#include <YSI\y_hooks>

CMD:getpizza(playerid, params[])
{
    if(IsPlayerConnectedEx(playerid))
    {
        if(Job[Player[playerid][PlayerJob]][JobType] == 7)
        {
            if(Vehicle[GetRealVehicleID(GetPlayerVehicleID(playerid))][Model] != 0 && Vehicle[GetRealVehicleID(GetPlayerVehicleID(playerid))][VehicleJob] == Player[playerid][PlayerJob])
            {
                for(new i; i < MAX_POINTS; i++)
                {
                    if(IsPlayerInRangeOfPoint(playerid, 3.0, Point[i][poPos][0], Point[i][poPos][1], Point[i][poPos][2]) && Point[i][poType] == 3)
                    {
                        if(GetPlayerVirtualWorld(playerid) == Point[i][pointVW])
                        {
                            if(GetPVarInt(playerid, "Checkpoint") >= 1) return SendClientMessage(playerid, WHITE, "You already have an active checkpoint. Reach it, or type /killcheckpoint to clear it.");

                            new rand = random(MAX_HOUSES), d;
                            /*while(!(House[rand][Owned] >= 1 && House[rand][HouseVW][0] == GetPlayerVirtualWorld(playerid) && House[rand][HouseInt][0] == GetPlayerInterior(playerid))) 
                            {
                                if(rand++ >= MAX_HOUSES) rand = 0;
                                if(d++ > MAX_HOUSES) return 1;
                            }*/ 

                            // Uncomment when more houses are owned.

                            while(!(House[rand][HousePos][0] != 0.0000 && House[rand][HouseVW][0] == GetPlayerVirtualWorld(playerid) && House[rand][HouseInt][0] == GetPlayerInterior(playerid))) 
                            {
                                if(rand++ >= MAX_HOUSES) rand = 0;
                                if(d++ > MAX_HOUSES) return 1;
                            }

                            SetPlayerCheckpointEx(playerid, House[rand][HousePos][0], House[rand][HousePos][1], House[rand][HousePos][2], 5.0);
                            SetPVarInt(playerid, "PizzaRun", 1);
                            SetPVarInt(playerid, "PizzaPoint", i);

                            SendClientMessage(playerid, WHITE, "You have three minutes to deliver the pizza to the house marked on your minimap!");
                            break;
                        }
                    }
                }
            }
            else return SendClientMessage(playerid, WHITE, "You are not on a pizza bike!");
        }
        else return SendClientMessage(playerid, WHITE, "You are not a pizza boy!");
    }
    return 1;
}

hook OnPlayerEnterCheckpoint(playerid)
{
    if(GetPVarInt(playerid, "PizzaRun") >= 1)
    {
        if(Job[Player[playerid][PlayerJob]][JobType] == 7)
        {
            DisablePlayerCheckpointEx(playerid);

            new Distance;
            Distance = floatround(GetPlayerDistanceFromPoint(playerid, Point[GetPVarInt(playerid, "PizzaPoint")][poPos][0], Point[GetPVarInt(playerid, "PizzaPoint")][poPos][1], Point[GetPVarInt(playerid, "PizzaPoint")][poPos][2]));
            
            new time = 300 - GetPVarInt(playerid, "PizzaRun"), realpay = Distance / 75 * time / 3;
            
            GiveMoneyEx(playerid, realpay);

            format(Array, sizeof(Array), "You delivered the pizza in time and received $%s.", FormatNumberToString(realpay));
            SendClientMessage(playerid, WHITE, Array);

            DeletePVar(playerid, "PizzaRun");
            DeletePVar(playerid, "PizzaPoint");
            DisablePlayerCheckpointEx(playerid);
        }
        else 
        {
            DeletePVar(playerid, "PizzaRun");
            DeletePVar(playerid, "PizzaPoint");
            DisablePlayerCheckpointEx(playerid);
            return SendClientMessage(playerid, WHITE, "You are not a pizza boy!");
        }
    }
    return 1;
}