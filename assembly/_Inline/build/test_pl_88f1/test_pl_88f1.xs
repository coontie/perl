#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

extern int subtract (int,int);

MODULE = test_pl_88f1	PACKAGE = main	

PROTOTYPES: DISABLE

int
subtract (neil, neim)
	int	neil
	int	neim

