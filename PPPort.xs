
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#define NEED_newCONSTSUB
#include "ppport.h"

void test1(void)
{
	newCONSTSUB(gv_stashpv("Devel::PPPort", FALSE), "test_value_1", newSViv(1));
}

extern void test2(void);
extern void test3(void);

MODULE = Devel::PPPort		PACKAGE = Devel::PPPort

void
test1()

void
test2()

void
test3()

int
test4()
	CODE:
	{
		SV * sv = newSViv(1);
		SV * rv = newRV_inc(sv);
		RETVAL = (SvREFCNT(sv) == 2);
	}
	OUTPUT:
	RETVAL

int
test5()
	CODE:
	{
		SV * sv = newSViv(2);
		SV * rv = newRV_noinc(sv);
		RETVAL = (SvREFCNT(sv) == 1);
	}
	OUTPUT:
	RETVAL

SV *
test6()
	CODE:
	{
		RETVAL = newSVsv(&PL_sv_undef);
	}
	OUTPUT:
	RETVAL

SV *
test7()
	CODE:
	{
		RETVAL = newSVsv(&PL_sv_yes);
	}
	OUTPUT:
	RETVAL

SV *
test8()
	CODE:
	{
		RETVAL = newSVsv(&PL_sv_no);
	}
	OUTPUT:
	RETVAL
