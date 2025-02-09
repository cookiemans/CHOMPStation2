// Unique areas were requested for each superpose map for future use. The plain superpose area is for future varedits to all superpose submaps.
/area/survivalpod/superpose
	requires_power = TRUE

/area/survivalpod/superpose/CrashedInfestedShip

/area/survivalpod/superpose/CrashedQurantineShip

/area/survivalpod/superpose/CultShip

/area/survivalpod/superpose/DemonPool
	requires_power = FALSE

/area/survivalpod/superpose/Dinner

/area/survivalpod/superpose/DragonCave

/area/survivalpod/superpose/ExplorerHome

/area/survivalpod/superpose/Farm

/area/survivalpod/superpose/FieldLab

/area/survivalpod/superpose/HellCave

/area/survivalpod/superpose/HydroCave

/area/survivalpod/superpose/LargeAlienShip

/area/survivalpod/superpose/LoneHome

/area/survivalpod/superpose/LoneHomeclean

/area/survivalpod/superpose/MechFabShip

/area/survivalpod/superpose/MechStorageFab

/area/survivalpod/superpose/MercShip

/area/survivalpod/superpose/MethLab

/area/survivalpod/superpose/OldHotel

/area/survivalpod/superpose/NewHotel

/area/survivalpod/superpose/ScienceShip

/area/survivalpod/superpose/SmallCombatShip

/area/survivalpod/superpose/SurvivalBarracks
	requires_power = FALSE

/area/survivalpod/superpose/SurvivalCargo
	requires_power = FALSE

/area/survivalpod/superpose/SurvivalDIY_11x11

/area/survivalpod/superpose/SurvivalDIY_11x11lite

/area/survivalpod/superpose/SurvivalDIY_7x7

/area/survivalpod/superpose/SurvivalDIY_9x9

/area/survivalpod/superpose/SurvivalDinner
	requires_power = FALSE

/area/survivalpod/superpose/SurvivalEngineering
	requires_power = FALSE

/area/survivalpod/superpose/SurvivalHome
	requires_power = FALSE

/area/survivalpod/superpose/SurvivalHydro
	requires_power = FALSE

/area/survivalpod/superpose/SurvivalJanitor
	requires_power = FALSE

/area/survivalpod/superpose/SurvivalLeisure
	requires_power = FALSE

/area/survivalpod/superpose/SurvivalLuxuryBar
	requires_power = FALSE

/area/survivalpod/superpose/SurvivalLuxuryHome
	requires_power = FALSE

/area/survivalpod/superpose/SurvivalMedical
	requires_power = FALSE

/area/survivalpod/superpose/SurvivalPool
	requires_power = FALSE

/area/survivalpod/superpose/SurvivalQuarters
	requires_power = FALSE

/area/survivalpod/superpose/SurvivalScience
	requires_power = FALSE

/area/survivalpod/superpose/SurvivalSecurity
	requires_power = FALSE

/area/survivalpod/superpose/TinyCombatShip

/area/survivalpod/superpose/TradingShip

/area/survivalpod/superpose/WoodenCamp

/area/survivalpod/superpose/AnimalHospital

/area/survivalpod/superpose/RestaurationBar
	requires_power = FALSE

/area/survivalpod/superpose/BroadcastingPod

/area/survivalpod/superpose/DemonPoolV2
	requires_power = FALSE

/area/survivalpod/superpose/PirateShip

/area/survivalpod/superpose/SurvivalHomeV2
	requires_power = FALSE

/area/survivalpod/superpose/SurvivalMechFab
	requires_power = FALSE

/area/survivalpod/superpose/SurvivalMethLab
	requires_power = FALSE

/area/survivalpod/superpose/SurvivalScienceV2
	requires_power = FALSE

/area/survivalpod/superpose/SurvivalSecurityV2
	requires_power = FALSE

/area/survivalpod/superpose/HillOutpost

/area/survivalpod/superpose/PizzaParlor

/area/survivalpod/superpose/GrandLibrary

/area/survivalpod/superpose/logcabin

/area/survivalpod/superpose/hotel

/area/survivalpod/superpose/XenoBotanySetup

/obj/item/device/survivalcapsule/superpose
	name = "superposed surfluid shelter capsule"
	desc = "A proprietary hyperstructure of many three-dimensional spaces superposed around a supermatter nano crystal; use a pen to reach the reset button. There's a license for use printed on the bottom."
	description_info = "The capsule contains pockets of compressed space in a super position stabilized by a miniscule supermatter crystal. \
	NanoTrasen stresses the safety of this model over previous prototypes but assumes no liability for sub-kiloton explosions."
	template_id = null
	var/list/template_ids = list()
	var/pod_initialized = FALSE

// Override since the parent proc has a sanity check to delete the capsule if no template is found, which doesn't exactly work with this item considering examining calls this proc.
/obj/item/device/survivalcapsule/superpose/get_template()
	if(template)
		return
	template = SSmapping.shelter_templates[template_id]
	if(!template)
		template = null

/obj/item/device/survivalcapsule/superpose/attack_self()
	if(!pod_initialized) // Populate list after round start as map templates might not exist when this item is created.
		for(var/datum/map_template/shelter/superpose/shelter_type as anything in subtypesof(/datum/map_template/shelter))
			if(!(initial(shelter_type.mappath)) || !(initial(shelter_type.superpose))) // Limits map templates to those marked for the superpose capsule.
				continue
			template_ids += initial(shelter_type.shelter_id)
		pod_initialized = TRUE
	if(!template_id)
		var/answer = tgui_input_list(usr, "Which template would you like to load?","Available Templates", template_ids)
		if(!answer)
			return
		else
			src.template_id = answer
			return // Return here or the pod will activate as soon as a selection is made.

	// Now we call super to run the rest of the parent proc since the choice has been handled.
	..()

// Allows resetting the capsule if the wrong template is chosen.
/obj/item/device/survivalcapsule/superpose/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/weapon/pen) && !used)
		template_id = null
		template = null // Important to reset both, otherwise the template cannot be reset once the pod has been deployed.
		to_chat(user, "<span class='notice'>You reset the pod's selection.</span>")
	..()
