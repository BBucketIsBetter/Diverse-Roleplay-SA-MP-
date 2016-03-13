//============================================//
//=====[ CNT USAGE SECTION ]=====//
//============================================//
public OnPlayerConnect(playerid)
{
    if(IsPlayerNPC(playerid)) {
		new ip[128];
	    GetPlayerIp(playerid, ip, sizeof(ip));
	    if(strcmp(ip, CFG_IP, true) != 0) { KickPlayer(playerid, "You have been kicked for duplicating a NPC!");  }
		SetPlayerColor(playerid, COLOR_WHITE);
		return 1;
    }
    GetPlayerName(playerid, PlayerInfo[playerid][pUsername], MAX_PLAYER_NAME);
	format(PlayerInfo[playerid][pName], MAX_PLAYER_NAME, "%s", PlayerInfo[playerid][pUsername]);
	GiveNameSpace(PlayerInfo[playerid][pName]);
    ResetPlayerWeapons(playerid);
    //==============================//
    CancelSelectTextDraw(playerid);
	SetPlayerTime(playerid, GMHour, GMMin);
	SetPlayerColor(playerid, COLOR_GREY);
	//==============================//
    if(!NameIsRP(PlayerName(playerid))) {
		KickPlayer(playerid, "Your name is not acceptable, please use the format: Firstname_Lastname!");
		scm(playerid, COLOR_LIGHTRED, "This name is not acceptable.");
		return 1;
	}
	//==============================//
	new string[128];
	GetPlayerVersion(playerid, string, 128);
	if(strcmp(string, CFG_VERSION, true) != 0) {
        KickPlayer(playerid, "You are currently running an invalid version of SA-MP!");
        return true;
	}
	oocname[playerid] = "None";
	SetPVarInt(playerid,"EndOfBL",0);
	SetPVarInt(playerid,"usingPayphone",-1);
	chatanim[playerid] = 1;
	curPopVar[playerid] = 0;
	curPopVarEx[playerid] = 0;
	//==============================//
	//SetPlayerVirtualWorld(playerid, INVALID_MAXPL);
    //==============================//
    SetPVarInt(playerid, "InviteOffer", INVALID_MAXPL);
    SetPVarInt(playerid, "RefillOffer", INVALID_MAXPL);
	SetPVarInt(playerid, "RepairOffer", INVALID_MAXPL);
	SetPVarInt(playerid, "ShakeOffer", INVALID_MAXPL);
	SetPVarInt(playerid, "BlindOffer", INVALID_MAXPL);
	SetPVarInt(playerid, "VehicleOffer", INVALID_MAXPL);
	SetPVarInt(playerid, "Drag", INVALID_MAXPL);
	SetPVarInt(playerid, "Mobile", INVALID_MAXPL);
	SetPVarInt(playerid, "HouseOffer", INVALID_MAXPL);
	SetPVarInt(playerid, "BizzOffer", INVALID_MAXPL);
	SetPVarInt(playerid, "LiveOffer", INVALID_MAXPL);
	SetPVarInt(playerid, "DragOffer", INVALID_MAXPL);
    PlayerInfo[playerid][pLiveOffer][0]=0;
	PlayerInfo[playerid][pLiveOffer][1]=0;
	PlayerInfo[playerid][pSpeedDelay]=0;
	PlayerInfo[playerid][pBalling]=0;
	PlayerInfo[playerid][pBallTeam]=0;
	PlayerInfo[playerid][pBallDef]=0;
	PlayerInfo[playerid][DunkDelay]=0;
	PlayerInfo[playerid][BallDelay]=0;
	PlayerInfo[playerid][pPeeping]=0;
	PlayerInfo[playerid][pFishing]=0;
	PlayerInfo[playerid][pSerialBan]=0;
	PlayerInfo[playerid][pForbid]=0;
	PlayerInfo[playerid][pKeyDelay]=0;
	PlayerInfo[playerid][pInVehicle]=-1;
	PlayerInfo[playerid][pArmour]=0.0;
	PlayerInfo[playerid][pAHSkip]=0;
	PlayerInfo[playerid][pLastPrim]=-1;
	PlayerInfo[playerid][pLastSec]=-1;
	PlayerInfo[playerid][pLastMelee]=-1;
	for(new i=0; i < 6; i++) {
		CarKeys[playerid][i] = 0;
	}
    //==============================//
    strmid(PlayerInfo[playerid][pAudioUrl], "NULL", 0, strlen("NULL"), 255);
    strmid(PlayerInfo[playerid][pCellname], "None", 0, strlen("None"), 255);
    strmid(PlayerInfo[playerid][pDescribe], "None", 0, strlen("None"), 255);
    strmid(PlayerInfo[playerid][pDescribe2], "None", 0, strlen("None"), 255);
    strmid(PlayerInfo[playerid][pAdText], "None", 0, strlen("None"), 255);
    strmid(PlayerInfo[playerid][pMarriedTo], "None", 0, strlen("None"), 255);
	
    for(new i = 0; i < MAX_INV_SLOTS; i++)
	{
		PlayerInfo[playerid][pInvItem][i]=0;
		PlayerInfo[playerid][pInvQ][i]=0;
		PlayerInfo[playerid][pInvEx][i]=0;
	}
	PlayerInfo[playerid][pPlayerWeapon]=0;
	PlayerInfo[playerid][pPlayerAmmo]=0;
	PlayerInfo[playerid][pSerial]=0;
	PlayerInfo[playerid][pAmmoType]=0;
	PlayerInfo[playerid][pDelay]=0;
	PlayerInfo[playerid][pBuyDialog]=0;
	
	BuildIntroTextDraws(playerid);
	BuildWheelMenu(playerid);
	BuildFishingTextdraws(playerid);
	
	Delete3DTextLabel(PlayerTag[playerid]);
	
	// Load MDC TextDraws:
	mdc_LoadPlayerTextdraws(playerid);
	
	//Remove buildings earlier.
	RemoveBuildings(playerid);
	return 1;
}
//============================================//
stock DisconnectSet(playerid) {
	if(GetPVarInt(playerid, "RentKey") > 0) {
	    VehicleInfo[GetPVarInt(playerid, "RentKey")][vDespawnTimer] = SetTimerEx("DespawnRentalVehicle", 300000, false, "i", GetPVarInt(playerid, "RentKey")); }

	if(GetPVarInt(playerid, "RouteVeh") >= 1) {
	    if(VehicleInfo[GetPVarInt(playerid, "RouteVeh")][vType] == VEHICLE_JOB) {
	    DespawnVehicle(GetPVarInt(playerid, "RouteVeh")); }
	}

	if(GetPVarInt(playerid, "TakeTest") >= 1 && GetPVarInt(playerid, "TestVeh") >= 1) {
	    DespawnVehicle(GetPVarInt(playerid, "TestVeh")); }

	if(GetPVarInt(playerid, "MaskUse") == 1) {
		Delete3DTextLabel(PlayerTag[playerid]); }

	if(GetPVarInt(playerid, "LSPD_Ta") == 1) {
       	PlayerInfo[playerid][pPlayerWeapon]=0;
       	PlayerInfo[playerid][pPlayerAmmo]=0;
		PlayerInfo[playerid][pSerial]=0; }
       	
    foreach(new i : Player) {
		if(GetPVarInt(i, "VehicleOffer") == playerid) {
            SetPVarInt(i, "VehicleOffer", INVALID_MAXPL);
			DeletePVar(i, "VehicleOfferPrice");
			DeletePVar(i, "VehicleOfferID"); }
	}

	for(new i = 0; i < MAX_PLAYER_ATTACHED_OBJECTS; i++) {
		RemovePlayerAttachedObject(playerid, i); }

	if(GetPVarInt(playerid, "Mobile") != INVALID_MAXPL) {
	    if(IsPlayerConnected(GetPVarInt(playerid, "Mobile")) && GetPVarInt(GetPVarInt(playerid, "Mobile"), "Mobile") == playerid) {
		    CallRemoteFunction("LoadRadios", "i", GetPVarInt(playerid, "Mobile"));
		    SendClientMessage(GetPVarInt(playerid, "Mobile"), COLOR_GREY, "The phone line went dead...");
			if(GetPlayerSpecialAction(GetPVarInt(playerid, "Mobile")) == SPECIAL_ACTION_USECELLPHONE) CellphoneState(GetPVarInt(playerid, "Mobile"), 2);
			SetPVarInt(GetPVarInt(playerid, "Mobile"), "Mobile", INVALID_MAXPL); }
        SetPVarInt(playerid, "Mobile", INVALID_MAXPL);
	}

	SetPVarInt(playerid, "DragOffer", INVALID_MAXPL);

	// Removing players' CommandSpam delays and spams.
	PlayerInfo[playerid][pCmdSpam] = 0;
	PlayerInfo[playerid][pCmdTime] = 0;
	DeletePVar(playerid, "Delay");
	
	//Enable fishing CP
	TogglePlayerDynamicCP(playerid, FishCP, 1);
	return 1;
}
//============================================//
public OnPlayerDisconnect(playerid, reason)
{
    if(IsPlayerNPC(playerid)) return 1;
	new string[128], sendername[MAX_PLAYER_NAME], query[128];
	if(GetPVarInt(playerid, "Mobile") != INVALID_MAXPL)
	{
	    if(IsPlayerConnected(GetPVarInt(playerid, "Mobile")) && GetPVarInt(GetPVarInt(playerid, "Mobile"), "Mobile") == playerid)
		{
		    CallRemoteFunction("LoadRadios","i", GetPVarInt(playerid, "Mobile"));
		    SendClientMessage(GetPVarInt(playerid, "Mobile"),COLOR_GREY,"The phone line went dead...");
			if(GetPlayerSpecialAction(GetPVarInt(playerid, "Mobile")) == SPECIAL_ACTION_USECELLPHONE) CellphoneState(GetPVarInt(playerid, "Mobile"),2);
			SetPVarInt(GetPVarInt(playerid, "Mobile"), "Mobile", INVALID_MAXPL);
			cancelPayphone(GetPVarInt(playerid, "Mobile"));
	    }
        SetPVarInt(playerid, "Mobile", INVALID_MAXPL);
	}
	cancelPayphone(playerid);
	
    // Despawn vehicle 10 minutes after the player has logged off.
    foreach(new v : Vehicle)
    {
		if(PlayerOwnsVehicle(playerid, v)) {
			VehicleInfo[v][vDespawnTimer] = SetTimerEx("DespawnPlayerVehicle", 600000, false, "i", v);
		}
    }
	
	PlayerInfo[playerid][pOffReg] = 0;
	switch(GetPVarInt(playerid, "PlayerLogged"))
	{
		case 1:
		{
		    format(query, sizeof(query), "UPDATE `accounts` SET `Online` = 0 WHERE `Name`='%s'", PlayerName(playerid));
		    mysql_tquery(handlesql, query);
		    format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
	        GiveNameSpace(sendername);
	        switch(reason)
	        {
	            case 0:
	            {
	                format(string, sizeof(string), "(SERVER): %s has left the server, (REASON): Crashed.", sendername);
	                SetPVarInt(playerid, "Crash", 1), SetPVarInt(playerid, "Crashes", GetPVarInt(playerid, "Crashes")+1);
	            }
	            case 1:
	            {
				    format(string, sizeof(string), "(SERVER): %s has left the server, (REASON): Disconnected.", sendername);
				    if(GetPVarInt(playerid, "Cuffed") == 0)
				    {
				        SetPVarInt(playerid, "SpawnLocation", 1);
				    }
				}
	            case 2: format(string, sizeof(string), "(SERVER): %s has left the server, (REASON): Kicked/Banned.", sendername);
	        }
	        if(GetPlayerState(playerid) != PLAYER_STATE_SPECTATING) ProxDetector(20.0, playerid, string, COLOR_LIGHTRED);
	        //==========//
	        TextDrawDestroy(MoneyDraw[playerid]);
	        TextDrawDestroy(LocationDraw[playerid]);
			PlayerTextDrawDestroy(playerid, PayTDraw[playerid]);
	        //==========//
	        if(GetPVarInt(playerid, "VD") == 1)
	        {
	            for(new i; i < 5; i++) { TextDrawHideForPlayer(playerid, VehicleDraw[i]); }
			    for(new i; i < 2; i++)
			    {
			        TextDrawHideForPlayer(playerid, VehicleIDraw[i][playerid]);
		            TextDrawDestroy(VehicleIDraw[i][playerid]);
			    }
			    DeletePVar(playerid, "VD");
			}
			//==========//
			new member = GetPVarInt(playerid, "Member");
			if(member == 1 || member== 2 || member == 3 || member == 4 || member == 5 || member == 8)
	    	{
	        	if(reason == 1)
	        	{
	            	foreach(new car : Vehicle)
		        	{
		            	if(CopInfo[car][Created] == 1)
	                	{
			            	if(strcmp(CopInfo[car][Owner], PlayerName(playerid), true) == 0)
			            	{
			                	VehicleInfo[car][vType] = VEHICLE_NONE;
			                	CopInfo[car][Created] = 0;
			                	DespawnVehicle(car);
								for(new i = 0; i < 2; i++) {
									CopInfo[car][Gun_Rack_Weapon][i] = 0;
									CopInfo[car][Gun_Rack_Ammo][i] = 0;
									CopInfo[car][Gun_Rack_E][i] = 0;
									CopInfo[car][Gun_Rack_Serial][i] = 0;
								}
			                	return 1;
			            	}
		            	}
	            	}
	        	}
	    	}
	    	//==========//
			DisconnectSet(playerid);
    		CallRemoteFunction("OnPlayerDataSave", "i", playerid);
		}
	    case 2:
	    {
			DestroyIntoTextDraws(playerid);
	    }
	}
	return 1;
}
//============================================//