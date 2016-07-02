#include <YSI\y_hooks>

CMD:report(playerid, params[])
{
	if(GetPVarInt(playerid, "ReportActive")) return SendClientMessage(playerid, WHITE, "You can only have one active report at a time. Try /cancel report to create another report.");
	new string[500];
	format(string, sizeof(string), "Falling\n\
		Deathmatch\n\
		Metagaming\n\
		Powergaming\n\
		Hacking\n\
		Exploiting\n\
		Non-RP Behaviour\n\
		Other");

	ShowPlayerDialog(playerid, DIALOG_REPORT, DIALOG_STYLE_LIST, "Report Menu", string, "Select", "Cancel");
	return 1;
}

CMD:reports(playerid, params[])
{
	if(Player[playerid][AdminLevel] >= 1)
	{
		ListReports(playerid);
	}
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	new string[256];
	switch(dialogid)
	{
        case DIALOG_REPORT:
        {
        	switch(listitem)
        	{
        		case 0: 
        		{
        			if(!response) return 1;
        			TogglePlayerControllableEx(playerid, FALSE);
        			SendReport(playerid, "[URGENT] Falling");

        			SendClientMessage(playerid, WHITE, "You have reported for falling. You have been frozen to prevent damage.");
        		}
        		case 1: ShowPlayerDialog(playerid, DIALOG_REPORT2, DIALOG_STYLE_INPUT, "Deathmatch", "Enter the name or id of the player you're reporting", "Select", "Cancel");
        		case 2: ShowPlayerDialog(playerid, DIALOG_REPORT3, DIALOG_STYLE_INPUT, "Metagaming", "Enter the name or id of the player you're reporting", "Select", "Cancel");
        		case 3: ShowPlayerDialog(playerid, DIALOG_REPORT4, DIALOG_STYLE_INPUT, "Powergaming", "Enter the name or id of the player you're reporting", "Select", "Cancel");
        		case 4: ShowPlayerDialog(playerid, DIALOG_REPORT5, DIALOG_STYLE_INPUT, "Hacking", "Enter the name or id of the player you're reporting", "Select", "Cancel");
        		case 5: ShowPlayerDialog(playerid, DIALOG_REPORT6, DIALOG_STYLE_INPUT, "Exploiting", "Enter the name or id of the player you're reporting", "Select", "Cancel");
        		case 6: ShowPlayerDialog(playerid, DIALOG_REPORT7, DIALOG_STYLE_INPUT, "Non-RP Behaviour", "Enter the name or id of the player you're reporting", "Select", "Cancel");
        		case 7: ShowPlayerDialog(playerid, DIALOG_REPORT8, DIALOG_STYLE_INPUT, "Other", "Please specify your report", "Select", "Cancel");
        	}
        }
        case DIALOG_REPORT2:
        {
        	new player;
        	if(!response) return 1;
          	if(sscanf(inputtext, "u", player)) { return ShowPlayerDialog(playerid, DIALOG_REPORT2, DIALOG_STYLE_INPUT, "Report Menu", "(Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");	}
			else if(!IsPlayerConnectedEx(player)) { return ShowPlayerDialog(playerid, DIALOG_REPORT2, DIALOG_STYLE_INPUT, "Report Menu", "(Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel"); }
			//else if(player == playerid) { return SendClientMessage(playerid, WHITE, "You can't submit a report on yourself."); }

        	format(string, sizeof(string), "[URGENT] %s(%d) - Deathmatching", GetName(player), player);
        	SendReport(playerid, string);

        	format(string, sizeof(string), "You have submitted a report on %s for Deathmatching. Please wait for a reply.", GetName(player));
			SendClientMessage(playerid, WHITE, string);
        }
        case DIALOG_REPORT3:
        {
        	new player;
        	if(!response) return 1;
          	if(sscanf(inputtext, "u", player)) { return ShowPlayerDialog(playerid, DIALOG_REPORT2, DIALOG_STYLE_INPUT, "Report Menu", "(Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");	}
			else if(!IsPlayerConnectedEx(player)) { return ShowPlayerDialog(playerid, DIALOG_REPORT2, DIALOG_STYLE_INPUT, "Report Menu", "(Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel"); }
			else if(player == playerid) { return SendClientMessage(playerid, WHITE, "You can't submit a report on yourself."); }

        	format(string, sizeof(string), "%s(%d) - Metagaming", GetName(player), player);
        	SendReport(playerid, string);

        	format(string, sizeof(string), "You have submitted a report on %s for Metagaming. Please wait for a reply.", GetName(player));
			SendClientMessage(playerid, WHITE, string);
        }
        case DIALOG_REPORT4:
        {
        	new player;
        	if(!response) return 1;
          	if(sscanf(inputtext, "u", player)) { return ShowPlayerDialog(playerid, DIALOG_REPORT2, DIALOG_STYLE_INPUT, "Report Menu", "(Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");	}
			else if(!IsPlayerConnectedEx(player)) { return ShowPlayerDialog(playerid, DIALOG_REPORT2, DIALOG_STYLE_INPUT, "Report Menu", "(Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel"); }
			else if(player == playerid) { return SendClientMessage(playerid, WHITE, "You can't submit a report on yourself."); }

        	format(string, sizeof(string), "%s(%d) - Powergaming", GetName(player), player);
        	SendReport(playerid, string);

        	format(string, sizeof(string), "You have submitted a report on %s for Powergaming. Please wait for a reply.", GetName(player));
			SendClientMessage(playerid, WHITE, string);
        }
        case DIALOG_REPORT5:
        {
        	new player;
        	if(!response) return 1;
          	if(sscanf(inputtext, "u", player)) { return ShowPlayerDialog(playerid, DIALOG_REPORT2, DIALOG_STYLE_INPUT, "Report Menu", "(Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");	}
			else if(!IsPlayerConnectedEx(player)) { return ShowPlayerDialog(playerid, DIALOG_REPORT2, DIALOG_STYLE_INPUT, "Report Menu", "(Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel"); }
			else if(player == playerid) { return SendClientMessage(playerid, WHITE, "You can't submit a report on yourself."); }

        	format(string, sizeof(string), "[URGENT] %s(%d) - Hacking", GetName(player), player);
        	SendReport(playerid, string);

        	format(string, sizeof(string), "You have submitted a report on %s for Hacking. Please wait for a reply.", GetName(player));
			SendClientMessage(playerid, WHITE, string);
        }
        case DIALOG_REPORT6:
        {
        	new player;
        	if(!response) return 1;
          	if(sscanf(inputtext, "u", player)) { return ShowPlayerDialog(playerid, DIALOG_REPORT2, DIALOG_STYLE_INPUT, "Report Menu", "(Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");	}
			else if(!IsPlayerConnectedEx(player)) { return ShowPlayerDialog(playerid, DIALOG_REPORT2, DIALOG_STYLE_INPUT, "Report Menu", "(Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel"); }
			else if(player == playerid) { return SendClientMessage(playerid, WHITE, "You can't submit a report on yourself."); }

        	format(string, sizeof(string), "%s(%d) - Exploiting", GetName(player), player);
        	SendReport(playerid, string);

        	format(string, sizeof(string), "You have submitted a report on %s for Exploiting. Please wait for a reply.", GetName(player));
			SendClientMessage(playerid, WHITE, string);
        }
        case DIALOG_REPORT7:
        {
        	new player;
        	if(!response) return 1;
          	if(sscanf(inputtext, "u", player)) { return ShowPlayerDialog(playerid, DIALOG_REPORT2, DIALOG_STYLE_INPUT, "Report Menu", "(Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel");	}
			else if(!IsPlayerConnectedEx(player)) { return ShowPlayerDialog(playerid, DIALOG_REPORT2, DIALOG_STYLE_INPUT, "Report Menu", "(Invalid Player) Enter the name or ID of the player.", "Enter", "Cancel"); }
			else if(player == playerid) { return SendClientMessage(playerid, WHITE, "You can't submit a report on yourself."); }

        	format(string, sizeof(string), "%s(%d) - Non-RP Behavior", GetName(player), player);
        	SendReport(playerid, string);

        	format(string, sizeof(string), "You have submitted a report on %s for Non-RP Behavior. Please wait for a reply.", GetName(player));
			SendClientMessage(playerid, WHITE, string);
        }
        case DIALOG_REPORT8:
        {
        	if(!response) return 1;
        	
        	format(string, sizeof(string), "%s", inputtext);
        	SendReport(playerid, string);
			SendClientMessage(playerid, WHITE, "You have submitted a report. Please wait for a reply.");
        }
    }
    return 1;
}

SendReport(playerid, report[])
{
    new id = -1, string[128];

	for(new i; i < MAX_REPORTS; ++i)
	{
		if(Reports[i][Used] == 0)
		{
			id = i;
			break;
		}
    }
    if(id != -1)
    {
       	foreach(new i: Player)
		{
			format(string, sizeof(string), "%s (ID: %i) | RID: %i | %s | Pend: 0 mins", GetName(playerid), playerid, id, report);
			SendToAdmins(ORANGE, string, 1, 1);
		}	

		SetPVarInt(playerid, "ReportActive", id);

        strmid(Reports[id][Report], report, 0, strlen(report), 128);

        Reports[id][Reporter] = playerid;
        Reports[id][ReportExpireTime] = 0;
        Reports[id][BeenUsed] = 1;
        Reports[id][Used] = 1;
        Reports[id][ReportExpireTimer] = SetTimerEx("ReportTimer", 60000, 0, "d", id);
    }
    else
    {
        ClearReports();
        SendReport(playerid, report);
    }
}

ClearReports() { for(new i; i < MAX_REPORTS; i++) ClearReport(i); }

ClearReport(id)
{
    if(Reports[id][Used] == 1) 
    {
        DeletePVar(Reports[id][Reporter], "ReportActive");
    }

    strmid(Reports[id][Report], "None", 0, 4, 4);

    Reports[id][CheckingReport] = -1;
    Reports[id][Reporter] = -1;
    Reports[id][ReportExpireTime] = 0;
    Reports[id][BeenUsed] = 0;
    Reports[id][Used] = 0;
    return 1;
}

ListReports(playerid)
{
	new string[128];
	SendClientMessage(playerid, ORANGE, "____________________ REPORTS _____________________");
	for(new i = MAX_REPORTS; i >= 0; i--)
	{
		if(Reports[i][Used] == 1)
		{
			format(string, sizeof(string), "%s (ID: %i) | ID: %i | %s | Pend: %d minutes", GetName(Reports[i][Reporter]), Reports[i][Reporter], i, (Reports[i][Report]), Reports[i][ReportExpireTime]);
			if(Reports[i][CheckingReport] == -1) SendClientMessage(playerid, BEIGE, string);
            else SendClientMessage(playerid, GREEN, string);
		}
	}
	SendClientMessage(playerid, ORANGE, "___________________________________________________");
}

forward ReportTimer(reportid);
public ReportTimer(reportid)
{
	if(Reports[reportid][Used] == 1)
	{
	    if(Reports[reportid][ReportExpireTime] >= 0)
	    {
	        Reports[reportid][ReportExpireTime]++;
  			Reports[reportid][ReportExpireTimer] = SetTimerEx("ReportTimer", 60000, 0, "d", reportid);
		}
	}
	return 1;
}