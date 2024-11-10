/datum/board
    var/mob/player/player1
    var/mob/player/player2
    var/z_level = -1

    New(var/client/c1, var/client/c2)
        player1 = new()
        player2 = new()

        player1.client = c1
        player2.client = c2

    
