task OneSecond[1000]()
{
	for(new i; i < MAX_PLAYERS; i++)
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

		if(IsPlayerInAnyVehicle(i) && PLAYER_STATE_DRIVER)
		{
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
				
			switch(GetPlayerSpeed(i, 1))
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
	OneMinuteInt++;

    if(GlobalMinute == 60)
    {
    	SetTime();
    	format(Array, sizeof(Array), "The time is now %d:00.", GlobalHour);
    	SendClientMessageToAll(GREY, Array);
    }

	for(new i; i < MAX_PLAYERS; i++)
	{
    	switch(OneMinuteInt)
    	{
    		case 5:
    		{
    			OneMinuteInt = 0;
    		
    			SavePlayerData(i, 1);
    			print("[TIMER] Saved Player Data Automatically.");
    		}
    	}

		SetPVarInt(i, "LastTyped", GetPVarInt(i, "LastTyped") + 1);
	}
	for(new i = 0; i < MAX_VEHICLES; i++)
    {
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