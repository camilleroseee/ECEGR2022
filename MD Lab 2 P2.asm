# Lab 2, Part 2 

# declare variables A,B,C,Z

.data 
	A: .word 10
	B: .word 15 
	C: .word 6
	Z: .word 0 
.text

# main section of code # 

main: 
	# loading the values onto A,B,C,Z so we can manipulate them in registers
	lw a1, A
	lw a2, B
	lw a3, C
	lw a4, Z
	
	addi tp, zero, 5 # assigning 5 to register a0 to make it easier to refer to 
	
	# beginning of logic statements 
	
	# assigning the logical statements for if statement 
	slt s0, a1, a2  # A < B 
	slt s1, tp, a3 # 5 < C 
	and s2, s0, s1 # anding together the two registers 
	
	# if statement using branches 
	beq s2, zero, ElseIf # if(A<B && C <>5) 
	addi a4, zero, 1 # assigning Z = 1 
	j Exit # jumping to exit 
	
	# else-if statement 
ElseIf: slt a0, a2, a1 # B < A
	addi t0, a3, 1 # C+1 
	addi t1, t0, 7 # (C+1)==7 
	beq a3, zero, checkIfTrue
	bne a5, zero, checkIfTrue
	
	addi a4, zero, 3 
	j Exit 
	
checkIfTrue: addi a4, zero, 2 
	     j Exit 

Exit:	addi sp, zero, 1
	addi gp, zero, 2
	addi tp, zero, 3
	# switch-cases
	beq  a4, sp, case1
	beq  a4, gp, case2
	beq  a4,tp, case3
	addi a3, zero, 0 
	j EndProgram
	
case1: addi a4, zero, -1
	j EndProgram
case2: addi a4, zero, -2
	j EndProgram
case3: addi a4, zero, -3
	j EndProgram 

	# ends the program and assigns new value to Z variable 
EndProgram: sw a4, Z, t6