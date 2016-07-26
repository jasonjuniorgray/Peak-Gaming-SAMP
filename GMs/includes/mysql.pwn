GamemodeMySQLInitiate()
{
	Array[0] = 0;

	new File: MySQLFile = fopen("mysql.ini", io_read), Host[50], User[50], DB[50], Pass[50];
	while(fread(MySQLFile, Array, sizeof(Array))) 
	{
		if(GetValue(Array, "Host", Host, sizeof(Host))) continue;
		if(GetValue(Array, "DB", DB, sizeof(DB))) continue;
		if(GetValue(Array, "User", User, sizeof(User))) continue;
		if(GetValue(Array, "Pass", Pass, sizeof(Pass))) continue;
	}
	fclose(MySQLFile);

    SQL = mysql_connect(Host, User, DB, Pass);
    if(mysql_errno() != 0)
    {
        print("[SQL] The connection to the database has failed, server shutting down...");
    }
    else
    {
        print("[SQL] The connection to the database was successful, script initializing...");
        GamemodeInitiate();
    }
	return 1;
}

GamemodeMySQLExit()
{
	SaveAllData();
	mysql_close(SQL);
	return 1;
}

MySQLConnectPlayer(playerid)
{
	Array[0] = 0;
	mysql_format(SQL, Array, sizeof(Array), "SELECT `Password`, `DatabaseID` FROM `accounts` WHERE `Username` = '%e' LIMIT 1", GetNameWithUnderscore(playerid), GetNameWithUnderscore(playerid));
    mysql_tquery(SQL, Array, "CheckAccount", "i", playerid);
	return 1;
}

//SQL Callbacks

public CheckAccount(playerid)
{
	ClearChat(playerid, 1);

    new rows, fields, string[255];
    cache_get_data(rows, fields, SQL);

    Player[playerid][Authenticated] = 0;

    if(rows)
    {
        cache_get_field_content(0, "Password", Player[playerid][Password], SQL, 256);
        
        format(string, sizeof(string), "{FFFFFF}Welcome to Peak Gaming Roleplay, %s.\n\n{FFFFFF}This account is registered. Please enter the password to authenticate.", GetName(playerid));
		ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Authentication", string, "Login", "");

		TogglePlayerSpectating(playerid, TRUE);
		TogglePlayerControllableEx(playerid, FALSE);
    }
    else
    {
    	RoleplayAccountCheck(playerid);

        format(string, sizeof(string), "{FFFFFF}Welcome to Peak Gaming Roleplay, %s.\n\n{FFFFFF}This name is {AA3333}unregistered{FFFFFF}. Please enter a password to register the account.", GetName(playerid));
		ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Register", string, "Register", "");

		TogglePlayerSpectating(playerid, TRUE);
		TogglePlayerControllableEx(playerid, FALSE);
    }
    SetPVarInt(playerid, "SpawnAFK", GetPVarInt(playerid, "SpawnAFK") + 1);
    return 1;
}

LoadServer() mysql_function_query(SQL, "SELECT * FROM `server`", true, "InitiateServer", "");
LoadGroups() mysql_function_query(SQL, "SELECT * FROM `groups`", true, "InitiateGroups", "");
LoadHouses() mysql_function_query(SQL, "SELECT * FROM `houses`", true, "InitiateHouses", "");
LoadDoors() mysql_function_query(SQL, "SELECT * FROM `doors`", true, "InitiateDoors", "");
LoadBusinesses() mysql_function_query(SQL, "SELECT * FROM `businesses`", true, "InitiateBusinesses", "");
LoadVehicles() mysql_function_query(SQL, "SELECT * FROM `vehicles`", true, "InitiateVehicles", "");
LoadDealershipVehicles() mysql_function_query(SQL, "SELECT * FROM `dealershipvehicles`", true, "InitiateDealershipVehicles", "");
LoadArrestPoints() mysql_function_query(SQL, "SELECT * FROM `arrestpoints`", true, "InitiateArrestPoints", "");
LoadLockers() mysql_function_query(SQL, "SELECT * FROM `lockers`", true, "InitiateLockers", "");
LoadGates() mysql_function_query(SQL, "SELECT * FROM `gates`", true, "InitiateGates", "");
LoadJobs() mysql_function_query(SQL, "SELECT * FROM `jobs`", true, "InitiateJobs", "");
LoadCrimes() mysql_function_query(SQL, "SELECT * FROM `crimes`", true, "InitiateCrimes", "");
LoadPoints() mysql_function_query(SQL, "SELECT * FROM `points`", true, "InitiatePoints", "");

public OnPlayerLogin(playerid)
{
	Array[0] = 0;
	new rows, fields, PlayerName[MAX_PLAYER_NAME], result[128];
	cache_get_data(rows, fields);
	for(new row;row < rows;row++)
	{
		cache_get_field_content(row, "Username", PlayerName, MAX_PLAYER_NAME);

		if(strcmp(PlayerName, GetNameWithUnderscore(playerid), true) != 0)
		{
			return 1;
		}

		Player[playerid][DatabaseID] = cache_get_field_content_int(row, "DatabaseID");

		cache_get_field_content(row, "Username", Player[playerid][Username], SQL, MAX_PLAYER_NAME);

    	Player[playerid][PosX] = cache_get_field_content_float(row, "PosX");
    	Player[playerid][PosY] = cache_get_field_content_float(row, "PosY");
    	Player[playerid][PosZ] = cache_get_field_content_float(row, "PosZ");
    	Player[playerid][PosA] = cache_get_field_content_float(row, "PosA");
    	Player[playerid][Health] = cache_get_field_content_float(row, "Health");
    	Player[playerid][Armour] = cache_get_field_content_float(row, "Armour");
    	Player[playerid][Money] = cache_get_field_content_int(row, "Money");
    	Player[playerid][Interior] = cache_get_field_content_int(row, "Interior");
    	Player[playerid][VirtualWorld] = cache_get_field_content_int(row, "VirtualWorld");
    	Player[playerid][Accent] = cache_get_field_content_int(row, "Accent");
    	Player[playerid][Skin] = cache_get_field_content_int(row, "Skin");
    	Player[playerid][AdminLevel] = cache_get_field_content_int(row, "AdminLevel");
		Player[playerid][PlayerGroup] = cache_get_field_content_int(row, "Group");
		Player[playerid][GroupRank] = cache_get_field_content_int(row, "Rank");
		Player[playerid][GroupDiv] = cache_get_field_content_int(row, "Division");
		Player[playerid][Leader] = cache_get_field_content_int(row, "Leader");

		cache_get_field_content(row,  "Weapons", result, SQL, 128);
		sscanf(result, "p<|>e<dddddddddddd>", Player[playerid][Weapon]);

		Player[playerid][PhoneNumber] = cache_get_field_content_int(row, "Phone");
		Player[playerid][Rope] = cache_get_field_content_int(row, "Rope");
		Player[playerid][Rags] = cache_get_field_content_int(row, "Rags");
		Player[playerid][PortableRadio] = cache_get_field_content_int(row, "Radio");
		Player[playerid][Cigar] = cache_get_field_content_int(row, "Cigars");
		Player[playerid][Lottery] = cache_get_field_content_int(row, "Lottery");
		Player[playerid][LotteryNumber] = cache_get_field_content_int(row, "LotteryNumber");
		Player[playerid][InsideBusiness] = cache_get_field_content_int(row, "InBusiness");

		cache_get_field_content(row,  "Cars", result, SQL, 128);
		sscanf(result, "p<|>e<ddddd>", Player[playerid][CarModel]);
		cache_get_field_content(row,  "CarX", result, SQL, 128);
		sscanf(result, "p<|>e<fffff>", Player[playerid][CarX]);
		cache_get_field_content(row,  "CarY", result, SQL, 128);
		sscanf(result, "p<|>e<fffff>", Player[playerid][CarY]);
		cache_get_field_content(row,  "CarZ", result, SQL, 128);
		sscanf(result, "p<|>e<fffff>", Player[playerid][CarZ]);
		cache_get_field_content(row,  "CarA", result, SQL, 128);
		sscanf(result, "p<|>e<fffff>", Player[playerid][CarA]);
		cache_get_field_content(row,  "CarInt", result, SQL, 128);
		sscanf(result, "p<|>e<ddddd>", Player[playerid][CarInt]);
		cache_get_field_content(row,  "CarVW", result, SQL, 128);
		sscanf(result, "p<|>e<ddddd>", Player[playerid][CarVW]);
		cache_get_field_content(row,  "Colour", result, SQL, 128);
		sscanf(result, "p<|>e<ddddd>", Player[playerid][CarColour]);
		cache_get_field_content(row,  "Colour2", result, SQL, 128);
		sscanf(result, "p<|>e<ddddd>", Player[playerid][CarColour2]);
		cache_get_field_content(row,  "CarFuel", result, SQL, 128);
		sscanf(result, "p<|>e<ddddd>", Player[playerid][CarFuel]);
		cache_get_field_content(row, "CarPlate1", Player[playerid][CarPlate1], SQL, MAX_PLAYER_NAME);
		cache_get_field_content(row, "CarPlate2", Player[playerid][CarPlate2], SQL, MAX_PLAYER_NAME);
		cache_get_field_content(row, "CarPlate3", Player[playerid][CarPlate3], SQL, MAX_PLAYER_NAME);
		cache_get_field_content(row, "CarPlate4", Player[playerid][CarPlate4], SQL, MAX_PLAYER_NAME);
		cache_get_field_content(row, "CarPlate5", Player[playerid][CarPlate5], SQL, MAX_PLAYER_NAME);
		cache_get_field_content(row,  "CarMod0", result, SQL, 128);
		sscanf(result, "p<|>e<ddddd>", Player[playerid][CarMod0]);
		cache_get_field_content(row,  "CarMod1", result, SQL, 128);
		sscanf(result, "p<|>e<ddddd>", Player[playerid][CarMod1]);
		cache_get_field_content(row,  "CarMod2", result, SQL, 128);
		sscanf(result, "p<|>e<ddddd>", Player[playerid][CarMod2]);
		cache_get_field_content(row,  "CarMod3", result, SQL, 128);
		sscanf(result, "p<|>e<ddddd>", Player[playerid][CarMod3]);
		cache_get_field_content(row,  "CarMod4", result, SQL, 128);
		sscanf(result, "p<|>e<ddddd>", Player[playerid][CarMod4]);
		cache_get_field_content(row,  "CarMod5", result, SQL, 128);
		sscanf(result, "p<|>e<ddddd>", Player[playerid][CarMod5]);
		cache_get_field_content(row,  "CarMod6", result, SQL, 128);
		sscanf(result, "p<|>e<ddddd>", Player[playerid][CarMod6]);
		cache_get_field_content(row,  "CarMod7", result, SQL, 128);
		sscanf(result, "p<|>e<ddddd>", Player[playerid][CarMod7]);
		cache_get_field_content(row,  "CarMod8", result, SQL, 128);
		sscanf(result, "p<|>e<ddddd>", Player[playerid][CarMod8]);
		cache_get_field_content(row,  "CarMod9", result, SQL, 128);
		sscanf(result, "p<|>e<ddddd>", Player[playerid][CarMod9]);
		cache_get_field_content(row,  "CarMod10", result, SQL, 128);
		sscanf(result, "p<|>e<ddddd>", Player[playerid][CarMod10]);
		cache_get_field_content(row,  "CarMod11", result, SQL, 128);
		sscanf(result, "p<|>e<ddddd>", Player[playerid][CarMod11]);
		cache_get_field_content(row,  "CarMod12", result, SQL, 128);
		sscanf(result, "p<|>e<ddddd>", Player[playerid][CarMod12]);
		cache_get_field_content(row,  "CarMod13", result, SQL, 128);
		sscanf(result, "p<|>e<ddddd>", Player[playerid][CarMod13]);
		cache_get_field_content(row,  "PaintJob", result, SQL, 128);
		sscanf(result, "p<|>e<ddddd>", Player[playerid][CarPaintJob]);

		Player[playerid][Fightstyle] = cache_get_field_content_int(row, "Fightstyle");
		Player[playerid][JailTime] = cache_get_field_content_int(row, "JailTime");
		Player[playerid][ArrestedBy] = cache_get_field_content_int(row, "ArrestedBy");
		Player[playerid][TotalCrimes] = cache_get_field_content_int(row, "TotalCrimes");
		Player[playerid][TotalArrests] = cache_get_field_content_int(row, "TotalArrests");
		Player[playerid][Crimes] = cache_get_field_content_int(row, "Crimes");

		Player[playerid][Speedo] = cache_get_field_content_int(row, "Speedo");
		Player[playerid][OnDuty] = cache_get_field_content_int(row, "OnDuty");
		Player[playerid][Injured] = cache_get_field_content_int(row, "Injured");
		Player[playerid][PlayerJob] = cache_get_field_content_int(row, "Job");

		cache_get_field_content(row,  "JobSkill", result, SQL, 128);
		sscanf(result, "p<|>e<dddddddd>", Player[playerid][JobSkill]);

		Player[playerid][Materials] = cache_get_field_content_int(row, "Materials");
		Player[playerid][Drugs][0] = cache_get_field_content_int(row, "Pot");
		Player[playerid][Drugs][1] = cache_get_field_content_int(row, "Crack");
		Player[playerid][ConnectedSeconds] = cache_get_field_content_int(row, "ConnectedSeconds");
		Player[playerid][PlayingHours] = cache_get_field_content_int(row, "Hours");

		if(Player[playerid][AdminLevel] >= 1)
		{
			cache_get_field_content(row, "AdminName", Player[playerid][AdminName], SQL, MAX_PLAYER_NAME);

			Player[playerid][AdminDuty] = cache_get_field_content_int(row, "AdminDuty");
			Player[playerid][AdminSkin] = cache_get_field_content_int(row, "AdminSkin");
		}

		if(Player[playerid][AdminDuty] >= 1)
    	{
    		SetPlayerSkin(playerid, Player[playerid][AdminSkin]);
    		SetPlayerName(playerid, Player[playerid][AdminName]);

    		SetSpawnInfo(playerid, 0, Player[playerid][AdminSkin], Player[playerid][PosX], Player[playerid][PosY], Player[playerid][PosZ], Player[playerid][PosA], 0, 0, 0, 0, 0, 0);
    	}
    	else SetSpawnInfo(playerid, 0, Player[playerid][Skin], Player[playerid][PosX], Player[playerid][PosY], Player[playerid][PosZ], Player[playerid][PosA], 0, 0, 0, 0, 0, 0);

    	TogglePlayerSpectating(playerid, FALSE);

    	if(Player[playerid][Injured] > 0) Player[playerid][Injured] = 3;

    	SpawnPlayer(playerid);
    	OnPlayerLoginForward(playerid);
    	break;
	}
	return 1;
}

public OnPlayerRegisterAccount(playerid)
{
	Player[playerid][DatabaseID] = cache_insert_id();
    printf("[SQL] New account registered. Database ID: [%d]", cache_insert_id());

    Player[playerid][PlayerGroup] = -1;
    Player[playerid][GroupRank] = -1;
    Player[playerid][GroupDiv] = -1;
    Player[playerid][InsideBusiness] = -1;
    Player[playerid][Speedo] = 1;
    Player[playerid][PlayerJob] = -1;

    SetPlayerColor(playerid, WHITE); // Grey on login, white on spawn.

    AdvanceTutorial(playerid, 1);
    return 1;
}

public OnQueryError(errorid, error[], callback[], query[], connectionHandle)
{
	printf("[SQL] Query Error - (ErrorID: %d) (Handle: %d)",  errorid, connectionHandle);
	print("[SQL] Check mysql_log.txt to review the query that threw the error.");

	if(errorid == 2013 || errorid == 2014 || errorid == 2006 || errorid == 2027 || errorid == 2055)
	{
		print("[SQL] Connection Error Detected in Threaded Query");
	}
}

SavePlayerData(playerid, type)
{
	if(Player[playerid][Authenticated] <= 0) { return 0; }
	switch(type)
	{
	    case 1: // case: full
	    {
	    	if(Player[playerid][Authenticated] >= 1)
	    	{
	        	new Query[2048], string[128], Float:Pos[4], Float: pHealth, Float: pArmour, pIP[16];

	        	if(Player[playerid][AdminLevel] >= 1 && Player[playerid][AdminLevel] <= 4 && Player[playerid][AdminDuty] >= 1) // This make sure that anything a Senior Admin or below does to their account while on duty, does not save.
	    		{
	    			SavePlayerInteger(Query, Player[playerid][DatabaseID], "AdminSkin", Player[playerid][AdminSkin]);
	    			SavePlayerString(Query, Player[playerid][DatabaseID], "AdminName", Player[playerid][AdminName]);
	    			SavePlayerInteger(Query, Player[playerid][DatabaseID], "AdminDuty", Player[playerid][AdminDuty]);

	    			SQLPlayerSaveFinish(Query, Player[playerid][DatabaseID]);
	    			return 1;
	    		}

    			GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
    			GetPlayerFacingAngle(playerid, Pos[3]);
    			GetPlayerHealth(playerid, pHealth);
    			GetPlayerArmour(playerid, pArmour);	
    			GetPlayerIp(playerid, pIP, sizeof(pIP));

    			format(Query, sizeof(Query), "UPDATE `accounts` SET ");

    			SavePlayerString(Query, Player[playerid][DatabaseID], "Username", Player[playerid][Username]);
    			SavePlayerString(Query, Player[playerid][DatabaseID], "LastIP", pIP);
            	SavePlayerFloat(Query, Player[playerid][DatabaseID], "PosX", Pos[0]);
            	SavePlayerFloat(Query, Player[playerid][DatabaseID], "PosY", Pos[1]);
            	SavePlayerFloat(Query, Player[playerid][DatabaseID], "PosZ", Pos[2]);
            	SavePlayerFloat(Query, Player[playerid][DatabaseID], "PosA", Pos[3]);
    			SavePlayerFloat(Query, Player[playerid][DatabaseID], "Health", pHealth);
    			SavePlayerFloat(Query, Player[playerid][DatabaseID], "Armour", pArmour);
    			SavePlayerInteger(Query, Player[playerid][DatabaseID], "Money", Player[playerid][Money]);
    			SavePlayerInteger(Query, Player[playerid][DatabaseID], "Interior", GetPlayerInterior(playerid));
    			SavePlayerInteger(Query, Player[playerid][DatabaseID], "VirtualWorld", GetPlayerVirtualWorld(playerid));
    			SavePlayerInteger(Query, Player[playerid][DatabaseID], "AdminLevel", Player[playerid][AdminLevel]);
    			SavePlayerInteger(Query, Player[playerid][DatabaseID], "AdminDuty", Player[playerid][AdminDuty]);
    			SavePlayerInteger(Query, Player[playerid][DatabaseID], "AdminSkin", Player[playerid][AdminSkin]);
    			SavePlayerString(Query, Player[playerid][DatabaseID], "AdminName", Player[playerid][AdminName]);
    			SavePlayerInteger(Query, Player[playerid][DatabaseID], "Accent", Player[playerid][Accent]);
    			SavePlayerInteger(Query, Player[playerid][DatabaseID], "Skin", Player[playerid][Skin]);
    			SavePlayerInteger(Query, Player[playerid][DatabaseID], "Group", Player[playerid][PlayerGroup]);
    			SavePlayerInteger(Query, Player[playerid][DatabaseID], "Rank", Player[playerid][GroupRank]);
    			SavePlayerInteger(Query, Player[playerid][DatabaseID], "Division", Player[playerid][GroupDiv]);
    			SavePlayerInteger(Query, Player[playerid][DatabaseID], "Leader", Player[playerid][Leader]);

    			for(new i; i < 12; i++)
				{
					format(string, sizeof(string), "%s%d", string, Player[playerid][Weapon][i]);
					strcat(string, "|");
				}
				SavePlayerString(Query, Player[playerid][DatabaseID], "Weapons", string);

    			SavePlayerInteger(Query, Player[playerid][DatabaseID], "Phone", Player[playerid][PhoneNumber]);
    			SavePlayerInteger(Query, Player[playerid][DatabaseID], "Rope", Player[playerid][Rope]);
    			SavePlayerInteger(Query, Player[playerid][DatabaseID], "Rags", Player[playerid][Rags]);
    			SavePlayerInteger(Query, Player[playerid][DatabaseID], "Radio", Player[playerid][PortableRadio]);
    			SavePlayerInteger(Query, Player[playerid][DatabaseID], "Cigars", Player[playerid][Cigar]);
    			SavePlayerInteger(Query, Player[playerid][DatabaseID], "Lottery", Player[playerid][Lottery]);
    			SavePlayerInteger(Query, Player[playerid][DatabaseID], "LotteryNumber", Player[playerid][LotteryNumber]);
    			SavePlayerInteger(Query, Player[playerid][DatabaseID], "InBusiness", Player[playerid][InsideBusiness]);

    			string[0] = 0;
    			for(new i; i < MAX_PLAYER_VEHICLES; i++)
				{
					format(string, sizeof(string), "%s%d", string, Player[playerid][CarModel][i]);
					strcat(string, "|");
				}
				SavePlayerString(Query, Player[playerid][DatabaseID], "Cars", string);

				string[0] = 0;
				for(new i; i < MAX_PLAYER_VEHICLES; i++)
				{
					format(string, sizeof(string), "%s%f", string, Player[playerid][CarX][i]);
					strcat(string, "|");
				}
				SavePlayerString(Query, Player[playerid][DatabaseID], "CarX", string);

				string[0] = 0;
				for(new i; i < MAX_PLAYER_VEHICLES; i++)
				{
					format(string, sizeof(string), "%s%f", string, Player[playerid][CarY][i]);
					strcat(string, "|");
				}
				SavePlayerString(Query, Player[playerid][DatabaseID], "CarY", string);

				string[0] = 0;
				for(new i; i < MAX_PLAYER_VEHICLES; i++)
				{
					format(string, sizeof(string), "%s%f", string, Player[playerid][CarZ][i]);
					strcat(string, "|");
				}
				SavePlayerString(Query, Player[playerid][DatabaseID], "CarZ", string);

				string[0] = 0;
				for(new i; i < MAX_PLAYER_VEHICLES; i++)
				{
					format(string, sizeof(string), "%s%f", string, Player[playerid][CarA][i]);
					strcat(string, "|");
				}
				SavePlayerString(Query, Player[playerid][DatabaseID], "CarA", string);

				string[0] = 0;
				for(new i; i < MAX_PLAYER_VEHICLES; i++)
				{
					format(string, sizeof(string), "%s%d", string, Player[playerid][CarVW][i]);
					strcat(string, "|");
				}
				SavePlayerString(Query, Player[playerid][DatabaseID], "CarVW", string);

				string[0] = 0;
				for(new i; i < MAX_PLAYER_VEHICLES; i++)
				{
					format(string, sizeof(string), "%s%d", string, Player[playerid][CarInt][i]);
					strcat(string, "|");
				}
				SavePlayerString(Query, Player[playerid][DatabaseID], "CarInt", string);

				string[0] = 0;
				for(new i; i < MAX_PLAYER_VEHICLES; i++)
				{
					format(string, sizeof(string), "%s%d", string, Player[playerid][CarColour][i]);
					strcat(string, "|");
				}
				SavePlayerString(Query, Player[playerid][DatabaseID], "Colour", string);

				string[0] = 0;
				for(new i; i < MAX_PLAYER_VEHICLES; i++)
				{
					format(string, sizeof(string), "%s%d", string, Player[playerid][CarColour2][i]);
					strcat(string, "|");
				}
				SavePlayerString(Query, Player[playerid][DatabaseID], "Colour2", string);

				string[0] = 0;
				for(new i; i < MAX_PLAYER_VEHICLES; i++)
				{
					format(string, sizeof(string), "%s%d", string, Fuel[Player[playerid][CarID][i]]);
					strcat(string, "|");
				}
				SavePlayerString(Query, Player[playerid][DatabaseID], "CarFuel", string);

				SavePlayerString(Query, Player[playerid][DatabaseID], "CarPlate1", Player[playerid][CarPlate1]);
				SavePlayerString(Query, Player[playerid][DatabaseID], "CarPlate2", Player[playerid][CarPlate2]);
				SavePlayerString(Query, Player[playerid][DatabaseID], "CarPlate3", Player[playerid][CarPlate3]);
				SavePlayerString(Query, Player[playerid][DatabaseID], "CarPlate4", Player[playerid][CarPlate4]);
				SavePlayerString(Query, Player[playerid][DatabaseID], "CarPlate5", Player[playerid][CarPlate5]);

				string[0] = 0;
				for(new i; i < MAX_PLAYER_VEHICLES; i++)
				{
					format(string, sizeof(string), "%s%d", string, Player[playerid][CarMod0][i]);
					strcat(string, "|");
				}
				SavePlayerString(Query, Player[playerid][DatabaseID], "CarMod0", string);

				string[0] = 0;
				for(new i; i < MAX_PLAYER_VEHICLES; i++)
				{
					format(string, sizeof(string), "%s%d", string, Player[playerid][CarMod1][i]);
					strcat(string, "|");
				}
				SavePlayerString(Query, Player[playerid][DatabaseID], "CarMod1", string);

				string[0] = 0;
				for(new i; i < MAX_PLAYER_VEHICLES; i++)
				{
					format(string, sizeof(string), "%s%d", string, Player[playerid][CarMod2][i]);
					strcat(string, "|");
				}
				SavePlayerString(Query, Player[playerid][DatabaseID], "CarMod2", string);

				string[0] = 0;
				for(new i; i < MAX_PLAYER_VEHICLES; i++)
				{
					format(string, sizeof(string), "%s%d", string, Player[playerid][CarMod3][i]);
					strcat(string, "|");
				}
				SavePlayerString(Query, Player[playerid][DatabaseID], "CarMod3", string);

				string[0] = 0;
				for(new i; i < MAX_PLAYER_VEHICLES; i++)
				{
					format(string, sizeof(string), "%s%d", string, Player[playerid][CarMod4][i]);
					strcat(string, "|");
				}
				SavePlayerString(Query, Player[playerid][DatabaseID], "CarMod4", string);

				string[0] = 0;
				for(new i; i < MAX_PLAYER_VEHICLES; i++)
				{
					format(string, sizeof(string), "%s%d", string, Player[playerid][CarMod5][i]);
					strcat(string, "|");
				}
				SavePlayerString(Query, Player[playerid][DatabaseID], "CarMod5", string);

				string[0] = 0;
				for(new i; i < MAX_PLAYER_VEHICLES; i++)
				{
					format(string, sizeof(string), "%s%d", string, Player[playerid][CarMod6][i]);
					strcat(string, "|");
				}
				SavePlayerString(Query, Player[playerid][DatabaseID], "CarMod6", string);

				string[0] = 0;
				for(new i; i < MAX_PLAYER_VEHICLES; i++)
				{
					format(string, sizeof(string), "%s%d", string, Player[playerid][CarMod7][i]);
					strcat(string, "|");
				}
				SavePlayerString(Query, Player[playerid][DatabaseID], "CarMod7", string);

				string[0] = 0;
				for(new i; i < MAX_PLAYER_VEHICLES; i++)
				{
					format(string, sizeof(string), "%s%d", string, Player[playerid][CarMod8][i]);
					strcat(string, "|");
				}
				SavePlayerString(Query, Player[playerid][DatabaseID], "CarMod8", string);

				string[0] = 0;
				for(new i; i < MAX_PLAYER_VEHICLES; i++)
				{
					format(string, sizeof(string), "%s%d", string, Player[playerid][CarMod9][i]);
					strcat(string, "|");
				}
				SavePlayerString(Query, Player[playerid][DatabaseID], "CarMod9", string);

				string[0] = 0;
				for(new i; i < MAX_PLAYER_VEHICLES; i++)
				{
					format(string, sizeof(string), "%s%d", string, Player[playerid][CarMod10][i]);
					strcat(string, "|");
				}
				SavePlayerString(Query, Player[playerid][DatabaseID], "CarMod10", string);

				string[0] = 0;
				for(new i; i < MAX_PLAYER_VEHICLES; i++)
				{
					format(string, sizeof(string), "%s%d", string, Player[playerid][CarMod11][i]);
					strcat(string, "|");
				}
				SavePlayerString(Query, Player[playerid][DatabaseID], "CarMod11", string);

				string[0] = 0;
				for(new i; i < MAX_PLAYER_VEHICLES; i++)
				{
					format(string, sizeof(string), "%s%d", string, Player[playerid][CarMod12][i]);
					strcat(string, "|");
				}
				SavePlayerString(Query, Player[playerid][DatabaseID], "CarMod12", string);

				string[0] = 0;
				for(new i; i < MAX_PLAYER_VEHICLES; i++)
				{
					format(string, sizeof(string), "%s%d", string, Player[playerid][CarMod13][i]);
					strcat(string, "|");
				}
				SavePlayerString(Query, Player[playerid][DatabaseID], "CarMod13", string);

				string[0] = 0;
				for(new i; i < MAX_PLAYER_VEHICLES; i++)
				{
					format(string, sizeof(string), "%s%d", string, Player[playerid][CarPaintJob][i]);
					strcat(string, "|");
				}
				SavePlayerString(Query, Player[playerid][DatabaseID], "PaintJob", string);

				SavePlayerInteger(Query, Player[playerid][DatabaseID], "Fightstyle", Player[playerid][Fightstyle]);
				SavePlayerInteger(Query, Player[playerid][DatabaseID], "JailTime", Player[playerid][JailTime]);
				SavePlayerInteger(Query, Player[playerid][DatabaseID], "ArrestedBy", Player[playerid][ArrestedBy]);
				SavePlayerInteger(Query, Player[playerid][DatabaseID], "TotalCrimes", Player[playerid][TotalCrimes]);
				SavePlayerInteger(Query, Player[playerid][DatabaseID], "TotalArrests", Player[playerid][TotalArrests]);
				SavePlayerInteger(Query, Player[playerid][DatabaseID], "Crimes", Player[playerid][Crimes]);

				SavePlayerInteger(Query, Player[playerid][DatabaseID], "Speedo", Player[playerid][Speedo]);
				SavePlayerInteger(Query, Player[playerid][DatabaseID], "OnDuty", Player[playerid][OnDuty]);
				SavePlayerInteger(Query, Player[playerid][DatabaseID], "Injured", Player[playerid][Injured]);
				SavePlayerInteger(Query, Player[playerid][DatabaseID], "Job", Player[playerid][PlayerJob]);

				string[0] = 0;
				for(new i = 0; i < MAX_JOBS; i++)
				{
					format(string, sizeof(string), "%s%d", string, Player[playerid][JobSkill][i]);
					strcat(string, "|");
				}
				SavePlayerString(Query, Player[playerid][DatabaseID], "JobSkill", string);

				SavePlayerInteger(Query, Player[playerid][DatabaseID], "Materials", Player[playerid][Materials]);
				SavePlayerInteger(Query, Player[playerid][DatabaseID], "Pot", Player[playerid][Drugs][0]);
				SavePlayerInteger(Query, Player[playerid][DatabaseID], "Crack", Player[playerid][Drugs][1]);
				SavePlayerInteger(Query, Player[playerid][DatabaseID], "ConnectedSeconds", Player[playerid][ConnectedSeconds]);
				SavePlayerInteger(Query, Player[playerid][DatabaseID], "Hours", Player[playerid][PlayingHours]);

    			SQLPlayerSaveFinish(Query, Player[playerid][DatabaseID]);
    		}
	    }
	}
	return 1;
}

SQLPlayerSaveFinish(query[], sqlplayerid)
{
	if (strcmp(query, "WHERE id=", false) == 0) mysql_tquery(SQL, query, "", "");
	else
	{
		new whereclause[32];
		format(whereclause, sizeof(whereclause), " WHERE DatabaseID=%d", sqlplayerid);
		strcat(query, whereclause, 2048);
		mysql_tquery(SQL, query, "", "");
		format(query, 2048, "UPDATE `accounts` SET ");
	}
	return 1;
}

SQLString(query[], sqlplayerid)
{
	new querylen = strlen(query);
	if (!query[0]) {
		format(query, 2048, "UPDATE `accounts` SET ");
	}
	else if (2048-querylen < 200)
	{
		new whereclause[32];
		format(whereclause, sizeof(whereclause), " WHERE `id`=%d", sqlplayerid);
		strcat(query, whereclause, 2048);
		mysql_tquery(SQL, query, "", "");
		format(query, 2048, "UPDATE `accounts` SET ");
	}
	else if (strfind(query, "=", true) != -1) strcat(query, ",", 2048);
	return 1;
}

SavePlayerInteger(query[], sqlid, Value[], Integer)
{
	SQLString(query, sqlid);
	new updval[64];
	format(updval, sizeof(updval), "`%s`=%d", Value, Integer);
	strcat(query, updval, 2048);
	return 1;
}


SavePlayerString(query[], sqlid, Value[], String[])
{
	SQLString(query, sqlid);
	new escapedstring[160], string[160];
	mysql_real_escape_string(String, escapedstring);
	format(string, sizeof(string), "`%s`='%s'", Value, escapedstring);
	strcat(query, string, 2048);
	return 1;
}

SavePlayerFloat(query[], sqlid, Value[], Float:Number)
{
	new flotostr[32];
	format(flotostr, sizeof(flotostr), "%0.2f", Number);
	SavePlayerString(query, sqlid, Value, flotostr);
	return 1;
}

SaveAllData()
{
	for(new i; i < MAX_PLAYERS; i++) SavePlayerData(i, 1);
	SaveServer();
	SaveGroups();
	SaveHouses();
	SaveDoors();
	SaveBusinesses();
	SaveVehicles();
	SaveDealershipVehicles();
	SaveArrestPoints();
	SaveLockers();
	SaveGates();
	SaveJobs();
	SaveCrimes();
	SavePoints();
}

ServerRestart()
{
	for(new i; i < MAX_PLAYERS; i++)
	{
		if(Player[i][AdminDuty] >= 1)
		{
			SetPlayerName(i, Player[i][Username]);
		}
	}

	SaveAllData();
	SendRconCommand("gmx");
	return 1;
}

SaveServer()
{
    Array[0] = 0;

    format(Array, sizeof Array, "UPDATE `server` SET \
        `X` = '%f', `Y` = '%f', `Z` = '%f', `A` = '%f', `Money` = '%d', `BankMoney` = '%d'",
        Spawn[0], Spawn[1], Spawn[2], Spawn[3], SpawnMoney[0], SpawnMoney[1]
    );
    mysql_tquery(SQL, Array, "", "");
    return 1;
}

forward InitiateServer();
public InitiateServer()
{
    new rows, fields;
    
    cache_get_data(rows, fields);
    Spawn[0] = cache_get_field_content_float(0, "X", SQL);
    Spawn[1] = cache_get_field_content_float(0, "Y", SQL);
    Spawn[2] = cache_get_field_content_float(0, "Z", SQL);
    Spawn[3] = cache_get_field_content_float(0, "A", SQL);

    SpawnMoney[0] = cache_get_field_content_int(0, "Money", SQL);
    SpawnMoney[1] = cache_get_field_content_int(0, "BankMoney", SQL);

    printf("[SCRIPT-LOAD] The script initiated the server properties.");
}