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
    print "1..2\n";
  }
  else {
    plan(tests => 2);
  }
}

use Devel::PPPort;
use strict;
$^W = 1;

ok(&Devel::PPPort::no_THX_arg("42"), 43);
ok(&Devel::PPPort::with_THX_arg("4711"), 4712);

