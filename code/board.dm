/datum/board
    var/mob/player/player1
    var/mob/player/player2
    var/z_level = -1

    New(var/z_level, var/client/c1, var/client/c2)
        //if(!isnum(z_level) || !istype(c1) || !istype(c2))
        //    throw EXCEPTION("invalid args for new board ([z_level],[c1],[c2])")
        src.z_level = z_level
        //load map and clear all turfs
        var/dmm_suite/reader = new()
        reader.read_map(file2text(pick(possible_map_files)), 1, 1, src.z_level, flags=DMM_OVERWRITE_MOBS|DMM_OVERWRITE_OBJS)
        player1 = new(locate(7,4,src.z_level), src)
        player2 = new(locate(7,4,src.z_level), src)

        player1.client = c1
        player2.client = c2
        StartGame()


    proc/Tick()

    proc/EndTurn()
    
    proc/StartGame()
        //draw a starting hand
        for(var/i = 1 to 3)
            player1.Draw()
            player2.Draw()

    proc/EndGame()
        var/mob/lobby_player/player
        if(player1.client)
            player = new()
            player.client = player1.client
        if(player2.client)
            player = new()
            player.client = player2.client

    proc/RenderHands()
        var/pixel_offset = -64
        player1.client?.images = null
        player2.client?.images = null
        for(var/obj/card/c in player1.hand)
            c.pixel_x = pixel_offset
            pixel_offset += 10
            player1.client?.images += c.inhand_client_image
            player2.client?.images += c.opponent_client_image
              
        for(var/obj/card/c in player2.hand)
            c.pixel_x = pixel_offset
            pixel_offset += 10
            player2.client?.images += c.inhand_client_image
            player1.client?.images += c.opponent_client_image
              
    proc/PlayCard(var/mob/player/player, var/obj/card/card)
        player.hand -= card
        card.loc = locate(5,3,src.z_level)
        card.FaceUpForPlay()
        RenderHands()