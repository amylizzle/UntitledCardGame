/mob/player
    name = "player"

    var/list/obj/card/hand = list()
    var/list/obj/card/deck = list()

    New()
        .=..()
        for(var/i = 1 to 10)
            deck += new /obj/card()
        //shuffle deck

        //draw a starting hand
        for(var/i = 1 to 3)
            Draw()

    Login()
        . = ..()
        UpdateAppearance()

    proc/Draw()
        if(length(deck) == 0)
            return
        hand += deck[length(deck)]
        deck.len--

    proc/UpdateAppearance()
        src.vis_contents = src.hand
        var/pixoffset = -64
        if(src.client)            
            for(var/obj/card/c in src.hand)
                c.pixel_x = pixoffset
                pixoffset += 16
                var/image/card_overlay = new /image(c.inhand_icon, c.inhand_icon_state)
                card_overlay.loc = c
                card_overlay.override = TRUE
                src.client.images += card_overlay
        
