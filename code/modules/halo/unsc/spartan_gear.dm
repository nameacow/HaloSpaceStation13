#define SPARTAN_BLEEDBLOCK_CHANCE 50

/mob/living/carbon/human/spartan/New(var/new_loc)
	. = ..(new_loc,"Spartan")

	name = species.get_random_name()
	real_name = name

/obj/item/organ/external/chest/augmented
	gendered_icon = 1
	min_broken_damage = 50

/obj/item/organ/external/groin/augmented
	gendered_icon = 1
	min_broken_damage = 50

/obj/item/organ/external/head/augmented
	gendered_icon = 1
	min_broken_damage = 50
	eye_icon = "eyes_s"
	eye_icon_location = 'code/modules/halo/unsc/r_Augmented_Human.dmi'

/obj/item/organ/external/arm/augmented
	gendered_icon = 1
	min_broken_damage = 50 //Needs 20 more damage to break

/obj/item/organ/external/arm/right/augmented
	gendered_icon = 1
	min_broken_damage = 50

/obj/item/organ/external/leg/augmented
	gendered_icon = 1
	min_broken_damage = 50

/obj/item/organ/external/leg/right/augmented
	gendered_icon = 1
	min_broken_damage = 50

/obj/item/organ/external/hand/augmented
	min_broken_damage = 50

/obj/item/organ/external/hand/right/augmented
	min_broken_damage = 50

/obj/item/organ/external/foot/augmented
	min_broken_damage = 50

/obj/item/organ/external/foot/right/augmented
	min_broken_damage = 50

/obj/item/organ/internal/eyes/occipital_reversal
	//Organ is slightly tougher
	min_bruised_damage = 25
	min_broken_damage = 35
	//Minor protection from flashes
	innate_flash_protection = FLASH_PROTECTION_MODERATE
	//Also protects against Phoron gas
	phoron_guard = 1

/obj/item/organ/internal/liver/spartan
	name = "augmented liver"
	//Twice as good at handling toxin damage... but not any tougher
	toxin_danger_level = 120

/obj/item/organ/internal/liver/spartan/Process()
	//To allow some filtering first, we're putting off our ..() call
	if(owner.chem_effects[CE_ALCOHOL] && owner.chem_effects[CE_ALCOHOL_TOXIC])
		//Remove an additional amount of alcohol
		owner.vessel.remove_reagent(/datum/reagent/ethanol, min(owner.chem_effects[CE_ALCOHOL_TOXIC], 3))

	// Small amounts of radiation can be handled by a spartan
	if(owner.radiation && !owner.chem_effects[CE_TOXIN])
		var/amount = min(owner.radiation, 10)
		owner.radiation -= amount
		//Radiation is scavenged into metabolizable compounds by the enhanced liver
		owner.vessel.add_reagent(/datum/reagent/radiotox, amount)

	. = ..()

/obj/item/organ/internal/heart/spartan
	name = "enhanced heart"
	desc = "a dense mass of muscle, vaugely resembling a heart"
	max_damage = 60
	min_bruised_damage = 30 //Considerably tougher
	min_broken_damage = 45

//give spartans some slight regen
/obj/item/organ/internal/heart/spartan/Process()
	. = ..()
	for(var/obj/item/organ/external/e in owner.bad_external_organs)
		if(!e.clamped() && prob(SPARTAN_BLEEDBLOCK_CHANCE))
			e.clamp_organ() //Clamping, not bandaging ensures that no passive healing is gained from the wounds being bandaged

#undef SPARTAN_BLEEDBLOCK_CHANCE