/obj/card
    icon = 'icons/cards.dmi'
    icon_state = "front_blank"
    var/mob/player/owner 
    //handle to this card's facedown copy in the opponents view
    var/obj/facedown_card/opponent_facedown

    New(loc, owning_player)
        .=..()
        owner = owning_player

    Click(location, control, params)
        . = ..()
        world.log << "card clicked belonging to [owner.client?.key]"
        owner.board.SelectCard(owner,src)

/obj/facedown_card
    icon = 'icons/cards.dmi'
    icon_state = "back_blank"

    New(loc, var/mob/player/owning_player)
        .=..()
        icon = owning_player.cardback_icon
        icon_state = owning_player.cardback_iconstate