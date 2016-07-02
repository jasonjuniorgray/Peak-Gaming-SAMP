#include <YSI\y_hooks>

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case DIALOG_BUSINESS_GYM:
		{
			if(!response) return 1;
			new id = Player[playerid][InsideBusiness];

			if(Player[playerid][Money] < Business[id][GymItemPrice][listitem]) return SendClientMessage(playerid, WHITE, "You do not have enough money for this.");
			
			switch(listitem)
			{
				case 0: Player[playerid][Fightstyle] = 4;
				case 1: Player[playerid][Fightstyle] = 5;
				case 2: Player[playerid][Fightstyle] = 6;
				case 3: Player[playerid][Fightstyle] = 7;
				case 4: Player[playerid][Fightstyle] = 15;
				case 5: Player[playerid][Fightstyle] = 16;
				default: return 1;
			}
			SetPlayerFightingStyle(playerid, Player[playerid][Fightstyle]);
			SendClientMessage(playerid, WHITE, "You have successfully bought a fighting style.");

			GiveMoneyEx(playerid, -Business[id][GymItemPrice][listitem]);
		}
	}
	return 1;
}