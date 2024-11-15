/datum/board
    var/mob/player/player1
    var/mob/player/player2
    //these lists handle the cards played to the board - they are organised as <player viewing the cards>_<player who's cards they are>
    var/list/obj/cardholder/player1_player1cards[LANE_COUNT]
    var/list/obj/cardholder/opponent/player1_player2cards[LANE_COUNT]
    var/list/obj/cardholder/player2_player2cards[LANE_COUNT]
    var/list/obj/cardholder/opponent/player2_player1cards[LANE_COUNT]

    var/z_level_player1 = -1
    var/z_level_player2 = -1
    var/gamestate = GAME_STATE_PREINIT
    var/obj/card/selected

    New(var/z_level, var/client/c1, var/client/c2)
        //if(!isnum(z_level) || !istype(c1) || !istype(c2))
        //    throw EXCEPTION("invalid args for new board ([z_level],[c1],[c2])")
        src.z_level_player1 = z_level
        src.z_level_player2 = z_level + 1
        if(world.maxz < src.z_level_player2)
            world.maxz = src.z_level_player2
        //load map and clear all turfs
        var/dmm_suite/reader = new()
        reader.read_map(file2text(pick(possible_map_files)), 1, 1, src.z_level_player1, flags=DMM_OVERWRITE_MOBS|DMM_OVERWRITE_OBJS)
        reader.read_map(file2text(pick(possible_map_files)), 1, 1, src.z_level_player2, flags=DMM_OVERWRITE_MOBS|DMM_OVERWRITE_OBJS)
        
        player1 = new(locate(world.maxx/2,4,src.z_level_player1), src)
        player2 = new(locate(world.maxx/2,4,src.z_level_player2), src)
        player1.opponent = player2
        player2.opponent = player1
        player1.client = c1
        player2.client = c2
        

    proc/RegisterCardholder(var/obj/cardholder/ch)
        var/list/obj/cardholder/holders 
        if(istype(ch, /obj/cardholder/opponent))
            if(ch.z == z_level_player1)
                holders = player1_player2cards
            else
                holders = player2_player1cards
        else
            if(ch.z == z_level_player1)
                holders = player1_player1cards
            else
                holders = player2_player2cards
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
            gamestate = GAME_STATE_PLAYER1


    proc/EndTurn()
        //do the active cards
        if(gamestate == GAME_STATE_PLAYER1)
            for(var/obj/cardholder/ch in player1_player1cards)
                ch.DoTurn()
        else if(gamestate == GAME_STATE_PLAYER2)
            for(var/obj/cardholder/ch in player2_player2cards)
                ch.DoTurn()

        //reset turn timer

        //swap active player and draw a card
        if(gamestate == GAME_STATE_PLAYER1)
            gamestate = GAME_STATE_PLAYER2
            Draw(player2)
        else if(gamestate == GAME_STATE_PLAYER2)
            gamestate = GAME_STATE_PLAYER1
            Draw(player1)
    
    proc/StartGame()
        for(var/obj/cardholder/ch in to_register)
            if(ch.z == src.z_level_player1 || ch.z == src.z_level_player2)
                src.RegisterCardholder(ch)
        //ensure the lanes are setup
        for(var/i = 1 to LANE_COUNT)
            if(isnull(player1_player1cards[i]) || isnull(player1_player2cards[i]) || isnull(player2_player1cards[i]) || isnull(player2_player1cards[i]))
                throw EXCEPTION("not enough cardholders in row")
            player1_player1cards[i].opposed_cardholder = player1_player2cards[i]
            player1_player1cards[i].twin_cardholder = player2_player1cards[i]

            player1_player2cards[i].opposed_cardholder = player1_player1cards[i]
            player1_player2cards[i].twin_cardholder = player2_player2cards[i]

            player2_player1cards[i].opposed_cardholder = player2_player2cards[i]
            player2_player1cards[i].twin_cardholder = player1_player1cards[i]

            player2_player2cards[i].opposed_cardholder = player1_player1cards[i]
            player2_player2cards[i].twin_cardholder = player1_player2cards[i]

        //populate decks
        for(var/i = 1 to 10)
            player1.deck += new /obj/card(null, player1)
            player2.deck += new /obj/card(null, player2)

        //draw a starting hand
        for(var/i = 1 to 3)
            src.Draw(player1)
            src.Draw(player2)

    proc/EndGame()
        var/mob/lobby_player/player
        if(player1.client)
            player = new()
            player.client = player1.client
        if(player2.client)
            player = new()
            player.client = player2.client

    proc/Draw(var/mob/player/player) 
        //pick a card from the deck
        if(length(player.deck) == 0)
            return
        var/obj/card/drawn = player.deck[length(player.deck)]
        player.deck.len-- 
        //put it in the hand of the drawing player
        player.hand += drawn
        drawn.loc = locate(world.maxx/2, 1, player.z)
        //create a face-down card in the other player's view
        drawn.opponent_facedown = new(locate(world.maxx/2, world.maxy, player == player1 ? player2.z : player1.z), player)
        //animate both moving from deck to hand

        //rebalance hands
        RecalculateHandSpacing()

    proc/RecalculateHandSpacing()
        //special case for single cards
        if(length(player1.hand) == 1)
            player1.hand[1].pixel_x = 0
            player1.hand[1].opponent_facedown.pixel_x = 0
        else
            var/deltax = min((7*world.icon_size)/(length(player1.hand)+1),32)
            var/total_length = length(player1.hand) * deltax
            for(var/i in 1 to length(player1.hand))
                player1.hand[i].pixel_x = (world.maxx/2) - (total_length/2) + ((i-1) * deltax)
                player1.hand[i].opponent_facedown.pixel_x = (world.maxx/2) - (total_length/2) + ((i-1) * deltax)

        if(length(player2.hand) == 1)
            player2.hand[1].pixel_x = 0
            player2.hand[1].opponent_facedown.pixel_x = 0
        else
            var/deltax = min((7*world.icon_size)/(length(player2.hand)+1),32)
            var/total_length = length(player2.hand) * deltax
            for(var/i in 1 to length(player2.hand))
                player2.hand[i].pixel_x = (world.maxx/2) - (total_length/2) + ((i-1) * deltax)
                player2.hand[i].opponent_facedown.pixel_x = (world.maxx/2) - (total_length/2) + ((i-1) * deltax)

              
    proc/SelectCard(var/mob/player/player, var/obj/card/card)
        if((gamestate == GAME_STATE_PLAYER1 && player != player1) || (gamestate == GAME_STATE_PLAYER2 && player != player2) || card.owner != player)
            return
        var/list/obj/cardholder/ch_list 
        if(player == src.player1)
            ch_list = player1_player1cards
        else
            ch_list = player2_player2cards
        for(var/i in 1 to LANE_COUNT)
            if(isnull(ch_list[i].card))
                ch_list[i].Highlight()
        selected = card
        world.log << "filters"

    proc/PlayCard(var/mob/player/player, var/obj/card/card, var/obj/cardholder/holder)
        world.log << "playing"
        player.hand -= card
        del(card.opponent_facedown)
        holder.SetCard(card)
        src.selected = null
        if(player == player1)
            for(var/obj/cardholder/ch in player1_player1cards)
                ch.Highlight(FALSE)
        else
            for(var/obj/cardholder/ch in player2_player2cards)
                ch.Highlight(FALSE)
        RecalculateHandSpacing()

