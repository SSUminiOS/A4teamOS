
_test:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
   printf(1, "Thread terminated.\n");
   exit();
 }

 int main(int argc, char *argv[]) 
 {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
     int tid;
     int arg = 35;

     tid = thread_create(&function, &arg);
   e:	8d 45 f4             	lea    -0xc(%ebp),%eax
 {
  11:	83 ec 1c             	sub    $0x1c,%esp
     int arg = 35;
  14:	c7 45 f4 23 00 00 00 	movl   $0x23,-0xc(%ebp)
     tid = thread_create(&function, &arg);
  1b:	50                   	push   %eax
  1c:	68 00 03 00 00       	push   $0x300
  21:	e8 2a 0a 00 00       	call   a50 <thread_create>
     thread_join(tid);
  26:	89 04 24             	mov    %eax,(%esp)
  29:	e8 72 0a 00 00       	call   aa0 <thread_join>
     printf(1, "Parent hex x = %x\n", x);
  2e:	83 c4 0c             	add    $0xc,%esp
  31:	ff 35 d8 0e 00 00    	push   0xed8
  37:	68 fc 0a 00 00       	push   $0xafc
  3c:	6a 01                	push   $0x1
  3e:	e8 dd 06 00 00       	call   720 <printf>
     printf(1, "Parent int x = %d\n", x);
  43:	83 c4 0c             	add    $0xc,%esp
  46:	ff 35 d8 0e 00 00    	push   0xed8
  4c:	68 0f 0b 00 00       	push   $0xb0f
  51:	6a 01                	push   $0x1
  53:	e8 c8 06 00 00       	call   720 <printf>
     printf(1, "Parent terminated.\n");
  58:	58                   	pop    %eax
  59:	5a                   	pop    %edx
  5a:	68 22 0b 00 00       	push   $0xb22
  5f:	6a 01                	push   $0x1
  61:	e8 ba 06 00 00       	call   720 <printf>
     exit();
  66:	e8 38 05 00 00       	call   5a3 <exit>
  6b:	66 90                	xchg   %ax,%ax
  6d:	66 90                	xchg   %ax,%ax
  6f:	90                   	nop

00000070 <fib>:
 {
  70:	55                   	push   %ebp
  71:	89 e5                	mov    %esp,%ebp
  73:	57                   	push   %edi
  74:	56                   	push   %esi
  75:	53                   	push   %ebx
  76:	83 ec 6c             	sub    $0x6c,%esp
 if (n <= 1)
  79:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  7d:	0f 8e 0e 02 00 00    	jle    291 <fib+0x221>
  83:	8b 45 08             	mov    0x8(%ebp),%eax
  86:	8b 55 08             	mov    0x8(%ebp),%edx
  89:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
  90:	83 e8 03             	sub    $0x3,%eax
  93:	89 45 b0             	mov    %eax,-0x50(%ebp)
  96:	83 fa 02             	cmp    $0x2,%edx
  99:	0f 84 4a 02 00 00    	je     2e9 <fib+0x279>
  9f:	8d 42 fe             	lea    -0x2(%edx),%eax
  a2:	83 ea 04             	sub    $0x4,%edx
  a5:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
  ac:	89 45 9c             	mov    %eax,-0x64(%ebp)
  af:	89 45 bc             	mov    %eax,-0x44(%ebp)
  b2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  b5:	83 e0 fe             	and    $0xfffffffe,%eax
  b8:	29 c2                	sub    %eax,%edx
  ba:	89 55 90             	mov    %edx,-0x70(%ebp)
 return fib(n-1) + fib(n-2);
  bd:	8b 55 bc             	mov    -0x44(%ebp),%edx
 if (n <= 1)
  c0:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
  c7:	8d 42 fd             	lea    -0x3(%edx),%eax
  ca:	89 45 b8             	mov    %eax,-0x48(%ebp)
  cd:	83 fa 01             	cmp    $0x1,%edx
  d0:	0f 84 09 02 00 00    	je     2df <fib+0x26f>
  d6:	83 fa 02             	cmp    $0x2,%edx
  d9:	0f 84 ef 01 00 00    	je     2ce <fib+0x25e>
  df:	8d 42 fe             	lea    -0x2(%edx),%eax
  e2:	83 ea 04             	sub    $0x4,%edx
  e5:	c7 45 a0 00 00 00 00 	movl   $0x0,-0x60(%ebp)
  ec:	89 45 98             	mov    %eax,-0x68(%ebp)
  ef:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  f2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  f5:	83 e0 fe             	and    $0xfffffffe,%eax
  f8:	29 c2                	sub    %eax,%edx
  fa:	89 55 94             	mov    %edx,-0x6c(%ebp)
 return fib(n-1) + fib(n-2);
  fd:	8b 4d b4             	mov    -0x4c(%ebp),%ecx
 if (n <= 1)
 100:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 107:	8d 41 fd             	lea    -0x3(%ecx),%eax
 10a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 10d:	83 f9 01             	cmp    $0x1,%ecx
 110:	0f 84 ae 01 00 00    	je     2c4 <fib+0x254>
 116:	83 f9 02             	cmp    $0x2,%ecx
 119:	0f 84 9b 01 00 00    	je     2ba <fib+0x24a>
 11f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 122:	8d 51 fa             	lea    -0x6(%ecx),%edx
 125:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
 12c:	8d 71 fc             	lea    -0x4(%ecx),%esi
 12f:	89 4d c8             	mov    %ecx,-0x38(%ebp)
 132:	89 f1                	mov    %esi,%ecx
 134:	83 e0 fe             	and    $0xfffffffe,%eax
 137:	29 c2                	sub    %eax,%edx
 139:	89 55 c0             	mov    %edx,-0x40(%ebp)
 return fib(n-1) + fib(n-2);
 13c:	8d 51 02             	lea    0x2(%ecx),%edx
 if (n <= 1)
 13f:	83 f9 ff             	cmp    $0xffffffff,%ecx
 142:	0f 84 9b 00 00 00    	je     1e3 <fib+0x173>
 148:	8d 41 ff             	lea    -0x1(%ecx),%eax
 14b:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 14e:	89 45 dc             	mov    %eax,-0x24(%ebp)
 151:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
 158:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
 15b:	83 fa 02             	cmp    $0x2,%edx
 15e:	0f 84 3c 01 00 00    	je     2a0 <fib+0x230>
 164:	8b 45 dc             	mov    -0x24(%ebp),%eax
 167:	8d 4a fc             	lea    -0x4(%edx),%ecx
 16a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 16d:	31 ff                	xor    %edi,%edi
 16f:	83 e0 fe             	and    $0xfffffffe,%eax
 172:	29 c1                	sub    %eax,%ecx
 174:	89 4d cc             	mov    %ecx,-0x34(%ebp)
 return fib(n-1) + fib(n-2);
 177:	89 de                	mov    %ebx,%esi
 if (n <= 1)
 179:	31 c9                	xor    %ecx,%ecx
 17b:	83 fb 01             	cmp    $0x1,%ebx
 17e:	0f 84 2c 01 00 00    	je     2b0 <fib+0x240>
 return fib(n-1) + fib(n-2);
 184:	83 ec 0c             	sub    $0xc,%esp
 187:	8d 46 ff             	lea    -0x1(%esi),%eax
 18a:	89 55 88             	mov    %edx,-0x78(%ebp)
 18d:	83 ee 02             	sub    $0x2,%esi
 190:	50                   	push   %eax
 191:	89 4d 8c             	mov    %ecx,-0x74(%ebp)
 194:	e8 d7 fe ff ff       	call   70 <fib>
 199:	8b 4d 8c             	mov    -0x74(%ebp),%ecx
 19c:	83 c4 10             	add    $0x10,%esp
 if (n <= 1)
 19f:	8b 55 88             	mov    -0x78(%ebp),%edx
 1a2:	01 c1                	add    %eax,%ecx
 1a4:	83 fe 01             	cmp    $0x1,%esi
 1a7:	7f db                	jg     184 <fib+0x114>
 1a9:	8d 43 fe             	lea    -0x2(%ebx),%eax
 return fib(n-1) + fib(n-2);
 1ac:	83 e3 01             	and    $0x1,%ebx
 1af:	8d 34 0b             	lea    (%ebx,%ecx,1),%esi
 	return n;
 1b2:	01 f7                	add    %esi,%edi
 if (n <= 1)
 1b4:	89 c3                	mov    %eax,%ebx
 1b6:	39 45 cc             	cmp    %eax,-0x34(%ebp)
 1b9:	75 bc                	jne    177 <fib+0x107>
 return fib(n-1) + fib(n-2);
 1bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
 1be:	83 e0 01             	and    $0x1,%eax
 1c1:	01 f8                	add    %edi,%eax
 1c3:	83 ea 02             	sub    $0x2,%edx
 1c6:	01 45 d8             	add    %eax,-0x28(%ebp)
 if (n <= 1)
 1c9:	83 6d d0 02          	subl   $0x2,-0x30(%ebp)
 1cd:	83 6d dc 02          	subl   $0x2,-0x24(%ebp)
 1d1:	83 fa 01             	cmp    $0x1,%edx
 1d4:	7f 85                	jg     15b <fib+0xeb>
 return fib(n-1) + fib(n-2);
 1d6:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
 1d9:	8b 55 d8             	mov    -0x28(%ebp),%edx
 1dc:	89 c8                	mov    %ecx,%eax
 1de:	83 e0 01             	and    $0x1,%eax
 1e1:	01 c2                	add    %eax,%edx
 if (n <= 1)
 1e3:	01 55 e0             	add    %edx,-0x20(%ebp)
 1e6:	83 e9 02             	sub    $0x2,%ecx
 1e9:	39 4d c0             	cmp    %ecx,-0x40(%ebp)
 1ec:	0f 85 4a ff ff ff    	jne    13c <fib+0xcc>
 return fib(n-1) + fib(n-2);
 1f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 1f5:	8b 4d c8             	mov    -0x38(%ebp),%ecx
 1f8:	83 e0 01             	and    $0x1,%eax
 1fb:	03 45 e0             	add    -0x20(%ebp),%eax
 1fe:	83 e9 02             	sub    $0x2,%ecx
 201:	01 45 d4             	add    %eax,-0x2c(%ebp)
 if (n <= 1)
 204:	83 6d e4 02          	subl   $0x2,-0x1c(%ebp)
 208:	83 f9 01             	cmp    $0x1,%ecx
 20b:	0f 8f 05 ff ff ff    	jg     116 <fib+0xa6>
 211:	8b 5d b4             	mov    -0x4c(%ebp),%ebx
 214:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 217:	8d 43 fe             	lea    -0x2(%ebx),%eax
 return fib(n-1) + fib(n-2);
 21a:	83 e3 01             	and    $0x1,%ebx
 21d:	01 d9                	add    %ebx,%ecx
 if (n <= 1)
 21f:	01 4d a0             	add    %ecx,-0x60(%ebp)
 222:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 225:	39 45 94             	cmp    %eax,-0x6c(%ebp)
 228:	0f 85 cf fe ff ff    	jne    fd <fib+0x8d>
 return fib(n-1) + fib(n-2);
 22e:	8b 45 b8             	mov    -0x48(%ebp),%eax
 231:	83 e0 01             	and    $0x1,%eax
 234:	03 45 a0             	add    -0x60(%ebp),%eax
 237:	8b 55 98             	mov    -0x68(%ebp),%edx
 23a:	01 45 a4             	add    %eax,-0x5c(%ebp)
 if (n <= 1)
 23d:	83 6d b8 02          	subl   $0x2,-0x48(%ebp)
 241:	83 fa 01             	cmp    $0x1,%edx
 244:	0f 8f 8c fe ff ff    	jg     d6 <fib+0x66>
 24a:	8b 75 bc             	mov    -0x44(%ebp),%esi
 24d:	8b 55 a4             	mov    -0x5c(%ebp),%edx
 250:	8d 46 fe             	lea    -0x2(%esi),%eax
 return fib(n-1) + fib(n-2);
 253:	83 e6 01             	and    $0x1,%esi
 256:	01 f2                	add    %esi,%edx
 if (n <= 1)
 258:	8b 5d 90             	mov    -0x70(%ebp),%ebx
 25b:	01 55 a8             	add    %edx,-0x58(%ebp)
 25e:	89 45 bc             	mov    %eax,-0x44(%ebp)
 261:	39 d8                	cmp    %ebx,%eax
 263:	0f 85 54 fe ff ff    	jne    bd <fib+0x4d>
 return fib(n-1) + fib(n-2);
 269:	8b 45 b0             	mov    -0x50(%ebp),%eax
 26c:	83 e0 01             	and    $0x1,%eax
 26f:	03 45 a8             	add    -0x58(%ebp),%eax
 272:	8b 55 9c             	mov    -0x64(%ebp),%edx
 275:	01 45 ac             	add    %eax,-0x54(%ebp)
 if (n <= 1)
 278:	83 6d b0 02          	subl   $0x2,-0x50(%ebp)
 27c:	83 fa 01             	cmp    $0x1,%edx
 27f:	0f 8f 11 fe ff ff    	jg     96 <fib+0x26>
 return fib(n-1) + fib(n-2);
 285:	8b 45 08             	mov    0x8(%ebp),%eax
 288:	83 e0 01             	and    $0x1,%eax
 28b:	03 45 ac             	add    -0x54(%ebp),%eax
 28e:	89 45 08             	mov    %eax,0x8(%ebp)
 }
 291:	8b 45 08             	mov    0x8(%ebp),%eax
 294:	8d 65 f4             	lea    -0xc(%ebp),%esp
 297:	5b                   	pop    %ebx
 298:	5e                   	pop    %esi
 299:	5f                   	pop    %edi
 29a:	5d                   	pop    %ebp
 29b:	c3                   	ret    
 29c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 if (n <= 1)
 2a0:	b8 01 00 00 00       	mov    $0x1,%eax
 2a5:	e9 19 ff ff ff       	jmp    1c3 <fib+0x153>
 2aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 2b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2b5:	e9 f8 fe ff ff       	jmp    1b2 <fib+0x142>
 2ba:	b8 01 00 00 00       	mov    $0x1,%eax
 2bf:	e9 3a ff ff ff       	jmp    1fe <fib+0x18e>
 2c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2c9:	e9 51 ff ff ff       	jmp    21f <fib+0x1af>
 2ce:	c7 45 98 00 00 00 00 	movl   $0x0,-0x68(%ebp)
 2d5:	b8 01 00 00 00       	mov    $0x1,%eax
 2da:	e9 58 ff ff ff       	jmp    237 <fib+0x1c7>
 2df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2e4:	e9 6f ff ff ff       	jmp    258 <fib+0x1e8>
 2e9:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%ebp)
 2f0:	b8 01 00 00 00       	mov    $0x1,%eax
 2f5:	e9 78 ff ff ff       	jmp    272 <fib+0x202>
 2fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000300 <function>:
 {
 300:	55                   	push   %ebp
 301:	89 e5                	mov    %esp,%ebp
 303:	83 ec 10             	sub    $0x10,%esp
   printf(1, "Thread created.\n");
 306:	68 c8 0a 00 00       	push   $0xac8
 30b:	6a 01                	push   $0x1
 30d:	e8 0e 04 00 00       	call   720 <printf>
   x = fib(*((int*)arg));
 312:	58                   	pop    %eax
 313:	8b 45 08             	mov    0x8(%ebp),%eax
 316:	ff 30                	push   (%eax)
 318:	e8 53 fd ff ff       	call   70 <fib>
 31d:	83 c4 0c             	add    $0xc,%esp
   printf(1, "Thread x = %d\n", x);
 320:	50                   	push   %eax
 321:	68 d9 0a 00 00       	push   $0xad9
 326:	6a 01                	push   $0x1
   x = fib(*((int*)arg));
 328:	a3 d8 0e 00 00       	mov    %eax,0xed8
   printf(1, "Thread x = %d\n", x);
 32d:	e8 ee 03 00 00       	call   720 <printf>
   printf(1, "Thread terminated.\n");
 332:	5a                   	pop    %edx
 333:	59                   	pop    %ecx
 334:	68 e8 0a 00 00       	push   $0xae8
 339:	6a 01                	push   $0x1
 33b:	e8 e0 03 00 00       	call   720 <printf>
   exit();
 340:	e8 5e 02 00 00       	call   5a3 <exit>
 345:	66 90                	xchg   %ax,%ax
 347:	66 90                	xchg   %ax,%ax
 349:	66 90                	xchg   %ax,%ax
 34b:	66 90                	xchg   %ax,%ax
 34d:	66 90                	xchg   %ax,%ax
 34f:	90                   	nop

00000350 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 350:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 351:	31 c0                	xor    %eax,%eax
{
 353:	89 e5                	mov    %esp,%ebp
 355:	53                   	push   %ebx
 356:	8b 4d 08             	mov    0x8(%ebp),%ecx
 359:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 35c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 360:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 364:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 367:	83 c0 01             	add    $0x1,%eax
 36a:	84 d2                	test   %dl,%dl
 36c:	75 f2                	jne    360 <strcpy+0x10>
    ;
  return os;
}
 36e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 371:	89 c8                	mov    %ecx,%eax
 373:	c9                   	leave  
 374:	c3                   	ret    
 375:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 37c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000380 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	53                   	push   %ebx
 384:	8b 55 08             	mov    0x8(%ebp),%edx
 387:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 38a:	0f b6 02             	movzbl (%edx),%eax
 38d:	84 c0                	test   %al,%al
 38f:	75 17                	jne    3a8 <strcmp+0x28>
 391:	eb 3a                	jmp    3cd <strcmp+0x4d>
 393:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 397:	90                   	nop
 398:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 39c:	83 c2 01             	add    $0x1,%edx
 39f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 3a2:	84 c0                	test   %al,%al
 3a4:	74 1a                	je     3c0 <strcmp+0x40>
    p++, q++;
 3a6:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
 3a8:	0f b6 19             	movzbl (%ecx),%ebx
 3ab:	38 c3                	cmp    %al,%bl
 3ad:	74 e9                	je     398 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 3af:	29 d8                	sub    %ebx,%eax
}
 3b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 3b4:	c9                   	leave  
 3b5:	c3                   	ret    
 3b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3bd:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
 3c0:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 3c4:	31 c0                	xor    %eax,%eax
 3c6:	29 d8                	sub    %ebx,%eax
}
 3c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 3cb:	c9                   	leave  
 3cc:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
 3cd:	0f b6 19             	movzbl (%ecx),%ebx
 3d0:	31 c0                	xor    %eax,%eax
 3d2:	eb db                	jmp    3af <strcmp+0x2f>
 3d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3df:	90                   	nop

000003e0 <strlen>:

uint
strlen(const char *s)
{
 3e0:	55                   	push   %ebp
 3e1:	89 e5                	mov    %esp,%ebp
 3e3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 3e6:	80 3a 00             	cmpb   $0x0,(%edx)
 3e9:	74 15                	je     400 <strlen+0x20>
 3eb:	31 c0                	xor    %eax,%eax
 3ed:	8d 76 00             	lea    0x0(%esi),%esi
 3f0:	83 c0 01             	add    $0x1,%eax
 3f3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 3f7:	89 c1                	mov    %eax,%ecx
 3f9:	75 f5                	jne    3f0 <strlen+0x10>
    ;
  return n;
}
 3fb:	89 c8                	mov    %ecx,%eax
 3fd:	5d                   	pop    %ebp
 3fe:	c3                   	ret    
 3ff:	90                   	nop
  for(n = 0; s[n]; n++)
 400:	31 c9                	xor    %ecx,%ecx
}
 402:	5d                   	pop    %ebp
 403:	89 c8                	mov    %ecx,%eax
 405:	c3                   	ret    
 406:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 40d:	8d 76 00             	lea    0x0(%esi),%esi

00000410 <memset>:

void*
memset(void *dst, int c, uint n)
{
 410:	55                   	push   %ebp
 411:	89 e5                	mov    %esp,%ebp
 413:	57                   	push   %edi
 414:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 417:	8b 4d 10             	mov    0x10(%ebp),%ecx
 41a:	8b 45 0c             	mov    0xc(%ebp),%eax
 41d:	89 d7                	mov    %edx,%edi
 41f:	fc                   	cld    
 420:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 422:	8b 7d fc             	mov    -0x4(%ebp),%edi
 425:	89 d0                	mov    %edx,%eax
 427:	c9                   	leave  
 428:	c3                   	ret    
 429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000430 <strchr>:

char*
strchr(const char *s, char c)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	8b 45 08             	mov    0x8(%ebp),%eax
 436:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 43a:	0f b6 10             	movzbl (%eax),%edx
 43d:	84 d2                	test   %dl,%dl
 43f:	75 12                	jne    453 <strchr+0x23>
 441:	eb 1d                	jmp    460 <strchr+0x30>
 443:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 447:	90                   	nop
 448:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 44c:	83 c0 01             	add    $0x1,%eax
 44f:	84 d2                	test   %dl,%dl
 451:	74 0d                	je     460 <strchr+0x30>
    if(*s == c)
 453:	38 d1                	cmp    %dl,%cl
 455:	75 f1                	jne    448 <strchr+0x18>
      return (char*)s;
  return 0;
}
 457:	5d                   	pop    %ebp
 458:	c3                   	ret    
 459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 460:	31 c0                	xor    %eax,%eax
}
 462:	5d                   	pop    %ebp
 463:	c3                   	ret    
 464:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 46b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 46f:	90                   	nop

00000470 <gets>:

char*
gets(char *buf, int max)
{
 470:	55                   	push   %ebp
 471:	89 e5                	mov    %esp,%ebp
 473:	57                   	push   %edi
 474:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 475:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 478:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 479:	31 db                	xor    %ebx,%ebx
{
 47b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 47e:	eb 27                	jmp    4a7 <gets+0x37>
    cc = read(0, &c, 1);
 480:	83 ec 04             	sub    $0x4,%esp
 483:	6a 01                	push   $0x1
 485:	57                   	push   %edi
 486:	6a 00                	push   $0x0
 488:	e8 2e 01 00 00       	call   5bb <read>
    if(cc < 1)
 48d:	83 c4 10             	add    $0x10,%esp
 490:	85 c0                	test   %eax,%eax
 492:	7e 1d                	jle    4b1 <gets+0x41>
      break;
    buf[i++] = c;
 494:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 498:	8b 55 08             	mov    0x8(%ebp),%edx
 49b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 49f:	3c 0a                	cmp    $0xa,%al
 4a1:	74 1d                	je     4c0 <gets+0x50>
 4a3:	3c 0d                	cmp    $0xd,%al
 4a5:	74 19                	je     4c0 <gets+0x50>
  for(i=0; i+1 < max; ){
 4a7:	89 de                	mov    %ebx,%esi
 4a9:	83 c3 01             	add    $0x1,%ebx
 4ac:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 4af:	7c cf                	jl     480 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 4b1:	8b 45 08             	mov    0x8(%ebp),%eax
 4b4:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 4b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4bb:	5b                   	pop    %ebx
 4bc:	5e                   	pop    %esi
 4bd:	5f                   	pop    %edi
 4be:	5d                   	pop    %ebp
 4bf:	c3                   	ret    
  buf[i] = '\0';
 4c0:	8b 45 08             	mov    0x8(%ebp),%eax
 4c3:	89 de                	mov    %ebx,%esi
 4c5:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 4c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4cc:	5b                   	pop    %ebx
 4cd:	5e                   	pop    %esi
 4ce:	5f                   	pop    %edi
 4cf:	5d                   	pop    %ebp
 4d0:	c3                   	ret    
 4d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4df:	90                   	nop

000004e0 <stat>:

int
stat(const char *n, struct stat *st)
{
 4e0:	55                   	push   %ebp
 4e1:	89 e5                	mov    %esp,%ebp
 4e3:	56                   	push   %esi
 4e4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4e5:	83 ec 08             	sub    $0x8,%esp
 4e8:	6a 00                	push   $0x0
 4ea:	ff 75 08             	push   0x8(%ebp)
 4ed:	e8 f1 00 00 00       	call   5e3 <open>
  if(fd < 0)
 4f2:	83 c4 10             	add    $0x10,%esp
 4f5:	85 c0                	test   %eax,%eax
 4f7:	78 27                	js     520 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 4f9:	83 ec 08             	sub    $0x8,%esp
 4fc:	ff 75 0c             	push   0xc(%ebp)
 4ff:	89 c3                	mov    %eax,%ebx
 501:	50                   	push   %eax
 502:	e8 f4 00 00 00       	call   5fb <fstat>
  close(fd);
 507:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 50a:	89 c6                	mov    %eax,%esi
  close(fd);
 50c:	e8 ba 00 00 00       	call   5cb <close>
  return r;
 511:	83 c4 10             	add    $0x10,%esp
}
 514:	8d 65 f8             	lea    -0x8(%ebp),%esp
 517:	89 f0                	mov    %esi,%eax
 519:	5b                   	pop    %ebx
 51a:	5e                   	pop    %esi
 51b:	5d                   	pop    %ebp
 51c:	c3                   	ret    
 51d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 520:	be ff ff ff ff       	mov    $0xffffffff,%esi
 525:	eb ed                	jmp    514 <stat+0x34>
 527:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 52e:	66 90                	xchg   %ax,%ax

00000530 <atoi>:

int
atoi(const char *s)
{
 530:	55                   	push   %ebp
 531:	89 e5                	mov    %esp,%ebp
 533:	53                   	push   %ebx
 534:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 537:	0f be 02             	movsbl (%edx),%eax
 53a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 53d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 540:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 545:	77 1e                	ja     565 <atoi+0x35>
 547:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 54e:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 550:	83 c2 01             	add    $0x1,%edx
 553:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 556:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 55a:	0f be 02             	movsbl (%edx),%eax
 55d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 560:	80 fb 09             	cmp    $0x9,%bl
 563:	76 eb                	jbe    550 <atoi+0x20>
  return n;
}
 565:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 568:	89 c8                	mov    %ecx,%eax
 56a:	c9                   	leave  
 56b:	c3                   	ret    
 56c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000570 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 570:	55                   	push   %ebp
 571:	89 e5                	mov    %esp,%ebp
 573:	57                   	push   %edi
 574:	8b 45 10             	mov    0x10(%ebp),%eax
 577:	8b 55 08             	mov    0x8(%ebp),%edx
 57a:	56                   	push   %esi
 57b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 57e:	85 c0                	test   %eax,%eax
 580:	7e 13                	jle    595 <memmove+0x25>
 582:	01 d0                	add    %edx,%eax
  dst = vdst;
 584:	89 d7                	mov    %edx,%edi
 586:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 58d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 590:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 591:	39 f8                	cmp    %edi,%eax
 593:	75 fb                	jne    590 <memmove+0x20>
  return vdst;
}
 595:	5e                   	pop    %esi
 596:	89 d0                	mov    %edx,%eax
 598:	5f                   	pop    %edi
 599:	5d                   	pop    %ebp
 59a:	c3                   	ret    

0000059b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 59b:	b8 01 00 00 00       	mov    $0x1,%eax
 5a0:	cd 40                	int    $0x40
 5a2:	c3                   	ret    

000005a3 <exit>:
SYSCALL(exit)
 5a3:	b8 02 00 00 00       	mov    $0x2,%eax
 5a8:	cd 40                	int    $0x40
 5aa:	c3                   	ret    

000005ab <wait>:
SYSCALL(wait)
 5ab:	b8 03 00 00 00       	mov    $0x3,%eax
 5b0:	cd 40                	int    $0x40
 5b2:	c3                   	ret    

000005b3 <pipe>:
SYSCALL(pipe)
 5b3:	b8 04 00 00 00       	mov    $0x4,%eax
 5b8:	cd 40                	int    $0x40
 5ba:	c3                   	ret    

000005bb <read>:
SYSCALL(read)
 5bb:	b8 05 00 00 00       	mov    $0x5,%eax
 5c0:	cd 40                	int    $0x40
 5c2:	c3                   	ret    

000005c3 <write>:
SYSCALL(write)
 5c3:	b8 10 00 00 00       	mov    $0x10,%eax
 5c8:	cd 40                	int    $0x40
 5ca:	c3                   	ret    

000005cb <close>:
SYSCALL(close)
 5cb:	b8 15 00 00 00       	mov    $0x15,%eax
 5d0:	cd 40                	int    $0x40
 5d2:	c3                   	ret    

000005d3 <kill>:
SYSCALL(kill)
 5d3:	b8 06 00 00 00       	mov    $0x6,%eax
 5d8:	cd 40                	int    $0x40
 5da:	c3                   	ret    

000005db <exec>:
SYSCALL(exec)
 5db:	b8 07 00 00 00       	mov    $0x7,%eax
 5e0:	cd 40                	int    $0x40
 5e2:	c3                   	ret    

000005e3 <open>:
SYSCALL(open)
 5e3:	b8 0f 00 00 00       	mov    $0xf,%eax
 5e8:	cd 40                	int    $0x40
 5ea:	c3                   	ret    

000005eb <mknod>:
SYSCALL(mknod)
 5eb:	b8 11 00 00 00       	mov    $0x11,%eax
 5f0:	cd 40                	int    $0x40
 5f2:	c3                   	ret    

000005f3 <unlink>:
SYSCALL(unlink)
 5f3:	b8 12 00 00 00       	mov    $0x12,%eax
 5f8:	cd 40                	int    $0x40
 5fa:	c3                   	ret    

000005fb <fstat>:
SYSCALL(fstat)
 5fb:	b8 08 00 00 00       	mov    $0x8,%eax
 600:	cd 40                	int    $0x40
 602:	c3                   	ret    

00000603 <link>:
SYSCALL(link)
 603:	b8 13 00 00 00       	mov    $0x13,%eax
 608:	cd 40                	int    $0x40
 60a:	c3                   	ret    

0000060b <mkdir>:
SYSCALL(mkdir)
 60b:	b8 14 00 00 00       	mov    $0x14,%eax
 610:	cd 40                	int    $0x40
 612:	c3                   	ret    

00000613 <chdir>:
SYSCALL(chdir)
 613:	b8 09 00 00 00       	mov    $0x9,%eax
 618:	cd 40                	int    $0x40
 61a:	c3                   	ret    

0000061b <dup>:
SYSCALL(dup)
 61b:	b8 0a 00 00 00       	mov    $0xa,%eax
 620:	cd 40                	int    $0x40
 622:	c3                   	ret    

00000623 <getpid>:
SYSCALL(getpid)
 623:	b8 0b 00 00 00       	mov    $0xb,%eax
 628:	cd 40                	int    $0x40
 62a:	c3                   	ret    

0000062b <sbrk>:
SYSCALL(sbrk)
 62b:	b8 0c 00 00 00       	mov    $0xc,%eax
 630:	cd 40                	int    $0x40
 632:	c3                   	ret    

00000633 <sleep>:
SYSCALL(sleep)
 633:	b8 0d 00 00 00       	mov    $0xd,%eax
 638:	cd 40                	int    $0x40
 63a:	c3                   	ret    

0000063b <uptime>:
SYSCALL(uptime)
 63b:	b8 0e 00 00 00       	mov    $0xe,%eax
 640:	cd 40                	int    $0x40
 642:	c3                   	ret    

00000643 <waitx>:
SYSCALL(waitx)
 643:	b8 16 00 00 00       	mov    $0x16,%eax
 648:	cd 40                	int    $0x40
 64a:	c3                   	ret    

0000064b <getps>:
SYSCALL(getps)
 64b:	b8 17 00 00 00       	mov    $0x17,%eax
 650:	cd 40                	int    $0x40
 652:	c3                   	ret    

00000653 <clone>:
/* for thread */
SYSCALL(clone)
 653:	b8 19 00 00 00       	mov    $0x19,%eax
 658:	cd 40                	int    $0x40
 65a:	c3                   	ret    

0000065b <join>:
SYSCALL(join)
 65b:	b8 1a 00 00 00       	mov    $0x1a,%eax
 660:	cd 40                	int    $0x40
 662:	c3                   	ret    

00000663 <gettid>:
SYSCALL(gettid) 
 663:	b8 1b 00 00 00       	mov    $0x1b,%eax
 668:	cd 40                	int    $0x40
 66a:	c3                   	ret    
 66b:	66 90                	xchg   %ax,%ax
 66d:	66 90                	xchg   %ax,%ax
 66f:	90                   	nop

00000670 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 670:	55                   	push   %ebp
 671:	89 e5                	mov    %esp,%ebp
 673:	57                   	push   %edi
 674:	56                   	push   %esi
 675:	53                   	push   %ebx
 676:	83 ec 3c             	sub    $0x3c,%esp
 679:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 67c:	89 d1                	mov    %edx,%ecx
{
 67e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 681:	85 d2                	test   %edx,%edx
 683:	0f 89 7f 00 00 00    	jns    708 <printint+0x98>
 689:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 68d:	74 79                	je     708 <printint+0x98>
    neg = 1;
 68f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 696:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 698:	31 db                	xor    %ebx,%ebx
 69a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 69d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 6a0:	89 c8                	mov    %ecx,%eax
 6a2:	31 d2                	xor    %edx,%edx
 6a4:	89 cf                	mov    %ecx,%edi
 6a6:	f7 75 c4             	divl   -0x3c(%ebp)
 6a9:	0f b6 92 98 0b 00 00 	movzbl 0xb98(%edx),%edx
 6b0:	89 45 c0             	mov    %eax,-0x40(%ebp)
 6b3:	89 d8                	mov    %ebx,%eax
 6b5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 6b8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 6bb:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 6be:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 6c1:	76 dd                	jbe    6a0 <printint+0x30>
  if(neg)
 6c3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 6c6:	85 c9                	test   %ecx,%ecx
 6c8:	74 0c                	je     6d6 <printint+0x66>
    buf[i++] = '-';
 6ca:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 6cf:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 6d1:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 6d6:	8b 7d b8             	mov    -0x48(%ebp),%edi
 6d9:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 6dd:	eb 07                	jmp    6e6 <printint+0x76>
 6df:	90                   	nop
    putc(fd, buf[i]);
 6e0:	0f b6 13             	movzbl (%ebx),%edx
 6e3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 6e6:	83 ec 04             	sub    $0x4,%esp
 6e9:	88 55 d7             	mov    %dl,-0x29(%ebp)
 6ec:	6a 01                	push   $0x1
 6ee:	56                   	push   %esi
 6ef:	57                   	push   %edi
 6f0:	e8 ce fe ff ff       	call   5c3 <write>
  while(--i >= 0)
 6f5:	83 c4 10             	add    $0x10,%esp
 6f8:	39 de                	cmp    %ebx,%esi
 6fa:	75 e4                	jne    6e0 <printint+0x70>
}
 6fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6ff:	5b                   	pop    %ebx
 700:	5e                   	pop    %esi
 701:	5f                   	pop    %edi
 702:	5d                   	pop    %ebp
 703:	c3                   	ret    
 704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 708:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 70f:	eb 87                	jmp    698 <printint+0x28>
 711:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 718:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 71f:	90                   	nop

00000720 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 720:	55                   	push   %ebp
 721:	89 e5                	mov    %esp,%ebp
 723:	57                   	push   %edi
 724:	56                   	push   %esi
 725:	53                   	push   %ebx
 726:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 729:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
 72c:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
 72f:	0f b6 13             	movzbl (%ebx),%edx
 732:	84 d2                	test   %dl,%dl
 734:	74 6a                	je     7a0 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
 736:	8d 45 10             	lea    0x10(%ebp),%eax
 739:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 73c:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 73f:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
 741:	89 45 d0             	mov    %eax,-0x30(%ebp)
 744:	eb 36                	jmp    77c <printf+0x5c>
 746:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 74d:	8d 76 00             	lea    0x0(%esi),%esi
 750:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 753:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
 758:	83 f8 25             	cmp    $0x25,%eax
 75b:	74 15                	je     772 <printf+0x52>
  write(fd, &c, 1);
 75d:	83 ec 04             	sub    $0x4,%esp
 760:	88 55 e7             	mov    %dl,-0x19(%ebp)
 763:	6a 01                	push   $0x1
 765:	57                   	push   %edi
 766:	56                   	push   %esi
 767:	e8 57 fe ff ff       	call   5c3 <write>
 76c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
 76f:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 772:	0f b6 13             	movzbl (%ebx),%edx
 775:	83 c3 01             	add    $0x1,%ebx
 778:	84 d2                	test   %dl,%dl
 77a:	74 24                	je     7a0 <printf+0x80>
    c = fmt[i] & 0xff;
 77c:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 77f:	85 c9                	test   %ecx,%ecx
 781:	74 cd                	je     750 <printf+0x30>
      }
    } else if(state == '%'){
 783:	83 f9 25             	cmp    $0x25,%ecx
 786:	75 ea                	jne    772 <printf+0x52>
      if(c == 'd'){
 788:	83 f8 25             	cmp    $0x25,%eax
 78b:	0f 84 07 01 00 00    	je     898 <printf+0x178>
 791:	83 e8 63             	sub    $0x63,%eax
 794:	83 f8 15             	cmp    $0x15,%eax
 797:	77 17                	ja     7b0 <printf+0x90>
 799:	ff 24 85 40 0b 00 00 	jmp    *0xb40(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 7a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 7a3:	5b                   	pop    %ebx
 7a4:	5e                   	pop    %esi
 7a5:	5f                   	pop    %edi
 7a6:	5d                   	pop    %ebp
 7a7:	c3                   	ret    
 7a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7af:	90                   	nop
  write(fd, &c, 1);
 7b0:	83 ec 04             	sub    $0x4,%esp
 7b3:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 7b6:	6a 01                	push   $0x1
 7b8:	57                   	push   %edi
 7b9:	56                   	push   %esi
 7ba:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 7be:	e8 00 fe ff ff       	call   5c3 <write>
        putc(fd, c);
 7c3:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
 7c7:	83 c4 0c             	add    $0xc,%esp
 7ca:	88 55 e7             	mov    %dl,-0x19(%ebp)
 7cd:	6a 01                	push   $0x1
 7cf:	57                   	push   %edi
 7d0:	56                   	push   %esi
 7d1:	e8 ed fd ff ff       	call   5c3 <write>
        putc(fd, c);
 7d6:	83 c4 10             	add    $0x10,%esp
      state = 0;
 7d9:	31 c9                	xor    %ecx,%ecx
 7db:	eb 95                	jmp    772 <printf+0x52>
 7dd:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 7e0:	83 ec 0c             	sub    $0xc,%esp
 7e3:	b9 10 00 00 00       	mov    $0x10,%ecx
 7e8:	6a 00                	push   $0x0
 7ea:	8b 45 d0             	mov    -0x30(%ebp),%eax
 7ed:	8b 10                	mov    (%eax),%edx
 7ef:	89 f0                	mov    %esi,%eax
 7f1:	e8 7a fe ff ff       	call   670 <printint>
        ap++;
 7f6:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 7fa:	83 c4 10             	add    $0x10,%esp
      state = 0;
 7fd:	31 c9                	xor    %ecx,%ecx
 7ff:	e9 6e ff ff ff       	jmp    772 <printf+0x52>
 804:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 808:	8b 45 d0             	mov    -0x30(%ebp),%eax
 80b:	8b 10                	mov    (%eax),%edx
        ap++;
 80d:	83 c0 04             	add    $0x4,%eax
 810:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 813:	85 d2                	test   %edx,%edx
 815:	0f 84 8d 00 00 00    	je     8a8 <printf+0x188>
        while(*s != 0){
 81b:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
 81e:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
 820:	84 c0                	test   %al,%al
 822:	0f 84 4a ff ff ff    	je     772 <printf+0x52>
 828:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 82b:	89 d3                	mov    %edx,%ebx
 82d:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 830:	83 ec 04             	sub    $0x4,%esp
          s++;
 833:	83 c3 01             	add    $0x1,%ebx
 836:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 839:	6a 01                	push   $0x1
 83b:	57                   	push   %edi
 83c:	56                   	push   %esi
 83d:	e8 81 fd ff ff       	call   5c3 <write>
        while(*s != 0){
 842:	0f b6 03             	movzbl (%ebx),%eax
 845:	83 c4 10             	add    $0x10,%esp
 848:	84 c0                	test   %al,%al
 84a:	75 e4                	jne    830 <printf+0x110>
      state = 0;
 84c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 84f:	31 c9                	xor    %ecx,%ecx
 851:	e9 1c ff ff ff       	jmp    772 <printf+0x52>
 856:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 85d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 860:	83 ec 0c             	sub    $0xc,%esp
 863:	b9 0a 00 00 00       	mov    $0xa,%ecx
 868:	6a 01                	push   $0x1
 86a:	e9 7b ff ff ff       	jmp    7ea <printf+0xca>
 86f:	90                   	nop
        putc(fd, *ap);
 870:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
 873:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 876:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 878:	6a 01                	push   $0x1
 87a:	57                   	push   %edi
 87b:	56                   	push   %esi
        putc(fd, *ap);
 87c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 87f:	e8 3f fd ff ff       	call   5c3 <write>
        ap++;
 884:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 888:	83 c4 10             	add    $0x10,%esp
      state = 0;
 88b:	31 c9                	xor    %ecx,%ecx
 88d:	e9 e0 fe ff ff       	jmp    772 <printf+0x52>
 892:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
 898:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 89b:	83 ec 04             	sub    $0x4,%esp
 89e:	e9 2a ff ff ff       	jmp    7cd <printf+0xad>
 8a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 8a7:	90                   	nop
          s = "(null)";
 8a8:	ba 36 0b 00 00       	mov    $0xb36,%edx
        while(*s != 0){
 8ad:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 8b0:	b8 28 00 00 00       	mov    $0x28,%eax
 8b5:	89 d3                	mov    %edx,%ebx
 8b7:	e9 74 ff ff ff       	jmp    830 <printf+0x110>
 8bc:	66 90                	xchg   %ax,%ax
 8be:	66 90                	xchg   %ax,%ax

000008c0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8c0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8c1:	a1 dc 0e 00 00       	mov    0xedc,%eax
{
 8c6:	89 e5                	mov    %esp,%ebp
 8c8:	57                   	push   %edi
 8c9:	56                   	push   %esi
 8ca:	53                   	push   %ebx
 8cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 8ce:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8d8:	89 c2                	mov    %eax,%edx
 8da:	8b 00                	mov    (%eax),%eax
 8dc:	39 ca                	cmp    %ecx,%edx
 8de:	73 30                	jae    910 <free+0x50>
 8e0:	39 c1                	cmp    %eax,%ecx
 8e2:	72 04                	jb     8e8 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8e4:	39 c2                	cmp    %eax,%edx
 8e6:	72 f0                	jb     8d8 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 8e8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 8eb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 8ee:	39 f8                	cmp    %edi,%eax
 8f0:	74 30                	je     922 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 8f2:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 8f5:	8b 42 04             	mov    0x4(%edx),%eax
 8f8:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 8fb:	39 f1                	cmp    %esi,%ecx
 8fd:	74 3a                	je     939 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 8ff:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 901:	5b                   	pop    %ebx
  freep = p;
 902:	89 15 dc 0e 00 00    	mov    %edx,0xedc
}
 908:	5e                   	pop    %esi
 909:	5f                   	pop    %edi
 90a:	5d                   	pop    %ebp
 90b:	c3                   	ret    
 90c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 910:	39 c2                	cmp    %eax,%edx
 912:	72 c4                	jb     8d8 <free+0x18>
 914:	39 c1                	cmp    %eax,%ecx
 916:	73 c0                	jae    8d8 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
 918:	8b 73 fc             	mov    -0x4(%ebx),%esi
 91b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 91e:	39 f8                	cmp    %edi,%eax
 920:	75 d0                	jne    8f2 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
 922:	03 70 04             	add    0x4(%eax),%esi
 925:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 928:	8b 02                	mov    (%edx),%eax
 92a:	8b 00                	mov    (%eax),%eax
 92c:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 92f:	8b 42 04             	mov    0x4(%edx),%eax
 932:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 935:	39 f1                	cmp    %esi,%ecx
 937:	75 c6                	jne    8ff <free+0x3f>
    p->s.size += bp->s.size;
 939:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 93c:	89 15 dc 0e 00 00    	mov    %edx,0xedc
    p->s.size += bp->s.size;
 942:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 945:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 948:	89 0a                	mov    %ecx,(%edx)
}
 94a:	5b                   	pop    %ebx
 94b:	5e                   	pop    %esi
 94c:	5f                   	pop    %edi
 94d:	5d                   	pop    %ebp
 94e:	c3                   	ret    
 94f:	90                   	nop

00000950 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 950:	55                   	push   %ebp
 951:	89 e5                	mov    %esp,%ebp
 953:	57                   	push   %edi
 954:	56                   	push   %esi
 955:	53                   	push   %ebx
 956:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 959:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 95c:	8b 3d dc 0e 00 00    	mov    0xedc,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 962:	8d 70 07             	lea    0x7(%eax),%esi
 965:	c1 ee 03             	shr    $0x3,%esi
 968:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 96b:	85 ff                	test   %edi,%edi
 96d:	0f 84 9d 00 00 00    	je     a10 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 973:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 975:	8b 4a 04             	mov    0x4(%edx),%ecx
 978:	39 f1                	cmp    %esi,%ecx
 97a:	73 6a                	jae    9e6 <malloc+0x96>
 97c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 981:	39 de                	cmp    %ebx,%esi
 983:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 986:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 98d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 990:	eb 17                	jmp    9a9 <malloc+0x59>
 992:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 998:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 99a:	8b 48 04             	mov    0x4(%eax),%ecx
 99d:	39 f1                	cmp    %esi,%ecx
 99f:	73 4f                	jae    9f0 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9a1:	8b 3d dc 0e 00 00    	mov    0xedc,%edi
 9a7:	89 c2                	mov    %eax,%edx
 9a9:	39 d7                	cmp    %edx,%edi
 9ab:	75 eb                	jne    998 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 9ad:	83 ec 0c             	sub    $0xc,%esp
 9b0:	ff 75 e4             	push   -0x1c(%ebp)
 9b3:	e8 73 fc ff ff       	call   62b <sbrk>
  if(p == (char*)-1)
 9b8:	83 c4 10             	add    $0x10,%esp
 9bb:	83 f8 ff             	cmp    $0xffffffff,%eax
 9be:	74 1c                	je     9dc <malloc+0x8c>
  hp->s.size = nu;
 9c0:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 9c3:	83 ec 0c             	sub    $0xc,%esp
 9c6:	83 c0 08             	add    $0x8,%eax
 9c9:	50                   	push   %eax
 9ca:	e8 f1 fe ff ff       	call   8c0 <free>
  return freep;
 9cf:	8b 15 dc 0e 00 00    	mov    0xedc,%edx
      if((p = morecore(nunits)) == 0)
 9d5:	83 c4 10             	add    $0x10,%esp
 9d8:	85 d2                	test   %edx,%edx
 9da:	75 bc                	jne    998 <malloc+0x48>
        return 0;
  }
}
 9dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 9df:	31 c0                	xor    %eax,%eax
}
 9e1:	5b                   	pop    %ebx
 9e2:	5e                   	pop    %esi
 9e3:	5f                   	pop    %edi
 9e4:	5d                   	pop    %ebp
 9e5:	c3                   	ret    
    if(p->s.size >= nunits){
 9e6:	89 d0                	mov    %edx,%eax
 9e8:	89 fa                	mov    %edi,%edx
 9ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 9f0:	39 ce                	cmp    %ecx,%esi
 9f2:	74 4c                	je     a40 <malloc+0xf0>
        p->s.size -= nunits;
 9f4:	29 f1                	sub    %esi,%ecx
 9f6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 9f9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 9fc:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 9ff:	89 15 dc 0e 00 00    	mov    %edx,0xedc
}
 a05:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 a08:	83 c0 08             	add    $0x8,%eax
}
 a0b:	5b                   	pop    %ebx
 a0c:	5e                   	pop    %esi
 a0d:	5f                   	pop    %edi
 a0e:	5d                   	pop    %ebp
 a0f:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
 a10:	c7 05 dc 0e 00 00 e0 	movl   $0xee0,0xedc
 a17:	0e 00 00 
    base.s.size = 0;
 a1a:	bf e0 0e 00 00       	mov    $0xee0,%edi
    base.s.ptr = freep = prevp = &base;
 a1f:	c7 05 e0 0e 00 00 e0 	movl   $0xee0,0xee0
 a26:	0e 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a29:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 a2b:	c7 05 e4 0e 00 00 00 	movl   $0x0,0xee4
 a32:	00 00 00 
    if(p->s.size >= nunits){
 a35:	e9 42 ff ff ff       	jmp    97c <malloc+0x2c>
 a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 a40:	8b 08                	mov    (%eax),%ecx
 a42:	89 0a                	mov    %ecx,(%edx)
 a44:	eb b9                	jmp    9ff <malloc+0xaf>
 a46:	66 90                	xchg   %ax,%ax
 a48:	66 90                	xchg   %ax,%ax
 a4a:	66 90                	xchg   %ax,%ax
 a4c:	66 90                	xchg   %ax,%ax
 a4e:	66 90                	xchg   %ax,%ax

00000a50 <thread_create>:
#include "user.h"
#include "mmu.h"
#include "thread.h"

int thread_create(void (*function) (void *), void *arg)
{
 a50:	55                   	push   %ebp
 a51:	89 e5                	mov    %esp,%ebp
 a53:	83 ec 14             	sub    $0x14,%esp
    void *stack = malloc(PGSIZE);
 a56:	68 00 10 00 00       	push   $0x1000
 a5b:	e8 f0 fe ff ff       	call   950 <malloc>

    if (stack == 0)
 a60:	83 c4 10             	add    $0x10,%esp
 a63:	85 c0                	test   %eax,%eax
 a65:	74 25                	je     a8c <thread_create+0x3c>
        return -1;
    if ((uint)stack % PGSIZE != 0)
 a67:	89 c2                	mov    %eax,%edx
 a69:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
 a6f:	74 07                	je     a78 <thread_create+0x28>
        stack += PGSIZE - ((uint)stack % PGSIZE);
 a71:	29 d0                	sub    %edx,%eax
 a73:	05 00 10 00 00       	add    $0x1000,%eax
    
    return clone(function, arg, stack);
 a78:	83 ec 04             	sub    $0x4,%esp
 a7b:	50                   	push   %eax
 a7c:	ff 75 0c             	push   0xc(%ebp)
 a7f:	ff 75 08             	push   0x8(%ebp)
 a82:	e8 cc fb ff ff       	call   653 <clone>
 a87:	83 c4 10             	add    $0x10,%esp
}
 a8a:	c9                   	leave  
 a8b:	c3                   	ret    
 a8c:	c9                   	leave  
        return -1;
 a8d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 a92:	c3                   	ret    
 a93:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000aa0 <thread_join>:

int thread_join(int tid)
{
 aa0:	55                   	push   %ebp
 aa1:	89 e5                	mov    %esp,%ebp
 aa3:	53                   	push   %ebx
    int retval;
    void *stack;
    retval = join(tid, &stack);
 aa4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
 aa7:	83 ec 1c             	sub    $0x1c,%esp
    retval = join(tid, &stack);
 aaa:	50                   	push   %eax
 aab:	ff 75 08             	push   0x8(%ebp)
 aae:	e8 a8 fb ff ff       	call   65b <join>
 ab3:	89 c3                	mov    %eax,%ebx
    free(stack);
 ab5:	58                   	pop    %eax
 ab6:	ff 75 f4             	push   -0xc(%ebp)
 ab9:	e8 02 fe ff ff       	call   8c0 <free>
    return retval;
}
 abe:	89 d8                	mov    %ebx,%eax
 ac0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 ac3:	c9                   	leave  
 ac4:	c3                   	ret    
