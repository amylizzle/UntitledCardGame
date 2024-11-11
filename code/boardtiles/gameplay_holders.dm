/obj/cardholder
    icon = 'icons/cards.dmi'
    icon_state = "cardslot_player"
    var/obj/card/card = null
    var/image/opponent_client_image
    var/image/player_client_image

    New()
        .=..()
        icon = null
        icon_state = null

    proc/SetCard(var/obj/card/card)
        src.card = card
        opponent_client_image = image(card.inhand_icon, card.inhand_icon_state)
        opponent_client_image.loc = src
        opponent_client_image.override = TRUE
        player_client_image = image(card.inhand_icon, card.inhand_icon_state)
        player_client_image.loc = src
        player_client_image.override = TRUE
        
/obj/cardholder/opponent
    icon_state = "cardslot_opponent"