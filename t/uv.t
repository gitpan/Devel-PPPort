################################################################################
#
#  !!!!! Do NOT edit this file directly! -- Edit mktests.PL instead. !!!!!
#
################################################################################
#
#  Perl/Pollution/Portability Test File
#
################################################################################
#
#  $Revision: 16 $
#  $Author: mhx $
#  $Date: 2004/08/13 12:49:20 +0200 $
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
    print "1..8\n";
  }
  else {
    plan(tests => 8);
  }
}

use Devel::PPPort;
use strict;
$^W = 1;

ok(&Devel::PPPort::sv_setuv(42), 42);
ok(&Devel::PPPort::newSVuv(123), 123);
ok(&Devel::PPPort::sv_2uv("4711"), 4711);
ok(&Devel::PPPort::sv_2uv("1735928559"), 1735928559);
ok(&Devel::PPPort::SvUVx("1735928559"), 1735928559);
ok(&Devel::PPPort::SvUVx(1735928559), 1735928559);
ok(&Devel::PPPort::SvUVx(0xdeadbeef), 0xdeadbeef);
ok(&Devel::PPPort::XSRETURN_UV(), 42);

