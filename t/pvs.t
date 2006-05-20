################################################################################
#
#            !!!!!   Do NOT edit this file directly!   !!!!!
#
#            Edit mktests.PL and/or parts/inc/pvs instead.
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
    print "1..7\n";
  }
  else {
    plan(tests => 7);
  }
}

use Devel::PPPort;
use strict;
$^W = 1;

my $x = 'foo';

ok(Devel::PPPort::newSVpvs(), "newSVpvs");

Devel::PPPort::sv_catpvs($x);
ok($x, "foosv_catpvs");

Devel::PPPort::sv_setpvs($x);
ok($x, "sv_setpvs");

my %h = ('hv_fetchs' => 42);
Devel::PPPort::hv_stores(\%h, 4711);
ok(scalar keys %h, 2);
ok(exists $h{'hv_stores'});
ok($h{'hv_stores'}, 4711);
ok(Devel::PPPort::hv_fetchs(\%h), 42);

