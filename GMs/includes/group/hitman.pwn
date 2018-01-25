#include <YSI\y_hooks>

CMD:contract(playerid, params[])
{
	ShowContractDialog(playerid);
	return 1;
}

ShowContractDialog(playerid)
{
	new ContractName[MAX_PLAYER_NAME], ContractReason[150];
	if(GetPVarType(playerid, "ContractName")) GetPVarString(playerid, "ContractName", ContractName, sizeof(ContractName));
	else format(ContractName, sizeof(ContractName), "Nobody");

	if(GetPVarType(playerid, "ContractReason")) GetPVarString(playerid, "ContractReason", ContractReason, sizeof(ContractReason));
	else format(ContractReason, sizeof(ContractReason), "Nothing");

	Array[0] = 0;
	format(Array, sizeof(Array), "Name: \t\t\t\t%s\nAmount: \t\t\t$%s\nReason: \t\t\t%s\nReset\nConfirm", ContractName, FormatNumberToString(GetPVarInt(playerid, "ContractAmount")), ContractReason);

	return ShowPlayerDialog(playerid, DIALOG_CONTRACT, DIALOG_STYLE_LIST, "Contract", Array, "Select", "Cancel");
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case DIALOG_CONTRACT:
		{
			if(!response) return 1;
			switch(listitem)
			{
				case 0: ShowPlayerDialog(playerid, DIALOG_CONTRACT_NAME, DIALOG_STYLE_INPUT, "Contract - Name", "Please enter the name of the person you are placing the contract on.\nExactly as it appears: (Firstname_Lastname)", "Select", "Cancel");
				case 1: ShowPlayerDialog(playerid, DIALOG_CONTRACT_AMOUNT, DIALOG_STYLE_INPUT, "Contract - Amount", "Please enter the dollar ammount you'd like to reward for the person you are placing the contract on.", "Select", "Cancel");
				case 2: ShowPlayerDialog(playerid, DIALOG_CONTRACT_REASON, DIALOG_STYLE_INPUT, "Contract - Reason", "Please enter a brief reason for the contract.", "Select", "Cancel");
				case 3:
				{
					DeletePVar(playerid, "ContractName");
					DeletePVar(playerid, "ContractAmount");
					DeletePVar(playerid, "ContractReason");
				}
				case 4:
				{
					if(!GetPVarType(playerid, "ContractName") || !GetPVarType(playerid, "ContractAmount") || !GetPVarType(playerid, "ContractReason")) return ShowContractDialog(playerid);
					else
					{
						Array[0] = 0;
						new ContractName[MAX_PLAYER_NAME], ContractReason[150];
						GetPVarString(playerid, "ContractName", ContractName, sizeof(ContractName));
						GetPVarString(playerid, "ContractReason", ContractReason, sizeof(ContractReason));

						mysql_format(SQL, Array, sizeof(Array), "INSERT INTO `contracts` (`Name`, `Amount`, `Reason`) VALUES ('%e', '%d', '%e')", ContractName, GetPVarInt(playerid, "ContractAmount"), ContractReason);
						mysql_tquery(SQL, Array, "OnPlayerSubmitContract", "i", playerid);
					}
				}
			}
		}
		case DIALOG_CONTRACT_NAME:
		{
			if(!response) return ShowContractDialog(playerid);

			SetPVarString(playerid, "ContractName", inputtext);

			mysql_format(SQL, Array, sizeof(Array), "SELECT * FROM `accounts` WHERE `Username` = '%e'", inputtext);
			mysql_tquery(SQL, Array, "OnPlayerContractExistCheck", "i", playerid);
		}
		case DIALOG_CONTRACT_AMOUNT:
		{
			if(!response) return ShowContractDialog(playerid);
			if(!IsNumeric(inputtext)) return SendClientMessage(playerid, WHITE, "Please enter a numerical value.");
			new amount = strval(inputtext);

			if(amount < 5000 || amount > 500000) return ShowPlayerDialog(playerid, DIALOG_CONTRACT_AMOUNT, DIALOG_STYLE_INPUT, "Contract - Amount", "Please enter the dollar ammount you'd like to reward for the person you are placing the contract on.\n\n(Amounts: $5,000-$500,000)", "Select", "Cancel");
			SetPVarInt(playerid, "ContractAmount", amount);
			return ShowContractDialog(playerid);
		}
		case DIALOG_CONTRACT_REASON:
		{
			if(!response) return ShowContractDialog(playerid);
			if(strlen(inputtext) < 3 || strlen(inputtext) > 126) return ShowPlayerDialog(playerid, DIALOG_CONTRACT_REASON, DIALOG_STYLE_INPUT, "Contract - Reason", "Please enter a brief reason for the contract.", "Select", "Cancel");

			SetPVarString(playerid, "ContractReason", inputtext);
			return ShowContractDialog(playerid);
		}
	}
	return 1;
}

forward OnPlayerContractExistCheck(playerid);
public OnPlayerContractExistCheck(playerid)
{
	new rows, fields;
	Array[0] = 0;
	cache_get_data(rows, fields, SQL);

	if(rows) return ShowContractDialog(playerid);
	else 
	{
		ShowPlayerDialog(playerid, DIALOG_CONTRACT_NAME, DIALOG_STYLE_INPUT, "Contract - Name", "Please enter the name of the person you are placing the contract on.\nExactly as it appears: (Firstname_Lastname)\n\n", "Select", "Cancel");
		DeletePVar(playerid, "ContractName");
		SendClientMessage(playerid, WHITE, "That player does not exist.");
	}
	return 1;
}

forward OnPlayerSubmitContract(playerid);
public OnPlayerSubmitContract(playerid)
{
	SendClientMessage(playerid, WHITE, "You have successfully submitted your contract. An agent will take care of them soon.");

	Array[0] = 0;
	new ContractName[MAX_PLAYER_NAME], ContractReason[150];
	GetPVarString(playerid, "ContractName", ContractName, sizeof(ContractName));
	GetPVarString(playerid, "ContractReason", ContractReason, sizeof(ContractReason));

	format(Array, sizeof(Array), "[/CONTRACT] %s has placed a contract on %s. ($%s) Reason: %s", GetName(playerid), ContractName, FormatNumberToString(GetPVarInt(playerid, "ContractAmount")), ContractReason);
  	Log(17, Array);
   	SendToAdmins(ORANGE, Array, 0, 1);

   	format(Array, sizeof(Array), "%s has placed a contract on %s. ($%s) Reason: %s", GetName(playerid), ContractName, FormatNumberToString(GetPVarInt(playerid, "ContractAmount")), ContractReason);
   	foreach(new i: Player) { if(Group[Player[i][PlayerGroup]][GroupType] == 4) SendClientMessage(i, LIGHTBLUE, Array); }
	return 1;
}