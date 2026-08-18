.global _begin
_begin:
    addi x1, x0, 5
    addi x2, x0, 10
    # not-taken: 5>=10 false
    bge x1, x2, _bge_greater_than_fail
    addi x3, x0, 1
    bne x1, x0, _bge_greater_taken_test
_bge_greater_than_fail:
    addi x3, x0, -1
    bne x1, x0, _end

_bge_greater_taken_test:
    # taken: 5 >= 0 true
    addi x2, x0, 0
    bge x1, x2, _bge_greater_taken
    addi x3, x0, -2
    bne x1, x0, _end
_bge_greater_taken:
    addi x3, x0, 2
    bne x1, x0, _bge_equal_test

_bge_equal_test:
    # taken: 5 >= 5 true
    addi x2, x0, 5
    bge x1, x2, _bge_equal_taken
    addi x3, x0, -3
    bne x1, x0, _end
_bge_equal_taken:
    addi x3, x0, 3

_bge_signed_test:
    # not taken: signed -5 >= 5 false
    addi x1, x0, -5
    addi x2, x0, 5
    bge x1, x2, _bge_signed_fail
    addi x3, x0, 4
    bne x1, x0, _bge_signed_taken_test

_bge_signed_fail:
    addi x3, x0, -4
    bne x1, x0, _end   

_bge_signed_taken_test:
    addi x1, x0, 5
    addi x2, x0, -5
    bge x1, x2, _bge_signed_taken
    addi x3, x0, -5
    bne x1, x0, _end

_bge_signed_taken:
    addi x3, x0, 5

_end:
