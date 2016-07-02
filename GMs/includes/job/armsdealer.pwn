#include <YSI\y_hooks>

CMD:getmats(playerid, params[])
{
	if(Job[Player[playerid][PlayerJob]][JobType] == 1)
	{
		for(new i; i < MAX_POINTS; i++)
		{
			if(IsPlayerInRangeOfPoint(playerid, 3.0, Point[i][poPos][0], Point[i][poPos][1], Point[i][poPos][2]) && Point[i][poType] == 0)
			{
				if(GetPlayerVirtualWorld(playerid) == Point[i][pointVW])
				{
					if(GetPVarInt(playerid, "Checkpoint") >= 1) return SendClientMessage(playerid, WHITE, "You already have an active checkpoint. Reach it, or type /killcheckpoint to clear it.");

					new price = Point[i][poMaterials] * 5;

					if(Player[playerid][Money] >= price)
					{
						SetPVarInt(playerid, "MaterialsRun", 1);
						SetPVarInt(playerid, "MaterialsForRun", Point[i][poMaterials]);
						SetPlayerCheckpointEx(playerid, Point[i][poPos2][0], Point[i][poPos2][1], Point[i][poPos2][2], 5.0);

						format(Array, sizeof(Array), "You have purchased %d materials packages for $%s. Deliver them to the checkpoint to collect your share.", Point[i][poMaterials] / 4, FormatNumberToString(price));
						SendClientMessage(playerid, WHITE, Array);
					}
					else 
					{
						format(Array, sizeof(Array), "You need $%s to purchase these materials.", FormatNumberToString(price));
						return SendClientMessage(playerid, WHITE, Array);
					}					
				}
			}
		}
	}
	else SendClientMessage(playerid, WHITE, "You are not an arms dealer.");
	return 1;
}

hook OnPlayerEnterCheckpoint(playerid)
{
	if(GetPVarInt(playerid, "MaterialsRun"))
	{
		DisablePlayerCheckpointEx(playerid);
		Player[playerid][Materials] += GetPVarInt(playerid, "MaterialsForRun");

		format(Array, sizeof(Array), "You have delivered the materials to the factory and collected %d.", GetPVarInt(playerid, "MaterialsForRun"));
		SendClientMessage(playerid, WHITE, Array);

		DeletePVar(playerid, "MaterialsRun");
		DeletePVar(playerid, "MaterialsForRun");
	}
	return 1;
}

CMD:sellgun(playerid, params[])
{
	if(Job[Player[playerid][PlayerJob]][JobType] == 1)
	{
		if(Player[playerid][JailTime] == 0)
		{
			if(GetPVarInt(playerid, "SellGunTime") > gettime()) return SendClientMessage(playerid, GREY, "You must wait 10 seconds before selling another gun.");
			if(IsPlayerInAnyVehicle(playerid) || GetPVarInt(playerid, "Cuffed") >= 1) return SendClientMessage(playerid, GREY, "You cannot sell a gun right now!");

			if(GetPVarType(playerid, "Offering")) return SendClientMessage(playerid, GREY, "You already have a pending offer. Type /cancel offer to reset it.");

			new id, weapon[16];
			if(sscanf(params, "us[16]", id, weapon)) 
			{
				SendClientMessage(playerid, WHITE, "-------------------------------------");
				switch(Player[playerid][JobSkill][0])
				{
					case 0 .. 49: // level 1
					{
						SendClientMessage(playerid, GREY, "flowers(100)    knuckles(100)");
						SendClientMessage(playerid, WHITE, "bat(100)            cane(100)");
						SendClientMessage(playerid, GREY, "shovel(100)         club(100)");
						SendClientMessage(playerid, WHITE, "pool(100)         katana(200)");
						SendClientMessage(playerid, GREY, "9mm(500)");
					}
					case 50 .. 99: // level 2
					{
						SendClientMessage(playerid, GREY, "flowers(100)    knuckles(100)");
						SendClientMessage(playerid, WHITE, "bat(100)            cane(100)");
						SendClientMessage(playerid, GREY, "shovel(100)         club(100)");
						SendClientMessage(playerid, WHITE, "pool(100)         katana(200)");
						SendClientMessage(playerid, GREY, "9mm(500)         sdpistol(850)");
						SendClientMessage(playerid, WHITE, "shotgun(1000)");
					}
					case 100 .. 199: // level 3
					{
						SendClientMessage(playerid, GREY, "flowers(100)    knuckles(100)");
						SendClientMessage(playerid, WHITE, "bat(100)            cane(100)");
						SendClientMessage(playerid, GREY, "shovel(100)         club(100)");
						SendClientMessage(playerid, WHITE, "pool(100)         katana(200)");
						SendClientMessage(playerid, GREY, "9mm(500)         sdpistol(800)");
						SendClientMessage(playerid, WHITE, "shotgun(1000)       uzi(2500)");
						SendClientMessage(playerid, GREY, "tec9(2500)        rifle(3000)");
					}
					case 200 .. 399: // level 4
					{
						SendClientMessage(playerid, GREY, "flowers(100)    knuckles(100)");
						SendClientMessage(playerid, WHITE, "bat(100)            cane(100)");
						SendClientMessage(playerid, GREY, "shovel(100)         club(100)");
						SendClientMessage(playerid, WHITE, "pool(100)         katana(200)");
						SendClientMessage(playerid, GREY, "9mm(500)         sdpistol(800)");
						SendClientMessage(playerid, WHITE, "shotgun(1000)       uzi(2500)");
						SendClientMessage(playerid, GREY, "tec9(2500)        rifle(3000)");
						SendClientMessage(playerid, WHITE, "MP5(4500)        deagle(5000)");
					}
					default: // level 5
					{
						SendClientMessage(playerid, GREY, "flowers(100)    knuckles(100)");
						SendClientMessage(playerid, WHITE, "bat(100)            cane(100)");
						SendClientMessage(playerid, GREY, "shovel(100)         club(100)");
						SendClientMessage(playerid, WHITE, "pool(100)         katana(200)");
						SendClientMessage(playerid, GREY, "9mm(500)         sdpistol(800)");
						SendClientMessage(playerid, WHITE, "shotgun(1000)       uzi(2500)");
						SendClientMessage(playerid, GREY, "tec9(2500)        rifle(3000)");
						SendClientMessage(playerid, WHITE, "MP5(4500)        deagle(5000)");
						SendClientMessage(playerid, GREY, "AK47(15000)");
					}
				}
				SendClientMessage(playerid, WHITE, "-------------------------------------");
				SendClientMessage(playerid, WHITE, "USAGE: /sellgun [playerid] [weapon]");
				return 1;
			}

			if(IsPlayerConnected(id))
			{
				if(IsPlayerInAnyVehicle(id) || GetPVarInt(id, "Cuffed") >= 1) return SendClientMessage(playerid, GREY, "You cannot sell a gun to that person right now!");

				if(IsPlayerNearPlayer(playerid, id, 8.0))
				{
					if(strcmp(weapon, "Flowers", true) == 0 && Player[playerid][JobSkill][0] >= 0)
					{
						if(Player[playerid][Materials] >= 100)
						{
							if(id == playerid)
							{
								Player[playerid][Materials] -= 100;
								GivePlayerWeaponEx(playerid, 14);
							}
							else
							{
								SetPVarInt(id, "SellGun", 14);
								SetPVarInt(id, "SellGunMats", 100);
								SetPVarInt(id, "SellGunID", playerid);
							}
						}
						else return SendClientMessage(playerid, WHITE, "You do not have enough materials!");
					}
					else if(strcmp(weapon, "Knuckles", true) == 0 && Player[playerid][JobSkill][0] >= 0)
					{
						if(Player[playerid][Materials] >= 100)
						{
							if(id == playerid)
							{
								Player[playerid][Materials] -= 100;
								GivePlayerWeaponEx(playerid, 1);
							}
							else
							{
								SetPVarInt(id, "SellGun", 1);
								SetPVarInt(id, "SellGunMats", 100);
								SetPVarInt(id, "SellGunID", playerid);
							}
						}
						else return SendClientMessage(playerid, WHITE, "You do not have enough materials!");
					}
					else if(strcmp(weapon, "Bat", true) == 0 && Player[playerid][JobSkill][0] >= 0)
					{
						if(Player[playerid][Materials] >= 100)
						{
							if(id == playerid)
							{
								Player[playerid][Materials] -= 100;
								GivePlayerWeaponEx(playerid, 5);
							}
							else
							{
								SetPVarInt(id, "SellGun", 5);
								SetPVarInt(id, "SellGunMats", 100);
								SetPVarInt(id, "SellGunID", playerid);
							}
						}
						else return SendClientMessage(playerid, WHITE, "You do not have enough materials!");
					}
					else if(strcmp(weapon, "Cane", true) == 0 && Player[playerid][JobSkill][0] >= 0)
					{
						if(Player[playerid][Materials] >= 100)
						{
							if(id == playerid)
							{
								Player[playerid][Materials] -= 100;
								GivePlayerWeaponEx(playerid, 15);
							}
							else
							{
								SetPVarInt(id, "SellGun", 15);
								SetPVarInt(id, "SellGunMats", 100);
								SetPVarInt(id, "SellGunID", playerid);
							}
						}
						else return SendClientMessage(playerid, WHITE, "You do not have enough materials!");
					}
					else if(strcmp(weapon, "Shovel", true) == 0 && Player[playerid][JobSkill][0] >= 0)
					{
						if(Player[playerid][Materials] >= 100)
						{
							if(id == playerid)
							{
								Player[playerid][Materials] -= 100;
								GivePlayerWeaponEx(playerid, 6);
							}
							else
							{
								SetPVarInt(id, "SellGun", 6);
								SetPVarInt(id, "SellGunMats", 100);
								SetPVarInt(id, "SellGunID", playerid);
							}
						}
						else return SendClientMessage(playerid, WHITE, "You do not have enough materials!");
					}
					else if(strcmp(weapon, "Club", true) == 0 && Player[playerid][JobSkill][0] >= 0)
					{
						if(Player[playerid][Materials] >= 100)
						{
							if(id == playerid)
							{
								Player[playerid][Materials] -= 100;
								GivePlayerWeaponEx(playerid, 2);
							}
							else
							{
								SetPVarInt(id, "SellGun", 2);
								SetPVarInt(id, "SellGunMats", 100);
								SetPVarInt(id, "SellGunID", playerid);
							}
						}
						else return SendClientMessage(playerid, WHITE, "You do not have enough materials!");
					}
					else if(strcmp(weapon, "Pool", true) == 0 && Player[playerid][JobSkill][0] >= 0)
					{
						if(Player[playerid][Materials] >= 100)
						{
							if(id == playerid)
							{
								Player[playerid][Materials] -= 100;
								GivePlayerWeaponEx(playerid, 7);
							}
							else
							{
								SetPVarInt(id, "SellGun", 7);
								SetPVarInt(id, "SellGunMats", 100);
								SetPVarInt(id, "SellGunID", playerid);
							}
						}
						else return SendClientMessage(playerid, WHITE, "You do not have enough materials!");
					}
					else if(strcmp(weapon, "Katana", true) == 0 && Player[playerid][JobSkill][0] >= 0)
					{
						if(Player[playerid][Materials] >= 200)
						{
							if(id == playerid)
							{
								Player[playerid][Materials] -= 200;
								GivePlayerWeaponEx(playerid, 8);
							}
							else
							{
								SetPVarInt(id, "SellGun", 8);
								SetPVarInt(id, "SellGunMats", 200);
								SetPVarInt(id, "SellGunID", playerid);
							}
						}
						else return SendClientMessage(playerid, WHITE, "You do not have enough materials!");
					}
					else if(strcmp(weapon, "9mm", true) == 0 && Player[playerid][JobSkill][0] >= 0)
					{
						if(Player[playerid][Materials] >= 500)
						{
							if(id == playerid)
							{
								Player[playerid][Materials] -= 500;
								GivePlayerWeaponEx(playerid, 22);
							}
							else
							{
								SetPVarInt(id, "SellGun", 22);
								SetPVarInt(id, "SellGunMats", 500);
								SetPVarInt(id, "SellGunID", playerid);
							}
						}
						else return SendClientMessage(playerid, WHITE, "You do not have enough materials!");
					}
					else if(strcmp(weapon, "sdpistol", true) == 0 && Player[playerid][JobSkill][0] >= 50)
					{
						if(Player[playerid][Materials] >= 850)
						{
							if(id == playerid)
							{
								Player[playerid][Materials] -= 850;
								GivePlayerWeaponEx(playerid, 23);
							}
							else
							{
								SetPVarInt(id, "SellGun", 23);
								SetPVarInt(id, "SellGunMats", 850);
								SetPVarInt(id, "SellGunID", playerid);
							}
						}
						else return SendClientMessage(playerid, WHITE, "You do not have enough materials!");
					}
					else if(strcmp(weapon, "shotgun", true) == 0 && Player[playerid][JobSkill][0] >= 50)
					{
						if(Player[playerid][Materials] >= 1000)
						{
							if(id == playerid)
							{
								Player[playerid][Materials] -= 1000;
								GivePlayerWeaponEx(playerid, 25);
							}
							else
							{
								SetPVarInt(id, "SellGun", 25);
								SetPVarInt(id, "SellGunMats", 1000);
								SetPVarInt(id, "SellGunID", playerid);
							}
						}
						else return SendClientMessage(playerid, WHITE, "You do not have enough materials!");
					}
					else if(strcmp(weapon, "uzi", true) == 0 && Player[playerid][JobSkill][0] >= 100)
					{
						if(Player[playerid][Materials] >= 2500)
						{
							if(id == playerid)
							{
								Player[playerid][Materials] -= 2500;
								GivePlayerWeaponEx(playerid, 28);
							}
							else
							{
								SetPVarInt(id, "SellGun", 28);
								SetPVarInt(id, "SellGunMats", 2500);
								SetPVarInt(id, "SellGunID", playerid);
							}
						}
						else return SendClientMessage(playerid, WHITE, "You do not have enough materials!");
					}
					else if(strcmp(weapon, "tec9", true) == 0 && Player[playerid][JobSkill][0] >= 100)
					{
						if(Player[playerid][Materials] >= 2500)
						{
							if(id == playerid)
							{
								Player[playerid][Materials] -= 2500;
								GivePlayerWeaponEx(playerid, 32);
							}
							else
							{
								SetPVarInt(id, "SellGun", 32);
								SetPVarInt(id, "SellGunMats", 2500);
								SetPVarInt(id, "SellGunID", playerid);
							}
						}
						else return SendClientMessage(playerid, WHITE, "You do not have enough materials!");
					}
					else if(strcmp(weapon, "rifle", true) == 0 && Player[playerid][JobSkill][0] >= 100)
					{
						if(Player[playerid][Materials] >= 3000)
						{
							if(id == playerid)
							{
								Player[playerid][Materials] -= 3000;
								GivePlayerWeaponEx(playerid, 33);
							}
							else
							{
								SetPVarInt(id, "SellGun", 33);
								SetPVarInt(id, "SellGunMats", 3000);
								SetPVarInt(id, "SellGunID", playerid);
							}
						}
						else return SendClientMessage(playerid, WHITE, "You do not have enough materials!");
					}
					else if(strcmp(weapon, "MP5", true) == 0 && Player[playerid][JobSkill][0] >= 200)
					{
						if(Player[playerid][Materials] >= 4500)
						{
							if(id == playerid)
							{
								Player[playerid][Materials] -= 4500;
								GivePlayerWeaponEx(playerid, 29);
							}
							else
							{
								SetPVarInt(id, "SellGun", 29);
								SetPVarInt(id, "SellGunMats", 4500);
								SetPVarInt(id, "SellGunID", playerid);
							}
						}
						else return SendClientMessage(playerid, WHITE, "You do not have enough materials!");
					}
					else if(strcmp(weapon, "deagle", true) == 0 && Player[playerid][JobSkill][0] >= 200)
					{
						if(Player[playerid][Materials] >= 5000)
						{
							if(id == playerid)
							{
								Player[playerid][Materials] -= 5000;
								GivePlayerWeaponEx(playerid, 24);
							}
							else
							{
								SetPVarInt(id, "SellGun", 24);
								SetPVarInt(id, "SellGunMats", 5000);
								SetPVarInt(id, "SellGunID", playerid);
							}
						}
						else return SendClientMessage(playerid, WHITE, "You do not have enough materials!");
					}
					else if(strcmp(weapon, "ak47", true) == 0 && Player[playerid][JobSkill][0] >= 400)
					{
						if(Player[playerid][Materials] >= 15000)
						{
							if(id == playerid)
							{
								Player[playerid][Materials] -= 15000;
								GivePlayerWeaponEx(playerid, 30);
							}
							else
							{
								SetPVarInt(id, "SellGun", 30);
								SetPVarInt(id, "SellGunMats", 15000);
								SetPVarInt(id, "SellGunID", playerid);
							}
						}
						else return SendClientMessage(playerid, WHITE, "You do not have enough materials!");
					}
					else return SendClientMessage(playerid, WHITE, "That is an invalid weapon!");
					
					weapon[0] = toupper(weapon[0]);

					if(id == playerid) 
					{ 
						format(Array, sizeof(Array), "* %s crafts a %s from their materials, handing it to themselves.", GetName(playerid), weapon); 
						SendNearbyMessage(playerid, Array, SCRIPTPURPLE, 30.0);

						IncreaseJobSkill(playerid, 0, 1);

						PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0); // Just a little 'classic' feel to it. -Jason
					}
					else 
					{
						SetPVarInt(playerid, "Offering", 1);
						format(Array, sizeof(Array), "You have offered %s a %s.", GetName(id), weapon);
						SendClientMessage(playerid, LIGHTBLUE, Array);
						format(Array, sizeof(Array), "%s has offered to sell you a %s, type /accept gun to accept it.", GetName(playerid), weapon);
						SendClientMessage(id, LIGHTBLUE, Array);
					}

					SetPVarInt(playerid, "SellGunTime", gettime() + 10);
				}
				else return SendClientMessage(playerid, WHITE, "You are not near that player!");
			}
			else return SendClientMessage(playerid, WHITE, "That player is not connected!");
		}
		else return SendClientMessage(playerid, WHITE, "You cannot do this while being in jail.");
	}
	else SendClientMessage(playerid, WHITE, "You are not an arms dealer.");
	return 1;
}