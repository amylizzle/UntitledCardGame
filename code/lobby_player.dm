/mob/lobby_player
    name = "lobby player"

    Logout()
        . = ..()
        waiting_players -= src

    Login()
        . = ..()
        waiting_players += src
        src.loc = locate(7,7,1)