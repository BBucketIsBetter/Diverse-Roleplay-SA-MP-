#define MAX_PAYPHONES 50

new
	Iterator:phoneObjects<MAX_PAYPHONES>,
	tCreatePhoneObjID[MAX_PLAYERS];

enum enumPhoneInformation
{
	phoneID,
	Float:pPosX,
	Float:pPosY,
	Float:pPosZ,
	Float:pRotX,
	Float:pRotY,
	Float:pRotZ,
	phoneVW,
	phoneInt,
	phoneName[48],
	
	phoneObjID,
	Text3D:phoneNameTag,
	bool:phoneStatus
};

new phoneInfo[MAX_PAYPHONES][enumPhoneInformation];

// ---------- Commands -------------- //

CMD:payphone(playerid, params[])
{
    if(GetPVarInt(playerid, "Cuffed") > 0) return SendClientMessage(playerid, COLOR_GREY, "You can't do this while handcuffed/tazed.");
	if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_LIGHTRED, "You are currently muted!");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while dead!");
	if(GetPVarInt(playerid, "usingPayphone") >= 0) return SendClientMessage(playerid, COLOR_RED, "You're already using a payphone.");
	new i = getNearestPhone(playerid);
	if(i == -1) return SendClientMessage(playerid, COLOR_RED, "You aren't near a payphone.");
	if(phoneInfo[i][phoneStatus] == true) return SendClientMessage(playerid, COLOR_RED, "That payphone is currently in use.");
	SetPVarInt(playerid, "usingPayphone", i);
	TogglePlayerControllableEx(playerid, false);
	ShowPlayerDialog(playerid, 552, DIALOG_STYLE_LIST, phoneInfo[i][phoneName], "Call number\nServices", "Okay", "Exit");
	return 1;
}

CMD:createpayphone(playerid, params[])
{
	if(GetPVarInt(playerid, "Admin") < 10 && GetPVarInt(playerid, "Mapper") < 1) return error(playerid, "Must be a level 10 admin or mapper.");
	if(Iter_Count(phoneObjects) >= MAX_PAYPHONES) return SendClientMessage(playerid, -1, "You cannot make any more payphones, the phone-limit has been reached!");
	new Float:fPos[3];
	GetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]);
	tCreatePhoneObjID[playerid] = CreateDynamicObject(1216, fPos[0]+0.3, fPos[1], fPos[2], -1, -1, -1, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
	SetPVarInt(playerid, "PlantPayphone", 1);
	Streamer_Update(playerid);
	EditDynamicObject(playerid, tCreatePhoneObjID[playerid]);
	SendClientMessage(playerid, -1, "[Payphone System] Set where the payphone should be.");
	return 1;
}

CMD:deletepayphone(playerid, params[])
{
	if(GetPVarInt(playerid, "Admin") < 10 && GetPVarInt(playerid, "Mapper") < 1) return error(playerid, "Must be a level 10 admin or mapper.");
	new i = getNearestPhone(playerid), query[172];
	if(i == -1) return SendClientMessage(playerid, COLOR_RED, "You aren't near a payphone.");	
	format(query, sizeof(query), "DELETE FROM `payphones` WHERE `ID` = %d", phoneInfo[i][phoneID]);
	mysql_function_query(handlesql, query, false, "thread_DeletePhone", "dd", playerid, i);
	return 1;
}

CMD:phonename(playerid, params[])
{
	if(GetPVarInt(playerid, "Admin") < 10 && GetPVarInt(playerid, "Mapper") < 1) return error(playerid, "Must be a level 10 admin or mapper.");
	new i = getNearestPhone(playerid);
	if(i == -1) return SendClientMessage(playerid, COLOR_RED, "You aren't near a payphone.");
	new query[150];
	if(isnull(params))
	{
		new Float:X, Float:Y, Float:Z;
		GetDynamicObjectPos(phoneInfo[i][phoneObjID], X, Y, Z);
		format(phoneInfo[i][phoneName], 48, "Payphone (%s)", GetZoneArea(X, Y, Z));
		format(query, 150, "UPDATE `payphones` SET `Name`='%s' WHERE `ID` = %d", phoneInfo[i][phoneName], phoneInfo[i][phoneID]);
		mysql_tquery(handlesql, query);
		return SendClientMessage(playerid, -1, "Payphone name reset to default.");
	}
	if(strlen(params) < 1 || strlen(params) > 47) return SendClientMessage(playerid, -1, "Payphone names must be between 1 and 47 characters long!");
	format(phoneInfo[i][phoneName], 21, "%s", params);
	new name[21];
	mysql_real_escape_string(params, name);
	format(query, 150, "UPDATE `payphones` SET `Name`='%s' WHERE `ID` = %d", name, phoneInfo[i][phoneID]);
	mysql_tquery(handlesql, query);
	format(query, 150, "You've changed payphone %d's name to: %s.", phoneInfo[i][phoneID], params);
	SendClientMessage(playerid, COLOR_LIGHTBLUE, query);
	SendClientMessage(playerid, COLOR_ORANGE, "[TIP] Use /phonename with no arguments to reset the payphones name to its default value.");
	return 1;
}

CMD:payphonehelp(playerid, params[])
{
	scm(playerid, COLOR_GREEN, "Payphone commands:");
	scm(playerid, COLOR_GREY, "  /payphone");
	if(GetPVarInt(playerid, "Admin") > 9 || GetPVarInt(playerid, "Mapper") > 0) {
		scm(playerid, COLOR_ORANGE, "---Mapper Commands---");
		scm(playerid, COLOR_GREY, "  /createpayphone");
		scm(playerid, COLOR_GREY, "  /deletepayphone (Deletes nearest payphone.)");
		scm(playerid, COLOR_GREY, "  /phonename [name] (No arguments to reset name to default.)");
	}
	return 1;
}

// ----------- Threaded Queries ----------- //

forward thread_LoadPhones();
public thread_LoadPhones()
{
	new rows, fields;
	
	cache_get_data(rows, fields, handlesql);
	
	if(rows > 0)
	{
		new temp[30];
		for(new i = 0; i < rows; i++)
		{
			cache_get_row(i, 0, temp);		phoneInfo[i][phoneID] = strval(temp);
			cache_get_row(i, 1, temp);		phoneInfo[i][pPosX] = floatstr(temp);
			cache_get_row(i, 2, temp);		phoneInfo[i][pPosY] = floatstr(temp);
			cache_get_row(i, 3, temp);		phoneInfo[i][pPosZ] = floatstr(temp);
			cache_get_row(i, 4, temp);		phoneInfo[i][pRotX] = floatstr(temp);
			cache_get_row(i, 5, temp);		phoneInfo[i][pRotY] = floatstr(temp);
			cache_get_row(i, 6, temp);		phoneInfo[i][pRotZ] = floatstr(temp);
			cache_get_row(i, 7, temp);		phoneInfo[i][phoneVW] = strval(temp);
			cache_get_row(i, 8, temp);		phoneInfo[i][phoneInt] = strval(temp);
			cache_get_row(i, 9, temp);		format(phoneInfo[i][phoneName], 48, "%s", temp);
			
			phoneInfo[i][phoneObjID] = CreateDynamicObject(1216, phoneInfo[i][pPosX], phoneInfo[i][pPosY], phoneInfo[i][pPosZ], phoneInfo[i][pRotX], phoneInfo[i][pRotY], phoneInfo[i][pRotZ], phoneInfo[i][phoneVW], phoneInfo[i][phoneInt]);
			phoneInfo[i][phoneNameTag] = CreateDynamic3DTextLabel("   [Payphone]\ntype /payphone to use.", COLOR_ORANGE, phoneInfo[i][pPosX], phoneInfo[i][pPosY], phoneInfo[i][pPosZ] + 1.3, 25.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, phoneInfo[i][phoneVW], phoneInfo[i][phoneInt], -1, 30.0);
			Iter_Add(phoneObjects, i);
		}
	}
	return 1;
}

forward thread_DeletePhone(playerid, phoneid);
public thread_DeletePhone(playerid, phoneid)
{
	if(playerid != INVALID_PLAYER_ID) SendClientMessage(playerid, -1, "SERVER: The phone was deleted successfully.");

	if(IsValidDynamicObject(phoneInfo[phoneid][phoneObjID])) {
		DestroyDynamicObject(phoneInfo[phoneid][phoneObjID]);
	}
	DestroyDynamic3DTextLabel(phoneInfo[phoneid][phoneNameTag]);
	Iter_Remove(phoneObjects, phoneid);
	for(new x; enumPhoneInformation:x < enumPhoneInformation; x++) phoneInfo[phoneid][enumPhoneInformation:x] = 0;
	return 1;
}
		
forward thread_CreatePhone(playerid,i);
public thread_CreatePhone(playerid,i)
{
	phoneInfo[i][phoneID] = cache_insert_id(handlesql);
	if(playerid != INVALID_PLAYER_ID)
	{
		Streamer_Update(playerid);
		SendClientMessage(playerid, -1, "SERVER: The phone was created successfully.");
	}
	return 1;
}

// ------------- Stock Functions ----------------- //

stock removeAllPhones()
{
	for(new i = 0; i < sizeof(phoneInfo); i++)
	{
		DestroyDynamicObject(phoneInfo[i][phoneObjID]);
		DestroyDynamic3DTextLabel(phoneInfo[phoneid][phoneNameTag]);
		for(new x; enumPhoneInformation:x < enumPhoneInformation; x++) phoneInfo[i][enumPhoneInformation:x] = 0;
	}
	
	Iter_Clear(phoneObjects);
}

stock getNearestPhone(playerid)
{
    new currentPhone = -1, Float:distance = 9999.9, Float:odist;    
	new vw = GetPlayerVirtualWorld(playerid);
	new int = GetPlayerInterior(playerid);
    foreach(new i : phoneObjects)
    {
		if(vw == phoneInfo[i][phoneVW] && int == phoneInfo[i][phoneInt]) {
			odist = GetPlayerDistanceFromPoint(playerid, phoneInfo[i][pPosX], phoneInfo[i][pPosY], phoneInfo[i][pPosZ]);
			if(odist > 5.0) continue;
			if (odist < distance)
			{
				currentPhone = i;
				distance = odist;
			}
		}
    }
    return currentPhone;
}

stock cancelPayphone(playerid)
{
	if(!Iter_Contains(Player, playerid)) return 1;
	new p = GetPVarInt(playerid, "usingPayphone");
	if(p < 0 || p > MAX_PAYPHONES) return 1;
	phoneInfo[p][phoneStatus] = false;
	SetPVarInt(playerid, "usingPayphone", -1);
	TogglePlayerControllableEx(playerid, true);
	return 1;
}