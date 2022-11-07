# OddsOn contract

## What is OddsOn?

OddsOn is one of the games British people use to amuse themselves when drunk. In short, one person (`challenger`) offers another person a challenge, the chalenged party (`challengee`) states odds at which they would be willing to potentially have to fulfil the stated challenge and finally, both parties, after a countdown state a number within the odds range. If numbers match, the challengee has to commence the challenge. The crazier the challange, the higher the odds (up to 100). You win by seeing your friends do stupid stuff, and you lose by having to do it yourself.


It is quite hard to execute an OddsOn game in real life because (as with rock-paper-scissors) there is some delay between two parties stating their respective numbers. This can be avoided by writing it on seperate pieces of paper, but it can also be done on blockchain as a simple commit-reveal.

## Contract overview

This contract will assume two parties have already agreed to set-up an OddsOn instance between themselves, the odds have been selected, and they merely need a smart contract to prevent cheating. From there on following steps will happen and need to be implemented:

1. Create a new OddsOn instance in the smart contract that will contain the addresses of both parties as well as the odds.
2. Each party submits the hash of the salted number that they wish to state (commit)
3. Each party submits the secret that goes on to produce above submitted hash (reveal)
4. Challenge is marked as either to be either commenced or not

## Features to implement

As in other exercises, functions declarations are provided, their names and parameters are not to be changed as it would break the tests (further). Likewise, tests are not to be changed but can be used for reference.


### Implement structs

Two [structs](https://www.cairo-lang.org/docs/reference/syntax.html#structs) necessary for this contract to work are missing, namely `Odd` and `OddsOn`. Implement them based on the following templates.


Struct `OddsOn` contains the following fields, all of the type felt:
- `challenger`
- `challengee`
- `spread`
- `commence`


Struct `Odd` contains the following fields, all of the type felt:
- `commit`
- `committed`
- `reveal`
- `revealed`
- `number`

Structs tested with `test_structs()`.

### Set-up an OddsOn


Function `set_up_game` accepts three arguments; challenger's address (`challenger: felt`), challengee's address (`challengee: felt`), odds at which person offered challenge is willing to proceed at (`spread: felt`).

Either party can call this function, it will create a new `OddsOn` struct and store it in the storage variable `oddsons` under the index retrieved from the `oddson_idx` storage variable. Finally, it will increment the OddsOn counter (`oddson_idx`) and write the new value back to the `oddson_idx` storage variable.

Set-up tested with `test_set_up_game()`.

### Access control

Two different functions will require access control that ensures only either of the two participants is allowed to invoke a given function. This reused logic will be accomplished using the function `check_caller`.

Function `check_caller` accepts two arguments; the address of the caller (`caller: felt`) being written to, and the struct containing information about this game instance (`oddson: OddsOn`). Based on the information from the argument `oddson`, it should return 1 if the caller is either of the players (`challengee` / `challenger`) and 0 otherwise.

Access control tested with `test_check_caller()`.

### Commit

Function `submit_commit` accepts two arguments; the index of the challenge (`oddson_idx: felt`) being written to, and the hash of the number (`commit: felt`).

At first `submit_commit` verifies that the caller is allowed to modify this OddsOn instance, by checking it with `check_caller`. It then retrieves the `Odd` struct for the caller. The caller is checked against the field `commited` to see whether the hash has already been stored (`committed = 1, already committed reject).

Commit tested with `test_submit_commit()`.

### Reveal

Function `submit_reveal` accepts two arguments; the index of the challenge (`oddson_idx: felt`) being written to, and secret (`reveal: felt`) that goes on to generate hash submitted earlier.

At first `submit_reveal` verifies that the caller is allowed to modify this OddsOn slot, by checking it with `submit_reveal`.

To prevent a person from cheating, both commits need to be submitted before anything can be revealed. Otherwise, the party that has seen the secret, but has not yet provided their own hash commit could pick a number that makes them "win". To do so first the `Odd` struct is retrieved for both people, and assertions are made to ensure each of the participants has already submitted a commit.

Invoke function `hash_felt` to hash provided reveal. Assert to ensure this regenerated hash matches the one that is stored at the field `commit` of the `Odd` struct for the caller


We need 100 distinct values, so a resolution of 7 bits (128 values) will suffice. Mask the `reveal` and extract from it the first 7bits, with the rest being the salt used to prevent brute forcing. This table shows how the same number can be represented in different ways:


| masked decimal  | masked binary  | unmasked decimal   | unmasked decimal |
|---|---|---|---|
| 4153128  |  01111110101111100101000  |  40  |  0101000 | 
| 2612008  |  01001111101101100101000  |  40  |  0101000 | 
|  2840601 | 1010110101100000011001  | 25  |  0011001 |
|  90137 | 000010110000000011001  | 25  |  0011001 |


Update `Odd` in storage for the caller to include the revealed number, as well as setting the revealed flag to 1. 


Check if both reveals have bene provided. If they have been, then compare them to see if the numbers are the same and based on that, update the state of the OddsOn.


As protostar test execution end on a revert, two unit tests are used to check necessary functionality of `submit_reveal()`. Those tests are `test_submit_reveal_1()` and `test_submit_reveal_2()`.

# // STUDENT-VERSION: Remove



## Homework ideas


### Security

No deadline


### Optimisation

Talk about why this implementation has less accessc control checks etc. doesnt matter ordering of commits. Only if they match.

talk about storage, could remove `Odd` fields:
- number (can recluclate at client)
- revealed (no penalty besides gas for resubmitting it)