
obj/mpos-app:     file format elf32-i386


Disassembly of section .text:

00200000 <app_printf>:

static void app_printf(const char *format, ...) __attribute__((noinline));

static void
app_printf(const char *format, ...)
{
  200000:	83 ec 1c             	sub    $0x1c,%esp
	// That means that after the "asm" instruction (which causes the
	// interrupt), the system call's return value is in the 'pid'
	// variable, and we can just return that value!

	pid_t pid;
	asm volatile("int %1\n"
  200003:	cd 30                	int    $0x30
static void
app_printf(const char *format, ...)
{
	// set default color based on currently running process
	int color = sys_getpid();
	if (color < 0)
  200005:	85 c0                	test   %eax,%eax
  200007:	78 15                	js     20001e <app_printf+0x1e>
		color = 0x0700;
	else {
		static const uint8_t col[] = { 0x0E, 0x0F, 0x0C, 0x0A, 0x09 };
		color = col[color % sizeof(col)] << 8;
  200009:	b9 05 00 00 00       	mov    $0x5,%ecx
  20000e:	31 d2                	xor    %edx,%edx
  200010:	f7 f1                	div    %ecx
  200012:	0f b6 82 a0 06 20 00 	movzbl 0x2006a0(%edx),%eax
  200019:	c1 e0 08             	shl    $0x8,%eax
  20001c:	eb 05                	jmp    200023 <app_printf+0x23>
app_printf(const char *format, ...)
{
	// set default color based on currently running process
	int color = sys_getpid();
	if (color < 0)
		color = 0x0700;
  20001e:	b8 00 07 00 00       	mov    $0x700,%eax
		color = col[color % sizeof(col)] << 8;
	}

	va_list val;
	va_start(val, format);
	cursorpos = console_vprintf(cursorpos, color, format, val);
  200023:	8d 54 24 24          	lea    0x24(%esp),%edx
  200027:	89 54 24 0c          	mov    %edx,0xc(%esp)
  20002b:	8b 54 24 20          	mov    0x20(%esp),%edx
  20002f:	89 44 24 04          	mov    %eax,0x4(%esp)
  200033:	a1 00 00 06 00       	mov    0x60000,%eax
  200038:	89 54 24 08          	mov    %edx,0x8(%esp)
  20003c:	89 04 24             	mov    %eax,(%esp)
  20003f:	e8 ec 01 00 00       	call   200230 <console_vprintf>
  200044:	a3 00 00 06 00       	mov    %eax,0x60000
	va_end(val);
}
  200049:	83 c4 1c             	add    $0x1c,%esp
  20004c:	c3                   	ret    

0020004d <run_child>:
	}
}

void
run_child(void)
{
  20004d:	83 ec 2c             	sub    $0x2c,%esp
	int i;
	volatile int checker = 1; /* This variable checks that you correctly
  200050:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  200057:	00 
	// That means that after the "asm" instruction (which causes the
	// interrupt), the system call's return value is in the 'pid'
	// variable, and we can just return that value!

	pid_t pid;
	asm volatile("int %1\n"
  200058:	cd 30                	int    $0x30
				     gave this process a new stack.
				     If the parent's 'checker' changed value
				     after the child ran, there's a problem! */

	app_printf("Child process %d!\n", sys_getpid());
  20005a:	89 44 24 04          	mov    %eax,0x4(%esp)
  20005e:	c7 04 24 18 06 20 00 	movl   $0x200618,(%esp)
  200065:	e8 96 ff ff ff       	call   200000 <app_printf>
  20006a:	b8 14 00 00 00       	mov    $0x14,%eax

static inline void
sys_yield(void)
{
	// This system call has no return values, so there's no '=a' clause.
	asm volatile("int %0\n"
  20006f:	cd 32                	int    $0x32

	// Yield a couple times to help people test Exercise 3
	for (i = 0; i < 20; i++)
  200071:	48                   	dec    %eax
  200072:	75 fb                	jne    20006f <run_child+0x22>
	// the 'int' instruction.
	// You can load other registers with similar syntax; specifically:
	//	"a" = %eax, "b" = %ebx, "c" = %ecx, "d" = %edx,
	//	"S" = %esi, "D" = %edi.

	asm volatile("int %0\n"
  200074:	b8 e8 03 00 00       	mov    $0x3e8,%eax
  200079:	cd 33                	int    $0x33
  20007b:	eb fe                	jmp    20007b <run_child+0x2e>

0020007d <start>:

void run_child(void);

void
start(void)
{
  20007d:	53                   	push   %ebx
  20007e:	83 ec 28             	sub    $0x28,%esp
	volatile int checker = 0; /* This variable checks that you correctly
				     gave the child process a new stack. */
	pid_t p;
	int status;

	app_printf("About to start a new process...\n");
  200081:	c7 04 24 2b 06 20 00 	movl   $0x20062b,(%esp)
void run_child(void);

void
start(void)
{
	volatile int checker = 0; /* This variable checks that you correctly
  200088:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
  20008f:	00 
				     gave the child process a new stack. */
	pid_t p;
	int status;

	app_printf("About to start a new process...\n");
  200090:	e8 6b ff ff ff       	call   200000 <app_printf>
sys_fork(void)
{
	// This system call follows the same pattern as sys_getpid().

	pid_t result;
	asm volatile("int %1\n"
  200095:	cd 31                	int    $0x31

	p = sys_fork();
	if (p == 0)
  200097:	83 f8 00             	cmp    $0x0,%eax
  20009a:	89 c3                	mov    %eax,%ebx
  20009c:	75 05                	jne    2000a3 <start+0x26>
		run_child();
  20009e:	e8 aa ff ff ff       	call   20004d <run_child>
	else if (p > 0) {
  2000a3:	7e 52                	jle    2000f7 <start+0x7a>
	// That means that after the "asm" instruction (which causes the
	// interrupt), the system call's return value is in the 'pid'
	// variable, and we can just return that value!

	pid_t pid;
	asm volatile("int %1\n"
  2000a5:	cd 30                	int    $0x30
		app_printf("Main process %d!\n", sys_getpid());
  2000a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  2000ab:	c7 04 24 4c 06 20 00 	movl   $0x20064c,(%esp)
  2000b2:	e8 49 ff ff ff       	call   200000 <app_printf>

static inline int
sys_wait(pid_t pid)
{
	int retval;
	asm volatile("int %1\n"
  2000b7:	89 d8                	mov    %ebx,%eax
  2000b9:	cd 34                	int    $0x34
		do {
			status = sys_wait(p);
		} while (status == WAIT_TRYAGAIN);
  2000bb:	83 f8 fe             	cmp    $0xfffffffe,%eax
  2000be:	74 f7                	je     2000b7 <start+0x3a>
		app_printf("Child %d exited with status %d!\n", p, status);
  2000c0:	89 44 24 08          	mov    %eax,0x8(%esp)
  2000c4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  2000c8:	c7 04 24 5e 06 20 00 	movl   $0x20065e,(%esp)
  2000cf:	e8 2c ff ff ff       	call   200000 <app_printf>

		// Check whether the child process corrupted our stack.
		// (This check doesn't find all errors, but it helps.)
		if (checker != 0) {
  2000d4:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  2000d8:	85 c0                	test   %eax,%eax
  2000da:	74 15                	je     2000f1 <start+0x74>
			app_printf("Error: stack collision!\n");
  2000dc:	c7 04 24 7f 06 20 00 	movl   $0x20067f,(%esp)
  2000e3:	e8 18 ff ff ff       	call   200000 <app_printf>
	// the 'int' instruction.
	// You can load other registers with similar syntax; specifically:
	//	"a" = %eax, "b" = %ebx, "c" = %ecx, "d" = %edx,
	//	"S" = %esi, "D" = %edi.

	asm volatile("int %0\n"
  2000e8:	b8 01 00 00 00       	mov    $0x1,%eax
  2000ed:	cd 33                	int    $0x33
  2000ef:	eb fe                	jmp    2000ef <start+0x72>
  2000f1:	31 c0                	xor    %eax,%eax
  2000f3:	cd 33                	int    $0x33
  2000f5:	eb fe                	jmp    2000f5 <start+0x78>
			sys_exit(1);
		} else
			sys_exit(0);

	} else {
		app_printf("Error!\n");
  2000f7:	c7 04 24 98 06 20 00 	movl   $0x200698,(%esp)
  2000fe:	e8 fd fe ff ff       	call   200000 <app_printf>
  200103:	b8 01 00 00 00       	mov    $0x1,%eax
  200108:	cd 33                	int    $0x33
  20010a:	eb fe                	jmp    20010a <start+0x8d>

0020010c <console_putc>:
 *
 *   Print a message onto the console, starting at the given cursor position. */

static uint16_t *
console_putc(uint16_t *cursor, unsigned char c, int color)
{
  20010c:	56                   	push   %esi
	if (cursor >= CONSOLE_END)
		cursor = CONSOLE_BEGIN;
  20010d:	3d a0 8f 0b 00       	cmp    $0xb8fa0,%eax
 *
 *   Print a message onto the console, starting at the given cursor position. */

static uint16_t *
console_putc(uint16_t *cursor, unsigned char c, int color)
{
  200112:	53                   	push   %ebx
  200113:	89 c3                	mov    %eax,%ebx
	if (cursor >= CONSOLE_END)
		cursor = CONSOLE_BEGIN;
  200115:	b8 00 80 0b 00       	mov    $0xb8000,%eax
  20011a:	0f 43 d8             	cmovae %eax,%ebx
	if (c == '\n') {
  20011d:	80 fa 0a             	cmp    $0xa,%dl
  200120:	75 2c                	jne    20014e <console_putc+0x42>
		int pos = (cursor - CONSOLE_BEGIN) % 80;
  200122:	8d 83 00 80 f4 ff    	lea    -0xb8000(%ebx),%eax
  200128:	be 50 00 00 00       	mov    $0x50,%esi
  20012d:	d1 f8                	sar    %eax
		for (; pos != 80; pos++)
			*cursor++ = ' ' | color;
  20012f:	83 c9 20             	or     $0x20,%ecx
console_putc(uint16_t *cursor, unsigned char c, int color)
{
	if (cursor >= CONSOLE_END)
		cursor = CONSOLE_BEGIN;
	if (c == '\n') {
		int pos = (cursor - CONSOLE_BEGIN) % 80;
  200132:	99                   	cltd   
  200133:	f7 fe                	idiv   %esi
  200135:	6b c2 fe             	imul   $0xfffffffe,%edx,%eax
  200138:	8d 34 03             	lea    (%ebx,%eax,1),%esi
		for (; pos != 80; pos++)
			*cursor++ = ' ' | color;
  20013b:	66 89 0c 56          	mov    %cx,(%esi,%edx,2)
{
	if (cursor >= CONSOLE_END)
		cursor = CONSOLE_BEGIN;
	if (c == '\n') {
		int pos = (cursor - CONSOLE_BEGIN) % 80;
		for (; pos != 80; pos++)
  20013f:	42                   	inc    %edx
  200140:	83 fa 50             	cmp    $0x50,%edx
  200143:	75 f6                	jne    20013b <console_putc+0x2f>
  200145:	8d 84 03 a0 00 00 00 	lea    0xa0(%ebx,%eax,1),%eax
  20014c:	eb 0b                	jmp    200159 <console_putc+0x4d>
			*cursor++ = ' ' | color;
	} else
		*cursor++ = c | color;
  20014e:	0f b6 d2             	movzbl %dl,%edx
  200151:	09 ca                	or     %ecx,%edx
  200153:	8d 43 02             	lea    0x2(%ebx),%eax
  200156:	66 89 13             	mov    %dx,(%ebx)
	return cursor;
}
  200159:	5b                   	pop    %ebx
  20015a:	5e                   	pop    %esi
  20015b:	c3                   	ret    

0020015c <fill_numbuf>:
static const char lower_digits[] = "0123456789abcdef";

static char *
fill_numbuf(char *numbuf_end, uint32_t val, int base, const char *digits,
	    int precision)
{
  20015c:	56                   	push   %esi
  20015d:	53                   	push   %ebx
  20015e:	8b 74 24 0c          	mov    0xc(%esp),%esi
	*--numbuf_end = '\0';
	if (precision != 0 || val != 0)
  200162:	83 7c 24 10 00       	cmpl   $0x0,0x10(%esp)

static char *
fill_numbuf(char *numbuf_end, uint32_t val, int base, const char *digits,
	    int precision)
{
	*--numbuf_end = '\0';
  200167:	8d 58 ff             	lea    -0x1(%eax),%ebx
  20016a:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
	if (precision != 0 || val != 0)
  20016e:	75 04                	jne    200174 <fill_numbuf+0x18>
  200170:	85 d2                	test   %edx,%edx
  200172:	74 10                	je     200184 <fill_numbuf+0x28>
		do {
			*--numbuf_end = digits[val % base];
  200174:	89 d0                	mov    %edx,%eax
  200176:	31 d2                	xor    %edx,%edx
  200178:	f7 f1                	div    %ecx
  20017a:	4b                   	dec    %ebx
  20017b:	8a 14 16             	mov    (%esi,%edx,1),%dl
  20017e:	88 13                	mov    %dl,(%ebx)
			val /= base;
  200180:	89 c2                	mov    %eax,%edx
  200182:	eb ec                	jmp    200170 <fill_numbuf+0x14>
		} while (val != 0);
	return numbuf_end;
}
  200184:	89 d8                	mov    %ebx,%eax
  200186:	5b                   	pop    %ebx
  200187:	5e                   	pop    %esi
  200188:	c3                   	ret    

00200189 <memcpy>:
 *
 *   We must provide our own implementations of these basic functions. */

void *
memcpy(void *dst, const void *src, size_t n)
{
  200189:	53                   	push   %ebx
  20018a:	8b 44 24 08          	mov    0x8(%esp),%eax
	const char *s = (const char *) src;
	char *d = (char *) dst;
	while (n-- > 0)
  20018e:	31 d2                	xor    %edx,%edx
 *
 *   We must provide our own implementations of these basic functions. */

void *
memcpy(void *dst, const void *src, size_t n)
{
  200190:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
	const char *s = (const char *) src;
	char *d = (char *) dst;
	while (n-- > 0)
  200194:	3b 54 24 10          	cmp    0x10(%esp),%edx
  200198:	74 09                	je     2001a3 <memcpy+0x1a>
		*d++ = *s++;
  20019a:	8a 0c 13             	mov    (%ebx,%edx,1),%cl
  20019d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  2001a0:	42                   	inc    %edx
  2001a1:	eb f1                	jmp    200194 <memcpy+0xb>
	return dst;
}
  2001a3:	5b                   	pop    %ebx
  2001a4:	c3                   	ret    

002001a5 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  2001a5:	55                   	push   %ebp
  2001a6:	57                   	push   %edi
  2001a7:	56                   	push   %esi
  2001a8:	53                   	push   %ebx
  2001a9:	8b 44 24 14          	mov    0x14(%esp),%eax
  2001ad:	8b 5c 24 18          	mov    0x18(%esp),%ebx
  2001b1:	8b 6c 24 1c          	mov    0x1c(%esp),%ebp
	const char *s = (const char *) src;
	char *d = (char *) dst;
	if (s < d && s + n > d) {
  2001b5:	39 c3                	cmp    %eax,%ebx
  2001b7:	72 04                	jb     2001bd <memmove+0x18>
		s += n, d += n;
		while (n-- > 0)
  2001b9:	31 c9                	xor    %ecx,%ecx
  2001bb:	eb 24                	jmp    2001e1 <memmove+0x3c>
void *
memmove(void *dst, const void *src, size_t n)
{
	const char *s = (const char *) src;
	char *d = (char *) dst;
	if (s < d && s + n > d) {
  2001bd:	8d 34 2b             	lea    (%ebx,%ebp,1),%esi
  2001c0:	39 c6                	cmp    %eax,%esi
  2001c2:	76 f5                	jbe    2001b9 <memmove+0x14>
  2001c4:	89 e9                	mov    %ebp,%ecx
		s += n, d += n;
		while (n-- > 0)
  2001c6:	89 ea                	mov    %ebp,%edx
  2001c8:	f7 d9                	neg    %ecx
memmove(void *dst, const void *src, size_t n)
{
	const char *s = (const char *) src;
	char *d = (char *) dst;
	if (s < d && s + n > d) {
		s += n, d += n;
  2001ca:	8d 3c 28             	lea    (%eax,%ebp,1),%edi
  2001cd:	01 ce                	add    %ecx,%esi
		while (n-- > 0)
  2001cf:	4a                   	dec    %edx
  2001d0:	83 fa ff             	cmp    $0xffffffff,%edx
  2001d3:	74 19                	je     2001ee <memmove+0x49>
			*--d = *--s;
  2001d5:	8a 1c 16             	mov    (%esi,%edx,1),%bl
  2001d8:	8d 2c 0f             	lea    (%edi,%ecx,1),%ebp
  2001db:	88 5c 15 00          	mov    %bl,0x0(%ebp,%edx,1)
  2001df:	eb ee                	jmp    2001cf <memmove+0x2a>
	} else
		while (n-- > 0)
  2001e1:	39 e9                	cmp    %ebp,%ecx
  2001e3:	74 09                	je     2001ee <memmove+0x49>
			*d++ = *s++;
  2001e5:	8a 14 0b             	mov    (%ebx,%ecx,1),%dl
  2001e8:	88 14 08             	mov    %dl,(%eax,%ecx,1)
  2001eb:	41                   	inc    %ecx
  2001ec:	eb f3                	jmp    2001e1 <memmove+0x3c>
	return dst;
}
  2001ee:	5b                   	pop    %ebx
  2001ef:	5e                   	pop    %esi
  2001f0:	5f                   	pop    %edi
  2001f1:	5d                   	pop    %ebp
  2001f2:	c3                   	ret    

002001f3 <memset>:

void *
memset(void *v, int c, size_t n)
{
  2001f3:	8b 44 24 04          	mov    0x4(%esp),%eax
	char *p = (char *) v;
	while (n-- > 0)
  2001f7:	31 d2                	xor    %edx,%edx
	return dst;
}

void *
memset(void *v, int c, size_t n)
{
  2001f9:	8b 4c 24 08          	mov    0x8(%esp),%ecx
	char *p = (char *) v;
	while (n-- > 0)
  2001fd:	3b 54 24 0c          	cmp    0xc(%esp),%edx
  200201:	74 06                	je     200209 <memset+0x16>
		*p++ = c;
  200203:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  200206:	42                   	inc    %edx
  200207:	eb f4                	jmp    2001fd <memset+0xa>
	return v;
}
  200209:	c3                   	ret    

0020020a <strlen>:

size_t
strlen(const char *s)
{
  20020a:	8b 54 24 04          	mov    0x4(%esp),%edx
	size_t n;
	for (n = 0; *s != '\0'; ++s)
  20020e:	31 c0                	xor    %eax,%eax
  200210:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  200214:	74 03                	je     200219 <strlen+0xf>
		++n;
  200216:	40                   	inc    %eax
  200217:	eb f7                	jmp    200210 <strlen+0x6>
	return n;
}
  200219:	c3                   	ret    

0020021a <strnlen>:

size_t
strnlen(const char *s, size_t maxlen)
{
  20021a:	8b 54 24 04          	mov    0x4(%esp),%edx
	size_t n;
	for (n = 0; n != maxlen && *s != '\0'; ++s)
  20021e:	31 c0                	xor    %eax,%eax
  200220:	3b 44 24 08          	cmp    0x8(%esp),%eax
  200224:	74 09                	je     20022f <strnlen+0x15>
  200226:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  20022a:	74 03                	je     20022f <strnlen+0x15>
		++n;
  20022c:	40                   	inc    %eax
  20022d:	eb f1                	jmp    200220 <strnlen+0x6>
	return n;
}
  20022f:	c3                   	ret    

00200230 <console_vprintf>:
#define FLAG_PLUSPOSITIVE	(1<<4)
static const char flag_chars[] = "#0- +";

uint16_t *
console_vprintf(uint16_t *cursor, int color, const char *format, va_list val)
{
  200230:	55                   	push   %ebp
  200231:	57                   	push   %edi
  200232:	56                   	push   %esi
  200233:	53                   	push   %ebx
  200234:	83 ec 3c             	sub    $0x3c,%esp
  200237:	8b 6c 24 50          	mov    0x50(%esp),%ebp
  20023b:	8b 5c 24 5c          	mov    0x5c(%esp),%ebx
	int flags, width, zeros, precision, negative, numeric, len;
#define NUMBUFSIZ 20
	char numbuf[NUMBUFSIZ];
	char *data;

	for (; *format; ++format) {
  20023f:	8b 44 24 58          	mov    0x58(%esp),%eax
  200243:	0f b6 10             	movzbl (%eax),%edx
  200246:	84 d2                	test   %dl,%dl
  200248:	0f 84 94 03 00 00    	je     2005e2 <console_vprintf+0x3b2>
		if (*format != '%') {
  20024e:	80 fa 25             	cmp    $0x25,%dl
  200251:	74 12                	je     200265 <console_vprintf+0x35>
			cursor = console_putc(cursor, *format, color);
  200253:	8b 4c 24 54          	mov    0x54(%esp),%ecx
  200257:	89 e8                	mov    %ebp,%eax
  200259:	e8 ae fe ff ff       	call   20010c <console_putc>
  20025e:	89 c5                	mov    %eax,%ebp
			continue;
  200260:	e9 5d 03 00 00       	jmp    2005c2 <console_vprintf+0x392>
		}

		// process flags
		flags = 0;
		for (++format; *format; ++format) {
  200265:	ff 44 24 58          	incl   0x58(%esp)
			const char *flagc = flag_chars;
			while (*flagc != '\0' && *flagc != *format)
				++flagc;
			if (*flagc == '\0')
				break;
			flags |= (1 << (flagc - flag_chars));
  200269:	be 01 00 00 00       	mov    $0x1,%esi
			cursor = console_putc(cursor, *format, color);
			continue;
		}

		// process flags
		flags = 0;
  20026e:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  200275:	00 
		for (++format; *format; ++format) {
  200276:	8b 44 24 58          	mov    0x58(%esp),%eax
  20027a:	8a 00                	mov    (%eax),%al
  20027c:	84 c0                	test   %al,%al
  20027e:	74 16                	je     200296 <console_vprintf+0x66>
  200280:	b9 a8 06 20 00       	mov    $0x2006a8,%ecx
			const char *flagc = flag_chars;
			while (*flagc != '\0' && *flagc != *format)
  200285:	8a 11                	mov    (%ecx),%dl
  200287:	84 d2                	test   %dl,%dl
  200289:	74 0b                	je     200296 <console_vprintf+0x66>
  20028b:	38 c2                	cmp    %al,%dl
  20028d:	0f 84 38 03 00 00    	je     2005cb <console_vprintf+0x39b>
				++flagc;
  200293:	41                   	inc    %ecx
  200294:	eb ef                	jmp    200285 <console_vprintf+0x55>
			flags |= (1 << (flagc - flag_chars));
		}

		// process width
		width = -1;
		if (*format >= '1' && *format <= '9') {
  200296:	8d 50 cf             	lea    -0x31(%eax),%edx
  200299:	80 fa 08             	cmp    $0x8,%dl
  20029c:	77 2a                	ja     2002c8 <console_vprintf+0x98>
  20029e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  2002a5:	00 
			for (width = 0; *format >= '0' && *format <= '9'; )
  2002a6:	8b 44 24 58          	mov    0x58(%esp),%eax
  2002aa:	0f be 00             	movsbl (%eax),%eax
  2002ad:	8d 50 d0             	lea    -0x30(%eax),%edx
  2002b0:	80 fa 09             	cmp    $0x9,%dl
  2002b3:	77 2c                	ja     2002e1 <console_vprintf+0xb1>
				width = 10 * width + *format++ - '0';
  2002b5:	6b 74 24 0c 0a       	imul   $0xa,0xc(%esp),%esi
  2002ba:	ff 44 24 58          	incl   0x58(%esp)
  2002be:	8d 44 06 d0          	lea    -0x30(%esi,%eax,1),%eax
  2002c2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  2002c6:	eb de                	jmp    2002a6 <console_vprintf+0x76>
		} else if (*format == '*') {
  2002c8:	3c 2a                	cmp    $0x2a,%al
				break;
			flags |= (1 << (flagc - flag_chars));
		}

		// process width
		width = -1;
  2002ca:	c7 44 24 0c ff ff ff 	movl   $0xffffffff,0xc(%esp)
  2002d1:	ff 
		if (*format >= '1' && *format <= '9') {
			for (width = 0; *format >= '0' && *format <= '9'; )
				width = 10 * width + *format++ - '0';
		} else if (*format == '*') {
  2002d2:	75 0d                	jne    2002e1 <console_vprintf+0xb1>
			width = va_arg(val, int);
  2002d4:	8b 03                	mov    (%ebx),%eax
  2002d6:	83 c3 04             	add    $0x4,%ebx
			++format;
  2002d9:	ff 44 24 58          	incl   0x58(%esp)
		width = -1;
		if (*format >= '1' && *format <= '9') {
			for (width = 0; *format >= '0' && *format <= '9'; )
				width = 10 * width + *format++ - '0';
		} else if (*format == '*') {
			width = va_arg(val, int);
  2002dd:	89 44 24 0c          	mov    %eax,0xc(%esp)
			++format;
		}

		// process precision
		precision = -1;
		if (*format == '.') {
  2002e1:	8b 44 24 58          	mov    0x58(%esp),%eax
			width = va_arg(val, int);
			++format;
		}

		// process precision
		precision = -1;
  2002e5:	83 ce ff             	or     $0xffffffff,%esi
		if (*format == '.') {
  2002e8:	80 38 2e             	cmpb   $0x2e,(%eax)
  2002eb:	75 4f                	jne    20033c <console_vprintf+0x10c>
			++format;
			if (*format >= '0' && *format <= '9') {
  2002ed:	8b 7c 24 58          	mov    0x58(%esp),%edi
		}

		// process precision
		precision = -1;
		if (*format == '.') {
			++format;
  2002f1:	40                   	inc    %eax
			if (*format >= '0' && *format <= '9') {
  2002f2:	8a 57 01             	mov    0x1(%edi),%dl
  2002f5:	8d 4a d0             	lea    -0x30(%edx),%ecx
  2002f8:	80 f9 09             	cmp    $0x9,%cl
  2002fb:	77 22                	ja     20031f <console_vprintf+0xef>
  2002fd:	89 44 24 58          	mov    %eax,0x58(%esp)
  200301:	31 f6                	xor    %esi,%esi
				for (precision = 0; *format >= '0' && *format <= '9'; )
  200303:	8b 44 24 58          	mov    0x58(%esp),%eax
  200307:	0f be 00             	movsbl (%eax),%eax
  20030a:	8d 50 d0             	lea    -0x30(%eax),%edx
  20030d:	80 fa 09             	cmp    $0x9,%dl
  200310:	77 2a                	ja     20033c <console_vprintf+0x10c>
					precision = 10 * precision + *format++ - '0';
  200312:	6b f6 0a             	imul   $0xa,%esi,%esi
  200315:	ff 44 24 58          	incl   0x58(%esp)
  200319:	8d 74 06 d0          	lea    -0x30(%esi,%eax,1),%esi
  20031d:	eb e4                	jmp    200303 <console_vprintf+0xd3>
			} else if (*format == '*') {
  20031f:	80 fa 2a             	cmp    $0x2a,%dl
  200322:	75 12                	jne    200336 <console_vprintf+0x106>
				precision = va_arg(val, int);
  200324:	8b 33                	mov    (%ebx),%esi
  200326:	8d 43 04             	lea    0x4(%ebx),%eax
				++format;
  200329:	83 44 24 58 02       	addl   $0x2,0x58(%esp)
			++format;
			if (*format >= '0' && *format <= '9') {
				for (precision = 0; *format >= '0' && *format <= '9'; )
					precision = 10 * precision + *format++ - '0';
			} else if (*format == '*') {
				precision = va_arg(val, int);
  20032e:	89 c3                	mov    %eax,%ebx
				++format;
			}
			if (precision < 0)
  200330:	85 f6                	test   %esi,%esi
  200332:	79 08                	jns    20033c <console_vprintf+0x10c>
  200334:	eb 04                	jmp    20033a <console_vprintf+0x10a>
		}

		// process precision
		precision = -1;
		if (*format == '.') {
			++format;
  200336:	89 44 24 58          	mov    %eax,0x58(%esp)
			} else if (*format == '*') {
				precision = va_arg(val, int);
				++format;
			}
			if (precision < 0)
				precision = 0;
  20033a:	31 f6                	xor    %esi,%esi
		}

		// process main conversion character
		negative = 0;
		numeric = 0;
		switch (*format) {
  20033c:	8b 44 24 58          	mov    0x58(%esp),%eax
  200340:	8a 00                	mov    (%eax),%al
  200342:	3c 64                	cmp    $0x64,%al
  200344:	74 46                	je     20038c <console_vprintf+0x15c>
  200346:	7f 26                	jg     20036e <console_vprintf+0x13e>
  200348:	3c 58                	cmp    $0x58,%al
  20034a:	0f 84 9f 00 00 00    	je     2003ef <console_vprintf+0x1bf>
  200350:	3c 63                	cmp    $0x63,%al
  200352:	0f 84 c2 00 00 00    	je     20041a <console_vprintf+0x1ea>
  200358:	3c 43                	cmp    $0x43,%al
  20035a:	0f 85 ca 00 00 00    	jne    20042a <console_vprintf+0x1fa>
		}
		case 's':
			data = va_arg(val, char *);
			break;
		case 'C':
			color = va_arg(val, int);
  200360:	8b 03                	mov    (%ebx),%eax
  200362:	83 c3 04             	add    $0x4,%ebx
  200365:	89 44 24 54          	mov    %eax,0x54(%esp)
			goto done;
  200369:	e9 54 02 00 00       	jmp    2005c2 <console_vprintf+0x392>
		}

		// process main conversion character
		negative = 0;
		numeric = 0;
		switch (*format) {
  20036e:	3c 75                	cmp    $0x75,%al
  200370:	74 58                	je     2003ca <console_vprintf+0x19a>
  200372:	3c 78                	cmp    $0x78,%al
  200374:	74 69                	je     2003df <console_vprintf+0x1af>
  200376:	3c 73                	cmp    $0x73,%al
  200378:	0f 85 ac 00 00 00    	jne    20042a <console_vprintf+0x1fa>
			data = fill_numbuf(numbuf + NUMBUFSIZ, x, 16, upper_digits, precision);
			numeric = 1;
			break;
		}
		case 's':
			data = va_arg(val, char *);
  20037e:	8b 03                	mov    (%ebx),%eax
  200380:	83 c3 04             	add    $0x4,%ebx
  200383:	89 44 24 08          	mov    %eax,0x8(%esp)
  200387:	e9 bc 00 00 00       	jmp    200448 <console_vprintf+0x218>
		// process main conversion character
		negative = 0;
		numeric = 0;
		switch (*format) {
		case 'd': {
			int x = va_arg(val, int);
  20038c:	8d 7b 04             	lea    0x4(%ebx),%edi
  20038f:	8b 1b                	mov    (%ebx),%ebx
			data = fill_numbuf(numbuf + NUMBUFSIZ, x > 0 ? x : -x, 10, upper_digits, precision);
  200391:	b9 0a 00 00 00       	mov    $0xa,%ecx
  200396:	89 74 24 04          	mov    %esi,0x4(%esp)
  20039a:	c7 04 24 c4 06 20 00 	movl   $0x2006c4,(%esp)
  2003a1:	89 d8                	mov    %ebx,%eax
  2003a3:	c1 f8 1f             	sar    $0x1f,%eax
  2003a6:	89 c2                	mov    %eax,%edx
  2003a8:	31 da                	xor    %ebx,%edx
  2003aa:	29 c2                	sub    %eax,%edx
  2003ac:	8d 44 24 3c          	lea    0x3c(%esp),%eax
  2003b0:	e8 a7 fd ff ff       	call   20015c <fill_numbuf>
			if (x < 0)
				negative = 1;
  2003b5:	c1 eb 1f             	shr    $0x1f,%ebx
  2003b8:	89 d9                	mov    %ebx,%ecx
		// process main conversion character
		negative = 0;
		numeric = 0;
		switch (*format) {
		case 'd': {
			int x = va_arg(val, int);
  2003ba:	89 fb                	mov    %edi,%ebx
			data = fill_numbuf(numbuf + NUMBUFSIZ, x > 0 ? x : -x, 10, upper_digits, precision);
			if (x < 0)
				negative = 1;
			numeric = 1;
  2003bc:	bf 01 00 00 00       	mov    $0x1,%edi
		negative = 0;
		numeric = 0;
		switch (*format) {
		case 'd': {
			int x = va_arg(val, int);
			data = fill_numbuf(numbuf + NUMBUFSIZ, x > 0 ? x : -x, 10, upper_digits, precision);
  2003c1:	89 44 24 08          	mov    %eax,0x8(%esp)
  2003c5:	e9 82 00 00 00       	jmp    20044c <console_vprintf+0x21c>
				negative = 1;
			numeric = 1;
			break;
		}
		case 'u': {
			unsigned x = va_arg(val, unsigned);
  2003ca:	8d 7b 04             	lea    0x4(%ebx),%edi
			data = fill_numbuf(numbuf + NUMBUFSIZ, x, 10, upper_digits, precision);
  2003cd:	b9 0a 00 00 00       	mov    $0xa,%ecx
  2003d2:	89 74 24 04          	mov    %esi,0x4(%esp)
  2003d6:	c7 04 24 c4 06 20 00 	movl   $0x2006c4,(%esp)
  2003dd:	eb 23                	jmp    200402 <console_vprintf+0x1d2>
			numeric = 1;
			break;
		}
		case 'x': {
			unsigned x = va_arg(val, unsigned);
  2003df:	8d 7b 04             	lea    0x4(%ebx),%edi
			data = fill_numbuf(numbuf + NUMBUFSIZ, x, 16, lower_digits, precision);
  2003e2:	89 74 24 04          	mov    %esi,0x4(%esp)
  2003e6:	c7 04 24 b0 06 20 00 	movl   $0x2006b0,(%esp)
  2003ed:	eb 0e                	jmp    2003fd <console_vprintf+0x1cd>
			numeric = 1;
			break;
		}
		case 'X': {
			unsigned x = va_arg(val, unsigned);
  2003ef:	8d 7b 04             	lea    0x4(%ebx),%edi
			data = fill_numbuf(numbuf + NUMBUFSIZ, x, 16, upper_digits, precision);
  2003f2:	89 74 24 04          	mov    %esi,0x4(%esp)
  2003f6:	c7 04 24 c4 06 20 00 	movl   $0x2006c4,(%esp)
  2003fd:	b9 10 00 00 00       	mov    $0x10,%ecx
  200402:	8b 13                	mov    (%ebx),%edx
  200404:	8d 44 24 3c          	lea    0x3c(%esp),%eax
			data = fill_numbuf(numbuf + NUMBUFSIZ, x, 16, lower_digits, precision);
			numeric = 1;
			break;
		}
		case 'X': {
			unsigned x = va_arg(val, unsigned);
  200408:	89 fb                	mov    %edi,%ebx
			data = fill_numbuf(numbuf + NUMBUFSIZ, x, 16, upper_digits, precision);
			numeric = 1;
  20040a:	bf 01 00 00 00       	mov    $0x1,%edi
			numeric = 1;
			break;
		}
		case 'X': {
			unsigned x = va_arg(val, unsigned);
			data = fill_numbuf(numbuf + NUMBUFSIZ, x, 16, upper_digits, precision);
  20040f:	e8 48 fd ff ff       	call   20015c <fill_numbuf>
  200414:	89 44 24 08          	mov    %eax,0x8(%esp)
  200418:	eb 30                	jmp    20044a <console_vprintf+0x21a>
		case 'C':
			color = va_arg(val, int);
			goto done;
		case 'c':
			data = numbuf;
			numbuf[0] = va_arg(val, int);
  20041a:	8b 03                	mov    (%ebx),%eax
  20041c:	83 c3 04             	add    $0x4,%ebx
			numbuf[1] = '\0';
  20041f:	c6 44 24 29 00       	movb   $0x0,0x29(%esp)
		case 'C':
			color = va_arg(val, int);
			goto done;
		case 'c':
			data = numbuf;
			numbuf[0] = va_arg(val, int);
  200424:	88 44 24 28          	mov    %al,0x28(%esp)
  200428:	eb 16                	jmp    200440 <console_vprintf+0x210>
			numbuf[1] = '\0';
			break;
		normal:
		default:
			data = numbuf;
			numbuf[0] = (*format ? *format : '%');
  20042a:	b2 25                	mov    $0x25,%dl
  20042c:	84 c0                	test   %al,%al
  20042e:	0f 45 d0             	cmovne %eax,%edx
  200431:	88 54 24 28          	mov    %dl,0x28(%esp)
			numbuf[1] = '\0';
  200435:	c6 44 24 29 00       	movb   $0x0,0x29(%esp)
			if (!*format)
  20043a:	75 04                	jne    200440 <console_vprintf+0x210>
				format--;
  20043c:	ff 4c 24 58          	decl   0x58(%esp)
			numbuf[0] = va_arg(val, int);
			numbuf[1] = '\0';
			break;
		normal:
		default:
			data = numbuf;
  200440:	8d 44 24 28          	lea    0x28(%esp),%eax
  200444:	89 44 24 08          	mov    %eax,0x8(%esp)
				precision = 0;
		}

		// process main conversion character
		negative = 0;
		numeric = 0;
  200448:	31 ff                	xor    %edi,%edi
			if (precision < 0)
				precision = 0;
		}

		// process main conversion character
		negative = 0;
  20044a:	31 c9                	xor    %ecx,%ecx
			if (!*format)
				format--;
			break;
		}

		if (precision >= 0)
  20044c:	83 fe ff             	cmp    $0xffffffff,%esi
  20044f:	89 4c 24 18          	mov    %ecx,0x18(%esp)
  200453:	74 12                	je     200467 <console_vprintf+0x237>
			len = strnlen(data, precision);
  200455:	8b 44 24 08          	mov    0x8(%esp),%eax
  200459:	89 74 24 04          	mov    %esi,0x4(%esp)
  20045d:	89 04 24             	mov    %eax,(%esp)
  200460:	e8 b5 fd ff ff       	call   20021a <strnlen>
  200465:	eb 0c                	jmp    200473 <console_vprintf+0x243>
		else
			len = strlen(data);
  200467:	8b 44 24 08          	mov    0x8(%esp),%eax
  20046b:	89 04 24             	mov    %eax,(%esp)
  20046e:	e8 97 fd ff ff       	call   20020a <strlen>
  200473:	8b 4c 24 18          	mov    0x18(%esp),%ecx
		if (numeric && negative)
			negative = '-';
  200477:	ba 2d 00 00 00       	mov    $0x2d,%edx
		}

		if (precision >= 0)
			len = strnlen(data, precision);
		else
			len = strlen(data);
  20047c:	89 44 24 10          	mov    %eax,0x10(%esp)
		if (numeric && negative)
  200480:	89 f8                	mov    %edi,%eax
  200482:	83 e0 01             	and    $0x1,%eax
  200485:	88 44 24 18          	mov    %al,0x18(%esp)
  200489:	89 f8                	mov    %edi,%eax
  20048b:	84 c8                	test   %cl,%al
  20048d:	75 17                	jne    2004a6 <console_vprintf+0x276>
			negative = '-';
		else if (flags & FLAG_PLUSPOSITIVE)
  20048f:	f6 44 24 14 10       	testb  $0x10,0x14(%esp)
			negative = '+';
  200494:	b2 2b                	mov    $0x2b,%dl
			len = strnlen(data, precision);
		else
			len = strlen(data);
		if (numeric && negative)
			negative = '-';
		else if (flags & FLAG_PLUSPOSITIVE)
  200496:	75 0e                	jne    2004a6 <console_vprintf+0x276>
			negative = '+';
		else if (flags & FLAG_SPACEPOSITIVE)
			negative = ' ';
  200498:	8b 44 24 14          	mov    0x14(%esp),%eax
  20049c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  2004a3:	83 e2 20             	and    $0x20,%edx
		else
			negative = 0;
		if (numeric && precision > len)
  2004a6:	3b 74 24 10          	cmp    0x10(%esp),%esi
  2004aa:	7e 0f                	jle    2004bb <console_vprintf+0x28b>
  2004ac:	80 7c 24 18 00       	cmpb   $0x0,0x18(%esp)
  2004b1:	74 08                	je     2004bb <console_vprintf+0x28b>
			zeros = precision - len;
  2004b3:	2b 74 24 10          	sub    0x10(%esp),%esi
  2004b7:	89 f7                	mov    %esi,%edi
  2004b9:	eb 3a                	jmp    2004f5 <console_vprintf+0x2c5>
		else if ((flags & (FLAG_ZERO | FLAG_LEFTJUSTIFY)) == FLAG_ZERO
  2004bb:	8b 4c 24 14          	mov    0x14(%esp),%ecx
			 && numeric && precision < 0
			 && len + !!negative < width)
			zeros = width - len - !!negative;
		else
			zeros = 0;
  2004bf:	31 ff                	xor    %edi,%edi
			negative = ' ';
		else
			negative = 0;
		if (numeric && precision > len)
			zeros = precision - len;
		else if ((flags & (FLAG_ZERO | FLAG_LEFTJUSTIFY)) == FLAG_ZERO
  2004c1:	83 e1 06             	and    $0x6,%ecx
  2004c4:	83 f9 02             	cmp    $0x2,%ecx
  2004c7:	75 2c                	jne    2004f5 <console_vprintf+0x2c5>
			 && numeric && precision < 0
  2004c9:	80 7c 24 18 00       	cmpb   $0x0,0x18(%esp)
  2004ce:	74 23                	je     2004f3 <console_vprintf+0x2c3>
  2004d0:	c1 ee 1f             	shr    $0x1f,%esi
  2004d3:	74 1e                	je     2004f3 <console_vprintf+0x2c3>
			 && len + !!negative < width)
  2004d5:	8b 74 24 10          	mov    0x10(%esp),%esi
  2004d9:	31 c0                	xor    %eax,%eax
  2004db:	85 d2                	test   %edx,%edx
  2004dd:	0f 95 c0             	setne  %al
  2004e0:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
  2004e3:	3b 4c 24 0c          	cmp    0xc(%esp),%ecx
  2004e7:	7d 0c                	jge    2004f5 <console_vprintf+0x2c5>
			zeros = width - len - !!negative;
  2004e9:	8b 7c 24 0c          	mov    0xc(%esp),%edi
  2004ed:	29 f7                	sub    %esi,%edi
  2004ef:	29 c7                	sub    %eax,%edi
  2004f1:	eb 02                	jmp    2004f5 <console_vprintf+0x2c5>
		else
			zeros = 0;
  2004f3:	31 ff                	xor    %edi,%edi
		width -= len + zeros + !!negative;
  2004f5:	8b 74 24 10          	mov    0x10(%esp),%esi
  2004f9:	85 d2                	test   %edx,%edx
  2004fb:	0f 95 c0             	setne  %al
  2004fe:	0f b6 c8             	movzbl %al,%ecx
  200501:	01 fe                	add    %edi,%esi
  200503:	01 f1                	add    %esi,%ecx
  200505:	8b 74 24 0c          	mov    0xc(%esp),%esi
  200509:	29 ce                	sub    %ecx,%esi
	if (c == '\n') {
		int pos = (cursor - CONSOLE_BEGIN) % 80;
		for (; pos != 80; pos++)
			*cursor++ = ' ' | color;
	} else
		*cursor++ = c | color;
  20050b:	8b 4c 24 54          	mov    0x54(%esp),%ecx
  20050f:	83 c9 20             	or     $0x20,%ecx
			 && len + !!negative < width)
			zeros = width - len - !!negative;
		else
			zeros = 0;
		width -= len + zeros + !!negative;
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
  200512:	f6 44 24 14 04       	testb  $0x4,0x14(%esp)
	if (c == '\n') {
		int pos = (cursor - CONSOLE_BEGIN) % 80;
		for (; pos != 80; pos++)
			*cursor++ = ' ' | color;
	} else
		*cursor++ = c | color;
  200517:	66 89 4c 24 0c       	mov    %cx,0xc(%esp)
			 && len + !!negative < width)
			zeros = width - len - !!negative;
		else
			zeros = 0;
		width -= len + zeros + !!negative;
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
  20051c:	74 13                	je     200531 <console_vprintf+0x301>
			cursor = console_putc(cursor, ' ', color);
		if (negative)
  20051e:	84 c0                	test   %al,%al
  200520:	74 2f                	je     200551 <console_vprintf+0x321>
			cursor = console_putc(cursor, negative, color);
  200522:	8b 4c 24 54          	mov    0x54(%esp),%ecx
  200526:	89 e8                	mov    %ebp,%eax
  200528:	e8 df fb ff ff       	call   20010c <console_putc>
  20052d:	89 c5                	mov    %eax,%ebp
  20052f:	eb 20                	jmp    200551 <console_vprintf+0x321>
			 && len + !!negative < width)
			zeros = width - len - !!negative;
		else
			zeros = 0;
		width -= len + zeros + !!negative;
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
  200531:	85 f6                	test   %esi,%esi
  200533:	7e e9                	jle    20051e <console_vprintf+0x2ee>

static uint16_t *
console_putc(uint16_t *cursor, unsigned char c, int color)
{
	if (cursor >= CONSOLE_END)
		cursor = CONSOLE_BEGIN;
  200535:	81 fd a0 8f 0b 00    	cmp    $0xb8fa0,%ebp
  20053b:	b9 00 80 0b 00       	mov    $0xb8000,%ecx
  200540:	0f 43 e9             	cmovae %ecx,%ebp
	if (c == '\n') {
		int pos = (cursor - CONSOLE_BEGIN) % 80;
		for (; pos != 80; pos++)
			*cursor++ = ' ' | color;
	} else
		*cursor++ = c | color;
  200543:	8b 4c 24 0c          	mov    0xc(%esp),%ecx
			 && len + !!negative < width)
			zeros = width - len - !!negative;
		else
			zeros = 0;
		width -= len + zeros + !!negative;
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
  200547:	4e                   	dec    %esi
			cursor = console_putc(cursor, ' ', color);
  200548:	83 c5 02             	add    $0x2,%ebp
	if (c == '\n') {
		int pos = (cursor - CONSOLE_BEGIN) % 80;
		for (; pos != 80; pos++)
			*cursor++ = ' ' | color;
	} else
		*cursor++ = c | color;
  20054b:	66 89 4d fe          	mov    %cx,-0x2(%ebp)
  20054f:	eb e0                	jmp    200531 <console_vprintf+0x301>
  200551:	8b 54 24 54          	mov    0x54(%esp),%edx

static uint16_t *
console_putc(uint16_t *cursor, unsigned char c, int color)
{
	if (cursor >= CONSOLE_END)
		cursor = CONSOLE_BEGIN;
  200555:	b8 00 80 0b 00       	mov    $0xb8000,%eax
	if (c == '\n') {
		int pos = (cursor - CONSOLE_BEGIN) % 80;
		for (; pos != 80; pos++)
			*cursor++ = ' ' | color;
	} else
		*cursor++ = c | color;
  20055a:	83 ca 30             	or     $0x30,%edx
		width -= len + zeros + !!negative;
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
			cursor = console_putc(cursor, ' ', color);
		if (negative)
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
  20055d:	85 ff                	test   %edi,%edi
  20055f:	7e 13                	jle    200574 <console_vprintf+0x344>

static uint16_t *
console_putc(uint16_t *cursor, unsigned char c, int color)
{
	if (cursor >= CONSOLE_END)
		cursor = CONSOLE_BEGIN;
  200561:	81 fd a0 8f 0b 00    	cmp    $0xb8fa0,%ebp
  200567:	0f 43 e8             	cmovae %eax,%ebp
		width -= len + zeros + !!negative;
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
			cursor = console_putc(cursor, ' ', color);
		if (negative)
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
  20056a:	4f                   	dec    %edi
	if (c == '\n') {
		int pos = (cursor - CONSOLE_BEGIN) % 80;
		for (; pos != 80; pos++)
			*cursor++ = ' ' | color;
	} else
		*cursor++ = c | color;
  20056b:	66 89 55 00          	mov    %dx,0x0(%ebp)
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
			cursor = console_putc(cursor, ' ', color);
		if (negative)
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
			cursor = console_putc(cursor, '0', color);
  20056f:	83 c5 02             	add    $0x2,%ebp
  200572:	eb e9                	jmp    20055d <console_vprintf+0x32d>
		width -= len + zeros + !!negative;
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
			cursor = console_putc(cursor, ' ', color);
		if (negative)
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
  200574:	8b 7c 24 08          	mov    0x8(%esp),%edi
  200578:	8b 44 24 10          	mov    0x10(%esp),%eax
  20057c:	01 f8                	add    %edi,%eax
  20057e:	89 44 24 08          	mov    %eax,0x8(%esp)
  200582:	8b 44 24 08          	mov    0x8(%esp),%eax
  200586:	29 f8                	sub    %edi,%eax
			cursor = console_putc(cursor, '0', color);
		for (; len > 0; ++data, --len)
  200588:	85 c0                	test   %eax,%eax
  20058a:	7e 13                	jle    20059f <console_vprintf+0x36f>
			cursor = console_putc(cursor, *data, color);
  20058c:	0f b6 17             	movzbl (%edi),%edx
  20058f:	89 e8                	mov    %ebp,%eax
			cursor = console_putc(cursor, ' ', color);
		if (negative)
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
			cursor = console_putc(cursor, '0', color);
		for (; len > 0; ++data, --len)
  200591:	47                   	inc    %edi
			cursor = console_putc(cursor, *data, color);
  200592:	8b 4c 24 54          	mov    0x54(%esp),%ecx
  200596:	e8 71 fb ff ff       	call   20010c <console_putc>
  20059b:	89 c5                	mov    %eax,%ebp
  20059d:	eb e3                	jmp    200582 <console_vprintf+0x352>
	if (c == '\n') {
		int pos = (cursor - CONSOLE_BEGIN) % 80;
		for (; pos != 80; pos++)
			*cursor++ = ' ' | color;
	} else
		*cursor++ = c | color;
  20059f:	8b 54 24 54          	mov    0x54(%esp),%edx

static uint16_t *
console_putc(uint16_t *cursor, unsigned char c, int color)
{
	if (cursor >= CONSOLE_END)
		cursor = CONSOLE_BEGIN;
  2005a3:	b8 00 80 0b 00       	mov    $0xb8000,%eax
	if (c == '\n') {
		int pos = (cursor - CONSOLE_BEGIN) % 80;
		for (; pos != 80; pos++)
			*cursor++ = ' ' | color;
	} else
		*cursor++ = c | color;
  2005a8:	83 ca 20             	or     $0x20,%edx
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
			cursor = console_putc(cursor, '0', color);
		for (; len > 0; ++data, --len)
			cursor = console_putc(cursor, *data, color);
		for (; width > 0; --width)
  2005ab:	85 f6                	test   %esi,%esi
  2005ad:	7e 13                	jle    2005c2 <console_vprintf+0x392>

static uint16_t *
console_putc(uint16_t *cursor, unsigned char c, int color)
{
	if (cursor >= CONSOLE_END)
		cursor = CONSOLE_BEGIN;
  2005af:	81 fd a0 8f 0b 00    	cmp    $0xb8fa0,%ebp
  2005b5:	0f 43 e8             	cmovae %eax,%ebp
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
			cursor = console_putc(cursor, '0', color);
		for (; len > 0; ++data, --len)
			cursor = console_putc(cursor, *data, color);
		for (; width > 0; --width)
  2005b8:	4e                   	dec    %esi
	if (c == '\n') {
		int pos = (cursor - CONSOLE_BEGIN) % 80;
		for (; pos != 80; pos++)
			*cursor++ = ' ' | color;
	} else
		*cursor++ = c | color;
  2005b9:	66 89 55 00          	mov    %dx,0x0(%ebp)
		for (; zeros > 0; --zeros)
			cursor = console_putc(cursor, '0', color);
		for (; len > 0; ++data, --len)
			cursor = console_putc(cursor, *data, color);
		for (; width > 0; --width)
			cursor = console_putc(cursor, ' ', color);
  2005bd:	83 c5 02             	add    $0x2,%ebp
  2005c0:	eb e9                	jmp    2005ab <console_vprintf+0x37b>
	int flags, width, zeros, precision, negative, numeric, len;
#define NUMBUFSIZ 20
	char numbuf[NUMBUFSIZ];
	char *data;

	for (; *format; ++format) {
  2005c2:	ff 44 24 58          	incl   0x58(%esp)
  2005c6:	e9 74 fc ff ff       	jmp    20023f <console_vprintf+0xf>
			const char *flagc = flag_chars;
			while (*flagc != '\0' && *flagc != *format)
				++flagc;
			if (*flagc == '\0')
				break;
			flags |= (1 << (flagc - flag_chars));
  2005cb:	81 e9 a8 06 20 00    	sub    $0x2006a8,%ecx
  2005d1:	89 f0                	mov    %esi,%eax
  2005d3:	d3 e0                	shl    %cl,%eax
			continue;
		}

		// process flags
		flags = 0;
		for (++format; *format; ++format) {
  2005d5:	ff 44 24 58          	incl   0x58(%esp)
			const char *flagc = flag_chars;
			while (*flagc != '\0' && *flagc != *format)
				++flagc;
			if (*flagc == '\0')
				break;
			flags |= (1 << (flagc - flag_chars));
  2005d9:	09 44 24 14          	or     %eax,0x14(%esp)
  2005dd:	e9 94 fc ff ff       	jmp    200276 <console_vprintf+0x46>
			cursor = console_putc(cursor, ' ', color);
	done: ;
	}

	return cursor;
}
  2005e2:	83 c4 3c             	add    $0x3c,%esp
  2005e5:	89 e8                	mov    %ebp,%eax
  2005e7:	5b                   	pop    %ebx
  2005e8:	5e                   	pop    %esi
  2005e9:	5f                   	pop    %edi
  2005ea:	5d                   	pop    %ebp
  2005eb:	c3                   	ret    

002005ec <console_printf>:

uint16_t *
console_printf(uint16_t *cursor, int color, const char *format, ...)
{
  2005ec:	83 ec 10             	sub    $0x10,%esp
	va_list val;
	va_start(val, format);
	cursor = console_vprintf(cursor, color, format, val);
  2005ef:	8d 44 24 20          	lea    0x20(%esp),%eax
  2005f3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  2005f7:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  2005fb:	89 44 24 08          	mov    %eax,0x8(%esp)
  2005ff:	8b 44 24 18          	mov    0x18(%esp),%eax
  200603:	89 44 24 04          	mov    %eax,0x4(%esp)
  200607:	8b 44 24 14          	mov    0x14(%esp),%eax
  20060b:	89 04 24             	mov    %eax,(%esp)
  20060e:	e8 1d fc ff ff       	call   200230 <console_vprintf>
	va_end(val);
	return cursor;
}
  200613:	83 c4 10             	add    $0x10,%esp
  200616:	c3                   	ret    
