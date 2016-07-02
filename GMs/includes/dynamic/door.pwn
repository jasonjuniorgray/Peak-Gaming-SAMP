CMD:nextdoor(playerid, params[])
{
	if(Player[playerid][AdminLevel] >= 5)
	{
		for(new i; i < MAX_DOORS; i++)
		{
		    if(Door[i][DoorPos][0] == 0.0) 
		    {
		        Array[0] = 0;
		        format(Array, sizeof(Array), "The next available door ID is %d.", i);
		        SendClientMessage(playerid, WHITE, Array);
		        break;
			}
		}
	}
	else SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
	return 1;
}

CMD:doorname(playerid, params[])
{
	new id, usage[36];
	if(sscanf(params, "ds[36]", id, usage)) 
	{
		if(Player[playerid][AdminLevel] >= 5)
		{
			return SendClientMessage(playerid, WHITE, "USAGE: /doorname [id] [name]");
		}
	}
	else if(Player[playerid][AdminLevel] >= 5)
	{
		if(id < 0 || id > MAX_DOORS) return SendClientMessage(playerid, WHITE, "That is not a valid door ID!");
		Array[0] = 0;

		format(Door[id][DoorName], 36, "%s", usage);

		format(Array, sizeof(Array), "You have modified the name of door %d to %s", id, usage);
		SendClientMessage(playerid, WHITE, Array);

		format(Array, sizeof(Array), "[/DOORNAME] %s has modified door %d's name to %s", GetName(playerid), id, usage);

		Log(7, Array);
		SaveDoor(id);
	}
	else SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
	return 1;
}

CMD:editdoor(playerid, params[])
{
	new id, usage[16], amount;
	if(sscanf(params, "ds[16]D(0)", id, usage, amount)) 
	{
		if(Player[playerid][AdminLevel] >= 5)
		{
			SendClientMessage(playerid, WHITE, "USAGE: /editdoor [id] [usage] [(optional) amount]");
			return SendClientMessage(playerid, GREY, "Usages: exterior, interior, owner, group, locked, custominterior, customexterior, vehicleable, pickup, restricted, delete");
		}
	}
	else if(Player[playerid][AdminLevel] >= 5)
	{
		if(id < 0 || id > MAX_DOORS) return SendClientMessage(playerid, WHITE, "That is not a valid door ID!");
		Array[0] = 0;
		if(strcmp(usage, "exterior", true) == 0)
		{
			new Float:Pos[4];
			GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
			GetPlayerFacingAngle(playerid, Pos[3]);

			Door[id][DoorPos][0] = Pos[0];
			Door[id][DoorPos][1] = Pos[1];
			Door[id][DoorPos][2] = Pos[2];
			Door[id][DoorPos][3] = Pos[3];

			Door[id][DoorVW][0] = GetPlayerVirtualWorld(playerid);
			Door[id][DoorInt][0] = GetPlayerInterior(playerid);

			format(Array, sizeof(Array), "You have moved the exterior of door %d", id);
			SendClientMessage(playerid, WHITE, Array);

			format(Array, sizeof(Array), "[/EDITDOOR] %s has moved the exterior of door %d to X: %f, Y: %f, Z: %f", GetName(playerid), id, Pos[0], Pos[1], Pos[2]);
		}
		else if(strcmp(usage, "interior", true) == 0)
		{
			new Float:Pos[4];
			GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
			GetPlayerFacingAngle(playerid, Pos[3]);

			Door[id][DoorPos][4] = Pos[0];
			Door[id][DoorPos][5] = Pos[1];
			Door[id][DoorPos][6] = Pos[2];
			Door[id][DoorPos][7] = Pos[3];

			Door[id][DoorVW][1] = GetPlayerVirtualWorld(playerid);
			Door[id][DoorInt][1] = GetPlayerInterior(playerid);

			format(Array, sizeof(Array), "You have moved the interior of door %d", id);
			SendClientMessage(playerid, WHITE, Array);

			format(Array, sizeof(Array), "[/EDITDOOR] %s has moved the interior of door %d to X: %f, Y: %f, Z: %f", GetName(playerid), id, Pos[0], Pos[1], Pos[2]);
		}
		else if(strcmp(usage, "owner", true) == 0)
		{
			if(!IsPlayerConnectedEx(amount) && amount != -1) return SendClientMessage(playerid, WHITE, "That player is not connected!");
			if(amount == -1) format(Door[id][DoorOwner], MAX_PLAYER_NAME, "Nobody");
			else format(Door[id][DoorOwner], MAX_PLAYER_NAME, "%s", GetName(amount));

			format(Array, sizeof(Array), "You have modified the owner of door %d to %s", id, Door[id][DoorOwner]);
			SendClientMessage(playerid, WHITE, Array);

			format(Array, sizeof(Array), "[/EDITDOOR] %s has modified the owner of door %d to %s", GetName(playerid), id, GetName(amount));
		}
		else if(strcmp(usage, "group", true) == 0)
		{
			Door[id][DoorGroup] = amount;

			format(Array, sizeof(Array), "You have modified the group of door %d to %d", id, amount);
			SendClientMessage(playerid, WHITE, Array);

			format(Array, sizeof(Array), "[/EDITDOOR] %s has modified the group of door %d to %d", GetName(playerid), id, amount);
		}
		else if(strcmp(usage, "locked", true) == 0)
		{
			if(amount < 0 || amount > 1) return SendClientMessage(playerid, WHITE, "The amount is either 0 for unlocked, and 1 for locked.");
			Door[id][DoorLocked] = amount;

			format(Array, sizeof(Array), "You have modified the locked status of door %d to %d", id, amount);
			SendClientMessage(playerid, WHITE, Array);

			format(Array, sizeof(Array), "[/EDITDOOR] %s has modified the locked status of door %d to %d", GetName(playerid), id, amount);
		}
		else if(strcmp(usage, "vehicleable", true) == 0)
		{
			if(amount < 0 || amount > 1) return SendClientMessage(playerid, WHITE, "The amount is either 0 for unvehicleable, and 1 for vehicleable.");
			Door[id][Vehicleable] = amount;

			format(Array, sizeof(Array), "You have modified the vehicleable of door %d to %d", id, amount);
			SendClientMessage(playerid, WHITE, Array);

			format(Array, sizeof(Array), "[/EDITDOOR] %s has modified the vehicleable of door %d to %d", GetName(playerid), id, amount);
		}
		else if(strcmp(usage, "restricted", true) == 0)
		{
			if(amount < 0 || amount > 1) return SendClientMessage(playerid, WHITE, "The amount is either 0 for unrestricted, and 1 for restricted.");
			Door[id][Restricted] = amount;

			format(Array, sizeof(Array), "You have modified the group restriction of door %d to %d", id, amount);
			SendClientMessage(playerid, WHITE, Array);

			format(Array, sizeof(Array), "[/EDITDOOR] %s has modified the restriction of door %d to %d", GetName(playerid), id, amount);
		}
		else if(strcmp(usage, "pickup", true) == 0)
		{
			Door[id][DoorPickupModel] = amount;

			format(Array, sizeof(Array), "You have modified the pickup model of door %d to %d", id, amount);
			SendClientMessage(playerid, WHITE, Array);

			format(Array, sizeof(Array), "[/EDITDOOR] %s has modified the pickup model of door %d to %d", GetName(playerid), id, amount);
		}
		else if(strcmp(usage, "customexterior", true) == 0)
		{
			if(amount < 0 || amount > 1) return SendClientMessage(playerid, WHITE, "The amount is either 0 for not custom, and 1 for custom.");
			Door[id][DoorCustom][0] = amount;

			format(Array, sizeof(Array), "You have modified the locked status of door %d to %d", id, amount);
			SendClientMessage(playerid, WHITE, Array);

			format(Array, sizeof(Array), "[/EDITDOOR] %s has modified the locked status of door %d to %d", GetName(playerid), id, amount);
		}
		else if(strcmp(usage, "custominterior", true) == 0)
		{
			if(amount < 0 || amount > 1) return SendClientMessage(playerid, WHITE, "The amount is either 0 for not custom, and 1 for custom.");
			Door[id][DoorCustom][1] = amount;

			format(Array, sizeof(Array), "You have modified the custom interior of door %d to %d", id, amount);
			SendClientMessage(playerid, WHITE, Array);

			format(Array, sizeof(Array), "[/EDITDOOR] %s has modified the custom interior of door %d to %d", GetName(playerid), id, amount);
		}
		else if(strcmp(usage, "locked", true) == 0)
		{
			if(amount < 0 || amount > 1) return SendClientMessage(playerid, WHITE, "The amount is either 0 for unlocked, and 1 for locked.");
			Door[id][DoorLocked] = amount;

			format(Array, sizeof(Array), "You have modified the locked status of door %d to %d", id, amount);
			SendClientMessage(playerid, WHITE, Array);

			format(Array, sizeof(Array), "[/EDITDOOR] %s has modified the locked status of door %d to %d", GetName(playerid), id, amount);
		}
		else if(strcmp(usage, "delete", true) == 0)
		{
			format(Door[id][DoorOwner], 50, "Nobody");
			format(Door[id][DoorName], 50, "Nothing");

			Door[id][DoorPos][0] = 0.00000;
			Door[id][DoorPos][1] = 0.00000;
			Door[id][DoorPos][2] = 0.00000;
			Door[id][DoorPos][3] = 0.00000;
			Door[id][DoorPos][4] = 0.00000;
			Door[id][DoorPos][5] = 0.00000;
			Door[id][DoorPos][6] = 0.00000;
			Door[id][DoorPos][7] = 0.00000;

			Door[id][DoorVW][0] = 0;
			Door[id][DoorInt][0] = 0;

			Door[id][DoorVW][1] = 0;
			Door[id][DoorInt][1] = 0;

			Door[id][DoorGroup] = -1;
			Door[id][DoorLocked] = 0;

			format(Array, sizeof(Array), "You have deleted door %d", id);
			SendClientMessage(playerid, WHITE, Array);

			format(Array, sizeof(Array), "[/EDITHOUSE] %s has deleted door %d", GetName(playerid), id);
		}
		else
		{
			SendClientMessage(playerid, WHITE, "USAGE: /editdoor [id] [usage] [(optional) amount]");
			return SendClientMessage(playerid, GREY, "Usages: exterior, interior, owner, group, locked, custominterior, customexterior, vehicleable, pickup, restricted, delete");
		}

		Log(7, Array);
		SaveDoor(id);
	}
	else SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
	return 1;
}

forward InitiateDoors();
public InitiateDoors()
{
    new rows, fields, doors;
    
    cache_get_data(rows, fields);
    for(new row; row < MAX_DOORS; row++)
    {        
        cache_get_field_content(row, "Name", Door[row][DoorName], SQL, 256);
        cache_get_field_content(row, "Owner", Door[row][DoorOwner], SQL, 256);

        Door[row][DoorPos][0] = cache_get_field_content_float(row, "X", SQL);
        Door[row][DoorPos][1] = cache_get_field_content_float(row, "Y", SQL);
        Door[row][DoorPos][2] = cache_get_field_content_float(row, "Z", SQL);
        Door[row][DoorPos][3] = cache_get_field_content_float(row, "A", SQL);
        Door[row][DoorPos][4] = cache_get_field_content_float(row, "IntX", SQL);
        Door[row][DoorPos][5] = cache_get_field_content_float(row, "IntY", SQL);
        Door[row][DoorPos][6] = cache_get_field_content_float(row, "IntZ", SQL);
        Door[row][DoorPos][7] = cache_get_field_content_float(row, "IntA", SQL);

        Door[row][DoorVW][0] = cache_get_field_content_int(row, "VW", SQL);
        Door[row][DoorVW][1] = cache_get_field_content_int(row, "IntVW", SQL);

        Door[row][DoorInt][0] = cache_get_field_content_int(row, "Interior", SQL);
        Door[row][DoorInt][1] = cache_get_field_content_int(row, "IntInterior", SQL);

        Door[row][DoorGroup] = cache_get_field_content_int(row, "Group", SQL);
        Door[row][Restricted] = cache_get_field_content_int(row, "Restricted", SQL);
        Door[row][Vehicleable] = cache_get_field_content_int(row, "Vehicleable", SQL);
        Door[row][DoorLocked] = cache_get_field_content_int(row, "Locked", SQL);
        Door[row][DoorPickupModel] = cache_get_field_content_int(row, "Pickup", SQL);

        Door[row][DoorCustom][0] = cache_get_field_content_int(row, "CustomExterior", SQL);
        Door[row][DoorCustom][1] = cache_get_field_content_int(row, "CustomInterior", SQL);

        DestroyDynamicPickup(Door[row][DoorPickup]);
    	DestroyDynamic3DTextLabel(Door[row][DoorText]);
    	if(Door[row][DoorPos][0] != 0.00000 && Door[row][DoorPos][1] != 0.00000 && Door[row][DoorPos][2] != 0.00000)
   	 	{
    		if(strfind(Door[row][DoorOwner], "Nobody", true) != -1)
    		{
    			if(Door[row][DoorGroup] < 0) format(Array, sizeof(Array), "%s\nID: %d", Door[row][DoorName], row);
    			else format(Array, sizeof(Array), "%s | Owner: %s\nID: %d", Door[row][DoorName], Group[Door[row][DoorGroup]][GroupName], row);
       		}
        	else format(Array, sizeof(Array), "%s | Owner: %s\nID: %d", Door[row][DoorName], Door[row][DoorOwner], row);
       		Door[row][DoorPickup] = CreateDynamicPickup(Door[row][DoorPickupModel], 23, Door[row][DoorPos][0], Door[row][DoorPos][1], Door[row][DoorPos][2], Door[row][DoorVW][0]);
       		Door[row][DoorText] = CreateDynamic3DTextLabel(Array, WHITE, Door[row][DoorPos][0], Door[row][DoorPos][1], Door[row][DoorPos][2], 7.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, Door[row][DoorVW][0], Door[row][DoorInt][0]);
    	}

        doors++;
    }
    switch(doors)
    {
        case 0: printf("[SCRIPT-LOAD/ERR] The script initiated 0 houses.", doors);
        default: printf("[SCRIPT-LOAD] The script has initiated %d houses", doors);
    }
}

SaveDoor(id)
{
    Array[0] = 0;

    format(Array, sizeof Array, "UPDATE `doors` SET \
        `Name` = '%s', `Owner` = '%s', `X` = '%f', `Y` = '%f', `Z` = '%f', `A` = %f, `IntX` = '%f', `IntY` = '%f', `IntZ` = '%f', `IntA` = %f, \
     	`VW` = '%d', `IntVW` = '%d', `Interior` = '%d', `IntInterior` = '%d', `Group` = '%d', `Restricted` = '%d', `Vehicleable` = '%d', `Locked` = '%d', `Pickup` = '%d', \
     	`CustomExterior` = '%d', `CustomInterior` = '%d' WHERE `id` = '%d'",
     	Door[id][DoorName], Door[id][DoorOwner], Door[id][DoorPos][0], Door[id][DoorPos][1], Door[id][DoorPos][2], Door[id][DoorPos][3], Door[id][DoorPos][4], Door[id][DoorPos][5],
        Door[id][DoorPos][6], Door[id][DoorPos][7], Door[id][DoorVW][0], Door[id][DoorVW][1], Door[id][DoorInt][0], Door[id][DoorInt][1], Door[id][DoorGroup], Door[id][Restricted], Door[id][Vehicleable], 
        Door[id][DoorLocked], Door[id][DoorPickupModel], Door[id][DoorCustom][0], Door[id][DoorCustom][1], id + 1
    );
    mysql_tquery(SQL, Array, "", "");

    DestroyDynamicPickup(Door[id][DoorPickup]);
    DestroyDynamic3DTextLabel(Door[id][DoorText]);
    if(Door[id][DoorPos][0] != 0.00000 && Door[id][DoorPos][1] != 0.00000 && Door[id][DoorPos][2] != 0.00000)
    {
    	if(strfind(Door[id][DoorOwner], "Nobody", true) != -1)
    	{
    		if(Door[id][DoorGroup] < 0) format(Array, sizeof(Array), "%s\nID: %d", Door[id][DoorName], id);
    		else format(Array, sizeof(Array), "%s | Owner: %s\nID: %d", Door[id][DoorName], Group[Door[id][DoorGroup]][GroupName], id);
       	}
        else format(Array, sizeof(Array), "%s | Owner: %s\nID: %d", Door[id][DoorName], Door[id][DoorOwner], id);
       	Door[id][DoorPickup] = CreateDynamicPickup(Door[id][DoorPickupModel], 23, Door[id][DoorPos][0], Door[id][DoorPos][1], Door[id][DoorPos][2], Door[id][DoorVW][0]);
       	Door[id][DoorText] = CreateDynamic3DTextLabel(Array, WHITE, Door[id][DoorPos][0], Door[id][DoorPos][1], Door[id][DoorPos][2], 7.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, Door[id][DoorVW][0], Door[id][DoorInt][0]);
    }
    return 1;
}

SaveDoors() { for(new i; i < MAX_DOORS; i++) SaveDoor(i); }