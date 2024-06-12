#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"

 int ac=8, dc=3;
struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

struct proc *queue[5][NPROC];
int q_tail[5] = {-1, -1, -1, -1, -1};

static struct proc *initproc;

int nextpid = 1;
int nexttgid = 1; 
extern void forkret(void);
extern void trapret(void);
static void wakeup1(void *chan);

void ticking(){
	for(struct proc *p=ptable.proc; p<&ptable.proc[NPROC]; ++p){
		if(p->state == RUNNING){
			p->rtime++;
		}
    if(p->state == SLEEPING){
			p->iotime++;
		}
	}
}

int add_proc_to_q(struct proc *p, int q_no)
{	
  // checking queue
	for(int i=0; i < q_tail[q_no]; i++)
	{
		if(p->pid == queue[q_no][i]->pid)
			return -1;
	}

	p->enter = ticks;
	p -> queue = q_no;
	q_tail[q_no]++;
	queue[q_no][q_tail[q_no]] = p;
	return 1;
}

int remove_proc_from_q(struct proc *p, int q_no)
{
	int proc_found = 0, rem = 0;
	for(int i=0; i <= q_tail[q_no]; i++)
	{
		if(queue[q_no][i] -> pid == p->pid)
		{
			rem = i;
			proc_found = 1;
			break;
		}
	}
	if(proc_found  == 0)
	{
		return -1;
	}
	for(int i = rem; i < q_tail[q_no]; i++)
	queue[q_no][i] = queue[q_no][i+1]; 
	q_tail[q_no] -= 1;
	return 1;
}

void change_q_flag(struct proc* p)
{
	acquire(&ptable.lock);
	p-> change_q = 1;
	release(&ptable.lock);
}

void incr_curr_ticks(struct proc *p)
{
	acquire(&ptable.lock);
	p->curr_ticks++;
	p->qticks[p->queue]++;
	release(&ptable.lock);
}

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

int
cpuid() {
  return mycpu()-cpus;
}

struct cpu*
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
}

struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  p = c->proc;
  popcli();
  return p;
}

static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
  p->tgid = nexttgid++; /* Define tgid for process(thread) */

  release(&ptable.lock);

  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
  p->ctime = ticks; 
	p->etime = 0;
	p->rtime = 0;
	p->iotime = 0;
	p->waitshh = -1282128;
  p->num_run = 0;
	p->priority = 50; // default
  	#ifdef MLFQ
		p->curr_ticks = 0;
		p->queue = 0;
		p->enter = 0;
		for(int i=0; i<5; i++)
			p->qticks[i] = 0;
	#endif
  return p;
}

void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");


  acquire(&ptable.lock);

  p->state = RUNNABLE;
  #ifdef MLFQ
  add_proc_to_q(p,0);
  #endif
  release(&ptable.lock);
}

int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();
  struct proc *p;

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->pgdir != curproc->pgdir)
        continue;

      p->sz = sz;
      switchuvm(p); 
  }
  release(&ptable.lock);

  switchuvm(curproc);
  return 0;
}

int
fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  if((np = allocproc()) == 0){
    return -1;
  }

  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;

  acquire(&ptable.lock);

  np->state = RUNNABLE;
  #ifdef MLFQ
  		add_proc_to_q(np, 0);
	#endif
  release(&ptable.lock);

  return pid;
}

void
exit(void)
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  acquire(&ptable.lock);

  wakeup1(curproc->parent);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  curproc->state = ZOMBIE;
  curproc->etime = ticks;
  curproc->waitshh=curproc->etime - curproc->ctime;
	cprintf("[Terminate] --> Total Time for pid [%d] is [%d]\n",curproc->pid, curproc->etime - curproc->ctime);
  sched();
  panic("zombie exit");
}

int
wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
  for(;;){
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != curproc && p->pgdir != curproc->pgdir)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){

        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        #ifdef MLFQ
					remove_proc_from_q(p, p->queue);
          p->queue=-1;
				#endif 
        p->pid = 0;
	p->tgid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
      }
    }

    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
    }

    sleep(curproc, &ptable.lock); 
  }
}


int
waitx(int *wtime, int *rtime)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
  for(;;){
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        *rtime = p->rtime ;
				*wtime = p->etime - p->ctime - p->rtime - p->iotime;
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        #ifdef MLFQ
					remove_proc_from_q(p, p->queue);
          p->queue=-1;
				#endif 
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
      }
    }

    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
    }

    sleep(curproc, &ptable.lock);
  }
}

void
scheduler(void)
{
  struct cpu *c = mycpu();
  c->proc = 0;
  
  for(;;){
    sti();


    acquire(&ptable.lock);
    
        #ifdef RR
      struct proc *p;
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        if(p->state != RUNNABLE)
          continue;

        c->proc = p;

		switchuvm(p);
        p->num_run++;
        p->state = RUNNING;

        swtch(&(c->scheduler), p->context);
        switchkvm();

        c->proc = 0;
      }
    #endif
        #ifdef FCFS

    struct proc *p;
    struct proc *to_run_proc = 0;
    
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
		{
			if (p->state != RUNNABLE)
				continue;

			if (to_run_proc == 0)
				to_run_proc = p;
			else if (p->ctime < to_run_proc->ctime)
				to_run_proc = p;
		}
    if (to_run_proc != 0 && to_run_proc->state == RUNNABLE)
		{

			p = to_run_proc;
			c->proc = p;
			switchuvm(p);
			p->num_run++;
			p->state = RUNNING;

			swtch(&(c->scheduler), p->context);
			switchkvm();

			c->proc = 0;
		}
		
    #endif
		#ifdef MLFQ

      for(int i=1; i < 5; i++)
			{
				for(int j=0; j <= q_tail[i]; j++)
				{
					struct proc *p = queue[i][j];
          				int age = ticks - p->enter;
					if(age > 30)
					{
						remove_proc_from_q(p, i);
						add_proc_to_q(p, i-1);
					}
				}
			}
			
			
			struct proc *p = 0;
			
			for(int i=0; i < 5; i++)
			{
				if(q_tail[i] >=0)
				{
					
					p = queue[i][0];
					remove_proc_from_q(p, i);
					break;
				}
			}

			if(p!=0 && p->state==RUNNABLE)
			{
				p->num_run++;
				c->proc = p;
				switchuvm(p);
				p->state = RUNNING;
				swtch(&c->scheduler, p->context);
				switchkvm();
				c->proc = 0;

				if(p!=0 && p->state == RUNNABLE)
				{
					if(p->change_q == 1)
					{
						p->change_q = 0;
						p->curr_ticks = 0;
						if(p->queue != 4){
						p->queue+=1;
            					}
					}
					else p->curr_ticks = 0;
					add_proc_to_q(p,p->queue);
				}
					
				
			}

    #endif
    release(&ptable.lock);
  }
}

void
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
}

void
yield(void)
{
  acquire(&ptable.lock); 
  myproc()->state = RUNNABLE;
  sched();
  release(&ptable.lock);
}

void
forkret(void)
{
  static int first = 1;
  release(&ptable.lock);

  if (first) {

    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }


}

void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");

  if(lk != &ptable.lock){  
    acquire(&ptable.lock); 
    release(lk);
  }

  p->chan = chan;
  p->state = SLEEPING;

  sched();

  p->chan = 0;

  if(lk != &ptable.lock){ 
    release(&ptable.lock);
    acquire(lk);
  }
}

static void
wakeup1(void *chan)
{
  struct proc *p;	

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == SLEEPING && p->chan == chan){
      p->state = RUNNABLE;
      #ifdef MLFQ
		p->curr_ticks = 0;
		add_proc_to_q(p, p->queue);
	#endif
    }
  }
}


void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      if(p->state == SLEEPING){
        p->state = RUNNABLE;
        #ifdef MLFQ
          p->curr_ticks = 0;
          add_proc_to_q(p, p->queue);
        #endif
      }
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
  };
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}


int
getps(void) 
{
	struct proc *p;
	int ret = -1;
  acquire(&ptable.lock);
  #ifndef MLFQ
  cprintf("PID   State \tr_time\tw_time\ts_time\n");
  #endif
  #ifdef MLFQ
  cprintf("PID   State \tr_time\tw_time\ts_time\tcur_q\t q0\tq1\tq2\tq3\tq4\n");
  #endif
  for (p = ptable.proc; p < &ptable.proc[NPROC]; ++p)
  {
    if(p->pid >= 3) {
    #ifndef MLFQ
    if (p->state == SLEEPING)
    {
      cprintf("%d   SLEEPING \t %d \t %d \t %d\n",  p->pid, p->rtime, ticks - p->ctime - p->rtime -p->iotime,p->iotime);
    }
    else if (p->state == RUNNING)
    {
      cprintf("%d   RUNNING  \t %d \t %d \t %d\n",  p->pid, p->rtime, ticks - p->ctime - p->rtime -p->iotime,p->iotime);
    }
    else if (p->state == RUNNABLE)
    {
      cprintf("%d   RUNNABLE \t %d \t %d \t %d\n",  p->pid, p->rtime, ticks - p->ctime - p->rtime -p->iotime,p->iotime);
    }
    else if (p->state == ZOMBIE)
    {
      cprintf("%d    ZOMBIE \t %d \t %d \t %d\n",  p->pid, p->rtime, p->etime - p->ctime - p->rtime -p->iotime,p->iotime);
    }
    #endif

    #ifdef MLFQ
   if (p->state == SLEEPING)
    {
      cprintf("%d   SLEEPING \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d\n",  p->pid,  p->rtime, ticks - p->ctime - p->rtime -p->iotime,p->iotime,p->queue,p->qticks[0],p->qticks[1],p->qticks[2],p->qticks[3],p->qticks[4]);
    }
    else if (p->state == RUNNING)
    {
      cprintf("%d   RUNNING  \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d\n",  p->pid,  p->rtime, ticks - p->ctime - p->rtime -p->iotime,p->iotime,p->queue,p->qticks[0],p->qticks[1],p->qticks[2],p->qticks[3],p->qticks[4]);
    }
    else if (p->state == RUNNABLE)
    {
      cprintf("%d   RUNNABLE \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d\n",  p->pid,  p->rtime, ticks - p->ctime - p->rtime -p->iotime,p->iotime,p->queue,p->qticks[0],p->qticks[1],p->qticks[2],p->qticks[3],p->qticks[4]);
    }
    else if (p->state == ZOMBIE)
    {
      cprintf("%d    ZOMBIE \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d\n",  p->pid,  p->rtime, p->etime - p->ctime - p->rtime -p->iotime,p->iotime,-1,p->qticks[0],p->qticks[1],p->qticks[2],p->qticks[3],p->qticks[4]);
    }
    #endif

  }
  }
  release(&ptable.lock);
	return ret;
}

int printinfo(struct proc *np) {
  struct proc *p = np;
  cprintf("PID : %d\n", p->tgid);
  cprintf("TID : %d\n",p->pid);
  cprintf("Page Directory Address: %p\n", p->pgdir);
  cprintf("Stack Pointer Value: %p\n", p->tf->esp);
  cprintf("Start Function Address: %p\n", p->function);
  cprintf("Memory Size: %d bytes\n\n", p->sz);
  return 0;
}

/* Clone, Join system call*/
int
clone(void (*function)(void*), void* arg, void* stack)
{
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  // <Code for new thread>

  // Copy process data to new process with page table address
  np->sz = curproc->sz;
  np->pgdir = curproc->pgdir;
  np->parent = curproc;
  *np->tf = *curproc->tf;
  np->tgid = curproc->tgid; /* Same tgid with parent => thread */

  np->function = function;

  // Stack pointer is at the bottom, bring it up; push return
  // address and arg
  *(uint*)(stack + PGSIZE - 1 * sizeof(void *)) = (uint)arg;
  *(uint*)(stack + PGSIZE - 2 * sizeof(void *)) = 0xFFFFFFFF;

  // Set esp (stack pointer register) and ebp (stack base register)
  // eip (instruction pointer register)
  np->tf->esp = (uint)stack + PGSIZE - 2 * sizeof(void*);
  np->tf->ebp = np->tf->esp;
  np->tf->eip = (uint) function;

  // Set thread stack
  np->tstack = stack;

  // </Code for new thread>

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;

  acquire(&ptable.lock);

  np->state = RUNNABLE;

  #ifdef MLFQ
  		add_proc_to_q(np, 0);
  #endif

  release(&ptable.lock);

  printinfo(np);

  return pid;
}

int
join(int tid, void** stack)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != curproc || p->pgdir != curproc->pgdir || p->pid != tid)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        *stack = p->tstack;
        p->tstack = 0;
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;

        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}


int sys_threadinfo(void)
{
	struct proc *p = myproc();
	cprintf("PID : %d\n", p->tgid);
	cprintf("TID : %d\n",p->pid);
	cprintf("Page Directory Address : %p\n", p->pgdir);
	cprintf("Stack Pointer Value : %p\n", p->tf->esp);
	cprintf("Statr Function Address : %p\n", p->function);
	cprintf("Memory Size : %d bytes\n\n", p->sz);
	return 0;
}
