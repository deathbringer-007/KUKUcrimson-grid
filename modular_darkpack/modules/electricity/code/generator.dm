/obj/warehouse_generator
	name = "发电机"
	desc = "以纯粹的电力为所辖区域供能。"
	icon = 'modular_darkpack/modules/electricity/icons/electricity.dmi'
	icon_state = "gen"
	plane = GAME_PLANE
	layer = CAR_LAYER
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	var/on = TRUE
	var/switching_on = FALSE
	var/last_sound_played = 0
//	var/fuel_remain = 1000
	COOLDOWN_DECLARE(generator_cooldown)

/obj/warehouse_generator/proc/start_on(mob/user)
	switching_on = TRUE
	to_chat(user, span_notice("你重新启动了[src]。"))
	playsound(src.loc, 'sound/items/deconstruct.ogg', 50, TRUE)
	addtimer(CALLBACK(src, PROC_REF(finalize_on)), 5 SECONDS)

/obj/warehouse_generator/proc/finalize_on()
	on = TRUE
	switching_on = FALSE
	icon_state = "gen"
	playsound(src.loc, 'sound/effects/supermatter.ogg', 25, TRUE)
	var/area/A = get_area(src)
	A.requires_power = FALSE
	A.fire_controled = TRUE
	for(var/obj/machinery/light/L in A)
		L.on = TRUE
		L.update(FALSE)

/obj/warehouse_generator/attack_hand(mob/user)
	. = ..()
	if(COOLDOWN_FINISHED(src, generator_cooldown))
		COOLDOWN_START(src, generator_cooldown, 10 SECONDS)
		if(on)
			to_chat(user, span_notice("你关闭了[src]。"))
			generator_shutdown()
		else if(switching_on)
			to_chat(user, span_warning("[src]正在启动！"))
		else if(!on)
			start_on(user)
	else
		to_chat(user, span_warning("稍等片刻才能再次[on ? "关闭" : "启动"][src]。"))

/obj/warehouse_generator/examine(mob/user)
	. = ..()
	. += "[src]目前处于[on ? "开启" : "关闭"]状态。"

/obj/warehouse_generator/proc/generator_shutdown()
	on = FALSE
	icon_state = "gen_off"
	var/area/A = get_area(src)
	for(var/mob/M in A)
		SEND_SOUND(M, 'modular_darkpack/modules/electricity/sounds/generator_shutdown.ogg')
	A.requires_power = TRUE
	A.fire_controled = FALSE
	var/datum/effect_system/basic/spark_spread/s = new(get_turf(src), 5, 1)
	s.start()
	for(var/obj/machinery/light/L in A)
		L.on = FALSE
		L.update(FALSE)
	playsound(loc, 'modular_darkpack/modules/electricity/sounds/generator_break.ogg', 100, TRUE)

/obj/warehouse_generator/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/warehouse_generator/Destroy()
	. = ..()
	STOP_PROCESSING(SSobj, src)

/obj/warehouse_generator/process(seconds_per_tick)
	if(on)
		if(last_sound_played+40 <= world.time)
			last_sound_played = world.time
			playsound(loc, 'modular_darkpack/modules/electricity/sounds/generator_loop.ogg', 25, FALSE)

/obj/warehouse_generator/start_off/Initialize(mapload)
	. = ..()
	generator_shutdown()
