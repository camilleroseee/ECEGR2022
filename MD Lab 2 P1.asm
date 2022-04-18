# ASsignment: Lab #2, Part 1 

# Part 1 - translate C program into ASM

# make a variable z to store in memory 

.data
z: .word 0

.text

# assigning A,B,C,D,E,F to registers + perform operations with them 
main: 

	addi a1, zero, 15 # A = 15 
	addi a2, zero, 10 # B = 10
	addi a3, zero, 5 # C = 5 
	addi a4, zero, 2 # D = 2 
	addi a5, zero, 18, # E = 18 
	addi a6, zero, -3 # F = -3 

# solving the Z equation 	

	sub t1, a1, a2 # This subtracts A and B for A-B 
	mul t2, a3, a4 # This multiplies C and D for C*D
	sub t3, a5, a6 # This subtracts E and F for E-F
	div t4, a1, a3 # This divides A and C for A/C
	
	add s1, t1, t2 # This adds line 21 and line 22 together 
	add s2, s1, t3 # adds together line 21, 22, and 23 
	sub s3, s2, t4 # subtracts line 24 from previous lines 

	sw s3, z, t6 # assigns final value of z to s3 register 
	
	


