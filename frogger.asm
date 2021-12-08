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
# - Milestone 1/2/3(choose the one that applies)
#
# Which approved additional features have been implemented?
# (See the assignment handout for the list of additional features)
# 1. Display the number of lives remaining.
# 2. (fill in the feature, if any)
# 3. (fill in the feature, if any)
# ... (add more if necessary)
#
# Any additional information that the TA needs to know:
# - To end the game click "q", this will stop the main loop
#
#####################################################################


.data
	displayAddress:	.word 0x10008000 # base address for display
	vF1: .space 512 # reserve memory for row 1 of vehicles
	vF2: .space 512 # reserve memory for row 2 of vehicles
	lF1: .space 512 # reserve memory for row 1 of logs
	lF2: .space 512 # reserve memory for row 2 of logs
	frogX: .word 16 # initial x-coordinate of the top left corner of the frog
	frogY: .word 28 # initial y-coordinate of the frog
	xConv: .word 4 # convert x-coordinate to bitmap display
	yConv: .word 128 # convert y-coordinate to bitmap display
	veh_starting_pt_1: .word 40 # starting position of vehicle/log colours in array
	veh_starting_pt_2: .word 0 # another starting position of vehicle/log colours in array
	log_starting_pt_1: .word 28
	log_starting_pt_2: .word 0
	rateDivider: .word 8
	lv_2_rateDivider: .word 0
	
	goal_region_list: .word 516, 540, 564, 588, 612 # pixel values of the top left corners 
	                                           #of each goal region from left to right

	fill_goal_region_list: .space 20	
	frog_lives: .word 3
	game_difficulty: 1
	number_of_frogs_lived: .word 0
	
	orange: .word 0xff8000 # frog colour
	yellow: .word 0xffff66 # vehicle colour
	blue: .word 0x66b2ff # water colour
	brown: .word 0x994c00 # log colour
	pink: .word 0xff99cc
	black: .word 0x000000
	red: .word 0xff3333
	purple: .word 0x4c0099 # safe region colour
	white: .word 0xffffff
	green: .word 0x00994c
		
.text
	
main:  
		
######## Draw Vehicles

######## First row of vehicles
# fill array with background colour
fillRoad1:
	la $t8, vF1 # load vehicle frame 1 address into t3
	addi $t2, $zero, 512 # t2 = 512
	add $t3, $zero, $zero # i = 0
	li $t5, 0x000000 # load black colour into t5
	jal fillArray # call function fillArray
	
# fill array with vehicle colour 			
fillCar:
	la $t8, vF1 # load vehicle frame 1 address into t3
	addi $t2, $zero, 512 # t2 = 512
	lw $t1, veh_starting_pt_1
	add $t3, $zero, $t1 # i = 20
			
outerLoop:
	bge $t3, $t2, paintCar1 # while i < 512
	addi $t0, $zero, 0 # initialize t0 = 0 as index i
	addi $t1, $zero, 24 # t1 =  to iterate 8 times
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
	lw $t1, veh_starting_pt_2
	add $t3, $zero, $t1 # i = 12
			
outerLoop2:
	bge $t3, $t2, paintCar2 # while i < 512
	addi $t0, $zero, 0 # initialize t0 = 0 as index i
	addi $t1, $zero, 24 # t1 =  to iterate 8 times
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
	
##### Draw Logs
######### First row of logs
fillWater1:
	la $t8, lF1 # load lF1 address into t3
	addi $t2, $zero, 512 # t2 = 512
	add $t3, $zero, $zero # i = 0
	li $t5, 0x66b2ff # load blue colour into t5
	jal fillArray # call function fillArray
	
# fill array with log colour 			
fillLog:
	la $t8, lF1 # load  vF1 address into t3
	addi $t2, $zero, 512 # t2 = 512
	lw $t1, log_starting_pt_1
	add $t3, $zero, $t1 # i = 20
			
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
	lw $t1, log_starting_pt_2
	add $t3, $zero, $t1 # i = 12
			
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

### Set up the background

# paint the goal region
	lw $t0, displayAddress # $t0 stores the base address for display
	lw $t1, blue # $t1 stores the blue colour code for cars
	lw $t2, green # $t2 stores the green colour code for the goal region
	lw $t3, brown # $t3 stores the brown colour code for logs
	lw $t4, purple # $t4 stores the purple colour code for safe and start region
	li $t5, 256 # specify the number of pixels to draw the goal region
	lw $t6, orange # orange colour for frog
	lw $t7, white # white colour for cars

	
drawGoalRegion:
	
	sw $t2, 0($t0) # paint the first (top-left) unit red.
	addi $t0, $t0, 4 # advance to the next pixel position
	addi $t5, $t5, -1 # decrement $t5 by 1
	bnez $t5, drawGoalRegion # keep drawing until $t5 is zero.

	addi $t3, $zero, 5
	addi $t0, $t0, -124
	lw $t7, green
	lw $t8, blue	
empty_goal_regions:
	
	jal draw_empty_goal_slot # decide later if wanna keep this
	
	addi $t0, $t0, -12
	jal fill_out_center
	
	addi $t0, $t0, 268
	addi $t3, $t3, -1
	bnez $t3, empty_goal_regions
	
	
	la $t1, fill_goal_region_list
	addi $t5, $zero, 5
	addi $t2, $zero, 0

# check if any frog is on the goal spots.	
fill_empty_goal_regions:

	add $t3, $t1, $t2
	lw $t4, 0($t3)
	bnez $t4, fill_out_slot 
	addi $t5, $t5, -1
	addi $t2, $t2, 4 
	bnez $t5, fill_empty_goal_regions
	
	j exit_fill_out_goal_regions
	
fill_out_slot:
	lw $t0, displayAddress
	lw $t6, black
	add $t0, $t0, $t4
	jal drawFrog
	
	addi $t5, $t5, -1
	addi $t2, $t2, 4
	j fill_empty_goal_regions

exit_fill_out_goal_regions:	
		
	lw $t0, displayAddress
	lw $t1, frog_lives
	lw $t2, red
	addi $t0, $t0, 4

draw_frog_lives:
	
	sw $t2, 0($t0)
	addi $t0, $t0, 8
	addi $t1, $t1, -1
	bnez $t1, draw_frog_lives

display_difficulty:
	lw $t0, displayAddress
	lw $t1, game_difficulty
	lw $t7, white
	addi $t2, $zero, 1
	beq $t1, $t2, drawOne
	jal numberTwo
	j exit_drawing_difficulty
	
drawOne:
	jal numberOne

exit_drawing_difficulty:	
	lw $t0, displayAddress
	addi $t0, $t0, 2048
	addi $t5, $zero, 256 # set length of pixels to 256
	lw $t4, purple
drawSafeRegion:

	sw $t4, 0($t0) # top left corner of the safe region
	addi $t0, $t0, 4 # advance to the next pixel position
	addi $t5, $t5, -1 # decrement $t5 by 1
	bnez $t5, drawSafeRegion
	
	lw $t0, displayAddress
	addi $t5, $zero, 128 # set length of pixels to 128
	addi $t0, $t0, 3584 # set the next starting pixel to 1024

# The road region is black, so will skip to drawing the starting region
	
drawStartingRegion:
	
	sw $t4, 0($t0) # top left corner of the starting region
	addi $t0, $t0, 4 # advance to the next pixel position
	addi $t5, $t5, -1 # decrement $t5 by 1
	bnez $t5, drawStartingRegion		
				
### Update function for game

# if input == w ===> moveUp
# if input == a ===> moveLeft
# if input == s ===> moveDown
# if input == d ===> moveRight
# if input == r ===> restart the game
# if input == q ===> quit game

# $t1 = user input
# 
gameLoop:

load_keyboard_input:
# check for keyboard input
	lw $t8, 0xffff0000  
	beq $t8, 1, keyboard_input
	beq $t8, 0, no_keyboard_input # if no key was pressed, branch to no_keyboard_input
	
keyboard_input:

	lw $t1, 0xffff0004 # load keyboard input
	
	# identify keyboard input by ASCII value
	beq $t1, 0x61, respond_to_a # if input == a branch to respond_to_a
	beq $t1, 0x77, respond_to_w # if input == w branch to respond_to_w
	beq $t1, 0x73, respond_to_s # if input == s branch to respond_to_s
	beq $t1, 0x64, respond_to_d # if input == d branch to respond_to_d
	beq $t1, 0x72, respond_to_r # if input == r branch to respond_to_r
	beq $t1, 0x71, respond_to_q # if input == q branch to respond_to_q
	
	j no_keyboard_input # if none of the above, branch to no_keyboard_input

respond_to_a:
	
	lw $t1, frogX # load current x-coor of frog	
	la $t8, frogX # load address of frogX
	addi $t1, $t1, -1 # moving left along the x axis
	
	# if reaches the leftmost screen, no more moving
	blt $t1, $zero, no_keyboard_input
	sw $t1, 0($t8) # update value in frogX
	
	j paintLog2 # repaint the screen

respond_to_w:
	
	lw $t1, frogY
	la $t8, frogY
	addi $t1, $t1, -4
	
	# if reaches the top of the screen, no more moving
	blt $t1, $zero, no_keyboard_input
	
	sw $t1, 0($t8)
	
	j paintLog2

respond_to_s:
	
	lw $t1, frogY
	la $t8, frogY
	addi $t1, $t1, 4
	
	# if reaches the bottom of the screen, no more moving
	bge $t1, 29, no_keyboard_input
	
	sw $t1, 0($t8)
	
	j paintLog2

respond_to_d:

	lw $t1, frogX # load current x-coor of frog
	la $t8, frogX # load address of frogX
	addi $t1, $t1, 1 # moving left along the x axis
	
	# if reaches the rightmost screen, no more moving to the right
	bge $t1, 29, no_keyboard_input 
	
	sw $t1, 0($t8) # update value in frogX
	
	j paintLog2 # repaint the screen

respond_to_r: # restart the game
	
	la $t8, frogX
	la $t9, frogY
	li $t1, 14 # initial value of frogX
	li $t2, 28 # initial value of frogY
	
	sw $t1, 0($t8) # set frogX = 14
	sw $t2, 0($t9) # set frogY = 28
	
	## reset frog lives if == 0
	lw $t3, frog_lives
	bnez $t3, paintLog2
	la $t4, frog_lives
	addi $t3, $zero, 3
	sw $t3, 0($t4) # reset to 3
	
	j paintLog2

respond_to_q:

	j Exit	

no_keyboard_input:

set_speed1:
	lw $t0, game_difficulty
	addi $t1, $zero, 2
	beq $t0, $t1, speed_up1
	lw $t3, rateDivider
	
	j moveLog1
speed_up1:
	lw $t3, lv_2_rateDivider	
moveLog1:		  
	la $t8, lF1 # load vF1 into t8
	addi $t0, $zero, 4 # second last pixel of the array
	addi $t1, $zero, 512
	lw $t9, 0($t8) # t9 = lF2[508]
	beqz $t3, log1_shift
	j drawLog1
	
log1_shift:
	jal shift_object_left

drawLog1:	
	la $t8, lF1 # load vF1 into t8
	lw $t9, displayAddress # load display address into t9
	addi $t1, $zero, 128 # t1 = 512
	addi $t9, $t9, 1024 # start drawing the pixel at 1024
	
	jal paintObj # paint one row of logs
	
	## update starting_pt_1
	la $t0, log_starting_pt_1
	lw $t1, log_starting_pt_1
	addi $t1, $t1, -4
	blt $t1, $zero, start_over_left_1
	sw $t1, 0($t0)

start_over_left_1:
	lw $t1, veh_starting_pt_1
	addi $t1, $zero, 32
	sw $t1, 0($t0)

set_speed2:
	lw $t3, rateDivider
	lw $t0, game_difficulty
	addi $t1, $zero, 2
	beq $t0, $t1, speed_up2
	
	j moveLog2
speed_up2:
	lw $t3, lv_2_rateDivider
	
moveLog2:
	#lw $t3, rateDivider
	la $t8, lF2 # load vF1 into t8
	addi $t0, $zero, 504 # second last pixel of the array
	lw $t9, 508($t8) # t9 = lF2[508]
	beqz $t3, log2_shift
	j drawLog2
	
log2_shift:
	jal shift_object_right

drawLog2:	
	la $t8, lF2 # load vF1 into t8
	lw $t9, displayAddress # load display address into t9
	addi $t1, $zero, 128 # t1 = 512
	addi $t9, $t9, 1536 # start drawing the pixel at 1536
	jal paintObj
	
	## update starting_pt_2
	la $t0, log_starting_pt_2
	lw $t1, log_starting_pt_2
	addi $t1, $t1, 4
	addi $t2, $zero, 32
	bge $t1, $t2, start_over_right_1
	sw $t1, 0($t0)


start_over_right_1:
	addi $t1, $zero, 0
	sw $t1, 0($t0)
	#j moveCar1

set_speed3:
	lw $t3, rateDivider
	lw $t0, game_difficulty
	addi $t1, $zero, 2
	beq $t0, $t1, speed_up3
	j moveCar1
speed_up3:
	lw $t3, lv_2_rateDivider
							
moveCar1:
	#lw $t3, rateDivider
	la $t8, vF1 # load vF1 into t8
	addi $t0, $zero, 4 # second last pixel of the array
	addi $t1, $zero, 512
	lw $t9, 0($t8) # t9 = lF2[508]
	beqz $t3, veh1_shift
	j drawVeh1
	
veh1_shift:
	jal shift_object_left 

drawVeh1:	
	la $t8, vF1 # load vF1 into t8
	lw $t9, displayAddress # load display address into t9
	addi $t1, $zero, 128 # t1 = 512
	addi $t9, $t9, 2560 # start drawing the pixel at 2560
	jal paintObj # paint one row of vehicles
	
	## update starting_pt_1
	la $t0, veh_starting_pt_1
	lw $t1, veh_starting_pt_1
	addi $t1, $t1, -4
	blt $t1, $zero, start_over_left
	sw $t1, 0($t0)

start_over_left:
	lw $t1, veh_starting_pt_1
	addi $t1, $zero, 36
	sw $t1, 0($t0)	

set_speed4:
	lw $t3, rateDivider
	lw $t0, game_difficulty
	addi $t1, $zero, 2
	beq $t0, $t1, speed_up4
	
	j moveCar2
speed_up4:
	lw $t3, lv_2_rateDivider
	
moveCar2:
	#lw $t3, rateDivider
	la $t8, vF2 # load vF1 into t8
	addi $t0, $zero, 504 # second last pixel of the array
	lw $t9, 508($t8) # t9 = lF2[508]
	beqz $t3, veh2_shift
	j drawVeh2

veh2_shift:
	jal shift_object_right

drawVeh2:	
	la $t8, vF2 # load vF1 into t8
	lw $t9, displayAddress # load display address into t9
	addi $t1, $zero, 128 # t1 = 512
	addi $t9, $t9, 3072
	jal paintObj
	
	## update starting_pt_2
	la $t0, veh_starting_pt_2
	lw $t1, veh_starting_pt_2
	addi $t1, $t1, 4
	addi $t2, $zero, 28
	bge $t1, $t2, start_over_right
	sw $t1, 0($t0)


start_over_right:
	addi $t1, $zero, 0
	sw $t1, 0($t0)
	##### frog
	# update rate divider
	addi $t2, $zero, 2
	lw $t5, game_difficulty
	beq $t5, $t2, check_lv_2_rateDivider
	la $t4, rateDivider
	lw $t3, rateDivider
	beqz $t3, reset_rateDivider
	
	j update_rateDivier
	
check_lv_2_rateDivider:
	
	la $t4, lv_2_rateDivider
	lw $t6, lv_2_rateDivider
	beqz $t6, reset_lv_2_rateDivider 
	
update_rateDivier:
	addi $t3, $t3, -1
	sw $t3, 0($t4)
	j frog

reset_rateDivider:

	addi $t3, $zero, 8
	la $t4, rateDivider
	sw $t3, 0($t4)
	
	j frog
	
reset_lv_2_rateDivider:	
	# reset lv_2_rateDivider
	addi $t1, $zero, 0
	la $t2, lv_2_rateDivider
	sw $t1, 0($t2)

	##### frog
frog:
	lw $t1, frogX # load xPos of frog into t1
	lw $t2, xConv # load xConv into t2
	lw $t4, frogY
	lw $t5, yConv	
	#lw $t0, displayAddress # load the display address into t0
	
	jal set_up_frog
	
	add $t7, $zero, $v0
	addi $t3, $zero, 1664  
	bge $t7, $t3, draw_frog # if t7 >= 1664, skip this step
	addi $t3, $zero, 1024
	blt $t7, $t3, draw_frog # elif t7 < 1024, skip this step
	
	lw $t8, displayAddress
	add $t2, $t8, $t7
	lw $t4, brown	
	addi $t5, $zero, 4  # i= 4

check_if_on_log:

	beqz $t5, exit_check_if_on_log # branch if i = 0
	addi $t1, $zero, 4 # j = 4
	
	check_row:	
	# check if the each row of frog covers brown pixels
		beqz $t1, exit_check_row
		lw $t3, 0($t2) # load colour
		bne $t3, $t4, draw_frog # check if t3 and t4 contain the same colour
		addi $t2, $t2, 4 # advance to the next pixel
		addi $t1, $t1, -1 # j = j - 1
		j check_row
		
	exit_check_row:	
		addi $t2, $t2, 112
		addi $t5, $t5, -1 # i = i - 1
		j check_if_on_log
		
exit_check_if_on_log:

	# now all pixels that will be covered by the frog are brown
	# meaning we are on a log!
	# Then we update frogX
	
set_speed5:
	lw $t3, rateDivider
	lw $t0, game_difficulty
	addi $t1, $zero, 2
	beq $t0, $t1, speed_up4
	
	j move_frog
speed_up5:
	lw $t3, lv_2_rateDivider

move_frog:	
	la $t0, frogX
	lw $t4, frogX
	lw $t1, frogY	
	# update frogX (frogY will stay the same)
	# check the direction of the log::
	
	bnez $t3, draw_frog
	addi $t2, $zero, 12
	blt $t1, $t2, move_to_left
	addi $t4, $t4, 1
	sw $t4, 0($t0) 
	
	j draw_frog
	
move_to_left:			
	addi $t4, $t4, -1
	sw $t4, 0($t0)
		
draw_frog:
	lw $t1, frogX # load xPos of frog into t1
	lw $t2, xConv # load xConv into t2
	lw $t4, frogY
	lw $t5, yConv	
	#lw $t0, displayAddress # load the display address into t0
	lw $t6, orange
	
	jal set_up_frog 
	
	lw $t1, displayAddress
	add $t1, $t1, $v0
	add $t0, $t1, $zero
	jal drawFrog

check_collisions:
#### detect collisions
# with vehicles
	
	lw $t1, frogX # current x coor of frog
	lw $t4, frogY # current y coor of frog
	jal set_up_frog # return the location of (x, y) on bitmap display
	# if (frogX, frogY) == yellow ==> collision!
	add $t2, $zero, $v0 # t2 = current (x,y) of frog on bitmap display
	
	# If (x,y) not in [2560, 3584), then frog is not in road region. 
	addi $t1, $zero, 2560
	blt $t2, $t1, detect_water_falling # branch to check if frog in in water region
	addi $t1, $zero, 3584
	bge $t2, $t1, no_collision
	
	# now, check if the left and right side of the frog has yellow pixel
	# if yes ==> collision!
	
	addi $t1, $zero, 512
	lw $t4, displayAddress
	add $t2, $t2, $t4
	addi $t3, $t2, 0 # start with a pixel on the left of (x,y)
	
check_left_car:	
	# first, check the left side
	lw $t4, 0($t3) # load the colour of that pixel
	lw $t5, yellow
	beq $t4, $t5, collision_detected
	addi $t3, $t3, 128
	addi $t1, $t1, -128
	bnez $t1, check_left_car
	
	addi $t1, $zero, 512
	addi $t3, $t2, 12 # a pixel on the right of the right side of frog
check_right_car:

	lw $t4, 0($t3) # load the colour of that pixel
	lw $t5, yellow
	beq $t4, $t5, collision_detected
	addi $t3, $t3, 128
	addi $t1, $t1, -128
	bnez $t1, check_right_car
	
	j no_collision
			
collision_detected:
	
	# frog lives minus 1
	la $t0, frog_lives
	lw $t1, frog_lives
	addi $t1, $t1, -1
	sw $t1, 0($t0)
	
	j respond_to_r # restart
	
detect_water_falling:
	
	#lw $t1, frogX # current x coor of frog
	#lw $t4, frogY # current y coor of frog
	#jal set_up_frog # return the location of (x, y) on bitmap display
	# if (frogX, frogY) == yellow ==> collision!
	#add $t2, $zero, $v0 # t2 = current (x,y) of frog on bitmap display
	
	# If (x,y) not in [2560, 3584), then frog is not in road region. 
	addi, $t1, $zero, 1024
	blt $t2, $t1, no_collision # branch to check if frog in in water region
	addi, $t1,  $zero, 2048
	bge $t2, $t1, no_collision
	
	addi $t1, $zero, 512
	lw $t4, displayAddress
	add $t2, $t2, $t4
	#addi $t3, $t2, -4 # start with a pixel on the left of (x,y)
	
### check 

check_left_side:	
	# first, check the left side
	lw $t4, 0($t2) # load the colour of that pixel
	lw $t5, blue
	beq $t4, $t5, falling_detected
	addi $t3, $t3, 128
	addi $t1, $t1, -128
	bnez $t1, check_left_side
	
	addi $t1, $zero, 512
	addi $t3, $t2, 12 # a pixel on the right of the right side of frog
	
check_right_side:

	lw $t4, 0($t3) # load the colour of that pixel
	lw $t5, blue
	beq $t4, $t5, falling_detected
	addi $t3, $t3, 128
	addi $t1, $t1, -128
	bnez $t1, check_right_side
	
	j no_collision

falling_detected:
	
	# frog lives minus 1
	la $t0, frog_lives
	lw $t1, frog_lives
	addi $t1, $t1, -1
	sw $t1, 0($t0)

	j respond_to_r # restart game

no_collision:
	# check if frogX == any element in goal_region_list
	addi $t0, $zero, 5 # i = 5
	la $t8, goal_region_list
	# load location of frog
	lw $t1, frogX
	lw $t2, xConv
	lw $t4, frogY
	lw $t5, yConv
	jal set_up_frog
	addi $t7, $v0, 0
	
	addi $t3, $zero, 0
	
	
check_if_in_goal_region:
	
	add $t6, $t8, $t3
	lw $t2, ($t6)
	beq $t2, $t7, record_success
	addi $t3, $t3, 4
	addi $t0, $t0, -1
	bnez, $t0, check_if_in_goal_region
	
	j sleep

record_success:

	la $t1, fill_goal_region_list
	add $t1, $t1, $t3
	sw $t7, 0($t1)
	
	# update number_of_frogs_lived
	# if 5 frogs has all survived, reset the list
	la $t2, number_of_frogs_lived
	lw $t0, number_of_frogs_lived
	addi $t0, $t0, 1
	addi $t5, $zero, 5
	beq $t0, $t5, upgrade_difficulty
	sw $t0, 0($t2)
	
	# otherwise, continue
	j respond_to_r

upgrade_difficulty:

	la $t1, fill_goal_region_list 
	jal reset_fill_goal_region_list
	
	la $t1, game_difficulty
	lw $t2, game_difficulty
	addi $t2, $t2, 1
	addi $t3, $zero, 2
	bgt $t2, $t3, win_state
	sw $t2, 0($t1)
	
	la $t0, number_of_frogs_lived
	sw $zero, 0($t0)
	
	j respond_to_r

win_state:
	j respond_to_q # end game	
	
sleep:				
### Sleep for 1 second before proceeding to the next line
	li $v0, 32 ### syscall sleep
	li $a0, 16 ### sleep for 1000 // 60 millisecond ~ 16 ms 
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
set_up_frog:
	# set up location on bitmap display
	mult $t1, $t2 # frogX * 4
	mflo $t3      # t3 = frogX * 4
	
	mult $t4, $t5 # frogY * 128
	mflo $t9      # t3 = frogY * 128
	
	add $t1, $t3, $t9 # t1 = frogX * 4 + frogY * 128
	#add $t0, $t0, $t1 # t0 = t1 + display address
	
	li $v0, 0 
	add $v0, $v0, $t1 # return value of this function
	jr $ra
	
drawFrog:
	
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
### shift value in an array to the right and wrap around
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
### shift value in an array to the left and wrap around
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

draw_empty_goal_slot:
	
	sw $t7, 0($t0)
	addi $t0, $t0, -128
	sw $t7, 0($t0)
	addi $t0, $t0, -128
	sw $t7, 0($t0)
	addi $t0, $t0, -128
	sw $t7, 0($t0)
	addi $t0, $t0, 4
	sw $t7, 0($t0)
	addi $t0, $t0, 4
	sw $t7, 0($t0)
	addi $t0, $t0, 4
	sw $t7, 0($t0)
	addi $t0, $t0, 4
	sw $t7, 0($t0)
	addi $t0, $t0, 128
	sw $t7, 0($t0)
	addi $t0, $t0, 128
	sw $t7, 0($t0)
	addi $t0, $t0, 128
	sw $t7, 0($t0)
		
	jr $ra

fill_out_center:
	
	sw $t8, 0($t0)
	addi $t0, $t0, 4
	sw $t8, 0($t0)
	addi $t0, $t0, 4
	sw $t8, 0($t0)
	addi $t0, $t0, -128
	sw $t8, 0($t0)
	addi $t0, $t0, -4
	sw $t8, 0($t0)
	addi $t0, $t0, -4
	sw $t8, 0($t0)
	addi $t0, $t0, -128
	sw $t8, 0($t0)
	addi $t0, $t0, 4
	sw $t8, 0($t0)
	addi $t0, $t0, 4
	sw $t8, 0($t0)
	
	jr $ra

numberOne:	
# t0 = displayAdress, t7 = colour

	addi $t0, $t0, 116
	sw $t7, 0($t0)
	addi $t0, $t0, 4
	sw $t7, 0($t0)
	addi $t0, $t0, 128
	sw $t7, 0($t0)
	addi $t0, $t0, 128
	sw $t7, 0($t0)
	addi $t0, $t0, 128
	sw $t7, 0($t0)
	addi $t0, $t0, -4
	sw $t7, 0($t0)
	addi $t0, $t0, 8
	sw $t7, 0($t0)
	
	jr $ra

numberTwo:	
	addi $t0, $t0, 116
	sw $t7, 0($t0)
	addi $t0, $t0, 4
	sw $t7, 0($t0)
	addi $t0, $t0, 4
	sw $t7, 0($t0)
	addi $t0, $t0, 128
	sw $t7, 0($t0)
	addi $t0, $t0, 128
	sw $t7, 0($t0)
	addi $t0, $t0, -4
	sw $t7, 0($t0)
	addi $t0, $t0, -4
	sw $t7, 0($t0)
	addi $t0, $t0, 128
	sw $t7, 0($t0)
	addi $t0, $t0, 128
	sw $t7, 0($t0)
	addi $t0, $t0, 4
	sw $t7, 0($t0)
	addi $t0, $t0, 4
	sw $t7, 0($t0)
	
	jr $ra

reset_fill_goal_region_list:
	
	sw $zero, 0($t1)
	sw $zero, 4($t1)
	sw $zero, 8($t1)
	sw $zero, 12($t1)
	sw $zero, 16($t1)
	
	jr $ra
