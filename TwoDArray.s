# Josue Arellano
# CS 264
# Program 4

.data
  array:        .word   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
  menu1:        .asciiz "\nMenu (enter an int as your choice): \n"
  menu2:        .asciiz " 1) Replace a value\n"
  menu3:        .asciiz " 2) Calculate the sum of all values\n"
  menu4:        .asciiz " 3) Print out the 2D array\n"
  menu5:        .asciiz " 4) Exit\n"
  menu6:        .asciiz "What would you like to do: "
  rwRqst:       .asciiz " Which row: "
  clmRqst:      .asciiz " Which column: "
  rplcVal:      .asciiz " What value do you want to change it to? " 
  sumVal:       .asciiz " The summation of the values in the array is: "
  delim:        .asciiz "\t"
  newLn:        .asciiz "\n"
  indxErr:      .asciiz "\nThe index is too large!"
  extSt:        .asciiz "\nGood Bye!"
  
.text
.globl main
main:
  ori $t0, $0, 0  # initialize the index
  ori $t1, $0, 0  # initialize the index
  ori $t9, $0, 1  # set a register to 1 for comparing and subtracting
  ori $s4, $0, 4  # set a register to 4 for index adding
  ori $s3, $0, 3  # set a register to 3 for row count
  ori $s5, $0, 5  # set a register to 5 for column count
  jal printArray  # print the array
  li $v0, 10      # end the program if printArray doesn't get called
  syscall
  
menu:
  ori $t0, $0, 0          # reset register for use in jumps
  beq $t1, 1, replace     # if ($t1 == 1) branch to replace
  beq $t1, 2, summation   # if ($t1 == 2) branch to summation
  beq $t1, 3, printArray  # if ($t1 == 3) branch to printArray
  beq $t1, 4, exit        # if ($t1 == 4) brach to exit
  la $a0, menu1           # print menu
  li $v0, 4
  syscall
  la $a0, menu2
  syscall
  la $a0, menu3
  syscall
  la $a0, menu4
  syscall
  la $a0, menu5
  syscall
  la $a0, menu6
  syscall
  li $v0, 5
  syscall
  move $t1, $v0           # store user input in register $t1
  j menu                  # loop when complete
  
replace:
  ori $t1, $0, 0          # reset user input register so the program won't loop
  li $v0, 4
  la $a0, rwRqst          # request the user input
  syscall
  li $v0, 5
  syscall
  move $t2, $v0
  slt $t3, $s5, $t2       # if (5 < userInput) $t3 = 1
  beq $t3, $t9, indxError # if ($t3 == 1) branch to indxError to handle out of
                          #   range user input
  sub $t2, $t2, $t9       # $t2--
  mult $t2, $s3           # $t2 *= 3, multiply index by 3, because the column size
                          #   is 3.  
  mflo $t0
  li $v0, 4
  la $a0, clmRqst
  syscall
  li $v0, 5
  syscall
  move $t2, $v0
  slt $t3, $s3, $t2
  beq $t3, $t9, indxError
  sub $t2, $t2, $t9
  add $t0, $t0, $t2
  mult $t0, $s4
  mflo $t0
  li $v0, 4
  la $a0, rplcVal
  syscall
  li $v0, 5
  syscall
  move $t2, $v0
  sw $t2, array($t0)      # store word in array(index)
  j menu                  # run menu command once again
  
indxError:
  li $v0, 4               # index out of range handle
  la $a0, indxErr
  syscall
  j menu
  
summation:
  ori $t1, $0, 0
  ori $t2, $0, 0
  ori $t0, $0, 0
  jal sum                 # jump to sum to compute the sum
  la $a0, sumVal
  li $v0, 4
  syscall
  or $a0, $0, $t2         # print the sum
  li $v0, 1
  syscall
  j menu
  
sum:
  beq $t0, 60, return     # loop until the end of the array
  lw $t3, array($t0)      # load word into register
  add $t2, $t2, $t3       # sum += #t3
  addi $t0, $t0, 4        # increment index
  j sum
  
return:
  jr $ra
  
printArray:
  ori $t1, $0, 0
  beq $t0, 60, menu       # loop until the end of the array
  beq $t0, 12, newRow     # if index is a multiple of 12 go to newRow to add a new
                          #   row.
  beq $t0, 24, newRow
  beq $t0, 36, newRow
  beq $t0, 48, newRow
  lw $a0, array($t0)      # print value
  li $v0, 1
  syscall
  la $a0, delim
  li $v0, 4
  syscall
  addi $t0, $t0, 4        # increment index
  j printArray
  
afterNewRow:
  lw $a0, array($t0)      # we need this because if we return to printArray
  li $v0, 1               #   without increasing the index, the program will loop
  syscall                 #   through printArray and newRow.
  la $a0, delim
  li $v0, 4
  syscall
  addi $t0, $t0, 4
  j printArray
  
newRow:
  li $v0, 4               # if we need a new line, then we need to add the next
                          #   element and increment the index.
  la $a0, newLn
  syscall
  j afterNewRow           # jump to afterNewRow
  
exit:
  li $v0, 4
  la $a0, extSt
  syscall
  li $v0, 10
  syscall
