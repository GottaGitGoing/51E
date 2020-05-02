#                                           ICS 51, Lab #1
# 
#                                          IMPORTATNT NOTES:
# 
#                       Write your assembly code only in the marked blocks.
# 
#                       DO NOT change anything outside the marked blocks.
# 
#
j main
###############################################################
#                           Data Section
.data
# 


new_line: .asciiz "\n"
space: .asciiz " "
triple_range_lbl: .asciiz "\nTrible range (Decimal Values) \nExpected output:\n240000 0 -300\nObtained output:\n"
swap_bits_lbl: .asciiz "\nSwap bits (Hexadecimal Values)\nExpected output:\n55555555 02138A9B FDEC7564\nObtained output:\n"
count_ones_lbl: .asciiz "\nCount ones \nExpected output:\n16 12 20\nObtained output:\n"

swap_bits_test_data:  .word 0xAAAAAAAA, 0x01234567, 0xFEDCBA98
swap_bits_expected_data:  .word 0x55555555, 0x02138A9B, 0xFDEC7564

triple_range_test_data: .word 80000, 111, 0, -111, 11
triple_range_expected_data: .word 240000, 0, -300

hex_digits: .byte '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'

###############################################################
#                           Text Section
.text
# Utility function to print hexadecimal numbers
print_hex:
move $t0, $a0
li $t1, 8 # digits
lui $t2, 0xf000 # mask
mask_and_print:
# print last hex digit
and $t4, $t0, $t2 
srl $t4, $t4, 28
la    $t3, hex_digits  
add   $t3, $t3, $t4 
lb    $a0, 0($t3)            
li    $v0, 11                
syscall 
# shift 4 times
sll $t0, $t0, 4
addi $t1, $t1, -1
bgtz $t1, mask_and_print
exit:
jr $ra
###############################################################
###############################################################
###############################################################
#                            PART 1 (Count Bits)
# 
# You are given an 32-bits integer stored in $t0. Count the number of 1's
#in the given number. For example: 1111 0000 should return 4
count_ones:
move $t0, $a0 
############################## Part 1: your code begins here ###
addi $t1, $zero, 32  # the while loop decrementer
addi $t3, $zero, 1   # the MASK
addi $t4, $zero, 0   # 1's counter
addi $t2, $zero, 0   # The bitwise ander result

while:
	blt $t1, 1, escape_loop
	
	and $t2, $t3, $t0   # store result of anding the 32 bit and mask
	add $t4, $t4, $t2  # add either 1 or 0 to the value of s1 the 1's counter
	srl $t0, $t0, 1
	
	addi $t1, $t1, -1
	j while  

escape_loop:
	add $t0, $zero, $t4



############################## Part 1: your code ends here ###
move $v0, $t0
jr $ra

###############################################################
###############################################################
###############################################################
###############################################################
###############################################################
###############################################################
#                            PART 2 (Swap Bits)
# 
# You are given an 32-bits integer stored in $t0. You need swap the bits
# at odd and even positions. i.e. b31 <-> b30, b29 <-> b28, ... , b1 <-> b0
# The result must be stored inside $t0 as well.
swap_bits:
move $t0, $a0 
############################## Part 2: your code begins here ###

# make odd mask (t1)
lui $t1, 0x5555
ori,$t1, $t1, 0x5555

# make even mask (t2)
lui, $t2, 0xAAAA
ori, $t2, $t2, 0xAAAA

# and and shift t1 and t0 into t3
and $t3, $t0,$t1
sll $t3, $t3, 1

# and and shift t2, and t0 into t4
and $t4, $t0,$t2
srl $t4, $t4, 1

or $t0, $t4, $t3



############################## Part 2: your code ends here ###
move $v0, $t0
jr $ra

###############################################################
###############################################################
###############################################################
#                           PART 3
# 
# You are given three integers. You need to find the smallest 
# one and the largest one and multiply their sum by three and return it.
# 
# Implementation details:
# The three integers are stored in registers $t0, $t1, and $t2. You 
# need to store the answer into register $t0. It will be returned by the
# function to the caller.

triple_range:
move $t0, $a0
move $t1, $a1
move $t2, $a2
############################### Part 3: your code begins here ##
# check if a is greater than b and c
ble $t0,$t1, check_b # if a greater than b CONTINUE
ble $t0,$t2, max_c # if a greater than c COntinue
add $t4,$zero,$t0    # set a be the max on $s0
# now we know a is greatest, check   ---- check B and C
ble $t1,$t2, min_b
ble $t2,$t1, min_c

check_b:

	ble $t1, $t2, max_c
	add $t4, $zero, $t1 # if here it means b is the max
	ble $t0, $t2, min_a
	ble $t2, $t0, min_c

max_c:
	add $t4,$zero, $t2 # if here, it means c is greater
	ble $t0, $t1, min_a
	ble $t1, $t0, min_b


min_a: add $t5, $zero, $t0
j comp
min_b: add $t5, $zero, $t1
j comp
min_c: add $t5, $zero, $t2
j comp

comp:
	add $t3, $t4,$t5
	mul $t0, $t3,3

############################### Part 3: your code ends here  ##
move $v0, $t0
jr $ra

###############################################################
###############################################################
###############################################################
#                          Main Function 
main:

li $v0, 4
la $a0, new_line
syscall
la $a0, count_ones_lbl
syscall

# Testing part 2
li $s0, 3 # num of test cases
li $s1, 0
la $s2, swap_bits_test_data

test_p1:
add $s4, $s2, $s1
# Pass input parameter
lw $a0, 0($s4)
jal count_ones

move $a0, $v0        # $integer to print
li $v0, 1
syscall

li $v0, 4
la $a0, space
syscall

addi $s1, $s1, 4
addi $s0, $s0, -1
bgtz $s0, test_p1

li $v0, 4
la $a0, new_line
syscall
la $a0, swap_bits_lbl
syscall

# Testing part 2
li $s0, 3 # num of test cases
li $s1, 0
la $s2, swap_bits_test_data

test_p2:
add $s4, $s2, $s1
# Pass input parameter
lw $a0, 0($s4)
jal swap_bits

move $a0, $v0
jal print_hex
li $v0, 4
la $a0, space
syscall

addi $s1, $s1, 4
addi $s0, $s0, -1
bgtz $s0, test_p2

li $v0, 4
la $a0, new_line
syscall
la $a0, triple_range_lbl
syscall


# Testing part 3
li $s0, 3 # num of test cases
li $s1, 0
la $s2, triple_range_test_data

test_p3:
add $s4, $s2, $s1
# Pass input parameter
lw $a0, 0($s4)
lw $a1, 4($s4)
lw $a2, 8($s4)
jal triple_range

move $a0, $v0        # $integer to print
li $v0, 1
syscall

li $v0, 4
la $a0, space
syscall

addi $s1, $s1, 4
addi $s0, $s0, -1
bgtz $s0, test_p3

_end:
# end program
li $v0, 10
syscall

