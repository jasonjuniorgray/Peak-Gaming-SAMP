#include <YSI\y_hooks>

hook OnGameModeInit()
{
	Create3DPickups();
	Create3DTextLabels();
	return 1;
}

Create3DPickups()
{
	CreateDynamicPickup(1240, 23, Hospitals[0][0], Hospitals[0][1], Hospitals[0][2], -1); // All Saints Delivery
	CreateDynamicPickup(1240, 23, Hospitals[1][0], Hospitals[1][1], Hospitals[1][2], -1); // County General Delivery

	CreateDynamicPickup(1240, 23, 478.8556, 159.4606, 1023.4783, -1); // Mulhulland Bank
	return 1;
}

Create3DTextLabels()
{
	CreateDynamic3DTextLabel("All Saints Hospital\nMedic: /deliverpatient", LIGHTRED, Hospitals[0][0], Hospitals[0][1], Hospitals[0][2], 10.0); // All Saints Delivery
	CreateDynamic3DTextLabel("County General Hospital\nMedic: /deliverpatient", LIGHTRED, Hospitals[1][0], Hospitals[1][1], Hospitals[1][2], 10.0); // County General Delivery

	CreateDynamic3DTextLabel("Mulhulland Bank", YELLOW, 478.8556, 159.4606, 1023.4783, 10.0); // County General Delivery
	return 1;
}