    
var/global/list/mob/lobby_player/waiting_players = list()
var/global/list/datum/board/boards = list()


/world
    mob = /mob/lobby_player
    view = "13x13"
    turf = /turf/default
    
    Tick()
        . = ..()

        if(length(waiting_players) > 1 && length(boards) < MAX_SIMULTANEOUS_GAMES)
            var/mob/lobby_player/player1 = pick(waiting_players)
            waiting_players -= player1
            var/mob/lobby_player/player2 = pick(waiting_players)
            waiting_players -= player2

            var/datum/board/newgame = new(player1.client, player2.client)
            boards += newgame
        
        for(var/datum/board/b in boards)
            b.Tick()
        

        