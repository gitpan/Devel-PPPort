################################################################################
#
#  !!!!! Do NOT edit this file directly! -- Edit mktests.PL instead. !!!!!
#
################################################################################
#
#  Perl/Pollution/Portability
#
################################################################################
#
#  Version 3.x, Copyright (C) 2004, Marcus Holland-Moritz.
#  Version 2.x, Copyright (C) 2001, Paul Marquess.
#  Version 1.x, Copyright (C) 1999, Kenneth Albanowski.
#
#  This program is free software; you can redistribute it and/or
#  modify it under the same terms as Perl itself.
#
################################################################################

BEGIN {
  if ($ENV{'PERL_CORE'}) {
    chdir 't' if -d 't';
    @INC = ('../lib', '../ext/Devel/PPPort/t') if -d '../lib' && -d '../ext';
    require Config; import Config;
    use vars '%Config';
    if (" $Config{'extensions'} " !~ m[ Devel/PPPort ] ) {
      print "1..0 # Skip -- Perl configured without Devel::PPPort module\n";
      exit 0;
    }
  }
  else {
    unshift @INC, 't';
  }

  eval "use Test";
  if ($@) {
    require 'testutil.pl';
    print "1..31\n";
  }
  else {
    plan(tests => 31);
  }
}

use Devel::PPPort;
use strict;
$^W = 1;

use vars qw($my_sv @my_av %my_hv);

my @s = &Devel::PPPort::newSVpvn();
ok(@s == 5);
ok($s[0], "test");
ok($s[1], "te");
ok($s[2], "");
ok(!defined($s[3]));
ok(!defined($s[4]));

ok(!defined(&Devel::PPPort::PL_sv_undef()));
ok(&Devel::PPPort::PL_sv_yes());
ok(!&Devel::PPPort::PL_sv_no());
ok(&Devel::PPPort::PL_na("abcd"), 4);

ok(&Devel::PPPort::boolSV(1));
ok(!&Devel::PPPort::boolSV(0));

$_ = "Fred";
ok(&Devel::PPPort::DEFSV(), "Fred");
ok(&Devel::PPPort::UNDERBAR(), "Fred");

eval { 1 };
ok(!&Devel::PPPort::ERRSV());
eval { cannot_call_this_one() };
ok(&Devel::PPPort::ERRSV());

ok(&Devel::PPPort::gv_stashpvn('Devel::PPPort', 0));
ok(!&Devel::PPPort::gv_stashpvn('does::not::exist', 0));
ok(&Devel::PPPort::gv_stashpvn('does::not::exist', 1));

$my_sv = 1;
ok(&Devel::PPPort::get_sv('my_sv', 0));
ok(!&Devel::PPPort::get_sv('not_my_sv', 0));
ok(&Devel::PPPort::get_sv('not_my_sv', 1));

@my_av = (1);
ok(&Devel::PPPort::get_av('my_av', 0));
ok(!&Devel::PPPort::get_av('not_my_av', 0));
ok(&Devel::PPPort::get_av('not_my_av', 1));

%my_hv = (a=>1);
ok(&Devel::PPPort::get_hv('my_hv', 0));
ok(!&Devel::PPPort::get_hv('not_my_hv', 0));
ok(&Devel::PPPort::get_hv('not_my_hv', 1));

sub my_cv { 1 };
ok(&Devel::PPPort::get_cv('my_cv', 0));
ok(!&Devel::PPPort::get_cv('not_my_cv', 0));
ok(&Devel::PPPort::get_cv('not_my_cv', 1));

