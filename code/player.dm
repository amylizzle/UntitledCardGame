/mob/player
    name = "player"

    var/list/obj/card/hand = list()
    var/list/obj/card/deck = list()
    var/datum/board/board

    New(loc, board)
        .=..(loc)
        src.board = board
        for(var/i = 1 to 10)
            deck += new /obj/card(null, src)
        //shuffle deck

    Login()
        . = ..()
        board.RenderHands()

    proc/Draw()
        if(length(deck) == 0)
            return
        var/obj/card/draw = deck[length(deck)]
        hand += draw
        draw.loc = src.loc
        deck.len--
        board.RenderHands()


        
