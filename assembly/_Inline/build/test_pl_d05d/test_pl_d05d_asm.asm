
   .text
   .globl    add

   add:      movl 4(%esp),%eax
             addl 8(%esp),%eax
             ret
   