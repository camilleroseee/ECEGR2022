# ALU Implementation in RARS 

.data

.text

# standard ops (non-immediates) 

# inputs
li t0, 0x01234567
li t1, 0x22334455

# add operation 
add a0, t0, t1

# sub operation
sub a1, t0, t1

# AND op
and a2, t0, t1

# OR op
or a3, t0, t1

# shifting right by 1
li t1, 1
srl a4, t0, t1

# shifting right by 2 
li t1, 2
srl a5, t0, t1

# shitfing right by 3 
li t1, 3
srl a6, t0, t1

# shifting left by 1 
li t1, 1
sll a7, t0, t1

# shifting left by 2 
li t1, 2
sll s2, t0, t1

# shifting left by 3 
li t1, 3
sll s3, t0, t1

# standard ops (immediates) 

# addi op 
addi s4, t0, 0x00000123

# andi op 
andi s5, t0, 0x00000123

# or1 op 
ori  s6, t0, 0x00000123

# shift right by immediate 
srli s7, t0, 3

# shift left by immediate 
slli s8, t0, 3

# testing zero outputs using new input values 
li t0, 0x55443322
li t1, 0x55443322
sub s9, t0, t1