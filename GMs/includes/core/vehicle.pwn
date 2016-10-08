#include <YSI\y_hooks>

CMD:e(playerid) return cmd_engine(playerid);
CMD:engine(playerid)
{
	if(Player[playerid][Authenticated] >= 1)
	{
		if(IsPlayerInAnyVehicle(playerid))
		{
			Array[0] = 0;
			new engine, lights, alarm, doors, bonnet, boot, objective, vehicleid = GetPlayerVehicleID(playerid);
			GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

			if(Player[playerid][AdminDuty] < 1)
			{
				new slot = IsPlayerInPersonalCar(playerid);
				if(Player[playerid][PlayerGroup] != Vehicle[GetRealVehicleID(vehicleid)][VehicleGroup] && slot == -1) 
				{
					if(Player[playerid][PlayerJob] != Vehicle[GetRealVehicleID(vehicleid)][VehicleJob] && slot == -1) 
					{
						return SendClientMessage(playerid, WHITE, "You do not have the keys for this vehicle!");
					}
				}
			}

			if(engine != 1) 
			{
				format(Array, sizeof(Array), "* %s turns the key in the ignition.", GetName(playerid));
				SetTimerEx("VehicleDelay", 1000, 0, "ii", playerid, vehicleid);
			}
			else
			{
				format(Array, sizeof(Array), "* %s turns the key in the ignition and the engine stops.", GetName(playerid));
				SetVehicleParamsEx(vehicleid, VEHICLE_PARAMS_OFF, lights, alarm, doors, bonnet, boot, objective);
			}

			SendNearbyMessage(playerid, Array, SCRIPTPURPLE, 30.0);
		}
		else return SendClientMessage(playerid, WHITE, "You are not in a vehicle.");
	}
	return 1;
}

CMD:hotwire(playerid)
{
	if(Player[playerid][Authenticated] >= 1)
	{
		if(IsPlayerInAnyVehicle(playerid))
		{
			if(GetRealDealerVehicleID(GetPlayerVehicleID(playerid)) > 0) return SendClientMessage(playerid, WHITE, "You cannot hotwire dealership vehicles!");
			Array[0] = 0;
			new engine, lights, alarm, doors, bonnet, boot, objective, vehicleid = GetPlayerVehicleID(playerid);
			GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

			if(Player[playerid][AdminDuty] > 1) return SendClientMessage(playerid, WHITE, "Admins should not hotwire vehicles. Sorry!");

			if(engine != 1) 
			{
				format(Array, sizeof(Array), "* %s tweaks with some wires under the dashboard.", GetName(playerid));
				SetTimerEx("VehicleDelayHotwire", 5000, 0, "ii", playerid, vehicleid);
			}
			else return SendClientMessage(playerid, WHITE, "You cannot hotwire a vehicle that is already on.");

			SendNearbyMessage(playerid, Array, SCRIPTPURPLE, 30.0);
		}
		else return SendClientMessage(playerid, WHITE, "You are not in a vehicle.");
	}
	return 1;
}

CMD:park(playerid, params[])
{
	new slot = IsPlayerInPersonalCar(playerid), vehicleid = GetPlayerVehicleID(playerid);
	if(slot >= 0 || Player[playerid][PlayerGroup] == Vehicle[GetRealVehicleID(vehicleid)][VehicleGroup])
	{
		if(GetPlayerSpeed(playerid, 0) == 0)
		{
			if(GetPVarInt(playerid, "CarModification") < gettime())
			{
				new Float:health;
				GetVehicleHealth(vehicleid, health);
				if(health < 800.0) return SendClientMessage(playerid, WHITE, "Your vehicle is too damaged to park it.");

				new Float:Pos[4];
				GetVehiclePos(vehicleid, Pos[0], Pos[1], Pos[2]);
				GetVehicleZAngle(vehicleid, Pos[3]);

				if(IsPlayersVehicle(playerid, vehicleid))
				{
					PlayerVehicle[playerid][CarX][slot] = Pos[0];
					PlayerVehicle[playerid][CarY][slot] = Pos[1];
					PlayerVehicle[playerid][CarZ][slot] = Pos[2];
					PlayerVehicle[playerid][CarA][slot] = Pos[3];

					PlayerVehicle[playerid][CarVW][slot] = GetPlayerVirtualWorld(playerid);
					PlayerVehicle[playerid][CarInt][slot] = GetPlayerInterior(playerid);

					PlayerVehicle[playerid][CarFuel][slot] = Fuel[PlayerVehicle[playerid][CarID][slot]];

					DestroyVehicle(PlayerVehicle[playerid][CarID][slot]);
					PlayerVehicle[playerid][CarID][slot] = CreateVehicle(PlayerVehicle[playerid][CarModel][slot], PlayerVehicle[playerid][CarX][slot], PlayerVehicle[playerid][CarY][slot], PlayerVehicle[playerid][CarZ][slot], PlayerVehicle[playerid][CarA][slot], PlayerVehicle[playerid][CarColour][slot], PlayerVehicle[playerid][CarColour2][slot], -1, 0);
					switch(slot)
           		    {
                		case 0: SetVehicleNumberPlate(PlayerVehicle[playerid][CarID][slot], PlayerVehicle[playerid][CarPlate1]);
                		case 1: SetVehicleNumberPlate(PlayerVehicle[playerid][CarID][slot], PlayerVehicle[playerid][CarPlate2]);
                		case 2: SetVehicleNumberPlate(PlayerVehicle[playerid][CarID][slot], PlayerVehicle[playerid][CarPlate3]);
                		case 3: SetVehicleNumberPlate(PlayerVehicle[playerid][CarID][slot], PlayerVehicle[playerid][CarPlate4]);
                		case 4: SetVehicleNumberPlate(PlayerVehicle[playerid][CarID][slot], PlayerVehicle[playerid][CarPlate5]);
                		default: return 1;
            		}
            		SetVehicleToRespawn(PlayerVehicle[playerid][CarID][slot]);
            		RemovePlayerFromVehicle(playerid);
					PutPlayerInVehicle(playerid, PlayerVehicle[playerid][CarID][slot], 0);
					SetVehicleVirtualWorld(PlayerVehicle[playerid][CarID][slot], PlayerVehicle[playerid][CarVW][slot]);
					LinkVehicleToInterior(PlayerVehicle[playerid][CarID][slot], PlayerVehicle[playerid][CarInt][slot]);
					SendClientMessage(playerid, WHITE, "You have parked your vehicle.");

					Fuel[PlayerVehicle[playerid][CarID][slot]] = PlayerVehicle[playerid][CarFuel][slot];

					AddPlayerVehicleMods(playerid);

					if(PlayerVehicle[playerid][CarPaintJob][slot] > 0) ChangeVehiclePaintjob(PlayerVehicle[playerid][CarID][slot], PlayerVehicle[playerid][CarPaintJob][slot] - 1);

					SavePlayerVehicleData(playerid, slot);
				}
				else
				{
					if(Player[playerid][Leader] > 0)
					{
						new id = GetRealVehicleID(vehicleid);

						Vehicle[id][VehiclePos][0] = Pos[0];
						Vehicle[id][VehiclePos][1] = Pos[1];
						Vehicle[id][VehiclePos][2] = Pos[2];
						Vehicle[id][VehiclePos][3] = Pos[3];

						Vehicle[id][VehicleVW] = GetPlayerVirtualWorld(playerid);
						Vehicle[id][VehicleInt] = GetPlayerInterior(playerid);

						Vehicle[id][VehFuel] = Fuel[Vehicle[id][VehID]];

						DestroyVehicle(Vehicle[id][VehID]);
						Vehicle[id][VehID] = CreateVehicle(Vehicle[id][Model], Vehicle[id][VehiclePos][0], Vehicle[id][VehiclePos][1], Vehicle[id][VehiclePos][2], Vehicle[id][VehiclePos][3], Vehicle[id][VehicleColour][0], Vehicle[id][VehicleColour][1], -1, Vehicle[id][Siren]);
						SetVehicleNumberPlate(vehicleid, Vehicle[id][Plate]);
						SetVehicleToRespawn(Vehicle[id][VehID]);
						RemovePlayerFromVehicle(playerid);
						PutPlayerInVehicle(playerid, Vehicle[id][VehID], 0);
						SetVehicleVirtualWorld(Vehicle[id][VehID], Vehicle[id][VehicleVW]);
						LinkVehicleToInterior(Vehicle[id][VehID], Vehicle[id][VehicleInt]);
						SendClientMessage(playerid, WHITE, "You have parked your group vehicle.");

						Fuel[Vehicle[id][VehID]] = Vehicle[id][VehFuel];
					}
					else return SendClientMessage(playerid, WHITE, "You must be a leader to park your group vehicles.");
				}
				SetPVarInt(playerid, "CarModification", gettime()+60);
			}
			else return SendClientMessage(playerid, WHITE, "You must wait 60 seconds before modifying your vehicle again.");
		}
		else return SendClientMessage(playerid, WHITE, "You must completely stop your vehicle first.");
	}
	else SendClientMessage(playerid, WHITE, "You do not have the keys for this vehicle!");
	return 1;
}

CMD:lock(playerid, params[])
{
	new vehicleid = GetClosestVehicle(playerid, 5.0);
	if(IsPlayersVehicle(playerid, vehicleid) || Player[playerid][PlayerGroup] == Vehicle[GetRealVehicleID(vehicleid)][VehicleGroup])
	{
		Array[0] = 0;
		new engine, lights, alarm, doors, bonnet, boot, objective;
		GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
		if(doors == VEHICLE_PARAMS_UNSET || doors == VEHICLE_PARAMS_OFF)
		{
			SetVehicleParamsEx(vehicleid, engine, lights, alarm, VEHICLE_PARAMS_ON, bonnet, boot, objective);
			format(Array, sizeof(Array), "* %s has locked their vehicle.", GetName(playerid));
		}
		else
		{
			SetVehicleParamsEx(vehicleid, engine, lights, alarm, VEHICLE_PARAMS_OFF, bonnet, boot, objective);
			format(Array, sizeof(Array), "* %s has unlocked their vehicle.", GetName(playerid));
		}
		SendNearbyMessage(playerid, Array, SCRIPTPURPLE, 30.0);
	}
	else SendClientMessage(playerid, WHITE, "You do not have the keys for this vehicle!");
	return 1;
}

CMD:deletecar(playerid, params[])
{
	new slot = IsPlayerInPersonalCar(playerid);
	if(slot != -1)
	{
		if(GetPlayerSpeed(playerid, 0) == 0)
		{
			if(GetPVarInt(playerid, "CarModification") < gettime())
			{
				new Float:health, vehicleid = GetPlayerVehicleID(playerid);
				GetVehicleHealth(vehicleid, health);
				if(health < 800.0) return SendClientMessage(playerid, WHITE, "Your vehicle is too damaged to delete it.");

				SetPVarInt(playerid, "DeletingSlot", slot);

				ShowPlayerDialog(playerid, DIALOG_DELETECAR_CONFIRM, DIALOG_STYLE_MSGBOX, "NOTICE", "You are about to delete the car you are in right now. Are you sure you want to continue?", "No", "Yes, delete");
			}
			else return SendClientMessage(playerid, WHITE, "You must wait 60 seconds before modifying your vehicle again.");
		}
		else return SendClientMessage(playerid, WHITE, "You must completely stop your vehicle first.");
	}
	else SendClientMessage(playerid, WHITE, "You do not have the keys for this vehicle!");
	return 1;
}


CMD:car(playerid, params[])
{
	new usage[16], window;
	if(sscanf(params, "s[16]D(0)", usage, window))
	{
	    SendClientMessage(playerid, WHITE, "SYNTAX: /car [usage]");
		return SendClientMessage(playerid, GREY, "Usages: engine, lights, hood, trunk, window.");
	}
	else
	{
		Array[0] = 0;
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			new engine, lights, alarm, doors, bonnet, boot, objective, vehicleid = GetPlayerVehicleID(playerid);
			GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

			if(strcmp(usage, "engine", true) == 0) return cmd_engine(playerid);
			else if(strcmp(usage, "lights", true) == 0)
			{
				if(lights == VEHICLE_PARAMS_UNSET || lights == VEHICLE_PARAMS_OFF)
				{
					format(Array, sizeof(Array), "* %s switches their vehicle lights on.", GetName(playerid));
					SetVehicleParamsEx(vehicleid, engine, VEHICLE_PARAMS_ON, alarm, doors, bonnet, boot, objective);
				}
				else
				{
					format(Array, sizeof(Array), "* %s switches their vehicle lights off.", GetName(playerid));
					SetVehicleParamsEx(vehicleid, engine, VEHICLE_PARAMS_OFF, alarm, doors, bonnet, boot, objective);
				}
			}
			else if(strcmp(usage, "hood", true) == 0 || strcmp(usage, "trunk", true) == 0) return SendClientMessage(playerid, WHITE, "You must be outside your vehicle to do this.");
			else if(strcmp(usage, "window", true) == 0)
			{
				if(window < 1 || window > 4)
				{
					SendClientMessage(playerid, WHITE, "SYNTAX: /car window [window]");
					return SendClientMessage(playerid, GREY, "Windows: 1 - Driver | 2 - Passenger | 3 - Backleft | 4 - Backright.");
				}
				new driver, passenger, backleft, backright;
				GetVehicleParamsCarWindows(vehicleid, driver, passenger, backleft, backright);
				switch(window)
				{
					case 1: 
					{
						SetVehicleParamsCarWindows(vehicleid, !driver, passenger, backleft, backright);
						format(Array, sizeof(Array), "* %s rolls the driver side window %s.", GetName(playerid), (window == VEHICLE_PARAMS_UNSET || window == VEHICLE_PARAMS_ON) ? ("down") : ("up"));
					}
					case 2: 
					{
						SetVehicleParamsCarWindows(vehicleid, driver, !passenger, backleft, backright);
						format(Array, sizeof(Array), "* %s rolls the passenger side window %s.", GetName(playerid), (passenger == VEHICLE_PARAMS_UNSET || passenger == VEHICLE_PARAMS_ON) ? ("down") : ("up"));
					}
					case 3: 
					{
						SetVehicleParamsCarWindows(vehicleid, driver, passenger, !backleft, backright);
						format(Array, sizeof(Array), "* %s rolls the back left side window %s.", GetName(playerid), (backleft == VEHICLE_PARAMS_UNSET || backleft == VEHICLE_PARAMS_ON) ? ("down") : ("up"));
					}
					case 4: 
					{
						SetVehicleParamsCarWindows(vehicleid, driver, passenger, backleft, !backright);
						format(Array, sizeof(Array), "* %s rolls the back right side window %s.", GetName(playerid), (backright == VEHICLE_PARAMS_UNSET || backright == VEHICLE_PARAMS_ON) ? ("down") : ("up"));
					}
					default: return 1;
				}
			}
			else if(strcmp(usage, "windows", true) == 0)
			{
				new driver, passenger, backleft, backright;
				GetVehicleParamsCarWindows(vehicleid, driver, passenger, backleft, backright);
				SetVehicleParamsCarWindows(vehicleid, !driver, !passenger, !backleft, !backright);
				format(Array, sizeof(Array), "* %s rolls the driver side window %s, passenger side window %s, back left side window %s, and back right window %s.", GetName(playerid),
				 	(driver == VEHICLE_PARAMS_UNSET || driver == VEHICLE_PARAMS_ON) ? ("down") : ("up"),
				 	(passenger == VEHICLE_PARAMS_UNSET || passenger == VEHICLE_PARAMS_ON) ? ("down") : ("up"),
				 	(backleft == VEHICLE_PARAMS_UNSET || backleft == VEHICLE_PARAMS_ON) ? ("down") : ("up"),
				 	(backright == VEHICLE_PARAMS_UNSET || backright == VEHICLE_PARAMS_ON) ? ("down") : ("up"));
			}
			else
			{
				SendClientMessage(playerid, WHITE, "SYNTAX: /car [usage]");
				return SendClientMessage(playerid, GREY, "Usages: engine, lights, hood, trunk, window(s).");
			}
			SendNearbyMessage(playerid, Array, SCRIPTPURPLE, 30.0);
		}
		else if(GetPlayerState(playerid) == PLAYER_STATE_PASSENGER)
		{
			new vehicleid = GetPlayerVehicleID(playerid);
			if(strcmp(usage, "window", true) == 0)
			{
				window = GetPlayerVehicleSeat(playerid) + 1;
				if(window < 1 || window > 4) return 1; // Just a check

				new driver, passenger, backleft, backright;
				GetVehicleParamsCarWindows(vehicleid, driver, passenger, backleft, backright);
				switch(window)
				{
					case 2:
					{
						SetVehicleParamsCarWindows(vehicleid, driver, !passenger, backleft, backright);
						format(Array, sizeof(Array), "* %s rolls the passenger side window %s.", GetName(playerid), (passenger == VEHICLE_PARAMS_UNSET || passenger == VEHICLE_PARAMS_ON) ? ("down") : ("up"));
					}
					case 3: 
					{
						SetVehicleParamsCarWindows(vehicleid, driver, passenger, !backleft, backright);
						format(Array, sizeof(Array), "* %s rolls the back left side window %s.", GetName(playerid), (backleft == VEHICLE_PARAMS_UNSET || backleft == VEHICLE_PARAMS_ON) ? ("down") : ("up"));
					}
					case 4: 
					{
						SetVehicleParamsCarWindows(vehicleid, driver, passenger, backleft, !backright);
						format(Array, sizeof(Array), "* %s rolls the back right side window %s.", GetName(playerid), (backright == VEHICLE_PARAMS_UNSET || backright == VEHICLE_PARAMS_ON) ? ("down") : ("up"));
					}
					default: return 1;
				}
				SendNearbyMessage(playerid, Array, SCRIPTPURPLE, 30.0);
			}
		}
		else if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
		{
			new engine, lights, alarm, doors, bonnet, boot, objective, vehicleid = GetClosestVehicle(playerid, 5.0);
			if(vehicleid == INVALID_VEHICLE_ID) return SendClientMessage(playerid, WHITE, "You are not near or inside a vehicle!");
			GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

			if(strcmp(usage, "hood", true) == 0)
			{
				if(bonnet == VEHICLE_PARAMS_UNSET || bonnet == VEHICLE_PARAMS_OFF)
				{
					if(doors == VEHICLE_PARAMS_UNSET || doors == VEHICLE_PARAMS_OFF)
					{
						format(Array, sizeof(Array), "* %s opens the vehicle hood.", GetName(playerid));
						SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, VEHICLE_PARAMS_ON, boot, objective);
					}
					else if(doors == VEHICLE_PARAMS_ON && vehicleid == IsPlayersVehicle(playerid, vehicleid) || doors == VEHICLE_PARAMS_ON && Player[playerid][PlayerGroup] == Vehicle[GetRealVehicleID(vehicleid)][VehicleGroup])
					{
						format(Array, sizeof(Array), "* %s opens the vehicle hood.", GetName(playerid));
						SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, VEHICLE_PARAMS_ON, boot, objective);
					}
					else return SendClientMessage(playerid, WHITE, "You do not have the keys to this vehicle!");
				}
				else
				{
					format(Array, sizeof(Array), "* %s closes the vehicle hood.", GetName(playerid));
					SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, VEHICLE_PARAMS_OFF, boot, objective);
				}
			}
			else if(strcmp(usage, "trunk", true) == 0)
			{
				if(boot == VEHICLE_PARAMS_UNSET || boot == VEHICLE_PARAMS_OFF)
				{
					if(doors == VEHICLE_PARAMS_UNSET || doors == VEHICLE_PARAMS_OFF)
					{
						format(Array, sizeof(Array), "* %s opens the vehicle trunk.", GetName(playerid));
						SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, VEHICLE_PARAMS_ON, objective);
					}
					else if(doors == VEHICLE_PARAMS_ON && vehicleid == IsPlayersVehicle(playerid, vehicleid) || doors == VEHICLE_PARAMS_ON && Player[playerid][PlayerGroup] == Vehicle[GetRealVehicleID(vehicleid)][VehicleGroup])
					{
						format(Array, sizeof(Array), "* %s opens the vehicle trunk.", GetName(playerid));
						SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, VEHICLE_PARAMS_ON, objective);
					}
					else return SendClientMessage(playerid, WHITE, "You do not have the keys to this vehicle!");
				}
				else
				{
					format(Array, sizeof(Array), "* %s closes the vehicle trunk.", GetName(playerid));
					SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, VEHICLE_PARAMS_OFF, objective);
				}
			}
			else
			{
				SendClientMessage(playerid, WHITE, "SYNTAX: /car [usage]");
				return SendClientMessage(playerid, GREY, "Usages: engine, lights, hood, trunk, window(s).");
			}
			SendNearbyMessage(playerid, Array, SCRIPTPURPLE, 30.0);
		}
	}
	return 1;
}

CMD:togspeedo(playerid, params[])
{
	if(Player[playerid][Speedo] == 1)
	{
	    Player[playerid][Speedo] = 0;
	    SendClientMessage(playerid, WHITE, "You have disabled your speedometer!");
	    PlayerTextDrawHide(playerid, SpeedTextDraw[playerid]);
		PlayerTextDrawHide(playerid, FuelTextDraw[playerid]);
	}
	else
	{
	    Player[playerid][Speedo] = 1;
	    SendClientMessage(playerid, WHITE, "You have enabled your speedometer!");
	    PlayerTextDrawShow(playerid, SpeedTextDraw[playerid]);
		PlayerTextDrawShow(playerid, FuelTextDraw[playerid]);
	}
	return 1;
}

GetClosestVehicle(playerid, Float:range, excludeinvehicle = 0) 
{
	new id = INVALID_VEHICLE_ID, Float:Pos[3], Float:temprange, Float:newrange = range;

	for(new i = 1; i <= MAX_VEHICLES; ++i)
	{
		GetVehiclePos(i, Pos[0], Pos[1], Pos[2]);
		temprange = GetPlayerDistanceFromPoint(playerid, Pos[0], Pos[1], Pos[2]);

		if(temprange < range) 
		{
			if(temprange < newrange)
			{
				newrange = temprange;
				if(GetPlayerVehicleID(playerid) == i && excludeinvehicle == 1) continue;
				else id = i;
			}
		}
	}
	return id;
}

CanVehicleBeModified(playerid)
{
	new carid = GetPlayerVehicleID(playerid);
	new carmodel = GetVehicleModel(carid);
	for (new i = 0; i < sizeof(UnmodifiableVehicles); i++)
	{
	    if(carmodel == UnmodifiableVehicles[i]) return 1;
	}
	return 0;
}

GetPlayerNextVehicleSlot(playerid)
{
    new id = -1;
    for(new i; i < MAX_PLAYER_VEHICLES; i++)
    {
        if(PlayerVehicle[playerid][CarModel][i] == 0) return i;
    }
    return id;
}

IsPlayerInPersonalCar(playerid)
{
    new slot = -1;
    if(PlayerVehicle[playerid][CarID][0] == GetPlayerVehicleID(playerid) && PlayerVehicle[playerid][CarModel][0] != 0) slot = 0;
    else if(PlayerVehicle[playerid][CarID][1] == GetPlayerVehicleID(playerid) && PlayerVehicle[playerid][CarModel][1] != 0) slot = 1;
    else if(PlayerVehicle[playerid][CarID][2] == GetPlayerVehicleID(playerid) && PlayerVehicle[playerid][CarModel][2] != 0) slot = 2;
    else if(PlayerVehicle[playerid][CarID][3] == GetPlayerVehicleID(playerid) && PlayerVehicle[playerid][CarModel][3] != 0) slot = 3;
    else if(PlayerVehicle[playerid][CarID][4] == GetPlayerVehicleID(playerid) && PlayerVehicle[playerid][CarModel][4] != 0) slot = 4;
    return slot;
}

GetPlayerVehicleSlot(playerid, vehicleid)
{
    new slot = -1;
    if(PlayerVehicle[playerid][CarID][0] == vehicleid && PlayerVehicle[playerid][CarModel][0] != 0) slot = 0;
    else if(PlayerVehicle[playerid][CarID][1] == vehicleid && PlayerVehicle[playerid][CarModel][1] != 0) slot = 1;
    else if(PlayerVehicle[playerid][CarID][2] == vehicleid && PlayerVehicle[playerid][CarModel][2] != 0) slot = 2;
    else if(PlayerVehicle[playerid][CarID][3] == vehicleid && PlayerVehicle[playerid][CarModel][3] != 0) slot = 3;
    else if(PlayerVehicle[playerid][CarID][4] == vehicleid && PlayerVehicle[playerid][CarModel][4] != 0) slot = 4;
    return slot;
}

IsPlayersVehicle(playerid, vehicleid)
{
    if(PlayerVehicle[playerid][CarID][0] == vehicleid && PlayerVehicle[playerid][CarModel][0] != 0) return 1;
    else if(PlayerVehicle[playerid][CarID][1] == vehicleid && PlayerVehicle[playerid][CarModel][1] != 0) return 1;
    else if(PlayerVehicle[playerid][CarID][2] == vehicleid && PlayerVehicle[playerid][CarModel][2] != 0) return 1;
    else if(PlayerVehicle[playerid][CarID][3] == vehicleid && PlayerVehicle[playerid][CarModel][3] != 0) return 1;
    else if(PlayerVehicle[playerid][CarID][4] == vehicleid && PlayerVehicle[playerid][CarModel][4] != 0) return 1;
    return 0;
}

GetPlayerCarMods(playerid)
{
    for(new i; i < MAX_PLAYER_VEHICLES; i++) 
    {
        PlayerVehicle[playerid][CarMod0][i] = GetVehicleComponentInSlot(PlayerVehicle[playerid][CarID][i], 0);
        PlayerVehicle[playerid][CarMod1][i] = GetVehicleComponentInSlot(PlayerVehicle[playerid][CarID][i], 1);
        PlayerVehicle[playerid][CarMod2][i] = GetVehicleComponentInSlot(PlayerVehicle[playerid][CarID][i], 2);
        PlayerVehicle[playerid][CarMod3][i] = GetVehicleComponentInSlot(PlayerVehicle[playerid][CarID][i], 3);
        PlayerVehicle[playerid][CarMod4][i] = GetVehicleComponentInSlot(PlayerVehicle[playerid][CarID][i], 4);
        PlayerVehicle[playerid][CarMod5][i] = GetVehicleComponentInSlot(PlayerVehicle[playerid][CarID][i], 5);
        PlayerVehicle[playerid][CarMod6][i] = GetVehicleComponentInSlot(PlayerVehicle[playerid][CarID][i], 6);
        PlayerVehicle[playerid][CarMod7][i] = GetVehicleComponentInSlot(PlayerVehicle[playerid][CarID][i], 7);
        PlayerVehicle[playerid][CarMod8][i] = GetVehicleComponentInSlot(PlayerVehicle[playerid][CarID][i], 8);
        PlayerVehicle[playerid][CarMod9][i] = GetVehicleComponentInSlot(PlayerVehicle[playerid][CarID][i], 9);
        PlayerVehicle[playerid][CarMod10][i] = GetVehicleComponentInSlot(PlayerVehicle[playerid][CarID][i], 10);
        PlayerVehicle[playerid][CarMod11][i] = GetVehicleComponentInSlot(PlayerVehicle[playerid][CarID][i], 11);
        PlayerVehicle[playerid][CarMod12][i] = GetVehicleComponentInSlot(PlayerVehicle[playerid][CarID][i], 12);
        PlayerVehicle[playerid][CarMod13][i] = GetVehicleComponentInSlot(PlayerVehicle[playerid][CarID][i], 13);
    }
    return 1;
}

AddPlayerVehicleMods(playerid)
{
	for(new i; i < MAX_PLAYER_VEHICLES; i++)
	{
		if(PlayerVehicle[playerid][CarMod0][i] > 0) AddVehicleComponent(PlayerVehicle[playerid][CarID][i], PlayerVehicle[playerid][CarMod0][i]);
    	if(PlayerVehicle[playerid][CarMod1][i] > 0) AddVehicleComponent(PlayerVehicle[playerid][CarID][i], PlayerVehicle[playerid][CarMod1][i]);
    	if(PlayerVehicle[playerid][CarMod2][i] > 0) AddVehicleComponent(PlayerVehicle[playerid][CarID][i], PlayerVehicle[playerid][CarMod2][i]);
    	if(PlayerVehicle[playerid][CarMod3][i] > 0) AddVehicleComponent(PlayerVehicle[playerid][CarID][i], PlayerVehicle[playerid][CarMod3][i]);
    	if(PlayerVehicle[playerid][CarMod4][i] > 0) AddVehicleComponent(PlayerVehicle[playerid][CarID][i], PlayerVehicle[playerid][CarMod4][i]);
    	if(PlayerVehicle[playerid][CarMod5][i] > 0) AddVehicleComponent(PlayerVehicle[playerid][CarID][i], PlayerVehicle[playerid][CarMod5][i]);
    	if(PlayerVehicle[playerid][CarMod6][i] > 0) AddVehicleComponent(PlayerVehicle[playerid][CarID][i], PlayerVehicle[playerid][CarMod6][i]);
    	if(PlayerVehicle[playerid][CarMod7][i] > 0) AddVehicleComponent(PlayerVehicle[playerid][CarID][i], PlayerVehicle[playerid][CarMod7][i]);
    	if(PlayerVehicle[playerid][CarMod8][i] > 0) AddVehicleComponent(PlayerVehicle[playerid][CarID][i], PlayerVehicle[playerid][CarMod8][i]);
    	if(PlayerVehicle[playerid][CarMod9][i] > 0) AddVehicleComponent(PlayerVehicle[playerid][CarID][i], PlayerVehicle[playerid][CarMod9][i]);
    	if(PlayerVehicle[playerid][CarMod10][i] > 0) AddVehicleComponent(PlayerVehicle[playerid][CarID][i], PlayerVehicle[playerid][CarMod10][i]);
    	if(PlayerVehicle[playerid][CarMod11][i] > 0) AddVehicleComponent(PlayerVehicle[playerid][CarID][i], PlayerVehicle[playerid][CarMod11][i]);
    	if(PlayerVehicle[playerid][CarMod12][i] > 0) AddVehicleComponent(PlayerVehicle[playerid][CarID][i], PlayerVehicle[playerid][CarMod12][i]);
    	if(PlayerVehicle[playerid][CarMod13][i] > 0) AddVehicleComponent(PlayerVehicle[playerid][CarID][i], PlayerVehicle[playerid][CarMod13][i]);
	}
	return 1;
}

forward VehicleDelay(playerid, vehicleid);
public VehicleDelay(playerid, vehicleid)
{
	Array[0] = 0;
	if(GetPlayerVehicleID(playerid) == vehicleid)
	{
		new Float:health, engine, lights, alarm, doors, bonnet, boot, objective;
		GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
		GetVehicleHealth(vehicleid, health);

		if(Fuel[vehicleid] == 0) 
		{
			format(Array, sizeof(Array), "* The vehicle has ran out of fuel. (( %s ))", GetName(playerid));
			return SendNearbyMessage(playerid, Array, SCRIPTPURPLE, 30.0);
		}

		if(health > 256.0)
		{
			format(Array, sizeof(Array), "* The vehicle engine starts (( %s ))", GetName(playerid));
			SetVehicleParamsEx(vehicleid, VEHICLE_PARAMS_ON, lights, alarm, doors, bonnet, boot, objective);
		}
		else format(Array, sizeof(Array), "* The vehicle engine stalls (( %s ))", GetName(playerid));
	}
	else format(Array, sizeof(Array), "* The vehicle engine doesn't start (( %s ))", GetName(playerid));

	SendNearbyMessage(playerid, Array, SCRIPTPURPLE, 30.0);
	return 1;
}

forward VehicleDelayHotwire(playerid, vehicleid);
public VehicleDelayHotwire(playerid, vehicleid)
{
	Array[0] = 0;
	if(GetPlayerVehicleID(playerid) == vehicleid)
	{
		new Float:health, engine, lights, alarm, doors, bonnet, boot, objective;
		GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
		GetVehicleHealth(vehicleid, health);

		if(Fuel[vehicleid] == 0) 
		{
			format(Array, sizeof(Array), "* The vehicle has ran out of fuel. (( %s ))", GetName(playerid));
			return SendNearbyMessage(playerid, Array, SCRIPTPURPLE, 30.0);
		}

		if(health > 256.0)
		{
			format(Array, sizeof(Array), "* The vehicle engine starts (( %s ))", GetName(playerid));
			SetVehicleParamsEx(vehicleid, VEHICLE_PARAMS_ON, lights, VEHICLE_PARAMS_ON, doors, bonnet, boot, objective);

			SetTimerEx("TurnOffAlarm", 15000, 0, "i", vehicleid);
		}
		else format(Array, sizeof(Array), "* The vehicle engine stalls (( %s ))", GetName(playerid));
	}
	else format(Array, sizeof(Array), "* The vehicle engine doesn't start (( %s ))", GetName(playerid));

	SendNearbyMessage(playerid, Array, SCRIPTPURPLE, 30.0);
	return 1;
}

forward TurnOffAlarm(vehicleid);
public TurnOffAlarm(vehicleid)
{
	Array[0] = 0;
	new engine, lights, alarm, doors, bonnet, boot, objective;
	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	SetVehicleParamsEx(vehicleid, engine, lights, VEHICLE_PARAMS_OFF, doors, bonnet, boot, objective);
	return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
	switch(newstate) // FOR ALL NEWSTATES.
	{
		case PLAYER_STATE_DRIVER:
		{
			new vehicleid = GetPlayerVehicleID(playerid);
			Array[0] = 0;

			if(Player[playerid][PlayerGroup] != Vehicle[GetRealVehicleID(vehicleid)][VehicleGroup] && Vehicle[GetRealVehicleID(vehicleid)][VehicleGroup] > -1)
			{
				RemovePlayerFromVehicle(playerid);
				format(Array, sizeof(Array), "This vehicle is only useable by the %s", Group[Vehicle[GetRealVehicleID(vehicleid)][VehicleGroup]][GroupName]);
				return SendClientMessage(playerid, WHITE, Array);
			}

			if(Player[playerid][PlayerJob] != Vehicle[GetRealVehicleID(vehicleid)][VehicleJob] && Vehicle[GetRealVehicleID(vehicleid)][VehicleJob] > -1)
			{
				RemovePlayerFromVehicle(playerid);
				format(Array, sizeof(Array), "This vehicle is only useable by a %s", Job[Vehicle[GetRealVehicleID(vehicleid)][VehicleJob]][JobName]);
				return SendClientMessage(playerid, WHITE, Array);
			}

			if(Player[playerid][Speedo] == 1)
			{
				PlayerTextDrawShow(playerid, SpeedTextDraw[playerid]);
				PlayerTextDrawShow(playerid, FuelTextDraw[playerid]);
			}
		}
		case PLAYER_STATE_ONFOOT:
		{
			if(oldstate == PLAYER_STATE_DRIVER)
			{
				PlayerTextDrawHide(playerid, SpeedTextDraw[playerid]);
				PlayerTextDrawHide(playerid, FuelTextDraw[playerid]);
			}
		}
	}
	return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if((newkeys & KEY_NO))
	{
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER) return cmd_engine(playerid);
	}
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case DIALOG_DELETECAR_CONFIRM:
		{
			if(!response)
			{
				new slot = GetPVarInt(playerid, "DeletingSlot");
				DeletePVar(playerid, "DeletingSlot");

				PlayerVehicle[playerid][CarModel][slot] = 0;

				PlayerVehicle[playerid][CarX][slot] = 0.0000;
				PlayerVehicle[playerid][CarY][slot] = 0.0000;
				PlayerVehicle[playerid][CarZ][slot] = 0.0000;
				PlayerVehicle[playerid][CarA][slot] = 0.0000;

				switch(slot)
				{
					case 0: format(PlayerVehicle[playerid][CarPlate1][slot], 16, "XYZSR998");
					case 1: format(PlayerVehicle[playerid][CarPlate2][slot], 16, "XYZSR998");
					case 2: format(PlayerVehicle[playerid][CarPlate3][slot], 16, "XYZSR998");
					case 3: format(PlayerVehicle[playerid][CarPlate4][slot], 16, "XYZSR998");
					case 4: format(PlayerVehicle[playerid][CarPlate5][slot], 16, "XYZSR998");
					default: return 1;
				}

				Fuel[PlayerVehicle[playerid][CarID][slot]] = 0;

				PlayerVehicle[playerid][CarFuel][slot] = 0;

				DestroyVehicle(PlayerVehicle[playerid][CarID][slot]);
				SendClientMessage(playerid, WHITE, "You have deleted your vehicle.");

				GetPlayerCarMods(playerid);

				format(Array, sizeof(Array), "DELETE FROM `playervehicles` WHERE `id` = '%d'", PlayerVehicle[playerid][CarDatabaseID][slot]);
				mysql_tquery(SQL, Array, "", "");
				
				SetPVarInt(playerid, "CarModification", gettime()+60);
			}
			else
			{
				DeletePVar(playerid, "DeletingSlot");
				return 1;
			}
		}
	}
	return 1;
}

CheckVehicleSeats(vehicle, seat)
{
	switch(GetVehicleModel(vehicle)) 
	{
		case 425, 430, 432, 441, 446, 448, 452, 453, 454, 464, 465, 472, 473, 476, 481, 484, 485, 486, 493, 501, 509, 510, 519, 520, 530, 531, 532, 539, 553, 564, 568, 571, 572, 574, 583, 592, 594, 595: return 0;
		default: if(IsVehicleOccupied(vehicle, seat)) return 0;
	}
	return 1;
}

/*IsABoat(vehicle) 
{
	switch(GetVehicleModel(vehicle)) 
	{
		case 472, 473, 493, 484, 430, 454, 453, 452, 446, 595: return 1;
	}
	return 0;
}*/

IsABike(vehicle) 
{
	switch(GetVehicleModel(vehicle)) 
	{
		case 509, 481, 510, 462, 448, 581, 522, 461, 521, 523, 463, 586, 468, 471: return 1;
	}
	return 0;
}

IsATrain(vehicle) 
{
	switch(vehicle) 
	{
		case 538, 537, 590, 569, 570: return 1;
	}
	return 0;
}

IsAPlane(vehicle, type = 0)
{
	if(type == 0)
	{
		switch(GetVehicleModel(vehicle)) 
		{
			case 592, 577, 511, 512, 593, 520, 553, 476, 519, 460, 513, 548, 425, 417, 487, 488, 497, 563, 447, 469: return 1;
		}
	}
	else
	{
		switch(vehicle) 
		{
			case 592, 577, 511, 512, 593, 520, 553, 476, 519, 460, 513, 548, 425, 417, 487, 488, 497, 563, 447, 469: return 1;
		}
	}
	return 0;
}

/*IsWeaponizedVehicle(vehicle)
{
	switch(vehicle) 
	{
		case 425, 432, 447, 476, 520: return 1;
	}
	return 0;
}*/

IsAHelicopter(vehicle)
{
	if(GetVehicleModel(vehicle) == 548 || GetVehicleModel(vehicle) == 425 || GetVehicleModel(vehicle) == 417 || GetVehicleModel(vehicle) == 487 || GetVehicleModel(vehicle) == 488 || GetVehicleModel(vehicle) == 497 || GetVehicleModel(vehicle) == 563 || GetVehicleModel(vehicle) == 447 || GetVehicleModel(vehicle) == 469 || GetVehicleModel(vehicle) == 593) return 1;
	return 0;
}


/*IsAnBus(vehicle)
{
	if(GetVehicleModel(vehicle) == 431 || GetVehicleModel(vehicle) == 437) return 1;
	return 0;
}

IsAnTaxi(vehicle)
{
	if(GetVehicleModel(vehicle) == 420 || GetVehicleModel(vehicle) == 438) return 1;
	return 0;
}*/