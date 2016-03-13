//============================================//
//=====[ TIMER USAGE SECTION ]=====//
//============================================//
forward TenMinTimer();
public TenMinTimer() {
	new string[128], Float:health;
	foreach(new i : Player)
	{
	    if(GetPVarInt(i, "PlayerLogged") == 1)
	    {
	        if(GetPVarInt(i, "DrugTime") == 0)
	        {
	            if(GetPVarInt(i, "Addiction") > 0 && GetPVarInt(i, "AFKTime") < 600)
	            {
	                SetPVarInt(i, "Addiction", GetPVarInt(i, "Addiction")-1);
	                format(string, 128, "You are experiencing withdrawal symptoms from '%s'!", PrintIName(GetPVarInt(i, "AddictionID")));
	                SCM(i, COLOR_LIGHTRED, string);
	                GetPlayerHealth(i, health);
	                if(health > 16)
	                {
	                	SetPlayerHealth(i, health-15.0);
					}
					else
					{
					    SetPlayerHealth(i, 1.0);
	    				SetPVarInt(i, "Cuffed", 1);
    	    			SetPVarInt(i, "CuffedTime", 120);
    	    			ApplyAnimation(i, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 0, 0);
					}
		    		if(GetPVarInt(i, "Addiction") == 0)
					{
					    format(string, 128, "Your addiction from '%s' is clean!", PrintIName(GetPVarInt(i, "AddictionID")));
	                    SCM(i, COLOR_LIGHTRED, string);
					    SetPVarInt(i, "Addiction", 0);
					    SetPVarInt(i, "AddictionID", 0);
					}
	            }
	        }
	    }
	}
	SpawnMatTrailers();
	SpawnTheftCars();
	if(GetTickCount() > 2075000000) {
		SendAdminMessage(COLOR_RED, "[WARNING] {FFFFFF}The host-computer needs to be restarted as 'GetTickCount()' is nearly out of bounds.");
		SendAdminMessage(COLOR_ORANGE, "[NOTICE] {FFFFFF}Servers can only run for 24 days before 'GetTickCount()' exceeds the integer limit of Pawn.");
		print("GetTickCount() is nearly out of bounds, restart the host-computer ASAP.");
	}
	return true;
}
//============================================//
new iter =0;
public OneSecondTimer()
{
	GMTime();
	iter++;
	if(iter > 3) {
		iter = 0;
		VJB = 0;
	}
	new string[128], Float:x, Float:y, Float:z, sendername[MAX_PLAYER_NAME], Float:distance;
	if(CountDown > 0)
	{
	    CountDown--;
	    format(string, sizeof(string),"~b~%d",CountDown);
	    GameTextForAll(string, 3000, 5);
	}
	new ip[64];
	for(new i=0; i < MAX_PLAYERS; i++)
	{
	    if(IsPlayerNPC(i))
	    {
	        GetPlayerIp(i, ip, sizeof(ip));
	        if(!strmatch(ip, CFG_IP)) {
				BanEx(i, "NPC Duplicate");
				print("Player was banned for duplicating a NPC.");
			}
	    }
	}
    foreach(new i : Player)
	{
		switch(GetPVarInt(i, "PlayerLogged"))
		{
		    case 0:
		    {
		        SetPVarInt(i, "LoginTime", GetPVarInt(i, "LoginTime")+1);
		        SetPVarInt(i, "CamTime", GetPVarInt(i, "CamTime")+1);
		        if(GetPVarInt(i, "CamTime") >= 60)
		        {
		            SetPVarInt(i, "CamTime", 0);
		            CallRemoteFunction("LoginCamera","i", i);
		        }
		        switch(GetPVarInt(i, "LoginTime"))
		        {
		            case 320:
		            {
						if(GetPVarInt(i, "AppWait") != 1 && GetPVarInt(i, "InRegQuiz") != 1) {
							KickPlayer(i, "You have been kicked for not logging in over (5) minutes.");
						}
		            }
		        }
		    }
		    case 1:
		    {
				if(PlayerInfo[i][pBalling] == 1) CheckInCourt(i);
				// Anti CJ skin.
				if(GetPlayerSkin(i) == 0) SetPlayerSkin(i, 1);
				// Anti Jet-Pack Hack.
				if(GetPlayerSpecialAction(i)==SPECIAL_ACTION_USEJETPACK&&GetPVarInt(i, "Admin")==0&&GetPVarInt(i, "PlayTime")>=15)
				{
					if(GetPVarInt(i, "BeingBanned") == 0)
					{
						format(string, sizeof(string), "AdmCmd: %s was banned by Anticheat Reason:[Jetpack Hack].", PlayerName(i));
						SendClientMessageToAll(COLOR_LIGHTRED, string);
						BanPlayer(i, "Jetpack Hack", "Anticheat");
					}
					continue;
				}
				new keys, updown, leftright;
				GetPlayerKeys(i, keys, updown, leftright);
				// Anti-Interior fall script //
				if(GetPVarInt(i, "IntEnter") != 0 && IntInfo[GetPVarInt(i, "IntEnter")][iFreeze] == 1) {
					if(GetPlayerInterior(i) == IntInfo[GetPVarInt(i, "IntEnter")][iInt] && GetPlayerVirtualWorld(i) == IntInfo[GetPVarInt(i, "IntEnter")][iWorld]) {
						if(IsPlayerFalling(i)) {
							SetPlayerPosEx(i, IntInfo[GetPVarInt(i, "IntEnter")][ixX], IntInfo[GetPVarInt(i, "IntEnter")][ixY], IntInfo[GetPVarInt(i, "IntEnter")][ixZ]+0.5);
							Streamer_Update(i);
						}
					}
				}
				// Anti-Running system with handcuffs.
				if(GetPlayerSpecialAction(i) == SPECIAL_ACTION_CUFFED && GetPlayerState(i) == PLAYER_STATE_ONFOOT && GetPVarInt(i, "Control") == 0 && GetPlayerSpeed(i, false) >= 7.0) {
					ClearAnimations(i);
					ApplyAnimation(i, "ped", "FLOOR_hit_f", 4.0, 0, 1, 1, 1, -1);
					SetTimerEx("PlayerGetup", 5000, false, "i", i);
					return 0;
				}
				// Fire Script //
				if(IsAroundFire(i, 1, 2.5) && GetPlayerState(i) == PLAYER_STATE_ONFOOT) {
					new Float:health;
					GetPlayerHealth(i, health);
					if(GetPVarInt(i, "Dead") == 0 && GetPVarInt(i, "Control") == 0 && GetPVarInt(i, "FDDUTY") == 0) SetPlayerHealth(i, health-0.1);
					else
					{
						new id = IsAroundFire(i,2,2.5);
						if(GetPVarInt(i, "FDDUTY") == 1)
						{
							if(keys & KEY_FIRE && GetPlayerWeapon(i) == 42 && IsPlayerAimObjectID(i, FDInfo[id][fObject]))
							{
								FDInfo[id][fHealth]--;
								if(FDInfo[id][fHealth] == 0)
								{
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
						}
					}
				}				
		    	// LSPD SCUBA GEAR //
				if(GetPVarInt(i, "FDDUTY") == 1 && GetPVarInt(i, "SubaGear") == 1 && PlayerInWater(i)) { SetPlayerHealth(i, 99.0); }
				SetPVarInt(i, "Delay", GetPVarInt(i, "Delay") - 1000); // Command delay

				if(PlayerInfo[i][pCmdSpam] > 0) PlayerInfo[i][pCmdSpam]--;
				if(PlayerInfo[i][pCmdTime] > 0)
				{
					PlayerInfo[i][pCmdTime]--;

				    if(PlayerInfo[i][pCmdTime] < 1)
				    {
						PlayerInfo[i][pCmdTime] = 0;
						PlayerInfo[i][pCmdSpam] = 0;
				        SetPVarInt(i, "Mute", 0);
				        SendClientMessage(i, COLOR_LIGHTRED, "You are no longer muted.");
				    }
				}
				if(GetPVarInt(i, "RammingHouse") != -1)
				{
				    if(GetPVarInt(i, "RammingTime") > 0)
				    {
				        SetPVarInt(i, "RammingTime", GetPVarInt(i, "RammingTime") - 1);
	        	  		format(string, sizeof(string),"~b~%d",GetPVarInt(i, "RammingTime"));
	    				GameTextForPlayer(i,string, 1000, 5);
				    }
                    if(GetPVarInt(i, "RammingTime") == 0)
					{
						new chance = random(50);
						if(GetPVarInt(i, "Duty") == 1)
						{
							if(chance > 20) //succeed
							{
		    					PlayerPlaySound(i, 1145, 0.0, 0.0, 0.0);
						 		GameTextForPlayer(i, "~w~House~n~~g~Unlocked", 4000, 3);
						 		HouseInfo[GetPVarInt(i, "RammingHouse")][hLocked] = 0;
							}
							else //Failure
							{
							    GameTextForPlayer(i, "~r~Failed!", 4000, 3);
							}
						}
						SetPVarInt(i, "RammingHouse", -1);
					}
				}
				if(GetPVarInt(i, "Mobile") != INVALID_MAXPL)
				{
				    SetPVarInt(i, "OnPhone", GetPVarInt(i, "OnPhone") + 1);
				}
				else
				{
				    SetPVarInt(i, "OnPhone", 0);
				}
		        if(IsPlayerInAnyVehicle(i) && !IsNotAEngineCar(GetPlayerVehicleID(i)))
	            {
	                for(new h = 0; h < sizeof(GasStations); h++)
	                {
	                    if(IsPlayerInRangeOfPoint(i,6.0,GasStations[h][0], GasStations[h][1], GasStations[h][2]))
	                    {
		    		        GameTextForPlayer(i, "~b~Gas Station~n~~w~(/fill)", 1000, 5);
	                    }
                    }
                    // TAXI FARE SCRIPT //
                    new driver = GetPVarInt(i, "TaxiBoss");
                    new vehicleid = GetPlayerVehicleID(i);
                    if(GetPlayerState(i) == PLAYER_STATE_PASSENGER)
                    {
                        if(VehicleInfo[vehicleid][vType] == VEHICLE_JOB)
                        {
                            if(GetPVarInt(i, "TaxiAM") > 0)
                            {
                                if(IsPlayerConnected(driver))
                                {
                                    if(vehicleid == GetPlayerVehicleID(driver))
                                    {
                                        if(GetPVarInt(driver, "OnRoute") != 0 && GetPVarInt(driver, "Job") == 5)
                                        {
											if(GetPlayerMoneyEx(i) >= GetPVarInt(i, "TaxiAm"))
											{
											    //SCM(playerid, -1, "DEBUG 6");
												if(GetPVarInt(i, "TaxiStep") <= 9) { format(string, 128, "~r~Taxifare:~n~rate: ~g~$%d~n~~b~0%d ~w~| ~g~$%d", GetPVarInt(i, "TaxiCost"), GetPVarInt(i, "TaxiStep"), GetPVarInt(i, "TaxiAm")); }
												if(GetPVarInt(i, "TaxiStep") >= 10) { format(string, 128, "~r~Taxifare~n~rate: ~g~$%d~n~~b~%d ~w~| ~g~$%d", GetPVarInt(i, "TaxiCost"), GetPVarInt(i, "TaxiStep"), GetPVarInt(i, "TaxiAm")); }
												GameTextForPlayer(i, string, 1000, 5);
												//==========//
                                                SetPVarInt(i, "TaxiStep", GetPVarInt(i, "TaxiStep")+1);
                                                if(GetPVarInt(i, "TaxiStep") >= 10)
                                                {
                                                    SetPVarInt(i, "TaxiStep", 0);
                                                    SetPVarInt(i, "TaxiAm", GetPVarInt(i, "TaxiAm")+GetPVarInt(i, "TaxiCost"));
                                                }
                                                //==========//
                                            }
                                            else
                                            {
                                                TaxiPayment(i);
                                                RemovePlayerFromVehicle(i);
                                            }
                                        }
                                        else
                                        {
                                            DeletePVar(i, "TaxiBoss"), DeletePVar(i, "TaxiCost");
	                                        DeletePVar(i, "TaxiStep"), DeletePVar(i, "TaxiAm");
                                        }
                                    }
                                    else
                                    {
                                        DeletePVar(i, "TaxiBoss"), DeletePVar(i, "TaxiCost");
	                                    DeletePVar(i, "TaxiStep"), DeletePVar(i, "TaxiAm");
                                    }
                                }
                                else
                                {
                                    DeletePVar(i, "TaxiBoss"), DeletePVar(i, "TaxiCost");
	                                DeletePVar(i, "TaxiStep"), DeletePVar(i, "TaxiAm");
                                }
                            }
                        }
                    }					
	            }				
				/*if(GetPVarInt(i, "PlayerLogged") != 0 && PlayerInfo[i][pAHSkip] != 1) {
					new Float:armour, acount = GetAdminCount(2);
					GetPlayerArmour(i, armour);
					if(armour != 0.0) {
						if(armour > PlayerInfo[i][pArmour]) {			
							if(GetPVarInt(i, "Admin") == 0 && GetPVarInt(i, "Member") != 1 && GetPVarInt(i, "Member") != 8) {
								format(string, sizeof(string), "AdmWrn: %s possibly hacked (%f) armour.", PlayerName(i), armour - PlayerInfo[i][pArmour]);
								SendAdminMessage(COLOR_YELLOW,string);
								if(acount == 0) { SetPlayerArmourEx(i, 0.0); }
							}
							if(acount > 0) PlayerInfo[i][pArmour] = armour;
						}
					}
				}*/
		        ////////////////////////
		        // ANTI TELEPORT HACK //
		        ////////////////////////
		        distance = GetPlayerDistanceFromPoint(i, PlayerInfo[i][pPos][0], PlayerInfo[i][pPos][1], PlayerInfo[i][pPos][2]);
		        if(distance >= 500.0)
		        {
		            if(GetPVarInt(i, "Admin") == 0)
		            {
		                if(GetPVarInt(i, "TPHackWarn") == 0)
		                {
		                    if(GetPlayerPing(i) <= 200 && !IsPlayerFalling(i) && IsPlayerInAnyVehicle(i))
		                    {
		                        SetPVarInt(i, "TPHackWarn", 1);
		                        /*format(string, sizeof(string), "AdmWrn: %s is possibly teleport hacking.", PlayerName(i));
					            SendAdminMessage(COLOR_YELLOW,string);*/
					            //if(acount == 0) { KickPlayer(i, "You have been kicked for supposedly teleport hacking."); }
					        }
					        if(GetPVarInt(i, "PizzaTimeEx") >= 20 && IsPlayerInAnyVehicle(i)) { KickPlayer(i, "You have been kicked for supposedly teleport hacking."); }
					    }
		            }
		        }
		        GetPlayerPos(i, x, y, z);
		        PlayerInfo[i][pPos][0]=x;
                PlayerInfo[i][pPos][1]=y;
                PlayerInfo[i][pPos][2]=z;
		        ////////////////////////
	            if(GetPVarInt(i, "JobReduce") > 0)
				{
				    SetPVarInt(i, "JobReduce", GetPVarInt(i, "JobReduce")-1);
				    if(GetPVarInt(i, "JobReduce") == 0) { SCM(i, COLOR_LIGHTBLUE, "Timer expired, you may now continue your job route!"); }
				}
	    	    if(GetPVarInt(i, "PlayerBlood") > 0)
	    	    {
	    	        SetPVarInt(i, "PlayerBlood", GetPVarInt(i, "PlayerBlood")-1);
	    	        if(GetPVarInt(i, "PlayerBlood") == 0)
					{
					    TextDrawHideForPlayer(i,BloodDraw[0]);
						TextDrawHideForPlayer(i,BloodDraw[1]);
						TextDrawHideForPlayer(i,BloodDraw[2]);
					    DeletePVar(i,"PlayerBlood");
					}
	    	    }
	    	    if(GetPVarInt(i, "CuffedTime") > 0)
				{
		    		SetPVarInt(i, "CuffedTime", GetPVarInt(i, "CuffedTime")-1);
		    		if(GetPVarInt(i, "CuffedTime") == 0)
					{
					    SetPVarInt(i, "Cuffed", 0);
					    TogglePlayerControllableEx(i,true);
					}
				}
				if(GetPVarInt(i, "Drag") != INVALID_MAXPL)
				{
		    		SetPlayerVirtualWorld(i,GetPlayerVirtualWorld(GetPVarInt(i, "Drag")));
		    		SetPlayerInterior(i,GetPlayerInterior(GetPVarInt(i, "Drag")));
		    		GetPlayerPos(GetPVarInt(i, "Drag"),x,y,z);
		    		SetPlayerPosEx(i,x+1,y,z);
		    		SetCameraBehindPlayer(i);
		    		if(GetPVarInt(GetPVarInt(i, "Drag"), "Member") == 4) { ApplyAnimation(i, "INT_HOUSE","BED_Loop_R", 4.0,1,1,1,1,1); }
				}
	    	    if(GetPVarInt(i, "HitMark") > 0)
				{
				    SetPVarInt(i, "HitMark", GetPVarInt(i, "HitMark")-1);
				    if(GetPVarInt(i, "HitMark") == 0)
				    {
				        TextDrawHideForPlayer(i,HitMark);
				    }
				}
	    	    if(GetPVarInt(i, "LableDraw") > 0)
				{
				    SetPVarInt(i, "LableDraw", GetPVarInt(i, "LableDraw")-1);
				    if(GetPVarInt(i, "LableDraw") == 0)
				    {
				        TextDrawDestroy(LableDraw[i]);
						TextDrawDestroy(UsedDraw[i]);
                        DeletePVar(i,"LableDraw");
				    }
				}
				if(GetPVarInt(i, "OnRoute") != 0)
				{
				    if(GetPVarInt(i, "RouteOT") > 0)
				    {
						if(GetPlayerState(i) != PLAYER_STATE_DRIVER)
						{
				            SetPVarInt(i, "RouteOT", GetPVarInt(i, "RouteOT")-1);
				            format(string, sizeof(string), "~n~~n~~w~you have ~r~%d ~w~seconds to get back in your ~y~vehicle ~w~!", GetPVarInt(i, "RouteOT"));
				            GameTextForPlayer(i, string, 1000, 4);
				            if(GetPVarInt(i, "RouteOT") == 0)
				            {
				                DeletePVar(i, "OnRoute");
	                            if(GetPVarInt(i, "RouteVeh") >= 1) { DespawnVehicle(GetPVarInt(i, "RouteVeh")); }
	                            DeletePVar(i, "RouteVeh");
	                            DeletePVar(i, "PizzaTime");
	                            SendClientMessage(i, COLOR_WHITE, "Your job route has end, for abandoning your vehicle!");
	                            DisablePlayerCheckpoint(i);
	                            TogglePlayerAllDynamicCPs(i, true);
				                DeletePVar(i, "RouteOT");
				            }
				        }
				    }
				}
				if(GetPVarInt(i, "Dead") == 3)
        		{
        		    SetPVarInt(i, "DT", GetPVarInt(i, "DT")+1);
					SetPlayerDrunkLevel(i, 8000);
					if(GetPVarInt(i, "DT") >= 30)
					{
					    SetPlayerDrunkLevel(i, 1000);
					    AfterSpawnHos(i);
					    SetPVarInt(i, "DT", 0);
					}
        		}
				if(GetPVarInt(i, "PizzaTime") >= 1 && GetPVarInt(i, "OnRoute") == 2 && GetPVarInt(i, "Job") == 4)
	            {
	                SetPVarInt(i, "PizzaTimeEx", GetPVarInt(i, "PizzaTimeEx")+1);
	        	    SetPVarInt(i, "PizzaTime", GetPVarInt(i, "PizzaTime")-1);
				    format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~w~%s",PrintTime(GetPVarInt(i, "PizzaTime"),5));
		    		GameTextForPlayer(i, string, 1000, 5);
		    		new v = GetPlayerVehicleID(i);
		    		new Float:vh;
					GetVehicleHealth(v, vh);
					if(vh < 950)
					{
			    	    SendClientMessage(i, COLOR_LIGHTRED, "FAILED: The food got messed up because of your reckless driving!");
			    	    SetPVarInt(i, "OnRoute", 1);
			    	    SetPlayerCheckpoint(i, 2111.6963, -1788.6849, 13.5608, 2.0);
						SetVehicleHealth(v, 1000.0);
					}
				    if(GetPVarInt(i, "PizzaTime") == 0)
				    {
			    	    SendClientMessage(i, COLOR_LIGHTRED, "FAILED: The pizza was too cold!");
			    	    SetPVarInt(i, "OnRoute", 1);
			    	    SetPlayerCheckpoint(i, 2111.6963, -1788.6849, 13.5608, 2.0);
				    }
	    	    }
        		if(GetPVarInt(i, "Jailed") > 0)
				{
		    		if(GetPVarInt(i, "JailTime") > 0)
		    		{
		    		    if(GetPVarInt(i, "JailTime") == 2 && GetPVarInt(i, "PayDay") >= 1) { DeletePVar(i, "PayDay"); }
		        		SetPVarInt(i, "JailTime", GetPVarInt(i, "JailTime")-1);
		    		}
		    		if(GetPVarInt(i, "JailTime") == 0)
		    		{
		        		SetPlayerPosEx(i, 2112.8062, -2102.2251, 13.7469);
		        		SetPlayerInterior(i, 0);
		        		SendClientMessage(i, COLOR_WHITE,"You have paid your debt to society.");
                		GameTextForPlayer(i, "~g~Freedom~n~~w~Try to be a better citizen", 5000, 1);
		        		TogglePlayerControllable(i,true);
	            		SetPlayerVirtualWorld(i,0);
	            		SetPVarInt(i, "Jailed", 0);
	            		SetPVarInt(i, "Mute", 0);
	            		SetPVarInt(i, "Bail", 0);
						SetPVarInt(i, "Cuffed", 0);
						SetPVarInt(i, "CuffedTime", 0);
						SetPlayerSpecialAction(i,SPECIAL_ACTION_NONE);
						RemovePlayerAttachedObject(i, 7);
	        		}
				}
        		if(GetPVarInt(i, "TakeTest") >= 2)
				{
					new Float:speed = GetPlayerSpeed(i, true);
					if(GetPVarFloat(i,"TestSpeed") < speed) { SetPVarFloat(i,"TestSpeed",speed); }
		    		format(string, sizeof(string), "~n~~n~~n~~n~~n~~n~~n~~w~%s",PrintTime(GetPVarInt(i, "TestTime"),20));
		    		GameTextForPlayer(i, string, 1000, 5);
		    		SetPVarInt(i, "TestTime", GetPVarInt(i, "TestTime")+1);
				}
				if(GetPVarInt(i, "RingTone") > 0)
				{
					switch(GetPVarInt(i, "RingTone"))
					{
			    		case 1:
			    		{
                    		format(sendername, sizeof(sendername), "%s", PlayerNameEx(i));
                    		GiveNameSpace(sendername);
			        		format(string, sizeof(string), "*** Phone rings (( %s ))", sendername);
			        		ProxDetector(30.0, i, string, COLOR_PURPLE);
			        		SetPVarInt(i, "RingTone", 2);
			        		PlayAudioStreamForPlayerEx(i,"http://k007.kiwi6.com/hotlink/j64yveyp1r/ring.mp3");
			    		}
			    		case 2: { SetPVarInt(i, "RingTone", 3); }
			    		case 3: { SetPVarInt(i, "RingTone", 4); }
			    		case 4: { SetPVarInt(i, "RingTone", 5); }
			    		case 5: { SetPVarInt(i, "RingTone", 1); }
					}
				}
				if(GetPVarInt(i, "RingPhone") > 0)
				{
					switch(GetPVarInt(i, "RingPhone"))
					{
			    		case 1:
			    		{
			        		SetPVarInt(i, "RingPhone", 2);
			        		PlayAudioStreamForPlayerEx(i,"http://k007.kiwi6.com/hotlink/gnmhctmzbt/dial-tone.mp3");
			    		}
			    		case 2: { SetPVarInt(i, "RingPhone", 3); }
			    		case 3: { SetPVarInt(i, "RingPhone", 4); }
			    		case 4: { SetPVarInt(i, "RingPhone", 5); }
			    		case 5: { SetPVarInt(i, "RingPhone", 1); }
					}
				}
				if(GetPVarInt(i, "TagUse") > 0)
				{
				    SetPlayerChatBubble(i, PlayerInfo[i][pTagMsg], COLOR_WHITE, 10.0, 1000);
				}
				if(GetPVarInt(i, "DrugTime") > 0)
				{
		    		SetPVarInt(i, "DrugTime", GetPVarInt(i, "DrugTime")-1);
		    		switch(GetPVarInt(i, "DrugHigh"))
		    		{
		    		    case 500, 501: { SetPlayerDrunkLevel(i,6000); }
		    		    case 502, 503: { SetPlayerDrunkLevel(i,10000); }
		    		    case 504, 505:
						{
		    		        SetPlayerDrunkLevel(i,10000);
		    		        SetPlayerTime(i, 15, 0);
					        SetPlayerWeather(i, -66);
		    		    }
		    		    case 506: { SetPlayerDrunkLevel(i,6000); }
		    		    case 507:
						{
		    		        SetPlayerDrunkLevel(i,10000);
		    		        SetPlayerTime(i, 15, 0);
					        SetPlayerWeather(i, -66);
		    		    }
		    		}
            		if(GetPVarInt(i, "DrugTime") == 0)
					{
					    SetPlayerDrunkLevel(i,0);
					    GameTextForPlayer(i, "~w~Drug Effect~n~~p~Gone", 4000, 1);
						if(GetPVarInt(i, "HouseEnter") != 0 || GetPVarInt(i, "BizzEnter") != 0 || GetPVarInt(i, "IntEnter") != 0) {
							SetPlayerWeather(i, 11);
						} else SetPlayerWeather(i, GMWeather);
					    SetPlayerTime(i, GMHour, GMMin);
					    DeletePVar(i,"DrugHigh");
					    SetPVarInt(i, "Hunger", 3);
					}
				}
	    	    if(GetPlayerState(i) != PLAYER_STATE_SPECTATING)
				{
				    SetPVarInt(i, "PlayTime", GetPVarInt(i, "PlayTime")+1);
					if(GetPVarInt(i, "PlayTime") >= 60 && GetPVarInt(i, "Crash") > 0) { SetPVarInt(i, "Crash", 0); }
				    if(GetPVarInt(i, "PlayTime") >= 120 && GetPVarInt(i, "Crashes") > 0) { SetPVarInt(i, "Crashes", 0); }
				}
				if(GetPVarInt(i, "AFKTime") < 10)
				{
					SetPVarInt(i, "AFKTime", GetPVarInt(i, "AFKTime")+1);
					if(GetPVarInt(i, "AFKTime") == 2) { ClearAnimations(i); }
				}
                else
                {
                    SetPVarInt(i, "AFKTime", GetPVarInt(i, "AFKTime")+1);
					new afkTime = GetPVarInt(i, "AFKTime");
					format(string, sizeof(string),"AFK - %d Seconds", afkTime);
                    SetPlayerChatBubble(i, string, COLOR_WHITE, 10.0, 2000);
                    SetPVarInt(i, "EnterVehicle" , GetCount()+5000);			
                    if(afkTime >= 86400) { Kick(i); }
                }
                if(GetPVarInt(i, "Hotwire") > 0)
				{
		    		SetPVarInt(i, "Hotwire", GetPVarInt(i, "Hotwire")+1);
		    		/*format(string, sizeof(string),"~w~%d", GetPVarInt(i, "Hotwire"));
				    GameTextForPlayer(i, string, 1000, 6);*/
		    		GetVehiclePos(GetPlayerVehicleID(i),x,y,z);
				    if(GetPVarInt(i, "Hotwire") >= 61)
				    {
				        DeletePVar(i,"HotWire");
				        TogglePlayerControllableEx(i,true);
				        format(sendername, sizeof(sendername), "%s", PlayerNameEx(i));
					    GiveNameSpace(sendername);
				        new rand = random(6)+1;
						switch(rand)
						{
						    case 1,3,5:
						    {
    				            format(string, sizeof(string), "*** Hotwire attempt successful. (( %s ))", sendername);
    				            ProxDetector(30.0, i, string, COLOR_PURPLE);
    				            VehicleInfo[GetPlayerVehicleID(i)][vEngine]=1;
    				            VehicleInfo[GetPlayerVehicleID(i)][vLights]=1;
    				            CarLights(GetPlayerVehicleID(i));
	                            CarEngine(GetPlayerVehicleID(i),1);
			    			    SendFactionMessage(1, COLOR_BLUE, "HQ: All Units - HQ: Vehicle Theft.");
			    			    format(string, sizeof(string), "HQ: %s - Plate: %s.", VehicleName[GetVehicleModel(GetPlayerVehicleID(i))-400], VehicleInfo[GetPlayerVehicleID(i)][vPlate]);
			    			    SendFactionMessage(1, COLOR_BLUE, string);
							    format(string, sizeof(string), "HQ: Location: %s",GetPlayerArea(i));
							    SendFactionMessage(1, COLOR_BLUE, string);
							    StopProgress(i);
							    TriggerBomb(GetPlayerVehicleID(i));
						    }
						    case 2,4,6:
						    {
						        format(string, sizeof(string), "*** Hotwire attempt failed. (( %s ))", sendername);
    				            ProxDetector(30.0, i, string, COLOR_PURPLE);
	                            RemovePlayerFromVehicle(i);
	                            StopProgress(i);
						    }
						}
				    }
				}
				if(GetPVarInt(i, "RamHouse") > 0)
				{
				    if(IsPlayerInRangeOfPoint(i,2.0, HouseInfo[GetPVarInt(i, "RamHouseID")][hXo], HouseInfo[GetPVarInt(i, "RamHouseID")][hYo], HouseInfo[GetPVarInt(i, "RamHouseID")][hZo]))
				    {
				        SetPVarInt(i, "RamHouse", GetPVarInt(i, "RamHouse")+1);
				        /*format(string, sizeof(string),"~w~%d", GetPVarInt(i, "RamHouse"));
				        GameTextForPlayer(i, string, 1000, 6);*/
				        if(GetPVarInt(i, "RamHouse") == 61)
				        {
					        new rand = random(2)+1;
						    switch(rand)
						    {
						        case 1:
						        {
    				                SendClientMessage(i, COLOR_WHITE, "The house door broke down and is now enterable.");
    				                HouseInfo[GetPVarInt(i, "RamHouseID")][hLocked]=0;
    				                DeletePVar(i,"RamHouse");
						            DeletePVar(i,"RamHouseID");
						            StopProgress(i);
						            if(GetPVarInt(i, "Member") != 1)
	    				            {
	    				                GetPlayerPos(i, x, y, z);
									    if(x > 46.7115 && y > -2755.979 && x < 2931.147 && y < -548.8602)
									    {
			    					        SendFactionMessage(1, COLOR_BLUE, "HQ: All Units - HQ: House Burglary.");
									        format(string, sizeof(string), "HQ: Location: %s",GetPlayerArea(i));
									        SendFactionMessage(1, COLOR_BLUE, string);
								        }
						            }
						        }
						        default:
						        {
						            SendClientMessage(i, COLOR_WHITE, "Attempt failed on breaking the house door.");
    				                DeletePVar(i,"RamHouse");
						            DeletePVar(i,"RamHouseID");
						            StopProgress(i);
						        }
							}
				        }
				    }
				    else
				    {
				        DeletePVar(i,"RamHouse");
						DeletePVar(i,"RamHouseID");
						SendClientMessage(i,COLOR_LIGHTRED, "Attempt failed, REASON:[left the door].");
						StopProgress(i);
				    }
				}
				if(GetPVarInt(i, "RamVehicle") > 0) {
				    new carid = PlayerToCar(i, 2, 4.0), found = 0;
				    if(GetPVarInt(i, "RamVehID") == carid) {
				        SetPVarInt(i, "RamVehicle", GetPVarInt(i, "RamVehicle") + 1);
				        if(GetPVarInt(i, "RamVehicle") >= GetPVarInt(i, "RamVehTime")) {
					        new rand;
					        switch(VehicleInfo[carid][vLockLvl]) {
					            case 0 .. 1: { rand = random(2)+1; }
					            case 2: { rand = random(3)+1; }
					            case 3: { rand = random(4)+1; }
					        }
						    switch(rand)
						    {
						        case 1:
						        {
						            foreach(new i2 : Player)
					                {
					                    SetVehicleParamsForPlayer(carid,i2,0,0);
					                }
                                    VehicleInfo[carid][vLock] = 0;
                                    format(string, sizeof(string),"The %s's door broke open.", VehicleName[GetVehicleModel(carid)-400]);
    				                SendClientMessage(i, COLOR_WHITE, string);
    				                DeletePVar(i,"RamVehicle");
						            DeletePVar(i,"RamHouseID");
						            StopProgress(i);
						            if(VehicleInfo[carid][vAlarmLvl] >= 1)
						            {
						                VehicleInfo[carid][vAlarm]=1;
						                if(GetPVarInt(i, "Member") != 1)
	    				                {
	    				                    GetPlayerPos(i, x, y, z);
									        if(x > 46.7115 && y > -2755.979 && x < 2931.147 && y < -548.8602)
									        {
			    					            SendFactionMessage(1, COLOR_BLUE, "HQ: All Units - HQ: Vehicle Burglary.");
									            format(string, sizeof(string), "HQ: Location: %s",GetPlayerArea(i));
									            SendFactionMessage(1, COLOR_BLUE, string);
									            found++;
								            }
						                }
						            }
						        }
						        default:
						        {
						            SendClientMessage(i, COLOR_LIGHTRED, "Attempt failed!");
    				                DeletePVar(i,"RamVehicle");
						            DeletePVar(i,"RamVehID");
						            StopProgress(i);
						            if(VehicleInfo[carid][vAlarmLvl] >= 2) { VehicleInfo[carid][vAlarm]=1; }
						        }
							}
				        }
				    }
				    else
				    {
				        DeletePVar(i,"RamVehicle");
						DeletePVar(i,"RamVehID");
						SendClientMessage(i,COLOR_LIGHTRED, "Attempt failed, REASON:[left the vehicle]!");
						StopProgress(i);
						if(VehicleInfo[carid][vAlarmLvl] >= 2) { VehicleInfo[carid][vAlarm]=1; }
				    }
				}
		    	//============//
		    	// Weapon Hack//
		    	//============//
		    	new sweapon, sammo, founda = GetAdminCount(2), gunname[128];
		    	if(GetPVarInt(i, "Admin") == 0 && GetPlayerState(i) != PLAYER_STATE_WASTED && GetPlayerState(i) != PLAYER_STATE_SPECTATING)
		    	{
		    	    new found[3];
		            for (new w = 0; w < 9; w++)
			        {
				        GetPlayerWeaponData(i, w, sweapon, sammo);
				        if(DisabledWeapon(GetPVarInt(i, "ConnectTime"), sweapon))
				        {
				            if(GetPVarInt(i, "BeingBanned") == 0)
				            {
				                GetWeaponName(sweapon, gunname, sizeof(gunname));
					            format(string, sizeof(string), "AdmCmd: %s was banned by Anticheat Reason:[Forbidden Weapons (%s)].", PlayerInfo[i][pName], gunname);
					            SendClientMessageToAll(COLOR_LIGHTRED, string);
					            format(string, sizeof(string), "Forbidden Weapon: %s", gunname);
		                        BanPlayer(i, string, "Anticheat");
		                    }
		                    return 1;
				        }
				        if(sweapon >= 22 && sweapon <= 38)
				        {
				            found[1]++;
							if(PlayerInfo[i][pPlayerWeapon] == sweapon)
							{
							    found[2]++;
							    if(sammo >= 1) { PlayerInfo[i][pPlayerAmmo]=sammo; }
							    if(sammo <= -1)
								{
								    if(GetPVarInt(i, "LSPD_Ta") == 0)
								    {
								        ResetPlayerWeapons(i);
								        PlayerInfo[i][pPlayerWeapon]=0, PlayerInfo[i][pPlayerAmmo]=0;
								    }
								}
							    if(sammo > 500)
							    {
							        if(GetPVarInt(i, "LSPD_Ta") == 0)
							        {
							            ResetPlayerWeaponsEx(i);
									    if(founda == 0)
									    {
									        if(GetPVarInt(i, "BeingBanned") == 0)
				                            {
					    	        	        format(string, sizeof(string), "AdmCmd: %s was banned by Anticheat Reason:[Ammo Hacks].", PlayerInfo[i][pName]);
					    	        	        SendClientMessageToAll(COLOR_LIGHTRED, string);
		                	        	        BanPlayer(i, "Ammo Hacks" , "Anticheat");
		                	        	    }
		                	            }
		                	            else
		                	            {
		                	                format(string, sizeof(string), "AdmWarning: %s (ID: %i) is possibly ammo hacking.", PlayerInfo[i][pName], i);
					                        if(GetPVarInt(i, "Member") != 1)
					                        {
					                            SendAdminMessage(COLOR_YELLOW,string);
					                            ResetPlayerWeaponsEx(i);
								                PlayerInfo[i][pPlayerWeapon]=0, PlayerInfo[i][pPlayerAmmo]=0;
								            }
		                	            }
		                	            return 1;
		                	        }
							    }
							}
				        }
				    }
				    if(found[1] >= 1 && found[2] == 0) // Found Weapon!
				    {
				        switch(GetPVarInt(i, "GUNHCKWARN"))
				        {
				            case 0, 1:
				            {
				                SetPVarInt(i, "GUNHCKWARN", GetPVarInt(i, "GUNHCKWARN")+1);
				            }
				            case 2:
				            {
				                if(GetPVarInt(i, "LSPD_Ta") == 0) { ResetPlayerWeaponsEx(i); }
				                SetPVarInt(i, "GUNHCKWARN", 0);
				                if(founda == 0)
				                {
				                    if(GetPVarInt(i, "BeingBanned") == 0)
				                    {
				                        if(GetPVarInt(i, "LSPD_Ta") == 0)
				                        {
				                            /*PlayerInfo[i][pPlayerWeapon]=0, PlayerInfo[i][pPlayerAmmo]=0;
					                        format(string, sizeof(string), "AdmCmd: %s was banned by Anticheat Reason:[Weapon Hacks].", PlayerInfo[i][pName]);
					                        SendClientMessageToAll(COLOR_LIGHTRED, string);
		                                    BanPlayer(i, "Weapon Hacks", "Anticheat");*/
		                                    KickPlayer(i, "You have been kicked due to supposedly weapon hacking.");
		                                }
		                            }
		                        }
		                        else
		                        {
		                            if(GetPVarInt(i, "LSPD_Ta") == 0 && GetPVarInt(i, "AdmWrnWeapon") == 0)
					                {
		                                format(string, sizeof(string), "AdmWarning: %s (ID: %i) is possibly weapon hacking.", PlayerInfo[i][pName], i);
					                    SendAdminMessage(COLOR_YELLOW,string);
					                    ResetPlayerWeaponsEx(i);
								        PlayerInfo[i][pPlayerWeapon]=0, PlayerInfo[i][pPlayerAmmo]=0;
								        SetPVarInt(i, "AdmWrnWeapon", 1);
										SetTimerEx("AdmWrnWeaponTimer", 30000, false, "i", i);
								    }
					                
		                        }
				            }
						}
				    }
				}
			}
		}
	}
	return 1;
}
//============================================//
public OneMinTimer()
{
	new query[150];
	
	new string[128],tmphour,tmpminute,tmpsecond,year,month,day,mtext[50], Float:x, Float:y, Float:z;
    gettime(tmphour, tmpminute, tmpsecond);
    getdate(year, month, day);
	FixHour(tmphour);
	if ((tmphour > ghour) || (tmphour == 0 && ghour == 23))
	{
	    ghour = tmphour;
		if(day > gday)
		{
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
		    gday=day;
		    format(string, sizeof(string), "Today is now %s-%d-%d.", mtext,gday,year);
		    SendClientMessageToAll(COLOR_WHITE,string);
		    foreach(new i : Player) //Setting subscription for online players.
		    {
		        if(GetPVarInt(i, "MonthDon") > 0)
		        {
					SetPVarInt(i, "MonthDonT", GetPVarInt(i, "MonthDonT") - 1);
					if(GetPVarInt(i, "MonthDonT") == 0)
					{
					    SetPVarInt(i, "MonthDon", 0);
					    SetPVarInt(i, "MonthDonT", 0);
					    SendClientMessage(i, -1, "INFO: Your monthly donation has expired. Renew it at (www.diverseroleplay.org)");
					}
		        }
		    }
		    for(new i = 0; i < 32; i = i + 7)
		    {
				if(i == gday)
				{
				    new lottery = random(500);
				    format(query, sizeof(query), "SELECT * FROM lottery WHERE Number=%d AND Active = 1", lottery);
				    mysql_function_query(handlesql, query, true, "LotteryCheck", "iii",  -1, 2, lottery);
				}
	  		}
		    mysql_function_query(handlesql, "SELECT ID, Online, MonthDon, MonthDonT FROM accounts WHERE MonthDon > 0 AND Online = 0", true, "CheckSub", ""); //Setting it for offline players.
		}
        new randfire = random(5)+1;
	    if(randfire == 1) {
		    SendFactionMessage(4, COLOR_PINK, "HQ: All Units - HQ: Forest fire.");
			SendFactionMessage(4, COLOR_PINK, "HQ: Location: Los Santos Hills");
		    new randex = random(6)+1;
		    switch(randex)
		    {
		        case 0:
		        {
		            CreateFire(2308.4075,-747.0538,130.8466, 0, 0);
		            CreateFire(2315.0510,-738.9586,131.2455, 0, 0);
		            CreateFire(2314.8535,-732.4950,131.0023, 0, 0);
		            CreateFire(2320.9534,-730.0740,130.9770, 0, 0);
		            CreateFire(2327.8726,-730.3591,131.1032, 0, 0);
		            CreateFire(2335.7083,-730.0630,131.2146, 0, 0);
		            CreateFire(2339.6821,-734.7635,131.5189, 0, 0);
		            CreateFire(2342.9485,-738.9572,131.6406, 0, 0);
		        }
		        case 1:
		        {
		            CreateFire(2104.8728,-702.4496,100.1167, 0, 0);
		            CreateFire(2108.7485,-699.7054,99.3212, 0, 0);
		            CreateFire(2112.5779,-694.6858,97.3766, 0, 0);
		            CreateFire(2115.7700,-707.0362,98.3757, 0, 0);
				}
                case 2:
		        {
		            CreateFire(1940.0613,-719.0024,119.6757, 0, 0);
		            CreateFire(1928.5973,-709.5876,116.1881, 0, 0);
		            CreateFire(1935.7831,-692.7582,113.7584, 0, 0);
		            CreateFire(1933.5417,-696.0070,114.1324, 0, 0);
		            CreateFire(1933.2642,-700.7009,115.0814, 0, 0);
		            CreateFire(1936.3926,-706.6457,116.8553, 0, 0);
		            CreateFire(1935.3020,-711.4852,117.6979, 0, 0);
				}
                case 3:
		        {
		            CreateFire(1815.2791,-652.8476,85.2148, 0, 0);
		            CreateFire(1811.2705,-656.1464,84.7837, 0, 0);
		            CreateFire(1809.2571,-660.4609,84.7211, 0, 0);
		            CreateFire(1808.0842,-664.9736,84.8005, 0, 0);
		            CreateFire(1811.9285,-667.0464,85.8153, 0, 0);
		            CreateFire(1818.4559,-665.6723,86.7164, 0, 0);
				}
                case 4:
		        {
		            CreateFire(1768.7803,-342.1057,86.1454, 0, 0);
		            CreateFire(1768.8862,-338.0265,85.6665, 0, 0);
		            CreateFire(1770.6743,-330.7438,84.2244, 0, 0);
		            CreateFire(1767.9269,-323.0002,84.4099, 0, 0);
		            CreateFire(1764.2595,-317.2643,85.0110, 0, 0);
		            CreateFire(1760.6791,-320.0348,86.4095, 0, 0);
		            CreateFire(1758.8864,-326.3961,87.5176, 0, 0);
		            CreateFire(1755.8950,-329.6440,87.1788, 0, 0);
		            CreateFire(1760.5447,-334.1052,87.7204, 0, 0);
				}
                case 5:
		        {
		            CreateFire(1411.1503, -403.2238,40.2368, 0, 0);
		            CreateFire(1411.3322,-418.4037,42.1495, 0, 0);
		            CreateFire(1410.2025,-413.5192,41.7965, 0, 0);
		            CreateFire(1417.9777,-411.8234,41.7799, 0, 0);
		            CreateFire(1420.4956,-408.9738,41.7520, 0, 0);
		            CreateFire(1416.1837,-401.5279,39.7653, 0, 0);

		        }
		        case 6:
		        {
		            CreateFire(542.7335,-823.4837,92.7289, 0, 0);
		            CreateFire(540.9619,-826.7196,92.7545, 0, 0);
		            CreateFire(538.8298,-827.7182,92.6495, 0, 0);
		            CreateFire(536.2847,-825.8207,92.9368, 0, 0);
		            CreateFire(535.3265,-824.2097,93.1646, 0, 0);
		        }
			}
		}
	}
	foreach(new v : Vehicle)
	{
	    CallRemoteFunction("RevCarIDObjects","i", v);
	    if(VehicleInfo[v][vEngine] == 1 && !IsNotAEngineCar(GetPlayerVehicleID(v)))
		{
		    if(VehicleInfo[v][vFuel] > 0)
		    {
				switch(GetVehicleModel(v))
				{
				    case 400, 408, 413, 422, 440, 459, 470, 478, 482, 489, 495, 500, 505, 522, 531, 543, 552, 554, 579, 582, 605:
				    {
					    VehicleInfo[v][vFuel]-=1;
					}
					case 414, 455, 456, 498, 499, 524, 578, 609:
					{
					    VehicleInfo[v][vFuel]-=2;
					}
					case 403, 443, 514, 515:
					{
					    VehicleInfo[v][vFuel]-=3;
					}
				    default:
				    {
					    VehicleInfo[v][vFuel]-=1;
					}
				}
		    }
	    }
	}
	for(new i = 0; i < sizeof(CrateInfo); i++)
    {
        if(CrateInfo[i][cUsed] == 1)
        {
            if(CrateInfo[i][cTime] > 0)
            {
                CrateInfo[i][cTime]--;
				if(CrateInfo[i][cTime] == 0)
				{
				    if(CrateInfo[i][cVeh] > 0)
				    {
				        CrateInfo[i][cTime]=30;
				    }
				    else
				    {
				        CrateInfo[i][cUsed]=0;
				        CrateInfo[i][cX]=0.0;
    			        CrateInfo[i][cY]=0.0;
    			        CrateInfo[i][cZ]=0.0;
    			        CrateInfo[i][cVeh]=0;
    			        CrateInfo[i][cTime]=0;
    			        if(IsValidDynamicObject(CrateInfo[i][cObject]) && CrateInfo[i][cObject] > 0) { DestroyDynamicObject(CrateInfo[i][cObject]); }
   	                    DestroyDynamic3DTextLabel(CrateInfo[i][cText]);
				    }
				}
            }
        }
	}
	for(new o = 0; o < MAX_OBJECTS; o++)
	{
	    if(Shells[o][sUsed] == 1)
	    {
	        if(Shells[o][sTime] >= 1) { Shells[o][sTime]--; }
	        else
	        {
	            Shells[o][sTime]=0;
				Shells[o][sCurTime]=0;
	            Shells[o][sUsed]=0;
	            Shells[o][sX]=0.0;
	            Shells[o][sY]=0.0;
	            Shells[o][sZ]=0.0;
	            DestroyDynamic3DTextLabel(Shells[o][sText]);
	        }
	    }
	    if(Bullet[o][bUsed] == 1)
	    {
	        Bullet[o][bUsed]=0;
	        Bullet[o][bX]=0.0;
	        Bullet[o][bY]=0.0;
	        Bullet[o][bZ]=0.0;
	        if(IsValidDynamicObject(Bullet[o][bObject])) { DestroyDynamicObject(Bullet[o][bObject]); }
	    }
	}
	for(new ol = 0; ol < MAX_LOOT; ol++)
	{
	    if(LootInfo[ol][lUsed] == 1)
	    {
	        if(LootInfo[ol][lTime] >= 1) { LootInfo[ol][lTime]--; }
	        else
	        {
	            LootInfo[ol][lTime]=0;
	            LootInfo[ol][lUsed]=0;
	            LootInfo[ol][lX]=0.0;
	            LootInfo[ol][lY]=0.0;
	            LootInfo[ol][lZ]=0.0;
	            DestroyDynamic3DTextLabel(LootInfo[ol][lText]);
	            if(IsValidDynamicObject(LootInfo[ol][lObject])) { DestroyDynamicObject(LootInfo[ol][lObject]); }
	            LootInfo[ol][lObject]=0;
	        }
	    }
	}
	for(new o = 0; o < sizeof(CorpInfo); o++)
    {
        if(CorpInfo[o][cUsed] == 1)
        {
            if(CorpInfo[o][cTime] > 0)
			{
                CorpInfo[o][cTime]--;
                if(CorpInfo[o][cTime] == 0) {
					RemoveCorpse(o);
				}
				else if(CorpInfo[o][cTime] < 50 && CorpInfo[o][cVeh] != 0){
					GetVehiclePos(CorpInfo[o][cVeh], x, y, z);
					format(string, sizeof(string), "*** A foul odour can be smelt emitting from the %s.", VehicleName[GetVehicleModel(CorpInfo[o][cVeh])-400]);
					foreach(new i : Player) {
						if(IsPlayerInRangeOfPoint(i, 20.0, x, y, z)) {
							SendClientMessage(i, COLOR_PURPLE, string);
						}
					}
				}
			} else {
			RemoveCorpse(o); }
        }
	}
	for(new fa = 0; fa < MAX_FACTIONS; fa++) {
	    if(FactionInfo[fa][fRights] > 0 && FactionInfo[fa][fShipment] > 0) {
			FactionInfo[fa][fShipment]--;
			if(FactionInfo[fa][fShipment] == 0 && FactionInfo[fa][fShipmentID] > 0) {
				SendFactionMessage(fa, COLOR_BLUE, "[TIP] {FFFFFF}Factions shipment has been dropped off!");
				foreach(new i : Player) {
					if(GetPVarInt(i, "Member") == fa && GetPVarInt(i, "Rank") >= 1) {
						SetPlayerCheckpoint(i, x, y, z+0.5, 5.0);
					}
				}
				GetDynamicObjectPos(FactionInfo[fa][fObj], x, y, z);
				if(IsValidDynamicObject(FactionInfo[fa][fObj])) { DestroyDynamicObject(FactionInfo[fa][fObj]); }
				format(string, sizeof(string), "Location: %s", GetZoneArea(x, y, z));
				SendFactionMessage(fa, COLOR_BLUE, string);				
				new crateID = LoadCrate(x, y, z);
				for(new i=0; i < MAX_SHIPMENT_SLOTS; i++) {
					if(FactionInfo[fa][fShipmentID][i] < 1) continue;
					if(crateID != -1) AddToCrate(crateID, FactionInfo[fa][fShipmentID][i], FactionInfo[fa][fShipmentA][i]);		
					FactionInfo[fa][fShipmentID][i] = 0;
					FactionInfo[fa][fShipmentA][i] = 0;					
				}
				if(crateID == -1) {
					SendFactionMessage(fa, COLOR_RED, "[ERROR] Failed to 'LoadCrate', no available crate slots found. Please notify an administrator or developer.");
				} else {
					SendATFMessage(COLOR_BLUE, "HQ: All Units - HQ: Incoming Illegal-Shipment");
					format(string, sizeof(string), "HQ: Location: %s", GetZoneArea(x, y, z));
					SendATFMessage(COLOR_BLUE, string);
				}
			}
	    }
	}
	for(new weed = 0; weed < sizeof(WeedInfo); weed++)
    {
        if(WeedInfo[weed][wPlanted] == 1 && WeedInfo[weed][wTime] > 0)
        {
            WeedInfo[weed][wTime]--;
            new Float:adjust;
            switch(WeedInfo[weed][wTime])
            {
                case 0 .. 4: { adjust=1.2; }
                case 5 .. 9: { adjust=1.3; }
                case 10 .. 14: { adjust=1.4; }
                case 15 .. 19: { adjust=1.5; }
                case 20 .. 24: { adjust=1.6; }
                case 25 .. 29: { adjust=1.7; }
                case 30 .. 34: { adjust=1.8; }
                case 35 .. 39: { adjust=1.9; }
                case 40 .. 44: { adjust=2.1; }
                case 45 .. 49: { adjust=2.2; }
                case 50 .. 54: { adjust=2.3; }
                case 55 .. 60: { adjust=2.5; }
            }
            if(WeedInfo[weed][wObject] > 0 && IsValidDynamicObject(WeedInfo[weed][wObject])) { MoveDynamicObject(WeedInfo[weed][wObject], WeedInfo[weed][wX], WeedInfo[weed][wY], WeedInfo[weed][wZ]-adjust, 5.0); }
        }
	}
	for(new crack = 0; crack < sizeof(CrackInfo); crack++)
    {
        if(CrackInfo[crack][cPlanted] == 1 && CrackInfo[crack][cTime] > 0)
        {
            CrackInfo[crack][cTime]--;
        }
	}
	foreach(new i : Player)
	{
		if(GetPVarInt(i, "Reg") >= 1 || GetPVarInt(i, "Admin") >= 1) {
			mysql_tquery(handlesql, "SELECT `ID` FROM applications", "CountPendingApps", "i", i);
		}
	    SetPVarInt(i, "Hunger", GetPVarInt(i, "Hunger")+1);
	    if(GetPVarInt(i, "AFKTime") < 1800) SetPVarInt(i, "PayDay", 1+GetPVarInt(i, "PayDay"));
        if(GetPVarInt(i, "Hunger") >= 3 && GetPVarInt(i, "Control") == 0 && GetPVarInt(i, "Dead") == 0
		&& GetPVarInt(i, "Cuffed") == 0 && GetPVarInt(i, "Jailed") == 0)
	    {
	        SetPVarInt(i, "Hunger", 0);
	        new Float:health;
	        GetPlayerHealth(i,health);
	        if(health >= 11.0) { SetPlayerHealth(i, health-1.0); }
	    }
	    if(GetPVarInt(i, "Wound_T") == 1 || GetPVarInt(i, "Wound_A") == 1 || GetPVarInt(i, "Wound_L") == 1)
	    {
	        if(GetPVarInt(i, "Cuffed") == 0 && GetPVarInt(i, "Control") == 0 && GetPVarInt(i, "Dead") == 0)
	        {
	            new Float:health;
	            GetPlayerHealth(i,health);
	            SetPlayerHealth(i, health-5.0);
	            CallRemoteFunction("ShowBlood", "i", i);
	        }
	    }
	    if(GetPVarInt(i, "JobTime") > 0) { SetPVarInt(i,"JobTime",GetPVarInt(i, "JobTime")-1); }
		CallRemoteFunction("PayDay", "i", i);
		//==========//
		GetPlayerPos(i, x, y, z);
		SetPVarFloat(i, "Pos_X_1", x);
		SetPVarFloat(i, "Pos_X_1", y);
		SetPVarFloat(i, "Pos_X_1", z);
		if(GetPVarFloat(i, "Pos_X_1") == GetPVarFloat(i, "Pos_X_2") &&
		GetPVarFloat(i, "Pos_Y_1") == GetPVarFloat(i, "Pos_Y_2") &&
		GetPVarFloat(i, "Pos_Z_1") == GetPVarFloat(i, "Pos_Z_2"))
		{
		    SetPVarInt(i, "AFK-TIME", GetPVarInt(i, "AFK-TIME")+1);
		    if(GetPVarInt(i, "AFK-TIME") >= 30)
		    {
		        //DeletePVar(i, "PayDay");
		    }
		}
		else
		{
		    DeletePVar(i, "AFK-TIME");
		}
		SetPVarFloat(i, "Pos_X_2", x);
		SetPVarFloat(i, "Pos_X_2", y);
		SetPVarFloat(i, "Pos_X_2", z);
		CallRemoteFunction("OnPlayerDataSave", "i", i);
		//==========//
	}
	return 1;
}
//============================================//
public OnPlayerUpdate(playerid)
{
    if(IsPlayerConnected(playerid) && !IsPlayerNPC(playerid))
    {
        new string[128], Float:health, Float:armour;
        GetPlayerHealth(playerid,health), GetPlayerArmour(playerid,armour);
        if(GetPVarInt(playerid, "AFKTime") > 0) SetPVarInt(playerid, "AFKTime", 0);
        if(GetPVarFloat(playerid, "PlayerHealth") != health && !IsPlayerNPC(playerid))
	    {
	        if(health >= 2.0 && health <= 9.0 && GetPVarInt(playerid, "Admin") < 4 && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && GetPVarInt(playerid, "Control") == 0 && GetPVarInt(playerid, "Dead") < 5 && GetPVarInt(playerid, "Cuffed") == 0)
	        {
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
		        SetPVarInt(playerid, "Dead", 5);
	            SetPVarInt(playerid, "CrackTime", GetCount()+60000);
		        SendClientMessage(playerid,COLOR_LIGHTRED,"WARNING: You are currently injured, use (/getup).");
	        }
	        SetPVarFloat(playerid, "PlayerHealth", health);
	    }
        if(PlayerInfo[playerid][pPlayerWeapon] > 0)
        {
		    if(PlayerInfo[playerid][pPlayerAmmo] <= 0)
		    {
		        if(!IsPlayerAttachedObjectSlotUsed(playerid, 9))
		        {
		        	SetPlayerAttachedObject(playerid, 9, PrintIid(PlayerInfo[playerid][pPlayerWeapon]), 6, 0.0, 0.0, 0.0);
		        }
		    }
		    else
		    {
		        if(PlayerInfo[playerid][pForbid] > 0) {
					SetPlayerArmedWeapon(playerid, 0);
				} else {
					if(GetPlayerWeapon(playerid) != PlayerInfo[playerid][pPlayerWeapon] && !IsPlayerInAnyVehicle(playerid))
					{
						if(GetPVarInt(playerid, "LSPD_Ta") == 1 && GetPlayerWeapon(playerid) == 23)
						{
							if(GetPVarInt(playerid, "LSPD_Delay") > GetCount())
							{
								SetPlayerArmedWeapon(playerid, 0);
							}
						}
						else
						{
							SetPlayerArmedWeapon(playerid, PlayerInfo[playerid][pPlayerWeapon]);

							if(IsPlayerAttachedObjectSlotUsed(playerid, 9))
							{
								RemovePlayerAttachedObject(playerid, 9);
							}
						}
					}
				}
		    }
        }
		new Float:speed = GetPlayerSpeed(playerid, false);
        // Speed Hack.
	    if(ReturnSpeedHack(playerid, speed) && GetPVarInt(playerid, "Admin") == 0 && !IsPlayerNPC(playerid))
	    {
		    switch(GetPVarInt(playerid, "SpeedWarning"))
		    {
		        case 0:
		        {
				    new playersip[128];
		            GetPlayerIp(playerid,playersip,sizeof(playersip));
		            format(string, sizeof(string), "AdmWarning: IP:%s| [%d]%s %.0f kph.", playersip, playerid, PlayerName(playerid), speed);
                    SendAdminMessage(COLOR_YELLOW,string);
                    SetPVarInt(playerid, "SpeedWarning", 1);
                    return 0;
		        }
		        case 1: SetPVarInt(playerid, "SpeedWarning", 2);
		        case 2: SetPVarInt(playerid, "SpeedWarning", 0);
		    }
    	}
		// Vehicle Data
		new vehicleid = GetPlayerVehicleID(playerid);
        if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
        {
			new Float:ghealth;
            GetVehicleHealth(vehicleid, ghealth);
            if(ghealth >= 20.0 && ghealth <= 299.0 && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
            {
		        SetVehicleHealth(vehicleid, 300.0);
		        switch(GetPVarInt(playerid, "FlipWarn"))
		        {
		            case 0 .. 5:
		            {
		                SetPVarInt(playerid,"FlipWarn", GetPVarInt(playerid, "FlipWarn")+1);
		            }
		            case 6:
		            {
		                new Float:X2, Float:Y2, Float:Z2;
		                GetVehiclePos(vehicleid, X2, Y2, Z2);
		                SendFactionMessage(2, COLOR_PINK, "HQ: All Units - HQ: Vehicle fumed in fire.");
					    format(string, sizeof(string), "HQ: Location: %s", GetZone(X2, Y2, Z2));
					    SendFactionMessage(2, COLOR_PINK, string);
		                CreateFire(X2, Y2, Z2, 0, 0);
		                SetPVarInt(playerid,"FlipWarn", 7);
		            }
		        }
		    }
		    if(VehicleInfo[vehicleid][vEngine] == 1 && !IsNotAEngineCar(vehicleid))
		    {
                switch(VehicleInfo[vehicleid][vFuel])
	            {
		            case 1:
			        {
				        format(string, sizeof(string), "There is no fuel in the %s!", VehicleName[GetVehicleModel(vehicleid)-400]);
						SendClientMessage(playerid, COLOR_LIGHTRED, string);
				        VehicleInfo[vehicleid][vEngine]=0;
				        VehicleInfo[vehicleid][vFuel]=0;
                        CarEngine(vehicleid, VehicleInfo[vehicleid][vEngine]);
		    	        return 0;
		            }
			        case 2 .. 300:
			        {
			            new vhealth = floatround(ghealth);
				        switch(vhealth)
				        {
				            case 1 .. 300:
					        {
					            if(VehicleInfo[vehicleid][vEngine] == 1)
						        {
		    				        if(VehicleInfo[vehicleid][vFuel] > 10) VehicleInfo[vehicleid][vFuel] = 10;
		    				        VehicleInfo[vehicleid][vEngine] = 0, CarEngine(vehicleid,0);
    	    			            format(string, sizeof(string), "The %ss engine broke-down.", VehicleName[GetVehicleModel(vehicleid)-400]);
									SendClientMessage(playerid, 0xCCEEFF96, string);
									return 0;
    	    		            }
				            }
				        }
		            }
	            }
	        }
		    if(!IsNotAEngineCar(vehicleid) && (VehicleInfo[vehicleid][vType] == VEHICLE_PERSONAL || VehicleInfo[vehicleid][vType] == VEHICLE_RENTAL))
		    {
				if(speed >= 105.0) {
					for(new h = 0; h < sizeof(SpeedCamera); h++) {
						if(IsPlayerInRangeOfPoint(playerid, 15.0, SpeedCamera[h][0], SpeedCamera[h][1], SpeedCamera[h][2])) {
							if(PlayerInfo[playerid][pSpeedDelay] < GetCount()) {
								if(GetPVarInt(playerid, "Member") != 1 && GetPVarInt(playerid, "Member") != 2) {
								PlayerInfo[playerid][pSpeedDelay]=GetCount()+10000;
								format(string, sizeof(string), "You have been caught on the %s speed camera.", GetZone(SpeedCamera[h][0], SpeedCamera[h][1], SpeedCamera[h][2]));
								SendClientMessage(playerid,COLOR_BLUE,string);
								PlayerPlaySound(playerid, 1132, 0.0, 0.0, 0.0);
								//==========//
								new query[264], year, month, day, hour, minute, second;
								getdate(year, month, day);
								gettime(hour,minute,second);
								new datum[64], timel[64];
								format(timel, sizeof(timel), "%d:%d:%d", hour, minute, second);
								format(datum, sizeof(datum), "%d-%d-%d", year, month, day);
								format(query, sizeof(query), "INSERT INTO `tickets`(`player`, `officer`, `time`, `date`, `amount`, `reason`) VALUES ('%s','%s','%s','%s',%d,'%s')",
								PlayerName(playerid), "LS-Speed-Camera",
								timel,datum, 150, "Speeding");
								mysql_tquery(handlesql, query);
								//==========//
								}
							}
						}
					}
				}
	        }
        }
    }
	return 1;
}
//============================================//
stock GetDotXY(Float:StartPosX, Float:StartPosY, &Float:NewX, &Float:NewY, Float:alpha, Float:dist)
{
    NewX = StartPosX + (dist * floatsin(alpha, degrees));
	NewY = StartPosY + (dist * floatcos(alpha, degrees));
	return true;
}
//============================================//
forward EnterGarage(playerid, h);
public EnterGarage(playerid, h)
{
	SetVehiclePosEx(GetPlayerVehicleID(playerid), HouseInfo[h][hgXi], HouseInfo[h][hgYi], HouseInfo[h][hgZi] + 0.5);
	SetVehicleZAngle(GetPlayerVehicleID(playerid), HouseInfo[h][hgAi]);
}
//============================================//
forward DestroyCampfire(campfireid);
public DestroyCampfire(campfireid)
{
	DestroyDynamicObject(Campfire[campfireid][cID]);
	Campfire[campfireid][cID] = 0;
	return 1;
}
//============================================//
forward DespawnPlayerVehicle(vehicleid);
public DespawnPlayerVehicle(vehicleid)
{
	foreach(new i : Player)
    {
		if(PlayerOwnsVehicle(i, vehicleid)) { return 1; }
		if(IsPlayerInVehicle(i, vehicleid))
		{
			VehicleInfo[vehicleid][vDespawnTimer] = SetTimerEx("DespawnPlayerVehicle", 600000, false, "i", vehicleid);
			return 1;
		}
	}

	SaveVehicleData(vehicleid);
    DespawnVehicle(vehicleid);
    return 1;
}
//============================================//
forward SpeedometerTimer();
public SpeedometerTimer()
{
	foreach(new i : Player)
    {
    	if(!IsPlayerConnected(i) || IsPlayerNPC(i)) continue;

		if(IsPlayerInAnyVehicle(i))
		{
			new vehicleid = GetPlayerVehicleID(i);

		    if(!IsNotAEngineCar(vehicleid))
			{
			    if(GetPVarInt(i, "VD") == 1)
			    {
			    	new Float:speed = GetPlayerSpeed(i, true);
			    	PrintSpeedo(i, speed);
				}
			}
		}
	}
}
//============================================//
forward ELMTimer();
public ELMTimer()
{
	foreach(new i : Vehicle) {
		if(VehicleInfo[i][vELM] == 1) {
			new panels, doors, lights, tires;
        	GetVehicleDamageStatus(i, panels, doors, lights, tires);
			switch(VehicleInfo[i][vELMFlash]) {
	        	case 0: UpdateVehicleDamageStatus(i, panels, doors, 2, tires);
	            case 1: UpdateVehicleDamageStatus(i, panels, doors, 5, tires);
	            case 2: UpdateVehicleDamageStatus(i, panels, doors, 2, tires);
	            case 3: UpdateVehicleDamageStatus(i, panels, doors, 4, tires);
	            case 4: UpdateVehicleDamageStatus(i, panels, doors, 5, tires);
	            case 5: UpdateVehicleDamageStatus(i, panels, doors, 4, tires);
	        }

	        if(VehicleInfo[i][vELMFlash] >=5) {
	        	VehicleInfo[i][vELMFlash] = 0;
	        } else {
				VehicleInfo[i][vELMFlash]++;
			}
		}
	}
}