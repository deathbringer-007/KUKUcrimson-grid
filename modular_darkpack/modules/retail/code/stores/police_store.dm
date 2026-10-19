/obj/structure/retail/police_equipment
	product_types = list(
		/obj/item/clothing/under/vampire/police,
		/obj/item/clothing/under/vampire/police/long,
		/obj/item/clothing/under/vampire/police/turtleneck,
		/obj/item/clothing/under/vampire/police/pants,
		/obj/item/clothing/under/vampire/police/utility,
		/obj/item/clothing/gloves/tackler/combat/insulated,
		/obj/item/clothing/head/vampire/police,
		/obj/item/clothing/head/vampire/helmet,
		/obj/item/clothing/suit/vampire/vest/police,
		/obj/item/clothing/suit/vampire/coat/police,
		/obj/item/storage/belt/holster/detective/darkpack,
		/obj/item/storage/belt/security/police,
		/obj/item/camera/detective,
		/obj/item/taperecorder,
		/obj/item/toy/crayon/white,
		/obj/item/storage/box/evidence,
		/obj/item/barrier_tape/police,
		/obj/item/flashlight/seclite,
		/obj/item/detective_scanner/darkpack,
		/obj/item/storage/box/bodybags,
		/obj/item/restraints/handcuffs,
		/obj/item/storage/medkit/darkpack/ifak,
		/obj/item/radio/headset/darkpack/police,
		/obj/item/melee/baton/security/handtaser,
		/obj/item/gun/energy/taser/darkpack,
		/obj/item/reagent_containers/spray/pepper,
		/obj/item/melee/baton/vamp,
		/obj/item/holosign_creator/police_tape,
	)
	products_list = list(
		new /datum/data/vending_product("双筒望远镜", /obj/item/binoculars, 20),
		new /datum/data/vending_product("胡椒喷雾", /obj/item/reagent_containers/spray/pepper, 20),

		//Sidearms
		new /datum/data/vending_product("格洛克19", /obj/item/gun/ballistic/automatic/pistol/darkpack/glock19, 50),
		new /datum/data/vending_product("9毫米格洛克弹匣", /obj/item/ammo_box/magazine/glock9mm, 10),

		//Long guns
		new /datum/data/vending_product("泵动霰弹枪", /obj/item/gun/ballistic/shotgun/vampire, 200),
		new /datum/data/vending_product("MP5", /obj/item/gun/ballistic/automatic/darkpack/mp5, 200),
		new /datum/data/vending_product("MP5弹匣", /obj/item/ammo_box/magazine/darkpack9mp5, 20),
		new /datum/data/vending_product("MP7", /obj/item/gun/ballistic/automatic/darkpack/mp7, 200),
		new /datum/data/vending_product("MP7加长弹匣", /obj/item/ammo_box/magazine/darkpack/c46pdw/ext, 20),
		new /datum/data/vending_product("AR-15", /obj/item/gun/ballistic/automatic/darkpack/ar15, 200),
		new /datum/data/vending_product("5.56弹匣", /obj/item/ammo_box/magazine/darkpack556, 20),
		new /datum/data/vending_product("自动霰弹枪", /obj/item/gun/ballistic/automatic/darkpack/autoshotgun, 200),
		new /datum/data/vending_product("自动霰弹枪弹匣", /obj/item/ammo_box/magazine/darkpackautoshot, 20),
		new /datum/data/vending_product("半自动狙击步枪", /obj/item/gun/ballistic/automatic/darkpack/autosniper, 200),
		new /datum/data/vending_product("PSG1 7.62弹匣", /obj/item/ammo_box/magazine/vamp762x51PSG1, 20),
		new /datum/data/vending_product("狙击步枪", /obj/item/gun/ballistic/automatic/darkpack/sniper, 200),

		//Ammo
		new /datum/data/vending_product(".50口径弹药盒", /obj/item/ammo_box/darkpack/c50, 80),
		new /datum/data/vending_product("7.62x51毫米弹药盒", /obj/item/ammo_box/darkpack/c762x51mm, 80),
		new /datum/data/vending_product("12号弹药盒", /obj/item/ammo_box/darkpack/c12g, 80),
		new /datum/data/vending_product("12号鹿弹盒", /obj/item/ammo_box/darkpack/c12g/buck, 80),
		new /datum/data/vending_product("12号高冲击失能弹盒", /obj/item/ammo_box/darkpack/c12g/incap, 80),
		new /datum/data/vending_product("12号橡胶独头弹盒", /obj/item/ammo_box/darkpack/c12g/rubber, 80),
		new /datum/data/vending_product("9毫米弹药盒", /obj/item/ammo_box/darkpack/c9mm, 80),
		new /datum/data/vending_product("5.56弹药盒", /obj/item/ammo_box/darkpack/c556, 80),
		new /datum/data/vending_product("PDW弹药盒", /obj/item/ammo_box/darkpack/c46pdw, 80),
	)

/obj/structure/retail/police_equipment/can_shop(mob/user)
	var/datum/job/vampire/assigned_role = user.mind?.assigned_role
	if(assigned_role && (/datum/job_department/police in assigned_role.departments_list))
		return TRUE
