# Josue Arellano
# CS 264
# Program 3

.data
  array:        .space  40
  tempArr:      .space  40
  str1:         .asciiz "Please enter 10 integer values: "
  exitString:   .asciiz "\nGood bye"
  menu1:        .asciiz "Menu (enter an int as your choice): \n"
  menu2:        .asciiz " 1) Replace an element at a certain position\n"
  menu3:        .asciiz " 2) Remove the max element\n"
  menu4:        .asciiz " 3) Remove the min element\n"
  menu5:        .asciiz " 4) Compute values and exit\n"
  menu6:        .asciiz "What would you like to do: "
  replacePos:   .asciiz "What position from the array do you wish to replace: "
  replaceVal:   .asciiz "What value do you want to change it to? "
  delim:        .asciiz "\t"
  newLine:      .asciiz "\n"
  sum:          .asciiz "The summation of the values in the array is: "
  product:      .asciiz " the product of all values in the array is "
  empty:        .asciiz "\nNo more can be done because your array is empty.\nGood Bye!"

.text
.globl main
main:
  li $s6, 40          # initial array size
  li $s5, 40          # initial tempArr size
  li $s4, 4           # used to make arrays smaller
  la $t0, array       # Requesting values
  li $v0, 4           # load print string instruction
  la $a0, str1        # load the string into the argument register
  syscall
  ori $s0, $0, 0x0    # $s0 will hold the index of the min/max value of the array

  jal loop            # loop to populate the array
  jal menu            # menu method

  li $v0, 10          # end program if for some reason the program doesn't go
                      #   through the loops
  syscall

loop:
  beq $t1, $s6, exit  # loop until 40
  li $v0, 5           # recieving input
  syscall
  sw $v0, array($t1)  # store input in array
  addi $t1, $t1, 4    # increment loop index
  j loop

menu:
  ori $t0, $0, 0      # initialize the index to 0
  ori $t9, $0, 1      # set a comparable register to 1 for finding min
  beq $s6, $0, emptyArray
  ori $t1, $0, 0      # initialize the index to 0
  beq $t5, 1, replace       # if ( $t5 == 1 ) goto replace
  beq $t5, 2, removeMax     # if ( $t5 == 2 ) goto removeMax
  beq $t5, 3, removeMin     # if ( $t5 == 3 ) goto removeMin
  beq $t5, 4, computeValues # if ( $t5 == 4 ) goto computeValues
  li $v0, 4           # print string instruction to print the menu
  la $a0, newLine
  syscall
  la $a0, menu1
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
  li $v0, 5           # reading the input from the user
  syscall
  move $t5, $v0       # copy user input into register $t5
  j menu

replace:
  li $v0, 4           # print string to as for user input
  la $a0, replacePos  
  syscall
  li $v0, 5           # getting the position of the user wants to replace
  syscall
  move $t1, $v0       # move value into register $t1
  sub $t1, $t1, $t9   # subtract one from position because the array starts at 0
  add $t1, $t1, $t1   # double the index
  add $t1, $t1, $t1   # double the index again to make it ( 4 * $t1 )
  la $a0, replaceVal  # print the request string
  li $v0, 4
  syscall
  li $v0, 5
  syscall
  sw $v0, array($t1)  # save the user input in the array 
  ori $t1, $0, 0      # reset the $t1 register
  j printArray        # print the array

removeMax:
  sub $s5, $s5, $s4   # make tempArr smaller
  ori $t1, $0, 0      # initialize index $t1
  ori $s0, $0, 0      # maxIndex($s0) set to 0
  jal findMax         # findMax loop to find minIndex
  ori $t1, $0, 0      # initialize index $t1
  ori $t2, $0, 0      # initialize index $t1
  jal fillTemp        # loop to remove max from array
  ori $t1, $0, 0      # initialize index $t1
  ori $t2, $0, 0      # initialize index $t1
  sub $s6, $s6, $s4   # make array smaller
  jal refillArr       # array = temp
  ori $t1, $0, 0      # reset the $t1 register
  j printArray

findMax:
  beq $t1, $s6, exit  # loop until size of array
  lw $t3, array($t1)
  lw $t4, array($s0)
  slt $t2, $t4, $t3   # if ( array($s0) < array($t1) ) $t2 = 1
  beq $t2, $t9, setIndexMax   # if ( $t2 == 1 ) set maxIndex($s0) to $t1
  add $t1, $t1, $s4   # increment index
  j findMax
  
setIndexMax:
  or $s0, $0, $t1
  j findMax

removeMin:
  sub $s5, $s5, $s4   # make tempArr smaller
  ori $t1, $0, 0      # initialize index #t1
  ori $s0, $0, 0      # minIndex($s0) set to 0
  jal findMin         # findMin loop to find minIndex
  ori $t1, $0, 0      # initialize index #t1
  ori $t2, $0, 0      # initialize index #t1
  jal fillTemp        # loop to remove min from arrays
  ori $t1, $0, 0      # initialize index #t1
  ori $t2, $0, 0      # initialize index #t1
  sub $s6, $s6, $s4   # make array smaller
  jal refillArr
  ori $t1, $0, 0
  j printArray

findMin:
  beq $t1, $s6, exit  # loop until size of array
  lw $t3, array($t1)
  lw $t4, array($s0)
  slt $t2, $t3, $t4   # if ( array(#t1) < array($s0) ) $t2 = 1
  beq $t2, $t9, setIndexMin   # if ( $t2 == 1 ) set minIndex($s0) to $t1
  add $t1, $t1, $s4   # increment index
  j findMin

refillArr:
  beq $t1, $s6, exit  # loop array
  lw $t3, tempArr($t1)
  sw $t3, array($t1)  # copy into array
  add $t1, $t1, $s4   # increment index
  j refillArr

fillTemp:
  beq $t1, $s6, exit  # loop array
  lw $t3, array($t1)
  lw $t4, array($s0)
  beq $t3, $t4, skip  # if array(minIndex) == array(index) skip index
  lw $t3, array($t1)
  sw $t3, tempArr($t2)# copy into tempArr
  add $t1, $t1, $s4   # increment index
  add $t2, $t2, $s4
  j fillTemp

skip:
  add $t1, $t1, $s4   # increment the index by one
  j fillTemp

setIndexMin:
  or $s0, $0, $t1     # update the min index
  j findMin
  
computeValues:
  ori $t1, $0, 0      # initialize the index for loop
  ori $t6, $0, 0      # sum = 0
  ori $t7, $0, 1      # product = 1
  jal sumNProd
  la $a0, sum
  li $v0, 4
  syscall
  or $a0, $0, $t6
  li $v0, 1
  syscall
  la $a0, product
  li $v0, 4
  syscall
  or $a0, $0, $t7
  li $v0, 1
  syscall
  li $v0, 4
  la $a0, exitString
  syscall
  li $v0, 10
  syscall
  
sumNProd:
  beq $t1, $s6, exit  # loop the array
  lw $t3, array($t1)  
  add $t6, $t6, $t3   # sum += $t3
  mult $t7, $t3       # $lo = product * $t3
  mflo $t7            # product = $lo
  add $t1, $t1, $s4   # i += 4
  j sumNProd

printArray:
  beq $t1, $s6, menu  # if( #t1 == arraySize ) goto menu
  ori $t5, $0, 0
  lw $a0, array($t1)  # store input in array
  li $v0, 1
  syscall
  la $a0, delim
  li $v0, 4
  syscall
  addi $t1, $t1, 4    # increment loop index
  j printArray
  
emptyArray:
  li $v0, 4
  la $a0, empty
  syscall
  li $v0, 10
  syscall

exit: 
  jr $ra
