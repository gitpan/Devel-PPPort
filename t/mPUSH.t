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
#  Version 3.x, Copyright (C) 2003, Marcus Holland-Moritz.
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

ok(join(':', &Devel::PPPort::mPUSHp()), "one:two:three");
ok(join(':', &Devel::PPPort::mPUSHn()), "0.5:-0.25:0.125");
ok(join(':', &Devel::PPPort::mPUSHi()), "-1:2:-3");
ok(join(':', &Devel::PPPort::mPUSHu()), "1:2:3");

ok(join(':', &Devel::PPPort::mXPUSHp()), "one:two:three");
ok(join(':', &Devel::PPPort::mXPUSHn()), "0.5:-0.25:0.125");
ok(join(':', &Devel::PPPort::mXPUSHi()), "-1:2:-3");
ok(join(':', &Devel::PPPort::mXPUSHu()), "1:2:3");

