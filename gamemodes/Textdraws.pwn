//=======Definitions/Enum/New Statements======//
new
PlayerText:IntroTD1,
PlayerText:IntroTD2,
PlayerText:PayTDraw[MAX_PLAYERS],
Text:PayDraw[6],
PlayerText:Wheels[MAX_PLAYERS][23],
Page[MAX_PLAYERS],
PlayerText:Fishdraw0[MAX_PLAYERS];
//===================Intro====================//
stock BuildIntroTextDraws(playerid)
{
	IntroTD1 = CreatePlayerTextDraw(playerid, 165.0, 35.0, "Welcome to Diverse Roleplay");
	PlayerTextDrawBackgroundColor(playerid,IntroTD1, -16776961);
	PlayerTextDrawFont(playerid,IntroTD1, 0);
	PlayerTextDrawLetterSize(playerid,IntroTD1, 1.0, 4.0);
	PlayerTextDrawColor(playerid,IntroTD1, -1);
	PlayerTextDrawSetOutline(playerid,IntroTD1, 0);
	PlayerTextDrawSetProportional(playerid,IntroTD1, 1);
	PlayerTextDrawSetShadow(playerid,IntroTD1, 2);
	PlayerTextDrawSetSelectable(playerid,IntroTD1, 0);

	IntroTD2 = CreatePlayerTextDraw(playerid, 250.0, 15.0, "www.diverseroleplay.org");
	PlayerTextDrawBackgroundColor(playerid,IntroTD2, 255);
	PlayerTextDrawFont(playerid,IntroTD2, 1);
	PlayerTextDrawLetterSize(playerid,IntroTD2, 0.5, 1.0);
	PlayerTextDrawColor(playerid,IntroTD2, -1);
	PlayerTextDrawSetProportional(playerid,IntroTD2, 1);
	PlayerTextDrawSetShadow(playerid,IntroTD2, 1);
	PlayerTextDrawSetSelectable(playerid,IntroTD2, 0);
	
	PlayerTextDrawShow(playerid, PlayerText:IntroTD1);
	PlayerTextDrawShow(playerid, PlayerText:IntroTD2);
	return 1;
}
stock DestroyIntoTextDraws(playerid)
{
	PlayerTextDrawDestroy(playerid, PlayerText:IntroTD1);
	PlayerTextDrawDestroy(playerid, PlayerText:IntroTD2);
}
stock BuildPayDraw()
{
    PayDraw[0] = TextDrawCreate(213.000000, 198.000000, "|||");
    TextDrawBackgroundColor(PayDraw[0], 0);
    TextDrawFont(PayDraw[0], 1);
    TextDrawLetterSize(PayDraw[0], 0.519999, 1.100000);
    TextDrawColor(PayDraw[0], 0);
    TextDrawSetOutline(PayDraw[0], 1);
    TextDrawSetProportional(PayDraw[0], 1);
    TextDrawUseBox(PayDraw[0], 1);
    TextDrawBoxColor(PayDraw[0], -1);
    TextDrawTextSize(PayDraw[0], 424.000000, 29.000000);
    TextDrawSetSelectable(PayDraw[0], 0);
    PayDraw[1] = TextDrawCreate(213.000000, 198.000000, "|||");
    TextDrawBackgroundColor(PayDraw[1], 0);
    TextDrawFont(PayDraw[1], 1);
    TextDrawLetterSize(PayDraw[1], 0.519999, 9.200000);
    TextDrawColor(PayDraw[1], 0);
    TextDrawSetOutline(PayDraw[1], 1);
    TextDrawSetProportional(PayDraw[1], 1);
    TextDrawUseBox(PayDraw[1], 1);
    TextDrawBoxColor(PayDraw[1], 150);
    TextDrawTextSize(PayDraw[1], 424.000000, 29.000000);
    TextDrawSetSelectable(PayDraw[1], 0);
    PayDraw[2] = TextDrawCreate(260.000000, 198.000000, "PAYMENT TYPE");
    TextDrawBackgroundColor(PayDraw[2], 255);
    TextDrawFont(PayDraw[2], 2);
    TextDrawLetterSize(PayDraw[2], 0.380000, 1.000000);
    TextDrawColor(PayDraw[2], -1);
    TextDrawSetOutline(PayDraw[2], 0);
    TextDrawSetProportional(PayDraw[2], 1);
    TextDrawSetShadow(PayDraw[2], 1);
    TextDrawSetSelectable(PayDraw[2], 0);
    PayDraw[3] = TextDrawCreate(234.000000, 269.000000, "~b~~h~CASH");
    TextDrawBackgroundColor(PayDraw[3], 255);
    TextDrawFont(PayDraw[3], 2);
    TextDrawLetterSize(PayDraw[3], 0.310000, 0.899999);
    TextDrawColor(PayDraw[3], 0x2641FEFF);
    TextDrawSetOutline(PayDraw[3], 0);
    TextDrawSetProportional(PayDraw[3], 1);
    TextDrawSetShadow(PayDraw[3], 1);
    TextDrawSetSelectable(PayDraw[3], true);
    PayDraw[4] = TextDrawCreate(298.000000, 269.000000, "~b~~h~DEBIT");
    TextDrawBackgroundColor(PayDraw[4], 255);
    TextDrawFont(PayDraw[4], 2);
    TextDrawLetterSize(PayDraw[4], 0.310000, 0.899999);
    TextDrawColor(PayDraw[4], 0x2641FEFF);
    TextDrawSetOutline(PayDraw[4], 0);
    TextDrawSetProportional(PayDraw[4], 1);
    TextDrawSetShadow(PayDraw[4], 1);
    TextDrawSetSelectable(PayDraw[4], true);
    PayDraw[5] = TextDrawCreate(362.000000, 269.000000, "~b~~h~CANCEL");
    TextDrawBackgroundColor(PayDraw[5], 255);
    TextDrawFont(PayDraw[5], 2);
    TextDrawLetterSize(PayDraw[5], 0.310000, 0.899999);
    TextDrawColor(PayDraw[5], 0x2641FEFF);
    TextDrawSetOutline(PayDraw[5], 0);
    TextDrawSetProportional(PayDraw[5], 1);
    TextDrawSetShadow(PayDraw[5], 1);
    TextDrawSetSelectable(PayDraw[5], true);
}
//============================================//
stock BuildWheelMenu(playerid)
{
    Wheels[playerid][0] = CreatePlayerTextDraw(playerid, 132.000000, 147.125000, "box");
	PlayerTextDrawLetterSize(playerid, Wheels[playerid][0], 0.000000, 21.299993);
	PlayerTextDrawTextSize(playerid, Wheels[playerid][0], 534.500000, 0.000000);
	PlayerTextDrawAlignment(playerid, Wheels[playerid][0], 1);
	PlayerTextDrawColor(playerid, Wheels[playerid][0], -1);
	PlayerTextDrawUseBox(playerid, Wheels[playerid][0], 1);
	PlayerTextDrawBoxColor(playerid, Wheels[playerid][0], 95);
	PlayerTextDrawSetShadow(playerid, Wheels[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, Wheels[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, Wheels[playerid][0], 255);
	PlayerTextDrawFont(playerid, Wheels[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, Wheels[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, Wheels[playerid][0], 0);

	Wheels[playerid][1] = CreatePlayerTextDraw(playerid, 260.500000, 151.500000, "box");
	PlayerTextDrawLetterSize(playerid, Wheels[playerid][1], 0.000000, 2.150000);
	PlayerTextDrawTextSize(playerid, Wheels[playerid][1], 388.000000, 0.000000);
	PlayerTextDrawAlignment(playerid, Wheels[playerid][1], 1);
	PlayerTextDrawColor(playerid, Wheels[playerid][1], -1);
	PlayerTextDrawUseBox(playerid, Wheels[playerid][1], 1);
	PlayerTextDrawBoxColor(playerid, Wheels[playerid][1], 95);
	PlayerTextDrawSetShadow(playerid, Wheels[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, Wheels[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, Wheels[playerid][1], 255);
	PlayerTextDrawFont(playerid, Wheels[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, Wheels[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, Wheels[playerid][1], 0);

	Wheels[playerid][2] = CreatePlayerTextDraw(playerid, 281.000000, 154.125000, "WHEELS_MENU");
	PlayerTextDrawLetterSize(playerid, Wheels[playerid][2], 0.388000, 1.486250);
	PlayerTextDrawAlignment(playerid, Wheels[playerid][2], 1);
	PlayerTextDrawColor(playerid, Wheels[playerid][2], -1);
	PlayerTextDrawSetShadow(playerid, Wheels[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, Wheels[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, Wheels[playerid][2], 255);
	PlayerTextDrawFont(playerid, Wheels[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, Wheels[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, Wheels[playerid][2], 0);

	Wheels[playerid][3] = CreatePlayerTextDraw(playerid, 170.000000, 176.437500, ""); // 1073
	PlayerTextDrawLetterSize(playerid, Wheels[playerid][3], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, Wheels[playerid][3], 43.500000, 41.437500);
	PlayerTextDrawAlignment(playerid, Wheels[playerid][3], 1);
	PlayerTextDrawColor(playerid, Wheels[playerid][3], -1);
	PlayerTextDrawSetShadow(playerid, Wheels[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, Wheels[playerid][3], 0);
	PlayerTextDrawBackgroundColor(playerid, Wheels[playerid][3], 0);
	PlayerTextDrawFont(playerid, Wheels[playerid][3], 5);
	PlayerTextDrawSetProportional(playerid, Wheels[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, Wheels[playerid][3], 0);
	PlayerTextDrawSetSelectable(playerid, Wheels[playerid][3], true);
	PlayerTextDrawSetPreviewModel(playerid, Wheels[playerid][3], 1073);
	PlayerTextDrawSetPreviewRot(playerid, Wheels[playerid][3], 0.000000, 0.000000, 90.000000, 1.000000);

	Wheels[playerid][4] = CreatePlayerTextDraw(playerid, 241.500000, 175.125000, ""); //1074
	PlayerTextDrawLetterSize(playerid, Wheels[playerid][4], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, Wheels[playerid][4], 43.500000, 41.437500);
	PlayerTextDrawAlignment(playerid, Wheels[playerid][4], 1);
	PlayerTextDrawColor(playerid, Wheels[playerid][4], -1);
	PlayerTextDrawSetShadow(playerid, Wheels[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, Wheels[playerid][4], 0);
	PlayerTextDrawBackgroundColor(playerid, Wheels[playerid][4], 0);
	PlayerTextDrawFont(playerid, Wheels[playerid][4], 5);
	PlayerTextDrawSetProportional(playerid, Wheels[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid, Wheels[playerid][4], 0);
	PlayerTextDrawSetSelectable(playerid, Wheels[playerid][4], true);
	PlayerTextDrawSetPreviewModel(playerid, Wheels[playerid][4], 1074);
	PlayerTextDrawSetPreviewRot(playerid, Wheels[playerid][4], 0.000000, 0.000000, 90.000000, 1.000000);

	Wheels[playerid][5] = CreatePlayerTextDraw(playerid, 313.000000, 176.000000, ""); //1075
	PlayerTextDrawLetterSize(playerid, Wheels[playerid][5], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, Wheels[playerid][5], 43.500000, 41.437500);
	PlayerTextDrawAlignment(playerid, Wheels[playerid][5], 1);
	PlayerTextDrawColor(playerid, Wheels[playerid][5], -1);
	PlayerTextDrawSetShadow(playerid, Wheels[playerid][5], 0);
	PlayerTextDrawSetOutline(playerid, Wheels[playerid][5], 0);
	PlayerTextDrawBackgroundColor(playerid, Wheels[playerid][5], 0);
	PlayerTextDrawFont(playerid, Wheels[playerid][5], 5);
	PlayerTextDrawSetProportional(playerid, Wheels[playerid][5], 1);
	PlayerTextDrawSetShadow(playerid, Wheels[playerid][5], 0);
	PlayerTextDrawSetSelectable(playerid, Wheels[playerid][5], true);
	PlayerTextDrawSetPreviewModel(playerid, Wheels[playerid][5], 1075);
	PlayerTextDrawSetPreviewRot(playerid, Wheels[playerid][5], 0.000000, 0.000000, 90.000000, 1.000000);

	Wheels[playerid][6] = CreatePlayerTextDraw(playerid, 385.000000, 174.250000, "");//1076
	PlayerTextDrawLetterSize(playerid, Wheels[playerid][6], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, Wheels[playerid][6], 43.500000, 41.437500);
	PlayerTextDrawAlignment(playerid, Wheels[playerid][6], 1);
	PlayerTextDrawColor(playerid, Wheels[playerid][6], -1);
	PlayerTextDrawSetShadow(playerid, Wheels[playerid][6], 0);
	PlayerTextDrawSetOutline(playerid, Wheels[playerid][6], 0);
	PlayerTextDrawBackgroundColor(playerid, Wheels[playerid][6], 0);
	PlayerTextDrawFont(playerid, Wheels[playerid][6], 5);
	PlayerTextDrawSetProportional(playerid, Wheels[playerid][6], 1);
	PlayerTextDrawSetShadow(playerid, Wheels[playerid][6], 0);
	PlayerTextDrawSetSelectable(playerid, Wheels[playerid][6], true);
	PlayerTextDrawSetPreviewModel(playerid, Wheels[playerid][6], 1076);
	PlayerTextDrawSetPreviewRot(playerid, Wheels[playerid][6], 0.000000, 0.000000, 90.000000, 1.000000);

	Wheels[playerid][7] = CreatePlayerTextDraw(playerid, 457.500000, 174.250000, ""); //1077
	PlayerTextDrawLetterSize(playerid, Wheels[playerid][7], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, Wheels[playerid][7], 43.500000, 41.437500);
	PlayerTextDrawAlignment(playerid, Wheels[playerid][7], 1);
	PlayerTextDrawColor(playerid, Wheels[playerid][7], -1);
	PlayerTextDrawSetShadow(playerid, Wheels[playerid][7], 0);
	PlayerTextDrawSetOutline(playerid, Wheels[playerid][7], 0);
	PlayerTextDrawBackgroundColor(playerid, Wheels[playerid][7], 0);
	PlayerTextDrawFont(playerid, Wheels[playerid][7], 5);
	PlayerTextDrawSetProportional(playerid, Wheels[playerid][7], 1);
	PlayerTextDrawSetShadow(playerid, Wheels[playerid][7], 0);
	PlayerTextDrawSetSelectable(playerid, Wheels[playerid][7], true);
	PlayerTextDrawSetPreviewModel(playerid, Wheels[playerid][7], 1077);
	PlayerTextDrawSetPreviewRot(playerid, Wheels[playerid][7], 0.000000, 0.000000, 90.000000, 1.000000);

	Wheels[playerid][8] = CreatePlayerTextDraw(playerid, 168.000000, 224.562500, ""); //1078
	PlayerTextDrawLetterSize(playerid, Wheels[playerid][8], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, Wheels[playerid][8], 43.500000, 41.437500);
	PlayerTextDrawAlignment(playerid, Wheels[playerid][8], 1);
	PlayerTextDrawColor(playerid, Wheels[playerid][8], -1);
	PlayerTextDrawSetShadow(playerid, Wheels[playerid][8], 0);
	PlayerTextDrawSetOutline(playerid, Wheels[playerid][8], 0);
	PlayerTextDrawBackgroundColor(playerid, Wheels[playerid][8], 0);
	PlayerTextDrawFont(playerid, Wheels[playerid][8], 5);
	PlayerTextDrawSetProportional(playerid, Wheels[playerid][8], 1);
	PlayerTextDrawSetShadow(playerid, Wheels[playerid][8], 0);
	PlayerTextDrawSetSelectable(playerid, Wheels[playerid][8], true);
	PlayerTextDrawSetPreviewModel(playerid, Wheels[playerid][8], 1078);
	PlayerTextDrawSetPreviewRot(playerid, Wheels[playerid][8], 0.000000, 0.000000, 90.000000, 1.000000);

	Wheels[playerid][9] = CreatePlayerTextDraw(playerid, 241.000000, 223.687500, "");  //1079
	PlayerTextDrawLetterSize(playerid, Wheels[playerid][9], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, Wheels[playerid][9], 43.500000, 41.437500);
	PlayerTextDrawAlignment(playerid, Wheels[playerid][9], 1);
	PlayerTextDrawColor(playerid, Wheels[playerid][9], -1);
	PlayerTextDrawSetShadow(playerid, Wheels[playerid][9], 0);
	PlayerTextDrawSetOutline(playerid, Wheels[playerid][9], 0);
	PlayerTextDrawBackgroundColor(playerid, Wheels[playerid][9], 0);
	PlayerTextDrawFont(playerid, Wheels[playerid][9], 5);
	PlayerTextDrawSetProportional(playerid, Wheels[playerid][9], 1);
	PlayerTextDrawSetShadow(playerid, Wheels[playerid][9], 0);
	PlayerTextDrawSetSelectable(playerid, Wheels[playerid][9], true);
	PlayerTextDrawSetPreviewModel(playerid, Wheels[playerid][9], 1079);
	PlayerTextDrawSetPreviewRot(playerid, Wheels[playerid][9], 0.000000, 0.000000, 90.000000, 1.000000);

	Wheels[playerid][10] = CreatePlayerTextDraw(playerid, 312.500000, 224.562500, "");  //1080
	PlayerTextDrawLetterSize(playerid, Wheels[playerid][10], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, Wheels[playerid][10], 43.500000, 41.437500);
	PlayerTextDrawAlignment(playerid, Wheels[playerid][10], 1);
	PlayerTextDrawColor(playerid, Wheels[playerid][10], -1);
	PlayerTextDrawSetShadow(playerid, Wheels[playerid][10], 0);
	PlayerTextDrawSetOutline(playerid, Wheels[playerid][10], 0);
	PlayerTextDrawBackgroundColor(playerid, Wheels[playerid][10], 0);
	PlayerTextDrawFont(playerid, Wheels[playerid][10], 5);
	PlayerTextDrawSetProportional(playerid, Wheels[playerid][10], 1);
	PlayerTextDrawSetShadow(playerid, Wheels[playerid][10], 0);
	PlayerTextDrawSetSelectable(playerid, Wheels[playerid][10], true);
	PlayerTextDrawSetPreviewModel(playerid, Wheels[playerid][10], 1080);
	PlayerTextDrawSetPreviewRot(playerid, Wheels[playerid][10], 0.000000, 0.000000, 90.000000, 1.000000);

	Wheels[playerid][11] = CreatePlayerTextDraw(playerid, 386.000000, 223.687500, "");  //1081
	PlayerTextDrawLetterSize(playerid, Wheels[playerid][11], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, Wheels[playerid][11], 43.500000, 41.437500);
	PlayerTextDrawAlignment(playerid, Wheels[playerid][11], 1);
	PlayerTextDrawColor(playerid, Wheels[playerid][11], -1);
	PlayerTextDrawSetShadow(playerid, Wheels[playerid][11], 0);
	PlayerTextDrawSetOutline(playerid, Wheels[playerid][11], 0);
	PlayerTextDrawBackgroundColor(playerid, Wheels[playerid][11], 0);
	PlayerTextDrawFont(playerid, Wheels[playerid][11], 5);
	PlayerTextDrawSetProportional(playerid, Wheels[playerid][11], 1);
	PlayerTextDrawSetShadow(playerid, Wheels[playerid][11], 0);
	PlayerTextDrawSetSelectable(playerid, Wheels[playerid][11], true);
	PlayerTextDrawSetPreviewModel(playerid, Wheels[playerid][11], 1081);
	PlayerTextDrawSetPreviewRot(playerid, Wheels[playerid][11], 0.000000, 0.000000, 90.000000, 1.000000);

	Wheels[playerid][12] = CreatePlayerTextDraw(playerid, 458.000000, 222.375000, ""); //1082
	PlayerTextDrawLetterSize(playerid, Wheels[playerid][12], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, Wheels[playerid][12], 43.500000, 41.437500);
	PlayerTextDrawAlignment(playerid, Wheels[playerid][12], 1);
	PlayerTextDrawColor(playerid, Wheels[playerid][12], -1);
	PlayerTextDrawSetShadow(playerid, Wheels[playerid][12], 0);
	PlayerTextDrawSetOutline(playerid, Wheels[playerid][12], 0);
	PlayerTextDrawBackgroundColor(playerid, Wheels[playerid][12], 0);
	PlayerTextDrawFont(playerid, Wheels[playerid][12], 5);
	PlayerTextDrawSetProportional(playerid, Wheels[playerid][12], 1);
	PlayerTextDrawSetShadow(playerid, Wheels[playerid][12], 0);
	PlayerTextDrawSetSelectable(playerid, Wheels[playerid][12], true);
	PlayerTextDrawSetPreviewModel(playerid, Wheels[playerid][12], 1082);
	PlayerTextDrawSetPreviewRot(playerid, Wheels[playerid][12], 0.000000, 0.000000, 90.000000, 1.000000);

	Wheels[playerid][13] = CreatePlayerTextDraw(playerid, 168.500000, 276.187500, ""); //1083
	PlayerTextDrawLetterSize(playerid, Wheels[playerid][13], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, Wheels[playerid][13], 43.500000, 41.437500);
	PlayerTextDrawAlignment(playerid, Wheels[playerid][13], 1);
	PlayerTextDrawColor(playerid, Wheels[playerid][13], -1);
	PlayerTextDrawSetShadow(playerid, Wheels[playerid][13], 0);
	PlayerTextDrawSetOutline(playerid, Wheels[playerid][13], 0);
	PlayerTextDrawBackgroundColor(playerid, Wheels[playerid][13], 0);
	PlayerTextDrawFont(playerid, Wheels[playerid][13], 5);
	PlayerTextDrawSetProportional(playerid, Wheels[playerid][13], 1);
	PlayerTextDrawSetShadow(playerid, Wheels[playerid][13], 0);
	PlayerTextDrawSetSelectable(playerid, Wheels[playerid][13], true);
	PlayerTextDrawSetPreviewModel(playerid, Wheels[playerid][13], 1083);
	PlayerTextDrawSetPreviewRot(playerid, Wheels[playerid][13], 0.000000, 0.000000, 90.000000, 1.000000);

	Wheels[playerid][14] = CreatePlayerTextDraw(playerid, 242.000000, 275.750000, ""); //1084
	PlayerTextDrawLetterSize(playerid, Wheels[playerid][14], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, Wheels[playerid][14], 43.500000, 41.437500);
	PlayerTextDrawAlignment(playerid, Wheels[playerid][14], 1);
	PlayerTextDrawColor(playerid, Wheels[playerid][14], -1);
	PlayerTextDrawSetShadow(playerid, Wheels[playerid][14], 0);
	PlayerTextDrawSetOutline(playerid, Wheels[playerid][14], 0);
	PlayerTextDrawBackgroundColor(playerid, Wheels[playerid][14], 0);
	PlayerTextDrawFont(playerid, Wheels[playerid][14], 5);
	PlayerTextDrawSetProportional(playerid, Wheels[playerid][14], 1);
	PlayerTextDrawSetShadow(playerid, Wheels[playerid][14], 0);
	PlayerTextDrawSetSelectable(playerid, Wheels[playerid][14], true);
	PlayerTextDrawSetPreviewModel(playerid, Wheels[playerid][14], 1084);
	PlayerTextDrawSetPreviewRot(playerid, Wheels[playerid][14], 0.000000, 0.000000, 90.000000, 1.000000);

	Wheels[playerid][15] = CreatePlayerTextDraw(playerid, 314.000000, 276.625000, ""); //1085
	PlayerTextDrawLetterSize(playerid, Wheels[playerid][15], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, Wheels[playerid][15], 43.500000, 41.437500);
	PlayerTextDrawAlignment(playerid, Wheels[playerid][15], 1);
	PlayerTextDrawColor(playerid, Wheels[playerid][15], -1);
	PlayerTextDrawSetShadow(playerid, Wheels[playerid][15], 0);
	PlayerTextDrawSetOutline(playerid, Wheels[playerid][15], 0);
	PlayerTextDrawBackgroundColor(playerid, Wheels[playerid][15], 0);
	PlayerTextDrawFont(playerid, Wheels[playerid][15], 5);
	PlayerTextDrawSetProportional(playerid, Wheels[playerid][15], 1);
	PlayerTextDrawSetShadow(playerid, Wheels[playerid][15], 0);
	PlayerTextDrawSetSelectable(playerid, Wheels[playerid][15], true);
	PlayerTextDrawSetPreviewModel(playerid, Wheels[playerid][15], 1085);
	PlayerTextDrawSetPreviewRot(playerid, Wheels[playerid][15], 0.000000, 0.000000, 90.000000, 1.000000);
	
	Wheels[playerid][16] = CreatePlayerTextDraw(playerid, 170.000000, 176.437500, ""); // 1025 V2--------
	PlayerTextDrawLetterSize(playerid, Wheels[playerid][16], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, Wheels[playerid][16], 43.500000, 41.437500);
	PlayerTextDrawAlignment(playerid, Wheels[playerid][16], 1);
	PlayerTextDrawColor(playerid, Wheels[playerid][16], -1);
	PlayerTextDrawSetShadow(playerid, Wheels[playerid][16], 0);
	PlayerTextDrawSetOutline(playerid, Wheels[playerid][16], 0);
	PlayerTextDrawBackgroundColor(playerid, Wheels[playerid][16], 0);
	PlayerTextDrawFont(playerid, Wheels[playerid][16], 5);
	PlayerTextDrawSetProportional(playerid, Wheels[playerid][16], 1);
	PlayerTextDrawSetShadow(playerid, Wheels[playerid][16], 0);
	PlayerTextDrawSetSelectable(playerid, Wheels[playerid][16], true);
	PlayerTextDrawSetPreviewModel(playerid, Wheels[playerid][16], 1025);
	PlayerTextDrawSetPreviewRot(playerid, Wheels[playerid][16], 0.000000, 0.000000, 90.000000, 1.000000);
	
	Wheels[playerid][17] = CreatePlayerTextDraw(playerid, 241.500000, 175.125000, ""); //1096 V2--------
	PlayerTextDrawLetterSize(playerid, Wheels[playerid][17], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, Wheels[playerid][17], 43.500000, 41.437500);
	PlayerTextDrawAlignment(playerid, Wheels[playerid][17], 1);
	PlayerTextDrawColor(playerid, Wheels[playerid][17], -1);
	PlayerTextDrawSetShadow(playerid, Wheels[playerid][17], 0);
	PlayerTextDrawSetOutline(playerid, Wheels[playerid][17], 0);
	PlayerTextDrawBackgroundColor(playerid, Wheels[playerid][17], 0);
	PlayerTextDrawFont(playerid, Wheels[playerid][17], 5);
	PlayerTextDrawSetProportional(playerid, Wheels[playerid][17], 1);
	PlayerTextDrawSetShadow(playerid, Wheels[playerid][17], 0);
	PlayerTextDrawSetSelectable(playerid, Wheels[playerid][17], true);
	PlayerTextDrawSetPreviewModel(playerid, Wheels[playerid][17], 1096);
	PlayerTextDrawSetPreviewRot(playerid, Wheels[playerid][17], 0.000000, 0.000000, 90.000000, 1.000000);
	
	Wheels[playerid][18] = CreatePlayerTextDraw(playerid, 313.000000, 176.000000, "");
	PlayerTextDrawLetterSize(playerid, Wheels[playerid][18], 0.000000, 0.000000); // 1097 V2--------
	PlayerTextDrawTextSize(playerid, Wheels[playerid][18], 43.500000, 41.437500);
	PlayerTextDrawAlignment(playerid, Wheels[playerid][18], 1);
	PlayerTextDrawColor(playerid, Wheels[playerid][18], -1);
	PlayerTextDrawSetShadow(playerid, Wheels[playerid][18], 0);
	PlayerTextDrawSetOutline(playerid, Wheels[playerid][18], 0);
	PlayerTextDrawBackgroundColor(playerid, Wheels[playerid][18], 0);
	PlayerTextDrawFont(playerid, Wheels[playerid][18], 5);
	PlayerTextDrawSetProportional(playerid, Wheels[playerid][18], 1);
	PlayerTextDrawSetShadow(playerid, Wheels[playerid][18], 0);
	PlayerTextDrawSetSelectable(playerid, Wheels[playerid][18], true);
	PlayerTextDrawSetPreviewModel(playerid, Wheels[playerid][18], 1097);
	PlayerTextDrawSetPreviewRot(playerid, Wheels[playerid][18], 0.000000, 0.000000, 90.000000, 1.000000);
	
	Wheels[playerid][19] = CreatePlayerTextDraw(playerid, 385.000000, 174.250000, ""); //1098 V2--------
	PlayerTextDrawLetterSize(playerid, Wheels[playerid][19], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, Wheels[playerid][19], 43.500000, 41.437500);
	PlayerTextDrawAlignment(playerid, Wheels[playerid][19], 1);
	PlayerTextDrawColor(playerid, Wheels[playerid][19], -1);
	PlayerTextDrawSetShadow(playerid, Wheels[playerid][19], 0);
	PlayerTextDrawSetOutline(playerid, Wheels[playerid][19], 0);
	PlayerTextDrawBackgroundColor(playerid, Wheels[playerid][19], 0);
	PlayerTextDrawFont(playerid, Wheels[playerid][19], 5);
	PlayerTextDrawSetProportional(playerid, Wheels[playerid][19], 1);
	PlayerTextDrawSetShadow(playerid, Wheels[playerid][19], 0);
	PlayerTextDrawSetSelectable(playerid, Wheels[playerid][19], true);
	PlayerTextDrawSetPreviewModel(playerid, Wheels[playerid][19], 1098);
	PlayerTextDrawSetPreviewRot(playerid, Wheels[playerid][19], 0.000000, 0.000000, 90.000000, 1.000000);

	Wheels[playerid][20] = CreatePlayerTextDraw(playerid, 437.500000, 312.500000, "box");
	PlayerTextDrawLetterSize(playerid, Wheels[playerid][20], 0.000000, 1.549998);
	PlayerTextDrawTextSize(playerid, Wheels[playerid][20], 506.000000, 0.000000);
	PlayerTextDrawAlignment(playerid, Wheels[playerid][20], 1);
	PlayerTextDrawColor(playerid, Wheels[playerid][20], -1);
	PlayerTextDrawUseBox(playerid, Wheels[playerid][20], 1);
	PlayerTextDrawBoxColor(playerid, Wheels[playerid][20], 95);
	PlayerTextDrawSetShadow(playerid, Wheels[playerid][20], 0);
	PlayerTextDrawSetOutline(playerid, Wheels[playerid][20], 0);
	PlayerTextDrawBackgroundColor(playerid, Wheels[playerid][20], 255);
	PlayerTextDrawFont(playerid, Wheels[playerid][20], 1);
	PlayerTextDrawSetProportional(playerid, Wheels[playerid][20], 1);
	PlayerTextDrawSetShadow(playerid, Wheels[playerid][20], 0);

	Wheels[playerid][21] = CreatePlayerTextDraw(playerid, 454.500000, 312.500000, "BACK");
	PlayerTextDrawLetterSize(playerid, Wheels[playerid][21], 0.265498, 1.385625);
	PlayerTextDrawAlignment(playerid, Wheels[playerid][21], 1);
	PlayerTextDrawColor(playerid, Wheels[playerid][21], -1);
	PlayerTextDrawSetShadow(playerid, Wheels[playerid][21], 0);
	PlayerTextDrawSetOutline(playerid, Wheels[playerid][21], 0);
	PlayerTextDrawBackgroundColor(playerid, Wheels[playerid][21], 255);
	PlayerTextDrawFont(playerid, Wheels[playerid][21], 2);
	PlayerTextDrawSetProportional(playerid, Wheels[playerid][21], 1);
	PlayerTextDrawSetShadow(playerid, Wheels[playerid][21], 0);
	PlayerTextDrawSetSelectable(playerid, Wheels[playerid][21], true);
	
	Wheels[playerid][22] = CreatePlayerTextDraw(playerid, 477.000000, 155.000000, "Next ~g~>"); // V2--------
	PlayerTextDrawLetterSize(playerid, Wheels[playerid][22], 0.250999, 1.066249);
	PlayerTextDrawAlignment(playerid, Wheels[playerid][22], 1);
	PlayerTextDrawColor(playerid, Wheels[playerid][22], -1);
	PlayerTextDrawSetShadow(playerid, Wheels[playerid][22], 0);
	PlayerTextDrawSetOutline(playerid, Wheels[playerid][22], 0);
	PlayerTextDrawBackgroundColor(playerid, Wheels[playerid][22], 255);
	PlayerTextDrawFont(playerid, Wheels[playerid][22], 1);
	PlayerTextDrawSetProportional(playerid, Wheels[playerid][22], 1);
	PlayerTextDrawSetShadow(playerid, Wheels[playerid][22], 0);
	PlayerTextDrawSetSelectable(playerid, Wheels[playerid][22], true);
	return 1;
}
stock DestroyWheelMenu(playerid)
{
	for(new i=0; i < 23; i++) {
		PlayerTextDrawDestroy(playerid, Wheels[playerid][i]);
	}
	Page[playerid] = 1;
	return 1;
}
forward ShowWheels(playerid);
public ShowWheels(playerid)
{
	PlayerTextDrawShow(playerid, Wheels[playerid][0]);
	PlayerTextDrawShow(playerid, Wheels[playerid][1]);
	PlayerTextDrawShow(playerid, Wheels[playerid][2]);
	PlayerTextDrawShow(playerid, Wheels[playerid][3]);
	PlayerTextDrawShow(playerid, Wheels[playerid][4]);
	PlayerTextDrawShow(playerid, Wheels[playerid][5]);
	PlayerTextDrawShow(playerid, Wheels[playerid][6]);
	PlayerTextDrawShow(playerid, Wheels[playerid][7]);
	PlayerTextDrawShow(playerid, Wheels[playerid][8]);
	PlayerTextDrawShow(playerid, Wheels[playerid][9]);
	PlayerTextDrawShow(playerid, Wheels[playerid][10]);
	PlayerTextDrawShow(playerid, Wheels[playerid][11]);
	PlayerTextDrawShow(playerid, Wheels[playerid][12]);
	PlayerTextDrawShow(playerid, Wheels[playerid][13]);
	PlayerTextDrawShow(playerid, Wheels[playerid][14]);
	PlayerTextDrawShow(playerid, Wheels[playerid][15]);
	PlayerTextDrawShow(playerid, Wheels[playerid][20]);

	PlayerTextDrawShow(playerid, Wheels[playerid][22]);
	PlayerTextDrawSetString(playerid, Wheels[playerid][22], "Next ~g~>");
	PlayerTextDrawShow(playerid, Wheels[playerid][21]);
	Page[playerid] = 1;
   
	SelectTextDraw(playerid,0xFFFFFFFF);
	return 1;
}
stock HideWheels(playerid)
{
	PlayerTextDrawHide(playerid, Wheels[playerid][0]);
	PlayerTextDrawHide(playerid, Wheels[playerid][1]);
	PlayerTextDrawHide(playerid, Wheels[playerid][2]);
	PlayerTextDrawHide(playerid, Wheels[playerid][3]);
	PlayerTextDrawHide(playerid, Wheels[playerid][4]);
	PlayerTextDrawHide(playerid, Wheels[playerid][5]);
	PlayerTextDrawHide(playerid, Wheels[playerid][6]);
	PlayerTextDrawHide(playerid, Wheels[playerid][7]);
	PlayerTextDrawHide(playerid, Wheels[playerid][8]);
	PlayerTextDrawHide(playerid, Wheels[playerid][9]);
	PlayerTextDrawHide(playerid, Wheels[playerid][10]);
	PlayerTextDrawHide(playerid, Wheels[playerid][11]);
	PlayerTextDrawHide(playerid, Wheels[playerid][12]);
	PlayerTextDrawHide(playerid, Wheels[playerid][13]);
	PlayerTextDrawHide(playerid, Wheels[playerid][14]);
	PlayerTextDrawHide(playerid, Wheels[playerid][15]);
	PlayerTextDrawHide(playerid, Wheels[playerid][16]);
	PlayerTextDrawHide(playerid, Wheels[playerid][17]);
	PlayerTextDrawHide(playerid, Wheels[playerid][18]);
	PlayerTextDrawHide(playerid, Wheels[playerid][19]);
	PlayerTextDrawHide(playerid, Wheels[playerid][20]);
	PlayerTextDrawHide(playerid, Wheels[playerid][21]);
	PlayerTextDrawHide(playerid, Wheels[playerid][22]);
	Page[playerid] = 0;
	CancelSelectTextDraw(playerid);
	return 1;
}
stock ShowWPage2(playerid)
{
    PlayerTextDrawHide(playerid, Wheels[playerid][3]);
	PlayerTextDrawHide(playerid, Wheels[playerid][4]);
	PlayerTextDrawHide(playerid, Wheels[playerid][5]);
	PlayerTextDrawHide(playerid, Wheels[playerid][6]);
	PlayerTextDrawHide(playerid, Wheels[playerid][7]);
	PlayerTextDrawHide(playerid, Wheels[playerid][8]);
	PlayerTextDrawHide(playerid, Wheels[playerid][9]);
	PlayerTextDrawHide(playerid, Wheels[playerid][10]);
	PlayerTextDrawHide(playerid, Wheels[playerid][11]);
	PlayerTextDrawHide(playerid, Wheels[playerid][12]);
	PlayerTextDrawHide(playerid, Wheels[playerid][13]);
	PlayerTextDrawHide(playerid, Wheels[playerid][14]);
	PlayerTextDrawHide(playerid, Wheels[playerid][15]);
   
	PlayerTextDrawShow(playerid, Wheels[playerid][16]);
	PlayerTextDrawShow(playerid, Wheels[playerid][17]);
	PlayerTextDrawShow(playerid, Wheels[playerid][18]);
	PlayerTextDrawShow(playerid, Wheels[playerid][19]);
   
	PlayerTextDrawSetString(playerid, Wheels[playerid][22], "Prev ~g~<");
	PlayerTextDrawShow(playerid, Wheels[playerid][22]);
	Page[playerid] = 2;
   
	return 1;
}
stock ShowWPage1(playerid)
{
    PlayerTextDrawShow(playerid, Wheels[playerid][3]);
	PlayerTextDrawShow(playerid, Wheels[playerid][4]);
	PlayerTextDrawShow(playerid, Wheels[playerid][5]);
	PlayerTextDrawShow(playerid, Wheels[playerid][6]);
	PlayerTextDrawShow(playerid, Wheels[playerid][7]);
	PlayerTextDrawShow(playerid, Wheels[playerid][8]);
	PlayerTextDrawShow(playerid, Wheels[playerid][9]);
	PlayerTextDrawShow(playerid, Wheels[playerid][10]);
	PlayerTextDrawShow(playerid, Wheels[playerid][11]);
	PlayerTextDrawShow(playerid, Wheels[playerid][12]);
	PlayerTextDrawShow(playerid, Wheels[playerid][13]);
	PlayerTextDrawShow(playerid, Wheels[playerid][14]);
	PlayerTextDrawShow(playerid, Wheels[playerid][15]);
   
	PlayerTextDrawHide(playerid, Wheels[playerid][16]);
	PlayerTextDrawHide(playerid, Wheels[playerid][17]);
	PlayerTextDrawHide(playerid, Wheels[playerid][18]);
	PlayerTextDrawHide(playerid, Wheels[playerid][19]);
   
	PlayerTextDrawSetString(playerid, Wheels[playerid][22], "Next ~g~>");
	PlayerTextDrawShow(playerid, Wheels[playerid][22]);
	Page[playerid] = 1;
   
	return 1;
}
//============================================//
stock BuildFishingTextdraws(playerid)
{
	Fishdraw0[playerid] = CreatePlayerTextDraw(playerid, 624.375000, 215.833282, "Fishing...");
	PlayerTextDrawLetterSize(playerid, Fishdraw0[playerid], 0.618125, 2.323333);
	PlayerTextDrawTextSize(playerid, Fishdraw0[playerid], -505.000000, -222.833374);
	PlayerTextDrawAlignment(playerid, Fishdraw0[playerid], 3);
	PlayerTextDrawColor(playerid, Fishdraw0[playerid], -1);
	PlayerTextDrawSetShadow(playerid, Fishdraw0[playerid], 0);
	PlayerTextDrawSetOutline(playerid, Fishdraw0[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, Fishdraw0[playerid], 65535);
	PlayerTextDrawFont(playerid, Fishdraw0[playerid], 1);
	PlayerTextDrawSetProportional(playerid, Fishdraw0[playerid], 1);
	return 1;
}

stock ShowFishingTD(playerid)
{
	PlayerTextDrawShow(playerid, Fishdraw0[playerid]);
	return 1;
}

stock HideFishingTD(playerid)
{
	PlayerTextDrawHide(playerid, Fishdraw0[playerid]);
	return 1;
}
//============================================//