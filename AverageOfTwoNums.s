.data
str1: .asciiz "Please enter an integer: "
str2: .asciiz "Please enter another integer: "
str3: .asciiz "The average of your numbers is: "
d1:   .word 5
.text
.globl main
main:
#requesting and storing user input
  li $v0, 4
  la $a0, str1
  syscall
  li $v0, 5
  syscall
  move $s0, $v0

#requesting and storing user input
  li $v0, 4
  la $a0, str2
  syscall
  li $v0, 5
  syscall
  move $s1, $v0

#requesting and storing user input
  li $v0, 4
  la $a0, str2
  syscall
  li $v0, 5
  syscall
  move $s2, $v0

#requesting and storing user input
  li $v0, 4
  la $a0, str2
  syscall
  li $v0, 5
  syscall
  move $s3, $v0

#requesting and storing user input
  li $v0, 4
  la $a0, str2
  syscall
  li $v0, 5
  syscall
  move $s4, $v0

#adding and storing numbers
  add $s5, $s0, $s1
  add $s5, $s5, $s2
  add $s5, $s5, $s3
  add $s5, $s5, $s4

#diving the sum by 5
  li $t1, 5
  div $s5, $t1
  mflo $s6

#printing the sum
  li $v0, 4
  la $a0, str3
  syscall
  li $v0, 1
  move $a0, $s6
  syscall

  li $v0, 10
  syscall
.end
