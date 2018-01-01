GamemodeMySQLInitiate()
{
	Array[0] = 0;

	new File: MySQLFile = fopen("mysql.ini", io_readwrite), Host[50], User[50], DB[50], Pass[50];
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

		mysql_format(SQL, Array, sizeof(Array), "SELECT * FROM `playervehicles` WHERE `player` = '%d'", Player[playerid][DatabaseID]);
        mysql_tquery(SQL, Array, "LoadPlayerVehicles", "i", playerid);

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

public LoadPlayerVehicles(playerid)
{
	Array[0] = 0;
	new rows, fields, vehicle;
	cache_get_data(rows, fields);
	for(new row;row < rows;row++)
	{
		PlayerVehicle[playerid][CarDatabaseID][vehicle] = cache_get_field_content_int(row, "id");
		PlayerVehicle[playerid][CarModel][vehicle] = cache_get_field_content_int(row, "Model");

		PlayerVehicle[playerid][CarX][vehicle] = cache_get_field_content_float(row, "X");
		PlayerVehicle[playerid][CarY][vehicle] = cache_get_field_content_float(row, "Y");
		PlayerVehicle[playerid][CarZ][vehicle] = cache_get_field_content_float(row, "Z");
		PlayerVehicle[playerid][CarA][vehicle] = cache_get_field_content_float(row, "A");

		PlayerVehicle[playerid][CarInt][vehicle] = cache_get_field_content_int(row, "Int");
		PlayerVehicle[playerid][CarVW][vehicle] = cache_get_field_content_int(row, "VW");
		PlayerVehicle[playerid][CarColour][vehicle] = cache_get_field_content_int(row, "Colour");
		PlayerVehicle[playerid][CarColour2][vehicle] = cache_get_field_content_int(row, "Colour2");
		PlayerVehicle[playerid][CarFuel][vehicle] = cache_get_field_content_int(row, "Fuel");

		switch(vehicle)
		{
			case 0: cache_get_field_content(row, "Plate", PlayerVehicle[playerid][CarPlate1], SQL, MAX_PLAYER_NAME);
			case 1:	cache_get_field_content(row, "Plate", PlayerVehicle[playerid][CarPlate2], SQL, MAX_PLAYER_NAME);
			case 2:	cache_get_field_content(row, "Plate", PlayerVehicle[playerid][CarPlate3], SQL, MAX_PLAYER_NAME);
			case 3: cache_get_field_content(row, "Plate", PlayerVehicle[playerid][CarPlate4], SQL, MAX_PLAYER_NAME);
			case 4: cache_get_field_content(row, "Plate", PlayerVehicle[playerid][CarPlate5], SQL, MAX_PLAYER_NAME);
			default: printf("No field content for player vehicle %d.", vehicle);
		}

		PlayerVehicle[playerid][CarMod0][vehicle] = cache_get_field_content_int(row, "Mod0");
		PlayerVehicle[playerid][CarMod1][vehicle] = cache_get_field_content_int(row, "Mod1");
		PlayerVehicle[playerid][CarMod2][vehicle] = cache_get_field_content_int(row, "Mod2");
		PlayerVehicle[playerid][CarMod3][vehicle] = cache_get_field_content_int(row, "Mod3");
		PlayerVehicle[playerid][CarMod4][vehicle] = cache_get_field_content_int(row, "Mod4");
		PlayerVehicle[playerid][CarMod5][vehicle] = cache_get_field_content_int(row, "Mod5");
		PlayerVehicle[playerid][CarMod6][vehicle] = cache_get_field_content_int(row, "Mod6");
		PlayerVehicle[playerid][CarMod7][vehicle] = cache_get_field_content_int(row, "Mod7");
		PlayerVehicle[playerid][CarMod8][vehicle] = cache_get_field_content_int(row, "Mod8");
		PlayerVehicle[playerid][CarMod9][vehicle] = cache_get_field_content_int(row, "Mod9");
		PlayerVehicle[playerid][CarMod10][vehicle] = cache_get_field_content_int(row, "Mod10");
		PlayerVehicle[playerid][CarMod11][vehicle] = cache_get_field_content_int(row, "Mod11");
		PlayerVehicle[playerid][CarMod12][vehicle] = cache_get_field_content_int(row, "Mod12");
		PlayerVehicle[playerid][CarMod13][vehicle] = cache_get_field_content_int(row, "Mod13");

		if(PlayerVehicle[playerid][CarModel][vehicle] != 0)
        {
            PlayerVehicle[playerid][CarID][vehicle] = CreateVehicle(PlayerVehicle[playerid][CarModel][vehicle], PlayerVehicle[playerid][CarX][vehicle], PlayerVehicle[playerid][CarY][vehicle], PlayerVehicle[playerid][CarZ][vehicle], PlayerVehicle[playerid][CarA][vehicle], PlayerVehicle[playerid][CarColour][vehicle], PlayerVehicle[playerid][CarColour2][vehicle], -1, 0);
            switch(vehicle)
            {
                case 0: SetVehicleNumberPlate(PlayerVehicle[playerid][CarID][vehicle], PlayerVehicle[playerid][CarPlate1]);
                case 1: SetVehicleNumberPlate(PlayerVehicle[playerid][CarID][vehicle], PlayerVehicle[playerid][CarPlate2]);
                case 2: SetVehicleNumberPlate(PlayerVehicle[playerid][CarID][vehicle], PlayerVehicle[playerid][CarPlate3]);
                case 3: SetVehicleNumberPlate(PlayerVehicle[playerid][CarID][vehicle], PlayerVehicle[playerid][CarPlate4]);
                case 4: SetVehicleNumberPlate(PlayerVehicle[playerid][CarID][vehicle], PlayerVehicle[playerid][CarPlate5]);
                default: return 1;
            }

            if(PlayerVehicle[playerid][CarPaintJob][vehicle] > 0) ChangeVehiclePaintjob(PlayerVehicle[playerid][CarID][vehicle], PlayerVehicle[playerid][CarPaintJob][vehicle] - 1);

            Fuel[PlayerVehicle[playerid][CarID][vehicle]] = PlayerVehicle[playerid][CarFuel][vehicle];
        }
        AddPlayerVehicleMods(playerid);

		vehicle++;
	}
	return 1;
}

public OnPlayerRegisterAccount(playerid)
{
	Player[playerid][DatabaseID] = cache_insert_id();
    printf("[SQL] New account registered. Database ID: [%d]", cache_insert_id());
    
    SetPlayerColor(playerid, WHITE); // Grey on login, white on spawn.

    AdvanceTutorial(playerid, 1);
    return 1;
}

public OnPlayerPurchaseVehicle(playerid, vehicle) { PlayerVehicle[playerid][CarDatabaseID][vehicle] = cache_insert_id(); SavePlayerVehicleData(playerid, vehicle); }

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
	if(Player[playerid][Authenticated] <= 0) return 0;
	switch(type)
	{
	    case 1: // case: full
	    {
	    	if(Player[playerid][Authenticated] >= 1)
	    	{
	        	new Query[2048], string[128], Float:Pos[4], Float: pHealth, Float: pArmour, pIP[20];

    			GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
    			GetPlayerFacingAngle(playerid, Pos[3]);
    			GetPlayerHealth(playerid, pHealth);
    			GetPlayerArmour(playerid, pArmour);	
    			GetPlayerIp(playerid, pIP, sizeof(pIP));

    			format(Query, sizeof(Query), "UPDATE `accounts` SET ");

    			if(Player[playerid][AdminLevel] >= 1 && Player[playerid][AdminLevel] <= 4 && Player[playerid][AdminDuty] >= 1) // This make sure that anything a Senior Admin or below does to their account while on duty, does not save.
	    		{
	    			SavePlayerInteger(Query, Player[playerid][DatabaseID], "AdminSkin", Player[playerid][AdminSkin]);
	    			SavePlayerString(Query, Player[playerid][DatabaseID], "AdminName", Player[playerid][AdminName]);
	    			SavePlayerInteger(Query, Player[playerid][DatabaseID], "AdminDuty", Player[playerid][AdminDuty]);

	    			SQLPlayerSaveFinish(Query, Player[playerid][DatabaseID]);
	    			return 1;
	    		}

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

SavePlayerVehicleData(playerid, vehicle = -1)
{
	new Query[2056];
	print("zzfewsaf");
	for(new i; i < MAX_PLAYER_VEHICLES; i++)
	{
		if(i == vehicle || vehicle == -1)
		{
			printf("%d, %d, %d, %d", i, PlayerVehicle[playerid][CarID], PlayerVehicle[playerid][CarModel][i], Fuel[PlayerVehicle[playerid][CarID][i]]);
			print("zzfewsaf");
			mysql_format(SQL, Query, sizeof(Query), "UPDATE `playervehicles` SET `Model` = '%d', `X` = '%f', `Y` = '%f', `Z` = '%f', `A` = '%f', `Int` = '%d', `VW` = '%d', `Colour` = '%d', `Colour2` = '%d', `Fuel` = '%d', \
				`Mod0` = '%d', `Mod1` = '%d', `Mod2` = '%d', `Mod3` = '%d', `Mod4` = '%d', `Mod5` = '%d', `Mod6` = '%d', `Mod7` = '%d', `Mod8` = '%d', `Mod9` = '%d', `Mod10` = '%d', `Mod11` = '%d', `Mod12` = '%d' , `Mod13` = '%d' \
				WHERE `id` = '%d'",
				PlayerVehicle[playerid][CarModel][i], PlayerVehicle[playerid][CarX][i], PlayerVehicle[playerid][CarY][i], PlayerVehicle[playerid][CarZ][i], PlayerVehicle[playerid][CarA][i], PlayerVehicle[playerid][CarInt][i],
				PlayerVehicle[playerid][CarVW][i], PlayerVehicle[playerid][CarColour][i], PlayerVehicle[playerid][CarColour2][i], Fuel[PlayerVehicle[playerid][CarID][i]], PlayerVehicle[playerid][CarMod0][i], PlayerVehicle[playerid][CarMod1][i],
				PlayerVehicle[playerid][CarMod2][i], PlayerVehicle[playerid][CarMod3][i], PlayerVehicle[playerid][CarMod4][i], PlayerVehicle[playerid][CarMod5][i], PlayerVehicle[playerid][CarMod6][i], PlayerVehicle[playerid][CarMod7][i],
				PlayerVehicle[playerid][CarMod8][i], PlayerVehicle[playerid][CarMod9][i], PlayerVehicle[playerid][CarMod10][i], PlayerVehicle[playerid][CarMod11][i], PlayerVehicle[playerid][CarMod12][i], PlayerVehicle[playerid][CarMod13][i],
				PlayerVehicle[playerid][CarDatabaseID][i]);
			mysql_tquery(SQL, Query, "", "");
		}
	}

	switch(vehicle)
	{
		case 0:
		{
			mysql_format(SQL, Query, sizeof(Query), "UPDATE `playervehicles` SET `Plate` = '%e' WHERE `id` = '%d'", PlayerVehicle[playerid][CarPlate1], PlayerVehicle[playerid][CarDatabaseID][0]);
			mysql_tquery(SQL, Query, "", "");
		}
		case 1:
		{
			mysql_format(SQL, Query, sizeof(Query), "UPDATE `playervehicles` SET `Plate` = '%e' WHERE `id` = '%d'", PlayerVehicle[playerid][CarPlate2], PlayerVehicle[playerid][CarDatabaseID][1]);
			mysql_tquery(SQL, Query, "", "");
		}
		case 2:
		{
			mysql_format(SQL, Query, sizeof(Query), "UPDATE `playervehicles` SET `Plate` = '%e' WHERE `id` = '%d'", PlayerVehicle[playerid][CarPlate3], PlayerVehicle[playerid][CarDatabaseID][2]);
			mysql_tquery(SQL, Query, "", "");
		}
		case 3:
		{
			mysql_format(SQL, Query, sizeof(Query), "UPDATE `playervehicles` SET `Plate` = '%e' WHERE `id` = '%d'", PlayerVehicle[playerid][CarPlate4], PlayerVehicle[playerid][CarDatabaseID][3]);
			mysql_tquery(SQL, Query, "", "");
		}
		case 4:
		{
			mysql_format(SQL, Query, sizeof(Query), "UPDATE `playervehicles` SET `Plate` = '%e' WHERE `id` = '%d'", PlayerVehicle[playerid][CarPlate5], PlayerVehicle[playerid][CarDatabaseID][4]);
			mysql_tquery(SQL, Query, "", "");
		}
		default:
		{
			for(new i; i < MAX_PLAYER_VEHICLES; i++)
			{
				switch(i)
				{
					case 0:
					{
						mysql_format(SQL, Query, sizeof(Query), "UPDATE `playervehicles` SET `Plate` = '%e' WHERE `id` = '%d'", PlayerVehicle[playerid][CarPlate1], PlayerVehicle[playerid][CarDatabaseID][0]);
						mysql_tquery(SQL, Query, "", "");
					}
					case 1:
					{
						mysql_format(SQL, Query, sizeof(Query), "UPDATE `playervehicles` SET `Plate` = '%e' WHERE `id` = '%d'", PlayerVehicle[playerid][CarPlate2], PlayerVehicle[playerid][CarDatabaseID][1]);
						mysql_tquery(SQL, Query, "", "");
					}
					case 2:
					{
						mysql_format(SQL, Query, sizeof(Query), "UPDATE `playervehicles` SET `Plate` = '%e' WHERE `id` = '%d'", PlayerVehicle[playerid][CarPlate3], PlayerVehicle[playerid][CarDatabaseID][2]);
						mysql_tquery(SQL, Query, "", "");
					}
					case 3:
					{
						mysql_format(SQL, Query, sizeof(Query), "UPDATE `playervehicles` SET `Plate` = '%e' WHERE `id` = '%d'", PlayerVehicle[playerid][CarPlate4], PlayerVehicle[playerid][CarDatabaseID][3]);
						mysql_tquery(SQL, Query, "", "");
					}
					case 4:
					{
						mysql_format(SQL, Query, sizeof(Query), "UPDATE `playervehicles` SET `Plate` = '%e' WHERE `id` = '%d'", PlayerVehicle[playerid][CarPlate5], PlayerVehicle[playerid][CarDatabaseID][4]);
						mysql_tquery(SQL, Query, "", "");
					}
				}
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
	foreach(new i: Player) { SavePlayerData(i, 1); SavePlayerVehicleData(i); }
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
	foreach(new i: Player)
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

    mysql_format(SQL, Array, sizeof Array, "UPDATE `server` SET \
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