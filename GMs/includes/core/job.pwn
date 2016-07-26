CMD:joinjob(playerid, params[])
{
    for(new i; i < MAX_JOBS; i++)
    {
        if(IsPlayerInRangeOfPoint(playerid, 2.0, Job[i][JobPos][0], Job[i][JobPos][1], Job[i][JobPos][2]))
        {
            if(Job[i][JobType] > 0)
            {
                if(Player[playerid][PlayerJob] != -1) return SendClientMessage(playerid, WHITE, "You already have a job! Use /quitjob to leave your current job.");

                Array[0] = 0;

                Player[playerid][PlayerJob] = i;

                format(Array, sizeof(Array), "Congratulations! You have become a %s.", Job[i][JobName]);
                SendClientMessage(playerid, WHITE, Array);
            }
        }
    }
    return 1;
}

CMD:quitjob(playerid, params[])
{
    if(Player[playerid][PlayerJob] == -1) return SendClientMessage(playerid, WHITE, "You do not have a job.");

    Array[0] = 0;

    format(Array, sizeof(Array), "You have quit your job as a %s.", Job[Player[playerid][PlayerJob]][JobName]);
    SendClientMessage(playerid, WHITE, Array);

    Player[playerid][PlayerJob] = -1;
    return 1;
}

CMD:skill(playerid, params[])
{
	if(isnull(params))
	{
		SendClientMessage(playerid, WHITE, "SYNTAX: /skill [usage]");
		return SendClientMessage(playerid, GREY, "Usages: 1 - Arms Dealer, 2 - Mechanic, 3 - Bodyguard, 4 - Detective, 5 - Trucker, 6 - Drug Smuggler");
	}
	else 
	{
		new level = Player[playerid][JobSkill][strval(params) - 1];
		Array[0] = 0;
		switch(strval(params) - 1)
		{
			case 0:
			{
				if(level >= 0 && level < 50) { SendClientMessage(playerid, WHITE, "Your skill level for Arms Dealer is 1."); format(Array, sizeof(Array), "You need to craft %d more weapons to level up.", 50 - level); SendClientMessage(playerid, GREY, Array); }
				else if(level >= 50 && level < 100) { SendClientMessage(playerid, WHITE, "Your skill level for Arms Dealer is 2."); format(Array, sizeof(Array), "You need to craft %d more weapons to level up.", 100 - level); SendClientMessage(playerid, GREY, Array); }
				else if(level >= 100 && level < 200) { SendClientMessage(playerid, WHITE, "Your skill level for Arms Dealer is 3."); format(Array, sizeof(Array), "You need to craft %d more weapons to level up.", 200 - level); SendClientMessage(playerid, GREY, Array); }
				else if(level >= 200 && level < 400) { SendClientMessage(playerid, WHITE, "Your skill level for Arms Dealer is 4."); format(Array, sizeof(Array), "You need to craft %d more weapons to level up.", 400 - level); SendClientMessage(playerid, GREY, Array); }
				else if(level >= 400) { SendClientMessage(playerid, WHITE, "Your skill level for Arms Dealer is 5."); }
			}
			case 1:
			{
				if(level >= 0 && level < 50) { SendClientMessage(playerid, WHITE, "Your skill level for Mechanic is 1."); format(Array, sizeof(Array), "You need to fix, repair, or colour %d more cars to level up.", 50 - level); SendClientMessage(playerid, GREY, Array); }
				else if(level >= 50 && level < 100) { SendClientMessage(playerid, WHITE, "Your skill level for Mechanic is 2."); format(Array, sizeof(Array), "You need to fix, repair, or colour %d more cars to level up.", 100 - level); SendClientMessage(playerid, GREY, Array); }
				else if(level >= 100 && level < 200) { SendClientMessage(playerid, WHITE, "Your skill level for Mechanic is 3."); format(Array, sizeof(Array), "You need to fix, repair, or colour %d more cars to level up.", 200 - level); SendClientMessage(playerid, GREY, Array); }
				else if(level >= 200 && level < 400) { SendClientMessage(playerid, WHITE, "Your skill level for Mechanic is 4."); format(Array, sizeof(Array), "You need to fix, repair, or colour %d more cars to level up.", 400 - level); SendClientMessage(playerid, GREY, Array); }
				else if(level >= 400) { SendClientMessage(playerid, WHITE, "Your skill level for Mechanic is 5."); }
			}
			case 2:
			{
				if(level >= 0 && level < 50) { SendClientMessage(playerid, WHITE, "Your skill level for Bodyguard is 1."); format(Array, sizeof(Array), "You need to guard %d more players to level up.", 50 - level); SendClientMessage(playerid, GREY, Array); }
				else if(level >= 50 && level < 100) { SendClientMessage(playerid, WHITE, "Your skill level for Bodyguard is 2."); format(Array, sizeof(Array), "You need to guard %d more players to level up.", 100 - level); SendClientMessage(playerid, GREY, Array); }
				else if(level >= 100 && level < 200) { SendClientMessage(playerid, WHITE, "Your skill level for Bodyguard is 3."); format(Array, sizeof(Array), "You need to guard %d more players to level up.", 200 - level); SendClientMessage(playerid, GREY, Array); }
				else if(level >= 200 && level < 400) { SendClientMessage(playerid, WHITE, "Your skill level for Bodyguard is 4."); format(Array, sizeof(Array), "You need to guard %d more players to level up.", 400 - level); SendClientMessage(playerid, GREY, Array); }
				else if(level >= 400) { SendClientMessage(playerid, WHITE, "Your skill level for Bodyguard is 5."); }
			}
			case 3:
			{
				if(level >= 0 && level < 50) { SendClientMessage(playerid, WHITE, "Your skill level for Detective is 1."); format(Array, sizeof(Array), "You need to find %d more players to level up.", 50 - level); SendClientMessage(playerid, GREY, Array); }
				else if(level >= 50 && level < 100) { SendClientMessage(playerid, WHITE, "Your skill level for Detective is 2."); format(Array, sizeof(Array), "You need to find %d more players to level up.", 100 - level); SendClientMessage(playerid, GREY, Array); }
				else if(level >= 100 && level < 200) { SendClientMessage(playerid, WHITE, "Your skill level for Detective is 3."); format(Array, sizeof(Array), "You need to find %d more players to level up.", 200 - level); SendClientMessage(playerid, GREY, Array); }
				else if(level >= 200 && level < 400) { SendClientMessage(playerid, WHITE, "Your skill level for Detective is 4."); format(Array, sizeof(Array), "You need to find %d more players to level up.", 400 - level); SendClientMessage(playerid, GREY, Array); }
				else if(level >= 400) { SendClientMessage(playerid, WHITE, "Your skill level for Detective is 5."); }
			}
			case 4:
			{
				if(level >= 0 && level < 50) { SendClientMessage(playerid, WHITE, "Your skill level for Trucker is 1."); format(Array, sizeof(Array), "You need to ship %d more cargo to level up.", 50 - level); SendClientMessage(playerid, GREY, Array); }
				else if(level >= 50 && level < 100) { SendClientMessage(playerid, WHITE, "Your skill level for Trucker is 2."); format(Array, sizeof(Array), "You need to ship %d more cargo to level up.", 100 - level); SendClientMessage(playerid, GREY, Array); }
				else if(level >= 100 && level < 200) { SendClientMessage(playerid, WHITE, "Your skill level for Trucker is 3."); format(Array, sizeof(Array), "You need to ship %d more cargo to level up.", 200 - level); SendClientMessage(playerid, GREY, Array); }
				else if(level >= 200 && level < 400) { SendClientMessage(playerid, WHITE, "Your skill level for Trucker is 4."); format(Array, sizeof(Array), "You need to ship %d more cargo to level up.", 400 - level); SendClientMessage(playerid, GREY, Array); }
				else if(level >= 400) { SendClientMessage(playerid, WHITE, "Your skill level for Trucker is 5."); }
			}
			case 5:
			{
				if(level >= 0 && level < 50) { SendClientMessage(playerid, WHITE, "Your skill level for Drug Smuggler is 1."); format(Array, sizeof(Array), "You need to smuggle %d more drugs to level up.", 50 - level); SendClientMessage(playerid, GREY, Array); }
				else if(level >= 50 && level < 100) { SendClientMessage(playerid, WHITE, "Your skill level for Drug Smuggler is 2."); format(Array, sizeof(Array), "You need to smuggle %d more drugs to level up.", 100 - level); SendClientMessage(playerid, GREY, Array); }
				else if(level >= 100 && level < 200) { SendClientMessage(playerid, WHITE, "Your skill level for Drug Smuggler is 3."); format(Array, sizeof(Array), "You need to smuggle %d more drugs to level up.", 200 - level); SendClientMessage(playerid, GREY, Array); }
				else if(level >= 200 && level < 400) { SendClientMessage(playerid, WHITE, "Your skill level for Drug Smuggler is 4."); format(Array, sizeof(Array), "You need to smuggle %d more drugs to level up.", 400 - level); SendClientMessage(playerid, GREY, Array); }
				else if(level >= 400) { SendClientMessage(playerid, WHITE, "Your skill level for Drug Smuggler is 5."); }
			}
			default:
			{
				SendClientMessage(playerid, WHITE, "/skill [job]");
				return SendClientMessage(playerid, GREY, "Types: 1 - Arms Dealer, 2 - Mechanic, 3 - Bodyguard, 4 - Detective, 5 - Trucker, 6 - Drug Smuggler");
			}
		}
	}
	return 1;
}

IncreaseJobSkill(playerid, job, xp)
{
	switch(job)
	{
		case 0 .. MAX_JOBS:
		{
			Player[playerid][JobSkill][job] += xp;
		}
	}
	return 1;
}