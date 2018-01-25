CMD:nextarrest(playerid, params[])
{
    if(Player[playerid][AdminLevel] >= 5)
    {
        for(new i; i < MAX_ARRESTPOINTS; i++)
        {
            if(Arrest[i][ArrestPos][0] == 0.0) 
            {
                Array[0] = 0;
                format(Array, sizeof(Array), "The next available arrest point ID is %d.", i);
                SendClientMessage(playerid, WHITE, Array);
                break;
            }
        }
    }
    else SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
    return 1;
}

CMD:editarrest(playerid, params[])
{
    new id, usage[16], amount;
    if(sscanf(params, "ds[16]D(0)", id, usage, amount)) 
    {
        if(Player[playerid][AdminLevel] >= 5)
        {
            SendClientMessage(playerid, WHITE, "USAGE: /editarrest [id] [usage] [(optional) amount]");
            return SendClientMessage(playerid, GREY, "Usages: position, group, delete");
        }
    }
    else if(Player[playerid][AdminLevel] >= 5)
    {
        if(id < 0 || id > MAX_ARRESTPOINTS) return SendClientMessage(playerid, WHITE, "That is not a valid arrest point ID!");
        Array[0] = 0;
        if(strcmp(usage, "position", true) == 0)
        {
            new Float:Pos[4];
            GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
            GetPlayerFacingAngle(playerid, Pos[3]);

            Arrest[id][ArrestPos][0] = Pos[0];
            Arrest[id][ArrestPos][1] = Pos[1];
            Arrest[id][ArrestPos][2] = Pos[2];

            Arrest[id][ArrestVW] = GetPlayerVirtualWorld(playerid);
            Arrest[id][ArrestInt] = GetPlayerInterior(playerid);

            format(Array, sizeof(Array), "You have moved the exterior of arrest point %d", id);
            SendClientMessage(playerid, WHITE, Array);

            format(Array, sizeof(Array), "[/EDITARRESTPOINT] %s has moved the exterior of arrest point %d to X: %f, Y: %f, Z: %f", GetName(playerid), id, Pos[0], Pos[1], Pos[2]);
        }
        else if(strcmp(usage, "group", true) == 0)
        {
            Arrest[id][ArrestGroup] = amount - 1;

            format(Array, sizeof(Array), "You have modified the group of arrest point %d to %s", id, Group[amount - 1][GroupName]);
            SendClientMessage(playerid, WHITE, Array);

            format(Array, sizeof(Array), "[/EDITARRESTPOINT] %s has modified the group of arrest point %d to %d", GetName(playerid), id, Group[amount - 1][GroupName]);
        }
        else if(strcmp(usage, "delete", true) == 0)
        {
            Arrest[id][ArrestPos][0] = 0.00000;
            Arrest[id][ArrestPos][1] = 0.00000;
            Arrest[id][ArrestPos][2] = 0.00000;

            Arrest[id][ArrestVW] = 0;
            Arrest[id][ArrestInt] = 0;

            Arrest[id][ArrestGroup] = 0;

            format(Array, sizeof(Array), "You have deleted arrest point %d", id);
            SendClientMessage(playerid, WHITE, Array);

            format(Array, sizeof(Array), "[/EDITARRESTPOINT] %s has deleted arrest point %d", GetName(playerid), id);
        }
        else
        {
            SendClientMessage(playerid, WHITE, "USAGE: /editarrestpoint [id] [usage] [(optional) amount]");
            return SendClientMessage(playerid, GREY, "Usages: position, group, delete");
        }

        Log(9, Array);
        SaveArrestPoint(id);
    }
    else SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
    return 1;
}

forward InitiateArrestPoints();
public InitiateArrestPoints()
{
    new rows, fields, arrestpoints;
    
    cache_get_data(rows, fields);
    for(new row; row < MAX_ARRESTPOINTS; row++)
    {        
        Arrest[row][ArrestPos][0] = cache_get_field_content_float(row, "X", SQL);
        Arrest[row][ArrestPos][1] = cache_get_field_content_float(row, "Y", SQL);
        Arrest[row][ArrestPos][2] = cache_get_field_content_float(row, "Z", SQL);

        Arrest[row][ArrestVW] = cache_get_field_content_int(row, "VW", SQL);
        Arrest[row][ArrestInt] = cache_get_field_content_int(row, "Int", SQL);

        Arrest[row][ArrestGroup] = cache_get_field_content_int(row, "Group", SQL);

        DestroyDynamicPickup(Arrest[row][ArrestPickup]);
    	DestroyDynamic3DTextLabel(Arrest[row][ArrestText]);
    	if(Arrest[row][ArrestPos][0] != 0.00000 && Arrest[row][ArrestPos][1] != 0.00000 && Arrest[row][ArrestPos][2] != 0.00000)
   	 	{
    		format(Array, sizeof(Array), "Arrest Point %d\n (( /arrest ))", row);
       		Arrest[row][ArrestPickup] = CreateDynamicPickup(1247, 23, Arrest[row][ArrestPos][0], Arrest[row][ArrestPos][1], Arrest[row][ArrestPos][2], Arrest[row][ArrestVW]);
       		Arrest[row][ArrestText] = CreateDynamic3DTextLabel(Array, BLUE, Arrest[row][ArrestPos][0], Arrest[row][ArrestPos][1], Arrest[row][ArrestPos][2], 7.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, Arrest[row][ArrestVW], Arrest[row][ArrestInt]);
    	}

        arrestpoints++;
    }
    switch(arrestpoints)
    {
        case 0: printf("[SCRIPT-LOAD/ERR] The script initiated 0 arrest points.", arrestpoints);
        default: printf("[SCRIPT-LOAD] The script has initiated %d arrest points", arrestpoints);
    }
}

SaveArrestPoint(id)
{
    Array[0] = 0;

    mysql_format(SQL, Array, sizeof Array, "UPDATE `arrestpoints` SET \
        `X` = '%f', `Y` = '%f', `Z` = '%f', `VW` = '%d', `Int` = '%d', `Group` = '%d' WHERE `id` = '%d'",
        Arrest[id][ArrestPos][0], Arrest[id][ArrestPos][1], Arrest[id][ArrestPos][2], Arrest[id][ArrestVW], Arrest[id][ArrestInt], Arrest[id][ArrestGroup], id + 1
    );
    mysql_tquery(SQL, Array, "", "");

    DestroyDynamicPickup(Arrest[id][ArrestPickup]);
    DestroyDynamic3DTextLabel(Arrest[id][ArrestText]);
    if(Arrest[id][ArrestPos][0] != 0.00000 && Arrest[id][ArrestPos][1] != 0.00000 && Arrest[id][ArrestPos][2] != 0.00000)
    {
        format(Array, sizeof(Array), "Arrest Point %d\n (( /arrest ))", id);
        Arrest[id][ArrestPickup] = CreateDynamicPickup(1247, 23, Arrest[id][ArrestPos][0], Arrest[id][ArrestPos][1], Arrest[id][ArrestPos][2], Arrest[id][ArrestVW]);
        Arrest[id][ArrestText] = CreateDynamic3DTextLabel(Array, BLUE, Arrest[id][ArrestPos][0], Arrest[id][ArrestPos][1], Arrest[id][ArrestPos][2], 7.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, Arrest[id][ArrestVW], Arrest[id][ArrestInt]);
    }
    return 1;
}

SaveArrestPoints() { for(new i; i < MAX_ARRESTPOINTS; i++) SaveArrestPoint(i); }