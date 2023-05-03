addi s0 x0 1
addi s1 x0 2
addi s2 x0 3 
addi s3 x0 4 
addi s4 x0 5

slli s4 s4 0b01
slti t0 s4 0
xori s0 s0 0b101
srli s4 s4 0b01
srai s3 s3 0b110
ori t1 t0 0b101
andi t0 t0 0b101
