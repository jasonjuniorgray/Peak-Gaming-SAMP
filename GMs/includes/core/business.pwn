#include <YSI\y_hooks>

new const StoreItems[][] =
{
	"Phone",
	"Camera",
	"Rope",
	"Rag",
	"Cigar",
	"Spraycan",
	"Lottery Ticket",
	"Portable Radio"
};

new const FoodItems[][] =
{
	"Meal",
	"Water",
	"Sprunk"
};

new const GymItems[][] =
{
	"Normal",
	"Boxing",
	"Kungfu",
	"Knee Head",
	"Grabkick",
	"Elbow"
};

CMD:buy(playerid, params[])
{
	new id = Player[playerid][InsideBusiness];
	Array[0] = 0;
	switch(Business[id][BizType])
	{
		case 0: return SendClientMessage(playerid, WHITE, "You are not inside a business.");
		case 1, 6: // Store
		{
			format(Array, sizeof(Array), "Item Name\t\tPrice");
			for(new i; i < sizeof(StoreItems); i++) 
			{
				if(Business[id][ItemPrice][i] > 0) format(Array, sizeof(Array), "%s\n%s\t\t$%d\n", Array, StoreItems[i], Business[id][ItemPrice][i]);
			}
			ShowPlayerDialog(playerid, DIALOG_BUSINESS_STORE, DIALOG_STYLE_TABLIST_HEADERS, "24/7 - Purchase", Array, "Purchase", "Cancel");
		}
		case 2: // Resturaunt
		{
			format(Array, sizeof(Array), "Item Name\t\tPrice");
			for(new i; i < sizeof(FoodItems); i++) 
			{
				if(Business[id][FoodItemPrice][i] > 0) format(Array, sizeof(Array), "%s\n%s\t\t$%d\n", Array, FoodItems[i], Business[id][FoodItemPrice][i]);
			}
			ShowPlayerDialog(playerid, DIALOG_BUSINESS_FOOD, DIALOG_STYLE_TABLIST_HEADERS, "Resturaunt - Purchase", Array, "Purchase", "Cancel");
		}
		case 4: // Gym
		{
			format(Array, sizeof(Array), "Item Name\t\tPrice");
			for(new i; i < sizeof(GymItems); i++) 
			{
				if(Business[id][GymItemPrice][i] > 0) format(Array, sizeof(Array), "%s\n%s\t\t$%d\n", Array, GymItems[i], Business[id][GymItemPrice][i]);
			}
			ShowPlayerDialog(playerid, DIALOG_BUSINESS_GYM, DIALOG_STYLE_TABLIST_HEADERS, "Gym - Purchase", Array, "Purchase", "Cancel");
		}
		case 5: // Clothing Store
		{
			format(Array, sizeof(Array), "Enter a skin number to purchase a skin. It will cost you $%d", Business[id][SkinPrice]);
			ShowPlayerDialog(playerid, DIALOG_BUSINESS_SKIN, DIALOG_STYLE_INPUT, "Clothing Store - Purchase", Array, "Purchase", "Cancel");
		}
		default: return 1;
	}
	return 1;
}

CMD:editcarprice(playerid, params[])
{
	new id, price;
	if(sscanf(params, "dd", id, price))
	{
		return SendClientMessage(playerid, WHITE, "SYNTAX: /editcarprice [id] [price]");
	}
	new rid = GetRealDealerVehicleID(id);

	if(id < 1 || id > MAX_VEHICLES) return SendClientMessage(playerid, WHITE, "That is not a valid vehicle ID!");
    if(Dealership[rid][DealerModel] == 0) return SendClientMessage(playerid, WHITE, "That is not a valid dealership vehicle ID!");

	if(strfind(Business[Dealership[rid][DealerBiz]][BizOwner], GetName(playerid), true) != -1)
	{
		if(price > 1)
		{
			Array[0] = 0;
			Dealership[rid][DealershipPrice] = price;

			format(Array, sizeof(Array), "You have edited the %s's price to $%s", VehicleNames[Dealership[rid][DealerModel] - 400], FormatNumberToString(price));
			SendClientMessage(playerid, WHITE, Array);

			RespawnDealershipVehicle(id, rid);
			SaveDealershipVehicle(rid);
		}
		else return SendClientMessage(playerid, WHITE, "Your new price must be greater than 1.");
	}
	else SendClientMessage(playerid, WHITE, "You do not own the business this car is attached to!");
	return 1;
}

CMD:editprices(playerid, params[])
{
	if(Player[playerid][InsideBusiness] > -1)
	{
		new id = Player[playerid][InsideBusiness];
		if(strfind(Business[id][BizOwner], GetName(playerid), true) != -1)
		{
			switch(Business[id][BizType])
			{
				case 1, 6: // Store
				{
					format(Array, sizeof(Array), "Item Name\t\tPrice");
					for(new i; i < sizeof(StoreItems); i++) 
					{
						format(Array, sizeof(Array), "%s\n%s\t\t$%d\n", Array, StoreItems[i], Business[id][ItemPrice][i]);
					}
					if(Business[id][BizType]) format(Array, sizeof(Array), "%s\nFuel\t\t$%d\n", Array, Business[id][FuelPrice]);
					ShowPlayerDialog(playerid, DIALOG_BUSINESS_STORE_EDIT, DIALOG_STYLE_TABLIST_HEADERS, "24/7 - Edit Prices", Array, "Purchase", "Cancel");
				}
				case 2: // Resturaunt
				{
					format(Array, sizeof(Array), "Item Name\t\tPrice");
					for(new i; i < sizeof(FoodItems); i++) 
					{
						format(Array, sizeof(Array), "%s\n%s\t\t$%d\n", Array, FoodItems[i], Business[id][FoodItemPrice][i]);
					}
					ShowPlayerDialog(playerid, DIALOG_BUSINESS_FOOD_EDIT, DIALOG_STYLE_TABLIST_HEADERS, "Resturaunt - Edit Prices", Array, "Purchase", "Cancel");
				}
				case 4: // Gym
				{
					format(Array, sizeof(Array), "Item Name\t\tPrice");
					for(new i; i < sizeof(GymItems) + 1; i++) 
					{
						if(strlen(GymItems[i]) > 0) format(Array, sizeof(Array), "%s\n%s\t\t$%d\n", Array, GymItems[i], Business[id][GymItemPrice][i]);
					}
					ShowPlayerDialog(playerid, DIALOG_BUSINESS_GYM_EDIT, DIALOG_STYLE_TABLIST_HEADERS, "Gym - Edit Prices", Array, "Purchase", "Cancel");
				}
				case 5: // Clothing Store
				{
					format(Array, sizeof(Array), "Enter a new cost for skins. The current price is $%d.", Business[id][SkinPrice]);
					ShowPlayerDialog(playerid, DIALOG_BUSINESS_SKIN_EDIT, DIALOG_STYLE_INPUT, "Clothing Store - Edit Prices", Array, "Purchase", "Cancel");
				}
			}
		}
		else return SendClientMessage(playerid, WHITE, "You are not inside a business you own!");
	}
	else SendClientMessage(playerid, WHITE, "You are not inside a business you own!");
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case DIALOG_BUSINESS_STORE_EDIT:
		{
			if(!response) return 1;
			switch(listitem)
			{
				case 0 .. MAX_BUSINESS_ITEMS_STORE:
				{
					new id = Player[playerid][InsideBusiness];
					if(listitem != 8) // Isn't editing fuel.
					{
						format(Array, sizeof(Array), "Enter a new cost for %s. The current price is $%d.\nSet the price to 0 to disable the item.", StoreItems[listitem], Business[id][ItemPrice][listitem]);
						ShowPlayerDialog(playerid, DIALOG_BUSINESS_STORE_EDIT2, DIALOG_STYLE_INPUT, "24/7 - Edit Prices", Array, "Purchase", "Cancel");
						SetPVarInt(playerid, "EditingPriceBiz", listitem);
					}
					else if(Business[id][BizType] == 6)
					{
						format(Array, sizeof(Array), "Enter a new cost for fuel. The current price is $%d.\nSet the price to 0 to disable the item.", Business[id][FuelPrice]);
						ShowPlayerDialog(playerid, DIALOG_BUSINESS_STORE_EDITFUEL, DIALOG_STYLE_INPUT, "24/7 - Edit Prices", Array, "Purchase", "Cancel");
					}
					SaveBusiness(id);
				}
			}
		}
		case DIALOG_BUSINESS_STORE_EDIT2:
		{
			if(!response) return 1;
			listitem = GetPVarInt(playerid, "EditingPriceBiz");
			if(!IsNumeric(inputtext)) 
			{
				format(Array, sizeof(Array), "Enter a new cost for %s. The current price is $%d.\nSet the price to 0 to disable the item.", StoreItems[listitem], Business[Player[playerid][InsideBusiness]][ItemPrice][listitem]);
				ShowPlayerDialog(playerid, DIALOG_BUSINESS_STORE_EDIT2, DIALOG_STYLE_INPUT, "24/7 - Edit Prices", Array, "Purchase", "Cancel");
			}

			Business[Player[playerid][InsideBusiness]][ItemPrice][listitem] = strval(inputtext);
			DeletePVar(playerid, "EditingPriceBiz");
			SaveBusiness(Player[playerid][InsideBusiness]);
		}
		case DIALOG_BUSINESS_STORE_EDITFUEL:
		{
			if(!response) return 1;
			if(!IsNumeric(inputtext)) 
			{
				format(Array, sizeof(Array), "Enter a new cost for fuel. The current price is $%d.\nSet the price to 0 to disable the item.", Business[Player[playerid][InsideBusiness]][FuelPrice]);
				ShowPlayerDialog(playerid, DIALOG_BUSINESS_STORE_EDITFUEL, DIALOG_STYLE_INPUT, "24/7 - Edit Prices", Array, "Purchase", "Cancel");
			}

			Business[Player[playerid][InsideBusiness]][FuelPrice] = strval(inputtext);
			DeletePVar(playerid, "EditingPriceBiz");
			SaveBusiness(Player[playerid][InsideBusiness]);
		}
		case DIALOG_BUSINESS_FOOD_EDIT:
		{
			if(!response) return 1;
			switch(listitem)
			{
				case 0 .. MAX_BUSINESS_ITEMS_FOOD:
				{
					new id = Player[playerid][InsideBusiness];
					format(Array, sizeof(Array), "Enter a new cost for %s. The current price is $%d.\nSet the price to 0 to disable the item.", FoodItems[listitem], Business[id][FoodItemPrice][listitem]);
					ShowPlayerDialog(playerid, DIALOG_BUSINESS_FOOD_EDIT2, DIALOG_STYLE_INPUT, "Resturaunt - Edit Prices", Array, "Purchase", "Cancel");
					SetPVarInt(playerid, "EditingPriceBiz", listitem);
					SaveBusiness(id);
				}
			}
		}
		case DIALOG_BUSINESS_FOOD_EDIT2:
		{
			if(!response) return 1;
			listitem = GetPVarInt(playerid, "EditingPriceBiz");
			if(!IsNumeric(inputtext)) 
			{
				format(Array, sizeof(Array), "Enter a new cost for %s. The current price is $%d.\nSet the price to 0 to disable the item.", FoodItems[listitem], Business[Player[playerid][InsideBusiness]][FoodItemPrice][listitem]);
				ShowPlayerDialog(playerid, DIALOG_BUSINESS_STORE_EDIT2, DIALOG_STYLE_INPUT, "Resturaunt - Edit Prices", Array, "Purchase", "Cancel");
			}

			Business[Player[playerid][InsideBusiness]][FoodItemPrice][listitem] = strval(inputtext);
			DeletePVar(playerid, "EditingPriceBiz");
			SaveBusiness(Player[playerid][InsideBusiness]);
		}
		case DIALOG_BUSINESS_GYM_EDIT:
		{
			if(!response) return 1;
			switch(listitem)
			{
				case 0 .. MAX_BUSINESS_ITEMS_STORE:
				{
					new id = Player[playerid][InsideBusiness];
					format(Array, sizeof(Array), "Enter a new cost for %s. The current price is $%d.\nSet the price to 0 to disable the item.", GymItems[listitem], Business[id][GymItemPrice][listitem]);
					ShowPlayerDialog(playerid, DIALOG_BUSINESS_GYM_EDIT2, DIALOG_STYLE_INPUT, "24/7 - Edit Prices", Array, "Purchase", "Cancel");
					SetPVarInt(playerid, "EditingPriceBiz", listitem);
					SaveBusiness(id);
				}
			}
		}
		case DIALOG_BUSINESS_GYM_EDIT2:
		{
			if(!response) return 1;
			listitem = GetPVarInt(playerid, "EditingPriceBiz");
			if(!IsNumeric(inputtext)) 
			{
				format(Array, sizeof(Array), "Enter a new cost for %s. The current price is $%d.\nSet the price to 0 to disable the item.", GymItems[listitem], Business[Player[playerid][InsideBusiness]][GymItemPrice][listitem]);
				ShowPlayerDialog(playerid, DIALOG_BUSINESS_STORE_EDIT2, DIALOG_STYLE_INPUT, "Resturaunt - Edit Prices", Array, "Purchase", "Cancel");
			}

			Business[Player[playerid][InsideBusiness]][GymItemPrice][listitem] = strval(inputtext);
			DeletePVar(playerid, "EditingPriceBiz");
			SaveBusiness(Player[playerid][InsideBusiness]);
		}
		case DIALOG_BUSINESS_SKIN_EDIT:
		{
			if(!response) return 1;
			new id = Player[playerid][InsideBusiness];
			if(!IsNumeric(inputtext)) 
			{
				format(Array, sizeof(Array), "Enter a new cost for skins. The current price is $%d.", Business[id][SkinPrice]);
				return ShowPlayerDialog(playerid, DIALOG_BUSINESS_SKIN_EDIT, DIALOG_STYLE_INPUT, "Clothing Store - Edit Prices", Array, "Purchase", "Cancel");
			}

			Business[id][SkinPrice] = strval(inputtext);
			format(Array, sizeof(Array), "You have edited the price for clothing to $%d", Business[id][SkinPrice]);
			SendClientMessage(playerid, WHITE, Array);
			SaveBusiness(id);
		}
	}
	return 1;
}