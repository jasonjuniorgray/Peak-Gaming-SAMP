#include <YSI\y_hooks>

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case DIALOG_BUSINESS_FOOD:
		{
			if(!response) return 1;
			Array[0] = 0;

			new id = Player[playerid][InsideBusiness];
			if(Player[playerid][Money] < Business[id][FoodItemPrice][listitem]) return SendClientMessage(playerid, WHITE, "You do not have enough money for this.");
			switch(listitem)
			{
				case 0 .. sizeof(FoodItems):
				{
					Business[id][Stock] -= 1;
					SetPlayerHealth(playerid, 100);

					format(Array, sizeof(Array), "You have purchsed a %s from %s.", FoodItems[listitem], Business[id][BizName]);
					SendClientMessage(playerid, WHITE, Array);

					GiveMoneyEx(playerid, -Business[id][FoodItemPrice][listitem]);
				}
			}
		}
	}
	return 1;
}