// Implement a function that sums numbers which sine is positive number.
// Number are provided in an array.
// Use nondeterministic jumps for conditional logic.
// Nondeterministic jumps: https://www.cairo-lang.org/docs/how_cairo_works/non_deterministic_jumps.html

func sum_positive_sine{}(arr_len: felt, arr: felt*, index: felt) -> (
    sum: felt
) {
    %{print(f"arr_len={ids.arr_len}, arr={ids.arr}, index = {ids.index} ")%}
}
