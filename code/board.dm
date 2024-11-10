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
        player1 = new()
        player2 = new()

        player1.loc = locate(7,1,src.z_level)
        
        player2.loc = locate(7,7,src.z_level)

        player1.client = c1
        player2.client = c2

    proc/Tick()

    proc/EndTurn()
    
    proc/EndGame()
        var/mob/lobby_player/player
        if(player1.client)
            player = new()
            player.client = player1.client
        if(player2.client)
            player = new()
            player.client = player2.client

