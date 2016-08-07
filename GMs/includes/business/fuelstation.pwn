CMD:refuel(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid), PricePlayerPays;
    for(new i = 0; i < MAX_BUSINESSES; i++)
    {
		if(IsPlayerInRangeOfPoint(playerid, 5.0, Business[i][FuelLocation][0], Business[i][FuelLocation][1], Business[i][FuelLocation][2]))
		{
			if(IsPlayerInAnyVehicle(playerid))
			{
                if(Fuel[vehicleid] == -1) return SendClientMessage(playerid, WHITE, "You cannot refuel this vehicle!");
                new engine,lights,alarm,doors,bonnet,boot,objective;
                GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
                if(engine == VEHICLE_PARAMS_ON) return SendClientMessage(playerid, WHITE, "You have to turn your engine off before you can refill!");
                new PriceofFuel = Fuel[vehicleid] - 100; 
			    PricePlayerPays = PriceofFuel * Business[i][FuelPrice]; // This will make it negative, so we actually want to give it to the player.
                if(Player[playerid][Money] >= PricePlayerPays)
                {
                    Fuel[vehicleid] = 100;
                    GiveMoneyEx(playerid, PricePlayerPays);
                    SendClientMessage(playerid, WHITE, "You have refilled your vehicle successfully!");
                }
                else
                {
					return SendClientMessage(playerid, WHITE, "You do not have enough money to refill!");
                }
			}
			else
            {
                SendClientMessage(playerid, WHITE, "You must be in a vehicle to refill!");
            }
		}
    }
    return 1;
}