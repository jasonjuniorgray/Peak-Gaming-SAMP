#include <YSI\y_hooks>

new Boating[MAX_PLAYERS];

CMD:boat(playerid, params[]) {
    new loc = random(5);
    if(Boating[playerid] == 1) {
        SendClientMessage(playerid, 0xFFFFFFFF, "You are already boating and so cancelled your current task.");
        Boating[playerid] = 0;
        DisablePlayerCheckpoint(playerid);
        return 1;
    }
    else {
        switch(loc) {
            case 1: {
                SetPlayerCheckpoint(playerid, 2178.8328,-133.5713,2.1615, 3.0);
                Boating[playerid] = 1;
                SendClientMessage(playerid, 0xFFFFFFFF, "You have started boating. Goto the checkpoint to begin!");
            }
            case 2: {
                SetPlayerCheckpoint(playerid, 2153.1582,-115.9479,1.6017, 3.0);
                Boating[playerid] = 1;
                SendClientMessage(playerid, 0xFFFFFFFF, "You have started boating. Goto the checkpoint to begin!");
            }
            case 3: {
                SetPlayerCheckpoint(playerid, 2132.6208,-96.0706,1.6111, 3.0);
                Boating[playerid] = 1;
                SendClientMessage(playerid, 0xFFFFFFFF, "You have started boating. Goto the checkpoint to begin!");
            }
            case 4: {
                SetPlayerCheckpoint(playerid, 2124.3271,-66.7647,1.3897, 3.0);
                Boating[playerid] = 1;
                SendClientMessage(playerid, 0xFFFFFFFF, "You have started boating. Goto the checkpoint to begin!");
            }
            case 5: {
                SetPlayerCheckpoint(playerid, 2126.0161,-46.6536,1.5936, 3.0);
                Boating[playerid] = 1;
                SendClientMessage(playerid, 0xFFFFFFFF, "You have started boating. Goto the checkpoint to begin!");
            }
        }
    }
    return 1;
}
 
hook OnPlayerEnterCheckpoint(playerid) {
    // Start
    if(IsPlayerInRangeOfPoint(playerid,5, 2178.8328,-133.5713,2.1615)) {
        CreateVehicle(446, 2181.7791,-142.7276,-0.6040, 0, 1, 1, 2, 0);
        SendClientMessage(playerid, 0xFFFFFFFF, "Enter the boat and goto the checkpoint to collect your reward!");
        SetPlayerCheckpoint(playerid, -58.2357,-584.7678,-0.2456, 3.0);
    }
    else if(IsPlayerInRangeOfPoint(playerid,5, 2153.1582,-115.9479,1.6017)) {
        CreateVehicle(446, 2139.8879,-135.7938,-0.5350, 0, 1, 1, 2, 0);
        SendClientMessage(playerid, 0xFFFFFFFF, "Enter the boat and goto the checkpoint to collect your reward!");
        SetPlayerCheckpoint(playerid, -58.2357,-584.7678,-0.2456, 3.0);
    }
    else if(IsPlayerInRangeOfPoint(playerid,5, 2132.6208,-96.0706,1.6111)) {
        CreateVehicle(446, 2108.8984,-111.3230,-0.5456, 0, 1, 1, 2, 0);
        SendClientMessage(playerid, 0xFFFFFFFF, "Enter the boat and goto the checkpoint to collect your reward!");
        SetPlayerCheckpoint(playerid, -58.2357,-584.7678,-0.2456, 3.0);
    }
    else if(IsPlayerInRangeOfPoint(playerid,5, 2124.3271,-66.7647,1.3897)) {
        CreateVehicle(446, 2091.8821,-74.3432,-0.5304, 0, 1, 1, 2, 0);
        SendClientMessage(playerid, 0xFFFFFFFF, "Enter the boat and goto the checkpoint to collect your reward!");
        SetPlayerCheckpoint(playerid, -58.2357,-584.7678,-0.2456, 3.0);
    }
    else if(IsPlayerInRangeOfPoint(playerid,5, 2126.0161,-46.6536,1.5936)) {
        CreateVehicle(446, 2113.3601,-41.5751,-0.5058, 0, 1, 1, 2, 0);
        SendClientMessage(playerid, 0xFFFFFFFF, "Enter the boat and goto the checkpoint to collect your reward!");
        SetPlayerCheckpoint(playerid, -58.2357,-584.7678,-0.2456, 3.0);
    }
    else if(IsPlayerInRangeOfPoint(playerid,5, -58.2357,-584.7678,-0.2456)) {
        if(Boating[playerid] == 0) {
            SendClientMessage(playerid, 0xFFFFFFFF, "You must be boating!");
            DisablePlayerCheckpoint(playerid);
            return 1;
        }
        else {
           SendClientMessage(playerid, 0xFFFFFFFF, "You have completed your boating trip and earned $500!");
           Boating[playerid] = 0;
           GivePlayerMoney(playerid, 500);
           DisablePlayerCheckpoint(playerid);
           RemovePlayerFromVehicle(playerid);
           return 1;
        }
    }
    return 1;
}