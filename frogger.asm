#####################################################################
#
# CSC258H5S Fall 2021 Assembly Final Project
# University of Toronto, St. George
#
# Student: Yefan Jiang, Student Number: 1005507211
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8
# - Unit height in pixels: 8
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestone is reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone 1 (choose the one that applies)
#
# Which approved additional features have been implemented?
# (See the assignment handout for the list of additional features)
# 1. (fill in the feature, if any)
# 2. (fill in the feature, if any)
# 3. (fill in the feature, if any)
# ... (add more if necessary)
#
# Any additional information that the TA needs to know:
# - (write here, if any)
#
#####################################################################


.data
	displayAddress:	.word 0x10008000 # base address for display
	vF1: .space 512 # reserve memory for row 1 of vehicles
	vF2: .space 512 # reserve memory for row 2 of vehicles
	lF1: .space 512 # reserve memory for row 1 of logs
	lF2: .space 512 # reserve memory for row 2 of logs
	frogX: .word 14 # initial x-coordinate of the top left corner of the frog
	frogY: .word 28 # initial y-coordinate of the frog
	xConv: .word 4 # convert x-coordinate to bitmap display
	yConv: .word 128 # convert y-coordinate to bitmap display
	
	orange: .word 0xff8000 # orange colour
		
.text
	
main: 
	
### Set up the background

# paint the goal region
	lw $t0, displayAddress # $t0 stores the base address for display
	li $t1, 0x66b2ff # $t1 stores the blue colour code for cars
	li $t2, 0x00994c # $t2 stores the green colour code for the goal region
	li $t3, 0x994c00 # $t3 stores the brown colour code for logs
	li $t4, 0x4c0099 # $t4 stores the purple colour code for safe and start region
	li $t5, 256 # specify the number of pixels to draw the goal region
	li $t6, 0xff8000 # orange colour for frog
	li $t7, 0xffffff # white colour for cars

	
drawGoalRegion:
	
	sw $t2, 0($t0) # paint the first (top-left) unit red.
	addi $t0, $t0, 4 # advance to the next pixel position
	addi $t5, $t5, -1 # decrement $t5 by 1
	bnez $t5, drawGoalRegion # keep drawing until $t5 is zero.
	
	addi $t5, $zero, 256 # set length of pixels to 256

drawWaterRegion:
	 
	sw $t1, 0($t0) # start painting the water region right beneath the goal region
	addi $t0, $t0, 4 # advance to the next pixel position
	addi $t5, $t5, -1 # decrement $t5 by 1
	bnez $t5, drawWaterRegion # keep drawing until $t5 is zero.
	
	addi $t5, $zero, 128 # set length of pixels to 128
	
drawSafeRegion:

	sw $t4, 0($t0) # top left corner of the safe region
	addi $t0, $t0, 4 # advance to the next pixel position
	addi $t5, $t5, -1 # decrement $t5 by 1
	bnez $t5, drawSafeRegion
	
	addi $t5, $zero, 128 # set length of pixels to 128
	addi $t0, $t0, 1024 # set the next starting pixel to 1024

# The road region is black, so will skip to drawing the starting region
	

drawStartingRegion:
	
	sw $t4, 0($t0) # top left corner of the starting region
	addi $t0, $t0, 4 # advance to the next pixel position
	addi $t5, $t5, -1 # decrement $t5 by 1
	bnez $t5, drawStartingRegion	
	
######## Draw Vehicles

######## First row of vehicles
# fill array with background colour
fillRoad1:
	la $t8, vF1 # load vehicle frame 1 address into t3
	addi $t2, $zero, 512 # t2 = 512
	add $t3, $zero, $zero # i = 20
	li $t5, 0x000000 # load black colour into t5
	jal fillArray # call function fillArray
	
# fill array with vehicle colour 			
fillCar:
	la $t8, vF1 # load vehicle frame 1 address into t3
	addi $t2, $zero, 512 # t2 = 512
	addi $t3, $zero, 20 # i = 20
			
outerLoop:
	bge $t3, $t2, paintCar1 # while i < 512
	addi $t0, $zero, 0 # initialize t0 = 0 as index i
	addi $t1, $zero, 36 # t1 =  to iterate 8 times
	add $t4, $t8, $t3 # hold address for vF1[i]
	li $t5, 0xffff66 # load yellow colour into t5
innerLoop:
	bge $t0, $t1, endInner # for j < 32
	add $t6, $t4, $t0 # hold address for vF1[i+j]
	sw $t5, 0($t6) # vF1[i+j] = t5
	addi $t0, $t0, 4 # update offset in t0
	j innerLoop
endInner:
	addi $t3, $t3, 64 # update t3 by 64
	j outerLoop # jump back to outerloop

paintCar1:		
	la $t8, vF1 # load vF1 into t8
	lw $t9, displayAddress # load display address into t9
	addi $t1, $zero, 128 # t1 = 512
	addi $t9, $t9, 2560 # start drawing the pixel at 2560
	jal paintObj # paint one row of vehicles

######## Second row of vehicles

fillRoad2:
	la $t8, vF2 # load vehicle frame 1 address into t3
	addi $t2, $zero, 512 # t2 = 512
	add $t3, $zero, $zero # i = 20
	li $t5, 0x000000 # load black colour into t5
	jal fillArray # call function fillArray
	
fillCar2:
	la $t8, vF2 # load vehicle frame 1 address into t3
	addi $t2, $zero, 512 # t2 = 512
	addi $t3, $zero, 12 # i = 20
			
outerLoop2:
	bge $t3, $t2, paintCar2 # while i < 512
	addi $t0, $zero, 0 # initialize t0 = 0 as index i
	addi $t1, $zero, 36 # t1 =  to iterate 8 times
	add $t4, $t8, $t3 # hold address for vF1[i]
	li $t5, 0xffff66 # load yellow colour into t5
innerLoop2:
	bge $t0, $t1, endInner2 # for j < 32
	add $t6, $t4, $t0 # hold address for vF1[i+j]
	sw $t5, 0($t6) # vF1[i+j] = t5
	addi $t0, $t0, 4 # update offset in t0
	j innerLoop2
endInner2:
	addi $t3, $t3, 64 # update t3 by 64
	j outerLoop2 # jump back to outerloop

paintCar2:
	la $t8, vF2 # load vF1 into t8
	lw $t9, displayAddress # load display address into t9
	addi $t1, $zero, 128 # t1 = 512
	addi $t9, $t9, 3072 # start drawing the pixel at 2560
	jal paintObj # paint one row of vehicles

##### Draw Logs
######### First row of logs
fillWater1:
	la $t8, lF1 # load lF1 address into t3
	addi $t2, $zero, 512 # t2 = 512
	add $t3, $zero, $zero # i = 20
	li $t5, 0x66b2ff # load blue colour into t5
	jal fillArray # call function fillArray
	
# fill array with log colour 			
fillLog:
	la $t8, lF1 # load  vF1 address into t3
	addi $t2, $zero, 512 # t2 = 512
	addi $t3, $zero, 20 # i = 20
			
outerLoop3:
	bge $t3, $t2, paintLog1 # while i < 512
	addi $t0, $zero, 0 # initialize t0 = 0 as index i
	addi $t1, $zero, 36 # t1 =  to iterate 9 times
	add $t4, $t8, $t3 # hold address for vF1[i]
	li $t5, 0x994c00 # load brown colour into t5
innerLoop3:
	bge $t0, $t1, endInner3 # for j < 36
	add $t6, $t4, $t0 # hold address for vF1[i+j]
	sw $t5, 0($t6) # vF1[i+j] = t5
	addi $t0, $t0, 4 # update offset in t0
	j innerLoop3
endInner3:
	addi $t3, $t3, 64 # update t3 by 64
	j outerLoop3 # jump back to outerloop

paintLog1:		
	la $t8, lF1 # load vF1 into t8
	lw $t9, displayAddress # load display address into t9
	addi $t1, $zero, 128 # t1 = 512
	addi $t9, $t9, 1024 # start drawing the pixel at 1024
	jal paintObj # paint one row of logs

######### Second row of logs
fillWater2:
	la $t8, lF2 # load lF1 address into t3
	addi $t2, $zero, 512 # t2 = 512
	add $t3, $zero, $zero # i = 0
	li $t5, 0x66b2ff # load blue colour into t5
	jal fillArray # call function fillArray
	
fillLog2:
	la $t8, lF2 # load  lF2 address into t3
	addi $t2, $zero, 512 # t2 = 512
	addi $t3, $zero, 12 # i = 12
			
outerLoop4:
	bge $t3, $t2, paintLog2 # while i < 512
	addi $t0, $zero, 0 # initialize t0 = 0 as index i
	addi $t1, $zero, 36 # t1 =  to iterate 9 times
	add $t4, $t8, $t3 # hold address for vF1[i]
	li $t5, 0x994c00 # load brown colour into t5
innerLoop4:
	bge $t0, $t1, endInner4 # for j < 36
	add $t6, $t4, $t0 # hold address for vF1[i+j]
	sw $t5, 0($t6) # vF1[i+j] = t5
	addi $t0, $t0, 4 # update offset in t0
	j innerLoop4
endInner4:
	addi $t3, $t3, 64 # update t3 by 64
	j outerLoop4 # jump back to outerloop

paintLog2:		
	la $t8, lF2 # load vF1 into t8
	lw $t9, displayAddress # load display address into t9
	addi $t1, $zero, 128 # t1 = 512
	addi $t9, $t9, 1536 # start drawing the pixel at 1536
	jal paintObj # paint one row of logs


## set up the initial location of frog
	lw $t1, frogX # load xPos of frog into t1
	lw $t2, xConv # load xConv into t2
	lw $t4, frogY
	lw $t5, yConv	
	lw $t0, displayAddress # load the display address into t0
	lw $t6, orange
paintFrog:
	
	jal drawFrog
				
### Update function for game

# if input == w ===> moveUp
# if input == a ===> moveLeft
# if input == s ===> moveDown
# if input == d ===> moveRight

# $t1 = user input
# 
gameLoop:

# check for keyboard input
	lw $t8, 0xffff0000  
	beq $t8, 1, keyboard_input
	beq $t8, 0, moveCar1 # if no key was pressed, branch to no_keyboard_input
	
keyboard_input:

	lw $t1, 0xffff0004 # load keyboard input
	
	# identify keyboard input by ASCII value
	beq $t1, 0x61, respond_to_a # if input == a branch to respond_to_a
	beq $t1, 0x77, respond_to_w # if input == w branch to respond_to_w
	beq $t1, 0x73, respond_to_s # if input == s branch to respond_to_s
	beq $t1, 0x64, respond_to_d # if input == d branch to respond_to_d

respond_to_a:
	
	lw $t1, frogX # load current x-coor of frog
	la $t8, frogX # load address of frogX
	addi $t1, $t1, -1 # moving left along the x axis
	sw $t1, 0($t8) # update value in frogX
	
	j main # repaint the screen

respond_to_w:
	
	lw $t1, frogY
	la $t8, frogY
	addi $t1, $t1, -1
	sw $t1, 0($t8)
	
	j main

respond_to_s:
	
	lw $t1, frogY
	la $t8, frogY
	addi $t1, $t1, 1
	sw $t1, 0($t8)
	
	j main

respond_to_d:

	lw $t1, frogX # load current x-coor of frog
	la $t8, frogX # load address of frogX
	addi $t1, $t1, 1 # moving left along the x axis
	sw $t1, 0($t8) # update value in frogX
	
	j main # repaint the screen
						
moveCar1:
	la $t8, vF1 # load vF1 into t8
	addi $t0, $zero, 4 # second last pixel of the array
	addi $t1, $zero, 512
	lw $t9, 0($t8) # t9 = lF2[508]
	jal shift_object_left 
	
	la $t8, vF1 # load vF1 into t8
	lw $t9, displayAddress # load display address into t9
	addi $t1, $zero, 128 # t1 = 512
	addi $t9, $t9, 2560 # start drawing the pixel at 2560
	jal paintObj # paint one row of vehicles

moveCar2:
	la $t8, vF2 # load vF1 into t8
	addi $t0, $zero, 504 # second last pixel of the array
	lw $t9, 508($t8) # t9 = lF2[508]
	
	jal shift_object_right
	
	la $t8, vF2 # load vF1 into t8
	lw $t9, displayAddress # load display address into t9
	addi $t1, $zero, 128 # t1 = 512
	addi $t9, $t9, 3072
	jal paintObj

moveLog1:
	la $t8, lF1 # load vF1 into t8
	addi $t0, $zero, 4 # second last pixel of the array
	addi $t1, $zero, 512
	lw $t9, 0($t8) # t9 = lF2[508]
	jal shift_object_left
	
	la $t8, lF1 # load vF1 into t8
	lw $t9, displayAddress # load display address into t9
	addi $t1, $zero, 128 # t1 = 512
	addi $t9, $t9, 1024 # start drawing the pixel at 1024
	jal paintObj # paint one row of logs

moveLog2:
	la $t8, lF2 # load vF1 into t8
	addi $t0, $zero, 504 # second last pixel of the array
	lw $t9, 508($t8) # t9 = lF2[508]
	
	jal shift_object_right
	
	la $t8, lF2 # load vF1 into t8
	lw $t9, displayAddress # load display address into t9
	addi $t1, $zero, 128 # t1 = 512
	addi $t9, $t9, 1536 # start drawing the pixel at 1536
	jal paintObj
				
### Sleep for 1 second before proceeding to the next line
	li $v0, 32 ### syscall sleep
	li $a0, 16 ### sleep for 1000 // 16 millisecond ~ 16 ms 
	syscall
	
	j end_game_loop
	
end_game_loop:
	j gameLoop # loop back to beginning
		
Exit:
	li $v0, 10 # terminate the program gracefully
	syscall
	
##################################################################################
################### HELPER FUNCTIONS
		
#### A loop that fill an array with values
#### t3: current index
#### t2: number of iterations
#### t5: value that will be stored into this array		
fillArray:
	bge $t3, $t2, endFA # while t3 < t2
	add $t4, $t3, $t8 
	sw $t5, 0($t4) 
	addi $t3, $t3, 4
	j fillArray
	
endFA:
	jr $ra
	

#### Assign colours to bitmap display
#### t8: one array
#### t9: another array	
paintObj:	
	lw $t2, 0($t8) # load value stored at t8[i]
	sw $t2, 0($t9) # store the value into t9[i]
	addi $t8, $t8, 4 # advance to the next value in the array
	addi $t9, $t9, 4 # advance to the next pixel value
	addi $t1, $t1, -1 # decrement t1 by 1
	bnez $t1, paintObj # keep executing until t1 = 0
	jr $ra	

##############################################################################
	
##############################################################################
drawFrog:
	# set up location on bitmap display
	mult $t1, $t2 # frogX * 4
	mflo $t3      # t3 = frogX * 4
	
	mult $t4, $t5 # frogY * 128
	mflo $t9      # t3 = frogY * 128
	
	add $t1, $t3, $t9 # t1 = frogX * 4 + frogY * 128
	add $t0, $t0, $t1 # t0 = t1 + display address
	
	sw $t6, 0($t0) # orange color stored at the location on the bitmap display
	addi $t0, $t0, 128 # switch to the next row right below
	sw $t6, 0($t0) # draw a pixel
	addi $t0, $t0, 4 # locate a pixel right next to the previous one
	sw $t6, 0($t0)
	addi $t0, $t0, 128 # switch to the next row right below
	sw $t6, 0($t0)
	addi $t0, $t0, 124 # switch to the next row then one pixel to the left
	sw $t6, 0($t0)	
	# draw 3 more pixels in a row as the bottom of the frog
	addi $t0, $t0, 4
	sw $t6, 0($t0)
	addi $t0, $t0, 4
	sw $t6, 0($t0)
	addi $t0, $t0, 4 
	sw $t6, 0($t0)	
	# finish the other half of the frog
	addi $t0, $t0, -132 # go back to the second bottom row
	sw $t6, 0($t0)
	addi $t0, $t0, -128 # switch to the row above
	sw $t6, 0($t0)
	addi $t0, $t0, 4 # advance to the next pixel
	sw $t6, 0($t0)
	addi $t0, $t0, -128 # switch to the row above
	sw $t6, 0($t0)
	
	jr $ra 
#######################################################################
shift_object_right:
	
	bltz $t0, wrap_around_right_zero # if t0 < 0 branch to wrap_around_right_zero
	beq $t0, 124, wrap_around_right # else if t0 = 124 branch to wrap_around_right
 	beq $t0, 252, wrap_around_right # or if t0 = 252 
 	beq $t0, 380, wrap_around_right # or if t0 = 380
 	
	add $t2, $t8, $t0
	lw $t3, 0($t2)
	addi $t2, $t2, 4 # shift one pixel to the right
	sw $t3, 0($t2)
	addi $t0, $t0, -4	
	 
	j shift_object_right

wrap_around_right:

 	add $t2, $t8, $t0 
 	addi $t2, $t2, 4
 	sw $t9, 0($t2)
 
 	addi $t2, $t2, -4
 	lw $t9, 0($t2)
 	addi $t0, $t0, -4
 	
 	j shift_object_right	
	
wrap_around_right_zero:

	add $t2, $t8, $t0
	addi $t2, $t2, 4
	sw $t9, 0($t2)
	
	jr $ra

#########################################################################
shift_object_left:
	
	bge $t0, $t1, wrap_around_left_zero # if t0 < 0 branch to wrap_around_right_zero
	beq $t0, 384, wrap_around_left # or if t0 = 380
	beq $t0, 128, wrap_around_left # else if t0 = 124 branch to wrap_around_right
 	beq $t0, 256, wrap_around_left # or if t0 = 252 
 		
	add $t2, $t8, $t0
	lw $t3, 0($t2)
	addi $t2, $t2, -4 # shift one pixel to the left
	sw $t3, 0($t2)
	addi $t0, $t0, 4	
	 
	j shift_object_left

wrap_around_left:

 	add $t2, $t8, $t0 
 	addi $t2, $t2, -4
 	sw $t9, 0($t2)
 
 	addi $t2, $t2, 4
 	lw $t9, 0($t2)
 	addi $t0, $t0, 4
 	
 	j shift_object_left	
	
wrap_around_left_zero:

	add $t2, $t8, $t0
	addi $t2, $t2, -4
	sw $t9, 0($t2)
	
	jr $ra	

