#include <YSI\y_hooks>

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    Array[0] = 0;
	switch(dialogid)
	{
        case DIALOG_EDITGROUP:
        {
            if(!response) return 0;
        	switch(listitem)
        	{
        		case 0 .. MAX_GROUPS:
        		{
        			SetPVarInt(playerid, "EditingGroup", listitem); // Essential for the whole system to work. Do not touch/edit/remove - Jason

        			new string[256];
					format(string, sizeof(string), "Name: %s\n\
						Type: %s\n\
						Ranks\n\
						Paycheques\n\
						Divisions\n\
						Colour\n\
                        Safe Position", 
						Group[GetPVarInt(playerid, "EditingGroup")][GroupName],
						GroupTypeToString(Group[GetPVarInt(playerid, "EditingGroup")][GroupType]));
					ShowPlayerDialog(playerid, DIALOG_EDITGROUP2, DIALOG_STYLE_LIST, "Edit Group", string, "Select", "Cancel");
        		}
        	}
        }
        case DIALOG_EDITGROUP2:
        {
            if(!response) return 0;
        	switch(listitem)
        	{
        		case 0:
        		{
                    if(Player[playerid][AdminLevel] < 1) return SendClientMessage(playerid, WHITE, "This option is locked to administrators.");
        			ShowPlayerDialog(playerid, DIALOG_EDITGROUP_NAME, DIALOG_STYLE_INPUT, "Edit Group - Name", "Enter the new name for the specified group.", "Select", "Cancel");
        		}
        		case 1:
        		{
                    if(Player[playerid][AdminLevel] < 1) return SendClientMessage(playerid, WHITE, "This option is locked to administrators.");
        			ShowPlayerDialog(playerid, DIALOG_EDITGROUP_TYPE, DIALOG_STYLE_LIST, "Edit Group - Type", "Law Enforcement\
        				\nLaw Enforcement (IA)\
        				\nGovernment\
                        \nMedic\
                        \nContract Agency\
        				\nCriminal", "Select", "Cancel");
        		}
        		case 2:
        		{
        			new string[400];
        			for(new i; i < MAX_GROUP_RANKS; i++)
					{
						format(string, sizeof(string), "%s\n%d.) %s\n", string, i, GroupRankNames[GetPVarInt(playerid, "EditingGroup")][i]);
					}
                    ShowPlayerDialog(playerid, DIALOG_EDITGROUP_RANKS, DIALOG_STYLE_LIST, "Edit Group - Ranks", string, "Select", "Cancel");
        		}
        		case 3:
        		{
        			new string[400];
        			for(new i; i < MAX_GROUP_RANKS; i++)
					{
						format(string, sizeof(string), "%s\n%s - $%d\n", string, GroupRankNames[GetPVarInt(playerid, "EditingGroup")][i], Group[GetPVarInt(playerid, "EditingGroup")][GroupPaycheque][i]);						
					}
                    ShowPlayerDialog(playerid, DIALOG_EDITGROUP_PAY, DIALOG_STYLE_LIST, "Edit Group - Paycheques", string, "Select", "Cancel");
        		}
        		case 4:
        		{
        			new string[400];
        			for(new i; i < MAX_GROUP_DIVS; i++)
					{
						format(string, sizeof(string), "%s\n%d.) %s\n", string, i, GroupDivisionNames[GetPVarInt(playerid, "EditingGroup")][i]);
					}
                    ShowPlayerDialog(playerid, DIALOG_EDITGROUP_DIVS, DIALOG_STYLE_LIST, "Edit Group - Divisions", string, "Select", "Cancel");
        		}
        		case 5: 
                {
                    if(Player[playerid][AdminLevel] < 1) return SendClientMessage(playerid, WHITE, "This option is locked to administrators.");
                    ShowPlayerDialog(playerid, DIALOG_EDITGROUP_COLOUR, DIALOG_STYLE_INPUT, "Edit Group - Colour", "Enter the new HTML colour code for the group. (eg: BF4621)", "Select", "Cancel");
                }
                case 6: 
                {
                    new Float:Pos[3];
                    GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);

                    Group[GetPVarInt(playerid, "EditingGroup")][GroupSafePos][0] = Pos[0];
                    Group[GetPVarInt(playerid, "EditingGroup")][GroupSafePos][1] = Pos[1];
                    Group[GetPVarInt(playerid, "EditingGroup")][GroupSafePos][2] = Pos[2];

                    SendClientMessage(playerid, WHITE, "You have changed the safe position.");
                    format(Array, sizeof(Array), "[/EDITGROUP] %s changed group %d's safe position to X: %f, Y: %f, Z: %f", GetName(playerid), GetPVarInt(playerid, "EditingGroup"), Pos[0], Pos[1], Pos[2]);
                    Log(3, Array);

                    SaveGroup(GetPVarInt(playerid, "EditingGroup"));
                    ListGroups(playerid);
                }
        	}
        }
        case DIALOG_EDITGROUP_NAME:
        {
            if(!response) return ListGroups(playerid);
        	if(strlen(inputtext) < 1) { format(Group[GetPVarInt(playerid, "EditingGroup")][GroupName], 255, "empty", inputtext); }
        	else format(Group[GetPVarInt(playerid, "EditingGroup")][GroupName], 255, "%s", inputtext);

            format(Array, sizeof(Array), "[/EDITGROUP] %s changed group %d's name to %s", GetName(playerid), GetPVarInt(playerid, "EditingGroup"), inputtext);
            Log(3, Array);

            SaveGroup(GetPVarInt(playerid, "EditingGroup"));
            ListGroups(playerid);
        }
        case DIALOG_EDITGROUP_TYPE:
        {
            if(!response) return ListGroups(playerid);
            Group[GetPVarInt(playerid, "EditingGroup")][GroupType] = listitem;

            format(Array, sizeof(Array), "[/EDITGROUP] %s changed group %d's type to %d", GetName(playerid), GetPVarInt(playerid, "EditingGroup"), listitem);
            Log(3, Array);

            SaveGroup(GetPVarInt(playerid, "EditingGroup"));
            ListGroups(playerid);
        }
        case DIALOG_EDITGROUP_RANKS: 
        {
            if(!response) return ListGroups(playerid);
            SetPVarInt(playerid, "EditingRank", listitem);
            ShowPlayerDialog(playerid, DIALOG_EDITGROUP_RANKS2, DIALOG_STYLE_INPUT, "Edit Group - Ranks", "Enter the new name for the specified rank.", "Select", "Cancel");
        }
        case DIALOG_EDITGROUP_RANKS2:
        {
            if(!response) return ListGroups(playerid);
            if(strlen(inputtext) < 1) { format(GroupRankNames[GetPVarInt(playerid, "EditingGroup")][GetPVarInt(playerid, "EditingRank")], 255, "None", inputtext); }
            else format(GroupRankNames[GetPVarInt(playerid, "EditingGroup")][GetPVarInt(playerid, "EditingRank")], 255, "%s", inputtext);

            SaveGroup(GetPVarInt(playerid, "EditingGroup"));

            new string[400];
            for(new i; i < MAX_GROUP_RANKS; i++)
            {
                format(string, sizeof(string), "%s\n%d.) %s\n", string, i, GroupRankNames[GetPVarInt(playerid, "EditingGroup")][i]);
            }
            ShowPlayerDialog(playerid, DIALOG_EDITGROUP_RANKS, DIALOG_STYLE_LIST, "Edit Group - Ranks", string, "Select", "Cancel");

            format(Array, sizeof(Array), "[/EDITGROUP] %s changed group %d's rank %d name to %s", GetName(playerid), GetPVarInt(playerid, "EditingGroup"), GetPVarInt(playerid, "EditingRank"), inputtext);
            Log(3, Array);

            DeletePVar(playerid, "EditingRank");
        }
        case DIALOG_EDITGROUP_PAY: 
        {
            if(!response) return ListGroups(playerid);
            SetPVarInt(playerid, "EditingRank", listitem);
            ShowPlayerDialog(playerid, DIALOG_EDITGROUP_PAY2, DIALOG_STYLE_INPUT, "Edit Group - Paycheques", "Enter the amount that the rank will get paid each hour.", "Select", "Cancel");
        }
        case DIALOG_EDITGROUP_PAY2:
        {
            if(!response) return ListGroups(playerid);
            if(strlen(inputtext) < 1) { Group[GetPVarInt(playerid, "EditingGroup")][GroupPaycheque][GetPVarInt(playerid, "EditingRank")] = 0; }
            if(!IsNumeric(inputtext)) return ShowPlayerDialog(playerid, DIALOG_EDITGROUP_PAY2, DIALOG_STYLE_INPUT, "Edit Group - Paycheques", "Enter the amount that the rank will get paid each hour.", "Select", "Cancel");
            else Group[GetPVarInt(playerid, "EditingGroup")][GroupPaycheque][GetPVarInt(playerid, "EditingRank")] = strval(inputtext);

            SaveGroup(GetPVarInt(playerid, "EditingGroup"));

            new string[400];
            for(new i; i < MAX_GROUP_RANKS; i++)
            {
                format(string, sizeof(string), "%s\n%s - $%d\n", string, GroupRankNames[GetPVarInt(playerid, "EditingGroup")][i], Group[GetPVarInt(playerid, "EditingGroup")][GroupPaycheque][i]);                      
            }
            ShowPlayerDialog(playerid, DIALOG_EDITGROUP_PAY, DIALOG_STYLE_LIST, "Edit Group - Paycheques", string, "Select", "Cancel");

            format(Array, sizeof(Array), "[/EDITGROUP] %s changed group %d's rank %d pay to %d", GetName(playerid), GetPVarInt(playerid, "EditingGroup"), GetPVarInt(playerid, "EditingRank"), inputtext);
            Log(3, Array);

            DeletePVar(playerid, "EditingRank");
        }
        case DIALOG_EDITGROUP_DIVS: 
        {
            if(!response) return ListGroups(playerid);
            SetPVarInt(playerid, "EditingDivision", listitem);
            ShowPlayerDialog(playerid, DIALOG_EDITGROUP_DIVS2, DIALOG_STYLE_INPUT, "Edit Group - Divisions", "Enter the new name for the specified rank.", "Select", "Cancel");
        }
        case DIALOG_EDITGROUP_DIVS2:
        {
            if(!response) return ListGroups(playerid);
            if(strlen(inputtext) < 1) { format(GroupDivisionNames[GetPVarInt(playerid, "EditingGroup")][GetPVarInt(playerid, "EditingDivision")], 255, "None", inputtext); }
            else format(GroupDivisionNames[GetPVarInt(playerid, "EditingGroup")][GetPVarInt(playerid, "EditingDivision")], 255, "%s", inputtext);

            SaveGroup(GetPVarInt(playerid, "EditingGroup"));

            new string[400];
            for(new i; i < MAX_GROUP_DIVS; i++)
            {
                format(string, sizeof(string), "%s\n%d.) %s\n", string, i, GroupDivisionNames[GetPVarInt(playerid, "EditingGroup")][i]);
            }
            ShowPlayerDialog(playerid, DIALOG_EDITGROUP_DIVS, DIALOG_STYLE_LIST, "Edit Group - Divisions", string, "Select", "Cancel");

            format(Array, sizeof(Array), "[/EDITGROUP] %s changed group %d's division %d name to %s", GetName(playerid), GetPVarInt(playerid, "EditingGroup"), GetPVarInt(playerid, "EditingDivision"), inputtext);
            Log(3, Array);

            DeletePVar(playerid, "EditingDivision");
        }
        case DIALOG_EDITGROUP_COLOUR:
        {
            if(!response) return ListGroups(playerid);

            new colour;
            sscanf(inputtext, "h", colour);
            if(strlen(inputtext) < 1 || strlen(inputtext) > 6) { Group[GetPVarInt(playerid, "EditingGroup")][GroupColour] = 000000; }
            else Group[GetPVarInt(playerid, "EditingGroup")][GroupColour] = colour;

            format(Array, sizeof(Array), "[/EDITGROUP] %s changed group %d's colour to %s (%d)", GetName(playerid), GetPVarInt(playerid, "EditingGroup"), inputtext, colour);
            Log(3, Array);

            SaveGroup(GetPVarInt(playerid, "EditingGroup"));
            return ListGroups(playerid);
        }

        case DIALOG_MAKELEADER:
        {
            Array[0] = 0;

            if(!response) return 1;

            new id = GetPVarInt(playerid, "MakingLeader");
            DeletePVar(playerid, "MakingLeader");
            if(IsPlayerConnectedEx(id))
            {
                Player[id][PlayerGroup] = listitem;
                Player[id][GroupRank] = GetMaxGroupRank(listitem);
                Player[id][Leader] = 1;

                format(Array, sizeof(Array), "You have made %s leader of (the) %s", GetName(id), Group[listitem][GroupName]);
                SendClientMessage(playerid, LIGHTBLUE, Array);

                format(Array, sizeof(Array), "You have been made leader of (the) %s by %s %s", Group[listitem][GroupName], GetPlayerAdminLevel(playerid), GetName(playerid));
                SendClientMessage(id, LIGHTBLUE, Array);

                format(Array, sizeof(Array), "[/MAKELEADER] %s has made %s the leader of group (the) %s(%d)", GetName(playerid), GetName(id), Group[listitem][GroupName], listitem);
                Log(1, Array);
            }
            else return SendClientMessage(playerid, WHITE, "That player is not connected anymore!");
        }
    }
    return 1;
}

CMD:editgroup(playerid, params[])
{
	if(Player[playerid][AdminLevel] >= 4)
	{
		ListGroups(playerid);
	}
	else SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
	return 1;
}

CMD:editmygroup(playerid, params[])
{
    Array[0] = 0;
    if(Player[playerid][AdminLevel] >= 4 || Player[playerid][GroupRank] == GetMaxGroupRank(Player[playerid][PlayerGroup]))
    {
        format(Array, sizeof(Array), "Name: %s\n\
            Type: %s\n\
            Ranks\n\
            Paycheques\n\
            Divisions\n\
            Colour",
            Group[GetPVarInt(playerid, "EditingGroup")][GroupName],
            GroupTypeToString(Group[GetPVarInt(playerid, "EditingGroup")][GroupType]));
        ShowPlayerDialog(playerid, DIALOG_EDITGROUP2, DIALOG_STYLE_LIST, "Edit Group", Array, "Select", "Cancel");

        SetPVarInt(playerid, "EditingGroup", Player[playerid][PlayerGroup]);
    }
    else SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
    return 1;
}

ListGroups(playerid)
{
	new string[2000];
    DeletePVar(playerid, "EditingGroup");

	for(new i; i < MAX_GROUPS; i++) format(string, sizeof(string), "%s\n%d.) {%s}%s{FFFFFF}\n", string, i + 1, GetGroupColour(Group[i][GroupColour]), Group[i][GroupName]);
	return ShowPlayerDialog(playerid, DIALOG_EDITGROUP, DIALOG_STYLE_LIST, "Edit Group", string, "Select", "Cancel");
}

GroupTypeToString(id)
{
	new TypeString[50];
	switch(id)
	{
		case 0: format(TypeString, sizeof(TypeString), "Law Enforcement");
		case 1: format(TypeString, sizeof(TypeString), "Law Enforcement (IA)");
		case 2: format(TypeString, sizeof(TypeString), "Government");
        case 3: format(TypeString, sizeof(TypeString), "Medic");
        case 4: format(TypeString, sizeof(TypeString), "Contract Agency");
		case 5: format(TypeString, sizeof(TypeString), "Criminal");
	}
	return TypeString;
}

public InitiateGroups()
{
    new rows, fields, number[25], groups;
    
    cache_get_data(rows, fields);
    for(new row; row < MAX_GROUPS; row++)
    {        
        Group[row][GroupType] = cache_get_field_content_int(row, "GroupType", SQL);
        cache_get_field_content(row, "GroupName", Group[row][GroupName], SQL, 256);
        cache_get_field_content(row, "MOTD", Group[row][GroupMOTD], SQL, 256);

        for(new i; i < MAX_GROUP_RANKS; i++)
        {
            format(number, sizeof number, "Rank%i", i);
            cache_get_field_content(row, number, GroupRankNames[row][i], 256);
        }
        for(new i; i < MAX_GROUP_RANKS; i++)
        {
            format(number, sizeof number, "RankPay%i", i);
            Group[row][GroupPaycheque][i] = cache_get_field_content_int(row, number, SQL);
        }
        for(new i; i < MAX_GROUP_DIVS; i++)
        {
            format(number, sizeof number, "Div%i", i);
            cache_get_field_content(row, number, GroupDivisionNames[row][i]);
        }
        Group[row][GroupColour] = cache_get_field_content_int(row, "Colour", SQL);
        Group[row][GroupSafePos][0] = cache_get_field_content_float(row, "SafeX", SQL);
        Group[row][GroupSafePos][1] = cache_get_field_content_float(row, "SafeY", SQL);
        Group[row][GroupSafePos][2] = cache_get_field_content_float(row, "SafeZ", SQL);
        Group[row][GroupMoney] = cache_get_field_content_int(row, "Money", SQL);

        groups++;
    }
    switch(groups)
    {
        case 0: printf("[SCRIPT-LOAD/ERR] The script initiated 0 groups.", groups);
        default: printf("[SCRIPT-LOAD] The script has initiated %d groups", groups);
    }
}

SaveGroup(id)
{
    new Query[2000];

    mysql_format(SQL, Query, sizeof Query, "UPDATE `groups` SET \
        `GroupType` = %i, `GroupName` = '%e', `MOTD` = '%e'",
        Group[id][GroupType], Group[id][GroupName], Group[id][GroupMOTD]
    );

    for(new i; i < MAX_GROUP_RANKS; i++) mysql_format(SQL, Query, sizeof Query, "%s, `Rank%i` = '%e'", Query, i, GroupRankNames[id][i]);
    for(new i; i < MAX_GROUP_RANKS; i++) mysql_format(SQL, Query, sizeof Query, "%s, `RankPay%i` = '%d'", Query, i, Group[id][GroupPaycheque][i]);
    for(new i; i < MAX_GROUP_DIVS; i++) mysql_format(SQL, Query, sizeof Query, "%s, `Div%i` = '%e'", Query, i, GroupDivisionNames[id][i]);

    mysql_format(SQL, Query, sizeof Query, "%s, `Colour` = %i, `SafeX` = '%f', `SafeY` = '%f', `SafeZ` = '%f', Money = '%d'", Query, 
        Group[id][GroupColour], Group[id][GroupSafePos][0], Group[id][GroupSafePos][1], Group[id][GroupSafePos][2], Group[id][GroupMoney]);

    mysql_format(SQL, Query, sizeof Query, "%s WHERE `id` = %d", Query, id + 1);
    mysql_tquery(SQL, Query, "", "");
    return 1;
}

SaveGroups() { for(new i; i < MAX_GROUPS; i++) SaveGroup(i); }