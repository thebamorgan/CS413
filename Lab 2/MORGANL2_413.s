@ Filename: MORGANL2_413.s
@ Author:   Ben Morgan
@ Email:    bam0043@uah.edu
@ Term:     CS413-01 2023
@ Purpose:
@ Write an ARM Assembly program that will calculate the area of the following four plane shapes:
@ a)	Triangle 0.5 * b * h
@ b)	Rectangle  w * h
@ c)	Trapezoid (a+b) * h/2
@ d)	Square  s^2


@ Use these commands to assemble, link, run and debug this program:
@    as -o MORGANL2_413.o MORGANL2_413.s
@    gcc -o MORGANL2_413 MORGANL2_413.o
@    ./MORGANL2_413 ;echo $?
@    gdb --args ./MORGANL2_413

.equ READERROR, 0
.global main

main:
    ldr r0, = welcomeStr
    bl printf

    ldr r0, = numPattern @Used to take a number input from the user
    ldr r1, = numInput
    bl scanf

    ldr r1, = numInput
    ldr r1, [r1]

    cmp r1, #1 @If the user inputed a 1, take them to the triangle label to calculate area
    beq tri 

    cmp r1, #2 @If the user inputed a 2, take them to the rectangle label to calculate area
    beq rct

    cmp r1, #3 @If the user inputed a 3, take them to the trapezoid label to calculate area
    beq trp

    cmp r1, #4 @If the user inputed a 4, take them to the square label to calculate area
    beq sqr

    cmp r1, #5 @If the user inputed a 5, exit the program
    beq exit

    b reject @ If the user enters a number that is not 1-5 or is a character, break to an invalid input message to prompt them to enter a valid input

    b exit

reject: @Tell the user the input was invalid and branch back to the relevant branch 

    ldr r0, = rejectMessage 
    bl printf

    ldr r0, = strInputPattern
    ldr r1, = strInputError
    bl scanf

    b main

triErr: @If there was an error in the input tell them it was wrong and branch to let them enter again

    ldr r0, = rejectMessage
    bl printf

    ldr r0, = strInputPattern
    ldr r1, = strInputError
    bl scanf

    b tri

triOver: @ If there was an overflow error in the calculation, let the user know and branch back to let them try again
    ldr r0, = overErr
    bl printf

tri: @(1/2) * b * h
    ldr r0, = triangle @Tell user what shape they picked
    bl printf

    ldr r0, = height
    bl printf

    ldr r0, = numPattern @Used to take a number input from the user
    ldr r1, = numInput
    bl scanf

    cmp r0, #READERROR
    beq triErr
    
    ldr r1, = numInput
    ldr r1, [r1]
    mov r5, r1 @Store the height value for calculation

    ldr r0, =base
    bl printf

    ldr r0, = numPattern @Used to take a number input from the user
    ldr r1, = numInput
    bl scanf

    cmp r0, #READERROR
    beq triErr

    ldr r1, = numInput
    ldr r1, [r1]
    mov r6, r1 @Store the base value for calculation
    
    umull r8, r7, r5, r6 @Multiply b*h and check for overflow

    mov r1, r8 @Store result of multiplication 
    mov r1, r1, asr #1 @Divides by 2
    ldr r0, =numPrint

    cmp r7, #0 @ Compare r7 to 0 to see if there was an overflow
    bne triOver

    bl printf
    b again @Branch to prompt asking if they want to do another calculation

rctErr: @If there was an error in the input tell them it was wrong and branch to let them enter again

    ldr r0, = rejectMessage
    bl printf

    ldr r0, = strInputPattern
    ldr r1, = strInputError
    bl scanf

    b rct

rctOver: @ If there was an overflow error in the calculation, let the user know and branch back to let them try again
    ldr r0, = overErr
    bl printf

rct: @w*h

    ldr r0, = rectangle @Tell user what shape they picked
    bl printf

    ldr r0, = width
    bl printf

    ldr r0, = numPattern @Used to take a number input from the user
    ldr r1, = numInput
    bl scanf

    cmp r0, #READERROR
    beq rctErr

    ldr r1, = numInput
    ldr r5,[r1] @Store width for calculation

    ldr r0, = height
    bl printf

    ldr r0, = numPattern @Used to take a number input from the user
    ldr r1, = numInput
    bl scanf

    ldr r1, = numInput
    ldr r6,[r1] @Store height for calculation

    umull r8, r7, r5, r6 @Multiply w*h and check for overflow
    mov r1, r8
    ldr r0, =numPrint

    cmp r7, #0 @ Compare r7 to 0 to see if there was an overflow 
    bne rctOver
    
    bl printf
    b again @Branch to prompt asking if they want to do another calculation

trpErr: @If there was an error in the input tell them it was wrong and branch to let them enter again

    ldr r0, = rejectMessage
    bl printf

    ldr r0, = strInputPattern
    ldr r1, = strInputError
    bl scanf

    b trp

trpOver: @ If there was an overflow error in the calculation, let the user know and branch back to let them try again
    ldr r0, = overErr
    bl printf

trp: @(1/2) * (a+b) * h
    ldr r0, = trapezoid @Tell user what shape they picked
    bl printf

    ldr r0, = base
    bl printf

    ldr r0, = numPattern
    ldr r1, = numInput
    bl scanf

    cmp r0, #READERROR
    beq trpErr

    ldr r1, = numInput
    ldr r6, [r1] @Store the first base for calculation

    ldr r0, = base2
    bl printf

    ldr r0, = numPattern
    ldr r1, = numInput
    bl scanf

    cmp r0, #READERROR
    beq trpErr

    ldr r1, = numInput
    ldr r3, [r1] @Store the second base for calculation

    add r4, r6, r3 @ (a+b)
    mov r4, r4, asr #1 @ (a+b) * (1/2)
    
    ldr r0, = height
    bl printf

    ldr r0, = numPattern
    ldr r1, = numInput
    bl scanf

    cmp r0, #READERROR
    beq trpErr

    ldr r1, = numInput
    ldr r5, [r1] @Store the height for calculation

    umull r8, r7, r4, r5 @(a+b) * (1/2) * h
    mov r1, r8
    ldr r0, = numPrint

    cmp r7, #0 @ Compare r7 to 0 to see if there was an overflow
    bne trpOver

    bl printf
    b again @Branch to prompt asking if they want to do another calculation

sqrErr:  @If there was an error in the input tell them it was wrong and branch to let them enter again

    ldr r0, = rejectMessage
    bl printf

    ldr r0, = strInputPattern
    ldr r1, = strInputError
    bl scanf

    b sqr

sqrOver: @ If there was an overflow error in the calculation, let the user know and branch back to let them try again
    ldr r0, = overErr
    bl printf
    
sqr: @s^2

    ldr r0, = square @Tell user what shape they picked
    bl printf

    ldr r0, = side
    bl printf

    ldr r0, = numPattern @Used to take a number input from the user
    ldr r1, = numInput
    bl scanf
    @cmp for valid input
    cmp r0, #READERROR
    beq sqrErr
    
    ldr r1, = numInput
    ldr r1,[r1] @Store side for calculation

    umull r8, r7, r1, r1 @s^2
    mov r1, r8
    ldr r0, =numPrint
    
    cmp r7, #0 @ Compare r7 to 0 to see if there was an overflow
    bne sqrOver

    bl printf
    b again @Branch to prompt asking if they want to do another calculation

againErr: @If there was an error in the input tell them it was wrong and branch to let them enter again
    ldr r0, = rejectMessage
    bl printf

again: @Ask the user if they want to do another calculation
    ldr r0, =survey
    bl printf

    ldr r0, = numPattern @Used to take a number input from the user
    ldr r1, = numInput
    bl scanf
    
    cmp r0, #READERROR 
    beq againErr

    ldr r1, = numInput
    ldr r1, [r1]

    cmp r1, #1 @Check if user wants to coninue the program
    beq main

    cmp r1, #2 @Check if user wants to stop the program
    beq exit

    b againErr

exit:
    
    mov r7, #0x01 @ Satisfies 5
    svc 0

.data
@Statement/prompt strings
.balign 4
survey: .asciz "Would you like to make another calculation? 1 for yes or 2 for no.\n"

.balign 4
rejectMessage: .asciz "Invalid input, try again.\n"

.balign 4
overErr: .asciz "There was an overflow error, try again.\n"

.balign 4
welcomeStr: .asciz "This program will calculate the area of a given shape. Please enter 1 for triangle, 2 for rectangle, 3 for trapezoid, 4 for square, or 5 to exit.\n" 

.balign 4
triangle: .asciz "You have selected triangle\n\n"

.balign 4
rectangle: .asciz "You have selected rectangle\n\n"

.balign 4
trapezoid: .asciz "You have selected trapezoid\n\n"

.balign 4
square: .asciz "You have selected square\n\n"

.balign 4
numPrint: .asciz "The calculated area is: %d\n"

@Area for asking the user what values they want with their calculation
.balign 4
height: .asciz "Please enter the height value:\n"

.balign 4
base: .asciz "Please enter the base value:\n"

.balign 4
base2: .asciz "Please enter the other base value:\n"

.balign 4
width: .asciz "Please enter the width value:\n"

.balign 4
side: .asciz "Please enter the side value:\n"

@Formatters
.balign 4
strInputPattern: .asciz "%[^\n]" @ Used to clear the input buffer for invalid input. 

.balign 4
strInputError: .skip 100*4  @ User to clear the input buffer for invalid input. 

.balign 4
numPattern: .asciz "%d"

.balign 4
numInput: .word 0
