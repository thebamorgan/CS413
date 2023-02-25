@ Filename: MORGANL1_413.s
@ Author:   Ben Morgan
@ Email:    bam0043@uah.edu
@ Term:     CS413-01 2022
@ Purpose:


@ Use these commands to assemble, link, run and debug this program:
@    as -o MORGANL1_413.o MORGANL1_413.s
@    gcc -o MORGANL1_413 MORGANL1_413.o
@    ./MORGANL1_413 ;echo $?
@    gdb --args ./MORGANL1_413



.equ READERROR, 0
.equ length, 10
.global main

main:

welcome:

    ldr r0, = welcomeStr @ Satisfies 1
    bl printf

    mov r1, #length
    ldr r3, =A1 @Store the arrays into registers
    ldr r4, =A2
    ldr r5, =A3

arrayCalc:

    ldr r6, [r3], #4 @Loads the current value in array 1 and increases the position in the array

    ldr r7, [r4], #4 @Loads the current value in array 2 and increases the position in the array

    add r6, r6, r7 @Add the values of array 1 & 2 together and store in register 6
    str r6, [r5], #4 @Add the calculated value to the third array and move to the next position

    subs r1, r1, #1 @Subtract one from the counter
    bne arrayCalc

next:

    ldr r5, =A1
    ldr r0, = first
    bl printf
    bl arrayPrint

    ldr r5, =A2
    ldr r0, = second
    bl printf
    bl arrayPrint

    ldr r5, =A3
    ldr r0, = third
    bl printf
    bl arrayPrint


    b userTime
arrayPrint:

    mov r8, #length
    push {lr}
    arrayPrint_2:
        cmp r8, #0
        beq next2 @Once it has printed 10 times, break the loop and move on

        ldr r1, [r5], #4 @Store the value of the position in the third array to be printed

        ldr r0, =numPattern @Load the number format so it can print a number
        bl printf  @Print the current position in the array

        sub r8, r8, #1 @Subtract one from the counter
        b arrayPrint_2 @Repeat array


next2:
    pop {pc}
    b exit


userTime:
    ldr r0, = instructionStr @instruct the user on how to determine what type of numbers they want to see
    bl printf

    ldr r0, =charPattern @Prepare for character type input
    ldr r1, =charInput @Receive the character type input
    bl scanf

    ldr r1, = charInput
    ldr r1, [r1]
    cmp r1, #'+'
    beq positivePrint
    cmp r1, #'-'
    beq negative
    cmp r1, #'0'
    beq zero

    b exit

positivePrint:
/*
for i in array:
    if i > 0:
        print array[i]
 */
    ldr r5, =A3
    mov r8, #0
    push {lr}
    posPrint:

        cmp r8, #length
        bge exit
        add r8, #1

        ldr r1, [r5], #4

        cmp r1, #0
        ble posPrint

        ldr r0, =numPattern
        bl printf

        b posPrint


negative:
/*
for i in array:
    if i < 0:
        print array[i]
 */
    ldr r5, =A3
    mov r8, #0

    negPrint:

        cmp r8, #length
        bge exit
        add r8, #1

        ldr r1, [r5], #4

        cmp r1, #0
        bge negPrint

        ldr r0, =numPattern
        bl printf

        b negPrint


zero:
/*
for i in array:
    if i == 0:
        print array[i]
 */
    ldr r5, =A3
    mov r8, #0
    zerPrint:

        cmp r8, #length
        bge exit
        add r8, #1

        ldr r1, [r5], #4

        cmp r1, #0
        bgt zerPrint
        cmp r1, #0
        blt zerPrint

        ldr r0, =numPattern
        bl printf

        b zerPrint


readerror:

    ldr r8 , = strInputPattern
    ldr r9, = strInputError
    bl scanf

    b welcome

exit:

    mov r7, #0x01 @ Satisfies 5
    svc 0

.data

.balign 4
welcomeStr: .asciz "Welcome to the first 413 lab.\n"

.balign 4
instructionStr: .asciz "Please type +, -, or 0 to see the values of their respective type from the third array.\n"
.balign 4
numPattern: .asciz "%d\n"
.balign 4
charPattern: .asciz "%c"
.balign 4
charInput: .word 0
.balign 4
strInputPattern: .asciz "%[^\n]" @ Used to clear the input buffer for invalid input.

.balign 4
strInputError: .skip 100*4  @ User to clear the input buffer for invalid input.

.balign 4
A1: .word 0,1,2,3,4,1,6,7,8,9
.balign 4
A2: .word 4,-1,-2,-5,6,7,8,8,9,1
.balign 4
A3: .word 0,0,0,0,0,0,0,0,0,0

.balign 4
first: .asciz "This is the first array.\n"
.balign 4
second: .asciz "This is the second array.\n"
.balign 4
third: .asciz "This is the calculated array.\n"

