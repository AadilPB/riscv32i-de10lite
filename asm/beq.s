.global _begin

_begin:
    addi x1, x0, 1
    addi x2, x0, 1
    beq x1, x2, _beq_taken
    addi x3, x0, -5
    bne x1, x0, _end

_beq_taken:
    addi x3, x0, 12
    addi x2, x0, -1
    beq x1, x2, _beq_not_taken
    addi x3, x0, 5
    bne x1, x0, _end

_beq_not_taken:
    addi x3, x0, -12

_end:
