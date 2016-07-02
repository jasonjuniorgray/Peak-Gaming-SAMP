CMD:track(playerid, params[])
{
	if(Job[Player[playerid][PlayerJob]][JobType] == 4)
	{
		new id;
		if(sscanf(params, "u", id)) 
		{
			return SendClientMessage(playerid, WHITE, "SYNTAX: /track [playerid]");
		}
		else 
		{
			if(!IsPlayerConnectedEx(id)) return SendClientMessage(playerid, WHITE, "That player is not connected!");
			//if(Player[playerid][PhoneToggled] == 1) return SendClientMessage(playerid, WHITE, "That player's phone is off!");
			if(IsPlayerInAnyVehicle(playerid) || GetPVarInt(playerid, "Cuffed") >= 1) return SendClientMessage(playerid, GREY, "You cannot do this right now!");

			if(GetPVarInt(playerid, "FindTime") > gettime()) 
			{
				format(Array, sizeof(Array), "You must wait %d seconds before you can track again.", GetPVarInt(playerid, "FindTime") - gettime()); 
				return SendClientMessage(playerid, GREY, Array);
			}

			new waittime, trackertime;
			switch(Player[playerid][JobSkill][3])
			{
				case 0 .. 49: { waittime = 120; trackertime = 5000; }
				case 50 .. 99: { waittime = 100; trackertime = 10000; }
				case 100 .. 199: { waittime = 60; trackertime = 15000; }
				case 200 .. 399: { waittime = 30; trackertime = 20000; }
				default: { waittime = 25; trackertime = 20000; }
			}

			if(id == playerid) return SendClientMessage(playerid, WHITE, "You cannot track yourself!");

			if(GetPlayerInterior(playerid) == 0 && GetPlayerVirtualWorld(playerid) == 0)
			{
				if(GetPVarInt(playerid, "Checkpoint") >= 1) return SendClientMessage(playerid, WHITE, "You already have an active checkpoint. Reach it, or type /killcheckpoint to clear it.");
				
				new Float:Pos[3];
				GetPlayerPos(id, Pos[0], Pos[1], Pos[2]);

				SetPlayerCheckpointEx(playerid, Pos[0], Pos[1], Pos[2], 3.0);

				format(Array, sizeof(Array), "You have a trace! It will last for %d seconds.", trackertime / 1000);
				SendClientMessage(playerid, WHITE, Array);

				SetTimerEx("DetectiveFind", trackertime, FALSE, "ii", playerid, id);

				SetPVarInt(playerid, "FindTime", gettime() + waittime);
				IncreaseJobSkill(playerid, 3, 1);
			}
			else return SendClientMessage(playerid, WHITE, "The signal is to weak to track.");
		}
	}
	else SendClientMessage(playerid, WHITE, "You are not a detective!");
	return 1;
}

forward DetectiveFind(playerid, id);
public DetectiveFind(playerid, id) return DisablePlayerCheckpointEx(playerid);