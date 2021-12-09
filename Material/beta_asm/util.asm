|; ABS(Ra, Rb):     Reg[Rc] <- | Reg[Ra] |              (note: Ra should be different from Rc)
.macro ABS(Ra, Rc)          SRAC(Ra, 31, Rc) XOR(Ra, Rc, Rc) SUB(Ra, Rc, Rc)
|; MOD(Ra, Rb, Rc): Reg[Rc] <- Reg[Ra] % Reg[Rb]        (note: Ra should be different from Rc)
.macro MOD(Ra, Rb, Rc)      ABS(Ra, Rc) MOVE(Rc, Ra) DIV(Ra, Rb, Rc) MUL(Rc, Rb, Rc) SUB(Ra, Rc, Rc)

|; fill(array, size):
|;  Fill an array with increasing value ranging from 1 to size.
|;  @param array Address of the first element of the array
|;  @param size  The size of the array
fill__: 
    PUSH(LP)                    |; Save and update LP and BP
    PUSH(BP)
    MOVE(SP, BP) 

    PUSH(R1)                    |; Save registers
    PUSH(R2)
    PUSH(R3)
    PUSH(R4)
    PUSH(R5)

    LD(BP, -16, R1)             |; array
    LD(BP, -12, R2)             |; size

    CMOVE(0, R3)                |; i = 0
    
fill_loop__:
    CMPLT(R3, R2, R4)           |; i > 0
    BF(R4, fill_end__)          |; if (i > 0) -> jump to fill_end__
    ADDC(R3, R1, R4)            |; Compute value to place in the array: Reg[R4] <- i + 1 
    MULC(R3, 4, R5)             |; Reg[R5] <- 4 * i
    ADD(R1, R5, R5)             |; Compute address: Reg[R5] <- array + 4 * i
    ST(R4, 0, R5)               |; Save value in array
    ADDC(R3, 1, R3)             |; i++
    BR(fill_loop__)

fill_end__:
    POP(R5)                     |; Restore registers
    POP(R4)
    POP(R3)
    POP(R2)
    POP(R1)
    POP(BP)
    POP(LP)
    RTN()

|; random_array(array, size):
|;  Fill an array with random values
|;  @param array Address of the first element of the array
|;  @param size  The size of the array
random_shuffle__:
    PUSH(LP)                        |; Save and update LP and BP
    PUSH(BP)
    MOVE(SP, BP) 

    PUSH(R1)                        |; Save registers
    PUSH(R2)
    PUSH(R3)
    PUSH(R4)
    PUSH(R5)
    PUSH(R6)
    PUSH(R7)

    LD(BP, -16, R1)                 |; array
    LD(BP, -12, R2)                 |; size

    MOVE(R2, R3)                    |; i = size
    SUBC(R3, 1, R3)                 |; i--

random_shuffle_loop__:
    CMPLT(R31, R3, R4)              |; i > 0
    BF(R4, random_shuffle_end__)    |; if (i > 0) -> jump to random_shuffle_end__
    RANDOM()                        |; Compute swap first address : array + 4 * (rand() % i)  
    MOVE(R0, R4)                
    PUSH(R4)
    PUSH(R3)
    CALL(modulo__)                  |; Reg[R0] <- rand() % i
    DEALLOCATE(2)
    MULC(R0, 4, R4)                 |; Reg[R4] <- 4 * (rand() % i)
    ADD(R4, R1, R4)                 |; Reg[R4] <- array + 4 * (rand() % i)
    MULC(R3, 4, R5)                 |; Compute swap second address : array + 4 * i
    ADD(R5, R1, R5)                 |; Reg[R5] <- array + 4 * i

    LD(R4, 0, R6)                   |; Swap elements of array: Mem[Reg[R4]] with Mem[Reg[R5]]
    LD(R5, 0, R7)
    ST(R6, 0, R5)
    ST(R7, 0, R4)

    SUBC(R3, 1, R3)                 |; i--
    BR(random_shuffle_loop__)

random_shuffle_end__:
    POP(R7)                         |; Restore registers
    POP(R6)
    POP(R5)
    POP(R4)
    POP(R3)
    POP(R2)
    POP(R1)
    POP(BP)
    POP(LP)
    RTN()

|; modulo(a, b)
|;  Compute |a| % b, both being positive integers
modulo__: 
    PUSH(LP)            |; Save and update LP and BP
    PUSH(BP)
    MOVE(SP, BP)
    PUSH(R1)            |; Save registers 
    PUSH(R2)
    PUSH(R3)
    PUSH(R4)
    LD(BP, -16, R1)     |; Reg[R1] <- a
    LD(BP, -12, R2)     |; Reg[R2] <- b
    |; Make sure a is positive
    PUSH(R1)
    CALL(abs__)
    DEALLOCATE(1)
    MOVE(R0, R1)
    |; Modulo: m = a - floor(a / b) * b
    DIV(R1, R2, R3)     |; Reg[R3] <- floor(a / b) 
    MUL(R3, R2, R4)     |; Reg[R4] <- Reg[R3] * b
    SUB(R1, R4, R0)     |; Reg[R0] <- a - Reg[R4]
    POP(R4)
    POP(R3)
    POP(R2)
    POP(R1)
    POP(BP)
    POP(LP)
    RTN()

|; abs(n) : 
|;  Returns the absolute value of n
abs__:
    PUSH(LP)
    PUSH(BP)
    MOVE(SP, BP) 
    PUSH(R1)
    LD(BP, -12, R0)
    CMPLEC(R0, 0, R1)
    BF(R1, abs_end__)
    MULC(R0, -1, R0)

abs_end__:
    POP(R1)
    POP(BP)
    POP(LP)
    RTN()