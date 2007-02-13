/**********************************************************
      stolen from linux/arch/i386/kernel/cpu/common.c
 **********************************************************/

/* Standard macro to see if a specific flag is changeable */
static inline int
flag_is_changeable_p (unsigned int flag)
{
  unsigned int f1, f2;
  asm ("pushfl\n\t"
       "pushfl\n\t"
       "popl %0\n\t"
       "movl %0,%1\n\t"
       "xorl %2,%0\n\t"
       "pushl %0\n\t"
       "popfl\n\t"
       "pushfl\n\t"
       "popl %0\n\t"
       "popfl\n\t"
       : "=&r" (f1), "=&r" (f2)
       :"ir" (flag));
  return ((f1 ^ f2) & flag) != 0;
}

#ifndef X86_EFLAGS_ID
#define X86_EFLAGS_ID 0x00200000 /* CPUID detection flag */
#endif

/**********************************************************
      stolen from linux/include/asm-i386/processor.h
 **********************************************************/

static inline unsigned int
cpuid_eax(unsigned int op)
{
  unsigned int eax;
  __asm__("cpuid": "=a" (eax): "0" (op): "bx", "cx", "dx");
  return eax;
}

static inline unsigned int
cpuid_edx (unsigned int op)
{
  unsigned int eax, edx;
  __asm__ ("cpuid": "=a" (eax), "=d" (edx): "0" (op):"bx", "cx");
  return edx;
}

/**********************************************************
  Based on specs from:
  - http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/25481.pdf
  - http://download.intel.com/design/Xeon/applnots/24161831.pdf
 **********************************************************/

check_64bit ()
{
  /* probe for CPUID instruction */
  if (!flag_is_changeable_p (X86_EFLAGS_ID))
    return 0;

  /* probe for 0x80000001-level CPUID support */
  if (cpuid_eax (0x80000000) < 0x80000001)
    return 0;

  /* probe for 64-bit support */
  return (cpuid_edx (0x80000001) & (1 << 29)) ? 1 : 0;
}
