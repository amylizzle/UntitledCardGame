/mob/player
    name = "player"
    var/cardback_icon = 'icons/cards.dmi'
    var/cardback_iconstate = "back_blank"
    var/list/obj/card/hand = list()
    var/list/obj/card/deck = list()
    var/datum/board/board

    New(loc, board)
        .=..(loc)
        src.board = board



        
