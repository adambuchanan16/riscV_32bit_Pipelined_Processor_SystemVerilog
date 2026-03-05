_start:

# -------------------------
# Setup constants
# -------------------------
addi x10, x0, 0
addi x1,  x0, 5
addi x2,  x0, 10

# -------------------------
# ALU ops
# -------------------------
add  x3, x1, x2
sub  x4, x2, x1
and  x5, x1, x2
or   x6, x1, x2
xor  x7, x1, x2
slt  x8, x1, x2

# -------------------------
# Forwarding chain
# -------------------------
addi x9,  x0, 1
add  x9,  x9, x1
add  x9,  x9, x2
add  x9,  x9, x3

# -------------------------
# Branch tests
# -------------------------
beq  x1, x2, br_taken1
addi x11, x0, 111

br_taken1:
addi x12, x0, 7
addi x13, x0, 7
beq  x12, x13, br_taken2
addi x11, x0, 222

br_taken2:
addi x14, x0, 1

sw   x3, 0(x10)
sw   x4, 4(x10)
sw   x9, 8(x10)

lw   x15, 0(x10)
lw   x16, 4(x10)

lw   x17, 8(x10)
add  x18, x17, x1

jal  x20, func
addi x19, x0, 999

sw   x18, 12(x10)
sw   x21, 16(x10)

done:
jal  x0, done

func:
addi x21, x0, 123
jalr x0, 0(x20)