/*
					88888888ba    ,ad8888ba,  88888888ba  88888888ba   
					88      "8b  d8"'    `"8b 88      "8b 88      "8b  
					88      ,8P d8'           88      ,8P 88      ,8P  
					88aaaaaa8P' 88            88aaaaaa8P' 88aaaaaa8P'  
					88""""""'   88      88888 88""""88'   88""""""'    
					88          Y8,        88 88    `8b   88           
					88           Y8a.    .a88 88     `8b  88           
					88            `"Y88888P"  88      `8b 88   



//--------------------------------[MAIN SERVER SCRIPT]--------------------------------//

					Peak Gaming Roleplay

							Founded by:
								Jason Gray
								Geoff Matthews

							Developers:
								 *** Development Director: 
								 				Jason Gray

							Mappers:
								 *** Mapping Director: 
								 			Geoff Matthews
								 			

							Plugins:
								*** Plugin Developers: 
								            Y_Less (sscanf, foreach)
								 		    Zeex (zcmd)
								 			Incognito (streamer)


		   // Credits to Kaicore for the SA:MP Modification //								 			
 *
 * Copyright (c) 2016, by Jason Gray
 *
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are not permitted in any case.
 *
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */								 					        
                                               
		/*  ---------------- SCRIPT REVISION ----------------- */

#define                     	VERSION                         "PG:RP 0.01.082"

#include <a_samp>
#include <a_mysql>
#include <sscanf2>
#include <streamer>
#include <zcmd>
#include <foreach>

#include <YSI\y_timers>
#include <YSI\y_utils>

#include "./includes/defines.pwn"
#include "./includes/enumerators.pwn"
#include "./includes/variables.pwn"
#include "./includes/callbacks.pwn"
#include "./includes/functions.pwn"
#include "./includes/dialog.pwn"
#include "./includes/mysql.pwn"
#include "./includes/timers.pwn"

#include "./includes/core/admin.pwn"
#include "./includes/core/animations.pwn"
#include "./includes/core/anticheat.pwn"
#include "./includes/core/business.pwn"
#include "./includes/core/chat.pwn"
#include "./includes/core/group.pwn"
#include "./includes/core/job.pwn"
#include "./includes/core/login.pwn"
#include "./includes/core/phone.pwn"
#include "./includes/core/player.pwn"
#include "./includes/core/report.pwn"
#include "./includes/core/textdraw.pwn"
#include "./includes/core/vehicle.pwn"
#include "./includes/core/weapon.pwn"

#include "./includes/dynamic/arrestpoint.pwn"
#include "./includes/dynamic/business.pwn"
#include "./includes/dynamic/crime.pwn"
#include "./includes/dynamic/door.pwn"
#include "./includes/dynamic/enterandexit.pwn"
#include "./includes/dynamic/gate.pwn"
#include "./includes/dynamic/group.pwn"
#include "./includes/dynamic/house.pwn"
#include "./includes/dynamic/job.pwn"
#include "./includes/dynamic/locker.pwn"
#include "./includes/dynamic/point.pwn"
#include "./includes/dynamic/vehicle.pwn"

#include "./includes/business/clothing.pwn"
#include "./includes/business/dealership.pwn"
#include "./includes/business/food.pwn"
#include "./includes/business/fuelstation.pwn"
#include "./includes/business/gym.pwn"
#include "./includes/business/lottery.pwn"
#include "./includes/business/store.pwn"

#include "./includes/group/lawenforcement.pwn"

#include "./includes/job/armsdealer.pwn"
#include "./includes/job/bodyguard.pwn"
#include "./includes/job/detective.pwn"
#include "./includes/job/drugsmuggler.pwn"
#include "./includes/job/mechanic.pwn"
#include "./includes/job/pizzaboy.pwn"
#include "./includes/job/trucker.pwn"

main(){}

public OnGameModeInit()
{
	SetGameModeText(VERSION);

	UsePlayerPedAnims();
	DisableInteriorEnterExits();
	EnableStuntBonusForAll(0);
	ShowPlayerMarkers(PLAYER_MARKERS_MODE_OFF);
	ManualVehicleEngineAndLights();

	GamemodeMySQLInitiate();
	return 1;	
}

public OnGameModeExit()
{
    GamemodeMySQLExit();
	return 1;
}