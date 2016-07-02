#include <YSI\y_hooks>

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys & KEY_YES) 
	{
		if(GetPVarInt(playerid, "StreamPrep") > 0) return SendClientMessage(playerid, WHITE, "Please wait for your stream prep to end!");
		
		for(new i; i < MAX_HOUSES; i++)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.0, House[i][HousePos][0], House[i][HousePos][1], House[i][HousePos][2]) && House[i][HouseVW][0] == GetPlayerVirtualWorld(playerid) && House[i][HouseInt][0] == GetPlayerInterior(playerid))
			{
				if(House[i][Locked] == 0)
				{
					SetPlayerPos(playerid, House[i][HousePos][4], House[i][HousePos][5], House[i][HousePos][6]);
					SetPlayerFacingAngle(playerid, House[i][HousePos][7]);
					SetPlayerVirtualWorld(playerid, House[i][HouseVW][1]);
					SetPlayerInterior(playerid, House[i][HouseInt][1]);

					SetCameraBehindPlayer(playerid);
					if(House[i][Custom][1] > 0) PrepareStream(playerid);
				}
				else return SendClientMessage(playerid, WHITE, "This house is locked!");
			}
			else if(IsPlayerInRangeOfPoint(playerid, 2.0, House[i][HousePos][4], House[i][HousePos][5], House[i][HousePos][6]) && House[i][HouseVW][1] == GetPlayerVirtualWorld(playerid) && House[i][HouseInt][1] == GetPlayerInterior(playerid))
			{
				SetPlayerPos(playerid, House[i][HousePos][0], House[i][HousePos][1], House[i][HousePos][2]);
				SetPlayerFacingAngle(playerid, House[i][HousePos][3]);
				SetPlayerVirtualWorld(playerid, House[i][HouseVW][0]);
				SetPlayerInterior(playerid, House[i][HouseInt][0]);

				SetCameraBehindPlayer(playerid);
				if(House[i][Custom][0] > 0) PrepareStream(playerid);
			}
		}
		for(new i; i < MAX_BUSINESSES; i++)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.0, Business[i][BizPos][0], Business[i][BizPos][1], Business[i][BizPos][2]) && Business[i][BizVW][0] == GetPlayerVirtualWorld(playerid) && Business[i][BizInt][0] == GetPlayerInterior(playerid))
			{
				if(Business[i][BizLocked] == 0)
				{
					SetPlayerPos(playerid, Business[i][BizPos][4], Business[i][BizPos][5], Business[i][BizPos][6]);
					SetPlayerFacingAngle(playerid, Business[i][BizPos][7]);
					SetPlayerVirtualWorld(playerid, Business[i][BizVW][1]);
					SetPlayerInterior(playerid, Business[i][BizInt][1]);

					SetCameraBehindPlayer(playerid);
					Player[playerid][InsideBusiness] = i;
					if(Business[i][BizCustom][1] > 0) PrepareStream(playerid);
				}
				else return SendClientMessage(playerid, WHITE, "This business is locked!");
			}
			else if(IsPlayerInRangeOfPoint(playerid, 2.0, Business[i][BizPos][4], Business[i][BizPos][5], Business[i][BizPos][6]) && Business[i][BizVW][1] == GetPlayerVirtualWorld(playerid) && Business[i][BizInt][1] == GetPlayerInterior(playerid))
			{
				SetPlayerPos(playerid, Business[i][BizPos][0], Business[i][BizPos][1], Business[i][BizPos][2]);
				SetPlayerFacingAngle(playerid, Business[i][BizPos][3]);
				SetPlayerVirtualWorld(playerid, Business[i][BizVW][0]);
				SetPlayerInterior(playerid, Business[i][BizInt][0]);

				SetCameraBehindPlayer(playerid);
				Player[playerid][InsideBusiness] = -1;
				if(Business[i][BizCustom][0] > 0) PrepareStream(playerid);
			}
		}
		for(new i; i < MAX_DOORS; i++)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.0, Door[i][DoorPos][0], Door[i][DoorPos][1], Door[i][DoorPos][2]) && Door[i][DoorInt][0] == GetPlayerInterior(playerid) && Door[i][DoorVW][0] == GetPlayerVirtualWorld(playerid))
			{
				if(Door[i][DoorLocked] == 0)
				{
					if(Door[i][DoorGroup] > -1 && Door[i][Restricted] > 0 && Player[playerid][PlayerGroup] != Door[i][DoorGroup]) return SendClientMessage(playerid, WHITE, "This door is restricted to a group.");
					if(Door[i][Restricted] > 0 && Door[i][DoorGroup] == -1 && Player[playerid][AdminDuty] == 0) return SendClientMessage(playerid, WHITE, "This door is restricted by an administrator.");

					if(Door[i][Vehicleable] > 0) SetPlayerPosEx(playerid, Door[i][DoorPos][4], Door[i][DoorPos][5], Door[i][DoorPos][6], Door[i][DoorPos][7], Door[i][DoorInt][1], Door[i][DoorVW][1]);
					else 
					{
						SetPlayerPos(playerid, Door[i][DoorPos][4], Door[i][DoorPos][5], Door[i][DoorPos][6]);
						SetPlayerFacingAngle(playerid, Door[i][DoorPos][7]);
						SetPlayerVirtualWorld(playerid, Door[i][DoorVW][1]);
						SetPlayerInterior(playerid, Door[i][DoorInt][1]);
					}

					SetCameraBehindPlayer(playerid);
					if(Door[i][DoorCustom][1] > 0) PrepareStream(playerid);
				}
				else return SendClientMessage(playerid, WHITE, "This door is locked!");
			}
			if(IsPlayerInRangeOfPoint(playerid, 2.0, Door[i][DoorPos][4], Door[i][DoorPos][5], Door[i][DoorPos][6]) && Door[i][DoorInt][1] == GetPlayerInterior(playerid) && Door[i][DoorVW][1] == GetPlayerVirtualWorld(playerid))
			{
				if(Door[i][DoorLocked] == 0)
				{
					if(Door[i][DoorGroup] > -1 && Door[i][Restricted] > 0 && Player[playerid][PlayerGroup] != Door[i][DoorGroup]) return SendClientMessage(playerid, WHITE, "This door is restricted to a group.");
					if(Door[i][Restricted] > 0 && Door[i][DoorGroup] == -1 && Player[playerid][AdminDuty] == 0) return SendClientMessage(playerid, WHITE, "This door is restricted by an administrator.");

					if(Door[i][Vehicleable] > 0) SetPlayerPosEx(playerid, Door[i][DoorPos][0], Door[i][DoorPos][1], Door[i][DoorPos][2], Door[i][DoorPos][3], Door[i][DoorInt][0], Door[i][DoorVW][0]);
					else 
					{
						SetPlayerPos(playerid, Door[i][DoorPos][0], Door[i][DoorPos][1], Door[i][DoorPos][2]);
						SetPlayerFacingAngle(playerid, Door[i][DoorPos][3]);
						SetPlayerVirtualWorld(playerid, Door[i][DoorVW][0]);
						SetPlayerInterior(playerid, Door[i][DoorInt][0]);
					}

					SetCameraBehindPlayer(playerid);
					if(Door[i][DoorCustom][0] > 0) PrepareStream(playerid);
				}
				else return SendClientMessage(playerid, WHITE, "This door is locked!");
			}
		}
	}
	return 1;
}