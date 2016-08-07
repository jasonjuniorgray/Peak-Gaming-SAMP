public OnPlayerRequestClass(playerid, classid)
{
	if(Player[playerid][Authenticated] == 0)
	{
		SetSpawnCameraPosition(playerid);
	}
	else
	{
		SetSpawnInfo(playerid, 0, Player[playerid][Skin], Player[playerid][PosX], Player[playerid][PosY], Player[playerid][PosZ], 0.0, 0, 0, 0, 0, 0, 0);
		SpawnPlayer(playerid);
	}
	return 1;
}

public OnPlayerConnect(playerid)
{
	SetPlayerColor(playerid, GREY);
    MySQLConnectPlayer(playerid);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	Array[0] = 0;
	switch(reason)
	{
		case 0: format(Array, sizeof(Array), "%s has left the server (timeout).", GetName(playerid));
		case 1: format(Array, sizeof(Array), "%s has left the server (leaving).", GetName(playerid));
		case 2: format(Array, sizeof(Array), "%s has left the server (kick/banned).", GetName(playerid));
	}
	SendNearbyMessage(playerid, Array, YELLOW, 15.0);

	for(new i; i < MAX_PLAYER_VEHICLES; i++) 
	{
		if(PlayerVehicle[playerid][CarModel][i] != 0) DestroyVehicle(PlayerVehicle[playerid][CarID][i]);
	}

	/*if(GetPVarInt(playerid, "OnPhone"))
	{
		foreach(new i: Player)
		{
			if(GetPVarInt(i, "OnPhone") == playerid || GetPVarInt(i, "Calling") == playerid) 
			{
				Array[0] = 0;
				format(Array, sizeof(Array), "%s puts away their cellphone.", GetName(playerid));
				SetPVarInt(i, "OnPhone", -1);
				SetPVarInt(i, "Calling", -1);
				SetPlayerChatBubble(i, Array, PURPLE, 15.0, 5000);
				SendClientMessage(i, GREY, "The other person has disconnected.");
			}
		}
	}*/
		
	SavePlayerData(playerid, 1);
	SavePlayerVehicleData(playerid);
	
	Player[playerid][Authenticated] = 0;
	return 1;
}

public OnPlayerSpawn(playerid)
{
	if(Player[playerid][Authenticated] == 0) Player[playerid][Authenticated] = 1;
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	new string[255];
	if(strfind(text, "|", true) != -1) return 0;

	/*if(GetPVarInt(playerid, "OnPhone") > -1)
	{
		format(string, sizeof(string), "(cellphone) %s says: %s", GetName(playerid), text);
		SetPlayerChatBubble(playerid, Array, WHITE, 15.0, 5000);
		SendClientMessage(playerid, WHITE, string);
		SendClientMessage(GetPVarInt(playerid, "OnPhone"), YELLOW, string);

		format(string, sizeof(string), "(cellphone) %s says to %s: %s", GetName(playerid), GetName(GetPVarInt(playerid, "OnPhone")), text);
		Log(8, Array);
	}
	else*/
	{
		format(string, sizeof(string), "(%s accent) %s says: %s", GetPlayerAccent(playerid), GetName(playerid), text);
		SendNearbyMessage(playerid, string, WHITE, 10.0);
	}

	DeletePVar(playerid, "LastTyped");
	return 0;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	return 0;
}

public OnPlayerCommandReceived(playerid, cmdtext[])
{
	Array[0] = 0;
	format(Array, sizeof(Array), "[zcmd] [%s] %s", GetName(playerid), cmdtext);
	printf("%s", Array);
	Log(0, Array);

	DeletePVar(playerid, "LastTyped");
	return 1;
}

public OnPlayerCommandPerformed(playerid, cmdtext[], success)
{
	if(!success) SendClientMessage(playerid, WHITE, "SERVER: Unknown command, please type /help for a list of commands.");
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnEnterExitModShop(playerid, enterexit, interiorid)
{
    switch(enterexit)
    {
    	case 0: // exit
    	{
    		if(IsPlayersVehicle(playerid, GetPlayerVehicleID(playerid)))
			{
				GetPlayerCarMods(playerid);
				SavePlayerVehicleData(playerid, GetPlayerVehicleSlot(playerid, GetPlayerVehicleID(playerid)));
			}
    	}
    }
    return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	if(IsPlayersVehicle(playerid, GetPlayerVehicleID(playerid)))
	{
		new id = IsPlayerInPersonalCar(playerid);
		PlayerVehicle[playerid][CarPaintJob][id] = paintjobid + 1;
	}
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	if(IsPlayersVehicle(playerid, GetPlayerVehicleID(playerid)))
	{
		new id = IsPlayerInPersonalCar(playerid);
		PlayerVehicle[playerid][CarColour][id] = color1;
		PlayerVehicle[playerid][CarColour2][id] = color2;
	}
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	DeletePVar(playerid, "LastTyped");
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

public SetPlayerPosEx(playerid, Float: X, Float: Y, Float: Z, Float: A, interior, virtualworld)
{
	if(IsPlayerInAnyVehicle(playerid))
	{
	    SetPlayerVirtualWorld(playerid, virtualworld);
	    SetPlayerInterior(playerid, interior);

		SetVehiclePos(GetPlayerVehicleID(playerid), X, Y, Z);
		SetVehicleVirtualWorld(GetPlayerVehicleID(playerid), virtualworld);
	    LinkVehicleToInterior(GetPlayerVehicleID(playerid), interior);
	    SetVehicleZAngle(GetPlayerVehicleID(playerid), A);
	    return 1;
	}
	else
	{
	    SetPlayerVirtualWorld(playerid, virtualworld);
	    SetPlayerInterior(playerid, interior);
	    SetPlayerPos(playerid, X, Y, Z);
	    SetPlayerFacingAngle(playerid, A);
	    return 1;
	}
}

public SendToAdmins(colour, string[], requireduty, requiredlevel)
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	  	if(IsPlayerConnectedEx(i))
	  	{
	  	    if(Player[i][AdminLevel] >= requiredlevel)
	  	    {
	  	        if(requireduty == 1 && Player[i][AdminDuty] == 1) // && Player[i][AFKStat] == 0)
	  	        {
	  	        	SendClientMessage(i, colour, string);
	  	        }
	  	        else if(requireduty == 0)
	  	        {
	  	            SendClientMessage(i, colour, string);
	  	        }
		   	}
		}
	}
	return 1;
}