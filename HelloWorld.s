#Arellano Program 1
.data
str:  .asciiz "Hello world\n"
name: .asciiz "name: Josue Arellano\n"
game: .asciiz "game: Super Smash Bros.\n"
film: .asciiz "film: The Fellowship of the Ring\n"
song: .asciiz "song: Love Came In\n"
.text
.globl main
main:
      li $v0, 4       # $system call code for print_str
      la $a0, str     # $address of string to print
      syscall         # print the string
      la $a0, name
      syscall
      la $a0, game
      syscall
      la $a0, film
      syscall
      la $a0, song
      syscall

      li $v0, 1
      li $a0, 2
      li $a1, 5
      syscall
      syscall

      li $v0, 10
      syscall
.end
