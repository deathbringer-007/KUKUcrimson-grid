/obj/item/occult_artifact/holy
	abstract_type = /obj/item/occult_artifact/holy

/obj/item/occult_artifact/holy/identify(mob/living/artifact_identifier)
	if(!artifact_identifier?.mind?.holy_role)
		if(artifact_identifier)
			to_chat(artifact_identifier, span_warning("你无法解读这件圣物。"))
		return
	. = ..()

/obj/item/occult_artifact/holy/attack_self(mob/user, modifiers)
	if(!identified && !user?.mind?.holy_role)
		to_chat(user, span_warning("你无法解读这件圣物。"))
		return
	. = ..()
