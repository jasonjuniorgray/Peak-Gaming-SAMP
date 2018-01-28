CMD:buybusiness(playerid, params[])
{
	for(new i; i < MAX_BUSINESSES; i++)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.0, Business[i][BizPos][0], Business[i][BizPos][1], Business[i][BizPos][2]))
		{
			if(Business[i][BizPrice] >= 0)
			{
				if(Player[playerid][Money] >= Business[i][BizPrice])
				{
					Array[0] = 0;
					format(Business[i][BizOwner], MAX_PLAYER_NAME, "%s", GetName(playerid));
					Business[i][BizOwned] = 1;

					SaveBusiness(i);

					format(Array, sizeof(Array), "You have bought business %d! Congratulations!", i);
					SendClientMessage(playerid, WHITE, Array);
					break;
				}
				else return SendClientMessage(playerid, WHITE, "You do not have enough money!");
			}
			else return SendClientMessage(playerid, WHITE, "You cannot buy this business!");
		}
	}
	return 1;
}

CMD:nextbusiness(playerid, params[])
{
	if(Player[playerid][AdminLevel] >= 5)
	{
		for(new i; i < MAX_HOUSES; i++)
		{
		    if(Business[i][BizPos][0] == 0.0) 
		    {
		        Array[0] = 0;
		        format(Array, sizeof(Array), "The next available business ID is %d.", i);
		        SendClientMessage(playerid, WHITE, Array);
		        break;
			}
		}
	}
	else SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
	return 1;
}

CMD:businessname(playerid, params[])
{
	new id, usage[25];
	if(sscanf(params, "ds[25]", id, usage)) 
	{
		if(Player[playerid][AdminLevel] >= 5)
		{
			return SendClientMessage(playerid, WHITE, "USAGE: /businessname [id] [name]");
		}
	}
	else if(Player[playerid][AdminLevel] >= 5)
	{
		if(id < 0 || id > MAX_BUSINESSES) return SendClientMessage(playerid, WHITE, "That is not a valid business ID!");
		Array[0] = 0;

		format(Business[id][BizName], 25, "%s", usage);

		format(Array, sizeof(Array), "You have modified the name of business %d to %s", id, usage);
		SendClientMessage(playerid, WHITE, Array);

		format(Array, sizeof(Array), "[/BUSINESSNAME] %s has modified business %d's name to %s", GetName(playerid), id, usage);

		Log(6, Array);
		SaveBusiness(id);
	}
	else SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
	return 1;
}

CMD:editbusiness(playerid, params[])
{
	new id, usage[16], amount;
	if(sscanf(params, "ds[16]D(0)", id, usage, amount)) 
	{
		if(Player[playerid][AdminLevel] >= 5)
		{
			SendClientMessage(playerid, WHITE, "USAGE: /editbusiness [id] [usage] [(optional) amount]");
			return SendClientMessage(playerid, GREY, "Usages: exterior, interior, owner, price, locked, custominterior, customexterior, type, stock, carspawn, sell, delete");
		}
	}
	else if(Player[playerid][AdminLevel] >= 5)
	{
		if(id < 0 || id > MAX_BUSINESSES) return SendClientMessage(playerid, WHITE, "That is not a valid business ID!");
		Array[0] = 0;
		if(strcmp(usage, "exterior", true) == 0)
		{
			new Float:Pos[4];
			GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
			GetPlayerFacingAngle(playerid, Pos[3]);

			Business[id][BizPos][0] = Pos[0];
			Business[id][BizPos][1] = Pos[1];
			Business[id][BizPos][2] = Pos[2];
			Business[id][BizPos][3] = Pos[3];

			Business[id][BizVW][0] = GetPlayerVirtualWorld(playerid);
			Business[id][BizInt][0] = GetPlayerInterior(playerid);

			format(Array, sizeof(Array), "You have moved the exterior of business %d", id);
			SendClientMessage(playerid, WHITE, Array);

			format(Array, sizeof(Array), "[/EDITBUSINESS] %s has moved the exterior of business %d to X: %f, Y: %f, Z: %f", GetName(playerid), id, Pos[0], Pos[1], Pos[2]);
		}
		else if(strcmp(usage, "interior", true) == 0)
		{
			new Float:Pos[4];
			GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
			GetPlayerFacingAngle(playerid, Pos[3]);

			Business[id][BizPos][4] = Pos[0];
			Business[id][BizPos][5] = Pos[1];
			Business[id][BizPos][6] = Pos[2];
			Business[id][BizPos][7] = Pos[3];

			Business[id][BizVW][1] = GetPlayerVirtualWorld(playerid);
			Business[id][BizInt][1] = GetPlayerInterior(playerid);

			format(Array, sizeof(Array), "You have moved the interior of business %d", id);
			SendClientMessage(playerid, WHITE, Array);

			format(Array, sizeof(Array), "[/EDITBUSINESS] %s has moved the interior of business %d to X: %f, Y: %f, Z: %f", GetName(playerid), id, Pos[0], Pos[1], Pos[2]);
		}
		else if(strcmp(usage, "owner", true) == 0)
		{
			if(!IsPlayerConnectedEx(amount)) return SendClientMessage(playerid, WHITE, "That player is not connected!");

			format(Business[id][BizOwner], MAX_PLAYER_NAME, "%s", GetName(amount));
			Business[id][BizOwned] = 1;

			format(Array, sizeof(Array), "You have modified the owner of business %d to %s", id, GetName(amount));
			SendClientMessage(playerid, WHITE, Array);

			format(Array, sizeof(Array), "[/EDITBUSINESS] %s has modified the owner of business %d to %s", GetName(playerid), id, GetName(amount));
		}
		else if(strcmp(usage, "price", true) == 0)
		{
			Business[id][BizPrice] = amount;

			format(Array, sizeof(Array), "You have modified the price of business %d to %d", id, amount);
			SendClientMessage(playerid, WHITE, Array);

			format(Array, sizeof(Array), "[/EDITBUSINESS] %s has modified the price of business %d to %d", GetName(playerid), id, amount);
		}
		else if(strcmp(usage, "stock", true) == 0)
		{
			Business[id][Stock] = amount;

			format(Array, sizeof(Array), "You have modified the stock of business %d to %d", id, amount);
			SendClientMessage(playerid, WHITE, Array);

			format(Array, sizeof(Array), "[/EDITBUSINESS] %s has modified the stock of business %d to %d", GetName(playerid), id, amount);
		}
		else if(strcmp(usage, "locked", true) == 0)
		{
			if(amount < 0 || amount > 1) return SendClientMessage(playerid, WHITE, "The amount is either 0 for unlocked, and 1 for locked.");
			Business[id][BizLocked] = amount;

			format(Array, sizeof(Array), "You have modified the locked status of business %d to %d", id, amount);
			SendClientMessage(playerid, WHITE, Array);

			format(Array, sizeof(Array), "[/EDITBUSINESS] %s has modified the locked status of business %d to %d", GetName(playerid), id, amount);
		}
		else if(strcmp(usage, "customexterior", true) == 0)
		{
			if(amount < 0 || amount > 1) return SendClientMessage(playerid, WHITE, "The amount is either 0 for not custom, and 1 for custom.");
			Business[id][BizCustom][0] = amount;

			format(Array, sizeof(Array), "You have modified the custom exterior status of business %d to %d", id, amount);
			SendClientMessage(playerid, WHITE, Array);

			format(Array, sizeof(Array), "[/EDITBUSINESS] %s has modified the custom exterior status of business %d to %d", GetName(playerid), id, amount);
		}
		else if(strcmp(usage, "custominterior", true) == 0)
		{
			if(amount < 0 || amount > 1) return SendClientMessage(playerid, WHITE, "The amount is either 0 for not custom, and 1 for custom.");
			Business[id][BizCustom][1] = amount;

			format(Array, sizeof(Array), "You have modified the custom interior status of business %d to %d", id, amount);
			SendClientMessage(playerid, WHITE, Array);

			format(Array, sizeof(Array), "[/EDITBUSINESS] %s has modified the custom interior status of business %d to %d", GetName(playerid), id, amount);
		}
		else if(strcmp(usage, "type", true) == 0)
		{
			if(amount < 1 || amount > 6) return SendClientMessage(playerid, GREY, "Types: 1 - 24/7, 2 - Resturaunt, 3 - Dealership, 4 - Gym, 5 - Clothing Store, 6 - Gas/Store");
			Business[id][BizType] = amount;

			format(Array, sizeof(Array), "You have modified the type of business %d to %d", id, amount);
			SendClientMessage(playerid, WHITE, Array);

			format(Array, sizeof(Array), "[/EDITBUSINESS] %s has modified the locked status of business %d to %d", GetName(playerid), id, amount);
		}
		else if(strcmp(usage, "sell", true) == 0)
		{
			format(Business[id][BizOwner], MAX_PLAYER_NAME, "Nobody");
			Business[id][BizOwned] = 0;

			format(Array, sizeof(Array), "You have modified the owner of business %d to Nobody", id);
			SendClientMessage(playerid, WHITE, Array);

			format(Array, sizeof(Array), "[/EDITBUSINESS] %s has modified the owner of business %d to Nobody", GetName(playerid), id);
		}
		else if(strcmp(usage, "carspawn", true) == 0)
		{
			if(Business[id][BizType] != 3) return SendClientMessage(playerid, WHITE, "You can only do this to car dealerships.");
			new Float:Pos[4];
			GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
			GetPlayerFacingAngle(playerid, Pos[3]);

			Business[id][CarSpawnPos][0] = Pos[0];
			Business[id][CarSpawnPos][1] = Pos[1];
			Business[id][CarSpawnPos][2] = Pos[2];
			Business[id][CarSpawnPos][3] = Pos[3];

			format(Array, sizeof(Array), "You have moved business %d's carspawn location.", id);
			SendClientMessage(playerid, WHITE, Array);

			format(Array, sizeof(Array), "[/EDITBUSINESS] %s has moved the car spawn location of business %d to X: %f, Y: %f, Z: %f", GetName(playerid), id, Pos[0], Pos[1], Pos[2]);
		}
		else if(strcmp(usage, "fuelspawn", true) == 0)
		{
			if(Business[id][BizType] != 6) return SendClientMessage(playerid, WHITE, "You can only do this to gas stations.");
			new Float:Pos[3];
			GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);

			Business[id][FuelLocation][0] = Pos[0];
			Business[id][FuelLocation][1] = Pos[1];
			Business[id][FuelLocation][2] = Pos[2];

			format(Array, sizeof(Array), "You have moved business %d's fuel location.", id);
			SendClientMessage(playerid, WHITE, Array);

			format(Array, sizeof(Array), "[/EDITBUSINESS] %s has moved the fuel location of business %d to X: %f, Y: %f, Z: %f", GetName(playerid), id, Pos[0], Pos[1], Pos[2]);
		}
		else if(strcmp(usage, "delete", true) == 0)
		{
			format(Business[id][BizName], 24, "Nothing");
			format(Business[id][BizOwner], MAX_PLAYER_NAME, "Nobody");
			Business[id][BizPos][0] = 0.00000;
			Business[id][BizPos][1] = 0.00000;
			Business[id][BizPos][2] = 0.00000;
			Business[id][BizPos][3] = 0.00000;
			Business[id][BizPos][4] = 0.00000;
			Business[id][BizPos][5] = 0.00000;
			Business[id][BizPos][6] = 0.00000;
			Business[id][BizPos][7] = 0.00000;
			Business[id][CarSpawnPos][0] = 0.00000;
			Business[id][CarSpawnPos][1] = 0.00000;
			Business[id][CarSpawnPos][2] = 0.00000;
			Business[id][CarSpawnPos][3] = 0.00000;
			Business[id][FuelLocation][0] = 0.00000;
			Business[id][FuelLocation][1] = 0.00000;
			Business[id][FuelLocation][2] = 0.00000;

			Business[id][BizType] = 0;

			Business[id][BizVW][0] = 0;
			Business[id][BizInt][0] = 0;

			Business[id][BizVW][1] = 0;
			Business[id][BizInt][1] = 0;

			Business[id][BizPrice] = -1;
			Business[id][BizLocked] = 0;

			format(Array, sizeof(Array), "You have deleted business %d", id);
			SendClientMessage(playerid, WHITE, Array);

			format(Array, sizeof(Array), "[/EDITBUSINESS] %s has deleted business %d", GetName(playerid), id);
		}
		else
		{
			SendClientMessage(playerid, WHITE, "USAGE: /editbusiness [id] [usage] [(optional) amount]");
			return SendClientMessage(playerid, GREY, "Usages: exterior, interior, owner, price, type, stock, locked, custominterior, customexterior, sell");
		}

		Log(6, Array);
		SaveBusiness(id);
	}
	else SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
	return 1;
}

GetBusinessTypeName(id)
{
	new type[16];
	switch(Business[id][BizType])
	{
		case 1: format(type, 16, "24/7");
		case 2: format(type, 16, "Resturaunt");
		case 3: format(type, 16, "Car Dealership");
		case 4: format(type, 16, "Gym");
		case 5: format(type, 16, "Clothing Store");
		case 6: format(type, 16, "Fuel Station");
		default: format(type, 16, "null");
	}
	return type;
}

GetBusinessTypeIcon(id)
{
	new icon;
	switch(Business[id][BizType])
	{
		case 1: icon = 1274; // 24/7 - Dollar
		case 2: icon = 19094; // Resturaunt - Burger
		case 3: icon = 1274; // Car Dealer - Dollar
		case 4: icon = 1239; // Gym - I
		case 5: icon = 1275; // Clothing - Blue T-Shirt
		case 6: icon = 1650; // Fuel Station - Gas Can
		default: icon = 1239; // Null - I
	}
	return icon;
}

forward InitiateBusinesses();
public InitiateBusinesses()
{
    new rows, fields, businesses;
    
    cache_get_data(rows, fields);
    for(new row; row < MAX_BUSINESSES; row++)
    {        
        cache_get_field_content(row, "Owner", Business[row][BizOwner], SQL, 256);
        cache_get_field_content(row, "Name", Business[row][BizName], SQL, 256);

        Business[row][BizOwned] = cache_get_field_content_int(row, "Owned", SQL);
        Business[row][BizType] = cache_get_field_content_int(row, "Type", SQL);
        Business[row][BizPos][0] = cache_get_field_content_float(row, "X", SQL);
        Business[row][BizPos][1] = cache_get_field_content_float(row, "Y", SQL);
        Business[row][BizPos][2] = cache_get_field_content_float(row, "Z", SQL);
        Business[row][BizPos][3] = cache_get_field_content_float(row, "A", SQL);
        Business[row][BizPos][4] = cache_get_field_content_float(row, "IntX", SQL);
        Business[row][BizPos][5] = cache_get_field_content_float(row, "IntY", SQL);
        Business[row][BizPos][6] = cache_get_field_content_float(row, "IntZ", SQL);
        Business[row][BizPos][7] = cache_get_field_content_float(row, "IntA", SQL);
        Business[row][CarSpawnPos][0] = cache_get_field_content_float(row, "CarX", SQL);
        Business[row][CarSpawnPos][1] = cache_get_field_content_float(row, "CarY", SQL);
        Business[row][CarSpawnPos][2] = cache_get_field_content_float(row, "CarZ", SQL);
        Business[row][CarSpawnPos][3] = cache_get_field_content_float(row, "CarA", SQL);
        Business[row][FuelLocation][0] = cache_get_field_content_float(row, "FuelX", SQL);
        Business[row][FuelLocation][1] = cache_get_field_content_float(row, "FuelY", SQL);
        Business[row][FuelLocation][2] = cache_get_field_content_float(row, "FuelZ", SQL);

        Business[row][BizVW][0] = cache_get_field_content_int(row, "VW", SQL);
        Business[row][BizVW][1] = cache_get_field_content_int(row, "IntVW", SQL);

        Business[row][BizInt][0] = cache_get_field_content_int(row, "Interior", SQL);
        Business[row][BizInt][1] = cache_get_field_content_int(row, "IntInterior", SQL);

        Business[row][BizPrice] = cache_get_field_content_int(row, "Price", SQL);
        Business[row][BizLocked] = cache_get_field_content_int(row, "Locked", SQL);

        Business[row][Stock] = cache_get_field_content_int(row, "Stock", SQL);

        Business[row][BizCustom][0] = cache_get_field_content_int(row, "CustomExterior", SQL);
        Business[row][BizCustom][1] = cache_get_field_content_int(row, "CustomInterior", SQL);

        Array[0] = 0;
        for(new i; i < MAX_BUSINESS_ITEMS_STORE; i++) 
        {
        	format(Array, 16, "Price%d", i);
        	Business[row][ItemPrice][i] = cache_get_field_content_int(row, Array, SQL);
        }

        Array[0] = 0;
        for(new i; i < MAX_BUSINESS_ITEMS_FOOD; i++) 
        {
        	format(Array, 16, "PriceFood%d", i);
        	Business[row][FoodItemPrice][i] = cache_get_field_content_int(row, Array, SQL);
        }

        Array[0] = 0;
        for(new i; i < MAX_BUSINESS_ITEMS_GYM; i++) 
        {
        	format(Array, 16, "PriceGym%d", i);
        	Business[row][GymItemPrice][i] = cache_get_field_content_int(row, Array, SQL);
        }

        Business[row][SkinPrice] = cache_get_field_content_int(row, "SkinPrice", SQL);
        Business[row][FuelPrice] = cache_get_field_content_int(row, "FuelPrice", SQL);

        DestroyDynamicPickup(Business[row][BizPickup]);
        DestroyDynamic3DTextLabel(Business[row][BizText]);

    	if(Business[row][BizPos][0] != 0.00000 && Business[row][BizPos][1] != 0.00000 && Business[row][BizPos][2] != 0.00000)
   		{
   			switch(Business[row][BizOwned])
    		{
    			case 0: format(Array, sizeof(Array), "%s\nBusiness %d\n%s\nAvailable for $%d! (/buybusiness)", Business[row][BizName], row, GetBusinessTypeName(row), Business[row][BizPrice]);
    			default: format(Array, sizeof(Array), "%s\nBusiness %d\n%s\nOwner: %s", Business[row][BizName], row, GetBusinessTypeName(row), Business[row][BizOwner]);
    		}
    		if(Business[row][BizPrice] < 0) format(Array, sizeof(Array), "%s\nBusiness %d\n%s\nUnavailable", Business[row][BizName], row, GetBusinessTypeName(row));

        	Business[row][BizPickup] = CreateDynamicPickup(GetBusinessTypeIcon(row), 23, Business[row][BizPos][0], Business[row][BizPos][1], Business[row][BizPos][2], Business[row][BizVW][0]);
        	Business[row][BizText] = CreateDynamic3DTextLabel(Array, WHITE, Business[row][BizPos][0], Business[row][BizPos][1], Business[row][BizPos][2], 7.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, Business[row][BizVW], Business[row][BizInt]);
    		if(Business[row][BizType] == 6 && Business[row][FuelLocation][0] != 0.00000 && Business[row][FuelLocation][1] != 0.00000 && Business[row][FuelLocation][2] != 0.00000) 
        	{
        		format(Array, sizeof(Array), "Fuel Station\n$%d per unit\n(( /refuel ))", Business[row][FuelPrice]);
        		Business[row][FuelText] = CreateDynamic3DTextLabel(Array, YELLOW, Business[row][FuelLocation][0], Business[row][FuelLocation][1], Business[row][FuelLocation][2], 10.0);
        	}
    	}

        businesses++;
    }
    switch(businesses)
    {
        case 0: printf("[SCRIPT-LOAD/ERR] The script initiated 0 businesses.", businesses);
        default: printf("[SCRIPT-LOAD] The script has initiated %d businesses", businesses);
    }
}

SaveBusiness(id)
{
    Array[0] = 0;

    mysql_format(SQL, Array, sizeof Array, "UPDATE `businesses` SET \
        `Name` = '%e', `Owned` = '%d', `Owner` = '%e', `Type` = '%d', `X` = '%f', `Y` = '%f', `Z` = '%f', `A` = %f, `IntX` = '%f', `IntY` = '%f', `IntZ` = '%f', `IntA` = %f, \
     	`VW` = '%d', `IntVW` = '%d', `Interior` = '%d', `IntInterior` = '%d', `Price` = '%d', `Locked` = '%d', `Stock` = '%d', `CarX` = %f, `CarY` = %f, `CarZ` = %f, `CarA` = %f, \
     	`FuelX` = '%f', `FuelY` = '%f', `FuelZ` = '%f'",
        Business[id][BizName], Business[id][BizOwned], Business[id][BizOwner], Business[id][BizType], Business[id][BizPos][0], Business[id][BizPos][1], Business[id][BizPos][2], Business[id][BizPos][3], Business[id][BizPos][4], Business[id][BizPos][5],
        Business[id][BizPos][6], Business[id][BizPos][7], Business[id][BizVW][0], Business[id][BizVW][1], Business[id][BizInt][0], Business[id][BizInt][1], Business[id][BizPrice], Business[id][BizLocked], Business[id][Stock],
        Business[id][CarSpawnPos][0], Business[id][CarSpawnPos][1], Business[id][CarSpawnPos][2], Business[id][CarSpawnPos][3], Business[id][FuelLocation][0], Business[id][FuelLocation][1], Business[id][FuelLocation][2], id + 1
    );

    for(new i; i < MAX_BUSINESS_ITEMS_STORE; i++) format(Array, sizeof(Array), "%s, `Price%d` = '%d'", Array, i, Business[id][ItemPrice][i]);
    for(new i; i < MAX_BUSINESS_ITEMS_FOOD; i++) format(Array, sizeof(Array), "%s, `PriceFood%d` = '%d'", Array, i, Business[id][FoodItemPrice][i]);
    for(new i; i < MAX_BUSINESS_ITEMS_GYM; i++) format(Array, sizeof(Array), "%s, `PriceGym%d` = '%d'", Array, i, Business[id][GymItemPrice][i]);

    mysql_format(SQL, Array, sizeof(Array), "%s, `SkinPrice` = '%d', `FuelPrice` = '%d', `CustomExterior` = '%d', `CustomInterior` = '%d' WHERE `id` = '%d'", 
    	Array, Business[id][SkinPrice], Business[id][FuelPrice], Business[id][BizCustom][0], Business[id][BizCustom][1], id + 1);

    mysql_tquery(SQL, Array, "", "");

    DestroyDynamicPickup(Business[id][BizPickup]);
    DestroyDynamic3DTextLabel(Business[id][BizText]);
    DestroyDynamic3DTextLabel(Business[id][FuelText]);
    if(Business[id][BizPos][0] != 0.00000 && Business[id][BizPos][1] != 0.00000 && Business[id][BizPos][2] != 0.00000)
    {
    	switch(Business[id][BizOwned])
    	{
    		case 0: format(Array, sizeof(Array), "%s\nBusiness %d\n%s\nAvailable for $%d! (/buybusiness)", Business[id][BizName], id, GetBusinessTypeName(id), Business[id][BizPrice]);
    		default: format(Array, sizeof(Array), "%s\nBusiness %d\n%s\nOwner: %s", Business[id][BizName], id, GetBusinessTypeName(id), Business[id][BizOwner]);
    	}
    	if(Business[id][BizPrice] < 0) format(Array, sizeof(Array), "%s\nBusiness %d\n%s\nUnavailable", Business[id][BizName], id, GetBusinessTypeName(id));

        Business[id][BizPickup] = CreateDynamicPickup(GetBusinessTypeIcon(id), 23, Business[id][BizPos][0], Business[id][BizPos][1], Business[id][BizPos][2], Business[id][BizVW][0]);
        Business[id][BizText] = CreateDynamic3DTextLabel(Array, WHITE, Business[id][BizPos][0], Business[id][BizPos][1], Business[id][BizPos][2], 7.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, Business[id][BizVW], Business[id][BizInt]);
        if(Business[id][BizType] == 6 && Business[id][FuelLocation][0] != 0.00000 && Business[id][FuelLocation][1] != 0.00000 && Business[id][FuelLocation][2] != 0.00000) 
        {
        	format(Array, sizeof(Array), "Fuel Station\n$%d per unit\n(( /refuel ))", Business[id][FuelPrice]);
        	Business[id][FuelText] = CreateDynamic3DTextLabel(Array, YELLOW, Business[id][FuelLocation][0], Business[id][FuelLocation][1], Business[id][FuelLocation][2], 10.0);
        }
    }
    return 1;
}

SaveBusinesses() { for(new i; i < MAX_BUSINESSES; i++) SaveBusiness(i); }