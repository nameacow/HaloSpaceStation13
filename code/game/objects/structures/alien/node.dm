/obj/structure/alien/node
	name = "alien weed node"
	desc = "Some kind of strange, pulsating structure."
	icon_state = "weednode"
	health = 100
	layer = ABOVE_OBJ_LAYER

/obj/structure/alien/node/Initialize()
	..()
	START_PROCESSING(SSobj, src)

/obj/structure/alien/node/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/structure/alien/node/Process()
	if(locate(/obj/effect/plant) in loc)
		return
	new/obj/effect/plant(get_turf(src), plant_controller.seeds["xenomorph"], start_matured = 1)