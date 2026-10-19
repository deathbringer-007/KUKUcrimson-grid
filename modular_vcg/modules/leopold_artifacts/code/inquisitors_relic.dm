/obj/item/occult_artifact/holy/inquisitors_relic
	name = "银戒指"
	desc = "一枚古老的银戒指。"
	true_name = "金口圣戒"
	true_desc = "佩戴在手套栏时，赋予佩戴者真信的力量。"
	icon = 'modular_vcg/modules/leopold_artifacts/icons/relics.dmi'
	icon_state = "silver_ring"
	onflooricon = 'modular_vcg/modules/leopold_artifacts/icons/relics.dmi'
	worn_icon = 'modular_vcg/modules/leopold_artifacts/icons/relics_worn.dmi'
	worn_icon_state = "silver_ring"
	slot_flags = ITEM_SLOT_GLOVES
	research_value = 1 //Shouldnt be applicable except for rare cases
	var/datum/mind/granted_mind
	var/previous_holy_role = NONE

/obj/item/occult_artifact/holy/inquisitors_relic/Destroy()
	restore_holy_role()
	return ..()

/obj/item/occult_artifact/holy/inquisitors_relic/grant_powers()
	. = ..()
	update_holy_role()

/obj/item/occult_artifact/holy/inquisitors_relic/ungrant_powers()
	. = ..()
	restore_holy_role()

/obj/item/occult_artifact/holy/inquisitors_relic/equipped(mob/user, slot, initial = FALSE)
	. = ..()
	if(slot == ITEM_SLOT_GLOVES && owner == user)
		update_holy_role()

/obj/item/occult_artifact/holy/inquisitors_relic/dropped(mob/user, silent = FALSE)
	restore_holy_role()
	. = ..()

/obj/item/occult_artifact/holy/inquisitors_relic/process(seconds_per_tick)
	. = ..()
	update_holy_role()

/obj/item/occult_artifact/holy/inquisitors_relic/proc/restore_holy_role()
	if(!granted_mind)
		return
	if(granted_mind.holy_role == HOLY_ROLE_PRIEST)
		granted_mind.set_holy_role(previous_holy_role)
	granted_mind = null
	previous_holy_role = NONE

/obj/item/occult_artifact/holy/inquisitors_relic/proc/update_holy_role()
	var/mob/living/carbon/human/wearer = owner
	if(!istype(wearer) || wearer.gloves != src || !wearer.mind)
		restore_holy_role()
		return
	if(granted_mind == wearer.mind)
		return
	restore_holy_role()
	if(wearer.mind.holy_role >= HOLY_ROLE_PRIEST)
		return
	granted_mind = wearer.mind
	previous_holy_role = granted_mind.holy_role
	granted_mind.set_holy_role(HOLY_ROLE_PRIEST)
