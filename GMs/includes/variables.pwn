new SQL, Float:Spawn[4], ServerGMX, SpawnMoney[2], LotteryInfo[2], GlobalHour, GlobalMinute, GlobalSecond, Weather;

new Array[4096]; // Much cleaner way of doing this, define it globally and use it when needed. Rather than defining strings locally. (Added 5/13/2016 - Do not remove, unless you want errors)

new OneMinuteInt;

/* enumerators */
new Player[MAX_PLAYERS][PlayerData];
new Group[MAX_GROUPS][GroupData];
new House[MAX_HOUSES][HouseData];
new Door[MAX_DOORS][DoorData];
new Business[MAX_BUSINESSES][BusinessData];
new Gate[MAX_GATES][GateData];
new Job[MAX_JOBS][JobData];
new Arrest[MAX_ARRESTPOINTS][ArrestData];
new Locker[MAX_LOCKERS][LockerData];
new Crime[MAX_CRIMES][CrimeData];
new Vehicle[MAX_DYN_VEHICLES][VehicleData];
new Dealership[MAX_VEHICLES][DealershipData];
new Reports[MAX_REPORTS][ReportData];
new Point[MAX_POINTS][PointData];

new GroupRankNames[MAX_GROUPS][MAX_GROUP_RANKS][256];
new GroupDivisionNames[MAX_GROUPS][6][256];

new Fuel[MAX_VEHICLES];

new AdminVehicles[MAX_ADMIN_VEHICLES] = INVALID_VEHICLE_ID;

/* textdraws */
new PlayerText: FuelTextDraw[MAX_PLAYERS];
new PlayerText: SpeedTextDraw[MAX_PLAYERS];
new Text:		AnimationHelper;
new Text:       LimboTextDraw;

/* forwards */
forward FinishQuery(resultid, extraid, handleid);
forward CheckAccount(playerid);
forward OnPlayerRegisterAccount(playerid);
forward OnPlayerLogin(playerid);
forward InitiateGroups();
forward SetPlayerPosEx(playerid, Float: X, Float: Y, Float: Z, Float: A, interior, virtualworld);
forward SendToAdmins(colour, string[], requireduty, requiredlevel);

/*
forward LoadGroups();
forward LoadHouses();
forward LoadDoors();
forward LoadBusinesses();
forward LoadVehicles();
forward LoadDealershipVehicles();
forward LoadArrestPoints();
forward LoadLockers();
forward LoadGates();
forward LoadJobs();
forward LoadCrimes();
forward LoadPoints();*/

/* misc variables */

new const VehicleNames[212][] = {
	"Landstalker","Bravura","Buffalo","Linerunner","Perennial","Sentinel","Dumper","Firetruck","Trashmaster","Stretch",
	"Manana","Infernus","Voodoo","Pony","Mule","Cheetah","Ambulance","Leviathan","Moonbeam","Esperanto","Taxi",
	"Washington","Bobcat","Mr Whoopee","BF Injection","Hunter","Premier","Enforcer","Securicar","Banshee","Predator",
	"Bus","Rhino","Barracks","Hotknife","Trailer","Previon","Coach","Cabbie","Stallion","Rumpo","RC Bandit", "Romero",
	"Packer","Monster","Admiral","Squalo","Seasparrow","Pizzaboy","Tram","Trailer","Turismo","Speeder","Reefer","Tropic","Flatbed",
	"Yankee","Caddy","Solair","Berkley's RC Van","Skimmer","PCJ-600","Faggio","Freeway","RC Baron","RC Raider",
	"Glendale","Oceanic","Sanchez","Sparrow","Patriot","Quad","Coastguard","Dinghy","Hermes","Sabre","Rustler",
	"ZR-350","Walton","Regina","Comet","BMX","Burrito","Camper","Marquis","Baggage","Dozer","Maverick","News Chopper",
	"Rancher","FBI Rancher","Virgo","Greenwood","Jetmax","Hotring Racer","Sandking","Blista Compact","Police Maverick",
	"Boxville","Benson","Mesa","RC Goblin","Hotring Racer A","Hotring Racer B","Bloodring Banger","Rancher","Super GT",
	"Elegant","Journey","Bike","Mountain Bike","Beagle","Cropduster","Stuntplane","Tanker","Road Train","Nebula","Majestic",
	"Buccaneer","Shamal","Hydra","FCR-900","NRG-500","HPV-1000","Cement Truck","Tow Truck","Fortune","Cadrona","FBI Truck",
	"Willard","Forklift","Tractor","Combine","Feltzer","Remington","Slamvan","Blade","Freight","Streak","Vortex","Vincent",
	"Bullet","Clover","Sadler","Firetruck","Hustler","Intruder","Primo","Cargobob","Tampa","Sunrise","Merit","Utility",
	"Nevada","Yosemite","Windsor","Monster A","Monster B","Uranus","Jester","Sultan","Stratum","Elegy","Raindance","RC Tiger",
	"Flash","Tahoma","Savanna","Bandito","Freight","Trailer","Kart","Mower","Duneride","Sweeper","Broadway",
	"Tornado","AT-400","DFT-30","Huntley","Stafford","BF-400","Newsvan","Tug","Trailer","Emperor","Wayfarer",
	"Euros","Hotdog","Club","Trailer","Trailer","Andromada","Dodo","RCCam","Launch","Police Car (LSPD)","Police Car (SFPD)",
	"Police Car (LVPD)","Police Ranger","Picador","S.W.A.T. Van","Alpha","Phoenix","Glendale","Sadler","Luggage Trailer A",
	"Luggage Trailer B","Stair Trailer","Boxville","Farm Plow","Utility Trailer"
};

new UnmodifiableVehicles[29] =
{
	581,523,462,521,463,522,461,448,468,586,
    509,481,510,472,473,493,595,484,430,453,
    452,446,454,590,569,537,538,570,449
};

new Float:PrisonLSPD[3][3] = {
{115.0158, 246.8853, 1024.4165},
{114.4784, 234.3702, 1024.4231},
{110.6974, 247.4793, 1024.4165}
};

new Float:TruckerCheckpoints[8][3] = {
{1025.3368, -918.4128, 42.7766},
{787.5068, -1618.1384, 13.9769},
{1915.9900, -1790.5170, 13.9732},
{2121.8145, -1781.8267, 13.9815},
{1915.9900, -1790.5170, 13.9732},
{1078.5503, -1568.6083, 13.9874},
{998.0937, -1436.8132, 14.1380},
{833.8846, -1207.7870, 17.5655}
};