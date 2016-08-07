#include <YSI\y_hooks>

new NametagTimer[MAX_PLAYERS];

hook OnPlayerStreamIn(playerid, id)
{
	NametagTimer[id] = SetTimerEx("RangeCheck", 500, true, "ii", playerid, id);
	return 1;
}

hook OnPlayerStreamOut(playerid, id)
{
	KillTimer(NametagTimer[id]);
	return 1;
}

forward RangeCheck(playerid, id);
public RangeCheck(playerid, id)
{
	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(id, X, Y, Z);
	
	if(IsPlayerInRangeOfPoint(playerid, 25.0, X, Y, Z))
	{
		ShowPlayerNameTagForPlayer(id, playerid, true);
	}
	else
	{
		ShowPlayerNameTagForPlayer(id, playerid, false);
	}
}