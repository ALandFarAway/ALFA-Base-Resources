// Name     : NWNX Clock include
// Purpose  : Various functions for accessing the Clock plugin
// Authors  : Ingmar Stieger (Papillon)
// Modified : January 11, 2005

// This file is licensed under the terms of the
// GNU GENERAL PUBLIC LICENSE (GPL) Version 2

/************************************/
/* Constants                        */
/************************************/
const string BUFFER		= "                                               ";

/************************************/
/* Function prototypes              */
/************************************/

// This method gets the system's date in the format (mm/dd/yyyy).
string GetSystemDate();

// This method gets the system's time in the format (hh:mm:ss).
string GetSystemTime();

/************************************/
/* Implementation                   */
/************************************/

// This method gets the system's date in the format (mm.dd.yyyy).
string GetSystemDate(){

	// Variables.
	object oModule			= GetModule();
	
	// Get the system's date.
	SetLocalString(oModule, "NWNX!CLOCK!DATE", BUFFER);
	return (GetLocalString(oModule, "NWNX!CLOCK!DATE"));
	
}

// This method gets the system's time in the format (hh:mm:ss).
string GetSystemTime(){

	// Variables.
	object oModule			= GetModule();
	
	// Get the system's time.
	SetLocalString(oModule, "NWNX!CLOCK!TIME", BUFFER);
	return (GetLocalString(oModule, "NWNX!CLOCK!TIME"));
	
}