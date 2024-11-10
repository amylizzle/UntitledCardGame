/mob/lobby_player
    name = "lobby player"

    Logout()
        . = ..()
        world.waiting_players -= src

    Login()
        . = ..()
        world.waiting_players += src