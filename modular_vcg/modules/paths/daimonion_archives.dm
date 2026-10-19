#define FAVOR_MULTIPLIER 3

/obj/structure/retail/occult/baali
	icon = 'modular_darkpack/modules/deprecated/icons/64x64.dmi'
	icon_state = "baali"
	pixel_w = -16
	pixel_z = -16
	owner_needed = FALSE
	desc = "用你的恶魔学识向炼狱诸魔祈求恩宠。"
	name = "炼狱符文"

	products_list = list(
	// SPELLBOOKS
	new /datum/data/vending_product("痛苦之道法术书（I 级）",	/obj/item/path_spellbook/path_of_pain/level1,	130),
	new /datum/data/vending_product("痛苦之道法术书（II 级）",	/obj/item/path_spellbook/path_of_pain/level2,	180),
	new /datum/data/vending_product("痛苦之道法术书（III 级）",	/obj/item/path_spellbook/path_of_pain/level3,	210),
	new /datum/data/vending_product("痛苦之道法术书（IV 级）",	/obj/item/path_spellbook/path_of_pain/level4,	240),
	new /datum/data/vending_product("痛苦之道法术书（V 级）",	/obj/item/path_spellbook/path_of_pain/level5,	270),

	new /datum/data/vending_product("炼狱之火法术书（I 级）",	/obj/item/path_spellbook/fires_of_inferno/level1,	130),
	new /datum/data/vending_product("炼狱之火法术书（II 级）",	/obj/item/path_spellbook/fires_of_inferno/level2,	180),
	new /datum/data/vending_product("炼狱之火法术书（III 级）",	/obj/item/path_spellbook/fires_of_inferno/level3,	210),
	new /datum/data/vending_product("炼狱之火法术书（IV 级）",	/obj/item/path_spellbook/fires_of_inferno/level4,	240),
	new /datum/data/vending_product("炼狱之火法术书（V 级）",	/obj/item/path_spellbook/fires_of_inferno/level5, 270),

	new /datum/data/vending_product("摄魂之道法术书（I 级）",	/obj/item/path_spellbook/taking_of_spirit/level1,	130),
	new /datum/data/vending_product("摄魂之道法术书（II 级）",	/obj/item/path_spellbook/taking_of_spirit/level2,	180),
	new /datum/data/vending_product("摄魂之道法术书（III 级）",	/obj/item/path_spellbook/taking_of_spirit/level3,	210),
	new /datum/data/vending_product("摄魂之道法术书（IV 级）",	/obj/item/path_spellbook/taking_of_spirit/level4,	240),
	new /datum/data/vending_product("摄魂之道法术书（V 级）",	/obj/item/path_spellbook/taking_of_spirit/level5, 270),

	// ARTIFACTS
	// Lower tier artifacts
	new /datum/data/vending_product("威卡帕格蓟", /obj/item/occult_artifact/vampire/weekapaug_thistle, 75),
	new /datum/data/vending_product("裹尸布灵器", /obj/item/occult_artifact/vampire/mummywrap_fetish, 70),
	new /datum/data/vending_product("加尔朱姆", /obj/item/occult_artifact/vampire/galdjum, 70),
	new /datum/data/vending_product("血星", /obj/item/occult_artifact/vampire/bloodstar, 70),

	// Mid tier artifacts
	new /datum/data/vending_product("妖精护符", /obj/item/occult_artifact/vampire/fae_charm, 120),
	new /datum/data/vending_product("戴蒙诺里", /obj/item/occult_artifact/vampire/daimonori, 120),
	new /datum/data/vending_product("阿拉穆特之钥", /obj/item/occult_artifact/vampire/key_of_alamut, 130),
	new /datum/data/vending_product("伊莱莎之心", /obj/item/occult_artifact/vampire/heart_of_eliza, 140),
	new /datum/data/vending_product("血石", /obj/item/occult_artifact/vampire/bloodstone, 140),

	// High tier artifacts
	new /datum/data/vending_product("憎恶之杯", /obj/item/occult_artifact/vampire/odious_chalice, 180),

)

/obj/structure/retail/occult/baali/has_purchase_privileges(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/human_user = user
		return human_user.get_discipline(/datum/discipline/daimonion)

/obj/structure/retail/occult/baali/proc/calculate_favor(mob/living/carbon/human/sacrificed)
	var/favor = 25
	if(get_kindred_splat(sacrificed))
		favor = ((GHOUL_GENERATION - clamp(sacrificed.get_generation(), 1, 17)) * 8 + 78) //the '8+78' creates a linear scale based on generation with 8 being 150 favor, 13th being 100 favor, and 16th being 78 favor.
	if(get_garou_splat(sacrificed) || get_corax_splat(sacrificed))
		favor = 100
	if(get_ghoul_splat(sacrificed))
		favor = 50
	return favor * FAVOR_MULTIPLIER

/obj/structure/retail/occult/baali/attackby(obj/item/I, mob/user, params)
	. = ..()
	if(can_shop(user))
		var/sacrifice = FALSE
		var/upset = FALSE
		if(ishuman(user))
			var/mob/living/carbon/human/human_user = user
			for(var/mob/living/carbon/human/sacrificed_human in get_turf(src))
				if(sacrificed_human.stat < HARD_CRIT)
					continue
				if(!sacrificed_human.mind)
					upset = TRUE
					var/turf/throw_turf = get_edge_target_turf(sacrificed_human, pick(GLOB.alldirs))
					sacrificed_human.safe_throw_at(throw_turf, 3, 1, src, spin = TRUE, force = MOVE_FORCE_STRONG, gentle = TRUE)
					continue
				human_user.infernal_favor += calculate_favor(sacrificed_human)
				var/spawn_point = sacrificed_human.mind.assigned_role.get_roundstart_spawn_point()
				if(spawn_point)
					if(HAS_TRAIT_FROM(sacrificed_human, TRAIT_AURA_OF_INFERNO, DAIMONION_TRAIT))
						to_chat(sacrificed_human, span_userdanger("你的灵魂被拖入了炼狱位面！"))
						sacrificed_human.dust(drop_items = TRUE)
						continue
					to_chat(sacrificed_human, span_userdanger("有什么正在撕扯你的灵魂！好痛！"))
					sacrificed_human.forceMove(spawn_point)
					ADD_TRAIT(sacrificed_human, TRAIT_AURA_OF_INFERNO, DAIMONION_TRAIT)
					SEND_SIGNAL(sacrificed_human, COMSIG_MOB_UPDATE_AURA)
					sacrificed_human.AdjustSleeping(5 SECONDS)
					addtimer(CALLBACK(src, PROC_REF(on_wake_up), sacrificed_human), 5 SECONDS)
					sacrificed_human.log_message("has been sacrificed the first time on baali rune by [key_name(user)].", LOG_GAME)
					log_admin("[key_name(sacrificed_human)] has been sacrificed the first time on baali rune by [key_name(user)].")
				else
					sacrificed_human.dust(drop_items = TRUE)
				sacrifice = TRUE
			if(upset)
				to_chat(human_user, span_warning("炼狱诸魔只渴求拥有心智的生灵！"))
				human_user.adjust_fire_stacks(1, overwrite_color = COLOR_VERY_DARK_LIME_GREEN)
			if(sacrifice || upset)
				playsound(get_turf(src), 'sound/effects/magic/demon_dies.ogg', 100, TRUE)
				animate(src, color = initial(color), time = 0.5 SECONDS)
				addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, update_atom_colour)), 0.5 SECONDS)
			else
				interface_interact(human_user)

/obj/structure/retail/occult/baali/proc/on_wake_up(mob/living/carbon/human/sacrificed_human)
	sacrificed_human.SetSleeping(0)
	to_chat(sacrificed_human, span_warning("痛苦逐渐消退，但你感到内心空洞。再来一次，你就活不成了。"))
	to_chat(sacrificed_human, span_userdanger("你不记得是谁带走了你，也不记得身处何地，更不记得此前发生过什么。"))

// BaaliSpellbookVendor.jsx in tgui/interfaces
/obj/structure/retail/occult/baali/proc/interface_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BaaliSpellbookVendor", name)
		ui.open()

/obj/structure/retail/occult/baali/ui_data(mob/user)
	. = list()
	.["user"] = list()
	if(ishuman(user))
		var/mob/living/carbon/human/human_user = user
		.["user"]["points"] = human_user.infernal_favor
		.["user"]["name"] = "[human_user.real_name]"
		.["user"]["has_daimonion"] = !!human_user.get_discipline(/datum/discipline/daimonion)
		.["user"]["has_privileges"] = has_purchase_privileges(human_user)
	else
		.["user"]["points"] = 0
		.["user"]["name"] = "未知"
		.["user"]["has_daimonion"] = FALSE
		.["user"]["has_privileges"] = FALSE

	.["product_records"] = list()
	for(var/datum/data/vending_product/prize in products_list)
		var/stock_count = prize.amount
		var/obj/item/product_item = prize.product_path
		var/list/product_data = list(
			path = replacetext(replacetext("[prize.product_path]", "/obj/item/", ""), "/", "-"),
			name = prize.name,
			price = prize.price,
			ref = REF(prize),
			stock = stock_count,
			available = (stock_count > 0),
			icon = initial(product_item.icon),
			icon_state = initial(product_item.icon_state)
		)
		.["product_records"] += list(product_data)

/obj/structure/retail/occult/baali/ui_act(action, params)
	if(action != "purchase")
		return ..()

	if(!ishuman(usr))
		return

	var/mob/living/carbon/human/human_user = usr

	if(!get_kindred_splat(usr))
		return

	var/datum/data/vending_product/prize = locate(params["ref"]) in products_list
	var/current_stock = prize.amount
	if(current_stock <= 0)
		to_chat(usr, span_alert("错误：[prize.name]已售罄！"))
		return

	if(prize.price > human_user.infernal_favor)
		to_chat(usr, span_alert("错误：恩宠不足，无法购买[prize.name]！你需要[prize.price]点恩宠。"))
		return

	human_user.infernal_favor -= prize.price

	prize.amount -= 1

	to_chat(usr, span_notice("炼狱符文涌出恶魔能量，[prize.name]随之显现！"))
	new prize.product_path(loc)
	return TRUE

//offer artifacts to the shop for research points AND increment stock
/obj/structure/retail/occult/baali/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	. = ..()
	if(istype(tool, /obj/item/occult_artifact))
		var/obj/item/occult_artifact/artifact = tool

		if(!ishuman(user))
			return ITEM_INTERACT_BLOCKING

		var/mob/living/carbon/human/human_user = user

		if(artifact.research_value <= 0)
			to_chat(user, span_warning("炼狱诸魔认为这件遗物毫无价值。"))
			return ITEM_INTERACT_BLOCKING

		human_user.infernal_favor += artifact.research_value

		increment_stock(artifact.type)

		//when donating an artifact, increase stock of a random spellbook
		increment_stock(pick(
			/obj/item/path_spellbook/path_of_pain/level1,
			/obj/item/path_spellbook/path_of_pain/level2,
			/obj/item/path_spellbook/path_of_pain/level3,
			/obj/item/path_spellbook/path_of_pain/level4,
			/obj/item/path_spellbook/path_of_pain/level5,
			/obj/item/path_spellbook/fires_of_inferno/level1,
			/obj/item/path_spellbook/fires_of_inferno/level2,
			/obj/item/path_spellbook/fires_of_inferno/level3,
			/obj/item/path_spellbook/fires_of_inferno/level4,
			/obj/item/path_spellbook/fires_of_inferno/level5,
			/obj/item/path_spellbook/taking_of_spirit/level1,
			/obj/item/path_spellbook/taking_of_spirit/level2,
			/obj/item/path_spellbook/taking_of_spirit/level3,
			/obj/item/path_spellbook/taking_of_spirit/level4,
			/obj/item/path_spellbook/taking_of_spirit/level5))

		if(artifact.research_value >= 20)
			to_chat(user, span_nicegreen("炼狱诸魔贪婪地吞下这件强大的遗物，将其纳入收藏，并赐予你[artifact.research_value]点恩宠！"))
		else if(artifact.research_value >= 10)
			to_chat(user, span_notice("炼狱诸魔吸收了遗物的精华，保存其中的知识，并赐予你[artifact.research_value]点恩宠。"))
		else
			to_chat(user, span_notice("炼狱诸魔勉强收下这件不起眼的遗物，将其收存，并赐予你[artifact.research_value]点恩宠。"))

		qdel(artifact)
		return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/path_spellbook))
		var/obj/item/path_spellbook/spellbook = tool

		if(!ishuman(user))
			return ITEM_INTERACT_BLOCKING

		var/mob/living/carbon/human/human_user = user

		var/research_reward = 50
		human_user.infernal_favor += research_reward

		increment_stock(spellbook.type)

		to_chat(user, span_notice("炼狱诸魔收下了你的法术书，将其中的知识纳入收藏，并赐予你[research_reward]点恩宠。"))

		qdel(spellbook)
		return ITEM_INTERACT_SUCCESS

#undef FAVOR_MULTIPLIER
