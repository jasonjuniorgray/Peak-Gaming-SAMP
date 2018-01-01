task OneSecond[1000]()
{
	foreach(new i: Player)
	{
		// AFK / LoginRegister Check
		if(Player[i][Authenticated] >= 1)
		{
			if(GetPVarInt(i, "LastTyped") >= 10 && Player[i][AdminLevel] < 1337 && Player[i][AdminDuty] < 1) 
			{
				if(IsPlayerInRangeOfPoint(i, 2.0, GetPVarFloat(i, "AFKCheck1"), GetPVarFloat(i, "AFKCheck2"), GetPVarFloat(i, "AFKCheck3")))
				{
					SendClientMessage(i, WHITE, "You have been kicked for being AFK.");
					return DelayPunishment(i, 1);
				}
			}
			else
			{
				DeletePVar(i, "Paused");

				new Float:Pos[3];
				GetPlayerPos(i, Pos[0], Pos[1], Pos[2]);

				SetPVarFloat(i, "AFKCheck1", Pos[0]);
				SetPVarFloat(i, "AFKCheck2", Pos[1]);
				SetPVarFloat(i, "AFKCheck3", Pos[2]);
			}
		}
		else
		{
			if(GetPVarInt(i, "SpawnAFK") >= 30)
			{
				SendClientMessage(i, WHITE, "You have been kicked for being failing to login within a thirty second timeframe.");
				return DelayPunishment(i, 1);
			}
			else
			{
				SetPVarInt(i, "SpawnAFK", GetPVarInt(i, "SpawnAFK") + 1);
			}
		}

		Player[i][ConnectedSeconds]++;
		if(Player[i][ConnectedSeconds] >= 3600)
		{
			new PayMoney = 500;
			Player[i][ConnectedSeconds] = 0;
			Player[i][PlayingHours]++;

			SendClientMessage(i, WHITE, "----------------------------------------------");
			SendClientMessage(i, GREY, "Your paycheque has arrived!");

			// bank shit to increase money
			format(Array, sizeof(Array), "Money: $%s, Tax: 0 percent.", FormatNumberToString(PayMoney));
			SendClientMessage(i, GREY, Array);
			if(Player[i][PlayerGroup] >= 0)
			{
				new GroupPayMoney = Group[Player[i][PlayerGroup]][GroupPaycheque][Player[i][GroupRank]];
				if(GroupPayMoney > 0)
				{
					if(Group[Player[i][PlayerGroup]][GroupMoney] >= GroupPayMoney)
					{
						format(Array, sizeof(Array), "You have recieved $%s for being a member of %s.", FormatNumberToString(GroupPayMoney), Group[Player[i][PlayerGroup]][GroupName]);
						PayMoney += GroupPayMoney;
					}
					else format(Array, sizeof(Array), "Your group does not have enough to pay you.", FormatNumberToString(GroupPayMoney));
					SendClientMessage(i, GREY, Array);
				}
			}
			//money = money / tax;

			format(Array, sizeof(Array), "Total: $%s, Bank Total: $0.", FormatNumberToString(PayMoney));
			SendClientMessage(i, GREY, Array);
			GiveMoneyEx(i, PayMoney);

			SendClientMessage(i, WHITE, "----------------------------------------------");
		}

		if(Player[i][Taser] > 0) SetPlayerArmedWeapon(i, 23);
		if(GetPVarType(i, "TaserReload")) { if(GetPVarInt(i, "TaserReload") > 0) SetPVarInt(i, "TaserReload", GetPVarInt(i, "TaserReload") - 1); else DeletePVar(i, "TaserReload"); }

		if(IsPlayerInAnyVehicle(i) && PLAYER_STATE_DRIVER)
		{
			SetPlayerArmedWeapon(i, 0);

			new Float:health, engine, lights, alarm, doors, bonnet, boot, objective, vehicleid = GetPlayerVehicleID(i);
			GetVehicleHealth(vehicleid, health);
			GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

			if(health < 256.0)
			{
				SetVehicleHealth(vehicleid, 256.0);

				if(engine != VEHICLE_PARAMS_OFF)
				{
					Array[0] = 0;
					format(Array, sizeof(Array), "* The vehicle engine stalls (( %s ))", GetName(i));
					SendNearbyMessage(i, Array, SCRIPTPURPLE, 30.0);
					SetVehicleParamsEx(vehicleid, VEHICLE_PARAMS_OFF, lights, alarm, doors, bonnet, boot, objective);
				}
			}
		}
		if(Player[i][JailTime] > 0 && Player[i][ArrestedBy] != 0)
		{
			Player[i][JailTime]--;

			if(Player[i][JailTime] == 0)
			{
				SetPlayerPosEx(i, Spawn[0], Spawn[1], Spawn[2], Spawn[3], 0, 0);
				Player[i][ArrestedBy] = 0;
			}
		}

		if(GetPVarType(i, "PizzaRun"))
		{
			if(GetPVarInt(i, "PizzaRun") >= 300)
			{
				SendClientMessage(i, WHITE, "You took too long to deliver the pizza and it's gone cold. Your run has been canceled.");
				DeletePVar(i, "PizzaRun");
				DeletePVar(i, "PizzaPoint");
				DisablePlayerCheckpointEx(i);
			}
			else SetPVarInt(i, "PizzaRun", GetPVarInt(i, "PizzaRun") + 1);
		}

		if(IsPlayerInAnyVehicle(i) && Player[i][Speedo] == 1 && GetPlayerState(i) == PLAYER_STATE_DRIVER)
	    {
			new string[50], color1[4], color2[4];
				
			switch(GetPlayerSpeed(i, 0))
			{
				case 0 .. 40: color1 = "~w~";
				case 41 .. 60: color1 = "~y~";
				case 61 .. 200: color1 = "~r~";
				default: color1 = "~w~";
			}
				
			switch(Fuel[GetPlayerVehicleID(i)])
			{
				case 0 .. 10: color2 = "~r~";
				case 11 .. 50: color2 = "~y~";
				case 51 .. 70: color2 = "~w~";
				case 71 .. 100: color2 = "~g~";
				default: color2 = "~w~";
			}
				
	    	if(Fuel[GetPlayerVehicleID(i)] == -1)
	    	{
				format(string, sizeof(string), "~b~Fuel: ~w~U/L");
			}
			else
			{
				format(string, sizeof(string), "~b~Fuel: %s%i", color2, Fuel[GetPlayerVehicleID(i)]);
			}
			PlayerTextDrawSetString(i, FuelTextDraw[i], string);

			format(string, sizeof(string), "~b~MPH: %s%d", color1, GetPlayerSpeed(i, 1));
			PlayerTextDrawSetString(i, SpeedTextDraw[i], string);
		}
	}
	return 1;
}

task OneMinute[60000]()
{
	gettime(GlobalHour, GlobalMinute, GlobalSecond);

	Array[0] = 0;
	OneMinuteInt[0]++;
	OneMinuteInt[1]++;

    if(GlobalMinute == 0)
    {
    	SetTime();
    	format(Array, sizeof(Array), "The time is now %d:00.", GlobalHour);
    	SendClientMessageToAll(GREY, Array);
    }

	foreach(new i: Player)
	{
    	switch(OneMinuteInt[0])
    	{
    		case 5:
    		{
    			OneMinuteInt[0] = 0;
    		
    			SavePlayerData(i, 1);
    			print("[TIMER] Saved Player Data Automatically.");
    		}
    	}

		SetPVarInt(i, "LastTyped", GetPVarInt(i, "LastTyped") + 1);
	}
	switch(OneMinuteInt[1])
	{
		case 2:
		{
			for(new i = 0; i < MAX_VEHICLES; i++)
		    {
		    	OneMinuteInt[1] = 0;
		    	
		        new engine, lights, alarm, doors, bonnet, boot, objective;
		        GetVehicleParamsEx(i, engine, lights, alarm, doors, bonnet, boot, objective);

		        if(engine == VEHICLE_PARAMS_ON)
		        {
		            if(Fuel[i] == -1) return 1;

					Fuel[i] = Fuel[i] - 1;
					if(Fuel[i] == 0)
					{
						Fuel[i] = 0;
		                SetVehicleParamsEx(i, VEHICLE_PARAMS_OFF, lights, alarm, doors, bonnet, boot, objective);
					}
		        }
		    }
		}
    }
	if(GlobalHour == 0 && GlobalMinute == 0)
	{
		if(LotteryInfo[0] > 0)
		{
			new rand = random(LotteryInfo[0]);

			if(rand == 0) rand = 1;
			format(Array, sizeof(Array), "The lottery drawing has finished! The number was %d, and the jackpot was $%s.", rand, FormatNumberToString(LotteryInfo[1]));
			SendClientMessageToAll(WHITE, Array);
			GetLotteryWinners(rand);
		}
	}
	return 1;
}

forward KickPlayer(playerid);
public KickPlayer(playerid)
{
	Kick(playerid);
	return 1;
}

forward GMXTimer();
public GMXTimer()
{
	if(ServerGMX == 1) ServerRestart();
	return 1;
}

forward PrepareStreamTimer(playerid);
public PrepareStreamTimer(playerid)
{
	new Float: X, Float: Y, Float: Z;
	if(IsPlayerInAnyVehicle(playerid))
	{
		GetVehiclePos(GetPlayerVehicleID(playerid), X, Y, Z);
		SetVehiclePos(GetPlayerVehicleID(playerid), X, Y, Z);
	}
	else
	{
		GetPlayerPos(playerid, X, Y, Z);
		SetPlayerPos(playerid, X, Y, Z + 0.5);
	}
	TogglePlayerControllableEx(playerid, TRUE);
	SetCameraBehindPlayer(playerid);

	if(Player[playerid][Injured] > 0) ApplyAnimation(playerid, "PED", "KO_shot_stom", 4.0, 0, 1, 1, 1, 0, 1);

	DeletePVar(playerid, "StreamPrep");
}

forward TaserTimer(playerid);
public TaserTimer(playerid) 
{
	if(GetPVarType(playerid, "Tasered") && GetPVarInt(playerid, "Tasered") > 0)
	{
		Array[0] = 0;
		DeletePVar(playerid, "Tasered");
		TogglePlayerControllableEx(playerid, TRUE);
		ClearAnimations(playerid);
		ApplyAnimation(playerid, "SUNBATHE", "Lay_Bac_out", 4.1, 0, 1, 1, 0, 1, 1);
		SetPlayerDrunkLevel(playerid, 0);

		format(Array, sizeof(Array), "* %s recovers from the taser, standing up on their feet.", GetName(playerid));
		SendNearbyMessage(playerid, Array, SCRIPTPURPLE, 30.0);
	}
	return 1;
}

forward FindUpdate(playerid, id);
public FindUpdate(playerid, id) 
{
	if(GetPVarType(playerid, "AcceptedPatient") > 0 && Player[playerid][Injured] != 2)
	{
		SendClientMessage(playerid, WHITE, "The patient has died and was sent to the hospital.");
		KillTimer(GetPVarInt(playerid, "AcceptedPatient"));
		DeletePVar(playerid, "AcceptedPatient");
		DisablePlayerCheckpointEx(playerid);
	}
	new Float:Pos[3];
	GetPlayerPos(id, Pos[0], Pos[1], Pos[2]);

	SetPlayerCheckpoint(playerid, Pos[0], Pos[1], Pos[2], 4.0);
	return 1;
}

forward DragTimer(playerid, id);
public DragTimer(playerid, id) 
{
	new Float:Pos[3];
	GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);

	SetPlayerPos(id, Pos[0], Pos[1] + 0.8, Pos[2]);
	return 1;
}