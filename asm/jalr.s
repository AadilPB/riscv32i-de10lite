.global _begin

_begin:
addi x1, x0, 16
addi x3, x0, 2
jalr x2, 0(x1)
addi x3, x0, 99
addi x4, x0, 55

done:
    jal  x0, done   

