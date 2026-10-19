#define TRAIT_MESMERIZED "mesmerized"

/datum/discipline/dominate
	name = "Dominate"
	desc = {"压制目标的意志；只要对方的意志不比你强，就能迫使其服从。
● 号令：操控 + 威吓
●● 催眠：操控 + 领导
●●● 遗忘之心：机敏 + 诡诈
●●●● 心智驯化：魅力 + 领导
●●●●● 附身：魅力 + 威吓"}
	icon_state = "dominate"
	power_type = /datum/discipline_power/dominate
	var/list/botched_targets //a lazylist of weakrefs

/datum/discipline/dominate/post_gain()
	. = ..()
	if(level >= 4)
		RegisterSignal(owner, COMSIG_MOB_EMOTE, PROC_REF(on_snap))

/datum/discipline/dominate/post_loss()
	. = ..()
	UnregisterSignal(owner, COMSIG_MOB_EMOTE)

/datum/discipline/dominate/proc/on_snap(atom/source, datum/emote/emote_args)
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(handle_snap), source, emote_args)

/datum/discipline/dominate/proc/handle_snap(atom/source, datum/emote/emote_args)
	var/list/emote_list = list("snap", "snap2", "snap3", "whistle")
	if(!emote_list.Find(emote_args.key))
		return
	for(var/mob/living/carbon/human/target in get_hearers_in_view(6, owner))
		var/mob/living/carbon/human/conditioner = target.conditioner?.resolve()
		if(conditioner != owner)
			continue
		switch(emote_args.key)
			if("snap")
				target.SetSleeping(0)
				target.dir = get_dir(target, owner)
				target.emote("me", 1, "专注地面向<b>[owner]</b>。", TRUE)
				to_chat(target, span_danger("注意！"))
			if("snap2")
				target.dir = get_dir(target, owner)
				target.Immobilize(50)
				target.emote("me",1,"听到<b>[owner]</b>的响指，猛地一颤。", TRUE)
				to_chat(target, span_danger("停下！"))
			if("snap3")
				target.Knockdown(50)
				target.Immobilize(80)
				target.emote("me",1,"的双膝承受不住身体的重量，弯了下去。",TRUE)
				target.do_jitter_animation(0.1 SECONDS)
				to_chat(target, span_danger("倒下！"))
			if("whistle")
				target.apply_status_effect(STATUS_EFFECT_AWE, owner)
				to_chat(target, span_danger("过来！"))


/datum/discipline_power/dominate
	name = "Dominate power name"
	desc = "Dominate power description"
	vitae_cost = 0 //No Dominate 1-5 abilities cost blood.
	frenzy_usable = FALSE

	activate_sound = 'modular_darkpack/modules/powers/sounds/dominate.ogg'

/datum/discipline_power/dominate/activate(mob/living/carbon/human/target)
	. = ..()

	var/mob/living/carbon/human/dominate_target = target
	dominate_target.remove_overlay(POWERS_LAYER)
	var/mutable_appearance/dominate_overlay = mutable_appearance('modular_darkpack/modules/powers/icons/dominate.dmi', "dominate", -POWERS_LAYER)
	dominate_overlay.pixel_z = 2
	dominate_target.overlays_standing[POWERS_LAYER] = dominate_overlay
	dominate_target.apply_overlay(POWERS_LAYER)

	//dominate compels the target to have their gaze absolutely entrapped by the dominator
	dominate_target.face_atom(owner)
	to_chat(dominate_target, span_danger("你完全陷入了[owner]的凝视之中，无法移开目光、呼救，甚至无力尝试抵抗。只能祈祷有人来将你拖走或推开，救你脱身。"))
	owner.face_atom(dominate_target)
	addtimer(CALLBACK(dominate_target, TYPE_PROC_REF(/mob/living/carbon/human, post_dominate_checks), dominate_target), 2 SECONDS)
	return TRUE

//dicerolling
//all dominate rolls involve rolling some stat against the victim's permanent willpower with many caveats. this proc rolls and considers those caveats
/datum/discipline_power/dominate/proc/dominate_check(mob/living/carbon/human/owner, mob/living/carbon/human/target, owner_stat = list(), numerical = FALSE)
	var/datum/discipline/dominate/parent_disc = discipline

	if(HAS_TRAIT(owner, TRAIT_NO_EYE_CONTACT))
		to_chat(owner, span_warning("你无法与对方对视！"))
		return FALSE

	//someone has botched a dominate against this human
	if(LAZYLEN(parent_disc.botched_targets))
		for(var/datum/weakref/ref in parent_disc.botched_targets)
			var/mob/living/carbon/human/botched = ref.resolve()
			if(!botched)
				LAZYREMOVE(parent_disc.botched_targets, ref)
				continue
			if(botched == target)
				to_chat(owner, span_warning("你之前的大失败使[target]在今夜余下的时间内能够抵抗你的支配术。"))
				return FALSE

	//automatically succeed against my conditioned servant
	var/mob/living/carbon/human/conditioner = target.conditioner?.resolve()
	if(owner == conditioner)
		if(numerical == TRUE)
			return 8
		else
			return TRUE

	if(HAS_TRAIT(target, TRAIT_CANNOT_RESIST_MIND_CONTROL))
		if(numerical == TRUE)
			return 8
		else
			return TRUE

	var/theirpower = target.st_get_stat(STAT_TEMPORARY_WILLPOWER)

	if(HAS_TRAIT(target, TRAIT_IRON_WILL))
		theirpower += 3

	//tremere have built-in safeguards to easily dominate their stone servitors
	if(HAS_TRAIT(target, TRAIT_WEAK_TO_DOMINATE))
		theirpower -= 2

	if(HAS_TRAIT(target, TRAIT_WEAK_WILLED))
		theirpower -= 2

	if(HAS_TRAIT(target, TRAIT_IN_FRENZY))
		theirpower += 2

	if((!(owner.obscured_slots & HIDEFACE))&(HAS_TRAIT(owner, TRAIT_DISFIGURED_APPEARANCE))) // Are we visibly disfigured?
		theirpower += 2

	if(HAS_TRAIT(owner, TRAIT_ENCHANTING_VOICE))
		theirpower -= 2

	if(!get_kindred_splat(target)) // Is our target mortal?
		if(HAS_TRAIT(owner, TRAIT_GRAVE_SMELL)) // Are we stinky?
			theirpower += 1
		if((HAS_TRAIT(owner, TRAIT_GLOWING_EYES)) && (!owner.is_eyes_covered()) && (STAT_INTIMIDATION in owner_stat)) // Are we intimidating a mortal with uncovered eyes?
			theirpower -= 1

	//wearing dark sunglasses makes it harder for the Dominator to capture the victim's gaze and raises difficulty -- V20 'Dominate' section titled 'Eye Contact'
	var/total_tint = 0
	var/mob/living/carbon/human/human_target = target
	for(var/obj/item/clothing/worn_item in human_target.get_equipped_items(INCLUDE_ABSTRACT))
		total_tint += worn_item.tint

	if(total_tint > 0)
		if(total_tint >= 2)
			theirpower += 2
		else
			theirpower += 1

	//if anyone else tries to dominate my conditioned servant its much harder for them but not for me
	if(target.conditioner?.resolve())
		theirpower += 3

	// This var needs to go after everything that changes theirpower.
	var/mypower = SSroll.storyteller_roll_datum(owner, target, difficulty = theirpower, applic_stats = owner_stat, numerical = TRUE)

	//i've botched so now this person is immune to dominate for the rest of the round
	if(mypower < 0)
		LAZYADD(parent_disc.botched_targets, WEAKREF(target))
		to_chat(owner, span_warning("你的支配术出现了大失败！[target]在今夜余下的时间内能够抵抗你的支配术。"))
		return FALSE

	var/datum/splat/vampire/kindred/owner_splat = get_kindred_splat(owner)
	var/datum/splat/vampire/kindred/target_splat = get_kindred_splat(target)
	if(target_splat)
		if(owner_splat.generation > target_splat.generation)
			to_chat(owner, span_warning("你无法支配[target]，对方的血液力量比你的更强！"))
			return FALSE

	if(HAS_TRAIT(target, TRAIT_MERIT_UNTAMABLE))
		to_chat(owner, span_warning("你无法支配[target]，那是一头无法驯服的野兽！"))
		return FALSE

	if(numerical == TRUE)
		return mypower

	//did we succeed or fail the roll
	return (mypower > 0)

//dominate involves capturing the victim's gaze, leaving them completely helpless as you hypnotically invade their mind.
/datum/discipline_power/dominate/proc/immobilize_target(mob/living/carbon/human/target, duration = 5 SECONDS)
	ADD_TRAIT(target, TRAIT_IMMOBILIZED, TRAIT_GENERIC)
	ADD_TRAIT(target, TRAIT_PACIFISM, "dominate") // CRIMSON EDIT ADD - DOM PACIFY
	RegisterSignals(target, list(COMSIG_ATOM_ATTACKBY, COMSIG_MOB_ITEM_ATTACK, COMSIG_PROJECTILE_PREHIT), PROC_REF(on_target_attacked))
	if(do_after(owner, duration, target))
		release_target(target)
		return TRUE
	else
		release_target(target)
		return FALSE

/datum/discipline_power/dominate/proc/on_target_attacked(datum/source)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/target = source
	release_target(target)
	to_chat(owner, span_warning("[target]遭到攻击，打断了你的专注！"))
	to_chat(target, span_warning("你遭到攻击，施加在你心灵上的控制随之解除！"))

/datum/discipline_power/dominate/proc/release_target(mob/living/carbon/human/target)
	UnregisterSignal(target, list(COMSIG_ATOM_ATTACKBY, COMSIG_MOB_ITEM_ATTACK, COMSIG_PROJECTILE_PREHIT))
	to_chat(target, span_danger("你重新掌控了自己的注意力，终于能从那威严的目光中移开视线。"))
	REMOVE_TRAIT(target, TRAIT_IMMOBILIZED, TRAIT_GENERIC)
	REMOVE_TRAIT(target, TRAIT_PACIFISM, "dominate") // CRIMSON EDIT ADD - DOM PACIFY

/mob/living/carbon/human/proc/post_dominate_checks(mob/living/carbon/human/dominate_target)
	dominate_target?.remove_overlay(POWERS_LAYER)

//COMMAND
/datum/discipline_power/dominate/command
	name = "号令"
	desc = "说出一个词，迫使他人服从。"
	level = 1
	check_flags = DISC_CHECK_SPEAK|DISC_CHECK_SEE|DISC_CHECK_DIRECT_SEE
	target_type = TARGET_HUMAN
	cooldown_length = 15 SECONDS
	duration_length = 3 SECONDS
	range = 7
	var/successes
	var/custom_command = ""

//successes for dominate 1
/datum/discipline_power/dominate/command/proc/get_success_message(successes)
	switch(successes)
		if(1)
			return "力度轻微、持续短暂"
		if(2)
			return "通常程度的强迫"
		if(3)
			return "力度适中、持续较久"
		if(4)
			return "力度强烈、持续长久"
		if(5)
			return "超自然的强迫力量"
		else
			return "立即而坚决地执行"

/datum/discipline_power/dominate/command/pre_activation_checks(mob/living/carbon/human/target)

	custom_command = tgui_input_text(owner, "支配号令", "你的命令是什么？", encode = FALSE)
	owner.say(custom_command)

	successes = dominate_check(owner, target, list(STAT_MANIPULATION, STAT_INTIMIDATION), numerical = TRUE)
	if(successes > 0)
		var/command_strength = get_success_message(successes)
		to_chat(owner, span_notice("你能对目标施加号令，效果为：[command_strength]！"))
		var/mob/living/carbon/human/conditioner = target.conditioner?.resolve()
		if(owner != conditioner)
			//V20 Dominate 'Command' section
			if(length(splittext(custom_command, " ")) > 1)
				to_chat(owner, span_warning("命令只能包含一个词，不能有空格！"))
				return FALSE
		if(!custom_command)
			return FALSE
		return TRUE

	to_chat(owner, span_warning("[target]抵抗了你的支配！"))
	to_chat(target, span_warning("[owner]紧紧地盯着你。"))
	do_cooldown(TRUE)
	return FALSE

/datum/discipline_power/dominate/command/activate(mob/living/carbon/human/target)
	. = ..()
	to_chat(owner, span_warning("你成功支配了[target]的心灵！"))
	log_combat(owner, target, "Dominated with Command: [custom_command]")
	to_chat(target, span_big("[custom_command]"))
	var/command_strength = get_success_message(successes)
	to_chat(target, span_warning("[owner]以[successes]个成功数支配了你的心灵。你被迫执行“[custom_command]”，效果为：[command_strength]。"))
	SEND_SOUND(target, sound('modular_darkpack/modules/powers/sounds/dominate.ogg'))

// MESMERIZE
/datum/discipline_power/dominate/mesmerize
	name = "催眠"
	desc = "在目标脑海中植入催眠暗示，使其在思绪中反复回响。"
	level = 2
	check_flags = DISC_CHECK_SPEAK|DISC_CHECK_SEE|DISC_CHECK_DIRECT_SEE
	target_type = TARGET_HUMAN
	cooldown_length = 30 SECONDS
	range = 7
	var/custom_message = ""
	var/pulse_interval
	var/datum/weakref/current_target_ref
	var/datum/weakref/end_action_ref
	var/pulse_active = FALSE

/datum/discipline_power/dominate/mesmerize/pre_activation_checks(mob/living/carbon/human/target)
	//you can't mesmerize someone already mesmerized
	if(HAS_TRAIT(target, TRAIT_MESMERIZED))
		to_chat(owner, span_warning("[target]已经受到催眠暗示的影响！"))
		return FALSE

	if(pulse_active)
		to_chat(owner, span_warning("你已经有一个正在生效的催眠！"))
		return FALSE

	var/successes = dominate_check(owner, target, list(STAT_MANIPULATION, STAT_LEADERSHIP), numerical = TRUE)
	if(successes > 0)
		custom_message = tgui_input_text(owner, "催眠暗示", "要让什么催眠暗示在对方脑海中回响？", encode = FALSE)
		if(!custom_message)
			return FALSE
		pulse_interval = successes
		return TRUE
	pulse_interval = 0

	to_chat(owner, span_warning("[target]抵抗了你的支配！"))
	to_chat(target, span_warning("[owner]紧紧地盯着你。"))

	do_cooldown(cooldown_length)
	return FALSE

/datum/discipline_power/dominate/mesmerize/activate(mob/living/carbon/human/target)
	. = ..()
	if(!immobilize_target(target, 10 SECONDS))
		to_chat(owner, span_warning("向[target]植入催眠暗示时，你的专注被打断了！"))
		return
	target.throw_alert("mesmerize", /atom/movable/screen/alert/mesmerize)
	log_combat(owner, target, "Dominated with Mesmerize: [custom_message]")
	to_chat(owner, span_warning("你成功在[target]的脑海中植入了催眠暗示！"))
	owner.say(custom_message)
	to_chat(target, span_info("一个催促你的念头潜入了你的潜意识。你不明白它从何而来，但它不断涌现，迫使你清醒时的思绪向它靠拢。"))
	to_chat(target, span_hypnophrase(custom_message))
	SEND_SOUND(target, sound('modular_darkpack/modules/powers/sounds/dominate.ogg'))
	current_target_ref = WEAKREF(target)
	ADD_TRAIT(target, TRAIT_MESMERIZED, TRAIT_GENERIC)

	//allow the dominator to end the mesmerization pulses early if the target completes the directive, assuming its an objective rather than a hypnotic suggestion (which is allowed)
	var/datum/action/vampire/end_mesmerization/end_action = new(owner, src)
	end_action.Grant(owner)
	end_action_ref = WEAKREF(end_action)
	pulse_active = TRUE
	start_mesmerization_cycle(target)

/datum/discipline_power/dominate/mesmerize/proc/start_mesmerization_cycle(mob/living/carbon/human/target)
	if(!pulse_active)
		return

	//the message pangs in the victim's mind every couple minutes depending on successes rolled.
	var/interval_minutes = max(1, 5 - pulse_interval)
	var/interval_deciseconds = interval_minutes * 60 * 10
	addtimer(CALLBACK(src, PROC_REF(mesmerization_pulse), target, interval_deciseconds, 1), interval_deciseconds)

/datum/discipline_power/dominate/mesmerize/proc/mesmerization_pulse(mob/living/carbon/human/target, interval, pulse_count)
	if(!pulse_active || !target || target.stat == DEAD)
		if(target)
			REMOVE_TRAIT(target, TRAIT_MESMERIZED, TRAIT_GENERIC)
		cleanup_mesmerization()
		return

	to_chat(target, span_hypnophrase("<font size='4'><b>[custom_message]</b></font>"))
	SEND_SOUND(target, sound('modular_darkpack/modules/powers/sounds/dominate.ogg', volume = 30))

	//once its pulsed 5 times, end the mesmerization. we don't need people seeing 'shit yourself' every minute til roundend.
	if(pulse_count >= 5)
		REMOVE_TRAIT(target, TRAIT_MESMERIZED, TRAIT_GENERIC)
		to_chat(target, span_notice("催眠暗示不再反复涌现，或已扎根，或随着你的意识逐渐恢复正常而悄然消散。"))
		cleanup_mesmerization()
		return

	if(pulse_active)
		addtimer(CALLBACK(src, PROC_REF(mesmerization_pulse), target, interval, pulse_count + 1), interval)

//for use in the /datum/action/vampire/end_mesmerization
/datum/discipline_power/dominate/mesmerize/proc/force_end_mesmerization()
	var/mob/living/carbon/human/current_target = current_target_ref?.resolve()
	if(!current_target || !pulse_active)
		return
	pulse_active = FALSE
	REMOVE_TRAIT(current_target, TRAIT_MESMERIZED, TRAIT_GENERIC)
	to_chat(current_target, span_hypnophrase("<font size='4'><b>[custom_message]</b></font>"))
	to_chat(current_target, span_notice("催眠暗示不再反复涌现，或已扎根，或随着你的意识逐渐恢复正常而悄然消散。"))
	current_target.clear_alert("mesmerize")
	cleanup_mesmerization()

/datum/discipline_power/dominate/mesmerize/proc/cleanup_mesmerization()
	var/mob/living/carbon/human/current_target = current_target_ref?.resolve()
	pulse_active = FALSE
	if(current_target)
		current_target.clear_alert("mesmerize")
	current_target_ref = null
	var/datum/action/vampire/end_mesmerization/action = end_action_ref?.resolve()
	if(action)
		action.Remove(owner)
	end_action_ref = null

/datum/action/vampire/end_mesmerization
	name = "终止催眠"
	desc = "强制结束你正在维持的催眠效果。"
	button_icon_state = "dominate"
	var/datum/discipline_power/dominate/mesmerize/linked_power

/datum/action/vampire/end_mesmerization/New(Target, datum/discipline_power/dominate/mesmerize/power)
	..()
	linked_power = power

/datum/action/vampire/end_mesmerization/Trigger(mob/clicker, trigger_flags)
	. = ..()
	if(!.)
		return

	if(!linked_power)
		Remove(owner)
		return FALSE
	linked_power.force_end_mesmerization()

// THE FORGETFUL MIND
/datum/discipline_power/dominate/the_forgetful_mind
	name = "遗忘之心"
	desc = "侵入一个人的心灵，重塑其记忆。"
	level = 3
	check_flags = DISC_CHECK_SPEAK|DISC_CHECK_SEE|DISC_CHECK_DIRECT_SEE
	target_type = TARGET_HUMAN
	cooldown_length = 1 MINUTES
	duration_length = 3 SECONDS
	range = 7
	var/custom_memory = ""
	var/successes

/datum/discipline_power/dominate/the_forgetful_mind/proc/get_success_message(successes)
	switch(successes)
		if(1)
			return "可以永久移除一段记忆，但无法用新记忆替代；留下的空白可能让真实记忆在适当的情境下重新浮现"
		if(2)
			return "可以永久移除多段记忆，但无法改写；留下的空白可能让真实记忆在竭力回想时重新浮现"
		if(3)
			return "可以永久改写或移除多段记忆，但若改写不够细致准确，真实记忆可能在很久以后重新浮现"
		if(4)
			return "可以对记忆进行深入而强力的改写或移除，彻底改变整件事情或整段对话的记忆"
		if(5 to INFINITY)
			return "潜意识完全瓦解，可以彻底重构整段人生经历或进行其他改动"

/datum/discipline_power/dominate/the_forgetful_mind/pre_activation_checks(mob/living/carbon/human/target)

	successes = dominate_check(owner, target, list(STAT_WITS, STAT_SUBTERFUGE), numerical = TRUE)
	if(successes > 0)
		var/mindwipe_strength = get_success_message(successes)
		to_chat(owner, span_notice("你的催眠凝视俘获了[target]，效果为：[mindwipe_strength]。"))
		custom_memory = tgui_input_text(owner, "改写记忆", "你要植入或改写什么记忆？", encode = FALSE)
		if(!custom_memory)
			return FALSE
		return TRUE
	to_chat(owner, span_warning("[target]抵抗了你的支配！"))
	to_chat(target, span_warning("[owner]紧紧地盯着你。"))
	do_cooldown(cooldown_length)
	return FALSE

/datum/discipline_power/dominate/the_forgetful_mind/activate(mob/living/carbon/human/target)
	. = ..()
	if(!immobilize_target(target, 10 SECONDS))
		to_chat(owner, span_danger("你对[target]的专注被打断，支配失败了……"))
		return
	log_combat(owner, target, "Dominated with The Forgetful Mind: [custom_memory]")
	to_chat(owner, span_warning("你成功侵入了[target]的心灵，改写了其记忆！"))
	owner.say(custom_memory, forced = FALSE, bubble_type = SPEECH_BUBBLE_TYPE)
	to_chat(target, span_hypnophrase(custom_memory))
	SEND_SOUND(target, sound('modular_darkpack/modules/powers/sounds/dominate.ogg'))
	SEND_SIGNAL(target, COMSIG_ALL_MASQUERADE_REINFORCE)
	var/mindwipe_strength = get_success_message(successes)
	to_chat(target, span_warning("[owner]以[successes]个成功数支配了你的心灵。其催眠力量达到了这样的程度：[mindwipe_strength]。"))

// CONDITIONING
/datum/discipline_power/dominate/conditioning
	name = "心智驯化"
	desc = "逐渐摧毁一个人的心智，使其服从你的意志。"
	level = 4
	check_flags = DISC_CHECK_SPEAK|DISC_CHECK_SEE|DISC_CHECK_DIRECT_SEE
	target_type = TARGET_HUMAN
	cooldown_length = 15 SECONDS
	duration_length = 6 SECONDS
	range = 2

/datum/discipline_power/dominate/conditioning/pre_activation_checks(mob/living/carbon/human/target)

	var/roll_success = dominate_check(owner, target, list(STAT_CHARISMA, STAT_LEADERSHIP))
	if(!roll_success)
		to_chat(owner, span_warning("[target]的心灵抵抗了你的支配！"))
		do_cooldown(cooldown_length)
	return roll_success

/datum/discipline_power/dominate/conditioning/activate(mob/living/carbon/human/target)
	. = ..()
	target.dir = get_dir(target, owner)
	to_chat(target, span_danger("看着我！"))
	owner.say("看着我。")
	if(!immobilize_target(target, 20 SECONDS))
		to_chat(owner, span_warning("你的专注被打断了！"))
		to_chat(target, span_notice("那压迫心灵的力量突然退去了。"))
		return
	target.conditioner = WEAKREF(owner)
	target.throw_alert("conditioning", /atom/movable/screen/alert/conditioning)
	to_chat(target, span_hypnophrase("你的脑海中满是关于[owner]的念头。对方的一言一行对你而言都无比重要。"))
	SEND_SOUND(target, sound('modular_darkpack/modules/powers/sounds/dominate.ogg'))

// POSSESSION
/datum/discipline_power/dominate/possession
	name = "附身"
	desc = "完全掌控目标的心灵与身体。"
	level = 5
	check_flags = DISC_CHECK_SPEAK|DISC_CHECK_SEE|DISC_CHECK_DIRECT_SEE
	target_type = TARGET_HUMAN
	cooldown_length = 5 MINUTES
	range = 7
	var/datum/weakref/active_possession

/datum/discipline_power/dominate/possession/pre_activation_checks(mob/living/carbon/human/target)

	if(get_kindred_splat(target) || get_garou_splat(target)) // DARKPACK TODO: reimplement Kuei-Jin
		to_chat(owner, span_warning("[get_kindred_splat(target) ? "你无法附身于另一名血族" : "你无法附身于这个生物——其内在的野兽正在抵抗"]！"))
		return FALSE

	if(target.possessed)
		to_chat(owner, span_warning("这个凡人已经被附身了！"))
		return FALSE

	var/roll_success = dominate_check(owner, target, list(STAT_CHARISMA, STAT_INTIMIDATION))
	if(!roll_success)
		to_chat(owner, span_warning("[target]抵抗了你的支配！"))
		to_chat(target, span_warning("[owner]紧紧地盯着你。"))
		do_cooldown(cooldown_length)
	return roll_success

/datum/discipline_power/dominate/possession/activate(mob/living/carbon/human/target)
	. = ..()
	target.dir = get_dir(target, owner)
	to_chat(target, span_danger("一股压倒性的力量侵入你的心灵，你的身体僵住了……"))

	to_chat(owner, span_warning("你开始将自己的意识融入[target]的心灵……"))

	if(!immobilize_target(target, 30 SECONDS))
		to_chat(owner, span_warning("你的专注被打断了！"))
		to_chat(target, span_notice("那压迫心灵的力量突然退去了。"))
		return
	var/datum/possession_controller/controller = new(owner, target, src)
	active_possession = WEAKREF(controller)
	to_chat(owner, span_warning("你夺取了[target]身体的控制权！"))
	to_chat(target, span_danger("另一个心灵夺取了控制权，你的意识被粗暴地挤了出去！"))
	target.possessed = TRUE
	log_combat(owner, target, "Possessed via Dominate Possession")
	SEND_SOUND(target, sound('modular_darkpack/modules/powers/sounds/dominate.ogg'))

//AUTONOMIC MASTERY
/datum/discipline_power/dominate/autonomic_mastery
	name = "自主神经掌控"
	desc = "控制目标的自主神经系统。"

	level = 6

	check_flags = DISC_CHECK_SPEAK|DISC_CHECK_SEE
	target_type = TARGET_HUMAN

	cooldown_length = 15 SECONDS
	range = 7

/datum/discipline_power/dominate/autonomic_mastery/pre_activation_checks(mob/living/carbon/human/target)

	var/roll_success = dominate_check(owner, target)
	if(roll_success)
		return TRUE
	else
		do_cooldown(cooldown_length)
		return FALSE

/datum/discipline_power/dominate/autonomic_mastery/activate(mob/living/carbon/human/target)
	. = ..()
	to_chat(owner, span_warning("你成功支配了[target]的身体机能！"))
	var/list/orders = list("入睡", "醒来", "心脏病发作", "复苏")
	var/order = tgui_input_list(owner, "选择一个命令","选择命令", orders)
	if(!order)
		return
	switch(order)
		if("入睡")
			owner.say("睡吧")
			target.Sleeping(200)
			to_chat(target, span_danger("你突然感到筋疲力尽。"))
			SEND_SOUND(target, sound('modular_darkpack/modules/powers/sounds/dominate.ogg'))
		if("醒来")
			owner.say("醒来")
			target.SetSleeping(0)
			to_chat(target, span_danger("你突然感到精力充沛。"))
			SEND_SOUND(target, sound('modular_darkpack/modules/powers/sounds/dominate.ogg'))
		if("心脏病发作")
			owner.say("死去")
			target.adjust_stamina_loss(60, FALSE)
			target.set_heartattack(TRUE)
			to_chat(target, span_danger("你的胸口传来一阵剧痛！"))
			SEND_SOUND(target, sound('modular_darkpack/modules/powers/sounds/dominate.ogg'))
		if("复苏")
			owner.say("活过来")
			target.set_heartattack(FALSE)
			to_chat(target, span_danger("你感到心脏猛烈地跳动起来！"))
			target.revive()
			SEND_SOUND(target, sound('modular_darkpack/modules/powers/sounds/dominate.ogg'))

#undef TRAIT_MESMERIZED
