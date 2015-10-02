
obj/mpos-app2:     file format elf32-i386


Disassembly of section .text:

00200000 <app_printf.constprop.0>:
 *****************************************************************************/

static void app_printf(const char *format, ...) __attribute__((noinline));

static void
app_printf(const char *format, ...)
  200000:	83 ec 2c             	sub    $0x2c,%esp
  200003:	c7 44 24 1c e0 05 20 	movl   $0x2005e0,0x1c(%esp)
  20000a:	00 
	// That means that after the "asm" instruction (which causes the
	// interrupt), the system call's return value is in the 'pid'
	// variable, and we can just return that value!

	pid_t pid;
	asm volatile("int %1\n"
  20000b:	cd 30                	int    $0x30
static void
app_printf(const char *format, ...)
{
	// set default color based on currently running process
	int color = sys_getpid();
	if (color < 0)
  20000d:	85 c0                	test   %eax,%eax
  20000f:	78 15                	js     200026 <app_printf.constprop.0+0x26>
		color = 0x0700;
	else {
		static const uint8_t col[] = { 0x0E, 0x0F, 0x0C, 0x0A, 0x09 };
		color = col[color % sizeof(col)] << 8;
  200011:	b9 05 00 00 00       	mov    $0x5,%ecx
  200016:	31 d2                	xor    %edx,%edx
  200018:	f7 f1                	div    %ecx
  20001a:	0f b6 82 00 06 20 00 	movzbl 0x200600(%edx),%eax
  200021:	c1 e0 08             	shl    $0x8,%eax
  200024:	eb 05                	jmp    20002b <app_printf.constprop.0+0x2b>
app_printf(const char *format, ...)
{
	// set default color based on currently running process
	int color = sys_getpid();
	if (color < 0)
		color = 0x0700;
  200026:	b8 00 07 00 00       	mov    $0x700,%eax
		color = col[color % sizeof(col)] << 8;
	}

	va_list val;
	va_start(val, format);
	cursorpos = console_vprintf(cursorpos, color, format, val);
  20002b:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  20002f:	8d 4c 24 20          	lea    0x20(%esp),%ecx
  200033:	89 44 24 04          	mov    %eax,0x4(%esp)
  200037:	a1 00 00 06 00       	mov    0x60000,%eax
  20003c:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  200040:	89 54 24 08          	mov    %edx,0x8(%esp)
  200044:	89 04 24             	mov    %eax,(%esp)
  200047:	e8 aa 01 00 00       	call   2001f6 <console_vprintf>
  20004c:	a3 00 00 06 00       	mov    %eax,0x60000
	va_end(val);
}
  200051:	83 c4 2c             	add    $0x2c,%esp
  200054:	c3                   	ret    

00200055 <run_child>:
	sys_exit(0);
}

void
run_child(void)
{
  200055:	53                   	push   %ebx
  200056:	83 ec 08             	sub    $0x8,%esp
	int input_counter = counter;
  200059:	8b 1d cc 17 20 00    	mov    0x2017cc,%ebx

	counter++;		/* Note that all "processes" share an address
  20005f:	a1 cc 17 20 00       	mov    0x2017cc,%eax
  200064:	40                   	inc    %eax
  200065:	a3 cc 17 20 00       	mov    %eax,0x2017cc
	// That means that after the "asm" instruction (which causes the
	// interrupt), the system call's return value is in the 'pid'
	// variable, and we can just return that value!

	pid_t pid;
	asm volatile("int %1\n"
  20006a:	cd 30                	int    $0x30
				   space, so this change to 'counter' will be
				   visible to all processes. */

	app_printf("Process %d lives, counter %d!\n",
  20006c:	89 da                	mov    %ebx,%edx
  20006e:	e8 8d ff ff ff       	call   200000 <app_printf.constprop.0>
	// the 'int' instruction.
	// You can load other registers with similar syntax; specifically:
	//	"a" = %eax, "b" = %ebx, "c" = %ecx, "d" = %edx,
	//	"S" = %esi, "D" = %edi.

	asm volatile("int %0\n"
  200073:	89 d8                	mov    %ebx,%eax
  200075:	cd 33                	int    $0x33
  200077:	eb fe                	jmp    200077 <run_child+0x22>

00200079 <start>:
start(void)
{
	pid_t p;
	int status;

	counter = 0;
  200079:	c7 05 cc 17 20 00 00 	movl   $0x0,0x2017cc
  200080:	00 00 00 

	while (counter < 1025) {
  200083:	a1 cc 17 20 00       	mov    0x2017cc,%eax
  200088:	3d 00 04 00 00       	cmp    $0x400,%eax
  20008d:	7e 06                	jle    200095 <start+0x1c>
  20008f:	31 c0                	xor    %eax,%eax
  200091:	cd 33                	int    $0x33
  200093:	eb 3b                	jmp    2000d0 <start+0x57>
  200095:	31 d2                	xor    %edx,%edx
		int n_started = 0;

		// Start as many processes as possible, until we fail to start
		// a process or we have started 1025 processes total.
		while (counter + n_started < 1025) {
  200097:	a1 cc 17 20 00       	mov    0x2017cc,%eax
  20009c:	01 d0                	add    %edx,%eax
  20009e:	3d 00 04 00 00       	cmp    $0x400,%eax
  2000a3:	7f 11                	jg     2000b6 <start+0x3d>
sys_fork(void)
{
	// This system call follows the same pattern as sys_getpid().

	pid_t result;
	asm volatile("int %1\n"
  2000a5:	cd 31                	int    $0x31
			p = sys_fork();
			if (p == 0)
  2000a7:	83 f8 00             	cmp    $0x0,%eax
  2000aa:	75 08                	jne    2000b4 <start+0x3b>

void run_child(void);

void
start(void)
{
  2000ac:	83 ec 0c             	sub    $0xc,%esp
		// Start as many processes as possible, until we fail to start
		// a process or we have started 1025 processes total.
		while (counter + n_started < 1025) {
			p = sys_fork();
			if (p == 0)
				run_child();
  2000af:	e8 a1 ff ff ff       	call   200055 <run_child>
			else if (p > 0)
  2000b4:	7f 0b                	jg     2000c1 <start+0x48>
			else
				break;
		}

		// If we could not start any new processes, give up!
		if (n_started == 0)
  2000b6:	85 d2                	test   %edx,%edx
  2000b8:	74 d5                	je     20008f <start+0x16>
  2000ba:	ba 02 00 00 00       	mov    $0x2,%edx
  2000bf:	eb 03                	jmp    2000c4 <start+0x4b>
		while (counter + n_started < 1025) {
			p = sys_fork();
			if (p == 0)
				run_child();
			else if (p > 0)
				n_started++;
  2000c1:	42                   	inc    %edx
  2000c2:	eb d3                	jmp    200097 <start+0x1e>

static inline int
sys_wait(pid_t pid)
{
	int retval;
	asm volatile("int %1\n"
  2000c4:	89 d0                	mov    %edx,%eax
  2000c6:	cd 34                	int    $0x34
		// We started at least one process, but then could not start
		// any more.
		// That means we ran out of room to start processes.
		// Retrieve old processes' exit status with sys_wait(),
		// to make room for new processes.
		for (p = 2; p < NPROCS; p++)
  2000c8:	42                   	inc    %edx
  2000c9:	83 fa 10             	cmp    $0x10,%edx
  2000cc:	75 f6                	jne    2000c4 <start+0x4b>
  2000ce:	eb b3                	jmp    200083 <start+0xa>
  2000d0:	eb fe                	jmp    2000d0 <start+0x57>

002000d2 <console_putc>:
 *
 *   Print a message onto the console, starting at the given cursor position. */

static uint16_t *
console_putc(uint16_t *cursor, unsigned char c, int color)
{
  2000d2:	56                   	push   %esi
	if (cursor >= CONSOLE_END)
		cursor = CONSOLE_BEGIN;
  2000d3:	3d a0 8f 0b 00       	cmp    $0xb8fa0,%eax
 *
 *   Print a message onto the console, starting at the given cursor position. */

static uint16_t *
console_putc(uint16_t *cursor, unsigned char c, int color)
{
  2000d8:	53                   	push   %ebx
  2000d9:	89 c3                	mov    %eax,%ebx
	if (cursor >= CONSOLE_END)
		cursor = CONSOLE_BEGIN;
  2000db:	b8 00 80 0b 00       	mov    $0xb8000,%eax
  2000e0:	0f 43 d8             	cmovae %eax,%ebx
	if (c == '\n') {
  2000e3:	80 fa 0a             	cmp    $0xa,%dl
  2000e6:	75 2c                	jne    200114 <console_putc+0x42>
		int pos = (cursor - CONSOLE_BEGIN) % 80;
  2000e8:	8d 83 00 80 f4 ff    	lea    -0xb8000(%ebx),%eax
  2000ee:	be 50 00 00 00       	mov    $0x50,%esi
  2000f3:	d1 f8                	sar    %eax
		for (; pos != 80; pos++)
			*cursor++ = ' ' | color;
  2000f5:	83 c9 20             	or     $0x20,%ecx
console_putc(uint16_t *cursor, unsigned char c, int color)
{
	if (cursor >= CONSOLE_END)
		cursor = CONSOLE_BEGIN;
	if (c == '\n') {
		int pos = (cursor - CONSOLE_BEGIN) % 80;
  2000f8:	99                   	cltd   
  2000f9:	f7 fe                	idiv   %esi
  2000fb:	6b c2 fe             	imul   $0xfffffffe,%edx,%eax
  2000fe:	8d 34 03             	lea    (%ebx,%eax,1),%esi
		for (; pos != 80; pos++)
			*cursor++ = ' ' | color;
  200101:	66 89 0c 56          	mov    %cx,(%esi,%edx,2)
{
	if (cursor >= CONSOLE_END)
		cursor = CONSOLE_BEGIN;
	if (c == '\n') {
		int pos = (cursor - CONSOLE_BEGIN) % 80;
		for (; pos != 80; pos++)
  200105:	42                   	inc    %edx
  200106:	83 fa 50             	cmp    $0x50,%edx
  200109:	75 f6                	jne    200101 <console_putc+0x2f>
  20010b:	8d 84 03 a0 00 00 00 	lea    0xa0(%ebx,%eax,1),%eax
  200112:	eb 0b                	jmp    20011f <console_putc+0x4d>
			*cursor++ = ' ' | color;
	} else
		*cursor++ = c | color;
  200114:	0f b6 d2             	movzbl %dl,%edx
  200117:	09 ca                	or     %ecx,%edx
  200119:	8d 43 02             	lea    0x2(%ebx),%eax
  20011c:	66 89 13             	mov    %dx,(%ebx)
	return cursor;
}
  20011f:	5b                   	pop    %ebx
  200120:	5e                   	pop    %esi
  200121:	c3                   	ret    

00200122 <fill_numbuf>:
static const char lower_digits[] = "0123456789abcdef";

static char *
fill_numbuf(char *numbuf_end, uint32_t val, int base, const char *digits,
	    int precision)
{
  200122:	56                   	push   %esi
  200123:	53                   	push   %ebx
  200124:	8b 74 24 0c          	mov    0xc(%esp),%esi
	*--numbuf_end = '\0';
	if (precision != 0 || val != 0)
  200128:	83 7c 24 10 00       	cmpl   $0x0,0x10(%esp)

static char *
fill_numbuf(char *numbuf_end, uint32_t val, int base, const char *digits,
	    int precision)
{
	*--numbuf_end = '\0';
  20012d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  200130:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
	if (precision != 0 || val != 0)
  200134:	75 04                	jne    20013a <fill_numbuf+0x18>
  200136:	85 d2                	test   %edx,%edx
  200138:	74 10                	je     20014a <fill_numbuf+0x28>
		do {
			*--numbuf_end = digits[val % base];
  20013a:	89 d0                	mov    %edx,%eax
  20013c:	31 d2                	xor    %edx,%edx
  20013e:	f7 f1                	div    %ecx
  200140:	4b                   	dec    %ebx
  200141:	8a 14 16             	mov    (%esi,%edx,1),%dl
  200144:	88 13                	mov    %dl,(%ebx)
			val /= base;
  200146:	89 c2                	mov    %eax,%edx
  200148:	eb ec                	jmp    200136 <fill_numbuf+0x14>
		} while (val != 0);
	return numbuf_end;
}
  20014a:	89 d8                	mov    %ebx,%eax
  20014c:	5b                   	pop    %ebx
  20014d:	5e                   	pop    %esi
  20014e:	c3                   	ret    

0020014f <memcpy>:
 *
 *   We must provide our own implementations of these basic functions. */

void *
memcpy(void *dst, const void *src, size_t n)
{
  20014f:	53                   	push   %ebx
  200150:	8b 44 24 08          	mov    0x8(%esp),%eax
	const char *s = (const char *) src;
	char *d = (char *) dst;
	while (n-- > 0)
  200154:	31 d2                	xor    %edx,%edx
 *
 *   We must provide our own implementations of these basic functions. */

void *
memcpy(void *dst, const void *src, size_t n)
{
  200156:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
	const char *s = (const char *) src;
	char *d = (char *) dst;
	while (n-- > 0)
  20015a:	3b 54 24 10          	cmp    0x10(%esp),%edx
  20015e:	74 09                	je     200169 <memcpy+0x1a>
		*d++ = *s++;
  200160:	8a 0c 13             	mov    (%ebx,%edx,1),%cl
  200163:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  200166:	42                   	inc    %edx
  200167:	eb f1                	jmp    20015a <memcpy+0xb>
	return dst;
}
  200169:	5b                   	pop    %ebx
  20016a:	c3                   	ret    

0020016b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  20016b:	55                   	push   %ebp
  20016c:	57                   	push   %edi
  20016d:	56                   	push   %esi
  20016e:	53                   	push   %ebx
  20016f:	8b 44 24 14          	mov    0x14(%esp),%eax
  200173:	8b 5c 24 18          	mov    0x18(%esp),%ebx
  200177:	8b 6c 24 1c          	mov    0x1c(%esp),%ebp
	const char *s = (const char *) src;
	char *d = (char *) dst;
	if (s < d && s + n > d) {
  20017b:	39 c3                	cmp    %eax,%ebx
  20017d:	72 04                	jb     200183 <memmove+0x18>
		s += n, d += n;
		while (n-- > 0)
  20017f:	31 c9                	xor    %ecx,%ecx
  200181:	eb 24                	jmp    2001a7 <memmove+0x3c>
void *
memmove(void *dst, const void *src, size_t n)
{
	const char *s = (const char *) src;
	char *d = (char *) dst;
	if (s < d && s + n > d) {
  200183:	8d 34 2b             	lea    (%ebx,%ebp,1),%esi
  200186:	39 c6                	cmp    %eax,%esi
  200188:	76 f5                	jbe    20017f <memmove+0x14>
  20018a:	89 e9                	mov    %ebp,%ecx
		s += n, d += n;
		while (n-- > 0)
  20018c:	89 ea                	mov    %ebp,%edx
  20018e:	f7 d9                	neg    %ecx
memmove(void *dst, const void *src, size_t n)
{
	const char *s = (const char *) src;
	char *d = (char *) dst;
	if (s < d && s + n > d) {
		s += n, d += n;
  200190:	8d 3c 28             	lea    (%eax,%ebp,1),%edi
  200193:	01 ce                	add    %ecx,%esi
		while (n-- > 0)
  200195:	4a                   	dec    %edx
  200196:	83 fa ff             	cmp    $0xffffffff,%edx
  200199:	74 19                	je     2001b4 <memmove+0x49>
			*--d = *--s;
  20019b:	8a 1c 16             	mov    (%esi,%edx,1),%bl
  20019e:	8d 2c 0f             	lea    (%edi,%ecx,1),%ebp
  2001a1:	88 5c 15 00          	mov    %bl,0x0(%ebp,%edx,1)
  2001a5:	eb ee                	jmp    200195 <memmove+0x2a>
	} else
		while (n-- > 0)
  2001a7:	39 e9                	cmp    %ebp,%ecx
  2001a9:	74 09                	je     2001b4 <memmove+0x49>
			*d++ = *s++;
  2001ab:	8a 14 0b             	mov    (%ebx,%ecx,1),%dl
  2001ae:	88 14 08             	mov    %dl,(%eax,%ecx,1)
  2001b1:	41                   	inc    %ecx
  2001b2:	eb f3                	jmp    2001a7 <memmove+0x3c>
	return dst;
}
  2001b4:	5b                   	pop    %ebx
  2001b5:	5e                   	pop    %esi
  2001b6:	5f                   	pop    %edi
  2001b7:	5d                   	pop    %ebp
  2001b8:	c3                   	ret    

002001b9 <memset>:

void *
memset(void *v, int c, size_t n)
{
  2001b9:	8b 44 24 04          	mov    0x4(%esp),%eax
	char *p = (char *) v;
	while (n-- > 0)
  2001bd:	31 d2                	xor    %edx,%edx
	return dst;
}

void *
memset(void *v, int c, size_t n)
{
  2001bf:	8b 4c 24 08          	mov    0x8(%esp),%ecx
	char *p = (char *) v;
	while (n-- > 0)
  2001c3:	3b 54 24 0c          	cmp    0xc(%esp),%edx
  2001c7:	74 06                	je     2001cf <memset+0x16>
		*p++ = c;
  2001c9:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  2001cc:	42                   	inc    %edx
  2001cd:	eb f4                	jmp    2001c3 <memset+0xa>
	return v;
}
  2001cf:	c3                   	ret    

002001d0 <strlen>:

size_t
strlen(const char *s)
{
  2001d0:	8b 54 24 04          	mov    0x4(%esp),%edx
	size_t n;
	for (n = 0; *s != '\0'; ++s)
  2001d4:	31 c0                	xor    %eax,%eax
  2001d6:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  2001da:	74 03                	je     2001df <strlen+0xf>
		++n;
  2001dc:	40                   	inc    %eax
  2001dd:	eb f7                	jmp    2001d6 <strlen+0x6>
	return n;
}
  2001df:	c3                   	ret    

002001e0 <strnlen>:

size_t
strnlen(const char *s, size_t maxlen)
{
  2001e0:	8b 54 24 04          	mov    0x4(%esp),%edx
	size_t n;
	for (n = 0; n != maxlen && *s != '\0'; ++s)
  2001e4:	31 c0                	xor    %eax,%eax
  2001e6:	3b 44 24 08          	cmp    0x8(%esp),%eax
  2001ea:	74 09                	je     2001f5 <strnlen+0x15>
  2001ec:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  2001f0:	74 03                	je     2001f5 <strnlen+0x15>
		++n;
  2001f2:	40                   	inc    %eax
  2001f3:	eb f1                	jmp    2001e6 <strnlen+0x6>
	return n;
}
  2001f5:	c3                   	ret    

002001f6 <console_vprintf>:
#define FLAG_PLUSPOSITIVE	(1<<4)
static const char flag_chars[] = "#0- +";

uint16_t *
console_vprintf(uint16_t *cursor, int color, const char *format, va_list val)
{
  2001f6:	55                   	push   %ebp
  2001f7:	57                   	push   %edi
  2001f8:	56                   	push   %esi
  2001f9:	53                   	push   %ebx
  2001fa:	83 ec 3c             	sub    $0x3c,%esp
  2001fd:	8b 6c 24 50          	mov    0x50(%esp),%ebp
  200201:	8b 5c 24 5c          	mov    0x5c(%esp),%ebx
	int flags, width, zeros, precision, negative, numeric, len;
#define NUMBUFSIZ 20
	char numbuf[NUMBUFSIZ];
	char *data;

	for (; *format; ++format) {
  200205:	8b 44 24 58          	mov    0x58(%esp),%eax
  200209:	0f b6 10             	movzbl (%eax),%edx
  20020c:	84 d2                	test   %dl,%dl
  20020e:	0f 84 94 03 00 00    	je     2005a8 <console_vprintf+0x3b2>
		if (*format != '%') {
  200214:	80 fa 25             	cmp    $0x25,%dl
  200217:	74 12                	je     20022b <console_vprintf+0x35>
			cursor = console_putc(cursor, *format, color);
  200219:	8b 4c 24 54          	mov    0x54(%esp),%ecx
  20021d:	89 e8                	mov    %ebp,%eax
  20021f:	e8 ae fe ff ff       	call   2000d2 <console_putc>
  200224:	89 c5                	mov    %eax,%ebp
			continue;
  200226:	e9 5d 03 00 00       	jmp    200588 <console_vprintf+0x392>
		}

		// process flags
		flags = 0;
		for (++format; *format; ++format) {
  20022b:	ff 44 24 58          	incl   0x58(%esp)
			const char *flagc = flag_chars;
			while (*flagc != '\0' && *flagc != *format)
				++flagc;
			if (*flagc == '\0')
				break;
			flags |= (1 << (flagc - flag_chars));
  20022f:	be 01 00 00 00       	mov    $0x1,%esi
			cursor = console_putc(cursor, *format, color);
			continue;
		}

		// process flags
		flags = 0;
  200234:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  20023b:	00 
		for (++format; *format; ++format) {
  20023c:	8b 44 24 58          	mov    0x58(%esp),%eax
  200240:	8a 00                	mov    (%eax),%al
  200242:	84 c0                	test   %al,%al
  200244:	74 16                	je     20025c <console_vprintf+0x66>
  200246:	b9 08 06 20 00       	mov    $0x200608,%ecx
			const char *flagc = flag_chars;
			while (*flagc != '\0' && *flagc != *format)
  20024b:	8a 11                	mov    (%ecx),%dl
  20024d:	84 d2                	test   %dl,%dl
  20024f:	74 0b                	je     20025c <console_vprintf+0x66>
  200251:	38 c2                	cmp    %al,%dl
  200253:	0f 84 38 03 00 00    	je     200591 <console_vprintf+0x39b>
				++flagc;
  200259:	41                   	inc    %ecx
  20025a:	eb ef                	jmp    20024b <console_vprintf+0x55>
			flags |= (1 << (flagc - flag_chars));
		}

		// process width
		width = -1;
		if (*format >= '1' && *format <= '9') {
  20025c:	8d 50 cf             	lea    -0x31(%eax),%edx
  20025f:	80 fa 08             	cmp    $0x8,%dl
  200262:	77 2a                	ja     20028e <console_vprintf+0x98>
  200264:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  20026b:	00 
			for (width = 0; *format >= '0' && *format <= '9'; )
  20026c:	8b 44 24 58          	mov    0x58(%esp),%eax
  200270:	0f be 00             	movsbl (%eax),%eax
  200273:	8d 50 d0             	lea    -0x30(%eax),%edx
  200276:	80 fa 09             	cmp    $0x9,%dl
  200279:	77 2c                	ja     2002a7 <console_vprintf+0xb1>
				width = 10 * width + *format++ - '0';
  20027b:	6b 74 24 0c 0a       	imul   $0xa,0xc(%esp),%esi
  200280:	ff 44 24 58          	incl   0x58(%esp)
  200284:	8d 44 06 d0          	lea    -0x30(%esi,%eax,1),%eax
  200288:	89 44 24 0c          	mov    %eax,0xc(%esp)
  20028c:	eb de                	jmp    20026c <console_vprintf+0x76>
		} else if (*format == '*') {
  20028e:	3c 2a                	cmp    $0x2a,%al
				break;
			flags |= (1 << (flagc - flag_chars));
		}

		// process width
		width = -1;
  200290:	c7 44 24 0c ff ff ff 	movl   $0xffffffff,0xc(%esp)
  200297:	ff 
		if (*format >= '1' && *format <= '9') {
			for (width = 0; *format >= '0' && *format <= '9'; )
				width = 10 * width + *format++ - '0';
		} else if (*format == '*') {
  200298:	75 0d                	jne    2002a7 <console_vprintf+0xb1>
			width = va_arg(val, int);
  20029a:	8b 03                	mov    (%ebx),%eax
  20029c:	83 c3 04             	add    $0x4,%ebx
			++format;
  20029f:	ff 44 24 58          	incl   0x58(%esp)
		width = -1;
		if (*format >= '1' && *format <= '9') {
			for (width = 0; *format >= '0' && *format <= '9'; )
				width = 10 * width + *format++ - '0';
		} else if (*format == '*') {
			width = va_arg(val, int);
  2002a3:	89 44 24 0c          	mov    %eax,0xc(%esp)
			++format;
		}

		// process precision
		precision = -1;
		if (*format == '.') {
  2002a7:	8b 44 24 58          	mov    0x58(%esp),%eax
			width = va_arg(val, int);
			++format;
		}

		// process precision
		precision = -1;
  2002ab:	83 ce ff             	or     $0xffffffff,%esi
		if (*format == '.') {
  2002ae:	80 38 2e             	cmpb   $0x2e,(%eax)
  2002b1:	75 4f                	jne    200302 <console_vprintf+0x10c>
			++format;
			if (*format >= '0' && *format <= '9') {
  2002b3:	8b 7c 24 58          	mov    0x58(%esp),%edi
		}

		// process precision
		precision = -1;
		if (*format == '.') {
			++format;
  2002b7:	40                   	inc    %eax
			if (*format >= '0' && *format <= '9') {
  2002b8:	8a 57 01             	mov    0x1(%edi),%dl
  2002bb:	8d 4a d0             	lea    -0x30(%edx),%ecx
  2002be:	80 f9 09             	cmp    $0x9,%cl
  2002c1:	77 22                	ja     2002e5 <console_vprintf+0xef>
  2002c3:	89 44 24 58          	mov    %eax,0x58(%esp)
  2002c7:	31 f6                	xor    %esi,%esi
				for (precision = 0; *format >= '0' && *format <= '9'; )
  2002c9:	8b 44 24 58          	mov    0x58(%esp),%eax
  2002cd:	0f be 00             	movsbl (%eax),%eax
  2002d0:	8d 50 d0             	lea    -0x30(%eax),%edx
  2002d3:	80 fa 09             	cmp    $0x9,%dl
  2002d6:	77 2a                	ja     200302 <console_vprintf+0x10c>
					precision = 10 * precision + *format++ - '0';
  2002d8:	6b f6 0a             	imul   $0xa,%esi,%esi
  2002db:	ff 44 24 58          	incl   0x58(%esp)
  2002df:	8d 74 06 d0          	lea    -0x30(%esi,%eax,1),%esi
  2002e3:	eb e4                	jmp    2002c9 <console_vprintf+0xd3>
			} else if (*format == '*') {
  2002e5:	80 fa 2a             	cmp    $0x2a,%dl
  2002e8:	75 12                	jne    2002fc <console_vprintf+0x106>
				precision = va_arg(val, int);
  2002ea:	8b 33                	mov    (%ebx),%esi
  2002ec:	8d 43 04             	lea    0x4(%ebx),%eax
				++format;
  2002ef:	83 44 24 58 02       	addl   $0x2,0x58(%esp)
			++format;
			if (*format >= '0' && *format <= '9') {
				for (precision = 0; *format >= '0' && *format <= '9'; )
					precision = 10 * precision + *format++ - '0';
			} else if (*format == '*') {
				precision = va_arg(val, int);
  2002f4:	89 c3                	mov    %eax,%ebx
				++format;
			}
			if (precision < 0)
  2002f6:	85 f6                	test   %esi,%esi
  2002f8:	79 08                	jns    200302 <console_vprintf+0x10c>
  2002fa:	eb 04                	jmp    200300 <console_vprintf+0x10a>
		}

		// process precision
		precision = -1;
		if (*format == '.') {
			++format;
  2002fc:	89 44 24 58          	mov    %eax,0x58(%esp)
			} else if (*format == '*') {
				precision = va_arg(val, int);
				++format;
			}
			if (precision < 0)
				precision = 0;
  200300:	31 f6                	xor    %esi,%esi
		}

		// process main conversion character
		negative = 0;
		numeric = 0;
		switch (*format) {
  200302:	8b 44 24 58          	mov    0x58(%esp),%eax
  200306:	8a 00                	mov    (%eax),%al
  200308:	3c 64                	cmp    $0x64,%al
  20030a:	74 46                	je     200352 <console_vprintf+0x15c>
  20030c:	7f 26                	jg     200334 <console_vprintf+0x13e>
  20030e:	3c 58                	cmp    $0x58,%al
  200310:	0f 84 9f 00 00 00    	je     2003b5 <console_vprintf+0x1bf>
  200316:	3c 63                	cmp    $0x63,%al
  200318:	0f 84 c2 00 00 00    	je     2003e0 <console_vprintf+0x1ea>
  20031e:	3c 43                	cmp    $0x43,%al
  200320:	0f 85 ca 00 00 00    	jne    2003f0 <console_vprintf+0x1fa>
		}
		case 's':
			data = va_arg(val, char *);
			break;
		case 'C':
			color = va_arg(val, int);
  200326:	8b 03                	mov    (%ebx),%eax
  200328:	83 c3 04             	add    $0x4,%ebx
  20032b:	89 44 24 54          	mov    %eax,0x54(%esp)
			goto done;
  20032f:	e9 54 02 00 00       	jmp    200588 <console_vprintf+0x392>
		}

		// process main conversion character
		negative = 0;
		numeric = 0;
		switch (*format) {
  200334:	3c 75                	cmp    $0x75,%al
  200336:	74 58                	je     200390 <console_vprintf+0x19a>
  200338:	3c 78                	cmp    $0x78,%al
  20033a:	74 69                	je     2003a5 <console_vprintf+0x1af>
  20033c:	3c 73                	cmp    $0x73,%al
  20033e:	0f 85 ac 00 00 00    	jne    2003f0 <console_vprintf+0x1fa>
			data = fill_numbuf(numbuf + NUMBUFSIZ, x, 16, upper_digits, precision);
			numeric = 1;
			break;
		}
		case 's':
			data = va_arg(val, char *);
  200344:	8b 03                	mov    (%ebx),%eax
  200346:	83 c3 04             	add    $0x4,%ebx
  200349:	89 44 24 08          	mov    %eax,0x8(%esp)
  20034d:	e9 bc 00 00 00       	jmp    20040e <console_vprintf+0x218>
		// process main conversion character
		negative = 0;
		numeric = 0;
		switch (*format) {
		case 'd': {
			int x = va_arg(val, int);
  200352:	8d 7b 04             	lea    0x4(%ebx),%edi
  200355:	8b 1b                	mov    (%ebx),%ebx
			data = fill_numbuf(numbuf + NUMBUFSIZ, x > 0 ? x : -x, 10, upper_digits, precision);
  200357:	b9 0a 00 00 00       	mov    $0xa,%ecx
  20035c:	89 74 24 04          	mov    %esi,0x4(%esp)
  200360:	c7 04 24 24 06 20 00 	movl   $0x200624,(%esp)
  200367:	89 d8                	mov    %ebx,%eax
  200369:	c1 f8 1f             	sar    $0x1f,%eax
  20036c:	89 c2                	mov    %eax,%edx
  20036e:	31 da                	xor    %ebx,%edx
  200370:	29 c2                	sub    %eax,%edx
  200372:	8d 44 24 3c          	lea    0x3c(%esp),%eax
  200376:	e8 a7 fd ff ff       	call   200122 <fill_numbuf>
			if (x < 0)
				negative = 1;
  20037b:	c1 eb 1f             	shr    $0x1f,%ebx
  20037e:	89 d9                	mov    %ebx,%ecx
		// process main conversion character
		negative = 0;
		numeric = 0;
		switch (*format) {
		case 'd': {
			int x = va_arg(val, int);
  200380:	89 fb                	mov    %edi,%ebx
			data = fill_numbuf(numbuf + NUMBUFSIZ, x > 0 ? x : -x, 10, upper_digits, precision);
			if (x < 0)
				negative = 1;
			numeric = 1;
  200382:	bf 01 00 00 00       	mov    $0x1,%edi
		negative = 0;
		numeric = 0;
		switch (*format) {
		case 'd': {
			int x = va_arg(val, int);
			data = fill_numbuf(numbuf + NUMBUFSIZ, x > 0 ? x : -x, 10, upper_digits, precision);
  200387:	89 44 24 08          	mov    %eax,0x8(%esp)
  20038b:	e9 82 00 00 00       	jmp    200412 <console_vprintf+0x21c>
				negative = 1;
			numeric = 1;
			break;
		}
		case 'u': {
			unsigned x = va_arg(val, unsigned);
  200390:	8d 7b 04             	lea    0x4(%ebx),%edi
			data = fill_numbuf(numbuf + NUMBUFSIZ, x, 10, upper_digits, precision);
  200393:	b9 0a 00 00 00       	mov    $0xa,%ecx
  200398:	89 74 24 04          	mov    %esi,0x4(%esp)
  20039c:	c7 04 24 24 06 20 00 	movl   $0x200624,(%esp)
  2003a3:	eb 23                	jmp    2003c8 <console_vprintf+0x1d2>
			numeric = 1;
			break;
		}
		case 'x': {
			unsigned x = va_arg(val, unsigned);
  2003a5:	8d 7b 04             	lea    0x4(%ebx),%edi
			data = fill_numbuf(numbuf + NUMBUFSIZ, x, 16, lower_digits, precision);
  2003a8:	89 74 24 04          	mov    %esi,0x4(%esp)
  2003ac:	c7 04 24 10 06 20 00 	movl   $0x200610,(%esp)
  2003b3:	eb 0e                	jmp    2003c3 <console_vprintf+0x1cd>
			numeric = 1;
			break;
		}
		case 'X': {
			unsigned x = va_arg(val, unsigned);
  2003b5:	8d 7b 04             	lea    0x4(%ebx),%edi
			data = fill_numbuf(numbuf + NUMBUFSIZ, x, 16, upper_digits, precision);
  2003b8:	89 74 24 04          	mov    %esi,0x4(%esp)
  2003bc:	c7 04 24 24 06 20 00 	movl   $0x200624,(%esp)
  2003c3:	b9 10 00 00 00       	mov    $0x10,%ecx
  2003c8:	8b 13                	mov    (%ebx),%edx
  2003ca:	8d 44 24 3c          	lea    0x3c(%esp),%eax
			data = fill_numbuf(numbuf + NUMBUFSIZ, x, 16, lower_digits, precision);
			numeric = 1;
			break;
		}
		case 'X': {
			unsigned x = va_arg(val, unsigned);
  2003ce:	89 fb                	mov    %edi,%ebx
			data = fill_numbuf(numbuf + NUMBUFSIZ, x, 16, upper_digits, precision);
			numeric = 1;
  2003d0:	bf 01 00 00 00       	mov    $0x1,%edi
			numeric = 1;
			break;
		}
		case 'X': {
			unsigned x = va_arg(val, unsigned);
			data = fill_numbuf(numbuf + NUMBUFSIZ, x, 16, upper_digits, precision);
  2003d5:	e8 48 fd ff ff       	call   200122 <fill_numbuf>
  2003da:	89 44 24 08          	mov    %eax,0x8(%esp)
  2003de:	eb 30                	jmp    200410 <console_vprintf+0x21a>
		case 'C':
			color = va_arg(val, int);
			goto done;
		case 'c':
			data = numbuf;
			numbuf[0] = va_arg(val, int);
  2003e0:	8b 03                	mov    (%ebx),%eax
  2003e2:	83 c3 04             	add    $0x4,%ebx
			numbuf[1] = '\0';
  2003e5:	c6 44 24 29 00       	movb   $0x0,0x29(%esp)
		case 'C':
			color = va_arg(val, int);
			goto done;
		case 'c':
			data = numbuf;
			numbuf[0] = va_arg(val, int);
  2003ea:	88 44 24 28          	mov    %al,0x28(%esp)
  2003ee:	eb 16                	jmp    200406 <console_vprintf+0x210>
			numbuf[1] = '\0';
			break;
		normal:
		default:
			data = numbuf;
			numbuf[0] = (*format ? *format : '%');
  2003f0:	b2 25                	mov    $0x25,%dl
  2003f2:	84 c0                	test   %al,%al
  2003f4:	0f 45 d0             	cmovne %eax,%edx
  2003f7:	88 54 24 28          	mov    %dl,0x28(%esp)
			numbuf[1] = '\0';
  2003fb:	c6 44 24 29 00       	movb   $0x0,0x29(%esp)
			if (!*format)
  200400:	75 04                	jne    200406 <console_vprintf+0x210>
				format--;
  200402:	ff 4c 24 58          	decl   0x58(%esp)
			numbuf[0] = va_arg(val, int);
			numbuf[1] = '\0';
			break;
		normal:
		default:
			data = numbuf;
  200406:	8d 44 24 28          	lea    0x28(%esp),%eax
  20040a:	89 44 24 08          	mov    %eax,0x8(%esp)
				precision = 0;
		}

		// process main conversion character
		negative = 0;
		numeric = 0;
  20040e:	31 ff                	xor    %edi,%edi
			if (precision < 0)
				precision = 0;
		}

		// process main conversion character
		negative = 0;
  200410:	31 c9                	xor    %ecx,%ecx
			if (!*format)
				format--;
			break;
		}

		if (precision >= 0)
  200412:	83 fe ff             	cmp    $0xffffffff,%esi
  200415:	89 4c 24 18          	mov    %ecx,0x18(%esp)
  200419:	74 12                	je     20042d <console_vprintf+0x237>
			len = strnlen(data, precision);
  20041b:	8b 44 24 08          	mov    0x8(%esp),%eax
  20041f:	89 74 24 04          	mov    %esi,0x4(%esp)
  200423:	89 04 24             	mov    %eax,(%esp)
  200426:	e8 b5 fd ff ff       	call   2001e0 <strnlen>
  20042b:	eb 0c                	jmp    200439 <console_vprintf+0x243>
		else
			len = strlen(data);
  20042d:	8b 44 24 08          	mov    0x8(%esp),%eax
  200431:	89 04 24             	mov    %eax,(%esp)
  200434:	e8 97 fd ff ff       	call   2001d0 <strlen>
  200439:	8b 4c 24 18          	mov    0x18(%esp),%ecx
		if (numeric && negative)
			negative = '-';
  20043d:	ba 2d 00 00 00       	mov    $0x2d,%edx
		}

		if (precision >= 0)
			len = strnlen(data, precision);
		else
			len = strlen(data);
  200442:	89 44 24 10          	mov    %eax,0x10(%esp)
		if (numeric && negative)
  200446:	89 f8                	mov    %edi,%eax
  200448:	83 e0 01             	and    $0x1,%eax
  20044b:	88 44 24 18          	mov    %al,0x18(%esp)
  20044f:	89 f8                	mov    %edi,%eax
  200451:	84 c8                	test   %cl,%al
  200453:	75 17                	jne    20046c <console_vprintf+0x276>
			negative = '-';
		else if (flags & FLAG_PLUSPOSITIVE)
  200455:	f6 44 24 14 10       	testb  $0x10,0x14(%esp)
			negative = '+';
  20045a:	b2 2b                	mov    $0x2b,%dl
			len = strnlen(data, precision);
		else
			len = strlen(data);
		if (numeric && negative)
			negative = '-';
		else if (flags & FLAG_PLUSPOSITIVE)
  20045c:	75 0e                	jne    20046c <console_vprintf+0x276>
			negative = '+';
		else if (flags & FLAG_SPACEPOSITIVE)
			negative = ' ';
  20045e:	8b 44 24 14          	mov    0x14(%esp),%eax
  200462:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  200469:	83 e2 20             	and    $0x20,%edx
		else
			negative = 0;
		if (numeric && precision > len)
  20046c:	3b 74 24 10          	cmp    0x10(%esp),%esi
  200470:	7e 0f                	jle    200481 <console_vprintf+0x28b>
  200472:	80 7c 24 18 00       	cmpb   $0x0,0x18(%esp)
  200477:	74 08                	je     200481 <console_vprintf+0x28b>
			zeros = precision - len;
  200479:	2b 74 24 10          	sub    0x10(%esp),%esi
  20047d:	89 f7                	mov    %esi,%edi
  20047f:	eb 3a                	jmp    2004bb <console_vprintf+0x2c5>
		else if ((flags & (FLAG_ZERO | FLAG_LEFTJUSTIFY)) == FLAG_ZERO
  200481:	8b 4c 24 14          	mov    0x14(%esp),%ecx
			 && numeric && precision < 0
			 && len + !!negative < width)
			zeros = width - len - !!negative;
		else
			zeros = 0;
  200485:	31 ff                	xor    %edi,%edi
			negative = ' ';
		else
			negative = 0;
		if (numeric && precision > len)
			zeros = precision - len;
		else if ((flags & (FLAG_ZERO | FLAG_LEFTJUSTIFY)) == FLAG_ZERO
  200487:	83 e1 06             	and    $0x6,%ecx
  20048a:	83 f9 02             	cmp    $0x2,%ecx
  20048d:	75 2c                	jne    2004bb <console_vprintf+0x2c5>
			 && numeric && precision < 0
  20048f:	80 7c 24 18 00       	cmpb   $0x0,0x18(%esp)
  200494:	74 23                	je     2004b9 <console_vprintf+0x2c3>
  200496:	c1 ee 1f             	shr    $0x1f,%esi
  200499:	74 1e                	je     2004b9 <console_vprintf+0x2c3>
			 && len + !!negative < width)
  20049b:	8b 74 24 10          	mov    0x10(%esp),%esi
  20049f:	31 c0                	xor    %eax,%eax
  2004a1:	85 d2                	test   %edx,%edx
  2004a3:	0f 95 c0             	setne  %al
  2004a6:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
  2004a9:	3b 4c 24 0c          	cmp    0xc(%esp),%ecx
  2004ad:	7d 0c                	jge    2004bb <console_vprintf+0x2c5>
			zeros = width - len - !!negative;
  2004af:	8b 7c 24 0c          	mov    0xc(%esp),%edi
  2004b3:	29 f7                	sub    %esi,%edi
  2004b5:	29 c7                	sub    %eax,%edi
  2004b7:	eb 02                	jmp    2004bb <console_vprintf+0x2c5>
		else
			zeros = 0;
  2004b9:	31 ff                	xor    %edi,%edi
		width -= len + zeros + !!negative;
  2004bb:	8b 74 24 10          	mov    0x10(%esp),%esi
  2004bf:	85 d2                	test   %edx,%edx
  2004c1:	0f 95 c0             	setne  %al
  2004c4:	0f b6 c8             	movzbl %al,%ecx
  2004c7:	01 fe                	add    %edi,%esi
  2004c9:	01 f1                	add    %esi,%ecx
  2004cb:	8b 74 24 0c          	mov    0xc(%esp),%esi
  2004cf:	29 ce                	sub    %ecx,%esi
	if (c == '\n') {
		int pos = (cursor - CONSOLE_BEGIN) % 80;
		for (; pos != 80; pos++)
			*cursor++ = ' ' | color;
	} else
		*cursor++ = c | color;
  2004d1:	8b 4c 24 54          	mov    0x54(%esp),%ecx
  2004d5:	83 c9 20             	or     $0x20,%ecx
			 && len + !!negative < width)
			zeros = width - len - !!negative;
		else
			zeros = 0;
		width -= len + zeros + !!negative;
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
  2004d8:	f6 44 24 14 04       	testb  $0x4,0x14(%esp)
	if (c == '\n') {
		int pos = (cursor - CONSOLE_BEGIN) % 80;
		for (; pos != 80; pos++)
			*cursor++ = ' ' | color;
	} else
		*cursor++ = c | color;
  2004dd:	66 89 4c 24 0c       	mov    %cx,0xc(%esp)
			 && len + !!negative < width)
			zeros = width - len - !!negative;
		else
			zeros = 0;
		width -= len + zeros + !!negative;
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
  2004e2:	74 13                	je     2004f7 <console_vprintf+0x301>
			cursor = console_putc(cursor, ' ', color);
		if (negative)
  2004e4:	84 c0                	test   %al,%al
  2004e6:	74 2f                	je     200517 <console_vprintf+0x321>
			cursor = console_putc(cursor, negative, color);
  2004e8:	8b 4c 24 54          	mov    0x54(%esp),%ecx
  2004ec:	89 e8                	mov    %ebp,%eax
  2004ee:	e8 df fb ff ff       	call   2000d2 <console_putc>
  2004f3:	89 c5                	mov    %eax,%ebp
  2004f5:	eb 20                	jmp    200517 <console_vprintf+0x321>
			 && len + !!negative < width)
			zeros = width - len - !!negative;
		else
			zeros = 0;
		width -= len + zeros + !!negative;
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
  2004f7:	85 f6                	test   %esi,%esi
  2004f9:	7e e9                	jle    2004e4 <console_vprintf+0x2ee>

static uint16_t *
console_putc(uint16_t *cursor, unsigned char c, int color)
{
	if (cursor >= CONSOLE_END)
		cursor = CONSOLE_BEGIN;
  2004fb:	81 fd a0 8f 0b 00    	cmp    $0xb8fa0,%ebp
  200501:	b9 00 80 0b 00       	mov    $0xb8000,%ecx
  200506:	0f 43 e9             	cmovae %ecx,%ebp
	if (c == '\n') {
		int pos = (cursor - CONSOLE_BEGIN) % 80;
		for (; pos != 80; pos++)
			*cursor++ = ' ' | color;
	} else
		*cursor++ = c | color;
  200509:	8b 4c 24 0c          	mov    0xc(%esp),%ecx
			 && len + !!negative < width)
			zeros = width - len - !!negative;
		else
			zeros = 0;
		width -= len + zeros + !!negative;
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
  20050d:	4e                   	dec    %esi
			cursor = console_putc(cursor, ' ', color);
  20050e:	83 c5 02             	add    $0x2,%ebp
	if (c == '\n') {
		int pos = (cursor - CONSOLE_BEGIN) % 80;
		for (; pos != 80; pos++)
			*cursor++ = ' ' | color;
	} else
		*cursor++ = c | color;
  200511:	66 89 4d fe          	mov    %cx,-0x2(%ebp)
  200515:	eb e0                	jmp    2004f7 <console_vprintf+0x301>
  200517:	8b 54 24 54          	mov    0x54(%esp),%edx

static uint16_t *
console_putc(uint16_t *cursor, unsigned char c, int color)
{
	if (cursor >= CONSOLE_END)
		cursor = CONSOLE_BEGIN;
  20051b:	b8 00 80 0b 00       	mov    $0xb8000,%eax
	if (c == '\n') {
		int pos = (cursor - CONSOLE_BEGIN) % 80;
		for (; pos != 80; pos++)
			*cursor++ = ' ' | color;
	} else
		*cursor++ = c | color;
  200520:	83 ca 30             	or     $0x30,%edx
		width -= len + zeros + !!negative;
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
			cursor = console_putc(cursor, ' ', color);
		if (negative)
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
  200523:	85 ff                	test   %edi,%edi
  200525:	7e 13                	jle    20053a <console_vprintf+0x344>

static uint16_t *
console_putc(uint16_t *cursor, unsigned char c, int color)
{
	if (cursor >= CONSOLE_END)
		cursor = CONSOLE_BEGIN;
  200527:	81 fd a0 8f 0b 00    	cmp    $0xb8fa0,%ebp
  20052d:	0f 43 e8             	cmovae %eax,%ebp
		width -= len + zeros + !!negative;
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
			cursor = console_putc(cursor, ' ', color);
		if (negative)
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
  200530:	4f                   	dec    %edi
	if (c == '\n') {
		int pos = (cursor - CONSOLE_BEGIN) % 80;
		for (; pos != 80; pos++)
			*cursor++ = ' ' | color;
	} else
		*cursor++ = c | color;
  200531:	66 89 55 00          	mov    %dx,0x0(%ebp)
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
			cursor = console_putc(cursor, ' ', color);
		if (negative)
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
			cursor = console_putc(cursor, '0', color);
  200535:	83 c5 02             	add    $0x2,%ebp
  200538:	eb e9                	jmp    200523 <console_vprintf+0x32d>
		width -= len + zeros + !!negative;
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
			cursor = console_putc(cursor, ' ', color);
		if (negative)
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
  20053a:	8b 7c 24 08          	mov    0x8(%esp),%edi
  20053e:	8b 44 24 10          	mov    0x10(%esp),%eax
  200542:	01 f8                	add    %edi,%eax
  200544:	89 44 24 08          	mov    %eax,0x8(%esp)
  200548:	8b 44 24 08          	mov    0x8(%esp),%eax
  20054c:	29 f8                	sub    %edi,%eax
			cursor = console_putc(cursor, '0', color);
		for (; len > 0; ++data, --len)
  20054e:	85 c0                	test   %eax,%eax
  200550:	7e 13                	jle    200565 <console_vprintf+0x36f>
			cursor = console_putc(cursor, *data, color);
  200552:	0f b6 17             	movzbl (%edi),%edx
  200555:	89 e8                	mov    %ebp,%eax
			cursor = console_putc(cursor, ' ', color);
		if (negative)
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
			cursor = console_putc(cursor, '0', color);
		for (; len > 0; ++data, --len)
  200557:	47                   	inc    %edi
			cursor = console_putc(cursor, *data, color);
  200558:	8b 4c 24 54          	mov    0x54(%esp),%ecx
  20055c:	e8 71 fb ff ff       	call   2000d2 <console_putc>
  200561:	89 c5                	mov    %eax,%ebp
  200563:	eb e3                	jmp    200548 <console_vprintf+0x352>
	if (c == '\n') {
		int pos = (cursor - CONSOLE_BEGIN) % 80;
		for (; pos != 80; pos++)
			*cursor++ = ' ' | color;
	} else
		*cursor++ = c | color;
  200565:	8b 54 24 54          	mov    0x54(%esp),%edx

static uint16_t *
console_putc(uint16_t *cursor, unsigned char c, int color)
{
	if (cursor >= CONSOLE_END)
		cursor = CONSOLE_BEGIN;
  200569:	b8 00 80 0b 00       	mov    $0xb8000,%eax
	if (c == '\n') {
		int pos = (cursor - CONSOLE_BEGIN) % 80;
		for (; pos != 80; pos++)
			*cursor++ = ' ' | color;
	} else
		*cursor++ = c | color;
  20056e:	83 ca 20             	or     $0x20,%edx
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
			cursor = console_putc(cursor, '0', color);
		for (; len > 0; ++data, --len)
			cursor = console_putc(cursor, *data, color);
		for (; width > 0; --width)
  200571:	85 f6                	test   %esi,%esi
  200573:	7e 13                	jle    200588 <console_vprintf+0x392>

static uint16_t *
console_putc(uint16_t *cursor, unsigned char c, int color)
{
	if (cursor >= CONSOLE_END)
		cursor = CONSOLE_BEGIN;
  200575:	81 fd a0 8f 0b 00    	cmp    $0xb8fa0,%ebp
  20057b:	0f 43 e8             	cmovae %eax,%ebp
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
			cursor = console_putc(cursor, '0', color);
		for (; len > 0; ++data, --len)
			cursor = console_putc(cursor, *data, color);
		for (; width > 0; --width)
  20057e:	4e                   	dec    %esi
	if (c == '\n') {
		int pos = (cursor - CONSOLE_BEGIN) % 80;
		for (; pos != 80; pos++)
			*cursor++ = ' ' | color;
	} else
		*cursor++ = c | color;
  20057f:	66 89 55 00          	mov    %dx,0x0(%ebp)
		for (; zeros > 0; --zeros)
			cursor = console_putc(cursor, '0', color);
		for (; len > 0; ++data, --len)
			cursor = console_putc(cursor, *data, color);
		for (; width > 0; --width)
			cursor = console_putc(cursor, ' ', color);
  200583:	83 c5 02             	add    $0x2,%ebp
  200586:	eb e9                	jmp    200571 <console_vprintf+0x37b>
	int flags, width, zeros, precision, negative, numeric, len;
#define NUMBUFSIZ 20
	char numbuf[NUMBUFSIZ];
	char *data;

	for (; *format; ++format) {
  200588:	ff 44 24 58          	incl   0x58(%esp)
  20058c:	e9 74 fc ff ff       	jmp    200205 <console_vprintf+0xf>
			const char *flagc = flag_chars;
			while (*flagc != '\0' && *flagc != *format)
				++flagc;
			if (*flagc == '\0')
				break;
			flags |= (1 << (flagc - flag_chars));
  200591:	81 e9 08 06 20 00    	sub    $0x200608,%ecx
  200597:	89 f0                	mov    %esi,%eax
  200599:	d3 e0                	shl    %cl,%eax
			continue;
		}

		// process flags
		flags = 0;
		for (++format; *format; ++format) {
  20059b:	ff 44 24 58          	incl   0x58(%esp)
			const char *flagc = flag_chars;
			while (*flagc != '\0' && *flagc != *format)
				++flagc;
			if (*flagc == '\0')
				break;
			flags |= (1 << (flagc - flag_chars));
  20059f:	09 44 24 14          	or     %eax,0x14(%esp)
  2005a3:	e9 94 fc ff ff       	jmp    20023c <console_vprintf+0x46>
			cursor = console_putc(cursor, ' ', color);
	done: ;
	}

	return cursor;
}
  2005a8:	83 c4 3c             	add    $0x3c,%esp
  2005ab:	89 e8                	mov    %ebp,%eax
  2005ad:	5b                   	pop    %ebx
  2005ae:	5e                   	pop    %esi
  2005af:	5f                   	pop    %edi
  2005b0:	5d                   	pop    %ebp
  2005b1:	c3                   	ret    

002005b2 <console_printf>:

uint16_t *
console_printf(uint16_t *cursor, int color, const char *format, ...)
{
  2005b2:	83 ec 10             	sub    $0x10,%esp
	va_list val;
	va_start(val, format);
	cursor = console_vprintf(cursor, color, format, val);
  2005b5:	8d 44 24 20          	lea    0x20(%esp),%eax
  2005b9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  2005bd:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  2005c1:	89 44 24 08          	mov    %eax,0x8(%esp)
  2005c5:	8b 44 24 18          	mov    0x18(%esp),%eax
  2005c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  2005cd:	8b 44 24 14          	mov    0x14(%esp),%eax
  2005d1:	89 04 24             	mov    %eax,(%esp)
  2005d4:	e8 1d fc ff ff       	call   2001f6 <console_vprintf>
	va_end(val);
	return cursor;
}
  2005d9:	83 c4 10             	add    $0x10,%esp
  2005dc:	c3                   	ret    
