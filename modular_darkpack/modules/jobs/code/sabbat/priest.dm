/datum/job/vampire/sabbatpriest
	title = JOB_SABBAT_PRIEST
	faction = FACTION_SABBAT
	total_positions = 2
	spawn_positions = 2
	supervisors = "该隐"
	config_tag = "SABBAT_PRIEST"
	outfit = /datum/outfit/job/vampire/sabbatpriest
	allowed_splats = list(SPLAT_KINDRED)
	job_flags = CITY_JOB_FLAGS

	departments_list = list(
		/datum/job_department/sabbat,
	)

	tgui_icon = FA_ICON_CROSS

	description = "你是魔宴祭司，负责主持战团的各类仪式，也是战团首领的副手。为新成员主持共血仪式，查阅典籍，用仪式帮助战团，确保魔宴同盟在该隐的眷顾下延续。【注意】选择此角色即表示你已阅读并同意服务器关于对抗角色冲突升级的规则。务必让双方都能参与其中、享受互动。仅因自己有能力就随意杀害其他玩家角色，可能导致你被禁止选择此类角色。"
	minimum_masquerade = 0
	display_order = JOB_DISPLAY_ORDER_SABBATPRIEST
	whitelisted = TRUE

	known_contacts = list(
		JOB_SABBAT_DUCTUS,
		JOB_SABBAT_PACK
	)

/datum/outfit/job/vampire/sabbatpriest
	name = JOB_SABBAT_PRIEST
	jobtype = /datum/job/vampire/sabbatpriest
	l_pocket = /obj/item/smartphone/sabbat_priest
	r_pocket = /obj/item/vamp/keys/sabbat
	suit = /obj/item/clothing/suit/vampire/noddist
	head = /obj/item/clothing/head/vampire/noddist_mask
	uses_default_clan_clothes = TRUE
	backpack_contents = list(/obj/item/card/credit=1)

/datum/outfit/job/vampire/sabbatpriest/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.mind.add_antag_datum(/datum/antagonist/sabbatist/priest)

/datum/antagonist/sabbatist/priest
	antag_hud_name = "priest"

/obj/item/sabbat_priest_tome
	name = "魔宴祭司典籍"
	desc = "一本饰有魔宴同盟标志的典籍。"
	icon = 'modular_darkpack/modules/jobs/icons/sabbat.dmi'
	icon_state = "sabbat-tome"

/datum/sabbat_ritae/ritae_description
	var/name = "仪式说明"
	var/desc = "仪式说明"

/datum/sabbat_ritae/ritae_description/pack_credo
	name = "战团信条"
	desc = "我们是该隐之剑。我们不向避世戒律屈膝。我们不是长老的奴隶，也不是上古者的工具。历经血与火，我们为末日审判做好准备。我们凭借力量行动，不靠藏头露尾；我们团结一心，同属一个战团。叛徒必死，暴君必亡。此乃该隐的意志。\n"

/datum/sabbat_ritae/ritae_description/vaulderie_info
	name = "共血仪式"
	desc = "共血仪式在战团成员之间建立共血纽带，使参与者形成程度较浅的共同血缚。它会切断原有血缚，提醒所有该隐后裔摆脱那些篡夺该隐权柄的长老。使用共血仪式高脚杯或银制高脚杯举行仪式。每名成员都必须将自己的血粹滴入杯中，再由全体参与者共饮。\n"

/datum/sabbat_ritae/ritae_description/shovelhead_info
	name = "新生仪式"
	desc = "我们常因新生仪式遭受诋毁。该隐后裔须在巢穴中直穿篝火，战胜对火焰与死亡的恐惧，才得以成为真正的魔宴成员。但在危急关头，尤其是需要大规模初拥时，我们可能采用“铲头法”：初拥新的该隐后裔，将其埋入浅坟，唤醒他们的狂乱、心兽与真正本性……\n"

/datum/sabbat_ritae/ritae_description/monomacy_info
	name = "决斗仪式"
	desc = "当两名魔宴同盟的该隐后裔无法和平、理性地解决争端时，可通过决斗仪式一决高下。挑战者使用巢穴中的决斗法阵符文发出挑战，被挑战者可以接受或拒绝。祭司必须裁定争端是否值得以决斗解决。被挑战者有权决定决斗条件，例如武器、是否允许使用律能、以长眠还是终亡为终点，以及决斗地点等。祭司始终对仪式与战团拥有最终权威，可以宣布某场决斗无效。\n"

/datum/sabbat_ritae/ritae_description/bloodbath_info
	name = "血浴"
	desc = "血浴是祭司选立新任战团首领的仪式，通常在前任首领遭到决斗挑战后举行。每位愿意效忠新首领的魔宴成员都要走到浴缸前，用仪式刀献出大量血粹。新首领随后浸入拥护自己的战团成员所献之血，祭司则对浴缸使用典籍。待首领离开浴缸，祭司须用共血仪式高脚杯舀取血液，供所有人共饮，为新战团的共血纽带赋予神圣意义。\n"

/datum/sabbat_ritae/ritae_description/war_party_hunt_info
	name = "战团出征"
	desc = "使用该隐后裔长老头骨制成的出征图腾，即可发起战团出征仪式。它的黑暗力量会召回城中所有参加过共血仪式的人，让大家返回巢穴商议出征计划，打击异端、冒牌者，以及躲在避世戒律背后的懦夫。长老背叛了该隐，而我们就是他复仇意志的化身。\n"

/datum/sabbat_ritae/ritae_description/blood_feast_info
	name = "血宴"
	desc = "血宴是战团的庆典仪式，通常在正式集会时举行。每位该隐后裔都要外出参加狩猎竞赛，祭司可以自行决定是否参与。谁要是带回一个血如泥土般难喝的肮脏乞丐，可就有苦头吃了。仪式要比一比，谁能为整个战团献上最上等的佳肴：爱管闲事的警察、离经叛道的魔宴成员，或值得施以血噬的异端血族。战团将展现力量，今夜我们皆可饱餐。\n"

/datum/sabbat_ritae/ritae_description/wild_hunt_info
	name = "狂猎"
	desc = "无人可以违抗该隐，尤其是参加过共血仪式的人！背叛该隐与魔宴同盟的叛徒和逃亡者，以及知晓其叛行的人，都将遭到正义战团的讨伐。他们可能受到血噬、肢体摧残，或在腐朽心脏仍插着木桩时被投入仪式之火，直至被处以死刑。无人可以违抗该隐，也无人能逃脱他的复仇，密党的长老与战团的叛徒皆不例外。\n "

/obj/item/sabbat_priest_tome/attack_self(mob/living/carbon/human/user)
	. = ..()
	if(!user.mind || !is_sabbatist(user.mind.assigned_role))
		to_chat(user, "触碰这本典籍时，你没有感到任何异样。")
		return

	var/is_priest = is_sabbat_priest(user.mind.assigned_role)

	var/original_icon_state = icon_state
	icon_state = "[original_icon_state]-open"
	addtimer(CALLBACK(src, PROC_REF(close_book)), 10 SECONDS)

	to_chat(user, "这些是该隐赐予你们的权威仪式。")

	// Define all ritae datums
	var/list/ritae_datums = list(
		"战团信条" = new /datum/sabbat_ritae/ritae_description/pack_credo(),
		"共血仪式" = new /datum/sabbat_ritae/ritae_description/vaulderie_info(),
		"铲头法" = new /datum/sabbat_ritae/ritae_description/shovelhead_info(),
		"决斗仪式" = new /datum/sabbat_ritae/ritae_description/monomacy_info(),
		"血浴" = new /datum/sabbat_ritae/ritae_description/bloodbath_info(),
		"战团出征" = new /datum/sabbat_ritae/ritae_description/war_party_hunt_info(),
		"血宴" = new /datum/sabbat_ritae/ritae_description/blood_feast_info(),
		"狂猎" = new /datum/sabbat_ritae/ritae_description/wild_hunt_info()
	)

	var/list/ritae_options = list()

	// Everyone can see "Pack Credo"
	if(is_priest)
		ritae_options += "战团信条（编辑）"
	else
		ritae_options += "战团信条"

	// Only Priests can see other ritae
	if(is_priest)
		for(var/name in ritae_datums)
			if(name != "战团信条")
				ritae_options += name

	var/choice = tgui_input_list(user, "选择要了解的仪式：", "魔宴仪式", ritae_options)
	if(!choice)
		return

	if(choice == "战团信条（编辑）")
		var/datum/sabbat_ritae/ritae_description/pack_credo/credo = ritae_datums["战团信条"]
		to_chat(user, span_cult("<b>战团信条：</b>"))
		to_chat(user, span_cult("[credo.desc]"))

		var/new_credo = tgui_input_text(user, "输入你对魔宴同盟目标的理解：", "编辑战团信条", credo.desc)
		if(new_credo && new_credo != credo.desc)
			credo.desc = new_credo
			to_chat(user, span_cult("你更新了战团对魔宴信条的诠释。"))
		return

	var/datum/sabbat_ritae/ritae_description/ritus = ritae_datums[choice]
	if(ritus)
		to_chat(user, span_cult("<b>[ritus.name]:</b>"))
		to_chat(user, span_cult("[ritus.desc]"))

/obj/item/sabbat_priest_tome/proc/close_book()
	icon_state = initial(icon_state)
