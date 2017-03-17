#!/usr/bin/perl -w

print "9 - 16 = ", subtract(9, 16), "\n";

use Inline ASM => 'DATA',
              AS => 'nasm',
              ASFLAGS => '-f elf64',
              PROTO => {subtract => 'int(int,int)'};

__END__
__ASM__

.text
.global    subtract

             GLOBAL subtract
             SECTION .text

subtract: 
	mov eax,[esp+4]
        sub eax,[esp+8]
        ret
