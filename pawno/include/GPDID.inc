/************************************************************
 * GetPlayerDialogID(playerid) With Anti-Dialog Hack! V2.1	*
 * Credits: wups			  								*
 ************************************************************/

// include
#include <a_samp>


// defines
#if defined _GPDID
	#endinput
#endif
#define _GPDID

#if !defined isnull // credits Y_Less
	#define isnull(%1) \
		((!(%1[0])) || (((%1[0]) == '\1') && (!(%1[1]))))
#endif
// The main function:
#define GPDID GetPlayerDialogID
#define GetPlayerDialogID(%0) (GetPVarInt(%0,"P_DIALOGID"))

// variables

static
	bool:GPD_ODR;
	
	
// forwards
// forward OnPlayerDialogChange(playerid,lastdialog,newdialog);
// I don't think this is needed.

// Functions

// ShowPlayerDialog
stock GPD_ShowPlayerDialog(playerid,dialogid,style,caption[],info[],button1[],button2[])
{
	SetPVarInt(playerid,"P_DIALOGID",dialogid);
	return ShowPlayerDialog(playerid,dialogid,style,caption,info,button1,button2);
}

#define ShowPlayerDialog GPD_ShowPlayerDialog



// OnPlayerKeyStateChange
public OnDialogResponse(playerid,dialogid,response,listitem,inputtext[])
{
	dialogid=GetPVarInt(playerid,"P_DIALOGID");
	SetPVarInt(playerid,"P_DIALOGID",-1);
	return (GPD_ODR)?CallLocalFunction("GPD_OnDialogResponse","iiiis",playerid,dialogid,response,listitem,(((isnull(inputtext)) ? ("\1\0"):(inputtext)))):0;
}
#if defined _ALS_OnDialogResponse
	#undef OnDialogResponse
#else
	#define _ALS_OnDialogResponse
#endif
#define OnDialogResponse GPD_OnDialogResponse
forward GPD_OnDialogResponse(playerid,dialogid,response,listitem,inputtext[]);


#if !defined FILTERSCRIPT
	// OnGameModeInit
	public OnGameModeInit()
	{
		GPD_ODR = (funcidx("GPD_OnDialogResponse") != -1);
		return (funcidx("GPD_OnGameModeInit") != -1)?CallLocalFunction("GPD_OnGameModeInit",""):1;
	}
	#if defined _ALS_OnGameModeInit
		#undef OnGameModeInit
	#else
		#define _ALS_OnGameModeInit
	#endif
	#define OnGameModeInit GPD_OnGameModeInit
	forward GPD_OnGameModeInit();
#else
	// OnFilterScriptInit
	public OnFilterScriptInit()
	{
		GPD_ODR = (funcidx("GPD_OnDialogResponse") != -1);
		return (funcidx("GPD_OnFilterScriptInit") != -1)?CallLocalFunction("GPD_OnFilterScriptInit",""):1;
	}
	#if defined _ALS_OnFilterScriptInit
		#undef OnFilterScriptInit
	#else
		#define _ALS_OnFilterScriptInit
	#endif
	#define OnFilterScriptInit GPD_OnFilterScriptInit
	forward GPD_OnFilterScriptInit();
#endif


// The end.
