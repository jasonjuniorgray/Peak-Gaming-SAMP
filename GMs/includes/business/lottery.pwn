#include <YSI\y_hooks>

CMD:enterdrawing(playerid, params[])
{
	if(LotteryInfo[0] < 1) return SendClientMessage(playerid, WHITE, "The lottery has been disabled.");
	if(Player[playerid][Lottery] >= 1)
	{
		new number;
		Array[0] = 0;
		if(sscanf(params, "d", number)) 
		{
			SendClientMessage(playerid, WHITE, "SYNTAX: /enterdrawing [number]");
			format(Array, 128, "The current lottery drawing is between 1 and %d. The jackpot is $%s", LotteryInfo[0], FormatNumberToString(LotteryInfo[1]));
			return SendClientMessage(playerid, GREY, Array);
		}
		else
		{
			if(Player[playerid][LotteryNumber] < 1)
			{
				if(number < 1 || number > LotteryInfo[0]) 
				{
					SendClientMessage(playerid, WHITE, "SYNTAX: /enterdrawing [number]");
					format(Array, 128, "The current lottery drawing is between 1 and %d. The jackpot is $%s", LotteryInfo[0], FormatNumberToString(LotteryInfo[1]));
					return SendClientMessage(playerid, GREY, Array);
				}
				else
				{
					Player[playerid][Lottery]--;
					Player[playerid][LotteryNumber] = number;

					format(Array, 128, "You have selected lottery number %d. The lottery ends tonight at midnight.", LotteryInfo[0], FormatNumberToString(LotteryInfo[1]));
					SendClientMessage(playerid, WHITE, Array);
					return SendClientMessage(playerid, GREY, "You have entered the lottery. Your entry will save even upon logout.");
				}
			}
			else return SendClientMessage(playerid, WHITE, "You've already participated in this drawing. Please wait until the next one.");
		}
	}
	return 1;
}

CMD:lottery(playerid, params[])
{
	if(Player[playerid][AdminLevel] >= 5)
	{
	    Array[0] = 0;
	    format(Array, sizeof(Array), "Numbers (1-%d)\nWinnings ($%s)", LotteryInfo[0], FormatNumberToString(LotteryInfo[1]));
	    ShowPlayerDialog(playerid, DIALOG_BUSINESS_LOTTERY, DIALOG_STYLE_LIST, "Edit Lottery", Array, "Select", "Cancel");
	}
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case DIALOG_BUSINESS_LOTTERY:
		{
			if(!response) return 1;
			switch(listitem)
			{
				case 0: ShowPlayerDialog(playerid, DIALOG_BUSINESS_LOTTERY2, DIALOG_STYLE_INPUT, "Edit Lottery - Numbers", "Please enter the numbers for the lottery drawing. It will be 1 out of the number you chose.", "Select", "Cancel");
				case 1: ShowPlayerDialog(playerid, DIALOG_BUSINESS_LOTTERY3, DIALOG_STYLE_INPUT, "Edit Lottery - Winnings", "Please enter the money the player gets when they win the lottery. This resets to this number every drawing.", "Select", "Cancel");
			}
		}
		case DIALOG_BUSINESS_LOTTERY2:
		{
			if(!response) return 1;
			LotteryInfo[0] = strval(inputtext);

			format(Array, 128, "You have changed the lottery numbers to 1-%d.", LotteryInfo[0]);
			SendClientMessage(playerid, WHITE, Array);

			format(Array, 128, "[/LOTTERY] %s has changed the lottery numbers to 1-%d.", GetName(playerid), LotteryInfo[0]);
			Log(2, Array);
		}
		case DIALOG_BUSINESS_LOTTERY3:
		{
			if(!response) return 1;
			LotteryInfo[1] = strval(inputtext);

			format(Array, 128, "You have changed the lottery winnings to $%s.", FormatNumberToString(LotteryInfo[1]));
			SendClientMessage(playerid, WHITE, Array);

			format(Array, 128, "[/LOTTERY] %s has changed the lottery winnings to $%s.", FormatNumberToString(LotteryInfo[1]));
			Log(2, Array);
		}
	}
	return 1;
}

GetLotteryWinners(number)
{
	new winners;
	for(new i; i < MAX_PLAYERS; i++)
	{
		if(Player[i][LotteryNumber] == number)
		{
			SetPVarInt(i, "WonLottery", 1);
			winners++;
		}
	}

	LotteryCheck(number, winners);
}

LotteryCheck(number, winners)
{
	Array[0] = 0;
	format(Array, sizeof(Array), "SELECT * FROM `accounts` WHERE `LotteryNumber` = '%d'", number);
	mysql_tquery(SQL, Array, "OnLotteryCheck", "ii", number, winners);
}

forward OnLotteryCheck(number, winners);
public OnLotteryCheck(number, winners)
{
	new rows, fields, realwin;
	Array[0] = 0;
	cache_get_data(rows, fields, SQL);

	realwin = LotteryInfo[1] / winners;

	if(rows)
	{
		format(Array, sizeof(Array), "UPDATE `accounts` SET `Money` = `Money` + %d, `LotteryNumber` = -1 WHERE `LotteryNumber` = %d", realwin, number); // Set to -1 so the player can be congratulated upon their next login.
		mysql_tquery(SQL, Array, "", "");
	}
	for(new i; i < MAX_PLAYERS; i++)
	{
		if(GetPVarInt(i, "WonLottery"))
		{
			GiveMoneyEx(i, realwin);
			format(Array, 128, "You have won the lottery and recieved $%s.", FormatNumberToString(realwin));
			SendClientMessage(i, WHITE, Array);
			Player[i][LotteryNumber] = 0;

			DeletePVar(i, "WonLottery");
		}
	}
	return 1;
}