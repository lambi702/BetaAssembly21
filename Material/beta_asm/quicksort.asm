|; Quicksort(array, size):
|;  Sort the given array using the quicksort algorithm
|;  @param array Address of array[0] in the DRAM
|;  @param size  Number of elements in the array

|; authors : - Romain LAMBERMONT, s190931
|;           - Arthur LOUIS, s191230

|; --- Macros ---

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

|; Function : partition : computes the pivot and and sorts the elements in the 
|;                        corresponding sub-arrays, the value of the pivot is
|;                        computed from the last element of the array
|; @param array : the adress of the array
|; @param size : size of the array
|; @param pivot : index of element to swap with last element (often the middle of the array)
|; @returns small + 1 : the index of the pivot after partitioning
partition:
    PUSH(LP) PUSH(BP)
    MOVE(SP,BP)
    PUSH(R1) PUSH(R2)
    PUSH(R3) PUSH(R4)
    PUSH(R5) PUSH(R6)
    PUSH(R7) PUSH(R8)
    PUSH(R9)

    LD(BP,-12,R1) |; r1 = array
    LD(BP,-16,R2) |; r2 = size
    LD(BP,-20,R3) |; r3 = pivot

    SUBC(R2,1,R4) |; r4 = size - 1

    ADDR(R1,R3,R5) |; r5 = array + pivot
    ADDR(R1,R2,R6)
    SUBC(R6,4,R6) |; r6 = array + size - 1
    PUSH(R5) PUSH(R6)
    CALL(swap,2) |; swap(array + pivot, array + size - 1)

    LDR(R1,R4,R6) |; r6 = pivot_val = array[r4]
    
    MOVE(R31,R7) |; r7 = curr = 0
    SUBC(R31,1,R8) |; r8 = small = -1

partition_loop:
    CMPLT(R7,R4,R0)
    BF(R0,partition_end) |; if(curr >= size - 1) -> exit loop

    LDR(R1,R7,R0) |; r0 = array[curr]
    CMPLE(R0,R6,R0)
    BT(R0,partition_inc) |; if(array[curr] <= pivot_val) -> enter the condition in _inc
    
    ADDC(R7,1,R7) |; curr++
    BR(partition_loop)

partition_inc:
    ADDC(R8,1,R8) |; small++
    ADDR(R1,R7,R0) |; r0 = array + curr
    ADDR(R1,R8,R9) |; r9 = array + small
    PUSH(R0) PUSH(R9)
    CALL(swap,2) |; swap(array + curr, array + small)
    
    ADDC(R7,1,R7) |; curr++
    BR(partition_loop)

partition_end:
    ADDR(R1,R8,R0)
    ADDC(R0,4,R0) |; r0 = array + small + 1

    ADDR(R1,R2,R9)
    SUBC(R9,4,R9) |; r9 = array + size - 1

    PUSH(R0) PUSH(R9)
    CALL(swap,2) |; swap(array + small + 1, array + size - 1)

    ADDC(R8,1,R8)
    MOVE(R8,R0) |; r0 = small + 1 to return

    POP(R9) POP(R8)
    POP(R7) POP(R6)
    POP(R5) POP(R4)
    POP(R3) POP(R2)
    POP(R1)
    POP(BP) POP(LP)
    RTN()

|; Function : quicksort : sorts the array using the quicksort algorithm
|; @param array : address of the array
|; @param size : size of the array
quicksort:
    PUSH(LP) PUSH(BP)
    MOVE(SP,BP)
    PUSH(R1) PUSH(R2)
    PUSH(R3) PUSH(R4)
    PUSH(R5)

    LD(BP,-16,R1) |; r1 = array
    LD(BP,-12,R2) |; r2 = size

    CMPLEC(R2,1,R0)
    BT(R0,quicksort_end) |; if(size <= 1) -> base case in _end

    DIVC(R2,2,R3)
    SUBC(R3,1,R3) |; r3 = size/2 - 1

    PUSH(R3) PUSH(R2) PUSH(R1)
    CALL(partition,3) |; partition(array, size, size/2 - 1)

    MOVE(R0,R4) |; r4 = pivot
    PUSH(R1) PUSH(R4)
    CALL(quicksort,2) |; quicksort(array, pivot)

    ADDR(R1,R4,R0)
    ADDC(R0,4,R0) |; r0 = array + pivot + 1
    SUBC(R2,1,R5)
    SUB(R5,R4,R5) |; r5 = size - 1 - pivot
    PUSH(R0) PUSH(R5)
    CALL(quicksort,2) |; quicksort(array + pivot + 1, size - 1 - pivot)

quicksort_end:
    POP(R5) POP(R4)
    POP(R3) POP(R2)
    POP(R1)
    POP(BP) POP(LP)
    RTN()