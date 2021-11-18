# Demo for painting## Bitmap Display Configuration:
# - Unit width in pixels: 8# - Unit height in pixels: 8
# - Display width in pixels: 256# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
#
.data
	displayAddress:	.word 0x10008000
.text
	lw $t0, displayAddress # $t0 stores the base address for displayli $t1, 0xff0000
	li $t1, 0xff0000 # $t1 stores the red colour codeli $t2, 0x00ff00
	li $t2, 0x00ff00 # $t2 stores the green colour codeli $t3, 0x0000ff
	li $t3, 0x0000ff # $t3 stores the blue colour codesw $t1, 0($t0)
	
	sw $t1, 0($t0) # paint the first (top-left) unit red.sw $t2, 4($t0)
	sw $t2, 4($t0) # paint the second unit on the first row green. Why$t0+4?sw $t3, 128($t0) 
	sw $t3, 128($t0) # paint the first unit on the second row blue. Why +128?Exit:li $v0, 10 
Exit:
	li $v0, 10 # terminate the program gracefullysyscall
	syscall