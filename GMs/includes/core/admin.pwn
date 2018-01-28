CMD:ah(playerid, params[])
{
	#pragma unused params
	SendClientMessage(playerid, GREY, "---------------------------------------------------------------------------------------------------------------------------");

	if(Player[playerid][AdminLevel] == 0)
	{
		SendClientMessage(playerid, WHITE, "Administrators at Peak Gaming Roleplay are constantly working to improve the server experience for all players.");
		SendClientMessage(playerid, WHITE, "If you have a question, feel free to ask it in /n(ewbie) at any time. If you have an issue that can only be");
		SendClientMessage(playerid, WHITE, "resolved by an administrator, please use the /report command and we will assist you.");
	}

	if(Player[playerid][AdminLevel] >= 1)
	{
		SendClientMessage(playerid, WHITE, "Level 1 Administrator: /a(dmin), /go, /send, /goto, /get, /gotoco, /sendtoco, /sendto, /up, /dn, /lt, /rt, /fd, /bk");
		SendClientMessage(playerid, WHITE, "Level 1 Administrator: /reports, /a(ccept)r(eport), /c(lose)r(eport), /adminduty, /jetpack, /near, /revive");
		SendClientMessage(playerid, WHITE, "Level 1 Administrator: /freeze, /unfreeze, /spec(tate), /respawnvehicle, /respawnvehicles, /entercar");
	}

	if(Player[playerid][AdminLevel] >= 2)
	{
		SendClientMessage(playerid, GREY, "Level 2 Administrator: /vehiclenames, /veh, /afix, /anos, /ahyd");
	}

	if(Player[playerid][AdminLevel] >= 3)
	{
		SendClientMessage(playerid, WHITE, "Level 3 Administrator: /set, /jobskill, /agiveweapon, /destroyvehicles");
	}

	if(Player[playerid][AdminLevel] >= 4)
	{
	    SendClientMessage(playerid, GREY, "Level 4 Administrator: /makeleader, /clearchat");
	}

	if(Player[playerid][AdminLevel] >= 5)
	{
	    SendClientMessage(playerid, WHITE, "Level 5 Administrator: /makeadmin, /adminname, /lottery, /nexthouse, /edithouse, /createvehicle, /editvehicle, /evplate, /contracts");
	    SendClientMessage(playerid, WHITE, "Level 5 Administrator: /nextbusiness, /editbusiness, /businessname, /createdealershipvehicle, /editdealershipvehicle, /crimelist");
	    SendClientMessage(playerid, WHITE, "Level 5 Administrator: /nextdoor, /editdoor, /doorname, /nextarrest, /editarrest, /nextlocker, /editlocker, /editpoint, /editserver");
	}

	if(Player[playerid][AdminLevel] >= 6)
	{
	    SendClientMessage(playerid, GREY, "Level 6 Administrator: /gmx");
	}

	SendClientMessage(playerid, GREY, "---------------------------------------------------------------------------------------------------------------------------");
	return 1;
}

// MAKE ADMIN COMMANDS //

CMD:makeadmin(playerid, params[])
{
	new id, level, string[128];
	if(sscanf(params, "ud", id, level))
	{
	    if(Player[playerid][AdminLevel] >= 5)
	    {
			SendClientMessage(playerid, WHITE, "SYNTAX: /makeadmin [playerid] [level]");
		}
		else return SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
	}
	else
	{
	    if(Player[playerid][AdminLevel] >= 5)
	    {
	        if(Player[id][AdminLevel] == 0 && level >= 1)
	        {
                if(level >= Player[playerid][AdminLevel] && Player[playerid][AdminLevel] != 99999)
                {
                    SendClientMessage(playerid, WHITE, "You can only hire an admin to a lower level.");
                }
                else
                {
	                Player[id][AdminLevel] = level;
	                format(Player[playerid][AdminName], MAX_PLAYER_NAME, "None");
			        format(string, sizeof(string), "%s has been hired to admin level %d by %s.", GetName(id), level, GetName(playerid));
			        SendToAdmins(ORANGE, string, 0, 1);
		        }
            }
	        else if(level >= Player[playerid][AdminLevel])
    	    {
        	    SendClientMessage(playerid, WHITE, "You're unable to execute this action.");
        	}
        	else if(level >= Player[id][AdminLevel])
	    	{
	        	format(string, sizeof(string), "%s has been promoted to admin level %d by %s.", GetName(id), level, GetName(playerid));
	        	SendToAdmins(ORANGE, string, 0, 1);
	        	Player[id][AdminLevel] = level;
		    }
		    else if(level < 1)
		    {
		        format(string, sizeof(string), "%s has been removed from the admin team by %s.", GetName(id), GetName(playerid));
		        SendToAdmins(ORANGE, string, 0, 1);
		        Player[id][AdminLevel] = level;
		        Player[playerid][AdminDuty] = 0;
		    }
		    else if(level < Player[id][AdminLevel])
		    {
		        format(string, sizeof(string), "%s has been demoted to admin level %d by %s.", GetName(id), level, GetName(playerid));
		        SendToAdmins(ORANGE, string, 0, 1);
		        Player[id][AdminLevel] = level;
		    }

		    format(string, sizeof(string), "[/MAKEADMIN] %s.", string);
	    	Log(2, string);
		}
		else return SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
    }
	return 1;
}

CMD:makercadmin(playerid, params[])
{
	new id, level, string[128];
	if(sscanf(params, "ud", id, level))
	{
	    if(IsPlayerAdmin(playerid))
	    {
			SendClientMessage(playerid, WHITE, "SYNTAX: /makercadmin [playerid] [level]");
		}
		else return 0;
	}
	else
	{
	    if(IsPlayerAdmin(playerid))
	    {
	        Player[id][AdminLevel] = level;
			format(string, sizeof(string), "[RCON] %s has had their admin level changed to %d by %s.", GetName(id), level, GetName(playerid));
			SendToAdmins(ORANGE, string, 0, 1);

			format(Player[playerid][AdminName], MAX_PLAYER_NAME, "None");

			format(string, sizeof(string), "[/MAKERCADMIN] %s.", string);
	    	Log(2, string);
		}
		else return 0;
    }
	return 1;
}

// ADMIN LEVEL 1 COMMANDS //

CMD:a(playerid, params[]) { return cmd_admin(playerid, params); }

CMD:admin(playerid, params[])
{
	new Message[128], string[128];
	if(sscanf(params, "s[128]", Message))
	{
		if(Player[playerid][AdminLevel] >= 1)
	    {
			SendClientMessage(playerid, WHITE, "SYNTAX: /a(dmin) [message]");
		}
	}
	else
	{
		if(Player[playerid][AdminLevel] >= 1)
		{
		    format(string, sizeof(string), "[Admin] %s %s: %s", GetPlayerAdminLevel(playerid), GetName(playerid), Message);
	    	SendToAdmins(YELLOW, string, 0, 1);

	    	format(string, sizeof(string), "[/ADMIN] %s %s: %s", GetPlayerAdminLevel(playerid), GetName(playerid), Message);
	        Log(1, string);
		}
	}
	return 1;
}

CMD:go(playerid, params[])
{
    if(Player[playerid][AdminLevel] >= 1)
	{
		if(isnull(params))
		{
			SendClientMessage(playerid, WHITE, "USAGE: /go [location]");
			SendClientMessage(playerid, GREY, "Location: LS, SF, LV, RC, ElQue, Bayside, LSVIP, stadium1, stadium2, stadium3, stadium4");
			SendClientMessage(playerid, GREY, "Location: int1, sfairport, dillimore, cave, doc, bank, mall, allsaints, area69");
			SendClientMessage(playerid, GREY, "Location: countygen, cracklab, gym, rodeo, flint, idlewood, fbi, oocprison, air");
			return 1;
		}
		if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
		{
			SendClientMessage(playerid, WHITE, "You can not do this while spectating.");
			return 1;
		}
		if(strcmp(params,"air",true) == 0)
		{
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 816.5245,-1497.5740,632.5261);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);

			}
			else
			{
				SetPlayerPos(playerid, 816.5245,-1497.5740,632.5261);
			}
			SendClientMessage(playerid, WHITE, " You have successfully teleported Up In The Air! Staring Anna Kendrick!");
			SetPlayerInterior(playerid,0);
			Player[playerid][Interior] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			Player[playerid][VirtualWorld] = 0;
		}
		if(strcmp(params,"ls",true) == 0)
		{
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 1529.6,-1691.2,13.3);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(playerid, 1529.6,-1691.2,13.3);
			}
			SendClientMessage(playerid, WHITE, " You have successfully teleported to your desired location!");
			SetPlayerInterior(playerid,0);
			Player[playerid][Interior] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			Player[playerid][VirtualWorld] = 0;
		}
		if(strcmp(params,"oocprison",true) == 0)
		{
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 327.3283,653.3726,982.2977);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);

			}
			else
			{
				SetPlayerPos(playerid, 327.3283,653.3726,982.2977);
			}
			SendClientMessage(playerid, WHITE, " You have successfully teleported to your desired location!");
			SetPlayerInterior(playerid,1);
			Player[playerid][Interior] = 1;
			SetPlayerVirtualWorld(playerid, 1);
			Player[playerid][VirtualWorld] = 1;
			
			PrepareStream(playerid);
		}
		if(strcmp(params,"doc",true) == 0)
		{
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, -1039.4092,-578.2493,32.0078);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
			}
			else
			{
				SetPlayerPos(playerid, -1042.4764,-599.7729,32.0078);
			}
			SendClientMessage(playerid, WHITE, " You have successfully teleported to your desired location!");
			SetPlayerInterior(playerid,0);
			Player[playerid][Interior] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			Player[playerid][VirtualWorld] = 0;
			
		}
		else if(strcmp(params,"garagexlg",true) == 0)
		{
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar,1111.0139,1546.9510,5290.2793);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(playerid, 1111.0139,1546.9510,5290.2793);
			}
			SendClientMessage(playerid, WHITE, " You have successfully teleported to your desired location!");
			SetPlayerInterior(playerid,0);
			Player[playerid][Interior] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			Player[playerid][VirtualWorld] = 0;
		}
		else if(strcmp(params,"garagelg",true) == 0)
		{
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar,1192.8501,1540.0295,5290.2871);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(playerid, 1192.8501,1540.0295,5290.2871);
			}
			SendClientMessage(playerid, WHITE, " You have successfully teleported to your desired location!");
			SetPlayerInterior(playerid,0);
			Player[playerid][Interior] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			Player[playerid][VirtualWorld] = 0;
		}
		else if(strcmp(params,"garagemed",true) == 0)
		{
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar,1069.1473,1582.1029,5290.2529);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(playerid, 1069.1473,1582.1029,5290.2529);
			}
			SendClientMessage(playerid, WHITE, " You have successfully teleported to your desired location!");
			SetPlayerInterior(playerid,0);
			Player[playerid][Interior] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			Player[playerid][VirtualWorld] = 0;
		}
		else if(strcmp(params,"garagesm",true) == 0)
		{
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar,1198.1407,1589.2153,5290.2871);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(playerid, 1198.1407,1589.2153,5290.2871);
			}
			SendClientMessage(playerid, WHITE, " You have successfully teleported to your desired location!");
			SetPlayerInterior(playerid,0);
			Player[playerid][Interior] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			Player[playerid][VirtualWorld] = 0;
		}
		else if(strcmp(params,"cave",true) == 0)
		{
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, -1993.01, -1580.44, 86.39);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(playerid, -1993.01, -1580.44, 86.39);
			}
			SendClientMessage(playerid, WHITE, " You have successfully teleported to your desired location!");
			SetPlayerInterior(playerid,0);
			Player[playerid][Interior] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			Player[playerid][VirtualWorld] = 0;
		}
		else if(strcmp(params,"sfairport",true) == 0)
		{
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, -1412.5375,-301.8998,14.1411);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(playerid, -1412.5375,-301.8998,14.1411);
			}
			SendClientMessage(playerid, WHITE, " You have successfully teleported to your desired location!");
			SetPlayerInterior(playerid,0);
			Player[playerid][Interior] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			Player[playerid][VirtualWorld] = 0;
		}
		else if(strcmp(params,"sf",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, -1605.0,720.0,12.0);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(playerid, -1605.0,720.0,12.0);
			}
			SendClientMessage(playerid, WHITE, " You have successfully teleported to your desired location!");
			SetPlayerInterior(playerid,0);
			Player[playerid][Interior] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			Player[playerid][VirtualWorld] = 0;
		}
		else if(strcmp(params,"lv",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 1699.2, 1435.1, 10.7);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(playerid, 1699.2,1435.1, 10.7);
			}
			SendClientMessage(playerid, WHITE, " You have successfully teleported to your desired location!");
			SetPlayerInterior(playerid,0);
			Player[playerid][Interior] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			Player[playerid][VirtualWorld] = 0;

		}
		else if(strcmp(params,"island",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, -1081.0,4297.9,4.4);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(playerid, -1081.0,4297.9,4.4);
			}
			SendClientMessage(playerid, WHITE, " You have successfully teleported to your desired location!");
			SetPlayerInterior(playerid,0);
			Player[playerid][Interior] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			Player[playerid][VirtualWorld] = 0;

		}
		else if(strcmp(params,"cracklab",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 2348.2871, -1146.8298, 27.3183);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(playerid, 2348.2871, -1146.8298, 27.3183);
			}
			SendClientMessage(playerid, WHITE, " You have successfully teleported to your desired location!");
			SetPlayerInterior(playerid,0);
			Player[playerid][Interior] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			Player[playerid][VirtualWorld] = 0;

		}
		else if(strcmp(params,"bank",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 1487.91, -1030.60, 23.66);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(playerid, 1487.91, -1030.60, 23.66);
			}
			SendClientMessage(playerid, WHITE, " You have successfully teleported to your desired location!");
			SetPlayerInterior(playerid,0);
			Player[playerid][Interior] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			Player[playerid][VirtualWorld] = 0;

		}
		else if(strcmp(params,"allsaints",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 1192.78, -1292.68, 13.38);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(playerid, 1192.78, -1292.68, 13.38);
			}
			SendClientMessage(playerid, WHITE, " You have successfully teleported to your desired location!");
			SetPlayerInterior(playerid,0);
			Player[playerid][Interior] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			Player[playerid][VirtualWorld] = 0;

		}
		else if(strcmp(params,"countygen",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 2000.05, -1409.36, 16.99);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(playerid, 2000.05, -1409.36, 16.99);
			}
			SendClientMessage(playerid, WHITE, " You have successfully teleported to your desired location!");
			SetPlayerInterior(playerid,0);
			Player[playerid][Interior] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			Player[playerid][VirtualWorld] = 0;

		}
		else if(strcmp(params,"gym",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 2227.60, -1674.89, 14.62);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(playerid, 2227.60, -1674.89, 14.62);
			}
			SendClientMessage(playerid, WHITE, " You have successfully teleported to your desired location!");
			SetPlayerInterior(playerid,0);
			Player[playerid][Interior] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			Player[playerid][VirtualWorld] = 0;

   		}
		else if(strcmp(params,"fbi",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 344.77,-1526.08,33.28);
				
			}
			else
			{
				SetPlayerPos(playerid, 344.77,-1526.08,33.28);
			}
			SendClientMessage(playerid, WHITE, " You have successfully teleported to your desired location!");
			SetPlayerInterior(playerid,0);
			Player[playerid][Interior] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			Player[playerid][VirtualWorld] = 0;

		}
  		else if(strcmp(params,"rc",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 1253.70, 343.73, 19.41);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(playerid, 1253.70, 343.73, 19.41);
			}
			SendClientMessage(playerid, WHITE, " You have successfully teleported to your desired location!");
			SetPlayerInterior(playerid,0);
			Player[playerid][Interior] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			Player[playerid][VirtualWorld] = 0;

   		}
     	else if(strcmp(params,"lsvip",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 1810.39, -1601.15, 13.54);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(playerid, 1810.39, -1601.15, 13.54);
			}
			SendClientMessage(playerid, WHITE, " You have successfully teleported to your desired location!");
			SetPlayerInterior(playerid,0);
			Player[playerid][Interior] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			Player[playerid][VirtualWorld] = 0;
		}
		else if(strcmp(params,"area69",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 112.67, 1917.55, 18.72);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(playerid, 112.67, 1917.55, 18.72);
			}
			SendClientMessage(playerid, WHITE, " You have successfully teleported to your desired location!");
			SetPlayerInterior(playerid,0);
			Player[playerid][Interior] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			Player[playerid][VirtualWorld] = 0;

		}
		else if(strcmp(params,"stadium1",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, -1424.93, -664.59, 1059.86);
				LinkVehicleToInterior(tmpcar, 4);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(playerid, -1424.93, -664.59, 1059.86);
			}
			SendClientMessage(playerid, WHITE, " You have successfully teleported to your desired location!");
			SetPlayerInterior(playerid,4);
			Player[playerid][Interior] = 4;
			SetPlayerVirtualWorld(playerid, 0);
			Player[playerid][VirtualWorld] = 0;

		}
		else if(strcmp(params,"stadium2",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, -1395.96, -208.20, 1051.28);
				LinkVehicleToInterior(tmpcar, 7);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(playerid, -1395.96, -208.20, 1051.28);
			}
			SendClientMessage(playerid, WHITE, " You have successfully teleported to your desired location!");
			SetPlayerInterior(playerid,7);
			Player[playerid][Interior] = 7;
			SetPlayerVirtualWorld(playerid, 0);
			Player[playerid][VirtualWorld] = 0;

		}
		else if(strcmp(params,"stadium3",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, -1410.72, 1591.16, 1052.53);
				LinkVehicleToInterior(tmpcar, 14);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(playerid, -1410.72, 1591.16, 1052.53);
			}
			SendClientMessage(playerid, WHITE, " You have successfully teleported to your desired location!");
			SetPlayerInterior(playerid,14);
			Player[playerid][Interior] = 14;
			SetPlayerVirtualWorld(playerid, 0);
			Player[playerid][VirtualWorld] = 0;

		}
		else if(strcmp(params,"stadium4",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, -1394.20, 987.62, 1023.96);
				LinkVehicleToInterior(tmpcar, 15);
				SetVehicleVirtualWorld(tmpcar, 0);
				
    		}
			else
			{
				SetPlayerPos(playerid, -1394.20, 987.62, 1023.96);
			}
			SendClientMessage(playerid, WHITE, " You have successfully teleported to your desired location!");
			SetPlayerInterior(playerid,15);
			Player[playerid][Interior] = 15;
			SetPlayerVirtualWorld(playerid, 0);
			Player[playerid][VirtualWorld] = 0;

		}
		else if(strcmp(params,"int1",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 1416.107000,0.268620,1000.926000);
				LinkVehicleToInterior(tmpcar, 1);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(playerid, 1416.107000,0.268620,1000.926000);
			}
			SendClientMessage(playerid, WHITE, " You have successfully teleported to your desired location!");
			SetPlayerInterior(playerid,1);
			Player[playerid][Interior] = 1;
			SetPlayerVirtualWorld(playerid, 0);
			Player[playerid][VirtualWorld] = 0;

		}
		else if(strcmp(params,"mall",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 1133.71,-1464.52,15.77);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(playerid, 1133.71,-1464.52,15.77);
			}
			SendClientMessage(playerid, WHITE, " You have successfully teleported to your desired location!");
			SetPlayerInterior(playerid,0);
			Player[playerid][Interior] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			Player[playerid][VirtualWorld] = 0;

		}
		else if(strcmp(params,"elque",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, -1446.5997,2608.4478,55.8359);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(playerid, -1446.5997,2608.4478,55.8359);
			}
			SendClientMessage(playerid, WHITE, " You have successfully teleported to your desired location!");
			SetPlayerInterior(playerid,0);
			Player[playerid][Interior] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			Player[playerid][VirtualWorld] = 0;

		}
		else if(strcmp(params,"bayside",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, -2465.1348,2333.6572,4.8359);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(playerid, -2465.1348,2333.6572,4.8359);
			}
			SendClientMessage(playerid, WHITE, " You have successfully teleported to your desired location!");
			SetPlayerInterior(playerid,0);
			Player[playerid][Interior] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			Player[playerid][VirtualWorld] = 0;

		}
		else if(strcmp(params,"dillimore",true) == 0)
		{
		 	if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 634.9734, -594.6402, 16.3359);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(playerid, 634.9734, -594.6402, 16.3359);
			}
			SendClientMessage(playerid, WHITE, " You have successfully teleported to your desired location!");
			SetPlayerInterior(playerid,0);
			Player[playerid][Interior] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			Player[playerid][VirtualWorld] = 0;
		}
		else if(strcmp(params,"rodeo",true) == 0)
		{
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 587.0106,-1238.3374,17.8049);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(playerid, 587.0106,-1238.3374,17.8049);
			}
			SendClientMessage(playerid, WHITE, " You have successfully teleported to your desired location!");
			SetPlayerInterior(playerid,0);
			Player[playerid][Interior] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			Player[playerid][VirtualWorld] = 0;
		}
		else if(strcmp(params,"flint",true) == 0)
		{
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, -108.1058,-1172.5293,2.8906);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(playerid, -108.1058,-1172.5293,2.8906);
			}
			SendClientMessage(playerid, WHITE, " You have successfully teleported to your desired location!");
			SetPlayerInterior(playerid,0);
			Player[playerid][Interior] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			Player[playerid][VirtualWorld] = 0;
		}
		else if(strcmp(params,"idlewood",true) == 0)
		{
			if (GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, 1955.1357,-1796.8896,13.5469);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(playerid, 1955.1357,-1796.8896,13.5469);
			}
			SendClientMessage(playerid, WHITE, " You have successfully teleported to your desired location!");
			SetPlayerInterior(playerid,0);
			Player[playerid][Interior] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			Player[playerid][VirtualWorld] = 0;
		}
		Player[playerid][InsideBusiness] = 0;
	}
	else SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
	return 1;
}

CMD:send(playerid, params[])
{
	new id, location[50], string[128];
    if(Player[playerid][AdminLevel] >= 1)
	{
		if(sscanf(params, "us", id, location))
		{
			SendClientMessage(playerid, WHITE, "USAGE: /send [playerid] [location]");
			SendClientMessage(playerid, GREY, "Locations 1: LS, SF, LV, RC, ElQue, Bayside, LSVIP, stadium1, stadium2, stadium3, stadium4");
			SendClientMessage(playerid, GREY, "Locations 2: int1, sfairport, dillimore, cave, doc, bank, mall, allsaints, area69");
			SendClientMessage(playerid, GREY, "Locations 3: countygen, cracklab, gym, rodeo, flint, idlewood, fbi, oocprison, air");
			return 1;
		}
		if(GetPlayerState(id) == PLAYER_STATE_SPECTATING)
		{
			SendClientMessage(id, WHITE, "You can not do this while they're spectating.");
			return 1;
		}
		if(strcmp(location,"air",true) == 0)
		{
			if (GetPlayerState(id) == 2)
			{
				new tmpcar = GetPlayerVehicleID(id);
				SetVehiclePos(tmpcar, 816.5245,-1497.5740,632.5261);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);

			}
			else
			{
				SetPlayerPos(id, 816.5245,-1497.5740,632.5261);
			}
			SetPlayerInterior(id,0);
			Player[id][Interior] = 0;
			SetPlayerVirtualWorld(id, 0);
			Player[id][VirtualWorld] = 0;
		}
		if(strcmp(location,"ls",true) == 0)
		{
			if (GetPlayerState(id) == 2)
			{
				new tmpcar = GetPlayerVehicleID(id);
				SetVehiclePos(tmpcar, 1529.6,-1691.2,13.3);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(id, 1529.6,-1691.2,13.3);
			}
			SetPlayerInterior(id,0);
			Player[id][Interior] = 0;
			SetPlayerVirtualWorld(id, 0);
			Player[id][VirtualWorld] = 0;
		}
		if(strcmp(location,"oocprison",true) == 0)
		{
			if (GetPlayerState(id) == 2)
			{
				new tmpcar = GetPlayerVehicleID(id);
				SetVehiclePos(tmpcar, 327.3283,653.3726,982.2977);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);

			}
			else
			{
				SetPlayerPos(id, 327.3283,653.3726,982.2977);
			}
			SetPlayerInterior(id,1);
			Player[id][Interior] = 1;
			SetPlayerVirtualWorld(id, 1);
			Player[id][VirtualWorld] = 1;
			
			PrepareStream(id);
		}
		if(strcmp(location,"doc",true) == 0)
		{
			if (GetPlayerState(id) == 2)
			{
				new tmpcar = GetPlayerVehicleID(id);
				SetVehiclePos(tmpcar, -1039.4092,-578.2493,32.0078);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
			}
			else
			{
				SetPlayerPos(id, -1042.4764,-599.7729,32.0078);
			}
			SetPlayerInterior(id,0);
			Player[id][Interior] = 0;
			SetPlayerVirtualWorld(id, 0);
			Player[id][VirtualWorld] = 0;
			
		}
		else if(strcmp(location,"garagexlg",true) == 0)
		{
			if (GetPlayerState(id) == 2)
			{
				new tmpcar = GetPlayerVehicleID(id);
				SetVehiclePos(tmpcar,1111.0139,1546.9510,5290.2793);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(id, 1111.0139,1546.9510,5290.2793);
			}
			SetPlayerInterior(id,0);
			Player[id][Interior] = 0;
			SetPlayerVirtualWorld(id, 0);
			Player[id][VirtualWorld] = 0;
		}
		else if(strcmp(location,"garagelg",true) == 0)
		{
			if (GetPlayerState(id) == 2)
			{
				new tmpcar = GetPlayerVehicleID(id);
				SetVehiclePos(tmpcar,1192.8501,1540.0295,5290.2871);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(id, 1192.8501,1540.0295,5290.2871);
			}
			SetPlayerInterior(id,0);
			Player[id][Interior] = 0;
			SetPlayerVirtualWorld(id, 0);
			Player[id][VirtualWorld] = 0;
		}
		else if(strcmp(location,"garagemed",true) == 0)
		{
			if (GetPlayerState(id) == 2)
			{
				new tmpcar = GetPlayerVehicleID(id);
				SetVehiclePos(tmpcar,1069.1473,1582.1029,5290.2529);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(id, 1069.1473,1582.1029,5290.2529);
			}
			SetPlayerInterior(id,0);
			Player[id][Interior] = 0;
			SetPlayerVirtualWorld(id, 0);
			Player[id][VirtualWorld] = 0;
		}
		else if(strcmp(location,"garagesm",true) == 0)
		{
			if (GetPlayerState(id) == 2)
			{
				new tmpcar = GetPlayerVehicleID(id);
				SetVehiclePos(tmpcar,1198.1407,1589.2153,5290.2871);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(id, 1198.1407,1589.2153,5290.2871);
			}

			SetPlayerInterior(id,0);
			Player[id][Interior] = 0;
			SetPlayerVirtualWorld(id, 0);
			Player[id][VirtualWorld] = 0;
		}
		else if(strcmp(location,"cave",true) == 0)
		{
			if (GetPlayerState(id) == 2)
			{
				new tmpcar = GetPlayerVehicleID(id);
				SetVehiclePos(tmpcar, -1993.01, -1580.44, 86.39);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(id, -1993.01, -1580.44, 86.39);
			}

			SetPlayerInterior(id,0);
			Player[id][Interior] = 0;
			SetPlayerVirtualWorld(id, 0);
			Player[id][VirtualWorld] = 0;
		}
		else if(strcmp(location,"sfairport",true) == 0)
		{
			if (GetPlayerState(id) == 2)
			{
				new tmpcar = GetPlayerVehicleID(id);
				SetVehiclePos(tmpcar, -1412.5375,-301.8998,14.1411);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(id, -1412.5375,-301.8998,14.1411);
			}

			SetPlayerInterior(id,0);
			Player[id][Interior] = 0;
			SetPlayerVirtualWorld(id, 0);
			Player[id][VirtualWorld] = 0;
		}
		else if(strcmp(location,"sf",true) == 0)
		{
		 	if (GetPlayerState(id) == 2)
			{
				new tmpcar = GetPlayerVehicleID(id);
				SetVehiclePos(tmpcar, -1605.0,720.0,12.0);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(id, -1605.0,720.0,12.0);
			}

			SetPlayerInterior(id,0);
			Player[id][Interior] = 0;
			SetPlayerVirtualWorld(id, 0);
			Player[id][VirtualWorld] = 0;
		}
		else if(strcmp(location,"lv",true) == 0)
		{
		 	if (GetPlayerState(id) == 2)
			{
				new tmpcar = GetPlayerVehicleID(id);
				SetVehiclePos(tmpcar, 1699.2, 1435.1, 10.7);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(id, 1699.2,1435.1, 10.7);
			}

			SetPlayerInterior(id,0);
			Player[id][Interior] = 0;
			SetPlayerVirtualWorld(id, 0);
			Player[id][VirtualWorld] = 0;

		}
		else if(strcmp(location,"island",true) == 0)
		{
		 	if (GetPlayerState(id) == 2)
			{
				new tmpcar = GetPlayerVehicleID(id);
				SetVehiclePos(tmpcar, -1081.0,4297.9,4.4);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(id, -1081.0,4297.9,4.4);
			}

			SetPlayerInterior(id,0);
			Player[id][Interior] = 0;
			SetPlayerVirtualWorld(id, 0);
			Player[id][VirtualWorld] = 0;

		}
		else if(strcmp(location,"cracklab",true) == 0)
		{
		 	if (GetPlayerState(id) == 2)
			{
				new tmpcar = GetPlayerVehicleID(id);
				SetVehiclePos(tmpcar, 2348.2871, -1146.8298, 27.3183);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(id, 2348.2871, -1146.8298, 27.3183);
			}

			SetPlayerInterior(id,0);
			Player[id][Interior] = 0;
			SetPlayerVirtualWorld(id, 0);
			Player[id][VirtualWorld] = 0;

		}
		else if(strcmp(location,"bank",true) == 0)
		{
		 	if (GetPlayerState(id) == 2)
			{
				new tmpcar = GetPlayerVehicleID(id);
				SetVehiclePos(tmpcar, 1487.91, -1030.60, 23.66);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(id, 1487.91, -1030.60, 23.66);
			}

			SetPlayerInterior(id,0);
			Player[id][Interior] = 0;
			SetPlayerVirtualWorld(id, 0);
			Player[id][VirtualWorld] = 0;

		}
		else if(strcmp(location,"allsaints",true) == 0)
		{
		 	if (GetPlayerState(id) == 2)
			{
				new tmpcar = GetPlayerVehicleID(id);
				SetVehiclePos(tmpcar, 1192.78, -1292.68, 13.38);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(id, 1192.78, -1292.68, 13.38);
			}

			SetPlayerInterior(id,0);
			Player[id][Interior] = 0;
			SetPlayerVirtualWorld(id, 0);
			Player[id][VirtualWorld] = 0;

		}
		else if(strcmp(location,"countygen",true) == 0)
		{
		 	if (GetPlayerState(id) == 2)
			{
				new tmpcar = GetPlayerVehicleID(id);
				SetVehiclePos(tmpcar, 2000.05, -1409.36, 16.99);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(id, 2000.05, -1409.36, 16.99);
			}

			SetPlayerInterior(id,0);
			Player[id][Interior] = 0;
			SetPlayerVirtualWorld(id, 0);
			Player[id][VirtualWorld] = 0;

		}
		else if(strcmp(location,"gym",true) == 0)
		{
		 	if (GetPlayerState(id) == 2)
			{
				new tmpcar = GetPlayerVehicleID(id);
				SetVehiclePos(tmpcar, 2227.60, -1674.89, 14.62);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(id, 2227.60, -1674.89, 14.62);
			}

			SetPlayerInterior(id,0);
			Player[id][Interior] = 0;
			SetPlayerVirtualWorld(id, 0);
			Player[id][VirtualWorld] = 0;

   		}
		else if(strcmp(location,"fbi",true) == 0)
		{
		 	if (GetPlayerState(id) == 2)
			{
				new tmpcar = GetPlayerVehicleID(id);
				SetVehiclePos(tmpcar, 344.77,-1526.08,33.28);
				
			}
			else
			{
				SetPlayerPos(id, 344.77,-1526.08,33.28);
			}

			SetPlayerInterior(id,0);
			Player[id][Interior] = 0;
			SetPlayerVirtualWorld(id, 0);
			Player[id][VirtualWorld] = 0;

		}
  		else if(strcmp(location,"rc",true) == 0)
		{
		 	if (GetPlayerState(id) == 2)
			{
				new tmpcar = GetPlayerVehicleID(id);
				SetVehiclePos(tmpcar, 1253.70, 343.73, 19.41);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(id, 1253.70, 343.73, 19.41);
			}

			SetPlayerInterior(id,0);
			Player[id][Interior] = 0;
			SetPlayerVirtualWorld(id, 0);
			Player[id][VirtualWorld] = 0;

   		}
     	else if(strcmp(location,"lsvip",true) == 0)
		{
		 	if (GetPlayerState(id) == 2)
			{
				new tmpcar = GetPlayerVehicleID(id);
				SetVehiclePos(tmpcar, 1810.39, -1601.15, 13.54);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(id, 1810.39, -1601.15, 13.54);
			}

			SetPlayerInterior(id,0);
			Player[id][Interior] = 0;
			SetPlayerVirtualWorld(id, 0);
			Player[id][VirtualWorld] = 0;
		}
		else if(strcmp(location,"area69",true) == 0)
		{
		 	if (GetPlayerState(id) == 2)
			{
				new tmpcar = GetPlayerVehicleID(id);
				SetVehiclePos(tmpcar, 112.67, 1917.55, 18.72);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(id, 112.67, 1917.55, 18.72);
			}

			SetPlayerInterior(id,0);
			Player[id][Interior] = 0;
			SetPlayerVirtualWorld(id, 0);
			Player[id][VirtualWorld] = 0;

		}
		else if(strcmp(location,"stadium1",true) == 0)
		{
		 	if (GetPlayerState(id) == 2)
			{
				new tmpcar = GetPlayerVehicleID(id);
				SetVehiclePos(tmpcar, -1424.93, -664.59, 1059.86);
				LinkVehicleToInterior(tmpcar, 4);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(id, -1424.93, -664.59, 1059.86);
			}

			SetPlayerInterior(id,4);
			Player[id][Interior] = 4;
			SetPlayerVirtualWorld(id, 0);
			Player[id][VirtualWorld] = 0;

		}
		else if(strcmp(location,"stadium2",true) == 0)
		{
		 	if (GetPlayerState(id) == 2)
			{
				new tmpcar = GetPlayerVehicleID(id);
				SetVehiclePos(tmpcar, -1395.96, -208.20, 1051.28);
				LinkVehicleToInterior(tmpcar, 7);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(id, -1395.96, -208.20, 1051.28);
			}

			SetPlayerInterior(id,7);
			Player[id][Interior] = 7;
			SetPlayerVirtualWorld(id, 0);
			Player[id][VirtualWorld] = 0;

		}
		else if(strcmp(location,"stadium3",true) == 0)
		{
		 	if (GetPlayerState(id) == 2)
			{
				new tmpcar = GetPlayerVehicleID(id);
				SetVehiclePos(tmpcar, -1410.72, 1591.16, 1052.53);
				LinkVehicleToInterior(tmpcar, 14);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(id, -1410.72, 1591.16, 1052.53);
			}

			SetPlayerInterior(id,14);
			Player[id][Interior] = 14;
			SetPlayerVirtualWorld(id, 0);
			Player[id][VirtualWorld] = 0;

		}
		else if(strcmp(location,"stadium4",true) == 0)
		{
		 	if (GetPlayerState(id) == 2)
			{
				new tmpcar = GetPlayerVehicleID(id);
				SetVehiclePos(tmpcar, -1394.20, 987.62, 1023.96);
				LinkVehicleToInterior(tmpcar, 15);
				SetVehicleVirtualWorld(tmpcar, 0);
				
    		}
			else
			{
				SetPlayerPos(id, -1394.20, 987.62, 1023.96);
			}

			SetPlayerInterior(id,15);
			Player[id][Interior] = 15;
			SetPlayerVirtualWorld(id, 0);
			Player[id][VirtualWorld] = 0;

		}
		else if(strcmp(location,"int1",true) == 0)
		{
		 	if (GetPlayerState(id) == 2)
			{
				new tmpcar = GetPlayerVehicleID(id);
				SetVehiclePos(tmpcar, 1416.107000,0.268620,1000.926000);
				LinkVehicleToInterior(tmpcar, 1);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(id, 1416.107000,0.268620,1000.926000);
			}

			SetPlayerInterior(id,1);
			Player[id][Interior] = 1;
			SetPlayerVirtualWorld(id, 0);
			Player[id][VirtualWorld] = 0;

		}
		else if(strcmp(location,"mall",true) == 0)
		{
		 	if (GetPlayerState(id) == 2)
			{
				new tmpcar = GetPlayerVehicleID(id);
				SetVehiclePos(tmpcar, 1133.71,-1464.52,15.77);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(id, 1133.71,-1464.52,15.77);
			}

			SetPlayerInterior(id,0);
			Player[id][Interior] = 0;
			SetPlayerVirtualWorld(id, 0);
			Player[id][VirtualWorld] = 0;

		}
		else if(strcmp(location,"elque",true) == 0)
		{
		 	if (GetPlayerState(id) == 2)
			{
				new tmpcar = GetPlayerVehicleID(id);
				SetVehiclePos(tmpcar, -1446.5997,2608.4478,55.8359);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(id, -1446.5997,2608.4478,55.8359);
			}

			SetPlayerInterior(id,0);
			Player[id][Interior] = 0;
			SetPlayerVirtualWorld(id, 0);
			Player[id][VirtualWorld] = 0;

		}
		else if(strcmp(location,"bayside",true) == 0)
		{
		 	if (GetPlayerState(id) == 2)
			{
				new tmpcar = GetPlayerVehicleID(id);
				SetVehiclePos(tmpcar, -2465.1348,2333.6572,4.8359);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(id, -2465.1348,2333.6572,4.8359);
			}

			SetPlayerInterior(id,0);
			Player[id][Interior] = 0;
			SetPlayerVirtualWorld(id, 0);
			Player[id][VirtualWorld] = 0;

		}
		else if(strcmp(location,"dillimore",true) == 0)
		{
		 	if (GetPlayerState(id) == 2)
			{
				new tmpcar = GetPlayerVehicleID(id);
				SetVehiclePos(tmpcar, 634.9734, -594.6402, 16.3359);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(id, 634.9734, -594.6402, 16.3359);
			}

			SetPlayerInterior(id,0);
			Player[id][Interior] = 0;
			SetPlayerVirtualWorld(id, 0);
			Player[id][VirtualWorld] = 0;
		}
		else if(strcmp(location,"rodeo",true) == 0)
		{
			if (GetPlayerState(id) == 2)
			{
				new tmpcar = GetPlayerVehicleID(id);
				SetVehiclePos(tmpcar, 587.0106,-1238.3374,17.8049);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(id, 587.0106,-1238.3374,17.8049);
			}

			SetPlayerInterior(id,0);
			Player[id][Interior] = 0;
			SetPlayerVirtualWorld(id, 0);
			Player[id][VirtualWorld] = 0;
		}
		else if(strcmp(location,"flint",true) == 0)
		{
			if (GetPlayerState(id) == 2)
			{
				new tmpcar = GetPlayerVehicleID(id);
				SetVehiclePos(tmpcar, -108.1058,-1172.5293,2.8906);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(id, -108.1058,-1172.5293,2.8906);
			}

			SetPlayerInterior(id,0);
			Player[id][Interior] = 0;
			SetPlayerVirtualWorld(id, 0);
			Player[id][VirtualWorld] = 0;
		}
		else if(strcmp(location,"idlewood",true) == 0)
		{
			if (GetPlayerState(id) == 2)
			{
				new tmpcar = GetPlayerVehicleID(id);
				SetVehiclePos(tmpcar, 1955.1357,-1796.8896,13.5469);
				LinkVehicleToInterior(tmpcar, 0);
				SetVehicleVirtualWorld(tmpcar, 0);
				
			}
			else
			{
				SetPlayerPos(id, 1955.1357,-1796.8896,13.5469);
			}

			SetPlayerInterior(id,0);
			Player[id][Interior] = 0;
			SetPlayerVirtualWorld(id, 0);
			Player[id][VirtualWorld] = 0;
		}

		format(string, sizeof(string), "You have teleported %s to your desired location.", GetName(id));
		SendClientMessage(playerid, WHITE, string);
		format(string, sizeof(string), "You have been teleported by administrator %s.", GetName(playerid));
		SendClientMessage(id, GREY, string);

		Player[playerid][InsideBusiness] = 0;

		format(string, sizeof(string), "[/SEND] %s has sent %s to (%s).", GetName(playerid), GetName(id), location);
	    Log(1, string);
	}
	else SendClientMessage(id, WHITE, "You are not authorized to preform this command.");
	return 1;
}

CMD:goto(playerid, params[])
{
	new id, string[128], Float: X, Float: Y, Float: Z, Float: A;
	if(sscanf(params, "u", id))
	{
	    if(Player[playerid][AdminLevel] >= 1)
	    {
			SendClientMessage(playerid, WHITE, "SYNTAX: /goto [playerid]");
		}
		else return SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
	}
	else
	{
		if(Player[playerid][AdminLevel] >= 1)
		{
		    if(IsPlayerConnectedEx(id))
		    {
				//else
				{
					GetPlayerPos(id, X, Y, Z);
					GetPlayerFacingAngle(id, A);
					SetPlayerPosEx(playerid, X, Y, Z, A, GetPlayerInterior(id), GetPlayerVirtualWorld(id));
					format(string, sizeof(string), "You have teleported to %s.", GetName(id));
					SendClientMessage(playerid, WHITE, string);
					Player[playerid][InsideBusiness] = -1;
				}
		    }
		    else
		    {
		        SendClientMessage(playerid, WHITE, "That player is not connected or isn't logged in.");
		    }
		}
		else return SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
	}
	return 1;
}

CMD:sendto(playerid, params[])
{
	new id, id2, string[128], Float: X, Float: Y, Float: Z, Float: A;
	if(sscanf(params, "uu", id, id2))
	{
	    if(Player[playerid][AdminLevel] >= 1)
	    {
			SendClientMessage(playerid, WHITE, "SYNTAX: /sendto [playerid] [destination id]");
		}
		else return SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
	}
	else
	{
		if(Player[playerid][AdminLevel] >= 1)
		{
		    if(IsPlayerConnectedEx(id) && IsPlayerConnectedEx(playerid))
		    {
				//else
				{
					GetPlayerPos(id2, X, Y, Z);
					GetPlayerFacingAngle(id2, A);
					SetPlayerPosEx(playerid, X, Y, Z, A, GetPlayerInterior(id2), GetPlayerVirtualWorld(id2));
					format(string, sizeof(string), "You have teleported %s to %s.", GetName(id), GetName(id2));
					SendClientMessage(playerid, WHITE, string);

					format(string, sizeof(string), "[/SENDTO] %s has sent %s to %s.", GetName(playerid), GetName(id), GetName(id2));
	    			Log(1, string);
				}
		    }
		    else
		    {
		        SendClientMessage(playerid, WHITE, "That player is not connected or isn't logged in.");
		    }
		}
		else return SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
	}
	return 1;
}

CMD:get(playerid, params[])
{
	new id, string[128], Float: X, Float: Y, Float: Z, Float: A;
	if(sscanf(params, "u", id))
	{
	    if(Player[playerid][AdminLevel] >= 1)
	    {
			SendClientMessage(playerid, WHITE, "SYNTAX: /get [playerid]");
		}
		else return SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
	}
	else
	{
		if(Player[playerid][AdminLevel] >= 1)
		{
		    if(IsPlayerConnectedEx(id))
		    {
				//else
				{
					GetPlayerPos(playerid, X, Y, Z);
					GetPlayerFacingAngle(playerid, A);
					SetPlayerPosEx(id, X, Y, Z, A, GetPlayerInterior(id), GetPlayerVirtualWorld(id));
					format(string, sizeof(string), "You have teleported %s to you.", GetName(id));
					SendClientMessage(playerid, WHITE, string);
					Player[playerid][InsideBusiness] = -1;
				}
		    }
		    else
		    {
		        SendClientMessage(playerid, WHITE, "That player is not connected or isn't logged in.");
		    }
		}
		else return SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
	}
	return 1;
}

CMD:gotoco(playerid, params[])
{
	new pInterior, pVirtualWorld, Float: X, Float: Y, Float: Z, string[256];
	if(sscanf(params, "fffd", X, Y, Z, pInterior, pVirtualWorld))
	{
	    if(Player[playerid][AdminLevel] >= 1)
	    {
			SendClientMessage(playerid, WHITE, "SYNTAX: /gotoco [x point] [y point] [z point] [interior] [virtual world]");
		}
		else return SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
	}
	else
	{
		if(Player[playerid][AdminLevel] >= 1)
		{
		    SetPlayerPosEx(playerid, X, Y, Z, 0, pInterior, pVirtualWorld);

		    format(string, sizeof(string), "You have teleported to X: %f Y: %f Z: %f Int: %d VW: %d.",  X, Y, Z, pInterior, pVirtualWorld);
	        SendClientMessage(playerid, WHITE, string);
		}
		else return SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
	}
	return 1;
}

CMD:sendtoco(playerid, params[])
{
	new id, pInterior, pVirtualWorld, Float: X, Float: Y, Float: Z, string[256];
	if(sscanf(params, "ufffd", id, X, Y, Z, pInterior, pVirtualWorld))
	{
	    if(Player[playerid][AdminLevel] >= 1)
	    {
			SendClientMessage(playerid, WHITE, "SYNTAX: /sendtoco [player] [x point] [y point] [z point] [interior] [virtual world]");
		}
		else return SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
	}
	else
	{
		if(Player[playerid][AdminLevel] >= 1)
		{
		    SetPlayerPosEx(id, X, Y, Z, 0, pInterior, pVirtualWorld);

		    format(string, sizeof(string), "You have teleported %s to X: %f Y: %f Z: %f Int: %d VW: %d.", GetName(id), X, Y, Z, pInterior, pVirtualWorld);
	        SendClientMessage(playerid, WHITE, string);
	        format(string, sizeof(string), "You have been teleported by administrator %s.", GetName(id));
	        SendClientMessage(id, GREY, string);

	        format(string, sizeof(string), "[/SENDTOCO] %s has sent %s to X: %f Y: %f Z: %f Int: %d VW: %d.", GetName(playerid), GetName(id), X, Y, Z, pInterior, pVirtualWorld);
	    	Log(1, string);
		}
		else return SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
	}
	return 1;
}

CMD:near(playerid, params[])
{
	new Usage[50], Float:radius;
	if(sscanf(params, "s[128]F(30.0)", Usage, radius))
	{
	    if(Player[playerid][AdminLevel] >= 1)
	    {
		    SendClientMessage(playerid, WHITE, "SYNTAX: /near [usage] [(optional) radius]");
			SendClientMessage(playerid, GREY, "Usages: Players, Houses, Businesses, Doors, Gates, Jobs, Arrests, Lockers");
			return 1;
		}
	}
	else if(Player[playerid][AdminLevel] >= 1)
	{
		Array[0] = 0;
		if(strcmp(Usage, "Players", true) == 0)
       	{
    		for(new i = 0; i < MAX_PLAYERS; i++)
    		{
    			new Float:Pos[3];
    			GetPlayerPos(i, Pos[0], Pos[1], Pos[2]);

        		new Float:distance = GetPlayerDistanceFromPoint(playerid, Pos[0], Pos[1], Pos[2]);
        		if(IsPlayerInRangeOfPoint(playerid, radius, Pos[0], Pos[1], Pos[2]))
        		{
            		format(Array, sizeof(Array), "Player ID: %d | VW: %d | Int: %d | Distance: %0.1f", i, GetPlayerVirtualWorld(i), GetPlayerInterior(i), distance);
            		SendClientMessage(playerid, WHITE, Array);
        		}
        	}
		}
		if(strcmp(Usage, "Houses", true) == 0)
       	{
    		for(new i = 0; i < MAX_HOUSES; i++)
    		{
        		new Float:distance = GetPlayerDistanceFromPoint(playerid, House[i][HousePos][0], House[i][HousePos][1], House[i][HousePos][2]);
        		if(IsPlayerInRangeOfPoint(playerid, radius, House[i][HousePos][0], House[i][HousePos][1], House[i][HousePos][2]))
        		{
            		format(Array, sizeof(Array), "House ID: %d | VW: %d | Int: %d | Distance: %0.1f", i, House[i][HouseVW][0], House[i][HouseInt][0], distance);
            		SendClientMessage(playerid, WHITE, Array);
        		}

                distance = GetPlayerDistanceFromPoint(playerid, House[i][HousePos][4], House[i][HousePos][5], House[i][HousePos][6]);
                if(IsPlayerInRangeOfPoint(playerid, radius, House[i][HousePos][4], House[i][HousePos][5], House[i][HousePos][6]))
                {
                    format(Array, sizeof(Array), "(int) House ID: %d | VW: %d | Int: %d | Distance: %0.1f", i, House[i][HouseVW][1], House[i][HouseInt][1], distance);
                    SendClientMessage(playerid, WHITE, Array);
                }
        	}
		}
		if(strcmp(Usage, "Businesses", true) == 0)
       	{
    		for(new i = 0; i < MAX_BUSINESSES; i++)
    		{
        		new Float:distance = GetPlayerDistanceFromPoint(playerid, Business[i][BizPos][0], Business[i][BizPos][1], Business[i][BizPos][2]);
        		if(IsPlayerInRangeOfPoint(playerid, radius, Business[i][BizPos][0], Business[i][BizPos][1], Business[i][BizPos][2]))
        		{
            		format(Array, sizeof(Array), "Business ID: %d | VW: %d | Int: %d | Distance: %0.1f", i, Business[i][BizVW][0], Business[i][BizInt][0], distance);
            		SendClientMessage(playerid, WHITE, Array);
        		}

                distance = GetPlayerDistanceFromPoint(playerid, Business[i][BizPos][4], Business[i][BizPos][5], Business[i][BizPos][6]);
                if(IsPlayerInRangeOfPoint(playerid, radius, Business[i][BizPos][4], Business[i][BizPos][5], Business[i][BizPos][6]))
                {
                    format(Array, sizeof(Array), "(int) Business ID: %d | VW: %d | Int: %d | Distance: %0.1f", i, Business[i][BizVW][1], Business[i][BizInt][1], distance);
                    SendClientMessage(playerid, WHITE, Array);
                }
        	}
		}
        if(strcmp(Usage, "Doors", true) == 0)
        {
            for(new i = 0; i < MAX_BUSINESSES; i++)
            {
                new Float:distance = GetPlayerDistanceFromPoint(playerid, Door[i][DoorPos][0], Door[i][DoorPos][1], Door[i][DoorPos][2]);
                if(IsPlayerInRangeOfPoint(playerid, radius, Door[i][DoorPos][0], Door[i][DoorPos][1], Door[i][DoorPos][2]))
                {
                    format(Array, sizeof(Array), "Door ID: %d | VW: %d | Int: %d | Distance: %0.1f", i, Door[i][DoorVW][0], Door[i][DoorInt][0], distance);
                    SendClientMessage(playerid, WHITE, Array);
                }

                distance = GetPlayerDistanceFromPoint(playerid, Door[i][DoorPos][4], Door[i][DoorPos][5], Door[i][DoorPos][6]);
                if(IsPlayerInRangeOfPoint(playerid, radius, Door[i][DoorPos][4], Door[i][DoorPos][5], Door[i][DoorPos][6]))
                {
                    format(Array, sizeof(Array), "(int) Door ID: %d | VW: %d | Int: %d | Distance: %0.1f", i, Door[i][DoorVW][1], Door[i][DoorInt][1], distance);
                    SendClientMessage(playerid, WHITE, Array);
                }
            }
        }
	    if(strcmp(Usage, "Gates", true) == 0)
       	{
    		for(new i = 0; i < MAX_GATES; i++)
    		{
        		new Float:distance = GetPlayerDistanceFromPoint(playerid, Gate[i][GatePos][0], Gate[i][GatePos][1], Gate[i][GatePos][2]);
        		if(IsPlayerInRangeOfPoint(playerid, radius, Gate[i][GatePos][0], Gate[i][GatePos][1], Gate[i][GatePos][2]))
        		{
            		format(Array, sizeof(Array), "Gate ID: %d | VW: %d | Int: %d | Distance: %0.1f", i, Gate[i][GateVW], Gate[i][GateInt], distance);
            		SendClientMessage(playerid, WHITE, Array);
        		}
        	}
		}
		if(strcmp(Usage, "Jobs", true) == 0)
       	{
    		for(new i = 0; i < MAX_JOBS; i++)
    		{
        		new Float:distance = GetPlayerDistanceFromPoint(playerid, Job[i][JobPos][0], Job[i][JobPos][1], Job[i][JobPos][2]);
        		if(IsPlayerInRangeOfPoint(playerid, radius, Job[i][JobPos][0], Job[i][JobPos][1], Job[i][JobPos][2]))
        		{
            		format(Array, sizeof(Array), "Job ID: %d | VW: 0 | Int: 0 | Distance: %0.1f", i, distance);
            		SendClientMessage(playerid, WHITE, Array);
        		}
        	}
		}
        if(strcmp(Usage, "Arrests", true) == 0)
        {
            for(new i = 0; i < MAX_ARRESTPOINTS; i++)
            {
                new Float:distance = GetPlayerDistanceFromPoint(playerid, Arrest[i][ArrestPos][0], Arrest[i][ArrestPos][1], Arrest[i][ArrestPos][2]);
                if(IsPlayerInRangeOfPoint(playerid, radius, Arrest[i][ArrestPos][0], Arrest[i][ArrestPos][1], Arrest[i][ArrestPos][2]))
                {
                    format(Array, sizeof(Array), "Arrest ID: %d | VW: %d | Int: %d | Distance: %0.1f", i, Arrest[i][ArrestVW], Arrest[i][ArrestInt], distance);
                    SendClientMessage(playerid, WHITE, Array);
                }
            }
        }
        if(strcmp(Usage, "Points", true) == 0)
        {
            for(new i = 0; i < MAX_POINTS; i++)
            {
                new Float:distance = GetPlayerDistanceFromPoint(playerid, Point[i][poPos][0], Point[i][poPos][1], Point[i][poPos][2]);
                if(IsPlayerInRangeOfPoint(playerid, radius, Point[i][poPos][0], Point[i][poPos][1], Point[i][poPos][2]))
                {
                    format(Array, sizeof(Array), "Point ID: %d | VW: %d | Int: ? | Distance: %0.1f", i, Point[i][pointVW], distance);
                    SendClientMessage(playerid, WHITE, Array);
                }
            }
        }
        if(strcmp(Usage, "Lockers", true) == 0)
        {
            for(new i = 0; i < MAX_LOCKERS; i++)
            {
                new Float:distance = GetPlayerDistanceFromPoint(playerid, Locker[i][LockerPos][0], Locker[i][LockerPos][1], Locker[i][LockerPos][2]);
                if(IsPlayerInRangeOfPoint(playerid, radius, Locker[i][LockerPos][0], Locker[i][LockerPos][1], Locker[i][LockerPos][2]))
                {
                    format(Array, sizeof(Array), "Locker ID: %d | VW: %d | Int: %d | Distance: %0.1f", i, Locker[i][LockerVW], Locker[i][LockerInt], distance);
                    SendClientMessage(playerid, WHITE, Array);
                }
            }
        }
	}
	return 1;
}

CMD:revive(playerid, params[])
{
	new id;
	if(sscanf(params, "u", id))
	{
	    if(Player[playerid][AdminLevel] >= 1)
	    {
		    return SendClientMessage(playerid, WHITE, "SYNTAX: /revive [playerid]");
		}
	}
	else if(Player[playerid][AdminLevel] >= 1)
	{
		if(Player[id][Injured] == 2 || Player[id][Injured] == 3)
		{
			Array[0] = 0;
			ClearAnimations(id, 1);
			Player[id][Injured] = 0;
			SetPlayerHealthEx(id, 100);
			TextDrawHideForPlayer(id, LimboTextDraw);

			GivePlayerSavedWeapons(id);

			format(Array, sizeof(Array), "You have revived %s.", GetName(id));
            SendClientMessage(playerid, WHITE, Array);
            format(Array, sizeof(Array), "You have been revived by %s %s.", GetPlayerAdminLevel(playerid), GetName(playerid));
            SendClientMessage(id, WHITE, Array);

            format(Array, sizeof(Array), "[/REVIVE] %s has been revived by %s %s.", GetName(id), GetPlayerAdminLevel(playerid), GetName(playerid));
            Log(1, Array);
		}
		else if(Player[id][Injured] == 4)
		{
			Array[0] = 0;
			Player[id][Injured] = 0;
			TogglePlayerSpectating(id, FALSE);
			SetPlayerPosEx(id, 1176.7156, -1323.5863, 14.0350, 270.0, 0, 0);
			GivePlayerSavedWeapons(id);
			TogglePlayerControllableEx(id, TRUE);
			SetCameraBehindPlayer(id);
			TextDrawHideForPlayer(id, LimboTextDraw);

			format(Array, sizeof(Array), "You have released %s from the hospital.", GetName(id));
            SendClientMessage(playerid, WHITE, Array);
            format(Array, sizeof(Array), "You have been released from the hospital by %s %s.", GetPlayerAdminLevel(playerid), GetName(playerid));
            SendClientMessage(id, WHITE, Array);

            format(Array, sizeof(Array), "[/REVIVE] %s has been released from the hopsital by %s %s.", GetName(id), GetPlayerAdminLevel(playerid), GetName(playerid));
            Log(1, Array);
		}
	}
	return 1;
}

CMD:up(playerid, params[])
{
    if(Player[playerid][AdminLevel] >= 1)
	{
        new Float:slx, Float:sly, Float:slz;
        GetPlayerPos(playerid, slx, sly, slz);
		if (GetPlayerState(playerid) == 2)
		{
			new tmpcar = GetPlayerVehicleID(playerid);
			SetVehiclePos(tmpcar, slx, sly, slz+5);
		}
		else
		{
			SetPlayerPos(playerid, slx, sly, slz+5);
		}
        return 1;
    }
    else
	{
        SendClientMessage(playerid, WHITE, "You are not authorized to preform this command");
    }
    return 1;
}

CMD:dn(playerid, params[])
{
    if(Player[playerid][AdminLevel] >= 1)
	{
        new Float:slx, Float:sly, Float:slz;
		GetPlayerPos(playerid, slx, sly, slz);
		if (GetPlayerState(playerid) == 2)
		{
			new tmpcar = GetPlayerVehicleID(playerid);
			SetVehiclePos(tmpcar, slx, sly, slz-2);
		}
		else
		{
			SetPlayerPos(playerid, slx, sly, slz-2);
		}
        return 1;
    }
    else
	{
        SendClientMessage(playerid, WHITE, "You are not authorized to preform this command");
    }
    return 1;
}

CMD:lt(playerid, params[])
{
    if(Player[playerid][AdminLevel] >= 1)
	{
        new Float:slx, Float:sly, Float:slz;
        GetPlayerPos(playerid, slx, sly, slz);
		if (GetPlayerState(playerid) == 2)
		{
			new tmpcar = GetPlayerVehicleID(playerid);
			SetVehiclePos(tmpcar, slx-2, sly, slz);
		}
		else
		{
			SetPlayerPos(playerid, slx-2, sly, slz);
		}
        return 1;
    }
    else
	{
        SendClientMessage(playerid, WHITE, "You are not authorized to preform this command");
    }
    return 1;
}

CMD:rt(playerid, params[])
{
    if(Player[playerid][AdminLevel] >= 1)
	{
        new Float:slx, Float:sly, Float:slz;
        GetPlayerPos(playerid, slx, sly, slz);
		if (GetPlayerState(playerid) == 2)
		{
			new tmpcar = GetPlayerVehicleID(playerid);
			SetVehiclePos(tmpcar, slx+2, sly, slz);
		}
		else
		{
			SetPlayerPos(playerid, slx+2, sly, slz);
		}
        return 1;
    }
    else
	{
        SendClientMessage(playerid, WHITE, "You are not authorized to preform this command");
    }
    return 1;
}

CMD:fd(playerid, params[])
{
    if(Player[playerid][AdminLevel] >= 1)
	{
        new Float:slx, Float:sly, Float:slz;
        GetPlayerPos(playerid, slx, sly, slz);
		if (GetPlayerState(playerid) == 2)
		{
			new tmpcar = GetPlayerVehicleID(playerid);
			SetVehiclePos(tmpcar, slx, sly+2, slz);
		}
		else
		{
			SetPlayerPos(playerid, slx, sly+2, slz);
		}
        return 1;
    }
    else
	{
        SendClientMessage(playerid, WHITE, "You are not authorized to preform this command");
    }
    return 1;
}

CMD:bk(playerid, params[])
{
    if(Player[playerid][AdminLevel] >= 1)
	{
        new Float:slx, Float:sly, Float:slz;
        GetPlayerPos(playerid, slx, sly, slz);
		if (GetPlayerState(playerid) == 2)
		{
			new tmpcar = GetPlayerVehicleID(playerid);
			SetVehiclePos(tmpcar, slx, sly-2, slz);
		}
		else
		{
			SetPlayerPos(playerid, slx, sly-2, slz);
		}
        return 1;
    }
    else
	{
        SendClientMessage(playerid, WHITE, "You are not authorized to preform this command");
    }
    return 1;
}

CMD:ar(playerid, params[]) { return cmd_acceptreport(playerid, params); }
CMD:acceptreport(playerid, params[])
{
	new id;
	if(sscanf(params, "u", id))
    {
	    if(Player[playerid][AdminLevel] >= 1)
	    {
	    	SendClientMessage(playerid, WHITE, "SYNTAX: /a(ceept)r(eport) [id]");
	    }
	    else return SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
	}
	else
	{
		if(Player[playerid][AdminLevel] >= 1)
		{
			if(Reports[id][Used] >= 1 && IsPlayerConnectedEx(Reports[id][Reporter]))
			{
				if(Reports[id][CheckingReport] == -1)
				{
					Array[0] = 0;
					Reports[id][CheckingReport] = playerid;

					format(Array, sizeof(Array), "%s %s has taken your report. Please note this could take a while to resolve.", GetPlayerAdminLevel(playerid), GetName(playerid));
					SendClientMessage(Reports[id][Reporter], ORANGE, Array);
					SendClientMessage(Reports[id][Reporter], WHITE, "You can use /pm to communicate with the admin who accepted your report.");
					format(Array, sizeof(Array), "%s %s has taken the report from %s (%d - RID: %d).", GetPlayerAdminLevel(playerid), GetName(playerid), GetName(Reports[id][Reporter]), Reports[id][Reporter], id);
					SendToAdmins(ORANGE, Array, 1, 1);

					format(Array, sizeof(Array), "[/ACCEPTREPORT] %s has accepted RID %d from %s [%s].", GetName(playerid), Reports[id][Reporter], GetName(Reports[id][Reporter]), Reports[id][Report]);
	    			Log(1, Array);
				}
				else return SendClientMessage(playerid, WHITE, "Another administrator is already looking at this report!");
			}
			else return SendClientMessage(playerid, WHITE, "The reporter has either logged off or this report is not being used.");
		}
		else return SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
	}
	return 1;
}

CMD:cr(playerid, params[]) { return cmd_closereport(playerid, params); }
CMD:closereport(playerid, params[])
{
	new id;
	if(sscanf(params, "u", id))
    {
	    if(Player[playerid][AdminLevel] >= 1)
	    {
	    	SendClientMessage(playerid, WHITE, "SYNTAX: /c(lose)r(eport) [id]");
	    }
	    else return SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
	}
	else
	{
		if(Player[playerid][AdminLevel] >= 1)
		{
			if(Reports[id][Used] >= 1)
			{
				Array[0] = 0;
				if(Reports[id][CheckingReport] == -1)
				{
					format(Array, sizeof(Array), "%s %s has closed your report. Please keep mindful to report for releveant issues only.", GetPlayerAdminLevel(playerid), GetName(playerid));
					SendClientMessage(Reports[id][Reporter], ORANGE, Array);
					format(Array, sizeof(Array), "%s %s has trashed the report from %s (%d - RID: %d).", GetPlayerAdminLevel(playerid), GetName(playerid), GetName(Reports[id][Reporter]), Reports[id][Reporter], id);
					SendToAdmins(ORANGE, Array, 1, 1);

					format(Array, sizeof(Array), "[/CLOSEREPORT] %s has trashed RID %d from %s [%s].", GetName(playerid), Reports[id][Reporter], GetName(Reports[id][Reporter]), Reports[id][Report]);
	    			Log(1, Array);

	    			DeletePVar(Reports[id][Reporter], "ReportActive");
				}
				else
				{
					format(Array, sizeof(Array), "%s %s has closed your report. We hope your issue was resolved to the best of our abilities!", GetPlayerAdminLevel(playerid), GetName(playerid));
					SendClientMessage(Reports[id][Reporter], ORANGE, Array);
					format(Array, sizeof(Array), "%s %s has closed the report from %s (%d - RID: %d).", GetPlayerAdminLevel(playerid), GetName(playerid), GetName(Reports[id][Reporter]), Reports[id][Reporter], id);
					SendToAdmins(ORANGE, Array, 1, 1);

					format(Array, sizeof(Array), "[/CLOSEREPORT] %s has closed RID %d from %s [%s].", GetName(playerid), Reports[id][Reporter], GetName(Reports[id][Reporter]), Reports[id][Report]);
	    			Log(1, Array);

	    			DeletePVar(Reports[id][Reporter], "ReportActive");
				}
				ClearReport(id);
			}
			else return SendClientMessage(playerid, WHITE, "This report is not being used.");
		}
		else return SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
	}
	return 1;
}

CMD:adminduty(playerid, params[])
{
	if(Player[playerid][AdminLevel] >= 1)
	{
		Array[0] = 0;
		if(Player[playerid][AdminDuty] >= 1)
		{
			Player[playerid][AdminDuty] = 0;

			SetPlayerPos(playerid, Player[playerid][PosX], Player[playerid][PosY], Player[playerid][PosZ]);
			SetPlayerFacingAngle(playerid, Player[playerid][PosA]);
			SetPlayerSkin(playerid, Player[playerid][Skin]);
			SetPlayerName(playerid, Player[playerid][Username]);

			SendClientMessage(playerid, WHITE, "You have went off administration duty.");
			format(Array, sizeof(Array), "%s %s (%s) has went off administration duty.", GetPlayerAdminLevel(playerid), Player[playerid][AdminName], Player[playerid][Username]);
			SendToAdmins(ORANGE, Array, 1, 1);
		}
		else
		{
			Player[playerid][AdminDuty] = 1;

			SetPlayerSkin(playerid, Player[playerid][AdminSkin]);
			SetPlayerName(playerid, Player[playerid][AdminName]);

			if(Player[playerid][AdminLevel] <= 4) 
			{
				SendClientMessage(playerid, WHITE, "Please note: any changes made to your account from this point until you are off admin duty will not save.");
			}

			GetPlayerPos(playerid, Player[playerid][PosX], Player[playerid][PosY], Player[playerid][PosZ]);
			GetPlayerFacingAngle(playerid, Player[playerid][PosA]);

			format(Array, sizeof(Array), "%s %s (%s) has went on administration duty.", GetPlayerAdminLevel(playerid), Player[playerid][AdminName], Player[playerid][Username]);
			SendToAdmins(ORANGE, Array, 1, 1);
		}
	}
	else SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
	return 1;
}

CMD:freeze(playerid, params[])
{
	new id, string[128];
    if(sscanf(params, "u", id))
    {
	    if(Player[playerid][AdminLevel] >= 1)
	    {
	    	SendClientMessage(playerid, WHITE, "SYNTAX: /freeze [playerid]");
	    }
	    else return SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
	}
	else
	{
		if(Player[playerid][AdminLevel] >= 1)
		{
			if(IsPlayerConnectedEx(id))
			{
				TogglePlayerControllableEx(playerid, FALSE);

				format(string, sizeof(string), "You have frozen %s.", GetName(id));
	    		SendClientMessage(playerid, WHITE, string);

	    		format(string, sizeof(string), "[/FREEZE] %s has frozen %s.", GetName(playerid), GetName(id));
	    		Log(1, string);
	    	}
	    	else return SendClientMessage(playerid, WHITE, "This player is not connected.");
	    }
	    else return SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
	}
	return 1;
}

CMD:unfreeze(playerid, params[])
{
	new id, string[128];
    if(sscanf(params, "u", id))
    {
	    if(Player[playerid][AdminLevel] >= 1)
	    {
	    	SendClientMessage(playerid, WHITE, "SYNTAX: /unfreeze [playerid]");
	    }
	    else return SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
	}
	else
	{
		if(Player[playerid][AdminLevel] >= 1)
		{
			if(IsPlayerConnectedEx(id))
			{
				TogglePlayerControllableEx(playerid, TRUE);

				format(string, sizeof(string), "You have unfrozen %s.", GetName(id));
	    		SendClientMessage(playerid, WHITE, string);

	    		format(string, sizeof(string), "[/UNFREEZE] %s has unfrozen %s.", GetName(playerid), GetName(id));
	    		Log(1, string);
	    	}
	    	else return SendClientMessage(playerid, WHITE, "This player is not connected.");
	    }
	    else return SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
	}
	return 1;
}

CMD:spec(playerid, params[])
{
	if(Player[playerid][AdminLevel] < 1)
	{
		return SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
	}

	Array[0] = 0;

	if(strcmp(params, "off", true) == 0)
	{
		if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING && Player[playerid][AdminLevel] >= 1)
		{
			TogglePlayerSpectating(playerid, FALSE);
			SetCameraBehindPlayer(playerid);

			format(Array, sizeof(Array), "[/SPEC] %s has stopped spectating.", GetName(playerid));
	    	Log(1, Array);
			return 1;
		}
		else
		{
			SendClientMessage(playerid, WHITE, "You're not spectating anyone.");
			return 1;
		}
	}

	new id;

	if(sscanf(params, "u", id)) return SendClientMessage(playerid, GREY, "USAGE: /spec (playerid/off)");
	if(id == playerid) return SendClientMessage(playerid, WHITE, "You cannot spectate yourself.");
	if(IsPlayerConnectedEx(id))
	{
		SpectatePlayer(playerid, id);

		format(Array, sizeof(Array), "[/SPEC] %s has started spectating %s.", GetName(playerid), GetName(id));
	    Log(1, Array);
	}
	else
	{
		SendClientMessage(playerid, WHITE, "This player is not logged in.");
	}
	return 1;
}

CMD:respawnvehicle(playerid, params[])
{
    new id;
    if(sscanf(params, "d", id) && !IsPlayerInAnyVehicle(playerid)) 
    {
        if(Player[playerid][AdminLevel] >= 1)
        {
            return SendClientMessage(playerid, WHITE, "USAGE: /respawnvehicle [id]");
        }
        else return SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
    }
    else if(Player[playerid][AdminLevel] >= 1)
    {
    	if(IsPlayerInAnyVehicle(playerid))
    	{
    		id = GetPlayerVehicleID(playerid);
    	}
        new rid = GetRealVehicleID(id);

        if(Vehicle[rid][Model] != 0) RespawnVehicle(id, rid);
        else SetVehicleToRespawn(id);

        SendClientMessage(playerid, WHITE, "You have successfully respawned that vehicle.");
    }
    else SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
    return 1;
}

CMD:respawnvehicles(playerid, params[])
{
    new Float:range;
    if(sscanf(params, "f", range)) 
    {
        if(Player[playerid][AdminLevel] >= 1)
        {
            return SendClientMessage(playerid, WHITE, "USAGE: /respawnvehicles [range (0-100)]");
        }
        else return SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
    }
    else if(Player[playerid][AdminLevel] >= 1)
    {
        new Float:Pos[3];
        GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
        for(new i; i < MAX_VEHICLES; i++)
        {
            if(GetVehicleDistanceFromPoint(i, Pos[0], Pos[1], Pos[2]) <= range && !IsVehicleOccupied(i))
            {
                new rid = GetRealVehicleID(i);

                if(Vehicle[rid][Model] != 0) RespawnVehicle(i, rid);
                else SetVehicleToRespawn(i);
            }
        }

        SendClientMessage(playerid, WHITE, "You have successfully respawned those vehicles.");
    }
    else SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
    return 1;
}

CMD:entercar(playerid, params[])
{
    new id, seat;
    if(sscanf(params, "dd", id)) 
    {
        if(Player[playerid][AdminLevel] >= 1)
        {
            return SendClientMessage(playerid, WHITE, "USAGE: /entercar [id] [seat]");
        }
        else return SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
    }
    else if(Player[playerid][AdminLevel] >= 1)
    {
    	if(id == INVALID_VEHICLE_ID) return SendClientMessage(playerid, WHITE, "That is not a valid vehicle ID.");
    	if(IsPlayerInAnyVehicle(playerid)) RemovePlayerFromVehicle(playerid);
    	PutPlayerInVehicle(playerid, id, seat);
    }
    else SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
    return 1;
}

// ADMIN LEVEL 2 COMMANDS //

CMD:vehiclenames(playerid, params[]) 
{
	if(Player[playerid][AdminLevel] >= 2)
	{
		SendClientMessage(playerid, WHITE, "--------------------------------------------------------------------------------------------------------------------------------");
		SendClientMessage(playerid, WHITE, "Vehicle Search:");

		if(isnull(params)) return SendClientMessage(playerid, GREY, "You did not enter a keyword.");
		if(!params[2]) return SendClientMessage(playerid, GREY, "Your search must be longer than two characters.");

		Array[0] = 0;
		for(new v; v < sizeof(VehicleNames); v++) 
		{
			if(strfind(VehicleNames[v], params, true) != -1) 
			{
				if(isnull(Array)) format(Array, sizeof(Array), "%s (ID %d)", VehicleNames[v], v+400);
				else format(Array, sizeof(Array), "%s | %s (ID %d)", Array, VehicleNames[v], v+400);
			}
		}

		if(!Array[0]) SendClientMessage(playerid, GREY, "No results found.");
		else SendClientMessage(playerid, GREY, Array);

		SendClientMessage(playerid, WHITE, "--------------------------------------------------------------------------------------------------------------------------------");
	}
	return 1;
}

CMD:veh(playerid, params[]) 
{
	if(Player[playerid][AdminLevel] >= 2) 
	{
		new vehicle, colour[2];

		if(sscanf(params, "iD(0)D(0)", vehicle, colour[0], colour[1])) return SendClientMessage(playerid, WHITE, "SYNTAX: /veh [model] [(optional) colour] [(optional) colour]");
		else if(!(400 <= vehicle <= 611)) return SendClientMessage(playerid, WHITE, "You specified an invalid model ID. (IDs start at 400, and end at 611).");
		else if(!(0 <= colour[0] <= 255 && 0 <= colour[1] <= 255)) return SendClientMessage(playerid, WHITE, "You specified an invalid colour ID. (IDs start at 0, and end at 255).");

		else for(new i; i < sizeof(AdminVehicles); i++) if(i >= MAX_ADMIN_VEHICLES) return SendClientMessage(playerid, WHITE, "The maximum limit of 50 spawned vehicles has been reached.");
		else if(AdminVehicles[i] == INVALID_VEHICLE_ID) 
		{
			new Float:Pos[4];

			GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
			GetPlayerFacingAngle(playerid, Pos[3]);
			AdminVehicles[i] = CreateVehicle(vehicle, Pos[0], Pos[1], Pos[2], Pos[3], colour[0], colour[1], -1);
			LinkVehicleToInterior(AdminVehicles[i], GetPlayerInterior(playerid));
			SetVehicleVirtualWorld(AdminVehicles[i], GetPlayerVirtualWorld(playerid));
			Fuel[AdminVehicles[i]] = -1;
			return SendClientMessage(playerid, WHITE, "You have successfully created a vehicle.");
		}
	}
	else SendClientMessage(playerid, WHITE, "You are not authorized to use that command.");
	return 1;
}

CMD:afix(playerid, params[])
{
	if(Player[playerid][AdminLevel] >= 2)
    {
        if(IsPlayerInAnyVehicle(playerid))
		{
            new Float:Rot;
            GetVehicleZAngle(GetPlayerVehicleID(playerid), Rot);
            SetVehicleZAngle(GetPlayerVehicleID(playerid), Rot);
            SetVehicleHealth(GetPlayerVehicleID(playerid), 1000.0);
            RepairVehicle(GetPlayerVehicleID(playerid));

            SendClientMessage(playerid, WHITE, "You have successfully fixed the vehicle.");
        }
        else return SendClientMessage(playerid, WHITE, "You are not in a vehicle!");
    }
    else SendClientMessage(playerid, WHITE, "You are not authorized to use that command.");
    return 1;
}

CMD:anos(playerid, params[])
{
	if(Player[playerid][AdminLevel] >= 2)
	{
		if(IsPlayerInAnyVehicle(playerid))
		{
		    if(CanVehicleBeModified(playerid))
		    {
		        SendClientMessage(playerid, WHITE, "You can't modify this vehicle.");
		    }
		    else
		    {
		        AddVehicleComponent(GetPlayerVehicleID(playerid), 1010);
			    SendClientMessage(playerid, WHITE, "You have applied nitrous.");
		    }
		}
		else
		{
		    SendClientMessage(playerid, WHITE, "You're not in this vehicle.");
		}
	}
	return 1;
}

CMD:ahyd(playerid, params[])
{
	if(Player[playerid][AdminLevel] >= 2)
	{
		if(IsPlayerInAnyVehicle(playerid))
		{
		    if(CanVehicleBeModified(playerid))
		    {
		        SendClientMessage(playerid, WHITE, "You can't modify this vehicle.");
		    }
		    else
		    {
		        AddVehicleComponent(GetPlayerVehicleID(playerid), 1070);
			    SendClientMessage(playerid, WHITE, "You have applied hydrolics.");
		    }
		}
		else
		{
		    SendClientMessage(playerid, WHITE, "You're not in this vehicle.");
		}
	}
	return 1;
}

// ADMIN LEVEL 3 COMMANDS //

CMD:set(playerid, params[])
{
    new Usage[36], id, Value, string[256];
    if(sscanf(params, "us[36]d", id, Usage, Value))
    {
	    if(Player[playerid][AdminLevel] >= 3)
	    {
	        SendClientMessage(playerid, WHITE, "SYNTAX: /set [playerid] [usage] [value]");
	        return SendClientMessage(playerid, GREY, "Usages: Health, Armour, Int(erior), V(irtual)W(orld), Accent, Skin, Gender, Age, Money");
	    }
	    else return SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
    }
    else
    {
        if(Player[playerid][AdminLevel] >= 3)
        {
	        new hour, minute, second, day, year, month;
	        gettime(hour, minute, second);
	        getdate(year, month, day);
	        if(strlen(Usage) >= 1 && IsPlayerConnectedEx(id) && Player[playerid][AdminLevel] >= Player[id][AdminLevel] && Player[playerid][AdminLevel] >= 3)
	        {
	        	if(strcmp(Usage, "health", true) == 0) SetPlayerHealthEx(id, float(Value));

	        	else if(strcmp(Usage, "armour", true) == 0) SetPlayerArmourEx(id, float(Value));

	        	else if(strcmp(Usage, "accent", true) == 0) Player[id][Accent] = Value;

	   	    	else if(strcmp(Usage, "skin", true) == 0)
	        	{
	        		if(SkinNumberInvalid(Value)) { return SendClientMessage(playerid, WHITE, "Invalid skin model! Valid skins start at 0 and end at 311."); }

	        		if(Player[id][AdminDuty] >= 1) Player[id][AdminSkin] = Value;
	        		else Player[id][Skin] = Value;

	        		SetPlayerSkin(id, Value);
	        	}

	        	else if(strcmp(Usage, "gender", true) == 0)
	        	{
	        		if(Value < 0 || Value > 1) return SendClientMessage(playerid, WHITE, "Genders are 0 for Male and 1 for Female.");

	        		Player[id][Gender] = Value;
	        	}

	        	else if(strcmp(Usage, "age", true) == 0)
	        	{
	        		if(Value < 18 || Value > 99) return SendClientMessage(playerid, WHITE, "Ages are from 18-99.");

	        		Player[id][Age] = Value;
	        	}

	        	else if(strcmp(Usage, "interior", true) == 0 || strcmp(Usage, "int", true) == 0)
	        	{
	        		Player[id][Interior] = Value;
	        		SetPlayerInterior(id, Value);
	        	}

	        	else if(strcmp(Usage, "virtualworld", true) == 0 || strcmp(Usage, "vw", true) == 0)
	        	{
	        		Player[id][VirtualWorld] = Value;
	        		SetPlayerVirtualWorld(playerid, Value);
	        	}

	        	else if(strcmp(Usage, "money", true) == 0) 
	        	{
	        		if(Value < 0) return SendClientMessage(playerid, WHITE, "You cannot give negative money, use /fine to take away money.");

	        		GiveMoneyEx(id, Value);
	        	}

	        	else
	        	{
	        		SendClientMessage(playerid, WHITE, "SYNTAX: /set [playerid] [usage] [value]");
	        		return SendClientMessage(playerid, GREY, "Usages: Health, Armour, Interior, V(irtual)W(orld), Accent, Skin, Gender, Age, Money");
	        	}

	        	Usage[0] = tolower(Usage[0]);

	        	format(string, sizeof(string), "You have modified %s's %s to %d.", GetName(id), Usage, Value);
	        	SendClientMessage(playerid, WHITE, string);
	        	format(string, sizeof(string), "Your %s has been modified to %d by administrator %s.", Usage, Value, GetName(playerid));
	        	SendClientMessage(id, GREY, string);

	        	format(string, sizeof(string), "[/SET] %s has modified %s's %s to %d.", GetName(playerid), GetName(id), Usage, Value);
	        	Log(1, string);
	        }
	        else return SendClientMessage(playerid, WHITE, "You can not preform this action on a player that is not connected or has a higher administrator level.");
	    }
	    else return SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
	}
	return 1;
}

CMD:agiveweapon(playerid, params[])
{
    if(Player[playerid][AdminLevel] >= 3) 
    {
        new id, weapon, ammo;
        if(sscanf(params, "udD(99999)", id, weapon, ammo)) 
        {
            SendClientMessage(playerid, WHITE, "SYNTAX: /agiveweapon [playerid] [weapon] [(optional) ammo]");
            SendClientMessage(playerid, GREY, "(1)Brass Knuckles (2)Golf Club (3)Nite Stick (4)Knife (5)Baseball Bat (6)Shovel (7)Pool Cue (8)Katana (9)Chainsaw");
            SendClientMessage(playerid, GREY, "(10)Purple Dildo (11)Small White Vibrator (12)Large White Vibrator (13)Silver Vibrator (14)Flowers (15)Cane (16)Frag Grenade");
            SendClientMessage(playerid, GREY, "(17)Tear Gas (18)Molotov Cocktail (21)Jetpack (22)9mm (23)Silenced 9mm (24)Desert Eagle (25)Shotgun (26)Sawnoff Shotgun");
            SendClientMessage(playerid, GREY, "(27)Combat Shotgun (28)Micro SMG (Mac 10) (29)SMG (MP5) (30)AK-47 (31)M4 (32)Tec9 (33)Rifle (34)Sniper Rifle");
            SendClientMessage(playerid, GREY, "(35)Rocket Launcher (36)HS Rocket Launcher (37)Flamethrower (38)Minigun (39)Satchel Charge (40)Detonator");
            SendClientMessage(playerid, GREY, "(41)Spraycan (42)Fire Extinguisher (43)Camera (44)Nightvision Goggles (45)Infared Goggles (46)Parachute");
            return 1;
        }

        if(weapon < 1 || weapon > 47 || weapon == 19 || weapon == 20) return SendClientMessage(playerid, WHITE, "You specified an invalid weapon ID.");
        if(IsPlayerConnectedEx(id))
		{
			if(id != INVALID_PLAYER_ID && weapon == 21) 
			{
                SetPlayerSpecialAction(id, SPECIAL_ACTION_USEJETPACK);
            }
            else GivePlayerWeaponEx(id, weapon, ammo);

            Array[0] = 0;

            format(Array, sizeof(Array), "You have given %s a %s(%d)! (Ammo: %d)", GetName(id), GetWeaponNameEx(weapon), weapon, ammo);
            SendClientMessage(playerid, WHITE, Array);
            format(Array, sizeof(Array), "You were given a %s by %s! (Ammo: %d)", GetWeaponNameEx(weapon), GetName(playerid), ammo);
            SendClientMessage(playerid, WHITE, Array);
			format(Array, sizeof(Array), "[/AGIVEAWEAPON] %s has given %s a %s(%d) | Ammo: %d", GetName(playerid), GetName(id), GetWeaponNameEx(weapon), weapon, ammo);
			Log(1, Array);
        }
    }
    else return SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
	return 1;
}

CMD:jetpack(playerid, params[])
{
    if(Player[playerid][AdminLevel] >= 1) 
    {
    	Array[0] = 0;
    	if(Player[playerid][AdminLevel] >= 5)
    	{
        	new id;
        	if(sscanf(params, "u(-1)", id)) 
        	{
        		if(id == -1) id = playerid;
        		SetPlayerSpecialAction(id, SPECIAL_ACTION_USEJETPACK); 

            	format(Array, sizeof(Array), "You have given %s a jetpack!", GetName(id));
            	SendClientMessage(playerid, WHITE, Array);
           		format(Array, sizeof(Array), "You were given a jetpack by %s!", GetName(playerid));
            	SendClientMessage(playerid, WHITE, Array);
            	format(Array, sizeof(Array), "[/JETPACK] %s has given %s a jetpack.", GetName(playerid), GetName(id));
				Log(2, Array);
				return 1;
        	}
        }

        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USEJETPACK); 
        format(Array, sizeof(Array), "[/JETPACK] %s has given %s a jetpack.", GetName(playerid), GetName(playerid));
		Log(2, Array);
    }
    else return SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
	return 1;
}

CMD:jobskill(playerid, params[])
{
	new id, Usage, Value;
    if(sscanf(params, "udd", id, Usage, Value))
    {
	    if(Player[playerid][AdminLevel] >= 3)
	    {
	        SendClientMessage(playerid, WHITE, "SYNTAX: /jobskill [playerid] [job] [value]");
	        return SendClientMessage(playerid, GREY, "Jobs: 1 - Arms Dealer, 2 - Mechanic, 3 - Bodyguard, 4 - Detective, 5 - Trucker, 6 - Drug Smuggler");
	    }
	    else return SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
    }
    else
    {
    	if(Player[playerid][AdminLevel] >= 3)
    	{
    		if(IsPlayerConnectedEx(id))
    		{
    			if(Usage < 1 || Usage > 6) return SendClientMessage(playerid, GREY, "Jobs: 1 - Arms Dealer, 2 - Mechanic, 3 - Bodyguard, 4 - Detective, 5 - Trucker, 6 - Drug Smuggler");
    			Player[id][JobSkill][Usage - 1] = Value;

    			format(Array, sizeof(Array), "You have modified %s's %s skill to %d.", GetName(id), Job[Usage - 1][JobName], Value);
	        	SendClientMessage(playerid, WHITE, Array);
	        	format(Array, sizeof(Array), "Your %s skill has been modified to %d by administrator %s.", Job[Usage - 1][JobName], Value, GetName(playerid));
	        	SendClientMessage(id, GREY, Array);

	        	format(Array, sizeof(Array), "[/JOBSKILL] %s has modified %s's %s skill to %d.", GetName(playerid), GetName(id), Job[Usage - 1][JobName], Value);
	        	Log(1, Array);
    		}
    		else return SendClientMessage(playerid, WHITE, "That player is not connected.");
    	}
    	else return SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
    }
    return 1;
}

CMD:destroyvehicles(playerid, params[])
{
    if(Player[playerid][AdminLevel] >= 4) 
    {
    	for(new i = 0; i < sizeof(AdminVehicles); i++) 
    	{
        	if(AdminVehicles[i] != INVALID_VEHICLE_ID) 
        	{
            	DestroyVehicle(AdminVehicles[i]);
            	AdminVehicles[i] = INVALID_VEHICLE_ID;
        	}
    	}

    	SendClientMessage(playerid, WHITE, "You have successfully destroyed all administrative spawned vehicles.");
    }
    else SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
    return 1;
}

// ADMIN LEVEL 4 COMMANDS //

CMD:makeleader(playerid, params[])
{
	new id;
    if(sscanf(params, "u", id))
    {
	    if(Player[playerid][AdminLevel] >= 4)
	    {
	        SendClientMessage(playerid, WHITE, "SYNTAX: /makeleader [playerid]");
	    }
	    else return SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
    }
    else
    {
        if(Player[playerid][AdminLevel] >= 4)
        {
        	if(IsPlayerConnectedEx(id))
        	{
        		new Name[15 + MAX_PLAYER_NAME];
        		Array[0] = 0;
        		SetPVarInt(playerid, "MakingLeader", id);

        		for(new i; i < MAX_GROUPS; i++) format(Array, sizeof(Array), "%s\n%d.) {%s}%s{FFFFFF}\n", Array, i + 1, GetGroupColour(Group[i][GroupColour]), Group[i][GroupName]);
        		format(Name, MAX_PLAYER_NAME, "Make Leader - %s", GetName(id));

				ShowPlayerDialog(playerid, DIALOG_MAKELEADER, DIALOG_STYLE_LIST, Name, Array, "Select", "Cancel");
        	}
        	else return SendClientMessage(playerid, WHITE, "You can not preform this action on a player that is not connected.");
        }
        else return SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
    }
    return 1;
}

CMD:clearchat(playerid, params[])
{
	if(Player[playerid][AdminLevel] >= 4)
    {
    	Array[0] = 0;
    	ClearChat(playerid, 2);

    	format(Array, sizeof(Array), "[/CLEARCHAT] %s %s has cleared the SA:MP chat.", GetPlayerAdminLevel(playerid), GetName(playerid));
	    SendToAdmins(ORANGE, Array, 0, 4);
    }
    else SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
	return 1;
}

// ADMIN LEVEL 5 COMMANDS //

CMD:adminname(playerid, params[])
{
	new id, name[MAX_PLAYER_NAME];
	if(sscanf(params, "us[16]", id, name))
    {
	    if(Player[playerid][AdminLevel] >= 5)
	    {
	        SendClientMessage(playerid, WHITE, "SYNTAX: /adminname [playerid] [name]");
	    }
	    else return SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
    }
    else
    {
        if(Player[playerid][AdminLevel] >= 5)
        {
        	Array[0] = 0;

        	format(Player[id][AdminName], MAX_PLAYER_NAME, "%s", name);
        	if(Player[id][AdminDuty] >= 1) SetPlayerName(id, Player[id][AdminName]);

        	format(Array, sizeof(Array), "You have changed %s's admin name to %s.", GetName(id), name);
	        SendClientMessage(playerid, WHITE, Array);
	        format(Array, sizeof(Array), "Your admin name has been changed to %s by %s.", name, GetName(id));
	        SendClientMessage(id, GREY, Array);

	        format(Array, sizeof(Array), "[/ADMINNAME] %s has set %s's admin name to %s.", GetName(playerid), GetName(id), name);
	    	Log(2, Array);
        }
        else return SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
    }
	return 1;
}

CMD:editserver(playerid, params[])
{
    new usage[16], amount;
    if(sscanf(params, "s[16]D(0)", usage, amount)) 
    {
        if(Player[playerid][AdminLevel] >= 5)
        {
            SendClientMessage(playerid, WHITE, "USAGE: /editserver [usage] [(optional) amount]");
            return SendClientMessage(playerid, GREY, "Usages: spawn, spawnmoney, bankmoney");
        }
    }
    else if(Player[playerid][AdminLevel] >= 5)
    {
        Array[0] = 0;
        if(strcmp(usage, "spawn", true) == 0)
        {
            new Float:Pos[4];
            GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
            GetPlayerFacingAngle(playerid, Pos[3]);

            Spawn[0] = Pos[0];
            Spawn[1] = Pos[1];
            Spawn[2] = Pos[2];
            Spawn[3] = Pos[3];

            format(Array, sizeof(Array), "You have moved the server spawn.");
            SendClientMessage(playerid, WHITE, Array);

            format(Array, sizeof(Array), "[/EDITSERVER] %s has moved the server spawn to X: %f, Y: %f, Z: %f", GetName(playerid), Pos[0], Pos[1], Pos[2]);
        }
        else if(strcmp(usage, "spawnmoney", true) == 0)
        {
            SpawnMoney[0] = amount;

            format(Array, sizeof(Array), "You have modified the server spawn money to $%d", amount);
            SendClientMessage(playerid, WHITE, Array);

            format(Array, sizeof(Array), "[/EDITSERVER] %s has modified the server spawn money to %d", GetName(playerid), amount);
        }
        else if(strcmp(usage, "bankmoney", true) == 0)
        {
            SpawnMoney[1] = amount;

            format(Array, sizeof(Array), "You have modified the server bank money to $%d", amount);
            SendClientMessage(playerid, WHITE, Array);

            format(Array, sizeof(Array), "[/EDITSERVER] %s has modified the server bank money to %d", GetName(playerid), amount);
        }
        else
        {
            SendClientMessage(playerid, WHITE, "USAGE: /editserver [usage] [(optional) amount]");
            return SendClientMessage(playerid, GREY, "Usages: spawn, spawnmoney, bankmoney");
        }

        Log(17, Array);
    }
    else SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
    return 1;
}

// ADMIN LEVEL 6 COMMANDS //

CMD:gmx(playerid, params[])
{
	new reason[128];
	if(sscanf(params, "s[128]", reason))
	{
	    if(Player[playerid][AdminLevel] >= 6)
	    {
			SendClientMessage(playerid, WHITE, "SYNTAX: /gmx [reason]");
		}
	}
	else if(Player[playerid][AdminLevel] >= 6)
	{
		switch(ServerGMX)
		{
			case 0:
			{
				format(Array, sizeof(Array), "Admin %s has initiated a server restart, it will occur in the next 30 seconds, reason: %s", GetName(playerid), reason);
				SendClientMessageToAll(LIGHTRED, Array);
				SetTimer("GMXTimer", 30000, false);
				ServerGMX = 1;
			}
			case 1:
			{
				format(Array, sizeof(Array), "Admin %s has changed the restart priority to (2). The server will restart now, reason: %s", GetName(playerid), reason);
				SendClientMessageToAll(LIGHTRED, Array);
				ServerGMX = 2;
				ServerRestart();
			}
		}
	}
	else SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
	return 1;
}

CMD:payday(playerid, params[])
{
	if(Player[playerid][AdminLevel] >= 6)
	{
		Player[playerid][ConnectedSeconds] = 3599;
	}
	return 1;
}

CMD:audiourl(playerid, params[])
{
	new url[128];
	if(sscanf(params, "s[128]", url))
	{
	    if(Player[playerid][AdminLevel] >= 6)
	    {
			SendClientMessage(playerid, WHITE, "SYNTAX: /audiourl [url]");
		}
	}
	else if(Player[playerid][AdminLevel] >= 6) PlayAudioStreamForPlayer(playerid, url);
	return 1;
}