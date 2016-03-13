//============================================//
//=====[ ACC USAGE SECTION ]=====//
//============================================//
public OnPlayerRequestClass(playerid, classid)
{
    SetPVarInt(playerid, "BeingBanned", 0);
    if(IsPlayerNPC(playerid))
	{
		new i = -1;
		i = GetNPCID(playerid);
        if(i != -1) {
            NPCInfo[i][nUsed]=1;
            SetSpawnInfo(playerid, 69, NPCInfo[i][nModel], NPCInfo[i][n_X], NPCInfo[i][n_Y], NPCInfo[i][n_Z], NPCInfo[i][n_A], -1,-1,-1,-1,-1,-1);
            SetPlayerFacingAngle(playerid, NPCInfo[i][n_A]);
            SetPlayerInterior(playerid, NPCInfo[i][nInt]);
            SetPlayerVirtualWorld(playerid, NPCInfo[i][nWorld]);
			//=====//
            switch(NPCInfo[i][nType])
            {
                case NPC_TYPE_BUS_1: {
                    PutPlayerInVehicle(playerid, BotBus, 0);
                }
                case NPC_TYPE_BUS_2: {
                    PutPlayerInVehicle(playerid, BotBus2, 0);
                }
                case NPC_TYPE_TRAIN: {
                    PutPlayerInVehicle(playerid, BotTrain, 0);
                }
            }
        }
	    return 1;
	}
    else
    {
        SpawnPlayer(playerid);
        if(GetPVarInt(playerid, "PlayerLogged") == 1) return SpawnPlayer(playerid);
        PlayAudioStreamForPlayerEx(playerid, "http://www.diverseroleplay.org/sounds/beat.mp3");
		ClearChatbox(playerid, 50);
		CheckIfBanned(playerid);
		//==============================//
		TogglePlayerSpectating(playerid, 1);
	    //==============================//
	    TextDrawShowForPlayer(playerid, SideBar1);
	    TextDrawShowForPlayer(playerid, SideBar2);
	    //==============================//
		CheckAccount(playerid, 1);
	    //==============================//
	    SetTimerEx("LoginCamera", 500, false, "i", playerid);
	    //==============================//
    }
	return 1;
}
//============================================//
sqlconnect()
{
    handlesql = mysql_connect(MYSQL_HOST,MYSQL_USER,MYSQL_DB,MYSQL_PASS);
    if(handlesql) printf("SUCCESS: Connected To MySQL!");
    else printf("ERROR: Failed to connect to Mysql!");
    return 1;
}
//============================================//
stock CheckAccount(playerid, type)
{
    new query[82];
	format(query, sizeof(query), "SELECT * FROM `accounts` WHERE `Name` = '%s'", PlayerName(playerid));
	mysql_function_query(handlesql, query, true, "OnAccountCheck", "dd", playerid, type);
	return 1;
}
//============================================//
forward LogUserIn(playerid);
public LogUserIn(playerid)
{
    SetPVarInt(playerid, "VehicleLoaded", 1);
	new string[128];
    new fields, rows;
    cache_get_data(rows, fields);
    if(rows)
	{
     	CallRemoteFunction("OnPlayerLogin","ii",playerid, 0);
	}
    else
    {
        if(GetPVarInt(playerid, "WrongPassword") >= 5) Kick(playerid);
	    SetPVarInt(playerid, "WrongPassword", 1+GetPVarInt(playerid, "WrongPassword"));
	    new amount = 5 - GetPVarInt(playerid, "WrongPassword");
	    format(string, sizeof(string),"Invalid password (%d tries left).", amount);
	    SendClientMessage(playerid,COLOR_LIGHTRED,string);
	    ShowPlayerDialog(playerid,1,DIALOG_STYLE_PASSWORD,"Server Account","Welcome back to Diverse RP, please enter your password to login.","Login", "");
		CheckAccount(playerid, 1);
    }
    return 1;
}
//============================================//
public OnAccountCheck(playerid, type)
{
	if(playerid != INVALID_PLAYER_ID)
	{
		new rows, fields;
		cache_get_data(rows, fields, handlesql);
		if(rows)
		{
		    new fetch[24];
		    cache_get_field_content(0, "Tut", fetch);
		    SetPVarInt(playerid, "Tut", strval(fetch));
		    SetPVarInt(playerid, "AccountExist", 1);
		    if(type == 1)
		    {
				SendClientMessage(playerid, COLOR_LIGHTBLUE, "NOTE: If you ever forget your password you can recover it at ucp.diverseroleplay.org assuming you entered a real email.");
		        cache_get_row(0, 2, PlayerInfo[playerid][pPass]);
	            ShowPlayerDialog(playerid,1,DIALOG_STYLE_PASSWORD,"Server Account","Welcome back to Diverse RP, please enter your password to login.","Login", "");
	        }
		}
		else //if(GetPVarInt(playerid, "AccountExist") != 1)
		{
			new query[100];
			mysql_format(handlesql, query, sizeof(query), "SELECT `Time` FROM applications WHERE `Name`='%s'", PlayerName(playerid));
			mysql_tquery(handlesql, query, "CheckIfApplied", "i", playerid);
		}
	}
	return 1;
}
//=============================================//
forward CheckIfApplied(playerid);
public CheckIfApplied(playerid)
{
	if(cache_get_row_count() < 1) return ShowPlayerDialog(playerid,2,DIALOG_STYLE_PASSWORD,"Register Account","There is no existing account using your playername, please create a new account!\nPlease enter your desired password.","Register", "");
	SCM(playerid, COLOR_ORANGE, "Your account is still pending approval. You don't have to be online for your application to be reviewed.");
	new string[142],fetch[25];
	cache_get_field_content(0, "Time", fetch);
	new time = GetCount() - strval(fetch);
	format(string, sizeof(string), "Character Name: %s\n-----\nTime elapsed: %i minutes.\n-----\nApplications pending: %i",PlayerName(playerid),(time/60000),cache_get_row_count());
	return ShowPlayerDialog(playerid,513,DIALOG_STYLE_MSGBOX,"Your application is pending.", string, "Refresh", "");
}
//============================================//
forward RefreshAppStatus(playerid);
public RefreshAppStatus(playerid)
{
	new string[142],fetch[25];
	cache_get_field_content(0, "Time", fetch);
	new time = GetCount() - strval(fetch);
	format(string, sizeof(string), "Character Name: %s\n-----\nTime elapsed: %i minutes.\n-----\nApplications pending: %i",PlayerName(playerid),(time/60000),cache_get_row_count());
	return ShowPlayerDialog(playerid,513,DIALOG_STYLE_MSGBOX,"Your application is pending.", string, "Refresh", "");
}
//============================================//
public OnPlayerLogin(playerid, type)
{
	new query[255];
	format(query, sizeof(query), "SELECT * FROM `accounts` WHERE `Name`='%s'", PlayerName(playerid));
	mysql_function_query(handlesql, query, true, "OnAccountLoad", "dd", playerid, type);
    new ip[128], datum[50],hour,minute,second,year,month,day,tijd[50];
	getdate(year, month, day);
	gettime(hour,minute,second);
    format(datum, sizeof(datum), "%d-%d-%d", year, month, day);
    format(tijd, sizeof(tijd), "%d:%d:%d", hour, minute, second);
    GetPlayerIp(playerid, ip, sizeof(ip));
    format(query, sizeof(query),"INSERT INTO `logs_logingame`(`name`, `ip`, `date`, `time`) VALUES ('%s','%s','%s','%s')",
    PlayerName(playerid), ip, datum, tijd);
    mysql_tquery(handlesql, query);
	DestroyIntoTextDraws(playerid);
	return 1;
}
//============================================//
public OnAccountLoad(playerid, type)
{
	// LOAD ACCOUNT DATA //
	if(type == 0)
	{
		CheckIfBanned(playerid);
		
	    new query[255], emailv[64];
		SetPVarInt(playerid, "Cash", cache_get_field_content_int(0, "Cash"));
		SetPVarInt(playerid, "Bank", cache_get_field_content_int(0, "Bank"));
		SetPVarInt(playerid, "Model", cache_get_field_content_int(0, "Model"));
		SetPVarInt(playerid, "Interior", cache_get_field_content_int(0, "Interior"));
		SetPVarInt(playerid, "World", cache_get_field_content_int(0, "World"));
		SetPVarInt(playerid, "Tut", cache_get_field_content_int(0, "Tut"));
		SetPVarInt(playerid, "Age", cache_get_field_content_int(0, "Age"));
		SetPVarInt(playerid, "Sex", cache_get_field_content_int(0, "Sex"));
		SetPVarFloat(playerid, "PosX", cache_get_field_content_float(0, "PosX"));
		SetPVarFloat(playerid, "PosY", cache_get_field_content_float(0, "PosY"));
		SetPVarFloat(playerid, "PosZ", cache_get_field_content_float(0, "PosZ"));
		SetPVarFloat(playerid, "Health", cache_get_field_content_float(0, "Health"));
		new Float:armr = cache_get_field_content_float(0, "Armour");
		PlayerInfo[playerid][pArmour] = armr;
		SetPlayerArmourEx(playerid, armr);
		SetPVarInt(playerid, "Admin", cache_get_field_content_int(0, "Admin"));
		SetPVarInt(playerid, "Helper", cache_get_field_content_int(0, "Helper"));
		SetPVarInt(playerid, "Reg", cache_get_field_content_int(0, "Reg"));
		SetPVarInt(playerid, "Jailed", cache_get_field_content_int(0, "Jailed"));
		SetPVarInt(playerid, "Jailtime", cache_get_field_content_int(0, "Jailtime"));
		SetPVarInt(playerid, "ConnectTime", cache_get_field_content_int(0, "ConnectTime"));
		SetPVarInt(playerid, "DriveLic", cache_get_field_content_int(0, "DriveLic"));
		SetPVarInt(playerid, "GunLic", cache_get_field_content_int(0, "GunLic"));
		
		SetPVarInt(playerid, "helpmes", cache_get_field_content_int(0, "helpme"));

		SetPVarInt(playerid, "Member", cache_get_field_content_int(0, "Member"));
		SetPVarInt(playerid, "Rank", cache_get_field_content_int(0, "Rank"));
		SetPVarInt(playerid, "JobReduce", cache_get_field_content_int(0, "JobReduce"));
		SetPVarInt(playerid, "Job", cache_get_field_content_int(0, "JobID"));
		SetPVarInt(playerid, "DonateRank", cache_get_field_content_int(0, "DonateRank"));
		SetPVarInt(playerid, "Fightstyle", cache_get_field_content_int(0, "Fightstyle"));
		SetPVarInt(playerid, "HouseKey", cache_get_field_content_int(0, "HouseKey"));
		SetPVarInt(playerid, "BizzKey", cache_get_field_content_int(0, "BizzKey"));
		SetPVarInt(playerid, "WalkieFreq", cache_get_field_content_int(0, "WalkieFreq"));
		SetPVarInt(playerid, "PhoneNum", cache_get_field_content_int(0, "PhoneNum"));
		SetPVarInt(playerid, "PayDay", cache_get_field_content_int(0, "PayDay"));
		SetPVarInt(playerid, "PayCheck", cache_get_field_content_int(0, "PayCheck"));
		SetPVarInt(playerid, "CheckEarn", cache_get_field_content_int(0, "CheckEarn"));
		
		SetPVarInt(playerid, "CarTicket", cache_get_field_content_int(0, "CarTicket"));
		SetPVarInt(playerid, "Changes", cache_get_field_content_int(0, "Changes"));
        SetPVarInt(playerid, "ChatStyle", cache_get_field_content_int(0, "ChatStyle"));
		
		PlayerInfo[playerid][pForbid] = cache_get_field_content_int(0, "Forbid");
		PlayerInfo[playerid][pWepSerial] = cache_get_field_content_int(0, "WepSerial");

		PlayerInfo[playerid][pPlayerWeapon] = cache_get_field_content_int(0, "PlayerWeapon");
		PlayerInfo[playerid][pPlayerAmmo] = cache_get_field_content_int(0, "PlayerAmmo");
		PlayerInfo[playerid][pSerial] = cache_get_field_content_int(0, "PlayerSerial");
		PlayerInfo[playerid][pAmmoType] = cache_get_field_content_int(0, "AmmoType");
		
		PlayerInfo[playerid][pLastPrim] = cache_get_field_content_int(0, "LastPrim");
		PlayerInfo[playerid][pLastSec] = cache_get_field_content_int(0, "LastSec");
		PlayerInfo[playerid][pLastMelee] = cache_get_field_content_int(0, "LastMelee");
		
		PlayerInfo[playerid][pBuyDialog] = cache_get_field_content_int(0, "BuyDialog");
		
		new fetch[128];
		
		cache_get_field_content(0, "MaskID", fetch);
		SetPVarInt(playerid, "MaskID", strval(fetch));
		
		cache_get_field_content(0, "Dead", fetch);
		SetPVarInt(playerid, "Dead", strval(fetch));
		cache_get_field_content(0, "PaidRent", fetch);
		SetPVarInt(playerid, "PaidRent", strval(fetch));
		
		cache_get_field_content(0, "Describe1", fetch);
		format(PlayerInfo[playerid][pDescribe], 128, fetch);
		cache_get_field_content(0, "Describe2", fetch);
		format(PlayerInfo[playerid][pDescribe2], 128, fetch);
	
		cache_get_field_content(0, "email", fetch);
		SetPVarInt(playerid, "email", strval(fetch));
		format(emailv, sizeof(emailv), fetch);	
		
		cache_get_field_content(0, "LicTime", fetch);
		SetPVarInt(playerid, "LicTime", strval(fetch));
		cache_get_field_content(0, "LicGuns", fetch);
		SetPVarInt(playerid, "LicGuns", strval(fetch));
		
		cache_get_field_content(0, "MonthDon", fetch);
		SetPVarInt(playerid, "MonthDon", strval(fetch));
		cache_get_field_content(0, "MonthDonT", fetch);
		SetPVarInt(playerid, "MonthDonT", strval(fetch));
		cache_get_field_content(0, "DrugTime", fetch);
		SetPVarInt(playerid, "DrugTime", strval(fetch));
		cache_get_field_content(0, "Addiction", fetch);
		SetPVarInt(playerid, "Addiction", strval(fetch));
		cache_get_field_content(0, "AddictionID", fetch);
		SetPVarInt(playerid, "AddictionID", strval(fetch));
		
		cache_get_field_content(0, "AutoReload", fetch);
		SetPVarInt(playerid, "AutoReload", strval(fetch));
		cache_get_field_content(0, "AudioT", fetch);
		SetPVarInt(playerid, "AudioT", strval(fetch));
		cache_get_field_content(0, "Frights", fetch);
		SetPVarInt(playerid, "Frights", strval(fetch));

		cache_get_field_content(0, "HudCol", fetch);
		SetPVarInt(playerid, "HudCol", strval(fetch));
		cache_get_field_content(0, "SecHol", fetch);
		SetPVarInt(playerid, "SecHol", strval(fetch));
		cache_get_field_content(0, "Bonus", fetch);
		SetPVarInt(playerid, "Bonus", strval(fetch));
		cache_get_field_content(0, "SpawnLocation", fetch);
		SetPVarInt(playerid, "SpawnLocation", strval(fetch));
		
		cache_get_field_content(0, "ForumName", fetch);
		format(oocname[playerid], MAX_PLAYER_NAME, "%s", fetch);

		cache_get_field_content(0, "HouseEnter", fetch);
		SetPVarInt(playerid, "HouseEnter", strval(fetch));
		cache_get_field_content(0, "BizzEnter", fetch);
		SetPVarInt(playerid, "BizzEnter", strval(fetch));
		
		cache_get_field_content(0, "PaintUse", fetch);
		SetPVarInt(playerid, "PaintUse", strval(fetch));
		
		cache_get_field_content(0, "MarriedTo", fetch);
		strmid(PlayerInfo[playerid][pMarriedTo], fetch, 0, strlen(fetch), 255);
		if(strlen(PlayerInfo[playerid][pMarriedTo]) == 0) format(PlayerInfo[playerid][pMarriedTo], MAX_PLAYER_NAME + 1, "None");

		cache_get_field_content(0, "Accent", fetch);
		format(PlayerInfo[playerid][pAccent], 64, "%s", fetch);
		if(strlen(PlayerInfo[playerid][pAccent]) == 0) format(PlayerInfo[playerid][pAccent], 64, "None");
		
		cache_get_field_content(0, "OfflineReg", fetch);
		if(strval(fetch) == 1) {
			PlayerInfo[playerid][pOffReg] = 1;
		}
		
		SetPVarInt(playerid, "Backpack", cache_get_field_content_int(0, "Backpack"));
		
		PlayerInfo[playerid][pCraft] = cache_get_field_content_int(0, "Craft");
		PlayerInfo[playerid][pCraftExp] = cache_get_field_content_int(0, "CraftExp");
		PlayerInfo[playerid][pMaterials] = cache_get_field_content_int(0, "Materials");
		SetPVarInt(playerid, "WalkStyle", cache_get_field_content_int(0, "WalkStyle"));
		
		//Inventory loading.
		for(new i = 0; i < MAX_INV_SLOTS; i++)
		{
			new invnum[24];
			format(invnum, sizeof(invnum), "InvID%d", i);
			new itemID = cache_get_field_content_int(0, invnum);
		    if(itemID != 0) { 
				new invnum2[24], invnum3[24], invnum4[24];
				format(invnum2, sizeof(invnum2), "InvQ%d", i);
				format(invnum3, sizeof(invnum3), "InvE%d", i);
				format(invnum4, sizeof(invnum4), "InvS%d", i);
				GiveInvItem(playerid, itemID, cache_get_field_content_int(0, invnum2), cache_get_field_content_int(0, invnum3), cache_get_field_content_int(0, invnum4)); 
			}
		}
		for(new i = 1; i < 11; i++)
		{
			//Contact system
			new contactname[40], contactnumber[40];
			format(contactname, sizeof(contactname), "ContactName%d", i);
			format(contactnumber, sizeof(contactnumber), "ContactNumber%d", i);
			cache_get_field_content(0, contactname, fetch);
			SetPVarString(playerid, contactname, fetch);
			cache_get_field_content(0, contactnumber, fetch);
			SetPVarInt(playerid, contactnumber, strval(fetch));

			//Inventory system
			new tr[20], ta[20];
			format(tr, sizeof(tr), "TicketR%d", i);
			format(ta, sizeof(ta), "TicketA%d", i);
			cache_get_field_content(0, tr, fetch);
			SetPVarString(playerid, tr, fetch);
			cache_get_field_content(0, ta, fetch);
			SetPVarInt(playerid, ta, strval(fetch));
		}
		for(new i = 0;i < 20; i++)
		{
	    	TicketInfo[playerid][i][tAmount] = 0;
		}
		format(query, sizeof(query), "SELECT * FROM `tickets` WHERE player='%s' AND paid=0", PlayerName(playerid));
		mysql_function_query(handlesql, query, true, "LoadTickets", "d", playerid);
		new emaila[128];
		GetPVarString(playerid, "email", emaila, 128);
		
		for(new i=0; i < MAX_PDATA_FIELDS+1; i++)
		{
			if(PDataFields[i][pUsed] == 0) break; // We've reached the end of PData, they've all been loaded. Kill the loop.
			switch(PDataFields[i][pType])
			{
				case 0: //Integer
				{
					cache_get_field_content(0,PDataFields[i][pField],fetch);
					SetPVarInt(playerid,PDataFields[i][pField],strval(fetch));
				}
				case 1: //Float
				{
					cache_get_field_content(0,PDataFields[i][pField],fetch);
					SetPVarFloat(playerid,PDataFields[i][pField],floatstr(fetch));
				}
				case 2: //String
				{
					cache_get_field_content(0,PDataFields[i][pField],fetch);
					SetPVarString(playerid,PDataFields[i][pField],fetch);
				}
			}
		}
	}
	//==========//
	if(GetPVarInt(playerid, "Tut") == 1 || GetPVarInt(playerid, "Sex") == 0 || GetPVarInt(playerid, "Age") == 0)
	{
		EnableUCP(playerid, 1); //UCPRelated, enable the UCP but disable closing it.
	}
	SetPVarInt(playerid,"PlayerLogged", 2);
	if(GetPVarInt(playerid, "9mmSkill") == 0) {
		SetPDataInt(playerid, "9mmSkill", 200);
	}
	if(GetPVarInt(playerid, "uziSkill") == 0) {
		SetPDataInt(playerid, "uziSkill", 200);
	}
	if(GetPVarInt(playerid, "sawnoffSkill") == 0) {
		SetPDataInt(playerid, "sawnoffSkill", 200);
	}
	CallRemoteFunction("OnLoginInit","ii",playerid, 1);
	return 1;
}

//============================================//
stock SaveCrafting(playerid)
{
    if(GetPVarInt(playerid, "PlayerLogged") != 1) return true;
	new savename[24], query[124];
	GetPlayerName(playerid, savename, 24);
	mysql_format(handlesql, query, sizeof(query), "UPDATE accounts SET Craft=%i,CraftExp=%d,Materials=%d WHERE Name='%s'",PlayerInfo[playerid][pCraft],PlayerInfo[playerid][pCraftExp],PlayerInfo[playerid][pMaterials],savename);
	mysql_tquery(handlesql, query);
	return 1;
}
//============================================//
public OnPlayerDataSave(playerid)
{
	if(IsPlayerNPC(playerid)) return true;
    if(GetPVarInt(playerid, "PlayerLogged") != 1) return true;
    if(GetPVarInt(playerid, "PlayTime") < 10) return true;
	if(GetPVarInt(playerid, "AppWait") == 1) return true;
	new savename[24];
	GetPlayerName(playerid, savename, 24);
	new query[2048], Float:health,
	Float:armour,
	Float:x,
	Float:y,
	Float:z,
	world = GetPlayerVirtualWorld(playerid),
	interior = GetPlayerInterior(playerid);
	//==========//
	GetPlayerPos(playerid,x,y,z); GetPlayerHealth(playerid,health); GetPlayerArmour(playerid,armour);
	if(GetPlayerState(playerid) != PLAYER_STATE_SPECTATING)
	{
		if(PlayerInfo[playerid][pInVehicle] == -1 && PlayerInfo[playerid][pPeeping] != 1) {
			SetPVarFloat(playerid, "PosX", x); SetPVarFloat(playerid, "PosY", y); SetPVarFloat(playerid, "PosZ", z);
			SetPVarInt(playerid, "Interior", interior); SetPVarInt(playerid, "World", world);
		}
		SetPVarFloat(playerid, "Health", health); 
		PlayerInfo[playerid][pArmour] = armour;
	}

	//==========//
	mysql_format(handlesql, query, sizeof(query), "UPDATE accounts SET Cash=%i, Bank=%i, Model=%i, Interior=%i, World=%i, Tut=%i, Age=%i, Sex=%i, PosX=%f, PosY=%f, PosZ=%f, Health=%f, Armour=%f, MarriedTo='%s' WHERE Name='%s'",
	GetPVarInt(playerid, "Cash"), GetPVarInt(playerid, "Bank"), GetPVarInt(playerid, "Model"),
	GetPVarInt(playerid, "Interior"), GetPVarInt(playerid, "World"),
	GetPVarInt(playerid, "Tut"), GetPVarInt(playerid, "Age"), GetPVarInt(playerid, "Sex"),
	GetPVarFloat(playerid, "PosX"), GetPVarFloat(playerid, "PosY"), GetPVarFloat(playerid, "PosZ"),
	GetPVarFloat(playerid, "Health"), PlayerInfo[playerid][pArmour], PlayerInfo[playerid][pMarriedTo],
	savename);
	mysql_tquery(handlesql, query);

	mysql_format(handlesql, query, sizeof(query), "UPDATE accounts SET Admin=%i, Helper=%i, Reg=%i, Jailed=%i, Jailtime=%i, helpme=%d, ConnectTime=%i, ChatStyle=%i, HudCol=%d,SecHol=%d,Bonus=%d WHERE Name='%s'",
	GetPVarInt(playerid, "Admin"), GetPVarInt(playerid, "Helper"), GetPVarInt(playerid, "Reg"),
	GetPVarInt(playerid, "Jailed"), GetPVarInt(playerid, "Jailtime"), GetPVarInt(playerid, "helpmes"), GetPVarInt(playerid, "ConnectTime"), GetPVarInt(playerid, "ChatStyle"),
	GetPVarInt(playerid, "HudCol"),GetPVarInt(playerid, "SecHol"),GetPVarInt(playerid, "Bonus"),
	savename);
	mysql_tquery(handlesql, query);

	mysql_format(handlesql, query, sizeof(query), "UPDATE accounts SET DriveLic=%d, GunLic=%d, MaskID=%d, PlayerWeapon=%d, PlayerAmmo=%d, PlayerSerial=%d, AmmoType=%d, WepSerial=%d WHERE Name='%s'",
	GetPVarInt(playerid, "DriveLic"), GetPVarInt(playerid, "GunLic"), GetPVarInt(playerid, "MaskID"),
	PlayerInfo[playerid][pPlayerWeapon], PlayerInfo[playerid][pPlayerAmmo], PlayerInfo[playerid][pSerial], PlayerInfo[playerid][pAmmoType], PlayerInfo[playerid][pWepSerial],
	savename);
	mysql_tquery(handlesql, query);

	mysql_format(handlesql, query, sizeof(query), "UPDATE accounts SET Member=%d, Rank=%d, JobReduce=%d, DonateRank=%d, Fightstyle=%d, HouseKey=%d, BizzKey=%d, JobID=%d WHERE Name='%s'",
	GetPVarInt(playerid, "Member"),GetPVarInt(playerid, "Rank"),GetPVarInt(playerid, "JobReduce"),GetPVarInt(playerid, "DonateRank"),GetPVarInt(playerid, "Fightstyle"),
	GetPVarInt(playerid, "HouseKey"),GetPVarInt(playerid, "BizzKey"), GetPVarInt(playerid, "Job"), savename);
	mysql_tquery(handlesql, query);

	mysql_format(handlesql, query, sizeof(query), "UPDATE accounts SET WalkieFreq=%d,PhoneNum=%d,PayDay=%d,PayCheck=%d,CheckEarn=%d, Dead=%d, PaidRent=%d, Changes=%d, CarTicket=%d WHERE Name='%s'",
	GetPVarInt(playerid, "WalkieFreq"),GetPVarInt(playerid, "PhoneNum"),GetPVarInt(playerid, "PayDay"),GetPVarInt(playerid, "PayCheck"),
	GetPVarInt(playerid, "CheckEarn"), GetPVarInt(playerid, "Dead"), GetPVarInt(playerid, "PaidRent"), GetPVarInt(playerid, "Changes"), GetPVarInt(playerid, "CarTicket"),
	savename);
	mysql_tquery(handlesql, query);

	//new desc[128], desc2[128];
	//mysql_escape_string(PlayerInfo[playerid][pDescribe], desc);
	//mysql_escape_string(PlayerInfo[playerid][pDescribe2], desc2);
		
	mysql_format(handlesql, query, sizeof(query), "UPDATE accounts SET MonthDon=%d, MonthDonT=%d, AudioT=%d, Frights=%d,SpawnLocation=%d WHERE Name='%s'",
	GetPVarInt(playerid, "MonthDon"), GetPVarInt(playerid, "MonthDonT"),GetPVarInt(playerid, "AudioT"), GetPVarInt(playerid, "Frights"), GetPVarInt(playerid, "SpawnLocation"),savename);
	mysql_tquery(handlesql, query);

	mysql_format(handlesql, query, sizeof(query), "UPDATE accounts SET LicTime=%d, LicGuns=%d, Addiction=%d, DrugTime=%d, AutoReload=%d, AddictionID=%d, HouseEnter=%d, BizzEnter=%d, PaintUse=%d WHERE Name='%s'",
	GetPVarInt(playerid, "LicTime"), GetPVarInt(playerid, "LicGuns"),
    GetPVarInt(playerid, "Addiction"), GetPVarInt(playerid, "Drugtime"), GetPVarInt(playerid, "AutoReload"),GetPVarInt(playerid, "AddictionID"),
    GetPVarInt(playerid, "HouseEnter"), GetPVarInt(playerid, "BizzEnter"), GetPVarInt(playerid, "PaintUse"),
	savename);
	mysql_tquery(handlesql, query);
		
	new safename[25];
	mysql_real_escape_string(oocname[playerid], safename);
	mysql_format(handlesql, query, sizeof(query), "UPDATE accounts SET ForumName='%s',Backpack=%i,Accent='%s',WalkStyle=%i WHERE Name='%s'",safename,GetPVarInt(playerid,"Backpack"),PlayerInfo[playerid][pAccent],GetPVarInt(playerid, "WalkStyle"),savename);
	mysql_tquery(handlesql, query);
	
	SaveCrafting(playerid);
		
	//Inventory saving
	for(new i = 0; i < MAX_INV_SLOTS; i++)
	{
		mysql_format(handlesql, query, sizeof(query), "UPDATE accounts SET InvID%d=%d, InvQ%d=%d, InvE%d=%d, InvS%d=%d WHERE Name='%s'",
		i,PlayerInfo[playerid][pInvItem][i],
		i,PlayerInfo[playerid][pInvQ][i],
		i,PlayerInfo[playerid][pInvEx][i],
		i,PlayerInfo[playerid][pInvS][i],
		savename);
	 	mysql_tquery(handlesql, query);
	}
		
	for(new i = 1; i < 11; i++)
	{
		//Contact system
		new contactname[40], contactnumber[40], strings[50], strings2[50];
		format(contactname, sizeof(contactname), "ContactName%d", i);
		format(contactnumber, sizeof(contactnumber), "ContactNumber%d", i);
		GetPVarString(playerid, contactname, strings, 50);
		//Inventory system
		new tr[20], ta[20];
		format(tr, sizeof(tr), "TicketR%d", i);
		format(ta, sizeof(ta), "TicketA%d", i);
		GetPVarString(playerid, tr, strings2, 50);
		mysql_escape_string(strings2, strings2);
		mysql_escape_string(strings, strings);
		mysql_format(handlesql, query, sizeof(query), "UPDATE accounts SET ContactName%d='%s', ContactNumber%d=%d, TicketR%d='%s', TicketA%d=%d WHERE Name='%s'",
		i, strings, i, GetPVarInt(playerid, contactnumber), i, strings2, i, GetPVarInt(playerid, ta), savename);
		mysql_tquery(handlesql, query);
	}
	return 1;
}
//============================================//
forward StartingUCP(playerid);
public StartingUCP(playerid)
{
	SendClientMessage(playerid, COLOR_YELLOW, "Don't forget to use /ucp to view your User Control Panel!");
	EnableUCP(playerid, 1);
	SendClientMessage(playerid, COLOR_ORANGE, "You're in the starters UCP which means you can change your model for free! (Player Options -> Change player model)");
	SendClientMessage(playerid, COLOR_ORANGE, "Once you close this your skin can only be changed at a clothing store.");
	SendClientMessage(playerid, COLOR_ORANGE, "You can change your in-game age, gender, and more by going to: /ucp -> Player Options.");
	return 1;
}
//============================================//
forward OnPlayerRegister(name[]);
public OnPlayerRegister(name[])
{
	if(cache_get_row_count() < 1) return print("[ERROR] OnPlayerRegister returned 'rows' as '0'.");
	new password[65];
	cache_get_field_content(0, "Pass", password);
	new playerid = FindPlayer(name);
	if(playerid != -1) {
		SendClientMessage(playerid,COLOR_GREEN,"Your account has been approved!");
		DeletePVar(playerid,"AppWait");
		DeletePVar(playerid,"AppSetup");
		strmid(PlayerInfo[playerid][pOOC], "None", 0, strlen("None"), 255);
		strmid(PlayerInfo[playerid][pMetagame], "None", 0, strlen("None"), 255);
		strmid(PlayerInfo[playerid][pRevenge], "None", 0, strlen("None"), 255);
		strmid(PlayerInfo[playerid][pRoleplay], "None", 0, strlen("None"), 255);
		strmid(PlayerInfo[playerid][pPowergame], "None", 0, strlen("None"), 255);
		strmid(PlayerInfo[playerid][pQuest1], "None", 0, strlen("None"), 255);
		strmid(PlayerInfo[playerid][pQuest2], "None", 0, strlen("None"), 255);
		strmid(PlayerInfo[playerid][pQuest3], "None", 0, strlen("None"), 255);
		strmid(PlayerInfo[playerid][pQuest4], "None", 0, strlen("None"), 255);
		strmid(PlayerInfo[playerid][pQuest5], "None", 0, strlen("None"), 255);
		new query[264];
		mysql_format(handlesql, query, sizeof(query), "INSERT INTO accounts (`Name`,`Pass`) VALUES ('%s','%s')", name, password);
		mysql_tquery(handlesql, query);
		format(PlayerInfo[playerid][pPass],65,"%s",password);
		mysql_format(handlesql, query, sizeof(query), "DELETE FROM applications WHERE Name = '%s'", name);
		mysql_tquery(handlesql, query);
		//==========//
		SetPVarInt(playerid, "Cash", 500);
		SetPVarInt(playerid, "Bank", 0);
		SetPVarInt(playerid, "Model", 26);
		SetPVarInt(playerid, "Interior", 0);
		SetPVarInt(playerid, "World", 0);
		SetPVarInt(playerid, "Tut", 0);
		SetPVarInt(playerid, "Age", 14);
		SetPVarInt(playerid, "Sex", 1);
		SetPVarFloat(playerid, "PosX", 1642.7285);
		SetPVarFloat(playerid, "PosY", -2240.5591);
		SetPVarFloat(playerid, "PosZ", 13.4945);
		SetPVarFloat(playerid, "Health", 99.0);
		PlayerInfo[playerid][pArmour] = 0;
		new randmask = 1000 + random(9999999);
		SetPVarInt(playerid, "MaskID", randmask);
		new randphone = 1000 + random(9999999);
		SetPVarInt(playerid, "PhoneNum", randphone);
		PlayerInfo[playerid][pWepSerial] = (1000 + random(9999999));
		PlayerInfo[playerid][pLastPrim] = -1;
		PlayerInfo[playerid][pLastSec] = -1;
		PlayerInfo[playerid][pLastMelee] = -1;
		//==========//
		SetPVarInt(playerid, "AccountExist", 1);
		CallRemoteFunction("OnPlayerLogin", "ii", playerid, 1);
		OnPlayerDataSave(playerid);
		SetPVarInt(playerid, "UCPMode", 1);
		ShowPlayerDialog(playerid,516,DIALOG_STYLE_INPUT,"[UCP] Choose a new email","Enter your new email below","Continue", "Cancel");
	} else {
		new randmask = 1000 + random(9999999);
		new randphone = 1000 + random(9999999);
		new randserial = 1000 + random(9999999);
		new query[648];
		mysql_format(handlesql, query, sizeof(query), "INSERT INTO accounts (`Name`,`Pass`,`Cash`,`Bank`,`Model`,`Interior`,`World`,`Tut`,`Age`,`Sex`,`PosX`,`PosY`,`PosZ`,`Health`,`Armour`,`MaskID`,`PhoneNum`,`WepSerial`,`OfflineReg`,`LastPrim`,`LastSec`,`LastMelee`) VALUES ('%s','%s',%i,%i,%i,%i,%i,%i,%i,%i,%f,%f,%f,%f,%f,%d,%d,%d,%i,%d,%d,%d)",name,password,500,0,26,0,0,0,14,1,1642.7285,-2240.5591,13.4945,99.0,0.0,randmask,randphone,randserial,1,-1,-1,-1);
		mysql_tquery(handlesql, query);
		mysql_format(handlesql, query, sizeof(query), "DELETE FROM applications WHERE Name = '%s'", name);
		mysql_tquery(handlesql, query);
	}
	return 1;
}
//============================================//
public OnLoginInit(playerid, type)
{
	if(PlayerInfo[playerid][pOffReg] == 1) {
		SetPVarInt(playerid, "UCPMode", 1);
		ShowPlayerDialog(playerid,516,DIALOG_STYLE_INPUT,"[UCP] Choose a new email","Enter your new email below","Continue", "Cancel");
		new query[128];
		mysql_format(handlesql, query, sizeof(query), "UPDATE accounts SET `OfflineReg`=0 WHERE Name='%s'", PlayerName(playerid));
		mysql_tquery(handlesql, query);
	}
	else SendClientMessage(playerid, COLOR_YELLOW, "Don't forget to use /ucp to view your 'User Control Panel'.");
	
	new string[128], query[128];
	switch(type)
	{
	    case 1:
	    {
			if(GetPVarInt(playerid,"SpawnLocation") == 1)
			{
			    new count = 0;
			    if(GetPVarInt(playerid,"HouseKey") != 0) count++;
	            if(GetPVarInt(playerid,"BizzKey") != 0) count++;
	            if(GetPVarInt(playerid,"Member") == 1 || GetPVarInt(playerid,"Member") == 2 || GetPVarInt(playerid,"Member") == 8) count++;
	            if(count > 0)
	            {
			        CallRemoteFunction("SelectSpawnpoint","i", playerid);
			        TextDrawShowForPlayer(playerid, SpawnDraw[4]);
			        TextDrawShowForPlayer(playerid, SpawnDraw[5]);
			        return true;
			    }
			}
	    	TextDrawHideForPlayer(playerid, SideBar1);
	        TextDrawHideForPlayer(playerid, SideBar2);
	        ClearChatbox(playerid,50);
	        TogglePlayerSpectating(playerid, 0);
	        SetCameraBehindPlayer(playerid);
	        SpawnPlayer(playerid);
	        SetSpawnInfo(playerid, 0, GetPVarInt(playerid,"Model"), GetPVarFloat(playerid, "PosX"),GetPVarFloat(playerid, "PosY"),GetPVarFloat(playerid, "PosZ"), 0.0, 0, 0, 0, 0, 0, 0);
	        SetPlayerSkinEx(playerid, GetPVarInt(playerid,"Model"));
            SetPlayerPosEx(playerid, GetPVarFloat(playerid, "PosX"), GetPVarFloat(playerid, "PosY"), GetPVarFloat(playerid, "PosZ"));
            SetPlayerInterior(playerid,GetPVarInt(playerid, "Interior"));
	        SetPlayerVirtualWorld(playerid,GetPVarInt(playerid, "World"));
	        TogglePlayerControllable(playerid, false);
            SetTimerEx("OnLoginInit", 1000, false, "ii", playerid, 2);
            SetPlayerScore(playerid, GetPVarInt(playerid, "ConnectTime"));
            SetCameraBehindPlayer(playerid);
			
            mysql_format(handlesql, string, sizeof(string), "SELECT * FROM `adjust` WHERE `name`='%s'", PlayerInfo[playerid][pUsername]);
			mysql_tquery(handlesql, string, "LoadHolsterSQL", "d", playerid);
			
            for(new i = 0; i < 301; i++)
			{
			    PlayerInfo[playerid][pBlockPM][i] = 0;
			}
            for(new i = 0; i < 6; i++)
			{
			    TextDrawHideForPlayer(playerid, WoundDraw[i]);
			}
            for(new o = 1; o < 9; o++)
            {
                if(IsPlayerAttachedObjectSlotUsed(playerid, o))
				{
				    RemovePlayerAttachedObject(playerid, o);
				}
            }
            for(new o = 0; o < 4; o++)
	        {
	            TextDrawHideForPlayer(playerid, PGBar[o][playerid]);
            }         
	    }
	    case 2:
	    {
    	    SetPVarInt(playerid, "PlayerLogged", 1);
    	    SetCameraBehindPlayer(playerid);
    	    TogglePlayerControllable(playerid, true);
    	    StopAudioStreamForPlayerEx(playerid);
    	    SetPlayerColor(playerid, COLOR_WHITE);
    	    if(GetPVarFloat(playerid, "Health") > 0.0) SetPlayerHealth(playerid,GetPVarFloat(playerid, "Health"));
    	    if(PlayerInfo[playerid][pArmour] > 0.0) SetPlayerArmourEx(playerid,PlayerInfo[playerid][pArmour]);
    	    //==============================//}
    	    PreloadAnimLib(playerid,"CRACK"); PreloadAnimLib(playerid,"CARRY");
		    PreloadAnimLib(playerid,"SWEET"); PreloadAnimLib(playerid,"PED");
		    PreloadAnimLib(playerid,"RAPPING"); PreloadAnimLib(playerid,"COP_AMBIENT");
		    PreloadAnimLib(playerid,"DEALER"); PreloadAnimLib(playerid,"BEACH");
		    PreloadAnimLib(playerid,"ON_LOOKERS"); PreloadAnimLib(playerid,"SUNBATHE");
		    PreloadAnimLib(playerid,"RIOT"); PreloadAnimLib(playerid,"SHOP");
		    PreloadAnimLib(playerid,"PARACHUTE"); PreloadAnimLib(playerid,"GHANDS");
		    PreloadAnimLib(playerid,"MEDIC"); PreloadAnimLib(playerid,"MISC");
		    PreloadAnimLib(playerid,"SWAT"); PreloadAnimLib(playerid,"GANGS");
		    PreloadAnimLib(playerid,"BOMBER"); PreloadAnimLib(playerid,"FOOD");
		    PreloadAnimLib(playerid,"PARK"); PreloadAnimLib(playerid,"GRAVEYARD");
		    PreloadAnimLib(playerid,"KISSING"); PreloadAnimLib(playerid,"KNIFE");
		    PreloadAnimLib(playerid,"FINALE"); PreloadAnimLib(playerid,"SMOKING");
		    PreloadAnimLib(playerid,"BLOWJOBZ"); PreloadAnimLib(playerid,"SNM");
		    PreloadAnimLib(playerid,"LOWRIDER"); PreloadAnimLib(playerid,"DANCING");
		    PreloadAnimLib(playerid,"ROB_BANK"); PreloadAnimLib(playerid,"POLICE");
		    PreloadAnimLib(playerid,"SILENCED");
		    //==============================//
			SetPlayerSkillLevel(playerid,WEAPONSKILL_PISTOL,GetPVarInt(playerid, "9mmSkill"));
			SetPlayerSkillLevel(playerid,WEAPONSKILL_SAWNOFF_SHOTGUN,GetPVarInt(playerid, "sawnoffSkill"));
			SetPlayerSkillLevel(playerid,WEAPONSKILL_MICRO_UZI,GetPVarInt(playerid, "uziSkill"));
		    //==============================//
		    CallRemoteFunction("OnPlayerDataSave", "i", playerid);
	        //==============================//}
		    TextDrawShowForPlayer(playerid,MoneyDraw2);
		    TextDrawShowForPlayer(playerid,ServerDraw);
		    //==============================//
		    MoneyDraw[playerid] = TextDrawCreate(497.000000,77.000000,"~g~$00000000");
		    TextDrawAlignment(MoneyDraw[playerid],0);
		    TextDrawBackgroundColor(MoneyDraw[playerid],0x000000ff);
		    TextDrawFont(MoneyDraw[playerid],3);
		    TextDrawLetterSize(MoneyDraw[playerid],0.599999,2.200000);
		    TextDrawColor(MoneyDraw[playerid],0xffffffff);
		    TextDrawSetOutline(MoneyDraw[playerid],1);
		    TextDrawSetProportional(MoneyDraw[playerid],1);
		    TextDrawSetShadow(MoneyDraw[playerid],1);
		    TextDrawShowForPlayer(playerid,MoneyDraw[playerid]);
		    LocationDraw[playerid] = TextDrawCreate(38.000000, 329.000000, " ");
		    TextDrawBackgroundColor(LocationDraw[playerid], 255);
		    TextDrawFont(LocationDraw[playerid], 2);
		    TextDrawLetterSize(LocationDraw[playerid], 0.280000, 1.000000);
		    TextDrawColor(LocationDraw[playerid], -1);
		    TextDrawSetOutline(LocationDraw[playerid], 0);
		    TextDrawSetProportional(LocationDraw[playerid], 1);
		    TextDrawSetShadow(LocationDraw[playerid], 1);
		    format(string, sizeof(string),"~w~%s", GetPlayerArea(playerid));
		    TextDrawSetString(Text:LocationDraw[playerid], string);
		    TextDrawShowForPlayer(playerid, LocationDraw[playerid]);
		    //==============================//
		    CallRemoteFunction("PrintHud","i",playerid);
		    //==============================//
		    format(query, sizeof(query), "UPDATE `accounts` SET `Online` = 1 WHERE `Name`='%s'", PlayerName(playerid));
            mysql_tquery(handlesql, query);
		    //==============================//
		    LoadChecks(playerid);
		    //==============================//
			format(string, sizeof(string), "SELECT * FROM `toys` WHERE `PlayerName`='%s'", PlayerName(playerid));
			mysql_function_query(handlesql, string, true, "LoadToys", "d", playerid);
		    if(PlayerInfo[playerid][pPlayerWeapon] > 0 && PlayerInfo[playerid][pPlayerAmmo] > 0)
		    {
		        GivePlayerWeaponEx(playerid, PlayerInfo[playerid][pPlayerWeapon], PlayerInfo[playerid][pPlayerAmmo]);
		    }
		    //==============================//
		    new mem = GetPVarInt(playerid, "Member");
		    if(FactionInfo[mem][fUsed] == 1)
		    {
		        format(string, sizeof(string),"FACTION-MOTD: %s", FactionInfo[mem][fMOTD]);
				SCM(playerid, 0xE65A5AAA, string);
		    }
		    else { SetPVarInt(playerid, "Member", 0), SetPVarInt(playerid, "Rank", 0); }
		    //==============================//
		    SCM(playerid, COLOR_LIGHTRED, "To follow up on updates visit our website @ www.diverseroleplay.org");
		    SCM(playerid, COLOR_LIGHTRED, "IMPORTANT: Please make sure your account is always linked to a valid email address. (/ucp -> Player Options)");
			SCM(playerid, COLOR_LIGHTRED, "*Email addresses are kept private, and are only used for password-recovery purposes.*");
		    //==============================//
		    if(strcmp(PlayerInfo[playerid][pDescribe], " ", true) == 0) strmid(PlayerInfo[playerid][pDescribe], "None", 0, strlen("None"), 255);
		    if(strcmp(PlayerInfo[playerid][pDescribe2], " ", true) == 0) strmid(PlayerInfo[playerid][pDescribe2], "None", 0, strlen("None"), 255);
		    //==============================//
		    switch(GetPVarInt(playerid, "FightStyle"))
            {
                case 0: SetPlayerFightingStyle(playerid,FIGHT_STYLE_NORMAL);
                case 1: SetPlayerFightingStyle(playerid,FIGHT_STYLE_BOXING);
                case 2: SetPlayerFightingStyle(playerid,FIGHT_STYLE_KUNGFU);
                case 3: SetPlayerFightingStyle(playerid,FIGHT_STYLE_KNEEHEAD);
                case 4: SetPlayerFightingStyle(playerid,FIGHT_STYLE_GRABKICK);
                case 5: SetPlayerFightingStyle(playerid,FIGHT_STYLE_ELBOW);
            }
		    //==============================//
		    if(GetPVarInt(playerid, "Dead") == 1 || GetPVarInt(playerid, "Dead") == 2)
		    {
			    TogglePlayerControllable(playerid,false);
			    SetPVarInt(playerid, "Dead", 2);
			    SetPlayerPosEx(playerid,GetPVarFloat(playerid, "PosX"),GetPVarFloat(playerid, "PosY"),GetPVarFloat(playerid, "PosZ"));
				SetPlayerFacingAngle(playerid,GetPVarFloat(playerid, "Angle"));
				SetPlayerInterior(playerid,GetPVarInt(playerid, "Interior"));
				SetPlayerVirtualWorld(playerid,GetPVarInt(playerid, "World"));
				SetCameraBehindPlayer(playerid);
	            SendClientMessage(playerid,COLOR_WHITE,"Type (/accept death) to continue.");
	            SetPlayerHealth(playerid,1.0);
	            new rand = random(5)+1;
				switch(rand)
				{
				    case 1: ApplyAnimation(playerid, "ped", "FLOOR_hit", 4.0, 0, 1, 1, 1, -1);
			        case 2: ApplyAnimation(playerid, "ped", "FLOOR_hit_f", 4.0, 0, 1, 1, 1, -1);
			        case 3: ApplyAnimation(playerid, "ped", "KO_shot_front", 4.0, 0, 1, 1, 1, -1);
			        case 4: ApplyAnimation(playerid, "ped", "KO_shot_stom", 4.0, 0, 1, 1, 1, -1);
	                case 5: ApplyAnimation(playerid, "ped", "BIKE_fall_off", 4.0, 0, 1, 1, 1, -1);
				    default: ApplyAnimation(playerid, "FINALE", "FIN_Land_Die", 4.0, 0, 1, 1, 1, -1);
				}
				if(GetPVarInt(playerid, "Admin") != 10) SetPVarInt(playerid, "DeathTime", GetCount()+60000);
	            return 1;
			}
			if(GetPVarInt(playerid, "Dead") == 3)
			{
			    DeathPlayer(playerid, "You need to rest to regain consciousness.");
			    return true;
			}
			//==============================//
			if(GetPVarInt(playerid, "Backpack") == 1) SetPlayerAttachedObject(playerid, 6, 371, 1, 0.0, -0.14, 0.0, 0.0, 90, 359.5022, 1, 1, 1);
			//==============================//
			switch(GetPVarInt(playerid, "Jailed"))
			{
			    case 1:
			    {
			        SetPlayerPosEx(playerid, -1406.7714,1245.1904,1029.8984);
			        SetPlayerFacingAngle(playerid, 177.0008);
			        SetPlayerInterior(playerid, 16);
			        SetPlayerVirtualWorld(playerid, playerid + 1);
			        format(string, sizeof(string),"[JAILED] You are in admin-jail for %d seconds.", GetPVarInt(playerid, "Jailtime"));
			        SCM(playerid, 0xE65A5AAA, string);
			        SetPVarInt(playerid, "Mute", 1);
			    }
			    case 2:
			    {
			        new ran = random(3) + 1;
			        if(ran == 1) SetPlayerPosEx(playerid, 2592.0681,-1506.9999,-48.9141);
			        else if(ran == 2) SetPlayerPosEx(playerid, 2588.0879,-1526.0541,-48.9141);
			        else SetPlayerPosEx(playerid, 2583.7458,-1526.5377,-48.9141);
			        SetPlayerInterior(playerid, 1);
			        SetPlayerVirtualWorld(playerid, 1);
			        SCM(playerid, 0xE65A5AAA, "[JAILED] You are in jail.");
			    }
			}
			//==============================//
			if(IsPlayerInRangeOfPoint(playerid, 15.0, 2233.0278,2457.1990,-7.4531+10.0)) // UNBUG DEALERSHIP SYSTEM
			{
		    	SetPlayerPosEx(playerid, 1529.6,-1691.2,13.3);
			    SetPlayerInterior(playerid,0);
			    SetPlayerVirtualWorld(playerid,0);
		        SendClientMessage(playerid, 0xFF000000, "You have been sent to Los Santos!.");
			}
			//==============================//
			LoadRadios(playerid);
			CallRemoteFunction("LoadHolsters","i",playerid);
			/*if(GetPVarInt(playerid, "HouseKey") != 0)
			{
			    if(strcmp(HouseInfo[GetPVarInt(playerid, "HouseKey")][hOwner], PlayerName(playerid), true) == 0)
                {
			        LoadCars(playerid);
			    }
			}*/
			if(GetPVarInt(playerid, "MonthDon") != 0)
			{
			    if(GetPVarInt(playerid, "MonthDonT") <= 0)
			    {
			        SetPVarInt(playerid, "MonthDon", 0);
			        SetPVarInt(playerid, "MonthDonT", 0);
			        scm(playerid, -1, "Your monthly subscription has expired!");
			    }
			}
			if(GetPVarInt(playerid, "HouseEnter") != 0)
			{
			    HouseLights(GetPVarInt(playerid, "HouseEnter"));
			}
			if(GetPlayerVirtualWorld(playerid) == 0 && GetPlayerInterior(playerid) == 0 && GetPVarInt(playerid, "DrugTime") == 0) {
				SetPlayerTime(playerid, GMHour, GMMin);
				SetPlayerWeather(playerid, GMWeather);
			}
			//==============================//
		}
	}
	return 1;
}
//============================================//
