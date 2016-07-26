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

	    			if(GetPlayerSpecialAction(id) == SPECIAL_ACTION_HANDSUP)
	    			{
	    				Array[0] = 0;
	    				SetPVarInt(id, "Cuffed", 1);
	    				ClearAnimations(id, 1);

	    				SetPlayerSpecialAction(id, SPECIAL_ACTION_CUFFED);

	    				if(!unfrozen)
	    				{
	    					TogglePlayerControllable(id, FALSE);
	    					SetCameraBehindPlayer(id);
	    				}

	    				format(Array, sizeof(Array), "* %s takes out a pair of cuffs, securing them tightly on %s's wrists.", GetName(playerid), GetName(id));
	    				SendNearbyMessage(playerid, Array, SCRIPTPURPLE, 30.0);
	    			}
	    			else return SendClientMessage(playerid, WHITE, "This player does not have their hands up!");
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

						TogglePlayerControllable(id, TRUE);

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

										TogglePlayerControllable(id, TRUE);

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

	    				AddCrime(id, playerid, listitem, Player[playerid][PlayerGroup], gettime());

	    				Log(16, Array, Player[playerid][PlayerGroup]);
	    			}
	    			else return SendClientMessage(playerid, WHITE, "That palyer is not connected!");
				}
			}
		}
	}
	return 1;
}

AddCrime(playerid, issuer, crime, group, time)
{
	Array[0] = 0;
	format(Array, sizeof(Array), "INSERT INTO `issuedcrimes` (`player`, `issuer`, `crime`, `group`, `time`, `active`) VALUES (%d, %d, %d, %d, %d, 1)", Player[playerid][DatabaseID], Player[issuer][DatabaseID], crime, group, time);
	mysql_tquery(SQL, Array, "", "");
	return 1;
}

DisableCrimes(playerid)
{
	Array[0] = 0;
	format(Array, sizeof(Array), "UPDATE `issuedcrimes` SET `active` = '0' WHERE `player` = '%d'", Player[playerid][DatabaseID]);
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