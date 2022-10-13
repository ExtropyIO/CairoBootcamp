%lang starknet

from exrx.ex_implicit_arguments import implicit_arguments

@external
func test_implicit_arguments{syscall_ptr: felt*, range_check_ptr}() {
    let secret = 'Cairo';
    let encoded = implicit_arguments{secret=secret}();
    %{
        print(f"encoded: {ids.encoded}")
    %}
    assert 18689353477 = encoded;
    return ();
}
