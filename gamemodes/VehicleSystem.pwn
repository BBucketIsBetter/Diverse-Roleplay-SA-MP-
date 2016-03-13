/* === General Information ===

	1. Use the Iterator Vehicles in combination with foreach to loop through all spawned vehicles.
	2. Use VehicleInfo to access data of spawned vehicles.
	3. Differentiate VehicleID (SA:MP ID of vehicle in the list of all spawned vehicles) and DatabaseID (The automatically assigned ID used
	   to identify a vehicle in the set of all available vehicles - vID in enumerator vInfo)

*/

/* === Commands === */

COMMAND:v(playerid, params[]) {
    if(GetPVarInt(playerid, "PlayerLogged") == 0) return SendClientMessage(playerid, COLOR_WHITE, "You must be logged in to use this.");
    new type[30],
	    user,
	    price;

	if(sscanf(params, "s[30]I(-1)I(-1)", type, user, price))
	{
		SendClientMessage(playerid, -1, "/v [usage]");
		SendClientMessage(playerid, COLOR_GREY, "Spawn | Stats | Despawn | Park | Sell | Delete");
		SendClientMessage(playerid, COLOR_GREY, "Sellto | Radio | Find | Lock | Corpse | Lights");
		SendClientMessage(playerid, COLOR_GREY, "Breakin | Trunk | Bomb | Paint | Color | Glovebox");
		SendClientMessage(playerid, COLOR_GREY, "Putmats | Takemats | Crate | Release");
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "--------------Vehicle Attachments----------------");
		SendClientMessage(playerid, COLOR_GREY, "Plant | Edit | Select | Removeall | Rights | Neon");
		SendClientMessage(playerid, COLOR_BLUE, "[TIP] {FFFFFF}You can furnish vehicle interiors. (Only some vehicles have interiors.)");
		return 1;
	}
	
	if(strcmp(type, "spawn", true) == 0) {
        if(CountSpawnedCars(playerid) >= MAX_SPAWNED_CARS) return SendClientMessage(playerid, COLOR_GREY, "You already have the maximum amount of vehicles spawned.");
		new query[112];
		mysql_format(handlesql, query, sizeof(query), "SELECT `Model`, `Donate`, `Value`, `Impounded` FROM `vehicles` WHERE `Owner` = '%e';", PlayerInfo[playerid][pUsername]);
		mysql_tquery(handlesql, query, "vs_OnPlayerSpawnsVehicle", "i", playerid);
	} else if(strcmp(type, "stats", true) == 0) {
		if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_GREY, "You have to be in your vehicle to view it's statistics.");
        new vehicleID = GetPlayerVehicleID(playerid);
		if(!PlayerOwnsVehicle(playerid, vehicleID)) return SendClientMessage(playerid, COLOR_GREY, "You don't own this vehicle.");
        new msg[75];
        SendClientMessage(playerid, -1, "_____________________________________________________");
        format(msg, sizeof(msg), "                               {3366FF}%s", VehicleName[GetVehicleModel(vehicleID) - 400]);
        SendClientMessage(playerid, -1, msg);
        if(!IsNotAEngineCar(vehicleID))
        {
            format(msg, sizeof(msg), "Mileage: %d.%d | Fuel: %d/100", VehicleInfo[vehicleID][vMileage][1], VehicleInfo[vehicleID][vMileage][2], VehicleInfo[vehicleID][vFuel]);
            SendClientMessage(playerid, -1, msg);
            format(msg, sizeof(msg), "Insurance: %d/3 | Lock-Lvl: %d/3 | Alarm-Lvl: %d/3 | Plate: %s", VehicleInfo[vehicleID][vInsurance], VehicleInfo[vehicleID][vLockLvl], VehicleInfo[vehicleID][vAlarmLvl], VehicleInfo[vehicleID][vPlate]);
            SendClientMessage(playerid, -1, msg);
        }
        format(msg, sizeof(msg), "Locked: %d | Value: $%d | ColorOne: %d | ColorTwo: %d | PaintJob: %d", VehicleInfo[vehicleID][vLock], VehicleInfo[vehicleID][vValue], VehicleInfo[vehicleID][vColorOne], VehicleInfo[vehicleID][vColorTwo], VehicleInfo[vehicleID][vPaintJob]);
        SendClientMessage(playerid, -1, msg);
		SendClientMessage(playerid, -1, "_____________________________________________________");
	} else if(strcmp(type, "lock", true) == 0) {
		if(!NearestAccessCar(playerid, 1, VEHICLE_LOCK_RANGE)) return SendClientMessage(playerid, COLOR_RED, "You aren't near any vehicles you own.");
	    new vehicleID = GetPlayerVehicleID(playerid), incar = 0;
		if(vehicleID == 0) { 
			vehicleID = NearestAccessCar(playerid, 2, VEHICLE_LOCK_RANGE); 
		} else incar = 1;
		if(vehicleID == INVALID_VEHICLE_ID) return SendClientMessage(playerid, COLOR_GREY, "You are not around your vehicle!");
		if(VehicleInfo[vehicleID][vType] != VEHICLE_PERSONAL) return SendClientMessage(playerid, COLOR_GREY, "This is not a personal vehicle.");
        new Float:pos[3];
        GetVehiclePos(vehicleID, pos[0], pos[1], pos[2]);
        if(incar == 1 || IsPlayerInRangeOfPoint(playerid, VEHICLE_LOCK_RANGE, pos[0], pos[1], pos[2])) {
	    	switch(VehicleInfo[vehicleID][vLock]) {
    			case 0: {
			    	foreach(new i : Player) {
				    	SetVehicleParamsForPlayer(vehicleID, i, 0, 1);
	       				if(GetPlayerVehicleID(i) == vehicleID) {
           					if(VehicleInfo[vehicleID][vModel] == 481 || VehicleInfo[vehicleID][vModel] == 509 || VehicleInfo[vehicleID][vModel] == 510) {
               					RemovePlayerFromVehicle(i);
                   				SendClientMessage(i, COLOR_LIGHTRED, "WARNING: You can't ride a bicycle if it's locked!");
		                    }
               			}
		       		}

           			VehicleInfo[vehicleID][vLock] = 1;
		            PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
		            GameTextForPlayer(playerid, "~w~Vehicle~n~~r~Locked", 4000, 3);
	        	}
		        case 1: {
			    	foreach(new i : Player) {
				    	SetVehicleParamsForPlayer(vehicleID, i, 0, 0);
			    	}

					VehicleInfo[vehicleID][vLock] = 0;
					PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
      				GameTextForPlayer(playerid, "~w~Vehicle~n~~g~Unlocked", 4000, 3);
		        }
	    	}
		} else {
			SendClientMessage(playerid, COLOR_GREY, "You are not around your vehicle.");
		}
	} else if(strcmp(type, "park", true) == 0) {
		if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_GREY, "You have to be in your vehicle in order to park it.");
	    new vehicleID = GetPlayerVehicleID(playerid);
		if(!PlayerOwnsVehicle(playerid, vehicleID)) return SendClientMessage(playerid, COLOR_GREY, "You don't own this vehicle.");
		if(GetPlayerInterior(playerid) != 0 && GetPVarInt(playerid, "GarageEnter") == 0) return SendClientMessage(playerid, COLOR_GREY, "You cannot park your vehicle inside an interior.");
		
		new msg[160], parkingPrice = 100;
		if(GetPVarInt(playerid, "GarageEnter") != 0) parkingPrice = 0;

		if(GetPVarInt(playerid, "MonthDon") != 0) {
		    parkingPrice = 0;
		}

		if(parkingPrice != 0 && GetPlayerMoneyEx(playerid) < parkingPrice) {
		    format(msg, sizeof(msg), "You do not have enough money to park your vehicle ($%i).", parkingPrice);
			return SendClientMessage(playerid, COLOR_GREY, msg);
		}

		GetVehiclePos(vehicleID, VehicleInfo[vehicleID][vX], VehicleInfo[vehicleID][vY], VehicleInfo[vehicleID][vZ]);
		GetVehicleZAngle(vehicleID, VehicleInfo[vehicleID][vAngle]);
		VehicleInfo[vehicleID][vVirtualWorld] = GetVehicleVirtualWorld(vehicleID);
		VehicleInfo[vehicleID][vInterior] = GetPlayerInterior(playerid);
		GivePlayerMoneyEx(playerid, -parkingPrice);
		format(msg, sizeof(msg), "Vehicle parking spot updated for $%i, the vehicle will spawn here from now on.", parkingPrice);
		SendClientMessage(playerid, -1, msg);
		mysql_format(handlesql, msg, sizeof(msg), "UPDATE `vehicles` SET `X` = %f, `Y` = %f, `Z` = %f, `Angle` = %f, `VirtualWorld` = %i, `Interior` = %i WHERE `ID` = %i;", VehicleInfo[vehicleID][vX], VehicleInfo[vehicleID][vY], VehicleInfo[vehicleID][vZ], VehicleInfo[vehicleID][vAngle], VehicleInfo[vehicleID][vVirtualWorld], VehicleInfo[vehicleID][vInterior], VehicleInfo[vehicleID][vID]);
		mysql_tquery(handlesql, msg);
	} else if(strcmp(type, "despawn", true) == 0) {
		new carcount = CountSpawnedCars(playerid);
		if(carcount < 1) return SendClientMessage(playerid, COLOR_GREY, "You don't have any vehicles spawned.");
		if(carcount > 1) {
			new count = 0, skip = 0, str[128];
			foreach(new v : Vehicle) {
				if(count >= carcount) {
					scm(playerid, COLOR_GREY, "You aren't close enough to any of your vehicles parking spot to despawn them.");
					return 1;
				}
				if(PlayerOwnsVehicle(playerid, v)) {
					count++;
					if(IsPlayerInRangeOfPoint(playerid, VEHICLE_DESPAWN_RANGE, VehicleInfo[v][vX], VehicleInfo[v][vY], VehicleInfo[v][vZ])) {
						if(VehicleInfo[v][vCorp] > 0 && CorpInfo[VehicleInfo[v][vCorp]][cUsed] == 1) {
							format(str, 128, "You can't despawn your %s with a corpse inside (/v corpse).", VehicleName[GetVehicleModel(v)-400]);
							SendClientMessage(playerid, COLOR_GREY, str);
							continue;
						}				
						foreach(new i : Player) {
							if(IsPlayerInVehicle(i, v)) {
								format(str, 128, "Your %s is still occupied!", VehicleName[GetVehicleModel(v)-400]);
								SendClientMessage(playerid, COLOR_GREY, str);
								skip++;
							}
						}
						
						foreach(new i : Vehicle) {
							if(GetVehicleTrailer(i) == v) {
								format(str, 128, "Your %s is currently being towed by a Tow Truck.", VehicleName[GetVehicleModel(v)-400]);
								SendClientMessage(playerid, COLOR_GREY, str);
								skip++;
							}
						}
						if(skip > 0) continue;
						
						for(new i = 1; i < 6; i++) {
							if(VehicleInfo[v][cObject][i] > 0) {
								if(IsValidDynamicObject(VehicleInfo[v][cObject][i])) {
									DestroyDynamicObject(VehicleInfo[v][cObject][i]);
									VehicleInfo[v][cObject][i] = 0;
								}
							}
						}
						format(str, 128, "~w~%s ~r~Despawned", VehicleName[GetVehicleModel(v)-400]);
						GameTextForPlayer(playerid, str, 5000, 1);
						SaveVehicleData(v);
						DespawnVehicle(v);
						return 1;
					}
				}
			}
		} else {
			new vehicleID = IsPlayerVehicleSpawned(playerid);
			if(vehicleID == -1) return SendClientMessage(playerid, COLOR_GREY, "You do not have a vehicle spawned.");
			if(VehicleInfo[vehicleID][vCorp] > 0 && CorpInfo[VehicleInfo[vehicleID][vCorp]][cUsed] == 1) return SendClientMessage(playerid, COLOR_GREY, "You can't despawn a vehicle with a corpse inside (/v corpse).");
			if(IsPlayerInRangeOfPoint(playerid, VEHICLE_DESPAWN_RANGE, VehicleInfo[vehicleID][vX], VehicleInfo[vehicleID][vY], VehicleInfo[vehicleID][vZ])) {
				foreach(new i : Player) {
					if(IsPlayerInVehicle(i, vehicleID)) {
						return SendClientMessage(playerid, COLOR_GREY, "Your vehicle is still occupied!");
					}
				}

				foreach(new i : Vehicle) {
					if(GetVehicleTrailer(i) == vehicleID) {
						return SendClientMessage(playerid, COLOR_GREY, "Your vehicle is currently being towed by a Tow Truck.");
					}
				}

				for(new i = 1; i < 6; i++) {
					if(VehicleInfo[vehicleID][cObject][i] > 0) {
						if(IsValidDynamicObject(VehicleInfo[vehicleID][cObject][i])) {
							DestroyDynamicObject(VehicleInfo[vehicleID][cObject][i]);
							VehicleInfo[vehicleID][cObject][i] = 0;
						}
					}
				}
				GameTextForPlayer(playerid, "~w~Vehicle ~r~Despawned", 5000, 1);
				SaveVehicleData(vehicleID);
				DespawnVehicle(vehicleID);
			} else {
				SendClientMessage(playerid, COLOR_GREY, "You are not close enough to your vehicle's parking spot.");
			}
		}
	} else if(strcmp(type, "sell", true) == 0) {
		if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_GREY, "You have to be in your vehicle in order to sell it.");
	    new vehicleID = GetPlayerVehicleID(playerid);
		if(!PlayerOwnsVehicle(playerid, vehicleID)) return SendClientMessage(playerid, COLOR_GREY, "You don't own this vehicle.");
        if(VehicleInfo[vehicleID][vDonate] != 0) return SendClientMessage(playerid, COLOR_GREY, "You cannot sell a donor vehicle.");
   		new msg[70];
		format(msg, sizeof(msg), "Would you like to sell your vehicle for {ffffff}$%d{a9c4e4}?", VehicleInfo[vehicleID][vValue]/3);
	    ShowPlayerDialog(playerid, DIALOG_VEHICLE_SELL, DIALOG_STYLE_MSGBOX, "Sell Vehicle", msg, "Sell", "Cancel");
	} else if(strcmp(type, "delete", true) == 0) {
		if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_GREY, "You have to be in your vehicle in order to delete it.");
	    new vehicleID = GetPlayerVehicleID(playerid);
		if(!PlayerOwnsVehicle(playerid, vehicleID)) return SendClientMessage(playerid, COLOR_GREY, "You don't own this vehicle.");
        if(VehicleInfo[vehicleID][vDonate] == 0) return SendClientMessage(playerid, COLOR_GREY, "You can only delete donor vehicles, use (/v sell) instead.");
	    ShowPlayerDialog(playerid, 557, DIALOG_STYLE_MSGBOX, "Delete Vehicle", "Are you sure you want to delete your vehicle?\nThis cannot be undone.", "Confirm", "Cancel");
	} else if(strcmp(type, "radio", true) == 0) {
		new vehicleID = GetPlayerVehicleID(playerid);
		if(vehicleID == 0 && IsValidCar(PlayerInfo[playerid][pInVehicle])) { vehicleID = PlayerInfo[playerid][pInVehicle]; }
		if(vehicleID == -1 || vehicleID == 0) return SendClientMessage(playerid, COLOR_GREY, "You have to be in a vehicle with a radio installed.");	
        if(IsNotAEngineCar(vehicleID) && IsEnterableVehicle(vehicleID) == -1) return SendClientMessage(playerid, COLOR_GREY, "This vehicle does not have a radio installed.");
        if(GetPlayerVehicleID(playerid) != vehicleID && GetPlayerState(playerid) == PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOR_GREY, "You have to be in the driver seat of your vehicle in order to set the radio station.");
        ShowPlayerDialog(playerid, DIALOG_RADIO, DIALOG_STYLE_LIST, "Vehicle Radio", "Radio Stations\nDirect URL\nTurn Off", "Select", "Exit");
	} else if(strcmp(type, "find", true) == 0) {
		if(CountSpawnedCars(playerid) < 1) return SendClientMessage(playerid, COLOR_GREY, "You do not have any vehicles spawned.");

		if(GetPlayerMoneyEx(playerid) >= 200) {
		    new msg[75],
				skip = 0,
	   			Float:pos[3];
			foreach(new i : Vehicle) {
				if(PlayerOwnsVehicle(playerid, i)) {
					foreach(new p : Player) {
						if(GetPlayerVehicleID(p) == i) {
							format(msg, sizeof(msg), "Someone is currently occupying your %s, therefore it cannot be tracked at this time.", VehicleName[GetVehicleModel(i)-400]);
							SendClientMessage(playerid, COLOR_GREY, msg);
							skip = 1;
						}
					}
					if(skip == 1) {
						skip = 0;
						continue;
					}
					GetVehiclePos(i, pos[0], pos[1], pos[2]);
					format(msg, sizeof(msg), "You have a %s currently in the area '%s'.", VehicleName[GetVehicleModel(i)-400], GetZone(pos[0], pos[1], pos[2]));
					SendClientMessage(playerid, COLOR_WHITE, msg);
				}
			}
			GivePlayerMoneyEx(playerid, -200);
			GameTextForPlayer(playerid, "~r~-$200", 5000, 1);
			PlayerPlaySound(playerid, 1054, 0.0, 0.0, 0.0);
		} else {
			SendClientMessage(playerid, COLOR_GREY, "You do not have enough money ($200).");
		}
	} else if(strcmp(type, "breakin", true) == 0) {
	    if(!CheckInvItem(playerid, 406)) return SendClientMessage(playerid, COLOR_GREY, "You need a toolkit to use this.");
	    new vehicleID = PlayerToCar(playerid, 2, 4.0), Float:x, Float:y, Float:z, string[128];
	    if(VehicleInfo[vehicleID][vID] == 0) return SendClientMessage(playerid, COLOR_GREY, "You cannot use your toolkit on this vehicle.");
	    if(IsNotAEngineCar(vehicleID)) return SendClientMessage(playerid, COLOR_GREY, "This vehicle does not have an engine.");
	    if(IsHelmetCar(vehicleID)) return SendClientMessage(playerid, COLOR_GREY, "This vehicle doesn't have a door.");
	    if(VehicleInfo[vehicleID][vLock] == 0) return SendClientMessage(playerid, COLOR_GREY, "This vehicle is not locked.");
	    new msg[75],
	        time;

	    format(msg, sizeof(msg), "You are now attempting to break into the %s!", VehicleName[VehicleInfo[vehicleID][vModel] - 400]);
       	SendClientMessage(playerid, COLOR_WHITE, msg);
        SetPVarInt(playerid, "RamVehicle", 1);
       	SetPVarInt(playerid, "RamVehID", vehicleID);
       	switch(VehicleInfo[vehicleID][vLockLvl]) {
       	    case 0: time = 30;
       	    case 1: time = 60;
       	    case 2: time = 120;
       	    case 3: time = 300;
       	}

        if(VehicleInfo[vehicleID][vAlarmLvl] >= 3)
		{
            VehicleInfo[vehicleID][vAlarm]=1;
            GetPlayerPos(playerid, x, y, z);
        	new found;
			if(x > 46.7115 && y > -2755.979 && x < 2931.147 && y < -548.8602)
			{
			    SendFactionMessage(1, COLOR_BLUE, "HQ: All Units - HQ: House Burglary.");
				format(string, sizeof(string), "HQ: Location: %s", GetPlayerArea(playerid));
				SendFactionMessage(1, COLOR_BLUE, string);
				PlaySoundInArea(3401, x, y, z, 20.0);
				found++;
			}
			if(found != 0) {
			SendBurg(vehicleID); }
        }

       	ProgressBar(playerid, "Unlocking Car...", time, 1);
		AddPlayerTag(playerid, "(breaking into car)");
       	SetPVarInt(playerid, "RamVehTime", time);
  	} else if(strcmp(type, "corpse", true) == 0) {
	    new vehicleID = PlayerToCar(playerid,2,4.0);
        if(vehicleID == INVALID_VEHICLE_ID) return SendClientMessage(playerid, COLOR_GREY, "You do not have a vehicle spawned.");
		if(!IsTrunkCar(GetVehicleModel(vehicleID))) return SendClientMessage(playerid, COLOR_GREY, "This vehicle doesn't have a suitable trunk!");
		if(VehicleInfo[vehicleID][vTrunk] == 0) return SendClientMessage(playerid, COLOR_GREY, "The vehicles trunk must be opened.");
        new Float:pos[3];
		GetVehiclePos(vehicleID, pos[0], pos[1], pos[2]);
		if(IsPlayerInRangeOfPoint(playerid, 10.0, pos[0], pos[1], pos[2])) {
  			new id = -1;
		    for(new i = 0; i < sizeof(CorpInfo); i++) {
               	if(CorpInfo[i][cUsed] == 1) {
                   	if(CorpInfo[i][cVeh] == vehicleID) {
                       	id = i;
						break;
                    }
                }
            }

            if(id == -1) return SendClientMessage(playerid, COLOR_GREY, "There is no corpse in your vehicle.");
			GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	        CorpInfo[id][cText]=CreateDynamic3DTextLabel("| Corpse |\npress '~k~~CONVERSATION_YES~' to examine!", 0x33CCFFFF, pos[0]+0.75, pos[1], pos[2]-0.4, 50.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, 50.0);
		    CorpInfo[id][cX] = pos[0];
	        CorpInfo[id][cY] = pos[1];
	        CorpInfo[id][cZ] = pos[2];
	        CorpInfo[id][cVeh] = 0;
			CorpInfo[id][cBody]=CreateActor(CorpInfo[id][cSkin], pos[0]+0.75, pos[1], pos[2], 0.0);
			SetActorInvulnerable(CorpInfo[id][cBody], true);
			ApplyActorAnimation(CorpInfo[id][cBody], "PED", "KO_shot_stom", 4.0, 0, 0, 0, 1, 0);
	        VehicleInfo[vehicleID][vCorp]=0;
	        SendClientMessage(playerid, COLOR_WHITE, "Corpse unloaded!");
		} else {
    		SendClientMessage(playerid, COLOR_GREY, "You are not around your vehicle.");
  		}
	} else if(strcmp(type, "sellto", true) == 0) {
	    if(user == -1 || price == -1) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /v sellto [PlayerID] [Price]");
	    if(GetPVarInt(playerid, "ConnectTime") < 8) return SendClientMessage(playerid, COLOR_GREY, "You need at least 8 Time-In-LS to perform this action.");
	    if(!Iter_Contains(Player, user)) return SendClientMessage(playerid, COLOR_GREY, "This player is not connected or points to a NPC.");
	    if(playerid == user) return SendClientMessage(playerid, COLOR_GREY, "You cannot sell a vehicle to yourself.");
	    if(GetPVarInt(user, "ConnectTime") < 8) return SendClientMessage(playerid, COLOR_GREY, "The player you are trying to sell your vehicle to has less than 8 Time-In-LS.");
		if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_GREY, "You have to be in your vehicle in order to sell it.");
	    new vehicleID = GetPlayerVehicleID(playerid);
		if(!PlayerOwnsVehicle(playerid, vehicleID)) return SendClientMessage(playerid, COLOR_GREY, "You don't own this vehicle.");
        if(VehicleInfo[vehicleID][vDonate] != 0) return SendClientMessage(playerid, COLOR_GREY, "You cannot sell a donor vehicle.");
        if(VehicleInfo[vehicleID][vModel] == 522) return SendClientMessage(playerid, COLOR_GREY, "You cannot sell a NRG-500.");
		if(price < 1 || price > VehicleInfo[vehicleID][vValue] + 20000) {
			new msg[100];
			format(msg, sizeof(msg),"You can only sell this vehicle for a price within the following range: $1 - $%d.", VehicleInfo[vehicleID][vValue] + 20000);
			return SendClientMessage(playerid, COLOR_GREY, msg);
		}

		if(PlayerToPlayer(playerid, user, VEHICLE_SELL_RANGE)) {
		    new query[75];
		    mysql_format(handlesql, query, sizeof(query), "SELECT NULL FROM `vehicles` WHERE `Owner` = '%e';", PlayerInfo[user][pUsername]);
		    mysql_tquery(handlesql, query, "vs_PlayerSellsVehicleToPlayer", "iii", playerid, user, price);
		} else {
			SendClientMessage(playerid, COLOR_GREY, "You are not close enough to this player.");
   		}
	} else if(strcmp(type, "color", true) == 0) {
	    if(user == -1 || price == -1) {
		    SendClientMessage(playerid, COLOR_GREEN, "USAGE: /v color [color1] [color2]");
		    SendClientMessage(playerid, COLOR_GREY, "NOTE: colorids 0-1 are free.");
		    return true;
		}
		else {
		if(GetPVarInt(playerid, "ColorDelay") > GetCount()) return scm(playerid, -1, "You can't use this command for a moment!");
		if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_GREY, "You have to be in your vehicle in order to color it.");
	    new vehicleID = GetPlayerVehicleID(playerid), string[128];
		if(!PlayerOwnsVehicle(playerid, vehicleID)) return SendClientMessage(playerid, COLOR_GREY, "You don't own this vehicle.");
   	    if(user < 0 || user > 500) return SendClientMessage(playerid, COLOR_GREY, "Cannot go under 0 or above 500.");
   	    if(price < 0 || price > 500) return SendClientMessage(playerid, COLOR_GREY, "Cannot go under 0 or above 500.");
   	    new cost = 0;
   	    if(user >= 2) cost += 250;
   	    if(price >= 2) cost += 250;
   	    if(GetPlayerMoneyEx(playerid) >= cost)
   	    {
   	        format(string, sizeof(string),"~r~-$%d", cost);
          	GameTextForPlayer(playerid, string, 5000, 1);
          	format(string, sizeof(string),"%s's color has been changed for $%d!", VehicleName[GetVehicleModel(vehicleID)-400], cost);
          	scm(playerid, -1, string);
            GivePlayerMoneyEx(playerid, -cost);
            ChangeVehicleColor(vehicleID, user, price);
            VehicleInfo[vehicleID][vColorOne]=user;
            VehicleInfo[vehicleID][vColorTwo]=price;
            SaveVehicleData(vehicleID, 0);
            SetPVarInt(playerid, "ColorDelay" , GetCount()+5000);
   	    }
   	    else SendClientMessage(playerid, COLOR_LIGHTRED, "Insufficient funds!"); }
    } else if(strcmp(type, "lights", true) == 0) {
        if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOR_GREY, "You have to be inside a vehicle's driver seat to toggle the lights of a vehicle.");
        if(IsNotAEngineCar(GetPlayerVehicleID(playerid))) return SendClientMessage(playerid, COLOR_GREY, "This vehicle does not have lights.");
		CarLights(GetPlayerVehicleID(playerid));
        PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
    } else if(strcmp(type, "trunk", true) == 0) {
        new vehicleID = PlayerToCar(playerid,2,4.0), string[128], sendername[MAX_PLAYER_NAME];
        if(vehicleID == INVALID_VEHICLE_ID) return SendClientMessage(playerid, COLOR_GREY, "You aren't near any vehicles.");
		if(!PlayerOwnsVehicle(playerid, vehicleID)) return SendClientMessage(playerid, COLOR_GREY, "You don't own this vehicle.");
        if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return SendClientMessage(playerid, COLOR_GREY, "You have to be onfoot to use this!");
        if(IsNotAEngineCar(GetPlayerVehicleID(playerid))) return SendClientMessage(playerid, COLOR_GREY, "This vehicle does not have a trunk.");
        new Float:pos[3];
		GetVehiclePos(vehicleID, pos[0], pos[1], pos[2]);
		if(IsPlayerInRangeOfPoint(playerid, 5.0, pos[0], pos[1], pos[2])) {
        format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
		GiveNameSpace(sendername);
        switch(VehicleInfo[vehicleID][vTrunk])
		{
		    case 0: {
		        VehicleInfo[vehicleID][vTrunk]=1;
		        format(string, sizeof(string), "* %s opens the %s's trunk.", sendername, PrintVehName(vehicleID));
				scm(playerid, COLOR_BLUE, "[TIP] {FFFFFF}Don't forget to lock your trunk or it may get robbed! (/v trunk)");
		    }
		    case 1: {
		        VehicleInfo[vehicleID][vTrunk]=0;
		        format(string, sizeof(string), "* %s closes the %s's trunk.", sendername, PrintVehName(vehicleID));
		    }
		}
		ProxDetector(30.0, playerid, string, COLOR_PURPLE);
        VehicleTrunk(vehicleID, VehicleInfo[vehicleID][vTrunk]);
        } else {
    		SendClientMessage(playerid, COLOR_GREY, "You are not around your vehicle."); }
	} else if(strcmp(type, "bomb", true) == 0) {
        if (!CheckInvItem(playerid, 1004)) return scm(playerid, -1, "You don`t have a bomb!");
        if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return SendClientMessage(playerid, COLOR_GREY, "You must be on-foot.");
        new carid = PlayerToCar(playerid, 2, 4.0), string[128];
        if(VehicleInfo[carid][vType] != VEHICLE_PERSONAL) return SendClientMessage(playerid,COLOR_GREY,"This is not a personal vehicle.");
	    if(IsNotAEngineCar(carid)) return SendClientMessage(playerid, COLOR_GREY, "This vehicle dosent have an engine.");
	    if(IsHelmetCar(carid)) return SendClientMessage(playerid, COLOR_GREY, "This vehicle is a bike not a car.");
	    if(VehicleInfo[carid][vEngine] != 0) return SendClientMessage(playerid,COLOR_GREY,"This vehicles engine is not turned off.");
	    if(VehicleInfo[carid][vBomb] != 0) return SendClientMessage(playerid,COLOR_GREY,"This vehicle already contains a bomb charge.");
        PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
		ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0);
        format(string, sizeof(string),"Bomb wired to the %s`s ignition!", VehicleName[GetVehicleModel(carid)-400]);
        SendClientMessage(playerid, COLOR_WHITE, string);
        GameTextForPlayer(playerid, "~w~Bomb~n~~b~Wired", 4000, 3);
        VehicleInfo[carid][vBomb]=1;
        RemoveInvItem(playerid, 1004);
	} else if(strcmp(type, "glovebox", true) == 0) {
        if (!IsPlayerInAnyVehicle(playerid)) return scm(playerid, -1, "You aren't even in a vehicle!");
		new key = GetPlayerVehicleID(playerid);
		if(!IsHelmetCar(key) && VehicleInfo[key][vType] == VEHICLE_PERSONAL) {
			PrintVehGB(playerid, key);
		}
	} else if(strcmp(type, "paint", true) == 0) {
	    if(user == -1) {
		    SendClientMessage(playerid, COLOR_GREEN, "USAGE: /v [paint] [paintjob-ID](1-3)");
		    SendClientMessage(playerid, COLOR_GREY, "NOTE: 0 to remove.");
		    return true;
		}
		else {
			if(GetPVarInt(playerid, "ColorDelay") > GetCount()) return scm(playerid, -1, "You can't use this command for a moment!");
			if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_GREY, "You have to be in your vehicle in order to color it.");
			new vehicleID = GetPlayerVehicleID(playerid), string[128];
			if(!PlayerOwnsVehicle(playerid, vehicleID)) return SendClientMessage(playerid, COLOR_GREY, "You don't own this vehicle.");
			if(IsNotAEngineCar(vehicleID)) return SendClientMessage(playerid, COLOR_GREY, "Paintjobs can only be applied to engine-cars.");
			if(user < 0  || user > 3) return SendClientMessage(playerid, COLOR_GREY, "Cannot go under 0 or above 3.");
			if(user == 0) {
				ChangeVehiclePaintjob(vehicleID, 3);
				VehicleInfo[vehicleID][vPaintJob]=3;
				SaveVehicleData(vehicleID, 0);
				format(string, sizeof(string),"%s's paintjob has been reset!", VehicleName[GetVehicleModel(vehicleID)-400]);
				return scm(playerid, -1, string);
			}
			format(string, sizeof(string),"%s's paintjob has been changed!", VehicleName[GetVehicleModel(vehicleID)-400]);
			scm(playerid, -1, string);
			VehicleInfo[vehicleID][vColorOne]=1;
            VehicleInfo[vehicleID][vColorTwo]=1;
			ChangeVehicleColor(vehicleID, 1, 1);
			ChangeVehiclePaintjob(vehicleID, user-1);
			VehicleInfo[vehicleID][vPaintJob]=user-1;
			SaveVehicleData(vehicleID, 0);
			SetPVarInt(playerid, "ColorDelay" , GetCount()+5000);
		}
    } else if(strcmp(type, "putmats", true) == 0) {
		new vehicleID = PlayerToCar(playerid, 2, 4.0);
		if(vehicleID == INVALID_VEHICLE_ID) return scm(playerid, COLOR_GREY, "No nearby vehicle found.");
		if(!IsValidTCar(vehicleID)) return SendClientMessage(playerid, COLOR_GREY, "You can only store materials in a vehicle with an opened trunk!");
		if(user == (-1)) return scm(playerid, COLOR_GREEN, "USAGE: /v putmats {FFFFFF} [amount]");
		if(user <= 0) return scm(playerid, COLOR_GREEN, "USAGE: /v putmats {FFFFFF} [amount]");
		if(user >= 99999999) return scm(playerid, COLOR_GREEN, "USAGE: /v putmats {FFFFFF} [amount]");
		if(user > PlayerInfo[playerid][pMaterials]) return scm(playerid, COLOR_GREY, "You don't have that many materials!");
		PlayerInfo[playerid][pMaterials] = PlayerInfo[playerid][pMaterials] - user;
		VehicleInfo[vehicleID][vMats] = VehicleInfo[vehicleID][vMats] + user;
		SaveCrafting(playerid);
		SaveVehicleData(vehicleID, 0);
		new sendername[MAX_PLAYER_NAME];
		format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
		GiveNameSpace(sendername);
		new string[100];
		format(string, sizeof(string), "*** %s stores some materials in the vehicle.", sendername);
		ProxDetector(30.0, playerid, string, COLOR_PURPLE);
		format(string, sizeof(string), "You've stored %d materials inside the vehicle. (Trunk Total: %d)", user, VehicleInfo[vehicleID][vMats]);
		SendClientMessage(playerid, COLOR_GREEN, string);
		return 1;
	} else if(strcmp(type, "takemats", true) == 0) {
		new vehicleID = PlayerToCar(playerid, 2, 4.0);
		if(vehicleID == INVALID_VEHICLE_ID) return scm(playerid, COLOR_GREY, "No nearby vehicle found.");
		if(!IsValidTCar(vehicleID)) return SendClientMessage(playerid, COLOR_GREY, "You can only take materials from a vehicle with an opened trunk!");
		if(user == (-1)) return scm(playerid, COLOR_GREEN, "USAGE: /v takemats {FFFFFF} [amount]");
		if(user <= 0) return scm(playerid, COLOR_GREEN, "USAGE: /v takemats {FFFFFF} [amount]");
		if(user >= 99999999) return scm(playerid, COLOR_GREEN, "USAGE: /v takemats {FFFFFF} [amount]");
		if(user > VehicleInfo[vehicleID][vMats]) return scm(playerid, COLOR_GREY, "There isn't enough materials in the vehicle!");
		VehicleInfo[vehicleID][vMats] = VehicleInfo[vehicleID][vMats] - user;
		PlayerInfo[playerid][pMaterials] = PlayerInfo[playerid][pMaterials] + user;
		SaveCrafting(playerid);
		SaveVehicleData(vehicleID, 0);
		new sendername[MAX_PLAYER_NAME];
		format(sendername, sizeof(sendername), "%s", PlayerNameEx(playerid));
		GiveNameSpace(sendername);
		new string[100];
		format(string, sizeof(string), "*** %s takes some materials from the vehicle.", sendername);
		ProxDetector(30.0, playerid, string, COLOR_PURPLE);
		format(string, sizeof(string), "You've taken %d materials from the vehicle. (Trunk Total: %d)", user, VehicleInfo[vehicleID][vMats]);
		SendClientMessage(playerid, COLOR_GREEN, string);
		return 1;
	} else if(strcmp(type, "crate", true) == 0) {
		new vehicleID = PlayerToCar(playerid, 2, 4.0);
		if (vehicleID == INVALID_VEHICLE_ID) return scm(playerid, COLOR_GREY, "No nearby vehicle found.");
		if (VehicleInfo[vehicleID][vType] != VEHICLE_PERSONAL) return SendClientMessage(playerid, COLOR_WHITE, "Crates can only be stored in personal vehicles.");
		if (!IsTrunkCar(GetVehicleModel(vehicleID))) return SendClientMessage(playerid, COLOR_WHITE, "This vehicle doesn't have an appropriate trunk.");
		if (VehicleInfo[vehicleID][vTrunk] == 0) return SendClientMessage(playerid, COLOR_GREY, "The vehicles trunk must be opened.");
		new foundid = -1;
		for(new i = 0; i < sizeof(CrateInfo); i++)
		{
			if(CrateInfo[i][cUsed] == 1)
			{
				if(CrateInfo[i][cVeh] == vehicleID)
				{
					foundid=i;
					break;
				}
			}
		}
		if(foundid == -1) return SendClientMessage(playerid,COLOR_GREY,"There is no crate in this vehicle.");
		new Float:x2, Float:y2, Float:z2;
		GetPlayerPos(playerid, x2, y2, z2);
		CrateInfo[foundid][cText]=CreateDynamic3DTextLabel( "| SHIPMENT CRATE |\npress '~k~~CONVERSATION_YES~' to navigate !", 0x33AA33FF, x2, y2, z2, 25.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0, 0, -1, 50.0);
		CrateInfo[foundid][cObject] = CreateDynamicObject(964, x2, y2, z2 - 1, 0.0, 0.0, 0.0, 0);
		CrateInfo[foundid][cX]=x2;
		CrateInfo[foundid][cY]=y2;
		CrateInfo[foundid][cZ]=z2;
		CrateInfo[foundid][cVeh]=0;
		SendClientMessage(playerid,COLOR_WHITE,"Crate unloaded!");
	} else if(strcmp(type, "release", true) == 0) {
		if(IsPlayerInRangeOfPoint(playerid, 2.5, 1616.0746, -1897.0616, 13.5491)) {
			new query[100];
			mysql_format(handlesql, query, sizeof(query), "SELECT Model,Impounded FROM vehicles WHERE Owner='%s' AND Impounded > 0", PlayerInfo[playerid][pUsername]);
			mysql_tquery(handlesql, query, "OnVehicleRelease", "i", playerid);
		} else SendClientMessage(playerid, COLOR_LIGHTRED, "You aren't at the Impound Lot!");
	} else if(strcmp(type, "plant", true) == 0) {
		new vehicleID = PlayerInfo[playerid][pInVehicle], incar = 0;
		if(vehicleID == -1) {
			vehicleID = GetPlayerVehicleID(playerid);
			if(vehicleID == 0) { vehicleID = NearestAccessCar(playerid, 2, 10.0); }
		} else incar = 1;
		if(vehicleID == INVALID_VEHICLE_ID) { return SendClientMessage(playerid, COLOR_WHITE, "You can't furnish any near-by vehicles."); }
		if(!CanFurnishVehicle(playerid, vehicleID)) { return SendClientMessage(playerid, COLOR_WHITE, "You don't have permission to furnish this vehicle!"); }
		if(GetPVarInt(playerid, "MonthDon") > 0) {  SendClientMessage(playerid, COLOR_ORANGE, "[NOTICE] {FFFFFF}Since you're a donor you can furnish your vehicle for free! (Except under-glow.)"); }
		if(incar == 0) { //Outdoor
			if(outdoor_vehicle_furn == 0)  { return SendClientMessage(playerid, COLOR_WHITE, "Outdoor vehicle attachments have been disabled by an administrator!"); }
			new count = 0;
			for(new slot = 0; slot < MAX_VEHICLE_OBJ; slot++) {
				if(VehicleInfo[vehicleID][voID][slot] != 0 && VehicleInfo[vehicleID][voIndoor][slot] == 0) {
					count++;
				}
			}
			if(count >= MAX_VEHICLE_OUTDOOR_OBJ) { return SendClientMessage(playerid, COLOR_WHITE, "You can't place any more outdoor vehicle attachments!"); }
			SendClientMessage(playerid, COLOR_BLUE, "[TIP] {FFFFFF}It is recommended that you customise your vehicles exterior on a flat surface for more accurate placement.");
			SetPVarInt(playerid, "FurnVehicleID", vehicleID);
			ShowModelSelectionMenuEx(playerid, VehicleFurnObjs, sizeof(VehicleFurnObjs), "Furniture List", MODEL_SELECTION_VEHFURN_CREATE, 16.0, 0.0, -55.0);
		} else { //Indoor
			if(IsEnterableVehicle(vehicleID) == -1) { return 1; }
			if(user == -1) {
				SetPVarInt(playerid, "FurnVehicleID", vehicleID);
				ShowModelSelectionMenuEx(playerid, FurnObjs, sizeof(FurnObjs), "Furniture List", MODEL_SELECTION_VEHFURN_CREATE, 16.0, 0.0, -55.0);
			} else {
				if(!IsValidObjID(user)) { return SendClientMessage(playerid, COLOR_WHITE, "Invalid object-ID."); }
                new Float:X, Float:Y, Float:Z;
		        GetPlayerPos(playerid, X, Y, Z);
		        new obj = CreatePlayerObject(playerid, user, X+1.0, Y+1.0, Z, 0.0, 0.0, 0.0, 100.0);		
				SetPVarInt(playerid, "FurnObject", obj);
				SetPVarInt(playerid, "FurnVehicleID", vehicleID);
				SetPVarInt(playerid, "EditorMode", EDITOR_MODE_VEHICLEFURN_CREATE);
				PlayerInfo[playerid][pFurnID] = user;
		        EditPlayerObject(playerid, obj);
				new string[100];
		        format(string, sizeof(string),"%s selected, use the SPRINT key to navigate.", ObjectList[user][oName]);
		        SendClientMessage(playerid, COLOR_WHITE, string);				
			}
		}
		return 1;
	} else if(strcmp(type, "edit", true) == 0) {
		new vehicleID = PlayerInfo[playerid][pInVehicle], incar = 0;
		if(vehicleID == -1) {
			vehicleID = GetPlayerVehicleID(playerid);
			if(vehicleID == 0) { vehicleID = NearestAccessCar(playerid, 2, 10.0); }
		} else incar = 1;
		if(vehicleID == INVALID_VEHICLE_ID) { return SendClientMessage(playerid, COLOR_WHITE, "You can't furnish any near-by vehicles."); }
		if(!CanFurnishVehicle(playerid, vehicleID)) { return SendClientMessage(playerid, COLOR_WHITE, "You don't have permission to furnish this vehicle!"); }
		new objlist[MAX_VEHICLE_OBJ], count = 0;
		for(new slot = 0; slot < MAX_VEHICLE_OBJ; slot++) {
			if(VehicleInfo[vehicleID][voID][slot] != 0) {
				if(incar == 1) {
					if(VehicleInfo[vehicleID][voIndoor][slot] == 1) {
						objlist[count] = VehicleInfo[vehicleID][voID][slot];
						count++;
					}
				} else {
					if(outdoor_vehicle_furn == 0) { return SendClientMessage(playerid, COLOR_WHITE, "Outdoor vehicle furniture has been temporarily disabled by an administrator."); }
					if(VehicleInfo[vehicleID][voIndoor][slot] == 0) {
						objlist[count] = VehicleInfo[vehicleID][voID][slot];					
						count++;					
					}
				}
			}
		}
		if(count == 0) {
			SendClientMessage(playerid, COLOR_LIGHTRED, "No vehicle objects found!");
		} else {
			SendClientMessage(playerid, COLOR_BLUE, "[TIP] {FFFFFF}It is recommended that you customise your vehicles exterior on a flat surface for more accurate placement.");
			SetPVarInt(playerid, "FurnVehicleID", vehicleID);
			ShowModelSelectionMenuEx(playerid, objlist, count, "Select Item", MODEL_SELECTION_VEHFURN_EDIT, 16.0, 0.0, -55.0);
		}
		return 1;
   	} else if(strcmp(type, "select", true) == 0) {
		new vehicleID = PlayerInfo[playerid][pInVehicle];
		if(vehicleID == -1) {
			vehicleID = GetPlayerVehicleID(playerid);
			if(vehicleID == 0) { vehicleID = NearestAccessCar(playerid, 2, 10.0); }
		}
		if(vehicleID == INVALID_VEHICLE_ID) { return SendClientMessage(playerid, COLOR_WHITE, "You can't furnish any near-by vehicles."); }
		if(!CanFurnishVehicle(playerid, vehicleID)) { return SendClientMessage(playerid, COLOR_WHITE, "You don't have permission to furnish this vehicle!"); }
		SetPVarInt(playerid, "FurnVehicleID", vehicleID);
		SetPVarInt(playerid, "SelectMode", SELECTMODE_VEHICLE_OBJECT);
		SelectObject(playerid);
		SendClientMessage(playerid, COLOR_BLUE, "[TIP] {FFFFFF}Click on a vehicle-object to edit it.");		
		SendClientMessage(playerid, COLOR_BLUE, "[TIP] {FFFFFF}It is recommended that you customise your vehicles exterior on a flat surface for more accurate placement.");
		return 1;
   	} else if(strcmp(type, "removeall", true) == 0) {
		new vehicleID = PlayerInfo[playerid][pInVehicle];
		if(vehicleID == -1) {
			vehicleID = GetPlayerVehicleID(playerid);
			if(vehicleID == 0) { vehicleID = NearestAccessCar(playerid, 2, 10.0); }
		}
		if(vehicleID == INVALID_VEHICLE_ID) { return SendClientMessage(playerid, COLOR_WHITE, "You can't furnish any near-by vehicles."); }
		if(!CanFurnishVehicle(playerid, vehicleID)) { return SendClientMessage(playerid, COLOR_WHITE, "You don't have permission to furnish this vehicle!"); }
		SetPVarInt(playerid, "FurnVehicleID", vehicleID);
		new string[128];
		format(string, sizeof(string), "Are you sure you want to remove all objects from the %s?", VehicleName[GetVehicleModel(vehicleID)-400]);
		ShowPlayerDialog(playerid, DIALOG_VEHFURN_REMOVEALL_CONFIRM, DIALOG_STYLE_MSGBOX, "Delete Vehicle Objects", string, "Yes", "No");			
		return 1;
	} else if(strcmp(type, "rights", true) == 0) {
		if(user == -1) { return SendClientMessage(playerid, COLOR_GREY, "COMMAND: /v rights [playerid]."); }
		new vehicleID = PlayerInfo[playerid][pInVehicle];
		if(vehicleID == -1) {
			vehicleID = GetPlayerVehicleID(playerid);
			if(vehicleID == 0) { vehicleID = NearestAccessCar(playerid, 2, 10.0); }
		}
		if(vehicleID == INVALID_VEHICLE_ID) { return SendClientMessage(playerid, COLOR_WHITE, "You don't own any near-by vehicles."); }
		if(!PlayerOwnsVehicle(playerid, vehicleID)) { return SendClientMessage(playerid, COLOR_WHITE, "You don't own this vehicle!"); }		
		if(!IsPlayerConnected(user) || IsPlayerNPC(user)) { return SendClientMessage(playerid, COLOR_GREY, "No player found!"); }
		if(PlayerToPlayer(playerid, user, 10.0)) {
			new string[128];
			format(string, 128, "You have given %s permission to furnish your %s!", PlayerInfo[user][pUsername], VehicleName[GetVehicleModel(vehicleID)-400]);
			SendClientMessage(playerid, -1, string);
			format(string, 128, "%s has given you permission to furnish their %s!", PlayerInfo[playerid][pUsername], VehicleName[GetVehicleModel(vehicleID)-400]);
			SendClientMessage(user, -1, string);
			format(VehicleInfo[vehicleID][vRights], MAX_PLAYER_NAME, "%s", PlayerInfo[user][pUsername]);
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "[NOTE] {FFFFFF}Vehicle furnishing rights reset after re-spawning the vehicle.");
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "[NOTE] {FFFFFF}To furnish your vehicle a player must have access to it. (/give carkey)");
		} else SendClientMessage(playerid, COLOR_GREY, "You are not close enough to that player!");
		return 1;
	} else if(strcmp(type, "neon", true) == 0) {
		if(GetPVarInt(playerid, "ColorDelay") > GetCount()) { return SendClientMessage(playerid, -1, "You can't use this command for a moment!"); }
		new vehicleID = GetPlayerVehicleID(playerid);
		if(vehicleID == 0) { return SendClientMessage(playerid, COLOR_WHITE, "You aren't in a vehicle."); }
		SetPVarInt(playerid, "ColorDelay" , GetCount()+5000);
		switch(VehicleInfo[vehicleID][vNeonOff]) {
			case 0: //Neon currently on. Turn it off.
			{
				for(new slot = 0; slot < MAX_VEHICLE_OBJ; slot++) {
					if(IsValidDynamicObject(VehicleInfo[vehicleID][vObject][slot]) && IsNeonObject(VehicleInfo[vehicleID][voID][slot])) {
						DestroyDynamicObject(VehicleInfo[vehicleID][vObject][slot]);
					}
				}
				VehicleInfo[vehicleID][vNeonOff] = 1;
				SendClientMessage(playerid, COLOR_WHITE, "Neon under-glow switched off!");
			}
			case 1: //Neon currently off. Turn it on.
			{
				if(outdoor_neon_furn == 0) { return SendClientMessage(playerid, COLOR_WHITE, "Neon under-glow is currently disabled! (Disabled by an administrator.)"); }
				VehicleInfo[vehicleID][vNeonOff] = 0;
				for(new slot = 0; slot < MAX_VEHICLE_OBJ; slot++) {
					if(VehicleInfo[vehicleID][voID][slot] != 0 && IsNeonObject(VehicleInfo[vehicleID][voID][slot])) {
						CreateVehicleObject(vehicleID, slot);
					}
				}
				Streamer_Update(playerid);
				SendClientMessage(playerid, COLOR_WHITE, "Neon under-glow switched on!");
			}
		}
		return 1;
	} else cmd_v(playerid, "");
	return 1;
}

COMMAND:vehicledata(playerid, params[]) {
	if(GetPVarInt(playerid, "Admin") == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You do not have access to this command!");
	new vehicleID;
	if(sscanf(params, "i", vehicleID)) return SendClientMessage(playerid, COLOR_GREY, "USAGE: /vehicledata [vehicleID]");
	if(!Iter_Contains(Vehicle, vehicleID)) return SendClientMessage(playerid, COLOR_GREY, "A vehicle with this vehicleID is not spawned.");
	new msg[MAX_MSG_LENGTH],
		Float:health,
		Float:pos[4];
		
	GetVehicleHealth(vehicleID, health);
	GetVehiclePos(vehicleID, pos[0], pos[1], pos[2]);
	GetVehicleZAngle(vehicleID, pos[3]);
	format(msg, sizeof(msg), "Vehicle Data ({FF3333}VehicleID: %i, Database ID: %i, X: %.2f, Y: %.2f, Z: %.2f, Angle: %.2f{FFFFFF}):", vehicleID, VehicleInfo[vehicleID][vID], pos[0], pos[1], pos[2], pos[3]);
	SendClientMessage(playerid, -1, msg);
	format(msg, sizeof(msg), "ModelID: %i, Saved ModelID: %i, Park X: %.2f, Park Y: %.2f, Park Z: %.2f, Park Angle: %.2f, Color 1: %i, Color 2: %i", GetVehicleModel(vehicleID), VehicleInfo[vehicleID][vModel], VehicleInfo[vehicleID][vX], VehicleInfo[vehicleID][vY], VehicleInfo[vehicleID][vZ], VehicleInfo[vehicleID][vAngle], VehicleInfo[vehicleID][vColorOne], VehicleInfo[vehicleID][vColorTwo]);
	SendClientMessage(playerid, -1, msg);
	if(isnull(VehicleInfo[vehicleID][vOwner])) {
		format(msg, sizeof(msg), "Engine: %i, Windows: %i, Type: %i, Lights: %i, Created: %i, Job: %i, WireTime: %i, Owner: Noone", VehicleInfo[vehicleID][vEngine], VehicleInfo[vehicleID][vWindows], VehicleInfo[vehicleID][vType], VehicleInfo[vehicleID][vLights], VehicleInfo[vehicleID][vCreated], VehicleInfo[vehicleID][vJob], VehicleInfo[vehicleID][vWireTime]);
	} else {
		format(msg, sizeof(msg), "Engine: %i, Windows: %i, Type: %i, Lights: %i, Created: %i, Job: %i, WireTime: %i, Owner: %s", VehicleInfo[vehicleID][vEngine], VehicleInfo[vehicleID][vWindows], VehicleInfo[vehicleID][vType], VehicleInfo[vehicleID][vLights], VehicleInfo[vehicleID][vCreated], VehicleInfo[vehicleID][vJob], VehicleInfo[vehicleID][vWireTime], VehicleInfo[vehicleID][vOwner]);
	}
	
    SendClientMessage(playerid, -1, msg);
    format(msg, sizeof(msg), "Value: $%i, Fuel: %i, Lock: %i, Donator Vehicle: %i, Plate: %s, PlateV: %i, Insurance: %i, InsuranceC: %i", VehicleInfo[vehicleID][vValue], VehicleInfo[vehicleID][vFuel], VehicleInfo[vehicleID][vLock], VehicleInfo[vehicleID][vDonate], VehicleInfo[vehicleID][vPlate], VehicleInfo[vehicleID][vPlateV], VehicleInfo[vehicleID][vInsurance], VehicleInfo[vehicleID][vInsuranceC]);
    SendClientMessage(playerid, -1, msg);
    format(msg, sizeof(msg), "GPS: %i, Mileage1: %i, Mileage2: %i, Interior: %i", VehicleInfo[vehicleID][vGPS], VehicleInfo[vehicleID][vMileage][1], VehicleInfo[vehicleID][vMileage][2], VehicleInfo[vehicleID][vInterior]);
    SendClientMessage(playerid, -1, msg);
    format(msg, sizeof(msg), "Virtual World: %i, Saved Virtual World: %i, Lock Level: %i, Alarm Level: %i", GetVehicleVirtualWorld(vehicleID), VehicleInfo[vehicleID][vVirtualWorld], VehicleInfo[vehicleID][vLockLvl], VehicleInfo[vehicleID][vAlarmLvl]);
    SendClientMessage(playerid, -1, msg);
    format(msg, sizeof(msg), "Health: %.2f, Saved Health: %.2f, Modification 1: %i, Modification 2: %i, Modification 3: %i, Modification 4: %i", health, VehicleInfo[vehicleID][vHealth], VehicleInfo[vehicleID][vMod][0], VehicleInfo[vehicleID][vMod][1], VehicleInfo[vehicleID][vMod][2], VehicleInfo[vehicleID][vMod][3]);
    SendClientMessage(playerid, -1, msg);
    format(msg, sizeof(msg), "Modification 5: %i, Modification 6: %i, Modification 7: %i, Modification 8: %i, Modification 9: %i, Modification 10: %i", VehicleInfo[vehicleID][vMod][4], VehicleInfo[vehicleID][vMod][5], VehicleInfo[vehicleID][vMod][6], VehicleInfo[vehicleID][vMod][7], VehicleInfo[vehicleID][vMod][8], VehicleInfo[vehicleID][vMod][9]);
    SendClientMessage(playerid, -1, msg);
	if(isnull(VehicleInfo[vehicleID][vRadio])) {
    	format(msg, sizeof(msg), "Modification 11: %i, Radio URL: None", VehicleInfo[vehicleID][vMod][10]);
	} else {
        format(msg, sizeof(msg), "Modification 11: %i, Radio URL: %s", VehicleInfo[vehicleID][vMod][10], VehicleInfo[vehicleID][vRadio]);
	}

	SendClientMessage(playerid, -1, msg);
	return 1;
}

/* === MySQL === */

forward vs_OnVehicleDataLoaded(dbID, playerid);
public vs_OnVehicleDataLoaded(dbID, playerid) {
	if(cache_get_row_count(handlesql) != 0) {
		if(cache_get_field_content_int(0, "Impounded") > 0) return SendClientMessage(playerid, COLOR_WHITE, "Oops! Your vehicle is impounded, you'll have to get it released at the impound lot before you can spawn it again.");
	    new model = cache_get_field_content_int(0, "Model"),
			Float:pos[4],
			color[2],
			vehicleID;

		pos[0] = cache_get_field_content_float(0, "X");
		pos[1] = cache_get_field_content_float(0, "Y");
		pos[2] = cache_get_field_content_float(0, "Z");
		pos[3] = cache_get_field_content_float(0, "Angle");
		color[0] = cache_get_field_content_int(0, "ColorOne");
		color[1] = cache_get_field_content_int(0, "ColorTwo");
		vehicleID = AddStaticVehicleEx(model, pos[0], pos[1], pos[2], pos[3], color[0], color[1], -1);
		if(vehicleID != INVALID_VEHICLE_ID) {
		    if(Iter_Contains(Vehicle, vehicleID)) {
				ResetVehicleData(vehicleID);
			}

		    Iter_Add(Vehicle, vehicleID);
		    VehicleInfo[vehicleID][vEngine] = 0;
    		VehicleInfo[vehicleID][vWindows] = 0;
    		VehicleInfo[vehicleID][vCorp]=0;
    		VehicleInfo[vehicleID][vType] = VEHICLE_PERSONAL;
			VehicleInfo[vehicleID][vLights] = 0;
    		VehicleInfo[vehicleID][vCreated] = 1;
			VehicleInfo[vehicleID][vJob] = 0;
			VehicleInfo[vehicleID][vWireTime] = 0;
		    VehicleInfo[vehicleID][vID] = dbID;
		    VehicleInfo[vehicleID][vModel] = model;
		    VehicleInfo[vehicleID][vX] = pos[0];
		    VehicleInfo[vehicleID][vY] = pos[1];
		    VehicleInfo[vehicleID][vZ] = pos[2];
		    VehicleInfo[vehicleID][vAngle] = pos[3];
		    VehicleInfo[vehicleID][vColorOne] = color[0];
		    VehicleInfo[vehicleID][vColorTwo] = color[1];
			new pj = cache_get_field_content_int(0, "PaintJob");
			VehicleInfo[vehicleID][vPaintJob] = pj;
			ChangeVehiclePaintjob(vehicleID, pj);
			cache_get_field_content(0, "Owner", VehicleInfo[vehicleID][vOwner], handlesql, MAX_PLAYER_NAME);
			VehicleInfo[vehicleID][vValue] = cache_get_field_content_int(0, "Value");
			VehicleInfo[vehicleID][vLock] = cache_get_field_content_int(0, "Locked");
			VehicleInfo[vehicleID][vFuel] = cache_get_field_content_int(0, "Fuel");
			VehicleInfo[vehicleID][vDonate] = cache_get_field_content_int(0, "Donate");
			cache_get_field_content(0, "Plate", VehicleInfo[vehicleID][vPlate], handlesql, VEHICLE_PLATE_MAX_LENGTH);
			if(isnull(VehicleInfo[vehicleID][vPlate])) {
			    new rand = 1000 + random(99999999);
			    format(VehicleInfo[vehicleID][vPlate], VEHICLE_PLATE_MAX_LENGTH, "%i", rand);
			}

			SetVehicleNumberPlate(vehicleID, VehicleInfo[vehicleID][vPlate]);
			VehicleInfo[vehicleID][vPlateV] = cache_get_field_content_int(0, "PlateV");
			VehicleInfo[vehicleID][vInsurance] = cache_get_field_content_int(0, "Insurance");
			VehicleInfo[vehicleID][vInsuranceC] = cache_get_field_content_int(0, "InsuranceC");
			VehicleInfo[vehicleID][vHealth] = cache_get_field_content_float(0, "Health");
			VehicleInfo[vehicleID][vGPS] = cache_get_field_content_int(0, "GPS");
			new fetchstr[50];
			for(new i = 0; i < MAX_VEH_SLOTS; i++)
			{
				format(fetchstr, 50, "InvID%i", i);
				VehicleInfo[vehicleID][vInvID][i] = cache_get_field_content_int(0, fetchstr);
				format(fetchstr, 50, "InvQ%i", i);
				VehicleInfo[vehicleID][vInvQ][i] = cache_get_field_content_int(0, fetchstr);
				format(fetchstr, 50, "InvE%i", i);
				VehicleInfo[vehicleID][vInvE][i] = cache_get_field_content_int(0, fetchstr);
				format(fetchstr, 50, "InvS%i", i);
				VehicleInfo[vehicleID][vInvS][i] = cache_get_field_content_int(0, fetchstr);
			}
			VehicleInfo[vehicleID][vMileage][1] = cache_get_field_content_int(0, "Mileage01");
			VehicleInfo[vehicleID][vMileage][2] = cache_get_field_content_int(0, "Mileage02");
			for(new i = 0; i < MAX_GLOVEBOX_SLOTS; i++)
			{
				format(fetchstr, 50, "GBID%i", i);
				VehicleInfo[vehicleID][vGBID][i] = cache_get_field_content_int(0, fetchstr);
				format(fetchstr, 50, "GBQ%i", i);
				VehicleInfo[vehicleID][vGBQ][i] = cache_get_field_content_int(0, fetchstr);
				format(fetchstr, 50, "GBE%i", i);
				VehicleInfo[vehicleID][vGBE][i] = cache_get_field_content_int(0, fetchstr);
				format(fetchstr, 50, "GBS%i", i);
				VehicleInfo[vehicleID][vGBS][i] = cache_get_field_content_int(0, fetchstr);
			}
			VehicleInfo[vehicleID][vStats][1] = cache_get_field_content_int(0, "Stats1");
			VehicleInfo[vehicleID][vStats][2] = cache_get_field_content_int(0, "Stats2");
			VehicleInfo[vehicleID][vStats][3] = cache_get_field_content_int(0, "Stats3");
			VehicleInfo[vehicleID][vLockLvl] = cache_get_field_content_int(0, "LockLvl");
			VehicleInfo[vehicleID][vAlarmLvl] = cache_get_field_content_int(0, "AlarmLvl");
			VehicleInfo[vehicleID][vVirtualWorld] = cache_get_field_content_int(0, "VirtualWorld");
			VehicleInfo[vehicleID][vMats] = cache_get_field_content_int(0, "Materials");
			VehicleInfo[vehicleID][vInterior] = cache_get_field_content_int(0, "Interior");
			VehicleInfo[vehicleID][vBomb] = cache_get_field_content_int(0, "Bomb");
			VehicleInfo[vehicleID][vMod][0] = cache_get_field_content_int(0, "Mod1");
			VehicleInfo[vehicleID][vMod][1] = cache_get_field_content_int(0, "Mod2");
			VehicleInfo[vehicleID][vMod][2] = cache_get_field_content_int(0, "Mod3");
			VehicleInfo[vehicleID][vMod][3] = cache_get_field_content_int(0, "Mod4");
			VehicleInfo[vehicleID][vMod][4] = cache_get_field_content_int(0, "Mod5");
			VehicleInfo[vehicleID][vMod][5] = cache_get_field_content_int(0, "Mod6");
			VehicleInfo[vehicleID][vMod][6] = cache_get_field_content_int(0, "Mod7");
			VehicleInfo[vehicleID][vMod][7] = cache_get_field_content_int(0, "Mod8");
			VehicleInfo[vehicleID][vMod][8] = cache_get_field_content_int(0, "Mod9");
			VehicleInfo[vehicleID][vMod][9] = cache_get_field_content_int(0, "Mod10");
			VehicleInfo[vehicleID][vMod] = cache_get_field_content_int(0, "Mod11");
			strmid(VehicleInfo[vehicleID][vRadio], "None", 0, strlen("None"), VEHICLE_RADIO_URL_MAX_LENGTH);
		    if(!(VehicleInfo[vehicleID][vInsurance] <= 2 || VehicleInfo[vehicleID][vInsuranceC] > 250)) {
      			VehicleInfo[vehicleID][vHealth] = 950.0;
			}

            if(!IsNotAEngineCar(vehicleID)) {
			    if(VehicleInfo[vehicleID][vHealth] <= 300.0)
			    {
			        new price = 500, string[128];
			        if(GetPlayerMoneyEx(playerid) >= price)
				    {
				        GivePlayerMoneyEx(playerid,-price);
					    format(string, sizeof(string),"-$%d was taken to repair your destroyed %s!", price, PrintVehName(vehicleID));
					    SendClientMessage(playerid,COLOR_WHITE,string);
					    VehicleInfo[vehicleID][vHealth] = 1000.0;
					    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
				    }
				    else
				    {
				        format(string, sizeof(string),"You cannot spawn your %s as it's destroyed, cost: $%d!", PrintVehName(vehicleID), price);
					    SendClientMessage(playerid, COLOR_LIGHTRED, string);
					    DespawnVehicle(vehicleID);
					    return 1;
				    }
			    }
			}

			SetVehicleHealth(vehicleID, VehicleInfo[vehicleID][vHealth]);
			SetVehicleVirtualWorldEx(vehicleID, VehicleInfo[vehicleID][vVirtualWorld]);
			LinkVehicleToInteriorEx(vehicleID, VehicleInfo[vehicleID][vInterior]);
   			if(!IsNotAEngineCar(vehicleID)) {
     			for(new i = 1; i < 10; i++) {
	 				LoadOwnableMods(vehicleID, i);
		 		}

   	            if(VehicleInfo[vehicleID][vInsurance] <= 1 || VehicleInfo[vehicleID][vInsuranceC] > 250) {
			        UpdateVehicleDamageStatus(vehicleID, VehicleInfo[vehicleID][vStats][1], VehicleInfo[vehicleID][vStats][2], 0, VehicleInfo[vehicleID][vStats][3]);
			    }
       		}

			if(VehicleInfo[vehicleID][vValue] == 0) {
				VehicleInfo[vehicleID][vDonate] = 1;
			}

			if(VehicleInfo[vehicleID][vValue] < 0) {
				VehicleInfo[vehicleID][vValue] = 0;
			}

			//LoadCarIDObjects(vehicleID);
			new query[64];
			mysql_format(handlesql, query, sizeof(query), "SELECT * FROM vehiclefurn WHERE VID=%d", VehicleInfo[vehicleID][vID]);
			mysql_tquery(handlesql, query, "LoadVehicleFurniture", "i", vehicleID);
			if(playerid != -1) {
			    new msg[90];
			    format(msg, sizeof(msg), "%s has been spawned at it's designated location, (Area: %s).", VehicleName[GetVehicleModel(vehicleID)-400], GetZone(VehicleInfo[vehicleID][vX], VehicleInfo[vehicleID][vY], VehicleInfo[vehicleID][vZ]));
				SendClientMessage(playerid, COLOR_WHITE, msg);
				format(msg, sizeof(msg), "~w~%s ~g~Spawned", VehicleName[GetVehicleModel(vehicleID)-400]);
				GameTextForPlayer(playerid, msg, 5000, 1);
			}
		} else {
			if(playerid != -1) {
				SendClientMessage(playerid, COLOR_GREY, "An error occured while attempting to spawn the vehicle, please try again.");
			}
		}
	} else {
		if(playerid != -1) {
			SendClientMessage(playerid, COLOR_GREY, "The requested vehicle could not be found in the database, please try again.");
		}
	}
	return 1;
}

forward vs_OnPlayerSpawnsVehicle(playerid);
public vs_OnPlayerSpawnsVehicle(playerid) {
	new rows = cache_get_row_count(handlesql);
	if(rows > 0) {
	    new dialogMsg[400],
	        addition[20],
	        value;
	        
	    for(new i = 0; i < rows; i++) {
	        value = cache_get_field_content_int(i, "Value");
	        if(cache_get_field_content_int(i, "Impounded") > 0) {
	        	format(addition, sizeof(addition), "(Impounded: $%d)", cache_get_field_content_int(i, "Impounded"));
	        } else if(cache_get_field_content_int(i, "Donate") != 0 || value == 0) {
				format(addition, sizeof(addition), "Donator Vehicle, ");
			} else {
				format(addition, sizeof(addition), "%s", EOS);
			}
	        
	        if(isnull(dialogMsg)) {
	    		format(dialogMsg, sizeof(dialogMsg), "Model: %s (%sValue: $%i)", VehicleName[cache_get_field_content_int(i, "Model") - 400], addition, value);
			} else {
				format(dialogMsg, sizeof(dialogMsg), "%s\nModel: %s (%sValue: $%i)", dialogMsg, VehicleName[cache_get_field_content_int(i, "Model") - 400], addition, value);
			}
		}
		
		ShowPlayerDialog(playerid, DIALOG_VEHICLE_SPAWN, DIALOG_STYLE_LIST, "Spawn Vehicle", dialogMsg, "Spawn", "Cancel");
	} else {
		SendClientMessage(playerid, COLOR_GREY, "You do not have any vehicles.");
	}
}

forward vs_OnPlayerVehicleSpawnSelected(playerid);
public vs_OnPlayerVehicleSpawnSelected(playerid) {
	if(cache_get_row_count(handlesql) > 0) {
	    SpawnVehicle(cache_get_field_content_int(0, "ID"), playerid);
	} else {
		SendClientMessage(playerid, COLOR_GREY, "An error occured while attempting to load the vehicle's data, please try again.");
	}
}

forward vs_PlayerSellsVehicleToPlayer(playerid, user, price);
public vs_PlayerSellsVehicleToPlayer(playerid, user, price) {
	// Checking everything twice in case of massive lag or intervening/unexpected behaviour  - Double-Check because of sensitive money-related feature.
    if(GetPVarInt(playerid, "ConnectTime") < 8) return SendClientMessage(playerid, COLOR_GREY, "You need at least 8 Time-In-LS to perform this action.");
    if(!Iter_Contains(Player, user)) return SendClientMessage(playerid, COLOR_GREY, "This player is not connected or points to a NPC.");
    if(playerid == user) return SendClientMessage(playerid, COLOR_GREY, "You cannot sell a vehicle to yourself.");
    if(GetPVarInt(user, "ConnectTime") < 8) return SendClientMessage(playerid, COLOR_GREY, "The player you are trying to sell your vehicle to has less than 8 Time-In-LS.");
	if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_GREY, "You have to be in your vehicle in order to sell it.");
	new vehicleID = GetPlayerVehicleID(playerid);
	if(!PlayerOwnsVehicle(playerid, vehicleID)) return SendClientMessage(playerid, COLOR_GREY, "You don't own this vehicle.");
	if(GetPlayerVehicleID(playerid) != vehicleID) return SendClientMessage(playerid, COLOR_GREY, "You have to be in your vehicle in order to sell it.");
    if(VehicleInfo[vehicleID][vDonate] != 0) return SendClientMessage(playerid, COLOR_GREY, "You cannot sell a donor vehicle.");
    if(VehicleInfo[vehicleID][vModel] == 522) return SendClientMessage(playerid, COLOR_GREY, "You cannot sell a NRG-500.");
	if(price < VehicleInfo[vehicleID][vValue] - 10000 || price > VehicleInfo[vehicleID][vValue] + 20000) {
	    new msg[100];
	    format(msg, sizeof(msg),"You can only sell this vehicle for a price within the following range: $%d - $%d.", VehicleInfo[vehicleID][vValue] - 10000, VehicleInfo[vehicleID][vValue] + 20000);
	    SendClientMessage(playerid, COLOR_GREY, msg);
	} else {
		if(PlayerToPlayer(playerid, user, VEHICLE_SELL_RANGE)) {
		    if(cache_get_row_count() < MaxVehicles(playerid)) {
		        new msg[100];
		        format(msg, sizeof(msg), "You offered %s to purchase your vehicle for $%i.", PlayerInfo[user][pName], price);
				SendClientMessage(playerid, COLOR_LIGHTRED, msg);
				format(msg, sizeof(msg), "%s offered you to purchase his vehicle for $%i (/accept sellto).", PlayerInfo[playerid][pName], price);
				SendClientMessage(user, COLOR_LIGHTRED, msg);
				SetPVarInt(user, "VehicleOffer", playerid);
				SetPVarInt(user, "VehicleOfferPrice", price);
				SetPVarInt(user, "VehicleOfferID", vehicleID);
		    } else {
				SendClientMessage(playerid, COLOR_GREY, "This player already holds the maximum amount of ownerships of vehicles per-player.");
			}
		} else {
			SendClientMessage(playerid, COLOR_GREY, "You are not close enough to this player.");
	    }
	}
	
	return 1;
}

/* === Functions === */

SpawnVehicle(dbID, playerid = -1) {
	if(Iter_Free(Vehicle) != -1) {
		foreach(new i : Vehicle) {
			if(VehicleInfo[i][vID] == dbID) {
				SendClientMessage(playerid, COLOR_GREY, "This vehicle is already spawned.");
				return -1;
			}
		}

		new query[50];
		mysql_format(handlesql, query, sizeof(query), "SELECT * FROM `vehicles` WHERE `ID`=%i", dbID);
		mysql_tquery(handlesql, query, "vs_OnVehicleDataLoaded", "ii", dbID, playerid);
	} else {
		if(playerid != -1) {
			SendClientMessage(playerid, COLOR_GREY, "Vehicle could not be spawned as the maximum amount of spawned vehicles has been reached, please contact an administrator.");
		}
		
		return 0;
	}
	
	return 1;
}

/*stock LoadCarIDObjects(key) {
    if(!IsNotAEngineCarEx(key))
    {
        if(!IsHelmetCar(key) && !IsBike(key))
        {
			new item[6], Float:x, Float:y, Float:z, count = 0;
			if(VehicleInfo[key][vType] == VEHICLE_PERSONAL && IsTrunkCar(GetVehicleModel(key)))
			{
				GetVehicleModelInfo(GetVehicleModel(key), 6, x, y, z);
				item[1]=VehicleInfo[key][vInvID][1], item[2]=VehicleInfo[key][vInvID][2];
				item[3]=VehicleInfo[key][vInvID][3], item[4]=VehicleInfo[key][vInvID][4];
				item[5]=VehicleInfo[key][vInvID][5];
				for(new i = 1; i < 6; i++)
				{
					if(VehicleInfo[key][cObject][i] > 0)
					{
						if(IsValidDynamicObject(VehicleInfo[key][cObject][i])) { DestroyDynamicObject(VehicleInfo[key][cObject][i]); }
						VehicleInfo[key][cObject][i] = 0;
					}
					if(item[i] > 0)
					{
						if(TrunkObject(item[i], 1))
						{
							count++;
						}
					}
				}
				if(count > 0)
				{
					for(new i = 1; i < 6; i++)
					{
						if(item[i] > 0)
						{
							if(TrunkObject(item[i], 1))
							{
								VehicleInfo[key][cObject][i]=CreateDynamicObject(TrunkObject(item[i], 2), x, y, z, 0.0, 0.0, 0.0, GetVehicleVirtualWorld(key));
								new Float:offset = 0.0, Float:offset2 = 0.0;
								switch(count)
								{
									case 1:
									{
										switch(i)
										{
											case 1: { offset=1.0, offset2=TrunkOffset(GetVehicleModel(key), 1); }
										}
									}
									case 2:
									{
										switch(i)
										{
											case 1: { offset=1.4, offset2=TrunkOffset(GetVehicleModel(key), 1); }
											case 2: { offset=0.4, offset2=TrunkOffset(GetVehicleModel(key), 1); }
										}
									}
									case 3:
									{
										switch(i)
										{
											case 1: { offset=1.4, offset2=TrunkOffset(GetVehicleModel(key), 1); }
											case 2: { offset=0.9, offset2=TrunkOffset(GetVehicleModel(key), 1); }
											case 3: { offset=0.4, offset2=TrunkOffset(GetVehicleModel(key), 1); }
										}
									}
									case 4:
									{
										switch(i)
										{
											case 1: { offset=1.4, offset2=TrunkOffset(GetVehicleModel(key), 1); }
											case 2: { offset=1.0, offset2=TrunkOffset(GetVehicleModel(key), 1); }
											case 3: { offset=0.7, offset2=TrunkOffset(GetVehicleModel(key), 1); }
											case 4: { offset=0.4, offset2=TrunkOffset(GetVehicleModel(key), 1); }
										}
									}
									case 5:
									{
										switch(i)
										{
											case 1: { offset=1.4, offset2=TrunkOffset(GetVehicleModel(key), 1); }
											case 2: { offset=1.0, offset2=TrunkOffset(GetVehicleModel(key), 1)-0.1; }
											case 3: { offset=0.9, offset2=TrunkOffset(GetVehicleModel(key), 1); }
											case 4: { offset=0.7, offset2=TrunkOffset(GetVehicleModel(key), 1)-0.1; }
											case 5: { offset=0.4, offset2=TrunkOffset(GetVehicleModel(key), 1); }
										}
									}
									case 6:
									{
										switch(i)
										{
											case 1: { offset=1.4, offset2=TrunkOffset(GetVehicleModel(key), 1); }
											case 2: { offset=1.2, offset2=TrunkOffset(GetVehicleModel(key), 1)-0.1; }
											case 3: { offset=1.0, offset2=TrunkOffset(GetVehicleModel(key), 1); }
											case 4: { offset=0.8, offset2=TrunkOffset(GetVehicleModel(key), 1)-0.1; }
											case 5: { offset=0.6, offset2=TrunkOffset(GetVehicleModel(key), 1); }
											case 6: { offset=0.4, offset2=TrunkOffset(GetVehicleModel(key), 1); }
										}
									}
									default:
									{
										switch(i)
										{
											case 1: { offset=1.5, offset2=TrunkOffset(GetVehicleModel(key), 1); }
											case 2: { offset=1.4, offset2=TrunkOffset(GetVehicleModel(key), 1)-0.1; }
											case 3: { offset=1.2, offset2=TrunkOffset(GetVehicleModel(key), 1); }
											case 4: { offset=1.0, offset2=TrunkOffset(GetVehicleModel(key), 1)-0.1; }
											case 5: { offset=0.8, offset2=TrunkOffset(GetVehicleModel(key), 1); }
											case 6: { offset=0.6, offset2=TrunkOffset(GetVehicleModel(key), 1)-0.1; }
											case 7: { offset=0.4, offset2=TrunkOffset(GetVehicleModel(key), 1); }
											case 8: { offset=0.2, offset2=TrunkOffset(GetVehicleModel(key), 1)-0.1; }
										}
									}
								}
								AttachDynamicObjectToVehicle(VehicleInfo[key][cObject][i], key, x-offset, y-offset2, z+TrunkOffset(GetVehicleModel(key), 2), 0.0+TrunkObject(item[i], 3), 0.0, 0.0+90.0);
							}
						}
					}
				}
			}
		}
    }
	return true;
}*/

stock IsPlayerVehicleSpawned(playerid) {
	if(Iter_Contains(Player, playerid)) {
	    foreach(new i : Vehicle) {
			if(!isnull(VehicleInfo[i][vOwner]) && strcmp(VehicleInfo[i][vOwner], PlayerInfo[playerid][pUsername], false) == 0 && VehicleInfo[i][vType] == VEHICLE_PERSONAL) {
				return i;
			}
		}
	}
	
	return -1;
}

stock ResetVehicleData(vehicleID) {
	new playerid = GetPlayerID(VehicleInfo[vehicleID][vOwner]);
	if(playerid != -1) {
		foreach(new i : Player) {
			if(GetPVarInt(i, "VehicleOffer") == playerid) {
				SetPVarInt(i, "VehicleOffer", INVALID_MAXPL);
				DeletePVar(i, "VehicleOfferPrice");
				DeletePVar(i, "VehicleOfferID");
			}
		}
	}

	for(new i = 0; i < MAX_VEHICLE_SIREN_OBJECTS; i++)
	{
		if(IsValidDynamicObject(VehicleInfo[vehicleID][vSirenObjectID][i]))
		{
			if(VehicleInfo[vehicleID][vSirenObjectID][i] != 0)
			{
	  		    DestroyDynamicObject(VehicleInfo[vehicleID][vSirenObjectID][i]);
	  		    VehicleInfo[vehicleID][vSirenObject][i] = 0;
	  		    VehicleInfo[vehicleID][vSirenObjectID][i] = 0;
	  		    VehicleInfo[vehicleID][vSirenX][i] = 0;
	  		    VehicleInfo[vehicleID][vSirenY][i] = 0;
	  		    VehicleInfo[vehicleID][vSirenZ][i] = 0;
	  		    VehicleInfo[vehicleID][vSirenXr][i] = 0;
	  		    VehicleInfo[vehicleID][vSirenYr][i] = 0;
	  		    VehicleInfo[vehicleID][vSirenZr][i] = 0;
	  		}
	 	}
	}
	
	format(VehicleInfo[vehicleID][vRights], MAX_PLAYER_NAME, "\0");
	VehicleInfo[vehicleID][vNeonOff] = 0;
	for(new i = 0; i < MAX_VEHICLE_OBJ; i++) {
		if(IsValidDynamicObject(VehicleInfo[vehicleID][vObject][i])) {
			DestroyDynamicObject(VehicleInfo[vehicleID][vObject][i]);
		}
		VehicleInfo[vehicleID][voID][i] = 0;
		VehicleInfo[vehicleID][voX][i] = 0.0;
		VehicleInfo[vehicleID][voY][i] = 0.0;
		VehicleInfo[vehicleID][voZ][i] = 0.0;
		VehicleInfo[vehicleID][vorX][i] = 0.0;
		VehicleInfo[vehicleID][vorY][i] = 0.0;
		VehicleInfo[vehicleID][vorZ][i] = 0.0;
		VehicleInfo[vehicleID][voIndoor][i] = 0;
	}
 	
 	if(VehicleInfo[vehicleID][vUText] > 0) {
 	Delete3DTextLabel(VehicleInfo[vehicleID][vCText]);
	VehicleInfo[vehicleID][vUText]=0; }
	
	for(new i=1; i < MAX_VEH_SLOTS; i++) {
		VehicleInfo[vehicleID][vInvID][i] = 0;
	}

    for(new i = 0; i < sizeof(VehicleInfo[]); i++) {
	    VehicleInfo[vehicleID][vInfo:i] = 0;
	}

	Iter_Remove(Vehicle, vehicleID);
}

stock DespawnVehicle(vehicleID)
{
	foreach(new i : Player) {
		if(PlayerInfo[i][pInVehicle] == vehicleID) {
			ExitVehicleInterior(i);
		}
	}
    DestroyVehicle(vehicleID);
    ResetVehicleData(vehicleID);
}

stock ImpoundVehicle(databaseID, price) {
	new query[256], rand = random(sizeof(ImpoundSpawns));
	mysql_format(handlesql, query, sizeof(query), "UPDATE vehicles SET Impounded=%d,X=%f,Y=%f,Z=%f,Angle=%f WHERE ID=%d", price, 
		ImpoundSpawns[rand][i_x], ImpoundSpawns[rand][i_y], 
		ImpoundSpawns[rand][i_z], ImpoundSpawns[rand][i_ang], databaseID);
	mysql_tquery(handlesql, query);	
}

stock ReleaseVehicle(databaseID) {
	new query[256];
	mysql_format(handlesql, query, sizeof(query), "UPDATE vehicles SET Impounded=0 WHERE ID=%d", databaseID);
	mysql_tquery(handlesql, query);	
}

stock SaveVehicleData(id, saveowner = 0) {
	// Yet to be improved!
	if(VehicleInfo[id][vType] != VEHICLE_PERSONAL) return 1;
	//==========//
	new query[500], Float:health, panels,doors,lights,tires;
	GetVehicleHealth(id, health);
	VehicleInfo[id][vHealth]=health;
    GetVehicleDamageStatus(id,panels,doors,lights,tires);
    VehicleInfo[id][vStats][1]=panels;
    VehicleInfo[id][vStats][2]=doors;
    VehicleInfo[id][vStats][3]=tires;
    //=========//
	if(saveowner == 1)
	{
 		mysql_format(handlesql, query, sizeof(query), "UPDATE vehicles SET Model=%d, X=%f, Y=%f, Z=%f, Angle=%f, ColorOne=%d, ColorTwo=%d, Owner='%e', Value=%d, PaintJob=%d WHERE ID=%d",
  		VehicleInfo[id][vModel], VehicleInfo[id][vX], VehicleInfo[id][vY], VehicleInfo[id][vZ], VehicleInfo[id][vAngle],
		VehicleInfo[id][vColorOne], VehicleInfo[id][vColorTwo], VehicleInfo[id][vOwner], VehicleInfo[id][vValue], VehicleInfo[id][vPaintJob], VehicleInfo[id][vID]);
		mysql_tquery(handlesql, query);
	}
	else
	{
	    mysql_format(handlesql, query, sizeof(query), "UPDATE vehicles SET Model=%d, X=%f, Y=%f, Z=%f, Angle=%f, ColorOne=%d, ColorTwo=%d, Value=%d, PaintJob=%d, Interior=%d WHERE ID=%d",
  		VehicleInfo[id][vModel], VehicleInfo[id][vX], VehicleInfo[id][vY], VehicleInfo[id][vZ], VehicleInfo[id][vAngle],
		VehicleInfo[id][vColorOne], VehicleInfo[id][vColorTwo], VehicleInfo[id][vValue], VehicleInfo[id][vPaintJob], VehicleInfo[id][vInterior], VehicleInfo[id][vID]);
		mysql_tquery(handlesql, query);
	}
    //==========//
	mysql_format(handlesql, query, sizeof(query), "UPDATE vehicles SET Locked=%d, Fuel=%d, Donate=%d, Plate='%e', PlateV=%d, GPS=%d, Insurance=%d, InsuranceC=%d, Health=%f, VirtualWorld=%d, Materials=%d WHERE ID=%d",
	VehicleInfo[id][vLock], VehicleInfo[id][vFuel], VehicleInfo[id][vDonate], VehicleInfo[id][vPlate], VehicleInfo[id][vPlateV],
	VehicleInfo[id][vGPS], VehicleInfo[id][vInsurance], VehicleInfo[id][vInsuranceC], VehicleInfo[id][vHealth], VehicleInfo[id][vVirtualWorld], VehicleInfo[id][vMats], VehicleInfo[id][vID]);
	mysql_tquery(handlesql, query);
	//==========//
	for(new i = 0; i < MAX_VEH_SLOTS; i++)
	{
		mysql_format(handlesql, query, sizeof(query), "UPDATE `vehicles` SET `InvID%d`=%d,`InvQ%d`=%d,`InvE%d`=%d,`InvS%d`=%d WHERE ID=%d",
		i, VehicleInfo[id][vInvID][i], i, VehicleInfo[id][vInvQ][i], i, VehicleInfo[id][vInvE][i], i, VehicleInfo[id][vInvS][i], VehicleInfo[id][vID]);
		mysql_tquery(handlesql, query);
	}
	//==========//
	for(new i = 0; i < MAX_GLOVEBOX_SLOTS; i++)
	{
		mysql_format(handlesql, query, sizeof(query), "UPDATE `vehicles` SET `GBID%d`=%d,`GBQ%d`=%d,`GBE%d`=%d,`GBS%d`=%d WHERE ID=%d",
		i, VehicleInfo[id][vGBID][i], i, VehicleInfo[id][vGBQ][i], i, VehicleInfo[id][vGBE][i], i, VehicleInfo[id][vGBS][i], VehicleInfo[id][vID]);
		mysql_tquery(handlesql, query);
	}
	//==========//
	mysql_format(handlesql, query, sizeof(query), "UPDATE `vehicles` SET `Mileage01`=%d,`Mileage02`=%d,`Stats1`=%d,`Stats2`=%d,`Stats3`=%d WHERE ID=%d",
	VehicleInfo[id][vMileage][1], VehicleInfo[id][vMileage][2],
	VehicleInfo[id][vStats][1], VehicleInfo[id][vStats][2],
	VehicleInfo[id][vStats][3], VehicleInfo[id][vID]);
	mysql_tquery(handlesql, query);
	
	//==========//
	mysql_format(handlesql, query, sizeof(query), "UPDATE `vehicles` SET `LockLvl`=%d,`AlarmLvl`=%d,`Bomb`=%d WHERE ID=%d",
	VehicleInfo[id][vLockLvl], VehicleInfo[id][vAlarmLvl], VehicleInfo[id][vBomb], VehicleInfo[id][vID]);
	mysql_tquery(handlesql, query);
	for(new i = 0; i < 11; i++) {
		mysql_format(handlesql, query, sizeof(query), "UPDATE `vehicles` SET Mod%d = %d WHERE ID = %d", i + 1, VehicleInfo[id][vMod][i], VehicleInfo[id][vID]);
		mysql_tquery(handlesql, query);
	}
	return 1;
}

forward vs_OnAdminVehicleSpawnSelected(playerid);
public vs_OnAdminVehicleSpawnSelected(playerid)  {
	if(cache_get_row_count(handlesql) > 0) {
		for(new i = 0; i < cache_get_row_count(handlesql); i++) {
			for(new i2 = 0; i2 < CountSpawnedCars(playerid); i2++) {
				new vehicleID = GetSpawnedVehicle(playerid, i2);
				if(VehicleInfo[vehicleID][vID] == cache_get_field_content_int(i, "ID")) {
					SendClientMessage(playerid, COLOR_GREY, "This vehicle is already spawned.");
					return 1;
				}
			}
			SpawnVehicle(cache_get_field_content_int(i, "ID"), playerid);
		}
	}
	return 1;
}

forward OnVehicleRelease(playerid);
public OnVehicleRelease(playerid) {
	if(cache_get_row_count() < 1) { return SendClientMessage(playerid, COLOR_WHITE, "You don't have any impounded vehicles!"); }
	new result[264];
	for(new i = 0; i < cache_get_row_count(); i++) {
		format(result, sizeof(result), "%s%s ($%d)\n", result, VehicleName[cache_get_field_content_int(i, "Model")-400], cache_get_field_content_int(i, "Impounded"));
	}
	ShowPlayerDialog(playerid, DIALOG_VEHICLE_RELEASE, DIALOG_STYLE_LIST, "Impound List", result, "Release", "Cancel");
	return 1;
}

forward OnVehicleReleased(playerid);
public OnVehicleReleased(playerid) {
	if(cache_get_row_count() < 1) { return error(playerid, "Vehicle not found!"); }
	new price = cache_get_field_content_int(0, "Impounded");
	if(GetPlayerMoneyEx(playerid) >= price) {
		GivePlayerMoneyEx(playerid, -price);
		ReleaseVehicle(cache_get_field_content_int(0, "ID"));
		new string[128];
		format(string, sizeof(string), "~r~-$%d", price);
		GameTextForPlayer(playerid, string, 5000, 1);
		format(string, sizeof(string), "You've released your %s from impound, you can now spawn it.", VehicleName[cache_get_field_content_int(0, "Model")-400]);
		SendClientMessage(playerid, COLOR_WHITE, string);
		SendClientMessage(playerid, COLOR_BLUE, "[TIP] {FFFFFF}Your car will spawn at the impound lot across the street. Make sure you re-park it elsewhere.");
	} else SendClientMessage(playerid, COLOR_WHITE, "You can't afford this!");
	return 1;
}