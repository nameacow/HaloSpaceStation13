/obj/item/weapon/grenade
	name = "grenade"
	desc = "A hand held grenade, with an adjustable timer."
	w_class = ITEM_SIZE_SMALL
	icon = 'icons/obj/grenade.dmi'
	icon_state = "grenade"
	item_state = "grenade"
	throw_speed = 4
	throw_range = 20
	flags = CONDUCT
	slot_flags = SLOT_BELT
	var/active = 0
	var/det_time = 50
	var/starttimer_on_hit = 0
	var/arm_sound = 'sound/weapons/armbomb.ogg'
	var/can_adjust_timer = 1

	var/alt_explosion_damage_max = 500 //The amount of armour + shield piercing damage done when grenade is stuck inside someone.
	var/alt_explosion_damage_cap = 15 //How much damage can the alt-explosion apply in one instance.
	var/multiplier_non_direct = 1 //The multiplier to apply to the alt explosion max damage if the grenade is not directly on top of or inside someone.
	var/alt_explosion_range = -1 //if set to -1, no armor bypass explosion

/obj/item/weapon/grenade/proc/clown_check(var/mob/living/user)
	if((CLUMSY in user.mutations) && prob(50))
		to_chat(user, "<span class='warning'>Huh? How does this thing work?</span>")

		activate(user)
		add_fingerprint(user)
		spawn(5)
			detonate()
		return 0
	return 1


/*/obj/item/weapon/grenade/afterattack(atom/target as mob|obj|turf|area, mob/user as mob)
	if (istype(target, /obj/item/weapon/storage)) return ..() // Trying to put it in a full container
	if (istype(target, /obj/item/weapon/gun/grenadelauncher)) return ..()
	if((user.get_active_hand() == src) && (!active) && (clown_check(user)) && target.loc != src.loc)
		to_chat(user, "<span class='warning'>You prime the [name]! [det_time/10] seconds!</span>")
		active = 1
		icon_state = initial(icon_state) + "_active"
		playsound(loc, 'sound/weapons/armbomb.ogg', 75, 1, -3)
		spawn(det_time)
			detonate()
			return
		user.set_dir(get_dir(user, target))
		user.drop_item()
		var/t = (isturf(target) ? target : target.loc)
		walk_towards(src, t, 3)
	return*/


/obj/item/weapon/grenade/examine(mob/user)
	. = ..(user, 0)
	if(starttimer_on_hit)
		to_chat(user,"The timer starts when [src] impacts a surface.")
	if(.)
		if(det_time > 1)
			to_chat(user, "The timer is set to [det_time/10] seconds.")
			return
		if(det_time == null)
			return
		to_chat(user, "\The [src] is set for instant detonation.")


/obj/item/weapon/grenade/attack_self(mob/user as mob)
	if(!active)
		if(clown_check(user))
			to_chat(user, "<span class='warning'>You prime \the [name]! [det_time/10] seconds!</span>")

			activate(user)
			add_fingerprint(user)
			if(iscarbon(user))
				var/mob/living/carbon/C = user
				C.throw_mode_on()
			user.disrupt_cloak_if_required(cloak_disrupt)//Always disrupt on throws.
	return

/obj/item/weapon/grenade/proc/start_timer()
	spawn()
		for(var/i=0, i<det_time, i++)
			sleep(1-clamp(max(0,world.tick_usage-100)*0.01,0,0.5))
		detonate()

/obj/item/weapon/grenade/proc/activate(mob/user as mob)
	if(active)
		return

	if(user)
		msg_admin_attack("[user.name] ([user.ckey]) primed \a [src] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

	icon_state = initial(icon_state) + "_active"
	active = 1
	playsound(loc, arm_sound, 75, 0, -3)

	if(!starttimer_on_hit)
		start_timer()
		return


/obj/item/weapon/grenade/proc/detonate()
//	playsound(loc, 'sound/items/Welder2.ogg', 25, 1)
	var/turf/T = get_turf(src)
	if(T)
		T.hotspot_expose(700,125)


/obj/item/weapon/grenade/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(isscrewdriver(W) && can_adjust_timer)
		switch(det_time)
			if (1)
				det_time = 10
				to_chat(user, "<span class='notice'>You set the [name] for 1 second detonation time.</span>")
			if (10)
				det_time = 30
				to_chat(user, "<span class='notice'>You set the [name] for 3 second detonation time.</span>")
			if (30)
				det_time = 50
				to_chat(user, "<span class='notice'>You set the [name] for 5 second detonation time.</span>")
			if (50)
				det_time = 1
				to_chat(user, "<span class='notice'>You set the [name] for instant detonation.</span>")
		add_fingerprint(user)
	..()
	return

/obj/item/weapon/grenade/proc/do_alt_explosion() //ex act is for plasnades
	if(alt_explosion_range == -1)
		return 0

	for(var/mob/living/m in range(alt_explosion_range,loc))
		var/mult = 1
		if(multiplier_non_direct != mult && get_turf(m) != get_turf(loc))
			mult = multiplier_non_direct
		var/dmg_max = alt_explosion_damage_max * mult
		while(dmg_max > 0)
			var/amt_dealt = min(alt_explosion_damage_cap,dmg_max)
			m.adjustFireLoss(amt_dealt)
			dmg_max -= amt_dealt
		m.updatehealth()
		m.UpdateAppearance()
	return 1

/obj/item/weapon/grenade/attack_hand()
	walk(src, null, null)
	..()
	return

/obj/item/weapon/grenade/throw_impact(var/atom/hit)
	if(active == 1 && starttimer_on_hit)
		active = 2
		start_timer()
	. = ..()
