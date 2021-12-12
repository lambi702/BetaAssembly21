|; Bubblesort(array, size):
|;  Sort the given array using the Bubblesort algorithm
|;  @param array Address of array[0] in the DRAM
|;  @param size  Number of elements in the array

|; authors : - Romain LAMBERMONT, s190931
|;           - Arthur LOUIS, s191230

|;--- Macros ---

|; Macro : SWAP : swaps the values between two registers
|; @param Ra : address of the first element to swap
|; @param Rb : address of the second element to swap
|; @param Rtmp1 : first temporary register used to swap
|; @param Rtmp2 : second temporary register used to swap
.macro SWAP(Ra,Rb, Rtmp1, Rtmp2) LD(Ra, 0, Rtmp1) LD(Rb, 0, Rtmp2) ST(Rtmp1, 0, Rb) ST(Rtmp2,0, Ra)

|; Macro : ADDR : computes the adress of the Ri th element in the array Ra
|;                and saves it in the register Ro
|; @param Ra : address of the array
|; @param Ri : index of the element to compute the address
|; @param Ro : register used to save the address
.macro ADDR(Ra, Ri, Ro) MULC(Ri,4, Ro) ADD(Ra, Ro, Ro)

|; Macro : LDR : loads the Ri th element of the array Ra and saves it in 
|;               the register Ro
|; @param Ra : address of the array
|; @param Ri : index of the element to extract
|; @param Ro : register used to save the value of the element extracted
.macro LDR(Ra, Ri, Ro) ADDR(Ra, Ri, Ro) LD(Ro, 0, Ro)

|; --- Functions ---

|; Function : swap : swaps two register's value using the SWAP macro
|; @param Ra : address of the first element to swap
|; @param Rb : address of the second element to swap
swap:
    PUSH(LP) PUSH(BP)
    MOVE(SP,BP)
    PUSH(R1) PUSH(R2)
    PUSH(R3) PUSH(R4)

    LD(BP,-12,R1)
    LD(BP,-16,R2)
    SWAP(R1,R2,R3,R4)

    POP(R4) POP(R3)
    POP(R2) POP(R1)
    POP(BP) POP(LP)
    RTN()

|; Function : quicksort : sorts the array using the bubblesort algorithm
|; @param array : address of the array
|; @param size : size of the array
bubblesort:
    PUSH(LP) PUSH(BP)
    MOVE(SP,BP)
    PUSH(R1) PUSH(R2)
    PUSH(R3) PUSH(R4)
    PUSH(R5) PUSH(R6)

    LD(BP,-16,R1) |; r1 = array
    LD(BP,-12,R2) |; r2 = size
    SUBC(R2,1,R3) |; r3 = size - 1
    CMOVE(0,R4) |; r4 = i = 0
    CMOVE(0,R5) |; r5 = j = 0

bubblesort_loop_1:
    CMPLT(R4,R3,R0)
    BF(R0,bubblesort_end) |; if(i >= size - 1) exit the loop

bubblesort_loop_2:
    SUB(R3,R4,R6) |; r6 = size - 1 - i
    CMPLT(R5,R6,R0)
    BF(R0,bubblesort_loop_1_end) |; if(j >= size - 1 - i) -> i++

    LDR(R1,R5,R6) |; r6 = array[j]

    ADDC(R5,1,R0)
    LDR(R1,R0,R0) |; r0 = array[j+1]

    CMPLT(R0,R6,R0)
    BF(R0, bubblesort_loop_2_end) |; if(array[j+1] >= array[j]) -> direct j++

    ADDR(R1,R5,R6) |; r6 = &array[j]

    ADDC(R5,1,R0)
    ADDR(R1,R0,R0) |; r0 = &array[j+1] 

    PUSH(R0) PUSH(R6)
    CALL(swap,2) |; swap(&array[j], &array[j+1])

bubblesort_loop_2_end:
    ADDC(R5,1,R5) |; j++
    BR(bubblesort_loop_2)

bubblesort_loop_1_end:
    ADDC(R4,1,R4) |; i++
    CMOVE(0,R5) |; j = 0
    BR(bubblesort_loop_1)

bubblesort_end:
    POP(R6) POP(R5)
    POP(R4) POP(R3)
    POP(R2) POP(R1)
    POP(BP) POP(LP)
    RTN()