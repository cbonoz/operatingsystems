
obj/mpos-bootsector.out:     file format elf32-i386


Disassembly of section .text:

00007c00 <start>:
.set SEGSEL_BOOT_DATA,0x10	# data segment selector
.set CR0_PE_ON,0x1		# protected mode enable flag

.globl start					# Entry point
start:		.code16				# This runs in real mode
		cli				# Disable interrupts
    7c00:	fa                   	cli    
		cld				# String operations increment
    7c01:	fc                   	cld    

		# Set up the important data segment registers (DS, ES, SS).
		xorw	%ax,%ax			# Segment number zero
    7c02:	31 c0                	xor    %eax,%eax
		movw	%ax,%ds			# -> Data Segment
    7c04:	8e d8                	mov    %eax,%ds
		movw	%ax,%es			# -> Extra Segment
    7c06:	8e c0                	mov    %eax,%es
		movw	%ax,%ss			# -> Stack Segment
    7c08:	8e d0                	mov    %eax,%ss

		# Set up the stack pointer, growing downward from 0x7c00.
		movw	$start,%sp         	# Stack Pointer
    7c0a:	bc 00 7c e4 64       	mov    $0x64e47c00,%esp

00007c0d <seta20.1>:
#   and subsequent 80286-based PCs wanted to retain maximum compatibility),
#   physical address line 20 is tied to low when the machine boots.
#   Obviously this a bit of a drag for us, especially when trying to
#   address memory above 1MB.  This code undoes this.

seta20.1:	inb	$0x64,%al		# Get status
    7c0d:	e4 64                	in     $0x64,%al
		testb	$0x2,%al		# Busy?
    7c0f:	a8 02                	test   $0x2,%al
		jnz	seta20.1		# Yes
    7c11:	75 fa                	jne    7c0d <seta20.1>
		movb	$0xd1,%al		# Command: Write
    7c13:	b0 d1                	mov    $0xd1,%al
		outb	%al,$0x64		#  output port
    7c15:	e6 64                	out    %al,$0x64

00007c17 <seta20.2>:
seta20.2:	inb	$0x64,%al		# Get status
    7c17:	e4 64                	in     $0x64,%al
		testb	$0x2,%al		# Busy?
    7c19:	a8 02                	test   $0x2,%al
		jnz	seta20.2		# Yes
    7c1b:	75 fa                	jne    7c17 <seta20.2>
		movb	$0xdf,%al		# Enable
    7c1d:	b0 df                	mov    $0xdf,%al
		outb	%al,$0x60		#  A20
    7c1f:	e6 60                	out    %al,$0x60

00007c21 <real_to_prot>:
#   OK to run code at any address, or write to any address.
#   The 'gdt' and 'gdtdesc' tables below define these segments.
#   This code loads them into the processor.
#   We need this setup to ensure the transition to protected mode is smooth.

real_to_prot:	cli			# Don't allow interrupts: mandatory,
    7c21:	fa                   	cli    
					# since we didn't set up an interrupt
					# descriptor table for handling them
		lgdt	gdtdesc		# load GDT: mandatory in protected mode
    7c22:	0f 01 16             	lgdtl  (%esi)
    7c25:	64                   	fs
    7c26:	7c 0f                	jl     7c37 <protcseg+0x1>
		movl	%cr0, %eax	# Turn on protected mode
    7c28:	20 c0                	and    %al,%al
		orl	$CR0_PE_ON, %eax
    7c2a:	66 83 c8 01          	or     $0x1,%ax
		movl	%eax, %cr0
    7c2e:	0f 22 c0             	mov    %eax,%cr0

	        # CPU magic: jump to relocation, flush prefetch queue, and
		# reload %cs.  Has the effect of just jmp to the next
		# instruction, but simultaneously loads CS with
		# $SEGSEL_BOOT_CODE.
		ljmp	$SEGSEL_BOOT_CODE, $protcseg
    7c31:	ea 36 7c 08 00 66 b8 	ljmp   $0xb866,$0x87c36

00007c36 <protcseg>:

		.code32			# run in 32-bit protected mode
		# Set up the protected-mode data segment registers
protcseg:	movw	$SEGSEL_BOOT_DATA, %ax	# Our data segment selector
    7c36:	66 b8 10 00          	mov    $0x10,%ax
		movw	%ax, %ds		# -> DS: Data Segment
    7c3a:	8e d8                	mov    %eax,%ds
		movw	%ax, %es		# -> ES: Extra Segment
    7c3c:	8e c0                	mov    %eax,%es
		movw	%ax, %fs		# -> FS
    7c3e:	8e e0                	mov    %eax,%fs
		movw	%ax, %gs		# -> GS
    7c40:	8e e8                	mov    %eax,%gs
		movw	%ax, %ss		# -> SS: Stack Segment
    7c42:	8e d0                	mov    %eax,%ss

		call bootmain		# finish the boot!  Shouldn't return,
    7c44:	e8 cf 00 00 00       	call   7d18 <bootmain>

00007c49 <spinloop>:

spinloop:	jmp spinloop		# ..but in case it does, spin.
    7c49:	eb fe                	jmp    7c49 <spinloop>
    7c4b:	90                   	nop

00007c4c <gdt>:
	...
    7c54:	ff                   	(bad)  
    7c55:	ff 00                	incl   (%eax)
    7c57:	00 00                	add    %al,(%eax)
    7c59:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
    7c60:	00 92 cf 00 17 00    	add    %dl,0x1700cf(%edx)

00007c64 <gdtdesc>:
    7c64:	17                   	pop    %ss
    7c65:	00 4c 7c 00          	add    %cl,0x0(%esp,%edi,2)
	...

00007c6a <waitdisk>:

static inline uint8_t
inb(int port)
{
	uint8_t data;
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
    7c6a:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7c6f:	ec                   	in     (%dx),%al

void
waitdisk(void)
{
	// wait for disk reaady
	while ((inb(0x1F7) & 0xC0) != 0x40)
    7c70:	83 e0 c0             	and    $0xffffffc0,%eax
    7c73:	3c 40                	cmp    $0x40,%al
    7c75:	75 f8                	jne    7c6f <waitdisk+0x5>
		/* do nothing */;
}
    7c77:	c3                   	ret    

00007c78 <readsect>:

void
readsect(void *dst, uint32_t sect)
{
    7c78:	57                   	push   %edi
    7c79:	53                   	push   %ebx
    7c7a:	8b 5c 24 10          	mov    0x10(%esp),%ebx
	// wait for disk to be ready
	waitdisk();
    7c7e:	e8 e7 ff ff ff       	call   7c6a <waitdisk>
}

static inline void
outb(int port, uint8_t data)
{
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
    7c83:	ba f2 01 00 00       	mov    $0x1f2,%edx
    7c88:	b0 01                	mov    $0x1,%al
    7c8a:	ee                   	out    %al,(%dx)
    7c8b:	0f b6 c3             	movzbl %bl,%eax
    7c8e:	b2 f3                	mov    $0xf3,%dl
    7c90:	ee                   	out    %al,(%dx)
    7c91:	0f b6 c7             	movzbl %bh,%eax
    7c94:	b2 f4                	mov    $0xf4,%dl
    7c96:	ee                   	out    %al,(%dx)

	outb(0x1F2, 1);		// count = 1
	outb(0x1F3, sect);
	outb(0x1F4, sect >> 8);
	outb(0x1F5, sect >> 16);
    7c97:	89 d8                	mov    %ebx,%eax
    7c99:	b2 f5                	mov    $0xf5,%dl
    7c9b:	c1 e8 10             	shr    $0x10,%eax
    7c9e:	0f b6 c0             	movzbl %al,%eax
    7ca1:	ee                   	out    %al,(%dx)
	outb(0x1F6, (sect >> 24) | 0xE0);
    7ca2:	c1 eb 18             	shr    $0x18,%ebx
    7ca5:	b2 f6                	mov    $0xf6,%dl
    7ca7:	88 d8                	mov    %bl,%al
    7ca9:	83 c8 e0             	or     $0xffffffe0,%eax
    7cac:	ee                   	out    %al,(%dx)
    7cad:	b0 20                	mov    $0x20,%al
    7caf:	b2 f7                	mov    $0xf7,%dl
    7cb1:	ee                   	out    %al,(%dx)
	outb(0x1F7, 0x20);	// cmd 0x20 - read sectors

	// wait for disk to be ready
	waitdisk();
    7cb2:	e8 b3 ff ff ff       	call   7c6a <waitdisk>
}

static inline void
insl(int port, void *addr, int cnt)
{
	asm volatile("cld\n\trepne\n\tinsl"			:
    7cb7:	8b 7c 24 0c          	mov    0xc(%esp),%edi
    7cbb:	b9 80 00 00 00       	mov    $0x80,%ecx
    7cc0:	ba f0 01 00 00       	mov    $0x1f0,%edx
    7cc5:	fc                   	cld    
    7cc6:	f2 6d                	repnz insl (%dx),%es:(%edi)

	// read a sector
	insl(0x1F0, dst, SECTORSIZE/4);
}
    7cc8:	5b                   	pop    %ebx
    7cc9:	5f                   	pop    %edi
    7cca:	c3                   	ret    

00007ccb <readseg>:

// Read 'filesz' bytes at 'offset' from kernel into virtual address 'va',
// then clear the memory from 'va+filesz' up to 'va+memsz' (set it to 0).
void
readseg(uint32_t va, uint32_t filesz, uint32_t memsz, uint32_t sect)
{
    7ccb:	55                   	push   %ebp
    7ccc:	57                   	push   %edi
    7ccd:	56                   	push   %esi
    7cce:	53                   	push   %ebx
    7ccf:	83 ec 08             	sub    $0x8,%esp
    7cd2:	8b 74 24 1c          	mov    0x1c(%esp),%esi
	uint32_t end_va;

	end_va = va + filesz;
    7cd6:	8b 5c 24 20          	mov    0x20(%esp),%ebx
	memsz += va;
    7cda:	8b 6c 24 24          	mov    0x24(%esp),%ebp

// Read 'filesz' bytes at 'offset' from kernel into virtual address 'va',
// then clear the memory from 'va+filesz' up to 'va+memsz' (set it to 0).
void
readseg(uint32_t va, uint32_t filesz, uint32_t memsz, uint32_t sect)
{
    7cde:	8b 7c 24 28          	mov    0x28(%esp),%edi
	uint32_t end_va;

	end_va = va + filesz;
    7ce2:	01 f3                	add    %esi,%ebx
	memsz += va;
    7ce4:	01 f5                	add    %esi,%ebp

	// round down to sector boundary
	va &= ~(SECTORSIZE - 1);
    7ce6:	81 e6 00 fe ff ff    	and    $0xfffffe00,%esi

	// read sectors
	while (va < end_va) {
    7cec:	39 de                	cmp    %ebx,%esi
    7cee:	73 15                	jae    7d05 <readseg+0x3a>
		readsect((uint8_t*) va, sect);
    7cf0:	89 7c 24 04          	mov    %edi,0x4(%esp)
		va += SECTORSIZE;
		sect++;
    7cf4:	47                   	inc    %edi
	// round down to sector boundary
	va &= ~(SECTORSIZE - 1);

	// read sectors
	while (va < end_va) {
		readsect((uint8_t*) va, sect);
    7cf5:	89 34 24             	mov    %esi,(%esp)
		va += SECTORSIZE;
    7cf8:	81 c6 00 02 00 00    	add    $0x200,%esi
	// round down to sector boundary
	va &= ~(SECTORSIZE - 1);

	// read sectors
	while (va < end_va) {
		readsect((uint8_t*) va, sect);
    7cfe:	e8 75 ff ff ff       	call   7c78 <readsect>
    7d03:	eb e7                	jmp    7cec <readseg+0x21>
		va += SECTORSIZE;
		sect++;
	}

	// clear bss segment
	while (end_va < memsz)
    7d05:	39 eb                	cmp    %ebp,%ebx
    7d07:	73 07                	jae    7d10 <readseg+0x45>
		*((uint8_t*) end_va++) = 0;
    7d09:	43                   	inc    %ebx
    7d0a:	c6 43 ff 00          	movb   $0x0,-0x1(%ebx)
    7d0e:	eb f5                	jmp    7d05 <readseg+0x3a>
}
    7d10:	83 c4 08             	add    $0x8,%esp
    7d13:	5b                   	pop    %ebx
    7d14:	5e                   	pop    %esi
    7d15:	5f                   	pop    %edi
    7d16:	5d                   	pop    %ebp
    7d17:	c3                   	ret    

00007d18 <bootmain>:
void readsect(void *addr, uint32_t sect);
void readseg(uint32_t va, uint32_t filesz, uint32_t memsz, uint32_t sect);

void
bootmain(void)
{
    7d18:	56                   	push   %esi
    7d19:	53                   	push   %ebx
    7d1a:	83 ec 10             	sub    $0x10,%esp
	struct Proghdr *ph, *eph;
	uint32_t *stackptr;

	// read 1st page off disk
	readseg((uint32_t) ELFHDR, PAGESIZE, PAGESIZE, 1);
    7d1d:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    7d24:	00 
    7d25:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
    7d2c:	00 
    7d2d:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
    7d34:	00 
    7d35:	c7 04 24 00 00 01 00 	movl   $0x10000,(%esp)
    7d3c:	e8 8a ff ff ff       	call   7ccb <readseg>

	// is this a valid ELF?
	if (ELFHDR->e_magic != ELF_MAGIC)
    7d41:	81 3d 00 00 01 00 7f 	cmpl   $0x464c457f,0x10000
    7d48:	45 4c 46 
    7d4b:	75 4f                	jne    7d9c <bootmain+0x84>
		return;

	// load each program segment (ignores ph flags)
	ph = (struct Proghdr*) ((uint8_t *) ELFHDR + ELFHDR->e_phoff);
    7d4d:	a1 1c 00 01 00       	mov    0x1001c,%eax
    7d52:	8d 98 00 00 01 00    	lea    0x10000(%eax),%ebx
	eph = ph + ELFHDR->e_phnum;
    7d58:	0f b7 05 2c 00 01 00 	movzwl 0x1002c,%eax
    7d5f:	c1 e0 05             	shl    $0x5,%eax
    7d62:	8d 34 03             	lea    (%ebx,%eax,1),%esi
	for (; ph < eph; ph++)
    7d65:	39 f3                	cmp    %esi,%ebx
    7d67:	73 29                	jae    7d92 <bootmain+0x7a>
		readseg(ph->p_va, ph->p_filesz, ph->p_memsz, 1 + ph->p_offset / SECTORSIZE);
    7d69:	8b 43 04             	mov    0x4(%ebx),%eax
		return;

	// load each program segment (ignores ph flags)
	ph = (struct Proghdr*) ((uint8_t *) ELFHDR + ELFHDR->e_phoff);
	eph = ph + ELFHDR->e_phnum;
	for (; ph < eph; ph++)
    7d6c:	83 c3 20             	add    $0x20,%ebx
		readseg(ph->p_va, ph->p_filesz, ph->p_memsz, 1 + ph->p_offset / SECTORSIZE);
    7d6f:	c1 e8 09             	shr    $0x9,%eax
    7d72:	40                   	inc    %eax
    7d73:	89 44 24 0c          	mov    %eax,0xc(%esp)
    7d77:	8b 43 f4             	mov    -0xc(%ebx),%eax
    7d7a:	89 44 24 08          	mov    %eax,0x8(%esp)
    7d7e:	8b 43 f0             	mov    -0x10(%ebx),%eax
    7d81:	89 44 24 04          	mov    %eax,0x4(%esp)
    7d85:	8b 43 e8             	mov    -0x18(%ebx),%eax
    7d88:	89 04 24             	mov    %eax,(%esp)
    7d8b:	e8 3b ff ff ff       	call   7ccb <readseg>
    7d90:	eb d3                	jmp    7d65 <bootmain+0x4d>

	// jump to the kernel, clearing %eax
	__asm __volatile("movl %0, %%esp; ret" : : "r" (&ELFHDR->e_entry), "a" (0));
    7d92:	31 c0                	xor    %eax,%eax
    7d94:	ba 18 00 01 00       	mov    $0x10018,%edx
    7d99:	89 d4                	mov    %edx,%esp
    7d9b:	c3                   	ret    
}
    7d9c:	83 c4 10             	add    $0x10,%esp
    7d9f:	5b                   	pop    %ebx
    7da0:	5e                   	pop    %esi
    7da1:	c3                   	ret    
