#include <YSI\y_hooks>

CMD:cuff(playerid, params[])
{
	new id, unfrozen;
	if(sscanf(params, "uD", id, unfrozen))
	{
	    if(Group[Player[playerid][PlayerGroup]][GroupType] == 0 || Group[Player[playerid][PlayerGroup]][GroupType] == 1)
	    {
			SendClientMessage(playerid, WHITE, "SYNTAX: /cuff [playerid] [(optional) unfrozen]");
		}
		else return SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
	}
	else
	{
	    if(Group[Player[playerid][PlayerGroup]][GroupType] == 0 || Group[Player[playerid][PlayerGroup]][GroupType] == 1)
	    {
	    	if(IsPlayerConnectedEx(id))
	    	{
	    		if(playerid == id) return SendClientMessage(playerid, WHITE, "You cannot cuff yourself!");

	    		if(IsPlayerNearPlayer(playerid, id, 5.0))
	    		{
	    			if(GetPVarInt(id, "Cuffed")) return SendClientMessage(playerid, WHITE, "This player is already cuffed!");

	    			if(GetPlayerSpecialAction(id) == SPECIAL_ACTION_HANDSUP || GetPVarType(playerid, "Tasered"))
	    			{
	    				Array[0] = 0;
	    				SetPVarInt(id, "Cuffed", 1);
	    				DeletePVar(id, "Tasered");
	    				ClearAnimations(id, 1);

	    				SetPlayerSpecialAction(id, SPECIAL_ACTION_CUFFED);

	    				if(!unfrozen)
	    				{
	    					TogglePlayerControllableEx(id, FALSE);
	    					SetCameraBehindPlayer(id);
	    				}

	    				format(Array, sizeof(Array), "* %s takes out a pair of cuffs, securing them tightly on %s's wrists.", GetName(playerid), GetName(id));
	    				SendNearbyMessage(playerid, Array, SCRIPTPURPLE, 30.0);
	    			}
	    			else return SendClientMessage(playerid, WHITE, "This player does not have their hands up or has not been tased!");
	    		}
	    		else return SendClientMessage(playerid, WHITE, "You are not near that player!");
	    	}
	    	else return SendClientMessage(playerid, WHITE, "That player is not connected!");
	    }
	    else return SendClientMessage(playerid, WHITE, "You are not in a law enforcement group!");
	}
	return 1;
}

CMD:uncuff(playerid, params[])
{
	new id;
	if(sscanf(params, "u", id))
	{
	    if(Group[Player[playerid][PlayerGroup]][GroupType] == 0 || Group[Player[playerid][PlayerGroup]][GroupType] == 1)
	    {
			SendClientMessage(playerid, WHITE, "SYNTAX: /uncuff [playerid]");
		}
		else return SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
	}
	else
	{
	    if(Group[Player[playerid][PlayerGroup]][GroupType] == 0 || Group[Player[playerid][PlayerGroup]][GroupType] == 1)
	    {
	    	if(IsPlayerConnectedEx(id))
	    	{
	    		if(playerid == id) return SendClientMessage(playerid, WHITE, "You cannot uncuff yourself!");

	    		if(IsPlayerNearPlayer(playerid, id, 5.0))
	    		{
	    			if(!GetPVarInt(id, "Cuffed")) return SendClientMessage(playerid, WHITE, "This player is not cuffed!");
	    			else
	    			{
	    				Array[0] = 0;
	    				DeletePVar(id, "Cuffed");
	    				ClearAnimations(id, 1);
	    				SetPlayerSpecialAction(id, SPECIAL_ACTION_NONE);

						TogglePlayerControllableEx(id, TRUE);

	    				format(Array, sizeof(Array), "* %s uses a key to remove the cuffs from %s.", GetName(playerid), GetName(id));
	    				SendNearbyMessage(id, Array, SCRIPTPURPLE, 30.0);
	    			}
	    		}
	    		else return SendClientMessage(playerid, WHITE, "You are not near that player!");
	    	}
	    	else return SendClientMessage(playerid, WHITE, "That player is not connected!");
	    }
	    else return SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
	}
	return 1;
}

CMD:drag(playerid, params[]) // This command can also be used by medics.
{
	new id;
	if(sscanf(params, "u", id) && !GetPVarType(playerid, "Dragging"))
	{
	    if(Group[Player[playerid][PlayerGroup]][GroupType] == 0 || Group[Player[playerid][PlayerGroup]][GroupType] == 1 || Group[Player[playerid][PlayerGroup]][GroupType] == 3)
	    {
			SendClientMessage(playerid, WHITE, "SYNTAX: /drag [playerid]");
		}
		else return SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
	}
	else
	{
	    if(Group[Player[playerid][PlayerGroup]][GroupType] == 0 || Group[Player[playerid][PlayerGroup]][GroupType] == 1 || Group[Player[playerid][PlayerGroup]][GroupType] == 3)
	    {
	    	if(IsPlayerConnectedEx(id))
	    	{
	    		if(playerid == id) return SendClientMessage(playerid, WHITE, "You cannot drag yourself!");

	    		if(IsPlayerNearPlayer(playerid, id, 5.0))
	    		{
	    			if(!GetPVarInt(id, "Cuffed") && Group[Player[playerid][PlayerGroup]][GroupType] != 3) return SendClientMessage(playerid, WHITE, "This player is not cuffed!");
	    			if(Player[playerid][Injured] != 2 && Group[Player[playerid][PlayerGroup]][GroupType] == 3) return SendClientMessage(playerid, WHITE, "This player is not injured!");
	    			else
	    			{
	    				Array[0] = 0;
	    				if(GetPVarType(playerid, "Dragging"))
	    				{
	    					SetPVarInt(playerid, "Dragging", SetTimerEx("DragTimer", 1000, TRUE, "ii", playerid, id));

	    					if(Group[Player[playerid][PlayerGroup]][GroupType] != 3) format(Array, sizeof(Array), "* %s grabs ahold of %s and begins to move them.", GetName(playerid), GetName(id));
	    					else format(Array, sizeof(Array), "* %s places %s on a stretcher and begins to move them.", GetName(playerid), GetName(id));
	    					SendNearbyMessage(id, Array, SCRIPTPURPLE, 30.0);
	    					format(Array, sizeof(Array), "You have started dragging %s. Type /drag again to stop.", GetName(playerid), GetName(id));
	    				}
	    				else
	    				{
	    					KillTimer(GetPVarInt(playerid, "Dragging"));

	    					format(Array, sizeof(Array), "* %s has stopped moving %s.", GetName(playerid), GetName(id));
	    					SendNearbyMessage(id, Array, SCRIPTPURPLE, 30.0);
	    				}
	    			}
	    		}
	    		else return SendClientMessage(playerid, WHITE, "You are not near that player!");
	    	}
	    	else return SendClientMessage(playerid, WHITE, "That player is not connected!");
	    }
	    else return SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
	}
	return 1;
}

CMD:detain(playerid, params[]) // This command can also be used by medics.
{
	new id, seat;
	if(sscanf(params, "ud", id, seat))
	{
	    if(Group[Player[playerid][PlayerGroup]][GroupType] == 0 || Group[Player[playerid][PlayerGroup]][GroupType] == 1 || Group[Player[playerid][PlayerGroup]][GroupType] == 3)
	    {
			SendClientMessage(playerid, WHITE, "SYNTAX: /detain [playerid] [seat (1-3)]");
		}
		else return SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
	}
	else
	{
	    if(Group[Player[playerid][PlayerGroup]][GroupType] == 0 || Group[Player[playerid][PlayerGroup]][GroupType] == 1 || Group[Player[playerid][PlayerGroup]][GroupType] == 3)
	    {
	    	if(IsPlayerConnectedEx(id))
	    	{
	    		if(playerid == id) return SendClientMessage(playerid, WHITE, "You cannot detain yourself!");

	    		if(IsPlayerNearPlayer(playerid, id, 5.0))
	    		{
	    			new vehicle = GetClosestVehicle(playerid, 5.0), engine, lights, alarm, doors, bonnet, boot, objective;
	    			if(vehicle == INVALID_VEHICLE_ID) return SendClientMessage(playerid, WHITE, "You are not near a vehicle!");

	    			GetVehicleParamsEx(vehicle, engine, lights, alarm, doors, bonnet, boot, objective);
					if(doors == VEHICLE_PARAMS_UNSET || doors == VEHICLE_PARAMS_OFF)
					{
		    			if(!GetPVarInt(id, "Cuffed") && Group[Player[playerid][PlayerGroup]][GroupType] != 3) return SendClientMessage(playerid, WHITE, "This player is not cuffed!");
	    				if(Player[playerid][Injured] != 2 && Group[Player[playerid][PlayerGroup]][GroupType] == 3) return SendClientMessage(playerid, WHITE, "This player is not injured!");
		    			else
		    			{
		    				if(seat < 1 || seat > 3 || CheckVehicleSeats(vehicle, seat)) return SendClientMessage(playerid, WHITE, "You entered an invalid seat number.");
		    				if(IsPlayerInAnyVehicle(id)) return SendClientMessage(playerid, WHITE, "This player is already in a vehicle.");
		    				Array[0] = 0;
		    				PutPlayerInVehicle(playerid, vehicle, seat);

		    				format(Array, sizeof(Array), "* %s has placed %s inside the vehicle.", GetName(playerid), GetName(id));
		    				SendNearbyMessage(id, Array, SCRIPTPURPLE, 30.0);
		    			}
		    		}
		    		else return SendClientMessage(playerid, WHITE, "This vehicle is locked!");
	    		}
	    		else return SendClientMessage(playerid, WHITE, "You are not near that player!");
	    	}
	    	else return SendClientMessage(playerid, WHITE, "That player is not connected!");
	    }
	    else return SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
	}
	return 1;
}

CMD:arrest(playerid, params[])
{
	if(Player[playerid][PlayerGroup] > -1)
	{
		if(Group[Player[playerid][PlayerGroup]][GroupType] == 0 || Group[Player[playerid][PlayerGroup]][GroupType] == 1)
		{
			new id, time, fine;
			if(sscanf(params, "udd", id, time, fine)) 
			{
				SendClientMessage(playerid, WHITE, "SYNTAX: /arrest [playerid] [time] [fine]");
				if(Group[Player[playerid][PlayerGroup]][GroupType] == 0) return SendClientMessage(playerid, GREY, "Time: You can prison from 5 up to 30 minutes. | Fine: You can fine from 0 up to $5,000");
				else if(Group[Player[playerid][PlayerGroup]][GroupType] == 1) return SendClientMessage(playerid, GREY, "Time: You can prison from 5 up to 60 minutes. | Fine: You can fine from 0 up to $15,000");
				else return 1;
			}
			else
			{
				if(IsPlayerConnectedEx(id))
				{
					if(IsPlayerNearPlayer(playerid, id, 8.0))
					{
						for(new i; i < MAX_ARRESTPOINTS; i++)
						{
							if(IsPlayerInRangeOfPoint(playerid, 5.0, Arrest[i][ArrestPos][0], Arrest[i][ArrestPos][1], Arrest[i][ArrestPos][2]))
							{
								if(Player[id][Crimes] > 0)
								{
									if(playerid == id) return SendClientMessage(playerid, WHITE, "You cannot arrest yourself!");

									if(!GetPVarInt(id, "Cuffed")) return SendClientMessage(playerid, WHITE, "This player is not cuffed!");
	    							else
	    							{
	    								switch(Group[Player[playerid][PlayerGroup]][GroupType])
	    								{
	    									case 0: 
	    									{
	    										if(time < 5 || time > 30) return SendClientMessage(playerid, WHITE, "You can not give someone less than five minutes in jail or more than thirty.");
	    										if(fine < 0 || fine > 5000) return SendClientMessage(playerid, WHITE, "You can not fine someone for less than zero dollars, or more than five thousand.");
	    									}
	    									case 1: 
	    									{
	    										if(time < 5 || time > 60) return SendClientMessage(playerid, WHITE, "You can not give someone less than five minutes in jail or more than sixty.");
	    										if(fine < 0 || fine > 5000) return SendClientMessage(playerid, WHITE, "You can not fine someone for less than zero dollars, or more than fifteen thousand.");
	    									}
	    									default: return 1;
	    								}
	    								Array[0] = 0;
	    								DeletePVar(id, "Cuffed");
	    								ClearAnimations(id, 1);
	    								SetPlayerSpecialAction(id, SPECIAL_ACTION_NONE);

										TogglePlayerControllableEx(id, TRUE);

										ArrestPlayer(id, playerid, time, fine, Group[Player[playerid][PlayerGroup]][GroupType]);

										DisableCrimes(id);

	    								format(Array, sizeof(Array), "%s %s has arrested %s for %d minutes with a $%s fine.", GroupRankNames[Player[playerid][PlayerGroup]][Player[playerid][GroupRank]], GetName(playerid), GetName(id), time, FormatNumberToString(fine));
	    								SendGroupMessage(Player[playerid][PlayerGroup], Array, DEFAULT);

	    								Log(16, Array, Player[playerid][PlayerGroup]);

	    								Player[id][Crimes] = 0;
	    								Player[id][TotalArrests]++;
	    								SetPlayerWantedLevel(playerid, 0);
	    								return 1;
	    							}
	    						}
	    						else return SendClientMessage(playerid, WHITE, "This player does not have any active charges.");
	    					}
	    				}
	    				return SendClientMessage(playerid, WHITE, "You are not near an arrest point");
					}
					else return SendClientMessage(playerid, WHITE, "You are not near that player.");
				}
				else return SendClientMessage(playerid, WHITE, "That player is not connected.");
			}
		}
		else return SendClientMessage(playerid, WHITE, "You are not in a law enforcment agency.");
	}
	else SendClientMessage(playerid, WHITE, "You are not in a law enforcment agency.");
	return 1;
}

CMD:charge(playerid, params[])
{
	if(Player[playerid][PlayerGroup] > -1)
	{
		if(Group[Player[playerid][PlayerGroup]][GroupType] == 0 || Group[Player[playerid][PlayerGroup]][GroupType] == 1)
		{
			new id;
			if(sscanf(params, "u", id)) 
			{
				return SendClientMessage(playerid, WHITE, "SYNTAX: /charge [playerid]");
			}
			else
			{
				if(IsPlayerConnectedEx(id))
				{
					DeletePVar(playerid, "EmptyCrime");
					SetPVarInt(playerid, "Charging", id);
					Array[0] = 0;
					for(new i; i < MAX_CRIMES; i++) { if(strfind(Crime[i][CrimeName], "empty", true) == -1) format(Array, sizeof(Array), "%s\n%s", Array, Crime[i][CrimeName]); }
					return ShowPlayerDialog(playerid, DIALOG_CRIMELIST, DIALOG_STYLE_LIST, "Crime List - Charging", Array, "Select", "Cancel");
				}
				else return SendClientMessage(playerid, WHITE, "This player is not connected.");
			}
		}
		else return SendClientMessage(playerid, WHITE, "You are not in a law enforcement agency.");
	}
	else SendClientMessage(playerid, WHITE, "You are not in a law enforcement agency.");
	return 1;
}

CMD:find(playerid, params[])
{
	if(Player[playerid][PlayerGroup] > -1)
	{
		if(Group[Player[playerid][PlayerGroup]][GroupType] == 0 || Group[Player[playerid][PlayerGroup]][GroupType] == 1)
		{
			new id;
			if(sscanf(params, "u", id)) 
			{
				return SendClientMessage(playerid, WHITE, "SYNTAX: /find [playerid]");
			}
			else 
			{
				switch(GetPVarType(playerid, "Finding"))
				{
					case 0:
					{
						if(!IsPlayerConnectedEx(id)) return SendClientMessage(playerid, WHITE, "That player is not connected!");
						//if(Player[playerid][PhoneToggled] == 1) return SendClientMessage(playerid, WHITE, "That player's phone is off!");
						if(GetPVarInt(playerid, "Cuffed") >= 1 || GetPVarType(playerid, "Tasered")) return SendClientMessage(playerid, GREY, "You cannot do this right now!");
						if(id == playerid) return SendClientMessage(playerid, WHITE, "You cannot trace yourself!");

						if(GetPlayerInterior(id) == 0 && GetPlayerVirtualWorld(id) == 0)
						{
							if(GetPVarInt(playerid, "Checkpoint") >= 1) return SendClientMessage(playerid, WHITE, "You already have an active checkpoint. Reach it, or type /killcheckpoint to clear it.");
							
							new Float:Pos[3];
							GetPlayerPos(id, Pos[0], Pos[1], Pos[2]);

							SetPlayerCheckpointEx(playerid, Pos[0], Pos[1], Pos[2], 4.0);

							new location[50];
							GetPlayer3DZone(id, location, 50);

							SendClientMessage(playerid, WHITE, "You've began a trace.");
							format(Array, sizeof(Array), "%s has last been seen in: %s.", GetName(id), location);
							SendClientMessage(playerid, GREY, Array);

							SetPVarInt(playerid, "Finding", SetTimerEx("FindUpdate", 1000, TRUE, "ii", playerid, id)); 
						}
						else return SendClientMessage(playerid, WHITE, "The signal is to weak to trace.");
					}
					default:
					{
						SendClientMessage(playerid, WHITE, "You have canceled the trace.");
						KillTimer(GetPVarInt(playerid, "Finding"));
						DeletePVar(playerid, "Finding");
						DisablePlayerCheckpointEx(playerid);
					}
				}
			}
		}
		else return SendClientMessage(playerid, WHITE, "You are not in a law enforcement agency.");
	}
	else SendClientMessage(playerid, WHITE, "You are not in a law enforcement agency.");
	return 1;
}

CMD:taser(playerid, params[])
{
	if(Player[playerid][PlayerGroup] > -1)
	{
		if(Group[Player[playerid][PlayerGroup]][GroupType] == 0 || Group[Player[playerid][PlayerGroup]][GroupType] == 1)
		{
			if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, WHITE, "You cannot do this while being in a vehicle!");

			Array[0] = 0;
			switch(Player[playerid][Taser])
			{
				case 0: // Holstered.
				{
					ResetPlayerWeapons(playerid);
					GivePlayerWeapon(playerid, 23, 99999);

					format(Array, sizeof(Array), "* %s unholsters their taser.", GetName(playerid));
	    			SendNearbyMessage(playerid, Array, SCRIPTPURPLE, 30.0);
					Player[playerid][Taser] = 1;
				}
				default: // Unholstered.
				{
					ResetPlayerWeapons(playerid);
					GivePlayerSavedWeapons(playerid);
					format(Array, sizeof(Array), "* %s holsters their taser.", GetName(playerid));
	    			SendNearbyMessage(playerid, Array, SCRIPTPURPLE, 30.0);

					Player[playerid][Taser] = 0;
				}
			}
		}
		else return SendClientMessage(playerid, WHITE, "You are not in a law enforcement agency.");
	}
	else SendClientMessage(playerid, WHITE, "You are not in a law enforcement agency.");
	return 1;
}

CMD:tow(playerid, params[])
{
    if(Player[playerid][PlayerGroup] > -1)
	{
		if(Group[Player[playerid][PlayerGroup]][GroupType] == 0 || Group[Player[playerid][PlayerGroup]][GroupType] == 1)
		{
	        if(IsPlayerInAnyVehicle(playerid))
	        {
				new vehicle = GetPlayerVehicleID(playerid);
				if(GetVehicleModel(vehicle) == 525)
				{
					new VehicleToTow =  GetClosestVehicle(playerid, 8.0, .excludeinvehicle = 1);
					if(VehicleToTow != INVALID_VEHICLE_ID)
					{
						if(!IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
						{
	                        if(IsAPlane(VehicleToTow) || IsABike(VehicleToTow) || IsATrain(VehicleToTow) || IsAHelicopter(VehicleToTow)) return SendClientMessage(playerid, WHITE, "You can not tow this type of vehicle.");
	                        AttachTrailerToVehicle(VehicleToTow, GetPlayerVehicleID(playerid));                    
						}
						else DetachTrailerFromVehicle(GetPlayerVehicleID(playerid));
					}
					else return SendClientMessage(playerid, WHITE, "You are not near a vehicle!");
				}
				else return SendClientMessage(playerid, WHITE, "You are not in a tow truck!");
	        }
	        else return SendClientMessage(playerid, WHITE, "You are not in a tow truck!");
	    }
	    else return SendClientMessage(playerid, WHITE, "You are not in a law enforcement agency.");
    }
    else SendClientMessage(playerid, WHITE, "You are not in a law enforcement agency.");
	return 1;
}

CMD:mdc(playerid, params[])
{
	if(Player[playerid][PlayerGroup] > -1)
	{
		if(Group[Player[playerid][PlayerGroup]][GroupType] == 0 || Group[Player[playerid][PlayerGroup]][GroupType] == 1)
		{
			if(IsPlayerInAnyVehicle(playerid))
			{
				new vehicle = GetPlayerVehicleID(playerid), id = GetRealVehicleID(vehicle);

				if(Vehicle[id][Model] == 0) return SendClientMessage(playerid, WHITE, "You need to be in one of your group's vehicles to do this.");
				else ShowPlayerDialog(playerid, DIALOG_MDC, DIALOG_STYLE_LIST, "Mobile Database Computer", "Civilian Information\nWarrants\nBackup Calls", "Select", "Cancel");
			}
			else return SendClientMessage(playerid, WHITE, "You need to be in one of your group's vehicles to do this.");
		}
		else return SendClientMessage(playerid, WHITE, "You are not in a law enforcement agency.");
	}
	else SendClientMessage(playerid, WHITE, "You are not in a law enforcement agency.");
	return 1;
}

CMD:wanted(playerid, params[])
{
	if(Player[playerid][PlayerGroup] > -1)
	{
		if(Group[Player[playerid][PlayerGroup]][GroupType] == 0 || Group[Player[playerid][PlayerGroup]][GroupType] == 1)
		{
			SendClientMessage(playerid, GREY, "---------------------------------------------------------------------------------------------------------------------------");

			new total[2];
			Array[0] = 0;
			foreach(new i: Player)
			{
				if(Player[i][Crimes] > 0) 
				{
					if(total[0] > 3) total[0] = 0;

					format(Array, sizeof(Array), "%s%s (%d) ", Array, GetName(i), Player[i][Crimes]);
					total[0]++;
					total[1]++;

					if(total[0] > 3) SendClientMessage(playerid, WHITE, Array);
				}
			}
			if(total[1] > 0) SendClientMessage(playerid, WHITE, Array);
			else SendClientMessage(playerid, DARKGREY, "There are currently no wanted suspects online.");

			SendClientMessage(playerid, GREY, "---------------------------------------------------------------------------------------------------------------------------");
		}
		else return SendClientMessage(playerid, WHITE, "You are not in a law enforcement agency.");
	}
	else SendClientMessage(playerid, WHITE, "You are not in a law enforcement agency.");
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case DIALOG_CRIMELIST:
		{
			if(!response) return 1;
			switch(listitem)
			{
				case 0 .. MAX_CRIMES:
				{
					new id = GetPVarInt(playerid, "Charging");
					if(IsPlayerConnectedEx(id))
					{
						Array[0] = 0;

						Player[id][TotalCrimes]++;
						Player[id][Crimes]++;

						format(Array, sizeof(Array), "You have been charged with a crime: %s, by the %s. (( %s ))", Crime[listitem][CrimeName], Group[Player[playerid][PlayerGroup]][GroupName], GetName(playerid));
						SendClientMessage(id, LIGHTRED, Array);

						format(Array, sizeof(Array), "%s has been charged with a crime: %s, by %s", GetName(id), Crime[listitem][CrimeName], GetName(playerid));
	    				SendGroupMessage(Player[playerid][PlayerGroup], Array, Group[Player[playerid][PlayerGroup]][GroupColour] * 256 + 255);

	    				SetPlayerWantedLevel(id, GetPlayerWantedLevel(id) + 1);

	    				AddCrime(id, playerid, Crime[listitem][CrimeName], Player[playerid][PlayerGroup]);

	    				Log(16, Array, Player[playerid][PlayerGroup]);
	    			}
	    			else return SendClientMessage(playerid, WHITE, "That player is not connected!");
				}
			}
		}
		case DIALOG_MDC:
		{
			if(!response) return 1;
			if(Player[playerid][PlayerGroup] == -1 && Group[Player[playerid][PlayerGroup]][GroupType] != 0 && Group[Player[playerid][PlayerGroup]][GroupType] != 1) return SendClientMessage(playerid, WHITE, "You are not in a law enforcement agency.");

			switch(listitem)
			{
				case 0: ShowPlayerDialog(playerid, DIALOG_MDC_CIVINFO, DIALOG_STYLE_INPUT, "Mobile Database Computer - Civilian Information", "Please enter the ID or the full name of the person you would like to search.", "Select", "Cancel");
				case 1: return cmd_wanted(playerid, "");
				case 2: return cmd_backupcalls(playerid, "");
			}
		}
		case DIALOG_MDC_CIVINFO: 
		{
			if(!response) return 1;
			if(Player[playerid][PlayerGroup] == -1 && Group[Player[playerid][PlayerGroup]][GroupType] != 0 && Group[Player[playerid][PlayerGroup]][GroupType] != 1) return SendClientMessage(playerid, WHITE, "You are not in a law enforcement agency.");

			new id;
			if(sscanf(inputtext, "u", id)) return ShowPlayerDialog(playerid, DIALOG_MDC_CIVINFO, DIALOG_STYLE_INPUT, "Mobile Database Computer - Civilian Information", "Please enter the ID or the full name of the person you would like to search.", "Select", "Cancel");
			else 
			{
				if(id == -1) return SendClientMessage(playerid, WHITE, "This player is not connected.");
				if(!IsPlayerConnectedEx(id)) return SendClientMessage(playerid, WHITE, "This player is not connected.");

				ShowPlayerDialog(playerid, DIALOG_MDC_CIVINFO2, DIALOG_STYLE_LIST, "Mobile Database Computer - Civilian Information", "Licenses\nRecord\nVehicles\nAdd Charge\nAdd Ticket\nClear Charges", "Select", "Cancel");
				SetPVarInt(playerid, "CivlianInformation", id);
			}
		}
		case DIALOG_MDC_CIVINFO2:
		{
			if(!response) return 1;
			if(Player[playerid][PlayerGroup] == -1 && Group[Player[playerid][PlayerGroup]][GroupType] != 0 && Group[Player[playerid][PlayerGroup]][GroupType] != 1) return SendClientMessage(playerid, WHITE, "You are not in a law enforcement agency.");

			if(GetPVarInt(playerid, "CivilianInformation") == -1) return SendClientMessage(playerid, WHITE, "This player is not connected.");
			if(!IsPlayerConnectedEx(GetPVarInt(playerid, "CivilianInformation"))) return SendClientMessage(playerid, WHITE, "This player is not connected.");

			switch(listitem)
			{
				case 0: SendClientMessage(playerid, WHITE, "Licenses are still in work.");
				case 1:
				{
					Array[0] = 0;
					mysql_format(SQL, Array, 256, "SELECT * FROM `issuedcrimes` WHERE `player` = '%d'", Player[GetPVarInt(playerid, "CivilianInformation")][DatabaseID]);
					mysql_tquery(SQL, Array, "OnCrimeLookup", "ii", playerid, GetPVarInt(playerid, "CivilianInformation")); 
				}
				case 2:
				{
					SendClientMessage(playerid, GREY, "---------------------------------------------------------------------------------------------------------------------------");
					Array[0] = 0;
					new vehiclestring[MAX_PLAYER_VEHICLES][50];

					for(new i; i < MAX_PLAYER_VEHICLES; i++)
					{
						if(PlayerVehicle[GetPVarInt(playerid, "CivilianInformation")][CarModel][i] > 0) format(vehiclestring[i], 50, "%s", VehicleNames[PlayerVehicle[GetPVarInt(playerid, "CivilianInformation")][CarModel][i] - 400]);
						else format(vehiclestring[i], 50, "Nothing");
					}

					format(Array, sizeof(Array), "%s (%s), %s (%s), %s (%s), %s (%s), %s (%s)", vehiclestring[0], PlayerVehicle[playerid][CarPlate1], vehiclestring[1], PlayerVehicle[playerid][CarPlate2], vehiclestring[2], PlayerVehicle[playerid][CarPlate3], vehiclestring[3], PlayerVehicle[playerid][CarPlate4], vehiclestring[4], PlayerVehicle[playerid][CarPlate5]);
					SendClientMessage(playerid, WHITE, Array);
					SendClientMessage(playerid, GREY, "---------------------------------------------------------------------------------------------------------------------------");
				}
				case 3: 
				{
					new id[3];
					valstr(id, GetPVarInt(playerid, "CivilianInformation"));

					return cmd_charge(playerid, id);
				}
				case 4: return 1; //return cmd_ticket(playerid, GetPVarInt(playerid, "CivilianInformation"));
				case 5:
				{
					if(Group[Player[playerid][PlayerGroup]][GroupType] == 1) // Law Enforcement (IA)
					{
						Array[0] = 0;
						DisableCrimes(GetPVarInt(playerid, "CivilianInformation"));

						format(Array, sizeof(Array), "%s %s %s (%s) has cleared %s's charges.", Group[Player[playerid][PlayerGroup]][GroupName], GroupRankNames[Player[playerid][PlayerGroup]][Player[playerid][GroupRank]], GetName(playerid), GroupDivisionNames[Player[playerid][PlayerGroup]][Player[playerid][GroupDiv]], GetName(GetPVarInt(playerid, "CivilianInformation")));
						foreach(new i: Player)
			            {
			                if(Group[Player[i][PlayerGroup]][GroupType] == 0 || Group[Player[i][PlayerGroup]][GroupType] == 1) SendClientMessage(i, LIGHTRED, Array);
			            }

			            format(Array, sizeof(Array), "[CLEAR CHARGES] %s", Array);
			            Log(10, Array);
					}
					else return SendClientMessage(playerid, WHITE, "You are not in a law enforcment (IA) group!");
				}
			}
		}
	}
	return 1;
}

forward OnCrimeLookup(playerid, id);
public OnCrimeLookup(playerid, id) 
{ 
	Array[0] = 0;
	new row, rows, fields, issuer[MAX_PLAYER_NAME], crime[256], group[256], time[30], active;
    
    cache_get_data(rows, fields);

    while(row < rows)
    {
    	cache_get_field_content(row, "issuer", issuer, SQL, MAX_PLAYER_NAME);
    	cache_get_field_content(row, "crime", crime, SQL, sizeof(crime));
    	cache_get_field_content(row, "group", group, SQL, sizeof(group));
    	cache_get_field_content(row, "time", time, SQL, sizeof(time));

    	active = cache_get_field_content_int(row, "active", SQL);

    	if(active == 0) format(Array, sizeof(Array), "\n{A9C4E4}\t[%s] - %s - Issuer: %s (%s)%s", time, crime, issuer, group, Array);
    	else format(Array, sizeof(Array), "\n{EB9B9B}\t[%s] - %s - Issuer: %s (%s)%s", time, crime, issuer, group, Array);
    	row++;
    }
    if(row == 0) format(Array, sizeof(Array), "\n\tThey currently do not have any crimes.", Array, time, crime, issuer, group);

    format(Array, sizeof(Array), "{FFFFFF}Name: %s\nActive Charges: %d\nTotal Charges: %d\nTotal Arrests: %d\n%s\n\n{FFFFFF}Legend: {EB9B9B}Active Charge{FFFFFF}, {A9C4E4}Inactive Charge.", GetName(id), Player[playerid][Crimes], Player[playerid][TotalCrimes], Player[playerid][TotalArrests], Array);
    ShowPlayerDialog(playerid, DIALOG_DEFAULT, DIALOG_STYLE_MSGBOX, "Check Record", Array, "Finish", "");
}

AddCrime(playerid, issuer, crime[], group)
{
	new Query[550];
	mysql_format(SQL, Query, sizeof(Query), "INSERT INTO `issuedcrimes` (`player`, `issuer`, `crime`, `group`, `active`) VALUES ('%d', '%e', '%e', '%e', '1')", Player[playerid][DatabaseID], GetName(issuer), crime, Group[group][GroupName]);
	mysql_tquery(SQL, Query, "", "");
	return 1;
}

DisableCrimes(playerid)
{
	Array[0] = 0;
	mysql_format(SQL, Array, sizeof(Array), "UPDATE `issuedcrimes` SET `active` = '0' WHERE `player` = '%d'", Player[playerid][DatabaseID]);
	mysql_tquery(SQL, Array, "", "");
	return 1;
}

ArrestPlayer(playerid, arrester, time, fine, type)
{
	switch(type)
	{
		case 0:
		{
			new rand = random(sizeof(PrisonLSPD));

			SetPlayerPosEx(playerid, PrisonLSPD[rand][0], PrisonLSPD[rand][1], PrisonLSPD[rand][2], 0.0, 1, 0);
			Player[playerid][JailTime] = time * 60;
			Player[playerid][ArrestedBy] = Player[arrester][DatabaseID];

			GiveMoneyEx(playerid, -fine);
			Group[Player[arrester][PlayerGroup]][GroupMoney] += fine;
		}
	}
	PrepareStream(playerid);
	return 1;
}