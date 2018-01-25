#include <YSI\y_hooks>

// Some anit-cheat functions are found under the "OneSecond" task in timers.pwn. //

SetPlayerHealthEx(playerid, Float:health) { SetPlayerHealth(playerid, health); Player[playerid][Health] = health; return 1; } // Serverside health.
SetPlayerArmourEx(playerid, Float:armour) { SetPlayerArmour(playerid, armour); Player[playerid][Armour] = armour; return 1; } // Serverside armour.