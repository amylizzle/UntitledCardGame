/obj/endturn_button
    icon = 'icons/endturn.dmi'
    icon_state = "shitty"
    plane = PLANE_BOARD_OBJECTS

    Click(location, control, params)
        . = ..()
        var/datum/board/board = boards[src.z]
        if(board.gamestate == GAME_STATE_PLAYER1 && usr == board.player1)
            board.EndTurn()
        else if(board.gamestate == GAME_STATE_PLAYER2 && usr == board.player2)
            board.EndTurn()

/obj/health_indicator
    var/mob/player/owner
    icon = 'icons/status.dmi'
    icon_state = "health7"
    plane = PLANE_BOARD_OBJECTS

    New(loc, owning_player)
        .=..()
        owner = owning_player

    proc/UpdateHealth()
        icon_state = "health[min(max(owner.health,0),7)]"

/obj/stamina_indicator
    var/mob/player/owner
    icon = 'icons/status.dmi'
    icon_state = "stamina0"
    plane = PLANE_BOARD_OBJECTS

    New(loc, owning_player)
        .=..()
        owner = owning_player

    proc/UpdateStamina()
        icon_state = "stamina[min(max(owner.health,0),5)]"