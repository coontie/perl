/usr/bin/perl /usr/share/perl/5.10/ExtUtils/xsubpp  -typemap /usr/share/perl/5.10/ExtUtils/typemap   test_pl_88f1.xs > test_pl_88f1.xsc && mv test_pl_88f1.xsc test_pl_88f1.c
gcc -c   -D_REENTRANT -D_GNU_SOURCE -DDEBIAN -fno-strict-aliasing -pipe -fstack-protector -I/usr/local/include -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -O2 -g   -DVERSION=\"0.00\" -DXS_VERSION=\"0.00\" -fPIC "-I/usr/lib/perl/5.10/CORE"   test_pl_88f1.c
nasm -f elf64 test_pl_88f1_asm.asm -o test_pl_88f1_asm.o
test_pl_88f1_asm.asm:2: error: attempt to define a local label before any non-local labels
test_pl_88f1_asm.asm:3: error: attempt to define a local label before any non-local labels
make: *** [test_pl_88f1_asm.o] Error 1
