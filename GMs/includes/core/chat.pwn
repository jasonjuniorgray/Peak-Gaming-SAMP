#include <YSI\y_hooks>

CMD:me(playerid, params[])
{
	if(isnull(params))
	{
		return SendClientMessage(playerid, WHITE, "SYNTAX: /me [action]");
	}
	Array[0] = 0;

	format(Array, sizeof(Array), "* %s %s", GetName(playerid), params);
	SendNearbyMessage(playerid, Array, PURPLE, 30.0);
	format(Array, sizeof(Array), "[/ME] %s", Array);
	Log(8, Array);
	return 1;
}

CMD:lme(playerid, params[])
{
	if(isnull(params))
	{
		return SendClientMessage(playerid, WHITE, "SYNTAX: /lme [action]");
	}
	Array[0] = 0;

	format(Array, sizeof(Array), "* %s %s", GetName(playerid), params);
	SendNearbyMessage(playerid, Array, PURPLE, 10.0);

	format(Array, sizeof(Array), "[/LME] %s", Array);
	Log(8, Array);
	return 1;
}

CMD:do(playerid, params[])
{
	if(isnull(params))
	{
		return SendClientMessage(playerid, WHITE, "SYNTAX: /do [message]");
	}
	Array[0] = 0;
	
	format(Array, sizeof(Array), "* %s (( %s ))", params, GetName(playerid));
	SendNearbyMessage(playerid, Array, PURPLE, 30.0);

	format(Array, sizeof(Array), "[/DO] %s", Array);
	Log(8, Array);
	return 1;
}

CMD:ldo(playerid, params[])
{
	if(isnull(params))
	{
		return SendClientMessage(playerid, WHITE, "SYNTAX: /ldo [message]");
	}
	Array[0] = 0;
	
	format(Array, sizeof(Array), "* %s (( %s ))",params, GetName(playerid));
	SendNearbyMessage(playerid, Array, PURPLE, 10.0);

	format(Array, sizeof(Array), "[/LDO] %s", Array);
	Log(8, Array);
	return 1;
}

CMD:s(playerid, params[]) return cmd_shout(playerid, params);
CMD:shout(playerid, params[])
{
	if(isnull(params))
	{
		return SendClientMessage(playerid, WHITE, "SYNTAX: /s(hout) [message]");
	}
	Array[0] = 0;
	
	format(Array, sizeof(Array), "%s shouts: %s", GetName(playerid), params);
	SendNearbyMessage(playerid, Array, WHITE, 45.0);

	format(Array, sizeof(Array), "[/SHOUT] %s", Array);
	Log(8, Array);
	return 1;
}

CMD:l(playerid, params[]) return cmd_low(playerid, params);
CMD:low(playerid, params[])
{
	if(isnull(params))
	{
		return SendClientMessage(playerid, WHITE, "SYNTAX: /l(ow) [message]");
	}
	Array[0] = 0;
	
	format(Array, sizeof(Array), "%s says low: %s", GetName(playerid), params);
	SendNearbyMessage(playerid, Array, WHITE, 5.0);

	format(Array, sizeof(Array), "[/LOW] %s", Array);
	Log(8, Array);
	return 1;
}

CMD:ame(playerid, params[])
{
	if(isnull(params)) 
	{
		return SendClientMessage(playerid, WHITE, "SYNTAX: /ame [action]");
	}
	Array[0] = 0;

	format(Array, sizeof(Array), "%s %s", GetName(playerid), params);
	SetPlayerChatBubble(playerid, Array, PURPLE, 15.0, 5000);
	format(Array, sizeof(Array), "> %s", params);
	SendClientMessage(playerid, PURPLE, Array);

	format(Array, sizeof(Array), "[/AME] %s", Array);
	Log(8, Array);
	return 1;
}

CMD:b(playerid, params[])
{
	if(isnull(params))
	{
		return SendClientMessage(playerid, WHITE, "SYNTAX: /b [message]");
	}
	Array[0] = 0;
	
	format(Array, sizeof(Array), "(( %s: %s ))", GetName(playerid), params);
	SendNearbyMessage(playerid, Array, DARKGREY, 30.0);

	format(Array, sizeof(Array), "[/B] (( %s ))", Array);
	Log(8, Array);
	return 1;
}

CMD:w(playerid, params[]) return cmd_shout(playerid, params);
CMD:whisper(playerid, params[])
{
	new id, message[256];
	if(sscanf(params, "ds[256]", id, message)) 
	{
		return SendClientMessage(playerid, WHITE, "SYNTAX: /w(hisper) [playerid] [message]");
	}
	if(IsPlayerConnectedEx(id))
	{
		if(IsPlayerNearPlayer(playerid, id, 5.0))
		{
			Array[0] = 0;
	
			format(Array, sizeof(Array), "%s whispers to you: %s", GetName(playerid), message);
			SendClientMessage(id, YELLOW, Array);
			format(Array, sizeof(Array), "You whispered to %s: %s", GetName(id), message);
			SendClientMessage(playerid, YELLOW, Array);
			format(Array, sizeof(Array), "%s %s", GetName(playerid), params);
			SetPlayerChatBubble(playerid, Array, PURPLE, 15.0, 5000);

			format(Array, sizeof(Array), "[/WHISPER] %s whispers to %s: %s", GetName(playerid), GetName(id), message);
			Log(8, Array);
		}
		return SendClientMessage(playerid, WHITE, "You are not close enough to that player!");
	}
	else SendClientMessage(playerid, WHITE, "That player is not connected!");
	return 1;
}

CMD:pm(playerid, params[])
{
	new id, message[256];
	if(sscanf(params, "ds[256]", id, message)) 
	{
		return SendClientMessage(playerid, WHITE, "SYNTAX: /pm [playerid] [message]");
	}
	if(IsPlayerConnectedEx(id))
	{
		if(Player[playerid][AdminLevel] == 0 && Player[id][AdminDuty] < 1 || GetPVarInt(playerid, "ReportActive") && Reports[GetPVarInt(playerid, "ReportActive")][CheckingReport] == id)
		{
			Array[0] = 0;
	
			format(Array, sizeof(Array), "PM from %s (ID: %d): %s", GetName(playerid), playerid, message);
			SendClientMessage(id, YELLOW, Array);
			format(Array, sizeof(Array), "You have sent %s: %s", GetName(id), message);
			SendClientMessage(playerid, YELLOW, Array);

			format(Array, sizeof(Array), "[/PM] %s sent a message to %s: %s", GetName(playerid), GetName(id), message);
			Log(8, Array);
		}
		return SendClientMessage(playerid, WHITE, "You cannot message on duty admins, unless they have accepted your report.");
	}
	else SendClientMessage(playerid, WHITE, "That player is not connected!");
	return 1;
}

CMD:accent(playerid, params[])
{
	Array[0] = 0;

	ShowPlayerDialog(playerid, DIALOG_ACCENTS, DIALOG_STYLE_LIST, "Chose an Accent", "American\n\
		Southern\n\
		Canadian\n\
		British\n\
		Australian\n\
		Spanish\n\
		Irish\n\
		Italian\n\
		Sweedish\n\
		Asian\n\
		Russian\n\
		German\n\
		Arabic\n\
		Norwegian\n", "Select", "Close");
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case DIALOG_ACCENTS:
		{
			if(!response) return 1;
			Array[0] = 0;
			switch(listitem)
			{
				case 0 .. 13: Player[playerid][Accent] = listitem;
			}

			format(Array, sizeof(Array), "You have changed your accent to %s", inputtext);
			SendClientMessage(playerid, WHITE, Array);
		}
	}
	return 1;
}

GetPlayerAccent(playerid)
{
	new string[16];

	switch(Player[playerid][Accent])
	{
		case 0: format(string, 16, "American");
		case 1: format(string, 16, "Southern");
		case 2: format(string, 16, "Canadian");
		case 3: format(string, 16, "British");
		case 4: format(string, 16, "Australian");
		case 5: format(string, 16, "Spanish");
		case 6: format(string, 16, "Irish");
		case 7: format(string, 16, "Italian");
		case 8: format(string, 16, "Sweedish");
		case 9: format(string, 16, "Asian");
		case 10: format(string, 16, "Russian");
		case 11: format(string, 16, "German");
		case 12: format(string, 16, "Arabic");
		case 13: format(string, 16, "Norwegian");
		default: 
		{
			format(string, 16, "American");
			Player[playerid][Accent] = 0;
		}
	}
	return string;
}