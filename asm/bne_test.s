.global _begin

_begin:
    addi x1, x0, 1
    addi x2, x0, 1
    bne x1, x2, _bne_not_taken_fail
    addi x3, x0, 1
    bne x1, x0, _bne_taken_test

_bne_not_taken_fail:
    addi x3, x0, -1
    bne x1, x0, _end


_bne_taken_test:
    addi x2, x0, -1
    bne x1, x2, _bne_taken
    addi x3, x0, -2
    bne x1, x0, _end
_bne_taken:
    addi x3, x0, 2

_end:


