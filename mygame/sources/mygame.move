module mygame::mygame {
    use std::vector;
    use sui::tx_context::{ TxContext};
    use sui::clock::{Self, Clock};
    struct MYGAME has drop {};


    entry public play(gesture: vector<u8>,clock: &Clock,ctx: &mut TxContext) {
        
    }
}