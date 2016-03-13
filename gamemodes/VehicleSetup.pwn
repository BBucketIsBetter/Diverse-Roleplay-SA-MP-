//============================================//
//=====[ VEHICLE USAGE SECTION ]=====//
//============================================//
public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    //============//
	// ANTI DEAD G-BUG //
	//============//
	if(GetPVarInt(playerid, "Dead") > 0)
	{
	    ClearAnimations(playerid, 1);
	    ApplyAnimation(playerid, "ped", "FLOOR_hit_f", 4.0, 0, 1, 1, 1, -1);
	    return 1;
	}
	//============//
    if(GetPVarInt(playerid, "OnRoute") != 0)
    {
		if(vehicleid != GetPVarInt(playerid, "RouteVeh"))
		{
            ClearAnimations(playerid, 1);
            return true;
        }
    }
	if(ispassenger)
	{
		if(VehicleInfo[vehicleid][vType] == VEHICLE_JOB && VehicleInfo[vehicleid][vJob] == 6)
		{
		    new found = 0;
		    foreach(new i : Player)
		    {
		        if(GetPlayerVehicleID(i) == vehicleid)
		        {
		            if(GetPlayerState(i) == PLAYER_STATE_DRIVER)
		            {
		                found++;
						break;
		            }
		        }
		    }
		    if(found == 0) ClearAnimations(playerid, 1);
		}
	}
	else
	{
		new Float:x, Float:y, Float:z;
		GetPlayerPos(playerid, x, y, z);
	    foreach(new i : Player)
		{
		    if(playerid != i && IsPlayerInVehicle(i,vehicleid) && GetPlayerState(i) == 2 && GetPVarInt(playerid, "Control") == 0)
		    {
		        RemovePlayerFromVehicle(playerid);
				ClearAnimations(playerid);
			    SetPlayerPosEx(playerid,x,y,z+1.5);
			    TogglePlayerControllableEx(playerid,false);
			    SetTimerEx("TogglePlayerControllableEx", 2000, false, "ii", playerid,true);
			    return SendClientMessage(playerid,COLOR_LIGHTRED, "You have been frozen for supposedly Non-RP Jacking!");
			}
		}
	    switch(VehicleInfo[vehicleid][vType])
	    {
	        case VEHICLE_RENTAL:
	        {
	            if(GetPVarInt(playerid, "RentKey") != vehicleid) ClearAnimations(playerid, 1);
	        }
	        case VEHICLE_JOB:
	        {
	            if(GetPVarInt(playerid, "Job") != VehicleInfo[vehicleid][vJob]) ClearAnimations(playerid, 1);
	            if(GetPVarInt(playerid, "RouteVeh") != vehicleid) ClearAnimations(playerid, 1);
	        }
	        case VEHICLE_LSPD:
	        {
	            if(GetPVarInt(playerid, "Member") != 1) ClearAnimations(playerid, 1);
	        }
	        case VEHICLE_LSFD:
	        {
	            if(GetPVarInt(playerid, "Member") != 2) ClearAnimations(playerid, 1);
	        }
	        case VEHICLE_GOV:
	        {
	            if(GetPVarInt(playerid, "Member") != 8) ClearAnimations(playerid, 1);
	        }
	        case VEHICLE_RLS:
	        {
	            if(GetPVarInt(playerid, "Member") != 3) ClearAnimations(playerid, 1);
	        }
	        case VEHICLE_SAN:
	        {
	            if(GetPVarInt(playerid, "Member") != 4) ClearAnimations(playerid, 1);
	        }
	    }
	}
	SetPVarInt(playerid, "EnterVehicle" , GetCount()+10000);
	return 1;
}
//============================================//
public OnPlayerExitVehicle(playerid, vehicleid)
{
    if(GetPVarInt(playerid, "Hotwire") > 0) { DeletePVar(playerid,"Hotwire"); }
    DeletePVar(playerid,"EnterVehicle"), DeletePVar(playerid, "RefillAM"), DeletePVar(playerid, "RefillPR");
    StopAudioStreamForPlayerEx(playerid);
    if(IsPlayerAttachedObjectSlotUsed(playerid,HOLDOBJECT_CLOTH1)) RemovePlayerAttachedObject(playerid,HOLDOBJECT_CLOTH1), SetPVarInt(playerid, "Seatbelt", 0);
    StopProgress(playerid);
	return 1;
}
//============================================//
stock CreateVehicleEx(vehicletype, Float:x, Float:y, Float:z, Float:rotation, color1, color2, respawn_delay, plate[])
{
	new id;
    id = CreateVehicle(vehicletype, x, y, z, rotation, color1, color2, respawn_delay);
    VehicleInfo[id][vFuel]=100, VehicleInfo[id][vEngine]=0;
    VehicleInfo[id][vWindows]=0, VehicleInfo[id][vID]=0;
    VehicleInfo[id][vType]=VEHICLE_NONE, VehicleInfo[id][vLights]=0;
    VehicleInfo[id][vCreated]=1, VehicleInfo[id][vJob]=0;
	VehicleInfo[id][vWireTime]=0;
    SetVehicleNumberPlate(id, plate);
    SetVehicleToRespawn(id);
	return id;
}
//============================================//
public VehCreation(playerid)
{
	new string[248];
	switch(GetPVarInt(playerid, "VEHC"))
	{
	    case 0:
	    {
	        SetPVarInt(playerid, "VEHC", 1);
	        //==========//
	        SetPVarInt(playerid, "VEHID", 0);
	        //==========//
	        TogglePlayerControllable(playerid,false);
            SetPlayerPosEx(playerid, 2233.0278,2457.1990,-7.4531+10.0);
            SetPlayerCameraPos(playerid, 2233.0278,2457.1990,-7.4531+3.5);
            SetPlayerCameraLookAt(playerid, 2226.3962,2457.6038,-7.4531);
            if(playerid == 0) SetPlayerVirtualWorld(playerid,INVALID_MAXPL);
            else SetPlayerVirtualWorld(playerid,playerid);
            //==========//
	        CallRemoteFunction("VehCreation", "i", playerid);
	        //==========//
	    }
	    case 1: // Code here
	    {
			new id = GetPVarInt(playerid, "VEHID"), carmdl, price;
			switch(GetPVarInt(playerid, "VEHMDL"))
			{
			    case 1: // Vehicle NORMAL Dealership
			    {
			        carmdl=VehDealership[id][0];
			        price=VehDealership[id][1];
			    }
			    case 2: // Vehicle GROTTI Dealership
			    {
			        carmdl=GrotDealership[id][0];
			        price=GrotDealership[id][1];
			    }
			    case 3: // Vehicle BIKE Dealership
			    {
			        carmdl=BikeDealership[id][0];
			        price=BikeDealership[id][1];
			    }
			    case 4: // Vehicle BOAT Dealership
			    {
			        carmdl=BoatDealership[id][0];
			        price=BoatDealership[id][1];
			    }
			}
			//=====//
			format(string, 248, "{FF3333}%s\n{FFFFFF}Cost: {19D175}$%d\n{FFFFFF}Fuel type: %s", VehicleName[carmdl-400], price, FuelName(GasType(carmdl)));
			ShowPlayerDialog(playerid,36,DIALOG_STYLE_MSGBOX,"DEALERSHIP",string,"Next", "Options");
			PlayerPlaySound(playerid,1054, 0.0, 0.0, 0.0);
			//==========//
			if(carmdl != GetVehicleModel(GetPVarInt(playerid, "VEHVEH")))
			{
			    if(GetPVarInt(playerid, "VEHVEH") >= 1) { DestroyVehicle(GetPVarInt(playerid, "VEHVEH")); }
			    new idcar = AddStaticVehicleEx(carmdl, 2226.3962, 2457.6038, -7.4531, 314.4251, 0, 0, 9999);
			    SetVehicleVirtualWorld(idcar, GetPlayerVirtualWorld(playerid));
			    SetPVarInt(playerid, "VEHVEH", idcar);
			}
			//==========//
	    }
	}
	return true;
}
//============================================//
public VehMod(playerid)
{
	new idcar = GetPlayerVehicleID(playerid), Float:X, Float:Y, Float:Z, string[128];
	GetPlayerPos(playerid, X, Y, Z);
    switch(GetPVarInt(playerid, "VEHMOD"))
	{
	    case 0:
	    {
		    SetPVarInt(playerid, "VEHMOD", 1);
		    SetPVarInt(playerid, "BOOGA", 1);
		    SetVehiclePosEx(idcar, -1688.1204,1035.6780,45.0044);
		    SetVehicleZAngle(idcar, 89.8080);
		    foreach(new i : Player)
		    {
		        if(GetPlayerVehicleID(i) == idcar)
		        {
		            if(i != playerid) SetPVarInt(i, "SeatIDm", GetPlayerVehicleSeat(i));
		            TogglePlayerControllable(i, false);
		            SetPlayerCameraPos(i, -1693.7269, 1035.6421, 45.2109+0.5);
		            SetPlayerCameraLookAt(i, -1688.1204, 1035.6780, 45.0044);
		            SetVehicleVirtualWorld(idcar, playerid);
		            SetPlayerVirtualWorld(i, playerid);
		            if(i != playerid) PutPlayerInVehicleEx(i, idcar, GetPVarInt(i, "SeatIDm"));
		        }
		    }
		    CallRemoteFunction("VehMod", "i", playerid);
		}
		case 1:
		{
		    switch(GetPVarInt(playerid, "VEHSEC"))
		    {
		        case 0:
		        {
		            if(GetPVarInt(playerid, "BOOGA") == 0)
		            {
		                SetPlayerCameraPos(playerid, -1693.7269, 1035.6421, 45.2109+0.5);
		                SetPlayerCameraLookAt(playerid, X, Y, Z, 1);
		            }
		            else DeletePVar(playerid, "BOOGA");
		            if(IsNotAEngineCar(idcar) || IsBike(idcar)) ShowPlayerDialog(playerid,25,DIALOG_STYLE_LIST,"Mod Shop","Select Color 1\nSelect Color 2","Select", "Exit");
		            else ShowPlayerDialog(playerid,25,DIALOG_STYLE_LIST,"Mod Shop","Select Color 1\nSelect Color 2\nSelect Wheels\nBody Modifications\nRemove Mods","Select", "Exit");
		        }
		        case 1: // SELECT COLOR 1
		        {
		            SetPlayerCameraPos(playerid, -1691.1902,1037.9753,45.5051+0.5);
		            SetPlayerCameraLookAt(playerid, X, Y, Z, 1);
		            ShowPlayerDialog(playerid,25,DIALOG_STYLE_INPUT,"Select Color 1", "Cost: $500\nSelect a color from (1-300)","Select", "Back");
		        }
		        case 2: // SELECT COLOR 2
		        {
		            SetPlayerCameraPos(playerid, -1691.1902,1037.9753,45.5051+0.5);
		            SetPlayerCameraLookAt(playerid, X, Y, Z, 1);
		            ShowPlayerDialog(playerid,25,DIALOG_STYLE_INPUT,"Select Color 2", "Cost: $500\nSelect a color from (1-300)","Select", "Back");
		        }
		        case 3: // SELECT WHEELS
		        {
		            if(IsBike(idcar))
		            {
		                SetPVarInt(playerid, "VEHSEC", 0);
		                CallRemoteFunction("VehMod", "i", playerid);
		                SCM(playerid, COLOR_LIGHTRED, "You can not modify bike wheels!");
		                return true;
		            }
		            SetPlayerCameraPos(playerid, -1691.1902,1037.9753,45.5051+0.5);
		            SetPlayerCameraLookAt(playerid, X, Y, Z, 1);
					SetTimerEx("ShowWheels", 100, false, "i", playerid); //Delay a frame to prevent accidental clicking.
		        }
		        case 4: // BODY MODS
		        {
		            if(IsBike(idcar))
		            {
		                SetPVarInt(playerid, "VEHSEC", 0);
		                CallRemoteFunction("VehMod", "i", playerid);
		                SCM(playerid, COLOR_LIGHTRED, "You can not modify bikes!");
		                return true;
		            }
		            SetPlayerCameraPos(playerid, -1691.1902,1037.9753,45.5051+0.5);
		            SetPlayerCameraLookAt(playerid, X, Y, Z, 1);
		            new result[2000], comp[20], compname[20][128];
		            comp[0]=1087, compname[0]="Hydraulics";
		            switch(GetVehicleModel(idcar))
		            {
		                case 534: // REMMINGTON
		                {
		                    comp[1]=1100, compname[1]="Bullbar Chrome Grill";
		                    comp[2]=1101, compname[2]="Sideskirt Left `Chrome Flames`";
		                    comp[3]=1106, compname[3]="Sideskirt Right `Chrome Arches`";
		                    comp[4]=1122, compname[4]="Sideskirt Right `Chrome Flames`";
		                    comp[5]=1123, compname[5]="Bullbars Bullbar Chrome Bars";
		                    comp[6]=1124, compname[6]="Sideskirt Left `Chrome Arches`";
		                    comp[7]=1125, compname[7]="Bullbars Bullbar Chrome Lights";
		                    comp[8]=1126, compname[8]="Exhaust Chrome Exhaust";
		                    comp[9]=1127, compname[9]="Exhaust Slamin Exhaust";
		                    comp[10]=1178, compname[10]="Rear Bumper Slamin";
		                    comp[11]=1179, compname[11]="Front Bumper Chrome";
		                    comp[12]=1180, compname[12]="Rear Bumper Chrome";
		                    comp[13]=1185, compname[13]="Front Bumper Slamin";
		                }
		                case 535: // SLAMVAN
		                {
		                    comp[1]=1109, compname[1]="Rear Bullbars Chrome";
		                    comp[2]=1110, compname[2]="Rear Bullbars Slamin";
		                    comp[3]=1111, compname[3]="Front Sign?Little Sign?";
		                    comp[4]=1112, compname[4]="Front Sign?Little Sign?";
		                    comp[5]=1113, compname[5]="Exhaust Chrome";
		                    comp[6]=1114, compname[6]="Exhaust Slamin";
		                    comp[7]=1115, compname[7]="Front Bullbars Chrome";
		                    comp[8]=1116, compname[8]="Front Bullbars Slamin";
		                    comp[9]=1117, compname[9]="Front Bumper Chrome";
		                    comp[10]=1118, compname[10]="Sideskirt Right `Chrome Trim`";
		                    comp[11]=1119, compname[11]="Sideskirt Right `Wheelcovers`";
		                    comp[12]=1120, compname[12]="Sideskirt Left `Chrome Trim`";
		                    comp[13]=1121, compname[13]="Sideskirt Left `Wheelcovers`";
						}
		                case 536: // BLADE
		                {
		                    comp[1]=1103, compname[1]="Roof Covertible";
		                    comp[2]=1104, compname[2]="Exhaust Chrome";
		                    comp[3]=1105, compname[3]="Exhaust Slamin";
		                    comp[4]=1107, compname[4]="Sideskirt Left `Chrome Strip`";
		                    comp[5]=1108, compname[5]="Sideskirt Right `Chrome Strip`";
		                    comp[6]=1128, compname[6]="RoofVinyl Hardtop";
		                    comp[7]=1181, compname[7]="Front Bumper Slamin";
		                    comp[8]=1182, compname[8]="Front Bumper Chrome";
		                    comp[9]=1183, compname[9]="Rear Bumper Slamin";
		                    comp[10]=1184, compname[10]="Rear Bumper Chrome";
		                }
		                case 567: // SAVANNA
		                {
                            comp[1]=1102, compname[1]="Sideskirt Left `Chrome Strip`";
		                    comp[2]=1129, compname[2]="Exhaust Chrome";
		                    comp[3]=1130, compname[3]="Roof Hardtop";
		                    comp[4]=1131, compname[4]="Roof Softtop";
		                    comp[5]=1132, compname[5]="Exhaust Slamin";
		                    comp[6]=1133, compname[6]="Sideskirt Right `Chrome Strip`";
		                    comp[7]=1186, compname[7]="Rear Bumper Slamin";
		                    comp[8]=1187, compname[8]="Rear Bumper Chrome";
		                    comp[9]=1188, compname[9]="Front Bumper Slamin";
		                    comp[10]=1189, compname[10]="Front Bumper Chrome";
		                }
		                case 558: // URANUS
		                {
		                    comp[1]=1088, compname[1]="Roof Alien";
		                    comp[2]=1089, compname[2]="Exhaust X-Flow";
		                    comp[3]=1090, compname[3]="SideskirtRight Alien";
		                    comp[4]=1091, compname[4]="RoofX-Flow";
		                    comp[5]=1092, compname[5]="Exhaust Alien";
		                    comp[6]=1093, compname[6]="Sideskirt Left X-Flow";
		                    comp[7]=1094, compname[7]="Sideskirt Left Alien";
		                    comp[8]=1095, compname[8]="Sideskirt Right X-Flow";
		                    comp[9]=1163, compname[9]="SpoilerX-Flow";
		                    comp[10]=1164, compname[10]="Spoiler Alien";
		                    comp[11]=1165, compname[11]="Front Bumper X-Flow";
		                    comp[12]=1166, compname[12]="Front Bumper Alien";
		                    comp[13]=1167, compname[13]="Rear Bumper X-Flow";
		                    comp[14]=1168, compname[14]="Rear Bumper Alien";
		                }
		                case 559: // JESTER
		                {
		                    comp[1]=1065, compname[1]="Exhaust Alien";
		                    comp[2]=1066, compname[2]="Exhaust X-Flow";
		                    comp[3]=1067, compname[3]="Roof Alien";
		                    comp[4]=1068, compname[4]="Roof X-Flow";
		                    comp[5]=1069, compname[5]="Right Alien Sideskirt";
		                    comp[6]=1070, compname[6]="Right X-Flow Sideskirt";
		                    comp[7]=1071, compname[7]="Left Alien Sideskirt";
		                    comp[8]=1072, compname[8]="Left X-Flow Sideskirt";
		                    comp[9]=1158, compname[9]="SpoilerX-Flow";
		                    comp[10]=1159, compname[10]="Rear BumperAlien";
		                    comp[11]=1160, compname[11]="Front BumperAlien";
		                    comp[12]=1161, compname[12]="Rear BumperX-Flow";
		                    comp[13]=1162, compname[13]="Spoiler Alien";
		                    comp[14]=1173, compname[14]="Front BumperX-Flow";
		                }
		                case 560: // SULTAN
		                {
		                	comp[1]=1026, compname[1]="Sideskirt Right Alien";
		                    comp[2]=1027, compname[2]="Sideskirt Left Alien";
		                    comp[3]=1028, compname[3]="Exhaust Alien";
		                    comp[4]=1029, compname[4]="Exhaust X-Flow";
		                    comp[5]=1030, compname[5]="Sideskirt Left X-Flow";
		                    comp[6]=1031, compname[6]="Sideskirt Right X-Flow";
		                    comp[7]=1032, compname[7]="RoofAlien Roof Vent";
		                    comp[8]=1033, compname[8]="RoofX-Flow Roof Vent";
		                    comp[9]=1138, compname[9]="Spoiler Alien";
		                    comp[10]=1139, compname[10]="SpoilerX-Flow";
		                    comp[11]=1140, compname[11]="Rear BumperX-Flow";
		                    comp[12]=1141, compname[12]="Rear Bumper Alien";
		                    comp[13]=1169, compname[13]="Front Bumper Alien";
		                    comp[14]=1170, compname[14]="Front BumperX-Flow";
		                }
		                case 561: // stratum
		                {
		                    comp[1]=1055, compname[1]="Roof Alien";
		                    comp[2]=1056, compname[2]="SideskirtRight Alien";
		                    comp[3]=1057, compname[3]="SideskirtRight X-Flow";
		                    comp[4]=1058, compname[4]="Spoiler Alien";
		                    comp[5]=1059, compname[5]="ExhaustX-Flow";
		                    comp[6]=1060, compname[6]="SpoilerX-Flow";
		                    comp[7]=1061, compname[7]="RoofX-Flow";
		                    comp[8]=1062, compname[8]="SideskirtLeft Alien";
		                    comp[9]=1063, compname[9]="SideskirtLeft X-Flow";
		                    comp[10]=1064, compname[10]="Exhaust Alien";
		                    comp[11]=1154, compname[11]="Rear BumperAlien";
		                    comp[12]=1155, compname[12]="Front BumperAlien";
		                    comp[13]=1156, compname[13]="Rear BumperX-Flow";
		                    comp[14]=1157, compname[14]="Front BumperX-Flow";
		                }
		                case 562: // elegy
		                {
		                    comp[1]=1034, compname[1]="Exhaust Alien";
		                    comp[2]=1035, compname[2]="RoofX-Flow Roof Vent";
		                    comp[3]=1036, compname[3]="SideSkirt Right Alien";
		                    comp[4]=1037, compname[4]="ExhaustX-Flow";
		                    comp[5]=1038, compname[5]="RoofAlien Roof Vent";
		                    comp[6]=1039, compname[6]="SideSkirtLeft X-Flow";
		                    comp[7]=1040, compname[7]="SideSkirtLeft Alien";
		                    comp[8]=1041, compname[8]="SideSkirtRight X-Flow";
		                    comp[9]=1146, compname[9]="SpoilerX-Flow";
		                    comp[10]=1147, compname[10]="Spoiler Alien";
		                    comp[11]=1148, compname[11]="Rear BumperX-Flow";
		                    comp[12]=1149, compname[12]="Rear BumperAlien";
		                    comp[13]=1171, compname[13]="Front BumperAlien";
		                    comp[14]=1172, compname[14]="Front BumperX-Flow";
		                }
		                case 565: // flash
		                {
		                    comp[1]=1045, compname[1]="ExhaustX-Flow";
		                    comp[2]=1046, compname[2]="Exhaust Alien";
		                    comp[3]=1047, compname[3]="SideSkirtRight Alien";
		                    comp[4]=1048, compname[4]="SideSkirtRight X-Flow";
		                    comp[5]=1049, compname[5]="Spoiler Alien";
		                    comp[6]=1050, compname[6]="Spoiler X-Flow";
		                    comp[7]=1051, compname[7]="SideSkirtLeft Alien";
		                    comp[8]=1052, compname[8]="SideSkirtLeft X-Flow";
		                    comp[9]=1053, compname[9]="RoofX-Flow";
		                    comp[10]=1054, compname[10]="Roof Alien";
		                    comp[11]=1150, compname[11]="Bumper Alien";
		                    comp[12]=1151, compname[12]="BumperX-Flow";
		                    comp[13]=1152, compname[13]="BumperX-Flow";
		                    comp[14]=1153, compname[14]="Bumper Alien";
		                }
		                case 575: // broadway
		                {
		                    comp[1]=1042, compname[1]="SideSkirt Right Chrome";
		                    comp[2]=1043, compname[2]="Exhaust Slamin";
		                    comp[3]=1044, compname[3]="Exhaust Chrome";
		                    comp[4]=1099, compname[4]="SideskirtLeft Chrome";
		                    comp[5]=1174, compname[5]="Front Bumper Chrome";
		                    comp[6]=1175, compname[6]="Rear Bumper Slamin";
		                    comp[7]=1176, compname[7]="Front Bumper Chrome";
		                    comp[8]=1177, compname[8]="Rear Bumper Slamin";
		                }
		                case 576: // tornado
		                {
		                    comp[1]=1134, compname[1]="SideSkirt Right `Chrome Strip`";
		                    comp[2]=1135, compname[2]="Exhaust Slamin";
		                    comp[3]=1136, compname[3]="Exhaust Chrome";
		                    comp[4]=1137, compname[4]="SideskirtLeft `Chrome Strip`";
		                    comp[5]=1190, compname[5]="Front Bumper Slamin";
		                    comp[6]=1191, compname[6]="Front Bumper Chrome";
		                    comp[7]=1192, compname[7]="Rear Bumper Chrome";
		                    comp[8]=1193, compname[8]="Rear Bumper Slamin";
		                }
		            }
		            for(new i = 0; i < 20; i++)
			        {
			            if(comp[i] != 0) format(result, 2000, "%s\n%s", result, compname[i]);
			        }
			        ShowPlayerDialog(playerid,25,DIALOG_STYLE_LIST,"Body Modifications",result,"Select", "Back");
		        }
		        case 5: // REMOVE MODS
		        {
	                new key = GetPVarInt(playerid, "VEHMODKEY"),
						found,
						query[300];
						
	                for(new i = 1; i < 10; i++) {
						if(VehicleInfo[key][vMod][i] >= 1000 && VehicleInfo[key][vMod][i] <= 1193) {
							RemoveVehicleComponent(GetPlayerVehicleID(playerid), VehicleInfo[key][vMod][i]);
							found++;
							VehicleInfo[key][vMod][i]=0;
						}
                    }
                    
	                format(string, 128, "%d components removed!", found);
	                SCM(playerid, COLOR_WHITE, string);
	                PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    mysql_format(handlesql, query, sizeof(query), "UPDATE `vehicles` SET `Mod1` = %i, `Mod2` = %i, `Mod3` = %i, `Mod4` = %i, `Mod5` = %i, `Mod6` = %i, `Mod7` = %i, \
																						 `Mod8` = %i, `Mod9` = %i, `Mod10` = %i, `Mod11` = %i WHERE `ID` = %i;",
                                 VehicleInfo[key][vMod][0], VehicleInfo[key][vMod][1], VehicleInfo[key][vMod][2], VehicleInfo[key][vMod][3], VehicleInfo[key][vMod][4], VehicleInfo[key][vMod][5],
                                 VehicleInfo[key][vMod][6], VehicleInfo[key][vMod][7], VehicleInfo[key][vMod][8], VehicleInfo[key][vMod][9], VehicleInfo[key][vMod][10], VehicleInfo[key][vID]);
					mysql_tquery(handlesql, query);
                    SetPVarInt(playerid, "VEHSEC", 0);
		            CallRemoteFunction("VehMod", "i", playerid);
		        }
		    }
		}
    }
	return true;
}
//============================================//
public OnVehicleStreamIn(vehicleid, forplayerid)
{
	if(GetPVarInt(forplayerid, "AdminDuty") == 1) return SetVehicleParamsForPlayer(vehicleid, forplayerid, 0, 0);
	switch(VehicleInfo[vehicleid][vType]) {
	    case VEHICLE_DMV: {
	        SetVehicleParamsForPlayer(vehicleid, forplayerid, 0, 1);
	    }
	    case VEHICLE_PERSONAL: {
	        if(GetVehicleVirtualWorld(vehicleid) == 0) {
			    switch(VehicleInfo[vehicleid][vLock]) {
			        case 0: SetVehicleParamsForPlayer(vehicleid,forplayerid, 0, 0);
			        case 1: SetVehicleParamsForPlayer(vehicleid,forplayerid, 0, 1);
			    }
			} else {
			    SetVehicleParamsForPlayer(vehicleid,forplayerid, 0, 0);
			}
	    }
	    default: {
	        switch(VehicleInfo[vehicleid][vLock]) {
	            case 0: SetVehicleParamsForPlayer(vehicleid,forplayerid, 0, 0);
			    case 1: SetVehicleParamsForPlayer(vehicleid,forplayerid, 0, 1);
	        }
	    }
	}
	return 1;
}
//============================================//
public OnVehicleSpawn(vehicleid)
{
	if(IsNotAEngineCar(vehicleid)) {
		new engine, lights, alarm, doors, bonnet, boot, objective;
    	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    	SetVehicleParamsEx(vehicleid, 1, lights, alarm, doors, bonnet, boot, objective);
	}

    if(VehicleInfo[vehicleid][vID] != 0)
    {
		if(VehicleInfo[vehicleid][vCreated] == 1)
		{
		    if(VehicleInfo[vehicleid][vInterior] == 0 && VehicleInfo[vehicleid][vWorld] == 0)
		    {
                DespawnVehicle(vehicleid);
        	}
        	else
        	{
                LinkVehicleToInteriorEx(vehicleid, VehicleInfo[vehicleid][vInterior]);
                SetVehicleVirtualWorld(vehicleid, VehicleInfo[vehicleid][vWorld]);
                VehicleInfo[vehicleid][vEngine] = 0;
        	    VehicleInfo[vehicleid][vWindows] = 0;
        	    VehicleInfo[vehicleid][vAlarm] = 0;
        	}
        }
        return true;
    }

    for(new i = 0; i < MAX_VEHICLE_SIREN_OBJECTS; i++)
    {
    	if(VehicleInfo[vehicleid][vSirenObjectID][i] != 0)
    	{
    		DestroyDynamicObject(VehicleInfo[vehicleid][vSirenObjectID][i]);
  			VehicleInfo[vehicleid][vSirenObjectID][i] = 0;
    	}
    }
	return 1;
}
//============================================//
public OnVehicleDeath(vehicleid, killerid)
{
	if(IsEnterableVehicle(vehicleid) != -1) {
		foreach(new i : Player) {
			if(PlayerInfo[i][pInVehicle] == vehicleid) {
				ExitVehicleInterior(i);
			}
		}
	}
	new Float:x,Float:y,Float:z;
	GetVehiclePos(vehicleid,x,y,z);
	switch(VehicleInfo[vehicleid][vType])
	{
	    case VEHICLE_PERSONAL:
		{
		    if(VehicleInfo[vehicleid][vID] != 0 && !IsNotAEngineCar(vehicleid))
    	    {
    	        if(VehicleInfo[vehicleid][vInterior] == 0 && VehicleInfo[vehicleid][vWorld] == 0)
		        {
        	        CreateExplosion(x,y,z, 1, 1.0);
        	        VehicleInfo[vehicleid][vHealth] = 290.0;
					VehicleInfo[vehicleid][vAlarm] = 0;
					SaveVehicleData(vehicleid, 0);
					DespawnVehicle(vehicleid);
        	    }
        	    else
        	    {
        	        VehicleInfo[vehicleid][vHealth] = 290.0;
        	        VehicleInfo[vehicleid][vFuel] = VehicleInfo[vehicleid][vFuel];
        	        VehicleInfo[vehicleid][vEngine] = 0;
        	        VehicleInfo[vehicleid][vWindows] = 0;
					VehicleInfo[vehicleid][vAlarm] = 0;
					SaveVehicleData(vehicleid, 0);
					SetVehicleToRespawn(vehicleid);
        	    }
    	    }
		}
	}
	return 1;
}
//============================================//
public OnVehicleDamageStatusUpdate(vehicleid, playerid)
{
    new panels, doors, lights, tires, Float:speed = GetPlayerSpeed(playerid, true);
    foreach(new i : Player)
    {
        if(IsPlayerConnected(i) && GetPlayerVehicleID(i) == vehicleid)
        {
            GetVehicleDamageStatus(GetPlayerVehicleID(playerid),panels,doors,lights,tires);
            if(VehicleInfo[GetPlayerVehicleID(playerid)][Panel] != panels || VehicleInfo[GetPlayerVehicleID(playerid)][Doors] != doors)
            {
                VehicleInfo[GetPlayerVehicleID(playerid)][Panel] = panels; VehicleInfo[GetPlayerVehicleID(playerid)][Doors] = doors;
				if(speed >= 60.0)
				{
				    new Float:health;
					GetPlayerHealth(i,health);
					switch(GetPVarInt(i, "Seatbelt"))
					{
					    case 0:
					    {
					        SetPlayerHealth(i,health-20.0);
					    }
					    case 1:
					    {
					        SetPlayerHealth(i,health-1.0);
					    }
					}
            	}
            }
        }
    }
	return true;
}
//============================================//