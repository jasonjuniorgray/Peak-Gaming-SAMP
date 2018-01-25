CMD:fix(playerid, params[])
{
	if(Job[Player[playerid][PlayerJob]][JobType] == 2)
	{
		if(GetPVarInt(playerid, "MechanicTime") > gettime()) return SendClientMessage(playerid, GREY, "You must wait 60 seconds before using your commands again.");
		if(IsPlayerInAnyVehicle(playerid) || GetPVarInt(playerid, "Cuffed") >= 1 || GetPVarType(playerid, "Tasered")) return SendClientMessage(playerid, GREY, "You cannot do this right now!");
		if(Player[playerid][MechanicTimer] != 0) return SendClientMessage(playerid, GREY, "You are already using your mechanic skills!");

		new vehicleid = GetClosestVehicle(playerid, 10.0);
		if(vehicleid != INVALID_VEHICLE_ID)
		{
			new engine, lights, alarm, doors, bonnet, boot, objective;
            GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);

            if(bonnet == VEHICLE_PARAMS_ON)
            {
            	Array[0] = 0;
		        SetVehicleHealth(vehicleid, 1000.0);
			    SendClientMessage(playerid, WHITE, "You have fixed the vehicle.");

			    SetPVarInt(playerid, "MechanicTime", gettime() + 60);

			    format(Array, sizeof(Array), "{FF8000}** {C2A2DA}%s has repaired the vehicle.", GetName(playerid));
                SendNearbyMessage(playerid, Array, PURPLE, 30.0);

                IncreaseJobSkill(playerid, 1, 1);
		    }
		    else
            {
		        SendClientMessage(playerid, WHITE, "The vehicle's hood must be opened.");
            }
		}
	}
	else SendClientMessage(playerid, WHITE, "You are not a mechanic!");
	return 1;
}

CMD:repair(playerid, params[])
{
	if(Job[Player[playerid][PlayerJob]][JobType] == 2)
	{
		new id, price;
		if(sscanf(params, "ud", id, price)) 
		{
			return SendClientMessage(playerid, WHITE, "SYNTAX: /repair [playerid] [price]");
		}
		else 
		{
			if(!IsPlayerNearPlayer(playerid, id, 8.0)) return SendClientMessage(playerid, GREY, "You are not near that player.");
			if(GetPVarInt(playerid, "MechanicTime") > gettime()) return SendClientMessage(playerid, GREY, "You must wait 60 seconds before using your commands again.");
			if(IsPlayerInAnyVehicle(playerid) || GetPVarInt(playerid, "Cuffed") >= 1 || GetPVarType(playerid, "Tasered")) return SendClientMessage(playerid, GREY, "You cannot do this right now!");
			if(price < 0) return SendClientMessage(playerid, GREY, "The price must be a positive integer!");
			if(Player[playerid][MechanicTimer] != 0) return SendClientMessage(playerid, GREY, "You are already using your mechanic skills!");
			if(GetPVarType(playerid, "Offering")) return SendClientMessage(playerid, GREY, "You already have a pending offer. Type /cancel offer to reset it.");

			new vehicleid = GetClosestVehicle(playerid, 10.0);
			if(vehicleid != INVALID_VEHICLE_ID)
			{
				new engine, lights, alarm, doors, bonnet, boot, objective;
            	GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);

            	if(bonnet == VEHICLE_PARAMS_ON)
            	{
            		if(id == playerid)
            		{
            			SetPVarInt(playerid, "RepairInt", 1);
            			Player[playerid][MechanicTimer] = SetTimerEx("RepairTimer", 1000, TRUE, "iii", playerid, id, vehicleid);

            			format(Array, sizeof(Array), "{FF8000}** {C2A2DA}%s has started to repair the vehicle.", GetName(playerid));
                		SendNearbyMessage(playerid, Array, PURPLE, 30.0);

                		SendClientMessage(playerid, WHITE, "You are now repairing the vehicle. Do not go to far away from it, or inside any other vehicle!");
            			return 1;
            		}
            		SetPVarInt(playerid, "Offering", 1);
            		SetPVarInt(id, "RepairID", playerid);
            		SetPVarInt(id, "RepairVehID", vehicleid);
            		SetPVarInt(id, "RepairPrice", price);

            		format(Array, sizeof(Array), "You have offered %s a repair for $%s.", GetName(id), FormatNumberToString(price));
  					SendClientMessage(playerid, LIGHTBLUE, Array);
					format(Array, sizeof(Array), "%s has offered to repair your vehicle for $%s, type /accept repair to accept it.", GetName(playerid), FormatNumberToString(price));
  					SendClientMessage(id, LIGHTBLUE, Array);
		    	}
		    	else
            	{
		        	return SendClientMessage(playerid, WHITE, "The vehicle's hood must be opened.");
            	}
            }
            else return SendClientMessage(playerid, WHITE, "You are not near a vehicle!");
		}
	}
	else SendClientMessage(playerid, WHITE, "You are not a mechanic!");
	return 1;
}

CMD:respray(playerid, params[])
{
	if(Job[Player[playerid][PlayerJob]][JobType] == 2)
	{
		new id, colour[2], price;
		if(sscanf(params, "uddd", id, colour[0], colour[1], price)) 
		{
			return SendClientMessage(playerid, WHITE, "SYNTAX: /respray [playerid] [colour 1] [colour 2] [price]");
		}
		else
		{
			if(!IsPlayerNearPlayer(playerid, id, 8.0)) return SendClientMessage(playerid, GREY, "You are not near that player.");
			if(GetPVarInt(playerid, "MechanicTime") > gettime()) return SendClientMessage(playerid, GREY, "You must wait 60 seconds before using your commands again.");
			if(IsPlayerInAnyVehicle(playerid) || GetPVarInt(playerid, "Cuffed") >= 1 || GetPVarType(playerid, "Tasered")) return SendClientMessage(playerid, GREY, "You cannot do this right now!");
			if(price < 0) return SendClientMessage(playerid, GREY, "The price must be a positive integer!");
			if(GetPlayerWeapon(playerid) != 41) return SendClientMessage(playerid, GREY, "You must be holding a spraycan!");
			if(Player[playerid][MechanicTimer] != 0) return SendClientMessage(playerid, GREY, "You are already using your mechanic skills!");
			if(colour[0] < 0 || colour[0] > 255 || colour[1] < 0 || colour[1] > 255) return SendClientMessage(playerid, GREY, "Colour ID's are from 0 to 255.");
			if(GetPVarType(playerid, "Offering")) return SendClientMessage(playerid, GREY, "You already have a pending offer. Type /cancel offer to reset it.");

			new vehicleid = GetClosestVehicle(playerid, 10.0);
			if(vehicleid != INVALID_VEHICLE_ID)
			{
				if(!IsPlayersVehicle(id, vehicleid)) return SendClientMessage(playerid, GREY, "You are not near a vehicle they own!");

				if(id == playerid)
            	{
            		SetPVarInt(playerid, "ColourInt", 1);
            		Player[playerid][MechanicTimer] = SetTimerEx("ColourTimer", 1000, TRUE, "iiiii", playerid, id, vehicleid, colour[0], colour[1]);

            		format(Array, sizeof(Array), "{FF8000}** {C2A2DA}%s has started to respray the vehicle.", GetName(playerid));
                	SendNearbyMessage(playerid, Array, PURPLE, 30.0);

                	SendClientMessage(playerid, WHITE, "You are now spraying the vehicle. Do not go to far away from it, inside any other vehicle, and do not put your spraycan away!");
            		return 1;
            	}

            	SetPVarInt(playerid, "Offering", 1);
            	SetPVarInt(id, "ColourID", playerid);
            	SetPVarInt(id, "Colour1", colour[0]);
            	SetPVarInt(id, "Colour2", colour[1]);
            	SetPVarInt(id, "ColourVehID", vehicleid);
            	SetPVarInt(id, "ColourPrice", price);

            	format(Array, sizeof(Array), "You have offered %s a respray for $%s.", GetName(id), FormatNumberToString(price));
  				SendClientMessage(playerid, LIGHTBLUE, Array);
				format(Array, sizeof(Array), "%s has offered to respray your vehicle (to ID: %d, ID 2: %d) for $%s, type /accept respray to accept it.", GetName(playerid), colour[0], colour[1], FormatNumberToString(price));
  				SendClientMessage(id, LIGHTBLUE, Array);
            }
            else return SendClientMessage(playerid, WHITE, "You are not near a vehicle they own!");
		}
	}
	else SendClientMessage(playerid, WHITE, "You are not a mechanic!");
	return 1;
}

CMD:refill(playerid, params[])
{
	if(Job[Player[playerid][PlayerJob]][JobType] == 2)
	{
		new id, price;
		if(sscanf(params, "ud", id, price)) 
		{
			return SendClientMessage(playerid, WHITE, "SYNTAX: /refill [playerid] [price]");
		}
		else 
		{
			if(!IsPlayerNearPlayer(playerid, id, 8.0)) return SendClientMessage(playerid, GREY, "You are not near that player.");
			if(GetPVarInt(playerid, "MechanicTime") > gettime()) return SendClientMessage(playerid, GREY, "You must wait 60 seconds before using your commands again.");
			if(IsPlayerInAnyVehicle(playerid) || GetPVarInt(playerid, "Cuffed") >= 1 || GetPVarType(playerid, "Tasered")) return SendClientMessage(playerid, GREY, "You cannot do this right now!");
			if(price < 0) return SendClientMessage(playerid, GREY, "The price must be a positive integer!");
			if(Player[playerid][MechanicTimer] != 0) return SendClientMessage(playerid, GREY, "You are already using your mechanic skills!");
			if(GetPVarType(playerid, "Offering")) return SendClientMessage(playerid, GREY, "You already have a pending offer. Type /cancel offer to reset it.");

			new vehicleid = GetClosestVehicle(playerid, 10.0);
			if(vehicleid != INVALID_VEHICLE_ID)
			{
				if(Fuel[vehicleid] == -1) return SendClientMessage(playerid, WHITE, "You cannot refill this vehicle!");
				new engine, lights, alarm, doors, bonnet, boot, objective;
            	GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);

            	if(id == playerid)
            	{
            		new fuel;
            		if(Player[playerid][JobSkill][1] >= 0 && Player[playerid][JobSkill][1] < 50) fuel = 1; 
					else if(Player[playerid][JobSkill][1] >= 50 && Player[playerid][JobSkill][1] < 100) fuel = 2;
					else if(Player[playerid][JobSkill][1] >= 100 && Player[playerid][JobSkill][1] < 200) fuel = 3;
					else if(Player[playerid][JobSkill][1] >= 200 && Player[playerid][JobSkill][1] < 400) fuel = 4;
					else if(Player[playerid][JobSkill][1] >= 400) fuel = 5;

					Fuel[vehicleid] += 2 * fuel;

					if(Fuel[vehicleid] > 100) Fuel[vehicleid] = 100;

					SetPVarInt(playerid, "MechanicTime", gettime() + 60);

            		format(Array, sizeof(Array), "{FF8000}** {C2A2DA}%s has refilled their vehicle.", GetName(playerid));
                	SendNearbyMessage(playerid, Array, PURPLE, 30.0);
            		return 1;
            	}
            	SetPVarInt(playerid, "Offering", 1);
            	SetPVarInt(id, "RefillID", playerid);
            	SetPVarInt(id, "RefillVehID", vehicleid);
            	SetPVarInt(id, "RefillPrice", price);

            	format(Array, sizeof(Array), "You have offered %s a refill for $%s.", GetName(id), FormatNumberToString(price));
  				SendClientMessage(playerid, LIGHTBLUE, Array);
				format(Array, sizeof(Array), "%s has offered to refill your vehicle for $%s, type /accept refill to accept it.", GetName(playerid), FormatNumberToString(price));
  				SendClientMessage(id, LIGHTBLUE, Array);
            }
            else return SendClientMessage(playerid, WHITE, "You are not near a vehicle!");
		}
	}
	else SendClientMessage(playerid, WHITE, "You are not a mechanic!");
	return 1;
}

forward RepairTimer(playerid, id, vehicleid);
public RepairTimer(playerid, id, vehicleid)
{
	if(!IsPlayerConnectedEx(id)) 
	{
		KillTimer(Player[playerid][MechanicTimer]);
		Player[playerid][MechanicTimer] = 0;
		return SendClientMessage(playerid, WHITE, "That player has disconnected");
	}

	if(IsPlayerInAnyVehicle(playerid))
	{
		KillTimer(Player[playerid][MechanicTimer]);
		Player[playerid][MechanicTimer] = 0;
		return SendClientMessage(playerid, WHITE, "You can't repair a vehicle from inside.");
	}

	switch(GetPVarInt(playerid, "RepairInt"))
	{
		case 0 .. 28:
		{
			if(GetVehicleModel(vehicleid) != 0)
			{
				new Float:Pos[3], engine, lights, alarm, doors, bonnet, boot, objective;
            	GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
				GetVehiclePos(vehicleid, Pos[0], Pos[1], Pos[2]);

				if(bonnet == VEHICLE_PARAMS_ON)
				{

					if(IsPlayerInRangeOfPoint(playerid, 15.0, Pos[0], Pos[1], Pos[2]))
					{
						Array[0] = 0;
						format(Array, sizeof(Array), "Repairing Vehicle...~n~%d seconds left.", 30 - GetPVarInt(playerid, "RepairInt"));
						SetPVarInt(playerid, "RepairInt", GetPVarInt(playerid, "RepairInt") + 1);
						GameTextForPlayer(playerid, Array, 1000, 4);
					}
					else 
					{
						KillTimer(Player[playerid][MechanicTimer]);
						Player[playerid][MechanicTimer] = 0;
						return SendClientMessage(playerid, WHITE, "You are no longer near that vehicle.");
					}
				}
				else
            	{
            		KillTimer(Player[playerid][MechanicTimer]);
            		Player[playerid][MechanicTimer] = 0;
		        	return SendClientMessage(playerid, WHITE, "The vehicle's hood must be opened.");
            	}
			}
			else 
			{
				KillTimer(Player[playerid][MechanicTimer]);
				Player[playerid][MechanicTimer] = 0;
				return SendClientMessage(playerid, WHITE, "You are no longer near that vehicle.");
			}
		}
		default:
		{
			new engine, lights, alarm, doors, bonnet, boot, objective;
            GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);

            if(bonnet == VEHICLE_PARAMS_ON)
            {
            	Array[0] = 0;
		        RepairVehicle(vehicleid);
			    SendClientMessage(playerid, WHITE, "You have repaired the vehicle.");

			    KillTimer(Player[playerid][MechanicTimer]);

			    Player[playerid][MechanicTimer] = 0;

			    GiveMoneyEx(playerid, -GetPVarInt(playerid, "RepairPrice"));
            	GiveMoneyEx(id, GetPVarInt(playerid, "RepairPrice"));

			    SetPVarInt(playerid, "MechanicTime", gettime() + 60);

			    format(Array, sizeof(Array), "{FF8000}** {C2A2DA}%s has repaired the vehicle.", GetName(playerid));
                SendNearbyMessage(playerid, Array, PURPLE, 30.0);

                DeletePVar(playerid, "RepairPrice");

                IncreaseJobSkill(playerid, 1, 2);
		    }
		    else
            {
            	KillTimer(Player[playerid][MechanicTimer]);
            	Player[playerid][MechanicTimer] = 0;
		        return SendClientMessage(playerid, WHITE, "The vehicle's hood must be opened.");
            }
		}
	}
	return 1;
}

forward ColourTimer(playerid, id, vehicleid, colour1, colour2);
public ColourTimer(playerid, id, vehicleid, colour1, colour2)
{
	if(!IsPlayerConnectedEx(id)) 
	{
		KillTimer(Player[playerid][MechanicTimer]);
		Player[playerid][MechanicTimer] = 0;
		return SendClientMessage(playerid, WHITE, "That player has disconnected");
	}

	if(IsPlayerInAnyVehicle(playerid))
	{
		KillTimer(Player[playerid][MechanicTimer]);
		Player[playerid][MechanicTimer] = 0;
		return SendClientMessage(playerid, WHITE, "You can't respray a vehicle from inside.");
	}

	if(GetPlayerWeapon(playerid) != 41) 
	{
		KillTimer(Player[playerid][MechanicTimer]);
		Player[playerid][MechanicTimer] = 0;
		return SendClientMessage(playerid, WHITE, "You must be holding a spraycan!");
	}

	switch(GetPVarInt(playerid, "ColourInt"))
	{
		case 0 .. 28:
		{
			if(GetVehicleModel(vehicleid) != 0)
			{
				new Float:Pos[3], engine, lights, alarm, doors, bonnet, boot, objective;
            	GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
				GetVehiclePos(vehicleid, Pos[0], Pos[1], Pos[2]);

				if(IsPlayerInRangeOfPoint(playerid, 15.0, Pos[0], Pos[1], Pos[2]))
				{
					Array[0] = 0;
					format(Array, sizeof(Array), "Respraying Vehicle...~n~%d seconds left.", 30 - GetPVarInt(playerid, "ColourInt"));
					SetPVarInt(playerid, "ColourInt", GetPVarInt(playerid, "ColourInt") + 1);
					GameTextForPlayer(playerid, Array, 1000, 4);
				}
				else 
				{
					KillTimer(Player[playerid][MechanicTimer]);
					Player[playerid][MechanicTimer] = 0;
					return SendClientMessage(playerid, WHITE, "You are no longer near that vehicle.");
				}
			}
			else 
			{
				KillTimer(Player[playerid][MechanicTimer]);
				Player[playerid][MechanicTimer] = 0;
				return SendClientMessage(playerid, WHITE, "You are no longer near that vehicle.");
			}
		}
		default:
		{
			new engine, lights, alarm, doors, bonnet, boot, objective;
            GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);

            Array[0] = 0;
		    RepairVehicle(vehicleid);
			SendClientMessage(playerid, WHITE, "You have resprayed the vehicle.");

			ChangeVehicleColor(vehicleid, colour1, colour2);

			new slot = GetPlayerVehicleSlot(id, vehicleid);
			PlayerVehicle[id][CarColour][slot] = colour1;
			PlayerVehicle[id][CarColour2][slot] = colour2;

			KillTimer(Player[playerid][MechanicTimer]);

			Player[playerid][MechanicTimer] = 0;

			GiveMoneyEx(playerid, -GetPVarInt(playerid, "ColourPrice"));
            GiveMoneyEx(id, GetPVarInt(playerid, "ColourPrice"));

			SetPVarInt(playerid, "MechanicTime", gettime() + 60);

			format(Array, sizeof(Array), "{FF8000}** {C2A2DA}%s has resprayed the vehicle.", GetName(playerid));
            SendNearbyMessage(playerid, Array, PURPLE, 30.0);

            DeletePVar(playerid, "ColourPrice");

            SavePlayerVehicleData(id, slot);

            IncreaseJobSkill(playerid, 1, 2);
		}
	}
	return 1;
}