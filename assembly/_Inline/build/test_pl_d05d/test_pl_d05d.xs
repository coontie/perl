#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

extern int add (int,int);

MODULE = test_pl_d05d	PACKAGE = main	

PROTOTYPES: DISABLE

int
add (neil, neim)
	int	neil
	int	neim

