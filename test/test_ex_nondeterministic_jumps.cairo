%lang starknet

from exercises.programs.ex_nondeterministic_jumps import sum_positive_sine
from starkware.cairo.common.alloc import alloc

@external
func test_sum_positive_sine{syscall_ptr: felt*, range_check_ptr}() {
    alloc_locals;

    let (local array: felt*) = alloc();
    assert array[0] = 1;
    assert array[1] = 4;
    let (sum) = sum_positive_sine(2, array, 0);
    assert  1 = sum;

    let (local array: felt*) = alloc();
    assert array[0] = 2; // YES
    assert array[1] = 100;
    assert array[2] = 12;
    assert array[3] = 2; // YES
    assert array[4] = 422; // YES
    assert array[5] = 898;
    assert array[6] = 10;
    assert array[7] = 31;
    assert array[8] = 22;
    assert array[9] = 5;
    let (sum) = sum_positive_sine(10, array, 0);
    assert 426 = sum;

    return ();
}
