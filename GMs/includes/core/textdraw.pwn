#include <YSI\y_hooks>

hook OnGameModeInit()
{
	CreateAnimationHelper();
	CreateLimboTextdraw();
	return 1;
}

hook OnPlayerConnect(playerid)
{
	CreatePlayerTextDraws(playerid);
	return 1;
}

CreatePlayerTextDraws(playerid)
{
	FuelTextDraw[playerid] = CreatePlayerTextDraw(playerid, 495.000000, 133.000000, "~b~Fuel: N/A");
	PlayerTextDrawBackgroundColor(playerid, FuelTextDraw[playerid], 255);
	PlayerTextDrawFont(playerid, FuelTextDraw[playerid], 1);
	PlayerTextDrawLetterSize(playerid, FuelTextDraw[playerid], 0.270000, 2.000000);
	PlayerTextDrawColor(playerid, FuelTextDraw[playerid], -1);
	PlayerTextDrawSetOutline(playerid, FuelTextDraw[playerid], 1);
	PlayerTextDrawSetProportional(playerid,FuelTextDraw[playerid], 1);

	SpeedTextDraw[playerid] = CreatePlayerTextDraw(playerid, 555.000000, 133.000000, "~b~MP/H: N/A");
	PlayerTextDrawBackgroundColor(playerid, SpeedTextDraw[playerid], 255);
	PlayerTextDrawFont(playerid, SpeedTextDraw[playerid], 1);
	PlayerTextDrawLetterSize(playerid, SpeedTextDraw[playerid], 0.270000, 2.000000);
	PlayerTextDrawColor(playerid, SpeedTextDraw[playerid], -1);
	PlayerTextDrawSetOutline(playerid, SpeedTextDraw[playerid], 1);
	PlayerTextDrawSetProportional(playerid, SpeedTextDraw[playerid], 1);
	return 1;
}

CreateAnimationHelper()
{
	AnimationHelper = TextDrawCreate(630.0, 427.0,
	"~r~~k~~PED_SPRINT~ ~w~to stop the animation");
	TextDrawUseBox(AnimationHelper, 0);
	TextDrawFont(AnimationHelper, 2);
	TextDrawSetShadow(AnimationHelper,0);
    TextDrawSetOutline(AnimationHelper,1);
    TextDrawBackgroundColor(AnimationHelper,0x000000FF);
    TextDrawColor(AnimationHelper,0xFFFFFFFF);
    TextDrawAlignment(AnimationHelper,3);	
	return 1;
}

CreateLimboTextdraw()
{
	LimboTextDraw = TextDrawCreate(306.5, 395.0,
	"~w~You are~r~Injured~w~!~n~~n~~r~/limbo ~w~to go to the hospital.");
	TextDrawUseBox(LimboTextDraw, 0);
	TextDrawFont(LimboTextDraw, 2);
	TextDrawSetShadow(LimboTextDraw,0);
    TextDrawSetOutline(LimboTextDraw,1);
    TextDrawBackgroundColor(LimboTextDraw,0x000000FF);
    TextDrawColor(LimboTextDraw,0xFFFFFFFF);
    TextDrawAlignment(LimboTextDraw,2);	
	return 1;
}