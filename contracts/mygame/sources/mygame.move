module mygame::mygame {
    use std::vector;
    use sui::event;
    use std::string;
    use sui::tx_context::{ TxContext};
    use sui::clock::{Self, Clock};
    
    const ERROR_GESTURE_IN :u64 = 1;

    struct MYGAME has drop {}

    struct Result has copy,drop {
        msg: string::String
    }

    entry public fun play(gesture_in: vector<u8>,clock: &Clock,ctx: &mut TxContext) {

        assert!((gesture_in == b"Rock" || gesture_in == b"Scissors" || gesture_in == b"Paper"), ERROR_GESTURE_IN);

        let ts_ms = clock::timestamp_ms(clock);
        let random = ts_ms % 3;
        
        let all_gestures = vector::empty<vector<u8>>();
        vector::push_back(&mut all_gestures, b"Rock");
        vector::push_back(&mut all_gestures, b"Scissors");
        vector::push_back(&mut all_gestures, b"Paper");

        let random_gestures = vector::borrow(&all_gestures,random);

        // compare
        let log;
        if (gesture_in == *random_gestures) {
            log = b"even";
        } else if (gesture_in == b"Rock" && *random_gestures == b"Scissors") {
            log = b"win";
        } else if (gesture_in == b"Scissors" && *random_gestures == b"Paper") {
            log = b"win";
        } else if (gesture_in == b"Paper" && *random_gestures == b"Rock") {
            log = b"win";
        } else {
            log = b"lose";
        };

        event::emit(Result{msg: string::utf8(log)});
    }
}