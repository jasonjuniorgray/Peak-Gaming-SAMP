#include <YSI\y_hooks>

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case DIALOG_BUSINESS_SKIN:
		{
			if(!response) return 1;
			new id = Player[playerid][InsideBusiness];
			if(!IsNumeric(inputtext)) 
			{
				SendClientMessage(playerid, WHITE, "Please enter a numerical value.");
				format(Array, sizeof(Array), "Enter a skin number to purchase a skin. It will cost you $%d", Business[id][SkinPrice]);
				return ShowPlayerDialog(playerid, DIALOG_BUSINESS_SKIN, DIALOG_STYLE_INPUT, "Clothing Store - Purchase", Array, "Purchase", "Cancel");
			}	

			if(Player[playerid][Money] < Business[id][SkinPrice]) return SendClientMessage(playerid, WHITE, "You do not have enough money for this.");

			if(!SkinNumberInvalid(strval(inputtext)))
			{
				if(!SkinRestricted(strval(inputtext)))
				{
					Player[playerid][Skin] = strval(inputtext);
					SetPlayerSkin(playerid, strval(inputtext));

					GiveMoneyEx(playerid, -Business[id][SkinPrice]);
					SendClientMessage(playerid, WHITE, "You have purchased a new outfit.");
				}
				else
				{
					SendClientMessage(playerid, WHITE, "That skin is restricted to factions only.");
					format(Array, sizeof(Array), "Enter a skin number to purchase a skin. It will cost you $%d", Business[id][SkinPrice]);
					return ShowPlayerDialog(playerid, DIALOG_BUSINESS_SKIN, DIALOG_STYLE_INPUT, "Clothing Store - Purchase", Array, "Purchase", "Cancel");
				}
			}
			else
			{
				SendClientMessage(playerid, WHITE, "That is not a skin number.");
				format(Array, sizeof(Array), "Enter a skin number to purchase a skin. It will cost you $%d", Business[id][SkinPrice]);
				return ShowPlayerDialog(playerid, DIALOG_BUSINESS_SKIN, DIALOG_STYLE_INPUT, "Clothing Store - Purchase", Array, "Purchase", "Cancel");
			}
		}
	}
	return 1;
}