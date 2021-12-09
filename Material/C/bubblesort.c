/**
 * Swap integers at address item1 and item2
 *
 * @param item1 int* Address of the first element to swap
 * @param item2 int* Address of the second element to swap
 *
 * MEMSWAP(Ra, Rb):
 *      TMP <- Mem[Reg[Ra]]
 *      Mem[Reg[Ra]] <- Mem[Reg[Rb]]
 *      Mem[Reg[Rb]] <- TMP
 */
void swap(int* item1, int* item2) {
    int tmp = *item1;
    *item1 = *item2;
    *item2 = tmp;
}
 
/**
 * Sort the array using the bubblesort algorithm
 * @param array int*   Address of the first element of the array
 * @param size  size_t Size of the array to sort
 */
void bubblesort(int* array, size_t size) {
    size_t i, j;
    for (i = 0; i < size-1; i++) {
        // Last i elements are already in place
        for (j = 0; j < size-i-1; j++) {
            if (array[j] > array[j+1]) {
                swap(&array[j], &array[j+1]);
            }
        }
    }
}