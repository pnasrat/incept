/* exported entry point */
int incept_start (unsigned long r3, unsigned long r4, unsigned long r5);

struct prom_args {
  const char *service;
  int nargs;
  int nret;
  void *args[10];
};

/* Client interface handler */
typedef int (*prom_entry)(void *);

void prom_exit(prom_entry);

int incept_start (unsigned long r3, unsigned long r4, unsigned long r5)
{
  /* Initialize OF interface */
  /* stack pointer is r1 */
  r3 = 0;
  prom_exit((prom_entry)r5);
  return 0;
}

void prom_exit(prom_entry pp) {
  struct prom_args p;
  p.service = "exit";
  p.nargs = 0;
  p.nret = 0;
  for (;;) ;
    pp(&p);
  /* powerpc processor binding revision 2.1 
   * s7.1 - To invoke a client interface service construct argument array.
   * Place argument array in r3
   * Transfer 
   */
}
