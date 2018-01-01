#include <YSI\y_hooks>

new const PoliceWeapons[][] =
{
    "Nitestick (3)",
    "Spraycan (41)",
    "Camera (43)",
    "Desert Eagle (24)",
    "Shotgun (25)",
    "MP5 (29)",
    "Combat Shotgun (27)",
    "M4 (31)",
    "Sniper Rifle (34)",
    "Tear Gas (17)"
};

new const HitmanWeapons[][] =
{
    "Knife (4)",
    "Camera (43)",
    "Silenced Pistol (23)",
    "Desert Eagle (24)",
    "Shotgun (25)",
    "MP5 (29)",
    "Combat Shotgun (27)",
    "M4 (31)",
    "Sniper Rifle (34)"
};

CMD:r(playerid, params[]) return cmd_radio(playerid, params);
CMD:radio(playerid, params[])
{
    new message[256];
    if(Player[playerid][PlayerGroup] > -1)
    {
        if(sscanf(params, "s[256]", message)) 
        {
            return SendClientMessage(playerid, WHITE, "SYNTAX: /r(adio) [message]");
        }
        else
        {
            Array[0] = 0;
            format(Array, sizeof(Array), "%s %s (%s): %s", GroupRankNames[Player[playerid][PlayerGroup]][Player[playerid][GroupRank]], GetName(playerid), GroupDivisionNames[Player[playerid][PlayerGroup]][Player[playerid][GroupDiv]], message);
            SendGroupMessage(Player[playerid][PlayerGroup], Array, Group[Player[playerid][PlayerGroup]][GroupColour] * 256 + 255);

            format(Array, sizeof(Array), "[/RADIO] [Group: %d] %s", Player[playerid][PlayerGroup], message);
            Log(10, Array);
        }
    }
    return 1;
}

CMD:g(playerid, params[]) return cmd_group(playerid, params);
CMD:group(playerid, params[])
{
    new message[256];
    if(Player[playerid][PlayerGroup] > -1)
    {
        if(sscanf(params, "s[256]", message)) 
        {
            return SendClientMessage(playerid, WHITE, "SYNTAX: /g(roup) [message]");
        }
        else
        {
            Array[0] = 0;
            format(Array, sizeof(Array), "%s %s (%s): %s", GroupRankNames[Player[playerid][PlayerGroup]][Player[playerid][GroupRank]], GetName(playerid), GroupDivisionNames[Player[playerid][PlayerGroup]][Player[playerid][GroupDiv]], message);
            SendGroupMessage(Player[playerid][PlayerGroup], Array, YELLOWGREEN);

            format(Array, sizeof(Array), "[/GROUP] [Group: %d] %s", Player[playerid][PlayerGroup], message);
            Log(10, Array);
        }
    }
    return 1;
}

CMD:dept(playerid, params[]) return cmd_department(playerid, params);
CMD:department(playerid, params[])
{
    new message[256];
    if(Player[playerid][PlayerGroup] > -1 || Group[Player[playerid][PlayerGroup]][GroupType] == 0 || Group[Player[playerid][PlayerGroup]][GroupType] == 1 || Group[Player[playerid][PlayerGroup]][GroupType] == 2 || Group[Player[playerid][PlayerGroup]][GroupType] == 3)
    {
        if(sscanf(params, "s[256]", message)) 
        {
            return SendClientMessage(playerid, WHITE, "SYNTAX: /department [message]");
        }
        else
        {
            Array[0] = 0;
            format(Array, sizeof(Array), "%s %s %s (%s): %s", Group[Player[playerid][PlayerGroup]][GroupName], GroupRankNames[Player[playerid][PlayerGroup]][Player[playerid][GroupRank]], GetName(playerid), GroupDivisionNames[Player[playerid][PlayerGroup]][Player[playerid][GroupDiv]], message);
            foreach(new i: Player)
            {
                if(Group[Player[i][PlayerGroup]][GroupType] == 0 || Group[Player[i][PlayerGroup]][GroupType] == 1 || Group[Player[i][PlayerGroup]][GroupType] == 2 || Group[Player[i][PlayerGroup]][GroupType] == 3) SendClientMessage(i, LIGHTORANGE, Array);
            }

            format(Array, sizeof(Array), "[/DEPARTMENT] [Group: %d] %s", Player[playerid][PlayerGroup], message);
            Log(10, Array);
        }
    }
    return 1;
}

CMD:badge(playerid, params[])
{
    if(Player[playerid][PlayerGroup] > -1 || Group[Player[playerid][PlayerGroup]][GroupType] == 0 || Group[Player[playerid][PlayerGroup]][GroupType] == 1 || Group[Player[playerid][PlayerGroup]][GroupType] == 2 || Group[Player[playerid][PlayerGroup]][GroupType] == 3)
    {
        if(Player[playerid][OnDuty] == 0)
        {
            SetPlayerColor(playerid, Group[Player[playerid][PlayerGroup]][GroupColour] * 256 + 255);
            SendClientMessage(playerid, WHITE, "You have attached your badge, and are now being identified as on duty.");
            Player[playerid][OnDuty] = 1;
        }
        else
        {
            SetPlayerColor(playerid, 0xFFFFFFFF);
            SendClientMessage(playerid, WHITE, "You have deattached your badge, and are now being identified as off duty.");
            Player[playerid][OnDuty] = 0;
        }
    }
    return 1;
}

CMD:locker(playerid, params[])
{
    if(Player[playerid][PlayerGroup] > -1)
    {
        for(new i; i < MAX_LOCKERS; i++)
        {
            if(IsPlayerInRangeOfPoint(playerid, 5.0, Locker[i][LockerPos][0], Locker[i][LockerPos][1], Locker[i][LockerPos][2]) && Player[playerid][PlayerGroup] == Locker[i][LockerGroup])
            {
                switch(Group[Player[playerid][PlayerGroup]][GroupType])
                {
                    case 0, 1: ShowPlayerDialog(playerid, DIALOG_LOCKER_POLICE, DIALOG_STYLE_LIST, "Locker", "Duty\nFirst Aid\nKevlar\nClothes\nWeapons", "Select", "Cancel");
                    case 2, 3: ShowPlayerDialog(playerid, DIALOG_LOCKER_GOVERNMENT, DIALOG_STYLE_LIST, "Locker", "Duty\nFirst Aid\nKevlar\nClothes", "Select", "Cancel");
                    case 4: ShowPlayerDialog(playerid, DIALOG_LOCKER_HITMAN, DIALOG_STYLE_LIST, "Locker", "First Aid\nKevlar\nClothes\nWeapons", "Select", "Cancel");
                }
            }
        }
    }
    return 1;
}

CMD:backup(playerid, params[])
{
    if(Player[playerid][PlayerGroup] > -1)
    {
        if(Group[Player[playerid][PlayerGroup]][GroupType] == 0 || Group[Player[playerid][PlayerGroup]][GroupType] == 1 || Group[Player[playerid][PlayerGroup]][GroupType] == 2 || Group[Player[playerid][PlayerGroup]][GroupType] == 3)
        {
            new code, all;
            if(sscanf(params, "D(0)D(0)", all, code)) 
            {
                SendClientMessage(playerid, WHITE, "SYNTAX: /backup [all] [option]");
                return SendClientMessage(playerid, GREY, "Options: 1: Non-emergency, 2: Emergency");
            }
            else
            {
                new location[50];
                GetPlayer3DZone(playerid, location, 50);

                Array[0] = 0;
                switch(Player[playerid][Backup])
                {
                    case 0:
                    {
                        switch(all)
                        {
                            case 1:
                            {
                                switch(code)
                                {
                                    case 1: format(Array, sizeof(Array), "%s is requesting non-emergency backup at their location: %s", GetName(playerid), location);
                                    default: format(Array, sizeof(Array), "%s is requesting emergency backup at their location: %s", GetName(playerid), location);
                                }
                                foreach(new i: Player)
                                {
                                    if(Group[Player[i][PlayerGroup]][GroupType] == 0 || Group[Player[i][PlayerGroup]][GroupType] == 1 || Group[Player[i][PlayerGroup]][GroupType] == 2 || Group[Player[i][PlayerGroup]][GroupType] == 3) SendClientMessage(i, LIGHTORANGE, Array);
                                }
                                Player[playerid][Backup] = 2;
                            }
                            default:
                            {
                                switch(code)
                                {
                                    case 1: format(Array, sizeof(Array), "%s is requesting non-emergency backup at their location: %s", GetName(playerid), location);
                                    default: format(Array, sizeof(Array), "%s is requesting emergency backup at their location: %s", GetName(playerid), location);
                                }
                                SendGroupMessage(Player[playerid][PlayerGroup], Array, Group[Player[playerid][PlayerGroup]][GroupColour] * 256 + 255);
                                Player[playerid][Backup] = 1;
                            }
                        }
                    }
                    case 1:
                    {
                        format(Array, sizeof(Array), "%s no longer requests backup.", GetName(playerid));
                        SendGroupMessage(Player[playerid][PlayerGroup], Array, Group[Player[playerid][PlayerGroup]][GroupColour] * 256 + 255);
                        Player[playerid][Backup] = 0;
                    }
                    case 2:
                    {
                        format(Array, sizeof(Array), "%s no longer requests backup.", GetName(playerid));
                        foreach(new i: Player)
                        {
                            if(Group[Player[i][PlayerGroup]][GroupType] == 0 || Group[Player[i][PlayerGroup]][GroupType] == 1 || Group[Player[i][PlayerGroup]][GroupType] == 2 || Group[Player[i][PlayerGroup]][GroupType] == 3) SendClientMessage(i, LIGHTORANGE, Array);
                        }
                        Player[playerid][Backup] = 0;
                    }
                }   
            }
        }
        else return SendClientMessage(playerid, WHITE, "You are not in a law enforcement agency.");
    }
    else SendClientMessage(playerid, WHITE, "You are not in a law enforcement agency.");
    return 1;
}

CMD:backupcalls(playerid, params[])
{
    if(Player[playerid][PlayerGroup] > -1)
    {
        if(Group[Player[playerid][PlayerGroup]][GroupType] == 0 || Group[Player[playerid][PlayerGroup]][GroupType] == 1 || Group[Player[playerid][PlayerGroup]][GroupType] == 2 || Group[Player[playerid][PlayerGroup]][GroupType] == 3)
        {
            SendClientMessage(playerid, GREY, "---------------------------------------------------------------------------------------------------------------------------");

            Array[0] = 0;
            new backup;
            foreach(new i: Player)
            {
                switch(Player[i][Backup])
                {
                    case 1: 
                    {
                        if(Player[playerid][PlayerGroup] == Player[i][PlayerGroup]) 
                        {
                            format(Array, 256, "%s (%s)", GetName(playerid), Group[Player[playerid][PlayerGroup]][GroupName]);
                            SendClientMessage(playerid, WHITE, Array);
                            backup++;
                        }
                    }
                    case 2: 
                    {
                        format(Array, 256, "%s (%s)", GetName(playerid), Group[Player[playerid][PlayerGroup]][GroupName]);
                        SendClientMessage(playerid, WHITE, Array);
                        backup++;
                    }
                    default: Player[i][Backup] = 0;
                }
            }
            if(backup == 0) SendClientMessage(playerid, DARKGREY, "Nobody has requested backup.");

            SendClientMessage(playerid, GREY, "---------------------------------------------------------------------------------------------------------------------------");
        }
    }
    return 1;
}

CMD:setrank(playerid, params[])
{
    new id, rank;
    if(Player[playerid][PlayerGroup] > -1 && Player[playerid][Leader] > 0)
    {
        if(sscanf(params, "ud", id, rank)) 
        {
            return SendClientMessage(playerid, WHITE, "SYNTAX: /setrank [playerid] [rank]");
        }
        else
        {
            if(Player[playerid][PlayerGroup] == Player[id][PlayerGroup])
            {
                if(rank > -1 || rank < MAX_GROUP_RANKS)
                {
                    if(rank < Player[playerid][GroupRank] || Player[playerid][GroupRank] == GetMaxGroupRank(Player[playerid][PlayerGroup]))
                    {
                        if(strfind(GroupRankNames[Player[playerid][PlayerGroup]][rank], "None", true) == -1)
                        {
                            Array[0] = 0;
                            Player[id][GroupRank] = rank;

                            format(Array, sizeof(Array), "You have set %s's rank to %s(%d)", GetName(id), GroupRankNames[Player[playerid][PlayerGroup]][rank], rank);
                            SendClientMessage(playerid, LIGHTBLUE, Array);
                            format(Array, sizeof(Array), "%s has set your rank to %s(%d)", GetName(playerid), GroupRankNames[Player[playerid][PlayerGroup]][rank], rank);
                            SendClientMessage(playerid, LIGHTBLUE, Array);
                            format(Array, sizeof(Array), "%s has set %s's rank to %s(%d)", GetName(playerid), GetName(id), GroupRankNames[Player[playerid][PlayerGroup]][rank], rank);
                            Log(11, Array);
                        }
                        else return SendClientMessage(playerid, WHITE, "That rank is not set up.");
                    }
                    else return SendClientMessage(playerid, WHITE, "You cannot change a person's rank to an equal or higher rank than yours.");
                }
                else return SendClientMessage(playerid, WHITE, "Rank numbers are 0 through 9.");                    
            }
            else return SendClientMessage(playerid, WHITE, "You cannot set a rank for someone who is not in your group.");  
        }
    }
    else SendClientMessage(playerid, WHITE, "You are not a group leader.");
    return 1;
}

CMD:setdivision(playerid, params[])
{
    new id, div;
    if(Player[playerid][PlayerGroup] > -1 && Player[playerid][Leader] > 0)
    {
        if(sscanf(params, "ud", id, div)) 
        {
            return SendClientMessage(playerid, WHITE, "SYNTAX: /setdivision [playerid] [division]");
        }
        else
        {
            if(Player[playerid][PlayerGroup] == Player[id][PlayerGroup])
            {
                if(div > -1 || div < 7)
                {
                    if(Player[id][GroupRank] < Player[playerid][GroupRank] || Player[playerid][GroupRank] == GetMaxGroupRank(Player[playerid][PlayerGroup]))
                    {
                        if(strfind(GroupDivisionNames[Player[playerid][PlayerGroup]][div], "None", true) == -1)
                        {
                            Array[0] = 0;
                            Player[id][GroupDiv] = div;

                            format(Array, sizeof(Array), "You have set %s's division to %s(%d)", GetName(id), GroupDivisionNames[Player[playerid][PlayerGroup]][div], div);
                            SendClientMessage(playerid, LIGHTBLUE, Array);
                            format(Array, sizeof(Array), "%s has set your division to %s(%d)", GetName(playerid), GroupDivisionNames[Player[playerid][PlayerGroup]][div], div);
                            SendClientMessage(playerid, LIGHTBLUE, Array);
                            format(Array, sizeof(Array), "%s has set %s's division to %s(%d)", GetName(playerid), GetName(id), GroupDivisionNames[Player[playerid][PlayerGroup]][div], div);
                            Log(11, Array);
                        }
                        else return SendClientMessage(playerid, WHITE, "That division is not set up.");
                    }
                    else return SendClientMessage(playerid, WHITE, "You cannot change a person's division who's rank isan equal or higher rank than yours.");
                }
                else return SendClientMessage(playerid, WHITE, "Division numbers are 0 through 6.");                    
            }
            else return SendClientMessage(playerid, WHITE, "You cannot set a division for someone who is not in your group.");  
        }
    }
    else SendClientMessage(playerid, WHITE, "You are not a group leader.");
    return 1;
}

CMD:groupbalance(playerid, params[])
{
    if(Player[playerid][PlayerGroup] > -1 && Player[playerid][Leader] > 0)
    {
        SendClientMessage(playerid, WHITE, "-----------------------------");

        format(Array, sizeof(Array), "Money: $%s", FormatNumberToString(Group[Player[playerid][PlayerGroup]][GroupMoney]));
        SendClientMessage(playerid, GREY, Array);
        SendClientMessage(playerid, WHITE, "-----------------------------");
    }
    else SendClientMessage(playerid, WHITE, "You are not a group leader.");
    return 1;
}

CMD:groupwithdraw(playerid, params[])
{
    new id, amount;
    if(Player[playerid][PlayerGroup] > -1 && Player[playerid][Leader] > 0)
    {
        if(sscanf(params, "dd", id, amount)) 
        {
            SendClientMessage(playerid, WHITE, "SYNTAX: /groupwithdraw [id] [amount]");
            return SendClientMessage(playerid, GREY, "IDs: 1 - Money");
        }
        else
        {
            if(IsPlayerInRangeOfPoint(playerid, 5.0, Group[Player[playerid][PlayerGroup]][GroupSafePos][0], Group[Player[playerid][PlayerGroup]][GroupSafePos][1], Group[Player[playerid][PlayerGroup]][GroupSafePos][2]))
            {
                switch(id)
                {
                    case 1:
                    {
                        if(amount > Group[Player[playerid][PlayerGroup]][GroupMoney]) return SendClientMessage(playerid, WHITE, "Your group does not have that much money!");
                        if(amount < 1) return SendClientMessage(playerid, WHITE, "Your amount must be more than 0.");

                        GiveMoneyEx(playerid, amount);
                        Group[Player[playerid][PlayerGroup]][GroupMoney] -= amount;

                        format(Array, sizeof(Array), "You have withdrawn $%s from the group locker.", FormatNumberToString(amount));
                        SendClientMessage(playerid, WHITE, Array);

                        format(Array, sizeof(Array), "%s has withdrawn $%s from the group locker.", GetName(playerid), FormatNumberToString(amount));
                    }
                    default:
                    {
                        SendClientMessage(playerid, WHITE, "SYNTAX: /groupwithdraw [id] [amount]");
                        return SendClientMessage(playerid, GREY, "IDs: 1 - Money");
                    }
                }
                Log(16, Array);
            }
            else return SendClientMessage(playerid, WHITE, "You are not near your group safe.");
        }
    }
    else SendClientMessage(playerid, WHITE, "You are not a group leader.");
    return 1;
}

CMD:groupdeposit(playerid, params[])
{
    new id, amount;
    if(Player[playerid][PlayerGroup] > -1 && Player[playerid][Leader] > 0)
    {
        if(sscanf(params, "dd", id, amount)) 
        {
            SendClientMessage(playerid, WHITE, "SYNTAX: /groupdeposit [id] [amount]");
            return SendClientMessage(playerid, GREY, "IDs: 1 - Money");
        }
        else
        {
            if(IsPlayerInRangeOfPoint(playerid, 5.0, Group[Player[playerid][PlayerGroup]][GroupSafePos][0], Group[Player[playerid][PlayerGroup]][GroupSafePos][1], Group[Player[playerid][PlayerGroup]][GroupSafePos][2]))
            {
                switch(id)
                {
                    case 1:
                    {
                        if(amount > Player[playerid][Money]) return SendClientMessage(playerid, WHITE, "You do not have that much money!");
                        if(amount < 1) return SendClientMessage(playerid, WHITE, "Your amount must be more than 0.");

                        GiveMoneyEx(playerid, -amount);
                        Group[Player[playerid][PlayerGroup]][GroupMoney] += amount;

                        format(Array, sizeof(Array), "You have deposited $%s from the group locker.", FormatNumberToString(amount));
                        SendClientMessage(playerid, WHITE, Array);

                        format(Array, sizeof(Array), "%s has deposited $%s from the group locker.", GetName(playerid), FormatNumberToString(amount));
                    }
                    default:
                    {
                        SendClientMessage(playerid, WHITE, "SYNTAX: /groupdeposit [id] [amount]");
                        return SendClientMessage(playerid, GREY, "IDs: 1 - Money");
                    }
                }
                Log(16, Array);
            }
            else return SendClientMessage(playerid, WHITE, "You are not near your group safe.");
        }
    }
    else SendClientMessage(playerid, WHITE, "You are not a group leader.");
    return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
        case DIALOG_LOCKER_CLOTHES:
        {
            if(!response) return 1;
            if(!IsNumeric(inputtext)) 
            {
                SendClientMessage(playerid, WHITE, "Please enter a numerical value.");
                return ShowPlayerDialog(playerid, DIALOG_LOCKER_CLOTHES, DIALOG_STYLE_INPUT, "Locker - Clothing", "Please enter a skin number to change into it.", "Select", "Cancel");
            }   

            if(!SkinNumberInvalid(strval(inputtext)))
            {
                Player[playerid][Skin] = strval(inputtext);
                SetPlayerSkin(playerid, strval(inputtext));
            }
            else
            {
                SendClientMessage(playerid, WHITE, "That is not a skin number.");
                return ShowPlayerDialog(playerid, DIALOG_LOCKER_CLOTHES, DIALOG_STYLE_INPUT, "Locker - Clothing", "Please enter a skin number to change into it.", "Select", "Cancel");
            }
        }

        case DIALOG_LOCKER_GOVERNMENT:
        {
            if(!response) return 1;
            switch(listitem)
            {
                case 0:
                {
                    if(Player[playerid][OnDuty] == 0)
                    {
                        SetPlayerColor(playerid, Group[Player[playerid][PlayerGroup]][GroupColour] * 256 + 255);
                        Player[playerid][OnDuty] = 1;

                        format(Array, sizeof(Array), "* %s takes out their badge from their locker.", GetName(playerid));
                        SendNearbyMessage(playerid, Array, SCRIPTPURPLE, 30.0);
                    }
                    else
                    {
                        SetPlayerColor(playerid, WHITE);
                        Player[playerid][OnDuty] = 0;

                        format(Array, sizeof(Array), "* %s places their badge back into their locker.", GetName(playerid));
                        SendNearbyMessage(playerid, Array, SCRIPTPURPLE, 30.0);
                    }
                }
                case 1: SetPlayerHealth(playerid, 100);
                case 2: SetPlayerArmour(playerid, 100);
                case 3: ShowPlayerDialog(playerid, DIALOG_LOCKER_CLOTHES, DIALOG_STYLE_INPUT, "Locker - Clothing", "Please enter a skin number to change into it.", "Select", "Cancel");
            }
        }

        case DIALOG_LOCKER_POLICE:
        {
            if(!response) return 1;
            switch(listitem)
            {
                case 0:
                {
                    if(Player[playerid][OnDuty] == 0)
                    {
                        SetPlayerColor(playerid, Group[Player[playerid][PlayerGroup]][GroupColour] * 256 + 255);
                        Player[playerid][OnDuty] = 1;

                        format(Array, sizeof(Array), "* %s takes out their badge from their locker.", GetName(playerid));
                        SendNearbyMessage(playerid, Array, SCRIPTPURPLE, 30.0);
                    }
                    else
                    {
                        SetPlayerColor(playerid, WHITE);
                        Player[playerid][OnDuty] = 0;

                        format(Array, sizeof(Array), "* %s places their badge back into their locker.", GetName(playerid));
                        SendNearbyMessage(playerid, Array, SCRIPTPURPLE, 30.0);
                    }
                }
                case 1: SetPlayerHealth(playerid, 100);
                case 2: SetPlayerArmour(playerid, 100);
                case 3: ShowPlayerDialog(playerid, DIALOG_LOCKER_CLOTHES, DIALOG_STYLE_INPUT, "Locker - Clothing", "Please enter a skin number to change into it.", "Purchase", "Cancel");
                case 4: 
                { 
                    for(new i; i < sizeof(PoliceWeapons); i++) format(Array, sizeof(Array), "%s\n%s", Array, PoliceWeapons[i]);
                    ShowPlayerDialog(playerid, DIALOG_LOCKER_WEAPONS, DIALOG_STYLE_LIST, "Locker - Weapons", Array, "Select", "Cancel");
                }
            }
        }

        case DIALOG_LOCKER_HITMAN:
        {
            if(!response) return 1;
            switch(listitem)
            {
                case 0: SetPlayerHealth(playerid, 100);
                case 1: SetPlayerArmour(playerid, 100);
                case 2: ShowPlayerDialog(playerid, DIALOG_LOCKER_CLOTHES, DIALOG_STYLE_INPUT, "Locker - Clothing", "Please enter a skin number to change into it.", "Purchase", "Cancel");
                case 3: 
                { 
                    for(new i; i < sizeof(HitmanWeapons); i++) format(Array, sizeof(Array), "%s\n%s", Array, HitmanWeapons[i]);
                    ShowPlayerDialog(playerid, DIALOG_LOCKER_WEAPONS, DIALOG_STYLE_LIST, "Locker - Weapons", Array, "Select", "Cancel");
                }
            }
        }

        case DIALOG_LOCKER_WEAPONS:
        {
            if(!response) return 1;
            switch(listitem)
            {
                case 0 .. 15: // Yes I know there's not 15 options. But they won't be selecting anything higher than what they're given. Suck my dick.
                {
                    Array[0] = 0;
                    new idstring[4], id[3];

                    id[1] = strfind(inputtext, "(");
                    id[2] = strfind(inputtext, ")");
                    
                    strmid(idstring, inputtext, id[1]+1, id[2]);
                    id[0] = strval(idstring);

                    GivePlayerWeaponEx(playerid, id[0]);

                    new weaponname[16];
                    GetWeaponName(id[0], weaponname, 16);

                    format(Array, sizeof(Array), "* %s has taken a %s from their locker.", GetName(playerid), weaponname); 
                    SendNearbyMessage(playerid, Array, SCRIPTPURPLE, 30.0);

                    format(Array, sizeof(Array), "%s %s (%s) has withdrawn a %s from the group locker.", GroupRankNames[Player[playerid][PlayerGroup]][Player[playerid][GroupRank]], GetName(playerid), GroupDivisionNames[Player[playerid][PlayerGroup]][Player[playerid][GroupDiv]], weaponname); 
                    Log(16, Array);
                }
            }
        }
    }
    return 1;
}

SendGroupMessage(group, message[], colour)
{
	if(group > -1)
	{
		foreach(new i: Player)
		{
			if(Player[i][PlayerGroup] == group) SendClientMessage(i, colour, message);
		}
	}
	return 1;
}

GetMaxGroupRank(group)
{
    new rank;
    for (new i; i < MAX_GROUP_RANKS; i++)
    {
        if(strfind(GroupRankNames[group][i], "None", true) == -1) rank = i;
    }
    return rank;
}