/obj/endturn_button
    icon = 'icons/endturn.dmi'
    icon_state = "shitty"
    plane = PLANE_BOARD_OBJECTS

    Click(location, control, params)
        . = ..()
        boards[src.z].EndTurn()

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