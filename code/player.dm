/mob/player
    name = "player"
    icon = 'icons/profile_frame.dmi'
    icon_state = "frame"
    var/cardback_icon = 'icons/cards.dmi'
    var/cardback_iconstate = "back_blank"
    var/list/obj/card/hand = list()
    var/list/obj/card/deck = list()
    var/datum/board/board

    var/health = 7
    var/obj/health_indicator/health_indicator
    var/obj/stamina_indicator/stamina_indicator

    New(loc, board)
        .=..(loc)
        src.board = board
        src.health_indicator = new(get_step(src, WEST), src)
        src.stamina_indicator = new(get_step(get_step(src, EAST), EAST), src)



        
