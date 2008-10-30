################################################################################
#
#            !!!!!   Do NOT edit this file directly!   !!!!!
#
#            Edit mktests.PL and/or parts/inc/pv_tools instead.
#
#  This file was automatically generated from the definition files in the
#  parts/inc/ subdirectory by mktests.PL. To learn more about how all this
#  works, please read the F<HACKERS> file that came with this distribution.
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

  sub load {
    eval "use Test";
    require 'testutil.pl' if $@;
  }

  if (13) {
    load();
    plan(tests => 13);
  }
}

use Devel::PPPort;
use strict;
$^W = 1;

package Devel::PPPort;
use vars '@ISA';
require DynaLoader;
@ISA = qw(DynaLoader);
bootstrap Devel::PPPort;

package main;

my $uni = &Devel::PPPort::pv_escape_can_unicode();

# sanity check
ok($uni ? $] >= 5.006 : $] < 5.008);

my @r;

@r = &Devel::PPPort::pv_pretty();
ok($r[0], $r[1]);
ok($r[0], "foobarbaz");
ok($r[2], $r[3]);
ok($r[2], '<leftpv_p\retty\nright>');
ok($r[4], $r[5]);
ok($r[4], $uni ? 'N\375 Batter\355\0' : 'N\303\275 Batter\303');
ok($r[6], $r[7]);
ok($r[6], $uni ? '\\301g\\346tis Byrjun...' : '\303\201g\303\246tis...');

@r = &Devel::PPPort::pv_display();
ok($r[0], $r[1]);
ok($r[0], '"foob\0rbaz"\0');
ok($r[2], $r[3]);
ok($r[2] eq '"pv_di"...\0' ||
   $r[2] eq '"pv_d"...\0');  # some perl implementations are broken... :(

