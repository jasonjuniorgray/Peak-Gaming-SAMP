#include <YSI\y_hooks>

CMD:createdealershipvehicle(playerid, params[])
{
	new bid, model;
	if(sscanf(params, "dd", bid, model))
	{
	    if(Player[playerid][AdminLevel] >= 5)
	    {
			return SendClientMessage(playerid, WHITE, "SYNTAX: /createdealershipvehicle [dealership id] [model]");
		}
		else return SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
	}
	if(Player[playerid][AdminLevel] >= 5)
	{
        if(Business[bid][BizType] != 3) return SendClientMessage(playerid, WHITE, "That business is not a dealership.");
		new id = FindNextDealerVehicle();
		if(id != -1 && id <= MAX_VEHICLES)
		{
			new Float:Pos[4];
			GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
			GetPlayerFacingAngle(playerid, Pos[3]);

			Dealership[id][DealerVehID] = CreateVehicle(model, Pos[0], Pos[1], Pos[2], Pos[3], 0, 0, -1);

            Dealership[id][DealerModel] = model;

            Dealership[id][DealerBiz] = bid;

            Dealership[id][DealerVehPos][0] = Pos[0];
            Dealership[id][DealerVehPos][1] = Pos[1];
            Dealership[id][DealerVehPos][2] = Pos[2];
            Dealership[id][DealerVehPos][3] = Pos[3];

			SetVehicleVirtualWorld(Dealership[id][DealerVehID], GetPlayerVirtualWorld(playerid));
			Dealership[id][DealerVehVW] = GetPlayerVirtualWorld(playerid);

			LinkVehicleToInterior(Dealership[id][DealerVehID], GetPlayerInterior(playerid));
			Dealership[id][DealerVehInt] = GetPlayerInterior(playerid);

            Dealership[id][DealerDatabaseID] = id;

            Fuel[Dealership[id][DealerVehID]] = -1;

			SaveDealershipVehicle(id);

			format(Array, sizeof(Array), "%s\n$%s", VehicleNames[Dealership[id][DealerModel] - 400], FormatNumberToString(Dealership[id][DealershipPrice]));
        	Dealership[id][DealerTextID] = CreateDynamic3DTextLabel(Array, WHITE, 0.0, 0.0, 0.0, 7.0, INVALID_PLAYER_ID, Dealership[id][DealerVehID], 0, Dealership[id][DealerVehVW], Dealership[id][DealerVehInt]);
    	}
        Array[0] = 0;

        format(Array, sizeof(Array), "[/CREATEDEALERSHIPVEHICLE] %s has created vehicle %d.", GetName(playerid), id);
        Log(2, Array);
	}
	return 1;
}

CMD:editdealershipvehicle(playerid, params[])
{
    new id, usage[16];
    if(sscanf(params, "ds[16]D(0)", id, usage)) 
    {
        if(Player[playerid][AdminLevel] >= 5)
        {
            SendClientMessage(playerid, WHITE, "USAGE: /editdealershipvehicle [id] [usage]");
            return SendClientMessage(playerid, GREY, "Usages: spawn, delete");
        }
    }
    else if(Player[playerid][AdminLevel] >= 5)
    {
        new rid = GetRealDealerVehicleID(id);

        if(id < 1 || id > MAX_VEHICLES) return SendClientMessage(playerid, WHITE, "That is not a valid vehicle ID!");
        if(Dealership[rid][DealerModel] == 0) return SendClientMessage(playerid, WHITE, "That is not a valid dealership vehicle ID!");

        Array[0] = 0;
        if(strcmp(usage, "spawn", true) == 0)
        {
            if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, WHITE, "You must be in a vehicle to edit the spawn!");
            new Float:Pos[4];
            GetVehiclePos(GetPlayerVehicleID(playerid), Pos[0], Pos[1], Pos[2]);
            GetVehicleZAngle(GetPlayerVehicleID(playerid), Pos[3]);

            Dealership[rid][DealerVehPos][0] = Pos[0];
            Dealership[rid][DealerVehPos][1] = Pos[1];
            Dealership[rid][DealerVehPos][2] = Pos[2];
            Dealership[rid][DealerVehPos][3] = Pos[3];

            Dealership[rid][DealerVehVW] = GetPlayerVirtualWorld(playerid);
            Dealership[rid][DealerVehInt] = GetPlayerInterior(playerid);

            format(Array, sizeof(Array), "You have moved the spawn of dealer vehicle %d.", id);
            SendClientMessage(playerid, WHITE, Array);

            format(Array, sizeof(Array), "[/EDITDEALERSHIPVEHICLE] %s has moved the spawn of dealer vehicle %d to X: %f, Y: %f, Z: %f.", GetName(playerid), id, Pos[0], Pos[1], Pos[2]);
        }
        else if(strcmp(usage, "delete", true) == 0)
        {
            Dealership[rid][DealerModel] = 0;
            Dealership[rid][DealerVehID] = 0;

            Dealership[rid][DealerBiz] = 0;

            Dealership[rid][DealerVehPos][0] = 0.00000;
            Dealership[rid][DealerVehPos][1] = 0.00000;
            Dealership[rid][DealerVehPos][2] = 0.00000;
            Dealership[rid][DealerVehPos][3] = 0.00000;

            Dealership[rid][DealerVehVW] = 0;
            Dealership[rid][DealerVehInt] = 0;

            format(Array, sizeof(Array), "You have deleted dealer vehicle %d.", id);
            SendClientMessage(playerid, WHITE, Array);

            format(Array, sizeof(Array), "[/EDITDEALERSHIPVEHICLE] %s has deleted dealer vehicle %d.", GetName(playerid), id);
        }
        else
        {
            SendClientMessage(playerid, WHITE, "USAGE: /editdealershipvehicle [id] [usage]");
            return SendClientMessage(playerid, GREY, "Usages: spawn, delete");
        }

        Log(2, Array);
        RespawnDealershipVehicle(id, rid);
        SaveDealershipVehicle(rid);
    }
    else SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
    return 1;
}

GetRealDealerVehicleID(id)
{
    new realid;
    for(new i; i < MAX_VEHICLES; i++)
    {
        if(id == Dealership[i][DealerVehID])
        {
            realid = i;
        }
    }
    return realid;
}

FindNextDealerVehicle()
{
	for(new i = 1; i < MAX_VEHICLES; i++)
	{
		if(Dealership[i][DealerModel] == 0) 
		{
			return i;
		}
	}
	return -1;
}

RespawnDealershipVehicle(id, rid) 
{ 
    DestroyVehicle(id); 
    DestroyDynamic3DTextLabel(Dealership[rid][DealerTextID]);
    if(Dealership[rid][DealerModel] != 0) 
    {
    	format(Array, sizeof(Array), "%s\n$%s", VehicleNames[Dealership[rid][DealerModel] - 400], FormatNumberToString(Dealership[rid][DealershipPrice]));
        Dealership[rid][DealerVehID] = CreateVehicle(Dealership[rid][DealerModel], Dealership[rid][DealerVehPos][0], Dealership[rid][DealerVehPos][1], Dealership[rid][DealerVehPos][2], Dealership[rid][DealerVehPos][3], 0, 0, 0); 
        Dealership[rid][DealerTextID] = CreateDynamic3DTextLabel(Array, WHITE, 0.0, 0.0, 0.0, 7.0, INVALID_PLAYER_ID, Dealership[rid][DealerVehID], 0, Dealership[rid][DealerVehVW], Dealership[rid][DealerVehInt]);
        SetVehicleVirtualWorld(Dealership[rid][DealerVehID], Dealership[rid][DealerVehVW]); 
        LinkVehicleToInterior(Dealership[rid][DealerVehID], Dealership[rid][DealerVehInt]);

        Fuel[id] = -1;
    } 
    return 1;
} 

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
	switch(newstate)
	{
		case PLAYER_STATE_DRIVER:
		{
			for(new i; i < 100; i++)
			{
				if(GetPlayerVehicleID(playerid) == Dealership[i][DealerVehID])
				{
                    SetPVarInt(playerid, "BuyingVehicle", GetVehicleModel(GetPlayerVehicleID(playerid)));
                    SetPVarInt(playerid, "DealershipPrice", Dealership[GetRealDealerVehicleID(GetPlayerVehicleID(playerid))][DealershipPrice]);
					format(Array, sizeof(Array), "You are about to purchase this %s for $%s.", VehicleNames[Dealership[GetRealDealerVehicleID(GetPlayerVehicleID(playerid))][DealerModel] - 400], FormatNumberToString(Dealership[GetRealDealerVehicleID(GetPlayerVehicleID(playerid))][DealershipPrice]));
					ShowPlayerDialog(playerid, DIALOG_BUSINESS_BUYCAR, DIALOG_STYLE_MSGBOX, Array, Array, "Purchase", "Cancel");
				}
			}
		}
	}
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
        case DIALOG_BUSINESS_BUYCAR:
        {
            if(!response)
            {
                if(Player[playerid][AdminDuty] < 1) RemovePlayerFromVehicle(playerid);
                DeletePVar(playerid, "BuyingVehicle");
                return 1;
            }
            else
            {
                new slot = GetPlayerNextVehicleSlot(playerid);
                if(slot != -1)
                {
                    new model = GetPVarInt(playerid, "BuyingVehicle");
                    new biz = Dealership[GetRealDealerVehicleID(GetPlayerVehicleID(playerid))][DealerBiz];
                    DeletePVar(playerid, "BuyingVehicle");

                    if(Player[playerid][Money] < Dealership[GetRealDealerVehicleID(GetPlayerVehicleID(playerid))][DealershipPrice]) return SendClientMessage(playerid, WHITE, "You do not have enough money for this.");

                    PlayerVehicle[playerid][CarModel][slot] = model;
                    PlayerVehicle[playerid][CarX][slot] = Business[biz][CarSpawnPos][0];
                    PlayerVehicle[playerid][CarY][slot] = Business[biz][CarSpawnPos][1];
                    PlayerVehicle[playerid][CarZ][slot] = Business[biz][CarSpawnPos][2];
                    PlayerVehicle[playerid][CarA][slot] = Business[biz][CarSpawnPos][3];

                    PlayerVehicle[playerid][CarColour][slot] = 0;
                    PlayerVehicle[playerid][CarColour2][slot] = 0;

                    new license[8];
                    format(license, 8, "%s", RandomLicensePlateGenerator());

                    switch(slot)
                    {
                        case 0: format(PlayerVehicle[playerid][CarPlate1], 8, "%s", license);
                        case 1: format(PlayerVehicle[playerid][CarPlate2], 8, "%s", license);
                        case 2: format(PlayerVehicle[playerid][CarPlate3], 8, "%s", license);
                        case 3: format(PlayerVehicle[playerid][CarPlate4], 8, "%s", license);
                        case 4: format(PlayerVehicle[playerid][CarPlate5], 8, "%s", license);
                        default: return 1;
                    }

                    PlayerVehicle[playerid][CarID][slot] = CreateVehicle(PlayerVehicle[playerid][CarModel][slot], PlayerVehicle[playerid][CarX][slot], PlayerVehicle[playerid][CarY][slot], PlayerVehicle[playerid][CarZ][slot], PlayerVehicle[playerid][CarA][slot], PlayerVehicle[playerid][CarColour][slot], PlayerVehicle[playerid][CarColour2][slot], -1, 0);
                    SetVehicleNumberPlate(PlayerVehicle[playerid][CarID][slot], license);
                    SetPlayerInterior(playerid, 0);
                    SetPlayerVirtualWorld(playerid, 0);
                    SetVehicleVirtualWorld(PlayerVehicle[playerid][CarID][slot], 0);
                    LinkVehicleToInterior(PlayerVehicle[playerid][CarID][slot], 0);

                    RemovePlayerFromVehicle(playerid);
                    PutPlayerInVehicle(playerid, PlayerVehicle[playerid][CarID][slot], 0);

                    GiveMoneyEx(playerid, -GetPVarInt(playerid, "DealershipPrice"));
                    DeletePVar(playerid, "DealershipPrice");

                    Fuel[PlayerVehicle[playerid][CarID][slot]] = 100;

                    mysql_format(SQL, Array, sizeof(Array), "INSERT INTO `playervehicles` (`player`) VALUES ('%d')", Player[playerid][DatabaseID]);
                    mysql_tquery(SQL, Array, "OnPlayerPurchaseVehicle", "ii", playerid, slot);                    
                }
                else 
                {
                    if(Player[playerid][AdminDuty] < 1) RemovePlayerFromVehicle(playerid);
                    DeletePVar(playerid, "BuyingVehicle");
                    return SendClientMessage(playerid, WHITE, "You do not have any free vehicle slots. Type /deletecar if you wish to remove one.");
                }
            }
        }
    }
    return 1;
}

RandomLicensePlateGenerator()
{
    new license[8];
    new const Letters[26][] = { "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z" };

    format(license, sizeof(license), "%d%s%s%s%d", random(9), Letters[random(sizeof(Letters))], Letters[random(sizeof(Letters))], Letters[random(sizeof(Letters))], random(899)+100); // California License Plate 0XXX000
    return license;
}

forward InitiateDealershipVehicles();
public InitiateDealershipVehicles()
{
    new rows, fields, vehicles;
    
    cache_get_data(rows, fields);
    for(new row; row < 100; row++)
    {
        new id = row + 1;

        Dealership[id][DealerDatabaseID] = cache_get_field_content_int(row, "id", SQL);
        Dealership[id][DealerBiz] = cache_get_field_content_int(row, "Biz", SQL);
        Dealership[id][DealerModel] = cache_get_field_content_int(row, "Model", SQL);

        Dealership[id][DealerVehPos][0] = cache_get_field_content_float(row, "X", SQL);
        Dealership[id][DealerVehPos][1] = cache_get_field_content_float(row, "Y", SQL);
        Dealership[id][DealerVehPos][2] = cache_get_field_content_float(row, "Z", SQL);
        Dealership[id][DealerVehPos][3] = cache_get_field_content_float(row, "A", SQL);

        Dealership[id][DealerVehVW] = cache_get_field_content_int(row, "VW", SQL);
        Dealership[id][DealerVehInt] = cache_get_field_content_int(row, "Int", SQL);

        Dealership[id][DealershipPrice] = cache_get_field_content_int(row, "Price", SQL);

        if(Dealership[id][DealerModel] != 0) 
    	{
    		Array[0] = 0;
    		format(Array, sizeof(Array), "%s\nPrice: $%s", VehicleNames[Dealership[id][DealerModel]-400], FormatNumberToString(Dealership[id][DealershipPrice]));
        	Dealership[id][DealerVehID] = CreateVehicle(Dealership[id][DealerModel], Dealership[id][DealerVehPos][0], Dealership[id][DealerVehPos][1], Dealership[id][DealerVehPos][2], Dealership[id][DealerVehPos][3], 0, 0, 0); 
        	SetVehicleVirtualWorld(Dealership[id][DealerVehID], Dealership[id][DealerVehVW]); 
        	LinkVehicleToInterior(Dealership[id][DealerVehID], Dealership[id][DealerVehInt]);

        	Dealership[id][DealerTextID] = CreateDynamic3DTextLabel(Array, WHITE, Dealership[id][DealerVehPos][0], Dealership[id][DealerVehPos][1], Dealership[id][DealerVehPos][2], 8.0, INVALID_PLAYER_ID, Dealership[id][DealerVehID], 0, Dealership[id][DealerVehVW], Dealership[id][DealerVehInt]);
    	} 

        Fuel[Dealership[id][DealerVehID]] = -1;

        vehicles++;
    }
    switch(vehicles)
    {
        case 0: printf("[SCRIPT-LOAD/ERR] The script initiated 0 dealership vehicles.", vehicles);
        default: printf("[SCRIPT-LOAD] The script has initiated %d dealership vehicles", vehicles);
    }
}

SaveDealershipVehicle(id)
{
    Array[0] = 0;

    mysql_format(SQL, Array, sizeof Array, "UPDATE `dealershipvehicles` SET \
        `Model` = '%d', `Biz` = '%d', `X` = '%f', `Y` = '%f', `Z` = '%f', `A` = %f, `VW` = '%d', `Int` = '%d', `Price` = '%d' WHERE `id` = '%d'",
        Dealership[id][DealerModel], Dealership[id][DealerBiz], Dealership[id][DealerVehPos][0], Dealership[id][DealerVehPos][1], Dealership[id][DealerVehPos][2], Dealership[id][DealerVehPos][3], Dealership[id][DealerVehVW], Dealership[id][DealerVehInt], Dealership[id][DealershipPrice], Dealership[id][DealerDatabaseID]
    );
    mysql_tquery(SQL, Array, "", "");
    return 1;
}

SaveDealershipVehicles() { for(new i; i < MAX_VEHICLES; i++) SaveDealershipVehicle(i); }