#include <YSI\y_hooks>

CMD:phone(playerid, params[])
{
	if(Player[playerid][PhoneNumber] > 0)
	{
		Array[0] = 0;
		format(Array, sizeof(Array), "%s takes out their phone, and unlocks it.");
		SetPlayerChatBubble(playerid, Array, PURPLE, 15.0, 5000);

		ShowPlayerDialog(playerid, DIALOG_PHONE, DIALOG_STYLE_LIST, "Phone", "Call\nText\nContacts\nMusic\nMaps", "Select", "Lock");
	}
	else SendClientMessage(playerid, WHITE, "You do not have a phone.");
	return 1;
}

CMD:call(playerid, params[])
{
	new number;
	if(sscanf(params, "d", number)) 
	{
		return SendClientMessage(playerid, WHITE, "SYNTAX: /call [number]");
	}
	else
	{
		Array[0] = 0;
		foreach(new i: Player)
		{
			if(Player[i][PhoneNumber] == number)
			{
				format(Array, sizeof(Array), "%s press a few buttons and presses the phone to their ear.", GetName(playerid));
				SetPlayerChatBubble(playerid, Array, PURPLE, 15.0, 5000);
				format(Array, sizeof(Array), "> %s press a few buttons and presses the phone to their ear.", GetName(playerid));
				SendClientMessage(playerid, PURPLE, Array);
				if(GetPVarInt(i, "Calling") || GetPVarInt(i, "OnPhone")) return SendClientMessage(playerid, GREY, "You just get a busy tone...");
				SetPVarInt(playerid, "Calling", i);

				format(Array, sizeof(Array), "%s phone begins to ring.", GetName(i));
				SendNearbyMessage(i, Array, PURPLE, 30.0);
				format(Array, sizeof(Array), "Your phone is being called. Number: %d", Player[playerid][PhoneNumber]);
				SendClientMessage(i, WHITE, Array);
				SendClientMessage(i, GREY, "Use /p(ickup) to answer it or /h(angup) to send it to voicemail.");
				Player[playerid][PhoneTimer] = SetTimerEx("CallReminder", 4000, 1, "i", i);
				return 1;
			}
		}
		SendClientMessage(playerid, GREY, "You just get a disconnect tone...");
		format(Array, sizeof(Array), "%s takes out their cellphone.", GetName(playerid));
		SetPlayerChatBubble(playerid, Array, PURPLE, 15.0, 5000);
	}
	return 1;
}

CMD:sms(playerid, params[])
{
	new number, message[256];
	if(sscanf(params, "ds[256]", number, message)) 
	{
		return SendClientMessage(playerid, WHITE, "SYNTAX: /sms [number] [message]");
	}
	else
	{
		Array[0] = 0;
		foreach(new i: Player)
		{
			if(Player[i][PhoneNumber] == number)
			{
				format(Array, sizeof(Array), "%s takes out their cellphone.", GetName(playerid));
				SetPlayerChatBubble(playerid, Array, PURPLE, 15.0, 5000);
				format(Array, sizeof(Array), "> %s takes out their cellphone.", GetName(playerid));
				SendClientMessage(playerid, PURPLE, Array);

				format(Array, sizeof(Array), "SMS: %s, Sender: %d.", message, Player[playerid][PhoneNumber]);
				SendNearbyMessage(i, Array, YELLOW, 30.0);
				format(Array, sizeof(Array), "You sent: %s to %d", message, Player[i][PhoneNumber]);
				SendNearbyMessage(playerid, Array, YELLOW, 30.0);
				return 1;
			}
		}
		format(Array, sizeof(Array), "SMS: %s, Sender: %d (%s).", message, Player[playerid][PhoneNumber], GetName(playerid));
		Log(8, Array);
		SendClientMessage(playerid, GREY, "The message failed to deliver.");
		format(Array, sizeof(Array), "%s takes out their cellphone.", GetName(playerid));
		SetPlayerChatBubble(playerid, Array, PURPLE, 15.0, 5000);
	}
	return 1;
}

CMD:pickup(playerid, params[])
{
	if(Player[playerid][PhoneTimer] > -1)
	{
		Array[0] = 0;
		format(Array, sizeof(Array), "%s answers their cellphone.", GetName(playerid));
		SetPlayerChatBubble(playerid, Array, PURPLE, 15.0, 5000);
		KillTimer(Player[playerid][PhoneTimer]);

		foreach(new i: Player)
		{
			if(GetPVarInt(i, "Calling") == playerid) 
			{
				SetPVarInt(i, "Calling", -1);
				SetPVarInt(i, "OnPhone", playerid);
				SetPVarInt(playerid, "OnPhone", i);
				return SendClientMessage(playerid, GREY, "The other person has answered.");
			}
		}
	}
	else SendClientMessage(playerid, WHITE, "Nobody has tried to call you.");
	return 1;
}

CMD:hangup(playerid, params[])
{
	if(GetPVarInt(playerid, "OnPhone") > -1)
	{
		Array[0] = 0;
		format(Array, sizeof(Array), "%s puts away their cellphone.", GetName(playerid));
		SetPlayerChatBubble(playerid, Array, PURPLE, 15.0, 5000);

		foreach(new i: Player)
		{
			if(GetPVarInt(i, "OnPhone") == playerid) 
			{
				SetPVarInt(playerid, "OnPhone", -1);
				SetPVarInt(i, "OnPhone", -1);
				SetPlayerChatBubble(i, Array, PURPLE, 15.0, 5000);
				return SendClientMessage(playerid, GREY, "The other person has hungup.");
			}
		}
	}
	else SendClientMessage(playerid, WHITE, "You are not on the phone.");
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case DIALOG_PHONE:
		{
			Array[0] = 0;
			if(!response) 
			{
				format(Array, sizeof(Array), "%s locks their phone.");
				SetPlayerChatBubble(playerid, Array, PURPLE, 15.0, 5000);
				return 1;
			}
			switch(listitem)
			{
				case 0: ShowPlayerDialog(playerid, DIALOG_PHONE_CALL, DIALOG_STYLE_INPUT, "Phone - Call", "Enter the number of the person you wish to call.", "Select", "Home");
				case 1: ShowPlayerDialog(playerid, DIALOG_PHONE_TEXT, DIALOG_STYLE_INPUT, "Phone - Text", "Enter the number of the person you wish to text.", "Select", "Home");
				case 2: ShowPlayerDialog(playerid, DIALOG_PHONE_CONTACTS, DIALOG_STYLE_LIST, "Phone", "Call\nText\nContacts\nMusic\nMaps", "Select", "Lock");
				//case 3: //ShowMusicDialog(playerid, 1);
				//case 4: //ShowMapsDialog(playerid);
			}
		}
		case DIALOG_PHONE_CALL:
		{
			if(!response) return ShowPlayerDialog(playerid, DIALOG_PHONE, DIALOG_STYLE_LIST, "Phone", "Call\nText\nContacts\nMusic\nMaps", "Select", "Lock");

			if(IsNumeric(inputtext))
			{
				foreach(new i: Player)
				{
					if(Player[i][PhoneNumber] == strval(inputtext))
					{
						Array[0] = 0;
						format(Array, sizeof(Array), "%s press a few buttons and presses the phone to their ear.", GetName(playerid));
						SetPlayerChatBubble(playerid, Array, PURPLE, 15.0, 5000);
						format(Array, sizeof(Array), "> %s press a few buttons and presses the phone to their ear.", GetName(playerid));
						SendClientMessage(playerid, PURPLE, Array);
						if(GetPVarInt(i, "Calling") || GetPVarInt(i, "OnPhone")) return SendClientMessage(playerid, GREY, "You just get a busy tone...");
						SetPVarInt(playerid, "Calling", i);

						format(Array, sizeof(Array), "%s phone begins to ring.", GetName(i));
						SendNearbyMessage(i, Array, PURPLE, 30.0);
						format(Array, sizeof(Array), "Your phone is being called. Number: %d", Player[playerid][PhoneNumber]);
						SendClientMessage(i, WHITE, Array);
						SendClientMessage(i, GREY, "Use /p(ickup) to answer it or /h(angup) to send it to voicemail.");
						Player[playerid][PhoneTimer] = SetTimerEx("CallReminder", 4000, TRUE, "i", i);
						break;
					}
				}
			}
			else return ShowPlayerDialog(playerid, DIALOG_PHONE_CALL, DIALOG_STYLE_INPUT, "Phone - Call", "Enter the number of the person you wish to call.", "Select", "Home");
		}
	}
	return 1;
}

forward CallReminder(playerid);
public CallReminder(playerid)
{
	Array[0] = 0;
	format(Array, sizeof(Array), "%s phone begins to ring.", GetName(playerid));
	SendNearbyMessage(playerid, Array, PURPLE, 30.0);
	return 1;
}

/*
GetPhoneContacts(playerid)
{
	mysql_format(SQL, Array, sizeof(Array), "SELECT `Name`, `Number` FROM `contacts` WHERE `Player` = '%d' LIMIT 5", Player[playerid][DatabaseID]);
    mysql_tquery(SQL, Array, "OnGetPhoneContacts", "i", playerid);
}

forward OnGetPhoneContacts(playerid);
public OnGetPhoneContacts(playerid)
{
	if(rows)
	{

	}
	else
	{
		ShowPlayerDialog(playerid, DIALOG_CONTACTS, style, caption[], info[], button1[], button2[]);
	}
	return 1;
}*/