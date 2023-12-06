module mynft::nft {
    use sui::transfer;
    use sui::package::{Self};
    use std::string::{String,utf8};
    use sui::tx_context::{Self, TxContext};
    use sui::display;
    use sui::object::{Self,ID,UID};
    use sui::event;
    

    struct NFT has drop {}

    struct MyNFT has key, store {
        id: UID,
        name: String,
        image_url: String,
        description: String
    } 

    // event
    struct NFTCreated has copy, drop {
        id: ID,
        creator: address,
        name: String,
        image_url: String,
        description: String,
    }

    fun init(witness: NFT,ctx: &mut TxContext) {
        let keys = vector[
            utf8(b"name"),
            utf8(b"image_url"),
            utf8(b"description"),
        ];
        let values = vector[
            utf8(b"{name}"),
            utf8(b"{image_url}"),
            utf8(b"description"),
        ];

        let publisher = package::claim(witness, ctx);
        let display = display::new_with_fields<MyNFT>(&publisher, keys, values, ctx);
        let sender = tx_context::sender(ctx);

        display::update_version(&mut display);

        transfer::public_transfer(publisher, sender );
        transfer::public_transfer(display, sender );
    }

     public entry fun create_nft(name: String,image_url:String,description: String,recipient: address, ctx: &mut TxContext) {
       let sender = tx_context::sender(ctx);
        let nft = MyNFT {
            id: object::new(ctx),
            name: name,
            image_url: image_url,
            description: description,
        };

        // emit a event
        event::emit(NFTCreated{
            id: object::id(&nft),
            creator: sender,
            name: nft.name,
            image_url: nft.image_url,
            description: nft.description,
        });

        transfer::public_transfer(nft, recipient)
    }
}