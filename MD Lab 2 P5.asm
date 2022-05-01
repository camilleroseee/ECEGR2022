# Lab 2, Part 5 

# declaring my variables A,B,C to be stored in memory 
.data
	varA: .word 0 
	varB: .word 0 
	varC: .word 0 
.text

# main part of code 
main: 
	addi t0, zero, 5
	addi t1, zero, 10
	
	addi sp, sp, -8
	sw t0, 4(sp)
	sw t1, 0(sp)
	
	add a0, zero, t0
	jal AddItUp
	sw t1, varA, s0
	
	lw t1, 0(sp)
	add a0, zero, t1
	jal AddItUp
	sw t1, varB, s0
	
	addi sp, sp, 8
	
	lw t0, varA
	lw t1, varB
	add t2, t0, t1
	sw t2, varC, s0
	
	li a7,10			
	ecall

#AddItUp function 
AddItUp:
	add t0, zero, zero
	add t1, zero, zero

# for loop to perform the adding operation of AddItUp
forLoop: slt t5, t0, a0
	beq t5, zero, exitForLoop
	addi t2, t0, 1
	add t1, t1, t2
	addi t0, t0, 1
	j forLoop

exitForLoop:
	ret
	