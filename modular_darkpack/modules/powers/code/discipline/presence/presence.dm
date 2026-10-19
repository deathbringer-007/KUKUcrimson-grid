#define TRAIT_PRESENCE_IMMUNE "presence_immune"

/datum/discipline/presence
	name = "Presence"
	desc = {"通过超自然的魅力与情绪操纵，吸引、影响并控制人群。
● 敬畏：魅力 + 表演（难度 7）
●● 恐惧凝视：魅力 + 威吓，对抗机敏 + 勇气
●●● 迷醉：外貌 + 共情，对抗意志力
●●●● 召唤：魅力 + 诡诈（难度 7）
●●●●● 威严：勇气，对抗魅力 + 威吓"}
	icon_state = "presence"
	power_type = /datum/discipline_power/presence

/datum/discipline/presence/post_gain()
	. = ..()
	ADD_TRAIT(owner, TRAIT_CHARMER, /datum/discipline/presence)

/datum/discipline_power/presence
	name = "Presence power name"
	desc = "Presence power description"
	activate_sound = 'modular_darkpack/modules/powers/sounds/presence_activate.ogg'
	deactivate_sound = 'modular_darkpack/modules/powers/sounds/presence_deactivate.ogg'

//lets not have people be able to cast this through walls


/datum/discipline_power/presence/proc/presence_check(mob/living/carbon/human/owner, mob/living/carbon/human/target, using_stats, difficulty)
	if(!ishuman(target))
		return FALSE

	if(HAS_TRAIT(target, TRAIT_PRESENCE_IMMUNE))
		to_chat(owner, span_warning("对这个人施展威仪术时发生过大失败，今夜余下的时间内无法再对其使用威仪术。"))
		return FALSE

	//is the difficulty pre-defined? if not, its probably their willpower.
	var/theirpower = difficulty || target.st_get_stat(STAT_TEMPORARY_WILLPOWER)

	// Do we have traits to modify our difficulties?
	if((!(owner.obscured_slots & HIDEFACE))&(HAS_TRAIT(owner, TRAIT_DISFIGURED_APPEARANCE))) // Are we visibly disfigured?
		theirpower += 2 // Increase the difficulty by two.

	if(HAS_TRAIT(owner, TRAIT_ENCHANTING_VOICE))
		theirpower -= 2

	if(HAS_TRAIT(target, TRAIT_COLDLY_LOGICAL))
		theirpower += 1

	if(HAS_TRAIT(target, TRAIT_IN_FRENZY))
		theirpower += 2

	if(!get_kindred_splat(target)) // Is our target mortal?
		if(HAS_TRAIT(owner, TRAIT_GRAVE_SMELL)) // Are we stinky?
			theirpower += 1
		if((HAS_TRAIT(owner, TRAIT_GLOWING_EYES)) && (!owner.is_eyes_covered()) && (STAT_INTIMIDATION in using_stats)) // Are we intimidating a mortal with uncovered eyes?
			theirpower -= 1

	var/successes = SSroll.storyteller_roll_datum(owner, target, difficulty = theirpower, applic_stats = using_stats, numerical = TRUE)

	//botch
	if(successes < 0)
		ADD_TRAIT(target, TRAIT_PRESENCE_IMMUNE, TRAIT_GENERIC)
		to_chat(owner, span_warning("对这个人施展威仪术时发生过大失败，今夜余下的时间内无法再对其使用威仪术。"))
		return FALSE

	//number of successes is rather critical for the efficacy of the power
	return successes

/datum/discipline_power/presence/proc/apply_presence_overlay(mob/living/carbon/target)
	target.remove_overlay(POWERS_LAYER)
	var/mutable_appearance/presence_overlay = mutable_appearance('modular_darkpack/modules/powers/icons/presence.dmi', "presence", -POWERS_LAYER)
	presence_overlay.pixel_z = 1
	target.overlays_standing[POWERS_LAYER] = presence_overlay
	target.apply_overlay(POWERS_LAYER)
	SEND_SOUND(target, sound('modular_darkpack/modules/powers/sounds/presence_activate.ogg'))

//used in awe - v20 book states that awe affects the targets of lowest willpower first if affecting multiple targets.
/datum/discipline_power/presence/proc/sort_targets_by_willpower(list/targets)
	var/list/sorted = list()
	for(var/mob/living/carbon/target in targets)
		var/target_willpower = target.st_get_stat(STAT_TEMPORARY_WILLPOWER)
		var/inserted = FALSE

		for(var/i = 1; i <= length(sorted); i++)
			var/mob/living/carbon/existing = sorted[i]
			if(target_willpower < existing.st_get_stat(STAT_TEMPORARY_WILLPOWER))
				sorted.Insert(i, target)
				inserted = TRUE
				break

		if(!inserted)
			sorted += target
	return sorted


/datum/storyteller_roll/presence_awe
	difficulty = 7
	applicable_stats = list(STAT_CHARISMA, STAT_PERFORMANCE)
	numerical = TRUE

/datum/storyteller_roll/presence_awe/using_difficulty(mob/living/roller, atom/target)
	. = ..()
	if(HAS_TRAIT(roller, TRAIT_ENCHANTING_VOICE))
		. -= 2

// AWE
/datum/discipline_power/presence/awe
	name = "敬畏"
	desc = "让周围的人仰慕你，渴望与你亲近。"
	level = 1
	vitae_cost = 1
	check_flags = DISC_CHECK_CAPABLE | DISC_CHECK_SPEAK
	range = 7
	multi_activate = FALSE
	cancelable = TRUE
	cooldown_length = 15 SECONDS
	duration_length = 1 SCENES
	vitae_cost = 1
	var/successes = 0
	var/list/affected_targets = list()
	frenzy_usable = FALSE

/datum/discipline_power/presence/awe/pre_activation_checks()
	. = ..()

	//charisma + performance
	successes = SSroll.storyteller_roll_datum(owner, roll_datum = /datum/storyteller_roll/presence_awe)
	if(successes > 0)
		return TRUE

	to_chat(owner, span_warning("你的威仪未能吸引周围任何人。"))
	do_cooldown(cooldown_length)
	return FALSE

/datum/discipline_power/presence/awe/activate()
	. = ..()

	var/list/potential_targets = list()
	for(var/mob/living/carbon/target in hearers(range, owner))
		if(target != owner)
			potential_targets += target

	if(!length(potential_targets))
		to_chat(owner, span_warning("周围没有人能感受你的威仪。"))
		return

	var/list/target_counts = list(1, 2, 6, 20, length(potential_targets)) //V20 core rulebook presence -> awe
	var/targets_to_affect = target_counts[clamp(successes, 1, 5)]

	potential_targets = sort_targets_by_willpower(potential_targets)
	affected_targets = list()

	for(var/i = 1; i <= min(targets_to_affect, length(potential_targets)); i++)
		var/mob/living/carbon/target = potential_targets[i]
		apply_presence_overlay(target)
		to_chat(target, span_yellowteamradio("无论[owner]说什么，你都觉得无比动听，深信不疑！"))
		target.apply_status_effect(STATUS_EFFECT_AWE, owner)
		affected_targets += target

	var/affected_count = length(affected_targets)
	if(affected_count > 0)
		to_chat(owner, span_warning("你令人折服的威仪吸引了周围[affected_count]个人！"))
	else
		to_chat(owner, span_warning("你的威仪未能影响周围任何人。"))

/datum/discipline_power/presence/awe/deactivate()
	. = ..()
	for(var/mob/living/carbon/target in affected_targets)
		target.remove_status_effect(STATUS_EFFECT_AWE)
		target.remove_overlay(POWERS_LAYER)
	affected_targets.Cut()

// DREAD GAZE
/datum/discipline_power/presence/dread_gaze
	name = "恐惧凝视"
	desc = "仅凭言语与目光，便让他人心生恐惧。"
	level = 2
	vitae_cost = 0
	check_flags = DISC_CHECK_CAPABLE | DISC_CHECK_SPEAK | DISC_CHECK_DIRECT_SEE
	target_type = TARGET_HUMAN
	range = 7
	multi_activate = TRUE
	cooldown_length = 15 SECONDS
	duration_length = 10 SECONDS
	var/successes = 0


/datum/discipline_power/presence/dread_gaze/pre_activation_checks(mob/living/target)

	//charisma + intimidation, difficulty equal to the victims wits + courage
	successes = presence_check(owner, target, list(STAT_CHARISMA, STAT_INTIMIDATION), difficulty = (target.st_get_stat(STAT_WITS) + target.st_get_stat(STAT_COURAGE)))
	if(successes > 0)
		return TRUE

	do_cooldown(cooldown_length)
	return FALSE

/datum/discipline_power/presence/dread_gaze/activate(mob/living/carbon/human/target)
	. = ..()
	apply_presence_overlay(target)
	if(successes >= (target.st_get_stat(STAT_WITS) + target.st_get_stat(STAT_COURAGE)))	//We check if you just flat out have more successes than their dice pool total.
		var/extended_action_prompt = tgui_input_list(owner, "要尝试迫使目标因恐惧而畏缩吗？这项延长行动需要一定时间，能震慑并削弱对手！", "骇人威仪", list("是", "否"), "否")
		switch(extended_action_prompt)
			if("是")
				ADD_TRAIT(owner, TRAIT_IMMOBILIZED, DISCIPLINE_TRAIT(type))
				if(do_after(owner, 3 SECONDS))
					to_chat(owner, span_warning("你仅凭威仪就迫使[target]恐惧畏缩！"))
					to_chat(target, span_userdanger("压倒性的恐惧吞噬了你，你被迫在[owner]面前畏缩，双腿不听使唤，整个身心都为之震颤！"))
					target.Stun(1 TURNS)	//~5 seconds
					target.emote("tremble")	//Shaking emote for visibility
					target.emote(pick("scream","cry"))	//Audible emote
					target.apply_status_effect(/datum/status_effect/dread_gaze)	//Debuffs for set time
				REMOVE_TRAIT(owner, TRAIT_IMMOBILIZED, DISCIPLINE_TRAIT(type))
				return TRUE
	if(successes <= 3) // already checked for above 0 in pre_activation
		to_chat(target, span_userdanger("对[owner]的恐惧吞噬了你！"))
		to_chat(owner, span_warning("你的恐惧凝视让[target]心生恐惧！"))
	else
		to_chat(target, span_userdanger("无边的恐惧充斥着你！你必须远离[owner]！"))
		to_chat(owner, span_warning("你骇人的威仪让[target]惊恐逃窜！"))

		//V20's 'dread gaze' section states that with 3 or more successes targets will find themselves scratching at the walls or fleeing against their will because they are so terrified.
		GLOB.move_manager.move_away(target, owner, 10, target.cached_multiplicative_slowdown, 2 MINUTES)

/datum/discipline_power/presence/dread_gaze/deactivate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(POWERS_LAYER)

// ENTRANCEMENT
/datum/discipline_power/presence/entrancement
	name = "迷醉"
	desc = "让情绪服从你的意志，借此操纵他人的心灵。"
	level = 3
	check_flags = DISC_CHECK_CAPABLE|DISC_CHECK_SPEAK | DISC_CHECK_DIRECT_SEE
	target_type = TARGET_HUMAN
	range = 7
	multi_activate = TRUE
	cooldown_length = 3 MINUTES
	duration_length = 5 SECONDS
	vitae_cost = 1
	var/successes = 0
	frenzy_usable = FALSE

/datum/discipline_power/presence/entrancement/pre_activation_checks(mob/living/target)

	successes = presence_check(owner, target, list(STAT_APPEARANCE, STAT_EMPATHY))
	if(successes > 0)
		return TRUE

	do_cooldown(cooldown_length)
	return FALSE

/datum/discipline_power/presence/entrancement/activate(mob/living/carbon/human/target)
	. = ..()
	if(!.)
		to_chat(owner, span_warning("[target]似乎没有被你的话语迷住。"))
		return
	target.throw_alert("entrancement", /atom/movable/screen/alert/entrancement)
	log_combat(owner, target, "Used Presence Entrancement")

	apply_presence_overlay(target, successes * 1 MINUTES)
	to_chat(target, span_hypnophrase("你发现自己彻底为[owner]着迷，心甘情愿地成为其仆从。"))
	to_chat(target, span_info("你现在心甘情愿地侍奉[owner]。你会设法取悦对方，满足对方的一切愿望，但这股冲动很快就会消退。"))
	addtimer(CALLBACK(src, PROC_REF(end_entrancement), target), successes * 1 MINUTES) // CRIMSON GRID EDIT - Original: addtimer(CALLBACK(src, PROC_REF(end_entrancement), target), successes * 10 MINUTES)

/datum/discipline_power/presence/entrancement/proc/end_entrancement(mob/living/carbon/human/target)
	to_chat(target, span_hypnophrase("你想满足[owner]一切愿望的冲动消退了。"))
	target.clear_alert("entrancement")

/datum/discipline_power/presence/entrancement/deactivate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(POWERS_LAYER)

// SUMMON
/datum/discipline_power/presence/summon
	name = "召唤"
	desc = "呼唤你见过的任何人来到你的身边。"
	level = 4
	check_flags = DISC_CHECK_CAPABLE | DISC_CHECK_SPEAK
	range = 7
	multi_activate = TRUE
	cooldown_length = 10 MINUTES
	duration_length = 5 SECONDS
	vitae_cost = 1
	var/successes = 0
	var/mob/living/carbon/human/summon_target
	frenzy_usable = FALSE

/datum/discipline_power/presence/summon/pre_activation_checks(mob/living/target)
	var/mob/living/summon_target = owner?.mind?.guestbook.pick_known_guy(owner)
	if(!istype(summon_target))
		return FALSE

	//this ability has a difficulty of 4 or 5 or something for people the summoner has met, and 8 for those they've only met briefly.
	//i thought that was too low and the ability for the misuse of this disc caused me to raise it to 7 difficulty
	successes = presence_check(owner, summon_target, list(STAT_CHARISMA, STAT_SUBTERFUGE), 7)
	if(successes > 0)
		return TRUE

	do_cooldown(cooldown_length)
	return FALSE

/datum/discipline_power/presence/summon/activate(mob/living/carbon/human/target)
	. = ..()
	if(!. || !summon_target)
		to_chat(owner, span_warning("你的召唤未能传达给[summon_target ? summon_target.real_name : "目标"]。"))
		return

	apply_presence_overlay(summon_target, 5 MINUTES)

	var/turf/owner_turf = get_turf(owner)
	var/location_info = "[get_area_name(owner_turf)], X:[owner_turf.x] Y:[owner_turf.y] Z:[owner_turf.z]"
	to_chat(summon_target, span_yellowteamradio("[owner.real_name]正召唤你前往其所在地。[owner.real_name]目前位于[location_info]。"))

	//V20 presence -> 'summon' section for this flavortext
	var/list/flavor_texts = list(
		"你感到一股微弱的力量牵引你走向[owner.real_name]，你迟疑而缓慢地靠近。",
		"你不情愿地受到驱使，想去寻找[owner.real_name]，但障碍很容易让你打消念头。",
		"你强烈地想以适当的速度前往[owner.real_name]身边。",
		"你受到驱使，急切地奔向[owner.real_name]，克服沿途的障碍，但不会危及自身。",
		"你迫切地需要奔向[owner.real_name]，愿意不惜一切来到对方身边。"
	)

	var/flavor_index = clamp(successes, 1, 5)
	to_chat(summon_target, span_yellowteamradio(flavor_texts[flavor_index]))
	to_chat(summon_target, span_info("召唤只对确实见过召唤者的目标生效。如果根据合理的角色经历，你的角色从未见过召唤者，这项能力便不会生效。"))
	to_chat(owner, span_warning("你成功召唤[summon_target.real_name]前来！（[successes]个成功数）"))
	summon_target.do_jitter_animation(3 SECONDS)

/datum/discipline_power/presence/summon/deactivate(mob/living/carbon/human/target)
	. = ..()
	summon_target?.remove_overlay(POWERS_LAYER)

// MAJESTY
/datum/discipline_power/presence/majesty
	name = "威严"
	desc = "展现无上的威严，让他人几乎无法违抗或伤害你。"
	level = 5
	check_flags = DISC_CHECK_CAPABLE | DISC_CHECK_SPEAK
	range = 7
	multi_activate = TRUE
	cooldown_length = 3 MINUTES
	duration_length = 2 MINUTES
	vitae_cost = 0
	willpower_cost = 1
	violates_masquerade = TRUE
	var/list/affected_targets = list()
	frenzy_usable = FALSE

/datum/discipline_power/presence/majesty/pre_activation_checks(mob/living/target)
	return TRUE

/datum/discipline_power/presence/majesty/activate(mob/living/carbon/human/target)
	. = ..()
	affected_targets = list()
	for(var/mob/living/carbon/human/hearer in get_hearers_in_view(range, owner))
		if(hearer == owner)
			continue

		var/roll_difficulty = owner.st_get_stat(STAT_CHARISMA) + owner.st_get_stat(STAT_INTIMIDATION)
		//'the victim must make a courage roll with a difficulty equal to the caster's charisma + intimidation to a maximum of 10'
		var/hearer_successes = SSroll.storyteller_roll_datum(hearer, owner, difficulty = roll_difficulty, applic_stats = list(STAT_COURAGE), numerical = TRUE)
		hearer_successes = max(0, hearer_successes)

		apply_presence_overlay(hearer, 3 MINUTES)
		affected_targets[hearer] = hearer_successes
		watch_for_attacks(hearer) // CRIMSON EDIT ADD - Majesty pacifism breaks after being attacked

		// this ability is often used to end combat scenes but it often ignored.
		var/pacifism_delay = hearer_successes * 10 SECONDS
		if(hearer_successes > 0)
			to_chat(hearer, span_info("你的意志能让你抵抗[pacifism_delay / 10]秒，之后你将被迫放弃暴力。")) // CRIMSON EDIT - Majesty pacifism breaks after being attacked
			addtimer(CALLBACK(src, PROC_REF(apply_pacifism), hearer), pacifism_delay)
		else
			ADD_TRAIT(hearer, TRAIT_PACIFISM, "Majesty")
			to_chat(hearer, span_info("你完全无法违抗[owner]。")) // CRIMSON EDIT - Majesty pacifism breaks after being attacked

		to_chat(hearer, span_hypnophrase("你被[owner]的威严压倒了。出言反对已十分困难，动手攻击更是不可想象。")) // CRIMSON EDIT - Majesty pacifism breaks after being attacked
		ADD_TRAIT(owner, TRAIT_PACIFISM, "Majesty")

		if(hearer_successes > 0)
			to_chat(hearer, span_info("在获准离开[owner]身边之前，你的意志允许你做出[hearer_successes]次违抗行为。")) // CRIMSON EDIT - Majesty pacifism breaks after being attacked

	var/total_affected = length(affected_targets)
	if(total_affected > 0)
		watch_for_attacks(owner) // CRIMSON EDIT ADD - Majesty pacifism breaks after being attacked
		to_chat(owner, span_warning("你的威严压倒了在场的[total_affected]个人！"))
	else
		to_chat(owner, span_warning("没有人在场见证你的威严。"))

/datum/discipline_power/presence/majesty/deactivate(mob/living/carbon/human/target)
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_PACIFISM, "Majesty")
	UnregisterSignal(owner, list(COMSIG_MOB_APPLY_DAMAGE, COMSIG_ATOM_HITBY)) // CRIMSON EDIT ADD - Majesty pacifism breaks after being attacked
	for(var/mob/living/carbon/human/affected_target in affected_targets)
		if(affected_target)
			UnregisterSignal(affected_target, list(COMSIG_MOB_APPLY_DAMAGE, COMSIG_ATOM_HITBY)) // CRIMSON EDIT ADD - Majesty pacifism breaks after being attacked
			affected_target.remove_overlay(POWERS_LAYER)
			to_chat(affected_target, span_hypnophrase("[owner]压倒性的威仪消退了，你的意志恢复了正常。你仍然记得对方对你做过什么。")) // CRIMSON EDIT - Majesty pacifism breaks after being attacked
			REMOVE_TRAIT(affected_target, TRAIT_PACIFISM, "Majesty")
	affected_targets.Cut()

/datum/discipline_power/presence/majesty/proc/apply_pacifism(mob/living/carbon/human/hearer)
	if(hearer && (hearer in affected_targets))
		ADD_TRAIT(hearer, TRAIT_PACIFISM, "Majesty")
		to_chat(hearer, span_warning("你的抵抗崩溃了，再也无法鼓起意志违抗[owner]！")) // CRIMSON EDIT - Majesty pacifism breaks after being attacked

// CRIMSON EDIT ADD START - Majesty pacifism breaks after being attacked
/datum/discipline_power/presence/majesty/proc/watch_for_attacks(mob/living/carbon/human/attacked_mob)
	RegisterSignal(attacked_mob, COMSIG_MOB_APPLY_DAMAGE, PROC_REF(on_damaged))
	RegisterSignal(attacked_mob, COMSIG_ATOM_HITBY, PROC_REF(on_hit_by_thrown))

/datum/discipline_power/presence/majesty/proc/on_damaged(mob/living/carbon/human/attacked_mob, damage, damagetype, def_zone, blocked, wound_bonus, exposed_wound_bonus, sharpness, attack_direction)
	SIGNAL_HANDLER
	if(damagetype == STAMINA || isnull(attack_direction))
		return
	break_majesty(attacked_mob)

/datum/discipline_power/presence/majesty/proc/on_hit_by_thrown(mob/living/carbon/human/attacked_mob, atom/movable/hitting_atom)
	SIGNAL_HANDLER
	if(!isitem(hitting_atom))
		return
	var/obj/item/thrown_item = hitting_atom
	if(thrown_item.damtype == STAMINA)
		return
	break_majesty(attacked_mob)

/datum/discipline_power/presence/majesty/proc/break_majesty(mob/living/carbon/human/attacked_mob)
	UnregisterSignal(attacked_mob, list(COMSIG_MOB_APPLY_DAMAGE, COMSIG_ATOM_HITBY))
	affected_targets -= attacked_mob
	REMOVE_TRAIT(attacked_mob, TRAIT_PACIFISM, "Majesty")
	if(attacked_mob == owner)
		to_chat(attacked_mob, span_warning("鲜血与疼痛打破了你王者般的镇定。你可以还击了。"))
		return
	attacked_mob.remove_overlay(POWERS_LAYER)
	to_chat(attacked_mob, span_warning("疼痛驱散了迷惘。你可以还击了。"))
// CRIMSON EDIT ADD END - Majesty pacifism breaks after being attacked

// LOVE
/datum/discipline_power/presence/love
	name = "倾慕"
	desc = "让某人深深迷恋你，如同受到血缚一般。"
	level = 6
	check_flags = DISC_CHECK_CAPABLE|DISC_CHECK_SPEAK
	target_type = TARGET_HUMAN
	range = 7
	cooldown_length = 15 SECONDS
	var/presence_succeeded = FALSE

/datum/discipline_power/presence/love/pre_activation_checks(mob/living/target)

	presence_succeeded = presence_check(owner, target)
	if(presence_succeeded)
		return TRUE

	do_cooldown(cooldown_length)
	return FALSE

/datum/discipline_power/presence/love/activate(mob/living/carbon/human/target)
	. = ..()
	if(presence_succeeded)
		apply_presence_overlay(target)
		//target.apply_status_effect(STATUS_EFFECT_INLOVE, owner)
		to_chat(owner, span_warning("你的威仪使[target]为你着迷，与对方建立了情感束缚！"))
	else
		to_chat(owner, span_warning("[target]的心灵抵抗了你的影响！"))
		to_chat(target, span_warning("[owner]散发出压倒性的气场，强迫你心生爱慕……但你坚定心志，拒绝了这超乎常理的诱惑。"))

///mob/living/carbon/proc/walk_to_caster(mob/living/step_to)
	//walk(src, 0)
	//if(!CheckFrenzyMove())
		//set_glide_size(DELAY_TO_GLIDE_SIZE(total_multiplicative_slowdown()))
		//step_to(src, step_to, 0)
		//face_atom(step_to)

///mob/living/carbon/human/proc/step_away_caster(mob/living/step_from)
	//walk(src, 0)
	//if(!CheckFrenzyMove())
		//set_glide_size(DELAY_TO_GLIDE_SIZE(total_multiplicative_slowdown()))
		//step_away(src, step_from, 99)

#undef TRAIT_PRESENCE_IMMUNE
