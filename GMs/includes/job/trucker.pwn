#include <YSI\y_hooks>

CMD:truckrun(playerid, params[])
{
	if(Job[Player[playerid][PlayerJob]][JobType] == 5)
	{
		if(Vehicle[GetRealVehicleID(GetPlayerVehicleID(playerid))][Model] != 0 && Vehicle[GetRealVehicleID(GetPlayerVehicleID(playerid))][VehicleJob] == Player[playerid][PlayerJob])
		{
			if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)) && Vehicle[GetRealVehicleID(GetVehicleTrailer(GetPlayerVehicleID(playerid)))][Model])
			{
				if(GetPVarInt(playerid, "Checkpoint") >= 1) return SendClientMessage(playerid, WHITE, "You already have an active checkpoint. Reach it, or type /killcheckpoint to clear it.");

				SetPlayerCheckpointEx(playerid, -66.7639, -1120.5050, 1.0781, 5.0);
				SendClientMessage(playerid, WHITE, "You have started a trucker run started. Head to the supplies depot to collect the cargo.");

				SetPVarInt(playerid, "TruckRun", 1);
				SetPVarInt(playerid, "TruckVeh", GetPlayerVehicleID(playerid));
				SetPVarInt(playerid, "TruckTrailer", GetVehicleTrailer(GetPlayerVehicleID(playerid)));
			}
			else return SendClientMessage(playerid, WHITE, "You need to attach a trailer from the docks first!");
		}
		else return SendClientMessage(playerid, WHITE, "This is not a truck at the trucker depot!");
	}
	else SendClientMessage(playerid, WHITE, "You are not a trucker!");
	return 1;
}

hook OnPlayerEnterCheckpoint(playerid)
{
	if(GetPVarInt(playerid, "TruckRun") == 1)
	{
		if(GetPlayerVehicleID(playerid) == GetPVarInt(playerid, "TruckVeh"))
		{
			if(GetVehicleTrailer(GetPlayerVehicleID(playerid)) == GetPVarInt(playerid, "TruckTrailer"))
			{
				if(Job[Player[playerid][PlayerJob]][JobType] == 5)
				{
					DisablePlayerCheckpointEx(playerid);
					SetTimerEx("CargoTimer", 5000, 0, "i", playerid);
					TogglePlayerControllableEx(playerid, FALSE);
					GameTextForPlayer(playerid, "~w~Loading...", 4500, 4);
				}
				else
				{
					SendClientMessage(playerid, WHITE, "You are no longer a trucker. Your run has been canceled.");
					SetVehicleToRespawn(GetPVarInt(playerid, "TruckTrailer"));
					SetVehicleToRespawn(GetPVarInt(playerid, "TruckVeh"));

					DeletePVar(playerid, "TruckRun");
					DeletePVar(playerid, "TruckVeh");
					DeletePVar(playerid, "TruckTrailer");
					return 1;
				}
			}
			else return SendClientMessage(playerid, WHITE, "This is not the trailer you started with!");
		}
		else return SendClientMessage(playerid, WHITE, "This is not the truck you started with!");
	}
	if(GetPVarInt(playerid, "TruckRun") == 2)
	{
		if(GetPlayerVehicleID(playerid) == GetPVarInt(playerid, "TruckVeh"))
		{
			if(GetVehicleTrailer(GetPlayerVehicleID(playerid)) == GetPVarInt(playerid, "TruckTrailer"))
			{
				if(Job[Player[playerid][PlayerJob]][JobType] == 5)
				{
					DisablePlayerCheckpointEx(playerid);
					SetTimerEx("CargoTimer", 5000, 0, "i", playerid);
					TogglePlayerControllableEx(playerid, FALSE);
					GameTextForPlayer(playerid, "~w~Unloading...", 4500, 4);
				}
				else
				{
					SendClientMessage(playerid, WHITE, "You are no longer a trucker. Your run has been canceled.");
					SetVehicleToRespawn(GetPVarInt(playerid, "TruckTrailer"));
					SetVehicleToRespawn(GetPVarInt(playerid, "TruckVeh"));

					DeletePVar(playerid, "TruckRun");
					DeletePVar(playerid, "TruckVeh");
					DeletePVar(playerid, "TruckTrailer");
					return 1;
				}
			}
			else return SendClientMessage(playerid, WHITE, "This is not the trailer you started with!");
		}
		else return SendClientMessage(playerid, WHITE, "This is not the truck you started with!");
	}
	if(GetPVarInt(playerid, "TruckRun") == 3)
	{
		if(GetPlayerVehicleID(playerid) == GetPVarInt(playerid, "TruckVeh"))
		{
			if(GetVehicleTrailer(GetPlayerVehicleID(playerid)) == GetPVarInt(playerid, "TruckTrailer"))
			{
				if(Job[Player[playerid][PlayerJob]][JobType] == 5)
				{
					Array[0] = 0;

					new Float:health;
					GetVehicleHealth(GetPVarInt(playerid, "TruckVeh"), health);

					new rand = random(3500) + random(3500);

					new temppay = floatround(Vehicle[GetRealVehicleID(GetPVarInt(playerid, "TruckVeh"))][MaxHealth] - health);
					new temppay2 = temppay * 3;

					new realpay = rand - temppay2;

					format(Array, sizeof(Array), "You have finished your trucker run and collected $%s in pay.", FormatNumberToString(realpay));
					SendClientMessage(playerid, WHITE, Array);
					format(Array, sizeof(Array), "Due to the damage on the truck, $%s has been subtracted from your pay.", FormatNumberToString(temppay));
					SendClientMessage(playerid, GREY, Array);

					if(temppay == 0) IncreaseJobSkill(playerid, 5, 2);
					else IncreaseJobSkill(playerid, 5, 1);

					GiveMoneyEx(playerid, realpay);

					SetVehicleToRespawn(GetPVarInt(playerid, "TruckTrailer"));
					SetVehicleToRespawn(GetPVarInt(playerid, "TruckVeh"));

					DeletePVar(playerid, "TruckRun");
					DeletePVar(playerid, "TruckVeh");
					DeletePVar(playerid, "TruckTrailer");

					DisablePlayerCheckpointEx(playerid);
				}
				else
				{
					SendClientMessage(playerid, WHITE, "You are no longer a trucker. Your run has been canceled.");
					SetVehicleToRespawn(GetPVarInt(playerid, "TruckTrailer"));
					SetVehicleToRespawn(GetPVarInt(playerid, "TruckVeh"));

					DeletePVar(playerid, "TruckRun");
					DeletePVar(playerid, "TruckVeh");
					DeletePVar(playerid, "TruckTrailer");
					return 1;
				}
			}
			else return SendClientMessage(playerid, WHITE, "This is not the trailer you started with!");
		}
		else return SendClientMessage(playerid, WHITE, "This is not the truck you started with!");
	}
	return 1;
}

forward CargoTimer(playerid);
public CargoTimer(playerid)
{
	if(GetPVarInt(playerid, "TruckRun") == 1)
	{
		TogglePlayerControllableEx(playerid, TRUE);
		SendClientMessage(playerid, WHITE, "Your cargo has been loaded. Go to the checkpoint to deliver them.");

		if(GetPVarInt(playerid, "Checkpoint") >= 1) return SendClientMessage(playerid, WHITE, "You already have an active checkpoint. Reach it, or type /killcheckpoint to clear it.");

		new rand = random(sizeof(TruckerCheckpoints));
		SetPlayerCheckpointEx(playerid, TruckerCheckpoints[rand][0], TruckerCheckpoints[rand][1], TruckerCheckpoints[rand][2], 5.0);

		SetPVarInt(playerid, "TruckRun", 2);
		return 1;
	}

	if(GetPVarInt(playerid, "TruckRun") == 2)
	{
		TogglePlayerControllableEx(playerid, TRUE);
		SendClientMessage(playerid, WHITE, "Your cargo has been unloaded. Head back to the docks to collect your pay.");

		if(GetPVarInt(playerid, "Checkpoint") >= 1) return SendClientMessage(playerid, WHITE, "You already have an active checkpoint. Reach it, or type /killcheckpoint to clear it.");
		SetPlayerCheckpointEx(playerid, 2524.8154, -2089.1436, 14.1389, 5.0);

		SetPVarInt(playerid, "TruckRun", 3);
		return 1;
	}

	else
	{
		SendClientMessage(playerid, WHITE, "Your run has been canceled.");
		SetVehicleToRespawn(GetPVarInt(playerid, "TruckTrailer"));
		SetVehicleToRespawn(GetPVarInt(playerid, "TruckVeh"));

		DeletePVar(playerid, "TruckRun");
		DeletePVar(playerid, "TruckVeh");
		DeletePVar(playerid, "TruckTrailer");
	}
	return 1;
}