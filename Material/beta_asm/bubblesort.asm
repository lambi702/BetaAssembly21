|; Bubblesort(array, size):
|;  Sort the given array using the Bubblesort algorithm
|;  @param array Address of array[0] in the DRAM
|;  @param size  Number of elements in the array

bubblesort: 
    PUSH(LP)
    PUSH(BP)
    MOVE(SP,BP)
    PUSH(R1)
    PUSH(R2)

bubblesort_loop:


bubblesort_end:
    POP(R2)
    POP(R1)
    POP(BP)
    POP(LP)
    RTN()