/* Commands */

COMMAND:mdc(playerid, params[]) {
	if(GetPVarInt(playerid, "mdc_shown") != 0) return SendClientMessage(playerid, COLOR_GREY, "You already have the Mobile Data Computer opened (Reminder: Use /cursor to get your cursor back active).");
    if(GetPVarInt(playerid, "Member") != 1 && GetPVarInt(playerid, "Member") != 8) return SendClientMessage(playerid, COLOR_GREY, "You have to be a police officer or government official to access the Mobile Data Computer.");
	new vehicleID = GetPlayerVehicleID(playerid),
		bool:access = false;
		
	if(VehicleInfo[vehicleID][vType] == VEHICLE_LSPD || VehicleInfo[vehicleID][vType] == VEHICLE_GOV) {
		access = true;
	}
	
	if(access != true) {
        for(new i = 0; i < sizeof(mdc_coordinates); i++) {
			if(IsPlayerInRangeOfPoint(playerid, MDC_DEFAULT_ACCESS_RANGE, mdc_coordinates[i][0], mdc_coordinates[i][1], mdc_coordinates[i][2])) {
			    access = true;
			}
		}
	}
	
	if(access == true) {
		mdc_ShowPlayerStartScreen(playerid);
		SendClientMessage(playerid, COLOR_BLUE, "[TIP] {FFFFFF}Press ESC to disable the cursor and use /cursor to get your cursor back active.");
		SetPVarInt(playerid, "mdc_shown", 1);
	} else {
        SendClientMessage(playerid, COLOR_GREY, "You are not close to a computer of the Los Santos Police Department and are not in a government vehicle equipped with a Mobile Data Computer.");
	}
	
	return 1;
}

COMMAND:cursor(playerid, params) {
	SelectTextDraw(playerid, -1);
	return 1;
}
	
/* Functions */

stock mdc_LoadTextdraws() {
    td_mdc_Box = TextDrawCreate(442.000000, 178.000000, "New Textdraw");
	TextDrawBackgroundColor(td_mdc_Box, 255);
	TextDrawFont(td_mdc_Box, 1);
	TextDrawLetterSize(td_mdc_Box, 0.000000, 6.399999);
	TextDrawColor(td_mdc_Box, -1);
	TextDrawSetOutline(td_mdc_Box, 0);
	TextDrawSetProportional(td_mdc_Box, 1);
	TextDrawSetShadow(td_mdc_Box, 1);
	TextDrawUseBox(td_mdc_Box, 1);
	TextDrawBoxColor(td_mdc_Box, 125);
	TextDrawTextSize(td_mdc_Box, 198.000000, 0.000000);
	TextDrawSetSelectable(td_mdc_Box, 0);

    td_mdc_HeaderBox = TextDrawCreate(442.000000, 178.000000, "New Textdraw");
	TextDrawBackgroundColor(td_mdc_HeaderBox, 255);
	TextDrawFont(td_mdc_HeaderBox, 1);
	TextDrawLetterSize(td_mdc_HeaderBox, 0.000000, 1.799998);
	TextDrawColor(td_mdc_HeaderBox, -1);
	TextDrawSetOutline(td_mdc_HeaderBox, 0);
	TextDrawSetProportional(td_mdc_HeaderBox, 1);
	TextDrawSetShadow(td_mdc_HeaderBox, 1);
	TextDrawUseBox(td_mdc_HeaderBox, 1);
	TextDrawBoxColor(td_mdc_HeaderBox, 100);
	TextDrawTextSize(td_mdc_HeaderBox, 198.000000, 0.000000);
	TextDrawSetSelectable(td_mdc_HeaderBox, 0);
	
	td_mdc_CitizenBox = TextDrawCreate(442.000000, 178.000000, "New Textdraw");
	TextDrawBackgroundColor(td_mdc_CitizenBox, 255);
	TextDrawFont(td_mdc_CitizenBox, 1);
	TextDrawLetterSize(td_mdc_CitizenBox, 0.000000, 11.699997);
	TextDrawColor(td_mdc_CitizenBox, -1);
	TextDrawSetOutline(td_mdc_CitizenBox, 0);
	TextDrawSetProportional(td_mdc_CitizenBox, 1);
	TextDrawSetShadow(td_mdc_CitizenBox, 1);
	TextDrawUseBox(td_mdc_CitizenBox, 1);
	TextDrawBoxColor(td_mdc_CitizenBox, 125);
	TextDrawTextSize(td_mdc_CitizenBox, 198.000000, 0.000000);
	TextDrawSetSelectable(td_mdc_CitizenBox, 0);

	td_mdc_DataBox = TextDrawCreate(432.000000, 223.000000, "New Textdraw");
	TextDrawBackgroundColor(td_mdc_DataBox, 255);
	TextDrawFont(td_mdc_DataBox, 1);
	TextDrawLetterSize(td_mdc_DataBox, 0.000000, 5.199998);
	TextDrawColor(td_mdc_DataBox, -1);
	TextDrawSetOutline(td_mdc_DataBox, 0);
	TextDrawSetProportional(td_mdc_DataBox, 1);
	TextDrawSetShadow(td_mdc_DataBox, 1);
	TextDrawUseBox(td_mdc_DataBox, 1);
	TextDrawBoxColor(td_mdc_DataBox, 125);
	TextDrawTextSize(td_mdc_DataBox, 255.000000, 0.000000);
	TextDrawSetSelectable(td_mdc_DataBox, 0);

	td_mdc_OptionsBox = TextDrawCreate(432.000000, 329.000000, "New Textdraw");
	TextDrawBackgroundColor(td_mdc_OptionsBox, 255);
	TextDrawFont(td_mdc_OptionsBox, 1);
	TextDrawLetterSize(td_mdc_OptionsBox, 0.000000, 2.699999);
	TextDrawColor(td_mdc_OptionsBox, -1);
	TextDrawSetOutline(td_mdc_OptionsBox, 0);
	TextDrawSetProportional(td_mdc_OptionsBox, 1);
	TextDrawSetShadow(td_mdc_OptionsBox, 1);
	TextDrawUseBox(td_mdc_OptionsBox, 1);
	TextDrawBoxColor(td_mdc_OptionsBox, 125);
	TextDrawTextSize(td_mdc_OptionsBox, 208.000000, -70.000000);
	TextDrawSetSelectable(td_mdc_OptionsBox, 0);
	
	for(new i = 0; i < sizeof(td_mdc_cr_Box); i++) {
		td_mdc_cr_Box[i] = TextDrawCreate(442.000000, 178.000000, "New Textdraw");
		TextDrawBackgroundColor(td_mdc_cr_Box[i], 255);
		TextDrawFont(td_mdc_cr_Box[i], 1);
		TextDrawLetterSize(td_mdc_cr_Box[i], 0.000000, 5.4999 + i * 0.8167);
		TextDrawColor(td_mdc_cr_Box[i], -1);
		TextDrawSetOutline(td_mdc_cr_Box[i], 0);
		TextDrawSetProportional(td_mdc_cr_Box[i], 1);
		TextDrawSetShadow(td_mdc_cr_Box[i], 1);
		TextDrawUseBox(td_mdc_cr_Box[i], 1);
		TextDrawBoxColor(td_mdc_cr_Box[i], 125);
		TextDrawTextSize(td_mdc_cr_Box[i], 198.000000, 0.000000);
		TextDrawSetSelectable(td_mdc_cr_Box[i], 0);
	}

    for(new i = 0; i < sizeof(td_mdc_cr_InnerBox); i++) {
		td_mdc_cr_InnerBox[i] = TextDrawCreate(432.000000, 228.000000, "New Textdraw");
		TextDrawBackgroundColor(td_mdc_cr_InnerBox[i], 255);
		TextDrawFont(td_mdc_cr_InnerBox[i], 1);
		TextDrawLetterSize(td_mdc_cr_InnerBox[i], 0.000000, 2.0999 + i * 0.8167);
		TextDrawColor(td_mdc_cr_InnerBox[i], -1);
		TextDrawSetOutline(td_mdc_cr_InnerBox[i], 0);
		TextDrawSetProportional(td_mdc_cr_InnerBox[i], 1);
		TextDrawSetShadow(td_mdc_cr_InnerBox[i], 1);
		TextDrawUseBox(td_mdc_cr_InnerBox[i], 1);
		TextDrawBoxColor(td_mdc_cr_InnerBox[i], 100);
		TextDrawTextSize(td_mdc_cr_InnerBox[i], 208.000000, 0.000000);
		TextDrawSetSelectable(td_mdc_cr_InnerBox[i], 1);
	}
	
	td_mdc_veh_Box = TextDrawCreate(442.000000, 178.000000, "New Textdraw");
	TextDrawBackgroundColor(td_mdc_veh_Box, 255);
	TextDrawFont(td_mdc_veh_Box, 1);
	TextDrawLetterSize(td_mdc_veh_Box, 0.000000, 6.299985);
	TextDrawColor(td_mdc_veh_Box, -1);
	TextDrawSetOutline(td_mdc_veh_Box, 0);
	TextDrawSetProportional(td_mdc_veh_Box, 1);
	TextDrawSetShadow(td_mdc_veh_Box, 1);
	TextDrawUseBox(td_mdc_veh_Box, 1);
	TextDrawBoxColor(td_mdc_veh_Box, 125);
	TextDrawTextSize(td_mdc_veh_Box, 198.000000, 0.000000);
	TextDrawSetSelectable(td_mdc_veh_Box, 0);
	
	td_mdc_veh_InnerBox = TextDrawCreate(432.000000, 223.000000, "New Textdraw");
	TextDrawBackgroundColor(td_mdc_veh_InnerBox, 255);
	TextDrawFont(td_mdc_veh_InnerBox, 1);
	TextDrawLetterSize(td_mdc_veh_InnerBox, 0.000000, 3.199998);
	TextDrawColor(td_mdc_veh_InnerBox, -1);
	TextDrawSetOutline(td_mdc_veh_InnerBox, 0);
	TextDrawSetProportional(td_mdc_veh_InnerBox, 1);
	TextDrawSetShadow(td_mdc_veh_InnerBox, 1);
	TextDrawUseBox(td_mdc_veh_InnerBox, 1);
	TextDrawBoxColor(td_mdc_veh_InnerBox, 100);
	TextDrawTextSize(td_mdc_veh_InnerBox, 255.000000, -10.000000);
	TextDrawSetSelectable(td_mdc_veh_InnerBox, 1);
	
	td_mdc_veh_BoxNoEnt = TextDrawCreate(442.000000, 178.000000, "New Textdraw");
	TextDrawBackgroundColor(td_mdc_veh_BoxNoEnt, 255);
	TextDrawFont(td_mdc_veh_BoxNoEnt, 1);
	TextDrawLetterSize(td_mdc_veh_BoxNoEnt, 0.000000, 4.199985);
	TextDrawColor(td_mdc_veh_BoxNoEnt, -1);
	TextDrawSetOutline(td_mdc_veh_BoxNoEnt, 0);
	TextDrawSetProportional(td_mdc_veh_BoxNoEnt, 1);
	TextDrawSetShadow(td_mdc_veh_BoxNoEnt, 1);
	TextDrawUseBox(td_mdc_veh_BoxNoEnt, 1);
	TextDrawBoxColor(td_mdc_veh_BoxNoEnt, 125);
	TextDrawTextSize(td_mdc_veh_BoxNoEnt, 198.000000, 0.000000);
	TextDrawSetSelectable(td_mdc_veh_BoxNoEnt, 0);
	
	td_mdc_veh_InnerBoxNoEnt = TextDrawCreate(432.000000, 223.000000, "New Textdraw");
	TextDrawBackgroundColor(td_mdc_veh_InnerBoxNoEnt, 255);
	TextDrawFont(td_mdc_veh_InnerBoxNoEnt, 1);
	TextDrawLetterSize(td_mdc_veh_InnerBoxNoEnt, 0.000000, 1.199998);
	TextDrawColor(td_mdc_veh_InnerBoxNoEnt, -1);
	TextDrawSetOutline(td_mdc_veh_InnerBoxNoEnt, 0);
	TextDrawSetProportional(td_mdc_veh_InnerBoxNoEnt, 1);
	TextDrawSetShadow(td_mdc_veh_InnerBoxNoEnt, 1);
	TextDrawUseBox(td_mdc_veh_InnerBoxNoEnt, 1);
	TextDrawBoxColor(td_mdc_veh_InnerBoxNoEnt, 100);
	TextDrawTextSize(td_mdc_veh_InnerBoxNoEnt, 255.000000, -10.000000);
	TextDrawSetSelectable(td_mdc_veh_InnerBoxNoEnt, 1);
	
	td_mdc_veh_TextNoEnt = TextDrawCreate(267.000000, 228.000000, "No entries could be found.");
	TextDrawBackgroundColor(td_mdc_veh_TextNoEnt, 255);
	TextDrawFont(td_mdc_veh_TextNoEnt, 2);
	TextDrawLetterSize(td_mdc_veh_TextNoEnt, 0.170000, 1.000000);
	TextDrawColor(td_mdc_veh_TextNoEnt, -1);
	TextDrawSetOutline(td_mdc_veh_TextNoEnt, 0);
	TextDrawSetProportional(td_mdc_veh_TextNoEnt, 1);
	TextDrawSetShadow(td_mdc_veh_TextNoEnt, 1);
	TextDrawSetSelectable(td_mdc_veh_TextNoEnt, 0);

	td_mdc_veh_Model = TextDrawCreate(329.000000, 228.000000, "~b~~h~~h~~h~Model Name:");
	TextDrawAlignment(td_mdc_veh_Model, 3);
	TextDrawBackgroundColor(td_mdc_veh_Model, 255);
	TextDrawFont(td_mdc_veh_Model, 2);
	TextDrawLetterSize(td_mdc_veh_Model, 0.170000, 1.000000);
	TextDrawColor(td_mdc_veh_Model, -524057345);
	TextDrawSetOutline(td_mdc_veh_Model, 0);
	TextDrawSetProportional(td_mdc_veh_Model, 1);
	TextDrawSetShadow(td_mdc_veh_Model, 1);
	TextDrawSetSelectable(td_mdc_veh_Model, 0);
	
	td_mdc_veh_Owner = TextDrawCreate(329.000000, 240.000000, "~b~~h~~h~~h~Owner:");
	TextDrawAlignment(td_mdc_veh_Owner, 3);
	TextDrawBackgroundColor(td_mdc_veh_Owner, 255);
	TextDrawFont(td_mdc_veh_Owner, 2);
	TextDrawLetterSize(td_mdc_veh_Owner, 0.170000, 1.000000);
	TextDrawColor(td_mdc_veh_Owner, -524057345);
	TextDrawSetOutline(td_mdc_veh_Owner, 0);
	TextDrawSetProportional(td_mdc_veh_Owner, 1);
	TextDrawSetShadow(td_mdc_veh_Owner, 1);
	TextDrawSetSelectable(td_mdc_veh_Owner, 0);

	td_mdc_veh_Plate = TextDrawCreate(329.000000, 252.000000, "~b~~h~~h~~h~License Plate:");
	TextDrawAlignment(td_mdc_veh_Plate, 3);
	TextDrawBackgroundColor(td_mdc_veh_Plate, 255);
	TextDrawFont(td_mdc_veh_Plate, 2);
	TextDrawLetterSize(td_mdc_veh_Plate, 0.170000, 1.000000);
	TextDrawColor(td_mdc_veh_Plate, -524057345);
	TextDrawSetOutline(td_mdc_veh_Plate, 0);
	TextDrawSetProportional(td_mdc_veh_Plate, 1);
	TextDrawSetShadow(td_mdc_veh_Plate, 1);
	TextDrawSetSelectable(td_mdc_veh_Plate, 0);

	td_mdc_veh_Insurance = TextDrawCreate(329.000000, 264.000000, "~b~~h~~h~~h~Insurance:");
	TextDrawAlignment(td_mdc_veh_Insurance, 3);
	TextDrawBackgroundColor(td_mdc_veh_Insurance, 255);
	TextDrawFont(td_mdc_veh_Insurance, 2);
	TextDrawLetterSize(td_mdc_veh_Insurance, 0.170000, 1.000000);
	TextDrawColor(td_mdc_veh_Insurance, -524057345);
	TextDrawSetOutline(td_mdc_veh_Insurance, 0);
	TextDrawSetProportional(td_mdc_veh_Insurance, 1);
	TextDrawSetShadow(td_mdc_veh_Insurance, 1);
	TextDrawSetSelectable(td_mdc_veh_Insurance, 0);
	
	td_mdc_veh_ArrowRight = TextDrawCreate(425.000000, 276.000000, "LD_BEAT:right");
	TextDrawBackgroundColor(td_mdc_veh_ArrowRight, 255);
	TextDrawFont(td_mdc_veh_ArrowRight, 4);
	TextDrawLetterSize(td_mdc_veh_ArrowRight, 0.500000, 1.000000);
	TextDrawColor(td_mdc_veh_ArrowRight, -1);
	TextDrawSetOutline(td_mdc_veh_ArrowRight, 0);
	TextDrawSetProportional(td_mdc_veh_ArrowRight, 1);
	TextDrawSetShadow(td_mdc_veh_ArrowRight, 1);
	TextDrawUseBox(td_mdc_veh_ArrowRight, 1);
	TextDrawBoxColor(td_mdc_veh_ArrowRight, 255);
	TextDrawTextSize(td_mdc_veh_ArrowRight, 10.000000, 12.000000);
	TextDrawSetSelectable(td_mdc_veh_ArrowRight, 1);

	td_mdc_veh_Next = TextDrawCreate(404.000000, 276.000000, "~b~~h~~h~~h~Next");
	TextDrawBackgroundColor(td_mdc_veh_Next, 255);
	TextDrawFont(td_mdc_veh_Next, 2);
	TextDrawLetterSize(td_mdc_veh_Next, 0.170000, 1.000000);
	TextDrawColor(td_mdc_veh_Next, -1);
	TextDrawSetOutline(td_mdc_veh_Next, 0);
	TextDrawSetProportional(td_mdc_veh_Next, 1);
	TextDrawSetShadow(td_mdc_veh_Next, 1);
	TextDrawTextSize(td_mdc_veh_Next, 423.000000, 152.000000);
	TextDrawSetSelectable(td_mdc_veh_Next, 1);

	td_mdc_veh_Label = TextDrawCreate(254.000000, 217.000000, "~b~Vehicles");
	TextDrawBackgroundColor(td_mdc_veh_Label, 255);
	TextDrawFont(td_mdc_veh_Label, 2);
	TextDrawLetterSize(td_mdc_veh_Label, 0.170000, 1.000000);
	TextDrawColor(td_mdc_veh_Label, -1384438529);
	TextDrawSetOutline(td_mdc_veh_Label, 0);
	TextDrawSetProportional(td_mdc_veh_Label, 1);
	TextDrawSetShadow(td_mdc_veh_Label, 1);
	TextDrawSetPreviewModel(td_mdc_veh_Label, 480);
	TextDrawSetPreviewRot(td_mdc_veh_Label, -16.000000, 0.000000, -55.000000, 1.000000);
	TextDrawSetSelectable(td_mdc_veh_Label, 0);
	
	td_mdc_HeaderText = TextDrawCreate(209.000000, 189.000000, "~b~~h~Mobile Data Computer");
	TextDrawBackgroundColor(td_mdc_HeaderText, 255);
	TextDrawFont(td_mdc_HeaderText, 2);
	TextDrawLetterSize(td_mdc_HeaderText, 0.219999, 1.200000);
	TextDrawColor(td_mdc_HeaderText, -1384438529);
	TextDrawSetOutline(td_mdc_HeaderText, 0);
	TextDrawSetProportional(td_mdc_HeaderText, 1);
	TextDrawSetShadow(td_mdc_HeaderText, 1);
	TextDrawSetSelectable(td_mdc_HeaderText, 0);

	td_mdc_Exit = TextDrawCreate(420.000000, 189.000000, "LD_BEAT:cross");
	TextDrawBackgroundColor(td_mdc_Exit, 255);
	TextDrawFont(td_mdc_Exit, 4);
	TextDrawLetterSize(td_mdc_Exit, 0.500000, 1.000000);
	TextDrawColor(td_mdc_Exit, -1);
	TextDrawSetOutline(td_mdc_Exit, 0);
	TextDrawSetProportional(td_mdc_Exit, 1);
	TextDrawSetShadow(td_mdc_Exit, 1);
	TextDrawUseBox(td_mdc_Exit, 1);
	TextDrawBoxColor(td_mdc_Exit, 255);
	TextDrawTextSize(td_mdc_Exit, 10.000000, 12.000000);
	TextDrawSetSelectable(td_mdc_Exit, 1);

	td_mdc_Section[0] = TextDrawCreate(316.000000, 228.000000, "New Textdraw");
	TextDrawBackgroundColor(td_mdc_Section[0], 255);
	TextDrawFont(td_mdc_Section[0], 1);
	TextDrawLetterSize(td_mdc_Section[0], 0.000000, 1.199999);
	TextDrawColor(td_mdc_Section[0], -1);
	TextDrawSetOutline(td_mdc_Section[0], 0);
	TextDrawSetProportional(td_mdc_Section[0], 1);
	TextDrawSetShadow(td_mdc_Section[0], 1);
	TextDrawUseBox(td_mdc_Section[0], 1);
	TextDrawBoxColor(td_mdc_Section[0], 100);
	TextDrawTextSize(td_mdc_Section[0], 208.000000, 0.000000);
	TextDrawSetSelectable(td_mdc_Section[0], 0);

	td_mdc_Section[1] = TextDrawCreate(316.000000, 257.000000, "New Textdraw");
	TextDrawBackgroundColor(td_mdc_Section[1], 255);
	TextDrawFont(td_mdc_Section[1], 1);
	TextDrawLetterSize(td_mdc_Section[1], 0.000000, 1.199999);
	TextDrawColor(td_mdc_Section[1], -1);
	TextDrawSetOutline(td_mdc_Section[1], 0);
	TextDrawSetProportional(td_mdc_Section[1], 1);
	TextDrawSetShadow(td_mdc_Section[1], 1);
	TextDrawUseBox(td_mdc_Section[1], 1);
	TextDrawBoxColor(td_mdc_Section[1], 100);
	TextDrawTextSize(td_mdc_Section[1], 208.000000, 0.000000);
	TextDrawSetSelectable(td_mdc_Section[1], 0);

	td_mdc_Section[2] = TextDrawCreate(432.000000, 257.000000, "New Textdraw");
	TextDrawBackgroundColor(td_mdc_Section[2], 255);
	TextDrawFont(td_mdc_Section[2], 1);
	TextDrawLetterSize(td_mdc_Section[2], 0.000000, 1.199999);
	TextDrawColor(td_mdc_Section[2], -1);
	TextDrawSetOutline(td_mdc_Section[2], 0);
	TextDrawSetProportional(td_mdc_Section[2], 1);
	TextDrawSetShadow(td_mdc_Section[2], 1);
	TextDrawUseBox(td_mdc_Section[2], 1);
	TextDrawBoxColor(td_mdc_Section[2], 100);
	TextDrawTextSize(td_mdc_Section[2], 323.000000, 0.000000);
	TextDrawSetSelectable(td_mdc_Section[2], 0);

	td_mdc_Section[3] = TextDrawCreate(432.000000, 228.000000, "New Textdraw");
	TextDrawBackgroundColor(td_mdc_Section[3], 255);
	TextDrawFont(td_mdc_Section[3], 1);
	TextDrawLetterSize(td_mdc_Section[3], 0.000000, 1.199999);
	TextDrawColor(td_mdc_Section[3], -1);
	TextDrawSetOutline(td_mdc_Section[3], 0);
	TextDrawSetProportional(td_mdc_Section[3], 1);
	TextDrawSetShadow(td_mdc_Section[3], 1);
	TextDrawUseBox(td_mdc_Section[3], 1);
	TextDrawBoxColor(td_mdc_Section[3], 100);
	TextDrawTextSize(td_mdc_Section[3], 323.000000, 0.000000);
	TextDrawSetSelectable(td_mdc_Section[3], 0);

	td_mdc_SectionText[0] = TextDrawCreate(262.000000, 234.000000, "~b~~h~~h~~h~Search Citizen");
	TextDrawAlignment(td_mdc_SectionText[0], 2);
	TextDrawBackgroundColor(td_mdc_SectionText[0], 255);
	TextDrawFont(td_mdc_SectionText[0], 2);
	TextDrawLetterSize(td_mdc_SectionText[0], 0.170000, 1.000000);
	TextDrawColor(td_mdc_SectionText[0], -524057345);
	TextDrawSetOutline(td_mdc_SectionText[0], 0);
	TextDrawSetProportional(td_mdc_SectionText[0], 1);
	TextDrawSetShadow(td_mdc_SectionText[0], 1);
	TextDrawTextSize(td_mdc_SectionText[0], 15.000000, 102.000000);
	TextDrawSetSelectable(td_mdc_SectionText[0], 1);

	td_mdc_SectionText[1] = TextDrawCreate(262.000000, 263.000000, "~b~~h~~h~~h~Search Weapon Serial");
	TextDrawAlignment(td_mdc_SectionText[1], 2);
	TextDrawBackgroundColor(td_mdc_SectionText[1], 255);
	TextDrawFont(td_mdc_SectionText[1], 2);
	TextDrawLetterSize(td_mdc_SectionText[1], 0.170000, 1.000000);
	TextDrawColor(td_mdc_SectionText[1], -524057345);
	TextDrawSetOutline(td_mdc_SectionText[1], 0);
	TextDrawSetProportional(td_mdc_SectionText[1], 1);
	TextDrawSetShadow(td_mdc_SectionText[1], 1);
	TextDrawTextSize(td_mdc_SectionText[1], 15.000000, 102.000000);
	TextDrawSetSelectable(td_mdc_SectionText[1], 1);

	td_mdc_SectionText[2] = TextDrawCreate(378.000000, 263.000000, "~b~~h~~h~~h~Search Phone Number");
	TextDrawAlignment(td_mdc_SectionText[2], 2);
	TextDrawBackgroundColor(td_mdc_SectionText[2], 255);
	TextDrawFont(td_mdc_SectionText[2], 2);
	TextDrawLetterSize(td_mdc_SectionText[2], 0.170000, 1.000000);
	TextDrawColor(td_mdc_SectionText[2], -524057345);
	TextDrawSetOutline(td_mdc_SectionText[2], 0);
	TextDrawSetProportional(td_mdc_SectionText[2], 1);
	TextDrawSetShadow(td_mdc_SectionText[2], 1);
	TextDrawTextSize(td_mdc_SectionText[2], 15.000000, 102.000000);
	TextDrawSetSelectable(td_mdc_SectionText[2], 1);

	td_mdc_SectionText[3] = TextDrawCreate(378.000000, 234.000000, "~b~~h~~h~~h~Search License Plate");
	TextDrawAlignment(td_mdc_SectionText[3], 2);
	TextDrawBackgroundColor(td_mdc_SectionText[3], 255);
	TextDrawFont(td_mdc_SectionText[3], 2);
	TextDrawLetterSize(td_mdc_SectionText[3], 0.170000, 1.000000);
	TextDrawColor(td_mdc_SectionText[3], -524057345);
	TextDrawSetOutline(td_mdc_SectionText[3], 0);
	TextDrawSetProportional(td_mdc_SectionText[3], 1);
	TextDrawSetShadow(td_mdc_SectionText[3], 1);
	TextDrawTextSize(td_mdc_SectionText[3], 15.000000, 103.000000);
	TextDrawSetSelectable(td_mdc_SectionText[3], 1);

	td_mdc_SectionHeaderText = TextDrawCreate(207.000000, 220.000000, "~b~Sections");
	TextDrawBackgroundColor(td_mdc_SectionHeaderText, 255);
	TextDrawFont(td_mdc_SectionHeaderText, 2);
	TextDrawLetterSize(td_mdc_SectionHeaderText, 0.170000, 1.000000);
	TextDrawColor(td_mdc_SectionHeaderText, -1384438529);
	TextDrawSetOutline(td_mdc_SectionHeaderText, 0);
	TextDrawSetProportional(td_mdc_SectionHeaderText, 1);
	TextDrawSetShadow(td_mdc_SectionHeaderText, 1);
	TextDrawSetSelectable(td_mdc_SectionHeaderText, 0);
	
	td_mdc_Gender = TextDrawCreate(329.000000, 252.000000, "~b~~h~~h~~h~Gender:");
	TextDrawAlignment(td_mdc_Gender, 3);
	TextDrawBackgroundColor(td_mdc_Gender, 255);
	TextDrawFont(td_mdc_Gender, 2);
	TextDrawLetterSize(td_mdc_Gender, 0.170000, 1.000000);
	TextDrawColor(td_mdc_Gender, -524057345);
	TextDrawSetOutline(td_mdc_Gender, 0);
	TextDrawSetProportional(td_mdc_Gender, 1);
	TextDrawSetShadow(td_mdc_Gender, 1);
	TextDrawSetSelectable(td_mdc_Gender, 0);
	
	td_mdc_Job = TextDrawCreate(329.000000, 264.000000, "~b~~h~~h~~h~Occupation:");
	TextDrawAlignment(td_mdc_Job, 3);
	TextDrawBackgroundColor(td_mdc_Job, 255);
	TextDrawFont(td_mdc_Job, 2);
	TextDrawLetterSize(td_mdc_Job, 0.170000, 1.000000);
	TextDrawColor(td_mdc_Job, -524057345);
	TextDrawSetOutline(td_mdc_Job, 0);
	TextDrawSetProportional(td_mdc_Job, 1);
	TextDrawSetShadow(td_mdc_Job, 1);
	TextDrawSetSelectable(td_mdc_Job, 0);

	td_mdc_DriveLic = TextDrawCreate(329.000000, 276.000000, "~b~~h~~h~~h~Driver's License:");
	TextDrawAlignment(td_mdc_DriveLic, 3);
	TextDrawBackgroundColor(td_mdc_DriveLic, 255);
	TextDrawFont(td_mdc_DriveLic, 2);
	TextDrawLetterSize(td_mdc_DriveLic, 0.170000, 1.000000);
	TextDrawColor(td_mdc_DriveLic, -524057345);
	TextDrawSetOutline(td_mdc_DriveLic, 0);
	TextDrawSetProportional(td_mdc_DriveLic, 1);
	TextDrawSetShadow(td_mdc_DriveLic, 1);
	TextDrawSetSelectable(td_mdc_DriveLic, 0);

	td_mdc_GunLic = TextDrawCreate(329.000000, 288.000000, "~b~~h~~h~~h~Weapon License:");
	TextDrawAlignment(td_mdc_GunLic, 3);
	TextDrawBackgroundColor(td_mdc_GunLic, 255);
	TextDrawFont(td_mdc_GunLic, 2);
	TextDrawLetterSize(td_mdc_GunLic, 0.170000, 1.000000);
	TextDrawColor(td_mdc_GunLic, -524057345);
	TextDrawSetOutline(td_mdc_GunLic, 0);
	TextDrawSetProportional(td_mdc_GunLic, 1);
	TextDrawSetShadow(td_mdc_GunLic, 1);
	TextDrawSetSelectable(td_mdc_GunLic, 0);

	td_mdc_PhoneNumber = TextDrawCreate(329.000000, 300.000000, "~b~~h~~h~~h~Phone Number:");
	TextDrawAlignment(td_mdc_PhoneNumber, 3);
	TextDrawBackgroundColor(td_mdc_PhoneNumber, 255);
	TextDrawFont(td_mdc_PhoneNumber, 2);
	TextDrawLetterSize(td_mdc_PhoneNumber, 0.170000, 1.000000);
	TextDrawColor(td_mdc_PhoneNumber, -524057345);
	TextDrawSetOutline(td_mdc_PhoneNumber, 0);
	TextDrawSetProportional(td_mdc_PhoneNumber, 1);
	TextDrawSetShadow(td_mdc_PhoneNumber, 1);
	TextDrawSetSelectable(td_mdc_PhoneNumber, 0);
	
	td_mdc_Name = TextDrawCreate(329.000000, 228.000000, "~b~~h~~h~~h~Full Name:");
	TextDrawAlignment(td_mdc_Name, 3);
	TextDrawBackgroundColor(td_mdc_Name, 255);
	TextDrawFont(td_mdc_Name, 2);
	TextDrawLetterSize(td_mdc_Name, 0.170000, 1.000000);
	TextDrawColor(td_mdc_Name, -524057345);
	TextDrawSetOutline(td_mdc_Name, 0);
	TextDrawSetProportional(td_mdc_Name, 1);
	TextDrawSetShadow(td_mdc_Name, 1);
	TextDrawSetSelectable(td_mdc_Name, 0);

	td_mdc_PropertiesArrow = TextDrawCreate(411.000000, 357.000000, "LD_BEAT:right");
	TextDrawBackgroundColor(td_mdc_PropertiesArrow, 255);
	TextDrawFont(td_mdc_PropertiesArrow, 4);
	TextDrawLetterSize(td_mdc_PropertiesArrow, 0.500000, 1.000000);
	TextDrawColor(td_mdc_PropertiesArrow, -1);
	TextDrawSetOutline(td_mdc_PropertiesArrow, 0);
	TextDrawSetProportional(td_mdc_PropertiesArrow, 1);
	TextDrawSetShadow(td_mdc_PropertiesArrow, 1);
	TextDrawUseBox(td_mdc_PropertiesArrow, 1);
	TextDrawBoxColor(td_mdc_PropertiesArrow, 255);
	TextDrawTextSize(td_mdc_PropertiesArrow, 10.000000, 14.000000);
	TextDrawSetSelectable(td_mdc_PropertiesArrow, 1);

	td_mdc_VehiclesArrow = TextDrawCreate(411.000000, 337.000000, "LD_BEAT:right");
	TextDrawBackgroundColor(td_mdc_VehiclesArrow, 255);
	TextDrawFont(td_mdc_VehiclesArrow, 4);
	TextDrawLetterSize(td_mdc_VehiclesArrow, 0.500000, 1.000000);
	TextDrawColor(td_mdc_VehiclesArrow, -1);
	TextDrawSetOutline(td_mdc_VehiclesArrow, 0);
	TextDrawSetProportional(td_mdc_VehiclesArrow, 1);
	TextDrawSetShadow(td_mdc_VehiclesArrow, 1);
	TextDrawUseBox(td_mdc_VehiclesArrow, 1);
	TextDrawBoxColor(td_mdc_VehiclesArrow, 255);
	TextDrawTextSize(td_mdc_VehiclesArrow, 10.000000, 14.000000);
	TextDrawSetSelectable(td_mdc_VehiclesArrow, 1);

	td_mdc_Vehicles = TextDrawCreate(372.000000, 338.000000, "~b~~h~~h~~h~Vehicles");
	TextDrawBackgroundColor(td_mdc_Vehicles, 255);
	TextDrawFont(td_mdc_Vehicles, 2);
	TextDrawLetterSize(td_mdc_Vehicles, 0.170000, 1.000000);
	TextDrawColor(td_mdc_Vehicles, -524057345);
	TextDrawSetOutline(td_mdc_Vehicles, 0);
	TextDrawSetProportional(td_mdc_Vehicles, 1);
	TextDrawSetShadow(td_mdc_Vehicles, 1);
	TextDrawTextSize(td_mdc_Vehicles, 410.0, 20.0);
	TextDrawSetSelectable(td_mdc_Vehicles, 1);

	td_mdc_Properties = TextDrawCreate(363.000000, 358.000000, "~b~~h~~h~~h~Properties");
	TextDrawBackgroundColor(td_mdc_Properties, 255);
	TextDrawFont(td_mdc_Properties, 2);
	TextDrawLetterSize(td_mdc_Properties, 0.170000, 1.000000);
	TextDrawColor(td_mdc_Properties, -524057345);
	TextDrawSetOutline(td_mdc_Properties, 0);
	TextDrawSetProportional(td_mdc_Properties, 1);
	TextDrawSetShadow(td_mdc_Properties, 1);
	TextDrawTextSize(td_mdc_Properties, 410.0, 20.0);
	TextDrawSetSelectable(td_mdc_Properties, 1);

	td_mdc_Age = TextDrawCreate(329.000000, 240.000000, "~b~~h~~h~~h~Age:");
	TextDrawAlignment(td_mdc_Age, 3);
	TextDrawBackgroundColor(td_mdc_Age, 255);
	TextDrawFont(td_mdc_Age, 2);
	TextDrawLetterSize(td_mdc_Age, 0.170000, 1.000000);
	TextDrawColor(td_mdc_Age, -524057345);
	TextDrawSetOutline(td_mdc_Age, 0);
	TextDrawSetProportional(td_mdc_Age, 1);
	TextDrawSetShadow(td_mdc_Age, 1);
	TextDrawSetSelectable(td_mdc_Age, 0);

	td_mdc_CasesArrow = TextDrawCreate(219.000000, 357.000000, "LD_BEAT:left");
	TextDrawBackgroundColor(td_mdc_CasesArrow, 255);
	TextDrawFont(td_mdc_CasesArrow, 4);
	TextDrawLetterSize(td_mdc_CasesArrow, 0.500000, 1.000000);
	TextDrawColor(td_mdc_CasesArrow, -1);
	TextDrawSetOutline(td_mdc_CasesArrow, 0);
	TextDrawSetProportional(td_mdc_CasesArrow, 1);
	TextDrawSetShadow(td_mdc_CasesArrow, 1);
	TextDrawUseBox(td_mdc_CasesArrow, 1);
	TextDrawBoxColor(td_mdc_CasesArrow, 255);
	TextDrawTextSize(td_mdc_CasesArrow, 10.000000, 14.000000);
	TextDrawSetSelectable(td_mdc_CasesArrow, 1);

	td_mdc_CriminalRecordArrow = TextDrawCreate(219.000000, 337.000000, "LD_BEAT:left");
	TextDrawBackgroundColor(td_mdc_CriminalRecordArrow, 255);
	TextDrawFont(td_mdc_CriminalRecordArrow, 4);
	TextDrawLetterSize(td_mdc_CriminalRecordArrow, 0.500000, 1.000000);
	TextDrawColor(td_mdc_CriminalRecordArrow, -1);
	TextDrawSetOutline(td_mdc_CriminalRecordArrow, 0);
	TextDrawSetProportional(td_mdc_CriminalRecordArrow, 1);
	TextDrawSetShadow(td_mdc_CriminalRecordArrow, 1);
	TextDrawUseBox(td_mdc_CriminalRecordArrow, 1);
	TextDrawBoxColor(td_mdc_CriminalRecordArrow, 255);
	TextDrawTextSize(td_mdc_CriminalRecordArrow, 10.000000, 14.000000);
	TextDrawSetSelectable(td_mdc_CriminalRecordArrow, 1);

	td_mdc_CriminalRecord = TextDrawCreate(233.000000, 338.000000, "~b~~h~~h~~h~Criminal Record");
	TextDrawBackgroundColor(td_mdc_CriminalRecord, 255);
	TextDrawFont(td_mdc_CriminalRecord, 2);
	TextDrawLetterSize(td_mdc_CriminalRecord, 0.170000, 1.000000);
	TextDrawColor(td_mdc_CriminalRecord, -524057345);
	TextDrawSetOutline(td_mdc_CriminalRecord, 0);
	TextDrawSetProportional(td_mdc_CriminalRecord, 1);
	TextDrawSetShadow(td_mdc_CriminalRecord, 1);
	TextDrawTextSize(td_mdc_CriminalRecord, 294.0, 20.0);
	TextDrawSetSelectable(td_mdc_CriminalRecord, 1);

	td_mdc_Cases = TextDrawCreate(233.000000, 358.000000, "~b~~h~~h~~h~Cases");
	TextDrawBackgroundColor(td_mdc_Cases, 255);
	TextDrawFont(td_mdc_Cases, 2);
	TextDrawLetterSize(td_mdc_Cases, 0.170000, 1.000000);
	TextDrawColor(td_mdc_Cases, -524057345);
	TextDrawSetOutline(td_mdc_Cases, 0);
	TextDrawSetProportional(td_mdc_Cases, 1);
	TextDrawSetShadow(td_mdc_Cases, 1);
    TextDrawTextSize(td_mdc_Cases, 260.0, 20.0);
	TextDrawSetSelectable(td_mdc_Cases, 1);

	td_mdc_Browse = TextDrawCreate(207.000000, 321.000000, "~b~Browse");
	TextDrawBackgroundColor(td_mdc_Browse, 255);
	TextDrawFont(td_mdc_Browse, 2);
	TextDrawLetterSize(td_mdc_Browse, 0.170000, 1.000000);
	TextDrawColor(td_mdc_Browse, -1384438529);
	TextDrawSetOutline(td_mdc_Browse, 0);
	TextDrawSetProportional(td_mdc_Browse, 1);
	TextDrawSetShadow(td_mdc_Browse, 1);
	TextDrawSetSelectable(td_mdc_Browse, 0);
	
	td_mdc_cr_TypeTitle = TextDrawCreate(220.000000, 234.000000, "~b~~h~~h~~h~Type");
	TextDrawBackgroundColor(td_mdc_cr_TypeTitle, 255);
	TextDrawFont(td_mdc_cr_TypeTitle, 2);
	TextDrawLetterSize(td_mdc_cr_TypeTitle, 0.170000, 1.000000);
	TextDrawColor(td_mdc_cr_TypeTitle, -524057345);
	TextDrawSetOutline(td_mdc_cr_TypeTitle, 0);
	TextDrawSetProportional(td_mdc_cr_TypeTitle, 1);
	TextDrawSetShadow(td_mdc_cr_TypeTitle, 1);
	TextDrawSetSelectable(td_mdc_cr_TypeTitle, 0);

	td_mdc_cr_DescriptionTitle = TextDrawCreate(257.000000, 234.000000, "~b~~h~~h~~h~Description");
	TextDrawBackgroundColor(td_mdc_cr_DescriptionTitle, 255);
	TextDrawFont(td_mdc_cr_DescriptionTitle, 2);
	TextDrawLetterSize(td_mdc_cr_DescriptionTitle, 0.170000, 1.000000);
	TextDrawColor(td_mdc_cr_DescriptionTitle, -524057345);
	TextDrawSetOutline(td_mdc_cr_DescriptionTitle, 0);
	TextDrawSetProportional(td_mdc_cr_DescriptionTitle, 1);
	TextDrawSetShadow(td_mdc_cr_DescriptionTitle, 1);
	TextDrawSetSelectable(td_mdc_cr_DescriptionTitle, 0);

	td_mdc_cr_DateTitle = TextDrawCreate(375.000000, 234.000000, "~b~~h~~h~~h~Date");
	TextDrawAlignment(td_mdc_cr_DateTitle, 2);
	TextDrawBackgroundColor(td_mdc_cr_DateTitle, 255);
	TextDrawFont(td_mdc_cr_DateTitle, 2);
	TextDrawLetterSize(td_mdc_cr_DateTitle, 0.170000, 1.000000);
	TextDrawColor(td_mdc_cr_DateTitle, -524057345);
	TextDrawSetOutline(td_mdc_cr_DateTitle, 0);
	TextDrawSetProportional(td_mdc_cr_DateTitle, 1);
	TextDrawSetShadow(td_mdc_cr_DateTitle, 1);
	TextDrawSetSelectable(td_mdc_cr_DateTitle, 0);
	
	for(new i = 0; i < sizeof(td_mdc_cr_Info); i++) {
		td_mdc_cr_Info[i] = TextDrawCreate(412.000000, 249.000000 + i * 15, "LD_CHAT:badchat");
		TextDrawBackgroundColor(td_mdc_cr_Info[i], 255);
		TextDrawFont(td_mdc_cr_Info[i], 4);
		TextDrawLetterSize(td_mdc_cr_Info[i], 0.500000, 1.000000);
		TextDrawColor(td_mdc_cr_Info[i], -1);
		TextDrawSetOutline(td_mdc_cr_Info[i], 0);
		TextDrawSetProportional(td_mdc_cr_Info[i], 1);
		TextDrawSetShadow(td_mdc_cr_Info[i], 1);
		TextDrawUseBox(td_mdc_cr_Info[i], 1);
		TextDrawBoxColor(td_mdc_cr_Info[i], 255);
		TextDrawTextSize(td_mdc_cr_Info[i], 8.000000, 9.000000);
		TextDrawSetSelectable(td_mdc_cr_Info[i], 1);
	}
	
	td_mdc_cr_ArrowDown = TextDrawCreate(425.000000, 351.000000, "LD_BEAT:down");
	TextDrawBackgroundColor(td_mdc_cr_ArrowDown, 255);
	TextDrawFont(td_mdc_cr_ArrowDown, 4);
	TextDrawLetterSize(td_mdc_cr_ArrowDown, 0.500000, 1.000000);
	TextDrawColor(td_mdc_cr_ArrowDown, -1);
	TextDrawSetOutline(td_mdc_cr_ArrowDown, 0);
	TextDrawSetProportional(td_mdc_cr_ArrowDown, 1);
	TextDrawSetShadow(td_mdc_cr_ArrowDown, 1);
	TextDrawUseBox(td_mdc_cr_ArrowDown, 1);
	TextDrawBoxColor(td_mdc_cr_ArrowDown, 255);
	TextDrawTextSize(td_mdc_cr_ArrowDown, 11.000000, 12.000000);
	TextDrawSetSelectable(td_mdc_cr_ArrowDown, 1);

	td_mdc_cr_ArrowUp = TextDrawCreate(425.000000, 335.000000, "LD_BEAT:up");
	TextDrawBackgroundColor(td_mdc_cr_ArrowUp, 255);
	TextDrawFont(td_mdc_cr_ArrowUp, 4);
	TextDrawLetterSize(td_mdc_cr_ArrowUp, 0.500000, 1.000000);
	TextDrawColor(td_mdc_cr_ArrowUp, -1);
	TextDrawSetOutline(td_mdc_cr_ArrowUp, 0);
	TextDrawSetProportional(td_mdc_cr_ArrowUp, 1);
	TextDrawSetShadow(td_mdc_cr_ArrowUp, 1);
	TextDrawUseBox(td_mdc_cr_ArrowUp, 1);
	TextDrawBoxColor(td_mdc_cr_ArrowUp, 255);
	TextDrawTextSize(td_mdc_cr_ArrowUp, 11.000000, 12.000000);
	TextDrawSetSelectable(td_mdc_cr_ArrowUp, 1);

	td_mdc_cr_Title = TextDrawCreate(207.000000, 220.000000, "~b~Criminal Record");
	TextDrawBackgroundColor(td_mdc_cr_Title, 255);
	TextDrawFont(td_mdc_cr_Title, 2);
	TextDrawLetterSize(td_mdc_cr_Title, 0.170000, 1.000000);
	TextDrawColor(td_mdc_cr_Title, -1384438529);
	TextDrawSetOutline(td_mdc_cr_Title, 0);
	TextDrawSetProportional(td_mdc_cr_Title, 1);
	TextDrawSetShadow(td_mdc_cr_Title, 1);
	TextDrawSetSelectable(td_mdc_cr_Title, 0);
}

stock mdc_LoadPlayerTextdraws(playerid) {
    td_mdc_Skin = CreatePlayerTextDraw(playerid, 264.000000, 231.000000, "New Textdraw");
	PlayerTextDrawBackgroundColor(playerid, td_mdc_Skin, 0);
	PlayerTextDrawFont(playerid, td_mdc_Skin, 5);
	PlayerTextDrawLetterSize(playerid, td_mdc_Skin, 0.500000, 1.000000);
	PlayerTextDrawColor(playerid, td_mdc_Skin, -1);
	PlayerTextDrawSetOutline(playerid, td_mdc_Skin, 0);
	PlayerTextDrawSetProportional(playerid, td_mdc_Skin, 1);
	PlayerTextDrawSetShadow(playerid, td_mdc_Skin, 1);
	PlayerTextDrawUseBox(playerid, td_mdc_Skin, 1);
	PlayerTextDrawBoxColor(playerid, td_mdc_Skin, 0);
	PlayerTextDrawTextSize(playerid, td_mdc_Skin, -70.000000, 80.000000);
	PlayerTextDrawSetPreviewModel(playerid, td_mdc_Skin, 107);
	PlayerTextDrawSetPreviewRot(playerid, td_mdc_Skin, -16.000000, 0.000000, -30.000000, 1.000000);
	PlayerTextDrawSetSelectable(playerid, td_mdc_Skin, 0);

	td_mdc_NameValue = CreatePlayerTextDraw(playerid, 338.000000, 228.000000, "Firstname Lastname");
	PlayerTextDrawBackgroundColor(playerid, td_mdc_NameValue, 255);
	PlayerTextDrawFont(playerid, td_mdc_NameValue, 2);
	PlayerTextDrawLetterSize(playerid, td_mdc_NameValue, 0.170000, 1.000000);
	PlayerTextDrawColor(playerid, td_mdc_NameValue, -1);
	PlayerTextDrawSetOutline(playerid, td_mdc_NameValue, 0);
	PlayerTextDrawSetProportional(playerid, td_mdc_NameValue, 1);
	PlayerTextDrawSetShadow(playerid, td_mdc_NameValue, 1);
	PlayerTextDrawSetSelectable(playerid, td_mdc_NameValue, 0);

	td_mdc_AgeValue = CreatePlayerTextDraw(playerid, 338.000000, 240.000000, "21");
	PlayerTextDrawBackgroundColor(playerid, td_mdc_AgeValue, 255);
	PlayerTextDrawFont(playerid, td_mdc_AgeValue, 2);
	PlayerTextDrawLetterSize(playerid, td_mdc_AgeValue, 0.170000, 1.000000);
	PlayerTextDrawColor(playerid, td_mdc_AgeValue, -1);
	PlayerTextDrawSetOutline(playerid, td_mdc_AgeValue, 0);
	PlayerTextDrawSetProportional(playerid, td_mdc_AgeValue, 1);
	PlayerTextDrawSetShadow(playerid, td_mdc_AgeValue, 1);
	PlayerTextDrawSetSelectable(playerid, td_mdc_AgeValue, 0);

	td_mdc_GenderValue = CreatePlayerTextDraw(playerid, 338.000000, 252.000000, "Male");
	PlayerTextDrawBackgroundColor(playerid, td_mdc_GenderValue, 255);
	PlayerTextDrawFont(playerid, td_mdc_GenderValue, 2);
	PlayerTextDrawLetterSize(playerid, td_mdc_GenderValue, 0.170000, 1.000000);
	PlayerTextDrawColor(playerid, td_mdc_GenderValue, -1);
	PlayerTextDrawSetOutline(playerid, td_mdc_GenderValue, 0);
	PlayerTextDrawSetProportional(playerid, td_mdc_GenderValue, 1);
	PlayerTextDrawSetShadow(playerid, td_mdc_GenderValue, 1);
	PlayerTextDrawSetSelectable(playerid, td_mdc_GenderValue, 0);

	td_mdc_JobValue = CreatePlayerTextDraw(playerid, 338.000000, 264.000000, "Unemployed");
	PlayerTextDrawBackgroundColor(playerid, td_mdc_JobValue, 255);
	PlayerTextDrawFont(playerid, td_mdc_JobValue, 2);
	PlayerTextDrawLetterSize(playerid, td_mdc_JobValue, 0.170000, 1.000000);
	PlayerTextDrawColor(playerid, td_mdc_JobValue, -1);
	PlayerTextDrawSetOutline(playerid, td_mdc_JobValue, 0);
	PlayerTextDrawSetProportional(playerid, td_mdc_JobValue, 1);
	PlayerTextDrawSetShadow(playerid, td_mdc_JobValue, 1);
	PlayerTextDrawSetSelectable(playerid, td_mdc_JobValue, 0);

	td_mdc_DriveLicValue = CreatePlayerTextDraw(playerid, 338.000000, 276.000000, "Passed");
	PlayerTextDrawBackgroundColor(playerid, td_mdc_DriveLicValue, 255);
	PlayerTextDrawFont(playerid, td_mdc_DriveLicValue, 2);
	PlayerTextDrawLetterSize(playerid, td_mdc_DriveLicValue, 0.170000, 1.000000);
	PlayerTextDrawColor(playerid, td_mdc_DriveLicValue, -1);
	PlayerTextDrawSetOutline(playerid, td_mdc_DriveLicValue, 0);
	PlayerTextDrawSetProportional(playerid, td_mdc_DriveLicValue, 1);
	PlayerTextDrawSetShadow(playerid, td_mdc_DriveLicValue, 1);
	PlayerTextDrawSetSelectable(playerid, td_mdc_DriveLicValue, 0);

	td_mdc_GunLicValue = CreatePlayerTextDraw(playerid, 338.000000, 288.000000, "Not Passed");
	PlayerTextDrawBackgroundColor(playerid, td_mdc_GunLicValue, 255);
	PlayerTextDrawFont(playerid, td_mdc_GunLicValue, 2);
	PlayerTextDrawLetterSize(playerid, td_mdc_GunLicValue, 0.170000, 1.000000);
	PlayerTextDrawColor(playerid, td_mdc_GunLicValue, -1);
	PlayerTextDrawSetOutline(playerid, td_mdc_GunLicValue, 0);
	PlayerTextDrawSetProportional(playerid, td_mdc_GunLicValue, 1);
	PlayerTextDrawSetShadow(playerid, td_mdc_GunLicValue, 1);
	PlayerTextDrawSetSelectable(playerid, td_mdc_GunLicValue, 0);

	td_mdc_PhoneNumberValue = CreatePlayerTextDraw(playerid, 338.000000, 300.000000, "4701958");
	PlayerTextDrawBackgroundColor(playerid, td_mdc_PhoneNumberValue, 255);
	PlayerTextDrawFont(playerid, td_mdc_PhoneNumberValue, 2);
	PlayerTextDrawLetterSize(playerid, td_mdc_PhoneNumberValue, 0.170000, 1.000000);
	PlayerTextDrawColor(playerid, td_mdc_PhoneNumberValue, -1);
	PlayerTextDrawSetOutline(playerid, td_mdc_PhoneNumberValue, 0);
	PlayerTextDrawSetProportional(playerid, td_mdc_PhoneNumberValue, 1);
	PlayerTextDrawSetShadow(playerid, td_mdc_PhoneNumberValue, 1);
	PlayerTextDrawSetSelectable(playerid, td_mdc_PhoneNumberValue, 0);
	
	for(new i = 0; i < sizeof(td_mdc_cr_Date); i++) {
		td_mdc_cr_Date[i] = CreatePlayerTextDraw(playerid, 366.000000, 249.000000 + i * 15, "21.02.2014");
		PlayerTextDrawBackgroundColor(playerid, td_mdc_cr_Date[i], 255);
		PlayerTextDrawFont(playerid, td_mdc_cr_Date[i], 2);
		PlayerTextDrawLetterSize(playerid, td_mdc_cr_Date[i], 0.170000, 1.000000);
		PlayerTextDrawColor(playerid, td_mdc_cr_Date[i], -1);
		PlayerTextDrawSetOutline(playerid, td_mdc_cr_Date[i], 0);
		PlayerTextDrawSetProportional(playerid, td_mdc_cr_Date[i], 1);
		PlayerTextDrawSetShadow(playerid, td_mdc_cr_Date[i], 1);
		PlayerTextDrawSetSelectable(playerid, td_mdc_cr_Date[i], 0);

		td_mdc_cr_Description[i] = CreatePlayerTextDraw(playerid, 257.000000, 249.000000 + i * 15, "Possession of a firearm w...");
		PlayerTextDrawBackgroundColor(playerid, td_mdc_cr_Description[i], 255);
		PlayerTextDrawFont(playerid, td_mdc_cr_Description[i], 2);
		PlayerTextDrawLetterSize(playerid, td_mdc_cr_Description[i], 0.170000, 1.000000);
		PlayerTextDrawColor(playerid, td_mdc_cr_Description[i], -1);
		PlayerTextDrawSetOutline(playerid, td_mdc_cr_Description[i], 0);
		PlayerTextDrawSetProportional(playerid, td_mdc_cr_Description[i], 1);
		PlayerTextDrawSetShadow(playerid, td_mdc_cr_Description[i], 1);
		PlayerTextDrawSetSelectable(playerid, td_mdc_cr_Description[i], 0);

		td_mdc_cr_Type[i] = CreatePlayerTextDraw(playerid, 220.000000, 249.000000 + i * 15, "Ticket");
		PlayerTextDrawBackgroundColor(playerid, td_mdc_cr_Type[i], 255);
		PlayerTextDrawFont(playerid, td_mdc_cr_Type[i], 2);
		PlayerTextDrawLetterSize(playerid, td_mdc_cr_Type[i], 0.170000, 1.000000);
		PlayerTextDrawColor(playerid, td_mdc_cr_Type[i], -1);
		PlayerTextDrawSetOutline(playerid, td_mdc_cr_Type[i], 0);
		PlayerTextDrawSetProportional(playerid, td_mdc_cr_Type[i], 1);
		PlayerTextDrawSetShadow(playerid, td_mdc_cr_Type[i], 1);
		PlayerTextDrawSetSelectable(playerid, td_mdc_cr_Type[i], 0);
	}
	
	td_mdc_veh_ModelValue = CreatePlayerTextDraw(playerid, 338.000000, 228.000000, "Landstalker");
	PlayerTextDrawBackgroundColor(playerid, td_mdc_veh_ModelValue, 255);
	PlayerTextDrawFont(playerid, td_mdc_veh_ModelValue, 2);
	PlayerTextDrawLetterSize(playerid, td_mdc_veh_ModelValue, 0.170000, 1.000000);
	PlayerTextDrawColor(playerid, td_mdc_veh_ModelValue, -1);
	PlayerTextDrawSetOutline(playerid, td_mdc_veh_ModelValue, 0);
	PlayerTextDrawSetProportional(playerid, td_mdc_veh_ModelValue, 1);
	PlayerTextDrawSetShadow(playerid, td_mdc_veh_ModelValue, 1);
	PlayerTextDrawSetSelectable(playerid, td_mdc_veh_ModelValue, 0);

	td_mdc_veh_VehicleModel = CreatePlayerTextDraw(playerid, 191.000000, 200.000000, "New Textdraw");
	PlayerTextDrawBackgroundColor(playerid, td_mdc_veh_VehicleModel, 0);
	PlayerTextDrawFont(playerid, td_mdc_veh_VehicleModel, 5);
	PlayerTextDrawLetterSize(playerid, td_mdc_veh_VehicleModel, 0.500000, 1.000000);
	PlayerTextDrawColor(playerid, td_mdc_veh_VehicleModel, -1);
	PlayerTextDrawSetOutline(playerid, td_mdc_veh_VehicleModel, 0);
	PlayerTextDrawSetProportional(playerid, td_mdc_veh_VehicleModel, 1);
	PlayerTextDrawSetShadow(playerid, td_mdc_veh_VehicleModel, 1);
	PlayerTextDrawUseBox(playerid, td_mdc_veh_VehicleModel, 1);
	PlayerTextDrawBoxColor(playerid, td_mdc_veh_VehicleModel, 0);
	PlayerTextDrawTextSize(playerid, td_mdc_veh_VehicleModel, 68.000000, 94.000000);
	PlayerTextDrawSetPreviewModel(playerid, td_mdc_veh_VehicleModel, 400);
	PlayerTextDrawSetPreviewRot(playerid, td_mdc_veh_VehicleModel, -16.000000, 0.000000, 35.000000, 1.000000);
	PlayerTextDrawSetSelectable(playerid, td_mdc_veh_VehicleModel, 0);

	td_mdc_veh_OwnerValue = CreatePlayerTextDraw(playerid, 338.000000, 240.000000, "Test Name");
	PlayerTextDrawBackgroundColor(playerid, td_mdc_veh_OwnerValue, 255);
	PlayerTextDrawFont(playerid, td_mdc_veh_OwnerValue, 2);
	PlayerTextDrawLetterSize(playerid, td_mdc_veh_OwnerValue, 0.170000, 1.000000);
	PlayerTextDrawColor(playerid, td_mdc_veh_OwnerValue, -1);
	PlayerTextDrawSetOutline(playerid, td_mdc_veh_OwnerValue, 0);
	PlayerTextDrawSetProportional(playerid, td_mdc_veh_OwnerValue, 1);
	PlayerTextDrawSetShadow(playerid, td_mdc_veh_OwnerValue, 1);
	PlayerTextDrawSetSelectable(playerid, td_mdc_veh_OwnerValue, 0);

	td_mdc_veh_PlateValue = CreatePlayerTextDraw(playerid, 338.000000, 252.000000, "P-205-LS");
	PlayerTextDrawBackgroundColor(playerid, td_mdc_veh_PlateValue, 255);
	PlayerTextDrawFont(playerid, td_mdc_veh_PlateValue, 2);
	PlayerTextDrawLetterSize(playerid, td_mdc_veh_PlateValue, 0.170000, 1.000000);
	PlayerTextDrawColor(playerid, td_mdc_veh_PlateValue, -1);
	PlayerTextDrawSetOutline(playerid, td_mdc_veh_PlateValue, 0);
	PlayerTextDrawSetProportional(playerid, td_mdc_veh_PlateValue, 1);
	PlayerTextDrawSetShadow(playerid, td_mdc_veh_PlateValue, 1);
	PlayerTextDrawSetSelectable(playerid, td_mdc_veh_PlateValue, 0);

	td_mdc_veh_InsuranceValue = CreatePlayerTextDraw(playerid, 338.000000, 264.000000, "Yes");
	PlayerTextDrawBackgroundColor(playerid, td_mdc_veh_InsuranceValue, 255);
	PlayerTextDrawFont(playerid, td_mdc_veh_InsuranceValue, 2);
	PlayerTextDrawLetterSize(playerid, td_mdc_veh_InsuranceValue, 0.170000, 1.000000);
	PlayerTextDrawColor(playerid, td_mdc_veh_InsuranceValue, -1);
	PlayerTextDrawSetOutline(playerid, td_mdc_veh_InsuranceValue, 0);
	PlayerTextDrawSetProportional(playerid, td_mdc_veh_InsuranceValue, 1);
	PlayerTextDrawSetShadow(playerid, td_mdc_veh_InsuranceValue, 1);
	PlayerTextDrawSetSelectable(playerid, td_mdc_veh_InsuranceValue, 0);
}

stock mdc_ShowPlayerStartScreen(playerid) {
    TextDrawShowForPlayer(playerid, td_mdc_Box);
    TextDrawShowForPlayer(playerid, td_mdc_HeaderBox);
    TextDrawShowForPlayer(playerid, td_mdc_HeaderText);
    TextDrawShowForPlayer(playerid, td_mdc_Exit);
    for(new i = 0; i < sizeof(td_mdc_Section); i++) {
        TextDrawShowForPlayer(playerid, td_mdc_Section[i]);
        TextDrawShowForPlayer(playerid, td_mdc_SectionText[i]);
	}
 	
	TextDrawShowForPlayer(playerid, td_mdc_SectionHeaderText);
	SelectTextDraw(playerid, -1);
}

stock mdc_Hide(playerid, bool:close = false) {
    TextDrawHideForPlayer(playerid, td_mdc_CitizenBox);
    TextDrawHideForPlayer(playerid, td_mdc_Box);
    TextDrawHideForPlayer(playerid, td_mdc_HeaderBox);
    TextDrawHideForPlayer(playerid, td_mdc_DataBox);
	TextDrawHideForPlayer(playerid, td_mdc_OptionsBox);
	TextDrawHideForPlayer(playerid, td_mdc_veh_Box);
	TextDrawHideForPlayer(playerid, td_mdc_veh_InnerBox);
	TextDrawHideForPlayer(playerid, td_mdc_veh_BoxNoEnt);
	TextDrawHideForPlayer(playerid, td_mdc_veh_InnerBoxNoEnt);
	for(new i = 0; i < sizeof(td_mdc_cr_Box); i++) {
		TextDrawHideForPlayer(playerid, td_mdc_cr_Box[i]);
	}
	
	for(new i = 0; i < sizeof(td_mdc_cr_InnerBox); i++) {
		TextDrawHideForPlayer(playerid, td_mdc_cr_InnerBox[i]);
	}
	
    TextDrawHideForPlayer(playerid, td_mdc_HeaderText);
    TextDrawHideForPlayer(playerid, td_mdc_Exit);
    for(new i = 0; i < sizeof(td_mdc_Section); i++) {
        TextDrawHideForPlayer(playerid, td_mdc_Section[i]);
        TextDrawHideForPlayer(playerid, td_mdc_SectionText[i]);
	}

	TextDrawHideForPlayer(playerid, td_mdc_SectionHeaderText);
	TextDrawHideForPlayer(playerid, td_mdc_Gender);
	TextDrawHideForPlayer(playerid, td_mdc_Job);
	TextDrawHideForPlayer(playerid, td_mdc_DriveLic);
	TextDrawHideForPlayer(playerid, td_mdc_GunLic);
	TextDrawHideForPlayer(playerid, td_mdc_PhoneNumber);
	TextDrawHideForPlayer(playerid, td_mdc_Name);
	TextDrawHideForPlayer(playerid, td_mdc_PropertiesArrow);
	TextDrawHideForPlayer(playerid, td_mdc_VehiclesArrow);
	TextDrawHideForPlayer(playerid, td_mdc_Vehicles);
	TextDrawHideForPlayer(playerid, td_mdc_Properties);
	TextDrawHideForPlayer(playerid, td_mdc_Age);
	TextDrawHideForPlayer(playerid, td_mdc_CriminalRecordArrow);
	TextDrawHideForPlayer(playerid, td_mdc_CasesArrow);
	TextDrawHideForPlayer(playerid, td_mdc_CriminalRecord);
	TextDrawHideForPlayer(playerid, td_mdc_Cases);
	TextDrawHideForPlayer(playerid, td_mdc_Browse);
	PlayerTextDrawHide(playerid, td_mdc_Skin);
	PlayerTextDrawHide(playerid, td_mdc_NameValue);
	PlayerTextDrawHide(playerid, td_mdc_AgeValue);
	PlayerTextDrawHide(playerid, td_mdc_GenderValue);
	PlayerTextDrawHide(playerid, td_mdc_JobValue);
	PlayerTextDrawHide(playerid, td_mdc_DriveLicValue);
	PlayerTextDrawHide(playerid, td_mdc_GunLicValue);
	PlayerTextDrawHide(playerid, td_mdc_PhoneNumberValue);
	TextDrawHideForPlayer(playerid, td_mdc_cr_Title);
	TextDrawHideForPlayer(playerid, td_mdc_cr_ArrowUp);
	TextDrawHideForPlayer(playerid, td_mdc_cr_ArrowDown);
	TextDrawHideForPlayer(playerid, td_mdc_cr_TypeTitle);
	TextDrawHideForPlayer(playerid, td_mdc_cr_DescriptionTitle);
	TextDrawHideForPlayer(playerid, td_mdc_cr_DateTitle);
	TextDrawHideForPlayer(playerid, td_mdc_veh_Model);
	TextDrawHideForPlayer(playerid, td_mdc_veh_Owner);
	TextDrawHideForPlayer(playerid, td_mdc_veh_Plate);
	TextDrawHideForPlayer(playerid, td_mdc_veh_Insurance);
	TextDrawHideForPlayer(playerid, td_mdc_veh_ArrowRight);
	TextDrawHideForPlayer(playerid, td_mdc_veh_Next);
	TextDrawHideForPlayer(playerid, td_mdc_veh_Label);
	PlayerTextDrawHide(playerid, td_mdc_veh_ModelValue);
	PlayerTextDrawHide(playerid, td_mdc_veh_VehicleModel);
	PlayerTextDrawHide(playerid, td_mdc_veh_OwnerValue);
	PlayerTextDrawHide(playerid, td_mdc_veh_PlateValue);
	PlayerTextDrawHide(playerid, td_mdc_veh_InsuranceValue);
	TextDrawHideForPlayer(playerid, td_mdc_veh_TextNoEnt);
	for(new i = 0; i < sizeof(td_mdc_cr_Info); i++) {
		TextDrawHideForPlayer(playerid, td_mdc_cr_Info[i]);
	}
	
	for(new i = 0; i < sizeof(td_mdc_cr_Info); i++) {
		PlayerTextDrawHide(playerid, td_mdc_cr_Type[i]);
		PlayerTextDrawHide(playerid, td_mdc_cr_Description[i]);
		PlayerTextDrawHide(playerid, td_mdc_cr_Date[i]);
	}
	
	if(close != false) {
		DeletePVar(playerid, "mdc_Citizen");
		DeletePVar(playerid, "mdc_VehicleIndex");
		DeletePVar(playerid, "mdc_Shown");
		CancelSelectTextDraw(playerid);
	}
}

stock mdc_SearchCitizen(playerid, name[]) {
	new user;
	for(new i = 0; i < strlen(name); i++) {
	    if(name[i] == ' ') {
			name[i] = '_';
		}
	}
	
	user = GetPlayerID(name);
	if(user != -1) {
	    SetPVarString(playerid, "mdc_Citizen", name);
	    mdc_ShowCitizen(playerid, PlayerName(user), GetPlayerSkin(user), GetPVarInt(user, "Age"), GetPVarInt(user, "Sex"), GetPVarInt(user, "DriveLic"), GetPVarInt(user, "GunLic"),
						GetPVarInt(user, "Job"), GetPVarInt(user, "PhoneNum"));
	} else {
		new query[135];
		format(query, sizeof(query), "SELECT `Model`, `Age`, `Sex`, `DriveLic`, `GunLic`, `JobID`, `PhoneNum` FROM `accounts` WHERE `Name` = '%s';", name);
		mysql_function_query(handlesql, query, true, "mdc_SearchCitizenResult", "ds", playerid, name);
	}
}

stock mdc_ShowCitizen(playerid, name[], skin, age, sex, driveLic, weaponLic, jobID, phoneNumber) {
	new value[20];
    mdc_Hide(playerid, false);
	
	// Skin
	PlayerTextDrawSetPreviewModel(playerid, td_mdc_Skin, skin);
	PlayerTextDrawShow(playerid, td_mdc_Skin);
	
	// Name
	PlayerTextDrawSetString(playerid, td_mdc_NameValue, name);
	PlayerTextDrawShow(playerid, td_mdc_NameValue);
	
	// Age
	format(value, sizeof(value), "%i", age);
	PlayerTextDrawSetString(playerid, td_mdc_AgeValue, value);
	PlayerTextDrawShow(playerid, td_mdc_AgeValue);
	
	// Gender
	PlayerTextDrawSetString(playerid, td_mdc_GenderValue, GetGenderString(sex));
	PlayerTextDrawShow(playerid, td_mdc_GenderValue);
	
	// Job
	PlayerTextDrawSetString(playerid, td_mdc_JobValue, GetOccupation(jobID));
	PlayerTextDrawShow(playerid, td_mdc_JobValue);
	
	// Driver's License
	PlayerTextDrawSetString(playerid, td_mdc_DriveLicValue, GetDriveLicStatus(driveLic));
	PlayerTextDrawShow(playerid, td_mdc_DriveLicValue);
	
	// Weapon License
	PlayerTextDrawSetString(playerid, td_mdc_GunLicValue, GetWeaponLicStatus(weaponLic));
	PlayerTextDrawShow(playerid, td_mdc_GunLicValue);
	
	// Phone Number
	format(value, sizeof(value), "%i", phoneNumber);
	PlayerTextDrawSetString(playerid, td_mdc_PhoneNumberValue, value);
	PlayerTextDrawShow(playerid, td_mdc_PhoneNumberValue);
	
	// Other
    TextDrawShowForPlayer(playerid, td_mdc_CitizenBox);
    TextDrawShowForPlayer(playerid, td_mdc_HeaderBox);
	TextDrawShowForPlayer(playerid, td_mdc_DataBox);
	TextDrawShowForPlayer(playerid, td_mdc_OptionsBox);
	TextDrawShowForPlayer(playerid, td_mdc_HeaderText);
    TextDrawShowForPlayer(playerid, td_mdc_Exit);
	TextDrawShowForPlayer(playerid, td_mdc_Gender);
	TextDrawShowForPlayer(playerid, td_mdc_Job);
	TextDrawShowForPlayer(playerid, td_mdc_DriveLic);
	TextDrawShowForPlayer(playerid, td_mdc_GunLic);
	TextDrawShowForPlayer(playerid, td_mdc_PhoneNumber);
	TextDrawShowForPlayer(playerid, td_mdc_Name);
	TextDrawShowForPlayer(playerid, td_mdc_PropertiesArrow);
	TextDrawShowForPlayer(playerid, td_mdc_VehiclesArrow);
	TextDrawShowForPlayer(playerid, td_mdc_Vehicles);
	TextDrawShowForPlayer(playerid, td_mdc_Properties);
	TextDrawShowForPlayer(playerid, td_mdc_Age);
	TextDrawShowForPlayer(playerid, td_mdc_CriminalRecordArrow);
	TextDrawShowForPlayer(playerid, td_mdc_CasesArrow);
	TextDrawShowForPlayer(playerid, td_mdc_CriminalRecord);
	TextDrawShowForPlayer(playerid, td_mdc_Cases);
	TextDrawShowForPlayer(playerid, td_mdc_Browse);
	SelectTextDraw(playerid, -1);
}

stock mdc_ShowCriminalRecord(playerid, name[]) {
	new query[130];
	format(query, sizeof(query), "SELECT `officer`, `time`, `date`, `amount`, `reason`, `paid` FROM `tickets` WHERE `player` = '%s';", name);
	mysql_function_query(handlesql, query, true, "mdc_FetchTickets", "ds", playerid, name);
}

stock mdc_ShowCriminalRecordDetails(playerid, idx) {
	new dialogMsg[600];
	if(CriminalRecordData[playerid][idx][mdc_cr_type] == RECORD_TICKET) {
	    if(CriminalRecordData[playerid][idx][mdc_cr_paid] == 0) {
	    	format(dialogMsg, sizeof(dialogMsg), "{3D62A8}Ticket Issued By The Los Santos Police Department\n\n{ffffff}Offender:\t{a9c4e4}%s\n{ffffff}Police Officer:\t{a9c4e4}%s\
												  \n{ffffff}Date:\t\t{a9c4e4}%s\n{ffffff}Time:\t\t{a9c4e4}%s\n{ffffff}Price:\t\t{a9c4e4}$%i\n{ffffff}Offence:\t{a9c4e4}%s\n\n\
												  {ffffff}Information:\t{a9c4e4}The offender has {3D62A8}NOT {a9c4e4}yet paid the ticket.",
												  GetNameWithSpace(CriminalRecordData[playerid][idx][mdc_cr_offender]), GetNameWithSpace(CriminalRecordData[playerid][idx][mdc_cr_officer]),
												  CriminalRecordData[playerid][idx][mdc_cr_date], CriminalRecordData[playerid][idx][mdc_cr_time],
												  CriminalRecordData[playerid][idx][mdc_cr_price], CriminalRecordData[playerid][idx][mdc_cr_description]);
		} else {
			format(dialogMsg, sizeof(dialogMsg), "{3D62A8}Ticket Issued By The Los Santos Police Department\n\n{ffffff}Offender:\t{a9c4e4}%s\n{ffffff}Police Officer:\t{a9c4e4}%s\n\
												  {ffffff}Date:\t\t{a9c4e4}%s\n{ffffff}Time:\t\t{a9c4e4}%s\n{ffffff}Price:\t\t{a9c4e4}$%i\n{ffffff}Offence:\t{a9c4e4}%s\n\n{ffffff}\
												  Information:\t{a9c4e4}The offender has paid the ticket.", GetNameWithSpace(CriminalRecordData[playerid][idx][mdc_cr_offender]),
												  GetNameWithSpace(CriminalRecordData[playerid][idx][mdc_cr_officer]), CriminalRecordData[playerid][idx][mdc_cr_date],
												  CriminalRecordData[playerid][idx][mdc_cr_time], CriminalRecordData[playerid][idx][mdc_cr_price],
												  CriminalRecordData[playerid][idx][mdc_cr_description]);
		}
	} else {
        if(CriminalRecordData[playerid][idx][mdc_cr_served] == 0) {
	    	format(dialogMsg, sizeof(dialogMsg), "{3D62A8}Charge Issued By The Los Santos Police Department\n\n{ffffff}Offender:\t{a9c4e4}%s\n{ffffff}Police Officer:\t{a9c4e4}%s\n\
												  {ffffff}Date:\t\t{a9c4e4}%s\n{ffffff}Time:\t\t{a9c4e4}%s\n{ffffff}Felony:\t\t{a9c4e4}%s\n\n{ffffff}Information:\t{a9c4e4}The offender \
												  is presently {3D62A8}WANTED {a9c4e4}due to this charge.", GetNameWithSpace(CriminalRecordData[playerid][idx][mdc_cr_offender]),
												  GetNameWithSpace(CriminalRecordData[playerid][idx][mdc_cr_officer]), CriminalRecordData[playerid][idx][mdc_cr_date],
												  CriminalRecordData[playerid][idx][mdc_cr_time], CriminalRecordData[playerid][idx][mdc_cr_description]);
		} else {
			format(dialogMsg, sizeof(dialogMsg), "{3D62A8}Charge Issued By The Los Santos Police Department\n\n{ffffff}Offender:\t{a9c4e4}%s\n{ffffff}Police Officer:\t{a9c4e4}%s\n{ffffff}\
												  Date:\t\t{a9c4e4}%s\n{ffffff}Time:\t\t{a9c4e4}%s\n{ffffff}Felony:\t\t{a9c4e4}%s\n\n{ffffff}Information:\t{a9c4e4}The offender has \
												  already served according time in prison.", GetNameWithSpace(CriminalRecordData[playerid][idx][mdc_cr_offender]),
												  GetNameWithSpace(CriminalRecordData[playerid][idx][mdc_cr_officer]), CriminalRecordData[playerid][idx][mdc_cr_date],
												  CriminalRecordData[playerid][idx][mdc_cr_time], CriminalRecordData[playerid][idx][mdc_cr_description]);
		}
	}
	
	ShowPlayerDialog(playerid, DIALOG_CLOSE, DIALOG_STYLE_MSGBOX, "{3D62A8}Detailed Record Information", dialogMsg, "Close", "");
}

stock mdc_ResetCriminalRecordData(playerid) {
	for(new i = 0; i < MAX_CRIMINAL_RECORDS; i++) {
        for(new j = 0; j < sizeof(CriminalRecordData[][]); j++) {
	    	CriminalRecordData[playerid][i][CriminalRecordEnum:j] = 0;
		}
	}
	
	Iter_Clear(CriminalRecordIterator[playerid]);
}

stock mdc_ShowVehicles(playerid, name[]) {
	new query[140];
	format(query, sizeof(query), "SELECT `Model`, `ColorOne`, `ColorTwo`, `Plate`, `Insurance` FROM `vehicles` WHERE `Owner` = '%s';", name);
	mysql_function_query(handlesql, query, true, "mdc_FetchVehicle", "ds", playerid, name);
}

stock mdc_ShowVehicle(playerid, owner[], model, color1, color2, insurance, plate[], bool:nextBtn = false) {
    mdc_Hide(playerid, false);
    
    // Model
    PlayerTextDrawSetString(playerid, td_mdc_veh_ModelValue, VehicleName[model - 400]);
	PlayerTextDrawShow(playerid, td_mdc_veh_ModelValue);
	
	// Model Preview
	PlayerTextDrawSetPreviewModel(playerid, td_mdc_veh_VehicleModel, model);
	PlayerTextDrawSetPreviewVehCol(playerid, td_mdc_veh_VehicleModel, color1, color2);
	PlayerTextDrawShow(playerid, td_mdc_veh_VehicleModel);
	
	// Owner
	PlayerTextDrawSetString(playerid, td_mdc_veh_OwnerValue, owner);
	PlayerTextDrawShow(playerid, td_mdc_veh_OwnerValue);
	
	// License Plate Number
	PlayerTextDrawSetString(playerid, td_mdc_veh_PlateValue, plate);
	PlayerTextDrawShow(playerid, td_mdc_veh_PlateValue);
	
	// Insurance
	if(insurance) {
	    PlayerTextDrawSetString(playerid, td_mdc_veh_InsuranceValue, "Yes");
	} else {
		PlayerTextDrawSetString(playerid, td_mdc_veh_InsuranceValue, "No");
	}
	
	PlayerTextDrawShow(playerid, td_mdc_veh_InsuranceValue);
	TextDrawShowForPlayer(playerid, td_mdc_veh_Box);
    TextDrawShowForPlayer(playerid, td_mdc_veh_InnerBox);
    TextDrawShowForPlayer(playerid, td_mdc_HeaderBox);
    TextDrawShowForPlayer(playerid, td_mdc_HeaderText);
    TextDrawShowForPlayer(playerid, td_mdc_Exit);
	TextDrawShowForPlayer(playerid, td_mdc_veh_Model);
	TextDrawShowForPlayer(playerid, td_mdc_veh_Owner);
	TextDrawShowForPlayer(playerid, td_mdc_veh_Plate);
	TextDrawShowForPlayer(playerid, td_mdc_veh_Insurance);
	TextDrawShowForPlayer(playerid, td_mdc_veh_Label);
	if(nextBtn != false) {
        TextDrawShowForPlayer(playerid, td_mdc_veh_ArrowRight);
		TextDrawShowForPlayer(playerid, td_mdc_veh_Next);
	}
	
	SelectTextDraw(playerid, -1);
}

/* MySQL */

forward mdc_SearchCitizenResult(playerid, name[]);
public mdc_SearchCitizenResult(playerid, name[]) {
	if(cache_get_row_count() > 0) {
	    SetPVarString(playerid, "mdc_Citizen", name);
		mdc_ShowCitizen(playerid, GetNameWithSpace(name), cache_get_field_content_int(0, "Model") , cache_get_field_content_int(0, "Age"), cache_get_field_content_int(0, "Sex"),
					   	cache_get_field_content_int(0, "DriveLic"), cache_get_field_content_int(0, "GunLic"), cache_get_field_content_int(0, "JobID"),
					  	cache_get_field_content_int(0, "PhoneNum"));
	} else {
		SendClientMessage(playerid, COLOR_GREY, "No citizen could be found under the mentioned name.");
		ShowPlayerDialog(playerid, DIALOG_MDC_SEARCH_CITIZEN, DIALOG_STYLE_INPUT, "{3D62A8}Search Citizen", "Please enter the citizen's full name below:", "Search", "Cancel");
	}
}

forward mdc_SearchPhoneNumber(playerid, phoneNum);
public mdc_SearchPhoneNumber(playerid, phoneNum) {
	if(cache_get_row_count() > 0) {
		new name[MAX_PLAYER_NAME];
		cache_get_field_content(0, "Name", name);
		SetPVarString(playerid, "mdc_Citizen", name);
		mdc_ShowCitizen(playerid, GetNameWithSpace(name), cache_get_field_content_int(0, "Model") , cache_get_field_content_int(0, "Age"), cache_get_field_content_int(0, "Sex"),
					   	cache_get_field_content_int(0, "DriveLic"), cache_get_field_content_int(0, "GunLic"), cache_get_field_content_int(0, "JobID"), phoneNum);
	} else {
		SendClientMessage(playerid, COLOR_GREY, "No citizen could be associated with the mentioned phone number.");
		ShowPlayerDialog(playerid, DIALOG_MDC_SEARCH_PHONE_NUMBER, DIALOG_STYLE_INPUT, "{3D62A8}Search Phone Number", "Please enter the phone number below:", "Search", "Cancel");
	}
}

forward mdc_SearchSerial(playerid);
public mdc_SearchSerial(playerid) {
	if(cache_get_row_count() > 0) {
		new name[MAX_PLAYER_NAME];
		cache_get_field_content(0, "Name", name);
		SetPVarString(playerid, "mdc_Citizen", name);
		mdc_ShowCitizen(playerid, GetNameWithSpace(name), cache_get_field_content_int(0, "Model") , cache_get_field_content_int(0, "Age"), cache_get_field_content_int(0, "Sex"),
					   	cache_get_field_content_int(0, "DriveLic"), cache_get_field_content_int(0, "GunLic"), cache_get_field_content_int(0, "JobID"),
  						cache_get_field_content_int(0, "PhoneNum"));
	} else {
		SendClientMessage(playerid, COLOR_GREY, "No citizen could be associated with the mentioned weapon serial number.");
		ShowPlayerDialog(playerid, DIALOG_MDC_SEARCH_SERIAL, DIALOG_STYLE_INPUT, "{3D62A8}Search Weapon Serial", "Please enter the weapons's serial number below:", "Search", "Cancel");
	}
}

forward mdc_FetchTickets(playerid, name[]);
public mdc_FetchTickets(playerid, name[]) {
	new idx;
	mdc_ResetCriminalRecordData(playerid);
	SetPVarInt(playerid, "mdc_cr_ScrollTop", 0);
	for(new i = 0; i < cache_get_row_count(); i++) {
		idx = Iter_Free(CriminalRecordIterator[playerid]);
		if(idx == -1) {
		    break;
		}
		
		Iter_Add(CriminalRecordIterator[playerid], idx);
		format(CriminalRecordData[playerid][idx][mdc_cr_offender], MAX_PLAYER_NAME, "%s", name);
		CriminalRecordData[playerid][idx][mdc_cr_type] = RECORD_TICKET;
		cache_get_field_content(i, "reason", CriminalRecordData[playerid][idx][mdc_cr_description], handlesql, MDC_DESCRIPTION_MAX_LENGTH);
		cache_get_field_content(i, "time", CriminalRecordData[playerid][idx][mdc_cr_time], handlesql, 15);
		cache_get_field_content(i, "date", CriminalRecordData[playerid][idx][mdc_cr_date], handlesql, 15);
		cache_get_field_content(i, "officer", CriminalRecordData[playerid][idx][mdc_cr_officer], handlesql, MAX_PLAYER_NAME);
		CriminalRecordData[playerid][idx][mdc_cr_paid] = cache_get_field_content_int(i, "paid", handlesql);
		CriminalRecordData[playerid][idx][mdc_cr_price] = cache_get_field_content_int(i, "amount", handlesql);
	}
	
	new query[130];
	format(query, sizeof(query), "SELECT `officer`, `time`, `date`, `served`, `crime` FROM `criminals` WHERE `player` = '%s';", name);
	mysql_function_query(handlesql, query, true, "mdc_FetchCharges", "ds", playerid, name);
}

forward mdc_FetchCharges(playerid, name[]);
public mdc_FetchCharges(playerid, name[]) {
	new idx;
	for(new i = 0; i < cache_get_row_count(); i++) {
		idx = Iter_Free(CriminalRecordIterator[playerid]);
		if(idx == -1) {
		    break;
		}

        Iter_Add(CriminalRecordIterator[playerid], idx);
		format(CriminalRecordData[playerid][idx][mdc_cr_offender], MAX_PLAYER_NAME, "%s", name);
		CriminalRecordData[playerid][idx][mdc_cr_type] = RECORD_CHARGE;
		cache_get_field_content(i, "crime", CriminalRecordData[playerid][idx][mdc_cr_description], handlesql, MDC_DESCRIPTION_MAX_LENGTH);
		cache_get_field_content(i, "time", CriminalRecordData[playerid][idx][mdc_cr_time], handlesql, 15);
		cache_get_field_content(i, "date", CriminalRecordData[playerid][idx][mdc_cr_date], handlesql, 15);
		cache_get_field_content(i, "officer", CriminalRecordData[playerid][idx][mdc_cr_officer], handlesql, MAX_PLAYER_NAME);
		CriminalRecordData[playerid][idx][mdc_cr_served] = cache_get_field_content_int(i, "served", handlesql);
	}

	new count = Iter_Count(CriminalRecordIterator[playerid]);
	mdc_Hide(playerid, false);
    TextDrawShowForPlayer(playerid, td_mdc_HeaderBox);
    if(count >= 7) {
    	TextDrawShowForPlayer(playerid, td_mdc_cr_Box[6]);
		TextDrawShowForPlayer(playerid, td_mdc_cr_InnerBox[6]);
	} else if(count > 1) {
        TextDrawShowForPlayer(playerid, td_mdc_cr_Box[count - 1]);
		TextDrawShowForPlayer(playerid, td_mdc_cr_InnerBox[count - 1]);
	} else {
	    TextDrawShowForPlayer(playerid, td_mdc_cr_Box[0]);
		TextDrawShowForPlayer(playerid, td_mdc_cr_InnerBox[0]);
	}
	
	TextDrawShowForPlayer(playerid, td_mdc_HeaderText);
    TextDrawShowForPlayer(playerid, td_mdc_Exit);
	TextDrawShowForPlayer(playerid, td_mdc_cr_Title);
	TextDrawShowForPlayer(playerid, td_mdc_cr_TypeTitle);
	TextDrawShowForPlayer(playerid, td_mdc_cr_DescriptionTitle);
	TextDrawShowForPlayer(playerid, td_mdc_cr_DateTitle);
	if(count > 7) {
		TextDrawShowForPlayer(playerid, td_mdc_cr_ArrowUp);
		TextDrawShowForPlayer(playerid, td_mdc_cr_ArrowDown);
	}
	
	if(count <= 0) {
	    PlayerTextDrawColor(playerid, td_mdc_cr_Type[0], COLOR_WHITE);
	    PlayerTextDrawSetString(playerid, td_mdc_cr_Type[0], "No entries could be found.");
	    PlayerTextDrawShow(playerid, td_mdc_cr_Type[0]);
	} else {
		for(new i = 0; i < sizeof(td_mdc_cr_Info); i++) {
		    if(i >= count) {
				break;
			}
		    
		    if(CriminalRecordData[playerid][i][mdc_cr_type] == RECORD_CHARGE) {
			  	PlayerTextDrawSetString(playerid, td_mdc_cr_Type[i], "Charge");
			  	if(CriminalRecordData[playerid][i][mdc_cr_served] == 0) {
			  	    PlayerTextDrawColor(playerid, td_mdc_cr_Type[i], COLOR_RED);
			        PlayerTextDrawColor(playerid, td_mdc_cr_Description[i], COLOR_RED);
			        PlayerTextDrawColor(playerid, td_mdc_cr_Date[i], COLOR_RED);
			  	} else {
				   	PlayerTextDrawColor(playerid, td_mdc_cr_Type[i], COLOR_WHITE);
				    PlayerTextDrawColor(playerid, td_mdc_cr_Description[i], COLOR_WHITE);
				    PlayerTextDrawColor(playerid, td_mdc_cr_Date[i], COLOR_WHITE);
				}
			} else {
			    PlayerTextDrawSetString(playerid, td_mdc_cr_Type[i], "Ticket");
			    if(CriminalRecordData[playerid][i][mdc_cr_paid] == 0) {
			        PlayerTextDrawColor(playerid, td_mdc_cr_Type[i], COLOR_RED);
			        PlayerTextDrawColor(playerid, td_mdc_cr_Description[i], COLOR_RED);
			        PlayerTextDrawColor(playerid, td_mdc_cr_Date[i], COLOR_RED);
			    } else {
                    PlayerTextDrawColor(playerid, td_mdc_cr_Type[i], COLOR_WHITE);
			      	PlayerTextDrawColor(playerid, td_mdc_cr_Description[i], COLOR_WHITE);
			       	PlayerTextDrawColor(playerid, td_mdc_cr_Date[i], COLOR_WHITE);
				}
			}

		    PlayerTextDrawSetString(playerid, td_mdc_cr_Date[i], CriminalRecordData[playerid][i][mdc_cr_date]);
		    if(strlen(CriminalRecordData[playerid][i][mdc_cr_description]) < 20) {
		    	PlayerTextDrawSetString(playerid, td_mdc_cr_Description[i], CriminalRecordData[playerid][i][mdc_cr_description]);
			} else {
				new desc[25];
				strmid(desc, CriminalRecordData[playerid][i][mdc_cr_description], 0, 20, MDC_DESCRIPTION_MAX_LENGTH);
				strins(desc, "...", strlen(desc), sizeof(desc));
				PlayerTextDrawSetString(playerid, td_mdc_cr_Description[i], desc);
			}

			PlayerTextDrawShow(playerid, td_mdc_cr_Type[i]);
			PlayerTextDrawShow(playerid, td_mdc_cr_Description[i]);
			PlayerTextDrawShow(playerid, td_mdc_cr_Date[i]);
			TextDrawShowForPlayer(playerid, td_mdc_cr_Info[i]);
		}
	}
	
	SelectTextDraw(playerid, -1);
}

forward mdc_SearchLicensePlate(playerid, plate[]);
public mdc_SearchLicensePlate(playerid, plate[]) {
	if(cache_get_row_count() > 0) {
		new name[MAX_PLAYER_NAME];
		cache_get_field_content(0, "Owner", name);
		SetPVarString(playerid, "mdc_Citizen", name);
		mdc_ShowVehicle(playerid, GetNameWithSpace(name), cache_get_field_content_int(0, "Model") , cache_get_field_content_int(0, "ColorOne"), cache_get_field_content_int(0, "ColorTwo"),
					   	cache_get_field_content_int(0, "Insurance"), plate, false);
	} else {
		SendClientMessage(playerid, COLOR_GREY, "No vehicle could be found under the mentioned license plate number.");
		ShowPlayerDialog(playerid, DIALOG_MDC_SEARCH_PLATE, DIALOG_STYLE_INPUT, "{3D62A8}Search License Plate", "Please enter the license plate below:", "Search", "Cancel");
	}
}

forward mdc_FetchVehicle(playerid, owner[]);
public mdc_FetchVehicle(playerid, owner[]) {
    mdc_Hide(playerid, false);
	if(cache_get_row_count() > 0) {
	    if(GetPVarInt(playerid, "mdc_VehicleIndex") >= cache_get_row_count()) {
	        SetPVarInt(playerid, "mdc_VehicleIndex", 0);
	    }

		new row = GetPVarInt(playerid, "mdc_VehicleIndex"),
		    plate[50];
		    
	    cache_get_field_content(row, "Plate", plate);
	    if(cache_get_row_count() > 1) {
		    mdc_ShowVehicle(playerid, GetNameWithSpace(owner), cache_get_field_content_int(row, "Model") , cache_get_field_content_int(row, "ColorOne"),
							cache_get_field_content_int(row, "ColorTwo"), cache_get_field_content_int(row, "Insurance"), plate, true);
		} else {
		    mdc_ShowVehicle(playerid, GetNameWithSpace(owner), cache_get_field_content_int(row, "Model") , cache_get_field_content_int(row, "ColorOne"),
							cache_get_field_content_int(row, "ColorTwo"), cache_get_field_content_int(row, "Insurance"), plate, false);
		}
	} else {
		TextDrawShowForPlayer(playerid, td_mdc_veh_BoxNoEnt);
		TextDrawShowForPlayer(playerid, td_mdc_veh_InnerBoxNoEnt);
	    TextDrawShowForPlayer(playerid, td_mdc_HeaderBox);
	    TextDrawShowForPlayer(playerid, td_mdc_HeaderText);
	    TextDrawShowForPlayer(playerid, td_mdc_Exit);
		TextDrawShowForPlayer(playerid, td_mdc_veh_TextNoEnt);
		TextDrawShowForPlayer(playerid, td_mdc_veh_Label);
	}
	
	SelectTextDraw(playerid, -1);
}
