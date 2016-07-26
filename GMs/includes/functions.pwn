GamemodeInitiate()
{
	AntiDeAMX();
	Streamer_VisibleItems(STREAMER_TYPE_OBJECT, 999);

	LoadServer();
	LoadGroups();
	LoadHouses();
	LoadDoors();
	LoadBusinesses();
	LoadVehicles();
	LoadDealershipVehicles();
	LoadArrestPoints();
	LoadLockers();
	LoadGates();
	LoadJobs();
	LoadCrimes();
	LoadPoints();

	ClearReports();
	SetTime();

	for(new i = 0; i < sizeof(AdminVehicles); i++) AdminVehicles[i] = INVALID_VEHICLE_ID;

	print("[SCRIPT-LOAD] The server has successfully initiated.");
	return 1;
}

GetNameWithUnderscore(playerid)
{
    new Name[MAX_PLAYER_NAME];
    
    if(IsPlayerConnected(playerid)) { GetPlayerName(playerid, Name, sizeof(Name)); }
	else { Name = "Disconnected/Nothing"; }
	return Name;
}

GetName(playerid)
{
    new Name[MAX_PLAYER_NAME];

    GetPlayerName(playerid, Name, sizeof(Name));
    for(new i = 0; i < MAX_PLAYER_NAME; i++)
    {
        if(Name[i] == '_') Name[i] = ' ';
    }
    return Name;
}

ClearChat(playerid, value)
{
	switch(value)
	{
	    case 1: { for(new i = 0; i < 50; i++) SendClientMessage(playerid, WHITE, ""); }
	    case 2: { for(new i = 0; i < 50; i++) SendClientMessageToAll(WHITE, ""); }
	}
	return 1;
}

DelayPunishment(playerid, punishment)
{
	switch(punishment)
	{
	    case 1:
	    {
	        SetTimerEx("KickPlayer", 500, false, "i",playerid);
	    }
	}
	return 1;
}

AdvanceTutorial(playerid, stage)
{
	switch(stage)
	{
	    case 1:
	    {	    	
	        SetSpawnInfo(playerid, 0, 59, Spawn[0], Spawn[1], Spawn[2], Spawn[3], 0, 0, 0, 0, 0, 0);
	        TogglePlayerSpectating(playerid, FALSE);
	        TogglePlayerControllableEx(playerid, TRUE);

    		SpawnPlayer(playerid);
    		GiveMoneyEx(playerid, SpawnMoney[0]);

    		Player[playerid][Authenticated] = 1;

    		SavePlayerData(playerid, 1);
	    }
	}
	return 1;
}

RoleplayAccountCheck(playerid)
{
    new Split[3][MAX_PLAYER_NAME];
	split(GetNameWithUnderscore(playerid), Split, '_');
			
    if(!strlen(Split[0]) || !strlen(Split[1]))
    {
        SendClientMessage(playerid, WHITE, "You have been kicked for failing to connect with a roleplay name. i.e (John_Doe)");
        DelayPunishment(playerid, 1);

        SetPVarInt(playerid, "CannotRegister", 1);
    }
    else return 1;
    return 1;
}

IsPlayerConnectedEx(playerid)
{
	if(IsPlayerConnected(playerid))
	{
	    if(Player[playerid][Authenticated] == 1) return 1;
	    else return 0;
	}
	else return 0;
}

SkinNumberInvalid(skin)
{
    if (skin < 0 || skin > 311) return true;
    return false;
}

SkinRestricted(skin)
{
    if(skin >= 265 && skin <= 267 || skin >= 274 && skin <= 288 || skin >= 300 && skin <= 311) return true;
    return false;
}

SpectatePlayer(playerid, id)
{
	TogglePlayerSpectating(playerid, TRUE);
	PlayerSpectatePlayer(playerid, id);
}

GetPlayerSpeed(playerid, get3d)
{
	new Float:x, Float:y, Float:z;
	if(IsPlayerInAnyVehicle(playerid))
	    GetVehicleVelocity(GetPlayerVehicleID(playerid), x, y, z);
	else
	    GetPlayerVelocity(playerid, x, y, z);

	return SpeedCheck(x, y, z, 100.0, get3d);
}

SetSpawnCameraPosition(playerid)
{
	TogglePlayerSpectating(playerid, TRUE);
	TogglePlayerControllableEx(playerid, FALSE);
	new randcamera = random(6);
	switch(randcamera)
	{
		case 0: // LS -> Vinewood sign
		{
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			InterpolateCameraPos(playerid, 1332.4017, -1273.0405, 51.5045, 1356.2163, -875.2115, 81.1848, 10000, CAMERA_MOVE);
    		InterpolateCameraLookAt(playerid, 1332.5355, -1272.0459, 51.3143, 1356.7589, -874.3672, 81.1946, 10000, CAMERA_MOVE);
		}
	    case 1: // LS -> Vinewood sign
		{
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			InterpolateCameraPos(playerid, 1332.4017, -1273.0405, 51.5045, 1356.2163, -875.2115, 81.1848, 10000, CAMERA_MOVE);
    		InterpolateCameraLookAt(playerid, 1332.5355, -1272.0459, 51.3143, 1356.7589, -874.3672, 81.1946, 10000, CAMERA_MOVE);
		}
		case 2: // LS -> Beach
		{
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			InterpolateCameraPos(playerid, 728.0360, -1492.6876, 1.0439, 696.5245, -1947.8958, 6.1950, 10000, CAMERA_MOVE);
    		InterpolateCameraLookAt(playerid, 728.0723, -1493.6913, 1.0588, 695.6471, -1948.3850, 6.3300, 10000, CAMERA_MOVE);
		}
		case 3: // LS -> Mall
		{
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid,1071.1344, -1400.6703, 13.0747);
			InterpolateCameraPos(playerid, 1071.1344, -1400.6703, 13.0747, 1161.6663, -1397.9561, 13.3860, 10000, CAMERA_MOVE);
    		InterpolateCameraLookAt(playerid, 1071.2012, -1401.6727, 13.1947, 1161.3923, -1398.9231, 13.4960, 10000, CAMERA_MOVE);
		}
		case 4: // EB -> EBCF
		{
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid,-1164.0419, -495.4816, 65.7990);
			InterpolateCameraPos(playerid, -1164.0419, -495.4816, 65.7990, -1035.6960, -561.4199, 31.2457, 10000, CAMERA_MOVE);
    		InterpolateCameraLookAt(playerid, -1163.5122, -496.3318, 65.6240, -1035.7935, -562.4171, 31.3107, 10000, CAMERA_MOVE);
		}
		case 5: // LS -> Grotti
		{
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid,573.4924, -1223.6322, 21.3408);
			Streamer_UpdateEx(playerid,505.2603, -1275.6567, 21.5236);
			InterpolateCameraPos(playerid, 573.4924, -1223.6322, 21.3408, 504.3172, -1275.3181, 21.5836, 10000, CAMERA_MOVE);
    		InterpolateCameraLookAt(playerid, 573.1172, -1224.5615, 21.2858, 505.2603, -1275.6567, 21.5236, 10000, CAMERA_MOVE);
		}
		case 6: // RC -> BC
		{
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			Streamer_UpdateEx(playerid,609.8735, 344.9718, 18.1300);
			InterpolateCameraPos(playerid, 609.8735, 344.9718, 18.1300, 430.9228, 600.4754, 18.1655, 10000, CAMERA_MOVE);
    		InterpolateCameraLookAt(playerid, 609.2668, 345.7694, 18.1800, 430.3113, 601.2694, 18.1805, 10000, CAMERA_MOVE);
		}
	}
}

PrepareStream(playerid)
{
	TogglePlayerControllableEx(playerid, FALSE);
	SetPVarInt(playerid, "StreamPrep", 1);
	SetTimerEx("PrepareStreamTimer", 1000 + GetPlayerPing(playerid) * 2, FALSE, "i", playerid);
	return 1;
}

GetPlayerAdminLevel(playerid)
{
	new AdminLevelString[50];
	switch(Player[playerid][AdminLevel])
	{
		case 1: format(AdminLevelString, sizeof(AdminLevelString), "Junior Administrator");
		case 2: format(AdminLevelString, sizeof(AdminLevelString), "Administrator");
		case 3: format(AdminLevelString, sizeof(AdminLevelString), "General Administrator");
		case 4: format(AdminLevelString, sizeof(AdminLevelString), "Senior Administrator");
		case 5 .. 6: format(AdminLevelString, sizeof(AdminLevelString), "Head Administrator");
		case 99999: format(AdminLevelString, sizeof(AdminLevelString), "Executive Administrator");
		default: format(AdminLevelString, sizeof(AdminLevelString), "undefined");
	}
	return AdminLevelString;
}

TogglePlayerControllableEx(playerid, control)
{
	switch(control)
	{
		case 0:
		{
			TogglePlayerControllable(playerid, FALSE);
			SetPVarInt(playerid, "Frozen", 1);
		}
		case 1:
		{
			TogglePlayerControllable(playerid, TRUE);
			DeletePVar(playerid, "Frozen");
		}
	}
}

split(const strsrc[], strdest[][], delimiter) // credits to calgonx
{
	new i, li, len, aNum;
	while(i <= strlen(strsrc))
	{
		if(strsrc[i] == delimiter || i == strlen(strsrc))
		{
	        len = strmid(strdest[aNum], strsrc, li, i, 128);
	        strdest[aNum][len] = 0;
	        li = i+1;
	        aNum++;
		}
		i++;
	}
	return 1;
}

IsNumeric(string[]) { for (new i = 0, j = strlen(string); i < j; i++) if (string[i] > '9' || string[i] < '0') return 0; return 1; }

GetGroupColour(colour)
{
	new colorstring[7];
	format(colorstring, sizeof(colorstring), "%x", colour);
	new i, d = 6 - strlen(colorstring);
	while (i++ != d) {
		strins(colorstring, "0", 0, 7);
	}
	return colorstring;
}

IsKeyJustDown(key, newkeys, oldkeys)
{
	if((newkeys & key) && !(oldkeys & key)) return 1;
	return 0;
}

IsPlayerNearPlayer(playerid, id, Float:range)
{
	new Float:Pos[3];
	GetPlayerPos(id, Pos[0], Pos[1], Pos[2]);

	if(IsPlayerInRangeOfPoint(playerid, range, Pos[0], Pos[1], Pos[2])) return 1;
	else return 0;
}

SendNearbyMessage(playerid, string[], color, Float:range)
{
	new Float:Pos[3];
	for(new i; i < MAX_PLAYERS; i++)
	{
		GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
		if(IsPlayerInRangeOfPoint(i, range, Pos[0], Pos[1], Pos[2]))
		{
			SendClientMessage(i, color, string);
		}
	}
	return 1;
}

SetTime()
{
	gettime(GlobalHour, GlobalMinute, GlobalSecond);
	
	SetWorldTime(GlobalHour);

	Weather = random(19) + 1;
	if(Weather == 1 || Weather == 8 || Weather == 9) Weather=1;
	SetWeather(Weather);
}

/*ResetPlayerVars(playerid)
{
	for(new i=0; i < MAX_REPORTS; i++)
	{
	    if(Reports[i][Used] == 1 && Reports[i][Reporter] ==playerid) 
	    {
			DeletePVar(Reports[i][Reporter], "ReportActive");
		}
	}

	DeletePVar(playerid, "CannotRegister");
	DeletePVar(playerid, "LastTyped");
	DeletePVar(playerid, "SpawnAFK");
	DeletePVar(playerid, "Frozen");
	DeletePVar(playerid, "InAnimation");
	DeletePVar(playerid, "LoopingAnim");
	DeletePVar(playerid, "Offering");
	DeletePVar(playerid, "TruckRun");
	DeletePVar(playerid, "TruckVeh");
	DeletePVar(playerid, "TruckTrailer");
	SetPVarInt(playerid, "OnPhone", -1);
	SetPVarInt(playerid, "Calling", -1);

	if(Player[playerid][PhoneTimer] > -1) KillTimer(Player[playerid][PhoneTimer]);
}*/

/*GetWeekday(display = 0, day = 0, month = 0, year = 0)
{
	if(!day) getdate(year, month, day);

	new weekday_str[10], j, e;

	if(month <= 2)
	{
		month += 12;
		--year;
	}

	j = year % 100;
	e = year / 100;
	
	if(display == 1)
	{
		switch((day + (month+1)*26/10 + j + j/4 + e/4 - 2*e) % 7)
		{
			case 0: weekday_str = "sat";
			case 1: weekday_str = "sun";
			case 2: weekday_str = "mon";
			case 3: weekday_str = "tues";
			case 4: weekday_str = "wed";
			case 5: weekday_str = "thurs";
			case 6: weekday_str = "fri";
		}
	}
	else
	{
		switch((day + (month+1)*26/10 + j + j/4 + e/4 - 2*e) % 7)
		{
			case 0: weekday_str = "saturday";
			case 1: weekday_str = "sunday";
			case 2: weekday_str = "monday";
			case 3: weekday_str = "tuesday";
			case 4: weekday_str = "wednesday";
			case 5: weekday_str = "thursday";
			case 6: weekday_str = "friday";
		}
	}

	return weekday_str;
}*/

GiveMoneyEx(playerid, amount)
{
	if(Player[playerid][Authenticated])
	{
		Player[playerid][Money] += amount;
		GivePlayerMoney(playerid, amount);
	}
	return 1;
}

FormatNumberToString(number) // Ain't gonna lie, ripped straight from the NG:RP script. :S
{
	new i, string[15];
	valstrex(string, number);
	if(strfind(string, "-") != -1) i = strlen(string) - 4;
	else i = strlen(string) - 3;
	while (i >= 1)
 	{
		if(strfind(string, "-") != -1) strins(string, ",", i + 1);
		else strins(string, ",", i);
		i -= 3;
	}
	return string;
}

valstrex(dest[], value, bool:pack = false) // Ain't gonna lie, ripped straight from the NG:RP script. :S
{
    // format can't handle cellmin properly
    static const cellmin_value[] = !"-2147483648";

    if (value == cellmin)
        pack && strpack(dest, cellmin_value, 12) || strunpack(dest, cellmin_value, 12);
    else
        format(dest, 12, "%d", value) && pack && strpack(dest, dest, 12);
}

IsVehicleOccupied(id, seat = 0) 
{
	foreach(new i : Player) if(GetPlayerVehicleID(i) == id && GetPlayerVehicleSeat(i) == seat) return 1;
	return 0;
}


SetPlayerCheckpointEx(playerid, Float:X, Float:Y, Float:Z, Float:Size)
{
	if(GetPVarInt(playerid, "Checkpoint") >= 1)
	{
		SendClientMessage(playerid, WHITE, "You already have an active checkpoint. Reach it, or type /killcheckpoint to clear it.");
		return 0;
	}
	else
	{
		SetPVarInt(playerid, "Checkpoint", 1);
		SetPlayerCheckpoint(playerid, X, Y, Z, Size);
	}
	return 1;
}

DisablePlayerCheckpointEx(playerid)
{
	DeletePVar(playerid, "Checkpoint");
	DisablePlayerCheckpoint(playerid);
	return 1;
}

GetDateFormat(time, form)  // Ain't gonna lie, ripped straight from the NG:RP script. :S
{
    /*
        date( 1247182451 )  will print >> 09.07.2009-23:34:11
        date( 1247182451, 1) will print >> 09/07/2009, 23:34:11
        date( 1247182451, 2) will print >> July 09, 2009, 23:34:11
        date( 1247182451, 3) will print >> 9 Jul 2009, 23:34
    */
    new year=1970, day=0, month=0, hourt=0, mins=0, sec=0;

    new days_of_month[12] = { 31,28,31,30,31,30,31,31,30,31,30,31 };
    new names_of_month[12][10] = {"January","February","March","April","May","June","July","August","September","October","November","December"};
    new returnstring[32];

    while(time>31622400)
	{
        time -= 31536000;
        if (((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0)) time -= 86400;
        year++;
    }

    if (((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0))
    {
        days_of_month[1] = 29;
	}
    else
    {
        days_of_month[1] = 28;
	}

    while(time>86400)
	{
        time -= 86400, day++;
        if(day==days_of_month[month]) day=0, month++;
    }

    while(time>60)
	{
        time -= 60, mins++;
        if( mins == 60) mins=0, hourt++;
    }

    sec=time;

    switch( form )
	{
        case 1: format(returnstring, 31, "%02d/%02d/%d %02d:%02d:%02d", day+1, month+1, year, hourt, mins, sec);
        case 2: format(returnstring, 31, "%s %02d, %d, %02d:%02d:%02d", names_of_month[month],day+1,year, hourt, mins, sec);
        case 3: format(returnstring, 31, "%d %c%c%c %d, %02d:%02d", day+1,names_of_month[month][0],names_of_month[month][1],names_of_month[month][2], year,hourt,mins);
		case 4: format(returnstring, 31, "%s %02d, %d", names_of_month[month],day+1,year);
		case 5: format(returnstring, 31, "%s %02d, %d, %02d:%02d:%02d", names_of_month[month],day+1,year, hourt, mins, sec);
        default: format(returnstring, 31, "%02d.%02d.%d-%02d:%02d:%02d", day+1, month+1, year, hourt, mins, sec);
    }

    return returnstring;
}

// LOGGING //

Log(type, string[], group = -1)
{
	new File:logfile, logstring[300];
	format(logstring, sizeof(logstring), "[%s] %s\r\n", GetDateFormat(gettime(), 2), string);

	switch(type)
	{
		case 0: // Server
		{
			logfile = fopen("Logs/Server.log", io_append);
			fwrite(logfile, logstring);
			fclose(logfile);
		}
		case 1: // Admin
		{
			logfile = fopen("Logs/Admin.log", io_append);
			fwrite(logfile, logstring);
			fclose(logfile);

			Log(0, string);
		}
		case 2: // Head Admin+
		{
			logfile = fopen("Logs/HeadAdmin.log", io_append);
			fwrite(logfile, logstring);
			fclose(logfile);

			Log(0, string);
		}
		case 3: // Edit Group
		{
			logfile = fopen("Logs/EditGroup.log", io_append);
			fwrite(logfile, logstring);
			fclose(logfile);

			Log(0, logstring);
		}
		case 4: // House Edit
		{
			logfile = fopen("Logs/HouseEdit.log", io_append);
			fwrite(logfile, logstring);
			fclose(logfile);

			Log(0, logstring);
		}
		case 5: // Vehicle Edit
		{
			logfile = fopen("Logs/VehicleEdit.log", io_append);
			fwrite(logfile, logstring);
			fclose(logfile);

			Log(0, logstring);
		}
		case 6: // Business Edit
		{
			logfile = fopen("Logs/BusinessEdit.log", io_append);
			fwrite(logfile, logstring);
			fclose(logfile);

			Log(0, logstring);
		}
		case 7: // Door Edit
		{
			logfile = fopen("Logs/DoorEdit.log", io_append);
			fwrite(logfile, logstring);
			fclose(logfile);

			Log(0, logstring);
		}
		case 8: // IC / RP / OOC chats
		{
			logfile = fopen("Logs/PlayerChat.log", io_append);
			fwrite(logfile, logstring);
			fclose(logfile);

			Log(0, logstring);
		}
		case 9: // Arrest Edit
		{
			logfile = fopen("Logs/ArrestEdit.log", io_append);
			fwrite(logfile, logstring);
			fclose(logfile);

			Log(0, logstring);
		}
		case 10: // Group Log
		{
			logfile = fopen("Logs/Group.log", io_append);
			fwrite(logfile, logstring);
			fclose(logfile);

			Log(0, logstring);
		}
		case 11: // Group Leader Log
		{
			logfile = fopen("Logs/GroupLeader.log", io_append);
			fwrite(logfile, logstring);
			fclose(logfile);

			Log(0, logstring);
		}
		case 12: // Gate Edit Log
		{
			logfile = fopen("Logs/GateEdit.log", io_append);
			fwrite(logfile, logstring);
			fclose(logfile);

			Log(0, logstring);
		}
		case 13: // Job Edit Log
		{
			logfile = fopen("Logs/JobEdit.log", io_append);
			fwrite(logfile, logstring);
			fclose(logfile);

			Log(0, logstring);
		}
		case 14: // Point Edit Log
		{
			logfile = fopen("Logs/PointEdit.log", io_append);
			fwrite(logfile, logstring);
			fclose(logfile);

			Log(0, logstring);
		}
		case 15: // Locker Edit Log
		{
			logfile = fopen("Logs/LockerEdit.log", io_append);
			fwrite(logfile, logstring);
			fclose(logfile);

			Log(0, logstring);
		}
		case 16: // Group Log (SQL)
		{
			if(group == -1) return 1;
			new Query[500];

			format(Query, sizeof(Query), "INSERT INTO `grouplog`(`timestamp`, `group`, `log`) VALUES (NOW(), %d, '%s')", group, string);
			mysql_tquery(SQL, Query, "", "");
		}
		case 17: // Server Edit Log
		{
			logfile = fopen("Logs/ServerEdit.log", io_append);
			fwrite(logfile, logstring);
			fclose(logfile);

			Log(0, logstring);
		}
	}
	return 1;
}

GetValue(parse[], value[], destination[], length) 
{
	new Equal = strfind(parse, "=", false), Length = strlen(parse);
	while(Length-- && parse[Length] <= ' ') parse[Length] = 0;
	if(strcmp(parse, value, false, Equal) == 0) { strmid(destination, parse, Equal + 1, Length + 1, length); return 1; }
	return 0;
}

AntiDeAMX()
{
    new a[][] = {
        "Unarmed (Fist)",
        "Brass K"
    };
    #pragma unused a
}
