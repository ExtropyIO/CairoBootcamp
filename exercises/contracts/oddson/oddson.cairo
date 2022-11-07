%lang starknet
from starkware.cairo.common.cairo_builtins import HashBuiltin, BitwiseBuiltin
from starkware.cairo.common.uint256 import (
    Uint256,
    uint256_le,
    uint256_unsigned_div_rem,
    uint256_sub,
)
from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.math import unsigned_div_rem, assert_le_felt, assert_le
from starkware.cairo.common.math_cmp import is_le
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.hash_state import hash_init, hash_update
from starkware.cairo.common.bitwise import bitwise_and, bitwise_xor
from lib.hash import hash_felt

@storage_var
func oddson_idx() -> (idx: felt) {
}

@storage_var
func oddsons(oddson_idx: felt) -> (oddson_struct: OddsOn) {
}

@storage_var
func odds(oddson_idx: felt, player: felt) -> (numb: Odd) {
}

func set_up_game{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    challenger: felt, challengee: felt, spread: felt
) {

    return ();
}

@view
func check_caller{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    caller: felt, oddson: OddsOn
) -> (valid: felt) {

    return (1,);
}

func submit_commit{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}(oddson_idx: felt, commit: felt) {

    return ();
}

func submit_reveal{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}(oddson_idx: felt, reveal: felt) {

    return ();
}
