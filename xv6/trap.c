#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#include "traps.h"
#include "spinlock.h"

int q_ticks_max[5] = {2, 4, 8, 16, 32};
struct gatedesc idt[256];
extern uint vectors[]; 
struct spinlock tickslock;
uint ticks;

int wakeup_ps = 0; // FCFS
const int TICKS_LIMIT = 500; //FCFS

void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
}

void
idtinit(void)
{
  lidt(idt, sizeof(idt));
}

void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
      ticking();
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:

    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_COM1:
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
    break;

  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }

    cprintf("pid %d %s: trap %d err %d on cpu %d "
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
  }

  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
 
 #ifdef RR 
  if(myproc() && myproc()->state == RUNNING &&
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
 #endif
    
    
 if(myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
  {
    #ifdef FCFS // hyunwoo's FCFS
    if( myproc()->ticks > TICKS_LIMIT || wakeup_ps > 0 ){
      	if(myproc()->ticks > TICKS_LIMIT) {
      		kill(myproc()->pid);
      		}
      	else{
      		wakeup_ps = 0;
    		yield();
    		}
    	}
    #endif
    #ifdef MLFQ // joo seo mlfq
			if(myproc()->curr_ticks >= q_ticks_max[myproc()->queue])
			{
				change_q_flag(myproc());
				yield(); 
				
			}

			else 		
			{
				incr_curr_ticks(myproc());

			}	
    #endif
    }

  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
