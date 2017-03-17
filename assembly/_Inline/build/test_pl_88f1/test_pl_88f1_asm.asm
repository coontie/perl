
.text
.globl    add

             GLOBAL subtract
             SECTION .text

subtract: mov eax,[esp+4]
             sub eax,[esp+8]
             ret

