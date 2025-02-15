/*
	Badges are worn on the belt or neck, and can be used to show that the holder is an authorized
	Security agent - the user details can be imprinted on holobadges with a Security-access ID card,
	or they can be emagged to accept any ID for use in disguises.
*/

/obj/item/clothing/accessory/badge
	name = "detective's badge"
	desc = "A simple badge, made from gold."
	icon_state = "goldbadge"
	slot_flags = SLOT_BELT | SLOT_TIE
	slot = ACCESSORY_SLOT_INSIGNIA
	var/stored_name
	var/badge_string = "Private Investigator"

/obj/item/clothing/accessory/badge/old
	name = "faded badge"
	desc = "A faded badge, backed with leather. Looks crummy."
	icon_state = "badge_round"

/obj/item/clothing/accessory/badge/proc/set_name(var/new_name)
	stored_name = new_name
	name = "[initial(name)] ([stored_name])"

/obj/item/clothing/accessory/badge/attack_self(mob/user as mob)

	if(!stored_name)
		to_chat(user, "You polish your [src.name] fondly, shining up the surface.")
		set_name(user.real_name)
		return

	if(isliving(user))
		if(stored_name)
			user.visible_message("<span class='notice'>[user] displays their [src.name].\nIt reads: [stored_name], [badge_string].</span>","<span class='notice'>You display your [src.name].\nIt reads: [stored_name], [badge_string].</span>")
		else
			user.visible_message("<span class='notice'>[user] displays their [src.name].\nIt reads: [badge_string].</span>","<span class='notice'>You display your [src.name]. It reads: [badge_string].</span>")

/obj/item/clothing/accessory/badge/attack(mob/living/carbon/human/M, mob/living/user)
	if(isliving(user))
		user.visible_message("<span class='danger'>[user] invades [M]'s personal space, thrusting [src] into their face insistently.</span>","<span class='danger'>You invade [M]'s personal space, thrusting [src] into their face insistently.</span>")

//.Holobadges.
/obj/item/clothing/accessory/badge/holo
	name = "LED Badge"
	desc = "This glowing blue badge marks the holder as a member of the GCPD."
	icon_state = "holobadge"
	item_state = "holobadge"
	badge_string = "Geminus City Police Department"
	var/emagged //Emagging removes Sec check.

/obj/item/clothing/accessory/badge/holo/cord
	icon_state = "holobadge-cord"
	slot_flags = SLOT_MASK | SLOT_TIE

/obj/item/clothing/accessory/badge/holo/attack_self(mob/user as mob)
	if(!stored_name)
		to_chat(user, "Waving around a holobadge before swiping an ID would be pretty pointless.")
		return
	return ..()

/obj/item/clothing/accessory/badge/holo/emag_act(var/remaining_charges, var/mob/user)
	if (emagged)
		to_chat(user, "<span class='danger'>\The [src] is already cracked.</span>")
		return
	else
		emagged = 1
		to_chat(user, "<span class='danger'>You crack the holobadge security checks.</span>")
		return 1

/obj/item/clothing/accessory/badge/holo/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(istype(O, /obj/item/weapon/card/id) || istype(O, /obj/item/device/pda))

		var/obj/item/weapon/card/id/id_card = null

		if(istype(O, /obj/item/weapon/card/id))
			id_card = O
		else
			var/obj/item/device/pda/pda = O
			id_card = pda.id

		if(access_security in id_card.access || emagged)
			to_chat(user, "You imprint your ID details onto the badge.")
			set_name(user.real_name)
		else
			to_chat(user, "[src] rejects your insufficient access rights.")
		return
	..()

/obj/item/weapon/storage/box/holobadge
	name = "holobadge box"
	desc = "A box claiming to contain holobadges."
	New()
		new /obj/item/clothing/accessory/badge/holo(src)
		new /obj/item/clothing/accessory/badge/holo(src)
		new /obj/item/clothing/accessory/badge/holo(src)
		new /obj/item/clothing/accessory/badge/holo(src)
		new /obj/item/clothing/accessory/badge/holo/cord(src)
		new /obj/item/clothing/accessory/badge/holo/cord(src)
		..()
		return


/obj/item/weapon/storage/box/holobadge_solgov
	name = "holobadge box"
	desc = "A box claiming to contain holobadges, this one has 'Master at Arms' written on it in fine print."
	startswith = list(/obj/item/clothing/accessory/badge/security = 6)


/obj/item/clothing/accessory/badge/security
	name = "security forces badge"
	desc = "A silver law enforcement badge. Stamped with the words 'Master at Arms'."
	icon_state = "silverbadge"
	slot_flags = SLOT_TIE
	badge_string = "Sol Central Government"

/obj/item/clothing/accessory/badge/marshal
	name = "marshal's badge"
	desc = "A leather-backed gold badge displaying the crest of the Colonial Marshals."
	icon_state = "marshalbadge"
	badge_string = "Colonial Marshal Bureau"

/obj/item/clothing/accessory/badge/chiefmarshal
	name = "chief marshal's badge"
	desc = "A leather-backed gold badge displaying the crest of the Colonial Marshals. This one has extra shine to it."
	icon_state = "marshalbadge"
	badge_string = "Colonial Marshal Bureau"

/obj/item/clothing/accessory/badge/tags //child of a badge for now because I'd rather not copy-paste their code
	name = "dog tags"
	desc = "Plain identification tags made from a durable metal. Stamped with a variety of informational details."
	gender = PLURAL
	icon_state = "tags"
	badge_string = "UNSC"
	slot_flags = SLOT_MASK | SLOT_TIE

/obj/item/clothing/accessory/badge/defenseintel
	name = "investigator's badge"
	desc = "A leather-backed silver badge bearing the crest of the Defense Intelligence Agency."
	icon_state = "diabadge"
	slot_flags = SLOT_TIE
	badge_string = "Defense Intelligence Agency"

/obj/item/clothing/accessory/badge/representative
	name = "representative's badge"
	desc = "A leather-backed plastic badge with a variety of information printed on it. Belongs to a representative of the Sol Central Government."
	icon_state = "solbadge"
	slot_flags = SLOT_TIE
	badge_string = "Sol Central Government"

/obj/item/clothing/accessory/badge/nanotrasen
	name = "\improper NanoTrasen badge"
	desc = "A leather-backed plastic badge with a variety of information printed on it. Belongs to a NanoTrasen corporate executive."
	icon_state = "ntbadge"
	slot_flags = SLOT_TIE
	badge_string = "NanoTrasen"

/obj/item/clothing/accessory/badge/police
	name = "\improper GCPD Badge"
	desc = "Badge worn by officers to show position."
	icon_state = "solbadge"
	slot_flags = SLOT_TIE
	badge_string = "Geminus City Police Department"
