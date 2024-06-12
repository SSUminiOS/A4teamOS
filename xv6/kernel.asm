
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc f0 7d 11 80       	mov    $0x80117df0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 60 30 10 80       	mov    $0x80103060,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 74 b5 10 80       	mov    $0x8010b574,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 40 80 10 80       	push   $0x80108040
80100051:	68 40 b5 10 80       	push   $0x8010b540
80100056:	e8 a5 50 00 00       	call   80105100 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 3c fc 10 80       	mov    $0x8010fc3c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 8c fc 10 80 3c 	movl   $0x8010fc3c,0x8010fc8c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 90 fc 10 80 3c 	movl   $0x8010fc3c,0x8010fc90
80100074:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 3c fc 10 80 	movl   $0x8010fc3c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 47 80 10 80       	push   $0x80108047
80100097:	50                   	push   %eax
80100098:	e8 33 4f 00 00       	call   80104fd0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 90 fc 10 80       	mov    0x8010fc90,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 90 fc 10 80    	mov    %ebx,0x8010fc90
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb e0 f9 10 80    	cmp    $0x8010f9e0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 40 b5 10 80       	push   $0x8010b540
801000e4:	e8 e7 51 00 00       	call   801052d0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 90 fc 10 80    	mov    0x8010fc90,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 3c fc 10 80    	cmp    $0x8010fc3c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 3c fc 10 80    	cmp    $0x8010fc3c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 8c fc 10 80    	mov    0x8010fc8c,%ebx
80100126:	81 fb 3c fc 10 80    	cmp    $0x8010fc3c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 3c fc 10 80    	cmp    $0x8010fc3c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 40 b5 10 80       	push   $0x8010b540
80100162:	e8 09 51 00 00       	call   80105270 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 9e 4e 00 00       	call   80105010 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 4f 21 00 00       	call   801022e0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 4e 80 10 80       	push   $0x8010804e
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 ed 4e 00 00       	call   801050b0 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
  iderw(b);
801001d4:	e9 07 21 00 00       	jmp    801022e0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 5f 80 10 80       	push   $0x8010805f
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 ac 4e 00 00       	call   801050b0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 5c 4e 00 00       	call   80105070 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 40 b5 10 80 	movl   $0x8010b540,(%esp)
8010021b:	e8 b0 50 00 00       	call   801052d0 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 90 fc 10 80       	mov    0x8010fc90,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 3c fc 10 80 	movl   $0x8010fc3c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 90 fc 10 80       	mov    0x8010fc90,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 90 fc 10 80    	mov    %ebx,0x8010fc90
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 40 b5 10 80 	movl   $0x8010b540,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 ff 4f 00 00       	jmp    80105270 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 66 80 10 80       	push   $0x80108066
80100279:	e8 02 01 00 00       	call   80100380 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 c7 15 00 00       	call   80101860 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
801002a0:	e8 2b 50 00 00       	call   801052d0 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 20 ff 10 80       	mov    0x8010ff20,%eax
801002b5:	3b 05 24 ff 10 80    	cmp    0x8010ff24,%eax
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 40 ff 10 80       	push   $0x8010ff40
801002c8:	68 20 ff 10 80       	push   $0x8010ff20
801002cd:	e8 7e 44 00 00       	call   80104750 <sleep>
    while(input.r == input.w){
801002d2:	a1 20 ff 10 80       	mov    0x8010ff20,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 24 ff 10 80    	cmp    0x8010ff24,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 39 39 00 00       	call   80103c20 <myproc>
801002e7:	8b 48 2c             	mov    0x2c(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 40 ff 10 80       	push   $0x8010ff40
801002f6:	e8 75 4f 00 00       	call   80105270 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 7c 14 00 00       	call   80101780 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret    
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 20 ff 10 80    	mov    %edx,0x8010ff20
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a a0 fe 10 80 	movsbl -0x7fef0160(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 40 ff 10 80       	push   $0x8010ff40
8010034c:	e8 1f 4f 00 00       	call   80105270 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 26 14 00 00       	call   80101780 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret    
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 20 ff 10 80       	mov    %eax,0x8010ff20
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli    
  cons.locking = 0;
80100389:	c7 05 74 ff 10 80 00 	movl   $0x0,0x8010ff74
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 52 25 00 00       	call   801028f0 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 6d 80 10 80       	push   $0x8010806d
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 20 87 10 80 	movl   $0x80108720,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 53 4d 00 00       	call   80105120 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 81 80 10 80       	push   $0x80108081
801003dd:	e8 be 02 00 00       	call   801006a0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 78 ff 10 80 01 	movl   $0x1,0x8010ff78
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 ea 00 00 00    	je     80100500 <consputc.part.0+0x100>
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 41 67 00 00       	call   80106b60 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100441:	c1 e1 08             	shl    $0x8,%ecx
80100444:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100445:	89 f2                	mov    %esi,%edx
80100447:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100448:	0f b6 c0             	movzbl %al,%eax
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	0f 84 92 00 00 00    	je     801004e8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100456:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045c:	74 72                	je     801004d0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010045e:	0f b6 db             	movzbl %bl,%ebx
80100461:	8d 70 01             	lea    0x1(%eax),%esi
80100464:	80 cf 07             	or     $0x7,%bh
80100467:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
8010046e:	80 
  if(pos < 0 || pos > 25*80)
8010046f:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100475:	0f 8f fb 00 00 00    	jg     80100576 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010047b:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100481:	0f 8f a9 00 00 00    	jg     80100530 <consputc.part.0+0x130>
  outb(CRTPORT+1, pos>>8);
80100487:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
80100489:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100490:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100493:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100496:	bb d4 03 00 00       	mov    $0x3d4,%ebx
8010049b:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a0:	89 da                	mov    %ebx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004a8:	89 f8                	mov    %edi,%eax
801004aa:	89 ca                	mov    %ecx,%edx
801004ac:	ee                   	out    %al,(%dx)
801004ad:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004b9:	89 ca                	mov    %ecx,%edx
801004bb:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004bc:	b8 20 07 00 00       	mov    $0x720,%eax
801004c1:	66 89 06             	mov    %ax,(%esi)
}
801004c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c7:	5b                   	pop    %ebx
801004c8:	5e                   	pop    %esi
801004c9:	5f                   	pop    %edi
801004ca:	5d                   	pop    %ebp
801004cb:	c3                   	ret    
801004cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(pos > 0) --pos;
801004d0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004d3:	85 c0                	test   %eax,%eax
801004d5:	75 98                	jne    8010046f <consputc.part.0+0x6f>
801004d7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004db:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004e0:	31 ff                	xor    %edi,%edi
801004e2:	eb b2                	jmp    80100496 <consputc.part.0+0x96>
801004e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004e8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004ed:	f7 e2                	mul    %edx
801004ef:	c1 ea 06             	shr    $0x6,%edx
801004f2:	8d 04 92             	lea    (%edx,%edx,4),%eax
801004f5:	c1 e0 04             	shl    $0x4,%eax
801004f8:	8d 70 50             	lea    0x50(%eax),%esi
801004fb:	e9 6f ff ff ff       	jmp    8010046f <consputc.part.0+0x6f>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100500:	83 ec 0c             	sub    $0xc,%esp
80100503:	6a 08                	push   $0x8
80100505:	e8 56 66 00 00       	call   80106b60 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 4a 66 00 00       	call   80106b60 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 3e 66 00 00       	call   80106b60 <uartputc>
80100522:	83 c4 10             	add    $0x10,%esp
80100525:	e9 f8 fe ff ff       	jmp    80100422 <consputc.part.0+0x22>
8010052a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100530:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100533:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100536:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010053d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100542:	68 60 0e 00 00       	push   $0xe60
80100547:	68 a0 80 0b 80       	push   $0x800b80a0
8010054c:	68 00 80 0b 80       	push   $0x800b8000
80100551:	e8 da 4e 00 00       	call   80105430 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 25 4e 00 00       	call   80105390 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 85 80 10 80       	push   $0x80108085
8010057e:	e8 fd fd ff ff       	call   80100380 <panic>
80100583:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010058a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100590 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100590:	55                   	push   %ebp
80100591:	89 e5                	mov    %esp,%ebp
80100593:	57                   	push   %edi
80100594:	56                   	push   %esi
80100595:	53                   	push   %ebx
80100596:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100599:	ff 75 08             	push   0x8(%ebp)
{
8010059c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010059f:	e8 bc 12 00 00       	call   80101860 <iunlock>
  acquire(&cons.lock);
801005a4:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
801005ab:	e8 20 4d 00 00       	call   801052d0 <acquire>
  for(i = 0; i < n; i++)
801005b0:	83 c4 10             	add    $0x10,%esp
801005b3:	85 f6                	test   %esi,%esi
801005b5:	7e 25                	jle    801005dc <consolewrite+0x4c>
801005b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005ba:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005bd:	8b 15 78 ff 10 80    	mov    0x8010ff78,%edx
    consputc(buf[i] & 0xff);
801005c3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005c6:	85 d2                	test   %edx,%edx
801005c8:	74 06                	je     801005d0 <consolewrite+0x40>
  asm volatile("cli");
801005ca:	fa                   	cli    
    for(;;)
801005cb:	eb fe                	jmp    801005cb <consolewrite+0x3b>
801005cd:	8d 76 00             	lea    0x0(%esi),%esi
801005d0:	e8 2b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005d5:	83 c3 01             	add    $0x1,%ebx
801005d8:	39 df                	cmp    %ebx,%edi
801005da:	75 e1                	jne    801005bd <consolewrite+0x2d>
  release(&cons.lock);
801005dc:	83 ec 0c             	sub    $0xc,%esp
801005df:	68 40 ff 10 80       	push   $0x8010ff40
801005e4:	e8 87 4c 00 00       	call   80105270 <release>
  ilock(ip);
801005e9:	58                   	pop    %eax
801005ea:	ff 75 08             	push   0x8(%ebp)
801005ed:	e8 8e 11 00 00       	call   80101780 <ilock>

  return n;
}
801005f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005f5:	89 f0                	mov    %esi,%eax
801005f7:	5b                   	pop    %ebx
801005f8:	5e                   	pop    %esi
801005f9:	5f                   	pop    %edi
801005fa:	5d                   	pop    %ebp
801005fb:	c3                   	ret    
801005fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100600 <printint>:
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 2c             	sub    $0x2c,%esp
80100609:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010060c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if(sign && (sign = xx < 0))
8010060f:	85 c9                	test   %ecx,%ecx
80100611:	74 04                	je     80100617 <printint+0x17>
80100613:	85 c0                	test   %eax,%eax
80100615:	78 6d                	js     80100684 <printint+0x84>
    x = xx;
80100617:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
8010061e:	89 c1                	mov    %eax,%ecx
  i = 0;
80100620:	31 db                	xor    %ebx,%ebx
80100622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buf[i++] = digits[x % base];
80100628:	89 c8                	mov    %ecx,%eax
8010062a:	31 d2                	xor    %edx,%edx
8010062c:	89 de                	mov    %ebx,%esi
8010062e:	89 cf                	mov    %ecx,%edi
80100630:	f7 75 d4             	divl   -0x2c(%ebp)
80100633:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100636:	0f b6 92 b0 80 10 80 	movzbl -0x7fef7f50(%edx),%edx
  }while((x /= base) != 0);
8010063d:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010063f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100643:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
80100646:	73 e0                	jae    80100628 <printint+0x28>
  if(sign)
80100648:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010064b:	85 c9                	test   %ecx,%ecx
8010064d:	74 0c                	je     8010065b <printint+0x5b>
    buf[i++] = '-';
8010064f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100654:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
80100656:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
8010065b:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
8010065f:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100662:	8b 15 78 ff 10 80    	mov    0x8010ff78,%edx
80100668:	85 d2                	test   %edx,%edx
8010066a:	74 04                	je     80100670 <printint+0x70>
8010066c:	fa                   	cli    
    for(;;)
8010066d:	eb fe                	jmp    8010066d <printint+0x6d>
8010066f:	90                   	nop
80100670:	e8 8b fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
80100675:	8d 45 d7             	lea    -0x29(%ebp),%eax
80100678:	39 c3                	cmp    %eax,%ebx
8010067a:	74 0e                	je     8010068a <printint+0x8a>
    consputc(buf[i]);
8010067c:	0f be 03             	movsbl (%ebx),%eax
8010067f:	83 eb 01             	sub    $0x1,%ebx
80100682:	eb de                	jmp    80100662 <printint+0x62>
    x = -xx;
80100684:	f7 d8                	neg    %eax
80100686:	89 c1                	mov    %eax,%ecx
80100688:	eb 96                	jmp    80100620 <printint+0x20>
}
8010068a:	83 c4 2c             	add    $0x2c,%esp
8010068d:	5b                   	pop    %ebx
8010068e:	5e                   	pop    %esi
8010068f:	5f                   	pop    %edi
80100690:	5d                   	pop    %ebp
80100691:	c3                   	ret    
80100692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801006a0 <cprintf>:
{
801006a0:	55                   	push   %ebp
801006a1:	89 e5                	mov    %esp,%ebp
801006a3:	57                   	push   %edi
801006a4:	56                   	push   %esi
801006a5:	53                   	push   %ebx
801006a6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006a9:	a1 74 ff 10 80       	mov    0x8010ff74,%eax
801006ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
801006b1:	85 c0                	test   %eax,%eax
801006b3:	0f 85 27 01 00 00    	jne    801007e0 <cprintf+0x140>
  if (fmt == 0)
801006b9:	8b 75 08             	mov    0x8(%ebp),%esi
801006bc:	85 f6                	test   %esi,%esi
801006be:	0f 84 ac 01 00 00    	je     80100870 <cprintf+0x1d0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c4:	0f b6 06             	movzbl (%esi),%eax
  argp = (uint*)(void*)(&fmt + 1);
801006c7:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006ca:	31 db                	xor    %ebx,%ebx
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 56                	je     80100726 <cprintf+0x86>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	0f 85 cf 00 00 00    	jne    801007a8 <cprintf+0x108>
    c = fmt[++i] & 0xff;
801006d9:	83 c3 01             	add    $0x1,%ebx
801006dc:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
801006e0:	85 d2                	test   %edx,%edx
801006e2:	74 42                	je     80100726 <cprintf+0x86>
    switch(c){
801006e4:	83 fa 70             	cmp    $0x70,%edx
801006e7:	0f 84 90 00 00 00    	je     8010077d <cprintf+0xdd>
801006ed:	7f 51                	jg     80100740 <cprintf+0xa0>
801006ef:	83 fa 25             	cmp    $0x25,%edx
801006f2:	0f 84 c0 00 00 00    	je     801007b8 <cprintf+0x118>
801006f8:	83 fa 64             	cmp    $0x64,%edx
801006fb:	0f 85 f4 00 00 00    	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 10, 1);
80100701:	8d 47 04             	lea    0x4(%edi),%eax
80100704:	b9 01 00 00 00       	mov    $0x1,%ecx
80100709:	ba 0a 00 00 00       	mov    $0xa,%edx
8010070e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100711:	8b 07                	mov    (%edi),%eax
80100713:	e8 e8 fe ff ff       	call   80100600 <printint>
80100718:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010071b:	83 c3 01             	add    $0x1,%ebx
8010071e:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100722:	85 c0                	test   %eax,%eax
80100724:	75 aa                	jne    801006d0 <cprintf+0x30>
  if(locking)
80100726:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100729:	85 c0                	test   %eax,%eax
8010072b:	0f 85 22 01 00 00    	jne    80100853 <cprintf+0x1b3>
}
80100731:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100734:	5b                   	pop    %ebx
80100735:	5e                   	pop    %esi
80100736:	5f                   	pop    %edi
80100737:	5d                   	pop    %ebp
80100738:	c3                   	ret    
80100739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100740:	83 fa 73             	cmp    $0x73,%edx
80100743:	75 33                	jne    80100778 <cprintf+0xd8>
      if((s = (char*)*argp++) == 0)
80100745:	8d 47 04             	lea    0x4(%edi),%eax
80100748:	8b 3f                	mov    (%edi),%edi
8010074a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010074d:	85 ff                	test   %edi,%edi
8010074f:	0f 84 e3 00 00 00    	je     80100838 <cprintf+0x198>
      for(; *s; s++)
80100755:	0f be 07             	movsbl (%edi),%eax
80100758:	84 c0                	test   %al,%al
8010075a:	0f 84 08 01 00 00    	je     80100868 <cprintf+0x1c8>
  if(panicked){
80100760:	8b 15 78 ff 10 80    	mov    0x8010ff78,%edx
80100766:	85 d2                	test   %edx,%edx
80100768:	0f 84 b2 00 00 00    	je     80100820 <cprintf+0x180>
8010076e:	fa                   	cli    
    for(;;)
8010076f:	eb fe                	jmp    8010076f <cprintf+0xcf>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100778:	83 fa 78             	cmp    $0x78,%edx
8010077b:	75 78                	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 16, 0);
8010077d:	8d 47 04             	lea    0x4(%edi),%eax
80100780:	31 c9                	xor    %ecx,%ecx
80100782:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100787:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
8010078a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010078d:	8b 07                	mov    (%edi),%eax
8010078f:	e8 6c fe ff ff       	call   80100600 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100794:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
80100798:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010079b:	85 c0                	test   %eax,%eax
8010079d:	0f 85 2d ff ff ff    	jne    801006d0 <cprintf+0x30>
801007a3:	eb 81                	jmp    80100726 <cprintf+0x86>
801007a5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007a8:	8b 0d 78 ff 10 80    	mov    0x8010ff78,%ecx
801007ae:	85 c9                	test   %ecx,%ecx
801007b0:	74 14                	je     801007c6 <cprintf+0x126>
801007b2:	fa                   	cli    
    for(;;)
801007b3:	eb fe                	jmp    801007b3 <cprintf+0x113>
801007b5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007b8:	a1 78 ff 10 80       	mov    0x8010ff78,%eax
801007bd:	85 c0                	test   %eax,%eax
801007bf:	75 6c                	jne    8010082d <cprintf+0x18d>
801007c1:	b8 25 00 00 00       	mov    $0x25,%eax
801007c6:	e8 35 fc ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007cb:	83 c3 01             	add    $0x1,%ebx
801007ce:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
801007d2:	85 c0                	test   %eax,%eax
801007d4:	0f 85 f6 fe ff ff    	jne    801006d0 <cprintf+0x30>
801007da:	e9 47 ff ff ff       	jmp    80100726 <cprintf+0x86>
801007df:	90                   	nop
    acquire(&cons.lock);
801007e0:	83 ec 0c             	sub    $0xc,%esp
801007e3:	68 40 ff 10 80       	push   $0x8010ff40
801007e8:	e8 e3 4a 00 00       	call   801052d0 <acquire>
801007ed:	83 c4 10             	add    $0x10,%esp
801007f0:	e9 c4 fe ff ff       	jmp    801006b9 <cprintf+0x19>
  if(panicked){
801007f5:	8b 0d 78 ff 10 80    	mov    0x8010ff78,%ecx
801007fb:	85 c9                	test   %ecx,%ecx
801007fd:	75 31                	jne    80100830 <cprintf+0x190>
801007ff:	b8 25 00 00 00       	mov    $0x25,%eax
80100804:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100807:	e8 f4 fb ff ff       	call   80100400 <consputc.part.0>
8010080c:	8b 15 78 ff 10 80    	mov    0x8010ff78,%edx
80100812:	85 d2                	test   %edx,%edx
80100814:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100817:	74 2e                	je     80100847 <cprintf+0x1a7>
80100819:	fa                   	cli    
    for(;;)
8010081a:	eb fe                	jmp    8010081a <cprintf+0x17a>
8010081c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100820:	e8 db fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
80100825:	83 c7 01             	add    $0x1,%edi
80100828:	e9 28 ff ff ff       	jmp    80100755 <cprintf+0xb5>
8010082d:	fa                   	cli    
    for(;;)
8010082e:	eb fe                	jmp    8010082e <cprintf+0x18e>
80100830:	fa                   	cli    
80100831:	eb fe                	jmp    80100831 <cprintf+0x191>
80100833:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100837:	90                   	nop
        s = "(null)";
80100838:	bf 98 80 10 80       	mov    $0x80108098,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 40 ff 10 80       	push   $0x8010ff40
8010085b:	e8 10 4a 00 00       	call   80105270 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 9f 80 10 80       	push   $0x8010809f
80100878:	e8 03 fb ff ff       	call   80100380 <panic>
8010087d:	8d 76 00             	lea    0x0(%esi),%esi

80100880 <consoleintr>:
{
80100880:	55                   	push   %ebp
80100881:	89 e5                	mov    %esp,%ebp
80100883:	57                   	push   %edi
80100884:	56                   	push   %esi
  int c, doprocdump = 0;
80100885:	31 f6                	xor    %esi,%esi
{
80100887:	53                   	push   %ebx
80100888:	83 ec 18             	sub    $0x18,%esp
8010088b:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
8010088e:	68 40 ff 10 80       	push   $0x8010ff40
80100893:	e8 38 4a 00 00       	call   801052d0 <acquire>
  while((c = getc()) >= 0){
80100898:	83 c4 10             	add    $0x10,%esp
8010089b:	eb 1a                	jmp    801008b7 <consoleintr+0x37>
8010089d:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
801008a0:	83 fb 08             	cmp    $0x8,%ebx
801008a3:	0f 84 d7 00 00 00    	je     80100980 <consoleintr+0x100>
801008a9:	83 fb 10             	cmp    $0x10,%ebx
801008ac:	0f 85 32 01 00 00    	jne    801009e4 <consoleintr+0x164>
801008b2:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
801008b7:	ff d7                	call   *%edi
801008b9:	89 c3                	mov    %eax,%ebx
801008bb:	85 c0                	test   %eax,%eax
801008bd:	0f 88 05 01 00 00    	js     801009c8 <consoleintr+0x148>
    switch(c){
801008c3:	83 fb 15             	cmp    $0x15,%ebx
801008c6:	74 78                	je     80100940 <consoleintr+0xc0>
801008c8:	7e d6                	jle    801008a0 <consoleintr+0x20>
801008ca:	83 fb 7f             	cmp    $0x7f,%ebx
801008cd:	0f 84 ad 00 00 00    	je     80100980 <consoleintr+0x100>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008d3:	a1 28 ff 10 80       	mov    0x8010ff28,%eax
801008d8:	89 c2                	mov    %eax,%edx
801008da:	2b 15 20 ff 10 80    	sub    0x8010ff20,%edx
801008e0:	83 fa 7f             	cmp    $0x7f,%edx
801008e3:	77 d2                	ja     801008b7 <consoleintr+0x37>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e5:	8d 48 01             	lea    0x1(%eax),%ecx
  if(panicked){
801008e8:	8b 15 78 ff 10 80    	mov    0x8010ff78,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
801008ee:	83 e0 7f             	and    $0x7f,%eax
801008f1:	89 0d 28 ff 10 80    	mov    %ecx,0x8010ff28
        c = (c == '\r') ? '\n' : c;
801008f7:	83 fb 0d             	cmp    $0xd,%ebx
801008fa:	0f 84 13 01 00 00    	je     80100a13 <consoleintr+0x193>
        input.buf[input.e++ % INPUT_BUF] = c;
80100900:	88 98 a0 fe 10 80    	mov    %bl,-0x7fef0160(%eax)
  if(panicked){
80100906:	85 d2                	test   %edx,%edx
80100908:	0f 85 10 01 00 00    	jne    80100a1e <consoleintr+0x19e>
8010090e:	89 d8                	mov    %ebx,%eax
80100910:	e8 eb fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100915:	83 fb 0a             	cmp    $0xa,%ebx
80100918:	0f 84 14 01 00 00    	je     80100a32 <consoleintr+0x1b2>
8010091e:	83 fb 04             	cmp    $0x4,%ebx
80100921:	0f 84 0b 01 00 00    	je     80100a32 <consoleintr+0x1b2>
80100927:	a1 20 ff 10 80       	mov    0x8010ff20,%eax
8010092c:	83 e8 80             	sub    $0xffffff80,%eax
8010092f:	39 05 28 ff 10 80    	cmp    %eax,0x8010ff28
80100935:	75 80                	jne    801008b7 <consoleintr+0x37>
80100937:	e9 fb 00 00 00       	jmp    80100a37 <consoleintr+0x1b7>
8010093c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
80100940:	a1 28 ff 10 80       	mov    0x8010ff28,%eax
80100945:	39 05 24 ff 10 80    	cmp    %eax,0x8010ff24
8010094b:	0f 84 66 ff ff ff    	je     801008b7 <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100951:	83 e8 01             	sub    $0x1,%eax
80100954:	89 c2                	mov    %eax,%edx
80100956:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100959:	80 ba a0 fe 10 80 0a 	cmpb   $0xa,-0x7fef0160(%edx)
80100960:	0f 84 51 ff ff ff    	je     801008b7 <consoleintr+0x37>
  if(panicked){
80100966:	8b 15 78 ff 10 80    	mov    0x8010ff78,%edx
        input.e--;
8010096c:	a3 28 ff 10 80       	mov    %eax,0x8010ff28
  if(panicked){
80100971:	85 d2                	test   %edx,%edx
80100973:	74 33                	je     801009a8 <consoleintr+0x128>
80100975:	fa                   	cli    
    for(;;)
80100976:	eb fe                	jmp    80100976 <consoleintr+0xf6>
80100978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010097f:	90                   	nop
      if(input.e != input.w){
80100980:	a1 28 ff 10 80       	mov    0x8010ff28,%eax
80100985:	3b 05 24 ff 10 80    	cmp    0x8010ff24,%eax
8010098b:	0f 84 26 ff ff ff    	je     801008b7 <consoleintr+0x37>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 28 ff 10 80       	mov    %eax,0x8010ff28
  if(panicked){
80100999:	a1 78 ff 10 80       	mov    0x8010ff78,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 56                	je     801009f8 <consoleintr+0x178>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x123>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
801009a8:	b8 00 01 00 00       	mov    $0x100,%eax
801009ad:	e8 4e fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
801009b2:	a1 28 ff 10 80       	mov    0x8010ff28,%eax
801009b7:	3b 05 24 ff 10 80    	cmp    0x8010ff24,%eax
801009bd:	75 92                	jne    80100951 <consoleintr+0xd1>
801009bf:	e9 f3 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
801009c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
801009c8:	83 ec 0c             	sub    $0xc,%esp
801009cb:	68 40 ff 10 80       	push   $0x8010ff40
801009d0:	e8 9b 48 00 00       	call   80105270 <release>
  if(doprocdump) {
801009d5:	83 c4 10             	add    $0x10,%esp
801009d8:	85 f6                	test   %esi,%esi
801009da:	75 2b                	jne    80100a07 <consoleintr+0x187>
}
801009dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009df:	5b                   	pop    %ebx
801009e0:	5e                   	pop    %esi
801009e1:	5f                   	pop    %edi
801009e2:	5d                   	pop    %ebp
801009e3:	c3                   	ret    
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009e4:	85 db                	test   %ebx,%ebx
801009e6:	0f 84 cb fe ff ff    	je     801008b7 <consoleintr+0x37>
801009ec:	e9 e2 fe ff ff       	jmp    801008d3 <consoleintr+0x53>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009f8:	b8 00 01 00 00       	mov    $0x100,%eax
801009fd:	e8 fe f9 ff ff       	call   80100400 <consputc.part.0>
80100a02:	e9 b0 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
}
80100a07:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a0a:	5b                   	pop    %ebx
80100a0b:	5e                   	pop    %esi
80100a0c:	5f                   	pop    %edi
80100a0d:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a0e:	e9 1d 3f 00 00       	jmp    80104930 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a13:	c6 80 a0 fe 10 80 0a 	movb   $0xa,-0x7fef0160(%eax)
  if(panicked){
80100a1a:	85 d2                	test   %edx,%edx
80100a1c:	74 0a                	je     80100a28 <consoleintr+0x1a8>
80100a1e:	fa                   	cli    
    for(;;)
80100a1f:	eb fe                	jmp    80100a1f <consoleintr+0x19f>
80100a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a28:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a2d:	e8 ce f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a32:	a1 28 ff 10 80       	mov    0x8010ff28,%eax
          wakeup(&input.r);
80100a37:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a3a:	a3 24 ff 10 80       	mov    %eax,0x8010ff24
          wakeup(&input.r);
80100a3f:	68 20 ff 10 80       	push   $0x8010ff20
80100a44:	e8 c7 3d 00 00       	call   80104810 <wakeup>
80100a49:	83 c4 10             	add    $0x10,%esp
80100a4c:	e9 66 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
80100a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a5f:	90                   	nop

80100a60 <consoleinit>:

void
consoleinit(void)
{
80100a60:	55                   	push   %ebp
80100a61:	89 e5                	mov    %esp,%ebp
80100a63:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a66:	68 a8 80 10 80       	push   $0x801080a8
80100a6b:	68 40 ff 10 80       	push   $0x8010ff40
80100a70:	e8 8b 46 00 00       	call   80105100 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a75:	58                   	pop    %eax
80100a76:	5a                   	pop    %edx
80100a77:	6a 00                	push   $0x0
80100a79:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a7b:	c7 05 2c 09 11 80 90 	movl   $0x80100590,0x8011092c
80100a82:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100a85:	c7 05 28 09 11 80 80 	movl   $0x80100280,0x80110928
80100a8c:	02 10 80 
  cons.locking = 1;
80100a8f:	c7 05 74 ff 10 80 01 	movl   $0x1,0x8010ff74
80100a96:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a99:	e8 e2 19 00 00       	call   80102480 <ioapicenable>
}
80100a9e:	83 c4 10             	add    $0x10,%esp
80100aa1:	c9                   	leave  
80100aa2:	c3                   	ret    
80100aa3:	66 90                	xchg   %ax,%ax
80100aa5:	66 90                	xchg   %ax,%ax
80100aa7:	66 90                	xchg   %ax,%ax
80100aa9:	66 90                	xchg   %ax,%ax
80100aab:	66 90                	xchg   %ax,%ax
80100aad:	66 90                	xchg   %ax,%ax
80100aaf:	90                   	nop

80100ab0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ab0:	55                   	push   %ebp
80100ab1:	89 e5                	mov    %esp,%ebp
80100ab3:	57                   	push   %edi
80100ab4:	56                   	push   %esi
80100ab5:	53                   	push   %ebx
80100ab6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100abc:	e8 5f 31 00 00       	call   80103c20 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 94 22 00 00       	call   80102d60 <begin_op>

  if((ip = namei(path)) == 0){
80100acc:	83 ec 0c             	sub    $0xc,%esp
80100acf:	ff 75 08             	push   0x8(%ebp)
80100ad2:	e8 c9 15 00 00       	call   801020a0 <namei>
80100ad7:	83 c4 10             	add    $0x10,%esp
80100ada:	85 c0                	test   %eax,%eax
80100adc:	0f 84 02 03 00 00    	je     80100de4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ae2:	83 ec 0c             	sub    $0xc,%esp
80100ae5:	89 c3                	mov    %eax,%ebx
80100ae7:	50                   	push   %eax
80100ae8:	e8 93 0c 00 00       	call   80101780 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100af3:	6a 34                	push   $0x34
80100af5:	6a 00                	push   $0x0
80100af7:	50                   	push   %eax
80100af8:	53                   	push   %ebx
80100af9:	e8 92 0f 00 00       	call   80101a90 <readi>
80100afe:	83 c4 20             	add    $0x20,%esp
80100b01:	83 f8 34             	cmp    $0x34,%eax
80100b04:	74 22                	je     80100b28 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100b06:	83 ec 0c             	sub    $0xc,%esp
80100b09:	53                   	push   %ebx
80100b0a:	e8 01 0f 00 00       	call   80101a10 <iunlockput>
    end_op();
80100b0f:	e8 bc 22 00 00       	call   80102dd0 <end_op>
80100b14:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100b17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100b1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b1f:	5b                   	pop    %ebx
80100b20:	5e                   	pop    %esi
80100b21:	5f                   	pop    %edi
80100b22:	5d                   	pop    %ebp
80100b23:	c3                   	ret    
80100b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100b28:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b2f:	45 4c 46 
80100b32:	75 d2                	jne    80100b06 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100b34:	e8 b7 71 00 00       	call   80107cf0 <setupkvm>
80100b39:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b3f:	85 c0                	test   %eax,%eax
80100b41:	74 c3                	je     80100b06 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b43:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b4a:	00 
80100b4b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b51:	0f 84 ac 02 00 00    	je     80100e03 <exec+0x353>
  sz = 0;
80100b57:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b5e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b61:	31 ff                	xor    %edi,%edi
80100b63:	e9 8e 00 00 00       	jmp    80100bf6 <exec+0x146>
80100b68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b6f:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80100b70:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b77:	75 6c                	jne    80100be5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b79:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b7f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b85:	0f 82 87 00 00 00    	jb     80100c12 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b8b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b91:	72 7f                	jb     80100c12 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b93:	83 ec 04             	sub    $0x4,%esp
80100b96:	50                   	push   %eax
80100b97:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100b9d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100ba3:	e8 68 6f 00 00       	call   80107b10 <allocuvm>
80100ba8:	83 c4 10             	add    $0x10,%esp
80100bab:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	74 5d                	je     80100c12 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100bb5:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bbb:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100bc0:	75 50                	jne    80100c12 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100bc2:	83 ec 0c             	sub    $0xc,%esp
80100bc5:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100bcb:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100bd1:	53                   	push   %ebx
80100bd2:	50                   	push   %eax
80100bd3:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bd9:	e8 42 6e 00 00       	call   80107a20 <loaduvm>
80100bde:	83 c4 20             	add    $0x20,%esp
80100be1:	85 c0                	test   %eax,%eax
80100be3:	78 2d                	js     80100c12 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100be5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bec:	83 c7 01             	add    $0x1,%edi
80100bef:	83 c6 20             	add    $0x20,%esi
80100bf2:	39 f8                	cmp    %edi,%eax
80100bf4:	7e 3a                	jle    80100c30 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bf6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bfc:	6a 20                	push   $0x20
80100bfe:	56                   	push   %esi
80100bff:	50                   	push   %eax
80100c00:	53                   	push   %ebx
80100c01:	e8 8a 0e 00 00       	call   80101a90 <readi>
80100c06:	83 c4 10             	add    $0x10,%esp
80100c09:	83 f8 20             	cmp    $0x20,%eax
80100c0c:	0f 84 5e ff ff ff    	je     80100b70 <exec+0xc0>
    freevm(pgdir);
80100c12:	83 ec 0c             	sub    $0xc,%esp
80100c15:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c1b:	e8 50 70 00 00       	call   80107c70 <freevm>
  if(ip){
80100c20:	83 c4 10             	add    $0x10,%esp
80100c23:	e9 de fe ff ff       	jmp    80100b06 <exec+0x56>
80100c28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c2f:	90                   	nop
  sz = PGROUNDUP(sz);
80100c30:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c36:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c3c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c42:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c48:	83 ec 0c             	sub    $0xc,%esp
80100c4b:	53                   	push   %ebx
80100c4c:	e8 bf 0d 00 00       	call   80101a10 <iunlockput>
  end_op();
80100c51:	e8 7a 21 00 00       	call   80102dd0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c56:	83 c4 0c             	add    $0xc,%esp
80100c59:	56                   	push   %esi
80100c5a:	57                   	push   %edi
80100c5b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c61:	57                   	push   %edi
80100c62:	e8 a9 6e 00 00       	call   80107b10 <allocuvm>
80100c67:	83 c4 10             	add    $0x10,%esp
80100c6a:	89 c6                	mov    %eax,%esi
80100c6c:	85 c0                	test   %eax,%eax
80100c6e:	0f 84 94 00 00 00    	je     80100d08 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c74:	83 ec 08             	sub    $0x8,%esp
80100c77:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c7d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c7f:	50                   	push   %eax
80100c80:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c81:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c83:	e8 08 71 00 00       	call   80107d90 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c88:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c8b:	83 c4 10             	add    $0x10,%esp
80100c8e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c94:	8b 00                	mov    (%eax),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	0f 84 8b 00 00 00    	je     80100d29 <exec+0x279>
80100c9e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100ca4:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100caa:	eb 23                	jmp    80100ccf <exec+0x21f>
80100cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100cb3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100cba:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100cbd:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100cc3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100cc6:	85 c0                	test   %eax,%eax
80100cc8:	74 59                	je     80100d23 <exec+0x273>
    if(argc >= MAXARG)
80100cca:	83 ff 20             	cmp    $0x20,%edi
80100ccd:	74 39                	je     80100d08 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ccf:	83 ec 0c             	sub    $0xc,%esp
80100cd2:	50                   	push   %eax
80100cd3:	e8 b8 48 00 00       	call   80105590 <strlen>
80100cd8:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cda:	58                   	pop    %eax
80100cdb:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cde:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce1:	ff 34 b8             	push   (%eax,%edi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ce4:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce7:	e8 a4 48 00 00       	call   80105590 <strlen>
80100cec:	83 c0 01             	add    $0x1,%eax
80100cef:	50                   	push   %eax
80100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf3:	ff 34 b8             	push   (%eax,%edi,4)
80100cf6:	53                   	push   %ebx
80100cf7:	56                   	push   %esi
80100cf8:	e8 63 72 00 00       	call   80107f60 <copyout>
80100cfd:	83 c4 20             	add    $0x20,%esp
80100d00:	85 c0                	test   %eax,%eax
80100d02:	79 ac                	jns    80100cb0 <exec+0x200>
80100d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d08:	83 ec 0c             	sub    $0xc,%esp
80100d0b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d11:	e8 5a 6f 00 00       	call   80107c70 <freevm>
80100d16:	83 c4 10             	add    $0x10,%esp
  return -1;
80100d19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d1e:	e9 f9 fd ff ff       	jmp    80100b1c <exec+0x6c>
80100d23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d29:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d30:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d32:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d39:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d3d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d3f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d42:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d48:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d4a:	50                   	push   %eax
80100d4b:	52                   	push   %edx
80100d4c:	53                   	push   %ebx
80100d4d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d53:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d5a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d5d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d63:	e8 f8 71 00 00       	call   80107f60 <copyout>
80100d68:	83 c4 10             	add    $0x10,%esp
80100d6b:	85 c0                	test   %eax,%eax
80100d6d:	78 99                	js     80100d08 <exec+0x258>
  for(last=s=path; *s; s++)
80100d6f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d72:	8b 55 08             	mov    0x8(%ebp),%edx
80100d75:	0f b6 00             	movzbl (%eax),%eax
80100d78:	84 c0                	test   %al,%al
80100d7a:	74 13                	je     80100d8f <exec+0x2df>
80100d7c:	89 d1                	mov    %edx,%ecx
80100d7e:	66 90                	xchg   %ax,%ax
      last = s+1;
80100d80:	83 c1 01             	add    $0x1,%ecx
80100d83:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d85:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100d88:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d8b:	84 c0                	test   %al,%al
80100d8d:	75 f1                	jne    80100d80 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d8f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d95:	83 ec 04             	sub    $0x4,%esp
80100d98:	6a 10                	push   $0x10
80100d9a:	89 f8                	mov    %edi,%eax
80100d9c:	52                   	push   %edx
80100d9d:	83 c0 74             	add    $0x74,%eax
80100da0:	50                   	push   %eax
80100da1:	e8 aa 47 00 00       	call   80105550 <safestrcpy>
  curproc->pgdir = pgdir;
80100da6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100dac:	89 f8                	mov    %edi,%eax
80100dae:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100db1:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100db3:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100db6:	89 c1                	mov    %eax,%ecx
80100db8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dbe:	8b 40 20             	mov    0x20(%eax),%eax
80100dc1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100dc4:	8b 41 20             	mov    0x20(%ecx),%eax
80100dc7:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100dca:	89 0c 24             	mov    %ecx,(%esp)
80100dcd:	e8 be 6a 00 00       	call   80107890 <switchuvm>
  freevm(oldpgdir);
80100dd2:	89 3c 24             	mov    %edi,(%esp)
80100dd5:	e8 96 6e 00 00       	call   80107c70 <freevm>
  return 0;
80100dda:	83 c4 10             	add    $0x10,%esp
80100ddd:	31 c0                	xor    %eax,%eax
80100ddf:	e9 38 fd ff ff       	jmp    80100b1c <exec+0x6c>
    end_op();
80100de4:	e8 e7 1f 00 00       	call   80102dd0 <end_op>
    cprintf("exec: fail\n");
80100de9:	83 ec 0c             	sub    $0xc,%esp
80100dec:	68 c1 80 10 80       	push   $0x801080c1
80100df1:	e8 aa f8 ff ff       	call   801006a0 <cprintf>
    return -1;
80100df6:	83 c4 10             	add    $0x10,%esp
80100df9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dfe:	e9 19 fd ff ff       	jmp    80100b1c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e03:	be 00 20 00 00       	mov    $0x2000,%esi
80100e08:	31 ff                	xor    %edi,%edi
80100e0a:	e9 39 fe ff ff       	jmp    80100c48 <exec+0x198>
80100e0f:	90                   	nop

80100e10 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e10:	55                   	push   %ebp
80100e11:	89 e5                	mov    %esp,%ebp
80100e13:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e16:	68 cd 80 10 80       	push   $0x801080cd
80100e1b:	68 80 ff 10 80       	push   $0x8010ff80
80100e20:	e8 db 42 00 00       	call   80105100 <initlock>
}
80100e25:	83 c4 10             	add    $0x10,%esp
80100e28:	c9                   	leave  
80100e29:	c3                   	ret    
80100e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e30 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e34:	bb b4 ff 10 80       	mov    $0x8010ffb4,%ebx
{
80100e39:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e3c:	68 80 ff 10 80       	push   $0x8010ff80
80100e41:	e8 8a 44 00 00       	call   801052d0 <acquire>
80100e46:	83 c4 10             	add    $0x10,%esp
80100e49:	eb 10                	jmp    80100e5b <filealloc+0x2b>
80100e4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e4f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e50:	83 c3 18             	add    $0x18,%ebx
80100e53:	81 fb 14 09 11 80    	cmp    $0x80110914,%ebx
80100e59:	74 25                	je     80100e80 <filealloc+0x50>
    if(f->ref == 0){
80100e5b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e5e:	85 c0                	test   %eax,%eax
80100e60:	75 ee                	jne    80100e50 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e62:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e65:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e6c:	68 80 ff 10 80       	push   $0x8010ff80
80100e71:	e8 fa 43 00 00       	call   80105270 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e76:	89 d8                	mov    %ebx,%eax
      return f;
80100e78:	83 c4 10             	add    $0x10,%esp
}
80100e7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e7e:	c9                   	leave  
80100e7f:	c3                   	ret    
  release(&ftable.lock);
80100e80:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e83:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e85:	68 80 ff 10 80       	push   $0x8010ff80
80100e8a:	e8 e1 43 00 00       	call   80105270 <release>
}
80100e8f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e91:	83 c4 10             	add    $0x10,%esp
}
80100e94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e97:	c9                   	leave  
80100e98:	c3                   	ret    
80100e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ea0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ea0:	55                   	push   %ebp
80100ea1:	89 e5                	mov    %esp,%ebp
80100ea3:	53                   	push   %ebx
80100ea4:	83 ec 10             	sub    $0x10,%esp
80100ea7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100eaa:	68 80 ff 10 80       	push   $0x8010ff80
80100eaf:	e8 1c 44 00 00       	call   801052d0 <acquire>
  if(f->ref < 1)
80100eb4:	8b 43 04             	mov    0x4(%ebx),%eax
80100eb7:	83 c4 10             	add    $0x10,%esp
80100eba:	85 c0                	test   %eax,%eax
80100ebc:	7e 1a                	jle    80100ed8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100ebe:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ec1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ec4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ec7:	68 80 ff 10 80       	push   $0x8010ff80
80100ecc:	e8 9f 43 00 00       	call   80105270 <release>
  return f;
}
80100ed1:	89 d8                	mov    %ebx,%eax
80100ed3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ed6:	c9                   	leave  
80100ed7:	c3                   	ret    
    panic("filedup");
80100ed8:	83 ec 0c             	sub    $0xc,%esp
80100edb:	68 d4 80 10 80       	push   $0x801080d4
80100ee0:	e8 9b f4 ff ff       	call   80100380 <panic>
80100ee5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ef0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	57                   	push   %edi
80100ef4:	56                   	push   %esi
80100ef5:	53                   	push   %ebx
80100ef6:	83 ec 28             	sub    $0x28,%esp
80100ef9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100efc:	68 80 ff 10 80       	push   $0x8010ff80
80100f01:	e8 ca 43 00 00       	call   801052d0 <acquire>
  if(f->ref < 1)
80100f06:	8b 53 04             	mov    0x4(%ebx),%edx
80100f09:	83 c4 10             	add    $0x10,%esp
80100f0c:	85 d2                	test   %edx,%edx
80100f0e:	0f 8e a5 00 00 00    	jle    80100fb9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f14:	83 ea 01             	sub    $0x1,%edx
80100f17:	89 53 04             	mov    %edx,0x4(%ebx)
80100f1a:	75 44                	jne    80100f60 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f1c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f20:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f23:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f25:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f2b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f2e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f31:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f34:	68 80 ff 10 80       	push   $0x8010ff80
  ff = *f;
80100f39:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f3c:	e8 2f 43 00 00       	call   80105270 <release>

  if(ff.type == FD_PIPE)
80100f41:	83 c4 10             	add    $0x10,%esp
80100f44:	83 ff 01             	cmp    $0x1,%edi
80100f47:	74 57                	je     80100fa0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f49:	83 ff 02             	cmp    $0x2,%edi
80100f4c:	74 2a                	je     80100f78 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f51:	5b                   	pop    %ebx
80100f52:	5e                   	pop    %esi
80100f53:	5f                   	pop    %edi
80100f54:	5d                   	pop    %ebp
80100f55:	c3                   	ret    
80100f56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f5d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f60:	c7 45 08 80 ff 10 80 	movl   $0x8010ff80,0x8(%ebp)
}
80100f67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f6a:	5b                   	pop    %ebx
80100f6b:	5e                   	pop    %esi
80100f6c:	5f                   	pop    %edi
80100f6d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f6e:	e9 fd 42 00 00       	jmp    80105270 <release>
80100f73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f77:	90                   	nop
    begin_op();
80100f78:	e8 e3 1d 00 00       	call   80102d60 <begin_op>
    iput(ff.ip);
80100f7d:	83 ec 0c             	sub    $0xc,%esp
80100f80:	ff 75 e0             	push   -0x20(%ebp)
80100f83:	e8 28 09 00 00       	call   801018b0 <iput>
    end_op();
80100f88:	83 c4 10             	add    $0x10,%esp
}
80100f8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f8e:	5b                   	pop    %ebx
80100f8f:	5e                   	pop    %esi
80100f90:	5f                   	pop    %edi
80100f91:	5d                   	pop    %ebp
    end_op();
80100f92:	e9 39 1e 00 00       	jmp    80102dd0 <end_op>
80100f97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100fa0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fa4:	83 ec 08             	sub    $0x8,%esp
80100fa7:	53                   	push   %ebx
80100fa8:	56                   	push   %esi
80100fa9:	e8 82 25 00 00       	call   80103530 <pipeclose>
80100fae:	83 c4 10             	add    $0x10,%esp
}
80100fb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb4:	5b                   	pop    %ebx
80100fb5:	5e                   	pop    %esi
80100fb6:	5f                   	pop    %edi
80100fb7:	5d                   	pop    %ebp
80100fb8:	c3                   	ret    
    panic("fileclose");
80100fb9:	83 ec 0c             	sub    $0xc,%esp
80100fbc:	68 dc 80 10 80       	push   $0x801080dc
80100fc1:	e8 ba f3 ff ff       	call   80100380 <panic>
80100fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fcd:	8d 76 00             	lea    0x0(%esi),%esi

80100fd0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fd0:	55                   	push   %ebp
80100fd1:	89 e5                	mov    %esp,%ebp
80100fd3:	53                   	push   %ebx
80100fd4:	83 ec 04             	sub    $0x4,%esp
80100fd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fda:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fdd:	75 31                	jne    80101010 <filestat+0x40>
    ilock(f->ip);
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	ff 73 10             	push   0x10(%ebx)
80100fe5:	e8 96 07 00 00       	call   80101780 <ilock>
    stati(f->ip, st);
80100fea:	58                   	pop    %eax
80100feb:	5a                   	pop    %edx
80100fec:	ff 75 0c             	push   0xc(%ebp)
80100fef:	ff 73 10             	push   0x10(%ebx)
80100ff2:	e8 69 0a 00 00       	call   80101a60 <stati>
    iunlock(f->ip);
80100ff7:	59                   	pop    %ecx
80100ff8:	ff 73 10             	push   0x10(%ebx)
80100ffb:	e8 60 08 00 00       	call   80101860 <iunlock>
    return 0;
  }
  return -1;
}
80101000:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101003:	83 c4 10             	add    $0x10,%esp
80101006:	31 c0                	xor    %eax,%eax
}
80101008:	c9                   	leave  
80101009:	c3                   	ret    
8010100a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101010:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101013:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101018:	c9                   	leave  
80101019:	c3                   	ret    
8010101a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101020 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	57                   	push   %edi
80101024:	56                   	push   %esi
80101025:	53                   	push   %ebx
80101026:	83 ec 0c             	sub    $0xc,%esp
80101029:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010102c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010102f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101032:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101036:	74 60                	je     80101098 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101038:	8b 03                	mov    (%ebx),%eax
8010103a:	83 f8 01             	cmp    $0x1,%eax
8010103d:	74 41                	je     80101080 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010103f:	83 f8 02             	cmp    $0x2,%eax
80101042:	75 5b                	jne    8010109f <fileread+0x7f>
    ilock(f->ip);
80101044:	83 ec 0c             	sub    $0xc,%esp
80101047:	ff 73 10             	push   0x10(%ebx)
8010104a:	e8 31 07 00 00       	call   80101780 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010104f:	57                   	push   %edi
80101050:	ff 73 14             	push   0x14(%ebx)
80101053:	56                   	push   %esi
80101054:	ff 73 10             	push   0x10(%ebx)
80101057:	e8 34 0a 00 00       	call   80101a90 <readi>
8010105c:	83 c4 20             	add    $0x20,%esp
8010105f:	89 c6                	mov    %eax,%esi
80101061:	85 c0                	test   %eax,%eax
80101063:	7e 03                	jle    80101068 <fileread+0x48>
      f->off += r;
80101065:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101068:	83 ec 0c             	sub    $0xc,%esp
8010106b:	ff 73 10             	push   0x10(%ebx)
8010106e:	e8 ed 07 00 00       	call   80101860 <iunlock>
    return r;
80101073:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101076:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101079:	89 f0                	mov    %esi,%eax
8010107b:	5b                   	pop    %ebx
8010107c:	5e                   	pop    %esi
8010107d:	5f                   	pop    %edi
8010107e:	5d                   	pop    %ebp
8010107f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101080:	8b 43 0c             	mov    0xc(%ebx),%eax
80101083:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101086:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101089:	5b                   	pop    %ebx
8010108a:	5e                   	pop    %esi
8010108b:	5f                   	pop    %edi
8010108c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010108d:	e9 3e 26 00 00       	jmp    801036d0 <piperead>
80101092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101098:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010109d:	eb d7                	jmp    80101076 <fileread+0x56>
  panic("fileread");
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	68 e6 80 10 80       	push   $0x801080e6
801010a7:	e8 d4 f2 ff ff       	call   80100380 <panic>
801010ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010b0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010b0:	55                   	push   %ebp
801010b1:	89 e5                	mov    %esp,%ebp
801010b3:	57                   	push   %edi
801010b4:	56                   	push   %esi
801010b5:	53                   	push   %ebx
801010b6:	83 ec 1c             	sub    $0x1c,%esp
801010b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801010bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801010bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010c2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010c5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801010c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010cc:	0f 84 bd 00 00 00    	je     8010118f <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
801010d2:	8b 03                	mov    (%ebx),%eax
801010d4:	83 f8 01             	cmp    $0x1,%eax
801010d7:	0f 84 bf 00 00 00    	je     8010119c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010dd:	83 f8 02             	cmp    $0x2,%eax
801010e0:	0f 85 c8 00 00 00    	jne    801011ae <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010e9:	31 f6                	xor    %esi,%esi
    while(i < n){
801010eb:	85 c0                	test   %eax,%eax
801010ed:	7f 30                	jg     8010111f <filewrite+0x6f>
801010ef:	e9 94 00 00 00       	jmp    80101188 <filewrite+0xd8>
801010f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010f8:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
801010fb:	83 ec 0c             	sub    $0xc,%esp
801010fe:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
80101101:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101104:	e8 57 07 00 00       	call   80101860 <iunlock>
      end_op();
80101109:	e8 c2 1c 00 00       	call   80102dd0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010110e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101111:	83 c4 10             	add    $0x10,%esp
80101114:	39 c7                	cmp    %eax,%edi
80101116:	75 5c                	jne    80101174 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101118:	01 fe                	add    %edi,%esi
    while(i < n){
8010111a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010111d:	7e 69                	jle    80101188 <filewrite+0xd8>
      int n1 = n - i;
8010111f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101122:	b8 00 06 00 00       	mov    $0x600,%eax
80101127:	29 f7                	sub    %esi,%edi
80101129:	39 c7                	cmp    %eax,%edi
8010112b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010112e:	e8 2d 1c 00 00       	call   80102d60 <begin_op>
      ilock(f->ip);
80101133:	83 ec 0c             	sub    $0xc,%esp
80101136:	ff 73 10             	push   0x10(%ebx)
80101139:	e8 42 06 00 00       	call   80101780 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010113e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101141:	57                   	push   %edi
80101142:	ff 73 14             	push   0x14(%ebx)
80101145:	01 f0                	add    %esi,%eax
80101147:	50                   	push   %eax
80101148:	ff 73 10             	push   0x10(%ebx)
8010114b:	e8 40 0a 00 00       	call   80101b90 <writei>
80101150:	83 c4 20             	add    $0x20,%esp
80101153:	85 c0                	test   %eax,%eax
80101155:	7f a1                	jg     801010f8 <filewrite+0x48>
      iunlock(f->ip);
80101157:	83 ec 0c             	sub    $0xc,%esp
8010115a:	ff 73 10             	push   0x10(%ebx)
8010115d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101160:	e8 fb 06 00 00       	call   80101860 <iunlock>
      end_op();
80101165:	e8 66 1c 00 00       	call   80102dd0 <end_op>
      if(r < 0)
8010116a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010116d:	83 c4 10             	add    $0x10,%esp
80101170:	85 c0                	test   %eax,%eax
80101172:	75 1b                	jne    8010118f <filewrite+0xdf>
        panic("short filewrite");
80101174:	83 ec 0c             	sub    $0xc,%esp
80101177:	68 ef 80 10 80       	push   $0x801080ef
8010117c:	e8 ff f1 ff ff       	call   80100380 <panic>
80101181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101188:	89 f0                	mov    %esi,%eax
8010118a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
8010118d:	74 05                	je     80101194 <filewrite+0xe4>
8010118f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101197:	5b                   	pop    %ebx
80101198:	5e                   	pop    %esi
80101199:	5f                   	pop    %edi
8010119a:	5d                   	pop    %ebp
8010119b:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
8010119c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010119f:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011a5:	5b                   	pop    %ebx
801011a6:	5e                   	pop    %esi
801011a7:	5f                   	pop    %edi
801011a8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011a9:	e9 22 24 00 00       	jmp    801035d0 <pipewrite>
  panic("filewrite");
801011ae:	83 ec 0c             	sub    $0xc,%esp
801011b1:	68 f5 80 10 80       	push   $0x801080f5
801011b6:	e8 c5 f1 ff ff       	call   80100380 <panic>
801011bb:	66 90                	xchg   %ax,%ax
801011bd:	66 90                	xchg   %ax,%ax
801011bf:	90                   	nop

801011c0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011c0:	55                   	push   %ebp
801011c1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011c3:	89 d0                	mov    %edx,%eax
801011c5:	c1 e8 0c             	shr    $0xc,%eax
801011c8:	03 05 ec 25 11 80    	add    0x801125ec,%eax
{
801011ce:	89 e5                	mov    %esp,%ebp
801011d0:	56                   	push   %esi
801011d1:	53                   	push   %ebx
801011d2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011d4:	83 ec 08             	sub    $0x8,%esp
801011d7:	50                   	push   %eax
801011d8:	51                   	push   %ecx
801011d9:	e8 f2 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011de:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011e0:	c1 fb 03             	sar    $0x3,%ebx
801011e3:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801011e6:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801011e8:	83 e1 07             	and    $0x7,%ecx
801011eb:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
801011f0:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
801011f6:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
801011f8:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
801011fd:	85 c1                	test   %eax,%ecx
801011ff:	74 23                	je     80101224 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101201:	f7 d0                	not    %eax
  log_write(bp);
80101203:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101206:	21 c8                	and    %ecx,%eax
80101208:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010120c:	56                   	push   %esi
8010120d:	e8 2e 1d 00 00       	call   80102f40 <log_write>
  brelse(bp);
80101212:	89 34 24             	mov    %esi,(%esp)
80101215:	e8 d6 ef ff ff       	call   801001f0 <brelse>
}
8010121a:	83 c4 10             	add    $0x10,%esp
8010121d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101220:	5b                   	pop    %ebx
80101221:	5e                   	pop    %esi
80101222:	5d                   	pop    %ebp
80101223:	c3                   	ret    
    panic("freeing free block");
80101224:	83 ec 0c             	sub    $0xc,%esp
80101227:	68 ff 80 10 80       	push   $0x801080ff
8010122c:	e8 4f f1 ff ff       	call   80100380 <panic>
80101231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010123f:	90                   	nop

80101240 <balloc>:
{
80101240:	55                   	push   %ebp
80101241:	89 e5                	mov    %esp,%ebp
80101243:	57                   	push   %edi
80101244:	56                   	push   %esi
80101245:	53                   	push   %ebx
80101246:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101249:	8b 0d d4 25 11 80    	mov    0x801125d4,%ecx
{
8010124f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101252:	85 c9                	test   %ecx,%ecx
80101254:	0f 84 87 00 00 00    	je     801012e1 <balloc+0xa1>
8010125a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101261:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101264:	83 ec 08             	sub    $0x8,%esp
80101267:	89 f0                	mov    %esi,%eax
80101269:	c1 f8 0c             	sar    $0xc,%eax
8010126c:	03 05 ec 25 11 80    	add    0x801125ec,%eax
80101272:	50                   	push   %eax
80101273:	ff 75 d8             	push   -0x28(%ebp)
80101276:	e8 55 ee ff ff       	call   801000d0 <bread>
8010127b:	83 c4 10             	add    $0x10,%esp
8010127e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101281:	a1 d4 25 11 80       	mov    0x801125d4,%eax
80101286:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101289:	31 c0                	xor    %eax,%eax
8010128b:	eb 2f                	jmp    801012bc <balloc+0x7c>
8010128d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101290:	89 c1                	mov    %eax,%ecx
80101292:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101297:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010129a:	83 e1 07             	and    $0x7,%ecx
8010129d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010129f:	89 c1                	mov    %eax,%ecx
801012a1:	c1 f9 03             	sar    $0x3,%ecx
801012a4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801012a9:	89 fa                	mov    %edi,%edx
801012ab:	85 df                	test   %ebx,%edi
801012ad:	74 41                	je     801012f0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012af:	83 c0 01             	add    $0x1,%eax
801012b2:	83 c6 01             	add    $0x1,%esi
801012b5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012ba:	74 05                	je     801012c1 <balloc+0x81>
801012bc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012bf:	77 cf                	ja     80101290 <balloc+0x50>
    brelse(bp);
801012c1:	83 ec 0c             	sub    $0xc,%esp
801012c4:	ff 75 e4             	push   -0x1c(%ebp)
801012c7:	e8 24 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012cc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012d3:	83 c4 10             	add    $0x10,%esp
801012d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012d9:	39 05 d4 25 11 80    	cmp    %eax,0x801125d4
801012df:	77 80                	ja     80101261 <balloc+0x21>
  panic("balloc: out of blocks");
801012e1:	83 ec 0c             	sub    $0xc,%esp
801012e4:	68 12 81 10 80       	push   $0x80108112
801012e9:	e8 92 f0 ff ff       	call   80100380 <panic>
801012ee:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801012f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012f3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012f6:	09 da                	or     %ebx,%edx
801012f8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012fc:	57                   	push   %edi
801012fd:	e8 3e 1c 00 00       	call   80102f40 <log_write>
        brelse(bp);
80101302:	89 3c 24             	mov    %edi,(%esp)
80101305:	e8 e6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010130a:	58                   	pop    %eax
8010130b:	5a                   	pop    %edx
8010130c:	56                   	push   %esi
8010130d:	ff 75 d8             	push   -0x28(%ebp)
80101310:	e8 bb ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101315:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101318:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010131a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010131d:	68 00 02 00 00       	push   $0x200
80101322:	6a 00                	push   $0x0
80101324:	50                   	push   %eax
80101325:	e8 66 40 00 00       	call   80105390 <memset>
  log_write(bp);
8010132a:	89 1c 24             	mov    %ebx,(%esp)
8010132d:	e8 0e 1c 00 00       	call   80102f40 <log_write>
  brelse(bp);
80101332:	89 1c 24             	mov    %ebx,(%esp)
80101335:	e8 b6 ee ff ff       	call   801001f0 <brelse>
}
8010133a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010133d:	89 f0                	mov    %esi,%eax
8010133f:	5b                   	pop    %ebx
80101340:	5e                   	pop    %esi
80101341:	5f                   	pop    %edi
80101342:	5d                   	pop    %ebp
80101343:	c3                   	ret    
80101344:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010134b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010134f:	90                   	nop

80101350 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101350:	55                   	push   %ebp
80101351:	89 e5                	mov    %esp,%ebp
80101353:	57                   	push   %edi
80101354:	89 c7                	mov    %eax,%edi
80101356:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101357:	31 f6                	xor    %esi,%esi
{
80101359:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010135a:	bb b4 09 11 80       	mov    $0x801109b4,%ebx
{
8010135f:	83 ec 28             	sub    $0x28,%esp
80101362:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101365:	68 80 09 11 80       	push   $0x80110980
8010136a:	e8 61 3f 00 00       	call   801052d0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010136f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101372:	83 c4 10             	add    $0x10,%esp
80101375:	eb 1b                	jmp    80101392 <iget+0x42>
80101377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010137e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101380:	39 3b                	cmp    %edi,(%ebx)
80101382:	74 6c                	je     801013f0 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101384:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010138a:	81 fb d4 25 11 80    	cmp    $0x801125d4,%ebx
80101390:	73 26                	jae    801013b8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101392:	8b 43 08             	mov    0x8(%ebx),%eax
80101395:	85 c0                	test   %eax,%eax
80101397:	7f e7                	jg     80101380 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101399:	85 f6                	test   %esi,%esi
8010139b:	75 e7                	jne    80101384 <iget+0x34>
8010139d:	85 c0                	test   %eax,%eax
8010139f:	75 76                	jne    80101417 <iget+0xc7>
801013a1:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013a3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013a9:	81 fb d4 25 11 80    	cmp    $0x801125d4,%ebx
801013af:	72 e1                	jb     80101392 <iget+0x42>
801013b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013b8:	85 f6                	test   %esi,%esi
801013ba:	74 79                	je     80101435 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013bc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013bf:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013c1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013c4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013cb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013d2:	68 80 09 11 80       	push   $0x80110980
801013d7:	e8 94 3e 00 00       	call   80105270 <release>

  return ip;
801013dc:	83 c4 10             	add    $0x10,%esp
}
801013df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e2:	89 f0                	mov    %esi,%eax
801013e4:	5b                   	pop    %ebx
801013e5:	5e                   	pop    %esi
801013e6:	5f                   	pop    %edi
801013e7:	5d                   	pop    %ebp
801013e8:	c3                   	ret    
801013e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013f0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013f3:	75 8f                	jne    80101384 <iget+0x34>
      release(&icache.lock);
801013f5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801013f8:	83 c0 01             	add    $0x1,%eax
      return ip;
801013fb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801013fd:	68 80 09 11 80       	push   $0x80110980
      ip->ref++;
80101402:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101405:	e8 66 3e 00 00       	call   80105270 <release>
      return ip;
8010140a:	83 c4 10             	add    $0x10,%esp
}
8010140d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101410:	89 f0                	mov    %esi,%eax
80101412:	5b                   	pop    %ebx
80101413:	5e                   	pop    %esi
80101414:	5f                   	pop    %edi
80101415:	5d                   	pop    %ebp
80101416:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101417:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010141d:	81 fb d4 25 11 80    	cmp    $0x801125d4,%ebx
80101423:	73 10                	jae    80101435 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101425:	8b 43 08             	mov    0x8(%ebx),%eax
80101428:	85 c0                	test   %eax,%eax
8010142a:	0f 8f 50 ff ff ff    	jg     80101380 <iget+0x30>
80101430:	e9 68 ff ff ff       	jmp    8010139d <iget+0x4d>
    panic("iget: no inodes");
80101435:	83 ec 0c             	sub    $0xc,%esp
80101438:	68 28 81 10 80       	push   $0x80108128
8010143d:	e8 3e ef ff ff       	call   80100380 <panic>
80101442:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101450 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101450:	55                   	push   %ebp
80101451:	89 e5                	mov    %esp,%ebp
80101453:	57                   	push   %edi
80101454:	56                   	push   %esi
80101455:	89 c6                	mov    %eax,%esi
80101457:	53                   	push   %ebx
80101458:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010145b:	83 fa 0b             	cmp    $0xb,%edx
8010145e:	0f 86 8c 00 00 00    	jbe    801014f0 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101464:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101467:	83 fb 7f             	cmp    $0x7f,%ebx
8010146a:	0f 87 a2 00 00 00    	ja     80101512 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101470:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101476:	85 c0                	test   %eax,%eax
80101478:	74 5e                	je     801014d8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010147a:	83 ec 08             	sub    $0x8,%esp
8010147d:	50                   	push   %eax
8010147e:	ff 36                	push   (%esi)
80101480:	e8 4b ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101485:	83 c4 10             	add    $0x10,%esp
80101488:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010148c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010148e:	8b 3b                	mov    (%ebx),%edi
80101490:	85 ff                	test   %edi,%edi
80101492:	74 1c                	je     801014b0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101494:	83 ec 0c             	sub    $0xc,%esp
80101497:	52                   	push   %edx
80101498:	e8 53 ed ff ff       	call   801001f0 <brelse>
8010149d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801014a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014a3:	89 f8                	mov    %edi,%eax
801014a5:	5b                   	pop    %ebx
801014a6:	5e                   	pop    %esi
801014a7:	5f                   	pop    %edi
801014a8:	5d                   	pop    %ebp
801014a9:	c3                   	ret    
801014aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801014b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801014b3:	8b 06                	mov    (%esi),%eax
801014b5:	e8 86 fd ff ff       	call   80101240 <balloc>
      log_write(bp);
801014ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014bd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014c0:	89 03                	mov    %eax,(%ebx)
801014c2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801014c4:	52                   	push   %edx
801014c5:	e8 76 1a 00 00       	call   80102f40 <log_write>
801014ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014cd:	83 c4 10             	add    $0x10,%esp
801014d0:	eb c2                	jmp    80101494 <bmap+0x44>
801014d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014d8:	8b 06                	mov    (%esi),%eax
801014da:	e8 61 fd ff ff       	call   80101240 <balloc>
801014df:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014e5:	eb 93                	jmp    8010147a <bmap+0x2a>
801014e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014ee:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
801014f0:	8d 5a 14             	lea    0x14(%edx),%ebx
801014f3:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
801014f7:	85 ff                	test   %edi,%edi
801014f9:	75 a5                	jne    801014a0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
801014fb:	8b 00                	mov    (%eax),%eax
801014fd:	e8 3e fd ff ff       	call   80101240 <balloc>
80101502:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101506:	89 c7                	mov    %eax,%edi
}
80101508:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010150b:	5b                   	pop    %ebx
8010150c:	89 f8                	mov    %edi,%eax
8010150e:	5e                   	pop    %esi
8010150f:	5f                   	pop    %edi
80101510:	5d                   	pop    %ebp
80101511:	c3                   	ret    
  panic("bmap: out of range");
80101512:	83 ec 0c             	sub    $0xc,%esp
80101515:	68 38 81 10 80       	push   $0x80108138
8010151a:	e8 61 ee ff ff       	call   80100380 <panic>
8010151f:	90                   	nop

80101520 <readsb>:
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	56                   	push   %esi
80101524:	53                   	push   %ebx
80101525:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101528:	83 ec 08             	sub    $0x8,%esp
8010152b:	6a 01                	push   $0x1
8010152d:	ff 75 08             	push   0x8(%ebp)
80101530:	e8 9b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101535:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101538:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010153a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010153d:	6a 1c                	push   $0x1c
8010153f:	50                   	push   %eax
80101540:	56                   	push   %esi
80101541:	e8 ea 3e 00 00       	call   80105430 <memmove>
  brelse(bp);
80101546:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101549:	83 c4 10             	add    $0x10,%esp
}
8010154c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010154f:	5b                   	pop    %ebx
80101550:	5e                   	pop    %esi
80101551:	5d                   	pop    %ebp
  brelse(bp);
80101552:	e9 99 ec ff ff       	jmp    801001f0 <brelse>
80101557:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010155e:	66 90                	xchg   %ax,%ax

80101560 <iinit>:
{
80101560:	55                   	push   %ebp
80101561:	89 e5                	mov    %esp,%ebp
80101563:	53                   	push   %ebx
80101564:	bb c0 09 11 80       	mov    $0x801109c0,%ebx
80101569:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010156c:	68 4b 81 10 80       	push   $0x8010814b
80101571:	68 80 09 11 80       	push   $0x80110980
80101576:	e8 85 3b 00 00       	call   80105100 <initlock>
  for(i = 0; i < NINODE; i++) {
8010157b:	83 c4 10             	add    $0x10,%esp
8010157e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101580:	83 ec 08             	sub    $0x8,%esp
80101583:	68 52 81 10 80       	push   $0x80108152
80101588:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101589:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010158f:	e8 3c 3a 00 00       	call   80104fd0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101594:	83 c4 10             	add    $0x10,%esp
80101597:	81 fb e0 25 11 80    	cmp    $0x801125e0,%ebx
8010159d:	75 e1                	jne    80101580 <iinit+0x20>
  bp = bread(dev, 1);
8010159f:	83 ec 08             	sub    $0x8,%esp
801015a2:	6a 01                	push   $0x1
801015a4:	ff 75 08             	push   0x8(%ebp)
801015a7:	e8 24 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015ac:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015af:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015b1:	8d 40 5c             	lea    0x5c(%eax),%eax
801015b4:	6a 1c                	push   $0x1c
801015b6:	50                   	push   %eax
801015b7:	68 d4 25 11 80       	push   $0x801125d4
801015bc:	e8 6f 3e 00 00       	call   80105430 <memmove>
  brelse(bp);
801015c1:	89 1c 24             	mov    %ebx,(%esp)
801015c4:	e8 27 ec ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015c9:	ff 35 ec 25 11 80    	push   0x801125ec
801015cf:	ff 35 e8 25 11 80    	push   0x801125e8
801015d5:	ff 35 e4 25 11 80    	push   0x801125e4
801015db:	ff 35 e0 25 11 80    	push   0x801125e0
801015e1:	ff 35 dc 25 11 80    	push   0x801125dc
801015e7:	ff 35 d8 25 11 80    	push   0x801125d8
801015ed:	ff 35 d4 25 11 80    	push   0x801125d4
801015f3:	68 b8 81 10 80       	push   $0x801081b8
801015f8:	e8 a3 f0 ff ff       	call   801006a0 <cprintf>
}
801015fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101600:	83 c4 30             	add    $0x30,%esp
80101603:	c9                   	leave  
80101604:	c3                   	ret    
80101605:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010160c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101610 <ialloc>:
{
80101610:	55                   	push   %ebp
80101611:	89 e5                	mov    %esp,%ebp
80101613:	57                   	push   %edi
80101614:	56                   	push   %esi
80101615:	53                   	push   %ebx
80101616:	83 ec 1c             	sub    $0x1c,%esp
80101619:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010161c:	83 3d dc 25 11 80 01 	cmpl   $0x1,0x801125dc
{
80101623:	8b 75 08             	mov    0x8(%ebp),%esi
80101626:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101629:	0f 86 91 00 00 00    	jbe    801016c0 <ialloc+0xb0>
8010162f:	bf 01 00 00 00       	mov    $0x1,%edi
80101634:	eb 21                	jmp    80101657 <ialloc+0x47>
80101636:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010163d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101640:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101643:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101646:	53                   	push   %ebx
80101647:	e8 a4 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010164c:	83 c4 10             	add    $0x10,%esp
8010164f:	3b 3d dc 25 11 80    	cmp    0x801125dc,%edi
80101655:	73 69                	jae    801016c0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101657:	89 f8                	mov    %edi,%eax
80101659:	83 ec 08             	sub    $0x8,%esp
8010165c:	c1 e8 03             	shr    $0x3,%eax
8010165f:	03 05 e8 25 11 80    	add    0x801125e8,%eax
80101665:	50                   	push   %eax
80101666:	56                   	push   %esi
80101667:	e8 64 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010166c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010166f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101671:	89 f8                	mov    %edi,%eax
80101673:	83 e0 07             	and    $0x7,%eax
80101676:	c1 e0 06             	shl    $0x6,%eax
80101679:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010167d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101681:	75 bd                	jne    80101640 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101683:	83 ec 04             	sub    $0x4,%esp
80101686:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101689:	6a 40                	push   $0x40
8010168b:	6a 00                	push   $0x0
8010168d:	51                   	push   %ecx
8010168e:	e8 fd 3c 00 00       	call   80105390 <memset>
      dip->type = type;
80101693:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101697:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010169a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010169d:	89 1c 24             	mov    %ebx,(%esp)
801016a0:	e8 9b 18 00 00       	call   80102f40 <log_write>
      brelse(bp);
801016a5:	89 1c 24             	mov    %ebx,(%esp)
801016a8:	e8 43 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801016ad:	83 c4 10             	add    $0x10,%esp
}
801016b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016b3:	89 fa                	mov    %edi,%edx
}
801016b5:	5b                   	pop    %ebx
      return iget(dev, inum);
801016b6:	89 f0                	mov    %esi,%eax
}
801016b8:	5e                   	pop    %esi
801016b9:	5f                   	pop    %edi
801016ba:	5d                   	pop    %ebp
      return iget(dev, inum);
801016bb:	e9 90 fc ff ff       	jmp    80101350 <iget>
  panic("ialloc: no inodes");
801016c0:	83 ec 0c             	sub    $0xc,%esp
801016c3:	68 58 81 10 80       	push   $0x80108158
801016c8:	e8 b3 ec ff ff       	call   80100380 <panic>
801016cd:	8d 76 00             	lea    0x0(%esi),%esi

801016d0 <iupdate>:
{
801016d0:	55                   	push   %ebp
801016d1:	89 e5                	mov    %esp,%ebp
801016d3:	56                   	push   %esi
801016d4:	53                   	push   %ebx
801016d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016d8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016db:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016de:	83 ec 08             	sub    $0x8,%esp
801016e1:	c1 e8 03             	shr    $0x3,%eax
801016e4:	03 05 e8 25 11 80    	add    0x801125e8,%eax
801016ea:	50                   	push   %eax
801016eb:	ff 73 a4             	push   -0x5c(%ebx)
801016ee:	e8 dd e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801016f3:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016f7:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016fa:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016fc:	8b 43 a8             	mov    -0x58(%ebx),%eax
801016ff:	83 e0 07             	and    $0x7,%eax
80101702:	c1 e0 06             	shl    $0x6,%eax
80101705:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101709:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010170c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101710:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101713:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101717:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010171b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010171f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101723:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101727:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010172a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010172d:	6a 34                	push   $0x34
8010172f:	53                   	push   %ebx
80101730:	50                   	push   %eax
80101731:	e8 fa 3c 00 00       	call   80105430 <memmove>
  log_write(bp);
80101736:	89 34 24             	mov    %esi,(%esp)
80101739:	e8 02 18 00 00       	call   80102f40 <log_write>
  brelse(bp);
8010173e:	89 75 08             	mov    %esi,0x8(%ebp)
80101741:	83 c4 10             	add    $0x10,%esp
}
80101744:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101747:	5b                   	pop    %ebx
80101748:	5e                   	pop    %esi
80101749:	5d                   	pop    %ebp
  brelse(bp);
8010174a:	e9 a1 ea ff ff       	jmp    801001f0 <brelse>
8010174f:	90                   	nop

80101750 <idup>:
{
80101750:	55                   	push   %ebp
80101751:	89 e5                	mov    %esp,%ebp
80101753:	53                   	push   %ebx
80101754:	83 ec 10             	sub    $0x10,%esp
80101757:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010175a:	68 80 09 11 80       	push   $0x80110980
8010175f:	e8 6c 3b 00 00       	call   801052d0 <acquire>
  ip->ref++;
80101764:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101768:	c7 04 24 80 09 11 80 	movl   $0x80110980,(%esp)
8010176f:	e8 fc 3a 00 00       	call   80105270 <release>
}
80101774:	89 d8                	mov    %ebx,%eax
80101776:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101779:	c9                   	leave  
8010177a:	c3                   	ret    
8010177b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010177f:	90                   	nop

80101780 <ilock>:
{
80101780:	55                   	push   %ebp
80101781:	89 e5                	mov    %esp,%ebp
80101783:	56                   	push   %esi
80101784:	53                   	push   %ebx
80101785:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101788:	85 db                	test   %ebx,%ebx
8010178a:	0f 84 b7 00 00 00    	je     80101847 <ilock+0xc7>
80101790:	8b 53 08             	mov    0x8(%ebx),%edx
80101793:	85 d2                	test   %edx,%edx
80101795:	0f 8e ac 00 00 00    	jle    80101847 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010179b:	83 ec 0c             	sub    $0xc,%esp
8010179e:	8d 43 0c             	lea    0xc(%ebx),%eax
801017a1:	50                   	push   %eax
801017a2:	e8 69 38 00 00       	call   80105010 <acquiresleep>
  if(ip->valid == 0){
801017a7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017aa:	83 c4 10             	add    $0x10,%esp
801017ad:	85 c0                	test   %eax,%eax
801017af:	74 0f                	je     801017c0 <ilock+0x40>
}
801017b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017b4:	5b                   	pop    %ebx
801017b5:	5e                   	pop    %esi
801017b6:	5d                   	pop    %ebp
801017b7:	c3                   	ret    
801017b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017bf:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017c0:	8b 43 04             	mov    0x4(%ebx),%eax
801017c3:	83 ec 08             	sub    $0x8,%esp
801017c6:	c1 e8 03             	shr    $0x3,%eax
801017c9:	03 05 e8 25 11 80    	add    0x801125e8,%eax
801017cf:	50                   	push   %eax
801017d0:	ff 33                	push   (%ebx)
801017d2:	e8 f9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017d7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017da:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017dc:	8b 43 04             	mov    0x4(%ebx),%eax
801017df:	83 e0 07             	and    $0x7,%eax
801017e2:	c1 e0 06             	shl    $0x6,%eax
801017e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017e9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017ec:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017ef:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017f3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017f7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017fb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017ff:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101803:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101807:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010180b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010180e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101811:	6a 34                	push   $0x34
80101813:	50                   	push   %eax
80101814:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101817:	50                   	push   %eax
80101818:	e8 13 3c 00 00       	call   80105430 <memmove>
    brelse(bp);
8010181d:	89 34 24             	mov    %esi,(%esp)
80101820:	e8 cb e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101825:	83 c4 10             	add    $0x10,%esp
80101828:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010182d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101834:	0f 85 77 ff ff ff    	jne    801017b1 <ilock+0x31>
      panic("ilock: no type");
8010183a:	83 ec 0c             	sub    $0xc,%esp
8010183d:	68 70 81 10 80       	push   $0x80108170
80101842:	e8 39 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101847:	83 ec 0c             	sub    $0xc,%esp
8010184a:	68 6a 81 10 80       	push   $0x8010816a
8010184f:	e8 2c eb ff ff       	call   80100380 <panic>
80101854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010185b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010185f:	90                   	nop

80101860 <iunlock>:
{
80101860:	55                   	push   %ebp
80101861:	89 e5                	mov    %esp,%ebp
80101863:	56                   	push   %esi
80101864:	53                   	push   %ebx
80101865:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101868:	85 db                	test   %ebx,%ebx
8010186a:	74 28                	je     80101894 <iunlock+0x34>
8010186c:	83 ec 0c             	sub    $0xc,%esp
8010186f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101872:	56                   	push   %esi
80101873:	e8 38 38 00 00       	call   801050b0 <holdingsleep>
80101878:	83 c4 10             	add    $0x10,%esp
8010187b:	85 c0                	test   %eax,%eax
8010187d:	74 15                	je     80101894 <iunlock+0x34>
8010187f:	8b 43 08             	mov    0x8(%ebx),%eax
80101882:	85 c0                	test   %eax,%eax
80101884:	7e 0e                	jle    80101894 <iunlock+0x34>
  releasesleep(&ip->lock);
80101886:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101889:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010188c:	5b                   	pop    %ebx
8010188d:	5e                   	pop    %esi
8010188e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010188f:	e9 dc 37 00 00       	jmp    80105070 <releasesleep>
    panic("iunlock");
80101894:	83 ec 0c             	sub    $0xc,%esp
80101897:	68 7f 81 10 80       	push   $0x8010817f
8010189c:	e8 df ea ff ff       	call   80100380 <panic>
801018a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018af:	90                   	nop

801018b0 <iput>:
{
801018b0:	55                   	push   %ebp
801018b1:	89 e5                	mov    %esp,%ebp
801018b3:	57                   	push   %edi
801018b4:	56                   	push   %esi
801018b5:	53                   	push   %ebx
801018b6:	83 ec 28             	sub    $0x28,%esp
801018b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018bc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018bf:	57                   	push   %edi
801018c0:	e8 4b 37 00 00       	call   80105010 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018c5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018c8:	83 c4 10             	add    $0x10,%esp
801018cb:	85 d2                	test   %edx,%edx
801018cd:	74 07                	je     801018d6 <iput+0x26>
801018cf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018d4:	74 32                	je     80101908 <iput+0x58>
  releasesleep(&ip->lock);
801018d6:	83 ec 0c             	sub    $0xc,%esp
801018d9:	57                   	push   %edi
801018da:	e8 91 37 00 00       	call   80105070 <releasesleep>
  acquire(&icache.lock);
801018df:	c7 04 24 80 09 11 80 	movl   $0x80110980,(%esp)
801018e6:	e8 e5 39 00 00       	call   801052d0 <acquire>
  ip->ref--;
801018eb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018ef:	83 c4 10             	add    $0x10,%esp
801018f2:	c7 45 08 80 09 11 80 	movl   $0x80110980,0x8(%ebp)
}
801018f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018fc:	5b                   	pop    %ebx
801018fd:	5e                   	pop    %esi
801018fe:	5f                   	pop    %edi
801018ff:	5d                   	pop    %ebp
  release(&icache.lock);
80101900:	e9 6b 39 00 00       	jmp    80105270 <release>
80101905:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101908:	83 ec 0c             	sub    $0xc,%esp
8010190b:	68 80 09 11 80       	push   $0x80110980
80101910:	e8 bb 39 00 00       	call   801052d0 <acquire>
    int r = ip->ref;
80101915:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101918:	c7 04 24 80 09 11 80 	movl   $0x80110980,(%esp)
8010191f:	e8 4c 39 00 00       	call   80105270 <release>
    if(r == 1){
80101924:	83 c4 10             	add    $0x10,%esp
80101927:	83 fe 01             	cmp    $0x1,%esi
8010192a:	75 aa                	jne    801018d6 <iput+0x26>
8010192c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101932:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101935:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101938:	89 cf                	mov    %ecx,%edi
8010193a:	eb 0b                	jmp    80101947 <iput+0x97>
8010193c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101940:	83 c6 04             	add    $0x4,%esi
80101943:	39 fe                	cmp    %edi,%esi
80101945:	74 19                	je     80101960 <iput+0xb0>
    if(ip->addrs[i]){
80101947:	8b 16                	mov    (%esi),%edx
80101949:	85 d2                	test   %edx,%edx
8010194b:	74 f3                	je     80101940 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010194d:	8b 03                	mov    (%ebx),%eax
8010194f:	e8 6c f8 ff ff       	call   801011c0 <bfree>
      ip->addrs[i] = 0;
80101954:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010195a:	eb e4                	jmp    80101940 <iput+0x90>
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101960:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101966:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101969:	85 c0                	test   %eax,%eax
8010196b:	75 2d                	jne    8010199a <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010196d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101970:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101977:	53                   	push   %ebx
80101978:	e8 53 fd ff ff       	call   801016d0 <iupdate>
      ip->type = 0;
8010197d:	31 c0                	xor    %eax,%eax
8010197f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101983:	89 1c 24             	mov    %ebx,(%esp)
80101986:	e8 45 fd ff ff       	call   801016d0 <iupdate>
      ip->valid = 0;
8010198b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101992:	83 c4 10             	add    $0x10,%esp
80101995:	e9 3c ff ff ff       	jmp    801018d6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
8010199a:	83 ec 08             	sub    $0x8,%esp
8010199d:	50                   	push   %eax
8010199e:	ff 33                	push   (%ebx)
801019a0:	e8 2b e7 ff ff       	call   801000d0 <bread>
801019a5:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019a8:	83 c4 10             	add    $0x10,%esp
801019ab:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019b4:	8d 70 5c             	lea    0x5c(%eax),%esi
801019b7:	89 cf                	mov    %ecx,%edi
801019b9:	eb 0c                	jmp    801019c7 <iput+0x117>
801019bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019bf:	90                   	nop
801019c0:	83 c6 04             	add    $0x4,%esi
801019c3:	39 f7                	cmp    %esi,%edi
801019c5:	74 0f                	je     801019d6 <iput+0x126>
      if(a[j])
801019c7:	8b 16                	mov    (%esi),%edx
801019c9:	85 d2                	test   %edx,%edx
801019cb:	74 f3                	je     801019c0 <iput+0x110>
        bfree(ip->dev, a[j]);
801019cd:	8b 03                	mov    (%ebx),%eax
801019cf:	e8 ec f7 ff ff       	call   801011c0 <bfree>
801019d4:	eb ea                	jmp    801019c0 <iput+0x110>
    brelse(bp);
801019d6:	83 ec 0c             	sub    $0xc,%esp
801019d9:	ff 75 e4             	push   -0x1c(%ebp)
801019dc:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019df:	e8 0c e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019e4:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019ea:	8b 03                	mov    (%ebx),%eax
801019ec:	e8 cf f7 ff ff       	call   801011c0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019f1:	83 c4 10             	add    $0x10,%esp
801019f4:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801019fb:	00 00 00 
801019fe:	e9 6a ff ff ff       	jmp    8010196d <iput+0xbd>
80101a03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a10 <iunlockput>:
{
80101a10:	55                   	push   %ebp
80101a11:	89 e5                	mov    %esp,%ebp
80101a13:	56                   	push   %esi
80101a14:	53                   	push   %ebx
80101a15:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a18:	85 db                	test   %ebx,%ebx
80101a1a:	74 34                	je     80101a50 <iunlockput+0x40>
80101a1c:	83 ec 0c             	sub    $0xc,%esp
80101a1f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a22:	56                   	push   %esi
80101a23:	e8 88 36 00 00       	call   801050b0 <holdingsleep>
80101a28:	83 c4 10             	add    $0x10,%esp
80101a2b:	85 c0                	test   %eax,%eax
80101a2d:	74 21                	je     80101a50 <iunlockput+0x40>
80101a2f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a32:	85 c0                	test   %eax,%eax
80101a34:	7e 1a                	jle    80101a50 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a36:	83 ec 0c             	sub    $0xc,%esp
80101a39:	56                   	push   %esi
80101a3a:	e8 31 36 00 00       	call   80105070 <releasesleep>
  iput(ip);
80101a3f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a42:	83 c4 10             	add    $0x10,%esp
}
80101a45:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a48:	5b                   	pop    %ebx
80101a49:	5e                   	pop    %esi
80101a4a:	5d                   	pop    %ebp
  iput(ip);
80101a4b:	e9 60 fe ff ff       	jmp    801018b0 <iput>
    panic("iunlock");
80101a50:	83 ec 0c             	sub    $0xc,%esp
80101a53:	68 7f 81 10 80       	push   $0x8010817f
80101a58:	e8 23 e9 ff ff       	call   80100380 <panic>
80101a5d:	8d 76 00             	lea    0x0(%esi),%esi

80101a60 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	8b 55 08             	mov    0x8(%ebp),%edx
80101a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a69:	8b 0a                	mov    (%edx),%ecx
80101a6b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a6e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a71:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a74:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a78:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a7b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a7f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a83:	8b 52 58             	mov    0x58(%edx),%edx
80101a86:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a89:	5d                   	pop    %ebp
80101a8a:	c3                   	ret    
80101a8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a8f:	90                   	nop

80101a90 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a90:	55                   	push   %ebp
80101a91:	89 e5                	mov    %esp,%ebp
80101a93:	57                   	push   %edi
80101a94:	56                   	push   %esi
80101a95:	53                   	push   %ebx
80101a96:	83 ec 1c             	sub    $0x1c,%esp
80101a99:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a9c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9f:	8b 75 10             	mov    0x10(%ebp),%esi
80101aa2:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101aa5:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101aa8:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101aad:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ab0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101ab3:	0f 84 a7 00 00 00    	je     80101b60 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101ab9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101abc:	8b 40 58             	mov    0x58(%eax),%eax
80101abf:	39 c6                	cmp    %eax,%esi
80101ac1:	0f 87 ba 00 00 00    	ja     80101b81 <readi+0xf1>
80101ac7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101aca:	31 c9                	xor    %ecx,%ecx
80101acc:	89 da                	mov    %ebx,%edx
80101ace:	01 f2                	add    %esi,%edx
80101ad0:	0f 92 c1             	setb   %cl
80101ad3:	89 cf                	mov    %ecx,%edi
80101ad5:	0f 82 a6 00 00 00    	jb     80101b81 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101adb:	89 c1                	mov    %eax,%ecx
80101add:	29 f1                	sub    %esi,%ecx
80101adf:	39 d0                	cmp    %edx,%eax
80101ae1:	0f 43 cb             	cmovae %ebx,%ecx
80101ae4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ae7:	85 c9                	test   %ecx,%ecx
80101ae9:	74 67                	je     80101b52 <readi+0xc2>
80101aeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101aef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101af3:	89 f2                	mov    %esi,%edx
80101af5:	c1 ea 09             	shr    $0x9,%edx
80101af8:	89 d8                	mov    %ebx,%eax
80101afa:	e8 51 f9 ff ff       	call   80101450 <bmap>
80101aff:	83 ec 08             	sub    $0x8,%esp
80101b02:	50                   	push   %eax
80101b03:	ff 33                	push   (%ebx)
80101b05:	e8 c6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b0a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b0d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b12:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b14:	89 f0                	mov    %esi,%eax
80101b16:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b1b:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b1d:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b20:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b22:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b26:	39 d9                	cmp    %ebx,%ecx
80101b28:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b2b:	83 c4 0c             	add    $0xc,%esp
80101b2e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b2f:	01 df                	add    %ebx,%edi
80101b31:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b33:	50                   	push   %eax
80101b34:	ff 75 e0             	push   -0x20(%ebp)
80101b37:	e8 f4 38 00 00       	call   80105430 <memmove>
    brelse(bp);
80101b3c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b3f:	89 14 24             	mov    %edx,(%esp)
80101b42:	e8 a9 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b47:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b4a:	83 c4 10             	add    $0x10,%esp
80101b4d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b50:	77 9e                	ja     80101af0 <readi+0x60>
  }
  return n;
80101b52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b58:	5b                   	pop    %ebx
80101b59:	5e                   	pop    %esi
80101b5a:	5f                   	pop    %edi
80101b5b:	5d                   	pop    %ebp
80101b5c:	c3                   	ret    
80101b5d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b60:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b64:	66 83 f8 09          	cmp    $0x9,%ax
80101b68:	77 17                	ja     80101b81 <readi+0xf1>
80101b6a:	8b 04 c5 20 09 11 80 	mov    -0x7feef6e0(,%eax,8),%eax
80101b71:	85 c0                	test   %eax,%eax
80101b73:	74 0c                	je     80101b81 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b75:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b7b:	5b                   	pop    %ebx
80101b7c:	5e                   	pop    %esi
80101b7d:	5f                   	pop    %edi
80101b7e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b7f:	ff e0                	jmp    *%eax
      return -1;
80101b81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b86:	eb cd                	jmp    80101b55 <readi+0xc5>
80101b88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b8f:	90                   	nop

80101b90 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	57                   	push   %edi
80101b94:	56                   	push   %esi
80101b95:	53                   	push   %ebx
80101b96:	83 ec 1c             	sub    $0x1c,%esp
80101b99:	8b 45 08             	mov    0x8(%ebp),%eax
80101b9c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b9f:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ba2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101ba7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101baa:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101bad:	8b 75 10             	mov    0x10(%ebp),%esi
80101bb0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101bb3:	0f 84 b7 00 00 00    	je     80101c70 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101bb9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bbc:	3b 70 58             	cmp    0x58(%eax),%esi
80101bbf:	0f 87 e7 00 00 00    	ja     80101cac <writei+0x11c>
80101bc5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bc8:	31 d2                	xor    %edx,%edx
80101bca:	89 f8                	mov    %edi,%eax
80101bcc:	01 f0                	add    %esi,%eax
80101bce:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101bd1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bd6:	0f 87 d0 00 00 00    	ja     80101cac <writei+0x11c>
80101bdc:	85 d2                	test   %edx,%edx
80101bde:	0f 85 c8 00 00 00    	jne    80101cac <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101be4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101beb:	85 ff                	test   %edi,%edi
80101bed:	74 72                	je     80101c61 <writei+0xd1>
80101bef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bf0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101bf3:	89 f2                	mov    %esi,%edx
80101bf5:	c1 ea 09             	shr    $0x9,%edx
80101bf8:	89 f8                	mov    %edi,%eax
80101bfa:	e8 51 f8 ff ff       	call   80101450 <bmap>
80101bff:	83 ec 08             	sub    $0x8,%esp
80101c02:	50                   	push   %eax
80101c03:	ff 37                	push   (%edi)
80101c05:	e8 c6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c0a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c0f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c12:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c15:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c17:	89 f0                	mov    %esi,%eax
80101c19:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c1e:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c20:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c24:	39 d9                	cmp    %ebx,%ecx
80101c26:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c29:	83 c4 0c             	add    $0xc,%esp
80101c2c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c2d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c2f:	ff 75 dc             	push   -0x24(%ebp)
80101c32:	50                   	push   %eax
80101c33:	e8 f8 37 00 00       	call   80105430 <memmove>
    log_write(bp);
80101c38:	89 3c 24             	mov    %edi,(%esp)
80101c3b:	e8 00 13 00 00       	call   80102f40 <log_write>
    brelse(bp);
80101c40:	89 3c 24             	mov    %edi,(%esp)
80101c43:	e8 a8 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c48:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c4b:	83 c4 10             	add    $0x10,%esp
80101c4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c51:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c54:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c57:	77 97                	ja     80101bf0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c59:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c5c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c5f:	77 37                	ja     80101c98 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c61:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c67:	5b                   	pop    %ebx
80101c68:	5e                   	pop    %esi
80101c69:	5f                   	pop    %edi
80101c6a:	5d                   	pop    %ebp
80101c6b:	c3                   	ret    
80101c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c74:	66 83 f8 09          	cmp    $0x9,%ax
80101c78:	77 32                	ja     80101cac <writei+0x11c>
80101c7a:	8b 04 c5 24 09 11 80 	mov    -0x7feef6dc(,%eax,8),%eax
80101c81:	85 c0                	test   %eax,%eax
80101c83:	74 27                	je     80101cac <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c85:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101c88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c8b:	5b                   	pop    %ebx
80101c8c:	5e                   	pop    %esi
80101c8d:	5f                   	pop    %edi
80101c8e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c8f:	ff e0                	jmp    *%eax
80101c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c98:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c9b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c9e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101ca1:	50                   	push   %eax
80101ca2:	e8 29 fa ff ff       	call   801016d0 <iupdate>
80101ca7:	83 c4 10             	add    $0x10,%esp
80101caa:	eb b5                	jmp    80101c61 <writei+0xd1>
      return -1;
80101cac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cb1:	eb b1                	jmp    80101c64 <writei+0xd4>
80101cb3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101cc0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101cc0:	55                   	push   %ebp
80101cc1:	89 e5                	mov    %esp,%ebp
80101cc3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101cc6:	6a 0e                	push   $0xe
80101cc8:	ff 75 0c             	push   0xc(%ebp)
80101ccb:	ff 75 08             	push   0x8(%ebp)
80101cce:	e8 cd 37 00 00       	call   801054a0 <strncmp>
}
80101cd3:	c9                   	leave  
80101cd4:	c3                   	ret    
80101cd5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ce0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101ce0:	55                   	push   %ebp
80101ce1:	89 e5                	mov    %esp,%ebp
80101ce3:	57                   	push   %edi
80101ce4:	56                   	push   %esi
80101ce5:	53                   	push   %ebx
80101ce6:	83 ec 1c             	sub    $0x1c,%esp
80101ce9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cec:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101cf1:	0f 85 85 00 00 00    	jne    80101d7c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101cf7:	8b 53 58             	mov    0x58(%ebx),%edx
80101cfa:	31 ff                	xor    %edi,%edi
80101cfc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101cff:	85 d2                	test   %edx,%edx
80101d01:	74 3e                	je     80101d41 <dirlookup+0x61>
80101d03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d07:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d08:	6a 10                	push   $0x10
80101d0a:	57                   	push   %edi
80101d0b:	56                   	push   %esi
80101d0c:	53                   	push   %ebx
80101d0d:	e8 7e fd ff ff       	call   80101a90 <readi>
80101d12:	83 c4 10             	add    $0x10,%esp
80101d15:	83 f8 10             	cmp    $0x10,%eax
80101d18:	75 55                	jne    80101d6f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d1a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d1f:	74 18                	je     80101d39 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d21:	83 ec 04             	sub    $0x4,%esp
80101d24:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d27:	6a 0e                	push   $0xe
80101d29:	50                   	push   %eax
80101d2a:	ff 75 0c             	push   0xc(%ebp)
80101d2d:	e8 6e 37 00 00       	call   801054a0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d32:	83 c4 10             	add    $0x10,%esp
80101d35:	85 c0                	test   %eax,%eax
80101d37:	74 17                	je     80101d50 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d39:	83 c7 10             	add    $0x10,%edi
80101d3c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d3f:	72 c7                	jb     80101d08 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d44:	31 c0                	xor    %eax,%eax
}
80101d46:	5b                   	pop    %ebx
80101d47:	5e                   	pop    %esi
80101d48:	5f                   	pop    %edi
80101d49:	5d                   	pop    %ebp
80101d4a:	c3                   	ret    
80101d4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d4f:	90                   	nop
      if(poff)
80101d50:	8b 45 10             	mov    0x10(%ebp),%eax
80101d53:	85 c0                	test   %eax,%eax
80101d55:	74 05                	je     80101d5c <dirlookup+0x7c>
        *poff = off;
80101d57:	8b 45 10             	mov    0x10(%ebp),%eax
80101d5a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d5c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d60:	8b 03                	mov    (%ebx),%eax
80101d62:	e8 e9 f5 ff ff       	call   80101350 <iget>
}
80101d67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d6a:	5b                   	pop    %ebx
80101d6b:	5e                   	pop    %esi
80101d6c:	5f                   	pop    %edi
80101d6d:	5d                   	pop    %ebp
80101d6e:	c3                   	ret    
      panic("dirlookup read");
80101d6f:	83 ec 0c             	sub    $0xc,%esp
80101d72:	68 99 81 10 80       	push   $0x80108199
80101d77:	e8 04 e6 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d7c:	83 ec 0c             	sub    $0xc,%esp
80101d7f:	68 87 81 10 80       	push   $0x80108187
80101d84:	e8 f7 e5 ff ff       	call   80100380 <panic>
80101d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d90 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d90:	55                   	push   %ebp
80101d91:	89 e5                	mov    %esp,%ebp
80101d93:	57                   	push   %edi
80101d94:	56                   	push   %esi
80101d95:	53                   	push   %ebx
80101d96:	89 c3                	mov    %eax,%ebx
80101d98:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d9b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d9e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101da1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101da4:	0f 84 64 01 00 00    	je     80101f0e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101daa:	e8 71 1e 00 00       	call   80103c20 <myproc>
  acquire(&icache.lock);
80101daf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101db2:	8b 70 70             	mov    0x70(%eax),%esi
  acquire(&icache.lock);
80101db5:	68 80 09 11 80       	push   $0x80110980
80101dba:	e8 11 35 00 00       	call   801052d0 <acquire>
  ip->ref++;
80101dbf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dc3:	c7 04 24 80 09 11 80 	movl   $0x80110980,(%esp)
80101dca:	e8 a1 34 00 00       	call   80105270 <release>
80101dcf:	83 c4 10             	add    $0x10,%esp
80101dd2:	eb 07                	jmp    80101ddb <namex+0x4b>
80101dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101dd8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101ddb:	0f b6 03             	movzbl (%ebx),%eax
80101dde:	3c 2f                	cmp    $0x2f,%al
80101de0:	74 f6                	je     80101dd8 <namex+0x48>
  if(*path == 0)
80101de2:	84 c0                	test   %al,%al
80101de4:	0f 84 06 01 00 00    	je     80101ef0 <namex+0x160>
  while(*path != '/' && *path != 0)
80101dea:	0f b6 03             	movzbl (%ebx),%eax
80101ded:	84 c0                	test   %al,%al
80101def:	0f 84 10 01 00 00    	je     80101f05 <namex+0x175>
80101df5:	89 df                	mov    %ebx,%edi
80101df7:	3c 2f                	cmp    $0x2f,%al
80101df9:	0f 84 06 01 00 00    	je     80101f05 <namex+0x175>
80101dff:	90                   	nop
80101e00:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e04:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e07:	3c 2f                	cmp    $0x2f,%al
80101e09:	74 04                	je     80101e0f <namex+0x7f>
80101e0b:	84 c0                	test   %al,%al
80101e0d:	75 f1                	jne    80101e00 <namex+0x70>
  len = path - s;
80101e0f:	89 f8                	mov    %edi,%eax
80101e11:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e13:	83 f8 0d             	cmp    $0xd,%eax
80101e16:	0f 8e ac 00 00 00    	jle    80101ec8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e1c:	83 ec 04             	sub    $0x4,%esp
80101e1f:	6a 0e                	push   $0xe
80101e21:	53                   	push   %ebx
    path++;
80101e22:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101e24:	ff 75 e4             	push   -0x1c(%ebp)
80101e27:	e8 04 36 00 00       	call   80105430 <memmove>
80101e2c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e2f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e32:	75 0c                	jne    80101e40 <namex+0xb0>
80101e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e38:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e3b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e3e:	74 f8                	je     80101e38 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e40:	83 ec 0c             	sub    $0xc,%esp
80101e43:	56                   	push   %esi
80101e44:	e8 37 f9 ff ff       	call   80101780 <ilock>
    if(ip->type != T_DIR){
80101e49:	83 c4 10             	add    $0x10,%esp
80101e4c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e51:	0f 85 cd 00 00 00    	jne    80101f24 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e57:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e5a:	85 c0                	test   %eax,%eax
80101e5c:	74 09                	je     80101e67 <namex+0xd7>
80101e5e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e61:	0f 84 22 01 00 00    	je     80101f89 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e67:	83 ec 04             	sub    $0x4,%esp
80101e6a:	6a 00                	push   $0x0
80101e6c:	ff 75 e4             	push   -0x1c(%ebp)
80101e6f:	56                   	push   %esi
80101e70:	e8 6b fe ff ff       	call   80101ce0 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e75:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101e78:	83 c4 10             	add    $0x10,%esp
80101e7b:	89 c7                	mov    %eax,%edi
80101e7d:	85 c0                	test   %eax,%eax
80101e7f:	0f 84 e1 00 00 00    	je     80101f66 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e85:	83 ec 0c             	sub    $0xc,%esp
80101e88:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101e8b:	52                   	push   %edx
80101e8c:	e8 1f 32 00 00       	call   801050b0 <holdingsleep>
80101e91:	83 c4 10             	add    $0x10,%esp
80101e94:	85 c0                	test   %eax,%eax
80101e96:	0f 84 30 01 00 00    	je     80101fcc <namex+0x23c>
80101e9c:	8b 56 08             	mov    0x8(%esi),%edx
80101e9f:	85 d2                	test   %edx,%edx
80101ea1:	0f 8e 25 01 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101ea7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101eaa:	83 ec 0c             	sub    $0xc,%esp
80101ead:	52                   	push   %edx
80101eae:	e8 bd 31 00 00       	call   80105070 <releasesleep>
  iput(ip);
80101eb3:	89 34 24             	mov    %esi,(%esp)
80101eb6:	89 fe                	mov    %edi,%esi
80101eb8:	e8 f3 f9 ff ff       	call   801018b0 <iput>
80101ebd:	83 c4 10             	add    $0x10,%esp
80101ec0:	e9 16 ff ff ff       	jmp    80101ddb <namex+0x4b>
80101ec5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101ec8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101ecb:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
80101ece:	83 ec 04             	sub    $0x4,%esp
80101ed1:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101ed4:	50                   	push   %eax
80101ed5:	53                   	push   %ebx
    name[len] = 0;
80101ed6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101ed8:	ff 75 e4             	push   -0x1c(%ebp)
80101edb:	e8 50 35 00 00       	call   80105430 <memmove>
    name[len] = 0;
80101ee0:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101ee3:	83 c4 10             	add    $0x10,%esp
80101ee6:	c6 02 00             	movb   $0x0,(%edx)
80101ee9:	e9 41 ff ff ff       	jmp    80101e2f <namex+0x9f>
80101eee:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ef0:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101ef3:	85 c0                	test   %eax,%eax
80101ef5:	0f 85 be 00 00 00    	jne    80101fb9 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
80101efb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101efe:	89 f0                	mov    %esi,%eax
80101f00:	5b                   	pop    %ebx
80101f01:	5e                   	pop    %esi
80101f02:	5f                   	pop    %edi
80101f03:	5d                   	pop    %ebp
80101f04:	c3                   	ret    
  while(*path != '/' && *path != 0)
80101f05:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f08:	89 df                	mov    %ebx,%edi
80101f0a:	31 c0                	xor    %eax,%eax
80101f0c:	eb c0                	jmp    80101ece <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
80101f0e:	ba 01 00 00 00       	mov    $0x1,%edx
80101f13:	b8 01 00 00 00       	mov    $0x1,%eax
80101f18:	e8 33 f4 ff ff       	call   80101350 <iget>
80101f1d:	89 c6                	mov    %eax,%esi
80101f1f:	e9 b7 fe ff ff       	jmp    80101ddb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f24:	83 ec 0c             	sub    $0xc,%esp
80101f27:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f2a:	53                   	push   %ebx
80101f2b:	e8 80 31 00 00       	call   801050b0 <holdingsleep>
80101f30:	83 c4 10             	add    $0x10,%esp
80101f33:	85 c0                	test   %eax,%eax
80101f35:	0f 84 91 00 00 00    	je     80101fcc <namex+0x23c>
80101f3b:	8b 46 08             	mov    0x8(%esi),%eax
80101f3e:	85 c0                	test   %eax,%eax
80101f40:	0f 8e 86 00 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f46:	83 ec 0c             	sub    $0xc,%esp
80101f49:	53                   	push   %ebx
80101f4a:	e8 21 31 00 00       	call   80105070 <releasesleep>
  iput(ip);
80101f4f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f52:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f54:	e8 57 f9 ff ff       	call   801018b0 <iput>
      return 0;
80101f59:	83 c4 10             	add    $0x10,%esp
}
80101f5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f5f:	89 f0                	mov    %esi,%eax
80101f61:	5b                   	pop    %ebx
80101f62:	5e                   	pop    %esi
80101f63:	5f                   	pop    %edi
80101f64:	5d                   	pop    %ebp
80101f65:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f66:	83 ec 0c             	sub    $0xc,%esp
80101f69:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101f6c:	52                   	push   %edx
80101f6d:	e8 3e 31 00 00       	call   801050b0 <holdingsleep>
80101f72:	83 c4 10             	add    $0x10,%esp
80101f75:	85 c0                	test   %eax,%eax
80101f77:	74 53                	je     80101fcc <namex+0x23c>
80101f79:	8b 4e 08             	mov    0x8(%esi),%ecx
80101f7c:	85 c9                	test   %ecx,%ecx
80101f7e:	7e 4c                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f80:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f83:	83 ec 0c             	sub    $0xc,%esp
80101f86:	52                   	push   %edx
80101f87:	eb c1                	jmp    80101f4a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f89:	83 ec 0c             	sub    $0xc,%esp
80101f8c:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f8f:	53                   	push   %ebx
80101f90:	e8 1b 31 00 00       	call   801050b0 <holdingsleep>
80101f95:	83 c4 10             	add    $0x10,%esp
80101f98:	85 c0                	test   %eax,%eax
80101f9a:	74 30                	je     80101fcc <namex+0x23c>
80101f9c:	8b 7e 08             	mov    0x8(%esi),%edi
80101f9f:	85 ff                	test   %edi,%edi
80101fa1:	7e 29                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101fa3:	83 ec 0c             	sub    $0xc,%esp
80101fa6:	53                   	push   %ebx
80101fa7:	e8 c4 30 00 00       	call   80105070 <releasesleep>
}
80101fac:	83 c4 10             	add    $0x10,%esp
}
80101faf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fb2:	89 f0                	mov    %esi,%eax
80101fb4:	5b                   	pop    %ebx
80101fb5:	5e                   	pop    %esi
80101fb6:	5f                   	pop    %edi
80101fb7:	5d                   	pop    %ebp
80101fb8:	c3                   	ret    
    iput(ip);
80101fb9:	83 ec 0c             	sub    $0xc,%esp
80101fbc:	56                   	push   %esi
    return 0;
80101fbd:	31 f6                	xor    %esi,%esi
    iput(ip);
80101fbf:	e8 ec f8 ff ff       	call   801018b0 <iput>
    return 0;
80101fc4:	83 c4 10             	add    $0x10,%esp
80101fc7:	e9 2f ff ff ff       	jmp    80101efb <namex+0x16b>
    panic("iunlock");
80101fcc:	83 ec 0c             	sub    $0xc,%esp
80101fcf:	68 7f 81 10 80       	push   $0x8010817f
80101fd4:	e8 a7 e3 ff ff       	call   80100380 <panic>
80101fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101fe0 <dirlink>:
{
80101fe0:	55                   	push   %ebp
80101fe1:	89 e5                	mov    %esp,%ebp
80101fe3:	57                   	push   %edi
80101fe4:	56                   	push   %esi
80101fe5:	53                   	push   %ebx
80101fe6:	83 ec 20             	sub    $0x20,%esp
80101fe9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101fec:	6a 00                	push   $0x0
80101fee:	ff 75 0c             	push   0xc(%ebp)
80101ff1:	53                   	push   %ebx
80101ff2:	e8 e9 fc ff ff       	call   80101ce0 <dirlookup>
80101ff7:	83 c4 10             	add    $0x10,%esp
80101ffa:	85 c0                	test   %eax,%eax
80101ffc:	75 67                	jne    80102065 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ffe:	8b 7b 58             	mov    0x58(%ebx),%edi
80102001:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102004:	85 ff                	test   %edi,%edi
80102006:	74 29                	je     80102031 <dirlink+0x51>
80102008:	31 ff                	xor    %edi,%edi
8010200a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010200d:	eb 09                	jmp    80102018 <dirlink+0x38>
8010200f:	90                   	nop
80102010:	83 c7 10             	add    $0x10,%edi
80102013:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102016:	73 19                	jae    80102031 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102018:	6a 10                	push   $0x10
8010201a:	57                   	push   %edi
8010201b:	56                   	push   %esi
8010201c:	53                   	push   %ebx
8010201d:	e8 6e fa ff ff       	call   80101a90 <readi>
80102022:	83 c4 10             	add    $0x10,%esp
80102025:	83 f8 10             	cmp    $0x10,%eax
80102028:	75 4e                	jne    80102078 <dirlink+0x98>
    if(de.inum == 0)
8010202a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010202f:	75 df                	jne    80102010 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102031:	83 ec 04             	sub    $0x4,%esp
80102034:	8d 45 da             	lea    -0x26(%ebp),%eax
80102037:	6a 0e                	push   $0xe
80102039:	ff 75 0c             	push   0xc(%ebp)
8010203c:	50                   	push   %eax
8010203d:	e8 ae 34 00 00       	call   801054f0 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102042:	6a 10                	push   $0x10
  de.inum = inum;
80102044:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102047:	57                   	push   %edi
80102048:	56                   	push   %esi
80102049:	53                   	push   %ebx
  de.inum = inum;
8010204a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010204e:	e8 3d fb ff ff       	call   80101b90 <writei>
80102053:	83 c4 20             	add    $0x20,%esp
80102056:	83 f8 10             	cmp    $0x10,%eax
80102059:	75 2a                	jne    80102085 <dirlink+0xa5>
  return 0;
8010205b:	31 c0                	xor    %eax,%eax
}
8010205d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102060:	5b                   	pop    %ebx
80102061:	5e                   	pop    %esi
80102062:	5f                   	pop    %edi
80102063:	5d                   	pop    %ebp
80102064:	c3                   	ret    
    iput(ip);
80102065:	83 ec 0c             	sub    $0xc,%esp
80102068:	50                   	push   %eax
80102069:	e8 42 f8 ff ff       	call   801018b0 <iput>
    return -1;
8010206e:	83 c4 10             	add    $0x10,%esp
80102071:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102076:	eb e5                	jmp    8010205d <dirlink+0x7d>
      panic("dirlink read");
80102078:	83 ec 0c             	sub    $0xc,%esp
8010207b:	68 a8 81 10 80       	push   $0x801081a8
80102080:	e8 fb e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102085:	83 ec 0c             	sub    $0xc,%esp
80102088:	68 fa 89 10 80       	push   $0x801089fa
8010208d:	e8 ee e2 ff ff       	call   80100380 <panic>
80102092:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020a0 <namei>:

struct inode*
namei(char *path)
{
801020a0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801020a1:	31 d2                	xor    %edx,%edx
{
801020a3:	89 e5                	mov    %esp,%ebp
801020a5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801020a8:	8b 45 08             	mov    0x8(%ebp),%eax
801020ab:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801020ae:	e8 dd fc ff ff       	call   80101d90 <namex>
}
801020b3:	c9                   	leave  
801020b4:	c3                   	ret    
801020b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020c0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020c0:	55                   	push   %ebp
  return namex(path, 1, name);
801020c1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020c6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020cb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020ce:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020cf:	e9 bc fc ff ff       	jmp    80101d90 <namex>
801020d4:	66 90                	xchg   %ax,%ax
801020d6:	66 90                	xchg   %ax,%ax
801020d8:	66 90                	xchg   %ax,%ax
801020da:	66 90                	xchg   %ax,%ax
801020dc:	66 90                	xchg   %ax,%ax
801020de:	66 90                	xchg   %ax,%ax

801020e0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801020e0:	55                   	push   %ebp
801020e1:	89 e5                	mov    %esp,%ebp
801020e3:	57                   	push   %edi
801020e4:	56                   	push   %esi
801020e5:	53                   	push   %ebx
801020e6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801020e9:	85 c0                	test   %eax,%eax
801020eb:	0f 84 b4 00 00 00    	je     801021a5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801020f1:	8b 70 08             	mov    0x8(%eax),%esi
801020f4:	89 c3                	mov    %eax,%ebx
801020f6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801020fc:	0f 87 96 00 00 00    	ja     80102198 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102102:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102107:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010210e:	66 90                	xchg   %ax,%ax
80102110:	89 ca                	mov    %ecx,%edx
80102112:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102113:	83 e0 c0             	and    $0xffffffc0,%eax
80102116:	3c 40                	cmp    $0x40,%al
80102118:	75 f6                	jne    80102110 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010211a:	31 ff                	xor    %edi,%edi
8010211c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102121:	89 f8                	mov    %edi,%eax
80102123:	ee                   	out    %al,(%dx)
80102124:	b8 01 00 00 00       	mov    $0x1,%eax
80102129:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010212e:	ee                   	out    %al,(%dx)
8010212f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102134:	89 f0                	mov    %esi,%eax
80102136:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102137:	89 f0                	mov    %esi,%eax
80102139:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010213e:	c1 f8 08             	sar    $0x8,%eax
80102141:	ee                   	out    %al,(%dx)
80102142:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102147:	89 f8                	mov    %edi,%eax
80102149:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010214a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010214e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102153:	c1 e0 04             	shl    $0x4,%eax
80102156:	83 e0 10             	and    $0x10,%eax
80102159:	83 c8 e0             	or     $0xffffffe0,%eax
8010215c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010215d:	f6 03 04             	testb  $0x4,(%ebx)
80102160:	75 16                	jne    80102178 <idestart+0x98>
80102162:	b8 20 00 00 00       	mov    $0x20,%eax
80102167:	89 ca                	mov    %ecx,%edx
80102169:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010216a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010216d:	5b                   	pop    %ebx
8010216e:	5e                   	pop    %esi
8010216f:	5f                   	pop    %edi
80102170:	5d                   	pop    %ebp
80102171:	c3                   	ret    
80102172:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102178:	b8 30 00 00 00       	mov    $0x30,%eax
8010217d:	89 ca                	mov    %ecx,%edx
8010217f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102180:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102185:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102188:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010218d:	fc                   	cld    
8010218e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102190:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102193:	5b                   	pop    %ebx
80102194:	5e                   	pop    %esi
80102195:	5f                   	pop    %edi
80102196:	5d                   	pop    %ebp
80102197:	c3                   	ret    
    panic("incorrect blockno");
80102198:	83 ec 0c             	sub    $0xc,%esp
8010219b:	68 14 82 10 80       	push   $0x80108214
801021a0:	e8 db e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021a5:	83 ec 0c             	sub    $0xc,%esp
801021a8:	68 0b 82 10 80       	push   $0x8010820b
801021ad:	e8 ce e1 ff ff       	call   80100380 <panic>
801021b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021c0 <ideinit>:
{
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021c6:	68 26 82 10 80       	push   $0x80108226
801021cb:	68 20 26 11 80       	push   $0x80112620
801021d0:	e8 2b 2f 00 00       	call   80105100 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021d5:	58                   	pop    %eax
801021d6:	a1 a4 27 11 80       	mov    0x801127a4,%eax
801021db:	5a                   	pop    %edx
801021dc:	83 e8 01             	sub    $0x1,%eax
801021df:	50                   	push   %eax
801021e0:	6a 0e                	push   $0xe
801021e2:	e8 99 02 00 00       	call   80102480 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021e7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021ea:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021ef:	90                   	nop
801021f0:	ec                   	in     (%dx),%al
801021f1:	83 e0 c0             	and    $0xffffffc0,%eax
801021f4:	3c 40                	cmp    $0x40,%al
801021f6:	75 f8                	jne    801021f0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021f8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801021fd:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102202:	ee                   	out    %al,(%dx)
80102203:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102208:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010220d:	eb 06                	jmp    80102215 <ideinit+0x55>
8010220f:	90                   	nop
  for(i=0; i<1000; i++){
80102210:	83 e9 01             	sub    $0x1,%ecx
80102213:	74 0f                	je     80102224 <ideinit+0x64>
80102215:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102216:	84 c0                	test   %al,%al
80102218:	74 f6                	je     80102210 <ideinit+0x50>
      havedisk1 = 1;
8010221a:	c7 05 00 26 11 80 01 	movl   $0x1,0x80112600
80102221:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102224:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102229:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010222e:	ee                   	out    %al,(%dx)
}
8010222f:	c9                   	leave  
80102230:	c3                   	ret    
80102231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010223f:	90                   	nop

80102240 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102240:	55                   	push   %ebp
80102241:	89 e5                	mov    %esp,%ebp
80102243:	57                   	push   %edi
80102244:	56                   	push   %esi
80102245:	53                   	push   %ebx
80102246:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102249:	68 20 26 11 80       	push   $0x80112620
8010224e:	e8 7d 30 00 00       	call   801052d0 <acquire>

  if((b = idequeue) == 0){
80102253:	8b 1d 04 26 11 80    	mov    0x80112604,%ebx
80102259:	83 c4 10             	add    $0x10,%esp
8010225c:	85 db                	test   %ebx,%ebx
8010225e:	74 63                	je     801022c3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102260:	8b 43 58             	mov    0x58(%ebx),%eax
80102263:	a3 04 26 11 80       	mov    %eax,0x80112604

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102268:	8b 33                	mov    (%ebx),%esi
8010226a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102270:	75 2f                	jne    801022a1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102272:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010227e:	66 90                	xchg   %ax,%ax
80102280:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102281:	89 c1                	mov    %eax,%ecx
80102283:	83 e1 c0             	and    $0xffffffc0,%ecx
80102286:	80 f9 40             	cmp    $0x40,%cl
80102289:	75 f5                	jne    80102280 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010228b:	a8 21                	test   $0x21,%al
8010228d:	75 12                	jne    801022a1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010228f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102292:	b9 80 00 00 00       	mov    $0x80,%ecx
80102297:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010229c:	fc                   	cld    
8010229d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010229f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801022a1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801022a4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801022a7:	83 ce 02             	or     $0x2,%esi
801022aa:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801022ac:	53                   	push   %ebx
801022ad:	e8 5e 25 00 00       	call   80104810 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022b2:	a1 04 26 11 80       	mov    0x80112604,%eax
801022b7:	83 c4 10             	add    $0x10,%esp
801022ba:	85 c0                	test   %eax,%eax
801022bc:	74 05                	je     801022c3 <ideintr+0x83>
    idestart(idequeue);
801022be:	e8 1d fe ff ff       	call   801020e0 <idestart>
    release(&idelock);
801022c3:	83 ec 0c             	sub    $0xc,%esp
801022c6:	68 20 26 11 80       	push   $0x80112620
801022cb:	e8 a0 2f 00 00       	call   80105270 <release>

  release(&idelock);
}
801022d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022d3:	5b                   	pop    %ebx
801022d4:	5e                   	pop    %esi
801022d5:	5f                   	pop    %edi
801022d6:	5d                   	pop    %ebp
801022d7:	c3                   	ret    
801022d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022df:	90                   	nop

801022e0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801022e0:	55                   	push   %ebp
801022e1:	89 e5                	mov    %esp,%ebp
801022e3:	53                   	push   %ebx
801022e4:	83 ec 10             	sub    $0x10,%esp
801022e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801022ea:	8d 43 0c             	lea    0xc(%ebx),%eax
801022ed:	50                   	push   %eax
801022ee:	e8 bd 2d 00 00       	call   801050b0 <holdingsleep>
801022f3:	83 c4 10             	add    $0x10,%esp
801022f6:	85 c0                	test   %eax,%eax
801022f8:	0f 84 c3 00 00 00    	je     801023c1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022fe:	8b 03                	mov    (%ebx),%eax
80102300:	83 e0 06             	and    $0x6,%eax
80102303:	83 f8 02             	cmp    $0x2,%eax
80102306:	0f 84 a8 00 00 00    	je     801023b4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010230c:	8b 53 04             	mov    0x4(%ebx),%edx
8010230f:	85 d2                	test   %edx,%edx
80102311:	74 0d                	je     80102320 <iderw+0x40>
80102313:	a1 00 26 11 80       	mov    0x80112600,%eax
80102318:	85 c0                	test   %eax,%eax
8010231a:	0f 84 87 00 00 00    	je     801023a7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102320:	83 ec 0c             	sub    $0xc,%esp
80102323:	68 20 26 11 80       	push   $0x80112620
80102328:	e8 a3 2f 00 00       	call   801052d0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010232d:	a1 04 26 11 80       	mov    0x80112604,%eax
  b->qnext = 0;
80102332:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102339:	83 c4 10             	add    $0x10,%esp
8010233c:	85 c0                	test   %eax,%eax
8010233e:	74 60                	je     801023a0 <iderw+0xc0>
80102340:	89 c2                	mov    %eax,%edx
80102342:	8b 40 58             	mov    0x58(%eax),%eax
80102345:	85 c0                	test   %eax,%eax
80102347:	75 f7                	jne    80102340 <iderw+0x60>
80102349:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010234c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010234e:	39 1d 04 26 11 80    	cmp    %ebx,0x80112604
80102354:	74 3a                	je     80102390 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102356:	8b 03                	mov    (%ebx),%eax
80102358:	83 e0 06             	and    $0x6,%eax
8010235b:	83 f8 02             	cmp    $0x2,%eax
8010235e:	74 1b                	je     8010237b <iderw+0x9b>
    sleep(b, &idelock);
80102360:	83 ec 08             	sub    $0x8,%esp
80102363:	68 20 26 11 80       	push   $0x80112620
80102368:	53                   	push   %ebx
80102369:	e8 e2 23 00 00       	call   80104750 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010236e:	8b 03                	mov    (%ebx),%eax
80102370:	83 c4 10             	add    $0x10,%esp
80102373:	83 e0 06             	and    $0x6,%eax
80102376:	83 f8 02             	cmp    $0x2,%eax
80102379:	75 e5                	jne    80102360 <iderw+0x80>
  }


  release(&idelock);
8010237b:	c7 45 08 20 26 11 80 	movl   $0x80112620,0x8(%ebp)
}
80102382:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102385:	c9                   	leave  
  release(&idelock);
80102386:	e9 e5 2e 00 00       	jmp    80105270 <release>
8010238b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010238f:	90                   	nop
    idestart(b);
80102390:	89 d8                	mov    %ebx,%eax
80102392:	e8 49 fd ff ff       	call   801020e0 <idestart>
80102397:	eb bd                	jmp    80102356 <iderw+0x76>
80102399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023a0:	ba 04 26 11 80       	mov    $0x80112604,%edx
801023a5:	eb a5                	jmp    8010234c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801023a7:	83 ec 0c             	sub    $0xc,%esp
801023aa:	68 55 82 10 80       	push   $0x80108255
801023af:	e8 cc df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023b4:	83 ec 0c             	sub    $0xc,%esp
801023b7:	68 40 82 10 80       	push   $0x80108240
801023bc:	e8 bf df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023c1:	83 ec 0c             	sub    $0xc,%esp
801023c4:	68 2a 82 10 80       	push   $0x8010822a
801023c9:	e8 b2 df ff ff       	call   80100380 <panic>
801023ce:	66 90                	xchg   %ax,%ax

801023d0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023d0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023d1:	c7 05 54 26 11 80 00 	movl   $0xfec00000,0x80112654
801023d8:	00 c0 fe 
{
801023db:	89 e5                	mov    %esp,%ebp
801023dd:	56                   	push   %esi
801023de:	53                   	push   %ebx
  ioapic->reg = reg;
801023df:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023e6:	00 00 00 
  return ioapic->data;
801023e9:	8b 15 54 26 11 80    	mov    0x80112654,%edx
801023ef:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023f2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023f8:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023fe:	0f b6 15 a0 27 11 80 	movzbl 0x801127a0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102405:	c1 ee 10             	shr    $0x10,%esi
80102408:	89 f0                	mov    %esi,%eax
8010240a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010240d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102410:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102413:	39 c2                	cmp    %eax,%edx
80102415:	74 16                	je     8010242d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102417:	83 ec 0c             	sub    $0xc,%esp
8010241a:	68 74 82 10 80       	push   $0x80108274
8010241f:	e8 7c e2 ff ff       	call   801006a0 <cprintf>
  ioapic->reg = reg;
80102424:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
8010242a:	83 c4 10             	add    $0x10,%esp
8010242d:	83 c6 21             	add    $0x21,%esi
{
80102430:	ba 10 00 00 00       	mov    $0x10,%edx
80102435:	b8 20 00 00 00       	mov    $0x20,%eax
8010243a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102440:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102442:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102444:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
  for(i = 0; i <= maxintr; i++){
8010244a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010244d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102453:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102456:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80102459:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010245c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010245e:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
80102464:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010246b:	39 f0                	cmp    %esi,%eax
8010246d:	75 d1                	jne    80102440 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010246f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102472:	5b                   	pop    %ebx
80102473:	5e                   	pop    %esi
80102474:	5d                   	pop    %ebp
80102475:	c3                   	ret    
80102476:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010247d:	8d 76 00             	lea    0x0(%esi),%esi

80102480 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102480:	55                   	push   %ebp
  ioapic->reg = reg;
80102481:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
{
80102487:	89 e5                	mov    %esp,%ebp
80102489:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010248c:	8d 50 20             	lea    0x20(%eax),%edx
8010248f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102493:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102495:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010249b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010249e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024a4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024a6:	a1 54 26 11 80       	mov    0x80112654,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024ab:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801024ae:	89 50 10             	mov    %edx,0x10(%eax)
}
801024b1:	5d                   	pop    %ebp
801024b2:	c3                   	ret    
801024b3:	66 90                	xchg   %ax,%ax
801024b5:	66 90                	xchg   %ax,%ax
801024b7:	66 90                	xchg   %ax,%ax
801024b9:	66 90                	xchg   %ax,%ax
801024bb:	66 90                	xchg   %ax,%ax
801024bd:	66 90                	xchg   %ax,%ax
801024bf:	90                   	nop

801024c0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801024c0:	55                   	push   %ebp
801024c1:	89 e5                	mov    %esp,%ebp
801024c3:	53                   	push   %ebx
801024c4:	83 ec 04             	sub    $0x4,%esp
801024c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024ca:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024d0:	75 76                	jne    80102548 <kfree+0x88>
801024d2:	81 fb f0 7d 11 80    	cmp    $0x80117df0,%ebx
801024d8:	72 6e                	jb     80102548 <kfree+0x88>
801024da:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801024e0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801024e5:	77 61                	ja     80102548 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801024e7:	83 ec 04             	sub    $0x4,%esp
801024ea:	68 00 10 00 00       	push   $0x1000
801024ef:	6a 01                	push   $0x1
801024f1:	53                   	push   %ebx
801024f2:	e8 99 2e 00 00       	call   80105390 <memset>

  if(kmem.use_lock)
801024f7:	8b 15 94 26 11 80    	mov    0x80112694,%edx
801024fd:	83 c4 10             	add    $0x10,%esp
80102500:	85 d2                	test   %edx,%edx
80102502:	75 1c                	jne    80102520 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102504:	a1 98 26 11 80       	mov    0x80112698,%eax
80102509:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010250b:	a1 94 26 11 80       	mov    0x80112694,%eax
  kmem.freelist = r;
80102510:	89 1d 98 26 11 80    	mov    %ebx,0x80112698
  if(kmem.use_lock)
80102516:	85 c0                	test   %eax,%eax
80102518:	75 1e                	jne    80102538 <kfree+0x78>
    release(&kmem.lock);
}
8010251a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010251d:	c9                   	leave  
8010251e:	c3                   	ret    
8010251f:	90                   	nop
    acquire(&kmem.lock);
80102520:	83 ec 0c             	sub    $0xc,%esp
80102523:	68 60 26 11 80       	push   $0x80112660
80102528:	e8 a3 2d 00 00       	call   801052d0 <acquire>
8010252d:	83 c4 10             	add    $0x10,%esp
80102530:	eb d2                	jmp    80102504 <kfree+0x44>
80102532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102538:	c7 45 08 60 26 11 80 	movl   $0x80112660,0x8(%ebp)
}
8010253f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102542:	c9                   	leave  
    release(&kmem.lock);
80102543:	e9 28 2d 00 00       	jmp    80105270 <release>
    panic("kfree");
80102548:	83 ec 0c             	sub    $0xc,%esp
8010254b:	68 a6 82 10 80       	push   $0x801082a6
80102550:	e8 2b de ff ff       	call   80100380 <panic>
80102555:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010255c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102560 <freerange>:
{
80102560:	55                   	push   %ebp
80102561:	89 e5                	mov    %esp,%ebp
80102563:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102564:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102567:	8b 75 0c             	mov    0xc(%ebp),%esi
8010256a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010256b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102571:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102577:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010257d:	39 de                	cmp    %ebx,%esi
8010257f:	72 23                	jb     801025a4 <freerange+0x44>
80102581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102588:	83 ec 0c             	sub    $0xc,%esp
8010258b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102591:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102597:	50                   	push   %eax
80102598:	e8 23 ff ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010259d:	83 c4 10             	add    $0x10,%esp
801025a0:	39 f3                	cmp    %esi,%ebx
801025a2:	76 e4                	jbe    80102588 <freerange+0x28>
}
801025a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025a7:	5b                   	pop    %ebx
801025a8:	5e                   	pop    %esi
801025a9:	5d                   	pop    %ebp
801025aa:	c3                   	ret    
801025ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025af:	90                   	nop

801025b0 <kinit2>:
{
801025b0:	55                   	push   %ebp
801025b1:	89 e5                	mov    %esp,%ebp
801025b3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025b4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025b7:	8b 75 0c             	mov    0xc(%ebp),%esi
801025ba:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025bb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025c1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025cd:	39 de                	cmp    %ebx,%esi
801025cf:	72 23                	jb     801025f4 <kinit2+0x44>
801025d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025d8:	83 ec 0c             	sub    $0xc,%esp
801025db:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025e1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025e7:	50                   	push   %eax
801025e8:	e8 d3 fe ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025ed:	83 c4 10             	add    $0x10,%esp
801025f0:	39 de                	cmp    %ebx,%esi
801025f2:	73 e4                	jae    801025d8 <kinit2+0x28>
  kmem.use_lock = 1;
801025f4:	c7 05 94 26 11 80 01 	movl   $0x1,0x80112694
801025fb:	00 00 00 
}
801025fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102601:	5b                   	pop    %ebx
80102602:	5e                   	pop    %esi
80102603:	5d                   	pop    %ebp
80102604:	c3                   	ret    
80102605:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010260c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102610 <kinit1>:
{
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	56                   	push   %esi
80102614:	53                   	push   %ebx
80102615:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102618:	83 ec 08             	sub    $0x8,%esp
8010261b:	68 ac 82 10 80       	push   $0x801082ac
80102620:	68 60 26 11 80       	push   $0x80112660
80102625:	e8 d6 2a 00 00       	call   80105100 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010262a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010262d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102630:	c7 05 94 26 11 80 00 	movl   $0x0,0x80112694
80102637:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010263a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102640:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102646:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010264c:	39 de                	cmp    %ebx,%esi
8010264e:	72 1c                	jb     8010266c <kinit1+0x5c>
    kfree(p);
80102650:	83 ec 0c             	sub    $0xc,%esp
80102653:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102659:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010265f:	50                   	push   %eax
80102660:	e8 5b fe ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102665:	83 c4 10             	add    $0x10,%esp
80102668:	39 de                	cmp    %ebx,%esi
8010266a:	73 e4                	jae    80102650 <kinit1+0x40>
}
8010266c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010266f:	5b                   	pop    %ebx
80102670:	5e                   	pop    %esi
80102671:	5d                   	pop    %ebp
80102672:	c3                   	ret    
80102673:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010267a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102680 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102680:	a1 94 26 11 80       	mov    0x80112694,%eax
80102685:	85 c0                	test   %eax,%eax
80102687:	75 1f                	jne    801026a8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102689:	a1 98 26 11 80       	mov    0x80112698,%eax
  if(r)
8010268e:	85 c0                	test   %eax,%eax
80102690:	74 0e                	je     801026a0 <kalloc+0x20>
    kmem.freelist = r->next;
80102692:	8b 10                	mov    (%eax),%edx
80102694:	89 15 98 26 11 80    	mov    %edx,0x80112698
  if(kmem.use_lock)
8010269a:	c3                   	ret    
8010269b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010269f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
801026a0:	c3                   	ret    
801026a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
801026a8:	55                   	push   %ebp
801026a9:	89 e5                	mov    %esp,%ebp
801026ab:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801026ae:	68 60 26 11 80       	push   $0x80112660
801026b3:	e8 18 2c 00 00       	call   801052d0 <acquire>
  r = kmem.freelist;
801026b8:	a1 98 26 11 80       	mov    0x80112698,%eax
  if(kmem.use_lock)
801026bd:	8b 15 94 26 11 80    	mov    0x80112694,%edx
  if(r)
801026c3:	83 c4 10             	add    $0x10,%esp
801026c6:	85 c0                	test   %eax,%eax
801026c8:	74 08                	je     801026d2 <kalloc+0x52>
    kmem.freelist = r->next;
801026ca:	8b 08                	mov    (%eax),%ecx
801026cc:	89 0d 98 26 11 80    	mov    %ecx,0x80112698
  if(kmem.use_lock)
801026d2:	85 d2                	test   %edx,%edx
801026d4:	74 16                	je     801026ec <kalloc+0x6c>
    release(&kmem.lock);
801026d6:	83 ec 0c             	sub    $0xc,%esp
801026d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026dc:	68 60 26 11 80       	push   $0x80112660
801026e1:	e8 8a 2b 00 00       	call   80105270 <release>
  return (char*)r;
801026e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801026e9:	83 c4 10             	add    $0x10,%esp
}
801026ec:	c9                   	leave  
801026ed:	c3                   	ret    
801026ee:	66 90                	xchg   %ax,%ax

801026f0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026f0:	ba 64 00 00 00       	mov    $0x64,%edx
801026f5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801026f6:	a8 01                	test   $0x1,%al
801026f8:	0f 84 c2 00 00 00    	je     801027c0 <kbdgetc+0xd0>
{
801026fe:	55                   	push   %ebp
801026ff:	ba 60 00 00 00       	mov    $0x60,%edx
80102704:	89 e5                	mov    %esp,%ebp
80102706:	53                   	push   %ebx
80102707:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102708:	8b 1d 9c 26 11 80    	mov    0x8011269c,%ebx
  data = inb(KBDATAP);
8010270e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102711:	3c e0                	cmp    $0xe0,%al
80102713:	74 5b                	je     80102770 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102715:	89 da                	mov    %ebx,%edx
80102717:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010271a:	84 c0                	test   %al,%al
8010271c:	78 62                	js     80102780 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010271e:	85 d2                	test   %edx,%edx
80102720:	74 09                	je     8010272b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102722:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102725:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102728:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010272b:	0f b6 91 e0 83 10 80 	movzbl -0x7fef7c20(%ecx),%edx
  shift ^= togglecode[data];
80102732:	0f b6 81 e0 82 10 80 	movzbl -0x7fef7d20(%ecx),%eax
  shift |= shiftcode[data];
80102739:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010273b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010273d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010273f:	89 15 9c 26 11 80    	mov    %edx,0x8011269c
  c = charcode[shift & (CTL | SHIFT)][data];
80102745:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102748:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010274b:	8b 04 85 c0 82 10 80 	mov    -0x7fef7d40(,%eax,4),%eax
80102752:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102756:	74 0b                	je     80102763 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102758:	8d 50 9f             	lea    -0x61(%eax),%edx
8010275b:	83 fa 19             	cmp    $0x19,%edx
8010275e:	77 48                	ja     801027a8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102760:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102763:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102766:	c9                   	leave  
80102767:	c3                   	ret    
80102768:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010276f:	90                   	nop
    shift |= E0ESC;
80102770:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102773:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102775:	89 1d 9c 26 11 80    	mov    %ebx,0x8011269c
}
8010277b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010277e:	c9                   	leave  
8010277f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102780:	83 e0 7f             	and    $0x7f,%eax
80102783:	85 d2                	test   %edx,%edx
80102785:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102788:	0f b6 81 e0 83 10 80 	movzbl -0x7fef7c20(%ecx),%eax
8010278f:	83 c8 40             	or     $0x40,%eax
80102792:	0f b6 c0             	movzbl %al,%eax
80102795:	f7 d0                	not    %eax
80102797:	21 d8                	and    %ebx,%eax
}
80102799:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
8010279c:	a3 9c 26 11 80       	mov    %eax,0x8011269c
    return 0;
801027a1:	31 c0                	xor    %eax,%eax
}
801027a3:	c9                   	leave  
801027a4:	c3                   	ret    
801027a5:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801027a8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801027ab:	8d 50 20             	lea    0x20(%eax),%edx
}
801027ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027b1:	c9                   	leave  
      c += 'a' - 'A';
801027b2:	83 f9 1a             	cmp    $0x1a,%ecx
801027b5:	0f 42 c2             	cmovb  %edx,%eax
}
801027b8:	c3                   	ret    
801027b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801027c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801027c5:	c3                   	ret    
801027c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027cd:	8d 76 00             	lea    0x0(%esi),%esi

801027d0 <kbdintr>:

void
kbdintr(void)
{
801027d0:	55                   	push   %ebp
801027d1:	89 e5                	mov    %esp,%ebp
801027d3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801027d6:	68 f0 26 10 80       	push   $0x801026f0
801027db:	e8 a0 e0 ff ff       	call   80100880 <consoleintr>
}
801027e0:	83 c4 10             	add    $0x10,%esp
801027e3:	c9                   	leave  
801027e4:	c3                   	ret    
801027e5:	66 90                	xchg   %ax,%ax
801027e7:	66 90                	xchg   %ax,%ax
801027e9:	66 90                	xchg   %ax,%ax
801027eb:	66 90                	xchg   %ax,%ax
801027ed:	66 90                	xchg   %ax,%ax
801027ef:	90                   	nop

801027f0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801027f0:	a1 a0 26 11 80       	mov    0x801126a0,%eax
801027f5:	85 c0                	test   %eax,%eax
801027f7:	0f 84 cb 00 00 00    	je     801028c8 <lapicinit+0xd8>
  lapic[index] = value;
801027fd:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102804:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102807:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010280a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102811:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102814:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102817:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010281e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102821:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102824:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010282b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010282e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102831:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102838:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010283b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010283e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102845:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102848:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010284b:	8b 50 30             	mov    0x30(%eax),%edx
8010284e:	c1 ea 10             	shr    $0x10,%edx
80102851:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102857:	75 77                	jne    801028d0 <lapicinit+0xe0>
  lapic[index] = value;
80102859:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102860:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102863:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102866:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010286d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102870:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102873:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010287a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010287d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102880:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102887:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010288a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010288d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102894:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102897:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010289a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801028a1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801028a4:	8b 50 20             	mov    0x20(%eax),%edx
801028a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028ae:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801028b0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801028b6:	80 e6 10             	and    $0x10,%dh
801028b9:	75 f5                	jne    801028b0 <lapicinit+0xc0>
  lapic[index] = value;
801028bb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801028c2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028c5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801028c8:	c3                   	ret    
801028c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801028d0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801028d7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028da:	8b 50 20             	mov    0x20(%eax),%edx
}
801028dd:	e9 77 ff ff ff       	jmp    80102859 <lapicinit+0x69>
801028e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801028f0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
801028f0:	a1 a0 26 11 80       	mov    0x801126a0,%eax
801028f5:	85 c0                	test   %eax,%eax
801028f7:	74 07                	je     80102900 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
801028f9:	8b 40 20             	mov    0x20(%eax),%eax
801028fc:	c1 e8 18             	shr    $0x18,%eax
801028ff:	c3                   	ret    
    return 0;
80102900:	31 c0                	xor    %eax,%eax
}
80102902:	c3                   	ret    
80102903:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010290a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102910 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102910:	a1 a0 26 11 80       	mov    0x801126a0,%eax
80102915:	85 c0                	test   %eax,%eax
80102917:	74 0d                	je     80102926 <lapiceoi+0x16>
  lapic[index] = value;
80102919:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102920:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102923:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102926:	c3                   	ret    
80102927:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010292e:	66 90                	xchg   %ax,%ax

80102930 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102930:	c3                   	ret    
80102931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102938:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010293f:	90                   	nop

80102940 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102940:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102941:	b8 0f 00 00 00       	mov    $0xf,%eax
80102946:	ba 70 00 00 00       	mov    $0x70,%edx
8010294b:	89 e5                	mov    %esp,%ebp
8010294d:	53                   	push   %ebx
8010294e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102951:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102954:	ee                   	out    %al,(%dx)
80102955:	b8 0a 00 00 00       	mov    $0xa,%eax
8010295a:	ba 71 00 00 00       	mov    $0x71,%edx
8010295f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102960:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102962:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102965:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010296b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010296d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102970:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102972:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102975:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102978:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010297e:	a1 a0 26 11 80       	mov    0x801126a0,%eax
80102983:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102989:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010298c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102993:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102996:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102999:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801029a0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029a3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029a6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029ac:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029af:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029b5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029b8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029be:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029c1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029c7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
801029ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029cd:	c9                   	leave  
801029ce:	c3                   	ret    
801029cf:	90                   	nop

801029d0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801029d0:	55                   	push   %ebp
801029d1:	b8 0b 00 00 00       	mov    $0xb,%eax
801029d6:	ba 70 00 00 00       	mov    $0x70,%edx
801029db:	89 e5                	mov    %esp,%ebp
801029dd:	57                   	push   %edi
801029de:	56                   	push   %esi
801029df:	53                   	push   %ebx
801029e0:	83 ec 4c             	sub    $0x4c,%esp
801029e3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029e4:	ba 71 00 00 00       	mov    $0x71,%edx
801029e9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801029ea:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029ed:	bb 70 00 00 00       	mov    $0x70,%ebx
801029f2:	88 45 b3             	mov    %al,-0x4d(%ebp)
801029f5:	8d 76 00             	lea    0x0(%esi),%esi
801029f8:	31 c0                	xor    %eax,%eax
801029fa:	89 da                	mov    %ebx,%edx
801029fc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029fd:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a02:	89 ca                	mov    %ecx,%edx
80102a04:	ec                   	in     (%dx),%al
80102a05:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a08:	89 da                	mov    %ebx,%edx
80102a0a:	b8 02 00 00 00       	mov    $0x2,%eax
80102a0f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a10:	89 ca                	mov    %ecx,%edx
80102a12:	ec                   	in     (%dx),%al
80102a13:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a16:	89 da                	mov    %ebx,%edx
80102a18:	b8 04 00 00 00       	mov    $0x4,%eax
80102a1d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a1e:	89 ca                	mov    %ecx,%edx
80102a20:	ec                   	in     (%dx),%al
80102a21:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a24:	89 da                	mov    %ebx,%edx
80102a26:	b8 07 00 00 00       	mov    $0x7,%eax
80102a2b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a2c:	89 ca                	mov    %ecx,%edx
80102a2e:	ec                   	in     (%dx),%al
80102a2f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a32:	89 da                	mov    %ebx,%edx
80102a34:	b8 08 00 00 00       	mov    $0x8,%eax
80102a39:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a3a:	89 ca                	mov    %ecx,%edx
80102a3c:	ec                   	in     (%dx),%al
80102a3d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a3f:	89 da                	mov    %ebx,%edx
80102a41:	b8 09 00 00 00       	mov    $0x9,%eax
80102a46:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a47:	89 ca                	mov    %ecx,%edx
80102a49:	ec                   	in     (%dx),%al
80102a4a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a4c:	89 da                	mov    %ebx,%edx
80102a4e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a53:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a54:	89 ca                	mov    %ecx,%edx
80102a56:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a57:	84 c0                	test   %al,%al
80102a59:	78 9d                	js     801029f8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102a5b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a5f:	89 fa                	mov    %edi,%edx
80102a61:	0f b6 fa             	movzbl %dl,%edi
80102a64:	89 f2                	mov    %esi,%edx
80102a66:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a69:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a6d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a70:	89 da                	mov    %ebx,%edx
80102a72:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102a75:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a78:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a7c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a7f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a82:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a86:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a89:	31 c0                	xor    %eax,%eax
80102a8b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a8c:	89 ca                	mov    %ecx,%edx
80102a8e:	ec                   	in     (%dx),%al
80102a8f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a92:	89 da                	mov    %ebx,%edx
80102a94:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a97:	b8 02 00 00 00       	mov    $0x2,%eax
80102a9c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a9d:	89 ca                	mov    %ecx,%edx
80102a9f:	ec                   	in     (%dx),%al
80102aa0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aa3:	89 da                	mov    %ebx,%edx
80102aa5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102aa8:	b8 04 00 00 00       	mov    $0x4,%eax
80102aad:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aae:	89 ca                	mov    %ecx,%edx
80102ab0:	ec                   	in     (%dx),%al
80102ab1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab4:	89 da                	mov    %ebx,%edx
80102ab6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102ab9:	b8 07 00 00 00       	mov    $0x7,%eax
80102abe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102abf:	89 ca                	mov    %ecx,%edx
80102ac1:	ec                   	in     (%dx),%al
80102ac2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ac5:	89 da                	mov    %ebx,%edx
80102ac7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102aca:	b8 08 00 00 00       	mov    $0x8,%eax
80102acf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ad0:	89 ca                	mov    %ecx,%edx
80102ad2:	ec                   	in     (%dx),%al
80102ad3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ad6:	89 da                	mov    %ebx,%edx
80102ad8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102adb:	b8 09 00 00 00       	mov    $0x9,%eax
80102ae0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ae1:	89 ca                	mov    %ecx,%edx
80102ae3:	ec                   	in     (%dx),%al
80102ae4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ae7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102aea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102aed:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102af0:	6a 18                	push   $0x18
80102af2:	50                   	push   %eax
80102af3:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102af6:	50                   	push   %eax
80102af7:	e8 e4 28 00 00       	call   801053e0 <memcmp>
80102afc:	83 c4 10             	add    $0x10,%esp
80102aff:	85 c0                	test   %eax,%eax
80102b01:	0f 85 f1 fe ff ff    	jne    801029f8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102b07:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102b0b:	75 78                	jne    80102b85 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102b0d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b10:	89 c2                	mov    %eax,%edx
80102b12:	83 e0 0f             	and    $0xf,%eax
80102b15:	c1 ea 04             	shr    $0x4,%edx
80102b18:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b1b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b1e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b21:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b24:	89 c2                	mov    %eax,%edx
80102b26:	83 e0 0f             	and    $0xf,%eax
80102b29:	c1 ea 04             	shr    $0x4,%edx
80102b2c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b2f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b32:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b35:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b38:	89 c2                	mov    %eax,%edx
80102b3a:	83 e0 0f             	and    $0xf,%eax
80102b3d:	c1 ea 04             	shr    $0x4,%edx
80102b40:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b43:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b46:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b49:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b4c:	89 c2                	mov    %eax,%edx
80102b4e:	83 e0 0f             	and    $0xf,%eax
80102b51:	c1 ea 04             	shr    $0x4,%edx
80102b54:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b57:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b5a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b5d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b60:	89 c2                	mov    %eax,%edx
80102b62:	83 e0 0f             	and    $0xf,%eax
80102b65:	c1 ea 04             	shr    $0x4,%edx
80102b68:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b6b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b6e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b71:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b74:	89 c2                	mov    %eax,%edx
80102b76:	83 e0 0f             	and    $0xf,%eax
80102b79:	c1 ea 04             	shr    $0x4,%edx
80102b7c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b7f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b82:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b85:	8b 75 08             	mov    0x8(%ebp),%esi
80102b88:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b8b:	89 06                	mov    %eax,(%esi)
80102b8d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b90:	89 46 04             	mov    %eax,0x4(%esi)
80102b93:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b96:	89 46 08             	mov    %eax,0x8(%esi)
80102b99:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b9c:	89 46 0c             	mov    %eax,0xc(%esi)
80102b9f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102ba2:	89 46 10             	mov    %eax,0x10(%esi)
80102ba5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ba8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102bab:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102bb2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bb5:	5b                   	pop    %ebx
80102bb6:	5e                   	pop    %esi
80102bb7:	5f                   	pop    %edi
80102bb8:	5d                   	pop    %ebp
80102bb9:	c3                   	ret    
80102bba:	66 90                	xchg   %ax,%ax
80102bbc:	66 90                	xchg   %ax,%ax
80102bbe:	66 90                	xchg   %ax,%ax

80102bc0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102bc0:	8b 0d 08 27 11 80    	mov    0x80112708,%ecx
80102bc6:	85 c9                	test   %ecx,%ecx
80102bc8:	0f 8e 8a 00 00 00    	jle    80102c58 <install_trans+0x98>
{
80102bce:	55                   	push   %ebp
80102bcf:	89 e5                	mov    %esp,%ebp
80102bd1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102bd2:	31 ff                	xor    %edi,%edi
{
80102bd4:	56                   	push   %esi
80102bd5:	53                   	push   %ebx
80102bd6:	83 ec 0c             	sub    $0xc,%esp
80102bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102be0:	a1 f4 26 11 80       	mov    0x801126f4,%eax
80102be5:	83 ec 08             	sub    $0x8,%esp
80102be8:	01 f8                	add    %edi,%eax
80102bea:	83 c0 01             	add    $0x1,%eax
80102bed:	50                   	push   %eax
80102bee:	ff 35 04 27 11 80    	push   0x80112704
80102bf4:	e8 d7 d4 ff ff       	call   801000d0 <bread>
80102bf9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bfb:	58                   	pop    %eax
80102bfc:	5a                   	pop    %edx
80102bfd:	ff 34 bd 0c 27 11 80 	push   -0x7feed8f4(,%edi,4)
80102c04:	ff 35 04 27 11 80    	push   0x80112704
  for (tail = 0; tail < log.lh.n; tail++) {
80102c0a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c0d:	e8 be d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c12:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c15:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c17:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c1a:	68 00 02 00 00       	push   $0x200
80102c1f:	50                   	push   %eax
80102c20:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c23:	50                   	push   %eax
80102c24:	e8 07 28 00 00       	call   80105430 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c29:	89 1c 24             	mov    %ebx,(%esp)
80102c2c:	e8 7f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c31:	89 34 24             	mov    %esi,(%esp)
80102c34:	e8 b7 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c39:	89 1c 24             	mov    %ebx,(%esp)
80102c3c:	e8 af d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c41:	83 c4 10             	add    $0x10,%esp
80102c44:	39 3d 08 27 11 80    	cmp    %edi,0x80112708
80102c4a:	7f 94                	jg     80102be0 <install_trans+0x20>
  }
}
80102c4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c4f:	5b                   	pop    %ebx
80102c50:	5e                   	pop    %esi
80102c51:	5f                   	pop    %edi
80102c52:	5d                   	pop    %ebp
80102c53:	c3                   	ret    
80102c54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c58:	c3                   	ret    
80102c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c60 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c60:	55                   	push   %ebp
80102c61:	89 e5                	mov    %esp,%ebp
80102c63:	53                   	push   %ebx
80102c64:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c67:	ff 35 f4 26 11 80    	push   0x801126f4
80102c6d:	ff 35 04 27 11 80    	push   0x80112704
80102c73:	e8 58 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c78:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c7b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c7d:	a1 08 27 11 80       	mov    0x80112708,%eax
80102c82:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102c85:	85 c0                	test   %eax,%eax
80102c87:	7e 19                	jle    80102ca2 <write_head+0x42>
80102c89:	31 d2                	xor    %edx,%edx
80102c8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c8f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102c90:	8b 0c 95 0c 27 11 80 	mov    -0x7feed8f4(,%edx,4),%ecx
80102c97:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102c9b:	83 c2 01             	add    $0x1,%edx
80102c9e:	39 d0                	cmp    %edx,%eax
80102ca0:	75 ee                	jne    80102c90 <write_head+0x30>
  }
  bwrite(buf);
80102ca2:	83 ec 0c             	sub    $0xc,%esp
80102ca5:	53                   	push   %ebx
80102ca6:	e8 05 d5 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102cab:	89 1c 24             	mov    %ebx,(%esp)
80102cae:	e8 3d d5 ff ff       	call   801001f0 <brelse>
}
80102cb3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102cb6:	83 c4 10             	add    $0x10,%esp
80102cb9:	c9                   	leave  
80102cba:	c3                   	ret    
80102cbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cbf:	90                   	nop

80102cc0 <initlog>:
{
80102cc0:	55                   	push   %ebp
80102cc1:	89 e5                	mov    %esp,%ebp
80102cc3:	53                   	push   %ebx
80102cc4:	83 ec 2c             	sub    $0x2c,%esp
80102cc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102cca:	68 e0 84 10 80       	push   $0x801084e0
80102ccf:	68 c0 26 11 80       	push   $0x801126c0
80102cd4:	e8 27 24 00 00       	call   80105100 <initlock>
  readsb(dev, &sb);
80102cd9:	58                   	pop    %eax
80102cda:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102cdd:	5a                   	pop    %edx
80102cde:	50                   	push   %eax
80102cdf:	53                   	push   %ebx
80102ce0:	e8 3b e8 ff ff       	call   80101520 <readsb>
  log.start = sb.logstart;
80102ce5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102ce8:	59                   	pop    %ecx
  log.dev = dev;
80102ce9:	89 1d 04 27 11 80    	mov    %ebx,0x80112704
  log.size = sb.nlog;
80102cef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102cf2:	a3 f4 26 11 80       	mov    %eax,0x801126f4
  log.size = sb.nlog;
80102cf7:	89 15 f8 26 11 80    	mov    %edx,0x801126f8
  struct buf *buf = bread(log.dev, log.start);
80102cfd:	5a                   	pop    %edx
80102cfe:	50                   	push   %eax
80102cff:	53                   	push   %ebx
80102d00:	e8 cb d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102d05:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102d08:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102d0b:	89 1d 08 27 11 80    	mov    %ebx,0x80112708
  for (i = 0; i < log.lh.n; i++) {
80102d11:	85 db                	test   %ebx,%ebx
80102d13:	7e 1d                	jle    80102d32 <initlog+0x72>
80102d15:	31 d2                	xor    %edx,%edx
80102d17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d1e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102d20:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102d24:	89 0c 95 0c 27 11 80 	mov    %ecx,-0x7feed8f4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d2b:	83 c2 01             	add    $0x1,%edx
80102d2e:	39 d3                	cmp    %edx,%ebx
80102d30:	75 ee                	jne    80102d20 <initlog+0x60>
  brelse(buf);
80102d32:	83 ec 0c             	sub    $0xc,%esp
80102d35:	50                   	push   %eax
80102d36:	e8 b5 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d3b:	e8 80 fe ff ff       	call   80102bc0 <install_trans>
  log.lh.n = 0;
80102d40:	c7 05 08 27 11 80 00 	movl   $0x0,0x80112708
80102d47:	00 00 00 
  write_head(); // clear the log
80102d4a:	e8 11 ff ff ff       	call   80102c60 <write_head>
}
80102d4f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d52:	83 c4 10             	add    $0x10,%esp
80102d55:	c9                   	leave  
80102d56:	c3                   	ret    
80102d57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d5e:	66 90                	xchg   %ax,%ax

80102d60 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d60:	55                   	push   %ebp
80102d61:	89 e5                	mov    %esp,%ebp
80102d63:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d66:	68 c0 26 11 80       	push   $0x801126c0
80102d6b:	e8 60 25 00 00       	call   801052d0 <acquire>
80102d70:	83 c4 10             	add    $0x10,%esp
80102d73:	eb 18                	jmp    80102d8d <begin_op+0x2d>
80102d75:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d78:	83 ec 08             	sub    $0x8,%esp
80102d7b:	68 c0 26 11 80       	push   $0x801126c0
80102d80:	68 c0 26 11 80       	push   $0x801126c0
80102d85:	e8 c6 19 00 00       	call   80104750 <sleep>
80102d8a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d8d:	a1 00 27 11 80       	mov    0x80112700,%eax
80102d92:	85 c0                	test   %eax,%eax
80102d94:	75 e2                	jne    80102d78 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d96:	a1 fc 26 11 80       	mov    0x801126fc,%eax
80102d9b:	8b 15 08 27 11 80    	mov    0x80112708,%edx
80102da1:	83 c0 01             	add    $0x1,%eax
80102da4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102da7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102daa:	83 fa 1e             	cmp    $0x1e,%edx
80102dad:	7f c9                	jg     80102d78 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102daf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102db2:	a3 fc 26 11 80       	mov    %eax,0x801126fc
      release(&log.lock);
80102db7:	68 c0 26 11 80       	push   $0x801126c0
80102dbc:	e8 af 24 00 00       	call   80105270 <release>
      break;
    }
  }
}
80102dc1:	83 c4 10             	add    $0x10,%esp
80102dc4:	c9                   	leave  
80102dc5:	c3                   	ret    
80102dc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102dcd:	8d 76 00             	lea    0x0(%esi),%esi

80102dd0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102dd0:	55                   	push   %ebp
80102dd1:	89 e5                	mov    %esp,%ebp
80102dd3:	57                   	push   %edi
80102dd4:	56                   	push   %esi
80102dd5:	53                   	push   %ebx
80102dd6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102dd9:	68 c0 26 11 80       	push   $0x801126c0
80102dde:	e8 ed 24 00 00       	call   801052d0 <acquire>
  log.outstanding -= 1;
80102de3:	a1 fc 26 11 80       	mov    0x801126fc,%eax
  if(log.committing)
80102de8:	8b 35 00 27 11 80    	mov    0x80112700,%esi
80102dee:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102df1:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102df4:	89 1d fc 26 11 80    	mov    %ebx,0x801126fc
  if(log.committing)
80102dfa:	85 f6                	test   %esi,%esi
80102dfc:	0f 85 22 01 00 00    	jne    80102f24 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e02:	85 db                	test   %ebx,%ebx
80102e04:	0f 85 f6 00 00 00    	jne    80102f00 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102e0a:	c7 05 00 27 11 80 01 	movl   $0x1,0x80112700
80102e11:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e14:	83 ec 0c             	sub    $0xc,%esp
80102e17:	68 c0 26 11 80       	push   $0x801126c0
80102e1c:	e8 4f 24 00 00       	call   80105270 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e21:	8b 0d 08 27 11 80    	mov    0x80112708,%ecx
80102e27:	83 c4 10             	add    $0x10,%esp
80102e2a:	85 c9                	test   %ecx,%ecx
80102e2c:	7f 42                	jg     80102e70 <end_op+0xa0>
    acquire(&log.lock);
80102e2e:	83 ec 0c             	sub    $0xc,%esp
80102e31:	68 c0 26 11 80       	push   $0x801126c0
80102e36:	e8 95 24 00 00       	call   801052d0 <acquire>
    wakeup(&log);
80102e3b:	c7 04 24 c0 26 11 80 	movl   $0x801126c0,(%esp)
    log.committing = 0;
80102e42:	c7 05 00 27 11 80 00 	movl   $0x0,0x80112700
80102e49:	00 00 00 
    wakeup(&log);
80102e4c:	e8 bf 19 00 00       	call   80104810 <wakeup>
    release(&log.lock);
80102e51:	c7 04 24 c0 26 11 80 	movl   $0x801126c0,(%esp)
80102e58:	e8 13 24 00 00       	call   80105270 <release>
80102e5d:	83 c4 10             	add    $0x10,%esp
}
80102e60:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e63:	5b                   	pop    %ebx
80102e64:	5e                   	pop    %esi
80102e65:	5f                   	pop    %edi
80102e66:	5d                   	pop    %ebp
80102e67:	c3                   	ret    
80102e68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e6f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e70:	a1 f4 26 11 80       	mov    0x801126f4,%eax
80102e75:	83 ec 08             	sub    $0x8,%esp
80102e78:	01 d8                	add    %ebx,%eax
80102e7a:	83 c0 01             	add    $0x1,%eax
80102e7d:	50                   	push   %eax
80102e7e:	ff 35 04 27 11 80    	push   0x80112704
80102e84:	e8 47 d2 ff ff       	call   801000d0 <bread>
80102e89:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e8b:	58                   	pop    %eax
80102e8c:	5a                   	pop    %edx
80102e8d:	ff 34 9d 0c 27 11 80 	push   -0x7feed8f4(,%ebx,4)
80102e94:	ff 35 04 27 11 80    	push   0x80112704
  for (tail = 0; tail < log.lh.n; tail++) {
80102e9a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e9d:	e8 2e d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102ea2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ea5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ea7:	8d 40 5c             	lea    0x5c(%eax),%eax
80102eaa:	68 00 02 00 00       	push   $0x200
80102eaf:	50                   	push   %eax
80102eb0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102eb3:	50                   	push   %eax
80102eb4:	e8 77 25 00 00       	call   80105430 <memmove>
    bwrite(to);  // write the log
80102eb9:	89 34 24             	mov    %esi,(%esp)
80102ebc:	e8 ef d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102ec1:	89 3c 24             	mov    %edi,(%esp)
80102ec4:	e8 27 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102ec9:	89 34 24             	mov    %esi,(%esp)
80102ecc:	e8 1f d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ed1:	83 c4 10             	add    $0x10,%esp
80102ed4:	3b 1d 08 27 11 80    	cmp    0x80112708,%ebx
80102eda:	7c 94                	jl     80102e70 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102edc:	e8 7f fd ff ff       	call   80102c60 <write_head>
    install_trans(); // Now install writes to home locations
80102ee1:	e8 da fc ff ff       	call   80102bc0 <install_trans>
    log.lh.n = 0;
80102ee6:	c7 05 08 27 11 80 00 	movl   $0x0,0x80112708
80102eed:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ef0:	e8 6b fd ff ff       	call   80102c60 <write_head>
80102ef5:	e9 34 ff ff ff       	jmp    80102e2e <end_op+0x5e>
80102efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102f00:	83 ec 0c             	sub    $0xc,%esp
80102f03:	68 c0 26 11 80       	push   $0x801126c0
80102f08:	e8 03 19 00 00       	call   80104810 <wakeup>
  release(&log.lock);
80102f0d:	c7 04 24 c0 26 11 80 	movl   $0x801126c0,(%esp)
80102f14:	e8 57 23 00 00       	call   80105270 <release>
80102f19:	83 c4 10             	add    $0x10,%esp
}
80102f1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f1f:	5b                   	pop    %ebx
80102f20:	5e                   	pop    %esi
80102f21:	5f                   	pop    %edi
80102f22:	5d                   	pop    %ebp
80102f23:	c3                   	ret    
    panic("log.committing");
80102f24:	83 ec 0c             	sub    $0xc,%esp
80102f27:	68 e4 84 10 80       	push   $0x801084e4
80102f2c:	e8 4f d4 ff ff       	call   80100380 <panic>
80102f31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f3f:	90                   	nop

80102f40 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f40:	55                   	push   %ebp
80102f41:	89 e5                	mov    %esp,%ebp
80102f43:	53                   	push   %ebx
80102f44:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f47:	8b 15 08 27 11 80    	mov    0x80112708,%edx
{
80102f4d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f50:	83 fa 1d             	cmp    $0x1d,%edx
80102f53:	0f 8f 85 00 00 00    	jg     80102fde <log_write+0x9e>
80102f59:	a1 f8 26 11 80       	mov    0x801126f8,%eax
80102f5e:	83 e8 01             	sub    $0x1,%eax
80102f61:	39 c2                	cmp    %eax,%edx
80102f63:	7d 79                	jge    80102fde <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f65:	a1 fc 26 11 80       	mov    0x801126fc,%eax
80102f6a:	85 c0                	test   %eax,%eax
80102f6c:	7e 7d                	jle    80102feb <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f6e:	83 ec 0c             	sub    $0xc,%esp
80102f71:	68 c0 26 11 80       	push   $0x801126c0
80102f76:	e8 55 23 00 00       	call   801052d0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f7b:	8b 15 08 27 11 80    	mov    0x80112708,%edx
80102f81:	83 c4 10             	add    $0x10,%esp
80102f84:	85 d2                	test   %edx,%edx
80102f86:	7e 4a                	jle    80102fd2 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f88:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102f8b:	31 c0                	xor    %eax,%eax
80102f8d:	eb 08                	jmp    80102f97 <log_write+0x57>
80102f8f:	90                   	nop
80102f90:	83 c0 01             	add    $0x1,%eax
80102f93:	39 c2                	cmp    %eax,%edx
80102f95:	74 29                	je     80102fc0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f97:	39 0c 85 0c 27 11 80 	cmp    %ecx,-0x7feed8f4(,%eax,4)
80102f9e:	75 f0                	jne    80102f90 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80102fa0:	89 0c 85 0c 27 11 80 	mov    %ecx,-0x7feed8f4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102fa7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102faa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102fad:	c7 45 08 c0 26 11 80 	movl   $0x801126c0,0x8(%ebp)
}
80102fb4:	c9                   	leave  
  release(&log.lock);
80102fb5:	e9 b6 22 00 00       	jmp    80105270 <release>
80102fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102fc0:	89 0c 95 0c 27 11 80 	mov    %ecx,-0x7feed8f4(,%edx,4)
    log.lh.n++;
80102fc7:	83 c2 01             	add    $0x1,%edx
80102fca:	89 15 08 27 11 80    	mov    %edx,0x80112708
80102fd0:	eb d5                	jmp    80102fa7 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80102fd2:	8b 43 08             	mov    0x8(%ebx),%eax
80102fd5:	a3 0c 27 11 80       	mov    %eax,0x8011270c
  if (i == log.lh.n)
80102fda:	75 cb                	jne    80102fa7 <log_write+0x67>
80102fdc:	eb e9                	jmp    80102fc7 <log_write+0x87>
    panic("too big a transaction");
80102fde:	83 ec 0c             	sub    $0xc,%esp
80102fe1:	68 f3 84 10 80       	push   $0x801084f3
80102fe6:	e8 95 d3 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
80102feb:	83 ec 0c             	sub    $0xc,%esp
80102fee:	68 09 85 10 80       	push   $0x80108509
80102ff3:	e8 88 d3 ff ff       	call   80100380 <panic>
80102ff8:	66 90                	xchg   %ax,%ax
80102ffa:	66 90                	xchg   %ax,%ax
80102ffc:	66 90                	xchg   %ax,%ax
80102ffe:	66 90                	xchg   %ax,%ax

80103000 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103000:	55                   	push   %ebp
80103001:	89 e5                	mov    %esp,%ebp
80103003:	53                   	push   %ebx
80103004:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103007:	e8 f4 0b 00 00       	call   80103c00 <cpuid>
8010300c:	89 c3                	mov    %eax,%ebx
8010300e:	e8 ed 0b 00 00       	call   80103c00 <cpuid>
80103013:	83 ec 04             	sub    $0x4,%esp
80103016:	53                   	push   %ebx
80103017:	50                   	push   %eax
80103018:	68 24 85 10 80       	push   $0x80108524
8010301d:	e8 7e d6 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80103022:	e8 19 37 00 00       	call   80106740 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103027:	e8 74 0b 00 00       	call   80103ba0 <mycpu>
8010302c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010302e:	b8 01 00 00 00       	mov    $0x1,%eax
80103033:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010303a:	e8 c1 0f 00 00       	call   80104000 <scheduler>
8010303f:	90                   	nop

80103040 <mpenter>:
{
80103040:	55                   	push   %ebp
80103041:	89 e5                	mov    %esp,%ebp
80103043:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103046:	e8 35 48 00 00       	call   80107880 <switchkvm>
  seginit();
8010304b:	e8 a0 47 00 00       	call   801077f0 <seginit>
  lapicinit();
80103050:	e8 9b f7 ff ff       	call   801027f0 <lapicinit>
  mpmain();
80103055:	e8 a6 ff ff ff       	call   80103000 <mpmain>
8010305a:	66 90                	xchg   %ax,%ax
8010305c:	66 90                	xchg   %ax,%ax
8010305e:	66 90                	xchg   %ax,%ax

80103060 <main>:
{
80103060:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103064:	83 e4 f0             	and    $0xfffffff0,%esp
80103067:	ff 71 fc             	push   -0x4(%ecx)
8010306a:	55                   	push   %ebp
8010306b:	89 e5                	mov    %esp,%ebp
8010306d:	53                   	push   %ebx
8010306e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010306f:	83 ec 08             	sub    $0x8,%esp
80103072:	68 00 00 40 80       	push   $0x80400000
80103077:	68 f0 7d 11 80       	push   $0x80117df0
8010307c:	e8 8f f5 ff ff       	call   80102610 <kinit1>
  kvmalloc();      // kernel page table
80103081:	e8 ea 4c 00 00       	call   80107d70 <kvmalloc>
  mpinit();        // detect other processors
80103086:	e8 85 01 00 00       	call   80103210 <mpinit>
  lapicinit();     // interrupt controller
8010308b:	e8 60 f7 ff ff       	call   801027f0 <lapicinit>
  seginit();       // segment descriptors
80103090:	e8 5b 47 00 00       	call   801077f0 <seginit>
  picinit();       // disable pic
80103095:	e8 76 03 00 00       	call   80103410 <picinit>
  ioapicinit();    // another interrupt controller
8010309a:	e8 31 f3 ff ff       	call   801023d0 <ioapicinit>
  consoleinit();   // console hardware
8010309f:	e8 bc d9 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
801030a4:	e8 d7 39 00 00       	call   80106a80 <uartinit>
  pinit();         // process table
801030a9:	e8 d2 0a 00 00       	call   80103b80 <pinit>
  tvinit();        // trap vectors
801030ae:	e8 0d 36 00 00       	call   801066c0 <tvinit>
  binit();         // buffer cache
801030b3:	e8 88 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
801030b8:	e8 53 dd ff ff       	call   80100e10 <fileinit>
  ideinit();       // disk 
801030bd:	e8 fe f0 ff ff       	call   801021c0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030c2:	83 c4 0c             	add    $0xc,%esp
801030c5:	68 8a 00 00 00       	push   $0x8a
801030ca:	68 ac b4 10 80       	push   $0x8010b4ac
801030cf:	68 00 70 00 80       	push   $0x80007000
801030d4:	e8 57 23 00 00       	call   80105430 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030d9:	83 c4 10             	add    $0x10,%esp
801030dc:	69 05 a4 27 11 80 b0 	imul   $0xb0,0x801127a4,%eax
801030e3:	00 00 00 
801030e6:	05 c0 27 11 80       	add    $0x801127c0,%eax
801030eb:	3d c0 27 11 80       	cmp    $0x801127c0,%eax
801030f0:	76 7e                	jbe    80103170 <main+0x110>
801030f2:	bb c0 27 11 80       	mov    $0x801127c0,%ebx
801030f7:	eb 20                	jmp    80103119 <main+0xb9>
801030f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103100:	69 05 a4 27 11 80 b0 	imul   $0xb0,0x801127a4,%eax
80103107:	00 00 00 
8010310a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103110:	05 c0 27 11 80       	add    $0x801127c0,%eax
80103115:	39 c3                	cmp    %eax,%ebx
80103117:	73 57                	jae    80103170 <main+0x110>
    if(c == mycpu())  // We've started already.
80103119:	e8 82 0a 00 00       	call   80103ba0 <mycpu>
8010311e:	39 c3                	cmp    %eax,%ebx
80103120:	74 de                	je     80103100 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103122:	e8 59 f5 ff ff       	call   80102680 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103127:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010312a:	c7 05 f8 6f 00 80 40 	movl   $0x80103040,0x80006ff8
80103131:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103134:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010313b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010313e:	05 00 10 00 00       	add    $0x1000,%eax
80103143:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103148:	0f b6 03             	movzbl (%ebx),%eax
8010314b:	68 00 70 00 00       	push   $0x7000
80103150:	50                   	push   %eax
80103151:	e8 ea f7 ff ff       	call   80102940 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103156:	83 c4 10             	add    $0x10,%esp
80103159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103160:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103166:	85 c0                	test   %eax,%eax
80103168:	74 f6                	je     80103160 <main+0x100>
8010316a:	eb 94                	jmp    80103100 <main+0xa0>
8010316c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103170:	83 ec 08             	sub    $0x8,%esp
80103173:	68 00 00 00 8e       	push   $0x8e000000
80103178:	68 00 00 40 80       	push   $0x80400000
8010317d:	e8 2e f4 ff ff       	call   801025b0 <kinit2>
  userinit();      // first user process
80103182:	e8 c9 0a 00 00       	call   80103c50 <userinit>
  mpmain();        // finish this processor's setup
80103187:	e8 74 fe ff ff       	call   80103000 <mpmain>
8010318c:	66 90                	xchg   %ax,%ax
8010318e:	66 90                	xchg   %ax,%ax

80103190 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103190:	55                   	push   %ebp
80103191:	89 e5                	mov    %esp,%ebp
80103193:	57                   	push   %edi
80103194:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103195:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010319b:	53                   	push   %ebx
  e = addr+len;
8010319c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010319f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801031a2:	39 de                	cmp    %ebx,%esi
801031a4:	72 10                	jb     801031b6 <mpsearch1+0x26>
801031a6:	eb 50                	jmp    801031f8 <mpsearch1+0x68>
801031a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031af:	90                   	nop
801031b0:	89 fe                	mov    %edi,%esi
801031b2:	39 fb                	cmp    %edi,%ebx
801031b4:	76 42                	jbe    801031f8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031b6:	83 ec 04             	sub    $0x4,%esp
801031b9:	8d 7e 10             	lea    0x10(%esi),%edi
801031bc:	6a 04                	push   $0x4
801031be:	68 38 85 10 80       	push   $0x80108538
801031c3:	56                   	push   %esi
801031c4:	e8 17 22 00 00       	call   801053e0 <memcmp>
801031c9:	83 c4 10             	add    $0x10,%esp
801031cc:	85 c0                	test   %eax,%eax
801031ce:	75 e0                	jne    801031b0 <mpsearch1+0x20>
801031d0:	89 f2                	mov    %esi,%edx
801031d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031d8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801031db:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801031de:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801031e0:	39 fa                	cmp    %edi,%edx
801031e2:	75 f4                	jne    801031d8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031e4:	84 c0                	test   %al,%al
801031e6:	75 c8                	jne    801031b0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801031e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031eb:	89 f0                	mov    %esi,%eax
801031ed:	5b                   	pop    %ebx
801031ee:	5e                   	pop    %esi
801031ef:	5f                   	pop    %edi
801031f0:	5d                   	pop    %ebp
801031f1:	c3                   	ret    
801031f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801031fb:	31 f6                	xor    %esi,%esi
}
801031fd:	5b                   	pop    %ebx
801031fe:	89 f0                	mov    %esi,%eax
80103200:	5e                   	pop    %esi
80103201:	5f                   	pop    %edi
80103202:	5d                   	pop    %ebp
80103203:	c3                   	ret    
80103204:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010320b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010320f:	90                   	nop

80103210 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103210:	55                   	push   %ebp
80103211:	89 e5                	mov    %esp,%ebp
80103213:	57                   	push   %edi
80103214:	56                   	push   %esi
80103215:	53                   	push   %ebx
80103216:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103219:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103220:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103227:	c1 e0 08             	shl    $0x8,%eax
8010322a:	09 d0                	or     %edx,%eax
8010322c:	c1 e0 04             	shl    $0x4,%eax
8010322f:	75 1b                	jne    8010324c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103231:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103238:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010323f:	c1 e0 08             	shl    $0x8,%eax
80103242:	09 d0                	or     %edx,%eax
80103244:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103247:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010324c:	ba 00 04 00 00       	mov    $0x400,%edx
80103251:	e8 3a ff ff ff       	call   80103190 <mpsearch1>
80103256:	89 c3                	mov    %eax,%ebx
80103258:	85 c0                	test   %eax,%eax
8010325a:	0f 84 40 01 00 00    	je     801033a0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103260:	8b 73 04             	mov    0x4(%ebx),%esi
80103263:	85 f6                	test   %esi,%esi
80103265:	0f 84 25 01 00 00    	je     80103390 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010326b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010326e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103274:	6a 04                	push   $0x4
80103276:	68 3d 85 10 80       	push   $0x8010853d
8010327b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010327c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010327f:	e8 5c 21 00 00       	call   801053e0 <memcmp>
80103284:	83 c4 10             	add    $0x10,%esp
80103287:	85 c0                	test   %eax,%eax
80103289:	0f 85 01 01 00 00    	jne    80103390 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
8010328f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103296:	3c 01                	cmp    $0x1,%al
80103298:	74 08                	je     801032a2 <mpinit+0x92>
8010329a:	3c 04                	cmp    $0x4,%al
8010329c:	0f 85 ee 00 00 00    	jne    80103390 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
801032a2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801032a9:	66 85 d2             	test   %dx,%dx
801032ac:	74 22                	je     801032d0 <mpinit+0xc0>
801032ae:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801032b1:	89 f0                	mov    %esi,%eax
  sum = 0;
801032b3:	31 d2                	xor    %edx,%edx
801032b5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801032b8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801032bf:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801032c2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801032c4:	39 c7                	cmp    %eax,%edi
801032c6:	75 f0                	jne    801032b8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801032c8:	84 d2                	test   %dl,%dl
801032ca:	0f 85 c0 00 00 00    	jne    80103390 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032d0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
801032d6:	a3 a0 26 11 80       	mov    %eax,0x801126a0
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032db:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801032e2:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
801032e8:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032ed:	03 55 e4             	add    -0x1c(%ebp),%edx
801032f0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801032f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032f7:	90                   	nop
801032f8:	39 d0                	cmp    %edx,%eax
801032fa:	73 15                	jae    80103311 <mpinit+0x101>
    switch(*p){
801032fc:	0f b6 08             	movzbl (%eax),%ecx
801032ff:	80 f9 02             	cmp    $0x2,%cl
80103302:	74 4c                	je     80103350 <mpinit+0x140>
80103304:	77 3a                	ja     80103340 <mpinit+0x130>
80103306:	84 c9                	test   %cl,%cl
80103308:	74 56                	je     80103360 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010330a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010330d:	39 d0                	cmp    %edx,%eax
8010330f:	72 eb                	jb     801032fc <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103311:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103314:	85 f6                	test   %esi,%esi
80103316:	0f 84 d9 00 00 00    	je     801033f5 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010331c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103320:	74 15                	je     80103337 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103322:	b8 70 00 00 00       	mov    $0x70,%eax
80103327:	ba 22 00 00 00       	mov    $0x22,%edx
8010332c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010332d:	ba 23 00 00 00       	mov    $0x23,%edx
80103332:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103333:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103336:	ee                   	out    %al,(%dx)
  }
}
80103337:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010333a:	5b                   	pop    %ebx
8010333b:	5e                   	pop    %esi
8010333c:	5f                   	pop    %edi
8010333d:	5d                   	pop    %ebp
8010333e:	c3                   	ret    
8010333f:	90                   	nop
    switch(*p){
80103340:	83 e9 03             	sub    $0x3,%ecx
80103343:	80 f9 01             	cmp    $0x1,%cl
80103346:	76 c2                	jbe    8010330a <mpinit+0xfa>
80103348:	31 f6                	xor    %esi,%esi
8010334a:	eb ac                	jmp    801032f8 <mpinit+0xe8>
8010334c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103350:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103354:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103357:	88 0d a0 27 11 80    	mov    %cl,0x801127a0
      continue;
8010335d:	eb 99                	jmp    801032f8 <mpinit+0xe8>
8010335f:	90                   	nop
      if(ncpu < NCPU) {
80103360:	8b 0d a4 27 11 80    	mov    0x801127a4,%ecx
80103366:	83 f9 07             	cmp    $0x7,%ecx
80103369:	7f 19                	jg     80103384 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010336b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103371:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103375:	83 c1 01             	add    $0x1,%ecx
80103378:	89 0d a4 27 11 80    	mov    %ecx,0x801127a4
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010337e:	88 9f c0 27 11 80    	mov    %bl,-0x7feed840(%edi)
      p += sizeof(struct mpproc);
80103384:	83 c0 14             	add    $0x14,%eax
      continue;
80103387:	e9 6c ff ff ff       	jmp    801032f8 <mpinit+0xe8>
8010338c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103390:	83 ec 0c             	sub    $0xc,%esp
80103393:	68 42 85 10 80       	push   $0x80108542
80103398:	e8 e3 cf ff ff       	call   80100380 <panic>
8010339d:	8d 76 00             	lea    0x0(%esi),%esi
{
801033a0:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801033a5:	eb 13                	jmp    801033ba <mpinit+0x1aa>
801033a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033ae:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
801033b0:	89 f3                	mov    %esi,%ebx
801033b2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801033b8:	74 d6                	je     80103390 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033ba:	83 ec 04             	sub    $0x4,%esp
801033bd:	8d 73 10             	lea    0x10(%ebx),%esi
801033c0:	6a 04                	push   $0x4
801033c2:	68 38 85 10 80       	push   $0x80108538
801033c7:	53                   	push   %ebx
801033c8:	e8 13 20 00 00       	call   801053e0 <memcmp>
801033cd:	83 c4 10             	add    $0x10,%esp
801033d0:	85 c0                	test   %eax,%eax
801033d2:	75 dc                	jne    801033b0 <mpinit+0x1a0>
801033d4:	89 da                	mov    %ebx,%edx
801033d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033dd:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801033e0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801033e3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801033e6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801033e8:	39 d6                	cmp    %edx,%esi
801033ea:	75 f4                	jne    801033e0 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033ec:	84 c0                	test   %al,%al
801033ee:	75 c0                	jne    801033b0 <mpinit+0x1a0>
801033f0:	e9 6b fe ff ff       	jmp    80103260 <mpinit+0x50>
    panic("Didn't find a suitable machine");
801033f5:	83 ec 0c             	sub    $0xc,%esp
801033f8:	68 5c 85 10 80       	push   $0x8010855c
801033fd:	e8 7e cf ff ff       	call   80100380 <panic>
80103402:	66 90                	xchg   %ax,%ax
80103404:	66 90                	xchg   %ax,%ax
80103406:	66 90                	xchg   %ax,%ax
80103408:	66 90                	xchg   %ax,%ax
8010340a:	66 90                	xchg   %ax,%ax
8010340c:	66 90                	xchg   %ax,%ax
8010340e:	66 90                	xchg   %ax,%ax

80103410 <picinit>:
80103410:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103415:	ba 21 00 00 00       	mov    $0x21,%edx
8010341a:	ee                   	out    %al,(%dx)
8010341b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103420:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103421:	c3                   	ret    
80103422:	66 90                	xchg   %ax,%ax
80103424:	66 90                	xchg   %ax,%ax
80103426:	66 90                	xchg   %ax,%ax
80103428:	66 90                	xchg   %ax,%ax
8010342a:	66 90                	xchg   %ax,%ax
8010342c:	66 90                	xchg   %ax,%ax
8010342e:	66 90                	xchg   %ax,%ax

80103430 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103430:	55                   	push   %ebp
80103431:	89 e5                	mov    %esp,%ebp
80103433:	57                   	push   %edi
80103434:	56                   	push   %esi
80103435:	53                   	push   %ebx
80103436:	83 ec 0c             	sub    $0xc,%esp
80103439:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010343c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010343f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103445:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010344b:	e8 e0 d9 ff ff       	call   80100e30 <filealloc>
80103450:	89 03                	mov    %eax,(%ebx)
80103452:	85 c0                	test   %eax,%eax
80103454:	0f 84 a8 00 00 00    	je     80103502 <pipealloc+0xd2>
8010345a:	e8 d1 d9 ff ff       	call   80100e30 <filealloc>
8010345f:	89 06                	mov    %eax,(%esi)
80103461:	85 c0                	test   %eax,%eax
80103463:	0f 84 87 00 00 00    	je     801034f0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103469:	e8 12 f2 ff ff       	call   80102680 <kalloc>
8010346e:	89 c7                	mov    %eax,%edi
80103470:	85 c0                	test   %eax,%eax
80103472:	0f 84 b0 00 00 00    	je     80103528 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103478:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010347f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103482:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103485:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010348c:	00 00 00 
  p->nwrite = 0;
8010348f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103496:	00 00 00 
  p->nread = 0;
80103499:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801034a0:	00 00 00 
  initlock(&p->lock, "pipe");
801034a3:	68 7b 85 10 80       	push   $0x8010857b
801034a8:	50                   	push   %eax
801034a9:	e8 52 1c 00 00       	call   80105100 <initlock>
  (*f0)->type = FD_PIPE;
801034ae:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801034b0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801034b3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801034b9:	8b 03                	mov    (%ebx),%eax
801034bb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801034bf:	8b 03                	mov    (%ebx),%eax
801034c1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801034c5:	8b 03                	mov    (%ebx),%eax
801034c7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801034ca:	8b 06                	mov    (%esi),%eax
801034cc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034d2:	8b 06                	mov    (%esi),%eax
801034d4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034d8:	8b 06                	mov    (%esi),%eax
801034da:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034de:	8b 06                	mov    (%esi),%eax
801034e0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801034e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034e6:	31 c0                	xor    %eax,%eax
}
801034e8:	5b                   	pop    %ebx
801034e9:	5e                   	pop    %esi
801034ea:	5f                   	pop    %edi
801034eb:	5d                   	pop    %ebp
801034ec:	c3                   	ret    
801034ed:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
801034f0:	8b 03                	mov    (%ebx),%eax
801034f2:	85 c0                	test   %eax,%eax
801034f4:	74 1e                	je     80103514 <pipealloc+0xe4>
    fileclose(*f0);
801034f6:	83 ec 0c             	sub    $0xc,%esp
801034f9:	50                   	push   %eax
801034fa:	e8 f1 d9 ff ff       	call   80100ef0 <fileclose>
801034ff:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103502:	8b 06                	mov    (%esi),%eax
80103504:	85 c0                	test   %eax,%eax
80103506:	74 0c                	je     80103514 <pipealloc+0xe4>
    fileclose(*f1);
80103508:	83 ec 0c             	sub    $0xc,%esp
8010350b:	50                   	push   %eax
8010350c:	e8 df d9 ff ff       	call   80100ef0 <fileclose>
80103511:	83 c4 10             	add    $0x10,%esp
}
80103514:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103517:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010351c:	5b                   	pop    %ebx
8010351d:	5e                   	pop    %esi
8010351e:	5f                   	pop    %edi
8010351f:	5d                   	pop    %ebp
80103520:	c3                   	ret    
80103521:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103528:	8b 03                	mov    (%ebx),%eax
8010352a:	85 c0                	test   %eax,%eax
8010352c:	75 c8                	jne    801034f6 <pipealloc+0xc6>
8010352e:	eb d2                	jmp    80103502 <pipealloc+0xd2>

80103530 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103530:	55                   	push   %ebp
80103531:	89 e5                	mov    %esp,%ebp
80103533:	56                   	push   %esi
80103534:	53                   	push   %ebx
80103535:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103538:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010353b:	83 ec 0c             	sub    $0xc,%esp
8010353e:	53                   	push   %ebx
8010353f:	e8 8c 1d 00 00       	call   801052d0 <acquire>
  if(writable){
80103544:	83 c4 10             	add    $0x10,%esp
80103547:	85 f6                	test   %esi,%esi
80103549:	74 65                	je     801035b0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010354b:	83 ec 0c             	sub    $0xc,%esp
8010354e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103554:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010355b:	00 00 00 
    wakeup(&p->nread);
8010355e:	50                   	push   %eax
8010355f:	e8 ac 12 00 00       	call   80104810 <wakeup>
80103564:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103567:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010356d:	85 d2                	test   %edx,%edx
8010356f:	75 0a                	jne    8010357b <pipeclose+0x4b>
80103571:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103577:	85 c0                	test   %eax,%eax
80103579:	74 15                	je     80103590 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010357b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010357e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103581:	5b                   	pop    %ebx
80103582:	5e                   	pop    %esi
80103583:	5d                   	pop    %ebp
    release(&p->lock);
80103584:	e9 e7 1c 00 00       	jmp    80105270 <release>
80103589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103590:	83 ec 0c             	sub    $0xc,%esp
80103593:	53                   	push   %ebx
80103594:	e8 d7 1c 00 00       	call   80105270 <release>
    kfree((char*)p);
80103599:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010359c:	83 c4 10             	add    $0x10,%esp
}
8010359f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035a2:	5b                   	pop    %ebx
801035a3:	5e                   	pop    %esi
801035a4:	5d                   	pop    %ebp
    kfree((char*)p);
801035a5:	e9 16 ef ff ff       	jmp    801024c0 <kfree>
801035aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801035b0:	83 ec 0c             	sub    $0xc,%esp
801035b3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801035b9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801035c0:	00 00 00 
    wakeup(&p->nwrite);
801035c3:	50                   	push   %eax
801035c4:	e8 47 12 00 00       	call   80104810 <wakeup>
801035c9:	83 c4 10             	add    $0x10,%esp
801035cc:	eb 99                	jmp    80103567 <pipeclose+0x37>
801035ce:	66 90                	xchg   %ax,%ax

801035d0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035d0:	55                   	push   %ebp
801035d1:	89 e5                	mov    %esp,%ebp
801035d3:	57                   	push   %edi
801035d4:	56                   	push   %esi
801035d5:	53                   	push   %ebx
801035d6:	83 ec 28             	sub    $0x28,%esp
801035d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801035dc:	53                   	push   %ebx
801035dd:	e8 ee 1c 00 00       	call   801052d0 <acquire>
  for(i = 0; i < n; i++){
801035e2:	8b 45 10             	mov    0x10(%ebp),%eax
801035e5:	83 c4 10             	add    $0x10,%esp
801035e8:	85 c0                	test   %eax,%eax
801035ea:	0f 8e c0 00 00 00    	jle    801036b0 <pipewrite+0xe0>
801035f0:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035f3:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801035f9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801035ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103602:	03 45 10             	add    0x10(%ebp),%eax
80103605:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103608:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010360e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103614:	89 ca                	mov    %ecx,%edx
80103616:	05 00 02 00 00       	add    $0x200,%eax
8010361b:	39 c1                	cmp    %eax,%ecx
8010361d:	74 3f                	je     8010365e <pipewrite+0x8e>
8010361f:	eb 67                	jmp    80103688 <pipewrite+0xb8>
80103621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103628:	e8 f3 05 00 00       	call   80103c20 <myproc>
8010362d:	8b 48 2c             	mov    0x2c(%eax),%ecx
80103630:	85 c9                	test   %ecx,%ecx
80103632:	75 34                	jne    80103668 <pipewrite+0x98>
      wakeup(&p->nread);
80103634:	83 ec 0c             	sub    $0xc,%esp
80103637:	57                   	push   %edi
80103638:	e8 d3 11 00 00       	call   80104810 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010363d:	58                   	pop    %eax
8010363e:	5a                   	pop    %edx
8010363f:	53                   	push   %ebx
80103640:	56                   	push   %esi
80103641:	e8 0a 11 00 00       	call   80104750 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103646:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010364c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103652:	83 c4 10             	add    $0x10,%esp
80103655:	05 00 02 00 00       	add    $0x200,%eax
8010365a:	39 c2                	cmp    %eax,%edx
8010365c:	75 2a                	jne    80103688 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010365e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103664:	85 c0                	test   %eax,%eax
80103666:	75 c0                	jne    80103628 <pipewrite+0x58>
        release(&p->lock);
80103668:	83 ec 0c             	sub    $0xc,%esp
8010366b:	53                   	push   %ebx
8010366c:	e8 ff 1b 00 00       	call   80105270 <release>
        return -1;
80103671:	83 c4 10             	add    $0x10,%esp
80103674:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103679:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010367c:	5b                   	pop    %ebx
8010367d:	5e                   	pop    %esi
8010367e:	5f                   	pop    %edi
8010367f:	5d                   	pop    %ebp
80103680:	c3                   	ret    
80103681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103688:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010368b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010368e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103694:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010369a:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
8010369d:	83 c6 01             	add    $0x1,%esi
801036a0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036a3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801036a7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801036aa:	0f 85 58 ff ff ff    	jne    80103608 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801036b0:	83 ec 0c             	sub    $0xc,%esp
801036b3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801036b9:	50                   	push   %eax
801036ba:	e8 51 11 00 00       	call   80104810 <wakeup>
  release(&p->lock);
801036bf:	89 1c 24             	mov    %ebx,(%esp)
801036c2:	e8 a9 1b 00 00       	call   80105270 <release>
  return n;
801036c7:	8b 45 10             	mov    0x10(%ebp),%eax
801036ca:	83 c4 10             	add    $0x10,%esp
801036cd:	eb aa                	jmp    80103679 <pipewrite+0xa9>
801036cf:	90                   	nop

801036d0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036d0:	55                   	push   %ebp
801036d1:	89 e5                	mov    %esp,%ebp
801036d3:	57                   	push   %edi
801036d4:	56                   	push   %esi
801036d5:	53                   	push   %ebx
801036d6:	83 ec 18             	sub    $0x18,%esp
801036d9:	8b 75 08             	mov    0x8(%ebp),%esi
801036dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036df:	56                   	push   %esi
801036e0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801036e6:	e8 e5 1b 00 00       	call   801052d0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036eb:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801036f1:	83 c4 10             	add    $0x10,%esp
801036f4:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801036fa:	74 2f                	je     8010372b <piperead+0x5b>
801036fc:	eb 37                	jmp    80103735 <piperead+0x65>
801036fe:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103700:	e8 1b 05 00 00       	call   80103c20 <myproc>
80103705:	8b 48 2c             	mov    0x2c(%eax),%ecx
80103708:	85 c9                	test   %ecx,%ecx
8010370a:	0f 85 80 00 00 00    	jne    80103790 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103710:	83 ec 08             	sub    $0x8,%esp
80103713:	56                   	push   %esi
80103714:	53                   	push   %ebx
80103715:	e8 36 10 00 00       	call   80104750 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010371a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103720:	83 c4 10             	add    $0x10,%esp
80103723:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103729:	75 0a                	jne    80103735 <piperead+0x65>
8010372b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103731:	85 c0                	test   %eax,%eax
80103733:	75 cb                	jne    80103700 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103735:	8b 55 10             	mov    0x10(%ebp),%edx
80103738:	31 db                	xor    %ebx,%ebx
8010373a:	85 d2                	test   %edx,%edx
8010373c:	7f 20                	jg     8010375e <piperead+0x8e>
8010373e:	eb 2c                	jmp    8010376c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103740:	8d 48 01             	lea    0x1(%eax),%ecx
80103743:	25 ff 01 00 00       	and    $0x1ff,%eax
80103748:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010374e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103753:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103756:	83 c3 01             	add    $0x1,%ebx
80103759:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010375c:	74 0e                	je     8010376c <piperead+0x9c>
    if(p->nread == p->nwrite)
8010375e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103764:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010376a:	75 d4                	jne    80103740 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010376c:	83 ec 0c             	sub    $0xc,%esp
8010376f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103775:	50                   	push   %eax
80103776:	e8 95 10 00 00       	call   80104810 <wakeup>
  release(&p->lock);
8010377b:	89 34 24             	mov    %esi,(%esp)
8010377e:	e8 ed 1a 00 00       	call   80105270 <release>
  return i;
80103783:	83 c4 10             	add    $0x10,%esp
}
80103786:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103789:	89 d8                	mov    %ebx,%eax
8010378b:	5b                   	pop    %ebx
8010378c:	5e                   	pop    %esi
8010378d:	5f                   	pop    %edi
8010378e:	5d                   	pop    %ebp
8010378f:	c3                   	ret    
      release(&p->lock);
80103790:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103793:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103798:	56                   	push   %esi
80103799:	e8 d2 1a 00 00       	call   80105270 <release>
      return -1;
8010379e:	83 c4 10             	add    $0x10,%esp
}
801037a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037a4:	89 d8                	mov    %ebx,%eax
801037a6:	5b                   	pop    %ebx
801037a7:	5e                   	pop    %esi
801037a8:	5f                   	pop    %edi
801037a9:	5d                   	pop    %ebp
801037aa:	c3                   	ret    
801037ab:	66 90                	xchg   %ax,%ax
801037ad:	66 90                	xchg   %ax,%ax
801037af:	90                   	nop

801037b0 <allocproc>:
  return p;
}

static struct proc*
allocproc(void)
{
801037b0:	55                   	push   %ebp
801037b1:	89 e5                	mov    %esp,%ebp
801037b3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037b4:	bb 74 32 11 80       	mov    $0x80113274,%ebx
{
801037b9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801037bc:	68 40 32 11 80       	push   $0x80113240
801037c1:	e8 0a 1b 00 00       	call   801052d0 <acquire>
801037c6:	83 c4 10             	add    $0x10,%esp
801037c9:	eb 17                	jmp    801037e2 <allocproc+0x32>
801037cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037cf:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037d0:	81 c3 cc 00 00 00    	add    $0xcc,%ebx
801037d6:	81 fb 74 65 11 80    	cmp    $0x80116574,%ebx
801037dc:	0f 84 26 01 00 00    	je     80103908 <allocproc+0x158>
    if(p->state == UNUSED)
801037e2:	8b 43 10             	mov    0x10(%ebx),%eax
801037e5:	85 c0                	test   %eax,%eax
801037e7:	75 e7                	jne    801037d0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801037e9:	a1 08 b0 10 80       	mov    0x8010b008,%eax
  p->tgid = nexttgid++; /* Define tgid for process(thread) */

  release(&ptable.lock);
801037ee:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801037f1:	c7 43 10 01 00 00 00 	movl   $0x1,0x10(%ebx)
  p->pid = nextpid++;
801037f8:	89 43 14             	mov    %eax,0x14(%ebx)
801037fb:	8d 50 01             	lea    0x1(%eax),%edx
  p->tgid = nexttgid++; /* Define tgid for process(thread) */
801037fe:	a1 04 b0 10 80       	mov    0x8010b004,%eax
  p->pid = nextpid++;
80103803:	89 15 08 b0 10 80    	mov    %edx,0x8010b008
  p->tgid = nexttgid++; /* Define tgid for process(thread) */
80103809:	89 43 18             	mov    %eax,0x18(%ebx)
8010380c:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
8010380f:	68 40 32 11 80       	push   $0x80113240
  p->tgid = nexttgid++; /* Define tgid for process(thread) */
80103814:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
8010381a:	e8 51 1a 00 00       	call   80105270 <release>

  if((p->kstack = kalloc()) == 0){
8010381f:	e8 5c ee ff ff       	call   80102680 <kalloc>
80103824:	83 c4 10             	add    $0x10,%esp
80103827:	89 43 08             	mov    %eax,0x8(%ebx)
8010382a:	85 c0                	test   %eax,%eax
8010382c:	0f 84 ef 00 00 00    	je     80103921 <allocproc+0x171>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103832:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103838:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010383b:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103840:	89 53 20             	mov    %edx,0x20(%ebx)
  *(uint*)sp = (uint)trapret;
80103843:	c7 40 14 a8 66 10 80 	movl   $0x801066a8,0x14(%eax)
  p->context = (struct context*)sp;
8010384a:	89 43 24             	mov    %eax,0x24(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010384d:	6a 14                	push   $0x14
8010384f:	6a 00                	push   $0x0
80103851:	50                   	push   %eax
80103852:	e8 39 1b 00 00       	call   80105390 <memset>
  p->context->eip = (uint)forkret;
80103857:	8b 43 24             	mov    0x24(%ebx),%eax
8010385a:	83 c4 10             	add    $0x10,%esp
8010385d:	c7 40 10 40 39 10 80 	movl   $0x80103940,0x10(%eax)
  p->ctime = ticks; 
80103864:	a1 84 65 11 80       	mov    0x80116584,%eax
	p->etime = 0;
80103869:	c7 83 90 00 00 00 00 	movl   $0x0,0x90(%ebx)
80103870:	00 00 00 
  p->ctime = ticks; 
80103873:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
		p->enter = 0;
		for(int i=0; i<5; i++)
			p->qticks[i] = 0;
	#endif
  return p;
}
80103879:	89 d8                	mov    %ebx,%eax
	p->rtime = 0;
8010387b:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
80103882:	00 00 00 
	p->iotime = 0;
80103885:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
8010388c:	00 00 00 
	p->waitshh = -1282128;
8010388f:	c7 83 94 00 00 00 b0 	movl   $0xffec6fb0,0x94(%ebx)
80103896:	6f ec ff 
  p->num_run = 0;
80103899:	c7 83 9c 00 00 00 00 	movl   $0x0,0x9c(%ebx)
801038a0:	00 00 00 
	p->priority = 50; // default
801038a3:	c7 83 98 00 00 00 32 	movl   $0x32,0x98(%ebx)
801038aa:	00 00 00 
		p->curr_ticks = 0;
801038ad:	c7 83 b8 00 00 00 00 	movl   $0x0,0xb8(%ebx)
801038b4:	00 00 00 
		p->queue = 0;
801038b7:	c7 83 b4 00 00 00 00 	movl   $0x0,0xb4(%ebx)
801038be:	00 00 00 
		p->enter = 0;
801038c1:	c7 83 c0 00 00 00 00 	movl   $0x0,0xc0(%ebx)
801038c8:	00 00 00 
			p->qticks[i] = 0;
801038cb:	c7 83 a0 00 00 00 00 	movl   $0x0,0xa0(%ebx)
801038d2:	00 00 00 
801038d5:	c7 83 a4 00 00 00 00 	movl   $0x0,0xa4(%ebx)
801038dc:	00 00 00 
801038df:	c7 83 a8 00 00 00 00 	movl   $0x0,0xa8(%ebx)
801038e6:	00 00 00 
801038e9:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
801038f0:	00 00 00 
801038f3:	c7 83 b0 00 00 00 00 	movl   $0x0,0xb0(%ebx)
801038fa:	00 00 00 
}
801038fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103900:	c9                   	leave  
80103901:	c3                   	ret    
80103902:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80103908:	83 ec 0c             	sub    $0xc,%esp
  return 0;
8010390b:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
8010390d:	68 40 32 11 80       	push   $0x80113240
80103912:	e8 59 19 00 00       	call   80105270 <release>
}
80103917:	89 d8                	mov    %ebx,%eax
  return 0;
80103919:	83 c4 10             	add    $0x10,%esp
}
8010391c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010391f:	c9                   	leave  
80103920:	c3                   	ret    
    p->state = UNUSED;
80103921:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
    return 0;
80103928:	31 db                	xor    %ebx,%ebx
}
8010392a:	89 d8                	mov    %ebx,%eax
8010392c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010392f:	c9                   	leave  
80103930:	c3                   	ret    
80103931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103938:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010393f:	90                   	nop

80103940 <forkret>:
  release(&ptable.lock);
}

void
forkret(void)
{
80103940:	55                   	push   %ebp
80103941:	89 e5                	mov    %esp,%ebp
80103943:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  release(&ptable.lock);
80103946:	68 40 32 11 80       	push   $0x80113240
8010394b:	e8 20 19 00 00       	call   80105270 <release>

  if (first) {
80103950:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103955:	83 c4 10             	add    $0x10,%esp
80103958:	85 c0                	test   %eax,%eax
8010395a:	75 04                	jne    80103960 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }


}
8010395c:	c9                   	leave  
8010395d:	c3                   	ret    
8010395e:	66 90                	xchg   %ax,%ax
    first = 0;
80103960:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103967:	00 00 00 
    iinit(ROOTDEV);
8010396a:	83 ec 0c             	sub    $0xc,%esp
8010396d:	6a 01                	push   $0x1
8010396f:	e8 ec db ff ff       	call   80101560 <iinit>
    initlog(ROOTDEV);
80103974:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010397b:	e8 40 f3 ff ff       	call   80102cc0 <initlog>
}
80103980:	83 c4 10             	add    $0x10,%esp
80103983:	c9                   	leave  
80103984:	c3                   	ret    
80103985:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010398c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103990 <ticking>:
	for(struct proc *p=ptable.proc; p<&ptable.proc[NPROC]; ++p){
80103990:	b8 74 32 11 80       	mov    $0x80113274,%eax
80103995:	eb 21                	jmp    801039b8 <ticking+0x28>
80103997:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010399e:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
801039a0:	83 fa 02             	cmp    $0x2,%edx
801039a3:	75 07                	jne    801039ac <ticking+0x1c>
			p->iotime++;
801039a5:	83 80 84 00 00 00 01 	addl   $0x1,0x84(%eax)
	for(struct proc *p=ptable.proc; p<&ptable.proc[NPROC]; ++p){
801039ac:	05 cc 00 00 00       	add    $0xcc,%eax
801039b1:	3d 74 65 11 80       	cmp    $0x80116574,%eax
801039b6:	74 1b                	je     801039d3 <ticking+0x43>
		if(p->state == RUNNING){
801039b8:	8b 50 10             	mov    0x10(%eax),%edx
801039bb:	83 fa 04             	cmp    $0x4,%edx
801039be:	75 e0                	jne    801039a0 <ticking+0x10>
			p->rtime++;
801039c0:	83 80 88 00 00 00 01 	addl   $0x1,0x88(%eax)
	for(struct proc *p=ptable.proc; p<&ptable.proc[NPROC]; ++p){
801039c7:	05 cc 00 00 00       	add    $0xcc,%eax
801039cc:	3d 74 65 11 80       	cmp    $0x80116574,%eax
801039d1:	75 e5                	jne    801039b8 <ticking+0x28>
}
801039d3:	c3                   	ret    
801039d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039df:	90                   	nop

801039e0 <add_proc_to_q>:
{	
801039e0:	55                   	push   %ebp
801039e1:	89 e5                	mov    %esp,%ebp
801039e3:	57                   	push   %edi
801039e4:	8b 7d 0c             	mov    0xc(%ebp),%edi
801039e7:	8b 55 08             	mov    0x8(%ebp),%edx
801039ea:	56                   	push   %esi
801039eb:	53                   	push   %ebx
	for(int i=0; i < q_tail[q_no]; i++)
801039ec:	8b 0c bd 0c b0 10 80 	mov    -0x7fef4ff4(,%edi,4),%ecx
801039f3:	85 c9                	test   %ecx,%ecx
801039f5:	7e 34                	jle    80103a2b <add_proc_to_q+0x4b>
801039f7:	89 fb                	mov    %edi,%ebx
		if(p->pid == queue[q_no][i]->pid)
801039f9:	8b 72 14             	mov    0x14(%edx),%esi
	for(int i=0; i < q_tail[q_no]; i++)
801039fc:	31 c0                	xor    %eax,%eax
801039fe:	c1 e3 08             	shl    $0x8,%ebx
80103a01:	eb 0c                	jmp    80103a0f <add_proc_to_q+0x2f>
80103a03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a07:	90                   	nop
80103a08:	83 c0 01             	add    $0x1,%eax
80103a0b:	39 c8                	cmp    %ecx,%eax
80103a0d:	74 19                	je     80103a28 <add_proc_to_q+0x48>
		if(p->pid == queue[q_no][i]->pid)
80103a0f:	8b 94 83 40 2d 11 80 	mov    -0x7feed2c0(%ebx,%eax,4),%edx
80103a16:	3b 72 14             	cmp    0x14(%edx),%esi
80103a19:	75 ed                	jne    80103a08 <add_proc_to_q+0x28>
}
80103a1b:	5b                   	pop    %ebx
			return -1;
80103a1c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103a21:	5e                   	pop    %esi
80103a22:	5f                   	pop    %edi
80103a23:	5d                   	pop    %ebp
80103a24:	c3                   	ret    
80103a25:	8d 76 00             	lea    0x0(%esi),%esi
80103a28:	8b 55 08             	mov    0x8(%ebp),%edx
	q_tail[q_no]++;
80103a2b:	83 c1 01             	add    $0x1,%ecx
	p -> queue = q_no;
80103a2e:	89 ba b4 00 00 00    	mov    %edi,0xb4(%edx)
	p->enter = ticks;
80103a34:	a1 84 65 11 80       	mov    0x80116584,%eax
	q_tail[q_no]++;
80103a39:	89 0c bd 0c b0 10 80 	mov    %ecx,-0x7fef4ff4(,%edi,4)
	queue[q_no][q_tail[q_no]] = p;
80103a40:	c1 e7 06             	shl    $0x6,%edi
80103a43:	01 cf                	add    %ecx,%edi
	p->enter = ticks;
80103a45:	89 82 c0 00 00 00    	mov    %eax,0xc0(%edx)
	return 1;
80103a4b:	b8 01 00 00 00       	mov    $0x1,%eax
}
80103a50:	5b                   	pop    %ebx
	queue[q_no][q_tail[q_no]] = p;
80103a51:	89 14 bd 40 2d 11 80 	mov    %edx,-0x7feed2c0(,%edi,4)
}
80103a58:	5e                   	pop    %esi
80103a59:	5f                   	pop    %edi
80103a5a:	5d                   	pop    %ebp
80103a5b:	c3                   	ret    
80103a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103a60 <remove_proc_from_q>:
{
80103a60:	55                   	push   %ebp
80103a61:	89 e5                	mov    %esp,%ebp
80103a63:	57                   	push   %edi
80103a64:	56                   	push   %esi
80103a65:	53                   	push   %ebx
80103a66:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	for(int i=0; i <= q_tail[q_no]; i++)
80103a69:	8b 0c 9d 0c b0 10 80 	mov    -0x7fef4ff4(,%ebx,4),%ecx
80103a70:	85 c9                	test   %ecx,%ecx
80103a72:	78 74                	js     80103ae8 <remove_proc_from_q+0x88>
		if(queue[q_no][i] -> pid == p->pid)
80103a74:	8b 45 08             	mov    0x8(%ebp),%eax
80103a77:	89 de                	mov    %ebx,%esi
80103a79:	c1 e6 08             	shl    $0x8,%esi
80103a7c:	8b 78 14             	mov    0x14(%eax),%edi
	for(int i=0; i <= q_tail[q_no]; i++)
80103a7f:	31 c0                	xor    %eax,%eax
80103a81:	eb 0c                	jmp    80103a8f <remove_proc_from_q+0x2f>
80103a83:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a87:	90                   	nop
80103a88:	83 c0 01             	add    $0x1,%eax
80103a8b:	39 c8                	cmp    %ecx,%eax
80103a8d:	7f 59                	jg     80103ae8 <remove_proc_from_q+0x88>
		if(queue[q_no][i] -> pid == p->pid)
80103a8f:	8b 94 86 40 2d 11 80 	mov    -0x7feed2c0(%esi,%eax,4),%edx
80103a96:	39 7a 14             	cmp    %edi,0x14(%edx)
80103a99:	75 ed                	jne    80103a88 <remove_proc_from_q+0x28>
	for(int i = rem; i < q_tail[q_no]; i++)
80103a9b:	39 c8                	cmp    %ecx,%eax
80103a9d:	7d 2e                	jge    80103acd <remove_proc_from_q+0x6d>
80103a9f:	89 da                	mov    %ebx,%edx
80103aa1:	c1 e2 06             	shl    $0x6,%edx
80103aa4:	01 d0                	add    %edx,%eax
80103aa6:	01 ca                	add    %ecx,%edx
80103aa8:	8d 04 85 40 2d 11 80 	lea    -0x7feed2c0(,%eax,4),%eax
80103aaf:	8d 34 95 40 2d 11 80 	lea    -0x7feed2c0(,%edx,4),%esi
80103ab6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103abd:	8d 76 00             	lea    0x0(%esi),%esi
	queue[q_no][i] = queue[q_no][i+1]; 
80103ac0:	8b 50 04             	mov    0x4(%eax),%edx
	for(int i = rem; i < q_tail[q_no]; i++)
80103ac3:	83 c0 04             	add    $0x4,%eax
	queue[q_no][i] = queue[q_no][i+1]; 
80103ac6:	89 50 fc             	mov    %edx,-0x4(%eax)
	for(int i = rem; i < q_tail[q_no]; i++)
80103ac9:	39 f0                	cmp    %esi,%eax
80103acb:	75 f3                	jne    80103ac0 <remove_proc_from_q+0x60>
	q_tail[q_no] -= 1;
80103acd:	83 e9 01             	sub    $0x1,%ecx
	return 1;
80103ad0:	b8 01 00 00 00       	mov    $0x1,%eax
	q_tail[q_no] -= 1;
80103ad5:	89 0c 9d 0c b0 10 80 	mov    %ecx,-0x7fef4ff4(,%ebx,4)
}
80103adc:	5b                   	pop    %ebx
80103add:	5e                   	pop    %esi
80103ade:	5f                   	pop    %edi
80103adf:	5d                   	pop    %ebp
80103ae0:	c3                   	ret    
80103ae1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ae8:	5b                   	pop    %ebx
		return -1;
80103ae9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103aee:	5e                   	pop    %esi
80103aef:	5f                   	pop    %edi
80103af0:	5d                   	pop    %ebp
80103af1:	c3                   	ret    
80103af2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103b00 <change_q_flag>:
{
80103b00:	55                   	push   %ebp
80103b01:	89 e5                	mov    %esp,%ebp
80103b03:	53                   	push   %ebx
80103b04:	83 ec 10             	sub    $0x10,%esp
80103b07:	8b 5d 08             	mov    0x8(%ebp),%ebx
	acquire(&ptable.lock);
80103b0a:	68 40 32 11 80       	push   $0x80113240
80103b0f:	e8 bc 17 00 00       	call   801052d0 <acquire>
	release(&ptable.lock);
80103b14:	83 c4 10             	add    $0x10,%esp
	p-> change_q = 1;
80103b17:	c7 83 bc 00 00 00 01 	movl   $0x1,0xbc(%ebx)
80103b1e:	00 00 00 
}
80103b21:	8b 5d fc             	mov    -0x4(%ebp),%ebx
	release(&ptable.lock);
80103b24:	c7 45 08 40 32 11 80 	movl   $0x80113240,0x8(%ebp)
}
80103b2b:	c9                   	leave  
	release(&ptable.lock);
80103b2c:	e9 3f 17 00 00       	jmp    80105270 <release>
80103b31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b3f:	90                   	nop

80103b40 <incr_curr_ticks>:
{
80103b40:	55                   	push   %ebp
80103b41:	89 e5                	mov    %esp,%ebp
80103b43:	53                   	push   %ebx
80103b44:	83 ec 10             	sub    $0x10,%esp
80103b47:	8b 5d 08             	mov    0x8(%ebp),%ebx
	acquire(&ptable.lock);
80103b4a:	68 40 32 11 80       	push   $0x80113240
80103b4f:	e8 7c 17 00 00       	call   801052d0 <acquire>
	p->qticks[p->queue]++;
80103b54:	8b 83 b4 00 00 00    	mov    0xb4(%ebx),%eax
	p->curr_ticks++;
80103b5a:	83 83 b8 00 00 00 01 	addl   $0x1,0xb8(%ebx)
	release(&ptable.lock);
80103b61:	83 c4 10             	add    $0x10,%esp
	p->qticks[p->queue]++;
80103b64:	83 84 83 a0 00 00 00 	addl   $0x1,0xa0(%ebx,%eax,4)
80103b6b:	01 
}
80103b6c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
	release(&ptable.lock);
80103b6f:	c7 45 08 40 32 11 80 	movl   $0x80113240,0x8(%ebp)
}
80103b76:	c9                   	leave  
	release(&ptable.lock);
80103b77:	e9 f4 16 00 00       	jmp    80105270 <release>
80103b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103b80 <pinit>:
{
80103b80:	55                   	push   %ebp
80103b81:	89 e5                	mov    %esp,%ebp
80103b83:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103b86:	68 80 85 10 80       	push   $0x80108580
80103b8b:	68 40 32 11 80       	push   $0x80113240
80103b90:	e8 6b 15 00 00       	call   80105100 <initlock>
}
80103b95:	83 c4 10             	add    $0x10,%esp
80103b98:	c9                   	leave  
80103b99:	c3                   	ret    
80103b9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ba0 <mycpu>:
{
80103ba0:	55                   	push   %ebp
80103ba1:	89 e5                	mov    %esp,%ebp
80103ba3:	56                   	push   %esi
80103ba4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ba5:	9c                   	pushf  
80103ba6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103ba7:	f6 c4 02             	test   $0x2,%ah
80103baa:	75 46                	jne    80103bf2 <mycpu+0x52>
  apicid = lapicid();
80103bac:	e8 3f ed ff ff       	call   801028f0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103bb1:	8b 35 a4 27 11 80    	mov    0x801127a4,%esi
80103bb7:	85 f6                	test   %esi,%esi
80103bb9:	7e 2a                	jle    80103be5 <mycpu+0x45>
80103bbb:	31 d2                	xor    %edx,%edx
80103bbd:	eb 08                	jmp    80103bc7 <mycpu+0x27>
80103bbf:	90                   	nop
80103bc0:	83 c2 01             	add    $0x1,%edx
80103bc3:	39 f2                	cmp    %esi,%edx
80103bc5:	74 1e                	je     80103be5 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103bc7:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103bcd:	0f b6 99 c0 27 11 80 	movzbl -0x7feed840(%ecx),%ebx
80103bd4:	39 c3                	cmp    %eax,%ebx
80103bd6:	75 e8                	jne    80103bc0 <mycpu+0x20>
}
80103bd8:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103bdb:	8d 81 c0 27 11 80    	lea    -0x7feed840(%ecx),%eax
}
80103be1:	5b                   	pop    %ebx
80103be2:	5e                   	pop    %esi
80103be3:	5d                   	pop    %ebp
80103be4:	c3                   	ret    
  panic("unknown apicid\n");
80103be5:	83 ec 0c             	sub    $0xc,%esp
80103be8:	68 87 85 10 80       	push   $0x80108587
80103bed:	e8 8e c7 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103bf2:	83 ec 0c             	sub    $0xc,%esp
80103bf5:	68 4c 87 10 80       	push   $0x8010874c
80103bfa:	e8 81 c7 ff ff       	call   80100380 <panic>
80103bff:	90                   	nop

80103c00 <cpuid>:
cpuid() {
80103c00:	55                   	push   %ebp
80103c01:	89 e5                	mov    %esp,%ebp
80103c03:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103c06:	e8 95 ff ff ff       	call   80103ba0 <mycpu>
}
80103c0b:	c9                   	leave  
  return mycpu()-cpus;
80103c0c:	2d c0 27 11 80       	sub    $0x801127c0,%eax
80103c11:	c1 f8 04             	sar    $0x4,%eax
80103c14:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103c1a:	c3                   	ret    
80103c1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c1f:	90                   	nop

80103c20 <myproc>:
myproc(void) {
80103c20:	55                   	push   %ebp
80103c21:	89 e5                	mov    %esp,%ebp
80103c23:	53                   	push   %ebx
80103c24:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103c27:	e8 54 15 00 00       	call   80105180 <pushcli>
  c = mycpu();
80103c2c:	e8 6f ff ff ff       	call   80103ba0 <mycpu>
  p = c->proc;
80103c31:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c37:	e8 94 15 00 00       	call   801051d0 <popcli>
}
80103c3c:	89 d8                	mov    %ebx,%eax
80103c3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c41:	c9                   	leave  
80103c42:	c3                   	ret    
80103c43:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103c50 <userinit>:
{
80103c50:	55                   	push   %ebp
80103c51:	89 e5                	mov    %esp,%ebp
80103c53:	56                   	push   %esi
80103c54:	53                   	push   %ebx
  p = allocproc();
80103c55:	e8 56 fb ff ff       	call   801037b0 <allocproc>
80103c5a:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103c5c:	a3 74 65 11 80       	mov    %eax,0x80116574
  if((p->pgdir = setupkvm()) == 0)
80103c61:	e8 8a 40 00 00       	call   80107cf0 <setupkvm>
80103c66:	89 43 04             	mov    %eax,0x4(%ebx)
80103c69:	85 c0                	test   %eax,%eax
80103c6b:	0f 84 16 01 00 00    	je     80103d87 <userinit+0x137>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103c71:	83 ec 04             	sub    $0x4,%esp
80103c74:	68 2c 00 00 00       	push   $0x2c
80103c79:	68 80 b4 10 80       	push   $0x8010b480
80103c7e:	50                   	push   %eax
80103c7f:	e8 1c 3d 00 00       	call   801079a0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103c84:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103c87:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103c8d:	6a 4c                	push   $0x4c
80103c8f:	6a 00                	push   $0x0
80103c91:	ff 73 20             	push   0x20(%ebx)
80103c94:	e8 f7 16 00 00       	call   80105390 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103c99:	8b 43 20             	mov    0x20(%ebx),%eax
80103c9c:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103ca1:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103ca4:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103ca9:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103cad:	8b 43 20             	mov    0x20(%ebx),%eax
80103cb0:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103cb4:	8b 43 20             	mov    0x20(%ebx),%eax
80103cb7:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103cbb:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103cbf:	8b 43 20             	mov    0x20(%ebx),%eax
80103cc2:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103cc6:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103cca:	8b 43 20             	mov    0x20(%ebx),%eax
80103ccd:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103cd4:	8b 43 20             	mov    0x20(%ebx),%eax
80103cd7:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  
80103cde:	8b 43 20             	mov    0x20(%ebx),%eax
80103ce1:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103ce8:	8d 43 74             	lea    0x74(%ebx),%eax
80103ceb:	6a 10                	push   $0x10
80103ced:	68 b0 85 10 80       	push   $0x801085b0
80103cf2:	50                   	push   %eax
80103cf3:	e8 58 18 00 00       	call   80105550 <safestrcpy>
  p->cwd = namei("/");
80103cf8:	c7 04 24 b9 85 10 80 	movl   $0x801085b9,(%esp)
80103cff:	e8 9c e3 ff ff       	call   801020a0 <namei>
80103d04:	89 43 70             	mov    %eax,0x70(%ebx)
  acquire(&ptable.lock);
80103d07:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
80103d0e:	e8 bd 15 00 00       	call   801052d0 <acquire>
	for(int i=0; i < q_tail[q_no]; i++)
80103d13:	8b 0d 0c b0 10 80    	mov    0x8010b00c,%ecx
  p->state = RUNNABLE;
80103d19:	c7 43 10 03 00 00 00 	movl   $0x3,0x10(%ebx)
	for(int i=0; i < q_tail[q_no]; i++)
80103d20:	83 c4 10             	add    $0x10,%esp
80103d23:	85 c9                	test   %ecx,%ecx
80103d25:	7e 39                	jle    80103d60 <userinit+0x110>
		if(p->pid == queue[q_no][i]->pid)
80103d27:	8b 73 14             	mov    0x14(%ebx),%esi
	for(int i=0; i < q_tail[q_no]; i++)
80103d2a:	31 c0                	xor    %eax,%eax
80103d2c:	eb 09                	jmp    80103d37 <userinit+0xe7>
80103d2e:	66 90                	xchg   %ax,%ax
80103d30:	83 c0 01             	add    $0x1,%eax
80103d33:	39 c8                	cmp    %ecx,%eax
80103d35:	74 29                	je     80103d60 <userinit+0x110>
		if(p->pid == queue[q_no][i]->pid)
80103d37:	8b 14 85 40 2d 11 80 	mov    -0x7feed2c0(,%eax,4),%edx
80103d3e:	3b 72 14             	cmp    0x14(%edx),%esi
80103d41:	75 ed                	jne    80103d30 <userinit+0xe0>
  release(&ptable.lock);
80103d43:	83 ec 0c             	sub    $0xc,%esp
80103d46:	68 40 32 11 80       	push   $0x80113240
80103d4b:	e8 20 15 00 00       	call   80105270 <release>
}
80103d50:	83 c4 10             	add    $0x10,%esp
80103d53:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d56:	5b                   	pop    %ebx
80103d57:	5e                   	pop    %esi
80103d58:	5d                   	pop    %ebp
80103d59:	c3                   	ret    
80103d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	p->enter = ticks;
80103d60:	a1 84 65 11 80       	mov    0x80116584,%eax
	q_tail[q_no]++;
80103d65:	83 c1 01             	add    $0x1,%ecx
	p -> queue = q_no;
80103d68:	c7 83 b4 00 00 00 00 	movl   $0x0,0xb4(%ebx)
80103d6f:	00 00 00 
	q_tail[q_no]++;
80103d72:	89 0d 0c b0 10 80    	mov    %ecx,0x8010b00c
	p->enter = ticks;
80103d78:	89 83 c0 00 00 00    	mov    %eax,0xc0(%ebx)
	queue[q_no][q_tail[q_no]] = p;
80103d7e:	89 1c 8d 40 2d 11 80 	mov    %ebx,-0x7feed2c0(,%ecx,4)
	return 1;
80103d85:	eb bc                	jmp    80103d43 <userinit+0xf3>
    panic("userinit: out of memory?");
80103d87:	83 ec 0c             	sub    $0xc,%esp
80103d8a:	68 97 85 10 80       	push   $0x80108597
80103d8f:	e8 ec c5 ff ff       	call   80100380 <panic>
80103d94:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d9f:	90                   	nop

80103da0 <growproc>:
{
80103da0:	55                   	push   %ebp
80103da1:	89 e5                	mov    %esp,%ebp
80103da3:	57                   	push   %edi
80103da4:	56                   	push   %esi
80103da5:	53                   	push   %ebx
80103da6:	83 ec 0c             	sub    $0xc,%esp
80103da9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80103dac:	e8 cf 13 00 00       	call   80105180 <pushcli>
  c = mycpu();
80103db1:	e8 ea fd ff ff       	call   80103ba0 <mycpu>
  p = c->proc;
80103db6:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103dbc:	e8 0f 14 00 00       	call   801051d0 <popcli>
  sz = curproc->sz;
80103dc1:	8b 3e                	mov    (%esi),%edi
  if(n > 0){
80103dc3:	85 db                	test   %ebx,%ebx
80103dc5:	7f 7d                	jg     80103e44 <growproc+0xa4>
  } else if(n < 0){
80103dc7:	0f 85 a3 00 00 00    	jne    80103e70 <growproc+0xd0>
  acquire(&ptable.lock);
80103dcd:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103dd0:	89 3e                	mov    %edi,(%esi)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103dd2:	bb 74 32 11 80       	mov    $0x80113274,%ebx
  acquire(&ptable.lock);
80103dd7:	68 40 32 11 80       	push   $0x80113240
80103ddc:	e8 ef 14 00 00       	call   801052d0 <acquire>
80103de1:	83 c4 10             	add    $0x10,%esp
80103de4:	eb 18                	jmp    80103dfe <growproc+0x5e>
80103de6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ded:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103df0:	81 c3 cc 00 00 00    	add    $0xcc,%ebx
80103df6:	81 fb 74 65 11 80    	cmp    $0x80116574,%ebx
80103dfc:	74 24                	je     80103e22 <growproc+0x82>
      if(p->pgdir != curproc->pgdir)
80103dfe:	8b 46 04             	mov    0x4(%esi),%eax
80103e01:	39 43 04             	cmp    %eax,0x4(%ebx)
80103e04:	75 ea                	jne    80103df0 <growproc+0x50>
      switchuvm(p); 
80103e06:	83 ec 0c             	sub    $0xc,%esp
      p->sz = sz;
80103e09:	89 3b                	mov    %edi,(%ebx)
      switchuvm(p); 
80103e0b:	53                   	push   %ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e0c:	81 c3 cc 00 00 00    	add    $0xcc,%ebx
      switchuvm(p); 
80103e12:	e8 79 3a 00 00       	call   80107890 <switchuvm>
80103e17:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e1a:	81 fb 74 65 11 80    	cmp    $0x80116574,%ebx
80103e20:	75 dc                	jne    80103dfe <growproc+0x5e>
  release(&ptable.lock);
80103e22:	83 ec 0c             	sub    $0xc,%esp
80103e25:	68 40 32 11 80       	push   $0x80113240
80103e2a:	e8 41 14 00 00       	call   80105270 <release>
  switchuvm(curproc);
80103e2f:	89 34 24             	mov    %esi,(%esp)
80103e32:	e8 59 3a 00 00       	call   80107890 <switchuvm>
  return 0;
80103e37:	83 c4 10             	add    $0x10,%esp
80103e3a:	31 c0                	xor    %eax,%eax
}
80103e3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e3f:	5b                   	pop    %ebx
80103e40:	5e                   	pop    %esi
80103e41:	5f                   	pop    %edi
80103e42:	5d                   	pop    %ebp
80103e43:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103e44:	83 ec 04             	sub    $0x4,%esp
80103e47:	01 fb                	add    %edi,%ebx
80103e49:	53                   	push   %ebx
80103e4a:	57                   	push   %edi
80103e4b:	ff 76 04             	push   0x4(%esi)
80103e4e:	e8 bd 3c 00 00       	call   80107b10 <allocuvm>
80103e53:	83 c4 10             	add    $0x10,%esp
80103e56:	89 c7                	mov    %eax,%edi
80103e58:	85 c0                	test   %eax,%eax
80103e5a:	0f 85 6d ff ff ff    	jne    80103dcd <growproc+0x2d>
      return -1;
80103e60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e65:	eb d5                	jmp    80103e3c <growproc+0x9c>
80103e67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e6e:	66 90                	xchg   %ax,%ax
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103e70:	83 ec 04             	sub    $0x4,%esp
80103e73:	01 fb                	add    %edi,%ebx
80103e75:	53                   	push   %ebx
80103e76:	57                   	push   %edi
80103e77:	ff 76 04             	push   0x4(%esi)
80103e7a:	e8 c1 3d 00 00       	call   80107c40 <deallocuvm>
80103e7f:	83 c4 10             	add    $0x10,%esp
80103e82:	89 c7                	mov    %eax,%edi
80103e84:	85 c0                	test   %eax,%eax
80103e86:	0f 85 41 ff ff ff    	jne    80103dcd <growproc+0x2d>
80103e8c:	eb d2                	jmp    80103e60 <growproc+0xc0>
80103e8e:	66 90                	xchg   %ax,%ax

80103e90 <fork>:
{
80103e90:	55                   	push   %ebp
80103e91:	89 e5                	mov    %esp,%ebp
80103e93:	57                   	push   %edi
80103e94:	56                   	push   %esi
80103e95:	53                   	push   %ebx
80103e96:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103e99:	e8 e2 12 00 00       	call   80105180 <pushcli>
  c = mycpu();
80103e9e:	e8 fd fc ff ff       	call   80103ba0 <mycpu>
  p = c->proc;
80103ea3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ea9:	e8 22 13 00 00       	call   801051d0 <popcli>
  if((np = allocproc()) == 0){
80103eae:	e8 fd f8 ff ff       	call   801037b0 <allocproc>
80103eb3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103eb6:	85 c0                	test   %eax,%eax
80103eb8:	0f 84 0c 01 00 00    	je     80103fca <fork+0x13a>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103ebe:	83 ec 08             	sub    $0x8,%esp
80103ec1:	ff 33                	push   (%ebx)
80103ec3:	89 c7                	mov    %eax,%edi
80103ec5:	ff 73 04             	push   0x4(%ebx)
80103ec8:	e8 13 3f 00 00       	call   80107de0 <copyuvm>
80103ecd:	83 c4 10             	add    $0x10,%esp
80103ed0:	89 47 04             	mov    %eax,0x4(%edi)
80103ed3:	85 c0                	test   %eax,%eax
80103ed5:	0f 84 f6 00 00 00    	je     80103fd1 <fork+0x141>
  np->sz = curproc->sz;
80103edb:	8b 03                	mov    (%ebx),%eax
80103edd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103ee0:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103ee2:	8b 79 20             	mov    0x20(%ecx),%edi
  np->parent = curproc;
80103ee5:	89 c8                	mov    %ecx,%eax
80103ee7:	89 59 1c             	mov    %ebx,0x1c(%ecx)
  *np->tf = *curproc->tf;
80103eea:	b9 13 00 00 00       	mov    $0x13,%ecx
80103eef:	8b 73 20             	mov    0x20(%ebx),%esi
80103ef2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103ef4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103ef6:	8b 40 20             	mov    0x20(%eax),%eax
80103ef9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103f00:	8b 44 b3 30          	mov    0x30(%ebx,%esi,4),%eax
80103f04:	85 c0                	test   %eax,%eax
80103f06:	74 13                	je     80103f1b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103f08:	83 ec 0c             	sub    $0xc,%esp
80103f0b:	50                   	push   %eax
80103f0c:	e8 8f cf ff ff       	call   80100ea0 <filedup>
80103f11:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103f14:	83 c4 10             	add    $0x10,%esp
80103f17:	89 44 b7 30          	mov    %eax,0x30(%edi,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103f1b:	83 c6 01             	add    $0x1,%esi
80103f1e:	83 fe 10             	cmp    $0x10,%esi
80103f21:	75 dd                	jne    80103f00 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103f23:	83 ec 0c             	sub    $0xc,%esp
80103f26:	ff 73 70             	push   0x70(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103f29:	83 c3 74             	add    $0x74,%ebx
  np->cwd = idup(curproc->cwd);
80103f2c:	e8 1f d8 ff ff       	call   80101750 <idup>
80103f31:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103f34:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103f37:	89 47 70             	mov    %eax,0x70(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103f3a:	8d 47 74             	lea    0x74(%edi),%eax
80103f3d:	6a 10                	push   $0x10
80103f3f:	53                   	push   %ebx
80103f40:	50                   	push   %eax
80103f41:	e8 0a 16 00 00       	call   80105550 <safestrcpy>
  pid = np->pid;
80103f46:	8b 5f 14             	mov    0x14(%edi),%ebx
  acquire(&ptable.lock);
80103f49:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
80103f50:	e8 7b 13 00 00       	call   801052d0 <acquire>
	for(int i=0; i < q_tail[q_no]; i++)
80103f55:	8b 0d 0c b0 10 80    	mov    0x8010b00c,%ecx
  np->state = RUNNABLE;
80103f5b:	c7 47 10 03 00 00 00 	movl   $0x3,0x10(%edi)
	for(int i=0; i < q_tail[q_no]; i++)
80103f62:	83 c4 10             	add    $0x10,%esp
80103f65:	85 c9                	test   %ecx,%ecx
80103f67:	7e 37                	jle    80103fa0 <fork+0x110>
		if(p->pid == queue[q_no][i]->pid)
80103f69:	8b 77 14             	mov    0x14(%edi),%esi
	for(int i=0; i < q_tail[q_no]; i++)
80103f6c:	31 c0                	xor    %eax,%eax
80103f6e:	eb 07                	jmp    80103f77 <fork+0xe7>
80103f70:	83 c0 01             	add    $0x1,%eax
80103f73:	39 c8                	cmp    %ecx,%eax
80103f75:	74 29                	je     80103fa0 <fork+0x110>
		if(p->pid == queue[q_no][i]->pid)
80103f77:	8b 14 85 40 2d 11 80 	mov    -0x7feed2c0(,%eax,4),%edx
80103f7e:	3b 72 14             	cmp    0x14(%edx),%esi
80103f81:	75 ed                	jne    80103f70 <fork+0xe0>
  release(&ptable.lock);
80103f83:	83 ec 0c             	sub    $0xc,%esp
80103f86:	68 40 32 11 80       	push   $0x80113240
80103f8b:	e8 e0 12 00 00       	call   80105270 <release>
  return pid;
80103f90:	83 c4 10             	add    $0x10,%esp
}
80103f93:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f96:	89 d8                	mov    %ebx,%eax
80103f98:	5b                   	pop    %ebx
80103f99:	5e                   	pop    %esi
80103f9a:	5f                   	pop    %edi
80103f9b:	5d                   	pop    %ebp
80103f9c:	c3                   	ret    
80103f9d:	8d 76 00             	lea    0x0(%esi),%esi
	p->enter = ticks;
80103fa0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103fa3:	a1 84 65 11 80       	mov    0x80116584,%eax
	q_tail[q_no]++;
80103fa8:	83 c1 01             	add    $0x1,%ecx
80103fab:	89 0d 0c b0 10 80    	mov    %ecx,0x8010b00c
	p->enter = ticks;
80103fb1:	89 82 c0 00 00 00    	mov    %eax,0xc0(%edx)
	p -> queue = q_no;
80103fb7:	c7 82 b4 00 00 00 00 	movl   $0x0,0xb4(%edx)
80103fbe:	00 00 00 
	queue[q_no][q_tail[q_no]] = p;
80103fc1:	89 14 8d 40 2d 11 80 	mov    %edx,-0x7feed2c0(,%ecx,4)
	return 1;
80103fc8:	eb b9                	jmp    80103f83 <fork+0xf3>
    return -1;
80103fca:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103fcf:	eb c2                	jmp    80103f93 <fork+0x103>
    kfree(np->kstack);
80103fd1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103fd4:	83 ec 0c             	sub    $0xc,%esp
80103fd7:	ff 73 08             	push   0x8(%ebx)
80103fda:	e8 e1 e4 ff ff       	call   801024c0 <kfree>
    np->kstack = 0;
80103fdf:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103fe6:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103fe9:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
    return -1;
80103ff0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103ff5:	eb 9c                	jmp    80103f93 <fork+0x103>
80103ff7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ffe:	66 90                	xchg   %ax,%ax

80104000 <scheduler>:
{
80104000:	55                   	push   %ebp
80104001:	89 e5                	mov    %esp,%ebp
80104003:	57                   	push   %edi
80104004:	56                   	push   %esi
80104005:	53                   	push   %ebx
80104006:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80104009:	e8 92 fb ff ff       	call   80103ba0 <mycpu>
  c->proc = 0;
8010400e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104015:	00 00 00 
  struct cpu *c = mycpu();
80104018:	89 45 dc             	mov    %eax,-0x24(%ebp)
  c->proc = 0;
8010401b:	83 c0 04             	add    $0x4,%eax
8010401e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80104021:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
80104028:	fb                   	sti    
    acquire(&ptable.lock);
80104029:	83 ec 0c             	sub    $0xc,%esp
8010402c:	68 40 32 11 80       	push   $0x80113240
80104031:	e8 9a 12 00 00       	call   801052d0 <acquire>
80104036:	83 c4 10             	add    $0x10,%esp
80104039:	ba 00 01 00 00       	mov    $0x100,%edx
8010403e:	31 c9                	xor    %ecx,%ecx
80104040:	89 cf                	mov    %ecx,%edi
				for(int j=0; j <= q_tail[i]; j++)
80104042:	31 db                	xor    %ebx,%ebx
80104044:	83 c1 01             	add    $0x1,%ecx
80104047:	8b 34 bd 10 b0 10 80 	mov    -0x7fef4ff0(,%edi,4),%esi
8010404e:	85 f6                	test   %esi,%esi
80104050:	78 5e                	js     801040b0 <scheduler+0xb0>
80104052:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80104055:	eb 15                	jmp    8010406c <scheduler+0x6c>
80104057:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010405e:	66 90                	xchg   %ax,%ax
80104060:	83 c3 01             	add    $0x1,%ebx
80104063:	39 1c bd 10 b0 10 80 	cmp    %ebx,-0x7fef4ff0(,%edi,4)
8010406a:	7c 41                	jl     801040ad <scheduler+0xad>
					struct proc *p = queue[i][j];
8010406c:	8b b4 9a 40 2d 11 80 	mov    -0x7feed2c0(%edx,%ebx,4),%esi
          				int age = ticks - p->enter;
80104073:	a1 84 65 11 80       	mov    0x80116584,%eax
80104078:	2b 86 c0 00 00 00    	sub    0xc0(%esi),%eax
					if(age > 30)
8010407e:	83 f8 1e             	cmp    $0x1e,%eax
80104081:	7e dd                	jle    80104060 <scheduler+0x60>
						remove_proc_from_q(p, i);
80104083:	83 ec 08             	sub    $0x8,%esp
80104086:	ff 75 e0             	push   -0x20(%ebp)
				for(int j=0; j <= q_tail[i]; j++)
80104089:	83 c3 01             	add    $0x1,%ebx
						remove_proc_from_q(p, i);
8010408c:	56                   	push   %esi
8010408d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80104090:	e8 cb f9 ff ff       	call   80103a60 <remove_proc_from_q>
						add_proc_to_q(p, i-1);
80104095:	58                   	pop    %eax
80104096:	5a                   	pop    %edx
80104097:	57                   	push   %edi
80104098:	56                   	push   %esi
80104099:	e8 42 f9 ff ff       	call   801039e0 <add_proc_to_q>
8010409e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801040a1:	83 c4 10             	add    $0x10,%esp
				for(int j=0; j <= q_tail[i]; j++)
801040a4:	39 1c bd 10 b0 10 80 	cmp    %ebx,-0x7fef4ff0(,%edi,4)
801040ab:	7d bf                	jge    8010406c <scheduler+0x6c>
801040ad:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      for(int i=1; i < 5; i++)
801040b0:	81 c2 00 01 00 00    	add    $0x100,%edx
801040b6:	83 f9 04             	cmp    $0x4,%ecx
801040b9:	75 85                	jne    80104040 <scheduler+0x40>
			for(int i=0; i < 5; i++)
801040bb:	31 c0                	xor    %eax,%eax
				if(q_tail[i] >=0)
801040bd:	8b 0c 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%ecx
801040c4:	85 c9                	test   %ecx,%ecx
801040c6:	79 1d                	jns    801040e5 <scheduler+0xe5>
			for(int i=0; i < 5; i++)
801040c8:	83 c0 01             	add    $0x1,%eax
801040cb:	83 f8 05             	cmp    $0x5,%eax
801040ce:	75 ed                	jne    801040bd <scheduler+0xbd>
    release(&ptable.lock);
801040d0:	83 ec 0c             	sub    $0xc,%esp
801040d3:	68 40 32 11 80       	push   $0x80113240
801040d8:	e8 93 11 00 00       	call   80105270 <release>
  for(;;){
801040dd:	83 c4 10             	add    $0x10,%esp
801040e0:	e9 43 ff ff ff       	jmp    80104028 <scheduler+0x28>
					p = queue[i][0];
801040e5:	89 c2                	mov    %eax,%edx
					remove_proc_from_q(p, i);
801040e7:	83 ec 08             	sub    $0x8,%esp
					p = queue[i][0];
801040ea:	c1 e2 08             	shl    $0x8,%edx
					remove_proc_from_q(p, i);
801040ed:	50                   	push   %eax
					p = queue[i][0];
801040ee:	8b 9a 40 2d 11 80    	mov    -0x7feed2c0(%edx),%ebx
					remove_proc_from_q(p, i);
801040f4:	53                   	push   %ebx
801040f5:	e8 66 f9 ff ff       	call   80103a60 <remove_proc_from_q>
			if(p!=0 && p->state==RUNNABLE)
801040fa:	83 c4 10             	add    $0x10,%esp
801040fd:	85 db                	test   %ebx,%ebx
801040ff:	74 cf                	je     801040d0 <scheduler+0xd0>
80104101:	83 7b 10 03          	cmpl   $0x3,0x10(%ebx)
80104105:	75 c9                	jne    801040d0 <scheduler+0xd0>
				c->proc = p;
80104107:	8b 7d dc             	mov    -0x24(%ebp),%edi
				switchuvm(p);
8010410a:	83 ec 0c             	sub    $0xc,%esp
				p->num_run++;
8010410d:	83 83 9c 00 00 00 01 	addl   $0x1,0x9c(%ebx)
				c->proc = p;
80104114:	89 9f ac 00 00 00    	mov    %ebx,0xac(%edi)
				switchuvm(p);
8010411a:	53                   	push   %ebx
8010411b:	e8 70 37 00 00       	call   80107890 <switchuvm>
				p->state = RUNNING;
80104120:	c7 43 10 04 00 00 00 	movl   $0x4,0x10(%ebx)
				swtch(&c->scheduler, p->context);
80104127:	58                   	pop    %eax
80104128:	5a                   	pop    %edx
80104129:	ff 73 24             	push   0x24(%ebx)
8010412c:	ff 75 d8             	push   -0x28(%ebp)
8010412f:	e8 77 14 00 00       	call   801055ab <swtch>
				switchkvm();
80104134:	e8 47 37 00 00       	call   80107880 <switchkvm>
				if(p!=0 && p->state == RUNNABLE)
80104139:	83 c4 10             	add    $0x10,%esp
				c->proc = 0;
8010413c:	c7 87 ac 00 00 00 00 	movl   $0x0,0xac(%edi)
80104143:	00 00 00 
				if(p!=0 && p->state == RUNNABLE)
80104146:	83 7b 10 03          	cmpl   $0x3,0x10(%ebx)
8010414a:	75 84                	jne    801040d0 <scheduler+0xd0>
					if(p->change_q == 1)
8010414c:	83 bb bc 00 00 00 01 	cmpl   $0x1,0xbc(%ebx)
						if(p->queue != 4){
80104153:	8b 83 b4 00 00 00    	mov    0xb4(%ebx),%eax
					if(p->change_q == 1)
80104159:	74 2c                	je     80104187 <scheduler+0x187>
					else p->curr_ticks = 0;
8010415b:	c7 83 b8 00 00 00 00 	movl   $0x0,0xb8(%ebx)
80104162:	00 00 00 
					add_proc_to_q(p,p->queue);
80104165:	83 ec 08             	sub    $0x8,%esp
80104168:	50                   	push   %eax
80104169:	53                   	push   %ebx
8010416a:	e8 71 f8 ff ff       	call   801039e0 <add_proc_to_q>
8010416f:	83 c4 10             	add    $0x10,%esp
    release(&ptable.lock);
80104172:	83 ec 0c             	sub    $0xc,%esp
80104175:	68 40 32 11 80       	push   $0x80113240
8010417a:	e8 f1 10 00 00       	call   80105270 <release>
  for(;;){
8010417f:	83 c4 10             	add    $0x10,%esp
80104182:	e9 a1 fe ff ff       	jmp    80104028 <scheduler+0x28>
						p->change_q = 0;
80104187:	c7 83 bc 00 00 00 00 	movl   $0x0,0xbc(%ebx)
8010418e:	00 00 00 
						p->curr_ticks = 0;
80104191:	c7 83 b8 00 00 00 00 	movl   $0x0,0xb8(%ebx)
80104198:	00 00 00 
						if(p->queue != 4){
8010419b:	83 f8 04             	cmp    $0x4,%eax
8010419e:	74 c5                	je     80104165 <scheduler+0x165>
						p->queue+=1;
801041a0:	83 c0 01             	add    $0x1,%eax
801041a3:	89 83 b4 00 00 00    	mov    %eax,0xb4(%ebx)
801041a9:	eb ba                	jmp    80104165 <scheduler+0x165>
801041ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041af:	90                   	nop

801041b0 <sched>:
{
801041b0:	55                   	push   %ebp
801041b1:	89 e5                	mov    %esp,%ebp
801041b3:	56                   	push   %esi
801041b4:	53                   	push   %ebx
  pushcli();
801041b5:	e8 c6 0f 00 00       	call   80105180 <pushcli>
  c = mycpu();
801041ba:	e8 e1 f9 ff ff       	call   80103ba0 <mycpu>
  p = c->proc;
801041bf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041c5:	e8 06 10 00 00       	call   801051d0 <popcli>
  if(!holding(&ptable.lock))
801041ca:	83 ec 0c             	sub    $0xc,%esp
801041cd:	68 40 32 11 80       	push   $0x80113240
801041d2:	e8 59 10 00 00       	call   80105230 <holding>
801041d7:	83 c4 10             	add    $0x10,%esp
801041da:	85 c0                	test   %eax,%eax
801041dc:	74 4f                	je     8010422d <sched+0x7d>
  if(mycpu()->ncli != 1)
801041de:	e8 bd f9 ff ff       	call   80103ba0 <mycpu>
801041e3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801041ea:	75 68                	jne    80104254 <sched+0xa4>
  if(p->state == RUNNING)
801041ec:	83 7b 10 04          	cmpl   $0x4,0x10(%ebx)
801041f0:	74 55                	je     80104247 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801041f2:	9c                   	pushf  
801041f3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801041f4:	f6 c4 02             	test   $0x2,%ah
801041f7:	75 41                	jne    8010423a <sched+0x8a>
  intena = mycpu()->intena;
801041f9:	e8 a2 f9 ff ff       	call   80103ba0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
801041fe:	83 c3 24             	add    $0x24,%ebx
  intena = mycpu()->intena;
80104201:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104207:	e8 94 f9 ff ff       	call   80103ba0 <mycpu>
8010420c:	83 ec 08             	sub    $0x8,%esp
8010420f:	ff 70 04             	push   0x4(%eax)
80104212:	53                   	push   %ebx
80104213:	e8 93 13 00 00       	call   801055ab <swtch>
  mycpu()->intena = intena;
80104218:	e8 83 f9 ff ff       	call   80103ba0 <mycpu>
}
8010421d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104220:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104226:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104229:	5b                   	pop    %ebx
8010422a:	5e                   	pop    %esi
8010422b:	5d                   	pop    %ebp
8010422c:	c3                   	ret    
    panic("sched ptable.lock");
8010422d:	83 ec 0c             	sub    $0xc,%esp
80104230:	68 bb 85 10 80       	push   $0x801085bb
80104235:	e8 46 c1 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
8010423a:	83 ec 0c             	sub    $0xc,%esp
8010423d:	68 e7 85 10 80       	push   $0x801085e7
80104242:	e8 39 c1 ff ff       	call   80100380 <panic>
    panic("sched running");
80104247:	83 ec 0c             	sub    $0xc,%esp
8010424a:	68 d9 85 10 80       	push   $0x801085d9
8010424f:	e8 2c c1 ff ff       	call   80100380 <panic>
    panic("sched locks");
80104254:	83 ec 0c             	sub    $0xc,%esp
80104257:	68 cd 85 10 80       	push   $0x801085cd
8010425c:	e8 1f c1 ff ff       	call   80100380 <panic>
80104261:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104268:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010426f:	90                   	nop

80104270 <exit>:
{
80104270:	55                   	push   %ebp
80104271:	89 e5                	mov    %esp,%ebp
80104273:	57                   	push   %edi
80104274:	56                   	push   %esi
80104275:	53                   	push   %ebx
80104276:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
80104279:	e8 a2 f9 ff ff       	call   80103c20 <myproc>
  if(curproc == initproc)
8010427e:	39 05 74 65 11 80    	cmp    %eax,0x80116574
80104284:	0f 84 8a 01 00 00    	je     80104414 <exit+0x1a4>
8010428a:	89 c2                	mov    %eax,%edx
8010428c:	8d 58 30             	lea    0x30(%eax),%ebx
8010428f:	8d 70 70             	lea    0x70(%eax),%esi
80104292:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80104298:	8b 03                	mov    (%ebx),%eax
8010429a:	85 c0                	test   %eax,%eax
8010429c:	74 18                	je     801042b6 <exit+0x46>
      fileclose(curproc->ofile[fd]);
8010429e:	83 ec 0c             	sub    $0xc,%esp
801042a1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801042a4:	50                   	push   %eax
801042a5:	e8 46 cc ff ff       	call   80100ef0 <fileclose>
      curproc->ofile[fd] = 0;
801042aa:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801042b0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801042b3:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
801042b6:	83 c3 04             	add    $0x4,%ebx
801042b9:	39 f3                	cmp    %esi,%ebx
801042bb:	75 db                	jne    80104298 <exit+0x28>
801042bd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
static void
wakeup1(void *chan)
{
  struct proc *p;	

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042c0:	bb 74 32 11 80       	mov    $0x80113274,%ebx
  begin_op();
801042c5:	e8 96 ea ff ff       	call   80102d60 <begin_op>
  iput(curproc->cwd);
801042ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801042cd:	83 ec 0c             	sub    $0xc,%esp
801042d0:	ff 72 70             	push   0x70(%edx)
801042d3:	e8 d8 d5 ff ff       	call   801018b0 <iput>
  end_op();
801042d8:	e8 f3 ea ff ff       	call   80102dd0 <end_op>
  curproc->cwd = 0;
801042dd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801042e0:	c7 42 70 00 00 00 00 	movl   $0x0,0x70(%edx)
  acquire(&ptable.lock);
801042e7:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
801042ee:	e8 dd 0f 00 00       	call   801052d0 <acquire>
  wakeup1(curproc->parent);
801042f3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801042f6:	83 c4 10             	add    $0x10,%esp
801042f9:	8b 72 1c             	mov    0x1c(%edx),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042fc:	eb 10                	jmp    8010430e <exit+0x9e>
801042fe:	66 90                	xchg   %ax,%ax
80104300:	81 c3 cc 00 00 00    	add    $0xcc,%ebx
80104306:	81 fb 74 65 11 80    	cmp    $0x80116574,%ebx
8010430c:	74 42                	je     80104350 <exit+0xe0>
    if(p->state == SLEEPING && p->chan == chan){
8010430e:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
80104312:	75 ec                	jne    80104300 <exit+0x90>
80104314:	3b 73 28             	cmp    0x28(%ebx),%esi
80104317:	75 e7                	jne    80104300 <exit+0x90>
      p->state = RUNNABLE;
      #ifdef MLFQ
		p->curr_ticks = 0;
		add_proc_to_q(p, p->queue);
80104319:	83 ec 08             	sub    $0x8,%esp
      p->state = RUNNABLE;
8010431c:	c7 43 10 03 00 00 00 	movl   $0x3,0x10(%ebx)
		p->curr_ticks = 0;
80104323:	c7 83 b8 00 00 00 00 	movl   $0x0,0xb8(%ebx)
8010432a:	00 00 00 
		add_proc_to_q(p, p->queue);
8010432d:	ff b3 b4 00 00 00    	push   0xb4(%ebx)
80104333:	53                   	push   %ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104334:	81 c3 cc 00 00 00    	add    $0xcc,%ebx
8010433a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		add_proc_to_q(p, p->queue);
8010433d:	e8 9e f6 ff ff       	call   801039e0 <add_proc_to_q>
80104342:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104345:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104348:	81 fb 74 65 11 80    	cmp    $0x80116574,%ebx
8010434e:	75 be                	jne    8010430e <exit+0x9e>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104350:	be 74 32 11 80       	mov    $0x80113274,%esi
80104355:	eb 17                	jmp    8010436e <exit+0xfe>
80104357:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010435e:	66 90                	xchg   %ax,%ax
80104360:	81 c6 cc 00 00 00    	add    $0xcc,%esi
80104366:	81 fe 74 65 11 80    	cmp    $0x80116574,%esi
8010436c:	74 66                	je     801043d4 <exit+0x164>
    if(p->parent == curproc){
8010436e:	39 56 1c             	cmp    %edx,0x1c(%esi)
80104371:	75 ed                	jne    80104360 <exit+0xf0>
      p->parent = initproc;
80104373:	8b 3d 74 65 11 80    	mov    0x80116574,%edi
      if(p->state == ZOMBIE)
80104379:	83 7e 10 05          	cmpl   $0x5,0x10(%esi)
      p->parent = initproc;
8010437d:	89 7e 1c             	mov    %edi,0x1c(%esi)
      if(p->state == ZOMBIE)
80104380:	75 de                	jne    80104360 <exit+0xf0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104382:	bb 74 32 11 80       	mov    $0x80113274,%ebx
80104387:	eb 15                	jmp    8010439e <exit+0x12e>
80104389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104390:	81 c3 cc 00 00 00    	add    $0xcc,%ebx
80104396:	81 fb 74 65 11 80    	cmp    $0x80116574,%ebx
8010439c:	74 c2                	je     80104360 <exit+0xf0>
    if(p->state == SLEEPING && p->chan == chan){
8010439e:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
801043a2:	75 ec                	jne    80104390 <exit+0x120>
801043a4:	3b 7b 28             	cmp    0x28(%ebx),%edi
801043a7:	75 e7                	jne    80104390 <exit+0x120>
		add_proc_to_q(p, p->queue);
801043a9:	83 ec 08             	sub    $0x8,%esp
      p->state = RUNNABLE;
801043ac:	c7 43 10 03 00 00 00 	movl   $0x3,0x10(%ebx)
		p->curr_ticks = 0;
801043b3:	c7 83 b8 00 00 00 00 	movl   $0x0,0xb8(%ebx)
801043ba:	00 00 00 
		add_proc_to_q(p, p->queue);
801043bd:	ff b3 b4 00 00 00    	push   0xb4(%ebx)
801043c3:	53                   	push   %ebx
801043c4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801043c7:	e8 14 f6 ff ff       	call   801039e0 <add_proc_to_q>
801043cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801043cf:	83 c4 10             	add    $0x10,%esp
801043d2:	eb bc                	jmp    80104390 <exit+0x120>
  curproc->etime = ticks;
801043d4:	a1 84 65 11 80       	mov    0x80116584,%eax
	cprintf("[Terminate] --> Total Time for pid [%d] is [%d]\n",curproc->pid, curproc->etime - curproc->ctime);
801043d9:	83 ec 04             	sub    $0x4,%esp
  curproc->state = ZOMBIE;
801043dc:	c7 42 10 05 00 00 00 	movl   $0x5,0x10(%edx)
  curproc->etime = ticks;
801043e3:	89 82 90 00 00 00    	mov    %eax,0x90(%edx)
  curproc->waitshh=curproc->etime - curproc->ctime;
801043e9:	2b 82 8c 00 00 00    	sub    0x8c(%edx),%eax
801043ef:	89 82 94 00 00 00    	mov    %eax,0x94(%edx)
	cprintf("[Terminate] --> Total Time for pid [%d] is [%d]\n",curproc->pid, curproc->etime - curproc->ctime);
801043f5:	50                   	push   %eax
801043f6:	ff 72 14             	push   0x14(%edx)
801043f9:	68 74 87 10 80       	push   $0x80108774
801043fe:	e8 9d c2 ff ff       	call   801006a0 <cprintf>
  sched();
80104403:	e8 a8 fd ff ff       	call   801041b0 <sched>
  panic("zombie exit");
80104408:	c7 04 24 08 86 10 80 	movl   $0x80108608,(%esp)
8010440f:	e8 6c bf ff ff       	call   80100380 <panic>
    panic("init exiting");
80104414:	83 ec 0c             	sub    $0xc,%esp
80104417:	68 fb 85 10 80       	push   $0x801085fb
8010441c:	e8 5f bf ff ff       	call   80100380 <panic>
80104421:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104428:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010442f:	90                   	nop

80104430 <waitx>:
{
80104430:	55                   	push   %ebp
80104431:	89 e5                	mov    %esp,%ebp
80104433:	56                   	push   %esi
80104434:	53                   	push   %ebx
  pushcli();
80104435:	e8 46 0d 00 00       	call   80105180 <pushcli>
  c = mycpu();
8010443a:	e8 61 f7 ff ff       	call   80103ba0 <mycpu>
  p = c->proc;
8010443f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104445:	e8 86 0d 00 00       	call   801051d0 <popcli>
  acquire(&ptable.lock);
8010444a:	83 ec 0c             	sub    $0xc,%esp
8010444d:	68 40 32 11 80       	push   $0x80113240
80104452:	e8 79 0e 00 00       	call   801052d0 <acquire>
80104457:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010445a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010445c:	bb 74 32 11 80       	mov    $0x80113274,%ebx
80104461:	eb 13                	jmp    80104476 <waitx+0x46>
80104463:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104467:	90                   	nop
80104468:	81 c3 cc 00 00 00    	add    $0xcc,%ebx
8010446e:	81 fb 74 65 11 80    	cmp    $0x80116574,%ebx
80104474:	74 1e                	je     80104494 <waitx+0x64>
      if(p->parent != curproc)
80104476:	39 73 1c             	cmp    %esi,0x1c(%ebx)
80104479:	75 ed                	jne    80104468 <waitx+0x38>
      if(p->state == ZOMBIE){
8010447b:	83 7b 10 05          	cmpl   $0x5,0x10(%ebx)
8010447f:	74 5f                	je     801044e0 <waitx+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104481:	81 c3 cc 00 00 00    	add    $0xcc,%ebx
      havekids = 1;
80104487:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010448c:	81 fb 74 65 11 80    	cmp    $0x80116574,%ebx
80104492:	75 e2                	jne    80104476 <waitx+0x46>
    if(!havekids || curproc->killed){
80104494:	85 c0                	test   %eax,%eax
80104496:	0f 84 d6 00 00 00    	je     80104572 <waitx+0x142>
8010449c:	8b 46 2c             	mov    0x2c(%esi),%eax
8010449f:	85 c0                	test   %eax,%eax
801044a1:	0f 85 cb 00 00 00    	jne    80104572 <waitx+0x142>
  pushcli();
801044a7:	e8 d4 0c 00 00       	call   80105180 <pushcli>
  c = mycpu();
801044ac:	e8 ef f6 ff ff       	call   80103ba0 <mycpu>
  p = c->proc;
801044b1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801044b7:	e8 14 0d 00 00       	call   801051d0 <popcli>
  if(p == 0)
801044bc:	85 db                	test   %ebx,%ebx
801044be:	0f 84 c5 00 00 00    	je     80104589 <waitx+0x159>
  p->chan = chan;
801044c4:	89 73 28             	mov    %esi,0x28(%ebx)
  p->state = SLEEPING;
801044c7:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
  sched();
801044ce:	e8 dd fc ff ff       	call   801041b0 <sched>
  p->chan = 0;
801044d3:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)
}
801044da:	e9 7b ff ff ff       	jmp    8010445a <waitx+0x2a>
801044df:	90                   	nop
        *rtime = p->rtime ;
801044e0:	8b 93 88 00 00 00    	mov    0x88(%ebx),%edx
801044e6:	8b 45 0c             	mov    0xc(%ebp),%eax
        kfree(p->kstack);
801044e9:	83 ec 0c             	sub    $0xc,%esp
        *rtime = p->rtime ;
801044ec:	89 10                	mov    %edx,(%eax)
				*wtime = p->etime - p->ctime - p->rtime - p->iotime;
801044ee:	8b 83 90 00 00 00    	mov    0x90(%ebx),%eax
801044f4:	2b 83 8c 00 00 00    	sub    0x8c(%ebx),%eax
801044fa:	29 d0                	sub    %edx,%eax
801044fc:	8b 55 08             	mov    0x8(%ebp),%edx
801044ff:	2b 83 84 00 00 00    	sub    0x84(%ebx),%eax
80104505:	89 02                	mov    %eax,(%edx)
        pid = p->pid;
80104507:	8b 73 14             	mov    0x14(%ebx),%esi
        kfree(p->kstack);
8010450a:	ff 73 08             	push   0x8(%ebx)
8010450d:	e8 ae df ff ff       	call   801024c0 <kfree>
        p->kstack = 0;
80104512:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104519:	5a                   	pop    %edx
8010451a:	ff 73 04             	push   0x4(%ebx)
8010451d:	e8 4e 37 00 00       	call   80107c70 <freevm>
					remove_proc_from_q(p, p->queue);
80104522:	59                   	pop    %ecx
80104523:	58                   	pop    %eax
80104524:	ff b3 b4 00 00 00    	push   0xb4(%ebx)
8010452a:	53                   	push   %ebx
8010452b:	e8 30 f5 ff ff       	call   80103a60 <remove_proc_from_q>
        p->pid = 0;
80104530:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
          p->queue=-1;
80104537:	c7 83 b4 00 00 00 ff 	movl   $0xffffffff,0xb4(%ebx)
8010453e:	ff ff ff 
        p->parent = 0;
80104541:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
        p->name[0] = 0;
80104548:	c6 43 74 00          	movb   $0x0,0x74(%ebx)
        p->killed = 0;
8010454c:	c7 43 2c 00 00 00 00 	movl   $0x0,0x2c(%ebx)
        p->state = UNUSED;
80104553:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        release(&ptable.lock);
8010455a:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
80104561:	e8 0a 0d 00 00       	call   80105270 <release>
        return pid;
80104566:	83 c4 10             	add    $0x10,%esp
}
80104569:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010456c:	89 f0                	mov    %esi,%eax
8010456e:	5b                   	pop    %ebx
8010456f:	5e                   	pop    %esi
80104570:	5d                   	pop    %ebp
80104571:	c3                   	ret    
      release(&ptable.lock);
80104572:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104575:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010457a:	68 40 32 11 80       	push   $0x80113240
8010457f:	e8 ec 0c 00 00       	call   80105270 <release>
      return -1;
80104584:	83 c4 10             	add    $0x10,%esp
80104587:	eb e0                	jmp    80104569 <waitx+0x139>
    panic("sleep");
80104589:	83 ec 0c             	sub    $0xc,%esp
8010458c:	68 14 86 10 80       	push   $0x80108614
80104591:	e8 ea bd ff ff       	call   80100380 <panic>
80104596:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010459d:	8d 76 00             	lea    0x0(%esi),%esi

801045a0 <wait>:
{
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
801045a3:	56                   	push   %esi
801045a4:	53                   	push   %ebx
  pushcli();
801045a5:	e8 d6 0b 00 00       	call   80105180 <pushcli>
  c = mycpu();
801045aa:	e8 f1 f5 ff ff       	call   80103ba0 <mycpu>
  p = c->proc;
801045af:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801045b5:	e8 16 0c 00 00       	call   801051d0 <popcli>
  acquire(&ptable.lock);
801045ba:	83 ec 0c             	sub    $0xc,%esp
801045bd:	68 40 32 11 80       	push   $0x80113240
801045c2:	e8 09 0d 00 00       	call   801052d0 <acquire>
801045c7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801045ca:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045cc:	bb 74 32 11 80       	mov    $0x80113274,%ebx
801045d1:	eb 13                	jmp    801045e6 <wait+0x46>
801045d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045d7:	90                   	nop
801045d8:	81 c3 cc 00 00 00    	add    $0xcc,%ebx
801045de:	81 fb 74 65 11 80    	cmp    $0x80116574,%ebx
801045e4:	74 26                	je     8010460c <wait+0x6c>
      if(p->parent != curproc && p->pgdir != curproc->pgdir)
801045e6:	39 73 1c             	cmp    %esi,0x1c(%ebx)
801045e9:	74 08                	je     801045f3 <wait+0x53>
801045eb:	8b 56 04             	mov    0x4(%esi),%edx
801045ee:	39 53 04             	cmp    %edx,0x4(%ebx)
801045f1:	75 e5                	jne    801045d8 <wait+0x38>
      if(p->state == ZOMBIE){
801045f3:	83 7b 10 05          	cmpl   $0x5,0x10(%ebx)
801045f7:	74 67                	je     80104660 <wait+0xc0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045f9:	81 c3 cc 00 00 00    	add    $0xcc,%ebx
      havekids = 1;
801045ff:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104604:	81 fb 74 65 11 80    	cmp    $0x80116574,%ebx
8010460a:	75 da                	jne    801045e6 <wait+0x46>
    if(!havekids || curproc->killed){
8010460c:	85 c0                	test   %eax,%eax
8010460e:	0f 84 c1 00 00 00    	je     801046d5 <wait+0x135>
80104614:	8b 46 2c             	mov    0x2c(%esi),%eax
80104617:	85 c0                	test   %eax,%eax
80104619:	0f 85 b6 00 00 00    	jne    801046d5 <wait+0x135>
  pushcli();
8010461f:	e8 5c 0b 00 00       	call   80105180 <pushcli>
  c = mycpu();
80104624:	e8 77 f5 ff ff       	call   80103ba0 <mycpu>
  p = c->proc;
80104629:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010462f:	e8 9c 0b 00 00       	call   801051d0 <popcli>
  if(p == 0)
80104634:	85 db                	test   %ebx,%ebx
80104636:	0f 84 b0 00 00 00    	je     801046ec <wait+0x14c>
  p->chan = chan;
8010463c:	89 73 28             	mov    %esi,0x28(%ebx)
  p->state = SLEEPING;
8010463f:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
  sched();
80104646:	e8 65 fb ff ff       	call   801041b0 <sched>
  p->chan = 0;
8010464b:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)
}
80104652:	e9 73 ff ff ff       	jmp    801045ca <wait+0x2a>
80104657:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010465e:	66 90                	xchg   %ax,%ax
        kfree(p->kstack);
80104660:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104663:	8b 73 14             	mov    0x14(%ebx),%esi
        kfree(p->kstack);
80104666:	ff 73 08             	push   0x8(%ebx)
80104669:	e8 52 de ff ff       	call   801024c0 <kfree>
        p->kstack = 0;
8010466e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104675:	5a                   	pop    %edx
80104676:	ff 73 04             	push   0x4(%ebx)
80104679:	e8 f2 35 00 00       	call   80107c70 <freevm>
					remove_proc_from_q(p, p->queue);
8010467e:	59                   	pop    %ecx
8010467f:	58                   	pop    %eax
80104680:	ff b3 b4 00 00 00    	push   0xb4(%ebx)
80104686:	53                   	push   %ebx
80104687:	e8 d4 f3 ff ff       	call   80103a60 <remove_proc_from_q>
        p->pid = 0;
8010468c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
          p->queue=-1;
80104693:	c7 83 b4 00 00 00 ff 	movl   $0xffffffff,0xb4(%ebx)
8010469a:	ff ff ff 
	p->tgid = 0;
8010469d:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
        p->parent = 0;
801046a4:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
        p->name[0] = 0;
801046ab:	c6 43 74 00          	movb   $0x0,0x74(%ebx)
        p->killed = 0;
801046af:	c7 43 2c 00 00 00 00 	movl   $0x0,0x2c(%ebx)
        p->state = UNUSED;
801046b6:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        release(&ptable.lock);
801046bd:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
801046c4:	e8 a7 0b 00 00       	call   80105270 <release>
        return pid;
801046c9:	83 c4 10             	add    $0x10,%esp
}
801046cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046cf:	89 f0                	mov    %esi,%eax
801046d1:	5b                   	pop    %ebx
801046d2:	5e                   	pop    %esi
801046d3:	5d                   	pop    %ebp
801046d4:	c3                   	ret    
      release(&ptable.lock);
801046d5:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801046d8:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801046dd:	68 40 32 11 80       	push   $0x80113240
801046e2:	e8 89 0b 00 00       	call   80105270 <release>
      return -1;
801046e7:	83 c4 10             	add    $0x10,%esp
801046ea:	eb e0                	jmp    801046cc <wait+0x12c>
    panic("sleep");
801046ec:	83 ec 0c             	sub    $0xc,%esp
801046ef:	68 14 86 10 80       	push   $0x80108614
801046f4:	e8 87 bc ff ff       	call   80100380 <panic>
801046f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104700 <yield>:
{
80104700:	55                   	push   %ebp
80104701:	89 e5                	mov    %esp,%ebp
80104703:	53                   	push   %ebx
80104704:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock); 
80104707:	68 40 32 11 80       	push   $0x80113240
8010470c:	e8 bf 0b 00 00       	call   801052d0 <acquire>
  pushcli();
80104711:	e8 6a 0a 00 00       	call   80105180 <pushcli>
  c = mycpu();
80104716:	e8 85 f4 ff ff       	call   80103ba0 <mycpu>
  p = c->proc;
8010471b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104721:	e8 aa 0a 00 00       	call   801051d0 <popcli>
  myproc()->state = RUNNABLE;
80104726:	c7 43 10 03 00 00 00 	movl   $0x3,0x10(%ebx)
  sched();
8010472d:	e8 7e fa ff ff       	call   801041b0 <sched>
  release(&ptable.lock);
80104732:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
80104739:	e8 32 0b 00 00       	call   80105270 <release>
}
8010473e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104741:	83 c4 10             	add    $0x10,%esp
80104744:	c9                   	leave  
80104745:	c3                   	ret    
80104746:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010474d:	8d 76 00             	lea    0x0(%esi),%esi

80104750 <sleep>:
{
80104750:	55                   	push   %ebp
80104751:	89 e5                	mov    %esp,%ebp
80104753:	57                   	push   %edi
80104754:	56                   	push   %esi
80104755:	53                   	push   %ebx
80104756:	83 ec 0c             	sub    $0xc,%esp
80104759:	8b 7d 08             	mov    0x8(%ebp),%edi
8010475c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010475f:	e8 1c 0a 00 00       	call   80105180 <pushcli>
  c = mycpu();
80104764:	e8 37 f4 ff ff       	call   80103ba0 <mycpu>
  p = c->proc;
80104769:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010476f:	e8 5c 0a 00 00       	call   801051d0 <popcli>
  if(p == 0)
80104774:	85 db                	test   %ebx,%ebx
80104776:	0f 84 87 00 00 00    	je     80104803 <sleep+0xb3>
  if(lk == 0)
8010477c:	85 f6                	test   %esi,%esi
8010477e:	74 76                	je     801047f6 <sleep+0xa6>
  if(lk != &ptable.lock){  
80104780:	81 fe 40 32 11 80    	cmp    $0x80113240,%esi
80104786:	74 50                	je     801047d8 <sleep+0x88>
    acquire(&ptable.lock); 
80104788:	83 ec 0c             	sub    $0xc,%esp
8010478b:	68 40 32 11 80       	push   $0x80113240
80104790:	e8 3b 0b 00 00       	call   801052d0 <acquire>
    release(lk);
80104795:	89 34 24             	mov    %esi,(%esp)
80104798:	e8 d3 0a 00 00       	call   80105270 <release>
  p->chan = chan;
8010479d:	89 7b 28             	mov    %edi,0x28(%ebx)
  p->state = SLEEPING;
801047a0:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
  sched();
801047a7:	e8 04 fa ff ff       	call   801041b0 <sched>
  p->chan = 0;
801047ac:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)
    release(&ptable.lock);
801047b3:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
801047ba:	e8 b1 0a 00 00       	call   80105270 <release>
    acquire(lk);
801047bf:	89 75 08             	mov    %esi,0x8(%ebp)
801047c2:	83 c4 10             	add    $0x10,%esp
}
801047c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801047c8:	5b                   	pop    %ebx
801047c9:	5e                   	pop    %esi
801047ca:	5f                   	pop    %edi
801047cb:	5d                   	pop    %ebp
    acquire(lk);
801047cc:	e9 ff 0a 00 00       	jmp    801052d0 <acquire>
801047d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801047d8:	89 7b 28             	mov    %edi,0x28(%ebx)
  p->state = SLEEPING;
801047db:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
  sched();
801047e2:	e8 c9 f9 ff ff       	call   801041b0 <sched>
  p->chan = 0;
801047e7:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)
}
801047ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801047f1:	5b                   	pop    %ebx
801047f2:	5e                   	pop    %esi
801047f3:	5f                   	pop    %edi
801047f4:	5d                   	pop    %ebp
801047f5:	c3                   	ret    
    panic("sleep without lk");
801047f6:	83 ec 0c             	sub    $0xc,%esp
801047f9:	68 1a 86 10 80       	push   $0x8010861a
801047fe:	e8 7d bb ff ff       	call   80100380 <panic>
    panic("sleep");
80104803:	83 ec 0c             	sub    $0xc,%esp
80104806:	68 14 86 10 80       	push   $0x80108614
8010480b:	e8 70 bb ff ff       	call   80100380 <panic>

80104810 <wakeup>:
}


void
wakeup(void *chan)
{
80104810:	55                   	push   %ebp
80104811:	89 e5                	mov    %esp,%ebp
80104813:	56                   	push   %esi
80104814:	53                   	push   %ebx
80104815:	8b 75 08             	mov    0x8(%ebp),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104818:	bb 74 32 11 80       	mov    $0x80113274,%ebx
  acquire(&ptable.lock);
8010481d:	83 ec 0c             	sub    $0xc,%esp
80104820:	68 40 32 11 80       	push   $0x80113240
80104825:	e8 a6 0a 00 00       	call   801052d0 <acquire>
8010482a:	83 c4 10             	add    $0x10,%esp
8010482d:	eb 0f                	jmp    8010483e <wakeup+0x2e>
8010482f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104830:	81 c3 cc 00 00 00    	add    $0xcc,%ebx
80104836:	81 fb 74 65 11 80    	cmp    $0x80116574,%ebx
8010483c:	74 3c                	je     8010487a <wakeup+0x6a>
    if(p->state == SLEEPING && p->chan == chan){
8010483e:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
80104842:	75 ec                	jne    80104830 <wakeup+0x20>
80104844:	3b 73 28             	cmp    0x28(%ebx),%esi
80104847:	75 e7                	jne    80104830 <wakeup+0x20>
		add_proc_to_q(p, p->queue);
80104849:	83 ec 08             	sub    $0x8,%esp
8010484c:	ff b3 b4 00 00 00    	push   0xb4(%ebx)
80104852:	53                   	push   %ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104853:	81 c3 cc 00 00 00    	add    $0xcc,%ebx
      p->state = RUNNABLE;
80104859:	c7 83 44 ff ff ff 03 	movl   $0x3,-0xbc(%ebx)
80104860:	00 00 00 
		p->curr_ticks = 0;
80104863:	c7 43 ec 00 00 00 00 	movl   $0x0,-0x14(%ebx)
		add_proc_to_q(p, p->queue);
8010486a:	e8 71 f1 ff ff       	call   801039e0 <add_proc_to_q>
8010486f:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104872:	81 fb 74 65 11 80    	cmp    $0x80116574,%ebx
80104878:	75 c4                	jne    8010483e <wakeup+0x2e>
  wakeup1(chan);
  release(&ptable.lock);
8010487a:	c7 45 08 40 32 11 80 	movl   $0x80113240,0x8(%ebp)
}
80104881:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104884:	5b                   	pop    %ebx
80104885:	5e                   	pop    %esi
80104886:	5d                   	pop    %ebp
  release(&ptable.lock);
80104887:	e9 e4 09 00 00       	jmp    80105270 <release>
8010488c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104890 <kill>:

int
kill(int pid)
{
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
80104893:	53                   	push   %ebx
80104894:	83 ec 10             	sub    $0x10,%esp
80104897:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010489a:	68 40 32 11 80       	push   $0x80113240
8010489f:	e8 2c 0a 00 00       	call   801052d0 <acquire>
801048a4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801048a7:	b8 74 32 11 80       	mov    $0x80113274,%eax
801048ac:	eb 0e                	jmp    801048bc <kill+0x2c>
801048ae:	66 90                	xchg   %ax,%ax
801048b0:	05 cc 00 00 00       	add    $0xcc,%eax
801048b5:	3d 74 65 11 80       	cmp    $0x80116574,%eax
801048ba:	74 2c                	je     801048e8 <kill+0x58>
    if(p->pid == pid){
801048bc:	39 58 14             	cmp    %ebx,0x14(%eax)
801048bf:	75 ef                	jne    801048b0 <kill+0x20>
      p->killed = 1;
      if(p->state == SLEEPING){
801048c1:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
      p->killed = 1;
801048c5:	c7 40 2c 01 00 00 00 	movl   $0x1,0x2c(%eax)
      if(p->state == SLEEPING){
801048cc:	74 3a                	je     80104908 <kill+0x78>
        #ifdef MLFQ
          p->curr_ticks = 0;
          add_proc_to_q(p, p->queue);
        #endif
      }
      release(&ptable.lock);
801048ce:	83 ec 0c             	sub    $0xc,%esp
801048d1:	68 40 32 11 80       	push   $0x80113240
801048d6:	e8 95 09 00 00       	call   80105270 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801048db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801048de:	83 c4 10             	add    $0x10,%esp
801048e1:	31 c0                	xor    %eax,%eax
}
801048e3:	c9                   	leave  
801048e4:	c3                   	ret    
801048e5:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ptable.lock);
801048e8:	83 ec 0c             	sub    $0xc,%esp
801048eb:	68 40 32 11 80       	push   $0x80113240
801048f0:	e8 7b 09 00 00       	call   80105270 <release>
}
801048f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801048f8:	83 c4 10             	add    $0x10,%esp
801048fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104900:	c9                   	leave  
80104901:	c3                   	ret    
80104902:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
          add_proc_to_q(p, p->queue);
80104908:	83 ec 08             	sub    $0x8,%esp
        p->state = RUNNABLE;
8010490b:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
          p->curr_ticks = 0;
80104912:	c7 80 b8 00 00 00 00 	movl   $0x0,0xb8(%eax)
80104919:	00 00 00 
          add_proc_to_q(p, p->queue);
8010491c:	ff b0 b4 00 00 00    	push   0xb4(%eax)
80104922:	50                   	push   %eax
80104923:	e8 b8 f0 ff ff       	call   801039e0 <add_proc_to_q>
80104928:	83 c4 10             	add    $0x10,%esp
8010492b:	eb a1                	jmp    801048ce <kill+0x3e>
8010492d:	8d 76 00             	lea    0x0(%esi),%esi

80104930 <procdump>:

void
procdump(void)
{
80104930:	55                   	push   %ebp
80104931:	89 e5                	mov    %esp,%ebp
80104933:	57                   	push   %edi
80104934:	56                   	push   %esi
80104935:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104938:	53                   	push   %ebx
80104939:	bb e8 32 11 80       	mov    $0x801132e8,%ebx
8010493e:	83 ec 3c             	sub    $0x3c,%esp
80104941:	eb 27                	jmp    8010496a <procdump+0x3a>
80104943:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104947:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104948:	83 ec 0c             	sub    $0xc,%esp
8010494b:	68 20 87 10 80       	push   $0x80108720
80104950:	e8 4b bd ff ff       	call   801006a0 <cprintf>
80104955:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104958:	81 c3 cc 00 00 00    	add    $0xcc,%ebx
8010495e:	81 fb e8 65 11 80    	cmp    $0x801165e8,%ebx
80104964:	0f 84 7e 00 00 00    	je     801049e8 <procdump+0xb8>
    if(p->state == UNUSED)
8010496a:	8b 43 9c             	mov    -0x64(%ebx),%eax
8010496d:	85 c0                	test   %eax,%eax
8010496f:	74 e7                	je     80104958 <procdump+0x28>
      state = "???";
80104971:	ba 2b 86 10 80       	mov    $0x8010862b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104976:	83 f8 05             	cmp    $0x5,%eax
80104979:	77 11                	ja     8010498c <procdump+0x5c>
8010497b:	8b 14 85 d4 88 10 80 	mov    -0x7fef772c(,%eax,4),%edx
      state = "???";
80104982:	b8 2b 86 10 80       	mov    $0x8010862b,%eax
80104987:	85 d2                	test   %edx,%edx
80104989:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010498c:	53                   	push   %ebx
8010498d:	52                   	push   %edx
8010498e:	ff 73 a0             	push   -0x60(%ebx)
80104991:	68 2f 86 10 80       	push   $0x8010862f
80104996:	e8 05 bd ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
8010499b:	83 c4 10             	add    $0x10,%esp
8010499e:	83 7b 9c 02          	cmpl   $0x2,-0x64(%ebx)
801049a2:	75 a4                	jne    80104948 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801049a4:	83 ec 08             	sub    $0x8,%esp
801049a7:	8d 45 c0             	lea    -0x40(%ebp),%eax
801049aa:	8d 7d c0             	lea    -0x40(%ebp),%edi
801049ad:	50                   	push   %eax
801049ae:	8b 43 b0             	mov    -0x50(%ebx),%eax
801049b1:	8b 40 0c             	mov    0xc(%eax),%eax
801049b4:	83 c0 08             	add    $0x8,%eax
801049b7:	50                   	push   %eax
801049b8:	e8 63 07 00 00       	call   80105120 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801049bd:	83 c4 10             	add    $0x10,%esp
801049c0:	8b 17                	mov    (%edi),%edx
801049c2:	85 d2                	test   %edx,%edx
801049c4:	74 82                	je     80104948 <procdump+0x18>
        cprintf(" %p", pc[i]);
801049c6:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801049c9:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
801049cc:	52                   	push   %edx
801049cd:	68 81 80 10 80       	push   $0x80108081
801049d2:	e8 c9 bc ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801049d7:	83 c4 10             	add    $0x10,%esp
801049da:	39 fe                	cmp    %edi,%esi
801049dc:	75 e2                	jne    801049c0 <procdump+0x90>
801049de:	e9 65 ff ff ff       	jmp    80104948 <procdump+0x18>
801049e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049e7:	90                   	nop
  }
}
801049e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801049eb:	5b                   	pop    %ebx
801049ec:	5e                   	pop    %esi
801049ed:	5f                   	pop    %edi
801049ee:	5d                   	pop    %ebp
801049ef:	c3                   	ret    

801049f0 <getps>:


int
getps(void) 
{
801049f0:	55                   	push   %ebp
801049f1:	89 e5                	mov    %esp,%ebp
801049f3:	57                   	push   %edi
801049f4:	56                   	push   %esi
801049f5:	53                   	push   %ebx
  cprintf("PID   State \tr_time\tw_time\ts_time\n");
  #endif
  #ifdef MLFQ
  cprintf("PID   State \tr_time\tw_time\ts_time\tcur_q\t q0\tq1\tq2\tq3\tq4\n");
  #endif
  for (p = ptable.proc; p < &ptable.proc[NPROC]; ++p)
801049f6:	bb 74 32 11 80       	mov    $0x80113274,%ebx
{
801049fb:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
801049fe:	68 40 32 11 80       	push   $0x80113240
80104a03:	e8 c8 08 00 00       	call   801052d0 <acquire>
  cprintf("PID   State \tr_time\tw_time\ts_time\tcur_q\t q0\tq1\tq2\tq3\tq4\n");
80104a08:	c7 04 24 a8 87 10 80 	movl   $0x801087a8,(%esp)
80104a0f:	e8 8c bc ff ff       	call   801006a0 <cprintf>
80104a14:	83 c4 10             	add    $0x10,%esp
80104a17:	eb 30                	jmp    80104a49 <getps+0x59>
80104a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    #ifdef MLFQ
   if (p->state == SLEEPING)
    {
      cprintf("%d   SLEEPING \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d\n",  p->pid,  p->rtime, ticks - p->ctime - p->rtime -p->iotime,p->iotime,p->queue,p->qticks[0],p->qticks[1],p->qticks[2],p->qticks[3],p->qticks[4]);
    }
    else if (p->state == RUNNING)
80104a20:	83 fa 04             	cmp    $0x4,%edx
80104a23:	0f 84 a7 00 00 00    	je     80104ad0 <getps+0xe0>
    {
      cprintf("%d   RUNNING  \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d\n",  p->pid,  p->rtime, ticks - p->ctime - p->rtime -p->iotime,p->iotime,p->queue,p->qticks[0],p->qticks[1],p->qticks[2],p->qticks[3],p->qticks[4]);
    }
    else if (p->state == RUNNABLE)
80104a29:	83 fa 03             	cmp    $0x3,%edx
80104a2c:	0f 84 fe 00 00 00    	je     80104b30 <getps+0x140>
    {
      cprintf("%d   RUNNABLE \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d\n",  p->pid,  p->rtime, ticks - p->ctime - p->rtime -p->iotime,p->iotime,p->queue,p->qticks[0],p->qticks[1],p->qticks[2],p->qticks[3],p->qticks[4]);
    }
    else if (p->state == ZOMBIE)
80104a32:	83 fa 05             	cmp    $0x5,%edx
80104a35:	0f 84 55 01 00 00    	je     80104b90 <getps+0x1a0>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; ++p)
80104a3b:	81 c3 cc 00 00 00    	add    $0xcc,%ebx
80104a41:	81 fb 74 65 11 80    	cmp    $0x80116574,%ebx
80104a47:	74 65                	je     80104aae <getps+0xbe>
    if(p->pid >= 3) {
80104a49:	8b 43 14             	mov    0x14(%ebx),%eax
80104a4c:	83 f8 02             	cmp    $0x2,%eax
80104a4f:	7e ea                	jle    80104a3b <getps+0x4b>
   if (p->state == SLEEPING)
80104a51:	8b 53 10             	mov    0x10(%ebx),%edx
80104a54:	83 fa 02             	cmp    $0x2,%edx
80104a57:	75 c7                	jne    80104a20 <getps+0x30>
      cprintf("%d   SLEEPING \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d\n",  p->pid,  p->rtime, ticks - p->ctime - p->rtime -p->iotime,p->iotime,p->queue,p->qticks[0],p->qticks[1],p->qticks[2],p->qticks[3],p->qticks[4]);
80104a59:	8b 8b 88 00 00 00    	mov    0x88(%ebx),%ecx
80104a5f:	8b bb 8c 00 00 00    	mov    0x8c(%ebx),%edi
80104a65:	83 ec 04             	sub    $0x4,%esp
80104a68:	ff b3 b0 00 00 00    	push   0xb0(%ebx)
80104a6e:	8b 15 84 65 11 80    	mov    0x80116584,%edx
80104a74:	ff b3 ac 00 00 00    	push   0xac(%ebx)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; ++p)
80104a7a:	81 c3 cc 00 00 00    	add    $0xcc,%ebx
      cprintf("%d   SLEEPING \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d\n",  p->pid,  p->rtime, ticks - p->ctime - p->rtime -p->iotime,p->iotime,p->queue,p->qticks[0],p->qticks[1],p->qticks[2],p->qticks[3],p->qticks[4]);
80104a80:	8b 73 b8             	mov    -0x48(%ebx),%esi
80104a83:	01 cf                	add    %ecx,%edi
80104a85:	ff 73 dc             	push   -0x24(%ebx)
80104a88:	29 fa                	sub    %edi,%edx
80104a8a:	ff 73 d8             	push   -0x28(%ebx)
80104a8d:	29 f2                	sub    %esi,%edx
80104a8f:	ff 73 d4             	push   -0x2c(%ebx)
80104a92:	ff 73 e8             	push   -0x18(%ebx)
80104a95:	56                   	push   %esi
80104a96:	52                   	push   %edx
80104a97:	51                   	push   %ecx
80104a98:	50                   	push   %eax
80104a99:	68 e4 87 10 80       	push   $0x801087e4
80104a9e:	e8 fd bb ff ff       	call   801006a0 <cprintf>
80104aa3:	83 c4 30             	add    $0x30,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; ++p)
80104aa6:	81 fb 74 65 11 80    	cmp    $0x80116574,%ebx
80104aac:	75 9b                	jne    80104a49 <getps+0x59>
    }
    #endif

  }
  }
  release(&ptable.lock);
80104aae:	83 ec 0c             	sub    $0xc,%esp
80104ab1:	68 40 32 11 80       	push   $0x80113240
80104ab6:	e8 b5 07 00 00       	call   80105270 <release>
	return ret;
}
80104abb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104abe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ac3:	5b                   	pop    %ebx
80104ac4:	5e                   	pop    %esi
80104ac5:	5f                   	pop    %edi
80104ac6:	5d                   	pop    %ebp
80104ac7:	c3                   	ret    
80104ac8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104acf:	90                   	nop
      cprintf("%d   RUNNING  \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d\n",  p->pid,  p->rtime, ticks - p->ctime - p->rtime -p->iotime,p->iotime,p->queue,p->qticks[0],p->qticks[1],p->qticks[2],p->qticks[3],p->qticks[4]);
80104ad0:	8b 8b 88 00 00 00    	mov    0x88(%ebx),%ecx
80104ad6:	8b bb 8c 00 00 00    	mov    0x8c(%ebx),%edi
80104adc:	83 ec 04             	sub    $0x4,%esp
80104adf:	ff b3 b0 00 00 00    	push   0xb0(%ebx)
80104ae5:	8b 15 84 65 11 80    	mov    0x80116584,%edx
80104aeb:	ff b3 ac 00 00 00    	push   0xac(%ebx)
80104af1:	8b b3 84 00 00 00    	mov    0x84(%ebx),%esi
80104af7:	01 cf                	add    %ecx,%edi
80104af9:	ff b3 a8 00 00 00    	push   0xa8(%ebx)
80104aff:	29 fa                	sub    %edi,%edx
80104b01:	ff b3 a4 00 00 00    	push   0xa4(%ebx)
80104b07:	29 f2                	sub    %esi,%edx
80104b09:	ff b3 a0 00 00 00    	push   0xa0(%ebx)
80104b0f:	ff b3 b4 00 00 00    	push   0xb4(%ebx)
80104b15:	56                   	push   %esi
80104b16:	52                   	push   %edx
80104b17:	51                   	push   %ecx
80104b18:	50                   	push   %eax
80104b19:	68 20 88 10 80       	push   $0x80108820
80104b1e:	e8 7d bb ff ff       	call   801006a0 <cprintf>
80104b23:	83 c4 30             	add    $0x30,%esp
80104b26:	e9 10 ff ff ff       	jmp    80104a3b <getps+0x4b>
80104b2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b2f:	90                   	nop
      cprintf("%d   RUNNABLE \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d\n",  p->pid,  p->rtime, ticks - p->ctime - p->rtime -p->iotime,p->iotime,p->queue,p->qticks[0],p->qticks[1],p->qticks[2],p->qticks[3],p->qticks[4]);
80104b30:	8b 8b 88 00 00 00    	mov    0x88(%ebx),%ecx
80104b36:	8b bb 8c 00 00 00    	mov    0x8c(%ebx),%edi
80104b3c:	83 ec 04             	sub    $0x4,%esp
80104b3f:	ff b3 b0 00 00 00    	push   0xb0(%ebx)
80104b45:	8b 15 84 65 11 80    	mov    0x80116584,%edx
80104b4b:	ff b3 ac 00 00 00    	push   0xac(%ebx)
80104b51:	8b b3 84 00 00 00    	mov    0x84(%ebx),%esi
80104b57:	01 cf                	add    %ecx,%edi
80104b59:	ff b3 a8 00 00 00    	push   0xa8(%ebx)
80104b5f:	29 fa                	sub    %edi,%edx
80104b61:	ff b3 a4 00 00 00    	push   0xa4(%ebx)
80104b67:	29 f2                	sub    %esi,%edx
80104b69:	ff b3 a0 00 00 00    	push   0xa0(%ebx)
80104b6f:	ff b3 b4 00 00 00    	push   0xb4(%ebx)
80104b75:	56                   	push   %esi
80104b76:	52                   	push   %edx
80104b77:	51                   	push   %ecx
80104b78:	50                   	push   %eax
80104b79:	68 5c 88 10 80       	push   $0x8010885c
80104b7e:	e8 1d bb ff ff       	call   801006a0 <cprintf>
80104b83:	83 c4 30             	add    $0x30,%esp
80104b86:	e9 b0 fe ff ff       	jmp    80104a3b <getps+0x4b>
80104b8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b8f:	90                   	nop
      cprintf("%d    ZOMBIE \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d\n",  p->pid,  p->rtime, p->etime - p->ctime - p->rtime -p->iotime,p->iotime,-1,p->qticks[0],p->qticks[1],p->qticks[2],p->qticks[3],p->qticks[4]);
80104b90:	8b 8b 88 00 00 00    	mov    0x88(%ebx),%ecx
80104b96:	8b b3 84 00 00 00    	mov    0x84(%ebx),%esi
80104b9c:	83 ec 04             	sub    $0x4,%esp
80104b9f:	ff b3 b0 00 00 00    	push   0xb0(%ebx)
80104ba5:	8b 93 90 00 00 00    	mov    0x90(%ebx),%edx
80104bab:	ff b3 ac 00 00 00    	push   0xac(%ebx)
80104bb1:	2b 93 8c 00 00 00    	sub    0x8c(%ebx),%edx
80104bb7:	ff b3 a8 00 00 00    	push   0xa8(%ebx)
80104bbd:	29 ca                	sub    %ecx,%edx
80104bbf:	ff b3 a4 00 00 00    	push   0xa4(%ebx)
80104bc5:	29 f2                	sub    %esi,%edx
80104bc7:	ff b3 a0 00 00 00    	push   0xa0(%ebx)
80104bcd:	6a ff                	push   $0xffffffff
80104bcf:	56                   	push   %esi
80104bd0:	52                   	push   %edx
80104bd1:	51                   	push   %ecx
80104bd2:	50                   	push   %eax
80104bd3:	68 98 88 10 80       	push   $0x80108898
80104bd8:	e8 c3 ba ff ff       	call   801006a0 <cprintf>
80104bdd:	83 c4 30             	add    $0x30,%esp
80104be0:	e9 56 fe ff ff       	jmp    80104a3b <getps+0x4b>
80104be5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104bf0 <printinfo>:

int printinfo(struct proc *np) {
80104bf0:	55                   	push   %ebp
80104bf1:	89 e5                	mov    %esp,%ebp
80104bf3:	53                   	push   %ebx
80104bf4:	83 ec 0c             	sub    $0xc,%esp
80104bf7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p = np;
  cprintf("PID : %d\n", p->tgid);
80104bfa:	ff 73 18             	push   0x18(%ebx)
80104bfd:	68 38 86 10 80       	push   $0x80108638
80104c02:	e8 99 ba ff ff       	call   801006a0 <cprintf>
  cprintf("TID : %d\n",p->pid);
80104c07:	58                   	pop    %eax
80104c08:	5a                   	pop    %edx
80104c09:	ff 73 14             	push   0x14(%ebx)
80104c0c:	68 42 86 10 80       	push   $0x80108642
80104c11:	e8 8a ba ff ff       	call   801006a0 <cprintf>
  cprintf("Page Directory Address: %p\n", p->pgdir);
80104c16:	59                   	pop    %ecx
80104c17:	58                   	pop    %eax
80104c18:	ff 73 04             	push   0x4(%ebx)
80104c1b:	68 4c 86 10 80       	push   $0x8010864c
80104c20:	e8 7b ba ff ff       	call   801006a0 <cprintf>
  cprintf("Stack Pointer Value: %p\n", p->tf->esp);
80104c25:	58                   	pop    %eax
80104c26:	8b 43 20             	mov    0x20(%ebx),%eax
80104c29:	5a                   	pop    %edx
80104c2a:	ff 70 44             	push   0x44(%eax)
80104c2d:	68 68 86 10 80       	push   $0x80108668
80104c32:	e8 69 ba ff ff       	call   801006a0 <cprintf>
  cprintf("Start Function Address: %p\n", p->function);
80104c37:	59                   	pop    %ecx
80104c38:	58                   	pop    %eax
80104c39:	ff b3 c4 00 00 00    	push   0xc4(%ebx)
80104c3f:	68 81 86 10 80       	push   $0x80108681
80104c44:	e8 57 ba ff ff       	call   801006a0 <cprintf>
  cprintf("Memory Size: %d bytes\n\n", p->sz);
80104c49:	58                   	pop    %eax
80104c4a:	5a                   	pop    %edx
80104c4b:	ff 33                	push   (%ebx)
80104c4d:	68 9d 86 10 80       	push   $0x8010869d
80104c52:	e8 49 ba ff ff       	call   801006a0 <cprintf>
  return 0;
}
80104c57:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c5a:	31 c0                	xor    %eax,%eax
80104c5c:	c9                   	leave  
80104c5d:	c3                   	ret    
80104c5e:	66 90                	xchg   %ax,%ax

80104c60 <clone>:

/* Clone, Join system call*/
int
clone(void (*function)(void*), void* arg, void* stack)
{
80104c60:	55                   	push   %ebp
80104c61:	89 e5                	mov    %esp,%ebp
80104c63:	57                   	push   %edi
80104c64:	56                   	push   %esi
80104c65:	53                   	push   %ebx
80104c66:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80104c69:	e8 12 05 00 00       	call   80105180 <pushcli>
  c = mycpu();
80104c6e:	e8 2d ef ff ff       	call   80103ba0 <mycpu>
  p = c->proc;
80104c73:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80104c79:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  popcli();
80104c7c:	e8 4f 05 00 00       	call   801051d0 <popcli>
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
80104c81:	e8 2a eb ff ff       	call   801037b0 <allocproc>
80104c86:	85 c0                	test   %eax,%eax
80104c88:	0f 84 41 01 00 00    	je     80104dcf <clone+0x16f>
  }

  // <Code for new thread>

  // Copy process data to new process with page table address
  np->sz = curproc->sz;
80104c8e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104c91:	89 c3                	mov    %eax,%ebx
  np->pgdir = curproc->pgdir;
  np->parent = curproc;
  *np->tf = *curproc->tf;
80104c93:	b9 13 00 00 00       	mov    $0x13,%ecx
80104c98:	8b 7b 20             	mov    0x20(%ebx),%edi
  np->sz = curproc->sz;
80104c9b:	8b 02                	mov    (%edx),%eax
80104c9d:	89 03                	mov    %eax,(%ebx)
  np->pgdir = curproc->pgdir;
80104c9f:	8b 42 04             	mov    0x4(%edx),%eax
  np->parent = curproc;
80104ca2:	89 53 1c             	mov    %edx,0x1c(%ebx)
  np->pgdir = curproc->pgdir;
80104ca5:	89 43 04             	mov    %eax,0x4(%ebx)
  *np->tf = *curproc->tf;
80104ca8:	8b 72 20             	mov    0x20(%edx),%esi
80104cab:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  np->function = function;

  // Stack pointer is at the bottom, bring it up; push return
  // address and arg
  *(uint*)(stack + PGSIZE - 1 * sizeof(void *)) = (uint)arg;
80104cad:	8b 4d 10             	mov    0x10(%ebp),%ecx
  // </Code for new thread>

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80104cb0:	31 f6                	xor    %esi,%esi
80104cb2:	89 d7                	mov    %edx,%edi
  np->tgid = curproc->tgid; /* Same tgid with parent => thread */
80104cb4:	8b 42 18             	mov    0x18(%edx),%eax
  np->tf->esp = (uint)stack + PGSIZE - 2 * sizeof(void*);
80104cb7:	81 c1 f8 0f 00 00    	add    $0xff8,%ecx
  np->tgid = curproc->tgid; /* Same tgid with parent => thread */
80104cbd:	89 43 18             	mov    %eax,0x18(%ebx)
  np->function = function;
80104cc0:	8b 45 08             	mov    0x8(%ebp),%eax
80104cc3:	89 83 c4 00 00 00    	mov    %eax,0xc4(%ebx)
  *(uint*)(stack + PGSIZE - 1 * sizeof(void *)) = (uint)arg;
80104cc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  *(uint*)(stack + PGSIZE - 2 * sizeof(void *)) = 0xFFFFFFFF;
80104ccc:	c7 01 ff ff ff ff    	movl   $0xffffffff,(%ecx)
  *(uint*)(stack + PGSIZE - 1 * sizeof(void *)) = (uint)arg;
80104cd2:	89 41 04             	mov    %eax,0x4(%ecx)
  np->tf->esp = (uint)stack + PGSIZE - 2 * sizeof(void*);
80104cd5:	8b 43 20             	mov    0x20(%ebx),%eax
80104cd8:	89 48 44             	mov    %ecx,0x44(%eax)
  np->tf->ebp = np->tf->esp;
80104cdb:	8b 43 20             	mov    0x20(%ebx),%eax
80104cde:	8b 48 44             	mov    0x44(%eax),%ecx
80104ce1:	89 48 08             	mov    %ecx,0x8(%eax)
  np->tf->eip = (uint) function;
80104ce4:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104ce7:	8b 43 20             	mov    0x20(%ebx),%eax
80104cea:	89 48 38             	mov    %ecx,0x38(%eax)
  np->tstack = stack;
80104ced:	8b 45 10             	mov    0x10(%ebp),%eax
80104cf0:	89 43 0c             	mov    %eax,0xc(%ebx)
  np->tf->eax = 0;
80104cf3:	8b 43 20             	mov    0x20(%ebx),%eax
80104cf6:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80104cfd:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[i])
80104d00:	8b 44 b7 30          	mov    0x30(%edi,%esi,4),%eax
80104d04:	85 c0                	test   %eax,%eax
80104d06:	74 10                	je     80104d18 <clone+0xb8>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104d08:	83 ec 0c             	sub    $0xc,%esp
80104d0b:	50                   	push   %eax
80104d0c:	e8 8f c1 ff ff       	call   80100ea0 <filedup>
80104d11:	83 c4 10             	add    $0x10,%esp
80104d14:	89 44 b3 30          	mov    %eax,0x30(%ebx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80104d18:	83 c6 01             	add    $0x1,%esi
80104d1b:	83 fe 10             	cmp    $0x10,%esi
80104d1e:	75 e0                	jne    80104d00 <clone+0xa0>
  np->cwd = idup(curproc->cwd);
80104d20:	83 ec 0c             	sub    $0xc,%esp
80104d23:	ff 77 70             	push   0x70(%edi)
80104d26:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80104d29:	e8 22 ca ff ff       	call   80101750 <idup>

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104d2e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104d31:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80104d34:	89 43 70             	mov    %eax,0x70(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104d37:	8d 43 74             	lea    0x74(%ebx),%eax
80104d3a:	83 c2 74             	add    $0x74,%edx
80104d3d:	6a 10                	push   $0x10
80104d3f:	52                   	push   %edx
80104d40:	50                   	push   %eax
80104d41:	e8 0a 08 00 00       	call   80105550 <safestrcpy>

  pid = np->pid;
80104d46:	8b 73 14             	mov    0x14(%ebx),%esi

  acquire(&ptable.lock);
80104d49:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
80104d50:	e8 7b 05 00 00       	call   801052d0 <acquire>
	for(int i=0; i < q_tail[q_no]; i++)
80104d55:	8b 0d 0c b0 10 80    	mov    0x8010b00c,%ecx

  np->state = RUNNABLE;
80104d5b:	c7 43 10 03 00 00 00 	movl   $0x3,0x10(%ebx)
	for(int i=0; i < q_tail[q_no]; i++)
80104d62:	83 c4 10             	add    $0x10,%esp
80104d65:	85 c9                	test   %ecx,%ecx
80104d67:	7e 3f                	jle    80104da8 <clone+0x148>
		if(p->pid == queue[q_no][i]->pid)
80104d69:	8b 7b 14             	mov    0x14(%ebx),%edi
	for(int i=0; i < q_tail[q_no]; i++)
80104d6c:	31 c0                	xor    %eax,%eax
80104d6e:	eb 07                	jmp    80104d77 <clone+0x117>
80104d70:	83 c0 01             	add    $0x1,%eax
80104d73:	39 c8                	cmp    %ecx,%eax
80104d75:	74 31                	je     80104da8 <clone+0x148>
		if(p->pid == queue[q_no][i]->pid)
80104d77:	8b 14 85 40 2d 11 80 	mov    -0x7feed2c0(,%eax,4),%edx
80104d7e:	3b 7a 14             	cmp    0x14(%edx),%edi
80104d81:	75 ed                	jne    80104d70 <clone+0x110>

  #ifdef MLFQ
  		add_proc_to_q(np, 0);
  #endif

  release(&ptable.lock);
80104d83:	83 ec 0c             	sub    $0xc,%esp
80104d86:	68 40 32 11 80       	push   $0x80113240
80104d8b:	e8 e0 04 00 00       	call   80105270 <release>

  printinfo(np);
80104d90:	89 1c 24             	mov    %ebx,(%esp)
80104d93:	e8 58 fe ff ff       	call   80104bf0 <printinfo>

  return pid;
80104d98:	83 c4 10             	add    $0x10,%esp
}
80104d9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d9e:	89 f0                	mov    %esi,%eax
80104da0:	5b                   	pop    %ebx
80104da1:	5e                   	pop    %esi
80104da2:	5f                   	pop    %edi
80104da3:	5d                   	pop    %ebp
80104da4:	c3                   	ret    
80104da5:	8d 76 00             	lea    0x0(%esi),%esi
	p->enter = ticks;
80104da8:	a1 84 65 11 80       	mov    0x80116584,%eax
	q_tail[q_no]++;
80104dad:	83 c1 01             	add    $0x1,%ecx
	p -> queue = q_no;
80104db0:	c7 83 b4 00 00 00 00 	movl   $0x0,0xb4(%ebx)
80104db7:	00 00 00 
	q_tail[q_no]++;
80104dba:	89 0d 0c b0 10 80    	mov    %ecx,0x8010b00c
	p->enter = ticks;
80104dc0:	89 83 c0 00 00 00    	mov    %eax,0xc0(%ebx)
	queue[q_no][q_tail[q_no]] = p;
80104dc6:	89 1c 8d 40 2d 11 80 	mov    %ebx,-0x7feed2c0(,%ecx,4)
	return 1;
80104dcd:	eb b4                	jmp    80104d83 <clone+0x123>
    return -1;
80104dcf:	be ff ff ff ff       	mov    $0xffffffff,%esi
80104dd4:	eb c5                	jmp    80104d9b <clone+0x13b>
80104dd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ddd:	8d 76 00             	lea    0x0(%esi),%esi

80104de0 <join>:

int
join(int tid, void** stack)
{
80104de0:	55                   	push   %ebp
80104de1:	89 e5                	mov    %esp,%ebp
80104de3:	57                   	push   %edi
80104de4:	56                   	push   %esi
80104de5:	53                   	push   %ebx
80104de6:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80104de9:	e8 92 03 00 00       	call   80105180 <pushcli>
  c = mycpu();
80104dee:	e8 ad ed ff ff       	call   80103ba0 <mycpu>
  p = c->proc;
80104df3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104df9:	e8 d2 03 00 00       	call   801051d0 <popcli>
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();

  acquire(&ptable.lock);
80104dfe:	83 ec 0c             	sub    $0xc,%esp
80104e01:	68 40 32 11 80       	push   $0x80113240
80104e06:	e8 c5 04 00 00       	call   801052d0 <acquire>
80104e0b:	8b 55 08             	mov    0x8(%ebp),%edx
80104e0e:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80104e11:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e13:	bb 74 32 11 80       	mov    $0x80113274,%ebx
80104e18:	eb 14                	jmp    80104e2e <join+0x4e>
80104e1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e20:	81 c3 cc 00 00 00    	add    $0xcc,%ebx
80104e26:	81 fb 74 65 11 80    	cmp    $0x80116574,%ebx
80104e2c:	74 32                	je     80104e60 <join+0x80>
      if(p->parent != curproc || p->pgdir != curproc->pgdir || p->pid != tid)
80104e2e:	39 73 1c             	cmp    %esi,0x1c(%ebx)
80104e31:	75 ed                	jne    80104e20 <join+0x40>
80104e33:	8b 4e 04             	mov    0x4(%esi),%ecx
80104e36:	39 4b 04             	cmp    %ecx,0x4(%ebx)
80104e39:	75 e5                	jne    80104e20 <join+0x40>
80104e3b:	8b 7b 14             	mov    0x14(%ebx),%edi
80104e3e:	39 d7                	cmp    %edx,%edi
80104e40:	75 de                	jne    80104e20 <join+0x40>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
80104e42:	83 7b 10 05          	cmpl   $0x5,0x10(%ebx)
80104e46:	74 6f                	je     80104eb7 <join+0xd7>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e48:	81 c3 cc 00 00 00    	add    $0xcc,%ebx
      havekids = 1;
80104e4e:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e53:	81 fb 74 65 11 80    	cmp    $0x80116574,%ebx
80104e59:	75 d3                	jne    80104e2e <join+0x4e>
80104e5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e5f:	90                   	nop
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80104e60:	85 c0                	test   %eax,%eax
80104e62:	0f 84 a9 00 00 00    	je     80104f11 <join+0x131>
80104e68:	8b 46 2c             	mov    0x2c(%esi),%eax
80104e6b:	85 c0                	test   %eax,%eax
80104e6d:	0f 85 9e 00 00 00    	jne    80104f11 <join+0x131>
80104e73:	89 55 08             	mov    %edx,0x8(%ebp)
  pushcli();
80104e76:	e8 05 03 00 00       	call   80105180 <pushcli>
  c = mycpu();
80104e7b:	e8 20 ed ff ff       	call   80103ba0 <mycpu>
  p = c->proc;
80104e80:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104e86:	e8 45 03 00 00       	call   801051d0 <popcli>
  if(p == 0)
80104e8b:	8b 55 08             	mov    0x8(%ebp),%edx
80104e8e:	85 db                	test   %ebx,%ebx
80104e90:	0f 84 9a 00 00 00    	je     80104f30 <join+0x150>
  p->chan = chan;
80104e96:	89 73 28             	mov    %esi,0x28(%ebx)
  p->state = SLEEPING;
80104e99:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
80104ea0:	89 55 08             	mov    %edx,0x8(%ebp)
  sched();
80104ea3:	e8 08 f3 ff ff       	call   801041b0 <sched>
  p->chan = 0;
80104ea8:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)
}
80104eaf:	8b 55 08             	mov    0x8(%ebp),%edx
80104eb2:	e9 5a ff ff ff       	jmp    80104e11 <join+0x31>
        kfree(p->kstack);
80104eb7:	83 ec 0c             	sub    $0xc,%esp
80104eba:	ff 73 08             	push   0x8(%ebx)
80104ebd:	e8 fe d5 ff ff       	call   801024c0 <kfree>
        *stack = p->tstack;
80104ec2:	8b 53 0c             	mov    0xc(%ebx),%edx
80104ec5:	8b 45 0c             	mov    0xc(%ebp),%eax
        p->kstack = 0;
80104ec8:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        *stack = p->tstack;
80104ecf:	89 10                	mov    %edx,(%eax)
        p->tstack = 0;
80104ed1:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        p->pid = 0;
80104ed8:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->parent = 0;
80104edf:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
        p->name[0] = 0;
80104ee6:	c6 43 74 00          	movb   $0x0,0x74(%ebx)
        p->killed = 0;
80104eea:	c7 43 2c 00 00 00 00 	movl   $0x0,0x2c(%ebx)
        p->state = UNUSED;
80104ef1:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        release(&ptable.lock);
80104ef8:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
80104eff:	e8 6c 03 00 00       	call   80105270 <release>
        return pid;
80104f04:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80104f07:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f0a:	89 f8                	mov    %edi,%eax
80104f0c:	5b                   	pop    %ebx
80104f0d:	5e                   	pop    %esi
80104f0e:	5f                   	pop    %edi
80104f0f:	5d                   	pop    %ebp
80104f10:	c3                   	ret    
      release(&ptable.lock);
80104f11:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104f14:	bf ff ff ff ff       	mov    $0xffffffff,%edi
      release(&ptable.lock);
80104f19:	68 40 32 11 80       	push   $0x80113240
80104f1e:	e8 4d 03 00 00       	call   80105270 <release>
      return -1;
80104f23:	83 c4 10             	add    $0x10,%esp
}
80104f26:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f29:	89 f8                	mov    %edi,%eax
80104f2b:	5b                   	pop    %ebx
80104f2c:	5e                   	pop    %esi
80104f2d:	5f                   	pop    %edi
80104f2e:	5d                   	pop    %ebp
80104f2f:	c3                   	ret    
    panic("sleep");
80104f30:	83 ec 0c             	sub    $0xc,%esp
80104f33:	68 14 86 10 80       	push   $0x80108614
80104f38:	e8 43 b4 ff ff       	call   80100380 <panic>
80104f3d:	8d 76 00             	lea    0x0(%esi),%esi

80104f40 <sys_threadinfo>:


int sys_threadinfo(void)
{
80104f40:	55                   	push   %ebp
80104f41:	89 e5                	mov    %esp,%ebp
80104f43:	53                   	push   %ebx
80104f44:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80104f47:	e8 34 02 00 00       	call   80105180 <pushcli>
  c = mycpu();
80104f4c:	e8 4f ec ff ff       	call   80103ba0 <mycpu>
  p = c->proc;
80104f51:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104f57:	e8 74 02 00 00       	call   801051d0 <popcli>
	struct proc *p = myproc();
	cprintf("PID : %d\n", p->tgid);
80104f5c:	83 ec 08             	sub    $0x8,%esp
80104f5f:	ff 73 18             	push   0x18(%ebx)
80104f62:	68 38 86 10 80       	push   $0x80108638
80104f67:	e8 34 b7 ff ff       	call   801006a0 <cprintf>
	cprintf("TID : %d\n",p->pid);
80104f6c:	58                   	pop    %eax
80104f6d:	5a                   	pop    %edx
80104f6e:	ff 73 14             	push   0x14(%ebx)
80104f71:	68 42 86 10 80       	push   $0x80108642
80104f76:	e8 25 b7 ff ff       	call   801006a0 <cprintf>
	cprintf("Page Directory Address : %p\n", p->pgdir);
80104f7b:	59                   	pop    %ecx
80104f7c:	58                   	pop    %eax
80104f7d:	ff 73 04             	push   0x4(%ebx)
80104f80:	68 b5 86 10 80       	push   $0x801086b5
80104f85:	e8 16 b7 ff ff       	call   801006a0 <cprintf>
	cprintf("Stack Pointer Value : %p\n", p->tf->esp);
80104f8a:	58                   	pop    %eax
80104f8b:	8b 43 20             	mov    0x20(%ebx),%eax
80104f8e:	5a                   	pop    %edx
80104f8f:	ff 70 44             	push   0x44(%eax)
80104f92:	68 d2 86 10 80       	push   $0x801086d2
80104f97:	e8 04 b7 ff ff       	call   801006a0 <cprintf>
	cprintf("Statr Function Address : %p\n", p->function);
80104f9c:	59                   	pop    %ecx
80104f9d:	58                   	pop    %eax
80104f9e:	ff b3 c4 00 00 00    	push   0xc4(%ebx)
80104fa4:	68 ec 86 10 80       	push   $0x801086ec
80104fa9:	e8 f2 b6 ff ff       	call   801006a0 <cprintf>
	cprintf("Memory Size : %d bytes\n\n", p->sz);
80104fae:	58                   	pop    %eax
80104faf:	5a                   	pop    %edx
80104fb0:	ff 33                	push   (%ebx)
80104fb2:	68 09 87 10 80       	push   $0x80108709
80104fb7:	e8 e4 b6 ff ff       	call   801006a0 <cprintf>
	return 0;
}
80104fbc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104fbf:	31 c0                	xor    %eax,%eax
80104fc1:	c9                   	leave  
80104fc2:	c3                   	ret    
80104fc3:	66 90                	xchg   %ax,%ax
80104fc5:	66 90                	xchg   %ax,%ax
80104fc7:	66 90                	xchg   %ax,%ax
80104fc9:	66 90                	xchg   %ax,%ax
80104fcb:	66 90                	xchg   %ax,%ax
80104fcd:	66 90                	xchg   %ax,%ax
80104fcf:	90                   	nop

80104fd0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104fd0:	55                   	push   %ebp
80104fd1:	89 e5                	mov    %esp,%ebp
80104fd3:	53                   	push   %ebx
80104fd4:	83 ec 0c             	sub    $0xc,%esp
80104fd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104fda:	68 ec 88 10 80       	push   $0x801088ec
80104fdf:	8d 43 04             	lea    0x4(%ebx),%eax
80104fe2:	50                   	push   %eax
80104fe3:	e8 18 01 00 00       	call   80105100 <initlock>
  lk->name = name;
80104fe8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104feb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104ff1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104ff4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104ffb:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104ffe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105001:	c9                   	leave  
80105002:	c3                   	ret    
80105003:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010500a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105010 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80105010:	55                   	push   %ebp
80105011:	89 e5                	mov    %esp,%ebp
80105013:	56                   	push   %esi
80105014:	53                   	push   %ebx
80105015:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80105018:	8d 73 04             	lea    0x4(%ebx),%esi
8010501b:	83 ec 0c             	sub    $0xc,%esp
8010501e:	56                   	push   %esi
8010501f:	e8 ac 02 00 00       	call   801052d0 <acquire>
  while (lk->locked) {
80105024:	8b 13                	mov    (%ebx),%edx
80105026:	83 c4 10             	add    $0x10,%esp
80105029:	85 d2                	test   %edx,%edx
8010502b:	74 16                	je     80105043 <acquiresleep+0x33>
8010502d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80105030:	83 ec 08             	sub    $0x8,%esp
80105033:	56                   	push   %esi
80105034:	53                   	push   %ebx
80105035:	e8 16 f7 ff ff       	call   80104750 <sleep>
  while (lk->locked) {
8010503a:	8b 03                	mov    (%ebx),%eax
8010503c:	83 c4 10             	add    $0x10,%esp
8010503f:	85 c0                	test   %eax,%eax
80105041:	75 ed                	jne    80105030 <acquiresleep+0x20>
  }
  lk->locked = 1;
80105043:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80105049:	e8 d2 eb ff ff       	call   80103c20 <myproc>
8010504e:	8b 40 14             	mov    0x14(%eax),%eax
80105051:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80105054:	89 75 08             	mov    %esi,0x8(%ebp)
}
80105057:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010505a:	5b                   	pop    %ebx
8010505b:	5e                   	pop    %esi
8010505c:	5d                   	pop    %ebp
  release(&lk->lk);
8010505d:	e9 0e 02 00 00       	jmp    80105270 <release>
80105062:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105070 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80105070:	55                   	push   %ebp
80105071:	89 e5                	mov    %esp,%ebp
80105073:	56                   	push   %esi
80105074:	53                   	push   %ebx
80105075:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80105078:	8d 73 04             	lea    0x4(%ebx),%esi
8010507b:	83 ec 0c             	sub    $0xc,%esp
8010507e:	56                   	push   %esi
8010507f:	e8 4c 02 00 00       	call   801052d0 <acquire>
  lk->locked = 0;
80105084:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010508a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80105091:	89 1c 24             	mov    %ebx,(%esp)
80105094:	e8 77 f7 ff ff       	call   80104810 <wakeup>
  release(&lk->lk);
80105099:	89 75 08             	mov    %esi,0x8(%ebp)
8010509c:	83 c4 10             	add    $0x10,%esp
}
8010509f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050a2:	5b                   	pop    %ebx
801050a3:	5e                   	pop    %esi
801050a4:	5d                   	pop    %ebp
  release(&lk->lk);
801050a5:	e9 c6 01 00 00       	jmp    80105270 <release>
801050aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801050b0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801050b0:	55                   	push   %ebp
801050b1:	89 e5                	mov    %esp,%ebp
801050b3:	57                   	push   %edi
801050b4:	31 ff                	xor    %edi,%edi
801050b6:	56                   	push   %esi
801050b7:	53                   	push   %ebx
801050b8:	83 ec 18             	sub    $0x18,%esp
801050bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801050be:	8d 73 04             	lea    0x4(%ebx),%esi
801050c1:	56                   	push   %esi
801050c2:	e8 09 02 00 00       	call   801052d0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801050c7:	8b 03                	mov    (%ebx),%eax
801050c9:	83 c4 10             	add    $0x10,%esp
801050cc:	85 c0                	test   %eax,%eax
801050ce:	75 18                	jne    801050e8 <holdingsleep+0x38>
  release(&lk->lk);
801050d0:	83 ec 0c             	sub    $0xc,%esp
801050d3:	56                   	push   %esi
801050d4:	e8 97 01 00 00       	call   80105270 <release>
  return r;
}
801050d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050dc:	89 f8                	mov    %edi,%eax
801050de:	5b                   	pop    %ebx
801050df:	5e                   	pop    %esi
801050e0:	5f                   	pop    %edi
801050e1:	5d                   	pop    %ebp
801050e2:	c3                   	ret    
801050e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801050e7:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
801050e8:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801050eb:	e8 30 eb ff ff       	call   80103c20 <myproc>
801050f0:	39 58 14             	cmp    %ebx,0x14(%eax)
801050f3:	0f 94 c0             	sete   %al
801050f6:	0f b6 c0             	movzbl %al,%eax
801050f9:	89 c7                	mov    %eax,%edi
801050fb:	eb d3                	jmp    801050d0 <holdingsleep+0x20>
801050fd:	66 90                	xchg   %ax,%ax
801050ff:	90                   	nop

80105100 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80105100:	55                   	push   %ebp
80105101:	89 e5                	mov    %esp,%ebp
80105103:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80105106:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80105109:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010510f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80105112:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80105119:	5d                   	pop    %ebp
8010511a:	c3                   	ret    
8010511b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010511f:	90                   	nop

80105120 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105120:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105121:	31 d2                	xor    %edx,%edx
{
80105123:	89 e5                	mov    %esp,%ebp
80105125:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80105126:	8b 45 08             	mov    0x8(%ebp),%eax
{
80105129:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010512c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
8010512f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105130:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80105136:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010513c:	77 1a                	ja     80105158 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010513e:	8b 58 04             	mov    0x4(%eax),%ebx
80105141:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80105144:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80105147:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105149:	83 fa 0a             	cmp    $0xa,%edx
8010514c:	75 e2                	jne    80105130 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010514e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105151:	c9                   	leave  
80105152:	c3                   	ret    
80105153:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105157:	90                   	nop
  for(; i < 10; i++)
80105158:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010515b:	8d 51 28             	lea    0x28(%ecx),%edx
8010515e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80105160:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105166:	83 c0 04             	add    $0x4,%eax
80105169:	39 d0                	cmp    %edx,%eax
8010516b:	75 f3                	jne    80105160 <getcallerpcs+0x40>
}
8010516d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105170:	c9                   	leave  
80105171:	c3                   	ret    
80105172:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105180 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105180:	55                   	push   %ebp
80105181:	89 e5                	mov    %esp,%ebp
80105183:	53                   	push   %ebx
80105184:	83 ec 04             	sub    $0x4,%esp
80105187:	9c                   	pushf  
80105188:	5b                   	pop    %ebx
  asm volatile("cli");
80105189:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010518a:	e8 11 ea ff ff       	call   80103ba0 <mycpu>
8010518f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105195:	85 c0                	test   %eax,%eax
80105197:	74 17                	je     801051b0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80105199:	e8 02 ea ff ff       	call   80103ba0 <mycpu>
8010519e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801051a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801051a8:	c9                   	leave  
801051a9:	c3                   	ret    
801051aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
801051b0:	e8 eb e9 ff ff       	call   80103ba0 <mycpu>
801051b5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801051bb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801051c1:	eb d6                	jmp    80105199 <pushcli+0x19>
801051c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801051d0 <popcli>:

void
popcli(void)
{
801051d0:	55                   	push   %ebp
801051d1:	89 e5                	mov    %esp,%ebp
801051d3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801051d6:	9c                   	pushf  
801051d7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801051d8:	f6 c4 02             	test   $0x2,%ah
801051db:	75 35                	jne    80105212 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801051dd:	e8 be e9 ff ff       	call   80103ba0 <mycpu>
801051e2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801051e9:	78 34                	js     8010521f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801051eb:	e8 b0 e9 ff ff       	call   80103ba0 <mycpu>
801051f0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801051f6:	85 d2                	test   %edx,%edx
801051f8:	74 06                	je     80105200 <popcli+0x30>
    sti();
}
801051fa:	c9                   	leave  
801051fb:	c3                   	ret    
801051fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80105200:	e8 9b e9 ff ff       	call   80103ba0 <mycpu>
80105205:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010520b:	85 c0                	test   %eax,%eax
8010520d:	74 eb                	je     801051fa <popcli+0x2a>
  asm volatile("sti");
8010520f:	fb                   	sti    
}
80105210:	c9                   	leave  
80105211:	c3                   	ret    
    panic("popcli - interruptible");
80105212:	83 ec 0c             	sub    $0xc,%esp
80105215:	68 f7 88 10 80       	push   $0x801088f7
8010521a:	e8 61 b1 ff ff       	call   80100380 <panic>
    panic("popcli");
8010521f:	83 ec 0c             	sub    $0xc,%esp
80105222:	68 0e 89 10 80       	push   $0x8010890e
80105227:	e8 54 b1 ff ff       	call   80100380 <panic>
8010522c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105230 <holding>:
{
80105230:	55                   	push   %ebp
80105231:	89 e5                	mov    %esp,%ebp
80105233:	56                   	push   %esi
80105234:	53                   	push   %ebx
80105235:	8b 75 08             	mov    0x8(%ebp),%esi
80105238:	31 db                	xor    %ebx,%ebx
  pushcli();
8010523a:	e8 41 ff ff ff       	call   80105180 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010523f:	8b 06                	mov    (%esi),%eax
80105241:	85 c0                	test   %eax,%eax
80105243:	75 0b                	jne    80105250 <holding+0x20>
  popcli();
80105245:	e8 86 ff ff ff       	call   801051d0 <popcli>
}
8010524a:	89 d8                	mov    %ebx,%eax
8010524c:	5b                   	pop    %ebx
8010524d:	5e                   	pop    %esi
8010524e:	5d                   	pop    %ebp
8010524f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80105250:	8b 5e 08             	mov    0x8(%esi),%ebx
80105253:	e8 48 e9 ff ff       	call   80103ba0 <mycpu>
80105258:	39 c3                	cmp    %eax,%ebx
8010525a:	0f 94 c3             	sete   %bl
  popcli();
8010525d:	e8 6e ff ff ff       	call   801051d0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80105262:	0f b6 db             	movzbl %bl,%ebx
}
80105265:	89 d8                	mov    %ebx,%eax
80105267:	5b                   	pop    %ebx
80105268:	5e                   	pop    %esi
80105269:	5d                   	pop    %ebp
8010526a:	c3                   	ret    
8010526b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010526f:	90                   	nop

80105270 <release>:
{
80105270:	55                   	push   %ebp
80105271:	89 e5                	mov    %esp,%ebp
80105273:	56                   	push   %esi
80105274:	53                   	push   %ebx
80105275:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80105278:	e8 03 ff ff ff       	call   80105180 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010527d:	8b 03                	mov    (%ebx),%eax
8010527f:	85 c0                	test   %eax,%eax
80105281:	75 15                	jne    80105298 <release+0x28>
  popcli();
80105283:	e8 48 ff ff ff       	call   801051d0 <popcli>
    panic("release");
80105288:	83 ec 0c             	sub    $0xc,%esp
8010528b:	68 15 89 10 80       	push   $0x80108915
80105290:	e8 eb b0 ff ff       	call   80100380 <panic>
80105295:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80105298:	8b 73 08             	mov    0x8(%ebx),%esi
8010529b:	e8 00 e9 ff ff       	call   80103ba0 <mycpu>
801052a0:	39 c6                	cmp    %eax,%esi
801052a2:	75 df                	jne    80105283 <release+0x13>
  popcli();
801052a4:	e8 27 ff ff ff       	call   801051d0 <popcli>
  lk->pcs[0] = 0;
801052a9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801052b0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801052b7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801052bc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801052c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052c5:	5b                   	pop    %ebx
801052c6:	5e                   	pop    %esi
801052c7:	5d                   	pop    %ebp
  popcli();
801052c8:	e9 03 ff ff ff       	jmp    801051d0 <popcli>
801052cd:	8d 76 00             	lea    0x0(%esi),%esi

801052d0 <acquire>:
{
801052d0:	55                   	push   %ebp
801052d1:	89 e5                	mov    %esp,%ebp
801052d3:	53                   	push   %ebx
801052d4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801052d7:	e8 a4 fe ff ff       	call   80105180 <pushcli>
  if(holding(lk))
801052dc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801052df:	e8 9c fe ff ff       	call   80105180 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801052e4:	8b 03                	mov    (%ebx),%eax
801052e6:	85 c0                	test   %eax,%eax
801052e8:	75 7e                	jne    80105368 <acquire+0x98>
  popcli();
801052ea:	e8 e1 fe ff ff       	call   801051d0 <popcli>
  asm volatile("lock; xchgl %0, %1" :
801052ef:	b9 01 00 00 00       	mov    $0x1,%ecx
801052f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
801052f8:	8b 55 08             	mov    0x8(%ebp),%edx
801052fb:	89 c8                	mov    %ecx,%eax
801052fd:	f0 87 02             	lock xchg %eax,(%edx)
80105300:	85 c0                	test   %eax,%eax
80105302:	75 f4                	jne    801052f8 <acquire+0x28>
  __sync_synchronize();
80105304:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80105309:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010530c:	e8 8f e8 ff ff       	call   80103ba0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80105311:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80105314:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80105316:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80105319:	31 c0                	xor    %eax,%eax
8010531b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010531f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105320:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80105326:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010532c:	77 1a                	ja     80105348 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
8010532e:	8b 5a 04             	mov    0x4(%edx),%ebx
80105331:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80105335:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80105338:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
8010533a:	83 f8 0a             	cmp    $0xa,%eax
8010533d:	75 e1                	jne    80105320 <acquire+0x50>
}
8010533f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105342:	c9                   	leave  
80105343:	c3                   	ret    
80105344:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80105348:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
8010534c:	8d 51 34             	lea    0x34(%ecx),%edx
8010534f:	90                   	nop
    pcs[i] = 0;
80105350:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105356:	83 c0 04             	add    $0x4,%eax
80105359:	39 c2                	cmp    %eax,%edx
8010535b:	75 f3                	jne    80105350 <acquire+0x80>
}
8010535d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105360:	c9                   	leave  
80105361:	c3                   	ret    
80105362:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80105368:	8b 5b 08             	mov    0x8(%ebx),%ebx
8010536b:	e8 30 e8 ff ff       	call   80103ba0 <mycpu>
80105370:	39 c3                	cmp    %eax,%ebx
80105372:	0f 85 72 ff ff ff    	jne    801052ea <acquire+0x1a>
  popcli();
80105378:	e8 53 fe ff ff       	call   801051d0 <popcli>
    panic("acquire");
8010537d:	83 ec 0c             	sub    $0xc,%esp
80105380:	68 1d 89 10 80       	push   $0x8010891d
80105385:	e8 f6 af ff ff       	call   80100380 <panic>
8010538a:	66 90                	xchg   %ax,%ax
8010538c:	66 90                	xchg   %ax,%ax
8010538e:	66 90                	xchg   %ax,%ax

80105390 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105390:	55                   	push   %ebp
80105391:	89 e5                	mov    %esp,%ebp
80105393:	57                   	push   %edi
80105394:	8b 55 08             	mov    0x8(%ebp),%edx
80105397:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010539a:	53                   	push   %ebx
8010539b:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
8010539e:	89 d7                	mov    %edx,%edi
801053a0:	09 cf                	or     %ecx,%edi
801053a2:	83 e7 03             	and    $0x3,%edi
801053a5:	75 29                	jne    801053d0 <memset+0x40>
    c &= 0xFF;
801053a7:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801053aa:	c1 e0 18             	shl    $0x18,%eax
801053ad:	89 fb                	mov    %edi,%ebx
801053af:	c1 e9 02             	shr    $0x2,%ecx
801053b2:	c1 e3 10             	shl    $0x10,%ebx
801053b5:	09 d8                	or     %ebx,%eax
801053b7:	09 f8                	or     %edi,%eax
801053b9:	c1 e7 08             	shl    $0x8,%edi
801053bc:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801053be:	89 d7                	mov    %edx,%edi
801053c0:	fc                   	cld    
801053c1:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801053c3:	5b                   	pop    %ebx
801053c4:	89 d0                	mov    %edx,%eax
801053c6:	5f                   	pop    %edi
801053c7:	5d                   	pop    %ebp
801053c8:	c3                   	ret    
801053c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
801053d0:	89 d7                	mov    %edx,%edi
801053d2:	fc                   	cld    
801053d3:	f3 aa                	rep stos %al,%es:(%edi)
801053d5:	5b                   	pop    %ebx
801053d6:	89 d0                	mov    %edx,%eax
801053d8:	5f                   	pop    %edi
801053d9:	5d                   	pop    %ebp
801053da:	c3                   	ret    
801053db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053df:	90                   	nop

801053e0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801053e0:	55                   	push   %ebp
801053e1:	89 e5                	mov    %esp,%ebp
801053e3:	56                   	push   %esi
801053e4:	8b 75 10             	mov    0x10(%ebp),%esi
801053e7:	8b 55 08             	mov    0x8(%ebp),%edx
801053ea:	53                   	push   %ebx
801053eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801053ee:	85 f6                	test   %esi,%esi
801053f0:	74 2e                	je     80105420 <memcmp+0x40>
801053f2:	01 c6                	add    %eax,%esi
801053f4:	eb 14                	jmp    8010540a <memcmp+0x2a>
801053f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053fd:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80105400:	83 c0 01             	add    $0x1,%eax
80105403:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80105406:	39 f0                	cmp    %esi,%eax
80105408:	74 16                	je     80105420 <memcmp+0x40>
    if(*s1 != *s2)
8010540a:	0f b6 0a             	movzbl (%edx),%ecx
8010540d:	0f b6 18             	movzbl (%eax),%ebx
80105410:	38 d9                	cmp    %bl,%cl
80105412:	74 ec                	je     80105400 <memcmp+0x20>
      return *s1 - *s2;
80105414:	0f b6 c1             	movzbl %cl,%eax
80105417:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80105419:	5b                   	pop    %ebx
8010541a:	5e                   	pop    %esi
8010541b:	5d                   	pop    %ebp
8010541c:	c3                   	ret    
8010541d:	8d 76 00             	lea    0x0(%esi),%esi
80105420:	5b                   	pop    %ebx
  return 0;
80105421:	31 c0                	xor    %eax,%eax
}
80105423:	5e                   	pop    %esi
80105424:	5d                   	pop    %ebp
80105425:	c3                   	ret    
80105426:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010542d:	8d 76 00             	lea    0x0(%esi),%esi

80105430 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105430:	55                   	push   %ebp
80105431:	89 e5                	mov    %esp,%ebp
80105433:	57                   	push   %edi
80105434:	8b 55 08             	mov    0x8(%ebp),%edx
80105437:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010543a:	56                   	push   %esi
8010543b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010543e:	39 d6                	cmp    %edx,%esi
80105440:	73 26                	jae    80105468 <memmove+0x38>
80105442:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80105445:	39 fa                	cmp    %edi,%edx
80105447:	73 1f                	jae    80105468 <memmove+0x38>
80105449:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
8010544c:	85 c9                	test   %ecx,%ecx
8010544e:	74 0c                	je     8010545c <memmove+0x2c>
      *--d = *--s;
80105450:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80105454:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80105457:	83 e8 01             	sub    $0x1,%eax
8010545a:	73 f4                	jae    80105450 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010545c:	5e                   	pop    %esi
8010545d:	89 d0                	mov    %edx,%eax
8010545f:	5f                   	pop    %edi
80105460:	5d                   	pop    %ebp
80105461:	c3                   	ret    
80105462:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80105468:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
8010546b:	89 d7                	mov    %edx,%edi
8010546d:	85 c9                	test   %ecx,%ecx
8010546f:	74 eb                	je     8010545c <memmove+0x2c>
80105471:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80105478:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80105479:	39 c6                	cmp    %eax,%esi
8010547b:	75 fb                	jne    80105478 <memmove+0x48>
}
8010547d:	5e                   	pop    %esi
8010547e:	89 d0                	mov    %edx,%eax
80105480:	5f                   	pop    %edi
80105481:	5d                   	pop    %ebp
80105482:	c3                   	ret    
80105483:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010548a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105490 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80105490:	eb 9e                	jmp    80105430 <memmove>
80105492:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801054a0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801054a0:	55                   	push   %ebp
801054a1:	89 e5                	mov    %esp,%ebp
801054a3:	56                   	push   %esi
801054a4:	8b 75 10             	mov    0x10(%ebp),%esi
801054a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
801054aa:	53                   	push   %ebx
801054ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
801054ae:	85 f6                	test   %esi,%esi
801054b0:	74 2e                	je     801054e0 <strncmp+0x40>
801054b2:	01 d6                	add    %edx,%esi
801054b4:	eb 18                	jmp    801054ce <strncmp+0x2e>
801054b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054bd:	8d 76 00             	lea    0x0(%esi),%esi
801054c0:	38 d8                	cmp    %bl,%al
801054c2:	75 14                	jne    801054d8 <strncmp+0x38>
    n--, p++, q++;
801054c4:	83 c2 01             	add    $0x1,%edx
801054c7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801054ca:	39 f2                	cmp    %esi,%edx
801054cc:	74 12                	je     801054e0 <strncmp+0x40>
801054ce:	0f b6 01             	movzbl (%ecx),%eax
801054d1:	0f b6 1a             	movzbl (%edx),%ebx
801054d4:	84 c0                	test   %al,%al
801054d6:	75 e8                	jne    801054c0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801054d8:	29 d8                	sub    %ebx,%eax
}
801054da:	5b                   	pop    %ebx
801054db:	5e                   	pop    %esi
801054dc:	5d                   	pop    %ebp
801054dd:	c3                   	ret    
801054de:	66 90                	xchg   %ax,%ax
801054e0:	5b                   	pop    %ebx
    return 0;
801054e1:	31 c0                	xor    %eax,%eax
}
801054e3:	5e                   	pop    %esi
801054e4:	5d                   	pop    %ebp
801054e5:	c3                   	ret    
801054e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054ed:	8d 76 00             	lea    0x0(%esi),%esi

801054f0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801054f0:	55                   	push   %ebp
801054f1:	89 e5                	mov    %esp,%ebp
801054f3:	57                   	push   %edi
801054f4:	56                   	push   %esi
801054f5:	8b 75 08             	mov    0x8(%ebp),%esi
801054f8:	53                   	push   %ebx
801054f9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801054fc:	89 f0                	mov    %esi,%eax
801054fe:	eb 15                	jmp    80105515 <strncpy+0x25>
80105500:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80105504:	8b 7d 0c             	mov    0xc(%ebp),%edi
80105507:	83 c0 01             	add    $0x1,%eax
8010550a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
8010550e:	88 50 ff             	mov    %dl,-0x1(%eax)
80105511:	84 d2                	test   %dl,%dl
80105513:	74 09                	je     8010551e <strncpy+0x2e>
80105515:	89 cb                	mov    %ecx,%ebx
80105517:	83 e9 01             	sub    $0x1,%ecx
8010551a:	85 db                	test   %ebx,%ebx
8010551c:	7f e2                	jg     80105500 <strncpy+0x10>
    ;
  while(n-- > 0)
8010551e:	89 c2                	mov    %eax,%edx
80105520:	85 c9                	test   %ecx,%ecx
80105522:	7e 17                	jle    8010553b <strncpy+0x4b>
80105524:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80105528:	83 c2 01             	add    $0x1,%edx
8010552b:	89 c1                	mov    %eax,%ecx
8010552d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80105531:	29 d1                	sub    %edx,%ecx
80105533:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80105537:	85 c9                	test   %ecx,%ecx
80105539:	7f ed                	jg     80105528 <strncpy+0x38>
  return os;
}
8010553b:	5b                   	pop    %ebx
8010553c:	89 f0                	mov    %esi,%eax
8010553e:	5e                   	pop    %esi
8010553f:	5f                   	pop    %edi
80105540:	5d                   	pop    %ebp
80105541:	c3                   	ret    
80105542:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105550 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105550:	55                   	push   %ebp
80105551:	89 e5                	mov    %esp,%ebp
80105553:	56                   	push   %esi
80105554:	8b 55 10             	mov    0x10(%ebp),%edx
80105557:	8b 75 08             	mov    0x8(%ebp),%esi
8010555a:	53                   	push   %ebx
8010555b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
8010555e:	85 d2                	test   %edx,%edx
80105560:	7e 25                	jle    80105587 <safestrcpy+0x37>
80105562:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80105566:	89 f2                	mov    %esi,%edx
80105568:	eb 16                	jmp    80105580 <safestrcpy+0x30>
8010556a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105570:	0f b6 08             	movzbl (%eax),%ecx
80105573:	83 c0 01             	add    $0x1,%eax
80105576:	83 c2 01             	add    $0x1,%edx
80105579:	88 4a ff             	mov    %cl,-0x1(%edx)
8010557c:	84 c9                	test   %cl,%cl
8010557e:	74 04                	je     80105584 <safestrcpy+0x34>
80105580:	39 d8                	cmp    %ebx,%eax
80105582:	75 ec                	jne    80105570 <safestrcpy+0x20>
    ;
  *s = 0;
80105584:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80105587:	89 f0                	mov    %esi,%eax
80105589:	5b                   	pop    %ebx
8010558a:	5e                   	pop    %esi
8010558b:	5d                   	pop    %ebp
8010558c:	c3                   	ret    
8010558d:	8d 76 00             	lea    0x0(%esi),%esi

80105590 <strlen>:

int
strlen(const char *s)
{
80105590:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105591:	31 c0                	xor    %eax,%eax
{
80105593:	89 e5                	mov    %esp,%ebp
80105595:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105598:	80 3a 00             	cmpb   $0x0,(%edx)
8010559b:	74 0c                	je     801055a9 <strlen+0x19>
8010559d:	8d 76 00             	lea    0x0(%esi),%esi
801055a0:	83 c0 01             	add    $0x1,%eax
801055a3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801055a7:	75 f7                	jne    801055a0 <strlen+0x10>
    ;
  return n;
}
801055a9:	5d                   	pop    %ebp
801055aa:	c3                   	ret    

801055ab <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801055ab:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801055af:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801055b3:	55                   	push   %ebp
  pushl %ebx
801055b4:	53                   	push   %ebx
  pushl %esi
801055b5:	56                   	push   %esi
  pushl %edi
801055b6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801055b7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801055b9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801055bb:	5f                   	pop    %edi
  popl %esi
801055bc:	5e                   	pop    %esi
  popl %ebx
801055bd:	5b                   	pop    %ebx
  popl %ebp
801055be:	5d                   	pop    %ebp
  ret
801055bf:	c3                   	ret    

801055c0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801055c0:	55                   	push   %ebp
801055c1:	89 e5                	mov    %esp,%ebp
801055c3:	53                   	push   %ebx
801055c4:	83 ec 04             	sub    $0x4,%esp
801055c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801055ca:	e8 51 e6 ff ff       	call   80103c20 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801055cf:	8b 00                	mov    (%eax),%eax
801055d1:	39 d8                	cmp    %ebx,%eax
801055d3:	76 1b                	jbe    801055f0 <fetchint+0x30>
801055d5:	8d 53 04             	lea    0x4(%ebx),%edx
801055d8:	39 d0                	cmp    %edx,%eax
801055da:	72 14                	jb     801055f0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801055dc:	8b 45 0c             	mov    0xc(%ebp),%eax
801055df:	8b 13                	mov    (%ebx),%edx
801055e1:	89 10                	mov    %edx,(%eax)
  return 0;
801055e3:	31 c0                	xor    %eax,%eax
}
801055e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801055e8:	c9                   	leave  
801055e9:	c3                   	ret    
801055ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801055f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055f5:	eb ee                	jmp    801055e5 <fetchint+0x25>
801055f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055fe:	66 90                	xchg   %ax,%ax

80105600 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105600:	55                   	push   %ebp
80105601:	89 e5                	mov    %esp,%ebp
80105603:	53                   	push   %ebx
80105604:	83 ec 04             	sub    $0x4,%esp
80105607:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010560a:	e8 11 e6 ff ff       	call   80103c20 <myproc>

  if(addr >= curproc->sz)
8010560f:	39 18                	cmp    %ebx,(%eax)
80105611:	76 2d                	jbe    80105640 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80105613:	8b 55 0c             	mov    0xc(%ebp),%edx
80105616:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80105618:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010561a:	39 d3                	cmp    %edx,%ebx
8010561c:	73 22                	jae    80105640 <fetchstr+0x40>
8010561e:	89 d8                	mov    %ebx,%eax
80105620:	eb 0d                	jmp    8010562f <fetchstr+0x2f>
80105622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105628:	83 c0 01             	add    $0x1,%eax
8010562b:	39 c2                	cmp    %eax,%edx
8010562d:	76 11                	jbe    80105640 <fetchstr+0x40>
    if(*s == 0)
8010562f:	80 38 00             	cmpb   $0x0,(%eax)
80105632:	75 f4                	jne    80105628 <fetchstr+0x28>
      return s - *pp;
80105634:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80105636:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105639:	c9                   	leave  
8010563a:	c3                   	ret    
8010563b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010563f:	90                   	nop
80105640:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105643:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105648:	c9                   	leave  
80105649:	c3                   	ret    
8010564a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105650 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105650:	55                   	push   %ebp
80105651:	89 e5                	mov    %esp,%ebp
80105653:	56                   	push   %esi
80105654:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105655:	e8 c6 e5 ff ff       	call   80103c20 <myproc>
8010565a:	8b 55 08             	mov    0x8(%ebp),%edx
8010565d:	8b 40 20             	mov    0x20(%eax),%eax
80105660:	8b 40 44             	mov    0x44(%eax),%eax
80105663:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105666:	e8 b5 e5 ff ff       	call   80103c20 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010566b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010566e:	8b 00                	mov    (%eax),%eax
80105670:	39 c6                	cmp    %eax,%esi
80105672:	73 1c                	jae    80105690 <argint+0x40>
80105674:	8d 53 08             	lea    0x8(%ebx),%edx
80105677:	39 d0                	cmp    %edx,%eax
80105679:	72 15                	jb     80105690 <argint+0x40>
  *ip = *(int*)(addr);
8010567b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010567e:	8b 53 04             	mov    0x4(%ebx),%edx
80105681:	89 10                	mov    %edx,(%eax)
  return 0;
80105683:	31 c0                	xor    %eax,%eax
}
80105685:	5b                   	pop    %ebx
80105686:	5e                   	pop    %esi
80105687:	5d                   	pop    %ebp
80105688:	c3                   	ret    
80105689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105690:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105695:	eb ee                	jmp    80105685 <argint+0x35>
80105697:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010569e:	66 90                	xchg   %ax,%ax

801056a0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801056a0:	55                   	push   %ebp
801056a1:	89 e5                	mov    %esp,%ebp
801056a3:	57                   	push   %edi
801056a4:	56                   	push   %esi
801056a5:	53                   	push   %ebx
801056a6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
801056a9:	e8 72 e5 ff ff       	call   80103c20 <myproc>
801056ae:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801056b0:	e8 6b e5 ff ff       	call   80103c20 <myproc>
801056b5:	8b 55 08             	mov    0x8(%ebp),%edx
801056b8:	8b 40 20             	mov    0x20(%eax),%eax
801056bb:	8b 40 44             	mov    0x44(%eax),%eax
801056be:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801056c1:	e8 5a e5 ff ff       	call   80103c20 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801056c6:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801056c9:	8b 00                	mov    (%eax),%eax
801056cb:	39 c7                	cmp    %eax,%edi
801056cd:	73 31                	jae    80105700 <argptr+0x60>
801056cf:	8d 4b 08             	lea    0x8(%ebx),%ecx
801056d2:	39 c8                	cmp    %ecx,%eax
801056d4:	72 2a                	jb     80105700 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801056d6:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
801056d9:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801056dc:	85 d2                	test   %edx,%edx
801056de:	78 20                	js     80105700 <argptr+0x60>
801056e0:	8b 16                	mov    (%esi),%edx
801056e2:	39 c2                	cmp    %eax,%edx
801056e4:	76 1a                	jbe    80105700 <argptr+0x60>
801056e6:	8b 5d 10             	mov    0x10(%ebp),%ebx
801056e9:	01 c3                	add    %eax,%ebx
801056eb:	39 da                	cmp    %ebx,%edx
801056ed:	72 11                	jb     80105700 <argptr+0x60>
    return -1;
  *pp = (char*)i;
801056ef:	8b 55 0c             	mov    0xc(%ebp),%edx
801056f2:	89 02                	mov    %eax,(%edx)
  return 0;
801056f4:	31 c0                	xor    %eax,%eax
}
801056f6:	83 c4 0c             	add    $0xc,%esp
801056f9:	5b                   	pop    %ebx
801056fa:	5e                   	pop    %esi
801056fb:	5f                   	pop    %edi
801056fc:	5d                   	pop    %ebp
801056fd:	c3                   	ret    
801056fe:	66 90                	xchg   %ax,%ax
    return -1;
80105700:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105705:	eb ef                	jmp    801056f6 <argptr+0x56>
80105707:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010570e:	66 90                	xchg   %ax,%ax

80105710 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105710:	55                   	push   %ebp
80105711:	89 e5                	mov    %esp,%ebp
80105713:	56                   	push   %esi
80105714:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105715:	e8 06 e5 ff ff       	call   80103c20 <myproc>
8010571a:	8b 55 08             	mov    0x8(%ebp),%edx
8010571d:	8b 40 20             	mov    0x20(%eax),%eax
80105720:	8b 40 44             	mov    0x44(%eax),%eax
80105723:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105726:	e8 f5 e4 ff ff       	call   80103c20 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010572b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010572e:	8b 00                	mov    (%eax),%eax
80105730:	39 c6                	cmp    %eax,%esi
80105732:	73 44                	jae    80105778 <argstr+0x68>
80105734:	8d 53 08             	lea    0x8(%ebx),%edx
80105737:	39 d0                	cmp    %edx,%eax
80105739:	72 3d                	jb     80105778 <argstr+0x68>
  *ip = *(int*)(addr);
8010573b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
8010573e:	e8 dd e4 ff ff       	call   80103c20 <myproc>
  if(addr >= curproc->sz)
80105743:	3b 18                	cmp    (%eax),%ebx
80105745:	73 31                	jae    80105778 <argstr+0x68>
  *pp = (char*)addr;
80105747:	8b 55 0c             	mov    0xc(%ebp),%edx
8010574a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010574c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010574e:	39 d3                	cmp    %edx,%ebx
80105750:	73 26                	jae    80105778 <argstr+0x68>
80105752:	89 d8                	mov    %ebx,%eax
80105754:	eb 11                	jmp    80105767 <argstr+0x57>
80105756:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010575d:	8d 76 00             	lea    0x0(%esi),%esi
80105760:	83 c0 01             	add    $0x1,%eax
80105763:	39 c2                	cmp    %eax,%edx
80105765:	76 11                	jbe    80105778 <argstr+0x68>
    if(*s == 0)
80105767:	80 38 00             	cmpb   $0x0,(%eax)
8010576a:	75 f4                	jne    80105760 <argstr+0x50>
      return s - *pp;
8010576c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
8010576e:	5b                   	pop    %ebx
8010576f:	5e                   	pop    %esi
80105770:	5d                   	pop    %ebp
80105771:	c3                   	ret    
80105772:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105778:	5b                   	pop    %ebx
    return -1;
80105779:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010577e:	5e                   	pop    %esi
8010577f:	5d                   	pop    %ebp
80105780:	c3                   	ret    
80105781:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105788:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010578f:	90                   	nop

80105790 <syscall>:
[SYS_threadinfo] sys_threadinfo,
};

void
syscall(void)
{
80105790:	55                   	push   %ebp
80105791:	89 e5                	mov    %esp,%ebp
80105793:	53                   	push   %ebx
80105794:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105797:	e8 84 e4 ff ff       	call   80103c20 <myproc>
8010579c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010579e:	8b 40 20             	mov    0x20(%eax),%eax
801057a1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801057a4:	8d 50 ff             	lea    -0x1(%eax),%edx
801057a7:	83 fa 1b             	cmp    $0x1b,%edx
801057aa:	77 24                	ja     801057d0 <syscall+0x40>
801057ac:	8b 14 85 60 89 10 80 	mov    -0x7fef76a0(,%eax,4),%edx
801057b3:	85 d2                	test   %edx,%edx
801057b5:	74 19                	je     801057d0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
801057b7:	ff d2                	call   *%edx
801057b9:	89 c2                	mov    %eax,%edx
801057bb:	8b 43 20             	mov    0x20(%ebx),%eax
801057be:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801057c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801057c4:	c9                   	leave  
801057c5:	c3                   	ret    
801057c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057cd:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
801057d0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801057d1:	8d 43 74             	lea    0x74(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801057d4:	50                   	push   %eax
801057d5:	ff 73 14             	push   0x14(%ebx)
801057d8:	68 25 89 10 80       	push   $0x80108925
801057dd:	e8 be ae ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
801057e2:	8b 43 20             	mov    0x20(%ebx),%eax
801057e5:	83 c4 10             	add    $0x10,%esp
801057e8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801057ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801057f2:	c9                   	leave  
801057f3:	c3                   	ret    
801057f4:	66 90                	xchg   %ax,%ax
801057f6:	66 90                	xchg   %ax,%ax
801057f8:	66 90                	xchg   %ax,%ax
801057fa:	66 90                	xchg   %ax,%ax
801057fc:	66 90                	xchg   %ax,%ax
801057fe:	66 90                	xchg   %ax,%ax

80105800 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105800:	55                   	push   %ebp
80105801:	89 e5                	mov    %esp,%ebp
80105803:	57                   	push   %edi
80105804:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105805:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80105808:	53                   	push   %ebx
80105809:	83 ec 34             	sub    $0x34,%esp
8010580c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010580f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105812:	57                   	push   %edi
80105813:	50                   	push   %eax
{
80105814:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105817:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010581a:	e8 a1 c8 ff ff       	call   801020c0 <nameiparent>
8010581f:	83 c4 10             	add    $0x10,%esp
80105822:	85 c0                	test   %eax,%eax
80105824:	0f 84 46 01 00 00    	je     80105970 <create+0x170>
    return 0;
  ilock(dp);
8010582a:	83 ec 0c             	sub    $0xc,%esp
8010582d:	89 c3                	mov    %eax,%ebx
8010582f:	50                   	push   %eax
80105830:	e8 4b bf ff ff       	call   80101780 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105835:	83 c4 0c             	add    $0xc,%esp
80105838:	6a 00                	push   $0x0
8010583a:	57                   	push   %edi
8010583b:	53                   	push   %ebx
8010583c:	e8 9f c4 ff ff       	call   80101ce0 <dirlookup>
80105841:	83 c4 10             	add    $0x10,%esp
80105844:	89 c6                	mov    %eax,%esi
80105846:	85 c0                	test   %eax,%eax
80105848:	74 56                	je     801058a0 <create+0xa0>
    iunlockput(dp);
8010584a:	83 ec 0c             	sub    $0xc,%esp
8010584d:	53                   	push   %ebx
8010584e:	e8 bd c1 ff ff       	call   80101a10 <iunlockput>
    ilock(ip);
80105853:	89 34 24             	mov    %esi,(%esp)
80105856:	e8 25 bf ff ff       	call   80101780 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010585b:	83 c4 10             	add    $0x10,%esp
8010585e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105863:	75 1b                	jne    80105880 <create+0x80>
80105865:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010586a:	75 14                	jne    80105880 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010586c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010586f:	89 f0                	mov    %esi,%eax
80105871:	5b                   	pop    %ebx
80105872:	5e                   	pop    %esi
80105873:	5f                   	pop    %edi
80105874:	5d                   	pop    %ebp
80105875:	c3                   	ret    
80105876:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010587d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105880:	83 ec 0c             	sub    $0xc,%esp
80105883:	56                   	push   %esi
    return 0;
80105884:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80105886:	e8 85 c1 ff ff       	call   80101a10 <iunlockput>
    return 0;
8010588b:	83 c4 10             	add    $0x10,%esp
}
8010588e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105891:	89 f0                	mov    %esi,%eax
80105893:	5b                   	pop    %ebx
80105894:	5e                   	pop    %esi
80105895:	5f                   	pop    %edi
80105896:	5d                   	pop    %ebp
80105897:	c3                   	ret    
80105898:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010589f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
801058a0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
801058a4:	83 ec 08             	sub    $0x8,%esp
801058a7:	50                   	push   %eax
801058a8:	ff 33                	push   (%ebx)
801058aa:	e8 61 bd ff ff       	call   80101610 <ialloc>
801058af:	83 c4 10             	add    $0x10,%esp
801058b2:	89 c6                	mov    %eax,%esi
801058b4:	85 c0                	test   %eax,%eax
801058b6:	0f 84 cd 00 00 00    	je     80105989 <create+0x189>
  ilock(ip);
801058bc:	83 ec 0c             	sub    $0xc,%esp
801058bf:	50                   	push   %eax
801058c0:	e8 bb be ff ff       	call   80101780 <ilock>
  ip->major = major;
801058c5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
801058c9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
801058cd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
801058d1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
801058d5:	b8 01 00 00 00       	mov    $0x1,%eax
801058da:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
801058de:	89 34 24             	mov    %esi,(%esp)
801058e1:	e8 ea bd ff ff       	call   801016d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801058e6:	83 c4 10             	add    $0x10,%esp
801058e9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801058ee:	74 30                	je     80105920 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
801058f0:	83 ec 04             	sub    $0x4,%esp
801058f3:	ff 76 04             	push   0x4(%esi)
801058f6:	57                   	push   %edi
801058f7:	53                   	push   %ebx
801058f8:	e8 e3 c6 ff ff       	call   80101fe0 <dirlink>
801058fd:	83 c4 10             	add    $0x10,%esp
80105900:	85 c0                	test   %eax,%eax
80105902:	78 78                	js     8010597c <create+0x17c>
  iunlockput(dp);
80105904:	83 ec 0c             	sub    $0xc,%esp
80105907:	53                   	push   %ebx
80105908:	e8 03 c1 ff ff       	call   80101a10 <iunlockput>
  return ip;
8010590d:	83 c4 10             	add    $0x10,%esp
}
80105910:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105913:	89 f0                	mov    %esi,%eax
80105915:	5b                   	pop    %ebx
80105916:	5e                   	pop    %esi
80105917:	5f                   	pop    %edi
80105918:	5d                   	pop    %ebp
80105919:	c3                   	ret    
8010591a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105920:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105923:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105928:	53                   	push   %ebx
80105929:	e8 a2 bd ff ff       	call   801016d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010592e:	83 c4 0c             	add    $0xc,%esp
80105931:	ff 76 04             	push   0x4(%esi)
80105934:	68 f0 89 10 80       	push   $0x801089f0
80105939:	56                   	push   %esi
8010593a:	e8 a1 c6 ff ff       	call   80101fe0 <dirlink>
8010593f:	83 c4 10             	add    $0x10,%esp
80105942:	85 c0                	test   %eax,%eax
80105944:	78 18                	js     8010595e <create+0x15e>
80105946:	83 ec 04             	sub    $0x4,%esp
80105949:	ff 73 04             	push   0x4(%ebx)
8010594c:	68 ef 89 10 80       	push   $0x801089ef
80105951:	56                   	push   %esi
80105952:	e8 89 c6 ff ff       	call   80101fe0 <dirlink>
80105957:	83 c4 10             	add    $0x10,%esp
8010595a:	85 c0                	test   %eax,%eax
8010595c:	79 92                	jns    801058f0 <create+0xf0>
      panic("create dots");
8010595e:	83 ec 0c             	sub    $0xc,%esp
80105961:	68 e3 89 10 80       	push   $0x801089e3
80105966:	e8 15 aa ff ff       	call   80100380 <panic>
8010596b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010596f:	90                   	nop
}
80105970:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105973:	31 f6                	xor    %esi,%esi
}
80105975:	5b                   	pop    %ebx
80105976:	89 f0                	mov    %esi,%eax
80105978:	5e                   	pop    %esi
80105979:	5f                   	pop    %edi
8010597a:	5d                   	pop    %ebp
8010597b:	c3                   	ret    
    panic("create: dirlink");
8010597c:	83 ec 0c             	sub    $0xc,%esp
8010597f:	68 f2 89 10 80       	push   $0x801089f2
80105984:	e8 f7 a9 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80105989:	83 ec 0c             	sub    $0xc,%esp
8010598c:	68 d4 89 10 80       	push   $0x801089d4
80105991:	e8 ea a9 ff ff       	call   80100380 <panic>
80105996:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010599d:	8d 76 00             	lea    0x0(%esi),%esi

801059a0 <sys_dup>:
{
801059a0:	55                   	push   %ebp
801059a1:	89 e5                	mov    %esp,%ebp
801059a3:	56                   	push   %esi
801059a4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801059a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801059a8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801059ab:	50                   	push   %eax
801059ac:	6a 00                	push   $0x0
801059ae:	e8 9d fc ff ff       	call   80105650 <argint>
801059b3:	83 c4 10             	add    $0x10,%esp
801059b6:	85 c0                	test   %eax,%eax
801059b8:	78 36                	js     801059f0 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801059ba:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801059be:	77 30                	ja     801059f0 <sys_dup+0x50>
801059c0:	e8 5b e2 ff ff       	call   80103c20 <myproc>
801059c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801059c8:	8b 74 90 30          	mov    0x30(%eax,%edx,4),%esi
801059cc:	85 f6                	test   %esi,%esi
801059ce:	74 20                	je     801059f0 <sys_dup+0x50>
  struct proc *curproc = myproc();
801059d0:	e8 4b e2 ff ff       	call   80103c20 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801059d5:	31 db                	xor    %ebx,%ebx
801059d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059de:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
801059e0:	8b 54 98 30          	mov    0x30(%eax,%ebx,4),%edx
801059e4:	85 d2                	test   %edx,%edx
801059e6:	74 18                	je     80105a00 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
801059e8:	83 c3 01             	add    $0x1,%ebx
801059eb:	83 fb 10             	cmp    $0x10,%ebx
801059ee:	75 f0                	jne    801059e0 <sys_dup+0x40>
}
801059f0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801059f3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801059f8:	89 d8                	mov    %ebx,%eax
801059fa:	5b                   	pop    %ebx
801059fb:	5e                   	pop    %esi
801059fc:	5d                   	pop    %ebp
801059fd:	c3                   	ret    
801059fe:	66 90                	xchg   %ax,%ax
  filedup(f);
80105a00:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105a03:	89 74 98 30          	mov    %esi,0x30(%eax,%ebx,4)
  filedup(f);
80105a07:	56                   	push   %esi
80105a08:	e8 93 b4 ff ff       	call   80100ea0 <filedup>
  return fd;
80105a0d:	83 c4 10             	add    $0x10,%esp
}
80105a10:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105a13:	89 d8                	mov    %ebx,%eax
80105a15:	5b                   	pop    %ebx
80105a16:	5e                   	pop    %esi
80105a17:	5d                   	pop    %ebp
80105a18:	c3                   	ret    
80105a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105a20 <sys_read>:
{
80105a20:	55                   	push   %ebp
80105a21:	89 e5                	mov    %esp,%ebp
80105a23:	56                   	push   %esi
80105a24:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105a25:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105a28:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80105a2b:	53                   	push   %ebx
80105a2c:	6a 00                	push   $0x0
80105a2e:	e8 1d fc ff ff       	call   80105650 <argint>
80105a33:	83 c4 10             	add    $0x10,%esp
80105a36:	85 c0                	test   %eax,%eax
80105a38:	78 5e                	js     80105a98 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105a3a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105a3e:	77 58                	ja     80105a98 <sys_read+0x78>
80105a40:	e8 db e1 ff ff       	call   80103c20 <myproc>
80105a45:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105a48:	8b 74 90 30          	mov    0x30(%eax,%edx,4),%esi
80105a4c:	85 f6                	test   %esi,%esi
80105a4e:	74 48                	je     80105a98 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105a50:	83 ec 08             	sub    $0x8,%esp
80105a53:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a56:	50                   	push   %eax
80105a57:	6a 02                	push   $0x2
80105a59:	e8 f2 fb ff ff       	call   80105650 <argint>
80105a5e:	83 c4 10             	add    $0x10,%esp
80105a61:	85 c0                	test   %eax,%eax
80105a63:	78 33                	js     80105a98 <sys_read+0x78>
80105a65:	83 ec 04             	sub    $0x4,%esp
80105a68:	ff 75 f0             	push   -0x10(%ebp)
80105a6b:	53                   	push   %ebx
80105a6c:	6a 01                	push   $0x1
80105a6e:	e8 2d fc ff ff       	call   801056a0 <argptr>
80105a73:	83 c4 10             	add    $0x10,%esp
80105a76:	85 c0                	test   %eax,%eax
80105a78:	78 1e                	js     80105a98 <sys_read+0x78>
  return fileread(f, p, n);
80105a7a:	83 ec 04             	sub    $0x4,%esp
80105a7d:	ff 75 f0             	push   -0x10(%ebp)
80105a80:	ff 75 f4             	push   -0xc(%ebp)
80105a83:	56                   	push   %esi
80105a84:	e8 97 b5 ff ff       	call   80101020 <fileread>
80105a89:	83 c4 10             	add    $0x10,%esp
}
80105a8c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105a8f:	5b                   	pop    %ebx
80105a90:	5e                   	pop    %esi
80105a91:	5d                   	pop    %ebp
80105a92:	c3                   	ret    
80105a93:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a97:	90                   	nop
    return -1;
80105a98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a9d:	eb ed                	jmp    80105a8c <sys_read+0x6c>
80105a9f:	90                   	nop

80105aa0 <sys_write>:
{
80105aa0:	55                   	push   %ebp
80105aa1:	89 e5                	mov    %esp,%ebp
80105aa3:	56                   	push   %esi
80105aa4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105aa5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105aa8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80105aab:	53                   	push   %ebx
80105aac:	6a 00                	push   $0x0
80105aae:	e8 9d fb ff ff       	call   80105650 <argint>
80105ab3:	83 c4 10             	add    $0x10,%esp
80105ab6:	85 c0                	test   %eax,%eax
80105ab8:	78 5e                	js     80105b18 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105aba:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105abe:	77 58                	ja     80105b18 <sys_write+0x78>
80105ac0:	e8 5b e1 ff ff       	call   80103c20 <myproc>
80105ac5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105ac8:	8b 74 90 30          	mov    0x30(%eax,%edx,4),%esi
80105acc:	85 f6                	test   %esi,%esi
80105ace:	74 48                	je     80105b18 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105ad0:	83 ec 08             	sub    $0x8,%esp
80105ad3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ad6:	50                   	push   %eax
80105ad7:	6a 02                	push   $0x2
80105ad9:	e8 72 fb ff ff       	call   80105650 <argint>
80105ade:	83 c4 10             	add    $0x10,%esp
80105ae1:	85 c0                	test   %eax,%eax
80105ae3:	78 33                	js     80105b18 <sys_write+0x78>
80105ae5:	83 ec 04             	sub    $0x4,%esp
80105ae8:	ff 75 f0             	push   -0x10(%ebp)
80105aeb:	53                   	push   %ebx
80105aec:	6a 01                	push   $0x1
80105aee:	e8 ad fb ff ff       	call   801056a0 <argptr>
80105af3:	83 c4 10             	add    $0x10,%esp
80105af6:	85 c0                	test   %eax,%eax
80105af8:	78 1e                	js     80105b18 <sys_write+0x78>
  return filewrite(f, p, n);
80105afa:	83 ec 04             	sub    $0x4,%esp
80105afd:	ff 75 f0             	push   -0x10(%ebp)
80105b00:	ff 75 f4             	push   -0xc(%ebp)
80105b03:	56                   	push   %esi
80105b04:	e8 a7 b5 ff ff       	call   801010b0 <filewrite>
80105b09:	83 c4 10             	add    $0x10,%esp
}
80105b0c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105b0f:	5b                   	pop    %ebx
80105b10:	5e                   	pop    %esi
80105b11:	5d                   	pop    %ebp
80105b12:	c3                   	ret    
80105b13:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b17:	90                   	nop
    return -1;
80105b18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b1d:	eb ed                	jmp    80105b0c <sys_write+0x6c>
80105b1f:	90                   	nop

80105b20 <sys_close>:
{
80105b20:	55                   	push   %ebp
80105b21:	89 e5                	mov    %esp,%ebp
80105b23:	56                   	push   %esi
80105b24:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105b25:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105b28:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80105b2b:	50                   	push   %eax
80105b2c:	6a 00                	push   $0x0
80105b2e:	e8 1d fb ff ff       	call   80105650 <argint>
80105b33:	83 c4 10             	add    $0x10,%esp
80105b36:	85 c0                	test   %eax,%eax
80105b38:	78 3e                	js     80105b78 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105b3a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105b3e:	77 38                	ja     80105b78 <sys_close+0x58>
80105b40:	e8 db e0 ff ff       	call   80103c20 <myproc>
80105b45:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105b48:	8d 5a 0c             	lea    0xc(%edx),%ebx
80105b4b:	8b 34 98             	mov    (%eax,%ebx,4),%esi
80105b4e:	85 f6                	test   %esi,%esi
80105b50:	74 26                	je     80105b78 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105b52:	e8 c9 e0 ff ff       	call   80103c20 <myproc>
  fileclose(f);
80105b57:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105b5a:	c7 04 98 00 00 00 00 	movl   $0x0,(%eax,%ebx,4)
  fileclose(f);
80105b61:	56                   	push   %esi
80105b62:	e8 89 b3 ff ff       	call   80100ef0 <fileclose>
  return 0;
80105b67:	83 c4 10             	add    $0x10,%esp
80105b6a:	31 c0                	xor    %eax,%eax
}
80105b6c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105b6f:	5b                   	pop    %ebx
80105b70:	5e                   	pop    %esi
80105b71:	5d                   	pop    %ebp
80105b72:	c3                   	ret    
80105b73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b77:	90                   	nop
    return -1;
80105b78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b7d:	eb ed                	jmp    80105b6c <sys_close+0x4c>
80105b7f:	90                   	nop

80105b80 <sys_fstat>:
{
80105b80:	55                   	push   %ebp
80105b81:	89 e5                	mov    %esp,%ebp
80105b83:	56                   	push   %esi
80105b84:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105b85:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105b88:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80105b8b:	53                   	push   %ebx
80105b8c:	6a 00                	push   $0x0
80105b8e:	e8 bd fa ff ff       	call   80105650 <argint>
80105b93:	83 c4 10             	add    $0x10,%esp
80105b96:	85 c0                	test   %eax,%eax
80105b98:	78 46                	js     80105be0 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105b9a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105b9e:	77 40                	ja     80105be0 <sys_fstat+0x60>
80105ba0:	e8 7b e0 ff ff       	call   80103c20 <myproc>
80105ba5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105ba8:	8b 74 90 30          	mov    0x30(%eax,%edx,4),%esi
80105bac:	85 f6                	test   %esi,%esi
80105bae:	74 30                	je     80105be0 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105bb0:	83 ec 04             	sub    $0x4,%esp
80105bb3:	6a 14                	push   $0x14
80105bb5:	53                   	push   %ebx
80105bb6:	6a 01                	push   $0x1
80105bb8:	e8 e3 fa ff ff       	call   801056a0 <argptr>
80105bbd:	83 c4 10             	add    $0x10,%esp
80105bc0:	85 c0                	test   %eax,%eax
80105bc2:	78 1c                	js     80105be0 <sys_fstat+0x60>
  return filestat(f, st);
80105bc4:	83 ec 08             	sub    $0x8,%esp
80105bc7:	ff 75 f4             	push   -0xc(%ebp)
80105bca:	56                   	push   %esi
80105bcb:	e8 00 b4 ff ff       	call   80100fd0 <filestat>
80105bd0:	83 c4 10             	add    $0x10,%esp
}
80105bd3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105bd6:	5b                   	pop    %ebx
80105bd7:	5e                   	pop    %esi
80105bd8:	5d                   	pop    %ebp
80105bd9:	c3                   	ret    
80105bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105be0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105be5:	eb ec                	jmp    80105bd3 <sys_fstat+0x53>
80105be7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bee:	66 90                	xchg   %ax,%ax

80105bf0 <sys_link>:
{
80105bf0:	55                   	push   %ebp
80105bf1:	89 e5                	mov    %esp,%ebp
80105bf3:	57                   	push   %edi
80105bf4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105bf5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105bf8:	53                   	push   %ebx
80105bf9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105bfc:	50                   	push   %eax
80105bfd:	6a 00                	push   $0x0
80105bff:	e8 0c fb ff ff       	call   80105710 <argstr>
80105c04:	83 c4 10             	add    $0x10,%esp
80105c07:	85 c0                	test   %eax,%eax
80105c09:	0f 88 fb 00 00 00    	js     80105d0a <sys_link+0x11a>
80105c0f:	83 ec 08             	sub    $0x8,%esp
80105c12:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105c15:	50                   	push   %eax
80105c16:	6a 01                	push   $0x1
80105c18:	e8 f3 fa ff ff       	call   80105710 <argstr>
80105c1d:	83 c4 10             	add    $0x10,%esp
80105c20:	85 c0                	test   %eax,%eax
80105c22:	0f 88 e2 00 00 00    	js     80105d0a <sys_link+0x11a>
  begin_op();
80105c28:	e8 33 d1 ff ff       	call   80102d60 <begin_op>
  if((ip = namei(old)) == 0){
80105c2d:	83 ec 0c             	sub    $0xc,%esp
80105c30:	ff 75 d4             	push   -0x2c(%ebp)
80105c33:	e8 68 c4 ff ff       	call   801020a0 <namei>
80105c38:	83 c4 10             	add    $0x10,%esp
80105c3b:	89 c3                	mov    %eax,%ebx
80105c3d:	85 c0                	test   %eax,%eax
80105c3f:	0f 84 e4 00 00 00    	je     80105d29 <sys_link+0x139>
  ilock(ip);
80105c45:	83 ec 0c             	sub    $0xc,%esp
80105c48:	50                   	push   %eax
80105c49:	e8 32 bb ff ff       	call   80101780 <ilock>
  if(ip->type == T_DIR){
80105c4e:	83 c4 10             	add    $0x10,%esp
80105c51:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105c56:	0f 84 b5 00 00 00    	je     80105d11 <sys_link+0x121>
  iupdate(ip);
80105c5c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80105c5f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105c64:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105c67:	53                   	push   %ebx
80105c68:	e8 63 ba ff ff       	call   801016d0 <iupdate>
  iunlock(ip);
80105c6d:	89 1c 24             	mov    %ebx,(%esp)
80105c70:	e8 eb bb ff ff       	call   80101860 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105c75:	58                   	pop    %eax
80105c76:	5a                   	pop    %edx
80105c77:	57                   	push   %edi
80105c78:	ff 75 d0             	push   -0x30(%ebp)
80105c7b:	e8 40 c4 ff ff       	call   801020c0 <nameiparent>
80105c80:	83 c4 10             	add    $0x10,%esp
80105c83:	89 c6                	mov    %eax,%esi
80105c85:	85 c0                	test   %eax,%eax
80105c87:	74 5b                	je     80105ce4 <sys_link+0xf4>
  ilock(dp);
80105c89:	83 ec 0c             	sub    $0xc,%esp
80105c8c:	50                   	push   %eax
80105c8d:	e8 ee ba ff ff       	call   80101780 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105c92:	8b 03                	mov    (%ebx),%eax
80105c94:	83 c4 10             	add    $0x10,%esp
80105c97:	39 06                	cmp    %eax,(%esi)
80105c99:	75 3d                	jne    80105cd8 <sys_link+0xe8>
80105c9b:	83 ec 04             	sub    $0x4,%esp
80105c9e:	ff 73 04             	push   0x4(%ebx)
80105ca1:	57                   	push   %edi
80105ca2:	56                   	push   %esi
80105ca3:	e8 38 c3 ff ff       	call   80101fe0 <dirlink>
80105ca8:	83 c4 10             	add    $0x10,%esp
80105cab:	85 c0                	test   %eax,%eax
80105cad:	78 29                	js     80105cd8 <sys_link+0xe8>
  iunlockput(dp);
80105caf:	83 ec 0c             	sub    $0xc,%esp
80105cb2:	56                   	push   %esi
80105cb3:	e8 58 bd ff ff       	call   80101a10 <iunlockput>
  iput(ip);
80105cb8:	89 1c 24             	mov    %ebx,(%esp)
80105cbb:	e8 f0 bb ff ff       	call   801018b0 <iput>
  end_op();
80105cc0:	e8 0b d1 ff ff       	call   80102dd0 <end_op>
  return 0;
80105cc5:	83 c4 10             	add    $0x10,%esp
80105cc8:	31 c0                	xor    %eax,%eax
}
80105cca:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ccd:	5b                   	pop    %ebx
80105cce:	5e                   	pop    %esi
80105ccf:	5f                   	pop    %edi
80105cd0:	5d                   	pop    %ebp
80105cd1:	c3                   	ret    
80105cd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105cd8:	83 ec 0c             	sub    $0xc,%esp
80105cdb:	56                   	push   %esi
80105cdc:	e8 2f bd ff ff       	call   80101a10 <iunlockput>
    goto bad;
80105ce1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105ce4:	83 ec 0c             	sub    $0xc,%esp
80105ce7:	53                   	push   %ebx
80105ce8:	e8 93 ba ff ff       	call   80101780 <ilock>
  ip->nlink--;
80105ced:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105cf2:	89 1c 24             	mov    %ebx,(%esp)
80105cf5:	e8 d6 b9 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
80105cfa:	89 1c 24             	mov    %ebx,(%esp)
80105cfd:	e8 0e bd ff ff       	call   80101a10 <iunlockput>
  end_op();
80105d02:	e8 c9 d0 ff ff       	call   80102dd0 <end_op>
  return -1;
80105d07:	83 c4 10             	add    $0x10,%esp
80105d0a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d0f:	eb b9                	jmp    80105cca <sys_link+0xda>
    iunlockput(ip);
80105d11:	83 ec 0c             	sub    $0xc,%esp
80105d14:	53                   	push   %ebx
80105d15:	e8 f6 bc ff ff       	call   80101a10 <iunlockput>
    end_op();
80105d1a:	e8 b1 d0 ff ff       	call   80102dd0 <end_op>
    return -1;
80105d1f:	83 c4 10             	add    $0x10,%esp
80105d22:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d27:	eb a1                	jmp    80105cca <sys_link+0xda>
    end_op();
80105d29:	e8 a2 d0 ff ff       	call   80102dd0 <end_op>
    return -1;
80105d2e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d33:	eb 95                	jmp    80105cca <sys_link+0xda>
80105d35:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d40 <sys_unlink>:
{
80105d40:	55                   	push   %ebp
80105d41:	89 e5                	mov    %esp,%ebp
80105d43:	57                   	push   %edi
80105d44:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105d45:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105d48:	53                   	push   %ebx
80105d49:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80105d4c:	50                   	push   %eax
80105d4d:	6a 00                	push   $0x0
80105d4f:	e8 bc f9 ff ff       	call   80105710 <argstr>
80105d54:	83 c4 10             	add    $0x10,%esp
80105d57:	85 c0                	test   %eax,%eax
80105d59:	0f 88 7a 01 00 00    	js     80105ed9 <sys_unlink+0x199>
  begin_op();
80105d5f:	e8 fc cf ff ff       	call   80102d60 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105d64:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105d67:	83 ec 08             	sub    $0x8,%esp
80105d6a:	53                   	push   %ebx
80105d6b:	ff 75 c0             	push   -0x40(%ebp)
80105d6e:	e8 4d c3 ff ff       	call   801020c0 <nameiparent>
80105d73:	83 c4 10             	add    $0x10,%esp
80105d76:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105d79:	85 c0                	test   %eax,%eax
80105d7b:	0f 84 62 01 00 00    	je     80105ee3 <sys_unlink+0x1a3>
  ilock(dp);
80105d81:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105d84:	83 ec 0c             	sub    $0xc,%esp
80105d87:	57                   	push   %edi
80105d88:	e8 f3 b9 ff ff       	call   80101780 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105d8d:	58                   	pop    %eax
80105d8e:	5a                   	pop    %edx
80105d8f:	68 f0 89 10 80       	push   $0x801089f0
80105d94:	53                   	push   %ebx
80105d95:	e8 26 bf ff ff       	call   80101cc0 <namecmp>
80105d9a:	83 c4 10             	add    $0x10,%esp
80105d9d:	85 c0                	test   %eax,%eax
80105d9f:	0f 84 fb 00 00 00    	je     80105ea0 <sys_unlink+0x160>
80105da5:	83 ec 08             	sub    $0x8,%esp
80105da8:	68 ef 89 10 80       	push   $0x801089ef
80105dad:	53                   	push   %ebx
80105dae:	e8 0d bf ff ff       	call   80101cc0 <namecmp>
80105db3:	83 c4 10             	add    $0x10,%esp
80105db6:	85 c0                	test   %eax,%eax
80105db8:	0f 84 e2 00 00 00    	je     80105ea0 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
80105dbe:	83 ec 04             	sub    $0x4,%esp
80105dc1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105dc4:	50                   	push   %eax
80105dc5:	53                   	push   %ebx
80105dc6:	57                   	push   %edi
80105dc7:	e8 14 bf ff ff       	call   80101ce0 <dirlookup>
80105dcc:	83 c4 10             	add    $0x10,%esp
80105dcf:	89 c3                	mov    %eax,%ebx
80105dd1:	85 c0                	test   %eax,%eax
80105dd3:	0f 84 c7 00 00 00    	je     80105ea0 <sys_unlink+0x160>
  ilock(ip);
80105dd9:	83 ec 0c             	sub    $0xc,%esp
80105ddc:	50                   	push   %eax
80105ddd:	e8 9e b9 ff ff       	call   80101780 <ilock>
  if(ip->nlink < 1)
80105de2:	83 c4 10             	add    $0x10,%esp
80105de5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105dea:	0f 8e 1c 01 00 00    	jle    80105f0c <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105df0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105df5:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105df8:	74 66                	je     80105e60 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105dfa:	83 ec 04             	sub    $0x4,%esp
80105dfd:	6a 10                	push   $0x10
80105dff:	6a 00                	push   $0x0
80105e01:	57                   	push   %edi
80105e02:	e8 89 f5 ff ff       	call   80105390 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105e07:	6a 10                	push   $0x10
80105e09:	ff 75 c4             	push   -0x3c(%ebp)
80105e0c:	57                   	push   %edi
80105e0d:	ff 75 b4             	push   -0x4c(%ebp)
80105e10:	e8 7b bd ff ff       	call   80101b90 <writei>
80105e15:	83 c4 20             	add    $0x20,%esp
80105e18:	83 f8 10             	cmp    $0x10,%eax
80105e1b:	0f 85 de 00 00 00    	jne    80105eff <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
80105e21:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105e26:	0f 84 94 00 00 00    	je     80105ec0 <sys_unlink+0x180>
  iunlockput(dp);
80105e2c:	83 ec 0c             	sub    $0xc,%esp
80105e2f:	ff 75 b4             	push   -0x4c(%ebp)
80105e32:	e8 d9 bb ff ff       	call   80101a10 <iunlockput>
  ip->nlink--;
80105e37:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105e3c:	89 1c 24             	mov    %ebx,(%esp)
80105e3f:	e8 8c b8 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
80105e44:	89 1c 24             	mov    %ebx,(%esp)
80105e47:	e8 c4 bb ff ff       	call   80101a10 <iunlockput>
  end_op();
80105e4c:	e8 7f cf ff ff       	call   80102dd0 <end_op>
  return 0;
80105e51:	83 c4 10             	add    $0x10,%esp
80105e54:	31 c0                	xor    %eax,%eax
}
80105e56:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e59:	5b                   	pop    %ebx
80105e5a:	5e                   	pop    %esi
80105e5b:	5f                   	pop    %edi
80105e5c:	5d                   	pop    %ebp
80105e5d:	c3                   	ret    
80105e5e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105e60:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105e64:	76 94                	jbe    80105dfa <sys_unlink+0xba>
80105e66:	be 20 00 00 00       	mov    $0x20,%esi
80105e6b:	eb 0b                	jmp    80105e78 <sys_unlink+0x138>
80105e6d:	8d 76 00             	lea    0x0(%esi),%esi
80105e70:	83 c6 10             	add    $0x10,%esi
80105e73:	3b 73 58             	cmp    0x58(%ebx),%esi
80105e76:	73 82                	jae    80105dfa <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105e78:	6a 10                	push   $0x10
80105e7a:	56                   	push   %esi
80105e7b:	57                   	push   %edi
80105e7c:	53                   	push   %ebx
80105e7d:	e8 0e bc ff ff       	call   80101a90 <readi>
80105e82:	83 c4 10             	add    $0x10,%esp
80105e85:	83 f8 10             	cmp    $0x10,%eax
80105e88:	75 68                	jne    80105ef2 <sys_unlink+0x1b2>
    if(de.inum != 0)
80105e8a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105e8f:	74 df                	je     80105e70 <sys_unlink+0x130>
    iunlockput(ip);
80105e91:	83 ec 0c             	sub    $0xc,%esp
80105e94:	53                   	push   %ebx
80105e95:	e8 76 bb ff ff       	call   80101a10 <iunlockput>
    goto bad;
80105e9a:	83 c4 10             	add    $0x10,%esp
80105e9d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105ea0:	83 ec 0c             	sub    $0xc,%esp
80105ea3:	ff 75 b4             	push   -0x4c(%ebp)
80105ea6:	e8 65 bb ff ff       	call   80101a10 <iunlockput>
  end_op();
80105eab:	e8 20 cf ff ff       	call   80102dd0 <end_op>
  return -1;
80105eb0:	83 c4 10             	add    $0x10,%esp
80105eb3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105eb8:	eb 9c                	jmp    80105e56 <sys_unlink+0x116>
80105eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105ec0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105ec3:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105ec6:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80105ecb:	50                   	push   %eax
80105ecc:	e8 ff b7 ff ff       	call   801016d0 <iupdate>
80105ed1:	83 c4 10             	add    $0x10,%esp
80105ed4:	e9 53 ff ff ff       	jmp    80105e2c <sys_unlink+0xec>
    return -1;
80105ed9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ede:	e9 73 ff ff ff       	jmp    80105e56 <sys_unlink+0x116>
    end_op();
80105ee3:	e8 e8 ce ff ff       	call   80102dd0 <end_op>
    return -1;
80105ee8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105eed:	e9 64 ff ff ff       	jmp    80105e56 <sys_unlink+0x116>
      panic("isdirempty: readi");
80105ef2:	83 ec 0c             	sub    $0xc,%esp
80105ef5:	68 14 8a 10 80       	push   $0x80108a14
80105efa:	e8 81 a4 ff ff       	call   80100380 <panic>
    panic("unlink: writei");
80105eff:	83 ec 0c             	sub    $0xc,%esp
80105f02:	68 26 8a 10 80       	push   $0x80108a26
80105f07:	e8 74 a4 ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
80105f0c:	83 ec 0c             	sub    $0xc,%esp
80105f0f:	68 02 8a 10 80       	push   $0x80108a02
80105f14:	e8 67 a4 ff ff       	call   80100380 <panic>
80105f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f20 <sys_open>:

int
sys_open(void)
{
80105f20:	55                   	push   %ebp
80105f21:	89 e5                	mov    %esp,%ebp
80105f23:	57                   	push   %edi
80105f24:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105f25:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105f28:	53                   	push   %ebx
80105f29:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105f2c:	50                   	push   %eax
80105f2d:	6a 00                	push   $0x0
80105f2f:	e8 dc f7 ff ff       	call   80105710 <argstr>
80105f34:	83 c4 10             	add    $0x10,%esp
80105f37:	85 c0                	test   %eax,%eax
80105f39:	0f 88 8e 00 00 00    	js     80105fcd <sys_open+0xad>
80105f3f:	83 ec 08             	sub    $0x8,%esp
80105f42:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105f45:	50                   	push   %eax
80105f46:	6a 01                	push   $0x1
80105f48:	e8 03 f7 ff ff       	call   80105650 <argint>
80105f4d:	83 c4 10             	add    $0x10,%esp
80105f50:	85 c0                	test   %eax,%eax
80105f52:	78 79                	js     80105fcd <sys_open+0xad>
    return -1;

  begin_op();
80105f54:	e8 07 ce ff ff       	call   80102d60 <begin_op>

  if(omode & O_CREATE){
80105f59:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105f5d:	75 79                	jne    80105fd8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105f5f:	83 ec 0c             	sub    $0xc,%esp
80105f62:	ff 75 e0             	push   -0x20(%ebp)
80105f65:	e8 36 c1 ff ff       	call   801020a0 <namei>
80105f6a:	83 c4 10             	add    $0x10,%esp
80105f6d:	89 c6                	mov    %eax,%esi
80105f6f:	85 c0                	test   %eax,%eax
80105f71:	0f 84 7e 00 00 00    	je     80105ff5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105f77:	83 ec 0c             	sub    $0xc,%esp
80105f7a:	50                   	push   %eax
80105f7b:	e8 00 b8 ff ff       	call   80101780 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105f80:	83 c4 10             	add    $0x10,%esp
80105f83:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105f88:	0f 84 c2 00 00 00    	je     80106050 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105f8e:	e8 9d ae ff ff       	call   80100e30 <filealloc>
80105f93:	89 c7                	mov    %eax,%edi
80105f95:	85 c0                	test   %eax,%eax
80105f97:	74 23                	je     80105fbc <sys_open+0x9c>
  struct proc *curproc = myproc();
80105f99:	e8 82 dc ff ff       	call   80103c20 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105f9e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105fa0:	8b 54 98 30          	mov    0x30(%eax,%ebx,4),%edx
80105fa4:	85 d2                	test   %edx,%edx
80105fa6:	74 60                	je     80106008 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105fa8:	83 c3 01             	add    $0x1,%ebx
80105fab:	83 fb 10             	cmp    $0x10,%ebx
80105fae:	75 f0                	jne    80105fa0 <sys_open+0x80>
    if(f)
      fileclose(f);
80105fb0:	83 ec 0c             	sub    $0xc,%esp
80105fb3:	57                   	push   %edi
80105fb4:	e8 37 af ff ff       	call   80100ef0 <fileclose>
80105fb9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105fbc:	83 ec 0c             	sub    $0xc,%esp
80105fbf:	56                   	push   %esi
80105fc0:	e8 4b ba ff ff       	call   80101a10 <iunlockput>
    end_op();
80105fc5:	e8 06 ce ff ff       	call   80102dd0 <end_op>
    return -1;
80105fca:	83 c4 10             	add    $0x10,%esp
80105fcd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105fd2:	eb 6d                	jmp    80106041 <sys_open+0x121>
80105fd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105fd8:	83 ec 0c             	sub    $0xc,%esp
80105fdb:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105fde:	31 c9                	xor    %ecx,%ecx
80105fe0:	ba 02 00 00 00       	mov    $0x2,%edx
80105fe5:	6a 00                	push   $0x0
80105fe7:	e8 14 f8 ff ff       	call   80105800 <create>
    if(ip == 0){
80105fec:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105fef:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105ff1:	85 c0                	test   %eax,%eax
80105ff3:	75 99                	jne    80105f8e <sys_open+0x6e>
      end_op();
80105ff5:	e8 d6 cd ff ff       	call   80102dd0 <end_op>
      return -1;
80105ffa:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105fff:	eb 40                	jmp    80106041 <sys_open+0x121>
80106001:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80106008:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010600b:	89 7c 98 30          	mov    %edi,0x30(%eax,%ebx,4)
  iunlock(ip);
8010600f:	56                   	push   %esi
80106010:	e8 4b b8 ff ff       	call   80101860 <iunlock>
  end_op();
80106015:	e8 b6 cd ff ff       	call   80102dd0 <end_op>

  f->type = FD_INODE;
8010601a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80106020:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106023:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80106026:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80106029:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010602b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80106032:	f7 d0                	not    %eax
80106034:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106037:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010603a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010603d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80106041:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106044:	89 d8                	mov    %ebx,%eax
80106046:	5b                   	pop    %ebx
80106047:	5e                   	pop    %esi
80106048:	5f                   	pop    %edi
80106049:	5d                   	pop    %ebp
8010604a:	c3                   	ret    
8010604b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010604f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80106050:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106053:	85 c9                	test   %ecx,%ecx
80106055:	0f 84 33 ff ff ff    	je     80105f8e <sys_open+0x6e>
8010605b:	e9 5c ff ff ff       	jmp    80105fbc <sys_open+0x9c>

80106060 <sys_mkdir>:

int
sys_mkdir(void)
{
80106060:	55                   	push   %ebp
80106061:	89 e5                	mov    %esp,%ebp
80106063:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106066:	e8 f5 cc ff ff       	call   80102d60 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010606b:	83 ec 08             	sub    $0x8,%esp
8010606e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106071:	50                   	push   %eax
80106072:	6a 00                	push   $0x0
80106074:	e8 97 f6 ff ff       	call   80105710 <argstr>
80106079:	83 c4 10             	add    $0x10,%esp
8010607c:	85 c0                	test   %eax,%eax
8010607e:	78 30                	js     801060b0 <sys_mkdir+0x50>
80106080:	83 ec 0c             	sub    $0xc,%esp
80106083:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106086:	31 c9                	xor    %ecx,%ecx
80106088:	ba 01 00 00 00       	mov    $0x1,%edx
8010608d:	6a 00                	push   $0x0
8010608f:	e8 6c f7 ff ff       	call   80105800 <create>
80106094:	83 c4 10             	add    $0x10,%esp
80106097:	85 c0                	test   %eax,%eax
80106099:	74 15                	je     801060b0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010609b:	83 ec 0c             	sub    $0xc,%esp
8010609e:	50                   	push   %eax
8010609f:	e8 6c b9 ff ff       	call   80101a10 <iunlockput>
  end_op();
801060a4:	e8 27 cd ff ff       	call   80102dd0 <end_op>
  return 0;
801060a9:	83 c4 10             	add    $0x10,%esp
801060ac:	31 c0                	xor    %eax,%eax
}
801060ae:	c9                   	leave  
801060af:	c3                   	ret    
    end_op();
801060b0:	e8 1b cd ff ff       	call   80102dd0 <end_op>
    return -1;
801060b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801060ba:	c9                   	leave  
801060bb:	c3                   	ret    
801060bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801060c0 <sys_mknod>:

int
sys_mknod(void)
{
801060c0:	55                   	push   %ebp
801060c1:	89 e5                	mov    %esp,%ebp
801060c3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801060c6:	e8 95 cc ff ff       	call   80102d60 <begin_op>
  if((argstr(0, &path)) < 0 ||
801060cb:	83 ec 08             	sub    $0x8,%esp
801060ce:	8d 45 ec             	lea    -0x14(%ebp),%eax
801060d1:	50                   	push   %eax
801060d2:	6a 00                	push   $0x0
801060d4:	e8 37 f6 ff ff       	call   80105710 <argstr>
801060d9:	83 c4 10             	add    $0x10,%esp
801060dc:	85 c0                	test   %eax,%eax
801060de:	78 60                	js     80106140 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801060e0:	83 ec 08             	sub    $0x8,%esp
801060e3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801060e6:	50                   	push   %eax
801060e7:	6a 01                	push   $0x1
801060e9:	e8 62 f5 ff ff       	call   80105650 <argint>
  if((argstr(0, &path)) < 0 ||
801060ee:	83 c4 10             	add    $0x10,%esp
801060f1:	85 c0                	test   %eax,%eax
801060f3:	78 4b                	js     80106140 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801060f5:	83 ec 08             	sub    $0x8,%esp
801060f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801060fb:	50                   	push   %eax
801060fc:	6a 02                	push   $0x2
801060fe:	e8 4d f5 ff ff       	call   80105650 <argint>
     argint(1, &major) < 0 ||
80106103:	83 c4 10             	add    $0x10,%esp
80106106:	85 c0                	test   %eax,%eax
80106108:	78 36                	js     80106140 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010610a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010610e:	83 ec 0c             	sub    $0xc,%esp
80106111:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80106115:	ba 03 00 00 00       	mov    $0x3,%edx
8010611a:	50                   	push   %eax
8010611b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010611e:	e8 dd f6 ff ff       	call   80105800 <create>
     argint(2, &minor) < 0 ||
80106123:	83 c4 10             	add    $0x10,%esp
80106126:	85 c0                	test   %eax,%eax
80106128:	74 16                	je     80106140 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010612a:	83 ec 0c             	sub    $0xc,%esp
8010612d:	50                   	push   %eax
8010612e:	e8 dd b8 ff ff       	call   80101a10 <iunlockput>
  end_op();
80106133:	e8 98 cc ff ff       	call   80102dd0 <end_op>
  return 0;
80106138:	83 c4 10             	add    $0x10,%esp
8010613b:	31 c0                	xor    %eax,%eax
}
8010613d:	c9                   	leave  
8010613e:	c3                   	ret    
8010613f:	90                   	nop
    end_op();
80106140:	e8 8b cc ff ff       	call   80102dd0 <end_op>
    return -1;
80106145:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010614a:	c9                   	leave  
8010614b:	c3                   	ret    
8010614c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106150 <sys_chdir>:

int
sys_chdir(void)
{
80106150:	55                   	push   %ebp
80106151:	89 e5                	mov    %esp,%ebp
80106153:	56                   	push   %esi
80106154:	53                   	push   %ebx
80106155:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80106158:	e8 c3 da ff ff       	call   80103c20 <myproc>
8010615d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010615f:	e8 fc cb ff ff       	call   80102d60 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106164:	83 ec 08             	sub    $0x8,%esp
80106167:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010616a:	50                   	push   %eax
8010616b:	6a 00                	push   $0x0
8010616d:	e8 9e f5 ff ff       	call   80105710 <argstr>
80106172:	83 c4 10             	add    $0x10,%esp
80106175:	85 c0                	test   %eax,%eax
80106177:	78 77                	js     801061f0 <sys_chdir+0xa0>
80106179:	83 ec 0c             	sub    $0xc,%esp
8010617c:	ff 75 f4             	push   -0xc(%ebp)
8010617f:	e8 1c bf ff ff       	call   801020a0 <namei>
80106184:	83 c4 10             	add    $0x10,%esp
80106187:	89 c3                	mov    %eax,%ebx
80106189:	85 c0                	test   %eax,%eax
8010618b:	74 63                	je     801061f0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010618d:	83 ec 0c             	sub    $0xc,%esp
80106190:	50                   	push   %eax
80106191:	e8 ea b5 ff ff       	call   80101780 <ilock>
  if(ip->type != T_DIR){
80106196:	83 c4 10             	add    $0x10,%esp
80106199:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010619e:	75 30                	jne    801061d0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801061a0:	83 ec 0c             	sub    $0xc,%esp
801061a3:	53                   	push   %ebx
801061a4:	e8 b7 b6 ff ff       	call   80101860 <iunlock>
  iput(curproc->cwd);
801061a9:	58                   	pop    %eax
801061aa:	ff 76 70             	push   0x70(%esi)
801061ad:	e8 fe b6 ff ff       	call   801018b0 <iput>
  end_op();
801061b2:	e8 19 cc ff ff       	call   80102dd0 <end_op>
  curproc->cwd = ip;
801061b7:	89 5e 70             	mov    %ebx,0x70(%esi)
  return 0;
801061ba:	83 c4 10             	add    $0x10,%esp
801061bd:	31 c0                	xor    %eax,%eax
}
801061bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801061c2:	5b                   	pop    %ebx
801061c3:	5e                   	pop    %esi
801061c4:	5d                   	pop    %ebp
801061c5:	c3                   	ret    
801061c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061cd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801061d0:	83 ec 0c             	sub    $0xc,%esp
801061d3:	53                   	push   %ebx
801061d4:	e8 37 b8 ff ff       	call   80101a10 <iunlockput>
    end_op();
801061d9:	e8 f2 cb ff ff       	call   80102dd0 <end_op>
    return -1;
801061de:	83 c4 10             	add    $0x10,%esp
801061e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061e6:	eb d7                	jmp    801061bf <sys_chdir+0x6f>
801061e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061ef:	90                   	nop
    end_op();
801061f0:	e8 db cb ff ff       	call   80102dd0 <end_op>
    return -1;
801061f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061fa:	eb c3                	jmp    801061bf <sys_chdir+0x6f>
801061fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106200 <sys_exec>:

int
sys_exec(void)
{
80106200:	55                   	push   %ebp
80106201:	89 e5                	mov    %esp,%ebp
80106203:	57                   	push   %edi
80106204:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106205:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010620b:	53                   	push   %ebx
8010620c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106212:	50                   	push   %eax
80106213:	6a 00                	push   $0x0
80106215:	e8 f6 f4 ff ff       	call   80105710 <argstr>
8010621a:	83 c4 10             	add    $0x10,%esp
8010621d:	85 c0                	test   %eax,%eax
8010621f:	0f 88 87 00 00 00    	js     801062ac <sys_exec+0xac>
80106225:	83 ec 08             	sub    $0x8,%esp
80106228:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010622e:	50                   	push   %eax
8010622f:	6a 01                	push   $0x1
80106231:	e8 1a f4 ff ff       	call   80105650 <argint>
80106236:	83 c4 10             	add    $0x10,%esp
80106239:	85 c0                	test   %eax,%eax
8010623b:	78 6f                	js     801062ac <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010623d:	83 ec 04             	sub    $0x4,%esp
80106240:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80106246:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80106248:	68 80 00 00 00       	push   $0x80
8010624d:	6a 00                	push   $0x0
8010624f:	56                   	push   %esi
80106250:	e8 3b f1 ff ff       	call   80105390 <memset>
80106255:	83 c4 10             	add    $0x10,%esp
80106258:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010625f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106260:	83 ec 08             	sub    $0x8,%esp
80106263:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80106269:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80106270:	50                   	push   %eax
80106271:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80106277:	01 f8                	add    %edi,%eax
80106279:	50                   	push   %eax
8010627a:	e8 41 f3 ff ff       	call   801055c0 <fetchint>
8010627f:	83 c4 10             	add    $0x10,%esp
80106282:	85 c0                	test   %eax,%eax
80106284:	78 26                	js     801062ac <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80106286:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010628c:	85 c0                	test   %eax,%eax
8010628e:	74 30                	je     801062c0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80106290:	83 ec 08             	sub    $0x8,%esp
80106293:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80106296:	52                   	push   %edx
80106297:	50                   	push   %eax
80106298:	e8 63 f3 ff ff       	call   80105600 <fetchstr>
8010629d:	83 c4 10             	add    $0x10,%esp
801062a0:	85 c0                	test   %eax,%eax
801062a2:	78 08                	js     801062ac <sys_exec+0xac>
  for(i=0;; i++){
801062a4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801062a7:	83 fb 20             	cmp    $0x20,%ebx
801062aa:	75 b4                	jne    80106260 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801062ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801062af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801062b4:	5b                   	pop    %ebx
801062b5:	5e                   	pop    %esi
801062b6:	5f                   	pop    %edi
801062b7:	5d                   	pop    %ebp
801062b8:	c3                   	ret    
801062b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
801062c0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801062c7:	00 00 00 00 
  return exec(path, argv);
801062cb:	83 ec 08             	sub    $0x8,%esp
801062ce:	56                   	push   %esi
801062cf:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
801062d5:	e8 d6 a7 ff ff       	call   80100ab0 <exec>
801062da:	83 c4 10             	add    $0x10,%esp
}
801062dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062e0:	5b                   	pop    %ebx
801062e1:	5e                   	pop    %esi
801062e2:	5f                   	pop    %edi
801062e3:	5d                   	pop    %ebp
801062e4:	c3                   	ret    
801062e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801062ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801062f0 <sys_pipe>:

int
sys_pipe(void)
{
801062f0:	55                   	push   %ebp
801062f1:	89 e5                	mov    %esp,%ebp
801062f3:	57                   	push   %edi
801062f4:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801062f5:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801062f8:	53                   	push   %ebx
801062f9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801062fc:	6a 08                	push   $0x8
801062fe:	50                   	push   %eax
801062ff:	6a 00                	push   $0x0
80106301:	e8 9a f3 ff ff       	call   801056a0 <argptr>
80106306:	83 c4 10             	add    $0x10,%esp
80106309:	85 c0                	test   %eax,%eax
8010630b:	78 4a                	js     80106357 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010630d:	83 ec 08             	sub    $0x8,%esp
80106310:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106313:	50                   	push   %eax
80106314:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106317:	50                   	push   %eax
80106318:	e8 13 d1 ff ff       	call   80103430 <pipealloc>
8010631d:	83 c4 10             	add    $0x10,%esp
80106320:	85 c0                	test   %eax,%eax
80106322:	78 33                	js     80106357 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106324:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80106327:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80106329:	e8 f2 d8 ff ff       	call   80103c20 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010632e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80106330:	8b 74 98 30          	mov    0x30(%eax,%ebx,4),%esi
80106334:	85 f6                	test   %esi,%esi
80106336:	74 28                	je     80106360 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80106338:	83 c3 01             	add    $0x1,%ebx
8010633b:	83 fb 10             	cmp    $0x10,%ebx
8010633e:	75 f0                	jne    80106330 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80106340:	83 ec 0c             	sub    $0xc,%esp
80106343:	ff 75 e0             	push   -0x20(%ebp)
80106346:	e8 a5 ab ff ff       	call   80100ef0 <fileclose>
    fileclose(wf);
8010634b:	58                   	pop    %eax
8010634c:	ff 75 e4             	push   -0x1c(%ebp)
8010634f:	e8 9c ab ff ff       	call   80100ef0 <fileclose>
    return -1;
80106354:	83 c4 10             	add    $0x10,%esp
80106357:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010635c:	eb 43                	jmp    801063a1 <sys_pipe+0xb1>
8010635e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80106360:	8d 73 0c             	lea    0xc(%ebx),%esi
80106363:	89 3c b0             	mov    %edi,(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106366:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80106369:	e8 b2 d8 ff ff       	call   80103c20 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010636e:	31 d2                	xor    %edx,%edx
    if(curproc->ofile[fd] == 0){
80106370:	8b 4c 90 30          	mov    0x30(%eax,%edx,4),%ecx
80106374:	85 c9                	test   %ecx,%ecx
80106376:	74 18                	je     80106390 <sys_pipe+0xa0>
  for(fd = 0; fd < NOFILE; fd++){
80106378:	83 c2 01             	add    $0x1,%edx
8010637b:	83 fa 10             	cmp    $0x10,%edx
8010637e:	75 f0                	jne    80106370 <sys_pipe+0x80>
      myproc()->ofile[fd0] = 0;
80106380:	e8 9b d8 ff ff       	call   80103c20 <myproc>
80106385:	c7 04 b0 00 00 00 00 	movl   $0x0,(%eax,%esi,4)
8010638c:	eb b2                	jmp    80106340 <sys_pipe+0x50>
8010638e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80106390:	89 7c 90 30          	mov    %edi,0x30(%eax,%edx,4)
  }
  fd[0] = fd0;
80106394:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106397:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80106399:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010639c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010639f:	31 c0                	xor    %eax,%eax
}
801063a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063a4:	5b                   	pop    %ebx
801063a5:	5e                   	pop    %esi
801063a6:	5f                   	pop    %edi
801063a7:	5d                   	pop    %ebp
801063a8:	c3                   	ret    
801063a9:	66 90                	xchg   %ax,%ax
801063ab:	66 90                	xchg   %ax,%ax
801063ad:	66 90                	xchg   %ax,%ax
801063af:	90                   	nop

801063b0 <sys_fork>:
int getps(void);

int
sys_fork(void)
{
  return fork();
801063b0:	e9 db da ff ff       	jmp    80103e90 <fork>
801063b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801063c0 <sys_exit>:
}

int
sys_exit(void)
{
801063c0:	55                   	push   %ebp
801063c1:	89 e5                	mov    %esp,%ebp
801063c3:	83 ec 08             	sub    $0x8,%esp
  exit();
801063c6:	e8 a5 de ff ff       	call   80104270 <exit>
  return 0;  // not reached
}
801063cb:	31 c0                	xor    %eax,%eax
801063cd:	c9                   	leave  
801063ce:	c3                   	ret    
801063cf:	90                   	nop

801063d0 <sys_wait>:

int
sys_wait(void)
{
  return wait();
801063d0:	e9 cb e1 ff ff       	jmp    801045a0 <wait>
801063d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801063e0 <sys_kill>:
}

int
sys_kill(void)
{
801063e0:	55                   	push   %ebp
801063e1:	89 e5                	mov    %esp,%ebp
801063e3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801063e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801063e9:	50                   	push   %eax
801063ea:	6a 00                	push   $0x0
801063ec:	e8 5f f2 ff ff       	call   80105650 <argint>
801063f1:	83 c4 10             	add    $0x10,%esp
801063f4:	85 c0                	test   %eax,%eax
801063f6:	78 18                	js     80106410 <sys_kill+0x30>
    return -1;
  return kill(pid);
801063f8:	83 ec 0c             	sub    $0xc,%esp
801063fb:	ff 75 f4             	push   -0xc(%ebp)
801063fe:	e8 8d e4 ff ff       	call   80104890 <kill>
80106403:	83 c4 10             	add    $0x10,%esp
}
80106406:	c9                   	leave  
80106407:	c3                   	ret    
80106408:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010640f:	90                   	nop
80106410:	c9                   	leave  
    return -1;
80106411:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106416:	c3                   	ret    
80106417:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010641e:	66 90                	xchg   %ax,%ax

80106420 <sys_getpid>:

int
sys_getpid(void)
{
80106420:	55                   	push   %ebp
80106421:	89 e5                	mov    %esp,%ebp
80106423:	83 ec 08             	sub    $0x8,%esp
  return myproc()->tgid;
80106426:	e8 f5 d7 ff ff       	call   80103c20 <myproc>
8010642b:	8b 40 18             	mov    0x18(%eax),%eax
}
8010642e:	c9                   	leave  
8010642f:	c3                   	ret    

80106430 <sys_sbrk>:

int
sys_sbrk(void)
{
80106430:	55                   	push   %ebp
80106431:	89 e5                	mov    %esp,%ebp
80106433:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106434:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106437:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010643a:	50                   	push   %eax
8010643b:	6a 00                	push   $0x0
8010643d:	e8 0e f2 ff ff       	call   80105650 <argint>
80106442:	83 c4 10             	add    $0x10,%esp
80106445:	85 c0                	test   %eax,%eax
80106447:	78 27                	js     80106470 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80106449:	e8 d2 d7 ff ff       	call   80103c20 <myproc>
  if(growproc(n) < 0)
8010644e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106451:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106453:	ff 75 f4             	push   -0xc(%ebp)
80106456:	e8 45 d9 ff ff       	call   80103da0 <growproc>
8010645b:	83 c4 10             	add    $0x10,%esp
8010645e:	85 c0                	test   %eax,%eax
80106460:	78 0e                	js     80106470 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106462:	89 d8                	mov    %ebx,%eax
80106464:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106467:	c9                   	leave  
80106468:	c3                   	ret    
80106469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106470:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106475:	eb eb                	jmp    80106462 <sys_sbrk+0x32>
80106477:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010647e:	66 90                	xchg   %ax,%ax

80106480 <sys_sleep>:

int
sys_sleep(void)
{
80106480:	55                   	push   %ebp
80106481:	89 e5                	mov    %esp,%ebp
80106483:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106484:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106487:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010648a:	50                   	push   %eax
8010648b:	6a 00                	push   $0x0
8010648d:	e8 be f1 ff ff       	call   80105650 <argint>
80106492:	83 c4 10             	add    $0x10,%esp
80106495:	85 c0                	test   %eax,%eax
80106497:	0f 88 8a 00 00 00    	js     80106527 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010649d:	83 ec 0c             	sub    $0xc,%esp
801064a0:	68 a0 65 11 80       	push   $0x801165a0
801064a5:	e8 26 ee ff ff       	call   801052d0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801064aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801064ad:	8b 1d 84 65 11 80    	mov    0x80116584,%ebx
  while(ticks - ticks0 < n){
801064b3:	83 c4 10             	add    $0x10,%esp
801064b6:	85 d2                	test   %edx,%edx
801064b8:	75 27                	jne    801064e1 <sys_sleep+0x61>
801064ba:	eb 54                	jmp    80106510 <sys_sleep+0x90>
801064bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801064c0:	83 ec 08             	sub    $0x8,%esp
801064c3:	68 a0 65 11 80       	push   $0x801165a0
801064c8:	68 84 65 11 80       	push   $0x80116584
801064cd:	e8 7e e2 ff ff       	call   80104750 <sleep>
  while(ticks - ticks0 < n){
801064d2:	a1 84 65 11 80       	mov    0x80116584,%eax
801064d7:	83 c4 10             	add    $0x10,%esp
801064da:	29 d8                	sub    %ebx,%eax
801064dc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801064df:	73 2f                	jae    80106510 <sys_sleep+0x90>
    if(myproc()->killed){
801064e1:	e8 3a d7 ff ff       	call   80103c20 <myproc>
801064e6:	8b 40 2c             	mov    0x2c(%eax),%eax
801064e9:	85 c0                	test   %eax,%eax
801064eb:	74 d3                	je     801064c0 <sys_sleep+0x40>
      release(&tickslock);
801064ed:	83 ec 0c             	sub    $0xc,%esp
801064f0:	68 a0 65 11 80       	push   $0x801165a0
801064f5:	e8 76 ed ff ff       	call   80105270 <release>
  }
  release(&tickslock);
  return 0;
}
801064fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
801064fd:	83 c4 10             	add    $0x10,%esp
80106500:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106505:	c9                   	leave  
80106506:	c3                   	ret    
80106507:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010650e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80106510:	83 ec 0c             	sub    $0xc,%esp
80106513:	68 a0 65 11 80       	push   $0x801165a0
80106518:	e8 53 ed ff ff       	call   80105270 <release>
  return 0;
8010651d:	83 c4 10             	add    $0x10,%esp
80106520:	31 c0                	xor    %eax,%eax
}
80106522:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106525:	c9                   	leave  
80106526:	c3                   	ret    
    return -1;
80106527:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010652c:	eb f4                	jmp    80106522 <sys_sleep+0xa2>
8010652e:	66 90                	xchg   %ax,%ax

80106530 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106530:	55                   	push   %ebp
80106531:	89 e5                	mov    %esp,%ebp
80106533:	53                   	push   %ebx
80106534:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106537:	68 a0 65 11 80       	push   $0x801165a0
8010653c:	e8 8f ed ff ff       	call   801052d0 <acquire>
  xticks = ticks;
80106541:	8b 1d 84 65 11 80    	mov    0x80116584,%ebx
  release(&tickslock);
80106547:	c7 04 24 a0 65 11 80 	movl   $0x801165a0,(%esp)
8010654e:	e8 1d ed ff ff       	call   80105270 <release>
  return xticks;
}
80106553:	89 d8                	mov    %ebx,%eax
80106555:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106558:	c9                   	leave  
80106559:	c3                   	ret    
8010655a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106560 <sys_waitx>:

int sys_waitx(void)
{
80106560:	55                   	push   %ebp
80106561:	89 e5                	mov    %esp,%ebp
80106563:	83 ec 1c             	sub    $0x1c,%esp
  int *wtime, *rtime;

  if (argptr(0, (char **)&wtime, sizeof(int)) < 0)
80106566:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106569:	6a 04                	push   $0x4
8010656b:	50                   	push   %eax
8010656c:	6a 00                	push   $0x0
8010656e:	e8 2d f1 ff ff       	call   801056a0 <argptr>
80106573:	83 c4 10             	add    $0x10,%esp
80106576:	85 c0                	test   %eax,%eax
80106578:	78 2e                	js     801065a8 <sys_waitx+0x48>
    return -1;

  if (argptr(1, (char **)&rtime, sizeof(int)) < 0)
8010657a:	83 ec 04             	sub    $0x4,%esp
8010657d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106580:	6a 04                	push   $0x4
80106582:	50                   	push   %eax
80106583:	6a 01                	push   $0x1
80106585:	e8 16 f1 ff ff       	call   801056a0 <argptr>
8010658a:	83 c4 10             	add    $0x10,%esp
8010658d:	85 c0                	test   %eax,%eax
8010658f:	78 17                	js     801065a8 <sys_waitx+0x48>
    return -1;
  
  return waitx(wtime, rtime);
80106591:	83 ec 08             	sub    $0x8,%esp
80106594:	ff 75 f4             	push   -0xc(%ebp)
80106597:	ff 75 f0             	push   -0x10(%ebp)
8010659a:	e8 91 de ff ff       	call   80104430 <waitx>
8010659f:	83 c4 10             	add    $0x10,%esp
}
801065a2:	c9                   	leave  
801065a3:	c3                   	ret    
801065a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801065a8:	c9                   	leave  
    return -1;
801065a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801065ae:	c3                   	ret    
801065af:	90                   	nop

801065b0 <sys_getps>:

int sys_getps(void)
{
  return getps();
801065b0:	e9 3b e4 ff ff       	jmp    801049f0 <getps>
801065b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801065c0 <sys_clone>:
}

/* for thread */
int
sys_clone(void)
{
801065c0:	55                   	push   %ebp
801065c1:	89 e5                	mov    %esp,%ebp
801065c3:	83 ec 20             	sub    $0x20,%esp
  int function, arg, stack;

  if(argint(0, &function) < 0)
801065c6:	8d 45 ec             	lea    -0x14(%ebp),%eax
801065c9:	50                   	push   %eax
801065ca:	6a 00                	push   $0x0
801065cc:	e8 7f f0 ff ff       	call   80105650 <argint>
801065d1:	83 c4 10             	add    $0x10,%esp
801065d4:	85 c0                	test   %eax,%eax
801065d6:	78 48                	js     80106620 <sys_clone+0x60>
    return -1;

  if(argint(1, &arg) < 0)
801065d8:	83 ec 08             	sub    $0x8,%esp
801065db:	8d 45 f0             	lea    -0x10(%ebp),%eax
801065de:	50                   	push   %eax
801065df:	6a 01                	push   $0x1
801065e1:	e8 6a f0 ff ff       	call   80105650 <argint>
801065e6:	83 c4 10             	add    $0x10,%esp
801065e9:	85 c0                	test   %eax,%eax
801065eb:	78 33                	js     80106620 <sys_clone+0x60>
    return -1;

  if(argint(2, &stack) < 0)
801065ed:	83 ec 08             	sub    $0x8,%esp
801065f0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801065f3:	50                   	push   %eax
801065f4:	6a 02                	push   $0x2
801065f6:	e8 55 f0 ff ff       	call   80105650 <argint>
801065fb:	83 c4 10             	add    $0x10,%esp
801065fe:	85 c0                	test   %eax,%eax
80106600:	78 1e                	js     80106620 <sys_clone+0x60>
    return -1;
  
  return clone((void *)function, (void *)arg, (void *)stack);
80106602:	83 ec 04             	sub    $0x4,%esp
80106605:	ff 75 f4             	push   -0xc(%ebp)
80106608:	ff 75 f0             	push   -0x10(%ebp)
8010660b:	ff 75 ec             	push   -0x14(%ebp)
8010660e:	e8 4d e6 ff ff       	call   80104c60 <clone>
80106613:	83 c4 10             	add    $0x10,%esp
}
80106616:	c9                   	leave  
80106617:	c3                   	ret    
80106618:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010661f:	90                   	nop
80106620:	c9                   	leave  
    return -1;
80106621:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106626:	c3                   	ret    
80106627:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010662e:	66 90                	xchg   %ax,%ax

80106630 <sys_join>:

int
sys_join(void)
{
80106630:	55                   	push   %ebp
80106631:	89 e5                	mov    %esp,%ebp
80106633:	83 ec 20             	sub    $0x20,%esp
  int tid, stack;

  if(argint(0, &tid) < 0)
80106636:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106639:	50                   	push   %eax
8010663a:	6a 00                	push   $0x0
8010663c:	e8 0f f0 ff ff       	call   80105650 <argint>
80106641:	83 c4 10             	add    $0x10,%esp
80106644:	85 c0                	test   %eax,%eax
80106646:	78 28                	js     80106670 <sys_join+0x40>
    return -1;

  if(argint(1, &stack) < 0)
80106648:	83 ec 08             	sub    $0x8,%esp
8010664b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010664e:	50                   	push   %eax
8010664f:	6a 01                	push   $0x1
80106651:	e8 fa ef ff ff       	call   80105650 <argint>
80106656:	83 c4 10             	add    $0x10,%esp
80106659:	85 c0                	test   %eax,%eax
8010665b:	78 13                	js     80106670 <sys_join+0x40>
    return -1;

  return join(tid, (void **)stack);
8010665d:	83 ec 08             	sub    $0x8,%esp
80106660:	ff 75 f4             	push   -0xc(%ebp)
80106663:	ff 75 f0             	push   -0x10(%ebp)
80106666:	e8 75 e7 ff ff       	call   80104de0 <join>
8010666b:	83 c4 10             	add    $0x10,%esp
}
8010666e:	c9                   	leave  
8010666f:	c3                   	ret    
80106670:	c9                   	leave  
    return -1;
80106671:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106676:	c3                   	ret    
80106677:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010667e:	66 90                	xchg   %ax,%ax

80106680 <sys_gettid>:

int
sys_gettid(void)
{
80106680:	55                   	push   %ebp
80106681:	89 e5                	mov    %esp,%ebp
80106683:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106686:	e8 95 d5 ff ff       	call   80103c20 <myproc>
8010668b:	8b 40 14             	mov    0x14(%eax),%eax
}
8010668e:	c9                   	leave  
8010668f:	c3                   	ret    

80106690 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106690:	1e                   	push   %ds
  pushl %es
80106691:	06                   	push   %es
  pushl %fs
80106692:	0f a0                	push   %fs
  pushl %gs
80106694:	0f a8                	push   %gs
  pushal
80106696:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106697:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010669b:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010669d:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010669f:	54                   	push   %esp
  call trap
801066a0:	e8 cb 00 00 00       	call   80106770 <trap>
  addl $4, %esp
801066a5:	83 c4 04             	add    $0x4,%esp

801066a8 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801066a8:	61                   	popa   
  popl %gs
801066a9:	0f a9                	pop    %gs
  popl %fs
801066ab:	0f a1                	pop    %fs
  popl %es
801066ad:	07                   	pop    %es
  popl %ds
801066ae:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801066af:	83 c4 08             	add    $0x8,%esp
  iret
801066b2:	cf                   	iret   
801066b3:	66 90                	xchg   %ax,%ax
801066b5:	66 90                	xchg   %ax,%ax
801066b7:	66 90                	xchg   %ax,%ax
801066b9:	66 90                	xchg   %ax,%ax
801066bb:	66 90                	xchg   %ax,%ax
801066bd:	66 90                	xchg   %ax,%ax
801066bf:	90                   	nop

801066c0 <tvinit>:
int wakeup_ps = 0; // FCFS
const int TICKS_LIMIT = 500; //FCFS

void
tvinit(void)
{
801066c0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801066c1:	31 c0                	xor    %eax,%eax
{
801066c3:	89 e5                	mov    %esp,%ebp
801066c5:	83 ec 08             	sub    $0x8,%esp
801066c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066cf:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801066d0:	8b 14 85 3c b0 10 80 	mov    -0x7fef4fc4(,%eax,4),%edx
801066d7:	c7 04 c5 e2 65 11 80 	movl   $0x8e000008,-0x7fee9a1e(,%eax,8)
801066de:	08 00 00 8e 
801066e2:	66 89 14 c5 e0 65 11 	mov    %dx,-0x7fee9a20(,%eax,8)
801066e9:	80 
801066ea:	c1 ea 10             	shr    $0x10,%edx
801066ed:	66 89 14 c5 e6 65 11 	mov    %dx,-0x7fee9a1a(,%eax,8)
801066f4:	80 
  for(i = 0; i < 256; i++)
801066f5:	83 c0 01             	add    $0x1,%eax
801066f8:	3d 00 01 00 00       	cmp    $0x100,%eax
801066fd:	75 d1                	jne    801066d0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
801066ff:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106702:	a1 3c b1 10 80       	mov    0x8010b13c,%eax
80106707:	c7 05 e2 67 11 80 08 	movl   $0xef000008,0x801167e2
8010670e:	00 00 ef 
  initlock(&tickslock, "time");
80106711:	68 35 8a 10 80       	push   $0x80108a35
80106716:	68 a0 65 11 80       	push   $0x801165a0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010671b:	66 a3 e0 67 11 80    	mov    %ax,0x801167e0
80106721:	c1 e8 10             	shr    $0x10,%eax
80106724:	66 a3 e6 67 11 80    	mov    %ax,0x801167e6
  initlock(&tickslock, "time");
8010672a:	e8 d1 e9 ff ff       	call   80105100 <initlock>
}
8010672f:	83 c4 10             	add    $0x10,%esp
80106732:	c9                   	leave  
80106733:	c3                   	ret    
80106734:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010673b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010673f:	90                   	nop

80106740 <idtinit>:

void
idtinit(void)
{
80106740:	55                   	push   %ebp
  pd[0] = size-1;
80106741:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106746:	89 e5                	mov    %esp,%ebp
80106748:	83 ec 10             	sub    $0x10,%esp
8010674b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010674f:	b8 e0 65 11 80       	mov    $0x801165e0,%eax
80106754:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106758:	c1 e8 10             	shr    $0x10,%eax
8010675b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010675f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106762:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106765:	c9                   	leave  
80106766:	c3                   	ret    
80106767:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010676e:	66 90                	xchg   %ax,%ax

80106770 <trap>:

void
trap(struct trapframe *tf)
{
80106770:	55                   	push   %ebp
80106771:	89 e5                	mov    %esp,%ebp
80106773:	57                   	push   %edi
80106774:	56                   	push   %esi
80106775:	53                   	push   %ebx
80106776:	83 ec 1c             	sub    $0x1c,%esp
80106779:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
8010677c:	8b 43 30             	mov    0x30(%ebx),%eax
8010677f:	83 f8 40             	cmp    $0x40,%eax
80106782:	0f 84 a0 01 00 00    	je     80106928 <trap+0x1b8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106788:	83 e8 20             	sub    $0x20,%eax
8010678b:	83 f8 1f             	cmp    $0x1f,%eax
8010678e:	0f 87 8c 00 00 00    	ja     80106820 <trap+0xb0>
80106794:	ff 24 85 dc 8a 10 80 	jmp    *-0x7fef7524(,%eax,4)
8010679b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010679f:	90                   	nop
      ticking();
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801067a0:	e8 9b ba ff ff       	call   80102240 <ideintr>
    lapiceoi();
801067a5:	e8 66 c1 ff ff       	call   80102910 <lapiceoi>
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
  }

  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801067aa:	e8 71 d4 ff ff       	call   80103c20 <myproc>
801067af:	85 c0                	test   %eax,%eax
801067b1:	74 1d                	je     801067d0 <trap+0x60>
801067b3:	e8 68 d4 ff ff       	call   80103c20 <myproc>
801067b8:	8b 50 2c             	mov    0x2c(%eax),%edx
801067bb:	85 d2                	test   %edx,%edx
801067bd:	74 11                	je     801067d0 <trap+0x60>
801067bf:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801067c3:	83 e0 03             	and    $0x3,%eax
801067c6:	66 83 f8 03          	cmp    $0x3,%ax
801067ca:	0f 84 20 02 00 00    	je     801069f0 <trap+0x280>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
 #endif
    
    
 if(myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
801067d0:	e8 4b d4 ff ff       	call   80103c20 <myproc>
801067d5:	85 c0                	test   %eax,%eax
801067d7:	74 0f                	je     801067e8 <trap+0x78>
801067d9:	e8 42 d4 ff ff       	call   80103c20 <myproc>
801067de:	83 78 10 04          	cmpl   $0x4,0x10(%eax)
801067e2:	0f 84 b8 00 00 00    	je     801068a0 <trap+0x130>

			}	
    #endif
    }

  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801067e8:	e8 33 d4 ff ff       	call   80103c20 <myproc>
801067ed:	85 c0                	test   %eax,%eax
801067ef:	74 1d                	je     8010680e <trap+0x9e>
801067f1:	e8 2a d4 ff ff       	call   80103c20 <myproc>
801067f6:	8b 40 2c             	mov    0x2c(%eax),%eax
801067f9:	85 c0                	test   %eax,%eax
801067fb:	74 11                	je     8010680e <trap+0x9e>
801067fd:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106801:	83 e0 03             	and    $0x3,%eax
80106804:	66 83 f8 03          	cmp    $0x3,%ax
80106808:	0f 84 47 01 00 00    	je     80106955 <trap+0x1e5>
    exit();
}
8010680e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106811:	5b                   	pop    %ebx
80106812:	5e                   	pop    %esi
80106813:	5f                   	pop    %edi
80106814:	5d                   	pop    %ebp
80106815:	c3                   	ret    
80106816:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010681d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80106820:	e8 fb d3 ff ff       	call   80103c20 <myproc>
80106825:	8b 7b 38             	mov    0x38(%ebx),%edi
80106828:	85 c0                	test   %eax,%eax
8010682a:	0f 84 f6 01 00 00    	je     80106a26 <trap+0x2b6>
80106830:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106834:	0f 84 ec 01 00 00    	je     80106a26 <trap+0x2b6>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010683a:	0f 20 d1             	mov    %cr2,%ecx
8010683d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106840:	e8 bb d3 ff ff       	call   80103c00 <cpuid>
80106845:	8b 73 30             	mov    0x30(%ebx),%esi
80106848:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010684b:	8b 43 34             	mov    0x34(%ebx),%eax
8010684e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80106851:	e8 ca d3 ff ff       	call   80103c20 <myproc>
80106856:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106859:	e8 c2 d3 ff ff       	call   80103c20 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010685e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106861:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106864:	51                   	push   %ecx
80106865:	57                   	push   %edi
80106866:	52                   	push   %edx
80106867:	ff 75 e4             	push   -0x1c(%ebp)
8010686a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
8010686b:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010686e:	83 c6 74             	add    $0x74,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106871:	56                   	push   %esi
80106872:	ff 70 14             	push   0x14(%eax)
80106875:	68 98 8a 10 80       	push   $0x80108a98
8010687a:	e8 21 9e ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
8010687f:	83 c4 20             	add    $0x20,%esp
80106882:	e8 99 d3 ff ff       	call   80103c20 <myproc>
80106887:	c7 40 2c 01 00 00 00 	movl   $0x1,0x2c(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010688e:	e8 8d d3 ff ff       	call   80103c20 <myproc>
80106893:	85 c0                	test   %eax,%eax
80106895:	0f 85 18 ff ff ff    	jne    801067b3 <trap+0x43>
8010689b:	e9 30 ff ff ff       	jmp    801067d0 <trap+0x60>
 if(myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
801068a0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801068a4:	0f 85 3e ff ff ff    	jne    801067e8 <trap+0x78>
			if(myproc()->curr_ticks >= q_ticks_max[myproc()->queue])
801068aa:	e8 71 d3 ff ff       	call   80103c20 <myproc>
801068af:	8b b0 b8 00 00 00    	mov    0xb8(%eax),%esi
801068b5:	e8 66 d3 ff ff       	call   80103c20 <myproc>
801068ba:	8b 80 b4 00 00 00    	mov    0xb4(%eax),%eax
801068c0:	3b 34 85 28 b0 10 80 	cmp    -0x7fef4fd8(,%eax,4),%esi
801068c7:	0f 8c 43 01 00 00    	jl     80106a10 <trap+0x2a0>
				change_q_flag(myproc());
801068cd:	e8 4e d3 ff ff       	call   80103c20 <myproc>
801068d2:	83 ec 0c             	sub    $0xc,%esp
801068d5:	50                   	push   %eax
801068d6:	e8 25 d2 ff ff       	call   80103b00 <change_q_flag>
				yield(); 
801068db:	e8 20 de ff ff       	call   80104700 <yield>
801068e0:	83 c4 10             	add    $0x10,%esp
801068e3:	e9 00 ff ff ff       	jmp    801067e8 <trap+0x78>
801068e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801068ef:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801068f0:	8b 7b 38             	mov    0x38(%ebx),%edi
801068f3:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801068f7:	e8 04 d3 ff ff       	call   80103c00 <cpuid>
801068fc:	57                   	push   %edi
801068fd:	56                   	push   %esi
801068fe:	50                   	push   %eax
801068ff:	68 40 8a 10 80       	push   $0x80108a40
80106904:	e8 97 9d ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80106909:	e8 02 c0 ff ff       	call   80102910 <lapiceoi>
    break;
8010690e:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106911:	e8 0a d3 ff ff       	call   80103c20 <myproc>
80106916:	85 c0                	test   %eax,%eax
80106918:	0f 85 95 fe ff ff    	jne    801067b3 <trap+0x43>
8010691e:	e9 ad fe ff ff       	jmp    801067d0 <trap+0x60>
80106923:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106927:	90                   	nop
    if(myproc()->killed)
80106928:	e8 f3 d2 ff ff       	call   80103c20 <myproc>
8010692d:	8b 70 2c             	mov    0x2c(%eax),%esi
80106930:	85 f6                	test   %esi,%esi
80106932:	0f 85 c8 00 00 00    	jne    80106a00 <trap+0x290>
    myproc()->tf = tf;
80106938:	e8 e3 d2 ff ff       	call   80103c20 <myproc>
8010693d:	89 58 20             	mov    %ebx,0x20(%eax)
    syscall();
80106940:	e8 4b ee ff ff       	call   80105790 <syscall>
    if(myproc()->killed)
80106945:	e8 d6 d2 ff ff       	call   80103c20 <myproc>
8010694a:	8b 48 2c             	mov    0x2c(%eax),%ecx
8010694d:	85 c9                	test   %ecx,%ecx
8010694f:	0f 84 b9 fe ff ff    	je     8010680e <trap+0x9e>
}
80106955:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106958:	5b                   	pop    %ebx
80106959:	5e                   	pop    %esi
8010695a:	5f                   	pop    %edi
8010695b:	5d                   	pop    %ebp
      exit();
8010695c:	e9 0f d9 ff ff       	jmp    80104270 <exit>
80106961:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106968:	e8 53 02 00 00       	call   80106bc0 <uartintr>
    lapiceoi();
8010696d:	e8 9e bf ff ff       	call   80102910 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106972:	e8 a9 d2 ff ff       	call   80103c20 <myproc>
80106977:	85 c0                	test   %eax,%eax
80106979:	0f 85 34 fe ff ff    	jne    801067b3 <trap+0x43>
8010697f:	e9 4c fe ff ff       	jmp    801067d0 <trap+0x60>
80106984:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106988:	e8 43 be ff ff       	call   801027d0 <kbdintr>
    lapiceoi();
8010698d:	e8 7e bf ff ff       	call   80102910 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106992:	e8 89 d2 ff ff       	call   80103c20 <myproc>
80106997:	85 c0                	test   %eax,%eax
80106999:	0f 85 14 fe ff ff    	jne    801067b3 <trap+0x43>
8010699f:	e9 2c fe ff ff       	jmp    801067d0 <trap+0x60>
801069a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
801069a8:	e8 53 d2 ff ff       	call   80103c00 <cpuid>
801069ad:	85 c0                	test   %eax,%eax
801069af:	0f 85 f0 fd ff ff    	jne    801067a5 <trap+0x35>
      acquire(&tickslock);
801069b5:	83 ec 0c             	sub    $0xc,%esp
801069b8:	68 a0 65 11 80       	push   $0x801165a0
801069bd:	e8 0e e9 ff ff       	call   801052d0 <acquire>
      wakeup(&ticks);
801069c2:	c7 04 24 84 65 11 80 	movl   $0x80116584,(%esp)
      ticks++;
801069c9:	83 05 84 65 11 80 01 	addl   $0x1,0x80116584
      wakeup(&ticks);
801069d0:	e8 3b de ff ff       	call   80104810 <wakeup>
      release(&tickslock);
801069d5:	c7 04 24 a0 65 11 80 	movl   $0x801165a0,(%esp)
801069dc:	e8 8f e8 ff ff       	call   80105270 <release>
      ticking();
801069e1:	e8 aa cf ff ff       	call   80103990 <ticking>
801069e6:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
801069e9:	e9 b7 fd ff ff       	jmp    801067a5 <trap+0x35>
801069ee:	66 90                	xchg   %ax,%ax
    exit();
801069f0:	e8 7b d8 ff ff       	call   80104270 <exit>
801069f5:	e9 d6 fd ff ff       	jmp    801067d0 <trap+0x60>
801069fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106a00:	e8 6b d8 ff ff       	call   80104270 <exit>
80106a05:	e9 2e ff ff ff       	jmp    80106938 <trap+0x1c8>
80106a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
				incr_curr_ticks(myproc());
80106a10:	e8 0b d2 ff ff       	call   80103c20 <myproc>
80106a15:	83 ec 0c             	sub    $0xc,%esp
80106a18:	50                   	push   %eax
80106a19:	e8 22 d1 ff ff       	call   80103b40 <incr_curr_ticks>
80106a1e:	83 c4 10             	add    $0x10,%esp
80106a21:	e9 c2 fd ff ff       	jmp    801067e8 <trap+0x78>
80106a26:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106a29:	e8 d2 d1 ff ff       	call   80103c00 <cpuid>
80106a2e:	83 ec 0c             	sub    $0xc,%esp
80106a31:	56                   	push   %esi
80106a32:	57                   	push   %edi
80106a33:	50                   	push   %eax
80106a34:	ff 73 30             	push   0x30(%ebx)
80106a37:	68 64 8a 10 80       	push   $0x80108a64
80106a3c:	e8 5f 9c ff ff       	call   801006a0 <cprintf>
      panic("trap");
80106a41:	83 c4 14             	add    $0x14,%esp
80106a44:	68 3a 8a 10 80       	push   $0x80108a3a
80106a49:	e8 32 99 ff ff       	call   80100380 <panic>
80106a4e:	66 90                	xchg   %ax,%ax

80106a50 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106a50:	a1 e0 6d 11 80       	mov    0x80116de0,%eax
80106a55:	85 c0                	test   %eax,%eax
80106a57:	74 17                	je     80106a70 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106a59:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106a5e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106a5f:	a8 01                	test   $0x1,%al
80106a61:	74 0d                	je     80106a70 <uartgetc+0x20>
80106a63:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106a68:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106a69:	0f b6 c0             	movzbl %al,%eax
80106a6c:	c3                   	ret    
80106a6d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106a70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106a75:	c3                   	ret    
80106a76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a7d:	8d 76 00             	lea    0x0(%esi),%esi

80106a80 <uartinit>:
{
80106a80:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106a81:	31 c9                	xor    %ecx,%ecx
80106a83:	89 c8                	mov    %ecx,%eax
80106a85:	89 e5                	mov    %esp,%ebp
80106a87:	57                   	push   %edi
80106a88:	bf fa 03 00 00       	mov    $0x3fa,%edi
80106a8d:	56                   	push   %esi
80106a8e:	89 fa                	mov    %edi,%edx
80106a90:	53                   	push   %ebx
80106a91:	83 ec 1c             	sub    $0x1c,%esp
80106a94:	ee                   	out    %al,(%dx)
80106a95:	be fb 03 00 00       	mov    $0x3fb,%esi
80106a9a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106a9f:	89 f2                	mov    %esi,%edx
80106aa1:	ee                   	out    %al,(%dx)
80106aa2:	b8 0c 00 00 00       	mov    $0xc,%eax
80106aa7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106aac:	ee                   	out    %al,(%dx)
80106aad:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80106ab2:	89 c8                	mov    %ecx,%eax
80106ab4:	89 da                	mov    %ebx,%edx
80106ab6:	ee                   	out    %al,(%dx)
80106ab7:	b8 03 00 00 00       	mov    $0x3,%eax
80106abc:	89 f2                	mov    %esi,%edx
80106abe:	ee                   	out    %al,(%dx)
80106abf:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106ac4:	89 c8                	mov    %ecx,%eax
80106ac6:	ee                   	out    %al,(%dx)
80106ac7:	b8 01 00 00 00       	mov    $0x1,%eax
80106acc:	89 da                	mov    %ebx,%edx
80106ace:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106acf:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106ad4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106ad5:	3c ff                	cmp    $0xff,%al
80106ad7:	74 78                	je     80106b51 <uartinit+0xd1>
  uart = 1;
80106ad9:	c7 05 e0 6d 11 80 01 	movl   $0x1,0x80116de0
80106ae0:	00 00 00 
80106ae3:	89 fa                	mov    %edi,%edx
80106ae5:	ec                   	in     (%dx),%al
80106ae6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106aeb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106aec:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80106aef:	bf 60 8b 10 80       	mov    $0x80108b60,%edi
80106af4:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80106af9:	6a 00                	push   $0x0
80106afb:	6a 04                	push   $0x4
80106afd:	e8 7e b9 ff ff       	call   80102480 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80106b02:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80106b06:	83 c4 10             	add    $0x10,%esp
80106b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80106b10:	a1 e0 6d 11 80       	mov    0x80116de0,%eax
80106b15:	bb 80 00 00 00       	mov    $0x80,%ebx
80106b1a:	85 c0                	test   %eax,%eax
80106b1c:	75 14                	jne    80106b32 <uartinit+0xb2>
80106b1e:	eb 23                	jmp    80106b43 <uartinit+0xc3>
    microdelay(10);
80106b20:	83 ec 0c             	sub    $0xc,%esp
80106b23:	6a 0a                	push   $0xa
80106b25:	e8 06 be ff ff       	call   80102930 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106b2a:	83 c4 10             	add    $0x10,%esp
80106b2d:	83 eb 01             	sub    $0x1,%ebx
80106b30:	74 07                	je     80106b39 <uartinit+0xb9>
80106b32:	89 f2                	mov    %esi,%edx
80106b34:	ec                   	in     (%dx),%al
80106b35:	a8 20                	test   $0x20,%al
80106b37:	74 e7                	je     80106b20 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106b39:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80106b3d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106b42:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80106b43:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80106b47:	83 c7 01             	add    $0x1,%edi
80106b4a:	88 45 e7             	mov    %al,-0x19(%ebp)
80106b4d:	84 c0                	test   %al,%al
80106b4f:	75 bf                	jne    80106b10 <uartinit+0x90>
}
80106b51:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b54:	5b                   	pop    %ebx
80106b55:	5e                   	pop    %esi
80106b56:	5f                   	pop    %edi
80106b57:	5d                   	pop    %ebp
80106b58:	c3                   	ret    
80106b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106b60 <uartputc>:
  if(!uart)
80106b60:	a1 e0 6d 11 80       	mov    0x80116de0,%eax
80106b65:	85 c0                	test   %eax,%eax
80106b67:	74 47                	je     80106bb0 <uartputc+0x50>
{
80106b69:	55                   	push   %ebp
80106b6a:	89 e5                	mov    %esp,%ebp
80106b6c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106b6d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106b72:	53                   	push   %ebx
80106b73:	bb 80 00 00 00       	mov    $0x80,%ebx
80106b78:	eb 18                	jmp    80106b92 <uartputc+0x32>
80106b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106b80:	83 ec 0c             	sub    $0xc,%esp
80106b83:	6a 0a                	push   $0xa
80106b85:	e8 a6 bd ff ff       	call   80102930 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106b8a:	83 c4 10             	add    $0x10,%esp
80106b8d:	83 eb 01             	sub    $0x1,%ebx
80106b90:	74 07                	je     80106b99 <uartputc+0x39>
80106b92:	89 f2                	mov    %esi,%edx
80106b94:	ec                   	in     (%dx),%al
80106b95:	a8 20                	test   $0x20,%al
80106b97:	74 e7                	je     80106b80 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106b99:	8b 45 08             	mov    0x8(%ebp),%eax
80106b9c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106ba1:	ee                   	out    %al,(%dx)
}
80106ba2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106ba5:	5b                   	pop    %ebx
80106ba6:	5e                   	pop    %esi
80106ba7:	5d                   	pop    %ebp
80106ba8:	c3                   	ret    
80106ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bb0:	c3                   	ret    
80106bb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bbf:	90                   	nop

80106bc0 <uartintr>:

void
uartintr(void)
{
80106bc0:	55                   	push   %ebp
80106bc1:	89 e5                	mov    %esp,%ebp
80106bc3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106bc6:	68 50 6a 10 80       	push   $0x80106a50
80106bcb:	e8 b0 9c ff ff       	call   80100880 <consoleintr>
}
80106bd0:	83 c4 10             	add    $0x10,%esp
80106bd3:	c9                   	leave  
80106bd4:	c3                   	ret    

80106bd5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106bd5:	6a 00                	push   $0x0
  pushl $0
80106bd7:	6a 00                	push   $0x0
  jmp alltraps
80106bd9:	e9 b2 fa ff ff       	jmp    80106690 <alltraps>

80106bde <vector1>:
.globl vector1
vector1:
  pushl $0
80106bde:	6a 00                	push   $0x0
  pushl $1
80106be0:	6a 01                	push   $0x1
  jmp alltraps
80106be2:	e9 a9 fa ff ff       	jmp    80106690 <alltraps>

80106be7 <vector2>:
.globl vector2
vector2:
  pushl $0
80106be7:	6a 00                	push   $0x0
  pushl $2
80106be9:	6a 02                	push   $0x2
  jmp alltraps
80106beb:	e9 a0 fa ff ff       	jmp    80106690 <alltraps>

80106bf0 <vector3>:
.globl vector3
vector3:
  pushl $0
80106bf0:	6a 00                	push   $0x0
  pushl $3
80106bf2:	6a 03                	push   $0x3
  jmp alltraps
80106bf4:	e9 97 fa ff ff       	jmp    80106690 <alltraps>

80106bf9 <vector4>:
.globl vector4
vector4:
  pushl $0
80106bf9:	6a 00                	push   $0x0
  pushl $4
80106bfb:	6a 04                	push   $0x4
  jmp alltraps
80106bfd:	e9 8e fa ff ff       	jmp    80106690 <alltraps>

80106c02 <vector5>:
.globl vector5
vector5:
  pushl $0
80106c02:	6a 00                	push   $0x0
  pushl $5
80106c04:	6a 05                	push   $0x5
  jmp alltraps
80106c06:	e9 85 fa ff ff       	jmp    80106690 <alltraps>

80106c0b <vector6>:
.globl vector6
vector6:
  pushl $0
80106c0b:	6a 00                	push   $0x0
  pushl $6
80106c0d:	6a 06                	push   $0x6
  jmp alltraps
80106c0f:	e9 7c fa ff ff       	jmp    80106690 <alltraps>

80106c14 <vector7>:
.globl vector7
vector7:
  pushl $0
80106c14:	6a 00                	push   $0x0
  pushl $7
80106c16:	6a 07                	push   $0x7
  jmp alltraps
80106c18:	e9 73 fa ff ff       	jmp    80106690 <alltraps>

80106c1d <vector8>:
.globl vector8
vector8:
  pushl $8
80106c1d:	6a 08                	push   $0x8
  jmp alltraps
80106c1f:	e9 6c fa ff ff       	jmp    80106690 <alltraps>

80106c24 <vector9>:
.globl vector9
vector9:
  pushl $0
80106c24:	6a 00                	push   $0x0
  pushl $9
80106c26:	6a 09                	push   $0x9
  jmp alltraps
80106c28:	e9 63 fa ff ff       	jmp    80106690 <alltraps>

80106c2d <vector10>:
.globl vector10
vector10:
  pushl $10
80106c2d:	6a 0a                	push   $0xa
  jmp alltraps
80106c2f:	e9 5c fa ff ff       	jmp    80106690 <alltraps>

80106c34 <vector11>:
.globl vector11
vector11:
  pushl $11
80106c34:	6a 0b                	push   $0xb
  jmp alltraps
80106c36:	e9 55 fa ff ff       	jmp    80106690 <alltraps>

80106c3b <vector12>:
.globl vector12
vector12:
  pushl $12
80106c3b:	6a 0c                	push   $0xc
  jmp alltraps
80106c3d:	e9 4e fa ff ff       	jmp    80106690 <alltraps>

80106c42 <vector13>:
.globl vector13
vector13:
  pushl $13
80106c42:	6a 0d                	push   $0xd
  jmp alltraps
80106c44:	e9 47 fa ff ff       	jmp    80106690 <alltraps>

80106c49 <vector14>:
.globl vector14
vector14:
  pushl $14
80106c49:	6a 0e                	push   $0xe
  jmp alltraps
80106c4b:	e9 40 fa ff ff       	jmp    80106690 <alltraps>

80106c50 <vector15>:
.globl vector15
vector15:
  pushl $0
80106c50:	6a 00                	push   $0x0
  pushl $15
80106c52:	6a 0f                	push   $0xf
  jmp alltraps
80106c54:	e9 37 fa ff ff       	jmp    80106690 <alltraps>

80106c59 <vector16>:
.globl vector16
vector16:
  pushl $0
80106c59:	6a 00                	push   $0x0
  pushl $16
80106c5b:	6a 10                	push   $0x10
  jmp alltraps
80106c5d:	e9 2e fa ff ff       	jmp    80106690 <alltraps>

80106c62 <vector17>:
.globl vector17
vector17:
  pushl $17
80106c62:	6a 11                	push   $0x11
  jmp alltraps
80106c64:	e9 27 fa ff ff       	jmp    80106690 <alltraps>

80106c69 <vector18>:
.globl vector18
vector18:
  pushl $0
80106c69:	6a 00                	push   $0x0
  pushl $18
80106c6b:	6a 12                	push   $0x12
  jmp alltraps
80106c6d:	e9 1e fa ff ff       	jmp    80106690 <alltraps>

80106c72 <vector19>:
.globl vector19
vector19:
  pushl $0
80106c72:	6a 00                	push   $0x0
  pushl $19
80106c74:	6a 13                	push   $0x13
  jmp alltraps
80106c76:	e9 15 fa ff ff       	jmp    80106690 <alltraps>

80106c7b <vector20>:
.globl vector20
vector20:
  pushl $0
80106c7b:	6a 00                	push   $0x0
  pushl $20
80106c7d:	6a 14                	push   $0x14
  jmp alltraps
80106c7f:	e9 0c fa ff ff       	jmp    80106690 <alltraps>

80106c84 <vector21>:
.globl vector21
vector21:
  pushl $0
80106c84:	6a 00                	push   $0x0
  pushl $21
80106c86:	6a 15                	push   $0x15
  jmp alltraps
80106c88:	e9 03 fa ff ff       	jmp    80106690 <alltraps>

80106c8d <vector22>:
.globl vector22
vector22:
  pushl $0
80106c8d:	6a 00                	push   $0x0
  pushl $22
80106c8f:	6a 16                	push   $0x16
  jmp alltraps
80106c91:	e9 fa f9 ff ff       	jmp    80106690 <alltraps>

80106c96 <vector23>:
.globl vector23
vector23:
  pushl $0
80106c96:	6a 00                	push   $0x0
  pushl $23
80106c98:	6a 17                	push   $0x17
  jmp alltraps
80106c9a:	e9 f1 f9 ff ff       	jmp    80106690 <alltraps>

80106c9f <vector24>:
.globl vector24
vector24:
  pushl $0
80106c9f:	6a 00                	push   $0x0
  pushl $24
80106ca1:	6a 18                	push   $0x18
  jmp alltraps
80106ca3:	e9 e8 f9 ff ff       	jmp    80106690 <alltraps>

80106ca8 <vector25>:
.globl vector25
vector25:
  pushl $0
80106ca8:	6a 00                	push   $0x0
  pushl $25
80106caa:	6a 19                	push   $0x19
  jmp alltraps
80106cac:	e9 df f9 ff ff       	jmp    80106690 <alltraps>

80106cb1 <vector26>:
.globl vector26
vector26:
  pushl $0
80106cb1:	6a 00                	push   $0x0
  pushl $26
80106cb3:	6a 1a                	push   $0x1a
  jmp alltraps
80106cb5:	e9 d6 f9 ff ff       	jmp    80106690 <alltraps>

80106cba <vector27>:
.globl vector27
vector27:
  pushl $0
80106cba:	6a 00                	push   $0x0
  pushl $27
80106cbc:	6a 1b                	push   $0x1b
  jmp alltraps
80106cbe:	e9 cd f9 ff ff       	jmp    80106690 <alltraps>

80106cc3 <vector28>:
.globl vector28
vector28:
  pushl $0
80106cc3:	6a 00                	push   $0x0
  pushl $28
80106cc5:	6a 1c                	push   $0x1c
  jmp alltraps
80106cc7:	e9 c4 f9 ff ff       	jmp    80106690 <alltraps>

80106ccc <vector29>:
.globl vector29
vector29:
  pushl $0
80106ccc:	6a 00                	push   $0x0
  pushl $29
80106cce:	6a 1d                	push   $0x1d
  jmp alltraps
80106cd0:	e9 bb f9 ff ff       	jmp    80106690 <alltraps>

80106cd5 <vector30>:
.globl vector30
vector30:
  pushl $0
80106cd5:	6a 00                	push   $0x0
  pushl $30
80106cd7:	6a 1e                	push   $0x1e
  jmp alltraps
80106cd9:	e9 b2 f9 ff ff       	jmp    80106690 <alltraps>

80106cde <vector31>:
.globl vector31
vector31:
  pushl $0
80106cde:	6a 00                	push   $0x0
  pushl $31
80106ce0:	6a 1f                	push   $0x1f
  jmp alltraps
80106ce2:	e9 a9 f9 ff ff       	jmp    80106690 <alltraps>

80106ce7 <vector32>:
.globl vector32
vector32:
  pushl $0
80106ce7:	6a 00                	push   $0x0
  pushl $32
80106ce9:	6a 20                	push   $0x20
  jmp alltraps
80106ceb:	e9 a0 f9 ff ff       	jmp    80106690 <alltraps>

80106cf0 <vector33>:
.globl vector33
vector33:
  pushl $0
80106cf0:	6a 00                	push   $0x0
  pushl $33
80106cf2:	6a 21                	push   $0x21
  jmp alltraps
80106cf4:	e9 97 f9 ff ff       	jmp    80106690 <alltraps>

80106cf9 <vector34>:
.globl vector34
vector34:
  pushl $0
80106cf9:	6a 00                	push   $0x0
  pushl $34
80106cfb:	6a 22                	push   $0x22
  jmp alltraps
80106cfd:	e9 8e f9 ff ff       	jmp    80106690 <alltraps>

80106d02 <vector35>:
.globl vector35
vector35:
  pushl $0
80106d02:	6a 00                	push   $0x0
  pushl $35
80106d04:	6a 23                	push   $0x23
  jmp alltraps
80106d06:	e9 85 f9 ff ff       	jmp    80106690 <alltraps>

80106d0b <vector36>:
.globl vector36
vector36:
  pushl $0
80106d0b:	6a 00                	push   $0x0
  pushl $36
80106d0d:	6a 24                	push   $0x24
  jmp alltraps
80106d0f:	e9 7c f9 ff ff       	jmp    80106690 <alltraps>

80106d14 <vector37>:
.globl vector37
vector37:
  pushl $0
80106d14:	6a 00                	push   $0x0
  pushl $37
80106d16:	6a 25                	push   $0x25
  jmp alltraps
80106d18:	e9 73 f9 ff ff       	jmp    80106690 <alltraps>

80106d1d <vector38>:
.globl vector38
vector38:
  pushl $0
80106d1d:	6a 00                	push   $0x0
  pushl $38
80106d1f:	6a 26                	push   $0x26
  jmp alltraps
80106d21:	e9 6a f9 ff ff       	jmp    80106690 <alltraps>

80106d26 <vector39>:
.globl vector39
vector39:
  pushl $0
80106d26:	6a 00                	push   $0x0
  pushl $39
80106d28:	6a 27                	push   $0x27
  jmp alltraps
80106d2a:	e9 61 f9 ff ff       	jmp    80106690 <alltraps>

80106d2f <vector40>:
.globl vector40
vector40:
  pushl $0
80106d2f:	6a 00                	push   $0x0
  pushl $40
80106d31:	6a 28                	push   $0x28
  jmp alltraps
80106d33:	e9 58 f9 ff ff       	jmp    80106690 <alltraps>

80106d38 <vector41>:
.globl vector41
vector41:
  pushl $0
80106d38:	6a 00                	push   $0x0
  pushl $41
80106d3a:	6a 29                	push   $0x29
  jmp alltraps
80106d3c:	e9 4f f9 ff ff       	jmp    80106690 <alltraps>

80106d41 <vector42>:
.globl vector42
vector42:
  pushl $0
80106d41:	6a 00                	push   $0x0
  pushl $42
80106d43:	6a 2a                	push   $0x2a
  jmp alltraps
80106d45:	e9 46 f9 ff ff       	jmp    80106690 <alltraps>

80106d4a <vector43>:
.globl vector43
vector43:
  pushl $0
80106d4a:	6a 00                	push   $0x0
  pushl $43
80106d4c:	6a 2b                	push   $0x2b
  jmp alltraps
80106d4e:	e9 3d f9 ff ff       	jmp    80106690 <alltraps>

80106d53 <vector44>:
.globl vector44
vector44:
  pushl $0
80106d53:	6a 00                	push   $0x0
  pushl $44
80106d55:	6a 2c                	push   $0x2c
  jmp alltraps
80106d57:	e9 34 f9 ff ff       	jmp    80106690 <alltraps>

80106d5c <vector45>:
.globl vector45
vector45:
  pushl $0
80106d5c:	6a 00                	push   $0x0
  pushl $45
80106d5e:	6a 2d                	push   $0x2d
  jmp alltraps
80106d60:	e9 2b f9 ff ff       	jmp    80106690 <alltraps>

80106d65 <vector46>:
.globl vector46
vector46:
  pushl $0
80106d65:	6a 00                	push   $0x0
  pushl $46
80106d67:	6a 2e                	push   $0x2e
  jmp alltraps
80106d69:	e9 22 f9 ff ff       	jmp    80106690 <alltraps>

80106d6e <vector47>:
.globl vector47
vector47:
  pushl $0
80106d6e:	6a 00                	push   $0x0
  pushl $47
80106d70:	6a 2f                	push   $0x2f
  jmp alltraps
80106d72:	e9 19 f9 ff ff       	jmp    80106690 <alltraps>

80106d77 <vector48>:
.globl vector48
vector48:
  pushl $0
80106d77:	6a 00                	push   $0x0
  pushl $48
80106d79:	6a 30                	push   $0x30
  jmp alltraps
80106d7b:	e9 10 f9 ff ff       	jmp    80106690 <alltraps>

80106d80 <vector49>:
.globl vector49
vector49:
  pushl $0
80106d80:	6a 00                	push   $0x0
  pushl $49
80106d82:	6a 31                	push   $0x31
  jmp alltraps
80106d84:	e9 07 f9 ff ff       	jmp    80106690 <alltraps>

80106d89 <vector50>:
.globl vector50
vector50:
  pushl $0
80106d89:	6a 00                	push   $0x0
  pushl $50
80106d8b:	6a 32                	push   $0x32
  jmp alltraps
80106d8d:	e9 fe f8 ff ff       	jmp    80106690 <alltraps>

80106d92 <vector51>:
.globl vector51
vector51:
  pushl $0
80106d92:	6a 00                	push   $0x0
  pushl $51
80106d94:	6a 33                	push   $0x33
  jmp alltraps
80106d96:	e9 f5 f8 ff ff       	jmp    80106690 <alltraps>

80106d9b <vector52>:
.globl vector52
vector52:
  pushl $0
80106d9b:	6a 00                	push   $0x0
  pushl $52
80106d9d:	6a 34                	push   $0x34
  jmp alltraps
80106d9f:	e9 ec f8 ff ff       	jmp    80106690 <alltraps>

80106da4 <vector53>:
.globl vector53
vector53:
  pushl $0
80106da4:	6a 00                	push   $0x0
  pushl $53
80106da6:	6a 35                	push   $0x35
  jmp alltraps
80106da8:	e9 e3 f8 ff ff       	jmp    80106690 <alltraps>

80106dad <vector54>:
.globl vector54
vector54:
  pushl $0
80106dad:	6a 00                	push   $0x0
  pushl $54
80106daf:	6a 36                	push   $0x36
  jmp alltraps
80106db1:	e9 da f8 ff ff       	jmp    80106690 <alltraps>

80106db6 <vector55>:
.globl vector55
vector55:
  pushl $0
80106db6:	6a 00                	push   $0x0
  pushl $55
80106db8:	6a 37                	push   $0x37
  jmp alltraps
80106dba:	e9 d1 f8 ff ff       	jmp    80106690 <alltraps>

80106dbf <vector56>:
.globl vector56
vector56:
  pushl $0
80106dbf:	6a 00                	push   $0x0
  pushl $56
80106dc1:	6a 38                	push   $0x38
  jmp alltraps
80106dc3:	e9 c8 f8 ff ff       	jmp    80106690 <alltraps>

80106dc8 <vector57>:
.globl vector57
vector57:
  pushl $0
80106dc8:	6a 00                	push   $0x0
  pushl $57
80106dca:	6a 39                	push   $0x39
  jmp alltraps
80106dcc:	e9 bf f8 ff ff       	jmp    80106690 <alltraps>

80106dd1 <vector58>:
.globl vector58
vector58:
  pushl $0
80106dd1:	6a 00                	push   $0x0
  pushl $58
80106dd3:	6a 3a                	push   $0x3a
  jmp alltraps
80106dd5:	e9 b6 f8 ff ff       	jmp    80106690 <alltraps>

80106dda <vector59>:
.globl vector59
vector59:
  pushl $0
80106dda:	6a 00                	push   $0x0
  pushl $59
80106ddc:	6a 3b                	push   $0x3b
  jmp alltraps
80106dde:	e9 ad f8 ff ff       	jmp    80106690 <alltraps>

80106de3 <vector60>:
.globl vector60
vector60:
  pushl $0
80106de3:	6a 00                	push   $0x0
  pushl $60
80106de5:	6a 3c                	push   $0x3c
  jmp alltraps
80106de7:	e9 a4 f8 ff ff       	jmp    80106690 <alltraps>

80106dec <vector61>:
.globl vector61
vector61:
  pushl $0
80106dec:	6a 00                	push   $0x0
  pushl $61
80106dee:	6a 3d                	push   $0x3d
  jmp alltraps
80106df0:	e9 9b f8 ff ff       	jmp    80106690 <alltraps>

80106df5 <vector62>:
.globl vector62
vector62:
  pushl $0
80106df5:	6a 00                	push   $0x0
  pushl $62
80106df7:	6a 3e                	push   $0x3e
  jmp alltraps
80106df9:	e9 92 f8 ff ff       	jmp    80106690 <alltraps>

80106dfe <vector63>:
.globl vector63
vector63:
  pushl $0
80106dfe:	6a 00                	push   $0x0
  pushl $63
80106e00:	6a 3f                	push   $0x3f
  jmp alltraps
80106e02:	e9 89 f8 ff ff       	jmp    80106690 <alltraps>

80106e07 <vector64>:
.globl vector64
vector64:
  pushl $0
80106e07:	6a 00                	push   $0x0
  pushl $64
80106e09:	6a 40                	push   $0x40
  jmp alltraps
80106e0b:	e9 80 f8 ff ff       	jmp    80106690 <alltraps>

80106e10 <vector65>:
.globl vector65
vector65:
  pushl $0
80106e10:	6a 00                	push   $0x0
  pushl $65
80106e12:	6a 41                	push   $0x41
  jmp alltraps
80106e14:	e9 77 f8 ff ff       	jmp    80106690 <alltraps>

80106e19 <vector66>:
.globl vector66
vector66:
  pushl $0
80106e19:	6a 00                	push   $0x0
  pushl $66
80106e1b:	6a 42                	push   $0x42
  jmp alltraps
80106e1d:	e9 6e f8 ff ff       	jmp    80106690 <alltraps>

80106e22 <vector67>:
.globl vector67
vector67:
  pushl $0
80106e22:	6a 00                	push   $0x0
  pushl $67
80106e24:	6a 43                	push   $0x43
  jmp alltraps
80106e26:	e9 65 f8 ff ff       	jmp    80106690 <alltraps>

80106e2b <vector68>:
.globl vector68
vector68:
  pushl $0
80106e2b:	6a 00                	push   $0x0
  pushl $68
80106e2d:	6a 44                	push   $0x44
  jmp alltraps
80106e2f:	e9 5c f8 ff ff       	jmp    80106690 <alltraps>

80106e34 <vector69>:
.globl vector69
vector69:
  pushl $0
80106e34:	6a 00                	push   $0x0
  pushl $69
80106e36:	6a 45                	push   $0x45
  jmp alltraps
80106e38:	e9 53 f8 ff ff       	jmp    80106690 <alltraps>

80106e3d <vector70>:
.globl vector70
vector70:
  pushl $0
80106e3d:	6a 00                	push   $0x0
  pushl $70
80106e3f:	6a 46                	push   $0x46
  jmp alltraps
80106e41:	e9 4a f8 ff ff       	jmp    80106690 <alltraps>

80106e46 <vector71>:
.globl vector71
vector71:
  pushl $0
80106e46:	6a 00                	push   $0x0
  pushl $71
80106e48:	6a 47                	push   $0x47
  jmp alltraps
80106e4a:	e9 41 f8 ff ff       	jmp    80106690 <alltraps>

80106e4f <vector72>:
.globl vector72
vector72:
  pushl $0
80106e4f:	6a 00                	push   $0x0
  pushl $72
80106e51:	6a 48                	push   $0x48
  jmp alltraps
80106e53:	e9 38 f8 ff ff       	jmp    80106690 <alltraps>

80106e58 <vector73>:
.globl vector73
vector73:
  pushl $0
80106e58:	6a 00                	push   $0x0
  pushl $73
80106e5a:	6a 49                	push   $0x49
  jmp alltraps
80106e5c:	e9 2f f8 ff ff       	jmp    80106690 <alltraps>

80106e61 <vector74>:
.globl vector74
vector74:
  pushl $0
80106e61:	6a 00                	push   $0x0
  pushl $74
80106e63:	6a 4a                	push   $0x4a
  jmp alltraps
80106e65:	e9 26 f8 ff ff       	jmp    80106690 <alltraps>

80106e6a <vector75>:
.globl vector75
vector75:
  pushl $0
80106e6a:	6a 00                	push   $0x0
  pushl $75
80106e6c:	6a 4b                	push   $0x4b
  jmp alltraps
80106e6e:	e9 1d f8 ff ff       	jmp    80106690 <alltraps>

80106e73 <vector76>:
.globl vector76
vector76:
  pushl $0
80106e73:	6a 00                	push   $0x0
  pushl $76
80106e75:	6a 4c                	push   $0x4c
  jmp alltraps
80106e77:	e9 14 f8 ff ff       	jmp    80106690 <alltraps>

80106e7c <vector77>:
.globl vector77
vector77:
  pushl $0
80106e7c:	6a 00                	push   $0x0
  pushl $77
80106e7e:	6a 4d                	push   $0x4d
  jmp alltraps
80106e80:	e9 0b f8 ff ff       	jmp    80106690 <alltraps>

80106e85 <vector78>:
.globl vector78
vector78:
  pushl $0
80106e85:	6a 00                	push   $0x0
  pushl $78
80106e87:	6a 4e                	push   $0x4e
  jmp alltraps
80106e89:	e9 02 f8 ff ff       	jmp    80106690 <alltraps>

80106e8e <vector79>:
.globl vector79
vector79:
  pushl $0
80106e8e:	6a 00                	push   $0x0
  pushl $79
80106e90:	6a 4f                	push   $0x4f
  jmp alltraps
80106e92:	e9 f9 f7 ff ff       	jmp    80106690 <alltraps>

80106e97 <vector80>:
.globl vector80
vector80:
  pushl $0
80106e97:	6a 00                	push   $0x0
  pushl $80
80106e99:	6a 50                	push   $0x50
  jmp alltraps
80106e9b:	e9 f0 f7 ff ff       	jmp    80106690 <alltraps>

80106ea0 <vector81>:
.globl vector81
vector81:
  pushl $0
80106ea0:	6a 00                	push   $0x0
  pushl $81
80106ea2:	6a 51                	push   $0x51
  jmp alltraps
80106ea4:	e9 e7 f7 ff ff       	jmp    80106690 <alltraps>

80106ea9 <vector82>:
.globl vector82
vector82:
  pushl $0
80106ea9:	6a 00                	push   $0x0
  pushl $82
80106eab:	6a 52                	push   $0x52
  jmp alltraps
80106ead:	e9 de f7 ff ff       	jmp    80106690 <alltraps>

80106eb2 <vector83>:
.globl vector83
vector83:
  pushl $0
80106eb2:	6a 00                	push   $0x0
  pushl $83
80106eb4:	6a 53                	push   $0x53
  jmp alltraps
80106eb6:	e9 d5 f7 ff ff       	jmp    80106690 <alltraps>

80106ebb <vector84>:
.globl vector84
vector84:
  pushl $0
80106ebb:	6a 00                	push   $0x0
  pushl $84
80106ebd:	6a 54                	push   $0x54
  jmp alltraps
80106ebf:	e9 cc f7 ff ff       	jmp    80106690 <alltraps>

80106ec4 <vector85>:
.globl vector85
vector85:
  pushl $0
80106ec4:	6a 00                	push   $0x0
  pushl $85
80106ec6:	6a 55                	push   $0x55
  jmp alltraps
80106ec8:	e9 c3 f7 ff ff       	jmp    80106690 <alltraps>

80106ecd <vector86>:
.globl vector86
vector86:
  pushl $0
80106ecd:	6a 00                	push   $0x0
  pushl $86
80106ecf:	6a 56                	push   $0x56
  jmp alltraps
80106ed1:	e9 ba f7 ff ff       	jmp    80106690 <alltraps>

80106ed6 <vector87>:
.globl vector87
vector87:
  pushl $0
80106ed6:	6a 00                	push   $0x0
  pushl $87
80106ed8:	6a 57                	push   $0x57
  jmp alltraps
80106eda:	e9 b1 f7 ff ff       	jmp    80106690 <alltraps>

80106edf <vector88>:
.globl vector88
vector88:
  pushl $0
80106edf:	6a 00                	push   $0x0
  pushl $88
80106ee1:	6a 58                	push   $0x58
  jmp alltraps
80106ee3:	e9 a8 f7 ff ff       	jmp    80106690 <alltraps>

80106ee8 <vector89>:
.globl vector89
vector89:
  pushl $0
80106ee8:	6a 00                	push   $0x0
  pushl $89
80106eea:	6a 59                	push   $0x59
  jmp alltraps
80106eec:	e9 9f f7 ff ff       	jmp    80106690 <alltraps>

80106ef1 <vector90>:
.globl vector90
vector90:
  pushl $0
80106ef1:	6a 00                	push   $0x0
  pushl $90
80106ef3:	6a 5a                	push   $0x5a
  jmp alltraps
80106ef5:	e9 96 f7 ff ff       	jmp    80106690 <alltraps>

80106efa <vector91>:
.globl vector91
vector91:
  pushl $0
80106efa:	6a 00                	push   $0x0
  pushl $91
80106efc:	6a 5b                	push   $0x5b
  jmp alltraps
80106efe:	e9 8d f7 ff ff       	jmp    80106690 <alltraps>

80106f03 <vector92>:
.globl vector92
vector92:
  pushl $0
80106f03:	6a 00                	push   $0x0
  pushl $92
80106f05:	6a 5c                	push   $0x5c
  jmp alltraps
80106f07:	e9 84 f7 ff ff       	jmp    80106690 <alltraps>

80106f0c <vector93>:
.globl vector93
vector93:
  pushl $0
80106f0c:	6a 00                	push   $0x0
  pushl $93
80106f0e:	6a 5d                	push   $0x5d
  jmp alltraps
80106f10:	e9 7b f7 ff ff       	jmp    80106690 <alltraps>

80106f15 <vector94>:
.globl vector94
vector94:
  pushl $0
80106f15:	6a 00                	push   $0x0
  pushl $94
80106f17:	6a 5e                	push   $0x5e
  jmp alltraps
80106f19:	e9 72 f7 ff ff       	jmp    80106690 <alltraps>

80106f1e <vector95>:
.globl vector95
vector95:
  pushl $0
80106f1e:	6a 00                	push   $0x0
  pushl $95
80106f20:	6a 5f                	push   $0x5f
  jmp alltraps
80106f22:	e9 69 f7 ff ff       	jmp    80106690 <alltraps>

80106f27 <vector96>:
.globl vector96
vector96:
  pushl $0
80106f27:	6a 00                	push   $0x0
  pushl $96
80106f29:	6a 60                	push   $0x60
  jmp alltraps
80106f2b:	e9 60 f7 ff ff       	jmp    80106690 <alltraps>

80106f30 <vector97>:
.globl vector97
vector97:
  pushl $0
80106f30:	6a 00                	push   $0x0
  pushl $97
80106f32:	6a 61                	push   $0x61
  jmp alltraps
80106f34:	e9 57 f7 ff ff       	jmp    80106690 <alltraps>

80106f39 <vector98>:
.globl vector98
vector98:
  pushl $0
80106f39:	6a 00                	push   $0x0
  pushl $98
80106f3b:	6a 62                	push   $0x62
  jmp alltraps
80106f3d:	e9 4e f7 ff ff       	jmp    80106690 <alltraps>

80106f42 <vector99>:
.globl vector99
vector99:
  pushl $0
80106f42:	6a 00                	push   $0x0
  pushl $99
80106f44:	6a 63                	push   $0x63
  jmp alltraps
80106f46:	e9 45 f7 ff ff       	jmp    80106690 <alltraps>

80106f4b <vector100>:
.globl vector100
vector100:
  pushl $0
80106f4b:	6a 00                	push   $0x0
  pushl $100
80106f4d:	6a 64                	push   $0x64
  jmp alltraps
80106f4f:	e9 3c f7 ff ff       	jmp    80106690 <alltraps>

80106f54 <vector101>:
.globl vector101
vector101:
  pushl $0
80106f54:	6a 00                	push   $0x0
  pushl $101
80106f56:	6a 65                	push   $0x65
  jmp alltraps
80106f58:	e9 33 f7 ff ff       	jmp    80106690 <alltraps>

80106f5d <vector102>:
.globl vector102
vector102:
  pushl $0
80106f5d:	6a 00                	push   $0x0
  pushl $102
80106f5f:	6a 66                	push   $0x66
  jmp alltraps
80106f61:	e9 2a f7 ff ff       	jmp    80106690 <alltraps>

80106f66 <vector103>:
.globl vector103
vector103:
  pushl $0
80106f66:	6a 00                	push   $0x0
  pushl $103
80106f68:	6a 67                	push   $0x67
  jmp alltraps
80106f6a:	e9 21 f7 ff ff       	jmp    80106690 <alltraps>

80106f6f <vector104>:
.globl vector104
vector104:
  pushl $0
80106f6f:	6a 00                	push   $0x0
  pushl $104
80106f71:	6a 68                	push   $0x68
  jmp alltraps
80106f73:	e9 18 f7 ff ff       	jmp    80106690 <alltraps>

80106f78 <vector105>:
.globl vector105
vector105:
  pushl $0
80106f78:	6a 00                	push   $0x0
  pushl $105
80106f7a:	6a 69                	push   $0x69
  jmp alltraps
80106f7c:	e9 0f f7 ff ff       	jmp    80106690 <alltraps>

80106f81 <vector106>:
.globl vector106
vector106:
  pushl $0
80106f81:	6a 00                	push   $0x0
  pushl $106
80106f83:	6a 6a                	push   $0x6a
  jmp alltraps
80106f85:	e9 06 f7 ff ff       	jmp    80106690 <alltraps>

80106f8a <vector107>:
.globl vector107
vector107:
  pushl $0
80106f8a:	6a 00                	push   $0x0
  pushl $107
80106f8c:	6a 6b                	push   $0x6b
  jmp alltraps
80106f8e:	e9 fd f6 ff ff       	jmp    80106690 <alltraps>

80106f93 <vector108>:
.globl vector108
vector108:
  pushl $0
80106f93:	6a 00                	push   $0x0
  pushl $108
80106f95:	6a 6c                	push   $0x6c
  jmp alltraps
80106f97:	e9 f4 f6 ff ff       	jmp    80106690 <alltraps>

80106f9c <vector109>:
.globl vector109
vector109:
  pushl $0
80106f9c:	6a 00                	push   $0x0
  pushl $109
80106f9e:	6a 6d                	push   $0x6d
  jmp alltraps
80106fa0:	e9 eb f6 ff ff       	jmp    80106690 <alltraps>

80106fa5 <vector110>:
.globl vector110
vector110:
  pushl $0
80106fa5:	6a 00                	push   $0x0
  pushl $110
80106fa7:	6a 6e                	push   $0x6e
  jmp alltraps
80106fa9:	e9 e2 f6 ff ff       	jmp    80106690 <alltraps>

80106fae <vector111>:
.globl vector111
vector111:
  pushl $0
80106fae:	6a 00                	push   $0x0
  pushl $111
80106fb0:	6a 6f                	push   $0x6f
  jmp alltraps
80106fb2:	e9 d9 f6 ff ff       	jmp    80106690 <alltraps>

80106fb7 <vector112>:
.globl vector112
vector112:
  pushl $0
80106fb7:	6a 00                	push   $0x0
  pushl $112
80106fb9:	6a 70                	push   $0x70
  jmp alltraps
80106fbb:	e9 d0 f6 ff ff       	jmp    80106690 <alltraps>

80106fc0 <vector113>:
.globl vector113
vector113:
  pushl $0
80106fc0:	6a 00                	push   $0x0
  pushl $113
80106fc2:	6a 71                	push   $0x71
  jmp alltraps
80106fc4:	e9 c7 f6 ff ff       	jmp    80106690 <alltraps>

80106fc9 <vector114>:
.globl vector114
vector114:
  pushl $0
80106fc9:	6a 00                	push   $0x0
  pushl $114
80106fcb:	6a 72                	push   $0x72
  jmp alltraps
80106fcd:	e9 be f6 ff ff       	jmp    80106690 <alltraps>

80106fd2 <vector115>:
.globl vector115
vector115:
  pushl $0
80106fd2:	6a 00                	push   $0x0
  pushl $115
80106fd4:	6a 73                	push   $0x73
  jmp alltraps
80106fd6:	e9 b5 f6 ff ff       	jmp    80106690 <alltraps>

80106fdb <vector116>:
.globl vector116
vector116:
  pushl $0
80106fdb:	6a 00                	push   $0x0
  pushl $116
80106fdd:	6a 74                	push   $0x74
  jmp alltraps
80106fdf:	e9 ac f6 ff ff       	jmp    80106690 <alltraps>

80106fe4 <vector117>:
.globl vector117
vector117:
  pushl $0
80106fe4:	6a 00                	push   $0x0
  pushl $117
80106fe6:	6a 75                	push   $0x75
  jmp alltraps
80106fe8:	e9 a3 f6 ff ff       	jmp    80106690 <alltraps>

80106fed <vector118>:
.globl vector118
vector118:
  pushl $0
80106fed:	6a 00                	push   $0x0
  pushl $118
80106fef:	6a 76                	push   $0x76
  jmp alltraps
80106ff1:	e9 9a f6 ff ff       	jmp    80106690 <alltraps>

80106ff6 <vector119>:
.globl vector119
vector119:
  pushl $0
80106ff6:	6a 00                	push   $0x0
  pushl $119
80106ff8:	6a 77                	push   $0x77
  jmp alltraps
80106ffa:	e9 91 f6 ff ff       	jmp    80106690 <alltraps>

80106fff <vector120>:
.globl vector120
vector120:
  pushl $0
80106fff:	6a 00                	push   $0x0
  pushl $120
80107001:	6a 78                	push   $0x78
  jmp alltraps
80107003:	e9 88 f6 ff ff       	jmp    80106690 <alltraps>

80107008 <vector121>:
.globl vector121
vector121:
  pushl $0
80107008:	6a 00                	push   $0x0
  pushl $121
8010700a:	6a 79                	push   $0x79
  jmp alltraps
8010700c:	e9 7f f6 ff ff       	jmp    80106690 <alltraps>

80107011 <vector122>:
.globl vector122
vector122:
  pushl $0
80107011:	6a 00                	push   $0x0
  pushl $122
80107013:	6a 7a                	push   $0x7a
  jmp alltraps
80107015:	e9 76 f6 ff ff       	jmp    80106690 <alltraps>

8010701a <vector123>:
.globl vector123
vector123:
  pushl $0
8010701a:	6a 00                	push   $0x0
  pushl $123
8010701c:	6a 7b                	push   $0x7b
  jmp alltraps
8010701e:	e9 6d f6 ff ff       	jmp    80106690 <alltraps>

80107023 <vector124>:
.globl vector124
vector124:
  pushl $0
80107023:	6a 00                	push   $0x0
  pushl $124
80107025:	6a 7c                	push   $0x7c
  jmp alltraps
80107027:	e9 64 f6 ff ff       	jmp    80106690 <alltraps>

8010702c <vector125>:
.globl vector125
vector125:
  pushl $0
8010702c:	6a 00                	push   $0x0
  pushl $125
8010702e:	6a 7d                	push   $0x7d
  jmp alltraps
80107030:	e9 5b f6 ff ff       	jmp    80106690 <alltraps>

80107035 <vector126>:
.globl vector126
vector126:
  pushl $0
80107035:	6a 00                	push   $0x0
  pushl $126
80107037:	6a 7e                	push   $0x7e
  jmp alltraps
80107039:	e9 52 f6 ff ff       	jmp    80106690 <alltraps>

8010703e <vector127>:
.globl vector127
vector127:
  pushl $0
8010703e:	6a 00                	push   $0x0
  pushl $127
80107040:	6a 7f                	push   $0x7f
  jmp alltraps
80107042:	e9 49 f6 ff ff       	jmp    80106690 <alltraps>

80107047 <vector128>:
.globl vector128
vector128:
  pushl $0
80107047:	6a 00                	push   $0x0
  pushl $128
80107049:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010704e:	e9 3d f6 ff ff       	jmp    80106690 <alltraps>

80107053 <vector129>:
.globl vector129
vector129:
  pushl $0
80107053:	6a 00                	push   $0x0
  pushl $129
80107055:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010705a:	e9 31 f6 ff ff       	jmp    80106690 <alltraps>

8010705f <vector130>:
.globl vector130
vector130:
  pushl $0
8010705f:	6a 00                	push   $0x0
  pushl $130
80107061:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107066:	e9 25 f6 ff ff       	jmp    80106690 <alltraps>

8010706b <vector131>:
.globl vector131
vector131:
  pushl $0
8010706b:	6a 00                	push   $0x0
  pushl $131
8010706d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107072:	e9 19 f6 ff ff       	jmp    80106690 <alltraps>

80107077 <vector132>:
.globl vector132
vector132:
  pushl $0
80107077:	6a 00                	push   $0x0
  pushl $132
80107079:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010707e:	e9 0d f6 ff ff       	jmp    80106690 <alltraps>

80107083 <vector133>:
.globl vector133
vector133:
  pushl $0
80107083:	6a 00                	push   $0x0
  pushl $133
80107085:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010708a:	e9 01 f6 ff ff       	jmp    80106690 <alltraps>

8010708f <vector134>:
.globl vector134
vector134:
  pushl $0
8010708f:	6a 00                	push   $0x0
  pushl $134
80107091:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107096:	e9 f5 f5 ff ff       	jmp    80106690 <alltraps>

8010709b <vector135>:
.globl vector135
vector135:
  pushl $0
8010709b:	6a 00                	push   $0x0
  pushl $135
8010709d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801070a2:	e9 e9 f5 ff ff       	jmp    80106690 <alltraps>

801070a7 <vector136>:
.globl vector136
vector136:
  pushl $0
801070a7:	6a 00                	push   $0x0
  pushl $136
801070a9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801070ae:	e9 dd f5 ff ff       	jmp    80106690 <alltraps>

801070b3 <vector137>:
.globl vector137
vector137:
  pushl $0
801070b3:	6a 00                	push   $0x0
  pushl $137
801070b5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801070ba:	e9 d1 f5 ff ff       	jmp    80106690 <alltraps>

801070bf <vector138>:
.globl vector138
vector138:
  pushl $0
801070bf:	6a 00                	push   $0x0
  pushl $138
801070c1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801070c6:	e9 c5 f5 ff ff       	jmp    80106690 <alltraps>

801070cb <vector139>:
.globl vector139
vector139:
  pushl $0
801070cb:	6a 00                	push   $0x0
  pushl $139
801070cd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801070d2:	e9 b9 f5 ff ff       	jmp    80106690 <alltraps>

801070d7 <vector140>:
.globl vector140
vector140:
  pushl $0
801070d7:	6a 00                	push   $0x0
  pushl $140
801070d9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801070de:	e9 ad f5 ff ff       	jmp    80106690 <alltraps>

801070e3 <vector141>:
.globl vector141
vector141:
  pushl $0
801070e3:	6a 00                	push   $0x0
  pushl $141
801070e5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801070ea:	e9 a1 f5 ff ff       	jmp    80106690 <alltraps>

801070ef <vector142>:
.globl vector142
vector142:
  pushl $0
801070ef:	6a 00                	push   $0x0
  pushl $142
801070f1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801070f6:	e9 95 f5 ff ff       	jmp    80106690 <alltraps>

801070fb <vector143>:
.globl vector143
vector143:
  pushl $0
801070fb:	6a 00                	push   $0x0
  pushl $143
801070fd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107102:	e9 89 f5 ff ff       	jmp    80106690 <alltraps>

80107107 <vector144>:
.globl vector144
vector144:
  pushl $0
80107107:	6a 00                	push   $0x0
  pushl $144
80107109:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010710e:	e9 7d f5 ff ff       	jmp    80106690 <alltraps>

80107113 <vector145>:
.globl vector145
vector145:
  pushl $0
80107113:	6a 00                	push   $0x0
  pushl $145
80107115:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010711a:	e9 71 f5 ff ff       	jmp    80106690 <alltraps>

8010711f <vector146>:
.globl vector146
vector146:
  pushl $0
8010711f:	6a 00                	push   $0x0
  pushl $146
80107121:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107126:	e9 65 f5 ff ff       	jmp    80106690 <alltraps>

8010712b <vector147>:
.globl vector147
vector147:
  pushl $0
8010712b:	6a 00                	push   $0x0
  pushl $147
8010712d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107132:	e9 59 f5 ff ff       	jmp    80106690 <alltraps>

80107137 <vector148>:
.globl vector148
vector148:
  pushl $0
80107137:	6a 00                	push   $0x0
  pushl $148
80107139:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010713e:	e9 4d f5 ff ff       	jmp    80106690 <alltraps>

80107143 <vector149>:
.globl vector149
vector149:
  pushl $0
80107143:	6a 00                	push   $0x0
  pushl $149
80107145:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010714a:	e9 41 f5 ff ff       	jmp    80106690 <alltraps>

8010714f <vector150>:
.globl vector150
vector150:
  pushl $0
8010714f:	6a 00                	push   $0x0
  pushl $150
80107151:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107156:	e9 35 f5 ff ff       	jmp    80106690 <alltraps>

8010715b <vector151>:
.globl vector151
vector151:
  pushl $0
8010715b:	6a 00                	push   $0x0
  pushl $151
8010715d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107162:	e9 29 f5 ff ff       	jmp    80106690 <alltraps>

80107167 <vector152>:
.globl vector152
vector152:
  pushl $0
80107167:	6a 00                	push   $0x0
  pushl $152
80107169:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010716e:	e9 1d f5 ff ff       	jmp    80106690 <alltraps>

80107173 <vector153>:
.globl vector153
vector153:
  pushl $0
80107173:	6a 00                	push   $0x0
  pushl $153
80107175:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010717a:	e9 11 f5 ff ff       	jmp    80106690 <alltraps>

8010717f <vector154>:
.globl vector154
vector154:
  pushl $0
8010717f:	6a 00                	push   $0x0
  pushl $154
80107181:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107186:	e9 05 f5 ff ff       	jmp    80106690 <alltraps>

8010718b <vector155>:
.globl vector155
vector155:
  pushl $0
8010718b:	6a 00                	push   $0x0
  pushl $155
8010718d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107192:	e9 f9 f4 ff ff       	jmp    80106690 <alltraps>

80107197 <vector156>:
.globl vector156
vector156:
  pushl $0
80107197:	6a 00                	push   $0x0
  pushl $156
80107199:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010719e:	e9 ed f4 ff ff       	jmp    80106690 <alltraps>

801071a3 <vector157>:
.globl vector157
vector157:
  pushl $0
801071a3:	6a 00                	push   $0x0
  pushl $157
801071a5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801071aa:	e9 e1 f4 ff ff       	jmp    80106690 <alltraps>

801071af <vector158>:
.globl vector158
vector158:
  pushl $0
801071af:	6a 00                	push   $0x0
  pushl $158
801071b1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801071b6:	e9 d5 f4 ff ff       	jmp    80106690 <alltraps>

801071bb <vector159>:
.globl vector159
vector159:
  pushl $0
801071bb:	6a 00                	push   $0x0
  pushl $159
801071bd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801071c2:	e9 c9 f4 ff ff       	jmp    80106690 <alltraps>

801071c7 <vector160>:
.globl vector160
vector160:
  pushl $0
801071c7:	6a 00                	push   $0x0
  pushl $160
801071c9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801071ce:	e9 bd f4 ff ff       	jmp    80106690 <alltraps>

801071d3 <vector161>:
.globl vector161
vector161:
  pushl $0
801071d3:	6a 00                	push   $0x0
  pushl $161
801071d5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801071da:	e9 b1 f4 ff ff       	jmp    80106690 <alltraps>

801071df <vector162>:
.globl vector162
vector162:
  pushl $0
801071df:	6a 00                	push   $0x0
  pushl $162
801071e1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801071e6:	e9 a5 f4 ff ff       	jmp    80106690 <alltraps>

801071eb <vector163>:
.globl vector163
vector163:
  pushl $0
801071eb:	6a 00                	push   $0x0
  pushl $163
801071ed:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801071f2:	e9 99 f4 ff ff       	jmp    80106690 <alltraps>

801071f7 <vector164>:
.globl vector164
vector164:
  pushl $0
801071f7:	6a 00                	push   $0x0
  pushl $164
801071f9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801071fe:	e9 8d f4 ff ff       	jmp    80106690 <alltraps>

80107203 <vector165>:
.globl vector165
vector165:
  pushl $0
80107203:	6a 00                	push   $0x0
  pushl $165
80107205:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010720a:	e9 81 f4 ff ff       	jmp    80106690 <alltraps>

8010720f <vector166>:
.globl vector166
vector166:
  pushl $0
8010720f:	6a 00                	push   $0x0
  pushl $166
80107211:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107216:	e9 75 f4 ff ff       	jmp    80106690 <alltraps>

8010721b <vector167>:
.globl vector167
vector167:
  pushl $0
8010721b:	6a 00                	push   $0x0
  pushl $167
8010721d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107222:	e9 69 f4 ff ff       	jmp    80106690 <alltraps>

80107227 <vector168>:
.globl vector168
vector168:
  pushl $0
80107227:	6a 00                	push   $0x0
  pushl $168
80107229:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010722e:	e9 5d f4 ff ff       	jmp    80106690 <alltraps>

80107233 <vector169>:
.globl vector169
vector169:
  pushl $0
80107233:	6a 00                	push   $0x0
  pushl $169
80107235:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010723a:	e9 51 f4 ff ff       	jmp    80106690 <alltraps>

8010723f <vector170>:
.globl vector170
vector170:
  pushl $0
8010723f:	6a 00                	push   $0x0
  pushl $170
80107241:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107246:	e9 45 f4 ff ff       	jmp    80106690 <alltraps>

8010724b <vector171>:
.globl vector171
vector171:
  pushl $0
8010724b:	6a 00                	push   $0x0
  pushl $171
8010724d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107252:	e9 39 f4 ff ff       	jmp    80106690 <alltraps>

80107257 <vector172>:
.globl vector172
vector172:
  pushl $0
80107257:	6a 00                	push   $0x0
  pushl $172
80107259:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010725e:	e9 2d f4 ff ff       	jmp    80106690 <alltraps>

80107263 <vector173>:
.globl vector173
vector173:
  pushl $0
80107263:	6a 00                	push   $0x0
  pushl $173
80107265:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010726a:	e9 21 f4 ff ff       	jmp    80106690 <alltraps>

8010726f <vector174>:
.globl vector174
vector174:
  pushl $0
8010726f:	6a 00                	push   $0x0
  pushl $174
80107271:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107276:	e9 15 f4 ff ff       	jmp    80106690 <alltraps>

8010727b <vector175>:
.globl vector175
vector175:
  pushl $0
8010727b:	6a 00                	push   $0x0
  pushl $175
8010727d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107282:	e9 09 f4 ff ff       	jmp    80106690 <alltraps>

80107287 <vector176>:
.globl vector176
vector176:
  pushl $0
80107287:	6a 00                	push   $0x0
  pushl $176
80107289:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010728e:	e9 fd f3 ff ff       	jmp    80106690 <alltraps>

80107293 <vector177>:
.globl vector177
vector177:
  pushl $0
80107293:	6a 00                	push   $0x0
  pushl $177
80107295:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010729a:	e9 f1 f3 ff ff       	jmp    80106690 <alltraps>

8010729f <vector178>:
.globl vector178
vector178:
  pushl $0
8010729f:	6a 00                	push   $0x0
  pushl $178
801072a1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801072a6:	e9 e5 f3 ff ff       	jmp    80106690 <alltraps>

801072ab <vector179>:
.globl vector179
vector179:
  pushl $0
801072ab:	6a 00                	push   $0x0
  pushl $179
801072ad:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801072b2:	e9 d9 f3 ff ff       	jmp    80106690 <alltraps>

801072b7 <vector180>:
.globl vector180
vector180:
  pushl $0
801072b7:	6a 00                	push   $0x0
  pushl $180
801072b9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801072be:	e9 cd f3 ff ff       	jmp    80106690 <alltraps>

801072c3 <vector181>:
.globl vector181
vector181:
  pushl $0
801072c3:	6a 00                	push   $0x0
  pushl $181
801072c5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801072ca:	e9 c1 f3 ff ff       	jmp    80106690 <alltraps>

801072cf <vector182>:
.globl vector182
vector182:
  pushl $0
801072cf:	6a 00                	push   $0x0
  pushl $182
801072d1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801072d6:	e9 b5 f3 ff ff       	jmp    80106690 <alltraps>

801072db <vector183>:
.globl vector183
vector183:
  pushl $0
801072db:	6a 00                	push   $0x0
  pushl $183
801072dd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801072e2:	e9 a9 f3 ff ff       	jmp    80106690 <alltraps>

801072e7 <vector184>:
.globl vector184
vector184:
  pushl $0
801072e7:	6a 00                	push   $0x0
  pushl $184
801072e9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801072ee:	e9 9d f3 ff ff       	jmp    80106690 <alltraps>

801072f3 <vector185>:
.globl vector185
vector185:
  pushl $0
801072f3:	6a 00                	push   $0x0
  pushl $185
801072f5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801072fa:	e9 91 f3 ff ff       	jmp    80106690 <alltraps>

801072ff <vector186>:
.globl vector186
vector186:
  pushl $0
801072ff:	6a 00                	push   $0x0
  pushl $186
80107301:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107306:	e9 85 f3 ff ff       	jmp    80106690 <alltraps>

8010730b <vector187>:
.globl vector187
vector187:
  pushl $0
8010730b:	6a 00                	push   $0x0
  pushl $187
8010730d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107312:	e9 79 f3 ff ff       	jmp    80106690 <alltraps>

80107317 <vector188>:
.globl vector188
vector188:
  pushl $0
80107317:	6a 00                	push   $0x0
  pushl $188
80107319:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010731e:	e9 6d f3 ff ff       	jmp    80106690 <alltraps>

80107323 <vector189>:
.globl vector189
vector189:
  pushl $0
80107323:	6a 00                	push   $0x0
  pushl $189
80107325:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010732a:	e9 61 f3 ff ff       	jmp    80106690 <alltraps>

8010732f <vector190>:
.globl vector190
vector190:
  pushl $0
8010732f:	6a 00                	push   $0x0
  pushl $190
80107331:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107336:	e9 55 f3 ff ff       	jmp    80106690 <alltraps>

8010733b <vector191>:
.globl vector191
vector191:
  pushl $0
8010733b:	6a 00                	push   $0x0
  pushl $191
8010733d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107342:	e9 49 f3 ff ff       	jmp    80106690 <alltraps>

80107347 <vector192>:
.globl vector192
vector192:
  pushl $0
80107347:	6a 00                	push   $0x0
  pushl $192
80107349:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010734e:	e9 3d f3 ff ff       	jmp    80106690 <alltraps>

80107353 <vector193>:
.globl vector193
vector193:
  pushl $0
80107353:	6a 00                	push   $0x0
  pushl $193
80107355:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010735a:	e9 31 f3 ff ff       	jmp    80106690 <alltraps>

8010735f <vector194>:
.globl vector194
vector194:
  pushl $0
8010735f:	6a 00                	push   $0x0
  pushl $194
80107361:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107366:	e9 25 f3 ff ff       	jmp    80106690 <alltraps>

8010736b <vector195>:
.globl vector195
vector195:
  pushl $0
8010736b:	6a 00                	push   $0x0
  pushl $195
8010736d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107372:	e9 19 f3 ff ff       	jmp    80106690 <alltraps>

80107377 <vector196>:
.globl vector196
vector196:
  pushl $0
80107377:	6a 00                	push   $0x0
  pushl $196
80107379:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010737e:	e9 0d f3 ff ff       	jmp    80106690 <alltraps>

80107383 <vector197>:
.globl vector197
vector197:
  pushl $0
80107383:	6a 00                	push   $0x0
  pushl $197
80107385:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010738a:	e9 01 f3 ff ff       	jmp    80106690 <alltraps>

8010738f <vector198>:
.globl vector198
vector198:
  pushl $0
8010738f:	6a 00                	push   $0x0
  pushl $198
80107391:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107396:	e9 f5 f2 ff ff       	jmp    80106690 <alltraps>

8010739b <vector199>:
.globl vector199
vector199:
  pushl $0
8010739b:	6a 00                	push   $0x0
  pushl $199
8010739d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801073a2:	e9 e9 f2 ff ff       	jmp    80106690 <alltraps>

801073a7 <vector200>:
.globl vector200
vector200:
  pushl $0
801073a7:	6a 00                	push   $0x0
  pushl $200
801073a9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801073ae:	e9 dd f2 ff ff       	jmp    80106690 <alltraps>

801073b3 <vector201>:
.globl vector201
vector201:
  pushl $0
801073b3:	6a 00                	push   $0x0
  pushl $201
801073b5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801073ba:	e9 d1 f2 ff ff       	jmp    80106690 <alltraps>

801073bf <vector202>:
.globl vector202
vector202:
  pushl $0
801073bf:	6a 00                	push   $0x0
  pushl $202
801073c1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801073c6:	e9 c5 f2 ff ff       	jmp    80106690 <alltraps>

801073cb <vector203>:
.globl vector203
vector203:
  pushl $0
801073cb:	6a 00                	push   $0x0
  pushl $203
801073cd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801073d2:	e9 b9 f2 ff ff       	jmp    80106690 <alltraps>

801073d7 <vector204>:
.globl vector204
vector204:
  pushl $0
801073d7:	6a 00                	push   $0x0
  pushl $204
801073d9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801073de:	e9 ad f2 ff ff       	jmp    80106690 <alltraps>

801073e3 <vector205>:
.globl vector205
vector205:
  pushl $0
801073e3:	6a 00                	push   $0x0
  pushl $205
801073e5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801073ea:	e9 a1 f2 ff ff       	jmp    80106690 <alltraps>

801073ef <vector206>:
.globl vector206
vector206:
  pushl $0
801073ef:	6a 00                	push   $0x0
  pushl $206
801073f1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801073f6:	e9 95 f2 ff ff       	jmp    80106690 <alltraps>

801073fb <vector207>:
.globl vector207
vector207:
  pushl $0
801073fb:	6a 00                	push   $0x0
  pushl $207
801073fd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107402:	e9 89 f2 ff ff       	jmp    80106690 <alltraps>

80107407 <vector208>:
.globl vector208
vector208:
  pushl $0
80107407:	6a 00                	push   $0x0
  pushl $208
80107409:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010740e:	e9 7d f2 ff ff       	jmp    80106690 <alltraps>

80107413 <vector209>:
.globl vector209
vector209:
  pushl $0
80107413:	6a 00                	push   $0x0
  pushl $209
80107415:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010741a:	e9 71 f2 ff ff       	jmp    80106690 <alltraps>

8010741f <vector210>:
.globl vector210
vector210:
  pushl $0
8010741f:	6a 00                	push   $0x0
  pushl $210
80107421:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107426:	e9 65 f2 ff ff       	jmp    80106690 <alltraps>

8010742b <vector211>:
.globl vector211
vector211:
  pushl $0
8010742b:	6a 00                	push   $0x0
  pushl $211
8010742d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107432:	e9 59 f2 ff ff       	jmp    80106690 <alltraps>

80107437 <vector212>:
.globl vector212
vector212:
  pushl $0
80107437:	6a 00                	push   $0x0
  pushl $212
80107439:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010743e:	e9 4d f2 ff ff       	jmp    80106690 <alltraps>

80107443 <vector213>:
.globl vector213
vector213:
  pushl $0
80107443:	6a 00                	push   $0x0
  pushl $213
80107445:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010744a:	e9 41 f2 ff ff       	jmp    80106690 <alltraps>

8010744f <vector214>:
.globl vector214
vector214:
  pushl $0
8010744f:	6a 00                	push   $0x0
  pushl $214
80107451:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107456:	e9 35 f2 ff ff       	jmp    80106690 <alltraps>

8010745b <vector215>:
.globl vector215
vector215:
  pushl $0
8010745b:	6a 00                	push   $0x0
  pushl $215
8010745d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107462:	e9 29 f2 ff ff       	jmp    80106690 <alltraps>

80107467 <vector216>:
.globl vector216
vector216:
  pushl $0
80107467:	6a 00                	push   $0x0
  pushl $216
80107469:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010746e:	e9 1d f2 ff ff       	jmp    80106690 <alltraps>

80107473 <vector217>:
.globl vector217
vector217:
  pushl $0
80107473:	6a 00                	push   $0x0
  pushl $217
80107475:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010747a:	e9 11 f2 ff ff       	jmp    80106690 <alltraps>

8010747f <vector218>:
.globl vector218
vector218:
  pushl $0
8010747f:	6a 00                	push   $0x0
  pushl $218
80107481:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107486:	e9 05 f2 ff ff       	jmp    80106690 <alltraps>

8010748b <vector219>:
.globl vector219
vector219:
  pushl $0
8010748b:	6a 00                	push   $0x0
  pushl $219
8010748d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107492:	e9 f9 f1 ff ff       	jmp    80106690 <alltraps>

80107497 <vector220>:
.globl vector220
vector220:
  pushl $0
80107497:	6a 00                	push   $0x0
  pushl $220
80107499:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010749e:	e9 ed f1 ff ff       	jmp    80106690 <alltraps>

801074a3 <vector221>:
.globl vector221
vector221:
  pushl $0
801074a3:	6a 00                	push   $0x0
  pushl $221
801074a5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801074aa:	e9 e1 f1 ff ff       	jmp    80106690 <alltraps>

801074af <vector222>:
.globl vector222
vector222:
  pushl $0
801074af:	6a 00                	push   $0x0
  pushl $222
801074b1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801074b6:	e9 d5 f1 ff ff       	jmp    80106690 <alltraps>

801074bb <vector223>:
.globl vector223
vector223:
  pushl $0
801074bb:	6a 00                	push   $0x0
  pushl $223
801074bd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801074c2:	e9 c9 f1 ff ff       	jmp    80106690 <alltraps>

801074c7 <vector224>:
.globl vector224
vector224:
  pushl $0
801074c7:	6a 00                	push   $0x0
  pushl $224
801074c9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801074ce:	e9 bd f1 ff ff       	jmp    80106690 <alltraps>

801074d3 <vector225>:
.globl vector225
vector225:
  pushl $0
801074d3:	6a 00                	push   $0x0
  pushl $225
801074d5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801074da:	e9 b1 f1 ff ff       	jmp    80106690 <alltraps>

801074df <vector226>:
.globl vector226
vector226:
  pushl $0
801074df:	6a 00                	push   $0x0
  pushl $226
801074e1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801074e6:	e9 a5 f1 ff ff       	jmp    80106690 <alltraps>

801074eb <vector227>:
.globl vector227
vector227:
  pushl $0
801074eb:	6a 00                	push   $0x0
  pushl $227
801074ed:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801074f2:	e9 99 f1 ff ff       	jmp    80106690 <alltraps>

801074f7 <vector228>:
.globl vector228
vector228:
  pushl $0
801074f7:	6a 00                	push   $0x0
  pushl $228
801074f9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801074fe:	e9 8d f1 ff ff       	jmp    80106690 <alltraps>

80107503 <vector229>:
.globl vector229
vector229:
  pushl $0
80107503:	6a 00                	push   $0x0
  pushl $229
80107505:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010750a:	e9 81 f1 ff ff       	jmp    80106690 <alltraps>

8010750f <vector230>:
.globl vector230
vector230:
  pushl $0
8010750f:	6a 00                	push   $0x0
  pushl $230
80107511:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107516:	e9 75 f1 ff ff       	jmp    80106690 <alltraps>

8010751b <vector231>:
.globl vector231
vector231:
  pushl $0
8010751b:	6a 00                	push   $0x0
  pushl $231
8010751d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107522:	e9 69 f1 ff ff       	jmp    80106690 <alltraps>

80107527 <vector232>:
.globl vector232
vector232:
  pushl $0
80107527:	6a 00                	push   $0x0
  pushl $232
80107529:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010752e:	e9 5d f1 ff ff       	jmp    80106690 <alltraps>

80107533 <vector233>:
.globl vector233
vector233:
  pushl $0
80107533:	6a 00                	push   $0x0
  pushl $233
80107535:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010753a:	e9 51 f1 ff ff       	jmp    80106690 <alltraps>

8010753f <vector234>:
.globl vector234
vector234:
  pushl $0
8010753f:	6a 00                	push   $0x0
  pushl $234
80107541:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107546:	e9 45 f1 ff ff       	jmp    80106690 <alltraps>

8010754b <vector235>:
.globl vector235
vector235:
  pushl $0
8010754b:	6a 00                	push   $0x0
  pushl $235
8010754d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107552:	e9 39 f1 ff ff       	jmp    80106690 <alltraps>

80107557 <vector236>:
.globl vector236
vector236:
  pushl $0
80107557:	6a 00                	push   $0x0
  pushl $236
80107559:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010755e:	e9 2d f1 ff ff       	jmp    80106690 <alltraps>

80107563 <vector237>:
.globl vector237
vector237:
  pushl $0
80107563:	6a 00                	push   $0x0
  pushl $237
80107565:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010756a:	e9 21 f1 ff ff       	jmp    80106690 <alltraps>

8010756f <vector238>:
.globl vector238
vector238:
  pushl $0
8010756f:	6a 00                	push   $0x0
  pushl $238
80107571:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107576:	e9 15 f1 ff ff       	jmp    80106690 <alltraps>

8010757b <vector239>:
.globl vector239
vector239:
  pushl $0
8010757b:	6a 00                	push   $0x0
  pushl $239
8010757d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107582:	e9 09 f1 ff ff       	jmp    80106690 <alltraps>

80107587 <vector240>:
.globl vector240
vector240:
  pushl $0
80107587:	6a 00                	push   $0x0
  pushl $240
80107589:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010758e:	e9 fd f0 ff ff       	jmp    80106690 <alltraps>

80107593 <vector241>:
.globl vector241
vector241:
  pushl $0
80107593:	6a 00                	push   $0x0
  pushl $241
80107595:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010759a:	e9 f1 f0 ff ff       	jmp    80106690 <alltraps>

8010759f <vector242>:
.globl vector242
vector242:
  pushl $0
8010759f:	6a 00                	push   $0x0
  pushl $242
801075a1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801075a6:	e9 e5 f0 ff ff       	jmp    80106690 <alltraps>

801075ab <vector243>:
.globl vector243
vector243:
  pushl $0
801075ab:	6a 00                	push   $0x0
  pushl $243
801075ad:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801075b2:	e9 d9 f0 ff ff       	jmp    80106690 <alltraps>

801075b7 <vector244>:
.globl vector244
vector244:
  pushl $0
801075b7:	6a 00                	push   $0x0
  pushl $244
801075b9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801075be:	e9 cd f0 ff ff       	jmp    80106690 <alltraps>

801075c3 <vector245>:
.globl vector245
vector245:
  pushl $0
801075c3:	6a 00                	push   $0x0
  pushl $245
801075c5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801075ca:	e9 c1 f0 ff ff       	jmp    80106690 <alltraps>

801075cf <vector246>:
.globl vector246
vector246:
  pushl $0
801075cf:	6a 00                	push   $0x0
  pushl $246
801075d1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801075d6:	e9 b5 f0 ff ff       	jmp    80106690 <alltraps>

801075db <vector247>:
.globl vector247
vector247:
  pushl $0
801075db:	6a 00                	push   $0x0
  pushl $247
801075dd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801075e2:	e9 a9 f0 ff ff       	jmp    80106690 <alltraps>

801075e7 <vector248>:
.globl vector248
vector248:
  pushl $0
801075e7:	6a 00                	push   $0x0
  pushl $248
801075e9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801075ee:	e9 9d f0 ff ff       	jmp    80106690 <alltraps>

801075f3 <vector249>:
.globl vector249
vector249:
  pushl $0
801075f3:	6a 00                	push   $0x0
  pushl $249
801075f5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801075fa:	e9 91 f0 ff ff       	jmp    80106690 <alltraps>

801075ff <vector250>:
.globl vector250
vector250:
  pushl $0
801075ff:	6a 00                	push   $0x0
  pushl $250
80107601:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107606:	e9 85 f0 ff ff       	jmp    80106690 <alltraps>

8010760b <vector251>:
.globl vector251
vector251:
  pushl $0
8010760b:	6a 00                	push   $0x0
  pushl $251
8010760d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107612:	e9 79 f0 ff ff       	jmp    80106690 <alltraps>

80107617 <vector252>:
.globl vector252
vector252:
  pushl $0
80107617:	6a 00                	push   $0x0
  pushl $252
80107619:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010761e:	e9 6d f0 ff ff       	jmp    80106690 <alltraps>

80107623 <vector253>:
.globl vector253
vector253:
  pushl $0
80107623:	6a 00                	push   $0x0
  pushl $253
80107625:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010762a:	e9 61 f0 ff ff       	jmp    80106690 <alltraps>

8010762f <vector254>:
.globl vector254
vector254:
  pushl $0
8010762f:	6a 00                	push   $0x0
  pushl $254
80107631:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107636:	e9 55 f0 ff ff       	jmp    80106690 <alltraps>

8010763b <vector255>:
.globl vector255
vector255:
  pushl $0
8010763b:	6a 00                	push   $0x0
  pushl $255
8010763d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107642:	e9 49 f0 ff ff       	jmp    80106690 <alltraps>
80107647:	66 90                	xchg   %ax,%ax
80107649:	66 90                	xchg   %ax,%ax
8010764b:	66 90                	xchg   %ax,%ax
8010764d:	66 90                	xchg   %ax,%ax
8010764f:	90                   	nop

80107650 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107650:	55                   	push   %ebp
80107651:	89 e5                	mov    %esp,%ebp
80107653:	57                   	push   %edi
80107654:	56                   	push   %esi
80107655:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107656:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
8010765c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107662:	83 ec 1c             	sub    $0x1c,%esp
80107665:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107668:	39 d3                	cmp    %edx,%ebx
8010766a:	73 49                	jae    801076b5 <deallocuvm.part.0+0x65>
8010766c:	89 c7                	mov    %eax,%edi
8010766e:	eb 0c                	jmp    8010767c <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107670:	83 c0 01             	add    $0x1,%eax
80107673:	c1 e0 16             	shl    $0x16,%eax
80107676:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80107678:	39 da                	cmp    %ebx,%edx
8010767a:	76 39                	jbe    801076b5 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
8010767c:	89 d8                	mov    %ebx,%eax
8010767e:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107681:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80107684:	f6 c1 01             	test   $0x1,%cl
80107687:	74 e7                	je     80107670 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80107689:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010768b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107691:	c1 ee 0a             	shr    $0xa,%esi
80107694:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
8010769a:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
801076a1:	85 f6                	test   %esi,%esi
801076a3:	74 cb                	je     80107670 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
801076a5:	8b 06                	mov    (%esi),%eax
801076a7:	a8 01                	test   $0x1,%al
801076a9:	75 15                	jne    801076c0 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
801076ab:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801076b1:	39 da                	cmp    %ebx,%edx
801076b3:	77 c7                	ja     8010767c <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
801076b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801076b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076bb:	5b                   	pop    %ebx
801076bc:	5e                   	pop    %esi
801076bd:	5f                   	pop    %edi
801076be:	5d                   	pop    %ebp
801076bf:	c3                   	ret    
      if(pa == 0)
801076c0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801076c5:	74 25                	je     801076ec <deallocuvm.part.0+0x9c>
      kfree(v);
801076c7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801076ca:	05 00 00 00 80       	add    $0x80000000,%eax
801076cf:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801076d2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
801076d8:	50                   	push   %eax
801076d9:	e8 e2 ad ff ff       	call   801024c0 <kfree>
      *pte = 0;
801076de:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
801076e4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801076e7:	83 c4 10             	add    $0x10,%esp
801076ea:	eb 8c                	jmp    80107678 <deallocuvm.part.0+0x28>
        panic("kfree");
801076ec:	83 ec 0c             	sub    $0xc,%esp
801076ef:	68 a6 82 10 80       	push   $0x801082a6
801076f4:	e8 87 8c ff ff       	call   80100380 <panic>
801076f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107700 <mappages>:
{
80107700:	55                   	push   %ebp
80107701:	89 e5                	mov    %esp,%ebp
80107703:	57                   	push   %edi
80107704:	56                   	push   %esi
80107705:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80107706:	89 d3                	mov    %edx,%ebx
80107708:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010770e:	83 ec 1c             	sub    $0x1c,%esp
80107711:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107714:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107718:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010771d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107720:	8b 45 08             	mov    0x8(%ebp),%eax
80107723:	29 d8                	sub    %ebx,%eax
80107725:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107728:	eb 3d                	jmp    80107767 <mappages+0x67>
8010772a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107730:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107732:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107737:	c1 ea 0a             	shr    $0xa,%edx
8010773a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107740:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107747:	85 c0                	test   %eax,%eax
80107749:	74 75                	je     801077c0 <mappages+0xc0>
    if(*pte & PTE_P)
8010774b:	f6 00 01             	testb  $0x1,(%eax)
8010774e:	0f 85 86 00 00 00    	jne    801077da <mappages+0xda>
    *pte = pa | perm | PTE_P;
80107754:	0b 75 0c             	or     0xc(%ebp),%esi
80107757:	83 ce 01             	or     $0x1,%esi
8010775a:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010775c:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
8010775f:	74 6f                	je     801077d0 <mappages+0xd0>
    a += PGSIZE;
80107761:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80107767:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
8010776a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010776d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80107770:	89 d8                	mov    %ebx,%eax
80107772:	c1 e8 16             	shr    $0x16,%eax
80107775:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80107778:	8b 07                	mov    (%edi),%eax
8010777a:	a8 01                	test   $0x1,%al
8010777c:	75 b2                	jne    80107730 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
8010777e:	e8 fd ae ff ff       	call   80102680 <kalloc>
80107783:	85 c0                	test   %eax,%eax
80107785:	74 39                	je     801077c0 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80107787:	83 ec 04             	sub    $0x4,%esp
8010778a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010778d:	68 00 10 00 00       	push   $0x1000
80107792:	6a 00                	push   $0x0
80107794:	50                   	push   %eax
80107795:	e8 f6 db ff ff       	call   80105390 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010779a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
8010779d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801077a0:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
801077a6:	83 c8 07             	or     $0x7,%eax
801077a9:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
801077ab:	89 d8                	mov    %ebx,%eax
801077ad:	c1 e8 0a             	shr    $0xa,%eax
801077b0:	25 fc 0f 00 00       	and    $0xffc,%eax
801077b5:	01 d0                	add    %edx,%eax
801077b7:	eb 92                	jmp    8010774b <mappages+0x4b>
801077b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
801077c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801077c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801077c8:	5b                   	pop    %ebx
801077c9:	5e                   	pop    %esi
801077ca:	5f                   	pop    %edi
801077cb:	5d                   	pop    %ebp
801077cc:	c3                   	ret    
801077cd:	8d 76 00             	lea    0x0(%esi),%esi
801077d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801077d3:	31 c0                	xor    %eax,%eax
}
801077d5:	5b                   	pop    %ebx
801077d6:	5e                   	pop    %esi
801077d7:	5f                   	pop    %edi
801077d8:	5d                   	pop    %ebp
801077d9:	c3                   	ret    
      panic("remap");
801077da:	83 ec 0c             	sub    $0xc,%esp
801077dd:	68 68 8b 10 80       	push   $0x80108b68
801077e2:	e8 99 8b ff ff       	call   80100380 <panic>
801077e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077ee:	66 90                	xchg   %ax,%ax

801077f0 <seginit>:
{
801077f0:	55                   	push   %ebp
801077f1:	89 e5                	mov    %esp,%ebp
801077f3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801077f6:	e8 05 c4 ff ff       	call   80103c00 <cpuid>
  pd[0] = size-1;
801077fb:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107800:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107806:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010780a:	c7 80 38 28 11 80 ff 	movl   $0xffff,-0x7feed7c8(%eax)
80107811:	ff 00 00 
80107814:	c7 80 3c 28 11 80 00 	movl   $0xcf9a00,-0x7feed7c4(%eax)
8010781b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010781e:	c7 80 40 28 11 80 ff 	movl   $0xffff,-0x7feed7c0(%eax)
80107825:	ff 00 00 
80107828:	c7 80 44 28 11 80 00 	movl   $0xcf9200,-0x7feed7bc(%eax)
8010782f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107832:	c7 80 48 28 11 80 ff 	movl   $0xffff,-0x7feed7b8(%eax)
80107839:	ff 00 00 
8010783c:	c7 80 4c 28 11 80 00 	movl   $0xcffa00,-0x7feed7b4(%eax)
80107843:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107846:	c7 80 50 28 11 80 ff 	movl   $0xffff,-0x7feed7b0(%eax)
8010784d:	ff 00 00 
80107850:	c7 80 54 28 11 80 00 	movl   $0xcff200,-0x7feed7ac(%eax)
80107857:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010785a:	05 30 28 11 80       	add    $0x80112830,%eax
  pd[1] = (uint)p;
8010785f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107863:	c1 e8 10             	shr    $0x10,%eax
80107866:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010786a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010786d:	0f 01 10             	lgdtl  (%eax)
}
80107870:	c9                   	leave  
80107871:	c3                   	ret    
80107872:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107880 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107880:	a1 e4 6d 11 80       	mov    0x80116de4,%eax
80107885:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010788a:	0f 22 d8             	mov    %eax,%cr3
}
8010788d:	c3                   	ret    
8010788e:	66 90                	xchg   %ax,%ax

80107890 <switchuvm>:
{
80107890:	55                   	push   %ebp
80107891:	89 e5                	mov    %esp,%ebp
80107893:	57                   	push   %edi
80107894:	56                   	push   %esi
80107895:	53                   	push   %ebx
80107896:	83 ec 1c             	sub    $0x1c,%esp
80107899:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010789c:	85 f6                	test   %esi,%esi
8010789e:	0f 84 cb 00 00 00    	je     8010796f <switchuvm+0xdf>
  if(p->kstack == 0)
801078a4:	8b 46 08             	mov    0x8(%esi),%eax
801078a7:	85 c0                	test   %eax,%eax
801078a9:	0f 84 da 00 00 00    	je     80107989 <switchuvm+0xf9>
  if(p->pgdir == 0)
801078af:	8b 46 04             	mov    0x4(%esi),%eax
801078b2:	85 c0                	test   %eax,%eax
801078b4:	0f 84 c2 00 00 00    	je     8010797c <switchuvm+0xec>
  pushcli();
801078ba:	e8 c1 d8 ff ff       	call   80105180 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801078bf:	e8 dc c2 ff ff       	call   80103ba0 <mycpu>
801078c4:	89 c3                	mov    %eax,%ebx
801078c6:	e8 d5 c2 ff ff       	call   80103ba0 <mycpu>
801078cb:	89 c7                	mov    %eax,%edi
801078cd:	e8 ce c2 ff ff       	call   80103ba0 <mycpu>
801078d2:	83 c7 08             	add    $0x8,%edi
801078d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801078d8:	e8 c3 c2 ff ff       	call   80103ba0 <mycpu>
801078dd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801078e0:	ba 67 00 00 00       	mov    $0x67,%edx
801078e5:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801078ec:	83 c0 08             	add    $0x8,%eax
801078ef:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801078f6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801078fb:	83 c1 08             	add    $0x8,%ecx
801078fe:	c1 e8 18             	shr    $0x18,%eax
80107901:	c1 e9 10             	shr    $0x10,%ecx
80107904:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010790a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107910:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107915:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010791c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107921:	e8 7a c2 ff ff       	call   80103ba0 <mycpu>
80107926:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010792d:	e8 6e c2 ff ff       	call   80103ba0 <mycpu>
80107932:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107936:	8b 5e 08             	mov    0x8(%esi),%ebx
80107939:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010793f:	e8 5c c2 ff ff       	call   80103ba0 <mycpu>
80107944:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107947:	e8 54 c2 ff ff       	call   80103ba0 <mycpu>
8010794c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107950:	b8 28 00 00 00       	mov    $0x28,%eax
80107955:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107958:	8b 46 04             	mov    0x4(%esi),%eax
8010795b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107960:	0f 22 d8             	mov    %eax,%cr3
}
80107963:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107966:	5b                   	pop    %ebx
80107967:	5e                   	pop    %esi
80107968:	5f                   	pop    %edi
80107969:	5d                   	pop    %ebp
  popcli();
8010796a:	e9 61 d8 ff ff       	jmp    801051d0 <popcli>
    panic("switchuvm: no process");
8010796f:	83 ec 0c             	sub    $0xc,%esp
80107972:	68 6e 8b 10 80       	push   $0x80108b6e
80107977:	e8 04 8a ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
8010797c:	83 ec 0c             	sub    $0xc,%esp
8010797f:	68 99 8b 10 80       	push   $0x80108b99
80107984:	e8 f7 89 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80107989:	83 ec 0c             	sub    $0xc,%esp
8010798c:	68 84 8b 10 80       	push   $0x80108b84
80107991:	e8 ea 89 ff ff       	call   80100380 <panic>
80107996:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010799d:	8d 76 00             	lea    0x0(%esi),%esi

801079a0 <inituvm>:
{
801079a0:	55                   	push   %ebp
801079a1:	89 e5                	mov    %esp,%ebp
801079a3:	57                   	push   %edi
801079a4:	56                   	push   %esi
801079a5:	53                   	push   %ebx
801079a6:	83 ec 1c             	sub    $0x1c,%esp
801079a9:	8b 45 0c             	mov    0xc(%ebp),%eax
801079ac:	8b 75 10             	mov    0x10(%ebp),%esi
801079af:	8b 7d 08             	mov    0x8(%ebp),%edi
801079b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801079b5:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801079bb:	77 4b                	ja     80107a08 <inituvm+0x68>
  mem = kalloc();
801079bd:	e8 be ac ff ff       	call   80102680 <kalloc>
  memset(mem, 0, PGSIZE);
801079c2:	83 ec 04             	sub    $0x4,%esp
801079c5:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
801079ca:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801079cc:	6a 00                	push   $0x0
801079ce:	50                   	push   %eax
801079cf:	e8 bc d9 ff ff       	call   80105390 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801079d4:	58                   	pop    %eax
801079d5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801079db:	5a                   	pop    %edx
801079dc:	6a 06                	push   $0x6
801079de:	b9 00 10 00 00       	mov    $0x1000,%ecx
801079e3:	31 d2                	xor    %edx,%edx
801079e5:	50                   	push   %eax
801079e6:	89 f8                	mov    %edi,%eax
801079e8:	e8 13 fd ff ff       	call   80107700 <mappages>
  memmove(mem, init, sz);
801079ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801079f0:	89 75 10             	mov    %esi,0x10(%ebp)
801079f3:	83 c4 10             	add    $0x10,%esp
801079f6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801079f9:	89 45 0c             	mov    %eax,0xc(%ebp)
}
801079fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801079ff:	5b                   	pop    %ebx
80107a00:	5e                   	pop    %esi
80107a01:	5f                   	pop    %edi
80107a02:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107a03:	e9 28 da ff ff       	jmp    80105430 <memmove>
    panic("inituvm: more than a page");
80107a08:	83 ec 0c             	sub    $0xc,%esp
80107a0b:	68 ad 8b 10 80       	push   $0x80108bad
80107a10:	e8 6b 89 ff ff       	call   80100380 <panic>
80107a15:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107a20 <loaduvm>:
{
80107a20:	55                   	push   %ebp
80107a21:	89 e5                	mov    %esp,%ebp
80107a23:	57                   	push   %edi
80107a24:	56                   	push   %esi
80107a25:	53                   	push   %ebx
80107a26:	83 ec 1c             	sub    $0x1c,%esp
80107a29:	8b 45 0c             	mov    0xc(%ebp),%eax
80107a2c:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80107a2f:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107a34:	0f 85 bb 00 00 00    	jne    80107af5 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
80107a3a:	01 f0                	add    %esi,%eax
80107a3c:	89 f3                	mov    %esi,%ebx
80107a3e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107a41:	8b 45 14             	mov    0x14(%ebp),%eax
80107a44:	01 f0                	add    %esi,%eax
80107a46:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80107a49:	85 f6                	test   %esi,%esi
80107a4b:	0f 84 87 00 00 00    	je     80107ad8 <loaduvm+0xb8>
80107a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80107a58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
80107a5b:	8b 4d 08             	mov    0x8(%ebp),%ecx
80107a5e:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80107a60:	89 c2                	mov    %eax,%edx
80107a62:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107a65:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80107a68:	f6 c2 01             	test   $0x1,%dl
80107a6b:	75 13                	jne    80107a80 <loaduvm+0x60>
      panic("loaduvm: address should exist");
80107a6d:	83 ec 0c             	sub    $0xc,%esp
80107a70:	68 c7 8b 10 80       	push   $0x80108bc7
80107a75:	e8 06 89 ff ff       	call   80100380 <panic>
80107a7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107a80:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107a83:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107a89:	25 fc 0f 00 00       	and    $0xffc,%eax
80107a8e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107a95:	85 c0                	test   %eax,%eax
80107a97:	74 d4                	je     80107a6d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80107a99:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107a9b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80107a9e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107aa3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107aa8:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80107aae:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107ab1:	29 d9                	sub    %ebx,%ecx
80107ab3:	05 00 00 00 80       	add    $0x80000000,%eax
80107ab8:	57                   	push   %edi
80107ab9:	51                   	push   %ecx
80107aba:	50                   	push   %eax
80107abb:	ff 75 10             	push   0x10(%ebp)
80107abe:	e8 cd 9f ff ff       	call   80101a90 <readi>
80107ac3:	83 c4 10             	add    $0x10,%esp
80107ac6:	39 f8                	cmp    %edi,%eax
80107ac8:	75 1e                	jne    80107ae8 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107aca:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80107ad0:	89 f0                	mov    %esi,%eax
80107ad2:	29 d8                	sub    %ebx,%eax
80107ad4:	39 c6                	cmp    %eax,%esi
80107ad6:	77 80                	ja     80107a58 <loaduvm+0x38>
}
80107ad8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107adb:	31 c0                	xor    %eax,%eax
}
80107add:	5b                   	pop    %ebx
80107ade:	5e                   	pop    %esi
80107adf:	5f                   	pop    %edi
80107ae0:	5d                   	pop    %ebp
80107ae1:	c3                   	ret    
80107ae2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107ae8:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107aeb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107af0:	5b                   	pop    %ebx
80107af1:	5e                   	pop    %esi
80107af2:	5f                   	pop    %edi
80107af3:	5d                   	pop    %ebp
80107af4:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80107af5:	83 ec 0c             	sub    $0xc,%esp
80107af8:	68 68 8c 10 80       	push   $0x80108c68
80107afd:	e8 7e 88 ff ff       	call   80100380 <panic>
80107b02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107b10 <allocuvm>:
{
80107b10:	55                   	push   %ebp
80107b11:	89 e5                	mov    %esp,%ebp
80107b13:	57                   	push   %edi
80107b14:	56                   	push   %esi
80107b15:	53                   	push   %ebx
80107b16:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107b19:	8b 45 10             	mov    0x10(%ebp),%eax
{
80107b1c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80107b1f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107b22:	85 c0                	test   %eax,%eax
80107b24:	0f 88 b6 00 00 00    	js     80107be0 <allocuvm+0xd0>
  if(newsz < oldsz)
80107b2a:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80107b2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107b30:	0f 82 9a 00 00 00    	jb     80107bd0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80107b36:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107b3c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107b42:	39 75 10             	cmp    %esi,0x10(%ebp)
80107b45:	77 44                	ja     80107b8b <allocuvm+0x7b>
80107b47:	e9 87 00 00 00       	jmp    80107bd3 <allocuvm+0xc3>
80107b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80107b50:	83 ec 04             	sub    $0x4,%esp
80107b53:	68 00 10 00 00       	push   $0x1000
80107b58:	6a 00                	push   $0x0
80107b5a:	50                   	push   %eax
80107b5b:	e8 30 d8 ff ff       	call   80105390 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107b60:	58                   	pop    %eax
80107b61:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107b67:	5a                   	pop    %edx
80107b68:	6a 06                	push   $0x6
80107b6a:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107b6f:	89 f2                	mov    %esi,%edx
80107b71:	50                   	push   %eax
80107b72:	89 f8                	mov    %edi,%eax
80107b74:	e8 87 fb ff ff       	call   80107700 <mappages>
80107b79:	83 c4 10             	add    $0x10,%esp
80107b7c:	85 c0                	test   %eax,%eax
80107b7e:	78 78                	js     80107bf8 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107b80:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107b86:	39 75 10             	cmp    %esi,0x10(%ebp)
80107b89:	76 48                	jbe    80107bd3 <allocuvm+0xc3>
    mem = kalloc();
80107b8b:	e8 f0 aa ff ff       	call   80102680 <kalloc>
80107b90:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107b92:	85 c0                	test   %eax,%eax
80107b94:	75 ba                	jne    80107b50 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107b96:	83 ec 0c             	sub    $0xc,%esp
80107b99:	68 e5 8b 10 80       	push   $0x80108be5
80107b9e:	e8 fd 8a ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107ba3:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ba6:	83 c4 10             	add    $0x10,%esp
80107ba9:	39 45 10             	cmp    %eax,0x10(%ebp)
80107bac:	74 32                	je     80107be0 <allocuvm+0xd0>
80107bae:	8b 55 10             	mov    0x10(%ebp),%edx
80107bb1:	89 c1                	mov    %eax,%ecx
80107bb3:	89 f8                	mov    %edi,%eax
80107bb5:	e8 96 fa ff ff       	call   80107650 <deallocuvm.part.0>
      return 0;
80107bba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107bc1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107bc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107bc7:	5b                   	pop    %ebx
80107bc8:	5e                   	pop    %esi
80107bc9:	5f                   	pop    %edi
80107bca:	5d                   	pop    %ebp
80107bcb:	c3                   	ret    
80107bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107bd0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107bd3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107bd6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107bd9:	5b                   	pop    %ebx
80107bda:	5e                   	pop    %esi
80107bdb:	5f                   	pop    %edi
80107bdc:	5d                   	pop    %ebp
80107bdd:	c3                   	ret    
80107bde:	66 90                	xchg   %ax,%ax
    return 0;
80107be0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107be7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107bea:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107bed:	5b                   	pop    %ebx
80107bee:	5e                   	pop    %esi
80107bef:	5f                   	pop    %edi
80107bf0:	5d                   	pop    %ebp
80107bf1:	c3                   	ret    
80107bf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107bf8:	83 ec 0c             	sub    $0xc,%esp
80107bfb:	68 fd 8b 10 80       	push   $0x80108bfd
80107c00:	e8 9b 8a ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107c05:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c08:	83 c4 10             	add    $0x10,%esp
80107c0b:	39 45 10             	cmp    %eax,0x10(%ebp)
80107c0e:	74 0c                	je     80107c1c <allocuvm+0x10c>
80107c10:	8b 55 10             	mov    0x10(%ebp),%edx
80107c13:	89 c1                	mov    %eax,%ecx
80107c15:	89 f8                	mov    %edi,%eax
80107c17:	e8 34 fa ff ff       	call   80107650 <deallocuvm.part.0>
      kfree(mem);
80107c1c:	83 ec 0c             	sub    $0xc,%esp
80107c1f:	53                   	push   %ebx
80107c20:	e8 9b a8 ff ff       	call   801024c0 <kfree>
      return 0;
80107c25:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80107c2c:	83 c4 10             	add    $0x10,%esp
}
80107c2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107c32:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c35:	5b                   	pop    %ebx
80107c36:	5e                   	pop    %esi
80107c37:	5f                   	pop    %edi
80107c38:	5d                   	pop    %ebp
80107c39:	c3                   	ret    
80107c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107c40 <deallocuvm>:
{
80107c40:	55                   	push   %ebp
80107c41:	89 e5                	mov    %esp,%ebp
80107c43:	8b 55 0c             	mov    0xc(%ebp),%edx
80107c46:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107c49:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107c4c:	39 d1                	cmp    %edx,%ecx
80107c4e:	73 10                	jae    80107c60 <deallocuvm+0x20>
}
80107c50:	5d                   	pop    %ebp
80107c51:	e9 fa f9 ff ff       	jmp    80107650 <deallocuvm.part.0>
80107c56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c5d:	8d 76 00             	lea    0x0(%esi),%esi
80107c60:	89 d0                	mov    %edx,%eax
80107c62:	5d                   	pop    %ebp
80107c63:	c3                   	ret    
80107c64:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107c6f:	90                   	nop

80107c70 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107c70:	55                   	push   %ebp
80107c71:	89 e5                	mov    %esp,%ebp
80107c73:	57                   	push   %edi
80107c74:	56                   	push   %esi
80107c75:	53                   	push   %ebx
80107c76:	83 ec 0c             	sub    $0xc,%esp
80107c79:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107c7c:	85 f6                	test   %esi,%esi
80107c7e:	74 59                	je     80107cd9 <freevm+0x69>
  if(newsz >= oldsz)
80107c80:	31 c9                	xor    %ecx,%ecx
80107c82:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107c87:	89 f0                	mov    %esi,%eax
80107c89:	89 f3                	mov    %esi,%ebx
80107c8b:	e8 c0 f9 ff ff       	call   80107650 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107c90:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107c96:	eb 0f                	jmp    80107ca7 <freevm+0x37>
80107c98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c9f:	90                   	nop
80107ca0:	83 c3 04             	add    $0x4,%ebx
80107ca3:	39 df                	cmp    %ebx,%edi
80107ca5:	74 23                	je     80107cca <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107ca7:	8b 03                	mov    (%ebx),%eax
80107ca9:	a8 01                	test   $0x1,%al
80107cab:	74 f3                	je     80107ca0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107cad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107cb2:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107cb5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107cb8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80107cbd:	50                   	push   %eax
80107cbe:	e8 fd a7 ff ff       	call   801024c0 <kfree>
80107cc3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107cc6:	39 df                	cmp    %ebx,%edi
80107cc8:	75 dd                	jne    80107ca7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80107cca:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107ccd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107cd0:	5b                   	pop    %ebx
80107cd1:	5e                   	pop    %esi
80107cd2:	5f                   	pop    %edi
80107cd3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107cd4:	e9 e7 a7 ff ff       	jmp    801024c0 <kfree>
    panic("freevm: no pgdir");
80107cd9:	83 ec 0c             	sub    $0xc,%esp
80107cdc:	68 19 8c 10 80       	push   $0x80108c19
80107ce1:	e8 9a 86 ff ff       	call   80100380 <panic>
80107ce6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107ced:	8d 76 00             	lea    0x0(%esi),%esi

80107cf0 <setupkvm>:
{
80107cf0:	55                   	push   %ebp
80107cf1:	89 e5                	mov    %esp,%ebp
80107cf3:	56                   	push   %esi
80107cf4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107cf5:	e8 86 a9 ff ff       	call   80102680 <kalloc>
80107cfa:	89 c6                	mov    %eax,%esi
80107cfc:	85 c0                	test   %eax,%eax
80107cfe:	74 42                	je     80107d42 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107d00:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107d03:	bb 40 b4 10 80       	mov    $0x8010b440,%ebx
  memset(pgdir, 0, PGSIZE);
80107d08:	68 00 10 00 00       	push   $0x1000
80107d0d:	6a 00                	push   $0x0
80107d0f:	50                   	push   %eax
80107d10:	e8 7b d6 ff ff       	call   80105390 <memset>
80107d15:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107d18:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107d1b:	83 ec 08             	sub    $0x8,%esp
80107d1e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107d21:	ff 73 0c             	push   0xc(%ebx)
80107d24:	8b 13                	mov    (%ebx),%edx
80107d26:	50                   	push   %eax
80107d27:	29 c1                	sub    %eax,%ecx
80107d29:	89 f0                	mov    %esi,%eax
80107d2b:	e8 d0 f9 ff ff       	call   80107700 <mappages>
80107d30:	83 c4 10             	add    $0x10,%esp
80107d33:	85 c0                	test   %eax,%eax
80107d35:	78 19                	js     80107d50 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107d37:	83 c3 10             	add    $0x10,%ebx
80107d3a:	81 fb 80 b4 10 80    	cmp    $0x8010b480,%ebx
80107d40:	75 d6                	jne    80107d18 <setupkvm+0x28>
}
80107d42:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107d45:	89 f0                	mov    %esi,%eax
80107d47:	5b                   	pop    %ebx
80107d48:	5e                   	pop    %esi
80107d49:	5d                   	pop    %ebp
80107d4a:	c3                   	ret    
80107d4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107d4f:	90                   	nop
      freevm(pgdir);
80107d50:	83 ec 0c             	sub    $0xc,%esp
80107d53:	56                   	push   %esi
      return 0;
80107d54:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107d56:	e8 15 ff ff ff       	call   80107c70 <freevm>
      return 0;
80107d5b:	83 c4 10             	add    $0x10,%esp
}
80107d5e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107d61:	89 f0                	mov    %esi,%eax
80107d63:	5b                   	pop    %ebx
80107d64:	5e                   	pop    %esi
80107d65:	5d                   	pop    %ebp
80107d66:	c3                   	ret    
80107d67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107d6e:	66 90                	xchg   %ax,%ax

80107d70 <kvmalloc>:
{
80107d70:	55                   	push   %ebp
80107d71:	89 e5                	mov    %esp,%ebp
80107d73:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107d76:	e8 75 ff ff ff       	call   80107cf0 <setupkvm>
80107d7b:	a3 e4 6d 11 80       	mov    %eax,0x80116de4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107d80:	05 00 00 00 80       	add    $0x80000000,%eax
80107d85:	0f 22 d8             	mov    %eax,%cr3
}
80107d88:	c9                   	leave  
80107d89:	c3                   	ret    
80107d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107d90 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107d90:	55                   	push   %ebp
80107d91:	89 e5                	mov    %esp,%ebp
80107d93:	83 ec 08             	sub    $0x8,%esp
80107d96:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107d99:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107d9c:	89 c1                	mov    %eax,%ecx
80107d9e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107da1:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107da4:	f6 c2 01             	test   $0x1,%dl
80107da7:	75 17                	jne    80107dc0 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107da9:	83 ec 0c             	sub    $0xc,%esp
80107dac:	68 2a 8c 10 80       	push   $0x80108c2a
80107db1:	e8 ca 85 ff ff       	call   80100380 <panic>
80107db6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107dbd:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107dc0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107dc3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107dc9:	25 fc 0f 00 00       	and    $0xffc,%eax
80107dce:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107dd5:	85 c0                	test   %eax,%eax
80107dd7:	74 d0                	je     80107da9 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107dd9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107ddc:	c9                   	leave  
80107ddd:	c3                   	ret    
80107dde:	66 90                	xchg   %ax,%ax

80107de0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107de0:	55                   	push   %ebp
80107de1:	89 e5                	mov    %esp,%ebp
80107de3:	57                   	push   %edi
80107de4:	56                   	push   %esi
80107de5:	53                   	push   %ebx
80107de6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107de9:	e8 02 ff ff ff       	call   80107cf0 <setupkvm>
80107dee:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107df1:	85 c0                	test   %eax,%eax
80107df3:	0f 84 bd 00 00 00    	je     80107eb6 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107df9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107dfc:	85 c9                	test   %ecx,%ecx
80107dfe:	0f 84 b2 00 00 00    	je     80107eb6 <copyuvm+0xd6>
80107e04:	31 f6                	xor    %esi,%esi
80107e06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107e0d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80107e10:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107e13:	89 f0                	mov    %esi,%eax
80107e15:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107e18:	8b 04 81             	mov    (%ecx,%eax,4),%eax
80107e1b:	a8 01                	test   $0x1,%al
80107e1d:	75 11                	jne    80107e30 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80107e1f:	83 ec 0c             	sub    $0xc,%esp
80107e22:	68 34 8c 10 80       	push   $0x80108c34
80107e27:	e8 54 85 ff ff       	call   80100380 <panic>
80107e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107e30:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107e32:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107e37:	c1 ea 0a             	shr    $0xa,%edx
80107e3a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107e40:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107e47:	85 c0                	test   %eax,%eax
80107e49:	74 d4                	je     80107e1f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
80107e4b:	8b 00                	mov    (%eax),%eax
80107e4d:	a8 01                	test   $0x1,%al
80107e4f:	0f 84 9f 00 00 00    	je     80107ef4 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107e55:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107e57:	25 ff 0f 00 00       	and    $0xfff,%eax
80107e5c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107e5f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107e65:	e8 16 a8 ff ff       	call   80102680 <kalloc>
80107e6a:	89 c3                	mov    %eax,%ebx
80107e6c:	85 c0                	test   %eax,%eax
80107e6e:	74 64                	je     80107ed4 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107e70:	83 ec 04             	sub    $0x4,%esp
80107e73:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107e79:	68 00 10 00 00       	push   $0x1000
80107e7e:	57                   	push   %edi
80107e7f:	50                   	push   %eax
80107e80:	e8 ab d5 ff ff       	call   80105430 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107e85:	58                   	pop    %eax
80107e86:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107e8c:	5a                   	pop    %edx
80107e8d:	ff 75 e4             	push   -0x1c(%ebp)
80107e90:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107e95:	89 f2                	mov    %esi,%edx
80107e97:	50                   	push   %eax
80107e98:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107e9b:	e8 60 f8 ff ff       	call   80107700 <mappages>
80107ea0:	83 c4 10             	add    $0x10,%esp
80107ea3:	85 c0                	test   %eax,%eax
80107ea5:	78 21                	js     80107ec8 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107ea7:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107ead:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107eb0:	0f 87 5a ff ff ff    	ja     80107e10 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107eb6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107eb9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107ebc:	5b                   	pop    %ebx
80107ebd:	5e                   	pop    %esi
80107ebe:	5f                   	pop    %edi
80107ebf:	5d                   	pop    %ebp
80107ec0:	c3                   	ret    
80107ec1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107ec8:	83 ec 0c             	sub    $0xc,%esp
80107ecb:	53                   	push   %ebx
80107ecc:	e8 ef a5 ff ff       	call   801024c0 <kfree>
      goto bad;
80107ed1:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107ed4:	83 ec 0c             	sub    $0xc,%esp
80107ed7:	ff 75 e0             	push   -0x20(%ebp)
80107eda:	e8 91 fd ff ff       	call   80107c70 <freevm>
  return 0;
80107edf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107ee6:	83 c4 10             	add    $0x10,%esp
}
80107ee9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107eec:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107eef:	5b                   	pop    %ebx
80107ef0:	5e                   	pop    %esi
80107ef1:	5f                   	pop    %edi
80107ef2:	5d                   	pop    %ebp
80107ef3:	c3                   	ret    
      panic("copyuvm: page not present");
80107ef4:	83 ec 0c             	sub    $0xc,%esp
80107ef7:	68 4e 8c 10 80       	push   $0x80108c4e
80107efc:	e8 7f 84 ff ff       	call   80100380 <panic>
80107f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107f08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107f0f:	90                   	nop

80107f10 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107f10:	55                   	push   %ebp
80107f11:	89 e5                	mov    %esp,%ebp
80107f13:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107f16:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107f19:	89 c1                	mov    %eax,%ecx
80107f1b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107f1e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107f21:	f6 c2 01             	test   $0x1,%dl
80107f24:	0f 84 00 01 00 00    	je     8010802a <uva2ka.cold>
  return &pgtab[PTX(va)];
80107f2a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107f2d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107f33:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107f34:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107f39:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80107f40:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107f42:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107f47:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107f4a:	05 00 00 00 80       	add    $0x80000000,%eax
80107f4f:	83 fa 05             	cmp    $0x5,%edx
80107f52:	ba 00 00 00 00       	mov    $0x0,%edx
80107f57:	0f 45 c2             	cmovne %edx,%eax
}
80107f5a:	c3                   	ret    
80107f5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107f5f:	90                   	nop

80107f60 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107f60:	55                   	push   %ebp
80107f61:	89 e5                	mov    %esp,%ebp
80107f63:	57                   	push   %edi
80107f64:	56                   	push   %esi
80107f65:	53                   	push   %ebx
80107f66:	83 ec 0c             	sub    $0xc,%esp
80107f69:	8b 75 14             	mov    0x14(%ebp),%esi
80107f6c:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f6f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107f72:	85 f6                	test   %esi,%esi
80107f74:	75 51                	jne    80107fc7 <copyout+0x67>
80107f76:	e9 a5 00 00 00       	jmp    80108020 <copyout+0xc0>
80107f7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107f7f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107f80:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107f86:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
80107f8c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107f92:	74 75                	je     80108009 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107f94:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107f96:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107f99:	29 c3                	sub    %eax,%ebx
80107f9b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107fa1:	39 f3                	cmp    %esi,%ebx
80107fa3:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80107fa6:	29 f8                	sub    %edi,%eax
80107fa8:	83 ec 04             	sub    $0x4,%esp
80107fab:	01 c1                	add    %eax,%ecx
80107fad:	53                   	push   %ebx
80107fae:	52                   	push   %edx
80107faf:	51                   	push   %ecx
80107fb0:	e8 7b d4 ff ff       	call   80105430 <memmove>
    len -= n;
    buf += n;
80107fb5:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107fb8:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
80107fbe:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107fc1:	01 da                	add    %ebx,%edx
  while(len > 0){
80107fc3:	29 de                	sub    %ebx,%esi
80107fc5:	74 59                	je     80108020 <copyout+0xc0>
  if(*pde & PTE_P){
80107fc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
80107fca:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107fcc:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
80107fce:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107fd1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107fd7:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
80107fda:	f6 c1 01             	test   $0x1,%cl
80107fdd:	0f 84 4e 00 00 00    	je     80108031 <copyout.cold>
  return &pgtab[PTX(va)];
80107fe3:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107fe5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107feb:	c1 eb 0c             	shr    $0xc,%ebx
80107fee:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107ff4:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
80107ffb:	89 d9                	mov    %ebx,%ecx
80107ffd:	83 e1 05             	and    $0x5,%ecx
80108000:	83 f9 05             	cmp    $0x5,%ecx
80108003:	0f 84 77 ff ff ff    	je     80107f80 <copyout+0x20>
  }
  return 0;
}
80108009:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010800c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108011:	5b                   	pop    %ebx
80108012:	5e                   	pop    %esi
80108013:	5f                   	pop    %edi
80108014:	5d                   	pop    %ebp
80108015:	c3                   	ret    
80108016:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010801d:	8d 76 00             	lea    0x0(%esi),%esi
80108020:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80108023:	31 c0                	xor    %eax,%eax
}
80108025:	5b                   	pop    %ebx
80108026:	5e                   	pop    %esi
80108027:	5f                   	pop    %edi
80108028:	5d                   	pop    %ebp
80108029:	c3                   	ret    

8010802a <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
8010802a:	a1 00 00 00 00       	mov    0x0,%eax
8010802f:	0f 0b                	ud2    

80108031 <copyout.cold>:
80108031:	a1 00 00 00 00       	mov    0x0,%eax
80108036:	0f 0b                	ud2    
