%lang starknet
from exercises.contracts.oddson.oddson import (
    OddsOn,
    Odd,
    oddsons,
    oddson_idx,
    set_up_game,
    submit_commit,
    submit_reveal,
    check_caller,
    odds
)
from starkware.cairo.common.cairo_builtins import HashBuiltin, BitwiseBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.hash_state import hash_init, hash_update
from starkware.cairo.common.math import assert_not_zero, assert_not_equal
from lib.hash import hash_felt
from lib.constants import TRUE, FALSE

const challenger = 0x00348f5537be66815eb7de63295fcb5d8b8b2ffe09bb712af4966db7cbb04a95;
const challengee = 0x3fe90a1958bb8468fb1b62970747d8a00c435ef96cda708ae8de3d07f1bb56b;
const cheater    = 0x77777777777777766665555570747d8a00c435ef96cda708ae8de3d07f1bb56b;

@external
func test_structs(){

    // Create a oddson struct
    let oddson = OddsOn(
        challenger=challenger, challengee=challengee, spread=50, commence=0, over=0
    );

    // Create a odd struct
    let odd = Odd(commit=666, commited=1, reveal=0, revealed=0, number=0);

    return ();
}


@external
func test_set_up_game{ syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(){

    alloc_locals;

    // Get counter at the start
    let (oddson_counter) = oddson_idx.read();

    // Assert initialised to zero
    assert 0 = oddson_counter;

    // Set-up a new oddson
    set_up_game(challenger, challengee, 42);

    // Read oddson counter
    let (oddson_counter) = oddson_idx.read();

    // Assert index incremented
    assert 1 = oddson_counter;

    // Read new oddson instance
    let (odds_on) = oddsons.read(0);

    // Assert correct addresses set in memory
    assert challenger = odds_on.challenger;
    assert challengee = odds_on.challengee;

    // Assert correct spread set in memory
    assert 42 = odds_on.spread;

    return ();
}


@external
func test_check_caller{ syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(){

    // Create oddson struct
    let oddson = OddsOn(
        challenger=challenger, challengee=challengee, spread=50, commence=0, over=0
    );    

    // Assert calling as valid addresses returns true
    let (valid) = check_caller(challengee, oddson);
    assert TRUE = valid;
    let (valid) = check_caller(challenger, oddson);
    assert TRUE = valid;

    // Assert calling as an invalid address returns false
    let (valid) = check_caller(cheater, oddson);
    assert 0 = valid;

    return ();
}

@external
func test_submit_commit{ syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(){

    alloc_locals;

    let (commit_challenger) = hash_felt(4153128);  // 40
    let (commit_challengee) = hash_felt(2840601);  // 25

    // Set-up a new oddson
    set_up_game(challenger, challengee, 50);

    // Submit commits
    //###########################################################

    // Submit commits as challengee
    %{ stop_prank_callable = start_prank(ids.challengee) %}
    submit_commit(0, commit_challengee);
    %{ stop_prank_callable() %}

    // Submit commits as challenger
    %{ stop_prank_callable = start_prank(ids.challenger) %}
    submit_commit(0, commit_challenger);
    %{ stop_prank_callable() %}

    // Assert correct odd struct stored for challenger
    let (odd) = odds.read(0, challenger);
    assert commit_challenger = odd.commit;
    assert TRUE = odd.commited;
    assert 0 = odd.reveal;
    assert FALSE = odd.revealed;
    assert 0 = odd.number;

    // Assert correct odd struct stored for challengee
    let (odd) = odds.read(0, challengee);
    assert commit_challengee = odd.commit;
    assert TRUE = odd.commited;
    assert 0 = odd.reveal;
    assert FALSE = odd.revealed;
    assert 0 = odd.number;

    // Assert cannot submit a commit again
    %{ stop_prank_callable = start_prank(ids.challenger) %}
    %{ expect_revert() %}
    submit_commit(0, commit_challenger);
    %{ stop_prank_callable() %}

    return ();
}

@external
func test_submit_reveal_1{ syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(){

    alloc_locals;

    let (commit_challenger) = hash_felt(4153128);  // 40
    let (commit_challengee) = hash_felt(2840601);  // 25

    // Set-up a new oddson
    set_up_game(challenger, challengee, 20);

    // Submit commits
    //###########################################################

    // Submit commits as challengee
    %{ stop_prank_callable = start_prank(ids.challengee) %}
    submit_commit(0, commit_challengee);
    %{ stop_prank_callable() %}

    // Submit commits as challenger
    %{ stop_prank_callable = start_prank(ids.challenger) %}
    submit_commit(0, commit_challenger);
    %{ stop_prank_callable() %}      

    // Submit reveals
    //###########################################################

    // Submit reveal as challengee
    %{ stop_prank_callable = start_prank(ids.challengee) %}
    submit_reveal(0, 2840601);
    %{ stop_prank_callable() %}

    // Assert number rounded down and marked as revealed
    let (odd_challengee) = odds.read(0, challengee);
    assert odd_challengee.number = 20;
    assert TRUE = odd_challengee.revealed;

    // Reverts on wrong secret
    %{ stop_prank_callable = start_prank(ids.challenger) %}
    %{ expect_revert() %}
    submit_reveal(0, 2840601);
    %{ stop_prank_callable() %}

    // Reverts if provided wrong hash
    return ();
}

@external
func test_submit_reveal_2{ syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(){

alloc_locals;

    let (commit_challenger) = hash_felt(4153128);  // 40
    let (commit_challengee) = hash_felt(2840601);  // 25

    // Set-up a new oddson
    set_up_game(challenger, challengee, 20);

    // Submit commits
    //###########################################################

    // Submit commits as challengee
    %{ stop_prank_callable = start_prank(ids.challengee) %}
    submit_commit(0, commit_challengee);
    %{ stop_prank_callable() %}

    // Submit reveals
    //###########################################################

    // Reverts on submit reveal as other person has not submitted commit
    %{ stop_prank_callable = start_prank(ids.challengee) %}
    %{ expect_revert() %}
    submit_reveal(0, 2840601);
    %{ stop_prank_callable() %}        

    return ();
}



@external
func test_odds_challenge_fail{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;

    let (commit_challenger) = hash_felt(4153128);  // 40
    let (commit_challengee) = hash_felt(2840601);  // 25

    // Create a oddson
    //###########################################################

    // Get counter at the start
    let (oddson_counter) = oddson_idx.read();

    // Assert initialised to zero
    assert 0 = oddson_counter;

    // Set-up a new oddson
    set_up_game(challenger, challengee, 50);

    // Submit commits
    //###########################################################

    // Submit commits as challengee
    %{ stop_prank_callable = start_prank(ids.challengee) %}
    submit_commit(0, commit_challengee);
    %{ stop_prank_callable() %}

    // Submit commits as challenger
    %{ stop_prank_callable = start_prank(ids.challenger) %}
    submit_commit(0, commit_challenger);
    %{ stop_prank_callable() %}

    // Submit reveals
    //###########################################################

    // Submit reveal as challengee
    %{ stop_prank_callable = start_prank(ids.challengee) %}
    submit_reveal(0, 2840601);
    %{ stop_prank_callable() %}

    // Submit reveal as challenger
    %{ stop_prank_callable = start_prank(ids.challenger) %}
    submit_reveal(0, 4153128);
    %{ stop_prank_callable() %}

    // Check correct state
    //##########################################################

    let (oddson) = oddsons.read(0);
    assert TRUE = oddson.over;
    assert FALSE = oddson.commence;

    return ();
}

@external
func test_odds_challenge_pass{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr, bitwise_ptr: BitwiseBuiltin*
}() {
    alloc_locals;

    let (commit_challenger) = hash_felt(699330);    // 66
    let (commit_challengee) = hash_felt(16755650);  // 66

    // Create a oddson
    //###########################################################

    // Get counter at the start
    let (oddson_counter) = oddson_idx.read();

    // Assert initialised to zero
    assert 0 = oddson_counter;

    // Set-up a new oddson
    set_up_game(challenger, challengee, 50);

    // Submit commits
    //###########################################################

    // Submit commits as challengee
    %{ stop_prank_callable = start_prank(ids.challengee) %}
    submit_commit(0, commit_challengee);
    %{ stop_prank_callable() %}

    // Submit commits as challenger
    %{ stop_prank_callable = start_prank(ids.challenger) %}
    submit_commit(0, commit_challenger);
    %{ stop_prank_callable() %}

    // Submit reveals
    //###########################################################

    // Submit reveal as challengee
    %{ stop_prank_callable = start_prank(ids.challengee) %}
    submit_reveal(0, 16755650);
    %{ stop_prank_callable() %}

    // Submit reveal as challenger
    %{ stop_prank_callable = start_prank(ids.challenger) %}
    submit_reveal(0, 699330);
    %{ stop_prank_callable() %}

    // Check correct state
    //##########################################################

    let (oddson) = oddsons.read(0);
    assert TRUE = oddson.over;
    assert TRUE = oddson.commence;

    return ();
}
