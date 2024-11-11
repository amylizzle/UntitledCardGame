/obj/cardholder
    icon = 'icons/cards.dmi'
    icon_state = "cardslot_player"
    mouse_opacity = 2
    var/obj/card/card = null
    var/image/opponent_client_image
    var/image/player_client_image
    var/obj/cardholder/opposed_cardholder
    var/obj/highlight/highlight

    New()
        .=..()
        icon = null
        icon_state = null
        //register with the board after board.New() completes
        to_register += src

    proc/SetCard(var/obj/card/card)
        world.log << "player card"
        src.card = card
        card.loc = src
        opponent_client_image = image(card.inhand_icon, card.inhand_icon_state)
        opponent_client_image.loc = src
        opponent_client_image.override = TRUE
        player_client_image = image(card.inhand_icon, card.inhand_icon_state)
        player_client_image.loc = src
        player_client_image.override = TRUE
        
        opponent_client_image.pixel_y = (opposed_cardholder.y - src.y) * world.icon_size
        player_client_image.pixel_y = 0

    proc/Highlight(var/on = TRUE)
        if(on)
            src.highlight = new /obj/highlight(src.loc, src)
        else
            del(src.highlight)

    Click(location, control, params)
        . = ..()
        if(boards[src.z].selected)
            boards[src.z].PlayCard(usr, boards[src.z].selected, src)

/obj/cardholder/opponent
    icon_state = "cardslot_opponent"

    SetCard(obj/card/card)
        . = ..()
        world.log << "opponent card"
        opponent_client_image.pixel_y = (opposed_cardholder.y - src.y) * world.icon_size
        player_client_image.pixel_y = 0

/obj/highlight
    icon = 'icons/cards.dmi'
    icon_state = "highlight"
    mouse_opacity = 2
    var/obj/cardholder/parent

    New(loc, var/obj/cardholder/parent)
        .=..()
        src.parent = parent

    Click(location, control, params)
        parent.Click(location, control, params)