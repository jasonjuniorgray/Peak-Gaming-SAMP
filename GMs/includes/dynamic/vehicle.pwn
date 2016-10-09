CMD:createvehicle(playerid, params[])
{
	new model, colour[2];
	if(sscanf(params, "dD(0)D(0)", model, colour[0], colour[1]))
	{
	    if(Player[playerid][AdminLevel] >= 5)
	    {
			SendClientMessage(playerid, WHITE, "SYNTAX: /createvehicle [model] [(optional) colour] [(optional) colour]");
		}
		else return SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
	}
	if(Player[playerid][AdminLevel] >= 5)
	{
		new id = FindNextVehicle();
		if(id != -1 && id <= MAX_DYN_VEHICLES)
		{
			new Float:Pos[4];
			GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
			GetPlayerFacingAngle(playerid, Pos[3]);

			Vehicle[id][VehID] = CreateVehicle(model, Pos[0], Pos[1], Pos[2], Pos[3], colour[0], colour[1], -1);

            Vehicle[id][Model] = model;

            Vehicle[id][VehiclePos][0] = Pos[0];
            Vehicle[id][VehiclePos][1] = Pos[1];
            Vehicle[id][VehiclePos][2] = Pos[2];
            Vehicle[id][VehiclePos][3] = Pos[3];

            Vehicle[id][VehicleColour][0] = colour[0];
            Vehicle[id][VehicleColour][1] = colour[1];

			SetVehicleVirtualWorld(Vehicle[id][VehID], GetPlayerVirtualWorld(playerid));
			Vehicle[id][VehicleVW] = GetPlayerVirtualWorld(playerid);

			LinkVehicleToInterior(Vehicle[id][VehID], GetPlayerInterior(playerid));
			Vehicle[id][VehicleInt] = GetPlayerInterior(playerid);

            Vehicle[id][VehicleGroup] = -1;
            Vehicle[id][Siren] = 0;

            Vehicle[id][VehicleDatabaseID] = id;

            Vehicle[id][VehFuel] = random(20) + 10;

            Fuel[Vehicle[id][VehID]] = Vehicle[id][VehFuel];

			SaveVehicle(id);
		}
        Array[0] = 0;

        format(Array, sizeof(Array), "[/CREATEVEHICLE] %s has created vehicle %d.", GetName(playerid), id);
        Log(5, Array);
	}
	else SendClientMessage(playerid, WHITE, "You are not authorized to preform this command");
	return 1;
}

CMD:evplate(playerid, params[])
{
    new id, usage[16];
    if(sscanf(params, "dS[16]", id, usage)) 
    {
        if(Player[playerid][AdminLevel] >= 5)
        {
            SendClientMessage(playerid, WHITE, "USAGE: /evplate [id] [plate]");
            return SendClientMessage(playerid, GREY, "Plate: Enter nothing to reset the plate to the original.");
        }
    }
    else if(Player[playerid][AdminLevel] >= 5)
    {
        new rid = GetRealVehicleID(id);

        if(id < 1 || id > MAX_VEHICLES) return SendClientMessage(playerid, WHITE, "That is not a valid vehicle ID!");
        if(Vehicle[rid][Model] == 0) return SendClientMessage(playerid, WHITE, "That is not a valid dynamic vehicle ID!");

        if(strlen(usage) <= 0) format(Vehicle[rid][Plate], 16, "XYZSR998", usage);
        else format(Vehicle[rid][Plate], 16, "%s", usage);

        format(Array, sizeof(Array), "You have modified the plate of vehicle %d to %s.", id, usage);
        SendClientMessage(playerid, WHITE, Array);

        format(Array, sizeof(Array), "[/EVPLATE] %s has modified the plate of vehicle %d to %s.", GetName(playerid), id, usage);
        Log(5, Array);

        RespawnVehicle(id, rid);
        SaveVehicle(rid);
    }
    else SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
    return 1;
}

CMD:editvehicle(playerid, params[])
{
    new id, usage[16], amount;
    if(sscanf(params, "ds[16]D(0)", id, usage, amount)) 
    {
        if(Player[playerid][AdminLevel] >= 5)
        {
            SendClientMessage(playerid, WHITE, "USAGE: /editvehicle [id] [usage] [(optional) amount]");
            return SendClientMessage(playerid, GREY, "Usages: spawn, colour(1-2), group, job, siren, maxhealth, respawntime, delete");
        }
    }
    else if(Player[playerid][AdminLevel] >= 5)
    {
        new rid = GetRealVehicleID(id);

        if(id < 1 || id > MAX_VEHICLES) return SendClientMessage(playerid, WHITE, "That is not a valid vehicle ID!");
        if(Vehicle[rid][Model] == 0) return SendClientMessage(playerid, WHITE, "That is not a valid dynamic vehicle ID!");

        Array[0] = 0;
        if(strcmp(usage, "spawn", true) == 0)
        {
            if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, WHITE, "You must be in a vehicle to edit the spawn!");
            new Float:Pos[4];
            GetVehiclePos(GetPlayerVehicleID(playerid), Pos[0], Pos[1], Pos[2]);
            GetVehicleZAngle(GetPlayerVehicleID(playerid), Pos[3]);

            Vehicle[rid][VehiclePos][0] = Pos[0];
            Vehicle[rid][VehiclePos][1] = Pos[1];
            Vehicle[rid][VehiclePos][2] = Pos[2];
            Vehicle[rid][VehiclePos][3] = Pos[3];

            Vehicle[rid][VehicleVW] = GetPlayerVirtualWorld(playerid);
            Vehicle[rid][VehicleInt] = GetPlayerInterior(playerid);

            format(Array, sizeof(Array), "You have moved the spawn of vehicle %d.", id);
            SendClientMessage(playerid, WHITE, Array);

            format(Array, sizeof(Array), "[/EDITVEHICLE] %s has moved the spawn of vehicle %d to X: %f, Y: %f, Z: %f.", GetName(playerid), id, Pos[0], Pos[1], Pos[2]);
        }
        else if(strcmp(usage, "colour1", true) == 0 || strcmp(usage, "colour2", true) == 0)
        {
            if(amount < 0 || amount > 255) return SendClientMessage(playerid, WHITE, "Colour ID's start at 0 and end at 255");

            if(strcmp(usage, "colour1", true) == 0) Vehicle[rid][VehicleColour][0] = amount;
            else Vehicle[rid][VehicleColour][1] = amount;

            format(Array, sizeof(Array), "You have modified the color of vehicle %d to %d.", id, amount);
            SendClientMessage(playerid, WHITE, Array);

            format(Array, sizeof(Array), "[/EDITVEHICLE] %s has modified the colour of vehicle %d to %d.", GetName(playerid), id, amount);
        }
        else if(strcmp(usage, "group", true) == 0)
        {
            if(amount < 0 || amount > MAX_GROUPS) return SendClientMessage(playerid, WHITE, "You have specified an invalid group.");
            Vehicle[rid][VehicleGroup] = amount - 1;

            format(Array, sizeof(Array), "You have modified the group of vehicle %d to %s.", id, Group[amount - 1][GroupName]);
            SendClientMessage(playerid, WHITE, Array);

            format(Array, sizeof(Array), "[/EDITVEHICLE] %s has modified the group of vehicle %d to %s.", GetName(playerid), id, Group[amount - 1][GroupName]);
        }
        else if(strcmp(usage, "job", true) == 0)
        {
            if(amount < 0 || amount > MAX_JOBS) return SendClientMessage(playerid, WHITE, "You have specified an invalid job.");
            Vehicle[rid][VehicleJob] = amount - 1;

            format(Array, sizeof(Array), "You have modified the job of vehicle %d to %s.", id, Job[amount - 1][JobName]);
            SendClientMessage(playerid, WHITE, Array);

            format(Array, sizeof(Array), "[/EDITVEHICLE] %s has modified the job of vehicle %d to %s.", GetName(playerid), id, Job[amount - 1][JobName]);
        }
        else if(strcmp(usage, "siren", true) == 0)
        {
            if(amount < 0 || amount > 1) return SendClientMessage(playerid, WHITE, "You have specified an integer. (1 for YES, 0 for NO)");
            Vehicle[rid][Siren] = amount;

            format(Array, sizeof(Array), "You have modified the siren of vehicle %d to %d.", id, amount);
            SendClientMessage(playerid, WHITE, Array);

            format(Array, sizeof(Array), "[/EDITVEHICLE] %s has modified vehicle %d to siren type %d.", GetName(playerid), id, amount);
        }
        else if(strcmp(usage, "maxhealth", true) == 0)
        {
            if(amount < 256) return SendClientMessage(playerid, WHITE, "You cannot set a vehicle lower than 256.");
            Vehicle[rid][MaxHealth] = float(amount);

            format(Array, sizeof(Array), "You have modified the maxhealth of vehicle %d to %d.", id, amount);
            SendClientMessage(playerid, WHITE, Array);

            format(Array, sizeof(Array), "[/EDITVEHICLE] %s has modified the maxhealth of vehicle %d to %d.", GetName(playerid), id, amount);
        }
        else if(strcmp(usage, "respawntime", true) == 0)
        {
            if(amount < -1) return SendClientMessage(playerid, WHITE, "You cannot set the respawn time for less than -1.");
            Vehicle[rid][RespawnTime] = amount;

            format(Array, sizeof(Array), "You have modified the respawn time of vehicle %d to %d.", id, amount);
            SendClientMessage(playerid, WHITE, Array);

            format(Array, sizeof(Array), "[/EDITVEHICLE] %s has modified the respawn time of vehicle %d to %d.", GetName(playerid), id, amount);
        }
        else if(strcmp(usage, "delete", true) == 0)
        {
            Vehicle[rid][Model] = 0;
            Vehicle[rid][VehID] = 0;

            Vehicle[rid][VehiclePos][0] = 0.00000;
            Vehicle[rid][VehiclePos][1] = 0.00000;
            Vehicle[rid][VehiclePos][2] = 0.00000;
            Vehicle[rid][VehiclePos][3] = 0.00000;

            Vehicle[rid][VehicleVW] = 0;
            Vehicle[rid][VehicleInt] = 0;

            Vehicle[rid][VehicleJob] = -1;
            Vehicle[rid][VehicleGroup] = -1;

            Vehicle[rid][RespawnTime] = -1;
            Vehicle[rid][Siren] = 0;
            Vehicle[rid][MaxHealth] = 1000.0;

            format(Array, sizeof(Array), "You have deleted vehicle %d.", id);
            SendClientMessage(playerid, WHITE, Array);

            format(Array, sizeof(Array), "[/EDITVEHICLE] %s has deleted vehicle %d.", GetName(playerid), id);
        }
        else
        {
            SendClientMessage(playerid, WHITE, "USAGE: /editvehicle [id] [usage] [(optional) amount]");
            return SendClientMessage(playerid, GREY, "Usages: spawn, colour(1-2), group, job, siren, maxhealth, respawntime, delete");
        }

        Log(5, Array);
        RespawnVehicle(id, rid);
        SaveVehicle(rid);
    }
    else SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
    return 1;
}

GetRealVehicleID(id)
{
    new realid;
    for(new i; i < MAX_DYN_VEHICLES; i++)
    {
        if(id == Vehicle[i][VehID])
        {
            realid = i;
        }
    }
    return realid;
}

FindNextVehicle()
{
	for(new i = 1; i < MAX_DYN_VEHICLES; i++)
	{
		if(Vehicle[i][Model] == 0) 
		{
			return i;
		}
	}
	return -1;
}

RespawnVehicle(id, rid) 
{ 
    DestroyVehicle(id); 
    if(Vehicle[rid][Model] != 0) 
    { 
        Vehicle[rid][VehID] = CreateVehicle(Vehicle[rid][Model], Vehicle[rid][VehiclePos][0], Vehicle[rid][VehiclePos][1], Vehicle[rid][VehiclePos][2], Vehicle[rid][VehiclePos][3], Vehicle[rid][VehicleColour][0], Vehicle[rid][VehicleColour][1], Vehicle[id][RespawnTime], Vehicle[rid][Siren]); 
        SetVehicleVirtualWorld(Vehicle[rid][VehID], Vehicle[rid][VehicleVW]); 
        LinkVehicleToInterior(Vehicle[rid][VehID], Vehicle[rid][VehicleInt]); 

        SetVehicleHealth(id, Vehicle[rid][MaxHealth]);
        SetVehicleNumberPlate(id, Vehicle[rid][Plate]);

        Fuel[Vehicle[id][VehID]] = Vehicle[id][VehFuel];
    } 
    return 1; 
}  

forward InitiateVehicles();
public InitiateVehicles()
{
    new rows, fields, vehicles;
    
    cache_get_data(rows, fields);
    for(new row; row < MAX_DYN_VEHICLES; row++)
    {
        new id = row + 1;  

        Vehicle[id][VehicleDatabaseID] = cache_get_field_content_int(row, "id", SQL);
        Vehicle[id][Model] = cache_get_field_content_int(row, "Model", SQL);

        Vehicle[id][VehiclePos][0] = cache_get_field_content_float(row, "X", SQL);
        Vehicle[id][VehiclePos][1] = cache_get_field_content_float(row, "Y", SQL);
        Vehicle[id][VehiclePos][2] = cache_get_field_content_float(row, "Z", SQL);
        Vehicle[id][VehiclePos][3] = cache_get_field_content_float(row, "A", SQL);

        Vehicle[id][VehicleVW] = cache_get_field_content_int(row, "VW", SQL);
        Vehicle[id][VehicleInt] = cache_get_field_content_int(row, "Int", SQL);

        Vehicle[id][VehicleColour][0] = cache_get_field_content_int(row, "Colour1", SQL);
        Vehicle[id][VehicleColour][1] = cache_get_field_content_int(row, "Colour2", SQL);

        Vehicle[id][VehicleJob] = cache_get_field_content_int(row, "Job", SQL);
        Vehicle[id][VehicleGroup] = cache_get_field_content_int(row, "Group", SQL);
        Vehicle[id][Siren] = cache_get_field_content_int(row, "Siren", SQL);

        Vehicle[id][RespawnTime] = cache_get_field_content_int(row, "RespawnTime", SQL);
        Vehicle[id][MaxHealth] = cache_get_field_content_float(row, "MaxHealth", SQL);

        Vehicle[id][VehFuel] = cache_get_field_content_int(row, "Fuel", SQL);

        cache_get_field_content(row, "Plate", Vehicle[id][Plate], SQL, 16);

        if(Vehicle[id][Model] != 0)
        {
            Vehicle[id][VehID] = CreateVehicle(Vehicle[id][Model], Vehicle[id][VehiclePos][0], Vehicle[id][VehiclePos][1], Vehicle[id][VehiclePos][2], Vehicle[id][VehiclePos][3], Vehicle[id][VehicleColour][0], Vehicle[id][VehicleColour][1], Vehicle[id][RespawnTime], Vehicle[id][Siren]);
            
            SetVehicleVirtualWorld(Vehicle[id][VehID], Vehicle[id][VehicleVW]);
            LinkVehicleToInterior(Vehicle[id][VehID], Vehicle[id][VehicleInt]);

            SetVehicleHealth(Vehicle[id][VehID], Vehicle[id][MaxHealth]);
            SetVehicleNumberPlate(Vehicle[id][VehID], Vehicle[id][Plate]);
        }

        if(Vehicle[id][VehicleGroup] < 1 && Vehicle[id][VehicleJob] < 0) Vehicle[id][VehFuel] = random(20) + 10;
        if(Vehicle[id][VehicleJob] > -1) Vehicle[id][VehFuel] = -1;

        Fuel[Vehicle[id][VehID]] = Vehicle[id][VehFuel];

        vehicles++;
    }
    switch(vehicles)
    {
        case 0: printf("[SCRIPT-LOAD/ERR] The script initiated 0 vehicles.", vehicles);
        default: printf("[SCRIPT-LOAD] The script has initiated %d vehicles", vehicles);
    }
}

SaveVehicle(id)
{
    Array[0] = 0;

    mysql_format(SQL, Array, sizeof Array, "UPDATE `vehicles` SET \
        `Model` = '%d', `X` = '%f', `Y` = '%f', `Z` = '%f', `A` = %f, `VW` = '%d', `Int` = '%d', `Colour1` = '%d', `Colour2` = '%d', `Fuel` = '%d', `Group` = '%d', `Job` = '%d', `Siren` = '%d', `MaxHealth` = '%f', \
        `RespawnTime` = '%d', `Plate` = '%e' WHERE `id` = '%d'",
        Vehicle[id][Model], Vehicle[id][VehiclePos][0], Vehicle[id][VehiclePos][1], Vehicle[id][VehiclePos][2], Vehicle[id][VehiclePos][3], Vehicle[id][VehicleVW], Vehicle[id][VehicleInt], 
        Vehicle[id][VehicleColour][0], Vehicle[id][VehicleColour][1], Fuel[Vehicle[id][VehID]], Vehicle[id][VehicleGroup], Vehicle[id][VehicleJob], Vehicle[id][Siren], Vehicle[id][MaxHealth], 
        Vehicle[id][RespawnTime], Vehicle[id][Plate], Vehicle[id][VehicleDatabaseID]
    );
    mysql_tquery(SQL, Array, "", "");
    return 1;
}

SaveVehicles() { for(new i; i < MAX_DYN_VEHICLES; i++) SaveVehicle(i); }