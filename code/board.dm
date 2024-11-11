/datum/board
    var/mob/player/player
    var/mob/player/opponent
    var/list/obj/cardholder/playercards[LANE_COUNT]
    var/list/obj/cardholder/opponentcards[LANE_COUNT]
    var/z_level = -1
    var/gamestate = GAME_STATE_PREINIT
    var/obj/card/selected

    New(var/z_level, var/client/c1, var/client/c2)
        //if(!isnum(z_level) || !istype(c1) || !istype(c2))
        //    throw EXCEPTION("invalid args for new board ([z_level],[c1],[c2])")
        src.z_level = z_level
        if(world.maxz < src.z_level)
            world.maxz = src.z_level
        //load map and clear all turfs
        var/dmm_suite/reader = new()
        reader.read_map(file2text(pick(possible_map_files)), 1, 1, src.z_level, flags=DMM_OVERWRITE_MOBS|DMM_OVERWRITE_OBJS)
        
        player = new(locate(world.maxx/2,world.maxy/2,src.z_level), src)
        opponent = new(locate(world.maxx/2,world.maxy/2,src.z_level), src)

        player.client = c1
        opponent.client = c2
        

    proc/RegisterCardholder(var/obj/cardholder/ch)
        var/list/obj/cardholder/holders 
        if(istype(ch, /obj/cardholder/opponent))
            holders = opponentcards
        else
            holders = playercards
        //insertion sort
        for(var/i = 1 to LANE_COUNT)
            if(!holders[i])
                holders[i] = ch
                return
            if(ch.loc.x < holders[i].loc.x)
                var/obj/cardholder/swap = holders[i]
                holders[i] = ch
                ch = swap
        throw EXCEPTION("too many cardholders in row")

    proc/Tick()
        if(gamestate == GAME_STATE_PREINIT)
            StartGame()
            gamestate = GAME_STATE_PLAYER


    proc/EndTurn()
    
    proc/StartGame()
        for(var/obj/cardholder/ch in to_register)
            if(ch.z == src.z_level)
                src.RegisterCardholder(ch)
        //ensure the lanes are setup
        for(var/i = 1 to LANE_COUNT)
            if(isnull(playercards[i]) && isnull(opponentcards[i]))
                throw EXCEPTION("not enough cardholders in row")
            playercards[i].opposed_cardholder = opponentcards[i]
            opponentcards[i].opposed_cardholder = playercards[i]

        //draw a starting hand
        for(var/i = 1 to 3)
            player.Draw()
            opponent.Draw()

    proc/EndGame()
        var/mob/lobby_player/player
        if(player.client)
            player = new()
            player.client = player.client
        if(opponent.client)
            player = new()
            player.client = opponent.client

    proc/RenderHands()
        var/pixel_offset = -64
        player.client?.images = null
        opponent.client?.images = null
        for(var/obj/card/c in player.hand)
            c.pixel_x = pixel_offset
            pixel_offset += 10
            player.client?.images += c.inhand_client_image
            opponent.client?.images += c.opponent_client_image
              
        for(var/obj/card/c in opponent.hand)
            c.pixel_x = pixel_offset
            pixel_offset += 10
            opponent.client?.images += c.inhand_client_image
            player.client?.images += c.opponent_client_image

        for(var/obj/cardholder/ch in playercards)
            player.client?.images += ch.player_client_image
            opponent.client?.images += ch.opponent_client_image

        for(var/obj/cardholder/ch in opponentcards)
            player.client?.images += ch.player_client_image
            opponent.client?.images += ch.opponent_client_image
              
    proc/SelectCard(var/mob/player/player, var/obj/card/card)
        var/list/obj/cardholder/ch_list 
        if(player == src.player)
            ch_list = playercards
        else
            ch_list = opponentcards
        for(var/i in 1 to LANE_COUNT)
            if(isnull(ch_list[i].card))
                playercards[i].Highlight()
        selected = card
        world.log << "filters"

    proc/PlayCard(var/mob/player/player, var/obj/card/card, var/obj/cardholder/holder)
        world.log << "playing"
        player.hand -= card
        card.FaceUpForPlay()
        if(player == src.player)
            holder.SetCard(card)
        else
            holder.opposed_cardholder.SetCard(card)
        RenderHands()
        for(var/obj/cardholder/ch in playercards)
            ch.Highlight(FALSE)
        for(var/obj/cardholder/ch in opponentcards)
            ch.Highlight(FALSE)
        world.log << "done"