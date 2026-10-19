/obj/item/occult_artifact/pickup(mob/user)
	. = ..()
	if(identified)
		bind(user)

/obj/item/occult_artifact/dropped(mob/user, silent = FALSE)
	. = ..()
	if(identified)
		if(isturf(loc))
			unbind(user)


/obj/item/occult_artifact/process(seconds_per_tick)
	if(owner && !in_contents_of(owner))
		unbind(owner)

/obj/item/occult_artifact
	name = "未鉴定的神秘灵器"
	desc = "谁知道其中藏着怎样的秘密……"
	icon_state = "arcane"
	icon = 'modular_darkpack/modules/occult_artifacts/icons/artifacts.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/occult_artifacts/icons/artifacts_onfloor.dmi')
	abstract_type = /obj/item/occult_artifact
	w_class = WEIGHT_CLASS_SMALL
	var/mob/living/owner
	/// Name set upon identifying the artifact
	var/true_name
	/// Desc set upon identifying the artifact
	var/true_desc
	var/identified = FALSE
	/// How many points this grants when fed into the treme artifact muncher
	var/research_value = 0
	/// "Rank" of artifact as used in the TTRPG.
	var/rank = 1
	var/can_be_identified_without_ritual = TRUE

	var/magic_type

	var/grant_sound // = 'sound/effects/magic/swap.ogg'
	var/ungrant_sound // = 'sound/effects/magic/teleport_diss.ogg'

	var/datum/controller/subsystem/processing/subsystem_type = /datum/controller/subsystem/processing/obj

	var/datum/storyteller_roll/identify_occult/identify_roll

/obj/item/occult_artifact/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling, 200, "artifact", FALSE, 0, 10, TRUE)

/obj/item/occult_artifact/proc/identify(mob/living/artifact_identifier)
	if(!identified)
		if(true_name)
			name = true_name
		if(true_desc)
			desc = true_desc
		identified = TRUE
		if(src in artifact_identifier?.get_all_contents())
			bind(artifact_identifier)

/obj/item/occult_artifact/proc/can_be_used_by(mob/living/user)
	return TRUE

/obj/item/occult_artifact/proc/bind(mob/user)
	if(!identified)
		return
	if(owner) // Dont bind twice
		return
	if(!can_be_used_by(user))
		return
	if(!CONFIG_GET(flag/artifact_stacking))
		var/list/artifacts = user.get_all_contents_type(type)
		for(var/obj/item/occult_artifact/other_artifact in artifacts)
			if(other_artifact.owner == user) // We already have a trinket bound. Please dont stack.
				to_chat(user, span_danger("你已持有同类遗物，相同的共鸣使这件多余的遗物失去了效力。"))
				return
	owner = user

	var/datum/controller/subsystem/processing/subsystem = locate(subsystem_type) in Master.subsystems
	START_PROCESSING(subsystem, src)

	grant_powers()

/obj/item/occult_artifact/proc/unbind(mob/user)
	if(src in owner?.get_all_contents()) // dont unbind if the user has just placed the artifact in their bag - which counts as dropping it
		return
	var/datum/controller/subsystem/processing/subsystem = locate(subsystem_type) in Master.subsystems
	STOP_PROCESSING(subsystem, src)

	if(owner)
		ungrant_powers()
		owner = null

/obj/item/occult_artifact/proc/grant_powers()
	SHOULD_CALL_PARENT(TRUE)

	if(grant_sound)
		playsound(owner, grant_sound, 5)
	return

/obj/item/occult_artifact/proc/ungrant_powers()
	SHOULD_CALL_PARENT(TRUE)

	if(ungrant_sound)
		playsound(owner, ungrant_sound, 5)
	return


/obj/item/occult_artifact/attack_self(mob/user, modifiers)
	. = ..()
	if(!isliving(user))
		return

	if(identified)
		to_chat(user, span_notice("这件遗物已经鉴定过了。"))
		return

	var/mob/living/artifact_identifier = user
	if(artifact_identifier.st_get_stat(STAT_OCCULT) < 3)
		to_chat(artifact_identifier, span_warning("这是什么东西？从旧货摊上淘来的玩意儿？"))
		return

	if(!can_be_identified_without_ritual)
		to_chat(artifact_identifier, span_warning("你见过一些神秘遗物、饰品和强大的古物，但眼前这件，要么是你从未见过的东西，要么只有极少数人才能唤醒其中的力量……"))
		return

	if(!can_be_used_by(artifact_identifier))
		to_chat(artifact_identifier, span_warning("这件物品中寄宿的存在拒绝与你合作。"))
		return

	to_chat(artifact_identifier, span_cult("你或许曾在某本神秘学典籍中见过它。你开始进行鉴定……"))
	if(!do_after(artifact_identifier, 1 TURNS, src))
		return

	if(!identify_roll)
		identify_roll = new()
	var/roll = identify_roll.st_roll(user, src)
	if(roll == ROLL_SUCCESS)
		identify(artifact_identifier)
		to_chat(artifact_identifier, span_cult("你成功鉴定了[src]！"))
	else
		to_chat(artifact_identifier, span_warning("你停止了对[src]的研究。"))


/obj/effect/spawner/random/occult
	name = "occult spawner"
	icon = 'modular_darkpack/modules/occult_artifacts/icons/artifacts.dmi'
	icon_state = "art_rand"


/obj/effect/spawner/random/occult/artifact
	name = "random occult artifact"
	loot = list(
		/obj/effect/spawner/random/occult/artifact/vampire_only = 55,
		/obj/effect/spawner/random/occult/artifact/werewolf_only = 45,
	)

/obj/effect/spawner/random/occult/artifact/Initialize(mapload)
	if(isnull(spawn_loot_chance))
		spawn_loot_chance = CONFIG_GET(number/artifact_random_probability)
	. = ..()


/obj/effect/spawner/random/occult/artifact/vampire_only
	name = "random vampire artifact"
	loot = null
	loot_subtype_path = /obj/item/occult_artifact/vampire


/obj/effect/spawner/random/occult/artifact/werewolf_only
	name = "random garou fetish"
	loot = list(
		/obj/item/occult_artifact/werewolf/nyxs_bangle = 33,
		/obj/item/occult_artifact/werewolf/dagger_of_retribution = 30,//Crimson edit reduced by 3 when inqusitor relic is removed increase back to 3
		/obj/item/occult_artifact/holy/inquisitors_relic = 3, // Crimson Edit added new artifact to werewolf spawn temporarily until other artifacts are made to make own spawner
		/obj/item/occult_artifact/werewolf/magpies_ears = 33,
		/obj/effect/spawner/random/occult/artifact/klaive = 1,
	)

/obj/effect/spawner/random/occult/artifact/klaive
	name = "random klaive"
	loot = list(
		/obj/item/occult_artifact/werewolf/klaive = 33,
		/obj/item/occult_artifact/werewolf/klaive/bane = 33,
		/obj/item/occult_artifact/werewolf/klaive/karambit = 33,
	)
// I've elected to remove grand klaives in favor of making them something you have to kill a real boss for.

