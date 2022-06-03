.data
# prompts for user (string type) 
userPrompt: .asciz "Enter a value: "
CelRes: .asciz "The temperature in Celsius is: "
KelRes: .asciz "The temperature in Kelvin is: "
newLine: .asciz "\r\n"

# floating point quantities 
FahrenFP: .float 0 
CelsFP: .float 0 
KelvFP: .float 0 

# extra values needed for conversion 
kelvinAdd: .float 273.15
.text

# Main program ------

main: 
#initializing floating point values 

flw fa0, FahrenFP, t0 
flw fa1, CelsFP, t0 
flw fa2, KelvFP, t0 

# initializing extra value for Kelvin conversion 
flw ft3, kelvinAdd, t0 

li a7, 4 
la a0,userPrompt
ecall 

li a7, 6
ecall 

jal convC
jal convK 
# Conversion Functions --------
convC: 
# initializing extra values needed for Celsius conversion 
li t0,5
li t1, 9 
li t2, 32

#Celsius calcuation 
fcvt.s.w ft0, t0
fcvt.s.w ft1, t1
fcvt.s.w ft2, t2 

fsub.s fs2, fa0 , ft2 
fdiv.s fs3, ft0, ft1 
fmul.s fa1, fs2, fs3 # temperature in Celsius 

# Showing the answer 
li a7, 4
la a0, CelRes
ecall 

li a7, 2 
fmv.s fa0, fa1 
ecall 

ret 

convK: 
#Kelvin Calculation 
flw ft3, kelvinAdd, t0
fadd.s fa0, fa0, ft3 

# Showing the answer 
li a7, 4 
la a0, newLine 
ecall 

li a7, 4 
la a0, KelRes 
ecall 

li a7, 2 
ecall 


