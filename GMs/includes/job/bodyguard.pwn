CMD:guard(playerid, params[])
{
	if(Job[Player[playerid][PlayerJob]][JobType] == 3)
	{
		new id, price;
		if(sscanf(params, "ud", id, price)) 
		{
			return SendClientMessage(playerid, WHITE, "SYNTAX: /guard [playerid] [price]");
		}
		else 
		{
			if(!IsPlayerNearPlayer(playerid, id, 8.0)) return SendClientMessage(playerid, GREY, "You are not near that player.");
			if(GetPVarInt(playerid, "GuardTime") > gettime()) return SendClientMessage(playerid, GREY, "You must wait 30 seconds before using your job commands again.");
			if(IsPlayerInAnyVehicle(playerid) || GetPVarInt(playerid, "Cuffed") >= 1 || GetPVarType(playerid, "Tasered")) return SendClientMessage(playerid, GREY, "You cannot do this right now!");
			if(price < 0) return SendClientMessage(playerid, GREY, "The price must be a positive integer!");
			if(GetPVarType(playerid, "Offering")) return SendClientMessage(playerid, GREY, "You already have a pending offer. Type /cancel offer to reset it.");

			new Float:amount;
			switch(Player[playerid][JobSkill][2])
			{
				case 0 .. 49: amount = 10;
				case 50 .. 99: amount = 15;
				case 100 .. 199: amount = 25;
				case 200 .. 399: amount = 35;
				default: amount = 50;
			}

			if(id == playerid && Player[playerid][JobSkill][2] >= 400)
            {
            	SetPlayerArmourEx(playerid, amount);

            	format(Array, sizeof(Array), "{FF8000}** {C2A2DA}%s has strapped on a kevlar vest.", GetName(playerid));
                SendNearbyMessage(playerid, Array, PURPLE, 30.0);

                IncreaseJobSkill(playerid, 2, 1);
            	return 1;
            }
            else if(id == playerid && Player[playerid][JobSkill][2] <= 399) return SendClientMessage(playerid, WHITE, "You must be a level 5 bodyguard to guard yourself.");

            SetPVarInt(playerid, "Offering", 1);
            SetPVarInt(id, "GuardID", playerid);
            SetPVarFloat(id, "GuardAmount", amount);
            SetPVarInt(id, "RefillPrice", price);

            format(Array, sizeof(Array), "You have offered %s a vest for $%s.", GetName(id), FormatNumberToString(price));
  			SendClientMessage(playerid, LIGHTBLUE, Array);
			format(Array, sizeof(Array), "%s has offered to vest you for $%s, type /accept guard to accept it.", GetName(playerid), FormatNumberToString(price));
  			SendClientMessage(id, LIGHTBLUE, Array);
		}
	}
	else SendClientMessage(playerid, WHITE, "You are not a bodyguard!");
	return 1;
}