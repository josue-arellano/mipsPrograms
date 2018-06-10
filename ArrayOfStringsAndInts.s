# Josue Arellano
# CS 264
# Program 5

.data
  array:      .space  480
  strSize:    .space  40
  tempStr1:   .byte  48
  enter:      .asciiz "Enter in the name, age and ID for 10 students please:\n"
  name:       .asciiz " name: "
  age:        .asciiz " age:  "
  id:         .asciiz " ID:   "
  record:     .asciiz "Record "
  menu1:      .asciiz "Menu:\n"
  menu2:      .asciiz " 1) Swap two records.\n"
  menu3:      .asciiz " 2) Exit\n"
  menu4:      .asciiz "Please choose one of the above options: "
  swap1:      .asciiz " Which record do you select first? "
  swap2:      .asciiz " Which record do you want to swap it with? "
  colon:      .asciiz ": "
  space:      .asciiz " "
  newLn:      .asciiz "\n"
  end:        .asciiz "Goodbye!"

.text
.globl main

main:
  li $v0, 4             # intro string
  la $a0, enter
  syscall
  
  ori $s0, $0, 480      # initializing all indices and constants
  ori $s5, $0, 40
  ori $s4, $0, 48
  ori $t0, $0, 0
  ori $t1, $0, 0
  ori $t2, $0, 1
  ori $t4, $0, 0
  ori $s2, $0, 2
  ori $s1, $0, 1
  ori $s6, $0, 10
  
  j loop
  
  li $v0, 10            # if for some reason it does not jump, end program
  syscall

loop:
  beq $t0, $s0, prntArr # only loop the size of the array
  ori $t3, $0, 0        # $t3 index is set to 0
  
  la $a0, name          # request for name
  li $v0, 4
  syscall
  
  la $a0, array($t0)    # get address of where the string will be stored
  li $a1, 41            # buffer size, must be stringSize + 1
  li $v0, 8             # instruction to request for string
  syscall
  
  addi $t3, $t0, 0      # initialize index $t3 to 0
  jal rmvNwLn           # jump to remove the '\n' char at the end of the string
  
  addi $t0, $t0, 40     # increment to access where the age should be stored in
                        #   array
  la $a0, age           # request for age
  li $v0, 4
  syscall
  li $v0, 5
  syscall
  
  sw $v0, array($t0)    # save input to array
  addi $t0, $t0, 4      # inrement to access where the ID should be stored in 
                        #   array
  la $a0, id            # request for ID
  li $v0, 4
  syscall
  li $v0, 5
  syscall

  sw $v0, array($t0)    # save input to array
  addi $t0, $t0, 4
  j loop                # jump back to get all inputs

rmvNwLn:
  lb $a3, array($t3)    # $a3 = byte at array($t3)
  addi $t3, $t3, 1      # increment index
  bnez $a3, rmvNwLn     # if $a3 != 0 loop
  beq $a1, $s5, skip    # if $a3 == size of string
  sub $t3, $t3, $s2     # --$a3
  sb $0, array($t3)     # add null char to end of string
  
skip:
  j $ra                 # jump back
  
menu:
  beq $t4, 2, exit      # compare user input
  beq $t4, 1, swap
  li $v0, 4             # print options
  la $a0, menu1
  syscall
  la $a0, menu2
  syscall
  la $a0, menu3
  syscall
  la $a0, menu4
  syscall
  li $v0, 5             # get user input
  syscall
  move $t4, $v0
  j menu                # loop
  
swap:
  li $v0, 4             # print options
  la $a0, swap1
  syscall
  ori $t0, $0, 0  
  li $v0, 5             # get first index
  syscall
  move $t5, $v0         # modify index
  slti $t8, $t5, 1      # if $t5 < 1 end program
  beq $t8, $s1, exit
  sub $t5, $t5, $s1     #   $t5--
  mult $t5, $s4         #   $t5 *= 48
  mflo $t5
  ori $t0, $0, 0        # reset indices
  ori $t1, $0, 0
  ori $t2, $0, 1
  li $v0, 4
  la $a0, swap2         # get second index
  syscall
  li $v0, 5
  syscall
  move $t6, $v0         # modify second index 
  slt $t8, $s6, $t6     # if 10 < $t6 end program
  beq $t8, $s1, exit
  sub $t6, $t6, $s1     #   $t6--
  mult $t6, $s4         #   $t6 *= 48
  mflo $t6
  j copy                # swap the two elements
  
copy:
  beq $t0, $s4, prntArr # loop until 48
  lb $a3, array($t6)    # copy byte into $a3
  lb $t7, array($t5)    # copy byte into $t7
  sb $a3, array($t5)    # copy byte into array($t5)
  sb $t7, array($t6)    # copy byte into array($t6)
  addi $t0, $t0, 1      # increment indices
  addi $t6, $t6, 1
  addi $t5, $t5, 1
  j copy                # loop

prntArr:
  beq $t1, $s0, menu    # loop until reached end of array
  ori $t4, $0, 0
  li $v0, 4
  la $a0, record        # print "Record #: "
  syscall
  li $v0, 1
  or $a0, $t2, $0
  syscall
  li $v0, 4
  la $a0, colon
  syscall
  la $a0, array($t1)    # get the string from array
  li $a1, 40  
  syscall
  li $a1, 4             # print string
  addi $t1, $t1, 40     # increment index
  li $v0, 4
  la $a0, space
  syscall
  li $v0, 1
  lw $a0, array($t1)    # print age
  syscall
  li $v0, 4
  la $a0, space
  syscall
  addi $t1, $t1, 4
  li $v0, 1
  lw $a0, array($t1)    # print ID
  syscall
  addi $t1, $t1, 4
  addi $t2, $t2, 1
  li $v0, 4
  la $a0, newLn
  syscall
  j prntArr             # loop

exit:
  li $v0, 4             # print end string
  la $a0, end
  syscall
  li $v0, 10            # end program
  syscall