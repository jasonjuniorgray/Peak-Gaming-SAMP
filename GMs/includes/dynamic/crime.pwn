#include <YSI\y_hooks>

CMD:crimelist(playerid, params)
{
	if(Player[playerid][AdminLevel] >= 5)
	{
		Array[0] = 0;
		for(new i; i < MAX_CRIMES; i++) format(Array, sizeof(Array), "%s\n%s", Array, Crime[i][CrimeName]);
		return ShowPlayerDialog(playerid, DIALOG_CRIMELIST_EDIT, DIALOG_STYLE_LIST, "Crime List - Edit", Array, "Select", "Cancel");
	}
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case DIALOG_CRIMELIST_EDIT:
		{
			if(!response) return 1;
			switch(listitem)
			{
				case 0 .. MAX_CRIMES:
				{
					SetPVarInt(playerid, "EditingCrime", listitem);
					ShowPlayerDialog(playerid, DIALOG_CRIMELIST_EDIT_NAME, DIALOG_STYLE_INPUT, "Crime List - Edit Name", "Please enter a new name for the specified crime.", "Select", "Cancel");
				}
			}
		}
		case DIALOG_CRIMELIST_EDIT_NAME:
		{
			if(!response)
			{
				for(new i; i < MAX_CRIMES; i++) format(Array, sizeof(Array), "%s\n%s", Array, Crime[i][CrimeName]);
				return ShowPlayerDialog(playerid, DIALOG_CRIMELIST_EDIT, DIALOG_STYLE_LIST, "Crime List - Edit", Array, "Select", "Cancel");
			}

			format(Crime[GetPVarInt(playerid, "EditingCrime")][CrimeName], 256, "%s", inputtext);

			SaveCrime(GetPVarInt(playerid, "EditingCrime"));
			DeletePVar(playerid, "EditingCrime");

			Array[0] = 0;
			for(new i; i < MAX_CRIMES; i++) format(Array, sizeof(Array), "%s\n%s", Array, Crime[i][CrimeName]);
			return ShowPlayerDialog(playerid, DIALOG_CRIMELIST_EDIT, DIALOG_STYLE_LIST, "Crime List - Edit", Array, "Select", "Cancel");
		}
	}
	return 1;
}

forward InitiateCrimes();
public InitiateCrimes()
{
    new rows, fields, crimes;
    
    cache_get_data(rows, fields);
    for(new row; row < MAX_CRIMES; row++)
    {      
		cache_get_field_content(row, "Name", Crime[row][CrimeName], SQL, 256);
    	crimes++;
    }
    switch(crimes)
    {
        case 0: printf("[SCRIPT-LOAD/ERR] The script initiated 0 crimes.", crimes);
        default: printf("[SCRIPT-LOAD] The script has initiated %d crimes", crimes);
    }
}

SaveCrime(id)
{
    Array[0] = 0;

    format(Array, sizeof Array, "UPDATE `crimes` SET \
        `Name` = '%s' WHERE `id` = '%d'",
        Crime[id][CrimeName], id + 1
    );
    mysql_tquery(SQL, Array, "", "");

    return 1;
}

SaveCrimes() { for(new i; i < MAX_CRIMES; i++) SaveCrime(i); }