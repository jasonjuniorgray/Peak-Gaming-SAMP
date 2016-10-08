CMD:takepatient(playerid, params[])
{
	if(Player[playerid][PlayerGroup] > -1)
	{
		if(Group[Player[playerid][PlayerGroup]][GroupType] == 3)
		{
			new id;
			if(sscanf(params, "u", id)) 
			{
				return SendClientMessage(playerid, WHITE, "SYNTAX: /takepatient [playerid]");
			}
			else
			{
				if(Player[id][Injured] >= 2)
				{
					if(GetPVarInt(playerid, "Checkpoint") >= 1) return SendClientMessage(playerid, WHITE, "You already have an active checkpoint. Reach it, or type /killcheckpoint to clear it.");
							
					new Float:Pos[3];
					GetPlayerPos(id, Pos[0], Pos[1], Pos[2]);

					SetPlayerCheckpointEx(playerid, Pos[0], Pos[1], Pos[2], 4.0);

					new location[50];
					GetPlayer3DZone(id, location, 50);

					SendClientMessage(playerid, WHITE, "You have accepted the medical call.");
					format(Array, sizeof(Array), "%s has last been seen in: %s.", GetName(id), location);
					SendClientMessage(playerid, GREY, Array);

					SetPVarInt(playerid, "AcceptedPatient", SetTimerEx("FindUpdate", 1000, TRUE, "ii", playerid, id)); 
				}
				else return SendClientMessage(playerid, "This player is not injured!");
			}
		}
		else return SendClientMessage(playerid, WHITE, "You are not in a medical agency.");
	}
	else SendClientMessage(playerid, WHITE, "You are not in a medical agency.");
	return 1;
}