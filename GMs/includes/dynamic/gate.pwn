#include <YSI\y_hooks>

CMD:gate(playerid)
{
    for(new i = 0; i < MAX_GATES; i++)
    {
    	if(Gate[i][GateGroup] > -1)
    	{
        	if(Player[playerid][PlayerGroup] == Gate[i][GateGroup] && Player[playerid][GroupRank] >= Gate[playerid][GateRank] && IsPlayerInRangeOfPoint(playerid, Gate[i][GateRange], Gate[i][GatePos][0], Gate[i][GatePos][1], Gate[i][GatePos][2]))
        	{
        		Array[0] = 0;
            	if(Gate[i][UseF] >= 1) return 1;
            
            	if(Gate[i][GateStatus] == 0)
            	{
            		MoveDynamicObject(Gate[i][GateID], Gate[i][GateMove][0], Gate[i][GateMove][1], Gate[i][GateMove][2], Gate[i][GateSpeed], Gate[i][GateMoveRot][0], Gate[i][GateMoveRot][1], Gate[i][GateMoveRot][2]);
            		Gate[i][GateStatus] = 1;
            	
            		format(Array, sizeof(Array), "%s uses their remote to open the gates.", GetName(playerid));
            		SetPlayerChatBubble(playerid, Array, PURPLE, 15.0, 5000);
				}
				else if(Gate[i][GateStatus] == 1)
            	{
            		MoveDynamicObject(Gate[i][GateID], Gate[i][GatePos][0], Gate[i][GatePos][1], Gate[i][GatePos][2], Gate[i][GateSpeed], Gate[i][GateRot][0], Gate[i][GateRot][1], Gate[i][GateRot][2]);
             		Gate[i][GateStatus] = 0;
            		
            		format(Array, sizeof(Array), "%s uses their remote to close the gates.", GetName(playerid));
            		SetPlayerChatBubble(playerid, Array, PURPLE, 15.0, 5000);
				}
        	}
        }
    }
	return 1;
}

CMD:pgate(playerid, params[])
{
	new Usage[50];
	if(sscanf(params, "s[50]", Usage))
	{
	    return SendClientMessage(playerid, WHITE, "SYNTAX: /pgate [password]");
	}
	for(new i = 0; i < MAX_GATES; i++)
	{
		if(IsPlayerInRangeOfPoint(playerid, Gate[i][GateRange], Gate[i][GatePos][0], Gate[i][GatePos][1], Gate[i][GatePos][2]))
		{
			if(strfind(Gate[i][GateOwner], "Nobody", true) == -1)
   			{
        		if(strcmp(Usage, Gate[i][GatePass], true) == 0)
        		{
        			Array[0] = 0;
        			if(Gate[i][GateStatus] == 0)
            		{
            			MoveDynamicObject(Gate[i][GateID], Gate[i][GateMove][0], Gate[i][GateMove][1], Gate[i][GateMove][2], Gate[i][GateSpeed], Gate[i][GateMoveRot][0], Gate[i][GateMoveRot][1], Gate[i][GateMoveRot][2]);
            			Gate[i][GateStatus] = 1;
            	
            			format(Array, sizeof(Array), "%s uses their remote to open the gates.", GetName(playerid));
            			SetPlayerChatBubble(playerid, Array, PURPLE, 15.0, 5000);
					}
					else if(Gate[i][GateStatus] == 1)
            		{
            			MoveDynamicObject(Gate[i][GateID], Gate[i][GatePos][0], Gate[i][GatePos][1], Gate[i][GatePos][2], Gate[i][GateSpeed], Gate[i][GateRot][0], Gate[i][GateRot][1], Gate[i][GateRot][2]);
             			Gate[i][GateStatus] = 0;
            		
            			format(Array, sizeof(Array), "%s uses their remote to close the gates.", GetName(playerid));
            			SetPlayerChatBubble(playerid, Array, PURPLE, 15.0, 5000);
            		}
				}
       		}
       	}
    }
    return 1;
}

CMD:gatepass(playerid, params[])
{
	new Usage[50];
	if(sscanf(params, "s[50]", Usage))
	{
	    return SendClientMessage(playerid, WHITE, "SYNTAX: /gatepass [password]");
	}
	for(new i = 0; i < MAX_GATES; i++)
	{
		if(IsPlayerInRangeOfPoint(playerid, Gate[i][GateRange], Gate[i][GatePos][0], Gate[i][GatePos][1], Gate[i][GatePos][2]))
		{
			if(strfind(Gate[i][GateOwner], GetName(playerid), true) != -1 || Player[playerid][AdminLevel] >= 5 && Player[playerid][AdminDuty] > 0)
   			{
   				Array[0] = 0;
        		format(Gate[i][GatePass], 50, "%s", Usage);

        		format(Array, sizeof(Array), "You have changed the password for your gate (%d) to: %s", i, Usage);
        		SendClientMessage(playerid, WHITE, Array);  

        		format(Array, sizeof(Array), "[/GATEPASS] %s has edited the password of gate %d to %s", GetName(playerid), i, Gate[i][GatePass]);
        		Log(12, Array);

        		SaveGate(i);
        		return 1;      			
       		}
       	}
    }
    SendClientMessage(playerid, WHITE, "You are not near a gate you own!");
    return 1;
}

CMD:nextgate(playerid, params[])
{
    if(Player[playerid][AdminLevel] >= 5)
    {
        for(new i; i < MAX_GATES; i++)
        {
            if(Gate[i][GateModel] == 0) 
            {
                Array[0] = 0;
                format(Array, sizeof(Array), "The next available gate ID is %d.", i);
                SendClientMessage(playerid, WHITE, Array);
                break;
            }
        }
    }
    else SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
    return 1;
}

CMD:editgate(playerid, params[])
{
	new id, Usage[50], Float:value;
	if(sscanf(params, "ds[128]F(0)", id, Usage, value))
	{
	    if(Player[playerid][AdminLevel] >= 5)
	    {
		    SendClientMessage(playerid, WHITE, "SYNTAX: /editgate [gateid] [usage] [value]");
			return SendClientMessage(playerid, GREY, "Usages: position, model, spawn, move, owner, group, grouprank, F, speed, range, delete");
		}
	}
	else if(Player[playerid][AdminLevel] >= 5)
	{
	    if(id < 0 || id > MAX_GATES) return SendClientMessage(playerid, WHITE, "That is not a valid gate ID!");
		Array[0] = 0;
	    if(strcmp(Usage, "position", true) == 0)
       	{
        	new Float:Pos[3];
			GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
				
 			Gate[id][GatePos][0] = Pos[0];
			Gate[id][GatePos][1] = Pos[1];
			Gate[id][GatePos][2] = Pos[2];
			Gate[id][GateRot][0] = 0.0;
			Gate[id][GateRot][1] = 0.0;
			Gate[id][GateRot][2] = 0.0;
					
			Gate[id][GateVW] = GetPlayerVirtualWorld(playerid);
			Gate[id][GateInt] = GetPlayerInterior(playerid);

			format(Array, sizeof(Array), "You have moved the position of gate %d", id);
			SendClientMessage(playerid, WHITE, Array);

			format(Array, sizeof(Array), "[/EDITGATE] %s has moved the position of gate %d to X: %f, Y: %f, Z: %f", GetName(playerid), id, Pos[0], Pos[1], Pos[2]);
		}
		else if(strcmp(Usage, "model", true) == 0)
        {
            new value2 = floatround(value, floatround_round);
                    
 			Gate[id][GateModel] = value2;

 			format(Array, sizeof(Array), "You have changed the model of gate %d", id);
			SendClientMessage(playerid, WHITE, Array);

			format(Array, sizeof(Array), "[/EDITGATE] %s has changed the model of gate %d to %d", GetName(playerid), id, value2);
		}
		else if(strcmp(Usage, "spawn", true) == 0)
        {
			DestroyDynamicObject(Gate[id][GateID]);
			Gate[id][GateID] = CreateDynamicObject(Gate[id][GateModel], Gate[id][GatePos][0], Gate[id][GatePos][1], Gate[id][GatePos][2], Gate[id][GateRot][0], Gate[id][GateRot][1], Gate[id][GateRot][2], Gate[id][GateVW], Gate[id][GateInt], -1, 150.0);
					
			SetPVarInt(playerid, "EditingAGate", 1);
			SetPVarInt(playerid, "EditingGate", id);
			EditDynamicObject(playerid, Gate[id][GateID]);
			return 1;
		}
		else if(strcmp(Usage, "move", true) == 0)
        {
			DestroyDynamicObject(Gate[id][GateID]);
			Gate[id][GateID] = CreateDynamicObject(Gate[id][GateModel], Gate[id][GatePos][0], Gate[id][GatePos][1], Gate[id][GatePos][2], Gate[id][GateRot][0], Gate[id][GateRot][1], Gate[id][GateRot][2], Gate[id][GateVW], Gate[id][GateInt], -1, 150.0);

            SetPVarInt(playerid, "EditingAGate", 2);
            SetPVarInt(playerid, "EditingGate", id);
			EditDynamicObject(playerid, Gate[id][GateID]);
        	return 1;
		}
		else if(strcmp(Usage, "owner", true) == 0)
        {
            new value2 = floatround(value, floatround_round);
            
            format(Gate[id][GateOwner], MAX_PLAYER_NAME, "%s", GetName(value2));
            Gate[id][GateGroup] = -1;
            Gate[id][GateRank] = -1;

 			format(Array, sizeof(Array), "You have edited the owner of gate %d to the %s.", id, Gate[id][GateOwner]);
			SendClientMessage(playerid, WHITE, Array);

			format(Array, sizeof(Array), "[/EDITGATE] %s has edited the owner of gate %d to the %s(%d)", GetName(playerid), id, Gate[id][GateOwner]);
		}
		else if(strcmp(Usage, "group", true) == 0)
        {
            new value2 = floatround(value, floatround_round);
                   
 			Gate[id][GateGroup] = value2 - 1;

 			format(Array, sizeof(Array), "You have edited the group of gate %d to the %s.", id, Group[value2 - 1][GroupName]);
			SendClientMessage(playerid, WHITE, Array);

			format(Array, sizeof(Array), "[/EDITGATE] %s has edited the group of gate %d to the %s(%d)", GetName(playerid), id, Group[value2 - 1][GroupName], value2 - 1);
		}
		else if(strcmp(Usage, "grouprank", true) == 0)
        {
            new value2 = floatround(value, floatround_round);
                    
 			Gate[id][GateRank] = value2;

 			format(Array, sizeof(Array), "You have edited the group rank of gate %d to %d", id, value2);
			SendClientMessage(playerid, WHITE, Array);

			format(Array, sizeof(Array), "[/EDITGATE] %s has edited the group rank of gate %d to %d", GetName(playerid), id, value2);
		}
		else if(strcmp(Usage, "F", true) == 0)
        {
            new value2 = floatround(value, floatround_round);
                    
 			Gate[id][UseF] = value2;
 			SendClientMessage(playerid, WHITE, "You have successfully edited the gate's open method.");

 			format(Array, sizeof(Array), "You have edited the open method of gate %d.", id, value2);
			SendClientMessage(playerid, WHITE, Array);

			format(Array, sizeof(Array), "[/EDITGATE] %s has edited the open method of gate %d to %d", GetName(playerid), id, value2);
		}
		else if(strcmp(Usage, "speed", true) == 0)
        {
 			Gate[id][GateSpeed] = value;
 			SendClientMessage(playerid, WHITE, "You have successfully edited the gate's speed.");

 			format(Array, sizeof(Array), "You have edited the speed of gate %d to %f", id, value);
			SendClientMessage(playerid, WHITE, Array);

			format(Array, sizeof(Array), "[/EDITGATE] %s has edited the speed of gate %d to %f", GetName(playerid), id, value);
		}
		else if(strcmp(Usage, "range", true) == 0)
        {
 			Gate[id][GateRange] = value;
 			SendClientMessage(playerid, WHITE, "You have successfully edited the gate's range.");

 			format(Array, sizeof(Array), "You have edited the range of gate %d to %f", id, value);
			SendClientMessage(playerid, WHITE, Array);

			format(Array, sizeof(Array), "[/EDITGATE] %s has edited the range of gate %d to %f", GetName(playerid), id, value);
		}
		else if(strcmp(Usage, "delete", true) == 0)
		{
			Gate[id][GateModel] = 0;

			Gate[id][GatePos][0] = 0.0000;
			Gate[id][GatePos][1] = 0.0000;
			Gate[id][GatePos][2] = 0.0000;

			Gate[id][GateRot][0] = 0.0000;
			Gate[id][GateRot][1] = 0.0000;
			Gate[id][GateRot][2] = 0.0000;

			Gate[id][GateMove][0] = 0.0000;
			Gate[id][GateMove][1] = 0.0000;
			Gate[id][GateMove][2] = 0.0000;

			Gate[id][GateMoveRot][0] = 0.0000;
			Gate[id][GateMoveRot][1] = 0.0000;
			Gate[id][GateMoveRot][2] = 0.0000;

			Gate[id][GateSpeed] = 0.0000;
			Gate[id][GateRange] = 0.0000;
					
			Gate[id][GateGroup] = -1;
			Gate[id][GateRank] = -1;

			Gate[id][GateVW] = 0;
			Gate[id][GateInt] = 0;

			Gate[id][UseF] = 0;

			format(Array, sizeof(Array), "You have deleted gate %d", id);
			SendClientMessage(playerid, WHITE, Array);

			format(Array, sizeof(Array), "[/EDITGATE] %s has deleted gate %d", GetName(playerid), id);
		}
		else
		{
			SendClientMessage(playerid, WHITE, "SYNTAX: /editgate [gateid] [usage] [value]");
			return SendClientMessage(playerid, GREY, "Usages: position, model, spawn, move, group, grouprank, F, speed, range, delete");
		}
		
		SaveGate(id);
		Log(12, Array);
	}
	return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if((newkeys & KEY_SECONDARY_ATTACK) && !(oldkeys & KEY_SECONDARY_ATTACK))
	{
    	for(new i = 0; i < MAX_GATES; i++)
    	{
    		if(Gate[i][GateGroup] > -1)
    		{
        		if(Player[playerid][PlayerGroup] == Gate[i][GateGroup] && Player[playerid][GroupRank] >= Gate[playerid][GateRank] && IsPlayerInRangeOfPoint(playerid, Gate[i][GateRange], Gate[i][GatePos][0], Gate[i][GatePos][1], Gate[i][GatePos][2]) && Gate[i][UseF] >= 1)
        		{
        			Array[0] = 0;
            		if(Gate[i][GateStatus] == 0)
            		{
            			MoveDynamicObject(Gate[i][GateID], Gate[i][GateMove][0], Gate[i][GateMove][1], Gate[i][GateMove][2], Gate[i][GateSpeed], Gate[i][GateMoveRot][0], Gate[i][GateMoveRot][1], Gate[i][GateMoveRot][2]);
            			Gate[i][GateStatus] = 1;
            	
            			format(Array, sizeof(Array), "%s uses their remote to open the gates.", GetName(playerid));
            			SetPlayerChatBubble(playerid, Array, PURPLE, 15.0, 5000);
					}
					else if(Gate[i][GateStatus] == 1)
            		{
            			MoveDynamicObject(Gate[i][GateID], Gate[i][GatePos][0], Gate[i][GatePos][1], Gate[i][GatePos][2], Gate[i][GateSpeed], Gate[i][GateRot][0], Gate[i][GateRot][1], Gate[i][GateRot][2]);
             			Gate[i][GateStatus] = 0;
            		
            			format(Array, sizeof(Array), "%s uses their remote to close the gates.", GetName(playerid));
            			SetPlayerChatBubble(playerid, Array, PURPLE, 15.0, 5000);
					}
        		}
        	}	
    	}
    }
    return 1;
}

hook OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	if(response == EDIT_RESPONSE_FINAL)
	{
	    new object = GetPVarInt(playerid, "EditingGate");
		if(GetPVarInt(playerid, "EditingAGate") == 1)
		{   
		    Gate[object][GatePos][0] = x;
			Gate[object][GatePos][1] = y;
			Gate[object][GatePos][2] = z;
			Gate[object][GateRot][0] = rx;
			Gate[object][GateRot][1] = ry;
			Gate[object][GateRot][2] = rz;

			format(Array, sizeof(Array), "[/EDITGATE] %s has moved the spawn position of gate %d to X: %f, Y: %f, Z: %f, RX: %f, RY: %f, RZ: %f", GetName(playerid), object, x, y, z, rx, ry, rz);
		}
		if(GetPVarInt(playerid, "EditingAGate") == 2)
		{
		    Gate[object][GateMove][0] = x;
			Gate[object][GateMove][1] = y;
			Gate[object][GateMove][2] = z;
			Gate[object][GateMoveRot][0] = rx;
			Gate[object][GateMoveRot][1] = ry;
			Gate[object][GateMoveRot][2] = rz;

			format(Array, sizeof(Array), "[/EDITGATE] %s has moved the move position of gate %d to X: %f, Y: %f, Z: %f, RX: %f, RY: %f, RZ: %f", GetName(playerid), object, x, y, z, rx, ry, rz);
		}

		DeletePVar(playerid, "EditingAGate");
		DeletePVar(playerid, "EditingGate");
		SaveGate(object);
		Log(12, Array);
	}
	if(response == EDIT_RESPONSE_CANCEL)
	{
		if(GetPVarInt(playerid, "EditingAGate") >= 1)
		{
			new object = GetPVarInt(playerid, "EditingGate");
			DestroyDynamicObject(Gate[object][GateID]);
			if(Gate[object][GateModel] > 0) Gate[object][GateID] = CreateDynamicObject(Gate[object][GateModel], Gate[object][GatePos][0], Gate[object][GatePos][1], Gate[object][GatePos][2], Gate[object][GateRot][0], Gate[object][GateRot][1], Gate[object][GateRot][2], Gate[object][GateVW], Gate[object][GateInt], -1, 150.0);
			
			DeletePVar(playerid, "EditingAGate");
			DeletePVar(playerid, "EditingGate");
		}
	}
	return 1;
}

forward InitiateGates();
public InitiateGates()
{
    new rows, fields, gates;
    
    cache_get_data(rows, fields);
    for(new row; row < MAX_GATES; row++)
    {   
    	Gate[row][GateModel] = cache_get_field_content_int(row, "Model", SQL); 

        Gate[row][GatePos][0] = cache_get_field_content_float(row, "X", SQL);
        Gate[row][GatePos][1] = cache_get_field_content_float(row, "Y", SQL);
        Gate[row][GatePos][2] = cache_get_field_content_float(row, "Z", SQL);

        Gate[row][GateRot][0] = cache_get_field_content_float(row, "RX", SQL);
        Gate[row][GateRot][1] = cache_get_field_content_float(row, "RY", SQL);
        Gate[row][GateRot][2] = cache_get_field_content_float(row, "RZ", SQL);

        Gate[row][GateMove][0] = cache_get_field_content_float(row, "MX", SQL);
        Gate[row][GateMove][1] = cache_get_field_content_float(row, "MY", SQL);
        Gate[row][GateMove][2] = cache_get_field_content_float(row, "MZ", SQL);

        Gate[row][GateMoveRot][0] = cache_get_field_content_float(row, "MRX", SQL);
        Gate[row][GateMoveRot][1] = cache_get_field_content_float(row, "MRY", SQL);
        Gate[row][GateMoveRot][2] = cache_get_field_content_float(row, "MRZ", SQL);

        Gate[row][GateSpeed] = cache_get_field_content_float(row, "Speed", SQL);
        Gate[row][GateRange] = cache_get_field_content_float(row, "Range", SQL);

        Gate[row][GateVW] = cache_get_field_content_int(row, "VW", SQL); 
        Gate[row][GateInt] = cache_get_field_content_int(row, "Interior", SQL); 
        Gate[row][GateGroup] = cache_get_field_content_int(row, "Group", SQL); 
        Gate[row][GateRank] = cache_get_field_content_int(row, "Rank", SQL); 
        Gate[row][UseF] = cache_get_field_content_int(row, "F", SQL); 

        cache_get_field_content(row, "Owner", Gate[row][GateOwner], SQL, MAX_PLAYER_NAME);
        cache_get_field_content(row, "Password", Gate[row][GatePass], SQL, 50);

        DestroyDynamicObject(Gate[row][GateID]);
		if(Gate[row][GateModel] > 0) Gate[row][GateID] = CreateDynamicObject(Gate[row][GateModel], Gate[row][GatePos][0], Gate[row][GatePos][1], Gate[row][GatePos][2], Gate[row][GateRot][0], Gate[row][GateRot][1], Gate[row][GateRot][2], Gate[row][GateVW], Gate[row][GateInt], -1, 150.0);

        gates++;
    }
    switch(gates)
    {
        case 0: printf("[SCRIPT-LOAD/ERR] The script initiated 0 gates.", gates);
        default: printf("[SCRIPT-LOAD] The script has initiated %d gates", gates);
    }
}

SaveGate(id)
{
    Array[0] = 0;

    format(Array, sizeof Array, "UPDATE `gates` SET \
        `Model` = '%d', `X` = '%f', `Y` = '%f', `Z` = '%f', `RX` = %f, `RY` = '%f', `RZ` = '%f', `MX` = '%f', `MY` = %f, `MZ` = %f, `MRX` = %f, `MRY` = %f, `MRZ` = %f, \
     	`Speed` = '%f', `Range` = '%f', `VW` = '%d', `Interior` = '%d', `Owner` = '%s', `Password` = '%s', `Group` = '%d', `Rank` = '%d', `F` = '%d' WHERE `id` = '%d'",
        Gate[id][GateModel], Gate[id][GatePos][0], Gate[id][GatePos][1], Gate[id][GatePos][2], Gate[id][GateRot][0], Gate[id][GateRot][1], Gate[id][GateRot][2], Gate[id][GateMove][0], Gate[id][GateMove][1], Gate[id][GateMove][2],
        Gate[id][GateMoveRot][0], Gate[id][GateMoveRot][1], Gate[id][GateMoveRot][2], Gate[id][GateSpeed], Gate[id][GateRange], Gate[id][GateVW], Gate[id][GateInt], Gate[id][GateOwner], Gate[id][GatePass], Gate[id][GateGroup], Gate[id][GateRank], Gate[id][UseF], id + 1
    );
    mysql_tquery(SQL, Array, "", "");

    DestroyDynamicObject(Gate[id][GateID]);
	if(Gate[id][GateModel] > 0) Gate[id][GateID] = CreateDynamicObject(Gate[id][GateModel], Gate[id][GatePos][0], Gate[id][GatePos][1], Gate[id][GatePos][2], Gate[id][GateRot][0], Gate[id][GateRot][1], Gate[id][GateRot][2], Gate[id][GateVW], Gate[id][GateInt], -1, 150.0);
    return 1;
}

SaveGates() { for(new i; i < MAX_GATES; i++) SaveGate(i); }