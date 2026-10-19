/obj/item/clothing/suit/vampire/toggled
	var/toggle_noun = "zip"

/obj/item/clothing/suit/vampire/toggled/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/toggle_icon, toggle_noun)

/obj/item/clothing/suit/vampire/toggled/bomber_jacket
	name = "飞行夹克"
	desc = "一件飞行夹克。"
	icon = 'modular_vcg/modules/clothes/icons/clothing.dmi'
	worn_icon = 'modular_vcg/modules/clothes/icons/worn.dmi'
	icon_state = "fur1"
	ONFLOOR_ICON_HELPER('modular_vcg/modules/clothes/icons/clothing_onfloor.dmi')

/obj/item/clothing/suit/vampire/toggled/bomber_jacket/inverted
	name = "飞行夹克"
	desc = "一件华丽的飞行夹克。"
	icon_state = "fur2"

/obj/item/clothing/suit/vampire/toggled/plain_jacket
	name = "朴素棕色夹克"
	desc = "一件朴素的棕色夹克。"
	icon = 'modular_vcg/modules/clothes/icons/clothing.dmi'
	worn_icon = 'modular_vcg/modules/clothes/icons/worn.dmi'
	icon_state = "plain1"
	ONFLOOR_ICON_HELPER('modular_vcg/modules/clothes/icons/clothing_onfloor.dmi')

/obj/item/clothing/suit/vampire/toggled/plain_jacket/black
	name = "朴素黑色夹克"
	desc = "一件朴素的黑色夹克。"
	icon_state = "plain2"

/obj/item/clothing/suit/vampire/toggled/military_jacket
	name = "军用夹克"
	desc = "一件军用夹克。"
	icon = 'modular_vcg/modules/clothes/icons/clothing.dmi'
	worn_icon = 'modular_vcg/modules/clothes/icons/worn.dmi'
	icon_state = "m65"
	ONFLOOR_ICON_HELPER('modular_vcg/modules/clothes/icons/clothing_onfloor.dmi')

/obj/item/clothing/suit/vampire/racing_jacket
	name = "黑黄赛车夹克"
	desc = "一件黑黄双色的日式赛车夹克。"
	icon = 'modular_vcg/modules/clothes/icons/clothing.dmi'
	worn_icon = 'modular_vcg/modules/clothes/icons/worn.dmi'
	icon_state = "blackyellow_racejacket"
	ONFLOOR_ICON_HELPER('modular_vcg/modules/clothes/icons/clothing_onfloor.dmi')
	armor_type = /datum/armor/racing_jacket

/datum/armor/racing_jacket
	melee = 30
	bullet = 25
	laser = 5
	energy = 5
	bomb = 35
	fire = 35
	acid = 10
	wound = 35

/obj/item/clothing/suit/vampire/racing_jacket/blackblue
	name = "黑蓝赛车夹克"
	desc = "一件黑蓝双色的日式赛车夹克。"
	icon_state = "blackblue_racejacket"

/obj/item/clothing/suit/vampire/racing_jacket/whitered
	name = "白红赛车夹克"
	desc = "一件白红双色的日式赛车夹克。"
	icon_state = "whitered_racejacket"

/obj/item/clothing/suit/vampire/racing_jacket/whiteyellow
	name = "白黄赛车夹克"
	desc = "一件白黄双色的日式赛车夹克。"
	icon_state = "whiteyellow_racejacket"

/obj/item/clothing/suit/vampire/racing_jacket/bluewhite
	name = "蓝白赛车夹克"
	desc = "一件蓝白双色的日式赛车夹克。"
	icon_state = "bluewhite_racejacket"

/obj/item/clothing/suit/vampire/racing_jacket/redwhite
	name = "红白赛车夹克"
	desc = "一件红白双色的日式赛车夹克。"
	icon_state = "redwhite_racejacket"

// Knight Armor Changes

/obj/item/clothing/suit/armor/riot/knight
	slowdown = 0.5

/obj/item/clothing/suit/armor/riot/knight/yellow
	slowdown = 0.5

/obj/item/clothing/suit/armor/riot/knight/blue
	slowdown = 0.5

/obj/item/clothing/suit/armor/riot/knight/red
	slowdown = 0.5

