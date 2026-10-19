//HATS

//HATS

//HATS

/obj/item/clothing/head/vampire
	icon = 'modular_darkpack/modules/clothes/icons/clothing.dmi'
	worn_icon = 'modular_darkpack/modules/clothes/icons/worn.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/clothes/icons/clothing_onfloor.dmi')
	armor_type = /datum/armor/vampire_hat

/datum/armor/vampire_hat
	melee = 10
	laser = 10
	energy = 10
	bomb = 10
	acid = 10
	wound = 10

/obj/item/clothing/head/vampire/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling, 5, "headwear", FALSE)

/obj/item/clothing/head/vampire/malkav
	name = "怪人帽"
	desc = "无论身处何种场合，都能显得危险或性感。提供一定防护。"
	icon_state = "malkav_hat"
	armor_type = /datum/armor/malkavian_hat

/datum/armor/malkavian_hat
	melee = 25
	bullet = 25
	laser = 10
	energy = 10
	bomb = 10
	acid = 10
	wound = 10

/obj/item/clothing/head/vampire/bandana
	name = "棕色头巾"
	desc = "一条时髦的头巾。"
	icon_state = "bandana"

/obj/item/clothing/head/vampire/bandana/red
	name = "红色头巾"
	icon_state = "bandana_red"

/obj/item/clothing/head/vampire/bandana/black
	name = "黑色头巾"
	icon_state = "bandana_black"

/obj/item/clothing/head/vampire/baseballcap
	name = "棒球帽"
	desc = "一顶圆顶软帽，前方伸出硬质帽檐。巨人队的棒球，精彩无可比拟！"
	icon_state = "baseballcap"

/obj/item/clothing/head/vampire/ushanka
	name = "俄式护耳帽"
	desc = "一顶厚实的毛皮帽，两侧有遮住耳朵的护耳。"
	icon_state = "ushanka"

/obj/item/clothing/head/vampire/beanie
	name = "针织帽"
	desc = "一顶时髦的针织帽。"
	icon_state = "hat"

/obj/item/clothing/head/vampire/beanie/black
	name = "黑色针织帽"
	icon_state = "hat_black"

/obj/item/clothing/head/vampire/beanie/homeless
	name = "破旧针织帽"
	icon_state = "hat_homeless"

/obj/item/clothing/head/vampire/wizard/blue
	name = "蓝色巫师帽"
	desc = "一顶泛着水色的巫师帽。"
	icon_state = "wizardhat_blue"

/obj/item/clothing/head/vampire/wizard/black
	name = "黑色巫师帽"
	desc = "一顶透着邪气的巫师帽。"
	icon_state = "wizardhat_black"

/obj/item/clothing/head/vampire/wizard/darkred
	name = "暗红色巫师帽"
	desc = "一顶透着狂热气息的巫师帽。"
	icon_state = "wizardhat_darkred"

/obj/item/clothing/head/vampire/wizard/green
	name = "绿色巫师帽"
	desc = "一顶透着大地气息的巫师帽。"
	icon_state = "wizardhat_green"

/obj/item/clothing/head/vampire/wizard/grey
	name = "灰色巫师帽"
	desc = "一顶显得沉郁的巫师帽。"
	icon_state = "wizardhat_grey"

/obj/item/clothing/head/vampire/wizard/purple
	name = "紫色巫师帽"
	desc = "一顶优雅的巫师帽。"
	icon_state = "wizardhat_purple"

/obj/item/clothing/head/vampire/wizard/red
	name = "红色巫师帽"
	desc = "一顶透着怒意的巫师帽。"
	icon_state = "wizardhat_red"

/obj/item/clothing/head/vampire/wizard/white
	name = "白色巫师帽"
	desc = "一顶如天使般圣洁的巫师帽。"
	icon_state = "wizardhat_white"

/obj/item/clothing/head/vampire/wizard/yellow
	name = "黄色巫师帽"
	desc = "一顶洋溢着欢快气息的巫师帽。"
	icon_state = "wizardhat_yellow"

/obj/item/clothing/head/vampire/police
	name = "警帽"
	desc = "无论身处何种场合，都能显得危险或性感。提供一定防护。"
	icon_state = "law"
	armor_type = /datum/armor/armored_hat
	custom_price = 20

/datum/armor/armored_hat
	melee = 20
	bullet = 20
	laser = 10
	energy = 10
	bomb = 10
	acid = 10
	wound = 10

/obj/item/clothing/head/vampire/cowboy
	name = "牛仔帽"
	desc = "怎么看都很酷。提供一定防护。"
	icon_state = "cowboy"
	armor_type = /datum/armor/armored_hat

/obj/item/clothing/head/vampire/cowboy/armorless
	name = "牛仔帽"
	desc = "咿——我可不常这么喊——哈！"
	armor_type = /datum/armor/none

/obj/item/clothing/head/vampire/british
	name = "英式警帽"
	desc = "来杯茶吗？提供一定防护。"
	icon_state = "briish"
	armor_type = /datum/armor/armored_hat

/obj/item/clothing/head/vampire/napoleon
	name = "法国海军上将帽"
	desc = "思绪纷飞，我迷失在你的双眸中……沉溺于你含情目光的波浪里……"
	icon_state = "french"
	armor_type = /datum/armor/none

/obj/item/clothing/head/vampire/top
	name = "高顶礼帽"
	desc = "来杯茶吗？提供一定防护。"
	icon_state = "top"
	armor_type = /datum/armor/none

/obj/item/clothing/head/vampire/skull
	name = "骷髅头盔"
	desc = "见鬼……提供一定防护。"
	icon_state = "skull"
	armor_type = /datum/armor/armored_hat

/obj/item/clothing/head/vampire/helmet
	name = "警用头盔"
	desc = "看起来很危险。提供良好的防护。"
	icon_state = "helmet"
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEHAIR
	armor_type = /datum/armor/police_helmet
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	masquerade_violating = TRUE
	custom_price = 50

/datum/armor/police_helmet
	melee = 40
	bullet = 40
	laser = 40
	energy = 40
	bomb = 20
	fire = 20
	acid = 40
	wound = 25

/obj/item/clothing/head/vampire/helmet/egorium
	name = "奇异面具"
	desc = "看起来很神秘。提供良好的防护。"
	icon_state = "masque"
	flags_inv = HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	visor_flags_inv = HIDEFACE|HIDEFACIALHAIR|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	visor_flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	masquerade_violating = FALSE

/obj/item/clothing/head/vampire/helmet/spain
	name = "西班牙头盔"
	desc = "征服者！提供良好的防护。"
	icon_state = "spain"
	flags_inv = HIDEEARS
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	masquerade_violating = FALSE

/obj/item/clothing/head/vampire/army
	name = "军用头盔"
	desc = "看起来很危险。对钝击提供出色的防护。"
	icon_state = "viet"
	flags_inv = HIDEEARS|HIDEHAIR
	armor_type = /datum/armor/army_helmet
	masquerade_violating = TRUE

/datum/armor/army_helmet
	melee = 60
	bullet = 60
	laser = 60
	energy = 60
	bomb = 40
	fire = 20
	acid = 40
	wound = 25

/obj/item/clothing/head/vampire/hardhat
	name = "施工安全帽"
	desc = "一顶用于保护头部免受伤害的热塑性塑料硬帽。"
	icon_state = "hardhat"
	armor_type = /datum/armor/construction_helmet
	hair_mask = /datum/hair_mask/standard_hat_middle
	custom_price = 50

/datum/armor/construction_helmet
	melee = 20
	bullet = 5
	bomb = 10
	fire = 5
	wound = 15

/obj/item/clothing/head/vampire/eod
	name = "排爆头盔"
	desc = "看起来很危险。对几乎所有威胁都能提供顶级防护。"
	icon_state = "bomb"
	armor_type = /datum/armor/eod_helmet
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEHAIR
	visor_flags_inv = HIDEFACE|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	visor_flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	w_class = WEIGHT_CLASS_BULKY
	masquerade_violating = TRUE

/datum/armor/eod_helmet
	melee = 70
	bullet = 70
	laser = 90
	energy = 90
	bomb = 100
	fire = 50
	acid = 90
	wound = 40

/obj/item/clothing/head/vampire/bogatyr
	name = "骨盔"
	desc = "由不明材料制成的威严头盔。"
	icon_state = "bogatyr_helmet_light"
	armor_type = /datum/armor/police_helmet
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEHAIR
	visor_flags_inv = HIDEFACE|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	visor_flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/clothing/head/vampire/bogatyr/captain
	name = "金色骨盔"
	icon_state = "bogatyr_captain_helmet"
	armor_type = /datum/armor/bogatyr_helmet

/obj/item/clothing/head/vampire/bogatyr/captain/heavy // ! Craftable only.
	name = "强化金色骨盔"
	armor_type = /datum/armor/eod_helmet
	w_class = WEIGHT_CLASS_BULKY

/obj/item/clothing/head/vampire/bogatyr/heavy
	name = "重型骨盔"
	icon_state = "bogatyr_helmet"
	armor_type = /datum/armor/eod_helmet
	w_class = WEIGHT_CLASS_BULKY

/datum/armor/bogatyr_helmet
	melee = 55
	bullet = 50
	laser = 60
	energy = 60
	bomb = 20
	fire = 40
	acid = 70
	wound = 30

/obj/item/clothing/head/vampire/bahari_mask
	name = "黑暗之母面具"
	desc = "当我初次品尝那两棵树的果实，\
			感受生命与知识的种子在体内燃烧时，\
			我便在那天立誓，绝不回头……"
	icon_state = "bahari_mask"
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR

/obj/item/clothing/head/vampire/straw_hat
	name = "草帽"
	desc = "一顶草帽。"
	icon_state = "strawhat"

/obj/item/clothing/head/vampire/hijab
	name = "希贾布头巾"
	desc = "穆斯林女性佩戴的传统头巾。"
	icon_state = "hijab"
	flags_inv = HIDEEARS|HIDEHAIR

/obj/item/clothing/head/vampire/taqiyah
	name = "穆斯林礼拜帽"
	desc = "穆斯林男性佩戴的传统帽子。"
	icon_state = "taqiyah"

/obj/item/clothing/head/vampire/noddist_mask
	name = "挪得信徒面具"
	desc = "太阳闪耀黑光！月亮映照血色！末日审判即将到来。"
	icon_state = "noddist_mask"

/obj/item/clothing/head/vampire/kalimavkion
	name = "东正教教士帽"
	desc = "东正教教士佩戴的传统帽子。"
	icon_state = "kalimavkion"

/obj/item/clothing/head/vampire/prayer_veil
	name = "祈祷面纱"
	desc = "一条传统面纱。"
	icon_state = "prayer_veil"
	flags_inv = HIDEEARS|HIDEHAIR

/obj/item/clothing/head/vampire/hardhat/pentex_yellow
	name = "\improper " + MAIN_EVIL_COMPANY_DISPLAY_NAME + "安全帽"
	desc = "一顶黄色安全帽，上面印有" + MAIN_EVIL_COMPANY_DISPLAY_NAME + "的标志！"
	icon_state = "pentex_hardhat_yellow"

/obj/item/clothing/head/vampire/hardhat/pentex_white
	name = "\improper " + MAIN_EVIL_COMPANY_DISPLAY_NAME + "安全帽"
	desc = "一顶白色安全帽，上面印有" + MAIN_EVIL_COMPANY_DISPLAY_NAME + "的标志！"
	icon_state = "pentex_hardhat_white"

/obj/item/clothing/head/vampire/pentex_beret
	name = "第一小队贝雷帽"
	desc = "一顶黑色贝雷帽，带有一枚神秘的金色螺旋徽章。"
	icon_state = "pentex_beret"
	armor_type = /datum/armor/armored_hat
	hair_mask = /datum/hair_mask/standard_hat_middle

/obj/item/clothing/head/vampire/blackbag
	name = "黑色头袋"
	desc = "绑匪、虐待狂和那些名字只有三个字母的机构都爱用。可以轻松套住头部，遮挡视线。"
	icon_state = "black_bag"
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR

	flash_protect = FLASH_PROTECTION_WELDER
	tint = 3

/obj/item/clothing/head/vampire/blackbag/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot == ITEM_SLOT_HEAD)
		user.become_blind("blindfold_[REF(src)]")

/obj/item/clothing/head/vampire/blackbag/dropped(mob/living/carbon/human/user)
	. = ..()
	user.cure_blind("blindfold_[REF(src)]")

/obj/item/clothing/head/vampire/blackbag/attack(mob/living/target, mob/living/user)
	. = ..()
	var/obj/item/clothing/head/H = target.get_item_by_slot(ITEM_SLOT_HEAD)
	if(H?.clothing_flags & SNUG_FIT)
		to_chat(user, span_warning("对方的头饰挡住了黑色头袋，套不上去！"))
		return
	if(do_after(user, 0.5 SECONDS, target)) //Mainly to prevent black_bagging mid combat.
		target.visible_message(span_warning("[user]把[src]强行套到了[target]头上！"))
		to_chat(target, span_bolddanger("[src]被强行套到了你的头上！"))
		target.emote("scream")
		target.Stun(0.5 SECONDS)

		H = target.get_item_by_slot(ITEM_SLOT_HEAD) // Refetch it if it changes between do_after
		target.dropItemToGround(H)
		target.equip_to_slot_if_possible(src, ITEM_SLOT_HEAD)

/obj/item/clothing/head/beret/black
	name = "黑色贝雷帽"
	desc = "一顶黑色贝雷帽，特别适合老兵，以及阴郁深沉、走反英雄路线的默剧演员。"
	greyscale_colors = "#3f3c40"
