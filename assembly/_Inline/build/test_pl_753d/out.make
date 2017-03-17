/usr/bin/perl /usr/share/perl/5.10/ExtUtils/xsubpp  -typemap /usr/share/perl/5.10/ExtUtils/typemap   test_pl_753d.xs > test_pl_753d.xsc && mv test_pl_753d.xsc test_pl_753d.c
gcc -c   -D_REENTRANT -D_GNU_SOURCE -DDEBIAN -fno-strict-aliasing -pipe -fstack-protector -I/usr/local/include -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -O2 -g   -DVERSION=\"0.00\" -DXS_VERSION=\"0.00\" -fPIC "-I/usr/lib/perl/5.10/CORE"   test_pl_753d.c
nasm -f elf64 test_pl_753d_asm.asm -o test_pl_753d_asm.o
test_pl_753d_asm.asm:2: error: attempt to define a local label before any non-local labels
test_pl_753d_asm.asm:3: error: attempt to define a local label before any non-local labels
test_pl_753d_asm.asm:3: error: parser: instruction expected
make: *** [test_pl_753d_asm.o] Error 1
