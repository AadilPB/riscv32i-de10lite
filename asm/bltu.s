.global _begin
_begin:
    addi x1, x0, 5
    addi x2, x0, 10
    bltu x1, x2, _bltu_taken
    addi x3, x0, -1
    bne x1, x0, _end
_bltu_taken:
    addi x3, x0, 1
    # not-taken: x1 > x2 (5 > 0)
    addi x2, x0, 0
    bltu x1, x2, _bltu_greater_than_fail
    addi x3, x0, 2
    bne x1, x0, _bltu_equal_test
_bltu_greater_than_fail:
    addi x3, x0, -2

_bltu_equal_test:
    # not-taken: x1 == x2 (5 == 5)
    addi x2, x0, 5
    bltu x1, x2, _bltu_equal_fail
    addi x3, x0, 3
    bne x1, x0, _bltu_unsigned_test_1
_bltu_equal_fail:
    addi x3, x0, -3

_bltu_unsigned_test_1:
    # not taken: unsigned -5 < 5 false
    addi x1, x0, -5
    addi x2, x0, 5
    bltu x1, x2, _bltu_unsigned_fail
    addi x3, x0, 4
    bne x1, x0, _bltu_unsigned_test_2
_bltu_unsigned_fail:
    addi x3, x0, -4
    bne x1, x0, _end

_bltu_unsigned_test_2:
    # taken: unsigned 5 < -5 true
    addi x1, x0, 5
    addi x2, x0, -5
    bltu x1, x2, _bltu_unsigned_taken
    addi x3, x0, -5
    bne x1, x0, _end

_bltu_unsigned_taken:
    addi x3, x0, 5

_end:
