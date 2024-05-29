
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
80100028:	bc f0 7a 11 80       	mov    $0x80117af0,%esp

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
8010004c:	68 e0 7a 10 80       	push   $0x80107ae0
80100051:	68 40 b5 10 80       	push   $0x8010b540
80100056:	e8 15 4c 00 00       	call   80104c70 <initlock>
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
80100092:	68 e7 7a 10 80       	push   $0x80107ae7
80100097:	50                   	push   %eax
80100098:	e8 a3 4a 00 00       	call   80104b40 <initsleeplock>
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
801000e4:	e8 57 4d 00 00       	call   80104e40 <acquire>
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
80100162:	e8 79 4c 00 00       	call   80104de0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 0e 4a 00 00       	call   80104b80 <acquiresleep>
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
801001a1:	68 ee 7a 10 80       	push   $0x80107aee
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
801001be:	e8 5d 4a 00 00       	call   80104c20 <holdingsleep>
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
801001dc:	68 ff 7a 10 80       	push   $0x80107aff
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
801001ff:	e8 1c 4a 00 00       	call   80104c20 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 cc 49 00 00       	call   80104be0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 40 b5 10 80 	movl   $0x8010b540,(%esp)
8010021b:	e8 20 4c 00 00       	call   80104e40 <acquire>
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
8010026c:	e9 6f 4b 00 00       	jmp    80104de0 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 06 7b 10 80       	push   $0x80107b06
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
801002a0:	e8 9b 4b 00 00       	call   80104e40 <acquire>
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
801002cd:	e8 de 43 00 00       	call   801046b0 <sleep>
    while(input.r == input.w){
801002d2:	a1 20 ff 10 80       	mov    0x8010ff20,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 24 ff 10 80    	cmp    0x8010ff24,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 19 39 00 00       	call   80103c00 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 40 ff 10 80       	push   $0x8010ff40
801002f6:	e8 e5 4a 00 00       	call   80104de0 <release>
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
8010034c:	e8 8f 4a 00 00       	call   80104de0 <release>
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
801003a2:	68 0d 7b 10 80       	push   $0x80107b0d
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 c3 85 10 80 	movl   $0x801085c3,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 c3 48 00 00       	call   80104c90 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 21 7b 10 80       	push   $0x80107b21
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
8010041a:	e8 e1 61 00 00       	call   80106600 <uartputc>
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
80100505:	e8 f6 60 00 00       	call   80106600 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 ea 60 00 00       	call   80106600 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 de 60 00 00       	call   80106600 <uartputc>
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
80100551:	e8 4a 4a 00 00       	call   80104fa0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 95 49 00 00       	call   80104f00 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 25 7b 10 80       	push   $0x80107b25
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
801005ab:	e8 90 48 00 00       	call   80104e40 <acquire>
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
801005e4:	e8 f7 47 00 00       	call   80104de0 <release>
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
80100636:	0f b6 92 50 7b 10 80 	movzbl -0x7fef84b0(%edx),%edx
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
801007e8:	e8 53 46 00 00       	call   80104e40 <acquire>
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
80100838:	bf 38 7b 10 80       	mov    $0x80107b38,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 40 ff 10 80       	push   $0x8010ff40
8010085b:	e8 80 45 00 00       	call   80104de0 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 3f 7b 10 80       	push   $0x80107b3f
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
80100893:	e8 a8 45 00 00       	call   80104e40 <acquire>
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
801009d0:	e8 0b 44 00 00       	call   80104de0 <release>
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
80100a0e:	e9 7d 3e 00 00       	jmp    80104890 <procdump>
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
80100a44:	e8 27 3d 00 00       	call   80104770 <wakeup>
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
80100a66:	68 48 7b 10 80       	push   $0x80107b48
80100a6b:	68 40 ff 10 80       	push   $0x8010ff40
80100a70:	e8 fb 41 00 00       	call   80104c70 <initlock>

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
80100abc:	e8 3f 31 00 00       	call   80103c00 <myproc>
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
80100b34:	e8 57 6c 00 00       	call   80107790 <setupkvm>
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
80100ba3:	e8 08 6a 00 00       	call   801075b0 <allocuvm>
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
80100bd9:	e8 e2 68 00 00       	call   801074c0 <loaduvm>
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
80100c1b:	e8 f0 6a 00 00       	call   80107710 <freevm>
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
80100c62:	e8 49 69 00 00       	call   801075b0 <allocuvm>
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
80100c83:	e8 a8 6b 00 00       	call   80107830 <clearpteu>
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
80100cd3:	e8 28 44 00 00       	call   80105100 <strlen>
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
80100ce7:	e8 14 44 00 00       	call   80105100 <strlen>
80100cec:	83 c0 01             	add    $0x1,%eax
80100cef:	50                   	push   %eax
80100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf3:	ff 34 b8             	push   (%eax,%edi,4)
80100cf6:	53                   	push   %ebx
80100cf7:	56                   	push   %esi
80100cf8:	e8 03 6d 00 00       	call   80107a00 <copyout>
80100cfd:	83 c4 20             	add    $0x20,%esp
80100d00:	85 c0                	test   %eax,%eax
80100d02:	79 ac                	jns    80100cb0 <exec+0x200>
80100d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d08:	83 ec 0c             	sub    $0xc,%esp
80100d0b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d11:	e8 fa 69 00 00       	call   80107710 <freevm>
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
80100d63:	e8 98 6c 00 00       	call   80107a00 <copyout>
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
80100d9d:	83 c0 6c             	add    $0x6c,%eax
80100da0:	50                   	push   %eax
80100da1:	e8 1a 43 00 00       	call   801050c0 <safestrcpy>
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
80100dbe:	8b 40 18             	mov    0x18(%eax),%eax
80100dc1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100dc4:	8b 41 18             	mov    0x18(%ecx),%eax
80100dc7:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100dca:	89 0c 24             	mov    %ecx,(%esp)
80100dcd:	e8 5e 65 00 00       	call   80107330 <switchuvm>
  freevm(oldpgdir);
80100dd2:	89 3c 24             	mov    %edi,(%esp)
80100dd5:	e8 36 69 00 00       	call   80107710 <freevm>
  return 0;
80100dda:	83 c4 10             	add    $0x10,%esp
80100ddd:	31 c0                	xor    %eax,%eax
80100ddf:	e9 38 fd ff ff       	jmp    80100b1c <exec+0x6c>
    end_op();
80100de4:	e8 e7 1f 00 00       	call   80102dd0 <end_op>
    cprintf("exec: fail\n");
80100de9:	83 ec 0c             	sub    $0xc,%esp
80100dec:	68 61 7b 10 80       	push   $0x80107b61
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
80100e16:	68 6d 7b 10 80       	push   $0x80107b6d
80100e1b:	68 80 ff 10 80       	push   $0x8010ff80
80100e20:	e8 4b 3e 00 00       	call   80104c70 <initlock>
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
80100e41:	e8 fa 3f 00 00       	call   80104e40 <acquire>
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
80100e71:	e8 6a 3f 00 00       	call   80104de0 <release>
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
80100e8a:	e8 51 3f 00 00       	call   80104de0 <release>
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
80100eaf:	e8 8c 3f 00 00       	call   80104e40 <acquire>
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
80100ecc:	e8 0f 3f 00 00       	call   80104de0 <release>
  return f;
}
80100ed1:	89 d8                	mov    %ebx,%eax
80100ed3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ed6:	c9                   	leave  
80100ed7:	c3                   	ret    
    panic("filedup");
80100ed8:	83 ec 0c             	sub    $0xc,%esp
80100edb:	68 74 7b 10 80       	push   $0x80107b74
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
80100f01:	e8 3a 3f 00 00       	call   80104e40 <acquire>
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
80100f3c:	e8 9f 3e 00 00       	call   80104de0 <release>

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
80100f6e:	e9 6d 3e 00 00       	jmp    80104de0 <release>
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
80100fbc:	68 7c 7b 10 80       	push   $0x80107b7c
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
801010a2:	68 86 7b 10 80       	push   $0x80107b86
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
80101177:	68 8f 7b 10 80       	push   $0x80107b8f
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
801011b1:	68 95 7b 10 80       	push   $0x80107b95
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
80101227:	68 9f 7b 10 80       	push   $0x80107b9f
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
801012e4:	68 b2 7b 10 80       	push   $0x80107bb2
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
80101325:	e8 d6 3b 00 00       	call   80104f00 <memset>
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
8010136a:	e8 d1 3a 00 00       	call   80104e40 <acquire>
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
801013d7:	e8 04 3a 00 00       	call   80104de0 <release>

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
80101405:	e8 d6 39 00 00       	call   80104de0 <release>
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
80101438:	68 c8 7b 10 80       	push   $0x80107bc8
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
80101515:	68 d8 7b 10 80       	push   $0x80107bd8
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
80101541:	e8 5a 3a 00 00       	call   80104fa0 <memmove>
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
8010156c:	68 eb 7b 10 80       	push   $0x80107beb
80101571:	68 80 09 11 80       	push   $0x80110980
80101576:	e8 f5 36 00 00       	call   80104c70 <initlock>
  for(i = 0; i < NINODE; i++) {
8010157b:	83 c4 10             	add    $0x10,%esp
8010157e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101580:	83 ec 08             	sub    $0x8,%esp
80101583:	68 f2 7b 10 80       	push   $0x80107bf2
80101588:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101589:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010158f:	e8 ac 35 00 00       	call   80104b40 <initsleeplock>
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
801015bc:	e8 df 39 00 00       	call   80104fa0 <memmove>
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
801015f3:	68 58 7c 10 80       	push   $0x80107c58
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
8010168e:	e8 6d 38 00 00       	call   80104f00 <memset>
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
801016c3:	68 f8 7b 10 80       	push   $0x80107bf8
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
80101731:	e8 6a 38 00 00       	call   80104fa0 <memmove>
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
8010175f:	e8 dc 36 00 00       	call   80104e40 <acquire>
  ip->ref++;
80101764:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101768:	c7 04 24 80 09 11 80 	movl   $0x80110980,(%esp)
8010176f:	e8 6c 36 00 00       	call   80104de0 <release>
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
801017a2:	e8 d9 33 00 00       	call   80104b80 <acquiresleep>
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
80101818:	e8 83 37 00 00       	call   80104fa0 <memmove>
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
8010183d:	68 10 7c 10 80       	push   $0x80107c10
80101842:	e8 39 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101847:	83 ec 0c             	sub    $0xc,%esp
8010184a:	68 0a 7c 10 80       	push   $0x80107c0a
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
80101873:	e8 a8 33 00 00       	call   80104c20 <holdingsleep>
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
8010188f:	e9 4c 33 00 00       	jmp    80104be0 <releasesleep>
    panic("iunlock");
80101894:	83 ec 0c             	sub    $0xc,%esp
80101897:	68 1f 7c 10 80       	push   $0x80107c1f
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
801018c0:	e8 bb 32 00 00       	call   80104b80 <acquiresleep>
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
801018da:	e8 01 33 00 00       	call   80104be0 <releasesleep>
  acquire(&icache.lock);
801018df:	c7 04 24 80 09 11 80 	movl   $0x80110980,(%esp)
801018e6:	e8 55 35 00 00       	call   80104e40 <acquire>
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
80101900:	e9 db 34 00 00       	jmp    80104de0 <release>
80101905:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101908:	83 ec 0c             	sub    $0xc,%esp
8010190b:	68 80 09 11 80       	push   $0x80110980
80101910:	e8 2b 35 00 00       	call   80104e40 <acquire>
    int r = ip->ref;
80101915:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101918:	c7 04 24 80 09 11 80 	movl   $0x80110980,(%esp)
8010191f:	e8 bc 34 00 00       	call   80104de0 <release>
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
80101a23:	e8 f8 31 00 00       	call   80104c20 <holdingsleep>
80101a28:	83 c4 10             	add    $0x10,%esp
80101a2b:	85 c0                	test   %eax,%eax
80101a2d:	74 21                	je     80101a50 <iunlockput+0x40>
80101a2f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a32:	85 c0                	test   %eax,%eax
80101a34:	7e 1a                	jle    80101a50 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a36:	83 ec 0c             	sub    $0xc,%esp
80101a39:	56                   	push   %esi
80101a3a:	e8 a1 31 00 00       	call   80104be0 <releasesleep>
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
80101a53:	68 1f 7c 10 80       	push   $0x80107c1f
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
80101b37:	e8 64 34 00 00       	call   80104fa0 <memmove>
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
80101c33:	e8 68 33 00 00       	call   80104fa0 <memmove>
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
80101cce:	e8 3d 33 00 00       	call   80105010 <strncmp>
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
80101d2d:	e8 de 32 00 00       	call   80105010 <strncmp>
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
80101d72:	68 39 7c 10 80       	push   $0x80107c39
80101d77:	e8 04 e6 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d7c:	83 ec 0c             	sub    $0xc,%esp
80101d7f:	68 27 7c 10 80       	push   $0x80107c27
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
80101daa:	e8 51 1e 00 00       	call   80103c00 <myproc>
  acquire(&icache.lock);
80101daf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101db2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101db5:	68 80 09 11 80       	push   $0x80110980
80101dba:	e8 81 30 00 00       	call   80104e40 <acquire>
  ip->ref++;
80101dbf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dc3:	c7 04 24 80 09 11 80 	movl   $0x80110980,(%esp)
80101dca:	e8 11 30 00 00       	call   80104de0 <release>
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
80101e27:	e8 74 31 00 00       	call   80104fa0 <memmove>
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
80101e8c:	e8 8f 2d 00 00       	call   80104c20 <holdingsleep>
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
80101eae:	e8 2d 2d 00 00       	call   80104be0 <releasesleep>
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
80101edb:	e8 c0 30 00 00       	call   80104fa0 <memmove>
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
80101f2b:	e8 f0 2c 00 00       	call   80104c20 <holdingsleep>
80101f30:	83 c4 10             	add    $0x10,%esp
80101f33:	85 c0                	test   %eax,%eax
80101f35:	0f 84 91 00 00 00    	je     80101fcc <namex+0x23c>
80101f3b:	8b 46 08             	mov    0x8(%esi),%eax
80101f3e:	85 c0                	test   %eax,%eax
80101f40:	0f 8e 86 00 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f46:	83 ec 0c             	sub    $0xc,%esp
80101f49:	53                   	push   %ebx
80101f4a:	e8 91 2c 00 00       	call   80104be0 <releasesleep>
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
80101f6d:	e8 ae 2c 00 00       	call   80104c20 <holdingsleep>
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
80101f90:	e8 8b 2c 00 00       	call   80104c20 <holdingsleep>
80101f95:	83 c4 10             	add    $0x10,%esp
80101f98:	85 c0                	test   %eax,%eax
80101f9a:	74 30                	je     80101fcc <namex+0x23c>
80101f9c:	8b 7e 08             	mov    0x8(%esi),%edi
80101f9f:	85 ff                	test   %edi,%edi
80101fa1:	7e 29                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101fa3:	83 ec 0c             	sub    $0xc,%esp
80101fa6:	53                   	push   %ebx
80101fa7:	e8 34 2c 00 00       	call   80104be0 <releasesleep>
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
80101fcf:	68 1f 7c 10 80       	push   $0x80107c1f
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
8010203d:	e8 1e 30 00 00       	call   80105060 <strncpy>
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
8010207b:	68 48 7c 10 80       	push   $0x80107c48
80102080:	e8 fb e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102085:	83 ec 0c             	sub    $0xc,%esp
80102088:	68 a6 83 10 80       	push   $0x801083a6
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
8010219b:	68 b4 7c 10 80       	push   $0x80107cb4
801021a0:	e8 db e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021a5:	83 ec 0c             	sub    $0xc,%esp
801021a8:	68 ab 7c 10 80       	push   $0x80107cab
801021ad:	e8 ce e1 ff ff       	call   80100380 <panic>
801021b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021c0 <ideinit>:
{
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021c6:	68 c6 7c 10 80       	push   $0x80107cc6
801021cb:	68 20 26 11 80       	push   $0x80112620
801021d0:	e8 9b 2a 00 00       	call   80104c70 <initlock>
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
8010224e:	e8 ed 2b 00 00       	call   80104e40 <acquire>

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
801022ad:	e8 be 24 00 00       	call   80104770 <wakeup>

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
801022cb:	e8 10 2b 00 00       	call   80104de0 <release>

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
801022ee:	e8 2d 29 00 00       	call   80104c20 <holdingsleep>
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
80102328:	e8 13 2b 00 00       	call   80104e40 <acquire>

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
80102369:	e8 42 23 00 00       	call   801046b0 <sleep>
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
80102386:	e9 55 2a 00 00       	jmp    80104de0 <release>
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
801023aa:	68 f5 7c 10 80       	push   $0x80107cf5
801023af:	e8 cc df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023b4:	83 ec 0c             	sub    $0xc,%esp
801023b7:	68 e0 7c 10 80       	push   $0x80107ce0
801023bc:	e8 bf df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023c1:	83 ec 0c             	sub    $0xc,%esp
801023c4:	68 ca 7c 10 80       	push   $0x80107cca
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
8010241a:	68 14 7d 10 80       	push   $0x80107d14
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
801024d2:	81 fb f0 7a 11 80    	cmp    $0x80117af0,%ebx
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
801024f2:	e8 09 2a 00 00       	call   80104f00 <memset>

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
80102528:	e8 13 29 00 00       	call   80104e40 <acquire>
8010252d:	83 c4 10             	add    $0x10,%esp
80102530:	eb d2                	jmp    80102504 <kfree+0x44>
80102532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102538:	c7 45 08 60 26 11 80 	movl   $0x80112660,0x8(%ebp)
}
8010253f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102542:	c9                   	leave  
    release(&kmem.lock);
80102543:	e9 98 28 00 00       	jmp    80104de0 <release>
    panic("kfree");
80102548:	83 ec 0c             	sub    $0xc,%esp
8010254b:	68 46 7d 10 80       	push   $0x80107d46
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
8010261b:	68 4c 7d 10 80       	push   $0x80107d4c
80102620:	68 60 26 11 80       	push   $0x80112660
80102625:	e8 46 26 00 00       	call   80104c70 <initlock>
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
801026b3:	e8 88 27 00 00       	call   80104e40 <acquire>
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
801026e1:	e8 fa 26 00 00       	call   80104de0 <release>
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
8010272b:	0f b6 91 80 7e 10 80 	movzbl -0x7fef8180(%ecx),%edx
  shift ^= togglecode[data];
80102732:	0f b6 81 80 7d 10 80 	movzbl -0x7fef8280(%ecx),%eax
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
8010274b:	8b 04 85 60 7d 10 80 	mov    -0x7fef82a0(,%eax,4),%eax
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
80102788:	0f b6 81 80 7e 10 80 	movzbl -0x7fef8180(%ecx),%eax
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
80102af7:	e8 54 24 00 00       	call   80104f50 <memcmp>
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
80102c24:	e8 77 23 00 00       	call   80104fa0 <memmove>
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
80102cca:	68 80 7f 10 80       	push   $0x80107f80
80102ccf:	68 c0 26 11 80       	push   $0x801126c0
80102cd4:	e8 97 1f 00 00       	call   80104c70 <initlock>
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
80102d6b:	e8 d0 20 00 00       	call   80104e40 <acquire>
80102d70:	83 c4 10             	add    $0x10,%esp
80102d73:	eb 18                	jmp    80102d8d <begin_op+0x2d>
80102d75:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d78:	83 ec 08             	sub    $0x8,%esp
80102d7b:	68 c0 26 11 80       	push   $0x801126c0
80102d80:	68 c0 26 11 80       	push   $0x801126c0
80102d85:	e8 26 19 00 00       	call   801046b0 <sleep>
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
80102dbc:	e8 1f 20 00 00       	call   80104de0 <release>
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
80102dde:	e8 5d 20 00 00       	call   80104e40 <acquire>
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
80102e1c:	e8 bf 1f 00 00       	call   80104de0 <release>
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
80102e36:	e8 05 20 00 00       	call   80104e40 <acquire>
    wakeup(&log);
80102e3b:	c7 04 24 c0 26 11 80 	movl   $0x801126c0,(%esp)
    log.committing = 0;
80102e42:	c7 05 00 27 11 80 00 	movl   $0x0,0x80112700
80102e49:	00 00 00 
    wakeup(&log);
80102e4c:	e8 1f 19 00 00       	call   80104770 <wakeup>
    release(&log.lock);
80102e51:	c7 04 24 c0 26 11 80 	movl   $0x801126c0,(%esp)
80102e58:	e8 83 1f 00 00       	call   80104de0 <release>
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
80102eb4:	e8 e7 20 00 00       	call   80104fa0 <memmove>
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
80102f08:	e8 63 18 00 00       	call   80104770 <wakeup>
  release(&log.lock);
80102f0d:	c7 04 24 c0 26 11 80 	movl   $0x801126c0,(%esp)
80102f14:	e8 c7 1e 00 00       	call   80104de0 <release>
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
80102f27:	68 84 7f 10 80       	push   $0x80107f84
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
80102f76:	e8 c5 1e 00 00       	call   80104e40 <acquire>
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
80102fb5:	e9 26 1e 00 00       	jmp    80104de0 <release>
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
80102fe1:	68 93 7f 10 80       	push   $0x80107f93
80102fe6:	e8 95 d3 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
80102feb:	83 ec 0c             	sub    $0xc,%esp
80102fee:	68 a9 7f 10 80       	push   $0x80107fa9
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
80103007:	e8 d4 0b 00 00       	call   80103be0 <cpuid>
8010300c:	89 c3                	mov    %eax,%ebx
8010300e:	e8 cd 0b 00 00       	call   80103be0 <cpuid>
80103013:	83 ec 04             	sub    $0x4,%esp
80103016:	53                   	push   %ebx
80103017:	50                   	push   %eax
80103018:	68 c4 7f 10 80       	push   $0x80107fc4
8010301d:	e8 7e d6 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80103022:	e8 b9 31 00 00       	call   801061e0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103027:	e8 54 0b 00 00       	call   80103b80 <mycpu>
8010302c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010302e:	b8 01 00 00 00       	mov    $0x1,%eax
80103033:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010303a:	e8 31 0f 00 00       	call   80103f70 <scheduler>
8010303f:	90                   	nop

80103040 <mpenter>:
{
80103040:	55                   	push   %ebp
80103041:	89 e5                	mov    %esp,%ebp
80103043:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103046:	e8 d5 42 00 00       	call   80107320 <switchkvm>
  seginit();
8010304b:	e8 40 42 00 00       	call   80107290 <seginit>
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
80103077:	68 f0 7a 11 80       	push   $0x80117af0
8010307c:	e8 8f f5 ff ff       	call   80102610 <kinit1>
  kvmalloc();      // kernel page table
80103081:	e8 8a 47 00 00       	call   80107810 <kvmalloc>
  mpinit();        // detect other processors
80103086:	e8 85 01 00 00       	call   80103210 <mpinit>
  lapicinit();     // interrupt controller
8010308b:	e8 60 f7 ff ff       	call   801027f0 <lapicinit>
  seginit();       // segment descriptors
80103090:	e8 fb 41 00 00       	call   80107290 <seginit>
  picinit();       // disable pic
80103095:	e8 76 03 00 00       	call   80103410 <picinit>
  ioapicinit();    // another interrupt controller
8010309a:	e8 31 f3 ff ff       	call   801023d0 <ioapicinit>
  consoleinit();   // console hardware
8010309f:	e8 bc d9 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
801030a4:	e8 77 34 00 00       	call   80106520 <uartinit>
  pinit();         // process table
801030a9:	e8 b2 0a 00 00       	call   80103b60 <pinit>
  tvinit();        // trap vectors
801030ae:	e8 ad 30 00 00       	call   80106160 <tvinit>
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
801030d4:	e8 c7 1e 00 00       	call   80104fa0 <memmove>

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
80103119:	e8 62 0a 00 00       	call   80103b80 <mycpu>
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
80103182:	e8 a9 0a 00 00       	call   80103c30 <userinit>
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
801031be:	68 d8 7f 10 80       	push   $0x80107fd8
801031c3:	56                   	push   %esi
801031c4:	e8 87 1d 00 00       	call   80104f50 <memcmp>
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
80103276:	68 dd 7f 10 80       	push   $0x80107fdd
8010327b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010327c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010327f:	e8 cc 1c 00 00       	call   80104f50 <memcmp>
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
80103393:	68 e2 7f 10 80       	push   $0x80107fe2
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
801033c2:	68 d8 7f 10 80       	push   $0x80107fd8
801033c7:	53                   	push   %ebx
801033c8:	e8 83 1b 00 00       	call   80104f50 <memcmp>
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
801033f8:	68 fc 7f 10 80       	push   $0x80107ffc
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
801034a3:	68 1b 80 10 80       	push   $0x8010801b
801034a8:	50                   	push   %eax
801034a9:	e8 c2 17 00 00       	call   80104c70 <initlock>
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
8010353f:	e8 fc 18 00 00       	call   80104e40 <acquire>
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
8010355f:	e8 0c 12 00 00       	call   80104770 <wakeup>
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
80103584:	e9 57 18 00 00       	jmp    80104de0 <release>
80103589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103590:	83 ec 0c             	sub    $0xc,%esp
80103593:	53                   	push   %ebx
80103594:	e8 47 18 00 00       	call   80104de0 <release>
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
801035c4:	e8 a7 11 00 00       	call   80104770 <wakeup>
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
801035dd:	e8 5e 18 00 00       	call   80104e40 <acquire>
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
80103628:	e8 d3 05 00 00       	call   80103c00 <myproc>
8010362d:	8b 48 24             	mov    0x24(%eax),%ecx
80103630:	85 c9                	test   %ecx,%ecx
80103632:	75 34                	jne    80103668 <pipewrite+0x98>
      wakeup(&p->nread);
80103634:	83 ec 0c             	sub    $0xc,%esp
80103637:	57                   	push   %edi
80103638:	e8 33 11 00 00       	call   80104770 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010363d:	58                   	pop    %eax
8010363e:	5a                   	pop    %edx
8010363f:	53                   	push   %ebx
80103640:	56                   	push   %esi
80103641:	e8 6a 10 00 00       	call   801046b0 <sleep>
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
8010366c:	e8 6f 17 00 00       	call   80104de0 <release>
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
801036ba:	e8 b1 10 00 00       	call   80104770 <wakeup>
  release(&p->lock);
801036bf:	89 1c 24             	mov    %ebx,(%esp)
801036c2:	e8 19 17 00 00       	call   80104de0 <release>
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
801036e6:	e8 55 17 00 00       	call   80104e40 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036eb:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801036f1:	83 c4 10             	add    $0x10,%esp
801036f4:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801036fa:	74 2f                	je     8010372b <piperead+0x5b>
801036fc:	eb 37                	jmp    80103735 <piperead+0x65>
801036fe:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103700:	e8 fb 04 00 00       	call   80103c00 <myproc>
80103705:	8b 48 24             	mov    0x24(%eax),%ecx
80103708:	85 c9                	test   %ecx,%ecx
8010370a:	0f 85 80 00 00 00    	jne    80103790 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103710:	83 ec 08             	sub    $0x8,%esp
80103713:	56                   	push   %esi
80103714:	53                   	push   %ebx
80103715:	e8 96 0f 00 00       	call   801046b0 <sleep>
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
80103776:	e8 f5 0f 00 00       	call   80104770 <wakeup>
  release(&p->lock);
8010377b:	89 34 24             	mov    %esi,(%esp)
8010377e:	e8 5d 16 00 00       	call   80104de0 <release>
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
80103799:	e8 42 16 00 00       	call   80104de0 <release>
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
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
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
801037c1:	e8 7a 16 00 00       	call   80104e40 <acquire>
801037c6:	83 c4 10             	add    $0x10,%esp
801037c9:	eb 17                	jmp    801037e2 <allocproc+0x32>
801037cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037cf:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037d0:	81 c3 c0 00 00 00    	add    $0xc0,%ebx
801037d6:	81 fb 74 62 11 80    	cmp    $0x80116274,%ebx
801037dc:	0f 84 0e 01 00 00    	je     801038f0 <allocproc+0x140>
    if(p->state == UNUSED)
801037e2:	8b 43 0c             	mov    0xc(%ebx),%eax
801037e5:	85 c0                	test   %eax,%eax
801037e7:	75 e7                	jne    801037d0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801037e9:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
801037ee:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801037f1:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801037f8:	89 43 10             	mov    %eax,0x10(%ebx)
801037fb:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
801037fe:	68 40 32 11 80       	push   $0x80113240
  p->pid = nextpid++;
80103803:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103809:	e8 d2 15 00 00       	call   80104de0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010380e:	e8 6d ee ff ff       	call   80102680 <kalloc>
80103813:	83 c4 10             	add    $0x10,%esp
80103816:	89 43 08             	mov    %eax,0x8(%ebx)
80103819:	85 c0                	test   %eax,%eax
8010381b:	0f 84 e8 00 00 00    	je     80103909 <allocproc+0x159>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103821:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103827:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010382a:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010382f:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103832:	c7 40 14 4d 61 10 80 	movl   $0x8010614d,0x14(%eax)
  p->context = (struct context*)sp;
80103839:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010383c:	6a 14                	push   $0x14
8010383e:	6a 00                	push   $0x0
80103840:	50                   	push   %eax
80103841:	e8 ba 16 00 00       	call   80104f00 <memset>
  p->context->eip = (uint)forkret;
80103846:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103849:	83 c4 10             	add    $0x10,%esp
8010384c:	c7 40 10 20 39 10 80 	movl   $0x80103920,0x10(%eax)
  p->ctime = ticks; 
80103853:	a1 84 62 11 80       	mov    0x80116284,%eax
	p->etime = 0;
80103858:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
8010385f:	00 00 00 
  p->ctime = ticks; 
80103862:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
		p->enter = 0;
		for(int i=0; i<5; i++)
			p->qticks[i] = 0;
	#endif
  return p;
}
80103868:	89 d8                	mov    %ebx,%eax
	p->rtime = 0;
8010386a:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80103871:	00 00 00 
	p->iotime = 0;
80103874:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
	p->waitshh = -1282128;
8010387b:	c7 83 8c 00 00 00 b0 	movl   $0xffec6fb0,0x8c(%ebx)
80103882:	6f ec ff 
  p->num_run = 0;
80103885:	c7 83 94 00 00 00 00 	movl   $0x0,0x94(%ebx)
8010388c:	00 00 00 
	p->priority = 50; // default
8010388f:	c7 83 90 00 00 00 32 	movl   $0x32,0x90(%ebx)
80103896:	00 00 00 
		p->curr_ticks = 0;
80103899:	c7 83 b0 00 00 00 00 	movl   $0x0,0xb0(%ebx)
801038a0:	00 00 00 
		p->queue = 0;
801038a3:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
801038aa:	00 00 00 
		p->enter = 0;
801038ad:	c7 83 b8 00 00 00 00 	movl   $0x0,0xb8(%ebx)
801038b4:	00 00 00 
			p->qticks[i] = 0;
801038b7:	c7 83 98 00 00 00 00 	movl   $0x0,0x98(%ebx)
801038be:	00 00 00 
801038c1:	c7 83 9c 00 00 00 00 	movl   $0x0,0x9c(%ebx)
801038c8:	00 00 00 
801038cb:	c7 83 a0 00 00 00 00 	movl   $0x0,0xa0(%ebx)
801038d2:	00 00 00 
801038d5:	c7 83 a4 00 00 00 00 	movl   $0x0,0xa4(%ebx)
801038dc:	00 00 00 
801038df:	c7 83 a8 00 00 00 00 	movl   $0x0,0xa8(%ebx)
801038e6:	00 00 00 
}
801038e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038ec:	c9                   	leave  
801038ed:	c3                   	ret    
801038ee:	66 90                	xchg   %ax,%ax
  release(&ptable.lock);
801038f0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801038f3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801038f5:	68 40 32 11 80       	push   $0x80113240
801038fa:	e8 e1 14 00 00       	call   80104de0 <release>
}
801038ff:	89 d8                	mov    %ebx,%eax
  return 0;
80103901:	83 c4 10             	add    $0x10,%esp
}
80103904:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103907:	c9                   	leave  
80103908:	c3                   	ret    
    p->state = UNUSED;
80103909:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103910:	31 db                	xor    %ebx,%ebx
}
80103912:	89 d8                	mov    %ebx,%eax
80103914:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103917:	c9                   	leave  
80103918:	c3                   	ret    
80103919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103920 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103920:	55                   	push   %ebp
80103921:	89 e5                	mov    %esp,%ebp
80103923:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103926:	68 40 32 11 80       	push   $0x80113240
8010392b:	e8 b0 14 00 00       	call   80104de0 <release>

  if (first) {
80103930:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103935:	83 c4 10             	add    $0x10,%esp
80103938:	85 c0                	test   %eax,%eax
8010393a:	75 04                	jne    80103940 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010393c:	c9                   	leave  
8010393d:	c3                   	ret    
8010393e:	66 90                	xchg   %ax,%ax
    first = 0;
80103940:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103947:	00 00 00 
    iinit(ROOTDEV);
8010394a:	83 ec 0c             	sub    $0xc,%esp
8010394d:	6a 01                	push   $0x1
8010394f:	e8 0c dc ff ff       	call   80101560 <iinit>
    initlog(ROOTDEV);
80103954:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010395b:	e8 60 f3 ff ff       	call   80102cc0 <initlog>
}
80103960:	83 c4 10             	add    $0x10,%esp
80103963:	c9                   	leave  
80103964:	c3                   	ret    
80103965:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010396c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103970 <ticking>:
	for(struct proc *p=ptable.proc; p<&ptable.proc[NPROC]; ++p){
80103970:	b8 74 32 11 80       	mov    $0x80113274,%eax
80103975:	eb 1e                	jmp    80103995 <ticking+0x25>
80103977:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010397e:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
80103980:	83 fa 02             	cmp    $0x2,%edx
80103983:	75 04                	jne    80103989 <ticking+0x19>
			p->iotime++;
80103985:	83 40 7c 01          	addl   $0x1,0x7c(%eax)
	for(struct proc *p=ptable.proc; p<&ptable.proc[NPROC]; ++p){
80103989:	05 c0 00 00 00       	add    $0xc0,%eax
8010398e:	3d 74 62 11 80       	cmp    $0x80116274,%eax
80103993:	74 1b                	je     801039b0 <ticking+0x40>
		if(p->state == RUNNING){
80103995:	8b 50 0c             	mov    0xc(%eax),%edx
80103998:	83 fa 04             	cmp    $0x4,%edx
8010399b:	75 e3                	jne    80103980 <ticking+0x10>
			p->rtime++;
8010399d:	83 80 80 00 00 00 01 	addl   $0x1,0x80(%eax)
	for(struct proc *p=ptable.proc; p<&ptable.proc[NPROC]; ++p){
801039a4:	05 c0 00 00 00       	add    $0xc0,%eax
801039a9:	3d 74 62 11 80       	cmp    $0x80116274,%eax
801039ae:	75 e5                	jne    80103995 <ticking+0x25>
}
801039b0:	c3                   	ret    
801039b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039bf:	90                   	nop

801039c0 <add_proc_to_q>:
{	
801039c0:	55                   	push   %ebp
801039c1:	89 e5                	mov    %esp,%ebp
801039c3:	57                   	push   %edi
801039c4:	8b 7d 0c             	mov    0xc(%ebp),%edi
801039c7:	8b 55 08             	mov    0x8(%ebp),%edx
801039ca:	56                   	push   %esi
801039cb:	53                   	push   %ebx
	for(int i=0; i < q_tail[q_no]; i++)
801039cc:	8b 0c bd 08 b0 10 80 	mov    -0x7fef4ff8(,%edi,4),%ecx
801039d3:	85 c9                	test   %ecx,%ecx
801039d5:	7e 34                	jle    80103a0b <add_proc_to_q+0x4b>
801039d7:	89 fb                	mov    %edi,%ebx
		if(p->pid == queue[q_no][i]->pid)
801039d9:	8b 72 10             	mov    0x10(%edx),%esi
	for(int i=0; i < q_tail[q_no]; i++)
801039dc:	31 c0                	xor    %eax,%eax
801039de:	c1 e3 08             	shl    $0x8,%ebx
801039e1:	eb 0c                	jmp    801039ef <add_proc_to_q+0x2f>
801039e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039e7:	90                   	nop
801039e8:	83 c0 01             	add    $0x1,%eax
801039eb:	39 c8                	cmp    %ecx,%eax
801039ed:	74 19                	je     80103a08 <add_proc_to_q+0x48>
		if(p->pid == queue[q_no][i]->pid)
801039ef:	8b 94 83 40 2d 11 80 	mov    -0x7feed2c0(%ebx,%eax,4),%edx
801039f6:	3b 72 10             	cmp    0x10(%edx),%esi
801039f9:	75 ed                	jne    801039e8 <add_proc_to_q+0x28>
}
801039fb:	5b                   	pop    %ebx
			return -1;
801039fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103a01:	5e                   	pop    %esi
80103a02:	5f                   	pop    %edi
80103a03:	5d                   	pop    %ebp
80103a04:	c3                   	ret    
80103a05:	8d 76 00             	lea    0x0(%esi),%esi
80103a08:	8b 55 08             	mov    0x8(%ebp),%edx
	q_tail[q_no]++;
80103a0b:	83 c1 01             	add    $0x1,%ecx
	p -> queue = q_no;
80103a0e:	89 ba ac 00 00 00    	mov    %edi,0xac(%edx)
	p->enter = ticks;
80103a14:	a1 84 62 11 80       	mov    0x80116284,%eax
	q_tail[q_no]++;
80103a19:	89 0c bd 08 b0 10 80 	mov    %ecx,-0x7fef4ff8(,%edi,4)
	queue[q_no][q_tail[q_no]] = p;
80103a20:	c1 e7 06             	shl    $0x6,%edi
80103a23:	01 cf                	add    %ecx,%edi
	p->enter = ticks;
80103a25:	89 82 b8 00 00 00    	mov    %eax,0xb8(%edx)
	return 1;
80103a2b:	b8 01 00 00 00       	mov    $0x1,%eax
}
80103a30:	5b                   	pop    %ebx
	queue[q_no][q_tail[q_no]] = p;
80103a31:	89 14 bd 40 2d 11 80 	mov    %edx,-0x7feed2c0(,%edi,4)
}
80103a38:	5e                   	pop    %esi
80103a39:	5f                   	pop    %edi
80103a3a:	5d                   	pop    %ebp
80103a3b:	c3                   	ret    
80103a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103a40 <remove_proc_from_q>:
{
80103a40:	55                   	push   %ebp
80103a41:	89 e5                	mov    %esp,%ebp
80103a43:	57                   	push   %edi
80103a44:	56                   	push   %esi
80103a45:	53                   	push   %ebx
80103a46:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	for(int i=0; i <= q_tail[q_no]; i++)
80103a49:	8b 0c 9d 08 b0 10 80 	mov    -0x7fef4ff8(,%ebx,4),%ecx
80103a50:	85 c9                	test   %ecx,%ecx
80103a52:	78 74                	js     80103ac8 <remove_proc_from_q+0x88>
		if(queue[q_no][i] -> pid == p->pid)
80103a54:	8b 45 08             	mov    0x8(%ebp),%eax
80103a57:	89 de                	mov    %ebx,%esi
80103a59:	c1 e6 08             	shl    $0x8,%esi
80103a5c:	8b 78 10             	mov    0x10(%eax),%edi
	for(int i=0; i <= q_tail[q_no]; i++)
80103a5f:	31 c0                	xor    %eax,%eax
80103a61:	eb 0c                	jmp    80103a6f <remove_proc_from_q+0x2f>
80103a63:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a67:	90                   	nop
80103a68:	83 c0 01             	add    $0x1,%eax
80103a6b:	39 c8                	cmp    %ecx,%eax
80103a6d:	7f 59                	jg     80103ac8 <remove_proc_from_q+0x88>
		if(queue[q_no][i] -> pid == p->pid)
80103a6f:	8b 94 86 40 2d 11 80 	mov    -0x7feed2c0(%esi,%eax,4),%edx
80103a76:	39 7a 10             	cmp    %edi,0x10(%edx)
80103a79:	75 ed                	jne    80103a68 <remove_proc_from_q+0x28>
	for(int i = rem; i < q_tail[q_no]; i++)
80103a7b:	39 c8                	cmp    %ecx,%eax
80103a7d:	7d 2e                	jge    80103aad <remove_proc_from_q+0x6d>
80103a7f:	89 da                	mov    %ebx,%edx
80103a81:	c1 e2 06             	shl    $0x6,%edx
80103a84:	01 d0                	add    %edx,%eax
80103a86:	01 ca                	add    %ecx,%edx
80103a88:	8d 04 85 40 2d 11 80 	lea    -0x7feed2c0(,%eax,4),%eax
80103a8f:	8d 34 95 40 2d 11 80 	lea    -0x7feed2c0(,%edx,4),%esi
80103a96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a9d:	8d 76 00             	lea    0x0(%esi),%esi
	queue[q_no][i] = queue[q_no][i+1]; 
80103aa0:	8b 50 04             	mov    0x4(%eax),%edx
	for(int i = rem; i < q_tail[q_no]; i++)
80103aa3:	83 c0 04             	add    $0x4,%eax
	queue[q_no][i] = queue[q_no][i+1]; 
80103aa6:	89 50 fc             	mov    %edx,-0x4(%eax)
	for(int i = rem; i < q_tail[q_no]; i++)
80103aa9:	39 f0                	cmp    %esi,%eax
80103aab:	75 f3                	jne    80103aa0 <remove_proc_from_q+0x60>
	q_tail[q_no] -= 1;
80103aad:	83 e9 01             	sub    $0x1,%ecx
	return 1;
80103ab0:	b8 01 00 00 00       	mov    $0x1,%eax
	q_tail[q_no] -= 1;
80103ab5:	89 0c 9d 08 b0 10 80 	mov    %ecx,-0x7fef4ff8(,%ebx,4)
}
80103abc:	5b                   	pop    %ebx
80103abd:	5e                   	pop    %esi
80103abe:	5f                   	pop    %edi
80103abf:	5d                   	pop    %ebp
80103ac0:	c3                   	ret    
80103ac1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ac8:	5b                   	pop    %ebx
		return -1;
80103ac9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103ace:	5e                   	pop    %esi
80103acf:	5f                   	pop    %edi
80103ad0:	5d                   	pop    %ebp
80103ad1:	c3                   	ret    
80103ad2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ae0 <change_q_flag>:
{
80103ae0:	55                   	push   %ebp
80103ae1:	89 e5                	mov    %esp,%ebp
80103ae3:	53                   	push   %ebx
80103ae4:	83 ec 10             	sub    $0x10,%esp
80103ae7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	acquire(&ptable.lock);
80103aea:	68 40 32 11 80       	push   $0x80113240
80103aef:	e8 4c 13 00 00       	call   80104e40 <acquire>
	release(&ptable.lock);
80103af4:	83 c4 10             	add    $0x10,%esp
	p-> change_q = 1;
80103af7:	c7 83 b4 00 00 00 01 	movl   $0x1,0xb4(%ebx)
80103afe:	00 00 00 
}
80103b01:	8b 5d fc             	mov    -0x4(%ebp),%ebx
	release(&ptable.lock);
80103b04:	c7 45 08 40 32 11 80 	movl   $0x80113240,0x8(%ebp)
}
80103b0b:	c9                   	leave  
	release(&ptable.lock);
80103b0c:	e9 cf 12 00 00       	jmp    80104de0 <release>
80103b11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b1f:	90                   	nop

80103b20 <incr_curr_ticks>:
{
80103b20:	55                   	push   %ebp
80103b21:	89 e5                	mov    %esp,%ebp
80103b23:	53                   	push   %ebx
80103b24:	83 ec 10             	sub    $0x10,%esp
80103b27:	8b 5d 08             	mov    0x8(%ebp),%ebx
	acquire(&ptable.lock);
80103b2a:	68 40 32 11 80       	push   $0x80113240
80103b2f:	e8 0c 13 00 00       	call   80104e40 <acquire>
	p->qticks[p->queue]++;
80103b34:	8b 83 ac 00 00 00    	mov    0xac(%ebx),%eax
	p->curr_ticks++;
80103b3a:	83 83 b0 00 00 00 01 	addl   $0x1,0xb0(%ebx)
	release(&ptable.lock);
80103b41:	83 c4 10             	add    $0x10,%esp
	p->qticks[p->queue]++;
80103b44:	83 84 83 98 00 00 00 	addl   $0x1,0x98(%ebx,%eax,4)
80103b4b:	01 
}
80103b4c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
	release(&ptable.lock);
80103b4f:	c7 45 08 40 32 11 80 	movl   $0x80113240,0x8(%ebp)
}
80103b56:	c9                   	leave  
	release(&ptable.lock);
80103b57:	e9 84 12 00 00       	jmp    80104de0 <release>
80103b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103b60 <pinit>:
{
80103b60:	55                   	push   %ebp
80103b61:	89 e5                	mov    %esp,%ebp
80103b63:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103b66:	68 20 80 10 80       	push   $0x80108020
80103b6b:	68 40 32 11 80       	push   $0x80113240
80103b70:	e8 fb 10 00 00       	call   80104c70 <initlock>
}
80103b75:	83 c4 10             	add    $0x10,%esp
80103b78:	c9                   	leave  
80103b79:	c3                   	ret    
80103b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103b80 <mycpu>:
{
80103b80:	55                   	push   %ebp
80103b81:	89 e5                	mov    %esp,%ebp
80103b83:	56                   	push   %esi
80103b84:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103b85:	9c                   	pushf  
80103b86:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103b87:	f6 c4 02             	test   $0x2,%ah
80103b8a:	75 46                	jne    80103bd2 <mycpu+0x52>
  apicid = lapicid();
80103b8c:	e8 5f ed ff ff       	call   801028f0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103b91:	8b 35 a4 27 11 80    	mov    0x801127a4,%esi
80103b97:	85 f6                	test   %esi,%esi
80103b99:	7e 2a                	jle    80103bc5 <mycpu+0x45>
80103b9b:	31 d2                	xor    %edx,%edx
80103b9d:	eb 08                	jmp    80103ba7 <mycpu+0x27>
80103b9f:	90                   	nop
80103ba0:	83 c2 01             	add    $0x1,%edx
80103ba3:	39 f2                	cmp    %esi,%edx
80103ba5:	74 1e                	je     80103bc5 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103ba7:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103bad:	0f b6 99 c0 27 11 80 	movzbl -0x7feed840(%ecx),%ebx
80103bb4:	39 c3                	cmp    %eax,%ebx
80103bb6:	75 e8                	jne    80103ba0 <mycpu+0x20>
}
80103bb8:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103bbb:	8d 81 c0 27 11 80    	lea    -0x7feed840(%ecx),%eax
}
80103bc1:	5b                   	pop    %ebx
80103bc2:	5e                   	pop    %esi
80103bc3:	5d                   	pop    %ebp
80103bc4:	c3                   	ret    
  panic("unknown apicid\n");
80103bc5:	83 ec 0c             	sub    $0xc,%esp
80103bc8:	68 27 80 10 80       	push   $0x80108027
80103bcd:	e8 ae c7 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103bd2:	83 ec 0c             	sub    $0xc,%esp
80103bd5:	68 04 81 10 80       	push   $0x80108104
80103bda:	e8 a1 c7 ff ff       	call   80100380 <panic>
80103bdf:	90                   	nop

80103be0 <cpuid>:
cpuid() {
80103be0:	55                   	push   %ebp
80103be1:	89 e5                	mov    %esp,%ebp
80103be3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103be6:	e8 95 ff ff ff       	call   80103b80 <mycpu>
}
80103beb:	c9                   	leave  
  return mycpu()-cpus;
80103bec:	2d c0 27 11 80       	sub    $0x801127c0,%eax
80103bf1:	c1 f8 04             	sar    $0x4,%eax
80103bf4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103bfa:	c3                   	ret    
80103bfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103bff:	90                   	nop

80103c00 <myproc>:
myproc(void) {
80103c00:	55                   	push   %ebp
80103c01:	89 e5                	mov    %esp,%ebp
80103c03:	53                   	push   %ebx
80103c04:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103c07:	e8 e4 10 00 00       	call   80104cf0 <pushcli>
  c = mycpu();
80103c0c:	e8 6f ff ff ff       	call   80103b80 <mycpu>
  p = c->proc;
80103c11:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c17:	e8 24 11 00 00       	call   80104d40 <popcli>
}
80103c1c:	89 d8                	mov    %ebx,%eax
80103c1e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c21:	c9                   	leave  
80103c22:	c3                   	ret    
80103c23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103c30 <userinit>:
{
80103c30:	55                   	push   %ebp
80103c31:	89 e5                	mov    %esp,%ebp
80103c33:	56                   	push   %esi
80103c34:	53                   	push   %ebx
  p = allocproc();
80103c35:	e8 76 fb ff ff       	call   801037b0 <allocproc>
80103c3a:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103c3c:	a3 74 62 11 80       	mov    %eax,0x80116274
  if((p->pgdir = setupkvm()) == 0)
80103c41:	e8 4a 3b 00 00       	call   80107790 <setupkvm>
80103c46:	89 43 04             	mov    %eax,0x4(%ebx)
80103c49:	85 c0                	test   %eax,%eax
80103c4b:	0f 84 16 01 00 00    	je     80103d67 <userinit+0x137>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103c51:	83 ec 04             	sub    $0x4,%esp
80103c54:	68 2c 00 00 00       	push   $0x2c
80103c59:	68 80 b4 10 80       	push   $0x8010b480
80103c5e:	50                   	push   %eax
80103c5f:	e8 dc 37 00 00       	call   80107440 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103c64:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103c67:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103c6d:	6a 4c                	push   $0x4c
80103c6f:	6a 00                	push   $0x0
80103c71:	ff 73 18             	push   0x18(%ebx)
80103c74:	e8 87 12 00 00       	call   80104f00 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103c79:	8b 43 18             	mov    0x18(%ebx),%eax
80103c7c:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c81:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c84:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103c89:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c8d:	8b 43 18             	mov    0x18(%ebx),%eax
80103c90:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103c94:	8b 43 18             	mov    0x18(%ebx),%eax
80103c97:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c9b:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103c9f:	8b 43 18             	mov    0x18(%ebx),%eax
80103ca2:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103ca6:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103caa:	8b 43 18             	mov    0x18(%ebx),%eax
80103cad:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103cb4:	8b 43 18             	mov    0x18(%ebx),%eax
80103cb7:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103cbe:	8b 43 18             	mov    0x18(%ebx),%eax
80103cc1:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103cc8:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103ccb:	6a 10                	push   $0x10
80103ccd:	68 50 80 10 80       	push   $0x80108050
80103cd2:	50                   	push   %eax
80103cd3:	e8 e8 13 00 00       	call   801050c0 <safestrcpy>
  p->cwd = namei("/");
80103cd8:	c7 04 24 59 80 10 80 	movl   $0x80108059,(%esp)
80103cdf:	e8 bc e3 ff ff       	call   801020a0 <namei>
80103ce4:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103ce7:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
80103cee:	e8 4d 11 00 00       	call   80104e40 <acquire>
	for(int i=0; i < q_tail[q_no]; i++)
80103cf3:	8b 0d 08 b0 10 80    	mov    0x8010b008,%ecx
  p->state = RUNNABLE;
80103cf9:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
	for(int i=0; i < q_tail[q_no]; i++)
80103d00:	83 c4 10             	add    $0x10,%esp
80103d03:	85 c9                	test   %ecx,%ecx
80103d05:	7e 39                	jle    80103d40 <userinit+0x110>
		if(p->pid == queue[q_no][i]->pid)
80103d07:	8b 73 10             	mov    0x10(%ebx),%esi
	for(int i=0; i < q_tail[q_no]; i++)
80103d0a:	31 c0                	xor    %eax,%eax
80103d0c:	eb 09                	jmp    80103d17 <userinit+0xe7>
80103d0e:	66 90                	xchg   %ax,%ax
80103d10:	83 c0 01             	add    $0x1,%eax
80103d13:	39 c8                	cmp    %ecx,%eax
80103d15:	74 29                	je     80103d40 <userinit+0x110>
		if(p->pid == queue[q_no][i]->pid)
80103d17:	8b 14 85 40 2d 11 80 	mov    -0x7feed2c0(,%eax,4),%edx
80103d1e:	3b 72 10             	cmp    0x10(%edx),%esi
80103d21:	75 ed                	jne    80103d10 <userinit+0xe0>
  release(&ptable.lock);
80103d23:	83 ec 0c             	sub    $0xc,%esp
80103d26:	68 40 32 11 80       	push   $0x80113240
80103d2b:	e8 b0 10 00 00       	call   80104de0 <release>
}
80103d30:	83 c4 10             	add    $0x10,%esp
80103d33:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d36:	5b                   	pop    %ebx
80103d37:	5e                   	pop    %esi
80103d38:	5d                   	pop    %ebp
80103d39:	c3                   	ret    
80103d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	p->enter = ticks;
80103d40:	a1 84 62 11 80       	mov    0x80116284,%eax
	q_tail[q_no]++;
80103d45:	83 c1 01             	add    $0x1,%ecx
	p -> queue = q_no;
80103d48:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80103d4f:	00 00 00 
	q_tail[q_no]++;
80103d52:	89 0d 08 b0 10 80    	mov    %ecx,0x8010b008
	p->enter = ticks;
80103d58:	89 83 b8 00 00 00    	mov    %eax,0xb8(%ebx)
	queue[q_no][q_tail[q_no]] = p;
80103d5e:	89 1c 8d 40 2d 11 80 	mov    %ebx,-0x7feed2c0(,%ecx,4)
	return 1;
80103d65:	eb bc                	jmp    80103d23 <userinit+0xf3>
    panic("userinit: out of memory?");
80103d67:	83 ec 0c             	sub    $0xc,%esp
80103d6a:	68 37 80 10 80       	push   $0x80108037
80103d6f:	e8 0c c6 ff ff       	call   80100380 <panic>
80103d74:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d7f:	90                   	nop

80103d80 <growproc>:
{
80103d80:	55                   	push   %ebp
80103d81:	89 e5                	mov    %esp,%ebp
80103d83:	56                   	push   %esi
80103d84:	53                   	push   %ebx
80103d85:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103d88:	e8 63 0f 00 00       	call   80104cf0 <pushcli>
  c = mycpu();
80103d8d:	e8 ee fd ff ff       	call   80103b80 <mycpu>
  p = c->proc;
80103d92:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d98:	e8 a3 0f 00 00       	call   80104d40 <popcli>
  sz = curproc->sz;
80103d9d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103d9f:	85 f6                	test   %esi,%esi
80103da1:	7f 1d                	jg     80103dc0 <growproc+0x40>
  } else if(n < 0){
80103da3:	75 3b                	jne    80103de0 <growproc+0x60>
  switchuvm(curproc);
80103da5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103da8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103daa:	53                   	push   %ebx
80103dab:	e8 80 35 00 00       	call   80107330 <switchuvm>
  return 0;
80103db0:	83 c4 10             	add    $0x10,%esp
80103db3:	31 c0                	xor    %eax,%eax
}
80103db5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103db8:	5b                   	pop    %ebx
80103db9:	5e                   	pop    %esi
80103dba:	5d                   	pop    %ebp
80103dbb:	c3                   	ret    
80103dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103dc0:	83 ec 04             	sub    $0x4,%esp
80103dc3:	01 c6                	add    %eax,%esi
80103dc5:	56                   	push   %esi
80103dc6:	50                   	push   %eax
80103dc7:	ff 73 04             	push   0x4(%ebx)
80103dca:	e8 e1 37 00 00       	call   801075b0 <allocuvm>
80103dcf:	83 c4 10             	add    $0x10,%esp
80103dd2:	85 c0                	test   %eax,%eax
80103dd4:	75 cf                	jne    80103da5 <growproc+0x25>
      return -1;
80103dd6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ddb:	eb d8                	jmp    80103db5 <growproc+0x35>
80103ddd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103de0:	83 ec 04             	sub    $0x4,%esp
80103de3:	01 c6                	add    %eax,%esi
80103de5:	56                   	push   %esi
80103de6:	50                   	push   %eax
80103de7:	ff 73 04             	push   0x4(%ebx)
80103dea:	e8 f1 38 00 00       	call   801076e0 <deallocuvm>
80103def:	83 c4 10             	add    $0x10,%esp
80103df2:	85 c0                	test   %eax,%eax
80103df4:	75 af                	jne    80103da5 <growproc+0x25>
80103df6:	eb de                	jmp    80103dd6 <growproc+0x56>
80103df8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103dff:	90                   	nop

80103e00 <fork>:
{
80103e00:	55                   	push   %ebp
80103e01:	89 e5                	mov    %esp,%ebp
80103e03:	57                   	push   %edi
80103e04:	56                   	push   %esi
80103e05:	53                   	push   %ebx
80103e06:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103e09:	e8 e2 0e 00 00       	call   80104cf0 <pushcli>
  c = mycpu();
80103e0e:	e8 6d fd ff ff       	call   80103b80 <mycpu>
  p = c->proc;
80103e13:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e19:	e8 22 0f 00 00       	call   80104d40 <popcli>
  if((np = allocproc()) == 0){
80103e1e:	e8 8d f9 ff ff       	call   801037b0 <allocproc>
80103e23:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103e26:	85 c0                	test   %eax,%eax
80103e28:	0f 84 0c 01 00 00    	je     80103f3a <fork+0x13a>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103e2e:	83 ec 08             	sub    $0x8,%esp
80103e31:	ff 33                	push   (%ebx)
80103e33:	89 c7                	mov    %eax,%edi
80103e35:	ff 73 04             	push   0x4(%ebx)
80103e38:	e8 43 3a 00 00       	call   80107880 <copyuvm>
80103e3d:	83 c4 10             	add    $0x10,%esp
80103e40:	89 47 04             	mov    %eax,0x4(%edi)
80103e43:	85 c0                	test   %eax,%eax
80103e45:	0f 84 f6 00 00 00    	je     80103f41 <fork+0x141>
  np->sz = curproc->sz;
80103e4b:	8b 03                	mov    (%ebx),%eax
80103e4d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103e50:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103e52:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103e55:	89 c8                	mov    %ecx,%eax
80103e57:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103e5a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103e5f:	8b 73 18             	mov    0x18(%ebx),%esi
80103e62:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103e64:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103e66:	8b 40 18             	mov    0x18(%eax),%eax
80103e69:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103e70:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103e74:	85 c0                	test   %eax,%eax
80103e76:	74 13                	je     80103e8b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103e78:	83 ec 0c             	sub    $0xc,%esp
80103e7b:	50                   	push   %eax
80103e7c:	e8 1f d0 ff ff       	call   80100ea0 <filedup>
80103e81:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103e84:	83 c4 10             	add    $0x10,%esp
80103e87:	89 44 b7 28          	mov    %eax,0x28(%edi,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103e8b:	83 c6 01             	add    $0x1,%esi
80103e8e:	83 fe 10             	cmp    $0x10,%esi
80103e91:	75 dd                	jne    80103e70 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103e93:	83 ec 0c             	sub    $0xc,%esp
80103e96:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e99:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103e9c:	e8 af d8 ff ff       	call   80101750 <idup>
80103ea1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103ea4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103ea7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103eaa:	8d 47 6c             	lea    0x6c(%edi),%eax
80103ead:	6a 10                	push   $0x10
80103eaf:	53                   	push   %ebx
80103eb0:	50                   	push   %eax
80103eb1:	e8 0a 12 00 00       	call   801050c0 <safestrcpy>
  pid = np->pid;
80103eb6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103eb9:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
80103ec0:	e8 7b 0f 00 00       	call   80104e40 <acquire>
	for(int i=0; i < q_tail[q_no]; i++)
80103ec5:	8b 0d 08 b0 10 80    	mov    0x8010b008,%ecx
  np->state = RUNNABLE;
80103ecb:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
	for(int i=0; i < q_tail[q_no]; i++)
80103ed2:	83 c4 10             	add    $0x10,%esp
80103ed5:	85 c9                	test   %ecx,%ecx
80103ed7:	7e 37                	jle    80103f10 <fork+0x110>
		if(p->pid == queue[q_no][i]->pid)
80103ed9:	8b 77 10             	mov    0x10(%edi),%esi
	for(int i=0; i < q_tail[q_no]; i++)
80103edc:	31 c0                	xor    %eax,%eax
80103ede:	eb 07                	jmp    80103ee7 <fork+0xe7>
80103ee0:	83 c0 01             	add    $0x1,%eax
80103ee3:	39 c8                	cmp    %ecx,%eax
80103ee5:	74 29                	je     80103f10 <fork+0x110>
		if(p->pid == queue[q_no][i]->pid)
80103ee7:	8b 14 85 40 2d 11 80 	mov    -0x7feed2c0(,%eax,4),%edx
80103eee:	3b 72 10             	cmp    0x10(%edx),%esi
80103ef1:	75 ed                	jne    80103ee0 <fork+0xe0>
  release(&ptable.lock);
80103ef3:	83 ec 0c             	sub    $0xc,%esp
80103ef6:	68 40 32 11 80       	push   $0x80113240
80103efb:	e8 e0 0e 00 00       	call   80104de0 <release>
  return pid;
80103f00:	83 c4 10             	add    $0x10,%esp
}
80103f03:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f06:	89 d8                	mov    %ebx,%eax
80103f08:	5b                   	pop    %ebx
80103f09:	5e                   	pop    %esi
80103f0a:	5f                   	pop    %edi
80103f0b:	5d                   	pop    %ebp
80103f0c:	c3                   	ret    
80103f0d:	8d 76 00             	lea    0x0(%esi),%esi
	p->enter = ticks;
80103f10:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103f13:	a1 84 62 11 80       	mov    0x80116284,%eax
	q_tail[q_no]++;
80103f18:	83 c1 01             	add    $0x1,%ecx
80103f1b:	89 0d 08 b0 10 80    	mov    %ecx,0x8010b008
	p->enter = ticks;
80103f21:	89 82 b8 00 00 00    	mov    %eax,0xb8(%edx)
	p -> queue = q_no;
80103f27:	c7 82 ac 00 00 00 00 	movl   $0x0,0xac(%edx)
80103f2e:	00 00 00 
	queue[q_no][q_tail[q_no]] = p;
80103f31:	89 14 8d 40 2d 11 80 	mov    %edx,-0x7feed2c0(,%ecx,4)
	return 1;
80103f38:	eb b9                	jmp    80103ef3 <fork+0xf3>
    return -1;
80103f3a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103f3f:	eb c2                	jmp    80103f03 <fork+0x103>
    kfree(np->kstack);
80103f41:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103f44:	83 ec 0c             	sub    $0xc,%esp
80103f47:	ff 73 08             	push   0x8(%ebx)
80103f4a:	e8 71 e5 ff ff       	call   801024c0 <kfree>
    np->kstack = 0;
80103f4f:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103f56:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103f59:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103f60:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103f65:	eb 9c                	jmp    80103f03 <fork+0x103>
80103f67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f6e:	66 90                	xchg   %ax,%ax

80103f70 <scheduler>:
{
80103f70:	55                   	push   %ebp
80103f71:	89 e5                	mov    %esp,%ebp
80103f73:	57                   	push   %edi
80103f74:	56                   	push   %esi
80103f75:	53                   	push   %ebx
80103f76:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80103f79:	e8 02 fc ff ff       	call   80103b80 <mycpu>
  c->proc = 0;
80103f7e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103f85:	00 00 00 
  struct cpu *c = mycpu();
80103f88:	89 45 dc             	mov    %eax,-0x24(%ebp)
  c->proc = 0;
80103f8b:	83 c0 04             	add    $0x4,%eax
80103f8e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80103f91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
80103f98:	fb                   	sti    
    acquire(&ptable.lock);
80103f99:	83 ec 0c             	sub    $0xc,%esp
80103f9c:	68 40 32 11 80       	push   $0x80113240
80103fa1:	e8 9a 0e 00 00       	call   80104e40 <acquire>
80103fa6:	83 c4 10             	add    $0x10,%esp
80103fa9:	ba 00 01 00 00       	mov    $0x100,%edx
80103fae:	31 c9                	xor    %ecx,%ecx
80103fb0:	89 cf                	mov    %ecx,%edi
				for(int j=0; j <= q_tail[i]; j++)
80103fb2:	31 db                	xor    %ebx,%ebx
80103fb4:	83 c1 01             	add    $0x1,%ecx
80103fb7:	8b 34 bd 0c b0 10 80 	mov    -0x7fef4ff4(,%edi,4),%esi
80103fbe:	85 f6                	test   %esi,%esi
80103fc0:	78 5e                	js     80104020 <scheduler+0xb0>
80103fc2:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80103fc5:	eb 15                	jmp    80103fdc <scheduler+0x6c>
80103fc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fce:	66 90                	xchg   %ax,%ax
80103fd0:	83 c3 01             	add    $0x1,%ebx
80103fd3:	39 1c bd 0c b0 10 80 	cmp    %ebx,-0x7fef4ff4(,%edi,4)
80103fda:	7c 41                	jl     8010401d <scheduler+0xad>
					struct proc *p = queue[i][j];
80103fdc:	8b b4 9a 40 2d 11 80 	mov    -0x7feed2c0(%edx,%ebx,4),%esi
          				int age = ticks - p->enter;
80103fe3:	a1 84 62 11 80       	mov    0x80116284,%eax
80103fe8:	2b 86 b8 00 00 00    	sub    0xb8(%esi),%eax
					if(age > 30)
80103fee:	83 f8 1e             	cmp    $0x1e,%eax
80103ff1:	7e dd                	jle    80103fd0 <scheduler+0x60>
						remove_proc_from_q(p, i);
80103ff3:	83 ec 08             	sub    $0x8,%esp
80103ff6:	ff 75 e0             	push   -0x20(%ebp)
				for(int j=0; j <= q_tail[i]; j++)
80103ff9:	83 c3 01             	add    $0x1,%ebx
						remove_proc_from_q(p, i);
80103ffc:	56                   	push   %esi
80103ffd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80104000:	e8 3b fa ff ff       	call   80103a40 <remove_proc_from_q>
						add_proc_to_q(p, i-1);
80104005:	58                   	pop    %eax
80104006:	5a                   	pop    %edx
80104007:	57                   	push   %edi
80104008:	56                   	push   %esi
80104009:	e8 b2 f9 ff ff       	call   801039c0 <add_proc_to_q>
8010400e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104011:	83 c4 10             	add    $0x10,%esp
				for(int j=0; j <= q_tail[i]; j++)
80104014:	39 1c bd 0c b0 10 80 	cmp    %ebx,-0x7fef4ff4(,%edi,4)
8010401b:	7d bf                	jge    80103fdc <scheduler+0x6c>
8010401d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      for(int i=1; i < 5; i++)
80104020:	81 c2 00 01 00 00    	add    $0x100,%edx
80104026:	83 f9 04             	cmp    $0x4,%ecx
80104029:	75 85                	jne    80103fb0 <scheduler+0x40>
			for(int i=0; i < 5; i++)
8010402b:	31 c0                	xor    %eax,%eax
				if(q_tail[i] >=0)
8010402d:	8b 0c 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%ecx
80104034:	85 c9                	test   %ecx,%ecx
80104036:	79 1d                	jns    80104055 <scheduler+0xe5>
			for(int i=0; i < 5; i++)
80104038:	83 c0 01             	add    $0x1,%eax
8010403b:	83 f8 05             	cmp    $0x5,%eax
8010403e:	75 ed                	jne    8010402d <scheduler+0xbd>
    release(&ptable.lock);
80104040:	83 ec 0c             	sub    $0xc,%esp
80104043:	68 40 32 11 80       	push   $0x80113240
80104048:	e8 93 0d 00 00       	call   80104de0 <release>
  for(;;){
8010404d:	83 c4 10             	add    $0x10,%esp
80104050:	e9 43 ff ff ff       	jmp    80103f98 <scheduler+0x28>
					p = queue[i][0];
80104055:	89 c2                	mov    %eax,%edx
					remove_proc_from_q(p, i);
80104057:	83 ec 08             	sub    $0x8,%esp
					p = queue[i][0];
8010405a:	c1 e2 08             	shl    $0x8,%edx
					remove_proc_from_q(p, i);
8010405d:	50                   	push   %eax
					p = queue[i][0];
8010405e:	8b 9a 40 2d 11 80    	mov    -0x7feed2c0(%edx),%ebx
					remove_proc_from_q(p, i);
80104064:	53                   	push   %ebx
80104065:	e8 d6 f9 ff ff       	call   80103a40 <remove_proc_from_q>
			if(p!=0 && p->state==RUNNABLE)
8010406a:	83 c4 10             	add    $0x10,%esp
8010406d:	85 db                	test   %ebx,%ebx
8010406f:	74 cf                	je     80104040 <scheduler+0xd0>
80104071:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104075:	75 c9                	jne    80104040 <scheduler+0xd0>
				c->proc = p;
80104077:	8b 7d dc             	mov    -0x24(%ebp),%edi
				switchuvm(p);
8010407a:	83 ec 0c             	sub    $0xc,%esp
				p->num_run++;
8010407d:	83 83 94 00 00 00 01 	addl   $0x1,0x94(%ebx)
				c->proc = p;
80104084:	89 9f ac 00 00 00    	mov    %ebx,0xac(%edi)
				switchuvm(p);
8010408a:	53                   	push   %ebx
8010408b:	e8 a0 32 00 00       	call   80107330 <switchuvm>
				p->state = RUNNING;
80104090:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
				swtch(&c->scheduler, p->context);
80104097:	58                   	pop    %eax
80104098:	5a                   	pop    %edx
80104099:	ff 73 1c             	push   0x1c(%ebx)
8010409c:	ff 75 d8             	push   -0x28(%ebp)
8010409f:	e8 77 10 00 00       	call   8010511b <swtch>
				switchkvm();
801040a4:	e8 77 32 00 00       	call   80107320 <switchkvm>
				if(p!=0 && p->state == RUNNABLE)
801040a9:	83 c4 10             	add    $0x10,%esp
				c->proc = 0;
801040ac:	c7 87 ac 00 00 00 00 	movl   $0x0,0xac(%edi)
801040b3:	00 00 00 
				if(p!=0 && p->state == RUNNABLE)
801040b6:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801040ba:	75 84                	jne    80104040 <scheduler+0xd0>
					if(p->change_q == 1)
801040bc:	83 bb b4 00 00 00 01 	cmpl   $0x1,0xb4(%ebx)
						if(p->queue != 4){
801040c3:	8b 83 ac 00 00 00    	mov    0xac(%ebx),%eax
					if(p->change_q == 1)
801040c9:	74 2c                	je     801040f7 <scheduler+0x187>
					else p->curr_ticks = 0;
801040cb:	c7 83 b0 00 00 00 00 	movl   $0x0,0xb0(%ebx)
801040d2:	00 00 00 
					add_proc_to_q(p,p->queue);
801040d5:	83 ec 08             	sub    $0x8,%esp
801040d8:	50                   	push   %eax
801040d9:	53                   	push   %ebx
801040da:	e8 e1 f8 ff ff       	call   801039c0 <add_proc_to_q>
801040df:	83 c4 10             	add    $0x10,%esp
    release(&ptable.lock);
801040e2:	83 ec 0c             	sub    $0xc,%esp
801040e5:	68 40 32 11 80       	push   $0x80113240
801040ea:	e8 f1 0c 00 00       	call   80104de0 <release>
  for(;;){
801040ef:	83 c4 10             	add    $0x10,%esp
801040f2:	e9 a1 fe ff ff       	jmp    80103f98 <scheduler+0x28>
						p->change_q = 0;
801040f7:	c7 83 b4 00 00 00 00 	movl   $0x0,0xb4(%ebx)
801040fe:	00 00 00 
						p->curr_ticks = 0;
80104101:	c7 83 b0 00 00 00 00 	movl   $0x0,0xb0(%ebx)
80104108:	00 00 00 
						if(p->queue != 4){
8010410b:	83 f8 04             	cmp    $0x4,%eax
8010410e:	74 c5                	je     801040d5 <scheduler+0x165>
						p->queue+=1;
80104110:	83 c0 01             	add    $0x1,%eax
80104113:	89 83 ac 00 00 00    	mov    %eax,0xac(%ebx)
80104119:	eb ba                	jmp    801040d5 <scheduler+0x165>
8010411b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010411f:	90                   	nop

80104120 <sched>:
{
80104120:	55                   	push   %ebp
80104121:	89 e5                	mov    %esp,%ebp
80104123:	56                   	push   %esi
80104124:	53                   	push   %ebx
  pushcli();
80104125:	e8 c6 0b 00 00       	call   80104cf0 <pushcli>
  c = mycpu();
8010412a:	e8 51 fa ff ff       	call   80103b80 <mycpu>
  p = c->proc;
8010412f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104135:	e8 06 0c 00 00       	call   80104d40 <popcli>
  if(!holding(&ptable.lock))
8010413a:	83 ec 0c             	sub    $0xc,%esp
8010413d:	68 40 32 11 80       	push   $0x80113240
80104142:	e8 59 0c 00 00       	call   80104da0 <holding>
80104147:	83 c4 10             	add    $0x10,%esp
8010414a:	85 c0                	test   %eax,%eax
8010414c:	74 4f                	je     8010419d <sched+0x7d>
  if(mycpu()->ncli != 1)
8010414e:	e8 2d fa ff ff       	call   80103b80 <mycpu>
80104153:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010415a:	75 68                	jne    801041c4 <sched+0xa4>
  if(p->state == RUNNING)
8010415c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104160:	74 55                	je     801041b7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104162:	9c                   	pushf  
80104163:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104164:	f6 c4 02             	test   $0x2,%ah
80104167:	75 41                	jne    801041aa <sched+0x8a>
  intena = mycpu()->intena;
80104169:	e8 12 fa ff ff       	call   80103b80 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010416e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104171:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104177:	e8 04 fa ff ff       	call   80103b80 <mycpu>
8010417c:	83 ec 08             	sub    $0x8,%esp
8010417f:	ff 70 04             	push   0x4(%eax)
80104182:	53                   	push   %ebx
80104183:	e8 93 0f 00 00       	call   8010511b <swtch>
  mycpu()->intena = intena;
80104188:	e8 f3 f9 ff ff       	call   80103b80 <mycpu>
}
8010418d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104190:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104196:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104199:	5b                   	pop    %ebx
8010419a:	5e                   	pop    %esi
8010419b:	5d                   	pop    %ebp
8010419c:	c3                   	ret    
    panic("sched ptable.lock");
8010419d:	83 ec 0c             	sub    $0xc,%esp
801041a0:	68 5b 80 10 80       	push   $0x8010805b
801041a5:	e8 d6 c1 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
801041aa:	83 ec 0c             	sub    $0xc,%esp
801041ad:	68 87 80 10 80       	push   $0x80108087
801041b2:	e8 c9 c1 ff ff       	call   80100380 <panic>
    panic("sched running");
801041b7:	83 ec 0c             	sub    $0xc,%esp
801041ba:	68 79 80 10 80       	push   $0x80108079
801041bf:	e8 bc c1 ff ff       	call   80100380 <panic>
    panic("sched locks");
801041c4:	83 ec 0c             	sub    $0xc,%esp
801041c7:	68 6d 80 10 80       	push   $0x8010806d
801041cc:	e8 af c1 ff ff       	call   80100380 <panic>
801041d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041df:	90                   	nop

801041e0 <exit>:
{
801041e0:	55                   	push   %ebp
801041e1:	89 e5                	mov    %esp,%ebp
801041e3:	57                   	push   %edi
801041e4:	56                   	push   %esi
801041e5:	53                   	push   %ebx
801041e6:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
801041e9:	e8 12 fa ff ff       	call   80103c00 <myproc>
  if(curproc == initproc)
801041ee:	39 05 74 62 11 80    	cmp    %eax,0x80116274
801041f4:	0f 84 8a 01 00 00    	je     80104384 <exit+0x1a4>
801041fa:	89 c2                	mov    %eax,%edx
801041fc:	8d 58 28             	lea    0x28(%eax),%ebx
801041ff:	8d 70 68             	lea    0x68(%eax),%esi
80104202:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80104208:	8b 03                	mov    (%ebx),%eax
8010420a:	85 c0                	test   %eax,%eax
8010420c:	74 18                	je     80104226 <exit+0x46>
      fileclose(curproc->ofile[fd]);
8010420e:	83 ec 0c             	sub    $0xc,%esp
80104211:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80104214:	50                   	push   %eax
80104215:	e8 d6 cc ff ff       	call   80100ef0 <fileclose>
      curproc->ofile[fd] = 0;
8010421a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80104220:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104223:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104226:	83 c3 04             	add    $0x4,%ebx
80104229:	39 f3                	cmp    %esi,%ebx
8010422b:	75 db                	jne    80104208 <exit+0x28>
8010422d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
static void
wakeup1(void *chan)
{
  struct proc *p;	

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104230:	bb 74 32 11 80       	mov    $0x80113274,%ebx
  begin_op();
80104235:	e8 26 eb ff ff       	call   80102d60 <begin_op>
  iput(curproc->cwd);
8010423a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010423d:	83 ec 0c             	sub    $0xc,%esp
80104240:	ff 72 68             	push   0x68(%edx)
80104243:	e8 68 d6 ff ff       	call   801018b0 <iput>
  end_op();
80104248:	e8 83 eb ff ff       	call   80102dd0 <end_op>
  curproc->cwd = 0;
8010424d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104250:	c7 42 68 00 00 00 00 	movl   $0x0,0x68(%edx)
  acquire(&ptable.lock);
80104257:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
8010425e:	e8 dd 0b 00 00       	call   80104e40 <acquire>
  wakeup1(curproc->parent);
80104263:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104266:	83 c4 10             	add    $0x10,%esp
80104269:	8b 72 14             	mov    0x14(%edx),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010426c:	eb 10                	jmp    8010427e <exit+0x9e>
8010426e:	66 90                	xchg   %ax,%ax
80104270:	81 c3 c0 00 00 00    	add    $0xc0,%ebx
80104276:	81 fb 74 62 11 80    	cmp    $0x80116274,%ebx
8010427c:	74 42                	je     801042c0 <exit+0xe0>
    if(p->state == SLEEPING && p->chan == chan){
8010427e:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104282:	75 ec                	jne    80104270 <exit+0x90>
80104284:	3b 73 20             	cmp    0x20(%ebx),%esi
80104287:	75 e7                	jne    80104270 <exit+0x90>
      p->state = RUNNABLE;
      #ifdef MLFQ
		p->curr_ticks = 0;
		add_proc_to_q(p, p->queue);
80104289:	83 ec 08             	sub    $0x8,%esp
      p->state = RUNNABLE;
8010428c:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
		p->curr_ticks = 0;
80104293:	c7 83 b0 00 00 00 00 	movl   $0x0,0xb0(%ebx)
8010429a:	00 00 00 
		add_proc_to_q(p, p->queue);
8010429d:	ff b3 ac 00 00 00    	push   0xac(%ebx)
801042a3:	53                   	push   %ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042a4:	81 c3 c0 00 00 00    	add    $0xc0,%ebx
801042aa:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		add_proc_to_q(p, p->queue);
801042ad:	e8 0e f7 ff ff       	call   801039c0 <add_proc_to_q>
801042b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801042b5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042b8:	81 fb 74 62 11 80    	cmp    $0x80116274,%ebx
801042be:	75 be                	jne    8010427e <exit+0x9e>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042c0:	be 74 32 11 80       	mov    $0x80113274,%esi
801042c5:	eb 17                	jmp    801042de <exit+0xfe>
801042c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042ce:	66 90                	xchg   %ax,%ax
801042d0:	81 c6 c0 00 00 00    	add    $0xc0,%esi
801042d6:	81 fe 74 62 11 80    	cmp    $0x80116274,%esi
801042dc:	74 66                	je     80104344 <exit+0x164>
    if(p->parent == curproc){
801042de:	39 56 14             	cmp    %edx,0x14(%esi)
801042e1:	75 ed                	jne    801042d0 <exit+0xf0>
      p->parent = initproc;
801042e3:	8b 3d 74 62 11 80    	mov    0x80116274,%edi
      if(p->state == ZOMBIE)
801042e9:	83 7e 0c 05          	cmpl   $0x5,0xc(%esi)
      p->parent = initproc;
801042ed:	89 7e 14             	mov    %edi,0x14(%esi)
      if(p->state == ZOMBIE)
801042f0:	75 de                	jne    801042d0 <exit+0xf0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042f2:	bb 74 32 11 80       	mov    $0x80113274,%ebx
801042f7:	eb 15                	jmp    8010430e <exit+0x12e>
801042f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104300:	81 c3 c0 00 00 00    	add    $0xc0,%ebx
80104306:	81 fb 74 62 11 80    	cmp    $0x80116274,%ebx
8010430c:	74 c2                	je     801042d0 <exit+0xf0>
    if(p->state == SLEEPING && p->chan == chan){
8010430e:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104312:	75 ec                	jne    80104300 <exit+0x120>
80104314:	3b 7b 20             	cmp    0x20(%ebx),%edi
80104317:	75 e7                	jne    80104300 <exit+0x120>
		add_proc_to_q(p, p->queue);
80104319:	83 ec 08             	sub    $0x8,%esp
      p->state = RUNNABLE;
8010431c:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
		p->curr_ticks = 0;
80104323:	c7 83 b0 00 00 00 00 	movl   $0x0,0xb0(%ebx)
8010432a:	00 00 00 
		add_proc_to_q(p, p->queue);
8010432d:	ff b3 ac 00 00 00    	push   0xac(%ebx)
80104333:	53                   	push   %ebx
80104334:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80104337:	e8 84 f6 ff ff       	call   801039c0 <add_proc_to_q>
8010433c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010433f:	83 c4 10             	add    $0x10,%esp
80104342:	eb bc                	jmp    80104300 <exit+0x120>
  curproc->etime = ticks;
80104344:	a1 84 62 11 80       	mov    0x80116284,%eax
	cprintf("[Terminate] --> Total Time for pid [%d] is [%d]\n",curproc->pid, curproc->etime - curproc->ctime);
80104349:	83 ec 04             	sub    $0x4,%esp
  curproc->state = ZOMBIE;
8010434c:	c7 42 0c 05 00 00 00 	movl   $0x5,0xc(%edx)
  curproc->etime = ticks;
80104353:	89 82 88 00 00 00    	mov    %eax,0x88(%edx)
  curproc->waitshh=curproc->etime - curproc->ctime;
80104359:	2b 82 84 00 00 00    	sub    0x84(%edx),%eax
8010435f:	89 82 8c 00 00 00    	mov    %eax,0x8c(%edx)
	cprintf("[Terminate] --> Total Time for pid [%d] is [%d]\n",curproc->pid, curproc->etime - curproc->ctime);
80104365:	50                   	push   %eax
80104366:	ff 72 10             	push   0x10(%edx)
80104369:	68 2c 81 10 80       	push   $0x8010812c
8010436e:	e8 2d c3 ff ff       	call   801006a0 <cprintf>
  sched();
80104373:	e8 a8 fd ff ff       	call   80104120 <sched>
  panic("zombie exit");
80104378:	c7 04 24 a8 80 10 80 	movl   $0x801080a8,(%esp)
8010437f:	e8 fc bf ff ff       	call   80100380 <panic>
    panic("init exiting");
80104384:	83 ec 0c             	sub    $0xc,%esp
80104387:	68 9b 80 10 80       	push   $0x8010809b
8010438c:	e8 ef bf ff ff       	call   80100380 <panic>
80104391:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104398:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010439f:	90                   	nop

801043a0 <wait>:
{
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
801043a3:	56                   	push   %esi
801043a4:	53                   	push   %ebx
  pushcli();
801043a5:	e8 46 09 00 00       	call   80104cf0 <pushcli>
  c = mycpu();
801043aa:	e8 d1 f7 ff ff       	call   80103b80 <mycpu>
  p = c->proc;
801043af:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801043b5:	e8 86 09 00 00       	call   80104d40 <popcli>
  acquire(&ptable.lock);
801043ba:	83 ec 0c             	sub    $0xc,%esp
801043bd:	68 40 32 11 80       	push   $0x80113240
801043c2:	e8 79 0a 00 00       	call   80104e40 <acquire>
801043c7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801043ca:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043cc:	bb 74 32 11 80       	mov    $0x80113274,%ebx
801043d1:	eb 13                	jmp    801043e6 <wait+0x46>
801043d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043d7:	90                   	nop
801043d8:	81 c3 c0 00 00 00    	add    $0xc0,%ebx
801043de:	81 fb 74 62 11 80    	cmp    $0x80116274,%ebx
801043e4:	74 1e                	je     80104404 <wait+0x64>
      if(p->parent != curproc)
801043e6:	39 73 14             	cmp    %esi,0x14(%ebx)
801043e9:	75 ed                	jne    801043d8 <wait+0x38>
      if(p->state == ZOMBIE){
801043eb:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801043ef:	74 5f                	je     80104450 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043f1:	81 c3 c0 00 00 00    	add    $0xc0,%ebx
      havekids = 1;
801043f7:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043fc:	81 fb 74 62 11 80    	cmp    $0x80116274,%ebx
80104402:	75 e2                	jne    801043e6 <wait+0x46>
    if(!havekids || curproc->killed){
80104404:	85 c0                	test   %eax,%eax
80104406:	0f 84 b2 00 00 00    	je     801044be <wait+0x11e>
8010440c:	8b 46 24             	mov    0x24(%esi),%eax
8010440f:	85 c0                	test   %eax,%eax
80104411:	0f 85 a7 00 00 00    	jne    801044be <wait+0x11e>
  pushcli();
80104417:	e8 d4 08 00 00       	call   80104cf0 <pushcli>
  c = mycpu();
8010441c:	e8 5f f7 ff ff       	call   80103b80 <mycpu>
  p = c->proc;
80104421:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104427:	e8 14 09 00 00       	call   80104d40 <popcli>
  if(p == 0)
8010442c:	85 db                	test   %ebx,%ebx
8010442e:	0f 84 a1 00 00 00    	je     801044d5 <wait+0x135>
  p->chan = chan;
80104434:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80104437:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010443e:	e8 dd fc ff ff       	call   80104120 <sched>
  p->chan = 0;
80104443:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010444a:	e9 7b ff ff ff       	jmp    801043ca <wait+0x2a>
8010444f:	90                   	nop
        kfree(p->kstack);
80104450:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104453:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104456:	ff 73 08             	push   0x8(%ebx)
80104459:	e8 62 e0 ff ff       	call   801024c0 <kfree>
        p->kstack = 0;
8010445e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104465:	5a                   	pop    %edx
80104466:	ff 73 04             	push   0x4(%ebx)
80104469:	e8 a2 32 00 00       	call   80107710 <freevm>
					remove_proc_from_q(p, p->queue);
8010446e:	59                   	pop    %ecx
8010446f:	58                   	pop    %eax
80104470:	ff b3 ac 00 00 00    	push   0xac(%ebx)
80104476:	53                   	push   %ebx
80104477:	e8 c4 f5 ff ff       	call   80103a40 <remove_proc_from_q>
        p->pid = 0;
8010447c:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
          p->queue=-1;
80104483:	c7 83 ac 00 00 00 ff 	movl   $0xffffffff,0xac(%ebx)
8010448a:	ff ff ff 
        p->parent = 0;
8010448d:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104494:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104498:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
8010449f:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801044a6:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
801044ad:	e8 2e 09 00 00       	call   80104de0 <release>
        return pid;
801044b2:	83 c4 10             	add    $0x10,%esp
}
801044b5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044b8:	89 f0                	mov    %esi,%eax
801044ba:	5b                   	pop    %ebx
801044bb:	5e                   	pop    %esi
801044bc:	5d                   	pop    %ebp
801044bd:	c3                   	ret    
      release(&ptable.lock);
801044be:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801044c1:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801044c6:	68 40 32 11 80       	push   $0x80113240
801044cb:	e8 10 09 00 00       	call   80104de0 <release>
      return -1;
801044d0:	83 c4 10             	add    $0x10,%esp
801044d3:	eb e0                	jmp    801044b5 <wait+0x115>
    panic("sleep");
801044d5:	83 ec 0c             	sub    $0xc,%esp
801044d8:	68 b4 80 10 80       	push   $0x801080b4
801044dd:	e8 9e be ff ff       	call   80100380 <panic>
801044e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801044f0 <waitx>:
{
801044f0:	55                   	push   %ebp
801044f1:	89 e5                	mov    %esp,%ebp
801044f3:	56                   	push   %esi
801044f4:	53                   	push   %ebx
  pushcli();
801044f5:	e8 f6 07 00 00       	call   80104cf0 <pushcli>
  c = mycpu();
801044fa:	e8 81 f6 ff ff       	call   80103b80 <mycpu>
  p = c->proc;
801044ff:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104505:	e8 36 08 00 00       	call   80104d40 <popcli>
  acquire(&ptable.lock);
8010450a:	83 ec 0c             	sub    $0xc,%esp
8010450d:	68 40 32 11 80       	push   $0x80113240
80104512:	e8 29 09 00 00       	call   80104e40 <acquire>
80104517:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010451a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010451c:	bb 74 32 11 80       	mov    $0x80113274,%ebx
80104521:	eb 13                	jmp    80104536 <waitx+0x46>
80104523:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104527:	90                   	nop
80104528:	81 c3 c0 00 00 00    	add    $0xc0,%ebx
8010452e:	81 fb 74 62 11 80    	cmp    $0x80116274,%ebx
80104534:	74 1e                	je     80104554 <waitx+0x64>
      if(p->parent != curproc)
80104536:	39 73 14             	cmp    %esi,0x14(%ebx)
80104539:	75 ed                	jne    80104528 <waitx+0x38>
      if(p->state == ZOMBIE){
8010453b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010453f:	74 5f                	je     801045a0 <waitx+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104541:	81 c3 c0 00 00 00    	add    $0xc0,%ebx
      havekids = 1;
80104547:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010454c:	81 fb 74 62 11 80    	cmp    $0x80116274,%ebx
80104552:	75 e2                	jne    80104536 <waitx+0x46>
    if(!havekids || curproc->killed){
80104554:	85 c0                	test   %eax,%eax
80104556:	0f 84 d3 00 00 00    	je     8010462f <waitx+0x13f>
8010455c:	8b 46 24             	mov    0x24(%esi),%eax
8010455f:	85 c0                	test   %eax,%eax
80104561:	0f 85 c8 00 00 00    	jne    8010462f <waitx+0x13f>
  pushcli();
80104567:	e8 84 07 00 00       	call   80104cf0 <pushcli>
  c = mycpu();
8010456c:	e8 0f f6 ff ff       	call   80103b80 <mycpu>
  p = c->proc;
80104571:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104577:	e8 c4 07 00 00       	call   80104d40 <popcli>
  if(p == 0)
8010457c:	85 db                	test   %ebx,%ebx
8010457e:	0f 84 c2 00 00 00    	je     80104646 <waitx+0x156>
  p->chan = chan;
80104584:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80104587:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010458e:	e8 8d fb ff ff       	call   80104120 <sched>
  p->chan = 0;
80104593:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010459a:	e9 7b ff ff ff       	jmp    8010451a <waitx+0x2a>
8010459f:	90                   	nop
        *rtime = p->rtime ;
801045a0:	8b 93 80 00 00 00    	mov    0x80(%ebx),%edx
801045a6:	8b 45 0c             	mov    0xc(%ebp),%eax
        kfree(p->kstack);
801045a9:	83 ec 0c             	sub    $0xc,%esp
        *rtime = p->rtime ;
801045ac:	89 10                	mov    %edx,(%eax)
				*wtime = p->etime - p->ctime - p->rtime - p->iotime;
801045ae:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
801045b4:	2b 83 84 00 00 00    	sub    0x84(%ebx),%eax
801045ba:	29 d0                	sub    %edx,%eax
801045bc:	8b 55 08             	mov    0x8(%ebp),%edx
801045bf:	2b 43 7c             	sub    0x7c(%ebx),%eax
801045c2:	89 02                	mov    %eax,(%edx)
        pid = p->pid;
801045c4:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801045c7:	ff 73 08             	push   0x8(%ebx)
801045ca:	e8 f1 de ff ff       	call   801024c0 <kfree>
        p->kstack = 0;
801045cf:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801045d6:	5a                   	pop    %edx
801045d7:	ff 73 04             	push   0x4(%ebx)
801045da:	e8 31 31 00 00       	call   80107710 <freevm>
					remove_proc_from_q(p, p->queue);
801045df:	59                   	pop    %ecx
801045e0:	58                   	pop    %eax
801045e1:	ff b3 ac 00 00 00    	push   0xac(%ebx)
801045e7:	53                   	push   %ebx
801045e8:	e8 53 f4 ff ff       	call   80103a40 <remove_proc_from_q>
        p->pid = 0;
801045ed:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
          p->queue=-1;
801045f4:	c7 83 ac 00 00 00 ff 	movl   $0xffffffff,0xac(%ebx)
801045fb:	ff ff ff 
        p->parent = 0;
801045fe:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104605:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104609:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104610:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104617:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
8010461e:	e8 bd 07 00 00       	call   80104de0 <release>
        return pid;
80104623:	83 c4 10             	add    $0x10,%esp
}
80104626:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104629:	89 f0                	mov    %esi,%eax
8010462b:	5b                   	pop    %ebx
8010462c:	5e                   	pop    %esi
8010462d:	5d                   	pop    %ebp
8010462e:	c3                   	ret    
      release(&ptable.lock);
8010462f:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104632:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104637:	68 40 32 11 80       	push   $0x80113240
8010463c:	e8 9f 07 00 00       	call   80104de0 <release>
      return -1;
80104641:	83 c4 10             	add    $0x10,%esp
80104644:	eb e0                	jmp    80104626 <waitx+0x136>
    panic("sleep");
80104646:	83 ec 0c             	sub    $0xc,%esp
80104649:	68 b4 80 10 80       	push   $0x801080b4
8010464e:	e8 2d bd ff ff       	call   80100380 <panic>
80104653:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010465a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104660 <yield>:
{
80104660:	55                   	push   %ebp
80104661:	89 e5                	mov    %esp,%ebp
80104663:	53                   	push   %ebx
80104664:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104667:	68 40 32 11 80       	push   $0x80113240
8010466c:	e8 cf 07 00 00       	call   80104e40 <acquire>
  pushcli();
80104671:	e8 7a 06 00 00       	call   80104cf0 <pushcli>
  c = mycpu();
80104676:	e8 05 f5 ff ff       	call   80103b80 <mycpu>
  p = c->proc;
8010467b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104681:	e8 ba 06 00 00       	call   80104d40 <popcli>
  myproc()->state = RUNNABLE;
80104686:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010468d:	e8 8e fa ff ff       	call   80104120 <sched>
  release(&ptable.lock);
80104692:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
80104699:	e8 42 07 00 00       	call   80104de0 <release>
}
8010469e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046a1:	83 c4 10             	add    $0x10,%esp
801046a4:	c9                   	leave  
801046a5:	c3                   	ret    
801046a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046ad:	8d 76 00             	lea    0x0(%esi),%esi

801046b0 <sleep>:
{
801046b0:	55                   	push   %ebp
801046b1:	89 e5                	mov    %esp,%ebp
801046b3:	57                   	push   %edi
801046b4:	56                   	push   %esi
801046b5:	53                   	push   %ebx
801046b6:	83 ec 0c             	sub    $0xc,%esp
801046b9:	8b 7d 08             	mov    0x8(%ebp),%edi
801046bc:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801046bf:	e8 2c 06 00 00       	call   80104cf0 <pushcli>
  c = mycpu();
801046c4:	e8 b7 f4 ff ff       	call   80103b80 <mycpu>
  p = c->proc;
801046c9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801046cf:	e8 6c 06 00 00       	call   80104d40 <popcli>
  if(p == 0)
801046d4:	85 db                	test   %ebx,%ebx
801046d6:	0f 84 87 00 00 00    	je     80104763 <sleep+0xb3>
  if(lk == 0)
801046dc:	85 f6                	test   %esi,%esi
801046de:	74 76                	je     80104756 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801046e0:	81 fe 40 32 11 80    	cmp    $0x80113240,%esi
801046e6:	74 50                	je     80104738 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801046e8:	83 ec 0c             	sub    $0xc,%esp
801046eb:	68 40 32 11 80       	push   $0x80113240
801046f0:	e8 4b 07 00 00       	call   80104e40 <acquire>
    release(lk);
801046f5:	89 34 24             	mov    %esi,(%esp)
801046f8:	e8 e3 06 00 00       	call   80104de0 <release>
  p->chan = chan;
801046fd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104700:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104707:	e8 14 fa ff ff       	call   80104120 <sched>
  p->chan = 0;
8010470c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104713:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
8010471a:	e8 c1 06 00 00       	call   80104de0 <release>
    acquire(lk);
8010471f:	89 75 08             	mov    %esi,0x8(%ebp)
80104722:	83 c4 10             	add    $0x10,%esp
}
80104725:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104728:	5b                   	pop    %ebx
80104729:	5e                   	pop    %esi
8010472a:	5f                   	pop    %edi
8010472b:	5d                   	pop    %ebp
    acquire(lk);
8010472c:	e9 0f 07 00 00       	jmp    80104e40 <acquire>
80104731:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104738:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010473b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104742:	e8 d9 f9 ff ff       	call   80104120 <sched>
  p->chan = 0;
80104747:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010474e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104751:	5b                   	pop    %ebx
80104752:	5e                   	pop    %esi
80104753:	5f                   	pop    %edi
80104754:	5d                   	pop    %ebp
80104755:	c3                   	ret    
    panic("sleep without lk");
80104756:	83 ec 0c             	sub    $0xc,%esp
80104759:	68 ba 80 10 80       	push   $0x801080ba
8010475e:	e8 1d bc ff ff       	call   80100380 <panic>
    panic("sleep");
80104763:	83 ec 0c             	sub    $0xc,%esp
80104766:	68 b4 80 10 80       	push   $0x801080b4
8010476b:	e8 10 bc ff ff       	call   80100380 <panic>

80104770 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104770:	55                   	push   %ebp
80104771:	89 e5                	mov    %esp,%ebp
80104773:	56                   	push   %esi
80104774:	53                   	push   %ebx
80104775:	8b 75 08             	mov    0x8(%ebp),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104778:	bb 74 32 11 80       	mov    $0x80113274,%ebx
  acquire(&ptable.lock);
8010477d:	83 ec 0c             	sub    $0xc,%esp
80104780:	68 40 32 11 80       	push   $0x80113240
80104785:	e8 b6 06 00 00       	call   80104e40 <acquire>
8010478a:	83 c4 10             	add    $0x10,%esp
8010478d:	eb 0f                	jmp    8010479e <wakeup+0x2e>
8010478f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104790:	81 c3 c0 00 00 00    	add    $0xc0,%ebx
80104796:	81 fb 74 62 11 80    	cmp    $0x80116274,%ebx
8010479c:	74 3c                	je     801047da <wakeup+0x6a>
    if(p->state == SLEEPING && p->chan == chan){
8010479e:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
801047a2:	75 ec                	jne    80104790 <wakeup+0x20>
801047a4:	3b 73 20             	cmp    0x20(%ebx),%esi
801047a7:	75 e7                	jne    80104790 <wakeup+0x20>
		add_proc_to_q(p, p->queue);
801047a9:	83 ec 08             	sub    $0x8,%esp
801047ac:	ff b3 ac 00 00 00    	push   0xac(%ebx)
801047b2:	53                   	push   %ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047b3:	81 c3 c0 00 00 00    	add    $0xc0,%ebx
      p->state = RUNNABLE;
801047b9:	c7 83 4c ff ff ff 03 	movl   $0x3,-0xb4(%ebx)
801047c0:	00 00 00 
		p->curr_ticks = 0;
801047c3:	c7 43 f0 00 00 00 00 	movl   $0x0,-0x10(%ebx)
		add_proc_to_q(p, p->queue);
801047ca:	e8 f1 f1 ff ff       	call   801039c0 <add_proc_to_q>
801047cf:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047d2:	81 fb 74 62 11 80    	cmp    $0x80116274,%ebx
801047d8:	75 c4                	jne    8010479e <wakeup+0x2e>
  wakeup1(chan);
  release(&ptable.lock);
801047da:	c7 45 08 40 32 11 80 	movl   $0x80113240,0x8(%ebp)
}
801047e1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047e4:	5b                   	pop    %ebx
801047e5:	5e                   	pop    %esi
801047e6:	5d                   	pop    %ebp
  release(&ptable.lock);
801047e7:	e9 f4 05 00 00       	jmp    80104de0 <release>
801047ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801047f0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801047f0:	55                   	push   %ebp
801047f1:	89 e5                	mov    %esp,%ebp
801047f3:	53                   	push   %ebx
801047f4:	83 ec 10             	sub    $0x10,%esp
801047f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801047fa:	68 40 32 11 80       	push   $0x80113240
801047ff:	e8 3c 06 00 00       	call   80104e40 <acquire>
80104804:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104807:	b8 74 32 11 80       	mov    $0x80113274,%eax
8010480c:	eb 0e                	jmp    8010481c <kill+0x2c>
8010480e:	66 90                	xchg   %ax,%ax
80104810:	05 c0 00 00 00       	add    $0xc0,%eax
80104815:	3d 74 62 11 80       	cmp    $0x80116274,%eax
8010481a:	74 2c                	je     80104848 <kill+0x58>
    if(p->pid == pid){
8010481c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010481f:	75 ef                	jne    80104810 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING){
80104821:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104825:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING){
8010482c:	74 3a                	je     80104868 <kill+0x78>
        #ifdef MLFQ
          p->curr_ticks = 0;
          add_proc_to_q(p, p->queue);
        #endif
      }
      release(&ptable.lock);
8010482e:	83 ec 0c             	sub    $0xc,%esp
80104831:	68 40 32 11 80       	push   $0x80113240
80104836:	e8 a5 05 00 00       	call   80104de0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
8010483b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
8010483e:	83 c4 10             	add    $0x10,%esp
80104841:	31 c0                	xor    %eax,%eax
}
80104843:	c9                   	leave  
80104844:	c3                   	ret    
80104845:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104848:	83 ec 0c             	sub    $0xc,%esp
8010484b:	68 40 32 11 80       	push   $0x80113240
80104850:	e8 8b 05 00 00       	call   80104de0 <release>
}
80104855:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104858:	83 c4 10             	add    $0x10,%esp
8010485b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104860:	c9                   	leave  
80104861:	c3                   	ret    
80104862:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
          add_proc_to_q(p, p->queue);
80104868:	83 ec 08             	sub    $0x8,%esp
        p->state = RUNNABLE;
8010486b:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
          p->curr_ticks = 0;
80104872:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80104879:	00 00 00 
          add_proc_to_q(p, p->queue);
8010487c:	ff b0 ac 00 00 00    	push   0xac(%eax)
80104882:	50                   	push   %eax
80104883:	e8 38 f1 ff ff       	call   801039c0 <add_proc_to_q>
80104888:	83 c4 10             	add    $0x10,%esp
8010488b:	eb a1                	jmp    8010482e <kill+0x3e>
8010488d:	8d 76 00             	lea    0x0(%esi),%esi

80104890 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
80104893:	57                   	push   %edi
80104894:	56                   	push   %esi
80104895:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104898:	53                   	push   %ebx
80104899:	bb e0 32 11 80       	mov    $0x801132e0,%ebx
8010489e:	83 ec 3c             	sub    $0x3c,%esp
801048a1:	eb 27                	jmp    801048ca <procdump+0x3a>
801048a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048a7:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801048a8:	83 ec 0c             	sub    $0xc,%esp
801048ab:	68 c3 85 10 80       	push   $0x801085c3
801048b0:	e8 eb bd ff ff       	call   801006a0 <cprintf>
801048b5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801048b8:	81 c3 c0 00 00 00    	add    $0xc0,%ebx
801048be:	81 fb e0 62 11 80    	cmp    $0x801162e0,%ebx
801048c4:	0f 84 7e 00 00 00    	je     80104948 <procdump+0xb8>
    if(p->state == UNUSED)
801048ca:	8b 43 a0             	mov    -0x60(%ebx),%eax
801048cd:	85 c0                	test   %eax,%eax
801048cf:	74 e7                	je     801048b8 <procdump+0x28>
      state = "???";
801048d1:	ba cb 80 10 80       	mov    $0x801080cb,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801048d6:	83 f8 05             	cmp    $0x5,%eax
801048d9:	77 11                	ja     801048ec <procdump+0x5c>
801048db:	8b 14 85 ac 82 10 80 	mov    -0x7fef7d54(,%eax,4),%edx
      state = "???";
801048e2:	b8 cb 80 10 80       	mov    $0x801080cb,%eax
801048e7:	85 d2                	test   %edx,%edx
801048e9:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801048ec:	53                   	push   %ebx
801048ed:	52                   	push   %edx
801048ee:	ff 73 a4             	push   -0x5c(%ebx)
801048f1:	68 cf 80 10 80       	push   $0x801080cf
801048f6:	e8 a5 bd ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
801048fb:	83 c4 10             	add    $0x10,%esp
801048fe:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104902:	75 a4                	jne    801048a8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104904:	83 ec 08             	sub    $0x8,%esp
80104907:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010490a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010490d:	50                   	push   %eax
8010490e:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104911:	8b 40 0c             	mov    0xc(%eax),%eax
80104914:	83 c0 08             	add    $0x8,%eax
80104917:	50                   	push   %eax
80104918:	e8 73 03 00 00       	call   80104c90 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010491d:	83 c4 10             	add    $0x10,%esp
80104920:	8b 17                	mov    (%edi),%edx
80104922:	85 d2                	test   %edx,%edx
80104924:	74 82                	je     801048a8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104926:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104929:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010492c:	52                   	push   %edx
8010492d:	68 21 7b 10 80       	push   $0x80107b21
80104932:	e8 69 bd ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104937:	83 c4 10             	add    $0x10,%esp
8010493a:	39 fe                	cmp    %edi,%esi
8010493c:	75 e2                	jne    80104920 <procdump+0x90>
8010493e:	e9 65 ff ff ff       	jmp    801048a8 <procdump+0x18>
80104943:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104947:	90                   	nop
  }
}
80104948:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010494b:	5b                   	pop    %ebx
8010494c:	5e                   	pop    %esi
8010494d:	5f                   	pop    %edi
8010494e:	5d                   	pop    %ebp
8010494f:	c3                   	ret    

80104950 <getps>:


int
getps(void) 
{
80104950:	55                   	push   %ebp
80104951:	89 e5                	mov    %esp,%ebp
80104953:	56                   	push   %esi
80104954:	53                   	push   %ebx
  cprintf("PID   State \tr_time\tw_time\tc_time\n");
  #endif
  #ifdef MLFQ
  cprintf("PID   State \tr_time\tw_time\tc_time\tn_run\tcur_q\t q0\tq1\tq2\tq3\tq4\n");
  #endif
  for (p = ptable.proc; p < &ptable.proc[NPROC]; ++p)
80104955:	bb 74 32 11 80       	mov    $0x80113274,%ebx
  acquire(&ptable.lock);
8010495a:	83 ec 0c             	sub    $0xc,%esp
8010495d:	68 40 32 11 80       	push   $0x80113240
80104962:	e8 d9 04 00 00       	call   80104e40 <acquire>
  cprintf("PID   State \tr_time\tw_time\tc_time\tn_run\tcur_q\t q0\tq1\tq2\tq3\tq4\n");
80104967:	c7 04 24 60 81 10 80 	movl   $0x80108160,(%esp)
8010496e:	e8 2d bd ff ff       	call   801006a0 <cprintf>
80104973:	83 c4 10             	add    $0x10,%esp
80104976:	eb 31                	jmp    801049a9 <getps+0x59>
80104978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010497f:	90                   	nop
    #ifdef MLFQ
   if (p->state == SLEEPING)
    {
      cprintf("%d   SLEEPING \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d\n",  p->pid,  p->rtime, ticks - p->ctime - p->rtime -p->iotime,p->ctime,p->num_run,p->queue,p->qticks[0],p->qticks[1],p->qticks[2],p->qticks[3],p->qticks[4]);
    }
    else if (p->state == RUNNING)
80104980:	83 fa 04             	cmp    $0x4,%edx
80104983:	0f 84 9f 00 00 00    	je     80104a28 <getps+0xd8>
    {
      cprintf("%d   RUNNING  \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d\n",  p->pid,  p->rtime, ticks - p->ctime - p->rtime -p->iotime,p->ctime,p->num_run,p->queue,p->qticks[0],p->qticks[1],p->qticks[2],p->qticks[3],p->qticks[4]);
    }
    else if (p->state == RUNNABLE)
80104989:	83 fa 03             	cmp    $0x3,%edx
8010498c:	0f 84 f6 00 00 00    	je     80104a88 <getps+0x138>
    {
      cprintf("%d   RUNNABLE \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d\n",  p->pid,  p->rtime, ticks - p->ctime - p->rtime -p->iotime,p->ctime,p->num_run,p->queue,p->qticks[0],p->qticks[1],p->qticks[2],p->qticks[3],p->qticks[4]);
    }
    else if (p->state == ZOMBIE)
80104992:	83 fa 05             	cmp    $0x5,%edx
80104995:	0f 84 4d 01 00 00    	je     80104ae8 <getps+0x198>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; ++p)
8010499b:	81 c3 c0 00 00 00    	add    $0xc0,%ebx
801049a1:	81 fb 74 62 11 80    	cmp    $0x80116274,%ebx
801049a7:	74 61                	je     80104a0a <getps+0xba>
    if(p->pid >= 3) {
801049a9:	8b 43 10             	mov    0x10(%ebx),%eax
801049ac:	83 f8 02             	cmp    $0x2,%eax
801049af:	7e ea                	jle    8010499b <getps+0x4b>
   if (p->state == SLEEPING)
801049b1:	8b 53 0c             	mov    0xc(%ebx),%edx
801049b4:	83 fa 02             	cmp    $0x2,%edx
801049b7:	75 c7                	jne    80104980 <getps+0x30>
      cprintf("%d   SLEEPING \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d\n",  p->pid,  p->rtime, ticks - p->ctime - p->rtime -p->iotime,p->ctime,p->num_run,p->queue,p->qticks[0],p->qticks[1],p->qticks[2],p->qticks[3],p->qticks[4]);
801049b9:	8b 93 84 00 00 00    	mov    0x84(%ebx),%edx
801049bf:	8b 8b 80 00 00 00    	mov    0x80(%ebx),%ecx
801049c5:	ff b3 a8 00 00 00    	push   0xa8(%ebx)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; ++p)
801049cb:	81 c3 c0 00 00 00    	add    $0xc0,%ebx
      cprintf("%d   SLEEPING \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d\n",  p->pid,  p->rtime, ticks - p->ctime - p->rtime -p->iotime,p->ctime,p->num_run,p->queue,p->qticks[0],p->qticks[1],p->qticks[2],p->qticks[3],p->qticks[4]);
801049d1:	ff 73 e4             	push   -0x1c(%ebx)
801049d4:	8d 34 0a             	lea    (%edx,%ecx,1),%esi
801049d7:	ff 73 e0             	push   -0x20(%ebx)
801049da:	ff 73 dc             	push   -0x24(%ebx)
801049dd:	ff 73 d8             	push   -0x28(%ebx)
801049e0:	ff 73 ec             	push   -0x14(%ebx)
801049e3:	ff 73 d4             	push   -0x2c(%ebx)
801049e6:	52                   	push   %edx
801049e7:	8b 15 84 62 11 80    	mov    0x80116284,%edx
801049ed:	29 f2                	sub    %esi,%edx
801049ef:	2b 53 bc             	sub    -0x44(%ebx),%edx
801049f2:	52                   	push   %edx
801049f3:	51                   	push   %ecx
801049f4:	50                   	push   %eax
801049f5:	68 a0 81 10 80       	push   $0x801081a0
801049fa:	e8 a1 bc ff ff       	call   801006a0 <cprintf>
801049ff:	83 c4 30             	add    $0x30,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; ++p)
80104a02:	81 fb 74 62 11 80    	cmp    $0x80116274,%ebx
80104a08:	75 9f                	jne    801049a9 <getps+0x59>
    }
    #endif

  }
  }
  release(&ptable.lock);
80104a0a:	83 ec 0c             	sub    $0xc,%esp
80104a0d:	68 40 32 11 80       	push   $0x80113240
80104a12:	e8 c9 03 00 00       	call   80104de0 <release>
	return ret;
}
80104a17:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a1a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a1f:	5b                   	pop    %ebx
80104a20:	5e                   	pop    %esi
80104a21:	5d                   	pop    %ebp
80104a22:	c3                   	ret    
80104a23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a27:	90                   	nop
      cprintf("%d   RUNNING  \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d\n",  p->pid,  p->rtime, ticks - p->ctime - p->rtime -p->iotime,p->ctime,p->num_run,p->queue,p->qticks[0],p->qticks[1],p->qticks[2],p->qticks[3],p->qticks[4]);
80104a28:	8b 93 84 00 00 00    	mov    0x84(%ebx),%edx
80104a2e:	8b 8b 80 00 00 00    	mov    0x80(%ebx),%ecx
80104a34:	ff b3 a8 00 00 00    	push   0xa8(%ebx)
80104a3a:	ff b3 a4 00 00 00    	push   0xa4(%ebx)
80104a40:	8d 34 0a             	lea    (%edx,%ecx,1),%esi
80104a43:	ff b3 a0 00 00 00    	push   0xa0(%ebx)
80104a49:	ff b3 9c 00 00 00    	push   0x9c(%ebx)
80104a4f:	ff b3 98 00 00 00    	push   0x98(%ebx)
80104a55:	ff b3 ac 00 00 00    	push   0xac(%ebx)
80104a5b:	ff b3 94 00 00 00    	push   0x94(%ebx)
80104a61:	52                   	push   %edx
80104a62:	8b 15 84 62 11 80    	mov    0x80116284,%edx
80104a68:	29 f2                	sub    %esi,%edx
80104a6a:	2b 53 7c             	sub    0x7c(%ebx),%edx
80104a6d:	52                   	push   %edx
80104a6e:	51                   	push   %ecx
80104a6f:	50                   	push   %eax
80104a70:	68 e4 81 10 80       	push   $0x801081e4
80104a75:	e8 26 bc ff ff       	call   801006a0 <cprintf>
80104a7a:	83 c4 30             	add    $0x30,%esp
80104a7d:	e9 19 ff ff ff       	jmp    8010499b <getps+0x4b>
80104a82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("%d   RUNNABLE \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d\n",  p->pid,  p->rtime, ticks - p->ctime - p->rtime -p->iotime,p->ctime,p->num_run,p->queue,p->qticks[0],p->qticks[1],p->qticks[2],p->qticks[3],p->qticks[4]);
80104a88:	8b 93 84 00 00 00    	mov    0x84(%ebx),%edx
80104a8e:	8b 8b 80 00 00 00    	mov    0x80(%ebx),%ecx
80104a94:	ff b3 a8 00 00 00    	push   0xa8(%ebx)
80104a9a:	ff b3 a4 00 00 00    	push   0xa4(%ebx)
80104aa0:	8d 34 0a             	lea    (%edx,%ecx,1),%esi
80104aa3:	ff b3 a0 00 00 00    	push   0xa0(%ebx)
80104aa9:	ff b3 9c 00 00 00    	push   0x9c(%ebx)
80104aaf:	ff b3 98 00 00 00    	push   0x98(%ebx)
80104ab5:	ff b3 ac 00 00 00    	push   0xac(%ebx)
80104abb:	ff b3 94 00 00 00    	push   0x94(%ebx)
80104ac1:	52                   	push   %edx
80104ac2:	8b 15 84 62 11 80    	mov    0x80116284,%edx
80104ac8:	29 f2                	sub    %esi,%edx
80104aca:	2b 53 7c             	sub    0x7c(%ebx),%edx
80104acd:	52                   	push   %edx
80104ace:	51                   	push   %ecx
80104acf:	50                   	push   %eax
80104ad0:	68 28 82 10 80       	push   $0x80108228
80104ad5:	e8 c6 bb ff ff       	call   801006a0 <cprintf>
80104ada:	83 c4 30             	add    $0x30,%esp
80104add:	e9 b9 fe ff ff       	jmp    8010499b <getps+0x4b>
80104ae2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("%d    ZOMBIE \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d\n",  p->pid,  p->rtime, p->etime - p->ctime - p->rtime -p->iotime,p->ctime,p->num_run,-1,p->qticks[0],p->qticks[1],p->qticks[2],p->qticks[3],p->qticks[4]);
80104ae8:	8b b3 84 00 00 00    	mov    0x84(%ebx),%esi
80104aee:	8b 93 88 00 00 00    	mov    0x88(%ebx),%edx
80104af4:	ff b3 a8 00 00 00    	push   0xa8(%ebx)
80104afa:	8b 8b 80 00 00 00    	mov    0x80(%ebx),%ecx
80104b00:	ff b3 a4 00 00 00    	push   0xa4(%ebx)
80104b06:	29 f2                	sub    %esi,%edx
80104b08:	ff b3 a0 00 00 00    	push   0xa0(%ebx)
80104b0e:	29 ca                	sub    %ecx,%edx
80104b10:	2b 53 7c             	sub    0x7c(%ebx),%edx
80104b13:	ff b3 9c 00 00 00    	push   0x9c(%ebx)
80104b19:	ff b3 98 00 00 00    	push   0x98(%ebx)
80104b1f:	6a ff                	push   $0xffffffff
80104b21:	ff b3 94 00 00 00    	push   0x94(%ebx)
80104b27:	56                   	push   %esi
80104b28:	52                   	push   %edx
80104b29:	51                   	push   %ecx
80104b2a:	50                   	push   %eax
80104b2b:	68 6c 82 10 80       	push   $0x8010826c
80104b30:	e8 6b bb ff ff       	call   801006a0 <cprintf>
80104b35:	83 c4 30             	add    $0x30,%esp
80104b38:	e9 5e fe ff ff       	jmp    8010499b <getps+0x4b>
80104b3d:	66 90                	xchg   %ax,%ax
80104b3f:	90                   	nop

80104b40 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104b40:	55                   	push   %ebp
80104b41:	89 e5                	mov    %esp,%ebp
80104b43:	53                   	push   %ebx
80104b44:	83 ec 0c             	sub    $0xc,%esp
80104b47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104b4a:	68 c4 82 10 80       	push   $0x801082c4
80104b4f:	8d 43 04             	lea    0x4(%ebx),%eax
80104b52:	50                   	push   %eax
80104b53:	e8 18 01 00 00       	call   80104c70 <initlock>
  lk->name = name;
80104b58:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104b5b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104b61:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104b64:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104b6b:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104b6e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b71:	c9                   	leave  
80104b72:	c3                   	ret    
80104b73:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b80 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104b80:	55                   	push   %ebp
80104b81:	89 e5                	mov    %esp,%ebp
80104b83:	56                   	push   %esi
80104b84:	53                   	push   %ebx
80104b85:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104b88:	8d 73 04             	lea    0x4(%ebx),%esi
80104b8b:	83 ec 0c             	sub    $0xc,%esp
80104b8e:	56                   	push   %esi
80104b8f:	e8 ac 02 00 00       	call   80104e40 <acquire>
  while (lk->locked) {
80104b94:	8b 13                	mov    (%ebx),%edx
80104b96:	83 c4 10             	add    $0x10,%esp
80104b99:	85 d2                	test   %edx,%edx
80104b9b:	74 16                	je     80104bb3 <acquiresleep+0x33>
80104b9d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104ba0:	83 ec 08             	sub    $0x8,%esp
80104ba3:	56                   	push   %esi
80104ba4:	53                   	push   %ebx
80104ba5:	e8 06 fb ff ff       	call   801046b0 <sleep>
  while (lk->locked) {
80104baa:	8b 03                	mov    (%ebx),%eax
80104bac:	83 c4 10             	add    $0x10,%esp
80104baf:	85 c0                	test   %eax,%eax
80104bb1:	75 ed                	jne    80104ba0 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104bb3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104bb9:	e8 42 f0 ff ff       	call   80103c00 <myproc>
80104bbe:	8b 40 10             	mov    0x10(%eax),%eax
80104bc1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104bc4:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104bc7:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104bca:	5b                   	pop    %ebx
80104bcb:	5e                   	pop    %esi
80104bcc:	5d                   	pop    %ebp
  release(&lk->lk);
80104bcd:	e9 0e 02 00 00       	jmp    80104de0 <release>
80104bd2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104be0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104be0:	55                   	push   %ebp
80104be1:	89 e5                	mov    %esp,%ebp
80104be3:	56                   	push   %esi
80104be4:	53                   	push   %ebx
80104be5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104be8:	8d 73 04             	lea    0x4(%ebx),%esi
80104beb:	83 ec 0c             	sub    $0xc,%esp
80104bee:	56                   	push   %esi
80104bef:	e8 4c 02 00 00       	call   80104e40 <acquire>
  lk->locked = 0;
80104bf4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104bfa:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104c01:	89 1c 24             	mov    %ebx,(%esp)
80104c04:	e8 67 fb ff ff       	call   80104770 <wakeup>
  release(&lk->lk);
80104c09:	89 75 08             	mov    %esi,0x8(%ebp)
80104c0c:	83 c4 10             	add    $0x10,%esp
}
80104c0f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c12:	5b                   	pop    %ebx
80104c13:	5e                   	pop    %esi
80104c14:	5d                   	pop    %ebp
  release(&lk->lk);
80104c15:	e9 c6 01 00 00       	jmp    80104de0 <release>
80104c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c20 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104c20:	55                   	push   %ebp
80104c21:	89 e5                	mov    %esp,%ebp
80104c23:	57                   	push   %edi
80104c24:	31 ff                	xor    %edi,%edi
80104c26:	56                   	push   %esi
80104c27:	53                   	push   %ebx
80104c28:	83 ec 18             	sub    $0x18,%esp
80104c2b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104c2e:	8d 73 04             	lea    0x4(%ebx),%esi
80104c31:	56                   	push   %esi
80104c32:	e8 09 02 00 00       	call   80104e40 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104c37:	8b 03                	mov    (%ebx),%eax
80104c39:	83 c4 10             	add    $0x10,%esp
80104c3c:	85 c0                	test   %eax,%eax
80104c3e:	75 18                	jne    80104c58 <holdingsleep+0x38>
  release(&lk->lk);
80104c40:	83 ec 0c             	sub    $0xc,%esp
80104c43:	56                   	push   %esi
80104c44:	e8 97 01 00 00       	call   80104de0 <release>
  return r;
}
80104c49:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c4c:	89 f8                	mov    %edi,%eax
80104c4e:	5b                   	pop    %ebx
80104c4f:	5e                   	pop    %esi
80104c50:	5f                   	pop    %edi
80104c51:	5d                   	pop    %ebp
80104c52:	c3                   	ret    
80104c53:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c57:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104c58:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104c5b:	e8 a0 ef ff ff       	call   80103c00 <myproc>
80104c60:	39 58 10             	cmp    %ebx,0x10(%eax)
80104c63:	0f 94 c0             	sete   %al
80104c66:	0f b6 c0             	movzbl %al,%eax
80104c69:	89 c7                	mov    %eax,%edi
80104c6b:	eb d3                	jmp    80104c40 <holdingsleep+0x20>
80104c6d:	66 90                	xchg   %ax,%ax
80104c6f:	90                   	nop

80104c70 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104c70:	55                   	push   %ebp
80104c71:	89 e5                	mov    %esp,%ebp
80104c73:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104c76:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104c79:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104c7f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104c82:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104c89:	5d                   	pop    %ebp
80104c8a:	c3                   	ret    
80104c8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c8f:	90                   	nop

80104c90 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104c90:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104c91:	31 d2                	xor    %edx,%edx
{
80104c93:	89 e5                	mov    %esp,%ebp
80104c95:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104c96:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104c99:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104c9c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104c9f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104ca0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104ca6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104cac:	77 1a                	ja     80104cc8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104cae:	8b 58 04             	mov    0x4(%eax),%ebx
80104cb1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104cb4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104cb7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104cb9:	83 fa 0a             	cmp    $0xa,%edx
80104cbc:	75 e2                	jne    80104ca0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104cbe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cc1:	c9                   	leave  
80104cc2:	c3                   	ret    
80104cc3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104cc7:	90                   	nop
  for(; i < 10; i++)
80104cc8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104ccb:	8d 51 28             	lea    0x28(%ecx),%edx
80104cce:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104cd0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104cd6:	83 c0 04             	add    $0x4,%eax
80104cd9:	39 d0                	cmp    %edx,%eax
80104cdb:	75 f3                	jne    80104cd0 <getcallerpcs+0x40>
}
80104cdd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ce0:	c9                   	leave  
80104ce1:	c3                   	ret    
80104ce2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104cf0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104cf0:	55                   	push   %ebp
80104cf1:	89 e5                	mov    %esp,%ebp
80104cf3:	53                   	push   %ebx
80104cf4:	83 ec 04             	sub    $0x4,%esp
80104cf7:	9c                   	pushf  
80104cf8:	5b                   	pop    %ebx
  asm volatile("cli");
80104cf9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104cfa:	e8 81 ee ff ff       	call   80103b80 <mycpu>
80104cff:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104d05:	85 c0                	test   %eax,%eax
80104d07:	74 17                	je     80104d20 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104d09:	e8 72 ee ff ff       	call   80103b80 <mycpu>
80104d0e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104d15:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d18:	c9                   	leave  
80104d19:	c3                   	ret    
80104d1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104d20:	e8 5b ee ff ff       	call   80103b80 <mycpu>
80104d25:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104d2b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104d31:	eb d6                	jmp    80104d09 <pushcli+0x19>
80104d33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104d40 <popcli>:

void
popcli(void)
{
80104d40:	55                   	push   %ebp
80104d41:	89 e5                	mov    %esp,%ebp
80104d43:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104d46:	9c                   	pushf  
80104d47:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104d48:	f6 c4 02             	test   $0x2,%ah
80104d4b:	75 35                	jne    80104d82 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104d4d:	e8 2e ee ff ff       	call   80103b80 <mycpu>
80104d52:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104d59:	78 34                	js     80104d8f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104d5b:	e8 20 ee ff ff       	call   80103b80 <mycpu>
80104d60:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104d66:	85 d2                	test   %edx,%edx
80104d68:	74 06                	je     80104d70 <popcli+0x30>
    sti();
}
80104d6a:	c9                   	leave  
80104d6b:	c3                   	ret    
80104d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104d70:	e8 0b ee ff ff       	call   80103b80 <mycpu>
80104d75:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104d7b:	85 c0                	test   %eax,%eax
80104d7d:	74 eb                	je     80104d6a <popcli+0x2a>
  asm volatile("sti");
80104d7f:	fb                   	sti    
}
80104d80:	c9                   	leave  
80104d81:	c3                   	ret    
    panic("popcli - interruptible");
80104d82:	83 ec 0c             	sub    $0xc,%esp
80104d85:	68 cf 82 10 80       	push   $0x801082cf
80104d8a:	e8 f1 b5 ff ff       	call   80100380 <panic>
    panic("popcli");
80104d8f:	83 ec 0c             	sub    $0xc,%esp
80104d92:	68 e6 82 10 80       	push   $0x801082e6
80104d97:	e8 e4 b5 ff ff       	call   80100380 <panic>
80104d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104da0 <holding>:
{
80104da0:	55                   	push   %ebp
80104da1:	89 e5                	mov    %esp,%ebp
80104da3:	56                   	push   %esi
80104da4:	53                   	push   %ebx
80104da5:	8b 75 08             	mov    0x8(%ebp),%esi
80104da8:	31 db                	xor    %ebx,%ebx
  pushcli();
80104daa:	e8 41 ff ff ff       	call   80104cf0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104daf:	8b 06                	mov    (%esi),%eax
80104db1:	85 c0                	test   %eax,%eax
80104db3:	75 0b                	jne    80104dc0 <holding+0x20>
  popcli();
80104db5:	e8 86 ff ff ff       	call   80104d40 <popcli>
}
80104dba:	89 d8                	mov    %ebx,%eax
80104dbc:	5b                   	pop    %ebx
80104dbd:	5e                   	pop    %esi
80104dbe:	5d                   	pop    %ebp
80104dbf:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104dc0:	8b 5e 08             	mov    0x8(%esi),%ebx
80104dc3:	e8 b8 ed ff ff       	call   80103b80 <mycpu>
80104dc8:	39 c3                	cmp    %eax,%ebx
80104dca:	0f 94 c3             	sete   %bl
  popcli();
80104dcd:	e8 6e ff ff ff       	call   80104d40 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104dd2:	0f b6 db             	movzbl %bl,%ebx
}
80104dd5:	89 d8                	mov    %ebx,%eax
80104dd7:	5b                   	pop    %ebx
80104dd8:	5e                   	pop    %esi
80104dd9:	5d                   	pop    %ebp
80104dda:	c3                   	ret    
80104ddb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ddf:	90                   	nop

80104de0 <release>:
{
80104de0:	55                   	push   %ebp
80104de1:	89 e5                	mov    %esp,%ebp
80104de3:	56                   	push   %esi
80104de4:	53                   	push   %ebx
80104de5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104de8:	e8 03 ff ff ff       	call   80104cf0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104ded:	8b 03                	mov    (%ebx),%eax
80104def:	85 c0                	test   %eax,%eax
80104df1:	75 15                	jne    80104e08 <release+0x28>
  popcli();
80104df3:	e8 48 ff ff ff       	call   80104d40 <popcli>
    panic("release");
80104df8:	83 ec 0c             	sub    $0xc,%esp
80104dfb:	68 ed 82 10 80       	push   $0x801082ed
80104e00:	e8 7b b5 ff ff       	call   80100380 <panic>
80104e05:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104e08:	8b 73 08             	mov    0x8(%ebx),%esi
80104e0b:	e8 70 ed ff ff       	call   80103b80 <mycpu>
80104e10:	39 c6                	cmp    %eax,%esi
80104e12:	75 df                	jne    80104df3 <release+0x13>
  popcli();
80104e14:	e8 27 ff ff ff       	call   80104d40 <popcli>
  lk->pcs[0] = 0;
80104e19:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104e20:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104e27:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104e2c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104e32:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e35:	5b                   	pop    %ebx
80104e36:	5e                   	pop    %esi
80104e37:	5d                   	pop    %ebp
  popcli();
80104e38:	e9 03 ff ff ff       	jmp    80104d40 <popcli>
80104e3d:	8d 76 00             	lea    0x0(%esi),%esi

80104e40 <acquire>:
{
80104e40:	55                   	push   %ebp
80104e41:	89 e5                	mov    %esp,%ebp
80104e43:	53                   	push   %ebx
80104e44:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104e47:	e8 a4 fe ff ff       	call   80104cf0 <pushcli>
  if(holding(lk))
80104e4c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104e4f:	e8 9c fe ff ff       	call   80104cf0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104e54:	8b 03                	mov    (%ebx),%eax
80104e56:	85 c0                	test   %eax,%eax
80104e58:	75 7e                	jne    80104ed8 <acquire+0x98>
  popcli();
80104e5a:	e8 e1 fe ff ff       	call   80104d40 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80104e5f:	b9 01 00 00 00       	mov    $0x1,%ecx
80104e64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80104e68:	8b 55 08             	mov    0x8(%ebp),%edx
80104e6b:	89 c8                	mov    %ecx,%eax
80104e6d:	f0 87 02             	lock xchg %eax,(%edx)
80104e70:	85 c0                	test   %eax,%eax
80104e72:	75 f4                	jne    80104e68 <acquire+0x28>
  __sync_synchronize();
80104e74:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104e79:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104e7c:	e8 ff ec ff ff       	call   80103b80 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104e81:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80104e84:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104e86:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104e89:	31 c0                	xor    %eax,%eax
80104e8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e8f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104e90:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104e96:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104e9c:	77 1a                	ja     80104eb8 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
80104e9e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104ea1:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104ea5:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104ea8:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104eaa:	83 f8 0a             	cmp    $0xa,%eax
80104ead:	75 e1                	jne    80104e90 <acquire+0x50>
}
80104eaf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104eb2:	c9                   	leave  
80104eb3:	c3                   	ret    
80104eb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104eb8:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
80104ebc:	8d 51 34             	lea    0x34(%ecx),%edx
80104ebf:	90                   	nop
    pcs[i] = 0;
80104ec0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104ec6:	83 c0 04             	add    $0x4,%eax
80104ec9:	39 c2                	cmp    %eax,%edx
80104ecb:	75 f3                	jne    80104ec0 <acquire+0x80>
}
80104ecd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ed0:	c9                   	leave  
80104ed1:	c3                   	ret    
80104ed2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104ed8:	8b 5b 08             	mov    0x8(%ebx),%ebx
80104edb:	e8 a0 ec ff ff       	call   80103b80 <mycpu>
80104ee0:	39 c3                	cmp    %eax,%ebx
80104ee2:	0f 85 72 ff ff ff    	jne    80104e5a <acquire+0x1a>
  popcli();
80104ee8:	e8 53 fe ff ff       	call   80104d40 <popcli>
    panic("acquire");
80104eed:	83 ec 0c             	sub    $0xc,%esp
80104ef0:	68 f5 82 10 80       	push   $0x801082f5
80104ef5:	e8 86 b4 ff ff       	call   80100380 <panic>
80104efa:	66 90                	xchg   %ax,%ax
80104efc:	66 90                	xchg   %ax,%ax
80104efe:	66 90                	xchg   %ax,%ax

80104f00 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104f00:	55                   	push   %ebp
80104f01:	89 e5                	mov    %esp,%ebp
80104f03:	57                   	push   %edi
80104f04:	8b 55 08             	mov    0x8(%ebp),%edx
80104f07:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104f0a:	53                   	push   %ebx
80104f0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104f0e:	89 d7                	mov    %edx,%edi
80104f10:	09 cf                	or     %ecx,%edi
80104f12:	83 e7 03             	and    $0x3,%edi
80104f15:	75 29                	jne    80104f40 <memset+0x40>
    c &= 0xFF;
80104f17:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104f1a:	c1 e0 18             	shl    $0x18,%eax
80104f1d:	89 fb                	mov    %edi,%ebx
80104f1f:	c1 e9 02             	shr    $0x2,%ecx
80104f22:	c1 e3 10             	shl    $0x10,%ebx
80104f25:	09 d8                	or     %ebx,%eax
80104f27:	09 f8                	or     %edi,%eax
80104f29:	c1 e7 08             	shl    $0x8,%edi
80104f2c:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104f2e:	89 d7                	mov    %edx,%edi
80104f30:	fc                   	cld    
80104f31:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104f33:	5b                   	pop    %ebx
80104f34:	89 d0                	mov    %edx,%eax
80104f36:	5f                   	pop    %edi
80104f37:	5d                   	pop    %ebp
80104f38:	c3                   	ret    
80104f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104f40:	89 d7                	mov    %edx,%edi
80104f42:	fc                   	cld    
80104f43:	f3 aa                	rep stos %al,%es:(%edi)
80104f45:	5b                   	pop    %ebx
80104f46:	89 d0                	mov    %edx,%eax
80104f48:	5f                   	pop    %edi
80104f49:	5d                   	pop    %ebp
80104f4a:	c3                   	ret    
80104f4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f4f:	90                   	nop

80104f50 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104f50:	55                   	push   %ebp
80104f51:	89 e5                	mov    %esp,%ebp
80104f53:	56                   	push   %esi
80104f54:	8b 75 10             	mov    0x10(%ebp),%esi
80104f57:	8b 55 08             	mov    0x8(%ebp),%edx
80104f5a:	53                   	push   %ebx
80104f5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104f5e:	85 f6                	test   %esi,%esi
80104f60:	74 2e                	je     80104f90 <memcmp+0x40>
80104f62:	01 c6                	add    %eax,%esi
80104f64:	eb 14                	jmp    80104f7a <memcmp+0x2a>
80104f66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f6d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104f70:	83 c0 01             	add    $0x1,%eax
80104f73:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104f76:	39 f0                	cmp    %esi,%eax
80104f78:	74 16                	je     80104f90 <memcmp+0x40>
    if(*s1 != *s2)
80104f7a:	0f b6 0a             	movzbl (%edx),%ecx
80104f7d:	0f b6 18             	movzbl (%eax),%ebx
80104f80:	38 d9                	cmp    %bl,%cl
80104f82:	74 ec                	je     80104f70 <memcmp+0x20>
      return *s1 - *s2;
80104f84:	0f b6 c1             	movzbl %cl,%eax
80104f87:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104f89:	5b                   	pop    %ebx
80104f8a:	5e                   	pop    %esi
80104f8b:	5d                   	pop    %ebp
80104f8c:	c3                   	ret    
80104f8d:	8d 76 00             	lea    0x0(%esi),%esi
80104f90:	5b                   	pop    %ebx
  return 0;
80104f91:	31 c0                	xor    %eax,%eax
}
80104f93:	5e                   	pop    %esi
80104f94:	5d                   	pop    %ebp
80104f95:	c3                   	ret    
80104f96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f9d:	8d 76 00             	lea    0x0(%esi),%esi

80104fa0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104fa0:	55                   	push   %ebp
80104fa1:	89 e5                	mov    %esp,%ebp
80104fa3:	57                   	push   %edi
80104fa4:	8b 55 08             	mov    0x8(%ebp),%edx
80104fa7:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104faa:	56                   	push   %esi
80104fab:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104fae:	39 d6                	cmp    %edx,%esi
80104fb0:	73 26                	jae    80104fd8 <memmove+0x38>
80104fb2:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104fb5:	39 fa                	cmp    %edi,%edx
80104fb7:	73 1f                	jae    80104fd8 <memmove+0x38>
80104fb9:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104fbc:	85 c9                	test   %ecx,%ecx
80104fbe:	74 0c                	je     80104fcc <memmove+0x2c>
      *--d = *--s;
80104fc0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104fc4:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104fc7:	83 e8 01             	sub    $0x1,%eax
80104fca:	73 f4                	jae    80104fc0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104fcc:	5e                   	pop    %esi
80104fcd:	89 d0                	mov    %edx,%eax
80104fcf:	5f                   	pop    %edi
80104fd0:	5d                   	pop    %ebp
80104fd1:	c3                   	ret    
80104fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104fd8:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104fdb:	89 d7                	mov    %edx,%edi
80104fdd:	85 c9                	test   %ecx,%ecx
80104fdf:	74 eb                	je     80104fcc <memmove+0x2c>
80104fe1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104fe8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104fe9:	39 c6                	cmp    %eax,%esi
80104feb:	75 fb                	jne    80104fe8 <memmove+0x48>
}
80104fed:	5e                   	pop    %esi
80104fee:	89 d0                	mov    %edx,%eax
80104ff0:	5f                   	pop    %edi
80104ff1:	5d                   	pop    %ebp
80104ff2:	c3                   	ret    
80104ff3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105000 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80105000:	eb 9e                	jmp    80104fa0 <memmove>
80105002:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105010 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80105010:	55                   	push   %ebp
80105011:	89 e5                	mov    %esp,%ebp
80105013:	56                   	push   %esi
80105014:	8b 75 10             	mov    0x10(%ebp),%esi
80105017:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010501a:	53                   	push   %ebx
8010501b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
8010501e:	85 f6                	test   %esi,%esi
80105020:	74 2e                	je     80105050 <strncmp+0x40>
80105022:	01 d6                	add    %edx,%esi
80105024:	eb 18                	jmp    8010503e <strncmp+0x2e>
80105026:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010502d:	8d 76 00             	lea    0x0(%esi),%esi
80105030:	38 d8                	cmp    %bl,%al
80105032:	75 14                	jne    80105048 <strncmp+0x38>
    n--, p++, q++;
80105034:	83 c2 01             	add    $0x1,%edx
80105037:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010503a:	39 f2                	cmp    %esi,%edx
8010503c:	74 12                	je     80105050 <strncmp+0x40>
8010503e:	0f b6 01             	movzbl (%ecx),%eax
80105041:	0f b6 1a             	movzbl (%edx),%ebx
80105044:	84 c0                	test   %al,%al
80105046:	75 e8                	jne    80105030 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80105048:	29 d8                	sub    %ebx,%eax
}
8010504a:	5b                   	pop    %ebx
8010504b:	5e                   	pop    %esi
8010504c:	5d                   	pop    %ebp
8010504d:	c3                   	ret    
8010504e:	66 90                	xchg   %ax,%ax
80105050:	5b                   	pop    %ebx
    return 0;
80105051:	31 c0                	xor    %eax,%eax
}
80105053:	5e                   	pop    %esi
80105054:	5d                   	pop    %ebp
80105055:	c3                   	ret    
80105056:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010505d:	8d 76 00             	lea    0x0(%esi),%esi

80105060 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105060:	55                   	push   %ebp
80105061:	89 e5                	mov    %esp,%ebp
80105063:	57                   	push   %edi
80105064:	56                   	push   %esi
80105065:	8b 75 08             	mov    0x8(%ebp),%esi
80105068:	53                   	push   %ebx
80105069:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010506c:	89 f0                	mov    %esi,%eax
8010506e:	eb 15                	jmp    80105085 <strncpy+0x25>
80105070:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80105074:	8b 7d 0c             	mov    0xc(%ebp),%edi
80105077:	83 c0 01             	add    $0x1,%eax
8010507a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
8010507e:	88 50 ff             	mov    %dl,-0x1(%eax)
80105081:	84 d2                	test   %dl,%dl
80105083:	74 09                	je     8010508e <strncpy+0x2e>
80105085:	89 cb                	mov    %ecx,%ebx
80105087:	83 e9 01             	sub    $0x1,%ecx
8010508a:	85 db                	test   %ebx,%ebx
8010508c:	7f e2                	jg     80105070 <strncpy+0x10>
    ;
  while(n-- > 0)
8010508e:	89 c2                	mov    %eax,%edx
80105090:	85 c9                	test   %ecx,%ecx
80105092:	7e 17                	jle    801050ab <strncpy+0x4b>
80105094:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80105098:	83 c2 01             	add    $0x1,%edx
8010509b:	89 c1                	mov    %eax,%ecx
8010509d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
801050a1:	29 d1                	sub    %edx,%ecx
801050a3:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
801050a7:	85 c9                	test   %ecx,%ecx
801050a9:	7f ed                	jg     80105098 <strncpy+0x38>
  return os;
}
801050ab:	5b                   	pop    %ebx
801050ac:	89 f0                	mov    %esi,%eax
801050ae:	5e                   	pop    %esi
801050af:	5f                   	pop    %edi
801050b0:	5d                   	pop    %ebp
801050b1:	c3                   	ret    
801050b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801050c0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801050c0:	55                   	push   %ebp
801050c1:	89 e5                	mov    %esp,%ebp
801050c3:	56                   	push   %esi
801050c4:	8b 55 10             	mov    0x10(%ebp),%edx
801050c7:	8b 75 08             	mov    0x8(%ebp),%esi
801050ca:	53                   	push   %ebx
801050cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
801050ce:	85 d2                	test   %edx,%edx
801050d0:	7e 25                	jle    801050f7 <safestrcpy+0x37>
801050d2:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
801050d6:	89 f2                	mov    %esi,%edx
801050d8:	eb 16                	jmp    801050f0 <safestrcpy+0x30>
801050da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801050e0:	0f b6 08             	movzbl (%eax),%ecx
801050e3:	83 c0 01             	add    $0x1,%eax
801050e6:	83 c2 01             	add    $0x1,%edx
801050e9:	88 4a ff             	mov    %cl,-0x1(%edx)
801050ec:	84 c9                	test   %cl,%cl
801050ee:	74 04                	je     801050f4 <safestrcpy+0x34>
801050f0:	39 d8                	cmp    %ebx,%eax
801050f2:	75 ec                	jne    801050e0 <safestrcpy+0x20>
    ;
  *s = 0;
801050f4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
801050f7:	89 f0                	mov    %esi,%eax
801050f9:	5b                   	pop    %ebx
801050fa:	5e                   	pop    %esi
801050fb:	5d                   	pop    %ebp
801050fc:	c3                   	ret    
801050fd:	8d 76 00             	lea    0x0(%esi),%esi

80105100 <strlen>:

int
strlen(const char *s)
{
80105100:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105101:	31 c0                	xor    %eax,%eax
{
80105103:	89 e5                	mov    %esp,%ebp
80105105:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105108:	80 3a 00             	cmpb   $0x0,(%edx)
8010510b:	74 0c                	je     80105119 <strlen+0x19>
8010510d:	8d 76 00             	lea    0x0(%esi),%esi
80105110:	83 c0 01             	add    $0x1,%eax
80105113:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105117:	75 f7                	jne    80105110 <strlen+0x10>
    ;
  return n;
}
80105119:	5d                   	pop    %ebp
8010511a:	c3                   	ret    

8010511b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010511b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010511f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105123:	55                   	push   %ebp
  pushl %ebx
80105124:	53                   	push   %ebx
  pushl %esi
80105125:	56                   	push   %esi
  pushl %edi
80105126:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105127:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105129:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010512b:	5f                   	pop    %edi
  popl %esi
8010512c:	5e                   	pop    %esi
  popl %ebx
8010512d:	5b                   	pop    %ebx
  popl %ebp
8010512e:	5d                   	pop    %ebp
  ret
8010512f:	c3                   	ret    

80105130 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105130:	55                   	push   %ebp
80105131:	89 e5                	mov    %esp,%ebp
80105133:	53                   	push   %ebx
80105134:	83 ec 04             	sub    $0x4,%esp
80105137:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010513a:	e8 c1 ea ff ff       	call   80103c00 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010513f:	8b 00                	mov    (%eax),%eax
80105141:	39 d8                	cmp    %ebx,%eax
80105143:	76 1b                	jbe    80105160 <fetchint+0x30>
80105145:	8d 53 04             	lea    0x4(%ebx),%edx
80105148:	39 d0                	cmp    %edx,%eax
8010514a:	72 14                	jb     80105160 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010514c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010514f:	8b 13                	mov    (%ebx),%edx
80105151:	89 10                	mov    %edx,(%eax)
  return 0;
80105153:	31 c0                	xor    %eax,%eax
}
80105155:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105158:	c9                   	leave  
80105159:	c3                   	ret    
8010515a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105160:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105165:	eb ee                	jmp    80105155 <fetchint+0x25>
80105167:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010516e:	66 90                	xchg   %ax,%ax

80105170 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105170:	55                   	push   %ebp
80105171:	89 e5                	mov    %esp,%ebp
80105173:	53                   	push   %ebx
80105174:	83 ec 04             	sub    $0x4,%esp
80105177:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010517a:	e8 81 ea ff ff       	call   80103c00 <myproc>

  if(addr >= curproc->sz)
8010517f:	39 18                	cmp    %ebx,(%eax)
80105181:	76 2d                	jbe    801051b0 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80105183:	8b 55 0c             	mov    0xc(%ebp),%edx
80105186:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80105188:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010518a:	39 d3                	cmp    %edx,%ebx
8010518c:	73 22                	jae    801051b0 <fetchstr+0x40>
8010518e:	89 d8                	mov    %ebx,%eax
80105190:	eb 0d                	jmp    8010519f <fetchstr+0x2f>
80105192:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105198:	83 c0 01             	add    $0x1,%eax
8010519b:	39 c2                	cmp    %eax,%edx
8010519d:	76 11                	jbe    801051b0 <fetchstr+0x40>
    if(*s == 0)
8010519f:	80 38 00             	cmpb   $0x0,(%eax)
801051a2:	75 f4                	jne    80105198 <fetchstr+0x28>
      return s - *pp;
801051a4:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
801051a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801051a9:	c9                   	leave  
801051aa:	c3                   	ret    
801051ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801051af:	90                   	nop
801051b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
801051b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051b8:	c9                   	leave  
801051b9:	c3                   	ret    
801051ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801051c0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801051c0:	55                   	push   %ebp
801051c1:	89 e5                	mov    %esp,%ebp
801051c3:	56                   	push   %esi
801051c4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801051c5:	e8 36 ea ff ff       	call   80103c00 <myproc>
801051ca:	8b 55 08             	mov    0x8(%ebp),%edx
801051cd:	8b 40 18             	mov    0x18(%eax),%eax
801051d0:	8b 40 44             	mov    0x44(%eax),%eax
801051d3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801051d6:	e8 25 ea ff ff       	call   80103c00 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801051db:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801051de:	8b 00                	mov    (%eax),%eax
801051e0:	39 c6                	cmp    %eax,%esi
801051e2:	73 1c                	jae    80105200 <argint+0x40>
801051e4:	8d 53 08             	lea    0x8(%ebx),%edx
801051e7:	39 d0                	cmp    %edx,%eax
801051e9:	72 15                	jb     80105200 <argint+0x40>
  *ip = *(int*)(addr);
801051eb:	8b 45 0c             	mov    0xc(%ebp),%eax
801051ee:	8b 53 04             	mov    0x4(%ebx),%edx
801051f1:	89 10                	mov    %edx,(%eax)
  return 0;
801051f3:	31 c0                	xor    %eax,%eax
}
801051f5:	5b                   	pop    %ebx
801051f6:	5e                   	pop    %esi
801051f7:	5d                   	pop    %ebp
801051f8:	c3                   	ret    
801051f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105200:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105205:	eb ee                	jmp    801051f5 <argint+0x35>
80105207:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010520e:	66 90                	xchg   %ax,%ax

80105210 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105210:	55                   	push   %ebp
80105211:	89 e5                	mov    %esp,%ebp
80105213:	57                   	push   %edi
80105214:	56                   	push   %esi
80105215:	53                   	push   %ebx
80105216:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80105219:	e8 e2 e9 ff ff       	call   80103c00 <myproc>
8010521e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105220:	e8 db e9 ff ff       	call   80103c00 <myproc>
80105225:	8b 55 08             	mov    0x8(%ebp),%edx
80105228:	8b 40 18             	mov    0x18(%eax),%eax
8010522b:	8b 40 44             	mov    0x44(%eax),%eax
8010522e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105231:	e8 ca e9 ff ff       	call   80103c00 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105236:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105239:	8b 00                	mov    (%eax),%eax
8010523b:	39 c7                	cmp    %eax,%edi
8010523d:	73 31                	jae    80105270 <argptr+0x60>
8010523f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80105242:	39 c8                	cmp    %ecx,%eax
80105244:	72 2a                	jb     80105270 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105246:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80105249:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
8010524c:	85 d2                	test   %edx,%edx
8010524e:	78 20                	js     80105270 <argptr+0x60>
80105250:	8b 16                	mov    (%esi),%edx
80105252:	39 c2                	cmp    %eax,%edx
80105254:	76 1a                	jbe    80105270 <argptr+0x60>
80105256:	8b 5d 10             	mov    0x10(%ebp),%ebx
80105259:	01 c3                	add    %eax,%ebx
8010525b:	39 da                	cmp    %ebx,%edx
8010525d:	72 11                	jb     80105270 <argptr+0x60>
    return -1;
  *pp = (char*)i;
8010525f:	8b 55 0c             	mov    0xc(%ebp),%edx
80105262:	89 02                	mov    %eax,(%edx)
  return 0;
80105264:	31 c0                	xor    %eax,%eax
}
80105266:	83 c4 0c             	add    $0xc,%esp
80105269:	5b                   	pop    %ebx
8010526a:	5e                   	pop    %esi
8010526b:	5f                   	pop    %edi
8010526c:	5d                   	pop    %ebp
8010526d:	c3                   	ret    
8010526e:	66 90                	xchg   %ax,%ax
    return -1;
80105270:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105275:	eb ef                	jmp    80105266 <argptr+0x56>
80105277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010527e:	66 90                	xchg   %ax,%ax

80105280 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105280:	55                   	push   %ebp
80105281:	89 e5                	mov    %esp,%ebp
80105283:	56                   	push   %esi
80105284:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105285:	e8 76 e9 ff ff       	call   80103c00 <myproc>
8010528a:	8b 55 08             	mov    0x8(%ebp),%edx
8010528d:	8b 40 18             	mov    0x18(%eax),%eax
80105290:	8b 40 44             	mov    0x44(%eax),%eax
80105293:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105296:	e8 65 e9 ff ff       	call   80103c00 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010529b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010529e:	8b 00                	mov    (%eax),%eax
801052a0:	39 c6                	cmp    %eax,%esi
801052a2:	73 44                	jae    801052e8 <argstr+0x68>
801052a4:	8d 53 08             	lea    0x8(%ebx),%edx
801052a7:	39 d0                	cmp    %edx,%eax
801052a9:	72 3d                	jb     801052e8 <argstr+0x68>
  *ip = *(int*)(addr);
801052ab:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
801052ae:	e8 4d e9 ff ff       	call   80103c00 <myproc>
  if(addr >= curproc->sz)
801052b3:	3b 18                	cmp    (%eax),%ebx
801052b5:	73 31                	jae    801052e8 <argstr+0x68>
  *pp = (char*)addr;
801052b7:	8b 55 0c             	mov    0xc(%ebp),%edx
801052ba:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801052bc:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801052be:	39 d3                	cmp    %edx,%ebx
801052c0:	73 26                	jae    801052e8 <argstr+0x68>
801052c2:	89 d8                	mov    %ebx,%eax
801052c4:	eb 11                	jmp    801052d7 <argstr+0x57>
801052c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052cd:	8d 76 00             	lea    0x0(%esi),%esi
801052d0:	83 c0 01             	add    $0x1,%eax
801052d3:	39 c2                	cmp    %eax,%edx
801052d5:	76 11                	jbe    801052e8 <argstr+0x68>
    if(*s == 0)
801052d7:	80 38 00             	cmpb   $0x0,(%eax)
801052da:	75 f4                	jne    801052d0 <argstr+0x50>
      return s - *pp;
801052dc:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
801052de:	5b                   	pop    %ebx
801052df:	5e                   	pop    %esi
801052e0:	5d                   	pop    %ebp
801052e1:	c3                   	ret    
801052e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801052e8:	5b                   	pop    %ebx
    return -1;
801052e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052ee:	5e                   	pop    %esi
801052ef:	5d                   	pop    %ebp
801052f0:	c3                   	ret    
801052f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052ff:	90                   	nop

80105300 <syscall>:
[SYS_getps]   sys_getps,
};

void
syscall(void)
{
80105300:	55                   	push   %ebp
80105301:	89 e5                	mov    %esp,%ebp
80105303:	53                   	push   %ebx
80105304:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105307:	e8 f4 e8 ff ff       	call   80103c00 <myproc>
8010530c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010530e:	8b 40 18             	mov    0x18(%eax),%eax
80105311:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105314:	8d 50 ff             	lea    -0x1(%eax),%edx
80105317:	83 fa 16             	cmp    $0x16,%edx
8010531a:	77 24                	ja     80105340 <syscall+0x40>
8010531c:	8b 14 85 20 83 10 80 	mov    -0x7fef7ce0(,%eax,4),%edx
80105323:	85 d2                	test   %edx,%edx
80105325:	74 19                	je     80105340 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80105327:	ff d2                	call   *%edx
80105329:	89 c2                	mov    %eax,%edx
8010532b:	8b 43 18             	mov    0x18(%ebx),%eax
8010532e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105331:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105334:	c9                   	leave  
80105335:	c3                   	ret    
80105336:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010533d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105340:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105341:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105344:	50                   	push   %eax
80105345:	ff 73 10             	push   0x10(%ebx)
80105348:	68 fd 82 10 80       	push   $0x801082fd
8010534d:	e8 4e b3 ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80105352:	8b 43 18             	mov    0x18(%ebx),%eax
80105355:	83 c4 10             	add    $0x10,%esp
80105358:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
8010535f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105362:	c9                   	leave  
80105363:	c3                   	ret    
80105364:	66 90                	xchg   %ax,%ax
80105366:	66 90                	xchg   %ax,%ax
80105368:	66 90                	xchg   %ax,%ax
8010536a:	66 90                	xchg   %ax,%ax
8010536c:	66 90                	xchg   %ax,%ax
8010536e:	66 90                	xchg   %ax,%ax

80105370 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105370:	55                   	push   %ebp
80105371:	89 e5                	mov    %esp,%ebp
80105373:	57                   	push   %edi
80105374:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105375:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80105378:	53                   	push   %ebx
80105379:	83 ec 34             	sub    $0x34,%esp
8010537c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010537f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105382:	57                   	push   %edi
80105383:	50                   	push   %eax
{
80105384:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105387:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010538a:	e8 31 cd ff ff       	call   801020c0 <nameiparent>
8010538f:	83 c4 10             	add    $0x10,%esp
80105392:	85 c0                	test   %eax,%eax
80105394:	0f 84 46 01 00 00    	je     801054e0 <create+0x170>
    return 0;
  ilock(dp);
8010539a:	83 ec 0c             	sub    $0xc,%esp
8010539d:	89 c3                	mov    %eax,%ebx
8010539f:	50                   	push   %eax
801053a0:	e8 db c3 ff ff       	call   80101780 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
801053a5:	83 c4 0c             	add    $0xc,%esp
801053a8:	6a 00                	push   $0x0
801053aa:	57                   	push   %edi
801053ab:	53                   	push   %ebx
801053ac:	e8 2f c9 ff ff       	call   80101ce0 <dirlookup>
801053b1:	83 c4 10             	add    $0x10,%esp
801053b4:	89 c6                	mov    %eax,%esi
801053b6:	85 c0                	test   %eax,%eax
801053b8:	74 56                	je     80105410 <create+0xa0>
    iunlockput(dp);
801053ba:	83 ec 0c             	sub    $0xc,%esp
801053bd:	53                   	push   %ebx
801053be:	e8 4d c6 ff ff       	call   80101a10 <iunlockput>
    ilock(ip);
801053c3:	89 34 24             	mov    %esi,(%esp)
801053c6:	e8 b5 c3 ff ff       	call   80101780 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801053cb:	83 c4 10             	add    $0x10,%esp
801053ce:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801053d3:	75 1b                	jne    801053f0 <create+0x80>
801053d5:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
801053da:	75 14                	jne    801053f0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801053dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053df:	89 f0                	mov    %esi,%eax
801053e1:	5b                   	pop    %ebx
801053e2:	5e                   	pop    %esi
801053e3:	5f                   	pop    %edi
801053e4:	5d                   	pop    %ebp
801053e5:	c3                   	ret    
801053e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053ed:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801053f0:	83 ec 0c             	sub    $0xc,%esp
801053f3:	56                   	push   %esi
    return 0;
801053f4:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
801053f6:	e8 15 c6 ff ff       	call   80101a10 <iunlockput>
    return 0;
801053fb:	83 c4 10             	add    $0x10,%esp
}
801053fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105401:	89 f0                	mov    %esi,%eax
80105403:	5b                   	pop    %ebx
80105404:	5e                   	pop    %esi
80105405:	5f                   	pop    %edi
80105406:	5d                   	pop    %ebp
80105407:	c3                   	ret    
80105408:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010540f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80105410:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105414:	83 ec 08             	sub    $0x8,%esp
80105417:	50                   	push   %eax
80105418:	ff 33                	push   (%ebx)
8010541a:	e8 f1 c1 ff ff       	call   80101610 <ialloc>
8010541f:	83 c4 10             	add    $0x10,%esp
80105422:	89 c6                	mov    %eax,%esi
80105424:	85 c0                	test   %eax,%eax
80105426:	0f 84 cd 00 00 00    	je     801054f9 <create+0x189>
  ilock(ip);
8010542c:	83 ec 0c             	sub    $0xc,%esp
8010542f:	50                   	push   %eax
80105430:	e8 4b c3 ff ff       	call   80101780 <ilock>
  ip->major = major;
80105435:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105439:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010543d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105441:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105445:	b8 01 00 00 00       	mov    $0x1,%eax
8010544a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010544e:	89 34 24             	mov    %esi,(%esp)
80105451:	e8 7a c2 ff ff       	call   801016d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105456:	83 c4 10             	add    $0x10,%esp
80105459:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010545e:	74 30                	je     80105490 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105460:	83 ec 04             	sub    $0x4,%esp
80105463:	ff 76 04             	push   0x4(%esi)
80105466:	57                   	push   %edi
80105467:	53                   	push   %ebx
80105468:	e8 73 cb ff ff       	call   80101fe0 <dirlink>
8010546d:	83 c4 10             	add    $0x10,%esp
80105470:	85 c0                	test   %eax,%eax
80105472:	78 78                	js     801054ec <create+0x17c>
  iunlockput(dp);
80105474:	83 ec 0c             	sub    $0xc,%esp
80105477:	53                   	push   %ebx
80105478:	e8 93 c5 ff ff       	call   80101a10 <iunlockput>
  return ip;
8010547d:	83 c4 10             	add    $0x10,%esp
}
80105480:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105483:	89 f0                	mov    %esi,%eax
80105485:	5b                   	pop    %ebx
80105486:	5e                   	pop    %esi
80105487:	5f                   	pop    %edi
80105488:	5d                   	pop    %ebp
80105489:	c3                   	ret    
8010548a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105490:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105493:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105498:	53                   	push   %ebx
80105499:	e8 32 c2 ff ff       	call   801016d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010549e:	83 c4 0c             	add    $0xc,%esp
801054a1:	ff 76 04             	push   0x4(%esi)
801054a4:	68 9c 83 10 80       	push   $0x8010839c
801054a9:	56                   	push   %esi
801054aa:	e8 31 cb ff ff       	call   80101fe0 <dirlink>
801054af:	83 c4 10             	add    $0x10,%esp
801054b2:	85 c0                	test   %eax,%eax
801054b4:	78 18                	js     801054ce <create+0x15e>
801054b6:	83 ec 04             	sub    $0x4,%esp
801054b9:	ff 73 04             	push   0x4(%ebx)
801054bc:	68 9b 83 10 80       	push   $0x8010839b
801054c1:	56                   	push   %esi
801054c2:	e8 19 cb ff ff       	call   80101fe0 <dirlink>
801054c7:	83 c4 10             	add    $0x10,%esp
801054ca:	85 c0                	test   %eax,%eax
801054cc:	79 92                	jns    80105460 <create+0xf0>
      panic("create dots");
801054ce:	83 ec 0c             	sub    $0xc,%esp
801054d1:	68 8f 83 10 80       	push   $0x8010838f
801054d6:	e8 a5 ae ff ff       	call   80100380 <panic>
801054db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054df:	90                   	nop
}
801054e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801054e3:	31 f6                	xor    %esi,%esi
}
801054e5:	5b                   	pop    %ebx
801054e6:	89 f0                	mov    %esi,%eax
801054e8:	5e                   	pop    %esi
801054e9:	5f                   	pop    %edi
801054ea:	5d                   	pop    %ebp
801054eb:	c3                   	ret    
    panic("create: dirlink");
801054ec:	83 ec 0c             	sub    $0xc,%esp
801054ef:	68 9e 83 10 80       	push   $0x8010839e
801054f4:	e8 87 ae ff ff       	call   80100380 <panic>
    panic("create: ialloc");
801054f9:	83 ec 0c             	sub    $0xc,%esp
801054fc:	68 80 83 10 80       	push   $0x80108380
80105501:	e8 7a ae ff ff       	call   80100380 <panic>
80105506:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010550d:	8d 76 00             	lea    0x0(%esi),%esi

80105510 <sys_dup>:
{
80105510:	55                   	push   %ebp
80105511:	89 e5                	mov    %esp,%ebp
80105513:	56                   	push   %esi
80105514:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105515:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105518:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010551b:	50                   	push   %eax
8010551c:	6a 00                	push   $0x0
8010551e:	e8 9d fc ff ff       	call   801051c0 <argint>
80105523:	83 c4 10             	add    $0x10,%esp
80105526:	85 c0                	test   %eax,%eax
80105528:	78 36                	js     80105560 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010552a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010552e:	77 30                	ja     80105560 <sys_dup+0x50>
80105530:	e8 cb e6 ff ff       	call   80103c00 <myproc>
80105535:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105538:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010553c:	85 f6                	test   %esi,%esi
8010553e:	74 20                	je     80105560 <sys_dup+0x50>
  struct proc *curproc = myproc();
80105540:	e8 bb e6 ff ff       	call   80103c00 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105545:	31 db                	xor    %ebx,%ebx
80105547:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010554e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105550:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105554:	85 d2                	test   %edx,%edx
80105556:	74 18                	je     80105570 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80105558:	83 c3 01             	add    $0x1,%ebx
8010555b:	83 fb 10             	cmp    $0x10,%ebx
8010555e:	75 f0                	jne    80105550 <sys_dup+0x40>
}
80105560:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105563:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105568:	89 d8                	mov    %ebx,%eax
8010556a:	5b                   	pop    %ebx
8010556b:	5e                   	pop    %esi
8010556c:	5d                   	pop    %ebp
8010556d:	c3                   	ret    
8010556e:	66 90                	xchg   %ax,%ax
  filedup(f);
80105570:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105573:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105577:	56                   	push   %esi
80105578:	e8 23 b9 ff ff       	call   80100ea0 <filedup>
  return fd;
8010557d:	83 c4 10             	add    $0x10,%esp
}
80105580:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105583:	89 d8                	mov    %ebx,%eax
80105585:	5b                   	pop    %ebx
80105586:	5e                   	pop    %esi
80105587:	5d                   	pop    %ebp
80105588:	c3                   	ret    
80105589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105590 <sys_read>:
{
80105590:	55                   	push   %ebp
80105591:	89 e5                	mov    %esp,%ebp
80105593:	56                   	push   %esi
80105594:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105595:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105598:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010559b:	53                   	push   %ebx
8010559c:	6a 00                	push   $0x0
8010559e:	e8 1d fc ff ff       	call   801051c0 <argint>
801055a3:	83 c4 10             	add    $0x10,%esp
801055a6:	85 c0                	test   %eax,%eax
801055a8:	78 5e                	js     80105608 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801055aa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801055ae:	77 58                	ja     80105608 <sys_read+0x78>
801055b0:	e8 4b e6 ff ff       	call   80103c00 <myproc>
801055b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801055b8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801055bc:	85 f6                	test   %esi,%esi
801055be:	74 48                	je     80105608 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801055c0:	83 ec 08             	sub    $0x8,%esp
801055c3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801055c6:	50                   	push   %eax
801055c7:	6a 02                	push   $0x2
801055c9:	e8 f2 fb ff ff       	call   801051c0 <argint>
801055ce:	83 c4 10             	add    $0x10,%esp
801055d1:	85 c0                	test   %eax,%eax
801055d3:	78 33                	js     80105608 <sys_read+0x78>
801055d5:	83 ec 04             	sub    $0x4,%esp
801055d8:	ff 75 f0             	push   -0x10(%ebp)
801055db:	53                   	push   %ebx
801055dc:	6a 01                	push   $0x1
801055de:	e8 2d fc ff ff       	call   80105210 <argptr>
801055e3:	83 c4 10             	add    $0x10,%esp
801055e6:	85 c0                	test   %eax,%eax
801055e8:	78 1e                	js     80105608 <sys_read+0x78>
  return fileread(f, p, n);
801055ea:	83 ec 04             	sub    $0x4,%esp
801055ed:	ff 75 f0             	push   -0x10(%ebp)
801055f0:	ff 75 f4             	push   -0xc(%ebp)
801055f3:	56                   	push   %esi
801055f4:	e8 27 ba ff ff       	call   80101020 <fileread>
801055f9:	83 c4 10             	add    $0x10,%esp
}
801055fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801055ff:	5b                   	pop    %ebx
80105600:	5e                   	pop    %esi
80105601:	5d                   	pop    %ebp
80105602:	c3                   	ret    
80105603:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105607:	90                   	nop
    return -1;
80105608:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010560d:	eb ed                	jmp    801055fc <sys_read+0x6c>
8010560f:	90                   	nop

80105610 <sys_write>:
{
80105610:	55                   	push   %ebp
80105611:	89 e5                	mov    %esp,%ebp
80105613:	56                   	push   %esi
80105614:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105615:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105618:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010561b:	53                   	push   %ebx
8010561c:	6a 00                	push   $0x0
8010561e:	e8 9d fb ff ff       	call   801051c0 <argint>
80105623:	83 c4 10             	add    $0x10,%esp
80105626:	85 c0                	test   %eax,%eax
80105628:	78 5e                	js     80105688 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010562a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010562e:	77 58                	ja     80105688 <sys_write+0x78>
80105630:	e8 cb e5 ff ff       	call   80103c00 <myproc>
80105635:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105638:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010563c:	85 f6                	test   %esi,%esi
8010563e:	74 48                	je     80105688 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105640:	83 ec 08             	sub    $0x8,%esp
80105643:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105646:	50                   	push   %eax
80105647:	6a 02                	push   $0x2
80105649:	e8 72 fb ff ff       	call   801051c0 <argint>
8010564e:	83 c4 10             	add    $0x10,%esp
80105651:	85 c0                	test   %eax,%eax
80105653:	78 33                	js     80105688 <sys_write+0x78>
80105655:	83 ec 04             	sub    $0x4,%esp
80105658:	ff 75 f0             	push   -0x10(%ebp)
8010565b:	53                   	push   %ebx
8010565c:	6a 01                	push   $0x1
8010565e:	e8 ad fb ff ff       	call   80105210 <argptr>
80105663:	83 c4 10             	add    $0x10,%esp
80105666:	85 c0                	test   %eax,%eax
80105668:	78 1e                	js     80105688 <sys_write+0x78>
  return filewrite(f, p, n);
8010566a:	83 ec 04             	sub    $0x4,%esp
8010566d:	ff 75 f0             	push   -0x10(%ebp)
80105670:	ff 75 f4             	push   -0xc(%ebp)
80105673:	56                   	push   %esi
80105674:	e8 37 ba ff ff       	call   801010b0 <filewrite>
80105679:	83 c4 10             	add    $0x10,%esp
}
8010567c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010567f:	5b                   	pop    %ebx
80105680:	5e                   	pop    %esi
80105681:	5d                   	pop    %ebp
80105682:	c3                   	ret    
80105683:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105687:	90                   	nop
    return -1;
80105688:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010568d:	eb ed                	jmp    8010567c <sys_write+0x6c>
8010568f:	90                   	nop

80105690 <sys_close>:
{
80105690:	55                   	push   %ebp
80105691:	89 e5                	mov    %esp,%ebp
80105693:	56                   	push   %esi
80105694:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105695:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105698:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010569b:	50                   	push   %eax
8010569c:	6a 00                	push   $0x0
8010569e:	e8 1d fb ff ff       	call   801051c0 <argint>
801056a3:	83 c4 10             	add    $0x10,%esp
801056a6:	85 c0                	test   %eax,%eax
801056a8:	78 3e                	js     801056e8 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801056aa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801056ae:	77 38                	ja     801056e8 <sys_close+0x58>
801056b0:	e8 4b e5 ff ff       	call   80103c00 <myproc>
801056b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801056b8:	8d 5a 08             	lea    0x8(%edx),%ebx
801056bb:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
801056bf:	85 f6                	test   %esi,%esi
801056c1:	74 25                	je     801056e8 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
801056c3:	e8 38 e5 ff ff       	call   80103c00 <myproc>
  fileclose(f);
801056c8:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801056cb:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
801056d2:	00 
  fileclose(f);
801056d3:	56                   	push   %esi
801056d4:	e8 17 b8 ff ff       	call   80100ef0 <fileclose>
  return 0;
801056d9:	83 c4 10             	add    $0x10,%esp
801056dc:	31 c0                	xor    %eax,%eax
}
801056de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801056e1:	5b                   	pop    %ebx
801056e2:	5e                   	pop    %esi
801056e3:	5d                   	pop    %ebp
801056e4:	c3                   	ret    
801056e5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801056e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056ed:	eb ef                	jmp    801056de <sys_close+0x4e>
801056ef:	90                   	nop

801056f0 <sys_fstat>:
{
801056f0:	55                   	push   %ebp
801056f1:	89 e5                	mov    %esp,%ebp
801056f3:	56                   	push   %esi
801056f4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801056f5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801056f8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801056fb:	53                   	push   %ebx
801056fc:	6a 00                	push   $0x0
801056fe:	e8 bd fa ff ff       	call   801051c0 <argint>
80105703:	83 c4 10             	add    $0x10,%esp
80105706:	85 c0                	test   %eax,%eax
80105708:	78 46                	js     80105750 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010570a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010570e:	77 40                	ja     80105750 <sys_fstat+0x60>
80105710:	e8 eb e4 ff ff       	call   80103c00 <myproc>
80105715:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105718:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010571c:	85 f6                	test   %esi,%esi
8010571e:	74 30                	je     80105750 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105720:	83 ec 04             	sub    $0x4,%esp
80105723:	6a 14                	push   $0x14
80105725:	53                   	push   %ebx
80105726:	6a 01                	push   $0x1
80105728:	e8 e3 fa ff ff       	call   80105210 <argptr>
8010572d:	83 c4 10             	add    $0x10,%esp
80105730:	85 c0                	test   %eax,%eax
80105732:	78 1c                	js     80105750 <sys_fstat+0x60>
  return filestat(f, st);
80105734:	83 ec 08             	sub    $0x8,%esp
80105737:	ff 75 f4             	push   -0xc(%ebp)
8010573a:	56                   	push   %esi
8010573b:	e8 90 b8 ff ff       	call   80100fd0 <filestat>
80105740:	83 c4 10             	add    $0x10,%esp
}
80105743:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105746:	5b                   	pop    %ebx
80105747:	5e                   	pop    %esi
80105748:	5d                   	pop    %ebp
80105749:	c3                   	ret    
8010574a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105750:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105755:	eb ec                	jmp    80105743 <sys_fstat+0x53>
80105757:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010575e:	66 90                	xchg   %ax,%ax

80105760 <sys_link>:
{
80105760:	55                   	push   %ebp
80105761:	89 e5                	mov    %esp,%ebp
80105763:	57                   	push   %edi
80105764:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105765:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105768:	53                   	push   %ebx
80105769:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010576c:	50                   	push   %eax
8010576d:	6a 00                	push   $0x0
8010576f:	e8 0c fb ff ff       	call   80105280 <argstr>
80105774:	83 c4 10             	add    $0x10,%esp
80105777:	85 c0                	test   %eax,%eax
80105779:	0f 88 fb 00 00 00    	js     8010587a <sys_link+0x11a>
8010577f:	83 ec 08             	sub    $0x8,%esp
80105782:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105785:	50                   	push   %eax
80105786:	6a 01                	push   $0x1
80105788:	e8 f3 fa ff ff       	call   80105280 <argstr>
8010578d:	83 c4 10             	add    $0x10,%esp
80105790:	85 c0                	test   %eax,%eax
80105792:	0f 88 e2 00 00 00    	js     8010587a <sys_link+0x11a>
  begin_op();
80105798:	e8 c3 d5 ff ff       	call   80102d60 <begin_op>
  if((ip = namei(old)) == 0){
8010579d:	83 ec 0c             	sub    $0xc,%esp
801057a0:	ff 75 d4             	push   -0x2c(%ebp)
801057a3:	e8 f8 c8 ff ff       	call   801020a0 <namei>
801057a8:	83 c4 10             	add    $0x10,%esp
801057ab:	89 c3                	mov    %eax,%ebx
801057ad:	85 c0                	test   %eax,%eax
801057af:	0f 84 e4 00 00 00    	je     80105899 <sys_link+0x139>
  ilock(ip);
801057b5:	83 ec 0c             	sub    $0xc,%esp
801057b8:	50                   	push   %eax
801057b9:	e8 c2 bf ff ff       	call   80101780 <ilock>
  if(ip->type == T_DIR){
801057be:	83 c4 10             	add    $0x10,%esp
801057c1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801057c6:	0f 84 b5 00 00 00    	je     80105881 <sys_link+0x121>
  iupdate(ip);
801057cc:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801057cf:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801057d4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801057d7:	53                   	push   %ebx
801057d8:	e8 f3 be ff ff       	call   801016d0 <iupdate>
  iunlock(ip);
801057dd:	89 1c 24             	mov    %ebx,(%esp)
801057e0:	e8 7b c0 ff ff       	call   80101860 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801057e5:	58                   	pop    %eax
801057e6:	5a                   	pop    %edx
801057e7:	57                   	push   %edi
801057e8:	ff 75 d0             	push   -0x30(%ebp)
801057eb:	e8 d0 c8 ff ff       	call   801020c0 <nameiparent>
801057f0:	83 c4 10             	add    $0x10,%esp
801057f3:	89 c6                	mov    %eax,%esi
801057f5:	85 c0                	test   %eax,%eax
801057f7:	74 5b                	je     80105854 <sys_link+0xf4>
  ilock(dp);
801057f9:	83 ec 0c             	sub    $0xc,%esp
801057fc:	50                   	push   %eax
801057fd:	e8 7e bf ff ff       	call   80101780 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105802:	8b 03                	mov    (%ebx),%eax
80105804:	83 c4 10             	add    $0x10,%esp
80105807:	39 06                	cmp    %eax,(%esi)
80105809:	75 3d                	jne    80105848 <sys_link+0xe8>
8010580b:	83 ec 04             	sub    $0x4,%esp
8010580e:	ff 73 04             	push   0x4(%ebx)
80105811:	57                   	push   %edi
80105812:	56                   	push   %esi
80105813:	e8 c8 c7 ff ff       	call   80101fe0 <dirlink>
80105818:	83 c4 10             	add    $0x10,%esp
8010581b:	85 c0                	test   %eax,%eax
8010581d:	78 29                	js     80105848 <sys_link+0xe8>
  iunlockput(dp);
8010581f:	83 ec 0c             	sub    $0xc,%esp
80105822:	56                   	push   %esi
80105823:	e8 e8 c1 ff ff       	call   80101a10 <iunlockput>
  iput(ip);
80105828:	89 1c 24             	mov    %ebx,(%esp)
8010582b:	e8 80 c0 ff ff       	call   801018b0 <iput>
  end_op();
80105830:	e8 9b d5 ff ff       	call   80102dd0 <end_op>
  return 0;
80105835:	83 c4 10             	add    $0x10,%esp
80105838:	31 c0                	xor    %eax,%eax
}
8010583a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010583d:	5b                   	pop    %ebx
8010583e:	5e                   	pop    %esi
8010583f:	5f                   	pop    %edi
80105840:	5d                   	pop    %ebp
80105841:	c3                   	ret    
80105842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105848:	83 ec 0c             	sub    $0xc,%esp
8010584b:	56                   	push   %esi
8010584c:	e8 bf c1 ff ff       	call   80101a10 <iunlockput>
    goto bad;
80105851:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105854:	83 ec 0c             	sub    $0xc,%esp
80105857:	53                   	push   %ebx
80105858:	e8 23 bf ff ff       	call   80101780 <ilock>
  ip->nlink--;
8010585d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105862:	89 1c 24             	mov    %ebx,(%esp)
80105865:	e8 66 be ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
8010586a:	89 1c 24             	mov    %ebx,(%esp)
8010586d:	e8 9e c1 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105872:	e8 59 d5 ff ff       	call   80102dd0 <end_op>
  return -1;
80105877:	83 c4 10             	add    $0x10,%esp
8010587a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010587f:	eb b9                	jmp    8010583a <sys_link+0xda>
    iunlockput(ip);
80105881:	83 ec 0c             	sub    $0xc,%esp
80105884:	53                   	push   %ebx
80105885:	e8 86 c1 ff ff       	call   80101a10 <iunlockput>
    end_op();
8010588a:	e8 41 d5 ff ff       	call   80102dd0 <end_op>
    return -1;
8010588f:	83 c4 10             	add    $0x10,%esp
80105892:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105897:	eb a1                	jmp    8010583a <sys_link+0xda>
    end_op();
80105899:	e8 32 d5 ff ff       	call   80102dd0 <end_op>
    return -1;
8010589e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058a3:	eb 95                	jmp    8010583a <sys_link+0xda>
801058a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058b0 <sys_unlink>:
{
801058b0:	55                   	push   %ebp
801058b1:	89 e5                	mov    %esp,%ebp
801058b3:	57                   	push   %edi
801058b4:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801058b5:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801058b8:	53                   	push   %ebx
801058b9:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801058bc:	50                   	push   %eax
801058bd:	6a 00                	push   $0x0
801058bf:	e8 bc f9 ff ff       	call   80105280 <argstr>
801058c4:	83 c4 10             	add    $0x10,%esp
801058c7:	85 c0                	test   %eax,%eax
801058c9:	0f 88 7a 01 00 00    	js     80105a49 <sys_unlink+0x199>
  begin_op();
801058cf:	e8 8c d4 ff ff       	call   80102d60 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801058d4:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801058d7:	83 ec 08             	sub    $0x8,%esp
801058da:	53                   	push   %ebx
801058db:	ff 75 c0             	push   -0x40(%ebp)
801058de:	e8 dd c7 ff ff       	call   801020c0 <nameiparent>
801058e3:	83 c4 10             	add    $0x10,%esp
801058e6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801058e9:	85 c0                	test   %eax,%eax
801058eb:	0f 84 62 01 00 00    	je     80105a53 <sys_unlink+0x1a3>
  ilock(dp);
801058f1:	8b 7d b4             	mov    -0x4c(%ebp),%edi
801058f4:	83 ec 0c             	sub    $0xc,%esp
801058f7:	57                   	push   %edi
801058f8:	e8 83 be ff ff       	call   80101780 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801058fd:	58                   	pop    %eax
801058fe:	5a                   	pop    %edx
801058ff:	68 9c 83 10 80       	push   $0x8010839c
80105904:	53                   	push   %ebx
80105905:	e8 b6 c3 ff ff       	call   80101cc0 <namecmp>
8010590a:	83 c4 10             	add    $0x10,%esp
8010590d:	85 c0                	test   %eax,%eax
8010590f:	0f 84 fb 00 00 00    	je     80105a10 <sys_unlink+0x160>
80105915:	83 ec 08             	sub    $0x8,%esp
80105918:	68 9b 83 10 80       	push   $0x8010839b
8010591d:	53                   	push   %ebx
8010591e:	e8 9d c3 ff ff       	call   80101cc0 <namecmp>
80105923:	83 c4 10             	add    $0x10,%esp
80105926:	85 c0                	test   %eax,%eax
80105928:	0f 84 e2 00 00 00    	je     80105a10 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010592e:	83 ec 04             	sub    $0x4,%esp
80105931:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105934:	50                   	push   %eax
80105935:	53                   	push   %ebx
80105936:	57                   	push   %edi
80105937:	e8 a4 c3 ff ff       	call   80101ce0 <dirlookup>
8010593c:	83 c4 10             	add    $0x10,%esp
8010593f:	89 c3                	mov    %eax,%ebx
80105941:	85 c0                	test   %eax,%eax
80105943:	0f 84 c7 00 00 00    	je     80105a10 <sys_unlink+0x160>
  ilock(ip);
80105949:	83 ec 0c             	sub    $0xc,%esp
8010594c:	50                   	push   %eax
8010594d:	e8 2e be ff ff       	call   80101780 <ilock>
  if(ip->nlink < 1)
80105952:	83 c4 10             	add    $0x10,%esp
80105955:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010595a:	0f 8e 1c 01 00 00    	jle    80105a7c <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105960:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105965:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105968:	74 66                	je     801059d0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010596a:	83 ec 04             	sub    $0x4,%esp
8010596d:	6a 10                	push   $0x10
8010596f:	6a 00                	push   $0x0
80105971:	57                   	push   %edi
80105972:	e8 89 f5 ff ff       	call   80104f00 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105977:	6a 10                	push   $0x10
80105979:	ff 75 c4             	push   -0x3c(%ebp)
8010597c:	57                   	push   %edi
8010597d:	ff 75 b4             	push   -0x4c(%ebp)
80105980:	e8 0b c2 ff ff       	call   80101b90 <writei>
80105985:	83 c4 20             	add    $0x20,%esp
80105988:	83 f8 10             	cmp    $0x10,%eax
8010598b:	0f 85 de 00 00 00    	jne    80105a6f <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
80105991:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105996:	0f 84 94 00 00 00    	je     80105a30 <sys_unlink+0x180>
  iunlockput(dp);
8010599c:	83 ec 0c             	sub    $0xc,%esp
8010599f:	ff 75 b4             	push   -0x4c(%ebp)
801059a2:	e8 69 c0 ff ff       	call   80101a10 <iunlockput>
  ip->nlink--;
801059a7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801059ac:	89 1c 24             	mov    %ebx,(%esp)
801059af:	e8 1c bd ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
801059b4:	89 1c 24             	mov    %ebx,(%esp)
801059b7:	e8 54 c0 ff ff       	call   80101a10 <iunlockput>
  end_op();
801059bc:	e8 0f d4 ff ff       	call   80102dd0 <end_op>
  return 0;
801059c1:	83 c4 10             	add    $0x10,%esp
801059c4:	31 c0                	xor    %eax,%eax
}
801059c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059c9:	5b                   	pop    %ebx
801059ca:	5e                   	pop    %esi
801059cb:	5f                   	pop    %edi
801059cc:	5d                   	pop    %ebp
801059cd:	c3                   	ret    
801059ce:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801059d0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801059d4:	76 94                	jbe    8010596a <sys_unlink+0xba>
801059d6:	be 20 00 00 00       	mov    $0x20,%esi
801059db:	eb 0b                	jmp    801059e8 <sys_unlink+0x138>
801059dd:	8d 76 00             	lea    0x0(%esi),%esi
801059e0:	83 c6 10             	add    $0x10,%esi
801059e3:	3b 73 58             	cmp    0x58(%ebx),%esi
801059e6:	73 82                	jae    8010596a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801059e8:	6a 10                	push   $0x10
801059ea:	56                   	push   %esi
801059eb:	57                   	push   %edi
801059ec:	53                   	push   %ebx
801059ed:	e8 9e c0 ff ff       	call   80101a90 <readi>
801059f2:	83 c4 10             	add    $0x10,%esp
801059f5:	83 f8 10             	cmp    $0x10,%eax
801059f8:	75 68                	jne    80105a62 <sys_unlink+0x1b2>
    if(de.inum != 0)
801059fa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801059ff:	74 df                	je     801059e0 <sys_unlink+0x130>
    iunlockput(ip);
80105a01:	83 ec 0c             	sub    $0xc,%esp
80105a04:	53                   	push   %ebx
80105a05:	e8 06 c0 ff ff       	call   80101a10 <iunlockput>
    goto bad;
80105a0a:	83 c4 10             	add    $0x10,%esp
80105a0d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105a10:	83 ec 0c             	sub    $0xc,%esp
80105a13:	ff 75 b4             	push   -0x4c(%ebp)
80105a16:	e8 f5 bf ff ff       	call   80101a10 <iunlockput>
  end_op();
80105a1b:	e8 b0 d3 ff ff       	call   80102dd0 <end_op>
  return -1;
80105a20:	83 c4 10             	add    $0x10,%esp
80105a23:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a28:	eb 9c                	jmp    801059c6 <sys_unlink+0x116>
80105a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105a30:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105a33:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105a36:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80105a3b:	50                   	push   %eax
80105a3c:	e8 8f bc ff ff       	call   801016d0 <iupdate>
80105a41:	83 c4 10             	add    $0x10,%esp
80105a44:	e9 53 ff ff ff       	jmp    8010599c <sys_unlink+0xec>
    return -1;
80105a49:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a4e:	e9 73 ff ff ff       	jmp    801059c6 <sys_unlink+0x116>
    end_op();
80105a53:	e8 78 d3 ff ff       	call   80102dd0 <end_op>
    return -1;
80105a58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a5d:	e9 64 ff ff ff       	jmp    801059c6 <sys_unlink+0x116>
      panic("isdirempty: readi");
80105a62:	83 ec 0c             	sub    $0xc,%esp
80105a65:	68 c0 83 10 80       	push   $0x801083c0
80105a6a:	e8 11 a9 ff ff       	call   80100380 <panic>
    panic("unlink: writei");
80105a6f:	83 ec 0c             	sub    $0xc,%esp
80105a72:	68 d2 83 10 80       	push   $0x801083d2
80105a77:	e8 04 a9 ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
80105a7c:	83 ec 0c             	sub    $0xc,%esp
80105a7f:	68 ae 83 10 80       	push   $0x801083ae
80105a84:	e8 f7 a8 ff ff       	call   80100380 <panic>
80105a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105a90 <sys_open>:

int
sys_open(void)
{
80105a90:	55                   	push   %ebp
80105a91:	89 e5                	mov    %esp,%ebp
80105a93:	57                   	push   %edi
80105a94:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105a95:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105a98:	53                   	push   %ebx
80105a99:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105a9c:	50                   	push   %eax
80105a9d:	6a 00                	push   $0x0
80105a9f:	e8 dc f7 ff ff       	call   80105280 <argstr>
80105aa4:	83 c4 10             	add    $0x10,%esp
80105aa7:	85 c0                	test   %eax,%eax
80105aa9:	0f 88 8e 00 00 00    	js     80105b3d <sys_open+0xad>
80105aaf:	83 ec 08             	sub    $0x8,%esp
80105ab2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105ab5:	50                   	push   %eax
80105ab6:	6a 01                	push   $0x1
80105ab8:	e8 03 f7 ff ff       	call   801051c0 <argint>
80105abd:	83 c4 10             	add    $0x10,%esp
80105ac0:	85 c0                	test   %eax,%eax
80105ac2:	78 79                	js     80105b3d <sys_open+0xad>
    return -1;

  begin_op();
80105ac4:	e8 97 d2 ff ff       	call   80102d60 <begin_op>

  if(omode & O_CREATE){
80105ac9:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105acd:	75 79                	jne    80105b48 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105acf:	83 ec 0c             	sub    $0xc,%esp
80105ad2:	ff 75 e0             	push   -0x20(%ebp)
80105ad5:	e8 c6 c5 ff ff       	call   801020a0 <namei>
80105ada:	83 c4 10             	add    $0x10,%esp
80105add:	89 c6                	mov    %eax,%esi
80105adf:	85 c0                	test   %eax,%eax
80105ae1:	0f 84 7e 00 00 00    	je     80105b65 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105ae7:	83 ec 0c             	sub    $0xc,%esp
80105aea:	50                   	push   %eax
80105aeb:	e8 90 bc ff ff       	call   80101780 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105af0:	83 c4 10             	add    $0x10,%esp
80105af3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105af8:	0f 84 c2 00 00 00    	je     80105bc0 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105afe:	e8 2d b3 ff ff       	call   80100e30 <filealloc>
80105b03:	89 c7                	mov    %eax,%edi
80105b05:	85 c0                	test   %eax,%eax
80105b07:	74 23                	je     80105b2c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105b09:	e8 f2 e0 ff ff       	call   80103c00 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105b0e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105b10:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105b14:	85 d2                	test   %edx,%edx
80105b16:	74 60                	je     80105b78 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105b18:	83 c3 01             	add    $0x1,%ebx
80105b1b:	83 fb 10             	cmp    $0x10,%ebx
80105b1e:	75 f0                	jne    80105b10 <sys_open+0x80>
    if(f)
      fileclose(f);
80105b20:	83 ec 0c             	sub    $0xc,%esp
80105b23:	57                   	push   %edi
80105b24:	e8 c7 b3 ff ff       	call   80100ef0 <fileclose>
80105b29:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105b2c:	83 ec 0c             	sub    $0xc,%esp
80105b2f:	56                   	push   %esi
80105b30:	e8 db be ff ff       	call   80101a10 <iunlockput>
    end_op();
80105b35:	e8 96 d2 ff ff       	call   80102dd0 <end_op>
    return -1;
80105b3a:	83 c4 10             	add    $0x10,%esp
80105b3d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105b42:	eb 6d                	jmp    80105bb1 <sys_open+0x121>
80105b44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105b48:	83 ec 0c             	sub    $0xc,%esp
80105b4b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105b4e:	31 c9                	xor    %ecx,%ecx
80105b50:	ba 02 00 00 00       	mov    $0x2,%edx
80105b55:	6a 00                	push   $0x0
80105b57:	e8 14 f8 ff ff       	call   80105370 <create>
    if(ip == 0){
80105b5c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105b5f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105b61:	85 c0                	test   %eax,%eax
80105b63:	75 99                	jne    80105afe <sys_open+0x6e>
      end_op();
80105b65:	e8 66 d2 ff ff       	call   80102dd0 <end_op>
      return -1;
80105b6a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105b6f:	eb 40                	jmp    80105bb1 <sys_open+0x121>
80105b71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105b78:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105b7b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105b7f:	56                   	push   %esi
80105b80:	e8 db bc ff ff       	call   80101860 <iunlock>
  end_op();
80105b85:	e8 46 d2 ff ff       	call   80102dd0 <end_op>

  f->type = FD_INODE;
80105b8a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105b90:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b93:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105b96:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105b99:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105b9b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105ba2:	f7 d0                	not    %eax
80105ba4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105ba7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105baa:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105bad:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105bb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105bb4:	89 d8                	mov    %ebx,%eax
80105bb6:	5b                   	pop    %ebx
80105bb7:	5e                   	pop    %esi
80105bb8:	5f                   	pop    %edi
80105bb9:	5d                   	pop    %ebp
80105bba:	c3                   	ret    
80105bbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105bbf:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105bc0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105bc3:	85 c9                	test   %ecx,%ecx
80105bc5:	0f 84 33 ff ff ff    	je     80105afe <sys_open+0x6e>
80105bcb:	e9 5c ff ff ff       	jmp    80105b2c <sys_open+0x9c>

80105bd0 <sys_mkdir>:

int
sys_mkdir(void)
{
80105bd0:	55                   	push   %ebp
80105bd1:	89 e5                	mov    %esp,%ebp
80105bd3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105bd6:	e8 85 d1 ff ff       	call   80102d60 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105bdb:	83 ec 08             	sub    $0x8,%esp
80105bde:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105be1:	50                   	push   %eax
80105be2:	6a 00                	push   $0x0
80105be4:	e8 97 f6 ff ff       	call   80105280 <argstr>
80105be9:	83 c4 10             	add    $0x10,%esp
80105bec:	85 c0                	test   %eax,%eax
80105bee:	78 30                	js     80105c20 <sys_mkdir+0x50>
80105bf0:	83 ec 0c             	sub    $0xc,%esp
80105bf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bf6:	31 c9                	xor    %ecx,%ecx
80105bf8:	ba 01 00 00 00       	mov    $0x1,%edx
80105bfd:	6a 00                	push   $0x0
80105bff:	e8 6c f7 ff ff       	call   80105370 <create>
80105c04:	83 c4 10             	add    $0x10,%esp
80105c07:	85 c0                	test   %eax,%eax
80105c09:	74 15                	je     80105c20 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105c0b:	83 ec 0c             	sub    $0xc,%esp
80105c0e:	50                   	push   %eax
80105c0f:	e8 fc bd ff ff       	call   80101a10 <iunlockput>
  end_op();
80105c14:	e8 b7 d1 ff ff       	call   80102dd0 <end_op>
  return 0;
80105c19:	83 c4 10             	add    $0x10,%esp
80105c1c:	31 c0                	xor    %eax,%eax
}
80105c1e:	c9                   	leave  
80105c1f:	c3                   	ret    
    end_op();
80105c20:	e8 ab d1 ff ff       	call   80102dd0 <end_op>
    return -1;
80105c25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c2a:	c9                   	leave  
80105c2b:	c3                   	ret    
80105c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c30 <sys_mknod>:

int
sys_mknod(void)
{
80105c30:	55                   	push   %ebp
80105c31:	89 e5                	mov    %esp,%ebp
80105c33:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105c36:	e8 25 d1 ff ff       	call   80102d60 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105c3b:	83 ec 08             	sub    $0x8,%esp
80105c3e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105c41:	50                   	push   %eax
80105c42:	6a 00                	push   $0x0
80105c44:	e8 37 f6 ff ff       	call   80105280 <argstr>
80105c49:	83 c4 10             	add    $0x10,%esp
80105c4c:	85 c0                	test   %eax,%eax
80105c4e:	78 60                	js     80105cb0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105c50:	83 ec 08             	sub    $0x8,%esp
80105c53:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c56:	50                   	push   %eax
80105c57:	6a 01                	push   $0x1
80105c59:	e8 62 f5 ff ff       	call   801051c0 <argint>
  if((argstr(0, &path)) < 0 ||
80105c5e:	83 c4 10             	add    $0x10,%esp
80105c61:	85 c0                	test   %eax,%eax
80105c63:	78 4b                	js     80105cb0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105c65:	83 ec 08             	sub    $0x8,%esp
80105c68:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c6b:	50                   	push   %eax
80105c6c:	6a 02                	push   $0x2
80105c6e:	e8 4d f5 ff ff       	call   801051c0 <argint>
     argint(1, &major) < 0 ||
80105c73:	83 c4 10             	add    $0x10,%esp
80105c76:	85 c0                	test   %eax,%eax
80105c78:	78 36                	js     80105cb0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105c7a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105c7e:	83 ec 0c             	sub    $0xc,%esp
80105c81:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105c85:	ba 03 00 00 00       	mov    $0x3,%edx
80105c8a:	50                   	push   %eax
80105c8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105c8e:	e8 dd f6 ff ff       	call   80105370 <create>
     argint(2, &minor) < 0 ||
80105c93:	83 c4 10             	add    $0x10,%esp
80105c96:	85 c0                	test   %eax,%eax
80105c98:	74 16                	je     80105cb0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105c9a:	83 ec 0c             	sub    $0xc,%esp
80105c9d:	50                   	push   %eax
80105c9e:	e8 6d bd ff ff       	call   80101a10 <iunlockput>
  end_op();
80105ca3:	e8 28 d1 ff ff       	call   80102dd0 <end_op>
  return 0;
80105ca8:	83 c4 10             	add    $0x10,%esp
80105cab:	31 c0                	xor    %eax,%eax
}
80105cad:	c9                   	leave  
80105cae:	c3                   	ret    
80105caf:	90                   	nop
    end_op();
80105cb0:	e8 1b d1 ff ff       	call   80102dd0 <end_op>
    return -1;
80105cb5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cba:	c9                   	leave  
80105cbb:	c3                   	ret    
80105cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105cc0 <sys_chdir>:

int
sys_chdir(void)
{
80105cc0:	55                   	push   %ebp
80105cc1:	89 e5                	mov    %esp,%ebp
80105cc3:	56                   	push   %esi
80105cc4:	53                   	push   %ebx
80105cc5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105cc8:	e8 33 df ff ff       	call   80103c00 <myproc>
80105ccd:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105ccf:	e8 8c d0 ff ff       	call   80102d60 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105cd4:	83 ec 08             	sub    $0x8,%esp
80105cd7:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105cda:	50                   	push   %eax
80105cdb:	6a 00                	push   $0x0
80105cdd:	e8 9e f5 ff ff       	call   80105280 <argstr>
80105ce2:	83 c4 10             	add    $0x10,%esp
80105ce5:	85 c0                	test   %eax,%eax
80105ce7:	78 77                	js     80105d60 <sys_chdir+0xa0>
80105ce9:	83 ec 0c             	sub    $0xc,%esp
80105cec:	ff 75 f4             	push   -0xc(%ebp)
80105cef:	e8 ac c3 ff ff       	call   801020a0 <namei>
80105cf4:	83 c4 10             	add    $0x10,%esp
80105cf7:	89 c3                	mov    %eax,%ebx
80105cf9:	85 c0                	test   %eax,%eax
80105cfb:	74 63                	je     80105d60 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105cfd:	83 ec 0c             	sub    $0xc,%esp
80105d00:	50                   	push   %eax
80105d01:	e8 7a ba ff ff       	call   80101780 <ilock>
  if(ip->type != T_DIR){
80105d06:	83 c4 10             	add    $0x10,%esp
80105d09:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105d0e:	75 30                	jne    80105d40 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105d10:	83 ec 0c             	sub    $0xc,%esp
80105d13:	53                   	push   %ebx
80105d14:	e8 47 bb ff ff       	call   80101860 <iunlock>
  iput(curproc->cwd);
80105d19:	58                   	pop    %eax
80105d1a:	ff 76 68             	push   0x68(%esi)
80105d1d:	e8 8e bb ff ff       	call   801018b0 <iput>
  end_op();
80105d22:	e8 a9 d0 ff ff       	call   80102dd0 <end_op>
  curproc->cwd = ip;
80105d27:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105d2a:	83 c4 10             	add    $0x10,%esp
80105d2d:	31 c0                	xor    %eax,%eax
}
80105d2f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105d32:	5b                   	pop    %ebx
80105d33:	5e                   	pop    %esi
80105d34:	5d                   	pop    %ebp
80105d35:	c3                   	ret    
80105d36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d3d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105d40:	83 ec 0c             	sub    $0xc,%esp
80105d43:	53                   	push   %ebx
80105d44:	e8 c7 bc ff ff       	call   80101a10 <iunlockput>
    end_op();
80105d49:	e8 82 d0 ff ff       	call   80102dd0 <end_op>
    return -1;
80105d4e:	83 c4 10             	add    $0x10,%esp
80105d51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d56:	eb d7                	jmp    80105d2f <sys_chdir+0x6f>
80105d58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d5f:	90                   	nop
    end_op();
80105d60:	e8 6b d0 ff ff       	call   80102dd0 <end_op>
    return -1;
80105d65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d6a:	eb c3                	jmp    80105d2f <sys_chdir+0x6f>
80105d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d70 <sys_exec>:

int
sys_exec(void)
{
80105d70:	55                   	push   %ebp
80105d71:	89 e5                	mov    %esp,%ebp
80105d73:	57                   	push   %edi
80105d74:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105d75:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105d7b:	53                   	push   %ebx
80105d7c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105d82:	50                   	push   %eax
80105d83:	6a 00                	push   $0x0
80105d85:	e8 f6 f4 ff ff       	call   80105280 <argstr>
80105d8a:	83 c4 10             	add    $0x10,%esp
80105d8d:	85 c0                	test   %eax,%eax
80105d8f:	0f 88 87 00 00 00    	js     80105e1c <sys_exec+0xac>
80105d95:	83 ec 08             	sub    $0x8,%esp
80105d98:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105d9e:	50                   	push   %eax
80105d9f:	6a 01                	push   $0x1
80105da1:	e8 1a f4 ff ff       	call   801051c0 <argint>
80105da6:	83 c4 10             	add    $0x10,%esp
80105da9:	85 c0                	test   %eax,%eax
80105dab:	78 6f                	js     80105e1c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105dad:	83 ec 04             	sub    $0x4,%esp
80105db0:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105db6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105db8:	68 80 00 00 00       	push   $0x80
80105dbd:	6a 00                	push   $0x0
80105dbf:	56                   	push   %esi
80105dc0:	e8 3b f1 ff ff       	call   80104f00 <memset>
80105dc5:	83 c4 10             	add    $0x10,%esp
80105dc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dcf:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105dd0:	83 ec 08             	sub    $0x8,%esp
80105dd3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105dd9:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105de0:	50                   	push   %eax
80105de1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105de7:	01 f8                	add    %edi,%eax
80105de9:	50                   	push   %eax
80105dea:	e8 41 f3 ff ff       	call   80105130 <fetchint>
80105def:	83 c4 10             	add    $0x10,%esp
80105df2:	85 c0                	test   %eax,%eax
80105df4:	78 26                	js     80105e1c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105df6:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105dfc:	85 c0                	test   %eax,%eax
80105dfe:	74 30                	je     80105e30 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105e00:	83 ec 08             	sub    $0x8,%esp
80105e03:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105e06:	52                   	push   %edx
80105e07:	50                   	push   %eax
80105e08:	e8 63 f3 ff ff       	call   80105170 <fetchstr>
80105e0d:	83 c4 10             	add    $0x10,%esp
80105e10:	85 c0                	test   %eax,%eax
80105e12:	78 08                	js     80105e1c <sys_exec+0xac>
  for(i=0;; i++){
80105e14:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105e17:	83 fb 20             	cmp    $0x20,%ebx
80105e1a:	75 b4                	jne    80105dd0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105e1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105e1f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e24:	5b                   	pop    %ebx
80105e25:	5e                   	pop    %esi
80105e26:	5f                   	pop    %edi
80105e27:	5d                   	pop    %ebp
80105e28:	c3                   	ret    
80105e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105e30:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105e37:	00 00 00 00 
  return exec(path, argv);
80105e3b:	83 ec 08             	sub    $0x8,%esp
80105e3e:	56                   	push   %esi
80105e3f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105e45:	e8 66 ac ff ff       	call   80100ab0 <exec>
80105e4a:	83 c4 10             	add    $0x10,%esp
}
80105e4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e50:	5b                   	pop    %ebx
80105e51:	5e                   	pop    %esi
80105e52:	5f                   	pop    %edi
80105e53:	5d                   	pop    %ebp
80105e54:	c3                   	ret    
80105e55:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e60 <sys_pipe>:

int
sys_pipe(void)
{
80105e60:	55                   	push   %ebp
80105e61:	89 e5                	mov    %esp,%ebp
80105e63:	57                   	push   %edi
80105e64:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105e65:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105e68:	53                   	push   %ebx
80105e69:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105e6c:	6a 08                	push   $0x8
80105e6e:	50                   	push   %eax
80105e6f:	6a 00                	push   $0x0
80105e71:	e8 9a f3 ff ff       	call   80105210 <argptr>
80105e76:	83 c4 10             	add    $0x10,%esp
80105e79:	85 c0                	test   %eax,%eax
80105e7b:	78 4a                	js     80105ec7 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105e7d:	83 ec 08             	sub    $0x8,%esp
80105e80:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105e83:	50                   	push   %eax
80105e84:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105e87:	50                   	push   %eax
80105e88:	e8 a3 d5 ff ff       	call   80103430 <pipealloc>
80105e8d:	83 c4 10             	add    $0x10,%esp
80105e90:	85 c0                	test   %eax,%eax
80105e92:	78 33                	js     80105ec7 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105e94:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105e97:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105e99:	e8 62 dd ff ff       	call   80103c00 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105e9e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105ea0:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105ea4:	85 f6                	test   %esi,%esi
80105ea6:	74 28                	je     80105ed0 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105ea8:	83 c3 01             	add    $0x1,%ebx
80105eab:	83 fb 10             	cmp    $0x10,%ebx
80105eae:	75 f0                	jne    80105ea0 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105eb0:	83 ec 0c             	sub    $0xc,%esp
80105eb3:	ff 75 e0             	push   -0x20(%ebp)
80105eb6:	e8 35 b0 ff ff       	call   80100ef0 <fileclose>
    fileclose(wf);
80105ebb:	58                   	pop    %eax
80105ebc:	ff 75 e4             	push   -0x1c(%ebp)
80105ebf:	e8 2c b0 ff ff       	call   80100ef0 <fileclose>
    return -1;
80105ec4:	83 c4 10             	add    $0x10,%esp
80105ec7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ecc:	eb 53                	jmp    80105f21 <sys_pipe+0xc1>
80105ece:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105ed0:	8d 73 08             	lea    0x8(%ebx),%esi
80105ed3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105ed7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105eda:	e8 21 dd ff ff       	call   80103c00 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105edf:	31 d2                	xor    %edx,%edx
80105ee1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105ee8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105eec:	85 c9                	test   %ecx,%ecx
80105eee:	74 20                	je     80105f10 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105ef0:	83 c2 01             	add    $0x1,%edx
80105ef3:	83 fa 10             	cmp    $0x10,%edx
80105ef6:	75 f0                	jne    80105ee8 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105ef8:	e8 03 dd ff ff       	call   80103c00 <myproc>
80105efd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105f04:	00 
80105f05:	eb a9                	jmp    80105eb0 <sys_pipe+0x50>
80105f07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f0e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105f10:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105f14:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105f17:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105f19:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105f1c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105f1f:	31 c0                	xor    %eax,%eax
}
80105f21:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f24:	5b                   	pop    %ebx
80105f25:	5e                   	pop    %esi
80105f26:	5f                   	pop    %edi
80105f27:	5d                   	pop    %ebp
80105f28:	c3                   	ret    
80105f29:	66 90                	xchg   %ax,%ax
80105f2b:	66 90                	xchg   %ax,%ax
80105f2d:	66 90                	xchg   %ax,%ax
80105f2f:	90                   	nop

80105f30 <sys_fork>:
int getps(void);

int
sys_fork(void)
{
  return fork();
80105f30:	e9 cb de ff ff       	jmp    80103e00 <fork>
80105f35:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105f40 <sys_exit>:
}

int
sys_exit(void)
{
80105f40:	55                   	push   %ebp
80105f41:	89 e5                	mov    %esp,%ebp
80105f43:	83 ec 08             	sub    $0x8,%esp
  exit();
80105f46:	e8 95 e2 ff ff       	call   801041e0 <exit>
  return 0;  // not reached
}
80105f4b:	31 c0                	xor    %eax,%eax
80105f4d:	c9                   	leave  
80105f4e:	c3                   	ret    
80105f4f:	90                   	nop

80105f50 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105f50:	e9 4b e4 ff ff       	jmp    801043a0 <wait>
80105f55:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105f60 <sys_kill>:
}

int
sys_kill(void)
{
80105f60:	55                   	push   %ebp
80105f61:	89 e5                	mov    %esp,%ebp
80105f63:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105f66:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f69:	50                   	push   %eax
80105f6a:	6a 00                	push   $0x0
80105f6c:	e8 4f f2 ff ff       	call   801051c0 <argint>
80105f71:	83 c4 10             	add    $0x10,%esp
80105f74:	85 c0                	test   %eax,%eax
80105f76:	78 18                	js     80105f90 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105f78:	83 ec 0c             	sub    $0xc,%esp
80105f7b:	ff 75 f4             	push   -0xc(%ebp)
80105f7e:	e8 6d e8 ff ff       	call   801047f0 <kill>
80105f83:	83 c4 10             	add    $0x10,%esp
}
80105f86:	c9                   	leave  
80105f87:	c3                   	ret    
80105f88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f8f:	90                   	nop
80105f90:	c9                   	leave  
    return -1;
80105f91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f96:	c3                   	ret    
80105f97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f9e:	66 90                	xchg   %ax,%ax

80105fa0 <sys_getpid>:

int
sys_getpid(void)
{
80105fa0:	55                   	push   %ebp
80105fa1:	89 e5                	mov    %esp,%ebp
80105fa3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105fa6:	e8 55 dc ff ff       	call   80103c00 <myproc>
80105fab:	8b 40 10             	mov    0x10(%eax),%eax
}
80105fae:	c9                   	leave  
80105faf:	c3                   	ret    

80105fb0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105fb0:	55                   	push   %ebp
80105fb1:	89 e5                	mov    %esp,%ebp
80105fb3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105fb4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105fb7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105fba:	50                   	push   %eax
80105fbb:	6a 00                	push   $0x0
80105fbd:	e8 fe f1 ff ff       	call   801051c0 <argint>
80105fc2:	83 c4 10             	add    $0x10,%esp
80105fc5:	85 c0                	test   %eax,%eax
80105fc7:	78 27                	js     80105ff0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105fc9:	e8 32 dc ff ff       	call   80103c00 <myproc>
  if(growproc(n) < 0)
80105fce:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105fd1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105fd3:	ff 75 f4             	push   -0xc(%ebp)
80105fd6:	e8 a5 dd ff ff       	call   80103d80 <growproc>
80105fdb:	83 c4 10             	add    $0x10,%esp
80105fde:	85 c0                	test   %eax,%eax
80105fe0:	78 0e                	js     80105ff0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105fe2:	89 d8                	mov    %ebx,%eax
80105fe4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105fe7:	c9                   	leave  
80105fe8:	c3                   	ret    
80105fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105ff0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105ff5:	eb eb                	jmp    80105fe2 <sys_sbrk+0x32>
80105ff7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ffe:	66 90                	xchg   %ax,%ax

80106000 <sys_sleep>:

int
sys_sleep(void)
{
80106000:	55                   	push   %ebp
80106001:	89 e5                	mov    %esp,%ebp
80106003:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106004:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106007:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010600a:	50                   	push   %eax
8010600b:	6a 00                	push   $0x0
8010600d:	e8 ae f1 ff ff       	call   801051c0 <argint>
80106012:	83 c4 10             	add    $0x10,%esp
80106015:	85 c0                	test   %eax,%eax
80106017:	0f 88 8a 00 00 00    	js     801060a7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010601d:	83 ec 0c             	sub    $0xc,%esp
80106020:	68 a0 62 11 80       	push   $0x801162a0
80106025:	e8 16 ee ff ff       	call   80104e40 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010602a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
8010602d:	8b 1d 84 62 11 80    	mov    0x80116284,%ebx
  while(ticks - ticks0 < n){
80106033:	83 c4 10             	add    $0x10,%esp
80106036:	85 d2                	test   %edx,%edx
80106038:	75 27                	jne    80106061 <sys_sleep+0x61>
8010603a:	eb 54                	jmp    80106090 <sys_sleep+0x90>
8010603c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106040:	83 ec 08             	sub    $0x8,%esp
80106043:	68 a0 62 11 80       	push   $0x801162a0
80106048:	68 84 62 11 80       	push   $0x80116284
8010604d:	e8 5e e6 ff ff       	call   801046b0 <sleep>
  while(ticks - ticks0 < n){
80106052:	a1 84 62 11 80       	mov    0x80116284,%eax
80106057:	83 c4 10             	add    $0x10,%esp
8010605a:	29 d8                	sub    %ebx,%eax
8010605c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010605f:	73 2f                	jae    80106090 <sys_sleep+0x90>
    if(myproc()->killed){
80106061:	e8 9a db ff ff       	call   80103c00 <myproc>
80106066:	8b 40 24             	mov    0x24(%eax),%eax
80106069:	85 c0                	test   %eax,%eax
8010606b:	74 d3                	je     80106040 <sys_sleep+0x40>
      release(&tickslock);
8010606d:	83 ec 0c             	sub    $0xc,%esp
80106070:	68 a0 62 11 80       	push   $0x801162a0
80106075:	e8 66 ed ff ff       	call   80104de0 <release>
  }
  release(&tickslock);
  return 0;
}
8010607a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010607d:	83 c4 10             	add    $0x10,%esp
80106080:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106085:	c9                   	leave  
80106086:	c3                   	ret    
80106087:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010608e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80106090:	83 ec 0c             	sub    $0xc,%esp
80106093:	68 a0 62 11 80       	push   $0x801162a0
80106098:	e8 43 ed ff ff       	call   80104de0 <release>
  return 0;
8010609d:	83 c4 10             	add    $0x10,%esp
801060a0:	31 c0                	xor    %eax,%eax
}
801060a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801060a5:	c9                   	leave  
801060a6:	c3                   	ret    
    return -1;
801060a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060ac:	eb f4                	jmp    801060a2 <sys_sleep+0xa2>
801060ae:	66 90                	xchg   %ax,%ax

801060b0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801060b0:	55                   	push   %ebp
801060b1:	89 e5                	mov    %esp,%ebp
801060b3:	53                   	push   %ebx
801060b4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801060b7:	68 a0 62 11 80       	push   $0x801162a0
801060bc:	e8 7f ed ff ff       	call   80104e40 <acquire>
  xticks = ticks;
801060c1:	8b 1d 84 62 11 80    	mov    0x80116284,%ebx
  release(&tickslock);
801060c7:	c7 04 24 a0 62 11 80 	movl   $0x801162a0,(%esp)
801060ce:	e8 0d ed ff ff       	call   80104de0 <release>
  return xticks;
}
801060d3:	89 d8                	mov    %ebx,%eax
801060d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801060d8:	c9                   	leave  
801060d9:	c3                   	ret    
801060da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801060e0 <sys_waitx>:

int sys_waitx(void)
{
801060e0:	55                   	push   %ebp
801060e1:	89 e5                	mov    %esp,%ebp
801060e3:	83 ec 1c             	sub    $0x1c,%esp
  int *wtime, *rtime;

  if (argptr(0, (char **)&wtime, sizeof(int)) < 0)
801060e6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801060e9:	6a 04                	push   $0x4
801060eb:	50                   	push   %eax
801060ec:	6a 00                	push   $0x0
801060ee:	e8 1d f1 ff ff       	call   80105210 <argptr>
801060f3:	83 c4 10             	add    $0x10,%esp
801060f6:	85 c0                	test   %eax,%eax
801060f8:	78 2e                	js     80106128 <sys_waitx+0x48>
    return -1;

  if (argptr(1, (char **)&rtime, sizeof(int)) < 0)
801060fa:	83 ec 04             	sub    $0x4,%esp
801060fd:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106100:	6a 04                	push   $0x4
80106102:	50                   	push   %eax
80106103:	6a 01                	push   $0x1
80106105:	e8 06 f1 ff ff       	call   80105210 <argptr>
8010610a:	83 c4 10             	add    $0x10,%esp
8010610d:	85 c0                	test   %eax,%eax
8010610f:	78 17                	js     80106128 <sys_waitx+0x48>
    return -1;
  
  return waitx(wtime, rtime);
80106111:	83 ec 08             	sub    $0x8,%esp
80106114:	ff 75 f4             	push   -0xc(%ebp)
80106117:	ff 75 f0             	push   -0x10(%ebp)
8010611a:	e8 d1 e3 ff ff       	call   801044f0 <waitx>
8010611f:	83 c4 10             	add    $0x10,%esp
}
80106122:	c9                   	leave  
80106123:	c3                   	ret    
80106124:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106128:	c9                   	leave  
    return -1;
80106129:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010612e:	c3                   	ret    
8010612f:	90                   	nop

80106130 <sys_getps>:

int sys_getps(void)
{
  return getps();
80106130:	e9 1b e8 ff ff       	jmp    80104950 <getps>

80106135 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106135:	1e                   	push   %ds
  pushl %es
80106136:	06                   	push   %es
  pushl %fs
80106137:	0f a0                	push   %fs
  pushl %gs
80106139:	0f a8                	push   %gs
  pushal
8010613b:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
8010613c:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106140:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106142:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106144:	54                   	push   %esp
  call trap
80106145:	e8 c6 00 00 00       	call   80106210 <trap>
  addl $4, %esp
8010614a:	83 c4 04             	add    $0x4,%esp

8010614d <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010614d:	61                   	popa   
  popl %gs
8010614e:	0f a9                	pop    %gs
  popl %fs
80106150:	0f a1                	pop    %fs
  popl %es
80106152:	07                   	pop    %es
  popl %ds
80106153:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106154:	83 c4 08             	add    $0x8,%esp
  iret
80106157:	cf                   	iret   
80106158:	66 90                	xchg   %ax,%ax
8010615a:	66 90                	xchg   %ax,%ax
8010615c:	66 90                	xchg   %ax,%ax
8010615e:	66 90                	xchg   %ax,%ax

80106160 <tvinit>:
int wakeup_ps = 0; // FCFS
const int TICKS_LIMIT = 500; //FCFS

void
tvinit(void)
{
80106160:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106161:	31 c0                	xor    %eax,%eax
{
80106163:	89 e5                	mov    %esp,%ebp
80106165:	83 ec 08             	sub    $0x8,%esp
80106168:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010616f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106170:	8b 14 85 38 b0 10 80 	mov    -0x7fef4fc8(,%eax,4),%edx
80106177:	c7 04 c5 e2 62 11 80 	movl   $0x8e000008,-0x7fee9d1e(,%eax,8)
8010617e:	08 00 00 8e 
80106182:	66 89 14 c5 e0 62 11 	mov    %dx,-0x7fee9d20(,%eax,8)
80106189:	80 
8010618a:	c1 ea 10             	shr    $0x10,%edx
8010618d:	66 89 14 c5 e6 62 11 	mov    %dx,-0x7fee9d1a(,%eax,8)
80106194:	80 
  for(i = 0; i < 256; i++)
80106195:	83 c0 01             	add    $0x1,%eax
80106198:	3d 00 01 00 00       	cmp    $0x100,%eax
8010619d:	75 d1                	jne    80106170 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010619f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801061a2:	a1 38 b1 10 80       	mov    0x8010b138,%eax
801061a7:	c7 05 e2 64 11 80 08 	movl   $0xef000008,0x801164e2
801061ae:	00 00 ef 
  initlock(&tickslock, "time");
801061b1:	68 e1 83 10 80       	push   $0x801083e1
801061b6:	68 a0 62 11 80       	push   $0x801162a0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801061bb:	66 a3 e0 64 11 80    	mov    %ax,0x801164e0
801061c1:	c1 e8 10             	shr    $0x10,%eax
801061c4:	66 a3 e6 64 11 80    	mov    %ax,0x801164e6
  initlock(&tickslock, "time");
801061ca:	e8 a1 ea ff ff       	call   80104c70 <initlock>
}
801061cf:	83 c4 10             	add    $0x10,%esp
801061d2:	c9                   	leave  
801061d3:	c3                   	ret    
801061d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801061df:	90                   	nop

801061e0 <idtinit>:

void
idtinit(void)
{
801061e0:	55                   	push   %ebp
  pd[0] = size-1;
801061e1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801061e6:	89 e5                	mov    %esp,%ebp
801061e8:	83 ec 10             	sub    $0x10,%esp
801061eb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801061ef:	b8 e0 62 11 80       	mov    $0x801162e0,%eax
801061f4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801061f8:	c1 e8 10             	shr    $0x10,%eax
801061fb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801061ff:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106202:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106205:	c9                   	leave  
80106206:	c3                   	ret    
80106207:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010620e:	66 90                	xchg   %ax,%ax

80106210 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106210:	55                   	push   %ebp
80106211:	89 e5                	mov    %esp,%ebp
80106213:	57                   	push   %edi
80106214:	56                   	push   %esi
80106215:	53                   	push   %ebx
80106216:	83 ec 1c             	sub    $0x1c,%esp
80106219:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
8010621c:	8b 43 30             	mov    0x30(%ebx),%eax
8010621f:	83 f8 40             	cmp    $0x40,%eax
80106222:	0f 84 a0 01 00 00    	je     801063c8 <trap+0x1b8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106228:	83 e8 20             	sub    $0x20,%eax
8010622b:	83 f8 1f             	cmp    $0x1f,%eax
8010622e:	0f 87 8c 00 00 00    	ja     801062c0 <trap+0xb0>
80106234:	ff 24 85 88 84 10 80 	jmp    *-0x7fef7b78(,%eax,4)
8010623b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010623f:	90                   	nop
      ticking();
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106240:	e8 fb bf ff ff       	call   80102240 <ideintr>
    lapiceoi();
80106245:	e8 c6 c6 ff ff       	call   80102910 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010624a:	e8 b1 d9 ff ff       	call   80103c00 <myproc>
8010624f:	85 c0                	test   %eax,%eax
80106251:	74 1d                	je     80106270 <trap+0x60>
80106253:	e8 a8 d9 ff ff       	call   80103c00 <myproc>
80106258:	8b 50 24             	mov    0x24(%eax),%edx
8010625b:	85 d2                	test   %edx,%edx
8010625d:	74 11                	je     80106270 <trap+0x60>
8010625f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106263:	83 e0 03             	and    $0x3,%eax
80106266:	66 83 f8 03          	cmp    $0x3,%ax
8010626a:	0f 84 20 02 00 00    	je     80106490 <trap+0x280>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
 #endif
    
    
 if(myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80106270:	e8 8b d9 ff ff       	call   80103c00 <myproc>
80106275:	85 c0                	test   %eax,%eax
80106277:	74 0f                	je     80106288 <trap+0x78>
80106279:	e8 82 d9 ff ff       	call   80103c00 <myproc>
8010627e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106282:	0f 84 b8 00 00 00    	je     80106340 <trap+0x130>
			}	
    #endif
    }

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106288:	e8 73 d9 ff ff       	call   80103c00 <myproc>
8010628d:	85 c0                	test   %eax,%eax
8010628f:	74 1d                	je     801062ae <trap+0x9e>
80106291:	e8 6a d9 ff ff       	call   80103c00 <myproc>
80106296:	8b 40 24             	mov    0x24(%eax),%eax
80106299:	85 c0                	test   %eax,%eax
8010629b:	74 11                	je     801062ae <trap+0x9e>
8010629d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801062a1:	83 e0 03             	and    $0x3,%eax
801062a4:	66 83 f8 03          	cmp    $0x3,%ax
801062a8:	0f 84 47 01 00 00    	je     801063f5 <trap+0x1e5>
    exit();
}
801062ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062b1:	5b                   	pop    %ebx
801062b2:	5e                   	pop    %esi
801062b3:	5f                   	pop    %edi
801062b4:	5d                   	pop    %ebp
801062b5:	c3                   	ret    
801062b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801062bd:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
801062c0:	e8 3b d9 ff ff       	call   80103c00 <myproc>
801062c5:	8b 7b 38             	mov    0x38(%ebx),%edi
801062c8:	85 c0                	test   %eax,%eax
801062ca:	0f 84 f6 01 00 00    	je     801064c6 <trap+0x2b6>
801062d0:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801062d4:	0f 84 ec 01 00 00    	je     801064c6 <trap+0x2b6>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801062da:	0f 20 d1             	mov    %cr2,%ecx
801062dd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801062e0:	e8 fb d8 ff ff       	call   80103be0 <cpuid>
801062e5:	8b 73 30             	mov    0x30(%ebx),%esi
801062e8:	89 45 dc             	mov    %eax,-0x24(%ebp)
801062eb:	8b 43 34             	mov    0x34(%ebx),%eax
801062ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
801062f1:	e8 0a d9 ff ff       	call   80103c00 <myproc>
801062f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801062f9:	e8 02 d9 ff ff       	call   80103c00 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801062fe:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106301:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106304:	51                   	push   %ecx
80106305:	57                   	push   %edi
80106306:	52                   	push   %edx
80106307:	ff 75 e4             	push   -0x1c(%ebp)
8010630a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
8010630b:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010630e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106311:	56                   	push   %esi
80106312:	ff 70 10             	push   0x10(%eax)
80106315:	68 44 84 10 80       	push   $0x80108444
8010631a:	e8 81 a3 ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
8010631f:	83 c4 20             	add    $0x20,%esp
80106322:	e8 d9 d8 ff ff       	call   80103c00 <myproc>
80106327:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010632e:	e8 cd d8 ff ff       	call   80103c00 <myproc>
80106333:	85 c0                	test   %eax,%eax
80106335:	0f 85 18 ff ff ff    	jne    80106253 <trap+0x43>
8010633b:	e9 30 ff ff ff       	jmp    80106270 <trap+0x60>
 if(myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80106340:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106344:	0f 85 3e ff ff ff    	jne    80106288 <trap+0x78>
			if(myproc()->curr_ticks >= q_ticks_max[myproc()->queue])
8010634a:	e8 b1 d8 ff ff       	call   80103c00 <myproc>
8010634f:	8b b0 b0 00 00 00    	mov    0xb0(%eax),%esi
80106355:	e8 a6 d8 ff ff       	call   80103c00 <myproc>
8010635a:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80106360:	3b 34 85 24 b0 10 80 	cmp    -0x7fef4fdc(,%eax,4),%esi
80106367:	0f 8c 43 01 00 00    	jl     801064b0 <trap+0x2a0>
				change_q_flag(myproc());
8010636d:	e8 8e d8 ff ff       	call   80103c00 <myproc>
80106372:	83 ec 0c             	sub    $0xc,%esp
80106375:	50                   	push   %eax
80106376:	e8 65 d7 ff ff       	call   80103ae0 <change_q_flag>
				yield(); 
8010637b:	e8 e0 e2 ff ff       	call   80104660 <yield>
80106380:	83 c4 10             	add    $0x10,%esp
80106383:	e9 00 ff ff ff       	jmp    80106288 <trap+0x78>
80106388:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010638f:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106390:	8b 7b 38             	mov    0x38(%ebx),%edi
80106393:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80106397:	e8 44 d8 ff ff       	call   80103be0 <cpuid>
8010639c:	57                   	push   %edi
8010639d:	56                   	push   %esi
8010639e:	50                   	push   %eax
8010639f:	68 ec 83 10 80       	push   $0x801083ec
801063a4:	e8 f7 a2 ff ff       	call   801006a0 <cprintf>
    lapiceoi();
801063a9:	e8 62 c5 ff ff       	call   80102910 <lapiceoi>
    break;
801063ae:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801063b1:	e8 4a d8 ff ff       	call   80103c00 <myproc>
801063b6:	85 c0                	test   %eax,%eax
801063b8:	0f 85 95 fe ff ff    	jne    80106253 <trap+0x43>
801063be:	e9 ad fe ff ff       	jmp    80106270 <trap+0x60>
801063c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801063c7:	90                   	nop
    if(myproc()->killed)
801063c8:	e8 33 d8 ff ff       	call   80103c00 <myproc>
801063cd:	8b 70 24             	mov    0x24(%eax),%esi
801063d0:	85 f6                	test   %esi,%esi
801063d2:	0f 85 c8 00 00 00    	jne    801064a0 <trap+0x290>
    myproc()->tf = tf;
801063d8:	e8 23 d8 ff ff       	call   80103c00 <myproc>
801063dd:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
801063e0:	e8 1b ef ff ff       	call   80105300 <syscall>
    if(myproc()->killed)
801063e5:	e8 16 d8 ff ff       	call   80103c00 <myproc>
801063ea:	8b 48 24             	mov    0x24(%eax),%ecx
801063ed:	85 c9                	test   %ecx,%ecx
801063ef:	0f 84 b9 fe ff ff    	je     801062ae <trap+0x9e>
}
801063f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063f8:	5b                   	pop    %ebx
801063f9:	5e                   	pop    %esi
801063fa:	5f                   	pop    %edi
801063fb:	5d                   	pop    %ebp
      exit();
801063fc:	e9 df dd ff ff       	jmp    801041e0 <exit>
80106401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106408:	e8 53 02 00 00       	call   80106660 <uartintr>
    lapiceoi();
8010640d:	e8 fe c4 ff ff       	call   80102910 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106412:	e8 e9 d7 ff ff       	call   80103c00 <myproc>
80106417:	85 c0                	test   %eax,%eax
80106419:	0f 85 34 fe ff ff    	jne    80106253 <trap+0x43>
8010641f:	e9 4c fe ff ff       	jmp    80106270 <trap+0x60>
80106424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106428:	e8 a3 c3 ff ff       	call   801027d0 <kbdintr>
    lapiceoi();
8010642d:	e8 de c4 ff ff       	call   80102910 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106432:	e8 c9 d7 ff ff       	call   80103c00 <myproc>
80106437:	85 c0                	test   %eax,%eax
80106439:	0f 85 14 fe ff ff    	jne    80106253 <trap+0x43>
8010643f:	e9 2c fe ff ff       	jmp    80106270 <trap+0x60>
80106444:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80106448:	e8 93 d7 ff ff       	call   80103be0 <cpuid>
8010644d:	85 c0                	test   %eax,%eax
8010644f:	0f 85 f0 fd ff ff    	jne    80106245 <trap+0x35>
      acquire(&tickslock);
80106455:	83 ec 0c             	sub    $0xc,%esp
80106458:	68 a0 62 11 80       	push   $0x801162a0
8010645d:	e8 de e9 ff ff       	call   80104e40 <acquire>
      wakeup(&ticks);
80106462:	c7 04 24 84 62 11 80 	movl   $0x80116284,(%esp)
      ticks++;
80106469:	83 05 84 62 11 80 01 	addl   $0x1,0x80116284
      wakeup(&ticks);
80106470:	e8 fb e2 ff ff       	call   80104770 <wakeup>
      release(&tickslock);
80106475:	c7 04 24 a0 62 11 80 	movl   $0x801162a0,(%esp)
8010647c:	e8 5f e9 ff ff       	call   80104de0 <release>
      ticking();
80106481:	e8 ea d4 ff ff       	call   80103970 <ticking>
80106486:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106489:	e9 b7 fd ff ff       	jmp    80106245 <trap+0x35>
8010648e:	66 90                	xchg   %ax,%ax
    exit();
80106490:	e8 4b dd ff ff       	call   801041e0 <exit>
80106495:	e9 d6 fd ff ff       	jmp    80106270 <trap+0x60>
8010649a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
801064a0:	e8 3b dd ff ff       	call   801041e0 <exit>
801064a5:	e9 2e ff ff ff       	jmp    801063d8 <trap+0x1c8>
801064aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
				incr_curr_ticks(myproc());
801064b0:	e8 4b d7 ff ff       	call   80103c00 <myproc>
801064b5:	83 ec 0c             	sub    $0xc,%esp
801064b8:	50                   	push   %eax
801064b9:	e8 62 d6 ff ff       	call   80103b20 <incr_curr_ticks>
801064be:	83 c4 10             	add    $0x10,%esp
801064c1:	e9 c2 fd ff ff       	jmp    80106288 <trap+0x78>
801064c6:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801064c9:	e8 12 d7 ff ff       	call   80103be0 <cpuid>
801064ce:	83 ec 0c             	sub    $0xc,%esp
801064d1:	56                   	push   %esi
801064d2:	57                   	push   %edi
801064d3:	50                   	push   %eax
801064d4:	ff 73 30             	push   0x30(%ebx)
801064d7:	68 10 84 10 80       	push   $0x80108410
801064dc:	e8 bf a1 ff ff       	call   801006a0 <cprintf>
      panic("trap");
801064e1:	83 c4 14             	add    $0x14,%esp
801064e4:	68 e6 83 10 80       	push   $0x801083e6
801064e9:	e8 92 9e ff ff       	call   80100380 <panic>
801064ee:	66 90                	xchg   %ax,%ax

801064f0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801064f0:	a1 e0 6a 11 80       	mov    0x80116ae0,%eax
801064f5:	85 c0                	test   %eax,%eax
801064f7:	74 17                	je     80106510 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801064f9:	ba fd 03 00 00       	mov    $0x3fd,%edx
801064fe:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801064ff:	a8 01                	test   $0x1,%al
80106501:	74 0d                	je     80106510 <uartgetc+0x20>
80106503:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106508:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106509:	0f b6 c0             	movzbl %al,%eax
8010650c:	c3                   	ret    
8010650d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106510:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106515:	c3                   	ret    
80106516:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010651d:	8d 76 00             	lea    0x0(%esi),%esi

80106520 <uartinit>:
{
80106520:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106521:	31 c9                	xor    %ecx,%ecx
80106523:	89 c8                	mov    %ecx,%eax
80106525:	89 e5                	mov    %esp,%ebp
80106527:	57                   	push   %edi
80106528:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010652d:	56                   	push   %esi
8010652e:	89 fa                	mov    %edi,%edx
80106530:	53                   	push   %ebx
80106531:	83 ec 1c             	sub    $0x1c,%esp
80106534:	ee                   	out    %al,(%dx)
80106535:	be fb 03 00 00       	mov    $0x3fb,%esi
8010653a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010653f:	89 f2                	mov    %esi,%edx
80106541:	ee                   	out    %al,(%dx)
80106542:	b8 0c 00 00 00       	mov    $0xc,%eax
80106547:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010654c:	ee                   	out    %al,(%dx)
8010654d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80106552:	89 c8                	mov    %ecx,%eax
80106554:	89 da                	mov    %ebx,%edx
80106556:	ee                   	out    %al,(%dx)
80106557:	b8 03 00 00 00       	mov    $0x3,%eax
8010655c:	89 f2                	mov    %esi,%edx
8010655e:	ee                   	out    %al,(%dx)
8010655f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106564:	89 c8                	mov    %ecx,%eax
80106566:	ee                   	out    %al,(%dx)
80106567:	b8 01 00 00 00       	mov    $0x1,%eax
8010656c:	89 da                	mov    %ebx,%edx
8010656e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010656f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106574:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106575:	3c ff                	cmp    $0xff,%al
80106577:	74 78                	je     801065f1 <uartinit+0xd1>
  uart = 1;
80106579:	c7 05 e0 6a 11 80 01 	movl   $0x1,0x80116ae0
80106580:	00 00 00 
80106583:	89 fa                	mov    %edi,%edx
80106585:	ec                   	in     (%dx),%al
80106586:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010658b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010658c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010658f:	bf 0c 85 10 80       	mov    $0x8010850c,%edi
80106594:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80106599:	6a 00                	push   $0x0
8010659b:	6a 04                	push   $0x4
8010659d:	e8 de be ff ff       	call   80102480 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
801065a2:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
801065a6:	83 c4 10             	add    $0x10,%esp
801065a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
801065b0:	a1 e0 6a 11 80       	mov    0x80116ae0,%eax
801065b5:	bb 80 00 00 00       	mov    $0x80,%ebx
801065ba:	85 c0                	test   %eax,%eax
801065bc:	75 14                	jne    801065d2 <uartinit+0xb2>
801065be:	eb 23                	jmp    801065e3 <uartinit+0xc3>
    microdelay(10);
801065c0:	83 ec 0c             	sub    $0xc,%esp
801065c3:	6a 0a                	push   $0xa
801065c5:	e8 66 c3 ff ff       	call   80102930 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801065ca:	83 c4 10             	add    $0x10,%esp
801065cd:	83 eb 01             	sub    $0x1,%ebx
801065d0:	74 07                	je     801065d9 <uartinit+0xb9>
801065d2:	89 f2                	mov    %esi,%edx
801065d4:	ec                   	in     (%dx),%al
801065d5:	a8 20                	test   $0x20,%al
801065d7:	74 e7                	je     801065c0 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801065d9:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801065dd:	ba f8 03 00 00       	mov    $0x3f8,%edx
801065e2:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
801065e3:	0f b6 47 01          	movzbl 0x1(%edi),%eax
801065e7:	83 c7 01             	add    $0x1,%edi
801065ea:	88 45 e7             	mov    %al,-0x19(%ebp)
801065ed:	84 c0                	test   %al,%al
801065ef:	75 bf                	jne    801065b0 <uartinit+0x90>
}
801065f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801065f4:	5b                   	pop    %ebx
801065f5:	5e                   	pop    %esi
801065f6:	5f                   	pop    %edi
801065f7:	5d                   	pop    %ebp
801065f8:	c3                   	ret    
801065f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106600 <uartputc>:
  if(!uart)
80106600:	a1 e0 6a 11 80       	mov    0x80116ae0,%eax
80106605:	85 c0                	test   %eax,%eax
80106607:	74 47                	je     80106650 <uartputc+0x50>
{
80106609:	55                   	push   %ebp
8010660a:	89 e5                	mov    %esp,%ebp
8010660c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010660d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106612:	53                   	push   %ebx
80106613:	bb 80 00 00 00       	mov    $0x80,%ebx
80106618:	eb 18                	jmp    80106632 <uartputc+0x32>
8010661a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106620:	83 ec 0c             	sub    $0xc,%esp
80106623:	6a 0a                	push   $0xa
80106625:	e8 06 c3 ff ff       	call   80102930 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010662a:	83 c4 10             	add    $0x10,%esp
8010662d:	83 eb 01             	sub    $0x1,%ebx
80106630:	74 07                	je     80106639 <uartputc+0x39>
80106632:	89 f2                	mov    %esi,%edx
80106634:	ec                   	in     (%dx),%al
80106635:	a8 20                	test   $0x20,%al
80106637:	74 e7                	je     80106620 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106639:	8b 45 08             	mov    0x8(%ebp),%eax
8010663c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106641:	ee                   	out    %al,(%dx)
}
80106642:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106645:	5b                   	pop    %ebx
80106646:	5e                   	pop    %esi
80106647:	5d                   	pop    %ebp
80106648:	c3                   	ret    
80106649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106650:	c3                   	ret    
80106651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106658:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010665f:	90                   	nop

80106660 <uartintr>:

void
uartintr(void)
{
80106660:	55                   	push   %ebp
80106661:	89 e5                	mov    %esp,%ebp
80106663:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106666:	68 f0 64 10 80       	push   $0x801064f0
8010666b:	e8 10 a2 ff ff       	call   80100880 <consoleintr>
}
80106670:	83 c4 10             	add    $0x10,%esp
80106673:	c9                   	leave  
80106674:	c3                   	ret    

80106675 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106675:	6a 00                	push   $0x0
  pushl $0
80106677:	6a 00                	push   $0x0
  jmp alltraps
80106679:	e9 b7 fa ff ff       	jmp    80106135 <alltraps>

8010667e <vector1>:
.globl vector1
vector1:
  pushl $0
8010667e:	6a 00                	push   $0x0
  pushl $1
80106680:	6a 01                	push   $0x1
  jmp alltraps
80106682:	e9 ae fa ff ff       	jmp    80106135 <alltraps>

80106687 <vector2>:
.globl vector2
vector2:
  pushl $0
80106687:	6a 00                	push   $0x0
  pushl $2
80106689:	6a 02                	push   $0x2
  jmp alltraps
8010668b:	e9 a5 fa ff ff       	jmp    80106135 <alltraps>

80106690 <vector3>:
.globl vector3
vector3:
  pushl $0
80106690:	6a 00                	push   $0x0
  pushl $3
80106692:	6a 03                	push   $0x3
  jmp alltraps
80106694:	e9 9c fa ff ff       	jmp    80106135 <alltraps>

80106699 <vector4>:
.globl vector4
vector4:
  pushl $0
80106699:	6a 00                	push   $0x0
  pushl $4
8010669b:	6a 04                	push   $0x4
  jmp alltraps
8010669d:	e9 93 fa ff ff       	jmp    80106135 <alltraps>

801066a2 <vector5>:
.globl vector5
vector5:
  pushl $0
801066a2:	6a 00                	push   $0x0
  pushl $5
801066a4:	6a 05                	push   $0x5
  jmp alltraps
801066a6:	e9 8a fa ff ff       	jmp    80106135 <alltraps>

801066ab <vector6>:
.globl vector6
vector6:
  pushl $0
801066ab:	6a 00                	push   $0x0
  pushl $6
801066ad:	6a 06                	push   $0x6
  jmp alltraps
801066af:	e9 81 fa ff ff       	jmp    80106135 <alltraps>

801066b4 <vector7>:
.globl vector7
vector7:
  pushl $0
801066b4:	6a 00                	push   $0x0
  pushl $7
801066b6:	6a 07                	push   $0x7
  jmp alltraps
801066b8:	e9 78 fa ff ff       	jmp    80106135 <alltraps>

801066bd <vector8>:
.globl vector8
vector8:
  pushl $8
801066bd:	6a 08                	push   $0x8
  jmp alltraps
801066bf:	e9 71 fa ff ff       	jmp    80106135 <alltraps>

801066c4 <vector9>:
.globl vector9
vector9:
  pushl $0
801066c4:	6a 00                	push   $0x0
  pushl $9
801066c6:	6a 09                	push   $0x9
  jmp alltraps
801066c8:	e9 68 fa ff ff       	jmp    80106135 <alltraps>

801066cd <vector10>:
.globl vector10
vector10:
  pushl $10
801066cd:	6a 0a                	push   $0xa
  jmp alltraps
801066cf:	e9 61 fa ff ff       	jmp    80106135 <alltraps>

801066d4 <vector11>:
.globl vector11
vector11:
  pushl $11
801066d4:	6a 0b                	push   $0xb
  jmp alltraps
801066d6:	e9 5a fa ff ff       	jmp    80106135 <alltraps>

801066db <vector12>:
.globl vector12
vector12:
  pushl $12
801066db:	6a 0c                	push   $0xc
  jmp alltraps
801066dd:	e9 53 fa ff ff       	jmp    80106135 <alltraps>

801066e2 <vector13>:
.globl vector13
vector13:
  pushl $13
801066e2:	6a 0d                	push   $0xd
  jmp alltraps
801066e4:	e9 4c fa ff ff       	jmp    80106135 <alltraps>

801066e9 <vector14>:
.globl vector14
vector14:
  pushl $14
801066e9:	6a 0e                	push   $0xe
  jmp alltraps
801066eb:	e9 45 fa ff ff       	jmp    80106135 <alltraps>

801066f0 <vector15>:
.globl vector15
vector15:
  pushl $0
801066f0:	6a 00                	push   $0x0
  pushl $15
801066f2:	6a 0f                	push   $0xf
  jmp alltraps
801066f4:	e9 3c fa ff ff       	jmp    80106135 <alltraps>

801066f9 <vector16>:
.globl vector16
vector16:
  pushl $0
801066f9:	6a 00                	push   $0x0
  pushl $16
801066fb:	6a 10                	push   $0x10
  jmp alltraps
801066fd:	e9 33 fa ff ff       	jmp    80106135 <alltraps>

80106702 <vector17>:
.globl vector17
vector17:
  pushl $17
80106702:	6a 11                	push   $0x11
  jmp alltraps
80106704:	e9 2c fa ff ff       	jmp    80106135 <alltraps>

80106709 <vector18>:
.globl vector18
vector18:
  pushl $0
80106709:	6a 00                	push   $0x0
  pushl $18
8010670b:	6a 12                	push   $0x12
  jmp alltraps
8010670d:	e9 23 fa ff ff       	jmp    80106135 <alltraps>

80106712 <vector19>:
.globl vector19
vector19:
  pushl $0
80106712:	6a 00                	push   $0x0
  pushl $19
80106714:	6a 13                	push   $0x13
  jmp alltraps
80106716:	e9 1a fa ff ff       	jmp    80106135 <alltraps>

8010671b <vector20>:
.globl vector20
vector20:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $20
8010671d:	6a 14                	push   $0x14
  jmp alltraps
8010671f:	e9 11 fa ff ff       	jmp    80106135 <alltraps>

80106724 <vector21>:
.globl vector21
vector21:
  pushl $0
80106724:	6a 00                	push   $0x0
  pushl $21
80106726:	6a 15                	push   $0x15
  jmp alltraps
80106728:	e9 08 fa ff ff       	jmp    80106135 <alltraps>

8010672d <vector22>:
.globl vector22
vector22:
  pushl $0
8010672d:	6a 00                	push   $0x0
  pushl $22
8010672f:	6a 16                	push   $0x16
  jmp alltraps
80106731:	e9 ff f9 ff ff       	jmp    80106135 <alltraps>

80106736 <vector23>:
.globl vector23
vector23:
  pushl $0
80106736:	6a 00                	push   $0x0
  pushl $23
80106738:	6a 17                	push   $0x17
  jmp alltraps
8010673a:	e9 f6 f9 ff ff       	jmp    80106135 <alltraps>

8010673f <vector24>:
.globl vector24
vector24:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $24
80106741:	6a 18                	push   $0x18
  jmp alltraps
80106743:	e9 ed f9 ff ff       	jmp    80106135 <alltraps>

80106748 <vector25>:
.globl vector25
vector25:
  pushl $0
80106748:	6a 00                	push   $0x0
  pushl $25
8010674a:	6a 19                	push   $0x19
  jmp alltraps
8010674c:	e9 e4 f9 ff ff       	jmp    80106135 <alltraps>

80106751 <vector26>:
.globl vector26
vector26:
  pushl $0
80106751:	6a 00                	push   $0x0
  pushl $26
80106753:	6a 1a                	push   $0x1a
  jmp alltraps
80106755:	e9 db f9 ff ff       	jmp    80106135 <alltraps>

8010675a <vector27>:
.globl vector27
vector27:
  pushl $0
8010675a:	6a 00                	push   $0x0
  pushl $27
8010675c:	6a 1b                	push   $0x1b
  jmp alltraps
8010675e:	e9 d2 f9 ff ff       	jmp    80106135 <alltraps>

80106763 <vector28>:
.globl vector28
vector28:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $28
80106765:	6a 1c                	push   $0x1c
  jmp alltraps
80106767:	e9 c9 f9 ff ff       	jmp    80106135 <alltraps>

8010676c <vector29>:
.globl vector29
vector29:
  pushl $0
8010676c:	6a 00                	push   $0x0
  pushl $29
8010676e:	6a 1d                	push   $0x1d
  jmp alltraps
80106770:	e9 c0 f9 ff ff       	jmp    80106135 <alltraps>

80106775 <vector30>:
.globl vector30
vector30:
  pushl $0
80106775:	6a 00                	push   $0x0
  pushl $30
80106777:	6a 1e                	push   $0x1e
  jmp alltraps
80106779:	e9 b7 f9 ff ff       	jmp    80106135 <alltraps>

8010677e <vector31>:
.globl vector31
vector31:
  pushl $0
8010677e:	6a 00                	push   $0x0
  pushl $31
80106780:	6a 1f                	push   $0x1f
  jmp alltraps
80106782:	e9 ae f9 ff ff       	jmp    80106135 <alltraps>

80106787 <vector32>:
.globl vector32
vector32:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $32
80106789:	6a 20                	push   $0x20
  jmp alltraps
8010678b:	e9 a5 f9 ff ff       	jmp    80106135 <alltraps>

80106790 <vector33>:
.globl vector33
vector33:
  pushl $0
80106790:	6a 00                	push   $0x0
  pushl $33
80106792:	6a 21                	push   $0x21
  jmp alltraps
80106794:	e9 9c f9 ff ff       	jmp    80106135 <alltraps>

80106799 <vector34>:
.globl vector34
vector34:
  pushl $0
80106799:	6a 00                	push   $0x0
  pushl $34
8010679b:	6a 22                	push   $0x22
  jmp alltraps
8010679d:	e9 93 f9 ff ff       	jmp    80106135 <alltraps>

801067a2 <vector35>:
.globl vector35
vector35:
  pushl $0
801067a2:	6a 00                	push   $0x0
  pushl $35
801067a4:	6a 23                	push   $0x23
  jmp alltraps
801067a6:	e9 8a f9 ff ff       	jmp    80106135 <alltraps>

801067ab <vector36>:
.globl vector36
vector36:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $36
801067ad:	6a 24                	push   $0x24
  jmp alltraps
801067af:	e9 81 f9 ff ff       	jmp    80106135 <alltraps>

801067b4 <vector37>:
.globl vector37
vector37:
  pushl $0
801067b4:	6a 00                	push   $0x0
  pushl $37
801067b6:	6a 25                	push   $0x25
  jmp alltraps
801067b8:	e9 78 f9 ff ff       	jmp    80106135 <alltraps>

801067bd <vector38>:
.globl vector38
vector38:
  pushl $0
801067bd:	6a 00                	push   $0x0
  pushl $38
801067bf:	6a 26                	push   $0x26
  jmp alltraps
801067c1:	e9 6f f9 ff ff       	jmp    80106135 <alltraps>

801067c6 <vector39>:
.globl vector39
vector39:
  pushl $0
801067c6:	6a 00                	push   $0x0
  pushl $39
801067c8:	6a 27                	push   $0x27
  jmp alltraps
801067ca:	e9 66 f9 ff ff       	jmp    80106135 <alltraps>

801067cf <vector40>:
.globl vector40
vector40:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $40
801067d1:	6a 28                	push   $0x28
  jmp alltraps
801067d3:	e9 5d f9 ff ff       	jmp    80106135 <alltraps>

801067d8 <vector41>:
.globl vector41
vector41:
  pushl $0
801067d8:	6a 00                	push   $0x0
  pushl $41
801067da:	6a 29                	push   $0x29
  jmp alltraps
801067dc:	e9 54 f9 ff ff       	jmp    80106135 <alltraps>

801067e1 <vector42>:
.globl vector42
vector42:
  pushl $0
801067e1:	6a 00                	push   $0x0
  pushl $42
801067e3:	6a 2a                	push   $0x2a
  jmp alltraps
801067e5:	e9 4b f9 ff ff       	jmp    80106135 <alltraps>

801067ea <vector43>:
.globl vector43
vector43:
  pushl $0
801067ea:	6a 00                	push   $0x0
  pushl $43
801067ec:	6a 2b                	push   $0x2b
  jmp alltraps
801067ee:	e9 42 f9 ff ff       	jmp    80106135 <alltraps>

801067f3 <vector44>:
.globl vector44
vector44:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $44
801067f5:	6a 2c                	push   $0x2c
  jmp alltraps
801067f7:	e9 39 f9 ff ff       	jmp    80106135 <alltraps>

801067fc <vector45>:
.globl vector45
vector45:
  pushl $0
801067fc:	6a 00                	push   $0x0
  pushl $45
801067fe:	6a 2d                	push   $0x2d
  jmp alltraps
80106800:	e9 30 f9 ff ff       	jmp    80106135 <alltraps>

80106805 <vector46>:
.globl vector46
vector46:
  pushl $0
80106805:	6a 00                	push   $0x0
  pushl $46
80106807:	6a 2e                	push   $0x2e
  jmp alltraps
80106809:	e9 27 f9 ff ff       	jmp    80106135 <alltraps>

8010680e <vector47>:
.globl vector47
vector47:
  pushl $0
8010680e:	6a 00                	push   $0x0
  pushl $47
80106810:	6a 2f                	push   $0x2f
  jmp alltraps
80106812:	e9 1e f9 ff ff       	jmp    80106135 <alltraps>

80106817 <vector48>:
.globl vector48
vector48:
  pushl $0
80106817:	6a 00                	push   $0x0
  pushl $48
80106819:	6a 30                	push   $0x30
  jmp alltraps
8010681b:	e9 15 f9 ff ff       	jmp    80106135 <alltraps>

80106820 <vector49>:
.globl vector49
vector49:
  pushl $0
80106820:	6a 00                	push   $0x0
  pushl $49
80106822:	6a 31                	push   $0x31
  jmp alltraps
80106824:	e9 0c f9 ff ff       	jmp    80106135 <alltraps>

80106829 <vector50>:
.globl vector50
vector50:
  pushl $0
80106829:	6a 00                	push   $0x0
  pushl $50
8010682b:	6a 32                	push   $0x32
  jmp alltraps
8010682d:	e9 03 f9 ff ff       	jmp    80106135 <alltraps>

80106832 <vector51>:
.globl vector51
vector51:
  pushl $0
80106832:	6a 00                	push   $0x0
  pushl $51
80106834:	6a 33                	push   $0x33
  jmp alltraps
80106836:	e9 fa f8 ff ff       	jmp    80106135 <alltraps>

8010683b <vector52>:
.globl vector52
vector52:
  pushl $0
8010683b:	6a 00                	push   $0x0
  pushl $52
8010683d:	6a 34                	push   $0x34
  jmp alltraps
8010683f:	e9 f1 f8 ff ff       	jmp    80106135 <alltraps>

80106844 <vector53>:
.globl vector53
vector53:
  pushl $0
80106844:	6a 00                	push   $0x0
  pushl $53
80106846:	6a 35                	push   $0x35
  jmp alltraps
80106848:	e9 e8 f8 ff ff       	jmp    80106135 <alltraps>

8010684d <vector54>:
.globl vector54
vector54:
  pushl $0
8010684d:	6a 00                	push   $0x0
  pushl $54
8010684f:	6a 36                	push   $0x36
  jmp alltraps
80106851:	e9 df f8 ff ff       	jmp    80106135 <alltraps>

80106856 <vector55>:
.globl vector55
vector55:
  pushl $0
80106856:	6a 00                	push   $0x0
  pushl $55
80106858:	6a 37                	push   $0x37
  jmp alltraps
8010685a:	e9 d6 f8 ff ff       	jmp    80106135 <alltraps>

8010685f <vector56>:
.globl vector56
vector56:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $56
80106861:	6a 38                	push   $0x38
  jmp alltraps
80106863:	e9 cd f8 ff ff       	jmp    80106135 <alltraps>

80106868 <vector57>:
.globl vector57
vector57:
  pushl $0
80106868:	6a 00                	push   $0x0
  pushl $57
8010686a:	6a 39                	push   $0x39
  jmp alltraps
8010686c:	e9 c4 f8 ff ff       	jmp    80106135 <alltraps>

80106871 <vector58>:
.globl vector58
vector58:
  pushl $0
80106871:	6a 00                	push   $0x0
  pushl $58
80106873:	6a 3a                	push   $0x3a
  jmp alltraps
80106875:	e9 bb f8 ff ff       	jmp    80106135 <alltraps>

8010687a <vector59>:
.globl vector59
vector59:
  pushl $0
8010687a:	6a 00                	push   $0x0
  pushl $59
8010687c:	6a 3b                	push   $0x3b
  jmp alltraps
8010687e:	e9 b2 f8 ff ff       	jmp    80106135 <alltraps>

80106883 <vector60>:
.globl vector60
vector60:
  pushl $0
80106883:	6a 00                	push   $0x0
  pushl $60
80106885:	6a 3c                	push   $0x3c
  jmp alltraps
80106887:	e9 a9 f8 ff ff       	jmp    80106135 <alltraps>

8010688c <vector61>:
.globl vector61
vector61:
  pushl $0
8010688c:	6a 00                	push   $0x0
  pushl $61
8010688e:	6a 3d                	push   $0x3d
  jmp alltraps
80106890:	e9 a0 f8 ff ff       	jmp    80106135 <alltraps>

80106895 <vector62>:
.globl vector62
vector62:
  pushl $0
80106895:	6a 00                	push   $0x0
  pushl $62
80106897:	6a 3e                	push   $0x3e
  jmp alltraps
80106899:	e9 97 f8 ff ff       	jmp    80106135 <alltraps>

8010689e <vector63>:
.globl vector63
vector63:
  pushl $0
8010689e:	6a 00                	push   $0x0
  pushl $63
801068a0:	6a 3f                	push   $0x3f
  jmp alltraps
801068a2:	e9 8e f8 ff ff       	jmp    80106135 <alltraps>

801068a7 <vector64>:
.globl vector64
vector64:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $64
801068a9:	6a 40                	push   $0x40
  jmp alltraps
801068ab:	e9 85 f8 ff ff       	jmp    80106135 <alltraps>

801068b0 <vector65>:
.globl vector65
vector65:
  pushl $0
801068b0:	6a 00                	push   $0x0
  pushl $65
801068b2:	6a 41                	push   $0x41
  jmp alltraps
801068b4:	e9 7c f8 ff ff       	jmp    80106135 <alltraps>

801068b9 <vector66>:
.globl vector66
vector66:
  pushl $0
801068b9:	6a 00                	push   $0x0
  pushl $66
801068bb:	6a 42                	push   $0x42
  jmp alltraps
801068bd:	e9 73 f8 ff ff       	jmp    80106135 <alltraps>

801068c2 <vector67>:
.globl vector67
vector67:
  pushl $0
801068c2:	6a 00                	push   $0x0
  pushl $67
801068c4:	6a 43                	push   $0x43
  jmp alltraps
801068c6:	e9 6a f8 ff ff       	jmp    80106135 <alltraps>

801068cb <vector68>:
.globl vector68
vector68:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $68
801068cd:	6a 44                	push   $0x44
  jmp alltraps
801068cf:	e9 61 f8 ff ff       	jmp    80106135 <alltraps>

801068d4 <vector69>:
.globl vector69
vector69:
  pushl $0
801068d4:	6a 00                	push   $0x0
  pushl $69
801068d6:	6a 45                	push   $0x45
  jmp alltraps
801068d8:	e9 58 f8 ff ff       	jmp    80106135 <alltraps>

801068dd <vector70>:
.globl vector70
vector70:
  pushl $0
801068dd:	6a 00                	push   $0x0
  pushl $70
801068df:	6a 46                	push   $0x46
  jmp alltraps
801068e1:	e9 4f f8 ff ff       	jmp    80106135 <alltraps>

801068e6 <vector71>:
.globl vector71
vector71:
  pushl $0
801068e6:	6a 00                	push   $0x0
  pushl $71
801068e8:	6a 47                	push   $0x47
  jmp alltraps
801068ea:	e9 46 f8 ff ff       	jmp    80106135 <alltraps>

801068ef <vector72>:
.globl vector72
vector72:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $72
801068f1:	6a 48                	push   $0x48
  jmp alltraps
801068f3:	e9 3d f8 ff ff       	jmp    80106135 <alltraps>

801068f8 <vector73>:
.globl vector73
vector73:
  pushl $0
801068f8:	6a 00                	push   $0x0
  pushl $73
801068fa:	6a 49                	push   $0x49
  jmp alltraps
801068fc:	e9 34 f8 ff ff       	jmp    80106135 <alltraps>

80106901 <vector74>:
.globl vector74
vector74:
  pushl $0
80106901:	6a 00                	push   $0x0
  pushl $74
80106903:	6a 4a                	push   $0x4a
  jmp alltraps
80106905:	e9 2b f8 ff ff       	jmp    80106135 <alltraps>

8010690a <vector75>:
.globl vector75
vector75:
  pushl $0
8010690a:	6a 00                	push   $0x0
  pushl $75
8010690c:	6a 4b                	push   $0x4b
  jmp alltraps
8010690e:	e9 22 f8 ff ff       	jmp    80106135 <alltraps>

80106913 <vector76>:
.globl vector76
vector76:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $76
80106915:	6a 4c                	push   $0x4c
  jmp alltraps
80106917:	e9 19 f8 ff ff       	jmp    80106135 <alltraps>

8010691c <vector77>:
.globl vector77
vector77:
  pushl $0
8010691c:	6a 00                	push   $0x0
  pushl $77
8010691e:	6a 4d                	push   $0x4d
  jmp alltraps
80106920:	e9 10 f8 ff ff       	jmp    80106135 <alltraps>

80106925 <vector78>:
.globl vector78
vector78:
  pushl $0
80106925:	6a 00                	push   $0x0
  pushl $78
80106927:	6a 4e                	push   $0x4e
  jmp alltraps
80106929:	e9 07 f8 ff ff       	jmp    80106135 <alltraps>

8010692e <vector79>:
.globl vector79
vector79:
  pushl $0
8010692e:	6a 00                	push   $0x0
  pushl $79
80106930:	6a 4f                	push   $0x4f
  jmp alltraps
80106932:	e9 fe f7 ff ff       	jmp    80106135 <alltraps>

80106937 <vector80>:
.globl vector80
vector80:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $80
80106939:	6a 50                	push   $0x50
  jmp alltraps
8010693b:	e9 f5 f7 ff ff       	jmp    80106135 <alltraps>

80106940 <vector81>:
.globl vector81
vector81:
  pushl $0
80106940:	6a 00                	push   $0x0
  pushl $81
80106942:	6a 51                	push   $0x51
  jmp alltraps
80106944:	e9 ec f7 ff ff       	jmp    80106135 <alltraps>

80106949 <vector82>:
.globl vector82
vector82:
  pushl $0
80106949:	6a 00                	push   $0x0
  pushl $82
8010694b:	6a 52                	push   $0x52
  jmp alltraps
8010694d:	e9 e3 f7 ff ff       	jmp    80106135 <alltraps>

80106952 <vector83>:
.globl vector83
vector83:
  pushl $0
80106952:	6a 00                	push   $0x0
  pushl $83
80106954:	6a 53                	push   $0x53
  jmp alltraps
80106956:	e9 da f7 ff ff       	jmp    80106135 <alltraps>

8010695b <vector84>:
.globl vector84
vector84:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $84
8010695d:	6a 54                	push   $0x54
  jmp alltraps
8010695f:	e9 d1 f7 ff ff       	jmp    80106135 <alltraps>

80106964 <vector85>:
.globl vector85
vector85:
  pushl $0
80106964:	6a 00                	push   $0x0
  pushl $85
80106966:	6a 55                	push   $0x55
  jmp alltraps
80106968:	e9 c8 f7 ff ff       	jmp    80106135 <alltraps>

8010696d <vector86>:
.globl vector86
vector86:
  pushl $0
8010696d:	6a 00                	push   $0x0
  pushl $86
8010696f:	6a 56                	push   $0x56
  jmp alltraps
80106971:	e9 bf f7 ff ff       	jmp    80106135 <alltraps>

80106976 <vector87>:
.globl vector87
vector87:
  pushl $0
80106976:	6a 00                	push   $0x0
  pushl $87
80106978:	6a 57                	push   $0x57
  jmp alltraps
8010697a:	e9 b6 f7 ff ff       	jmp    80106135 <alltraps>

8010697f <vector88>:
.globl vector88
vector88:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $88
80106981:	6a 58                	push   $0x58
  jmp alltraps
80106983:	e9 ad f7 ff ff       	jmp    80106135 <alltraps>

80106988 <vector89>:
.globl vector89
vector89:
  pushl $0
80106988:	6a 00                	push   $0x0
  pushl $89
8010698a:	6a 59                	push   $0x59
  jmp alltraps
8010698c:	e9 a4 f7 ff ff       	jmp    80106135 <alltraps>

80106991 <vector90>:
.globl vector90
vector90:
  pushl $0
80106991:	6a 00                	push   $0x0
  pushl $90
80106993:	6a 5a                	push   $0x5a
  jmp alltraps
80106995:	e9 9b f7 ff ff       	jmp    80106135 <alltraps>

8010699a <vector91>:
.globl vector91
vector91:
  pushl $0
8010699a:	6a 00                	push   $0x0
  pushl $91
8010699c:	6a 5b                	push   $0x5b
  jmp alltraps
8010699e:	e9 92 f7 ff ff       	jmp    80106135 <alltraps>

801069a3 <vector92>:
.globl vector92
vector92:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $92
801069a5:	6a 5c                	push   $0x5c
  jmp alltraps
801069a7:	e9 89 f7 ff ff       	jmp    80106135 <alltraps>

801069ac <vector93>:
.globl vector93
vector93:
  pushl $0
801069ac:	6a 00                	push   $0x0
  pushl $93
801069ae:	6a 5d                	push   $0x5d
  jmp alltraps
801069b0:	e9 80 f7 ff ff       	jmp    80106135 <alltraps>

801069b5 <vector94>:
.globl vector94
vector94:
  pushl $0
801069b5:	6a 00                	push   $0x0
  pushl $94
801069b7:	6a 5e                	push   $0x5e
  jmp alltraps
801069b9:	e9 77 f7 ff ff       	jmp    80106135 <alltraps>

801069be <vector95>:
.globl vector95
vector95:
  pushl $0
801069be:	6a 00                	push   $0x0
  pushl $95
801069c0:	6a 5f                	push   $0x5f
  jmp alltraps
801069c2:	e9 6e f7 ff ff       	jmp    80106135 <alltraps>

801069c7 <vector96>:
.globl vector96
vector96:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $96
801069c9:	6a 60                	push   $0x60
  jmp alltraps
801069cb:	e9 65 f7 ff ff       	jmp    80106135 <alltraps>

801069d0 <vector97>:
.globl vector97
vector97:
  pushl $0
801069d0:	6a 00                	push   $0x0
  pushl $97
801069d2:	6a 61                	push   $0x61
  jmp alltraps
801069d4:	e9 5c f7 ff ff       	jmp    80106135 <alltraps>

801069d9 <vector98>:
.globl vector98
vector98:
  pushl $0
801069d9:	6a 00                	push   $0x0
  pushl $98
801069db:	6a 62                	push   $0x62
  jmp alltraps
801069dd:	e9 53 f7 ff ff       	jmp    80106135 <alltraps>

801069e2 <vector99>:
.globl vector99
vector99:
  pushl $0
801069e2:	6a 00                	push   $0x0
  pushl $99
801069e4:	6a 63                	push   $0x63
  jmp alltraps
801069e6:	e9 4a f7 ff ff       	jmp    80106135 <alltraps>

801069eb <vector100>:
.globl vector100
vector100:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $100
801069ed:	6a 64                	push   $0x64
  jmp alltraps
801069ef:	e9 41 f7 ff ff       	jmp    80106135 <alltraps>

801069f4 <vector101>:
.globl vector101
vector101:
  pushl $0
801069f4:	6a 00                	push   $0x0
  pushl $101
801069f6:	6a 65                	push   $0x65
  jmp alltraps
801069f8:	e9 38 f7 ff ff       	jmp    80106135 <alltraps>

801069fd <vector102>:
.globl vector102
vector102:
  pushl $0
801069fd:	6a 00                	push   $0x0
  pushl $102
801069ff:	6a 66                	push   $0x66
  jmp alltraps
80106a01:	e9 2f f7 ff ff       	jmp    80106135 <alltraps>

80106a06 <vector103>:
.globl vector103
vector103:
  pushl $0
80106a06:	6a 00                	push   $0x0
  pushl $103
80106a08:	6a 67                	push   $0x67
  jmp alltraps
80106a0a:	e9 26 f7 ff ff       	jmp    80106135 <alltraps>

80106a0f <vector104>:
.globl vector104
vector104:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $104
80106a11:	6a 68                	push   $0x68
  jmp alltraps
80106a13:	e9 1d f7 ff ff       	jmp    80106135 <alltraps>

80106a18 <vector105>:
.globl vector105
vector105:
  pushl $0
80106a18:	6a 00                	push   $0x0
  pushl $105
80106a1a:	6a 69                	push   $0x69
  jmp alltraps
80106a1c:	e9 14 f7 ff ff       	jmp    80106135 <alltraps>

80106a21 <vector106>:
.globl vector106
vector106:
  pushl $0
80106a21:	6a 00                	push   $0x0
  pushl $106
80106a23:	6a 6a                	push   $0x6a
  jmp alltraps
80106a25:	e9 0b f7 ff ff       	jmp    80106135 <alltraps>

80106a2a <vector107>:
.globl vector107
vector107:
  pushl $0
80106a2a:	6a 00                	push   $0x0
  pushl $107
80106a2c:	6a 6b                	push   $0x6b
  jmp alltraps
80106a2e:	e9 02 f7 ff ff       	jmp    80106135 <alltraps>

80106a33 <vector108>:
.globl vector108
vector108:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $108
80106a35:	6a 6c                	push   $0x6c
  jmp alltraps
80106a37:	e9 f9 f6 ff ff       	jmp    80106135 <alltraps>

80106a3c <vector109>:
.globl vector109
vector109:
  pushl $0
80106a3c:	6a 00                	push   $0x0
  pushl $109
80106a3e:	6a 6d                	push   $0x6d
  jmp alltraps
80106a40:	e9 f0 f6 ff ff       	jmp    80106135 <alltraps>

80106a45 <vector110>:
.globl vector110
vector110:
  pushl $0
80106a45:	6a 00                	push   $0x0
  pushl $110
80106a47:	6a 6e                	push   $0x6e
  jmp alltraps
80106a49:	e9 e7 f6 ff ff       	jmp    80106135 <alltraps>

80106a4e <vector111>:
.globl vector111
vector111:
  pushl $0
80106a4e:	6a 00                	push   $0x0
  pushl $111
80106a50:	6a 6f                	push   $0x6f
  jmp alltraps
80106a52:	e9 de f6 ff ff       	jmp    80106135 <alltraps>

80106a57 <vector112>:
.globl vector112
vector112:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $112
80106a59:	6a 70                	push   $0x70
  jmp alltraps
80106a5b:	e9 d5 f6 ff ff       	jmp    80106135 <alltraps>

80106a60 <vector113>:
.globl vector113
vector113:
  pushl $0
80106a60:	6a 00                	push   $0x0
  pushl $113
80106a62:	6a 71                	push   $0x71
  jmp alltraps
80106a64:	e9 cc f6 ff ff       	jmp    80106135 <alltraps>

80106a69 <vector114>:
.globl vector114
vector114:
  pushl $0
80106a69:	6a 00                	push   $0x0
  pushl $114
80106a6b:	6a 72                	push   $0x72
  jmp alltraps
80106a6d:	e9 c3 f6 ff ff       	jmp    80106135 <alltraps>

80106a72 <vector115>:
.globl vector115
vector115:
  pushl $0
80106a72:	6a 00                	push   $0x0
  pushl $115
80106a74:	6a 73                	push   $0x73
  jmp alltraps
80106a76:	e9 ba f6 ff ff       	jmp    80106135 <alltraps>

80106a7b <vector116>:
.globl vector116
vector116:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $116
80106a7d:	6a 74                	push   $0x74
  jmp alltraps
80106a7f:	e9 b1 f6 ff ff       	jmp    80106135 <alltraps>

80106a84 <vector117>:
.globl vector117
vector117:
  pushl $0
80106a84:	6a 00                	push   $0x0
  pushl $117
80106a86:	6a 75                	push   $0x75
  jmp alltraps
80106a88:	e9 a8 f6 ff ff       	jmp    80106135 <alltraps>

80106a8d <vector118>:
.globl vector118
vector118:
  pushl $0
80106a8d:	6a 00                	push   $0x0
  pushl $118
80106a8f:	6a 76                	push   $0x76
  jmp alltraps
80106a91:	e9 9f f6 ff ff       	jmp    80106135 <alltraps>

80106a96 <vector119>:
.globl vector119
vector119:
  pushl $0
80106a96:	6a 00                	push   $0x0
  pushl $119
80106a98:	6a 77                	push   $0x77
  jmp alltraps
80106a9a:	e9 96 f6 ff ff       	jmp    80106135 <alltraps>

80106a9f <vector120>:
.globl vector120
vector120:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $120
80106aa1:	6a 78                	push   $0x78
  jmp alltraps
80106aa3:	e9 8d f6 ff ff       	jmp    80106135 <alltraps>

80106aa8 <vector121>:
.globl vector121
vector121:
  pushl $0
80106aa8:	6a 00                	push   $0x0
  pushl $121
80106aaa:	6a 79                	push   $0x79
  jmp alltraps
80106aac:	e9 84 f6 ff ff       	jmp    80106135 <alltraps>

80106ab1 <vector122>:
.globl vector122
vector122:
  pushl $0
80106ab1:	6a 00                	push   $0x0
  pushl $122
80106ab3:	6a 7a                	push   $0x7a
  jmp alltraps
80106ab5:	e9 7b f6 ff ff       	jmp    80106135 <alltraps>

80106aba <vector123>:
.globl vector123
vector123:
  pushl $0
80106aba:	6a 00                	push   $0x0
  pushl $123
80106abc:	6a 7b                	push   $0x7b
  jmp alltraps
80106abe:	e9 72 f6 ff ff       	jmp    80106135 <alltraps>

80106ac3 <vector124>:
.globl vector124
vector124:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $124
80106ac5:	6a 7c                	push   $0x7c
  jmp alltraps
80106ac7:	e9 69 f6 ff ff       	jmp    80106135 <alltraps>

80106acc <vector125>:
.globl vector125
vector125:
  pushl $0
80106acc:	6a 00                	push   $0x0
  pushl $125
80106ace:	6a 7d                	push   $0x7d
  jmp alltraps
80106ad0:	e9 60 f6 ff ff       	jmp    80106135 <alltraps>

80106ad5 <vector126>:
.globl vector126
vector126:
  pushl $0
80106ad5:	6a 00                	push   $0x0
  pushl $126
80106ad7:	6a 7e                	push   $0x7e
  jmp alltraps
80106ad9:	e9 57 f6 ff ff       	jmp    80106135 <alltraps>

80106ade <vector127>:
.globl vector127
vector127:
  pushl $0
80106ade:	6a 00                	push   $0x0
  pushl $127
80106ae0:	6a 7f                	push   $0x7f
  jmp alltraps
80106ae2:	e9 4e f6 ff ff       	jmp    80106135 <alltraps>

80106ae7 <vector128>:
.globl vector128
vector128:
  pushl $0
80106ae7:	6a 00                	push   $0x0
  pushl $128
80106ae9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106aee:	e9 42 f6 ff ff       	jmp    80106135 <alltraps>

80106af3 <vector129>:
.globl vector129
vector129:
  pushl $0
80106af3:	6a 00                	push   $0x0
  pushl $129
80106af5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106afa:	e9 36 f6 ff ff       	jmp    80106135 <alltraps>

80106aff <vector130>:
.globl vector130
vector130:
  pushl $0
80106aff:	6a 00                	push   $0x0
  pushl $130
80106b01:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106b06:	e9 2a f6 ff ff       	jmp    80106135 <alltraps>

80106b0b <vector131>:
.globl vector131
vector131:
  pushl $0
80106b0b:	6a 00                	push   $0x0
  pushl $131
80106b0d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106b12:	e9 1e f6 ff ff       	jmp    80106135 <alltraps>

80106b17 <vector132>:
.globl vector132
vector132:
  pushl $0
80106b17:	6a 00                	push   $0x0
  pushl $132
80106b19:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106b1e:	e9 12 f6 ff ff       	jmp    80106135 <alltraps>

80106b23 <vector133>:
.globl vector133
vector133:
  pushl $0
80106b23:	6a 00                	push   $0x0
  pushl $133
80106b25:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106b2a:	e9 06 f6 ff ff       	jmp    80106135 <alltraps>

80106b2f <vector134>:
.globl vector134
vector134:
  pushl $0
80106b2f:	6a 00                	push   $0x0
  pushl $134
80106b31:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106b36:	e9 fa f5 ff ff       	jmp    80106135 <alltraps>

80106b3b <vector135>:
.globl vector135
vector135:
  pushl $0
80106b3b:	6a 00                	push   $0x0
  pushl $135
80106b3d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106b42:	e9 ee f5 ff ff       	jmp    80106135 <alltraps>

80106b47 <vector136>:
.globl vector136
vector136:
  pushl $0
80106b47:	6a 00                	push   $0x0
  pushl $136
80106b49:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106b4e:	e9 e2 f5 ff ff       	jmp    80106135 <alltraps>

80106b53 <vector137>:
.globl vector137
vector137:
  pushl $0
80106b53:	6a 00                	push   $0x0
  pushl $137
80106b55:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106b5a:	e9 d6 f5 ff ff       	jmp    80106135 <alltraps>

80106b5f <vector138>:
.globl vector138
vector138:
  pushl $0
80106b5f:	6a 00                	push   $0x0
  pushl $138
80106b61:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106b66:	e9 ca f5 ff ff       	jmp    80106135 <alltraps>

80106b6b <vector139>:
.globl vector139
vector139:
  pushl $0
80106b6b:	6a 00                	push   $0x0
  pushl $139
80106b6d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106b72:	e9 be f5 ff ff       	jmp    80106135 <alltraps>

80106b77 <vector140>:
.globl vector140
vector140:
  pushl $0
80106b77:	6a 00                	push   $0x0
  pushl $140
80106b79:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106b7e:	e9 b2 f5 ff ff       	jmp    80106135 <alltraps>

80106b83 <vector141>:
.globl vector141
vector141:
  pushl $0
80106b83:	6a 00                	push   $0x0
  pushl $141
80106b85:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106b8a:	e9 a6 f5 ff ff       	jmp    80106135 <alltraps>

80106b8f <vector142>:
.globl vector142
vector142:
  pushl $0
80106b8f:	6a 00                	push   $0x0
  pushl $142
80106b91:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106b96:	e9 9a f5 ff ff       	jmp    80106135 <alltraps>

80106b9b <vector143>:
.globl vector143
vector143:
  pushl $0
80106b9b:	6a 00                	push   $0x0
  pushl $143
80106b9d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106ba2:	e9 8e f5 ff ff       	jmp    80106135 <alltraps>

80106ba7 <vector144>:
.globl vector144
vector144:
  pushl $0
80106ba7:	6a 00                	push   $0x0
  pushl $144
80106ba9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106bae:	e9 82 f5 ff ff       	jmp    80106135 <alltraps>

80106bb3 <vector145>:
.globl vector145
vector145:
  pushl $0
80106bb3:	6a 00                	push   $0x0
  pushl $145
80106bb5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106bba:	e9 76 f5 ff ff       	jmp    80106135 <alltraps>

80106bbf <vector146>:
.globl vector146
vector146:
  pushl $0
80106bbf:	6a 00                	push   $0x0
  pushl $146
80106bc1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106bc6:	e9 6a f5 ff ff       	jmp    80106135 <alltraps>

80106bcb <vector147>:
.globl vector147
vector147:
  pushl $0
80106bcb:	6a 00                	push   $0x0
  pushl $147
80106bcd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106bd2:	e9 5e f5 ff ff       	jmp    80106135 <alltraps>

80106bd7 <vector148>:
.globl vector148
vector148:
  pushl $0
80106bd7:	6a 00                	push   $0x0
  pushl $148
80106bd9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106bde:	e9 52 f5 ff ff       	jmp    80106135 <alltraps>

80106be3 <vector149>:
.globl vector149
vector149:
  pushl $0
80106be3:	6a 00                	push   $0x0
  pushl $149
80106be5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106bea:	e9 46 f5 ff ff       	jmp    80106135 <alltraps>

80106bef <vector150>:
.globl vector150
vector150:
  pushl $0
80106bef:	6a 00                	push   $0x0
  pushl $150
80106bf1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106bf6:	e9 3a f5 ff ff       	jmp    80106135 <alltraps>

80106bfb <vector151>:
.globl vector151
vector151:
  pushl $0
80106bfb:	6a 00                	push   $0x0
  pushl $151
80106bfd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106c02:	e9 2e f5 ff ff       	jmp    80106135 <alltraps>

80106c07 <vector152>:
.globl vector152
vector152:
  pushl $0
80106c07:	6a 00                	push   $0x0
  pushl $152
80106c09:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106c0e:	e9 22 f5 ff ff       	jmp    80106135 <alltraps>

80106c13 <vector153>:
.globl vector153
vector153:
  pushl $0
80106c13:	6a 00                	push   $0x0
  pushl $153
80106c15:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106c1a:	e9 16 f5 ff ff       	jmp    80106135 <alltraps>

80106c1f <vector154>:
.globl vector154
vector154:
  pushl $0
80106c1f:	6a 00                	push   $0x0
  pushl $154
80106c21:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106c26:	e9 0a f5 ff ff       	jmp    80106135 <alltraps>

80106c2b <vector155>:
.globl vector155
vector155:
  pushl $0
80106c2b:	6a 00                	push   $0x0
  pushl $155
80106c2d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106c32:	e9 fe f4 ff ff       	jmp    80106135 <alltraps>

80106c37 <vector156>:
.globl vector156
vector156:
  pushl $0
80106c37:	6a 00                	push   $0x0
  pushl $156
80106c39:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106c3e:	e9 f2 f4 ff ff       	jmp    80106135 <alltraps>

80106c43 <vector157>:
.globl vector157
vector157:
  pushl $0
80106c43:	6a 00                	push   $0x0
  pushl $157
80106c45:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106c4a:	e9 e6 f4 ff ff       	jmp    80106135 <alltraps>

80106c4f <vector158>:
.globl vector158
vector158:
  pushl $0
80106c4f:	6a 00                	push   $0x0
  pushl $158
80106c51:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106c56:	e9 da f4 ff ff       	jmp    80106135 <alltraps>

80106c5b <vector159>:
.globl vector159
vector159:
  pushl $0
80106c5b:	6a 00                	push   $0x0
  pushl $159
80106c5d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106c62:	e9 ce f4 ff ff       	jmp    80106135 <alltraps>

80106c67 <vector160>:
.globl vector160
vector160:
  pushl $0
80106c67:	6a 00                	push   $0x0
  pushl $160
80106c69:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106c6e:	e9 c2 f4 ff ff       	jmp    80106135 <alltraps>

80106c73 <vector161>:
.globl vector161
vector161:
  pushl $0
80106c73:	6a 00                	push   $0x0
  pushl $161
80106c75:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106c7a:	e9 b6 f4 ff ff       	jmp    80106135 <alltraps>

80106c7f <vector162>:
.globl vector162
vector162:
  pushl $0
80106c7f:	6a 00                	push   $0x0
  pushl $162
80106c81:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106c86:	e9 aa f4 ff ff       	jmp    80106135 <alltraps>

80106c8b <vector163>:
.globl vector163
vector163:
  pushl $0
80106c8b:	6a 00                	push   $0x0
  pushl $163
80106c8d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106c92:	e9 9e f4 ff ff       	jmp    80106135 <alltraps>

80106c97 <vector164>:
.globl vector164
vector164:
  pushl $0
80106c97:	6a 00                	push   $0x0
  pushl $164
80106c99:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106c9e:	e9 92 f4 ff ff       	jmp    80106135 <alltraps>

80106ca3 <vector165>:
.globl vector165
vector165:
  pushl $0
80106ca3:	6a 00                	push   $0x0
  pushl $165
80106ca5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106caa:	e9 86 f4 ff ff       	jmp    80106135 <alltraps>

80106caf <vector166>:
.globl vector166
vector166:
  pushl $0
80106caf:	6a 00                	push   $0x0
  pushl $166
80106cb1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106cb6:	e9 7a f4 ff ff       	jmp    80106135 <alltraps>

80106cbb <vector167>:
.globl vector167
vector167:
  pushl $0
80106cbb:	6a 00                	push   $0x0
  pushl $167
80106cbd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106cc2:	e9 6e f4 ff ff       	jmp    80106135 <alltraps>

80106cc7 <vector168>:
.globl vector168
vector168:
  pushl $0
80106cc7:	6a 00                	push   $0x0
  pushl $168
80106cc9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106cce:	e9 62 f4 ff ff       	jmp    80106135 <alltraps>

80106cd3 <vector169>:
.globl vector169
vector169:
  pushl $0
80106cd3:	6a 00                	push   $0x0
  pushl $169
80106cd5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106cda:	e9 56 f4 ff ff       	jmp    80106135 <alltraps>

80106cdf <vector170>:
.globl vector170
vector170:
  pushl $0
80106cdf:	6a 00                	push   $0x0
  pushl $170
80106ce1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106ce6:	e9 4a f4 ff ff       	jmp    80106135 <alltraps>

80106ceb <vector171>:
.globl vector171
vector171:
  pushl $0
80106ceb:	6a 00                	push   $0x0
  pushl $171
80106ced:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106cf2:	e9 3e f4 ff ff       	jmp    80106135 <alltraps>

80106cf7 <vector172>:
.globl vector172
vector172:
  pushl $0
80106cf7:	6a 00                	push   $0x0
  pushl $172
80106cf9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106cfe:	e9 32 f4 ff ff       	jmp    80106135 <alltraps>

80106d03 <vector173>:
.globl vector173
vector173:
  pushl $0
80106d03:	6a 00                	push   $0x0
  pushl $173
80106d05:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106d0a:	e9 26 f4 ff ff       	jmp    80106135 <alltraps>

80106d0f <vector174>:
.globl vector174
vector174:
  pushl $0
80106d0f:	6a 00                	push   $0x0
  pushl $174
80106d11:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106d16:	e9 1a f4 ff ff       	jmp    80106135 <alltraps>

80106d1b <vector175>:
.globl vector175
vector175:
  pushl $0
80106d1b:	6a 00                	push   $0x0
  pushl $175
80106d1d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106d22:	e9 0e f4 ff ff       	jmp    80106135 <alltraps>

80106d27 <vector176>:
.globl vector176
vector176:
  pushl $0
80106d27:	6a 00                	push   $0x0
  pushl $176
80106d29:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106d2e:	e9 02 f4 ff ff       	jmp    80106135 <alltraps>

80106d33 <vector177>:
.globl vector177
vector177:
  pushl $0
80106d33:	6a 00                	push   $0x0
  pushl $177
80106d35:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106d3a:	e9 f6 f3 ff ff       	jmp    80106135 <alltraps>

80106d3f <vector178>:
.globl vector178
vector178:
  pushl $0
80106d3f:	6a 00                	push   $0x0
  pushl $178
80106d41:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106d46:	e9 ea f3 ff ff       	jmp    80106135 <alltraps>

80106d4b <vector179>:
.globl vector179
vector179:
  pushl $0
80106d4b:	6a 00                	push   $0x0
  pushl $179
80106d4d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106d52:	e9 de f3 ff ff       	jmp    80106135 <alltraps>

80106d57 <vector180>:
.globl vector180
vector180:
  pushl $0
80106d57:	6a 00                	push   $0x0
  pushl $180
80106d59:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106d5e:	e9 d2 f3 ff ff       	jmp    80106135 <alltraps>

80106d63 <vector181>:
.globl vector181
vector181:
  pushl $0
80106d63:	6a 00                	push   $0x0
  pushl $181
80106d65:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106d6a:	e9 c6 f3 ff ff       	jmp    80106135 <alltraps>

80106d6f <vector182>:
.globl vector182
vector182:
  pushl $0
80106d6f:	6a 00                	push   $0x0
  pushl $182
80106d71:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106d76:	e9 ba f3 ff ff       	jmp    80106135 <alltraps>

80106d7b <vector183>:
.globl vector183
vector183:
  pushl $0
80106d7b:	6a 00                	push   $0x0
  pushl $183
80106d7d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106d82:	e9 ae f3 ff ff       	jmp    80106135 <alltraps>

80106d87 <vector184>:
.globl vector184
vector184:
  pushl $0
80106d87:	6a 00                	push   $0x0
  pushl $184
80106d89:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106d8e:	e9 a2 f3 ff ff       	jmp    80106135 <alltraps>

80106d93 <vector185>:
.globl vector185
vector185:
  pushl $0
80106d93:	6a 00                	push   $0x0
  pushl $185
80106d95:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106d9a:	e9 96 f3 ff ff       	jmp    80106135 <alltraps>

80106d9f <vector186>:
.globl vector186
vector186:
  pushl $0
80106d9f:	6a 00                	push   $0x0
  pushl $186
80106da1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106da6:	e9 8a f3 ff ff       	jmp    80106135 <alltraps>

80106dab <vector187>:
.globl vector187
vector187:
  pushl $0
80106dab:	6a 00                	push   $0x0
  pushl $187
80106dad:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106db2:	e9 7e f3 ff ff       	jmp    80106135 <alltraps>

80106db7 <vector188>:
.globl vector188
vector188:
  pushl $0
80106db7:	6a 00                	push   $0x0
  pushl $188
80106db9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106dbe:	e9 72 f3 ff ff       	jmp    80106135 <alltraps>

80106dc3 <vector189>:
.globl vector189
vector189:
  pushl $0
80106dc3:	6a 00                	push   $0x0
  pushl $189
80106dc5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106dca:	e9 66 f3 ff ff       	jmp    80106135 <alltraps>

80106dcf <vector190>:
.globl vector190
vector190:
  pushl $0
80106dcf:	6a 00                	push   $0x0
  pushl $190
80106dd1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106dd6:	e9 5a f3 ff ff       	jmp    80106135 <alltraps>

80106ddb <vector191>:
.globl vector191
vector191:
  pushl $0
80106ddb:	6a 00                	push   $0x0
  pushl $191
80106ddd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106de2:	e9 4e f3 ff ff       	jmp    80106135 <alltraps>

80106de7 <vector192>:
.globl vector192
vector192:
  pushl $0
80106de7:	6a 00                	push   $0x0
  pushl $192
80106de9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106dee:	e9 42 f3 ff ff       	jmp    80106135 <alltraps>

80106df3 <vector193>:
.globl vector193
vector193:
  pushl $0
80106df3:	6a 00                	push   $0x0
  pushl $193
80106df5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106dfa:	e9 36 f3 ff ff       	jmp    80106135 <alltraps>

80106dff <vector194>:
.globl vector194
vector194:
  pushl $0
80106dff:	6a 00                	push   $0x0
  pushl $194
80106e01:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106e06:	e9 2a f3 ff ff       	jmp    80106135 <alltraps>

80106e0b <vector195>:
.globl vector195
vector195:
  pushl $0
80106e0b:	6a 00                	push   $0x0
  pushl $195
80106e0d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106e12:	e9 1e f3 ff ff       	jmp    80106135 <alltraps>

80106e17 <vector196>:
.globl vector196
vector196:
  pushl $0
80106e17:	6a 00                	push   $0x0
  pushl $196
80106e19:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106e1e:	e9 12 f3 ff ff       	jmp    80106135 <alltraps>

80106e23 <vector197>:
.globl vector197
vector197:
  pushl $0
80106e23:	6a 00                	push   $0x0
  pushl $197
80106e25:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106e2a:	e9 06 f3 ff ff       	jmp    80106135 <alltraps>

80106e2f <vector198>:
.globl vector198
vector198:
  pushl $0
80106e2f:	6a 00                	push   $0x0
  pushl $198
80106e31:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106e36:	e9 fa f2 ff ff       	jmp    80106135 <alltraps>

80106e3b <vector199>:
.globl vector199
vector199:
  pushl $0
80106e3b:	6a 00                	push   $0x0
  pushl $199
80106e3d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106e42:	e9 ee f2 ff ff       	jmp    80106135 <alltraps>

80106e47 <vector200>:
.globl vector200
vector200:
  pushl $0
80106e47:	6a 00                	push   $0x0
  pushl $200
80106e49:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106e4e:	e9 e2 f2 ff ff       	jmp    80106135 <alltraps>

80106e53 <vector201>:
.globl vector201
vector201:
  pushl $0
80106e53:	6a 00                	push   $0x0
  pushl $201
80106e55:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106e5a:	e9 d6 f2 ff ff       	jmp    80106135 <alltraps>

80106e5f <vector202>:
.globl vector202
vector202:
  pushl $0
80106e5f:	6a 00                	push   $0x0
  pushl $202
80106e61:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106e66:	e9 ca f2 ff ff       	jmp    80106135 <alltraps>

80106e6b <vector203>:
.globl vector203
vector203:
  pushl $0
80106e6b:	6a 00                	push   $0x0
  pushl $203
80106e6d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106e72:	e9 be f2 ff ff       	jmp    80106135 <alltraps>

80106e77 <vector204>:
.globl vector204
vector204:
  pushl $0
80106e77:	6a 00                	push   $0x0
  pushl $204
80106e79:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106e7e:	e9 b2 f2 ff ff       	jmp    80106135 <alltraps>

80106e83 <vector205>:
.globl vector205
vector205:
  pushl $0
80106e83:	6a 00                	push   $0x0
  pushl $205
80106e85:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106e8a:	e9 a6 f2 ff ff       	jmp    80106135 <alltraps>

80106e8f <vector206>:
.globl vector206
vector206:
  pushl $0
80106e8f:	6a 00                	push   $0x0
  pushl $206
80106e91:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106e96:	e9 9a f2 ff ff       	jmp    80106135 <alltraps>

80106e9b <vector207>:
.globl vector207
vector207:
  pushl $0
80106e9b:	6a 00                	push   $0x0
  pushl $207
80106e9d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106ea2:	e9 8e f2 ff ff       	jmp    80106135 <alltraps>

80106ea7 <vector208>:
.globl vector208
vector208:
  pushl $0
80106ea7:	6a 00                	push   $0x0
  pushl $208
80106ea9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106eae:	e9 82 f2 ff ff       	jmp    80106135 <alltraps>

80106eb3 <vector209>:
.globl vector209
vector209:
  pushl $0
80106eb3:	6a 00                	push   $0x0
  pushl $209
80106eb5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106eba:	e9 76 f2 ff ff       	jmp    80106135 <alltraps>

80106ebf <vector210>:
.globl vector210
vector210:
  pushl $0
80106ebf:	6a 00                	push   $0x0
  pushl $210
80106ec1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106ec6:	e9 6a f2 ff ff       	jmp    80106135 <alltraps>

80106ecb <vector211>:
.globl vector211
vector211:
  pushl $0
80106ecb:	6a 00                	push   $0x0
  pushl $211
80106ecd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106ed2:	e9 5e f2 ff ff       	jmp    80106135 <alltraps>

80106ed7 <vector212>:
.globl vector212
vector212:
  pushl $0
80106ed7:	6a 00                	push   $0x0
  pushl $212
80106ed9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106ede:	e9 52 f2 ff ff       	jmp    80106135 <alltraps>

80106ee3 <vector213>:
.globl vector213
vector213:
  pushl $0
80106ee3:	6a 00                	push   $0x0
  pushl $213
80106ee5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106eea:	e9 46 f2 ff ff       	jmp    80106135 <alltraps>

80106eef <vector214>:
.globl vector214
vector214:
  pushl $0
80106eef:	6a 00                	push   $0x0
  pushl $214
80106ef1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106ef6:	e9 3a f2 ff ff       	jmp    80106135 <alltraps>

80106efb <vector215>:
.globl vector215
vector215:
  pushl $0
80106efb:	6a 00                	push   $0x0
  pushl $215
80106efd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106f02:	e9 2e f2 ff ff       	jmp    80106135 <alltraps>

80106f07 <vector216>:
.globl vector216
vector216:
  pushl $0
80106f07:	6a 00                	push   $0x0
  pushl $216
80106f09:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106f0e:	e9 22 f2 ff ff       	jmp    80106135 <alltraps>

80106f13 <vector217>:
.globl vector217
vector217:
  pushl $0
80106f13:	6a 00                	push   $0x0
  pushl $217
80106f15:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106f1a:	e9 16 f2 ff ff       	jmp    80106135 <alltraps>

80106f1f <vector218>:
.globl vector218
vector218:
  pushl $0
80106f1f:	6a 00                	push   $0x0
  pushl $218
80106f21:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106f26:	e9 0a f2 ff ff       	jmp    80106135 <alltraps>

80106f2b <vector219>:
.globl vector219
vector219:
  pushl $0
80106f2b:	6a 00                	push   $0x0
  pushl $219
80106f2d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106f32:	e9 fe f1 ff ff       	jmp    80106135 <alltraps>

80106f37 <vector220>:
.globl vector220
vector220:
  pushl $0
80106f37:	6a 00                	push   $0x0
  pushl $220
80106f39:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106f3e:	e9 f2 f1 ff ff       	jmp    80106135 <alltraps>

80106f43 <vector221>:
.globl vector221
vector221:
  pushl $0
80106f43:	6a 00                	push   $0x0
  pushl $221
80106f45:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106f4a:	e9 e6 f1 ff ff       	jmp    80106135 <alltraps>

80106f4f <vector222>:
.globl vector222
vector222:
  pushl $0
80106f4f:	6a 00                	push   $0x0
  pushl $222
80106f51:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106f56:	e9 da f1 ff ff       	jmp    80106135 <alltraps>

80106f5b <vector223>:
.globl vector223
vector223:
  pushl $0
80106f5b:	6a 00                	push   $0x0
  pushl $223
80106f5d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106f62:	e9 ce f1 ff ff       	jmp    80106135 <alltraps>

80106f67 <vector224>:
.globl vector224
vector224:
  pushl $0
80106f67:	6a 00                	push   $0x0
  pushl $224
80106f69:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106f6e:	e9 c2 f1 ff ff       	jmp    80106135 <alltraps>

80106f73 <vector225>:
.globl vector225
vector225:
  pushl $0
80106f73:	6a 00                	push   $0x0
  pushl $225
80106f75:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106f7a:	e9 b6 f1 ff ff       	jmp    80106135 <alltraps>

80106f7f <vector226>:
.globl vector226
vector226:
  pushl $0
80106f7f:	6a 00                	push   $0x0
  pushl $226
80106f81:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106f86:	e9 aa f1 ff ff       	jmp    80106135 <alltraps>

80106f8b <vector227>:
.globl vector227
vector227:
  pushl $0
80106f8b:	6a 00                	push   $0x0
  pushl $227
80106f8d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106f92:	e9 9e f1 ff ff       	jmp    80106135 <alltraps>

80106f97 <vector228>:
.globl vector228
vector228:
  pushl $0
80106f97:	6a 00                	push   $0x0
  pushl $228
80106f99:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106f9e:	e9 92 f1 ff ff       	jmp    80106135 <alltraps>

80106fa3 <vector229>:
.globl vector229
vector229:
  pushl $0
80106fa3:	6a 00                	push   $0x0
  pushl $229
80106fa5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106faa:	e9 86 f1 ff ff       	jmp    80106135 <alltraps>

80106faf <vector230>:
.globl vector230
vector230:
  pushl $0
80106faf:	6a 00                	push   $0x0
  pushl $230
80106fb1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106fb6:	e9 7a f1 ff ff       	jmp    80106135 <alltraps>

80106fbb <vector231>:
.globl vector231
vector231:
  pushl $0
80106fbb:	6a 00                	push   $0x0
  pushl $231
80106fbd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106fc2:	e9 6e f1 ff ff       	jmp    80106135 <alltraps>

80106fc7 <vector232>:
.globl vector232
vector232:
  pushl $0
80106fc7:	6a 00                	push   $0x0
  pushl $232
80106fc9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106fce:	e9 62 f1 ff ff       	jmp    80106135 <alltraps>

80106fd3 <vector233>:
.globl vector233
vector233:
  pushl $0
80106fd3:	6a 00                	push   $0x0
  pushl $233
80106fd5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106fda:	e9 56 f1 ff ff       	jmp    80106135 <alltraps>

80106fdf <vector234>:
.globl vector234
vector234:
  pushl $0
80106fdf:	6a 00                	push   $0x0
  pushl $234
80106fe1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106fe6:	e9 4a f1 ff ff       	jmp    80106135 <alltraps>

80106feb <vector235>:
.globl vector235
vector235:
  pushl $0
80106feb:	6a 00                	push   $0x0
  pushl $235
80106fed:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106ff2:	e9 3e f1 ff ff       	jmp    80106135 <alltraps>

80106ff7 <vector236>:
.globl vector236
vector236:
  pushl $0
80106ff7:	6a 00                	push   $0x0
  pushl $236
80106ff9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106ffe:	e9 32 f1 ff ff       	jmp    80106135 <alltraps>

80107003 <vector237>:
.globl vector237
vector237:
  pushl $0
80107003:	6a 00                	push   $0x0
  pushl $237
80107005:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010700a:	e9 26 f1 ff ff       	jmp    80106135 <alltraps>

8010700f <vector238>:
.globl vector238
vector238:
  pushl $0
8010700f:	6a 00                	push   $0x0
  pushl $238
80107011:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107016:	e9 1a f1 ff ff       	jmp    80106135 <alltraps>

8010701b <vector239>:
.globl vector239
vector239:
  pushl $0
8010701b:	6a 00                	push   $0x0
  pushl $239
8010701d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107022:	e9 0e f1 ff ff       	jmp    80106135 <alltraps>

80107027 <vector240>:
.globl vector240
vector240:
  pushl $0
80107027:	6a 00                	push   $0x0
  pushl $240
80107029:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010702e:	e9 02 f1 ff ff       	jmp    80106135 <alltraps>

80107033 <vector241>:
.globl vector241
vector241:
  pushl $0
80107033:	6a 00                	push   $0x0
  pushl $241
80107035:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010703a:	e9 f6 f0 ff ff       	jmp    80106135 <alltraps>

8010703f <vector242>:
.globl vector242
vector242:
  pushl $0
8010703f:	6a 00                	push   $0x0
  pushl $242
80107041:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107046:	e9 ea f0 ff ff       	jmp    80106135 <alltraps>

8010704b <vector243>:
.globl vector243
vector243:
  pushl $0
8010704b:	6a 00                	push   $0x0
  pushl $243
8010704d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107052:	e9 de f0 ff ff       	jmp    80106135 <alltraps>

80107057 <vector244>:
.globl vector244
vector244:
  pushl $0
80107057:	6a 00                	push   $0x0
  pushl $244
80107059:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010705e:	e9 d2 f0 ff ff       	jmp    80106135 <alltraps>

80107063 <vector245>:
.globl vector245
vector245:
  pushl $0
80107063:	6a 00                	push   $0x0
  pushl $245
80107065:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010706a:	e9 c6 f0 ff ff       	jmp    80106135 <alltraps>

8010706f <vector246>:
.globl vector246
vector246:
  pushl $0
8010706f:	6a 00                	push   $0x0
  pushl $246
80107071:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107076:	e9 ba f0 ff ff       	jmp    80106135 <alltraps>

8010707b <vector247>:
.globl vector247
vector247:
  pushl $0
8010707b:	6a 00                	push   $0x0
  pushl $247
8010707d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107082:	e9 ae f0 ff ff       	jmp    80106135 <alltraps>

80107087 <vector248>:
.globl vector248
vector248:
  pushl $0
80107087:	6a 00                	push   $0x0
  pushl $248
80107089:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010708e:	e9 a2 f0 ff ff       	jmp    80106135 <alltraps>

80107093 <vector249>:
.globl vector249
vector249:
  pushl $0
80107093:	6a 00                	push   $0x0
  pushl $249
80107095:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010709a:	e9 96 f0 ff ff       	jmp    80106135 <alltraps>

8010709f <vector250>:
.globl vector250
vector250:
  pushl $0
8010709f:	6a 00                	push   $0x0
  pushl $250
801070a1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801070a6:	e9 8a f0 ff ff       	jmp    80106135 <alltraps>

801070ab <vector251>:
.globl vector251
vector251:
  pushl $0
801070ab:	6a 00                	push   $0x0
  pushl $251
801070ad:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801070b2:	e9 7e f0 ff ff       	jmp    80106135 <alltraps>

801070b7 <vector252>:
.globl vector252
vector252:
  pushl $0
801070b7:	6a 00                	push   $0x0
  pushl $252
801070b9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801070be:	e9 72 f0 ff ff       	jmp    80106135 <alltraps>

801070c3 <vector253>:
.globl vector253
vector253:
  pushl $0
801070c3:	6a 00                	push   $0x0
  pushl $253
801070c5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801070ca:	e9 66 f0 ff ff       	jmp    80106135 <alltraps>

801070cf <vector254>:
.globl vector254
vector254:
  pushl $0
801070cf:	6a 00                	push   $0x0
  pushl $254
801070d1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801070d6:	e9 5a f0 ff ff       	jmp    80106135 <alltraps>

801070db <vector255>:
.globl vector255
vector255:
  pushl $0
801070db:	6a 00                	push   $0x0
  pushl $255
801070dd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801070e2:	e9 4e f0 ff ff       	jmp    80106135 <alltraps>
801070e7:	66 90                	xchg   %ax,%ax
801070e9:	66 90                	xchg   %ax,%ax
801070eb:	66 90                	xchg   %ax,%ax
801070ed:	66 90                	xchg   %ax,%ax
801070ef:	90                   	nop

801070f0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801070f0:	55                   	push   %ebp
801070f1:	89 e5                	mov    %esp,%ebp
801070f3:	57                   	push   %edi
801070f4:	56                   	push   %esi
801070f5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801070f6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
801070fc:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107102:	83 ec 1c             	sub    $0x1c,%esp
80107105:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107108:	39 d3                	cmp    %edx,%ebx
8010710a:	73 49                	jae    80107155 <deallocuvm.part.0+0x65>
8010710c:	89 c7                	mov    %eax,%edi
8010710e:	eb 0c                	jmp    8010711c <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107110:	83 c0 01             	add    $0x1,%eax
80107113:	c1 e0 16             	shl    $0x16,%eax
80107116:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80107118:	39 da                	cmp    %ebx,%edx
8010711a:	76 39                	jbe    80107155 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
8010711c:	89 d8                	mov    %ebx,%eax
8010711e:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107121:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80107124:	f6 c1 01             	test   $0x1,%cl
80107127:	74 e7                	je     80107110 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80107129:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010712b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107131:	c1 ee 0a             	shr    $0xa,%esi
80107134:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
8010713a:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80107141:	85 f6                	test   %esi,%esi
80107143:	74 cb                	je     80107110 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80107145:	8b 06                	mov    (%esi),%eax
80107147:	a8 01                	test   $0x1,%al
80107149:	75 15                	jne    80107160 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
8010714b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107151:	39 da                	cmp    %ebx,%edx
80107153:	77 c7                	ja     8010711c <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80107155:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107158:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010715b:	5b                   	pop    %ebx
8010715c:	5e                   	pop    %esi
8010715d:	5f                   	pop    %edi
8010715e:	5d                   	pop    %ebp
8010715f:	c3                   	ret    
      if(pa == 0)
80107160:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107165:	74 25                	je     8010718c <deallocuvm.part.0+0x9c>
      kfree(v);
80107167:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010716a:	05 00 00 00 80       	add    $0x80000000,%eax
8010716f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107172:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80107178:	50                   	push   %eax
80107179:	e8 42 b3 ff ff       	call   801024c0 <kfree>
      *pte = 0;
8010717e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80107184:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107187:	83 c4 10             	add    $0x10,%esp
8010718a:	eb 8c                	jmp    80107118 <deallocuvm.part.0+0x28>
        panic("kfree");
8010718c:	83 ec 0c             	sub    $0xc,%esp
8010718f:	68 46 7d 10 80       	push   $0x80107d46
80107194:	e8 e7 91 ff ff       	call   80100380 <panic>
80107199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801071a0 <mappages>:
{
801071a0:	55                   	push   %ebp
801071a1:	89 e5                	mov    %esp,%ebp
801071a3:	57                   	push   %edi
801071a4:	56                   	push   %esi
801071a5:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
801071a6:	89 d3                	mov    %edx,%ebx
801071a8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
801071ae:	83 ec 1c             	sub    $0x1c,%esp
801071b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801071b4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801071b8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801071bd:	89 45 dc             	mov    %eax,-0x24(%ebp)
801071c0:	8b 45 08             	mov    0x8(%ebp),%eax
801071c3:	29 d8                	sub    %ebx,%eax
801071c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801071c8:	eb 3d                	jmp    80107207 <mappages+0x67>
801071ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801071d0:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801071d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801071d7:	c1 ea 0a             	shr    $0xa,%edx
801071da:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801071e0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801071e7:	85 c0                	test   %eax,%eax
801071e9:	74 75                	je     80107260 <mappages+0xc0>
    if(*pte & PTE_P)
801071eb:	f6 00 01             	testb  $0x1,(%eax)
801071ee:	0f 85 86 00 00 00    	jne    8010727a <mappages+0xda>
    *pte = pa | perm | PTE_P;
801071f4:	0b 75 0c             	or     0xc(%ebp),%esi
801071f7:	83 ce 01             	or     $0x1,%esi
801071fa:	89 30                	mov    %esi,(%eax)
    if(a == last)
801071fc:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
801071ff:	74 6f                	je     80107270 <mappages+0xd0>
    a += PGSIZE;
80107201:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80107207:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
8010720a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010720d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80107210:	89 d8                	mov    %ebx,%eax
80107212:	c1 e8 16             	shr    $0x16,%eax
80107215:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80107218:	8b 07                	mov    (%edi),%eax
8010721a:	a8 01                	test   $0x1,%al
8010721c:	75 b2                	jne    801071d0 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
8010721e:	e8 5d b4 ff ff       	call   80102680 <kalloc>
80107223:	85 c0                	test   %eax,%eax
80107225:	74 39                	je     80107260 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80107227:	83 ec 04             	sub    $0x4,%esp
8010722a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010722d:	68 00 10 00 00       	push   $0x1000
80107232:	6a 00                	push   $0x0
80107234:	50                   	push   %eax
80107235:	e8 c6 dc ff ff       	call   80104f00 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010723a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
8010723d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107240:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80107246:	83 c8 07             	or     $0x7,%eax
80107249:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
8010724b:	89 d8                	mov    %ebx,%eax
8010724d:	c1 e8 0a             	shr    $0xa,%eax
80107250:	25 fc 0f 00 00       	and    $0xffc,%eax
80107255:	01 d0                	add    %edx,%eax
80107257:	eb 92                	jmp    801071eb <mappages+0x4b>
80107259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80107260:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107263:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107268:	5b                   	pop    %ebx
80107269:	5e                   	pop    %esi
8010726a:	5f                   	pop    %edi
8010726b:	5d                   	pop    %ebp
8010726c:	c3                   	ret    
8010726d:	8d 76 00             	lea    0x0(%esi),%esi
80107270:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107273:	31 c0                	xor    %eax,%eax
}
80107275:	5b                   	pop    %ebx
80107276:	5e                   	pop    %esi
80107277:	5f                   	pop    %edi
80107278:	5d                   	pop    %ebp
80107279:	c3                   	ret    
      panic("remap");
8010727a:	83 ec 0c             	sub    $0xc,%esp
8010727d:	68 14 85 10 80       	push   $0x80108514
80107282:	e8 f9 90 ff ff       	call   80100380 <panic>
80107287:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010728e:	66 90                	xchg   %ax,%ax

80107290 <seginit>:
{
80107290:	55                   	push   %ebp
80107291:	89 e5                	mov    %esp,%ebp
80107293:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107296:	e8 45 c9 ff ff       	call   80103be0 <cpuid>
  pd[0] = size-1;
8010729b:	ba 2f 00 00 00       	mov    $0x2f,%edx
801072a0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801072a6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801072aa:	c7 80 38 28 11 80 ff 	movl   $0xffff,-0x7feed7c8(%eax)
801072b1:	ff 00 00 
801072b4:	c7 80 3c 28 11 80 00 	movl   $0xcf9a00,-0x7feed7c4(%eax)
801072bb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801072be:	c7 80 40 28 11 80 ff 	movl   $0xffff,-0x7feed7c0(%eax)
801072c5:	ff 00 00 
801072c8:	c7 80 44 28 11 80 00 	movl   $0xcf9200,-0x7feed7bc(%eax)
801072cf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801072d2:	c7 80 48 28 11 80 ff 	movl   $0xffff,-0x7feed7b8(%eax)
801072d9:	ff 00 00 
801072dc:	c7 80 4c 28 11 80 00 	movl   $0xcffa00,-0x7feed7b4(%eax)
801072e3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801072e6:	c7 80 50 28 11 80 ff 	movl   $0xffff,-0x7feed7b0(%eax)
801072ed:	ff 00 00 
801072f0:	c7 80 54 28 11 80 00 	movl   $0xcff200,-0x7feed7ac(%eax)
801072f7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801072fa:	05 30 28 11 80       	add    $0x80112830,%eax
  pd[1] = (uint)p;
801072ff:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107303:	c1 e8 10             	shr    $0x10,%eax
80107306:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010730a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010730d:	0f 01 10             	lgdtl  (%eax)
}
80107310:	c9                   	leave  
80107311:	c3                   	ret    
80107312:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107320 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107320:	a1 e4 6a 11 80       	mov    0x80116ae4,%eax
80107325:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010732a:	0f 22 d8             	mov    %eax,%cr3
}
8010732d:	c3                   	ret    
8010732e:	66 90                	xchg   %ax,%ax

80107330 <switchuvm>:
{
80107330:	55                   	push   %ebp
80107331:	89 e5                	mov    %esp,%ebp
80107333:	57                   	push   %edi
80107334:	56                   	push   %esi
80107335:	53                   	push   %ebx
80107336:	83 ec 1c             	sub    $0x1c,%esp
80107339:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010733c:	85 f6                	test   %esi,%esi
8010733e:	0f 84 cb 00 00 00    	je     8010740f <switchuvm+0xdf>
  if(p->kstack == 0)
80107344:	8b 46 08             	mov    0x8(%esi),%eax
80107347:	85 c0                	test   %eax,%eax
80107349:	0f 84 da 00 00 00    	je     80107429 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010734f:	8b 46 04             	mov    0x4(%esi),%eax
80107352:	85 c0                	test   %eax,%eax
80107354:	0f 84 c2 00 00 00    	je     8010741c <switchuvm+0xec>
  pushcli();
8010735a:	e8 91 d9 ff ff       	call   80104cf0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010735f:	e8 1c c8 ff ff       	call   80103b80 <mycpu>
80107364:	89 c3                	mov    %eax,%ebx
80107366:	e8 15 c8 ff ff       	call   80103b80 <mycpu>
8010736b:	89 c7                	mov    %eax,%edi
8010736d:	e8 0e c8 ff ff       	call   80103b80 <mycpu>
80107372:	83 c7 08             	add    $0x8,%edi
80107375:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107378:	e8 03 c8 ff ff       	call   80103b80 <mycpu>
8010737d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107380:	ba 67 00 00 00       	mov    $0x67,%edx
80107385:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
8010738c:	83 c0 08             	add    $0x8,%eax
8010738f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107396:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010739b:	83 c1 08             	add    $0x8,%ecx
8010739e:	c1 e8 18             	shr    $0x18,%eax
801073a1:	c1 e9 10             	shr    $0x10,%ecx
801073a4:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
801073aa:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801073b0:	b9 99 40 00 00       	mov    $0x4099,%ecx
801073b5:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801073bc:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
801073c1:	e8 ba c7 ff ff       	call   80103b80 <mycpu>
801073c6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801073cd:	e8 ae c7 ff ff       	call   80103b80 <mycpu>
801073d2:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801073d6:	8b 5e 08             	mov    0x8(%esi),%ebx
801073d9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801073df:	e8 9c c7 ff ff       	call   80103b80 <mycpu>
801073e4:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801073e7:	e8 94 c7 ff ff       	call   80103b80 <mycpu>
801073ec:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801073f0:	b8 28 00 00 00       	mov    $0x28,%eax
801073f5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801073f8:	8b 46 04             	mov    0x4(%esi),%eax
801073fb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107400:	0f 22 d8             	mov    %eax,%cr3
}
80107403:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107406:	5b                   	pop    %ebx
80107407:	5e                   	pop    %esi
80107408:	5f                   	pop    %edi
80107409:	5d                   	pop    %ebp
  popcli();
8010740a:	e9 31 d9 ff ff       	jmp    80104d40 <popcli>
    panic("switchuvm: no process");
8010740f:	83 ec 0c             	sub    $0xc,%esp
80107412:	68 1a 85 10 80       	push   $0x8010851a
80107417:	e8 64 8f ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
8010741c:	83 ec 0c             	sub    $0xc,%esp
8010741f:	68 45 85 10 80       	push   $0x80108545
80107424:	e8 57 8f ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80107429:	83 ec 0c             	sub    $0xc,%esp
8010742c:	68 30 85 10 80       	push   $0x80108530
80107431:	e8 4a 8f ff ff       	call   80100380 <panic>
80107436:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010743d:	8d 76 00             	lea    0x0(%esi),%esi

80107440 <inituvm>:
{
80107440:	55                   	push   %ebp
80107441:	89 e5                	mov    %esp,%ebp
80107443:	57                   	push   %edi
80107444:	56                   	push   %esi
80107445:	53                   	push   %ebx
80107446:	83 ec 1c             	sub    $0x1c,%esp
80107449:	8b 45 0c             	mov    0xc(%ebp),%eax
8010744c:	8b 75 10             	mov    0x10(%ebp),%esi
8010744f:	8b 7d 08             	mov    0x8(%ebp),%edi
80107452:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107455:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010745b:	77 4b                	ja     801074a8 <inituvm+0x68>
  mem = kalloc();
8010745d:	e8 1e b2 ff ff       	call   80102680 <kalloc>
  memset(mem, 0, PGSIZE);
80107462:	83 ec 04             	sub    $0x4,%esp
80107465:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010746a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
8010746c:	6a 00                	push   $0x0
8010746e:	50                   	push   %eax
8010746f:	e8 8c da ff ff       	call   80104f00 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107474:	58                   	pop    %eax
80107475:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010747b:	5a                   	pop    %edx
8010747c:	6a 06                	push   $0x6
8010747e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107483:	31 d2                	xor    %edx,%edx
80107485:	50                   	push   %eax
80107486:	89 f8                	mov    %edi,%eax
80107488:	e8 13 fd ff ff       	call   801071a0 <mappages>
  memmove(mem, init, sz);
8010748d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107490:	89 75 10             	mov    %esi,0x10(%ebp)
80107493:	83 c4 10             	add    $0x10,%esp
80107496:	89 5d 08             	mov    %ebx,0x8(%ebp)
80107499:	89 45 0c             	mov    %eax,0xc(%ebp)
}
8010749c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010749f:	5b                   	pop    %ebx
801074a0:	5e                   	pop    %esi
801074a1:	5f                   	pop    %edi
801074a2:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801074a3:	e9 f8 da ff ff       	jmp    80104fa0 <memmove>
    panic("inituvm: more than a page");
801074a8:	83 ec 0c             	sub    $0xc,%esp
801074ab:	68 59 85 10 80       	push   $0x80108559
801074b0:	e8 cb 8e ff ff       	call   80100380 <panic>
801074b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801074c0 <loaduvm>:
{
801074c0:	55                   	push   %ebp
801074c1:	89 e5                	mov    %esp,%ebp
801074c3:	57                   	push   %edi
801074c4:	56                   	push   %esi
801074c5:	53                   	push   %ebx
801074c6:	83 ec 1c             	sub    $0x1c,%esp
801074c9:	8b 45 0c             	mov    0xc(%ebp),%eax
801074cc:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
801074cf:	a9 ff 0f 00 00       	test   $0xfff,%eax
801074d4:	0f 85 bb 00 00 00    	jne    80107595 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
801074da:	01 f0                	add    %esi,%eax
801074dc:	89 f3                	mov    %esi,%ebx
801074de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
801074e1:	8b 45 14             	mov    0x14(%ebp),%eax
801074e4:	01 f0                	add    %esi,%eax
801074e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
801074e9:	85 f6                	test   %esi,%esi
801074eb:	0f 84 87 00 00 00    	je     80107578 <loaduvm+0xb8>
801074f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
801074f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
801074fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
801074fe:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80107500:	89 c2                	mov    %eax,%edx
80107502:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107505:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80107508:	f6 c2 01             	test   $0x1,%dl
8010750b:	75 13                	jne    80107520 <loaduvm+0x60>
      panic("loaduvm: address should exist");
8010750d:	83 ec 0c             	sub    $0xc,%esp
80107510:	68 73 85 10 80       	push   $0x80108573
80107515:	e8 66 8e ff ff       	call   80100380 <panic>
8010751a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107520:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107523:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107529:	25 fc 0f 00 00       	and    $0xffc,%eax
8010752e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107535:	85 c0                	test   %eax,%eax
80107537:	74 d4                	je     8010750d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80107539:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010753b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010753e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107543:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107548:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010754e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107551:	29 d9                	sub    %ebx,%ecx
80107553:	05 00 00 00 80       	add    $0x80000000,%eax
80107558:	57                   	push   %edi
80107559:	51                   	push   %ecx
8010755a:	50                   	push   %eax
8010755b:	ff 75 10             	push   0x10(%ebp)
8010755e:	e8 2d a5 ff ff       	call   80101a90 <readi>
80107563:	83 c4 10             	add    $0x10,%esp
80107566:	39 f8                	cmp    %edi,%eax
80107568:	75 1e                	jne    80107588 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
8010756a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80107570:	89 f0                	mov    %esi,%eax
80107572:	29 d8                	sub    %ebx,%eax
80107574:	39 c6                	cmp    %eax,%esi
80107576:	77 80                	ja     801074f8 <loaduvm+0x38>
}
80107578:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010757b:	31 c0                	xor    %eax,%eax
}
8010757d:	5b                   	pop    %ebx
8010757e:	5e                   	pop    %esi
8010757f:	5f                   	pop    %edi
80107580:	5d                   	pop    %ebp
80107581:	c3                   	ret    
80107582:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107588:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010758b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107590:	5b                   	pop    %ebx
80107591:	5e                   	pop    %esi
80107592:	5f                   	pop    %edi
80107593:	5d                   	pop    %ebp
80107594:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80107595:	83 ec 0c             	sub    $0xc,%esp
80107598:	68 14 86 10 80       	push   $0x80108614
8010759d:	e8 de 8d ff ff       	call   80100380 <panic>
801075a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801075b0 <allocuvm>:
{
801075b0:	55                   	push   %ebp
801075b1:	89 e5                	mov    %esp,%ebp
801075b3:	57                   	push   %edi
801075b4:	56                   	push   %esi
801075b5:	53                   	push   %ebx
801075b6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
801075b9:	8b 45 10             	mov    0x10(%ebp),%eax
{
801075bc:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
801075bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801075c2:	85 c0                	test   %eax,%eax
801075c4:	0f 88 b6 00 00 00    	js     80107680 <allocuvm+0xd0>
  if(newsz < oldsz)
801075ca:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
801075cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
801075d0:	0f 82 9a 00 00 00    	jb     80107670 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
801075d6:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801075dc:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
801075e2:	39 75 10             	cmp    %esi,0x10(%ebp)
801075e5:	77 44                	ja     8010762b <allocuvm+0x7b>
801075e7:	e9 87 00 00 00       	jmp    80107673 <allocuvm+0xc3>
801075ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
801075f0:	83 ec 04             	sub    $0x4,%esp
801075f3:	68 00 10 00 00       	push   $0x1000
801075f8:	6a 00                	push   $0x0
801075fa:	50                   	push   %eax
801075fb:	e8 00 d9 ff ff       	call   80104f00 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107600:	58                   	pop    %eax
80107601:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107607:	5a                   	pop    %edx
80107608:	6a 06                	push   $0x6
8010760a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010760f:	89 f2                	mov    %esi,%edx
80107611:	50                   	push   %eax
80107612:	89 f8                	mov    %edi,%eax
80107614:	e8 87 fb ff ff       	call   801071a0 <mappages>
80107619:	83 c4 10             	add    $0x10,%esp
8010761c:	85 c0                	test   %eax,%eax
8010761e:	78 78                	js     80107698 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107620:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107626:	39 75 10             	cmp    %esi,0x10(%ebp)
80107629:	76 48                	jbe    80107673 <allocuvm+0xc3>
    mem = kalloc();
8010762b:	e8 50 b0 ff ff       	call   80102680 <kalloc>
80107630:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107632:	85 c0                	test   %eax,%eax
80107634:	75 ba                	jne    801075f0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107636:	83 ec 0c             	sub    $0xc,%esp
80107639:	68 91 85 10 80       	push   $0x80108591
8010763e:	e8 5d 90 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107643:	8b 45 0c             	mov    0xc(%ebp),%eax
80107646:	83 c4 10             	add    $0x10,%esp
80107649:	39 45 10             	cmp    %eax,0x10(%ebp)
8010764c:	74 32                	je     80107680 <allocuvm+0xd0>
8010764e:	8b 55 10             	mov    0x10(%ebp),%edx
80107651:	89 c1                	mov    %eax,%ecx
80107653:	89 f8                	mov    %edi,%eax
80107655:	e8 96 fa ff ff       	call   801070f0 <deallocuvm.part.0>
      return 0;
8010765a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107661:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107664:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107667:	5b                   	pop    %ebx
80107668:	5e                   	pop    %esi
80107669:	5f                   	pop    %edi
8010766a:	5d                   	pop    %ebp
8010766b:	c3                   	ret    
8010766c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107670:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107673:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107676:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107679:	5b                   	pop    %ebx
8010767a:	5e                   	pop    %esi
8010767b:	5f                   	pop    %edi
8010767c:	5d                   	pop    %ebp
8010767d:	c3                   	ret    
8010767e:	66 90                	xchg   %ax,%ax
    return 0;
80107680:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107687:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010768a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010768d:	5b                   	pop    %ebx
8010768e:	5e                   	pop    %esi
8010768f:	5f                   	pop    %edi
80107690:	5d                   	pop    %ebp
80107691:	c3                   	ret    
80107692:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107698:	83 ec 0c             	sub    $0xc,%esp
8010769b:	68 a9 85 10 80       	push   $0x801085a9
801076a0:	e8 fb 8f ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
801076a5:	8b 45 0c             	mov    0xc(%ebp),%eax
801076a8:	83 c4 10             	add    $0x10,%esp
801076ab:	39 45 10             	cmp    %eax,0x10(%ebp)
801076ae:	74 0c                	je     801076bc <allocuvm+0x10c>
801076b0:	8b 55 10             	mov    0x10(%ebp),%edx
801076b3:	89 c1                	mov    %eax,%ecx
801076b5:	89 f8                	mov    %edi,%eax
801076b7:	e8 34 fa ff ff       	call   801070f0 <deallocuvm.part.0>
      kfree(mem);
801076bc:	83 ec 0c             	sub    $0xc,%esp
801076bf:	53                   	push   %ebx
801076c0:	e8 fb ad ff ff       	call   801024c0 <kfree>
      return 0;
801076c5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801076cc:	83 c4 10             	add    $0x10,%esp
}
801076cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801076d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076d5:	5b                   	pop    %ebx
801076d6:	5e                   	pop    %esi
801076d7:	5f                   	pop    %edi
801076d8:	5d                   	pop    %ebp
801076d9:	c3                   	ret    
801076da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801076e0 <deallocuvm>:
{
801076e0:	55                   	push   %ebp
801076e1:	89 e5                	mov    %esp,%ebp
801076e3:	8b 55 0c             	mov    0xc(%ebp),%edx
801076e6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801076e9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801076ec:	39 d1                	cmp    %edx,%ecx
801076ee:	73 10                	jae    80107700 <deallocuvm+0x20>
}
801076f0:	5d                   	pop    %ebp
801076f1:	e9 fa f9 ff ff       	jmp    801070f0 <deallocuvm.part.0>
801076f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076fd:	8d 76 00             	lea    0x0(%esi),%esi
80107700:	89 d0                	mov    %edx,%eax
80107702:	5d                   	pop    %ebp
80107703:	c3                   	ret    
80107704:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010770b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010770f:	90                   	nop

80107710 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107710:	55                   	push   %ebp
80107711:	89 e5                	mov    %esp,%ebp
80107713:	57                   	push   %edi
80107714:	56                   	push   %esi
80107715:	53                   	push   %ebx
80107716:	83 ec 0c             	sub    $0xc,%esp
80107719:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010771c:	85 f6                	test   %esi,%esi
8010771e:	74 59                	je     80107779 <freevm+0x69>
  if(newsz >= oldsz)
80107720:	31 c9                	xor    %ecx,%ecx
80107722:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107727:	89 f0                	mov    %esi,%eax
80107729:	89 f3                	mov    %esi,%ebx
8010772b:	e8 c0 f9 ff ff       	call   801070f0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107730:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107736:	eb 0f                	jmp    80107747 <freevm+0x37>
80107738:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010773f:	90                   	nop
80107740:	83 c3 04             	add    $0x4,%ebx
80107743:	39 df                	cmp    %ebx,%edi
80107745:	74 23                	je     8010776a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107747:	8b 03                	mov    (%ebx),%eax
80107749:	a8 01                	test   $0x1,%al
8010774b:	74 f3                	je     80107740 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010774d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107752:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107755:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107758:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010775d:	50                   	push   %eax
8010775e:	e8 5d ad ff ff       	call   801024c0 <kfree>
80107763:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107766:	39 df                	cmp    %ebx,%edi
80107768:	75 dd                	jne    80107747 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010776a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010776d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107770:	5b                   	pop    %ebx
80107771:	5e                   	pop    %esi
80107772:	5f                   	pop    %edi
80107773:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107774:	e9 47 ad ff ff       	jmp    801024c0 <kfree>
    panic("freevm: no pgdir");
80107779:	83 ec 0c             	sub    $0xc,%esp
8010777c:	68 c5 85 10 80       	push   $0x801085c5
80107781:	e8 fa 8b ff ff       	call   80100380 <panic>
80107786:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010778d:	8d 76 00             	lea    0x0(%esi),%esi

80107790 <setupkvm>:
{
80107790:	55                   	push   %ebp
80107791:	89 e5                	mov    %esp,%ebp
80107793:	56                   	push   %esi
80107794:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107795:	e8 e6 ae ff ff       	call   80102680 <kalloc>
8010779a:	89 c6                	mov    %eax,%esi
8010779c:	85 c0                	test   %eax,%eax
8010779e:	74 42                	je     801077e2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801077a0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801077a3:	bb 40 b4 10 80       	mov    $0x8010b440,%ebx
  memset(pgdir, 0, PGSIZE);
801077a8:	68 00 10 00 00       	push   $0x1000
801077ad:	6a 00                	push   $0x0
801077af:	50                   	push   %eax
801077b0:	e8 4b d7 ff ff       	call   80104f00 <memset>
801077b5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801077b8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801077bb:	83 ec 08             	sub    $0x8,%esp
801077be:	8b 4b 08             	mov    0x8(%ebx),%ecx
801077c1:	ff 73 0c             	push   0xc(%ebx)
801077c4:	8b 13                	mov    (%ebx),%edx
801077c6:	50                   	push   %eax
801077c7:	29 c1                	sub    %eax,%ecx
801077c9:	89 f0                	mov    %esi,%eax
801077cb:	e8 d0 f9 ff ff       	call   801071a0 <mappages>
801077d0:	83 c4 10             	add    $0x10,%esp
801077d3:	85 c0                	test   %eax,%eax
801077d5:	78 19                	js     801077f0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801077d7:	83 c3 10             	add    $0x10,%ebx
801077da:	81 fb 80 b4 10 80    	cmp    $0x8010b480,%ebx
801077e0:	75 d6                	jne    801077b8 <setupkvm+0x28>
}
801077e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801077e5:	89 f0                	mov    %esi,%eax
801077e7:	5b                   	pop    %ebx
801077e8:	5e                   	pop    %esi
801077e9:	5d                   	pop    %ebp
801077ea:	c3                   	ret    
801077eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801077ef:	90                   	nop
      freevm(pgdir);
801077f0:	83 ec 0c             	sub    $0xc,%esp
801077f3:	56                   	push   %esi
      return 0;
801077f4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801077f6:	e8 15 ff ff ff       	call   80107710 <freevm>
      return 0;
801077fb:	83 c4 10             	add    $0x10,%esp
}
801077fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107801:	89 f0                	mov    %esi,%eax
80107803:	5b                   	pop    %ebx
80107804:	5e                   	pop    %esi
80107805:	5d                   	pop    %ebp
80107806:	c3                   	ret    
80107807:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010780e:	66 90                	xchg   %ax,%ax

80107810 <kvmalloc>:
{
80107810:	55                   	push   %ebp
80107811:	89 e5                	mov    %esp,%ebp
80107813:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107816:	e8 75 ff ff ff       	call   80107790 <setupkvm>
8010781b:	a3 e4 6a 11 80       	mov    %eax,0x80116ae4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107820:	05 00 00 00 80       	add    $0x80000000,%eax
80107825:	0f 22 d8             	mov    %eax,%cr3
}
80107828:	c9                   	leave  
80107829:	c3                   	ret    
8010782a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107830 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107830:	55                   	push   %ebp
80107831:	89 e5                	mov    %esp,%ebp
80107833:	83 ec 08             	sub    $0x8,%esp
80107836:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107839:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010783c:	89 c1                	mov    %eax,%ecx
8010783e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107841:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107844:	f6 c2 01             	test   $0x1,%dl
80107847:	75 17                	jne    80107860 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107849:	83 ec 0c             	sub    $0xc,%esp
8010784c:	68 d6 85 10 80       	push   $0x801085d6
80107851:	e8 2a 8b ff ff       	call   80100380 <panic>
80107856:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010785d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107860:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107863:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107869:	25 fc 0f 00 00       	and    $0xffc,%eax
8010786e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107875:	85 c0                	test   %eax,%eax
80107877:	74 d0                	je     80107849 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107879:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010787c:	c9                   	leave  
8010787d:	c3                   	ret    
8010787e:	66 90                	xchg   %ax,%ax

80107880 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107880:	55                   	push   %ebp
80107881:	89 e5                	mov    %esp,%ebp
80107883:	57                   	push   %edi
80107884:	56                   	push   %esi
80107885:	53                   	push   %ebx
80107886:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107889:	e8 02 ff ff ff       	call   80107790 <setupkvm>
8010788e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107891:	85 c0                	test   %eax,%eax
80107893:	0f 84 bd 00 00 00    	je     80107956 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107899:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010789c:	85 c9                	test   %ecx,%ecx
8010789e:	0f 84 b2 00 00 00    	je     80107956 <copyuvm+0xd6>
801078a4:	31 f6                	xor    %esi,%esi
801078a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078ad:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
801078b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
801078b3:	89 f0                	mov    %esi,%eax
801078b5:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801078b8:	8b 04 81             	mov    (%ecx,%eax,4),%eax
801078bb:	a8 01                	test   $0x1,%al
801078bd:	75 11                	jne    801078d0 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801078bf:	83 ec 0c             	sub    $0xc,%esp
801078c2:	68 e0 85 10 80       	push   $0x801085e0
801078c7:	e8 b4 8a ff ff       	call   80100380 <panic>
801078cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
801078d0:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801078d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801078d7:	c1 ea 0a             	shr    $0xa,%edx
801078da:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801078e0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801078e7:	85 c0                	test   %eax,%eax
801078e9:	74 d4                	je     801078bf <copyuvm+0x3f>
    if(!(*pte & PTE_P))
801078eb:	8b 00                	mov    (%eax),%eax
801078ed:	a8 01                	test   $0x1,%al
801078ef:	0f 84 9f 00 00 00    	je     80107994 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801078f5:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
801078f7:	25 ff 0f 00 00       	and    $0xfff,%eax
801078fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
801078ff:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107905:	e8 76 ad ff ff       	call   80102680 <kalloc>
8010790a:	89 c3                	mov    %eax,%ebx
8010790c:	85 c0                	test   %eax,%eax
8010790e:	74 64                	je     80107974 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107910:	83 ec 04             	sub    $0x4,%esp
80107913:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107919:	68 00 10 00 00       	push   $0x1000
8010791e:	57                   	push   %edi
8010791f:	50                   	push   %eax
80107920:	e8 7b d6 ff ff       	call   80104fa0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107925:	58                   	pop    %eax
80107926:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010792c:	5a                   	pop    %edx
8010792d:	ff 75 e4             	push   -0x1c(%ebp)
80107930:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107935:	89 f2                	mov    %esi,%edx
80107937:	50                   	push   %eax
80107938:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010793b:	e8 60 f8 ff ff       	call   801071a0 <mappages>
80107940:	83 c4 10             	add    $0x10,%esp
80107943:	85 c0                	test   %eax,%eax
80107945:	78 21                	js     80107968 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107947:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010794d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107950:	0f 87 5a ff ff ff    	ja     801078b0 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107956:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107959:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010795c:	5b                   	pop    %ebx
8010795d:	5e                   	pop    %esi
8010795e:	5f                   	pop    %edi
8010795f:	5d                   	pop    %ebp
80107960:	c3                   	ret    
80107961:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107968:	83 ec 0c             	sub    $0xc,%esp
8010796b:	53                   	push   %ebx
8010796c:	e8 4f ab ff ff       	call   801024c0 <kfree>
      goto bad;
80107971:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107974:	83 ec 0c             	sub    $0xc,%esp
80107977:	ff 75 e0             	push   -0x20(%ebp)
8010797a:	e8 91 fd ff ff       	call   80107710 <freevm>
  return 0;
8010797f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107986:	83 c4 10             	add    $0x10,%esp
}
80107989:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010798c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010798f:	5b                   	pop    %ebx
80107990:	5e                   	pop    %esi
80107991:	5f                   	pop    %edi
80107992:	5d                   	pop    %ebp
80107993:	c3                   	ret    
      panic("copyuvm: page not present");
80107994:	83 ec 0c             	sub    $0xc,%esp
80107997:	68 fa 85 10 80       	push   $0x801085fa
8010799c:	e8 df 89 ff ff       	call   80100380 <panic>
801079a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801079a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801079af:	90                   	nop

801079b0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801079b0:	55                   	push   %ebp
801079b1:	89 e5                	mov    %esp,%ebp
801079b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801079b6:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801079b9:	89 c1                	mov    %eax,%ecx
801079bb:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801079be:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801079c1:	f6 c2 01             	test   $0x1,%dl
801079c4:	0f 84 00 01 00 00    	je     80107aca <uva2ka.cold>
  return &pgtab[PTX(va)];
801079ca:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801079cd:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801079d3:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
801079d4:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
801079d9:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
801079e0:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801079e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801079e7:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801079ea:	05 00 00 00 80       	add    $0x80000000,%eax
801079ef:	83 fa 05             	cmp    $0x5,%edx
801079f2:	ba 00 00 00 00       	mov    $0x0,%edx
801079f7:	0f 45 c2             	cmovne %edx,%eax
}
801079fa:	c3                   	ret    
801079fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801079ff:	90                   	nop

80107a00 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107a00:	55                   	push   %ebp
80107a01:	89 e5                	mov    %esp,%ebp
80107a03:	57                   	push   %edi
80107a04:	56                   	push   %esi
80107a05:	53                   	push   %ebx
80107a06:	83 ec 0c             	sub    $0xc,%esp
80107a09:	8b 75 14             	mov    0x14(%ebp),%esi
80107a0c:	8b 45 0c             	mov    0xc(%ebp),%eax
80107a0f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107a12:	85 f6                	test   %esi,%esi
80107a14:	75 51                	jne    80107a67 <copyout+0x67>
80107a16:	e9 a5 00 00 00       	jmp    80107ac0 <copyout+0xc0>
80107a1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107a1f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107a20:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107a26:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
80107a2c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107a32:	74 75                	je     80107aa9 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107a34:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107a36:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107a39:	29 c3                	sub    %eax,%ebx
80107a3b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107a41:	39 f3                	cmp    %esi,%ebx
80107a43:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80107a46:	29 f8                	sub    %edi,%eax
80107a48:	83 ec 04             	sub    $0x4,%esp
80107a4b:	01 c1                	add    %eax,%ecx
80107a4d:	53                   	push   %ebx
80107a4e:	52                   	push   %edx
80107a4f:	51                   	push   %ecx
80107a50:	e8 4b d5 ff ff       	call   80104fa0 <memmove>
    len -= n;
    buf += n;
80107a55:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107a58:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
80107a5e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107a61:	01 da                	add    %ebx,%edx
  while(len > 0){
80107a63:	29 de                	sub    %ebx,%esi
80107a65:	74 59                	je     80107ac0 <copyout+0xc0>
  if(*pde & PTE_P){
80107a67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
80107a6a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107a6c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
80107a6e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107a71:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107a77:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
80107a7a:	f6 c1 01             	test   $0x1,%cl
80107a7d:	0f 84 4e 00 00 00    	je     80107ad1 <copyout.cold>
  return &pgtab[PTX(va)];
80107a83:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107a85:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107a8b:	c1 eb 0c             	shr    $0xc,%ebx
80107a8e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107a94:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
80107a9b:	89 d9                	mov    %ebx,%ecx
80107a9d:	83 e1 05             	and    $0x5,%ecx
80107aa0:	83 f9 05             	cmp    $0x5,%ecx
80107aa3:	0f 84 77 ff ff ff    	je     80107a20 <copyout+0x20>
  }
  return 0;
}
80107aa9:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107aac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107ab1:	5b                   	pop    %ebx
80107ab2:	5e                   	pop    %esi
80107ab3:	5f                   	pop    %edi
80107ab4:	5d                   	pop    %ebp
80107ab5:	c3                   	ret    
80107ab6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107abd:	8d 76 00             	lea    0x0(%esi),%esi
80107ac0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107ac3:	31 c0                	xor    %eax,%eax
}
80107ac5:	5b                   	pop    %ebx
80107ac6:	5e                   	pop    %esi
80107ac7:	5f                   	pop    %edi
80107ac8:	5d                   	pop    %ebp
80107ac9:	c3                   	ret    

80107aca <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
80107aca:	a1 00 00 00 00       	mov    0x0,%eax
80107acf:	0f 0b                	ud2    

80107ad1 <copyout.cold>:
80107ad1:	a1 00 00 00 00       	mov    0x0,%eax
80107ad6:	0f 0b                	ud2    
