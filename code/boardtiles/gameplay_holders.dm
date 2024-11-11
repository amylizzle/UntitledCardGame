/obj/cardholder
    icon = 'icons/cards.dmi'
    icon_state = "cardslot_player"
    mouse_opacity = 2
    var/obj/card/card = null
    var/image/opponent_client_image
    var/image/player_client_image

    New()
        .=..()
        icon = null
        icon_state = null
        //register with the board after board.New() completes
        spawn(1)
            boards[src.z].RegisterCardholder(src)

    proc/SetCard(var/obj/card/card)
        src.card = card
        opponent_client_image = image(card.inhand_icon, card.inhand_icon_state)
        opponent_client_image.loc = src
        opponent_client_image.override = TRUE
        player_client_image = image(card.inhand_icon, card.inhand_icon_state)
        player_client_image.loc = src
        player_client_image.override = TRUE
        
        opponent_client_image.pixel_y = 96
        player_client_image.pixel_y = 0

/obj/cardholder/opponent
    icon_state = "cardslot_opponent"

    SetCard(obj/card/card)
        . = ..()
        opponent_client_image.pixel_y = -96
        player_client_image.pixel_y = 0
