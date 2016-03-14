//============================================//
//=====[ COMMAND SECTION ]=====//
//============================================//
#define ALTCOMMAND:%1->%2;           \
COMMAND:%1(playerid, params[])   \
return cmd_%2(playerid, params);
//============================================//
public OnPlayerCommandPerformed(playerid, cmdtext[], success)
{
	switch(success)
	{
		case 0:
		{
		    new string[MAX_MSG_LENGTH];
	        format(string, sizeof(string),"The command '%s' is not recognized by the server. (/help)", cmdtext);
	        SendClientMessage(playerid, COLOR_GREY, string);
	        return 1;
		}
		case 1:
		{
			if(GetPVarInt(playerid, "Mute") < 1)
			{
				PlayerInfo[playerid][pCmdSpam]++;

				if(PlayerInfo[playerid][pCmdSpam] >= 5)
				{
					new string[128];
					format(string, sizeof(string), "AdmWarning: %s (ID: %i) is possibly spamming commands (Typing: %s).", PlayerInfo[playerid][pName], playerid, cmdtext);
			        SendAdminMessage(COLOR_YELLOW, string);
					PlayerInfo[playerid][pCmdTime] = 3;
			        PlayerInfo[playerid][pCmdSpam] = 0;
					SetPVarInt(playerid, "Mute", 1);
					SendClientMessage(playerid, COLOR_LIGHTRED, "You have been temporarily muted. (Reason: Command spamming)");
					return 0;
				}
			}
            CMDLog(PlayerInfo[playerid][pUsername], cmdtext);
		}
	}
	return 1;
}
//============================================//
COMMAND:guide(playerid, params[])
{
	if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_LIGHTRED, "You are currently muted!");
	if(GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You must be outside to use this!");
	if(GetPlayerVirtualWorld(playerid) != 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You must be outside to use this!");
	if(!IsPlayerInRangeOfPoint(playerid, 5.0, 1640.8882,-2243.1147,13.4936)) return SendClientMessage(playerid, COLOR_LIGHTRED, "You are not around the guide icon!");
    SendClientMessage(playerid, COLOR_WHITE, "Welcome to Diverse Roleplay!");
    SendClientMessage(playerid, COLOR_GREY, "If you are new here, I suggest you visit www.diverseroleplay.org,");
    SendClientMessage(playerid, COLOR_GREY, "And head to the 'New Player Forum' and the 'Guides' sections.");
    SendClientMessage(playerid, COLOR_GREY, "They will display and help you with any questions needed within the server.");
    SendClientMessage(playerid, COLOR_GREY, "For other help you can always simply type (/help), or (/locations).");
    SendClientMessage(playerid, COLOR_GREY, "If you are still in need of assistance type (/helpme) or (/ra).");
	return 1;
}
//============================================//
COMMAND:locations(playerid, params[])
{
	new string[1000];
	if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_LIGHTRED, "You are currently muted!");
	if (GetPVarInt(playerid, "OnRoute") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are currently on a route.");
	if(GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You must be outside to use this!");
	if(GetPlayerVirtualWorld(playerid) != 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You must be outside to use this!");
	for(new i = 0; i < sizeof(Locations); i++)
	{
	    if(i == 0) { format(string, 1000, "%s", Locations[i][lname]); }
	    else { format(string, 1000, "%s\n%s", string, Locations[i][lname]); }
	}
	ShowPlayerDialog(playerid, 86, DIALOG_STYLE_LIST, "Locations", string, "Select", "Close");
	return 1;
}
//============================================//
COMMAND:help(playerid, params[])
{
	new string[1000];
	if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_LIGHTRED, "You are currently muted!");
	for(new i = 0; i < sizeof(HelpMenu); i++)
	{
	    if(i == 0) { format(string, 1000, "%s", HelpMenu[i][0]); }
	    else { format(string, 1000, "%s\n%s", string, HelpMenu[i][0]); }
	}
	ShowPlayerDialog(playerid, 17, DIALOG_STYLE_LIST, "Help Menu", string, "Select", "Close");
	return 1;
}
//============================================//
ALTCOMMAND:inv->inventory;
COMMAND:inventory(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_LIGHTRED, "You are currently muted!");
	if(GetPVarInt(playerid, "Jailed") > 0) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-jail.");
	if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    new diatxt[128];
    new count_in = 0;
	new id = GetPVarInt(playerid, "HouseEnter");
	format(diatxt, sizeof(diatxt), "Player Inventory");
	if(id != 0 && GetCloseHouseSafe(playerid, id) && HouseInfo[id][sLocked] != 1)
	{
	    format(diatxt, sizeof(diatxt), "%s\nProperty Inventory", diatxt);
	    count_in = 1;
	}
	if(count_in != 0)
	{
	    ShowPlayerDialog(playerid, 204, DIALOG_STYLE_LIST, "Select inventory", diatxt, "Open","Close");
	}
	else
	{
    	CallRemoteFunction("PrintInv", "i", playerid);
	}
	return 1;
}
//============================================//
COMMAND:mp3(playerid, params[])
{
	if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_LIGHTRED, "You are currently muted!");
	if (!CheckInvItem(playerid, 408)) return SendClientMessage(playerid, COLOR_WHITE, "You don't have a MP3 player.");
	ShowPlayerDialog(playerid,96,DIALOG_STYLE_LIST,"MP3 Player","Radio Stations\nDirect URL\nTurn Off","Select", "Exit");
	return 1;
}
//============================================//
COMMAND:wt(playerid, params[])
{
	new text[128], string[128], sendername[MAX_PLAYER_NAME];
	if(sscanf(params, "s[128]", text)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /wt [text]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_LIGHTRED, "You are currently muted!");
	    if (!CheckInvItem(playerid, 402)) return SendClientMessage(playerid, COLOR_WHITE, "You don't have a Walkie Talkie.");
	    if (GetPVarInt(playerid, "WalkieFreq") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You need a valid walkie talkie frequency (/setfreq).");
	    if(GetPVarInt(playerid, "Jailed") > 0) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-jail.");
	    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
	    format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
      	GiveNameSpace(sendername);
	    format(string, sizeof(string), "** Ch[%d] %s: %s **",GetPVarInt(playerid, "WalkieFreq"), sendername, text);
		SendFreqMessage(playerid,GetPVarInt(playerid, "WalkieFreq"),0x00C6C696, string);
		format(string, sizeof(string), "%s (walkie talkie): %s", sendername, text);
		ProxRadio(20.0, playerid, string, COLOR_FADE);
	}
	return 1;
}
//============================================//
ALTCOMMAND:op->ucp;
ALTCOMMAND:options->op;
COMMAND:ucp(playerid, params[])
{
	if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_LIGHTRED, "You are currently muted!");
	if(GetPVarInt(playerid, "Jailed") > 0) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-jail.");
	if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while dead!");
	EnableUCP(playerid, 0);
	return 1;
}
//============================================//
COMMAND:setfreq(playerid, params[])
{
	new amount,string[128];
	if(sscanf(params, "i", amount)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /setfreq [1-9999]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (!CheckInvItem(playerid, 402)) return SendClientMessage(playerid, COLOR_WHITE, "You don't have a Walkie Talkie.");
	    if(amount < 1 || amount > 9999) return SendClientMessage(playerid, COLOR_GREY, "Cannot go under 1 or above 9999.");
	    format(string, sizeof(string), "Walkie Talkie frequency set to: %d!", amount);
	    SendClientMessage(playerid, COLOR_WHITE, string);
	    SetPVarInt(playerid, "WalkieFreq", amount);
	}
	return 1;
}
//============================================//
COMMAND:stats(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") != 1) return SendClientMessage(playerid, COLOR_WHITE, "SERVER: You must be logged in to use this.");
    CallRemoteFunction("PrintStats", "ii", playerid, playerid);
	return 1;
}
//============================================//
ALTCOMMAND:l->low;
COMMAND:low(playerid, params[])
{
	new text[255],string[255],sendername[MAX_PLAYER_NAME],type;
	if(sscanf(params, "s[255]", text)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /low {FFFFFF}[text]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while dead!");
	    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_LIGHTRED, "You are currently muted!");
		format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
		GiveNameSpace(sendername);
    	if (IsPlayerInAnyVehicle(playerid) && IsAWindowCar(playerid))
        {
            switch(VehicleInfo[GetPlayerVehicleID(playerid)][vWindows])
			{
                case 0:
                {
                    format(string, sizeof(string), "[Windows Shut]: %s says[LOW]: %s", sendername, text);
                    type=1;
                }
                case 1: format(string, sizeof(string), "[Windows Open]: %s says[LOW]: %s", sendername, text);
            }
        }
        else format(string, sizeof(string), "%s says[LOW]: %s", sendername, text);
		if(type == 1)
		{
		    foreach(new i : Player)
		    {
		        if(GetPVarInt(i, "PlayerLogged") == 1 && IsPlayerInAnyVehicle(i))
		        {
				    if(GetPlayerVehicleID(i) == GetPlayerVehicleID(playerid))
				    {
				        SendClientMessage(i,  0xF0F0F096, string);
				    }
		        }
		    }
		}
		else ProxDetector(5.0, playerid, string, COLOR_GREY);
	}
	return 1;
}
//============================================//
COMMAND:say(playerid, params[])
{
	new text[255],string[255],sendername[MAX_PLAYER_NAME];
	if(sscanf(params, "s[255]", text)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /say {FFFFFF}[text]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") != 1) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while dead!");
	    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_LIGHTRED, "You are currently muted!");
		format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
		GiveNameSpace(sendername);
        format(string, sizeof(string), "%s %s: %s", sendername, PrintPrefix(playerid), text);
        new type = 0;
        if (IsPlayerInAnyVehicle(playerid) && IsAWindowCar(playerid))
        {
            switch(VehicleInfo[GetPlayerVehicleID(playerid)][vWindows])
			{
                case 0:
                {
                    format(string, sizeof(string), "[Windows Shut]: %s %s: %s", sendername, PrintPrefix(playerid), text);
                    type=1;
                }
                case 1: format(string, sizeof(string), "[Windows Open]: %s %s: %s", sendername, PrintPrefix(playerid), text);
            }
        }
		if(type == 0) ProxDetector(30.0, playerid, string, COLOR_FADE), SetPlayerChatBubble(playerid, string, COLOR_WHITE, 10.0, strlen(text)*100);
		else
		{
		    foreach(new i : Player)
		    {
		        if(GetPVarInt(i, "PlayerLogged") == 1 && IsPlayerInAnyVehicle(i))
		        {
				    if(GetPlayerVehicleID(i) == GetPlayerVehicleID(playerid))
				    {
				        SendClientMessage(i,  0xF0F0F096, string);
				    }
		        }
		    }
		}
	}
	return 1;
}
ALTCOMMAND:c->say;
//============================================//
COMMAND:me(playerid, params[])
{
	new text[255],string[255],sendername[MAX_PLAYER_NAME];
	if(sscanf(params, "s[255]", text)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /me {FFFFFF}[text]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") != 1) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_LIGHTRED, "You are currently muted!");
		format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
		GiveNameSpace(sendername);
    	format(string, sizeof(string), "* %s %s", sendername, text);
    	ProxDetector(30.0, playerid, string, COLOR_PURPLE);
	}
	return 1;
}
//============================================//
COMMAND:ame(playerid, params[])
{
	new text[128],string[255],sendername[MAX_PLAYER_NAME];
	if(sscanf(params, "s[128]", text)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /ame {FFFFFF}[text]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") != 1) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_LIGHTRED, "You are currently muted!");
		format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
		GiveNameSpace(sendername);
    	format(string, sizeof(string), "* %s %s", sendername, text);
    	SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 10000);
    	format(string, sizeof(string), "> %s ", text);
    	SendClientMessage(playerid, COLOR_PURPLE, string);
	}
	return 1;
}
//============================================//
COMMAND:do(playerid, params[])
{
	new text[255],string[255],sendername[MAX_PLAYER_NAME];
	if(sscanf(params, "s[255]", text)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /do {FFFFFF}[text]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") != 1) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_LIGHTRED, "You are currently muted!");
		format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
		GiveNameSpace(sendername);
    	format(string, sizeof(string), "* %s (( %s ))", text, sendername);
    	ProxDetector(30.0, playerid, string, COLOR_PURPLE);
	}
	return 1;
}
//============================================//
COMMAND:shout(playerid, params[])
{
	new text[128],string[255],sendername[MAX_PLAYER_NAME];
	if(sscanf(params, "s[128]", text)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /shout {FFFFFF}[text]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") != 1) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while dead!");
	    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_LIGHTRED, "You are currently muted!");
		format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
		GiveNameSpace(sendername);
    	format(string, sizeof(string), "%s Shouts: %s!", sendername, text);
    	ProxDetector(50.0, playerid, string, COLOR_FADE);
    	SetPlayerChatBubble(playerid, string, COLOR_FADE, 30.0, strlen(text)*100);
    	foreach(new h : HouseIterator)
		{
	    	if(IsPlayerInRangeOfPoint(playerid,10.0, HouseInfo[h][hXo], HouseInfo[h][hYo], HouseInfo[h][hZo]))
	    	{
            	foreach(new p : Player)
				{
                	if(IsPlayerInRangeOfPoint(p,30.0, HouseInfo[h][hXi], HouseInfo[h][hYi], HouseInfo[h][hZi]))
                	{
						if(GetPlayerVirtualWorld(p) == h)
						{
						    format(string, sizeof(string), "[OUTSIDE-HOUSE-DOOR]: %s shouts: %s!", sendername, text);
				        	SendClientMessage(p, COLOR_WHITE, string);
				    	}
					}
		    	}
	    	}
	    	if(IsPlayerInRangeOfPoint(playerid,20.0, HouseInfo[h][hXi], HouseInfo[h][hYi], HouseInfo[h][hZi]))
	    	{
	    	    if(GetPlayerVirtualWorld(playerid) == h)
	    	    {
            	    foreach(new p : Player)
				    {
                	    if(IsPlayerInRangeOfPoint(p, 15.0, HouseInfo[h][hXo], HouseInfo[h][hYo], HouseInfo[h][hZo]))
                	    {
						    if(GetPlayerVirtualWorld(p) == 0)
						    {
						        format(string, sizeof(string), "[INSIDE-HOUSE-DOOR]: %s shouts: %s!", sendername, text);
				        	    SendClientMessage(p, COLOR_WHITE, string);
				    	    }
					    }
		    	    }
		    	}
	    	}
		}
		if(PlayerInfo[playerid][pInVehicle] == -1) { //Not in vehicle interior.
			new car = PlayerToCar(playerid, 2, 10.0);
			if(car != INVALID_VEHICLE_ID && IsEnterableVehicle(car)) {
				foreach(new i : Player) {
					if(PlayerInfo[i][pInVehicle] == car) {
						format(string, sizeof(string), "[OUTSIDE-VEHICLE]: %s shouts: %s!", sendername, text);
						SendClientMessage(i, COLOR_WHITE, string);					
					}
				}
			}
		} else { //In vehicle interior.
			new Float:x, Float:y, Float:z;
			GetVehiclePos(PlayerInfo[playerid][pInVehicle], x, y, z);
			foreach(new i : Player) {
				if(!IsPlayerInRangeOfPoint(i, 10.0, x, y, z)) continue;
				format(string, sizeof(string), "[INSIDE-VEHICLE]: %s shouts: %s!", sendername, text);
				SendClientMessage(i, COLOR_WHITE, string);					
			}			
		}
	}
	return 1;
}
ALTCOMMAND:s->shout;
//============================================//
COMMAND:b(playerid, params[])
{
	new text[255],string[255],sendername[MAX_PLAYER_NAME];
	if(sscanf(params, "s[255]", text)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /b {FFFFFF}[ooc chat]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_LIGHTRED, "You are currently muted!");
		format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
		GiveNameSpace(sendername);
		switch(GetPVarInt(playerid, "MaskUse"))
		{
		    case 0: format(string, sizeof(string), "(( [%i] %s Says: %s ))", playerid, sendername, text);
		    case 1: format(string, sizeof(string), "(( %s Says: %s ))", sendername, text);
		}
		if(GetPVarInt(playerid, "Admin") == 11 && GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
		{
		    format(string, sizeof(string), "(( Hidden Says: %s ))", text);
		}
		switch(GetPVarInt(playerid, "Admin"))
		{
		    case 0: SendOOCMessage(20.0, playerid, string);
		    case 1 .. 11:
		    {
		        switch(GetPVarInt(playerid, "AdminDuty"))
		        {
		            case 0: ProxDetector(20.0, playerid, string, COLOR_FADE);
		            case 1:
					{
						switch(GetPVarInt(playerid, "Admin"))
						{
						    case 1 .. 3: ProxDetector(20.0, playerid, string, COLOR_ADMIN); // Moderator
						    case 4 .. 9: ProxDetector(20.0, playerid, string, COLOR_SENIOR_ADMIN); // Senior
						    case 10 .. 11:
						    {
							    ProxDetector(20.0, playerid, string, COLOR_LEAD_ADMIN); // Lead Administrator
							}
						}
					}
		        }
		    }
			default: SendOOCMessage(20.0, playerid, string);
		}
	}
	return 1;
}
//============================================//
COMMAND:eject(playerid, params[])
{
	new targetid,string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "u", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /eject {FFFFFF}[playerid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") != 1) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOR_WHITE, "You must be in a vehicle to use this!");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
	    if(GetPlayerVehicleID(targetid) == GetPlayerVehicleID(playerid))
	    {
	        format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
            GiveNameSpace(sendername);
            format(giveplayer, sizeof(giveplayer), "%s", PlayerNameEx(targetid));
            GiveNameSpace(giveplayer);
      	    format(string, sizeof(string), "You ejected %s from the vehicle.", giveplayer);
      	    SendClientMessage(playerid, COLOR_WHITE, string);
      	    format(string, sizeof(string), "You were ejected by driver %s.", sendername);
      	    SendClientMessage(targetid, COLOR_WHITE, string);
      	    RemovePlayerFromVehicle(targetid);
      	}
	}
	return 1;
}
//============================================//
COMMAND:shake(playerid, params[])
{
	new targetid,string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "ui", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /shake [playerid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (playerid == targetid) return SendClientMessage(playerid, COLOR_GREY, "You cannot pay to yourself.");
		if(IsPlayerConnected(targetid))
		{
		    if(PlayerToPlayer(playerid,targetid,8.0))
   			{
				SetPVarInt(targetid, "ShakeOffer", playerid);
   			    format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
	    	    format(giveplayer, sizeof(giveplayer), "%s", PlayerNameEx(targetid));
      		    GiveNameSpace(sendername);
        	    GiveNameSpace(giveplayer);
        	    format(string, sizeof(string), "You offered %s a handshake.", giveplayer);
           		SendClientMessage(playerid,COLOR_LIGHTBLUE,string);
            	format(string, sizeof(string), "%s gave you a handshake (/accept shake [1-8]).", sendername);
            	SendClientMessage(targetid,COLOR_LIGHTBLUE,string);
   			}
   			else
   			{
   			    SendClientMessage(playerid,COLOR_GREY,"You are not close enough to that player!");
   			}
		}
	}
	return 1;
}
//============================================//
COMMAND:blindfold(playerid, params[])
{
	new targetid,string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "ui", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /blindfold [playerid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (playerid == targetid) return SendClientMessage(playerid, COLOR_GREY, "You cannot blind yourself.");
		if(IsPlayerConnected(targetid))
		{
		    if(PlayerToPlayer(playerid,targetid,5.0))
   			{
				SetPVarInt(targetid, "BlindOffer", playerid);
   			    format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
	    	    format(giveplayer, sizeof(giveplayer), "%s", PlayerNameEx(targetid));
      		    GiveNameSpace(sendername);
        	    GiveNameSpace(giveplayer);
        	    format(string, sizeof(string), "You offered %s a blindfold.", giveplayer);
           		SendClientMessage(playerid,COLOR_LIGHTBLUE,string);
            	format(string, sizeof(string), "%s is trying to wrap a blindfold over your eyes (/accept blind).", sendername);
            	SendClientMessage(targetid,COLOR_LIGHTBLUE,string);
   			}
   			else SendClientMessage(playerid,COLOR_GREY,"You are not close enough to that player!");
		}
	}
	return 1;
}
//============================================//
COMMAND:unblind(playerid, params[])
{
	new targetid,string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "ui", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /unblind [playerid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (playerid == targetid) return SendClientMessage(playerid, COLOR_GREY, "You cannot un-blind to yourself.");
		if(IsPlayerConnected(targetid))
		{
		    if (GetPVarInt(targetid, "Blinded") == 0) return SendClientMessage(playerid, COLOR_WHITE, "This player is not blinded.");
		    if(PlayerToPlayer(playerid,targetid,5.0))
   			{
				DeletePVar(targetid,"Blinded");
				TextDrawHideForPlayer(targetid,BlindDraw);
   			    format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
	    	    format(giveplayer, sizeof(giveplayer), "%s", PlayerNameEx(targetid));
      		    GiveNameSpace(sendername);
        	    GiveNameSpace(giveplayer);
        	    format(string, sizeof(string), "You removed %s's blindfold.", giveplayer);
           		SendClientMessage(playerid,COLOR_LIGHTBLUE,string);
            	format(string, sizeof(string), "%s removed your blindfold.", sendername);
            	SendClientMessage(targetid,COLOR_LIGHTBLUE,string);
   			}
   			else SendClientMessage(playerid,COLOR_GREY,"You are not close enough to that player!");
		}
	}
	return 1;
}
//============================================//
COMMAND:pay(playerid, params[])
{
	new amount,targetid,string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "ii", targetid, amount)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /pay {FFFFFF}[playerid/maskid] [amount]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") != 1) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "PlayTime") <= 10) return SendClientMessage(playerid, COLOR_LIGHTRED, "You must wait before performing this command!");
	    if(amount < 1 || amount > 50000) return SendClientMessage(playerid, COLOR_GREY, "Cannot go under 1 or above 50000.");
        if(amount > GetPlayerMoneyEx(playerid)) return SendClientMessage(playerid, COLOR_GREY, "You don't have that much money on you.");
        if(GetPVarInt(playerid, "Delay") > GetCount()) return SendClientMessage(playerid, COLOR_LIGHTRED, "You must wait before performing this command!");
	    if(GetPVarInt(playerid, "ConnectTime") < 2) return SendClientMessage(playerid, COLOR_GREY, "You need 2 hours played to use this command.");
	    new found = 0;
		if(!IsPlayerConnected(targetid))
		{
		    foreach(new i : Player)
	        {
	            if(GetPVarInt(i, "MaskUse") == 1 && GetPVarInt(i, "MaskID") == targetid)
	            {
	                targetid=i;
	                found++;
					break;
	            }
	        }
	        if(found == 0) return SendClientMessage(playerid,COLOR_WHITE,"There is no-one online with that playerid or maskid.");
		}
		if (playerid != targetid)
		{
		    if(PlayerToPlayer(playerid,targetid,3.0))
   			{
   			    format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
	    	    format(giveplayer, sizeof(giveplayer), "%s", PlayerNameEx(targetid));
      		    GiveNameSpace(sendername);
        	    GiveNameSpace(giveplayer);
        	    PlayerPlaySound(targetid, 1083, 0.0, 0.0, 0.0);
        	    PlayerPlaySound(playerid, 1083, 0.0, 0.0, 0.0);
        	    if(amount >= 50000)
	    	    {
	        	    if(GetPVarInt(playerid, "Admin") == 0)
	        	    {
	            	    format(string, sizeof(string), "AdmWarn: %s has given %s $%d.", PlayerName(playerid), PlayerName(targetid), amount);
                	    SendAdminMessage(COLOR_YELLOW,string);
	        	    }
	    	    }
            	format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
            	format(giveplayer, sizeof(giveplayer), "%s", PlayerNameEx(targetid));
            	format(string, sizeof(string), "*** %s takes out $%d, and hands it to %s.", sendername, amount, giveplayer);
            	ProxDetector(30.0, playerid, string, COLOR_PURPLE);
				format(string, sizeof(string), "You gave %s [$%d].", giveplayer, amount);
				SendClientMessage(playerid,COLOR_WHITE,string);
				format(string, sizeof(string), "%s gave you [$%d].", sendername, amount);
                SendClientMessage(targetid,COLOR_WHITE,string);
                GivePlayerMoneyEx(playerid,-amount);
				GivePlayerMoneyEx(targetid,amount);
				format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
            	format(giveplayer, sizeof(giveplayer), "%s", PlayerName(targetid));
            	format(string, sizeof(string), "*** %s takes out $%d, and hands it to %s.", sendername, amount, giveplayer);
				PayLog(string);
				SetPVarInt(playerid, "Delay", GetCount()+2000); SetPVarInt(targetid, "Delay", GetCount()+2000);
   			}
   			else SendClientMessage(playerid,COLOR_GREY,"You are not close enough to that player!");
		}
		else SendClientMessage(playerid, COLOR_GREY, "You cannot pay to yourself.");
	}
	return 1;
}
//============================================//
COMMAND:wiretransfer(playerid, params[])
{
	new amount,targetid,string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "ii", targetid, amount)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /wiretransfer {FFFFFF}[playerid] [amount]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") != 1) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "PlayTime") <= 10) return SendClientMessage(playerid, COLOR_LIGHTRED, "You must wait before performing this command!");
	    if(amount < 25000 || amount > 5000000) return SendClientMessage(playerid, COLOR_GREY, "Cannot go under 25000 or above 5000000.");
        if(amount > GetPVarInt(playerid, "Bank")) return SendClientMessage(playerid, COLOR_GREY, "You don't have that much money in your bank.");
        if(GetPVarInt(playerid, "Delay") > GetCount()) return SendClientMessage(playerid, COLOR_LIGHTRED, "You must wait before performing this command!");
	    if(GetPVarInt(playerid, "ConnectTime") < 8) return SendClientMessage(playerid, COLOR_GREY, "You need 8 hours played to use this command.");
	    if(GetPVarInt(targetid, "ConnectTime") < 8) return SendClientMessage(playerid, COLOR_GREY, "This player needs 8 hours played to continue.");
	    if(GetPVarInt(playerid, "IntEnter") != 4) return scm(playerid, -1, "You need to be in the bank interior to use this!");
		if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid,COLOR_WHITE,"There is no-one online with that playerid.");
		if (playerid != targetid)
		{
		    if(PlayerToPlayer(playerid, targetid, 3.0))
   			{
   			    format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
	    	    format(giveplayer, sizeof(giveplayer), "%s", PlayerNameEx(targetid));
      		    GiveNameSpace(sendername);
        	    GiveNameSpace(giveplayer);
        	    PlayerPlaySound(targetid, 1083, 0.0, 0.0, 0.0);
        	    PlayerPlaySound(playerid, 1083, 0.0, 0.0, 0.0);
        	    if(amount >= 100000)
	    	    {
	        	    if(GetPVarInt(playerid, "Admin") == 0)
	        	    {
	            	    format(string, sizeof(string), "AdmWarn: %s has wired %s $%d.", PlayerName(playerid), PlayerName(targetid), amount);
                	    SendAdminMessage(COLOR_YELLOW,string);
	        	    }
	    	    }
            	format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
            	format(giveplayer, sizeof(giveplayer), "%s", PlayerNameEx(targetid));
            	//==========//
            	SendClientMessage(playerid,COLOR_WHITE,":Bank Statement:");
                format(string, sizeof(string), "Old Balance: $%d", GetPVarInt(playerid, "Bank"));
			    SendClientMessage(playerid, COLOR_GREEN, string);
			    format(string, sizeof(string), "New Balance: $%d", GetPVarInt(playerid, "Bank")-amount);
			    SendClientMessage(playerid, COLOR_GREEN, string);
			    format(string, sizeof(string), "- $%d wired to %s's bank account.", amount, PlayerName(targetid));
			    SendClientMessage(playerid, COLOR_GREY, string);
			    //==========//
				format(string, sizeof(string), "%s has wired $%d to your bank account", sendername, amount);
                SendPlayerSMS(targetid, string, "LS Bank");
                //==========//
                SetPVarInt(playerid, "Bank", GetPVarInt(playerid, "Bank")-amount);
                SetPVarInt(targetid, "Bank", GetPVarInt(targetid, "Bank")+amount);
				OnPlayerDataSave(playerid);
				OnPlayerDataSave(targetid);
                //==========//
            	format(string, sizeof(string), "* %s wired $%d to %s.", PlayerName(playerid), amount, PlayerName(targetid));
				PayLog(string);
				SetPVarInt(playerid, "Delay", GetCount()+2000); SetPVarInt(targetid, "Delay", GetCount()+2000);
   			}
   			else SendClientMessage(playerid,COLOR_GREY,"You are not close enough to that player!");
		}
		else SendClientMessage(playerid, COLOR_GREY, "You cannot pay to yourself.");
	}
	return 1;
}
//============================================//
ALTCOMMAND:w->whisper;
COMMAND:whisper(playerid, params[])
{
	new text[128],targetid,string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "us[128]", targetid, text)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /(w)hisper {FFFFFF}[playerid] [text]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") != 1) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_LIGHTRED, "You are currently muted!");
	    if (playerid == targetid) return SendClientMessage(playerid, COLOR_GREY, "You cannot whisper to yourself.");
		if(IsPlayerConnected(targetid))
		{
		    if(PlayerToPlayer(playerid,targetid,5.0))
   			{
   			    format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
	    	    format(giveplayer, sizeof(giveplayer), "%s", PlayerNameEx(targetid));
      		    GiveNameSpace(sendername);
        	    GiveNameSpace(giveplayer);
        	    format(string, sizeof(string), "*** %s whispers something to %s.", sendername, giveplayer);
        	    SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 10000);
		        format(string, sizeof(string), "%s whispers %s", sendername, text);
				SendClientMessage(targetid,  COLOR_YELLOW, string);
				SendClientMessage(playerid,  COLOR_YELLOW, string);
   			}
   			else SendClientMessage(playerid,COLOR_GREY,"You are not close enough to that player!");
		}
	}
	return 1;
}
//============================================//
ALTCOMMAND:p->pm;
COMMAND:pm(playerid, params[])
{
	new text[128],targetid,string[255],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "us[128]", targetid, text)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /(p)m {FFFFFF}[playerid] [text]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") != 1) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (playerid == targetid) return SendClientMessage(playerid, COLOR_GREY, "You cannot pm yourself.");
	    if(GetPVarInt(playerid, "Admin") == 0 && GetPVarInt(targetid, "TogPM") == 1) return SendClientMessage(playerid,COLOR_GREY,"Players Private Messages are currently blocked.");
	    if(GetPVarInt(playerid, "Admin") == 0 && PlayerInfo[targetid][pBlockPM][playerid] == 1) return SendClientMessage(playerid,COLOR_GREY,"This player has disabled Private Chats from you.");
	    if(GetPVarInt(playerid, "Admin") == 0 && PlayerInfo[playerid][pBlockPM][targetid] == 1) return SendClientMessage(playerid,COLOR_GREY,"You have disabled Private Chats with this player.");
	    if(GetPVarInt(playerid, "TogPM") == 1 && GetPVarInt(playerid, "Admin") == 0) return error(playerid, "YOUR private messages are blocked.");
	    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_LIGHTRED, "You are currently muted!");
		if(IsPlayerConnected(targetid))
		{
		    if(GetPVarInt(targetid, "Admin") > 0 && GetPVarInt(targetid, "Admin") <= 9 && GetPVarInt(targetid, "AdminDuty") == 1 && GetPVarInt(playerid, "APMWRN") == 0)
		    {
		        SetPVarString(playerid, "APMMSG", text);
		        SetPVarInt(playerid, "APMID", targetid);
		        ShowPlayerDialog(playerid, 206, DIALOG_STYLE_MSGBOX, "PM Warning", "IMPORTANT; Administrators are usually very busy, and it is important to not spam them with useless PM's while on duty\nAre you sure you want to send this PM?", "Yes", "No");
		    }
		    else
		    {
	   		    format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
		    	format(giveplayer, sizeof(giveplayer), "%s", PlayerName(targetid));
	      		GiveNameSpace(sendername);
	        	GiveNameSpace(giveplayer);
				format(string, sizeof(string), "(( PM from [%d] %s: %s ))", playerid, sendername, text);
				SendClientMessageEx(targetid,  0xF9F900FF, string);
				format(string, sizeof(string), "(( PM sent to [%d] %s: %s ))", targetid, giveplayer, text);
				SendClientMessageEx(playerid,  0xE5C43EAA, string);
				PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
				format(string, sizeof(string), "(( %s[%d] sent %s[%d]: %s ))", sendername, playerid, giveplayer, targetid, text);
				ShowPMs(string);
				SeePM(playerid, string);
				SeePM(targetid, string);				
			}
		}
	}
	return 1;
}
//============================================//
COMMAND:blocklist(playerid, params[])
{
	new string[128];
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "DonateRank") >= 1)
	{
	    SendClientMessage(playerid, COLOR_GREY, "People You Blocked:");
	    foreach(new i : Player)
	    {
	        if(PlayerInfo[playerid][pBlockPM][i] == 1)
	        {
	            format(string, sizeof(string), "** ID: %d ** %s", i, PlayerName(i));
				SendClientMessage(playerid, COLOR_GREY, string);
	        }
	    }
    }
    else
	{
	    SendClientMessage(playerid, COLOR_LIGHTRED, "WARNING: You must be a donater to use this.");
	}
	return 1;
}
//============================================//
COMMAND:blockpm(playerid, params[])
{
	new targetid;
	if(sscanf(params, "ui", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /blockpm {FFFFFF}[playerid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_LIGHTRED, "You are currently muted!");
	    if(GetPVarInt(playerid, "DonateRank") == 0) return SendClientMessage(playerid,COLOR_GREY,"You need to be a Donater to use this.");
	    if (playerid == targetid) return SendClientMessage(playerid, COLOR_GREY, "You cannot block to yourself.");
		if(IsPlayerConnected(targetid))
		{
			switch(PlayerInfo[playerid][pBlockPM][targetid])
			{
			    case 0:
			    {
					SendClientMessage(playerid,COLOR_GREY,"You now block PM's from this person (/blocklist, /blockall, /unblockall).");
			        PlayerInfo[playerid][pBlockPM][targetid] = 1;
			    }
			    case 1:
			    {
			        SendClientMessage(playerid,COLOR_GREY,"You now Un-blocked PM's from this person.");
			        PlayerInfo[playerid][pBlockPM][targetid] = 0;
			    }
			}
		}
	}
	return 1;
}
//============================================//
COMMAND:blockall(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "DonateRank") >= 1)
	{
	    for(new i = 0; i < 301; i++)
	    {
	        PlayerInfo[playerid][pBlockPM][i] = 1;
	    }
	    SendClientMessage(playerid,COLOR_GREY, "Blocked all users from PMing.");
    }
    else
	{
	    SendClientMessage(playerid, COLOR_LIGHTRED, "WARNING: You must be a donater to use this.");
	}
	return 1;
}
//============================================//
COMMAND:unblockall(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "DonateRank") >= 1)
	{
	    for(new i = 0; i < 301; i++)
	    {
	        PlayerInfo[playerid][pBlockPM][i] = 0;
	    }
	    SendClientMessage(playerid,COLOR_GREY, "Un-Blocked all users from PMing.");
    }
    else
	{
	    SendClientMessage(playerid, COLOR_LIGHTRED, "WARNING: You must be a donater to use this.");
	}
	return 1;
}
//============================================//
COMMAND:appearance(playerid, params[])
{
    if(GetPVarInt(playerid, "Delay") > GetCount()) return SendClientMessage(playerid, COLOR_LIGHTRED, "You must wait before performing this command!");
	SetPVarInt(playerid, "Delay", GetCount()+2000);
	new text[128], line;
	if(strcmp(PlayerInfo[playerid][pDescribe], "None", true) == -1 && strcmp(PlayerInfo[playerid][pDescribe2], "None", true) == -1)
	{
	    SendClientMessage(playerid, COLOR_LIGHTRED, "Appearance disabled.");
		strmid(PlayerInfo[playerid][pDescribe], "None", 0, strlen("None"), 255);
		strmid(PlayerInfo[playerid][pDescribe2], "None", 0, strlen("None"), 255);
		return true;
	}
	if(sscanf(params, "is[128]", line, text)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /appearance [line (1-2)] [text]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(strlen(text) > 128) return SendClientMessage(playerid, COLOR_WHITE, "Appearance is too long. (128 characters max.)");
	    if(line < 1 || line > 2) return SendClientMessage(playerid, COLOR_GREY, "Can not go under 1 or above 2.");
		new query[234];
	    switch(line)
	    {
	        case 1: 
			{
				format(PlayerInfo[playerid][pDescribe], 128, "%s", text);
				SendClientMessage(playerid, COLOR_LIGHTRED, "Appearance line (1) added.");
				new desc[128];
				mysql_real_escape_string(PlayerInfo[playerid][pDescribe], desc);
				mysql_format(handlesql, query, sizeof(query), "UPDATE accounts SET Describe1='%s' WHERE Name='%s'", desc, PlayerInfo[playerid][pUsername]);
				mysql_tquery(handlesql, query);
			}
	        case 2:
	        {
	            if(strcmp(PlayerInfo[playerid][pDescribe], "None", true) == 0) return SendClientMessage(playerid, COLOR_WHITE, "You need to have line (1) used first.");
				format(PlayerInfo[playerid][pDescribe2], 128, "%s", text);
				SendClientMessage(playerid, COLOR_LIGHTRED, "Appearance line (2) added.");
				new desc[128];
				mysql_real_escape_string(PlayerInfo[playerid][pDescribe2], desc);
				mysql_format(handlesql, query, sizeof(query), "UPDATE accounts SET Describe2='%s' WHERE Name='%s'", desc, PlayerInfo[playerid][pUsername]);
				mysql_tquery(handlesql, query);
			}
		}
	}
	return 1;
}
//============================================//
COMMAND:describe(playerid, params[])
{
	new targetid,string[128],sendername[MAX_PLAYER_NAME], stext[10];
	if(sscanf(params, "i", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /describe [playerid/maskid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    new found = 0, type = 0;
		if(!IsPlayerConnected(targetid))
		{
		    foreach(new i : Player)
	        {
	            if(GetPVarInt(i, "MaskUse") == 1 && GetPVarInt(i, "MaskID") == targetid)
	            {
	                targetid=i;
	                found++;
	                type=1;
	            }
	        }
	        if(found == 0) return SendClientMessage(playerid,COLOR_WHITE,"There is no-one online with that playerid or maskid.");
		}
        if(type == 0) format(sendername, sizeof(sendername), "%s", PlayerName(targetid));
        else format(sendername, sizeof(sendername), "%s", PlayerNameEx(targetid));
		GiveNameSpace(sendername);
		format(string, sizeof(string), "%s's appearance:", sendername);
		SendClientMessage(playerid,COLOR_WHITE,string);
		switch (GetPVarInt(targetid, "Sex"))
		{
	        case 1: stext = "Male";
	        case 2: stext = "Female";
		}
		format(string, sizeof(string), "Age: %d | Sex: %s.", GetPVarInt(targetid, "Age"), stext);
		SendClientMessage(playerid,COLOR_WHITE,string);
		format(string, sizeof(string), "%s.", PlayerInfo[targetid][pDescribe]);
		if(strcmp(PlayerInfo[targetid][pDescribe], "None", true) == 0) {}
		else SendClientMessage(playerid,COLOR_PURPLE,string);
		format(string, sizeof(string), "%s.", PlayerInfo[targetid][pDescribe2]);
		if(strcmp(PlayerInfo[targetid][pDescribe2], "None", true) == 0) {}
		else SendClientMessage(playerid,COLOR_PURPLE,string);
		if(GetPVarInt(targetid, "DrugTime") >= 1) SendClientMessage(playerid,COLOR_PURPLE,"Would appear to consumed narcotics.");
	}
	return 1;
}
//============================================//
COMMAND:give(playerid, params[])
{
	new type[128],amount,targetid,string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "s[128]iI(-1)", type, targetid, amount)) {
		SendClientMessage(playerid, -1, "/give [usage]");
		SendClientMessage(playerid, COLOR_GREY, "Weapon | Armour | Carkey | Rentkey | Ciggy |");
		SendClientMessage(playerid, COLOR_GREY, "Beer | Wine | Acid | Cocaine | Crystal |");
		SendClientMessage(playerid, COLOR_GREY, "Ecstasy | Meth | Heroin | Cannabis | Crack | Materials");
	}
	else
	{
	    if(GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(targetid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while the player dead.");
	    if(GetPVarInt(targetid, "Mute") == 1) return SendClientMessage(playerid,COLOR_LIGHTRED,"WARNING: The player is currently muted.");
	    if(GetPVarInt(targetid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "The player is not able to use this.");
	    if(GetPVarInt(playerid, "Delay") > GetCount()) return SendClientMessage(playerid, COLOR_LIGHTRED, "You must wait before performing this command!");
		new found = 0;
		if(!IsPlayerConnected(targetid))
		{
		    foreach(new i : Player)
	        {
	            if(GetPVarInt(i, "MaskUse") == 1 && GetPVarInt(i, "MaskID") == targetid)
	            {
	                targetid=i;
	                found++;
	            }
	        }
	        if(found == 0) return SendClientMessage(playerid,COLOR_WHITE,"There is no-one online with that playerid or maskid.");
		}
		if(playerid != targetid)
		{
		    if(PlayerToPlayer(playerid,targetid,3.0))
   			{
   			    if(strcmp(type, "weapon", true) == 0)
   			    {
   			        if(GetPVarInt(playerid, "Member") == 1 && !IsACop(targetid)) return SendClientMessage(playerid, COLOR_GREY ,"LSPD armour can not be shared out of the department.");
   			        if(GetPVarInt(playerid, "Member") == 8 && !IsACop(targetid)) return SendClientMessage(playerid, COLOR_GREY ,"Government armoury can not be shared out of the department.");
   			        if(GetPVarInt(targetid, "ConnectTime") < 8) return error(playerid, "Player doesn't have 8 hours played.");
   			        if(PlayerInfo[playerid][pPlayerWeapon] == 0) return SendClientMessage(playerid, COLOR_GREY ,"You don't have a weapon equiped!");
   			        if(PlayerInfo[targetid][pPlayerWeapon] > 0) return SendClientMessage(playerid, COLOR_GREY ,"This player already has a weapon equiped.");
    				format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
       				format(giveplayer, sizeof(giveplayer), "%s", PlayerNameEx(targetid));
		        	GiveNameSpace(sendername);
       	        	GiveNameSpace(giveplayer);
       	        	PlayerPlaySound(targetid, 1052, 0.0, 0.0, 0.0);
       	        	PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
					format(string, sizeof(string), "*** %s gives %s %s to %s.", sendername, CheckSex(playerid), PrintIName(PlayerInfo[playerid][pPlayerWeapon]), giveplayer);
    				ProxDetector(30.0, playerid, string, COLOR_PURPLE);
    				WepLog(string);
					PlayerInfo[targetid][pPlayerWeapon] = PlayerInfo[playerid][pPlayerWeapon];
    				PlayerInfo[targetid][pPlayerAmmo] = PlayerInfo[playerid][pPlayerAmmo];
					PlayerInfo[targetid][pSerial] = PlayerInfo[playerid][pSerial];
					PlayerInfo[targetid][pAmmoType] = PlayerInfo[playerid][pAmmoType];
					if(PlayerInfo[playerid][pPlayerAmmo] > 0) GivePlayerWeaponEx(targetid, PlayerInfo[playerid][pPlayerWeapon], PlayerInfo[playerid][pPlayerAmmo]), CallRemoteFunction("LoadHolsters","i",targetid);
					//==========//
    				PlayerInfo[playerid][pPlayerWeapon] = 0;
    				PlayerInfo[playerid][pPlayerAmmo] = 0;
					PlayerInfo[playerid][pSerial] = 0;
					PlayerInfo[playerid][pAmmoType] = 0;
					ResetPlayerWeaponsEx(playerid);
					//==========//
					SetPVarInt(playerid, "Delay", GetCount()+2000); SetPVarInt(targetid, "Delay", GetCount()+2000);
	        	}
	        	else if(strcmp(type, "armour", true) == 0)
   			    {
   			        new Float:PlayersArmour;
   			        GetPlayerArmour(playerid,PlayersArmour);
   			        if(PlayersArmour <= 1.0) return SendClientMessage(playerid, COLOR_GREY, "You do not have any kevlar to give.");
					if(GetPVarInt(playerid, "Member") == 1 && GetPVarInt(targetid, "Member") != 1) return SendClientMessage(playerid, COLOR_GREY ,"LSPD armour can not be shared out of the department.");
    				format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
       				format(giveplayer, sizeof(giveplayer), "%s", PlayerNameEx(targetid));
		        	GiveNameSpace(sendername);
       	        	GiveNameSpace(giveplayer);
       	        	PlayerPlaySound(targetid, 1052, 0.0, 0.0, 0.0);
       	        	PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
					format(string, sizeof(string), "*** %s gives %s kevlar to %s.", sendername, CheckSex(playerid), giveplayer);
    				ProxDetector(30.0, playerid, string, COLOR_PURPLE);
 					format(string, sizeof(string), "AdmWarn: %s has given %s a %.1f kevlar.", PlayerName(playerid), PlayerName(targetid), PlayersArmour);
       				if(PlayersArmour >= 50.0) SendAdminMessage(COLOR_YELLOW,string);
       				SetPlayerArmourEx(playerid, 0.0);
       				SetPlayerArmourEx(targetid, PlayersArmour);
					SetPVarInt(playerid, "Delay", GetCount()+2000); SetPVarInt(targetid, "Delay", GetCount()+2000);
	        	}
   			    else if(strcmp(type, "carkey", true) == 0)
   			    {
					SetPVarInt(playerid, "LendKeysTo", targetid);
					new query[100];
					mysql_format(handlesql, query, sizeof(query), "SELECT `Model` FROM `vehicles` WHERE `Owner` = '%e';", PlayerInfo[playerid][pUsername]);
					mysql_tquery(handlesql, query, "OnLendKeys", "i", playerid);
				    SetPVarInt(playerid, "Delay", GetCount()+2000); SetPVarInt(targetid, "Delay", GetCount()+2000);
   			    }
   			    else if(strcmp(type, "rentkey", true) == 0)
   			    {
   			        if(GetPVarInt(playerid, "RentKey") == 0) return SendClientMessage(playerid, COLOR_GREY, "You do not rent a vehicle.");
   			        if(GetPVarInt(targetid, "RentKey") != 0) return SendClientMessage(playerid, COLOR_GREY, "That player already rents a vehicle.");
   			        format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
	    	        format(giveplayer, sizeof(giveplayer), "%s", PlayerNameEx(targetid));
      		        GiveNameSpace(sendername);
        	        GiveNameSpace(giveplayer);
        	        PlayerPlaySound(targetid, 1052, 0.0, 0.0, 0.0);
        	        PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
        	        SetPVarInt(targetid, "RentKey", GetPVarInt(playerid, "RentKey"));
        	        SetPVarInt(playerid, "RentKey", 0);
        	        format(string, sizeof(string),"You gave %s your %s.", giveplayer, type);
        	        SendClientMessage(playerid, COLOR_WHITE, string);
        	        format(string, sizeof(string),"%s gave you %s %s.", sendername, CheckSex(playerid), type);
        	        SendClientMessage(targetid, COLOR_WHITE, string);
				    SetPVarInt(playerid, "Delay", GetCount()+2000); SetPVarInt(targetid, "Delay", GetCount()+2000);
   			    }
   			    else if(strcmp(type, "ciggy", true) == 0)
   			    {
				    if(GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_SMOKE_CIGGY) return SendClientMessage(playerid, COLOR_GREY, "You do not have a ciggy.");
				    if(GetPlayerSpecialAction(targetid) == SPECIAL_ACTION_SMOKE_CIGGY) return SendClientMessage(playerid, COLOR_GREY, "That player already has a ciggy.");
   			        format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
	    	        format(giveplayer, sizeof(giveplayer), "%s", PlayerNameEx(targetid));
      		        GiveNameSpace(sendername);
        	        GiveNameSpace(giveplayer);
        	        PlayerPlaySound(targetid, 1052, 0.0, 0.0, 0.0);
        	        PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
        	        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        	        SetPlayerSpecialAction(targetid,SPECIAL_ACTION_SMOKE_CIGGY);
        	        SendClientMessage(targetid,COLOR_WHITE,"Type (/ciggy) to place your ciggy on your mouth or hand.");
        	        format(string, sizeof(string),"You gave %s your %s.", giveplayer, type);
        	        SendClientMessage(playerid, COLOR_WHITE, string);
        	        format(string, sizeof(string),"%s gave you %s %s.", sendername, CheckSex(playerid), type);
        	        SendClientMessage(targetid, COLOR_WHITE, string);
				    SetPVarInt(playerid, "Delay", GetCount()+2000); SetPVarInt(targetid, "Delay", GetCount()+2000);
   			    }
   			    else if(strcmp(type, "beer", true) == 0)
   			    {
				    if(GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DRINK_BEER) return SendClientMessage(playerid, COLOR_GREY, "You do not have a beer bottle.");
				    if(GetPlayerSpecialAction(targetid) == SPECIAL_ACTION_DRINK_BEER) return SendClientMessage(playerid, COLOR_GREY, "That player already has a beer bottle.");
   			        format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
	    	        format(giveplayer, sizeof(giveplayer), "%s", PlayerNameEx(targetid));
      		        GiveNameSpace(sendername);
        	        GiveNameSpace(giveplayer);
        	        PlayerPlaySound(targetid, 1052, 0.0, 0.0, 0.0);
        	        PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
        	        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        	        SetPlayerSpecialAction(targetid,SPECIAL_ACTION_DRINK_BEER);
        	        format(string, sizeof(string),"You gave %s your %s.", giveplayer, type);
        	        SendClientMessage(playerid, COLOR_WHITE, string);
        	        format(string, sizeof(string),"%s gave you %s %s.", sendername, CheckSex(playerid), type);
        	        SendClientMessage(targetid, COLOR_WHITE, string);
				    SetPVarInt(playerid, "Delay", GetCount()+2000); SetPVarInt(targetid, "Delay", GetCount()+2000);
   			    }
   			    else if(strcmp(type, "wine", true) == 0)
   			    {
				    if(GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DRINK_WINE) return SendClientMessage(playerid, COLOR_GREY, "You do not have a wine bottle.");
				    if(GetPlayerSpecialAction(targetid) == SPECIAL_ACTION_DRINK_WINE) return SendClientMessage(playerid, COLOR_GREY, "That player already has a wine bottle.");
   			        format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
	    	        format(giveplayer, sizeof(giveplayer), "%s", PlayerNameEx(targetid));
      		        GiveNameSpace(sendername);
        	        GiveNameSpace(giveplayer);
        	        PlayerPlaySound(targetid, 1052, 0.0, 0.0, 0.0);
        	        PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
        	        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
        	        SetPlayerSpecialAction(targetid,SPECIAL_ACTION_DRINK_WINE);
        	        format(string, sizeof(string),"You gave %s your %s.", giveplayer, type);
        	        SendClientMessage(playerid, COLOR_WHITE, string);
        	        format(string, sizeof(string),"%s gave you %s %s.", sendername, CheckSex(playerid), type);
        	        SendClientMessage(targetid, COLOR_WHITE, string);
				    SetPVarInt(playerid, "Delay", GetCount()+2000); SetPVarInt(targetid, "Delay", GetCount()+2000);
   			    }
   			    else if(strcmp(type, "acid", true) == 0 || strcmp(type, "cocaine", true) == 0 ||
				strcmp(type, "crystal", true) == 0 || strcmp(type, "ecstasy", true) == 0 ||
				strcmp(type, "meth", true) == 0 || strcmp(type, "heroin", true) == 0 ||
				strcmp(type, "cannabis", true) == 0 || strcmp(type, "crack", true) == 0)
   			    {
					new itemid = 500;
					//==========//
					if(strcmp(type, "acid", true) == 0) { itemid = 500; }
					else if(strcmp(type, "cocaine", true) == 0) { itemid = 501; }
					else if(strcmp(type, "crystal", true) == 0) { itemid = 502; }
					else if(strcmp(type, "ecstasy", true) == 0) { itemid = 503; }
					else if(strcmp(type, "meth", true) == 0) { itemid = 504; }
					else if(strcmp(type, "pcp", true) == 0) { itemid = 505; }
					else if(strcmp(type, "cannabis", true) == 0) { itemid = 506; }
					else if(strcmp(type, "crack", true) == 0) { itemid = 507; }
					//==========//
   			        if(amount == (-1))
					{
					    format(string, sizeof(string),"USAGE: /give {FFFFFF}[%s] [playerid] [amount]", type);
					    SendClientMessage(playerid, COLOR_GREY, string);
					    return true;
					}
   			        if(amount < 1 || amount > 50) return SendClientMessage(playerid, COLOR_GREY, "Can't go under 1 or above 50.");
   			        if (!CheckInvItem(playerid, itemid)) return SendClientMessage(playerid, COLOR_WHITE, "You don't have this item!");
   			        new slot = -1;
   			        for(new p = 0; p < MAX_INV_SLOTS; p++)
			        {
			            if(PlayerInfo[playerid][pInvItem][p] == itemid)
			            {
							if(PlayerInfo[playerid][pInvQ][p] > amount) {
								slot = p;
								break;
							}
				        }
			        }
					if(slot == -1) return SendClientMessage(playerid, COLOR_LIGHTRED, "Insufficient amount!");
					if(CheckInv(targetid) == 1) {
			            GiveInvItem(targetid, itemid, amount, 0);
			        } else return SendClientMessage(playerid, COLOR_GREY, "This players inventory is full!");
					RemoveInvItem(playerid, itemid, amount, slot);
   			        format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
	    	        format(giveplayer, sizeof(giveplayer), "%s", PlayerNameEx(targetid));
      		        GiveNameSpace(sendername);
        	        GiveNameSpace(giveplayer);
        	        PlayerPlaySound(targetid, 1052, 0.0, 0.0, 0.0);
        	        PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
        	        format(string, sizeof(string),"You gave %s %d grams of %s.", giveplayer, amount, type);
        	        SendClientMessage(playerid, COLOR_WHITE, string);
        	        format(string, sizeof(string),"%s gave you %d grams of %s.", sendername, amount, type);
        	        SendClientMessage(targetid, COLOR_WHITE, string);
				    SetPVarInt(playerid, "Delay", GetCount()+2000); SetPVarInt(targetid, "Delay", GetCount()+2000);
   			    }
   			    else if(strcmp(type, "materials", true) == 0)
   			    {
					if(amount == (-1)) return scm(playerid, COLOR_GREEN, "USAGE: /give materials {FFFFFF} [targetid] [amount]");
					if(amount <= 0) return scm(playerid, COLOR_GREEN, "USAGE: /give materials {FFFFFF} [targetid] [amount]");
					if(amount >= 99999999) return scm(playerid, COLOR_GREEN, "USAGE: /give materials {FFFFFF} [targetid] [amount]");
					if(amount > PlayerInfo[playerid][pMaterials]) return scm(playerid, COLOR_GREY, "You don't have that many materials!");
					PlayerInfo[playerid][pMaterials] = PlayerInfo[playerid][pMaterials] - amount;
					PlayerInfo[targetid][pMaterials] = PlayerInfo[targetid][pMaterials] + amount;
					SaveCrafting(playerid);
					SaveCrafting(targetid);
					format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
	    	        format(giveplayer, sizeof(giveplayer), "%s", PlayerNameEx(targetid));
      		        GiveNameSpace(sendername);
        	        GiveNameSpace(giveplayer);
        	        PlayerPlaySound(targetid, 1052, 0.0, 0.0, 0.0);
        	        PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
					format(string, sizeof(string), "*** %s has given %s some materials.", sendername, giveplayer);
					ProxDetector(30.0, playerid, string, COLOR_PURPLE);
        	        format(string, sizeof(string),"You gave %s %d materials.", giveplayer, amount);
        	        SendClientMessage(playerid, COLOR_WHITE, string);
        	        format(string, sizeof(string),"%s gave you %d materials.", sendername, amount);
        	        SendClientMessage(targetid, COLOR_WHITE, string);
				    SetPVarInt(playerid, "Delay", GetCount()+2000); SetPVarInt(targetid, "Delay", GetCount()+2000);
   			    }
   			    else cmd_give(playerid, "");
   			}
   			else SendClientMessage(playerid,COLOR_GREY,"You are not close enough to that player!");
		}
		else SendClientMessage(playerid, COLOR_GREY, "You cannot give stuff to yourself.");
	}
	return 1;
}
//============================================//
COMMAND:id(playerid, params[])
{
	new targetid,string[128],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "u", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /id {FFFFFF}[playerid/PartOfName]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") != 1) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(IsPlayerConnected(targetid))
	    {
	        format(giveplayer, sizeof(giveplayer), "%s", PlayerName(targetid));
	        GiveNameSpace(giveplayer);
	        format(string, sizeof(string), "ID: (%d) %s - Hours Played: %d - Ping: %d",targetid,giveplayer,GetPVarInt(targetid, "ConnectTime"),GetPlayerPing(targetid));
		    SendClientMessage(playerid, COLOR_GREY, string);
		}
		else SendClientMessage(playerid, COLOR_GREY, "User was not found!");
	}
	return 1;
}
//============================================//
COMMAND:clearchat(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") != 1) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    ClearChatbox(playerid, 20);
	return 1;
}
//============================================//
COMMAND:try(playerid, params[])
{
	new text[128],string[128],sendername[MAX_PLAYER_NAME];
	if(sscanf(params, "s[128]", text)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /try {FFFFFF}[text] {FF0000}(This is for your own character only!)");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") != 1) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_LIGHTRED, "You are currently muted!");
		format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
		GiveNameSpace(sendername);
    	new coin = random(2)+1,coinname[20];
    	switch(coin)
    	{
    	    case 1: coinname = "succeeds";
    	    default: coinname = "fails";
    	}
    	format(string, sizeof(string), "*** %s tries to %s and %s.", sendername,text,coinname);
		ProxDetector(10.0, playerid, string, COLOR_PURPLE);
	}
	return 1;
}
//============================================//
COMMAND:coin(playerid, params[])
{
	new string[128],sendername[MAX_PLAYER_NAME];
    if (GetPVarInt(playerid, "PlayerLogged") != 1) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
	GiveNameSpace(sendername);
	new coin = random(2)+1, coinname[20];
	if(coin == 1) { coinname = "head"; }
	else { coinname = "tail"; }
    format(string, sizeof(string), "*** %s flips a coin and lands on a %s.", sendername,coinname);
	ProxDetector(10.0, playerid, string, COLOR_PURPLE);
	return 1;
}
//============================================//
COMMAND:dice(playerid, params[])
{
	new string[128],sendername[MAX_PLAYER_NAME];
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_LIGHTRED, "You are currently muted!");
    if (!CheckInvItem(playerid, 400)) return SendClientMessage(playerid, COLOR_WHITE, "You do not have any dice.");
    format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
    GiveNameSpace(sendername);
    new dice = random(6)+1;
    format(string, sizeof(string), "*** %s throws %s dice that lands on %d.", sendername, CheckSex(playerid), dice);
	ProxDetector(5.0, playerid, string, COLOR_PURPLE);
	return 1;
}
//============================================//
COMMAND:time(playerid, params[])
{
    new string[256],year,month,day,mtext[50],Hour, Minute, Second;
    if (GetPVarInt(playerid, "PlayerLogged") != 1) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while dead!");
	getdate(year, month, day), gettime(Hour, Minute, Second);
	switch(month)
	{
		case 1: mtext = "January";
		case 2: mtext = "February";
		case 3: mtext = "March";
		case 4: mtext = "April";
		case 5: mtext = "May";
		case 6: mtext = "June";
		case 7: mtext = "July";
		case 8: mtext = "August";
		case 9: mtext = "September";
		case 10: mtext = "October";
		case 11: mtext = "November";
	    case 12: mtext = "December";
	}
	if(GetPVarInt(playerid, "Jailed") > 0)
	{
	    format(string, sizeof(string), "JailTime Left: %d seconds.", GetPVarInt(playerid, "JailTime"));
	    return GameTextForPlayer(playerid, string, 5000, 1);
	}
	if(!CheckInvItem(playerid, 404)) return SendClientMessage(playerid,COLOR_GREY,"You don't have a watch.");
	
	/*format(montxt, 25, "%d", month);
	if(month < 10) format(montxt, 25, "0%d", month);
	
	format(daytxt, 25, "%d", day);
	if(day < 10) format(daytxt, 25, "0%d", day);
	
	format(string, 256, "YYYY/MM/DD: %d/%s/%s", year, montxt, daytxt);
	scm(playerid, COLOR_GREY, string);*/
	
	if(Minute < 10) format(string, 256, "~y~OOC Time: ~w~%d:0%d", Hour, Minute);
	else format(string, 256, "~y~OOC Time: ~w~%d:%d", Hour, Minute);
	//scm(playerid, COLOR_GREY, string);
	
	if (GMMin < 10) format(string, 256, "%s~n~~b~IC Time: ~w~%d:0%d", string, GMHour, GMMin);
	else format(string, 256, "%s~n~~b~IC Time: ~w~%d:%d", string, GMHour, GMMin);
	//scm(playerid, COLOR_GREY, string);
	
	GameTextForPlayer(playerid, string, 5000, 1);
	
	format(string, 256, "Playtime: %d seconds | Next Payday: %d minutes.", GetPVarInt(playerid, "PlayTime"), 60-GetPVarInt(playerid, "PayDay"));
	scm(playerid, COLOR_LIGHTRED, string);
	
	ApplyAnimation(playerid,"COP_AMBIENT","Coplook_watch",4.1,0,0,0,0,0);
	return 1;
}
//============================================//
COMMAND:windows(playerid, params[])
{
    new string[128],sendername[MAX_PLAYER_NAME];
    new idcar = GetPlayerVehicleID(playerid);
    if (GetPVarInt(playerid, "PlayerLogged") != 1) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	if (!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "You must be in a vehicle to use this!");
	if (!IsAWindowCar(playerid)) return SendClientMessage(playerid, COLOR_GREY, "This vehicle does not possess windows");
	format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
	GiveNameSpace(sendername);
	switch(VehicleInfo[idcar][vWindows])
	{
    	case 0:
    	{
    		format(string, sizeof(string), "The %ss window is now [DOWN].", VehicleName[GetVehicleModel(idcar)-400]);
			SendClientMessage(playerid, COLOR_WHITE, string);
			VehicleInfo[idcar][vWindows] = 1;
			SetVehicleParamsCarWindows(idcar, 0, 0, 0, 0);
    	}
    	case 1:
    	{
    		format(string, sizeof(string), "The %ss window is now [UP].", VehicleName[GetVehicleModel(idcar)-400]);
			SendClientMessage(playerid, COLOR_WHITE, string);
			VehicleInfo[idcar][vWindows] = 0;
			SetVehicleParamsCarWindows(idcar, 1, 1, 1, 1);
    	}
    }
	return 1;
}
ALTCOMMAND:wi->windows;
//============================================//
COMMAND:lock(playerid, params[])
{
    new idcar = 0;
    if (GetPVarInt(playerid, "PlayerLogged") != 1) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "RentKey") != 0) idcar = GetPVarInt(playerid, "RentKey");
    if(GetPVarInt(playerid, "RouteVeh") >= 1 && idcar == 0) idcar = GetPVarInt(playerid, "RouteVeh");
	foreach(new car : Vehicle)
	{
	    if(CopInfo[car][Created] == 1 && idcar == 0)
	    {
		    if(strcmp(CopInfo[car][Owner], PlayerName(playerid), true) == 0)
			{
			    idcar = car;
		    }
	    }
	}
	if(idcar == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You don't have a rental vehicle, job vehicle, or faction vehicle spawned!");
	switch(VehicleInfo[idcar][vLock])
	{
    	case 0:
    	{
			VehicleInfo[idcar][vLock] = 1;
			GameTextForPlayer(playerid, "~w~Vehicle~n~~r~Locked", 4000, 3);
			PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
			foreach(new i : Player)
			{
			    SetVehicleParamsForPlayer(idcar,i,0,1);
			}
    	}
    	case 1:
    	{
			VehicleInfo[idcar][vLock] = 0;
			GameTextForPlayer(playerid, "~w~Vehicle~n~~g~Unlocked", 4000, 3);
			PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
			foreach(new i : Player)
			{
			    SetVehicleParamsForPlayer(idcar,i,0,0);
			}
    	}
    }
	return 1;
}
//============================================//
COMMAND:unrent(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") != 1) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while dead!");
	if(GetPVarInt(playerid, "RentKey") == 0) return SendClientMessage(playerid, COLOR_GREY, "You do not possess a rented vehicle.");
	if(VehicleInfo[GetPVarInt(playerid, "RentKey")][vType] != VEHICLE_RENTAL) return SendClientMessage(playerid, COLOR_GREY, "This vehicle is not a rentable vehicle.");
	GameTextForPlayer(playerid, "~w~You no longer rent a vehicle!", 5000, 3);
	DespawnVehicle(GetPVarInt(playerid, "RentKey"));
	DeletePVar(playerid, "RentKey");
	PlayerPlaySound(playerid, 1054, 0.0, 0.0, 0.0);
	return 1;
}
//============================================//
COMMAND:accept(playerid, params[])
{
	new type[128], string[128], sendername[MAX_PLAYER_NAME], giveplayer[MAX_PLAYER_NAME],
	Float:x, Float:y, Float:z, sn;
	if(sscanf(params, "s[128]I(-1)", type, sn)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /accept {FFFFFF}[death/drag/invite/shake/blindfold/refill/repair/sellto/hsellto/bsellto/live/rentoffer]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") != 1) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_LIGHTRED, "You are currently muted!");
   	    if(strcmp(type, "death", true) == 0)
   	    {
   	        if (GetPVarInt(playerid, "Dead") != 2) return SendClientMessage(playerid, COLOR_WHITE, "You are not dead.");
   	        if(GetPVarInt(playerid, "DeathTime") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait before accepting death.");
   	        if(GetPVarInt(playerid, "JailTime") >= 1) return SendClientMessage(playerid, COLOR_WHITE, "You cannot accept death inside the prison, you must wait for a gaurd or prisoner to RP with you!");
   	        format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
	        GiveNameSpace(sendername);
   	        format(string, sizeof(string), "%s has accepted death.",sendername);
   	        ProxDetector(20.0, playerid, string, COLOR_WHITE);
			CreateCorpse(playerid);
   	        SetPVarInt(playerid, "Drag", INVALID_MAXPL);
   	        SetPVarInt(playerid, "Cuffed", 0);
   	        SetPVarInt(playerid, "CuffedTime", 0);
            ResetPlayerWeaponsEx(playerid);
	        ClearChatbox(playerid,50);
	        DeletePVar(playerid, "FadeToDeath");
	        ClearChatbox(playerid, 10);
   	        /*TextDrawHideForPlayer(playerid, MoneyDraw[playerid]);
   	        TextDrawHideForPlayer(playerid, MoneyDraw2);
   	        TextDrawHideForPlayer(playerid, LocationDraw[playerid]);*/
   	        TextDrawHideForPlayer(playerid, BlindDraw);
   	        DeletePVar(playerid,"Blinded");
			for(new p = 0; p < MAX_INV_SLOTS; p++)
			{
			    if(PlayerInfo[playerid][pInvItem][p] != 401 && PlayerInfo[playerid][pInvItem][p] != 402 && PlayerInfo[playerid][pInvItem][p] != 404 && PlayerInfo[playerid][pInvItem][p] != 405 && PlayerInfo[playerid][pInvItem][p])
			    {
					PlayerInfo[playerid][pInvItem][p]=0;
					PlayerInfo[playerid][pInvQ][p]=0;
					PlayerInfo[playerid][pInvEx][p]=0;
				}
			}
			CallRemoteFunction("FixInv", "i", playerid);
			DeathPlayer(playerid, "You need to rest to regain consciousness.");
			//OnPlayerSpawn(playerid); ITS BUGGED, PLEASE ARE STUCK AT THE HOSPITAL.
		}
   	    else if(strcmp(type, "invite", true) == 0)
   	    {
   	        if(GetPVarInt(playerid, "InviteOffer") != INVALID_MAXPL)
   	        {
   	            if(IsPlayerConnected(GetPVarInt(playerid, "InviteOffer")))
   	            {
					new targetid = GetPVarInt(playerid, "InviteOffer");
   	                format(sendername, sizeof(sendername), "%s", PlayerName(playerid)), format(giveplayer, sizeof(giveplayer), "%s", PlayerName(targetid));
      		        GiveNameSpace(sendername), GiveNameSpace(giveplayer);
        	        PlayerPlaySound(targetid, 1052, 0.0, 0.0, 0.0), PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
        	        SetPVarInt(playerid, "Member", GetPVarInt(targetid, "Member")), SetPVarInt(playerid, "Rank", 1);
        	        format(string, sizeof(string), "%s accepted your faction invite.", sendername);
        	        SendClientMessage(targetid,COLOR_GREY,string);
        	        format(string, sizeof(string), "You accepted %s's faction invite.", giveplayer);
        	        SendClientMessage(playerid,COLOR_GREY,string);
        	        SetPVarInt(playerid, "InviteOffer", INVALID_MAXPL);
   	            }
			    else SendClientMessage(playerid, COLOR_GREY, "The person who offered a invite is offline."), SetPVarInt(playerid, "InviteOffer", INVALID_MAXPL);
   	        }
   	        else SendClientMessage(playerid, COLOR_GREY, "You havent been offered for a invite.");
   	    }
   	    else if(strcmp(type, "drag", true) == 0)
   	    {
   	        if(GetPVarInt(playerid, "DragOffer") != INVALID_MAXPL)
   	        {
   	            if(IsPlayerConnected(GetPVarInt(playerid, "DragOffer")))
			    {
                    if(PlayerToPlayer(playerid,GetPVarInt(playerid, "DragOffer"),5.0) && GetPVarInt(playerid, "Dead") != 0)
                    {
			            format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
	    	            format(giveplayer, sizeof(giveplayer), "%s", PlayerNameEx(GetPVarInt(playerid, "DragOffer")));
      		            GiveNameSpace(sendername);
                        GiveNameSpace(giveplayer);
					    format(string, sizeof(string), "You accepted %s's drag offer.", giveplayer);
           		        SendClientMessage(playerid, COLOR_WHITE, string);
            	        format(string, sizeof(string), "%s has accepted your drag offer.", sendername);
            	        SendClientMessage(GetPVarInt(playerid, "DragOffer"), COLOR_LIGHTBLUE, string);
            	        format(string, sizeof(string), "*** %s starts to drag %s.", giveplayer, sendername);
    	                ProxDetector(30.0, GetPVarInt(playerid, "DragOffer"), string, COLOR_PURPLE);
    	                TogglePlayerControllableEx(playerid,false);
    	                SetPVarInt(playerid, "Drag", GetPVarInt(playerid, "DragOffer"));
			            SetPVarInt(playerid, "DragOffer", INVALID_MAXPL);
			        }
			        else SendClientMessage(playerid, COLOR_GREY, "You must be around the person who offered the drag."), SetPVarInt(playerid, "DragOffer", INVALID_MAXPL);
			    }
			    else SendClientMessage(playerid, COLOR_GREY, "The person who offered a drag is offline."), SetPVarInt(playerid, "DragOffer", INVALID_MAXPL);
   	        }
   	        else SendClientMessage(playerid, COLOR_GREY, "You havent been offered for a drag.");
   	    }
   	    else if(strcmp(type, "repair", true) == 0)
   	    {
   	        if(GetPVarInt(playerid, "RepairOffer") != INVALID_MAXPL)
   	        {
   	            if(IsPlayerConnected(GetPVarInt(playerid, "RepairOffer")))
			    {
			        if(GetPlayerMoneyEx(playerid) >= GetPVarInt(playerid, "RepairPrice"))
			        {
			            if(IsPlayerInAnyVehicle(playerid) && !IsNotAEngineCar(GetPlayerVehicleID(playerid)))
			            {
                            if(PlayerToPlayer(playerid, GetPVarInt(playerid, "RepairOffer"), 8.0))
                            {
			                    format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
	    	                    format(giveplayer, sizeof(giveplayer), "%s", PlayerNameEx(GetPVarInt(playerid, "RepairOffer")));
      		                    GiveNameSpace(sendername);
        	                    GiveNameSpace(giveplayer);
							    GivePlayerMoneyEx(playerid,-GetPVarInt(playerid, "RepairPrice"));
							    SetPVarInt(GetPVarInt(playerid, "RepairOffer"), "CheckEarn", GetPVarInt(playerid, "RepairPrice")+GetPVarInt(GetPVarInt(playerid, "RepairOffer"), "CheckEarn"));
							    format(string, sizeof(string), "*** Accepted %s's repair offer (( %s ))", giveplayer, sendername);
    	                        ProxDetector(30.0, playerid, string, COLOR_PURPLE);
							    format(string, sizeof(string), "You accepted %s a repair contract for $%d.", giveplayer, GetPVarInt(playerid, "RepairPrice"));
           		                SendClientMessage(playerid, COLOR_WHITE, string);
            	                format(string, sizeof(string), "%s has accepted your repair contract, $%d has been added to your paycheck.", sendername, GetPVarInt(playerid, "RepairPrice"));
            	                SendClientMessage(GetPVarInt(playerid, "RepairOffer"), COLOR_LIGHTBLUE, string);
            	                SetPVarInt(GetPVarInt(playerid, "RepairOffer"), "CheckEarn", GetPVarInt(GetPVarInt(playerid, "RepairOffer"), "CheckEarn")+GetPVarInt(playerid, "RepairPrice"));
            	                //==========//
								RepairVehicle(GetPlayerVehicleID(playerid));
            	                //==========//
            	                SetPVarInt(playerid, "RepairOffer", INVALID_MAXPL);
			                    SetPVarInt(playerid, "RepairPrice", 0);
			                }
			                else SendClientMessage(playerid, COLOR_GREY, "You must be around the person who offered the repair.");
			            }
			            else SendClientMessage(playerid, COLOR_GREY, "You are not inside a vehicle.");
			        }
			        else SendClientMessage(playerid, COLOR_GREY, "You cannot afford the price offered.");
			    }
			    else SendClientMessage(playerid, COLOR_GREY, "The person who offered a repair is offline."), SetPVarInt(playerid, "RepairOffer", INVALID_MAXPL);
   	        }
   	        else SendClientMessage(playerid, COLOR_GREY, "You havent been offered for a repair.");
   	    }
   	    else if(strcmp(type, "refill", true) == 0)
   	    {
   	        if(GetPVarInt(playerid, "RefillOffer") != INVALID_MAXPL)
   	        {
   	            if(IsPlayerConnected(GetPVarInt(playerid, "RefillOffer")))
			    {
			        if(GetPlayerMoneyEx(playerid) >= GetPVarInt(playerid, "RefillPrice"))
			        {
			            if(IsPlayerInAnyVehicle(playerid))
			            {
			                if(PlayerToPlayer(playerid, GetPVarInt(playerid, "RefillOffer"), 8.0))
                            {
			                    format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
	    	                    format(giveplayer, sizeof(giveplayer), "%s", PlayerNameEx(GetPVarInt(playerid, "RefillOffer")));
      		                    GiveNameSpace(sendername);
        	                    GiveNameSpace(giveplayer);
							    GivePlayerMoneyEx(playerid,-GetPVarInt(playerid, "RefillPrice"));
							    SetPVarInt(GetPVarInt(playerid, "RefillOffer"), "CheckEarn", GetPVarInt(playerid, "RefillPrice")+GetPVarInt(GetPVarInt(playerid, "RefillOffer"), "CheckEarn"));
							    format(string, sizeof(string), "*** Accepted %s's refill offer (( %s ))", giveplayer, sendername);
    	                        ProxDetector(30.0, playerid, string, COLOR_PURPLE);
							    format(string, sizeof(string), "You accepted %s a refill contract for $%d.", giveplayer, GetPVarInt(playerid, "RefillPrice"));
                                SendClientMessage(playerid, COLOR_WHITE, string);
            	                format(string, sizeof(string), "%s has accepted your refill contract, $%d has been added to your paycheck.", sendername, GetPVarInt(playerid, "RefillPrice"));
            	                SendClientMessage(GetPVarInt(playerid, "RefillOffer"), COLOR_LIGHTBLUE, string);
            	                SetPVarInt(GetPVarInt(playerid, "RepairOffer"), "CheckEarn", GetPVarInt(GetPVarInt(playerid, "RepairOffer"), "CheckEarn")+GetPVarInt(playerid, "RepairPrice"));
            	                VehicleInfo[GetPlayerVehicleID(playerid)][vFuel] = 100;
			                    SetPVarInt(playerid, "RefillOffer", INVALID_MAXPL);
			                    SetPVarInt(playerid, "RefillPrice", 0);
			                }
			                else SendClientMessage(playerid, COLOR_GREY, "You must be around the person who offered the refill.");
			            }
			            else SendClientMessage(playerid, COLOR_GREY, "You are not inside a vehicle.");
			        }
			        else SendClientMessage(playerid, COLOR_GREY, "You cannot afford the price offered.");
			    }
			    else SendClientMessage(playerid, COLOR_GREY, "The person who offered a refill is offline."), SetPVarInt(playerid, "RefillOffer", INVALID_MAXPL);
   	        }
   	        else SendClientMessage(playerid, COLOR_GREY, "You havent been offered for a refill.");
   	    }
   	    else if(strcmp(type, "taxi", true) == 0)
   	    {
   	        if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while dead!");
	        if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_LIGHTRED, "You are currently muted!");
   	        if (GetPVarInt(playerid, "Job") != 5) return SendClientMessage(playerid, COLOR_WHITE, "You are not a Taxi Driver.");
   	        if (GetPVarInt(playerid, "OnRoute") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not on route.");
   	        if (TaxiCall == INVALID_MAXPL) return SendClientMessage(playerid, COLOR_WHITE, "No taxi calls available.");
   	        format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
	    	format(giveplayer, sizeof(giveplayer), "%s", PlayerName(TaxiCall));
      		GiveNameSpace(sendername);
        	GiveNameSpace(giveplayer);
			format(string, sizeof(string), "~h~~y~You have accepted %s's call, location:[%s]!", giveplayer, GetPlayerArea(TaxiCall));
			SendClientMessage(playerid, COLOR_WHITE, string);
			SendClientMessage(TaxiCall, COLOR_YELLOW, "TXT: Your requested taxi will arrive shortly, Sender: 'LS Taxi Co.'.");
			PlayerPlaySound(TaxiCall, 1052, 0.0, 0.0, 0.0);
            GetPlayerPos(TaxiCall,x,y,z);
            SetPlayerCheckpoint(playerid,x,y,z,5.0);
            GameTextForPlayer(playerid, "~w~Taxi Caller~n~~r~Goto redmarker", 5000, 1);
		    TaxiCall = INVALID_MAXPL;
   	    }
   	    else if(strcmp(type, "mech", true) == 0)
   	    {
   	        if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while dead!");
	        if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_LIGHTRED, "You are currently muted!");
   	        if (GetPVarInt(playerid, "Job") != 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not a Mechanic.");
   	        if (GetPVarInt(playerid, "OnRoute") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not on route.");
   	        if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOR_GREY, "You must be in a vehicle driver to use this.");
   	        if (MechCall == INVALID_MAXPL) return SendClientMessage(playerid, COLOR_WHITE, "No mechanic calls available.");
   	        format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
	    	format(giveplayer, sizeof(giveplayer), "%s", PlayerName(MechCall));
      		GiveNameSpace(sendername);
        	GiveNameSpace(giveplayer);
			format(string, sizeof(string), "~h~~g~You have accepted %s's call, location:[%s]!", giveplayer, GetPlayerArea(MechCall));
			SendClientMessage(playerid, COLOR_WHITE, string);
			SendClientMessage(MechCall, COLOR_YELLOW, "TXT: Your requested towtruck will arrive shortly, Sender: 'LS Mechanic Co.'.");
			PlayerPlaySound(MechCall, 1052, 0.0, 0.0, 0.0);
            GetPlayerPos(MechCall,x,y,z);
            SetPlayerCheckpoint(playerid,x,y,z,5.0);
            GameTextForPlayer(playerid, "~w~Mechanic Caller~n~~r~Goto redmarker", 5000, 1);
		    MechCall = INVALID_MAXPL;
   	    }
   	    else if(strcmp(type, "blind", true) == 0)
   	    {
   	        if(GetPVarInt(playerid, "BlindOffer") != INVALID_MAXPL)
   	        {
   	            if(IsPlayerConnected(GetPVarInt(playerid, "BlindOffer")))
			    {
                    if(PlayerToPlayer(playerid,GetPVarInt(playerid, "BlindOffer"),8.0))
                    {
			            format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
	    	            format(giveplayer, sizeof(giveplayer), "%s", PlayerNameEx(GetPVarInt(playerid, "BlindOffer")));
      		            GiveNameSpace(sendername);
                        GiveNameSpace(giveplayer);
					    format(string, sizeof(string), "You accepted %s's blindfold.", giveplayer);
           		        SendClientMessage(playerid, COLOR_WHITE, string);
            	        format(string, sizeof(string), "%s has accepted your blindfold, (/unblind) to remove the blindfold.", sendername);
            	        SendClientMessage(GetPVarInt(playerid, "BlindOffer"), COLOR_LIGHTBLUE, string);
			            SetPVarInt(playerid, "BlindOffer", INVALID_MAXPL);
			            TextDrawShowForPlayer(playerid,BlindDraw);
			            SetPVarInt(playerid, "Blinded", 1);
			        }
			        else SendClientMessage(playerid, COLOR_GREY, "You must be around the person who offered the blind."), SetPVarInt(playerid, "BlindOffer", INVALID_MAXPL);
			    }
			    else SendClientMessage(playerid, COLOR_GREY, "The person who offered a blind is offline."), SetPVarInt(playerid, "BlindOffer", INVALID_MAXPL);
   	        }
   	        else SendClientMessage(playerid, COLOR_GREY, "You havent been offered for a blind.");
   	    }
   	    else if(strcmp(type, "divorce", true) == 0)
   	    {
   	        if(GetPVarInt(playerid, "DivorceOffer") != INVALID_MAXPL)
   	        {
   	            if(IsPlayerConnected(GetPVarInt(playerid, "DivorceOffer")))
			    {
                    if(PlayerToPlayer(playerid,GetPVarInt(playerid, "DivorceOffer"),8.0))
                    {
			            format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
	    	            format(giveplayer, sizeof(giveplayer), "%s", PlayerNameEx(GetPVarInt(playerid, "DivorceOffer")));
      		            GiveNameSpace(sendername);
                        GiveNameSpace(giveplayer);
                        strmid(PlayerInfo[playerid][pMarriedTo], "None", 0, strlen("None"), 255);
                        strmid(PlayerInfo[GetPVarInt(playerid, "DivorceOffer")][pMarriedTo], "None", 0, strlen("None"), 255);
					    format(string, sizeof(string), "You accepted %s's divorce.", giveplayer);
           		        SendClientMessage(playerid, COLOR_WHITE, string);
            	        format(string, sizeof(string), "%s has accepted your divorce.", sendername);
            	        SendClientMessage(GetPVarInt(playerid, "DivorceOffer"), COLOR_LIGHTBLUE, string);
			            SetPVarInt(playerid, "DivorceOffer", INVALID_MAXPL);
						OnPlayerDataSave(playerid);
						OnPlayerDataSave(GetPVarInt(playerid, "DivorceOffer"));
			        }
			        else SendClientMessage(playerid, COLOR_GREY, "You must be around the person who offered the divorce."), SetPVarInt(playerid, "DivorceOffer", INVALID_MAXPL);
			    }
			    else SendClientMessage(playerid, COLOR_GREY, "The person who offered a divorce is offline."), SetPVarInt(playerid, "DivorceOffer", INVALID_MAXPL);
   	        }
   	        else SendClientMessage(playerid, COLOR_GREY, "You haven't been asked for a divorce.");
   	    }
   	    else if(strcmp(type, "shake", true) == 0)
   	    {
   	        if(sn == (-1)) return SendClientMessage(playerid, COLOR_GREEN, "USAGE: /accept shake (1-8)");
   	        if(sn < 1 || sn > 8) return SendClientMessage(playerid, COLOR_GREEN, "USAGE: /accept shake (1-8)");
   	        if(GetPVarInt(playerid, "ShakeOffer") != INVALID_MAXPL)
   	        {
   	            if(IsPlayerConnected(GetPVarInt(playerid, "ShakeOffer")))
			    {
                    if(PlayerToPlayer(playerid,GetPVarInt(playerid, "ShakeOffer"),8.0))
                    {
                        SetPlayerToFacePlayer(playerid, GetPVarInt(playerid, "ShakeOffer"));
                        SetPlayerToFacePlayer(GetPVarInt(playerid, "ShakeOffer"), playerid);
			            format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
	    	            format(giveplayer, sizeof(giveplayer), "%s", PlayerNameEx(GetPVarInt(playerid, "ShakeOffer")));
      		            GiveNameSpace(sendername);
                        GiveNameSpace(giveplayer);
					    format(string, sizeof(string), "You accepted %s's handshake.", giveplayer);
           		        SendClientMessage(playerid, COLOR_WHITE, string);
            	        format(string, sizeof(string), "%s has accepted your handshake.", sendername);
            	        SendClientMessage(GetPVarInt(playerid, "ShakeOffer"), COLOR_LIGHTBLUE, string);
            	        new anim[128];
            	        switch(sn)
            	        {
            	            case 1: anim="hndshkaa";
            	            case 2: anim="hndshkba";
            	            case 3: anim="hndshkca";
            	            case 4: anim="hndshkcb";
            	            case 5: anim="hndshkda";
            	            case 6: anim="hndshkea";
            	            case 7: anim="hndshkfa";
            	            case 8: anim="prtial_hndshk_biz_01";
            	        }
            	        ApplyAnimation(playerid,"GANGS", anim,4.0,0,0,0,0,0);
			            ApplyAnimation(GetPVarInt(playerid, "ShakeOffer"), "GANGS", anim,4.0,0,0,0,0,0);
			            SetPVarInt(playerid, "ShakeOffer", INVALID_MAXPL);
			        }
			        else SendClientMessage(playerid, COLOR_GREY, "You must be around the person who offered the shake.");
			    }
			    else SendClientMessage(playerid, COLOR_GREY, "The person who offered a shake is offline."), SetPVarInt(playerid, "ShakeOffer", INVALID_MAXPL);
   	        }
   	        else SendClientMessage(playerid, COLOR_GREY, "You havent been offered for a shake.");
   	    } 
		else if(strcmp(type, "sellto", true) == 0) 
		{
			new seller = GetPVarInt(playerid, "VehicleOffer");
   	        if(seller == INVALID_MAXPL) return SendClientMessage(playerid, COLOR_GREY, "There are no outstanding offer to buy a vehicle.");
   	        if(!Iter_Contains(Player, seller)) {
   	            SetPVarInt(playerid, "VehicleOffer", INVALID_MAXPL);
   	            SetPVarInt(playerid, "VehicleOfferPrice", 0);
   	            SetPVarInt(playerid, "VehicleOfferID", 0);
                return SendClientMessage(playerid, COLOR_GREY, "The seller offering the acquisition of his vehicle is no longer connected.");
			}
			
			if(CountSpawnedCars(playerid) >= MAX_SPAWNED_CARS) {
			    SetPVarInt(playerid, "VehicleOffer", INVALID_MAXPL);
   	            SetPVarInt(playerid, "VehicleOfferPrice", 0);
   	            SetPVarInt(playerid, "VehicleOfferID", 0);
				return SendClientMessage(playerid, COLOR_GREY, "You have too many vehicles spawned to accept the offer.");
			}
			
			if(PlayerToPlayer(playerid, seller, VEHICLE_SELL_RANGE)) {
				if(GetPlayerMoneyEx(playerid) >= GetPVarInt(playerid, "VehicleOfferPrice")) {
            		if(CountSpawnedCars(seller) < 1) {
            		    SetPVarInt(playerid, "VehicleOffer", INVALID_MAXPL);
		   	            DeletePVar(playerid, "VehicleOfferPrice");
		   	            DeletePVar(playerid, "VehicleOfferID");
						return SendClientMessage(playerid, COLOR_GREY, "The seller offering the acquisition does not have a vehicle spawned.");
					}
					
					if(!PlayerOwnsVehicle(seller,GetPlayerVehicleID(seller))) {
					    SetPVarInt(playerid, "VehicleOffer", INVALID_MAXPL);
		   	            DeletePVar(playerid, "VehicleOfferPrice");
		   	            DeletePVar(playerid, "VehicleOfferID");
						return SendClientMessage(playerid, COLOR_GREY, "The seller offering the acquisition is not in his vehicle.");
					}

					new vehicleID = GetPVarInt(playerid, "VehicleOfferID");					
				    if(VehicleInfo[vehicleID][vID] != VehicleInfo[GetPlayerVehicleID(seller)][vID]) {
				        SetPVarInt(playerid, "VehicleOffer", INVALID_MAXPL);
		   	            DeletePVar(playerid, "VehicleOfferPrice");
		   	            DeletePVar(playerid, "VehicleOfferID");
						return SendClientMessage(playerid, COLOR_GREY, "The seller offered an acquisition for a different vehicle.");
					}
					
				    new msg[90];
    				GivePlayerMoneyEx(seller, GetPVarInt(playerid, "VehicleOfferPrice"));
 			    	GivePlayerMoneyEx(playerid, -GetPVarInt(playerid, "VehicleOfferPrice"));
   		    		format(msg, sizeof(msg), "%s accepted your offer for $%i.", PlayerInfo[playerid][pName], GetPVarInt(playerid, "VehicleOfferPrice"));
   		    		SendClientMessage(seller, COLOR_WHITE, msg);
     		    	format(msg, sizeof(msg), "You accepted %s's offer for $%i.", PlayerInfo[seller][pName], GetPVarInt(playerid, "VehicleOfferPrice"));
        	        SendClientMessage(playerid, COLOR_WHITE, msg);
       	         	SetPVarInt(playerid, "VehicleOffer", INVALID_MAXPL);
        	        DeletePVar(playerid, "VehicleOfferPrice");
        	        DeletePVar(playerid, "VehicleOfferID");
        	        format(VehicleInfo[vehicleID][vOwner], MAX_PLAYER_NAME, "%s", PlayerInfo[playerid][pUsername]);
        	        RemovePlayerFromVehicle(seller);
        	        mysql_format(handlesql, msg, sizeof(msg), "UPDATE `vehicles` SET `Owner` = '%s' WHERE `ID` = %i;", PlayerInfo[playerid][pUsername], VehicleInfo[vehicleID][vID]);
        	        mysql_tquery(handlesql, msg);
				} else	{
					SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have enough money to acquire the vehicle.");
					SetPVarInt(playerid, "VehicleOffer", INVALID_MAXPL);
					DeletePVar(playerid, "VehicleOfferPrice");
   	            	DeletePVar(playerid, "VehicleOfferID");
				}
        	} else {
				SendClientMessage(playerid, COLOR_GREY, "You aren't close enough to the seller of the vehicle.");
				SetPVarInt(playerid, "VehicleOffer", INVALID_MAXPL);
				DeletePVar(playerid, "VehicleOfferPrice");
   	            DeletePVar(playerid, "VehicleOfferID");
			}
		}
   	    else if(strcmp(type, "hsellto", true) == 0)
   	    {
   	        if(GetPVarInt(playerid, "HouseOffer") != INVALID_MAXPL)
   	        {
   	            if(IsPlayerConnected(GetPVarInt(playerid, "HouseOffer")))
   	            {
   	                if(PlayerToPlayer(playerid,GetPVarInt(playerid, "HouseOffer"),5.0))
   	                {
						if(GetPlayerMoneyEx(playerid) >= GetPVarInt(playerid, "HouseOfferPrice"))
						{
					   		new targetid = GetPVarInt(playerid, "HouseOffer"), key = GetPVarInt(GetPVarInt(playerid, "HouseOffer"), "HouseKey");
					   		if(strcmp(HouseInfo[key][hOwner], PlayerName(targetid), true) == 0)
					   		{
					   		    GivePlayerMoneyEx(targetid,GetPVarInt(playerid, "HouseOfferPrice"));
					   			GivePlayerMoneyEx(playerid,-GetPVarInt(playerid, "HouseOfferPrice"));
        	            		format(string, sizeof(string), "%s accepted your house sellto.", PlayerName(playerid));
        	            		SendClientMessage(targetid,COLOR_GREY,string);
        	            		format(string, sizeof(string), "You accepted %s's house sellto.", PlayerName(targetid));
        	            		SendClientMessage(playerid,COLOR_GREY,string);
        	            		SetPVarInt(playerid, "HouseKey", key);
        	            		SetPVarInt(targetid, "HouseKey", 0);
        	            		SetPVarInt(playerid, "HouseOffer", INVALID_MAXPL);
        	            		DeletePVar(playerid,"HouseOfferPrice");
        	            		strmid(HouseInfo[key][hOwner], PlayerName(playerid), 0, strlen(PlayerName(playerid)), 255);
        	            	}
        	            	else SendClientMessage(playerid, COLOR_GREY, "The player who offered a sellto doesn't own the house."), SetPVarInt(playerid, "HouseOffer", INVALID_MAXPL);
        	            }
        	            else SendClientMessage(playerid, COLOR_LIGHTRED, "Insufficient funds!"), SetPVarInt(playerid, "HouseOffer", INVALID_MAXPL);
        	        }
        	        else SendClientMessage(playerid, COLOR_GREY, "You aren't around the player who offered the sellto."), SetPVarInt(playerid, "HouseOffer", INVALID_MAXPL);
   	            }
			    else SendClientMessage(playerid, COLOR_GREY, "The person who offered a sellto is offline."), SetPVarInt(playerid, "HouseOffer", INVALID_MAXPL);
   	        }
   	        else SendClientMessage(playerid, COLOR_GREY, "You havent been offered for a sellto."), SetPVarInt(playerid, "HouseOffer", INVALID_MAXPL);
   	    }
   	    else if(strcmp(type, "bsellto", true) == 0)
   	    {
   	        if(GetPVarInt(playerid, "BizzOffer") != INVALID_MAXPL)
   	        {
   	            if(IsPlayerConnected(GetPVarInt(playerid, "BizzOffer")))
   	            {
   	                if(PlayerToPlayer(playerid,GetPVarInt(playerid, "BizzOffer"),5.0))
   	                {
						if(GetPlayerMoneyEx(playerid) >= GetPVarInt(playerid, "BizzOfferPrice"))
						{
					   		new targetid = GetPVarInt(playerid, "BizzOffer"), key = GetPVarInt(GetPVarInt(playerid, "BizzOffer"), "BizzKey");
					   		if(strcmp(BizInfo[key][Owner], PlayerName(targetid), true) == 0)
					   		{
					   		    if(BizInfo[key][Value] >= 10000)
					   		    {
					   			    GivePlayerMoneyEx(targetid,GetPVarInt(playerid, "BizzOfferPrice"));
					   			    GivePlayerMoneyEx(playerid,-GetPVarInt(playerid, "BizzOfferPrice"));
        	            		    format(string, sizeof(string), "%s accepted your bizz sellto.", PlayerName(playerid));
        	            		    SendClientMessage(targetid,COLOR_GREY,string);
        	            		    format(string, sizeof(string), "You accepted %s's bizz sellto.", PlayerName(targetid));
        	            		    SendClientMessage(playerid,COLOR_GREY,string);
        	            		    SetPVarInt(playerid, "BizzKey", key);
        	            		    SetPVarInt(targetid, "BizzKey", 0);
        	            		    SetPVarInt(playerid, "BizzOffer", INVALID_MAXPL);
        	            		    DeletePVar(playerid,"BizzOfferPrice");
        	            		    strmid(BizInfo[key][Owner], PlayerName(playerid), 0, strlen(PlayerName(playerid)), 255);
        	            		}
        	            		else SetPVarInt(playerid, "BizzOffer", INVALID_MAXPL);
        	            	}
        	            	else SendClientMessage(playerid, COLOR_GREY, "The player who offered a sellto doesn't own the bizz."), SetPVarInt(playerid, "BizzOffer", INVALID_MAXPL);
        	            }
        	            else SendClientMessage(playerid, COLOR_LIGHTRED, "Insufficient funds!"), SetPVarInt(playerid, "BizzOffer", INVALID_MAXPL);
        	        }
        	        else SendClientMessage(playerid, COLOR_GREY, "You aren't around the player who offered the sellto."), SetPVarInt(playerid, "BizzOffer", INVALID_MAXPL);
   	            }
			    else SendClientMessage(playerid, COLOR_GREY, "The person who offered a sellto is offline."), SetPVarInt(playerid, "BizzOffer", INVALID_MAXPL);
   	        }
   	        else SendClientMessage(playerid, COLOR_GREY, "You havent been offered for a sellto."), SetPVarInt(playerid, "BizzOffer", INVALID_MAXPL);
   	    }
   	    else if(strcmp(type, "live", true) == 0)
   	    {
   	        if(GetPVarInt(playerid, "LiveOffer") != INVALID_MAXPL)
   	        {
   	            if(IsPlayerConnected(GetPVarInt(playerid, "LiveOffer")))
			    {
                    if(PlayerToPlayer(playerid,GetPVarInt(playerid, "LiveOffer"),5.0))
                    {
                        new targetid = GetPVarInt(playerid, "LiveOffer");
			            format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
	    	            format(giveplayer, sizeof(giveplayer), "%s", PlayerNameEx(targetid));
      		            GiveNameSpace(sendername);
                        GiveNameSpace(giveplayer);
                        switch(GetPVarInt(targetid, "Member"))
                        {
                            case 2:
                            {
				                switch(PlayerInfo[playerid][pLiveOffer][0])
				                {
				                    case 0:
				                    {
				                        format(string, sizeof(string), "* %s accepted to go live on san news.", sendername);
						                SendClientMessage(targetid, COLOR_WHITE, string);
						                format(string, sizeof(string), "* Accepted %s's broadcast on san news.", giveplayer);
						                SendClientMessage(playerid, COLOR_WHITE, string);
						                PlayerInfo[playerid][pLiveOffer][0] = 1;
						                PlayerInfo[targetid][pLiveOffer][0] = 1;
				                    }
				                    case 1:
				                    {
				                        foreach(new i : Player)
				                        {
				                            if(PlayerInfo[i][pLiveOffer][0] == 1)
				                            {
				                                PlayerInfo[i][pLiveOffer][0] = 0;
				                                SendClientMessage(i,COLOR_WHITE,"News Broadcast has ended.");
				                            }
				                        }
				                    }
				                }
                            }
							case 3:
							{
							    switch(PlayerInfo[playerid][pLiveOffer][1])
				        	    {
				            	    case 0:
				            	    {
				                	    format(string, sizeof(string), "* %s to go live on Radio Los Santos.", sendername);
						        	    SendClientMessage(targetid, COLOR_WHITE, string);
						       	        format(string, sizeof(string), "* %s broadcast on Radio Los Santos.", giveplayer);
						       	        SendClientMessage(playerid, COLOR_WHITE, string);
						        	    PlayerInfo[playerid][pLiveOffer][1] = 1;
						        	    PlayerInfo[targetid][pLiveOffer][1] = 1;
				            	    }
				            	    case 1:
				            	    {
				                	    foreach(new i : Player)
				                	    {
				                    	    if(PlayerInfo[i][pLiveOffer][1] == 1)
				                    	    {
				                        	    PlayerInfo[i][pLiveOffer][1] = 0;
				                        	    SendClientMessage(i,COLOR_WHITE,"Broadcast has ended.");
				                    	    }
				                	    }
				            	    }
				        	    }
							}
                        }
                        SetPVarInt(playerid, "LiveOffer", INVALID_MAXPL);
			        }
			        else SendClientMessage(playerid, COLOR_GREY, "You must be around the person who offered the live.");
			    }
			    else SendClientMessage(playerid, COLOR_GREY, "The person who offered a live is offline."), SetPVarInt(playerid, "LiveOffer", INVALID_MAXPL);
   	        }
   	        else SendClientMessage(playerid, COLOR_GREY, "You havent been offered for a live.");
   	    }
   	    else if(strcmp(type, "rentoffer", true) == 0) {
   	        if(GetPVarInt(playerid, "RentOffer") != 501)
   	        {
   	            if(IsPlayerConnected(GetPVarInt(playerid, "RentOffer")))
   	            {
   	                if(PlayerToPlayer(playerid,GetPVarInt(playerid, "RentOffer"),5.0))
   	                {
					    new targetid = GetPVarInt(playerid, "RentOffer"), key = GetPVarInt(GetPVarInt(playerid, "RentOffer"), "HouseKey");
					   	if(strmatch(HouseInfo[key][hOwner], PlayerName(targetid)))
					   	{
        	                format(string, sizeof(string), "%s accepted your rental offer!", PlayerName(playerid));
        	            	SendClientMessage(targetid,COLOR_GREY,string);
        	            	format(string, sizeof(string), "You accepted %s's rental offer!", PlayerName(playerid));
        	            	SendClientMessage(playerid,COLOR_GREY,string);
        	            	SetPVarInt(playerid, "HouseKey", key);
							OnPlayerDataSave(playerid);
        	            }
        	            else SendClientMessage(playerid, COLOR_GREY, "The player who offered a rentto doesn't own the house."), SetPVarInt(playerid, "RentOffer", INVALID_MAXPL);
        	        }
        	        else SendClientMessage(playerid, COLOR_GREY, "You aren't around the player who offered the rentto."), SetPVarInt(playerid, "RentOffer", INVALID_MAXPL);
   	            }
			    else SendClientMessage(playerid, COLOR_GREY, "The person who offered a rentto is offline."), SetPVarInt(playerid, "RentOffer", INVALID_MAXPL);
   	        }
   	        else SendClientMessage(playerid, COLOR_GREY, "You havent been offered for a rentto."), SetPVarInt(playerid, "RentOffer", INVALID_MAXPL);
   	    }
	}
	return 1;
}
//============================================//
ALTCOMMAND:sb->seatbelt;
COMMAND:seatbelt(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if (!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "You must be in a vehicle to use this!");
    if(IsNotAEngineCar(GetPlayerVehicleID(playerid))) return SendClientMessage(playerid, COLOR_GREY, "This vehicle does not have a seatbelt system.");
    if(IsHelmetCar(GetPlayerVehicleID(playerid)))  return SendClientMessage(playerid, COLOR_GREY, "This vehicle does not have a seatbelt system.");
    switch(GetPVarInt(playerid, "Seatbelt"))
    {
        case 0:
        {
            GameTextForPlayer(playerid, "~w~Seatbelt ~g~On", 5000, 6);
            SetPVarInt(playerid, "Seatbelt", 1);
            PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
        }
        case 1:
        {
            GameTextForPlayer(playerid, "~w~Seatbelt ~r~Off", 5000, 6);
            SetPVarInt(playerid, "Seatbelt", 0);
            PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
        }
    }
	return 1;
}
//============================================//
COMMAND:helmet(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if (!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "You must be in a vehicle to use this!");
    if(IsNotAEngineCar(GetPlayerVehicleID(playerid))) return SendClientMessage(playerid, COLOR_GREY, "This vehicle does not have a helmet system.");
    if(!IsHelmetCar(GetPlayerVehicleID(playerid)))  return SendClientMessage(playerid, COLOR_GREY, "This vehicle does not have a helmet system.");
    switch(GetPVarInt(playerid, "Seatbelt"))
    {
        case 0:
        {
            GameTextForPlayer(playerid, "~w~Helmet ~g~On", 5000, 6);
            SetPVarInt(playerid, "Seatbelt", 1);
            ShowPlayerDialog(playerid, 21, DIALOG_STYLE_LIST, "Helmets","Helmet 1\nHelmet 2\nHelmet 3\nHelmet 4\nHelmet 5","Select", "");
        }
        case 1:
        {
            GameTextForPlayer(playerid, "~w~Helmet ~r~Off", 5000, 6);
            SetPVarInt(playerid, "Seatbelt", 0);
            if(IsPlayerAttachedObjectSlotUsed(playerid,HOLDOBJECT_CLOTH1)) RemovePlayerAttachedObject(playerid,HOLDOBJECT_CLOTH1);
        }
    }
	return 1;
}
//============================================//
COMMAND:hood(playerid, params[])
{
	new type[128];
	if(sscanf(params, "s[128]", type)) SendClientMessage(playerid, COLOR_GREEN, "USAGE: /hood [open/close]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return SendClientMessage(playerid, COLOR_GREY, "You must be on-foot.");
	    if(!PlayerToCar(playerid,1,4.0)) return SendClientMessage(playerid, COLOR_LIGHTRED, "WARNING: You are not close to any vehicle.");
	    new carid = PlayerToCar(playerid,2,4.0);
	    if(IsNotAEngineCar(carid)) return SendClientMessage(playerid, COLOR_GREY, "This vehicle dosent have an engine.");
	    if(IsHelmetCar(carid))  return SendClientMessage(playerid, COLOR_GREY, "This vehicle dosent even have a hood system.");
	    if(VehicleInfo[carid][vEngine] != 0) return SendClientMessage(playerid, COLOR_GREY, "This vehicle's engine is not turned off.");
        if(strcmp(type, "open", true) == 0)
	    {
			new engine,lights,alarm,doors,bonnet,boot,objective;
            GetVehicleParamsEx(carid,engine,lights,alarm,doors,bonnet,boot,objective);
            SetVehicleParamsEx(carid,engine,lights,alarm,doors,1,boot,objective);
            ApplyAnimation(playerid, "CARRY", "liftup", 3.0, 0, 0, 0, 0, 0);
	    }
	    else if(strcmp(type, "close", true) == 0)
	    {
			new engine,lights,alarm,doors,bonnet,boot,objective;
            GetVehicleParamsEx(carid,engine,lights,alarm,doors,bonnet,boot,objective);
            SetVehicleParamsEx(carid,engine,lights,alarm,doors,0,boot,objective);
            ApplyAnimation(playerid, "CARRY", "putdwn", 3.0, 0, 0, 0, 0, 0);
	    }
	    else
	    {
	        SendClientMessage(playerid, COLOR_GREEN, "USAGE: /hood [open/close]");
	    }
	}
	return 1;
}
//============================================//
COMMAND:setsub(playerid, params[])
{
	new type, targetid;
	if(sscanf(params, "ui", targetid, type)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /setsub [playerid] [level 0-1]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(type < 0 || type > 1) return SendClientMessage(playerid, COLOR_GREY, "Cannot go under 0 or above 1.");
		if(GetPVarInt(playerid, "Admin") >= 1337)
		{
		    if(IsPlayerConnected(targetid))
		    {
      		    SetPVarInt(targetid, "MonthDon", type);
      		    SetPVarInt(targetid, "MonthDonT", GetPVarInt(targetid, "MonthDonT") + 30);
      		    SendClientMessage(playerid,COLOR_GREY,"Player's subscription Rank & Perks has been given.");
      		    SendClientMessage(targetid,COLOR_GREY,"You have received your monthly subscription Rank and Perks.");
		    }
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
COMMAND:setdonate(playerid, params[])
{
	new type, targetid;
	if(sscanf(params, "ui", targetid, type)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /setdonate [playerid] [level 0-4]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(type < 0 || type > 4) return SendClientMessage(playerid, COLOR_GREY, "Cannot go under 0 or above 4.");
		if(GetPVarInt(playerid, "Admin") >= 1337)
		{
		    if(IsPlayerConnected(targetid))
		    {
      		    SetPVarInt(targetid, "DonateRank", type);
      		    switch(type)
      		    {
      		        case 1: SetPVarInt(targetid, "Changes", 2);
      		        case 2: SetPVarInt(targetid, "Changes", 3);
      		        case 3:
      		        {
      		            SetPVarInt(targetid, "CarTicket", 1);
      		            SetPVarInt(targetid, "Changes", 4);
      		        }
      		        case 4:
      		        {
      		            SetPVarInt(targetid, "CarTicket", 1);
      		            SetPVarInt(targetid, "Changes", 5);
      		        }
      		    }
      		    SendClientMessage(playerid,COLOR_GREY,"Players Donate Rank & Perks have been given.");
      		    SendClientMessage(targetid,COLOR_GREY,"You have received your Donation Rank and Perks.");
		    }
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
COMMAND:setstat(playerid, params[])
{
	if(GetPVarInt(playerid, "Admin") < 6) { return nal(playerid); }
	new type[128], targetid, amount, string[128];
	if(sscanf(params, "us[128]i", targetid, type, amount))
	{
	    SendClientMessage(playerid, COLOR_GREY, "USAGE: /setstat [playerid(name)] [stat code] [amount]");
	    SendClientMessage(playerid, COLOR_GREY, "| ConnectTime, Model, Bank, HouseKey, BizzKey |");
	    SendClientMessage(playerid, COLOR_GREY, "| GunLic, DriveLic, PhoneNum, Member, DonateRank |");
	    SendClientMessage(playerid, COLOR_GREY, "| Member, Rank, CarTicket, Changes , WepSerial |");
		SendClientMessage(playerid, COLOR_GREY, "| 9mmskill, uziskill, sawnoffskill |");
		SendClientMessage(playerid, COLOR_GREY, "| Materials, CraftLevel |");
	}
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if(GetPVarInt(playerid, "Admin") >= 6)
		{
		    if(strcmp(type, "ConnectTime", true) == 0)
		    {
		        SetPVarInt(targetid, "ConnectTime", amount), SetPlayerScore(targetid,GetPVarInt(targetid, "ConnectTime"));
		        OnPlayerDataSave(targetid);
				format(string, sizeof(string),"You have set %s's %s to %d", PlayerName(targetid), type,amount);
				SendClientMessage(playerid, COLOR_GREY, string);
		    }
		    else if(strcmp(type, "Model", true) == 0)
		    {
		        SetPVarInt(targetid, "Model", amount);
		        OnPlayerDataSave(targetid);
				format(string, sizeof(string),"You have set %s's %s to %d", PlayerName(targetid), type,amount);
				SendClientMessage(playerid, COLOR_GREY, string);
		    }
		    else if(strcmp(type, "Bank", true) == 0)
		    {
				if(GetPVarInt(playerid, "Admin") < 10) return error(playerid, "Lead only!");
		        SetPVarInt(targetid, "Bank", amount);
		        OnPlayerDataSave(targetid);
				format(string, sizeof(string),"You have set %s's %s to %d", PlayerName(targetid), type,amount);
				SendClientMessage(playerid, COLOR_GREY, string);
		    }
		    else if(strcmp(type, "HouseKey", true) == 0)
		    {
		        SetPVarInt(targetid, "HouseKey", amount);
		        OnPlayerDataSave(targetid);
				format(string, sizeof(string),"You have set %s's %s to %d", PlayerName(targetid), type,amount);
				SendClientMessage(playerid, COLOR_GREY, string);
		    }
		    else if(strcmp(type, "BizzKey", true) == 0)
		    {
		        SetPVarInt(targetid, "BizzKey", amount);
		        OnPlayerDataSave(targetid);
				format(string, sizeof(string),"You have set %s's %s to %d", PlayerName(targetid), type,amount);
				SendClientMessage(playerid, COLOR_GREY, string);
		    }
		    else if(strcmp(type, "GunLic", true) == 0)
		    {
		        SetPVarInt(targetid, "GunLic", amount);
		        OnPlayerDataSave(targetid);
				format(string, sizeof(string),"You have set %s's %s to %d", PlayerName(targetid), type,amount);
				SendClientMessage(playerid, COLOR_GREY, string);
		    }
		    else if(strcmp(type, "DriveLic", true) == 0)
		    {
		        SetPVarInt(targetid, "DriveLic", amount);
		        OnPlayerDataSave(targetid);
				format(string, sizeof(string),"You have set %s's %s to %d", PlayerName(targetid), type,amount);
				SendClientMessage(playerid, COLOR_GREY, string);
		    }
		    else if(strcmp(type, "PhoneNum", true) == 0)
		    {
		        SetPVarInt(targetid, "PhoneNum", amount);
		        OnPlayerDataSave(targetid);
				format(string, sizeof(string),"You have set %s's %s to %d", PlayerName(targetid), type,amount);
				SendClientMessage(playerid, COLOR_GREY, string);
		    }
		    else if(strcmp(type, "Member", true) == 0)
		    {
		        SetPVarInt(targetid, "Member", amount);
		        OnPlayerDataSave(targetid);
				format(string, sizeof(string),"You have set %s's %s to %d", PlayerName(targetid), type,amount);
				SendClientMessage(playerid, COLOR_GREY, string);
		    }
		    else if(strcmp(type, "Rank", true) == 0)
		    {
		        SetPVarInt(targetid, "Rank", amount);
		        OnPlayerDataSave(targetid);
				format(string, sizeof(string),"You have set %s's %s to %d", PlayerName(targetid), type,amount);
				SendClientMessage(playerid, COLOR_GREY, string);
		    }
		    else if(strcmp(type, "DonateRank", true) == 0)
		    {
				if(GetPVarInt(playerid, "Admin") < 11) return error(playerid, "Owner only!");
		        SetPVarInt(targetid, "DonateRank", amount);
		        OnPlayerDataSave(targetid);
				format(string, sizeof(string),"You have set %s's %s to %d", PlayerName(targetid), type,amount);
				SendClientMessage(playerid, COLOR_GREY, string);
		    }
		    else if(strcmp(type, "CarTicket", true) == 0)
		    {
		        SetPVarInt(targetid, "CarTicket", amount);
		        OnPlayerDataSave(targetid);
				format(string, sizeof(string),"You have set %s's %s to %d", PlayerName(targetid), type,amount);
				SendClientMessage(playerid, COLOR_GREY, string);
		    }
		    else if(strcmp(type, "Changes", true) == 0)
		    {
		        SetPVarInt(targetid, "Changes", amount);
		        OnPlayerDataSave(targetid);
				format(string, sizeof(string),"You have set %s's %s to %d", PlayerName(targetid), type,amount);
				SendClientMessage(playerid, COLOR_GREY, string);
		    }
		    else if(strcmp(type, "WepSerial", true) == 0)
		    {
				PlayerInfo[targetid][pWepSerial] = amount;
		        OnPlayerDataSave(targetid);
				format(string, sizeof(string),"You have set %s's %s to %d", PlayerName(targetid), type, amount);
				SendClientMessage(playerid, COLOR_GREY, string);
		    }			
		    else if(strcmp(type, "9mmskill", true) == 0)
		    {
				if(GetPVarInt(playerid, "Admin") < 11) return error(playerid, "Owner only!");
				if(amount < 200 || amount > 999) return error(playerid, "Value must be between 200 and 999.");
		        SetPDataInt(playerid, "9mmSkill", amount);
				SetPlayerSkillLevel(playerid,WEAPONSKILL_PISTOL,amount);
				format(string, sizeof(string),"You have set %s's %s to %d", PlayerName(targetid), type,amount);
				SendClientMessage(playerid, COLOR_GREY, string);
		    }
		    else if(strcmp(type, "uziskill", true) == 0)
		    {
				if(GetPVarInt(playerid, "Admin") < 11) return error(playerid, "Owner only!");
				if(amount < 200 || amount > 999) return error(playerid, "Value must be between 200 and 999.");
		        SetPDataInt(playerid, "uziSkill", amount);
				SetPlayerSkillLevel(playerid,WEAPONSKILL_MICRO_UZI,amount);
				format(string, sizeof(string),"You have set %s's %s to %d", PlayerName(targetid), type,amount);
				SendClientMessage(playerid, COLOR_GREY, string);
		    }
		    else if(strcmp(type, "sawnoffskill", true) == 0)
		    {
				if(GetPVarInt(playerid, "Admin") < 11) return error(playerid, "Owner only!");
				if(amount < 200 || amount > 999) return error(playerid, "Value must be between 200 and 999.");
		        SetPDataInt(playerid, "sawnoffSkill", amount);
				SetPlayerSkillLevel(playerid,WEAPONSKILL_SAWNOFF_SHOTGUN,amount);
				format(string, sizeof(string),"You have set %s's %s to %d", PlayerName(targetid), type,amount);
				SendClientMessage(playerid, COLOR_GREY, string);
		    }
			else if(strcmp(type, "Materials", true) == 0)
		    {
				if(GetPVarInt(playerid, "Admin") < 11) return error(playerid, "Owner only!");
		        PlayerInfo[targetid][pMaterials] = amount;
		        OnPlayerDataSave(targetid);
				format(string, sizeof(string),"You have set %s's %s to %d", PlayerName(targetid), type,amount);
				SendClientMessage(playerid, COLOR_GREY, string);
		    }
			else if(strcmp(type, "CraftLevel", true) == 0)
		    {
				if(GetPVarInt(playerid, "Admin") < 11) return error(playerid, "Owner only!");
		        PlayerInfo[targetid][pCraft] = amount;
				SaveCrafting(targetid);
				format(string, sizeof(string),"You have set %s's %s to %d", PlayerName(targetid), type,amount);
				SendClientMessage(playerid, COLOR_GREY, string);
		    }
			format(string, sizeof(string), "%s has set %s's %s to %d.", PlayerName(playerid), PlayerName(targetid), type, amount);
			StatLog(string);
		}
		else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
COMMAND:gasprice(playerid, params[])
{
	new amount,type[10],string[128],sendername[MAX_PLAYER_NAME];
	if(sscanf(params, "s[10]i", type, amount)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /gasprice [regular/premium/diesel] [price-per-liter]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if(GetPVarInt(playerid, "Admin") >= 8)
		{
			format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
			GiveNameSpace(sendername);
			if(GetPVarInt(playerid, "AHide") > 0 || GetPVarInt(playerid, "Admin") >= 11) sendername = "Hidden";
			if(strcmp(type, "regular", true) == 0) { //Gas price for regular fuel.
				format(string, sizeof(string), "AdmCmd: %s has set the per-liter price of 'Regular' fuel to $%d.", sendername, amount);
				SendAdminMessage(COLOR_LIGHTRED,string);
				GasPrice[FUEL_TYPE_REGULAR] = amount;
			} else if(strcmp(type, "premium", true) == 0) { //Gas price for premium fuel.
				format(string, sizeof(string), "AdmCmd: %s has set the per-liter price of 'Premium' fuel to $%d.", sendername, amount);
				SendAdminMessage(COLOR_LIGHTRED,string);
				GasPrice[FUEL_TYPE_PREMIUM] = amount;
			} else if(strcmp(type, "diesel", true) == 0) { //Gas price for diesel fuel.
				format(string, sizeof(string), "AdmCmd: %s has set the per-liter price of 'Diesel' fuel to $%d.", sendername, amount);
				SendAdminMessage(COLOR_LIGHTRED,string);
				GasPrice[FUEL_TYPE_DIESEL] = amount;
			} else return SendClientMessage(playerid, COLOR_GREY, "USAGE: /gasprice [regular/premium/diesel] [price-per-liter]");
		}
		else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
COMMAND:tod(playerid, params[])
{
	new a1,a2,a3;
	if(sscanf(params, "iii", a1,a2,a3)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /tod [hour/minute/second]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if(GetPVarInt(playerid, "Admin") >= 8)
		{
		    if(a1 < 0 || a1 > 24) return SendClientMessage(playerid, COLOR_GREY, "Cannot go under 0 or above 24.");
		    if(a2 < 0 || a2 > 20) return SendClientMessage(playerid, COLOR_GREY, "Cannot go under 0 or above 20.");
		    if(a3 < 0 || a3 > 60) return SendClientMessage(playerid, COLOR_GREY, "Cannot go under 0 or above 60.");
		    GMHour=a1;
		    GMMin=a2;
		    GMSec=a3;
		    SetWorldTimeEx();
		    scm(playerid, -1, "Time changed!");
		}
		else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
COMMAND:fill(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOR_WHITE, "You must be the driver in a vehicle to use this.");
    if (IsAtGasStation(playerid))
    {
		if(VehicleInfo[GetPlayerVehicleID(playerid)][vFuel] >= 99) return SendClientMessage(playerid, COLOR_WHITE, "Your gas tank is full!");
		new string[1000], amount, cost;
		amount = 100 - VehicleInfo[GetPlayerVehicleID(playerid)][vFuel];
		new gasType = GasType(GetVehicleModel(GetPlayerVehicleID(playerid)));
		cost = amount*GasPrice[gasType];
		if(GetPVarInt(playerid, "DonateRank") >= 2) cost = 0;
		if(GetPVarInt(playerid, "Member") == 1 || GetPVarInt(playerid, "Member") == 2) cost = 0;
		format(string, 1000, "Enter the amount of litres you would like to put in the vehicle.\nFuel type: %s{A9C4E4}\n$%d each liter.\nMaximum amount: %d liters\nFull-tank cost:  $%d", FuelName(gasType), GasPrice[gasType], amount, cost);
        ShowPlayerDialog(playerid, 15, DIALOG_STYLE_INPUT, "Gas Station", string,"Enter", "Cancel");
	}
	else SendClientMessage(playerid, COLOR_GREY, "You are not around any fuel pumps.");
	return 1;
}
//============================================//
COMMAND:afkers(playerid, params[])
{
	if(GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	if(GetPVarInt(playerid, "Admin") < 2) return 1;
	new online = 0, players = 0;
	foreach(new i : Player)
	{
	    if(GetPVarInt(i, "AFKTime") >= 5)
        {
		    if(GetPVarInt(i, "PlayerLogged") == 1)
			{
			    online++;
			}
	    }
	}
	foreach(new i : Player)
	{
	    if(GetPVarInt(i, "PlayerLogged") != 0)
		{
		    players++;
		}
	}
	new string[128];
	format(string, sizeof(string), "(( There is %d/%d afkers online. ))", online, players);
	SendClientMessage(playerid, 0x8080FF96, string);
	return 1;
}
//============================================//
COMMAND:aafkers(playerid, params[])
{
    new sendername[MAX_PLAYER_NAME],string[128];
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Admin") >= 1 || GetPVarInt(playerid, "Helper") >= 1)
    {
        SendClientMessage(playerid, COLOR_WHITE, "__________________________________________________");
        SendClientMessage(playerid, COLOR_WHITE, "   ALT-TABBED USERS/AFK AMOUNT(For Helpers):");
        new found = 0;
        foreach(new i : Player) {
            if(GetPVarInt(i, "AFKTime") >= 5) {
                format(sendername, sizeof(sendername), "%s", PlayerName(i));
      		    GiveNameSpace(sendername);
			    format(string, sizeof(string), "%s [ID: %d] %d seconds.", sendername, i, GetPVarInt(i, "AFKTime"));
			    if(GetPVarInt(playerid, "Admin") >= 1) {
			 		SendClientMessage(playerid, COLOR_FADE, string);
				}
			    found++;
            }
        }
        if(found == 0) SendClientMessage(playerid, COLOR_FADE, "No-one online.");
		if(found > 0) {
		    format(string, sizeof(string), "Total users AFK: %d.", found);
		    SendClientMessage(playerid, COLOR_FADE, string);
		}
        SendClientMessage(playerid, COLOR_WHITE, "__________________________________________________");
    }
    else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	return 1;
}
//============================================//
COMMAND:checkveh(playerid, params[])
{
	new targetid,string[128],giveplayer[MAX_PLAYER_NAME],Float:health;
	if(sscanf(params, "u", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /checkveh [playerid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
		if(GetPVarInt(playerid, "Admin") >= 1)
		{
			GetVehicleHealth(GetPlayerVehicleID(targetid),health);
      		format(giveplayer, sizeof(giveplayer), "%s", PlayerName(targetid));
      		GiveNameSpace(giveplayer);
      		format(string, sizeof(string), "%s driving vehicleid: %d with Health: %.1f.", giveplayer, GetPlayerVehicleID(targetid), health);
	        SendClientMessage(playerid, COLOR_GREY, string);
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
COMMAND:checkhealth(playerid, params[])
{
	new targetid,string[128],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "u", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /checkhealth [playerid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
		if(GetPVarInt(playerid, "Admin") >= 1)
		{
		    new Float:shealth;
			GetPlayerHealth(targetid,shealth);
      		format(giveplayer, sizeof(giveplayer), "%s", PlayerName(targetid));
      		GiveNameSpace(giveplayer);
      		format(string, sizeof(string), "%s Health is: %.1f.", giveplayer ,shealth);
	        SendClientMessage(playerid, COLOR_GREY, string);
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
COMMAND:checkarmour(playerid, params[])
{
	new targetid,string[128],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "u", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /checkarmour [playerid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
		if(GetPVarInt(playerid, "Admin") >= 1)
		{
		    new Float:shealth;
			GetPlayerArmour(targetid,shealth);
      		format(giveplayer, sizeof(giveplayer), "%s", PlayerName(targetid));
      		GiveNameSpace(giveplayer);
      		format(string, sizeof(string), "%s Armour is: %.1f.", giveplayer ,shealth);
	        SendClientMessage(playerid, COLOR_GREY, string);
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
COMMAND:checkweapons(playerid, params[])
{
	new targetid,string[128],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "u", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /checkweapons [playerid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
		if(GetPVarInt(playerid, "Admin") >= 1)
		{
		    new sweapon, sammo, gunname[128];
      		format(giveplayer, sizeof(giveplayer), "%s", PlayerName(targetid));
      		GiveNameSpace(giveplayer);
      		format(string, sizeof(string), "%s has the following weapons:", giveplayer);
	        SendClientMessage(playerid, COLOR_GREY, string);
	        for (new i=0; i<9; i++)
	        {
		        GetPlayerWeaponData(targetid, i, sweapon, sammo);
		        if(sweapon != 0)
		        {
		            GetWeaponName(sweapon, gunname, sizeof(gunname));
		            format(string, sizeof(string), "%d: %s (%d)", i, gunname, sammo);
		    	    SendClientMessage(playerid, COLOR_GREY, string);
			    }
	        }
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
COMMAND:a(playerid, params[])
{
	new text[128],string[255],sendername[128];
	if(sscanf(params, "s[128]", text)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /a [Admin-Chat]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if(GetPVarInt(playerid, "Admin") >= 1)
		{
   			format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
      		GiveNameSpace(sendername);
      		new arank[128];
      		switch(GetPVarInt(playerid, "Admin"))
      		{
      		    case 1: arank = "Level 1 Moderator";
      		    case 2: arank = "Level 2 Admin";
      		    case 3: arank = "Level 3 Admin";
      		    case 4 .. 9: arank = "Senior Admin";
      		    case 10: arank = "Lead Administrator";
      		    case 11: arank = "Lead Administrator";
      		}
      		if(GetPVarInt(playerid, "AHide") > 0 || GetPVarInt(playerid, "Admin") >= 11) sendername = "Hidden";
            format(string, sizeof(string), "*** %s %s *** %s", arank,  AdminName(playerid), text);
    	    SendAdminMessage(COLOR_YELLOW, string);
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
/*COMMAND:createobject(playerid, params[])
{
	new one, two;
	if(sscanf(params, "ii", one, two)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /createobject [id] [Rot-Z]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if(GetPVarInt(playerid, "Admin") >= 7)
		{
			new Float:X,Float:Y,Float:Z, string[128];
			GetPlayerPos(playerid,X,Y,Z);
			CreateDynamicObject(one, X,Y,Z+two, 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid));
			format(string, sizeof(string), "%.1f %.1f %.1f", X, Y, Z);
			SendClientMessage(playerid, COLOR_WHITE, string);
		}
		else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}*/
//============================================//
COMMAND:gmx(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "SERVER: You must be logged in to use this.");
    if(GetPVarInt(playerid, "Admin") >= 10) GameModeExit();
    else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	return 1;
}
//============================================//
COMMAND:concert(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "SERVER: You must be logged in to use this.");
    if(GetPVarInt(playerid, "Admin") >= 10)
    {
        switch(Concert)
        {
            case 0:
            {
                Concert=1;
                SendClientMessage(playerid, COLOR_LIGHTRED, "Concert enabled!");
                foreach(new i : Player)
	            {
	                RemoveBuildingForPlayer(i, 5523, 2021.6563, -1810.7266, 18.6016, 0.25);
	                RemoveBuildingForPlayer(i, 5524, 2025.3750, -1773.9531, 16.6797, 0.25);
	                RemoveBuildingForPlayer(i, 5525, 2029.5000, -1819.2734, 14.3359, 0.25);
	                RemoveBuildingForPlayer(i, 5526, 2049.5781, -1781.6797, 18.3281, 0.25);
	                RemoveBuildingForPlayer(i, 1524, 2034.3984, -1801.6719, 14.5469, 0.25);
	                RemoveBuildingForPlayer(i, 1268, 2030.9297, -1763.1641, 28.5781, 0.25);
	                RemoveBuildingForPlayer(i, 1268, 2066.8125, -1791.7891, 21.9766, 0.25);
	                RemoveBuildingForPlayer(i, 5417, 2029.5000, -1819.2734, 14.3359, 0.25);
	                RemoveBuildingForPlayer(i, 1226, 2013.2734, -1816.4297, 16.3828, 0.25);
	                RemoveBuildingForPlayer(i, 1283, 1972.9922, -1811.4531, 15.5859, 0.25);
	                RemoveBuildingForPlayer(i, 1226, 1974.2109, -1808.1406, 16.4063, 0.25);
	                RemoveBuildingForPlayer(i, 5411, 2021.6563, -1810.7266, 18.6016, 0.25);
	                RemoveBuildingForPlayer(i, 1259, 2030.9297, -1763.1641, 28.5781, 0.25);
	                RemoveBuildingForPlayer(i, 5628, 2025.3750, -1773.9531, 16.6797, 0.25);
	                RemoveBuildingForPlayer(i, 1226, 2041.3594, -1807.9531, 16.4063, 0.25);
	                RemoveBuildingForPlayer(i, 5522, 2048.7188, -1776.4766, 18.6484, 0.25);
	                RemoveBuildingForPlayer(i, 5521, 2049.5781, -1781.6797, 18.3281, 0.25);
	                RemoveBuildingForPlayer(i, 5422, 2071.4766, -1831.4219, 14.5625, 0.25);
	                RemoveBuildingForPlayer(i, 1283, 2070.2109, -1812.8828, 15.6016, 0.25);
	                RemoveBuildingForPlayer(i, 1259, 2066.8125, -1791.7891, 21.9766, 0.25);
	                RemoveBuildingForPlayer(i, 1522, 2070.2109, -1794.5938, 12.5234, 0.25);
	                RemoveBuildingForPlayer(i, 1522, 2068.1641, -1780.6094, 12.5391, 0.25);
	                RemoveBuildingForPlayer(i, 1216, 2069.0000, -1766.6641, 13.2109, 0.25);
	                RemoveBuildingForPlayer(i, 1216, 2068.9375, -1767.8359, 13.2109, 0.25);
	            }
	            for(new h = 0; h < sizeof(ConcertObject); h++)
	            {
	                if(ConcertOBJ[h] > 0)
	                {
	                    DestroyDynamicObject(ConcertOBJ[h]);
	                    ConcertOBJ[h]=0;
	                }
	                ConcertOBJ[h]=CreateDynamicObject(ConcertObject[h][comodel], ConcertObject[h][coX], ConcertObject[h][coY], ConcertObject[h][coZ], ConcertObject[h][corX], ConcertObject[h][corY], ConcertObject[h][corZ], 0);
	            }
				if(ConcertCP > 0)
				{
				    DestroyDynamicCP(ConcertCP);
				    ConcertCP=0;
				}
	            ConcertCP=CreateDynamicCP(2044.9153,-1818.7079,13.3513, 1.0, 0, 0);
            }
            case 1:
            {
                Concert=0;
                SendClientMessage(playerid, COLOR_LIGHTRED, "Concert disabled!");
                for(new h = 0; h < sizeof(ConcertObject); h++)
	            {
	                if(ConcertOBJ[h] > 0)
	                {
	                    DestroyDynamicObject(ConcertOBJ[h]);
	                    ConcertOBJ[h]=0;
	                }
	            }
	            if(ConcertCP > 0)
				{
				    DestroyDynamicCP(ConcertCP);
				    ConcertCP=0;
				}
            }
        }
    }
    else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	return 1;
}
//============================================//
ALTCOMMAND:o->ooc;
COMMAND:ooc(playerid, params[])
{
	new text[128],string[255],sendername[MAX_PLAYER_NAME];
	if(sscanf(params, "s[128]", text)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /ooc [OOC-Chat]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (OOCChat == 0 && GetPVarInt(playerid, "Admin") == 0) return SendClientMessage(playerid, COLOR_WHITE, "OOC Chat has been disabled.");
		if(GetPVarInt(playerid, "Admin") > 0 || GetPVarInt(playerid, "Helper") > 0) {
			format(sendername, sizeof(sendername), "%s", AdminName(playerid));
		} else {
			format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
		}
      	GiveNameSpace(sendername);
        format(string, sizeof(string), "OOC: %s: %s", sendername, text);
    	SendClientMessageToAll(0xB1C8FBAA, string);
	}
	return 1;
}
//============================================//
COMMAND:booc(playerid, params[])
{
	new text[128],string[255];
	if(sscanf(params, "s[128]", text)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /booc [OOC-Chat]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Admin") >= 9)
	    {
            format(string, sizeof(string), "OOC: Anticheat: %s", text);
    	    SendClientMessageToAll(0xB1C8FBAA, string);
    	}
	}
	return 1;
}
//============================================//
COMMAND:noooc(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	if(GetPVarInt(playerid, "Admin") >= 4)
	{
		switch(OOCChat)
		{
		    case 0:
			{
			    OOCChat=1;
			    SendClientMessageToAll(COLOR_WHITE, "OOC Chat has been enabled by Admin.");
			}
			case 1:
			{
			    OOCChat=0;
			    SendClientMessageToAll(COLOR_WHITE, "OOC Chat has been disabled by Admin.");
		    }
		}
	}
	else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	return 1;
}
//============================================//
COMMAND:bonus(playerid, params[])
{
	new targetid, amount, string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "ui", targetid, amount)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /bonus [playerid] [amount]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
	    if(IsPlayerNPC(targetid)) return SendClientMessage(playerid, COLOR_GREY, "Can't do this to a NPC.");
	    if (playerid == targetid) return SendClientMessage(playerid, COLOR_GREY, "You cannot bonus to yourself.");
		if(GetPVarInt(playerid, "Member") == 1 || GetPVarInt(playerid, "Member") == 2 || GetPVarInt(playerid, "Member") == 8)
		{
		    if(GetPVarInt(playerid, "Rank") >= MaxRank(GetPVarInt(playerid, "Member")))
		    {
		        if(amount < 0 || amount > 1000) return SendClientMessage(playerid, COLOR_GREY, "Cannot go under 0 or above 1000.");
   			    format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
      		    format(giveplayer, sizeof(giveplayer), "%s", PlayerName(targetid));
      		    GiveNameSpace(sendername);
      		    GiveNameSpace(giveplayer);
      		    format(string, sizeof(string), "%s's bonus paycheck value set to %d.", giveplayer, amount);
      		    SCM(playerid, COLOR_WHITE, string);
      		    format(string, sizeof(string), "Leader %s has set your bonus paycheck value to %d.", sendername, amount);
      		    SCM(targetid, COLOR_WHITE, string);
      		    SetPVarInt(playerid, "Bonus", amount);
			}
      		else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
		else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
COMMAND:slap(playerid, params[])
{
	new targetid,string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "u", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /slap [playerid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
	    if(IsPlayerNPC(targetid)) return SendClientMessage(playerid, COLOR_GREY, "Can't do this to a NPC.");
		if(GetPVarInt(playerid, "Admin") >= 1)
		{
   			format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
      		format(giveplayer, sizeof(giveplayer), "%s", PlayerName(targetid));
      		GiveNameSpace(sendername);
      		GiveNameSpace(giveplayer);
      		if(GetPVarInt(playerid, "AHide") > 0 || GetPVarInt(playerid, "Admin") >= 11) sendername = "Hidden";
      		format(string, sizeof(string), "AdmCmd: %s was slapped by %s.", giveplayer, sendername);
      		SendAdminMessage(COLOR_LIGHTRED,string);
			new Float:x,Float:y,Float:z,Float:health;
			GetPlayerHealth(targetid,health);
			GetPlayerPos(targetid,x,y,z);
      		SetPlayerPosEx(targetid,x,y,z+5);
      		SetPlayerHealth(targetid,health-15.0);
      		GameTextForPlayer(targetid, "~r~Slapped", 5000, 3);
      		PlayerPlaySound(targetid,1190, 0.0, 0.0, 0.0);
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
COMMAND:slapcar(playerid, params[])
{
	new targetid,string[128],sendername[MAX_PLAYER_NAME];
	if(sscanf(params, "i", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /slapcar [vehicleid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if(GetPVarInt(playerid, "Admin") >= 1)
		{
   			format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
      		GiveNameSpace(sendername);
      		if(GetPVarInt(playerid, "AHide") > 0 || GetPVarInt(playerid, "Admin") >= 11) sendername = "Hidden";
      		format(string, sizeof(string), "AdmCmd: %s slapped vehicleid %d.", sendername, targetid);
      		SendAdminMessage(COLOR_LIGHTRED,string);
			new Float:x,Float:y,Float:z;
			GetVehiclePos(targetid,x,y,z);
      		SetVehiclePosEx(targetid,x,y,z+5);
      		PlayerPlaySound(targetid,1190, 0.0, 0.0, 0.0);
		}
		else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
COMMAND:getcar(playerid, params[])
{
	new targetid;
	if(sscanf(params, "i", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /getcar [vehicleid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if(GetPVarInt(playerid, "Admin") >= 1)
		{
			new Float:x,Float:y,Float:z, Float:px,Float:py,Float:pz;
			GetVehiclePos(targetid,x,y,z), GetPlayerPos(playerid, px, py, pz);
			SetVehiclePosEx(targetid, px, py, pz);
			SetVehicleVirtualWorldEx(targetid, GetPlayerVirtualWorld(playerid));
			LinkVehicleToInteriorEx(targetid, GetPlayerInterior(playerid));
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
COMMAND:explode(playerid, params[])
{
	new targetid,string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "u", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /explode [playerid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
	    if(IsPlayerNPC(targetid)) return SendClientMessage(playerid, COLOR_GREY, "Can't do this to a NPC.");
		if(GetPVarInt(playerid, "Admin") >= 7)
		{
   			format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
      		format(giveplayer, sizeof(giveplayer), "%s", PlayerName(targetid));
      		GiveNameSpace(sendername);
      		GiveNameSpace(giveplayer);
      		if(GetPVarInt(playerid, "AHide") > 0 || GetPVarInt(playerid, "Admin") >= 11) sendername = "Hidden";
      		format(string, sizeof(string), "AdmCmd: %s was exploded by %s.", giveplayer, sendername);
      		SendAdminMessage(COLOR_LIGHTRED,string);
			new Float:x,Float:y,Float:z;
			GetPlayerPos(targetid,x,y,z);
			CreateExplosion(x, y, z, 2, 10.0);
		}
		else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
COMMAND:weaponid(playerid, params[])
{
	new maskid,string[128];
	if(sscanf(params, "i", maskid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /weaponid [Weapon-ID]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if(GetPVarInt(playerid, "Admin") >= 1)
		{
		    SendClientMessage(playerid, COLOR_GREY, "People with Weapon-ID:");
		    foreach(new i : Player)
	        {
	            if(GetPlayerWeapon(i) == maskid)
	            {
	                format(string, sizeof(string), "** ID: %d ** %s", i, PlayerName(i));
				    SendClientMessage(playerid, COLOR_GREY, string);
	            }
	        }
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
COMMAND:skinid(playerid, params[])
{
	new maskid,string[128];
	if(sscanf(params, "i", maskid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /skinid [Skin-ID]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if(GetPVarInt(playerid, "Admin") >= 1)
		{
		    SendClientMessage(playerid, COLOR_GREY, "People with Skin-ID:");
		    foreach(new i : Player)
	        {
	            if(GetPlayerSkin(i) == maskid)
	            {
	                format(string, sizeof(string), "** ID: %d ** %s", i, PlayerName(i));
				    SendClientMessage(playerid, COLOR_GREY, string);
	            }
	        }
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
COMMAND:sendtols(playerid, params[])
{
	new targetid;
	if(sscanf(params, "u", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /sendtols [playerid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
	    if(IsPlayerNPC(targetid)) return SendClientMessage(playerid, COLOR_GREY, "Can't do this to a NPC.");
	    if (GetPVarInt(playerid, "Jailed") != 0) return true;
		if(GetPVarInt(playerid, "Admin") >= 1)
		{
		    SetPlayerPosEx(targetid, 1529.6,-1691.2,13.3);
			SetPlayerInterior(targetid,0);
			SetPlayerVirtualWorld(targetid,0);
		    SendClientMessage(targetid, 0xFF000000, "You have been sent to Los Santos!.");
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
COMMAND:sendto(playerid, params[])
{
	new targetid, toplayerid, string[128];
	if(sscanf(params, "uu", targetid, toplayerid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /sendto [playerid] [targetid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
	    if (!IsPlayerConnected(toplayerid)) return SendClientMessage(playerid, COLOR_WHITE, "Targeted player is not connected!");
		if(GetPVarInt(playerid, "Admin") >= 1)
		{
			new Float:x,Float:y,Float:z;
			GetPlayerPos(toplayerid,x,y,z);
			if(IsPlayerInAnyVehicle(targetid))
		    {
                SetVehiclePosEx(GetPlayerVehicleID(targetid),x,y+4,z);
      		    SetPlayerVirtualWorld(targetid,GetPlayerVirtualWorld(toplayerid));
      		    SetPlayerInterior(targetid,GetPlayerInterior(toplayerid));
      		    LinkVehicleToInteriorEx(GetPlayerVehicleID(targetid),GetPlayerInterior(toplayerid));
      		    SetVehicleVirtualWorldEx(GetPlayerVehicleID(targetid),GetPlayerVirtualWorld(toplayerid));
	    	}
		    else
		    {
		        SetPlayerPosEx(targetid, x,y+2,z);
      		    SetPlayerVirtualWorld(targetid,GetPlayerVirtualWorld(toplayerid));
      		    SetPlayerInterior(targetid,GetPlayerInterior(toplayerid));
		    }

		    new targetid_name[MAX_PLAYER_NAME], toplayerid_name[MAX_PLAYER_NAME];
		    GetPlayerName(targetid, targetid_name, sizeof(targetid_name));
		    GetPlayerName(playerid, toplayerid_name, sizeof(toplayerid_name));
		    format(string, sizeof(string), "You have teleported %s to %s's location.", targetid_name, toplayerid_name);
      		SendClientMessage(playerid,COLOR_GREY,string);
      		SendClientMessage(targetid,COLOR_GREY,"You have been teleported.");

      		SetPVarInt(targetid, "IntEnter", GetPVarInt(toplayerid, "IntEnter"));
      		SetPVarInt(targetid, "BizzEnter", GetPVarInt(toplayerid, "BizzEnter"));
      		SetPVarInt(targetid, "HouseEnter", GetPVarInt(toplayerid, "HouseEnter"));
      		SetPVarInt(targetid, "GarageEnter", GetPVarInt(toplayerid, "GarageEnter"));
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
COMMAND:aflist(playerid, params[])
{
	new id,string[128],sendername[MAX_PLAYER_NAME];
	if(sscanf(params, "i", id)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /aflist [factionid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if(GetPVarInt(playerid, "Admin") >= 1)
		{
		    SendClientMessage(playerid, COLOR_WHITE, "Faction Members Online:");
            foreach(new i : Player)
	        {
	            if(GetPVarInt(i, "PlayerLogged") == 1 && GetPVarInt(i, "Member") == id)
	            {
	                format(sendername, sizeof(sendername), "%s", PlayerName(i));
      		        GiveNameSpace(sendername);
                    format(string, sizeof(string), "%s, Rank: %d.", sendername, GetPVarInt(i, "Rank"));
                    SendClientMessage(playerid, COLOR_WHITE, string);
	            }
	        }
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
COMMAND:forceincar(playerid, params[])
{
	new targetid,vehicleid,seatid;
	if(sscanf(params, "uii", targetid, vehicleid, seatid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /forceincar [playerid] [vehicleid] [seatid]");
	else
	{
	    if(GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
		if(GetPVarInt(playerid, "Admin") >= 4) PutPlayerInVehicleEx(targetid, vehicleid, seatid);
		else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
COMMAND:freeze(playerid, params[])
{
	new targetid,string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "u", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /freeze [playerid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
		if(GetPVarInt(playerid, "Admin") >= 1)
		{
   			format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
      		format(giveplayer, sizeof(giveplayer), "%s", PlayerName(targetid));
      		GiveNameSpace(sendername);
      		GiveNameSpace(giveplayer);
      		if(GetPVarInt(playerid, "AHide") > 0 || GetPVarInt(playerid, "Admin") >= 11) sendername = "Hidden";
      		format(string, sizeof(string), "AdmCmd: %s was frozen by %s.", giveplayer, sendername);
      		SendAdminMessage(COLOR_LIGHTRED,string);
      		TogglePlayerControllableEx(targetid,false);
      		GameTextForPlayer(targetid, "~w~Frozen", 5000, 3);
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
COMMAND:unfreeze(playerid, params[])
{
	new targetid,string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "u", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /unfreeze [playerid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
		if(GetPVarInt(playerid, "Admin") >= 1 || GetPVarInt(playerid, "Helper") >= 1)
		{
   			format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
      		format(giveplayer, sizeof(giveplayer), "%s", PlayerName(targetid));
      		GiveNameSpace(sendername);
      		GiveNameSpace(giveplayer);
      		if(GetPVarInt(playerid, "AHide") > 0 || GetPVarInt(playerid, "Admin") >= 11) sendername = "Hidden";
      		format(string, sizeof(string), "AdmCmd: %s was Un-frozen by %s.", giveplayer, sendername);
      		SendAdminMessage(COLOR_LIGHTRED,string);
      		TogglePlayerControllableEx(targetid,true);
      		GameTextForPlayer(targetid, "~w~Un-Frozen", 5000, 3);
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
COMMAND:mute(playerid, params[])
{
	new targetid,string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "u", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /mute [playerid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
		if(GetPVarInt(playerid, "Admin") >= 1)
		{
   			format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
      		format(giveplayer, sizeof(giveplayer), "%s", PlayerName(targetid));
      		GiveNameSpace(sendername);
      		GiveNameSpace(giveplayer);
      		if(GetPVarInt(playerid, "AHide") > 0 || GetPVarInt(playerid, "Admin") >= 11) sendername = "Hidden";
      		format(string, sizeof(string), "AdmCmd: %s was silenced by %s.", giveplayer, sendername);
      		SendAdminMessage(COLOR_LIGHTRED,string);
      		SetPVarInt(targetid, "Mute", 1);
      		GameTextForPlayer(targetid, "~w~Silenced", 5000, 3);
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
COMMAND:unmute(playerid, params[])
{
	new targetid,string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "u", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /unmute [playerid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
		if(GetPVarInt(playerid, "Admin") >= 1)
		{
   			format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
      		format(giveplayer, sizeof(giveplayer), "%s", PlayerName(targetid));
      		GiveNameSpace(sendername);
      		GiveNameSpace(giveplayer);
      		if(GetPVarInt(playerid, "AHide") > 0 || GetPVarInt(playerid, "Admin") >= 11) sendername = "Hidden";
      		format(string, sizeof(string), "AdmCmd: %s was un-silenced by %s.", giveplayer, sendername);
      		SendAdminMessage(COLOR_LIGHTRED,string);
      		SetPVarInt(targetid, "Mute", 0);
      		GameTextForPlayer(targetid, "~w~Un-Silenced", 5000, 3);
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
COMMAND:getip(playerid, params[])
{
	new targetid,string[128],giveplayer[MAX_PLAYER_NAME],playersip[128];
	if(sscanf(params, "u", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /getip [playerid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
		if(GetPVarInt(playerid, "Admin") >= 1 || GetPVarInt(playerid, "Reg") > 0)
		{
      		format(giveplayer, sizeof(giveplayer), "%s", PlayerName(targetid));
      		GiveNameSpace(giveplayer);
      		GetPlayerIp(targetid,playersip,sizeof(playersip));
            format(string, sizeof(string), "Player: %s - ID: %d - IP: %ss",giveplayer,targetid,playersip);
			SendClientMessage(playerid,COLOR_GREY,string);
		}
		else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
ALTCOMMAND:al->alist;
COMMAND:alist(playerid, params[])
{
    new admtext[128],sendername[MAX_PLAYER_NAME],string[128];
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Admin") < 1) return SendClientMessage(playerid, COLOR_WHITE, "You do not have access to this command.");
    SendClientMessage(playerid, COLOR_WHITE, "__________________________________________________");
    SendClientMessage(playerid, COLOR_WHITE, "                         Admins List :");
    foreach(new i : Player)
    {
        if(GetPVarInt(i, "Admin") >= 1 && GetPVarInt(i, "Admin") < 1337)
        {
            switch(GetPVarInt(i, "Admin"))
            {
                case 11: admtext = "Hidden Lead";
                case 10: admtext = "Lead Administrator";
                case 4 .. 9: admtext = "Senior Administrator";
                case 3: admtext = "Level 3 Administrator";
                case 2: admtext = "Level 2 Administrator";
                case 1: admtext = "Level 1 Moderator";
            }
            format(sendername, sizeof(sendername), "%s", PlayerName(i));
      		GiveNameSpace(sendername);
			switch(GetPVarInt(i, "AHide"))
			{
			    case 0:
			    {
			        format(string, sizeof(string), "%s: %s [ID: %d]", admtext, AdminName(i), i);
		     	    SendClientMessage(playerid, COLOR_FADE, string);
			    }
			    case 1:
			    {
			        format(string, sizeof(string), "%s: %s [ID: %d] (Hidden)", admtext, AdminName(i), i);
		     	    SendClientMessage(playerid, COLOR_LIGHTRED, string);
			    }
			}
        }
    }
    SendClientMessage(playerid, COLOR_WHITE, "__________________________________________________");
	return 1;
}
//============================================//
COMMAND:admins(playerid, params[])
{
    new string[128], admtext[128];
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    new found = GetAdminCount(2);
    if(found == 0) return SendClientMessage(playerid, 0x8080FF96, "(( There are no admins currently on-duty. ))");
    else
    {
        SendClientMessage(playerid, COLOR_WHITE, "__________________________________________________");
        SendClientMessage(playerid, COLOR_WHITE, "                         Admins Online:");
        foreach(new i : Player)
        {
            if(GetPVarInt(i, "Admin") >= 1 && GetPVarInt(i, "Admin") < 1337)
            {
                switch(GetPVarInt(i, "Admin"))
                {
                    case 11: admtext = "Hidden Lead";
                    case 10: admtext = "Lead Administrator";
                    case 4 .. 9: admtext = "Senior Administrator";
                    case 3: admtext = "Level 3 Administrator";
                    case 2: admtext = "Level 2 Administrator";
                    case 1: admtext = "Level 1 Moderator";
                }
			    format(string, sizeof(string), "%s: %s", admtext, AdminName(i));
			    if(GetPVarInt(i, "AHide") > 0 || GetPVarInt(i, "AFKTime") > 300) { string="Hidden Admin"; }
		        if(GetPVarInt(i, "AHide") != 2) { SendClientMessage(playerid, COLOR_FADE, string); }
            }
        }
        SendClientMessage(playerid, COLOR_WHITE, "__________________________________________________");
	    SendClientMessage(playerid, 0x8080FF96, "Type (/ra) for any administrative assistance and (/report) for rulebreakers!");
	}
	return 1;
}
//============================================//
COMMAND:ara(playerid, params[])
{
	new targetid,string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "u", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /ara [playerid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
	    if(GetPVarInt(targetid, "ReqAdmin") == 0) return SendClientMessage(playerid, COLOR_GREY, "This player's request time has dropped or he never requested!");
		if(GetPVarInt(playerid, "Admin") >= 1)
		{
   			format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
      		format(giveplayer, sizeof(giveplayer), "%s", PlayerName(targetid));
      		GiveNameSpace(sendername);
      		GiveNameSpace(giveplayer);
      		format(string, sizeof(string), "AdmCmd: %s has accepted %s's admin request.", AdminName(playerid), giveplayer);
      		SendAdminMessage(COLOR_YELLOW,string);
      		format(string, sizeof(string), "You accepted %s's request.", giveplayer);
      		SendClientMessage(playerid,COLOR_GREEN,string);
      		format(string, sizeof(string), "Admin %s has accepted your request.", AdminName(playerid));
      		SendClientMessage(targetid,COLOR_GREEN,string);
      		SetPVarInt(targetid, "ReqAdmin", 0);
		}
		else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
ALTCOMMAND:ra->requestadmin;
ALTCOMMAND:ahelp->requestadmin;
COMMAND:requestadmin(playerid, params[])
{
    new sendername[MAX_PLAYER_NAME], string[255], count = 0, req[128];
    if(sscanf(params, "s[128]", req)) return usage(playerid, "/ra [Help Request]");
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    count = GetAdminCount(2);
    if(count == 0) return SendClientMessage(playerid, COLOR_WHITE, "All admins are currently busy, sorry!");
    if(GetPVarInt(playerid, "ReqAdmin") > GetCount()) return SendClientMessage(playerid, COLOR_GREY, "You have recently requested an admins assistance.");
    format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
    GiveNameSpace(sendername);
	format(string, 256, "%s[%d] is requesting adminassistance, REASON:[%s].", sendername, playerid, req);
	SendAdminMessage(0xFF0000FF,string);
	SendClientMessage(playerid,COLOR_GREEN,"Your request has been sent to all the online Admins.");
	SetPVarInt(playerid, "ReqAdmin", GetCount()+120000);
	return 1;
}
//============================================//
ALTCOMMAND:ar->acceptreport;
COMMAND:acceptreport(playerid, params[])
{
	new targetid,string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "u", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /acceptreport [playerid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
	    if(GetPVarInt(targetid, "Reported") == 0) return SendClientMessage(playerid, COLOR_GREY, "This player's report time has dropped or he never reported.");
		if(GetPVarInt(playerid, "Admin") >= 1)
		{
   			format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
      		format(giveplayer, sizeof(giveplayer), "%s", PlayerName(targetid));
      		GiveNameSpace(sendername);
      		GiveNameSpace(giveplayer);
      		if(GetPVarInt(playerid, "AHide") > 0 || GetPVarInt(playerid, "Admin") >= 11) sendername = "Hidden";
      		format(string, sizeof(string), "AdmCmd: %s has accepted %s's report.", AdminName(playerid), giveplayer);
      		SendAdminMessage(COLOR_YELLOW,string);
      		format(string, sizeof(string), "You accepted %s's reported.", giveplayer);
      		SendClientMessage(playerid,COLOR_GREEN,string);
      		format(string, sizeof(string), "Admin %s has accepted your report.", AdminName(playerid));
      		SendClientMessage(targetid,COLOR_GREEN,string);
      		SetPVarInt(targetid, "Reported", 0);
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
ALTCOMMAND:tr->trashreport;
COMMAND:trashreport(playerid, params[])
{
	new targetid,string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "u", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /trashreport [playerid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
	    if(GetPVarInt(targetid, "Reported") == 0) return SendClientMessage(playerid, COLOR_GREY, "This player's report time has dropped or he never reported.");
		if(GetPVarInt(playerid, "Admin") >= 1)
		{
   			format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
      		format(giveplayer, sizeof(giveplayer), "%s", PlayerName(targetid));
      		GiveNameSpace(sendername);
      		GiveNameSpace(giveplayer);
      		if(GetPVarInt(playerid, "AHide") > 0 || GetPVarInt(playerid, "Admin") >= 11) sendername = "Hidden";
      		format(string, sizeof(string), "AdmCmd: %s has trashed %s's report.", AdminName(playerid), giveplayer);
      		SendAdminMessage(COLOR_YELLOW,string);
      		format(string, sizeof(string), "You trashed %s's reported.", giveplayer);
      		SendClientMessage(playerid,COLOR_GREEN,string);
      		format(string, sizeof(string), "Admin %s has trashed your report.", AdminName(playerid));
      		SendClientMessage(targetid,COLOR_GREEN,string);
      		SetPVarInt(targetid, "Reported", 0);
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
COMMAND:mreport(playerid, params[])
{
	new text[128],targetid,string[255],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "is[128]", targetid, text)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /mreport [maskid] [reason]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Reported") > GetCount()) return SendClientMessage(playerid, COLOR_GREY, "You have recently reported.");
	    new findid = 500;
	    foreach(new i : Player)
	    {
	        if(GetPVarInt(i, "MaskID") == targetid)
	        {
	            findid=i;
	        }
	    }
	    if(findid == playerid) return SendClientMessage(playerid,COLOR_WHITE,"You can't report yourself.");
	    if(findid == 500) return SendClientMessage(playerid,COLOR_WHITE,"There is no one with that mask-id online.");
   		format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
      	format(giveplayer, sizeof(giveplayer), "%s", PlayerName(findid));
      	GiveNameSpace(sendername);
      	GiveNameSpace(giveplayer);
      	format(string, sizeof(string), "REPORT: %s [ID:%d] has reported %s [ID:%d].", sendername, playerid, giveplayer, findid);
		SendAdminMessage(0xE19898AA,string);
		format(string, sizeof(string), "REPORT: Reason: %s.", text);
		SendAdminMessage(0xE19898AA,string);
		format(string, sizeof(string), "REPORT: Use /acceptreport %d or /trashreport %d for this report.", playerid, playerid);
		SendAdminMessage(0xE19898AA,string);
		SendClientMessage(playerid,COLOR_GREEN,"Your report has been sent to all the online Admins.");
		SetPVarInt(playerid, "Reported", GetCount()+120000);

	}
	return 1;
}
//============================================//
COMMAND:report(playerid, params[])
{
	new text[128],targetid,string[255],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "us[128]", targetid, text)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /report [playerid] [reason]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (playerid == targetid) return SendClientMessage(playerid, COLOR_GREY, "You cannot do this to yourself.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
	    if(GetPVarInt(playerid, "Reported") > GetCount()) return SendClientMessage(playerid, COLOR_GREY, "You have recently reported.");
   		format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
      	format(giveplayer, sizeof(giveplayer), "%s", PlayerName(targetid));
      	GiveNameSpace(sendername);
      	GiveNameSpace(giveplayer);
      	format(string, sizeof(string), "REPORT: %s [ID:%d] has reported %s [ID:%d].", sendername, playerid, giveplayer, targetid);
		SendAdminMessage(0xE19898AA,string);
		format(string, sizeof(string), "REPORT: Reason: %s.", text);
		SendAdminMessage(0xE19898AA,string);
		format(string, sizeof(string), "REPORT: Use /acceptreport %d or /trashreport %d for this report.", playerid, playerid);
		SendAdminMessage(0xE19898AA,string);
		SendClientMessage(playerid,COLOR_GREEN,"Your report has been sent to all the online Admins.");
		SetPVarInt(playerid, "Reported", GetCount()+120000);

	}
	return 1;
}
//============================================//
COMMAND:skick(playerid, params[])
{
	new text[128],targetid,string[255],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "us[128]", targetid, text)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /skick [playerid] [reason]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (playerid == targetid) return SendClientMessage(playerid, COLOR_GREY, "You cannot do this to yourself.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
	    if(IsPlayerNPC(targetid)) return SendClientMessage(playerid, COLOR_GREY, "Can't do this to a NPC.");
	    if(GetPVarInt(playerid, "Admin") <= 4 && GetPVarInt(targetid, "Admin") >= 1 && GetPVarInt(targetid, "Admin") <= 10) return SendClientMessage(playerid, COLOR_GREY, "You can't kick admins.");
		if(GetPVarInt(playerid, "Admin") >= 1)
		{
   			format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
      		format(giveplayer, sizeof(giveplayer), "%s", PlayerName(targetid));
      		GiveNameSpace(sendername);
      		GiveNameSpace(giveplayer);
      		if(GetPVarInt(playerid, "AHide") > 0 || GetPVarInt(playerid, "Admin") >= 11) sendername = "Hidden";
      		format(string, sizeof(string), "AdmCmd: %s was kicked by Admin %s Reason:[%s].", giveplayer, AdminName(playerid), text);
			SendAdminMessage(COLOR_YELLOW, string);
			format(string, sizeof(string), "You were silent-kicked for the reason: [%s].", text);
			SendClientMessage(targetid, COLOR_WHITE, string);
			SetPVarInt(targetid, "Kicks", GetPVarInt(targetid, "Kicks")+1);
			new query[516];
			new year,month,day, datum[64];
			getdate(year, month, day);
			format(datum, sizeof(datum), "%d-%d-%d", year, month, day);
			if(strfind(text, "afk", true) != -1)
			{
				format(query, sizeof(query),"INSERT INTO `logs_kicks`(`Name`, `Admin`, `Reason`, `Date`) VALUES ('%s','%s','%s','%s')", giveplayer, AdminName(playerid), text, datum);
			}
			else
			{
			    format(query, sizeof(query),"INSERT INTO `logs_kicks`(`Name`, `Admin`, `Reason`, `Date`, `afk`) VALUES ('%s','%s','%s','%s', 1)", giveplayer, AdminName(playerid), text, datum);
			}
			mysql_tquery(handlesql, query);
			KickPlayer(targetid, "");
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
COMMAND:disarm(playerid, params[])
{
	new targetid,string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "u", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /disarm [playerid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
		if(GetPVarInt(playerid, "Admin") >= 2)
		{
   			format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
      		format(giveplayer, sizeof(giveplayer), "%s", PlayerName(targetid));
      		GiveNameSpace(sendername);
      		GiveNameSpace(giveplayer);
      		if(GetPVarInt(playerid, "AHide") > 0 || GetPVarInt(playerid, "Admin") >= 11) sendername = "Hidden";
      		format(string, sizeof(string), "AdmCmd: %s was disarmed by %s.", giveplayer, sendername);
      		SendAdminMessage(COLOR_LIGHTRED,string);
      		ResetPlayerWeaponsEx(targetid);
      		ResetPlayerWeapons(targetid);
		}
		else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}//============================================//
COMMAND:clearinv(playerid, params[])
{
	new targetid,string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "u", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /clearinv [playerid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
		if(GetPVarInt(playerid, "Admin") >= 2)
		{
   			format(sendername, sizeof(sendername), "%s", PlayerInfo[playerid][pUsername]);
      		format(giveplayer, sizeof(giveplayer), "%s", PlayerInfo[targetid][pUsername]);
      		GiveNameSpace(sendername);
      		GiveNameSpace(giveplayer);
      		if(GetPVarInt(playerid, "AHide") > 0 || GetPVarInt(playerid, "Admin") >= 11) sendername = "Hidden";
      		format(string, sizeof(string), "AdmCmd: %s was clear-inved by %s.", giveplayer, sendername);
      		SendAdminMessage(COLOR_LIGHTRED,string);
      		ClearInvWeapons(targetid);
		}
		else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
COMMAND:clearbizzfurn(playerid, params[])
{
	new id,string[128],sendername[MAX_PLAYER_NAME];
	if(sscanf(params, "i", id)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /clearbizzfurn [bizzid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if(GetPVarInt(playerid, "Admin") >= 4)
		{
   			format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
      		GiveNameSpace(sendername);
      		if(GetPVarInt(playerid, "AHide") > 0 || GetPVarInt(playerid, "Admin") >= 11) sendername = "Hidden";
      		format(string, sizeof(string), "AdmCmd: %s cleared bizzID %d's furniture.", sendername, id);
      		SendAdminMessage(COLOR_LIGHTRED,string);
      		RemoveBizzObjects(id);
		}
		else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
COMMAND:clearhousefurn(playerid, params[])
{
	new id,string[128],sendername[MAX_PLAYER_NAME];
	if(sscanf(params, "i", id)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /clearhousefurn [houseid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if(GetPVarInt(playerid, "Admin") >= 4)
		{
   			format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
      		GiveNameSpace(sendername);
      		if(GetPVarInt(playerid, "AHide") > 0 || GetPVarInt(playerid, "Admin") >= 11) sendername = "Hidden";
      		format(string, sizeof(string), "AdmCmd: %s cleared houseID %d's furniture.", sendername, id);
      		SendAdminMessage(COLOR_LIGHTRED,string);
      		RemoveHouseObject(id);
		}
		else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
COMMAND:kick(playerid, params[])
{
	new text[128],targetid,string[255],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "us[128]", targetid, text)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /kick [playerid] [reason]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
		if(GetPVarInt(targetid, "Admin") > 7 && GetPVarInt(playerid, "Admin") < GetPVarInt(targetid, "Admin")) return nal(playerid);
	    if(IsPlayerNPC(targetid)) return SendClientMessage(playerid, COLOR_GREY, "Can't do this to a NPC.");
		if(GetPVarInt(playerid, "Admin") >= 1)
		{
   			format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
      		format(giveplayer, sizeof(giveplayer), "%s", PlayerName(targetid));
      		GiveNameSpace(sendername);
      		GiveNameSpace(giveplayer);
      		if(GetPVarInt(playerid, "AHide") > 0 || GetPVarInt(playerid, "Admin") >= 11) sendername = "Hidden";
      		format(string, sizeof(string), "AdmCmd: %s was kicked by Admin %s Reason:[%s].", giveplayer, AdminName(playerid), text);
			SendClientMessageToAll(COLOR_LIGHTRED, string);
			SetPVarInt(targetid, "Kicks", GetPVarInt(targetid, "Kicks")+1);
			KickPlayer(targetid, "");
			new query[516];
			new year,month,day, datum[64];
			getdate(year, month, day);
			format(datum, sizeof(datum), "%d-%d-%d", year, month, day);
			if(strfind(text, "afk", true) != -1)
			{
				format(query, sizeof(query),"INSERT INTO `logs_kicks`(`Name`, `Admin`, `Reason`, `Date`) VALUES ('%s','%s','%s','%s')", giveplayer, AdminName(playerid), text, datum);
			}
			else
			{
			    format(query, sizeof(query),"INSERT INTO `logs_kicks`(`Name`, `Admin`, `Reason`, `Date`, `afk`) VALUES ('%s','%s','%s','%s', 1)", giveplayer, AdminName(playerid), text, datum);
			}
			mysql_tquery(handlesql, query);
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
COMMAND:check(playerid, params[])
{
	new targetid, string[128];
	if(sscanf(params, "u", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /check [playerid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
		if(GetPVarInt(playerid, "Admin") >= 1 || GetPVarInt(playerid, "Helper") >= 1)
		{
		    PrintStats(targetid, playerid);
		    switch(GetPVarInt(targetid, "Jailed"))
			{
			    case 1:
			    {
			        format(string, sizeof(string), "AJAIL: %d Seconds", GetPVarInt(targetid, "JailTime"));
	                SendClientMessage(playerid,COLOR_LIGHTRED,string);
			    }
			    case 3:
			    {
			        format(string, sizeof(string), "COUNTY JAIL: %d Seconds", GetPVarInt(targetid, "JailTime"));
	                SendClientMessage(playerid,COLOR_LIGHTRED,string);
			    }
			}
		}
		else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
COMMAND:setint(playerid, params[])
{
	new targetid,type,string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "ui", targetid, type)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /setint [playerid] [interior]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
	    if(type < 0 || type > 1000) return SendClientMessage(playerid, COLOR_GREY, "Cannot go under 0 or above 1000.");
	    if(IsPlayerNPC(targetid)) return SendClientMessage(playerid, COLOR_GREY, "Can't do this to a NPC.");
		if(GetPVarInt(playerid, "Admin") >= 1 || GetPVarInt(playerid, "Helper") >= 1)
		{
   			format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
      		format(giveplayer, sizeof(giveplayer), "%s", PlayerName(targetid));
      		GiveNameSpace(sendername);
      		GiveNameSpace(giveplayer);
      		if(GetPVarInt(playerid, "AHide") > 0 || GetPVarInt(playerid, "Admin") >= 11) sendername = "Hidden";
      		SetPlayerInterior(targetid,type);
      		format(string, sizeof(string),"Admin/Helper %s has set your interior to %d", sendername, type);
      		SendClientMessage(targetid,COLOR_GREY,string);
      		format(string, sizeof(string),"You have set %s's interior to %d", giveplayer, type);
      		SendClientMessage(playerid,COLOR_GREY,string);
      		if(GetPVarInt(playerid, "Helper") > 0)
      		{
      		    format(string, sizeof(string),"HelpCmd: Helper %s has set %s's interior to %d", sendername, giveplayer, type);
      		    SendAdminMessage(COLOR_YELLOW,string);
      		}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
COMMAND:setvw(playerid, params[])
{
	new targetid,type,string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "ui", targetid, type)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /setvw [playerid] [world]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
	    if(type < 0 || type > 1000) return SendClientMessage(playerid, COLOR_GREY, "Cannot go under 0 or above 1000.");
	    if(IsPlayerNPC(targetid)) return SendClientMessage(playerid, COLOR_GREY, "Can't do this to a NPC.");
		if(GetPVarInt(playerid, "Admin") >= 1 || GetPVarInt(playerid, "Helper") >= 1)
		{
   			format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
      		format(giveplayer, sizeof(giveplayer), "%s", PlayerName(targetid));
      		GiveNameSpace(sendername);
      		GiveNameSpace(giveplayer);
      		if(GetPVarInt(playerid, "AHide") > 0 || GetPVarInt(playerid, "Admin") >= 11) sendername = "Hidden";
      		SetPlayerVirtualWorld(targetid,type);
      		format(string, sizeof(string),"Admin/Helper %s has set your world to %d", sendername, type);
      		SendClientMessage(targetid,COLOR_GREY,string);
      		format(string, sizeof(string),"You have set %s's world to %d", giveplayer, type);
      		SendClientMessage(playerid,COLOR_GREY,string);
      		if(GetPVarInt(playerid, "Helper") > 0)
      		{
      		    format(string, sizeof(string),"HelpCmd: Helper %s has set %s's world to %d", sendername, giveplayer, type);
      		    SendAdminMessage(COLOR_YELLOW,string);
      		}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
COMMAND:setskin(playerid, params[])
{
	new targetid,type,string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "ui", targetid, type)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /setskin [playerid] [amount]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
	    if(GetPVarInt(playerid, "Admin") == 0 && IsPlayerNPC(targetid)) return SendClientMessage(playerid, COLOR_GREY, "Can't do this to a NPC.");
	    if(type < 0 || type > 311) return SendClientMessage(playerid, COLOR_GREY, "Cannot go under 0 or above 299.");//////////////////
		if(GetPVarInt(playerid, "Admin") >= 1 || GetPVarInt(playerid, "Helper") >= 1)
		{
		    if(GetPVarInt(playerid, "Admin") < 1 && GetPVarInt(targetid, "Member") != 1 &&GetPVarInt(targetid, "Member") != 2) return error(playerid, "Only officers/LSFD can be changed by helpers.");
   			format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
      		format(giveplayer, sizeof(giveplayer), "%s", PlayerName(targetid));
      		GiveNameSpace(sendername);
      		GiveNameSpace(giveplayer);
      		if(GetPVarInt(playerid, "AHide") > 0 || GetPVarInt(playerid, "Admin") >= 11) sendername = "Hidden";
      		SetPlayerSkinEx(targetid,type);
      		SetPVarInt(targetid, "Model", type);
      		format(string, sizeof(string),"%s has set your skin to %d", sendername, type);
      		SendClientMessage(targetid,COLOR_GREY,string);
      		format(string, sizeof(string),"You set %s's skin to %d", giveplayer, type);
      		SendClientMessage(playerid,COLOR_GREY,string);
      		OnPlayerDataSave(targetid);
		}
		else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
COMMAND:goto(playerid, params[])
{
	new targetid;
	if(sscanf(params, "u", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /goto [playerid]");
	if(IsPlayerNPC(targetid)) return SendClientMessage(playerid, COLOR_GREY, "Can't do this to a NPC.");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
		if(GetPVarInt(playerid, "Admin") >= 1)
		{
			new Float:x,Float:y,Float:z;
			GetPlayerPos(targetid,x,y,z);	
			new vw = GetPlayerVirtualWorld(targetid), int = GetPlayerInterior(targetid);
			Streamer_UpdateEx(playerid, x, y+2, z, vw, int);
			if(IsPlayerInAnyVehicle(playerid))
		    {
                SetVehiclePosEx(GetPlayerVehicleID(playerid),x,y+4,z);
      		    SetPlayerVirtualWorld(playerid,vw);
      		    SetPlayerInterior(playerid,int);
      		    LinkVehicleToInteriorEx(GetPlayerVehicleID(playerid),int);
      		    SetVehicleVirtualWorldEx(GetPlayerVehicleID(playerid),vw);
	    	}
		    else
		    {				
				if(vw != 0 || int != 0) TempFreeze(playerid);
		        SetPlayerPosEx(playerid,x,y+2,z);
      		    SetPlayerVirtualWorld(playerid,vw);
      		    SetPlayerInterior(playerid,int);
		    }
      		SendClientMessage(playerid,COLOR_GREY,"You have been teleported.");

			SetPVarInt(playerid, "IntEnter", GetPVarInt(targetid, "IntEnter"));
      		SetPVarInt(playerid, "BizzEnter", GetPVarInt(targetid, "BizzEnter"));
      		SetPVarInt(playerid, "HouseEnter", GetPVarInt(targetid, "HouseEnter"));
      		SetPVarInt(playerid, "GarageEnter", GetPVarInt(targetid, "GarageEnter"));
			PlayerInfo[playerid][pInVehicle] = PlayerInfo[targetid][pInVehicle];
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
ALTCOMMAND:bring->gethere;
COMMAND:gethere(playerid, params[])
{
	new targetid;
	if(sscanf(params, "u", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /gethere [playerid]");
	if(IsPlayerNPC(targetid)) return SendClientMessage(playerid, COLOR_GREY, "Can't do this to a NPC.");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
		if(GetPVarInt(playerid, "Admin") >= 2)
		{
			new Float:x,Float:y,Float:z;
			GetPlayerPos(playerid,x,y,z);
			new vw = GetPlayerVirtualWorld(playerid), int = GetPlayerInterior(playerid);
			Streamer_UpdateEx(targetid, x, y+2, z, vw, int);
			if(IsPlayerInAnyVehicle(targetid))
		    {
                SetVehiclePosEx(GetPlayerVehicleID(targetid),x,y+4,z);
      		    SetPlayerVirtualWorld(targetid,vw);
      		    SetPlayerInterior(targetid,int);
      		    LinkVehicleToInteriorEx(GetPlayerVehicleID(targetid),int);
      		    SetVehicleVirtualWorldEx(GetPlayerVehicleID(targetid),vw);
	    	}
		    else
		    {
				if(vw != 0 || int != 0) TempFreeze(targetid);
		        SetPlayerPosEx(targetid,x,y+2,z);
      		    SetPlayerVirtualWorld(targetid,vw);
      		    SetPlayerInterior(targetid,int);
		    }
      		SendClientMessage(targetid,COLOR_GREY,"You have been teleported.");
      		SetPVarInt(targetid, "IntEnter", GetPVarInt(playerid, "IntEnter"));
      		SetPVarInt(targetid, "BizzEnter", GetPVarInt(playerid, "BizzEnter"));
      		SetPVarInt(targetid, "HouseEnter", GetPVarInt(playerid, "HouseEnter"));
      		SetPVarInt(targetid, "GarageEnter", GetPVarInt(playerid, "GarageEnter"));
			PlayerInfo[targetid][pInVehicle] = PlayerInfo[playerid][pInVehicle];
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
COMMAND:mark(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Admin") >= 2)
	{
	    new Float:x,Float:y,Float:z;
	    GetPlayerPos(playerid,x,y,z);
	    SetPVarFloat(playerid,"MarkX",x);
	    SetPVarFloat(playerid,"MarkY",y);
	    SetPVarFloat(playerid,"MarkZ",z);
	    SendClientMessage(playerid,COLOR_GREY,"Marker created, /gotomark useable.");
    }
    else
	{
	    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
COMMAND:gotomark(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Admin") >= 1)
	{
	    if(IsPlayerInAnyVehicle(playerid))
		{
            SetVehiclePosEx(GetPlayerVehicleID(playerid),GetPVarFloat(playerid,"MarkX"),GetPVarFloat(playerid,"MarkY"),GetPVarFloat(playerid,"MarkZ"));
			PlayerInfo[playerid][pInVehicle] = -1;
		}
		else
		{
		    SetPlayerPosEx(playerid,GetPVarFloat(playerid,"MarkX"),GetPVarFloat(playerid,"MarkY"),GetPVarFloat(playerid,"MarkZ"));
		    SetPlayerInterior(playerid,0);
		    SetPlayerVirtualWorld(playerid,0);
		}
    }
    else
	{
	    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
COMMAND:despawncar(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOR_WHITE, "You must be in a vehicle to use this!");
    if(GetPVarInt(playerid, "Admin") >= 1) {
        DespawnVehicle(GetPlayerVehicleID(playerid));
	    SendClientMessage(playerid, COLOR_WHITE, "Vehicle destroyed.");
    }
    else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	return 1;
}
//============================================//
COMMAND:despawnvehicle(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Admin") >= 1) {
		new vehicleid;
		if(sscanf(params, "i", vehicleid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /despawnvehicle [vehicleid] (Use /dl to see vehicle IDs.)");
		else {
			foreach(new car : Vehicle) {
				if(car == vehicleid) {
					DespawnVehicle(vehicleid);
					return SendClientMessage(playerid, COLOR_WHITE, "Vehicle destroyed.");
				}
			}
			SendClientMessage(playerid, COLOR_GREY, "No vehicle could be found with this ID.");
		}
    }
    else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	return 1;
}
//============================================//
COMMAND:rcc(playerid, params[])
{
	new string[128];
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Admin") >= 2)
	{
	    if(PlayerToCar(playerid,1,5.0))
	    {
			new vehicleid = PlayerToCar(playerid,2,5.0);
	        SetVehicleToRespawn(vehicleid);
	        if(VehicleInfo[vehicleid][vID] != 0)
	        {
	            if(VehicleInfo[vehicleid][vCreated] == 1 && VehicleInfo[vehicleid][vInterior] == 0) {
                    DespawnVehicle(GetPlayerVehicleID(playerid));
	            }
	        }
	        format(string, sizeof(string),"Car-ID:%d - respawned.",vehicleid);
	        SendClientMessage(playerid, COLOR_WHITE, string);
	    }
	    else
	    {
	        SendClientMessage(playerid, COLOR_LIGHTRED, "WARNING: You are not close to any vehicle.");
	    }
    }
    else
	{
	    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
COMMAND:rtc(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOR_WHITE, "You must be in a vehicle to use this!");
    if(GetPVarInt(playerid, "Admin") >= 1)
	{
	    SetVehicleToRespawn(GetPlayerVehicleID(playerid));
	    SendClientMessage(playerid,COLOR_WHITE,"Vehicle respawned.");
    }
    else
	{
	    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
COMMAND:aarmour(playerid, params[])
{
	new type;
	if(sscanf(params, "ii", type)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /aarmour [amount]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if(GetPVarInt(playerid, "Admin") >= 7)
		{
      		SetPlayerArmourEx(playerid,type);
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
COMMAND:ahealth(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Admin") >= 7)
	{
	    SetPlayerHealth(playerid,99.0);
    }
    else
	{
	    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
COMMAND:weatherall(playerid, params[])
{
	new id,string[128],sendername[MAX_PLAYER_NAME];
	if(sscanf(params, "i", id)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /weatherall [id]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if(GetPVarInt(playerid, "Admin") >= 3)
		{
   			format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
      		GiveNameSpace(sendername);
      		if(GetPVarInt(playerid, "AHide") > 0 || GetPVarInt(playerid, "Admin") >= 11) sendername = "Hidden";
      		format(string, sizeof(string), "AdmCmd: %s has set the weather to %d for everyone.", sendername, id);
      		SendAdminMessage(COLOR_LIGHTRED,string);
      		SetWeatherEx(id);
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
COMMAND:weather(playerid, params[])
{
	new id,string[128],sendername[MAX_PLAYER_NAME];
	if(sscanf(params, "i", id)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /weatherall [id]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if(GetPVarInt(playerid, "Admin") >= 4)
		{
   			format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
      		GiveNameSpace(sendername);
      		if(GetPVarInt(playerid, "AHide") > 0 || GetPVarInt(playerid, "Admin") >= 11) sendername = "Hidden";
      		format(string, sizeof(string), "AdmCmd: %s has set their weather to %d.", sendername, id);
      		SendAdminMessage(COLOR_LIGHTRED,string);
      		SetPlayerWeather(playerid,id);
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
COMMAND:aveh(playerid, params[])
{
	new type;
	if(sscanf(params, "i", type)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /aveh [Vehicle-ID]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if(GetPVarInt(playerid, "Admin") >= 7)
		{
			new Float:X,Float:Y,Float:Z,vehicleid;
			GetPlayerPos(playerid,X,Y,Z);
			vehicleid = AddStaticVehicleEx(type,X,Y,Z,90.7350, -1, -1, 999999);
			VehicleInfo[vehicleid][vFuel]=100;
			VehicleInfo[vehicleid][vWindows]=0;
			VehicleInfo[vehicleid][vEngine]=0;
			VehicleInfo[vehicleid][vType]=VEHICLE_ADMIN;
			Iter_Add(Vehicle, vehicleid);
			LinkVehicleToInteriorEx(vehicleid, GetPlayerInterior(playerid));
			SetVehicleVirtualWorldEx(vehicleid, GetPlayerVirtualWorld(playerid));
			SendClientMessage(playerid,COLOR_WHITE,"Vehicle spawned!");
		}
		else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
COMMAND:propose(playerid, params[])
{
	new targetid,string[128],sendername[MAX_PLAYER_NAME];
	if(sscanf(params, "u", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /propose [playerid] (Cost: $20,000)");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
	    if(IsPlayerNPC(targetid)) return SendClientMessage(playerid, COLOR_GREY, "Can't do this to a NPC.");
	    if(!IsPlayerInRangeOfPoint(playerid,2.0,2867.2097,1069.5339,-63.3413)) return SendClientMessage(playerid, COLOR_GREY, "You are not around the marriage checkpoint.");
	    if(strcmp(PlayerInfo[playerid][pMarriedTo], "None", true) == -1) return SendClientMessage(playerid, COLOR_GREY, "You are already married to someone.");
	    if(PlayerToPlayer(playerid,targetid,5.0))
	    {
	        if(strcmp(PlayerInfo[targetid][pMarriedTo], "None", true) == 0)
	        {
				if(GetPlayerMoneyEx(playerid) >= 20000)
				{
				    SetPVarInt(playerid, "MarriagePlayer", targetid);
				    SetPVarInt(targetid, "MarriagePlayer", playerid);
   			    	format(sendername, sizeof(sendername), "%s", PlayerName(targetid));
      		    	GiveNameSpace(sendername);
      		    	format(string, sizeof(string),"You sent a marriage proposal to %s.",sendername);
      		    	SendClientMessage(playerid,COLOR_WHITE,string);
      		    	format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
      		    	GiveNameSpace(sendername);
      		    	format(string, sizeof(string),"Would you like to marry %s?",sendername);
      		    	ShowPlayerDialog(targetid,508,DIALOG_STYLE_MSGBOX,"Marriage Propose",string,"Yes", "No");
      		    }
      		    else
      		    {
      		        SendClientMessage(playerid, COLOR_GREY, "You need $20,000 to continue.");
      		    }
      		}
      		else
      		{
      		    SendClientMessage(playerid, COLOR_GREY, "This player is already married to someone.");
      		}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_GREY, "You are not around that player.");
		}
	}
	return 1;
}
//============================================//
COMMAND:divorce(playerid, params[])
{
	new targetid,string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "ui", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /divorce [playerid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (playerid == targetid) return SendClientMessage(playerid, COLOR_GREY, "You cannot divorce to yourself.");
		if(IsPlayerConnected(targetid))
		{
		    if(PlayerToPlayer(playerid,targetid,5.0))
   			{
   			    if(strcmp(PlayerInfo[playerid][pMarriedTo], PlayerName(targetid), true) == 0) {
				SetPVarInt(targetid, "DivorceOffer", playerid);
   			    format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
	    	    format(giveplayer, sizeof(giveplayer), "%s", PlayerNameEx(targetid));
      		    GiveNameSpace(sendername);
        	    GiveNameSpace(giveplayer);
        	    format(string, sizeof(string), "You offered %s a divorce.", giveplayer);
           		SendClientMessage(playerid,COLOR_LIGHTBLUE,string);
            	format(string, sizeof(string), "%s gave you a divorce (/accept divorce).", sendername);
            	SendClientMessage(targetid,COLOR_LIGHTBLUE,string);
            	}
            	else SendClientMessage(playerid,COLOR_GREY,"This player is not married to you!");
   			}
   			else SendClientMessage(playerid,COLOR_GREY,"You are not close enough to that player!");
		}
	}
	return 1;
}
//============================================//
COMMAND:repaircar(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Admin") >= 4)
	{
	    RepairVehicle(GetPlayerVehicleID(playerid));
	    SendClientMessage(playerid,COLOR_WHITE,"Vehicle repaired.");
    }
    else
	{
	    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
COMMAND:fuelcars(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Admin") >= 4)
	{
		foreach(new c : Vehicle)
	    {
		    VehicleInfo[c][vFuel] = 100;
	    }
	    SendClientMessage(playerid,COLOR_WHITE,"All vehicles refuelled.");
    }
    else
	{
	    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
COMMAND:rac(playerid, params[])
{
	new string[128], sendername[MAX_PLAYER_NAME];
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Admin") >= 3)
	{
      	new bool:unwanted[MAX_VEHICLES];
		foreach(new player : Player)
     	{
            if(IsPlayerInAnyVehicle(player)) { unwanted[GetPlayerVehicleID(player)]=true; }
     	}
		for(new c=0; c < MAX_VEHICLES ;c++)
	    {
	        if(!unwanted[c] && GetVehicleModel(c) != 431)
	        {
			    SetVehicleToRespawn(c);
		    }
	    }
	    format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
      	GiveNameSpace(sendername);
	    format(string, sizeof(string), "All unused cars respawned by %s.", sendername);
	    SendClientMessage(playerid,COLOR_WHITE,string);
    }
    else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	return 1;
}
//============================================//
COMMAND:givemoney(playerid, params[])
{
	new targetid,type,string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "ui", targetid, type)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /givemoney [playerid] [amount]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
	    if(type < 0 || type > 99999999) return SendClientMessage(playerid, COLOR_GREY, "Cannot go under 0 or above 99999999.");
		if(GetPVarInt(playerid, "Admin") >= 10)
		{
   			format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
      		format(giveplayer, sizeof(giveplayer), "%s", PlayerName(targetid));
      		GiveNameSpace(sendername);
      		GiveNameSpace(giveplayer);
      		GivePlayerMoneyEx(targetid,type);
      		format(string, sizeof(string),"AdmCmd: %s has given %s $%d", sendername, giveplayer, type);
      		SendAdminMessage(COLOR_YELLOW,string);
			MoneyLog(string);
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
COMMAND:money(playerid, params[])
{
	new targetid,type,string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "ui", targetid, type)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /money [playerid] [amount]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
	    if(type < 0 || type > 99999999) return SendClientMessage(playerid, COLOR_GREY, "Cannot go under 0 or above 99999999.");
		if(GetPVarInt(playerid, "Admin") >= 10)
		{
   			format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
      		format(giveplayer, sizeof(giveplayer), "%s", PlayerName(targetid));
      		GiveNameSpace(sendername);
      		GiveNameSpace(giveplayer);
      		if(GetPVarInt(playerid, "AHide") > 0 || GetPVarInt(playerid, "Admin") >= 11) sendername = "Hidden";
      		SetPVarInt(targetid, "Cash", type);
      		SetSlidedMoneyBar(targetid);
      		format(string, sizeof(string),"AdmCmd: %s has set %s's money to $%d", sendername, giveplayer, type);
      		SendAdminMessage(COLOR_YELLOW,string);
			MoneyLog(string);
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "This command is RCON-only!");
		}
	}
	return 1;
}
//============================================//
COMMAND:sethp(playerid, params[])
{
	new targetid,type,string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "ui", targetid, type)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /sethp [playerid] [amount]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
		if (GetPVarInt(targetid, "Admin") > 7 && GetPVarInt(playerid, "Admin") < GetPVarInt(targetid, "Admin")) return nal(playerid);
	    if(type < 0 || type > 99) return SendClientMessage(playerid, COLOR_GREY, "Cannot go under 0 or above 99.");
		if(GetPVarInt(playerid, "Admin") >= 3)
		{
   			format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
      		format(giveplayer, sizeof(giveplayer), "%s", PlayerName(targetid));
      		GiveNameSpace(sendername);
      		GiveNameSpace(giveplayer);
      		if(GetPVarInt(playerid, "AHide") > 0 || GetPVarInt(playerid, "Admin") >= 11) sendername = "Hidden";
      		SetPlayerHealth(targetid,type);
      		format(string, sizeof(string),"AdmCmd: %s has set %s's heath to %d", sendername, giveplayer, type);
      		SendAdminMessage(COLOR_YELLOW,string);
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
COMMAND:setcarint(playerid, params[])
{
	new targetid,type,string[128],sendername[MAX_PLAYER_NAME];
	if(sscanf(params, "ii", targetid, type)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /setcarint [carid] [amount]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if(GetPVarInt(playerid, "Admin") >= 3)
		{
   			format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
      		GiveNameSpace(sendername);
      		if(GetPVarInt(playerid, "AHide") > 0 || GetPVarInt(playerid, "Admin") >= 11) sendername = "Hidden";
      		LinkVehicleToInteriorEx(targetid,type);
      		format(string, sizeof(string),"AdmCmd: %s has set carid %d int to %d", sendername, targetid, type);
      		SendAdminMessage(COLOR_YELLOW,string);
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
COMMAND:setcarhp(playerid, params[])
{
	new targetid,type,string[128],sendername[MAX_PLAYER_NAME];
	if(sscanf(params, "ii", targetid, type)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /setcarhp [carid] [amount]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if(GetPVarInt(playerid, "Admin") >= 3)
		{
   			format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
      		GiveNameSpace(sendername);
      		if(GetPVarInt(playerid, "AHide") > 0 || GetPVarInt(playerid, "Admin") >= 11) sendername = "Hidden";
      		SetVehicleHealth(targetid,type);
      		format(string, sizeof(string),"AdmCmd: %s has set carid %d heath to %d", sendername, targetid, type);
      		SendAdminMessage(COLOR_YELLOW,string);
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
COMMAND:setarmour(playerid, params[])
{
	new targetid,type,string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "ui", targetid, type)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /setarmour [playerid] [amount]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
	    if(type < 0 || type > 99) return SendClientMessage(playerid, COLOR_GREY, "Cannot go under 0 or above 99.");
		if(GetPVarInt(playerid, "Admin") >= 3)
		{
   			format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
      		format(giveplayer, sizeof(giveplayer), "%s", PlayerName(targetid));
      		GiveNameSpace(sendername);
      		GiveNameSpace(giveplayer);
      		if(GetPVarInt(playerid, "AHide") > 0 || GetPVarInt(playerid, "Admin") >= 11) sendername = "Hidden";
      		SetPlayerArmourEx(targetid,type);
      		format(string, sizeof(string),"AdmCmd: %s has set %s's armour to %d", sendername, giveplayer, type);
      		SendAdminMessage(COLOR_YELLOW,string);
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
COMMAND:setjob(playerid, params[])
{
	new targetid,type,string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "ui", targetid, type)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /setjob [playerid] [id]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
	    if(type < 0 || type > 50) return SendClientMessage(playerid, COLOR_GREY, "Cannot go under 0 or above 50.");
		if(GetPVarInt(playerid, "Admin") >= 3)
		{
   			format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
      		format(giveplayer, sizeof(giveplayer), "%s", PlayerName(targetid));
      		GiveNameSpace(sendername);
      		GiveNameSpace(giveplayer);
      		if(GetPVarInt(playerid, "AHide") > 0 || GetPVarInt(playerid, "Admin") >= 11) sendername = "Hidden";
      		SetPVarInt(targetid, "Job", type);
      		format(string, sizeof(string),"AdmCmd: %s has set %s's job to %d", sendername, giveplayer, type);
      		SendAdminMessage(COLOR_YELLOW,string);
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
COMMAND:setage(playerid, params[])
{
	new targetid,type,string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "ui", targetid, type)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /setage [playerid] [id]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
	    if(type < 0 || type > 110) return SendClientMessage(playerid, COLOR_GREY, "Cannot go under 0 or above 110.");
		if(GetPVarInt(playerid, "Admin") >= 1 || GetPVarInt(playerid, "Helper") >= 1)
		{
   			format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
      		format(giveplayer, sizeof(giveplayer), "%s", PlayerName(targetid));
      		GiveNameSpace(sendername);
      		GiveNameSpace(giveplayer);
      		if(GetPVarInt(playerid, "AHide") > 0 || GetPVarInt(playerid, "Admin") >= 11) sendername = "Hidden";
      		SetPVarInt(targetid, "Age", type);
      		format(string, sizeof(string),"AdmCmd: %s has set %s's age to %d", sendername, giveplayer, type);
      		SendAdminMessage(COLOR_YELLOW,string);
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
COMMAND:setsex(playerid, params[])
{
	new targetid,type,string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "ui", targetid, type)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /setsex [playerid] [0-1]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
	    if(type < 0 || type > 2) return SendClientMessage(playerid, COLOR_GREY, "Cannot go under 0 or above 2.");
		if(GetPVarInt(playerid, "Admin") >= 1 || GetPVarInt(playerid, "Helper") >= 1)
		{
   			format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
      		format(giveplayer, sizeof(giveplayer), "%s", PlayerName(targetid));
      		GiveNameSpace(sendername);
      		GiveNameSpace(giveplayer);
      		if(GetPVarInt(playerid, "AHide") > 0 || GetPVarInt(playerid, "Admin") >= 11) sendername = "Hidden";
      		SetPVarInt(targetid, "Sex", type);
      		format(string, sizeof(string),"AdmCmd: %s has set %s's sex to %d", sendername, giveplayer, type);
      		SendAdminMessage(COLOR_YELLOW,string);
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
COMMAND:gotocar(playerid, params[])
{
	new type;
	if(sscanf(params, "i", type)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /gotocar [Vehicle ID]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(type < 0 || type > 5000) return SendClientMessage(playerid, COLOR_GREY, "Cannot go under 0 or above 5000.");
		if(GetPVarInt(playerid, "Admin") >= 1)
		{
			new Float:x, Float:y, Float:z;
			GetVehiclePos(type,x,y,z);
			SetPlayerPosEx(playerid,x,y,z);
      		SendClientMessage(playerid,COLOR_GREY,"You have been teleported.");
			PlayerInfo[playerid][pInVehicle] = -1;
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
COMMAND:goincar(playerid, params[])
{
	new type;
	if(sscanf(params, "i", type)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /goincar [Vehicle ID]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(type < 0 || type > 5000) return SendClientMessage(playerid, COLOR_GREY, "Cannot go under 0 or above 5000.");
		if(GetPVarInt(playerid, "Admin") >= 1)
		{
		    PutPlayerInVehicleEx(playerid,type,0);
      		SendClientMessage(playerid,COLOR_GREY,"You have been teleported.");
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
COMMAND:checkhack(playerid, params[])
{
	new targetid;
	if(sscanf(params, "u", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /hack [playerid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
		if(GetPVarInt(playerid, "Admin") >= 2)
		{
			new Float:health;
			GetPlayerHealth(targetid,health);
			new Float:oldhealth = health - 1.0;
			SetPlayerHealth(targetid,health-1.0);
			GetPlayerHealth(targetid,health);
			if(health != oldhealth) {
				SendClientMessage(playerid,COLOR_YELLOW,"Players health has been lowered by 1.");
			}
			else SendClientMessage(playerid,COLOR_YELLOW,"Players health didn't change, possible hacker.");
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
COMMAND:aduty(playerid, params[])
{
	new string[128];
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Admin") >= 1)
	{
	    switch(GetPVarInt(playerid, "AdminDuty"))
	    {
	        case 0:
	        {
	            SetPVarInt(playerid, "AdminDuty", 1);
	            SetPlayerArmourEx(playerid, 100000);
				SetPlayerHealth(playerid, 100000);
				SetPlayerColor(playerid,COLOR_YELLOW);
				switch(GetPVarInt(playerid, "MaskUse"))
				{
				    case 0: format(string, sizeof(string),"%s(%d)", PlayerName(playerid), playerid);
				    case 1: format(string, sizeof(string),"%s", PlayerNameEx(playerid));
				}
				switch(GetPVarInt(playerid, "Admin"))
				{
				    case 1 .. 3: SetPlayerColor(playerid,COLOR_ADMIN); // Moderator
					case 4 .. 9: SetPlayerColor(playerid,COLOR_SENIOR_ADMIN); // Senior
					case 10 .. 11: SetPlayerColor(playerid,COLOR_LEAD_ADMIN); // Lead Administrator
				}
	            format(string, sizeof(string),"AdmCmd: %s is now On-Duty as an admin.", PlayerName(playerid));
      		    switch(GetPVarInt(playerid, "Admin"))
				{
				    case 1 .. 3: SendAdminMessage(COLOR_ADMIN,string); // Moderator
					case 4 .. 9: SendAdminMessage(COLOR_SENIOR_ADMIN,string); // Senior
					case 10 .. 11: SendAdminMessage(COLOR_LEAD_ADMIN,string); // Lead Administrator
				}
	        }
			case 1:
			{
			    SetPVarInt(playerid, "AdminDuty", 0);
			    SetPlayerArmourEx(playerid, 0);
				SetPlayerHealth(playerid, 100);
				SetPlayerColor(playerid, COLOR_WHITE);
			    format(string, sizeof(string),"AdmCmd: %s is now Off-Duty as an admin.", PlayerName(playerid));
			    SendAdminMessage(COLOR_YELLOW,string);
			}
	    }
    }
    else
	{
	    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
COMMAND:speclist(playerid, params[])
{
	new string[128];
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if (GetPVarInt(playerid,"Admin") < 7) return SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
    foreach(new i : Player) {
	    if(GetPVarInt(i, "PlayerLogged") == 1 && GetPVarInt(i, "Admin") > 0 && GetPVarInt(i, "Admin") < 1337 && GetPlayerState(i) == PLAYER_STATE_SPECTATING && IsPlayerConnected(GetPVarInt(i, "SpecID"))) {
			format(string, sizeof(string), "%s is spectating %s.", PlayerName(i), PlayerName(GetPVarInt(i, "SpecID")));
      		SendClientMessage(playerid, COLOR_WHITE, string);
	    }
	}
	return 1;
}
//============================================//
COMMAND:spec(playerid, params[])
{
	if(GetPVarInt(playerid, "PlayerSpectate") > 0) SendClientMessage(playerid, COLOR_LIGHTRED, "[NOTE] You can use /specoff to stop spectating.!");
	new targetid,string[128], playersip[256];
	if(sscanf(params, "u", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /spec [playerid]");
	else
	{
		if(GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
		if(GetPVarInt(playerid, "Admin") >= 1)
		{
			if(GetPVarInt(playerid, "PlayerSpectate") == 0)
			{
				new Float:health,Float:armour,Float:x, Float:y, Float:z,world = GetPlayerVirtualWorld(playerid), interior = GetPlayerInterior(playerid);
				GetPlayerPos(playerid,x,y,z); GetPlayerHealth(playerid,health); GetPlayerArmour(playerid,armour);
				SetPVarFloat(playerid,"MarkX",x);
				SetPVarFloat(playerid,"MarkY",y);
				SetPVarFloat(playerid,"MarkZ",z);
				SetPVarFloat(playerid, "Health", health);
				PlayerInfo[playerid][pArmour] = armour;
				SetPVarInt(playerid, "Int", interior);
				SetPVarInt(playerid, "World", world);
			}

			TogglePlayerSpectatingEx(playerid, 1);

			SetPlayerInterior(playerid,GetPlayerInterior(targetid));
			SetPlayerVirtualWorld(playerid,GetPlayerVirtualWorld(targetid));

			if(IsPlayerInAnyVehicle(targetid))
			{
				PlayerSpectateVehicle(playerid, GetPlayerVehicleID(targetid));
			}
			else
			{
				PlayerSpectatePlayer(playerid, targetid);
			}

			SetPVarInt(playerid, "SpecID", targetid);

			if(GetPVarInt(targetid, "Admin") > 9 && (GetPVarInt(playerid, "Admin") <= GetPVarInt(targetid, "Admin")))
			{
				format(string, sizeof(string), "Lead-Warning: %s is spectating you.", PlayerName(playerid));
				SendClientMessage(targetid,COLOR_LIGHTRED,string);
			}
			
			GetPlayerIp(targetid,playersip,sizeof(playersip));

			format(string, sizeof(string), "Player: %s - ID: %d - Hours Played: %d - IP: %s", PlayerInfo[targetid][pName], targetid, GetPVarInt(targetid, "ConnectTime"), playersip);
			SendClientMessage(playerid, COLOR_GREY, string);
		}
		else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
COMMAND:specoff(playerid, params[])
{
    if(GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "PlayerSpectate") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not spectating.");
    if(GetPVarInt(playerid, "Admin") >= 1)
	{
	    TogglePlayerSpectatingEx(playerid, 0);
		TempFreeze(playerid);
		SetPlayerInterior(playerid,GetPVarInt(playerid, "Int"));
		SetPlayerVirtualWorld(playerid,GetPVarInt(playerid, "World"));
		SetPlayerPosEx(playerid,GetPVarFloat(playerid,"MarkX"),GetPVarFloat(playerid,"MarkY"),GetPVarFloat(playerid,"MarkZ"));
	    if(GetPVarFloat(playerid, "Health") > 0) SetPlayerHealth(playerid,GetPVarFloat(playerid, "Health"));
	    if(PlayerInfo[playerid][pArmour] > 0) SetPlayerArmourEx(playerid,PlayerInfo[playerid][pArmour]);
	    ResetPlayerWeapons(playerid);
	    if(PlayerInfo[playerid][pPlayerWeapon] != 0 && PlayerInfo[playerid][pPlayerAmmo] != 0)
	    {
	        GivePlayerWeaponEx(playerid, PlayerInfo[playerid][pPlayerWeapon], PlayerInfo[playerid][pPlayerAmmo]);
	        CallRemoteFunction("LoadHolsters","i",playerid);
	    }
    }
    else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	return 1;
}
//============================================//
COMMAND:gotols(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Admin") >= 1)
	{
	    SendClientMessage(playerid,COLOR_GREY,"You have been teleported.");
		if(IsPlayerInAnyVehicle(playerid))
		{
            SetVehiclePosEx(GetPlayerVehicleID(playerid),1529.6,-1691.2,13.3);
			PlayerInfo[playerid][pInVehicle] = -1;
		}
		else
		{
		    SetPlayerPosEx(playerid,1529.6,-1691.2,13.3);
		    SetPlayerInterior(playerid,0);
		    SetPlayerVirtualWorld(playerid,0);
		}
    }
    else
	{
	    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
COMMAND:gotolv(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Admin") >= 1)
	{
	    SendClientMessage(playerid,COLOR_GREY,"You have been teleported.");
		if(IsPlayerInAnyVehicle(playerid))
		{
            SetVehiclePosEx(GetPlayerVehicleID(playerid),1699.2, 1435.1, 10.7);
			PlayerInfo[playerid][pInVehicle] = -1;
		}
		else
		{
		    SetPlayerPosEx(playerid,1699.2, 1435.1, 10.7);
		    SetPlayerInterior(playerid,0);
		    SetPlayerVirtualWorld(playerid,0);
		}
    }
    else
	{
	    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
COMMAND:gotosf(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Admin") >= 1)
	{
	    SendClientMessage(playerid,COLOR_GREY,"You have been teleported.");
		if(IsPlayerInAnyVehicle(playerid))
		{
            SetVehiclePosEx(GetPlayerVehicleID(playerid),-1417.0,-295.8,14.1);
			PlayerInfo[playerid][pInVehicle] = -1;
		}
		else
		{
		    SetPlayerPosEx(playerid,-1417.0,-295.8,14.1);
		    SetPlayerInterior(playerid,0);
		    SetPlayerVirtualWorld(playerid,0);
		}
    }
    else
	{
	    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
COMMAND:gotodemo(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Admin") >= 1)
	{
	    SendClientMessage(playerid,COLOR_GREY,"You have been teleported.");
		if(IsPlayerInAnyVehicle(playerid))
		{
            SetVehiclePosEx(GetPlayerVehicleID(playerid),-383.5794,2851.5256,113.9010);
			PlayerInfo[playerid][pInVehicle] = -1;
		}
		else
		{
		    SetPlayerPosEx(playerid,-383.5794,2851.5256,113.9010);
		    SetPlayerInterior(playerid,0);
		    SetPlayerVirtualWorld(playerid,0);
		}
    }
    else
	{
	    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
COMMAND:gotogas(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Admin") >= 1)
	{
	    SendClientMessage(playerid,COLOR_GREY,"You have been teleported.");
		if(IsPlayerInAnyVehicle(playerid)) SetVehiclePosEx(GetPlayerVehicleID(playerid),1925.4385,-1759.2397,13.5469);
		else SetPlayerPosEx(playerid,1925.4385,-1759.2397,13.5469), SetPlayerInterior(playerid,0), SetPlayerVirtualWorld(playerid,0);
    }
    else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	return 1;
}
//============================================//
COMMAND:gotoprison(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Admin") >= 1)
	{
	    SendClientMessage(playerid,COLOR_GREY,"You have been teleported.");
		if(IsPlayerInAnyVehicle(playerid)) return error(playerid, "You can't do this while in a vehicle.");
		else SetPlayerPosEx(playerid, 2575.0051, -1474.8724, -48.8995), SetPlayerInterior(playerid,1), SetPlayerVirtualWorld(playerid,1);
    }
    else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	return 1;
}
//============================================//
COMMAND:gotoclub(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Admin") >= 1)
	{
	    SendClientMessage(playerid,COLOR_GREY,"You have been teleported.");
		SetPlayerPosEx(playerid, 1100.1354, 243.8890, 527.3731), SetPlayerInterior(playerid,11), SetPlayerVirtualWorld(playerid,11);
		PlayerInfo[playerid][pInVehicle] = -1;
	}
    else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	return 1;
}
//============================================//
COMMAND:gototrap(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Admin") >= 1)
	{
	    SendClientMessage(playerid,COLOR_GREY,"You have been teleported.");
		if(IsPlayerInAnyVehicle(playerid)) return error(playerid, "You can't do this while in a vehicle.");
		else SetPlayerPosEx(playerid, 160.4535, 2485.5784, -88.9141), SetPlayerInterior(playerid,2), SetPlayerVirtualWorld(playerid,2);
		PlayerInfo[playerid][pInVehicle] = -1;
	}
    else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	return 1;
}
//============================================//
COMMAND:gotohos(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Admin") >= 1)
	{
	    SendClientMessage(playerid,COLOR_GREY,"You have been teleported.");
		if(IsPlayerInAnyVehicle(playerid)) SetVehiclePosEx(GetPlayerVehicleID(playerid),1182.5016,-1321.9572,13.5788);
		else SetPlayerPosEx(playerid,1182.5016,-1321.9572,13.5788), SetPlayerInterior(playerid,0), SetPlayerVirtualWorld(playerid,0);
	}
    else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	return 1;
}
//============================================//
COMMAND:gotoelcorona(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Admin") >= 1)
	{
	    SendClientMessage(playerid,COLOR_GREY,"You have been teleported.");
		if(IsPlayerInAnyVehicle(playerid))
		{
            SetVehiclePosEx(GetPlayerVehicleID(playerid),1908.7719,-2020.0188,13.5469);
			PlayerInfo[playerid][pInVehicle] = -1;
		}
		else
		{
		    SetPlayerPosEx(playerid,1908.7719,-2020.0188,13.5469);
		    SetPlayerInterior(playerid,0);
		    SetPlayerVirtualWorld(playerid,0);
		}
    }
    else
	{
	    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
COMMAND:gotonewbie(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Admin") >= 1)
	{
	    SendClientMessage(playerid,COLOR_GREY,"You have been teleported.");
		if(IsPlayerInAnyVehicle(playerid))
		{
            SetVehiclePosEx(GetPlayerVehicleID(playerid),1568.3518,-2276.5513,13.5537);
			PlayerInfo[playerid][pInVehicle] = -1;
		}
		else
		{
		    SetPlayerPosEx(playerid,1568.3518,-2276.5513,13.5537);
		    SetPlayerInterior(playerid,0);
		    SetPlayerVirtualWorld(playerid,0);
		}
    }
    else
	{
	    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
COMMAND:gotogrove(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Admin") >= 1)
	{
	    SendClientMessage(playerid,COLOR_GREY,"You have been teleported.");
		if(IsPlayerInAnyVehicle(playerid))
		{
            SetVehiclePosEx(GetPlayerVehicleID(playerid),2529.5720,-1667.7911,15.1690);
			PlayerInfo[playerid][pInVehicle] = -1;
		}
		else
		{
		    SetPlayerPosEx(playerid,2529.5720,-1667.7911,15.1690);
		    SetPlayerInterior(playerid,0);
		    SetPlayerVirtualWorld(playerid,0);
		}
    }
    else
	{
	    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
COMMAND:gotosan(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Admin") >= 1)
	{
	    SendClientMessage(playerid,COLOR_GREY,"You have been teleported.");
		if(IsPlayerInAnyVehicle(playerid))
		{
            SetVehiclePosEx(GetPlayerVehicleID(playerid),1786.6350,-1294.6017,13.4879);
			PlayerInfo[playerid][pInVehicle] = -1;
		}
		else
		{
		    SetPlayerPosEx(playerid,1786.6350,-1294.6017,13.4879);
		    SetPlayerInterior(playerid,0);
		    SetPlayerVirtualWorld(playerid,0);
		}
    }
    else
	{
	    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
COMMAND:gotoseville(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Admin") >= 1)
	{
	    SendClientMessage(playerid,COLOR_GREY,"You have been teleported.");
		if(IsPlayerInAnyVehicle(playerid))
		{
            SetVehiclePosEx(GetPlayerVehicleID(playerid),2783.2827,-2025.6841,13.5620);
			PlayerInfo[playerid][pInVehicle] = -1;
		}
		else
		{
		    SetPlayerPosEx(playerid,2783.2827,-2025.6841,13.5620);
		    SetPlayerInterior(playerid,0);
		    SetPlayerVirtualWorld(playerid,0);
		}
    }
    else
	{
	    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
COMMAND:gotomotel(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Admin") >= 1)
	{
	    SendClientMessage(playerid,COLOR_GREY,"You have been teleported.");
		if(IsPlayerInAnyVehicle(playerid))
		{
            SetVehiclePosEx(GetPlayerVehicleID(playerid),2196.0056,-1139.6841,38.1016);
			PlayerInfo[playerid][pInVehicle] = -1;
		}
		else
		{
		    SetPlayerPosEx(playerid,2196.0056,-1139.6841,38.1016);
		    SetPlayerInterior(playerid,0);
		    SetPlayerVirtualWorld(playerid,0);
		}
    }
    else
	{
	    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
COMMAND:gotobank(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Admin") >= 1)
	{
	    SendClientMessage(playerid,COLOR_GREY,"You have been teleported.");
		if(IsPlayerInAnyVehicle(playerid))
		{
            SetVehiclePosEx(GetPlayerVehicleID(playerid),1448.1796,-1010.7741,26.8438);
			PlayerInfo[playerid][pInVehicle] = -1;
		}
		else
		{
		    SetPlayerPosEx(playerid,1448.1796,-1010.7741,26.8438);
		    SetPlayerInterior(playerid,0);
		    SetPlayerVirtualWorld(playerid,0);
		}
    }
    else
	{
	    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
COMMAND:gotodonut(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Admin") >= 1)
	{
	    SendClientMessage(playerid,COLOR_GREY,"You have been teleported.");
		if(IsPlayerInAnyVehicle(playerid))
		{
            SetVehiclePosEx(GetPlayerVehicleID(playerid),1038.6437,-1344.3074,29.6374);
			PlayerInfo[playerid][pInVehicle] = -1;
		}
		else
		{
		    SetPlayerPosEx(playerid,1038.6437,-1344.3074,29.6374);
		    SetPlayerInterior(playerid,0);
		    SetPlayerVirtualWorld(playerid,0);
		}
    }
    else
	{
	    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
COMMAND:gotopier(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Admin") >= 1)
	{
	    SendClientMessage(playerid,COLOR_GREY,"You have been teleported.");
		if(IsPlayerInAnyVehicle(playerid))
		{
            SetVehiclePosEx(GetPlayerVehicleID(playerid),848.3141,-1909.2942,14.8499);
			PlayerInfo[playerid][pInVehicle] = -1;
		}
		else
		{
		    SetPlayerPosEx(playerid,848.3141,-1909.2942,14.8499);
		    SetPlayerInterior(playerid,0);
		    SetPlayerVirtualWorld(playerid,0);
		}
    }
    else
	{
	    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
COMMAND:countdown(playerid, params[])
{
	new targetid;
	if(sscanf(params, "i", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /countdown [time]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if(GetPVarInt(playerid, "Admin") >= 3)
		{
		    CountDown=targetid;
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
COMMAND:banip(playerid, params[])
{
	if(GetPVarInt(playerid, "Admin") < 4) return nal(playerid);
	new reason[128], ip[64], string[128];
	if(sscanf(params, "s[128]s[64]", ip, reason)) SendClientMessage(playerid, -1, "USAGE: /banip [IP] [reason]");
	else
	{
		if(strlen(reason) >= 100) return SendClientMessage(playerid, -1, "Ban Reason is too long.");
		format(string, sizeof(string), "AdmCmd: %s was IP banned by Admin %s Reason: [%s].", ip, AdminName(playerid), reason);
		SendAdminMessage(COLOR_YELLOW, string);
		BanPlayerO("IP BAN",ip,reason,AdminName(playerid));
		format(string, sizeof(string), "[BAN][IP][%s] %s", PlayerName(playerid), string);
		BanLog(string);
	}
	return 1;
}
COMMAND:unbanip(playerid,params[])
{
    new ip[32], dformat[64];
    if(GetPVarInt(playerid,"Admin") < 6) return SendClientMessage(playerid,-1,"You have to be at least a level 6 admin to unban.");
    if(sscanf(params,"s[32]",ip)) return SendClientMessage(playerid,-1,"USAGE: /unbanip [ip]");
    format(dformat,sizeof dformat,"unbanip %s",ip);
    SendRconCommand(dformat);
	new string[255];
	format(string, sizeof(string), "[UNBAN][IP][%s] AdmCMD: %s un-banned IP %s. (Unbans RCON bans only.)", PlayerName(playerid), AdminName(playerid), ip);
	BanLog(string);
    return 1;
}
//============================================//
COMMAND:find(playerid, params[])
{
	new targetid;
	if(sscanf(params, "u", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /find [playerid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
	    if(IsPlayerNPC(targetid)) return SendClientMessage(playerid, COLOR_GREY, "Can't do this to a NPC.");
		if(GetPVarInt(playerid, "Admin") >= 7)
		{
			new Float:x,Float:y,Float:z;
			GetPlayerPos(targetid,x,y,z);
			SetPlayerCheckpoint(playerid,x,y,z,5.0);
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
COMMAND:carplate(playerid, params[])
{
	new plate[50];
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOR_WHITE, "You must be in a vehicle to use this!");
	if(sscanf(params, "s[50]", plate)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /carplate [PLATE NAME]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if(GetPVarInt(playerid, "Admin") >= 7) {
			new h = GetPlayerVehicleID(playerid), query[115];
			
			SetVehicleNumberPlate(h, plate);
		    format(query, sizeof(query), "Edited CarID: %d's Plate to %s.", h, plate);
		    SendClientMessage(playerid,COLOR_GREY,query);
			if(VehicleInfo[h][vType] == VEHICLE_PERSONAL && VehicleInfo[h][vID] != 0) {
				format(VehicleInfo[h][vPlate], VEHICLE_PLATE_MAX_LENGTH, "%s", plate);
				mysql_format(handlesql, query, sizeof(query), "UPDATE `vehicles` SET `Plate` = '%e' WHERE `ID` = %i;", plate, VehicleInfo[h][vID]);
				mysql_tquery(handlesql, query);
				SendClientMessage(playerid, COLOR_LIGHTBLUE, "Vehicle plated saved as it's an owned vehicle!");
			}
		}
		else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
    return 1;
}
//============================================//
COMMAND:helpers(playerid, params[])
{
    new sendername[MAX_PLAYER_NAME],string[128],helptext[128];
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    new found = 0;
    foreach(new i : Player) {
        if(GetPVarInt(i, "Helper") >= 1) { found++; }
	}
	if(found == 0) return SendClientMessage(playerid, COLOR_FADE, "There is no helpers online.");
	SendClientMessage(playerid, COLOR_WHITE, "__________________________________________________");
    SendClientMessage(playerid, COLOR_WHITE, "                           Helpers Online:");
    foreach(new i : Player)
    {
        if(GetPVarInt(i, "Helper") >= 1)
        {
            format(sendername, sizeof(sendername), "%s", PlayerName(i));
      		GiveNameSpace(sendername);
      		switch(GetPVarInt(i, "Helper"))
            {
                case 3: helptext = "Lead Helper";
                case 2: helptext = "Helper Moderator";
                case 1: helptext = "Helper";
            }
			switch(GetPVarInt(i, "HelperDuty"))
			{
			    case 0:
			    {
				    if(GetPVarInt(i, "Helper") < 3) format(string, sizeof(string), "%s: %s [ID: %d]", helptext, AdminName(i), i);
				    if(GetPVarInt(i, "Helper") == 3) format(string, sizeof(string), "%s: %s [ID: HIDDEN]", helptext, AdminName(i));
			        SendClientMessage(playerid, COLOR_FADE, string);
			    }
			    case 1:
			    {
				    format(string, sizeof(string), "%s: %s [ID: %d] (On Duty)", helptext, AdminName(i), i);
			        SendClientMessage(playerid, 0x40808096, string);
			    }
			}
        }
    }
    SendClientMessage(playerid, COLOR_WHITE, "__________________________________________________");
	return 1;
}
//============================================//
COMMAND:togha(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    switch(GetPVarInt(playerid, "TogHa"))
    {
        case 0:
        {
            SetPVarInt(playerid,"TogHa",1);
            SendClientMessage(playerid, COLOR_GREY, "Local Staff Chat disabled!");
        }
        case 1:
        {
            DeletePVar(playerid,"TogHa");
            SendClientMessage(playerid, COLOR_GREY, "Local Staff Chat enabled!");
        }
    }
	return 1;
}
//============================================//
COMMAND:ha(playerid, params[])
{
	new text[128],string[128],sendername[MAX_PLAYER_NAME];
	if(sscanf(params, "s[128]", text)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /ha [Helper/Admin-Chat]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if(GetPVarInt(playerid, "Admin") >= 1 || GetPVarInt(playerid, "Helper") >= 1 || GetPVarInt(playerid, "Reg") >= 1)
		{
   			format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
      		GiveNameSpace(sendername);
      		new arank[128];
            switch(GetPVarInt(playerid, "Reg"))
            {
                case 3: arank = "Lead Registrator";
                case 2: arank = "Reg Moderator";
                case 1: arank = "Registrator";
            }
            switch(GetPVarInt(playerid, "Helper"))
            {
                case 3: arank = "Lead Helper";
                case 2: arank = "Helper Moderator";
                case 1: arank = "Helper";
            }
            switch(GetPVarInt(playerid, "Admin"))
      		{
      		    case 1: arank = "Level 1 Moderator";
      		    case 2: arank = "Level 2 Admin";
      		    case 3: arank = "Level 3 Admin";
      		    case 4 .. 9: arank = "Senior Admin";
      		    case 10: arank = "Lead Administrator";
      		    case 11: arank = "1337 Admin";
      		}
            format(string, sizeof(string), "*** %s %s *** %s", arank,  AdminName(playerid), text);
    	    SendStaffMessage(0x009B4E96, string);
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
COMMAND:rc(playerid, params[])
{
	new text[128],string[128],sendername[MAX_PLAYER_NAME],helptext[128];
	if(sscanf(params, "s[128]", text)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /rc [Register-Chat]");
	if(GetPVarInt(playerid, "Reg") < 2) return nal(playerid);
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if(GetPVarInt(playerid, "Reg") >= 1)
		{
		    switch(GetPVarInt(playerid, "Reg"))
            {
                case 3: helptext = "Lead Registrator";
                case 2: helptext = "Registrator Moderator";
                case 1: helptext = "Registrator";
            }
   			format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
      		GiveNameSpace(sendername);
            format(string, sizeof(string), "*%s %s: %s", helptext, AdminName(playerid), text);
    	    SendRegMessage(0x40808096, string);
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
COMMAND:passed(playerid, params[])
{
    new sendername[MAX_PLAYER_NAME],string[128],helptext[128];
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Admin") >= 1 || GetPVarInt(playerid, "Helper") >= 1 || GetPVarInt(playerid, "Reg") >= 1)
    {
        SendClientMessage(playerid, COLOR_WHITE, "__________________________________________________");
        SendClientMessage(playerid, COLOR_WHITE, "                  ONLINE People who are waiting approval:");
        new found = 0;
        foreach(new i : Player)
        {
            if(GetPVarInt(i, "PlayerLogged") == 1 && GetPVarInt(i, "Approve") == 0 && GetPVarInt(i, "AppWait") == 1) //UCPRelated, removed Tut check
            {
                format(sendername, sizeof(sendername), "%s", PlayerName(i));
      		    GiveNameSpace(sendername);
			    format(string, sizeof(string), "%s: %s [ID: %d]", helptext, sendername, i);
			    SendClientMessage(playerid, COLOR_FADE, string);
			    found++;
            }
        }
        if(found == 0) SendClientMessage(playerid, COLOR_FADE, "No-one online.");
        SendClientMessage(playerid, COLOR_WHITE, "__________________________________________________");
    }
    else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	return 1;
}
//============================================//
ALTCOMMAND:answers->applications;
ALTCOMMAND:apps->applications;
COMMAND:applications(playerid, params[])
{
	if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	if(GetPVarInt(playerid, "Admin") >= 1 || GetPVarInt(playerid, "Reg") >= 1)
	{
		new query[34];
		mysql_format(handlesql, query, sizeof(query), "SELECT `Name` FROM applications");
		mysql_tquery(handlesql, query, "PopulateAppMenu", "i", playerid);
	}
	else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	return 1;
}
//============================================//
COMMAND:ht(playerid, params[])
{
	new text[128],string[128],sendername[MAX_PLAYER_NAME],helptext[128];
	if(sscanf(params, "s[128]", text)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /ht [Helper-Chat]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if(GetPVarInt(playerid, "Helper") >= 1)
		{
		    switch(GetPVarInt(playerid, "Helper"))
            {
                case 3: helptext = "Lead Helper";
                case 2: helptext = "Helper Moderator";
                case 1: helptext = "Helper";
            }
   			format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
      		GiveNameSpace(sendername);
            format(string, sizeof(string), "*%s %s: %s", helptext, AdminName(playerid), text);
    	    SendHelperMessage(0x40808096, string);
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
COMMAND:helpme(playerid, params[])
{
	new text[128],string[128],sendername[MAX_PLAYER_NAME];
	if(sscanf(params, "s[128]", text)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /helpme [text]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "HelpMe") > GetCount()) return SendClientMessage(playerid, COLOR_GREY, "You have recently posted a HelpMe.");
	    if(GetPVarInt(playerid, "TogPM") == 1) return SendClientMessage(playerid, COLOR_GREY, "You can't use /helpme if your PMs are togged (/togpm).");
   		format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
      	GiveNameSpace(sendername);
      	new found = 0;
        foreach(new i : Player)
        {
            if(GetPVarInt(i, "Helper") >= 1)
            {
			    found++;
            }
        }
        if(found == 0)
        {
            format(string, sizeof(string), "HELPME: %s [ID:%d]: %s.", sendername, playerid, text);
		    SendAdminMessage(0xFF0000FF,string);
		    format(string, sizeof(string), "HELPME: Use /accepthelpme [%d] to respond to the helpme.", playerid);
		    SendAdminMessage(0xFF0000FF,string);
		    SendClientMessage(playerid,COLOR_GREEN,"Your request has been sent to all the online Helpers.");
		    SetPVarInt(playerid, "HelpMe", GetCount()+60000);
			return 1;
        }
      	format(string, sizeof(string), "HELPME: %s [ID:%d]: %s.", sendername, playerid, text);
		SendHelperMessage(0xFF0000FF,string);
		format(string, sizeof(string), "HELPME: Use /accepthelpme [%d] to respond to the helpme.", playerid);
		SendHelperMessage(0xFF0000FF,string);
		SendClientMessage(playerid,COLOR_GREEN,"Your request has been sent to all the online Helpers.");
		SetPVarInt(playerid, "HelpMe", GetCount()+60000);
	}
	return 1;
}
//============================================//
ALTCOMMAND:ahm->accepthelpme;
COMMAND:accepthelpme(playerid, params[])
{
	new targetid,string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "u", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /accepthelpme [playerid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
	    if(GetPVarInt(targetid, "HelpMe") == 0) return SendClientMessage(playerid, COLOR_GREY, "This player's helpme time has dropped or he never requested one.");
		if(GetPVarInt(playerid, "Helper") >= 1 || GetPVarInt(playerid, "Admin") >= 1)
		{
   			format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
      		format(giveplayer, sizeof(giveplayer), "%s", PlayerName(targetid));
      		GiveNameSpace(sendername);
      		GiveNameSpace(giveplayer);
      		format(string, sizeof(string), "HelpCmd: %s has accepted %s's helpme.", AdminName(playerid), giveplayer);
      		SendHelperMessage(0xFF0000FF,string);
      		format(string, sizeof(string), "You accepted %s's helpme.", giveplayer);
      		SendClientMessage(playerid,COLOR_GREEN,string);
      		format(string, sizeof(string), "Helper %s has accepted your helpme.", AdminName(playerid));
      		SendClientMessage(targetid,COLOR_GREEN,string);
      		SetPVarInt(targetid, "HelpMe", 0);
			SetPVarInt(playerid, "helpmes", GetPVarInt(playerid, "helpmes") + 1); //Amount of helpme's answered by helper.
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
COMMAND:hduty(playerid, params[])
{
	new string[128];
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Helper") >= 1)
	{
	    switch(GetPVarInt(playerid, "HelperDuty"))
	    {
	        case 0:
	        {
	            SetPVarInt(playerid, "HelperDuty", 1);
	            SetPlayerColor(playerid,0x00808000);
	            format(string, sizeof(string),"HelpCmd: %s is now On-Duty as an Helper.", PlayerName(playerid));
      		    SendHelperMessage(0xFF0000FF,string);
	        }
			case 1:
			{
			    SetPVarInt(playerid, "HelperDuty", 0);
			    SetPlayerColor(playerid,COLOR_WHITE);
			    format(string, sizeof(string),"HelpCmd: %s is now Off-Duty as an Helper.", PlayerName(playerid));
      		    SendHelperMessage(0xFF0000FF,string);
			}
	    }
    }
    else
	{
	    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
COMMAND:gi(playerid, params[])
{
	new itemid, quantity, ex1;
	if(sscanf(params, "iii", itemid, quantity, ex1)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /gi [ITEMID - AMOUNT - EX1]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Admin") >= 7) {
	        GiveInvItem(playerid, itemid, quantity, ex1);

			if(GetPVarInt(playerid, "Admin") < 1337) {
				new string[128];
				format(string, sizeof(string), "AdmWarn: %s has given himself an item: %s (%i)", PlayerInfo[playerid][pUsername], PrintIName(itemid), quantity);
				SendAdminMessage(COLOR_YELLOW, string);
				ItemLog(string);
			}
	    }
	}
	return 1;
}
//============================================//
COMMAND:up(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Admin") >= 1)
	{
	    new Float:x,Float:y,Float:z;
	    GetPlayerPos(playerid,x,y,z);
        SetPlayerPosEx(playerid,x,y,z+2);
    }
    else
	{
	    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
COMMAND:dn(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Admin") >= 1)
	{
	    new Float:x,Float:y,Float:z;
	    GetPlayerPos(playerid,x,y,z);
        SetPlayerPosEx(playerid,x,y,z-2);
    }
    else
	{
	    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
COMMAND:jetpack(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Admin") >= 7)
	{
	    SetPlayerSpecialAction(playerid, 2);
	    SendClientMessage(playerid, COLOR_LIGHTRED, "AdmCmd: You created a jetpack.");
	    SendClientMessage(playerid, COLOR_BLUE, "DO NOT forget to despawn it by typing /up");
    }
    else
	{
	    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
COMMAND:gotoint(playerid, params[])
{
	new aimid;
	if(sscanf(params, "i", aimid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /gotoint [1-74]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
        if(GetPVarInt(playerid, "Admin") >= 9)
	    {
	        switch(aimid)
		    {
		        case 1: SetPlayerInterior(playerid,14), SetPlayerPosEx(playerid,-1827.147338,7.207418,1061.143554);
		        case 2: SetPlayerInterior(playerid,14), SetPlayerPosEx(playerid,-1855.568725,41.263156,1061.143554);
		        case 3: SetPlayerInterior(playerid,1), SetPlayerPosEx(playerid,2.384830,33.103397,1199.849976);
		        case 4: SetPlayerInterior(playerid,9), SetPlayerPosEx(playerid,315.856170,1024.496459,1949.797363);
		        case 5: SetPlayerInterior(playerid,3), SetPlayerPosEx(playerid,235.508994,1189.169897,1080.339966);
		        case 6: SetPlayerInterior(playerid,2), SetPlayerPosEx(playerid,225.756989,1240.000000,1082.149902);
		        case 7: SetPlayerInterior(playerid,1), SetPlayerPosEx(playerid,223.043991,1289.259888,1082.199951);
		        case 8: SetPlayerInterior(playerid,7), SetPlayerPosEx(playerid,225.630997,1022.479980,1084.069946);
		        case 9: SetPlayerInterior(playerid,5), SetPlayerPosEx(playerid,15295.138977,1474.469971,1080.519897);
		        case 10: SetPlayerInterior(playerid,6), SetPlayerPosEx(playerid,15328.493988,1480.589966,1084.449951);
		        case 11: SetPlayerInterior(playerid,7), SetPlayerPosEx(playerid,15385.803986,1471.769897,1080.209961);
		        case 12: SetPlayerInterior(playerid,18), SetPlayerPosEx(playerid,1726.18,-1641.00,20.23);
		        case 13: SetPlayerInterior(playerid,2), SetPlayerPosEx(playerid,2567.52,-1294.59,1063.25);
		        case 14: SetPlayerInterior(playerid,15), SetPlayerPosEx(playerid,-1394.20,987.62,1023.96);
		        case 15: SetPlayerInterior(playerid,5), SetPlayerPosEx(playerid,2338.32,-1180.61,1027.98);
		        case 16: SetPlayerInterior(playerid,8), SetPlayerPosEx(playerid,2807.63,-1170.15,1025.57);
		        case 17: SetPlayerInterior(playerid,17), SetPlayerPosEx(playerid,376.99,-191.21,1000.63);
		        case 18: SetPlayerInterior(playerid,14), SetPlayerPosEx(playerid,-1830.81,16.83,1061.14);
		        case 19: SetPlayerInterior(playerid,15), SetPlayerPosEx(playerid,2220.26,-1148.01,1025.80);
		        case 20: SetPlayerInterior(playerid,14), SetPlayerPosEx(playerid,-1410.72,1591.16,1052.53);
		        case 21: SetPlayerInterior(playerid,1), SetPlayerPosEx(playerid,-750.80,491.00,1371.70);
		        case 22: SetPlayerInterior(playerid,14), SetPlayerPosEx(playerid,-1870.80,59.81,1056.25);
		        case 23: SetPlayerInterior(playerid,3), SetPlayerPosEx(playerid,-2637.69,1404.24,906.46);
		        case 24: SetPlayerInterior(playerid,10), SetPlayerPosEx(playerid,-1079.99,1061.58,1343.04);
		        case 25: SetPlayerInterior(playerid,2), SetPlayerPosEx(playerid,2451.77,-1699.80,1013.51);
		        case 26: SetPlayerInterior(playerid,1), SetPlayerPosEx(playerid,-2042.42,178.59,28.84);
		        case 27: SetPlayerInterior(playerid,1), SetPlayerPosEx(playerid,2535.83,-1674.32,1015.50);
		        case 28: SetPlayerInterior(playerid,1), SetPlayerPosEx(playerid,681.66,-453.32,-25.61);
		        case 29: SetPlayerInterior(playerid,1), SetPlayerPosEx(playerid,-2158.72,641.29,1052.38);
		        case 30: SetPlayerInterior(playerid,7), SetPlayerPosEx(playerid,-1395.958,-208.197,1051.170);
		        case 31: SetPlayerInterior(playerid,4), SetPlayerPosEx(playerid,-1424.9319,-664.5869,1059.8585);
		        case 32: SetPlayerInterior(playerid,5), SetPlayerPosEx(playerid,318.565,1115.210,1082.98);
		        case 33: SetPlayerInterior(playerid,9), SetPlayerPosEx(playerid,2251.85,-1138.16,1050.63);
		        case 34: SetPlayerInterior(playerid,10), SetPlayerPosEx(playerid,2260.76,-1210.45,1049.02);
		        case 35: SetPlayerInterior(playerid,3), SetPlayerPosEx(playerid,2496.65,-1696.55,1014.74);
		        case 36: SetPlayerInterior(playerid,5), SetPlayerPosEx(playerid,1299.14,-794.77,1084.00);
		        case 37: SetPlayerInterior(playerid,10), SetPlayerPosEx(playerid,2262.83,-1137.71,1050.63);
		        case 38: SetPlayerInterior(playerid,8), SetPlayerPosEx(playerid,2365.42,-1131.85,1050.88);
		        case 39: SetPlayerInterior(playerid,6), SetPlayerPosEx(playerid,-2240.00,131.00,1035.40);
		        case 40: SetPlayerInterior(playerid,16), SetPlayerPosEx(playerid,-203.0764,-24.1658,1002.2734);
		        case 41: SetPlayerInterior(playerid,10), SetPlayerPosEx(playerid,363.4129,-74.5786,1001.5078);
		        case 42: SetPlayerInterior(playerid,5), SetPlayerPosEx(playerid,372.3520,-131.6510,1001.4922);
		        case 43: SetPlayerInterior(playerid,9), SetPlayerPosEx(playerid,365.7158,-9.8873,1001.8516);
		        case 44: SetPlayerInterior(playerid,1), SetPlayerPosEx(playerid,2233.8032,1712.2303,1011.7632);
		        case 45: SetPlayerInterior(playerid,12), SetPlayerPosEx(playerid,1118.8878,-10.2737,1002.0859);
		        case 46: SetPlayerInterior(playerid,10), SetPlayerPosEx(playerid,2016.2699,1017.7790,996.8750);
		        case 47: SetPlayerInterior(playerid,17), SetPlayerPosEx(playerid,378.026,-190.5155,1000.6328);
		        case 48: SetPlayerInterior(playerid,2), SetPlayerPosEx(playerid,616.7820,-74.8151,997.6350);
		        case 49: SetPlayerInterior(playerid,3), SetPlayerPosEx(playerid,615.2851,-124.2390,997.6350);
		        case 50: SetPlayerInterior(playerid,1), SetPlayerPosEx(playerid,963.418762,2108.292480,1011.030273);
		        case 51: SetPlayerInterior(playerid,1), SetPlayerPosEx(playerid,2169.461181,1618.798339,999.976562);
		        case 52: SetPlayerInterior(playerid,17), SetPlayerPosEx(playerid,493.390991,-22.722799,1000.679687);
		        case 53: SetPlayerInterior(playerid,11), SetPlayerPosEx(playerid,501.980987,-69.150199,998.757812);
		        case 54: SetPlayerInterior(playerid,18), SetPlayerPosEx(playerid,-227.027999,1401.229980,27.765625);
		        case 55: SetPlayerInterior(playerid,4), SetPlayerPosEx(playerid,457.304748,-88.428497,999.554687);
		        case 56: SetPlayerInterior(playerid,1), SetPlayerPosEx(playerid,452.489990,-18.179698,1001.132812);
		        case 57: SetPlayerInterior(playerid,1), SetPlayerPosEx(playerid,681.557861,-455.680053,-25.609874);
		        case 58: SetPlayerInterior(playerid,17), SetPlayerPosEx(playerid,-959.564392,1848.576782,9.000000);
		        case 59: SetPlayerInterior(playerid,3), SetPlayerPosEx(playerid,384.808624,173.804992,1008.382812);
		        case 60: SetPlayerInterior(playerid,6), SetPlayerPosEx(playerid,774.213989,-48.924297,1000.585937);
		        case 61: SetPlayerInterior(playerid,7), SetPlayerPosEx(playerid,773.579956,-77.096694,1000.655029);
		        case 62: SetPlayerInterior(playerid,3), SetPlayerPosEx(playerid,1527.229980,-11.574499,1002.097106);
		        case 63: SetPlayerInterior(playerid,1), SetPlayerPosEx(playerid,2527.654052,-1679.388305,1015.498596);
		        case 64: SetPlayerInterior(playerid,3), SetPlayerPosEx(playerid,1212.019897,-28.663099,1000.953125);
		        case 65: SetPlayerInterior(playerid,3), SetPlayerPosEx(playerid,942.171997,-16.542755,1000.929687);
		        case 66: SetPlayerInterior(playerid,3), SetPlayerPosEx(playerid,964.106994,-53.205497,1001.124572);
		        case 67: SetPlayerInterior(playerid,1), SetPlayerPosEx(playerid,1412.639892,-1.787510,1000.924377);
		        case 68: SetPlayerInterior(playerid,15), SetPlayerPosEx(playerid,-1398.103515,937.631164,1036.479125);
		        case 69: SetPlayerInterior(playerid,18), SetPlayerPosEx(playerid,1710.433715,-1669.379272,20.225049);
		        case 70: SetPlayerInterior(playerid,6), SetPlayerPosEx(playerid,2333.11,-1077.1,1048.04);
		        case 71: SetPlayerInterior(playerid,8), SetPlayerPosEx(playerid,-42.58,1405.61,1083.45);
		        case 72: SetPlayerInterior(playerid,6), SetPlayerPosEx(playerid,2196.79,-1204.35,1048.05);
		        case 73: SetPlayerInterior(playerid,7), SetPlayerPosEx(playerid,314.820983,-141.431991,999.601562);
		        case 74: SetPlayerInterior(playerid,6), SetPlayerPosEx(playerid,296.919982,-108.071998,1001.515625);
		        case 75: SetPlayerInterior(playerid,1), SetPlayerPosEx(playerid,17.5380, -1.9900, 1000.6829 );
		        default: SendClientMessage(playerid, COLOR_GREY, "USAGE: /gotointt [1-74]");
		    }
        }
        else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
COMMAND:createint(playerid, params[])
{
	if(GetPVarInt(playerid, "Admin") >= 7) {
		new foundid = -1, Float:X, Float:Y, Float:Z;
	    for(new in = 1; in < MAX_INTS; in++) {
	        if(IntInfo[in][iUsed] == 0) {
	            foundid=in;
				break;
	        }
	    }
	    if(foundid == -1) return SendClientMessage(playerid, COLOR_LIGHTRED, "No more interiors left!");
	    GetPlayerPos(playerid, X, Y, Z);
		new query[142];
		mysql_format(handlesql, query, sizeof(query), "INSERT INTO interiors (`ID`, `Name`, `eX`, `eY`, `eZ`, `xX`, `xY`, `xZ`) VALUES(%d, '', %f, %f, %f, %f, %f, %f)", foundid, X, Y, Z, 0.0, 0.0, 0.0);
		mysql_tquery(handlesql, query);	//TODO: Redo saving/loading if interiors to store the dbID. This must be a callback that gets cache_insert_id().
		format(query, sizeof(query), "INT %d CREATED!", foundid);
	    SCM(playerid, COLOR_WHITE, query);
		LoadIntID(foundid);
	}
	else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	return 1;
}
//============================================//
COMMAND:editcar(playerid, params[])
{
	new type[128],amount,string[128];
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOR_WHITE, "You must be in a vehicle to use this!");
	if(VehicleInfo[GetPlayerVehicleID(playerid)][vID] == 0) return SendClientMessage(playerid, COLOR_GREY, "This is not an ownable vehicle.");
	if(sscanf(params, "s[128]i", type, amount)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /editcar [modelid/donate/price/paint/delay/engine/battery/mileage/locklvl/alarmlvl] [amount]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if(GetPVarInt(playerid, "Admin") >= 7)
		{
			new h = GetPlayerVehicleID(playerid),
			    query[75];
			    
		    if(strcmp(type, "modelid", true) == 0)
		    {
				VehicleInfo[h][vModel] = amount;
		        format(string, sizeof(string), "Edited CarID: %d's %s to %d.", h, type, amount);
		        SendClientMessage(playerid,COLOR_GREY,string);
		        mysql_format(handlesql, query, sizeof(query), "UPDATE `vehicles` SET `Model` = %i WHERE `ID` = %i;", amount, VehicleInfo[h][vID]);
		        mysql_tquery(handlesql, query);
		    }
		    else if(strcmp(type, "donate", true) == 0)
		    {
	            VehicleInfo[h][vDonate] = amount;
		        format(string, sizeof(string), "Edited CarID: %d's %s to %d.", h, type, amount);
		        SendClientMessage(playerid,COLOR_GREY,string);
		        mysql_format(handlesql, query, sizeof(query), "UPDATE `vehicles` SET `Donate` = %i WHERE `ID` = %i;", amount, VehicleInfo[h][vID]);
		        mysql_tquery(handlesql, query);
		    }
		    else if(strcmp(type, "price", true) == 0)
		    {
	            VehicleInfo[h][vValue] = amount;
		        format(string, sizeof(string), "Edited CarID: %d's %s to %d.", h, type, amount);
		        SendClientMessage(playerid,COLOR_GREY,string);
		        mysql_format(handlesql, query, sizeof(query), "UPDATE `vehicles` SET `Value` = %i WHERE `ID` = %i;", amount, VehicleInfo[h][vID]);
		        mysql_tquery(handlesql, query);
		    }
		    else if(strcmp(type, "mileage", true) == 0)
		    {
	            VehicleInfo[h][vMileage][1] = amount;
		        format(string, sizeof(string), "Edited CarID: %d's %s to %d.", h, type, amount);
		        SendClientMessage(playerid,COLOR_GREY,string);
		        mysql_format(handlesql, query, sizeof(query), "UPDATE `vehicles` SET `Mileage01` = %i WHERE `ID` = %i;", amount, VehicleInfo[h][vID]);
		        mysql_tquery(handlesql, query);
		    }
		    else if(strcmp(type, "locklvl", true) == 0)
		    {
	            VehicleInfo[h][vLockLvl] = amount;
		        format(string, sizeof(string), "Edited CarID: %d's %s to %d.", h, type, amount);
		        SendClientMessage(playerid,COLOR_GREY,string);
		        mysql_format(handlesql, query, sizeof(query), "UPDATE `vehicles` SET `LockLvl` = %i WHERE `ID` = %i;", amount, VehicleInfo[h][vID]);
		        mysql_tquery(handlesql, query);
		    }
		    else if(strcmp(type, "alarmlvl", true) == 0)
		    {
	            VehicleInfo[h][vAlarmLvl] = amount;
		        format(string, sizeof(string), "Edited CarID: %d's %s to %d.", h, type, amount);
		        SendClientMessage(playerid,COLOR_GREY,string);
		        mysql_format(handlesql, query, sizeof(query), "UPDATE `vehicles` SET `AlarmLvl` = %i WHERE `ID` = %i;", amount, VehicleInfo[h][vID]);
		        mysql_tquery(handlesql, query);
		    }
		}
		else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
COMMAND:editint(playerid, params[])
{
	new b, type[128], amount, string[128], file[128], str[50], Float:X, Float:Y, Float:Z;
	GetPlayerPos(playerid, X, Y, Z);
	if(sscanf(params, "is[128]is[50]", b, type, amount, str)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /editint [id] [type/world/int/icon/freeze/entrance/exit/name] [var] [str]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if(GetPVarInt(playerid, "Admin") >= 7)
		{
	                if(IntInfo[b][iUsed] == 1)
	                {
						new used = 0, query[128];
						if(strcmp(type, "type", true) == 0)
						{
							IntInfo[b][iType] = amount;
							used++;
							mysql_format(handlesql, query, sizeof(query), "UPDATE interiors SET Type=%d WHERE ID=%d", amount, b);
							mysql_tquery(handlesql, query);		
						}
						if(strcmp(type, "world", true) == 0)
						{
							IntInfo[b][iWorld] = amount;
							used++;
							mysql_format(handlesql, query, sizeof(query), "UPDATE interiors SET World=%d WHERE ID=%d", amount, b);
							mysql_tquery(handlesql, query);	
						}
						if(strcmp(type, "int", true) == 0)
						{
							IntInfo[b][iInt] = amount;
							used++;
							mysql_format(handlesql, query, sizeof(query), "UPDATE interiors SET `Int`=%d WHERE ID=%d", amount, b);
							mysql_tquery(handlesql, query);	
						}
						if(strcmp(type, "icon", true) == 0)
						{
							if(IntInfo[b][iMapIcon] >= 1) DestroyDynamicMapIcon(IntInfo[b][iMIcon]);
							IntInfo[b][iMapIcon] = amount;
							if(amount > 0)
							{
								IntInfo[b][iMIcon]=CreateDynamicMapIcon(IntInfo[b][ieX], IntInfo[b][ieY], IntInfo[b][ieZ], IntInfo[b][iMapIcon], COLOR_YELLOW);
							}
							used++;
							mysql_format(handlesql, query, sizeof(query), "UPDATE interiors SET MapIcon=%d WHERE ID=%d", amount, b);
							mysql_tquery(handlesql, query);	
						}
						if(strcmp(type, "freeze", true) == 0)
						{
							IntInfo[b][iFreeze] = amount;
							used++;
							mysql_format(handlesql, query, sizeof(query), "UPDATE interiors SET Freeze=%d WHERE ID=%d", amount, b);
							mysql_tquery(handlesql, query);	
						}
						if(strcmp(type, "entrance", true) == 0)
						{
							if(IntInfo[b][iMapIcon] >= 1) DestroyDynamicMapIcon(IntInfo[b][iMIcon]);
							IntInfo[b][ieX] = X;
							IntInfo[b][ieY] = Y;
							IntInfo[b][ieZ] = Z;
							if(IntInfo[b][iMapIcon] > 0)
							{
								IntInfo[b][iMIcon]=CreateDynamicMapIcon(IntInfo[b][ieX], IntInfo[b][ieY], IntInfo[b][ieZ], IntInfo[b][iMapIcon], COLOR_YELLOW);
							}
							DestroyDynamic3DTextLabel(IntInfo[b][iText]);
							DestroyDynamicPickup(IntInfo[b][iIcon]);
							format(file, 128, "| %s |", IntInfo[b][iName]);
							IntInfo[b][iText]=CreateDynamic3DTextLabel(file, 0xFFFFFFFF, IntInfo[b][ieX], IntInfo[b][ieY], IntInfo[b][ieZ]+0.50, 50.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0, 0, -1, 50.0);
							IntInfo[b][iIcon]=CreateDynamicPickup(1318, 1, IntInfo[b][ieX], IntInfo[b][ieY], IntInfo[b][ieZ]);
							used++;
							mysql_format(handlesql, query, sizeof(query), "UPDATE interiors SET eX=%f, eY=%f, eZ=%f WHERE ID=%d", X, Y, Z, b);
							mysql_tquery(handlesql, query);	
						}
						if(strcmp(type, "exit", true) == 0)
						{
							IntInfo[b][ixX] = X;
							IntInfo[b][ixY] = Y;
							IntInfo[b][ixZ] = Z;
							IntInfo[b][iInt] = GetPlayerInterior(playerid);
							if(IsValidDynamicPickup(IntInfo[b][iEIcon])) {
								DestroyDynamicPickup(IntInfo[b][iEIcon]);
							}					
							IntInfo[b][iEIcon]=CreateDynamicPickup(1318, 1, IntInfo[b][ixX], IntInfo[b][ixY], IntInfo[b][ixZ], IntInfo[b][iWorld], IntInfo[b][iInt]);
							used++;
							mysql_format(handlesql, query, sizeof(query), "UPDATE interiors SET `Int`=%d, xX=%f, xY=%f, xZ=%f WHERE ID=%d", GetPlayerInterior(playerid), X, Y, Z, b);
							mysql_tquery(handlesql, query);	
						}
						if(strcmp(type, "name", true) == 0)
						{
							strmid(IntInfo[b][iName], str, 0, strlen(str), 255);
							new bquery[200];
							mysql_format(handlesql, bquery, sizeof(bquery), "UPDATE interiors SET Name='%s' WHERE ID=%d", str, b);
							mysql_tquery(handlesql, bquery);	
							used++;
						}
						format(string, sizeof(string), "Edited IntID: %d's %s to %d.", b, type, amount);
						if(used != 0) {
							SendClientMessage(playerid, COLOR_GREY, string);
							ReloadIntID(b);
						}
						return true;
			        }
		}
		else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
COMMAND:crack(playerid, params[])
{
    if(GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
    if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
    SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
	new type;
	if(sscanf(params,"d",type)) return scm(playerid, -1, "/crack [1-4]");
    switch(type) {
		case 1: ApplyAnimation(playerid, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 0, 0);
		case 2: ApplyAnimation(playerid,"CRACK", "crckidle1", 4.0, 1, 0, 0, 0, 0);
		case 3: ApplyAnimation(playerid,"CRACK","crckidle3", 4.0, 1, 0, 0, 0, 0);
		case 4: ApplyAnimation(playerid,"CRACK","crckidle4", 4.0, 1, 0, 0, 0, 0);
		default: scm(playerid, -1, "/crack [1-4]");
    }
	return 1;
}
//============================================//
COMMAND:handsup(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Control") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are currently frozen!");
    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
    if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
    SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
    ApplyAnimation(playerid, "ROB_BANK", "SHP_HandsUp_Scr", 4.0, 0, 1, 1, 1, -1);
	return 1;
}
//============================================//
ALTCOMMAND:sa->stopanim;
COMMAND:stopanim(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
	if(GetPVarInt(playerid,"rappelling") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You can't use this while rappelling. (/breakrope)");
	if(GetPVarInt(playerid, "AnimUse") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You did not recently use any anim, therefore you are unable to (/stopanim).");
    ApplyAnimation(playerid, "CARRY", "crry_prtial", 2.0, 0, 0, 0, 0, 0);
    DeletePVar(playerid,"AnimUse");
	return 1;
}
//============================================//
COMMAND:piss(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Control") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are currently frozen!");
    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
    if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
    SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
    SetPlayerSpecialAction(playerid, 68);
	return 1;
}
//============================================//
COMMAND:slapass(playerid, params[])
{
    if(GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
    if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
    SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
    ApplyAnimation(playerid,"SWEET","sweet_ass_slap",4.0,0,0,0,0,0);
	return 1;
}
//============================================//
COMMAND:chairsit(playerid, params[])
{
    if(GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    //if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
    if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
    SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
    ApplyAnimation(playerid,"PED","SEAT_idle", 4.0, 1, 0, 0, 0, 0);
	return 1;
}
//============================================//
COMMAND:sit(playerid, params[])
{
    if(GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    //if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
    if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
    SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
	new type;
	if(sscanf(params,"d",type)) return scm(playerid, -1, "/sit [1-6]");
    switch(type)
    {
		case 1: ApplyAnimation(playerid,"PED","SEAT_down",4.1,0,1,1,1,0);
		case 2: ApplyAnimation(playerid,"MISC","seat_lr",2.0,1,0,0,0,0);
		case 3: ApplyAnimation(playerid,"MISC","seat_talk_01",2.0,1,0,0,0,0);
		case 4: ApplyAnimation(playerid,"MISC","seat_talk_02",2.0,1,0,0,0,0);
		case 5: ApplyAnimation(playerid,"BEACH", "ParkSit_M_loop", 4.0, 1, 0, 0, 0, 0);
		case 6: ApplyAnimation(playerid,"BEACH", "ParkSit_W_loop", 4.0, 1, 0, 0, 0, 0);
		default: scm(playerid, -1, "/sit [1-6]");
    }
    return 1;
}
//============================================//
COMMAND:drunk(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
    if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
    SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
    ApplyAnimation(playerid,"PED","WALK_DRUNK",4.1,1,1,1,1,1);
	return 1;
}
//============================================//
COMMAND:gwalk(playerid, params[])
{
	new aimid;
	if(sscanf(params, "i", aimid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /gwalk [1-2]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
        if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
        SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
		switch(aimid)
		{
		    case 1: ApplyAnimation(playerid,"PED","WALK_gang1",4.1,1,1,1,1,1);
            case 2: ApplyAnimation(playerid,"PED","WALK_gang2",4.1,1,1,1,1,1);
            default: SendClientMessage(playerid, COLOR_GREY, "USAGE: /gwalk [1-2]");
		}
	}
	return 1;
}
//============================================//
COMMAND:laugh(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
    if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
    SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
    ApplyAnimation(playerid, "RAPPING", "Laugh_01", 4.0, 0, 0, 0, 0, 0);
	return 1;
}
//============================================//
COMMAND:crossarms(playerid, params[])
{
	new aimid;
	if(sscanf(params, "i", aimid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /crossarms [1-5]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
        if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
        SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
		switch(aimid)
		{
		    case 1: ApplyAnimation(playerid, "COP_AMBIENT", "Coplook_loop", 4.0, 0, 1, 1, 1, -1);
            case 2: ApplyAnimation(playerid, "DEALER", "DEALER_IDLE", 4.0, 0, 1, 1, 1, -1);
            case 3: ApplyAnimation(playerid, "DEALER", "DEALER_IDLE_01", 4.0, 0, 1, 1, 1, -1);
            case 4: ApplyAnimation(playerid, "DEALER", "DEALER_IDLE_02", 4.0, 0, 1, 1, 1, -1);
            case 5: ApplyAnimation(playerid, "DEALER", "DEALER_IDLE_03", 4.0, 0, 1, 1, 1, -1);
            default: SendClientMessage(playerid, COLOR_GREY, "USAGE: /crossarms [1-5]");
		}
	}
	return 1;
}
//============================================//
COMMAND:lay(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
    if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
    SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
    ApplyAnimation(playerid,"BEACH", "bather", 4.0, 1, 0, 0, 0, 0);
	return 1;
}
//============================================//
COMMAND:wave(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
    if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
    SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
    ApplyAnimation(playerid, "ON_LOOKERS", "wave_loop", 4.0, 1, 0, 0, 0, 0);
	return 1;
}
//============================================//
COMMAND:msit(playerid, params[])
{
	new aimid;
	if(sscanf(params, "i", aimid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /msit [1-4]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
        if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
        SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
		switch(aimid)
		{
		    case 1: ApplyAnimation(playerid,"BEACH", "ParkSit_M_loop", 4.0, 1, 0, 0, 0, 0);
		    case 2: ApplyAnimation(playerid,"SUNBATHE","ParkSit_M_IdleA", 4.0, 1, 0, 0, 0, 0);
		    case 3: ApplyAnimation(playerid,"SUNBATHE","ParkSit_M_IdleB", 4.0, 1, 0, 0, 0, 0);
		    case 4: ApplyAnimation(playerid,"SUNBATHE","ParkSit_M_IdleC", 4.0, 1, 0, 0, 0, 0);
            default: SendClientMessage(playerid, COLOR_GREY, "USAGE: /msit [1-4]");
		}
	}
	return 1;
}
//============================================//
COMMAND:fsit(playerid, params[])
{
	new aimid;
	if(sscanf(params, "i", aimid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /fsit [1-4]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
        if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
        SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
		switch(aimid)
		{
		    case 1: ApplyAnimation(playerid,"BEACH", "ParkSit_W_loop", 4.0, 1, 0, 0, 0, 0);
		    case 2: ApplyAnimation(playerid,"SUNBATHE","ParkSit_W_IdleA", 4.0, 1, 0, 0, 0, 0);
		    case 3: ApplyAnimation(playerid,"SUNBATHE","ParkSit_W_IdleB", 4.0, 1, 0, 0, 0, 0);
		    case 4: ApplyAnimation(playerid,"SUNBATHE","ParkSit_W_IdleC", 4.0, 1, 0, 0, 0, 0);
            default: SendClientMessage(playerid, COLOR_GREY, "USAGE: /fsit [1-4]");
		}
	}
	return 1;
}
//============================================//
COMMAND:relax(playerid, params[])
{
	new aimid;
	if(sscanf(params, "i", aimid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /relax [1-2]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
        if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
        SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
		switch(aimid)
		{
		    case 1: ApplyAnimation(playerid,"BEACH","Lay_Bac_Loop", 4.0, 1, 0, 0, 0, 0);
            case 2: ApplyAnimation(playerid,"BEACH", "SitnWait_loop_W", 4.0, 1, 0, 0, 0, 0);
            default: SendClientMessage(playerid, COLOR_GREY, "USAGE: /relax [1-2]");
		}
	}
	return 1;
}
//============================================//
COMMAND:bat(playerid, params[])
{
	new aimid;
	if(sscanf(params, "i", aimid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /bat [1-2]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
        if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
        SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
		switch(aimid)
		{
		    case 1: ApplyAnimation(playerid,"CRACK","Bbalbat_Idle_01", 4.0, 1, 0, 0, 0, 0);
            case 2: ApplyAnimation(playerid,"CRACK","Bbalbat_Idle_02", 4.0, 1, 0, 0, 0, 0);
            default: SendClientMessage(playerid, COLOR_GREY, "USAGE: /bat [1-2]");
		}
	}
	return 1;
}
//============================================//
COMMAND:mwalk(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
    if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
    SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
    ApplyAnimation(playerid,"ped","WALK_player",4.1,1,1,1,1,1);
	return 1;
}
//============================================//
COMMAND:fwalk(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
    if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
    SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
    ApplyAnimation(playerid,"ped","WOMAN_walksexy",4.1,1,1,1,1,1);
	return 1;
}
//============================================//
COMMAND:angry(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
    if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
    SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
    ApplyAnimation(playerid,"RIOT","RIOT_ANGRY",4.0,0,0,0,0,0);
	return 1;
}
//============================================//
COMMAND:aim(playerid, params[])
{
	new aimid;
	if(sscanf(params, "i", aimid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /aim [1-7]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
        if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
        SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
		switch(aimid)
		{
		    case 1: ApplyAnimation(playerid,"PED","gang_gunstand",4.0,1,1,1,1,1);
            case 2: ApplyAnimation(playerid, "SHOP", "SHP_Gun_Aim", 4.0, 0, 1, 1, 1, -1);
            case 3: ApplyAnimation(playerid,"PED","Driveby_L",4.0, 0, 1, 1, 1, -1);
            case 4: ApplyAnimation(playerid,"PED","Driveby_R",4.0, 0, 1, 1, 1, -1);
            case 5: ApplyAnimation(playerid,"ped", "ARRESTgun", 4.0, 0, 1, 1, 1, -1);
            case 6: ApplyAnimation(playerid, "SHOP", "ROB_Loop_Threat", 4.0, 1, 0, 0, 0, 0);
            case 7: ApplyAnimation(playerid, "PED", "GUN_STAND", 4.0, 1, 0, 0, 0, 0);
            default: SendClientMessage(playerid, COLOR_GREY, "USAGE: /aim [1-7]");
		}
	}
	return 1;
}
//============================================//
COMMAND:die(playerid, params[])
{
	new aimid;
	if(sscanf(params, "i", aimid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /die [1-6]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
        if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
        SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
		switch(aimid)
		{
		    case 1: ApplyAnimation(playerid, "ped", "FLOOR_hit", 4.0, 0, 1, 1, 1, -1);
		    case 2: ApplyAnimation(playerid, "ped", "FLOOR_hit_f", 4.0, 0, 1, 1, 1, -1);
		    case 3: ApplyAnimation(playerid, "ped", "KO_shot_front", 4.0, 0, 1, 1, 1, -1);
		    case 4: ApplyAnimation(playerid, "ped", "KO_shot_stom", 4.0, 0, 1, 1, 1, -1);
            case 5: ApplyAnimation(playerid, "ped", "BIKE_fall_off", 4.0, 0, 1, 1, 1, -1);
			case 6: ApplyAnimation(playerid, "FINALE", "FIN_Land_Die", 4.0, 0, 1, 1, 1, -1);
            default: return SendClientMessage(playerid, COLOR_GREY, "USAGE: /die [1-6]");
		}
	}
	return 1;
}
//============================================//
COMMAND:gsign(playerid, params[])
{
	new aimid;
	if(sscanf(params, "i", aimid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /gsign [1-5]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
        if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
        SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
		switch(aimid)
		{
		    case 1: ApplyAnimation(playerid,"GHANDS","gsign1",4.0,0,1,1,1,1);
            case 2: ApplyAnimation(playerid,"GHANDS","gsign2",4.0,0,1,1,1,1);
            case 3: ApplyAnimation(playerid,"GHANDS","gsign3",4.0,0,1,1,1,1);
            case 4: ApplyAnimation(playerid,"GHANDS","gsign4",4.0,0,1,1,1,1);
            case 5: ApplyAnimation(playerid,"GHANDS","gsign5",4.0,0,1,1,1,1);
            default: SendClientMessage(playerid, COLOR_GREY, "USAGE: /gsign [1-5]");
		}
	}
	return 1;
}
//============================================//
COMMAND:cpr(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
    if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
    SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
    ApplyAnimation(playerid,"MEDIC","CPR", 4.0, 1, 0, 0, 0, 0);
    return 1;
}
//============================================//
COMMAND:hitch(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
    if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
    SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
    ApplyAnimation(playerid,"MISC","Hiker_Pose", 4.0, 1, 0, 0, 0, 0);
    return 1;
}
//============================================//
COMMAND:injured(playerid, params[])
{
	new aimid;
	if(sscanf(params, "i", aimid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /injured [1-2]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
        if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
        SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
		switch(aimid)
		{
		    case 1: ApplyAnimation(playerid,"SWEET","Sweet_injuredloop", 4.0, 1, 0, 0, 0, 0);
            case 2: ApplyAnimation(playerid,"SWAT","gnstwall_injurd", 4.0, 1, 0, 0, 0, 0);
            default: SendClientMessage(playerid, COLOR_GREY, "USAGE: /injured [1-2]");
		}
	}
	return 1;
}
//============================================//
COMMAND:slapped(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
    if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
    SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
    ApplyAnimation(playerid,"SWEET","ho_ass_slapped",4.0,0,0,0,0,0);
    return 1;
}
//============================================//
COMMAND:invite1(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
    if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
    SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
    ApplyAnimation(playerid,"GANGS","Invite_Yes",4.1,0,1,1,1,1);
    return 1;
}
//============================================//
COMMAND:invite2(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
    if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
    SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
    ApplyAnimation(playerid,"GANGS","Invite_No",4.1,0,1,1,1,1);
    return 1;
}
//============================================//
COMMAND:scratch(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
    if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
    SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
    ApplyAnimation(playerid,"MISC","Scratchballs_01", 4.0, 1, 0, 0, 0, 0);
    return 1;
}
//============================================//
COMMAND:bomb(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
    if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
    SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
    ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0); // Place Bomb
    return 1;
}
//============================================//
COMMAND:vomit(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
    if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
    SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
    ApplyAnimation(playerid, "FOOD", "EAT_Vomit_P", 3.0, 0, 0, 0, 0, 0); // Vomit BAH!
    return 1;
}
//============================================//
COMMAND:eat(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
    if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
    SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
    ApplyAnimation(playerid, "FOOD", "EAT_Burger", 3.0, 0, 0, 0, 0, 0);
    return 1;
}
//============================================//
COMMAND:doorkick(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
    if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
    SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
    ApplyAnimation(playerid, "POLICE", "Door_Kick", 3.0, 0, 0, 0, 0, 0);
    return 1;
}
//============================================//
COMMAND:eatgum(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
    if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
    SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
    ApplyAnimation(playerid, "ped", "gum_eat", 3.0, 0, 0, 0, 0, 0);
    return 1;
}
//============================================//
COMMAND:friskanim(playerid, params[])
{
	new aimid;
	if(sscanf(params, "i", aimid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /friskanim [1-2]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
        if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
        SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
		switch(aimid)
		{
		    case 1: ApplyAnimation(playerid, "POLICE", "plc_drgbst_01", 3.0, 0, 0, 0, 0, 0);
            case 2: ApplyAnimation(playerid, "POLICE", "plc_drgbst_02", 3.0, 0, 0, 0, 0, 0);
            default: SendClientMessage(playerid, COLOR_GREY, "USAGE: /friskanim [1-2]");
		}
	}
	return 1;
}
//============================================//
COMMAND:drink(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
    if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
    SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
    ApplyAnimation(playerid, "GANGS", "drnkbr_prtl", 3.0,1,1,1,1,1);
    return 1;
}
//============================================//
COMMAND:deal(playerid, params[])
{
	new aimid;
	if(sscanf(params, "i", aimid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /deal [1-6]");
	else
	{
	    if(GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
        if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
        SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
		switch(aimid)
		{
		    case 1: ApplyAnimation(playerid, "DEALER", "DEALER_DEAL", 4.1, 0, 0, 0, 0, 0, 1);
		    case 2: ApplyAnimation(playerid, "DEALER", "DRUGS_BUY", 4.1, 0, 0, 0, 0, 0, 1);
		    case 3: ApplyAnimation(playerid, "DEALER", "shop_pay", 4.1, 0, 0, 0, 0, 0, 1);
		    case 4: ApplyAnimation(playerid, "DEALER", "DEALER_IDLE_01", 4.1, 1, 0, 0, 0, 0, 1);
		    case 5: ApplyAnimation(playerid, "DEALER", "DEALER_IDLE_02", 4.1, 1, 0, 0, 0, 0, 1);
		    case 6: ApplyAnimation(playerid, "DEALER", "DEALER_IDLE_03", 4.1, 1, 0, 0, 0, 0, 1);
            default: SendClientMessage(playerid, COLOR_GREY, "USAGE: /deal [1-6]");
		}
	}
	return 1;
}
//============================================//
COMMAND:chat(playerid, params[])
{
	new aimid;
	if(sscanf(params, "i", aimid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /chat [1-9]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
        if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
        SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
		switch(aimid)
		{
		    case 1: ApplyAnimation(playerid,"PED","IDLE_CHAT",4.1,1,1,1,1,1);
            case 2: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkA", 4.0, 0, 1, 1, 1, -1);
            case 3: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkB", 4.0, 0, 1, 1, 1, -1);
            case 4: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkC", 4.0, 0, 1, 1, 1, -1);
            case 5: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkD", 4.0, 0, 1, 1, 1, -1);
            case 6: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkE", 4.0, 0, 1, 1, 1, -1);
            case 7: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkF", 4.0, 0, 1, 1, 1, -1);
            case 8: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkG", 4.0, 0, 1, 1, 1, -1);
            case 9: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkH", 4.0, 0, 1, 1, 1, -1);
            default: SendClientMessage(playerid, COLOR_GREY, "USAGE: /chat [1-9]");
		}
	}
	return 1;
}
COMMAND:togc(playerid, params[])
{
	switch(chatanim[playerid])
	{
		case 0:
		{
			chatanim[playerid] = 1;
			SendClientMessage(playerid,COLOR_GREEN,"Chat hand gestures enabled.");
		}
		case 1:
		{
			chatanim[playerid] = 0;
			SendClientMessage(playerid,COLOR_GREEN,"Chat hand gestures disabled.");
		}
		default:
		{
			chatanim[playerid] = 0;
			SendClientMessage(playerid,COLOR_GREEN,"Chat hand gestures disabled.");
		}
	}
	return 1;
}
//============================================//
COMMAND:fucku(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
    if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
    SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
    ApplyAnimation(playerid,"PED","fucku",4.0,0,0,0,0,0);
    return 1;
}
//============================================//
COMMAND:taichi(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
    if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
    SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
    ApplyAnimation(playerid,"PARK","Tai_Chi_Loop", 4.0, 1, 0, 0, 0, 0);
    return 1;
}
//============================================//
COMMAND:cry(playerid, params[])
{
	new aimid;
	if(sscanf(params, "i", aimid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /cry [1-2]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
        if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
        SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
		switch(aimid)
		{
		    case 1: ApplyAnimation(playerid,"GRAVEYARD","mrnF_loop", 4.0, 1, 0, 0, 0, 0);
            case 2: ApplyAnimation(playerid,"GRAVEYARD","mrnM_loop", 4.0, 1, 0, 0, 0, 0);
            default: SendClientMessage(playerid, COLOR_GREY, "USAGE: /cry [1-2]");
		}
	}
	return 1;
}
//============================================//
COMMAND:kiss(playerid, params[])
{
	new aimid;
	if(sscanf(params, "i", aimid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /kiss [1-6]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
        if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
        SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
		switch(aimid)
		{
		    case 1: ApplyAnimation(playerid,"KISSING","Grlfrd_Kiss_01",4.0,0,0,0,0,0);
            case 2: ApplyAnimation(playerid,"KISSING","Grlfrd_Kiss_02",4.0,0,0,0,0,0);
            case 3: ApplyAnimation(playerid,"KISSING","Grlfrd_Kiss_03",4.0,0,0,0,0,0);
            case 4: ApplyAnimation(playerid,"KISSING","Playa_Kiss_01",4.0,0,0,0,0,0);
            case 5: ApplyAnimation(playerid,"KISSING","Playa_Kiss_02",4.0,0,0,0,0,0);
            case 6: ApplyAnimation(playerid,"KISSING","Playa_Kiss_03",4.0,0,0,0,0,0);
            default: SendClientMessage(playerid, COLOR_GREY, "USAGE: /kiss [1-6]");
		}
	}
	return 1;
}
//============================================//
COMMAND:carsit(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
    if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
    SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
    ApplyAnimation(playerid,"CAR","Tap_hand", 4.0, 1, 0, 0, 0, 0);
    return 1;
}
//============================================//
COMMAND:stretch(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
    if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
    SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
    ApplyAnimation(playerid,"PLAYIDLES","stretch",4.0,0,0,0,0,0);
    return 1;
}
//============================================//
COMMAND:chant(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
    if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
    SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
    ApplyAnimation(playerid,"RIOT","RIOT_CHANT", 4.0, 1, 0, 0, 0, 0);
    return 1;
}
//============================================//
COMMAND:ghand(playerid, params[])
{
	new aimid;
	if(sscanf(params, "i", aimid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /ghand [1-5]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
        if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
        SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
		switch(aimid)
		{
		    case 1: ApplyAnimation(playerid,"GHANDS","gsign1LH",4.0,0,1,1,1,1);
            case 2: ApplyAnimation(playerid,"GHANDS","gsign2LH",4.0,0,1,1,1,1);
            case 3: ApplyAnimation(playerid,"GHANDS","gsign3LH",4.0,0,1,1,1,1);
            case 4: ApplyAnimation(playerid,"GHANDS","gsign4LH",4.0,0,1,1,1,1);
            case 5: ApplyAnimation(playerid,"GHANDS","gsign5LH",4.0,0,1,1,1,1);
            default: SendClientMessage(playerid, COLOR_GREY, "USAGE: /ghand [1-5]");
		}
	}
	return 1;
}
//============================================//
COMMAND:exhausted(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
    if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
    SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
    ApplyAnimation(playerid,"FAT","IDLE_tired", 4.0, 1, 0, 0, 0, 0);
    return 1;
}
//============================================//
COMMAND:carsmoke(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
    if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
    SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
    ApplyAnimation(playerid,"PED","Smoke_in_car", 4.0, 1, 0, 0, 0, 0);
    return 1;
}
//============================================//
COMMAND:basket(playerid, params[])
{
	new aimid;
	if(sscanf(params, "i", aimid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /basket [1-7]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
        if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
        SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
		switch(aimid)
		{
		    case 1: ApplyAnimation(playerid,"BSKTBALL","BBALL_def_loop", 4.0, 1, 0, 0, 0, 0);
            case 2: ApplyAnimation(playerid,"BSKTBALL","BBALL_idleloop", 4.0, 1, 0, 0, 0, 0);
            case 3: ApplyAnimation(playerid,"BSKTBALL","BBALL_pickup",4.0,0,0,0,0,0);
            case 4: ApplyAnimation(playerid,"BSKTBALL","BBALL_Jump_Shot",4.0,0,0,0,0,0);
            case 5: ApplyAnimation(playerid,"BSKTBALL","BBALL_Dnk",4.1,0,1,1,1,1);
            case 6: ApplyAnimation(playerid,"BSKTBALL","BBALL_run",4.1,1,1,1,1,1);
            case 7: ApplyAnimation(playerid,"BSKTBALL","BBALL_walk",4.1,1,1,1,1,1);
            default: SendClientMessage(playerid, COLOR_GREY, "USAGE: /basket [1-7]");
		}
	}
	return 1;
}
//============================================//
COMMAND:cockgun(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
    if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
    SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
    ApplyAnimation(playerid, "SILENCED", "Silence_reload", 3.0, 0, 0, 0, 0, 0);
    return 1;
}
//============================================//
COMMAND:toss(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
    if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
    SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
    ApplyAnimation(playerid, "GRENADE", "WEAPON_throw", 3.0, 0, 0, 0, 0, 0);
    return 1;
}
//============================================//
COMMAND:open(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
    if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
    SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
    ApplyAnimation(playerid, "AIRPORT", "thrw_barl_thrw", 3.0, 0, 0, 0, 0, 0);
    return 1;
}
//============================================//
COMMAND:liftup(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
    if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
    SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
    ApplyAnimation(playerid, "CARRY", "liftup", 3.0, 0, 0, 0, 0, 0);
    return 1;
}
//============================================//
COMMAND:putdown(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
    SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
    ApplyAnimation(playerid, "CARRY", "putdwn", 3.0, 0, 0, 0, 0, 0);
    return 1;
}
//============================================//
COMMAND:hide(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
    if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
    SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
    ApplyAnimation(playerid, "ped", "cower", 3.0, 1, 0, 0, 0, 0);
    return 1;
}
//============================================//
COMMAND:smoke(playerid, params[])
{
	new aimid;
	if(sscanf(params, "i", aimid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /smoke [1-2]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
        if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
        SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
		switch(aimid)
		{
		    case 1: ApplyAnimation(playerid,"SMOKING", "M_smklean_loop", 4.0, 1, 0, 0, 1, 0);
            case 2: ApplyAnimation(playerid,"GANGS","smkcig_prtl",4.0,0,1,1,1,1);
            default: SendClientMessage(playerid, COLOR_GREY, "USAGE: /smoke [1-2]");
		}
	}
	return 1;
}
//============================================//
COMMAND:spray(playerid, params[])
{
	new aimid;
	if(sscanf(params, "i", aimid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /spray [1-4]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
        if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
        SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
		switch(aimid)
		{
		    case 1: ApplyAnimation(playerid,"GRAFFITI", "graffiti_Chkout", 4.0,1,1,1,1,1);
            case 2: ApplyAnimation(playerid,"GRAFFITI","spraycan_fire",4.0,0,1,1,1,1);
            case 3: ApplyAnimation(playerid,"SPRAYCAN","spraycan_fire",4.0,0,1,1,1,1);
            case 4: ApplyAnimation(playerid,"SPRAYCAN","spraycan_full",4.0,0,1,1,1,1);
            default: SendClientMessage(playerid, COLOR_GREY, "USAGE: /sray [1-4]");
		}
	}
	return 1;
}
//============================================//
COMMAND:lean(playerid, params[])
{
	new aimid;
	if(sscanf(params, "i", aimid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /lean [1-3]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
        if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
        SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
		switch(aimid)
		{
		    case 1: ApplyAnimation(playerid,"GANGS","leanIDLE",4.0,0,0,0,1,0);
            case 2: ApplyAnimation(playerid,"MISC","Plyrlean_loop",4.0,0,0,0,1,0);
            case 3: ApplyAnimation(playerid,"BAR","BARman_idle",3.0,0,1,1,1,0);
            default: SendClientMessage(playerid, COLOR_GREY, "USAGE: /lean [1-3]");
		}
	}
	return 1;
}
//============================================//
COMMAND:bar(playerid, params[])
{
	new aimid;
	if(sscanf(params, "i", aimid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /bar [1-12]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
        if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
        SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
		switch(aimid)
		{
		    case 1: ApplyAnimation(playerid,"BAR","Barcustom_get",4.0,0,0,0,1,0);
		    case 2: ApplyAnimation(playerid,"BAR","Barcustom_loop",4.0,0,0,0,1,0);
		    case 3: ApplyAnimation(playerid,"BAR","Barcustom_order",4.0,0,0,0,1,0);
		    case 4: ApplyAnimation(playerid,"BAR","BARman_idle",4.0, 1, 0, 0, 1, 0);
		    case 5: ApplyAnimation(playerid,"BAR","Barserve_bottle",4.0,0,0,0,1,0);
		    case 6: ApplyAnimation(playerid,"BAR","Barserve_give",4.0,0,0,0,1,0);
		    case 7: ApplyAnimation(playerid,"BAR","Barserve_glass",4.0,0,0,0,1,0);
		    case 8: ApplyAnimation(playerid,"BAR","Barserve_in",4.0,0,0,0,1,0);
		    case 9: ApplyAnimation(playerid,"BAR","Barserve_loop",4.0,0,0,0,1,0);
		    case 10: ApplyAnimation(playerid,"BAR","Barserve_order",4.0,0,0,0,1,0);
		    case 11: ApplyAnimation(playerid,"BAR","dnk_stndF_loop",4.0,0,0,0,1,0);
		    case 12: ApplyAnimation(playerid,"BAR","dnk_stndM_loop",4.0,0,0,0,1,0);
            default: SendClientMessage(playerid, COLOR_GREY, "USAGE: /lean [1-12]");
		}
	}
	return 1;
}
//============================================//
COMMAND:bench(playerid, params[])
{
	new aimid;
	if(sscanf(params, "i", aimid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /bench [1-5]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
        if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
        SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
		switch(aimid)
		{
		    case 1: ApplyAnimation(playerid,"benchpress","gym_bp_geton",4.0,0,0,0,1,0);
		    case 2: ApplyAnimation(playerid,"benchpress","gym_bp_getoff",4.0,0,0,0,1,0);
		    case 3: ApplyAnimation(playerid,"benchpress","gym_bp_down",4.0,0,0,0,1,0);
		    case 4: ApplyAnimation(playerid,"benchpress","gym_bp_up_A",4.0,0,0,0,1,0);
		    case 5: ApplyAnimation(playerid,"benchpress","gym_bp_up_B",4.0,0,0,0,1,0);
            default: SendClientMessage(playerid, COLOR_GREY, "USAGE: /bench [1-5]");
		}
	}
	return 1;
}
//============================================//
COMMAND:dance(playerid, params[])
{
	new aimid;
	if(sscanf(params, "i", aimid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /dance [1-15]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Control") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are currently frozen!");
        if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
        if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
        SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
		switch(aimid)
		{
		    case 1: SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DANCE1);
            case 2: SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DANCE2);
            case 3: SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DANCE3);
            case 4: SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DANCE4);
            case 5: ApplyAnimation(playerid,"DANCING","bd_clap",4.0, 1, 0, 0, 1, 0);
            case 6: ApplyAnimation(playerid,"DANCING","DAN_Down_A",4.0, 1, 0, 0, 1, 0);
            case 7: ApplyAnimation(playerid,"DANCING","DAN_Left_A",4.0, 1, 0, 0, 1, 0);
            case 8: ApplyAnimation(playerid,"DANCING","DAN_Loop_A",4.0, 1, 0, 0, 1, 0);
            case 9: ApplyAnimation(playerid,"DANCING","DAN_Right_A",4.0, 1, 0, 0, 1, 0);
            case 10: ApplyAnimation(playerid,"DANCING","DAN_Up_A",4.0, 1, 0, 0, 1, 0);
            case 11: ApplyAnimation(playerid,"DANCING","dnce_M_a",4.0, 1, 0, 0, 1, 0);
            case 12: ApplyAnimation(playerid,"DANCING","dnce_M_b",4.0, 1, 0, 0, 1, 0);
            case 13: ApplyAnimation(playerid,"DANCING","dnce_M_c",4.0, 1, 0, 0, 1, 0);
            case 14: ApplyAnimation(playerid,"DANCING","dnce_M_d",4.0, 1, 0, 0, 1, 0);
            case 15: ApplyAnimation(playerid,"DANCING","dnce_M_e",4.0, 1, 0, 0, 1, 0);
            default: SendClientMessage(playerid, COLOR_GREY, "USAGE: /dance [1-15]");
		}
	}
	return 1;
}
//============================================//
COMMAND:rap(playerid, params[])
{
	new aimid;
	if(sscanf(params, "i", aimid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /rap [1-3]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
        if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
        SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
		switch(aimid)
		{
		    case 1: ApplyAnimation(playerid,"RAPPING","RAP_A_Loop",4.0,1,1,1,1,0);
            case 2: ApplyAnimation(playerid,"RAPPING","RAP_B_Loop",4.0,1,1,1,1,0);
            case 3: ApplyAnimation(playerid,"RAPPING","RAP_C_Loop",4.0,1,1,1,1,0);
            default: SendClientMessage(playerid, COLOR_GREY, "USAGE: /rap [1-3]");
		}
	}
	return 1;
}
//============================================//
COMMAND:wankoff(playerid, params[])
{
	new aimid;
	if(sscanf(params, "i", aimid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /wankoff [1-3]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
        if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
        SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
		switch(aimid)
		{
		    case 1: ApplyAnimation(playerid,"PAULNMAC","wank_in",4.0,1,1,1,1,0);
            case 2: ApplyAnimation(playerid,"PAULNMAC","wank_loop",4.0, 1, 0, 0, 1, 0);
            case 3: ApplyAnimation(playerid,"PAULNMAC","wank_out",4.0,1,1,1,1,0);
            default: SendClientMessage(playerid, COLOR_GREY, "USAGE: /wankoff [1-3]");
		}
	}
	return 1;
}
//============================================//
COMMAND:strip(playerid, params[])
{
	new aimid;
	if(sscanf(params, "i", aimid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /strip [1-7]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
        if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
        SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
		switch(aimid)
		{
		    case 1: ApplyAnimation(playerid,"STRIP","strip_A",4.0,1,1,1,1,0);
            case 2: ApplyAnimation(playerid,"STRIP","strip_B",4.0,1,1,1,1,0);
            case 3: ApplyAnimation(playerid,"STRIP","strip_C",4.0,1,1,1,1,0);
            case 4: ApplyAnimation(playerid,"STRIP","strip_D",4.0,1,1,1,1,0);
            case 5: ApplyAnimation(playerid,"STRIP","strip_E",4.0,1,1,1,1,0);
            case 6: ApplyAnimation(playerid,"STRIP","strip_F",4.0,1,1,1,1,0);
            case 7: ApplyAnimation(playerid,"STRIP","strip_G",4.0,1,1,1,1,0);
            default: SendClientMessage(playerid, COLOR_GREY, "USAGE: /strip [1-7]");
		}
	}
	return 1;
}
//============================================//
COMMAND:sexy(playerid, params[])
{
	new aimid;
	if(sscanf(params, "i", aimid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /sexy [1-8]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
        if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
        SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
		switch(aimid)
		{
		    case 1: ApplyAnimation(playerid,"SNM","SPANKING_IDLEW",4.1,0,1,1,1,1);
            case 2: ApplyAnimation(playerid,"SNM","SPANKING_IDLEP",4.1,0,1,1,1,1);
            case 3: ApplyAnimation(playerid,"SNM","SPANKINGW",4.1,0,1,1,1,1);
            case 4: ApplyAnimation(playerid,"SNM","SPANKINGP",4.1,0,1,1,1,1);
            case 5: ApplyAnimation(playerid,"SNM","SPANKEDW",4.1,0,1,1,1,1);
            case 6: ApplyAnimation(playerid,"SNM","SPANKEDP",4.1,0,1,1,1,1);
            case 7: ApplyAnimation(playerid,"SNM","SPANKING_ENDW",4.1,0,1,1,1,1);
            case 8: ApplyAnimation(playerid,"SNM","SPANKING_ENDP",4.1,0,1,1,1,1);
            default: SendClientMessage(playerid, COLOR_GREY, "USAGE: /sexy [1-8]");
		}
	}
	return 1;
}
//============================================//
COMMAND:bj(playerid, params[])
{
	new aimid;
	if(sscanf(params, "i", aimid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /bj [1-18]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
        if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
        SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
		switch(aimid)
		{
		    case 1: ApplyAnimation(playerid,"BLOWJOBZ","BJ_COUCH_START_P",4.1,0,1,1,1,1);
            case 2: ApplyAnimation(playerid,"BLOWJOBZ","BJ_COUCH_START_W",4.1,0,1,1,1,1);
            case 3: ApplyAnimation(playerid,"BLOWJOBZ","BJ_COUCH_LOOP_P",4.1,0,1,1,1,1);
            case 4: ApplyAnimation(playerid,"BLOWJOBZ","BJ_COUCH_LOOP_W",4.1,0,1,1,1,1);
            case 5: ApplyAnimation(playerid,"BLOWJOBZ","BJ_COUCH_END_P",4.1,0,1,1,1,1);
            case 6: ApplyAnimation(playerid,"BLOWJOBZ","BJ_COUCH_END_W",4.1,0,1,1,1,1);
            case 7: ApplyAnimation(playerid,"BLOWJOBZ","BJ_STAND_START_P",4.1,0,1,1,1,1);
            case 8: ApplyAnimation(playerid,"BLOWJOBZ","BJ_STAND_START_W",4.1,0,1,1,1,1);
            case 9: ApplyAnimation(playerid,"BLOWJOBZ","BJ_STAND_LOOP_P",4.1,0,1,1,1,1);
            case 10: ApplyAnimation(playerid,"BLOWJOBZ","BJ_STAND_LOOP_W",4.1,0,1,1,1,1);
            case 11: ApplyAnimation(playerid,"BLOWJOBZ","BJ_STAND_END_P",4.1,0,1,1,1,1);
            case 12: ApplyAnimation(playerid,"BLOWJOBZ","BJ_STAND_END_W",4.1,0,1,1,1,1);
            case 13: ApplyAnimation(playerid, "BLOWJOBZ", "BJ_CAR_START_W", 4.0, 0, 1, 1, 1, -1);
		    case 14: ApplyAnimation(playerid, "BLOWJOBZ", "BJ_CAR_START_P", 4.0, 0, 1, 1, 1, -1);
		    case 15: ApplyAnimation(playerid, "BLOWJOBZ", "BJ_CAR_LOOP_W", 4.0, 1, 1, 1, 1, 0);
		    case 16: ApplyAnimation(playerid, "BLOWJOBZ", "BJ_CAR_LOOP_P", 4.0, 1, 1, 1, 1, 0);
		    case 17: ApplyAnimation(playerid, "BLOWJOBZ", "BJ_CAR_END_W", 4.0, 0, 1, 1, 1, -1);
		    case 18: ApplyAnimation(playerid, "BLOWJOBZ", "BJ_CAR_END_P", 4.0, 0, 1, 1, 1, -1);
            default: SendClientMessage(playerid, COLOR_GREY, "USAGE: /bj [1-18]");
		}
	}
	return 1;
}
//============================================//
COMMAND:elbow(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
    if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
    SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
    ApplyAnimation(playerid,"FIGHT_D","FightD_3",4.0,0,1,1,0,0);
    return 1;
}
//============================================//
COMMAND:fstance(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
    if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
    SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
    ApplyAnimation(playerid,"FIGHT_D","FightD_IDLE",4.0,1,1,1,1,0);
    return 1;
}
//============================================//
COMMAND:gpunch(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
    if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
    SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
    ApplyAnimation(playerid,"FIGHT_B","FightB_G",4.0,0,0,0,0,0);
    return 1;
}
//============================================//
COMMAND:airkick(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
    if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
    SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
    ApplyAnimation(playerid,"FIGHT_C","FightC_M",4.0,0,1,1,0,0);
    return 1;
}
//============================================//
COMMAND:gkick(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
    if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
    SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
    ApplyAnimation(playerid,"FIGHT_D","FightD_G",4.0,0,0,0,0,0);
    return 1;
}
//============================================//
COMMAND:dpunch(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
    if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
    SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
    ApplyAnimation(playerid,"FIGHT_B","FightB_1",4.0,0,1,1,0,0);
    return 1;
}
//============================================//
COMMAND:getup(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0 && GetPVarInt(playerid, "Dead") != 5) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
    if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
    SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
    if(GetPVarInt(playerid, "Dead") == 5)
    {
        if(GetPVarInt(playerid, "CrackTime") > GetCount()) return SendClientMessage(playerid, COLOR_GREY, "You must wait atleast a minute before getting up.");
        SetPVarInt(playerid, "Dead", 0);
    }
    ApplyAnimation(playerid,"PED","getup",4.0,0,0,0,0,0);
    return 1;
}
//============================================//
COMMAND:cuffanim(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
    if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
    SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
    ApplyAnimation(playerid,"COP_AMBIENT","Copbrowse_shake",4.0, 0, 1, 1, 1, -1);
    return 1;
}
//============================================//
COMMAND:celebrate(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
    if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
    SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
    ApplyAnimation(playerid,"benchpress","gym_bp_celebrate", 4.0, 1, 0, 0, 0, 0);
    return 1;
}
//============================================//
COMMAND:eatsit(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
    if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
    SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
    ApplyAnimation(playerid,"FOOD","FF_Sit_Loop", 4.0, 1, 0, 0, 0, 0);
    return 1;
}
//============================================//
COMMAND:dive(playerid, params[])
{
	new aimid;
	if(sscanf(params, "i", aimid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /dive [1-3]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
        if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
        SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
		switch(aimid)
		{
            case 1: ApplyAnimation(playerid,"ped","Crouch_Roll_L",4.0,0,1,1,0,0);
            case 2: ApplyAnimation(playerid,"ped","Crouch_Roll_R",4.0,0,1,1,0,0);
            case 3: ApplyAnimation(playerid,"ped","EV_dive",4.0,0,1,1,0,0);
            default: SendClientMessage(playerid, COLOR_GREY, "USAGE: /dive [1-3]");
		}
	}
	return 1;
}
//============================================//
COMMAND:hold(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
    if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
    SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
    ApplyAnimation(playerid, "ped", "IDLE_armed", 4.0, 1, 0, 0, 1, 0);
    return 1;
}
//============================================//
COMMAND:pool(playerid, params[])
{
	new aimid;
	if(sscanf(params, "i", aimid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /pool [1-11]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
        if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
        SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
		switch(aimid)
		{
		    case 1: ApplyAnimation(playerid,"POOL","POOL_ChalkCue",4.0, 0, 1, 1, 1, -1);
		    case 2: ApplyAnimation(playerid,"POOL","POOL_Idle_Stance",4.0, 0, 1, 1, 1, -1);
		    case 3: ApplyAnimation(playerid,"POOL","POOL_Long_Shot",4.0, 0, 1, 1, 1, -1);
		    case 4: ApplyAnimation(playerid,"POOL","POOL_Long_Start",4.0, 0, 1, 1, 1, -1);
		    case 5: ApplyAnimation(playerid,"POOL","POOL_Med_Shot",4.0, 0, 1, 1, 1, -1);
		    case 6: ApplyAnimation(playerid,"POOL","POOL_Med_Start",4.0, 0, 1, 1, 1, -1);
		    case 7: ApplyAnimation(playerid,"POOL","POOL_Place_White",4.0, 0, 1, 1, 1, -1);
		    case 8: ApplyAnimation(playerid,"POOL","POOL_Short_Shot",4.0, 0, 1, 1, 1, -1);
		    case 9: ApplyAnimation(playerid,"POOL","POOL_Short_Start",4.0, 0, 1, 1, 1, -1);
		    case 10: ApplyAnimation(playerid,"POOL","POOL_XLong_Shot",4.0, 0, 1, 1, 1, -1);
		    case 11: ApplyAnimation(playerid,"POOL","POOL_XLong_Start",4.0, 0, 1, 1, 1, -1);
            default: SendClientMessage(playerid, COLOR_GREY, "USAGE: /pool [1-11]");
		}
	}
	return 1;
}
//============================================//
COMMAND:gfunk(playerid, params[])
{
	new aimid;
	if(sscanf(params, "i", aimid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /gfunk [1-17]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
        if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
        SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
		switch(aimid)
		{
		    case 1: ApplyAnimation(playerid,"GFUNK","DANCE_LOOP",4.0, 1, 0, 0, 1, 0);
		    case 2: ApplyAnimation(playerid,"GFUNK","DANCE_G3",4.0, 1, 0, 0, 1, 0);
		    case 3: ApplyAnimation(playerid,"GFUNK","DANCE_G4",4.0, 1, 0, 0, 1, 0);
		    case 4: ApplyAnimation(playerid,"GFUNK","DANCE_G2",4.0, 1, 0, 0, 1, 0);
		    case 5: ApplyAnimation(playerid,"GFUNK","DANCE_G1",4.0, 1, 0, 0, 1, 0);
		    case 6: ApplyAnimation(playerid,"GFUNK","DANCE_G10",4.0, 1, 0, 0, 1, 0);
		    case 7: ApplyAnimation(playerid,"GFUNK","DANCE_G9",4.0, 1, 0, 0, 1, 0);
		    case 8: ApplyAnimation(playerid,"GFUNK","DANCE_G11",4.0, 1, 0, 0, 1, 0);
		    case 9: ApplyAnimation(playerid,"GFUNK","DANCE_G12",4.0, 1, 0, 0, 1, 0);
		    case 10: ApplyAnimation(playerid,"WOP","DANCE_LOOP",4.0, 1, 0, 0, 1, 0);
		    case 11: ApplyAnimation(playerid,"WOP","DANCE_G10",4.0, 1, 0, 0, 1, 0);
		    case 12: ApplyAnimation(playerid,"WOP","DANCE_G9",4.0, 1, 0, 0, 1, 0);
		    case 13: ApplyAnimation(playerid,"WOP","DANCE_G12",4.0, 1, 0, 0, 1, 0);
		    case 14: ApplyAnimation(playerid,"WOP","DANCE_G11",4.0, 1, 0, 0, 1, 0);
		    case 15: ApplyAnimation(playerid,"WOP","DANCE_G2",4.0, 1, 0, 0, 1, 0);
		    case 16: ApplyAnimation(playerid,"WOP","DANCE_G1",4.0, 1, 0, 0, 1, 0);
		    case 17: ApplyAnimation(playerid,"WOP","DANCE_G4",4.0, 1, 0, 0, 1, 0);
            default: SendClientMessage(playerid, COLOR_GREY, "USAGE: /gfunk [1-17]");
		}
	}
	return 1;
}
//============================================//
COMMAND:idle(playerid, params[])
{
	new aimid;
	if(sscanf(params, "i", aimid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /idle [1-4]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
        if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
        SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
		switch(aimid)
		{
		    case 1: ApplyAnimation(playerid, "PED", "IDLE_HBHB", 4.0, 1, 0, 0, 1, 0);
		    case 2: ApplyAnimation(playerid, "PLAYIDLES", "shift", 4.0,1,1,1,1,0);
		    case 3: ApplyAnimation(playerid, "PLAYIDLES", "shldr", 4.0,1,1,1,1,0);
		    case 4: ApplyAnimation(playerid, "PLAYIDLES", "strleg", 4.0,1,1,1,1,0);
            default: SendClientMessage(playerid, COLOR_GREY, "USAGE: /idle [1-4]");
		}
	}
	return 1;
}
//============================================//
COMMAND:box(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
    if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
    SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
    ApplyAnimation(playerid,"GYMNASIUM","gym_shadowbox",4.1,1,1,1,1,1);
    return 1;
}
//============================================//
COMMAND:hoodfrisked(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
    if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
    SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
    ApplyAnimation(playerid,"POLICE","crm_drgbst_01",4.0,0,1,1,1,0);
    return 1;
}
//============================================//
COMMAND:lookout(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
    if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
    SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
    ApplyAnimation(playerid, "SHOP", "ROB_Shifty", 4.0, 0, 0, 0, 0, 0);
    return 1;
}
//============================================//
COMMAND:follow(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
    if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
    SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
    ApplyAnimation(playerid,"WUZI","Wuzi_follow",4.0,0,0,0,0,0);
    return 1;
}
//============================================//
COMMAND:facepalm(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
    if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
    SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
    ApplyAnimation(playerid, "MISC", "plyr_shkhead", 4.0, 0, 0, 0, 0, 0);
    return 1;
}
//============================================//
COMMAND:cover(playerid, params[])
{
	new aimid;
	if(sscanf(params, "i", aimid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /cover [1-6]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
        if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
        SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
		switch(aimid)
		{
            case 1: ApplyAnimation(playerid, "SWAT", "swt_wllshoot_in_L", 4.0, 0, 1, 1, 1, -1);
            case 2: ApplyAnimation(playerid, "SWAT", "swt_wllshoot_in_R", 4.0, 0, 1, 1, 1, -1);
            case 3: ApplyAnimation(playerid, "SWAT", "swt_wllshoot_out_L", 4.0, 0, 1, 1, 1, -1);
            case 4: ApplyAnimation(playerid, "SWAT", "swt_wllshoot_out_R", 4.0, 0, 1, 1, 1, -1);
            case 5: ApplyAnimation(playerid, "SWAT", "swt_wllpk_L", 4.0, 0, 1, 1, 1, -1);
            case 6: ApplyAnimation(playerid, "SWAT", "swt_wllpk_R", 4.0, 0, 1, 1, 1, -1);
            default: SendClientMessage(playerid, COLOR_GREY, "USAGE: /cover [1-6]");
		}
	}
	return 1;
}
//============================================//
COMMAND:fixcar(playerid, params[])
{
	new aimid;
	if(sscanf(params, "i", aimid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /fixcar [1-2]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
        if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
        SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
		switch(aimid)
		{
		    case 1: ApplyAnimation(playerid, "CAR","Fixn_Car_Loop", 4.0, 1, 0, 0, 1, 0);
            case 2: ApplyAnimation(playerid, "CAR","Fixn_Car_Out", 3.0, 0, 0, 0, 0, 0);
            default: SendClientMessage(playerid, COLOR_GREY, "USAGE: /fixcar [1-2]");
		}
	}
	return 1;
}
//============================================//
COMMAND:lowrider(playerid, params[])
{
	new aimid;
	if(sscanf(params, "i", aimid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /lowrider [1-8]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
        if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
        SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
		switch(aimid)
		{
		    case 1: ApplyAnimation(playerid, "LOWRIDER","lrgirl_hair", 4.0, 0, 1, 1, 1, -1);
		    case 2: ApplyAnimation(playerid, "LOWRIDER","lrgirl_hurry", 4.0, 0, 1, 1, 1, -1);
		    case 3: ApplyAnimation(playerid, "LOWRIDER","lrgirl_idleloop", 4.0, 0, 1, 1, 1, -1);
		    case 4: ApplyAnimation(playerid, "LOWRIDER","lrgirl_idle_to_l0", 4.0, 0, 1, 1, 1, -1);
		    case 5: ApplyAnimation(playerid, "LOWRIDER","lrgirl_l0_loop", 4.0, 0, 1, 1, 1, -1);
		    case 6: ApplyAnimation(playerid, "LOWRIDER","lrgirl_l1_loop", 4.0, 0, 1, 1, 1, -1);
		    case 7: ApplyAnimation(playerid, "LOWRIDER","lrgirl_l1_to_l2", 4.0, 0, 1, 1, 1, -1);
		    case 8: ApplyAnimation(playerid, "LOWRIDER","lrgirl_l2_to_l3", 4.0, 0, 1, 1, 1, -1);
            default: SendClientMessage(playerid, COLOR_GREY, "USAGE: /lowrider [1-8]");
		}
	}
	return 1;
}
//============================================//
COMMAND:yell(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
    if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
    SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
    ApplyAnimation(playerid, "RIOT", "RIOT_shout", 3.0, 0, 0, 0, 0, 0);
    return 1;
}
//============================================//
COMMAND:puton(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
    if(GetPVarInt(playerid, "AnimDelay") > GetCount()) return SendClientMessage(playerid, COLOR_WHITE, "You must wait to apply another animation.");
    SetPVarInt(playerid, "AnimDelay" , GetCount()+SCRIPT_ANIMDELAY), SetPVarInt(playerid, "AnimUse" , 1);
    ApplyAnimation(playerid, "goggles", "goggles_put_on", 3.0, 0, 0, 0, 0, 0);
    return 1;
}
//============================================//
COMMAND:fdduty(playerid, params[])
{
	if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Control") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are currently frozen!");
    if(GetPVarInt(playerid, "Duty") != 1) return SendClientMessage(playerid, COLOR_WHITE, "You can not use this while not on duty.");
    if(!PlayerToCar(playerid,1,3.0)) return SendClientMessage(playerid, COLOR_LIGHTRED, "WARNING: You are not close to any vehicle.");
    new carid = PlayerToCar(playerid,2,3.0);
    if(IsNotAEngineCar(carid)) return SendClientMessage(playerid, COLOR_GREY, "This vehicle dosen't have an engine.");
    if(GetPVarInt(playerid, "Member") == 2 && GetPVarInt(playerid, "Rank") > 1)
    {
		switch(GetPVarInt(playerid, "Rank"))
		{
		    case 1 .. 2:
		    {
			    SendClientMessage(playerid, COLOR_GREY, "You do not have access to fire dept equipment.");
			    return true;
			}
		}
        switch(GetVehicleModel(carid))
        {
            case 407, 427, 490, 544, 596, 597, 598, 599:
            {
                ShowPlayerDialog(playerid,101,DIALOG_STYLE_LIST,"LSFD Equipment","Toggle Duty\nFirefighter Equipment\nScuba Gear","Select", "");
            }
            default: SendClientMessage(playerid, COLOR_GREY, "You can only access this command around a firetruck!");
        }
    }
	return 1;
}
//============================================//
COMMAND:fdlocate(playerid, params[])
{
	if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Control") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are currently frozen!");
    if(GetPVarInt(playerid, "Duty") != 1) return SendClientMessage(playerid, COLOR_WHITE, "You can not use this while not on duty.");
    if(GetPVarInt(playerid, "FDDUTY") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You can not use this while not on fire duty.");
    if(GetPVarInt(playerid, "Member") == 2 && GetPVarInt(playerid, "Rank") > 1)
    {
		new string[128], found = 0;
      	for(new i = 0; i < sizeof(FDInfo); i++)
  	    {
		    if(FDInfo[i][fTime] > 0)
		    {
				SendClientMessage(playerid, COLOR_PINK, "DISPATCH: We've marked a located fire on your GPS.");
				format(string, 128, "DISPATCH: Location: %s.", GetZone(FDInfo[i][fdX], FDInfo[i][fdY], FDInfo[i][fdZ]));
				SendClientMessage(playerid, COLOR_PINK, string);
	            SetPlayerCheckpoint(playerid,FDInfo[i][fdX], FDInfo[i][fdY], FDInfo[i][fdZ],2.0);
		        found++;
		        return true;
		    }
  	    }
  	    if(found == 0) return SendClientMessage(playerid, COLOR_GREY, "There is no fires to locate!");
    }
	return 1;
}
//============================================//
COMMAND:treatwound(playerid, params[])
{
	new string[128], charge, Float:health, hp;
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Control") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are currently frozen!");
	if(GetPVarInt(playerid,"Wound_T") == 0 && GetPVarInt(playerid,"Wound_A") == 0 && GetPVarInt(playerid,"Wound_L") == 0) return SendClientMessage(playerid,COLOR_GREY,"You don't have any wounds.");
    if(IsPlayerInRangeOfPoint(playerid,3.0,2041.0728,-1337.5627,1271.4860))
    {
		charge = 150;
		if(GetPVarInt(playerid,"Wound_T") > 0) charge +=100;
		if(GetPVarInt(playerid,"Wound_A") > 0) charge +=50;
		if(GetPVarInt(playerid,"Wound_L") > 0) charge +=80;
		GetPlayerHealth(playerid, health);
		hp = floatround(health);
		switch(hp)
		{
		    case 0 .. 20: charge +=100;
		    case 21 .. 40: charge +=80;
		    case 41 .. 60: charge +=60;
		    case 61 .. 80: charge +=40;
		    case 81 .. 150: charge +=20;
		}
		SetPVarInt(playerid, "WoundC", charge);
		format(string, 128, "Would you like to treat your wound(s)?\nCost: $%d", charge);
		ShowPlayerDialog(playerid, 104, DIALOG_STYLE_MSGBOX, "Treat Wounds", string, "Yes", "No");
    }
    else SendClientMessage(playerid,COLOR_GREY,"You are not around the hospital table.");
    return 1;
}
//============================================//
COMMAND:treatplayer(playerid, params[])
{
	new targetid,string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "u", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /treatplayer [playerid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
	    if(IsPlayerNPC(targetid)) return SendClientMessage(playerid, COLOR_GREY, "Can't do this to a NPC.");
		if(GetPVarInt(targetid,"Wound_T") == 0 && GetPVarInt(targetid,"Wound_A") == 0 && GetPVarInt(targetid,"Wound_L") == 0) return SendClientMessage(playerid,COLOR_GREY,"This player doesn't have any wounds.");
		if(GetPVarInt(playerid, "Member") == 2 && GetPVarInt(playerid, "Rank") > 1 || GetPVarInt(playerid, "Admin") >= 1)
		{
		    if(PlayerToPlayer(playerid,targetid,3.0))
		    {
   			    format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
	    	    format(giveplayer, sizeof(giveplayer), "%s", PlayerNameEx(targetid));
      		    GiveNameSpace(sendername);
        	    GiveNameSpace(giveplayer);
                format(string, sizeof(string), "*** %s treats %s's wound.", sendername, giveplayer);
    	        ProxDetector(30.0, playerid, string, COLOR_PURPLE);
                SetPVarInt(targetid, "Wound_T", 0);
    	        SetPVarInt(targetid, "Wound_A", 0);
    	        SetPVarInt(targetid, "Wound_L", 0);
    	        PlayerWound(targetid, 0, 0);
    	    }
    	    else SendClientMessage(playerid,COLOR_GREY,"You are not close enough to that player!");
		}
	}
	return 1;
}
//============================================//
COMMAND:revive(playerid, params[])
{
	if(GetPVarInt(playerid, "Admin") >= 1 || (GetPVarInt(playerid, "Member") == 2 && GetPVarInt(playerid, "Rank") > 1))
	{
		new targetid,string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
		if(sscanf(params, "u", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /revive [playerid]");
		else
		{
		    if(targetid == playerid && GetPVarInt(playerid, "Admin") < 1) return error(playerid, "Cannot revive yourself.");
		    if (GetPVarInt(targetid, "Dead") == 0) return SendClientMessage(playerid, COLOR_WHITE, "This player is not dead yet.");
	 		if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
 			if(PlayerToPlayer(playerid,targetid,5.0) || targetid == playerid)
    		{
				format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
			    format(giveplayer, sizeof(giveplayer), "%s", PlayerNameEx(targetid));
		   		GiveNameSpace(sendername);
				GiveNameSpace(giveplayer);
			    format(string, sizeof(string), "*** %s uses %s defibrillator on %s.", sendername, CheckSex(playerid), giveplayer);
				ProxDetector(30.0, playerid, string, COLOR_PURPLE);
		  		SetPVarInt(targetid, "Dead", 0);
		  		SetPVarInt(targetid, "Mute", 0);
				TogglePlayerControllableEx(targetid,true);
				SetPlayerHealth(targetid,10.0);
				PlayerWound(targetid, 0, 0);
				ResetPlayerWeaponsEx(targetid);
				if(GetPVarInt(targetid, "Member") == 1 && GetPVarInt(targetid, "Duty") == 1)
        		{
            		format(string, sizeof(string),"%s", PlayerNameEx(targetid));
            		SetPlayerColor(targetid, 0x8080FFFF);
		    		if(GetPVarInt(targetid, "MaskUse") == 1) Update3DTextLabelText(PlayerTag[targetid], 0x8080FFFF, string);
				}
        		if(GetPVarInt(targetid, "Member") == 2 && GetPVarInt(targetid, "Duty") == 1)
        		{
            		format(string, sizeof(string),"%s", PlayerNameEx(targetid));
            		SetPlayerColor(targetid, COLOR_PINK);
		    		if(GetPVarInt(targetid, "MaskUse") == 1) Update3DTextLabelText(PlayerTag[targetid], COLOR_PINK, string);
				}
			}
		}
	}
	else nal(playerid);
	return 1;
}
//============================================//
ALTCOMMAND:savedata->saveaccounts;
COMMAND:saveaccounts(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Admin") >= 7)
    {
        foreach(new i : Player) {
            OnPlayerDataSave(i);
        }
        
       	SaveHouses();
       	SaveBizes();
   	    foreach(new i : Vehicle) {
   	        if(VehicleInfo[i][vID] != 0) {
				SaveVehicleData(i);
		    }
		}
    }
    else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
    return 1;
}
//============================================//
COMMAND:gametext(playerid, params[])
{
	new string[128], style;
	if(sscanf(params, "s[128]i", string, style)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /gametext [string] [style]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if(GetPVarInt(playerid, "Admin") >= 7) GameTextForPlayer(playerid,string,5000,style);
		else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
COMMAND:factionon(playerid, params[])
{
	new amount,string[128];
	if(sscanf(params, "i", amount)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /factionon [factionid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(amount < 1 || amount > MAX_FACTIONS) return SendClientMessage(playerid, COLOR_GREY, "Cannot go under 1 or above 50.");
		new online = 0;
		foreach(new i : Player)
		{
		    if(GetPVarInt(i, "Member") == amount)
		    {
				if(GetPVarInt(i, "PlayerLogged") == 1)
				{
				    online++;
			    }
		    }
	    }
		if(FactionInfo[amount][fUsed] == 0) return SCM(playerid, COLOR_LIGHTRED, "Invalid faction-ID!");
		format(string, sizeof(string), "(( There is %d members of the %s online ))",online, FactionInfo[amount][fName]);
		SendClientMessage(playerid, 0x8080FF96, string);
	}
	return 1;
}
//============================================//
COMMAND:rank(playerid, params[])
{
	new targetid,rank,string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "ui", targetid, rank)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /rank [playerid] [rank]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (GetPVarInt(playerid, "Member") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be in a faction to use this.");
		if(rank < 1 || rank > GetPVarInt(playerid, "Rank")-1)
		{
			format(string, 128, "Cannot go under 1 or above %d.", GetPVarInt(playerid, "Rank")-1);
			SendClientMessage(playerid, COLOR_GREY, string);
			return true;
		}
	    if (GetPVarInt(targetid, "Member") != GetPVarInt(playerid, "Member")) return SendClientMessage(playerid, COLOR_WHITE, "That player is not in the same faction as yours.");
	    new maxrank = MaxRank(GetPVarInt(playerid, "Member"));
		if(GetPVarInt(playerid, "Rank") >= maxrank || (GetPVarInt(playerid, "Member") == 1 && GetPVarInt(playerid, "Rank") >= 10) || (GetPVarInt(playerid, "Member") == 2 && GetPVarInt(playerid, "Rank") >= 10)) {
   		    format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
	    	format(giveplayer, sizeof(giveplayer), "%s", PlayerName(targetid));
      		GiveNameSpace(sendername);
        	GiveNameSpace(giveplayer);
        	new pdtxt[50];
        	if(rank > GetPVarInt(targetid, "Rank")) pdtxt="promoted";
        	if(rank < GetPVarInt(targetid, "Rank")) pdtxt="demoted";
        	SetPVarInt(targetid, "Rank", rank);
        	format(string, sizeof(string), "You have been %s by leader %s.", pdtxt, sendername);
           	SendClientMessage(targetid,COLOR_GREY,string);
            format(string, sizeof(string), "You have %s %s.", pdtxt, giveplayer);
            SendClientMessage(playerid,COLOR_GREY,string);
		}
	}
	return 1;
}
//============================================//
COMMAND:makeleader(playerid, params[])
{
	if(GetPVarInt(playerid, "Admin") < 9) return nal(playerid);
	new id, fac, str[128];
	if(sscanf(params, "ud", id, fac)) return usage(playerid, "/makeleader [Player] [Faction-ID]");
	if(fac < 1 || fac > MAX_FACTIONS) return SendClientMessage(playerid, COLOR_GREY, "Cannot go under 1 or above 50.");
	if(FactionInfo[fac][fUsed] == 0) return SCM(playerid, COLOR_LIGHTRED, "Invalid faction-ID!");
	SetPVarInt(id, "Member", fac);
	SetPVarInt(id, "Rank", MaxRank(fac));
	format(str, sizeof(str), "You have made (%s) the leader of faction #%d.", PlayerName(id), fac);
	SCM(playerid, -1, str);
	OnPlayerDataSave(id);
	return 1;
}
//============================================//
COMMAND:rights(playerid, params[])
{
	new targetid,rank,string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "ui", targetid, rank)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /rights [playerid] [0/1]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (GetPVarInt(playerid, "Member") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be in a faction to use this.");
		if(rank < 0 || rank > 1) return SendClientMessage(playerid, COLOR_GREY, "Cannot go under 0 or above 1.");
	    if (GetPVarInt(targetid, "Member") != GetPVarInt(playerid, "Member")) return SendClientMessage(playerid, COLOR_WHITE, "That player is not in the same faction as yours.");
		if(GetPVarInt(playerid, "Rank") >= MaxRank(GetPVarInt(playerid, "Member")))
		{
   		    format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
	    	format(giveplayer, sizeof(giveplayer), "%s", PlayerName(targetid));
      		GiveNameSpace(sendername);
        	GiveNameSpace(giveplayer);
        	//new pdtxt[50];
        	SetPVarInt(targetid, "Frights", rank);
        	if(rank == 0) format(string, sizeof(string), "Factory rights taken from %s by leader %s.", giveplayer, sendername);
        	if(rank == 1) format(string, sizeof(string), "Factory rights given to %s by leader %s.", giveplayer, sendername);
           	SendClientMessage(targetid,COLOR_GREY,string);
            SendClientMessage(playerid,COLOR_GREY,string);
		}
		else
		{
			SendClientMessage(playerid,COLOR_LIGHTRED,"You are not the faction leader.");
		}
	}
	return 1;
}
//============================================//
COMMAND:shipment(playerid, params[])
{
	if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	if (GetPVarInt(playerid, "Member") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be in a faction to use this.");
	if(GetPVarInt(playerid, "Rank") >= MaxRank(GetPVarInt(playerid, "Member")) || GetPVarInt(playerid, "Frights") == 1)
	{
	    new member = GetPVarInt(playerid, "Member");
        if(IsInLS(playerid)) {
            SendClientMessage(playerid, COLOR_WHITE, "You must be outside of Los Santos to use this command!");
        } else {
            if (GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be outside to use this command!");
            if (GetPlayerVirtualWorld(playerid) != 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be outside to use this command!");
            if(FactionInfo[member][fRights] == 0) return SendClientMessage(playerid, COLOR_WHITE, "Your faction has no rights!");
            if(FactionInfo[member][fShipment] > 0) return SCM(playerid, COLOR_LIGHTRED, "Your faction is currently in a shipping process already!");
            new found = 0;
            for(new i = 0; i < sizeof(CrateInfo); i++)
            {
                if(CrateInfo[i][cUsed] == 0 && found == 0)
                {
                    found++;
                }
            }
            if(found == 0) {
                SCM(playerid, COLOR_LIGHTRED, "ERROR: There are no crates left, tell a developer!");
                return true;
            }
            PrintShipment(playerid);
        }
	}
	else SendClientMessage(playerid, COLOR_WHITE, "You do not have permission to this command!");
	return 1;
}
//============================================//
COMMAND:factionrank(playerid, params[])
{
	new amount[128], type, string[128];
	if(sscanf(params, "is[128]", type, amount)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /factionrank [Rank 1-25] [Rank Name]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(type < 1 || type > 25)
		{
			SendClientMessage(playerid, COLOR_GREY, "Cannot go under 1 or above 25.");
			return true;
		}
	    if(strlen(amount) >= 40) return SendClientMessage(playerid, COLOR_WHITE, "Faction rank is too long.");
		new member = GetPVarInt(playerid, "Member");
		new maxrank = MaxRank(member);
	    if(GetPVarInt(playerid, "Rank") >= maxrank)
	    {	
	        format(string, 128, "Faction rank %d set to %s", type, amount);
	        SendClientMessage(playerid, COLOR_WHITE, string);
			format(FactionRank[member][type], 128, "%s", amount);
	        SaveFaction(member);
			if(strlen(FactionRank[member][type]) < 2) {
				format(string, 128, "Faction rank %d removed.", type);
				SendClientMessage(playerid, COLOR_WHITE, string);
				if(type == maxrank) {
					SetPVarInt(playerid, "Rank", MaxRank(member));
					OnPlayerDataSave(playerid);
				}
			} else if(type > maxrank) {
				SendClientMessage(playerid, COLOR_WHITE, "NOTE: You've added a NEW rank to the faction! You can use '/factionrank [rank-number] 0' to remove it if you'd like.");
				SetPVarInt(playerid, "Rank", MaxRank(member));
				OnPlayerDataSave(playerid);
			}			
		}
	}
	return 1;
}
//============================================//
COMMAND:factionbonus(playerid, params[]) {
	new amount,
		type;
		
	if(sscanf(params, "ii", type, amount)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /factionbonus [Rank 1-25] [value]");
 	if(GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
  	if(GetPVarInt(playerid, "Member") == 1 || GetPVarInt(playerid, "Member") == 2 || GetPVarInt(playerid, "Member") == 4 || GetPVarInt(playerid, "Member") == 5 || GetPVarInt(playerid, "Member") == 8) {
   		if(type < 1 || type > 25) return SendClientMessage(playerid, COLOR_GREY, "Cannot go under 1 or above 25.");
		if(amount < 0 || amount > 1000) return SendClientMessage(playerid, COLOR_GREY, "Cannot go under 0 or above 1000.");
	    if(GetPVarInt(playerid, "Rank") >= MaxRank(GetPVarInt(playerid, "Member"))) {
	        new query[80];
	    	format(query, sizeof(query), "Bonus for rank %d has been set to $%i.", type, amount);
			SendClientMessage(playerid, COLOR_WHITE, query);
			FactionBonus[GetPVarInt(playerid, "Member")][type - 1] = amount;
			mysql_format(handlesql, query, sizeof(query), "UPDATE `factions` SET `Bonus_Rank%i` = %i WHERE `ID` = %i;", type, amount, GetPVarInt(playerid, "Member"));
			mysql_tquery(handlesql, query);
		}
	} else {
		SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	
	return 1;
}
//============================================//
COMMAND:invite(playerid, params[])
{
	new targetid,string[128];
	if(sscanf(params, "u", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /invite [playerid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (playerid == targetid) return SendClientMessage(playerid, COLOR_GREY, "You cannot invite yourself.");
	    if (GetPVarInt(playerid, "Member") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be in a faction to use this.");
	    if (GetPVarInt(targetid, "Member") != 0) return SendClientMessage(playerid, COLOR_WHITE, "That player is already in a faction.");
		if(IsPlayerConnected(targetid))
		{
		    if(GetPVarInt(playerid, "Rank") >= MaxRank(GetPVarInt(playerid, "Member")) || (GetPVarInt(playerid, "Member") == 1 &&  GetPVarInt(playerid, "Rank") >= 10) || (GetPVarInt(playerid, "Member") == 2 &&  GetPVarInt(playerid, "Rank") >= 10))
   			{
   			    format(string, sizeof(string),"You gave %s a faction invite.", PlayerName(targetid));
				SendClientMessage(playerid,COLOR_LIGHTRED,string);
				format(string, sizeof(string),"%s offered a faction invite (/accept invite).", PlayerName(playerid));
				SendClientMessage(targetid,COLOR_LIGHTRED,string);
				SetPVarInt(targetid, "InviteOffer", playerid);
   			}
		}
	}
	return 1;
}
//============================================//
COMMAND:auninvite(playerid, params[])
{
	new targetid,string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "u", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /uninvite playerid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (GetPVarInt(playerid, "Admin") == 0) return nal(playerid);
	    if (playerid == targetid) return SendClientMessage(playerid, COLOR_GREY, "You cannot invite yourself.");
		if(IsPlayerConnected(targetid))
		{
			format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
    	    format(giveplayer, sizeof(giveplayer), "%s", PlayerName(targetid));
  		    GiveNameSpace(sendername);
    	    GiveNameSpace(giveplayer);
    	    SetPVarInt(targetid, "Member", 0);
    	    SetPVarInt(targetid, "Rank", 0);
    	    SetPVarInt(targetid, "Duty", 0);
    	    format(string, sizeof(string), "You have been uninvited by leader %s.", sendername);
       		SendClientMessage(targetid,COLOR_GREY,string);
        	format(string, sizeof(string), "You have sent a uninvite to %s.", giveplayer);
        	SendClientMessage(playerid,COLOR_GREY,string);
		}
	}
	return 1;
}
//============================================//
COMMAND:uninvite(playerid, params[])
{
	new name[24], pname[24], string[128];
	if(sscanf(params, "s[25]", name)) return usage(playerid, "/uninvite [Firstname_Lastname]");
	if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
 	if (GetPVarInt(playerid, "Member") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be in a faction to use this.");
	mysql_escape_string(name, name);
	new count = 0, countid = 0;
	if(GetPVarInt(playerid, "Rank") >= MaxRank(GetPVarInt(playerid, "Member")) || (GetPVarInt(playerid, "Member") == 1 &&  GetPVarInt(playerid, "Rank") >= 10) || (GetPVarInt(playerid, "Member") == 2 &&  GetPVarInt(playerid, "Rank") >= 10))
	{
		foreach(new i : Player)
		{
		    GetPlayerName(i, pname, 24);
		    if(strcmp(name, pname, true) == 0) //Is found
		    {
		        count++;
		        countid = i;
		    }
		}
		if(count > 0) //Online
		{
		    SetPVarInt(countid, "Member", 0);
		    SetPVarInt(countid, "Rank", 0);
		    SetPVarInt(countid, "Duty", 0);
		    format(string, sizeof(string), "[INFO] You have uninvited %s", name);
		    scm(playerid, -1, string);
		    scm(countid, -1, "You have been univited from your faction by a leader.");
		}
		else //Offline
		{
			format(string, sizeof(string), "UPDATE accounts SET Member=0, Rank=0 WHERE Name='%s'",name);
            mysql_function_query(handlesql, string, false, "SendQuery", "");
		    format(string, sizeof(string), "[INFO] You have uninvited %s", name);
		    scm(playerid, -1, string);
		}
	}
	return 1;
	/*
	new targetid,string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "u", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /uninvite [playerid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (GetPVarInt(playerid, "Member") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be in a faction to use this.");
	    if (playerid == targetid) return SendClientMessage(playerid, COLOR_GREY, "You cannot invite yourself.");
		if(IsPlayerConnected(targetid))
		{
		    if(GetPVarInt(playerid, "Rank") >= MaxRank(GetPVarInt(playerid, "Member")) || (GetPVarInt(playerid, "Member") == 1 &&  GetPVarInt(playerid, "Rank") >= 10) || (GetPVarInt(playerid, "Member") == 2 &&  GetPVarInt(playerid, "Rank") >= 10))
   			{
   			    if (GetPVarInt(targetid, "Member") != GetPVarInt(playerid, "Member")) return SendClientMessage(playerid, COLOR_WHITE, "That player is not in the same faction as yours.");
				format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
	    	    format(giveplayer, sizeof(giveplayer), "%s", PlayerName(targetid));
      		    GiveNameSpace(sendername);
        	    GiveNameSpace(giveplayer);
        	    SetPVarInt(targetid, "Member", 0);
        	    SetPVarInt(targetid, "Rank", 0);
        	    SetPVarInt(targetid, "Duty", 0);
        	    format(string, sizeof(string), "You have been uninvited by leader %s.", sendername);
           		SendClientMessage(targetid,COLOR_GREY,string);
            	format(string, sizeof(string), "You have sent a uninvite to %s.", giveplayer);
            	SendClientMessage(playerid,COLOR_GREY,string);
   			}
		}
	}
	*/
}
//============================================//
COMMAND:factionname(playerid, params[])
{
	new amount[128],string[128];
	if(sscanf(params, "s[128]", amount)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /factionname [Faction Name]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(strlen(amount) > 48) return SendClientMessage(playerid, COLOR_WHITE, "Faction name is too long.");
	    if(GetPVarInt(playerid, "Rank") >= MaxRank(GetPVarInt(playerid, "Member")))
	    {
	        strmid(FactionInfo[GetPVarInt(playerid, "Member")][fName], amount, 0, strlen(amount), 255);
	        format(string, sizeof(string), "You have set your factions name to: %s.", amount);
		    SendClientMessage(playerid, COLOR_WHITE, string);
		    SaveFaction(GetPVarInt(playerid, "Member"));
		}
	}
	return 1;
}

//============================================//
COMMAND:setfaction(playerid, params[])
{
	new type[128],targetid,amount,string[224];
	if(sscanf(params, "is[128]i", targetid, type, amount)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /setfaction [Faction-ID] [rights/wepcount/drugcount] [amount]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if(GetPVarInt(playerid, "Admin") >= 9) {
			if(FactionInfo[targetid][fUsed] == 0) return SendClientMessage(playerid, COLOR_GREY, "This faction doesn't exist!");
		    if(strcmp(type, "rights", true) == 0) {
		        FactionInfo[targetid][fRights] = amount;
				format(string, sizeof(string),"You have set factionid: %d's %s to %d",targetid,type,amount);
				SendClientMessage(playerid, COLOR_GREY, string);
				SaveFaction(targetid);
		    } else if(strcmp(type, "wepcount", true) == 0) {
				FactionInfo[targetid][fWepCount] = amount;
				format(string, sizeof(string), "Faction '%s' weapon-count set to %d.", FactionInfo[targetid][fName], amount);
				SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
				format(string, sizeof(string), "%s can currently order %d more weapons.", FactionInfo[targetid][fName], (FACTION_WEAPON_LIMIT-FactionInfo[targetid][fWepCount]));
				SaveFactionShipment(targetid);
			} else if(strcmp(type, "drugcount", true) == 0) {
				FactionInfo[targetid][fDrugCount] = amount;
				format(string, sizeof(string), "Faction '%s' drug-count set to %d.", FactionInfo[targetid][fName], amount);
				SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
				format(string, sizeof(string), "%s can currently order %d more grams of any/all drugs.", FactionInfo[targetid][fName], (FACTION_DRUG_LIMIT-FactionInfo[targetid][fDrugCount]));
				SaveFactionShipment(targetid);
			}			
		} else { SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!"); }
	}
	return 1;
}
//============================================//
COMMAND:factionwarehouse(playerid, params[])
{
	if(GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	if(GetPVarInt(playerid, "Admin") < 12) return error(playerid, "This has been disabled.");
	if(GetPVarInt(playerid, "Rank") >= MaxRank(GetPVarInt(playerid, "Member")))
	{
		if(FactionInfo[GetPVarInt(playerid, "Member")][fRights] == 0) return SendClientMessage(playerid, COLOR_WHITE, "Your faction doesn't contain weapon/drug rights.");
		if(FactionInfo[GetPVarInt(playerid, "Member")][fFact][0] != 0.0) return SendClientMessage(playerid, COLOR_WHITE, "You already planted the warehouse entrance (lead administrators can change it).");
	    new Float:x,Float:y,Float:z;
		GetPlayerPos(playerid,x,y,z);
		FactionInfo[GetPVarInt(playerid, "Member")][fFact][0] = x;
		FactionInfo[GetPVarInt(playerid, "Member")][fFact][1] = y;
		FactionInfo[GetPVarInt(playerid, "Member")][fFact][2] = z;
		SaveFaction(GetPVarInt(playerid, "Member"));
		DestroyDynamicCP(FactionCP[GetPVarInt(playerid, "Member")]);
	    FactionCP[GetPVarInt(playerid, "Member")]=CreateDynamicCP(x, y, z, 1.5, 0, -1, -1, 10.0);
		SendClientMessage(playerid, COLOR_WHITE, "You have planted your Factions Warehouse entrance at this location.");
	}
	return 1;
}
//============================================//
ALTCOMMAND:motd->factionmotd;
COMMAND:factionmotd(playerid, params[])
{
	new type[128],string[128];
	if(sscanf(params, "s[128]", type)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /factionmotd [Message]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (GetPVarInt(playerid, "Member") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be in a faction to use this.");
        if(GetPVarInt(playerid, "Rank") >= MaxRank(GetPVarInt(playerid, "Member")))
        {
            strmid(FactionInfo[GetPVarInt(playerid, "Member")][fMOTD], type, 0, strlen(type), 255);
            format(string, sizeof(string),"New Faction MOTD: %s.",FactionInfo[GetPVarInt(playerid, "Member")][fMOTD]);
            SendFactionMessage(GetPVarInt(playerid, "Member"), COLOR_BLUE, string);
            SaveFaction(GetPVarInt(playerid, "Member"));
        }
	}
	return 1;
}
//============================================//
COMMAND:flist(playerid, params[])
{
	new string[128],sendername[MAX_PLAYER_NAME];
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if (GetPVarInt(playerid, "Member") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be in a faction to use this.");
	SendClientMessage(playerid, COLOR_WHITE, "Faction Members Online:");
    foreach(new i : Player)
	{
 		format(sendername, sizeof(sendername), "%s", PlayerName(i));
		GiveNameSpace(sendername);
	    if(GetPVarInt(i, "PlayerLogged") == 1 && GetPVarInt(i, "Member") == GetPVarInt(playerid, "Member"))
	    {
	        if(GetPVarInt(i, "Duty") == 1) { format(string, sizeof(string), "{32CD32}(On-Duty) %s, Rank: %d.", sendername, GetPVarInt(i, "Rank")); }
	        else { format(string, sizeof(string), "%s, Rank: %d.", sendername, GetPVarInt(i, "Rank")); }
      		SendClientMessage(playerid, COLOR_WHITE, string);
	    }
	}
	return 1;
}
//============================================//
COMMAND:quitfaction(playerid, params[])
{
	new string[128];
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if (GetPVarInt(playerid, "Member") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You don't have a faction to quit from.");
	if(IsACop(playerid)) {
		ResetPlayerWeaponsEx(playerid);
		ClearInvWeapons(playerid);
	}
	SendClientMessage(playerid,COLOR_WHITE,"You have left your faction.");
	format(string, sizeof(string), "%s has quit the faction.", PlayerName(playerid));
	SendFactionMessage(GetPVarInt(playerid, "Member"),COLOR_WHITE,string);
	SetPVarInt(playerid, "Member", 0);
	SetPVarInt(playerid, "Rank", 0);
 	SetPVarInt(playerid, "Member", 0);
   	SetPVarInt(playerid, "Duty", 0);
	return 1;
}
//============================================//
ALTCOMMAND:r->radio;
COMMAND:radio(playerid, params[])
{
	new text[128],string[255],sendername[MAX_PLAYER_NAME];
	if(sscanf(params, "s[128]", text)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /radio [text]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_LIGHTRED, "You are currently muted!");
		new member = GetPVarInt(playerid, "Member");
	    if(member == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be in a faction to use this.");
	    if(member != 1 && member != 2 && member) return error(playerid, "Your faction cannot use the radio.");
	    if(GetPVarInt(playerid, "Jailed") > 0) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-jail.");
	    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
   		format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
      	GiveNameSpace(sendername);
		format(string, sizeof(string), "** %s (radio): %s, over. **", sendername, text);
        SendFactionMessage(member, 0x8080FF96, string);
        ProxRadio(20.0, playerid, string, COLOR_FADE);
		if(member == 1 || member == 2) { SendScannerMessage(member, string); }
	}
	return 1;
}
//============================================//
ALTCOMMAND:d->departments;
COMMAND:departments(playerid, params[])
{
	new text[128],string[255],sendername[MAX_PLAYER_NAME];
	if(sscanf(params, "s[128]", text)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /departments [text]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_LIGHTRED, "You are currently muted!");
	    if (GetPVarInt(playerid, "Member") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be in a faction to use this.");
	    if(GetPVarInt(playerid, "Member") != 1 && GetPVarInt(playerid, "Member") != 2 && GetPVarInt(playerid, "Member") != 8) return error(playerid, "Your faction cannot use the radio.");
	    if(GetPVarInt(playerid, "Duty") != 1) return SendClientMessage(playerid, COLOR_WHITE, "You can not use the radio while not on duty.");
   		format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
      	GiveNameSpace(sendername);
		format(string, sizeof(string), "**  %s %s: %s  **",  FactionRank[GetPVarInt(playerid, "Member")][GetPVarInt(playerid, "Rank")], sendername, text);
      	SendFactionMessage(1, COLOR_PINK, string);
      	SendFactionMessage(2, COLOR_PINK, string);
      	SendFactionMessage(8, COLOR_PINK, string);
        format(string, sizeof(string), "** %s(radio): %s, over. **", sendername, text);
        ProxRadio(20.0, playerid, string, COLOR_FADE);
	}
	return 1;
}
//============================================//
COMMAND:closef(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if (GetPVarInt(playerid, "Member") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be in a faction to use this.");
    if(GetPVarInt(playerid, "Rank") >= MaxRank(GetPVarInt(playerid, "Member")))
	{
        switch(FactionInfo[GetPVarInt(playerid, "Member")][fDisabled])
        {
            case 0:
            {
                FactionInfo[GetPVarInt(playerid, "Member")][fDisabled]=1;
                SendFactionMessage(GetPVarInt(playerid, "Member"), COLOR_GREY, "Faction Chat is closed!");
            }
            case 1:
            {
                FactionInfo[GetPVarInt(playerid, "Member")][fDisabled]=0;
                SendFactionMessage(GetPVarInt(playerid, "Member"), COLOR_GREY, "Faction Chat is open!");
            }
        }
    }
	return 1;
}
//============================================//
COMMAND:f(playerid, params[])
{
	new text[128],string[255],sendername[MAX_PLAYER_NAME];
	if(sscanf(params, "s[128]", text)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /f [text]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_LIGHTRED, "You are currently muted!");
	    if (GetPVarInt(playerid, "Member") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be in a faction to use this.");
	    if(FactionInfo[GetPVarInt(playerid, "Member")][fDisabled] == 1) return SendClientMessage(playerid, COLOR_WHITE, "Faction Chat closed!");
	   	format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
	    GiveNameSpace(sendername);
        format(string, sizeof(string), "** (( %s %s: %s )) **", FactionRank[GetPVarInt(playerid, "Member")][GetPVarInt(playerid, "Rank")], sendername, text);
	    SendFactionMessage(GetPVarInt(playerid, "Member"),0x7BDDA5AA,string);
	}
	return 1;
}

COMMAND:togf(playerid, params[])
{
	if(GetPVarInt(playerid, "TogF") == 0) SetPVarInt(playerid, "TogF", 1);
	else SetPVarInt(playerid, "TogF", 0);
	SCM(playerid, -1, "Faction chat toggled.");
	return 1;
}
//============================================//
//HOUSE SYSTEM
//============================================//
COMMAND:knock(playerid, params[])
{
	new string[128],sendername[MAX_PLAYER_NAME];
	if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	if(GetPVarInt(playerid, "Delay") > GetCount()) return SendClientMessage(playerid, COLOR_LIGHTRED, "You must wait before performing this command!");
	format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
	GiveNameSpace(sendername);
	foreach(new h : HouseIterator) {
	    if(IsPlayerInRangeOfPoint(playerid,2.0, HouseInfo[h][hXo], HouseInfo[h][hYo], HouseInfo[h][hZo]))
	    {
	        format(string, sizeof(string), "*** %s knocks on the door.", sendername);
            ProxDetector(30.0, playerid, string, COLOR_PURPLE);
            SetPVarInt(playerid, "Delay", GetCount()+5000);
            format(string, sizeof(string), "*** Is knocking on the door (( %s ))", sendername);
            foreach(new p : Player) {
                if(IsPlayerInRangeOfPoint(p, 30.0, HouseInfo[h][hXi], HouseInfo[h][hYi], HouseInfo[h][hZi])) {
					if(GetPlayerVirtualWorld(p) == h) {
				        SendClientMessage(p, COLOR_PURPLE, string);
				    }
				}
		    }
			return 1;
	    }
	}
	if(PlayerInfo[playerid][pInVehicle] == -1) { //Not in vehicle interior.
		new car = PlayerToCar(playerid, 2, 8.0);
		new vInt = IsEnterableVehicle(car);
		if(car != INVALID_VEHICLE_ID && vInt != -1) {
			new Float:x, Float:y, Float:z;
			GetVehicleRelativePos(car, x, y, z, VehicleInteriorPos[vInt][vExitX], VehicleInteriorPos[vInt][vExitY], VehicleInteriorPos[vInt][vExitZ]);
			if(IsPlayerInRangeOfPoint(playerid, 2.0, x, y, z)) {
				format(string, sizeof(string), "*** %s knocks on the door.", sendername);
				ProxDetector(30.0, playerid, string, COLOR_PURPLE);
				SetPVarInt(playerid, "Delay", GetCount()+5000);
				format(string, sizeof(string), "*** Is knocking on the door (( %s ))", sendername);		
				foreach(new i : Player) {
					if(PlayerInfo[i][pInVehicle] == car) {
						SendClientMessage(i, COLOR_PURPLE, string);			
					}
				}
			}
		}
	}	
	return 1;
}
//============================================//
COMMAND:doorbell(playerid, params[])
{
	new string[128],sendername[MAX_PLAYER_NAME];
	if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	if(GetPVarInt(playerid, "Delay") > GetCount()) return SendClientMessage(playerid, COLOR_LIGHTRED, "You must wait before performing this command!");
	format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
	GiveNameSpace(sendername);
	foreach(new h : HouseIterator)
	{
	    if(IsPlayerInRangeOfPoint(playerid,2.0, HouseInfo[h][hXo], HouseInfo[h][hYo], HouseInfo[h][hZo]))
	    {
	        SetPVarInt(playerid, "Delay", GetCount()+5000);
	        format(string, sizeof(string), "*** %s rings the doorbell.", sendername);
            ProxDetector(30.0, playerid, string, COLOR_PURPLE);
            PlaySoundPlyRadius(playerid, 20801, 10.0);
            foreach(new p : Player)
			{
                if(IsPlayerInRangeOfPoint(p, 30.0, HouseInfo[h][hXi], HouseInfo[h][hYi], HouseInfo[h][hZi]))
                {
                    if(GetPlayerVirtualWorld(p) == h)
					{
				        SendClientMessage(p, COLOR_PURPLE, "*** The doorbell rings (( House ))");
				        PlayerPlaySound(playerid, 20801, 0, 0, 0);
				    }
				}
		    }
	    }
	}
	return 1;
}
//============================================//
ALTCOMMAND:housetypes->houses;
COMMAND:houses(playerid, params[])
{
	if(GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	if(GetPVarInt(playerid, "Admin") < 9) return nal(playerid);
	new msg[128];
	SCM(playerid, -1, "_________________________________________________________________");
	for(new i=0; i < sizeof(HouseCor); i++)
	{
	    format(msg, sizeof(msg), "ID (%d) - Name (%s)", i, HouseCor[i][Housename]);
		SCM(playerid, -1, msg);
	}
	return 1;
}
//============================================//
COMMAND:createhouse(playerid, params[])
{
	if(GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	if(GetPVarInt(playerid, "Admin") < 9) return nal(playerid);
	new houseid, price, Float:X, Float:Y, Float:Z, UID, text[128];
	if(sscanf(params,"ii",houseid, price)) return usage(playerid, "/createhouse [Class][Value] - (Classes go 1,2,3,4 (small, medium, big,mansion))");
	if(houseid < 1 || houseid > 4) return error(playerid, "Invalid house ID.");
	for(new i=1; i< MAX_HOUSES; i++) {
		if(HouseInfo[i][hID] == 0) {
		    UID = i;
			format(text, sizeof(text), "House id is %d", UID);
			SendClientMessage(playerid, -1, text);
			break;
		}
	}
	for(new i = 0; i < sizeof(HouseCor); i++) {
		if(HouseCor[i][Class] == houseid) {
			HouseInfo[UID][hXi] = HouseCor[i][mbX];
			HouseInfo[UID][hYi] = HouseCor[i][mbY];
			HouseInfo[UID][hZi] = HouseCor[i][mbZ];
			HouseInfo[UID][hIntIn] = HouseCor[i][Houseint];
			break;
		}
	}
	HouseInfo[UID][hID] = UID;
	HouseInfo[UID][hBuyValue] = price;
	HouseInfo[UID][hValue] = 50;
	HouseInfo[UID][hIntOut] = GetPlayerInterior(playerid);
	HouseInfo[UID][hVwOut] = GetPlayerVirtualWorld(playerid);
	GetPlayerPos(playerid, X, Y, Z);
	HouseInfo[UID][hXo] = X;
	HouseInfo[UID][hYo] = Y;
	HouseInfo[UID][hZo] = Z;
	new query[516], owner[25];
	format(owner, sizeof(owner), "None");
	mysql_format(handlesql, query, sizeof(query),"INSERT INTO `houses`(`ID`, `Xo`, `Yo`, `Zo`, `Xi`, `Yi`, `Zi`, `IntOut`, `IntIn`, `VwOut`, `Owner`, `BuyValue`, `Value`) VALUES (%d, %f, %f, %f, %f, %f, %f, %d, %d, %d, '%s', %d, %d)",
 	UID, X, Y, Z, HouseInfo[UID][hXi], HouseInfo[UID][hYi], HouseInfo[UID][hZi], HouseInfo[UID][hIntOut], HouseInfo[UID][hIntIn], HouseInfo[UID][hVwOut],
	owner, price, 50);
	mysql_tquery(handlesql, query);
	printf("House %d created", UID);
	//HouseInfo[UID][hIcon]=CreateDynamicPickup(1273, 1, HouseInfo[UID][hXo], HouseInfo[UID][hYo], HouseInfo[UID][hZo],HouseInfo[UID][hVwOut],HouseInfo[UID][hVwOut] );
	HouseInfo[UID][hIcon] = CreateDynamicCP(HouseInfo[UID][hXo], HouseInfo[UID][hYo], HouseInfo[UID][hZo], 1.5, HouseInfo[UID][hVwOut], -1, -1, 10.0);

	Iter_Add(HouseIterator, UID);
	return 1;
}
//============================================//
COMMAND:houseentrance(playerid, params[])
{
	new houseid,string[128];
	if(sscanf(params, "i", houseid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /houseentrance [House-ID]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if(GetPVarInt(playerid, "Admin") >= 7)
		{
      		new Float:x,Float:y,Float:z;
			GetPlayerPos(playerid,x,y,z);
      		format(string, sizeof(string), "WARNING: Moved Property ID: %d's entrance to %f,%f,%f.", houseid, x, y, z);
      		SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
      		HouseInfo[houseid][hXo] = x;
			HouseInfo[houseid][hYo] = y;
			HouseInfo[houseid][hZo] = z;
			HouseInfo[houseid][hVwOut] = GetPlayerVirtualWorld(playerid);
			HouseInfo[houseid][hIntOut] = GetPlayerInterior(playerid);
			DestroyDynamicCP(HouseInfo[houseid][hIcon]);
			HouseInfo[houseid][hIcon] = CreateDynamicCP(HouseInfo[houseid][hXo], HouseInfo[houseid][hYo], HouseInfo[houseid][hZo], 1.5, HouseInfo[houseid][hVwOut], -1, -1, 10.0);
			new query[184];
			mysql_format(handlesql, query, 184, "UPDATE `houses` SET `Xo`=%f,`Yo`=%f,`Zo`=%f,`IntOut`=%d,`VwOut`=%d WHERE `ID`=%d", x, y, z, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid), houseid);
			mysql_tquery(handlesql, query);
		}
		else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
COMMAND:bizexit(playerid, params[])
{
	new houseid,string[128];
	if(sscanf(params, "i", houseid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /bizexit [Biz-ID]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if(GetPVarInt(playerid, "Admin") >= 7)
		{
      		new Float:x,Float:y,Float:z;
			GetPlayerPos(playerid,x,y,z);
      		format(string, sizeof(string), "WARNING: Moved Property ID: %d's exit to %f,%f,%f.", houseid, x, y, z);
      		SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
      		BizInfo[houseid][Xi] = x;
			BizInfo[houseid][Yi] = y;
			BizInfo[houseid][Zi] = z;
			BizInfo[houseid][IntIn] = GetPlayerInterior(playerid);
			DestroyDynamicPickup(BizInfo[houseid][bExit]);
			BizInfo[houseid][bExit] = CreateDynamicPickup(1318, 1, BizInfo[houseid][Xi], BizInfo[houseid][Yi], BizInfo[houseid][Zi], houseid, BizInfo[houseid][IntIn]);
			new query[184];
			mysql_format(handlesql, query, 184, "UPDATE `business` SET `Xi`=%f,`Yi`=%f,`Zi`=%f,`IntIn`=%d WHERE `ID`=%d", x, y, z, GetPlayerInterior(playerid), houseid);
			mysql_tquery(handlesql, query);
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
COMMAND:bizentrance(playerid, params[])
{
	new houseid,string[128];
	if(sscanf(params, "i", houseid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /bizentrance [Business-ID]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if(GetPVarInt(playerid, "Admin") >= 7)
		{
      		new Float:x,Float:y,Float:z;
			GetPlayerPos(playerid,x,y,z);
      		format(string, sizeof(string), "WARNING: Moved Property ID: %d's entrance to %f,%f,%f.", houseid, x, y, z);
      		SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
      		BizInfo[houseid][Xo] = x;
			BizInfo[houseid][Yo] = y;
			BizInfo[houseid][Zo] = z;
			DestroyDynamicPickup(BizInfo[houseid][Icon]);
			BizInfo[houseid][Icon] = CreateDynamicPickup(1272, 1, BizInfo[houseid][Xo], BizInfo[houseid][Yo], BizInfo[houseid][Zo]);
			new query[184];
			mysql_format(handlesql, query, 184, "UPDATE `business` SET `Xo`=%f, `Yo`=%f, `Zo`=%f WHERE `ID`=%d", x, y, z, houseid);
			mysql_tquery(handlesql, query);
		}
		else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
COMMAND:houseexit(playerid, params[])
{
	new houseid,string[128];
	if(sscanf(params, "i", houseid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /houseexit [House-ID]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if(GetPVarInt(playerid, "Admin") >= 7)
		{
      		new Float:x,Float:y,Float:z;
			GetPlayerPos(playerid,x,y,z);
      		format(string, sizeof(string), "WARNING: Moved Property ID: %d's exit to %f,%f,%f.", houseid, x, y, z);
      		SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
      		HouseInfo[houseid][hXi] = x;
			HouseInfo[houseid][hYi] = y;
			HouseInfo[houseid][hZi] = z;
			HouseInfo[houseid][hIntIn] = GetPlayerInterior(playerid);
			DestroyDynamicCP(HouseInfo[houseid][hExit]);
			HouseInfo[houseid][hExit] = CreateDynamicCP(HouseInfo[houseid][hXi], HouseInfo[houseid][hYi], HouseInfo[houseid][hZi], 1.5, houseid, HouseInfo[houseid][hIntIn], -1, 10.0);
			new query[184];
			mysql_format(handlesql, query, 184, "UPDATE `houses` SET `Xi`=%f,`Yi`=%f,`Zi`=%f,`IntIn`=%d WHERE `ID`=%d", x, y, z, GetPlayerInterior(playerid), houseid);
			mysql_tquery(handlesql, query);
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
CMD:hpos(playerid, params[])
{
	new inte, Float:x, Float:y, Float:z, text[128];
	if(!sscanf(params, "s[64]", text))
	{
	    GetPlayerPos(playerid, x, y, z);
		inte = GetPlayerInterior(playerid);
	    printf(" HouseInfo[ID][hXi] = %f", x);
	    printf(" HouseInfo[ID][hYi] = %f", y);
	    printf(" HouseInfo[ID][hZi] = %f", z);
	    printf(" HouseInfo[ID][hhIntInXi] = %d", inte);
	    printf(" //%s", text);
	    scm(playerid, -1, "house saved in logs");
	    return 1;
	}
	else return usage(playerid, "/hpos [comment");
}
//============================================//
COMMAND:gotoprop(playerid, params[])
{
	new id;
	if(sscanf(params, "i", id)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /gotoprop [Property-ID]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if(GetPVarInt(playerid, "Admin") >= 7)
		{
		    SetPlayerPosEx(playerid,HouseInfo[id][hXo], HouseInfo[id][hYo], HouseInfo[id][hZo]);
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}

COMMAND:gotobizz(playerid, params[])
{
	new id;
	if(sscanf(params, "i", id)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /gotobizz [Business-ID]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if(GetPVarInt(playerid, "Admin") >= 7)
		{
		    SetPlayerPosEx(playerid,BizInfo[id][Xo], BizInfo[id][Yo], BizInfo[id][Zo]);
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
COMMAND:bizzowner(playerid, params[])
{
	new id, id2[25];
	if(sscanf(params, "is[25]", id, id2)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /bizzowner [Bizz-ID] [Firstname_Lastname]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if(GetPVarInt(playerid, "Admin") >= 7) {
			format(BizInfo[id][Owner], 25, "%s", id2);
			SaveBiz(id);
		} else {
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
COMMAND:houseowner(playerid, params[])
{
	new id, id2[128];
	if(sscanf(params, "is[128]", id, id2)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /houseowner [HOUSE-ID] [Firstname_Lastname]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if(GetPVarInt(playerid, "Admin") >= 7) {
			format(HouseInfo[id][hOwner], 128, "%s", id2);
			SaveHouse(id);
		} else {
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
COMMAND:carowner(playerid, params[])
{
	new id,id2[128];
	if(sscanf(params, "is[128]", id, id2)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /carowner [CAR-ID] [Firstname_Lastname]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if(GetPVarInt(playerid, "Admin") >= 7) {
			foreach(new i : Vehicle) {
				if(VehicleInfo[i][vID] == id) {
					format(VehicleInfo[i][vOwner], MAX_PLAYER_NAME+1, "%s", id2);
				    SaveVehicleData(i, 1);
					break;
				}
			}
		} else {
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
COMMAND:editbizz(playerid, params[])
{
	new type[128],amount,string[128];
	if(sscanf(params, "s[128]i", type, amount)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /editbizz [price/fee/lock/bank] [amount]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if(GetPVarInt(playerid, "Admin") >= 9) {
		    foreach(new h : BizIterator)
	        {
	            if(IsPlayerInRangeOfPoint(playerid,2.0,BizInfo[h][Xo], BizInfo[h][Yo], BizInfo[h][Zo]))
	            {
			        if(strcmp(type, "price", true) == 0)
		            {
		                BizInfo[h][Value] = amount;
			            format(string, sizeof(string), "Edited BIZZID: %d's %s to %d.", h, type, amount);
			            SendClientMessage(playerid,COLOR_GREY,string);
			            SaveBiz(h);
			        }
			        else if(strcmp(type, "fee", true) == 0)
		            {
		                BizInfo[h][EnterPrice] = amount;
			            format(string, sizeof(string), "Edited BIZZID: %d's %s to %d.", h, type, amount);
			            SendClientMessage(playerid,COLOR_GREY,string);
			            SaveBiz(h);
			        }
			        else if(strcmp(type, "lock", true) == 0)
		            {
		                BizInfo[h][Locked] = amount;
			            format(string, sizeof(string), "Edited BIZZID: %d's %s to %d.", h, type, amount);
			            SendClientMessage(playerid,COLOR_GREY,string);
			            SaveBiz(h);
			        }
			        else if(strcmp(type, "Bank", true) == 0)
		            {
		                BizInfo[h][Bank] = amount;
			            format(string, sizeof(string), "Edited BIZZID: %d's %s to %d.", h, type, amount);
			            SendClientMessage(playerid,COLOR_GREY,string);
			            SaveBiz(h);
			        }
			        else
			        {
			            format(string, sizeof(string), "BIZZID: %d.", h);
			            SendClientMessage(playerid,COLOR_GREY,string);
			        }
			    }
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
COMMAND:edithouse(playerid, params[])
{
	new type[128],amount,string[128];
	if(sscanf(params, "s[128]i", type, amount)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /edithouse [price/lock/delete/class] [amount]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if(GetPVarInt(playerid, "Admin") >= 7)
		{
		    foreach(new h : HouseIterator)
	        {
	            if(IsPlayerInRangeOfPoint(playerid,2.0,HouseInfo[h][hXo], HouseInfo[h][hYo], HouseInfo[h][hZo]) && GetPlayerVirtualWorld(playerid) == HouseInfo[h][hVwOut] && GetPlayerInterior(playerid) == HouseInfo[h][hIntOut])
	            {
			        if(strcmp(type, "price", true) == 0)
		            {
		                HouseInfo[h][hBuyValue] = amount;
			            format(string, sizeof(string), "Edited HouseID: %d's %s to %d.", h, type, amount);
			            SendClientMessage(playerid,COLOR_GREY,string);
						SaveHouse(h);
			        }
			        else if(strcmp(type, "lock", true) == 0)
		            {
		                HouseInfo[h][hLocked] = amount;
			            format(string, sizeof(string), "Edited HouseID: %d's %s to %d.", h, type, amount);
			            SendClientMessage(playerid,COLOR_GREY,string);
						SaveHouse(h);
			        }
			        else if(strcmp(type, "delete", true) == 0)
		            {
		                DestroyDynamicPickup(HouseInfo[h][hIcon]);
		                HouseInfo[h][hXo] = 999;
		                HouseInfo[h][hYo] = 999;
		                HouseInfo[h][hZo] = 999;
			            format(string, sizeof(string), "Deleted HouseID: %d'", h);
			            SendClientMessage(playerid,COLOR_GREY,string);
						SaveHouse(h);
			        }
			        else if(strcmp(type, "class", true) == 0)
		            {
		                if(amount < 1 || amount > 5) return error(playerid, "Invalid class. 1 - small 2 - medium 3 - big 4 - mansion 5 - apartment");
		                HouseInfo[h][hClass] = amount;
			            format(string, sizeof(string), "Changed class of HouseID: %d to '%d'", h,amount);
			            SendClientMessage(playerid,COLOR_GREY,string);
			            SaveHouse(h);
			        }
			        else
			        {
			            format(string, sizeof(string), "HouseID: %d.", h);
			            SendClientMessage(playerid,COLOR_GREY,string);
			        }
			    }
			}
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
COMMAND:house(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") != 1) return true;
	new string[128], param[64], amount, amount2;
	if(sscanf(params, "s[64]I(-1)I(-1)", param, amount, amount2)) {
		scm(playerid, COLOR_GREEN, "/house [usage]");
		scm(playerid, COLOR_GREY, "  lock | sell | unrent | inventory | radio | sellto |");
		scm(playerid, COLOR_GREY, "  breakin | plant | edit | select | removeall | interior | setexit |");
		scm(playerid, COLOR_GREY, "  rights | plantsafe | lookout | bank | deposit | withdraw | backdoor |");
		scm(playerid, COLOR_GREY, "  rentfee | rentto | (/evict) | rentlist | furn | putmats | takemats");
		scm(playerid, COLOR_GREY, "  Safe control: /safe");
		return 1;
	}
  	if(strcmp(param, "lock", true) == 0)
  	{
		new id = GetPVarInt(playerid, "HouseKey");
		if(!IsPlayerInRangeOfPoint(playerid, 2.0, HouseInfo[id][hXo], HouseInfo[id][hYo], HouseInfo[id][hZo]) && 
			!IsPlayerInRangeOfPoint(playerid, 5.0, HouseInfo[id][hXi], HouseInfo[id][hYi], HouseInfo[id][hZi]) && 
			!IsPlayerInRangeOfPoint(playerid, 2.0, HouseInfo[id][hgXo], HouseInfo[id][hgYo], HouseInfo[id][hgZo]) &&
			!IsPlayerInRangeOfPoint(playerid, 5.0, HouseInfo[id][hgXi], HouseInfo[id][hgYi], HouseInfo[id][hgZi]) &&
			!IsPlayerInRangeOfPoint(playerid, 5.0, HouseInfo[id][hbdXi], HouseInfo[id][hbdYi], HouseInfo[id][hbdZi]) &&
			!IsPlayerInRangeOfPoint(playerid, 2.0, HouseInfo[id][hbdXo], HouseInfo[id][hbdYo], HouseInfo[id][hbdZo])) return error(playerid, "You are not near your house door.");
		if(HouseInfo[id][hLocked] == 1) //Locked
		{
			PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
	 		GameTextForPlayer(playerid, "~w~House~n~~g~Unlocked", 4000, 3);
	 		HouseInfo[id][hLocked] = 0;
		}
		else //Unlocked
		{
			PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
	  		GameTextForPlayer(playerid, "~w~House~n~~r~Locked", 4000, 3);
	  		HouseInfo[id][hLocked] = 1;
		}
		SaveHouse(id);
		return 1;
	}
	else if(strcmp(param, "sell", true) == 0)
  	{
		new id = GetPVarInt(playerid, "HouseKey");
		if(GetPVarInt(playerid, "HouseKey") == 0) return error(playerid, "You do not own a property.");
		if(!strmatch(HouseInfo[id][hOwner], PlayerName(playerid))) return error(playerid, "You only rent this property.");
		if(!IsPlayerInRangeOfPoint(playerid, 2.0, HouseInfo[id][hXo], HouseInfo[id][hYo], HouseInfo[id][hZo])) return error(playerid, "You are not near your house door.");
		format(string, sizeof(string), "Are you sure you want to sell your house?\n{33FF66}Value: {FFFFFF}$%d", floatround(HouseInfo[id][hBuyValue]*0.8));
		ShowPlayerDialog(playerid, 523, DIALOG_STYLE_MSGBOX, "Are you sure?", string, "Yes", "No");		
		return 1;
	}
	else if(strcmp(param, "rentto", true) == 0)
    {
        if(GetPVarInt(playerid, "HouseKey") == 0) return SendClientMessage(playerid, COLOR_GREY, "You don't own a house.");
	    new key = GetPVarInt(playerid, "HouseKey");
	    if(strmatch(HouseInfo[key][hOwner], PlayerName(playerid)))
	    {
	        if(amount == (-1)) return SendClientMessage(playerid, COLOR_GREEN, "USAGE: /house rentto {FFFFFF}[playerid]");
	        if (!IsPlayerConnected(amount)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
	        if(PlayerToPlayer(playerid,amount,5.0))
	        {
			    if(GetPVarInt(amount, "HouseKey") != 0) return SendClientMessage(playerid, COLOR_GREY, "This player currently owns or rents a property.");
	            format(string, sizeof(string),"You offered %s to rent at your property.", PlayerName(amount));
				SendClientMessage(playerid,COLOR_LIGHTRED,string);
				format(string, sizeof(string),"%s offered you to rent at his property for a cost of $%d per-payday. (/accept rentoffer).", PlayerName(playerid), HouseInfo[key][hValue]);
				SendClientMessage(amount,COLOR_LIGHTRED,string);
				SetPVarInt(amount, "RentOffer", playerid);
	        }
	        else SendClientMessage(playerid,COLOR_GREY,"You are not close enough to that player!");
	    }
	    else scm(playerid, -1, "Insufficient permission!");
    }
	else if(strcmp(param, "rentfee", true) == 0)
    {
        if(GetPVarInt(playerid, "ConnectTime") < 8) return SendClientMessage(playerid, COLOR_GREY, "You need 8 hours played to use this command.");
        if(GetPVarInt(playerid, "HouseKey") == 0) return SendClientMessage(playerid, COLOR_GREY, "You don't own a house.");
	    new key = GetPVarInt(playerid, "HouseKey");
	    if(strmatch(HouseInfo[key][hOwner], PlayerName(playerid)))
	    {
	        if(amount == (-1)) return SendClientMessage(playerid, COLOR_GREEN, "USAGE: /house rentfee {FFFFFF}[amount]");
	        if(amount < 0 || amount > 250)
	        {
				SendClientMessage(playerid, COLOR_GREY, "Cannot go under 0 or above 250.");
				return true;
			}
			HouseInfo[key][hValue]=amount;
			format(string, 128, "Rent fee set to $%d.", amount);
			scm(playerid, COLOR_LIGHTBLUE, string);
			SaveHouse(key);
	    }
	    else scm(playerid, -1, "Insufficient permission!");
    }
    else if(strcmp(param, "unrent", true) == 0)
  	{
		new id = GetPVarInt(playerid, "HouseKey");
		if(GetPVarInt(playerid, "HouseKey") == 0) return error(playerid, "You do not rent at a property.");
		if(!IsPlayerInRangeOfPoint(playerid, 2.0, HouseInfo[id][hXo], HouseInfo[id][hYo], HouseInfo[id][hZo])) return error(playerid, "You are not near your house door.");
		if(strmatch(HouseInfo[id][hOwner], PlayerName(playerid)))
		{
		    scm(playerid, -1, "You own this house, use /house sell to sell it for 1/4 the buy-value.");
	    }
	    else
	    {
	        scm(playerid, -1, "You no longer rent at this property.");
	        SetPVarInt(playerid, "HouseKey", 0);
			OnPlayerDataSave(playerid);
	    }
		return 1;
	}
	else if(strcmp(param, "rentlist", true) == 0)
    {
        if(GetPVarInt(playerid, "HouseKey") == 0) return SendClientMessage(playerid, COLOR_GREY, "You don't own a house.");
        if(GetPVarInt(playerid, "Delay") > GetCount()) return 1; // Delay to avoid MySQL overload.
	    new key = GetPVarInt(playerid, "HouseKey");
	    if(strmatch(HouseInfo[key][hOwner], PlayerName(playerid)))
	    {
	        mysql_tquery(handlesql, "SELECT `HouseKey`, `Name` FROM `accounts`;", "RentListSQL", "ii", playerid, GetPVarInt(playerid, "HouseKey"));
	        SetPVarInt(playerid, "Delay", GetCount()+5000);
	    }
	    else scm(playerid, -1, "Insufficient permission!");
    }
  	else if(strcmp(param, "inventory", true) == 0)
  	{
		new id = GetPVarInt(playerid, "HouseEnter");
		if(!GetCloseHouseSafe(playerid, id)) return error(playerid, "You are not near a house-safe. (/house plantsafe)");
		if(HouseInfo[id][sLocked] == 1) return error(playerid, "This house's safe(s) are locked! (/safe unlock)");
		PrintHouseInv(playerid);
		return 1;
	}
	else if(strcmp(param, "radio", true) == 0)
   	{
   	    if(GetPVarInt(playerid, "HouseKey") == 0) return error(playerid, "You do not own a property.");
   	    if (GetPVarInt(playerid, "HouseEnter") == GetPVarInt(playerid, "HouseKey"))
   	    {
   	        ShowPlayerDialog(playerid,68,DIALOG_STYLE_LIST,"House Radio","Radio Stations\nDirect URL\nTurn Off","Select", "Exit");
   	    }
   	    else SendClientMessage(playerid,COLOR_GREY,"You are not inside your house.");
   	}
   	else if(strcmp(param, "sellto", true) == 0)
    {
        if(GetPVarInt(playerid, "ConnectTime") < 8) return SendClientMessage(playerid, COLOR_GREY, "You need 8 hours played to use this command.");
        if(GetPVarInt(playerid, "HouseKey") == 0) return SendClientMessage(playerid, COLOR_GREY, "You don't own a house.");
	    new key = GetPVarInt(playerid, "HouseKey");
	    if(strmatch(HouseInfo[key][hOwner], PlayerName(playerid)))
	    {
	        if(HouseInfo[key][hBuyValue] <= 9999) return SendClientMessage(playerid, COLOR_GREY, "You can't sell a donate house.");
	        if(amount == (-1)) return SendClientMessage(playerid, COLOR_GREEN, "USAGE: /house sellto {FFFFFF}[playerid] [amount]");
	        if(amount2 == (-1)) return SendClientMessage(playerid, COLOR_GREEN, "USAGE: /house sellto {FFFFFF}[playerid] [amount]");
	        new val = HouseInfo[key][hValue]-10000;
	        if(amount2 < val || amount2 > 500000)
	        {
	            format(string, sizeof(string),"Cannot go under %d or above 500000.", val);
				SendClientMessage(playerid, COLOR_GREY, string);
				return true;
			}
	        if (!IsPlayerConnected(amount)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
	        if(PlayerToPlayer(playerid,amount,5.0))
	        {
			    if(GetPVarInt(amount, "HouseKey") != 0) SendClientMessage(playerid, COLOR_GREY, "This player is currently owns or rents at a house.");
	            format(string, sizeof(string),"You offered %s to purchase your house for $%d.", PlayerName(amount), amount2);
				SendClientMessage(playerid,COLOR_LIGHTRED,string);
				format(string, sizeof(string),"%s offered you to purchase his house for $%d (/accept hsellto).", PlayerName(playerid), amount2);
				SendClientMessage(amount,COLOR_LIGHTRED,string);
				SetPVarInt(amount, "HouseOffer", playerid);
				SetPVarInt(amount, "HouseOfferPrice", amount2);
	        }
	        else SendClientMessage(playerid,COLOR_GREY,"You are not close enough to that player!");
	    }
    }
    else if(strcmp(param, "breakin", true) == 0)
	{
	    for(new h = 0; h < sizeof(HouseInfo); h++)
	    {
	        if(IsPlayerInRangeOfPoint(playerid,2.0, HouseInfo[h][hXo], HouseInfo[h][hYo], HouseInfo[h][hZo]))
	        {
	            if(HouseInfo[h][hOwned] == 0) return SendClientMessage(playerid,COLOR_WHITE,"This house isn't owned.");
			    if(HouseInfo[h][hLocked] == 0) return SendClientMessage(playerid,COLOR_WHITE,"This house isn't locked.");
			    if(!CheckInvItem(playerid, 406)) return SendClientMessage(playerid,COLOR_GREY,"You need a toolkit to use this.");
        	    SendClientMessage(playerid, 0xCCEEFF96, "You are now attempting to break into the house!");
                SetPVarInt(playerid, "RamHouse", 1);
        	    SetPVarInt(playerid, "RamHouseID", h);
        	    ProgressBar(playerid, "Ramming House...", 60, 1);
				AddPlayerTag(playerid, "(ramming house)");
	        }
	    }
	}
	else if(strcmp(param, "plant", true) == 0)
	{
		new allow = FurnRight(playerid, 1);
	    if(allow > 0) {
			if(GetPlayerInterior(playerid) == 0 && GetPlayerVirtualWorld(playerid) == 0) {
				if(outdoor_furn == 0) return SendClientMessage(playerid, COLOR_RED, "Outdoor furniture is currently disabled!");

		    	if(GetHouseOutdoorObjects(allow) >= HOUSE_OUTDOOR_OBJECTS) {
		    		SendClientMessage(playerid, COLOR_GREY, "You can only plant up to 20 objects outdoors.");
		    		return 1;
		    	}
		    }		
		    if(amount == (-1)) {
                ShowModelSelectionMenuEx(playerid, FurnObjs, sizeof(FurnObjs), "Furniture List", 2, 16.0, 0.0, -55.0);
            } else {
                if(amount < 320 || amount > 31000) return scm(playerid, -1, "Invalid Object ID!");
				if(GetPlayerInterior(playerid) == 0 && GetPlayerVirtualWorld(playerid) == 0 && IsInvalidObjectID(amount)) return scm(playerid, -1, "This is not a valid outdoor furniture object!");
                new foundid = -1;
                for(new i = 0; i < MAX_OBJECT_ARRAY; i++) {
					if(ObjectList[i][oID] == amount) {
						foundid=i;
						break;
					}
                }
                if(foundid == -1) return scm(playerid, -1, "Invalid Object ID!");
                new Float:X, Float:Y, Float:Z;
		        GetPlayerPos(playerid, X, Y, Z);
		        new obj = CreatePlayerObject(playerid, amount, X+1.0, Y+1.0, Z, 0.0, 0.0, 0.0, 100.0);
		        SetPVarInt(playerid, "FurnObject", obj);
		        SetPVarInt(playerid, "EditorMode", 1);
		        SetPVarInt(playerid, "Mute", 1);
		        PlayerInfo[playerid][pFurnID]=amount;
		        EditPlayerObject(playerid, obj);
		        format(string, sizeof(string),"%s selected, use the SPRINT key to navigate.", ObjectList[foundid][oName]);
		        SendClientMessage(playerid, COLOR_WHITE, string);
            }
         }
	}
	else if(strcmp(param, "edit", true) == 0)
	{
	    if(FurnRightEx(playerid, 1)) { GetCloseHouseObject(playerid, FurnRight(playerid, 1)); }
	}
	else if(strcmp(param, "removeall", true) == 0)
	{
	    if(FurnRightEx(playerid, 1)) {
			ShowPlayerDialog(playerid, DIALOG_HOUSE_REMOVEALL, DIALOG_STYLE_MSGBOX, "Remove all furniture objects", "Are you sure you want to remove all of your current house furniture objects?", "Yes", "No");
		} else SendClientMessage(playerid, COLOR_GREY, "You don't have permission to furnish this house.");
	}
    else if(strcmp(param, "rights", true) == 0)
    {
        if(GetPVarInt(playerid, "HouseKey") == 0) return SendClientMessage(playerid, COLOR_GREY, "You don't own a house.");
	    new key = GetPVarInt(playerid, "HouseKey");
	    if(strcmp(HouseInfo[key][hOwner], PlayerName(playerid), true) == 0)
	    {
	        if(amount == (-1)) {
			    SendClientMessage(playerid, COLOR_GREEN, "USAGE: /house rights {FFFFFF}[playerid]");
			    SendClientMessage(playerid, COLOR_GREEN, "If you select playerid as 501 the furn rights will disable.");
			    return 1;
			}
			if(amount == 501) {
				format(HouseInfo[key][hFurnR], 25, "None");
			    scm(playerid, -1, "Property furnishing rights disabled!");
			    return 1;
			}
	        if (!IsPlayerConnected(amount)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
	        if(amount == playerid) return scm(playerid, -1, "You can't give yourself furnish rights!");
	        if(PlayerToPlayer(playerid,amount,5.0))
	        {
	            format(string, 128, "You have given %s permission to furnish your property!", PlayerName(amount));
	            scm(playerid, -1, string);
	            format(string, 128, "%s has given you permission to furnish their property!", PlayerName(playerid));
	            scm(amount, -1, string);
				format(HouseInfo[key][hFurnR],25,"%s",PlayerName(amount));
	        }
	        else SendClientMessage(playerid,COLOR_GREY,"You are not close enough to that player!");
	    }
	    else scm(playerid, -1, "Insufficient permission!");
    }
	else if(strcmp(param, "interior", true) == 0)
	{
	    if(GetPVarInt(playerid, "HouseKey") == 0) return SendClientMessage(playerid, COLOR_GREY, "You don't own a house.");
	    new key = GetPVarInt(playerid, "HouseKey");
	    new Houseclass = HouseInfo[key][hClass];
        if(!IsPlayerInRangeOfPoint(playerid,10.0, HouseInfo[key][hXo], HouseInfo[key][hYo], HouseInfo[key][hZo])) return error(playerid, "You must be at your housedoor (outside) to do this.");
        if(strmatch(HouseInfo[key][hOwner], PlayerName(playerid)))
        {
            new diatxt[1024];
		    for(new i = 0; i < sizeof(HouseCor); i++)
		    {
		        if(HouseCor[i][Class] == Houseclass)
		        {
		            format(diatxt, sizeof(diatxt), "%s{FF3333}%s {CCCCCC}(Click to use)\n", diatxt, HouseCor[i][Housename]);
		        }
		    }
		    if(Houseclass != 0) ShowPlayerDialog(playerid, 410, DIALOG_STYLE_LIST, "Select interior", diatxt, "Select","Cancel");
		    else
		    {
		        scm(playerid, -1, "Please re-type the command!");
		        HouseInfo[key][hClass]=1;
		    }
		}
		else scm(playerid, -1, "Insufficient permission!");
	}
	else if(strcmp(param, "setexit", true) == 0)
	{
		new key = GetPVarInt(playerid, "HouseKey");
	    if(key == 0) return SendClientMessage(playerid, COLOR_GREY, "You don't own a house.");
		if(GetPlayerVirtualWorld(playerid) != key) return SendClientMessage(playerid, COLOR_GREY, "You have to be in your house to use this command!");
      	new Float:x,Float:y,Float:z;
		GetPlayerPos(playerid,x,y,z);
      	SendClientMessage(playerid, COLOR_LIGHTBLUE, "WARNING: You've moved your houses exit to your current position.");
      	HouseInfo[key][hXi] = x;
		HouseInfo[key][hYi] = y;
		HouseInfo[key][hZi] = z;
		HouseInfo[key][hIntIn] = GetPlayerInterior(playerid);
		SaveHouse(key);
		DestroyDynamicCP(HouseInfo[key][hExit]);
		HouseInfo[key][hExit] = CreateDynamicCP(HouseInfo[key][hXi], HouseInfo[key][hYi], HouseInfo[key][hZi], 1.5, key, HouseInfo[key][hIntIn], -1, 10.0);
	}
	else if(strcmp(param, "lookout", true) == 0)
	{
		new key = GetPVarInt(playerid, "HouseEnter");
		if(PlayerInfo[playerid][pPeeping] != 1) {
			if(!IsPlayerInRangeOfPoint(playerid, 5.0, HouseInfo[key][hXi], HouseInfo[key][hYi], HouseInfo[key][hZi])) return error(playerid, "You are not near the house door.");
			if(key == 0) return SendClientMessage(playerid, COLOR_GREY, "You aren't even in a house!");
		}
		switch(PlayerInfo[playerid][pPeeping]) {
			case 0:
			{
				TogglePlayerSpectatingEx(playerid, SPECTATE_MODE_FIXED);
				SetPlayerInterior(playerid, HouseInfo[key][hIntOut]);
				SetPlayerVirtualWorld(playerid, HouseInfo[key][hVwOut]);
				SetTimerEx("HandlePlayerPeeping", 250, false, "ii", playerid, key); // Wait to "peep" for real.
			}
			case 1:
			{
				TogglePlayerSpectatingEx(playerid, 0);
				SpawnPlayer(playerid);
				SetPVarInt(playerid, "HouseEnter", GetPVarInt(playerid, "LastHouse"));
				TempFreeze(playerid);
				SetPlayerHealth(playerid,GetPVarFloat(playerid, "Health"));
				GivePlayerWeaponEx(playerid, PlayerInfo[playerid][pPlayerWeapon],PlayerInfo[playerid][pPlayerAmmo]);
			}
		}
	}
	else if(strcmp(param, "plantsafe", true) == 0) 
	{
		new id = FurnRight(playerid, 1);
		if(id < 1) return error(playerid, "You don't have permission to place furniture in this house.");
		if(GetPVarInt(playerid, "HouseEnter") != id) return error(playerid, "You must be inside your house to plant a safe.");
		cmd_house(playerid, "plant 2332");
	}
	else if(strcmp(param, "bank", true) == 0)
  	{
		new id = GetPVarInt(playerid, "HouseEnter");
		if(!GetCloseHouseSafe(playerid, id)) return error(playerid, "You aren't near a house safe.");
		if(HouseInfo[id][sLocked] == 1) return error(playerid, "This house's safe(s) are locked! (/safe unlock)");
		new msg[128];
		format(msg, sizeof(msg), "Property Bank: $%d.", HouseInfo[id][hBank]);
		SCM(playerid, -1, msg);
		return 1;
	}
	else if(strcmp(param, "deposit", true) == 0)
  	{
		new id = GetPVarInt(playerid, "HouseEnter");
		if(!GetCloseHouseSafe(playerid, id)) return error(playerid, "You aren't near a house safe.");
		if(HouseInfo[id][sLocked] == 1) return error(playerid, "This house's safe(s) are locked! (/safe unlock)");
		if(amount == (-1)) return scm(playerid, COLOR_GREEN, "USAGE: /house deposit {FFFFFF} [amount]");
		if(amount <= 0) return scm(playerid, COLOR_GREEN, "USAGE: /house deposit {FFFFFF} [amount]");
		if(amount >= 99999999) return scm(playerid, COLOR_GREEN, "USAGE: /house deposit {FFFFFF} [amount]");
		if(GetPlayerMoneyEx(playerid) >= amount)
		{
			GivePlayerMoneyEx(playerid, -amount);
			HouseInfo[id][hBank]+=amount;
			format(string, 128, "$%d added to your property bank!", amount);
			SCM(playerid, -1, string);
			SaveHouse(id);
			OnPlayerDataSave(playerid);
		}
		else scm(playerid, -1, "You don't have this much cash on you!");
		return 1;
	}
	else if(strcmp(param, "withdraw", true) == 0)
  	{
		new id = GetPVarInt(playerid, "HouseEnter");
		if(!GetCloseHouseSafe(playerid, id)) return error(playerid, "You aren't near a house safe.");
		if(HouseInfo[id][sLocked] == 1) return error(playerid, "This house's safe(s) are locked! (/safe unlock)");
		if(amount == (-1)) return scm(playerid, COLOR_GREEN, "USAGE: /house withdraw {FFFFFF} [amount]");
		if(amount <= 0) return scm(playerid, COLOR_GREEN, "USAGE: /house withdraw {FFFFFF} [amount]");
		if(amount >= 99999999) return scm(playerid, COLOR_GREEN, "USAGE: /house withdraw {FFFFFF} [amount]");
		if(HouseInfo[id][hBank] <= 0) return scm(playerid, -1, "There is no cash in your property bank.");
		if(HouseInfo[id][hBank] >= amount)
		{
			format(string,128, "$%d withdrawn from your property!", amount);
			SCM(playerid, -1, string);
			GivePlayerMoneyEx(playerid, amount);
			HouseInfo[id][hBank]-=amount;
			SaveHouse(id);
			OnPlayerDataSave(playerid);
		}
		else scm(playerid, -1, "You don't have this much cash in your bank!");
		return 1;
	}
	else if(strcmp(param, "furn", true) == 0)
  	{
		GetAllHouseFurn(playerid);
		return 1;
	}
  	else if(strcmp(param, "putmats", true) == 0)
  	{
		new id = GetPVarInt(playerid, "HouseEnter");
		if(!GetCloseHouseSafe(playerid, id)) return error(playerid, "You are not near a house-safe. (/house plantsafe)");
		if(HouseInfo[id][sLocked] == 1) return error(playerid, "This house's safe(s) are locked! (/safe unlock)");
		if(amount == (-1)) return scm(playerid, COLOR_GREEN, "USAGE: /house putmats {FFFFFF} [amount]");
		if(amount <= 0) return scm(playerid, COLOR_GREEN, "USAGE: /house putmats {FFFFFF} [amount]");
		if(amount >= 99999999) return scm(playerid, COLOR_GREEN, "USAGE: /house putmats {FFFFFF} [amount]");
		if(amount > PlayerInfo[playerid][pMaterials]) return scm(playerid, COLOR_GREY, "You don't have that many materials!");
		PlayerInfo[playerid][pMaterials] = PlayerInfo[playerid][pMaterials] - amount;
		HouseInfo[id][hMats] = HouseInfo[id][hMats] + amount;
		SaveHouse(id);
		SaveCrafting(playerid);
		new sendername[MAX_PLAYER_NAME];
		format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
		GiveNameSpace(sendername);
		format(string, sizeof(string), "*** %s stores some materials in the safe.", sendername);
		ProxDetector(30.0, playerid, string, COLOR_PURPLE);
		format(string, sizeof(string), "You've stored %d materials inside the safe. (Safe Total: %d)", amount, HouseInfo[id][hMats]);
		SendClientMessage(playerid, COLOR_GREEN, string);
		return 1;
	}
  	else if(strcmp(param, "takemats", true) == 0)
  	{
		new id = GetPVarInt(playerid, "HouseEnter");
		if(!GetCloseHouseSafe(playerid, id)) return error(playerid, "You are not near a house-safe. (/house plantsafe)");
		if(HouseInfo[id][sLocked] == 1) return error(playerid, "This house's safe(s) are locked! (/safe unlock)");
		if(amount == (-1)) return scm(playerid, COLOR_GREEN, "USAGE: /house takemats {FFFFFF} [amount]");
		if(amount <= 0) return scm(playerid, COLOR_GREEN, "USAGE: /house takemats {FFFFFF} [amount]");
		if(amount >= 99999999) return scm(playerid, COLOR_GREEN, "USAGE: /house takemats {FFFFFF} [amount]");
		if(amount > HouseInfo[id][hMats]) return scm(playerid, COLOR_GREY, "There isn't that many materials in the safe!");
		HouseInfo[id][hMats] = HouseInfo[id][hMats] - amount;
		PlayerInfo[playerid][pMaterials] = PlayerInfo[playerid][pMaterials] + amount;
		SaveHouse(id);
		SaveCrafting(playerid);
		new sendername[MAX_PLAYER_NAME];
		format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
		GiveNameSpace(sendername);
		format(string, sizeof(string), "*** %s takes some materials from the safe.", sendername);
		ProxDetector(30.0, playerid, string, COLOR_PURPLE);
		format(string, sizeof(string), "You've taken %d materials from the safe. (Safe Total: %d)", amount, HouseInfo[id][hMats]);
		SendClientMessage(playerid, COLOR_GREEN, string);
		return 1;
	}
	else if(strcmp(param, "select", true) == 0) 
	{
		SetPVarInt(playerid, "SelectMode", SELECTMODE_HOUSE);
		SelectObject(playerid);
		SendClientMessage(playerid, COLOR_BLUE, "[TIP] {FFFFFF}Click on a house object to edit it.");
		return 1;
	}
	else if(strcmp(param, "backdoor", true) == 0)
  	{
  		if(GetPVarInt(playerid, "HouseKey") == 0) return SendClientMessage(playerid, COLOR_GREY, "You don't own a house.");
  		new id = GetPVarInt(playerid, "HouseKey");
  		if(HouseInfo[id][hbdXo] == 0 && HouseInfo[id][hbdYo] == 0 && HouseInfo[id][hbdZo] == 0) return SendClientMessage(playerid, COLOR_GREY, "This house does not have a back door.");

  		if(GetPVarInt(playerid, "HouseEnter") == id) {
			new Float:pos[3];
			GetPlayerPos(playerid, pos[0], pos[1], pos[2]);

			HouseInfo[id][hbdXi] = pos[0];
			HouseInfo[id][hbdYi] = pos[1];
			HouseInfo[id][hbdZi] = pos[2];

			DestroyDynamicCP(HouseInfo[id][hbdiIcon]);
			HouseInfo[id][hbdiIcon] = CreateDynamicCP(HouseInfo[id][hbdXi], HouseInfo[id][hbdYi], HouseInfo[id][hbdZi], 1.5, id, -1, -1, 5.0);

			SendClientMessage(playerid, COLOR_WHITE, "Backdoor set!");
			SaveHouseBackdoor(id);
  		} else {
  			SendClientMessage(playerid, COLOR_GREY, "You are not inside of your house.");
  		}
  		return 1;
  	}	
	else cmd_house(playerid, "");
	return 1;
}
//============================================//
COMMAND:safe(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") != 1) return true;
	new string[128], param[64], amount;
	if(sscanf(params, "s[64]I(-1)", param, amount)) return usage(playerid, "/safe [lock/unlock/setcombo]");
	if(GetPVarInt(playerid, "HouseEnter") != 0) { //House version
		if(strcmp(param, "lock", true) == 0)
		{
			new id = GetPVarInt(playerid, "HouseEnter");
			if(!GetCloseHouseSafe(playerid, id)) return error(playerid, "You aren't near a house-safe!");
			if(HouseInfo[id][sLocked] == 0) //Unlocked
			{
				PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
				GameTextForPlayer(playerid, "~w~Safe~n~~g~Locked", 4000, 3);
				scm(playerid,COLOR_ORANGE,"Houses safe(s) locked.");
				HouseInfo[id][sLocked] = 1;
				SaveHouse(id);
			}
			else error(playerid, "This safe is already locked! (/safe unlock)");
			return 1;
		}
		else if(strcmp(param, "unlock", true) == 0)
		{
			new id = GetPVarInt(playerid, "HouseEnter");
			if(!GetCloseHouseSafe(playerid, id)) return error(playerid, "You aren't near a house-safe!");
			if(HouseInfo[id][sLocked] == 1) //Locked
			{
				if(strmatch(PlayerName(playerid),HouseInfo[id][hOwner])) {
					HouseInfo[id][sLocked] = 0;
					scm(playerid,COLOR_ORANGE,"House safe(s) unlocked!");
					SaveHouse(id);
				}
				else ShowPlayerDialog(playerid,506,DIALOG_STYLE_INPUT, "House-Safe", "Enter your house-safes combination. (/safe setcombo)", "Submit", "Cancel");
			}
			else error(playerid, "This safe is already unlocked! (/safe lock)");
			return 1;
		}
		else if(strcmp(param, "setcombo", true) == 0)
		{
			if(GetPVarInt(playerid, "HouseKey") == 0) return error(playerid, "You do not own a property.");
			new id = GetPVarInt(playerid, "HouseKey");
			if(strmatch(HouseInfo[id][hOwner], PlayerName(playerid)))
			{
				if(amount < 1000) return scm(playerid, COLOR_GREEN, "USAGE: /safe setcombo {FFFFFF} [4-digit-combo]");
				if(amount > 9999) return scm(playerid, COLOR_GREEN, "USAGE: /safe setcombo {FFFFFF} [4-digit-combo]");
				if(GetCloseHouseSafe(playerid, id))
				{
					HouseInfo[id][hCombo] = amount;
					SaveHouse(id);
					format(string, 128, "You've set your house-safe's combo to %d.", amount);
					SCM(playerid, COLOR_LIGHTBLUE, string);
				}
				else error(playerid, "You are not near your house safe.");
			}
			else scm(playerid, -1, "Insufficient permission!");
			return 1;
		}
	}
	else if(GetPVarInt(playerid, "BizzEnter") != 0) { //biz version
		if(strcmp(param, "lock", true) == 0)
		{
			new id = GetPVarInt(playerid, "BizzEnter");
			if(!GetCloseBizzSafe(playerid, id)) return error(playerid, "You aren't near a biz-safe!");
			if(BizInfo[id][sLocked] == 0) //Unlocked
			{
				PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
				GameTextForPlayer(playerid, "~w~Safe~n~~g~Locked", 4000, 3);
				scm(playerid,COLOR_ORANGE,"Business safe(s) locked.");
				BizInfo[id][sLocked] = 1;
			}
			else error(playerid, "This safe is already locked! (/safe unlock)");
			SaveBiz(id);
			return 1;
		}
		else if(strcmp(param, "unlock", true) == 0)
		{
			new id = GetPVarInt(playerid, "BizzEnter");
			if(!GetCloseBizzSafe(playerid, id)) return error(playerid, "You aren't near a biz-safe!");
			if(BizInfo[id][sLocked] == 1) //Locked
			{
				if(strmatch(PlayerName(playerid),BizInfo[id][Owner])) {
					BizInfo[id][sLocked] = 0;
					scm(playerid,COLOR_ORANGE,"Business safe(s) unlocked!");
					SaveBiz(id);
				}
				else ShowPlayerDialog(playerid,507,DIALOG_STYLE_INPUT, "Biz-Safe", "Enter your business-safes combination. (/safe setcombo)", "Submit", "Cancel");
			}
			else error(playerid, "This safe is already unlocked! (/safe lock)");
			return 1;
		}
		else if(strcmp(param, "setcombo", true) == 0)
		{
			if(GetPVarInt(playerid, "BizzKey") == 0) return error(playerid, "You do not own a property.");
			new id = GetPVarInt(playerid, "BizzKey");
			if(strmatch(BizInfo[id][Owner], PlayerName(playerid)))
			{
				if(amount < 1000) return scm(playerid, COLOR_GREEN, "USAGE: /safe setcombo {FFFFFF} [4-digit-combo]");
				if(amount > 9999) return scm(playerid, COLOR_GREEN, "USAGE: /safe setcombo {FFFFFF} [4-digit-combo]");
				if(GetCloseBizzSafe(playerid, id))
				{
					BizInfo[id][Combo] = amount;
					SaveBiz(id);
					format(string, 128, "You've set your biz-safe's combo to %d.", amount);
					SCM(playerid, COLOR_LIGHTBLUE, string);
				}
				else error(playerid, "You are not near your business safe.");
			}
			else scm(playerid, -1, "Insufficient permission!");
			return 1;
		}
	}
	else return usage(playerid, "You aren't in a house or a business!");
	return 1;
}
//============================================//
COMMAND:door(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    new found = 0, key, Float:x, Float:y, Float:z, id, Float:adjust = 90.0;
	key = GetPVarInt(playerid, "HouseEnter");
	if(key != 0) {
		for(new h = 0; h < MAX_HOUSE_OBJ; h++)
		{
			if(HouseInfo[key][hObject][h] != 0)
			{
				if(IsPlayerInRangeOfPoint(playerid, 3.0, HouseInfo[key][hoX][h], HouseInfo[key][hoY][h], HouseInfo[key][hoZ][h]))
				{
					if(IsDoorObject(HouseInfo[key][hoID][h]))
					{
						if(found == 0) {
							if(HouseInfo[key][Locked][h] != 1) {
								id = HouseInfo[key][hObject][h];
								GetDynamicObjectRot(id, x, y, z);
								if(z >= HouseInfo[key][horZ][h]+adjust-1.0) {
									SetDynamicObjectRot(id, x, y, HouseInfo[key][horZ][h]);
								} else {
									SetDynamicObjectRot(id, x, y, z+adjust);
								}
							}
							else SCM(playerid, COLOR_LIGHTRED, "The door is locked. (/lockdoor)");
							found++;
						}
					}
				}
			}
		}
	}
	key = GetPVarInt(playerid, "BizzEnter");
	if(key != 0) {
		for(new h = 0; h < MAX_HOUSE_OBJ; h++)
		{
			if(BizInfo[key][bObject][h] != 0)
			{
				if(IsPlayerInRangeOfPoint(playerid, 3.0, BizInfo[key][boX][h], BizInfo[key][boY][h], BizInfo[key][boZ][h]))
				{
					if(IsDoorObject(BizInfo[key][boID][h]))
					{
						if(found == 0) {
							if(BizInfo[key][bLocked][h] != 1) {
								id = BizInfo[key][bObject][h];
								GetDynamicObjectRot(id, x, y, z);
								if(z >= BizInfo[key][borZ][h]+adjust-1.0) {
									SetDynamicObjectRot(id, x, y, BizInfo[key][borZ][h]);
								} else {
									SetDynamicObjectRot(id, x, y, z+adjust);
								}
							}
							else SCM(playerid, COLOR_LIGHTRED, "The door is locked. (/lockdoor)");
							found++;
						}
					}
				}
			}
		}
	}
	if(key == 0 && GetPVarInt(playerid, "HouseEnter") == 0) {
		for(new h = 0; h < MAX_MAP_OBJ; h++)
		{
			if(MapInfo[h][mObject] != 0)
			{
				if(IsPlayerInRangeOfPoint(playerid, 3.0, MapInfo[h][mX], MapInfo[h][mY], MapInfo[h][mZ]))
				{
					if(IsDoorObject(MapInfo[h][mID]))
					{
						if(found == 0) {
							if(MapInfo[h][mLocked] != 1) {
								id = MapInfo[h][mObject];
								GetDynamicObjectRot(id, x, y, z);
								if(z >= MapInfo[h][mrZ]+adjust-1.0) {
									SetDynamicObjectRot(id, x, y, MapInfo[h][mrZ]);
								} else {
									SetDynamicObjectRot(id, x, y, z+adjust);
								}
							}
							else SCM(playerid, COLOR_LIGHTRED, "The door is locked. (/lockdoor)");
							found++;
						}
					}
				}
			}
		}
	}
    return 1;
}
//============================================//
COMMAND:tow(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOR_GREY, "You must be in a vehicle driver to use this.");
    if (GetVehicleModel(GetPlayerVehicleID(playerid)) != 525) return SendClientMessage(playerid, COLOR_GREY, "You must be inside a towtruck to use this.");
    if(GetPVarInt(playerid, "Job") == 1 || ((GetPVarInt(playerid, "Member") == 5 || GetPVarInt(playerid, "Member") == 1) && GetPVarInt(playerid, "Rank") > 1))
    {
        if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
        {
            DetachTrailerFromVehicle(GetPlayerVehicleID(playerid));
		    return 1;
		}
        if(CartoCloseCar(playerid,1,7.0))
	    {
	        new carid = CartoCloseCar(playerid,2,7.0);
            if(IsNotAEngineCar(carid)) return SendClientMessage(playerid, COLOR_GREY, "This vehicle dosen't have an engine.");
	        AttachTrailerToVehicle(carid,GetPlayerVehicleID(playerid));
	    }
	    else SendClientMessage(playerid, COLOR_LIGHTRED, "WARNING: You are not close to any vehicle.");
    }
    else SendClientMessage(playerid, COLOR_GREY, "You must be a mechanic or rank 2+ in Rapid Recovery/LSPD to use this!");
	return 1;
}
//============================================//
COMMAND:repair(playerid, params[])
{
	new amount,targetid,string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "ui", targetid, amount)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /repair [playerid] [price]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") != 1) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (playerid == targetid) return SendClientMessage(playerid, COLOR_GREY, "You cannot repair to yourself.");
	    //=========//
	    new max1 = 100, max2 = 1000, carid = GetPlayerVehicleID(targetid);
        //=========//
        if(!IsPlayerInAnyVehicle(targetid)) return SendClientMessage(playerid, COLOR_GREY, "The player must be in a vehicle!");
	    if(IsNotAEngineCar(carid)) return SendClientMessage(playerid, COLOR_GREY, "The player must be in a vehicle!");
	    new ciid = carid;
	    if(ciid == 0) return SendClientMessage(playerid, COLOR_GREY, "The player must be in a ownable vehicle!");
	    //=========//
	    if(amount < max1 || amount > max2)
		{
			format(string, sizeof(string), "Cannot go under %d or above %d.", max1, max2);
		    SendClientMessage(playerid, COLOR_GREY, string);
		    return true;
		}
	    //=========//
	    if(!CheckInvItem(playerid, 406))
	    {
	        if(GetPVarInt(playerid, "Job") != 1) return SendClientMessage(playerid, COLOR_GREY, "You must be a mechanic to use this.");
            if(GetPVarInt(playerid, "OnRoute") == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You are not on a route!");
        }
		if(IsPlayerConnected(targetid))
		{
		    if(PlayerToPlayer(playerid,targetid,10.0))
   			{
				SetPVarInt(targetid, "RepairOffer", playerid);
				SetPVarInt(targetid, "RepairPrice", amount);
   			    format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
	    	    format(giveplayer, sizeof(giveplayer), "%s", PlayerNameEx(targetid));
      		    GiveNameSpace(sendername);
        	    GiveNameSpace(giveplayer);
        	    PlayerPlaySound(targetid, 1052, 0.0, 0.0, 0.0);
        	    PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
        	    format(string, sizeof(string), "You offered %s a repair contract for $%d.", giveplayer, amount);
           		SendClientMessage(playerid,COLOR_LIGHTBLUE,string);
            	format(string, sizeof(string), "%s gave you a repair contract for $%d (/accept repair).", sendername, amount);
            	SendClientMessage(targetid,COLOR_LIGHTBLUE,string);
    	        format(string, sizeof(string), "*** %s has offered %s a repair.", sendername, giveplayer);
    	        ProxDetector(30.0, playerid, string, COLOR_PURPLE);
   			}
   			else SendClientMessage(playerid,COLOR_GREY,"You are not close enough to that player!");
		}
	}
	return 1;
}
//============================================//
COMMAND:refill(playerid, params[])
{
	new amount,targetid,string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "ui", targetid, amount)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /refill [playerid] [price]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") != 1) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (playerid == targetid) return SendClientMessage(playerid, COLOR_GREY, "You cannot pay to yourself.");
	    if(amount < 1 || amount > 1000) return SendClientMessage(playerid, COLOR_GREY, "Cannot go under 1 or above 1000.");
	    if(GetPVarInt(playerid, "Job") != 1) return SendClientMessage(playerid, COLOR_GREY, "You must be a mechanic to use this.");
	    if(GetPVarInt(playerid, "OnRoute") == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You are not on a route!");
		if(IsPlayerConnected(targetid))
		{
		    if(PlayerToPlayer(playerid,targetid,8.0))
   			{
				SetPVarInt(targetid, "RefillOffer", playerid);
				SetPVarInt(targetid, "RefillPrice", amount);
   			    format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
	    	    format(giveplayer, sizeof(giveplayer), "%s", PlayerNameEx(targetid));
      		    GiveNameSpace(sendername);
        	    GiveNameSpace(giveplayer);
        	    PlayerPlaySound(targetid, 1052, 0.0, 0.0, 0.0);
        	    PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
        	    format(string, sizeof(string), "You offered %s a refill contract for $%d.", giveplayer, amount);
           		SendClientMessage(playerid,COLOR_LIGHTBLUE,string);
            	format(string, sizeof(string), "%s gave you a refill contract for $%d (/accept refill).", sendername, amount);
            	SendClientMessage(targetid,COLOR_LIGHTBLUE,string);
            	format(string, sizeof(string), "*** %s has offered %s a refill.", sendername, giveplayer);
    	        ProxDetector(30.0, playerid, string, COLOR_PURPLE);
   			}
   			else SendClientMessage(playerid,COLOR_GREY,"You are not close enough to that player!");
		}
	}
	return 1;
}
//============================================//
// LSPD COMMANDS //
COMMAND:kevlar(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Member") == 1) SetPlayerAttachedObject(playerid,0,19142,1,0.1,0.05,0.0,0.0,0.0,0.0);
    else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	return 1;
}
//============================================//
COMMAND:gov(playerid, params[])
{
	new text[128],string[255],sendername[MAX_PLAYER_NAME];
	if(sscanf(params, "s[128]", text)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /gov [Message]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if(GetPVarInt(playerid, "Member") == 1 || GetPVarInt(playerid, "Member") == 2 || GetPVarInt(playerid, "Member") == 8)
		{
		    if(GetPVarInt(playerid, "Rank") >= 10)
		    {
   			    format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
      		    GiveNameSpace(sendername);
    	        SendClientMessageToAll(COLOR_WHITE, "|___________ Government News Announcement ___________|");
    	        switch(GetPVarInt(playerid, "Member"))
    	        {
    	            case 1: format(string, sizeof(string), "LSPD %s: %s", sendername, text);
    	            case 2: format(string, sizeof(string), "LSPD %s: %s", sendername, text);
    	            case 8: format(string, sizeof(string), "GOV %s: %s", sendername, text);
    	        }
                SendClientMessageToAll(COLOR_BLUE, string);
            }
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
COMMAND:detain(playerid, params[])
{
	new targetid,seatid;
	if(sscanf(params, "ui", targetid,seatid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /detain [playerid] [seatID]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOR_WHITE, "You must be in a vehicle to use this!");
	    if (playerid == targetid) return SendClientMessage(playerid, COLOR_GREY, "You cannot detain yourself.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
		if(GetPVarInt(targetid, "Member") == 1) return SendClientMessage(playerid,COLOR_GREY,"Cannot detain LSPD.");
		if(IsACop(playerid) || GetPVarInt(playerid, "Member") == 2)
		{
		    if(PlayerToPlayer(playerid,targetid,7.0))
		    {
			    PutPlayerInVehicleEx(targetid, GetPlayerVehicleID(playerid), seatid);
			    SetPVarInt(targetid, "Drag", INVALID_MAXPL);
			    if(GetPVarInt(playerid, "Member") == 4) ApplyAnimation(targetid, "INT_HOUSE","BED_Loop_R", 4.0,1,1,1,1,1);
			}
    	    else SendClientMessage(playerid,COLOR_GREY,"You are not close enough to that player!");
		}
	}
	return 1;
}
//============================================//
COMMAND:m(playerid, params[])
{
	new text[128],string[255],sendername[MAX_PLAYER_NAME];
	if(sscanf(params, "s[128]", text)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /m [Message]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if(GetPVarInt(playerid, "Member") == 1 || GetPVarInt(playerid, "Member") == 2)
		{
   		    format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
      		GiveNameSpace(sendername);
	    	switch(GetPVarInt(playerid, "Member"))
	    	{
	    	    case 1: format(string, sizeof(string), "[LSPD %s:o< %s]", sendername, text);
	    	    case 2: format(string, sizeof(string), "[LSFD %s:o< %s]", sendername, text);
	    	}
			ProxDetector(60.0, playerid, string,COLOR_YELLOW);
			for(new h = 1; h < MAX_HOUSES; h++)
			{
	    		if(IsPlayerInRangeOfPoint(playerid,10.0, HouseInfo[h][hXo], HouseInfo[h][hYo], HouseInfo[h][hZo]))
	    		{
            		foreach(new p : Player)
					{
                		if(IsPlayerInRangeOfPoint(p,30.0, HouseInfo[h][hXi], HouseInfo[h][hYi], HouseInfo[h][hZi]))
                		{
							if(GetPlayerVirtualWorld(p) == h)
							{
							    format(string, sizeof(string), "[OUTSIDE DOOR]: %s", string);
				        		SendClientMessage(p, COLOR_YELLOW, string);
				    		}
						}
		    		}
	    		}
			}
		}
		else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
ALTCOMMAND:ta->taze;
ALTCOMMAND:taser->taze;
COMMAND:taze(playerid, params[])
{
	if(GetPVarInt(playerid, "Duty") != 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not on duty!");
	if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	if(GetPVarInt(playerid, "ConnectTime") < 8) return SendClientMessage(playerid, COLOR_GREY, "You need 8 hours played to use this command.");
	if(IsACop(playerid))
	{
		switch(GetPVarInt(playerid, "LSPD_Ta"))
		{
		    case 0:
		    {
		        if(PlayerInfo[playerid][pPlayerWeapon] > 0) SetPVarInt(playerid,"LSPD_Wep", PlayerInfo[playerid][pPlayerWeapon]), SetPVarInt(playerid,"LSPD_Ammo", PlayerInfo[playerid][pPlayerAmmo]);
		        SetPVarInt(playerid,"LSPD_Ta",1);
		        ResetPlayerWeapons(playerid);
		        GivePlayerWeaponEx(playerid,23,9999);
		        SendClientMessage(playerid,COLOR_WHITE,"taser equipped.");
		        CallRemoteFunction("LoadHolsters","i",playerid);
		    }
		    case 1:
		    {
		        ResetPlayerWeapons(playerid);
		        if(GetPVarInt(playerid, "LSPD_Wep") > 0) GivePlayerWeaponEx(playerid,GetPVarInt(playerid, "LSPD_Wep"),GetPVarInt(playerid, "LSPD_Ammo"));
		        else PlayerInfo[playerid][pPlayerWeapon]=0, PlayerInfo[playerid][pPlayerAmmo]=0, RemovePlayerAttachedObject(playerid, 9);
		        DeletePVar(playerid,"LSPD_Ta"), DeletePVar(playerid,"LSPD_Wep"), DeletePVar(playerid,"LSPD_Ammo"), DeletePVar(playerid,"LSPD_Delay");
		        SendClientMessage(playerid,COLOR_WHITE,"taser holstered.");
		        CallRemoteFunction("LoadHolsters","i",playerid);
		    }
		}
	}
	return 1;
}
//============================================//
COMMAND:tackle(playerid, params[])
{
	new string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME], Float:X, Float:Y, Float:Z;
	if(GetPVarInt(playerid, "Duty") != 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not on duty!");
	if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	if(IsACop(playerid) || GetPVarInt(playerid, "Member") == 2)
	{
	    foreach(new i : Player)
	    {
			if(i != playerid && PlayerToPlayer(playerid,i,4.0) && !IsPlayerInAnyVehicle(i))
			{
				if(GetPVarInt(i, "Member") == 1) return SendClientMessage(playerid,COLOR_GREY,"Cannot Tackle LSPD.");
				if(GetPVarInt(i, "Dead") > 0) return SendClientMessage(playerid,COLOR_GREY,"Cannot Tackle dead-people.");
				if(GetPlayerWeapon(i) >= 22 && GetPlayerWeapon(i) <= 38) return SendClientMessage(playerid,COLOR_GREY,"Cannot Tackle someone with a weapon in hand.");
				if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
   		    	format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
	        	format(giveplayer, sizeof(giveplayer), "%s", PlayerNameEx(i));
      	    	GiveNameSpace(sendername);
            	GiveNameSpace(giveplayer);
				GetPlayerPos(i, X, Y, Z);
            	new rand = random(4);
            	switch(rand)
            	{
            		case 0:
            		{
            			format(string, sizeof(string), "*** %s performs a little jump rushing towards %s making him fall down.", sendername, giveplayer);
    	    			ProxDetector(30.0, playerid, string, COLOR_PURPLE);
	    	    		SetPVarInt(i, "Cuffed", 1);
   						SetPVarInt(i, "CuffedTime", 60);
   						SetPVarInt(playerid, "CuffedTime", 10);
   						TogglePlayerControllableEx(playerid, false);
						TogglePlayerControllableEx(i,false);
						SetPlayerPosEx(playerid, X, Y+0.5, Z);
						ApplyAnimation(i, "PARACHUTE", "FALL_skyDive_DIE", 4.0, 0, 1, 1, 1, -1);
						ApplyAnimation(playerid,"ped","EV_dive",4.0,0,1,1,0,0);
    	    		}
    	    		case 1:
    	    		{
         				format(string, sizeof(string), "*** %s performs a little jump rushing towards %s but ends falling %s self on the floor.", sendername, giveplayer, CheckSex(playerid));
    	    			ProxDetector(30.0, playerid, string, COLOR_PURPLE);
    	    			ApplyAnimation(playerid,"ped","EV_dive",4.0,0,1,1,0,0);
    	    			SetPVarInt(playerid, "CuffedTime", 10);
					}
					case 2:
					{
         				format(string, sizeof(string), "*** %s performs a little jump rushing towards %s but ends falling %s self on the floor.", sendername, giveplayer, CheckSex(playerid));
    	    			ProxDetector(30.0, playerid, string, COLOR_PURPLE);
    	    			ApplyAnimation(playerid,"ped","EV_dive",4.0,0,1,1,0,0);
    	    			SetPVarInt(playerid, "CuffedTime", 10);
					}
					case 3:
					{
            			format(string, sizeof(string), "*** %s performs a little jump rushing towards %s making him fall down.", sendername, giveplayer);
    	    			ProxDetector(30.0, playerid, string, COLOR_PURPLE);
	    	    		SetPVarInt(i, "Cuffed", 1);
   						SetPVarInt(i, "CuffedTime", 60);
   						SetPVarInt(playerid, "CuffedTime", 10);
						TogglePlayerControllableEx(playerid, false);
						TogglePlayerControllableEx(i,false);
						SetPlayerPosEx(playerid, X, Y+0.5, Z);
						ApplyAnimation(i, "PARACHUTE", "FALL_skyDive_DIE", 4.0, 0, 1, 1, 1, -1);
						ApplyAnimation(playerid,"ped","EV_dive",4.0,0,1,1,0,0);
					}
				}
    	    	return 1;
    	    }
    	}
	}
	return 1;
}
//============================================//
COMMAND:cblock(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	if(GetPVarInt(playerid, "Member") == 1)
	{
	    if(GetPVarInt(playerid, "Rank") >= 3)
	    {
			if(RoadBlocks >= MAX_OBJECTS) return true;
			new objects = 9, oblist[9];
            oblist[0] = 973, oblist[1] = 997;
            oblist[2] = 1237, oblist[3] = 1282;
            oblist[4] = 1422, oblist[5] = 18646;
            oblist[6] = 978, oblist[7] = 3091;
            oblist[8] = 981;
            ShowModelSelectionMenuEx(playerid, oblist, objects, "Roadblock List", 10, 16.0, 0.0, -55.0);
	    }
    }
    else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	return 1;
}
//============================================//
COMMAND:rblock(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	if(GetPVarInt(playerid, "Member") == 1)
	{
	    if(GetPVarInt(playerid, "Rank") >= 3)
	    {
	        for(new o = 0; o < MAX_OBJECTS; o++)
	        {
				if(RoadBlockObject[o] != 0)
				{
	                if(IsValidDynamicObject(RoadBlockObject[o])) { DestroyDynamicObject(RoadBlockObject[o]); }
	                RoadBlockObject[o]=0;                  
                }
            }
			RoadBlocks = 0;
        }
    }
    else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	return 1;
}
//============================================//
COMMAND:showbadge(playerid, params[])
{
	new targetid,string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(GetPVarInt(playerid, "Duty") != 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not on duty!");
	if(sscanf(params, "u", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /showbadge [playerid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (playerid == targetid) return SendClientMessage(playerid, COLOR_GREY, "You cannot show to yourself.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
		if(GetPVarInt(playerid, "Member") == 1 || GetPVarInt(playerid, "Member") == 2 || GetPVarInt(playerid, "Member") == 8)
		{
		    if(PlayerToPlayer(playerid,targetid,3.0))
		    {
	    	    format(giveplayer, sizeof(giveplayer), "%s", PlayerNameEx(targetid));
      		    GiveNameSpace(giveplayer);
                format(string, sizeof(string), "You have shown your badge to %s.", giveplayer);
                SendClientMessage(playerid, COLOR_WHITE, string);
    	        format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
    	        GiveNameSpace(sendername);
				format(string, sizeof(string), "** %s %s **", FactionRank[GetPVarInt(playerid, "Member")][GetPVarInt(playerid, "Rank")], sendername);
    	        SendClientMessage(targetid, COLOR_WHITE, string);
    	    }
    	    else
   			{
   			    SendClientMessage(playerid,COLOR_GREY,"You are not close enough to that player!");
   			}
		}
	}
	return 1;
}
//============================================//
ALTCOMMAND:cuff->handcuff;
COMMAND:handcuff(playerid, params[])
{
	new string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME],targetid;
	if(GetPVarInt(playerid, "Duty") != 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not on duty!");
	if(sscanf(params, "u", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /handcuff [playerid/maskid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    new found = 0;
		if(!IsPlayerConnected(targetid))
		{
		    foreach(new i : Player)
	        {
	            if(GetPVarInt(i, "MaskUse") == 1 && GetPVarInt(i, "MaskID") == targetid)
	            {
	                targetid=i;
	                found++;
					break;
	            }
	        }
	        if(found == 0) return SendClientMessage(playerid,COLOR_WHITE,"There is no-one online with that playerid or maskid.");
		}
	    if (playerid == targetid) return SendClientMessage(playerid, COLOR_GREY, "You cannot handcuff yourself.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
		if(IsACop(playerid))
		{
		    if(PlayerToPlayer(playerid,targetid,3.0))
		    {
   			    format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
	    	    format(giveplayer, sizeof(giveplayer), "%s", PlayerNameEx(targetid));
      		    GiveNameSpace(sendername);
        	    GiveNameSpace(giveplayer);
                format(string, sizeof(string), "You placed handcuffs onto %s.", giveplayer);
    	        SendClientMessage(playerid, COLOR_WHITE, string);
    	        format(string, sizeof(string), "%s placed you in handcuffs.", sendername);
    	        SendClientMessage(targetid, COLOR_WHITE, string);
    	        SetCameraBehindPlayer(targetid);
    	        SetPVarInt(targetid, "Cuffed", 2);
    	        SetPVarInt(targetid, "CuffedTime", 0);
    	        SetPlayerSpecialAction(targetid,SPECIAL_ACTION_CUFFED);
    	        SetPlayerAttachedObject(targetid, 7, 19418, 5, 0.002000,0.037999,-0.004000,-12.600098,126.699996,-119.800048,1.000000,1.000000,1.000000);
				cancelPayphone(targetid); //Just in-case a suspect is ever on a payphone.
    	    }
    	    else SendClientMessage(playerid,COLOR_GREY,"You are not close enough to that player!");
		}
	}
	return 1;
}
//============================================//
COMMAND:uncuff(playerid, params[])
{
	new string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME],targetid;
	if(sscanf(params, "u", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /uncuff [playerid/maskid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
        new found = 0;
		if(!IsPlayerConnected(targetid))
		{
		    foreach(new i : Player)
	        {
	            if(GetPVarInt(i, "MaskUse") == 1 && GetPVarInt(i, "MaskID") == targetid)
	            {
	                targetid=i;
	                found++;
	            }
	        }
	        if(found == 0) return SendClientMessage(playerid,COLOR_WHITE,"There is no-one online with that playerid or maskid.");
		}
		if (playerid == targetid) return SendClientMessage(playerid, COLOR_GREY, "You cannot uncuff yourself.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
		if(IsACop(playerid) || GetPVarInt(playerid, "Admin") >= 1)
		{
		    if(PlayerToPlayer(playerid,targetid,3.0))
		    {
   			    format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
	    	    format(giveplayer, sizeof(giveplayer), "%s", PlayerNameEx(targetid));
      		    GiveNameSpace(sendername);
        	    GiveNameSpace(giveplayer);
                format(string, sizeof(string), "You took handcuffs off of %s.", giveplayer);
    	        SendClientMessage(playerid, COLOR_WHITE, string);
    	        format(string, sizeof(string), "%s released your handcuffs.", sendername);
    	        SendClientMessage(targetid, COLOR_WHITE, string);
    	        TogglePlayerControllableEx(targetid,true);
    	        SetPVarInt(targetid, "Cuffed", 0);
    	        SetPVarInt(targetid, "CuffedTime", 0);
    	        SetPlayerSpecialAction(targetid,SPECIAL_ACTION_NONE);
    	        RemovePlayerAttachedObject(targetid, 7);
    	    }
    	    else SendClientMessage(playerid,COLOR_GREY,"You are not close enough to that player!");
		}
	}
	return 1;
}
//============================================//
COMMAND:dragoffer(playerid, params[])
{
	new targetid,string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "ui", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /dragoffer {FFFFFF}[playerid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (playerid == targetid) return SendClientMessage(playerid, COLOR_GREY, "You cannot drag to yourself.");
	    if (GetPVarInt(targetid, "Dead") != 2) return SendClientMessage(playerid, COLOR_WHITE, "This player is not dead yet.");
	    if(GetPVarInt(playerid, "ConnectTime") < 8) return SendClientMessage(playerid, COLOR_GREY, "You need 8 hours played to use this command.");
	    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
		if(IsPlayerConnected(targetid))
		{
		    if(PlayerToPlayer(playerid,targetid,8.0))
   			{
				SetPVarInt(targetid, "DragOffer", playerid);
   			    format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
	    	    format(giveplayer, sizeof(giveplayer), "%s", PlayerNameEx(targetid));
      		    GiveNameSpace(sendername);
        	    GiveNameSpace(giveplayer);
        	    format(string, sizeof(string), "You offered %s a Drag.", giveplayer);
           		SendClientMessage(playerid,COLOR_LIGHTBLUE,string);
            	format(string, sizeof(string), "%s gave you a drag offer (/accept drag).", sendername);
            	SendClientMessage(targetid,COLOR_LIGHTBLUE,string);
   			}
   			else SendClientMessage(playerid,COLOR_GREY,"You are not close enough to that player!");
		}
	}
	return 1;
}
//============================================//
COMMAND:drag(playerid, params[])
{
	new string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME],targetid;
	if(sscanf(params, "u", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /drag [playerid/maskid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if (playerid == targetid) return SendClientMessage(playerid, COLOR_GREY, "You cannot drag yourself.");
		new found = 0;
		if(!IsPlayerConnected(targetid))
		{
		    foreach(new i : Player)
	        {
	            if(GetPVarInt(i, "MaskUse") == 1 && GetPVarInt(i, "MaskID") == targetid)
	            {
	                targetid=i;
	                found++;
	            }
	        }
	        if(found == 0) return SendClientMessage(playerid,COLOR_WHITE,"There is no-one online with that playerid or maskid.");
		}
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
	    if(IsPlayerNPC(targetid)) return SendClientMessage(playerid, COLOR_GREY, "Can't do this to a NPC.");
	    if(IsACop(targetid) && GetPVarInt(playerid, "Admin") < 1) return SendClientMessage(playerid,COLOR_GREY,"Cannot Drag Law Enforcement.");
		if(GetPVarInt(targetid, "Dead") > 0) return SendClientMessage(playerid,COLOR_GREY,"Cant drag dead-people.");
		if(IsACop(playerid) || GetPVarInt(playerid, "Admin") >= 1)
		{
		    if(PlayerToPlayer(playerid,targetid,3.0))
		    {
   			    format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
	    	    format(giveplayer, sizeof(giveplayer), "%s", PlayerNameEx(targetid));
      		    GiveNameSpace(sendername);
        	    GiveNameSpace(giveplayer);
                format(string, sizeof(string), "*** %s starts to drag %s.", sendername, giveplayer);
    	        ProxDetector(30.0, playerid, string, COLOR_PURPLE);
    	        SetCameraBehindPlayer(targetid);
    	        SetPVarInt(targetid, "Drag", playerid);
    	        SetPVarInt(targetid, "Control", 1);
    	    }
    	    else SendClientMessage(playerid,COLOR_GREY,"You are not close enough to that player!");
		}
	}
	return 1;
}
//============================================//
COMMAND:stopdrag(playerid, params[])
{
	new string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME],targetid;
	if(sscanf(params, "u", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /stopdrag [playerid/maskid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
        new found = 0;
		if(!IsPlayerConnected(targetid))
		{
		    foreach(new i : Player)
	        {
	            if(GetPVarInt(i, "MaskUse") == 1 && GetPVarInt(i, "MaskID") == targetid)
	            {
	                targetid=i;
	                found++;
	            }
	        }
	        if(found == 0) return SendClientMessage(playerid,COLOR_WHITE,"There is no-one online with that playerid or maskid.");
		}
		if (playerid == targetid) return SendClientMessage(playerid, COLOR_GREY, "You cannot drag yourself.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
	    if(IsPlayerNPC(targetid)) return SendClientMessage(playerid, COLOR_GREY, "Can't do this to a NPC.");
		if(GetPVarInt(targetid, "Drag") == playerid)
		{
   			format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
	    	format(giveplayer, sizeof(giveplayer), "%s", PlayerNameEx(targetid));
      		GiveNameSpace(sendername);
        	GiveNameSpace(giveplayer);
            format(string, sizeof(string), "*** %s stops dragging %s.", sendername, giveplayer);
    	    ProxDetector(30.0, playerid, string, COLOR_PURPLE);
    	    if(GetPVarInt(targetid, "Dead") != 0) ApplyAnimation(targetid, "PARACHUTE", "FALL_skyDive_DIE", 4.0, 0, 1, 1, 1, -1);
    	    SetPVarInt(targetid, "Drag", INVALID_MAXPL);
    	    SetPVarInt(targetid, "Control", 0);
    	    SetCameraBehindPlayer(targetid);
		}
		else SendClientMessage(playerid,COLOR_GREY,"You are not dragging this person.");
	}
	return 1;
}
//============================================//
COMMAND:take(playerid, params[])
{
	new targetid,type[128],string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "us[128]", targetid, type)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /take [playerid] [carkey/inv/materials/weplicense/drivlicense]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if (playerid == targetid) return SendClientMessage(playerid, COLOR_GREY, "You cannot take yourself.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
		if(strcmp(type, "carkey", true) == 0)
		{
			if(GetPVarInt(playerid, "Delay") > GetCount()) return SendClientMessage(playerid, COLOR_LIGHTRED, "You must wait before performing this command!");
			SetPVarInt(playerid, "TakeKeysFrom", targetid);
			new query[100];
			mysql_format(handlesql, query, sizeof(query), "SELECT `Model` FROM `vehicles` WHERE `Owner` = '%e';", PlayerInfo[playerid][pUsername]);
			mysql_tquery(handlesql, query, "OnTakeKeys", "i", playerid);
			SetPVarInt(playerid, "Delay", GetCount()+2000); SetPVarInt(targetid, "Delay", GetCount()+2000);
			return 1;
		}
		if(IsACop(targetid)) return SendClientMessage(playerid,COLOR_GREY,"Cannot take Law Enforcement.");
		if(IsACop(playerid))
		{
		    if(PlayerToPlayer(playerid,targetid,5.0))
		    {
		    	format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
	    		format(giveplayer, sizeof(giveplayer), "%s", PlayerNameEx(targetid));
      	   	 	GiveNameSpace(sendername);
        		GiveNameSpace(giveplayer);
		   	 	if(strcmp(type, "inv", true) == 0)
		    	{
                	format(string, sizeof(string), "%s has confiscated your inventory.", sendername);
					SendClientMessage(targetid,COLOR_WHITE,string);
					format(string, sizeof(string), "You confiscated %s's inventory.", giveplayer);
					SendClientMessage(playerid,COLOR_WHITE,string);
					ResetPlayerWeaponsEx(targetid);
					new string2[50], id;
					for(new i = 0; i < MAX_INV_SLOTS; i++)
					{
						format(string2, 25, "InvItem_%d", i);
						id = GetPVarInt(targetid, string2);
						if((id >= 1 && id <= 128) || (id >= 500 && id <= 550) || (id == 1004) || (id == 1002) || (id == 1005) || (id == 1050))
						{
							format(string2, 25, "InvSlot_%d", i);
							SetPVarInt(targetid, string2, 0);
							format(string2, 25, "InvItem_%d", i);
							SetPVarInt(targetid, string2, 0);
							format(string2, 25, "InvQ_%d", i);
							SetPVarInt(targetid, string2, 0);
							format(string2, 25, "InvEx_%d", i);
							SetPVarInt(targetid, string2, 0);
		    			}
					}
    	    	}
				else if(strcmp(type, "materials", true) == 0)
				{
                	format(string, sizeof(string), "%s has confiscated your materials.", sendername);
					SendClientMessage(targetid,COLOR_WHITE,string);
					format(string, sizeof(string), "You confiscated %s's materials.", giveplayer);
					SendClientMessage(playerid,COLOR_WHITE,string);	
					PlayerInfo[targetid][pMaterials] = 0;
					SaveCrafting(playerid);
				}
    	    	else if(strcmp(type, "weplicense", true) == 0)
		    	{
					if(GetPVarInt(targetid, "GunLic") == 1)
					{
                    	format(string, sizeof(string), "%s has confiscated your weapon license.", sendername);
				    	SendClientMessage(targetid,COLOR_WHITE,string);
				    	format(string, sizeof(string), "You confiscated %s's weapon license.", giveplayer);
				    	SendClientMessage(playerid,COLOR_WHITE,string);
				    	SetPVarInt(targetid, "GunLic", 0);
					}
					else SendClientMessage(playerid,COLOR_GREY,"That player doesn't have a weapon license.");
    	    	}
    	    	else if(strcmp(type, "drivlicense", true) == 0)
		    	{
					if(GetPVarInt(targetid, "DriveLic") == 1)
					{
                    	format(string, sizeof(string), "%s has confiscated your driver license.", sendername);
				    	SendClientMessage(targetid,COLOR_WHITE,string);
				    	format(string, sizeof(string), "You confiscated %s's driver license.", giveplayer);
				    	SendClientMessage(playerid,COLOR_WHITE,string);
				    	SetPVarInt(targetid, "DriveLic", 0);
					}
					else SendClientMessage(playerid,COLOR_GREY,"That player doesn't have a driver license.");
    	    	}
    	    }
    	    else SendClientMessage(playerid,COLOR_GREY,"You are not around that player.");
		}
	}
	return 1;
}
//============================================//
ALTCOMMAND:su->suspect;
COMMAND:suspect(playerid, params[])
{
	new targetid,crime[128],string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "us[128]", targetid, crime)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /suspect [playerid] [crime description]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (playerid == targetid) return SendClientMessage(playerid, COLOR_GREY, "You cannot suspect yourself.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
		if(IsACop(targetid)) return SendClientMessage(playerid,COLOR_GREY,"Cannot suspect Law Enforcement.");
		if(IsACop(playerid))
		{
   			format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
	    	format(giveplayer, sizeof(giveplayer), "%s", PlayerName(targetid));
      		GiveNameSpace(sendername);
        	GiveNameSpace(giveplayer);
        	format(string, sizeof(string), "HQ: All Units APB: Reporter: %s",sendername);
            SendFactionMessage(GetPVarInt(playerid, "Member"), COLOR_BLUE, string);
			format(string, sizeof(string), "HQ: Crime: %s, Suspect: %s",crime,giveplayer);
			SendFactionMessage(GetPVarInt(playerid, "Member"), COLOR_BLUE, string);
			SetPVarInt(targetid, "Crimes", GetPVarInt(targetid, "Crimes")+1);
			SetPVarInt(targetid, "WantedLevel", GetPVarInt(targetid, "WantedLevel")+1);
			SetPlayerWantedLevel(targetid,GetPVarInt(targetid, "WantedLevel"));
			new query[516], year, month, day, hour, minute, second;
			getdate(year, month, day);
			gettime(hour,minute,second);
			new datum[64], time[64];
			format(time, sizeof(time), "%d:%d:%d", hour, minute, second);
		 	format(datum, sizeof(datum), "%d-%d-%d", year, month, day);
			mysql_real_escape_string(crime, crime);
			mysql_format(handlesql, query, sizeof(query), "INSERT INTO `criminals`(`player`, `officer`, `date`, `time`, `crime`, `served`) VALUES ('%s','%s','%e','%s','%s', 0)",
			PlayerName(targetid), PlayerName(playerid), datum, time, crime);
			mysql_tquery(handlesql, query);
		}
	}
	return 1;
}
//============================================//
COMMAND:address(playerid, params[])
{
	new id;
	if(sscanf(params, "i", id)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /address [Property-ID]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if(GetPVarInt(playerid, "Member") == 1 || GetPVarInt(playerid, "Admin") > 0)
		{
   	        SendClientMessage(playerid,COLOR_LIGHTRED,"Checkpoint marked on your map.");
   	        SetPlayerCheckpoint(playerid,HouseInfo[id][hXo], HouseInfo[id][hYo], HouseInfo[id][hZo],5.0);
		}
		else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
ALTCOMMAND:gl->givelicense;
COMMAND:givelicense(playerid, params[])
{
	new type[128],targetid,string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "s[128]u", type, targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /gl(Give License) [weapon/driver] [playerid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
        if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_LIGHTRED, "You are currently muted!");
	    if (playerid == targetid) return SendClientMessage(playerid, COLOR_GREY, "You cannot give stuff to yourself.");
	    if(GetPVarInt(playerid, "Member") != 1) return SendClientMessage(playerid, COLOR_GREY, "You must be a Police Officer to use this.");
	    if(GetPVarInt(playerid, "Rank") < 10) return SendClientMessage(playerid, COLOR_GREY, "You must be rank 10 and above to use this.");
		if(IsPlayerConnected(targetid))
		{
   		    if(strcmp(type, "weapon", true) == 0)
   			{
   			    format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
	    	    format(giveplayer, sizeof(giveplayer), "%s", PlayerNameEx(targetid));
      		    GiveNameSpace(sendername);
        	    GiveNameSpace(giveplayer);
				format(string, sizeof(string), "You gave %s a weapon license.", giveplayer);
				SendClientMessage(playerid,COLOR_LIGHTBLUE,string);
				format(string, sizeof(string), "%s's gave you a weapon license.", sendername);
				SendClientMessage(targetid,COLOR_LIGHTBLUE,string);
				SetPVarInt(targetid, "GunLic", 1);
	        }
  			else if(strcmp(type, "driver", true) == 0)
   			{
   			    format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
	    	    format(giveplayer, sizeof(giveplayer), "%s", PlayerNameEx(targetid));
      		    GiveNameSpace(sendername);
        	    GiveNameSpace(giveplayer);
				format(string, sizeof(string), "You gave %s a driver license.", giveplayer);
				SendClientMessage(playerid,COLOR_LIGHTBLUE,string);
				format(string, sizeof(string), "%s's gave you a driver license.", sendername);
				SendClientMessage(targetid,COLOR_LIGHTBLUE,string);
				SetPVarInt(targetid, "DriveLic", 1);
   			}
   			else
   		    {
   			     SendClientMessage(playerid, COLOR_GREY, "USAGE: /gl [weapon/driver] [playerid]");
   		    }
		}
	}
	return 1;
}
//============================================//
COMMAND:spike(playerid, params[])
{
	new type[30];
	if(sscanf(params, "s[30]", type)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /spike [create/remove]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
        if (GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid, COLOR_GREY, "You must be outside to use this.");
		if(IsACop(playerid))
		{
		    if(GetPVarInt(playerid, "Rank") >= 3 || GetPVarInt(playerid, "Admin") > 1)
		    {
		        if(strcmp(type, "create", true) == 0)
		        {
					new found = 0;
		        	for(new i = 0; i < sizeof(SpikeInfo); i++)
		        	{
						if(SpikeInfo[i][sID] == 0)
						{
		                	found++;
		            	}
		        	}
		        	if(found == 0) return SendClientMessage(playerid,COLOR_WHITE,"All spike strip slots used.");
		        	for(new i = 0; i < sizeof(SpikeInfo); i++)
		        	{
		        	    if(SpikeInfo[i][sID] == 0)
		        	    {
						    new Float:X,Float:Y,Float:Z,Float:A;
						    GetPlayerPos(playerid,X,Y,Z);
						    GetPlayerFacingAngle(playerid,A);
						    SpikeInfo[i][sX]=X;
						    SpikeInfo[i][sY]=Y;
						    SpikeInfo[i][sZ]=Z;
						    SpikeInfo[i][sID]=1;
			        	    SpikeInfo[i][sObject] = CreateDynamicObject(2899, X, Y, Z-0.8, 0.0, 0.0, A, 0);
			        	    SpikeInfo[i][sPickup] = CreateDynamicPickup(1007, 14, X, Y, Z, 0);
			        	    SendClientMessage(playerid,COLOR_WHITE,"Spikes created.");
			        	    return 1;
			        	}
		        	}
		        }
		        if(strcmp(type, "remove", true) == 0)
		        {
		            for(new i = 0; i < sizeof(SpikeInfo); i++)
		            {
						if(SpikeInfo[i][sID] == 1)
						{
		                	if(IsPlayerInRangeOfPoint(playerid,2.0,SpikeInfo[i][sX],SpikeInfo[i][sY],SpikeInfo[i][sZ]))
		                	{
								if(SpikeInfo[i][sObject] > 0 && IsValidDynamicObject(SpikeInfo[i][sObject])) { DestroyDynamicObject(SpikeInfo[i][sObject]); }
								DestroyDynamicPickup(SpikeInfo[i][sPickup]);
								SpikeInfo[i][sObject]=0;
								SpikeInfo[i][sPickup]=0;
								SpikeInfo[i][sID]=0;
								SpikeInfo[i][sX]=0.0;
								SpikeInfo[i][sY]=0.0;
								SpikeInfo[i][sZ]=0.0;
		                	    SendClientMessage(playerid,COLOR_WHITE,"Spikes removed.");
		                	    return 1;
		                	}
						}
		            }
		        }
		    }
			else SendClientMessage(playerid,COLOR_GREY,"You are not high enough rank to use this.");
		}
	}
	return 1;
}
//============================================//
COMMAND:breathe(playerid, params[])
{
	new targetid,string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME],stext[50];
	if(sscanf(params, "u", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /breathe [playerid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
	    if(PlayerToPlayer(playerid,targetid,5.0))
	    {
	        if(GetPVarInt(playerid, "Member") == 1)
	        {
   		        format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
      	        format(giveplayer, sizeof(giveplayer), "%s", PlayerName(targetid));
      	        GiveNameSpace(sendername);
      	        GiveNameSpace(giveplayer);
    	        switch(GetPlayerDrunkLevel(targetid))
                {
                    case 0 .. 2400: stext="Sober";
                    case 2401 .. 6000: stext="Intoxicated";
                }
                if(GetPVarInt(targetid, "DrugTime") > 0) stext="Sober";
    	        format(string, sizeof(string), "* %s uses %s breathalyzer on %s.", sendername, CheckSex(playerid), giveplayer);
    	        ProxDetector(30.0, playerid, string, COLOR_PURPLE);
    	        format(string, sizeof(string), "%s is %s.", giveplayer, stext);
    	        SendClientMessage(playerid,COLOR_WHITE,string);
    	    }
      	}
      	else SendClientMessage(playerid,COLOR_GREY,"You are not close enough to that player!");
	}
	return 1;
}
//============================================//
COMMAND:obtainweed(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	if(GetPVarInt(playerid, "Member") == 1)
	{
	    for(new weed = 0; weed < sizeof(WeedInfo); weed++)
		{
            if(IsPlayerInRangeOfPoint(playerid,2.0,WeedInfo[weed][wX],WeedInfo[weed][wY],WeedInfo[weed][wZ]))
            {
			    if(WeedInfo[weed][wPlanted] == 1 && WeedInfo[weed][wX] != 0.0 && WeedInfo[weed][wY] != 0.0 && WeedInfo[weed][wZ] != 0.0)
				{
                    ApplyAnimation(playerid, "BOMBER","BOM_Plant_In",4.0,0,0,0,0,0);
		            if(WeedInfo[weed][wObject] > 0 && IsValidDynamicObject(WeedInfo[weed][wObject])) { DestroyDynamicObject(WeedInfo[weed][wObject]); }
		            WeedInfo[weed][wObject]=0;
		            WeedInfo[weed][wX] = 0.0;
		    		WeedInfo[weed][wY] = 0.0;
		    		WeedInfo[weed][wZ] = 0.0;
		    		WeedInfo[weed][wTime] = 0;
		    		WeedInfo[weed][wPlanted] = 0;
 		            SendClientMessage(playerid,COLOR_GREEN,"You have picked up this plant.");
		    	    return 1;
				}
			}
		}
    }
    else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	return 1;
}
//============================================//
ALTCOMMAND:fireremove->removefire;
COMMAND:removefire(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Admin") >= 2)
	{
	    if(IsAroundFire(playerid, 1, 2.5) && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	    {
	        new id = IsAroundFire(playerid,2,2.5);
		    if(IsValidDynamicObject(FDInfo[id][fObject])) DestroyDynamicObject(FDInfo[id][fObject]);
			FDInfo[id][fObject]=0;
		    FDInfo[id][fdX]=0.0;
		    FDInfo[id][fdY]=0.0;
		    FDInfo[id][fdZ]=0.0;
		    FDInfo[id][fWorld]=0;
		    FDInfo[id][fInt]=0;
		    FDInfo[id][fTime]=0;
		    FDInfo[id][fHealth]=0;
	    }
    }
    else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	return 1;
}
//============================================//
COMMAND:removeweed(playerid, params[])
{
	new string[128];
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Admin") >= 1)
	{
	    for(new weed = 0; weed < sizeof(WeedInfo); weed++)
		{
            if(IsPlayerInRangeOfPoint(playerid,2.0,WeedInfo[weed][wX],WeedInfo[weed][wY],WeedInfo[weed][wZ]))
            {
			    if(WeedInfo[weed][wPlanted] == 1 && WeedInfo[weed][wX] != 0.0 && WeedInfo[weed][wY] != 0.0 && WeedInfo[weed][wZ] != 0.0)
				{
                    ApplyAnimation(playerid, "BOMBER","BOM_Plant_In",4.0,0,0,0,0,0);
		            if(WeedInfo[weed][wObject] > 0 && IsValidDynamicObject(WeedInfo[weed][wObject])) { DestroyDynamicObject(WeedInfo[weed][wObject]); }
		            WeedInfo[weed][wObject]=0;
		            WeedInfo[weed][wX] = 0.0;
		    		WeedInfo[weed][wY] = 0.0;
		    		WeedInfo[weed][wZ] = 0.0;
		    		WeedInfo[weed][wTime] = 0;
		    		WeedInfo[weed][wPlanted] = 0;
 		            SendClientMessage(playerid,COLOR_GREEN,"You have picked up this plant.");
 		            format(string, sizeof(string),"Weed owner: %s",WeedInfo[weed][wName]);
 		            SendClientMessage(playerid,COLOR_GREEN,string);
		    	    return 1;
				}
			}
		}
    }
    else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	return 1;
}
//============================================//
COMMAND:arrest(playerid, params[])
{
	new targetid,string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME], time;
	if(sscanf(params, "ud", targetid, time)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /arrest [playerid] [time]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if (playerid == targetid) return SendClientMessage(playerid, COLOR_GREY, "You cannot arrest yourself.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
		if(GetPVarInt(playerid, "Member") == 1 && GetPVarInt(playerid, "Rank") >= 1)
		{
			if(PlayerToPlayer(playerid,targetid,5.0))
			{
			    if(GetPVarInt(playerid, "Admin") == 0)
			    {
			        if(!IsPlayerInRangeOfPoint(playerid,10.0, 133.4899,1084.6453,523.9155)) return true;
			    }
   			    format(sendername, sizeof(sendername), "%s", PlayerName(playerid)), format(giveplayer, sizeof(giveplayer), "%s", PlayerName(targetid));
      		    GiveNameSpace(sendername), GiveNameSpace(giveplayer);
        	    format(string, sizeof(string), "NEWS: %s has just arrested %s for %d minutes.", sendername, giveplayer, time);
		        SendFactionMessage(1,COLOR_BLUE,string);
				SetPVarInt(targetid, "WantedLevel", 0);
        	    SetPlayerWantedLevel(targetid,0);
				SetPVarInt(targetid, "Jailed", 2);
				new ran = random(sizeof(JailPos));
				Streamer_UpdateEx(targetid, JailPos[ran][jX], JailPos[ran][jY], JailPos[ran][jZ], 1, 1);
				SetPlayerPosEx(targetid, JailPos[ran][jX], JailPos[ran][jY], JailPos[ran][jZ]);
				SetPlayerInterior(targetid, 1);
				SetPlayerVirtualWorld(targetid, 1);
        	    SetPVarInt(targetid, "JailTime", time * 60);
				SetTimerEx("UncuffPlayer", 2500, false, "i", targetid);
				new query[90];
				mysql_format(handlesql, query, sizeof(query), "UPDATE `criminals` SET `served` = 1 WHERE `player` = '%e';", PlayerName(targetid));
				mysql_tquery(handlesql, query);
        	}
        	else SendClientMessage(playerid, COLOR_GREY, "You are not close to that player.");
		}
	}
	return 1;
}
//============================================//
COMMAND:duty(playerid, params[])
{
	new string[128];
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
   	switch(GetPVarInt(playerid, "Member"))
	{
		case 1:
		{
			switch(GetPVarInt(playerid, "Duty"))
			{
		    	case 0:
		    	{
					//if(!IsPlayerInRangeOfPoint(playerid, 5.0, 120.6401,1079.8180,523.9174)) return error(playerid, "You must be at the locker room (bottom floor LSPD)");
		        	SetPVarInt(playerid, "Duty", 1);
		        	SendClientMessage(playerid,COLOR_WHITE,"You are now On-Duty.");
    	        	ShowPlayerDialog(playerid,26,DIALOG_STYLE_MSGBOX,"Color Setting","Select the color of your SA-MP nametag.","Blue", "White");
		    	}
		    	case 1:
		    	{
		        	SetPVarInt(playerid, "Duty", 0);
		        	SendClientMessage(playerid,COLOR_WHITE,"You are now Off-Duty.");
		        	SetPlayerColor(playerid,COLOR_WHITE);
		            format(string, sizeof(string),"%s", PlayerNameEx(playerid));
		        	if(GetPVarInt(playerid, "MaskUse") == 1) Update3DTextLabelText(PlayerTag[playerid], 0xFFFFFFFF, string);
		    	}
			}
		}
		case 2:
		{
		    switch(GetPVarInt(playerid, "Duty"))
		    {
		        case 0:
		        {
					SetPlayerColor(playerid, COLOR_PINK);
					SetPVarInt(playerid, "Duty", 1);
		        	format(string, sizeof(string),"%s", PlayerNameEx(playerid));
		        	if(GetPVarInt(playerid, "MaskUse") == 1) Update3DTextLabelText(PlayerTag[playerid], COLOR_PINK, string);
		        }
		        case 1:
		        {
		        	SetPVarInt(playerid, "Duty", 0);
		        	SendClientMessage(playerid,COLOR_WHITE,"You are now Off-Duty.");
		        	SetPlayerColor(playerid,COLOR_WHITE);
		        	SetPlayerSkinEx(playerid, GetPVarInt(playerid, "Model"));
		        	format(string, sizeof(string),"%s", PlayerNameEx(playerid));
		        	if(GetPVarInt(playerid, "MaskUse") == 1) Update3DTextLabelText(PlayerTag[playerid], 0xFFFFFFFF, string);
		        }
			}
		}
		case 8: // GOVERNENT
		{
		    switch(GetPVarInt(playerid, "Duty"))
		    {
		        case 0:
		        {
					SetPVarInt(playerid, "Duty", 1);
					SendClientMessage(playerid,COLOR_WHITE,"You are now ON-Duty.");
		        }
		        case 1:
		        {
		        	SetPVarInt(playerid, "Duty", 0);
		        	SendClientMessage(playerid,COLOR_WHITE,"You are now Off-Duty.");
		        }
			}
		}
		default: SendClientMessage(playerid, COLOR_GREY, "You don't have access to this command!.");
	}
	return 1;
}
//============================================//
COMMAND:policespawn(playerid, params[])
{
	if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	if(GetPVarInt(playerid, "Duty") != 1 && GetPVarInt(playerid, "Member") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not on duty!");
	if(GetPVarInt(playerid, "Member") == 1 && GetPVarInt(playerid, "Rank") >= 1)
	{
	    if(IsPlayerInRangeOfPoint(playerid,5.0,1572.4750,-1692.9384,5.8906))
	    {
	        foreach(new car : Vehicle)
		    {
		        if(CopInfo[car][Created] == 1)
			    {
		            if(strcmp(CopInfo[car][Owner], PlayerName(playerid), true) == 0)
			        {
			            SendClientMessage(playerid, COLOR_GREY, "You already have a police vehicle spawned, please /despawncopcar.");
			            return 1;
			        }
		        }
	        }
	        ShowPlayerDialog(playerid,28,DIALOG_STYLE_LIST,"Vehicle Options","{33FF66}LSPD Vehicle\n{33FF66}SFPD Vehicle\n{33FF66}LVPD Vehicle\n{33FF66}S.W.A.T Truck\n{33FF66}Ranger\n{33FF66}Police Bike\n{33FF66}FBI Rancher\n{33FF66}LSPD Maverick\nWater Tank\nTow Truck","Spawn", "Cancel");
	    }
	}
	return 1;
}
COMMAND:boatspawn(playerid, params[])
{
	if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	if(GetPVarInt(playerid, "Member") == 1)
	{
	    if(IsPlayerInRangeOfPoint(playerid,5.0,2725.7688,-2318.5544,3.0000))
	    {
	        foreach(new car : Vehicle)
		    {
		        if(CopInfo[car][Created] == 1)
			    {
		            if(strcmp(CopInfo[car][Owner], PlayerName(playerid), true) == 0)
			        {
			            SendClientMessage(playerid, COLOR_GREY, "You already have a gov vehicle spawned, please /despawngovcar.");
			            return 1;
			        }
		        }
	        }
	        CreateLSPDVehicle(playerid, 430, -1, -1, "LSPD");
	    }
	}
	return 1;
}
//============================================//
//============================================//
COMMAND:acuspawn(playerid, params[])
{
	new string[128];
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	if(GetPVarInt(playerid, "Duty") != 1 && GetPVarInt(playerid, "Member") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not on duty!");
	if(GetPVarInt(playerid, "Member") == 1 && GetPVarInt(playerid, "Rank") >= 4)
	{
	    if(IsPlayerInRangeOfPoint(playerid,5.0,1579.0227,-1696.7950,6.2188))
	    {
	        foreach(new car : Vehicle)
		    {
		        if(CopInfo[car][Created] == 1)
			    {
		            if(strcmp(CopInfo[car][Owner], PlayerName(playerid), true) == 0)
			        {
			            SendClientMessage(playerid, COLOR_GREY, "You already have a police vehicle spawned, please /despawncopcar.");
			            return true;
			        }
		        }
	        }
	        new id, c1, c2;
	        if(sscanf(params, "iii", id, c1, c2)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /acuspawn [vehicleid] [color1] [color2]");
	        else
	        {
	            if(DonateCars(id))
	            {
	                if(c1 < 0 || c1 > 300) return SendClientMessage(playerid, COLOR_GREY, "Cannot go under 0 or above 300.");
	                if(c2 < 0 || c2 > 300) return SendClientMessage(playerid, COLOR_GREY, "Cannot go under 0 or above 300.");
	                SendClientMessage(playerid, COLOR_GREY, "ACU Vehicle Spawned!");
	                new randnum = 1000 + random(99999999);
		            format(string, sizeof(string),"%d",randnum);
	                CreateLSPDVehicle(playerid,id,c1,c2,string);
	                foreach(new car : Vehicle)
		            {
		                if(CopInfo[car][Created] == 1)
			            {
		                    if(strcmp(CopInfo[car][Owner], PlayerName(playerid), true) == 0)
			                {
			                    SetVehiclePosEx(car, 1570.4138,-1710.9031,5.6617);
			                    SetVehicleZAngle(car, 0.5985);
			                    return true;
			                }
		                }
	                }
	            }
	            else SendClientMessage(playerid, COLOR_GREY, "Invalid Vehicle ID!");
	        }
	    }
	}
	return 1;
}
//============================================//
COMMAND:fdspawn(playerid, params[])
{
	if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	if(GetPVarInt(playerid, "Duty") != 1 && GetPVarInt(playerid, "Member") == 2) return SendClientMessage(playerid, COLOR_WHITE, "You are not on duty!");
	if(GetPVarInt(playerid, "Member") == 2 && GetPVarInt(playerid, "Rank") > 1)
	{
	    if(IsPlayerInRangeOfPoint(playerid,5.0,1130.6198,-1332.3566,13.5815))
	    {
	        foreach(new car : Vehicle)
		    {
		        if(CopInfo[car][Created] == 1)
			    {
		            if(strcmp(CopInfo[car][Owner], PlayerName(playerid), true) == 0)
			        {
			            SendClientMessage(playerid, COLOR_GREY, "You already have a ems vehicle spawned, please /despawngovcar.");
			            return 1;
			        }
		        }
	        }
	        ShowPlayerDialog(playerid,65,DIALOG_STYLE_LIST,"Vehicle Options","Ladder Truck\nFire Truck (RED)\nFire Truck (YELLOW)\nAmbulance (WHITE & RED)\nAmbulance (RED & WHITE)\nAmbulance (RED)\nAmbulance (WHITE)\nRanger\nEnforcer\nFBI Rancher\nRomero\nTow Truck\nRaindance\nMaverick\nSquad Enforcer\nCommissioner's Vehicle","Spawn", "Cancel");
	    }
	}
	return 1;
}
//============================================//
COMMAND:govspawn(playerid, params[])
{
	if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	if(GetPVarInt(playerid, "Duty") != 1 && GetPVarInt(playerid, "Member") == 8) return SendClientMessage(playerid, COLOR_WHITE, "You are not on duty!");
	if(GetPVarInt(playerid, "Member") == 8 && GetPVarInt(playerid, "Rank") > 10)
	{
	    if(IsPlayerInRangeOfPoint(playerid,5.0,1468.5840,-1836.1243,13.5469))
	    {
	        foreach(new car : Vehicle)
		    {
		        if(CopInfo[car][Created] == 1)
			    {
		            if(strcmp(CopInfo[car][Owner], PlayerName(playerid), true) == 0)
			        {
			            SendClientMessage(playerid, COLOR_GREY, "You already have a gov vehicle spawned, please /despawngovcar.");
			            return 1;
			        }
		        }
	        }
			if(!IsACop(playerid)) {
				ShowPlayerDialog(playerid,78,DIALOG_STYLE_LIST,"Vehicle Options","Sultan\nPremier\nGMC\nLimo","Spawn", "Cancel");
			}
			else ShowPlayerDialog(playerid,78,DIALOG_STYLE_LIST,"Vehicle Options","Sultan\nPremier\nGMC\nLimo\nMaverick","Spawn", "Cancel");
	    }
	}
	return 1;
}
//============================================//
COMMAND:rlsspawn(playerid, params[])
{
	if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	if(GetPVarInt(playerid, "Member") == 3)
	{
	    if(IsPlayerInRangeOfPoint(playerid,5.0,849.9410,-1383.7013,13.5710))
	    {
	        foreach(new car : Vehicle)
		    {
		        if(CopInfo[car][Created] == 1)
			    {
		            if(strcmp(CopInfo[car][Owner], PlayerName(playerid), true) == 0)
			        {
			            SendClientMessage(playerid, COLOR_GREY, "You already have a gov vehicle spawned, please /despawngovcar.");
			            return 1;
			        }
		        }
	        }
	        CreateRLSVehicle(playerid);
	    }
	}
	return 1;
}
//============================================//
COMMAND:camera(playerid, params[])
{
	if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	if(GetPVarInt(playerid, "Member") == 2)
	{
	    if(IsPlayerInRangeOfPoint(playerid,5.0,1625.8281,-853.5438,879.9100))
	    {
	        if(CheckInvItem(playerid, 43)) return SendClientMessage(playerid, COLOR_GREY, "You already have a camera.");
	        GiveInvItem(playerid, 43, 50, 0);
	        SendClientMessage(playerid, COLOR_WHITE, "Camera stored in your inventory!");
	    }
	}
	return 1;
}
//============================================//
COMMAND:newsspawn(playerid, params[])
{
	if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	if(GetPVarInt(playerid, "Member") == 4)
	{
	    if(IsPlayerInRangeOfPoint(playerid,5.0,1798.5409,-1281.3446,13.6655))
	    {
	        foreach(new car : Vehicle)
		    {
		        if(CopInfo[car][Created] == 1)
			    {
		            if(strcmp(CopInfo[car][Owner], PlayerName(playerid), true) == 0)
			        {
			            SendClientMessage(playerid, COLOR_GREY, "You already have a news vehicle spawned, please /despawngovcar.");
			            return 1;
			        }
		        }
	        }
	        CreateNewsVehicle(playerid);
	    }
	}
	return 1;
}
//============================================//
ALTCOMMAND:despawngovcar->despawncopcar;
COMMAND:despawncopcar(playerid, params[])
{
	if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	if(GetPVarInt(playerid, "Member") == 1 || GetPVarInt(playerid, "Member") == 2 || GetPVarInt(playerid, "Member") == 8)
	{
	    foreach(new car : Vehicle)
		{
		    if(CopInfo[car][Created] == 1)
	        {
			    if(strcmp(CopInfo[car][Owner], PlayerName(playerid), true) == 0)
			    {
			        SendClientMessage(playerid, COLOR_GREY, " Faction vehicle despawned!");
			        VehicleInfo[car][vType] = VEHICLE_NONE;
			        CopInfo[car][Created] = 0;
			        DespawnVehicle(car);
					if(VehicleInfo[car][vUText] == 1) {
						VehicleInfo[car][vUText]=0;
						Delete3DTextLabel(VehicleInfo[car][vCText]);
					}
					for(new i = 0; i < 2; i++) {
						CopInfo[car][Gun_Rack_Weapon][i] = 0;
						CopInfo[car][Gun_Rack_Ammo][i] = 0;
						CopInfo[car][Gun_Rack_E][i] = 0;
					}
			        return 1;
			    }
		    }
	    }
	}
	return 1;
}
//============================================//
COMMAND:despawnnewscar(playerid, params[])
{
	if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	if(GetPVarInt(playerid, "Member") == 4)
	{
	    foreach(new car : Vehicle)
		{
		    if(CopInfo[car][Created] == 1)
	        {
			    if(strcmp(CopInfo[car][Owner], PlayerName(playerid), true) == 0)
			    {
			        SendClientMessage(playerid, COLOR_GREY, " News vehicle despawned!");
			        VehicleInfo[car][vType] = VEHICLE_NONE;
			        CopInfo[car][Created] = 0;
			        DespawnVehicle(car);
			        return 1;
			    }
		    }
	    }
	}
	return 1;
}
//============================================//
COMMAND:despawnrlscar(playerid, params[])
{
	if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	if(GetPVarInt(playerid, "Member") == 3)
	{
	    foreach(new car : Vehicle)
		{
		    if(CopInfo[car][Created] == 1)
	        {
			    if(strcmp(CopInfo[car][Owner], PlayerName(playerid), true) == 0)
			    {
			        SendClientMessage(playerid, COLOR_GREY, " RLS vehicle despawned!");
			        VehicleInfo[car][vType] = VEHICLE_NONE;
			        CopInfo[car][Created] = 0;
			        DespawnVehicle(car);
			        return 1;
			    }
		    }
	    }
	}
	return 1;
}
//============================================//
ALTCOMMAND:despawntt->despawntowtruck;
COMMAND:despawntowtruck(playerid, params[])
{
	if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	if(GetPVarInt(playerid, "Member") == 5) {
	    foreach(new car : Vehicle) {
		    if(CopInfo[car][Created] == 1) {
			    if(strcmp(CopInfo[car][Owner], PlayerInfo[playerid][pUsername], true) == 0) {
			        SendClientMessage(playerid, COLOR_GREY, " RR towtruck despawned!");
			        VehicleInfo[car][vType] = VEHICLE_NONE;
			        CopInfo[car][Created] = 0;
			        DespawnVehicle(car);
			        return 1;
			    }
		    }
	    }
	}
	return 1;
}
//============================================//
COMMAND:dooropen(playerid, params[])
{
	new found = 0, string[128], Float:X, Float:Y, Float:Z;
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Member") == 1)
	{
	    for(new i = 0; i < 5; i++)
	    {
	        if(found == 0)
	        {
	            GetDynamicObjectPos(lspddoor[i], X, Y, Z);
	            if(IsPlayerInRangeOfPoint(playerid, 5.0, X, Y, Z))
	            {
	                if(IsDynamicObjectMoving(lspddoor[i]))
					{
					    found++;
					    SendClientMessage(playerid, COLOR_BLUE,"Door is currently moving!");
					    return true;
					}
	                if(lspddoorS[i] == 1)
	                {
	                    found++;
	                    SendClientMessage(playerid, COLOR_BLUE,"Door is currently open!");
	                }
	                else
	                {
	                    
	                    if(i <= 1) {
	                    MoveDynamicObject(lspddoor[i], X-2.0, Y, Z, 5.0); }
	                    else {
                        MoveDynamicObject(lspddoor[i], X, Y-2.0, Z, 5.0); }
	                    format(string, 128, "Door(%d) is open, please close it!", i);
      		            SendClientMessage(playerid, COLOR_BLUE, string);
      		            found++;
      		            lspddoorS[i]=1;
      		            PlaySoundPlyRadius(playerid, 6400, 10.0);
      		        }
	            }
	        }
	    }
	}
	if(GetPVarInt(playerid, "Member") == 2)
	{
	    if(IsPlayerInRangeOfPoint(playerid,2.0,2043.50, -1338.00, 1270.50))
	    {
	        MoveDynamicObject(fddoor1, 2043.50-1.5, -1338.00, 1270.50, 3.5000);
      		SendClientMessage(playerid, COLOR_BLUE,"Door 1 is open, please close it!");
      		PlaySoundPlyRadius(playerid, 6400, 10.0);
	    }
	    if(IsPlayerInRangeOfPoint(playerid,2.0,2040.90, -1346.66, 1270.50))
	    {
	        MoveDynamicObject(fddoor2, 2040.90, -1346.66-1.5, 1270.50, 3.5000);
      		SendClientMessage(playerid, COLOR_BLUE,"Door 2 is open, please close it!");
      		PlaySoundPlyRadius(playerid, 6400, 10.0);
	    }
	    if(IsPlayerInRangeOfPoint(playerid,2.0,2047.30, -1349.86, 1270.50))
	    {
	        MoveDynamicObject(fddoor3, 2047.30, -1349.86-1.5, 1270.50, 3.5000);
      		SendClientMessage(playerid, COLOR_BLUE,"Door 3 is open, please close it!");
      		PlaySoundPlyRadius(playerid, 6400, 10.0);
	    }
	    if(IsPlayerInRangeOfPoint(playerid,2.0,2043.44, -1344.30, 1270.50))
	    {
	        MoveDynamicObject(fddoor4, 2043.44-1.5, -1344.30, 1270.50, 3.5000);
      		SendClientMessage(playerid, COLOR_BLUE,"Door 4 is open, please close it!");
      		PlaySoundPlyRadius(playerid, 6400, 10.0);
	    }
	    if(IsPlayerInRangeOfPoint(playerid,2.0,2040.80, -1353.06, 1270.50))
	    {
	        MoveDynamicObject(fddoor5, 2040.80, -1353.06-1.5, 1270.50, 3.5000);
      		SendClientMessage(playerid, COLOR_BLUE,"Door 5 is open, please close it!");
      		PlaySoundPlyRadius(playerid, 6400, 10.0);
	    }
	    if(IsPlayerInRangeOfPoint(playerid,2.0,2000.50, -1511.20, 1173.50))
		{
	        MoveDynamicObject(fddoor6, 2000.50-1.5, -1511.20, 1173.50, 3.5000);
      		SendClientMessage(playerid, COLOR_BLUE,"Door 6 is open, please close it!");
      		PlaySoundPlyRadius(playerid, 6400, 10.0);
	    }
	    if(IsPlayerInRangeOfPoint(playerid,2.0,2028.00, -671.50, 1477.90))
	    {
	        MoveDynamicObject(fddoor7, 2028.00-1.5, -671.50, 1477.90, 3.5000);
      		SendClientMessage(playerid, COLOR_BLUE,"Door 7 is open, please close it!");
      		PlaySoundPlyRadius(playerid, 6400, 10.0);
	    }
	    if(IsPlayerInRangeOfPoint(playerid,2.0,2037.60, -671.50, 1477.90))
	    {
	        MoveDynamicObject(fddoor8, 2037.60-1.5, -671.50, 1477.90, 3.5000);
      		SendClientMessage(playerid, COLOR_BLUE,"Door 8 is open, please close it!");
      		PlaySoundPlyRadius(playerid, 6400, 10.0);
	    }
	    if(IsPlayerInRangeOfPoint(playerid,2.0,2047.20, -671.60, 1477.90))
	    {
	        MoveDynamicObject(fddoor9, 2047.20-1.5, -671.60, 1477.90, 3.5000);
      		SendClientMessage(playerid, COLOR_BLUE,"Door 9 is open, please close it!");
      		PlaySoundPlyRadius(playerid, 6400, 10.0);
	    }
	}
	if(GetPVarInt(playerid, "Member") == 1 || GetPVarInt(playerid, "Member") == 8)
	{
	    if(GetPVarInt(playerid, "Member") == 1 && GetPVarInt(playerid, "Rank") <= 11) return true;
	    for(new i = 1; i < 13; i++)
	    {
	        if(found == 0)
	        {
	            GetDynamicObjectPos(govdoor[i], X, Y, Z);
	            if(IsPlayerInRangeOfPoint(playerid, 5.0, X, Y, Z))
	            {
	                if(IsDynamicObjectMoving(govdoor[i]))
					{
					    found++;
					    SendClientMessage(playerid, COLOR_BLUE,"Door is currently moving!");
					    return true;
					}
	                if(govdoorS[i] == 1)
	                {
	                    found++;
	                    SendClientMessage(playerid, COLOR_BLUE,"Door is currently open!");
	                }
	                else
	                {
	                    switch(i)
	                    {
	                        case 1 .. 5, 9 .. 11:
	                        {
	                            MoveDynamicObject(govdoor[i], X-2.0, Y, Z, 5.0);
	                        }
	                        default:
	                        {
	                            MoveDynamicObject(govdoor[i], X, Y-2.0, Z, 5.0);
	                        }
	                    }
	                    format(string, 128, "Door(%d) is open, please close it!", i);
      		            SendClientMessage(playerid, COLOR_BLUE, string);
      		            found++;
      		            govdoorS[i]=1;
      		            PlaySoundPlyRadius(playerid, 6400, 10.0);
      		        }
	            }
	        }
	    }
	}
	return true;
}
//============================================//
COMMAND:doorclose(playerid, params[])
{
    new found = 0, string[128], Float:X, Float:Y, Float:Z;
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Member") == 1)
	{
	    for(new i = 0; i < 5; i++)
	    {
	        if(found == 0)
	        {
	            GetDynamicObjectPos(lspddoor[i], X, Y, Z);
	            switch(i)
	            {
	                case 0,1: { X+=2.0; }
	                default: { Y+=2.0; }
	            }
	            if(IsPlayerInRangeOfPoint(playerid, 5.0, X, Y, Z))
	            {
					if(IsDynamicObjectMoving(lspddoor[i]))
					{
					    found++;
					    SendClientMessage(playerid, COLOR_BLUE,"Door is currently moving!");
					    return true;
					}
	                if(lspddoorS[i] == 0)
	                {
	                    found++;
	                    SendClientMessage(playerid, COLOR_BLUE,"Door is currently closed!");
	                }
	                else
					{
	                    MoveDynamicObject(lspddoor[i], X, Y, Z, 5.0);
	                    format(string, 128, "Door(%d) is closed, thank you!", i);
      		            SendClientMessage(playerid, COLOR_BLUE, string);
      		            found++;
      		            lspddoorS[i]=0;
      		            PlaySoundPlyRadius(playerid, 6400, 10.0);
      		        }
	            }
	        }
	    }
	}
	if(GetPVarInt(playerid, "Member") == 2)
	{
	    if(IsPlayerInRangeOfPoint(playerid,2.0,2043.50, -1338.00, 1270.50))
	    {
	        MoveDynamicObject(fddoor1, 2043.50, -1338.00, 1270.50, 3.5000);
      		SendClientMessage(playerid, COLOR_BLUE,"Door is closed, thank you!");
      		PlaySoundPlyRadius(playerid, 6400, 10.0);
	    }
	    if(IsPlayerInRangeOfPoint(playerid,2.0,2040.90, -1346.66, 1270.50))
	    {
	        MoveDynamicObject(fddoor2, 2040.90, -1346.66, 1270.50, 3.5000);
      		SendClientMessage(playerid, COLOR_BLUE,"Door is closed, thank you!");
      		PlaySoundPlyRadius(playerid, 6400, 10.0);
	    }
	    if(IsPlayerInRangeOfPoint(playerid,2.0,2047.30, -1349.86, 1270.50))
	    {
	        MoveDynamicObject(fddoor3, 2047.30, -1349.86, 1270.50, 3.5000);
      		SendClientMessage(playerid, COLOR_BLUE,"Door is closed, thank you!");
      		PlaySoundPlyRadius(playerid, 6400, 10.0);
	    }
	    if(IsPlayerInRangeOfPoint(playerid,2.0,2043.44, -1344.30, 1270.50))
	    {
	        MoveDynamicObject(fddoor4, 2043.44, -1344.30, 1270.50, 3.5000);
      		SendClientMessage(playerid, COLOR_BLUE,"Door is closed, thank you!");
      		PlaySoundPlyRadius(playerid, 6400, 10.0);
	    }
	    if(IsPlayerInRangeOfPoint(playerid,2.0,2040.80, -1353.06, 1270.50))
	    {
	        MoveDynamicObject(fddoor5, 2040.80, -1353.06, 1270.50, 3.5000);
      		SendClientMessage(playerid, COLOR_BLUE,"Door is closed, thank you!");
      		PlaySoundPlyRadius(playerid, 6400, 10.0);
	    }
	    if(IsPlayerInRangeOfPoint(playerid,2.0,2000.50, -1511.20, 1173.50))
		{
	        MoveDynamicObject(fddoor6, 2000.50, -1511.20, 1173.50, 3.5000);
      		SendClientMessage(playerid, COLOR_BLUE,"Door is closed, thank you!");
      		PlaySoundPlyRadius(playerid, 6400, 10.0);
	    }
	    if(IsPlayerInRangeOfPoint(playerid,2.0,2028.00, -671.50, 1477.90))
	    {
	        MoveDynamicObject(fddoor7, 2028.00, -671.50, 1477.90, 3.5000);
      		SendClientMessage(playerid, COLOR_BLUE,"Door is closed, thank you!");
      		PlaySoundPlyRadius(playerid, 6400, 10.0);
	    }
	    if(IsPlayerInRangeOfPoint(playerid,2.0,2037.60, -671.50, 1477.90))
	    {
	        MoveDynamicObject(fddoor8, 2037.60, -671.50, 1477.90, 3.5000);
      		SendClientMessage(playerid, COLOR_BLUE,"Door is closed, thank you!");
      		PlaySoundPlyRadius(playerid, 6400, 10.0);
	    }
	    if(IsPlayerInRangeOfPoint(playerid,2.0,2047.20, -671.60, 1477.90))
	    {
	        MoveDynamicObject(fddoor9, 2047.20, -671.60, 1477.90, 3.5000);
      		SendClientMessage(playerid, COLOR_BLUE,"Door is closed, thank you!");
      		PlaySoundPlyRadius(playerid, 6400, 10.0);
	    }
	}
	if(GetPVarInt(playerid, "Member") == 1 || GetPVarInt(playerid, "Member") == 8)
	{
	    if(GetPVarInt(playerid, "Member") == 1 && GetPVarInt(playerid, "Rank") <= 11) return true;
	    for(new i = 1; i < 13; i++)
	    {
	        if(found == 0)
	        {
	            GetDynamicObjectPos(govdoor[i], X, Y, Z);
	            switch(i)
	            {
	                case 1 .. 5, 9 .. 11: { X+=2.0; }
	                default: { Y+=2.0; }
	            }
	            if(IsPlayerInRangeOfPoint(playerid, 5.0, X, Y, Z))
	            {
					if(IsDynamicObjectMoving(govdoor[i]))
					{
					    found++;
					    SendClientMessage(playerid, COLOR_BLUE,"Door is currently moving!");
					    return true;
					}
	                if(govdoorS[i] == 0)
	                {
	                    found++;
	                    SendClientMessage(playerid, COLOR_BLUE,"Door is currently closed!");
	                }
	                else
					{
	                    MoveDynamicObject(govdoor[i], X, Y, Z, 5.0);
	                    format(string, 128, "Door(%d) is closed, thank you!", i);
      		            SendClientMessage(playerid, COLOR_BLUE, string);
      		            found++;
      		            govdoorS[i]=0;
      		            PlaySoundPlyRadius(playerid, 6400, 10.0);
      		        }
	            }
	        }
	    }
	}
	return true;
}
//============================================//
COMMAND:gateopen(playerid, params[])
{
	new Float:X, Float:Y, Float:Z;
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Member") == 1)
    {
        GetDynamicObjectPos(PDdoor, X, Y, Z);
	    if(IsPlayerInRangeOfPoint(playerid, 15.0, X, Y, Z))
	    {
	        if(PDdoorO == 1) return error(playerid, "The gate is already opened.");
	        MoveDynamicObject(PDdoor, 1587.95, -1638.22, 6.93, 10.0);
		    PDdoorO = 1;
            SendClientMessage(playerid, COLOR_WHITE,"The garage gate is open, use (/gateclose) to close it.");
            PlaySoundInArea(1153, X, Y, Z, 20.0);
    	    return true;
	    }
	    GetDynamicObjectPos(PDdoor2, X, Y, Z);
	    if(IsPlayerInRangeOfPoint(playerid, 15.0, X, Y, Z))
	    {
	        if(PDdoor2O == 1) return error(playerid, "The barrier is already opened.");
	        SetDynamicObjectRot(PDdoor2, 0.0, 0.0, 90.0);
		    PDdoor2O = 1;
            SendClientMessage(playerid, COLOR_WHITE,"The barrier is open, use (/gateclose) to close it.");
    	    return true;
	    }
    }
    if(GetPVarInt(playerid, "Member") == 2)
	{
	    if(IsPlayerInRangeOfPoint(playerid,20.0,1145.59998, -1291.0, 16.2))
	    {
	        MoveDynamicObject(medgate1,1145.59998, -1291, 16.2-9.0, 5.0);
	        MoveDynamicObject(medgate2,1136.7998, -1291, 16.2-9.0, 5.0);
	        PlaySoundInArea(1153,1145.59998, -1291, 16.2,20.0);
            SendClientMessage(playerid, COLOR_WHITE,"The garage gate is open, use (/gateclose) to close it.");
            return true;
	    }
	    if(IsPlayerInRangeOfPoint(playerid,20.0, 1150.80005, -1348.09998, 16.1))
	    {
	        MoveDynamicObject(medgate3,1150.80005, -1348.09998, 16.1-9.0, 5.0);
	        MoveDynamicObject(medgate4,1142.0, -1348.09998, 16.1-9.0, 5.0);
	        PlaySoundInArea(1153,1150.80005, -1348.09998, 16.1,20.0);
            SendClientMessage(playerid, COLOR_WHITE,"The garage gate is open, use (/gateclose) to close it.");
            return true;
	    }
	}
	return 1;
}
//============================================//
COMMAND:gateclose(playerid, params[])
{
	new Float:X, Float:Y, Float:Z;
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Member") == 1)
    {
	    if(IsPlayerInRangeOfPoint(playerid, 15.0, 1587.95, -1638.22, 14.93))
	    {
	        if(PDdoorO == 0) return error(playerid, "The gate is not open.");
	        ClosePDGarage(1);
            SendClientMessage(playerid, COLOR_WHITE,"Garage gate closed.");
            PlaySoundInArea(1153, X, Y, Z, 20.0);
    	    return true;
	    }
	    GetDynamicObjectPos(PDdoor2, X, Y, Z);
	    if(IsPlayerInRangeOfPoint(playerid, 15.0, X, Y, Z))
	    {
	        if(PDdoor2O == 0) return error(playerid, "The barrier is not open.");
	        ClosePDGarage(2);
            SendClientMessage(playerid, COLOR_WHITE,"Barrier closed.");
    	    return true;
	    }
    }
    if(GetPVarInt(playerid, "Member") == 2)
	{
	    if(IsPlayerInRangeOfPoint(playerid,20.0,1145.59998, -1291.0, 16.2))
	    {
	        MoveDynamicObject(medgate1,1145.59998, -1291, 16.2, 5.0);
	        MoveDynamicObject(medgate2,1136.7998, -1291, 16.2, 5.0);
	        PlaySoundInArea(1153,1145.59998, -1291, 16.2,20.0);
            SendClientMessage(playerid, COLOR_WHITE,"The garage gate is closed.");
            return true;
	    }
	    if(IsPlayerInRangeOfPoint(playerid,20.0, 1150.80005, -1348.09998, 16.1))
	    {
	        MoveDynamicObject(medgate3,1150.80005, -1348.09998, 16.1, 5.0);
	        MoveDynamicObject(medgate4,1142.0, -1348.09998, 16.1, 5.0);
	        PlaySoundInArea(1153,1150.80005, -1348.09998, 16.1,20.0);
            SendClientMessage(playerid, COLOR_WHITE,"The garage gate is closed.");
            return true;
	    }
	}
	return 1;
}
//============================================//
COMMAND:licenses(playerid, params[])
{
	new string[128],dtext[20],wtext[20];
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    switch(GetPVarInt(playerid, "DriveLic"))
    {
        case 0: dtext = "Not Passed";
        case 1: dtext = "Passed";
    }
    switch(GetPVarInt(playerid, "GunLic"))
    {
        case 0: wtext = "Not Passed";
        case 1: wtext = "Passed";
        case 2: wtext = "Permanent Passed";
    }
    SendClientMessage(playerid,COLOR_WHITE,"_____________________________________________________");
    SendClientMessage(playerid,COLOR_WHITE,"                               Licenses:");
    format(string, sizeof(string), "Driving License: %s", dtext);
    SendClientMessage(playerid, COLOR_GREY, string);
    format(string, sizeof(string), "Weapon License: %s", wtext);
    SendClientMessage(playerid, COLOR_GREY, string);
    SendClientMessage(playerid,COLOR_WHITE,"_____________________________________________________");
	return 1;
}
//============================================//
COMMAND:sid(playerid, params[])
{
	new targetid,string[128],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "u", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /sid {FFFFFF}[playerid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_LIGHTRED, "You are currently muted!");
	    if (playerid == targetid) return SendClientMessage(playerid, COLOR_GREY, "You cannot show yourself, use /licenses.");
		if(IsPlayerConnected(targetid))
		{
		    if(PlayerToPlayer(playerid,targetid,5.0))
   			{
	    	    format(giveplayer, sizeof(giveplayer), "%s", PlayerName(playerid));
        	    GiveNameSpace(giveplayer);
        	    SendClientMessage(targetid,COLOR_WHITE,"_____________________________________________________");
        	    format(string, sizeof(string), "Name: %s - Age: %d", giveplayer, GetPVarInt(targetid, "Age"));
        	    SendClientMessage(targetid, COLOR_GREY, string);
        	    SendClientMessage(targetid,COLOR_WHITE,"_____________________________________________________");
        	    format(string, sizeof(string), "ID shown to %s", PlayerName(targetid));
        	    SendClientMessage(playerid, COLOR_WHITE, string);
   			}
   			else SendClientMessage(playerid,COLOR_GREY,"You are not close enough to that player!");
		}
	}
	return 1;
}
//============================================//
ALTCOMMAND:sl->showlicenses;
COMMAND:showlicenses(playerid, params[])
{
	new targetid,string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME],dtext[20],wtext[20];
	if(sscanf(params, "u", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /showlicenses {FFFFFF}[playerid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_LIGHTRED, "You are currently muted!");
	    if (playerid == targetid) return SendClientMessage(playerid, COLOR_GREY, "You cannot show yourself, use /licenses.");
		if(IsPlayerConnected(targetid))
		{
		    if(PlayerToPlayer(playerid,targetid,5.0))
   			{
   			    format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
	    	    format(giveplayer, sizeof(giveplayer), "%s", PlayerNameEx(targetid));
      		    GiveNameSpace(sendername);
        	    GiveNameSpace(giveplayer);
        	    switch(GetPVarInt(playerid, "DriveLic"))
        	    {
            	    case 0: dtext = "Not Passed";
            	    case 1: dtext = "Passed";
        	    }
        	    switch(GetPVarInt(playerid, "GunLic"))
        	    {
            	    case 0: wtext = "Not Passed";
            	    case 1: wtext = "Passed";
            	    case 2: wtext = "Permanent Passed";
        	    }
        	    SendClientMessage(targetid,COLOR_WHITE,"_____________________________________________________");
        	    format(string, sizeof(string), "                               %s's licenses:", sendername);
        	    SendClientMessage(targetid,COLOR_WHITE,string);
        	    format(string, sizeof(string), "Driving License: %s", dtext);
        	    SendClientMessage(targetid, COLOR_GREY, string);
        	    format(string, sizeof(string), "Weapon License: %s", wtext);
        	    SendClientMessage(targetid, COLOR_GREY, string);
        	    SendClientMessage(targetid,COLOR_WHITE,"_____________________________________________________");
				format(string, sizeof(string), "You shown your licenses to %s.", giveplayer);
				SendClientMessage(playerid, 0xCCEEFF96, string);
   			}
   			else
   			{
   			    SendClientMessage(playerid,COLOR_GREY,"You are not close enough to that player!");
   			}
		}
	}
	return 1;
}
//============================================//
COMMAND:togphone(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "PlayerSpectate") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You can't be spectating and use this command.");
    if(!CheckInvItem(playerid, 405)) return SendClientMessage(playerid, COLOR_WHITE, "You don't have a cellphone.");
    if(GetPVarInt(playerid, "CellMenu") > 0) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while using phone.");
    switch(GetPVarInt(playerid, "TogPhone"))
    {
        case 0:
        {
            SetPVarInt(playerid, "TogPhone", 1);
            SendClientMessage(playerid, COLOR_GREY, "Phone turned off.");
        }
        case 1:
        {
            DeletePVar(playerid,"TogPhone");
            SendClientMessage(playerid, COLOR_GREY, "Phone turned on.");
        }
    }
	return 1;
}
//============================================//
ALTCOMMAND:phone->cellphone;
COMMAND:cellphone(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if (GetPVarInt(playerid, "PayPhone") == 1) return SendClientMessage(playerid, COLOR_GREY, "You are currently using a payphone.");
    if (!CheckInvItem(playerid, 405)) return SendClientMessage(playerid, COLOR_WHITE, "You don't have a cellphone.");
    if (GetPVarInt(playerid, "Cuffed") > 0) return SendClientMessage(playerid, COLOR_GREY, "You can't do this while handcuffed/tazed.");
    if(GetPVarInt(playerid, "Jailed") > 0) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-jail.");
    if(GetPVarInt(playerid, "TogPhone") == 1) return SendClientMessage(playerid, COLOR_WHITE, "Your phone is turned off.");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_LIGHTRED, "You are currently muted!");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while dead!");
    if(IsPlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-water!");
	SetPVarInt(playerid,"CellMenu", 1);
	CellphoneState(playerid,1);
	ShowPlayerDialog(playerid,38,DIALOG_STYLE_LIST,"Cellphone","Call Number\nContacts\nText Message\nPickup Call\nToggle Speaker\nHang Up / Pocket Phone","Select", "");
	return 1;
}
//============================================//
COMMAND:ticket(playerid, params[])
{
	new targetid,string[128], amount, reason[50];
	if(sscanf(params, "uds", targetid, amount, reason)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /ticket [playerid] [amount] [reason]");
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	//if (playerid == targetid) return SendClientMessage(playerid, COLOR_GREY, "You cannot ticket yourself.");
    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
	if(GetPVarInt(playerid, "Member") != 1) return nal(playerid);
	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(playerid, X, Y, Z);
	if(!IsPlayerInRangeOfPoint(targetid, 10.0, X, Y, Z)) return error(playerid, "This player is not nearby you.");
	if(amount < 25 || amount > 2000) return SendClientMessage(playerid, COLOR_GREY, "Cannot go under 25 or above 2000.");
	new query[516], year, month, day, hour, minute, second;
	getdate(year, month, day);
	gettime(hour,minute,second);
	new datum[64], timel[64];
	format(timel, sizeof(timel), "%d:%d:%d", hour, minute, second);
 	format(datum, sizeof(datum), "%d-%d-%d", year, month, day);
	format(query, sizeof(query), "INSERT INTO `tickets`(`player`, `officer`, `time`, `date`, `amount`, `reason`) VALUES ('%s','%s','%s','%s',%d,'%s')",
    PlayerName(targetid), PlayerName(playerid),
	timel,datum, amount,reason);
	mysql_tquery(handlesql, query);
	format(string, sizeof(string), "* %s writes a ticket of $%d to %s", PlayerName(playerid), amount, PlayerName(targetid));
	ProxDetector(30.0, playerid, string, COLOR_PURPLE);
	return 1;
}
//============================================//
COMMAND:payticket(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 5.0, 129.2496,1131.2227,527.4651)) return error(playerid, "You must be at the police station to do this.");
	new query[255];
	format(query, sizeof(query), "SELECT * FROM tickets WHERE player='%s' AND paid=0 ORDER BY ID DESC", PlayerName(playerid));
	mysql_function_query(handlesql, query, true, "PayTicketsP", "i", playerid);
	return 1;
}
//============================================//
COMMAND:tickets(playerid, params[])
{
	new query[255];
	format(query, sizeof(query), "SELECT * FROM tickets WHERE player='%s' AND paid=0 ORDER BY ID DESC", PlayerName(playerid));
	mysql_function_query(handlesql, query, true, "GetTicketsP", "i", playerid);
	return 1;
}
//============================================//
COMMAND:frisk(playerid, params[])
{
	new Float:X, Float:Y, Float:Z, id, string[128];
	GetPlayerPos(playerid, X, Y, Z);
	if(sscanf(params, "u", id)) return usage(playerid, "/frisk [PlayerID/Name]");
	if(!IsPlayerInRangeOfPoint(id, 5.0, X, Y, Z)) return error(playerid, "Player is not nearby.");
	if(playerid == id) return true;
	PrintInvO(id, playerid);
	format(string, sizeof(string), "* %s starts searching %s for items", PlayerNameEx(playerid), PlayerNameEx(id));
	ProxDetector(30.0, playerid, string, COLOR_PURPLE);
 	scm(playerid, COLOR_LIGHTRED, "Warning: Always roleplay your frisking before doing so!");
	format(string, sizeof(string), "This player is currently carrying {36CC40}%d {FFFFFF}materials.", PlayerInfo[id][pMaterials]);
	scm(playerid, COLOR_WHITE, string);
	if(GetPVarInt(id, "TrackBug") == 1) scm(playerid, COLOR_BLUE, "This player is wearing a wire!");
	return 1;
}
//============================================//
COMMAND:checkinv(playerid, params[])
{
	new id;
	if(sscanf(params, "i", id)) return usage(playerid, "/checkinv [PlayerID]");
	if(GetPVarInt(playerid, "Admin") < 1) return nal(playerid);
	PrintInvO(id, playerid);
	return 1;
}
//============================================//
COMMAND:checkvehinv(playerid, params[])
{
	new id;
	if(sscanf(params, "i", id)) return usage(playerid, "/checkvehinv [vehicleID]");
	if(GetPVarInt(playerid, "Admin") < 1) return nal(playerid);
	PrintVehInvEx(playerid, id);
	return 1;
}
//============================================//
COMMAND:checkhouseinv(playerid, params[])
{
	new id;
	if(sscanf(params, "i", id)) return usage(playerid, "/checkhouseinv [houseID]");
	if(GetPVarInt(playerid, "Admin") < 1) return nal(playerid);
	PrintHouseInvEx(playerid, id);
	return 1;
}
//============================================//
COMMAND:checkbizzinv(playerid, params[])
{
	new id;
	if(sscanf(params, "i", id)) return usage(playerid, "/checkbizzinv [businessID]");
	if(GetPVarInt(playerid, "Admin") < 1) return nal(playerid);
	PrintBizInvEx(playerid, id);
	return 1;
}
//============================================//
ALTCOMMAND:checksb->checkseatbelt;
COMMAND:checkseatbelt(playerid, params[])
{
	new Float:X, Float:Y, Float:Z, id, string[128];
	GetPlayerPos(playerid, X, Y, Z);
	if(sscanf(params, "u", id)) return usage(playerid, "/checkseatbelt [PlayerID/Name]");
	if(!IsPlayerInRangeOfPoint(id, 5.0, X, Y, Z)) return error(playerid, "Player is not nearby.");
 	if(GetPVarInt(id, "Seatbelt") == 1) {
		format(string, sizeof(string), "* %s ((Is wearing a seatbelt)) ", PlayerName(id));
		ProxDetector(30.0, playerid, string, COLOR_PURPLE);
 	} else {
		format(string, sizeof(string), "* %s ((Is not wearing a seatbelt)) ", PlayerName(id));
		ProxDetector(30.0, playerid, string, COLOR_PURPLE);
 	}
	return 1;
}
//============================================//
COMMAND:uniform(playerid, params[])
{
    new Skin[10], count = 0;
	if(GetPVarInt(playerid, "Member") == 1)
	{
	    if(!IsPlayerInRangeOfPoint(playerid, 2.0, 120.6401,1079.8180,523.9174)) return true;
	    for(new i = 0; i < 10; i++)
	    {
	        //if(LSPDskin[i][Rank] != 0) format(diatxt, sizeof(diatxt), "%s{FFFFFF}%s {33FF66}(Rank %d)\n", diatxt, LSPDskin[i][Name], LSPDskin[i][Rank]);
			if(LSPDskin[i][Rank] != 0) Skin[i] = LSPDskin[i][SkinID];
			count++;
	    }
	    ShowModelSelectionMenuEx(playerid, Skin, count, "Select skin", 4, 0.0, 0.0, 0.0);
	    //ShowPlayerDialog(playerid, 205, DIALOG_STYLE_LIST, "Locker room",  diatxt, "Select", "Close");
	}
	if(GetPVarInt(playerid, "Member") == 2)
	{
	    if(!IsPlayerInRangeOfPoint(playerid, 2.0, 2042.0798,-1349.6273,1271.4860)) return true;
	    for(new i = 0; i < 8; i++)
	    {
			Skin[i] = LSFDskin[i][SkinID];
			count++;
	    }
	    ShowModelSelectionMenuEx(playerid, Skin, count, "Select skin", 7, 0.0, 0.0, 0.0);
	}
	if(GetPVarInt(playerid, "Member") == 8)
	{
	    if(!IsPlayerInRangeOfPoint(playerid, 2.0, 398.9706,203.9854,1081.6190)) return true;
	    for(new i = 0; i < 9; i++)
	    {
			Skin[i] = Govskin[i][SkinID];
			count++;
	    }
	    ShowModelSelectionMenuEx(playerid, Skin, count, "Select skin", 6, 0.0, 0.0, 0.0);
	}
	return 1;
}
//============================================//
COMMAND:locker(playerid, params[])
{
	if(GetPVarInt(playerid, "Member") != 8) return true;
	if(!IsPlayerInRangeOfPoint(playerid, 2.0, 374.7547,200.2276,1081.5173)) return error(playerid, "You are not at the locker room");
	if(GetPVarInt(playerid, "Duty") != 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not on duty!");
	new result[1000];
	for(new i = 0; i < sizeof(GovItems); i++)
	{
	    if(i == 0)
		{
		    format(result, 1000, "%s | Rank: %d", PrintIName(GovItems[i][0]), GovItems[i][1]);
		}
		else
		{
		    format(result, 1000, "%s\n%s | Rank: %d", result, PrintIName(GovItems[i][0]), GovItems[i][1]);
		}
	}
	format(result, 1000, "%s\n{33FF66}Disarm", result);
	ShowPlayerDialog(playerid, 79, DIALOG_STYLE_LIST, "GOVERNMENT Armoury", result, "Select", "Close");
	return 1;
}
//============================================//
CMD:gethp(playerid, params[])
{
	new msg[128];
	new id, Float:h;
	if(sscanf(params, "u", id)) return usage(playerid, "/gethp [ID/Name]");
	if(GetPVarInt(playerid, "Admin") < 1) return nal(playerid);
	GetPlayerHealth(id, h);
 	format(msg, sizeof(msg), "INFO: %s - Health (%f)", PlayerName(id), h);
	SCM(playerid, COLOR_LIGHTRED, msg);
	return 1;
}
//============================================//
CMD:getarmour(playerid, params[])
{
	new msg[128];
	new id, Float:h;
	if(sscanf(params, "u", id)) return usage(playerid, "/getarmour [ID/Name]");
	if(GetPVarInt(playerid, "Admin") < 1) return nal(playerid);
	GetPlayerArmour(id, h);
 	format(msg, sizeof(msg), "INFO: %s - Armour (%f)", PlayerName(id), h);
	SCM(playerid, COLOR_LIGHTRED, msg);
	return 1;
}
//============================================//
COMMAND:buyclothes(playerid, params[])
{
    if(!IsPlayerInRangeOfPoint(playerid, 1.0, 204.3188,-160.1595,1000.5234) && !IsPlayerInRangeOfPoint(playerid, 1.0, 207.3639,-100.6654,1005.2578)) return error(playerid, "You aren't at the clothes shop.");
	ShowPlayerDialog(playerid, 409, DIALOG_STYLE_LIST, "Select option", "Buy attachments\nChange skin", "Select", "Cancel");
	return 1;
}
//============================================//
ALTCOMMAND:tp->takeprim;
COMMAND:takeprim(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") != 1) return true;
    if(GetPVarInt(playerid, "Delay") > GetCount()) return SendClientMessage(playerid, COLOR_LIGHTRED, "You must wait before performing this command!");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Control") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are currently frozen!");
    if(GetPVarInt(playerid, "ConnectTime") < 8) return scm(playerid, -1, "You need (8) hours played to use firearms!");

    SetPVarInt(playerid, "Delay", GetCount()+2000);
	if(PlayerInfo[playerid][pPlayerWeapon] != 0) {
	    SendClientMessage(playerid, COLOR_WHITE, "You already have a weapon equipped!");
	    return true;
	}	
	new foundid = -1, str2[128];
	if(PlayerInfo[playerid][pLastPrim] != -1) {
		if(GetWeaponType(PlayerInfo[playerid][pInvItem][PlayerInfo[playerid][pLastPrim]]) == WEAPON_TYPE_PRIMARY) {
			foundid = PlayerInfo[playerid][pLastPrim];
		} else { 
			PlayerInfo[playerid][pLastPrim] = -1;
			new query[73];
			mysql_format(handlesql, query, sizeof(query), "UPDATE accounts SET LastPrim=-1 WHERE Name='%s'", PlayerInfo[playerid][pLastPrim], PlayerInfo[playerid][pUsername]);
			mysql_tquery(handlesql, query);
		}
	}	
	if(foundid == -1) {
		for(new i = 0; i < MAX_INV_SLOTS; i++) {
			if(PlayerInfo[playerid][pInvItem][i] >= 25 && PlayerInfo[playerid][pInvItem][i] <= 34) {
				foundid = i;
				break;
			}
		}
	}
	if(foundid == -1) return error(playerid, "You have no primary weapon in your inventory.");
	PlayerInfo[playerid][pAmmoType]=PlayerInfo[playerid][pInvEx][foundid];
    GivePlayerWeaponEx(playerid, PlayerInfo[playerid][pInvItem][foundid], PlayerInfo[playerid][pInvQ][foundid]);
	PlayerInfo[playerid][pSerial] = PlayerInfo[playerid][pInvS][foundid];
    //==========//
    format(str2, 128, "%s equipped!", PrintIName(PlayerInfo[playerid][pInvItem][foundid]));
    SendClientMessage(playerid, COLOR_WHITE, str2);
    //==========//
	RemoveInvItem(playerid, PlayerInfo[playerid][pInvItem][foundid], 0, foundid);
    //==========//
    CallRemoteFunction("LoadHolsters","i",playerid);
    SetTimerEx("FixInv", 500, false, "i", playerid);
	return 1;
}
//============================================//
ALTCOMMAND:ts->takesec;
COMMAND:takesec(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") != 1) return true;
    if(GetPVarInt(playerid, "Delay") > GetCount()) return SendClientMessage(playerid, COLOR_LIGHTRED, "You must wait before performing this command!");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Control") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are currently frozen!");
    if(GetPVarInt(playerid, "ConnectTime") < 8) return scm(playerid, -1, "You need (8) hours played to use firearms!");
	
    SetPVarInt(playerid, "Delay", GetCount()+2000);
	if(PlayerInfo[playerid][pPlayerWeapon] != 0) {
	    SendClientMessage(playerid, COLOR_WHITE, "You already have a weapon equipped!");
	    return true;
	}	
	new foundid = -1, str2[128];
	if(PlayerInfo[playerid][pLastSec] != -1) {
		if(GetWeaponType(PlayerInfo[playerid][pInvItem][PlayerInfo[playerid][pLastSec]]) == WEAPON_TYPE_SECONDARY) {
			foundid = PlayerInfo[playerid][pLastSec];
		} else {
			PlayerInfo[playerid][pLastSec] = -1;
			new query[72];
			mysql_format(handlesql, query, sizeof(query), "UPDATE accounts SET LastSec=-1 WHERE Name='%s'", PlayerInfo[playerid][pUsername]);
			mysql_tquery(handlesql, query);		
		}
	}
	if(foundid == -1) {
		for(new i = 0; i < MAX_INV_SLOTS; i++) {
			if(PlayerInfo[playerid][pInvItem][i] >= 22 && PlayerInfo[playerid][pInvItem][i] <= 24) {
				foundid = i;
				break;
			}
		}
	}
	if(foundid == -1) return error(playerid, "You have no secondary weapon in your inventory.");
	ApplyAnimation(playerid, "SILENCED", "Silence_reload", 3.0, 0, 0, 0, 0, 0);
    PlayerInfo[playerid][pAmmoType]=PlayerInfo[playerid][pInvEx][foundid];
    GivePlayerWeaponEx(playerid, PlayerInfo[playerid][pInvItem][foundid], PlayerInfo[playerid][pInvQ][foundid]);
	PlayerInfo[playerid][pSerial] = PlayerInfo[playerid][pInvS][foundid];
    //==========//
    format(str2, 128, "%s equipped!", PrintIName(PlayerInfo[playerid][pInvItem][foundid]));
    SendClientMessage(playerid, COLOR_WHITE, str2);
    //==========//
	RemoveInvItem(playerid, PlayerInfo[playerid][pInvItem][foundid], 0, foundid);
    //==========//
    CallRemoteFunction("LoadHolsters","i",playerid);
    SetTimerEx("FixInv", 500, false, "i", playerid);
	return 1;
}
//============================================//
ALTCOMMAND:tm->takemelee;
COMMAND:takemelee(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") != 1) return true;
    if(GetPVarInt(playerid, "Delay") > GetCount()) return SendClientMessage(playerid, COLOR_LIGHTRED, "You must wait before performing this command!");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Control") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are currently frozen!");
    if(GetPVarInt(playerid, "ConnectTime") < 8) return scm(playerid, -1, "You need (8) hours played to use firearms!");
	
    SetPVarInt(playerid, "Delay", GetCount()+2000);
	if(PlayerInfo[playerid][pPlayerWeapon] != 0) {
	    SendClientMessage(playerid, COLOR_WHITE, "You already have a weapon equipped!");
	    return true;
	}	
	new foundid = -1, str2[128];
	if(PlayerInfo[playerid][pLastMelee] != -1) {
		if(GetWeaponType(PlayerInfo[playerid][pInvItem][PlayerInfo[playerid][pLastMelee]]) == WEAPON_TYPE_MELEE) {
			foundid = PlayerInfo[playerid][pLastMelee];
		} else {
			PlayerInfo[playerid][pLastMelee] = -1;
			new query[74];
			mysql_format(handlesql, query, sizeof(query), "UPDATE accounts SET LastMelee=-1 WHERE Name='%s'", PlayerInfo[playerid][pUsername]);
			mysql_tquery(handlesql, query);		
		}
	}
	if(foundid == -1) {
		for(new i = 0; i < MAX_INV_SLOTS; i++) {
			if(PlayerInfo[playerid][pInvItem][i] >= 1 && PlayerInfo[playerid][pInvItem][i] <= 15) {
				foundid = i;
				break;
			}
		}
	}
	if(foundid == -1) return error(playerid, "You have no melee weapon in your inventory.");
	PlayerInfo[playerid][pAmmoType]=PlayerInfo[playerid][pInvEx][foundid];
	GivePlayerWeaponEx(playerid, PlayerInfo[playerid][pInvItem][foundid], PlayerInfo[playerid][pInvQ][foundid]);
	PlayerInfo[playerid][pSerial] = PlayerInfo[playerid][pInvS][foundid];
	//==========//
	format(str2, 128, "%s equipped!", PrintIName(PlayerInfo[playerid][pInvItem][foundid]));
	SendClientMessage(playerid, COLOR_WHITE, str2);
	//==========//
	RemoveInvItem(playerid, PlayerInfo[playerid][pInvItem][foundid], 0, foundid);
	//==========//
    CallRemoteFunction("LoadHolsters","i",playerid);
    SetTimerEx("FixInv", 500, false, "i", playerid);
	return 1;
}
//============================================//
ALTCOMMAND:pg->putgun;
COMMAND:putgun(playerid, params[])
{
    if(GetPVarInt(playerid, "Delay") > GetCount()) return SendClientMessage(playerid, COLOR_LIGHTRED, "You must wait before performing this command!");
    if(GetPlayerPing(playerid) >= 500) return SendClientMessage(playerid, COLOR_WHITE, "Your ping is too high to do this command!");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Control") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are currently frozen!");
    if(GetPVarInt(playerid, "LSPD_Ta") == 1) return 1; // Block taser bug.
	if(PlayerInfo[playerid][pPlayerWeapon] == 0) return error(playerid, "You currently have no weapon equipped.");

	SetPVarInt(playerid, "Delay", GetCount()+2000);
    new str[128];
    if(CheckInv(playerid) == 1) {
        new sweapon, sammo, wep = PlayerInfo[playerid][pPlayerWeapon];
        for (new i = 0; i < 9; i++) {
            GetPlayerWeaponData(playerid, i, sweapon, sammo);
            if(sweapon == wep) {
                PlayerInfo[playerid][pPlayerAmmo]=sammo;
			}
		}
		if(wep >= 22 && wep <= 34)
		{
		    new amount = PlayerInfo[playerid][pPlayerAmmo], am = 0;
		    switch(wep)
		    {
		        case 22 .. 24: am=7;
		        case 25 .. 27: am=6;
		        case 28 .. 32: am=30;
		        case 33, 34: am=10;
		    }
		    if(amount > am)
		    {
		        switch(PlayerInfo[playerid][pAmmoType])
		        {
		    	    case 101: am=14;
		    	    case 107: am=14;
		    	    case 116: am=60;
		    	    case 126: am=80;
		    	    case 127: am=60;
		        }
			    amount = am;
			}
		    PlayerInfo[playerid][pPlayerAmmo]=amount;
		    if(PlayerInfo[playerid][pAmmoType] == 0) {
			PlayerInfo[playerid][pPlayerAmmo]=0; }
		}
		if(wep > 0 && wep < 16) PlayerInfo[playerid][pPlayerAmmo] = 1;
		new ammo = PlayerInfo[playerid][pPlayerAmmo], ammotype = PlayerInfo[playerid][pAmmoType], serial = PlayerInfo[playerid][pSerial];
		ResetPlayerWeaponsEx(playerid);
		new slot = GiveInvItem(playerid, wep, ammo, ammotype, serial);
		new query[84];
		switch(GetWeaponType(wep)) {
			case WEAPON_TYPE_PRIMARY: { 
				PlayerInfo[playerid][pLastPrim] = slot; 
				mysql_format(handlesql, query, sizeof(query), "UPDATE accounts SET LastPrim=%d WHERE Name='%s'", slot, PlayerInfo[playerid][pUsername]);
				mysql_tquery(handlesql, query);
			}
			case WEAPON_TYPE_SECONDARY: { 
				PlayerInfo[playerid][pLastSec] = slot; 
				mysql_format(handlesql, query, sizeof(query), "UPDATE accounts SET LastSec=%d WHERE Name='%s'", slot, PlayerInfo[playerid][pUsername]);
				mysql_tquery(handlesql, query);
			}
			case WEAPON_TYPE_MELEE: { 
				PlayerInfo[playerid][pLastMelee] = slot; 
				mysql_format(handlesql, query, sizeof(query), "UPDATE accounts SET LastMelee=%d WHERE Name='%s'", slot, PlayerInfo[playerid][pUsername]);
				mysql_tquery(handlesql, query);
			}
		}		
        format(str, 50, "%s stored into your inventory!", PrintIName(wep));
		SetPVarInt(playerid, "JustChosen", 0);
		CallRemoteFunction("LoadHolsters","i",playerid);
        SendClientMessage(playerid, COLOR_WHITE, str);
        RemovePlayerAttachedObject(playerid, 9);
    } else SendClientMessage(playerid, COLOR_WHITE, "Your inventory is currently full!");
	return 1;
}
//============================================//
COMMAND:maskid(playerid, params[])
{
	if(GetPVarInt(playerid, "Admin") < 1) return nal(playerid);
	new mask, query[255];
	if(sscanf(params, "d", mask)) return usage(playerid, "/maskid [Mask ID]");
	format(query, sizeof(query), "SELECT * FROM `accounts` WHERE MaskID = %d", mask);
	mysql_tquery(handlesql, query, "RetrieveMask", "dd",mask, playerid);
 	return 1;
}
//============================================//
COMMAND:makeadmin(playerid, params[])
{
	if(GetPVarInt(playerid, "Admin") < 9) return nal(playerid);
	new id, lvl, str[128];
	if(sscanf(params, "ud", id, lvl)) return usage(playerid, "/makeadmin [Player] [Level]");
	if(GetPVarInt(playerid, "Admin") < GetPVarInt(id, "Admin")) return nal(playerid);
	if(GetPVarInt(playerid, "Admin") < lvl) return nal(playerid);
	if(lvl < 0 || lvl > 10) return error(playerid, "Invalid admin lvl.");
	SetPVarInt(id, "Admin", lvl);
	format(str, sizeof(str), "You have set (%s) to admin level (%d).", PlayerName(id), lvl);
	SCM(playerid, -1, str);
	return 1;
}
//============================================//
COMMAND:makehelper(playerid, params[])
{
	if(GetPVarInt(playerid, "Helper") < 2 && GetPVarInt(playerid, "Admin") < 10) return nal(playerid);
	new id, lvl, str[128];
	if(sscanf(params, "ud", id, lvl)) return usage(playerid, "/makehelper [Player] [Level]");
	if(lvl < 0 || lvl > 2) return error(playerid, "Invalid helper lvl.");
	SetPVarInt(id, "Helper", lvl);
	format(str, sizeof(str), "You have set (%s) to helper level (%d).", PlayerName(id), lvl);
	SCM(playerid, -1, str);
	OnPlayerDataSave(id);
	return 1;
}
//============================================//
COMMAND:makereg(playerid, params[])
{
	if(GetPVarInt(playerid, "Reg") < 2 && GetPVarInt(playerid, "Admin") < 10) return nal(playerid);
	new id, lvl, str[128];
	if(sscanf(params, "ud", id, lvl)) return usage(playerid, "/makereg [Player] [Level]");
	if(lvl < 0 || lvl > 2) return error(playerid, "Invalid reg lvl.");
	SetPVarInt(id, "Reg", lvl);
	format(str, sizeof(str), "You have set (%s) to reg level (%d).", PlayerName(id), lvl);
	SCM(playerid, -1, str);
	OnPlayerDataSave(id);
	return 1;
}
//============================================//
COMMAND:jailacc(playerid, params[])
{
	if(GetPVarInt(playerid, "Admin") < 1) return SendClientMessage(playerid, -1, "You are not allowed to use this command.");
	new id[25], time, reason[128], string[255];
	if(sscanf(params, "s[25]is[128](No reason Given)", id, time, reason)) return usage(playerid, "/jailacc [Player Name] [Minutes] [Reason]");
	if(time < 1) return error(playerid, "You can not jail for negative minutes.");
	format(string, sizeof(string), "AdmCmd: %s was offline jailed by Admin %s Reason:[%s].", id, AdminName(playerid), reason);
	SendClientMessageToAllEx(COLOR_LIGHTRED, string);
	new query[255], date[30], day, year, month;
	getdate(year, month, day);
	format(date, sizeof(date), "%d-%d-%d", year, month, day);
	format(query, sizeof(query), "INSERT INTO `logs_adminjails`(`Name`, `Admin`, `Reason`, `Minutes`, `Date`) VALUES ('%s','%s','%s',%i,'%s')",
	id, AdminName(playerid), reason, time * 60, date);
	mysql_tquery(handlesql, query);
	format(query, sizeof(query), "UPDATE accounts SET Jailed=1, Jailtime=%d WHERE Name='%s'", time * 60, id);
	mysql_tquery(handlesql, query);
	return 1;
}
//============================================//
COMMAND:cad(playerid, params[])
{
	new text[128],string[255],sendername[MAX_PLAYER_NAME];
	if(sscanf(params, "s[128]", text)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /cad [Advertisement]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(!IsPlayerInRangeOfPoint(playerid,4.0,1579.0818,-845.3063,879.9098)) return SendClientMessage(playerid, COLOR_GREY, "You are not at SAN studio.");
	    new price = 0;
	    if(GetPVarInt(playerid, "DonateRank") == 0) price = strlen(text) * 20;
	    if(GetPVarInt(playerid, "Ad") == 1) return SendClientMessage(playerid, COLOR_GREY, "You already requested a advertisement.");
	    if (!CheckInvItem(playerid, 405)) return SendClientMessage(playerid, COLOR_WHITE, "You don't have a cellphone.");
	    if(GetPlayerMoneyEx(playerid) >= price)
	    {
	        format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
      	    GiveNameSpace(sendername);
	        format(PlayerInfo[playerid][pAdText], sizeof(string), "AD: %s",  text);
	        format(string, sizeof(string), "AD: %s[%i] is trying to co-advertise something! '%s'.", sendername, playerid, text);
            SendAdminMessage(COLOR_LIGHTRED,string);
            SendHelperMessage(COLOR_LIGHTRED,string);
            format(string, sizeof(string), "AD: Use /approvead %i to approve, or type /denyad %i <reason>.",  playerid, playerid);
            SendAdminMessage(COLOR_LIGHTRED,string);
            SendHelperMessage(COLOR_LIGHTRED,string);
            SendClientMessage(playerid, COLOR_LIGHTBLUE, "Your company advertisement has been submitted and is waiting approvalby a helper or admin.");
            SetPVarInt(playerid, "Ad", 1);
            SetPVarInt(playerid, "AdPrice", price);
        }
        else SendClientMessage(playerid, COLOR_LIGHTRED, "Insufficient funds!");
	}
	return 1;
}
//============================================//
COMMAND:ad(playerid, params[])
{
	new text[128],string[255],sendername[MAX_PLAYER_NAME];
	if(sscanf(params, "s[128]", text)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /ad [Advertisement]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(!IsPlayerInRangeOfPoint(playerid,4.0,1579.0818,-845.3063,879.9098)) return SendClientMessage(playerid, COLOR_GREY, "You are not at SAN studio.");
	    new price = 0;
	    if(GetPVarInt(playerid, "DonateRank") == 0) price = strlen(text) * 10;
	    if(GetPVarInt(playerid, "Ad") == 1) return SendClientMessage(playerid, COLOR_GREY, "You already requested a advertisement.");
	    if (!CheckInvItem(playerid, 405)) return SendClientMessage(playerid, COLOR_WHITE, "You don't have a cellphone.");
	    if(GetPlayerMoneyEx(playerid) >= price)
	    {
	        format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
      	    GiveNameSpace(sendername);
	        format(PlayerInfo[playerid][pAdText], sizeof(string), "%s [Contact]: %s [Phone]: %d",  text, sendername, GetPVarInt(playerid, "PhoneNum"));
	        format(string, sizeof(string), "AD: %s[%i] is trying to advertise something! '%s'.", sendername, playerid, PlayerInfo[playerid][pAdText]);
            SendAdminMessage(COLOR_LIGHTRED,string);
            SendHelperMessage(COLOR_LIGHTRED,string);
            format(string, sizeof(string), "AD: Use /approvead %i to approve, or type /denyad %i <reason>.",  playerid, playerid);
            SendAdminMessage(COLOR_LIGHTRED,string);
            SendHelperMessage(COLOR_LIGHTRED,string);
            SendClientMessage(playerid, COLOR_LIGHTBLUE, "Your advertisement has been submitted and is waiting approvalby a helper or admin.");
            SetPVarInt(playerid, "Ad", 1);
            SetPVarInt(playerid, "AdPrice", price);
        }
        else SendClientMessage(playerid, COLOR_LIGHTRED, "Insufficient funds!");
	}
	return 1;
}
//============================================//
COMMAND:checkad(playerid, params[])
{
	new string[128];
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Helper") >= 1 || GetPVarInt(playerid, "Admin") >= 1)
	{
	    foreach(new i : Player)
	    {
	        if(GetPVarInt(i, "PlayerLogged") == 1)
	        {
	            if(GetPVarInt(i, "Ad") == 1)
	            {
	                format(string, sizeof(string),"AD: %s[%i]: %s",PlayerName(i),i,PlayerInfo[i][pAdText]);
	                SendClientMessage(playerid,COLOR_LIGHTRED,string);
	            }
	        }
	    }
    }
    else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	return 1;
}
//============================================//
COMMAND:approvead(playerid, params[])
{
	new targetid,string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "u", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /approvead [playerid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
	    if(GetPVarInt(targetid, "Ad") != 1) return SendClientMessage(playerid, COLOR_GREY, "This player does not have a pending ad.");
		if(GetPVarInt(playerid, "Admin") >= 1 || GetPVarInt(playerid, "Helper") >= 1)
		{
   			format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
      		format(giveplayer, sizeof(giveplayer), "%s", PlayerName(targetid));
      		GiveNameSpace(sendername);
      		GiveNameSpace(giveplayer);
      		format(string, sizeof(string), "AD: The advertisement by %s was approved by %s.", giveplayer,sendername);
			SendAdminMessage(COLOR_LIGHTBLUE,string);
      		SetPVarInt(targetid, "Ad", 0);
      		GivePlayerMoneyEx(targetid,-GetPVarInt(targetid, "AdPrice"));
      		SetPVarInt(targetid, "AdPrice", 0);
      		SendClientMessage(targetid,COLOR_GREEN,"Your advertisement has been placed on the newspaper.");
      		LoadAdText(PlayerInfo[targetid][pAdText]);
	        SendClientMessageToAllEx(COLOR_GREEN, PlayerInfo[targetid][pAdText]);
		}
		else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
COMMAND:denyad(playerid, params[])
{
	new targetid,reason[128],string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "us[128]", targetid, reason)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /denyad [playerid] [reason]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
	    if(GetPVarInt(targetid, "Ad") != 1) return SendClientMessage(playerid, COLOR_GREY, "This player does not have a pending ad.");
		if(GetPVarInt(playerid, "Admin") >= 1 || GetPVarInt(playerid, "Helper") >= 1)
		{
   			format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
      		format(giveplayer, sizeof(giveplayer), "%s", PlayerName(targetid));
      		GiveNameSpace(sendername);
      		GiveNameSpace(giveplayer);
      		format(string, sizeof(string), "AD: your advertisement was denied for: %s.",  reason);
			SendClientMessage(targetid, COLOR_LIGHTBLUE, string);
			format(string, sizeof(string), "AD: The advertisement by %s was denied by %s for: %s.",giveplayer, sendername, reason);
			SendAdminMessage(COLOR_LIGHTBLUE,string);
      		SetPVarInt(targetid, "Ad", 0);
		}
		else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
ALTCOMMAND:np->newspaper;
COMMAND:newspaper(playerid, params[])
{
    new amount = 0;
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    for(new i = 0; i < 7; i++)
    {
		if(Ad[i] == 1)
		{
		    amount++;
			if(amount == 1) { SendClientMessage(playerid,COLOR_WHITE,"|_____ Newspaper Ads _____|"); }
		    SendClientMessage(playerid,COLOR_LIGHTRED,AdT[i]);
		}
	}
	if(amount == 0) return SendClientMessage(playerid,COLOR_GREY,"There is no information on the news paper.");
	SendClientMessage(playerid,COLOR_WHITE,"|_________________________|");
	return 1;
}
//============================================//
COMMAND:floor(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Control") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are currently frozen!");
    if(IsPlayerInRangeOfPoint(playerid,2.0,2038.4750,-1365.0499,1271.5000) || IsPlayerInRangeOfPoint(playerid,2.0,2055.4756,-673.1822,1478.8860) || IsPlayerInRangeOfPoint(playerid,2.0,1994.9702,-1534.0613,1174.6000))
    {
        ShowPlayerDialog(playerid,54,DIALOG_STYLE_LIST,"Hosptial Floors","Main Floor\nSecond Floor\nThird Floor","Select", "");
    }
    else SendClientMessage(playerid, COLOR_GREY, "You are not around the hospital!");
	return 1;
}
//============================================//

COMMAND:createbiz(playerid, params[])
{
	if(GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	if(GetPVarInt(playerid, "Admin") < 9) return nal(playerid);
	new houseid, price, Float:X, Float:Y, Float:Z, UID, text[128], biname[50], msg[255], query[500];
	if(sscanf(params,"iis",houseid, price,biname)) return usage(playerid, "/createbiz [BizzID][Value][Name] - (Check /bizzes for a list of house IDs)");
	if(houseid < 0 || houseid > sizeof(BizCor)) return error(playerid, "Invalid bizz ID.");
	for(new i=1; i < MAX_BUSINESSES; i++) {
		if(BizInfo[i][ID] == 0) {
		    UID = i;
			format(text, sizeof(text), "Business id is %d", UID);
			SendClientMessage(playerid, -1, text);
			break;
		}
	}
	BizInfo[UID][ID] = UID;
	BizInfo[UID][Value] = price;
	format(BizInfo[UID][Name], 40, "%s", biname);
	format(BizInfo[UID][Owner],11, "For Sale");
	format(BizInfo[UID][Slogan], 20, "Default Slogan");
	BizInfo[UID][IntOut] = GetPlayerInterior(playerid);
	GetPlayerPos(playerid, X, Y, Z);
	BizInfo[UID][Xo] = X;
	BizInfo[UID][Yo] = Y;
	BizInfo[UID][Zo] = Z;
	BizInfo[UID][Products] = 50;
	BizInfo[UID][Icon]=CreateDynamicPickup(1272, 1, BizInfo[UID][Xo], BizInfo[UID][Yo], BizInfo[UID][Zo]);
	BizInfo[UID][Xi] = BizCor[houseid][bbX];
	BizInfo[UID][Yi] = BizCor[houseid][bbY];
	BizInfo[UID][Zi] = BizCor[houseid][bbZ];
	BizInfo[UID][IntIn] = BizCor[houseid][Bizint];
	format(msg, sizeof(msg), "[%s]",BizInfo[UID][Name]);
	BizInfo[UID][Text] = Create3DTextLabel(msg, 0x008080FF, BizInfo[UID][Xo], BizInfo[UID][Yo], BizInfo[UID][Zo] + 0.5, 0, 0);
	format(msg, 128, "INFO: Business (%d) has been created.", UID);
	SCM(playerid, -1, msg);
	format(query, sizeof(query), "INSERT INTO `business`(`ID`, `Xo`, `Yo`, `Zo`, `Xi`, `Yi`, `Zi`, `IntIn`, `IntOut`, `Owned`, `Owner`, `Value`, `Locked`, `Slogan`, `Products`, `EnterPrice`, `Name`) VALUES (%d,%f,%f,%f,%f,%f,%f,%d,%d,%d,'%s',%d,%d,'%s',%d,%d,'%s')",
	UID, X, Y, Z, BizInfo[UID][Xi],BizInfo[UID][Yi],BizInfo[UID][Zi],BizInfo[UID][IntIn],BizInfo[UID][IntOut],BizInfo[UID][Owned],BizInfo[UID][Owner],
	BizInfo[UID][Value],BizInfo[UID][Locked],BizInfo[UID][Slogan],BizInfo[UID][Products],BizInfo[UID][EnterPrice],BizInfo[UID][Name]);
	mysql_tquery(handlesql, query);
	printf("Business %d created", UID);
	Iter_Add(BizIterator, UID);
	return 1;
}
//============================================//
ALTCOMMAND:biztypes->bizzes;
COMMAND:bizzes(playerid, params[])
{
	if(GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	if(GetPVarInt(playerid, "Admin") < 9) return nal(playerid);
	new msg[128];
	SCM(playerid, -1, "_________________________________________________________________");
	for(new i=0; i < sizeof(BizCor); i++)
	{
	    format(msg, sizeof(msg), "ID (%d) - Name (%s)", i, BizCor[i][Bizzname]);
		SCM(playerid, -1, msg);
	}
	return 1;
}
//============================================//
COMMAND:biz(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") != 1) return true;
	new string[128], param[64], amount, amount2;
	if(sscanf(params, "s[64]I(-1)I(-1)", param, amount, amount2)) {
		scm(playerid, COLOR_GREEN, "/biz [usage]");
		scm(playerid, COLOR_GREY, "  lock | sell | name | slogan | fee | bank |");
		scm(playerid, COLOR_GREY, "  backdoor | radio | sellto | request | plant | edit | select |");
		scm(playerid, COLOR_GREY, "  removeall | setexit | setcp | bareswitch | type |");
		scm(playerid, COLOR_GREY, "  rights | bank | deposit | withdraw | inventory | furn |");
		scm(playerid, COLOR_GREY, "Safe control: /safe");
		return 1;
	}
  	if(strcmp(param, "lock", true) == 0)
  	{
		new id = GetPVarInt(playerid, "BizzKey");
		if(id == 0) return error(playerid, "You do not own a property.");
		if(!IsPlayerInRangeOfPoint(playerid, 2.0, BizInfo[id][Xo], BizInfo[id][Yo], BizInfo[id][Zo]) && 
			!IsPlayerInRangeOfPoint(playerid, 5.0, BizInfo[id][Xi], BizInfo[id][Yi], BizInfo[id][Zi]) &&
			!IsPlayerInRangeOfPoint(playerid, 5.0, BizInfo[id][bbdXi], BizInfo[id][bbdYi], BizInfo[id][bbdZi]) &&
			!IsPlayerInRangeOfPoint(playerid, 2.0, BizInfo[id][bbdXo], BizInfo[id][bbdYo], BizInfo[id][bbdZo])) return error(playerid, "You are not near your business door.");
		if(BizInfo[id][Locked] == 1) //Locked
		{
			PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
	 		GameTextForPlayer(playerid, "~w~Business~n~~g~Unlocked", 4000, 3);
	 		BizInfo[id][Locked] = 0;
		}
		else //Unlocked
		{
			PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
	  		GameTextForPlayer(playerid, "~w~Business~n~~r~Locked", 4000, 3);
	  		BizInfo[id][Locked] = 1;
		}
		SaveBiz(id);
		return 1;
	}
	else if(strcmp(param, "sell", true) == 0)
  	{
		new id = GetPVarInt(playerid, "BizzKey");
		if(GetPVarInt(playerid, "BizzKey") == 0) return error(playerid, "You do not own a property.");
		if(!IsPlayerInRangeOfPoint(playerid, 2.0, BizInfo[id][Xo], BizInfo[id][Yo], BizInfo[id][Zo])) return error(playerid, "You are not near your business door.");
		GivePlayerMoneyEx(playerid, BizInfo[id][Value]);
		SetPVarInt(playerid, "BizzKey", 0);
		BizInfo[id][Owned] = 0;
		format(BizInfo[id][Owner], 128, "None");
		SCM(playerid, -1, "Property sold.");
		SaveBiz(id);
		OnPlayerDataSave(playerid);
		return 1;
	}
	else if(strcmp(param, "name", true) == 0)
	{
		new id = GetPVarInt(playerid, "BizzKey");
		if(id == 0) return error(playerid, "You do not own a property.");
	    ShowPlayerDialog(playerid, 303, DIALOG_STYLE_INPUT, "Business", "Insert your business name (10 chars max.)", "Submit","Cancel");
	}
	else if(strcmp(param, "slogan", true) == 0)
	{
		new id = GetPVarInt(playerid, "BizzKey");
		if(id == 0) return error(playerid, "You do not own a property.");
	    ShowPlayerDialog(playerid, 301, DIALOG_STYLE_INPUT, "Business", "Insert your business slogan (80 chars max.)", "Submit","Cancel");
	}
	else if(strcmp(param, "fee", true) == 0)
	{
		new id = GetPVarInt(playerid, "BizzKey");
		if(id == 0) return error(playerid, "You do not own a property.");
	    ShowPlayerDialog(playerid, 302, DIALOG_STYLE_INPUT, "Business", "Insert your business enter-fee (1 - 100)", "Submit","Cancel");
	}
	else if(strcmp(param, "radio", true) == 0)
   	{
   	    if(GetPVarInt(playerid, "BizzKey") == 0) return error(playerid, "You do not own a property.");
   	    if (GetPVarInt(playerid, "BizzEnter") == GetPVarInt(playerid, "BizzKey"))
   	    {
   	        ShowPlayerDialog(playerid,55,DIALOG_STYLE_LIST,"Business Radio","Radio Stations\nDirect URL\nTurn Off","Select", "Exit");
   	    }
   	    else SendClientMessage(playerid,COLOR_GREY,"You are not inside your business.");
   	}
   	else if(strcmp(param, "sellto", true) == 0)
    {
        if(GetPVarInt(playerid, "ConnectTime") < 8) return SendClientMessage(playerid, COLOR_GREY, "You need 8 hours played to use this command.");
        if(GetPVarInt(playerid, "BizzKey") == 0) return SendClientMessage(playerid, COLOR_GREY, "You don't own a businesss.");
	    new key = GetPVarInt(playerid, "BizzKey");
	    if(strcmp(BizInfo[key][Owner], PlayerName(playerid), true) == 0)
	    {
	        if(BizInfo[key][Value] <= 9999) return SendClientMessage(playerid, COLOR_GREY, "You can't sell a donate business.");
	        if(amount == (-1)) return SendClientMessage(playerid, COLOR_GREEN, "USAGE: /biz sellto {FFFFFF}[playerid] [amount]");
	        if(amount2 == (-1)) return SendClientMessage(playerid, COLOR_GREEN, "USAGE: /biz sellto {FFFFFF}[playerid] [amount]");
	        new val = BizInfo[key][Value]-10000;
	        if(amount2 < val || amount2 > 500000)
	        {
	            format(string, sizeof(string),"Cannot go under %d or above 500000.", val);
				SendClientMessage(playerid, COLOR_GREY, string);
				return true;
			}
	        if (!IsPlayerConnected(amount)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
	        if(PlayerToPlayer(playerid,amount,5.0))
	        {
			    if(GetPVarInt(amount, "BizzKey") != 0) SendClientMessage(playerid, COLOR_GREY, "This player is currently owns or rents at a Bizz.");
	            format(string, sizeof(string),"You offered %s to purchase your business for $%d.", PlayerName(amount), amount2);
				SendClientMessage(playerid,COLOR_LIGHTRED,string);
				format(string, sizeof(string),"%s offered you to purchase his business for $%d (/accept bsellto).", PlayerName(playerid), amount2);
				SendClientMessage(amount,COLOR_LIGHTRED,string);
				SetPVarInt(amount, "BizzOffer", playerid);
				SetPVarInt(amount, "BizzOfferPrice", amount2);
	        }
	        else SendClientMessage(playerid,COLOR_GREY,"You are not close enough to that player!");
	    }
    }
  	else if(strcmp(param, "inventory", true) == 0)
  	{
		new key = GetPVarInt(playerid, "BizzEnter");
		if(!GetCloseBizzSafe(playerid, key)) return error(playerid, "You are not near a biz-safe. (/biz plantsafe)");
		if(BizInfo[key][sLocked] == 1) return error(playerid, "This business's safe(s) are locked! (/safe unlock)");
		PrintBizInv(playerid);
		return 1;
	}
    else if(strcmp(param, "request", true) == 0)
    {
        if(GetPVarInt(playerid, "BizzKey") == 0) return SendClientMessage(playerid, COLOR_GREY, "You don't own a business.");
	    new key = GetPVarInt(playerid, "BizzKey"), bizp = 1000;
	    if(BizInfo[key][bProd] >= 1) return SendClientMessage(playerid, COLOR_GREY, "You still have product(s) in your business!");
	    if(BizInfo[key][bReq] != 0) return SendClientMessage(playerid, COLOR_GREY, "Your request is still pending!");
	    if(GetPlayerMoneyEx(playerid) >= bizp)
	    {
			GivePlayerMoneyEx(playerid, -bizp);
			PlayerPlaySound(playerid,1054, 0.0, 0.0, 0.0);
		    format(string, sizeof(string),"~r~-$%d", bizp);
		    GameTextForPlayer(playerid, string, 5000, 1);
	        BizInfo[key][bReq]=1;
	        SendClientMessage(playerid, COLOR_WHITE, "You have requested products for your business!");
	        SendClientMessage(playerid, COLOR_WHITE, "All truckers online have been informed.");
	        format(string, sizeof(string), "The '%s' is requesting products!", BizInfo[key][Name]);
		    SendJobMessageEx(6,COLOR_LIGHTBLUE,string);
		}
		else SendClientMessage(playerid, COLOR_LIGHTRED, "Insufficient funds!");
    }
    else if(strcmp(param, "plant", true) == 0)
	{
		new allow = FurnRight(playerid, 2);
	    if(allow > 0) {
	        if(GetPlayerInterior(playerid) == 0 && GetPlayerVirtualWorld(playerid) == 0) {
				if(outdoor_furn == 0) return SendClientMessage(playerid, COLOR_RED, "Outdoor furniture is currently disabled!");

		    	if(GetBizzOutdoorObjects(allow) >= BUSINESS_OUTDOOR_OBJECTS) {
		    		scm(playerid, -1, "You can only plant up to 20 objects outdoors.");
		    		return 1;
		    	}
		    }
	        if(amount == (-1)) {
                ShowModelSelectionMenuEx(playerid, FurnObjs, sizeof(FurnObjs), "Furniture List", 8, 16.0, 0.0, -55.0);
            } else {
                if(amount < 320 || amount > 35000) return scm(playerid, -1, "Invalid Object ID!");
				if(GetPlayerInterior(playerid) == 0 && GetPlayerVirtualWorld(playerid) == 0 && IsInvalidObjectID(amount)) return scm(playerid, -1, "This is not a valid outdoor furniture object!");
                new foundid = -1;
                for(new i = 0; i < MAX_OBJECT_ARRAY; i++) {
					if(ObjectList[i][oID] == amount) {
						foundid=i;
						break;
					}
                }
                if(foundid == -1) return scm(playerid, -1, "Invalid Object ID!");
                new Float:X, Float:Y, Float:Z, obj = 0;
		        GetPlayerPos(playerid, X, Y, Z);
		        obj = CreatePlayerObject(playerid, amount, X+1.0, Y+1.0, Z, 0.0, 0.0, 0.0, 100.0);
		        SetPVarInt(playerid, "FurnObject", obj);
		        SetPVarInt(playerid, "EditorMode", 3);
		        SetPVarInt(playerid, "Mute", 1);
		        PlayerInfo[playerid][pFurnID]=amount;
		        EditPlayerObject(playerid, obj);
		        format(string, sizeof(string),"%s selected, use the SPRINT key to navigate.", ObjectList[foundid][oName]);
		        SendClientMessage(playerid, COLOR_WHITE, string);
            }
	    }
	}
	else if(strcmp(param, "edit", true) == 0)
	{
	    if(FurnRightEx(playerid, 2)){ GetCloseBizzObject(playerid, FurnRight(playerid, 2)); }
	}
	else if(strcmp(param, "removeall", true) == 0)
	{
	    if(FurnRightEx(playerid, 2)) {
			ShowPlayerDialog(playerid, DIALOG_BUSINESS_REMOVEALL, DIALOG_STYLE_MSGBOX, "Remove all furniture objects", "Are you sure you want to remove all of your current business furniture objects?", "Yes", "No");
		} else SendClientMessage(playerid, COLOR_GREY, "You don't have permission to furnish this business.");
	}
	else if(strcmp(param, "setexit", true) == 0)
	{
	    if(!FurnRightEx(playerid, 2)) return SendClientMessage(playerid, COLOR_GREY, "You don't have rights to this business.");
		new key = FurnRight(playerid, 2);	
		if(GetPlayerVirtualWorld(playerid) != key) return SendClientMessage(playerid, COLOR_GREY, "You have to be in a business to use this command!");
      	new Float:x,Float:y,Float:z;
		GetPlayerPos(playerid,x,y,z);
      	SendClientMessage(playerid, COLOR_LIGHTBLUE, "WARNING: You've moved the business' exit to your current position.");
      	BizInfo[key][Xi] = x;
		BizInfo[key][Yi] = y;
		BizInfo[key][Zi] = z;
		BizInfo[key][IntIn] = GetPlayerInterior(playerid);
		SaveBiz(key);
		DestroyDynamicPickup(BizInfo[key][bExit]);
		BizInfo[key][bExit] = CreateDynamicPickup(1318, 1, BizInfo[key][Xi], BizInfo[key][Yi], BizInfo[key][Zi], key, BizInfo[key][IntIn]);
	}
	else if(strcmp(param, "setcp", true) == 0)
	{
	    if(FurnRightEx(playerid, 2)) {
		    if(BizInfo[FurnRight(playerid, 2)][UD] >= 4) return scm(playerid, -1, "You cannot access this command for a few minutes to avoid abuse.");
		    ShowPlayerDialog(playerid, 447, DIALOG_STYLE_MSGBOX, "Business Checkpoint", "Would you like to move the bizz checkpoint?\n{CC0000}Abusing this command will result in a ban/business confiscation!", "Continue", "Cancel");
		}
		else scm(playerid, COLOR_GREY, "You don't have rights to this business.");
	}
	else if(strcmp(param, "bareswitch", true) == 0)
	{
	    new key = GetPVarInt(playerid, "BizzKey");
		if(key == 0) return error(playerid, "You do not own a property.");
	    if(BizInfo[key][UD] >= 4)
        {
            scm(playerid, -1, "You cannot access this command for a few minutes to avoid abuse.");
            return 1;
        }
	    if(strcmp(BizInfo[key][Owner], PlayerName(playerid), true) == 0)
	    {
			ShowPlayerDialog(playerid, 514, DIALOG_STYLE_MSGBOX, "Are you sure?", "By bare-switching this business all your objects will be removed, it will be switched to an empty interior\nand you won't beable to recover your old furniture/interior.\nAre you sure you want to do this?\n   ---------\n{33FF66}Cost: {FFFFFF}$2500", "Yes", "No");
		}
	}
	else if(strcmp(param, "type", true) == 0)
    {
        if(GetPVarInt(playerid, "BizzKey") == 0) return SendClientMessage(playerid, COLOR_GREY, "You don't own a businesss.");
	    new key = GetPVarInt(playerid, "BizzKey");
	    if(BizInfo[key][UD] >= 4)
        {
            scm(playerid, -1, "You cannot access this command for a few minutes to avoid abuse.");
            return 1;
        }
	    if(strcmp(BizInfo[key][Owner], PlayerName(playerid), true) == 0)
	    {
	        if(amount == (-1)) {
			    SendClientMessage(playerid, COLOR_WHITE, "USAGE: /biz type [0-4]");
                SendClientMessage(playerid, COLOR_GREY, "0: None | 1: Bar");
                SendClientMessage(playerid, COLOR_GREY, "2: 24/7 | 3: Warehouse");
                SendClientMessage(playerid, COLOR_GREY, "4: Gym");
                return 1;
			}
			if(amount < 0 || amount > 5) return SendClientMessage(playerid, COLOR_GREY, "Cannot go under 0 or above 5.");
			format(string, 128, "Business Type set to %d.", amount);
			scm(playerid, -1, string);
			BizInfo[key][cT]=amount;
			scm(playerid, COLOR_LIGHTRED, "This will only work when a custom CP position has been set!");
			BizInfo[key][UD]++;
			SaveBiz(key);
	    }
	    else scm(playerid, -1, "Insufficient permission!");
    }
    else if(strcmp(param, "rights", true) == 0)
    {
        if(GetPVarInt(playerid, "BizzKey") == 0) return SendClientMessage(playerid, COLOR_GREY, "You don't own a businesss.");
	    new key = GetPVarInt(playerid, "BizzKey");
	    if(strcmp(BizInfo[key][Owner], PlayerName(playerid), true) == 0)
	    {
	        if(amount == (-1)) {
			    SendClientMessage(playerid, COLOR_WHITE, "USAGE: /biz rights {FFFFFF}[playerid]");
			    SendClientMessage(playerid, COLOR_GREY, "If you select playerid as 501 the furn rights will disable.");
			    return 1;
			}
			if(amount == 501) {
			    strmid(BizInfo[key][FurnR], "None", 0, strlen("None"), 255);
			    scm(playerid, -1, "Business furnishing rights are disabled!");
			    SaveBiz(key);
			    return true;
			}
	        if (!IsPlayerConnected(amount)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
	        if(amount == playerid) return scm(playerid, -1, "You can't give yourself furnish rights!");
	        if(PlayerToPlayer(playerid,amount,5.0))
	        {
	            format(string, 128, "You have given %s permission to furnish your business!", PlayerName(amount));
	            scm(playerid, -1, string);
	            format(string, 128, "%s has given you permission to furnish their business!", PlayerName(playerid));
	            scm(amount, -1, string);
	            strmid(BizInfo[key][FurnR], PlayerName(amount), 0, strlen(PlayerName(amount)), 255);
	            SaveBiz(key);
	        }
	        else SendClientMessage(playerid,COLOR_GREY,"You are not close enough to that player!");
	    }
	    else scm(playerid, -1, "Insufficient permission!");
    }
	else if(strcmp(param, "plantsafe", true) == 0) 
	{
		new id = FurnRight(playerid, 2);
		if(id < 1) return error(playerid, "You don't have permission to place furniture in this business.");
		if(GetPVarInt(playerid, "BizzEnter") != id) return error(playerid, "You must be inside your business to plant a safe.");
		cmd_biz(playerid, "plant 2332");
	}
    else if(strcmp(param, "bank", true) == 0)
  	{
		new id = GetPVarInt(playerid, "BizzEnter");
		if(!GetCloseBizzSafe(playerid, id)) return error(playerid, "You aren't near a business safe.");
		if(BizInfo[id][sLocked] == 1) return error(playerid, "This business' safe(s) are locked! (/safe unlock)");
		new msg[128];
		format(msg, sizeof(msg), "INFO: %s (Bank: $%d)", BizInfo[id][Name], BizInfo[id][Bank]);
		SCM(playerid, -1, msg);
		return 1;
	}
	else if(strcmp(param, "deposit", true) == 0)
  	{
		new id = GetPVarInt(playerid, "BizzEnter");
		if(!GetCloseBizzSafe(playerid, id)) return error(playerid, "You aren't near a business safe.");
		if(BizInfo[id][sLocked] == 1) return error(playerid, "This business' safe(s) are locked! (/safe unlock)");
		if(amount == (-1)) return scm(playerid, COLOR_GREEN, "USAGE: /biz deposit {FFFFFF} [amount]");
		if(amount <= 0) return scm(playerid, COLOR_GREEN, "USAGE: /biz deposit {FFFFFF} [amount]");
		if(amount >= 99999999) return scm(playerid, COLOR_GREEN, "USAGE: /biz deposit {FFFFFF} [amount]");
		if(GetPlayerMoneyEx(playerid) >= amount)
		{
			GivePlayerMoneyEx(playerid, -amount);
			BizInfo[id][Bank]+=amount;
			format(string, 128, "$%d added to your business bank!", amount);
			SCM(playerid, -1, string);
			SaveBiz(id);
			OnPlayerDataSave(playerid);
		}
		else scm(playerid, -1, "You don't have this much cash on you!");
		return 1;
	}
	else if(strcmp(param, "withdraw", true) == 0)
  	{
		new id = GetPVarInt(playerid, "BizzEnter");
		if(!GetCloseBizzSafe(playerid, id)) return error(playerid, "You aren't near a business safe.");
		if(BizInfo[id][sLocked] == 1) return error(playerid, "This business' safe(s) are locked! (/safe unlock)");
		if(amount == (-1)) return scm(playerid, COLOR_GREEN, "USAGE: /biz withdraw {FFFFFF} [amount]");
		if(amount <= 0) return scm(playerid, COLOR_GREEN, "USAGE: /biz withdraw {FFFFFF} [amount]");
		if(amount >= 99999999) return scm(playerid, COLOR_GREEN, "USAGE: /biz withdraw {FFFFFF} [amount]");
		if(BizInfo[id][Bank] <= 0) return scm(playerid, -1, "There is no cash in your business bank.");
		if(BizInfo[id][Bank] >= amount)
		{
			format(string, 128, "%s (Withdrawn - $%d)", BizInfo[id][Name], amount);
			SCM(playerid, -1, string);
			GivePlayerMoneyEx(playerid, amount);
			BizInfo[id][Bank]-=amount;
			SaveBiz(id);
			OnPlayerDataSave(playerid);
		}
		else scm(playerid, -1, "You don't have this much cash in your bank!");
		return 1;
	}
	else if(strcmp(param, "furn", true) == 0)
  	{
		GetAllBizzFurn(playerid);
		return 1;
	}
	else if(strcmp(param, "select", true) == 0)
	{
		SetPVarInt(playerid, "SelectMode", SELECTMODE_BIZZ);
		SelectObject(playerid);
		SendClientMessage(playerid, COLOR_BLUE, "[TIP] {FFFFFF}Click on a business object to edit it.");
		return 1;
	}
	else if(strcmp(param, "backdoor", true) == 0)
  	{
		new id = GetPVarInt(playerid, "BizzKey");
  		if(id == 0) return SendClientMessage(playerid, COLOR_GREY, "You don't own a business.");

  		if(BizInfo[id][bbdXo] == 0 && BizInfo[id][bbdYo] == 0 && BizInfo[id][bbdZo] == 0) return SendClientMessage(playerid, COLOR_GREY, "This business does not have a back door.");
  		if(GetPVarInt(playerid, "BizzEnter") == id) {
			new Float:pos[3];
			GetPlayerPos(playerid, pos[0], pos[1], pos[2]);

			BizInfo[id][bbdXi] = pos[0];
			BizInfo[id][bbdYi] = pos[1];
			BizInfo[id][bbdZi] = pos[2];

			DestroyDynamicPickup(BizInfo[id][bbdiIcon]);
			BizInfo[id][bbdiIcon] = CreateDynamicPickup(1318, 1, BizInfo[id][bbdXi], BizInfo[id][bbdYi], BizInfo[id][bbdZi], id, BizInfo[id][IntIn]);

			SendClientMessage(playerid, COLOR_WHITE, "Backdoor set!");
			SaveBizzBackdoor(id);
  		} else { SendClientMessage(playerid, COLOR_GREY, "You are not inside of your business."); }
  	}	
	else cmd_biz(playerid, "");
	return 1;
}
//============================================//
COMMAND:holdo(playerid, params[])
{
    if(IsPlayerAttachedObjectSlotUsed(playerid,HOLDOBJECT_BENCH))
    {
		SendClientMessage(playerid,COLOR_WHITE,"Object removed.");
	    return RemovePlayerAttachedObject(playerid,HOLDOBJECT_BENCH);
	}
	if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	if (GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if (GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if (GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Jailed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return SendClientMessage(playerid, COLOR_GREY, "You must be on foot to use this.");
    if(GetPVarInt(playerid, "ConnectTime") < 8) return SendClientMessage(playerid, COLOR_GREY, "You need 8 hours played to use this command.");
    if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USECELLPHONE) return SendClientMessage(playerid, COLOR_GREY, "You can't be on a cellphone while using this.");
	ShowPlayerDialog(playerid,64,DIALOG_STYLE_LIST,"Hold Object","{33FF66}Basketball\n{33FF66}Suitcase\n{33FF66}Money\n{33FF66}Pizza\n{33FF66}Burger\n{33FF66}Fishing Rod\n{33FF66}Pool Stick\n{33FF66}Fire Extinguisher\n{33FF66}Floppy Disk\n{33FF66}Radio\n{33FF66}Parrot\n{33FF66}Flashlight\n{33FF66}Screwdriver\n{33FF66}Hammer\n{33FF66}Rope\n{33FF66}Katana\n{33FF66}Chainsaw\n{33FF66}Wheelchair\n{33FF66}Crowbar\n{33FF66}Wrench","Select", "Exit");
	return 1;
}
//============================================//
COMMAND:objectoff(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    RemovePlayerAttachedObject(playerid,HOLDOBJECT_CLOTH1);
    DeletePVar(playerid,"MouthCig");
    SendClientMessage(playerid,COLOR_WHITE,"Clothing objects removed.");
    RemovePlayerAttachedObject(playerid,HOLDOBJECT_CLOTH1);
    RemovePlayerAttachedObject(playerid,HOLDOBJECT_CLOTH2);
    RemovePlayerAttachedObject(playerid,HOLDOBJECT_CLOTH3);
    RemovePlayerAttachedObject(playerid,HOLDOBJECT_CLOTH4);
    SetPVarInt(playerid, "ObjectSwitch", 0);
	return 1;
}
//============================================//
COMMAND:changephone(playerid, params[])
{
    new count = 0, req;
    if(sscanf(params, "i", req)) return usage(playerid, "/changephone [number]");
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if (GetPVarInt(playerid, "DonateRank") == 0) return SendClientMessage(playerid, COLOR_WHITE, "NO PERMISSION, DONATORS ONLY!");
    if(req <= 0) return true;
    count = GetAdminCount(2);
    if(count == 0) return SendClientMessage(playerid, COLOR_WHITE, "There is no admins online to conduct your request!");
    new query[255];
    format(query, sizeof(query), "SELECT * FROM accounts WHERE PhoneNum=%d", req);
    mysql_tquery(handlesql, query, "CheckPhone", "ii", playerid, req);
	return 1;
}
//============================================//
COMMAND:acp(playerid, params[])
{
	new targetid,string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "u", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /acp [playerid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
	    if(GetPVarInt(targetid, "ReqNum") == 0) return SendClientMessage(playerid, COLOR_GREY, "This player's request time has dropped or he never requested!");
		if(GetPVarInt(playerid, "Admin") >= 1)
		{
   			format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
      		format(giveplayer, sizeof(giveplayer), "%s", PlayerName(targetid));
      		GiveNameSpace(sendername);
      		GiveNameSpace(giveplayer);
      		format(string, sizeof(string), "AdmCmd: %s has accepted %s's phonenumber change request.", sendername, giveplayer);
      		SendAdminMessage(COLOR_YELLOW,string);
      		format(string, sizeof(string), "You accepted %s's phone request.", giveplayer);
      		SendClientMessage(playerid,COLOR_GREEN,string);
      		format(string, sizeof(string), "Admin %s has accepted your phone request.", sendername);
      		SendClientMessage(targetid,COLOR_GREEN,string);
      		SetPVarInt(targetid, "PhoneNum", GetPVarInt(targetid, "ReqNum"));
      		SetPVarInt(targetid, "ReqAdmin", 0);
		}
		else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
COMMAND:plantradio(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "SERVER: You must be logged in to use this.");
	if (GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid, COLOR_GREY, "You must be outside to use this.");
	if (GetPVarInt(playerid, "ConnectTime") < 24) return SendClientMessage(playerid, COLOR_GREY, "You need 24 hours played to use boom-boxes.");
    if (CheckInvItem(playerid, 1003))
    {
		new found = 0, string[128], Float:X, Float:Y, Float:Z, Float:A, id = 0;
        for(new i=0;i<sizeof(RadioInfo);i++)
		{
		    if(RadioInfo[i][rAreaID] == GetPlayerZone(playerid))
		    {
		        found++;
		    }
		}
		if(found != 0) return SendClientMessage(playerid, COLOR_GREY,"There is currently a radio in this area!");
		for(new i=0;i<sizeof(RadioInfo);i++)
		{
		    if(RadioInfo[i][rX] == 0.0 && RadioInfo[i][rY] == 0.0 && RadioInfo[i][rZ] == 0.0)
		    {
		        id = i;
		    }
		}
		if(id == 0) return SendClientMessage(playerid, COLOR_GREY,"All boom boxes have been used!");
		for(new i=0;i<sizeof(RadioInfo);i++)
		{
            if(strcmp(RadioInfo[i][rOwner], PlayerName(playerid), true) == 0)
		    {
		        SendClientMessage(playerid, COLOR_LIGHTRED, "You already have a boombox planted!");
		        return true;
		    }
		}
		GetPlayerPos(playerid,X,Y,Z);
		GetPlayerFacingAngle(playerid, A);
		RadioInfo[id][rObject] = CreateDynamicObject(2103, X,Y,Z-1, 0.0, 0.0, A, GetPlayerVirtualWorld(playerid));
		format(string, sizeof(string),"[BOOM BOX]\n%s", PlayerName(playerid));
		RadioInfo[id][rText] = CreateDynamic3DTextLabel(string, COLOR_WHITE, X, Y, Z-0.25, 25.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0, 0, -1, 50.0);
		RadioInfo[id][rX] = X;
		RadioInfo[id][rY] = Y;
		RadioInfo[id][rZ] = Z;
		RadioInfo[id][rStatus] = 0;
		RadioInfo[id][rAreaID] = GetPlayerZone(playerid);
		strmid(RadioInfo[id][rOwner], PlayerName(playerid), 0, strlen(PlayerName(playerid)), 255);
		strmid(RadioInfo[id][rURL], "NUll", 0, strlen("NULL"), 255);
		SetPVarInt(playerid, "RadioPlant", 0);
		SendClientMessage(playerid, COLOR_WHITE, "Boombox planted, type (/editradio) to configure the radio options!");
		RemoveInvItem(playerid, 1003);
    }
    else SendClientMessage(playerid, COLOR_LIGHTRED, "You don't have a radio to plant!");
	return 1;
}
//============================================//
ALTCOMMAND:boombox->editradio;
COMMAND:editradio(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "SERVER: You must be logged in to use this.");
	if (GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid, COLOR_GREY, "You must be outside to use this.");
    for(new i=0;i<sizeof(RadioInfo);i++)
	{
	    if(IsPlayerInRangeOfPoint(playerid,5.0, RadioInfo[i][rX], RadioInfo[i][rY], RadioInfo[i][rZ]))
		{
		    if(RadioInfo[i][rAreaID] > 0)
			{
			    if(strcmp(RadioInfo[i][rOwner], PlayerName(playerid), true) == 0)
		        {
				    ShowPlayerDialog(playerid,58,DIALOG_STYLE_LIST,"BOOMBOX OPTIONS","Enter URL\nRadio Stations\nToggle ON/OFF\nPick-up Radio","Select", "Exit");
				    SetPVarInt(playerid, "RadioInfoID", i);
			        return true;
				}
		    }
	    }
	}
	return 1;
}
//============================================//
COMMAND:removeradio(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "SERVER: You must be logged in to use this.");
	if (GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid, COLOR_GREY, "You must be outside to use this.");
    if(GetPVarInt(playerid, "Admin") >= 1)
    {
        for(new i=0;i<sizeof(RadioInfo);i++)
		{
		    if(IsPlayerInRangeOfPoint(playerid,5.0, RadioInfo[i][rX], RadioInfo[i][rY], RadioInfo[i][rZ]))
		    {
				if(RadioInfo[i][rAreaID] > 0)
				{
                    SendClientMessage(playerid, COLOR_LIGHTRED, "Radio removed!");
                    if(RadioInfo[i][rStatus] != 0)
                    {
					    foreach(new ia : Player)
					    {
					        if(GetPlayerZone(ia) == RadioInfo[i][rAreaID])
					        {
						        StopAudioStreamForPlayerEx(ia);
					        }
					    }
					}
                    RadioInfo[i][rX] = 0.0;
		            RadioInfo[i][rY] = 0.0;
		            RadioInfo[i][rZ] = 0.0;
		            RadioInfo[i][rStatus] = 0;
		            RadioInfo[i][rAreaID] = 0;
		            strmid(RadioInfo[i][rOwner], "None", 0, strlen("None"), 255);
		            strmid(RadioInfo[i][rURL], "None", 0, strlen("None"), 255);
		            if(IsValidDynamicObject(RadioInfo[i][rObject])) { DestroyDynamicObject(RadioInfo[i][rObject]); }
                    DestroyDynamic3DTextLabel(RadioInfo[i][rText]);
				    return true;
				}
		    }
		}
    }
    else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	return 1;
}
//============================================//
COMMAND:ban(playerid, params[])
{
	if(GetPVarInt(playerid, "Admin") < 2) return SendClientMessage(playerid, -1, "You are not allowed to use this command.");
	new text[128],targetid,string[255],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "us[128]", targetid, text)) SendClientMessage(playerid, -1, "USAGE: /ban [PlayerID/Name] [Reason]");
	else
	{
		if(GetPVarInt(targetid, "Admin") > 7 && GetPVarInt(playerid, "Admin") < GetPVarInt(targetid, "Admin")) return nal(playerid);
		if(strlen(text) >= 100) return SendClientMessage(playerid, -1, "Ban Reason is too long.");
		format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
		format(giveplayer, sizeof(giveplayer), "%s", PlayerName(targetid));
		GiveNameSpace(sendername);
		GiveNameSpace(giveplayer);
		format(string, sizeof(string), "AdmCmd: %s was banned by Admin %s Reason:[%s].", giveplayer, AdminName(playerid), text);
		SendClientMessageToAllEx(COLOR_LIGHTRED, string);
		BanPlayer(targetid,text,AdminName(playerid));
		format(string, sizeof(string), "[BAN][ONLINE][%s] %s", PlayerName(playerid), string);
		BanLog(string);
	}
	return 1;
}
//============================================//
ALTCOMMAND:ajail->adminjail;
COMMAND:adminjail(playerid, params[]) {
	if(GetPVarInt(playerid, "Admin") < 1) return SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	new user,
		time,
		reason[128];

	if(sscanf(params, "uis[128]", user, time, reason)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /ajail [Player ID/Name] [Minutes] [Reason]");
	if(!IsPlayerConnected(user)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
 	if(IsPlayerNPC(user)) return SendClientMessage(playerid, COLOR_GREY, "Can't do this to a NPC.");
	if(time < 1) return SendClientMessage(playerid, COLOR_GREY, "You cannot jail a player for less than one minute.");
	new date[3],
	    query[315];

	// Set IG Data
	SetPlayerPosEx(user, -1406.7714, 1245.1904, 1029.8984);
	SetPlayerFacingAngle(user, 177.0008);
	SetPlayerInterior(user, 16);
	SetPlayerVirtualWorld(user, user + 1);
	SetPVarInt(user, "Jailed", 1);
	SetPVarInt(user, "JailTime", time * 60);
	SetPVarInt(user, "Mute", 1);

	// Log Administrative Jail in Database
	getdate(date[0], date[1], date[2]);
	format(query, sizeof(query), "%d-%d-%d", date[0], date[1], date[2]);
	format(query, sizeof(query), "INSERT INTO `logs_adminjails`(`Name`, `Admin`, `Reason`, `Minutes`, `Date`) VALUES ('%s','%s','%s',%i,'%e');", PlayerName(user), AdminName(playerid), reason, time, query);
	mysql_tquery(handlesql, query);

	// Message Players
	format(query, sizeof(query), "AdmCmd: %s was jailed by Admin %s Reason:[%s].", PlayerName(user), AdminName(playerid), reason);
	SendClientMessageToAllEx(COLOR_LIGHTRED, query);
	format(query, sizeof(query),"[JAILED] You have been jailed for %d minutes.", time);
	SendClientMessage(user, 0xE65A5AAA, query);

	// Disarm Player
	if(time >= 420) {
	    ResetPlayerWeaponsEx(user);
	    ClearInvWeapons(user);
	}

	return 1;
}
//============================================//
COMMAND:unjail(playerid, params[])
{
	new text[128],targetid,string[255],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "us[128]", targetid, text)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /unjail [playerid] [reason]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
        if(IsPlayerNPC(targetid)) return SendClientMessage(playerid, COLOR_GREY, "Can't do this to a NPC.");
		if(GetPVarInt(playerid, "Admin") >= 1)
		{
   			format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
      		format(giveplayer, sizeof(giveplayer), "%s", PlayerName(targetid));
      		GiveNameSpace(sendername);
      		GiveNameSpace(giveplayer);
      		if(GetPVarInt(playerid, "AHide") > 0 || GetPVarInt(playerid, "Admin") >= 11) sendername = "Hidden";
      		format(string, sizeof(string), "AdmCmd: %s was Un-Admin-jailed by Admin %s Reason:[%s].", giveplayer, AdminName(playerid), text);
			SendClientMessageToAllEx(COLOR_LIGHTRED, string);
			SetPVarInt(targetid, "Jailed", 2);
			SetPVarInt(targetid, "JailTime", 1);
            SetPVarInt(targetid, "Jails", GetPVarInt(targetid, "Jails")-1);
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
COMMAND:engine(playerid, params[])
{
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
	    if(IsNotAEngineCar(GetPlayerVehicleID(playerid))) return true;
	    new idcar = GetPlayerVehicleID(playerid), Float:ghealth, key = idcar, price, string[128];
	    switch(VehicleInfo[idcar][vEngine])
	    {
	        case 0:
	        {
	            GetVehicleHealth(idcar, ghealth);
	            if(ghealth <= 299.0)
		        {
		            //RemovePlayerFromVehicleEx(playerid);
				    SendClientMessage(playerid,COLOR_LIGHTRED,"The vehicle is currently damaged!");
				    return true;
		        }
		        if(VehicleInfo[idcar][vFuel] <= 0)
		        {
		            //RemovePlayerFromVehicleEx(playerid);
				    SendClientMessage(playerid,COLOR_LIGHTRED,"The vehicle has no fuel!");
				    return true;
		        }
		        if(VehicleInfo[idcar][vType] == VEHICLE_PERSONAL)
		        {
                    if(!PlayerOwnsVehicle(playerid, idcar) && !HasCarKey(playerid, VehicleInfo[idcar][vID])) {
						return true;
					}
				}
				if(VehicleInfo[idcar][vType] == VEHICLE_THEFT) return true;
				if(GetPVarInt(playerid, "RefillAM") > 0)
		        {
		            //RemovePlayerFromVehicleEx(playerid);
				    SendClientMessage(playerid,COLOR_LIGHTRED,"You can't turn the vehicles engine on while refueling!");
				    return true;
		        }
				if(GetPVarInt(playerid, "EngAmpt") != 0) return true;
				if(ghealth <= 300.0)
                {
   	                price = 500;
					if(VehicleInfo[key][vInsurance] > 0 && VehicleInfo[key][vInsuranceC] < 250) price = 0;
					if(GetPlayerMoneyEx(playerid) >= price)
					{
					    GivePlayerMoneyEx(playerid,-price);
					    format(string, sizeof(string),"-$%d was taken to repair your vehicle's engine!", price);
					    SendClientMessage(playerid,COLOR_WHITE,string);
					    VehicleInfo[key][vHealth] = 1000.0;
					    SetVehicleHealth(key, VehicleInfo[key][vHealth]);
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
					}
					else
					{
					    format(string, sizeof(string),"You cannot spawn your vehicle as it's damaged, cost: $%d!", price);
						SendClientMessage(playerid, COLOR_LIGHTRED, string);
					}
				    return true;
   	            }
   	            //==========//
   	            if(VehicleInfo[key][vType] == VEHICLE_PERSONAL)
   	            {
		            if(VehicleInfo[key][vMileage][1] >= 1000000)
		            {
				        SendClientMessage(playerid,COLOR_LIGHTRED,"This vehicle has reached it's Mileage limit!");
				        return true;
		            }
		        }
   	            //==========//
	            SetPVarInt(playerid, "EngAmpt", 1);
	            SetTimerEx("EngineResult", 2000, false, "ii", playerid, GetPlayerVehicleID(playerid));
	            GameTextForPlayer(playerid, "~n~~n~~n~~w~attempting to start~n~ the ~r~~h~engine~w~...", 2000, 3);
	            new Float:Xx, Float:Yy, Float:Zz;
	            GetPlayerPos(playerid, Xx, Yy, Zz);
	            foreach(new i : Player)
	            {
	                if(IsPlayerInRangeOfPoint(i, 15.0, Xx, Yy, Zz))
	                {
	            	    PlayAudioStreamForPlayerEx(i, "http://www.diverseroleplay.org/sounds/vehstart.mp3", Xx, Yy, Zz, 15.0, 1);
	            	}
				}
	        }
	        case 1:
	        {
	            VehicleInfo[idcar][vEngine]=0;
	            CarEngine(idcar, VehicleInfo[idcar][vEngine]);
	            GameTextForPlayer(playerid, "~n~~w~engine ~r~~h~off ~w~!", 5000, 5);
	        }
	    }
	}
	return 1;
}
//============================================//
COMMAND:reload(playerid, params[])
{
	new str[128], found = 0;
    if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
    {
        if(GetPVarInt(playerid, "PlayerLogged") == 1 && GetPVarInt(playerid, "Muted") == 0 && GetPVarInt(playerid, "Dead") == 0)
        {
		    //==========//
		    if(PlayerInfo[playerid][pPlayerWeapon] > 0)
		    {
    		    if(PlayerInfo[playerid][pPlayerAmmo] == 0)
    		    {
    		        if(GetPlayerWeapon(playerid) == 0)
    		        {
    		            new ammo, id;
    		            for(new i = 0; i < MAX_INV_SLOTS; i++)
    		            {
							if(PlayerInfo[playerid][pInvItem][i] >= 100 && PlayerInfo[playerid][pInvItem][i] <= 199)
							{
								ammo = CompatAmmo(playerid, PlayerInfo[playerid][pInvItem][i]);
								if(ammo > 0) { 
									found++, id = i; 
									break;
								}
							}
    		            }
    		            if(found == 0) {
    		                scm(playerid, -1, "You don't have any magazines for this weapon!");
    		                return 1;
						}
    		            //==========//
						PlayerInfo[playerid][pAmmoType]=PlayerInfo[playerid][pInvItem][id];
    		            GivePlayerWeaponEx(playerid, PlayerInfo[playerid][pPlayerWeapon], PlayerInfo[playerid][pInvQ][id]);
						PlayerInfo[playerid][pSerial]=PlayerInfo[playerid][pInvS][id];
					    //==========//
					    format(str, 128, "%s reloaded with '%s'!", PrintIName(PlayerInfo[playerid][pPlayerWeapon]), PrintIName(PlayerInfo[playerid][pInvItem][id]));
				        SendClientMessage(playerid, COLOR_WHITE, str);
				        //==========//
						PlayerInfo[playerid][pInvItem][id]=0;
						PlayerInfo[playerid][pInvQ][id]=0;
						PlayerInfo[playerid][pInvEx][id]=0;
					    SetTimerEx("FixInv", 500, false, "i", playerid);
				        //CallRemoteFunction("FixInv", "i", playerid);
				        return true;
    		        }
    		    }
			}
			else return error(playerid, "You have no weapon.");
		}
		else return error(playerid, "You are dead/muted.");
	}
	return 1;
}
//============================================//
COMMAND:calllist(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    SendClientMessage(playerid, COLOR_WHITE, "____________________________________________________________________");
    SendClientMessage(playerid, COLOR_FADE, "                             Numbers:                          ");
    SendClientMessage(playerid, COLOR_FADE, "LSPD/LSFD: 911 | Taxi Drivers: 411 | Mechanics: 311.");
    SendClientMessage(playerid, COLOR_WHITE, "____________________________________________________________________");
	return 1;
}
//============================================//
COMMAND:pcr(playerid, params[])
{
	if(GetPVarInt(playerid, "Member") != 2) return nal(playerid);
	/*new idcar = GetPlayerVehicleID(playerid);
	if(VehicleInfo[idcar][vType] != VEHICLE_LSPD) return error(playerid, "You are not in a police cruiser.");*/
	ShowPlayerDialog(playerid, 411, DIALOG_STYLE_INPUT, "Patient Care Report", "Enter the name of the patient.", "Continue","Close");
	return 1;
}
//============================================//
COMMAND:emsup(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Member") == 2)
	{
	    if(IsPlayerInRangeOfPoint(playerid,5.0,1144.5383,-1341.3037,13.5911))
	    {
		    SetPlayerPosEx(playerid,1151.9166,-1344.6350,26.7097);
		    SetPlayerInterior(playerid,0);
		    SetPlayerVirtualWorld(playerid,0);
		}
    }
    else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	return 1;
}
//============================================//
COMMAND:emsdown(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Member") == 2)
	{
	    if(IsPlayerInRangeOfPoint(playerid,5.0,1151.9166,-1344.6350,26.7097))
	    {
		    SetPlayerPosEx(playerid,1144.5383,-1341.3037,13.5911);
		    SetPlayerInterior(playerid,0);
		    SetPlayerVirtualWorld(playerid,0);
		}
    }
    else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	return 1;
}
//============================================//
COMMAND:stretcher(playerid, params[])
{
	new targetid,string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "u", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /stretcher [playerid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if (playerid == targetid) return SendClientMessage(playerid, COLOR_GREY, "You cannot drag yourself.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
	    if(IsPlayerNPC(targetid)) return SendClientMessage(playerid, COLOR_GREY, "Can't do this to a NPC.");
		if(GetPVarInt(targetid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "The player is not able to use this.");
		if(GetPVarInt(playerid, "Member") == 2 && GetPVarInt(playerid, "Rank") > 1)
		{
		    if(PlayerToPlayer(playerid,targetid,3.0))
		    {
   			    format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
	    	    format(giveplayer, sizeof(giveplayer), "%s", PlayerNameEx(targetid));
      		    GiveNameSpace(sendername);
        	    GiveNameSpace(giveplayer);
                format(string, sizeof(string), "*** %s places %s on a stretcher.", sendername, giveplayer);
    	        ProxDetector(30.0, playerid, string, COLOR_PURPLE);
    	        TogglePlayerControllableEx(targetid,false);
    	        SetCameraBehindPlayer(targetid);
    	        SetPVarInt(targetid, "Drag", playerid);
    	        ApplyAnimation(targetid, "INT_HOUSE","BED_Loop_R", 4.0,1,1,1,1,1);
    	        SetPlayerAttachedObject(targetid, 6, 2146, 1, -0.342133, 0.479713, 0.359209, 135.566574, 2.406259, 280.725524, 1.000000, 1.000000, 1.000000);
    	        SendClientMessage(playerid, COLOR_PINK, "Use (/stopstretcher) to take the player off the stretcher.");
    	    }
    	    else SendClientMessage(playerid,COLOR_GREY,"You are not close enough to that player!");
		}
	}
	return 1;
}
//============================================//
COMMAND:stopstretcher(playerid, params[])
{
	new targetid,string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "u", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /stopstretcher [playerid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if (playerid == targetid) return SendClientMessage(playerid, COLOR_GREY, "You cannot drag yourself.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
	    if(IsPlayerNPC(targetid)) return SendClientMessage(playerid, COLOR_GREY, "Can't do this to a NPC.");
	    if(GetPVarInt(playerid, "Member") == 2 && GetPVarInt(playerid, "Rank") > 1)
		{
			if(GetPVarInt(targetid, "Drag") == playerid)
			{
   				format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
	    		format(giveplayer, sizeof(giveplayer), "%s", PlayerNameEx(targetid));
      			GiveNameSpace(sendername);
        		GiveNameSpace(giveplayer);
            	format(string, sizeof(string), "*** %s places %s out of the stretcher.", sendername, giveplayer);
    	    	ProxDetector(30.0, playerid, string, COLOR_PURPLE);
    	    	SetPVarInt(targetid, "Drag", INVALID_MAXPL);
    	    	SetCameraBehindPlayer(targetid);
    	    	TogglePlayerControllableEx(targetid,true);
				ClearAnimations(targetid);
				RemovePlayerAttachedObject(targetid, 6);
				ApplyAnimation(targetid, "CARRY", "crry_prtial", 2.0, 0, 0, 0, 0, 0);
			}
			else SendClientMessage(playerid,COLOR_GREY,"You are not dragging this person.");
		}
	}
	return 1;
}
//============================================//
COMMAND:fdcone(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Duty") != 1) return SendClientMessage(playerid, COLOR_WHITE, "You can not use this while not on duty.");
	if(GetPVarInt(playerid, "Member") == 2 || GetPVarInt(playerid, "Rank") >= 8)
	{
	    if(RoadBlocks >= MAX_OBJECTS) return true;
	    new Float:X,Float:Y,Float:Z,Float:A;
	    GetPlayerPos(playerid, X, Y, Z);
		GetPlayerFacingAngle(playerid,A);
		RoadBlocks++;
		RoadBlockObject[RoadBlocks] = CreateDynamicObject(1237, X, Y, Z-1, 0, 0, A, 0);
		SendClientMessage(playerid, COLOR_LIGHTRED, "Cone created use (/rcone) to destroy the object.");
    }
    else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	return 1;
}
//============================================//
COMMAND:rcone(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Duty") != 1) return SendClientMessage(playerid, COLOR_WHITE, "You can not use this while not on duty.");
	if(GetPVarInt(playerid, "Member") == 2 || GetPVarInt(playerid, "Rank") >= 8)
	{
	    for(new o = 0; o < MAX_OBJECTS; o++)
	    {
		    if(RoadBlockObject[o] != 0)
		    {
	            if(IsValidDynamicObject(RoadBlockObject[o])) { DestroyDynamicObject(RoadBlockObject[o]); }
	            RoadBlockObject[o]=0;
                RoadBlocks = 0;
            }
        }
    }
    else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	return 1;
}
//============================================//
ALTCOMMAND:exit->enter;
COMMAND:enter(playerid, params[])
{
    foreach(new in : IntIterator)
    {
        if(GetPVarInt(playerid, "OnRoute") != 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You are currently on a route!");
        if(IntInfo[in][iUsed] == 1)
        {
            if(IsPlayerInRangeOfPoint(playerid, 2.0, IntInfo[in][ieX], IntInfo[in][ieY], IntInfo[in][ieZ]))
            {
                if(IntInfo[in][iFreeze] == 1) TogglePlayerControllableEx(playerid, false);
                SetPlayerPosEx(playerid, IntInfo[in][ixX], IntInfo[in][ixY], IntInfo[in][ixZ]);
                SetPlayerInterior(playerid,IntInfo[in][iInt]);
                SetPlayerVirtualWorld(playerid,IntInfo[in][iWorld]);
				Streamer_Update(playerid);
				if(IntInfo[in][iWorld] != 0) TempFreeze(playerid);
                PlayerPlaySound(playerid, 1054, 0.0, 0.0, 0.0);
                GameTextForPlayer(playerid, "~w~press ~r~'~k~~GROUP_CONTROL_BWD~' ~w~to exit.", 3000, 4);
                SetPVarInt(playerid, "IntEnter", in), SetPVarInt(playerid, "BizzEnter", 0);
				if(GetPVarInt(playerid, "DrugTime") == 0) {
					SetPlayerWeather(playerid, 11);
				}				
                if(IntInfo[in][iFreeze] == 0) SetTimerEx("LoadChecks", 1500, false, "i", playerid);
                if(IntInfo[in][iFreeze] == 1) SetTimerEx("TogglePlayerControllableEx", 2000, false, "ii", playerid, true);
                TextDrawSetString(Text:LocationDraw[playerid], PrintArea(playerid, 2, in));
                return true;
            }
            if(IsPlayerInRangeOfPoint(playerid, 2.0, IntInfo[in][ixX], IntInfo[in][ixY], IntInfo[in][ixZ]))
            {
				if(GetPlayerVirtualWorld(playerid) == IntInfo[in][iWorld])
				{
				    if(IntInfo[in][iFreeze] == 1) TogglePlayerControllableEx(playerid, false);
					Streamer_UpdateEx(playerid, IntInfo[in][ieX], IntInfo[in][ieY], IntInfo[in][ieZ], 0, 0);
                	SetPlayerPosEx(playerid, IntInfo[in][ieX], IntInfo[in][ieY], IntInfo[in][ieZ]);
                	SetPlayerInterior(playerid, 0);
                	SetPlayerVirtualWorld(playerid, 0);
                	PlayerPlaySound(playerid, 1055, 0.0, 0.0, 0.0);
                	DisablePlayerCheckpoint(playerid);
					if(GetPVarInt(playerid, "DrugTime") == 0) {
						SetPlayerWeather(playerid, GMWeather);
					}
                	SetPVarInt(playerid, "IntEnter", 0), SetPVarInt(playerid, "BizzEnter", 0);
                	if(IntInfo[in][iFreeze] == 1) SetTimerEx("TogglePlayerControllableEx", 2000, false, "ii", playerid, true);
                	TextDrawSetString(Text:LocationDraw[playerid], PrintArea(playerid, 0, 0));
                	return true;
                }
            }
        }
    }
    foreach(new h : HouseIterator)
	{
		if(GetPVarInt(playerid, "OnRoute") != 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You are currently on a route!");
	    if(HouseInfo[h][hID] != 0)
	    {
	        if(IsPlayerInRangeOfPoint(playerid, 2.0, HouseInfo[h][hXo], HouseInfo[h][hYo], HouseInfo[h][hZo]) && GetPlayerVirtualWorld(playerid) == HouseInfo[h][hVwOut])
	        {
	            if(HouseInfo[h][hOwned] != 0)
	            {
	                if(HouseInfo[h][hLocked] == 0)
	                {
						Streamer_UpdateEx(playerid, HouseInfo[h][hXi], HouseInfo[h][hYi], HouseInfo[h][hZi], h, HouseInfo[h][hIntIn]);
		                SetPlayerPosEx(playerid, HouseInfo[h][hXi], HouseInfo[h][hYi], HouseInfo[h][hZi]);
		                SetPlayerVirtualWorld(playerid, h);
		                SetPlayerInterior(playerid, HouseInfo[h][hIntIn]);
		                SetPVarInt(playerid, "IntEnter", 0), SetPVarInt(playerid, "BizzEnter", 0), SetPVarInt(playerid, "HouseEnter", h);
		                TextDrawSetString(Text:LocationDraw[playerid], PrintArea(playerid, 1, h));
		                if(strcmp(HouseInfo[h][hRadioU], "None", true) == 0){}
                        else
                        {
                            PlayAudioStreamForPlayerEx(playerid, HouseInfo[h][hRadioU]);
                        }
						if(GetPVarInt(playerid, "DrugTime") == 0) {
							SetPlayerWeather(playerid, 11);
						}
						HouseLights(h);
						if(HouseInfo[h][hLights] == 1) SCM(playerid, COLOR_LIGHTRED, "The house lights are currently off, (/lights) to toggle them.");
					}
					else
					{
						error(playerid, "This house is locked.");
					}
	            }
	            else
	           	{
					error(playerid, "This house is not owned by anyone.");
	            }
			}
	        else if(IsPlayerInRangeOfPoint(playerid, 2.0, HouseInfo[h][hXi], HouseInfo[h][hYi], HouseInfo[h][hZi]) && GetPlayerVirtualWorld(playerid) == h)
	        {
				Streamer_UpdateEx(playerid, HouseInfo[h][hXo], HouseInfo[h][hYo], HouseInfo[h][hZo], HouseInfo[h][hVwOut], HouseInfo[h][hIntOut]);
				SetPlayerPosEx(playerid, HouseInfo[h][hXo], HouseInfo[h][hYo], HouseInfo[h][hZo]);
				SetPlayerVirtualWorld(playerid, HouseInfo[h][hVwOut]);
				SetPlayerInterior(playerid, HouseInfo[h][hIntOut]);
				Streamer_Update(playerid);
				if(HouseInfo[h][hVwOut] != 0) TempFreeze(playerid);
				SetPVarInt(playerid, "IntEnter", 0), SetPVarInt(playerid, "BizzEnter", 0), SetPVarInt(playerid, "HouseEnter", 0);
				TextDrawSetString(Text:LocationDraw[playerid], PrintArea(playerid, 0, 0));
				StopAudioStreamForPlayerEx(playerid);
				if(GetPVarInt(playerid, "DrugTime") == 0) {
					SetPlayerWeather(playerid, GMWeather);
				}					
			}
			else if(IsPlayerInRangeOfPoint(playerid, 2.0, HouseInfo[h][hgXo], HouseInfo[h][hgYo], HouseInfo[h][hgZo]) && GetPlayerVirtualWorld(playerid) == HouseInfo[h][hVwOut])
			{
				if(HouseInfo[h][hLocked] == 1 && HouseInfo[h][hOwned] != 0)
				{
					error(playerid, "This garage is locked.");
					return true;
				}
	   
				TempFreeze(playerid);
				Streamer_UpdateEx(playerid, HouseInfo[h][hgXi], HouseInfo[h][hgYi], HouseInfo[h][hgZi], h, HouseInfo[h][gInterior]);
				SetPlayerVirtualWorld(playerid, h);
				SetPlayerInterior(playerid, HouseInfo[h][gInterior]);
				SetPlayerPosEx(playerid, HouseInfo[h][hgXi], HouseInfo[h][hgYi], HouseInfo[h][hgZi]);
				SetPlayerFacingAngle(playerid, HouseInfo[h][hgAi]);
				SetPVarInt(playerid, "IntEnter", 0), SetPVarInt(playerid, "BizzEnter", 0), SetPVarInt(playerid, "HouseEnter", h), SetPVarInt(playerid, "GarageEnter", h);

				TextDrawSetString(Text:LocationDraw[playerid], PrintArea(playerid, 1, h));

				if(strcmp(HouseInfo[h][hRadioU], "None", true) == 0){}
				else
				{
					PlayAudioStreamForPlayerEx(playerid, HouseInfo[h][hRadioU]);
				}
				if(GetPVarInt(playerid, "DrugTime") == 0) {
					SetPlayerWeather(playerid, 11);
				}		
				HouseLights(h);

				Streamer_Update(playerid);
				return 1;
			}
			else if(IsPlayerInRangeOfPoint(playerid, 4.0, HouseInfo[h][hgXi], HouseInfo[h][hgYi], HouseInfo[h][hgZi]) && GetPlayerVirtualWorld(playerid) == h)
			{
				TempFreeze(playerid);

				SetPlayerVirtualWorld(playerid, 0);
				SetPlayerInterior(playerid, 0);
				SetPlayerPosEx(playerid, HouseInfo[h][hgXo], HouseInfo[h][hgYo], HouseInfo[h][hgZo]);
				SetPlayerFacingAngle(playerid, HouseInfo[h][hgAo]);
				SetPVarInt(playerid, "IntEnter", 0), SetPVarInt(playerid, "BizzEnter", 0), SetPVarInt(playerid, "HouseEnter", 0), SetPVarInt(playerid, "GarageEnter", 0);

				TextDrawSetString(Text:LocationDraw[playerid], PrintArea(playerid, 0, 0));
					
				StopAudioStreamForPlayerEx(playerid);
				LoadRadios(playerid);

				if(GetPVarInt(playerid, "DrugTime") == 0) {
					SetPlayerWeather(playerid, GMWeather);
				}

				Streamer_Update(playerid);
				return 1;
			}
			else if(IsPlayerInRangeOfPoint(playerid, 2.0, HouseInfo[h][hbdXo], HouseInfo[h][hbdYo], HouseInfo[h][hbdZo]) && GetPlayerVirtualWorld(playerid) == HouseInfo[h][hVwOut])
			{
				if(HouseInfo[h][hOwned] != 0) {
					if(HouseInfo[h][hLocked] == 0) {
						if(HouseInfo[h][hbdXi] == 0 && HouseInfo[h][hbdYi] == 0 && HouseInfo[h][hbdXi] == 0) return 1;
						TempFreeze(playerid);
						SetPlayerPosEx(playerid, HouseInfo[h][hbdXi], HouseInfo[h][hbdYi], HouseInfo[h][hbdZi]);
						SetPlayerVirtualWorld(playerid, h);
						SetPlayerInterior(playerid, HouseInfo[h][hIntIn]);
						SetPVarInt(playerid, "IntEnter", 0), SetPVarInt(playerid, "BizzEnter", 0), SetPVarInt(playerid, "HouseEnter", h);
						TextDrawSetString(Text:LocationDraw[playerid], PrintArea(playerid, 1, h));
						if(strcmp(HouseInfo[h][hRadioU], "None", true) == 0){}
						else
						{
							PlayAudioStreamForPlayerEx(playerid, HouseInfo[h][hRadioU]);
						}
						HouseLights(h);
						if(HouseInfo[h][hLights] == 1) SCM(playerid, COLOR_LIGHTRED, "The house lights are currently off, (/lights) to toggle.");

						if(GetPVarInt(playerid, "DrugTime") == 0) {
							SetPlayerWeather(playerid, 11);
						}

						Streamer_Update(playerid);
						return 1;
					}
					else { error(playerid, "This house is locked."); }
				} else { error(playerid, "This house is unowned."); }
			}
			else if(IsPlayerInRangeOfPoint(playerid, 2.0, HouseInfo[h][hbdXi], HouseInfo[h][hbdYi], HouseInfo[h][hbdZi]) && GetPlayerVirtualWorld(playerid) == h) 
			{
				if(HouseInfo[h][hbdXo] == 0 && HouseInfo[h][hbdYo] == 0 && HouseInfo[h][hbdXo] == 0) return 1;

				TempFreeze(playerid);
				SetPlayerPosEx(playerid, HouseInfo[h][hbdXo], HouseInfo[h][hbdYo], HouseInfo[h][hbdZo]);
				SetPlayerVirtualWorld(playerid, HouseInfo[h][hVwOut]);
				SetPlayerInterior(playerid, HouseInfo[h][hIntOut]);
				SetPVarInt(playerid, "IntEnter", 0), SetPVarInt(playerid, "BizzEnter", 0), SetPVarInt(playerid, "HouseEnter", 0);
				TextDrawSetString(Text:LocationDraw[playerid], PrintArea(playerid, 0, 0));
				
				StopAudioStreamForPlayer(playerid);
				LoadRadios(playerid);
				if(GetPVarInt(playerid, "DrugTime") == 0) {
					SetPlayerWeather(playerid, GMWeather);
				}

				Streamer_Update(playerid);
				return 1;
			}
		}
    }
    foreach(new h : BizIterator)
	{
		if(GetPVarInt(playerid, "OnRoute") != 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You are currently on a route!");
	    if(BizInfo[h][ID] != 0)
	    {
	        if(IsPlayerInRangeOfPoint(playerid, 2.0, BizInfo[h][Xo], BizInfo[h][Yo], BizInfo[h][Zo]))
	        {
                if(BizInfo[h][Locked] == 0)
                {
					if(GetPlayerMoneyEx(playerid) >= BizInfo[h][EnterPrice])
					{
					    GivePlayerMoneyEx(playerid, -BizInfo[h][EnterPrice]);
					    BizInfo[h][Bank] = BizInfo[h][Bank] + BizInfo[h][EnterPrice];
						Streamer_UpdateEx(playerid, BizInfo[h][Xi], BizInfo[h][Yi], BizInfo[h][Zi], h, BizInfo[h][IntIn]);
					    SetPlayerPosEx(playerid, BizInfo[h][Xi], BizInfo[h][Yi], BizInfo[h][Zi]);
	                    SetPlayerVirtualWorld(playerid, h);
	                    SetPlayerInterior(playerid, BizInfo[h][IntIn]);
	                    SetPVarInt(playerid, "IntEnter", 0), SetPVarInt(playerid, "BizzEnter", h);
	                    new msg[128];
	                    format(msg, sizeof(msg), "{FFFFFF}Biz Slogan: %s", BizInfo[h][Slogan]);
	                    scm(playerid, -1, msg);
	                    if(GetPVarInt(playerid, "BizzKey") == h)
				        {
				            format(msg, sizeof(msg), "{FFFFFF}Products: %d/150.", BizInfo[h][bProd]);
				            scm(playerid, -1, msg);
				        }
	                    SetTimerEx("LoadChecks", 1500, false, "i", playerid);
	                    TextDrawSetString(Text:LocationDraw[playerid], PrintArea(playerid, 3, h));
	                    if(strcmp(BizInfo[h][bRadio], "None", true) == 0){}
                        else
                        {
                            PlayAudioStreamForPlayerEx(playerid, BizInfo[h][bRadio]);
                        }
						if(GetPVarInt(playerid, "DrugTime") == 0) {
							SetPlayerWeather(playerid, 11);
						}	
						return 1;
                    }
                    else error(playerid, "Insufficient funds.");
				}
				else
				{
					error(playerid, "This business is locked.");
				}
			}
	        else if(IsPlayerInRangeOfPoint(playerid, 2.0, BizInfo[h][Xi], BizInfo[h][Yi], BizInfo[h][Zi]) && GetPlayerVirtualWorld(playerid) == h)
	        {
				Streamer_UpdateEx(playerid, BizInfo[h][Xo], BizInfo[h][Yo], BizInfo[h][Zo], 0, BizInfo[h][IntOut]);
                SetPlayerPosEx(playerid, BizInfo[h][Xo], BizInfo[h][Yo], BizInfo[h][Zo]);
                SetPlayerVirtualWorld(playerid, 0);
                SetPlayerInterior(playerid, BizInfo[h][IntOut]);
                SetPVarInt(playerid, "IntEnter", 0), SetPVarInt(playerid, "BizzEnter", 0);
                StopAudioStreamForPlayerEx(playerid);
                TextDrawSetString(Text:LocationDraw[playerid], PrintArea(playerid, 0, 0));
				if(GetPVarInt(playerid, "DrugTime") == 0) {
					SetPlayerWeather(playerid, GMWeather);
				}		
				return 1;
			}
			else if(IsPlayerInRangeOfPoint(playerid, 2.0, BizInfo[h][bbdXo], BizInfo[h][bbdYo], BizInfo[h][bbdZo]))
			{
				if(BizInfo[h][Owned] != 0) {
	                if(BizInfo[h][Locked] == 0) {
	                	if(BizInfo[h][bbdXi] == 0 && BizInfo[h][bbdYi] == 0 && BizInfo[h][bbdXi] == 0) return 1;
						if(GetPVarInt(playerid, "MonthDon") == 0) {
						    if(GetPVarInt(playerid, "Cash") < BizInfo[h][EnterPrice]) return error(playerid,"Insufficient funds.");
							GivePlayerMoneyEx(playerid, -BizInfo[h][EnterPrice]);
							BizInfo[h][Bank] = BizInfo[h][Bank] + BizInfo[h][EnterPrice];
						}
							
						TogglePlayerControllableEx(playerid, false);
						SetPlayerPosEx(playerid, BizInfo[h][bbdXi], BizInfo[h][bbdYi], BizInfo[h][bbdZi]);
		                SetPlayerVirtualWorld(playerid, h);
		                SetPlayerInterior(playerid, BizInfo[h][IntIn]);
		                SetPVarInt(playerid, "IntEnter", 0), SetPVarInt(playerid, "BizzEnter", h), SetPVarInt(playerid, "HouseEnter", 0);
		                new msg[128];
		                format(msg, sizeof(msg), "{FFFFFF}Biz Slogan: %s", BizInfo[h][Slogan]);
		                scm(playerid, -1, msg);
		                SetTimerEx("TogglePlayerControllableEx", 1500, false, "ii", playerid, true);
		                TextDrawSetString(Text:LocationDraw[playerid], PrintArea(playerid, 0, 0));
		                if(strcmp(BizInfo[h][bRadio], "None", true) == 0){}
                        else {
                            PlayAudioStreamForPlayerEx(playerid, BizInfo[h][bRadio]);
                        }
						if(GetPVarInt(playerid, "DrugTime") == 0) {
							SetPlayerWeather(playerid, 11);
						}	

		            	Streamer_Update(playerid);
		            	return 1;
					}
					else { GameTextForPlayer(playerid, "~r~Closed", 5000, 1); }
	            }
			}
			else if(IsPlayerInRangeOfPoint(playerid, 2.0, BizInfo[h][bbdXi], BizInfo[h][bbdYi], BizInfo[h][bbdZi]) && GetPlayerVirtualWorld(playerid) == h)
			{
				if(BizInfo[h][bbdXo] == 0 && BizInfo[h][bbdYo] == 0 && BizInfo[h][bbdXo] == 0) return 1;
				TempFreeze(playerid);
                SetPlayerPosEx(playerid, BizInfo[h][bbdXo], BizInfo[h][bbdYo], BizInfo[h][bbdZo]);
                SetPlayerVirtualWorld(playerid, 0);
                SetPlayerInterior(playerid, BizInfo[h][IntOut]);
                SetPVarInt(playerid, "IntEnter", 0), SetPVarInt(playerid, "BizzEnter", 0), SetPVarInt(playerid, "HouseEnter", 0);
                StopAudioStreamForPlayerEx(playerid);
                LoadRadios(playerid);
                TextDrawSetString(Text:LocationDraw[playerid], PrintArea(playerid, 0, 0));
				if(GetPVarInt(playerid, "DrugTime") == 0) {
					SetPlayerWeather(playerid, GMWeather);
				}	

			    Streamer_Update(playerid);
			    return 1;
			}
		}
    }
	if(PlayerInfo[playerid][pInVehicle] != -1) { //Exit vehicle.
		new vInt = IsEnterableVehicle(PlayerInfo[playerid][pInVehicle]);
		if(!IsValidCar(PlayerInfo[playerid][pInVehicle]) || IsPlayerInRangeOfPoint(playerid, 2.0, VehicleInteriorPos[vInt][vIntX], VehicleInteriorPos[vInt][vIntY], VehicleInteriorPos[vInt][vIntZ])) {
			return ExitVehicleInterior(playerid);
		}		
	} else { //Enter vehicle.
		new car = PlayerToCar(playerid, 2, 5.0);
		new vInt = IsEnterableVehicle(car);
		if(vInt != -1) {
			if(!IsPlayerInAnyVehicle(playerid)) {
				new Float:x, Float:y, Float:z;
				GetVehicleRelativePos(car, x, y, z, VehicleInteriorPos[vInt][vExitX], VehicleInteriorPos[vInt][vExitY], VehicleInteriorPos[vInt][vExitZ]);
				if(IsPlayerInRangeOfPoint(playerid, 2, x, y, z)) {
					if(VehicleInfo[car][vLock] == 0) {
						GetPlayerPos(playerid, PlayerInfo[playerid][EnterVehPos][0], PlayerInfo[playerid][EnterVehPos][1], PlayerInfo[playerid][EnterVehPos][2]);
						SetPlayerPosEx(playerid, VehicleInteriorPos[vInt][vIntX], VehicleInteriorPos[vInt][vIntY], VehicleInteriorPos[vInt][vIntZ]);
						SetPlayerVirtualWorld(playerid, car);
						SetPlayerInterior(playerid, car);
						SendClientMessage(playerid, COLOR_WHITE, "Use '/exit' or click the door hotkey to leave this vehicle.");
						if(GetPVarInt(playerid, "DrugTime") == 0) { SetPlayerWeather(playerid, 11); }	
						PlayerInfo[playerid][pInVehicle] = car;
						LoadRadios(playerid);					
						return 1;
					} else SendClientMessage(playerid, COLOR_WHITE, "This vehicle is locked!");
				}
			} else SendClientMessage(playerid, COLOR_WHITE, "You can't do this while in a vehicle!");
		}
	}
	return 1;
}
//============================================//
COMMAND:stopaudio(playerid, params[])
{
    StopAudioStreamForPlayerEx(playerid);
	return 1;
}
//============================================//
COMMAND:hpm(playerid, params[])
{
	new text[128],targetid,string[255],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(GetPVarInt(playerid, "Helper") < 1 && GetPVarInt(playerid, "Admin") < 1) return nal(playerid);
	if(sscanf(params, "us[128]", targetid, text)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /hpm {FFFFFF}[playerid] [text]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") != 1) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (playerid == targetid) return SendClientMessage(playerid, COLOR_GREY, "You cannot pm yourself.");
	    if(GetPVarInt(playerid, "Admin") == 0 && GetPVarInt(targetid, "TogPM") == 1) return SendClientMessage(playerid,COLOR_GREY,"Players Private Messages are currently blocked.");
	    if(GetPVarInt(playerid, "Admin") == 0 && PlayerInfo[targetid][pBlockPM][playerid] == 1) return SendClientMessage(playerid,COLOR_GREY,"This player has disabled Private Chats from you.");
	    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_LIGHTRED, "You are currently muted!");
		if(IsPlayerConnected(targetid))
		{
		    if(GetPVarInt(targetid, "Admin") > 0 && GetPVarInt(targetid, "Admin") <= 9 && GetPVarInt(targetid, "AdminDuty") == 1 && GetPVarInt(playerid, "APMWRN") == 0)
		    {
		        SetPVarString(playerid, "APMMSG", text);
		        SetPVarInt(playerid, "APMID", targetid);
		        ShowPlayerDialog(playerid, 206, DIALOG_STYLE_MSGBOX, "PM Warning", "IMPORTANT; Administrators are usually very busy, and it is important to not spam them with useless PM's while on duty\nAre you sure you want to send this PM?", "Yes", "No");
		    }
		    else
		    {
	   		    format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
		    	format(giveplayer, sizeof(giveplayer), "%s", PlayerName(targetid));
	      		GiveNameSpace(sendername);
	        	GiveNameSpace(giveplayer);
				format(string, sizeof(string), "(( PM from [%d] %s: %s ))", playerid, AdminName(playerid), text);
				SendClientMessage(targetid,  0xF9F900FF, string);
				format(string, sizeof(string), "(( PM sent to [%d] %s: %s ))", targetid, giveplayer, text);
				SendClientMessage(playerid,  0xE5C43EAA, string);
				PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
			}
		}
	}
	return 1;
}
//============================================//
COMMAND:apm(playerid, params[])
{
	new text[128],targetid,string[256],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(GetPVarInt(playerid, "Admin") < 1) return nal(playerid);
	if(sscanf(params, "us[128]", targetid, text)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /apm {FFFFFF}[playerid] [text]");
	else
	{
	    if(GetPVarInt(playerid, "PlayerLogged") != 1) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(playerid == targetid) return SendClientMessage(playerid, COLOR_GREY, "You cannot PM yourself.");
	    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_LIGHTRED, "You are currently muted!");
		if(IsPlayerConnected(targetid)) {
   		    format(sendername, sizeof(sendername), "%s", PlayerInfo[playerid][pUsername]);
	    	format(giveplayer, sizeof(giveplayer), "%s", PlayerInfo[targetid][pUsername]);
      		GiveNameSpace(sendername);
        	GiveNameSpace(giveplayer);
			format(string, sizeof(string), "(( PM from [%d] %s: %s ))", playerid, AdminName(playerid), text);
			SendClientMessage(targetid,  0xF9F900FF, string);
			format(string, sizeof(string), "(( PM sent to [%d] %s: %s ))", targetid, giveplayer, text);
			SendClientMessage(playerid,  0xE5C43EAA, string);
			PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
			format(string, sizeof(string), "(( %s[%d] sent %s[%d]: %s ))", AdminName(playerid), playerid, giveplayer, targetid, text);
			ShowPMs(string);
			SeePM(playerid, string);
			SeePM(targetid, string);				
		}
	}
	return 1;
}
//============================================//
COMMAND:banacc(playerid, params[])
{
	if(GetPVarInt(playerid, "Admin") < 4) return nal(playerid);
	new name[24], reason[128], ip[32], string[128];
	if(sscanf(params, "s[25]s[128]S(No IP given)[32]", name, reason, ip)) SendClientMessage(playerid, -1, "USAGE: /banacc [Name] [Reason] [IP Address (optional)]");
	else
	{
		if(strlen(reason) >= 100) return SendClientMessage(playerid, -1, "Ban Reason is too long.");
		if(strlen(ip) < 3) format(ip, sizeof(ip), "No IP given");
		format(string, sizeof(string), "AdmCmd: %s was offline banned by Admin %s Reason:[%s].", name, AdminName(playerid), reason);
		SendClientMessageToAll(COLOR_LIGHTRED, string);
		BanPlayerO(name,ip,reason,AdminName(playerid));
		format(string, sizeof(string), "[BAN][OFFLINE][%s] %s", PlayerName(playerid), string);
		BanLog(string);
	}
	return 1;
}
//============================================//
ALTCOMMAND:clothing->items;
COMMAND:items(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return SendClientMessage(playerid, COLOR_GREY, "You must be on-foot.");
	ShowPlayerDialog(playerid, 296, DIALOG_STYLE_LIST, "Items menu", "Edit item\nEdit item color\nTake item off\nPut item on\nDelete item", "Select","Cancel");
	return 1;
}
//============================================//
COMMAND:carsign(playerid, params[])
{
    if(GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOR_WHITE, "You must be the driver in a vehicle to use this!");
    if(VehicleInfo[GetPlayerVehicleID(playerid)][vType] != VEHICLE_LSPD) return SendClientMessage(playerid, COLOR_WHITE, "You need to be in a police vehicle to use this.");
    if(GetPVarInt(playerid, "Delay") > GetCount()) return SendClientMessage(playerid, COLOR_LIGHTRED, "You must wait before performing this command!");
	new txt[50];
	if(sscanf(params, "s[50]", txt)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /carsign [text]");
	else
	{
	    if((GetPVarInt(playerid, "Member") == 1 && GetPVarInt(playerid, "Rank") >= 2) || GetPVarInt(playerid, "Member") == 2)
	    {
	        SetPVarInt(playerid, "Delay", GetCount()+2000);
	        new getcar = GetPlayerVehicleID(playerid);
			if(VehicleInfo[getcar][vUText] == 0) {
                VehicleInfo[getcar][vUText]=1;
                VehicleInfo[getcar][vCText] = Create3DTextLabel(txt, -1, 0.0, 0.0, 0.0, 50.0, 0, 1);
                Attach3DTextLabelToVehicle(VehicleInfo[getcar][vCText], getcar, -0.8, -2.8, -0.3);
                scm(playerid, -1, "Car sign added!");
            } else {
            VehicleInfo[getcar][vUText]=0;
            Delete3DTextLabel(VehicleInfo[getcar][vCText]);
			scm(playerid, -1, "Car sign removed!"); }
	    }
	    else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
COMMAND:enterrange(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(IsPlayerInRangeOfPoint(playerid,1.0,306.4015,-159.2461,999.5938))
    {
        GameTextForPlayer(playerid, "~w~Type /exitrange to leave.", 3000, 4);
        SetPlayerPosEx(playerid,305.2908,-159.0449,999.5938);
    }
    else SendClientMessage(playerid, COLOR_LIGHTRED, "WARNING: You are not around the shooting range.");
	return 1;
}
//============================================//
COMMAND:exitrange(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(IsPlayerInRangeOfPoint(playerid,1.0,306.4015,-159.2461,999.5938)) SetPlayerPos(playerid,306.4015,-159.2461,999.5938);
    else SendClientMessage(playerid, COLOR_LIGHTRED, "WARNING: You are not around the shooting range.");
	return 1;
}
//============================================//
ALTCOMMAND:gr->gunrack;
COMMAND:gunrack(playerid, params[])
{
	if(GetPVarInt(playerid, "Member") != 1) return SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "You need to be in a police vehicle to use this.");
	if(VehicleInfo[GetPlayerVehicleID(playerid)][vType] != VEHICLE_LSPD) return SendClientMessage(playerid, COLOR_WHITE, "You need to be in a police vehicle to use this.");
    if(GetPVarInt(playerid, "Delay") > GetCount()) return SendClientMessage(playerid, COLOR_LIGHTRED, "You must wait before performing this command!");
	if(GetPlayerVehicleSeat(playerid) != 0 && GetPlayerVehicleSeat(playerid) != 1) return SendClientMessage(playerid, COLOR_LIGHTRED, "This command can only be used in the front two seats of the vehicle.");
	if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 523 || 
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 509 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 481 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 510 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 462 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 448 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 522 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 581 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 471 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 461 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 521 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 586 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 468 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 463) return SendClientMessage(playerid, COLOR_LIGHTRED, "Motorcycles don't have a gun rack.");

	new option[64], slot;
	if(sscanf(params, "s[64]I(-1)", option, slot)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /gunrack [take/put/check]");

	if(!strcmp(option, "take"))
	{
		if(slot == -1 || slot > 2) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /gunrack [take] [1-2]");

		slot = slot-1;

		new string[128];
		if(PlayerInfo[playerid][pPlayerWeapon] != 0)
		{
		    SendClientMessage(playerid, COLOR_WHITE, "You already have a weapon equipped.");
		    return true;
		}

		if(CopInfo[GetPlayerVehicleID(playerid)][Gun_Rack_Weapon][slot] == 0)
		{
			SendClientMessage(playerid, COLOR_WHITE, "There is no gun in the gun rack.");
		    return true;
		}

		ApplyAnimation(playerid, "SILENCED", "Silence_reload", 3.0, 0, 0, 0, 0, 0);

	    GivePlayerWeaponEx(playerid, CopInfo[GetPlayerVehicleID(playerid)][Gun_Rack_Weapon][slot], CopInfo[GetPlayerVehicleID(playerid)][Gun_Rack_Ammo][slot]);
		PlayerInfo[playerid][pSerial] = CopInfo[GetPlayerVehicleID(playerid)][Gun_Rack_Serial][slot];
		
	    format(string, sizeof(string), "%s equipped from the gun rack!", PrintIName(CopInfo[GetPlayerVehicleID(playerid)][Gun_Rack_Weapon][slot]));
	    SendClientMessage(playerid, COLOR_WHITE, string);

	    CopInfo[GetPlayerVehicleID(playerid)][Gun_Rack_Weapon][slot] = 0;
		CopInfo[GetPlayerVehicleID(playerid)][Gun_Rack_Ammo][slot] = 0;
		CopInfo[GetPlayerVehicleID(playerid)][Gun_Rack_E][slot] = 0;
		CopInfo[GetPlayerVehicleID(playerid)][Gun_Rack_Serial][slot] = 0;
	    
	    CallRemoteFunction("LoadHolsters", "i", playerid);
    	SetTimerEx("FixInv", 500, false, "i", playerid);
    	SetPVarInt(playerid, "Delay", GetCount()+3000);
    	return 1;
	}
	else if(!strcmp(option, "put"))
	{
		if(slot == -1) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /gunrack [put] [1-2]");

		if(slot == 1)
		{
			slot = 0;
		}
		else if(slot == 2)
		{
			slot = 1;
		}
		else
		{
			return SendClientMessage(playerid, COLOR_GREY, "USAGE: /gunrack [put] [1-2]");
		}

		new string[128];
		if(PlayerInfo[playerid][pPlayerWeapon] == 0)
		{
		    SendClientMessage(playerid, COLOR_WHITE, "You don't have a weapon equipped.");
		    return true;
		}

		if(CopInfo[GetPlayerVehicleID(playerid)][Gun_Rack_Weapon][slot] != 0)
		{
			SendClientMessage(playerid, COLOR_WHITE, "There is already a weapon in the gunrack.");
		    return true;
		}

		CopInfo[GetPlayerVehicleID(playerid)][Gun_Rack_Weapon][slot] = PlayerInfo[playerid][pPlayerWeapon];
		CopInfo[GetPlayerVehicleID(playerid)][Gun_Rack_Ammo][slot] = PlayerInfo[playerid][pPlayerAmmo];
		CopInfo[GetPlayerVehicleID(playerid)][Gun_Rack_Serial][slot] = PlayerInfo[playerid][pSerial];

	    format(string, sizeof(string), "%s stored in the gun rack!", PrintIName(CopInfo[GetPlayerVehicleID(playerid)][Gun_Rack_Weapon][slot]));
	    SendClientMessage(playerid, COLOR_WHITE, string);

	    ResetPlayerWeaponsEx(playerid);
		PlayerInfo[playerid][pPlayerWeapon] = 0;
		PlayerInfo[playerid][pPlayerAmmo] = 0;
		PlayerInfo[playerid][pSerial] = 0;

		RemovePlayerAttachedObject(playerid, 9);
		SetPVarInt(playerid, "JustChosen", 0);
		CallRemoteFunction("LoadHolsters","i",playerid);
        RemovePlayerAttachedObject(playerid, 9);
        SetPVarInt(playerid, "Delay", GetCount()+3000);
        return 1;
	}
	if(!strcmp(option, "check"))
	{
		new string[128];
		if(CopInfo[GetPlayerVehicleID(playerid)][Gun_Rack_Weapon][0] != 0)
		{
			format(string, sizeof(string), "1: %s (%i):[%s]", 
				PrintIName(CopInfo[GetPlayerVehicleID(playerid)][Gun_Rack_Weapon][0]), 
				CopInfo[GetPlayerVehicleID(playerid)][Gun_Rack_Ammo][0], 
				PrintIName(CopInfo[GetPlayerVehicleID(playerid)][Gun_Rack_E][0]));
		}
		else
		{
			format(string, sizeof(string), "1: EMPTY SLOT");
		}
		SendClientMessage(playerid, COLOR_WHITE, string);
		if(CopInfo[GetPlayerVehicleID(playerid)][Gun_Rack_Weapon][1] != 0)
		{
			format(string, sizeof(string), "2: %s (%i):[%s]", 
				PrintIName(CopInfo[GetPlayerVehicleID(playerid)][Gun_Rack_Weapon][1]), 
				CopInfo[GetPlayerVehicleID(playerid)][Gun_Rack_Ammo][1], 
				PrintIName(CopInfo[GetPlayerVehicleID(playerid)][Gun_Rack_E][1]));
		}
		else
		{
			format(string, sizeof(string), "2: EMPTY SLOT");
		}
		SendClientMessage(playerid, COLOR_WHITE, string);
		return 1;
	}
	else
	{
		SendClientMessage(playerid, COLOR_GREY, "USAGE: /gunrack [take/put/check]");
	}
	return 1;
}
//============================================//
COMMAND:ram(playerid, params[])
{
	if(GetPVarInt(playerid, "Member") != 1) return nal(playerid);
	if(GetPVarInt(playerid, "Duty") != 1) return error(playerid, "You are not on duty.");
  	for(new h = 1; h < MAX_HOUSES; h++)
	{
	    if(HouseInfo[h][hID] != 0)
	    {
	        if(IsPlayerInRangeOfPoint(playerid, 2.0, HouseInfo[h][hXo], HouseInfo[h][hYo], HouseInfo[h][hZo]) && GetPlayerVirtualWorld(playerid) == HouseInfo[h][hVwOut])
	        {
	            if(HouseInfo[h][hOwned] != 0)
	            {
	                if(HouseInfo[h][hLocked] == 1)
	                {
	                    scm(playerid, COLOR_LIGHTRED, "House has been rammed open!");
			            scm(playerid, COLOR_LIGHTRED, "Abusing this command will lead to a ban!");
	                    HouseInfo[h][hLocked]=0;
	                }
	                else return error(playerid, "House is not locked.");
				}
				else return error(playerid, "House is not owned by anyone.");
			}
		}
	}
	foreach(new h : BizIterator)
	{
	    if(BizInfo[h][ID] != 0)
		{
		    if(IsPlayerInRangeOfPoint(playerid, 2.0, BizInfo[h][Xo], BizInfo[h][Yo], BizInfo[h][Zo]))
			{
			    if(BizInfo[h][Owned] != 0)
			    {
			        if(BizInfo[h][Locked] == 1)
			        {
			            BizInfo[h][Locked]=0;
			            scm(playerid, COLOR_LIGHTRED, "Business has been rammed open!");
			            scm(playerid, COLOR_LIGHTRED, "Abusing this command will lead to a ban!");
				    }
				    else scm(playerid, COLOR_LIGHTRED, "Business is not locked!");
			    }
		    }
	    }
    }
	return 1;
}
//============================================//
COMMAND:apb(playerid, params[])
{
	if(GetPVarInt(playerid, "Member") != 1) return nal(playerid);
	if(GetPVarInt(playerid, "Duty") != 1) return error(playerid, "You are not on duty.");
	ShowPlayerDialog(playerid, 405, DIALOG_STYLE_LIST, "APB - {CCCCCC}(Select Option)", "View list\nAdd APB\nRemove APB","Select","Cancel");
	return 1;
}
//============================================//
COMMAND:announce(playerid, params[])
{
	new text[128],string[128],sendername[MAX_PLAYER_NAME];
	if(sscanf(params, "s[128]", text)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /announce [text]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_LIGHTRED, "You are currently muted!");
	    if (GetPVarInt(playerid, "Member") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be in a faction to use this.");
   		format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
      	GiveNameSpace(sendername);
      	switch(GetPVarInt(playerid, "Member"))
      	{
      		case 3: // RLS
			{
			    format(string, sizeof(string), "* [RLS]: %s: %s *", sendername, text);
			    SendRadioMessage(0x458E1DAA, string);
			}
      	    case 4: // San News
			{
			    format(string, sizeof(string), "* [San News] %s: %s *", sendername, text);
			    SendNewsMessage(0x458E1DAA, string);
			}
      	}
	}
	return 1;
}
//============================================//
COMMAND:live(playerid, params[])
{
	new targetid,string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "u", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /live [playerid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_LIGHTRED, "You are currently muted!");
	    if (playerid == targetid) return SendClientMessage(playerid, COLOR_GREY, "You cannot pay to yourself.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
		if(GetPVarInt(playerid, "Member") == 3 || GetPVarInt(playerid, "Member") == 4)
		{
			if(PlayerToPlayer(playerid,targetid,3.0))
   			{
   			    format(sendername, sizeof(sendername), "%s", PlayerName(playerid));
      			format(giveplayer, sizeof(giveplayer), "%s", PlayerName(targetid));
      			GiveNameSpace(sendername);
      			GiveNameSpace(giveplayer);
      			SetPVarInt(targetid, "LiveOffer", playerid);
				switch(GetPVarInt(playerid, "Member"))
				{
					case 3:
				    {
				        if(PlayerInfo[playerid][pLiveOffer][1] == 1
						&& PlayerInfo[targetid][pLiveOffer][1] == 1)
				        {
				            PlayerInfo[playerid][pLiveOffer][1] = 0; PlayerInfo[targetid][pLiveOffer][1] = 0;
				            SendClientMessage(playerid,COLOR_WHITE,"Broadcast has ended.");
				            SendClientMessage(targetid,COLOR_WHITE,"Broadcast has ended.");
				            return true;
						}
						if(PlayerInfo[playerid][pLiveOffer][1] == 1)
				        {
				            PlayerInfo[playerid][pLiveOffer][1] = 0;
				            SendClientMessage(playerid,COLOR_WHITE,"Broadcast has ended.");
							return true;
						}
						if(PlayerInfo[targetid][pLiveOffer][1] == 1)
				        {
				            PlayerInfo[targetid][pLiveOffer][1] = 0;
				            SendClientMessage(targetid,COLOR_WHITE,"Broadcast has ended.");
				            return true;
						}
						format(string, sizeof(string),"You gave %s a live offer on Radio Los Santos.", giveplayer);
				        SendClientMessage(playerid,COLOR_LIGHTRED,string);
				        format(string, sizeof(string),"%s offered a live offer on Radio Los Santos (/accept live).", sendername);
				        SendClientMessage(targetid,COLOR_LIGHTRED,string);
				    }
				    case 4:
				    {
				        if(PlayerInfo[playerid][pLiveOffer][0] == 1
					    && PlayerInfo[targetid][pLiveOffer][0] == 1)
                        {
				            PlayerInfo[playerid][pLiveOffer][0] = 0; PlayerInfo[targetid][pLiveOffer][0] = 0;
				            SendClientMessage(playerid,COLOR_WHITE,"News Broadcast has ended.");
				            SendClientMessage(targetid,COLOR_WHITE,"News Broadcast has ended.");
				            return true;
				        }
				        if(PlayerInfo[playerid][pLiveOffer][0] == 1)
                        {
				            PlayerInfo[playerid][pLiveOffer][0] = 0;
				            SendClientMessage(playerid,COLOR_WHITE,"News Broadcast has ended.");
				            return true;
				        }
				        if(PlayerInfo[targetid][pLiveOffer][0] == 1)
                        {
				            PlayerInfo[targetid][pLiveOffer][0] = 0;
				            SendClientMessage(targetid,COLOR_WHITE,"News Broadcast has ended.");
				            return true;
				        }
				        format(string, sizeof(string),"You gave %s a live offer on san news.", giveplayer);
				        SendClientMessage(playerid,COLOR_LIGHTRED,string);
				        format(string, sizeof(string),"%s offered a live offer on san news (/accept live).", sendername);
				        SendClientMessage(targetid,COLOR_LIGHTRED,string);
				    }
				}
      		}
      		else SendClientMessage(playerid, COLOR_GREY, "You are not close to this player.");
		}
		else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}

COMMAND:fixitems(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_LIGHTRED, "You are currently muted!");
    FixItems(playerid);
	return 1;
}

COMMAND:event(playerid, params[])
{
	if(GetPVarInt(playerid, "Admin") <= 9) return 1;
	new num;
	if(sscanf(params, "i", num))
	{
	    SendClientMessage(playerid, COLOR_GREY, "USAGE: /event [id]");
	    SendClientMessage(playerid, COLOR_GREY, "0: Remove any existing event.");
	    SendClientMessage(playerid, COLOR_GREY, "1: Double Hours Event!");
		SendClientMessage(playerid, COLOR_GREY, "2: Double Pay-check Event!");
		SendClientMessage(playerid, COLOR_GREY, "3: Double Pay-check/Hours Event!");
	}
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    Event=num;
	    switch(num)
	    {
			case 1:
			{
			    SendRconCommand("hostname Diverse Roleplay 0.3.7 -| Double Hours! |-");
			}
			case 2:
			{
				SendRconCommand("hostname Diverse Roleplay 0.3.7 -| Double Payday! |-");
			}
			case 3:
			{
				SendRconCommand("hostname Diverse Roleplay 0.3.7 -| Double Payday/Hours! |-");
			}
	        default:
	        {
	            SendRconCommand("hostname Diverse Roleplay 0.3.7");
	            Event=0;
	        }
	    }
	}
	return 1;
}
//============================================//
COMMAND:tag(playerid, params[])
{
	if(GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_LIGHTRED, "You are currently muted!");
	if(GetPlayerVirtualWorld(playerid) != 0 || GetPlayerInterior(playerid) != 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You can't do this in interiors!");
	new member = GetPVarInt(playerid, "Member");
	if(member == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be in a faction to use this.");
	if((member == 1 || member == 2 || member == 3 || member == 4 || member == 5 || member == 8) && GetPVarInt(playerid, "Admin") <= 3) return SendClientMessage(playerid, COLOR_WHITE, "You must be in a non-default faction to use this. (Cops, etc can't spraypaint.)");
	if(GetPlayerWeapon(playerid) != 41 && PlayerInfo[playerid][pPlayerWeapon] != 41) return SendClientMessage(playerid, COLOR_LIGHTRED, "You must be holding a spray-can!");
	SprayTag_Dialog(playerid, TYPE_LIST_MENU);
	return 1;
}
//============================================//
ALTCOMMAND:silence->silencer;
COMMAND:silencer(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if (IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_LIGHTRED, "You can't be in a vehicle while you use this!");
    if(GetPVarInt(playerid, "LSPD_Ta") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
	switch(PlayerInfo[playerid][pPlayerWeapon])
	{
		case 22:
		{
			if (!CheckInvItem(playerid, 1002)) return SendClientMessage(playerid, COLOR_WHITE, "You don't have a silencer.");
			ApplyAnimation(playerid, "SILENCED", "Silence_reload", 3.0, 0, 0, 0, 0, 0);
			SendClientMessage(playerid, COLOR_WHITE, "Silencer attached.");		
			new Ammo = GetPlayerAmmo(playerid);
			new serial = PlayerInfo[playerid][pSerial];
			ResetPlayerWeapons(playerid);
			GivePlayerWeaponEx(playerid,23,Ammo);
			PlayerInfo[playerid][pSerial] = serial;
			RemoveInvItem(playerid, 1002);
		}
		case 23:
		{
			ApplyAnimation(playerid, "SILENCED", "Silence_reload", 3.0, 0, 0, 0, 0, 0);
    	    SendClientMessage(playerid, COLOR_WHITE, "Silencer detached.");
			new Ammo = GetPlayerAmmo(playerid);
			new serial = PlayerInfo[playerid][pSerial];
			ResetPlayerWeapons(playerid);
			GivePlayerWeaponEx(playerid,22,Ammo);
			PlayerInfo[playerid][pSerial] = serial;
			GiveInvItem(playerid, 1002, 1, 0);
		}
		default: SendClientMessage(playerid,COLOR_GREY,"Only M1911s can be silenced.");
	}
	return 1;
}
//============================================//
COMMAND:setfare(playerid, params[])
{
	new type, string[128];
	if(sscanf(params, "i", type))
	{
	    SendClientMessage(playerid, COLOR_WHITE, "USAGE: /setfare [0-25]");
	    SendClientMessage(playerid, COLOR_GREY, "Note: The player will be charged every ten seconds of the amount chosen.");
	}
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(type < 0 || type > 25) return SendClientMessage(playerid, COLOR_GREY, "Cannot go under 0 or above 25.");
		if(GetPVarInt(playerid, "Job") == 5 && GetPVarInt(playerid, "OnRoute") != 0)
		{
			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER && VehicleInfo[GetPlayerVehicleID(playerid)][vType] == VEHICLE_JOB)
			{
      			SetPVarInt(playerid, "TaxiFare", type);
      			format(string, sizeof(string),"You set the taxi fare to $%d.", type);
      			SendClientMessage(playerid,COLOR_GREY,string);
      			foreach(new i : Player)
	            {
	               if(GetPlayerVehicleID(i) == GetPlayerVehicleID(playerid))
	               {
	                  if(GetPlayerState(i) == PLAYER_STATE_PASSENGER)
	                  {
                          InitiateFare(i);
	                  }
	              }
	           }
      		}
		}
		else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command !");
	}
	return 1;
}
//============================================//
COMMAND:putciggy(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if (IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_LIGHTRED, "You can't be in a vehicle while you use this!");
    if(GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_SMOKE_CIGGY) return SendClientMessage(playerid, COLOR_GREY, "You do not have a ciggy.");
    if(GetPVarInt(playerid, "Delay") > GetCount()) return SendClientMessage(playerid, COLOR_LIGHTRED, "You must wait before performing this command!");
    if(GetPlayerPing(playerid) >= 500) return SendClientMessage(playerid, COLOR_WHITE, "Your ping is too high to do this command!");
    GiveInvItem(playerid, 300, 1, 0);
    SendClientMessage(playerid,COLOR_GREY,"{999999}{FFFFFF}Ciggy {999999}placed into your inventory.");
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
    SetPVarInt(playerid, "Delay", GetCount()+3000);
    DeletePVar(playerid,"MouthCig");
	return 1;
}

COMMAND:takeciggy(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if (!CheckInvItem(playerid, 300)) return SendClientMessage(playerid, COLOR_GREY, "You don't have this item in your inventory.");
    if (IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_LIGHTRED, "You can't be in a vehicle while you use this!");
    if(GetPVarInt(playerid, "Delay") > GetCount()) return SendClientMessage(playerid, COLOR_LIGHTRED, "You must wait before performing this command!");
    RemoveInvItem(playerid, 300);
    SendClientMessage(playerid,COLOR_GREY,"{999999}{FFFFFF}Ciggy {999999}taken from your inventory.");
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_SMOKE_CIGGY);
    SendClientMessage(playerid,COLOR_WHITE,"Type (/ciggy) to place your ciggy on your mouth or hand.");
    SetPVarInt(playerid, "Delay", GetCount()+3000);
	return 1;
}

COMMAND:ciggy(playerid, params[])
{
	new type[30], string[128], sendername[MAX_PLAYER_NAME];
	if(sscanf(params, "s[30]", type)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /ciggy [mouth / hand]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
        if(GetPVarInt(playerid, "Control") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are currently frozen!");
        format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
		GiveNameSpace(sendername);
	    if(strcmp(type, "mouth", true) == 0)
	    {
	        if(GetPVarInt(playerid,"MouthCig") == 1) return SendClientMessage(playerid,COLOR_GREY,"You already have a ciggy in your mouth.");
	        if(GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_SMOKE_CIGGY) return SendClientMessage(playerid,COLOR_GREY,"You don't have a ciggy in your hand.");
	        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	        SetPlayerAttachedObject(playerid, HOLDOBJECT_PHONE, 3044, 2, -0.057326, 0.026202, 0.000000, 172.549285, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
	        SendClientMessage(playerid,COLOR_WHITE,"Type (/ciggy hand) to remove the cigar from your mouth.");
	        SetPVarInt(playerid,"MouthCig",1);
	        format(string, sizeof(string), "* %s places %s ciggy into %s mouth.", sendername, CheckSex(playerid), CheckSex(playerid));
    	    ProxDetector(30.0, playerid, string, COLOR_PURPLE);
	    }
	    else if(strcmp(type, "hand", true) == 0)
	    {
            if(GetPlayerSpecialAction(playerid)== SPECIAL_ACTION_SMOKE_CIGGY) return SendClientMessage(playerid,COLOR_GREY,"You already have a ciggy in your hand.");
            if(GetPVarInt(playerid,"MouthCig") == 0) return SendClientMessage(playerid,COLOR_GREY,"You don't have a ciggy in your mouth.");
            DeletePVar(playerid,"MouthCig");
            RemovePlayerAttachedObject(playerid, HOLDOBJECT_PHONE);
            SetPlayerSpecialAction(playerid, SPECIAL_ACTION_SMOKE_CIGGY);
            format(string, sizeof(string), "* %s places %s ciggy into %s hand.", sendername, CheckSex(playerid), CheckSex(playerid));
    	    ProxDetector(30.0, playerid, string, COLOR_PURPLE);
	    }
	}
	return 1;
}

COMMAND:mask(playerid, params[])
{
	new string[128];
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "ConnectTime") <= 55) return SendClientMessage(playerid, COLOR_LIGHTRED, "You need (56) and over hours played!");
    if (!CheckInvItem(playerid, 401)) return SendClientMessage(playerid, COLOR_WHITE, "You don't have a mask.");
	switch(GetPVarInt(playerid, "MaskUse"))
    {
        case 0:
        {
            SetPVarInt(playerid, "MaskUse", 1);
            GameTextForPlayer(playerid, "~w~Mask ~g~On", 5000, 6);
            format(string, sizeof(string),"%s", PlayerNameEx(playerid));
            PlayerTag[playerid] = Create3DTextLabel("NULL",0xFFFFFFFF,0.0,0.0,0.0,15.0,0,1);
            Attach3DTextLabelToPlayer(PlayerTag[playerid], playerid, 0.0, 0.0, 0.1);
	        Update3DTextLabelText(PlayerTag[playerid], 0xFFFFFFFF,string);
	        foreach(new i : Player) {
		        if(GetPVarInt(i, "Admin") < 1) {
		            ShowPlayerNameTagForPlayer(i,playerid,0);
		        }
		    }
	        return true;
        }
        case 1:
        {
            SetPVarInt(playerid, "MaskUse", 0);
            GameTextForPlayer(playerid, "~w~Mask ~r~Off", 5000, 6);
            Delete3DTextLabel(PlayerTag[playerid]);
            foreach(new i : Player) {
		        ShowPlayerNameTagForPlayer(i,playerid,1);
		    }
	        return true;
        }
    }
    return 1;
}
//============================================//
COMMAND:tapwater(playerid, params[])
{
    new string[128], sendername[MAX_PLAYER_NAME], Float:health, found = 0;
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while dead!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_LIGHTRED, "You are currently muted!");
    if(GetPVarInt(playerid, "Delay") > GetCount()) return SendClientMessage(playerid, COLOR_LIGHTRED, "You must wait before performing this command!");
    GetPlayerHealth(playerid,health);
	for(new h = 0; h < sizeof(HouseInfo); h++)
	{
	    if(IsPlayerInRangeOfPoint(playerid,20.0,HouseInfo[h][hXi], HouseInfo[h][hYi], HouseInfo[h][hZi]))
	    {
	        if(GetPVarInt(playerid, "HouseEnter") == h)
	        {
				if(GetPlayerVirtualWorld(playerid) == h)
				{
				    found++;
					if(GetPlayerMoneyEx(playerid) >= 10)
					{
					    if(health >= 99) return SendClientMessage(playerid,COLOR_GREY,"Health is too full.");
					    format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
					    GiveNameSpace(sendername);
    				    format(string, sizeof(string), "*** %s drinks from the tap water.", sendername);
    				    ProxDetector(30.0, playerid, string, COLOR_PURPLE);
					    GivePlayerMoneyEx(playerid,-10);
					    SetPlayerHealth(playerid,health+40.0);
					    GameTextForPlayer(playerid, "~r~-$10", 5000, 1);
					    ApplyAnimation(playerid, "GANGS", "drnkbr_prtl", 3.0, 0, 0, 0, 0, 0);
					    SetPVarInt(playerid, "Delay", GetCount()+2000);
					}
					else SendClientMessage(playerid, COLOR_LIGHTRED, "Insufficient funds!");
	            }
	        }
	    }
	}
	if(found == 0) {
		scm(playerid, -1, "You are not near a house door."); }
	return 1;
}

COMMAND:lights(playerid, params[])
{
    new string[128], sendername[MAX_PLAYER_NAME], found = 0;
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while dead!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_LIGHTRED, "You are currently muted!");
    if(GetPVarInt(playerid, "Delay") > GetCount()) return SendClientMessage(playerid, COLOR_LIGHTRED, "You must wait before performing this command!");
	for(new h = 0; h < sizeof(HouseInfo); h++)
	{
	    if(IsPlayerInRangeOfPoint(playerid,5.0,HouseInfo[h][hXi], HouseInfo[h][hYi], HouseInfo[h][hZi]))
	    {
	        if(GetPVarInt(playerid, "HouseEnter"))
	        {
				if(GetPlayerVirtualWorld(playerid) == h && found == 0)
				{
				    format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
					GiveNameSpace(sendername);
					if(HouseInfo[h][hLights] == 0) { HouseInfo[h][hLights]=1, format(string, sizeof(string), "*** %s turns the lights off.", sendername); }
					else { HouseInfo[h][hLights]=0, format(string, sizeof(string), "*** %s turns the lights on.", sendername); }
    				ProxDetector(30.0, playerid, string, COLOR_PURPLE);
    				HouseLights(h);
    				SetPVarInt(playerid, "Delay", GetCount()+2000);
    				found++;
	            }
	        }
	    }
	}
	if(found == 0) {
		scm(playerid, -1, "You are not near a house door."); }
	return 1;
}
//============================================//
COMMAND:togpm(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    switch(GetPVarInt(playerid, "TogPM"))
    {
        case 0:
        {
            SetPVarInt(playerid, "TogPM", 1);
            SendClientMessage(playerid, COLOR_GREY, "Private Messages disabled!");
        }
        case 1:
        {
            SetPVarInt(playerid, "TogPM", 0);
            SendClientMessage(playerid, COLOR_GREY, "Private Messages enabled!");
        }
		default:
        {
            SetPVarInt(playerid, "TogPM", 1);
            SendClientMessage(playerid, COLOR_GREY, "Private Messages disabled!");
        }
    }
    return 1;
}

COMMAND:togb(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "TogB") == 0)
	{
 	    SetPVarInt(playerid, "TogB", 1);
 	    SCM(playerid, -1, "Local-OOC Chat toggled OFF.");
	}
	else
	{
	    SetPVarInt(playerid, "TogB", 0);
		SCM(playerid, -1, "Local-OOC Chat toggled ON.");
	}
    return 1;
}
//============================================//
COMMAND:call(playerid, params[])
{
    if (GetPVarInt(playerid, "Cuffed") > 0) return SendClientMessage(playerid, COLOR_GREY, "You can't do this while handcuffed/tazed.");
	if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_LIGHTRED, "You are currently muted!");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while dead!");
	new inputtext[64];
	if(sscanf(params, "s[64]", inputtext)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /call [contactname/number]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not logged in.");
	    if(!CheckInvItem(playerid, 405)) return SendClientMessage(playerid, COLOR_WHITE, "You don't have a cellphone.");
	    if(GetPVarInt(playerid, "TogPhone") == 1) return SendClientMessage(playerid, COLOR_WHITE, "Your phone is off.");
	    new found = 0, contactname[40], contactnumber[40], cname[50];
	    for(new i = 1; i < 11; i++)
		{
			format(contactname, sizeof(contactname), "ContactName%d", i);			
			GetPVarString(playerid, contactname, cname, 50);
			if(strmatch(inputtext, cname)) {
				found++;
				format(contactnumber, sizeof(contactnumber), "ContactNumber%d", i);
				format(inputtext, sizeof(inputtext), "%d", GetPVarInt(playerid, contactnumber));
				CallNumber(playerid, inputtext);
				return 1;
			}
		}
		if(found == 0)
		{
		    new amount = strval(inputtext);
		    if(amount <= 0 || amount >= 99999999) return scm(playerid, -1, "Invalid number!");
		    CallNumber(playerid, inputtext);
		}
	}
	return 1;
}

ALTCOMMAND:text->sms;
COMMAND:sms(playerid, params[])
{
    if(GetPVarInt(playerid, "Cuffed") > 0) return SendClientMessage(playerid, COLOR_GREY, "You can't do this while handcuffed/tazed.");
	if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_LIGHTRED, "You are currently muted!");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while dead!");
	new inputtext[64], text[128];
	if(sscanf(params, "s[64]s[128]", inputtext, text)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /sms [contactname/number] [text]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not logged in.");
	    if(!CheckInvItem(playerid, 405)) return SendClientMessage(playerid, COLOR_WHITE, "You don't have a cellphone.");
	    if(GetPVarInt(playerid, "TogPhone") == 1) return SendClientMessage(playerid, COLOR_WHITE, "Your phone is off.");
	    new found = 0, contactname[40], contactnumber[40], cname[50];
	    for(new i = 1; i < 11; i++) {
			format(contactname, sizeof(contactname), "ContactName%d", i);
			GetPVarString(playerid, contactname, cname, 50);
			if(strmatch(inputtext, cname)) {
				found++;
				format(contactnumber, sizeof(contactnumber), "ContactNumber%d", i);
				format(PlayerInfo[playerid][pCellname], 84, "%s", GetPVarInt(playerid, contactnumber));
				SmsNumber(playerid, text);
				return 1;
			}
		}
		if(found == 0) {
		    new amount = strval(inputtext);
		    if(amount <= 0 || amount >= 99999999) return scm(playerid, -1, "Invalid number!");
			format(PlayerInfo[playerid][pCellname], 84, "%s", inputtext);
		    SmsNumber(playerid, text);
		}
	}
	return 1;
}

COMMAND:contacts(playerid, params[])
{
	if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not logged in.");
	if(!CheckInvItem(playerid, 405)) return SendClientMessage(playerid, COLOR_WHITE, "You don't have a cellphone.");
    if(GetPVarInt(playerid, "TogPhone") == 1) return SendClientMessage(playerid, COLOR_WHITE, "Your phone is off.");
	new diatxt[128], contactname[40], contactnumber[40], cname[50];
	scm(playerid, -1, "Phone Contacts:");
	for(new i = 1; i < 11; i++)
	{
	    if(i != 11)
		{
		    format(contactname, sizeof(contactname), "ContactName%d", i);
			format(contactnumber, sizeof(contactnumber), "ContactNumber%d", i);
			GetPVarString(playerid, contactname, cname, 50);
			if(strlen(cname) < 2) format(cname, sizeof(cname), "None");
			format(diatxt, sizeof(diatxt), "{FFFFFF}%s {33FF66}(%d)", cname, GetPVarInt(playerid, contactnumber));
			scm(playerid, -1, diatxt);
	    }
	}
	return 1;
}

ALTCOMMAND:h->hangup;
COMMAND:hangup(playerid, params[])
{
	if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not logged in.");
    if(GetPVarInt(playerid, "Mobile") != INVALID_MAXPL)
    {
        if(GetPVarInt(playerid, "Mobile") < INVALID_MAXPL)
        {
            SendClientMessage(playerid, COLOR_GREY, "You hung up.");
            SendClientMessage(GetPVarInt(playerid, "Mobile"), COLOR_GREY, "The person on the other line has ended the call.");
            if(GetPVarInt(GetPVarInt(playerid, "Mobile"), "CellMenu") == 0) CellphoneState(GetPVarInt(playerid, "Mobile"),2);
            SetPVarInt(GetPVarInt(playerid, "Mobile"), "Mobile", INVALID_MAXPL);
            SetPVarInt(GetPVarInt(playerid, "Mobile"), "RingTone", 0);
            SetPVarInt(GetPVarInt(playerid, "Mobile"), "RingPhone", 0);
            CellphoneState(playerid,2);
      	    if(GetPVarInt(GetPVarInt(playerid, "Mobile"), "PayPhone") > 0)
      	    {
			    TogglePlayerControllableEx(GetPVarInt(playerid, "Mobile"),true);
				DeletePVar(GetPVarInt(playerid, "Mobile"),"PayPhone");
                DeletePVar(GetPVarInt(playerid, "Mobile"),"PhoneID");
		    }
		    CallRemoteFunction("LoadRadios","i", playerid);
		    CallRemoteFunction("LoadRadios","i", GetPVarInt(playerid, "Mobile"));
		    SetPVarInt(playerid, "Mobile", INVALID_MAXPL); // Disable the phone call.
		    SetPVarInt(playerid, "RingPhone", 0);
			cancelPayphone(playerid);
		    return 1;
	    }
    }
    foreach(new i : Player)
    {
        if(GetPVarInt(i, "Mobile") == playerid)
        {
            SetPVarInt(i, "RingTone", 0);
            SetPVarInt(i, "RingPhone", 0);
            SetPVarInt(i, "Mobile", INVALID_MAXPL); // Disable the phone call.
			cancelPayphone(i);
            SendClientMessage(i, COLOR_GREY, "They hung up.");
	        if(GetPVarInt(i, "CellMenu") == 0)
	        {
			    CellphoneState(i,2);
		    }
		    CallRemoteFunction("LoadRadios","i", i);
        }
    }
    SetPVarInt(playerid, "RingTone", 0);
    SetPVarInt(playerid, "RingPhone", 0);
    SetPVarInt(playerid, "Mobile", INVALID_MAXPL); // Disable the phone call.
	cancelPayphone(playerid);
	CellphoneState(playerid,2);
	CallRemoteFunction("LoadRadios","i", playerid);
	return 1;
}
//============================================//
COMMAND:wireplayer(playerid, params[])
{
	new targetid,choose[30],string[128],giveplayer[MAX_PLAYER_NAME];
	if(GetPVarInt(playerid, "Duty") != 1 && IsACop(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "You are not on duty!");
	if(sscanf(params, "us[30]", targetid, choose)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /wireplayer [playerid] [on/off]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (playerid == targetid) return SendClientMessage(playerid, COLOR_GREY, "You cannot wire yourself.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
		if(IsACop(playerid))
		{
			if(GetPVarInt(playerid, "Rank") >= 4)
			{
		        if(PlayerToPlayer(playerid,targetid,3.0))
		        {
		            format(giveplayer, sizeof(giveplayer), "%s", PlayerName(targetid));
		            GiveNameSpace(giveplayer);
        	        if(strcmp(choose, "on", true) == 0)
        	        {
        	            format(string, sizeof(string), "Wire placed onto %s.", giveplayer);
        	            SendClientMessage(playerid, COLOR_WHITE, string);
    	                SetPVarInt(targetid, "TrackBug", 1);
    	                SetPVarInt(targetid, "TrackBugPL", playerid);
        	        }
        	        else if(strcmp(choose, "off", true) == 0)
        	        {
        	            format(string, sizeof(string), "Wire removed off of %s.", giveplayer);
        	            SendClientMessage(playerid, COLOR_WHITE, string);
    	                DeletePVar(targetid,"TrackBug");
    	                DeletePVar(targetid,"TrackBugPL");
        	        }
    	        }
    	        else SendClientMessage(playerid,COLOR_GREY,"You are not close enough to that player!");
    	    }
    	    else SendClientMessage(playerid,COLOR_GREY,"You aren't high enough rank to perform this command!");
		}
	}
	return 1;
}

COMMAND:wireoff(playerid, params[])
{
	new string[128],sendername[MAX_PLAYER_NAME];
	if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	if (GetPVarInt(playerid, "TrackBug") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You do not have a wire on.");
	format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
    format(string, sizeof(string), "*** %s takes the wire off.", sendername);
    ProxDetector(30.0, playerid, string, COLOR_PURPLE);
    if(IsPlayerConnected(GetPVarInt(playerid, "TrackBugPL"))) SendClientMessage(GetPVarInt(playerid, "TrackBugPL"), COLOR_LIGHTRED,"** (MOLE) You hear static noise as the wire signal stops **");
    DeletePVar(playerid,"TrackBug");
    DeletePVar(playerid,"TrackBugPL");
	return 1;
}

COMMAND:tracephone(playerid, params[])
{
	new number, Float:X, Float:Y, Float:Z;
	if(sscanf(params, "i", number)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /tracephone {FFFFFF}[number]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_LIGHTRED, "You are currently muted!");
	    if (number == GetPVarInt(playerid, "PhoneNum")) return SendClientMessage(playerid, COLOR_GREY, "You cannot trace yourself.");
        if(GetPVarInt(playerid, "Jailed") > 0) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-jail.");
        if(!IsACop(playerid)) return SendClientMessage(playerid,COLOR_LIGHTRED,"You do not have access to this command.");
        if(GetPVarInt(playerid, "Rank") < 4) return SendClientMessage(playerid,COLOR_LIGHTRED,"You do not have access to this command.");
        if(GetPVarInt(playerid, "PhoneDelay") > GetCount()) return SendClientMessage(playerid, COLOR_LIGHTRED, "You must wait before performing this command!");
      	new found = 0;
		foreach(new i : Player)
		{
		    if(GetPVarInt(i, "PlayerLogged") == 1)
		    {
				if(GetPVarInt(i, "PhoneNum") == number)
				{
                    if (GetPVarInt(i, "TogPhone") == 1) return SendPhoneMessage(playerid);
                    if (GetPVarInt(i, "Dead") > 0) return SendPhoneMessage(playerid);
                    if(GetPVarInt(i, "Jailed") > 0) return SendPhoneMessage(playerid);
	                if(GetPlayerInterior(i) != 0) return SendPhoneMessage(playerid);
	                if(GetPlayerVirtualWorld(i) != 0) return SendPhoneMessage(playerid);
					found = 1;
      	            SendClientMessage(playerid, COLOR_WHITE, "Phone traced on your GPS.");
      	            GetPlayerPos(i,X,Y,Z);
      	            SetPlayerCheckpoint(playerid,X,Y,Z,5.0);
      	            SetPVarInt(playerid, "PhoneDelay", GetCount()+10000);
		        }
		    }
		}
		if(found == 0) return SendClientMessage(playerid, COLOR_GREY, "Couldn't find anyone with that number online.");
	}
	return 1;
}
//============================================//
ALTCOMMAND:doorlock->lockdoor;
COMMAND:lockdoor(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    if(GetPVarInt(playerid, "Cuffed") != 0) return SendClientMessage(playerid, COLOR_WHITE, "You are not able to use this!");
    new foundid = -1;
    if(GetPVarInt(playerid,"HouseEnter") != 0)
	{
		new key = FurnRight(playerid, 1);
		if(key > 0) {
            for(new h = 0; h < MAX_HOUSE_OBJ; h++)
            {
                if(HouseInfo[key][hObject][h] != 0)
		        {
		            if(IsPlayerInRangeOfPoint(playerid, 3.0, HouseInfo[key][hoX][h], HouseInfo[key][hoY][h], HouseInfo[key][hoZ][h]))
		            {
                        if(IsDoorObject(HouseInfo[key][hoID][h]))
                	    {
							foundid=h;
							break;
		        	    }
		            }
                }
            }
	        if(foundid == -1) { SCM(playerid, COLOR_LIGHTRED, "ERROR: Can't find any door!"); }
	        else
	        {
				switch(HouseInfo[key][Locked][foundid])
				{
					case 0: //Unlocked, lock it.
					{
						HouseInfo[key][Locked][foundid] = 1;
						SendClientMessage(playerid,COLOR_ORANGE,"Door locked.");
					}
					case 1: //Locked, unlock it.
					{
						HouseInfo[key][Locked][foundid] = 0;
						SendClientMessage(playerid,COLOR_ORANGE,"Door unlocked.");
					}
				}
				SaveFurnObj(key, foundid);
	        }
		}
		else SCM(playerid, COLOR_LIGHTRED, "You don't have access to this door.");
	}
	if(GetPVarInt(playerid,"BizzEnter") != 0)
	{
		new key = FurnRight(playerid, 2);
		if(key > 0) {
            for(new h = 0; h < MAX_HOUSE_OBJ; h++)
            {
                if(BizInfo[key][bObject][h] != 0)
		        {
		            if(IsPlayerInRangeOfPoint(playerid, 3.0, BizInfo[key][boX][h], BizInfo[key][boY][h], BizInfo[key][boZ][h]))
		            {
                        if(IsDoorObject(BizInfo[key][boID][h]))
                	    {
							foundid=h;
							break;
		        	    }
		            }
                }
            }
	        if(foundid == -1) { SCM(playerid, COLOR_LIGHTRED, "ERROR: Can't find any door!"); }
	        else
	        {
				switch(BizInfo[key][bLocked][foundid])
				{
					case 0: //Unlocked, lock it.
					{
						BizInfo[key][bLocked][foundid] = 1;
						SendClientMessage(playerid,COLOR_ORANGE,"Door locked.");
					}
					case 1: //Locked, unlock it.
					{
						BizInfo[key][bLocked][foundid] = 0;
						SendClientMessage(playerid,COLOR_ORANGE,"Door unlocked.");
					}
				}
				SaveBizzObj(key, foundid);
	        }
		}
		else SCM(playerid, COLOR_LIGHTRED, "You don't have access to this door.");
	}
	if((GetPVarInt(playerid, "Mapper") > 0 || GetPVarInt(playerid, "Admin") > 0) && (GetPVarInt(playerid, "HouseEnter") == 0 && GetPVarInt(playerid, "BizzEnter") == 0)) {
            for(new h = 0; h < MAX_MAP_OBJ; h++)
            {
                if(MapInfo[h][mObject] != 0)
		        {
		            if(IsPlayerInRangeOfPoint(playerid, 3.0, MapInfo[h][mX], MapInfo[h][mY], MapInfo[h][mZ]))
		            {
                        if(IsDoorObject(MapInfo[h][mID]))
                	    {
							foundid=h;
							break;
		        	    }
		            }
                }
            }
	        if(foundid == -1) { SCM(playerid, COLOR_LIGHTRED, "ERROR: Can't find any door!"); }
	        else
	        {
				switch(MapInfo[foundid][mLocked])
				{
					case 0: //Unlocked, lock it.
					{
						MapInfo[foundid][mLocked] = 1;
						SendClientMessage(playerid,COLOR_ORANGE,"Door locked.");
					}
					case 1: //Locked, unlock it.
					{
						MapInfo[foundid][mLocked] = 0;
						SendClientMessage(playerid,COLOR_ORANGE,"Door unlocked.");
					}
				}
				SaveMapObj(foundid);
	        }
	}
    return 1;
}
//============================================//
COMMAND:unsethduty(playerid, params[]) {
	if(GetPVarInt(playerid, "Admin") < 4 && GetPVarInt(playerid, "Helper") < 2) return SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	new user;
	if(sscanf(params, "u", user)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /unsethduty [PlayerID/PartOfName]");
	if(!IsPlayerConnected(user)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
	if(GetPVarInt(user, "HelperDuty") == 0) return SendClientMessage(playerid, COLOR_WHITE, "This player is not on helper duty!");
	new msg[110];
	SetPVarInt(user, "HelperDuty", 0);
	SetPlayerColor(user, COLOR_WHITE);
	format(msg, sizeof(msg), "HelpCmd: %s forced %s to go Off-Duty as a Helper.", AdminName(playerid), AdminName(user));
    SendHelperMessage(0xFF0000FF, msg);
	return 1;
}
//============================================//
COMMAND:search(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") != 1) return true;
	new param[64];
	if(sscanf(params, "s[64]", param)) {
		scm(playerid, COLOR_GREEN, "/search [usage]");
		scm(playerid, COLOR_GREY, "  trunk | trailer ");
		return 1;
	}
  	if(strcmp(param, "trunk", true) == 0)
  	{
		if(!PlayerToCar(playerid,1,4.0)) return SendClientMessage(playerid, COLOR_LIGHTRED, "You are not close to any vehicle.");
		new key = PlayerToCar(playerid,2,4.0);
		if(!IsTrunkCar(GetVehicleModel(key))) return error(playerid, "This vehicle doesn't have a trunk.");
		PrintVehInvEx(playerid, key);
		new sendername[MAX_PLAYER_NAME];
		format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
		GiveNameSpace(sendername);
		new string[62];
    	format(string, sizeof(string), "*** %s searches the vehicles trunk.", sendername);
    	ProxDetector(30.0, playerid, string, COLOR_PURPLE);
		return 1;
	} else if(strcmp(param, "trailer", true) == 0) {
		if(IsPlayerInAnyVehicle(playerid)) return scm(playerid, COLOR_GREY, "You can't search a trailer while in a vehicle.");
		new trailer = PlayerToTrailer(playerid,5.0);
		if(trailer == INVALID_VEHICLE_ID) return scm(playerid, COLOR_GREY, "You aren't near a materials trailer!");
		if(!IsMatTrailer(trailer)) return error(playerid, "Vehicle-ID isn't even a trailer, vehicle possibly despawned?");
		new string[72], sendername[MAX_PLAYER_NAME];
		format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
		GiveNameSpace(sendername);
    	format(string, sizeof(string), "*** %s searches the trailer for materials.", sendername);
    	ProxDetector(30.0, playerid, string, COLOR_PURPLE);
		format(string, sizeof(string), "This trailer contains {36CC40}%d {FFFFFF}materials.", VehicleInfo[trailer][vMats]);
		scm(playerid, COLOR_WHITE, string);
		if(IsACop(playerid)) scm(playerid, COLOR_BLUE, "[TIP] {FFFFFF}Use (/seizetrailer) to destroy the materials.");
		return 1;
	}
	else cmd_search(playerid, "");
	return 1;
}
//============================================//
COMMAND:evict(playerid, params[]) {
	new name[MAX_PLAYER_NAME];
	if(sscanf(params, "s[24]", name)) return usage(playerid, "/evict [Firstname_Lastname]");
	if(GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	new key = GetPVarInt(playerid, "HouseKey");
	if(key == 0) return scm(playerid, -1, "You don't own a property.");
	if(strmatch(name, PlayerName(playerid))) return scm(playerid, -1, "You can't evict yourself.");
	if(strmatch(HouseInfo[key][hOwner], PlayerName(playerid)))
 	{
		foreach(new i : Player) {
		    if(strmatch(name, PlayerName(i))) {
				new msg[70];
		        if(GetPVarInt(i, "HouseKey") != GetPVarInt(playerid, "HouseKey")) return SCM(playerid, -1, "This player does not rent at your property!");
				SetPVarInt(i, "HouseKey", 0);
				format(msg, sizeof(msg), "You have evicted %s from your property.", name);
				scm(playerid, -1, msg);
				scm(i, -1, "You have been evicted from your property!");
				return 1;
			}
		}

		new query[90];
		mysql_format(handlesql, query, sizeof(query), "SELECT `HouseKey` FROM `accounts` WHERE `Name` = '%s';", name);
		mysql_tquery(handlesql, query, "OnEvictValidation", "is", playerid, name);
	} else {
		SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}

	return 1;
}

forward OnEvictValidation(playerid, name[]);
public OnEvictValidation(playerid, name[]) {
	if(cache_get_row_count() > 0) {
		new query[100];
		if(cache_get_field_content_int(0, "HouseKey") != GetPVarInt(playerid, "HouseKey")) {
			SCM(playerid, -1, "This player does not rent at your property!");
		} else {
			mysql_format(handlesql, query, sizeof(query), "UPDATE `accounts` SET `HouseKey` =  '0' WHERE `Name` = '%s';", name);
			mysql_tquery(handlesql, query);
			format(query, sizeof(query), "You have evicted %s from your property.", name);
			scm(playerid, -1, query);
		}
	} else {
		SendClientMessage(playerid, COLOR_GREY, "This player could not be found in the database.");
	}
}
//============================================//
ALTCOMMAND:getbid->bizid;
COMMAND:bizid(playerid, params[])
{
	if(GetPVarInt(playerid, "Admin") < 3) return SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	new str[36];
	foreach(new h : BizIterator)
	{
		if(IsPlayerInRangeOfPoint(playerid,2.0,BizInfo[h][Xo], BizInfo[h][Yo], BizInfo[h][Zo]))
		{
			format(str, 36, "You're standing on biz-id: %d", h);
			return scm(playerid,COLOR_ORANGE,str);
		}
	}
	return error(playerid, "You aren't standing on a biz-marker.");
}
//============================================//
ALTCOMMAND:gethid->hid;
COMMAND:hid(playerid, params[])
{
	if(GetPVarInt(playerid, "Admin") < 3) return SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	new str[36], vw = GetPlayerVirtualWorld(playerid);
	foreach(new h : HouseIterator)
	{
		if(HouseInfo[h][hID] != 0 && vw == HouseInfo[h][hVwOut] && IsPlayerInRangeOfPoint(playerid,2.0,HouseInfo[h][hXo], HouseInfo[h][hYo], HouseInfo[h][hZo]))
		{
			format(str, 36, "You're standing on house-id: %d", HouseInfo[h][hID]);
			return scm(playerid,COLOR_ORANGE,str);
		}
	}
	return error(playerid, "You aren't standing on a house-marker.");
}
//============================================//
COMMAND:abiz(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") != 1) return true;
	if(GetPVarInt(playerid, "Admin") < 10) return SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	new string[128], id, param[64], amount, amount2;
	if(sscanf(params, "I(-1)s[64]I(-1)I(-1)", id, param, amount, amount2)) {
		scm(playerid, COLOR_GREEN, "/abiz [id] [usage]");
		scm(playerid, COLOR_GREY, "  lock | bank | removeall | setexit | setcp | type |");
		return 1;
	}
	if(id < 1 || id > MAX_BUSINESSES) return error(playerid, "Invalid biz-id.");
  	if(strcmp(param, "lock", true) == 0)
  	{
		if(!IsPlayerInRangeOfPoint(playerid, 2.0, BizInfo[id][Xo], BizInfo[id][Yo], BizInfo[id][Zo]) && !IsPlayerInRangeOfPoint(playerid, 5.0, BizInfo[id][Xi], BizInfo[id][Yi], BizInfo[id][Zi])) return error(playerid, "You are not near your business door.");
		if(BizInfo[id][Locked] == 1) //Locked
		{
			PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
	 		GameTextForPlayer(playerid, "~w~Business~n~~g~Unlocked", 4000, 3);
	 		BizInfo[id][Locked] = 0;
		}
		else //Unlocked
		{
			PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
	  		GameTextForPlayer(playerid, "~w~Business~n~~r~Locked", 4000, 3);
	  		BizInfo[id][Locked] = 1;
		}
		SaveBiz(id);
		return 1;
	}
	else if(strcmp(param, "removeall", true) == 0)
	{
		RemoveBizzObjects(id);
		SendClientMessage(playerid,COLOR_LIGHTRED,"All Bizz-Objects removed!");
	}
	else if(strcmp(param, "setexit", true) == 0)
	{
		if(GetPlayerVirtualWorld(playerid) != id) return SendClientMessage(playerid, COLOR_GREY, "You have to be in a business to use this command!");
      	new Float:x,Float:y,Float:z;
		GetPlayerPos(playerid,x,y,z);
      	SendClientMessage(playerid, COLOR_LIGHTBLUE, "WARNING: You've moved the business' exit to your current position.");
      	BizInfo[id][Xi] = x;
		BizInfo[id][Yi] = y;
		BizInfo[id][Zi] = z;
		BizInfo[id][IntIn] = GetPlayerInterior(playerid);
		SaveBiz(id);
		DestroyDynamicPickup(BizInfo[id][bExit]);
		BizInfo[id][bExit] = CreateDynamicPickup(1318, 1, BizInfo[id][Xi], BizInfo[id][Yi], BizInfo[id][Zi], id, BizInfo[id][IntIn]);
	}
	else if(strcmp(param, "setcp", true) == 0)
	{
		if(GetPlayerVirtualWorld(playerid) != id) return SendClientMessage(playerid, COLOR_GREY, "You have to be in a business to use this command!");
		SetPVarInt(playerid, "ABizEdit", id);
		ShowPlayerDialog(playerid, 447, DIALOG_STYLE_MSGBOX, "Business Checkpoint", "Would you like to move the bizz checkpoint?\n{CC0000}Abusing this command will result in a ban/business confiscation!", "Continue", "Cancel");
	}
	else if(strcmp(param, "type", true) == 0)
    {
		if(amount == (-1)) {
			SendClientMessage(playerid, COLOR_WHITE, "USAGE: /abiz type {FFFFFF}[0-4]");
			SendClientMessage(playerid, COLOR_GREY, "0: None | 1: Bar");
			SendClientMessage(playerid, COLOR_GREY, "2: 24/7 | 3: Warehouse");
			SendClientMessage(playerid, COLOR_GREY, "4: Gym");
			return 1;
		}
		if(amount < 0 || amount > 5) return SendClientMessage(playerid, COLOR_GREY, "Cannot go under 0 or above 5.");
		format(string, 128, "Business Type set to %d.", amount);
		scm(playerid, -1, string);
		BizInfo[id][cT]=amount;
		scm(playerid, COLOR_LIGHTRED, "This will only work when a custom CP position has been set!");
		SaveBiz(id);
    }
    else if(strcmp(param, "bank", true) == 0)
  	{
		new msg[128];
		format(msg, sizeof(msg), "INFO: %s (Bank: $%d)", BizInfo[id][Name], BizInfo[id][Bank]);
		SCM(playerid, -1, msg);
		return 1;
	}
	else cmd_abiz(playerid, "");
	return 1;
}
//============================================//
COMMAND:backpack(playerid, params[])
{
	if(GetPVarInt(playerid, "Backpack") == 1) {
		SetPVarInt(playerid, "Backpack", 0);
		GiveInvItem(playerid, 1006, 1, 0);
		if(IsPlayerAttachedObjectSlotUsed(playerid, 6)) RemovePlayerAttachedObject(playerid, 6);
		new sendername[MAX_PLAYER_NAME];
		format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
		GiveNameSpace(sendername);
		new string[56];
    	format(string, sizeof(string), "*** %s takes off %s backpack.", sendername, CheckSex(playerid));
    	ProxDetector(30.0, playerid, string, COLOR_PURPLE);
		CallRemoteFunction("LoadHolsters","i",playerid);
	}
	else error(playerid, "You aren't wearing a backpack.");
	return 1;
}
//============================================//
COMMAND:map(playerid, params[])
{
    if(GetPVarInt(playerid, "PlayerLogged") != 1) return true;
	if(GetPVarInt(playerid, "Mapper") < 1 && GetPVarInt(playerid, "Admin") < 11) return error(playerid, "You aren't a mapper.");
	new param[64], amount, val;
	if(sscanf(params, "s[64]I(-1)I(-1)", param, amount, val)) {
		scm(playerid, COLOR_GREEN, "/map [usage]");
		scm(playerid, COLOR_GREY, "  plant | edit | mine |");
		if(GetPVarInt(playerid, "Mapper") > 1 || GetPVarInt(playerid, "Admin") > 11) {
			scm(playerid, COLOR_GREY, " addmapper | removemapper |");
		}
		return 1;
	}
	if(strcmp(param, "plant", true) == 0)
	{
		if(amount == (-1))
		{
			ShowPlayerDialog(playerid, 522, DIALOG_STYLE_LIST, "Category Selection", "Weapons\nNature\nCar Parts\nFun Stuff\nRoads\nBarriers\nVarious\nMisc\nHouse-style List", "Select", "Exit");
		}
		else
		{
			if(amount < 320 || amount > 21000) return scm(playerid, -1, "Invalid Object ID!");
			new found = 0, foundid;
			for(new i = 0; i < MAX_OBJECT_ARRAY; i++)
			{
				if(ObjectList[i][oID] == amount)
				{
					found++;
					foundid=i;
					break;
				}
			}
			if(found == 0) return scm(playerid, -1, "Invalid Object ID!");
			new Float:X, Float:Y, Float:Z, obj = 0;
			GetPlayerPos(playerid, X, Y, Z);
			obj = CreatePlayerObject(playerid, amount, X+1.0, Y+1.0, Z, 0.0, 0.0, 0.0, 100.0);
			SetPVarInt(playerid, "FurnObject", obj);
			SetPVarInt(playerid, "EditorMode", 6);
			PlayerInfo[playerid][pFurnID]=amount;
			Streamer_Update(playerid);
			EditPlayerObject(playerid, obj);
			new string[72];
			format(string, sizeof(string),"%s selected, use the SPRINT key to navigate.", ObjectList[foundid][oName]);
			SendClientMessage(playerid, COLOR_WHITE, string);
		}
	}
	else if(strcmp(param, "edit", true) == 0)
	{
		GetCloseMapObject(playerid);
	}
	else if(strcmp(param, "addmapper", true) == 0)
	{
		if(GetPVarInt(playerid, "Admin") < 10 && GetPVarInt(playerid, "Mapper") < 2) return error(playerid, "Insufficient rank!");
		if(amount == (-1)) {
			SendClientMessage(playerid, COLOR_GREEN, "USAGE: /map addmapper {FFFFFF}[playerid]");
			return 1;
		}
		if(amount == playerid) return error(playerid, "You can't add yourself as a mapper.");
		if(IsPlayerNPC(amount)) return error(playerid, "You cant do this to NPCs.");
		if(!IsPlayerConnected(amount)) return error(playerid, "Player doesn't exist!");
		if(val < 1 || val > 2) return error(playerid, "You can only make a mapper rank 1(Mapper) or rank 2(Lead Mapper).");
		if(val == 2 && GetPVarInt(playerid, "Admin") < 11) return error(playerid, "Only the highest rank administrators can add lead-mappers.");
		SetPDataInt(amount, "Mapper", val);
		new string[128];
		format(string, sizeof(string), "You've been made a rank %d mapper by %s.", val, PlayerName(playerid));
		scm(amount, COLOR_WHITE, string);
		format(string, sizeof(string), "You've made %s a rank %d mapper.", PlayerName(amount), val);
		scm(playerid, COLOR_WHITE, string);
	}
	else if(strcmp(param, "removemapper", true) == 0)
	{
		if(GetPVarInt(playerid, "Admin") < 11 && GetPVarInt(playerid, "Mapper") < 2) return error(playerid, "Insufficient rank!");
		if(amount == (-1)) {
			SendClientMessage(playerid, COLOR_GREEN, "USAGE: /map removemapper {FFFFFF}[playerid]");
			return 1;
		}
		if(IsPlayerNPC(amount)) return error(playerid, "You cant do this to NPCs.");
		if(!IsPlayerConnected(amount)) return error(playerid, "Player doesn't exist!");
		SetPDataInt(amount, "Mapper", 0);
		new string[128];
		format(string, sizeof(string), "You've been removed from the mapping-team by %s.", PlayerName(playerid));
		scm(amount, COLOR_WHITE, string);
		format(string, sizeof(string), "You've removed %s from the mapping-team.", PlayerName(amount));
		scm(playerid, COLOR_WHITE, string);
	}
	else if(strcmp(param, "mine", true) == 0)
	{
		GetMapping(playerid,PlayerName(playerid),1);
	}
	else if(strcmp(param, "select", true) == 0)
	{
		SetPVarInt(playerid, "SelectMode", SELECTMODE_MAP);
		SelectObject(playerid);
		SendClientMessage(playerid, COLOR_BLUE, "[TIP] {FFFFFF}Click on a map object to edit it.");
	}
	else cmd_map(playerid, "");
	return 1;
}
//============================================//
COMMAND:removemapping(playerid, params[])
{
    if(GetPVarInt(playerid, "PlayerLogged") != 1) return 1;
	if(GetPVarInt(playerid, "Admin") < 11) return 1;
	new text[24];
	if(sscanf(params, "s[24]", text)) {
		scm(playerid, COLOR_GREEN, "/removemapping [firstname_lastname]");
		return 1;
	}
	if(strlen(text) < 3) return error(playerid, "The name you've entered is too short. Enter the mapper's name to remove all of his placed-objects.");
	SetPVarString(playerid, "MapperRemove", text);
	ShowPlayerDialog(playerid, 517, DIALOG_STYLE_MSGBOX, "Are you sure?", "This will remove all of the selected players mapping. (If the name is valid.)", "Yes", "No");
	return 1;
}
//============================================//
COMMAND:findmapping(playerid, params[])
{
    if(GetPVarInt(playerid, "PlayerLogged") != 1) return 1;
	if(GetPVarInt(playerid, "Admin") < 10) return 1;
	new text[24];
	if(sscanf(params, "s[24]", text)) {
		scm(playerid, COLOR_GREEN, "/findmapping [firstname_lastname]");
		return 1;
	}
	if(strlen(text) < 3) return error(playerid, "The name you've entered is too short. Enter the mapper's name to remove all of his placed-objects.");
	GetMapping(playerid,text);
	return 1;
}
//============================================//
COMMAND:stream(playerid, params[])
{
	if(GetPVarInt(playerid, "PlayerLogged") != 1) return 1;
	if(GetPVarInt(playerid, "Member") != 3) return error(playerid, "You aren't a member of Radio Los Santos!");
	if(GetPVarInt(playerid, "Rank") < 2) return error(playerid, "You have to be at-least rank 2 in RLS.");
	PopulateRLS(playerid);
	return 1;
}
//================Basketball==================//
COMMAND:ball(playerid, params[])
{
	if(GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	if(GetPVarInt(playerid, "Admin") < 1) return error(playerid, "Moderators and Admins only!");
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	if((x > 2288.74 || x < 2268.16 || y >  -1773.48 || y < -1803.60)) return SendClientMessage(playerid, COLOR_WHITE, "You aren't at the basketball court!");
	DestroyObject(Ball);
	Ball = CreateObject(2114, x+random(3), y+random(3), z-0.8, 0, 0, 96);
	return 1;
}
//============================================//
COMMAND:basketball(playerid, params[])
{
	if(GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	new balling = PlayerInfo[playerid][pBalling];
	if(GetPVarInt(playerid, "Duty") != 0 && balling != 1) return error(playerid, "You can't play basketball while on duty.");
	if(GetPVarInt(playerid, "OnRoute") != 0 && balling != 1) return SendClientMessage(playerid, COLOR_LIGHTRED, "You can't play basketball while on a route.");
    if(GetPVarInt(playerid, "Cuffed") > 0) return SendClientMessage(playerid, COLOR_GREY, "You can't do this while handcuffed/tazed.");
    if(GetPVarInt(playerid, "Jailed") > 0) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-jail.");
	if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while dead!");
	if(GetPVarInt(playerid, "AdminDuty") > 0) return SendClientMessage(playerid, COLOR_WHITE, "You can't play basketball while on admin-duty!");
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	if((x > 2288.74 || x < 2268.16 || y >  -1773.48 || y < -1803.60) && balling != 1) return SendClientMessage(playerid, COLOR_WHITE, "You aren't at the basketball court!");
	new team;
	if(sscanf(params, "u", team) && balling != 1) return usage(playerid, "/basketball [team: 1/2]");
	switch(balling)
	{
		case 0: //Not currently balling
		{
			if(team == 1) {
				PlayerInfo[playerid][pBallTeam] = 0;
				PlayerInfo[playerid][pBalling] = 1;
				SetPlayerColor(playerid, COLOR_LIGHTBLUE);
				new str[74];
				format(str, sizeof(str), "%s has joined the basketball game for Team 1.",PlayerName(playerid));
				SendBallerMessage(0, str);
				SendClientMessage(playerid, COLOR_BLUE, "[TIP] {FFFFFF}Use '/basketball' or leave the court to quit playing basketball.");
				SendClientMessage(playerid, COLOR_BLUE, "[TIP] {FFFFFF}You won't be-able to use hotkeys and certain features while playing basketball.");
			}
			else if(team == 2) {
				PlayerInfo[playerid][pBallTeam] = 1;
				PlayerInfo[playerid][pBalling] = 1;
				SetPlayerColor(playerid, COLOR_RED);
				new str[74];
				format(str, sizeof(str), "%s has joined the basketball game for Team 2.",PlayerName(playerid));
				SendBallerMessage(1, str);
				SendClientMessage(playerid, COLOR_BLUE, "[TIP] {FFFFFF}Use '/basketball' or leave the court to quit playing basketball.");
				SendClientMessage(playerid, COLOR_BLUE, "[TIP] {FFFFFF}You won't be-able to use hotkeys and certain features while playing basketball.");
			}
			else error(playerid, "You have to pick either team 1 or team 2!");
		}
		case 1: //Currently balling
		{
			QuitBalling(playerid);
		}
	}
	return 1;
}
//============================================//
COMMAND:score(playerid, params[])
{
	if(GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	new str[64];
	format(str, sizeof(str), "~w~Score~n~~g~Team 1: %d~n~~r~Team 2: %d", Score[0], Score[1]);
	GameTextForPlayer(playerid, str, 3000, 3);
	format(str, sizeof(str), "[Score] Team 1: %d | Team 2: %d", Score[0], Score[1]);
	scm(playerid, COLOR_ORANGE, str);
	return 1;
}
//============================================//
COMMAND:resetscore(playerid, params[])
{
	if(GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	if(GetPVarInt(playerid, "Admin") < 2) return error(playerid, "Administrators only!");
	if(Score[0] > Score[1]) {
		SendBallerMessage(1,"[Basketball] The score has been reset!");
	}
	else SendBallerMessage(1,"[Basketball] The score has been reset!");
	Score[0] = 0;
	Score[1] = 0;
	scm(playerid, COLOR_WHITE, "[Basketball] You've reset the score!");
	return 1;
}
//=============End of Basketball===============//
//=============================================//
COMMAND:carcount(playerid, params[])
{
	if(GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	if(GetPVarInt(playerid, "Admin") < 1337) return error(playerid, "Developers only!");
	new cars = 0;
	foreach(new i : Vehicle) {
		cars++;
	}
	new str[128];
	format(str,128,"Car count: %d",cars);
	scm(playerid, -1, str);
	return 1;
}
//=============================================//
COMMAND:wat(playerid, params[]) //Wear all toys
{
    if(GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return SendClientMessage(playerid, COLOR_GREY, "You must be on-foot.");
	if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_GREY, "You are not able to use this while dead!");
	for(new i = 0; i < 5; i++) {
		if(IsValidClothing(ToyInfo[playerid][i][tModel])) {
			if(IsPlayerAttachedObjectSlotUsed(playerid, i)) { RemovePlayerAttachedObject(playerid, i); }
			SetPlayerAttachedObject(playerid, i, ToyInfo[playerid][i][tModel],ToyInfo[playerid][i][tBone],
			ToyInfo[playerid][i][toX], ToyInfo[playerid][i][toY], ToyInfo[playerid][i][toZ],
			ToyInfo[playerid][i][trX], ToyInfo[playerid][i][trY], ToyInfo[playerid][i][trZ],
			ToyInfo[playerid][i][tsX], ToyInfo[playerid][i][tsY], ToyInfo[playerid][i][tsZ],
			ARGBColors[ToyInfo[playerid][i][tColor]][Hex], ARGBColors[ToyInfo[playerid][i][tColor2]][Hex]);
		}
	}
	scm(playerid, COLOR_ORANGE, "All toys attached!");
	return 1;
}

//=============================================//
COMMAND:rat(playerid, params[]) //Remove all toys
{
    if(GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return SendClientMessage(playerid, COLOR_GREY, "You must be on-foot.");
	if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_GREY, "You are not able to use this while dead!");
	for(new i = 0; i < 5; i++) {
		if(IsPlayerAttachedObjectSlotUsed(playerid, i)) {
			RemovePlayerAttachedObject(playerid, i);
		}
	}
	scm(playerid, COLOR_ORANGE, "All toys detached!");
	return 1;
}
//============================================//
COMMAND:drop(playerid, params[])
{
	if(GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	new type[32];
	if(sscanf(params, "s[32]", type)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /drop {FFFFFF}[carkey/cig/matpack/weapon]");
	else {
		if(strcmp(type, "carkey", true) == 0) {
			SendClientMessage(playerid, COLOR_BLUE, "[TIP] {FFFFFF}Double click a key-slot for more information.");
			ShowCarKeys(playerid);
		} else if(strcmp(type, "cig", true) == 0) {
			if(GetPVarInt(playerid, "usingCig") != 1) return scm(playerid, COLOR_GREY, "You aren't even smoking a cigarette.");
			DeletePVar(playerid, "usingCig");
			if(IsPlayerAttachedObjectSlotUsed(playerid, HOLDOBJECT_CLOTH4)) RemovePlayerAttachedObject(playerid, HOLDOBJECT_CLOTH4);
			scm(playerid, COLOR_WHITE, "Cigarette discarded.");
		} else if(strcmp(type, "matpack", true) == 0) {
			DeletePVar(playerid, "holdingMP");
			SetPlayerSpecialAction(playerid, 0);
			if(IsPlayerAttachedObjectSlotUsed(playerid, HOLDOBJECT_CLOTH4)) RemovePlayerAttachedObject(playerid, HOLDOBJECT_CLOTH4);
			scm(playerid, COLOR_WHITE, "Material pack discarded.");	
		} else if(strcmp(type, "weapon", true) == 0) {
			if(GetPVarInt(playerid, "PlayerLogged") != 1) return true;
			if(GetPVarInt(playerid, "LSPD_Ta") == 1) return 1; // Block taser bug.
			if(GetPVarInt(playerid, "JustChosen") == 1) return error(playerid, "You must wait a second.");
			if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_GREY, "You cannot give out weapons when your character has died.");
			if(PlayerInfo[playerid][pPlayerWeapon] == 0) return SendClientMessage(playerid, COLOR_GREY, "You aren't even holding a weapon.");
			if(GetPlayerPing(playerid) >= 500) return SendClientMessage(playerid, COLOR_WHITE, "Your ping is too high to use this!");
			if(GetPVarInt(playerid, "Delay") > GetCount()) return SendClientMessage(playerid, COLOR_LIGHTRED, "You must wait before performing this command!");
			SetPVarInt(playerid, "Delay", GetCount()+2000);
			new sweapon, sammo;
			for (new i = 0; i < 9; i++) {
				GetPlayerWeaponData(playerid, i, sweapon, sammo);
				if(sweapon == PlayerInfo[playerid][pPlayerWeapon]) {
					PlayerInfo[playerid][pPlayerAmmo]=sammo;
				}
			}
			if(PlayerInfo[playerid][pPlayerWeapon] >= 22 && PlayerInfo[playerid][pPlayerWeapon] <= 34)
			{
				new amount = PlayerInfo[playerid][pPlayerAmmo], am = 0;
				switch(PlayerInfo[playerid][pPlayerWeapon])
				{
					case 22 .. 24: am=7;
					case 25 .. 27: am=6;
					case 28 .. 32: am=30;
					case 33, 34: am=10;
				}
				if(amount > am)
				{
					switch(PlayerInfo[playerid][pAmmoType])
					{
						case 101: am=14;
						case 107: am=14;
						case 116: am=60;
						case 126: am=80;
						case 127: am=60;
					}
					amount = am;
				}
				PlayerInfo[playerid][pPlayerAmmo]=amount;
				if(PlayerInfo[playerid][pAmmoType] == 0) {
				PlayerInfo[playerid][pPlayerAmmo]=0; }
			}
			new Float:X, Float:Y, Float:Z, pw = PlayerInfo[playerid][pPlayerWeapon];
			GetPlayerPos(playerid, X, Y, Z);
			new str[50];
			format(str, 50, "%s dropped!", PrintIName(pw));
			SendClientMessage(playerid, COLOR_WHITE, str);
			if(GetPVarInt(playerid, "Member") != 1 && PlayerInfo[playerid][pPlayerWeapon] != 42 && GetPVarInt(playerid, "Member") != 8) {
				CreateLoot(PlayerInfo[playerid][pPlayerWeapon], PlayerInfo[playerid][pPlayerAmmo], PlayerInfo[playerid][pAmmoType], PlayerInfo[playerid][pSerial], X, Y, Z, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
			}
			ResetPlayerWeapons(playerid);
			PlayerInfo[playerid][pPlayerWeapon]=0;
			PlayerInfo[playerid][pPlayerAmmo]=0;
			ResetPlayerWeaponsEx(playerid);
			format(str, 50, "%s dropped his %s", PlayerInfo[playerid][pName], PrintIName(pw));
			WepLog(str);
			SetTimerEx("LoadHolsters", 1500, false, "i", playerid);		
		}
	}
	return 1;
}
//============================================//
COMMAND:craft(playerid, params[])
{
	if(GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	if(GetPVarInt(playerid, "Cuffed") > 0) return SendClientMessage(playerid, COLOR_GREY, "You can't do this while handcuffed/tazed.");
	new diatext[1024];
	for(new i = 0; i < CRAFT_WEP_COUNT; i++) {
		if(PlayerInfo[playerid][pCraft] < CraftWeps[i][wLvl]) continue;
		if(isnull(diatext)) {
			format(diatext, 1024, "%s", CraftWeps[i][wName]);
		} else format(diatext, 1024, "%s\n%s", diatext, CraftWeps[i][wName]);
	}
	new str[42];
	format(str, 42, "[Crafting] Level: %d | EXP: %d/%d", PlayerInfo[playerid][pCraft], PlayerInfo[playerid][pCraftExp], GetCraftEXP(playerid));
	ShowPlayerDialog(playerid, 554, DIALOG_STYLE_LIST, str, diatext, "Select","Close");
	return 1;
}
//=============S.W.A.T Rapelling==============//
ALTCOMMAND:swatrope->sr;
COMMAND:sr(playerid,params[])
{
	if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, 0x33CCFFAA,"You must be in a law enforcement helicopter to rappel!");
	if(!IsACop(playerid)) return SendClientMessage(playerid, 0x33CCFFAA,"You are not a LEO.");
	new veh = GetPlayerVehicleID(playerid);
	if(!IsHelicopter(veh) || (VehicleInfo[veh][vType] != VEHICLE_LSPD && VehicleInfo[veh][vType] != VEHICLE_GOV)) return SendClientMessage(playerid, 0x33CCFFAA,"You must be in a law enforcement helicopter to rappel!");
	if(GetPVarInt(playerid,"rappelling") == 1) return SendClientMessage(playerid, 0x33CCFFAA, "You are already rappelling!");

	RemovePlayerFromVehicle(playerid);
	new Float:X, Float:Y, Float:Z,Float:Angle;
	GetPlayerPos(playerid, X, Y, Z);
	SetPlayerPosEx(playerid, X, Y, Z-2);
	GetPlayerFacingAngle(playerid, Angle);
	GameTextForPlayer(playerid, "~B~Rappelling", 5000, 1);
	SetPVarInt(playerid,"rappelling",1);
    new z_ = 5;
	for(new i = 0; i < 58; i++) {
		rope[i] = CreateObject(19089, X, Y, Z+z_, 0, 0, Angle);
		z_ -= 3;
	}
	ApplyAnimation(playerid,"ped","abseil",4.0,0,0,0,1,0);
	scm(playerid, COLOR_BLUE, "[TIP] {FFFFFF}Don't forget to use /breakrope (/br)");
	return 1;
}
ALTCOMMAND:breakrope->br;
COMMAND:br(playerid,params[])
{
	if(GetPVarInt(playerid,"rappelling") == 0) return SendClientMessage(playerid, 0x33CCFFAA, "You are not rappelling!");
	for(new i = 0; i < 58; i++) {
		SetPVarInt(playerid,"rappelling",0);
		DestroyObject(rope[i]);
		ClearAnimations(playerid);
	}
	return 1;
}
//============================================//
COMMAND:weapon(playerid, params[])
{
    if (GetPVarInt(playerid, "PlayerLogged") != 1) return true;
	new param[64], bone;
	if(sscanf(params, "s[64]I(-1)", param, bone)) {
		scm(playerid, COLOR_GREEN, "/weapon [usage]");
		scm(playerid, COLOR_GREY, "  hide | adjust | bone | reset ");
		return 1;
	}
  	if(strcmp(param, "hide", true) == 0)
  	{
		switch(GetPVarInt(playerid, "SecHol"))
		{
			case 0: // Show holster
			{
				SetPVarInt(playerid, "SecHol", 1);
				scm(playerid, COLOR_GREEN, "Secondary holster set to: [Visible].");
				CallRemoteFunction("LoadHolsters","i",playerid);
			}
			case 1: // Hide holster
			{
				SetPVarInt(playerid, "SecHol", 0);
				scm(playerid, COLOR_GREEN, "Secondary holster set to: [Hidden].");
				if(IsPlayerAttachedObjectSlotUsed(playerid, 6)) CallRemoteFunction("LoadHolsters","i",playerid);
			}
		}
		OnPlayerDataSave(playerid);
		return 1;
	}
	else if(strcmp(param, "adjust", true) == 0)
	{
		new weaponid = PlayerInfo[playerid][pPlayerWeapon];
		SetPVarInt(playerid, "Delay", GetCount()+2000);

		if(weaponid >= 22 && weaponid <= 24)
		{
			if(HolsterInfo[playerid][weaponid][hBone] > 0) {
				SetPlayerAttachedObject(playerid, HOLDOBJECT_GUN2, GunobjectIds[weaponid], HolsterInfo[playerid][weaponid][hBone], HolsterInfo[playerid][weaponid][hoX], HolsterInfo[playerid][weaponid][hoY], HolsterInfo[playerid][weaponid][hoZ], HolsterInfo[playerid][weaponid][hrX], HolsterInfo[playerid][weaponid][hrY], HolsterInfo[playerid][weaponid][hrZ]);
			} else {
				HolsterInfo[playerid][weaponid][hBone] = 1;
				HolsterInfo[playerid][weaponid][hoX] = 0.139415;
				HolsterInfo[playerid][weaponid][hoY] = -0.167970;
				HolsterInfo[playerid][weaponid][hoZ] = 0.120848;
				HolsterInfo[playerid][weaponid][hrX] = 0.000000;
				HolsterInfo[playerid][weaponid][hrY] = 152.342666;
				HolsterInfo[playerid][weaponid][hrZ] = 0.000000;

				SetPlayerAttachedObject(playerid, HOLDOBJECT_GUN2, GunobjectIds[weaponid], 1, 0.139415, -0.167970, 0.120848, 0.000000, 152.342666, 0.000000);
			}
		}
		else if(weaponid >= 25 && weaponid <= 34)
		{
			if(HolsterInfo[playerid][weaponid][hBone] > 0) { 
				SetPlayerAttachedObject(playerid, HOLDOBJECT_GUN2, GunobjectIds[weaponid], HolsterInfo[playerid][weaponid][hBone], HolsterInfo[playerid][weaponid][hoX], HolsterInfo[playerid][weaponid][hoY], HolsterInfo[playerid][weaponid][hoZ], HolsterInfo[playerid][weaponid][hrX], HolsterInfo[playerid][weaponid][hrY], HolsterInfo[playerid][weaponid][hrZ]);
			} else {
				HolsterInfo[playerid][weaponid][hBone] = 8;
				HolsterInfo[playerid][weaponid][hoX] = -0.044177;
				HolsterInfo[playerid][weaponid][hoY] = 0.000000;
				HolsterInfo[playerid][weaponid][hoZ] = 0.092454;
				HolsterInfo[playerid][weaponid][hrX] = 246.994583;
				HolsterInfo[playerid][weaponid][hrY] = 0.000000;
				HolsterInfo[playerid][weaponid][hrZ] = 0.000000;

				SetPlayerAttachedObject(playerid, HOLDOBJECT_GUN1, GunobjectIds[weaponid], HolsterInfo[playerid][weaponid][hBone], HolsterInfo[playerid][weaponid][hoX], HolsterInfo[playerid][weaponid][hoY], HolsterInfo[playerid][weaponid][hoZ], HolsterInfo[playerid][weaponid][hrX], HolsterInfo[playerid][weaponid][hrY], HolsterInfo[playerid][weaponid][hrZ]);
			}
		}
		else return 1;
		
		SaveHolster(playerid);

		EditAttachedObject(playerid, HOLDOBJECT_GUN2);
		SetPVarInt(playerid, "EditorMode", 15);
	}
	else if(strcmp(param, "bone", true) == 0)
	{
		if(bone == (-1))
		{
			SendClientMessage(playerid, -1, "USAGE: /weapon bone [id]");
			SendClientMessage(playerid, -1, "1: Spine | 2: Left Thigh | 3: Right Thigh | 4: Right Calf | 5: Left Calf");
			return 1;
		}

		if(bone < 1 || bone > 5) return SendClientMessage(playerid, COLOR_GREY, "Cannot go under 1 or above 5.");
		new boneid = 1;

		switch(bone)
		{
			case 1: boneid = 1;
			case 2: boneid = 7;
			case 3: boneid = 8;
			case 4: boneid = 11;
			case 5: boneid = 12;
		}

		HolsterInfo[playerid][PlayerInfo[playerid][pPlayerWeapon]][hBone] = boneid;
		
		SaveHolster(playerid);
		
		scm(playerid, -1, "Holster bone adjustment set.");
	}
	else if(strcmp(param, "reset", true) == 0)
	{
		new weaponid = PlayerInfo[playerid][pPlayerWeapon];
		if(weaponid >= 22 && weaponid <= 24)
		{
			HolsterInfo[playerid][weaponid][hBone] = 8;
			HolsterInfo[playerid][weaponid][hoX] = -0.044177;
			HolsterInfo[playerid][weaponid][hoY] = 0.000000;
			HolsterInfo[playerid][weaponid][hoZ] = 0.092454;
			HolsterInfo[playerid][weaponid][hrX] = 246.994583;
			HolsterInfo[playerid][weaponid][hrY] = 0.000000;
			HolsterInfo[playerid][weaponid][hrZ] = 0.000000;

			SendClientMessage(playerid, COLOR_WHITE, "Weapon holster reset.");
			SaveHolster(playerid);
		}
		else if(weaponid >= 25 && weaponid <= 34)
		{
			HolsterInfo[playerid][weaponid][hBone] = 1;
			HolsterInfo[playerid][weaponid][hoX] = 0.139415;
			HolsterInfo[playerid][weaponid][hoY] = -0.167970;
			HolsterInfo[playerid][weaponid][hoZ] = 0.120848;
			HolsterInfo[playerid][weaponid][hrX] = 0.000000;
			HolsterInfo[playerid][weaponid][hrY] = 152.342666;
			HolsterInfo[playerid][weaponid][hrZ] = 0.000000;

			SendClientMessage(playerid, COLOR_WHITE, "Weapon holster reset.");
			SaveHolster(playerid);
		}
		else
		{
			SendClientMessage(playerid, COLOR_GREY, "This weapons holster can't be reset.");
		}
	}
	else cmd_weapon(playerid, "");
	return 1;
}
//============================================//
COMMAND:loadpack(playerid, params[])
{
	new trailer = PlayerToTrailer(playerid,5.0);
	if(trailer == INVALID_VEHICLE_ID) return scm(playerid, COLOR_GREY, "You aren't near a materials trailer!");
	if(!IsMatTrailer(trailer)) return error(playerid, "Vehicle-ID isn't even a trailer, vehicle possibly despawned?");
	if(GetPVarInt(playerid, "holdingMP") != 1) return scm(playerid, COLOR_GREY, "You aren't carrying a materials package!");
	if(VehicleInfo[trailer][vMats] > 8001) return scm(playerid, COLOR_GREY, "This trailer is full!");
	SetPVarInt(playerid, "holdingMP", 0);
	SetPlayerSpecialAction(playerid, 0);
	ClearAnimations(playerid);
	if(IsPlayerAttachedObjectSlotUsed(playerid, HOLDOBJECT_CLOTH4)) RemovePlayerAttachedObject(playerid, HOLDOBJECT_CLOTH4);
	VehicleInfo[trailer][vMats] = VehicleInfo[trailer][vMats]+2000;
	new str[100];
	format(str, sizeof(str), "You've stored {36CC40}2000 {FFFFFF}materials in the trailer. (Trailer: %d/10000 materials.)", VehicleInfo[trailer][vMats]);
	scm(playerid, COLOR_WHITE, str);
	return 1;
}
//============================================//
COMMAND:seizetrailer(playerid, params[])
{
	if(!IsACop(playerid) || GetPVarInt(playerid, "Duty") != 1) return scm(playerid, COLOR_GREY, "You are either not a cop or not on duty.");
	if(IsPlayerInAnyVehicle(playerid)) return scm(playerid, COLOR_GREY, "Can't do this while in a vehicle!");
	new trailer = PlayerToTrailer(playerid,5.0);
	if(trailer == INVALID_VEHICLE_ID) return scm(playerid, COLOR_GREY, "You aren't near a materials trailer!");
	if(!IsMatTrailer(trailer)) return error(playerid, "Vehicle-ID isn't even a trailer, vehicle possibly despawned?");
	VehicleInfo[trailer][vMats] = 0;
	new sendername[MAX_PLAYER_NAME];
	format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
	GiveNameSpace(sendername);
	new string[68];
	format(string, sizeof(string), "*** %s confiscates the trailers materials.", sendername);
	ProxDetector(30.0, playerid, string, COLOR_PURPLE);
	return 1;
}
//============================================//
COMMAND:vehicleclear(playerid, params[])
{
	new id,string[128],sendername[MAX_PLAYER_NAME];
	if(sscanf(params, "i", id)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /vehicleclear [vehicleid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if(GetPVarInt(playerid, "Admin") >= 2)
		{
   			format(sendername, sizeof(sendername), "%s", PlayerInfo[playerid][pUsername]);
      		GiveNameSpace(sendername);
      		format(string, sizeof(string), "AdmCmd: %s cleared vehicle %d's inventory.", sendername, id);
      		SendAdminMessage(COLOR_LIGHTRED,string);
      		for(new i = 0; i < MAX_VEH_SLOTS; i++) {
      			VehicleInfo[id][vInvID][i]=0;
				VehicleInfo[id][vInvQ][i]=0;
				VehicleInfo[id][vInvE][i]=0;
			}
		}
		else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
COMMAND:houseclear(playerid, params[])
{
	new id,string[128],sendername[MAX_PLAYER_NAME];
	if(sscanf(params, "i", id)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /houseclear [houseid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if(GetPVarInt(playerid, "Admin") >= 2) {
   			format(sendername, sizeof(sendername), "%s", PlayerInfo[playerid][pUsername]);
      		GiveNameSpace(sendername);
      		format(string, sizeof(string), "AdmCmd: %s cleared house %d's inventory.", sendername, id);
      		SendAdminMessage(COLOR_LIGHTRED,string);
      		for(new i = 0; i < MAX_HOUSE_SLOTS; i++) {
      			HouseInfo[id][hInvID][i]=0;
				HouseInfo[id][hInvQ][i]=0;
				HouseInfo[id][hInvE][i]=0;
			}
		}
		else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
ALTCOMMAND:bizclear->bizzclear;
COMMAND:bizzclear(playerid, params[])
{
	new id,string[128],sendername[MAX_PLAYER_NAME];
	if(sscanf(params, "i", id)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /bizclear [businessid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if(GetPVarInt(playerid, "Admin") >= 2)
		{
   			format(sendername, sizeof(sendername), "%s", PlayerInfo[playerid][pUsername]);
      		GiveNameSpace(sendername);
      		if(GetPVarInt(playerid, "AHide") > 0 || GetPVarInt(playerid, "Admin") >= 11) sendername = "Hidden";
      		format(string, sizeof(string), "AdmCmd: %s cleared business %d's inventory.", sendername, id);
      		SendAdminMessage(COLOR_LIGHTRED,string);
      		for(new i = 0; i < MAX_HOUSE_SLOTS; i++)
      		{
      			BizInfo[id][InvID][i]=0;
				BizInfo[id][InvQ][i]=0;
				BizInfo[id][InvE][i]=0;
			}
		}
		else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
COMMAND:fireremoveall(playerid, params[])
{
	if(GetPVarInt(playerid, "Admin") < 2) return SendClientMessage(playerid, COLOR_GREY, "You do not have access to this command.");

	new count = 0;
	for(new i = 0; i < sizeof(FDInfo); i++)
	{
		if(IsValidDynamicObject(FDInfo[i][fObject]))
		{
			DestroyDynamicObject(FDInfo[i][fObject]);
			count++;
		}

		FDInfo[i][fObject] = 0;
		FDInfo[i][fdX] = 0.0;
		FDInfo[i][fdY] = 0.0;
		FDInfo[i][fdZ] = 0.0;
		FDInfo[i][fWorld] = 0;
		FDInfo[i][fInt] = 0;
		FDInfo[i][fTime] = 0;
		FDInfo[i][fHealth] = 0;
	}

	new string[128];

	if(count > 1 || count == 0)
	{
		format(string, sizeof(string), "%i fires extinguished.", count);
	}
	else
	{
		format(string, sizeof(string), "%i fire extinguished.", count);
	}

	SendClientMessage(playerid, COLOR_WHITE, string);
	return 1;
}
//============================================//
COMMAND:houseeditfurniture(playerid, params[])
{
	if(GetPVarInt(playerid, "Admin") < 7) return SendClientMessage(playerid, COLOR_GREY, "You do not have access to this command.");

	new houseid, option[32];
	if(sscanf(params, "is[32]", houseid, option)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /houseeditfurniture [houseid] [reload/remove]");

	if(strcmp(option, "reload") == 0) {
		for(new i = 0; i < MAX_HOUSE_OBJ; i++) {
			if(IsValidDynamicObject(HouseInfo[houseid][hObject][i])) {
				DestroyDynamicObject(HouseInfo[houseid][hObject][i]);
			}

			HouseInfo[houseid][hObject][i] = 0;
			HouseInfo[houseid][hoID][i] = 0;
			HouseInfo[houseid][hoX][i] = 0.0;
			HouseInfo[houseid][hoY][i] = 0.0;
			HouseInfo[houseid][hoZ][i] = 0.0;
			HouseInfo[houseid][horX][i] = 0.0;
			HouseInfo[houseid][horY][i] = 0.0;
			HouseInfo[houseid][horZ][i] = 0.0;
		}

    	new query[248];
		format(query, sizeof(query), "SELECT * FROM housefurn WHERE HID=%d", houseid);
		mysql_tquery(handlesql, query, "LoadFurn", "i", houseid);

		SendClientMessage(playerid, COLOR_WHITE, "All house furniture reloaded.");
	} else if(strcmp(option, "remove") == 0) {
		RemoveHouseObjects(houseid);
    	SendClientMessage(playerid, COLOR_WHITE, "All house furniture removed.");
	}
	return 1;
}
//============================================//
COMMAND:housefurnitureinfo(playerid, params[])
{
	if(GetPVarInt(playerid, "Admin") < 7) return SendClientMessage(playerid, COLOR_GREY, "You do not have access to this command.");

	new houseid;
	if(sscanf(params, "i", houseid)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /housefurnitureinfo [houseid]");

	for(new i = 0; i < MAX_HOUSE_OBJ; i++)
	{
		if(HouseInfo[houseid][hObject][i] != 0 ||
			HouseInfo[houseid][hoID][i] != 0 ||
			HouseInfo[houseid][hoX][i] != 0.0)
		{
			new string[128];
			format(string, sizeof(string), "hObject: %i | hoID: %i", HouseInfo[houseid][hObject][i], HouseInfo[houseid][hoID][i]);
			SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
		}
	}
	return 1;
}
//============================================//
COMMAND:streamertickrate(playerid, params[])
{
	if(GetPVarInt(playerid, "Admin") < 9) return SendClientMessage(playerid, COLOR_GREY, "You do not have access to this command.");

	new tick_rate;
	if(sscanf(params, "i", tick_rate)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /streamertickrate [tick rate]");

	new old_tick_rate = Streamer_GetTickRate();
	Streamer_SetTickRate(tick_rate);

	new string[128];
	format(string, sizeof(string), "Streamer tick rate has been set from %i to %i.", old_tick_rate, tick_rate);
	SendClientMessage(playerid, COLOR_WHITE, string);
	return 1;
}
//============================================//
COMMAND:streamermaxitems(playerid, params[])
{
	if(GetPVarInt(playerid, "Admin") < 9) return SendClientMessage(playerid, COLOR_GREY, "You do not have access to this command.");

	new type, max_items;
	if(sscanf(params, "ii", type, max_items))
	{
		SendClientMessage(playerid, COLOR_GREY, "USAGE: /streamermaxitems [type] [max items]");
		SendClientMessage(playerid, COLOR_GREY, "TYPES: 0: Object | 1: Pickup | 2: CP | 3: Race CP");
		SendClientMessage(playerid, COLOR_GREY, "TYPES: 4: Map Icon | 5: 3D Text Label | 6: Area");
		return 1;
	}

	new old_max_items = Streamer_GetMaxItems(type);
	Streamer_SetMaxItems(type, max_items);

	new string[128];
	format(string, sizeof(string), "Streamer maximum items have been set from %i to %i.", old_max_items, max_items);
	SendClientMessage(playerid, COLOR_WHITE, string);
	return 1;
}
//============================================//
COMMAND:streamervisibleitems(playerid, params[])
{
	if(GetPVarInt(playerid, "Admin") < 9) return SendClientMessage(playerid, COLOR_GREY, "You do not have access to this command.");

	new type, visible_items;
	if(sscanf(params, "ii", type, visible_items))
	{
		SendClientMessage(playerid, COLOR_GREY, "USAGE: /streamervisibleitems [type] [max visibl items]");
		SendClientMessage(playerid, COLOR_GREY, "TYPES: 0: Object | 1: Pickup | 2: CP | 3: Race CP");
		SendClientMessage(playerid, COLOR_GREY, "TYPES: 4: Map Icon | 5: 3D Text Label | 6: Area");
		return 1;
	}

	new old_visible_items = Streamer_GetVisibleItems(type);
	Streamer_SetVisibleItems(type, visible_items);

	new string[128];
	format(string, sizeof(string), "Streamer maximum visible items have been set from %i to %i.", old_visible_items, visible_items);
	SendClientMessage(playerid, COLOR_WHITE, string);
	return 1;
}
//============================================//
COMMAND:streamerradius(playerid, params[])
{
	if(GetPVarInt(playerid, "Admin") < 9) return SendClientMessage(playerid, COLOR_GREY, "You do not have access to this command.");

	new type, radius;
	if(sscanf(params, "if", type, radius))
	{
		SendClientMessage(playerid, COLOR_GREY, "USAGE: /streamerradius [type] [radius]");
		SendClientMessage(playerid, COLOR_GREY, "TYPES: 0: Object | 1: Pickup | 2: CP | 3: Race CP");
		SendClientMessage(playerid, COLOR_GREY, "TYPES: 4: Map Icon | 5: 3D Text Label | 6: Area");
		return 1;
	}

	new Float:old_radius;
	Streamer_GetRadiusMultiplier(type, old_radius);

	Streamer_SetRadiusMultiplier(type, radius);

	new string[128];
	format(string, sizeof(string), "Streamer radius has been set from %f to %f.", old_radius, radius);
	SendClientMessage(playerid, COLOR_WHITE, string);
	return 1;
}
//============================================//
COMMAND:streamercameraupdate(playerid, params[])
{
	if(GetPVarInt(playerid, "Admin") < 9) return SendClientMessage(playerid, COLOR_GREY, "You do not have access to this command.");

	if(Streamer_IsToggleCameraUpdate(playerid) == 0)
	{
		SendClientMessage(playerid, COLOR_WHITE, "Streamer camera updating has been turned on.");
		Streamer_ToggleCameraUpdate(playerid, 1);
	}
	else
	{
		SendClientMessage(playerid, COLOR_WHITE, "Streamer camera updating has been turned off.");
		Streamer_ToggleCameraUpdate(playerid, 0);
	}
	return 1;
}
//============================================//
COMMAND:streameridleupdate(playerid, params[])
{
	if(GetPVarInt(playerid, "Admin") < 9) return SendClientMessage(playerid, COLOR_GREY, "You do not have access to this command.");

	if(Streamer_IsToggleIdleUpdate(playerid) == 0)
	{
		SendClientMessage(playerid, COLOR_WHITE, "Streamer idle updating has been turned on.");
		Streamer_ToggleIdleUpdate(playerid, 1);
	}
	else
	{
		SendClientMessage(playerid, COLOR_WHITE, "Streamer idle updating has been turned off.");
		Streamer_ToggleIdleUpdate(playerid, 0);
	}
	return 1;
}
//============================================//
COMMAND:resetspawn(playerid, params[])
{
	new id[64], query[128];
	if(sscanf(params, "s[64]", id)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /clearspawn [name]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if(GetPVarInt(playerid, "Admin") >= 1)
		{
		    format(query,sizeof(query),"UPDATE accounts SET World=0, Tut=0, PosX=0.0, PosY=0.0, PosZ=0.0 WHERE Name='%e'", id);
            mysql_tquery(handlesql, query);
			SCM(playerid, -1, "Spawn cleared.");
		}
		else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
COMMAND:vehiclesetspawn(playerid, params[])
{
	if(GetPVarInt(playerid, "Admin") < 1) return nal(playerid);

	new id;
	if(sscanf(params, "i", id)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /vehiclesetspawn [databaseid]");

	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);

	new query[256];
	mysql_format(handlesql, query, sizeof(query), "UPDATE `vehicles` SET `X`=%f, `Y`=%f, `Z`=%f, `VirtualWorld`=%i, `Interior`=%i WHERE `ID`=%i", x, y, z, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), id);
	mysql_tquery(handlesql, query);

	SendClientMessage(playerid, COLOR_WHITE, "Vehicle's spawn point has been set to your current position, virtual world and interior.");
	return 1;
}
//============================================//
COMMAND:checkwounds(playerid, params[])
{
	if(GetPVarInt(playerid, "Admin") < 1) return nal(playerid);
	
	new target;
	if(sscanf(params, "u", target)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /checkwounds [playerid]");

	if(GetPVarInt(target, "Wound_T") == 0 && GetPVarInt(target, "Wound_A") == 0 && GetPVarInt(target, "Wound_L") == 0) return SendClientMessage(playerid, COLOR_GREY, "This player has no wounds.");

	SendClientMessage(playerid, COLOR_WHITE, "_____________________________");
	if(GetPVarInt(target, "Wound_T") != 0)
	{
		SendClientMessage(playerid, COLOR_GREY, "Torso Wound");
	}
	if(GetPVarInt(target, "Wound_A") != 0)
	{
		SendClientMessage(playerid, COLOR_GREY, "Arm Wound");
	}
	if(GetPVarInt(target, "Wound_L") != 0)
	{
		SendClientMessage(playerid, COLOR_GREY, "Leg Wound");
	}
	SendClientMessage(playerid, COLOR_RED, "NOTE: Headwounds don't show up on /checkwounds.");
	SendClientMessage(playerid, COLOR_WHITE, "_____________________________");
	return 1;
}
//============================================//
COMMAND:garage(playerid, params[])
{
	if(GetPVarInt(playerid, "HouseKey") == 0) return SendClientMessage(playerid, COLOR_GREY, "You don't own a house.");

	new option[32];
	if(sscanf(params, "s[32]", option)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /garage [exit/bareswitch]");

	/*if(strcmp(params, "entrance", true) == 0)
  	{
  		new id = GetPVarInt(playerid, "HouseKey");

  		if(HouseInfo[id][hClass] <= 1) return SendClientMessage(playerid, COLOR_GREY, "Only houses of medium class and up can have a garage.");
  		if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_GREY, "You have to be on foot in order to do this.");
  		if(!IsPlayerInRangeOfPoint(playerid, HOUSE_GARAGE_DISTANCE, HouseInfo[id][hXo], HouseInfo[id][hYo], HouseInfo[id][hZo])) return SendClientMessage(playerid, COLOR_GREY, "You are too far away from your house's entrance.");
		
		new string[128];
		format(string, sizeof(string), "Are you sure you want to set up your garage here?\n\nPrice: $%i", GARAGE_ENTRANCE_COST);
        ShowPlayerDialog(playerid, 558, DIALOG_STYLE_MSGBOX, "Garage Entrance", string, "Yes", "No");
  	}*/
  	else if(strcmp(params, "exit", true) == 0)
  	{
  		if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_GREY, "You have to be on foot in order to do this.");
  		if(GetPVarInt(playerid, "GarageEnter") != GetPVarInt(playerid, "HouseKey")) return SendClientMessage(playerid, COLOR_GREY, "You have to be inside of your garage in order to do this.");

  		new string[128];
  		format(string, sizeof(string), "Are you sure you want to set up your garage's exit here?\n\nPrice: %s", FormatMoney(GARAGE_EXIT_COST));
        ShowPlayerDialog(playerid, 559, DIALOG_STYLE_MSGBOX, "Garage Exit", string, "Yes", "No");
  	}
  	else if(strcmp(params, "bareswitch", true) == 0)
  	{
  		new string[128];
  		format(string, sizeof(string), "Are you sure you want to bareswitch your garage?\n\nPrice: %s", FormatMoney(GARAGE_BARESWITCH_COST));
        ShowPlayerDialog(playerid, 560, DIALOG_STYLE_MSGBOX, "Garage Bareswitch", string, "Yes", "No");
  	}
  	/*else if(strcmp(params, "remove", true) == 0)
  	{
  		new string[128];
  		format(string, sizeof(string), "Are you sure you want to remove your garage?");
        ShowPlayerDialog(playerid, 561, DIALOG_STYLE_MSGBOX, "Remove Garage", string, "Yes", "No");
  	}*/
  	else
  	{
  		SendClientMessage(playerid, COLOR_GREY, "USAGE: /garage [exit/bareswitch]");
  	}
  	return 1;
}
//============================================//
COMMAND:housegarage(playerid, params[])
{
	new houseid, interior;
	if(sscanf(params, "ii", houseid, interior)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /housegarage [houseid] [interior]");
	if(GetPVarInt(playerid, "Admin") < 4) return nal(playerid);
	if(interior < 0 || interior >= sizeof(GarageInterior)) return error(playerid, "Non-existant interior ID.");
  		
	new Float:x, Float:y, Float:z, Float:a;
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);

	new string[128];
	format(string, sizeof(string), "WARNING: Moved Property ID: %d's garage to %.2f, %.2f, %.2f.", houseid, x, y, z);
	SendClientMessage(playerid, COLOR_LIGHTBLUE, string);

	DestroyDynamicCP(HouseInfo[houseid][gIcon]);
	HouseInfo[houseid][gIcon] = CreateDynamicCP(x, y, z, 1.5, HouseInfo[houseid][hVwOut], -1, -1, 10.0);
	HouseInfo[houseid][hgXo] = x;
	HouseInfo[houseid][hgYo] = y;
	HouseInfo[houseid][hgZo] = z;
	HouseInfo[houseid][hgAo] = a;

	HouseInfo[houseid][hgXi] = GarageInterior[interior][giX];
	HouseInfo[houseid][hgYi] = GarageInterior[interior][giY];
	HouseInfo[houseid][hgZi] = GarageInterior[interior][giZ];
	HouseInfo[houseid][hgAi] = GarageInterior[interior][giA];
	HouseInfo[houseid][gInterior] = GarageInterior[interior][giInterior];

	HouseInfo[houseid][Garage] = 1;

	SaveHouse(houseid);
	return 1;
}
//============================================//
COMMAND:housegarageinterior(playerid, params[])
{
	new houseid, interior;
	if(sscanf(params, "ii", houseid, interior)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /housegarageinterior [houseid] [interior] (0-1 are the IDs of available interiors)");
	if(GetPVarInt(playerid, "Admin") < 4) return nal(playerid);
	if(interior < 0 || interior >= sizeof(GarageInterior)) return error(playerid, "Non-existant interior ID.");
	
	new string[128];
	format(string, sizeof(string), "WARNING: Changed Property ID: %d's garage interior to %i.", houseid, interior);
	SendClientMessage(playerid, COLOR_LIGHTBLUE, string);

	HouseInfo[houseid][hgXi] = GarageInterior[interior][giX];
	HouseInfo[houseid][hgYi] = GarageInterior[interior][giY];
	HouseInfo[houseid][hgZi] = GarageInterior[interior][giZ];
	HouseInfo[houseid][hgAi] = GarageInterior[interior][giA];
	HouseInfo[houseid][gInterior] = GarageInterior[interior][giInterior];

	SaveHouse(houseid);
	return 1;
}
//============================================//
COMMAND:houseremovegarage(playerid, params[])
{
	new houseid;
	if(sscanf(params, "i", houseid)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /housegarageremove [houseid]");

	if(GetPVarInt(playerid, "Admin") < 4) return nal(playerid);

	new string[128];
	format(string, sizeof(string), "WARNING: Removed Property ID: %d's garage.", houseid);
	SendClientMessage(playerid, COLOR_LIGHTBLUE, string);

	HouseInfo[houseid][hgXo] = 0;
	HouseInfo[houseid][hgYo] = 0;
	HouseInfo[houseid][hgZo] = 0;
	HouseInfo[houseid][hgAo] = 0;

	HouseInfo[houseid][hgXi] = 0;
	HouseInfo[houseid][hgYi] = 0;
	HouseInfo[houseid][hgZi] = 0;
	HouseInfo[houseid][hgAi] = 0;

	HouseInfo[houseid][gInterior] = 0;
	HouseInfo[houseid][Garage] = 0;

	DestroyDynamicCP(HouseInfo[houseid][gIcon]);

	SaveHouse(houseid);
	return 1;
}
//============================================//
ALTCOMMAND:siren->el;
COMMAND:el(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);
	if(GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");

	if(GetPVarInt(playerid, "Member") == 1 || GetPVarInt(playerid, "Member") == 2 || GetPVarInt(playerid, "Member") == 8)
	{
		if(GetPVarInt(playerid, "Member") == 1 && GetPVarInt(playerid, "Rank") < 4)
		{
			return SendClientMessage(playerid, COLOR_GREY, "You do not have access to this command!");
		}
		else if(GetPVarInt(playerid, "Member") == 2 && GetPVarInt(playerid, "Rank") < 4)
		{
			return SendClientMessage(playerid, COLOR_GREY, "You do not have access to this command!");
		}
		else if(GetPVarInt(playerid, "Member") == 8 && GetPVarInt(playerid, "Rank") < 1)
		{
			return SendClientMessage(playerid, COLOR_GREY, "You do not have access to this command!");
		}
	}
	else
	{
		return SendClientMessage(playerid, COLOR_GREY, "You do not have access to this command!");
	}

	if(VehicleInfo[GetPlayerVehicleID(playerid)][vType] != VEHICLE_LSPD && 
		VehicleInfo[GetPlayerVehicleID(playerid)][vType] != VEHICLE_LSFD &&
		VehicleInfo[GetPlayerVehicleID(playerid)][vType] != VEHICLE_GOV) return SendClientMessage(playerid, COLOR_GREY, "You need to be in a LSPD, LSFD or LSG vehicle to use this.");
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOR_GREY, "You must be the driver of a vehicle to use this!");
	if(GetPVarInt(playerid, "Delay") > GetCount()) return SendClientMessage(playerid, COLOR_LIGHTRED, "You must wait before performing this command!");
	if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 523 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 509 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 481 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 510 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 462 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 448 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 522 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 581 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 471 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 461 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 521 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 586 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 468 ||
		GetVehicleModel(GetPlayerVehicleID(playerid)) == 463) return SendClientMessage(playerid, COLOR_GREY, "You can't use emergency lights while on a motorcycle.");

	new option[32];
	if(sscanf(params, "s[32]", option)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /el [on/off/edit/sync]");
	if(!strcmp(option, "on"))
	{
	    SetPVarInt(playerid, "Delay", GetCount()+2000);

	    for(new i = 0; i < MAX_VEHICLE_SIREN_OBJECTS; i++)
		{
			if(VehicleInfo[vehicleid][vSirenObjectID][i] != 0)
			{
				return SendClientMessage(playerid, COLOR_GREY, "This vehicle's sirens are already on.");
			}
		}

		new count = 0;
		for(new i = 0; i < MAX_VEHICLE_SIREN_OBJECTS; i++)
		{
			if(VehicleInfo[vehicleid][vSirenObject][i] != 0)
			{
				count++;
			}
		}

		if(count == 0)
		{
			return SendClientMessage(playerid, COLOR_GREY, "This vehicle has no sirens set up. (/el edit)");
		}

        for(new i = 0; i < MAX_VEHICLE_SIREN_OBJECTS; i++)
		{
			if(VehicleInfo[vehicleid][vSirenObject][i] != 0)
			{
				VehicleInfo[vehicleid][vSirenObjectID][i] = CreateDynamicObject(VehicleInfo[vehicleid][vSirenObject][i], 0, 0, 0, 0.0, 0.0, 0.0);

				AttachDynamicObjectToVehicle(VehicleInfo[vehicleid][vSirenObjectID][i], vehicleid, 
					VehicleInfo[vehicleid][vSirenX][i], VehicleInfo[vehicleid][vSirenY][i], VehicleInfo[vehicleid][vSirenZ][i], 
					VehicleInfo[vehicleid][vSirenXr][i], VehicleInfo[vehicleid][vSirenYr][i], VehicleInfo[vehicleid][vSirenZr][i]);
			}
		}

		new Float:X, Float:Y, Float:Z;
		GetVehicleVelocity(vehicleid, X, Y, Z);
		if(X == 0 && Y == 0 && Z == 0)
		{
			SetVehicleVelocity(vehicleid, X, Y, Z + 0.01);
		}
	}
	else if(!strcmp(option, "off"))
	{
		new count = 0;
		for(new i = 0; i < MAX_VEHICLE_SIREN_OBJECTS; i++)
		{
			if(VehicleInfo[vehicleid][vSirenObjectID][i] != 0)
			{
				count++;
			}
		}

		if(count == 0)
		{
			return SendClientMessage(playerid, COLOR_GREY, "This vehicle's sirens are already off.");
		}

		for(new i = 0; i < MAX_VEHICLE_SIREN_OBJECTS; i++)
		{
			if(VehicleInfo[vehicleid][vSirenObject][i] != 0)
			{
				DestroyDynamicObject(VehicleInfo[vehicleid][vSirenObjectID][i]);
				VehicleInfo[vehicleid][vSirenObjectID][i] = 0;
			}
		}

		new Float:X, Float:Y, Float:Z;
		GetVehicleVelocity(vehicleid, X, Y, Z);
		if(X == 0 && Y == 0 && Z == 0)
		{
			SetVehicleVelocity(vehicleid, X, Y, Z + 0.01);
		}
	}
	else if(!strcmp(option, "edit"))
	{
		SetPVarInt(playerid, "SirenEditorVehicleID", vehicleid);

		ShowPlayerDialog(playerid, DIALOG_SIREN_EDITOR, DIALOG_STYLE_LIST, "Siren Editor", "Add a siren\nRemove a siren", "Select","Exit");

		new count = 0;
		for(new i = 0; i < MAX_VEHICLE_SIREN_OBJECTS; i++)
		{
			if(VehicleInfo[vehicleid][vSirenObject][i] != 0)
			{
				AttachDynamicObjectToVehicle(VehicleInfo[vehicleid][vSirenObject][i], vehicleid, 
					VehicleInfo[vehicleid][vSirenX][i], VehicleInfo[vehicleid][vSirenY][i], VehicleInfo[vehicleid][vSirenZ][i], 
					VehicleInfo[vehicleid][vSirenXr][i], VehicleInfo[vehicleid][vSirenYr][i], VehicleInfo[vehicleid][vSirenZr][i]);
				count++;
			}
		}

		if(count > 0)
		{
			new Float:X, Float:Y, Float:Z;
			GetVehicleVelocity(vehicleid, X, Y, Z);
			if(X == 0 && Y == 0 && Z == 0)
			{
				SetVehicleVelocity(vehicleid, X, Y, Z + 0.01);
			}
		}
	}
	else if(!strcmp(option, "sync"))
	{
		if(VehicleInfo[GetPlayerVehicleID(playerid)][vSirenSync] == 0)
		{
			VehicleInfo[GetPlayerVehicleID(playerid)][vSirenSync] = 1;
			SendClientMessage(playerid, COLOR_WHITE, "Your sirens will now be synced.");

			if(GetVehicleParamsSirenState(vehicleid) == 1)
			{
				for(new i = 0; i < MAX_VEHICLE_SIREN_OBJECTS; i++)
				{
					if(VehicleInfo[vehicleid][vSirenObject][i] != 0)
					{
						DestroyDynamicObject(VehicleInfo[vehicleid][vSirenObjectID][i]);
						VehicleInfo[vehicleid][vSirenObjectID][i] = 0;
					}
				}

				for(new i = 0; i < MAX_VEHICLE_SIREN_OBJECTS; i++)
				{
					if(VehicleInfo[vehicleid][vSirenObject][i] != 0)
					{
						VehicleInfo[vehicleid][vSirenObjectID][i] = CreateDynamicObject(VehicleInfo[vehicleid][vSirenObject][i], 0, 0, 0, 0.0, 0.0, 0.0);

						AttachDynamicObjectToVehicle(VehicleInfo[vehicleid][vSirenObjectID][i], vehicleid, 
							VehicleInfo[vehicleid][vSirenX][i], VehicleInfo[vehicleid][vSirenY][i], VehicleInfo[vehicleid][vSirenZ][i], 
							VehicleInfo[vehicleid][vSirenXr][i], VehicleInfo[vehicleid][vSirenYr][i], VehicleInfo[vehicleid][vSirenZr][i]);
					}
				}

				new Float:X, Float:Y, Float:Z;
				GetVehicleVelocity(vehicleid, X, Y, Z);
				if(X == 0 && Y == 0 && Z == 0)
				{
					SetVehicleVelocity(vehicleid, X, Y, Z + 0.01);
				}
			}
			else
			{
				for(new i = 0; i < MAX_VEHICLE_SIREN_OBJECTS; i++)
				{
					if(VehicleInfo[vehicleid][vSirenObject][i] != 0)
					{
						DestroyDynamicObject(VehicleInfo[vehicleid][vSirenObjectID][i]);
						VehicleInfo[vehicleid][vSirenObjectID][i] = 0;
					}
				}
			}
		}
		else
		{
			VehicleInfo[GetPlayerVehicleID(playerid)][vSirenSync] = 0;
			SendClientMessage(playerid, COLOR_WHITE, "Your sirens will no longer be synced.");
		}
	}
	return 1;
}
//============================================//
COMMAND:elm(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOR_WHITE, "You must be the driver of a vehicle to use this!");
	if(VehicleInfo[GetPlayerVehicleID(playerid)][vType] != VEHICLE_LSPD && 
		VehicleInfo[GetPlayerVehicleID(playerid)][vType] != VEHICLE_LSFD &&
		VehicleInfo[GetPlayerVehicleID(playerid)][vType] != VEHICLE_GOV) return SendClientMessage(playerid, COLOR_WHITE, "You need to be in a LSPD, LSFD or LSG vehicle to use this.");

	new option[32];
	if(sscanf(params, "s[32]", option)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /elm [on/off/sync]");

	if(strcmp(option, "on") == 0)
	{
		if(VehicleInfo[GetPlayerVehicleID(playerid)][vELM] == 1) return SendClientMessage(playerid, COLOR_GREY, "Your vehicle's ELM is already on.");

		new engine, lights, alarm, doors, bonnet, boot, objective;
		GetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, boot, objective);
		SetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, 1, alarm, doors, bonnet, boot, objective);
		
		VehicleInfo[GetPlayerVehicleID(playerid)][vELMLightState] = lights;

		VehicleInfo[GetPlayerVehicleID(playerid)][vELM] = 1;
		GameTextForPlayer(playerid, "~n~~w~ELM ~g~~h~ON~w~!", 2000, 5);
	}
	else if(strcmp(option, "off") == 0)
	{
		if(VehicleInfo[GetPlayerVehicleID(playerid)][vELM] == 0) return SendClientMessage(playerid, COLOR_GREY, "Your vehicle's ELM is already off.");

		new engine, lights, alarm, doors, bonnet, boot, objective;
		GetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, boot, objective);
		SetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, VehicleInfo[GetPlayerVehicleID(playerid)][vELMLightState], alarm, doors, bonnet, boot, objective);
		VehicleInfo[GetPlayerVehicleID(playerid)][vLights] = VehicleInfo[GetPlayerVehicleID(playerid)][vELMLightState];

		VehicleInfo[GetPlayerVehicleID(playerid)][vELM] = 0;
		VehicleInfo[GetPlayerVehicleID(playerid)][vELMFlash] = 0;
		GameTextForPlayer(playerid, "~n~~w~ELM ~r~~h~OFF~w~!", 2000, 5);
	}
	else if(strcmp(option, "sync") == 0)
	{
		if(VehicleInfo[GetPlayerVehicleID(playerid)][vELMSync] == 0)
		{
			if(GetVehicleParamsSirenState(GetPlayerVehicleID(playerid)) == 1)
			{
				new engine, lights, alarm, doors, bonnet, boot, objective;
				GetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, boot, objective);
				VehicleInfo[GetPlayerVehicleID(playerid)][vELMLightState] = lights;

				VehicleInfo[GetPlayerVehicleID(playerid)][vELM] = 1;
			}
			else
			{
				VehicleInfo[GetPlayerVehicleID(playerid)][vELM] = 0;
			}

			VehicleInfo[GetPlayerVehicleID(playerid)][vELMSync] = 1;
			SendClientMessage(playerid, COLOR_WHITE, "Your vehicle's ELM will now be synced with sirens.");
		}
		else
		{
			VehicleInfo[GetPlayerVehicleID(playerid)][vELMSync] = 0;
			SendClientMessage(playerid, COLOR_WHITE, "Your vehicle's ELM will no longer be synced with sirens.");
		}
	}
	else
	{
		SendClientMessage(playerid, COLOR_GREY, "USAGE: /elm [on/off/sync]");
	}
	return 1;
}
//============================================//
ALTCOMMAND:accent->prefix;
COMMAND:prefix(playerid, params[])
{
	new text[128];
	if(strcmp(PlayerInfo[playerid][pAccent], "None", true) == 0) {}
	else
	{
	    SendClientMessage(playerid, COLOR_LIGHTRED, "Prefix disabled.");
		strmid(PlayerInfo[playerid][pAccent], "None", 0, strlen("None"), 255);
		return true;
	}
	if(sscanf(params, "s[128]", text)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /prefix [text]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(strlen(text) < 4 || strlen(text) > 65) return SendClientMessage(playerid, COLOR_WHITE, "Prefix is too short(4) or too long(65).");
		if(strcmp(PlayerInfo[playerid][pAccent], "None", true) == 0)
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "Prefix enabled.");
		    strmid(PlayerInfo[playerid][pAccent], text, 0, strlen(text), 255);
		}
	}
	return 1;
}
//============================================//
COMMAND:fish(playerid, params[])
{
	if(PlayerInfo[playerid][pFishing] == 1) return SendClientMessage(playerid, COLOR_WHITE, "You're already fishing.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "You can't fish while in a vehicle.");
	if(PlayerInWater(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "You can't fish while swimming.");
	if(GetPVarInt(playerid, "Dead") > 0) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while dead.");
	if(GetPVarInt(playerid, "Cuffed") > 0) return SendClientMessage(playerid, COLOR_GREY, "You can't do this while handcuffed/tazed.");
	if(GetPVarInt(playerid, "Jailed") > 0) return SendClientMessage(playerid, COLOR_WHITE, "Cannot use this command while in-jail.");
	if(!CheckInvItem(playerid, 1007)) return SendClientMessage(playerid, COLOR_WHITE, "You don't have a Fishing Rod.");
	if(!CheckInvItem(playerid, 1051)) return SendClientMessage(playerid, COLOR_WHITE, "You don't have any bait.");
	if(CanFishHere(playerid) == 0) return SendClientMessage(playerid, COLOR_WHITE, "You can't fish here.");
	PlayerInfo[playerid][pFishing]=1;
    if(IsPlayerAttachedObjectSlotUsed(playerid,HOLDOBJECT_CLOTH4)) RemovePlayerAttachedObject(playerid,HOLDOBJECT_CLOTH4);
	SetPlayerAttachedObject(playerid, HOLDOBJECT_CLOTH4, 18632, 6, 0.087079, 0.048070, 0.031638, 185.621994, 0.0, 0.0, 1.0, 1.0, 1.0);
	RemoveInvItem(playerid, 1051, 1);
	TogglePlayerControllableEx(playerid, false);
	scm(playerid, COLOR_BLUE, "[TIP] {FFFFFF}You're now fishing, press '~k~~PED_LOCK_TARGET~' to cancel.");
	new rand = randomEx(10000,25000);
	ApplyAnimation(playerid, "SAMP", "FishingIdle", 4.1, 0, 0, 0, 1, rand);
	ShowFishingTD(playerid);
	PlayerInfo[playerid][pFishTimer] = SetTimerEx("HandleFishing", rand, 0, "i", playerid);
	new sendername[MAX_PLAYER_NAME];
	format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
	GiveNameSpace(sendername);
	new string[84];
	format(string, sizeof(string), "*** %s baits their fishing hook, casting it into the water.", sendername);
	ProxDetector(30.0, playerid, string, COLOR_PURPLE);
	return 1;
}
//============================================//
ALTCOMMAND:gs->gunserial;
COMMAND:gunserial(playerid, params[])
{
    if(GetPVarInt(playerid, "Delay") > GetCount()) return SendClientMessage(playerid, COLOR_LIGHTRED, "You must wait before performing this command!");
	if(PlayerInfo[playerid][pPlayerWeapon] >= 22 && PlayerInfo[playerid][pPlayerWeapon] <= 38)
	{
	    new string[128], serial[12], sendername[MAX_PLAYER_NAME], gunname[25];
	    if(PlayerInfo[playerid][pSerial] == 0) serial="UNKNOWN";
	    else format(serial, 25, "%d", PlayerInfo[playerid][pSerial]);
	    GetWeaponName(PlayerInfo[playerid][pPlayerWeapon], gunname, sizeof(gunname));
	    format(string, sizeof(string), "%s's Serial-ID: %s.", gunname, serial);
	    scm(playerid, -1, string);
	    format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
		GiveNameSpace(sendername);
	    format(string, sizeof(string), "* %s checks %s %s's serial.", sendername, CheckSex(playerid), gunname);
    	SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 10000);
	}
	else error(playerid, "You currently have no weapon equipped.");
	return 1;
}
//============================================//
COMMAND:itemname(playerid, params[])
{
	if(GetPVarInt(playerid, "Admin") < 4) return nal(playerid);
	
	new itemid, string[64];
	if(sscanf(params, "i", itemid)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /itemname [item-ID]");

	for(new i = 0; i < sizeof(ItemIDs); i++)
	{
		if(ItemIDs[i][ItemID] == itemid)
		{
			format(string, sizeof(string), "%s (%i)", ItemIDs[i][Name], ItemIDs[i][ItemID]);
			return SendClientMessage(playerid, COLOR_GREY, string);
		}
	}
	return SendClientMessage(playerid, COLOR_GREY, "Item not found.");
}
//============================================//
COMMAND:itemid(playerid, params[])
{
	if(GetPVarInt(playerid, "Admin") < 4) return nal(playerid);

	new item_name[64], string[128];
	if(sscanf(params, "s[64]", item_name)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /itemid [(Part of) Item Name]");

	new count;
	for(new i = 0; i < sizeof(ItemIDs); i++)
	{
		if(strfind(ItemIDs[i][Name], item_name, true) != -1)
		{
			count++;
			format(string, sizeof(string), "%s (%i)", ItemIDs[i][Name], ItemIDs[i][ItemID]);
			SendClientMessage(playerid, COLOR_GREY, string);
		}
	}

	if(count == 0) { SendClientMessage(playerid, COLOR_GREY, "No items found."); }
	return 1;
}
//============================================//
COMMAND:cw(playerid, params[])
{
	if(!IsPlayerInAnyVehicle(playerid) && PlayerInfo[playerid][pInVehicle] == -1) return SendClientMessage(playerid, COLOR_GREY, "You have to be in a vehicle in order to use this.");
	new myVeh = GetPlayerVehicleID(playerid);
	if(IsNotAEngineCarEx(GetVehicleModel(myVeh)) && IsEnterableVehicle(myVeh) == -1) return SendClientMessage(playerid, COLOR_GREY, "You can't use this command in this vehicle.");
	new text[128];
	if(sscanf(params, "s[128]", text)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /cw [text]");

	new string[128], sendername[MAX_PLAYER_NAME];
	format(sendername, MAX_PLAYER_NAME, "%s", GiveNameSpaceEx(PlayerNameEx(playerid)));
	format(string, sizeof(string), "*** %s whispers something.", sendername);
	SetPlayerChatBubble(playerid, string, COLOR_PURPLE, 30.0, 10000);

	new myInVeh = PlayerInfo[playerid][pInVehicle];
	foreach(new i : Player) {
		if(myVeh == GetPlayerVehicleID(i) || GetPlayerVehicleID(i) == myInVeh || myVeh == PlayerInfo[i][pInVehicle] || (myInVeh != -1 && myInVeh == PlayerInfo[i][pInVehicle])) {
	        format(string, sizeof(string), "%s whispers: %s", sendername, text);
			SendClientMessage(i,  COLOR_YELLOW, string);
		}
	}
	return 1;
}
//============================================//
COMMAND:removetickets(playerid, params[])
{
	if(GetPVarInt(playerid, "Member") != 1 || GetPVarInt(playerid, "Rank") < 3) return SendClientMessage(playerid, COLOR_GREY, "You have to be at least Rank 3 in the LSPD to do this.");
	new targetid;
	if(sscanf(params, "i", targetid)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /removetickets [playerid]");
	if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_GREY, "This player is not connected.");

	new query[128];
	mysql_format(handlesql, query, sizeof(query), "DELETE FROM tickets WHERE player='%s'", PlayerInfo[targetid][pUsername]);
	mysql_tquery(handlesql, query);

	format(query, sizeof(query), "Officer %s has removed %s's tickets.", GiveNameSpaceEx(PlayerInfo[playerid][pUsername]), GiveNameSpaceEx(PlayerInfo[targetid][pUsername]));
	SendFactionMessage(1, COLOR_BLUE, query);
	return 1;
}
//============================================//
COMMAND:ahide(playerid, params[])
{
	new aimid, string[128];
	if(sscanf(params, "i", aimid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /ahide [0-2]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Admin") <= 3) return SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	    SetPVarInt(playerid, "AHide", aimid);
	    format(string, 128, "Hidden Admin set to %d.", aimid);
	    scm(playerid, -1, string);
	}
	
	return 1;
}
//============================================//
COMMAND:viewshipment(playerid, params[])
{
	if(GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	new factionid;
	if(sscanf(params, "i", factionid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /viewshipment [faction-id]");
	else
	{
		if(GetPVarInt(playerid, "Admin") > 2) {
			if(FactionInfo[factionid][fUsed] == 0) return SendClientMessage(playerid, COLOR_GREY, "This faction doesn't exist!");
			if(ShipmentCache[factionid][sUsed] == 0) return SendClientMessage(playerid, COLOR_GREY, "This faction doesn't have a shipment order that requires approval!");
			new found = -1;
			foreach(new i : Player) {
				if(strcmp(PlayerName(i), ShipmentCache[factionid][sName], true) == 0) {
					found = i;
					break;
				}
			}
			if(found == -1) {		
				ClearShipmentCache(factionid);
				SendFactionMessage(factionid, COLOR_ORANGE, "[NOTICE] {FFFFFF}Your pending faction shipment request has been cancelled as the buyer is offline.");
				return SendClientMessage(playerid, COLOR_ORANGE, "[NOTICE] {FFFFFF}The player who ordered the shipment is no longer online, so the shipment has been cancelled.");
			}
			SetPVarInt(playerid, "ShipmentAdmin", factionid);
			new result[624];
			for(new i=0; i < MAX_SHIPMENT_SLOTS; i++) {
				if(ShipmentCache[factionid][sShipmentID][i] > 0) {						
					if(ShipmentCache[factionid][sShipmentA][i] > 1 || IsQuantityItem(ShipmentCache[factionid][sShipmentID][i])) {
						format(result, sizeof(result), "%s\n%s (%d)", result, PrintIName(ShipmentCache[factionid][sShipmentID][i]), ShipmentCache[factionid][sShipmentA][i]);
					} else format(result, sizeof(result), "%s\n%s", result, PrintIName(ShipmentCache[factionid][sShipmentID][i]));
				} else format(result, sizeof(result), "%s\nEMPTY SLOT", result);
			}
			ShowPlayerDialog(playerid, DIALOG_SHIPMENT_AVIEW, DIALOG_STYLE_MSGBOX, "Shipment Info", result, "Options", "Exit");
		}
		else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
COMMAND:aimpound(playerid, params[])
{
    if(GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if(GetPVarInt(playerid, "Admin") >= 1) {
		new vehicleid, price;
		if(sscanf(params, "ii", vehicleid, price)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /aimpound [vehicle-id] [price] (Use /dl to see vehicle IDs.) ($1 - $2500)");
		else {
			if(price < 1 || price > 2500) return SendClientMessage(playerid, COLOR_WHITE, "The impound fee can only be set to a minimum of $1 and a maximum of $2500.");
			foreach(new car : Vehicle) {
				if(car == vehicleid) {
					if(VehicleInfo[car][vType] == VEHICLE_PERSONAL) { 
						ImpoundVehicle(VehicleInfo[car][vID], price);
						foreach(new i : Player) {
							if(strcmp(VehicleInfo[car][vOwner], PlayerInfo[i][pUsername], false) == 0) {
								new string[200];
								format(string, sizeof(string), "[NOTICE] {FFFFFF}Your %s has be admin-impounded by %s. The impound fee is set to $%d.", VehicleName[GetVehicleModel(car)-400], AdminName(playerid), price);
								SendClientMessage(i, COLOR_ORANGE, string);
								SendClientMessage(i, COLOR_BLUE, "[TIP] {FFFFFF}You can release your car by going to the impound lot. (/locations)");
								format(string, sizeof(string), "[IMPOUND][ADMIN] %s's %s was impounded by %s(%s). The impound fee is set to $%d.", PlayerName(i), VehicleName[GetVehicleModel(car)-400], AdminName(playerid), PlayerName(playerid), price);
								ImpoundLog(string);
								break;
							}
						}
						DespawnVehicle(car);
					} else SendClientMessage(playerid, COLOR_WHITE, "This is not a player-owned vehicle!");			
					return 1;
				}
			}
			SendClientMessage(playerid, COLOR_GREY, "No vehicle could be found with this ID.");
		}
    }
    else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	return 1;
}
//============================================//
COMMAND:tempban(playerid, params[])
{
	if(GetPVarInt(playerid, "Admin") < 2) return SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	new user, days, reason[128];
	if(sscanf(params, "uis[128]", user, days, reason)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /tempban [playerid] [days] [reason]");
	if(!IsPlayerConnected(user)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
 	if(IsPlayerNPC(user)) return SendClientMessage(playerid, COLOR_GREY, "Can't do this to a NPC.");
 	if(days < 1 || days > 14) return SendClientMessage(playerid, COLOR_GREY, "You can only temp-ban a player for 1-14 days.");
	new text[MAX_DOUBLE_MSG_LENGTH];
	format(text, sizeof(text), "AdmCmd: %s was temp-banned by Admin %s. (Reason: %s)", PlayerInfo[user][pName], AdminName(playerid), reason);
	SendClientMessageToAllEx(COLOR_LIGHTRED, text);
	BanPlayer(user, reason, AdminName(playerid), days);
	format(text, sizeof(text), "[TEMP-BAN][ONLINE][%s] %s", PlayerName(playerid), text);
	BanLog(text);
	return 1;
}
//============================================//
COMMAND:tempbanacc(playerid, params[])
{
	if(GetPVarInt(playerid, "Admin") < 4) return SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	new name[MAX_PLAYER_NAME], days, reason[128], ip[32];
	if(sscanf(params, "s[25]is[128]S(No IP given)[32]", name, days, reason)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /tempbanacc [firstname_lastname] [days] [reason] [IP Address(optional)]");
 	if(days < 1 || days > 14) return SendClientMessage(playerid, COLOR_GREY, "You can only temp-ban a player for 1-14 days.");
	if(strlen(ip) < 7) format(ip, sizeof(ip), "No IP given");
	new text[MAX_DOUBLE_MSG_LENGTH];
	format(text, sizeof(text), "AdmCmd: %s was offline temp-banned by Admin %s. (Reason: %s)", name, AdminName(playerid), reason);
	SendClientMessageToAllEx(COLOR_LIGHTRED, text);
	BanPlayerO(name, ip, reason, AdminName(playerid), days);
	format(text, sizeof(text), "[TEMP-BAN][OFFLINE][%s] %s", PlayerName(playerid), text);
	BanLog(text);
	return 1;
}
//============================================//
COMMAND:toggleoutdoorfurn(playerid, params[])
{
	if(GetPVarInt(playerid, "Admin") < 9) return SendClientMessage(playerid, COLOR_GREY, "You do not have access to this command.");

	if(outdoor_furn == 0) { //Enable
		outdoor_furn = 1;
		foreach(new i : HouseIterator)
		{
			for(new i2 = 0; i2 < MAX_HOUSE_OBJ; i2++) {
				if(HouseInfo[i][hoID][i2] != 0) {
					if(IsHouseOutdoorObject(i, i2)) {
						HouseInfo[i][hObject][i2] = CreateDynamicObject(HouseInfo[i][hoID][i2], HouseInfo[i][hoX][i2], HouseInfo[i][hoY][i2], HouseInfo[i][hoZ][i2], HouseInfo[i][horX][i2], HouseInfo[i][horY][i2], HouseInfo[i][horZ][i2], HouseInfo[i][hVwOut], -1, -1, 100);

						for(new v = 0; v < 13; v++) {
							if(HouseMInfo[i][i2][v] != 0) {
								ChangeDynamicObjectMaterial(HouseInfo[i][hObject][i2], v, HouseMInfo[i][i2][v]);
							}
						}
					}
				}
			}
		}

		foreach(new i : BizIterator) {
			for(new i2 = 0; i2 < MAX_HOUSE_OBJ; i2++) {
				if(BizInfo[i][boID][i2] != 0) {
					if(IsBizzOutdoorObject(i, i2)) {
						BizInfo[i][bObject][i2] = CreateDynamicObject(BizInfo[i][boID][i2], BizInfo[i][boX][i2], BizInfo[i][boY][i2], BizInfo[i][boZ][i2], BizInfo[i][borX][i2], BizInfo[i][borY][i2], BizInfo[i][borZ][i2], 0, -1, -1, 100);

						for(new v = 0; v < 13; v++) {
							if(BizMInfo[i][i2][v] != 0) {
								ChangeDynamicObjectMaterial(BizInfo[i][bObject][i2], v, BizMInfo[i][i2][v]);
							}
						}
					}
				}
			}
		}

		SendClientMessage(playerid, COLOR_WHITE, "All outdoor objects spawned. Outdoor furniture enabled.");
	} else { //Disable.
		outdoor_furn = 0;
		foreach(new i : HouseIterator)
		{
			for(new i2 = 0; i2 < MAX_HOUSE_OBJ; i2++) {
				if(IsHouseOutdoorObject(i, i2)) {
					DestroyDynamicObject(HouseInfo[i][hObject][i2]);
				}
			}
		}

		foreach(new i : BizIterator)
		{
			for(new i2 = 0; i2 < MAX_HOUSE_OBJ; i2++) {
				if(IsBizzOutdoorObject(i, i2)) {
					DestroyDynamicObject(BizInfo[i][bObject][i2]);
				}
			}
		}

		SendClientMessage(playerid, COLOR_WHITE, "All outdoor objects removed. Outdoor furniture disabled.");
	}
	return 1;
}
//============================================//
COMMAND:forbid(playerid, params[])
{
	new targetid,hr,string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "ui", targetid, hr)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /forbid [playerid] [hours]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
	    if(IsPlayerNPC(targetid)) return SendClientMessage(playerid, COLOR_GREY, "Can't do this to a NPC.");
		if(GetPVarInt(playerid, "Admin") >= 1)
		{
   			format(sendername, sizeof(sendername), "%s", PlayerInfo[playerid][pUsername]);
      		format(giveplayer, sizeof(giveplayer), "%s", PlayerInfo[targetid][pUsername]);
      		GiveNameSpace(sendername);
      		GiveNameSpace(giveplayer);
      		if(GetPVarInt(playerid, "Admin") >= 11) sendername = "Hidden";
      		format(string, sizeof(string), "AdmCmd: %s was weapon-restricted by %s for %d hours.", giveplayer, sendername, hr);
      		SendAdminMessage(COLOR_LIGHTRED,string);
			PlayerInfo[targetid][pForbid] = hr;
			SaveForbid(targetid);
      		format(string, sizeof(string), "You have been forbidden to use weapons for %d hours.", hr);
      		scm(targetid, COLOR_LIGHTRED,string);
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
COMMAND:unforbid(playerid, params[])
{
	new targetid,string[128],sendername[MAX_PLAYER_NAME],giveplayer[MAX_PLAYER_NAME];
	if(sscanf(params, "u", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /unforbid [playerid]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if (!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
	    if(IsPlayerNPC(targetid)) return SendClientMessage(playerid, COLOR_GREY, "Can't do this to a NPC.");
		if(GetPVarInt(playerid, "Admin") >= 1)
		{
   			format(sendername, sizeof(sendername), "%s", PlayerInfo[playerid][pUsername]);
      		format(giveplayer, sizeof(giveplayer), "%s", PlayerInfo[targetid][pUsername]);
      		GiveNameSpace(sendername);
      		GiveNameSpace(giveplayer);
      		if(GetPVarInt(playerid, "Admin") >= 11) sendername = "Hidden";
      		format(string, sizeof(string), "AdmCmd: %s was unweapon-restricted by %s", giveplayer, sendername);
      		SendAdminMessage(COLOR_LIGHTRED,string);
			PlayerInfo[targetid][pForbid] = 0;
			SaveForbid(targetid);
		}
		else
		{
		    SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
		}
	}
	return 1;
}
//============================================//
COMMAND:ab(playerid, params[])
{
	if(GetPVarInt(playerid, "Admin") < 1) return nal(playerid);

	new text[256],string[256],sendername[MAX_PLAYER_NAME];
	if(sscanf(params, "s[256]", text)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /ab {FFFFFF}[ooc chat]");
	else
	{
	    if (GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	    if(GetPVarInt(playerid, "Mute") == 1) return SendClientMessage(playerid, COLOR_LIGHTRED, "You are currently muted!");
		format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
		GiveNameSpace(sendername);

		format(string, sizeof(string), "(( %s: %s ))", AdminName(playerid), text);

		if((GetPVarInt(playerid, "Admin") == 11 || GetPVarInt(playerid, "AHide") > 0) && GetPlayerState(playerid) == PLAYER_STATE_SPECTATING) {
		    format(string, sizeof(string), "(( Hidden: %s ))", text);
		}

		switch(GetPVarInt(playerid, "Admin"))
		{
		    case 1 .. 3: ProxDetector(20.0, playerid, string, COLOR_ADMIN); // Moderator
		    case 4 .. 9: ProxDetector(20.0, playerid, string, COLOR_SENIOR_ADMIN); // Senior
		    case 10 .. 11: ProxDetector(20.0, playerid, string, COLOR_LEAD_ADMIN); // Lead Admin
			default: ProxDetector(20.0, playerid, string, COLOR_LEAD_ADMIN); // Lead Admin
		}
	}
	return 1;
}
//============================================//
COMMAND:gotopos(playerid, params[])
{
	new Float:x, Float:y, Float:z, vw, interior;
	if(sscanf(params, "fffI(-1)I(-1)", x, y, z, vw, interior)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /gotopos [x] [y] [z] (Optional: [vw] [interior])");
	if(GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	if(GetPVarInt(playerid, "Admin") >= 4) {
		if(IsPlayerInAnyVehicle(playerid)) {
			SetVehiclePosEx(GetPlayerVehicleID(playerid),x,y+4,z);
			if(vw != -1) {
				SetPlayerVirtualWorld(playerid,vw);
				SetVehicleVirtualWorldEx(GetPlayerVehicleID(playerid),vw);
			}
			if(interior != -1) {
				SetPlayerInterior(playerid,interior);
				LinkVehicleToInteriorEx(GetPlayerVehicleID(playerid),interior);	
			}
		} else {				
			if(vw != 0 || interior != 0) TempFreeze(playerid);
			SetPlayerPosEx(playerid,x,y+2,z);
			if(vw != -1) SetPlayerVirtualWorld(playerid,vw);
			if(interior != -1) SetPlayerInterior(playerid,interior);
		}
		SendClientMessage(playerid,COLOR_GREY,"You have been teleported.");

		SetPVarInt(playerid, "IntEnter", 0);
		SetPVarInt(playerid, "BizzEnter", 0);
		SetPVarInt(playerid, "HouseEnter", 0);
		SetPVarInt(playerid, "GarageEnter", 0);
		PlayerInfo[playerid][pInVehicle] = -1;
	} else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	return 1;
}
//============================================//
COMMAND:relativepos(playerid, params[])
{
	new targetid, Float:offx, Float:offy, Float:offz;
	if(sscanf(params, "ifff", targetid, offx, offy, offz)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /relativepos [vehicleid] [offx] [offy] [offz]");
	else
	{
	    if(GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if(GetPVarInt(playerid, "Admin") >= 10) {
			new Float:RelOutput[3];
			GetVehicleRelativePos(targetid, RelOutput[0], RelOutput[1], RelOutput[2], offx, offy, offz);
			SetPlayerPosEx(playerid, RelOutput[0], RelOutput[1], RelOutput[2]);
			new string[128];
			format(string, sizeof(string), "Relative: %f %f %f", RelOutput[0], RelOutput[1], RelOutput[2]);
			SendClientMessage(playerid, COLOR_ORANGE, string);
		} else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
COMMAND:impound(playerid, params[])
{
    if(GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    if((GetPVarInt(playerid, "Member") == 5 && GetPVarInt(playerid, "Rank") > 1) || (GetPVarInt(playerid, "Member") == 1 && GetPVarInt(playerid, "Rank") > 1)) {
		new price;
		if(sscanf(params, "i", price)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /impound [price] ($1 - $2500)");
		else {
			new myCar = GetPlayerVehicleID(playerid);
			if(myCar == 0) return SendClientMessage(playerid, COLOR_WHITE, "You aren't even in a car!");
			new car = GetVehicleTrailer(myCar);
			if(car == 0) return SendClientMessage(playerid, COLOR_WHITE, "You aren't even towing a car!");
			if(!IsPlayerInRangeOfPoint(playerid, 5, 1652.9574, -1838.5597, 13.5460)) return SendClientMessage(playerid, COLOR_WHITE, "You aren't at the impound-spot.");
			if(price < 1 || price > 2500) return SendClientMessage(playerid, COLOR_WHITE, "The impound fee can only be set to a minimum of $1 and a maximum of $2500.");
			new string[184];
			switch(VehicleInfo[car][vType])
			{
				case VEHICLE_PERSONAL:
				{
					ImpoundVehicle(VehicleInfo[car][vID], price);
					new found = 0;
					foreach(new i : Player) {
						if(strcmp(VehicleInfo[car][vOwner], PlayerInfo[i][pUsername], false) == 0) {						
							format(string, sizeof(string), "[NOTICE] {FFFFFF}Your %s has be impounded. The impound fee is set to $%d.", VehicleName[GetVehicleModel(car)-400], price);
							SendClientMessage(i, COLOR_ORANGE, string);
							SendClientMessage(i, COLOR_BLUE, "[TIP] {FFFFFF}You can release your car by going to the impound lot. (/locations)");
							format(string, sizeof(string), "[IMPOUND] %s's %s was impounded by %s. The impound fee is set to $%d.", PlayerName(i), VehicleName[GetVehicleModel(car)-400], PlayerName(playerid), price);
							ImpoundLog(string);
							found = 1;
							break;
						}
					}
					if(found == 0) {
						format(string, sizeof(string), "[IMPOUND] Vehicle #%i (%s) was impounded by %s. The impound fee is set to $%d. Owner: %s.", VehicleInfo[car][vID], VehicleName[GetVehicleModel(car)-400], PlayerName(playerid), price, VehicleInfo[car][vOwner]);
						ImpoundLog(string);
					}
					format(string, sizeof(string), "You've impounded %s's %s with a release-fee of $%d.", VehicleInfo[car][vOwner], VehicleName[GetVehicleModel(car)-400], price);
					SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
					DespawnVehicle(car);
					return 1;					
				}
				case VEHICLE_LSPD:
				{
					format(string, sizeof(string), "[IMPOUND][FACTION][LSPD] %s impounded a %s.", PlayerName(playerid), VehicleName[GetVehicleModel(car)-400]);
					ImpoundLog(string);
					SendClientMessage(playerid, COLOR_LIGHTBLUE, "You've impounded a LSPD vehicle, it has been de-spawned.");
					DespawnVehicle(car);
					return 1;
				}
				case VEHICLE_LSFD:
				{
					format(string, sizeof(string), "[IMPOUND][FACTION][LSFD] %s impounded a %s.", PlayerName(playerid), VehicleName[GetVehicleModel(car)-400]);
					ImpoundLog(string);
					SendClientMessage(playerid, COLOR_LIGHTBLUE, "You've impounded a LSFD vehicle, it has been de-spawned.");
					DespawnVehicle(car);
					return 1;
				}	
				case VEHICLE_GOV:
				{
					format(string, sizeof(string), "[IMPOUND][FACTION][GOV] %s impounded a %s.", PlayerName(playerid), VehicleName[GetVehicleModel(car)-400]);
					ImpoundLog(string);
					SendClientMessage(playerid, COLOR_LIGHTBLUE, "You've impounded a government vehicle, it has been de-spawned.");
					DespawnVehicle(car);
					return 1;
				}	
				case VEHICLE_ADMIN:
				{
					SendClientMessage(playerid, COLOR_LIGHTBLUE, "You've impounded an admin vehicle, it has been de-spawned.");
					DespawnVehicle(car);
					return 1;
				}	
				default: { SendClientMessage(playerid, COLOR_LIGHTBLUE, "You can't impound this vehicle!"); }
			}
		}
    } else SendClientMessage(playerid, COLOR_LIGHTRED, "You have to be at-least rank 2 in the Rapid Recovery or LSPD faction.");
	return 1;
}
//============================================//
ALTCOMMAND:spawntt->spawntowtruck;
COMMAND:spawntowtruck(playerid, params[])
{
	if(GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	if(GetPVarInt(playerid, "Member") == 5 && GetPVarInt(playerid, "Rank") > 1) {
	    if(IsPlayerInRangeOfPoint(playerid, 3, 1616.0746, -1897.0616, 13.5491)) {
	        foreach(new car : Vehicle) {
		        if(CopInfo[car][Created] == 1) {
		            if(strcmp(CopInfo[car][Owner], PlayerInfo[playerid][pUsername], true) == 0) {
			            SendClientMessage(playerid, COLOR_GREY, "You already have a tow truck spawned, please /despawntowtruck.");
			            return 1;
			        }
		        }
	        }
	        CreateTowTruck(playerid);
	    }
	} else SendClientMessage(playerid, COLOR_LIGHTRED, "You must be at-least rank 2 in the Rapid Recovery faction.");
	return 1;
}
//============================================//
COMMAND:bolo(playerid, params[])
{
    if(GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	if(GetPVarInt(playerid, "Member") == 1 && GetPVarInt(playerid, "Rank") >= 1) {
		ShowPlayerDialog(playerid,DIALOG_BOLO,DIALOG_STYLE_LIST,"Bolo Menu","View Bolo's\nAdd Bolo\nRemove Bolo\nExit","Select", "");
	} else { SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!"); }
	return 1;
}
//============================================//
COMMAND:housebackdoor(playerid, params[])
{
	if(GetPVarInt(playerid, "Admin") < 3) return nal(playerid);
	new id;
	if(sscanf(params, "i", id)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /housebackdoor [houseid]");

	if(GetPVarInt(playerid, "HouseEnter") == id) {
		new Float:pos[3];
		GetPlayerPos(playerid, pos[0], pos[1], pos[2]);

		HouseInfo[id][hbdXi] = pos[0];
		HouseInfo[id][hbdYi] = pos[1];
		HouseInfo[id][hbdZi] = pos[2];

		DestroyDynamicCP(HouseInfo[id][hbdiIcon]);
		HouseInfo[id][hbdiIcon] = CreateDynamicCP(HouseInfo[id][hbdXi], HouseInfo[id][hbdYi], HouseInfo[id][hbdZi], 1.5, id, -1, -1, 5.0);

		SaveHouse(id);

		new string[128];
		format(string, sizeof(string), "WARNING: Set Property ID: %d's inside backdoor to %.2f %.2f %.2f.", id, pos[0], pos[1], pos[2]);
		SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
	} else if(GetPVarInt(playerid, "HouseEnter") == 0) {
		new Float:pos[3];
		GetPlayerPos(playerid, pos[0], pos[1], pos[2]);

		HouseInfo[id][hbdXo] = pos[0];
		HouseInfo[id][hbdYo] = pos[1];
		HouseInfo[id][hbdZo] = pos[2];

		DestroyDynamicCP(HouseInfo[id][hbdoIcon]);
		HouseInfo[id][hbdoIcon] = CreateDynamicCP(HouseInfo[id][hbdXo], HouseInfo[id][hbdYo], HouseInfo[id][hbdZo], 1.5, HouseInfo[id][hVwOut], -1, -1, 5.0);

		SaveHouseBackdoor(id);

		new string[128];
		format(string, sizeof(string), "WARNING: Set Property ID: %d's outside backdoor to %.2f %.2f %.2f.", id, pos[0], pos[1], pos[2]);
		SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
	}
	return 1;
}
//============================================//
COMMAND:housebackdoorremove(playerid, params[])
{
	if(GetPVarInt(playerid, "Admin") < 3) return nal(playerid);
	new id;
	if(sscanf(params, "i", id)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /housebackdoorremove [houseid]");

	if(GetPVarInt(playerid, "HouseEnter") == id) {
		HouseInfo[id][hbdXi] = 0;
		HouseInfo[id][hbdYi] = 0;
		HouseInfo[id][hbdZi] = 0;

		DestroyDynamicCP(HouseInfo[id][hbdiIcon]);

		SaveHouse(id);

		new string[128];
		format(string, sizeof(string), "WARNING: Removed Property ID: %d's inside backdoor.", id);
		SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
	} else if(GetPVarInt(playerid, "HouseEnter") == 0) {
		HouseInfo[id][hbdXo] = 0;
		HouseInfo[id][hbdYo] = 0;
		HouseInfo[id][hbdZo] = 0;

		DestroyDynamicCP(HouseInfo[id][hbdoIcon]);

		SaveHouseBackdoor(id);

		new string[128];
		format(string, sizeof(string), "WARNING: Removed Property ID: %d's outside backdoor.", id);
		SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
	}
	return 1;
}
//============================================//
COMMAND:bizbackdoor(playerid, params[])
{
	if(GetPVarInt(playerid, "Admin") < 3) return nal(playerid);

	new id;
	if(sscanf(params, "i", id)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /bizbackdoor [businessid]");

	if(GetPVarInt(playerid, "BizzEnter") == id) {
		new Float:pos[3];
		GetPlayerPos(playerid, pos[0], pos[1], pos[2]);

		BizInfo[id][bbdXi] = pos[0];
		BizInfo[id][bbdYi] = pos[1];
		BizInfo[id][bbdZi] = pos[2];

		DestroyDynamicPickup(BizInfo[id][bbdiIcon]);
		BizInfo[id][bbdiIcon] = CreateDynamicPickup(1318, 1, BizInfo[id][bbdXi], BizInfo[id][bbdYi], BizInfo[id][bbdZi], id, BizInfo[id][IntIn]);

		SaveBizzBackdoor(id);

		new string[128];
		format(string, sizeof(string), "WARNING: Set business ID: %d's inside backdoor to %.2f %.2f %.2f.", id, pos[0], pos[1], pos[2]);
		SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
	} else if(GetPVarInt(playerid, "BizzEnter") == 0) {
		new Float:pos[3];
		GetPlayerPos(playerid, pos[0], pos[1], pos[2]);

		BizInfo[id][bbdXo] = pos[0];
		BizInfo[id][bbdYo] = pos[1];
		BizInfo[id][bbdZo] = pos[2];

		DestroyDynamicPickup(BizInfo[id][bbdoIcon]);
		BizInfo[id][bbdoIcon] = CreateDynamicPickup(1318, 1, BizInfo[id][bbdXo], BizInfo[id][bbdYo], BizInfo[id][bbdZo], 0, BizInfo[id][IntOut]);

		SaveBizzBackdoor(id);

		new string[128];
		format(string, sizeof(string), "WARNING: Set business ID: %d's outside backdoor to %.2f %.2f %.2f.", id, pos[0], pos[1], pos[2]);
		SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
	}
	return 1;
}
//============================================//
COMMAND:bizbackdoorremove(playerid, params[])
{
	if(GetPVarInt(playerid, "Admin") < 3) return nal(playerid);

	new id;
	if(sscanf(params, "i", id)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /bizbackdoorremove [businessid]");

	if(GetPVarInt(playerid, "BizzEnter") == id) {
		BizInfo[id][bbdXi] = 0;
		BizInfo[id][bbdYi] = 0;
		BizInfo[id][bbdZi] = 0;

		DestroyDynamicPickup(BizInfo[id][bbdiIcon]);

		SaveBizzBackdoor(id);

		new string[128];
		format(string, sizeof(string), "WARNING: Removed business ID: %d's inside backdoor.", id);
		SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
	} else if(GetPVarInt(playerid, "BizzEnter") == 0) {
		BizInfo[id][bbdXo] = 0;
		BizInfo[id][bbdYo] = 0;
		BizInfo[id][bbdZo] = 0;

		DestroyDynamicPickup(BizInfo[id][bbdoIcon]);

		SaveBizzBackdoor(id);

		new string[128];
		format(string, sizeof(string), "WARNING: Removed business ID: %d's outside backdoor.", id);
		SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
	}
	return 1;
}
//============================================//
COMMAND:factions(playerid, params[])
{
	if(GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	if(GetPVarInt(playerid, "Delay") > GetCount()) return SendClientMessage(playerid, COLOR_LIGHTRED, "You must wait before performing this command!");
	SetPVarInt(playerid, "Delay", GetCount()+2000);
	new online[MAX_FACTIONS];
	foreach(new i : Player) {
		if(GetPVarInt(i, "PlayerLogged") == 1 && GetPVarInt(i, "Member") > 0) {
			online[GetPVarInt(i, "Member")]++;
		}
	}
	new string[128];
	for(new i=0; i < MAX_FACTIONS; i++) {
		if(FactionInfo[i][fUsed] == 0) { continue; }
		format(string, sizeof(string), "(( There is %d members of the %s online ))", online[i], FactionInfo[i][fName]);
		SendClientMessage(playerid, 0x8080FF96, string);		
	}
	return 1;
}
//============================================//
COMMAND:spawn(playerid, params[])
{
	if(GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	if(CountSpawnedCars(playerid) >= MAX_SPAWNED_CARS) return SendClientMessage(playerid, COLOR_GREY, "You already have the maximum amount of vehicles spawned.");
	new query[112];
	mysql_format(handlesql, query, sizeof(query), "SELECT `Model`, `Donate`, `Value`, `Impounded` FROM `vehicles` WHERE `Owner` = '%e';", PlayerInfo[playerid][pUsername]);
	mysql_tquery(handlesql, query, "vs_OnPlayerSpawnsVehicle", "i", playerid);
	return 1;
}
//============================================//
COMMAND:vehicledespawn(playerid, params[])
{
	if(GetPVarInt(playerid, "Admin") < 1) return nal(playerid);
	new id;
	if(sscanf(params, "i", id)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /vehicledespawn [databaseid]");
	foreach(new i : Vehicle) {
		if(VehicleInfo[i][vID] == id) {
			SaveVehicleData(i);
			DespawnVehicle(i);
			SendClientMessage(playerid, COLOR_WHITE, "Vehicle despawned!");
			return 1;
		}
	}
	SendClientMessage(playerid, COLOR_GREY, "Vehicle with this ID does not exist in the database or is not spawned.");
	return 1;
}
//============================================//
COMMAND:vehiclespawn(playerid, params[])
{
	if(GetPVarInt(playerid, "Admin") < 1) return nal(playerid);
	new id;
	if(sscanf(params, "i", id)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /vehiclespawn [databaseid]");
	new query[100];
	mysql_format(handlesql, query, sizeof(query), "SELECT `ID` FROM `vehicles` WHERE `ID`=%i", id);
	mysql_pquery(handlesql, query, "vs_OnAdminVehicleSpawnSelected", "i", playerid);
	return 1;
}
//============================================//
COMMAND:treataddict(playerid, params[])
{
	if(GetPVarInt(playerid, "Admin") < 1 && GetPVarInt(playerid, "Member") != 2) return SendClientMessage(playerid, COLOR_GREY, "You do not have access to this command!");
	new targetid;
	if(sscanf(params, "i", targetid)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /treataddict [playerid]");
	SetPVarInt(targetid, "Addiction", 0);
	SendClientMessage(targetid, COLOR_WHITE, "You have been treated from your addiction!");
	SendClientMessage(playerid, COLOR_WHITE, "You have treated the player from his addiction.");
	OnPlayerDataSave(targetid);
	return 1;
}
//============================================//
COMMAND:setname(playerid, params[])
{
	if(GetPVarInt(playerid, "Admin") < 6) return SendClientMessage(playerid, COLOR_GREY, "You do not have access to this command!");
	new targetid, name[MAX_PLAYER_NAME];
	if(sscanf(params, "is[25]", targetid, name)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /setname [playerid] [Firstname_Lastname]");
	SetPVarInt(targetid, "GunLic", 0);
	new query[68];
	mysql_format(handlesql, query, sizeof(query), "SELECT NULL FROM accounts WHERE Name='%s'", name);
	mysql_tquery(handlesql, query, "HandleNCAdmin", "iis", playerid, targetid, name);
	return 1;
}
//============================================//
COMMAND:showpms(playerid, params[])
{
	if(GetPVarInt(playerid, "Admin") < 4) return nal(playerid);
	if(GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");

	new option[32], target;
	if(sscanf(params, "s[32]R(-1)", option, target)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /showpms [player/all/off]");
	if(!strcmp(option, "all")) {
		if(GetPVarInt(playerid, "SeePM") != INVALID_MAXPL) {
			SetPVarInt(playerid, "SeePM", INVALID_MAXPL);
			SendClientMessage(playerid, COLOR_GREY, "Player's private messages will no longer appear.");
		}

		if(GetPVarInt(playerid, "ShowPMs") == 0) {
			SetPVarInt(playerid, "ShowPMs", 1);
			SendClientMessage(playerid ,COLOR_GREY, "All private messages will now appear.");
		} else {
			SetPVarInt(playerid, "ShowPMs", 0);
			SendClientMessage(playerid, COLOR_GREY, "All private messages will no longer appear.");
		}
	} else if(!strcmp(option, "player")) {
		if(target == -1) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /showpms [player] [playerid]");
		if(!IsPlayerConnected(target)) return SendClientMessage(playerid, COLOR_GREY, "This player is not connected.");
		
		if(GetPVarInt(playerid, "ShowPMs") == 1) {
			SetPVarInt(playerid, "ShowPMs", 0);
			SendClientMessage(playerid, COLOR_GREY, "All private messages will no longer appear.");
		}
		if(GetPVarInt(playerid, "SeePM") == INVALID_MAXPL) {
			new string[128];
			SetPVarInt(playerid, "SeePM", target);
			format(string, 128, "You will now see %s's private messages.", PlayerInfo[target][pName]);
			SendClientMessage(playerid, COLOR_GREY, string);
		}
	} else if(!strcmp(option, "off")) {
		SetPVarInt(playerid, "ShowPMs", 0);
		SetPVarInt(playerid, "SeePM", INVALID_MAXPL);
		SendClientMessage(playerid, COLOR_GREY, "Private messages will no longer appear.");
	} else { SendClientMessage(playerid, COLOR_GREY, "USAGE: /showpms [player/all/off]"); }
	return 1;
}
//============================================//
COMMAND:resetplayer(playerid, params[])
{
	new targetid, string[128], sendername[MAX_PLAYER_NAME], giveplayer[MAX_PLAYER_NAME], Float:X, Float:Y, Float:Z;
	if(sscanf(params, "u", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /resetplayer [playerid]");
	else
	{
		if(GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_WHITE, "This player is not connected!");
		if(GetPVarInt(playerid, "Admin") >= 1) {
			format(sendername, sizeof(sendername), "%s", PlayerInfo[playerid][pUsername]);
      		format(giveplayer, sizeof(giveplayer), "%s", PlayerInfo[targetid][pUsername]);
      		GiveNameSpace(sendername);
      		GiveNameSpace(giveplayer);
      		if(GetPVarInt(playerid, "Admin") >= 11) sendername = "Hidden";
      		format(string, sizeof(string), "AdmCmd: %s was reset by %s.", giveplayer, sendername);
      		SendAdminMessage(COLOR_LIGHTRED,string);
      		GameTextForPlayer(targetid, "~w~RESET", 5000, 3);
      		new skin = GetPlayerSkin(targetid);
			new pint = GetPlayerInterior(targetid);
			new pvir = GetPlayerVirtualWorld(targetid);
      		GetPlayerPos(targetid, X, Y, Z);
            SetPlayerPos(targetid, X, Y, Z);
            SetPlayerInterior(targetid, pint);
            SetPlayerVirtualWorld(targetid, pvir);
            SetPlayerSkin(targetid, skin);
   			SetPVarInt(targetid, "Mute", 0);
			SetPVarInt(targetid, "Drag", INVALID_MAXPL);
    	    SetPVarInt(targetid, "Control", 0);
            TogglePlayerSpectating(targetid, false);
            TogglePlayerControllableEx(targetid, true);
		}
	}
	return 1;
}
//============================================//
COMMAND:netstats(playerid, params[])
{
	if(GetPVarInt(playerid, "Admin") < 1) return SendClientMessage(playerid, COLOR_GREY, "You don't have access to this command.");
	new targetid, giveplayer[64];
	if(sscanf(params, "u", targetid)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /netstats [playerid]");
	else
	{
		if(GetPVarInt(playerid, "Mute") == 1) return nal(playerid);
		if(GetPVarInt(playerid, "PlayerLogged") == 1) {
	        new stats[400+1];
	        format(giveplayer, sizeof(giveplayer), "{FFA500}%s's netstats", PlayerInfo[targetid][pUsername]);
	        GiveNameSpace(giveplayer);
	        GetPlayerNetworkStats(targetid, stats, sizeof(stats));
	        ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, giveplayer, stats, "Close", "");
	    }
	}
    return 1;
}
//============================================//
COMMAND:houseasell(playerid, params[])
{
	new id;
	if(sscanf(params, "i", id)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /houseasell [houseid]");
	else
	{
	    if(GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if(GetPVarInt(playerid, "Admin") >= 4) {
		    HouseInfo[id][hOwned] = 0;
		    format(HouseInfo[id][hOwner], 128, "None");
		    SCM(playerid, -1, "Property sold.");
		    SaveHouse(id);
		    new query[256];
		    mysql_format(handlesql, query, sizeof(query), "UPDATE accounts SET HouseKey=0 WHERE HouseKey=%d", id);
		   	mysql_tquery(handlesql, query);
		} else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
COMMAND:bizzasell(playerid, params[])
{
	new id;
	if(sscanf(params, "i", id)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /bizzasell [businessid]");
	else
	{
	    if(GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if(GetPVarInt(playerid, "Admin") >= 4) {
		    BizInfo[id][Owned] = 0;
		    format(BizInfo[id][Owner], 128, "None");
		    SCM(playerid, -1, "Business sold.");
		    SaveBiz(id);
		    new query[256];
		    mysql_format(handlesql, query, sizeof(query), "UPDATE accounts SET BizzKey=0 WHERE BizzKey=%d", id);
		   	mysql_tquery(handlesql, query);
		} else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
COMMAND:asellcar(playerid, params[])
{
	new id;
	if(sscanf(params, "i", id)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /asellcar [vehicle-ID]");
	else
	{
	    if(GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if(GetPVarInt(playerid, "Admin") >= 7) {
			if(VehicleInfo[id][vType] != VEHICLE_PERSONAL) { return SendClientMessage(playerid, COLOR_WHITE, "This isn't an owned vehicle!"); }
			new query[128];
		    mysql_format(handlesql, query, sizeof(query), "DELETE FROM `vehicles` WHERE ID=%d", VehicleInfo[id][vID]);
            mysql_tquery(handlesql, query);
		    mysql_format(handlesql, query, sizeof(query), "DELETE FROM `vehiclefurn` WHERE VID=%d", VehicleInfo[id][vID]);
            mysql_tquery(handlesql, query);			
			SCM(playerid, -1, "Vehicle sold.");
		} else SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	}
	return 1;
}
//============================================//
COMMAND:firecreate(playerid, params[])
{
	if(GetPVarInt(playerid, "Admin") < 2) return SendClientMessage(playerid, COLOR_GREY, "You do not have access to this command.");

	new Float:range;
	if(sscanf(params, "f", range)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /firecreate [range]");
	
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	CreateFire(x, y, z, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), range);
	SendClientMessage(playerid, COLOR_WHITE, "Fire created.");
	return 1;
}
//============================================//
ALTCOMMAND:removefurn->deletefurn;
COMMAND:deletefurn(playerid, params[]) 
{
	if(GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	if(GetPVarInt(playerid, "Admin") < 7) return SendClientMessage(playerid, COLOR_WHITE, "You must be at-least a level 7 admin.");
	SetPVarInt(playerid, "SelectMode", SELECTMODE_REMOVE);
	SelectObject(playerid);
	SendClientMessage(playerid, COLOR_BLUE, "[TIP] {FFFFFF}Click on a house or business object to remove it.");
	SendClientMessage(playerid, COLOR_BLUE, "[TIP] {FFFFFF}A confirmation will appear with the house/biz ID and the owner of the property.");
	return 1;
}
//============================================//
ALTCOMMAND:removetag->deletetag;
COMMAND:deletetag(playerid, params[]) 
{
	if(GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	if(GetPVarInt(playerid, "Admin") < 1) return SendClientMessage(playerid, COLOR_WHITE, "You must be at-least a level 1 admin.");
	SetPVarInt(playerid, "SelectMode", SELECTMODE_TAG);
	SelectObject(playerid);
	SendClientMessage(playerid, COLOR_BLUE, "[TIP] {FFFFFF}Click on a spray-tag to remove it.");
	return 1;
}
//============================================//
ALTCOMMAND:removeclosetag->deleteclosetag;
COMMAND:deleteclosetag(playerid, params[]) 
{
	if(GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	if(GetPVarInt(playerid, "Admin") < 1) return SendClientMessage(playerid, COLOR_WHITE, "You must be at-least a level 1 admin.");
	for(new member = 1; member < MAX_FACTIONS; member++) {
		for(new i = 0; i < MAX_FACTION_TAGS; i++) {
			if(IsValidDynamicObject(SprayTags[member][i][_spObject])) {
				new Float:pos[3];
				GetDynamicObjectPos(SprayTags[member][i][_spObject], pos[0], pos[1], pos[2]);
				if(IsPlayerInRangeOfPoint(playerid, 6.0, pos[0], pos[1], pos[2])) {
					SetPVarInt(playerid, "TagDeleteMember", member);
					SetPVarInt(playerid, "TagDeleteIndex", i);
					new string[128];
					format(string, sizeof(string), "Are you sure you want to delete this tag?\n{33FF66}Faction: %s(%d).", FactionInfo[member][fName], member);
					ShowPlayerDialog(playerid, DIALOG_TAG_DELETE, DIALOG_STYLE_MSGBOX, "Delete Tag", string, "Yes", "No");
					return 1;	
				}
			}
		}
	}	
	SendClientMessage(playerid, COLOR_ORANGE, "No nearby spray-tag found!");
	return 1;
}
//============================================//
ALTCOMMAND:removetags->deletetags;
COMMAND:deletetags(playerid, params[]) 
{
	if(GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	if(GetPVarInt(playerid, "Admin") < 1) return SendClientMessage(playerid, COLOR_WHITE, "You must be at-least a level 1 admin.");
	new member;
	if(sscanf(params, "i", member)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /removetags [faction-ID]");
	else
	{
		if(member < 1 || member > (MAX_FACTIONS-1)) { return SendClientMessage(playerid, COLOR_WHITE, "Invalid faction ID."); }
		if(FactionInfo[member][fUsed] == 0) { return SendClientMessage(playerid, COLOR_WHITE, "No faction uses this ID."); }
		SetPVarInt(playerid, "TagDeleteMember", member);
		new string[128];
		format(string, sizeof(string), "Are you sure you want to remove all spray-tags for this faction?\n{33FF66}Faction: %s(%d).", FactionInfo[member][fName], member);
		ShowPlayerDialog(playerid, DIALOG_TAG_DELETEALL, DIALOG_STYLE_MSGBOX, "Delete Tag", string, "Yes", "No");		
	}
	return 1;
}
//============================================//
COMMAND:toggleoutdoorvehiclefurn(playerid, params[])
{
	if(GetPVarInt(playerid, "Admin") < 6) return SendClientMessage(playerid, COLOR_GREY, "You do not have access to this command.");
	if(outdoor_vehicle_furn == 0) { //Enable
		outdoor_vehicle_furn = 1;
		foreach(new vehicleid : Vehicle) { //NOTE: We don't have to load furniture all over again, but since this is rarely called I'd prefer it in-case I want to SQL-modify my vehicle attachments etc. Not like it'll hurt performance it's command-based.
			if(VehicleInfo[vehicleid][vType] == VEHICLE_PERSONAL && VehicleInfo[vehicleid][vID] != 0) {
				new query[128];
				mysql_format(handlesql, query, sizeof(query), "SELECT * FROM vehiclefurn WHERE VID=%d", VehicleInfo[vehicleid][vID]);
				mysql_tquery(handlesql, query, "LoadVehicleFurniture", "i", vehicleid);
			}
			VehicleInfo[vehicleid][vNeonOff] = 0;
		}
		SendClientMessage(playerid, COLOR_WHITE, "All outdoor vehicle objects spawned. Outdoor vehicle furniture enabled.");
	} else { //Disable.
		outdoor_vehicle_furn = 0;
		foreach(new vehicleid : Vehicle) {
			if(VehicleInfo[vehicleid][vType] == VEHICLE_PERSONAL && VehicleInfo[vehicleid][vID] != 0) {
				for(new slot = 0; slot < MAX_VEHICLE_OBJ; slot++) {
					if(IsValidDynamicObject(VehicleInfo[vehicleid][vObject][slot])) {
						DestroyDynamicObject(VehicleInfo[vehicleid][vObject][slot]);
					}
				}
			}
		}
		SendClientMessage(playerid, COLOR_WHITE, "All outdoor vehicle objects removed. Outdoor vehicle furniture disabled.");
	}
	return 1;
}
//============================================//
COMMAND:deletevehiclefurn(playerid, params[])
{
	if(GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
	if(GetPVarInt(playerid, "Admin") < 4) return nal(playerid);	
	SetPVarInt(playerid, "SelectMode", SELECTMODE_VEHICLE_OBJECT_REMOVE);
	SelectObject(playerid);
	SendClientMessage(playerid, COLOR_BLUE, "[TIP] {FFFFFF}Click on a vehicle-object to remove it.");
	return 1;
}
//============================================//
COMMAND:deleteallvehiclefurn(playerid, params[])
{
	if(GetPVarInt(playerid, "Admin") < 4) return nal(playerid);
	new id;
	if(sscanf(params, "i", id)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /deleteallvehiclefurn [vehicle-ID]");
	foreach(new i : Vehicle) {
		if(i == id) {
			if(VehicleInfo[id][vType] == VEHICLE_PERSONAL) {
				SetPVarInt(playerid, "FurnVehicleID", id);
				new string[128];
				format(string, sizeof(string), "Are you sure you want to remove all objects from this vehicle?\n{33FF66}Owner: %s.", VehicleInfo[id][vOwner]);
				ShowPlayerDialog(playerid, DIALOG_VEHICLE_FURN_REMOVEALL_CONFIRM, DIALOG_STYLE_MSGBOX, "Delete Vehicle Objects", string, "Yes", "No");	
			} else SendClientMessage(playerid, COLOR_WHITE, "This isn't an owned vehicle!");
			return 1;
		}
	}
	SendClientMessage(playerid, COLOR_GREY, "Couldn't find vehicle with this ID. Remember this command uses the vehicle-ID not the database-ID.");
	return 1;
}
//============================================//
COMMAND:toggleneonunderglow(playerid, params[])
{
	if(GetPVarInt(playerid, "Admin") < 4) return SendClientMessage(playerid, COLOR_GREY, "You do not have access to this command.");
	if(outdoor_neon_furn == 0) { //Enable
		outdoor_neon_furn = 1;
		foreach(new vehicleid : Vehicle) {
			if(VehicleInfo[vehicleid][vNeonOff] == 1) { continue; }
			for(new slot = 0; slot < MAX_VEHICLE_OBJ; slot++) {
				if(VehicleInfo[vehicleid][voID][slot] != 0 && IsNeonObject(VehicleInfo[vehicleid][voID][slot])) {
					CreateVehicleObject(vehicleid, slot);
				}
			}
		}
		SendClientMessage(playerid, COLOR_WHITE, "All outdoor neon vehicle objects spawned. Outdoor neon vehicle furniture enabled.");
	} else { //Disable.
		outdoor_neon_furn = 0;
		foreach(new vehicleid : Vehicle) {
			if(VehicleInfo[vehicleid][vType] == VEHICLE_PERSONAL && VehicleInfo[vehicleid][vID] != 0) {
				for(new slot = 0; slot < MAX_VEHICLE_OBJ; slot++) {
					if(IsValidDynamicObject(VehicleInfo[vehicleid][vObject][slot]) && IsNeonObject(VehicleInfo[vehicleid][voID][slot])) {
						DestroyDynamicObject(VehicleInfo[vehicleid][vObject][slot]);
					}
				}
			}
		}
		SendClientMessage(playerid, COLOR_WHITE, "All outdoor neon vehicle objects removed. Outdoor neon vehicle furniture disabled.");
	}
	return 1;
}
//============================================//
COMMAND:shipmenttimeleft(playerid, params[])
{
	new id, mins;
	if(sscanf(params, "ii", id, mins)) SendClientMessage(playerid, COLOR_GREY, "USAGE: /shipmenttimeleft [faction-ID] [minutes left.]");
	else
	{
	    if(GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
		if(GetPVarInt(playerid, "Admin") >= 9) {
			if(FactionInfo[id][fShipment] < 1) { return SendClientMessage(playerid, COLOR_WHITE, "This shipment doesn't have any orders in transit."); }
			if(mins < 1 || mins > 240) { return SendClientMessage(playerid, COLOR_WHITE, "You can only set a shipment to arrive within 1 to 240 minutes."); }
			FactionInfo[id][fShipment] = mins;
			new string[148];
			format(string, sizeof(string), "[NOTICE] {FFFFFF}You've set %s's shipment to arrive in %d minutes.", FactionInfo[id][fName], mins);
			SendClientMessage(playerid, COLOR_ORANGE, string);
			format(string, sizeof(string), "[NOTICE] {FFFFFF}%s has set your factions shipment to arrive in %d minutes.", AdminName(playerid), mins);
			SendFactionMessage(id, COLOR_ORANGE, string);
			format(string, sizeof(string), "AdmWarn: %s(%d) has set %s's shipment to arrive in %d minutes.", AdminName(playerid), playerid, FactionInfo[id][fName], mins);
			SendAdminMessage(COLOR_YELLOW, string);			
			format(string, sizeof(string), "[SHIPMENT] $s($s) has set %s shipment to arrive in %d minutes.", AdminName(playerid), PlayerInfo[playerid][pUsername], FactionInfo[id][fName], mins);
			ItemLog(string);
		} else { SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!"); }
	}
	return 1;
}
//============================================// 
ALTCOMMAND:tognicks->tognametags;
COMMAND:tognametags(playerid, params[])
{
	if(GetPVarInt(playerid, "Delay") > GetCount()) return SendClientMessage(playerid, COLOR_LIGHTRED, "You must wait before performing this command!");
	SetPVarInt(playerid, "Delay", GetCount()+1000);
	switch(PlayerInfo[playerid][pNoName]) {
		case 0: {
			foreach(new i : Player) { 
				ShowPlayerNameTagForPlayer(playerid, i, 0); 
			}
			PlayerInfo[playerid][pNoName] = 1;
			SendClientMessage(playerid, COLOR_WHITE, "Name-tags disabled!");
			return 1;
		}
		case 1: {
			new admin = GetPVarInt(playerid, "Admin");
			foreach(new i : Player) { 
				if(GetPVarInt(playerid, "MaskUse") < 1 || admin > 0) {
					ShowPlayerNameTagForPlayer(playerid, i, 1); 
				}
			}	
			PlayerInfo[playerid][pNoName] = 0;
			SendClientMessage(playerid, COLOR_WHITE, "Name-tags enabled!");
			return 1;			
		}
	}
	return 1;
}
//============================================//
ALTCOMMAND:destroycp->removecp;
COMMAND:removecp(playerid, params[])
{
	if(GetPVarInt(playerid, "Delay") > GetCount()) return SendClientMessage(playerid, COLOR_LIGHTRED, "You must wait before performing this command!");
	SetPVarInt(playerid, "Delay", GetCount()+1000);
	DisablePlayerCheckpoint(playerid);
	SendClientMessage(playerid, COLOR_WHITE, "Checkpoint disabled!");
	return 1;
}
//============================================//