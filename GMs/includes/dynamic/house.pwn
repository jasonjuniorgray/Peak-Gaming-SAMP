CMD:buyhouse(playerid, params[])
{
	for(new i; i < MAX_HOUSES; i++)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.0, House[i][HousePos][0], House[i][HousePos][1], House[i][HousePos][2]))
		{
			if(House[i][Price] >= 0)
			{
				if(Player[playerid][Money] >= House[i][Price])
				{
					Array[0] = 0;
					format(House[i][Owner], MAX_PLAYER_NAME, "%s", GetName(playerid));
					House[i][Owned] = 1;

					SaveHouse(i);

					format(Array, sizeof(Array), "You have bought house %d! Congratulations!", i);
					SendClientMessage(playerid, WHITE, Array);
					break;
				}
				else return SendClientMessage(playerid, WHITE, "You do not have enough money!");
			}
			else return SendClientMessage(playerid, WHITE, "You cannot buy this house!");
		}
	}
	return 1;
}

CMD:nexthouse(playerid, params[])
{
	if(Player[playerid][AdminLevel] >= 5)
	{
		for(new i; i < MAX_HOUSES; i++)
		{
		    if(House[i][HousePos][0] == 0.0) 
		    {
		        Array[0] = 0;
		        format(Array, sizeof(Array), "The next available house ID is %d.", i);
		        SendClientMessage(playerid, WHITE, Array);
		        break;
			}
		}
	}
	else SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
	return 1;
}

CMD:edithouse(playerid, params[])
{
	new id, usage[16], amount;
	if(sscanf(params, "ds[16]D(0)", id, usage, amount)) 
	{
		if(Player[playerid][AdminLevel] >= 5)
		{
			SendClientMessage(playerid, WHITE, "USAGE: /edithouse [id] [usage] [(optional) amount]");
			return SendClientMessage(playerid, GREY, "Usages: exterior, interior, owner, price, locked, custominterior, customexterior, sell, delete");
		}
	}
	else if(Player[playerid][AdminLevel] >= 5)
	{
		if(id < 0 || id > MAX_HOUSES) return SendClientMessage(playerid, WHITE, "That is not a valid house ID!");
		Array[0] = 0;
		if(strcmp(usage, "exterior", true) == 0)
		{
			new Float:Pos[4];
			GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
			GetPlayerFacingAngle(playerid, Pos[3]);

			House[id][HousePos][0] = Pos[0];
			House[id][HousePos][1] = Pos[1];
			House[id][HousePos][2] = Pos[2];
			House[id][HousePos][3] = Pos[3];

			House[id][HouseVW][0] = GetPlayerVirtualWorld(playerid);
			House[id][HouseInt][0] = GetPlayerInterior(playerid);

			format(Array, sizeof(Array), "You have moved the exterior of house %d", id);
			SendClientMessage(playerid, WHITE, Array);

			format(Array, sizeof(Array), "[/EDITHOUSE] %s has moved the exterior of house %d to X: %f, Y: %f, Z: %f", GetName(playerid), id, Pos[0], Pos[1], Pos[2]);
		}
		else if(strcmp(usage, "interior", true) == 0)
		{
			new Float:Pos[4];
			GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
			GetPlayerFacingAngle(playerid, Pos[3]);

			House[id][HousePos][4] = Pos[0];
			House[id][HousePos][5] = Pos[1];
			House[id][HousePos][6] = Pos[2];
			House[id][HousePos][7] = Pos[3];

			House[id][HouseVW][1] = GetPlayerVirtualWorld(playerid);
			House[id][HouseInt][1] = GetPlayerInterior(playerid);

			format(Array, sizeof(Array), "You have moved the interior of house %d", id);
			SendClientMessage(playerid, WHITE, Array);

			format(Array, sizeof(Array), "[/EDITHOUSE] %s has moved the interior of house %d to X: %f, Y: %f, Z: %f", GetName(playerid), id, Pos[0], Pos[1], Pos[2]);
		}
		else if(strcmp(usage, "owner", true) == 0)
		{
			if(!IsPlayerConnectedEx(amount)) return SendClientMessage(playerid, WHITE, "That player is not connected!");

			format(House[id][Owner], MAX_PLAYER_NAME, "%s", GetName(amount));
			House[id][Owned] = 1;

			format(Array, sizeof(Array), "You have modified the owner of house %d to %s", id, GetName(amount));
			SendClientMessage(playerid, WHITE, Array);

			format(Array, sizeof(Array), "[/EDITHOUSE] %s has modified the owner of house %d to %s", GetName(playerid), id, GetName(amount));
		}
		else if(strcmp(usage, "price", true) == 0)
		{
			House[id][Price] = amount;

			format(Array, sizeof(Array), "You have modified the price of house %d to %d", id, amount);
			SendClientMessage(playerid, WHITE, Array);

			format(Array, sizeof(Array), "[/EDITHOUSE] %s has modified the price of house %d to %d", GetName(playerid), id, amount);
		}
		else if(strcmp(usage, "locked", true) == 0)
		{
			if(amount < 0 || amount > 1) return SendClientMessage(playerid, WHITE, "The amount is either 0 for unlocked, and 1 for locked.");
			House[id][Locked] = amount;

			format(Array, sizeof(Array), "You have modified the locked status of house %d to %d", id, amount);
			SendClientMessage(playerid, WHITE, Array);

			format(Array, sizeof(Array), "[/EDITHOUSE] %s has modified the locked status of house %d to %d", GetName(playerid), id, amount);
		}
		else if(strcmp(usage, "customexterior", true) == 0)
		{
			if(amount < 0 || amount > 1) return SendClientMessage(playerid, WHITE, "The amount is either 0 for not custom, and 1 for custom.");
			House[id][Custom][0] = amount;

			format(Array, sizeof(Array), "You have modified the custom exterior status of house %d to %d", id, amount);
			SendClientMessage(playerid, WHITE, Array);

			format(Array, sizeof(Array), "[/EDITHOUSE] %s has modified the custom exterior status of house %d to %d", GetName(playerid), id, amount);
		}
		else if(strcmp(usage, "custominterior", true) == 0)
		{
			if(amount < 0 || amount > 1) return SendClientMessage(playerid, WHITE, "The amount is either 0 for not custom, and 1 for custom.");
			House[id][Custom][1] = amount;

			format(Array, sizeof(Array), "You have modified the custom interior status of house %d to %d", id, amount);
			SendClientMessage(playerid, WHITE, Array);

			format(Array, sizeof(Array), "[/EDITHOUSE] %s has modified the custom interior status of house %d to %d", GetName(playerid), id, amount);
		}
		else if(strcmp(usage, "sell", true) == 0)
		{
			format(House[id][Owner], MAX_PLAYER_NAME, "Nobody");
			House[id][Owned] = 0;

			format(Array, sizeof(Array), "You have modified the owner of house %d to Nobody", id);
			SendClientMessage(playerid, WHITE, Array);

			format(Array, sizeof(Array), "[/EDITHOUSE] %s has modified the owner of house %d to Nobody", GetName(playerid), id);
		}
		else if(strcmp(usage, "delete", true) == 0)
		{
			format(House[id][Owner], 50, "Nobody");
			
			House[id][HousePos][0] = 0.0000;
			House[id][HousePos][1] = 0.0000;
			House[id][HousePos][2] = 0.0000;
			House[id][HousePos][3] = 0.0000;
			House[id][HousePos][4] = 0.0000;
			House[id][HousePos][5] = 0.0000;
			House[id][HousePos][6] = 0.0000;
			House[id][HousePos][7] = 0.0000;

			House[id][HouseVW][0] = 0;
			House[id][HouseInt][0] = 0;

			House[id][HouseVW][1] = 0;
			House[id][HouseInt][1] = 0;

			House[id][Price] = -1;
			House[id][Locked] = 0;

			format(Array, sizeof(Array), "You have deleted house %d", id);
			SendClientMessage(playerid, WHITE, Array);

			format(Array, sizeof(Array), "[/EDITHOUSE] %s has deleted house %d", GetName(playerid), id);
		}
		else
		{
			SendClientMessage(playerid, WHITE, "USAGE: /edithouse [id] [usage] [(optional) amount]");
			return SendClientMessage(playerid, GREY, "Usages: exterior, interior, owner, price, locked, custominterior, customexterior, sell");
		}

		Log(4, Array);
		SaveHouse(id);
	}
	else SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
	return 1;
}

forward InitiateHouses();
public InitiateHouses()
{
    new rows, fields, houses;
    
    cache_get_data(rows, fields);
    for(new row; row < MAX_HOUSES; row++)
    {        
        cache_get_field_content(row, "Owner", House[row][Owner], SQL, 256);

        House[row][Owned] = cache_get_field_content_int(row, "Owned", SQL);
        House[row][HousePos][0] = cache_get_field_content_float(row, "X", SQL);
        House[row][HousePos][1] = cache_get_field_content_float(row, "Y", SQL);
        House[row][HousePos][2] = cache_get_field_content_float(row, "Z", SQL);
        House[row][HousePos][3] = cache_get_field_content_float(row, "A", SQL);
        House[row][HousePos][4] = cache_get_field_content_float(row, "IntX", SQL);
        House[row][HousePos][5] = cache_get_field_content_float(row, "IntY", SQL);
        House[row][HousePos][6] = cache_get_field_content_float(row, "IntZ", SQL);
        House[row][HousePos][7] = cache_get_field_content_float(row, "IntA", SQL);

        House[row][HouseVW][0] = cache_get_field_content_int(row, "VW", SQL);
        House[row][HouseVW][1] = cache_get_field_content_int(row, "IntVW", SQL);

        House[row][HouseInt][0] = cache_get_field_content_int(row, "Interior", SQL);
        House[row][HouseInt][1] = cache_get_field_content_int(row, "IntInterior", SQL);

        House[row][Price] = cache_get_field_content_int(row, "Price", SQL);
        House[row][Locked] = cache_get_field_content_int(row, "Locked", SQL);

        House[row][Custom][0] = cache_get_field_content_int(row, "CustomExterior", SQL);
        House[row][Custom][1] = cache_get_field_content_int(row, "CustomInterior", SQL);

        DestroyDynamicPickup(House[row][HousePickup]);
        DestroyDynamic3DTextLabel(House[row][HouseText]);
        switch(House[row][Owned])
    	{
       		case 0: 
       		{
       			if(House[row][HousePos][0] != 0.00000 && House[row][HousePos][1] != 0.00000 && House[row][HousePos][2] != 0.00000)
       			{
       				format(Array, sizeof(Array), "House %d\nOwner: Nobody\nAvailable for $%s\n(( /buyhouse ))", row, FormatNumberToString(House[row][Price]));
       				House[row][HousePickup] = CreateDynamicPickup(1273, 23, House[row][HousePos][0], House[row][HousePos][1], House[row][HousePos][2], House[row][HouseVW][0]);
       				House[row][HouseText] = CreateDynamic3DTextLabel(Array, WHITE, House[row][HousePos][0], House[row][HousePos][1], House[row][HousePos][2], 7.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, House[row][HouseVW], House[row][HouseInt]);
       			}
       		}
        	default: 
        	{
        		if(House[row][HousePos][0] != 0.00000 && House[row][HousePos][1] != 0.00000 && House[row][HousePos][2] != 0.00000)
        		{
        			format(Array, sizeof(Array), "House %d\nOwner: %s", row, House[row][Owner]);
        			House[row][HousePickup] = CreateDynamicPickup(1272, 23, House[row][HousePos][0], House[row][HousePos][1], House[row][HousePos][2], House[row][HouseVW][0]);
        			House[row][HouseText] = CreateDynamic3DTextLabel(Array, WHITE, House[row][HousePos][0], House[row][HousePos][1], House[row][HousePos][2], 7.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, House[row][HouseVW], House[row][HouseInt]);
        		}
        	}
    	}

        houses++;
    }
    switch(houses)
    {
        case 0: printf("[SCRIPT-LOAD/ERR] The script initiated 0 houses.", houses);
        default: printf("[SCRIPT-LOAD] The script has initiated %d houses", houses);
    }
}

SaveHouse(id)
{
    Array[0] = 0;

    format(Array, sizeof Array, "UPDATE `houses` SET \
        `Owned` = '%d', `Owner` = '%s', `X` = '%f', `Y` = '%f', `Z` = '%f', `A` = %f, `IntX` = '%f', `IntY` = '%f', `IntZ` = '%f', `IntA` = %f, \
     	`VW` = '%d', `IntVW` = '%d', `Interior` = '%d', `IntInterior` = '%d', `Price` = '%d', `Locked` = '%d', `CustomExterior` = '%d', `CustomInterior` = '%d' WHERE `id` = '%d'",
        House[id][Owned], House[id][Owner], House[id][HousePos][0], House[id][HousePos][1], House[id][HousePos][2], House[id][HousePos][3], House[id][HousePos][4], House[id][HousePos][5],
        House[id][HousePos][6], House[id][HousePos][7], House[id][HouseVW][0], House[id][HouseVW][1], House[id][HouseInt][0], House[id][HouseInt][1], House[id][Price], House[id][Locked], 
        House[id][Custom][0], House[id][Custom][1], id + 1
    );
    mysql_tquery(SQL, Array, "", "");

    DestroyDynamicPickup(House[id][HousePickup]);
    DestroyDynamic3DTextLabel(House[id][HouseText]);
    switch(House[id][Owned])
    {
       	case 0: 
       	{
       		if(House[id][HousePos][0] != 0.00000 && House[id][HousePos][1] != 0.00000 && House[id][HousePos][2] != 0.00000)
       		{
       			format(Array, sizeof(Array), "House %d\nOwner: Nobody\nAvailable for $%s\n(( /buyhouse ))", id, FormatNumberToString(House[id][Price]));
       			House[id][HousePickup] = CreateDynamicPickup(1273, 23, House[id][HousePos][0], House[id][HousePos][1], House[id][HousePos][2], House[id][HouseVW][0]);
       			House[id][HouseText] = CreateDynamic3DTextLabel(Array, WHITE, House[id][HousePos][0], House[id][HousePos][1], House[id][HousePos][2], 7.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, House[id][HouseVW], House[id][HouseInt]);
       		}
       	}
        default: 
        {
        	if(House[id][HousePos][0] != 0.00000 && House[id][HousePos][1] != 0.00000 && House[id][HousePos][2] != 0.00000)
        	{
        		format(Array, sizeof(Array), "House %d\nOwner: %s", id, House[id][Owner]);
        		House[id][HousePickup] = CreateDynamicPickup(1272, 23, House[id][HousePos][0], House[id][HousePos][1], House[id][HousePos][2], House[id][HouseVW][0]);
        		House[id][HouseText] = CreateDynamic3DTextLabel(Array, WHITE, House[id][HousePos][0], House[id][HousePos][1], House[id][HousePos][2], 7.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, House[id][HouseVW], House[id][HouseInt]);
        	}
        }
    }
    return 1;
}

SaveHouses() { for(new i; i < MAX_HOUSES; i++) SaveHouse(i); }