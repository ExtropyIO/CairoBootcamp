// Task:
// Make the program work using only impicit arguments. No standard function arguments should be used.

// Tips:
// Implicit arguments are returned implicitly by any function using them
// Implicit arguments are passed down to any subsequent function calls that would require them.

from starkware.cairo.common.math import unsigned_div_rem

// TODO: fix function signature to make the test pass
func add_salt() -> felt {
    return secret + salt;
}

// TODO: fix function signature to make the test pass
func hash_6() -> () {
    let (secret, r) = unsigned_div_rem(value=secret, div=6);
    return (); 
}

// TODO: fix function signature to make the test pass
func hash_7() -> () {
    let (secret, r) = unsigned_div_rem(value=secret, div=7);
    return (); 
}

func implicit_arguments{secret: felt, range_check_ptr}() -> felt {
    let salt = 'salty';
    let secret = add_salt{secret=secret, salt=salt}();

    hash_6();
    hash_7();

    return secret;
}
