#define 						FALSE 										   0
#define 						TRUE 										   1

/*								COLOURS 								  	   */

#define                         WHITE                                 0xFFFFFFFF
#define  						GREY 							      0xCECECEFF
#define  						DARKGREY    					   	  0x626262FF
#define 						RED 						  		  0xE60000FF
#define 						DARKRED							      0xAA3333AA
#define  						LIGHTRED 							  0xFF8080FF
#define  						ORANGE 					  		  	  0xF97804FF
#define    						LIGHTORANGE 						  0xFFD7004A
#define  						YELLOW 								  0xFFFF00FF
#define  						PURPLE          					  0xC2A2DAAA
#define  						SCRIPTPURPLE						  0xB360FDFF
#define 						GREEN 								  0x21DD00FF
#define  						DARKGREEN 							  0x008040FF
#define  						LIGHTGREEN 							  0x38FF06FF
#define  						LIGHTBLUE 							  0x00C2ECFF
#define  						BLUE 								  0x1229FAFF
#define  						DEFAULT	  	 						  0xFFFFFFFF
#define  						PINK 								  0xD52DFFFF
#define  						AQUAGREEN   						  0x03D687FF
#define  						ADMINBLUE 						   	  0x99FFFFAA
#define  						NEWBIE_CHAT     					  0xCCFFCCFF
#define 						BEIGE 								  0xFFFF91FF
#define 						YELLOWGREEN							  0xBDF38BFF

/*								MAXIMUM DEFINES							  	   */

#define 						MAX_PLAYER_VEHICLES							   5
#define                         MAX_REPORTS                             	 999
#define                         MAX_GROUPS                                    20
#define 						MAX_GROUP_RANKS 							  10
#define 						MAX_GROUP_DIVS								   6
#define 						MAX_HOUSES									 500
#define 						MAX_DOORS									 500
#define 						MAX_BUSINESSES								 100
#define 						MAX_ARRESTPOINTS							  50
#define 						MAX_LOCKERS     							  50
#define 						MAX_GATES 									 500
#define 						MAX_JOBS 									  25
#define 						MAX_CRIMES      							  50
#define  						MAX_POINTS 								      25
#define 						MAX_BUSINESS_ITEMS_STORE					  10
#define 						MAX_BUSINESS_ITEMS_FOOD					       5
#define 						MAX_BUSINESS_ITEMS_GYM					       6
#define 						MAX_FUELSTATIONS							 100
#define 						MAX_DYN_VEHICLES							 500
#define 						MAX_ADMIN_VEHICLES							 100


/*								DIALOG DEFINES 								  */

/* You should generally skip a few ID's per system incase something needs to
be added to previous system. 												  */

#define 						DIALOG_DEFAULT								   0

#define 						DIALOG_REGISTER								   1
#define 						DIALOG_LOGIN								   2

#define 						DIALOG_REPORT								   3
#define 						DIALOG_REPORT2								   4
#define 						DIALOG_REPORT3								   5
#define 						DIALOG_REPORT4								   6
#define 						DIALOG_REPORT5								   7
#define 						DIALOG_REPORT6								   8
#define 						DIALOG_REPORT7								   9
#define 						DIALOG_REPORT8								  10

#define                         DIALOG_EDITGROUP							  11
#define                         DIALOG_EDITGROUP2							  12
#define                         DIALOG_EDITGROUP_NAME						  13
#define                         DIALOG_EDITGROUP_TYPE						  14
#define                         DIALOG_EDITGROUP_RANKS						  15
#define                         DIALOG_EDITGROUP_RANKS2						  16
#define                         DIALOG_EDITGROUP_PAY						  17
#define                         DIALOG_EDITGROUP_PAY2						  18
#define                         DIALOG_EDITGROUP_DIVS						  19
#define                         DIALOG_EDITGROUP_DIVS2						  20
#define                         DIALOG_EDITGROUP_COLOUR						  21

#define                         DIALOG_MAKELEADER						  	  22
#define                         DIALOG_ACCENTS  						  	  23

#define                         DIALOG_BUSINESS_STORE					  	  24
#define                         DIALOG_BUSINESS_LOTTERY					  	  25
#define                         DIALOG_BUSINESS_LOTTERY2				  	  26
#define                         DIALOG_BUSINESS_LOTTERY3				  	  27
#define                         DIALOG_BUSINESS_FOOD					  	  28
#define                         DIALOG_BUSINESS_BUYCAR					  	  29
#define                         DIALOG_BUSINESS_GYM 					  	  30
#define                         DIALOG_BUSINESS_SKIN 					  	  31
#define                         DIALOG_BUSINESS_STORE_EDIT				  	  32
#define                         DIALOG_BUSINESS_STORE_EDIT2				  	  33
#define                         DIALOG_BUSINESS_STORE_EDITFUEL			  	  34
#define                         DIALOG_BUSINESS_FOOD_EDIT				  	  35
#define                         DIALOG_BUSINESS_FOOD_EDIT2				  	  36
#define                         DIALOG_BUSINESS_BUYCAR_EDIT				  	  37
#define                         DIALOG_BUSINESS_GYM_EDIT 				  	  38
#define                         DIALOG_BUSINESS_GYM_EDIT2 				  	  39
#define                         DIALOG_BUSINESS_SKIN_EDIT				  	  40
#define 						DIALOG_DELETECAR_CONFIRM					  41

#define 						DIALOG_PHONE								  42
#define 						DIALOG_PHONE_CALL							  43
#define 						DIALOG_PHONE_TEXT							  44
#define 						DIALOG_PHONE_TEXT2							  45
#define 						DIALOG_PHONE_CONTACTS						  46

#define 						DIALOG_CRIMELIST 							  47
#define 						DIALOG_CRIMELIST_EDIT						  48
#define 						DIALOG_CRIMELIST_EDIT_NAME					  49

#define 						DIALOG_DROPWEAPON							  50

#define 						DIALOG_LISTPOINTS 							  51
#define 						DIALOG_EDITPOINT 							  52
#define 						DIALOG_EDITPOINT_NAME 			 			  53
#define 						DIALOG_EDITPOINT_TYPE 			              54
#define 						DIALOG_EDITPOINT_POSITION 		              55
#define 						DIALOG_EDITPOINT_MATERIALS		              56

#define 						DIALOG_LOCKER_GOVERNMENT		              57
#define 						DIALOG_LOCKER_POLICE    		              58
#define 						DIALOG_LOCKER_HITMAN			              59
#define 						DIALOG_LOCKER_CLOTHES						  60
#define  						DIALOG_LOCKER_WEAPONS						  61

#define  						DIALOG_MDC									  80
#define  						DIALOG_MDC_CIVINFO   						  81
#define  						DIALOG_MDC_CIVINFO2 						  82

#define  						DIALOG_CONTRACT		 						  90
#define  						DIALOG_CONTRACT_NAME		 				  91
#define  						DIALOG_CONTRACT_AMOUNT		 				  92
#define  						DIALOG_CONTRACT_REASON						  93



/* natives / miscs */
native WP_Hash(buffer[], len, const str[]);

#define tolower(%0) \
    (((%0) >= 'A' && (%0) <= 'Z') ? ((%0) | 0x20) : (%0))

#define SpeedCheck(%0,%1,%2,%3,%4) floatround(floatsqroot(%4?(%0*%0+%1*%1+%2*%2):(%0*%0+%1*%1)) *%3*1.6)
