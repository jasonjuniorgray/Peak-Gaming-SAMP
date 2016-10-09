#include <YSI\y_hooks>

CMD:editpoint(playerid, params[])
{
	if(Player[playerid][AdminLevel] >= 5)
	{
		ListPoints(playerid);
	}
	else SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case DIALOG_LISTPOINTS:
		{
			if(!response) return 1;
			switch(listitem)
			{
				case 0 .. MAX_POINTS:
				{
					SetPVarInt(playerid, "EditingPoint", listitem);
					format(Array, sizeof Array, "Name: %s\nType: %s\nPosition\nMaterial Amount (%d)", Point[listitem][poName], PointTypeToName(Point[listitem][poType]), Point[listitem][poMaterials]);
					ShowPlayerDialog(playerid, DIALOG_EDITPOINT, DIALOG_STYLE_LIST, "Edit Points", Array, "Select", "Cancel");
				}
			}
		}
		case DIALOG_EDITPOINT:
		{
			if(!response) return 1;
			switch(listitem)
			{
				case 0:
				{
					ShowPlayerDialog(playerid, DIALOG_EDITPOINT_NAME, DIALOG_STYLE_INPUT, "Edit Points - Name", "Please enter a new name for the point.", "Select", "Cancel");
				}
				case 1:
				{
					ShowPlayerDialog(playerid, DIALOG_EDITPOINT_TYPE, DIALOG_STYLE_LIST, "Edit Points - Type", "Materials\nPot\nCrack\nPizza\nNone", "Select", "Cancel");
				}
				case 2:
				{
					ShowPlayerDialog(playerid, DIALOG_EDITPOINT_POSITION, DIALOG_STYLE_LIST, "Edit Points - Position", "Pickup Point\nDelivery Point", "Select", "Cancel");
				}
				case 3:
				{
					ShowPlayerDialog(playerid, DIALOG_EDITPOINT_MATERIALS, DIALOG_STYLE_INPUT, "Edit Points - Materials", "Please enter the amount of materials the point will give each hour.", "Select", "Cancel");
				}
			}
		}
		case DIALOG_EDITPOINT_NAME:
		{
			Array[0] = 0;
			if(!response) return 1;

			if(strlen(inputtext) > 25) return ShowPlayerDialog(playerid, DIALOG_EDITPOINT_NAME, DIALOG_STYLE_INPUT, "Edit Points - Name", "Please enter a new name for the point.\n\nPlease specify a name under 25 characters.", "Select", "Cancel"); 
			strcpy(Point[GetPVarInt(playerid, "EditingPoint")][poName], inputtext, 25);

			format(Array, sizeof(Array), "%s has edited point %d's name to %s", GetName(playerid), GetPVarInt(playerid, "EditingPoint"), inputtext);
			Log(14, Array);

			format(Array, sizeof Array, "Name: %s\nType: %s\nPosition\nMaterial Amount (%d)\nInactive (%d)\nReset", 
			Point[GetPVarInt(playerid, "EditingPoint")][poName], 
			PointTypeToName(Point[GetPVarInt(playerid, "EditingPoint")][poType]), 
			Point[GetPVarInt(playerid, "EditingPoint")][poMaterials], 
			Point[GetPVarInt(playerid, "EditingPoint")][poInactive]);

			ShowPlayerDialog(playerid, DIALOG_EDITPOINT, DIALOG_STYLE_LIST, "Edit Points", Array, "Select", "Cancel");

			SavePoint(GetPVarInt(playerid, "EditingPoint"));
		}
		case DIALOG_EDITPOINT_TYPE:
		{
			Array[0] = 0;
			if(!response) return 1;
			switch(listitem)
			{
				case 0 .. 3:
				{
					Point[GetPVarInt(playerid, "EditingPoint")][poType] = listitem;

					format(Array, sizeof(Array), "%s has edited point %d's type to %s", GetName(playerid), GetPVarInt(playerid, "EditingPoint"), listitem);
					Log(14, Array);

					format(Array, sizeof Array, "Name: %s\nType: %s\nPosition\nMaterial Amount (%d)", 
						Point[GetPVarInt(playerid, "EditingPoint")][poName], 
						PointTypeToName(Point[GetPVarInt(playerid, "EditingPoint")][poType]), 
						Point[GetPVarInt(playerid, "EditingPoint")][poMaterials], 
						Point[GetPVarInt(playerid, "EditingPoint")][poInactive]);

					ShowPlayerDialog(playerid, DIALOG_EDITPOINT, DIALOG_STYLE_LIST, "Edit Points", Array, "Select", "Cancel");

					SavePoint(GetPVarInt(playerid, "EditingPoint"));
				}
			}
		}
		case DIALOG_EDITPOINT_POSITION:
		{
			new Float: Pos[3];
			GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
			switch(listitem)
			{
				case 0:
				{
					Point[GetPVarInt(playerid, "EditingPoint")][poPos][0] = Pos[0];
					Point[GetPVarInt(playerid, "EditingPoint")][poPos][1] = Pos[1];
					Point[GetPVarInt(playerid, "EditingPoint")][poPos][2] = Pos[2];
					Point[GetPVarInt(playerid, "EditingPoint")][pointVW] = GetPlayerVirtualWorld(playerid);

					SavePoint(GetPVarInt(playerid, "EditingPoint"));
				}
				case 1:
				{
					Point[GetPVarInt(playerid, "EditingPoint")][poPos2][0] = Pos[0];
					Point[GetPVarInt(playerid, "EditingPoint")][poPos2][1] = Pos[1];
					Point[GetPVarInt(playerid, "EditingPoint")][poPos2][2] = Pos[2];
					Point[GetPVarInt(playerid, "EditingPoint")][pointVW2] = GetPlayerVirtualWorld(playerid);

					SavePoint(GetPVarInt(playerid, "EditingPoint"));
				}
			}

			format(Array, sizeof(Array), "%s has edited point %d's position %d amount to X: %f, Y: %f, Z: %f, VW: %d", GetName(playerid), GetPVarInt(playerid, "EditingPoint"), listitem, Pos[0], Pos[0], Pos[0], GetPlayerVirtualWorld(playerid));
			Log(14, Array);
		}
		case DIALOG_EDITPOINT_MATERIALS:
		{
			Array[0] = 0;
			if(!IsNumeric(inputtext)) return ShowPlayerDialog(playerid, DIALOG_EDITPOINT_MATERIALS, DIALOG_STYLE_INPUT, "Edit Points - Materials", "Please enter the amount of materials the point will give each hour.\n\nPlease enter a numerical integer.", "Select", "Cancel");

			Point[GetPVarInt(playerid, "EditingPoint")][poMaterials] = strval(inputtext);

			format(Array, sizeof(Array), "%s has edited point %d's material amount to %d", GetName(playerid), GetPVarInt(playerid, "EditingPoint"), inputtext);
			Log(14, Array);

			format(Array, sizeof Array, "Name: %s\nType: %s\nPosition\nMaterial Amount (%d)", 
				Point[GetPVarInt(playerid, "EditingPoint")][poName], 
				PointTypeToName(Point[GetPVarInt(playerid, "EditingPoint")][poType]), 
				Point[GetPVarInt(playerid, "EditingPoint")][poMaterials], 
				Point[GetPVarInt(playerid, "EditingPoint")][poInactive]);

			ShowPlayerDialog(playerid, DIALOG_EDITPOINT, DIALOG_STYLE_LIST, "Edit Points", Array, "Select", "Cancel");

			SavePoint(GetPVarInt(playerid, "EditingPoint"));
		}
	}
	return 1;
}	

ListPoints(playerid) 
{
	Array[0] = 0;
	for(new i; i < MAX_POINTS; i++)
	{
		if(Point[i][poName][0]) format(Array, sizeof Array, "%s\n(%i) %s{FFFFFF}", Array, i + 1, Point[i][poName]);
		else format(Array, sizeof Array, "%s\n(%i) (empty)", Array, i + 1);
	}
	return ShowPlayerDialog(playerid, DIALOG_LISTPOINTS, DIALOG_STYLE_LIST, "Edit Points", Array, "Select", "Cancel");
}

PointTypeToName(id)
{
	new type[24];
	switch(id)
	{
		case 0: format(type, 24, "Materials");
		case 1: format(type, 24, "Pot");
		case 2: format(type, 24, "Crack");
		case 3: format(type, 24, "Pizza");
		case 4: format(type, 24, "None");
	}
	return type;
}

forward InitiatePoints();
public InitiatePoints()
{
	new fields, rows, id, result[128];
	cache_get_data(rows, fields, SQL);

	while((id < rows))
	{
		cache_get_field_content(id, "pointname", Point[id][poName], SQL, MAX_PLAYER_NAME);
		cache_get_field_content(id, "id", result, SQL); Point[id][poID] = strval(result);
		cache_get_field_content(id, "type", result, SQL); Point[id][poType] = strval(result);
		cache_get_field_content(id, "posx", result, SQL); Point[id][poPos][0] = floatstr(result);
		cache_get_field_content(id, "posy", result, SQL); Point[id][poPos][1] = floatstr(result);
		cache_get_field_content(id, "posz", result, SQL); Point[id][poPos][2] = floatstr(result);
		cache_get_field_content(id, "pos2x", result, SQL); Point[id][poPos2][0] = floatstr(result);
		cache_get_field_content(id, "pos2y", result, SQL); Point[id][poPos2][1] = floatstr(result);
		cache_get_field_content(id, "pos2z", result, SQL); Point[id][poPos2][2] = floatstr(result);
		cache_get_field_content(id, "vw", result, SQL); Point[id][pointVW] = strval(result);
		cache_get_field_content(id, "vw2", result, SQL); Point[id][pointVW2] = strval(result);
		cache_get_field_content(id, "capturable", result, SQL); Point[id][poCapturable] = strval(result);
		cache_get_field_content(id, "captureplayername", Point[id][CapturePlayerName], SQL, MAX_PLAYER_NAME);
		cache_get_field_content(id, "playernamecapping", Point[id][PlayerNameCapping], SQL, MAX_PLAYER_NAME);
		cache_get_field_content(id, "cappergroup", result, SQL); Point[id][poCapperGroup] = strval(result);
		cache_get_field_content(id, "cappergroupowned", result, SQL); Point[id][poCapperGroupOwned] = strval(result);
		cache_get_field_content(id, "inactive", result, SQL); Point[id][poInactive] = strval(result);
		cache_get_field_content(id, "materials", result, SQL); Point[id][poMaterials] = strval(result);
		cache_get_field_content(id, "timestamp1", result, SQL); Point[id][poTimestamp1] = strval(result);
		cache_get_field_content(id, "timestamp2", result, SQL); Point[id][poTimestamp2] = strval(result);
		
		if(Point[id][poCapperGroup] != -1)
		{
			Point[id][HasCrashed] = 1;
			Point[id][poTimer] = SetTimerEx("CaptureTimerEx", 60000, 1, "d", id);
		}

		DestroyDynamicPickup(Point[id][poPickupID]);
		DestroyDynamic3DTextLabel(Point[id][poTextID]);

		if(Point[id][poPos][0] != 0.0 && Point[id][poPos][1] != 0.0 && Point[id][poPos][2] != 0.0)
		{
			Point[id][poPickupID] = CreateDynamicPickup(1239, 1, Point[id][poPos][0], Point[id][poPos][1], Point[id][poPos][2], -1);
			switch(Point[id][poType])
			{
				case 0: Point[id][poTextID] = CreateDynamic3DTextLabel("Materials Pickup\n(( /getmats ))", YELLOW, Point[id][poPos][0], Point[id][poPos][1], Point[id][poPos][2], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1);
				case 1: Point[id][poTextID] = CreateDynamic3DTextLabel("Drug Pickup\n(( /getcrate ))", YELLOW, Point[id][poPos][0], Point[id][poPos][1], Point[id][poPos][2], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1);
				case 2: Point[id][poTextID] = CreateDynamic3DTextLabel("Drug Pickup\n(( /getcrate ))", YELLOW, Point[id][poPos][0], Point[id][poPos][1], Point[id][poPos][2], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1);
				case 3: Point[id][poTextID] = CreateDynamic3DTextLabel("Pizza Pickup\n(( /getpizza ))", YELLOW, Point[id][poPos][0], Point[id][poPos][1], Point[id][poPos][2], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1);
				case 4: 
				{
					if(Point[id][poCapturable] != 1 && Point[id][poInactive] != 1) DestroyDynamic3DTextLabel(Point[id][poTextID]); // Deletes the text label as a whole, will only display when the point is captureable.
				}
			}
		}

		Point[id][poBeingCaptured] = INVALID_PLAYER_ID;
		
		id++;
	}
	if(id == 0) printf("[SCRIPT-LOAD/ERR] The script initiated 0 points.");
	if(id != 0) printf("[SCRIPT-LOAD] The script initiated %d points.", id);
	return 1;
}

SavePoint(id)
{
	
	mysql_format(SQL, Array, sizeof(Array), "UPDATE `points` SET \
		`pointname` = '%e', `type` = '%d', `posx` = '%f', `posy` = '%f', `posz` = '%f', `pos2x` = '%f', `pos2y` = '%f', `pos2z` = '%f', `vw` = '%d', `vw2` = '%d', `capturable` = '%d', \
		`captureplayername` = '%e', `playernamecapping` = '%e', `cappergroup` = '%d', `cappergroupowned` = '%d', `inactive` = '%d', `materials` = '%d', `timestamp1` = '%d', `timestamp2` = '%d' WHERE `id` = %d",
		Point[id][poName], Point[id][poType],	Point[id][poPos][0], Point[id][poPos][1], Point[id][poPos][2], Point[id][poPos2][0], Point[id][poPos2][1], Point[id][poPos2][2], Point[id][pointVW], Point[id][pointVW2],
		Point[id][poCapturable], Point[id][CapturePlayerName], Point[id][PlayerNameCapping], Point[id][poCapperGroup], Point[id][poCapperGroupOwned], Point[id][poInactive], Point[id][poMaterials], Point[id][poTimestamp1], 
		Point[id][poTimestamp2], id+1
	);		
	mysql_tquery(SQL, Array, "", "");

	DestroyDynamicPickup(Point[id][poPickupID]);
	DestroyDynamic3DTextLabel(Point[id][poTextID]);

	if(Point[id][poPos][0] != 0.0 && Point[id][poPos][1] != 0.0 && Point[id][poPos][2] != 0.0)
	{
		Point[id][poPickupID] = CreateDynamicPickup(1239, 1, Point[id][poPos][0], Point[id][poPos][1], Point[id][poPos][2], -1);
		switch(Point[id][poType])
		{
			case 0: Point[id][poTextID] = CreateDynamic3DTextLabel("Materials Pickup\n(( /getmats )).", YELLOW, Point[id][poPos][0], Point[id][poPos][1], Point[id][poPos][2], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1);
			case 1: Point[id][poTextID] = CreateDynamic3DTextLabel("Drug Pickup\n(( /getcrate )).", YELLOW, Point[id][poPos][0], Point[id][poPos][1], Point[id][poPos][2], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1);
			case 2: Point[id][poTextID] = CreateDynamic3DTextLabel("Drug Pickup\n(( /getcrate ))", YELLOW, Point[id][poPos][0], Point[id][poPos][1], Point[id][poPos][2], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1);
			case 3: Point[id][poTextID] = CreateDynamic3DTextLabel("Pizza Pickup\n(( /getpizza ))", YELLOW, Point[id][poPos][0], Point[id][poPos][1], Point[id][poPos][2], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1);
			case 4: 
			{
				if(Point[id][poCapturable] != 1 && Point[id][poInactive] != 1) DestroyDynamic3DTextLabel(Point[id][poTextID]); // Deletes the text label as a whole, will only display when the point is captureable.
			}
		}
	}
	return 1;
}

SavePoints() { for(new i; i < MAX_POINTS; i++) SavePoint(i); }