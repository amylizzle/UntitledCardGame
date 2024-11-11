    
var/global/list/mob/lobby_player/waiting_players = list()
var/global/list/datum/board/boards[MAX_SIMULTANEOUS_GAMES]
var/global/list/possible_map_files = list()
var/global/list/cardholder/to_register = list()

/world
    mob = /mob/lobby_player
    view = "21x21"
    turf = /turf/default
    
    New()
        //waiting_players += new /mob/lobby_player()
        possible_map_files += "maps/boards/basic_board.dmm" //TODO do this properly
        DoTick()

    proc/DoTick() //TODO use Tick() when OD implements it
        if(length(waiting_players) > 1)
            world.log << "enough players for a game"
            var/z = GetAvailableZLevel()
            if(z == -1)
                world.log << "too many games active right now"
            else    
                var/mob/lobby_player/player1 = pick(waiting_players)
                waiting_players -= player1
                var/mob/lobby_player/player2 = pick(waiting_players)
                waiting_players -= player2

                var/datum/board/newgame = new(z, player1.client, player2.client)
                boards[z] = newgame
                //no need to keep around their lobby mobs
                del(player1) 
                del(player2)
        
        for(var/datum/board/b in boards)
            b?.Tick()
        
        spawn(1)
            DoTick()
        

    proc/GetAvailableZLevel()
        //z level 1 is the lobby
        var/z = 1
        while(z < MAX_SIMULTANEOUS_GAMES)
            if(isnull(boards[z]))
                return z+1 //+1 to skip the lobby
            z++
        return -1


