################################################################################
#
#            !!!!!   Do NOT edit this file directly!   !!!!!
#
#            Edit mktests.PL and/or parts/inc/newCONSTSUB instead.
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
    print "1..3\n";
  }
  else {
    plan(tests => 3);
  }
}

use Devel::PPPort;
use strict;
$^W = 1;

&Devel::PPPort::call_newCONSTSUB_1(); 
ok(&Devel::PPPort::test_value_1(), 1);

&Devel::PPPort::call_newCONSTSUB_2(); 
ok(&Devel::PPPort::test_value_2(), 2);

&Devel::PPPort::call_newCONSTSUB_3(); 
ok(&Devel::PPPort::test_value_3(), 3);

