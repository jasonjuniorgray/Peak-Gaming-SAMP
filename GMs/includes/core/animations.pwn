#include <YSI\y_hooks>

CMD:toganimhelper(playerid, params[])
{
	if(GetPVarType(playerid, "AnimationHelper"))
	{
		SendClientMessage(playerid, WHITE, "The animation helper has been enabled.");
		DeletePVar(playerid, "AnimationHelper");
	}
	else
	{
		SendClientMessage(playerid, WHITE, "The animation helper has been disabled.");
		SetPVarInt(playerid, "AnimationHelper", 1);
	}
	return 1;
}

CMD:animlist(playerid, params[])
{
	SendClientMessage(playerid, WHITE, "Available Animations:");
	SendClientMessage(playerid, GREY, "/handsup /drunk /bomb /rob /laugh /lookout /robman /crossarms /sit /siteat /hide /vomit /eat");
	SendClientMessage(playerid, WHITE, "/wave /slapass /deal /taichi /crack /smoke /chat /dance /fucku /taichi /drinkwater /pedmove");
	SendClientMessage(playerid, GREY, "/sleep /blob /opendoor /wavedown /reload /cpr /dive /showoff /box /tagwall /goggles /stripclub");
	SendClientMessage(playerid, WHITE, "/cry /dj /cheer /throw /robbed /hurt /nobreath /bar /getjiggy /fallover /rap /piss");
	SendClientMessage(playerid, GREY, "/salute /crabs /washhands /signal /stop /gesture /jerkoff /idles /lowrider /carchat");
	SendClientMessage(playerid, WHITE, "/blowjob /spank /sunbathe /kiss /snatch /sneak /copa /sexy /holdup /misc /bodypush");
	SendClientMessage(playerid, GREY, "/lowbodypush /headbutt /airkick /doorkick /leftslap /elbow /coprun /hitchhike /lean /nope");
	SendClientMessage(playerid, WHITE, "/cashier /write /camera /beckon /carry /cslot /croulette /ccards /pose /swata /argue /fightidle");
	SendClientMessage(playerid, GREY, "/presenta /pool /basketball /middlefinger /getup /phonetalk /crouchreload /lowbodypunch");
	SendClientMessage(playerid, WHITE, "Use /clearanimations to end an animation. Use /toganimationhelper to toggle the animation textdraw.");
	return 1;
}

CMD:clearanimations(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;

	SendClientMessage(playerid, WHITE, "You have cleared your animations.");
	ClearAnimations(playerid);
	SetPlayerSkin(playerid, GetPlayerSkin(playerid));
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);

	if(GetPVarType(playerid, "LoopingAnim")) 
	{
		StopLoopingAnim(playerid);
		TextDrawHideForPlayer(playerid, AnimationHelper);
	}
	return 1;
}

/*CMD:time(playerid, params[])
{
	if(GetPVarInt(playerid, "Injured") != 0 || PlayerCuffed[playerid] != 0 || GetPVarInt(playerid, "pBagged") >= 1 || PlayerInfo[playerid][pHospital] != 0) return SendClientMessage(playerid, GREY, "You can't do that right now.");
	
	new string[128], mtext[20], thour, suffix[3], year, month,day;
    getdate(year, month, day);
    if(month == 1) { mtext = "January"; }
    else if(month == 2) { mtext = "February"; }
    else if(month == 3) { mtext = "March"; }
    else if(month == 4) { mtext = "April"; }
    else if(month == 5) { mtext = "May"; }
    else if(month == 6) { mtext = "June"; }
    else if(month == 7) { mtext = "July"; }
    else if(month == 8) { mtext = "August"; }
    else if(month == 9) { mtext = "September"; }
    else if(month == 10) { mtext = "October"; }
    else if(month == 11) { mtext = "November"; }
    else if(month == 12) { mtext = "December"; }
	if(hour > 12 && hour < 24)
	{
		thour = hour - 12;
		suffix = "PM";
	}
	else if(hour == 12)
	{
		thour = 12;
		suffix = "PM";
	}
	else if(hour > 0 && hour < 12)
	{
		thour = hour;
		suffix = "AM";
	}
	else if(hour == 0)
	{
		thour = 12;
		suffix = "AM";
	}

	if (PlayerInfo[playerid][pJailTime] > 0)
	{
		format(string, sizeof(string), "~y~%s, %s %d, %d~n~~g~|~w~%d:%02d~g~%s|~n~~w~Jail Time Left: ~r~%s", GetWeekday(1), mtext, day, year, thour, minuite, suffix, TimeConvert(PlayerInfo[playerid][pJailTime]));
	}
	else
	{
		format(string, sizeof(string), "~y~%s, %s %d, %d~n~~g~|~w~%d:%02d~g~%s|", GetWeekday(1), mtext, day, year, thour, minuite, suffix);
	}
	if(!IsPlayerInAnyVehicle(playerid))
	{
		ApplyAnimation(playerid,"COP_AMBIENT","Coplook_watch", 4.0, 0, 0, 0, 0, 0, 1);
	}
    GameTextForPlayer(playerid, string, 5000, 1);
    return 1;
}*/

CMD:bodypush(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    ApplyAnimation(playerid,"GANGS","shake_cara",4.0,0,0,0,0,0);
	return 1;
}

CMD:lowbodypush(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    ApplyAnimation(playerid,"GANGS","shake_carSH",4.0,0,0,0,0,0);
	return 1;
}

CMD:headbutt(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    ApplyAnimation(playerid,"WAYFARER","WF_Fwd",4.0,0,0,0,0,0);
	return 1;
}

CMD:airkick(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    ApplyAnimation(playerid,"FIGHT_C","FightC_M",4.0,0,1,1,0,0);
	return 1;
}

CMD:doorkick(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    ApplyAnimation(playerid,"POLICE","Door_Kick",4.0,0,0,0,0,0);
	return 1;
}

CMD:leftslap(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    ApplyAnimation(playerid,"PED","BIKE_elbowL",4.0,0,0,0,0,0);
	return 1;
}

CMD:elbow(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    ApplyAnimation(playerid,"FIGHT_D","FightD_3",4.0,0,1,1,0,0);
	return 1;
}

CMD:coprun(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    ApplyAnimation(playerid,"SWORD","sword_block",50.0,0,1,1,1,1);
	return 1;
}

CMD:handsup(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    SetPlayerSpecialAction(playerid,SPECIAL_ACTION_HANDSUP);
	return 1;
}

CMD:piss(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
   	SetPlayerSpecialAction(playerid, 68);
	return 1;
}

CMD:sneak(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	ApplyAnimationEx(playerid, "PED", "Player_Sneak", 4.1, 1, 1, 1, 1, 1, 1);
	return 1;
}

CMD:drunk(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
   	ApplyAnimationEx(playerid, "PED", "WALK_DRUNK", 4.0, 1, 1, 1, 1, 1, 1);
    return 1;
}

CMD:rob(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	ApplyAnimationEx(playerid, "ped", "ARRESTgun", 4.0, 0, 1, 1, 1, 1, 1);
	return 1;
}

CMD:laugh(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	ApplyAnimationEx(playerid, "RAPPING", "Laugh_01", 4.0, 1, 0, 0, 0, 0, 1);
	return 1;
}

CMD:lookout(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
   	ApplyAnimation(playerid, "SHOP", "ROB_Shifty", 4.0, 0, 0, 0, 0, 0, 1);
    return 1;
}

CMD:hide(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    ApplyAnimationEx(playerid, "ped", "cower", 3.0, 1, 0, 0, 0, 0, 1);
    return 1;
}

CMD:vomit(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    ApplyAnimationEx(playerid, "FOOD", "EAT_Vomit_P", 3.0, 1, 0, 0, 0, 0, 1);
    return 1;
}

CMD:slapass(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    ApplyAnimation(playerid, "SWEET", "sweet_ass_slap", 4.0, 0, 0, 0, 0, 0, 1);
    return 1;
}

CMD:fucku(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    ApplyAnimation(playerid, "PED", "fucku", 4.0, 0, 0, 0, 0, 0, 1);
    return 1;
}

CMD:taichi(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    ApplyAnimationEx(playerid, "PARK", "Tai_Chi_Loop", 4.0, 1, 0, 0, 0, 0, 1);
    return 1;
}

CMD:drinkwater(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    ApplyAnimationEx(playerid, "BAR", "dnk_stndF_loop", 4.0, 1, 0, 0, 0, 0, 1);
    return 1;
}

CMD:checktime(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    ApplyAnimation(playerid, "COP_AMBIENT", "Coplook_watch", 4.0, 0, 0, 0, 0, 0, 1);
    return 1;
}

CMD:sleep(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    ApplyAnimationEx(playerid, "CRACK", "crckdeth4", 4.0, 0, 1, 1, 1, 0, 1);
    return 1;
}

CMD:blob(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    ApplyAnimationEx(playerid, "CRACK", "crckidle1", 4.0, 0, 1, 1, 1, 0, 1);
    return 1;
}

CMD:wavedown(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    ApplyAnimation(playerid, "BD_FIRE", "BD_Panic_01", 4.0, 0, 0, 0, 0, 0, 1);
    return 1;
}

CMD:cpr(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    ApplyAnimation(playerid, "MEDIC", "CPR", 4.0, 0, 0, 0, 0, 0, 1);
    return 1;
}

CMD:showoff(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    ApplyAnimationEx(playerid, "Freeweights", "gym_free_celebrate", 4.0, 1, 0, 0, 0, 0, 1);
    return 1;
}

CMD:goggles(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    ApplyAnimation(playerid, "goggles", "goggles_put_on", 4.0, 0, 0, 0, 0, 0, 1);
    return 1;
}

CMD:cry(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    ApplyAnimationEx(playerid, "GRAVEYARD", "mrnF_loop", 4.0, 1, 0, 0, 0, 0, 1);
    return 1;
}

CMD:throw(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    ApplyAnimation(playerid, "GRENADE", "WEAPON_throw", 4.0, 0, 0, 0, 0, 0, 1);
    return 1;
}

CMD:hurt(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    ApplyAnimationEx(playerid, "SWAT", "gnstwall_injurd", 4.0, 1, 0, 0, 0, 0, 1);
    return 1;
}

CMD:box(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    ApplyAnimationEx(playerid, "GYMNASIUM", "GYMshadowbox", 4.0, 1, 0, 0, 0, 0, 1);
    return 1;
}

CMD:washhands(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    ApplyAnimationEx(playerid, "BD_FIRE", "wash_up", 4.0, 1, 0, 0, 0, 0, 1);
    return 1;
}

CMD:crabs(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    ApplyAnimationEx(playerid, "MISC", "Scratchballs_01", 4.0, 1, 0, 0, 0, 0, 1);
    return 1;
}

CMD:salute(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    ApplyAnimationEx(playerid, "ON_LOOKERS", "Pointup_loop", 4.0, 1, 0, 0, 0, 0, 1);
    return 1;
}

CMD:jerkoff(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    ApplyAnimationEx(playerid, "PAULNMAC", "wank_out", 4.0, 1, 0, 0, 0, 0, 1);
    return 1;
}

CMD:stop(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
    ApplyAnimationEx(playerid, "PED", "endchat_01", 4.0, 1, 0, 0, 0, 0, 1);
    return 1;
}

CMD:lowbodypunch(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimationEx(playerid, "FIGHT_B", "FightB_G", 4.0, 1, 0, 0, 0, 0, 1);
		case 2: ApplyAnimationEx(playerid, "KNIFE", "Knife_4", 4.0, 1, 0, 0, 0, 0, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /lowbodypunch [1-2]");
	}
	return 1;
}

CMD:fightidle(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimationEx(playerid, "FIGHT_B", "FightB_IDLE", 4.0, 1, 0, 0, 0, 0, 1);
		case 2: ApplyAnimationEx(playerid, "FIGHT_C", "FightC_IDLE", 4.0, 1, 0, 0, 0, 0, 1);
		case 3: ApplyAnimationEx(playerid, "FIGHT_D", "FightD_IDLE", 4.0, 1, 0, 0, 0, 0, 1);
		case 4: ApplyAnimationEx(playerid, "PED", "FIGHTIDLE", 4.0, 1, 0, 0, 0, 0, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /fightidle [1-4]");
	}
	return 1;
}


CMD:rap(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimationEx(playerid, "RAPPING", "RAP_A_Loop", 4.0, 1, 0, 0, 0, 0, 1);
		case 2: ApplyAnimationEx(playerid, "RAPPING", "RAP_B_Loop", 4.0, 1, 0, 0, 0, 0, 1);
		case 3: ApplyAnimationEx(playerid, "RAPPING", "RAP_C_Loop", 4.0, 1, 0, 0, 0, 0, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /rap [1-3]");
	}
	return 1;
}

CMD:chat(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimationEx(playerid, "PED", "IDLE_CHAT", 4.0, 1, 0, 0, 0, 0, 1);
		case 2: ApplyAnimationEx(playerid, "GANGS", "prtial_gngtlkA", 4.0, 1, 0, 0, 0, 0, 1);
		case 3:	ApplyAnimationEx(playerid, "GANGS", "prtial_gngtlkB", 4.0, 1, 0, 0, 0, 0, 1);
		case 4: ApplyAnimationEx(playerid, "GANGS", "prtial_gngtlkE", 4.0, 1, 0, 0, 0, 0, 1);
		case 5: ApplyAnimationEx(playerid, "GANGS", "prtial_gngtlkF", 4.0, 1, 0, 0, 0, 0, 1);
		case 6: ApplyAnimationEx(playerid, "GANGS", "prtial_gngtlkG", 4.0, 1, 0, 0, 0, 0, 1);
		case 7:	ApplyAnimationEx(playerid, "GANGS", "prtial_gngtlkH", 4.0, 1, 0, 0, 0, 0, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /chat [1-7]");
	}
	return 1;
}

CMD:gesture(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimationEx(playerid, "GHANDS", "gsign1", 4.0, 0, 0, 0, 0, 0, 1);
		case 2: ApplyAnimationEx(playerid, "GHANDS", "gsign1LH", 4.0, 0, 0, 0, 0, 0, 1);
		case 3: ApplyAnimationEx(playerid, "GHANDS", "gsign2", 4.0, 0, 0, 0, 0, 0, 1);
		case 4: ApplyAnimationEx(playerid, "GHANDS", "gsign2LH", 4.0, 0, 0, 0, 0, 0, 1);
		case 5: ApplyAnimationEx(playerid, "GHANDS", "gsign3", 4.0, 0, 0, 0, 0, 0, 1);
		case 6: ApplyAnimationEx(playerid, "GHANDS", "gsign3LH", 4.0, 0, 0, 0, 0, 0, 1);
		case 7: ApplyAnimationEx(playerid, "GHANDS", "gsign4", 4.0, 0, 0, 0, 0, 0, 1);
		case 8: ApplyAnimationEx(playerid, "GHANDS", "gsign4LH", 4.0, 0, 0, 0, 0, 0, 1);
		case 9: ApplyAnimationEx(playerid, "GHANDS", "gsign5", 4.0, 0, 0, 0, 0, 0, 1);
		case 10: ApplyAnimationEx(playerid, "GHANDS", "gsign5", 4.0, 0, 0, 0, 0, 0, 1);
		case 11: ApplyAnimationEx(playerid, "GHANDS", "gsign5LH", 4.0, 0, 0, 0, 0, 0, 1);
		case 12: ApplyAnimationEx(playerid, "GANGS", "Invite_No", 4.0, 0, 0, 0, 0, 0, 1);
		case 13: ApplyAnimationEx(playerid, "GANGS", "Invite_Yes", 4.0, 0, 0, 0, 0, 0, 1);
		case 14: ApplyAnimationEx(playerid, "GANGS", "prtial_gngtlkD", 4.0, 0, 0, 0, 0, 0, 1);
		case 15: ApplyAnimationEx(playerid, "GANGS", "smkcig_prtl", 4.0, 0, 0, 0, 0, 0, 1);
		case 16: ApplyAnimationEx(playerid, "PED", "endchat_02", 4.0, 0, 0, 0, 0, 0, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /gesture [1-16]");
	}
	return 1;
}

CMD:lay(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimationEx(playerid, "BEACH", "bather", 4.0, 1, 0, 0, 0, 0, 1);
		case 2: ApplyAnimationEx(playerid, "BEACH", "Lay_Bac_Loop", 4.0, 1, 0, 0, 0, 0, 1);
		case 3: ApplyAnimationEx(playerid, "BEACH", "SitnWait_loop_W", 4.0, 1, 0, 0, 0, 0, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /lay [1-3]");
	}
	return 1;
}

CMD:wave(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimationEx(playerid, "ON_LOOKERS", "wave_loop", 4.0, 1, 0, 0, 0, 0, 1);
		case 2: ApplyAnimationEx(playerid, "KISSING", "gfwave2", 4.0, 1, 0, 0, 0, 0, 1);
		case 3: ApplyAnimationEx(playerid, "PED", "endchat_03", 4.0, 1, 0, 0, 0, 0, 1);
		case 4: ApplyAnimationEx(playerid, "bd_fire", "BD_GF_Wave", 4.0, 1, 0, 0, 0, 0, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /wave [1-4]");
	}
	return 1;
}

CMD:signal(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimationEx(playerid, "POLICE", "CopTraf_Come", 4.0, 1, 0, 0, 0, 0, 1);
		case 2: ApplyAnimationEx(playerid, "POLICE", "CopTraf_Stop", 4.0, 1, 0, 0, 0, 0, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /signal [1-2]");
	}
	return 1;
}

CMD:nobreath(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimationEx(playerid, "SWEET", "Sweet_injuredloop", 4.0, 1, 0, 0, 0, 0, 1);
		case 2: ApplyAnimationEx(playerid, "PED", "IDLE_tired", 4.0, 1, 0, 0, 0, 0, 1);
		case 3: ApplyAnimationEx(playerid, "FAT", "IDLE_tired", 4.0, 1, 0, 0, 0, 0, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /nobreath [1-3]");
	}
	return 1;
}

CMD:fallover(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimationEx(playerid, "KNIFE", "KILL_Knife_Ped_Die", 4.0, 0, 1, 1, 1, 0, 1);
		case 2: ApplyAnimationEx(playerid, "PED", "KO_shot_face", 4.0, 0, 1, 1, 1, 0, 1);
		case 3: ApplyAnimationEx(playerid, "PED", "KO_shot_stom", 4.0, 0, 1, 1, 1, 0, 1);
		case 4: ApplyAnimationEx(playerid, "PED", "BIKE_fallR", 4.1, 0, 1, 1, 1, 0, 1);
		case 5: ApplyAnimationEx(playerid, "PED", "BIKE_fall_off", 4.1, 0, 1, 1, 1, 0, 1);
		case 6: ApplyAnimationEx(playerid, "BASEBALL", "Bat_Hit_3", 4.1, 0, 1, 1, 1, 0, 1);
		case 7: ApplyAnimationEx(playerid, "DILDO", "Dildo_Hit_3", 4.1, 0, 1, 1, 1, 0, 1);
		case 8: ApplyAnimationEx(playerid, "HEIST9", "CAS_G2_GasKO", 4.1, 0, 1, 1, 1, 0, 1);
		case 9: ApplyAnimationEx(playerid, "FIGHT_B", "HitB_3", 4.1, 0, 1, 1, 1, 0, 1);
		case 10: ApplyAnimationEx(playerid, "FIGHT_C", "HitC_3", 4.1, 0, 1, 1, 1, 0, 1);
		case 11: ApplyAnimationEx(playerid, "FIGHT_D", "HitD_3", 4.1, 0, 1, 1, 1, 0, 1);
		case 12: ApplyAnimationEx(playerid, "FIGHT_E", "Hit_fightkick_B", 4.1, 0, 1, 1, 1, 0, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /fallover [1-12]");
	}
	return 1;
}

CMD:pedmove(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimationEx(playerid, "PED", "JOG_femaleA", 4.0, 1, 1, 1, 1, 1, 1);
		case 2: ApplyAnimationEx(playerid, "PED", "JOG_maleA", 4.0, 1, 1, 1, 1, 1, 1);
		case 3: ApplyAnimationEx(playerid, "PED", "WOMAN_walkfatold", 4.0, 1, 1, 1, 1, 1, 1);
		case 4: ApplyAnimationEx(playerid, "PED", "run_fat", 4.0, 1, 1, 1, 1, 1, 1);
		case 5: ApplyAnimationEx(playerid, "PED", "run_fatold", 4.0, 1, 1, 1, 1, 1, 1);
		case 6: ApplyAnimationEx(playerid, "PED", "run_old", 4.0, 1, 1, 1, 1, 1, 1);
		case 7: ApplyAnimationEx(playerid, "PED", "Run_Wuzi", 4.0, 1, 1, 1, 1, 1, 1);
		case 8: ApplyAnimationEx(playerid, "PED", "swat_run", 4.0, 1, 1, 1, 1, 1, 1);
		case 9: ApplyAnimationEx(playerid, "PED", "WALK_fat", 4.0, 1, 1, 1, 1, 1, 1);
		case 10: ApplyAnimationEx(playerid, "PED", "WALK_fatold", 4.0, 1, 1, 1, 1, 1, 1);
		case 11: ApplyAnimationEx(playerid, "PED", "WALK_gang1", 4.0, 1, 1, 1, 1, 1, 1);
		case 12: ApplyAnimationEx(playerid, "PED", "WALK_gang2", 4.0, 1, 1, 1, 1, 1, 1);
		case 13: ApplyAnimationEx(playerid, "PED", "WALK_old", 4.0, 1, 1, 1, 1, 1, 1);
		case 14: ApplyAnimationEx(playerid, "PED", "WALK_shuffle", 4.0, 1, 1, 1, 1, 1, 1);
		case 15: ApplyAnimationEx(playerid, "PED", "woman_run", 4.0, 1, 1, 1, 1, 1, 1);
		case 16: ApplyAnimationEx(playerid, "PED", "WOMAN_runbusy", 4.0, 1, 1, 1, 1, 1, 1);
		case 17: ApplyAnimationEx(playerid, "PED", "WOMAN_runfatold", 4.0, 1, 1, 1, 1, 1, 1);
		case 18: ApplyAnimationEx(playerid, "PED", "woman_runpanic", 4.0, 1, 1, 1, 1, 1, 1);
		case 19: ApplyAnimationEx(playerid, "PED", "WOMAN_runsexy", 4.0, 1, 1, 1, 1, 1, 1);
		case 20: ApplyAnimationEx(playerid, "PED", "WOMAN_walkbusy", 4.0, 1, 1, 1, 1, 1, 1);
		case 21: ApplyAnimationEx(playerid, "PED", "WOMAN_walkfatold", 4.0, 1, 1, 1, 1, 1, 1);
		case 22: ApplyAnimationEx(playerid, "PED", "WOMAN_walknorm", 4.0, 1, 1, 1, 1, 1, 1);
		case 23: ApplyAnimationEx(playerid, "PED", "WOMAN_walkold", 4.0, 1, 1, 1, 1, 1, 1);
		case 24: ApplyAnimationEx(playerid, "PED", "WOMAN_walkpro", 4.0, 1, 1, 1, 1, 1, 1);
		case 25: ApplyAnimationEx(playerid, "PED", "WOMAN_walksexy", 4.0, 1, 1, 1, 1, 1, 1);
		case 26: ApplyAnimationEx(playerid, "PED", "WOMAN_walkshop", 4.0, 1, 1, 1, 1, 1, 1);
		case 27: ApplyAnimationEx(playerid, "FAT", "FatWalk", 4.0, 1, 1, 1, 1, 1, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /pedmove [1-27]");
	}
	return 1;
}

CMD:getjiggy(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimationEx(playerid, "DANCING", "DAN_Down_A", 4.0, 1, 0, 0, 0, 0, 1);
		case 2: ApplyAnimationEx(playerid, "DANCING", "DAN_Left_A", 4.0, 1, 0, 0, 0, 0, 1);
		case 3: ApplyAnimationEx(playerid, "DANCING", "DAN_Loop_A", 4.0, 1, 0, 0, 0, 0, 1);
		case 4: ApplyAnimationEx(playerid, "DANCING", "DAN_Right_A", 4.0, 1, 0, 0, 0, 0, 1);
		case 5: ApplyAnimationEx(playerid, "DANCING", "DAN_Up_A", 4.0, 1, 0, 0, 0, 0, 1);
		case 6: ApplyAnimationEx(playerid, "DANCING", "dnce_M_a", 4.0, 1, 0, 0, 0, 0, 1);
		case 7: ApplyAnimationEx(playerid, "DANCING", "dnce_M_b", 4.0, 1, 0, 0, 0, 0, 1);
		case 8: ApplyAnimationEx(playerid, "DANCING", "dnce_M_c", 4.0, 1, 0, 0, 0, 0, 1);
		case 9: ApplyAnimationEx(playerid, "DANCING", "dnce_M_c", 4.0, 1, 0, 0, 0, 0, 1);
		case 10: ApplyAnimationEx(playerid, "DANCING", "dnce_M_d", 4.0, 1, 0, 0, 0, 0, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /getjiggy [1-10]");
	}
	return 1;
}

CMD:stripclub(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimationEx(playerid, "STRIP", "PLY_CASH", 4.0, 1, 0, 0, 0, 0, 1);
		case 2: ApplyAnimationEx(playerid, "STRIP", "PUN_CASH", 4.0, 1, 0, 0, 0, 0, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /stripclub [1-2]");
	}
	return 1;
}

CMD:smoke(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimation(playerid, "SMOKING", "M_smk_in", 4.0, 0, 0, 0, 0, 0, 1);
		case 2: ApplyAnimationEx(playerid, "SMOKING", "M_smklean_loop", 4.0, 1, 0, 0, 0, 0, 1);
		case 3: ApplyAnimationEx(playerid, "SMOKING", "F_smklean_loop", 4.0, 1, 0, 0, 0, 0, 1);
		case 4: ApplyAnimationEx(playerid, "SMOKING", "M_smk_tap", 4.0, 1, 0, 0, 0, 0, 1);
		case 5: ApplyAnimationEx(playerid, "SMOKING", "M_smk_drag", 4.0, 1, 0, 0, 0, 0, 1);
		case 6: ApplyAnimationEx(playerid, "SMOKING", "M_smk_loop", 4.0, 1, 0, 0, 0, 0, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /smoke [1-6]");
	}
	return 1;
}

CMD:dj(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimationEx(playerid, "SCRATCHING", "scdldlp", 4.0, 1, 0, 0, 0, 0, 1);
		case 2: ApplyAnimationEx(playerid, "SCRATCHING", "scdlulp", 4.0, 1, 0, 0, 0, 0, 1);
		case 3: ApplyAnimationEx(playerid, "SCRATCHING", "scdrdlp", 4.0, 1, 0, 0, 0, 0, 1);
		case 4: ApplyAnimationEx(playerid, "SCRATCHING", "scdrulp", 4.0, 1, 0, 0, 0, 0, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /dj [1-4]");
	}
	return 1;
}

CMD:reload(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimationEx(playerid, "BUDDY", "buddy_reload", 4.0, 0, 0, 0, 0, 0, 1);
		case 2: ApplyAnimationEx(playerid, "PYTHON", "python_reload", 4.0, 0, 0, 0, 0, 0, 1);
		case 3: ApplyAnimationEx(playerid, "COLT45", "colt45_reload", 4.0, 0, 0, 0, 0, 0, 1);
		case 4: ApplyAnimationEx(playerid, "COLT45", "sawnoff_reload", 4.0, 0, 0, 0, 0, 0, 1);
		case 5: ApplyAnimationEx(playerid, "RIFLE", "RIFLE_load", 4.0, 0, 0, 0, 0, 0, 1);
		case 6: ApplyAnimationEx(playerid, "SILENCED", "Silence_reload", 4.0, 0, 0, 0, 0, 0, 1);
		case 7: ApplyAnimationEx(playerid, "TEC", "TEC_reload", 3.5, 0, 0, 0, 0, 0, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /reload [1-7]");
	}
	return 1;
}

CMD:crouchreload(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimationEx(playerid, "BUDDY", "buddy_crouchreload", 4.0, 0, 0, 0, 0, 0, 1);
		case 2: ApplyAnimationEx(playerid, "COLT45", "colt45_crouchreload", 4.0, 0, 0, 0, 0, 0, 1);
		case 3: ApplyAnimationEx(playerid, "RIFLE", "RIFLE_crouchload", 4.0, 0, 0, 0, 0, 0, 1);
		case 4: ApplyAnimationEx(playerid, "SILENCED", "CrouchReload", 4.0, 0, 0, 0, 0, 0, 1);
		case 5: ApplyAnimationEx(playerid, "UZI", "UZI_crouchreload", 4.0, 0, 0, 0, 0, 0, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /crouchreload [1-5]");
	}
	return 1;
}

CMD:tagwall(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimationEx(playerid, "GRAFFITI", "graffiti_Chkout", 4.0, 1, 0, 0, 0, 0, 1);
		case 2: ApplyAnimationEx(playerid, "GRAFFITI", "spraycan_fire", 4.0, 1, 0, 0, 0, 0, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /tag [1-2]");
	}
	return 1;
}

CMD:deal(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimationEx(playerid, "DEALER", "DEALER_DEAL", 4.0, 1, 0, 0, 0, 0, 1);
		case 2: ApplyAnimationEx(playerid, "DEALER", "shop_pay", 4.0, 1, 0, 0, 0, 0, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /deal [1-2]");
	}
	return 1;
}

CMD:crossarms(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimationEx(playerid, "COP_AMBIENT", "Coplook_loop", 4.0, 0, 1, 1, 1, -1, 1);
		case 2: ApplyAnimationEx(playerid, "DEALER", "DEALER_IDLE", 4.0, 1, 0, 0, 0, 0, 1);
		case 3: ApplyAnimationEx(playerid, "GRAVEYARD", "mrnM_loop", 4.0, 1, 0, 0, 0, 0, 1);
		case 4: ApplyAnimationEx(playerid, "GRAVEYARD", "prst_loopa", 4.0, 1, 0, 0, 0, 0, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /crossarms [1-4]");
	}
	return 1;
}

CMD:cheer(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimationEx(playerid, "ON_LOOKERS", "shout_01", 4.0, 1, 0, 0, 0, 0, 1);
		case 2: ApplyAnimationEx(playerid, "ON_LOOKERS", "shout_02", 4.0, 1, 0, 0, 0, 0, 1);
		case 3: ApplyAnimationEx(playerid, "ON_LOOKERS", "shout_in", 4.0, 1, 0, 0, 0, 0, 1);
		case 4: ApplyAnimationEx(playerid, "RIOT", "RIOT_ANGRY_B", 4.0, 1, 0, 0, 0, 0, 1);
		case 5: ApplyAnimationEx(playerid, "RIOT", "RIOT_CHANT", 4.0, 1, 0, 0, 0, 0, 1);
		case 6: ApplyAnimationEx(playerid, "RIOT", "RIOT_shout", 4.0, 1, 0, 0, 0, 0, 1);
		case 7: ApplyAnimationEx(playerid, "STRIP", "PUN_HOLLER", 4.0, 1, 0, 0, 0, 0, 1);
		case 8: ApplyAnimationEx(playerid, "OTB", "wtchrace_win", 4.0, 1, 0, 0, 0, 0, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /cheer [1-8]");
	}
	return 1;
}

CMD:sit(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimationEx(playerid, "BEACH", "bather", 4.0, 1, 0, 0, 0, 0, 1);
		case 2: ApplyAnimationEx(playerid, "BEACH", "Lay_Bac_Loop", 4.0, 1, 0, 0, 0, 0, 1);
		case 3: ApplyAnimationEx(playerid, "BEACH", "ParkSit_W_loop", 4.0, 1, 0, 0, 0, 0, 1);
		case 4: ApplyAnimationEx(playerid, "BEACH", "SitnWait_loop_W", 4.0, 1, 0, 0, 0, 0, 1);
		case 5: ApplyAnimationEx(playerid, "BEACH", "ParkSit_M_loop", 4.0, 1, 0, 0, 0, 0, 1);
		case 6: ApplyAnimationEx(playerid, "FOOD", "FF_Sit_Look", 4.0, 1, 0, 0, 0, 0, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /sit [1-6]");
	}
	return 1;
}

CMD:siteat(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimationEx(playerid, "FOOD", "FF_Sit_Eat3", 4.0, 1, 0, 0, 0, 0, 1);
		case 2: ApplyAnimationEx(playerid, "FOOD", "FF_Sit_Eat2", 4.0, 1, 0, 0, 0, 0, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /siteat [1-2]");
	}
	return 1;
}

CMD:bar(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimationEx(playerid, "BAR", "Barcustom_get", 4.0, 0, 1, 0, 0, 0, 1);
		case 2: ApplyAnimationEx(playerid, "BAR", "Barserve_bottle", 4.0, 0, 0, 0, 0, 0, 1);
		case 3: ApplyAnimationEx(playerid, "BAR", "Barserve_give", 4.0, 0, 0, 0, 0, 0, 1);
		case 4: ApplyAnimationEx(playerid, "BAR", "dnk_stndM_loop", 4.0, 0, 0, 0, 0, 0, 1);
		case 5: ApplyAnimationEx(playerid, "BAR", "BARman_idle", 4.0, 1, 0, 0, 0, 0, 1);
		case 6: ApplyAnimationEx(playerid, "BAR", "Barserve_loop", 4.0, 1, 0, 0, 0, 0, 1);
		case 7: ApplyAnimationEx(playerid, "BAR", "Barserve_order", 4.0, 0, 0, 0, 0, 0, 1);
		case 8: ApplyAnimationEx(playerid, "BAR", "Barcustom_order", 4.0, 0, 0, 0, 0, 0, 1);
		case 9: ApplyAnimationEx(playerid, "BAR", "dnk_stndF_loop", 4.0, 0, 0, 0, 0, 0, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /bar [1-9]");
	}
	return 1;
}

CMD:dance(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: SetPlayerSpecialAction(playerid, 5);
		case 2: SetPlayerSpecialAction(playerid, 6);
		case 3: SetPlayerSpecialAction(playerid, 7);
		case 4: SetPlayerSpecialAction(playerid, 8);
		default: SendClientMessage(playerid, WHITE, "USAGE: /dance [1-4]");
	}
	return 1;
}

CMD:spank(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimationEx(playerid, "SNM", "SPANKINGW", 4.1, 1, 0, 0, 0, 0, 1);
		case 2: ApplyAnimationEx(playerid, "SNM", "SPANKINGP", 4.1, 1, 0, 0, 0, 0, 1);
		case 3: ApplyAnimationEx(playerid, "SNM", "SPANKEDW", 4.1, 1, 0, 0, 0, 0, 1);
		case 4: ApplyAnimationEx(playerid, "SNM", "SPANKEDP", 4.1, 1, 0, 0, 0, 0, 1);
		case 5: ApplyAnimationEx(playerid, "SNM", "Spanked_IdleP", 4.1, 1, 0, 0, 0, 0, 1);
		case 6: ApplyAnimationEx(playerid, "SNM", "Spanked_IdleW", 4.1, 1, 0, 0, 0, 0, 1);
		case 7: ApplyAnimationEx(playerid, "SNM", "Spanking_endP", 4.1, 0, 0, 0, 0, 0, 1);
		case 8: ApplyAnimationEx(playerid, "SNM", "Spanking_endW", 4.1, 0, 0, 0, 0, 0, 1);
		case 9: ApplyAnimationEx(playerid, "SNM", "Spanking_SittingIdleW", 4.1, 1, 0, 0, 0, 0, 1);
		case 10: ApplyAnimationEx(playerid, "SNM", "Spanking_SittingW", 4.1, 1, 0, 0, 0, 0, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /spank [1-10]");
	}
	return 1;
}

CMD:sexy(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimationEx(playerid, "STRIP", "strip_E", 4.1, 1, 0, 0, 0, 0, 1);
		case 2: ApplyAnimationEx(playerid, "STRIP", "strip_G", 4.1, 1, 0, 0, 0, 0, 1);
		case 3: ApplyAnimation(playerid, "STRIP", "STR_A2B", 4.1, 0, 0, 0, 0, 0, 1);
		case 4: ApplyAnimationEx(playerid, "STRIP", "STR_Loop_A", 4.1, 1, 0, 0, 0, 0, 1);
		case 5: ApplyAnimationEx(playerid, "STRIP", "STR_Loop_B", 4.1, 1, 0, 0, 0, 0, 1);
		case 6: ApplyAnimationEx(playerid, "STRIP", "STR_Loop_C", 4.1, 1, 0, 0, 0, 0, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /sexy [1-6]");
	}
	return 1;
}

CMD:holdup(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimationEx(playerid, "POOL", "POOL_ChalkCue", 4.1, 0, 1, 1, 1, 1, 1);
		case 2: ApplyAnimationEx(playerid, "POOL", "POOL_Idle_Stance", 4.1, 0, 1, 1, 1, 1, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /holdup [1-2]");
	}
	return 1;
}

CMD:copa(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimation(playerid, "POLICE", "CopTraf_Away", 4.1, 0, 0, 0, 0, 0, 1);
		case 2: ApplyAnimation(playerid, "POLICE", "CopTraf_Come", 4.1, 0, 0, 0, 0, 0, 1);
		case 3: ApplyAnimation(playerid, "POLICE", "CopTraf_Left", 4.1, 0, 0, 0, 0, 0, 1);
		case 4: ApplyAnimation(playerid, "POLICE", "CopTraf_Stop", 4.1, 0, 0, 0, 0, 0, 1);
		case 5: ApplyAnimationEx(playerid, "POLICE", "Cop_move_FWD", 4.1, 1, 1, 1, 1, 1, 1);
		case 6: ApplyAnimationEx(playerid, "POLICE", "crm_drgbst_01", 4.1, 0, 0, 0, 1, 5000, 1);
		case 7: ApplyAnimation(playerid, "POLICE", "Door_Kick", 4.1, 0, 1, 1, 1, 1, 1);
		case 8: ApplyAnimation(playerid, "POLICE", "plc_drgbst_01", 4.1, 0, 0, 0, 0, 5000, 1);
		case 9: ApplyAnimation(playerid, "POLICE", "plc_drgbst_02", 4.1, 0, 0, 0, 0, 0, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /copa [1-9]");
	}
	return 1;
}

CMD:misc(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimationEx(playerid, "CAR", "Fixn_Car_Loop", 4.1, 1, 0, 0, 0, 0, 1);
		case 2: ApplyAnimation(playerid, "CAR", "flag_drop", 4.1, 0, 0, 0, 0, 0, 1);
		case 3: ApplyAnimation(playerid, "PED", "bomber", 4.1, 0, 0, 0, 0, 0, 1);
		case 4: ApplyAnimation(playerid, "MISC", "Plunger_01", 4.1, 0, 1, 1, 1, 1, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /misc [1-4]");
	}
	return 1;
}

CMD:snatch(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimation(playerid, "PED", "BIKE_elbowL", 4.1, 0, 0, 0, 0, 0, 1);
		case 2: ApplyAnimation(playerid, "PED", "BIKE_elbowR", 4.1, 0, 0, 0, 0, 0, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /snatch [1-2]");
	}
	return 1;
}

CMD:blowjob(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimationEx(playerid, "BLOWJOBZ", "BJ_COUCH_LOOP_P", 4.1, 1, 0, 0, 0, 0, 1);
		case 2: ApplyAnimationEx(playerid, "BLOWJOBZ", "BJ_COUCH_LOOP_W", 4.1, 1, 0, 0, 0, 0, 1);
		case 3: ApplyAnimationEx(playerid, "BLOWJOBZ", "BJ_STAND_LOOP_P", 4.1, 1, 0, 0, 0, 0, 1);
		case 4: ApplyAnimationEx(playerid, "BLOWJOBZ", "BJ_STAND_LOOP_W", 4.1, 1, 0, 0, 0, 0, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /blowjob [1-4]");
	}
	return 1;
}

CMD:kiss(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimation(playerid, "KISSING", "Playa_Kiss_01", 4.1, 0, 0, 0, 0, 0, 1);
		case 2: ApplyAnimation(playerid, "KISSING", "Playa_Kiss_02", 4.1, 0, 0, 0, 0, 0, 1);
		case 3: ApplyAnimation(playerid, "KISSING", "Playa_Kiss_03", 4.1, 0, 0, 0, 0, 0, 1);
		case 4: ApplyAnimation(playerid, "KISSING", "Grlfrd_Kiss_01", 4.1, 0, 0, 0, 0, 0, 1);
		case 5: ApplyAnimation(playerid, "KISSING", "Grlfrd_Kiss_02", 4.1, 0, 0, 0, 0, 0, 1);
		case 6: ApplyAnimation(playerid, "KISSING", "Grlfrd_Kiss_03", 4.1, 0, 0, 0, 0, 0, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /kiss [1-6]");
	}
	return 1;
}

CMD:idles(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimationEx(playerid, "PLAYIDLES", "shift", 4.1, 1, 1, 1, 1, 1, 1);
		case 2: ApplyAnimationEx(playerid, "PLAYIDLES", "shldr", 4.1, 1, 1, 1, 1, 1, 1);
		case 3: ApplyAnimationEx(playerid, "PLAYIDLES", "stretch", 4.1, 1, 1, 1, 1, 1, 1);
		case 4: ApplyAnimationEx(playerid, "PLAYIDLES", "strleg", 4.1, 1, 1, 1, 1, 1, 1);
		case 5: ApplyAnimationEx(playerid, "PLAYIDLES", "time", 4.1, 1, 1, 1, 1, 1, 1);
		case 6: ApplyAnimationEx(playerid, "COP_AMBIENT", "Copbrowse_loop", 4.1, 1, 0, 0, 0, 0, 1);
		case 7: ApplyAnimationEx(playerid, "COP_AMBIENT", "Coplook_loop", 4.1, 1, 0, 0, 0, 0, 1);
		case 8: ApplyAnimationEx(playerid, "COP_AMBIENT", "Coplook_shake", 4.1, 1, 0, 0, 0, 0, 1);
		case 9: ApplyAnimationEx(playerid, "COP_AMBIENT", "Coplook_think", 4.1, 1, 0, 0, 0, 0, 1);
		case 10: ApplyAnimationEx(playerid, "COP_AMBIENT", "Coplook_watch", 4.1, 1, 0, 0, 0, 0, 1);
		case 11: ApplyAnimationEx(playerid, "PED", "roadcross", 4.1, 1, 0, 0, 0, 0, 1);
		case 12: ApplyAnimationEx(playerid, "PED", "roadcross_female", 4.1, 1, 0, 0, 0, 0, 1);
		case 13: ApplyAnimationEx(playerid, "PED", "roadcross_gang", 4.1, 1, 0, 0, 0, 0, 1);	
		case 14: ApplyAnimationEx(playerid, "PED", "roadcross_old", 4.1, 1, 0, 0, 0, 0, 1);	
		case 15: ApplyAnimationEx(playerid, "PED", "woman_idlestance", 4.1, 1, 0, 0, 0, 0, 1);
		case 16: ApplyAnimationEx(playerid, "DEALER", "DEALER_IDLE_01", 4.1, 1, 0, 0, 0, 0, 1);
		case 17: ApplyAnimationEx(playerid, "DEALER", "DEALER_IDLE_02", 4.1, 1, 0, 0, 0, 0, 1);
		case 18: ApplyAnimationEx(playerid, "DEALER", "DEALER_IDLE_03", 4.1, 1, 0, 0, 0, 0, 1);
		case 19: ApplyAnimationEx(playerid, "DEALER", "DEALER_IDLE", 4.1, 1, 0, 0, 0, 0, 1);
		case 20: ApplyAnimationEx(playerid, "ON_LOOKERS", "lkup_point", 4.1, 1, 0, 0, 0, 0, 1);
		case 21: ApplyAnimationEx(playerid, "ON_LOOKERS", "panic_cower", 4.1, 1, 0, 0, 0, 0, 1);
		case 22: ApplyAnimationEx(playerid, "ON_LOOKERS", "panic_hide", 4.1, 1, 0, 0, 0, 0, 1);
		case 23: ApplyAnimationEx(playerid, "ON_LOOKERS", "panic_loop", 4.1, 1, 0, 0, 0, 0, 1);
		case 24: ApplyAnimationEx(playerid, "ON_LOOKERS", "panic_point", 4.1, 1, 0, 0, 0, 0, 1);
		case 25: ApplyAnimationEx(playerid, "ON_LOOKERS", "panic_shout", 4.1, 1, 0, 0, 0, 0, 1);
		case 26: ApplyAnimationEx(playerid, "ON_LOOKERS", "point_loop", 4.1, 1, 0, 0, 0, 0, 1);
		case 27: ApplyAnimationEx(playerid, "ON_LOOKERS", "shout_loop", 4.1, 1, 0, 0, 0, 0, 1);
		case 28: ApplyAnimationEx(playerid, "OTB", "wtchrace_loop", 4.1, 1, 0, 0, 0, 0, 1);
		case 29: ApplyAnimationEx(playerid, "PAULNMAC", "PnM_Loop_A", 4.1, 1, 0, 0, 0, 0, 1);
		case 30: ApplyAnimationEx(playerid, "PAULNMAC", "PnM_Loop_B", 4.1, 1, 0, 0, 0, 0, 1);
		case 31: ApplyAnimationEx(playerid, "MUSCULAR", "MuscleIdle", 4.1, 1, 0, 0, 0, 0, 1);
		case 32: ApplyAnimationEx(playerid, "FAT", "FatIdle", 4.1, 1, 0, 0, 0, 0, 1);
		case 33: ApplyAnimationEx(playerid, "PED", "idlestance_old", 4.1, 1, 0, 0, 0, 0, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /idles [1-33]");
	}
	return 1;
}

CMD:sunbathe(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimationEx(playerid, "SUNBATHE", "batherdown", 4.1, 0, 1, 1, 1, 1, 1);
		case 2: ApplyAnimationEx(playerid, "SUNBATHE", "batherup", 4.1, 0, 1, 1, 1, 1, 1);
		case 3: ApplyAnimationEx(playerid, "SUNBATHE", "Lay_Bac_in", 4.1, 0, 1, 1, 1, 1, 1);
		case 4: ApplyAnimationEx(playerid, "SUNBATHE", "Lay_Bac_out", 4.1, 0, 1, 1, 1, 1, 1);
		case 5: ApplyAnimationEx(playerid, "SUNBATHE", "ParkSit_M_IdleA", 4.1, 0, 1, 1, 1, 1, 1);
		case 6: ApplyAnimationEx(playerid, "SUNBATHE", "ParkSit_M_IdleB", 4.1, 0, 1, 1, 1, 1, 1);
		case 7: ApplyAnimationEx(playerid, "SUNBATHE", "ParkSit_M_IdleC", 4.1, 0, 1, 1, 1, 1, 1);
		case 8: ApplyAnimationEx(playerid, "SUNBATHE", "ParkSit_M_in", 4.1, 0, 1, 1, 1, 1, 1);
		case 9: ApplyAnimationEx(playerid, "SUNBATHE", "ParkSit_M_out", 4.1, 0, 1, 1, 1, 1, 1);
		case 10: ApplyAnimationEx(playerid, "SUNBATHE", "ParkSit_W_idleA", 4.1, 0, 1, 1, 1, 1, 1);
		case 11: ApplyAnimationEx(playerid, "SUNBATHE", "ParkSit_W_idleB", 4.1, 0, 1, 1, 1, 1, 1);
		case 12: ApplyAnimationEx(playerid, "SUNBATHE", "ParkSit_W_idleC", 4.1, 0, 1, 1, 1, 1, 1);
		case 13: ApplyAnimationEx(playerid, "SUNBATHE", "ParkSit_W_in", 4.1, 0, 1, 1, 1, 1, 1);
		case 14: ApplyAnimationEx(playerid, "SUNBATHE", "ParkSit_W_out", 4.1, 0, 1, 1, 1, 1, 1);
		case 15: ApplyAnimationEx(playerid, "SUNBATHE", "SBATHE_F_LieB2Sit", 4.1, 0, 1, 1, 1, 1, 1);
		case 16: ApplyAnimationEx(playerid, "SUNBATHE", "SBATHE_F_Out", 4.1, 0, 1, 1, 1, 1, 1);
		case 17: ApplyAnimationEx(playerid, "SUNBATHE", "SitnWait_in_W", 4.1, 0, 1, 1, 1, 1, 1);
		case 18: ApplyAnimationEx(playerid, "SUNBATHE", "SitnWait_out_W", 4.1, 0, 1, 1, 1, 1, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /sunbathe [1-18]");
	}
	return 1;
}

CMD:lowrider(playerid, params[])
{
	if(!IsAbleVehicleAnimation(playerid)) return 1;
	if(IsCLowrider(GetPlayerVehicleID(playerid)))
	{
		switch(strval(params))
		{
			case 1: ApplyAnimation(playerid, "LOWRIDER", "lrgirl_bdbnce", 4.1, 0, 1, 1, 1, 1, 1);
			case 2: ApplyAnimation(playerid, "LOWRIDER", "lrgirl_hair", 4.1, 0, 1, 1, 1, 1, 1);
			case 3: ApplyAnimation(playerid, "LOWRIDER", "lrgirl_hurry", 4.1, 0, 1, 1, 1, 1, 1);
			case 4: ApplyAnimation(playerid, "LOWRIDER", "lrgirl_idleloop", 4.1, 0, 1, 1, 1, 1, 1);
			case 5: ApplyAnimation(playerid, "LOWRIDER", "lrgirl_idle_to_l0", 4.1, 0, 1, 1, 1, 1, 1);
			case 6: ApplyAnimation(playerid, "LOWRIDER", "lrgirl_l0_bnce", 4.1, 0, 1, 1, 1, 1, 1);
			case 7: ApplyAnimation(playerid, "LOWRIDER", "lrgirl_l0_loop", 4.1, 0, 1, 1, 1, 1, 1);
			case 8: ApplyAnimation(playerid, "LOWRIDER", "lrgirl_l0_to_l1", 4.1, 0, 1, 1, 1, 1, 1);
			case 9: ApplyAnimation(playerid, "LOWRIDER", "lrgirl_l12_to_l0", 4.1, 0, 1, 1, 1, 1, 1);
			case 10: ApplyAnimation(playerid, "LOWRIDER", "lrgirl_l1_bnce", 4.1, 0, 1, 1, 1, 1, 1);
			case 11: ApplyAnimation(playerid, "LOWRIDER", "lrgirl_l1_loop", 4.1, 0, 1, 1, 1, 1, 1);
			case 12: ApplyAnimation(playerid, "LOWRIDER", "lrgirl_l1_to_l2", 4.1, 0, 1, 1, 1, 1, 1);
			case 13: ApplyAnimation(playerid, "LOWRIDER", "lrgirl_l2_bnce", 4.1, 0, 1, 1, 1, 1, 1);
			case 14: ApplyAnimation(playerid, "LOWRIDER", "lrgirl_l2_loop", 4.1, 0, 1, 1, 1, 1, 1);
			case 15: ApplyAnimation(playerid, "LOWRIDER", "lrgirl_l2_to_l3", 4.1, 0, 1, 1, 1, 1, 1);
			case 16: ApplyAnimation(playerid, "LOWRIDER", "lrgirl_l345_to_l1", 4.1, 0, 1, 1, 1, 1, 1);
			case 17: ApplyAnimation(playerid, "LOWRIDER", "lrgirl_l3_bnce", 4.1, 0, 1, 1, 1, 1, 1);
			case 18: ApplyAnimation(playerid, "LOWRIDER", "lrgirl_l3_loop", 4.1, 0, 1, 1, 1, 1, 1);
			case 19: ApplyAnimation(playerid, "LOWRIDER", "lrgirl_l3_to_l4", 4.1, 0, 1, 1, 1, 1, 1);
			case 20: ApplyAnimation(playerid, "LOWRIDER", "lrgirl_l4_bnce", 4.1, 0, 1, 1, 1, 1, 1);
			case 21: ApplyAnimation(playerid, "LOWRIDER", "lrgirl_l4_loop", 4.1, 0, 1, 1, 1, 1, 1);
			case 22: ApplyAnimation(playerid, "LOWRIDER", "lrgirl_l4_to_l5", 4.1, 0, 1, 1, 1, 1, 1);
			case 23: ApplyAnimation(playerid, "LOWRIDER", "lrgirl_l5_bnce", 4.1, 0, 1, 1, 1, 1, 1);
			case 24: ApplyAnimation(playerid, "LOWRIDER", "lrgirl_l5_loop", 4.1, 0, 1, 1, 1, 1, 1);
			case 25: ApplyAnimation(playerid, "LOWRIDER", "prtial_gngtlkB", 4.1, 0, 1, 1, 1, 1, 1);
			case 26: ApplyAnimation(playerid, "LOWRIDER", "prtial_gngtlkC", 4.1, 0, 1, 1, 1, 1, 1);
			case 27: ApplyAnimation(playerid, "LOWRIDER", "prtial_gngtlkD", 4.1, 0, 1, 1, 1, 1, 1);
			case 28: ApplyAnimation(playerid, "LOWRIDER", "prtial_gngtlkE", 4.1, 0, 1, 1, 1, 1, 1);
			case 29: ApplyAnimation(playerid, "LOWRIDER", "prtial_gngtlkF", 4.1, 0, 1, 1, 1, 1, 1);
			case 30: ApplyAnimation(playerid, "LOWRIDER", "prtial_gngtlkG", 4.1, 0, 1, 1, 1, 1, 1);
			case 31: ApplyAnimation(playerid, "LOWRIDER", "prtial_gngtlkH", 4.1, 0, 1, 1, 1, 1, 1);
			default: SendClientMessage(playerid, WHITE, "USAGE: /lowrider [1-31]");
		}
	}
	else
	{
		SendClientMessage(playerid, GREY, "This animation requires you to be in a convertible lowrider.");
	}
	return 1;
}

CMD:carchat(playerid, params[])
{
	if(!IsAbleVehicleAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimation(playerid, "CAR_CHAT", "carfone_in", 4.1, 0, 1, 1, 1, 1, 1);
		case 2: ApplyAnimation(playerid, "CAR_CHAT", "carfone_loopA", 4.1, 0, 1, 1, 1, 1, 1);
		case 3: ApplyAnimation(playerid, "CAR_CHAT", "carfone_loopA_to_B", 4.1, 0, 1, 1, 1, 1, 1);
		case 4: ApplyAnimation(playerid, "CAR_CHAT", "carfone_loopB", 4.1, 0, 1, 1, 1, 1, 1);
		case 5: ApplyAnimation(playerid, "CAR_CHAT", "carfone_loopB_to_A", 4.1, 0, 1, 1, 1, 1, 1);
		case 6: ApplyAnimation(playerid, "CAR_CHAT", "carfone_out", 4.1, 0, 1, 1, 1, 1, 1);
		case 7: ApplyAnimation(playerid, "CAR_CHAT", "CAR_Sc1_BL", 4.1, 0, 1, 1, 1, 1, 1);
		case 8: ApplyAnimation(playerid, "CAR_CHAT", "CAR_Sc1_BR", 4.1, 0, 1, 1, 1, 1, 1);
		case 9: ApplyAnimation(playerid, "CAR_CHAT", "CAR_Sc1_FL", 4.1, 0, 1, 1, 1, 1, 1);
		case 10: ApplyAnimation(playerid, "CAR_CHAT", "CAR_Sc1_FR", 4.1, 0, 1, 1, 1, 1, 1);
		case 11: ApplyAnimation(playerid, "CAR_CHAT", "CAR_Sc2_FL", 4.1, 0, 1, 1, 1, 1, 1);
		case 12: ApplyAnimation(playerid, "CAR_CHAT", "CAR_Sc3_BR", 4.1, 0, 1, 1, 1, 1, 1);
		case 13: ApplyAnimation(playerid, "CAR_CHAT", "CAR_Sc3_FL", 4.1, 0, 1, 1, 1, 1, 1);
		case 14: ApplyAnimation(playerid, "CAR_CHAT", "CAR_Sc3_FR", 4.1, 0, 1, 1, 1, 1, 1);
		case 15: ApplyAnimation(playerid, "CAR_CHAT", "CAR_Sc4_BL", 4.1, 0, 1, 1, 1, 1, 1);
		case 16: ApplyAnimation(playerid, "CAR_CHAT", "CAR_Sc4_BR", 4.1, 0, 1, 1, 1, 1, 1);
		case 17: ApplyAnimation(playerid, "CAR_CHAT", "CAR_Sc4_FL", 4.1, 0, 1, 1, 1, 1, 1);
		case 18: ApplyAnimation(playerid, "CAR_CHAT", "CAR_Sc4_FR", 4.1, 0, 1, 1, 1, 1, 1);
		case 19: ApplyAnimation(playerid, "CAR", "Sit_relaxed", 4.1, 0, 1, 1, 1, 1, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /carchat [1-19]");
	}
	return 1;
}

CMD:hitchhike(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimationEx(playerid, "MISC", "Hiker_Pose", 4.1, 0, 1, 1, 1, 1, 1);
		case 2: ApplyAnimationEx(playerid, "MISC", "Hiker_Pose_L", 4.1, 0, 1, 1, 1, 1, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /hitchhike [1-2]");
	}
	return 1;
}

CMD:bat(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimationEx(playerid,"BASEBALL","Bat_IDLE",4.1, 1, 1, 1, 1, 1, 1);
		case 2: ApplyAnimationEx(playerid, "CRACK", "Bbalbat_Idle_01", 4.0, 1, 0, 0, 0, 0, 1);
		case 3: ApplyAnimationEx(playerid, "CRACK", "Bbalbat_Idle_02", 4.0, 1, 0, 0, 0, 0, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /bat [1-3]");
	}
	return 1;
}

CMD:sitonchair(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimationEx(playerid, "Attractors", "Stepsit_in", 4.0, 0, 0, 0, 1, 0, 1);
		case 2: ApplyAnimationEx(playerid, "CRIB", "PED_Console_Loop", 4.0, 1, 0, 0, 0, 0, 1);
		case 3: ApplyAnimationEx(playerid, "INT_HOUSE", "LOU_In", 4.0, 0, 0, 0, 1, 1, 1);
		case 4: ApplyAnimationEx(playerid, "MISC", "SEAT_LR", 4.0, 1, 0, 0, 0, 0, 1);
		case 5: ApplyAnimationEx(playerid, "MISC", "Seat_talk_01", 4.0, 1, 0, 0, 0, 0, 1);
		case 6: ApplyAnimationEx(playerid, "MISC", "Seat_talk_02", 4.0, 1, 0, 0, 0, 0, 1);
		case 7: ApplyAnimationEx(playerid, "ped", "SEAT_down", 4.0, 0, 0, 0, 1, 1, 1);
		case 8: ApplyAnimationEx(playerid, "JST_BUISNESS", "girl_02", 4.0, 1, 0, 0, 1, 1, 1);
		case 9: ApplyAnimationEx(playerid, "MISC", "SEAT_watch", 4.0, 1, 0, 0, 1, 1, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /sitonchair [1-9]");
	}
	return 1;
}

CMD:cashier(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	ApplyAnimationEx(playerid, "INT_SHOP", "shop_cashier", 4.0, 1, 0, 0, 0, 0, 1);
	return 1;
}

CMD:nope(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	ApplyAnimationEx(playerid, "PED", "endchat_02", 4.0, 0, 0, 0, 0, 0, 1);
	return 1;
}

CMD:middlefinger(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	ApplyAnimationEx(playerid,"RIOT","RIOT_FUKU",3.8,0,0,0,0,0,1);
	return 1;
}

CMD:phonetalk(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	ApplyAnimationEx(playerid,"PED","phone_talk",3.8,1,0,0,0,0,1);
	return 1;
}

CMD:write(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	ApplyAnimationEx(playerid,"OTB","betslp_loop",4.0,0,0,0,0,0,1);
	return 1;
}

CMD:opendoor(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1:ApplyAnimationEx(playerid, "PED", "Walk_DoorPartial", 4.0, 0, 0, 0, 0, 0, 1);
		case 2: ApplyAnimationEx(playerid, "AIRPORT", "thrw_barl_thrw", 4.0, 0, 0, 0, 0, 0, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /opendoor [1-2]");
	}
	return 1;
}

CMD:robman(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimationEx(playerid, "SHOP", "ROB_Loop_Threat", 4.0, 1, 0, 0, 0, 0, 1);
		case 2: ApplyAnimationEx(playerid, "SHOP", "SHP_Gun_Aim", 4.0, 1, 0, 0, 0, 0, 1);
		case 3: ApplyAnimationEx(playerid, "SHOP", "SHP_Gun_Threat", 4.0, 1, 0, 0, 0, 0, 1);
		case 4: ApplyAnimationEx(playerid, "PED", "Gun_stand", 4.0, 1, 0, 0, 0, 0, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /robman [1-4]");
	}
	return 1;
}

CMD:camera(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimationEx(playerid, "CAMERA", "camcrch_idleloop", 4.0, 1, 0, 0, 1, 0, 1);
		case 2: ApplyAnimationEx(playerid, "CAMERA", "camcrch_cmon", 4.0, 1, 0, 0, 0, 0, 1);
		case 3: ApplyAnimationEx(playerid, "CAMERA", "camcrch_to_camstnd", 4.0, 0, 0, 0, 1, 1, 1);
		case 4: ApplyAnimationEx(playerid, "CAMERA", "camstnd_cmon", 4.0, 1, 0, 0, 0, 0, 1);
		case 5: ApplyAnimationEx(playerid, "CAMERA", "camstnd_idleloop", 4.0, 1, 0, 0, 0, 0, 1);
		case 6: ApplyAnimationEx(playerid, "CAMERA", "camstnd_lkabt", 4.0, 1, 0, 0, 0, 0, 1);
		case 7: ApplyAnimationEx(playerid, "CAMERA", "camstnd_to_camcrch", 4.0, 0, 0, 0, 1, 1, 1);
		case 8: ApplyAnimationEx(playerid, "CAMERA", "piccrch_take", 4.0, 1, 0, 0, 0, 0, 1);
		case 9: ApplyAnimationEx(playerid, "CAMERA", "picstnd_take", 4.0, 1, 0, 0, 0, 0, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /camera [1-9]");
	}
	return 1;
}

CMD:bomb(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0, 1);
		case 2:	ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant_Loop", 4.0, 1, 0, 0, 0, 0, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /bomb [1-2]");
	}
	return 1;
}

CMD:beckon(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimationEx(playerid, "RYDER", "RYD_Beckon_01", 4.0, 0, 0, 0, 0, 0, 1);
		case 2:	ApplyAnimationEx(playerid, "RYDER", "RYD_Beckon_02", 4.0, 0, 0, 0, 0, 0, 1);
		case 3:	ApplyAnimationEx(playerid, "RYDER", "RYD_Beckon_03", 4.0, 0, 0, 0, 0, 0, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /beckon [1-3]");
	}
	return 1;
}

CMD:carry(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimationEx(playerid, "CARRY", "liftup", 3.8, 0, 0, 0, 0, 0, 1);
		case 2:	ApplyAnimationEx(playerid, "CARRY", "liftup05", 3.8, 0, 0, 0, 0, 0, 1);
		case 3:	ApplyAnimationEx(playerid, "CARRY", "liftup105", 3.8, 0, 0, 0, 0, 0, 1);
		case 4:	ApplyAnimationEx(playerid, "CARRY", "putdwn", 3.8, 0, 0, 0, 0, 0, 1);
		case 5: ApplyAnimationEx(playerid, "CARRY", "putdwn05", 3.8, 0, 0, 0, 0, 0, 1);
		case 6: ApplyAnimationEx(playerid, "CARRY", "putdwn105", 3.8, 0, 0, 0, 0, 0, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /carry [1-6]");
	}
	return 1;
}

CMD:cslot(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimationEx(playerid, "CASINO", "Slot_bet_01", 4.0, 0, 0, 0, 0, 0, 1);
		case 2:	ApplyAnimationEx(playerid, "CASINO", "Slot_bet_02", 4.0, 0, 0, 0, 0, 0, 1);
		case 3:	ApplyAnimationEx(playerid, "CASINO", "Slot_in", 4.0, 0, 0, 0, 0, 0, 1);
		case 4:	ApplyAnimationEx(playerid, "CASINO", "Slot_lose_out", 4.0, 0, 0, 0, 0, 0, 1);
		case 5: ApplyAnimationEx(playerid, "CASINO", "Slot_Plyr", 4.0, 0, 0, 0, 0, 0, 1);
		case 6: ApplyAnimationEx(playerid, "CASINO", "Slot_wait", 4.0, 1, 0, 0, 0, 0, 1);
		case 7: ApplyAnimationEx(playerid, "CASINO", "Slot_win_out", 4.0, 0, 0, 0, 0, 0, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /cslot [1-7]");
	}
	return 1;
}

CMD:croulette(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimationEx(playerid, "CASINO", "Roulette_bet", 4.0, 0, 0, 0, 0, 0, 1);
		case 2:	ApplyAnimationEx(playerid, "CASINO", "Roulette_loop", 4.0, 0, 0, 0, 0, 0, 1);
		case 3:	ApplyAnimationEx(playerid, "CASINO", "Roulette_lose", 4.0, 0, 0, 0, 0, 0, 1);
		case 4:	ApplyAnimationEx(playerid, "CASINO", "Roulette_out", 4.0, 0, 0, 0, 0, 0, 1);
		case 5: ApplyAnimationEx(playerid, "CASINO", "Roulette_win", 4.0, 0, 0, 0, 0, 0, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /croulette [1-5]");
	}
	return 1;
}

CMD:ccards(playerid,params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimationEx(playerid, "CASINO", "cards_in", 4.0, 0, 0, 0, 0, 0, 1);
		case 2:	ApplyAnimationEx(playerid, "CASINO", "cards_loop", 4.0, 0, 0, 0, 0, 0, 1);
		case 3:	ApplyAnimationEx(playerid, "CASINO", "cards_lose", 4.0, 0, 0, 0, 0, 0, 1);
		case 4:	ApplyAnimationEx(playerid, "CASINO", "cards_pick_01", 4.0, 0, 0, 0, 0, 0, 1);
		case 5: ApplyAnimationEx(playerid, "CASINO", "cards_pick_02", 4.0, 0, 0, 0, 0, 0, 1);
		case 6: ApplyAnimationEx(playerid, "CASINO", "dealone", 4.0, 0, 0, 0, 0, 0, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /ccards [1-6]");
	}
	return 1;
}

CMD:pose(playerid,params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimationEx(playerid, "CLOTHES", "CLO_Buy", 4.0, 1, 0, 0, 0, 0, 1);
		case 2:	ApplyAnimationEx(playerid, "CLOTHES", "CLO_Pose_Hat", 4.0, 1, 0, 0, 0, 0, 1);
		case 3:	ApplyAnimationEx(playerid, "CLOTHES", "CLO_Pose_Legs", 4.0, 1, 0, 0, 0, 0, 1);
		case 4:	ApplyAnimationEx(playerid, "CLOTHES", "CLO_Pose_Loop", 4.0, 1, 0, 0, 0, 0, 1);
		case 5: ApplyAnimationEx(playerid, "CLOTHES", "CLO_Pose_Shoes", 4.0, 1, 0, 0, 0, 0, 1);
		case 6: ApplyAnimationEx(playerid, "CLOTHES", "CLO_Pose_Torso", 4.0, 1, 0, 0, 0, 0, 1);
		case 7: ApplyAnimationEx(playerid, "CLOTHES", "CLO_Pose_Watch", 4.0, 1, 0, 0, 0, 0, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /pose [1-7]");
	}
	return 1;
}

CMD:crack(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimationEx(playerid, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 0, 0, 1);
		case 2: ApplyAnimationEx(playerid, "CRACK", "crckidle1", 4.0, 1, 0, 0, 0, 0, 1);
		case 3: ApplyAnimationEx(playerid, "CRACK", "crckidle2", 4.0, 1, 0, 0, 0, 0, 1);
		case 4: ApplyAnimationEx(playerid, "CRACK", "crckidle3", 4.0, 1, 0, 0, 0, 0, 1);
		case 5: ApplyAnimationEx(playerid, "CRACK", "crckidle4", 4.0, 1, 0, 0, 0, 0, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /crack [1-5]");
	}
	return 1;
}

CMD:eat(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimationEx(playerid, "FOOD", "EAT_Burger", 3.0, 1, 0, 0, 0, 0, 1);
		case 2: ApplyAnimationEx(playerid, "FOOD", "EAT_Chicken", 3.0, 1, 0, 0, 0, 0, 1);
		case 3: ApplyAnimationEx(playerid, "FOOD", "EAT_Pizza", 3.0, 1, 0, 0, 0, 0, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /eat [1-3]");
	}
	return 1;
}

CMD:lean(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimationEx(playerid, "MISC", "Plyrlean_loop", 4.0, 1, 1, 1, 1, 1, 1);
		case 2: ApplyAnimationEx(playerid, "GANGS", "leanIDLE", 4.0, 0, 1, 1, 1, 0, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /lean [1-2]");
	}
	return 1;
}

CMD:swata(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimationEx(playerid, "HEIST9", "swt_wllpk_L", 4.0, 0, 1, 1, 1, 1, 1);
		case 2: ApplyAnimationEx(playerid, "HEIST9", "swt_wllpk_R", 4.0, 0, 1, 1, 1, 1, 1);
		case 3: ApplyAnimationEx(playerid, "HEIST9", "swt_wllshoot_in_L", 4.0, 0, 1, 1, 1, 1, 1);
		case 4: ApplyAnimationEx(playerid, "HEIST9", "swt_wllshoot_in_R", 4.0, 0, 1, 1, 1, 1, 1);
		case 5: ApplyAnimationEx(playerid, "SWAT", "swt_lkt", 4.0, 0, 1, 1, 1, 1, 1);
		case 6: ApplyAnimationEx(playerid, "SWAT", "swt_sty", 4.0, 0, 1, 1, 1, 1, 1);
		case 7: ApplyAnimationEx(playerid, "ped", "Crouch_Roll_L", 4.0, 0, 1, 1, 1, 1, 1);
		case 8: ApplyAnimationEx(playerid, "ped", "Crouch_Roll_R", 4.0, 0, 1, 1, 1, 1, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /swata [1-8]");
	}
	return 1;
}

CMD:argue(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimationEx(playerid, "KISSING", "GF_StreetArgue_02", 4.0, 1, 1, 1, 1, 1, 1);
		case 2: ApplyAnimationEx(playerid, "KISSING", "GF_StreetArgue_01", 4.0, 1, 1, 1, 1, 1, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /argue [1-2]");
	}
	return 1;
}

CMD:presenta(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimationEx(playerid, "KISSING", "gift_get", 4.0, 0, 1, 1, 1, 1, 1);
		case 2: ApplyAnimationEx(playerid, "KISSING", "gift_give", 4.0, 0, 1, 1, 1, 1, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /presenta [1-2]");
	}
	return 1;
}

CMD:pool(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimationEx(playerid, "POOL", "POOL_ChalkCue", 4.0, 0, 1, 1, 1, 1, 1);
		case 2: ApplyAnimationEx(playerid, "POOL", "POOL_Long_Shot", 4.0, 0, 1, 1, 1, 1, 1);
		case 3: ApplyAnimationEx(playerid, "POOL", "POOL_Med_Shot", 4.0, 0, 1, 1, 1, 1, 1);
		case 4: ApplyAnimationEx(playerid, "POOL", "POOL_Short_Shot", 4.0, 0, 1, 1, 1, 1, 1);
		case 5: ApplyAnimationEx(playerid, "POOL", "POOL_XLong_Shot", 4.0, 0, 1, 1, 1, 1, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /pool [1-5]");
	}
	return 1;
}

CMD:basketball(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimationEx(playerid, "BSKTBALL", "BBALL_def_loop", 4.0, 1, 1, 1, 1, 1, 1);
		case 2: ApplyAnimationEx(playerid, "BSKTBALL", "BBALL_idleloop", 4.0, 1, 1, 1, 1, 1, 1);
		case 3: ApplyAnimationEx(playerid, "BSKTBALL", "BBALL_Jump_Shot", 4.0, 0, 1, 1, 1, 1, 1);
		case 4: ApplyAnimationEx(playerid, "BSKTBALL", "BBALL_pickup", 4.0, 0, 1, 1, 1, 1, 1);
		case 5: ApplyAnimationEx(playerid, "BSKTBALL", "BBALL_walk", 4.0, 1, 1, 1, 1, 1, 1);
		case 6: ApplyAnimationEx(playerid, "BSKTBALL", "BBALL_def_jump_shot", 4.0, 0, 1, 1, 1, 1, 1);
		case 7: ApplyAnimationEx(playerid, "BSKTBALL", "BBALL_run", 4.0, 1, 1, 1, 1, 1, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /basketball [1-7]");
	}
	return 1;
}

CMD:dive(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimationEx(playerid, "DODGE", "Crush_Jump", 4.0, 0, 1, 1, 1, 0, 1);
		case 2: ApplyAnimationEx(playerid, "PED", "EV_dive", 4.0, 0, 1, 1, 1, 0, 1);
		case 3: ApplyAnimationEx(playerid, "PED", "EV_step", 4.0, 0, 1, 1, 1, 0, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /dive [1-3]");
	}
	return 1;
}

CMD:getup(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimationEx(playerid, "PED", "getup", 4.0, 0, 0, 0, 0, 0, 1);
		case 2: ApplyAnimationEx(playerid, "PED", "getup_front", 4.0, 0, 0, 0, 0, 0, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /getup [1-2]");
	}
	return 1;
}

CMD:robbed(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return 1;
	switch(strval(params))
	{
		case 1: ApplyAnimationEx(playerid, "SHOP", "SHP_Rob_GiveCash", 4.0, 1, 0, 0, 0, 0, 1);
		case 2: ApplyAnimationEx(playerid, "SHOP", "SHP_Rob_React", 4.0, 0, 0, 0, 0, 0, 1);
		default: SendClientMessage(playerid, WHITE, "USAGE: /robbed [1-2]");
	}
	return 1;
}

CMD:what(playerid, params[])
{
	if(!IsAblePedAnimation(playerid)) return true;
	ApplyAnimationEx(playerid,"RIOT","RIOT_ANGRY", 4.0, 0, 0, 0, 0, 0, 1);
	return true;
}

ApplyAnimationEx(playerid, animlib[], animname[], Float:fDelta, loop, lockx, locky, freeze, time, forcesync)
{
	SetPVarInt(playerid, "LoopingAnim", 1);
	ApplyAnimation(playerid, animlib, animname, fDelta, loop, lockx, locky, freeze, time, forcesync);

	if(!GetPVarType(playerid, "AnimationHelper")) TextDrawShowForPlayer(playerid, AnimationHelper);
	return 1;
}

StopLoopingAnim(playerid)
{
	DeletePVar(playerid, "LoopingAnim");
    ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0, 1);
}

PreloadAnimLib(playerid, animlib[])
{
	ApplyAnimation(playerid, animlib, "null", 0.0, 0, 0, 0, 0, 0, 1);
}

IsAblePedAnimation(playerid)
{
    if(GetPVarType(playerid, "Cuffed") || GetPVarType(playerid, "Tasered") || GetPVarType(playerid, "Injured") || GetPVarType(playerid, "Frozen"))
    {
   		SendClientMessage(playerid, WHITE, "You can't do that at this time!");
   		return 0;
	}
    if(IsPlayerInAnyVehicle(playerid))
    {
		SendClientMessage(playerid, WHITE, "You must be outside of a vehicle to preform this animation.");
		return 0;
	}
	return 1;
}

IsAbleVehicleAnimation(playerid)
{
    if(GetPVarType(playerid, "Cuffed") || GetPVarType(playerid, "Tasered") || GetPVarType(playerid, "Injured") || GetPVarType(playerid, "Frozen")) 
    {
   		SendClientMessage(playerid, WHITE, "You can't do that at this time!");
   		return 0;
	}
	if(!IsPlayerInAnyVehicle(playerid))
    {
		SendClientMessage(playerid, WHITE, "You must be inside of a vehicle to preform this animation.");
		return 0;
	}
	return 1;
}

IsCLowrider(carid)
{
	new Cars[] = { 536, 575, 567 };

	for(new i = 0; i < sizeof(Cars); i++)
	{
		if(GetVehicleModel(carid) == Cars[i]) return 1;
	}
	return 0;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(GetPVarType(playerid, "LoopingAnim") && IsKeyJustDown(KEY_SPRINT,newkeys,oldkeys))
	{
	    StopLoopingAnim(playerid);
        TextDrawHideForPlayer(playerid, AnimationHelper);
    }
    return 1;
}

hook OnPlayerConnect(playerid)
{
	PreloadAnimLib(playerid,"AIRPORT");
	PreloadAnimLib(playerid,"Attractors");
	PreloadAnimLib(playerid,"BAR");
	PreloadAnimLib(playerid,"BASEBALL");
	PreloadAnimLib(playerid,"BD_FIRE");
	PreloadAnimLib(playerid,"benchpress");
    PreloadAnimLib(playerid,"BF_injection");
    PreloadAnimLib(playerid,"BIKED");
    PreloadAnimLib(playerid,"BIKEH");
    PreloadAnimLib(playerid,"BIKELEAP");
    PreloadAnimLib(playerid,"BIKES");
    PreloadAnimLib(playerid,"BIKEV");
    PreloadAnimLib(playerid,"BIKE_DBZ");
    PreloadAnimLib(playerid,"BMX");
    PreloadAnimLib(playerid,"BOX");
    PreloadAnimLib(playerid,"BSKTBALL");
    PreloadAnimLib(playerid,"BUDDY");
    PreloadAnimLib(playerid,"BUS");
    PreloadAnimLib(playerid,"CAMERA");
    PreloadAnimLib(playerid,"CAR");
    PreloadAnimLib(playerid,"CAR_CHAT");
    PreloadAnimLib(playerid,"CASINO");
    PreloadAnimLib(playerid,"CHAINSAW");
    PreloadAnimLib(playerid,"CHOPPA");
    PreloadAnimLib(playerid,"CLOTHES");
    PreloadAnimLib(playerid,"COACH");
    PreloadAnimLib(playerid,"COLT45");
    PreloadAnimLib(playerid,"COP_DVBYZ");
    PreloadAnimLib(playerid,"CRIB");
    PreloadAnimLib(playerid,"DAM_JUMP");
    PreloadAnimLib(playerid,"DANCING");
    PreloadAnimLib(playerid,"DILDO");
    PreloadAnimLib(playerid,"DODGE");
    PreloadAnimLib(playerid,"DOZER");
    PreloadAnimLib(playerid,"DRIVEBYS");
    PreloadAnimLib(playerid,"FAT");
    PreloadAnimLib(playerid,"FIGHT_B");
    PreloadAnimLib(playerid,"FIGHT_C");
    PreloadAnimLib(playerid,"FIGHT_D");
    PreloadAnimLib(playerid,"FIGHT_E");
    PreloadAnimLib(playerid,"FINALE");
    PreloadAnimLib(playerid,"FINALE2");
    PreloadAnimLib(playerid,"Flowers");
    PreloadAnimLib(playerid,"FOOD");
    PreloadAnimLib(playerid,"Freeweights");
    PreloadAnimLib(playerid,"GANGS");
    PreloadAnimLib(playerid,"GHANDS");
    PreloadAnimLib(playerid,"GHETTO_DB");
    PreloadAnimLib(playerid,"goggles");
    PreloadAnimLib(playerid,"GRAFFITI");
    PreloadAnimLib(playerid,"GRAVEYARD");
    PreloadAnimLib(playerid,"GRENADE");
    PreloadAnimLib(playerid,"GYMNASIUM");
    PreloadAnimLib(playerid,"HAIRCUTS");
    PreloadAnimLib(playerid,"HEIST9");
    PreloadAnimLib(playerid,"INT_HOUSE");
    PreloadAnimLib(playerid,"INT_OFFICE");
    PreloadAnimLib(playerid,"INT_SHOP");
    PreloadAnimLib(playerid,"JST_BUISNESS");
    PreloadAnimLib(playerid,"KART");
    PreloadAnimLib(playerid,"KISSING");
    PreloadAnimLib(playerid,"KNIFE");
    PreloadAnimLib(playerid,"LAPDAN1");
    PreloadAnimLib(playerid,"LAPDAN2");
    PreloadAnimLib(playerid,"LAPDAN3");
    PreloadAnimLib(playerid,"LOWRIDER");
    PreloadAnimLib(playerid,"MD_CHASE");
    PreloadAnimLib(playerid,"MEDIC");
    PreloadAnimLib(playerid,"MD_END");
    PreloadAnimLib(playerid,"MISC");
    PreloadAnimLib(playerid,"MTB");
    PreloadAnimLib(playerid,"MUSCULAR");
    PreloadAnimLib(playerid,"NEVADA");
    PreloadAnimLib(playerid,"ON_LOOKERS");
    PreloadAnimLib(playerid,"OTB");
    PreloadAnimLib(playerid,"PARACHUTE");
    PreloadAnimLib(playerid,"PARK");
    PreloadAnimLib(playerid,"PAULNMAC");
    PreloadAnimLib(playerid,"PED");
    PreloadAnimLib(playerid,"PLAYER_DVBYS");
    PreloadAnimLib(playerid,"PLAYIDLES");
    PreloadAnimLib(playerid,"POLICE");
    PreloadAnimLib(playerid,"POOL");
    PreloadAnimLib(playerid,"POOR");
    PreloadAnimLib(playerid,"PYTHON");
    PreloadAnimLib(playerid,"QUAD");
    PreloadAnimLib(playerid,"QUAD_DBZ");
    PreloadAnimLib(playerid,"RIFLE");
    PreloadAnimLib(playerid,"RIOT");
    PreloadAnimLib(playerid,"ROB_BANK");
    PreloadAnimLib(playerid,"ROCKET");
    PreloadAnimLib(playerid,"RUSTLER");
    PreloadAnimLib(playerid,"RYDER");
    PreloadAnimLib(playerid,"SCRATCHING");
    PreloadAnimLib(playerid,"SHAMAL");
    PreloadAnimLib(playerid,"SHOTGUN");
    PreloadAnimLib(playerid,"SILENCED");
    PreloadAnimLib(playerid,"SKATE");
    PreloadAnimLib(playerid,"SPRAYCAN");
    PreloadAnimLib(playerid,"STRIP");
    PreloadAnimLib(playerid,"SUNBATHE");
    PreloadAnimLib(playerid,"SWAT");
    PreloadAnimLib(playerid,"SWEET");
    PreloadAnimLib(playerid,"SWIM");
    PreloadAnimLib(playerid,"SWORD");
    PreloadAnimLib(playerid,"TANK");
    PreloadAnimLib(playerid,"TATTOOS");
    PreloadAnimLib(playerid,"TEC");
    PreloadAnimLib(playerid,"TRAIN");
    PreloadAnimLib(playerid,"TRUCK");
    PreloadAnimLib(playerid,"UZI");
    PreloadAnimLib(playerid,"VAN");
    PreloadAnimLib(playerid,"VENDING");
    PreloadAnimLib(playerid,"VORTEX");
    PreloadAnimLib(playerid,"WAYFARER");
    PreloadAnimLib(playerid,"WEAPONS");
    PreloadAnimLib(playerid,"WUZI");
    PreloadAnimLib(playerid,"SNM");
    PreloadAnimLib(playerid,"BLOWJOBZ");
    PreloadAnimLib(playerid,"SEX");
   	PreloadAnimLib(playerid,"BOMBER");
  	PreloadAnimLib(playerid,"RAPPING");
    PreloadAnimLib(playerid,"SHOP");
   	PreloadAnimLib(playerid,"BEACH");
   	PreloadAnimLib(playerid,"SMOKING");
    PreloadAnimLib(playerid,"FOOD");
    PreloadAnimLib(playerid,"ON_LOOKERS");
    PreloadAnimLib(playerid,"DEALER");
	PreloadAnimLib(playerid,"CRACK");
	PreloadAnimLib(playerid,"CARRY");
	PreloadAnimLib(playerid,"COP_AMBIENT");
	PreloadAnimLib(playerid,"PARK");
	PreloadAnimLib(playerid,"INT_HOUSE");
	PreloadAnimLib(playerid,"FOOD");
	return 1;
}