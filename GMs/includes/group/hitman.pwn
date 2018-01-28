#include <YSI\y_hooks>

// Hitman commands should always return 0. NEVER add error messages for civilians.

CMD:contract(playerid, params[])
{
	ShowContractDialog(playerid);
	return 1;
}

CMD:contracts(playerid, params[])
{
	if(Player[playerid][PlayerGroup] > -1 || Player[playerid][AdminLevel] >= 5)
	{
		if(Group[Player[playerid][PlayerGroup]][GroupType] == 4 || Player[playerid][AdminLevel] >= 5)
		{
			new contracts;
			Array[0] = 0;
			SendClientMessage(playerid, WHITE, "--------------------------------------------------------------");

			foreach(new i: Player)
			{
				if(Player[i][Contracted] == 1 && i != playerid)
				{
					format(Array, sizeof(Array), "%s (%d) | Contracted By: %s | Amount: %s | Reason: %s", GetName(i), i, FormatNumberToString(Player[i][ContractAmount]), Player[i][ContractedBy], Player[i][ContractedReason]);
					SendClientMessage(playerid, GREY, Array);

					contracts++;
				}
			}

			if(!contracts) SendClientMessage(playerid, DARKGREY, "There are no contracts online.");

			SendClientMessage(playerid, WHITE, "--------------------------------------------------------------");
			return 1;
		}
	}
	return 0;
}

CMD:takecontract(playerid, params[])
{
	new id;
	if(sscanf(params, "u", id))
	{
	    if(Group[Player[playerid][PlayerGroup]][GroupType] == 4)
	    {
			return SendClientMessage(playerid, WHITE, "SYNTAX: /takecontract [playerid]");
		}
		else return 0;
	}
	else
	{
		if(Group[Player[playerid][PlayerGroup]][GroupType] == 4)
	    {
	    	if(IsPlayerConnectedEx(id))
	    	{
	    		if(playerid == id) return SendClientMessage(playerid, WHITE, "You cannot take your own contract!");

	    		if(Player[playerid][Contracted] >= 1)
	    		{
	    			Array[0] = 0;
	    			SetPVarInt(playerid, "AcceptedContract", 1);
	    			SetPVarInt(playerid, "AcceptedContractID", id);

	    			format(Array, sizeof(Array), "%s has taken the contract on %s.", GetName(playerid), GetName(id));
   					foreach(new i: Player) { if(Group[Player[i][PlayerGroup]][GroupType] == 4) SendClientMessage(i, YELLOWGREEN, Array); }

   					format(Array, sizeof(Array), "You have accepted the contract on %s. Kill them to collect $%s", GetName(id), FormatNumberToString(Player[id][ContractAmount] / 2));
   					SendClientMessage(playerid, LIGHTBLUE, Array);
   				}
   				else SendClientMessage(playerid, WHITE, "This player is not contracted!");
   				return 1;
	    	}
	    }
	}
	return 0;
}

hook OnPlayerDeath(playerid, killerid, reason)
{
	if(Player[playerid][Contracted] == 1)
	{
		if(GetPVarInt(killerid, "AcceptedContract") == 1 && GetPVarInt(killerid, "AcceptedContractID") == playerid && Group[Player[killerid][PlayerGroup]][GroupType] == 4)
		{
			Array[0] = 0;

			format(Array, sizeof(Array), "You have been killed by a hitman and have lost $%s.", FormatNumberToString(Player[playerid][ContractAmount]));
   			SendClientMessage(playerid, YELLOW, Array);
   			GiveMoneyEx(playerid, -Player[playerid][ContractAmount]);

			format(Array, sizeof(Array), "You have completed the contract on %s and collected $%s", GetName(playerid), FormatNumberToString(Player[playerid][ContractAmount] / 2));
   			SendClientMessage(killerid, LIGHTBLUE, Array);
   			GiveMoneyEx(playerid, Player[playerid][ContractAmount] / 2);
   			for(new i = 0; i < MAX_GROUPS; i++) { if(Group[i][GroupType] == 4) Group[i][GroupMoney] += Player[playerid][ContractAmount] / 2; break; }

   			format(Array, sizeof(Array), "[HIT+] %s has completed the contract on %s (%d) for $%s.", GetName(killerid), GetName(playerid), Player[playerid][ContractID], FormatNumberToString(Player[playerid][ContractAmount] / 2));
  			Log(18, Array);

   			DeletePVar(killerid, "AcceptedContract");
   			DeletePVar(killerid, "AcceptedContractID");

   			UpdateContractInformation(playerid);
		}
	}

	if(Player[killerid][Contracted] == 1)
	{
		if(GetPVarInt(playerid, "AcceptedContract") == 1 && GetPVarInt(playerid, "AcceptedContractID") == killerid)
		{
			Array[0] = 0;

			format(Array, sizeof(Array), "You have killed the hitman trying to kill you and earned $%s.", FormatNumberToString(Player[killerid][ContractAmount]));
   			SendClientMessage(killerid, YELLOW, Array);
   			GiveMoneyEx(killerid, Player[killerid][ContractAmount]);

			format(Array, sizeof(Array), "You failed the contract and lost $%s", FormatNumberToString(Player[killerid][ContractAmount]));
   			SendClientMessage(playerid, LIGHTBLUE, Array);
   			GiveMoneyEx(playerid, -Player[playerid][ContractAmount]);

   			format(Array, sizeof(Array), "[HIT-] %s has failed the contract on %s (%d) and lost $%s.", GetName(playerid), GetName(killerid), Player[killerid][ContractID], FormatNumberToString(Player[playerid][ContractAmount]));
  			Log(18, Array);

   			DeletePVar(playerid, "AcceptedContract");
   			DeletePVar(playerid, "AcceptedContractID");

   			UpdateContractInformation(killerid);
		}
	}
	return 1;
}

hook OnPlayerDisconnect(playerid)
{
	if(Player[playerid][Contracted] == 1)
	{
		foreach(new i: Player) 
		{
			if(playerid == GetPVarInt(i, "AcceptedContract")) 
			{
				SendClientMessage(i, WHITE, "Your contract has disconnected.");
				DeletePVar(playerid, "AcceptedContract");
   				DeletePVar(playerid, "AcceptedContractID");
				DisablePlayerCheckpointEx(i);
			}
		}
	}
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
	format(Array, sizeof(Array), "Option\t\t\t\tValue\nName: \t\t\t\t%s\nAmount: \t\t\t$%s\nReason: \t\t\t%s\nReset\nConfirm", ContractName, FormatNumberToString(GetPVarInt(playerid, "ContractAmount")), ContractReason);

	return ShowPlayerDialog(playerid, DIALOG_CONTRACT, DIALOG_STYLE_TABLIST_HEADERS, "Contract", Array, "Select", "Cancel");
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
						new ContractName[MAX_PLAYER_NAME];
						GetPVarString(playerid, "ContractName", ContractName, sizeof(ContractName));
						Array[0] = 0;
						
						mysql_format(SQL, Array, sizeof(Array), "SELECT * FROM `contracts` WHERE `Active` = '1' AND `Name` = '%e'", ContractName);
						mysql_tquery(SQL, Array, "OnContractActiveCheck", "i", playerid);
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

forward OnContractActiveCheck(playerid);
public OnContractActiveCheck(playerid)
{
	new rows, fields, ContractName[MAX_PLAYER_NAME], ContractReason[150], Active = 1;					
	cache_get_data(rows, fields, SQL);
	GetPVarString(playerid, "ContractName", ContractName, sizeof(ContractName));
	GetPVarString(playerid, "ContractReason", ContractReason, sizeof(ContractReason));

	if(rows) Active = 0;

	mysql_format(SQL, Array, sizeof(Array), "INSERT INTO `contracts` (`Name`, `Contracter`, `Amount`, `Reason`, `Active`) VALUES ('%e', '%e', '%d', '%e', '%d')", ContractName, GetNameWithUnderscore(playerid), GetPVarInt(playerid, "ContractAmount"), ContractReason, Active);
	mysql_tquery(SQL, Array, "OnPlayerSubmitContract", "ii", playerid, Active);
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

forward OnPlayerSubmitContract(playerid, active);
public OnPlayerSubmitContract(playerid, active)
{
	SendClientMessage(playerid, WHITE, "You have successfully submitted your contract. An agent will take care of them soon.");

	new ContractName[MAX_PLAYER_NAME], ContractReason[150], id = INVALID_PLAYER_ID;
	GetPVarString(playerid, "ContractName", ContractName, sizeof(ContractName));
	GetPVarString(playerid, "ContractReason", ContractReason, sizeof(ContractReason));

	if(active == 1)
	{
		Array[0] = 0;
		
		foreach(new i: Player)
		{
			if(strcmp(GetNameWithUnderscore(i), ContractName, false) == 0)
			{
				Player[i][ContractID] = cache_insert_id();
				Player[i][Contracted] = 1;
				Player[i][ContractAmount] = GetPVarInt(playerid, "ContractAmount");
				format(Player[i][ContractedBy], MAX_PLAYER_NAME, "%s", GetNameWithUnderscore(playerid));
				format(Player[i][ContractedReason], 150, "%s", ContractReason);
				id = i;
				break;
			}
		}

		if(id == INVALID_PLAYER_ID)
		{
			mysql_format(SQL, Array, sizeof(Array), "UPDATE `accounts` SET `ContractID` = '%d', `Contracted` = '1', `ContractAmount` = '%d', `ContractedBy` = '%e', `ContractedReason` = '%e' WHERE `Username` = '%e'", cache_insert_id(), GetPVarInt(playerid, "ContractAmount"), GetNameWithUnderscore(playerid), ContractReason, ContractName);
			mysql_tquery(SQL, Array, "OnPlayerContractAdd", "i", playerid);
		}
	}

	format(Array, sizeof(Array), "[/CONTRACT] %s has placed a contract on %s. ($%s) Reason: %s", GetName(playerid), ContractName, FormatNumberToString(GetPVarInt(playerid, "ContractAmount")), ContractReason);
  	Log(18, Array);
   	SendToAdmins(ORANGE, Array, 0, 1);

   	format(Array, sizeof(Array), "%s has placed a contract on %s. ($%s) Reason: %s", GetName(playerid), ContractName, FormatNumberToString(GetPVarInt(playerid, "ContractAmount")), ContractReason);
   	foreach(new i: Player) { if(Group[Player[i][PlayerGroup]][GroupType] == 4) SendClientMessage(i, LIGHTBLUE, Array); }

   	DeletePVar(playerid, "ContractName");
	DeletePVar(playerid, "ContractAmount");
	DeletePVar(playerid, "ContractReason");
	return 1;
}

forward OnPlayerContractAdd(playerid);
public OnPlayerContractAdd(playerid)
{
	new rows, fields;
	cache_get_data(rows, fields, SQL);

	if(rows) return 1;
	else printf("Error adding in contract!");
	return 1;
}

UpdateContractInformation(playerid)
{
	// Active -1 = Complete, Active 0 = Standby, Active 1 = Current contract.
	mysql_format(SQL, Array, sizeof(Array), "UPDATE `contracts` SET `Active` = '-1' WHERE `id` = '%d'", Player[playerid][ContractID]);
	mysql_tquery(SQL, Array, "OnPlayerDeleteContract", "i", playerid);
	return 1;
}

forward OnPlayerUpdateContract(playerid);
public OnPlayerUpdateContract(playerid)
{
	new rows, fields;
	cache_get_data(rows, fields, SQL);

	if(rows)
	{
		for(new row;row < rows;row++)
		{
			Player[playerid][ContractID] = cache_get_field_content_int(row, "id");
			Player[playerid][Contracted] = 1;
			Player[playerid][ContractAmount] = cache_get_field_content_int(row, "ContractAmount");
			cache_get_field_content(row, "ContractedBy", Player[playerid][ContractedBy], SQL, MAX_PLAYER_NAME);
			cache_get_field_content(row, "ContractedReason", Player[playerid][ContractedReason], SQL, 150);
			break;
		}
		mysql_format(SQL, Array, sizeof(Array), "UPDATE `contracts` SET `Active` = '1' WHERE `id` = '%d'", Player[playerid][ContractID]);
		mysql_tquery(SQL, Array, "OnPlayerUpdateContract2", "i", playerid);
	}
	else
	{
		Player[playerid][ContractID] = 0;
		Player[playerid][Contracted] = 0;
		Player[playerid][ContractAmount] = 0;
		format(Player[playerid][ContractedBy], MAX_PLAYER_NAME, "Nobody");
		format(Player[playerid][ContractedReason], 150, "Nothing");
	}
	return 1;
}

forward OnPlayerUpdateContract2(playerid);
public OnPlayerUpdateContract2(playerid)
{
	new rows, fields;
	cache_get_data(rows, fields, SQL);

	if(rows) return 1;
	else printf("Error adding in contract 2!");
	return 1;
}

forward OnPlayerDeleteContract(playerid);
public OnPlayerDeleteContract(playerid)
{
	mysql_format(SQL, Array, sizeof(Array), "SELECT * FROM `contracts` WHERE `Name` = '%e' AND `Active` = '0'", GetNameWithUnderscore(playerid));
	mysql_tquery(SQL, Array, "OnPlayerUpdateContract", "i", playerid);
	return 1;
}