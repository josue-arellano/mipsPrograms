.text
.globl main
main: ori $8, $0, 0x0fa5
      ori $10, $8, 0x368f
      li $v0 10
      syscall
