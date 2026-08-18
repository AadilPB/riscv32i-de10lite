.global _begin
_begin:
    addi x1, x0, 5
    addi x2, x0, 10
    # not-taken: 5>=10 false
    bgeu x1, x2, _bgeu_greater_than_fail
    addi x3, x0, 1
    bne x1, x0, _bgeu_greater_taken_test
_bgeu_greater_than_fail:
    addi x3, x0, -1
    bne x1, x0, _end

_bgeu_greater_taken_test:
    # taken: 5 >= 0 true
    addi x2, x0, 0
    bgeu x1, x2, _bgeu_greater_taken
    addi x3, x0, -2
    bne x1, x0, _end
_bgeu_greater_taken:
    addi x3, x0, 2
    bne x1, x0, _bgeu_equal_test

_bgeu_equal_test:
    # taken: 5 >= 5 true
    addi x2, x0, 5
    bgeu x1, x2, _bgeu_equal_taken
    addi x3, x0, -3
    bne x1, x0, _end
_bgeu_equal_taken:
    addi x3, x0, 3

_bgeu_unsigned_test_1:
    # taken: unsigned -5 >= 5 true
    addi x1, x0, -5
    addi x2, x0, 5
    bgeu x1, x2, _bgeu_unsigned_taken
    addi x3, x0, -4
    bne x1, x0, _end
_bgeu_unsigned_taken:
    addi x3, x0, 4
    bne x1, x0, _bgeu_unsigned_test_2

_bgeu_unsigned_test_2:
    # not taken: unsigned 5 >= -5 false
    addi x1, x0, 5
    addi x2, x0, -5
    bgeu x1, x2, _bgeu_unsigned_fail
    addi x3, x0, 5
    bne x1, x0, _end
_bgeu_unsigned_fail:
    addi x3, x0, -5

_end:
