//================Forwarding================//
forward LoadStats(playerid);
//==========================================//

//==================Defines=================//

//==========================================//

//============New/Enum statments============//

enum skillArrayEnum
{
	Name[42],
	MaxXP,
	MaxLevel
}
/*================Skill IDs=================
(0.) Strength
(1.) 
==============End of Skill IDs==============
============================================*/

new skillArray[1][skillArrayEnum] = { // Skill name, Max XP(*currentLevel), MaxLevel
	{"Strength", 100, 8}
};

enum skillEnum
{
	Exp,
	Level
}
new Skills[MAX_PLAYERS][1][skillEnum];
//==========================================//

//================Build Code================//
stock SaveLevel(playerid,id) {
	new name = skillArray[id][Name];
	new query[128];
	//TODO Save Level
	SaveExp(playerid,id);
	return 1
}

stock LevelUp(playerid,id) {
	Skills[playerid][id][Exp] = 0;
	SaveLevel(playerid,id);
	return Skills[playerid][id][Level];
}

stock SetLevel(playerid,id,val) {
	Skills[playerid][id][Level]	= val;
	SaveLevel(playerid,id);
	return 1;
}

stock GetLevel(playerid,id,val) {
	return Skills[playerid][id][Level];
}

stock SaveExp(playerid,id) {
	return 1;
}

stock SetExp(playerid,id,val) {
	if val >= (Skills[playerid][id][Level]*skillArray[id][MaxXP]) {
		LevelUp(id);
		return 1;
	}
	Skills[playerid][id][Exp] = val;
	SaveExp(playerid,id);
	return 1;
}

stock AddExp(playerid,stat,amt) {
	if (Skills[playerid][id][Exp]+amt) >= (Skills[playerid][id][Level]*skillArray[id][MaxXP]) {
		LevelUp(id);
		return 1;
	}
	Skills[playerid][id][Exp] = Skills[playerid][id][Exp]+amt;
	SaveExp(playerid,id);
	return 1;
}

stock GetExp(playerid,stat,val) {
	return Skills[playerid][id][Exp];
}


stock ShowStatDialog(playerid,stat,val) {
	return 1;
}

public LoadStats(playerid) {
	//TODO - LoadStats
	return 1;
}
//==========================================//
