#include <YSI\y_hooks>

hook OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
	new Float:health, Float:armour, Float:addeddamage[2], Float:modifieddamage;
	GetPlayerHealth(playerid, health);
	GetPlayerArmour(playerid, armour);

	if(Player[issuerid][Taser] > 0 && weaponid == 23)
	{
		Array[0] = 0;
		if(GetPVarType(issuerid, "TaserReload") == 0)
		{
			if(IsPlayerNearPlayer(issuerid, playerid, 10.0))
			{
				SetPlayerHealthEx(playerid, health);
				SetPlayerArmourEx(playerid, armour);

				TogglePlayerControllableEx(playerid, FALSE);
				ClearAnimations(playerid);

				ApplyAnimation(playerid, "CRACK", "crckdeth2", 4.1, 0, 1, 1, 1, 1, 1);

				SetPVarInt(playerid, "Tasered", 1);
				SetPVarInt(issuerid, "TaserReload", 15);

				SetPlayerDrunkLevel(playerid, 99999999);
				SetTimerEx("TaserTimer", 15000, FALSE, "i", playerid);

				format(Array, sizeof(Array), "{FF8000}** {C2A2DA}%s fires their taser at %s, stunning them.", GetName(issuerid), GetName(playerid));
		    	SendNearbyMessage(playerid, Array, PURPLE, 30.0);
	    	}
	    	else
	    	{
	    		SetPlayerHealthEx(playerid, health);
				SetPlayerArmourEx(playerid, armour);

				SetPVarInt(issuerid, "TaserReload", 15);
	    		format(Array, sizeof(Array), "{FF8000}** {C2A2DA}%s fires their taser at %s, missing them.", GetName(issuerid), GetName(playerid));
		    	SendNearbyMessage(playerid, Array, PURPLE, 30.0);
	    	}
		}
		else
		{
			SetPlayerHealthEx(playerid, health);
			SetPlayerArmourEx(playerid, armour);
			format(Array, sizeof(Array), "Your taser is still reloading! (%d seconds.)", GetPVarInt(issuerid, "TaserReload"));
			SendClientMessage(issuerid, WHITE, Array);
		}
	}
	else
	{
		switch(weaponid)
		{
			case 14, 43, 47 .. 255: addeddamage[0] = 0.0;
			case 22, 23: addeddamage[0] = 20.0;
			case 30: addeddamage[0] = 20.0;
			case 31: addeddamage[0] = 15.0;
			default: addeddamage[0] = 0.0;
		}
		switch(bodypart)
		{
			case 3, 4: addeddamage[1] = 5.0;
			case 5 .. 8: addeddamage[1] = 2.0;
			case 9: addeddamage[1] = 15.0;
			default: addeddamage[1] = 0.0;
		}
		modifieddamage = addeddamage[0] + addeddamage[1];

		if(health <= 0) { SetPlayerHealthEx(playerid, 0); SetPlayerArmourEx(playerid, 0); }
		else if(health > 0 && armour == 0 || weaponid == 54) // Hasn't died, but has no armour. || or taking fall damage.
		{
			SetPlayerHealthEx(playerid, health - modifieddamage);
		}
		else if(health > 0 && armour > 0 && armour - modifieddamage > 0) // Still has armour after the damage is going to be given.
		{
			SetPlayerArmourEx(playerid, armour - modifieddamage);
		}
		else if(health > 0 && armour > 0 && armour - modifieddamage < 0) // Damage will be spread throughout health and armour.
		{
			new Float:tempfloat;
			tempfloat = modifieddamage - armour;

			SetPlayerArmourEx(playerid, 0);
			SetPlayerHealthEx(playerid, health - tempfloat);
		}
	}
	return 1;
}

hook OnPlayerDeath(playerid, killerid, reason)
{
	SetPlayerHealthEx(playerid, 0);
	SetPlayerArmourEx(playerid, 0);

	if(Player[playerid][Injured] == 0)
	{
		DeletePVar(playerid, "InAnimation");
		DeletePVar(playerid, "LoopingAnimation");
		TextDrawHideForPlayer(playerid, AnimationHelper);

		GetPlayerPos(playerid, Player[playerid][PosX], Player[playerid][PosY], Player[playerid][PosZ]);
		Player[playerid][Interior] = GetPlayerInterior(playerid);
		Player[playerid][VirtualWorld] = GetPlayerVirtualWorld(playerid);

		Player[playerid][Injured] = 1;
	}
	else if(Player[playerid][Injured] > 0) 
	{
		SetSpawnInfo(playerid, 0, Player[playerid][Skin], 1201.12, -1324, -80.0, 0.0, 0, 0, 0, 0, 0, 0);
		Player[playerid][Injured] = 4;
	}
	return 1;
}

hook OnPlayerSpawn(playerid)
{
	if(Player[playerid][Injured] == 4)
	{
		SetPlayerHealthEx(playerid, 50);
		Player[playerid][Injured] = 4;

		TogglePlayerControllableEx(playerid, FALSE);
		TextDrawHideForPlayer(playerid, LimboTextDraw);

		SetPlayerCameraPos(playerid, 1207.39, -1294.71, 24.61);
		SetPlayerCameraLookAt(playerid, 1181.72, -1322.65, 13.58);

		SetTimerEx("LimboTimer", 15000, FALSE, "i", playerid);
	}
	else if(Player[playerid][Injured] == 1)
	{
		SetPlayerHealthEx(playerid, 100);

		TogglePlayerSpectating(playerid, FALSE);
		Player[playerid][Injured] = 2;

		SetPlayerPosEx(playerid, Player[playerid][PosX], Player[playerid][PosY], Player[playerid][PosZ], 0.0, Player[playerid][Interior], Player[playerid][VirtualWorld]);
		SetPlayerSkin(playerid, Player[playerid][Skin]);

		if(Player[playerid][Interior] > 0) PrepareStream(playerid);

		ApplyAnimation(playerid, "PED", "KO_shot_stom", 4.0, 0, 1, 1, 1, 0, 1);
		TextDrawShowForPlayer(playerid, LimboTextDraw);

		SendClientMessage(playerid, WHITE, "The EMS have been informed of your location.");
		format(Array, sizeof(Array), "%s (%d) has been reported injured. Use /acceptpatient %d to accept the call.", GetName(playerid), playerid, playerid);
   		foreach(new i: Player) { if(Group[Player[i][PlayerGroup]][GroupType] == 3) SendClientMessage(i, Group[Player[playerid][PlayerGroup]][GroupColour] * 256 + 255, Array); }
		
		SetTimerEx("DeathTimer", 3500, FALSE, "i", playerid);		
	}
	return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
	switch(newstate)
	{
		case PLAYER_STATE_DRIVER:
		{
			SetPlayerArmedWeapon(playerid, 0);
		}
	}
	return 1;
}

forward DeathTimer(playerid);
public DeathTimer(playerid)
{
	if(Player[playerid][Injured] == 2)
	{
		new Float:health;
		GetPlayerHealth(playerid, health);

		if(IsPlayerInRangeOfPoint(playerid, 2.0, Player[playerid][PosX], Player[playerid][PosY], Player[playerid][PosZ]) && health > 2)
		{
			SetPlayerHealthEx(playerid, health - 1.0);

			SetTimerEx("DeathTimer", 3500, FALSE, "i", playerid);
		}
		else
		{
			Player[playerid][Injured] = 4;
			SetPlayerPosEx(playerid, 1201.12, -1324, -80.0, 0.0, 0, 0);
			TogglePlayerControllableEx(playerid, FALSE);

			SetPlayerCameraPos(playerid, 1207.39, -1294.71, 24.61);
			SetPlayerCameraLookAt(playerid, 1181.72, -1322.65, 13.58);

			SetPlayerHealthEx(playerid, 50.0);

			TextDrawHideForPlayer(playerid, LimboTextDraw);

			SetTimerEx("LimboTimer", 15000, FALSE, "i", playerid);
		}
	}
	return 1;
}

forward LimboTimer(playerid);
public LimboTimer(playerid)
{
	if(Player[playerid][Injured] == 4)
	{
		SendClientMessage(playerid, LIGHTRED, "You have been charged $1,000 for your stay. Have a nice day!");
		GiveMoneyEx(playerid, -1000);
		Player[playerid][Injured] = 0;
		TogglePlayerSpectating(playerid, FALSE);
		SetPlayerPosEx(playerid, 1176.7156, -1323.5863, 14.0350, 270.0, 0, 0);
		ResetPlayerWeaponsEx(playerid);
		TogglePlayerControllableEx(playerid, TRUE);
		SetPlayerHealthEx(playerid, 50.0);

		SetCameraBehindPlayer(playerid);
	}
	return 1;
}

GivePlayerWeaponEx(playerid, id, ammo = 99999)
{
	switch(id)
	{
		case 0, 1:
		{
			Player[playerid][Weapon][0] = id;
			GivePlayerWeapon(playerid, id, ammo);
		}
		case 2, 3, 4, 5, 6, 7, 8, 9:
		{
			Player[playerid][Weapon][1] = id;
			GivePlayerWeapon(playerid, id, ammo);
		}
		case 22, 23, 24:
		{
			Player[playerid][Weapon][2] = id;
			GivePlayerWeapon(playerid, id, ammo);
		}
		case 25, 26, 27:
		{
			Player[playerid][Weapon][3] = id;
			GivePlayerWeapon(playerid, id, ammo);
		}
		case 28, 29, 32:
		{
			Player[playerid][Weapon][4] = id;
			GivePlayerWeapon(playerid, id, ammo);
		}
		case 30, 31:
		{
			Player[playerid][Weapon][5] = id;
			GivePlayerWeapon(playerid, id, ammo);
		}
		case 33, 34:
		{
			Player[playerid][Weapon][6] = id;
			GivePlayerWeapon(playerid, id, ammo);
		}
		case 35, 36, 37, 38:
		{
			Player[playerid][Weapon][7] = id;
			GivePlayerWeapon(playerid, id, ammo);
		}
		case 16, 17, 18, 39, 40:
		{
			Player[playerid][Weapon][8] = id;
			GivePlayerWeapon(playerid, id, ammo);
		}
		case 41, 42, 43:
		{
			Player[playerid][Weapon][9] = id;
			GivePlayerWeapon(playerid, id, ammo);
		}
		case 10, 11, 12, 13, 14, 15:
		{
			Player[playerid][Weapon][10] = id;
			GivePlayerWeapon(playerid, id, ammo);
		}
		case 44, 45, 46:
		{
			Player[playerid][Weapon][11] = id;
			GivePlayerWeapon(playerid, id, ammo);
		}
	}
	return 1;
}

GivePlayerSavedWeapons(playerid) { for(new i; i < 12; i++) GivePlayerWeaponEx(playerid, Player[playerid][Weapon][i]); return 1; }
ResetPlayerWeaponsEx(playerid) { for(new i; i < 12; i++) Player[playerid][Weapon][i] = 0; ResetPlayerWeapons(playerid); return 1; }

GetWeaponNameEx(weaponid)
{
	new name[MAX_PLAYER_NAME];
	GetWeaponName(weaponid, name, sizeof(name));
	return name;
}

GetWeaponSlot(weaponid)
{
	new slot;
	switch(weaponid)
	{
		case 0, 1: slot = 0;
		case 2 .. 9: slot = 1;
		case 10 .. 15: slot = 10;
		case 16 .. 18, 39: slot = 8;
		case 22 .. 24: slot = 2;
		case 25 .. 27: slot = 3;
		case 28, 29, 32: slot = 4;
		case 30, 31: slot = 5;
		case 33, 34: slot = 6;
		case 35 .. 38: slot = 7;
		case 40: slot = 12;
		case 41 .. 43: slot = 9;
		case 44 .. 46: slot = 11;
	}
	return slot;
}