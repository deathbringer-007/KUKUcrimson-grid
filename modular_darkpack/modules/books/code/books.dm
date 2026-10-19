/obj/item/vampirebook
	name = "书"
	desc = "满载知识。"
	icon_state = "book"
	icon = 'modular_darkpack/modules/books/icons/books.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/books/icons/books_onfloor.dmi')
	w_class = WEIGHT_CLASS_SMALL
	var/quote = "嗯……这本书真无聊。"
	COOLDOWN_DECLARE(read)

/obj/item/vampirebook/proc/read_book(mob/living/carbon/human/user)
	quote = "嗯……这本书真无聊。"

/obj/item/vampirebook/attack_self(mob/living/carbon/human/user)
	. = ..()
	if(!COOLDOWN_FINISHED(src, read))
		return
	read_book(user)
	user.say(quote)
	var/original_icon_state = icon_state
	icon_state = "[original_icon_state]-1"
	COOLDOWN_START(src, read, 10 SECONDS)
	spawn(10 SECONDS)
		icon_state = original_icon_state

/obj/item/vampirebook/lilith
	name = "黑暗之母启示录"
	icon_state = "revelationsofdarkmother"

/obj/item/vampirebook/lilith/read_book(mob/living/carbon/human/user)
	quote = pick(GLOB.bahari_quotes)

/obj/item/vampirebook/noddist
	name = "挪得之书"
	icon_state = "bookofnod"

/obj/item/vampirebook/noddist/read_book(mob/living/carbon/human/user)
	quote = pick(GLOB.noddist_quotes)

/obj/item/vampirebook/quran
	name = "古兰经"
	icon_state = "quran"

/obj/item/vampirebook/quran/read_book(mob/living/carbon/human/user)
	quote = pick(GLOB.quran_quotes)

/obj/item/vampirebook/bible
	name = "圣经"
	icon_state = "bible"

// note to self - fucking move this to the parent type
/obj/item/vampirebook/bible/read_book(mob/living/carbon/human/user)
	. = ..()
	quote = pick(GLOB.bible_quotes)
