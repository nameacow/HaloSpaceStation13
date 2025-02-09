
#define PLANETFALL_BOUND_PADDING 10 //How many extra tiles to add to our bounds
#define CRASHLAND_DELETE_OBJS list(/obj/effect/landmark/start,/obj/machinery/overmap_weapon_console,/obj/machinery/shuttle_spawner)

/obj/effect/overmap/ship
	var/obj/effect/overmap/old_om_type
	var/obj/effect/overmap/landed_on = null

/obj/effect/overmap/ship/proc/remove_important_objs(var/turf/t)
	var/list/spawntypes = spawntypes() //Remove all logged spawnpoints so nobody spawns on this area.
	for(var/spawn_name in spawntypes)
		var/datum/spawnpoint/S = spawntypes[spawn_name]
		S.turfs -= t
	for(var/atom/a in t)
		for(var/type in CRASHLAND_DELETE_OBJS)
			if(istype(a,type))
				qdel(a)
				break

/obj/effect/overmap/ship/proc/do_crash_landing(var/obj/effect/overmap/planet,var/keep_umbilicals_active = 0)
	do_landing(planet,keep_umbilicals_active)
	if(old_om_type)
		qdel(old_om_type)

/obj/effect/overmap/ship/proc/do_landing(var/obj/effect/overmap/planet,var/keep_umbilicals_active = 0)
	set background = 1
	var/obj/effect/landmark/map_data/our_last = map_z_data[map_z_data.len]
	var/obj/effect/landmark/map_data/their_first = planet.map_z_data[1]
	if(!our_last || !their_first)
		return

	landed_on = planet
	/*
	our_last.below = their_first
	their_first.above = our_last*/

	//DO FLOORTURF GEN//
	//Now we pad the bounds a bit
	var/list/planetbounds = list(max(1,map_bounds[1] - PLANETFALL_BOUND_PADDING),min(255,map_bounds[2] + PLANETFALL_BOUND_PADDING),min(255,map_bounds[3] + PLANETFALL_BOUND_PADDING),max(1,map_bounds[4] - PLANETFALL_BOUND_PADDING))
	var/area/newoutside = new planet.parent_area_type (null)
	for(var/z_level in map_z)
		for(var/turf/t in block(locate(planetbounds[1],planetbounds[4],z_level),locate(planetbounds[3],planetbounds[2],z_level)))
			remove_important_objs(t)
			var/turf/space/space = t
			if(istype(space))
				newoutside.contents += space
				if(space.x == planetbounds[1] || space.x == planetbounds[3] || space.y == planetbounds[4] || space.y == planetbounds[2])
					space.ChangeTurf(/turf/unsimulated/mineral)
				else
					space.ChangeTurf(newoutside.base_turf)
	for(var/level in map_z)
		if(!old_om_type)
			old_om_type = map_sectors["[level]"]
		map_sectors["[level]"] = landed_on

	old_om_type.slipspace_status = 1 //Yes it's not in slipspace, but this is good enough to stop roundends
	old_om_type.loc = null
	if(keep_umbilicals_active)
		for(var/obj/docking_umbilical/u in world)
			if(u.our_ship == old_om_type)
				u.our_ship = landed_on

	//We should have screen shake happen on these.
	for(var/mob/m in GLOB.mobs_in_sectors[src])
		to_chat(m,"<span class = 'danger'>Your vessel's hull screeches as it slows to a stop on the ground...</span>")
		shake_camera(m, 1 SECOND, 2)

	for(var/mob/m in GLOB.mobs_in_sectors[planet])
		to_chat(m,"<span class = 'danger'>The sky is filled with the shape of [src]'s hull as it lands groundside...</span>")
		shake_camera(m, 0.5 SECONDS, 1)

/*
/obj/effect/overmap/ship/proc/exit_landing_state()
	if(!in_close_orbit)
		return
	var/obj/effect/landmark/map_data/our_last = map_z_data[map_z_data.len]
	var/obj/effect/landmark/map_data/their_first = in_close_orbit.map_z_data[1]

	our_last.below = null
	their_first.above = null

	var/list/planetbounds = in_close_orbit.map_bounds
	for(var/z_level in map_z)
		for(var/turf/t in block(locate(planetbounds[1],planetbounds[4],z_level),locate(planetbounds[3],planetbounds[2],z_level)))
			if(istype(t,/turf/simulated/open) || istype(t,/turf/unsimulated/mineral))
				t.ChangeTurf(/turf/space)
*/
#undef PLANETFALL_BOUND_PADDING
#undef CRASHLAND_DELETE_OBJS