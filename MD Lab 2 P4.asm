# MD Lab 2, Part 4 
.data
#declared two arrays in the data section, which will be stored in memory 
	array_A:	.word 0, 0, 0, 0, 0 
	array_B:	.word 1, 2, 4, 8, 16

.text

main:
	# loading the array addresses into registers (la = load address)
	la t0, array_A 
	la t1, array_B  
	addi s0, zero, 0  
	addi gp, zero, 4 
	
# for loop performing A[i] = B[i] - 1 array operation 	
forLoop: slti s11, s0, 5 # this is the same as for i < 5 
	beq s11, zero, exitFor
	mul s1, s0, gp 
	mul s2, s0, gp
	add s1, t1, s1 # address of B[i]
	add s2, t0, s2 # address of A[i]
	
	lw a0, 0(s1)
	addi a0, a0, -1
	
	sw a0, 0(s2)
	addi s0, s0, 1
	j forLoop #jumps back into the for loop 

exitFor:
	addi s0, s0, -1
	addi s5, zero, -1 # another temporary register holding value of -1 

# while loop performing A[i] = (A[i]+B[i])*2 array operation 
whileLoop:beq s0, s5, exitWhile # if condition isn't met, then you exit the loop
	mul s1, s0, gp # this is 4*i
	mul s2, s0, gp
	add s1, t1, s1 # address of B[i]
	add s2, t0, s2 # address of A[i]
	
	lw a1, 0(s1)
	lw a2, 0(s2)
	
	add a3, a1, a2
	addi a4, zero, 2
	mul a3, a3, a4
	sw a3, 0(s2)
	addi s0, s0, -1
	j whileLoop #jumps back into the while loop 
	
exitWhile:
	li  a7,10       
