/*
 * int check_64bit (void)
 *
 * Checks whether 64-bit mode is supported
 *
 * Stolen from a patch originaly intended for syslinux (http://syslinux.zytor.com/archives/2007-January/007832.html)
 * Copyright (C) 2007 Byron Stanoszek <gandalf@winds.org>
 *
 * Adapted to AT&T syntax by Robert Millan <rmh@aybabtu.com>
 */

.globl _check_64bit ; _check_64bit:
	pushl	%ebp
	pushl	%ebx
	pushl	%edx

	/* Check if this CPU supports the CPUID command */
	pushf
	pushf
	popl	%eax
	movl	%eax, %ebx
	xorl	$(1 << 21), %eax	// CPUID bit
	pushl	%eax
	popf
	pushf
	popl	%eax
	popf				// Restore the original flags
	xorl	%ebx, %eax
	jz	is_32bit

	/* Now check for the 64-bit flag in the CPU features byte ($0000_0001, edx)
	This is bit 30 for Intel CPUs, and bit 29 for AMD CPUs */
	movl	$0x00000000, %eax	// Find last Intel cpuid #
	cpuid
	cmpl	$0x00000000, %eax
	je	test_amd
	movl	$0x00000001, %eax	// Read Intel CPU flags
	cpuid
	btl	$30, %edx		// 64-bit if bit 30 is set
	jc	is_64bit

test_amd:
	movl	$0x80000000, %eax	// Find last AMD cpuid #
	cpuid
	cmpl	$0x80000000, %eax
	jbe	is_32bit
	movl	$0x80000001, %eax	// Read AMD CPU flags
	cpuid
	btl	$29, %edx		// 64-bit if bit 29 is set
	jnc	is_32bit

is_64bit:
	movl	$1, %eax
	popl	%edx
	popl	%ebx
	popl	%ebp
	ret
is_32bit:
	xorl	%eax, %eax
	popl	%edx
	popl	%ebx
	popl	%ebp
	ret
