public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
        case DIALOG_REGISTER:
        {
            if(!response) return Kick(playerid);
            if(GetPVarInt(playerid, "CannotRegister")) return 1;
            
            if(strlen(inputtext) < 3 || strlen(inputtext) > 31)
            {
                new string[128];
                SendClientMessage(playerid, DARKRED, "Your password must at least contain more than 2 characters and less than 32.");
                format(string, sizeof(string), "{FFFFFF}Welcome to Peak Gaming Roleplay, %s.\n\n{FFFFFF}This name is {AA3333}unregistered{FFFFFF}. Please enter a password to register the account.", GetName(playerid));
                return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Register", string, "Register", "");
            }
            new Query[512], RegisterIP[16], EscapedPassword[32];
            GetPlayerIp(playerid, RegisterIP, sizeof(RegisterIP));

            mysql_real_escape_string(inputtext, EscapedPassword);

            WP_Hash(Player[playerid][Password], 129, EscapedPassword);
            format(Player[playerid][Username], MAX_PLAYER_NAME, "%s", GetNameWithUnderscore(playerid));

            mysql_format(SQL, Query, sizeof(Query), "INSERT INTO `accounts` (`Username`, `Password`, `RegisterIP`, `LastIP`) VALUES ('%e', '%e', '%e', '%e')", GetNameWithUnderscore(playerid), Player[playerid][Password], RegisterIP, RegisterIP);
            mysql_tquery(SQL, Query, "OnPlayerRegisterAccount", "i", playerid);
        }
	    case DIALOG_LOGIN:
	    {
	        if(!response) return Kick(playerid);
	        
	        new PasswordHash[129], Query[100];

            WP_Hash(PasswordHash, sizeof(PasswordHash), inputtext);
            if(!strcmp(PasswordHash, Player[playerid][Password]))
            {
                mysql_format(SQL, Query, sizeof(Query), "SELECT * FROM `accounts` WHERE `Username` = '%e' LIMIT 1", GetNameWithUnderscore(playerid));
                mysql_tquery(SQL, Query, "OnPlayerLogin", "i", playerid);
            }
            else
            {
                if(GetPVarInt(playerid, "LoginAttempts") == 0) { SendClientMessage(playerid, DARKRED, "You have specified an incorrect password, you have 3 more tries before you are auto-kicked."); }
                if(GetPVarInt(playerid, "LoginAttempts") == 1) { SendClientMessage(playerid, DARKRED, "You have specified an incorrect password, you have 2 more tries before you are auto-kicked."); }
                if(GetPVarInt(playerid, "LoginAttempts") == 2) { SendClientMessage(playerid, DARKRED, "You have specified an incorrect password, you have 1 more try before you are auto-kicked."); }
                if(GetPVarInt(playerid, "LoginAttempts") == 3)
				{
					SendClientMessage(playerid, WHITE, "You have been auto-kicked for entering the wrong password too many times.");
					return DelayPunishment(playerid, 1);
				}
				else
				{
                	new string[255];
                	format(string, sizeof(string), "{FFFFFF}Welcome to Peak Gaming Roleplay, %s.\n\n{FFFFFF}This account is registered. Please enter the password to authenticate.", GetName(playerid));
					ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Authentication", string, "Login", "");
				
					SetPVarInt(playerid, "LoginAttempts", GetPVarInt(playerid, "LoginAttempts") + 1);
				}
            }
	    }
	}
	return 1;
}
