/datum/card_effect
    New(var/obj/cardholder/holder)
        ActivePlayerEffect(holder)
        OpposingPlayerEffect(holder.opposed_cardholder.twin_cardholder)

    proc/ActivePlayerEffect(var/obj/cardholder/holder)

    proc/OpposingPlayerEffect(var/obj/cardholder/opponent/holder)

/datum/card_effect/basic_card_attack
    ActivePlayerEffect(var/obj/cardholder/holder)
        var/y = (holder.opposed_cardholder.y - holder.y)*world.icon_size
        animate(holder, time=30, pixel_y=y, easing=BACK_EASING)
        animate(time=10, pixel_y=0)

    OpposingPlayerEffect(var/obj/cardholder/opponent/holder)
        var/y = (holder.opposed_cardholder.y - holder.y)*world.icon_size
        animate(holder, time=30, pixel_y=y, easing=BACK_EASING)
        animate(time=10, pixel_y=0)

/datum/card_effect/basic_player_attack
    ActivePlayerEffect(var/obj/cardholder/holder)
        var/y = ((world.maxy-4) - holder.y)*world.icon_size
        var/x = (world.maxx/2 - holder.x)*world.icon_size
        animate(holder, time=30, pixel_y=y, pixel_x=x, easing=BACK_EASING)
        animate(time=10, pixel_y=0, pixel_y=0)

    OpposingPlayerEffect(var/obj/cardholder/opponent/holder)
        var/y = (4 - holder.y)*world.icon_size
        var/x = (world.maxx/2 - holder.x)*world.icon_size
        animate(holder, time=30, pixel_y=y, pixel_x=x, easing=BACK_EASING)
        animate(time=10, pixel_y=0, pixel_y=0)