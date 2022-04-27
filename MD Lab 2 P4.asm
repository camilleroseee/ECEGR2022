# Lab 2, Part 4 - Arrays 

# declaring arrays A and B 
.data 
	array_A: .word 0,0,0,0,0
	array_B: .word 1, 2, 4, 8, 16 
	.text 
	
# main section of code 
main: 
	# loading the array addresses into registers (la = load address) 
	la s0, array_A 
	la s1, array_B 
	addi a0, zero, 0 
	addi gp, zero, 4 

# for loop performing A[i] = B[i] - 1 array operation 
forLoop: slti s2, a0, 5 # this is the same as for i < 5 
	beq s2, zero, exitFor # if condition isn't met, you exit the loop 
	mul s3, a0, gp 
	mul s4, a0, gp 
	add s3, s1, s3 
	add s4, s0, s4
	
	lw s10, 0(s3) 
	addi s10, s10, -1 
	
	sw s10, 0(s4) 
	addi a0, a0, 1 
	j forLoop 

exitFor: addi a0, a0, -1 
	 addi tp, zero, -1 

# while loop performing A[i] = (A[i]+B[i])*2 array operation 
whileLoop: beq a0, tp, exitWhile # if condition isn't met, then you exit the loop 
	   mul s3, a0, gp 
	   mul s4, a0, gp 
	   add s3, a0, s3 
	   add s4, a0, s4 
	   
	   lw s8, 0(s3) 
	   lw s9, 0(s4) 
	   
	   add s5, s8, s9 
	   addi s6, zero, 2 
	   mul s5, s5, s6 
	   sw s5, 0(s3) 
	   addi a0, a0, -1 
	   j whileLoop 

exitWhile: 
	li s7, 10 
	ecall 