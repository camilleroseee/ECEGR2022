# Lab 2, Part 2 

# declare variables A,B,C,Z

.data 
	A: .word 10
	B: .word 15 
	C: .word 6 
	Z: .word 0 
.text

# main section of code # 

main 
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
	j exit # jumping to exit 
	
	# else-if statement 
ElseIf: slt a0, a2, a1 # B < A
	addi t0, a3, 1 # C+1 
	addi t1, t0, 7 # (C+1)==7 
	beq a3, zero, trueCheck
	beq a5, zero, trueCheck 
	
	addi a4, zero, 3 
	
trueCheck: addi a4, zero, 2 

	# switch-case conditions -- if conditions aren't met above, program jumps straight to switch-case 
Exit: 	
	

	
	 
	
	 
	
	
	