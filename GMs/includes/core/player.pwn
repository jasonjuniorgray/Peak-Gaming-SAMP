#include <YSI\y_hooks>

CMD:stats(playerid, params[])
{
	ShowStatistics(playerid, playerid);
	return 1;
}

CMD:drop(playerid, params[])
{
    if(IsPlayerConnectedEx(playerid)) 
    {
        if(isnull(params)) 
        {
            SendClientMessage(playerid, WHITE, "SNYTAX: /drop [usage]");
            SendClientMessage(playerid, GREY, "Usages: weapon, weapons, phone");
            return 1;
        }
        if(strcmp(params, "weapon", true) == 0)
		{
			Array[0] = 0;
			new weaponname[16];
			for(new i; i < 12; i++)
			{
				if(Player[playerid][Weapon][i] > 0)
				{
					GetWeaponName(Player[playerid][Weapon][i], weaponname, 16);
					format(Array, sizeof(Array), "%s\n%s (%d)", Array, weaponname, Player[playerid][Weapon][i]);
				}
			}
			ShowPlayerDialog(playerid, DIALOG_DROPWEAPON, DIALOG_STYLE_LIST, "Drop Weapon", Array, "Select", "Cancel");
		}
		if(strcmp(params, "weapons", true) == 0)
		{
			Array[0] = 0;
			new drop;
			for(new i; i < 12; i++)
			{
				if(Player[playerid][Weapon][i] > 0) 
				{
					Player[playerid][Weapon][i] = 0;
					drop++;
				}
			}
			if(drop > 0)
			{
				format(Array, sizeof(Array), "{FF8000}** {C2A2DA}%s has dropped their weapons.", GetName(playerid)); 
				SendNearbyMessage(playerid, Array, PURPLE, 30.0);
			}
		}
		if(strcmp(params, "phone", true) == 0)
		{
			Array[0] = 0;
			if(Player[playerid][PhoneNumber] > 0)
			{
				Player[playerid][PhoneNumber] = 0;
				format(Array, sizeof(Array), "{FF8000}** {C2A2DA}%s has dropped their phone.", GetName(playerid)); 
				SendNearbyMessage(playerid, Array, PURPLE, 30.0);
			}
			else return SendClientMessage(playerid, WHITE, "You do not have a phone!");
		}
    }
    return 1;
}

CMD:accept(playerid, params[])
{
    if(IsPlayerConnectedEx(playerid)) 
    {
        if(isnull(params)) 
        {
            SendClientMessage(playerid, WHITE, "SNYTAX: /accept [name]");
            SendClientMessage(playerid, GREY, "Names: gun, repair, respray, refill, ticket");
            return 1;
        }
		if(strcmp(params, "gun", true) == 0)
		{
			Array[0] = 0;
			if(GetPVarInt(playerid, "Cuffed") >= 1 || GetPVarType(playerid, "Tasered")) return SendClientMessage(playerid, GREY, "You cannot do this right now!");
			if(!GetPVarType(playerid, "SellGunID") || GetPVarInt(playerid, "SellGunID") == INVALID_PLAYER_ID) return SendClientMessage(playerid, GREY, "No one has offered you a gun!");

			new id = GetPVarInt(playerid, "SellGunID");

			if(!GetPVarType(id, "Offering") || GetPVarInt(id, "Offering") == INVALID_PLAYER_ID || GetPVarInt(id, "Offering") != playerid) return SendClientMessage(playerid, GREY, "The seller has canceled the offer!");

			if(Player[id][Materials] < GetPVarInt(playerid, "SellGunMats")) 
			{
				SendClientMessage(id, WHITE, "You do not have enough materials to sell this item!");
				return SendClientMessage(playerid, WHITE, "The seller no longer has enough materials to sell this item!");
			}

			new weapon[16];
			GetWeaponName(GetPVarInt(playerid, "SellGun"), weapon, sizeof(weapon));

			Player[id][Materials] -= GetPVarInt(playerid, "SellGunMats");
			GivePlayerWeaponEx(playerid, GetPVarInt(playerid, "SellGun"));

			format(Array, sizeof(Array), "{FF8000}** {C2A2DA}%s crafts a %s from their materials, handing it to %s.", GetName(id), weapon, GetName(playerid)); 
			SendNearbyMessage(playerid, Array, PURPLE, 30.0);

			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0); // Just a little 'classic' feel to it. -Jason
			PlayerPlaySound(id, 1052, 0.0, 0.0, 0.0);

			DeletePVar(playerid, "pSellGun");
			DeletePVar(playerid, "pSellGunID");
			DeletePVar(playerid, "pSellGunMats");
		}
		else if(strcmp(params, "repair", true) == 0)
		{
			Array[0] = 0;
			if(GetPVarInt(playerid, "Cuffed") >= 1 || GetPVarType(playerid, "Tasered")) return SendClientMessage(playerid, GREY, "You cannot do this right now!");
			if(!GetPVarType(playerid, "RepairID") || GetPVarInt(playerid, "RepairID") == INVALID_PLAYER_ID) return SendClientMessage(playerid, GREY, "No one has offered you a repair!");

			new id = GetPVarInt(playerid, "RepairID");

			if(!GetPVarType(id, "Offering") || GetPVarInt(id, "Offering") == INVALID_PLAYER_ID || GetPVarInt(id, "Offering") != playerid) return SendClientMessage(playerid, GREY, "The seller has canceled the offer!");

			SetPVarInt(id, "RepairInt", 1);
            Player[id][MechanicTimer] = SetTimerEx("RepairTimer", 1000, TRUE, "iii", id, playerid, GetPVarInt(playerid, "RepairVehID"));

            format(Array, sizeof(Array), "{FF8000}** {C2A2DA}%s has started to repair the vehicle.", GetName(playerid));
            SendNearbyMessage(playerid, Array, PURPLE, 30.0);

            SendClientMessage(playerid, WHITE, "You are now repairing the vehicle. Do not go to far away from it, or inside any other vehicle!");

			DeletePVar(playerid, "RepairID");
			DeletePVar(playerid, "RepairVehID");
		}
		else if(strcmp(params, "respray", true) == 0)
		{
			Array[0] = 0;
			if(GetPVarInt(playerid, "Cuffed") >= 1 || GetPVarType(playerid, "Tasered")) return SendClientMessage(playerid, GREY, "You cannot do this right now!");
			if(!GetPVarType(playerid, "ColourID") || GetPVarInt(playerid, "ColourID") == INVALID_PLAYER_ID) return SendClientMessage(playerid, GREY, "No one has offered you a respray!");

			new id = GetPVarInt(playerid, "ColourID");

			if(!GetPVarType(id, "Offering") || GetPVarInt(id, "Offering") == INVALID_PLAYER_ID || GetPVarInt(id, "Offering") != playerid) return SendClientMessage(playerid, GREY, "The seller has canceled the offer!");

			SetPVarInt(id, "ColourInt", 1);
            Player[id][MechanicTimer] = SetTimerEx("ColourTimer", 1000, TRUE, "iiiii", id, playerid, GetPVarInt(playerid, "ColourVehID"), GetPVarInt(playerid, "Colour1"), GetPVarInt(playerid, "Colour2"));

            format(Array, sizeof(Array), "{FF8000}** {C2A2DA}%s has started to respray the vehicle.", GetName(id));
            SendNearbyMessage(id, Array, PURPLE, 30.0);

            SendClientMessage(id, WHITE, "You are now spraying the vehicle. Do not go to far away from it, inside any other vehicle, and do not put your spraycan away!");

			DeletePVar(playerid, "ColourID");
			DeletePVar(playerid, "Colour1");
			DeletePVar(playerid, "Colour2");
			DeletePVar(playerid, "ColourVehID");
		}
		else if(strcmp(params, "refill", true) == 0)
		{
			Array[0] = 0;
			if(GetPVarInt(playerid, "Cuffed") >= 1 || GetPVarType(playerid, "Tasered")) return SendClientMessage(playerid, GREY, "You cannot do this right now!");
			if(!GetPVarType(playerid, "RefillID") || GetPVarInt(playerid, "RefillID") == INVALID_PLAYER_ID) return SendClientMessage(playerid, GREY, "No one has offered you a refill!");

			new id = GetPVarInt(playerid, "RefillID"), fuel;

			if(!GetPVarType(id, "Offering") || GetPVarInt(id, "Offering") == INVALID_PLAYER_ID || GetPVarInt(id, "Offering") != playerid) return SendClientMessage(playerid, GREY, "The seller has canceled the offer!");

			if(Player[id][JobSkill][1] >= 0 && Player[id][JobSkill][1] < 50) fuel = 1; 
			else if(Player[id][JobSkill][1] >= 50 && Player[id][JobSkill][1] < 100) fuel = 2;
			else if(Player[id][JobSkill][1] >= 100 && Player[id][JobSkill][1] < 200) fuel = 3;
			else if(Player[id][JobSkill][1] >= 200 && Player[id][JobSkill][1] < 400) fuel = 4;
			else if(Player[id][JobSkill][1] >= 400) fuel = 5;

			Fuel[GetPVarInt(playerid, "RefillVehID")] += 2 * fuel;

			if(Fuel[GetPVarInt(playerid, "RefillVehID")] > 100) Fuel[GetPVarInt(playerid, "RefillVehID")] = 100;

            format(Array, sizeof(Array), "{FF8000}** {C2A2DA}%s has refilled their vehicle.", GetName(id));
            SendNearbyMessage(playerid, Array, PURPLE, 30.0);

            GiveMoneyEx(playerid, -GetPVarInt(playerid, "RefillPrice"));
            GiveMoneyEx(id, GetPVarInt(playerid, "RefillPrice"));

            SetPVarInt(id, "MechanicTime", gettime() + 60);

			DeletePVar(playerid, "RefillID");
			DeletePVar(playerid, "RefillVehID");
			DeletePVar(playerid, "RefillPrice");
		}
		else if(strcmp(params, "guard", true) == 0)
		{
			Array[0] = 0;
			if(GetPVarInt(playerid, "Cuffed") >= 1 || GetPVarType(playerid, "Tasered")) return SendClientMessage(playerid, GREY, "You cannot do this right now!");
			if(!GetPVarType(playerid, "GuardID") || GetPVarInt(playerid, "GuardID") == INVALID_PLAYER_ID) return SendClientMessage(playerid, GREY, "No one has offered you a guard!");

			new id = GetPVarInt(playerid, "GuardID");

			if(!GetPVarType(id, "Offering") || GetPVarInt(id, "Offering") == INVALID_PLAYER_ID || GetPVarInt(id, "Offering") != playerid) return SendClientMessage(playerid, GREY, "The seller has canceled the offer!");

			SetPlayerArmourEx(playerid, GetPVarFloat(playerid, "GuardAmount"));

            format(Array, sizeof(Array), "{FF8000}** {C2A2DA}%s has sold a kevlar vest to %s.", GetName(id), GetName(playerid));
            SendNearbyMessage(playerid, Array, PURPLE, 30.0);

            GiveMoneyEx(playerid, -GetPVarInt(playerid, "GuardPrice"));
            GiveMoneyEx(id, GetPVarInt(playerid, "GuardPrice"));

            IncreaseJobSkill(playerid, 2, 1);

            SetPVarInt(id, "GuardTime", gettime() + 30);

			DeletePVar(playerid, "GuardID");
			DeletePVar(playerid, "GuardAmount");
			DeletePVar(playerid, "GuardPrice");
		}
		else if(strcmp(params, "ticket", true) == 0)
		{
			Array[0] = 0;
			if(!GetPVarType(playerid, "BeingTicketedBy") || GetPVarInt(playerid, "BeingTicketedBy") == INVALID_PLAYER_ID) return SendClientMessage(playerid, GREY, "No one has cited you!");

			new id = GetPVarInt(playerid, "BeingTicketedBy");

			if(Player[playerid][Money] < GetPVarInt(playerid, "BeingTicktedPrice")) 
			{
				SendClientMessage(playerid, GREY, "You do not have enough money for this!");
				SendClientMessage(id, GREY, "The player has declined the ticket because they do not have enough money.");
			}
			else
			{
				Array[0] = 0;
            	format(Array, sizeof(Array), "{FF8000}** {C2A2DA}%s has wrote a citation to %s.", GetName(id), GetName(playerid));
            	SendNearbyMessage(playerid, Array, PURPLE, 30.0);

            	new reason[128];
            	GetPVarString(id, "BeingTicketedFor", reason, sizeof(reason));
            	format(Array, sizeof(Array), "%s (%s) has wrote a citation to %s ($%s), for %s.", GetName(id), Group[Player[id][PlayerGroup]][GroupName], GetName(playerid), FormatNumberToString(GetPVarInt(playerid, "BeingTicketedPrice")), reason);
            	Log(10, Array);

            	GiveMoneyEx(playerid, -GetPVarInt(playerid, "BeingTicketedPrice"));
            	new price[2];
            	price[0] = floatround(GetPVarInt(playerid, "BeingTicketedPrice") * 0.30, floatround_round); // Takes 30% of the fine and gives it to the group responsible.
            	price[1] = GetPVarInt(playerid, "BeingTicketedPrice") - price[0]; // Gives the rest to the government.

            	Group[Player[id][PlayerGroup]][GroupMoney] += price[0];
            	for(new i = 0; i < MAX_GROUPS; i++) { if(Group[i][GroupType] == 2) Group[i][GroupMoney] += price[1]; break; } // Fail safe. I don't like static group id's in the script, ensures even if the government group id does change from 0 in game it still adds it properly.
            }

			DeletePVar(playerid, "BeingTicketed");
			DeletePVar(playerid, "BeingTicketedPrice");
			DeletePVar(playerid, "BeingTicketedBy");
			DeletePVar(playerid, "BeingTicketedFor");
			DeletePVar(id, "Ticketing");
		}
	}
	return 1;
}

CMD:cancel(playerid, params[])
{
    if(IsPlayerConnectedEx(playerid)) 
    {
        if(isnull(params)) 
        {
            SendClientMessage(playerid, WHITE, "SNYTAX: /cancel [name]");
            SendClientMessage(playerid, GREY, "Names: offer, truckrun, matrun, drugrun, pizzarun");
            if(Group[Player[playerid][PlayerGroup]][GroupType] == 0 || Group[Player[playerid][PlayerGroup]][GroupType] == 1) SendClientMessage(playerid, GREY, "(COP ONLY) Names: ticket");
            if(Group[Player[playerid][PlayerGroup]][GroupType] == 0 || Group[Player[playerid][PlayerGroup]][GroupType] == 3) SendClientMessage(playerid, GREY, "(MEDIC ONLY) Names: patient");
            return 1;
        }
		if(strcmp(params, "offer", true) == 0)
		{
			if(!GetPVarType(playerid, "Offering")) return SendClientMessage(playerid, GREY, "You have not offered anyone anything!");

			DeletePVar(playerid, "Offering");
			SendClientMessage(playerid, WHITE, "You have successfully canceled your offer.");
		}
		if(strcmp(params, "ticket", true) == 0)
		{
			if(!GetPVarType(playerid, "Ticketing")) return SendClientMessage(playerid, GREY, "You have not offered anyone anything!");

			DeletePVar(GetPVarInt(playerid, "Ticketing"), "BeingTicketed");
			DeletePVar(GetPVarInt(playerid, "Ticketing"), "BeingTicketedPrice");
			DeletePVar(GetPVarInt(playerid, "Ticketing"), "BeingTicketedBy");
			DeletePVar(GetPVarInt(playerid, "Ticketing"), "BeingTicketedFor");

			SendClientMessage(GetPVarInt(playerid, "Ticketing"), WHITE, "The officer has canceled the ticket.");

			DeletePVar(playerid, "Ticketing");
			SendClientMessage(playerid, WHITE, "You have successfully canceled the ticket.");
		}
		if(strcmp(params, "patient", true) == 0)
		{
			if(!GetPVarType(playerid, "AcceptedPatient")) return SendClientMessage(playerid, GREY, "You have not accepted anyone!");

			SendClientMessage(GetPVarInt(playerid, "AcceptedPatientID"), WHITE, "The EMS driver has canceled the call.");

			KillTimer(GetPVarInt(playerid, "AcceptedPatient"));
			DeletePVar(playerid, "AcceptedPatient");
			DeletePVar(playerid, "AcceptedPatientID");
			SendClientMessage(playerid, WHITE, "You have successfully canceled the patient.");
		}
		else if(strcmp(params, "truckrun", true) == 0)
		{
			if(!GetPVarType(playerid, "TruckRun")) return SendClientMessage(playerid, GREY, "You are not on a truck run!");

			if(GetVehicleTrailer(GetPlayerVehicleID(playerid)) == GetPVarInt(playerid, "TruckTrailer")) SetVehicleToRespawn(GetPVarInt(playerid, "TruckTrailer"));
			if(GetPlayerVehicleID(playerid) == GetPVarInt(playerid, "TruckVeh")) SetVehicleToRespawn(GetPVarInt(playerid, "TruckVeh"));

			DisablePlayerCheckpointEx(playerid);

			DeletePVar(playerid, "TruckRun");
			DeletePVar(playerid, "TruckVeh");
			DeletePVar(playerid, "TruckTrailer");

			SendClientMessage(playerid, WHITE, "You have successfully canceled your truckrun.");
		}
		else if(strcmp(params, "matrun", true) == 0)
		{
			if(!GetPVarType(playerid, "MaterialsRun")) return SendClientMessage(playerid, GREY, "You are not on a materials run!");

			DisablePlayerCheckpointEx(playerid);

			DeletePVar(playerid, "MaterialsRun");
			DeletePVar(playerid, "MaterialsForRun");

			SendClientMessage(playerid, WHITE, "You have successfully canceled your materialsrun.");
		}
		else if(strcmp(params, "drugrun", true) == 0)
		{
			if(!GetPVarType(playerid, "DrugRun")) return SendClientMessage(playerid, GREY, "You are not on a drug run!");

			DisablePlayerCheckpointEx(playerid);

			if(GetPVarInt(playerid, "DrugRun") == 1) DeletePVar(playerid, "PotPackages");
			if(GetPVarInt(playerid, "DrugRun") == 2) DeletePVar(playerid, "CrackPackages");
			DeletePVar(playerid, "DrugRun");

			SendClientMessage(playerid, WHITE, "You have successfully canceled your drugrun.");
		}
		else if(strcmp(params, "pizzarun", true) == 0)
		{
			if(!GetPVarType(playerid, "PizzaRun")) return SendClientMessage(playerid, GREY, "You are not on a pizza run!");

			DisablePlayerCheckpointEx(playerid);
			DeletePVar(playerid, "PizzaRun");
			DeletePVar(playerid, "PizzaPoint");

			SendClientMessage(playerid, WHITE, "You have successfully canceled your pizzarun.");
		}
	}
	return 1;
}

CMD:killcheckpoint(playerid, params[])
{
	if(GetPVarInt(playerid, "Checkpoint") >= 1)
	{
		DisablePlayerCheckpointEx(playerid);

		if(GetPVarInt(playerid, "TruckRun") >= 1)
		{
			DeletePVar(playerid, "TruckRun");
			DeletePVar(playerid, "TruckVeh");
			DeletePVar(playerid, "TruckTrailer");
		}

		if(GetPVarInt(playerid, "MaterialsRun") >= 1)
		{
			DeletePVar(playerid, "MaterialsRun");
			DeletePVar(playerid, "MaterialsForRun");
		}

		if(GetPVarInt(playerid, "DrugRun") == 1)
		{
			DeletePVar(playerid, "DrugRun");
			DeletePVar(playerid, "PotPackages");
		}

		if(GetPVarInt(playerid, "DrugRun") == 2)
		{
			DeletePVar(playerid, "DrugRun");
			DeletePVar(playerid, "CrackPackages");
		}

		if(GetPVarInt(playerid, "PizzaRun") >= 1)
		{
			DeletePVar(playerid, "PizzaRun");
			DeletePVar(playerid, "PizzaPoint");
		}

		if(GetPVarType(playerid, "Finding") >= 1) DeletePVar(playerid, "Finding");
		if(GetPVarType(playerid, "AcceptedPatient") >= 1) { DeletePVar(playerid, "AcceptedPatient"); DeletePVar(playerid, "AcceptedPatientID"); }

		SendClientMessage(playerid, WHITE, "You have cleared your checkpoint.");
	}
	return 1;
}

CMD:limbo(playerid, params[])
{
	if(Player[playerid][Injured] == 2)
	{
		Player[playerid][Injured] = 4;
		SetPlayerPosEx(playerid, 1201.12, -1324, -80.0, 0.0, 0, 0);
		TogglePlayerControllableEx(playerid, FALSE);
		TextDrawHideForPlayer(playerid, LimboTextDraw);

		SetPlayerCameraPos(playerid, 1207.39, -1294.71, 24.61);
		SetPlayerCameraLookAt(playerid, 1181.72, -1322.65, 13.58);

		SetTimerEx("LimboTimer", 15000, FALSE, "i", playerid);
	}
	else SendClientMessage(playerid, WHITE, "You are not injured!");
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case DIALOG_DROPWEAPON:
		{
			if(!response) return 1;
			switch(listitem)
			{
				case 0 .. 12:
				{
					Array[0] = 0;
					new idstring[4], id[3];

					id[1] = strfind(inputtext, "(");
		    		id[2] = strfind(inputtext, ")");
		    		
		    		strmid(idstring, inputtext, id[1]+1, id[2]);
		    		id[0] = strval(idstring);

		    		new slot = GetWeaponSlot(id[0]);
					Player[playerid][Weapon][slot] = 0;

					ResetPlayerWeapons(playerid);
					GivePlayerSavedWeapons(playerid);

					new weaponname[16];
					GetWeaponName(id[0], weaponname, 16);

					format(Array, sizeof(Array), "{FF8000}** {C2A2DA}%s has dropped their %s.", GetName(playerid), weaponname); 
					SendNearbyMessage(playerid, Array, PURPLE, 30.0);
				}
			}
		}
	}
	return 1;
}

ShowStatistics(playerid, id) // Make sure to use 'id' when getting information, and 'playerid' when sending it.
{
	Array[0] = 0;

	new jobstring[50], groupstring[256], rankstring[50], divstring[50], leaderstring[15], vehiclestring[MAX_PLAYER_VEHICLES][50];
	SendClientMessage(id, WHITE, "---------------------------------------------------------------------------------------------------------------------------------------");

	if(Player[id][PlayerJob] > -1) format(jobstring, 50, "%s", Job[Player[id][PlayerJob]][JobName]);
	else format(jobstring, 50, "Nothing");

	if(Player[id][PlayerGroup] > -1) format(groupstring, 50, "%s", Group[Player[id][PlayerGroup]][GroupName]);
	else format(groupstring, 50, "Nothing");

	if(Player[id][PlayerGroup] > -1) format(rankstring, 50, "%s", GroupRankNames[Player[id][PlayerGroup]][Player[id][GroupRank]]);
	else format(rankstring, 50, "Nothing");

	if(Player[id][PlayerGroup] > -1) format(divstring, 50, "%s", GroupDivisionNames[Player[id][PlayerGroup]][Player[id][GroupDiv]]);
	else format(divstring, 50, "Nothing");

	if(Player[id][Leader] >= 1 && GetMaxGroupRank(Player[id][PlayerGroup]) != Player[id][GroupRank]) format(leaderstring, 50, "Yes");
	else if(Player[id][Leader] >= 1 && GetMaxGroupRank(Player[id][PlayerGroup]) == Player[id][GroupRank]) format(leaderstring, 50, "Slotholder");
	else format(leaderstring, 50, "No");

	for(new i; i < MAX_PLAYER_VEHICLES; i++)
	{
		if(PlayerVehicle[id][CarModel][i] > 0) format(vehiclestring[i], 50, "%s", VehicleNames[PlayerVehicle[id][CarModel][i] - 400]);
		else format(vehiclestring[i], 50, "Nothing");
	}


	format(Array, sizeof(Array), "Name: %s | Age: 18 | Gender: Female | Accent: %s | Job: %s | Second Job: Nothing | Third Job: Nothing", GetName(id), GetPlayerAccent(id), jobstring);
	SendClientMessage(playerid, WHITE, Array);

	format(Array, sizeof(Array), "Group: %s | Rank: %s | Division: %s | Badge: [000-000] | Hourly Pay: $%s | Group Leader: %s", groupstring, rankstring, divstring, FormatNumberToString(Group[Player[id][PlayerGroup]][GroupPaycheque][Player[id][GroupRank]]), leaderstring);
	SendClientMessage(playerid, WHITE, Array);

	if(Player[playerid][AdminLevel] > 0 && Player[playerid][AdminDuty] > 0)
	{
		new ipstring[16];
		GetPlayerIp(id, ipstring, 16);

		if(Player[id][AdminLevel] > 0)
		{
			format(Array, sizeof(Array), "Admin Level: %d | Admin Name: %s | Admin Duty: %d | Normal Name: %s", Player[playerid][AdminLevel], Player[playerid][AdminName], Player[playerid][AdminDuty], Player[playerid][Username]);
			SendClientMessage(playerid, GREY, Array);
		}

		format(Array, sizeof(Array), "ID: %d | IP Address: %s | Ping: %d", id, ipstring, GetPlayerPing(id));
		SendClientMessage(playerid, GREY, Array);
	}

	format(Array, sizeof(Array), "Playing Hours: %d | Married To: Nobody | Money: $%s | Bank Money: $0 | Total Wealth: $%s | Player Rank: Newbie", Player[playerid][PlayingHours], FormatNumberToString(Player[playerid][Money]), FormatNumberToString(Player[playerid][Money]));
	SendClientMessage(playerid, WHITE, Array);

	format(Array, sizeof(Array), "Vehicle 1: %s | Vehicle 2: %s | Vehicle 3: %s | Vehicle 4: %s | Vehicle 5: %s", vehiclestring[0], vehiclestring[1], vehiclestring[2], vehiclestring[3], vehiclestring[4]);
	SendClientMessage(playerid, WHITE, Array);

	SendClientMessage(id, WHITE, "---------------------------------------------------------------------------------------------------------------------------------------");
	return 1;
}