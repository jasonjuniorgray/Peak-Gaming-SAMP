CMD:nextjob(playerid, params[])
{
    if(Player[playerid][AdminLevel] >= 5)
    {
        for(new i; i < MAX_JOBS; i++)
        {
            if(Job[i][JobPos][0] == 0.0) 
            {
                Array[0] = 0;
                format(Array, sizeof(Array), "The next available job ID is %d.", i);
                SendClientMessage(playerid, WHITE, Array);
                break;
            }
        }
    }
    else SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
    return 1;
}

CMD:jobname(playerid, params[])
{
    new id, usage[25];
    if(sscanf(params, "ds[25]", id, usage)) 
    {
        if(Player[playerid][AdminLevel] >= 5)
        {
            return SendClientMessage(playerid, WHITE, "USAGE: /jobname [id] [name]");
        }
    }
    else if(Player[playerid][AdminLevel] >= 5)
    {
        if(id < 0 || id > MAX_JOBS) return SendClientMessage(playerid, WHITE, "That is not a valid job ID!");
        Array[0] = 0;

        format(Job[id][JobName], 25, "%s", usage);

        format(Array, sizeof(Array), "You have modified the name of job %d to %s", id, usage);
        SendClientMessage(playerid, WHITE, Array);

        format(Array, sizeof(Array), "[/JOBNAME] %s has modified job %d's name to %s", GetName(playerid), id, usage);

        Log(13, Array);
        SaveJob(id);
    }
    else SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
    return 1;
}

CMD:editjob(playerid, params[])
{
    new id, usage[16], amount;
    if(sscanf(params, "ds[16]D(0)", id, usage, amount)) 
    {
        if(Player[playerid][AdminLevel] >= 5)
        {
            SendClientMessage(playerid, WHITE, "USAGE: /editjob [id] [usage] [(optional) amount]");
            return SendClientMessage(playerid, GREY, "Usages: position, type, delete");
        }
    }
    else if(Player[playerid][AdminLevel] >= 5)
    {
        if(id < 0 || id > MAX_JOBS) return SendClientMessage(playerid, WHITE, "That is not a valid house ID!");
        Array[0] = 0;
        if(strcmp(usage, "position", true) == 0)
        {
            new Float:Pos[4];
            GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
            GetPlayerFacingAngle(playerid, Pos[3]);

            Job[id][JobPos][0] = Pos[0];
            Job[id][JobPos][1] = Pos[1];
            Job[id][JobPos][2] = Pos[2];

            format(Array, sizeof(Array), "You have moved the position of job %d", id);
            SendClientMessage(playerid, WHITE, Array);

            format(Array, sizeof(Array), "[/EDITJOB] %s has moved the position of job %d to X: %f, Y: %f, Z: %f", GetName(playerid), id, Pos[0], Pos[1], Pos[2]);
        }
        else if(strcmp(usage, "type", true) == 0)
        {
            if(amount < 1 || amount > 10)  return SendClientMessage(playerid, GREY, "Types: 1 - Arms Dealer, 2 - Mechanic, 3 - Bodyguard, 4 - Detective, 5 - Trucker, 6 - Drug Smuggler, 7 - Pizza Boy");
            Job[id][JobType] = amount;

            format(Array, sizeof(Array), "You have modified the type of job %d to %d", id, amount);
            SendClientMessage(playerid, WHITE, Array);

            format(Array, sizeof(Array), "[/EDITJOB] %s has modified the type of job %d to %d", GetName(playerid), id, amount);
        }
        else if(strcmp(usage, "delete", true) == 0)
        {
            format(Job[id][JobName], 50, "Nothing");
            Job[id][JobType] = 0;

            Job[id][JobPos][0] = 0.0000;
            Job[id][JobPos][1] = 0.0000;
            Job[id][JobPos][2] = 0.0000;

            format(Array, sizeof(Array), "You have deleted job %d", id);
            SendClientMessage(playerid, WHITE, Array);

            format(Array, sizeof(Array), "[/EDITJOB] %s has deleted job %d", GetName(playerid), id);
        }
        else
        {
            SendClientMessage(playerid, WHITE, "USAGE: /editjob [id] [usage] [(optional) amount]");
            return SendClientMessage(playerid, GREY, "Usages: position, type, delete");
        }

        Log(13, Array);
        SaveJob(id);
    }
    else SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
    return 1;
}

forward InitiateJobs();
public InitiateJobs()
{
    new rows, fields, jobs;
    
    cache_get_data(rows, fields);
    for(new row; row < MAX_JOBS; row++)
    {
        Array[0] = 0;
        cache_get_field_content(row, "Name", Job[row][JobName], SQL, 256);
        Job[row][JobType] = cache_get_field_content_int(row, "Type", SQL);

        Job[row][JobPos][0] = cache_get_field_content_float(row, "X", SQL);
        Job[row][JobPos][1] = cache_get_field_content_float(row, "Y", SQL);
        Job[row][JobPos][2] = cache_get_field_content_float(row, "Z", SQL);

        DestroyDynamicPickup(Job[row][JobPickup]);
        DestroyDynamic3DTextLabel(Job[row][JobText]);
        format(Array, sizeof(Array), "%s\n(( /joinjob ))", Job[row][JobName]);
        Job[row][JobPickup] = CreateDynamicPickup(1239, 23, Job[row][JobPos][0], Job[row][JobPos][1], Job[row][JobPos][2]);
        Job[row][JobText] = CreateDynamic3DTextLabel(Array, YELLOW, Job[row][JobPos][0], Job[row][JobPos][1], Job[row][JobPos][2], 7.0);

        jobs++;
    }
    switch(jobs)
    {
        case 0: printf("[SCRIPT-LOAD/ERR] The script initiated 0 jobs.", jobs);
        default: printf("[SCRIPT-LOAD] The script has initiated %d jobs", jobs);
    }
}

SaveJob(id)
{
    Array[0] = 0;

    format(Array, sizeof Array, "UPDATE `jobs` SET \
        `Name` ='%s', `Type` = '%d', `X` = '%f', `Y` = '%f', `Z` = '%f' WHERE `id` = '%d'",
        Job[id][JobName], Job[id][JobType], Job[id][JobPos][0], Job[id][JobPos][1], Job[id][JobPos][2], id + 1
    );
    mysql_tquery(SQL, Array, "", "");

    DestroyDynamicPickup(Job[id][JobPickup]);
    DestroyDynamic3DTextLabel(Job[id][JobText]);
    format(Array, sizeof(Array), "%s\n(( /joinjob ))", Job[id][JobName]);
    Job[id][JobPickup] = CreateDynamicPickup(1239, 23, Job[id][JobPos][0], Job[id][JobPos][1], Job[id][JobPos][2]);
    Job[id][JobText] = CreateDynamic3DTextLabel(Array, YELLOW, Job[id][JobPos][0], Job[id][JobPos][1], Job[id][JobPos][2], 7.0);
    return 1;
}

SaveJobs() { for(new i; i < MAX_JOBS; i++) SaveJob(i); }