/usr/bin/perl /usr/share/perl/5.10/ExtUtils/xsubpp  -typemap /usr/share/perl/5.10/ExtUtils/typemap   test_pl_d05d.xs > test_pl_d05d.xsc && mv test_pl_d05d.xsc test_pl_d05d.c
gcc -c   -D_REENTRANT -D_GNU_SOURCE -DDEBIAN -fno-strict-aliasing -pipe -fstack-protector -I/usr/local/include -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -O2 -g   -DVERSION=\"0.00\" -DXS_VERSION=\"0.00\" -fPIC "-I/usr/lib/perl/5.10/CORE"   test_pl_d05d.c
as -f elf test_pl_d05d_asm.asm -o test_pl_d05d_asm.o
Assembler messages:
Error: can't open elf for reading: No such file or directory
test_pl_d05d_asm.asm:3: Error: junk at end of line, first unrecognized character is ` '
test_pl_d05d_asm.asm:7: Warning: partial line at end of file ignored
make: *** [test_pl_d05d_asm.o] Error 1
