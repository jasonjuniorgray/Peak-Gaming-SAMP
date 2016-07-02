CMD:nextlocker(playerid, params[])
{
    if(Player[playerid][AdminLevel] >= 5)
    {
        for(new i; i < MAX_LOCKERS; i++)
        {
            if(Locker[i][LockerPos][0] == 0.0) 
            {
                Array[0] = 0;
                format(Array, sizeof(Array), "The next available locker ID is %d.", i);
                SendClientMessage(playerid, WHITE, Array);
                break;
            }
        }
    }
    else SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
    return 1;
}

CMD:editlocker(playerid, params[])
{
    new id, usage[16], amount;
    if(sscanf(params, "ds[16]D(0)", id, usage, amount)) 
    {
        if(Player[playerid][AdminLevel] >= 5)
        {
            SendClientMessage(playerid, WHITE, "USAGE: /editlocker [id] [usage] [(optional) amount]");
            return SendClientMessage(playerid, GREY, "Usages: position, group, delete");
        }
    }
    else if(Player[playerid][AdminLevel] >= 5)
    {
        if(id < 0 || id > MAX_LOCKERS) return SendClientMessage(playerid, WHITE, "That is not a valid locker ID!");
        Array[0] = 0;
        if(strcmp(usage, "position", true) == 0)
        {
            new Float:Pos[4];
            GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
            GetPlayerFacingAngle(playerid, Pos[3]);

            Locker[id][LockerPos][0] = Pos[0];
            Locker[id][LockerPos][1] = Pos[1];
            Locker[id][LockerPos][2] = Pos[2];

            Locker[id][LockerVW] = GetPlayerVirtualWorld(playerid);
            Locker[id][LockerInt] = GetPlayerInterior(playerid);

            format(Array, sizeof(Array), "You have moved the exterior of locker %d", id);
            SendClientMessage(playerid, WHITE, Array);

            format(Array, sizeof(Array), "[/EDITLOCKER] %s has moved the exterior of locker %d to X: %f, Y: %f, Z: %f", GetName(playerid), id, Pos[0], Pos[1], Pos[2]);
        }
        else if(strcmp(usage, "group", true) == 0)
        {
            Locker[id][LockerGroup] = amount - 1;

            format(Array, sizeof(Array), "You have modified the group of locker %d to %s", id, Group[amount - 1][GroupName]);
            SendClientMessage(playerid, WHITE, Array);

            format(Array, sizeof(Array), "[/EDITLOCKER] %s has modified the group of locker %d to %s", GetName(playerid), id, Group[amount - 1][GroupName]);
        }
        else if(strcmp(usage, "delete", true) == 0)
        {
            Locker[id][LockerPos][0] = 0.00000;
            Locker[id][LockerPos][1] = 0.00000;
            Locker[id][LockerPos][2] = 0.00000;

            Locker[id][LockerVW] = 0;
            Locker[id][LockerInt] = 0;

            Locker[id][LockerGroup] = 0;

            format(Array, sizeof(Array), "You have deleted locker %d", id);
            SendClientMessage(playerid, WHITE, Array);

            format(Array, sizeof(Array), "[/EDITLOCKER] %s has deleted locker %d", GetName(playerid), id);
        }
        else
        {
            SendClientMessage(playerid, WHITE, "USAGE: /editlocker [id] [usage] [(optional) amount]");
            return SendClientMessage(playerid, GREY, "Usages: position, group, delete");
        }

        Log(15, Array);
        SaveLocker(id);
    }
    else SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
    return 1;
}

forward InitiateLockers();
public InitiateLockers()
{
    new rows, fields, lockers;
    
    cache_get_data(rows, fields);
    for(new row; row < MAX_LOCKERS; row++)
    {        
        Locker[row][LockerPos][0] = cache_get_field_content_float(row, "X", SQL);
        Locker[row][LockerPos][1] = cache_get_field_content_float(row, "Y", SQL);
        Locker[row][LockerPos][2] = cache_get_field_content_float(row, "Z", SQL);

        Locker[row][LockerVW] = cache_get_field_content_int(row, "VW", SQL);
        Locker[row][LockerInt] = cache_get_field_content_int(row, "Int", SQL);

        Locker[row][LockerGroup] = cache_get_field_content_int(row, "Group", SQL);

    	DestroyDynamic3DTextLabel(Locker[row][LockerText]);
        if(Locker[row][LockerPos][0] != 0.00000 && Locker[row][LockerPos][1] != 0.00000 && Locker[row][LockerPos][2] != 0.00000)
        {
            format(Array, sizeof(Array), "%s Locker (%d)\n (( /locker ))", Group[Locker[row][LockerGroup]][GroupName], row);
            Locker[row][LockerText] = CreateDynamic3DTextLabel(Array, Group[Locker[row][LockerGroup]][GroupColour] * 256 + 255, Locker[row][LockerPos][0], Locker[row][LockerPos][1], Locker[row][LockerPos][2], 7.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, Locker[row][LockerVW], Locker[row][LockerInt]);
        }

        lockers++;
    }
    switch(lockers)
    {
        case 0: printf("[SCRIPT-LOAD/ERR] The script initiated 0 lockers.", lockers);
        default: printf("[SCRIPT-LOAD] The script has initiated %d lockers", lockers);
    }
}

SaveLocker(id)
{
    Array[0] = 0;

    format(Array, sizeof Array, "UPDATE `lockers` SET \
        `X` = '%f', `Y` = '%f', `Z` = '%f', `VW` = '%d', `Int` = '%d', `Group` = '%d' WHERE `id` = '%d'",
        Locker[id][LockerPos][0], Locker[id][LockerPos][1], Locker[id][LockerPos][2], Locker[id][LockerVW], Locker[id][LockerInt], Locker[id][LockerGroup], id + 1
    );
    mysql_tquery(SQL, Array, "", "");

    DestroyDynamic3DTextLabel(Locker[id][LockerText]);
    if(Locker[id][LockerPos][0] != 0.00000 && Locker[id][LockerPos][1] != 0.00000 && Locker[id][LockerPos][2] != 0.00000)
    {
        format(Array, sizeof(Array), "%s Locker (%d)\n (( /locker ))", Group[Locker[id][LockerGroup]][GroupName], id);
        Locker[id][LockerText] = CreateDynamic3DTextLabel(Array, Group[Locker[id][LockerGroup]][GroupColour] * 256 + 255, Locker[id][LockerPos][0], Locker[id][LockerPos][1], Locker[id][LockerPos][2], 7.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, Locker[id][LockerVW], Locker[id][LockerInt]);
    }
    return 1;
}

SaveLockers() { for(new i; i < MAX_LOCKERS; i++) SaveLocker(i); }