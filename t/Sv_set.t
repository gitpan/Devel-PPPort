################################################################################
#
#            !!!!!   Do NOT edit this file directly!   !!!!!
#
#            Edit mktests.PL and/or parts/inc/Sv_set instead.
#
################################################################################

BEGIN {
  if ($ENV{'PERL_CORE'}) {
    chdir 't' if -d 't';
    @INC = ('../lib', '../ext/Devel/PPPort/t') if -d '../lib' && -d '../ext';
    require Config; import Config;
    use vars '%Config';
    if (" $Config{'extensions'} " !~ m[ Devel/PPPort ]) {
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
    print "1..5\n";
  }
  else {
    plan(tests => 5);
  }
}

use Devel::PPPort;
use strict;
$^W = 1;

my $foo = 5;
ok(&Devel::PPPort::TestSvUV_set($foo, 12345), 42);
ok(&Devel::PPPort::TestSvPVX_const("mhx"), 43);
ok(&Devel::PPPort::TestSvPVX_mutable("mhx"), 44);

my $bar = [];

bless $bar, 'foo';
ok($bar->x(), 'foobar');

Devel::PPPort::TestSvSTASH_set($bar, 'bar');
ok($bar->x(), 'hacker');

package foo;

sub x { 'foobar' }

package bar;

sub x { 'hacker' }

