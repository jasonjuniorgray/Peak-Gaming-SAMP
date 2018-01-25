CMD:tax(playerid, params[])
{
	new tax;
	if(sscanf(params, "d", tax))
	{
	    if(Group[Player[playerid][PlayerGroup]][GroupType] == 2 && Player[playerid][Leader] > 0)
	    {
			SendClientMessage(playerid, WHITE, "SYNTAX: /tax [new tax percent]");
			return SendClientMessage(playerid, GREY, "Tax works as a percent. However, it must still be a whole number. (0-50)");
		}
		else return SendClientMessage(playerid, WHITE, "You are not authorized to preform this command.");
	}
	if(Player[playerid][PlayerGroup] > -1)
	{
		if(Group[Player[playerid][PlayerGroup]][GroupType] == 2)
		{
			if(Player[playerid][Leader] > 0)
			{
				if(tax < 0 || tax > 50) return SendClientMessage(playerid, GREY, "Tax works as a percent. However, it must still be a whole number. (0-50)");

				Array[0] = 0;
				Tax = tax;

				format(Array, sizeof(Array), "You have changed the tax for Los Santos to %d percent.", tax);
				SendClientMessage(playerid, WHITE, Array);

				format(Array, sizeof(Array), "[/TAX] %s has changed the server tax to %d percent.", GetName(playerid), tax);
				Log(17, Array);
				SendToAdmins(ORANGE, Array, 0, 1);
			}
			else return SendClientMessage(playerid, WHITE, "You are not the mayor.");
		}
		else return SendClientMessage(playerid, WHITE, "You are not in the government.");
	}
	else SendClientMessage(playerid, WHITE, "You are not in the government.");
	return 1;
}