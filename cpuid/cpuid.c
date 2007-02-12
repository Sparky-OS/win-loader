/*
  Based on specs from:
  - http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/25481.pdf
  - http://download.intel.com/design/Xeon/applnots/24161831.pdf
*/

/* stolen from linux/include/asm-i386/processor.h */
static inline unsigned int
cpuid_edx (unsigned int op)
{
  unsigned int eax, edx;
  __asm__ ("cpuid": "=a" (eax), "=d" (edx): "0" (op):"bx", "cx");
  return edx;
}

check_64bit ()
{
  return (cpuid_edx (0x80000001) & (1 << 29)) ? 1 : 0;
}
