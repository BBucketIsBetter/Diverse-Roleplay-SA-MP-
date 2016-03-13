//PData by Crazycarpet, for Fresh.
/*===============Description==================
	-Some helper functions for SA:MP's 'PVar' library that automatically generate the SQL query statements.
	-Max 'field' size is 32 characters.
	-Types: 0 = Integer, 1 = Float, 2 = String.
	-AddPDataField(id,field,type) MUST be ran on gamemode startup.
============================================*/

//==================Defines=================//
#define MAX_PDATA_FIELDS 500

/*
#define TYPE_INTEGER 0
#define TYPE_FLOAT 1;
#define TYPE_STRING 2;
*/
//==========================================//

//================Forwarding================//
forward SavePData(playerid);
//forward LoadPData(playerid);
//==========================================//

//============New/Enum statments============//
enum pData
{
	pUsed,
	pType,
	pField[32]
}
new PDataFields[MAX_PDATA_FIELDS][pData];
//==========================================//

//================Build Code================//
//Types: 0 = Integer, 1 = Float, 2 = String.
new pDataCount = 0;
stock AddPDataField(field[],type,size=11) { //Helper function to automate loading.
	PDataFields[pDataCount][pUsed] = 1; //For optimizing loading
	PDataFields[pDataCount][pType] = type;
	format(PDataFields[pDataCount][pField],32,"%s",field);
	switch(type) {
		case 0: //Integer
		{
			new query[80];
			mysql_format(handlesql, query,80,"ALTER TABLE accounts ADD %s int(%d) NOT NULL",field,size);
			mysql_tquery(handlesql, query);
		}
		case 1: //Float
		{
			new query[80];
			mysql_format(handlesql, query,80,"ALTER TABLE accounts ADD %s float NOT NULL",field);
			mysql_tquery(handlesql, query);
		}
		case 2: //String
		{
			new query[80];
			mysql_format(handlesql, query,80,"ALTER TABLE accounts ADD %s varchar(%d) NOT NULL",field,size);
			mysql_tquery(handlesql, query);
		}
	}
	pDataCount++;
	return 1;
}

stock SetPDataInt(playerid,field[],val) {
	if(GetPVarInt(playerid,"PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_LIGHTBLUE, "WARNING: Tried to 'SetPData' on a player who's not logged in, tell a developer ASAP.");
	SetPVarInt(playerid,field,val);
	new query[100];
	mysql_format(handlesql, query, 100, "UPDATE accounts SET %s=%d WHERE Name='%s'",field,val,PlayerName(playerid));
	mysql_tquery(handlesql, query);
	return 1;
}

stock SetPDataFloat(playerid,field[],Float:val) {
	if(GetPVarInt(playerid,"PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_LIGHTBLUE, "WARNING: Tried to 'SetPData' on a player who's not logged in, tell a developer ASAP.");
	SetPVarFloat(playerid,field,val);
	new query[124];
	mysql_format(handlesql, query, 124, "UPDATE accounts SET %s=%f WHERE Name='%s'",field,val,PlayerName(playerid));
	mysql_tquery(handlesql, query);
	return 1;
}

stock SetPDataString(playerid,field[],str[]) {
	if(GetPVarInt(playerid,"PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_LIGHTBLUE, "WARNING: Tried to 'SetPData' on a player who's not logged in, tell a developer ASAP.");
	SetPVarString(playerid,field,str);
	new val[128];
	mysql_real_escape_string(str, val);
	new query[184];
	mysql_format(handlesql, query, 184, "UPDATE accounts SET %s='%s' WHERE Name='%s'",field,val,PlayerName(playerid));
	mysql_tquery(handlesql, query);
	return 1;
}

public SavePData(playerid) {
	if(GetPVarInt(playerid,"PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_LIGHTBLUE, "WARNING: Tried to 'SavePData' on a player who's not logged in.");
	for(new i=0; i < MAX_PDATA_FIELDS+1; i++)
	{
		if(PDataFields[i][pUsed] != 0) break; // We've reached the end of PData, they've all been saved. Kill the loop.
		switch(PDataFields[i][pType])
		{
			case 0: //Integer
			{
				new query[100];
				mysql_format(handlesql, query, 100, "UPDATE `accounts` SET `%s`=%d WHERE `Name`='%s'",PDataFields[i][pField],GetPVarInt(playerid,PDataFields[i][pField]),PlayerName(playerid));
				mysql_tquery(handlesql, query);
			}
			case 1: //Float
			{
				new query[124];
				mysql_format(handlesql, query, 124, "UPDATE `accounts` SET `%s`=%f WHERE `Name`='%s'",PDataFields[i][pField],GetPVarFloat(playerid,PDataFields[i][pField]),PlayerName(playerid));
				mysql_tquery(handlesql, query);
			}
			case 2: //String
			{
				new val[128];
				GetPVarString(playerid,PDataFields[i][pField],val,128);
				mysql_real_escape_string(val, val);
				new query[184];
				mysql_format(handlesql, query, 184, "UPDATE `accounts` SET `%s`='%s' WHERE `Name`='%s'",PDataFields[i][pField],val,PlayerName(playerid));
				mysql_tquery(handlesql, query);
			}
		}
	}
	return 1;
}

/*public LoadPData(playerid) {
	if(GetPVarInt(playerid,"PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_LIGHTBLUE, "WARNING: Tried to 'LoadPData' on a player who's not logged in.");
	new fetch[64];
	for(new i=0; i < MAX_PDATA_FIELDS+1; i++)
	{
		if(PDataFields[i][pUsed] != 0) break; // We've reached the end of PData, they've all been loaded. Kill the loop.
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
	return 1;
}*/
//==========================================//