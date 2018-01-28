CMD:withdraw(playerid, params[])
{
	if(IsPlayerConnectedEx(playerid))
	{
		new amount;
		if(sscanf(params, "d", amount)) return SendClientMessage(playerid, WHITE, "SYNTAX: /withdraw [amount]");
		else
		{
			if(IsPlayerInRangeOfPoint(playerid, 10.0, 478.8556, 159.4606, 1023.4783))
			{
				if(amount < 1) return SendClientMessage(playerid, WHITE, "The amount to withdraw must be greater than 0.");

				if(Player[playerid][BankMoney] >= amount)
				{
					Array[0] = 0;

					Player[playerid][BankMoney] -= amount;
					GiveMoneyEx(playerid, amount);

					format(Array, sizeof(Array), "You have withdrew $%s from your bank account.", FormatNumberToString(amount));
					SendClientMessage(playerid, YELLOW, Array);

					format(Array, sizeof(Array), "[/WITHDRAW] %s has withdrew $%s from thier bank account.", GetName(playerid), FormatNumberToString(amount));
					Log(19, Array);
				}
				else return SendClientMessage(playerid, WHITE, "You don't have that much money in your bank.");
			}
			else return SendClientMessage(playerid, WHITE, "You are not at the bank.");
		}
	}
	return 1;
}

CMD:deposit(playerid, params[])
{
	if(IsPlayerConnectedEx(playerid))
	{
		new amount;
		if(sscanf(params, "d", amount)) return SendClientMessage(playerid, WHITE, "SYNTAX: /deposit [amount]");
		else
		{
			if(IsPlayerInRangeOfPoint(playerid, 10.0, 478.8556, 159.4606, 1023.4783))
			{
				if(amount < 1) return SendClientMessage(playerid, WHITE, "The amount to deposit must be greater than 0.");

				if(Player[playerid][Money] >= amount)
				{
					Array[0] = 0;

					Player[playerid][BankMoney] += amount;
					GiveMoneyEx(playerid, -amount);

					format(Array, sizeof(Array), "You have deposited $%s into your bank account.", FormatNumberToString(amount));
					SendClientMessage(playerid, YELLOW, Array);

					format(Array, sizeof(Array), "[/DEPOSIT] %s has deposited $%s into thier bank account.", GetName(playerid), FormatNumberToString(amount));
					Log(19, Array);
				}
				else return SendClientMessage(playerid, WHITE, "You don't have that much money.");
			}
			else return SendClientMessage(playerid, WHITE, "You are not at the bank.");
		}
	}
	return 1;
}

CMD:wiretransfer(playerid, params[])
{
	if(IsPlayerConnectedEx(playerid))
	{
		new id, amount;
		if(sscanf(params, "ud", amount)) return SendClientMessage(playerid, WHITE, "SYNTAX: /wiretransfer [id] [amount]");
		else
		{
			if(IsPlayerInRangeOfPoint(playerid, 10.0, 478.8556, 159.4606, 1023.4783))
			{
				if(amount < 1) return SendClientMessage(playerid, WHITE, "The amount to transfer must be greater than 0.");
				if(id == playerid) return SendClientMessage(playerid, WHITE, "You cannot transfer money to yourself.");

				if(IsPlayerConnectedEx(id))
				{
					if(Player[playerid][BankMoney] >= amount)
					{
						Array[0] = 0;

						Player[playerid][BankMoney] -= amount;
						Player[id][BankMoney] += amount;

						format(Array, sizeof(Array), "You have transfered $%s to %s.", FormatNumberToString(amount), GetName(id));
						SendClientMessage(playerid, YELLOW, Array);

						format(Array, sizeof(Array), "%s have transfered $%s to your bank acount.", GetName(playerid), FormatNumberToString(amount));
						SendClientMessage(playerid, YELLOW, Array);

						format(Array, sizeof(Array), "[/WIRETRANSFER] %s has transfered $%s to %s.", GetName(playerid), FormatNumberToString(amount), GetName(id));
						Log(19, Array);
					}
					else return SendClientMessage(playerid, WHITE, "You don't have that much money in your bank.");
				}
				else return SendClientMessage(playerid, WHITE, "That player is not connected.");
			}
			else return SendClientMessage(playerid, WHITE, "You are not at the bank.");
		}
	}
	return 1;
}