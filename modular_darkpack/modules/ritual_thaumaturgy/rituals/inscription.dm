// from clanbook tremere revised page 58

/obj/ritual_rune/thaumaturgy/inscription
	name = "仪式铭刻"
	desc = "制作以血粹书写的卷轴，让技艺不精的血魔法师或不懂血魔法的人也能施行一级或二级仪式。"
	icon_state = "rune5"
	word = ""
	level = 2
	sacrifices = list(/obj/item/paper)
	var/ritual_selected

/obj/ritual_rune/thaumaturgy/inscription/attack_hand(mob/living/user)
	var/datum/action/ritual_drawing/ritual_action = locate() in user.actions
	if(!ritual_action)
		return

	var/list/ritual_selection = ritual_action.get_available_runes()

	// gonna inscription the inscription ritual
	ritual_selection -= "仪式铭刻"

	for(var/ritual_name in ritual_selection)
		var/ritual_level = ritual_selection[ritual_name]["level"]
		if(ritual_level > 2)
			ritual_selection -= ritual_name

	var/selection = tgui_input_list(user, "你想将哪个仪式铭刻在卷轴上？", "仪式铭刻", ritual_selection)
	if(!selection)
		to_chat(user, span_cult("你决定不在羊皮纸上铭刻仪式。"))
		return FALSE

	ritual_selected = ritual_selection[selection]["path"]
	. = ..()

/obj/ritual_rune/thaumaturgy/inscription/complete()
	. = ..()

	if(!ritual_selected)
		to_chat(last_activator, span_cult("你还没有选择要铭刻的仪式。"))
		return

	var/obj/item/thaumaturgy_scroll/ritual_scroll = new(loc)
	ritual_scroll.name = "血魔法卷轴（[initial(ritual_selected:name)]）"
	ritual_scroll.desc = "一张以血粹书写的卷轴，持有者无需掌握血魔法即可施行“[initial(ritual_selected:name)]”仪式。仪式说明：[initial(ritual_selected:desc)]"
	ritual_scroll.ritual = ritual_selected

	to_chat(last_activator, span_cult("你以血魔法将自身血粹铭刻在纸上，让技艺不精的血魔法师，甚至完全不懂血魔法的人，都能使用卷轴施行其中的仪式。"))
	qdel(src)

/obj/item/thaumaturgy_scroll
	name = "血魔法卷轴"
	desc = "一张让不懂血魔法的人也能施行血魔法仪式的卷轴。"
	icon = 'modular_darkpack/modules/ritual_thaumaturgy/icons/ritual_scroll.dmi'
	icon_state = "scroll"
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/ritual_thaumaturgy/icons/onfloor.dmi')
	var/ritual

/obj/item/thaumaturgy_scroll/attack_self(mob/living/user)
	. = ..()
	if(!ritual)
		to_chat(user, span_cult("卷轴一片空白，没有可以施行的仪式。"))
		return

	to_chat(user, span_cult("你展开卷轴，依照指示施行“[initial(ritual:name)]”仪式。"))

	var/obj/ritual_rune/R = new ritual(user.loc)
	R.required_discipline = null // no discipline required to use the ritual
	R.attack_hand(user)

	qdel(src)
