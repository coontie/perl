#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

extern int subtract (int,int);

MODULE = test_pl_e6ee	PACKAGE = main	

PROTOTYPES: DISABLE

int
subtract (neil, neim)
	int	neil
	int	neim

