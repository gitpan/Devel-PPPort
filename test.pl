
use Devel::PPPort;

$total = 0;
$good = 0;

sub t ($$) {
	my($name, $t) = @_;
	my($result);
	
	print "$name... ";
	$@ = "";
	$result = eval {
		$value = &{$t}();
	};
	$result = 0 if $@ ne "";
	
	print $result ? "ok" : "not ok", "\n";
	$total++;
	$good++ if $result;
}

t("Static newCONSTSUB()", sub { Devel::PPPort::test1(); Devel::PPPort::test_value_1() == 1} );
t("Global newCONSTSUB()", sub { Devel::PPPort::test2(); Devel::PPPort::test_value_2() == 2} );
t("Extern newCONSTSUB()", sub { Devel::PPPort::test3(); Devel::PPPort::test_value_3() == 3} );
t("newRV_inc()", sub { Devel::PPPort::test4()} );
t("newRV_noinc()", sub { Devel::PPPort::test5()} );
t("PL_sv_undef", sub { not defined Devel::PPPort::test6()} );
t("PL_sv_yes", sub { Devel::PPPort::test7()} );
t("PL_sv_no", sub { !Devel::PPPort::test8()} );

print "$total tests in all, $good completed successfully.\n";
