#include <YSI\y_hooks>

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case DIALOG_BUSINESS_STORE:
		{
			if(!response) return 1;
			new id = Player[playerid][InsideBusiness];

			if(Player[playerid][Money] < Business[id][ItemPrice][listitem]) return SendClientMessage(playerid, WHITE, "You do not have enough money for this.");
			
			switch(listitem)
			{
				case 0:
				{
					if(Player[playerid][PhoneNumber] == 0)
					{
						if(Business[id][Stock] < 5) return SendClientMessage(playerid, WHITE, "This business doesn't have enough stock for that item!");

						new number = 1000000 + random(999999); // 7-digit phone number.
						SetPVarInt(playerid, "PhoneNumberCheck", 0);
						PhoneNumberCheck(playerid, number);

						Business[id][Stock] -= 5;
					}
					else return SendClientMessage(playerid, WHITE, "You already have a phone!");
				}
				case 1:
				{
					if(Business[id][Stock] < 4) return SendClientMessage(playerid, WHITE, "This business doesn't have enough stock for that item!");
						
					GivePlayerWeaponEx(playerid, 43);
					SendClientMessage(playerid, WHITE, "You have purchased a camera.");

					Business[id][Stock] -= 4;
				}
				case 2:
				{
					if(Business[id][Stock] < 1) return SendClientMessage(playerid, WHITE, "This business doesn't have enough stock for that item!");
						
					Player[playerid][Rope]++;
					SendClientMessage(playerid, WHITE, "You have purchased a rope.");

					Business[id][Stock] -= 1;
				}
				case 3:
				{
					if(Business[id][Stock] < 1) return SendClientMessage(playerid, WHITE, "This business doesn't have enough stock for that item!");
						
					Player[playerid][Rags]++;
					SendClientMessage(playerid, WHITE, "You have purchased a rag.");

					Business[id][Stock] -= 1;
				}
				case 4:
				{
					if(Business[id][Stock] < 1) return SendClientMessage(playerid, WHITE, "This business doesn't have enough stock for that item!");
						
					Player[playerid][Cigar]++;
					SendClientMessage(playerid, WHITE, "You have purchased a cigar.");

					Business[id][Stock] -= 1;
				}
				case 5:
				{
					if(Business[id][Stock] < 3) return SendClientMessage(playerid, WHITE, "This business doesn't have enough stock for that item!");
						
					GivePlayerWeaponEx(playerid, 41);
					SendClientMessage(playerid, WHITE, "You have purchased a spraycan.");

					Business[id][Stock] -= 3;
				}
				case 6:
				{						
					Player[playerid][Lottery]++;
					SendClientMessage(playerid, WHITE, "You have purchased a lottery ticket. You can now use /enterdrawing to select a number.");
				}
				case 7:
				{
					if(Player[playerid][PortableRadio] == 1)
					{
						if(Business[id][Stock] < 5) return SendClientMessage(playerid, WHITE, "This business doesn't have enough stock for that item!");
						
						Player[playerid][PortableRadio] = 1;
						SendClientMessage(playerid, WHITE, "You have purchased a portable radio.");

						Business[id][Stock] -= 5;
					}
					else return SendClientMessage(playerid, WHITE, "You already have a portable radio.");
				}
			}
			GiveMoneyEx(playerid, -Business[id][ItemPrice][listitem]);
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0); // Just a little 'classic' feel to it.
		}
	}
	return 1;
}

PhoneNumberCheck(playerid, number)
{
	Array[0] = 0;
	format(Array, sizeof(Array), "SELECT * FROM `accounts` WHERE `Phone` = '%d'", number);
	mysql_tquery(SQL, Array, "OnPhoneNumberCheck", "ii", playerid, number);
}

forward OnPhoneNumberCheck(playerid, number);
public OnPhoneNumberCheck(playerid, number)
{
	new rows, fields;
	cache_get_data(rows, fields, SQL);
	if(rows)
	{
		number = 1000000 + random(999999); // 7-digit phone number.
		if(GetPVarInt(playerid, "PhoneNumberCheck") >= 11) number = 10000000 + random(999999); // Just a quick check because I haven't seen any other gamemode that's done this. If the script's tried 11 times to get a phone number chances are you have a very popular server.
		PhoneNumberCheck(playerid, number);

		SetPVarInt(playerid, "PhoneNumberCheck", GetPVarInt(playerid, "PhoneNumberCheck") + 1);
	}
	else
	{
		Array[0] = 0;

		Player[playerid][PhoneNumber] = number;
		format(Array, sizeof(Array), "You have purchased a cell phone! Your number is %d", number);
		SendClientMessage(playerid, GREY, Array);
		DeletePVar(playerid, "PhoneNumberCheck");
	}
	return 1;
}