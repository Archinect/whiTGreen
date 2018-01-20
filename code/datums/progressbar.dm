#define PROGRESSBAR_HEIGHT 6

/datum/progressbar
	var/goal = 1
	var/image/bar
	var/shown = 0
	var/mob/user
	var/client/client
	var/listindex

/datum/progressbar/New(mob/User, goal_number, atom/target)
	. = ..()
	/*	if (!istype(target))
		EXCEPTION("Invalid target given")*/
	if (goal_number)
		goal = goal_number
	bar = image('icons/effects/progessbar.dmi', target, "prog_bar_0", 5)
	bar.plane = 5 //HUD_PLANE
//	bar.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
	user = User
	if(user)
		client = user.client
/*	LAZYINITLIST(user.progressbars)
	LAZYINITLIST(user.progressbars[bar.loc])*/
	user.progressbars += src
	listindex = user.progressbars.len
	bar.pixel_y = 32 + (PROGRESSBAR_HEIGHT * (listindex - 1))

/*	world << 1111
	if (client)
		world << 1112
		client.screen |= bar
		world << 1113*/

	user.overlays |= bar

/datum/progressbar/proc/update(progress)
/*	if (!user || !user.client)
		shown = 0
		return
	if (user.client != client)
		if (client)
			client.screen -= bar
		if (user.client)
			user.client.screen |= bar*/
	user.overlays -= bar
	world << 1101
	progress = CLAMP(progress, 0, goal)
	world << 1102
	world << progress
	bar.icon_state = "prog_bar_[round(((progress / goal) * 100), 5)]"
	world << 1103
	if (!shown)
//		user.client.screen += bar
		user.overlays |= bar
		shown = 1

/datum/progressbar/proc/shiftDown()
	--listindex
	bar.pixel_y -= PROGRESSBAR_HEIGHT

/datum/progressbar/Destroy()
	world << 2101
	for(var/I in user.progressbars)
		world << 2111
		var/datum/progressbar/P = I
		if(P != src && P.listindex > listindex)
			P.shiftDown()

	world << 2102
	if(user.progressbars)
		user.progressbars -= src

/*	if (client)
		client.screen -= bar*/

	world << 2103
	user.overlays -= bar

	world << 2104
	qdel(bar)
	. = ..()



#undef PROGRESSBAR_HEIGHT