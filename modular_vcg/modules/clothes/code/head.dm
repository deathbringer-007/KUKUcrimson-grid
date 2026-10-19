/obj/item/clothing/head/fedora/vampire  // Da High-Rollahs
	name = "灰色软呢礼帽"
	desc = "一顶有派头的帽子，黑帮老手常戴这种。"
	icon = 'modular_vcg/modules/clothes/icons/clothing.dmi'
	worn_icon = 'modular_vcg/modules/clothes/icons/worn.dmi'
	icon_state = "fedora_grey"
	hair_mask = /datum/hair_mask/standard_hat_low
	ONFLOOR_ICON_HELPER('modular_vcg/modules/clothes/icons/clothing_onfloor.dmi')

/obj/item/clothing/head/fedora/vampire/Initialize(mapload)
	. = ..()

/obj/item/clothing/head/fedora/vampire/tan
	name = "棕褐色软呢礼帽"
	icon_state = "fedora_tan"
	inhand_icon_state = null

/obj/item/clothing/head/fedora/vampire/sage
	name = "灰绿色软呢礼帽"
	icon_state = "fedora_sage"
	inhand_icon_state = null

/obj/item/clothing/head/flathat/vampire  //Da GOONS
	name = "灰色鸭舌帽"
	desc = "一顶硬汉们常戴的扁平帽子。"
	icon = 'modular_vcg/modules/clothes/icons/clothing.dmi'
	worn_icon = 'modular_vcg/modules/clothes/icons/worn.dmi'
	icon_state = "flatcap_grey"
	hair_mask = /datum/hair_mask/standard_hat_low
	ONFLOOR_ICON_HELPER('modular_vcg/modules/clothes/icons/clothing_onfloor.dmi')

/obj/item/clothing/head/flathat/vampire/Initialize(mapload)
	. = ..()

/obj/item/clothing/head/flathat/vampire/tan
	name = "棕褐色鸭舌帽"
	icon_state = "flatcap_tan"
	inhand_icon_state = null

/obj/item/clothing/head/flathat/vampire/sage
	name = "灰绿色鸭舌帽"
	icon_state = "flatcap_sage"
	inhand_icon_state = null

/obj/item/clothing/head/baseballcap/vampire  //For yall
	name = "红色棒球帽"
	desc = "一顶普通体育迷常戴的棒球帽。"
	icon = 'modular_vcg/modules/clothes/icons/clothing.dmi'
	worn_icon = 'modular_vcg/modules/clothes/icons/worn.dmi'
	icon_state = "baseball_red"
	ONFLOOR_ICON_HELPER('modular_vcg/modules/clothes/icons/clothing_onfloor.dmi')

/obj/item/clothing/head/baseballcap/vampire/blue
	name = "蓝色棒球帽"
	icon_state = "baseball_blue"
	inhand_icon_state = null

/obj/item/clothing/head/baseballcap/vampire/green
	name = "绿色棒球帽"
	icon_state = "baseball_green"
	inhand_icon_state = null

/// ARMOR

/obj/item/clothing/head/vampire/bikehelmet
	name = "黑色摩托车头盔"
	desc = "一顶黑色头盔……似曾相识？…… "
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEHAIR
	armor_type = /datum/armor/bike_helmet
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	icon = 'modular_vcg/modules/clothes/icons/clothing.dmi'
	worn_icon = 'modular_vcg/modules/clothes/icons/worn.dmi'
	icon_state = "black_bikehelmet"
	ONFLOOR_ICON_HELPER('modular_vcg/modules/clothes/icons/clothing_onfloor.dmi')
	custom_price = 200

/datum/armor/bike_helmet
	melee = 30
	bullet = 20
	laser = 20
	energy = 20
	bomb = 20
	fire = 10
	acid = 30
	wound = 25

/obj/item/clothing/head/vampire/bikehelmet/white
	name = "白色摩托车头盔"
	desc = "一顶白色头盔……似曾相识？…… "
	icon_state = "white_bikehelmet"

/obj/item/clothing/head/vampire/bikehelmet/yellow
	name = "黄色摩托车头盔"
	desc = "一顶黄色头盔……似曾相识？…… "
	icon_state = "yellow_bikehelmet"

/obj/item/clothing/head/vampire/bikehelmet/red
	name = "红色摩托车头盔"
	desc = "一顶红色头盔……似曾相识？…… "
	icon_state = "red_bikehelmet"

/obj/item/clothing/head/vampire/bikehelmet/blue
	name = "蓝色摩托车头盔"
	desc = "一顶蓝色头盔……似曾相识？…… "
	icon_state = "blue_bikehelmet"

/obj/item/clothing/head/vampire/bikehelmet/raceblue
	name = "蓝色赛车头盔"
	desc = "一顶蓝色赛车头盔……似曾相识？…… "
	icon_state = "blue_racehelmet"

/obj/item/clothing/head/vampire/bikehelmet/racewhite
	name = "白色赛车头盔"
	desc = "一顶白色赛车头盔……似曾相识？…… "
	icon_state = "white_racehelmet"
