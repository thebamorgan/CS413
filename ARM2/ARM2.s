@ Use these commands to assemble, link, run and debug this program:
@    as -o ARM2.o ARM2.s
@    gcc -o ARM2 ARM2.o
@    ./ARM2 ;echo $?
@    gdb --args ./ARM2


@ 1) Provides a welcome and instruction messages.
@ 2) Prompt the user to enter an integer between 0 and 10.
@ 3) Verify the proper input value. Reject any invalid inputs (negative, greater than 10) and re-prompt for a valid input value.
@ 4) Print “Hello world.” The number of times the user entered. Each “Hello world.” will be printed on a separate line.
@ 5) Code is to exit once the required messages are printed the requested number of times.
.equ READERROR, 0
.global main

main:
    ldr r0, = main2+1 @This change was made to make the program run in Thumb mode.... allegedly
    bx r0
    .code 16
main2:

welcome:

    ldr r0, = welcomeStr @ Satisfies 1
    bl printf

intPrompt:

    ldr r0, = instructionStr @ Satisfies 1/2
    bl printf

    ldr r0, = numPattern
    ldr r1, = intInput
    bl scanf

    cmp r0, #READERROR             
    beq readerror 

    ldr r1, = intInput
    ldr r1, [r1]

    cmp r1, #10 @ If the number is bigger than 10, reject the input
    bgt reject @ Satisfies 3

    cmp r1, #0
    blt reject @ Satisfies 3

    mov r6, r1 @ Load the value of r1 into r6
    b helloLoop

reject: 
    @ Satisfies 3
    ldr r0, = rejectMessage
    bl printf
    b intPrompt

helloLoop:
    cmp r6, #0 @ Here r6 is being compared to the value of 0, so once it is equal to 0 the loop will stop. 
    ble exit
    ldr r0, = helloWorld
    bl printf
    sub r6, r6, #1
    b helloLoop

readerror:

    ldr r0, = strInputPattern
    ldr r1, = strInputError
    bl scanf

    b intPrompt

exit:
    
    mov r7, #0x01 //Satisfies requirement 8
    svc 0

.data

.balign 4
welcomeStr: .asciz "Welcome to 413.\n" 

.balign 4
instructionStr: .asciz "Please enter a number 0-10. Hello World will print the number of times you enter.\n"

.balign 4
numPattern: .asciz "%d" 

.balign 4
helloWorld: .asciz "Hello World!\n"

.balign 4
intInput: .word 0

.balign 4
rejectMessage: .asciz "Invalid input, try again.\n"

.balign 4
strInputPattern: .asciz "%[^\n]" @ Used to clear the input buffer for invalid input. 

.balign 4
strInputError: .skip 100*4  @ User to clear the input buffer for invalid input. 
