@ Filename: lab3.s
@ Author:   Ben Morgan
@ Email:    bam0043@uah.edu
@ Term:     CS413-01 2022
@ Purpose:
@ Your program will simulate the operation of a vending machine. The machine will dispense,
@ upon reception of the correct amount of money, a choice of Gum, Peanuts, Cheese Crackers, or
@ M&Ms.

@ Use these commands to assemble, link, run and debug this program:
@    as -o lab3.o lab3.s
@    gcc -o lab3 lab3.o
@    ./lab3 ;echo $?
@    gdb --args ./lab3

.equ READERROR, 0
.global main
main:
stock:
    mov r4, #2 @Gum inventory
    mov r5, #2 @Peanut inventory
    mov r6, #2 @Cracker inventory
    mov r7, #2 @M&M inventory

    mov r10, #4 @Counter to check if stock is empty

stockCheck: @Compare stock of the items to 0 to know when to stop the program
    cmp r4, #0 
    addeq r2, #1
    cmp r5, #0
    addeq r2, #1
    cmp r6, #0
    addeq r2, #1
    cmp r7, #0
    addeq r2, #1

    cmp r2, #4
    beq emptyMachine
main2:
    ldr r0, = welcomeMsg @Greet user, state cost of items, ask for input
    bl printf

    mov r8, #0  @user payment amount

prompt:
    ldr r0, = charInputPattern
    ldr r1, = charInput
    bl scanf

    ldr r1, = charInput
	ldr r1, [r1]

    cmp r1, #'G'
    beq gum
    cmp r1, #'P'
    beq pea
    cmp r1, #'C'
    beq crk
    cmp r1, #'M'
    beq mnm
    cmp r1, #'I' @Secret code to check stock
    beq secretTunnel 

reject: @If invalid input occurs tell them and try again
    ldr r0, = rejectMessage 
    bl printf

    ldr r0, = strInputPattern
    ldr r1, = strInputError
    bl scanf

    b main2
secretTunnel: @section that displays the remaining inventory
    mov r1, r4
    ldr r0, = gumInventory
    bl printf
    mov r1, r5
    ldr r0, = peaInventory
    bl printf
    mov r1, r6
    ldr r0, = crkInventory
    bl printf
    mov r1, r7
    ldr r0, = mnmInventory
    bl printf

    b main2
empty: @Tell user their selected item isn't available and let them pick something else
    ldr r0, = noStock
    bl printf
    b main2

gum:
    cmp r4, #0 
    beq empty @If the item has no stock, tell them it is out and send to reprompt for dif item
    sub r4, r4, #1 @Subtract one from the stock

    mov r9, #50 @Cost of gum
    ldr r0, = gumSelection @Confirm that the user selected gum
    bl printf

    ldr r0, = charInputPattern
    ldr r1, = charInput
    bl scanf

    ldr r1, = charInput
	ldr r1, [r1]

    cmp r1, #'n'
    beq main
    cmp r1, #'y'
    bne reject

    ldr r0, = gumPrice @prompt user to pay
    bl printf
    b payment

pea:
    cmp r5, #0 
    beq empty @If the item has no stock, tell them it is out and send to reprompt for dif item
    sub r5, r5, #1 @Subtract one from the stock

    mov r9, #55 @Cost of peanuts
    ldr r0, = peaSelection @Confirm that the user selected peanuts
    bl printf

    ldr r0, = charInputPattern
    ldr r1, = charInput
    bl scanf

    ldr r1, = charInput
	ldr r1, [r1]

    cmp r1, #'n'
    beq main
    cmp r1, #'y'
    bne reject

    ldr r0, = peaPrice @prompt user to pay
    bl printf
    b payment
crk:
    cmp r6, #0 
    beq empty @If the item has no stock, tell them it is out and send to reprompt for dif item
    sub r6, r6, #1 @Subtract one from the stock

    mov r9, #65 @Cost of crackers
    ldr r0, = crkSelection @Confirm that the user selected crackers
    bl printf

    ldr r0, = charInputPattern
    ldr r1, = charInput
    bl scanf

    ldr r1, = charInput
	ldr r1, [r1]

    cmp r1, #'n'
    beq main
    cmp r1, #'y'
    bne reject

    ldr r0, = crkPrice @prompt user to pay
    bl printf
    b payment
    
mnm:
    cmp r7, #0 
    beq empty @If the item has no stock, tell them it is out and send to reprompt for dif item
    sub r7, r7, #1 @Subtract one from the stock

    mov r9, #100 @Cost of M&Ms
    ldr r0, = mnmSelection @Confirm that the user selected M&Ms
    bl printf

    ldr r0, = charInputPattern
    ldr r1, = charInput
    bl scanf

    ldr r1, = charInput
	ldr r1, [r1]

    cmp r1, #'n'
    beq main
    cmp r1, #'y'
    bne reject

    ldr r0, = mnmPrice @prompt user to pay
    bl printf
    b payment
    

payment: @Loop until enough money has been paid
    cmp r8, r9 @compare the user's payment to cost of item to see if loop stops
    bgt overPay
    beq exactPay
    

    ldr r0, = charInputPattern
    ldr r1, = charInput
    bl scanf

    ldr r1, = charInput
    ldr r1, [r1]

    cmp r1, #'D'
    beq dime
    cmp r1, #'Q'
    beq quart
    cmp r1, #'B'
    beq dolla

    b bankBroke
    dime:
        add r8, r8, #10
        b payment
    quart:
        add r8, r8, #25
        b payment
    dolla:
        add r8, r8, #100
        b payment


exactPay:
    ldr r0, = sufMoney @Tell user enough money has been entered
    bl printf

    ldr r0, = itemDispensed @Tell user their item has been dispensed
    bl printf

    b stockCheck
overPay:
    ldr r0, = sufMoney @Tell user enough money has been entered
    bl printf

    ldr r0, = itemDispensed @Tell user their item has been dispensed
    bl printf

    sub r8, r8, r9 @ r8 = r8 - r9; calculates change given back
    mov r1, r8

    ldr r0, = change @Tell them how much change they receive
    bl printf

    b stockCheck
bankBroke:
    ldr r0, = countError @If an error happened while paying, let them know & exit program
    bl printf

    b exit

emptyMachine:
    ldr r0, = allOut @Tell user machine is out of stock and exit program
    bl printf

    b exit

readerror:
    ldr r0, = strInputPattern
    ldr r1, = strInputError
    bl scanf

    b prompt
exit:
    mov r7, #0x01 @ Satisfies 5
    svc 0


.data
.balign 4

welcomeMsg: .asciz "\nWelcome to Mr. Zippy’s vending machine.\nCost of Gum ($0.50), Peanuts ($0.55), Cheese Crackers ($0.65), or M&Ms ($1.00)\nEnter item selection: Gum (G), Peanuts (P), Cheese Crackers (C), or M&Ms (M).\n"

noStock: .asciz "\nYour selected item is out of stock. Please select a different item.\n"

rejectMessage: .asciz "\n\nInvalid input, try again.\n\n"

allOut: .asciz "The machine is completely out of items\n"

gumInventory: .asciz "\nGum: %d left\n"
mnmInventory: .asciz "M&Ms: %d left\n\n"
peaInventory: .asciz "Peanuts: %d left\n"
crkInventory: .asciz "Crackers: %d left\n"

gumSelection: .asciz "You selected gum, is this correct? (y/n)\n"
mnmSelection: .asciz "You selected M&Ms, is this correct? (y/n)\n"
peaSelection: .asciz "You selected peanuts, is this correct? (y/n)\n"
crkSelection: .asciz "You selected crackers, is this correct? (y/n)\n"

gumPrice: .asciz "\nEnter at least $0.50 for selection\nDimes (D), Quarters (Q), and Dollar Bill (B)\n"
peaPrice: .asciz "\nEnter at least $0.55 for selection\nDimes (D), Quarters (Q), and Dollar Bill (B)\n"
crkPrice: .asciz "\nEnter at least $0.65 for selection\nDimes (D), Quarters (Q), and Dollar Bill (B)\n"
mnmPrice: .asciz "\nEnter at least $1.00 for selection\nDimes (D), Quarters (Q), and Dollar Bill (B)\n"

itemDispensed: .asciz "Your item has been dispensed\n"

sufMoney: .asciz "Enough money entered.\n"

change: .asciz "Change of %d cents have been returned\n"

countError: .asciz "Error in money counting. Exiting program.\n"

charInputPattern: .asciz "%s"
charInput: .word 0

strInputPattern: .asciz "%[^\n]" @ Used to clear the input buffer for invalid input. 
strInputError: .skip 100*4  @ User to clear the input buffer for invalid input. 
