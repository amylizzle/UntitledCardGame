/obj/cardholder
    icon = 'icons/cards.dmi'
    icon_state = "cardslot_player"
    mouse_opacity = 2
    plane = PLANE_BOARD_OBJECTS
    var/obj/card/card = null
    var/obj/cardholder/opposed_cardholder
    //this cardholder's twin on the other players board
    var/obj/cardholder/twin_cardholder
    var/obj/highlight/highlight
    var/mutable_appearance/return_appearance


    New()
        .=..()
        icon = null
        icon_state = null
        //register with the board after board.New() completes
        to_register += src
        return_appearance = src.appearance

    proc/SetCard(var/obj/card/card)
        world.log << "player card"
        src.card = card
        src.twin_cardholder.card = card
        card.pixel_x = src.pixel_x
        card.pixel_y = src.pixel_y
        card.loc = src.loc 
        NotifyChange()     

    proc/Highlight(var/on = TRUE)
        if(on)
            icon = 'icons/cards.dmi'
            icon_state = "highlight"
        else
            icon = null
            icon_state = null

    proc/NotifyChange()
        if(card && card.health > 0)
            twin_cardholder.appearance = card.appearance
        else
            twin_cardholder.appearance = twin_cardholder.return_appearance

    proc/DoTurn()
        if(!card)
            return
        if(opposed_cardholder.card)
            card.AttackCard(opposed_cardholder.card)
            opposed_cardholder.NotifyChange()
            src.NotifyChange()
        else
            card.AttackPlayer()



    Click(location, control, params)
        . = ..()
        if(boards[src.z].selected)
            boards[src.z].PlayCard(usr, boards[src.z].selected, src)

/obj/cardholder/opponent
    icon_state = "cardslot_opponent"

