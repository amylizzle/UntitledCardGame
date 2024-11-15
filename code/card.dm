/obj/card
    icon = 'icons/cards.dmi'
    icon_state = "front_blank"
    plane = PLANE_CARDS
    var/mob/player/owner 
    //handle to this card's facedown copy in the opponents view
    var/obj/facedown_card/opponent_facedown
    var/obj/cardholder/holder = null

    var/health = 1
    var/attack = 1

    New(loc, owning_player)
        .=..()
        owner = owning_player

    Click(location, control, params)
        . = ..()
        if(src in owner.hand)
            owner.board.SelectCard(owner,src)   

    proc/AttackCard(var/obj/cardholder/holder, var/obj/cardholder/opponent/opposing_holder)
        new /datum/card_effect/basic_card_attack(holder)        
        opposing_holder.card.TakeDamage(attack)
        
    proc/AttackPlayer(var/obj/cardholder/holder, var/mob/player/attacked)
        new /datum/card_effect/basic_player_attack(holder, attacked)
        attacked.TakeDamage(attack)

    proc/TakeDamage(var/damage)
        health -= damage
        
        if(health <= 0)            
            del(src)

/obj/facedown_card
    icon = 'icons/cards.dmi'
    icon_state = "back_blank"

    New(loc, var/mob/player/owning_player)
        .=..()
        icon = owning_player.cardback_icon
        icon_state = owning_player.cardback_iconstate
        transform = matrix(180, MATRIX_ROTATE)