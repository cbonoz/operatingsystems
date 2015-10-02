
obj/mpos-kern:     file format elf32-i386


Disassembly of section .text:

00100000 <multiboot>:
  100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
  100006:	00 00                	add    %al,(%eax)
  100008:	fe 4f 52             	decb   0x52(%edi)
  10000b:	e4 bc                	in     $0xbc,%al

0010000c <multiboot_start>:
# The multiboot_start routine sets the stack pointer to the top of the
# MiniprocOS's kernel stack, then jumps to the 'start' routine in mpos-kern.c.

.globl multiboot_start
multiboot_start:
	movl $0x200000, %esp
  10000c:	bc 00 00 20 00       	mov    $0x200000,%esp
	pushl $0
  100011:	6a 00                	push   $0x0
	popfl
  100013:	9d                   	popf   
	call start
  100014:	e8 72 00 00 00       	call   10008b <start>
  100019:	90                   	nop

0010001a <sys_int48_handler>:

# Interrupt handlers
.align 2

sys_int48_handler:
	pushl $0
  10001a:	6a 00                	push   $0x0
	pushl $48
  10001c:	6a 30                	push   $0x30
	jmp _generic_int_handler
  10001e:	eb 3a                	jmp    10005a <_generic_int_handler>

00100020 <sys_int49_handler>:

sys_int49_handler:
	pushl $0
  100020:	6a 00                	push   $0x0
	pushl $49
  100022:	6a 31                	push   $0x31
	jmp _generic_int_handler
  100024:	eb 34                	jmp    10005a <_generic_int_handler>

00100026 <sys_int50_handler>:

sys_int50_handler:
	pushl $0
  100026:	6a 00                	push   $0x0
	pushl $50
  100028:	6a 32                	push   $0x32
	jmp _generic_int_handler
  10002a:	eb 2e                	jmp    10005a <_generic_int_handler>

0010002c <sys_int51_handler>:

sys_int51_handler:
	pushl $0
  10002c:	6a 00                	push   $0x0
	pushl $51
  10002e:	6a 33                	push   $0x33
	jmp _generic_int_handler
  100030:	eb 28                	jmp    10005a <_generic_int_handler>

00100032 <sys_int52_handler>:

sys_int52_handler:
	pushl $0
  100032:	6a 00                	push   $0x0
	pushl $52
  100034:	6a 34                	push   $0x34
	jmp _generic_int_handler
  100036:	eb 22                	jmp    10005a <_generic_int_handler>

00100038 <sys_int53_handler>:

sys_int53_handler:
	pushl $0
  100038:	6a 00                	push   $0x0
	pushl $53
  10003a:	6a 35                	push   $0x35
	jmp _generic_int_handler
  10003c:	eb 1c                	jmp    10005a <_generic_int_handler>

0010003e <sys_int54_handler>:

sys_int54_handler:
	pushl $0
  10003e:	6a 00                	push   $0x0
	pushl $54
  100040:	6a 36                	push   $0x36
	jmp _generic_int_handler
  100042:	eb 16                	jmp    10005a <_generic_int_handler>

00100044 <sys_int55_handler>:

sys_int55_handler:
	pushl $0
  100044:	6a 00                	push   $0x0
	pushl $55
  100046:	6a 37                	push   $0x37
	jmp _generic_int_handler
  100048:	eb 10                	jmp    10005a <_generic_int_handler>

0010004a <sys_int56_handler>:

sys_int56_handler:
	pushl $0
  10004a:	6a 00                	push   $0x0
	pushl $56
  10004c:	6a 38                	push   $0x38
	jmp _generic_int_handler
  10004e:	eb 0a                	jmp    10005a <_generic_int_handler>

00100050 <sys_int57_handler>:

sys_int57_handler:
	pushl $0
  100050:	6a 00                	push   $0x0
	pushl $57
  100052:	6a 39                	push   $0x39
	jmp _generic_int_handler
  100054:	eb 04                	jmp    10005a <_generic_int_handler>

00100056 <default_int_handler>:

	.globl default_int_handler
default_int_handler:
	pushl $0
  100056:	6a 00                	push   $0x0
	jmp _generic_int_handler
  100058:	eb 00                	jmp    10005a <_generic_int_handler>

0010005a <_generic_int_handler>:
	# When we get here, the processor's interrupt mechanism has
	# pushed the old task status and stack registers onto the kernel stack.
	# Then one of the specific handlers pushed the interrupt number.
	# Now, we complete the 'registers_t' structure by pushing the extra
	# segment definitions and the general CPU registers.
	pushl %ds
  10005a:	1e                   	push   %ds
	pushl %es
  10005b:	06                   	push   %es
	pushal
  10005c:	60                   	pusha  

	# Call the kernel's 'interrupt' function.
	pushl %esp
  10005d:	54                   	push   %esp
	call interrupt
  10005e:	e8 13 01 00 00       	call   100176 <interrupt>

00100063 <sys_int_handlers>:
  100063:	1a 00                	sbb    (%eax),%al
  100065:	10 00                	adc    %al,(%eax)
  100067:	20 00                	and    %al,(%eax)
  100069:	10 00                	adc    %al,(%eax)
  10006b:	26 00 10             	add    %dl,%es:(%eax)
  10006e:	00 2c 00             	add    %ch,(%eax,%eax,1)
  100071:	10 00                	adc    %al,(%eax)
  100073:	32 00                	xor    (%eax),%al
  100075:	10 00                	adc    %al,(%eax)
  100077:	38 00                	cmp    %al,(%eax)
  100079:	10 00                	adc    %al,(%eax)
  10007b:	3e 00 10             	add    %dl,%ds:(%eax)
  10007e:	00 44 00 10          	add    %al,0x10(%eax,%eax,1)
  100082:	00 4a 00             	add    %cl,0x0(%edx)
  100085:	10 00                	adc    %al,(%eax)
  100087:	50                   	push   %eax
  100088:	00 10                	add    %dl,(%eax)
	...

0010008b <start>:
 *
 *****************************************************************************/

void
start(void)
{
  10008b:	53                   	push   %ebx
  10008c:	83 ec 18             	sub    $0x18,%esp
	const char *s;
	int whichprocess;
	pid_t i;

	// Initialize process descriptors as empty
	memset(proc_array, 0, sizeof(proc_array));
  10008f:	c7 44 24 08 00 05 00 	movl   $0x500,0x8(%esp)
  100096:	00 
  100097:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10009e:	00 
  10009f:	c7 04 24 30 91 10 00 	movl   $0x109130,(%esp)
  1000a6:	e8 a5 04 00 00       	call   100550 <memset>
  1000ab:	ba 30 91 10 00       	mov    $0x109130,%edx
	for (i = 0; i < NPROCS; i++) {
  1000b0:	31 c0                	xor    %eax,%eax
		proc_array[i].p_pid = i;
  1000b2:	89 02                	mov    %eax,(%edx)
	int whichprocess;
	pid_t i;

	// Initialize process descriptors as empty
	memset(proc_array, 0, sizeof(proc_array));
	for (i = 0; i < NPROCS; i++) {
  1000b4:	40                   	inc    %eax
  1000b5:	83 c2 50             	add    $0x50,%edx
		proc_array[i].p_pid = i;
		proc_array[i].p_state = P_EMPTY;
  1000b8:	c7 42 f8 00 00 00 00 	movl   $0x0,-0x8(%edx)
	int whichprocess;
	pid_t i;

	// Initialize process descriptors as empty
	memset(proc_array, 0, sizeof(proc_array));
	for (i = 0; i < NPROCS; i++) {
  1000bf:	83 f8 10             	cmp    $0x10,%eax
  1000c2:	75 ee                	jne    1000b2 <start+0x27>
		proc_array[i].p_pid = i;
		proc_array[i].p_state = P_EMPTY;
	}

	// The first process has process ID 1.
	current = &proc_array[1];
  1000c4:	c7 05 98 9e 10 00 80 	movl   $0x109180,0x109e98
  1000cb:	91 10 00 

	// Set up x86 hardware, and initialize the first process's
	// special registers.  This only needs to be done once, at boot time.
	// All other processes' special registers can be copied from the
	// first process.
	segments_init();
  1000ce:	e8 37 01 00 00       	call   10020a <segments_init>
	special_registers_init(current);
  1000d3:	a1 98 9e 10 00       	mov    0x109e98,%eax
  1000d8:	89 04 24             	mov    %eax,(%esp)
  1000db:	e8 05 02 00 00       	call   1002e5 <special_registers_init>

	// Erase the console, and initialize the cursor-position shared
	// variable to point to its upper left.
	console_clear();
  1000e0:	e8 40 02 00 00       	call   100325 <console_clear>

	// Figure out which program to run.
	cursorpos = console_printf(cursorpos, 0x0700, "Type '1' to run mpos-app, or '2' to run mpos-app2.");
  1000e5:	a1 00 00 06 00       	mov    0x60000,%eax
  1000ea:	c7 44 24 08 74 09 10 	movl   $0x100974,0x8(%esp)
  1000f1:	00 
  1000f2:	c7 44 24 04 00 07 00 	movl   $0x700,0x4(%esp)
  1000f9:	00 
  1000fa:	89 04 24             	mov    %eax,(%esp)
  1000fd:	e8 47 08 00 00       	call   100949 <console_printf>
  100102:	a3 00 00 06 00       	mov    %eax,0x60000
	do {
		whichprocess = console_read_digit();
  100107:	e8 5c 02 00 00       	call   100368 <console_read_digit>
	} while (whichprocess != 1 && whichprocess != 2);
  10010c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  10010f:	83 fb 01             	cmp    $0x1,%ebx
  100112:	77 f3                	ja     100107 <start+0x7c>
	console_clear();
  100114:	e8 0c 02 00 00       	call   100325 <console_clear>

	// Load the process application code and data into memory.
	// Store its entry point into the first process's EIP
	// (instruction pointer).
	program_loader(whichprocess - 1, &current->p_registers.reg_eip);
  100119:	a1 98 9e 10 00       	mov    0x109e98,%eax
  10011e:	89 1c 24             	mov    %ebx,(%esp)
  100121:	83 c0 34             	add    $0x34,%eax
  100124:	89 44 24 04          	mov    %eax,0x4(%esp)
  100128:	e8 af 02 00 00       	call   1003dc <program_loader>

	// Set the main process's stack pointer, ESP.
	current->p_registers.reg_esp = PROC1_STACK_ADDR + PROC_STACK_SIZE;
  10012d:	a1 98 9e 10 00       	mov    0x109e98,%eax
  100132:	c7 40 40 00 00 2c 00 	movl   $0x2c0000,0x40(%eax)

	// Mark the process as runnable!
	current->p_state = P_RUNNABLE;
  100139:	c7 40 48 01 00 00 00 	movl   $0x1,0x48(%eax)

	// Switch to the main process using run().
	run(current);
  100140:	89 04 24             	mov    %eax,(%esp)
  100143:	e8 7d 02 00 00       	call   1003c5 <run>

00100148 <schedule>:
 *****************************************************************************/

void
schedule(void)
{
	pid_t pid = current->p_pid;
  100148:	a1 98 9e 10 00       	mov    0x109e98,%eax
	while (1) {
		pid = (pid + 1) % NPROCS;
  10014d:	b9 10 00 00 00       	mov    $0x10,%ecx
 *****************************************************************************/

void
schedule(void)
{
	pid_t pid = current->p_pid;
  100152:	8b 10                	mov    (%eax),%edx
	while (1) {
		pid = (pid + 1) % NPROCS;
  100154:	8d 42 01             	lea    0x1(%edx),%eax
  100157:	99                   	cltd   
  100158:	f7 f9                	idiv   %ecx
		if (proc_array[pid].p_state == P_RUNNABLE)
  10015a:	6b c2 50             	imul   $0x50,%edx,%eax
  10015d:	83 b8 78 91 10 00 01 	cmpl   $0x1,0x109178(%eax)
  100164:	75 ee                	jne    100154 <schedule+0xc>
 *
 *****************************************************************************/

void
schedule(void)
{
  100166:	83 ec 1c             	sub    $0x1c,%esp
	pid_t pid = current->p_pid;
	while (1) {
		pid = (pid + 1) % NPROCS;
		if (proc_array[pid].p_state == P_RUNNABLE)
			run(&proc_array[pid]);
  100169:	05 30 91 10 00       	add    $0x109130,%eax
  10016e:	89 04 24             	mov    %eax,(%esp)
  100171:	e8 4f 02 00 00       	call   1003c5 <run>

00100176 <interrupt>:

static pid_t do_fork(process_t *parent);

void
interrupt(registers_t *reg)
{
  100176:	57                   	push   %edi
	// the application's state on the kernel's stack, then jumping to
	// kernel assembly code (in mpos-int.S, for your information).
	// That code saves more registers on the kernel's stack, then calls
	// interrupt().  The first thing we must do, then, is copy the saved
	// registers into the 'current' process descriptor.
	current->p_registers = *reg;
  100177:	b9 11 00 00 00       	mov    $0x11,%ecx

static pid_t do_fork(process_t *parent);

void
interrupt(registers_t *reg)
{
  10017c:	56                   	push   %esi
  10017d:	83 ec 14             	sub    $0x14,%esp
	// the application's state on the kernel's stack, then jumping to
	// kernel assembly code (in mpos-int.S, for your information).
	// That code saves more registers on the kernel's stack, then calls
	// interrupt().  The first thing we must do, then, is copy the saved
	// registers into the 'current' process descriptor.
	current->p_registers = *reg;
  100180:	a1 98 9e 10 00       	mov    0x109e98,%eax

static pid_t do_fork(process_t *parent);

void
interrupt(registers_t *reg)
{
  100185:	8b 54 24 20          	mov    0x20(%esp),%edx
	// the application's state on the kernel's stack, then jumping to
	// kernel assembly code (in mpos-int.S, for your information).
	// That code saves more registers on the kernel's stack, then calls
	// interrupt().  The first thing we must do, then, is copy the saved
	// registers into the 'current' process descriptor.
	current->p_registers = *reg;
  100189:	8d 78 04             	lea    0x4(%eax),%edi
  10018c:	89 d6                	mov    %edx,%esi
  10018e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

	switch (reg->reg_intno) {
  100190:	8b 52 28             	mov    0x28(%edx),%edx
  100193:	83 ea 30             	sub    $0x30,%edx
  100196:	83 fa 04             	cmp    $0x4,%edx
  100199:	77 6d                	ja     100208 <interrupt+0x92>
  10019b:	ff 24 95 a8 09 10 00 	jmp    *0x1009a8(,%edx,4)
		// The 'sys_getpid' system call returns the current
		// process's process ID.  System calls return results to user
		// code by putting those results in a register.  Like Linux,
		// we use %eax for system call return values.  The code is
		// surprisingly simple:
		current->p_registers.reg_eax = current->p_pid;
  1001a2:	8b 10                	mov    (%eax),%edx
  1001a4:	89 50 20             	mov    %edx,0x20(%eax)
  1001a7:	eb 07                	jmp    1001b0 <interrupt+0x3a>
		run(current);

	case INT_SYS_FORK:
		// The 'sys_fork' system call should create a new process.
		// You will have to complete the do_fork() function!
		current->p_registers.reg_eax = do_fork(current);
  1001a9:	c7 40 20 ff ff ff ff 	movl   $0xffffffff,0x20(%eax)
		run(current);
  1001b0:	89 04 24             	mov    %eax,(%esp)
  1001b3:	e8 0d 02 00 00       	call   1003c5 <run>
		// The process stored its exit status in the %eax register
		// before calling the system call.  The %eax REGISTER has
		// changed by now, but we can read the APPLICATION's setting
		// for this register out of 'current->p_registers'.
		current->p_state = P_ZOMBIE;
		current->p_exit_status = current->p_registers.reg_eax;
  1001b8:	8b 50 20             	mov    0x20(%eax),%edx
		// non-runnable.
		// The process stored its exit status in the %eax register
		// before calling the system call.  The %eax REGISTER has
		// changed by now, but we can read the APPLICATION's setting
		// for this register out of 'current->p_registers'.
		current->p_state = P_ZOMBIE;
  1001bb:	c7 40 48 03 00 00 00 	movl   $0x3,0x48(%eax)
		current->p_exit_status = current->p_registers.reg_eax;
  1001c2:	89 50 4c             	mov    %edx,0x4c(%eax)
  1001c5:	eb 3c                	jmp    100203 <interrupt+0x8d>
		// * A process that doesn't exist (p_state == P_EMPTY).
		// (In the Unix operating system, only process P's parent
		// can call sys_wait(P).  In MiniprocOS, we allow ANY
		// process to call sys_wait(P).)

		pid_t p = current->p_registers.reg_eax;
  1001c7:	8b 50 20             	mov    0x20(%eax),%edx
		if (p <= 0 || p >= NPROCS || p == current->p_pid
  1001ca:	8d 4a ff             	lea    -0x1(%edx),%ecx
  1001cd:	83 f9 0e             	cmp    $0xe,%ecx
  1001d0:	77 11                	ja     1001e3 <interrupt+0x6d>
  1001d2:	3b 10                	cmp    (%eax),%edx
  1001d4:	74 0d                	je     1001e3 <interrupt+0x6d>
		    || proc_array[p].p_state == P_EMPTY)
  1001d6:	6b d2 50             	imul   $0x50,%edx,%edx
  1001d9:	8b 8a 78 91 10 00    	mov    0x109178(%edx),%ecx
  1001df:	85 c9                	test   %ecx,%ecx
  1001e1:	75 09                	jne    1001ec <interrupt+0x76>
			current->p_registers.reg_eax = -1;
  1001e3:	c7 40 20 ff ff ff ff 	movl   $0xffffffff,0x20(%eax)
  1001ea:	eb 17                	jmp    100203 <interrupt+0x8d>
		else if (proc_array[p].p_state == P_ZOMBIE)
  1001ec:	83 f9 03             	cmp    $0x3,%ecx
  1001ef:	75 0b                	jne    1001fc <interrupt+0x86>
			current->p_registers.reg_eax = proc_array[p].p_exit_status;
  1001f1:	8b 92 7c 91 10 00    	mov    0x10917c(%edx),%edx
  1001f7:	89 50 20             	mov    %edx,0x20(%eax)
  1001fa:	eb 07                	jmp    100203 <interrupt+0x8d>
		else
			current->p_registers.reg_eax = WAIT_TRYAGAIN;
  1001fc:	c7 40 20 fe ff ff ff 	movl   $0xfffffffe,0x20(%eax)
		schedule();
  100203:	e8 40 ff ff ff       	call   100148 <schedule>
  100208:	eb fe                	jmp    100208 <interrupt+0x92>

0010020a <segments_init>:
{
	int i;

	// Set task state segment
	segments[SEGSEL_TASKSTATE >> 3]
		= SEG16(STS_T32A, (uint32_t) &kernel_task_descriptor,
  10020a:	b8 30 9e 10 00       	mov    $0x109e30,%eax
	kernel_task_descriptor.ts_ss0 = SEGSEL_KERN_DATA;

	// Set up interrupt descriptor table.
	// Most interrupts are effectively ignored
	for (i = 0; i < sizeof(interrupt_descriptors) / sizeof(gatedescriptor_t); i++)
		SETGATE(interrupt_descriptors[i], 0,
  10020f:	b9 56 00 10 00       	mov    $0x100056,%ecx
{
	int i;

	// Set task state segment
	segments[SEGSEL_TASKSTATE >> 3]
		= SEG16(STS_T32A, (uint32_t) &kernel_task_descriptor,
  100214:	89 c2                	mov    %eax,%edx
  100216:	c1 ea 10             	shr    $0x10,%edx
  100219:	66 a3 3a 10 10 00    	mov    %ax,0x10103a
  10021f:	c1 e8 18             	shr    $0x18,%eax
  100222:	88 15 3c 10 10 00    	mov    %dl,0x10103c
	kernel_task_descriptor.ts_ss0 = SEGSEL_KERN_DATA;

	// Set up interrupt descriptor table.
	// Most interrupts are effectively ignored
	for (i = 0; i < sizeof(interrupt_descriptors) / sizeof(gatedescriptor_t); i++)
		SETGATE(interrupt_descriptors[i], 0,
  100228:	ba 56 00 10 00       	mov    $0x100056,%edx
{
	int i;

	// Set task state segment
	segments[SEGSEL_TASKSTATE >> 3]
		= SEG16(STS_T32A, (uint32_t) &kernel_task_descriptor,
  10022d:	a2 3f 10 10 00       	mov    %al,0x10103f
	kernel_task_descriptor.ts_ss0 = SEGSEL_KERN_DATA;

	// Set up interrupt descriptor table.
	// Most interrupts are effectively ignored
	for (i = 0; i < sizeof(interrupt_descriptors) / sizeof(gatedescriptor_t); i++)
		SETGATE(interrupt_descriptors[i], 0,
  100232:	c1 ea 10             	shr    $0x10,%edx
	kernel_task_descriptor.ts_esp0 = KERNEL_STACK_TOP;
	kernel_task_descriptor.ts_ss0 = SEGSEL_KERN_DATA;

	// Set up interrupt descriptor table.
	// Most interrupts are effectively ignored
	for (i = 0; i < sizeof(interrupt_descriptors) / sizeof(gatedescriptor_t); i++)
  100235:	31 c0                	xor    %eax,%eax
{
	int i;

	// Set task state segment
	segments[SEGSEL_TASKSTATE >> 3]
		= SEG16(STS_T32A, (uint32_t) &kernel_task_descriptor,
  100237:	66 c7 05 38 10 10 00 	movw   $0x68,0x101038
  10023e:	68 00 
  100240:	c6 05 3e 10 10 00 40 	movb   $0x40,0x10103e
			sizeof(taskstate_t), 0);
	segments[SEGSEL_TASKSTATE >> 3].sd_s = 0;
  100247:	c6 05 3d 10 10 00 89 	movb   $0x89,0x10103d

	// Set up kernel task descriptor, so we can receive interrupts
	kernel_task_descriptor.ts_esp0 = KERNEL_STACK_TOP;
  10024e:	c7 05 34 9e 10 00 00 	movl   $0x80000,0x109e34
  100255:	00 08 00 
	kernel_task_descriptor.ts_ss0 = SEGSEL_KERN_DATA;
  100258:	66 c7 05 38 9e 10 00 	movw   $0x10,0x109e38
  10025f:	10 00 

	// Set up interrupt descriptor table.
	// Most interrupts are effectively ignored
	for (i = 0; i < sizeof(interrupt_descriptors) / sizeof(gatedescriptor_t); i++)
		SETGATE(interrupt_descriptors[i], 0,
  100261:	66 89 0c c5 30 96 10 	mov    %cx,0x109630(,%eax,8)
  100268:	00 
  100269:	66 c7 04 c5 32 96 10 	movw   $0x8,0x109632(,%eax,8)
  100270:	00 08 00 
  100273:	c6 04 c5 34 96 10 00 	movb   $0x0,0x109634(,%eax,8)
  10027a:	00 
  10027b:	c6 04 c5 35 96 10 00 	movb   $0x8e,0x109635(,%eax,8)
  100282:	8e 
  100283:	66 89 14 c5 36 96 10 	mov    %dx,0x109636(,%eax,8)
  10028a:	00 
	kernel_task_descriptor.ts_esp0 = KERNEL_STACK_TOP;
	kernel_task_descriptor.ts_ss0 = SEGSEL_KERN_DATA;

	// Set up interrupt descriptor table.
	// Most interrupts are effectively ignored
	for (i = 0; i < sizeof(interrupt_descriptors) / sizeof(gatedescriptor_t); i++)
  10028b:	40                   	inc    %eax
  10028c:	3d 00 01 00 00       	cmp    $0x100,%eax
  100291:	75 ce                	jne    100261 <segments_init+0x57>
  100293:	66 b8 30 00          	mov    $0x30,%ax

	// System calls get special handling.
	// Note that the last argument is '3'.  This means that unprivileged
	// (level-3) applications may generate these interrupts.
	for (i = INT_SYS_GETPID; i < INT_SYS_GETPID + 10; i++)
		SETGATE(interrupt_descriptors[i], 0,
  100297:	8b 14 85 a3 ff 0f 00 	mov    0xfffa3(,%eax,4),%edx
  10029e:	66 c7 04 c5 32 96 10 	movw   $0x8,0x109632(,%eax,8)
  1002a5:	00 08 00 
  1002a8:	c6 04 c5 34 96 10 00 	movb   $0x0,0x109634(,%eax,8)
  1002af:	00 
  1002b0:	c6 04 c5 35 96 10 00 	movb   $0xee,0x109635(,%eax,8)
  1002b7:	ee 
  1002b8:	66 89 14 c5 30 96 10 	mov    %dx,0x109630(,%eax,8)
  1002bf:	00 
  1002c0:	c1 ea 10             	shr    $0x10,%edx
  1002c3:	66 89 14 c5 36 96 10 	mov    %dx,0x109636(,%eax,8)
  1002ca:	00 
			SEGSEL_KERN_CODE, default_int_handler, 0);

	// System calls get special handling.
	// Note that the last argument is '3'.  This means that unprivileged
	// (level-3) applications may generate these interrupts.
	for (i = INT_SYS_GETPID; i < INT_SYS_GETPID + 10; i++)
  1002cb:	40                   	inc    %eax
  1002cc:	83 f8 3a             	cmp    $0x3a,%eax
  1002cf:	75 c6                	jne    100297 <segments_init+0x8d>
		SETGATE(interrupt_descriptors[i], 0,
			SEGSEL_KERN_CODE, sys_int_handlers[i - INT_SYS_GETPID], 3);

	// Reload segment pointers
	asm volatile("lgdt global_descriptor_table\n\t"
  1002d1:	b0 28                	mov    $0x28,%al
  1002d3:	0f 01 15 08 10 10 00 	lgdtl  0x101008
  1002da:	0f 00 d8             	ltr    %ax
  1002dd:	0f 01 1d 00 10 10 00 	lidtl  0x101000
  1002e4:	c3                   	ret    

001002e5 <special_registers_init>:
 *
 *****************************************************************************/

void
special_registers_init(process_t *proc)
{
  1002e5:	53                   	push   %ebx
  1002e6:	83 ec 18             	sub    $0x18,%esp
  1002e9:	8b 5c 24 20          	mov    0x20(%esp),%ebx
	memset(&proc->p_registers, 0, sizeof(registers_t));
  1002ed:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  1002f4:	00 
  1002f5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1002fc:	00 
  1002fd:	8d 43 04             	lea    0x4(%ebx),%eax
  100300:	89 04 24             	mov    %eax,(%esp)
  100303:	e8 48 02 00 00       	call   100550 <memset>
	proc->p_registers.reg_cs = SEGSEL_APP_CODE | 3;
  100308:	66 c7 43 38 1b 00    	movw   $0x1b,0x38(%ebx)
	proc->p_registers.reg_ds = SEGSEL_APP_DATA | 3;
  10030e:	66 c7 43 28 23 00    	movw   $0x23,0x28(%ebx)
	proc->p_registers.reg_es = SEGSEL_APP_DATA | 3;
  100314:	66 c7 43 24 23 00    	movw   $0x23,0x24(%ebx)
	proc->p_registers.reg_ss = SEGSEL_APP_DATA | 3;
  10031a:	66 c7 43 44 23 00    	movw   $0x23,0x44(%ebx)
}
  100320:	83 c4 18             	add    $0x18,%esp
  100323:	5b                   	pop    %ebx
  100324:	c3                   	ret    

00100325 <console_clear>:

void
console_clear(void)
{
	int i;
	cursorpos = (uint16_t *) 0xB8000;
  100325:	c7 05 00 00 06 00 00 	movl   $0xb8000,0x60000
  10032c:	80 0b 00 

	for (i = 0; i < 80 * 25; i++)
  10032f:	31 c0                	xor    %eax,%eax
		cursorpos[i] = ' ' | 0x0700;
  100331:	66 c7 84 00 00 80 0b 	movw   $0x720,0xb8000(%eax,%eax,1)
  100338:	00 20 07 
console_clear(void)
{
	int i;
	cursorpos = (uint16_t *) 0xB8000;

	for (i = 0; i < 80 * 25; i++)
  10033b:	40                   	inc    %eax
  10033c:	3d d0 07 00 00       	cmp    $0x7d0,%eax
  100341:	75 ee                	jne    100331 <console_clear+0xc>
 *
 *****************************************************************************/

void
console_clear(void)
{
  100343:	56                   	push   %esi
}

static inline void
outb(int port, uint8_t data)
{
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  100344:	be d4 03 00 00       	mov    $0x3d4,%esi
  100349:	53                   	push   %ebx
  10034a:	b0 0e                	mov    $0xe,%al
  10034c:	89 f2                	mov    %esi,%edx
  10034e:	ee                   	out    %al,(%dx)
  10034f:	31 c9                	xor    %ecx,%ecx
  100351:	bb d5 03 00 00       	mov    $0x3d5,%ebx
  100356:	88 c8                	mov    %cl,%al
  100358:	89 da                	mov    %ebx,%edx
  10035a:	ee                   	out    %al,(%dx)
  10035b:	b0 0f                	mov    $0xf,%al
  10035d:	89 f2                	mov    %esi,%edx
  10035f:	ee                   	out    %al,(%dx)
  100360:	88 c8                	mov    %cl,%al
  100362:	89 da                	mov    %ebx,%edx
  100364:	ee                   	out    %al,(%dx)
		cursorpos[i] = ' ' | 0x0700;
	outb(0x3D4, 14);
	outb(0x3D5, 0 / 256);
	outb(0x3D4, 15);
	outb(0x3D5, 0 % 256);
}
  100365:	5b                   	pop    %ebx
  100366:	5e                   	pop    %esi
  100367:	c3                   	ret    

00100368 <console_read_digit>:

static inline uint8_t
inb(int port)
{
	uint8_t data;
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  100368:	ba 64 00 00 00       	mov    $0x64,%edx
  10036d:	ec                   	in     (%dx),%al
int
console_read_digit(void)
{
	uint8_t data;

	if ((inb(KBSTATP) & KBS_DIB) == 0)
  10036e:	a8 01                	test   $0x1,%al
  100370:	74 4c                	je     1003be <console_read_digit+0x56>
  100372:	b2 60                	mov    $0x60,%dl
  100374:	ec                   	in     (%dx),%al
		return -1;

	data = inb(KBDATAP);
	if (data >= 0x02 && data <= 0x0A)
  100375:	8d 50 fe             	lea    -0x2(%eax),%edx
  100378:	80 fa 08             	cmp    $0x8,%dl
  10037b:	77 05                	ja     100382 <console_read_digit+0x1a>
		return data - 0x02 + 1;
  10037d:	0f b6 c0             	movzbl %al,%eax
  100380:	48                   	dec    %eax
  100381:	c3                   	ret    
	else if (data == 0x0B)
  100382:	3c 0b                	cmp    $0xb,%al
  100384:	74 3c                	je     1003c2 <console_read_digit+0x5a>
		return 0;
	else if (data >= 0x47 && data <= 0x49)
  100386:	8d 50 b9             	lea    -0x47(%eax),%edx
  100389:	80 fa 02             	cmp    $0x2,%dl
  10038c:	77 07                	ja     100395 <console_read_digit+0x2d>
		return data - 0x47 + 7;
  10038e:	0f b6 c0             	movzbl %al,%eax
  100391:	83 e8 40             	sub    $0x40,%eax
  100394:	c3                   	ret    
	else if (data >= 0x4B && data <= 0x4D)
  100395:	8d 50 b5             	lea    -0x4b(%eax),%edx
  100398:	80 fa 02             	cmp    $0x2,%dl
  10039b:	77 07                	ja     1003a4 <console_read_digit+0x3c>
		return data - 0x4B + 4;
  10039d:	0f b6 c0             	movzbl %al,%eax
  1003a0:	83 e8 47             	sub    $0x47,%eax
  1003a3:	c3                   	ret    
	else if (data >= 0x4F && data <= 0x51)
  1003a4:	8d 50 b1             	lea    -0x4f(%eax),%edx
  1003a7:	80 fa 02             	cmp    $0x2,%dl
  1003aa:	77 07                	ja     1003b3 <console_read_digit+0x4b>
		return data - 0x4F + 1;
  1003ac:	0f b6 c0             	movzbl %al,%eax
  1003af:	83 e8 4e             	sub    $0x4e,%eax
  1003b2:	c3                   	ret    
	else if (data == 0x53)
  1003b3:	3c 53                	cmp    $0x53,%al
  1003b5:	0f 95 c0             	setne  %al
  1003b8:	0f b6 c0             	movzbl %al,%eax
  1003bb:	f7 d8                	neg    %eax
  1003bd:	c3                   	ret    
console_read_digit(void)
{
	uint8_t data;

	if ((inb(KBSTATP) & KBS_DIB) == 0)
		return -1;
  1003be:	83 c8 ff             	or     $0xffffffff,%eax
  1003c1:	c3                   	ret    

	data = inb(KBDATAP);
	if (data >= 0x02 && data <= 0x0A)
		return data - 0x02 + 1;
	else if (data == 0x0B)
		return 0;
  1003c2:	31 c0                	xor    %eax,%eax
		return data - 0x4F + 1;
	else if (data == 0x53)
		return 0;
	else
		return -1;
}
  1003c4:	c3                   	ret    

001003c5 <run>:
 *
 *****************************************************************************/

void
run(process_t *proc)
{
  1003c5:	8b 44 24 04          	mov    0x4(%esp),%eax
	current = proc;
  1003c9:	a3 98 9e 10 00       	mov    %eax,0x109e98
		     "popal\n\t"
		     "popl %%es\n\t"
		     "popl %%ds\n\t"
		     "addl $8, %%esp\n\t"
		     "iret"
		     : : "g" (&proc->p_registers) : "memory");
  1003ce:	83 c0 04             	add    $0x4,%eax
void
run(process_t *proc)
{
	current = proc;

	asm volatile("movl %0,%%esp\n\t"
  1003d1:	89 c4                	mov    %eax,%esp
  1003d3:	61                   	popa   
  1003d4:	07                   	pop    %es
  1003d5:	1f                   	pop    %ds
  1003d6:	83 c4 08             	add    $0x8,%esp
  1003d9:	cf                   	iret   
  1003da:	eb fe                	jmp    1003da <run+0x15>

001003dc <program_loader>:
		    uint32_t filesz, uint32_t memsz);
static void loader_panic(void);

void
program_loader(int program_id, uint32_t *entry_point)
{
  1003dc:	55                   	push   %ebp
  1003dd:	57                   	push   %edi
  1003de:	56                   	push   %esi
  1003df:	53                   	push   %ebx
  1003e0:	83 ec 1c             	sub    $0x1c,%esp
  1003e3:	8b 44 24 30          	mov    0x30(%esp),%eax
	struct Proghdr *ph, *eph;
	struct Elf *elf_header;
	int nprograms = sizeof(ramimages) / sizeof(ramimages[0]);

	if (program_id < 0 || program_id >= nprograms)
  1003e7:	83 f8 01             	cmp    $0x1,%eax
  1003ea:	76 02                	jbe    1003ee <program_loader+0x12>
  1003ec:	eb fe                	jmp    1003ec <program_loader+0x10>
		loader_panic();

	// is this a valid ELF?
	elf_header = (struct Elf *) ramimages[program_id].begin;
  1003ee:	8b 34 c5 40 10 10 00 	mov    0x101040(,%eax,8),%esi
	if (elf_header->e_magic != ELF_MAGIC)
  1003f5:	81 3e 7f 45 4c 46    	cmpl   $0x464c457f,(%esi)
  1003fb:	74 02                	je     1003ff <program_loader+0x23>
  1003fd:	eb fe                	jmp    1003fd <program_loader+0x21>
		loader_panic();

	// load each program segment (ignores ph flags)
	ph = (struct Proghdr*) ((const uint8_t *) elf_header + elf_header->e_phoff);
  1003ff:	8b 5e 1c             	mov    0x1c(%esi),%ebx
	eph = ph + elf_header->e_phnum;
  100402:	0f b7 7e 2c          	movzwl 0x2c(%esi),%edi
	elf_header = (struct Elf *) ramimages[program_id].begin;
	if (elf_header->e_magic != ELF_MAGIC)
		loader_panic();

	// load each program segment (ignores ph flags)
	ph = (struct Proghdr*) ((const uint8_t *) elf_header + elf_header->e_phoff);
  100406:	01 f3                	add    %esi,%ebx
	eph = ph + elf_header->e_phnum;
  100408:	c1 e7 05             	shl    $0x5,%edi
  10040b:	8d 04 3b             	lea    (%ebx,%edi,1),%eax
  10040e:	89 44 24 0c          	mov    %eax,0xc(%esp)
	for (; ph < eph; ph++)
  100412:	3b 5c 24 0c          	cmp    0xc(%esp),%ebx
  100416:	73 40                	jae    100458 <program_loader+0x7c>
		if (ph->p_type == ELF_PROG_LOAD)
  100418:	83 3b 01             	cmpl   $0x1,(%ebx)
  10041b:	75 36                	jne    100453 <program_loader+0x77>
			copyseg((void *) ph->p_va,
  10041d:	8b 43 08             	mov    0x8(%ebx),%eax
// then clear the memory from 'va+filesz' up to 'va+memsz' (set it to 0).
static void
copyseg(void *dst, const uint8_t *src, uint32_t filesz, uint32_t memsz)
{
	uint32_t va = (uint32_t) dst;
	uint32_t end_va = va + filesz;
  100420:	8b 7b 10             	mov    0x10(%ebx),%edi
	memsz += va;
  100423:	8b 6b 14             	mov    0x14(%ebx),%ebp
// then clear the memory from 'va+filesz' up to 'va+memsz' (set it to 0).
static void
copyseg(void *dst, const uint8_t *src, uint32_t filesz, uint32_t memsz)
{
	uint32_t va = (uint32_t) dst;
	uint32_t end_va = va + filesz;
  100426:	01 c7                	add    %eax,%edi
	memsz += va;
  100428:	01 c5                	add    %eax,%ebp
	va &= ~(PAGESIZE - 1);		// round to page boundary

	// copy data
	memcpy((uint8_t *) va, src, end_va - va);
  10042a:	89 f9                	mov    %edi,%ecx
copyseg(void *dst, const uint8_t *src, uint32_t filesz, uint32_t memsz)
{
	uint32_t va = (uint32_t) dst;
	uint32_t end_va = va + filesz;
	memsz += va;
	va &= ~(PAGESIZE - 1);		// round to page boundary
  10042c:	25 00 f0 ff ff       	and    $0xfffff000,%eax

	// copy data
	memcpy((uint8_t *) va, src, end_va - va);
  100431:	29 c1                	sub    %eax,%ecx
  100433:	89 4c 24 08          	mov    %ecx,0x8(%esp)
	// load each program segment (ignores ph flags)
	ph = (struct Proghdr*) ((const uint8_t *) elf_header + elf_header->e_phoff);
	eph = ph + elf_header->e_phnum;
	for (; ph < eph; ph++)
		if (ph->p_type == ELF_PROG_LOAD)
			copyseg((void *) ph->p_va,
  100437:	8b 4b 04             	mov    0x4(%ebx),%ecx
	uint32_t end_va = va + filesz;
	memsz += va;
	va &= ~(PAGESIZE - 1);		// round to page boundary

	// copy data
	memcpy((uint8_t *) va, src, end_va - va);
  10043a:	89 04 24             	mov    %eax,(%esp)
	// load each program segment (ignores ph flags)
	ph = (struct Proghdr*) ((const uint8_t *) elf_header + elf_header->e_phoff);
	eph = ph + elf_header->e_phnum;
	for (; ph < eph; ph++)
		if (ph->p_type == ELF_PROG_LOAD)
			copyseg((void *) ph->p_va,
  10043d:	01 f1                	add    %esi,%ecx
	uint32_t end_va = va + filesz;
	memsz += va;
	va &= ~(PAGESIZE - 1);		// round to page boundary

	// copy data
	memcpy((uint8_t *) va, src, end_va - va);
  10043f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100443:	e8 9e 00 00 00       	call   1004e6 <memcpy>

	// clear bss segment
	while (end_va < memsz)
  100448:	39 ef                	cmp    %ebp,%edi
  10044a:	73 07                	jae    100453 <program_loader+0x77>
		*((uint8_t *) end_va++) = 0;
  10044c:	47                   	inc    %edi
  10044d:	c6 47 ff 00          	movb   $0x0,-0x1(%edi)
  100451:	eb f5                	jmp    100448 <program_loader+0x6c>
		loader_panic();

	// load each program segment (ignores ph flags)
	ph = (struct Proghdr*) ((const uint8_t *) elf_header + elf_header->e_phoff);
	eph = ph + elf_header->e_phnum;
	for (; ph < eph; ph++)
  100453:	83 c3 20             	add    $0x20,%ebx
  100456:	eb ba                	jmp    100412 <program_loader+0x36>
			copyseg((void *) ph->p_va,
				(const uint8_t *) elf_header + ph->p_offset,
				ph->p_filesz, ph->p_memsz);

	// store the entry point from the ELF header
	*entry_point = elf_header->e_entry;
  100458:	8b 56 18             	mov    0x18(%esi),%edx
  10045b:	8b 44 24 34          	mov    0x34(%esp),%eax
  10045f:	89 10                	mov    %edx,(%eax)
}
  100461:	83 c4 1c             	add    $0x1c,%esp
  100464:	5b                   	pop    %ebx
  100465:	5e                   	pop    %esi
  100466:	5f                   	pop    %edi
  100467:	5d                   	pop    %ebp
  100468:	c3                   	ret    

00100469 <console_putc>:
 *
 *   Print a message onto the console, starting at the given cursor position. */

static uint16_t *
console_putc(uint16_t *cursor, unsigned char c, int color)
{
  100469:	56                   	push   %esi
	if (cursor >= CONSOLE_END)
		cursor = CONSOLE_BEGIN;
  10046a:	3d a0 8f 0b 00       	cmp    $0xb8fa0,%eax
 *
 *   Print a message onto the console, starting at the given cursor position. */

static uint16_t *
console_putc(uint16_t *cursor, unsigned char c, int color)
{
  10046f:	53                   	push   %ebx
  100470:	89 c3                	mov    %eax,%ebx
	if (cursor >= CONSOLE_END)
		cursor = CONSOLE_BEGIN;
  100472:	b8 00 80 0b 00       	mov    $0xb8000,%eax
  100477:	0f 43 d8             	cmovae %eax,%ebx
	if (c == '\n') {
  10047a:	80 fa 0a             	cmp    $0xa,%dl
  10047d:	75 2c                	jne    1004ab <console_putc+0x42>
		int pos = (cursor - CONSOLE_BEGIN) % 80;
  10047f:	8d 83 00 80 f4 ff    	lea    -0xb8000(%ebx),%eax
  100485:	be 50 00 00 00       	mov    $0x50,%esi
  10048a:	d1 f8                	sar    %eax
		for (; pos != 80; pos++)
			*cursor++ = ' ' | color;
  10048c:	83 c9 20             	or     $0x20,%ecx
console_putc(uint16_t *cursor, unsigned char c, int color)
{
	if (cursor >= CONSOLE_END)
		cursor = CONSOLE_BEGIN;
	if (c == '\n') {
		int pos = (cursor - CONSOLE_BEGIN) % 80;
  10048f:	99                   	cltd   
  100490:	f7 fe                	idiv   %esi
  100492:	6b c2 fe             	imul   $0xfffffffe,%edx,%eax
  100495:	8d 34 03             	lea    (%ebx,%eax,1),%esi
		for (; pos != 80; pos++)
			*cursor++ = ' ' | color;
  100498:	66 89 0c 56          	mov    %cx,(%esi,%edx,2)
{
	if (cursor >= CONSOLE_END)
		cursor = CONSOLE_BEGIN;
	if (c == '\n') {
		int pos = (cursor - CONSOLE_BEGIN) % 80;
		for (; pos != 80; pos++)
  10049c:	42                   	inc    %edx
  10049d:	83 fa 50             	cmp    $0x50,%edx
  1004a0:	75 f6                	jne    100498 <console_putc+0x2f>
  1004a2:	8d 84 03 a0 00 00 00 	lea    0xa0(%ebx,%eax,1),%eax
  1004a9:	eb 0b                	jmp    1004b6 <console_putc+0x4d>
			*cursor++ = ' ' | color;
	} else
		*cursor++ = c | color;
  1004ab:	0f b6 d2             	movzbl %dl,%edx
  1004ae:	09 ca                	or     %ecx,%edx
  1004b0:	8d 43 02             	lea    0x2(%ebx),%eax
  1004b3:	66 89 13             	mov    %dx,(%ebx)
	return cursor;
}
  1004b6:	5b                   	pop    %ebx
  1004b7:	5e                   	pop    %esi
  1004b8:	c3                   	ret    

001004b9 <fill_numbuf>:
static const char lower_digits[] = "0123456789abcdef";

static char *
fill_numbuf(char *numbuf_end, uint32_t val, int base, const char *digits,
	    int precision)
{
  1004b9:	56                   	push   %esi
  1004ba:	53                   	push   %ebx
  1004bb:	8b 74 24 0c          	mov    0xc(%esp),%esi
	*--numbuf_end = '\0';
	if (precision != 0 || val != 0)
  1004bf:	83 7c 24 10 00       	cmpl   $0x0,0x10(%esp)

static char *
fill_numbuf(char *numbuf_end, uint32_t val, int base, const char *digits,
	    int precision)
{
	*--numbuf_end = '\0';
  1004c4:	8d 58 ff             	lea    -0x1(%eax),%ebx
  1004c7:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
	if (precision != 0 || val != 0)
  1004cb:	75 04                	jne    1004d1 <fill_numbuf+0x18>
  1004cd:	85 d2                	test   %edx,%edx
  1004cf:	74 10                	je     1004e1 <fill_numbuf+0x28>
		do {
			*--numbuf_end = digits[val % base];
  1004d1:	89 d0                	mov    %edx,%eax
  1004d3:	31 d2                	xor    %edx,%edx
  1004d5:	f7 f1                	div    %ecx
  1004d7:	4b                   	dec    %ebx
  1004d8:	8a 14 16             	mov    (%esi,%edx,1),%dl
  1004db:	88 13                	mov    %dl,(%ebx)
			val /= base;
  1004dd:	89 c2                	mov    %eax,%edx
  1004df:	eb ec                	jmp    1004cd <fill_numbuf+0x14>
		} while (val != 0);
	return numbuf_end;
}
  1004e1:	89 d8                	mov    %ebx,%eax
  1004e3:	5b                   	pop    %ebx
  1004e4:	5e                   	pop    %esi
  1004e5:	c3                   	ret    

001004e6 <memcpy>:
 *
 *   We must provide our own implementations of these basic functions. */

void *
memcpy(void *dst, const void *src, size_t n)
{
  1004e6:	53                   	push   %ebx
  1004e7:	8b 44 24 08          	mov    0x8(%esp),%eax
	const char *s = (const char *) src;
	char *d = (char *) dst;
	while (n-- > 0)
  1004eb:	31 d2                	xor    %edx,%edx
 *
 *   We must provide our own implementations of these basic functions. */

void *
memcpy(void *dst, const void *src, size_t n)
{
  1004ed:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
	const char *s = (const char *) src;
	char *d = (char *) dst;
	while (n-- > 0)
  1004f1:	3b 54 24 10          	cmp    0x10(%esp),%edx
  1004f5:	74 09                	je     100500 <memcpy+0x1a>
		*d++ = *s++;
  1004f7:	8a 0c 13             	mov    (%ebx,%edx,1),%cl
  1004fa:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  1004fd:	42                   	inc    %edx
  1004fe:	eb f1                	jmp    1004f1 <memcpy+0xb>
	return dst;
}
  100500:	5b                   	pop    %ebx
  100501:	c3                   	ret    

00100502 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  100502:	55                   	push   %ebp
  100503:	57                   	push   %edi
  100504:	56                   	push   %esi
  100505:	53                   	push   %ebx
  100506:	8b 44 24 14          	mov    0x14(%esp),%eax
  10050a:	8b 5c 24 18          	mov    0x18(%esp),%ebx
  10050e:	8b 6c 24 1c          	mov    0x1c(%esp),%ebp
	const char *s = (const char *) src;
	char *d = (char *) dst;
	if (s < d && s + n > d) {
  100512:	39 c3                	cmp    %eax,%ebx
  100514:	72 04                	jb     10051a <memmove+0x18>
		s += n, d += n;
		while (n-- > 0)
  100516:	31 c9                	xor    %ecx,%ecx
  100518:	eb 24                	jmp    10053e <memmove+0x3c>
void *
memmove(void *dst, const void *src, size_t n)
{
	const char *s = (const char *) src;
	char *d = (char *) dst;
	if (s < d && s + n > d) {
  10051a:	8d 34 2b             	lea    (%ebx,%ebp,1),%esi
  10051d:	39 c6                	cmp    %eax,%esi
  10051f:	76 f5                	jbe    100516 <memmove+0x14>
  100521:	89 e9                	mov    %ebp,%ecx
		s += n, d += n;
		while (n-- > 0)
  100523:	89 ea                	mov    %ebp,%edx
  100525:	f7 d9                	neg    %ecx
memmove(void *dst, const void *src, size_t n)
{
	const char *s = (const char *) src;
	char *d = (char *) dst;
	if (s < d && s + n > d) {
		s += n, d += n;
  100527:	8d 3c 28             	lea    (%eax,%ebp,1),%edi
  10052a:	01 ce                	add    %ecx,%esi
		while (n-- > 0)
  10052c:	4a                   	dec    %edx
  10052d:	83 fa ff             	cmp    $0xffffffff,%edx
  100530:	74 19                	je     10054b <memmove+0x49>
			*--d = *--s;
  100532:	8a 1c 16             	mov    (%esi,%edx,1),%bl
  100535:	8d 2c 0f             	lea    (%edi,%ecx,1),%ebp
  100538:	88 5c 15 00          	mov    %bl,0x0(%ebp,%edx,1)
  10053c:	eb ee                	jmp    10052c <memmove+0x2a>
	} else
		while (n-- > 0)
  10053e:	39 e9                	cmp    %ebp,%ecx
  100540:	74 09                	je     10054b <memmove+0x49>
			*d++ = *s++;
  100542:	8a 14 0b             	mov    (%ebx,%ecx,1),%dl
  100545:	88 14 08             	mov    %dl,(%eax,%ecx,1)
  100548:	41                   	inc    %ecx
  100549:	eb f3                	jmp    10053e <memmove+0x3c>
	return dst;
}
  10054b:	5b                   	pop    %ebx
  10054c:	5e                   	pop    %esi
  10054d:	5f                   	pop    %edi
  10054e:	5d                   	pop    %ebp
  10054f:	c3                   	ret    

00100550 <memset>:

void *
memset(void *v, int c, size_t n)
{
  100550:	8b 44 24 04          	mov    0x4(%esp),%eax
	char *p = (char *) v;
	while (n-- > 0)
  100554:	31 d2                	xor    %edx,%edx
	return dst;
}

void *
memset(void *v, int c, size_t n)
{
  100556:	8b 4c 24 08          	mov    0x8(%esp),%ecx
	char *p = (char *) v;
	while (n-- > 0)
  10055a:	3b 54 24 0c          	cmp    0xc(%esp),%edx
  10055e:	74 06                	je     100566 <memset+0x16>
		*p++ = c;
  100560:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  100563:	42                   	inc    %edx
  100564:	eb f4                	jmp    10055a <memset+0xa>
	return v;
}
  100566:	c3                   	ret    

00100567 <strlen>:

size_t
strlen(const char *s)
{
  100567:	8b 54 24 04          	mov    0x4(%esp),%edx
	size_t n;
	for (n = 0; *s != '\0'; ++s)
  10056b:	31 c0                	xor    %eax,%eax
  10056d:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  100571:	74 03                	je     100576 <strlen+0xf>
		++n;
  100573:	40                   	inc    %eax
  100574:	eb f7                	jmp    10056d <strlen+0x6>
	return n;
}
  100576:	c3                   	ret    

00100577 <strnlen>:

size_t
strnlen(const char *s, size_t maxlen)
{
  100577:	8b 54 24 04          	mov    0x4(%esp),%edx
	size_t n;
	for (n = 0; n != maxlen && *s != '\0'; ++s)
  10057b:	31 c0                	xor    %eax,%eax
  10057d:	3b 44 24 08          	cmp    0x8(%esp),%eax
  100581:	74 09                	je     10058c <strnlen+0x15>
  100583:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  100587:	74 03                	je     10058c <strnlen+0x15>
		++n;
  100589:	40                   	inc    %eax
  10058a:	eb f1                	jmp    10057d <strnlen+0x6>
	return n;
}
  10058c:	c3                   	ret    

0010058d <console_vprintf>:
#define FLAG_PLUSPOSITIVE	(1<<4)
static const char flag_chars[] = "#0- +";

uint16_t *
console_vprintf(uint16_t *cursor, int color, const char *format, va_list val)
{
  10058d:	55                   	push   %ebp
  10058e:	57                   	push   %edi
  10058f:	56                   	push   %esi
  100590:	53                   	push   %ebx
  100591:	83 ec 3c             	sub    $0x3c,%esp
  100594:	8b 6c 24 50          	mov    0x50(%esp),%ebp
  100598:	8b 5c 24 5c          	mov    0x5c(%esp),%ebx
	int flags, width, zeros, precision, negative, numeric, len;
#define NUMBUFSIZ 20
	char numbuf[NUMBUFSIZ];
	char *data;

	for (; *format; ++format) {
  10059c:	8b 44 24 58          	mov    0x58(%esp),%eax
  1005a0:	0f b6 10             	movzbl (%eax),%edx
  1005a3:	84 d2                	test   %dl,%dl
  1005a5:	0f 84 94 03 00 00    	je     10093f <console_vprintf+0x3b2>
		if (*format != '%') {
  1005ab:	80 fa 25             	cmp    $0x25,%dl
  1005ae:	74 12                	je     1005c2 <console_vprintf+0x35>
			cursor = console_putc(cursor, *format, color);
  1005b0:	8b 4c 24 54          	mov    0x54(%esp),%ecx
  1005b4:	89 e8                	mov    %ebp,%eax
  1005b6:	e8 ae fe ff ff       	call   100469 <console_putc>
  1005bb:	89 c5                	mov    %eax,%ebp
			continue;
  1005bd:	e9 5d 03 00 00       	jmp    10091f <console_vprintf+0x392>
		}

		// process flags
		flags = 0;
		for (++format; *format; ++format) {
  1005c2:	ff 44 24 58          	incl   0x58(%esp)
			const char *flagc = flag_chars;
			while (*flagc != '\0' && *flagc != *format)
				++flagc;
			if (*flagc == '\0')
				break;
			flags |= (1 << (flagc - flag_chars));
  1005c6:	be 01 00 00 00       	mov    $0x1,%esi
			cursor = console_putc(cursor, *format, color);
			continue;
		}

		// process flags
		flags = 0;
  1005cb:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  1005d2:	00 
		for (++format; *format; ++format) {
  1005d3:	8b 44 24 58          	mov    0x58(%esp),%eax
  1005d7:	8a 00                	mov    (%eax),%al
  1005d9:	84 c0                	test   %al,%al
  1005db:	74 16                	je     1005f3 <console_vprintf+0x66>
  1005dd:	b9 bc 09 10 00       	mov    $0x1009bc,%ecx
			const char *flagc = flag_chars;
			while (*flagc != '\0' && *flagc != *format)
  1005e2:	8a 11                	mov    (%ecx),%dl
  1005e4:	84 d2                	test   %dl,%dl
  1005e6:	74 0b                	je     1005f3 <console_vprintf+0x66>
  1005e8:	38 c2                	cmp    %al,%dl
  1005ea:	0f 84 38 03 00 00    	je     100928 <console_vprintf+0x39b>
				++flagc;
  1005f0:	41                   	inc    %ecx
  1005f1:	eb ef                	jmp    1005e2 <console_vprintf+0x55>
			flags |= (1 << (flagc - flag_chars));
		}

		// process width
		width = -1;
		if (*format >= '1' && *format <= '9') {
  1005f3:	8d 50 cf             	lea    -0x31(%eax),%edx
  1005f6:	80 fa 08             	cmp    $0x8,%dl
  1005f9:	77 2a                	ja     100625 <console_vprintf+0x98>
  1005fb:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  100602:	00 
			for (width = 0; *format >= '0' && *format <= '9'; )
  100603:	8b 44 24 58          	mov    0x58(%esp),%eax
  100607:	0f be 00             	movsbl (%eax),%eax
  10060a:	8d 50 d0             	lea    -0x30(%eax),%edx
  10060d:	80 fa 09             	cmp    $0x9,%dl
  100610:	77 2c                	ja     10063e <console_vprintf+0xb1>
				width = 10 * width + *format++ - '0';
  100612:	6b 74 24 0c 0a       	imul   $0xa,0xc(%esp),%esi
  100617:	ff 44 24 58          	incl   0x58(%esp)
  10061b:	8d 44 06 d0          	lea    -0x30(%esi,%eax,1),%eax
  10061f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100623:	eb de                	jmp    100603 <console_vprintf+0x76>
		} else if (*format == '*') {
  100625:	3c 2a                	cmp    $0x2a,%al
				break;
			flags |= (1 << (flagc - flag_chars));
		}

		// process width
		width = -1;
  100627:	c7 44 24 0c ff ff ff 	movl   $0xffffffff,0xc(%esp)
  10062e:	ff 
		if (*format >= '1' && *format <= '9') {
			for (width = 0; *format >= '0' && *format <= '9'; )
				width = 10 * width + *format++ - '0';
		} else if (*format == '*') {
  10062f:	75 0d                	jne    10063e <console_vprintf+0xb1>
			width = va_arg(val, int);
  100631:	8b 03                	mov    (%ebx),%eax
  100633:	83 c3 04             	add    $0x4,%ebx
			++format;
  100636:	ff 44 24 58          	incl   0x58(%esp)
		width = -1;
		if (*format >= '1' && *format <= '9') {
			for (width = 0; *format >= '0' && *format <= '9'; )
				width = 10 * width + *format++ - '0';
		} else if (*format == '*') {
			width = va_arg(val, int);
  10063a:	89 44 24 0c          	mov    %eax,0xc(%esp)
			++format;
		}

		// process precision
		precision = -1;
		if (*format == '.') {
  10063e:	8b 44 24 58          	mov    0x58(%esp),%eax
			width = va_arg(val, int);
			++format;
		}

		// process precision
		precision = -1;
  100642:	83 ce ff             	or     $0xffffffff,%esi
		if (*format == '.') {
  100645:	80 38 2e             	cmpb   $0x2e,(%eax)
  100648:	75 4f                	jne    100699 <console_vprintf+0x10c>
			++format;
			if (*format >= '0' && *format <= '9') {
  10064a:	8b 7c 24 58          	mov    0x58(%esp),%edi
		}

		// process precision
		precision = -1;
		if (*format == '.') {
			++format;
  10064e:	40                   	inc    %eax
			if (*format >= '0' && *format <= '9') {
  10064f:	8a 57 01             	mov    0x1(%edi),%dl
  100652:	8d 4a d0             	lea    -0x30(%edx),%ecx
  100655:	80 f9 09             	cmp    $0x9,%cl
  100658:	77 22                	ja     10067c <console_vprintf+0xef>
  10065a:	89 44 24 58          	mov    %eax,0x58(%esp)
  10065e:	31 f6                	xor    %esi,%esi
				for (precision = 0; *format >= '0' && *format <= '9'; )
  100660:	8b 44 24 58          	mov    0x58(%esp),%eax
  100664:	0f be 00             	movsbl (%eax),%eax
  100667:	8d 50 d0             	lea    -0x30(%eax),%edx
  10066a:	80 fa 09             	cmp    $0x9,%dl
  10066d:	77 2a                	ja     100699 <console_vprintf+0x10c>
					precision = 10 * precision + *format++ - '0';
  10066f:	6b f6 0a             	imul   $0xa,%esi,%esi
  100672:	ff 44 24 58          	incl   0x58(%esp)
  100676:	8d 74 06 d0          	lea    -0x30(%esi,%eax,1),%esi
  10067a:	eb e4                	jmp    100660 <console_vprintf+0xd3>
			} else if (*format == '*') {
  10067c:	80 fa 2a             	cmp    $0x2a,%dl
  10067f:	75 12                	jne    100693 <console_vprintf+0x106>
				precision = va_arg(val, int);
  100681:	8b 33                	mov    (%ebx),%esi
  100683:	8d 43 04             	lea    0x4(%ebx),%eax
				++format;
  100686:	83 44 24 58 02       	addl   $0x2,0x58(%esp)
			++format;
			if (*format >= '0' && *format <= '9') {
				for (precision = 0; *format >= '0' && *format <= '9'; )
					precision = 10 * precision + *format++ - '0';
			} else if (*format == '*') {
				precision = va_arg(val, int);
  10068b:	89 c3                	mov    %eax,%ebx
				++format;
			}
			if (precision < 0)
  10068d:	85 f6                	test   %esi,%esi
  10068f:	79 08                	jns    100699 <console_vprintf+0x10c>
  100691:	eb 04                	jmp    100697 <console_vprintf+0x10a>
		}

		// process precision
		precision = -1;
		if (*format == '.') {
			++format;
  100693:	89 44 24 58          	mov    %eax,0x58(%esp)
			} else if (*format == '*') {
				precision = va_arg(val, int);
				++format;
			}
			if (precision < 0)
				precision = 0;
  100697:	31 f6                	xor    %esi,%esi
		}

		// process main conversion character
		negative = 0;
		numeric = 0;
		switch (*format) {
  100699:	8b 44 24 58          	mov    0x58(%esp),%eax
  10069d:	8a 00                	mov    (%eax),%al
  10069f:	3c 64                	cmp    $0x64,%al
  1006a1:	74 46                	je     1006e9 <console_vprintf+0x15c>
  1006a3:	7f 26                	jg     1006cb <console_vprintf+0x13e>
  1006a5:	3c 58                	cmp    $0x58,%al
  1006a7:	0f 84 9f 00 00 00    	je     10074c <console_vprintf+0x1bf>
  1006ad:	3c 63                	cmp    $0x63,%al
  1006af:	0f 84 c2 00 00 00    	je     100777 <console_vprintf+0x1ea>
  1006b5:	3c 43                	cmp    $0x43,%al
  1006b7:	0f 85 ca 00 00 00    	jne    100787 <console_vprintf+0x1fa>
		}
		case 's':
			data = va_arg(val, char *);
			break;
		case 'C':
			color = va_arg(val, int);
  1006bd:	8b 03                	mov    (%ebx),%eax
  1006bf:	83 c3 04             	add    $0x4,%ebx
  1006c2:	89 44 24 54          	mov    %eax,0x54(%esp)
			goto done;
  1006c6:	e9 54 02 00 00       	jmp    10091f <console_vprintf+0x392>
		}

		// process main conversion character
		negative = 0;
		numeric = 0;
		switch (*format) {
  1006cb:	3c 75                	cmp    $0x75,%al
  1006cd:	74 58                	je     100727 <console_vprintf+0x19a>
  1006cf:	3c 78                	cmp    $0x78,%al
  1006d1:	74 69                	je     10073c <console_vprintf+0x1af>
  1006d3:	3c 73                	cmp    $0x73,%al
  1006d5:	0f 85 ac 00 00 00    	jne    100787 <console_vprintf+0x1fa>
			data = fill_numbuf(numbuf + NUMBUFSIZ, x, 16, upper_digits, precision);
			numeric = 1;
			break;
		}
		case 's':
			data = va_arg(val, char *);
  1006db:	8b 03                	mov    (%ebx),%eax
  1006dd:	83 c3 04             	add    $0x4,%ebx
  1006e0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006e4:	e9 bc 00 00 00       	jmp    1007a5 <console_vprintf+0x218>
		// process main conversion character
		negative = 0;
		numeric = 0;
		switch (*format) {
		case 'd': {
			int x = va_arg(val, int);
  1006e9:	8d 7b 04             	lea    0x4(%ebx),%edi
  1006ec:	8b 1b                	mov    (%ebx),%ebx
			data = fill_numbuf(numbuf + NUMBUFSIZ, x > 0 ? x : -x, 10, upper_digits, precision);
  1006ee:	b9 0a 00 00 00       	mov    $0xa,%ecx
  1006f3:	89 74 24 04          	mov    %esi,0x4(%esp)
  1006f7:	c7 04 24 d8 09 10 00 	movl   $0x1009d8,(%esp)
  1006fe:	89 d8                	mov    %ebx,%eax
  100700:	c1 f8 1f             	sar    $0x1f,%eax
  100703:	89 c2                	mov    %eax,%edx
  100705:	31 da                	xor    %ebx,%edx
  100707:	29 c2                	sub    %eax,%edx
  100709:	8d 44 24 3c          	lea    0x3c(%esp),%eax
  10070d:	e8 a7 fd ff ff       	call   1004b9 <fill_numbuf>
			if (x < 0)
				negative = 1;
  100712:	c1 eb 1f             	shr    $0x1f,%ebx
  100715:	89 d9                	mov    %ebx,%ecx
		// process main conversion character
		negative = 0;
		numeric = 0;
		switch (*format) {
		case 'd': {
			int x = va_arg(val, int);
  100717:	89 fb                	mov    %edi,%ebx
			data = fill_numbuf(numbuf + NUMBUFSIZ, x > 0 ? x : -x, 10, upper_digits, precision);
			if (x < 0)
				negative = 1;
			numeric = 1;
  100719:	bf 01 00 00 00       	mov    $0x1,%edi
		negative = 0;
		numeric = 0;
		switch (*format) {
		case 'd': {
			int x = va_arg(val, int);
			data = fill_numbuf(numbuf + NUMBUFSIZ, x > 0 ? x : -x, 10, upper_digits, precision);
  10071e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100722:	e9 82 00 00 00       	jmp    1007a9 <console_vprintf+0x21c>
				negative = 1;
			numeric = 1;
			break;
		}
		case 'u': {
			unsigned x = va_arg(val, unsigned);
  100727:	8d 7b 04             	lea    0x4(%ebx),%edi
			data = fill_numbuf(numbuf + NUMBUFSIZ, x, 10, upper_digits, precision);
  10072a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  10072f:	89 74 24 04          	mov    %esi,0x4(%esp)
  100733:	c7 04 24 d8 09 10 00 	movl   $0x1009d8,(%esp)
  10073a:	eb 23                	jmp    10075f <console_vprintf+0x1d2>
			numeric = 1;
			break;
		}
		case 'x': {
			unsigned x = va_arg(val, unsigned);
  10073c:	8d 7b 04             	lea    0x4(%ebx),%edi
			data = fill_numbuf(numbuf + NUMBUFSIZ, x, 16, lower_digits, precision);
  10073f:	89 74 24 04          	mov    %esi,0x4(%esp)
  100743:	c7 04 24 c4 09 10 00 	movl   $0x1009c4,(%esp)
  10074a:	eb 0e                	jmp    10075a <console_vprintf+0x1cd>
			numeric = 1;
			break;
		}
		case 'X': {
			unsigned x = va_arg(val, unsigned);
  10074c:	8d 7b 04             	lea    0x4(%ebx),%edi
			data = fill_numbuf(numbuf + NUMBUFSIZ, x, 16, upper_digits, precision);
  10074f:	89 74 24 04          	mov    %esi,0x4(%esp)
  100753:	c7 04 24 d8 09 10 00 	movl   $0x1009d8,(%esp)
  10075a:	b9 10 00 00 00       	mov    $0x10,%ecx
  10075f:	8b 13                	mov    (%ebx),%edx
  100761:	8d 44 24 3c          	lea    0x3c(%esp),%eax
			data = fill_numbuf(numbuf + NUMBUFSIZ, x, 16, lower_digits, precision);
			numeric = 1;
			break;
		}
		case 'X': {
			unsigned x = va_arg(val, unsigned);
  100765:	89 fb                	mov    %edi,%ebx
			data = fill_numbuf(numbuf + NUMBUFSIZ, x, 16, upper_digits, precision);
			numeric = 1;
  100767:	bf 01 00 00 00       	mov    $0x1,%edi
			numeric = 1;
			break;
		}
		case 'X': {
			unsigned x = va_arg(val, unsigned);
			data = fill_numbuf(numbuf + NUMBUFSIZ, x, 16, upper_digits, precision);
  10076c:	e8 48 fd ff ff       	call   1004b9 <fill_numbuf>
  100771:	89 44 24 08          	mov    %eax,0x8(%esp)
  100775:	eb 30                	jmp    1007a7 <console_vprintf+0x21a>
		case 'C':
			color = va_arg(val, int);
			goto done;
		case 'c':
			data = numbuf;
			numbuf[0] = va_arg(val, int);
  100777:	8b 03                	mov    (%ebx),%eax
  100779:	83 c3 04             	add    $0x4,%ebx
			numbuf[1] = '\0';
  10077c:	c6 44 24 29 00       	movb   $0x0,0x29(%esp)
		case 'C':
			color = va_arg(val, int);
			goto done;
		case 'c':
			data = numbuf;
			numbuf[0] = va_arg(val, int);
  100781:	88 44 24 28          	mov    %al,0x28(%esp)
  100785:	eb 16                	jmp    10079d <console_vprintf+0x210>
			numbuf[1] = '\0';
			break;
		normal:
		default:
			data = numbuf;
			numbuf[0] = (*format ? *format : '%');
  100787:	b2 25                	mov    $0x25,%dl
  100789:	84 c0                	test   %al,%al
  10078b:	0f 45 d0             	cmovne %eax,%edx
  10078e:	88 54 24 28          	mov    %dl,0x28(%esp)
			numbuf[1] = '\0';
  100792:	c6 44 24 29 00       	movb   $0x0,0x29(%esp)
			if (!*format)
  100797:	75 04                	jne    10079d <console_vprintf+0x210>
				format--;
  100799:	ff 4c 24 58          	decl   0x58(%esp)
			numbuf[0] = va_arg(val, int);
			numbuf[1] = '\0';
			break;
		normal:
		default:
			data = numbuf;
  10079d:	8d 44 24 28          	lea    0x28(%esp),%eax
  1007a1:	89 44 24 08          	mov    %eax,0x8(%esp)
				precision = 0;
		}

		// process main conversion character
		negative = 0;
		numeric = 0;
  1007a5:	31 ff                	xor    %edi,%edi
			if (precision < 0)
				precision = 0;
		}

		// process main conversion character
		negative = 0;
  1007a7:	31 c9                	xor    %ecx,%ecx
			if (!*format)
				format--;
			break;
		}

		if (precision >= 0)
  1007a9:	83 fe ff             	cmp    $0xffffffff,%esi
  1007ac:	89 4c 24 18          	mov    %ecx,0x18(%esp)
  1007b0:	74 12                	je     1007c4 <console_vprintf+0x237>
			len = strnlen(data, precision);
  1007b2:	8b 44 24 08          	mov    0x8(%esp),%eax
  1007b6:	89 74 24 04          	mov    %esi,0x4(%esp)
  1007ba:	89 04 24             	mov    %eax,(%esp)
  1007bd:	e8 b5 fd ff ff       	call   100577 <strnlen>
  1007c2:	eb 0c                	jmp    1007d0 <console_vprintf+0x243>
		else
			len = strlen(data);
  1007c4:	8b 44 24 08          	mov    0x8(%esp),%eax
  1007c8:	89 04 24             	mov    %eax,(%esp)
  1007cb:	e8 97 fd ff ff       	call   100567 <strlen>
  1007d0:	8b 4c 24 18          	mov    0x18(%esp),%ecx
		if (numeric && negative)
			negative = '-';
  1007d4:	ba 2d 00 00 00       	mov    $0x2d,%edx
		}

		if (precision >= 0)
			len = strnlen(data, precision);
		else
			len = strlen(data);
  1007d9:	89 44 24 10          	mov    %eax,0x10(%esp)
		if (numeric && negative)
  1007dd:	89 f8                	mov    %edi,%eax
  1007df:	83 e0 01             	and    $0x1,%eax
  1007e2:	88 44 24 18          	mov    %al,0x18(%esp)
  1007e6:	89 f8                	mov    %edi,%eax
  1007e8:	84 c8                	test   %cl,%al
  1007ea:	75 17                	jne    100803 <console_vprintf+0x276>
			negative = '-';
		else if (flags & FLAG_PLUSPOSITIVE)
  1007ec:	f6 44 24 14 10       	testb  $0x10,0x14(%esp)
			negative = '+';
  1007f1:	b2 2b                	mov    $0x2b,%dl
			len = strnlen(data, precision);
		else
			len = strlen(data);
		if (numeric && negative)
			negative = '-';
		else if (flags & FLAG_PLUSPOSITIVE)
  1007f3:	75 0e                	jne    100803 <console_vprintf+0x276>
			negative = '+';
		else if (flags & FLAG_SPACEPOSITIVE)
			negative = ' ';
  1007f5:	8b 44 24 14          	mov    0x14(%esp),%eax
  1007f9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100800:	83 e2 20             	and    $0x20,%edx
		else
			negative = 0;
		if (numeric && precision > len)
  100803:	3b 74 24 10          	cmp    0x10(%esp),%esi
  100807:	7e 0f                	jle    100818 <console_vprintf+0x28b>
  100809:	80 7c 24 18 00       	cmpb   $0x0,0x18(%esp)
  10080e:	74 08                	je     100818 <console_vprintf+0x28b>
			zeros = precision - len;
  100810:	2b 74 24 10          	sub    0x10(%esp),%esi
  100814:	89 f7                	mov    %esi,%edi
  100816:	eb 3a                	jmp    100852 <console_vprintf+0x2c5>
		else if ((flags & (FLAG_ZERO | FLAG_LEFTJUSTIFY)) == FLAG_ZERO
  100818:	8b 4c 24 14          	mov    0x14(%esp),%ecx
			 && numeric && precision < 0
			 && len + !!negative < width)
			zeros = width - len - !!negative;
		else
			zeros = 0;
  10081c:	31 ff                	xor    %edi,%edi
			negative = ' ';
		else
			negative = 0;
		if (numeric && precision > len)
			zeros = precision - len;
		else if ((flags & (FLAG_ZERO | FLAG_LEFTJUSTIFY)) == FLAG_ZERO
  10081e:	83 e1 06             	and    $0x6,%ecx
  100821:	83 f9 02             	cmp    $0x2,%ecx
  100824:	75 2c                	jne    100852 <console_vprintf+0x2c5>
			 && numeric && precision < 0
  100826:	80 7c 24 18 00       	cmpb   $0x0,0x18(%esp)
  10082b:	74 23                	je     100850 <console_vprintf+0x2c3>
  10082d:	c1 ee 1f             	shr    $0x1f,%esi
  100830:	74 1e                	je     100850 <console_vprintf+0x2c3>
			 && len + !!negative < width)
  100832:	8b 74 24 10          	mov    0x10(%esp),%esi
  100836:	31 c0                	xor    %eax,%eax
  100838:	85 d2                	test   %edx,%edx
  10083a:	0f 95 c0             	setne  %al
  10083d:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
  100840:	3b 4c 24 0c          	cmp    0xc(%esp),%ecx
  100844:	7d 0c                	jge    100852 <console_vprintf+0x2c5>
			zeros = width - len - !!negative;
  100846:	8b 7c 24 0c          	mov    0xc(%esp),%edi
  10084a:	29 f7                	sub    %esi,%edi
  10084c:	29 c7                	sub    %eax,%edi
  10084e:	eb 02                	jmp    100852 <console_vprintf+0x2c5>
		else
			zeros = 0;
  100850:	31 ff                	xor    %edi,%edi
		width -= len + zeros + !!negative;
  100852:	8b 74 24 10          	mov    0x10(%esp),%esi
  100856:	85 d2                	test   %edx,%edx
  100858:	0f 95 c0             	setne  %al
  10085b:	0f b6 c8             	movzbl %al,%ecx
  10085e:	01 fe                	add    %edi,%esi
  100860:	01 f1                	add    %esi,%ecx
  100862:	8b 74 24 0c          	mov    0xc(%esp),%esi
  100866:	29 ce                	sub    %ecx,%esi
	if (c == '\n') {
		int pos = (cursor - CONSOLE_BEGIN) % 80;
		for (; pos != 80; pos++)
			*cursor++ = ' ' | color;
	} else
		*cursor++ = c | color;
  100868:	8b 4c 24 54          	mov    0x54(%esp),%ecx
  10086c:	83 c9 20             	or     $0x20,%ecx
			 && len + !!negative < width)
			zeros = width - len - !!negative;
		else
			zeros = 0;
		width -= len + zeros + !!negative;
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
  10086f:	f6 44 24 14 04       	testb  $0x4,0x14(%esp)
	if (c == '\n') {
		int pos = (cursor - CONSOLE_BEGIN) % 80;
		for (; pos != 80; pos++)
			*cursor++ = ' ' | color;
	} else
		*cursor++ = c | color;
  100874:	66 89 4c 24 0c       	mov    %cx,0xc(%esp)
			 && len + !!negative < width)
			zeros = width - len - !!negative;
		else
			zeros = 0;
		width -= len + zeros + !!negative;
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
  100879:	74 13                	je     10088e <console_vprintf+0x301>
			cursor = console_putc(cursor, ' ', color);
		if (negative)
  10087b:	84 c0                	test   %al,%al
  10087d:	74 2f                	je     1008ae <console_vprintf+0x321>
			cursor = console_putc(cursor, negative, color);
  10087f:	8b 4c 24 54          	mov    0x54(%esp),%ecx
  100883:	89 e8                	mov    %ebp,%eax
  100885:	e8 df fb ff ff       	call   100469 <console_putc>
  10088a:	89 c5                	mov    %eax,%ebp
  10088c:	eb 20                	jmp    1008ae <console_vprintf+0x321>
			 && len + !!negative < width)
			zeros = width - len - !!negative;
		else
			zeros = 0;
		width -= len + zeros + !!negative;
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
  10088e:	85 f6                	test   %esi,%esi
  100890:	7e e9                	jle    10087b <console_vprintf+0x2ee>

static uint16_t *
console_putc(uint16_t *cursor, unsigned char c, int color)
{
	if (cursor >= CONSOLE_END)
		cursor = CONSOLE_BEGIN;
  100892:	81 fd a0 8f 0b 00    	cmp    $0xb8fa0,%ebp
  100898:	b9 00 80 0b 00       	mov    $0xb8000,%ecx
  10089d:	0f 43 e9             	cmovae %ecx,%ebp
	if (c == '\n') {
		int pos = (cursor - CONSOLE_BEGIN) % 80;
		for (; pos != 80; pos++)
			*cursor++ = ' ' | color;
	} else
		*cursor++ = c | color;
  1008a0:	8b 4c 24 0c          	mov    0xc(%esp),%ecx
			 && len + !!negative < width)
			zeros = width - len - !!negative;
		else
			zeros = 0;
		width -= len + zeros + !!negative;
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
  1008a4:	4e                   	dec    %esi
			cursor = console_putc(cursor, ' ', color);
  1008a5:	83 c5 02             	add    $0x2,%ebp
	if (c == '\n') {
		int pos = (cursor - CONSOLE_BEGIN) % 80;
		for (; pos != 80; pos++)
			*cursor++ = ' ' | color;
	} else
		*cursor++ = c | color;
  1008a8:	66 89 4d fe          	mov    %cx,-0x2(%ebp)
  1008ac:	eb e0                	jmp    10088e <console_vprintf+0x301>
  1008ae:	8b 54 24 54          	mov    0x54(%esp),%edx

static uint16_t *
console_putc(uint16_t *cursor, unsigned char c, int color)
{
	if (cursor >= CONSOLE_END)
		cursor = CONSOLE_BEGIN;
  1008b2:	b8 00 80 0b 00       	mov    $0xb8000,%eax
	if (c == '\n') {
		int pos = (cursor - CONSOLE_BEGIN) % 80;
		for (; pos != 80; pos++)
			*cursor++ = ' ' | color;
	} else
		*cursor++ = c | color;
  1008b7:	83 ca 30             	or     $0x30,%edx
		width -= len + zeros + !!negative;
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
			cursor = console_putc(cursor, ' ', color);
		if (negative)
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
  1008ba:	85 ff                	test   %edi,%edi
  1008bc:	7e 13                	jle    1008d1 <console_vprintf+0x344>

static uint16_t *
console_putc(uint16_t *cursor, unsigned char c, int color)
{
	if (cursor >= CONSOLE_END)
		cursor = CONSOLE_BEGIN;
  1008be:	81 fd a0 8f 0b 00    	cmp    $0xb8fa0,%ebp
  1008c4:	0f 43 e8             	cmovae %eax,%ebp
		width -= len + zeros + !!negative;
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
			cursor = console_putc(cursor, ' ', color);
		if (negative)
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
  1008c7:	4f                   	dec    %edi
	if (c == '\n') {
		int pos = (cursor - CONSOLE_BEGIN) % 80;
		for (; pos != 80; pos++)
			*cursor++ = ' ' | color;
	} else
		*cursor++ = c | color;
  1008c8:	66 89 55 00          	mov    %dx,0x0(%ebp)
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
			cursor = console_putc(cursor, ' ', color);
		if (negative)
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
			cursor = console_putc(cursor, '0', color);
  1008cc:	83 c5 02             	add    $0x2,%ebp
  1008cf:	eb e9                	jmp    1008ba <console_vprintf+0x32d>
		width -= len + zeros + !!negative;
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
			cursor = console_putc(cursor, ' ', color);
		if (negative)
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
  1008d1:	8b 7c 24 08          	mov    0x8(%esp),%edi
  1008d5:	8b 44 24 10          	mov    0x10(%esp),%eax
  1008d9:	01 f8                	add    %edi,%eax
  1008db:	89 44 24 08          	mov    %eax,0x8(%esp)
  1008df:	8b 44 24 08          	mov    0x8(%esp),%eax
  1008e3:	29 f8                	sub    %edi,%eax
			cursor = console_putc(cursor, '0', color);
		for (; len > 0; ++data, --len)
  1008e5:	85 c0                	test   %eax,%eax
  1008e7:	7e 13                	jle    1008fc <console_vprintf+0x36f>
			cursor = console_putc(cursor, *data, color);
  1008e9:	0f b6 17             	movzbl (%edi),%edx
  1008ec:	89 e8                	mov    %ebp,%eax
			cursor = console_putc(cursor, ' ', color);
		if (negative)
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
			cursor = console_putc(cursor, '0', color);
		for (; len > 0; ++data, --len)
  1008ee:	47                   	inc    %edi
			cursor = console_putc(cursor, *data, color);
  1008ef:	8b 4c 24 54          	mov    0x54(%esp),%ecx
  1008f3:	e8 71 fb ff ff       	call   100469 <console_putc>
  1008f8:	89 c5                	mov    %eax,%ebp
  1008fa:	eb e3                	jmp    1008df <console_vprintf+0x352>
	if (c == '\n') {
		int pos = (cursor - CONSOLE_BEGIN) % 80;
		for (; pos != 80; pos++)
			*cursor++ = ' ' | color;
	} else
		*cursor++ = c | color;
  1008fc:	8b 54 24 54          	mov    0x54(%esp),%edx

static uint16_t *
console_putc(uint16_t *cursor, unsigned char c, int color)
{
	if (cursor >= CONSOLE_END)
		cursor = CONSOLE_BEGIN;
  100900:	b8 00 80 0b 00       	mov    $0xb8000,%eax
	if (c == '\n') {
		int pos = (cursor - CONSOLE_BEGIN) % 80;
		for (; pos != 80; pos++)
			*cursor++ = ' ' | color;
	} else
		*cursor++ = c | color;
  100905:	83 ca 20             	or     $0x20,%edx
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
			cursor = console_putc(cursor, '0', color);
		for (; len > 0; ++data, --len)
			cursor = console_putc(cursor, *data, color);
		for (; width > 0; --width)
  100908:	85 f6                	test   %esi,%esi
  10090a:	7e 13                	jle    10091f <console_vprintf+0x392>

static uint16_t *
console_putc(uint16_t *cursor, unsigned char c, int color)
{
	if (cursor >= CONSOLE_END)
		cursor = CONSOLE_BEGIN;
  10090c:	81 fd a0 8f 0b 00    	cmp    $0xb8fa0,%ebp
  100912:	0f 43 e8             	cmovae %eax,%ebp
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
			cursor = console_putc(cursor, '0', color);
		for (; len > 0; ++data, --len)
			cursor = console_putc(cursor, *data, color);
		for (; width > 0; --width)
  100915:	4e                   	dec    %esi
	if (c == '\n') {
		int pos = (cursor - CONSOLE_BEGIN) % 80;
		for (; pos != 80; pos++)
			*cursor++ = ' ' | color;
	} else
		*cursor++ = c | color;
  100916:	66 89 55 00          	mov    %dx,0x0(%ebp)
		for (; zeros > 0; --zeros)
			cursor = console_putc(cursor, '0', color);
		for (; len > 0; ++data, --len)
			cursor = console_putc(cursor, *data, color);
		for (; width > 0; --width)
			cursor = console_putc(cursor, ' ', color);
  10091a:	83 c5 02             	add    $0x2,%ebp
  10091d:	eb e9                	jmp    100908 <console_vprintf+0x37b>
	int flags, width, zeros, precision, negative, numeric, len;
#define NUMBUFSIZ 20
	char numbuf[NUMBUFSIZ];
	char *data;

	for (; *format; ++format) {
  10091f:	ff 44 24 58          	incl   0x58(%esp)
  100923:	e9 74 fc ff ff       	jmp    10059c <console_vprintf+0xf>
			const char *flagc = flag_chars;
			while (*flagc != '\0' && *flagc != *format)
				++flagc;
			if (*flagc == '\0')
				break;
			flags |= (1 << (flagc - flag_chars));
  100928:	81 e9 bc 09 10 00    	sub    $0x1009bc,%ecx
  10092e:	89 f0                	mov    %esi,%eax
  100930:	d3 e0                	shl    %cl,%eax
			continue;
		}

		// process flags
		flags = 0;
		for (++format; *format; ++format) {
  100932:	ff 44 24 58          	incl   0x58(%esp)
			const char *flagc = flag_chars;
			while (*flagc != '\0' && *flagc != *format)
				++flagc;
			if (*flagc == '\0')
				break;
			flags |= (1 << (flagc - flag_chars));
  100936:	09 44 24 14          	or     %eax,0x14(%esp)
  10093a:	e9 94 fc ff ff       	jmp    1005d3 <console_vprintf+0x46>
			cursor = console_putc(cursor, ' ', color);
	done: ;
	}

	return cursor;
}
  10093f:	83 c4 3c             	add    $0x3c,%esp
  100942:	89 e8                	mov    %ebp,%eax
  100944:	5b                   	pop    %ebx
  100945:	5e                   	pop    %esi
  100946:	5f                   	pop    %edi
  100947:	5d                   	pop    %ebp
  100948:	c3                   	ret    

00100949 <console_printf>:

uint16_t *
console_printf(uint16_t *cursor, int color, const char *format, ...)
{
  100949:	83 ec 10             	sub    $0x10,%esp
	va_list val;
	va_start(val, format);
	cursor = console_vprintf(cursor, color, format, val);
  10094c:	8d 44 24 20          	lea    0x20(%esp),%eax
  100950:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100954:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  100958:	89 44 24 08          	mov    %eax,0x8(%esp)
  10095c:	8b 44 24 18          	mov    0x18(%esp),%eax
  100960:	89 44 24 04          	mov    %eax,0x4(%esp)
  100964:	8b 44 24 14          	mov    0x14(%esp),%eax
  100968:	89 04 24             	mov    %eax,(%esp)
  10096b:	e8 1d fc ff ff       	call   10058d <console_vprintf>
	va_end(val);
	return cursor;
}
  100970:	83 c4 10             	add    $0x10,%esp
  100973:	c3                   	ret    
