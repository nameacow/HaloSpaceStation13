/obj/machinery/camera/network/engineering
	network = NETWORK_ENGINEERING

/obj/machinery/camera/network/ert
	network = NETWORK_ERT

/obj/machinery/camera/network/medbay
	network = NETWORK_MEDICAL

/obj/machinery/camera/network/mercenary
	network = NETWORK_MERCENARY

/obj/machinery/camera/network/mining
	network = NETWORK_MINE

/obj/machinery/camera/network/research
	network = NETWORK_RESEARCH

/obj/machinery/camera/network/security
	network = NETWORK_SECURITY

/obj/machinery/camera/network/thunder
	network = NETWORK_THUNDER

// EMP

/obj/machinery/camera/emp_proof/Initialize()
	..()
	. = upgradeEmpProof()

// X-RAY

/obj/machinery/camera/xray
	icon_state = "xraycam" // Thanks to Krutchen for the icons.

/obj/machinery/camera/xray/Initialize()
	..()
	. = upgradeXRay()

// MOTION

/obj/machinery/camera/motion/Initialize()
	..()
	. = upgradeMotion()

// ALL UPGRADES

/obj/machinery/camera/all/Initialize()
	. = ..()
	upgradeEmpProof()
	upgradeXRay()
	upgradeMotion()

// AUTONAME
/obj/machinery/camera/autoname
	var/number = 0 //camera number in area

//This camera type automatically sets it's name to whatever the area that it's in is called.
/obj/machinery/camera/autoname/New()
	..()
	spawn(10)
		number = 1
		var/area/A = get_area(src)
		if(A)
			for(var/obj/machinery/camera/autoname/C in world)
				if(C == src) continue
				var/area/CA = get_area(C)
				if(CA.type == A.type)
					if(C.number)
						number = max(number, C.number+1)
			c_tag = "[A.name] #[number]"
		invalidateCameraCache()


// CHECKS

/obj/machinery/camera/proc/isEmpProof()
	var/O = locate(/obj/item/stack/material/osmium) in assembly.upgrades
	return O

/obj/machinery/camera/proc/isXRay()
	var/obj/item/weapon/stock_parts/scanning_module/O = locate(/obj/item/weapon/stock_parts/scanning_module) in assembly.upgrades
	if (O && O.rating >= 2)
		return O
	return null

/obj/machinery/camera/proc/isMotion()
	var/O = locate(/obj/item/device/assembly/prox_sensor) in assembly.upgrades
	return O

// UPGRADE PROCS

/obj/machinery/camera/proc/upgradeEmpProof()
	assembly.upgrades.Add(new /obj/item/stack/material/osmium(assembly))
	setPowerUsage()
	update_coverage()

/obj/machinery/camera/proc/upgradeXRay()
	assembly.upgrades.Add(new /obj/item/weapon/stock_parts/scanning_module/adv(assembly))
	setPowerUsage()
	update_coverage()

/obj/machinery/camera/proc/upgradeMotion()
	assembly.upgrades.Add(new /obj/item/device/assembly/prox_sensor(assembly))
	setPowerUsage()
	START_PROCESSING(SSmachines,src)
	update_coverage()

/obj/machinery/camera/proc/setPowerUsage()
	var/mult = 1
	if (isXRay())
		mult++
	if (isMotion())
		mult++
	active_power_usage = mult*initial(active_power_usage)
