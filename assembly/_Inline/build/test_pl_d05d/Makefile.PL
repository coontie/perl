use ExtUtils::MakeMaker;
my %options = %{
{
  'TYPEMAPS' => [
    '/usr/share/perl/5.10/ExtUtils/typemap'
  ],
  'NAME' => 'test_pl_d05d',
  'CC' => 'gcc',
  'OBJECT' => '$(BASEEXT)$(OBJ_EXT) test_pl_d05d_asm$(OBJ_EXT)',
  'VERSION' => '0.00'
}
};
WriteMakefile(%options);

sub MY::postamble {
  <<'FOO';
test_pl_d05d_asm$(OBJ_EXT) : test_pl_d05d_asm.asm
	as -f elf test_pl_d05d_asm.asm -o test_pl_d05d_asm$(OBJ_EXT)
FOO
}

