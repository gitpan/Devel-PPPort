
use ExtUtils::MakeMaker;

&WriteMakefile(
	NAME => "Devel::PPPort",
	DISTNAME => "Devel-PPPort",
	VERSION => "1.0007",
	
	
	XSPROTOARG => '-noprototypes',
	PM => {'PPPort.pm' => '$(INST_LIBDIR)/PPPort.pm'},
	XS => {'PPPort.xs' => 'PPPort.c'},
	OBJECT => 'PPPort$(OBJ_EXT) module2$(OBJ_EXT) module3$(OBJ_EXT)',

	'dist' => { COMPRESS=>"gzip", SUFFIX=>"gz" }
);

print <<'EOT';

This module does not support installation. If you wish to use ppport.h
in your own project, simply include it in your distribution. You may
verify that ppport.h works properly with your particular configuration
by running 'make test'.

EOT

sub MY::install {
	my $self = shift;
	<<'EOT';
install:
	@echo This module does not support installation. If you wish to use ppport.h
	@echo in your own project, simply include it in your distribution. You may
	@echo verify that ppport.h works properly with your particular configuration
	@echo by running \'make test\'.
EOT
}
