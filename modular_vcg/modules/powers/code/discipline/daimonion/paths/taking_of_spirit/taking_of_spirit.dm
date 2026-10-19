/datum/discipline/path/spirit
	name = "Taking of Spirit"
	desc = "操纵意志力的黑暗血魔法道途。"
	icon = 'modular_vcg/modules/paths/icons/paths.dmi'
	icon_state = "spirit"
	power_type = /datum/discipline_power/daimonion/path/spirit
	//lazylists of weakrefs
	var/list/botched_targets
	var/list/drained_targets

/datum/discipline/path/spirit/post_gain()
	. = ..()
	RegisterSignal(owner, COMSIG_LIVING_DEATH, PROC_REF(on_owner_death))
	ADD_TRAIT(owner, TRAIT_TAKING_SPIRIT_KNOWLEDGE, TAKING_OF_SPIRIT_TRAIT)

/datum/discipline/path/spirit/proc/on_owner_death(mob/living/dead)
	SIGNAL_HANDLER

	if(LAZYLEN(drained_targets))
		for(var/datum/weakref/ref in drained_targets)
			var/mob/living/carbon/human/drained = ref.resolve()
			if(!drained)
				continue
			if(!CAN_THEY_SEE(drained, dead))
				continue
			var/willpower_amount = drained_targets[ref]
			drained.st_set_stat(STAT_TEMPORARY_WILLPOWER, drained.st_get_stat(STAT_TEMPORARY_WILLPOWER) + willpower_amount)
			to_chat(drained, span_notice("目睹[dead]死亡后，你被夺走的意志力恢复了，对方对你的控制也随之消退。"))
	LAZYNULL(drained_targets)

/datum/discipline_power/daimonion/path/spirit
	name = "黑暗血魔法：摄魂之道能力名称"
	desc = "黑暗血魔法：摄魂之道能力描述"

	activate_sound = 'modular_darkpack/modules/powers/sounds/thaum.ogg'

	target_type = TARGET_PLAYER
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_TORPORED
	aggravating = FALSE
	hostile = TRUE
	violates_masquerade = FALSE
	range = 1

	cooldown_length = 5 MINUTES
	var/success_count
	var/willpower_drain_amount

/datum/storyteller_roll/taking_of_spirit
	bumper_text = "汲取意志力"
	applicable_stats = list(STAT_PERMANENT_WILLPOWER)
	numerical = TRUE
	roll_output_type = ROLL_FLAG_ROLLER|ROLL_FLAG_TARGET

/datum/storyteller_roll/taking_of_spirit_resist
	bumper_text = "抵抗意志汲取"
	applicable_stats = list(STAT_PERMANENT_WILLPOWER)
	numerical = TRUE
	roll_output_type = ROLL_FLAG_ROLLER|ROLL_FLAG_TARGET

/datum/discipline_power/daimonion/path/spirit/can_activate(mob/living/target, alert)
	. = ..()
	var/datum/discipline/path/spirit/parent_disc = discipline

	//someone has botched taking of spirit against this human
	if(LAZYLEN(parent_disc.botched_targets))
		for(var/datum/weakref/ref in parent_disc.botched_targets)
			var/mob/living/carbon/human/botched = ref.resolve()
			if(!botched)
				LAZYREMOVE(parent_disc.botched_targets, ref)
				continue
			if(botched == target)
				to_chat(owner, span_warning("你之前的失败使[target]免疫了你的摄魂之道。"))
				return FALSE
	if(target.st_get_stat(STAT_TEMPORARY_WILLPOWER) == 0)
		to_chat(owner, span_warning("[target]已经没有可供汲取的意志力了！"))
		return FALSE
	return TRUE

/datum/discipline_power/daimonion/path/spirit/activate(mob/living/target)
	. = ..()
	var/datum/discipline/path/spirit/parent_disc = discipline

	success_count = SSroll.storyteller_roll_datum(owner, target, /datum/storyteller_roll/taking_of_spirit, difficulty = (level + 3))
	if(success_count < 0)
		owner.visible_message(span_danger("[owner]目光呆滞，竭力集中精神。"), \
			span_notice("你目光呆滞，竭力集中精神。"))
		to_chat(owner, span_danger("你感到自己的意志力正在被抽走！"))
		spirit_botch_effect()
		return
	else if(success_count == 0)
		to_chat(owner, span_notice("你的法术消散了！"))
		return
	if(HAS_TRAIT(target, TRAIT_TAKING_SPIRIT_KNOWLEDGE))
		var/resist_count = SSroll.storyteller_roll_datum(target, owner, /datum/storyteller_roll/taking_of_spirit_resist, difficulty = 7)
		if(resist_count > success_count)
			LAZYADD(parent_disc.botched_targets, WEAKREF(target))
			to_chat(owner, span_warning("你的摄魂之道施展失败！[target]现在免疫了你的摄魂之道。"))
			return
	owner.visible_message(span_danger("[owner]将手伸向[target]的头部，吟诵着恶魔咒语。"), \
		span_notice("你开始对[target]的心智吟诵恶魔咒语……"))
	if(do_after(owner, 15 SECONDS, target = target, timed_action_flags = (IGNORE_HELD_ITEM)))
		owner.visible_message(span_danger("[owner]成功对[target]的心智施加了邪恶咒语。"), \
			span_notice("你成功对[target]的心智施加了邪恶咒语。"))
		to_chat(target, span_danger("你感到自己的意志力正在被抽走！"))
		var/actual_drain = min(target.st_get_stat(STAT_TEMPORARY_WILLPOWER), willpower_drain_amount)
		target.st_set_stat(STAT_TEMPORARY_WILLPOWER, target.st_get_stat(STAT_TEMPORARY_WILLPOWER) - actual_drain)
		if(target.st_get_stat(STAT_TEMPORARY_WILLPOWER) == 0)
			to_chat(target, span_hypnophrase("随着最后一丝意志力流失，你的情感逐渐麻木，只剩下服从[owner]的念头。"))
			to_chat(target, span_info("你如今是一具失去灵魂的傀儡，应将侍奉[owner]视为首要任务。"))
			target.visible_message(span_danger("[target]神情呆滞，眼中毫无生气。"), \
				span_notice("你神情呆滞，眼中毫无生气。"))
		ADD_TRAIT(target, TRAIT_TAKING_SPIRIT_KNOWLEDGE, TAKING_OF_SPIRIT_TRAIT)
		if(LAZYLEN(parent_disc.drained_targets))
			for(var/datum/weakref/ref in parent_disc.drained_targets)
				var/mob/living/carbon/human/drained = ref.resolve()
				if(!drained)
					LAZYREMOVE(parent_disc.drained_targets, ref)
					continue
				if(drained == target)
					parent_disc.drained_targets[ref] += actual_drain
					return
		LAZYADDASSOC(parent_disc.drained_targets, WEAKREF(target), actual_drain)
	else
		to_chat(owner, span_notice("你的注意力被打断了！不过，最严重的反噬似乎已经过去。"))

/datum/discipline_power/daimonion/path/spirit/proc/spirit_botch_effect()
	owner.st_set_stat(STAT_TEMPORARY_WILLPOWER, owner.st_get_stat(STAT_TEMPORARY_WILLPOWER) - willpower_drain_amount)

/datum/discipline_power/daimonion/path/spirit/one
	name = "黑暗血魔法：摄魂之道一级"
	desc = "汲取受害者的意志力。"

	level = 1
	willpower_drain_amount = 1

	grouped_powers = list(
		/datum/discipline_power/daimonion/path/spirit/two,
		/datum/discipline_power/daimonion/path/spirit/three,
		/datum/discipline_power/daimonion/path/spirit/four,
		/datum/discipline_power/daimonion/path/spirit/five,
	)

/datum/discipline_power/daimonion/path/spirit/two
	name = "黑暗血魔法：摄魂之道二级"
	desc = "汲取受害者的意志力。"

	level = 2
	willpower_drain_amount = 2

	grouped_powers = list(
		/datum/discipline_power/daimonion/path/spirit/one,
		/datum/discipline_power/daimonion/path/spirit/three,
		/datum/discipline_power/daimonion/path/spirit/four,
		/datum/discipline_power/daimonion/path/spirit/five,
	)

/datum/discipline_power/daimonion/path/spirit/three
	name = "黑暗血魔法：摄魂之道三级"
	desc = "汲取受害者的意志力。"

	level = 3
	willpower_drain_amount = 4

	grouped_powers = list(
		/datum/discipline_power/daimonion/path/spirit/one,
		/datum/discipline_power/daimonion/path/spirit/two,
		/datum/discipline_power/daimonion/path/spirit/four,
		/datum/discipline_power/daimonion/path/spirit/five,
	)

/datum/discipline_power/daimonion/path/spirit/four
	name = "黑暗血魔法：摄魂之道四级"
	desc = "汲取受害者的意志力。"

	level = 4
	willpower_drain_amount = 6

	grouped_powers = list(
		/datum/discipline_power/daimonion/path/spirit/one,
		/datum/discipline_power/daimonion/path/spirit/two,
		/datum/discipline_power/daimonion/path/spirit/three,
		/datum/discipline_power/daimonion/path/spirit/five,
	)

/datum/discipline_power/daimonion/path/spirit/five
	name = "黑暗血魔法：摄魂之道五级"
	desc = "汲取受害者的意志力。"

	level = 5
	willpower_drain_amount = 8

	grouped_powers = list(
		/datum/discipline_power/daimonion/path/spirit/one,
		/datum/discipline_power/daimonion/path/spirit/two,
		/datum/discipline_power/daimonion/path/spirit/three,
		/datum/discipline_power/daimonion/path/spirit/four,
	)
