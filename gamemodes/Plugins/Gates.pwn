#define MAX_GATES 300

new
	Iterator:gateObjects<MAX_GATES>,
	tCreateGateObjID[MAX_PLAYERS],
	tCreateGateObjModel[MAX_PLAYERS],
	tCreateGateStep[MAX_PLAYERS];

enum enumGateInformation
{
	gateID,
	gateModel,
	Float:gateClosePosX,
	Float:gateClosePosY,
	Float:gateClosePosZ,
	Float:gateClosePosRX,
	Float:gateClosePosRY,
	Float:gateClosePosRZ,
	Float:gateOpenPosX,
	Float:gateOpenPosY,
	Float:gateOpenPosZ,
	Float:gateOpenPosRX,
	Float:gateOpenPosRY,
	Float:gateOpenPosRZ,
	gateVW,
	gateInt,
	gatePass[21],
	usingPass,
	gateMember,
	gateRank,
	oSound,
	cSound,
	
	gateObjID,
	bool:gateStatus
};

enum enumObjectInformation
{
	Float:objCloseX,
	Float:objCloseY,
	Float:objCloseZ,
	Float:objCloseRX,
	Float:objCloseRY,
	Float:objCloseRZ,
	objVW,
	objInt
};

new gateInfo[MAX_GATES][enumGateInformation], objInfo[MAX_PLAYERS][enumObjectInformation];

// ---------- Commands -------------- //

CMD:gate(playerid, params[])
{
	new i = getNearestGate(playerid);
	if(i == -1) return SendClientMessage(playerid, COLOR_RED, "You aren't near a gate.");
	if(gateInfo[i][gateMember] != 0) {
		if(gateInfo[i][gateMember] != GetPVarInt(playerid, "Member")) {
			new str[68];
			format(str, 68, "You must be a member of %s to access this gate!", FactionInfo[gateInfo[i][gateMember]][fName]);
			return SendClientMessage(playerid, COLOR_ORANGE, str);
		}
		else if(gateInfo[i][gateRank] > GetPVarInt(playerid, "Rank")) {
			new str[72];
			format(str, 72, "You must be a rank %d member of %s to access this gate!", gateInfo[i][gateRank], FactionInfo[gateInfo[i][gateMember]][fName]);
			return SendClientMessage(playerid, COLOR_ORANGE, str);
		}
	}
	if(gateInfo[i][gateStatus]) {
		gateInfo[i][gateStatus] = false;
		if(gateInfo[i][cSound] != 0) {
			new Float:X, Float:Y, Float:Z;
			GetDynamicObjectPos(gateInfo[i][gateObjID], X, Y, Z);
			PlaySoundInArea(gateInfo[i][cSound], X, Y, Z, 20.0);
		}
		MoveDynamicObject(gateInfo[i][gateObjID], gateInfo[i][gateClosePosX], gateInfo[i][gateClosePosY], gateInfo[i][gateClosePosZ], 2.0, gateInfo[i][gateClosePosRX], gateInfo[i][gateClosePosRY], gateInfo[i][gateClosePosRZ]);
	} else {	
		switch(gateInfo[i][usingPass])
		{
			case 0:
			{
				gateInfo[i][gateStatus] = true;
				if(gateInfo[i][oSound] != 0) {
					new Float:X, Float:Y, Float:Z;
					GetDynamicObjectPos(gateInfo[i][gateObjID], X, Y, Z);
					PlaySoundInArea(gateInfo[i][oSound], X, Y, Z, 20.0);
				}
				MoveDynamicObject(gateInfo[i][gateObjID], gateInfo[i][gateOpenPosX], gateInfo[i][gateOpenPosY], gateInfo[i][gateOpenPosZ]+0.05, 2.0, gateInfo[i][gateOpenPosRX], gateInfo[i][gateOpenPosRY], gateInfo[i][gateOpenPosRZ]);
			}
			case 1:
			{
				if(isnull(params)) {
					return SendClientMessage(playerid, -1, "This gate uses a password. (/gate [password] to open it.)");
				}
				if(strmatch(params, gateInfo[i][gatePass])) {
					gateInfo[i][gateStatus] = true;
					if(gateInfo[i][oSound] != 0) {
						new Float:X, Float:Y, Float:Z;
						GetDynamicObjectPos(gateInfo[i][gateObjID], X, Y, Z);
						PlaySoundInArea(gateInfo[i][oSound], X, Y, Z, 20.0);
					}
					MoveDynamicObject(gateInfo[i][gateObjID], gateInfo[i][gateOpenPosX], gateInfo[i][gateOpenPosY], gateInfo[i][gateOpenPosZ]+0.05, 2.0, gateInfo[i][gateOpenPosRX], gateInfo[i][gateOpenPosRY], gateInfo[i][gateOpenPosRZ]);					
				} else {
					SendClientMessage(playerid, -1, "Incorrect password!");
				}
			}
		}
	}
	return 1;
}

CMD:creategate(playerid, params[])
{
	if(GetPVarInt(playerid, "Admin") < 10 && GetPVarInt(playerid, "Mapper") < 1) return error(playerid, "Must be a level 10 admin or mapper.");
	if(Iter_Count(gateObjects) >= MAX_GATES) return SendClientMessage(playerid, -1, "You cannot make any more gates, the gate-limit has been reached!");
	new objID;
	if(sscanf(params, "i", objID))
	{
		if(GateObjs[0] == 0) {
			new g_count = 0;
			for(new g=966; g < 994; g++)
			{
				if(g == 967) continue;
				GateObjs[g_count]=g;
				g_count++;
			}
		}
		ShowModelSelectionMenuEx(playerid, GateObjs, sizeof(GateObjs), "Gate Objects", 17, 16.0, 0.0, -55.0);
	}
	else
	{
		if(!IsValidObjID(objID)) return error(playerid, "Invalid object-ID.");
		new Float:fPos[3];
		GetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]);
		tCreateGateObjID[playerid] = CreatePlayerObject(playerid, objID, fPos[0]+0.3, fPos[1], fPos[2], -1, -1, -1);

		tCreateGateStep[playerid] = 1;
		tCreateGateObjModel[playerid] = objID;

		//Streamer_Update(playerid);
		EditPlayerObject(playerid, tCreateGateObjID[playerid]);
		SendClientMessage(playerid, -1, "[Gate System] Set where the gate should close.");
	}
	return 1;
}

CMD:deletegate(playerid, params[])
{
	if(GetPVarInt(playerid, "Admin") < 10 && GetPVarInt(playerid, "Mapper") < 1) return error(playerid, "Must be a level 10 admin or mapper.");
	new i = getNearestGate(playerid), query[172];
	if(i == -1) return SendClientMessage(playerid, COLOR_RED, "You aren't near a gate.");	
	format(query, sizeof(query), "DELETE FROM `gates` WHERE `ID` = %d", gateInfo[i][gateID]);
	mysql_function_query(handlesql, query, false, "thread_DeleteGate", "dd", playerid, i);
	return 1;
}

CMD:gatepass(playerid, params[])
{
	if(GetPVarInt(playerid, "Admin") < 10 && GetPVarInt(playerid, "Mapper") < 1) return error(playerid, "Must be a level 10 admin or mapper.");
	new i = getNearestGate(playerid);
	if(i == -1) return SendClientMessage(playerid, COLOR_RED, "You aren't near a gate.");
	new dbID = gateInfo[i][gateID];
	new query[150];
	if(isnull(params))
	{
		switch(gateInfo[i][usingPass])
		{
			case 0:
			{
				return SendClientMessage(playerid, -1, "SYNTAX: /gatepass [password]");
			}
			case 1:
			{
				gateInfo[i][usingPass] = 0;
				format(gateInfo[i][gatePass], 21, "");
				format(query, 150, "UPDATE `gates` SET `Password`='' WHERE `ID` = %d", dbID);
				mysql_tquery(handlesql, query);
				new str[32];
				format(str, 32, "Password removed from gate %d.", dbID);
				return SendClientMessage(playerid, -1, str);
			}
		}
	}
	if(strlen(params) < 1 || strlen(params) > 20) return SendClientMessage(playerid, -1, "Gate passwords must be between 1 and 20 characters long!");
	format(gateInfo[i][gatePass], 21, "%s", params);
	new name[21];
	mysql_real_escape_string(params, name);
	format(query, 150, "UPDATE `gates` SET `Password`='%s' WHERE `ID` = %d", name, dbID);
	mysql_tquery(handlesql, query);
	format(query, 150, "You've changed gate %d's password to: %s.", dbID, params);
	gateInfo[i][usingPass] = 1;
	SendClientMessage(playerid, COLOR_LIGHTBLUE, query);
	SendClientMessage(playerid, COLOR_ORANGE, "[TIP] Use /gatepass with no arguements to remove the password from the gate.");
	return 1;
}

CMD:gatemember(playerid, params[])
{
	if(GetPVarInt(playerid, "Admin") < 10 && GetPVarInt(playerid, "Mapper") < 1) return error(playerid, "Must be a level 10 admin or mapper.");
	new fac;
	if(sscanf(params, "i", fac)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /gatemember [factionid]");
	else
	{
		new i = getNearestGate(playerid);
		if(i == -1) return SendClientMessage(playerid, COLOR_RED, "You aren't near a gate.");
		if(fac < 0 || fac > MAX_FACTIONS || FactionInfo[fac][fUsed] != 1) return error(playerid, "Invalid faction ID!");
		new dbID = gateInfo[i][gateID];
		new query[128];
		format(query, 128, "UPDATE `gates` SET `Member`=%d WHERE `ID` = %d", fac, dbID);
		mysql_tquery(handlesql, query);
		format(query, 128, "You've changed gate %d's 'Member' to: %d.", dbID, fac);
		gateInfo[i][gateMember] = fac;
		SendClientMessage(playerid, COLOR_LIGHTBLUE, query);
	}
	return 1;
}

CMD:gaterank(playerid, params[])
{
	if(GetPVarInt(playerid, "Admin") < 10 && GetPVarInt(playerid, "Mapper") < 1) return error(playerid, "Must be a level 10 admin or mapper.");
	new fac;
	if(sscanf(params, "i", fac)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /gaterank [rankf]");
	else
	{
		new i = getNearestGate(playerid);
		if(i == -1) return SendClientMessage(playerid, COLOR_RED, "You aren't near a gate.");
		if(fac < 0 || fac > 25) return error(playerid, "Invalid rank!");
		new dbID = gateInfo[i][gateID];
		new query[128];
		format(query, 128, "UPDATE `gates` SET `Rank`=%d WHERE `ID` = %d", fac, dbID);
		mysql_tquery(handlesql, query);
		format(query, 128, "You've changed gate %d's 'Rank' to: %d.", dbID, fac);
		gateInfo[i][gateRank] = fac;
		SendClientMessage(playerid, COLOR_LIGHTBLUE, query);
	}
	return 1;
}

CMD:gateosound(playerid, params[])
{
	if(GetPVarInt(playerid, "Admin") < 10 && GetPVarInt(playerid, "Mapper") < 1) return error(playerid, "Must be a level 10 admin or mapper.");
	new id;
	if(sscanf(params, "i", id)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /gateosound [sound-id] (0 for none.)");
	else
	{
		new i = getNearestGate(playerid);
		if(i == -1) return SendClientMessage(playerid, COLOR_RED, "You aren't near a gate.");
		if(!IsValidSound(id)) return error(playerid, "Invalid sound-id!");
		new dbID = gateInfo[i][gateID];
		new query[128];
		format(query, 128, "UPDATE `gates` SET `oSound`=%d WHERE `ID` = %d", id, dbID);
		mysql_tquery(handlesql, query);
		format(query, 128, "You've changed gate %d's open-sound to: %d.", dbID, id);
		gateInfo[i][oSound] = id;
		SendClientMessage(playerid, COLOR_LIGHTBLUE, query);
	}
	return 1;
}

CMD:gatecsound(playerid, params[])
{
	if(GetPVarInt(playerid, "Admin") < 10 && GetPVarInt(playerid, "Mapper") < 1) return error(playerid, "Must be a level 10 admin or mapper.");
	new id;
	if(sscanf(params, "i", id)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /gatecsound [sound-id] (0 for none.)");
	else
	{
		new i = getNearestGate(playerid);
		if(i == -1) return SendClientMessage(playerid, COLOR_RED, "You aren't near a gate.");
		if(!IsValidSound(id)) return error(playerid, "Invalid sound-id!");
		new dbID = gateInfo[i][gateID];
		new query[128];
		format(query, 128, "UPDATE `gates` SET `cSound`=%d WHERE `ID` = %d", id, dbID);
		mysql_tquery(handlesql, query);
		format(query, 128, "You've changed gate %d's close-sound to: %d.", dbID, id);
		gateInfo[i][cSound] = id;
		SendClientMessage(playerid, COLOR_LIGHTBLUE, query);
	}
	return 1;
}

CMD:gatehelp(playerid, params[])
{
	scm(playerid, COLOR_GREEN, "Gate commands:");
	scm(playerid, COLOR_GREY, "  /gate");
	if(GetPVarInt(playerid, "Admin") > 9 || GetPVarInt(playerid, "Mapper") > 0) {
		scm(playerid, COLOR_ORANGE, "---Mapper Commands---");
		scm(playerid, COLOR_GREY, "  /creategate [model-id]");
		scm(playerid, COLOR_GREY, "  /deletegate (Deletes nearest gate.)");
		scm(playerid, COLOR_GREY, "  /gatepass [password]");
		scm(playerid, COLOR_GREY, "  /gatemember [faction-id]");
		scm(playerid, COLOR_GREY, "  /gaterank [rank]");
		scm(playerid, COLOR_GREY, "  /gateosound [sound-id] (Sets the gates opening sound.)");
		scm(playerid, COLOR_GREY, "  /gatecsound [sound-id] (Sets the gates closing sound.)");
	}
	return 1;
}

// ----------- Threaded Queries ----------- //

forward thread_LoadGates();
public thread_LoadGates()
{
	new rows, fields;
	
	cache_get_data(rows, fields, handlesql);
	
	if(rows > 0)
	{
		new temp[30];
		for(new i = 0; i < rows; i++)
		{
			cache_get_row(i, 0, temp);		gateInfo[i][gateID] = strval(temp);
			cache_get_row(i, 1, temp);		gateInfo[i][gateModel] = strval(temp);
			cache_get_row(i, 2, temp);		gateInfo[i][gateClosePosX] = floatstr(temp);
			cache_get_row(i, 3, temp);		gateInfo[i][gateClosePosY] = floatstr(temp);
			cache_get_row(i, 4, temp);		gateInfo[i][gateClosePosZ] = floatstr(temp);
			cache_get_row(i, 5, temp);		gateInfo[i][gateClosePosRX] = floatstr(temp);
			cache_get_row(i, 6, temp);		gateInfo[i][gateClosePosRY] = floatstr(temp);
			cache_get_row(i, 7, temp);		gateInfo[i][gateClosePosRZ] = floatstr(temp);
			cache_get_row(i, 8, temp);		gateInfo[i][gateOpenPosX] = floatstr(temp);
			cache_get_row(i, 9, temp);		gateInfo[i][gateOpenPosY] = floatstr(temp);
			cache_get_row(i, 10, temp);		gateInfo[i][gateOpenPosZ] = floatstr(temp);
			cache_get_row(i, 11, temp);		gateInfo[i][gateOpenPosRX] = floatstr(temp);
			cache_get_row(i, 12, temp);		gateInfo[i][gateOpenPosRY] = floatstr(temp);
			cache_get_row(i, 13, temp);		gateInfo[i][gateOpenPosRZ] = floatstr(temp);
			cache_get_row(i, 14, temp);		gateInfo[i][gateVW] = strval(temp);
			cache_get_row(i, 15, temp);		gateInfo[i][gateInt] = strval(temp);
			cache_get_row(i, 16, temp);		format(gateInfo[i][gatePass], 21, "%s", temp);
			if(!isnull(temp) && strlen(temp) > 0 && strcmp(temp, "", true) != 0) {
				gateInfo[i][usingPass] = 1;
			} else gateInfo[i][usingPass] = 0;
			cache_get_row(i, 17, temp);		gateInfo[i][gateMember] = strval(temp);
			cache_get_row(i, 18, temp);		gateInfo[i][gateRank] = strval(temp);
			cache_get_row(i, 19, temp);		gateInfo[i][oSound] = strval(temp);
			cache_get_row(i, 20, temp);		gateInfo[i][cSound] = strval(temp);
			
			gateInfo[i][gateObjID] = CreateDynamicObject(gateInfo[i][gateModel], gateInfo[i][gateClosePosX], gateInfo[i][gateClosePosY], gateInfo[i][gateClosePosZ], gateInfo[i][gateClosePosRX], gateInfo[i][gateClosePosRY], gateInfo[i][gateClosePosRZ], gateInfo[i][gateVW], gateInfo[i][gateInt]);
			Iter_Add(gateObjects, i);
		}
	}
	return 1;
}

forward thread_DeleteGate(playerid, gateid);
public thread_DeleteGate(playerid, gateid)
{
	if(playerid != INVALID_PLAYER_ID) SendClientMessage(playerid, -1, "SERVER: The gate was deleted successfully.");

	if(IsValidDynamicObject(gateInfo[gateid][gateObjID])) {
		DestroyDynamicObject(gateInfo[gateid][gateObjID]);
	}
	Iter_Remove(gateObjects, gateid);
	for(new x; enumGateInformation:x < enumGateInformation; x++) gateInfo[gateid][enumGateInformation:x] = 0;
	return 1;
}
		
forward thread_CreateGate(playerid,i);
public thread_CreateGate(playerid,i)
{
	gateInfo[i][gateID] = cache_insert_id(handlesql);
	if(playerid != INVALID_PLAYER_ID)
	{
		Streamer_Update(playerid);
		SendClientMessage(playerid, -1, "SERVER: The gate was created successfully.");
	}
	return 1;
}

// ------------- Stock Functions ----------------- //

stock DestroyGate(gateid)
{
	DestroyDynamicObject(gateInfo[gateid][gateObjID]);
	Iter_Remove(gateObjects, gateid);
	for(new i; enumGateInformation:i < enumGateInformation; i++) gateInfo[gateid][enumGateInformation:i] = 0;
	return 1;
}

stock removeAllGates()
{
	for(new i = 0; i < sizeof(gateInfo); i++)
	{
		DestroyDynamicObject(gateInfo[i][gateObjID]);
		for(new x; enumGateInformation:x < enumGateInformation; x++) gateInfo[i][enumGateInformation:x] = 0;
	}
	
	Iter_Clear(gateObjects);
}

stock getNearestGate(playerid)
{
    new currentGate = -1, Float:distance = 9999.9, Float:odist;    
	new vw = GetPlayerVirtualWorld(playerid);
	new int = GetPlayerInterior(playerid);
    foreach(new i : gateObjects)
    {
		if(vw == gateInfo[i][gateVW] && int == gateInfo[i][gateInt]) {
			odist = GetPlayerDistanceFromPoint(playerid, gateInfo[i][gateClosePosX], gateInfo[i][gateClosePosY], gateInfo[i][gateClosePosZ]);
			if(odist > 15.00) continue;
			if (odist < distance)
			{
				currentGate = i;
				distance = odist;
			}
		}
    }
    return currentGate;
}