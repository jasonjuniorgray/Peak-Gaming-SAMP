#include <YSI\y_hooks>

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
				if(Player[id][Injured] == 2)
				{
					if(GetPVarInt(playerid, "Checkpoint") >= 1) return SendClientMessage(playerid, WHITE, "You already have an active checkpoint. Reach it, or type /killcheckpoint to clear it.");
					if(GetPVarInt(playerid, "AcceptedPatient")) return SendClientMessage(playerid, WHITE, "You already have a patient. Reach them first or /killcheckpoint.");
							
					new Float:Pos[3];
					GetPlayerPos(id, Pos[0], Pos[1], Pos[2]);

					SetPlayerCheckpointEx(playerid, Pos[0], Pos[1], Pos[2], 4.0);

					new location[50];
					GetPlayer3DZone(id, location, 50);

					SendClientMessage(playerid, WHITE, "You have accepted the medical call.");
					SendClientMessage(playerid, WHITE, "An EMS driver has accepted your call and is enroute.");
					
					format(Array, sizeof(Array), "%s has last been seen in: %s.", GetName(id), location);
					SendClientMessage(playerid, GREY, Array);

					SetPVarInt(playerid, "AcceptedPatient", SetTimerEx("FindUpdate", 1000, TRUE, "ii", playerid, id)); 
					SetPVarInt(playerid, "AcceptedPatientID", id);
				}
				else return SendClientMessage(playerid, WHITE, "This player is not injured!");
			}
		}
		else return SendClientMessage(playerid, WHITE, "You are not in a medical agency.");
	}
	else SendClientMessage(playerid, WHITE, "You are not in a medical agency.");
	return 1;
}

CMD:deliverpatient(playerid, params[])
{
	if(Player[playerid][PlayerGroup] > -1)
	{
		if(Group[Player[playerid][PlayerGroup]][GroupType] == 3)
		{
			new id;
			if(sscanf(params, "u", id)) 
			{
				return SendClientMessage(playerid, WHITE, "SYNTAX: /deliverpatient [playerid]");
			}
			else
			{
				if(Player[id][Injured] == 3)
				{
					if(GetPlayerVehicleID(playerid) != GetPlayerVehicleID(id)) return SendClientMessage(playerid, WHITE, "You are not in the same vehicle as that player.");
					if(Player[playerid][PlayerGroup] != Vehicle[GetRealVehicleID(GetPlayerVehicleID(playerid))][VehicleGroup]) return SendClientMessage(playerid, WHITE, "You need to be in one of your group's vehicles to do this.");

					new hospital = -1;

					if(IsPlayerInRangeOfPoint(playerid, 5, Hospitals[0][0], Hospitals[0][1], Hospitals[0][2])) hospital = 0;
					else if(IsPlayerInRangeOfPoint(playerid, 5, Hospitals[1][0], Hospitals[1][1], Hospitals[1][2])) hospital = 1;
					else return SendClientMessage(playerid, WHITE, "You are not near a delivery point.");

					SetPlayerPosEx(id, 1201.12, -1324, -80.0, 0.0, 0, 0);
        			TogglePlayerControllableEx(id, FALSE);
        			Player[id][Injured] = 4;
        			
        			SetPlayerCameraPos(id, Hospitals[hospital][3], Hospitals[hospital][4], Hospitals[hospital][5]);
        			SetPlayerCameraLookAt(id, Hospitals[hospital][6], Hospitals[hospital][7], Hospitals[hospital][8]);

        			SetTimerEx("LimboTimer", 15000, FALSE, "i", id);
        			SetPlayerHealthEx(id, 50.0);

					SendClientMessage(id, WHITE, "You have delivered the patient and collected $500.");
					GiveMoneyEx(playerid, 500);
					format(Array, sizeof(Array), "%s has last been seen in: %s.", GetName(id));
					SendClientMessage(playerid, GREY, Array);
				}
				else return SendClientMessage(playerid, WHITE, "This player is not injured!");
			}
		}
		else return SendClientMessage(playerid, WHITE, "You are not in a medical agency.");
	}
	else SendClientMessage(playerid, WHITE, "You are not in a medical agency.");
	return 1;
}

hook OnPlayerEnterCheckpoint(playerid)
{
	if(GetPVarType(playerid, "AcceptedPatient") > 0 && Player[GetPVarType(playerid, "AcceptedPatientID")][Injured] == 2)
	{
		new id = GetPVarInt(playerid, "AcceptedPatientID");
		if(IsPlayerNearPlayer(playerid, id, 5.0))
		{
			if(IsPlayerConnectedEx(id))
			{
				DisablePlayerCheckpointEx(playerid);

				Player[id][Injured] = 3;
				SetPVarInt(playerid, "SavingPatient", id);

				ApplyAnimation(id, "SWAT", "gnstwall_injurd", 4.1, 0, 1, 1, 1, 1, 1);
				SendClientMessage(id, WHITE, "A medic has arrived, please wait for treatment.");
				TextDrawHideForPlayer(id, LimboTextDraw);

				KillTimer(GetPVarInt(playerid, "AcceptedPatient"));
				DeletePVar(playerid, "AcceptedPatient");
				DeletePVar(playerid, "AcceptedPatientID");
			}
			else 
			{
				KillTimer(GetPVarInt(playerid, "AcceptedPatient"));
				DeletePVar(playerid, "AcceptedPatient");
				DeletePVar(playerid, "AcceptedPatientID");
				DisablePlayerCheckpointEx(playerid);
				return SendClientMessage(playerid, WHITE, "The player was sent to the hospital.");
			}
		}
		else return 1;
	}
	return 1;
}