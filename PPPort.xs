/*******************************************************************************
*
*  !!!!! Do NOT edit this file directly! -- Edit PPPort_xs.PL instead. !!!!!
*
********************************************************************************
*
*  Perl/Pollution/Portability
*
********************************************************************************
*
*  $Revision: 7 $
*  $Author: mhx $
*  $Date: 2004/08/13 12:49:19 +0200 $
*
********************************************************************************
*
*  Version 3.x, Copyright (C) 2004, Marcus Holland-Moritz.
*  Version 2.x, Copyright (C) 2001, Paul Marquess.
*  Version 1.x, Copyright (C) 1999, Kenneth Albanowski.
*
*  This program is free software; you can redistribute it and/or
*  modify it under the same terms as Perl itself.
*
*******************************************************************************/

/* ========== BEGIN XSHEAD ================================================== */



/* =========== END XSHEAD =================================================== */

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

/* ========== BEGIN XSINIT ================================================== */

/* ---- from parts/inc/call ---- */
#define NEED_eval_pv

/* ---- from parts/inc/grok ---- */
#define NEED_grok_number
#define NEED_grok_numeric_radix
#define NEED_grok_bin
#define NEED_grok_hex
#define NEED_grok_oct

/* ---- from parts/inc/newCONSTSUB ---- */
#define NEED_newCONSTSUB

/* ---- from parts/inc/newRV ---- */
#define NEED_newRV_noinc

/* ---- from parts/inc/SvPV ---- */
#define NEED_sv_2pv_nolen
#define NEED_sv_2pvbyte

/* =========== END XSINIT =================================================== */

#include "ppport.h"

/* ========== BEGIN XSMISC ================================================== */

/* ---- from parts/inc/MY_CXT ---- */
#define MY_CXT_KEY "Devel::PPPort::_guts" XS_VERSION
 
typedef struct {
  /* Put Global Data in here */
  int dummy;          
} my_cxt_t;
 
START_MY_CXT     

/* ---- from parts/inc/newCONSTSUB ---- */
void call_newCONSTSUB_1(void)
{
#ifdef PERL_NO_GET_CONTEXT
	dTHX;
#endif
	newCONSTSUB(gv_stashpv("Devel::PPPort", FALSE), "test_value_1", newSViv(1));
}

extern void call_newCONSTSUB_2(void);
extern void call_newCONSTSUB_3(void);

/* =========== END XSMISC =================================================== */

MODULE = Devel::PPPort		PACKAGE = Devel::PPPort

BOOT:
	/* ---- from parts/inc/MY_CXT ---- */
	{
	  MY_CXT_INIT;
	  /* If any of the fields in the my_cxt_t struct need
	   * to be initialised, do it here.
	   */
	  MY_CXT.dummy = 42;
	}
	

##----------------------------------------------------------------------
##  XSUBs from parts/inc/call
##----------------------------------------------------------------------

I32
G_SCALAR()
	CODE:
		RETVAL = G_SCALAR;
	OUTPUT:
		RETVAL

I32
G_ARRAY()
	CODE:
		RETVAL = G_ARRAY;
	OUTPUT:
		RETVAL

I32
G_DISCARD()
	CODE:
		RETVAL = G_DISCARD;
	OUTPUT:
		RETVAL

void
eval_sv(sv, flags)
	SV* sv
	I32 flags
	PREINIT:
		I32 i;
	PPCODE:
		PUTBACK;
		i = eval_sv(sv, flags);
		SPAGAIN;
		EXTEND(SP, 1);
		PUSHs(sv_2mortal(newSViv(i)));

void
eval_pv(p, croak_on_error)
	char* p
	I32 croak_on_error
	PPCODE:
		PUTBACK;
		EXTEND(SP, 1);
		PUSHs(eval_pv(p, croak_on_error));

void
call_sv(sv, flags, ...)
	SV* sv
	I32 flags
	PREINIT:
		I32 i;
	PPCODE:
		for (i=0; i<items-2; i++)
		  ST(i) = ST(i+2); /* pop first two args */
		PUSHMARK(SP);
		SP += items - 2;
		PUTBACK;
		i = call_sv(sv, flags);
		SPAGAIN;
		EXTEND(SP, 1);
		PUSHs(sv_2mortal(newSViv(i)));

void
call_pv(subname, flags, ...)
	char* subname
	I32 flags
	PREINIT:
		I32 i;
	PPCODE:
		for (i=0; i<items-2; i++)
		  ST(i) = ST(i+2); /* pop first two args */
		PUSHMARK(SP);
		SP += items - 2;
		PUTBACK;
		i = call_pv(subname, flags);
		SPAGAIN;
		EXTEND(SP, 1);
		PUSHs(sv_2mortal(newSViv(i)));

void
call_argv(subname, flags, ...)
	char* subname
	I32 flags
	PREINIT:
		I32 i;
		char *args[8];
	PPCODE:
		if (items > 8)  /* play safe */
		  XSRETURN_UNDEF;
		for (i=2; i<items; i++)
		  args[i-2] = SvPV_nolen(ST(i));
		args[items-2] = NULL;
		PUTBACK;
		i = call_argv(subname, flags, args);
		SPAGAIN;
		EXTEND(SP, 1);
		PUSHs(sv_2mortal(newSViv(i)));

void
call_method(methname, flags, ...)
	char* methname
	I32 flags
	PREINIT:
		I32 i;
	PPCODE:
		for (i=0; i<items-2; i++)
		  ST(i) = ST(i+2); /* pop first two args */
		PUSHMARK(SP);
		SP += items - 2;
		PUTBACK;
		i = call_method(methname, flags);
		SPAGAIN;
		EXTEND(SP, 1);
		PUSHs(sv_2mortal(newSViv(i)));

##----------------------------------------------------------------------
##  XSUBs from parts/inc/cop
##----------------------------------------------------------------------

char *
CopSTASHPV()
	CODE:
		RETVAL = CopSTASHPV(PL_curcop);
	OUTPUT:
		RETVAL

char *
CopFILE()
	CODE:
		RETVAL = CopFILE(PL_curcop);
	OUTPUT:
		RETVAL

##----------------------------------------------------------------------
##  XSUBs from parts/inc/grok
##----------------------------------------------------------------------

UV
grok_number(string)
	SV *string
	PREINIT:
		const char *pv;
		STRLEN len;
	CODE:
		pv = SvPV(string, len);
		if (!grok_number(pv, len, &RETVAL))
		  XSRETURN_UNDEF;
	OUTPUT:
		RETVAL

UV
grok_bin(string)
	SV *string
	PREINIT:
		char *pv;
		I32 flags;
		STRLEN len;
	CODE:
		pv = SvPV(string, len);
		RETVAL = grok_bin(pv, &len, &flags, NULL);
	OUTPUT:
		RETVAL

UV
grok_hex(string)
	SV *string
	PREINIT:
		char *pv;
		I32 flags;
		STRLEN len;
	CODE:
		pv = SvPV(string, len);
		RETVAL = grok_hex(pv, &len, &flags, NULL);
	OUTPUT:
		RETVAL

UV
grok_oct(string)
	SV *string
	PREINIT:
		char *pv;
		I32 flags;
		STRLEN len;
	CODE:
		pv = SvPV(string, len);
		RETVAL = grok_oct(pv, &len, &flags, NULL);
	OUTPUT:
		RETVAL

UV
Perl_grok_number(string)
	SV *string
	PREINIT:
		const char *pv;
		STRLEN len;
	CODE:
		pv = SvPV(string, len);
		if (!Perl_grok_number(aTHX_ pv, len, &RETVAL))
		  XSRETURN_UNDEF;
	OUTPUT:
		RETVAL

UV
Perl_grok_bin(string)
	SV *string
	PREINIT:
		char *pv;
		I32 flags;
		STRLEN len;
	CODE:
		pv = SvPV(string, len);
		RETVAL = Perl_grok_bin(aTHX_ pv, &len, &flags, NULL);
	OUTPUT:
		RETVAL

UV
Perl_grok_hex(string)
	SV *string
	PREINIT:
		char *pv;
		I32 flags;
		STRLEN len;
	CODE:
		pv = SvPV(string, len);
		RETVAL = Perl_grok_hex(aTHX_ pv, &len, &flags, NULL);
	OUTPUT:
		RETVAL

UV
Perl_grok_oct(string)
	SV *string
	PREINIT:
		char *pv;
		I32 flags;
		STRLEN len;
	CODE:
		pv = SvPV(string, len);
		RETVAL = Perl_grok_oct(aTHX_ pv, &len, &flags, NULL);
	OUTPUT:
		RETVAL

##----------------------------------------------------------------------
##  XSUBs from parts/inc/limits
##----------------------------------------------------------------------

IV
iv_size()
	CODE:
		RETVAL = IVSIZE == sizeof(IV);
	OUTPUT:
		RETVAL

IV
uv_size()
	CODE:
		RETVAL = UVSIZE == sizeof(UV);
	OUTPUT:
		RETVAL

IV
iv_type()
	CODE:
		RETVAL = sizeof(IVTYPE) == sizeof(IV);
	OUTPUT:
		RETVAL

IV
uv_type()
	CODE:
		RETVAL = sizeof(UVTYPE) == sizeof(UV);
	OUTPUT:
		RETVAL

##----------------------------------------------------------------------
##  XSUBs from parts/inc/magic
##----------------------------------------------------------------------

void
sv_catpv_mg(sv, string)
	SV *sv;
	char *string;
	CODE:
		sv_catpv_mg(sv, string);

void
sv_catpvn_mg(sv, sv2)
	SV *sv;
	SV *sv2;
	PREINIT:
		char *str;
		STRLEN len;
	CODE:
		str = SvPV(sv2, len);
		sv_catpvn_mg(sv, str, len);

void
sv_catsv_mg(sv, sv2)
	SV *sv;
	SV *sv2;
	CODE:
		sv_catsv_mg(sv, sv2);

void
sv_setiv_mg(sv, iv)
	SV *sv;
	IV iv;
	CODE:
		sv_setiv_mg(sv, iv);

void
sv_setnv_mg(sv, nv)
	SV *sv;
	NV nv;
	CODE:
		sv_setnv_mg(sv, nv);

void
sv_setpv_mg(sv, pv)
	SV *sv;
	char *pv;
	CODE:
		sv_setpv_mg(sv, pv);

void
sv_setpvn_mg(sv, sv2)
	SV *sv;
	SV *sv2;
	PREINIT:
		char *str;
		STRLEN len;
	CODE:
		str = SvPV(sv2, len);
		sv_setpvn_mg(sv, str, len);

void
sv_setsv_mg(sv, sv2)
	SV *sv;
	SV *sv2;
	CODE:
		sv_setsv_mg(sv, sv2);

void
sv_setuv_mg(sv, uv)
	SV *sv;
	UV uv;
	CODE:
		sv_setuv_mg(sv, uv);

void
sv_usepvn_mg(sv, sv2)
	SV *sv;
	SV *sv2;
	PREINIT:
		char *str, *copy;
		STRLEN len;
	CODE:
		str = SvPV(sv2, len);
		New(42, copy, len+1, char);
		Copy(str, copy, len+1, char);
		sv_usepvn_mg(sv, copy, len);

##----------------------------------------------------------------------
##  XSUBs from parts/inc/misc
##----------------------------------------------------------------------

int
gv_stashpvn(name, create)
	char *name
	I32 create
	CODE:
		RETVAL = gv_stashpvn(name, strlen(name), create) != NULL;
	OUTPUT:
		RETVAL

int
get_sv(name, create)
	char *name
	I32 create
	CODE:
		RETVAL = get_sv(name, create) != NULL;
	OUTPUT:
		RETVAL

int
get_av(name, create)
	char *name
	I32 create
	CODE:
		RETVAL = get_av(name, create) != NULL;
	OUTPUT:
		RETVAL

int
get_hv(name, create)
	char *name
	I32 create
	CODE:
		RETVAL = get_hv(name, create) != NULL;
	OUTPUT:
		RETVAL

int
get_cv(name, create)
	char *name
	I32 create
	CODE:
		RETVAL = get_cv(name, create) != NULL;
	OUTPUT:
		RETVAL

void
newSVpvn()
	PPCODE:
		XPUSHs(newSVpvn("test", 4));
		XPUSHs(newSVpvn("test", 2));
		XPUSHs(newSVpvn("test", 0));
		XPUSHs(newSVpvn(NULL, 2));
		XPUSHs(newSVpvn(NULL, 0));
		XSRETURN(5);

SV *
PL_sv_undef()
	CODE:
		RETVAL = newSVsv(&PL_sv_undef);
	OUTPUT:
		RETVAL

SV *
PL_sv_yes()
	CODE:
		RETVAL = newSVsv(&PL_sv_yes);
	OUTPUT:
		RETVAL

SV *
PL_sv_no()
	CODE:
		RETVAL = newSVsv(&PL_sv_no);
	OUTPUT:
		RETVAL

int
PL_na(string)
	char *string
	CODE:
		PL_na = strlen(string);
		RETVAL = PL_na;
	OUTPUT:
		RETVAL

SV*
boolSV(value)
	int value
	CODE:
		RETVAL = newSVsv(boolSV(value));
	OUTPUT:
		RETVAL

SV*
DEFSV()
	CODE:
		RETVAL = newSVsv(DEFSV);
	OUTPUT:
		RETVAL

int
ERRSV()
	CODE:
		RETVAL = SvTRUE(ERRSV);
	OUTPUT:
		RETVAL

SV*
UNDERBAR()
	CODE:
		{
		  dUNDERBAR;
		  RETVAL = newSVsv(UNDERBAR);
		}
	OUTPUT:
		RETVAL

##----------------------------------------------------------------------
##  XSUBs from parts/inc/mPUSH
##----------------------------------------------------------------------

void
mPUSHp()
	PPCODE:
	EXTEND(SP, 3);
	mPUSHp("one", 3);
	mPUSHp("two", 3);
	mPUSHp("three", 5);
	XSRETURN(3);

void
mPUSHn()
	PPCODE:
	EXTEND(SP, 3);
	mPUSHn(0.5);
	mPUSHn(-0.25);
	mPUSHn(0.125);
	XSRETURN(3);

void
mPUSHi()
	PPCODE:
	EXTEND(SP, 3);
	mPUSHi(-1);
	mPUSHi(2);
	mPUSHi(-3);
	XSRETURN(3);

void
mPUSHu()
	PPCODE:
	EXTEND(SP, 3);
	mPUSHu(1);
	mPUSHu(2);
	mPUSHu(3);
	XSRETURN(3);

void
mXPUSHp()
	PPCODE:
	mXPUSHp("one", 3);
	mXPUSHp("two", 3);
	mXPUSHp("three", 5);
	XSRETURN(3);

void
mXPUSHn()
	PPCODE:
	mXPUSHn(0.5);
	mXPUSHn(-0.25);
	mXPUSHn(0.125);
	XSRETURN(3);

void
mXPUSHi()
	PPCODE:
	mXPUSHi(-1);
	mXPUSHi(2);
	mXPUSHi(-3);
	XSRETURN(3);

void
mXPUSHu()
	PPCODE:
	mXPUSHu(1);
	mXPUSHu(2);
	mXPUSHu(3);
	XSRETURN(3);

##----------------------------------------------------------------------
##  XSUBs from parts/inc/MY_CXT
##----------------------------------------------------------------------

int
MY_CXT_1()
	CODE:
		dMY_CXT;
		RETVAL = MY_CXT.dummy == 42;
		++MY_CXT.dummy;
	OUTPUT:
		RETVAL

int
MY_CXT_2()
	CODE:
		dMY_CXT;
		RETVAL = MY_CXT.dummy == 43;
	OUTPUT:
		RETVAL

##----------------------------------------------------------------------
##  XSUBs from parts/inc/newCONSTSUB
##----------------------------------------------------------------------

void
call_newCONSTSUB_1()

void
call_newCONSTSUB_2()

void
call_newCONSTSUB_3()

##----------------------------------------------------------------------
##  XSUBs from parts/inc/newRV
##----------------------------------------------------------------------

U32
newRV_inc_REFCNT()
	PREINIT:
		SV *sv, *rv;
	CODE:
		sv = newSViv(42);
		rv = newRV_inc(sv);
		SvREFCNT_dec(sv);
		RETVAL = SvREFCNT(sv);
		sv_2mortal(rv);
	OUTPUT:
		RETVAL

U32
newRV_noinc_REFCNT()
	PREINIT:
		SV *sv, *rv;
	CODE:
		sv = newSViv(42);
		rv = newRV_noinc(sv);
		RETVAL = SvREFCNT(sv);
		sv_2mortal(rv);
	OUTPUT:
		RETVAL

##----------------------------------------------------------------------
##  XSUBs from parts/inc/SvPV
##----------------------------------------------------------------------

IV
SvPVbyte(sv)
	SV *sv
	PREINIT:
		STRLEN len;
		const char *str;
	CODE:
		str = SvPVbyte(sv, len);
		RETVAL = strEQ(str, "mhx") ? len : -1;
	OUTPUT:
		RETVAL

IV
SvPV_nolen(sv)
	SV *sv
	PREINIT:
		const char *str;
	CODE:
		str = SvPV_nolen(sv);
		RETVAL = strEQ(str, "mhx") ? 3 : 0;
	OUTPUT:
		RETVAL

##----------------------------------------------------------------------
##  XSUBs from parts/inc/threads
##----------------------------------------------------------------------

IV
no_THX_arg(sv)
	SV *sv
	CODE:
		RETVAL = 1 + sv_2iv(sv);
	OUTPUT:
		RETVAL

void
with_THX_arg(error)
	char *error
	PPCODE:
		Perl_croak(aTHX_ "%s", error);

##----------------------------------------------------------------------
##  XSUBs from parts/inc/uv
##----------------------------------------------------------------------

SV *
sv_setuv(uv)
	UV uv
	CODE:
		RETVAL = newSViv(1);
		sv_setuv(RETVAL, uv);
	OUTPUT:
		RETVAL

SV *
newSVuv(uv)
	UV uv
	CODE:
		RETVAL = newSVuv(uv);
	OUTPUT:
		RETVAL

UV
sv_2uv(sv)
	SV *sv
	CODE:
		RETVAL = sv_2uv(sv);
	OUTPUT:
		RETVAL

UV
SvUVx(sv)
	SV *sv
	CODE:
		sv--;
		RETVAL = SvUVx(++sv);
	OUTPUT:
		RETVAL

void
XSRETURN_UV()
	PPCODE:
		XSRETURN_UV(42);
