
_proj0:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include"types.h"
#include"stat.h"
#include"user.h"
int main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	83 ec 10             	sub    $0x10,%esp
  12:	89 cb                	mov    %ecx,%ebx
	printf(1, "CS550 proj0 print in user space: ");
  14:	83 ec 08             	sub    $0x8,%esp
  17:	68 f4 07 00 00       	push   $0x7f4
  1c:	6a 01                	push   $0x1
  1e:	e8 18 04 00 00       	call   43b <printf>
  23:	83 c4 10             	add    $0x10,%esp
	for(int i = 1; i < argc; i++)
  26:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  2d:	eb 20                	jmp    4f <main+0x4f>
	{
		argv++;
  2f:	83 43 04 04          	addl   $0x4,0x4(%ebx)
		printf(1, "%s ", *argv);
  33:	8b 43 04             	mov    0x4(%ebx),%eax
  36:	8b 00                	mov    (%eax),%eax
  38:	83 ec 04             	sub    $0x4,%esp
  3b:	50                   	push   %eax
  3c:	68 16 08 00 00       	push   $0x816
  41:	6a 01                	push   $0x1
  43:	e8 f3 03 00 00       	call   43b <printf>
  48:	83 c4 10             	add    $0x10,%esp
	for(int i = 1; i < argc; i++)
  4b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  52:	3b 03                	cmp    (%ebx),%eax
  54:	7c d9                	jl     2f <main+0x2f>
	}
	printf(1, "\n");
  56:	83 ec 08             	sub    $0x8,%esp
  59:	68 1a 08 00 00       	push   $0x81a
  5e:	6a 01                	push   $0x1
  60:	e8 d6 03 00 00       	call   43b <printf>
  65:	83 c4 10             	add    $0x10,%esp
	exit();
  68:	e8 57 02 00 00       	call   2c4 <exit>

0000006d <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  6d:	55                   	push   %ebp
  6e:	89 e5                	mov    %esp,%ebp
  70:	57                   	push   %edi
  71:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  72:	8b 4d 08             	mov    0x8(%ebp),%ecx
  75:	8b 55 10             	mov    0x10(%ebp),%edx
  78:	8b 45 0c             	mov    0xc(%ebp),%eax
  7b:	89 cb                	mov    %ecx,%ebx
  7d:	89 df                	mov    %ebx,%edi
  7f:	89 d1                	mov    %edx,%ecx
  81:	fc                   	cld    
  82:	f3 aa                	rep stos %al,%es:(%edi)
  84:	89 ca                	mov    %ecx,%edx
  86:	89 fb                	mov    %edi,%ebx
  88:	89 5d 08             	mov    %ebx,0x8(%ebp)
  8b:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  8e:	90                   	nop
  8f:	5b                   	pop    %ebx
  90:	5f                   	pop    %edi
  91:	5d                   	pop    %ebp
  92:	c3                   	ret    

00000093 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  93:	55                   	push   %ebp
  94:	89 e5                	mov    %esp,%ebp
  96:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  99:	8b 45 08             	mov    0x8(%ebp),%eax
  9c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  9f:	90                   	nop
  a0:	8b 45 08             	mov    0x8(%ebp),%eax
  a3:	8d 50 01             	lea    0x1(%eax),%edx
  a6:	89 55 08             	mov    %edx,0x8(%ebp)
  a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  ac:	8d 4a 01             	lea    0x1(%edx),%ecx
  af:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  b2:	0f b6 12             	movzbl (%edx),%edx
  b5:	88 10                	mov    %dl,(%eax)
  b7:	0f b6 00             	movzbl (%eax),%eax
  ba:	84 c0                	test   %al,%al
  bc:	75 e2                	jne    a0 <strcpy+0xd>
    ;
  return os;
  be:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  c1:	c9                   	leave  
  c2:	c3                   	ret    

000000c3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c3:	55                   	push   %ebp
  c4:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  c6:	eb 08                	jmp    d0 <strcmp+0xd>
    p++, q++;
  c8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  cc:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
  d0:	8b 45 08             	mov    0x8(%ebp),%eax
  d3:	0f b6 00             	movzbl (%eax),%eax
  d6:	84 c0                	test   %al,%al
  d8:	74 10                	je     ea <strcmp+0x27>
  da:	8b 45 08             	mov    0x8(%ebp),%eax
  dd:	0f b6 10             	movzbl (%eax),%edx
  e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  e3:	0f b6 00             	movzbl (%eax),%eax
  e6:	38 c2                	cmp    %al,%dl
  e8:	74 de                	je     c8 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
  ea:	8b 45 08             	mov    0x8(%ebp),%eax
  ed:	0f b6 00             	movzbl (%eax),%eax
  f0:	0f b6 d0             	movzbl %al,%edx
  f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  f6:	0f b6 00             	movzbl (%eax),%eax
  f9:	0f b6 c0             	movzbl %al,%eax
  fc:	29 c2                	sub    %eax,%edx
  fe:	89 d0                	mov    %edx,%eax
}
 100:	5d                   	pop    %ebp
 101:	c3                   	ret    

00000102 <strlen>:

uint
strlen(char *s)
{
 102:	55                   	push   %ebp
 103:	89 e5                	mov    %esp,%ebp
 105:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 108:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 10f:	eb 04                	jmp    115 <strlen+0x13>
 111:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 115:	8b 55 fc             	mov    -0x4(%ebp),%edx
 118:	8b 45 08             	mov    0x8(%ebp),%eax
 11b:	01 d0                	add    %edx,%eax
 11d:	0f b6 00             	movzbl (%eax),%eax
 120:	84 c0                	test   %al,%al
 122:	75 ed                	jne    111 <strlen+0xf>
    ;
  return n;
 124:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 127:	c9                   	leave  
 128:	c3                   	ret    

00000129 <memset>:

void*
memset(void *dst, int c, uint n)
{
 129:	55                   	push   %ebp
 12a:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 12c:	8b 45 10             	mov    0x10(%ebp),%eax
 12f:	50                   	push   %eax
 130:	ff 75 0c             	pushl  0xc(%ebp)
 133:	ff 75 08             	pushl  0x8(%ebp)
 136:	e8 32 ff ff ff       	call   6d <stosb>
 13b:	83 c4 0c             	add    $0xc,%esp
  return dst;
 13e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 141:	c9                   	leave  
 142:	c3                   	ret    

00000143 <strchr>:

char*
strchr(const char *s, char c)
{
 143:	55                   	push   %ebp
 144:	89 e5                	mov    %esp,%ebp
 146:	83 ec 04             	sub    $0x4,%esp
 149:	8b 45 0c             	mov    0xc(%ebp),%eax
 14c:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 14f:	eb 14                	jmp    165 <strchr+0x22>
    if(*s == c)
 151:	8b 45 08             	mov    0x8(%ebp),%eax
 154:	0f b6 00             	movzbl (%eax),%eax
 157:	3a 45 fc             	cmp    -0x4(%ebp),%al
 15a:	75 05                	jne    161 <strchr+0x1e>
      return (char*)s;
 15c:	8b 45 08             	mov    0x8(%ebp),%eax
 15f:	eb 13                	jmp    174 <strchr+0x31>
  for(; *s; s++)
 161:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 165:	8b 45 08             	mov    0x8(%ebp),%eax
 168:	0f b6 00             	movzbl (%eax),%eax
 16b:	84 c0                	test   %al,%al
 16d:	75 e2                	jne    151 <strchr+0xe>
  return 0;
 16f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 174:	c9                   	leave  
 175:	c3                   	ret    

00000176 <gets>:

char*
gets(char *buf, int max)
{
 176:	55                   	push   %ebp
 177:	89 e5                	mov    %esp,%ebp
 179:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 17c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 183:	eb 42                	jmp    1c7 <gets+0x51>
    cc = read(0, &c, 1);
 185:	83 ec 04             	sub    $0x4,%esp
 188:	6a 01                	push   $0x1
 18a:	8d 45 ef             	lea    -0x11(%ebp),%eax
 18d:	50                   	push   %eax
 18e:	6a 00                	push   $0x0
 190:	e8 47 01 00 00       	call   2dc <read>
 195:	83 c4 10             	add    $0x10,%esp
 198:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 19b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 19f:	7e 33                	jle    1d4 <gets+0x5e>
      break;
    buf[i++] = c;
 1a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1a4:	8d 50 01             	lea    0x1(%eax),%edx
 1a7:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1aa:	89 c2                	mov    %eax,%edx
 1ac:	8b 45 08             	mov    0x8(%ebp),%eax
 1af:	01 c2                	add    %eax,%edx
 1b1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1b5:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1b7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1bb:	3c 0a                	cmp    $0xa,%al
 1bd:	74 16                	je     1d5 <gets+0x5f>
 1bf:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c3:	3c 0d                	cmp    $0xd,%al
 1c5:	74 0e                	je     1d5 <gets+0x5f>
  for(i=0; i+1 < max; ){
 1c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ca:	83 c0 01             	add    $0x1,%eax
 1cd:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1d0:	7c b3                	jl     185 <gets+0xf>
 1d2:	eb 01                	jmp    1d5 <gets+0x5f>
      break;
 1d4:	90                   	nop
      break;
  }
  buf[i] = '\0';
 1d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1d8:	8b 45 08             	mov    0x8(%ebp),%eax
 1db:	01 d0                	add    %edx,%eax
 1dd:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1e0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1e3:	c9                   	leave  
 1e4:	c3                   	ret    

000001e5 <stat>:

int
stat(char *n, struct stat *st)
{
 1e5:	55                   	push   %ebp
 1e6:	89 e5                	mov    %esp,%ebp
 1e8:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1eb:	83 ec 08             	sub    $0x8,%esp
 1ee:	6a 00                	push   $0x0
 1f0:	ff 75 08             	pushl  0x8(%ebp)
 1f3:	e8 0c 01 00 00       	call   304 <open>
 1f8:	83 c4 10             	add    $0x10,%esp
 1fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 202:	79 07                	jns    20b <stat+0x26>
    return -1;
 204:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 209:	eb 25                	jmp    230 <stat+0x4b>
  r = fstat(fd, st);
 20b:	83 ec 08             	sub    $0x8,%esp
 20e:	ff 75 0c             	pushl  0xc(%ebp)
 211:	ff 75 f4             	pushl  -0xc(%ebp)
 214:	e8 03 01 00 00       	call   31c <fstat>
 219:	83 c4 10             	add    $0x10,%esp
 21c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 21f:	83 ec 0c             	sub    $0xc,%esp
 222:	ff 75 f4             	pushl  -0xc(%ebp)
 225:	e8 c2 00 00 00       	call   2ec <close>
 22a:	83 c4 10             	add    $0x10,%esp
  return r;
 22d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 230:	c9                   	leave  
 231:	c3                   	ret    

00000232 <atoi>:

int
atoi(const char *s)
{
 232:	55                   	push   %ebp
 233:	89 e5                	mov    %esp,%ebp
 235:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 238:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 23f:	eb 25                	jmp    266 <atoi+0x34>
    n = n*10 + *s++ - '0';
 241:	8b 55 fc             	mov    -0x4(%ebp),%edx
 244:	89 d0                	mov    %edx,%eax
 246:	c1 e0 02             	shl    $0x2,%eax
 249:	01 d0                	add    %edx,%eax
 24b:	01 c0                	add    %eax,%eax
 24d:	89 c1                	mov    %eax,%ecx
 24f:	8b 45 08             	mov    0x8(%ebp),%eax
 252:	8d 50 01             	lea    0x1(%eax),%edx
 255:	89 55 08             	mov    %edx,0x8(%ebp)
 258:	0f b6 00             	movzbl (%eax),%eax
 25b:	0f be c0             	movsbl %al,%eax
 25e:	01 c8                	add    %ecx,%eax
 260:	83 e8 30             	sub    $0x30,%eax
 263:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 266:	8b 45 08             	mov    0x8(%ebp),%eax
 269:	0f b6 00             	movzbl (%eax),%eax
 26c:	3c 2f                	cmp    $0x2f,%al
 26e:	7e 0a                	jle    27a <atoi+0x48>
 270:	8b 45 08             	mov    0x8(%ebp),%eax
 273:	0f b6 00             	movzbl (%eax),%eax
 276:	3c 39                	cmp    $0x39,%al
 278:	7e c7                	jle    241 <atoi+0xf>
  return n;
 27a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 27d:	c9                   	leave  
 27e:	c3                   	ret    

0000027f <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 27f:	55                   	push   %ebp
 280:	89 e5                	mov    %esp,%ebp
 282:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 285:	8b 45 08             	mov    0x8(%ebp),%eax
 288:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 28b:	8b 45 0c             	mov    0xc(%ebp),%eax
 28e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 291:	eb 17                	jmp    2aa <memmove+0x2b>
    *dst++ = *src++;
 293:	8b 45 fc             	mov    -0x4(%ebp),%eax
 296:	8d 50 01             	lea    0x1(%eax),%edx
 299:	89 55 fc             	mov    %edx,-0x4(%ebp)
 29c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 29f:	8d 4a 01             	lea    0x1(%edx),%ecx
 2a2:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2a5:	0f b6 12             	movzbl (%edx),%edx
 2a8:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 2aa:	8b 45 10             	mov    0x10(%ebp),%eax
 2ad:	8d 50 ff             	lea    -0x1(%eax),%edx
 2b0:	89 55 10             	mov    %edx,0x10(%ebp)
 2b3:	85 c0                	test   %eax,%eax
 2b5:	7f dc                	jg     293 <memmove+0x14>
  return vdst;
 2b7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2ba:	c9                   	leave  
 2bb:	c3                   	ret    

000002bc <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2bc:	b8 01 00 00 00       	mov    $0x1,%eax
 2c1:	cd 40                	int    $0x40
 2c3:	c3                   	ret    

000002c4 <exit>:
SYSCALL(exit)
 2c4:	b8 02 00 00 00       	mov    $0x2,%eax
 2c9:	cd 40                	int    $0x40
 2cb:	c3                   	ret    

000002cc <wait>:
SYSCALL(wait)
 2cc:	b8 03 00 00 00       	mov    $0x3,%eax
 2d1:	cd 40                	int    $0x40
 2d3:	c3                   	ret    

000002d4 <pipe>:
SYSCALL(pipe)
 2d4:	b8 04 00 00 00       	mov    $0x4,%eax
 2d9:	cd 40                	int    $0x40
 2db:	c3                   	ret    

000002dc <read>:
SYSCALL(read)
 2dc:	b8 05 00 00 00       	mov    $0x5,%eax
 2e1:	cd 40                	int    $0x40
 2e3:	c3                   	ret    

000002e4 <write>:
SYSCALL(write)
 2e4:	b8 10 00 00 00       	mov    $0x10,%eax
 2e9:	cd 40                	int    $0x40
 2eb:	c3                   	ret    

000002ec <close>:
SYSCALL(close)
 2ec:	b8 15 00 00 00       	mov    $0x15,%eax
 2f1:	cd 40                	int    $0x40
 2f3:	c3                   	ret    

000002f4 <kill>:
SYSCALL(kill)
 2f4:	b8 06 00 00 00       	mov    $0x6,%eax
 2f9:	cd 40                	int    $0x40
 2fb:	c3                   	ret    

000002fc <exec>:
SYSCALL(exec)
 2fc:	b8 07 00 00 00       	mov    $0x7,%eax
 301:	cd 40                	int    $0x40
 303:	c3                   	ret    

00000304 <open>:
SYSCALL(open)
 304:	b8 0f 00 00 00       	mov    $0xf,%eax
 309:	cd 40                	int    $0x40
 30b:	c3                   	ret    

0000030c <mknod>:
SYSCALL(mknod)
 30c:	b8 11 00 00 00       	mov    $0x11,%eax
 311:	cd 40                	int    $0x40
 313:	c3                   	ret    

00000314 <unlink>:
SYSCALL(unlink)
 314:	b8 12 00 00 00       	mov    $0x12,%eax
 319:	cd 40                	int    $0x40
 31b:	c3                   	ret    

0000031c <fstat>:
SYSCALL(fstat)
 31c:	b8 08 00 00 00       	mov    $0x8,%eax
 321:	cd 40                	int    $0x40
 323:	c3                   	ret    

00000324 <link>:
SYSCALL(link)
 324:	b8 13 00 00 00       	mov    $0x13,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret    

0000032c <mkdir>:
SYSCALL(mkdir)
 32c:	b8 14 00 00 00       	mov    $0x14,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <chdir>:
SYSCALL(chdir)
 334:	b8 09 00 00 00       	mov    $0x9,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <dup>:
SYSCALL(dup)
 33c:	b8 0a 00 00 00       	mov    $0xa,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <getpid>:
SYSCALL(getpid)
 344:	b8 0b 00 00 00       	mov    $0xb,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <sbrk>:
SYSCALL(sbrk)
 34c:	b8 0c 00 00 00       	mov    $0xc,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <sleep>:
SYSCALL(sleep)
 354:	b8 0d 00 00 00       	mov    $0xd,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <uptime>:
SYSCALL(uptime)
 35c:	b8 0e 00 00 00       	mov    $0xe,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 364:	55                   	push   %ebp
 365:	89 e5                	mov    %esp,%ebp
 367:	83 ec 18             	sub    $0x18,%esp
 36a:	8b 45 0c             	mov    0xc(%ebp),%eax
 36d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 370:	83 ec 04             	sub    $0x4,%esp
 373:	6a 01                	push   $0x1
 375:	8d 45 f4             	lea    -0xc(%ebp),%eax
 378:	50                   	push   %eax
 379:	ff 75 08             	pushl  0x8(%ebp)
 37c:	e8 63 ff ff ff       	call   2e4 <write>
 381:	83 c4 10             	add    $0x10,%esp
}
 384:	90                   	nop
 385:	c9                   	leave  
 386:	c3                   	ret    

00000387 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 387:	55                   	push   %ebp
 388:	89 e5                	mov    %esp,%ebp
 38a:	53                   	push   %ebx
 38b:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 38e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 395:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 399:	74 17                	je     3b2 <printint+0x2b>
 39b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 39f:	79 11                	jns    3b2 <printint+0x2b>
    neg = 1;
 3a1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3a8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ab:	f7 d8                	neg    %eax
 3ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3b0:	eb 06                	jmp    3b8 <printint+0x31>
  } else {
    x = xx;
 3b2:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3b8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3bf:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3c2:	8d 41 01             	lea    0x1(%ecx),%eax
 3c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3c8:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3ce:	ba 00 00 00 00       	mov    $0x0,%edx
 3d3:	f7 f3                	div    %ebx
 3d5:	89 d0                	mov    %edx,%eax
 3d7:	0f b6 80 70 0a 00 00 	movzbl 0xa70(%eax),%eax
 3de:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3e2:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3e8:	ba 00 00 00 00       	mov    $0x0,%edx
 3ed:	f7 f3                	div    %ebx
 3ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3f2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3f6:	75 c7                	jne    3bf <printint+0x38>
  if(neg)
 3f8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3fc:	74 2d                	je     42b <printint+0xa4>
    buf[i++] = '-';
 3fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 401:	8d 50 01             	lea    0x1(%eax),%edx
 404:	89 55 f4             	mov    %edx,-0xc(%ebp)
 407:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 40c:	eb 1d                	jmp    42b <printint+0xa4>
    putc(fd, buf[i]);
 40e:	8d 55 dc             	lea    -0x24(%ebp),%edx
 411:	8b 45 f4             	mov    -0xc(%ebp),%eax
 414:	01 d0                	add    %edx,%eax
 416:	0f b6 00             	movzbl (%eax),%eax
 419:	0f be c0             	movsbl %al,%eax
 41c:	83 ec 08             	sub    $0x8,%esp
 41f:	50                   	push   %eax
 420:	ff 75 08             	pushl  0x8(%ebp)
 423:	e8 3c ff ff ff       	call   364 <putc>
 428:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 42b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 42f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 433:	79 d9                	jns    40e <printint+0x87>
}
 435:	90                   	nop
 436:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 439:	c9                   	leave  
 43a:	c3                   	ret    

0000043b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 43b:	55                   	push   %ebp
 43c:	89 e5                	mov    %esp,%ebp
 43e:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 441:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 448:	8d 45 0c             	lea    0xc(%ebp),%eax
 44b:	83 c0 04             	add    $0x4,%eax
 44e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 451:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 458:	e9 59 01 00 00       	jmp    5b6 <printf+0x17b>
    c = fmt[i] & 0xff;
 45d:	8b 55 0c             	mov    0xc(%ebp),%edx
 460:	8b 45 f0             	mov    -0x10(%ebp),%eax
 463:	01 d0                	add    %edx,%eax
 465:	0f b6 00             	movzbl (%eax),%eax
 468:	0f be c0             	movsbl %al,%eax
 46b:	25 ff 00 00 00       	and    $0xff,%eax
 470:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 473:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 477:	75 2c                	jne    4a5 <printf+0x6a>
      if(c == '%'){
 479:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 47d:	75 0c                	jne    48b <printf+0x50>
        state = '%';
 47f:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 486:	e9 27 01 00 00       	jmp    5b2 <printf+0x177>
      } else {
        putc(fd, c);
 48b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 48e:	0f be c0             	movsbl %al,%eax
 491:	83 ec 08             	sub    $0x8,%esp
 494:	50                   	push   %eax
 495:	ff 75 08             	pushl  0x8(%ebp)
 498:	e8 c7 fe ff ff       	call   364 <putc>
 49d:	83 c4 10             	add    $0x10,%esp
 4a0:	e9 0d 01 00 00       	jmp    5b2 <printf+0x177>
      }
    } else if(state == '%'){
 4a5:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4a9:	0f 85 03 01 00 00    	jne    5b2 <printf+0x177>
      if(c == 'd'){
 4af:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4b3:	75 1e                	jne    4d3 <printf+0x98>
        printint(fd, *ap, 10, 1);
 4b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4b8:	8b 00                	mov    (%eax),%eax
 4ba:	6a 01                	push   $0x1
 4bc:	6a 0a                	push   $0xa
 4be:	50                   	push   %eax
 4bf:	ff 75 08             	pushl  0x8(%ebp)
 4c2:	e8 c0 fe ff ff       	call   387 <printint>
 4c7:	83 c4 10             	add    $0x10,%esp
        ap++;
 4ca:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4ce:	e9 d8 00 00 00       	jmp    5ab <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4d3:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4d7:	74 06                	je     4df <printf+0xa4>
 4d9:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4dd:	75 1e                	jne    4fd <printf+0xc2>
        printint(fd, *ap, 16, 0);
 4df:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4e2:	8b 00                	mov    (%eax),%eax
 4e4:	6a 00                	push   $0x0
 4e6:	6a 10                	push   $0x10
 4e8:	50                   	push   %eax
 4e9:	ff 75 08             	pushl  0x8(%ebp)
 4ec:	e8 96 fe ff ff       	call   387 <printint>
 4f1:	83 c4 10             	add    $0x10,%esp
        ap++;
 4f4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4f8:	e9 ae 00 00 00       	jmp    5ab <printf+0x170>
      } else if(c == 's'){
 4fd:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 501:	75 43                	jne    546 <printf+0x10b>
        s = (char*)*ap;
 503:	8b 45 e8             	mov    -0x18(%ebp),%eax
 506:	8b 00                	mov    (%eax),%eax
 508:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 50b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 50f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 513:	75 25                	jne    53a <printf+0xff>
          s = "(null)";
 515:	c7 45 f4 1c 08 00 00 	movl   $0x81c,-0xc(%ebp)
        while(*s != 0){
 51c:	eb 1c                	jmp    53a <printf+0xff>
          putc(fd, *s);
 51e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 521:	0f b6 00             	movzbl (%eax),%eax
 524:	0f be c0             	movsbl %al,%eax
 527:	83 ec 08             	sub    $0x8,%esp
 52a:	50                   	push   %eax
 52b:	ff 75 08             	pushl  0x8(%ebp)
 52e:	e8 31 fe ff ff       	call   364 <putc>
 533:	83 c4 10             	add    $0x10,%esp
          s++;
 536:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 53a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 53d:	0f b6 00             	movzbl (%eax),%eax
 540:	84 c0                	test   %al,%al
 542:	75 da                	jne    51e <printf+0xe3>
 544:	eb 65                	jmp    5ab <printf+0x170>
        }
      } else if(c == 'c'){
 546:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 54a:	75 1d                	jne    569 <printf+0x12e>
        putc(fd, *ap);
 54c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 54f:	8b 00                	mov    (%eax),%eax
 551:	0f be c0             	movsbl %al,%eax
 554:	83 ec 08             	sub    $0x8,%esp
 557:	50                   	push   %eax
 558:	ff 75 08             	pushl  0x8(%ebp)
 55b:	e8 04 fe ff ff       	call   364 <putc>
 560:	83 c4 10             	add    $0x10,%esp
        ap++;
 563:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 567:	eb 42                	jmp    5ab <printf+0x170>
      } else if(c == '%'){
 569:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 56d:	75 17                	jne    586 <printf+0x14b>
        putc(fd, c);
 56f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 572:	0f be c0             	movsbl %al,%eax
 575:	83 ec 08             	sub    $0x8,%esp
 578:	50                   	push   %eax
 579:	ff 75 08             	pushl  0x8(%ebp)
 57c:	e8 e3 fd ff ff       	call   364 <putc>
 581:	83 c4 10             	add    $0x10,%esp
 584:	eb 25                	jmp    5ab <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 586:	83 ec 08             	sub    $0x8,%esp
 589:	6a 25                	push   $0x25
 58b:	ff 75 08             	pushl  0x8(%ebp)
 58e:	e8 d1 fd ff ff       	call   364 <putc>
 593:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 596:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 599:	0f be c0             	movsbl %al,%eax
 59c:	83 ec 08             	sub    $0x8,%esp
 59f:	50                   	push   %eax
 5a0:	ff 75 08             	pushl  0x8(%ebp)
 5a3:	e8 bc fd ff ff       	call   364 <putc>
 5a8:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5ab:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 5b2:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5b6:	8b 55 0c             	mov    0xc(%ebp),%edx
 5b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5bc:	01 d0                	add    %edx,%eax
 5be:	0f b6 00             	movzbl (%eax),%eax
 5c1:	84 c0                	test   %al,%al
 5c3:	0f 85 94 fe ff ff    	jne    45d <printf+0x22>
    }
  }
}
 5c9:	90                   	nop
 5ca:	c9                   	leave  
 5cb:	c3                   	ret    

000005cc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5cc:	55                   	push   %ebp
 5cd:	89 e5                	mov    %esp,%ebp
 5cf:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5d2:	8b 45 08             	mov    0x8(%ebp),%eax
 5d5:	83 e8 08             	sub    $0x8,%eax
 5d8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5db:	a1 8c 0a 00 00       	mov    0xa8c,%eax
 5e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5e3:	eb 24                	jmp    609 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5e8:	8b 00                	mov    (%eax),%eax
 5ea:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5ed:	77 12                	ja     601 <free+0x35>
 5ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5f2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5f5:	77 24                	ja     61b <free+0x4f>
 5f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5fa:	8b 00                	mov    (%eax),%eax
 5fc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5ff:	77 1a                	ja     61b <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 601:	8b 45 fc             	mov    -0x4(%ebp),%eax
 604:	8b 00                	mov    (%eax),%eax
 606:	89 45 fc             	mov    %eax,-0x4(%ebp)
 609:	8b 45 f8             	mov    -0x8(%ebp),%eax
 60c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 60f:	76 d4                	jbe    5e5 <free+0x19>
 611:	8b 45 fc             	mov    -0x4(%ebp),%eax
 614:	8b 00                	mov    (%eax),%eax
 616:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 619:	76 ca                	jbe    5e5 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 61b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 61e:	8b 40 04             	mov    0x4(%eax),%eax
 621:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 628:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62b:	01 c2                	add    %eax,%edx
 62d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 630:	8b 00                	mov    (%eax),%eax
 632:	39 c2                	cmp    %eax,%edx
 634:	75 24                	jne    65a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 636:	8b 45 f8             	mov    -0x8(%ebp),%eax
 639:	8b 50 04             	mov    0x4(%eax),%edx
 63c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63f:	8b 00                	mov    (%eax),%eax
 641:	8b 40 04             	mov    0x4(%eax),%eax
 644:	01 c2                	add    %eax,%edx
 646:	8b 45 f8             	mov    -0x8(%ebp),%eax
 649:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 64c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64f:	8b 00                	mov    (%eax),%eax
 651:	8b 10                	mov    (%eax),%edx
 653:	8b 45 f8             	mov    -0x8(%ebp),%eax
 656:	89 10                	mov    %edx,(%eax)
 658:	eb 0a                	jmp    664 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 65a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65d:	8b 10                	mov    (%eax),%edx
 65f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 662:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 664:	8b 45 fc             	mov    -0x4(%ebp),%eax
 667:	8b 40 04             	mov    0x4(%eax),%eax
 66a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 671:	8b 45 fc             	mov    -0x4(%ebp),%eax
 674:	01 d0                	add    %edx,%eax
 676:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 679:	75 20                	jne    69b <free+0xcf>
    p->s.size += bp->s.size;
 67b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67e:	8b 50 04             	mov    0x4(%eax),%edx
 681:	8b 45 f8             	mov    -0x8(%ebp),%eax
 684:	8b 40 04             	mov    0x4(%eax),%eax
 687:	01 c2                	add    %eax,%edx
 689:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 68f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 692:	8b 10                	mov    (%eax),%edx
 694:	8b 45 fc             	mov    -0x4(%ebp),%eax
 697:	89 10                	mov    %edx,(%eax)
 699:	eb 08                	jmp    6a3 <free+0xd7>
  } else
    p->s.ptr = bp;
 69b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6a1:	89 10                	mov    %edx,(%eax)
  freep = p;
 6a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a6:	a3 8c 0a 00 00       	mov    %eax,0xa8c
}
 6ab:	90                   	nop
 6ac:	c9                   	leave  
 6ad:	c3                   	ret    

000006ae <morecore>:

static Header*
morecore(uint nu)
{
 6ae:	55                   	push   %ebp
 6af:	89 e5                	mov    %esp,%ebp
 6b1:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6b4:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6bb:	77 07                	ja     6c4 <morecore+0x16>
    nu = 4096;
 6bd:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6c4:	8b 45 08             	mov    0x8(%ebp),%eax
 6c7:	c1 e0 03             	shl    $0x3,%eax
 6ca:	83 ec 0c             	sub    $0xc,%esp
 6cd:	50                   	push   %eax
 6ce:	e8 79 fc ff ff       	call   34c <sbrk>
 6d3:	83 c4 10             	add    $0x10,%esp
 6d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6d9:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6dd:	75 07                	jne    6e6 <morecore+0x38>
    return 0;
 6df:	b8 00 00 00 00       	mov    $0x0,%eax
 6e4:	eb 26                	jmp    70c <morecore+0x5e>
  hp = (Header*)p;
 6e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6ef:	8b 55 08             	mov    0x8(%ebp),%edx
 6f2:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6f8:	83 c0 08             	add    $0x8,%eax
 6fb:	83 ec 0c             	sub    $0xc,%esp
 6fe:	50                   	push   %eax
 6ff:	e8 c8 fe ff ff       	call   5cc <free>
 704:	83 c4 10             	add    $0x10,%esp
  return freep;
 707:	a1 8c 0a 00 00       	mov    0xa8c,%eax
}
 70c:	c9                   	leave  
 70d:	c3                   	ret    

0000070e <malloc>:

void*
malloc(uint nbytes)
{
 70e:	55                   	push   %ebp
 70f:	89 e5                	mov    %esp,%ebp
 711:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 714:	8b 45 08             	mov    0x8(%ebp),%eax
 717:	83 c0 07             	add    $0x7,%eax
 71a:	c1 e8 03             	shr    $0x3,%eax
 71d:	83 c0 01             	add    $0x1,%eax
 720:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 723:	a1 8c 0a 00 00       	mov    0xa8c,%eax
 728:	89 45 f0             	mov    %eax,-0x10(%ebp)
 72b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 72f:	75 23                	jne    754 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 731:	c7 45 f0 84 0a 00 00 	movl   $0xa84,-0x10(%ebp)
 738:	8b 45 f0             	mov    -0x10(%ebp),%eax
 73b:	a3 8c 0a 00 00       	mov    %eax,0xa8c
 740:	a1 8c 0a 00 00       	mov    0xa8c,%eax
 745:	a3 84 0a 00 00       	mov    %eax,0xa84
    base.s.size = 0;
 74a:	c7 05 88 0a 00 00 00 	movl   $0x0,0xa88
 751:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 754:	8b 45 f0             	mov    -0x10(%ebp),%eax
 757:	8b 00                	mov    (%eax),%eax
 759:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 75c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 75f:	8b 40 04             	mov    0x4(%eax),%eax
 762:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 765:	72 4d                	jb     7b4 <malloc+0xa6>
      if(p->s.size == nunits)
 767:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76a:	8b 40 04             	mov    0x4(%eax),%eax
 76d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 770:	75 0c                	jne    77e <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 772:	8b 45 f4             	mov    -0xc(%ebp),%eax
 775:	8b 10                	mov    (%eax),%edx
 777:	8b 45 f0             	mov    -0x10(%ebp),%eax
 77a:	89 10                	mov    %edx,(%eax)
 77c:	eb 26                	jmp    7a4 <malloc+0x96>
      else {
        p->s.size -= nunits;
 77e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 781:	8b 40 04             	mov    0x4(%eax),%eax
 784:	2b 45 ec             	sub    -0x14(%ebp),%eax
 787:	89 c2                	mov    %eax,%edx
 789:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78c:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 78f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 792:	8b 40 04             	mov    0x4(%eax),%eax
 795:	c1 e0 03             	shl    $0x3,%eax
 798:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 79b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79e:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7a1:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a7:	a3 8c 0a 00 00       	mov    %eax,0xa8c
      return (void*)(p + 1);
 7ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7af:	83 c0 08             	add    $0x8,%eax
 7b2:	eb 3b                	jmp    7ef <malloc+0xe1>
    }
    if(p == freep)
 7b4:	a1 8c 0a 00 00       	mov    0xa8c,%eax
 7b9:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7bc:	75 1e                	jne    7dc <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7be:	83 ec 0c             	sub    $0xc,%esp
 7c1:	ff 75 ec             	pushl  -0x14(%ebp)
 7c4:	e8 e5 fe ff ff       	call   6ae <morecore>
 7c9:	83 c4 10             	add    $0x10,%esp
 7cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7d3:	75 07                	jne    7dc <malloc+0xce>
        return 0;
 7d5:	b8 00 00 00 00       	mov    $0x0,%eax
 7da:	eb 13                	jmp    7ef <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7df:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e5:	8b 00                	mov    (%eax),%eax
 7e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7ea:	e9 6d ff ff ff       	jmp    75c <malloc+0x4e>
  }
}
 7ef:	c9                   	leave  
 7f0:	c3                   	ret    
