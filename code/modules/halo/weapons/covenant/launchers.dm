
/obj/item/weapon/gun/projectile/fuel_rod
	name = "Type-33 Light Anti-Armor Weapon"
	desc = "A man-portable weapon capable of inflicting heavy damage on both vehicles and infantry."
	icon = 'code/modules/halo/weapons/icons/fuel_rod_cannon.dmi'
	icon_state = "fuel_rod"
	item_state = "fuelrod"
	fire_sound = 'code/modules/halo/sounds/fuel_rod_fire_2.ogg'
	reload_sound = 'code/modules/halo/sounds/fuel_rod_reload.ogg'
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/fuel_rod
	fire_delay = 24 //disencourage spamming even though we have a higher mag size
	one_hand_penalty = -1
	dispersion = list(0)
	charge_sound = null
	hud_bullet_row_num = 5
	hud_bullet_reffile = 'code/modules/halo/icons/hud_display/hud_bullet_12x8.dmi'
	hud_bullet_iconstate = "fuelrod"
	caliber = "fuel rod"
	handle_casings = CASELESS
	w_class = ITEM_SIZE_HUGE
	slot_flags = SLOT_BACK
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		slot_back_str = 'code/modules/halo/weapons/icons/Back_Weapons.dmi',
		slot_s_store_str = 'code/modules/halo/weapons/icons/Armor_Weapons.dmi',
		)
	crosshair_file = 'code/modules/halo/weapons/icons/dragaim_missile.dmi'
	wielded_item_state = "fuelrod-wielded"
	salvage_components = list()
	matter = list("nanolaminate" = 2, "kemocite" = 1)
	slowdown_general = 0.5
	scope_zoom_amount = 1.5

/obj/item/weapon/gun/projectile/fuel_rod/update_icon()
	if(ammo_magazine)
		icon_state = "fuel_rod_loaded"
	else
		icon_state = "fuel_rod"
