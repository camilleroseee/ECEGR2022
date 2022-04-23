# Lab 2, Part 3 - Loops 

# declaring variables to be saved into memory 
.data 
	Z: .word 2 
	I: .word 0 
	
	.text

# main code section 
main: 
	# loading variables Z and I onto registers so we can manipulate them 
	lw t0, Z
	lw sp, I 

# for-Loop
forLoop: slti a0, sp, 21 
	beq a0, zero, exitFor 
	addi t0, t0, 1 # this is the same as z++
	addi sp, sp, 2 
	j forLoop 
	
exitFor: # leaves the for loop 

# do while-Loop 
dowhileLoop: 
	addi t0, t0, 1 
	slti a0, t0, 100 # same as z < 100 condition 
	beq a0, zero exitDoWhile
	j dowhileLoop 

exitDoWhile: # leaves the do while loop 

whileLoop: slt a0, zero, sp 
	   beq a0, zero, exitWhile 
	   addi t0, t0, -1 # same as z--
	   addi sp, sp, -1 # same as i--
	   j whileLoop 
	   
exitWhile: sw t0, Z, t6 # Assigns the final value of Z to the variable to be saved in memory 