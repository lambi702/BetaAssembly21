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
 * Partition the array around the pivot value taken at the end of the array (i.e. array[size - 1]).
 * In the end, the array is such that: array[... start + i] <= array[start + i + 1] < array[start + i + 2 ...]
 *
 * @param array int*   Address of the first element of the array
 * @param size  size_t Size of the array to partition
 *
 * @return size_t The position of the pivot after partitioning
 */
int partition(int* array, size_t size, size_t pivot) {
    // Swap pivot with the end of the array
    swap(array + pivot, array + size - 1);
    int pivot_val = array[size - 1];

    // Partition around pivot_val
    long small = -1;
    for (size_t curr = 0; curr < size -1 ; ++curr) {
        if (array[curr] <= pivot_val) {
            small++;
            swap(array + curr, array + small);
        }
    }

    // Place pivot between two subarrays
    swap(array + small + 1, array + size - 1);
    return small + 1;
}

/**
 * Sort the array using the quicksort algorithm
 * @param array int*   Address of the first element of the array
 * @param size  size_t Size of the array to sort
 */
void quicksort(int* array, size_t size) {
    if (size <= 1) {
        return;
    }

    // Pivot is taken at the center of the array
    size_t pivot = partition(array, size, (size / 2) - 1); // Partition the array around the pivot
    quicksort(array, pivot); // Sort the subarray to the left of the pivot
    quicksort(array + pivot + 1, size - pivot - 1); // Sort the subarray to the right of the pivot
}
