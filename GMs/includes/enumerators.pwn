enum PlayerData
{
    DatabaseID,
    Username[MAX_PLAYER_NAME],
    Password[129],
    IP[16],
    Authenticated,
    Float: PosX,
    Float: PosY,
    Float: PosZ,
    Float: PosA,
    Float: Health,
    Float: Armour,
    Interior,
    VirtualWorld,
    Money,
    BankMoney,
    Weapon[12],
    AdminLevel,
    AdminDuty,
    AdminSkin,
    AdminName[MAX_PLAYER_NAME],
	Skin,
    Accent,
    Gender,
    Age,
    PlayerGroup,
    GroupRank,
    GroupDiv,
    Leader,
    PhoneNumber,
    Rope,
    Rags,
    PortableRadio,
    Frequency,
    Cigar,
    Lottery,
    LotteryNumber,
    InsideBusiness,
    Fightstyle,
    JailTime,
    ArrestedBy,
    PhoneTimer,
    TotalCrimes,
    TotalArrests,
    Crimes,
    Speedo,
    OnDuty,
    Taser,
    Backup,
    Injured,
    PlayerJob,
    JobSkill[MAX_JOBS],
    MechanicTimer,
    Materials,
    Drugs[2],
    ConnectedSeconds,
    PlayingHours,
    ContractID,
    Contracted,
    ContractAmount,
    ContractedBy[MAX_PLAYER_NAME],
    ContractedReason[150]
};

enum PlayerVehicleData
{
    CarDatabaseID[MAX_PLAYER_VEHICLES],
    CarID[MAX_PLAYER_VEHICLES],
    CarModel[MAX_PLAYER_VEHICLES],
    Float:CarX[MAX_PLAYER_VEHICLES],
    Float:CarY[MAX_PLAYER_VEHICLES],
    Float:CarZ[MAX_PLAYER_VEHICLES],
    Float:CarA[MAX_PLAYER_VEHICLES],
    CarColour[MAX_PLAYER_VEHICLES],
    CarColour2[MAX_PLAYER_VEHICLES],
    CarVW[MAX_PLAYER_VEHICLES],
    CarInt[MAX_PLAYER_VEHICLES],
    CarFuel[MAX_PLAYER_VEHICLES],
    CarMod0[MAX_PLAYER_VEHICLES],
    CarMod1[MAX_PLAYER_VEHICLES],
    CarMod2[MAX_PLAYER_VEHICLES],
    CarMod3[MAX_PLAYER_VEHICLES],
    CarMod4[MAX_PLAYER_VEHICLES],
    CarMod5[MAX_PLAYER_VEHICLES],
    CarMod6[MAX_PLAYER_VEHICLES],
    CarMod7[MAX_PLAYER_VEHICLES],
    CarMod8[MAX_PLAYER_VEHICLES],
    CarMod9[MAX_PLAYER_VEHICLES],
    CarMod10[MAX_PLAYER_VEHICLES],
    CarMod11[MAX_PLAYER_VEHICLES],
    CarMod12[MAX_PLAYER_VEHICLES],
    CarMod13[MAX_PLAYER_VEHICLES],
    CarPaintJob[MAX_PLAYER_VEHICLES],
    CarPlate1[8],
    CarPlate2[8],
    CarPlate3[8],
    CarPlate4[8],
    CarPlate5[8]
}

enum GroupData
{
    GroupName[256],
    GroupType,
    GroupRanks[MAX_GROUP_RANKS],
    GroupPaycheque[MAX_GROUP_RANKS],
    GroupDivisions[6],
    GroupGovPay,
    GroupMOTD[256],
    GroupColour,
    Float:GroupSafePos[3],
    GroupMoney
};

enum HouseData
{
    Owner[MAX_PLAYER_NAME],
    Owned,
    Float:HousePos[8],
    HouseVW[2],
    HouseInt[2],
    Price,
    Locked,
    Custom[2],
    HousePickup,
    Text3D:HouseText
};

enum DoorData
{
    DoorName[36],
    DoorOwner[MAX_PLAYER_NAME],
    Float:DoorPos[8],
    DoorVW[2],
    DoorInt[2],
    Vehicleable,
    DoorGroup,
    DoorLocked,
    Restricted,
    DoorCustom[2],
    DoorPickupModel,
    DoorPickup,
    Text3D:DoorText
};

enum BusinessData
{
    BizName[26],
    BizOwner[MAX_PLAYER_NAME],
    BizOwned,
    Float:BizPos[8],
    Float:CarSpawnPos[4],
    BizVW[2],
    BizInt[2],
    BizType,
    ItemPrice[MAX_BUSINESS_ITEMS_STORE],
    FoodItemPrice[MAX_BUSINESS_ITEMS_FOOD],
    GymItemPrice[MAX_BUSINESS_ITEMS_GYM],
    SkinPrice,
    FuelPrice,
    Float:FuelLocation[3],
    Text3D:FuelText,
    Stock,
    BizCustom[2],
    BizPrice,
    BizLocked,
    BizPickup,
    Text3D:BizText
}

enum VehicleData
{
    VehID,
    VehicleDatabaseID,
    Model,
    Float:VehiclePos[4],
    VehicleInt,
    VehicleVW,
    VehicleColour[2],
    VehFuel,
    VehicleJob,
    VehicleGroup,
    Siren,
    Float:MaxHealth,
    RespawnTime,
    Plate[16]
};

enum DealershipData
{
    DealerVehID,
    DealershipPrice,
    Text3D:DealerTextID,
    DealerBiz,
    DealerDatabaseID,
    DealerModel,
    Float:DealerVehPos[4],
    DealerVehInt,
    DealerVehVW
};

enum GateData
{
    GateID,
    GateModel,
    Float: GatePos[3],
    Float: GateRot[3],
    Float: GateMove[3],
    Float: GateMoveRot[3],
    GateOwner[MAX_PLAYER_NAME],
    GatePass[50],
    GateGroup,
    GateRank,
    UseF,
    GateVW,
    GateInt,
    Float: GateSpeed,
    Float: GateRange,
    GateStatus
};

enum JobData
{
    JobName[50],
    Float: JobPos[3],
    JobType,
    JobPickup,
    Text3D:JobText
};

enum ReportData
{
	Report[256],
	Used,
	BeenUsed,
	Reporter,
	CheckingReport,
 	ReportExpireTime,
	ReportExpireTimer
};

enum PointData 
{
    poID,
    poType,
    poName[MAX_PLAYER_NAME],
    Float:poPos[3],
    Float:poPos2[3],
    Float:CapturePos[3],
    CapturePlayerName[MAX_PLAYER_NAME], // The person who SUCCESSFULLY captured the point.
    PlayerNameCapping[MAX_PLAYER_NAME], // The person who is ATTEMPTING to capture the point.
    poCapperGroup, // The ID of the group who is ATTEMPTING to capture the point.
    poCapperGroupOwned, // The ID of the group who actually OWNS the point.
    poCapturable,
    poInactive,
    poPickupID,
    poPickup2ID,
    poMaterials,
    HasCrashed,
    pointVW,
    pointVW2,
    poTimer,
    poTimestamp1, // Timestamp til becomes capturable
    poTimestamp2, // Timestamp til is captured
    Text3D:poTextID,
    poBeingCaptured,
    poCaptureTime
}

enum ArrestData
{
    Float:ArrestPos[3],
    ArrestVW,
    ArrestInt,
    ArrestGroup,
    ArrestPickup,
    Text3D:ArrestText
};

enum LockerData
{
    Float:LockerPos[3],
    LockerVW,
    LockerInt,
    LockerGroup,
    Text3D:LockerText
};

enum CrimeData
{
    CrimeName[256]
};

enum SAZONE_MAIN //Betamaster
{ 
    SAZONE_NAME[28],
    Float:SAZONE_AREA[6]
};

enum MAIN_ZONES //Betamaster
{ 
    SAZONE_NAME[28],
    Float:SAZONE_AREA[6]
};