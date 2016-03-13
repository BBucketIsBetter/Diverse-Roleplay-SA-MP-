//============================================//
//==============[ Checkpoint ]================//
//============================================//
public OnPlayerEnterCheckpoint(playerid)
{
    if(IsPlayerNPC(playerid)) return 1;
    //printf("Player [%i] %s just entered a checkpoint!", playerid, PlayerName(playerid));
    if(GetPVarInt(playerid, "Dead") == 1 || GetPVarInt(playerid, "Dead") == 2) return 1;
	new string[128], result[1000], found = 0, foundid = 0;
	if(GetPlayerVirtualWorld(playerid) == 0 && GetPlayerInterior(playerid) == 0)
    {
		if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) {
			for(new i = 0; i < sizeof(ATMs); i++)
			{
				if(IsPlayerInRangeOfPoint(playerid,3.0,ATMs[i][0],ATMs[i][1],ATMs[i][2]))
				{
					SendBankDialog(playerid, 3);
					return 1;
				}
			}
		}
		if(IsPlayerInAnyVehicle(playerid)) {
			if(IsPlayerInRangeOfPoint(playerid,3.0,-2091.3152,-2242.6431,30.6625)) {
				new idcar = GetPlayerVehicleID(playerid);
				if(IsMatTruck(idcar) && IsTrailerAttachedToVehicle(idcar)) {
					new trailer = GetVehicleTrailer(idcar);
					if(VehicleInfo[trailer][vMats] > 0) {
						DisablePlayerCheckpoint(playerid);
						PlayerInfo[playerid][pMaterials] = PlayerInfo[playerid][pMaterials]+VehicleInfo[trailer][vMats];
						SaveCrafting(playerid);
						format(string, sizeof(string), "You've received {36CC40}%d {FFFFFF}materials for successfully delivering the packages.", VehicleInfo[trailer][vMats]);
						scm(playerid, COLOR_WHITE, string);
						VehicleInfo[trailer][vMats] = 0;
						DetachTrailerFromVehicle(idcar);
						DespawnVehicle(trailer);
						//if(VehicleInfo[idcar][vType] == VEHICLE_THEFT) DespawnVehicle(idcar);
						SpawnMatTrailers();
					}
				}
			}
	        for(new i=0; i < sizeof(DriveThrus); i++) // Drive-thru!
	        {
	            if(IsPlayerInRangeOfPoint(playerid,3.0,DriveThrus[i][d_x],DriveThrus[i][d_y],DriveThrus[i][d_z]))
	            {
					if((GMHour >= 0 && GMHour <= 6) || GMHour >= 22) return scm(playerid, -1, "Drives-thrus are closed at night, come back in the morning or go inside! (Opens at 7 AM)");
					scm(playerid,COLOR_WHITE,"[Store Employee] says: Hello sir, what can I get for you?");
					switch(DriveThrus[i][Type])
					{
						case 1:
						{
							for(new f = 0; f < sizeof(CluckItems); f++)
							{
								if(f == 0) { format(result, 1000, "%s | $%d", PrintIName(CluckItems[f][0]), CluckItems[f][1]); }
								else { format(result, 1000, "%s\n%s | $%d", result, PrintIName(CluckItems[f][0]), CluckItems[f][1]); }
							}
							ShowPlayerDialog(playerid, 10, DIALOG_STYLE_LIST, "Cluckin Bell", result, "Purchase", "Close");
							return 1;
						}
						case 2:
						{
							for(new f = 0; f < sizeof(BurgerItems); f++)
							{
								if(f == 0) { format(result, 1000, "%s | $%d", PrintIName(BurgerItems[f][0]), BurgerItems[f][1]); }
								else { format(result, 1000, "%s\n%s | $%d", result, PrintIName(BurgerItems[f][0]), BurgerItems[f][1]); }
							}
							ShowPlayerDialog(playerid, 8, DIALOG_STYLE_LIST, "Burger Shot", result, "Purchase", "Close");
							return 1;
						}
					}
                }
            }
		}
    }
	if(spraytag_find[playerid] != 0)
	{
		new tagid = GetPVarInt(playerid, "TagToFind"), member = GetPVarInt(playerid, "Member");
		if(IsPlayerInRangeOfPoint(playerid, 3.0, SprayTags[member][tagid][_spPosX], SprayTags[member][tagid][_spPosY], SprayTags[member][tagid][_spPosZ])) {
			SendClientMessage(playerid, -1, "You've arrived at your tag spray.");
			DisablePlayerCheckpoint(playerid);
			spraytag_find[playerid] = 0;
			DeletePVar(playerid, "TagToFind");
		}
	}
    if(GetPVarInt(playerid, "OnRoute") != 0)
    {
        if(GetPlayerVehicleID(playerid) != GetPVarInt(playerid, "RouteVeh")) return true;
		new id = GetPVarInt(playerid, "OnRoute");
        switch(GetPVarInt(playerid, "Job"))
		{
		    case 2: // GARBAGE MAN ROUTE
		    {
		        if(id != sizeof(TrashRoute))
		        {
		            if(IsPlayerInRangeOfPoint(playerid, 15.0, TrashRoute[id-1][0], TrashRoute[id-1][1], TrashRoute[id-1][2]))
				    {
					    SetPVarInt(playerid, "OnRoute", id+1);
				        TogglePlayerControllable(playerid, false);
		                GameTextForPlayer(playerid,"~w~~n~~n~~n~~n~~n~~n~~n~~n~~n~Picking trash up...",5000,3);
		                SetTimerEx("NextRoute", 5000, false, "ifffi", playerid, TrashRoute[id][0],TrashRoute[id][1],TrashRoute[id][2], 1);
		            }
		        }
		        else CallRemoteFunction("EndRoute","ii", playerid, JOB_GARBAGE_PAY);
		    }
		    case 3: // SWEEPER ROUTE
		    {
		        if(id != sizeof(SweepRoute))
		        {
		            if(IsPlayerInRangeOfPoint(playerid, 15.0, SweepRoute[id-1][0], SweepRoute[id-1][1], SweepRoute[id-1][2]))
				    {
					    SetPVarInt(playerid, "OnRoute", id+1);
					    CallRemoteFunction("NextRoute","ifffi", playerid, SweepRoute[id][0], SweepRoute[id][1], SweepRoute[id][2], 1);
		            }
		        }
		        else CallRemoteFunction("EndRoute","ii", playerid, JOB_SWEEP_PAY);
		    }
		    case 4: // PIZZA BOY
		    {
		        switch(id)
		        {
		            case 1:
		            {
						if(IsPlayerInAnyVehicle(playerid))
						{
							new rand, Float:radius;
							rand = random(sizeof(gPizzaCheckpoints));
							CallRemoteFunction("NextRoute","ifffi", playerid, gPizzaCheckpoints[rand][0], gPizzaCheckpoints[rand][1], gPizzaCheckpoints[rand][2], 0);
							radius = GetVehicleDistanceFromPoint(GetPlayerVehicleID(playerid), gPizzaCheckpoints[rand][0], gPizzaCheckpoints[rand][1], gPizzaCheckpoints[rand][2]);
							new reward = floatround(radius/10);
							SetPVarInt(playerid, "PizzaTime", reward);
							SetPVarInt(playerid, "PizzaTimeEx", 0);
							SetPVarInt(playerid, "OnRoute", 2);
						}
		            }
		            case 2:
		            {
		                if(GetPVarInt(playerid, "PizzaTimeEx") && GetPVarInt(playerid, "PizzaTimeEx") <= 15)
		                {
		                    SendClientMessage(playerid, COLOR_LIGHTRED, "You have been kicked for supposedly teleporting to routes!");
		                    Kick(playerid);
		                    return true;
		                }
						if(IsPlayerInAnyVehicle(playerid))
						{
							new Float:radius;
							radius = GetVehicleDistanceFromPoint(GetPlayerVehicleID(playerid), 2111.6963, -1788.6849, 13.5608);
							new reward = floatround(radius/13);
							format(string, sizeof(string), "Pizza delivered, you have received $%d!", reward);
							SendClientMessage(playerid,COLOR_WHITE,string);
							SendClientMessage(playerid,COLOR_WHITE,"To continue your deliveries, proceed to the checkpoint.");
							SetPlayerCheckpoint(playerid, 2111.6963, -1788.6849, 13.5608, 2.0);
							GivePlayerMoneyEx(playerid, reward);
							SetPVarInt(playerid, "OnRoute", 1);
						}
		            }
		        }
		    }
		    case 6: // TRUCKER
		    {
		        switch(id)
		        {
		            case 1:
		            {
						new Float:Pos[6];
		                switch(GetPVarInt(playerid, "TruckerRoute"))
		                {
		                    case 1:
		                    {
	        	                foreach(new b : BizIterator) {
		                            if(BizInfo[b][bReq] == 1) {
										SetPlayerCheckpoint(playerid,BizInfo[b][Xo], BizInfo[b][Yo], BizInfo[b][Zo],10.0);
										SetPVarInt(playerid, "TruckBizz", b);
										format(string, sizeof(string), "Deliver the products to the %s in %s.", BizInfo[b][Name], GetZone(BizInfo[b][Xo], BizInfo[b][Yo], BizInfo[b][Zo]));
										SendClientMessage(playerid, COLOR_WHITE, string);
										ProgressBar(playerid, "Loading Products...", 10, 0);
										return true;
		                            }
			                    }
								RemovePlayerFromVehicle(playerid);
								SCM(playerid, -1, "There is no business requesting products!");
								return true;
		                    }
		                    case 2: // Gas
		                    {
		                        new rand = rand = random(2)+1;
		                        switch(rand)
		                        {
		                            case 1:
		                            {
		                                Pos[3]=1935.9091;
		                                Pos[4]-=1774.6240;
		                                Pos[5]=13.3828;
		                            }
		                            default:
		                            {
		                                Pos[3]=1005.9490;
		                                Pos[4]-=941.2861;
		                                Pos[5]=42.0975;
		                            }
		                        }
		                        format(string, sizeof(string), "Deliver the fuel to the Gas Station in %s.", GetZone(Pos[3], Pos[4], Pos[5]));
			                    SendClientMessage(playerid, COLOR_WHITE, string);
			                    SetPlayerCheckpoint(playerid,Pos[3], Pos[4], Pos[5],10.0);
			                    ProgressBar(playerid, "Loading Fuel...", 10, 0);
		                    }
		                    case 3: // Supplies
		                    {
		                        new rand = rand = random(2)+1;
		                        switch(rand)
		                        {
		                            case 1:
		                            {
		                                Pos[3]=883.4844;
		                                Pos[4]-=1239.0375;
		                                Pos[5]=16.0829;
		                            }
		                            default:
		                            {
		                                Pos[3]=2453.4060;
		                                Pos[4]-=2487.9009;
		                                Pos[5]=13.6440;
		                            }
		                        }
		                        format(string, sizeof(string), "Deliver the products to the Factory in %s.", GetZone(Pos[3], Pos[4], Pos[5]));
			                    SendClientMessage(playerid, COLOR_WHITE, string);
			                    SetPlayerCheckpoint(playerid,Pos[3], Pos[4], Pos[5],10.0);
			                    ProgressBar(playerid, "Loading Supplies...", 10, 0);
		                    }
		                }
		                TogglePlayerControllable(playerid, false);
			            SetPVarInt(playerid, "OnRoute", 2);
		            }
		            case 2:
		            {
		                switch(GetPVarInt(playerid, "TruckerRoute"))
		                {
		                    case 1:
							{
   	                            new bizz = GetPVarInt(playerid, "TruckBizz");
   	                            if(bizz >= 0 && bizz <= MAX_BUSINESSES+1)
   	                            {
   	                                BizInfo[bizz][bProd]=150;
   	                                BizInfo[bizz][bReq]=0;
   	                                SaveBiz(bizz);
   	                            }
   	                            ProgressBar(playerid, "Unloading Products...", 10, 0);
							}
   	                        case 2:
							{
   	                            ProgressBar(playerid, "Unloading Fuel...", 10, 0);
   	                        }
   	                        case 3:
							{
   	                            ProgressBar(playerid, "Unloading Supplies...", 10, 0);
   	                        }
   	                    }
   	                    TogglePlayerControllableEx(playerid,false);
   	                    SetPlayerCheckpoint(playerid,2472.5923,-2089.7461,13.5469,3.0);
		                SetPVarInt(playerid, "OnRoute", 3);
		            }
		            case 3: CallRemoteFunction("EndRoute","ii", playerid, JOB_TRUCKER_PAY);
		        }
			}
		    case 7: // FARMER
		    {
		        if(id != sizeof(FarmerRoute))
		        {
		            if(IsPlayerInRangeOfPoint(playerid, 15.0, FarmerRoute[id-1][0], FarmerRoute[id-1][1], FarmerRoute[id-1][2]))
				    {
					    SetPVarInt(playerid, "OnRoute", id+1);
					    CallRemoteFunction("NextRoute","ifffi", playerid, FarmerRoute[id][0], FarmerRoute[id][1], FarmerRoute[id][2], 1);
		            }
		        }
		        else CallRemoteFunction("EndRoute","ii", playerid, JOB_FARMER_PAY);
		    }
		    case 8:
		    {
				switch(GetPVarInt(playerid, "FactoryRoute"))
		        {
		            case 1:
		            {
		                ProgressBar(playerid, "Collecting Boxes...", 5, 2);
		                TogglePlayerControllable(playerid, false);
		                DisablePlayerCheckpoint(playerid);
					}
					case 2:
					{
					    ProgressBar(playerid, "Delivering Boxes...", 5, 2);
					    TogglePlayerControllable(playerid, false);
					    DisablePlayerCheckpoint(playerid);
					}
		        }
		    }
		    default:
		    {
		        DisablePlayerCheckpoint(playerid);
		    }
        }
        return true;
    }
    for(new i = 0; i < sizeof(CheckpointAreas); i++)
	{
        if(IsPlayerInRangeOfPoint(playerid,20.0,CheckpointAreas[i][cXe],CheckpointAreas[i][cYe],CheckpointAreas[i][cZe]))
        {
            if(found == 0)
            {
                found++;
                foundid=i;
            }
        }
    }
    new b = GetPVarInt(playerid, "BizzEnter");
    if(b != 0)
    {
        if(IsPlayerInRangeOfPoint(playerid, 15.0, BizInfo[b][CP][0], BizInfo[b][CP][1], BizInfo[b][CP][2]))
        {
            if(BizInfo[b][cT] > 0)
            {
                found++;
                foundid=b;
            }
        }
    }
    if(found != 0)
    {
        if(b != 0)
        {
            if(IsPlayerInRangeOfPoint(playerid, 15.0, BizInfo[b][CP][0], BizInfo[b][CP][1], BizInfo[b][CP][2]))
            {
				switch(BizInfo[b][cT])
				{
				    case 1:
				    {
				        if(BizzProductC(b) && b != 0) return SendClientMessage(playerid,COLOR_GREY,"There are no products available in this business!");
			            for(new i = 0; i < sizeof(BarItems); i++)
			            {
			                if(i == 0) { format(result, 2000, "%s | $%d", PrintIName(BarItems[i][0]), BarItems[i][1]); }
			                else { format(result, 2000, "%s\n%s | $%d", result, PrintIName(BarItems[i][0]), BarItems[i][1]); }
			            }
			            ShowPlayerDialog(playerid, 22, DIALOG_STYLE_LIST, "Bar Menu", result, "Purchase", "Close");
				    }
				    case 2:
				    {
			            if(BizzProductC(b) && b != 0) return SendClientMessage(playerid,COLOR_GREY,"There are no products available at this business!");
			            for(new i = 0; i < sizeof(StoreItems); i++)
			            {
			                if(i == 0) {
						        format(result, 2000, "%s | $%d", PrintIName(StoreItems[i][0]), StoreItems[i][1]);
							} else {
						        format(result, 2000, "%s\n%s | $%d", result, PrintIName(StoreItems[i][0]), StoreItems[i][1]); }
			            }
			            ShowPlayerDialog(playerid, 7, DIALOG_STYLE_LIST, "Store Dialog", result, "Purchase", "Close");
			        }
				    case 3:
				    {
				        if(BizzProductC(b) && b != 0) return SendClientMessage(playerid,COLOR_GREY,"There are no products available at this business!");
			            for(new i = 0; i < sizeof(WarItems); i++)
			            {
			                if(i == 0) { format(result, 2000, "%s | $%d", PrintIName(WarItems[i][0]), WarItems[i][1]); }
			                else { format(result, 2000, "%s\n%s | $%d", result, PrintIName(WarItems[i][0]), WarItems[i][1]); }
			            }
			            format(result, 2000, "%s\n{5CB8E6}Pawn a Watch $150\n{5CB8E6}Pawn a Cellphone $300\n{5CB8E6}Pawn a MP3 player $75", result);
			            ShowPlayerDialog(playerid, 67, DIALOG_STYLE_LIST, "Warehouse", result, "Purchase", "Close");
				    }
				    case 4:
				    {
				        ShowPlayerDialog(playerid,19,DIALOG_STYLE_LIST,"Fightstyle Guide","Normal $50\nBoxing $500\nKung Fu $3000\nKneeHead $6000\nGrabKick $8000\nElbow 10000$","Learn", "Cancel");
				    }
				}
				ClearAnimations(playerid);
                return 1; 
            }
        }
        if(!IsPlayerInRangeOfPoint(playerid,5.0,CheckpointAreas[foundid][cXe],CheckpointAreas[foundid][cYe],CheckpointAreas[foundid][cZe])) return true;
        switch(CheckpointAreas[foundid][cType])
        {
            case CHECKPOINT_GUN:
			{
				if(GetPVarInt(playerid, "ConnectTime") <= 7) return SendClientMessage(playerid, COLOR_LIGHTRED, "Insufficient hours played!");
				if(GetPVarInt(playerid, "GunLic") == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You need a weapon license!");
			    for(new i = 0; i < sizeof(AmmuItems); i++)
			    {
			        if(i == 0) { format(result, 2000, "%s | $%d", PrintIName(AmmuItems[i][0]), AmmuItems[i][1]); }
			        else { format(result, 2000, "%s\n%s | $%d", result, PrintIName(AmmuItems[i][0]), AmmuItems[i][1]); }
			    }
			    ShowPlayerDialog(playerid, 20, DIALOG_STYLE_LIST, "Ammunation", result, "Purchase", "Close");
			}
            case CHECKPOINT_BAR:
			{
			    if(BizzProductC(b) && b != 0) return SendClientMessage(playerid,COLOR_GREY,"There are no products available in this business!");
			    for(new i = 0; i < sizeof(BarItems); i++)
			    {
			        if(i == 0) { format(result, 2000, "%s | $%d", PrintIName(BarItems[i][0]), BarItems[i][1]); }
			        else { format(result, 2000, "%s\n%s | $%d", result, PrintIName(BarItems[i][0]), BarItems[i][1]); }
			    }
			    ShowPlayerDialog(playerid, 22, DIALOG_STYLE_LIST, "Bar Menu", result, "Purchase", "Close");
			}
            case CHECKPOINT_REST: {}
            case CHECKPOINT_STORE:
			{
			    if(BizzProductC(b) && b != 0) return SendClientMessage(playerid,COLOR_GREY,"There are no products available at this business!");
			    for(new i = 0; i < sizeof(StoreItems); i++)
			    {
			        if(i == 0)
					{
						format(result, 2000, "%s | $%d", PrintIName(StoreItems[i][0]), StoreItems[i][1]);
					}
			        else
					{
						format(result, 2000, "%s\n%s | $%d", result, PrintIName(StoreItems[i][0]), StoreItems[i][1]);
					}
			    }
			    ShowPlayerDialog(playerid, 7, DIALOG_STYLE_LIST, "Store Dialog", result, "Purchase", "Close");
			}
            case CHECKPOINT_BANK:
			{
			    new string2[128];
			    format(string, sizeof(string), "Bank Account: $%d", GetPVarInt(playerid, "Bank"));
			    format(string2, sizeof(string2), "{33FF66}Deposit\n{33FF66}Withdraw\n{33FF66}Cash A Check ($%d)", GetPVarInt(playerid, "CheckEarn"));
			    ShowPlayerDialog(playerid,11,DIALOG_STYLE_LIST,string,string2, "Continue", "Exit");
			}
            case CHECKPOINT_CLUCK:
            {
                if(BizzProductC(b) && b != 0) return SendClientMessage(playerid,COLOR_GREY,"There are no products available at this business!");
			    for(new i = 0; i < sizeof(CluckItems); i++)
			    {
			        if(i == 0) { format(result, 2000, "%s | $%d", PrintIName(CluckItems[i][0]), CluckItems[i][1]); }
			        else { format(result, 2000, "%s\n%s | $%d", result, PrintIName(CluckItems[i][0]), CluckItems[i][1]); }
			    }
			    ShowPlayerDialog(playerid, 10, DIALOG_STYLE_LIST, "Cluckin Bell", result, "Purchase", "Close");
			}
            case CHECKPOINT_PIZZA:
			{
			    for(new i = 0; i < sizeof(PizzaItems); i++)
			    {
			        if(i == 0) { format(result, 2000, "%s | $%d", PrintIName(PizzaItems[i][0]), PizzaItems[i][1]); }
			        else { format(result, 2000, "%s\n%s | $%d", result, PrintIName(PizzaItems[i][0]), PizzaItems[i][1]); }
			    }
			    ShowPlayerDialog(playerid, 9, DIALOG_STYLE_LIST, "Pizza Stack", result, "Purchase", "Close");
			}
            case CHECKPOINT_BURGER:
			{
			    for(new i = 0; i < sizeof(BurgerItems); i++)
			    {
			        if(i == 0) { format(result, 2000, "%s | $%d", PrintIName(BurgerItems[i][0]), BurgerItems[i][1]); }
			        else { format(result, 2000, "%s\n%s | $%d", result, PrintIName(BurgerItems[i][0]), BurgerItems[i][1]); }
			    }
			    ShowPlayerDialog(playerid, 8, DIALOG_STYLE_LIST, "Burger Shot", result, "Purchase", "Close");
			}
            case CHECKPOINT_SEXSHOP:
			{
			    if(BizzProductC(b) && b != 0) return SendClientMessage(playerid,COLOR_GREY,"There are no products available at this business!");
			    for(new i = 0; i < sizeof(SexItems); i++)
			    {
			        if(i == 0) { format(result, 2000, "%s | $%d", PrintIName(SexItems[i][0]), SexItems[i][1]); }
			        else { format(result, 2000, "%s\n%s | $%d", result, PrintIName(SexItems[i][0]), SexItems[i][1]); }
			    }
			    ShowPlayerDialog(playerid, 66, DIALOG_STYLE_LIST, "Sex Shop", result, "Purchase", "Close");
			}
            case CHECKPOINT_WARESHOP:
            {
                if(BizzProductC(b) && b != 0) return SendClientMessage(playerid,COLOR_GREY,"There are no products available at this business!");
			    for(new i = 0; i < sizeof(WarItems); i++)
			    {
			        if(i == 0) { format(result, 2000, "%s | $%d", PrintIName(WarItems[i][0]), WarItems[i][1]); }
			        else { format(result, 2000, "%s\n%s | $%d", result, PrintIName(WarItems[i][0]), WarItems[i][1]); }
			    }
			    format(result, 2000, "%s\n{5CB8E6}Pawn a Watch $150\n{5CB8E6}Pawn a Cellphone $300\n{5CB8E6}Pawn a MP3 player $75", result);
			    ShowPlayerDialog(playerid, 67, DIALOG_STYLE_LIST, "Warehouse", result, "Purchase", "Close");
			}
            case CHECKPOINT_LSPD:
			{
		    	if(GetPVarInt(playerid, "Member") != 1) return true;
			    if(GetPVarInt(playerid, "Duty") != 1) return SendClientMessage(playerid, COLOR_WHITE, "You are not on duty!");
			    for(new i = 0; i < sizeof(PDItems); i++)
			    {
			        if(i == 0)
					{
						format(result, 2000, "%s | Rank: %d", PrintIName(PDItems[i][0]), PDItems[i][1]);
					}
			        else
					{
						format(result, 2000, "%s\n%s | Rank: %d", result, PrintIName(PDItems[i][0]), PDItems[i][1]);
					}
			    }
			    format(result, 2000, "%s\n{33FF66}Disarm", result);
			    ShowPlayerDialog(playerid, 35, DIALOG_STYLE_LIST, "LSPD Armoury", result, "Select", "Close");
			}
            case CHECKPOINT_GYM:
			{
			    ShowPlayerDialog(playerid,19,DIALOG_STYLE_LIST,"Fightstyle Guide","Normal $50\nBoxing $500\nKung Fu $3000\nKneeHead $6000\nGrabKick $8000\nElbow 10000$","Learn", "Cancel");
			}
			case CHECKPOINT_HOSPITAL:
            {
                CreateLableText(playerid,"Hospital"," ~w~Type ~b~/treatwound ~w~to ~n~ heal any wounds.");
            }
            case CHECKPOINT_CHURCH:
            {
                GameTextForPlayer(playerid, "~p~Marriage~n~~w~Price: ~g~$20000~n~~r~/marriage", 3000, 5);
            }
        }
		ClearAnimations(playerid);
        return 1;
    }
	foreach(new h : HouseIterator)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.0, HouseInfo[h][hXo], HouseInfo[h][hYo], HouseInfo[h][hZo]) && GetPlayerVirtualWorld(playerid) == HouseInfo[h][hVwOut])
		{
			if(HouseInfo[h][hOwned] == 0) // For Sale
            {
            	new class[32];

            	switch(HouseInfo[h][hClass])
            	{
            		case 1: format(class, sizeof(class), "Small");
            		case 2: format(class, sizeof(class), "Medium");
            		case 3: format(class, sizeof(class), "Large");
            		case 4: format(class, sizeof(class), "Mansion");
            	}

				format(string, sizeof(string), " ~w~Price: ~g~~h~ %s ~n~ ~w~Class: ~g~~h~%s ~n~~n~ ~w~Press ~r~~h~ 'H' ~w~to buy. ", FormatMoney(HouseInfo[h][hBuyValue]), class);
	            CreateLableText(playerid, "Property", string);
	            return 1;
			}
			else // Bought
			{
				format(string, sizeof(string), " ~w~Owned by: ~n~~g~ %s ~w~ ~n~~n~ ~w~Press ~r~~h~ 'H' ~w~to enter. ", HouseInfo[h][hOwner]);
            	CreateLableText(playerid, "Property", string);
            	return 1;
			}
		}
		else if(IsPlayerInRangeOfPoint(playerid, 2.0, HouseInfo[h][hgXo], HouseInfo[h][hgYo], HouseInfo[h][hgZo]) && GetPlayerVirtualWorld(playerid) == HouseInfo[h][hVwOut])
		{
			if(IsPlayerInAnyVehicle(playerid))
		    {
		        GameTextForPlayer(playerid, "~n~~n~~n~~n~~w~Press ~r~~h~~k~~VEHICLE_HANDBRAKE~ ~w~to enter the garage.", 2000, 4);
		        return 1;
		    }
		    else
		    {
			    CreateLableText(playerid, "~w~Garage", " ~w~Press ~r~~h~ 'H' ~w~to enter.");
			    return 1;
			}
		}
	}
    for(new h = 0; h < MAX_FACTIONS; h++)
    {
        if(FactionInfo[h][fUsed] != 0)
        {
            if(IsPlayerInRangeOfPoint(playerid,2.0,FactionInfo[h][fFact][0],FactionInfo[h][fFact][1],FactionInfo[h][fFact][2]))
            {
                format(string, sizeof(string), " ~r~%s ~n~ ~w~Press ~r~~h~ 'H' ~w~to navigate.", FactionInfo[h][fName]);
                CreateLableText(playerid,"Warehouse",string);
                return true;
            }
        }
    }
	if(GetPlayerVisibleDynamicCP(playerid) == FishCP) return 1;
    DisablePlayerCheckpoint(playerid);
	return 1;
}
//============================================//
public OnPlayerEnterRaceCheckpoint(playerid)
{
    if(IsPlayerNPC(playerid)) return 1;
    if(GetPVarInt(playerid, "Dead") == 1 || GetPVarInt(playerid, "Dead") == 2) return 1;
	if(GetPVarInt(playerid, "TakeTest") >= 1)
    {
        new id = GetPVarInt(playerid, "TakeTest");
        if(id != sizeof(DMVRoute))
		{
		    if(IsPlayerInRangeOfPoint(playerid, 20.0, DMVRoute[id-1][0], DMVRoute[id-1][1], DMVRoute[id-1][2]))
		    {
			    SetPVarInt(playerid, "TakeTest", id+1);
			    if(id+1 == sizeof(DMVRoute)) SetPlayerRaceCheckpoint(playerid, 1, DMVRoute[id][0], DMVRoute[id][1], DMVRoute[id][2], DMVRoute[id][0], DMVRoute[id][1], DMVRoute[id][2], 5.0);
			    else SetPlayerRaceCheckpoint(playerid, 0, DMVRoute[id][0], DMVRoute[id][1], DMVRoute[id][2], DMVRoute[id+1][0], DMVRoute[id+1][1], DMVRoute[id+1][2], 5.0);
		    }
		}
		else
		{
		    DisablePlayerRaceCheckpoint(playerid);
		    new Float:health;
            GetVehicleHealth(GetPlayerVehicleID(playerid),health);
            if(health <= 500.0) PrintTestResult(playerid, 2, "Vehicle Is Too Damaged");
            else if(GetPVarInt(playerid, "TestTime") >= 301) PrintTestResult(playerid, 2, "Too Slow");
            else if(GetPVarInt(playerid, "TestTime") <= 90) PrintTestResult(playerid, 2, "Too Fast");
            else if(GetPVarFloat(playerid,"TestSpeed") >= 95.0) PrintTestResult(playerid, 2, "Broke Speed Limit");
            else
            {
                PlayAudioStreamForPlayer(playerid, "http://k007.kiwi6.com/hotlink/jsprrwci5z/tone");
                PrintTestResult(playerid, 1, "All Qualifications Correct");
                SetPVarInt(playerid, "DriveLic", 1);
            }
			DespawnVehicle(GetPVarInt(playerid, "TestVeh"));
			DeletePVar(playerid, "TakeTest"), DeletePVar(playerid, "TestVeh");
		}
    }
	return true;
}
//============================================//
public OnPlayerEnterDynamicCP(playerid, checkpointid) {
	if(IsPlayerNPC(playerid)) return 1;
	if(GetPVarInt(playerid, "Dead") > 0) return 1;
	if(checkpointid == FishCP) {
		ClearAnimations(playerid);
		SellFish(playerid);
		return 1;
	}
	return 1;
}
//============================================//