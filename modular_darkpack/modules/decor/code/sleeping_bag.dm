// Here be sleeping bags
// Largely copied from medical beds, snowflaked here to avoid overlapping functionality

/obj/structure/bed/sleeping_bag
	name = "睡袋"
	desc = "也有人把它叫作铺盖卷。"
	icon_state = "bedroll" // Sprites by @Major00
	max_integrity = 25
	integrity_failure = 0.35
	build_stack_type = /obj/item/stack/sheet/leather
	can_deconstruct = FALSE
	anchored = FALSE
	var/foldable_type = /obj/item/sleeping_bag // Snowflaked version of the rollerbed behavior

/obj/structure/bed/sleeping_bag/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/noisy_movement, movement_sound = 'sound/effects/footstep/crawl1.ogg')

/obj/structure/bed/sleeping_bag/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	. = ..()
	if(!isnull(foldable_type) && !has_buckled_mobs())
		context[SCREENTIP_CONTEXT_RMB] = "卷起"

	return CONTEXTUAL_SCREENTIP_SET

/obj/structure/bed/sleeping_bag/examine(mob/user)
	. = ..()
	if(anchored)
		. += span_notice("它被固定在地上了。")
	else if(!isnull(foldable_type))
		. += span_notice("右键点击即可将其收起。")

/obj/structure/bed/sleeping_bag/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(!ishuman(user) || !user.can_perform_action(src))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(has_buckled_mobs())
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	user.visible_message(span_notice("[user]卷起了[src]。"), span_notice("你卷起了[src]。"))
	var/obj/structure/bed/sleeping_bag/folding_bed = new foldable_type(get_turf(src))
	user.put_in_hands(folding_bed)
	qdel(src)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/sleeping_bag
	name = "睡袋"
	desc = "可以卷起来随身携带的床铺，也就是所谓的铺盖卷。"
	icon = 'modular_darkpack/master_files/icons/obj/bed.dmi'
	icon_state = "bedroll_inv"
	inhand_icon_state = "bedroll"
	lefthand_file = 'modular_darkpack/master_files/icons/obj/bed_inhand_left.dmi'
	righthand_file = 'modular_darkpack/master_files/icons/obj/bed_inhand_right.dmi'
	w_class = WEIGHT_CLASS_NORMAL // No more excuses, stop getting blood everywhere
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/decor/icons/bed_onfloor.dmi')

/obj/item/sleeping_bag/attack_self(mob/user)
	. = ..()
	deploy_bed(user, user.loc)

/obj/item/sleeping_bag/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(isopenturf(interacting_with))
		deploy_bed(user, interacting_with)
		return ITEM_INTERACT_SUCCESS
	return NONE

/obj/item/sleeping_bag/proc/deploy_bed(mob/user, atom/location)
	var/obj/structure/bed/sleeping_bag/deployed = new /obj/structure/bed/sleeping_bag(location)
	deployed.add_fingerprint(user)
	qdel(src)
