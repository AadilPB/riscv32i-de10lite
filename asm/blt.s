.global _begin
_begin:
    addi x1, x0, 5
    addi x2, x0, 10
    blt x1, x2, _blt_taken
    addi x3, x0, -1
    bne x1, x0, _end
_blt_taken:
    addi x3, x0, 1
    # not-taken: x1 > x2 (5 > 0)
    addi x2, x0, 0
    blt x1, x2, _blt_greater_than_fail
    addi x3, x0, 2
    bne x1, x0, _blt_equal_test
_blt_greater_than_fail:
    addi x3, x0, -2

_blt_equal_test:
    # not-taken: x1 == x2 (5 == 5)
    addi x2, x0, 5
    blt x1, x2, _blt_equal_fail
    addi x3, x0, 3
    bne x1, x0, _blt_signed_test
_blt_equal_fail:
    addi x3, x0, -3

_blt_signed_test:
    # taken: signed -5 < 5
    addi x1, x0, -5
    addi x2, x0, 5
    blt x1, x2, _blt_signed_taken
    addi x3, x0, -4
    bne x1, x0, _end
_blt_signed_taken:
    addi x3, x0, 4
    addi x1, x0, 5
    addi x2, x0, -5
    blt x1, x2, _blt_signed_fail
    addi x3, x0, 5
    bne x1, x0, _end

_blt_signed_fail:
    addi x3, x0, -5

_end:
