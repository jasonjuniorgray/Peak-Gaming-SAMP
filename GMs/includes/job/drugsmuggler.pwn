#include <YSI\y_hooks>

CMD:getcrate(playerid, params[])
{
	if(Job[Player[playerid][PlayerJob]][JobType] == 6)
	{
		for(new i; i < MAX_POINTS; i++)
		{
			if(IsPlayerInRangeOfPoint(playerid, 3.0, Point[i][poPos][0], Point[i][poPos][1], Point[i][poPos][2]) && Point[i][poType] == 1)
			{
				if(GetPlayerVirtualWorld(playerid) == Point[i][pointVW])
				{
					if(GetPVarInt(playerid, "Checkpoint") >= 1) return SendClientMessage(playerid, WHITE, "You already have an active checkpoint. Reach it, or type /killcheckpoint to clear it.");

					if(Player[playerid][Money] >= 300)
					{
						SetPVarInt(playerid, "DrugRun", 1);
						SetPVarInt(playerid, "PotPackages", 10);
						SetPlayerCheckpointEx(playerid, Point[i][poPos2][0], Point[i][poPos2][1], Point[i][poPos2][2], 5.0);

						format(Array, sizeof(Array), "You have purchased %d pot packages for $%s. Deliver them to the checkpoint to collect your reward.", 10);
						SendClientMessage(playerid, WHITE, Array);
					}
					else return SendClientMessage(playerid, WHITE, "You need $450 to purchase pot packages.");				
				}
			}
			if(IsPlayerInRangeOfPoint(playerid, 3.0, Point[i][poPos][0], Point[i][poPos][1], Point[i][poPos][2]) && Point[i][poType] == 2)
			{
				if(GetPlayerVirtualWorld(playerid) == Point[i][pointVW])
				{
					if(GetPVarInt(playerid, "Checkpoint") >= 1) return SendClientMessage(playerid, WHITE, "You already have an active checkpoint. Reach it, or type /killcheckpoint to clear it.");

					if(Player[playerid][Money] >= 300)
					{
						SetPVarInt(playerid, "DrugRun", 2);
						SetPVarInt(playerid, "CrackPackages", 10);
						SetPlayerCheckpointEx(playerid, Point[i][poPos2][0], Point[i][poPos2][1], Point[i][poPos2][2], 5.0);

						format(Array, sizeof(Array), "You have purchased %d pot packages for $%s. Deliver them to the checkpoint to collect your reward.", 10);
						SendClientMessage(playerid, WHITE, Array);
					}
					else return SendClientMessage(playerid, WHITE, "You need $450 to purchase pot packages.");				
				}
			}
		}
	}
	else SendClientMessage(playerid, WHITE, "You are not a drug smuggler.");
	return 1;
}

hook OnPlayerEnterCheckpoint(playerid)
{
	if(GetPVarInt(playerid, "DrugRun") == 1)
	{
		DisablePlayerCheckpointEx(playerid);
		Player[playerid][Drugs][0] += GetPVarInt(playerid, "PotPackages");

		SendClientMessage(playerid, WHITE, "You have delivered the materials to the factory and collected 10 pot.");

		DeletePVar(playerid, "DrugRun");
		DeletePVar(playerid, "PotPackages");
	}
	if(GetPVarInt(playerid, "DrugRun") == 2)
	{
		DisablePlayerCheckpointEx(playerid);
		Player[playerid][Drugs][1] += GetPVarInt(playerid, "CrackPackages");

		SendClientMessage(playerid, WHITE, "You have delivered the materials to the factory and collected 10 crack.");

		DeletePVar(playerid, "DrugRun");
		DeletePVar(playerid, "CrackPackages");
	}
	return 1;
}