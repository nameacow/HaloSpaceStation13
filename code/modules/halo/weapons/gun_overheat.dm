
#define FULLCLEAR_OVERHEAT_MODIFIER 2 //The multiplier to apply when the weapon fully overheats

/obj/item/weapon/gun
	var/overheat_fullclear_delay = 3 SECONDS //The time it takes from gaining heat to the heat accumulated being wiped
	var/overheat_fullclear_at = 0
	var/overheat_sfx = null
	var/overheat_capacity = -1
	var/heat_current = 0
	var/datum/progressbar/heat_bar
	var/heat_per_shot = 1

/obj/item/weapon/gun/Process()

	if(process_heat())
		return

	return PROCESS_KILL

/obj/item/weapon/gun/proc/process_heat()
	if(heat_current > 0)

		//are we overheated?
		if(overheat_fullclear_at)
			if(world.time >= overheat_fullclear_at)
				clear_overheat()
				color = initial(color)
			else if(heat_current == overheat_capacity)
				//flash red and yellow
				if(color == "#ff0000")
					color = "#ffa500"
				else
					color = "#ff0000"

			if(ismob(loc))	//update icons so guns flash in-hand
				var/mob/living/M = loc
				M.update_inv_belt(0)
				M.update_inv_s_store(0)
				M.update_inv_back(0)
				M.update_inv_l_hand(0)
				M.update_inv_r_hand(1)

		//continue processing
		return 1

	//stop processing
	return 0

/obj/item/weapon/gun/proc/add_heat(var/new_val)
	heat_current = min(overheat_capacity,heat_current + new_val)

	if(heat_current > 0)
		if(!heat_bar)
			heat_bar = new (src.loc, overheat_capacity, src)
			START_PROCESSING(SSobj, src)
		heat_bar.update(heat_current)

		if(heat_current >= overheat_capacity)
			do_overheat()
		else if(new_val > 0)
			overheat_fullclear_at = world.time + overheat_fullclear_delay
	else
		qdel(heat_bar)
		heat_bar = null
		STOP_PROCESSING(SSobj, src)

/obj/item/weapon/gun/proc/overheat_sfx(var/origin)
	if(overheat_sfx)
		playsound(origin,overheat_sfx,100,1)

/obj/item/weapon/gun/proc/do_overheat()
	overheat_fullclear_at = world.time + overheat_fullclear_delay * FULLCLEAR_OVERHEAT_MODIFIER
	heat_current = overheat_capacity
	var/mob/M = src.loc
	if(M)
		visible_message("\icon[src] <span class = 'warning'>[M]'s [src] overheats!</span>",\
			"\icon[src] <span class = 'warning'>Your [src] overheats!</span>",)
	else
		visible_message("\icon[src] <span class = 'warning'>[src] overheats!</span>")
	overheat_sfx(M)

/obj/item/weapon/gun/proc/clear_overheat()
	overheat_fullclear_at = 0
	heat_current = 0
	if(heat_bar)
		qdel(heat_bar)
		heat_bar = null

/obj/item/weapon/gun/proc/check_overheat()
	if(overheat_capacity > 0 && heat_current >= overheat_capacity)
		to_chat(src.loc,"\icon[src] <span class='warning'>[src] clunks as you pull the trigger, \
			it has overheated and needs to ventilate heat...</span>")
		overheat_sfx(src.loc)
		return 1
	return 0

#undef FULLCLEAR_OVERHEAT_MODIFIER
