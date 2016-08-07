CMD:clear(playerid, params[])
{
	if(Job[Player[playerid][PlayerJob]][JobType] == 7)
	{
		new id, price;
		if(sscanf(params, "ud", id, price)) 
		{
			return SendClientMessage(playerid, WHITE, "SYNTAX: /clear [playerid] [price]");
		}
		else 
		{
			if(!IsPlayerNearPlayer(playerid, id, 8.0)) return SendClientMessage(playerid, GREY, "You are not near that player.");
			if(GetPVarInt(playerid, "Cuffed") >= 1 || GetPVarType(playerid, "Tasered")) return SendClientMessage(playerid, GREY, "You cannot do this right now!");
			if(price < 0) return SendClientMessage(playerid, GREY, "The price must be a positive integer!");
			if(GetPVarType(playerid, "Offering")) return SendClientMessage(playerid, GREY, "You already have a pending offer. Type /cancel offer to reset it.");

			if(GetPVarInt(playerid, "LawyerTime") > gettime()) 
			{
				format(Array, sizeof(Array), "You must wait %d seconds before you can clear again.", GetPVarInt(playerid, "LawyerTime") - gettime()); 
				return SendClientMessage(playerid, GREY, Array);
			}

			new waittime;
			switch(Player[playerid][JobSkill][6])
			{
				case 0 .. 49: waittime = 300; 
				case 50 .. 99: waittime = 250; 
				case 100 .. 199: waittime = 180;
				case 200 .. 399: waittime = 120;
				default: waittime = 60;
			}

			if(id == playerid && Player[playerid][JobSkill][6] < 400) return SendClientMessage(playerid, WHITE, "You cannot clear yourself!");
			else if(id == playerid && Player[playerid][JobSkill][6] > 400)
			{
				return 1;
			}
			else
			{
				SetPVarInt(playerid, "Offering", 1);
				SetPVarInt(id, "ClearingID", playerid);
				SetPVarInt(id, "ClearingWait", waittime);
				SetPVarInt(id, "ClearingPrice", price);

				format(Array, sizeof(Array), "You have offered %s a clear for $%s.", GetName(id), FormatNumberToString(price));
	  			SendClientMessage(playerid, LIGHTBLUE, Array);
				format(Array, sizeof(Array), "%s has offered to clear a charge you have for $%s, type /accept clear to accept it.", GetName(playerid), FormatNumberToString(price));
	  			SendClientMessage(id, LIGHTBLUE, Array);
	  		}

			return SendClientMessage(playerid, WHITE, "This player doesn't have any more cimes to clear.");
		}
	}
	else SendClientMessage(playerid, WHITE, "You are not a lawyer!");
	return 1;
}