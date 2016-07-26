OnPlayerLoginForward(playerid)
{
	SetPlayerHealth(playerid, Player[playerid][Health]);
   	SetPlayerArmour(playerid, Player[playerid][Armour]);
    SetPlayerInterior(playerid, Player[playerid][Interior]);
    SetPlayerVirtualWorld(playerid, Player[playerid][VirtualWorld]);
    GivePlayerSavedWeapons(playerid);
    GivePlayerMoney(playerid, Player[playerid][Money]);
    SetPlayerArmedWeapon(playerid, 0);
    SetPlayerFightingStyle(playerid, Player[playerid][Fightstyle]);

    SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL, 1);
    SetPlayerSkillLevel(playerid, WEAPONSKILL_MICRO_UZI, 1);
    SetPlayerSkillLevel(playerid, WEAPONSKILL_SAWNOFF_SHOTGUN, 1);

    if(Player[playerid][Interior] > 0) PrepareStream(playerid);
    else TogglePlayerControllableEx(playerid, TRUE);

    for(new i; i < MAX_PLAYER_VEHICLES; i++)
    {
        if(Player[playerid][CarModel][i] != 0)
        {
            Player[playerid][CarID][i] = CreateVehicle(Player[playerid][CarModel][i], Player[playerid][CarX][i], Player[playerid][CarY][i], Player[playerid][CarZ][i], Player[playerid][CarA][i], Player[playerid][CarColour][i], Player[playerid][CarColour2][i], -1, 0);
            switch(i)
            {
                case 0: SetVehicleNumberPlate(Player[playerid][CarID][i], Player[playerid][CarPlate1]);
                case 1: SetVehicleNumberPlate(Player[playerid][CarID][i], Player[playerid][CarPlate2]);
                case 2: SetVehicleNumberPlate(Player[playerid][CarID][i], Player[playerid][CarPlate3]);
                case 3: SetVehicleNumberPlate(Player[playerid][CarID][i], Player[playerid][CarPlate4]);
                case 4: SetVehicleNumberPlate(Player[playerid][CarID][i], Player[playerid][CarPlate5]);
                default: return 1;
            }

            if(Player[playerid][CarPaintJob][i] > 0) ChangeVehiclePaintjob(Player[playerid][CarID][i], Player[playerid][CarPaintJob][i] - 1);

            Fuel[Player[playerid][CarID][i]] = Player[playerid][CarFuel][i];
        }
    }

    AddPlayerVehicleMods(playerid);

    if(Player[playerid][OnDuty] == 0 && Player[playerid][PlayerGroup] >= 0) SetPlayerColor(playerid, Group[Player[playerid][PlayerGroup]][GroupColour] * 256 + 255);
    if(Player[playerid][OnDuty] == 0 && Player[playerid][PlayerGroup] < 0 || Player[playerid][OnDuty]) SetPlayerColor(playerid, WHITE);

    if(Player[playerid][Injured] > 0)
    {
        SetPlayerPosEx(playerid, 1201.12, -1324, -80.0, 0.0, 0, 0);
        TogglePlayerControllableEx(playerid, FALSE);

        SetPlayerCameraPos(playerid, 1207.39, -1294.71, 24.61);
        SetPlayerCameraLookAt(playerid, 1181.72, -1322.65, 13.58);

        SetTimerEx("LimboTimer", 15000, FALSE, "i", playerid);
        SetPlayerHealth(playerid, 15.0);
    }
    
    if(Player[playerid][Crimes] > 0) SetPlayerWantedLevel(playerid, Player[playerid][Crimes]);

    format(Array, sizeof(Array), "%s has logged in as a %s.", GetName(playerid), GetPlayerAdminLevel(playerid));
    if(Player[playerid][AdminLevel] >= 1) SendToAdmins(ORANGE, Array, 0, 1);
	ClearChat(playerid, 1);

	format(Array, sizeof(Array), "Welcome back, %s.", GetName(playerid));
	SendClientMessage(playerid, WHITE, Array);
    if(Player[playerid][AdminLevel] >= 1)
    {
    	format(Array, sizeof(Array), "You are logged in as a(n) %s.", GetPlayerAdminLevel(playerid));
    	SendClientMessage(playerid, GREY, Array);
    }
    if(Player[playerid][LotteryNumber] == -1) 
    {
    	Player[playerid][LotteryNumber] = 0;
    	SendClientMessage(playerid, GREY, "While you were offline, you won the lottery and the money was automatically added to your account.");
    }

    Player[playerid][Authenticated] = 1; // Always keep this as low as possible in this function. This function is important as when it's 1 the player's data can be saved. If they're not spawned we shouldn't be saving their data!
    return 1;
}