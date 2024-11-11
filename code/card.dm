/obj/card
    icon = 'icons/cards.dmi'
    icon_state = "back_blank"
    var/inhand_icon = 'icons/cards.dmi'
    var/inhand_icon_state = "front_blank"
    var/image/inhand_client_image
    var/image/opponent_client_image
    var/mob/player/owner 

    New(loc, owning_player)
        .=..()
        owner = owning_player
        inhand_client_image = image(inhand_icon, inhand_icon_state)
        inhand_client_image.loc = src
        inhand_client_image.override = TRUE
        inhand_client_image.pixel_y = -world.maxy/2 * world.icon_size
        opponent_client_image = image(icon, icon_state)
        opponent_client_image.loc = src
        opponent_client_image.override = TRUE
        opponent_client_image.pixel_y = world.maxy/2 * world.icon_size
        opponent_client_image.transform = matrix(180, MATRIX_ROTATE)

    Click(location, control, params)
        . = ..()
        world.log << "card clicked belonging to [owner.client?.key]"
        