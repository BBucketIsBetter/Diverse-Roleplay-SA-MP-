/*===============Description==================
				.:FCNPC:.
			  .:AI Library:.
			  
		---------------------------
		-My attempt at writing an AI library 
		 (pawn-extension) using FCNPC in SA:MP.
		---------------------------
		Functions:
			*AI_CreateNPC(name[], team=0, dod=1, targetPlayer=1) - Create and return an ID for an NPC. (Not yet spawned.) 
				-(team == 0 == friendly | team == 1 == bad | team == 2 == hostile | team == 3 == neutral.) 
				-(dod = 1 = destroy on death. [Default: 1 (true)])
				-(targetPlayer = 1 = priority targetting against players. (Default: 1 (1 = Target players over NPCs | 2 = Target NPCs over players.)))
			*AI_DestroyNPC(id) - Remove the NPC from memory, destroy it if it's spawned.
			*AI_DestroyNPCReference(referenceID) - Finds an NPC by it's reference ID, then proceeds to destroy it like AI_DestroyNPC(id).
			*AI_SpawnNPC(id, skinid, X, Y, Z) - Spawn an already created NPC.
			*AI_SetAttackType(id, type) - Sets the NPCs attack type. (0 = melee, 1 = armed.)
		
		Back-end Functions:
			*AI_Think() - You should never need to call this, starts the loop for AI thinking.
			
		Helper functions:
			*GetIDByRef(referenceID) - returns the an array-index of a AI NPC who's reference ID (FCNPC ID) matches the stored 'refID'. Returns '-1' when there is no AI NPC with a matching reference ID.
			*GetRefByID(id) - returns the reference ID stored in AI_NPCS[id]. [low-resource]
			
		Loop-specific Helper Functions:
			*AI_Target(id) - [Internal] Sets the AIs target to the id-specified. NOTE: Targetting relies on AI_NPCS[id][targetType] as well. Calls outside of the targeting in AI_Think() are useless.
			*AI_TargetVehicle(vehicleid) - Forces the AI to target the specified 'vehicleid'.
			*AI_ClearTarget() - Resets an NPCs targeting data.
			*IsValidTarget(id, targetid) - Returns '0' if the target is deemed invalid, returns '1' if the target is deemed valid.
		
		Callbacks:
			*AI_OnDestroyed(id) - Called just before an AI NPC is destroyed.
			
		NOTE: We need to make CallRemoteFunction's throughout the gamemode for some events like:
			--public AI_OnPlayerEnterVehicle(playerid);
============================================*/

//================Forwarding================//
//Core Functions:

//Helper functions:

//Callbacks:
forward AI_OnDestroyed(id);
//==========================================//

//==================Defines=================//
#define MAX_AI 50; //Max AI allowed at one time.
#define SKIP_FRAMES 3; //Skip this many frames between each AI calculation. (The more frames you skip, the less CPU usage, but the more choppy the AI.)

//TEAM_ defines:
#define TEAM_FRIENDLY 0
#define TEAM_BAD 1
#define TEAM_HOSTILE 2
#define TEAM_NEUTRAL 3

//ATTACK_TYPE_ defines:
#define ATTACK_TYPE_MELEE 0
#define ATACK_TYPE_GUN 1

//TARGET_TYPE_ defines:
#define TARGET_TYPE_NPC 0
#define TARGET_TYPE_PLAYER 1
#define TARGET_TYPE_VEHICLE 2

//Point unchanged functions back to FCNPC.
#define AI_SetUpdateRate(%1) FCNPC_SetUpdateRate(%1)
#define AI_InitZMap(%1) FCNPC_InitZMap(%1)
#define AI_SpawnNPC(%1,%2,%3,%4,%5) FCNPC_Spawn(%1,%2,%3,%4,%5)
#define AI_Respawn(%1) FCNPC_Respawn(%1)
#define AI_Kill(%s) FCNPC_Kill(%1)
//TODO: rest of the AI_ defines.
//==========================================//

//============New/Enum statments============//
new Iterator:AIIterator<MAX_AI> //An iterator containing an index of AI_NPCS.

enum aiEnum {
	refID=-1,
	targetID=-1,
	targetType,
	playerFirst,
	attackType,
	Team,
	Paused,
	DOD=1 //Destroy on death.
};
static AI_NPCS[MAX_AI][aiEnum];
static AI_Active = 0;
//==========================================//

//================Build Code================//
//Helper functions:
static GetIDByRef(referenceID) {
	foreach(new id : AIIterator) { if (AI_NPCS[id][refID] == id) return id; }
	return -1;
}
static GetRefByID(id) { return AI_NPCS[id][refID]; }

//Functions:
stock AI_CreateNPC(name[], team=0, dod=1, targetPlayer=1) {
	for (new i=0; i < sizeof(AI_NPCS); i++) {
		if (AI_NPCS[i][refID] == -1) {
			if (AI_Active == 0) { //Run our loop.
				AI_Active == 1;
				AI_Think();
			}
			new id = FCNPC_Create(name);
			if (id == INVALID_ENTITY_ID) return -1;
			AI_NPCS[i][refID] = id;
			AI_NPCS[i][Team] = team;
			AI_NPCS[i][DOD] = dod;
			AI_NPCS[i][playerFirst] = targetPlayer;
			Iter_Add(AIIterator, i);
			return id;
		}
	}
	return -1;
}

stock AI_DestroyNPC(id) {
	if (AI_NPCS[id][refID] != -1) {
		AI_OnDestroyed(id);
		Iter_Remove(AIIterator, id);
		FCNPC_Destroy(AI_NPCS[id][refID]);
		AI_NPCS[id][refID] = -1;
		AI_NPCS[id][targetID] = -1;
		AI_NPCS[id][targetType] = 0;
		AI_NPCS[id][targetPlayer] = 1;
		AI_NPCS[id][attackType] = 0;
		AI_NPCS[id][Team] = 0;
		AI_NPCS[id][Paused] = 0;
		AI_NPCS[id][DOD] = 1;
		if (Iter_Count(AIIterator) < 1) AI_Active = 0;
		return 1;
	}
	return -1;
}

stock AI_DestroyNPCReference(referenceID) {
	foreach (new id : AIIterator) {
		if (AI_NPCS[id][refID] == referenceID) {
			AI_OnDestroyed(id);
			Iter_Remove(AIIterator, id);
			FCNPC_Destroy(AI_NPCS[id][refID]);
			AI_NPCS[id][refID] = -1;
			AI_NPCS[id][targetID] = -1;
			AI_NPCS[id][targetType] = 0;
			AI_NPCS[id][targetPlayer] = 1;
			AI_NPCS[id][attackType] = 0;
			AI_NPCS[id][Team] = 0;
			AI_NPCS[id][Paused] = 0;
			AI_NPCS[id][DOD] = 1;
			if (Iter_Count(AIIterator) < 1) AI_Active = 0;
			return 1;			
		}
	}
	return -1;
}

stock AI_SetAttackType(id, type) { AI_NPCS[id][attackType] = type; }

//Callbacks:

public AI_OnDestroyed(id) {
}

//Legacy callbacks:
public AI_OnDeath(referenceID, killerid, weaponid) {
	new id = GetIDByRef(referenceID);
	if (id == -1) return;
	
	
	
	if (AI_NPCS[id][DOD] == 1) AI_DestroyNPC(id)) //NOTE: Keep at bottom of OnDeath.
}

//Back-end functions:


//===Loop specific helper functions===// **KEEP AT BOTTOM**
static AI_Target(id) {
	AI_NPCS[id][Paused] = 1;
	AI_NPCS[id][targetID] = id;
	AI_NPCS[id][Paused] = 0;
}

static AI_TargetVehicle(id) {
	AI_NPCS[id][Paused] = 1;
	AI_NPCS[id][targetID] = id;
	AI_NPCS[id][targetType] = TARGET_TYPE_VEHICLE;
	AI_NPCS[id][Paused] = 0;
}

static AI_ClearTarget(id) {
	AI_NPCS[id][targetID] = -1;
	AI_NPCS[id][targetType] = 0;
}

static AI_

static IsValidTarget(id, targetid) { //NOTE: Don't call this if 'id' points to a TEAM_NEUTRAL NPC, because there is no valid target for neutral NPCs.
	switch(AI_NPCS[id][targetType]) {
		case TARGET_TYPE_NPC: {
			if (AI_NPCS[id][Team] == TEAM_FRIENDLY) return 0; //Don't target players if the NPC is set to be friendly.
			if (GetPVarInt(targetid, "Dead") > 0) return 0; //Don't target dead players.
			return 1;
		}
		case TARGET_TYPE_PLAYER: {
			if (AI_IsDead(GetRefByID(targetid))) return 0; //Don't target dead NPCs.
			new aiTeam = AI_NPCS[id][Team]; //Store the teams in memory since we reference to them SO much, and this will be called often.
			if (aiTeam == TEAM_NEUTRAL) return 0; //Don't target neutral NPCs.
			new targetTeam = AI_NPCS[targetid][Team];
			if ((aiTeam == TEAM_BAD && targetTeam == TEAM_BAD) || aiTeam == TEAM_FRIENDLY && targetTeam == TEAM_FRIENDLY) return 0; //Don't target bad-guys on the same team. NOTE: TEAM_HOSTILE targets everyone except TEAM_NEUTRAL.
			return 1;
		}
		case TARGET_TYPE_VEHICLE: {
			return 1;
		}
		default: { return 0; }
	}
	return 0;
}
//====================================//
static framesSkipped = 0; // Shitty way to control update-rate, but it's low-resource. If we experience choppiness or performance issues we'll switch it up.
AI_Think() {
	while (AI_Active == 1) {
		if (framesSkipped >= SKIP_FRAMES) {
			foreach (new id : AIIterator) {
				if (AI_NPCS[id][Paused] == 1) continue;
				new referenceID = GetRefByID(id);
				if (AI_IsDead(referenceID)) continue;
				new targetAquired = -1;
				if (AI_NPCS[id][Team] != TEAM_NEUTRAL) {
					//Handle targetting.
					new targetAquired = -1;
					if (AI_NPCS[id][targetType] != TARGET_TYPE_VEHICLE) {
						switch (AI_NPCS[id][targetPlayer]) {
							case 0: { //prioritize NPCs
								AI_NPCS[id][targetType] = TARGET_TYPE_NPC;
								foreach (new targetid : Bot) {
									if (IsValidTarget(id, targetid)) {
										if (AI_NPCS[id][targetID] != targetid) AI_Target(targetid);
										targetAquired = 1;
										break;
									}
								}
								if (targetAquired == -1) { //If we can't aquire a bot.
									AI_NPCS[id][targetType] = TARGET_TYPE_PLAYER;
									foreach (new targetid : Player) {
										if (IsValidTarget(id, targetid)) {
											if (AI_NPCS[id][targetID] != targetid) AI_Target(targetid);
											targetAquired = 1;
											break;
										}
									}
								}
							}
							case 1: {
								AI_NPCS[id][targetType] = TARGET_TYPE_PLAYER;
								foreach (new targetid : Player) {
									if (IsValidTarget(id, targetid)) {
										if (AI_NPCS[id][targetID] != targetid) AI_Target(targetid);
										targetAquired = 1;
										break;
									}
								}
								if (targetAquired == -1) { //If we can't aquire a player.
									AI_NPCS[id][targetType] = TARGET_TYPE_NPC;
									foreach (new targetid : Bot) {
										if (IsValidTarget(id, targetid)) {
											if (AI_NPCS[id][targetID] != targetid) AI_Target(targetid);
											targetAquired = 1;
											break;
										}
									}
								}
							}
						}
					} else targetAquired = 1;
					if (targetAquired == -1) AI_NPCS[id][targetID] = -1;
				}
				if (AI_NPCS[id][targetID] == -1) {
					//TODO: Handle movement.
				} else {
					//TODO: Handle attacking.
				}
			}
		} else framesSkipped++;
	}
	return 1;
}
//==========================================//