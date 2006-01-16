#!/usr/bin/perl -w
################################################################################
#
#  apicheck.pl -- generate C source for automated API check
#
################################################################################
#
#  $Revision: 14 $
#  $Author: mhx $
#  $Date: 2006/01/14 18:07:58 +0100 $
#
################################################################################
#
#  Version 3.x, Copyright (C) 2004-2006, Marcus Holland-Moritz.
#  Version 2.x, Copyright (C) 2001, Paul Marquess.
#  Version 1.x, Copyright (C) 1999, Kenneth Albanowski.
#
#  This program is free software; you can redistribute it and/or
#  modify it under the same terms as Perl itself.
#
################################################################################

use strict;
require 'parts/ppptools.pl';

if (@ARGV) {
  open OUT, ">$ARGV[0]" or die "$ARGV[0]: $!\n";
}
else {
  *OUT = \*STDOUT;
}

my @f = parse_embed(qw( parts/embed.fnc parts/apidoc.fnc ));

my %todo = %{&parse_todo};

my %tmap = (
  void => 'int',
);

my %amap = (
  SP   => 'SP',
  type => 'int',
  cast => 'int',
);

my %void = (
  void     => 1,
  Free_t   => 1,
  Signal_t => 1,
);

my %castvoid = (
  map { ($_ => 1) } qw(
    Nullav
    Nullcv
    Nullhv
    Nullch
    Nullsv
    HEf_SVKEY
    SP
    MARK
    SVt_PV
    SVt_IV
    SVt_NV
    SVt_PVMG
    SVt_PVAV
    SVt_PVHV
    SVt_PVCV
    SvUOK
    G_SCALAR
    G_ARRAY
    G_VOID
    G_DISCARD
    G_EVAL
    G_NOARGS
    XS_VERSION
  ),
);

my %ignorerv = (
  map { ($_ => 1) } qw(
    newCONSTSUB
  ),
);

my %stack = (
  ORIGMARK       => ['dORIGMARK;'],
  POPpx          => ['STRLEN n_a;'],
  POPpbytex      => ['STRLEN n_a;'],
  PUSHp          => ['dTARG;'],
  PUSHn          => ['dTARG;'],
  PUSHi          => ['dTARG;'],
  PUSHu          => ['dTARG;'],
  XPUSHp         => ['dTARG;'],
  XPUSHn         => ['dTARG;'],
  XPUSHi         => ['dTARG;'],
  XPUSHu         => ['dTARG;'],
  UNDERBAR       => ['dUNDERBAR;'],
  XCPT_TRY_START => ['dXCPT;'],
  XCPT_TRY_END   => ['dXCPT;'],
  XCPT_CATCH     => ['dXCPT;'],
  XCPT_RETHROW   => ['dXCPT;'],
);

my %postcode = (
  dSP        => "some_global_var = !sp;",
  dMARK      => "some_global_var = !mark;",
  dORIGMARK  => "some_global_var = !origmark;",
  dAX        => "some_global_var = !ax;",
  dITEMS     => "some_global_var = !items;",
  dXSARGS    => "some_global_var = ax && items;",
  NEWSV      => "some_global_var = !arg1;",
  New        => "some_global_var = !arg1;",
  Newc       => "some_global_var = !arg1;",
  Newz       => "some_global_var = !arg1;",
  dUNDERBAR  => "(void) UNDERBAR;",
);

my %ignore = (
  map { ($_ => 1) } qw(
    svtype
    items
    ix
    dXSI32
    XS
    CLASS
    THIS
    RETVAL
    StructCopy
  ),
);

print OUT <<HEAD;
/*
 * !!!!!!!   DO NOT EDIT THIS FILE   !!!!!!!
 * This file is built by $0.
 * Any changes made here will be lost!
 */

#include "EXTERN.h"
#include "perl.h"

#define NO_XSLOCKS
#include "XSUB.h"

#ifndef DPPP_APICHECK_NO_PPPORT_H

#define NEED_eval_pv
#define NEED_grok_bin
#define NEED_grok_hex
#define NEED_grok_number
#define NEED_grok_numeric_radix
#define NEED_grok_oct
#define NEED_newCONSTSUB
#define NEED_newRV_noinc
#define NEED_sv_2pv_nolen
#define NEED_sv_2pvbyte
#define NEED_sv_catpvf_mg
#define NEED_sv_catpvf_mg_nocontext
#define NEED_sv_setpvf_mg
#define NEED_sv_setpvf_mg_nocontext
#define NEED_vnewSVpvf


#include "ppport.h"

#endif

static int some_global_var;

static int    VARarg1;
static char  *VARarg2;
static double VARarg3;

HEAD

my $f;
for $f (@f) {
  $ignore{$f->{name}} and next;
  $f->{flags}{A} or next;  # only public API members

  $ignore{$f->{name}} = 1; # ignore duplicates

  my $Perl_ = $f->{flags}{p} ? 'Perl_' : '';

  my $stack = '';
  my @arg;
  my $aTHX = '';

  my $i = 1;
  my $ca;
  my $varargs = 0;
  for $ca (@{$f->{args}}) {
    my $a = $ca->[0];
    if ($a eq '...') {
      $varargs = 1;
      push @arg, qw(VARarg1 VARarg2 VARarg3);
      last;
    }
    my($n, $p, $d) = $a =~ /^ (\w+(?:\s+\w+)*)\s*  # type name  => $n
                              (\**)                # pointer    => $p
                              ((?:\[[^\]]*\])*)    # dimension  => $d
                            $/x
                     or die "$0 - cannot parse argument: [$a]\n";
    if (exists $amap{$n}) {
      push @arg, $amap{$n};
      next;
    }
    $n = $tmap{$n} || $n;
    my $v = 'arg' . $i++;
    push @arg, $v;
    $stack .= "  static $n $p$v$d;\n";
  }

  unless ($f->{flags}{n} || $f->{flags}{'m'}) {
    $stack = "  dTHX;\n$stack";
    $aTHX = @arg ? 'aTHX_ ' : 'aTHX';
  }

  if ($stack{$f->{name}}) {
    my $s = '';
    for (@{$stack{$f->{name}}}) {
      $s .= "  $_\n";
    }
    $stack = "$s$stack";
  }

  my $args = join ', ', @arg;
  my $rvt = $f->{ret} || 'void';
  my $ret;
  if ($void{$rvt}) {
    $ret = $castvoid{$f->{name}} ? '(void) ' : '';
  }
  else {
    $ret = $ignorerv{$f->{name}} ? '(void) ' : "return ";
  }
  my $aTHX_args = "$aTHX$args";

  my $post = '';
  if ($postcode{$f->{name}}) {
    $post = $postcode{$f->{name}};
    $post =~ s/^/    /g;
    $post = "\n$post";
  }

  unless ($f->{flags}{'m'} and @arg == 0) {
    $args = "($args)";
    $aTHX_args = "($aTHX_args)";
  }

  print OUT <<HEAD;
/******************************************************************************
*
*  $f->{name}
*
******************************************************************************/

HEAD

  if ($todo{$f->{name}}) {
    my($ver,$sub) = $todo{$f->{name}} =~ /^5\.(\d{3})(\d{3})$/ or die;
    for ($ver, $sub) {
      s/^0+(\d)/$1/
    }
    if ($ver < 6 && $sub > 0) {
      $sub =~ s/0$// or die;
    }
    print OUT "#if PERL_VERSION > $ver || (PERL_VERSION == $ver && PERL_SUBVERSION >= $sub) /* TODO */\n";
  }

  my $final = $varargs
              ? "$Perl_$f->{name}$aTHX_args"
              : "$f->{name}$args";

  $f->{cond} and print OUT "#if $f->{cond}\n";

  print OUT <<END;
$rvt _DPPP_test_$f->{name} (void)
{
  dXSARGS;
$stack
#ifdef $f->{name}
  if (some_global_var)
  {
    $ret$f->{name}$args;$post
  }
#endif

  some_global_var = items && ax;

  {
#ifdef $f->{name}
    $ret$final;$post
#else
    $ret$Perl_$f->{name}$aTHX_args;$post
#endif
  }
}
END

  $f->{cond} and print OUT "#endif\n";
  $todo{$f->{name}} and print OUT "#endif\n";

  print OUT "\n";
}

@ARGV and close OUT;

