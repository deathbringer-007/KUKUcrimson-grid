/obj/item/path_spellbook
	abstract_type = /obj/item/path_spellbook
	name = "道途法术书"
	desc = "默认的道途法术书。如果你在游戏中看到了它，请向开发者报告。"
	icon = 'modular_darkpack/modules/paths/icons/paths.dmi'
	icon_state = "spellbook_unfinished"
	drop_sound = 'sound/items/handling/book_drop.ogg'
	pickup_sound = 'sound/items/handling/book_pickup.ogg'
	var/activate_sound = 'modular_darkpack/modules/paths/sounds/open_book.ogg'
	var/deactivate_sound = 'modular_darkpack/modules/paths/sounds/close_book.ogg'

	var/datum/discipline/required_discipline = /datum/discipline/thaumaturgy // CRIMSON GRID ADD: DARK THAUMATURGY
	var/path_type = null
	var/path_level = 1
	var/do_after_time = 30 SECONDS

	var/identified = FALSE
	var/true_name = ""
	var/true_desc = ""

	var/datum/storyteller_roll/identify_occult/identify_roll

/obj/item/path_spellbook/Initialize(mapload)
	. = ..()
	if(!identified)
		true_name = name
		true_desc = desc
		name = "尘封的古书"
		desc = "这本书满是灰尘，书页也已磨损。大概不是什么重要的东西。"
	AddComponent(/datum/component/selling, 100, "artifact", FALSE, 0, 10, TRUE)

/obj/item/path_spellbook/examine(mob/user)
	. = ..()
	if(!identified)
		. += span_notice("你可以试着拂去灰尘，看看下面藏着什么。")

/obj/item/path_spellbook/attack_self(mob/living/carbon/human/user)
	. = ..()
	if(!istype(user))
		return FALSE

	if(!identified)
		if(do_after(user, 1 TURNS))
			if(!identify_roll)
				identify_roll = new()
				identify_roll.difficulty = path_level + 3
			var/roll = identify_roll.st_roll(user, src)
			switch(roll)
				if(ROLL_SUCCESS)
					to_chat(user, span_cult("你拂去了这本不起眼古书上的灰尘。是不是有人把它从图书馆带出来后遗失了？"))
					src.identified = TRUE
					name = true_name
					desc = true_desc
					return
				else
					to_chat(user, span_warning("你没能弄清这本书的真正来历，转而去关注更重要的事情。也许它只是本食谱？"))
					return
		return

	var/datum/splat/vampire/kindred/kindred = get_kindred_splat(user)
	var/datum/discipline/existing_path_discipline = kindred?.get_discipline(path_type)

	if(!path_type)
		to_chat(user, span_warning("这本法术书似乎并不完整！"))
		return

	if(get_kindred_splat(user))
		// CRIMSON GRID ADD: DARK THAUMATURGY
		if(!user.get_discipline(required_discipline))
			to_chat(user, span_warning("你必须掌握[DISCIPLINE_DISPLAY_NAME(required_discipline.name)]才能使用这本书！"))
		// CRIMSON GRID ADD END: DARK THAUMATURGY
			return
		if(existing_path_discipline)
			//Then we check if the level can be learned
			if(path_level == existing_path_discipline.level)
				// User already knows this level
				to_chat(user, span_warning("你已经掌握这本书的内容了！"))
				return
			else if(path_level == existing_path_discipline.level + 1)
				// The book's level is one higher than the user's current level
				user.playsound_local(user, activate_sound, 50, FALSE)
			else if (path_level > existing_path_discipline.level + 1)
				// The book's level is too high for the user to learn
				to_chat(user, span_warning("你必须先学习前几级的法术书！"))
				return
			else if (path_level < existing_path_discipline.level)
				// The book's level is lower than the user's current level
				to_chat(user, span_warning("你已经掌握这条道途更高等级的知识了！"))
				return
		// If we reach here, the user does not know this path at all
		if(path_level > 1 && !existing_path_discipline)
			to_chat(user, span_warning("你必须先掌握这条道途的第一级，才能学习更高等级！"))
			return
		else if(path_level == 1 && !existing_path_discipline)
			user.playsound_local(user, activate_sound, 50, FALSE)
	else
		to_chat(user, span_warning("这本书里尽是难以理解的胡言乱语。"))
		return

	var/original_icon_state = icon_state
	icon_state = "[original_icon_state]-opened"
	update_appearance()

	to_chat(user, span_notice("你开始研读这些古老文字……"))

	if(do_after(user, do_after_time, target = src))
		// Now checking the level again to assign the correct path level
		if(!existing_path_discipline)
			user.give_st_power(path_type, path_level)
			to_chat(user, span_notice("[name]中的知识涌入你的脑海！"))
		else
			// If the user already knows the path, update the level
			to_chat(user, span_notice("你加深了对[name]的理解！"))

			user.remove_st_power(path_type)
			user.give_st_power(path_type, path_level)

		user.playsound_local(user, deactivate_sound, 50, FALSE)
		qdel(src)
	else
		icon_state = original_icon_state
		update_appearance()
		to_chat(user, span_warning("你的专注被打断了！"))


/obj/item/occult_book
	abstract_type = /obj/item/occult_book
	name = "神秘学典籍"
	desc = "默认的神秘学典籍。如果你在游戏中看到了它，请向开发者报告。"
	icon = 'modular_darkpack/modules/paths/icons/paths.dmi'
	icon_state = "spellbook_unfinished"
	var/do_after_time = 30 SECONDS
	var/activate_sound = 'modular_darkpack/modules/paths/sounds/open_book.ogg'
	var/deactivate_sound = 'modular_darkpack/modules/paths/sounds/close_book.ogg'
	drop_sound = 'sound/items/handling/book_drop.ogg'
	pickup_sound = 'sound/items/handling/book_pickup.ogg'

	// research vars overriden by subtypes
	var/research_value = 10
	var/study_cooldown = 30 MINUTES
	var/study_research_value = 50
	var/required_discipline = /datum/discipline/thaumaturgy
	var/no_trait_message = "缺乏相应的知识，你无法理解这些文字。"
	var/cooldown_message = "你刚刚深入研读过这本典籍。需要等待%TIME%，才能从中获得新的领悟。"
	var/study_start_message = "你开始研读这本神秘学典籍……"
	var/study_interrupted_message = "你的专注被打断了，未能从书中汲取任何有意义的知识。"
	var/research_gain_message = "研读这本典籍让你获得了%POINTS%研究点！"

	// Flavor texts, must be overriden by subtypes
	var/list/study_flavor_texts = list(
		"你研读着奥秘文字，对神秘学的隐秘有了新的领悟。",
		"古老的知识从书页间流入你的脑海。",
		"书中的文字揭示了超自然力量与仪式的秘密。"
	)

/obj/item/occult_book/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling, 100, "artifact", FALSE, 0, 10, TRUE)

/obj/item/occult_book/attack_self(mob/living/carbon/human/user)
	if(!can_study(user))
		return ..()

	if(!check_cooldown(user))
		return

	begin_study(user)
	return ..()

/obj/item/occult_book/proc/can_study(mob/living/carbon/human/user)
	if(required_discipline && !user.get_discipline(required_discipline))
		to_chat(user, span_warning(no_trait_message))
		return FALSE
	return TRUE

/obj/item/occult_book/proc/check_cooldown(mob/living/carbon/human/user)
	if(!COOLDOWN_FINISHED(src, study_cooldown))
		var/replaced_text_cooldown_message = replacetext(cooldown_message, "%TIME%", "[COOLDOWN_TIMELEFT(src, study_cooldown) / 10]秒")
		to_chat(user, span_warning(replaced_text_cooldown_message))
		return FALSE
	return TRUE

/obj/item/occult_book/proc/begin_study(mob/living/carbon/human/user)
	var/original_icon_state = icon_state
	icon_state = "[original_icon_state]-opened"
	update_appearance()

	to_chat(user, span_notice(study_start_message))
	user.playsound_local(user, activate_sound, 50, FALSE)

	if(do_after(user, do_after_time, target = src))
		complete_study(user)
	else
		to_chat(user, span_warning(study_interrupted_message))

	icon_state = original_icon_state
	update_appearance()

/obj/item/occult_book/proc/complete_study(mob/living/carbon/human/user)
	user.research_points += study_research_value
	var/flavor_text = pick(study_flavor_texts)
	to_chat(user, span_cult(flavor_text))

	var/formatted_message = replacetext(research_gain_message, "%POINTS%", "[study_research_value]")
	to_chat(user, span_green(formatted_message))

	COOLDOWN_START(src, study_cooldown, study_cooldown)
	user.playsound_local(user, deactivate_sound, 50, FALSE)
