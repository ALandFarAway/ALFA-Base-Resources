/*
Author: brockfanning
Date: Early 2008...
Purpose: This is the script that can be modified to customize the behavior of
TKL Performer.  Server admins can use this to disable/enable certain features.

re-arranged it a bit, implemented TKL_USE_ADJUSTED_PERFORM, and add Improvisation styles 1/23/09 -brockfanning 
*/

// AL: ALFA settings.  Perform affects songs, lyrics = FALSE.  Perform speed factor to 5

// ******************** MISC CONFIGURATION *********************

const int TKL_NWNX4_NOT_INSTALLED =				FALSE;
	// IMPORTANT! If your server does NOT have NWNX4 installed (with the 'Timer' plugin)
	// you will NEED to set this to TRUE.  Without the NWNX4 Timer plugin,
	// some functions of TKL Performer are not possible, and using them could have bad results.
	// Setting this to TRUE will disable those functions, so you don't have to worry.

const int TKL_ALLOW_DISABLE_MUSIC =				TRUE;
	// If TRUE, players will have the ability to turn NWN2 music on and off (for everyone in the area).
	
const int TKL_ALLOW_DISABLE_SOUNDS = 			TRUE;
	// If TRUE, players will have the ability to turn NWN2 ambient sounds on and off (for everyone in the area).

const float TKL_PREVIEW = 						10.0f;
	// This is the number of seconds played when a player clicks on 'Preview'.
		
// ******************** PERFORM SKILL *********************	
		
const int TKL_MINIMUM_PERFORM_TO_USE =			0;
	// This is the minimum Perform skill needed to use the system.
	// NOTE: Slight change in version 2: This is the number of BASE RANKS needed to use the system.
	// (regardless of the setting of the next constant below)

const int TKL_USE_ADJUSTED_PERFORM = 			TRUE;
	// If TRUE, all Perform checks (besides the initial minimum check, above) will include all adjustments 
	// for Charisma, spells, items, etc.
	// If FALSE, only the Base Ranks will be used.

const int TKL_PERFORM_AFFECTS_SONGS =			FALSE;
	// If TRUE, the players' Perform skill will determine how many Songs they can have saved at a time.
const float TKL_SONGS_PER_PERFORM_POINT =		0.5;
	// If TKL_PERFORM_AFFECTS_SONGS is TRUE, this fraction determines the number of Songs that can be saved, per point of Perform.
	// Example: If set at 0.5, a player with 8 Perform will be able to save 4 songs.

const int TKL_PERFORM_AFFECTS_LYRICS = 			FALSE;
	// If TRUE, the players' Perform skill will determine how many Lyric slots they can edit in a song.
const int TKL_LYRICS_PER_PERFORM_POINT =		4;
	// If TKL_PERFORM_AFFECTS_LYRICS is TRUE, this determines the number of Lyrics slots that can be edited, per point of Perform.
	// Example: If set at 2, a player with 8 Perform will be able to edit 16 Lyrics slots.

const int TKL_PERFORM_AFFECTS_SPEED =			TRUE;
	// If TRUE, the players' Perform skill will determine how much they can speed up a song.
const int TKL_SPEED_PER_PERFORM_POINT =			8;
	// If TKL_PERFORM_AFFECTS_SPEED is TRUE, this determines the percentage a player can speed up a song, per point of Perform.
	// Example: If set at 2, a player with 8 Perform will be able to speed up songs by 16%.

// Modify the script below to control the way that Perform is checked.  For example,
// you might want to give a bonus to penalty to half-orcs, or you might want to give a special bonus
// for having the Artist feat, or you might want to give a bonus to DMs, etc...
// Note: This function is NOT used in the check to see if the player can equip the instrument.  Only BASE
// ranks are used for that check.

int GetPerform(object oPC)
{
	int iSkill = GetSkillRank(SKILL_PERFORM, oPC, !TKL_USE_ADJUSTED_PERFORM);
	// PLACE CHANGES HERE
	return iSkill;
}
	
// ******************** TRANSCRIPTION *********************
	
const int TKL_TRANSCRIPTIONS_PER_RESET =		0;
	// If set to 1 or more, this is the number of times per server reset that a PC can create a transcription.
	// If set to 0, there is no limit per reset.
const int TKL_ONE_TRANSCRIPTION_PER_HOUR =		TRUE;
	// If set to TRUE, this limits the transcription feature to once per game-hour.
	// If set to FALSE, PCs can Transcribe as often as they like.
const int TKL_TRANSCRIPTION_DC =				10;
	// If set to 1 or more, this is the base DC for a Perform skill check, whenever a PC attempts transcription.
	// If set to 0, Transcription will always be successful.
const int TKL_TRANSCRIPTION_LENGTH_PENALTY =	100;
	// If set to 1 or more, this is the number of notes that causes the Transcription DC to go up by 1.
	// For example, if set to 50, every 50 notes in a song causes the base DC to go up by 1.
	// (ie, a song with 100 notes would have its base Transcription DC increased by 2)
	// Note: This is not used if TKL_TRANSCRIPTION_DC is set to 0.
const int TKL_TRANSCRIPTION_CHARGES =			10;
	// This is the number of charges that will be given to the Musical Score items.
		
// ******************** IMPROV STYLES *********************

// Below you can modify the improvisation styles.
// Read through Style 1 for instruction on how they work.

// ***********************************************************************************
// Style 1:
// ***********************************************************************************

	// This is where you can give it a cool name, depending on your campaign world.
	const string STYLE_1_NAME = "Narcuan Fancy";
	
	// This is where you give the style a description.
	const string STYLE_1_DESCRIPTION = "A polite and beautiful form, based on the popular Narcuan folk tune, 'Bluegreaves'";
	
	// This determines the speed of the style.
	const int    STYLE_1_BEATS_PER_MINUTE = 180;
	
	// This governs the rhythms that will be played by the melody instruments.
	// Use any number of 1-measure melodic rhythms: - = rest, 1 = short note, 2 = long note 
	// At each measure of the improvisation, the performer will choose randomly from these rhythms.
	// Note: end each rhythm with '/'	Also, to make certain rhythms more common, include them multiple times.
	const string STYLE_1_MELODIC_RHYTHMS =
		"2-2-2-/112---/-1112-/--1111/2---11/2-2---/112-2-/2---2-/12-12-/2-----/------/-2-2-1/";	
	
	// This governs the rhythms that will be played by the drums.
	// To make certain rhythms more common, include them more than once.
	// Add any number of 1-measure percussion rhythms: - = rest, lower-case = soft, upper-case = loud
	// a = cow bell, b = taiko drum, c = triangle, d = guiro, e = frame drum, f = open snare, g = closed snare, h = tabla,  = tambourine, j = anvil
	// At each measure of the improvisation, the performer will choose randomly from these rhythms.
	// End each rhythm with a '/'
	// IMPORTANT: Must use the same number of beats as the Melodic Rhythms above.												
	const string STYLE_1_PERCUSSIVE_RHYTHMS = 
		"I-----/I-i-i-/I--iI-/I-I-I-/I-----/i-----/";
	
	// This governs the chord progression, and also determines the TOTAL LENGTH of the improvisation.
	// Add a progression of 1-measure chords.  M = major, m = minor, * = half-dim.
	// Precede a chord by '?' to indicate that this chord is in an alternate tonality. (see 'AltNotes' below)
	// All letters (A-G) should be upper-case, and follow each chord by a '/'			
	const string STYLE_1_CHORDS =
		"Am/Am/GM/GM/Am/Am/?EM/?EM/?Am/Am/GM/GM/Am/?EM/Am/Am/CM/CM/GM/GM/Am/Am/?EM/?EM/CM/CM/GM/GM/Am/?EM/?Am/Am/";
	
	// The governs the strum patterns for the chords.
	// To make certain rhythms more common, include them more than once.
	// Add any number of 1-measure strum patterns: - = rest, 1 = block chord, 2 = rolled chord
	// At each measure of the improvisation, the performer will choose randomly from these rhythms.
	// End each pattern with a '/'
	// IMPORTANT: Must use the same number of beats as the Melodic Rhythms and Percussive Rhythms above.
	const string STYLE_1_STRUM_PATTERNS = 
		"1-----/1-----/2-----/1---2-/2---1-/1-1-2-/";
		
	// This determines the palette of notes that the melody instrument can choose from.
	// All upper-case, followed by an octave number.
	// IMPORTANT: Place them in order of lowest to highest.
	// Use # or b as needed.  Follow each note by a '/'.
	// Follow any note by a '>' to indicate that it is a "leading tone", and should always lead to the next note.
	const string STYLE_1_NOTES = "A1/B1/C2/D2/E2/F2/G2/A2/B2/C3/";
	
	// Optional: These are the notes that the melody instrument can choose from, during alternate tonalities.
	// For example, if the song modulates to another key, put the notes of the new key here.  (also see instructions for
	// using '?' in the chords, above.
	// Follow any note by a '>' to indicate that it is a "leading tone", and should always lead to the next note.
	const string STYLE_1_ALT_NOTES = "A1/B1/C2/D2/E2/F2/G#2>/A2/B2/C3/";
	
	// Finally, this optional setting allows you to require a certain Perform skill to play this style.
	const int    STYLE_1_PERFORM_REQUIRED = 0;
	
// ***********************************************************************************
// Style 2:
// ***********************************************************************************
	const string STYLE_2_NAME = "Mormite Drum Dance";
	const string STYLE_2_DESCRIPTION = "A polyrhythmic beat originating from the jungles of Morma.";
	const int    STYLE_2_BEATS_PER_MINUTE = 240;
	const string STYLE_2_MELODIC_RHYTHMS =
		"2-2-2-/2--2--/2-2-2-/2--2--/2-212-/2-12-1/212-2-/2--211/21-12-/2112--/2-21-1/21-21-/21-1-1/21-2--/2-21-1/2--21-/212121/211211/";		
	const string STYLE_2_PERCUSSIVE_RHYTHMS = 
		"H-H-H-/H--H--/H-H-H-/H--H--/H-HhH-/H-hH-h/HhH-H-/H--Hhh/Hh-hH-/HhhH--/H-Hh-h/Hh-Hh-/Hh-h-h/Hh-H--/H-Hh-h/H--Hh-/HhHhHh/HhhHhh/E-E-E-/E--E--/E-E-E-/E--E--/E-EeE-/E-eE-e/EeE-E-/E--Eee/Ee-eE-/EeeE--/E-Ee-e/Ee-Ee-/Ee-e-e/Ee-E--/E-Ee-e/E--Ee-/EeEeEe/EeeEee/F-F-F-/F--F--/F-F-F-/F--F--/F-FfF-/F-fF-f/FfF-F-/F--Fff/Ff-fF-/FffF--/F-Ff-f/Ff-Ff-/Ff-f-f/Ff-F--/F-Ff-f/F--Ff-/FfFfFf/FffFff/";	
	const string STYLE_2_CHORDS =
		"CM/CM/CM/CM/CM/CM/CM/CM/?FM/?FM/?FM/?FM/CM/CM/CM/CM/CM/CM/CM/CM/CM/CM/CM/CM/?FM/?FM/?FM/?FM/CM/CM/CM/CM/GM/GM/GM/GM/CM/CM/CM/CM/";	
	const string STYLE_2_STRUM_PATTERNS = 
		"1-----/";		
	const string STYLE_2_NOTES = "E1/F1/G1/A1/B1/C2/D2/E2/F2/G2/A2/B2/C3/";	
	const string STYLE_2_ALT_NOTES = "F1/G1/A1/C2/D2/F2/G2/A2/C3/";
	const int    STYLE_2_PERFORM_REQUIRED = 0;	
// ***********************************************************************************
// Style 3:
// ***********************************************************************************
	const string STYLE_3_NAME = "Sir Sable's Galliard";
	const string STYLE_3_DESCRIPTION = "Orginally a tune composed in Sir Sable's honor, now the only form of music allowed in Lovoss.";
	const int    STYLE_3_BEATS_PER_MINUTE = 200;
	const string STYLE_3_MELODIC_RHYTHMS =
		"2---/2-2-/2--1/112-/1111/2-11/";		
	const string STYLE_3_PERCUSSIVE_RHYTHMS = 
		"g---/G---/G-g-/g--g/G---/";	
	const string STYLE_3_CHORDS =
		"CM/CM/GM/CM/FM/CM/CM/CM/GM/CM/CM/CM/GM/GM/GM/Am/Am/Am/?EM/?EM/?EM/?AM/?AM/?AM/CM/CM/GM/CM/FM/CM/CM/CM/GM/CM/CM/CM/GM/GM/GM/Am/Am/Am/?EM/?EM/?EM/?AM/?AM/?AM/";	
	const string STYLE_3_STRUM_PATTERNS = 
		"1---/";		
	const string STYLE_3_NOTES = "C2/D2/E2/F2/G2/A2/B2/C3/";	
	const string STYLE_3_ALT_NOTES = "A1/B1/C#2/D2/E2/F#2/G#2/A2/";
	const int    STYLE_3_PERFORM_REQUIRED = 0;
// ***********************************************************************************
// Style 4:
// ***********************************************************************************
	const string STYLE_4_NAME = "Gilden Waltz";
	const string STYLE_4_DESCRIPTION = "A popular dance in Kerond, said to have originated on the streets of Gilden.";
	const int    STYLE_4_BEATS_PER_MINUTE = 240;
	const string STYLE_4_MELODIC_RHYTHMS =
		"111111/112-2-/2-2-2-/2-----/212---/21112-/2-----/2----1/--2-2-/";		
	const string STYLE_4_PERCUSSIVE_RHYTHMS = 
		"F-f-f-/F-f-f-/F---f-/F-f---/F-----/F-f--f/";	
	const string STYLE_4_CHORDS =
		"Am/Am/Am/Am/Am/Am/EM/EM/EM/EM/EM/EM/EM/EM/?AM/?AM/?AM/?AM/?AM/?AM/?EM/?EM/?EM/?EM/GM/GM/GM/GM/?DM/?DM/?DM/?DM/Dm/Dm/Dm/Dm/Am/Am/Am/Am/EM/EM/EM/EM/Am/Am/EM/EM/";	
	const string STYLE_4_STRUM_PATTERNS = 
		"1-----/1-----/1-1-1-/";		
	const string STYLE_4_NOTES = "A1/B1/C2/D2/E2/F2/G#2>/A2/";	
	const string STYLE_4_ALT_NOTES = "A1/B1/C#2/D2/E2/F#2/G#2/A2/";
	const int    STYLE_4_PERFORM_REQUIRED = 0;
// ***********************************************************************************
// Style 5: 
// ***********************************************************************************
	const string STYLE_5_NAME = "Ragutsl Lament";
	const string STYLE_5_DESCRIPTION = "A 12-bar form from the doobils of Ragutsl, reputed to be a strong part of their inner strength and resilience.";
	const int    STYLE_5_BEATS_PER_MINUTE = 240;
	const string STYLE_5_MELODIC_RHYTHMS =
		"--12-12-2---/2-2--12-12-1/2-----------/---------111/2-1--12-12-1/2--2-2--12-1/-112-2------/2-2---2-2---/2--1-2------/2--1-2------/";		
	const string STYLE_5_PERCUSSIVE_RHYTHMS = 
		"j--g--B--g--/B--g--B--g--/J--G--B--G--/B--G--B--G--/j-gG--B--g--/JbbGbbB--Ggg/BggG--BggGbb/BbbGbbBbbG--";	
	const string STYLE_5_CHORDS =
		"CM/FM/CM/CM/?FM/?FM/CM/CM/GM/?FM/CM/GM/CM/?FM/CM/CM/?FM/?FM/CM/CM/GM/?FM/CM/GM/CM/?FM/CM/CM/?FM/?FM/CM/CM/GM/?FM/CM/GM/";	
	const string STYLE_5_STRUM_PATTERNS = 
		"1--1--1--1--/1--2--2--2--/1--1--1--2--/2--1--2--1--/1-----------/";		
	const string STYLE_5_NOTES = "C1/D1/E1/F1/G1/A1/Bb1/C2/D2/E2/F2/G2/A2/Bb2/C3/";	
	const string STYLE_5_ALT_NOTES = "C1/D1/Eb1/F1/G1/A2/Bb2/C2/D2/Eb2/F2/G2/A2/Bb2/C3/";
	const int    STYLE_5_PERFORM_REQUIRED = 0;
// ***********************************************************************************
// Style 6: 
// ***********************************************************************************
	const string STYLE_6_NAME = "Racethian Nocturne";
	const string STYLE_6_DESCRIPTION = "A nostalgic 4-count dance popular at Racethian wine-tastings.";
	const int    STYLE_6_BEATS_PER_MINUTE = 180;
	const string STYLE_6_MELODIC_RHYTHMS =
		"2-2-2-2-/2-112-2-/2---2---/112-112-/2---112-/112-2---/1-1-1-1-/1-1-1-11/1-111-11/2-------/";		
	const string STYLE_6_PERCUSSIVE_RHYTHMS = 
		"C-e-e---/D-e-E---/C---E---/D--cE---/C--eE---/D---e---/D--eE--e/";	
	const string STYLE_6_CHORDS =
		"CM/Am/Dm/GM/CM/Am/Dm/GM/CM/Am/Dm/GM/CM/Am/Dm/GM/?EbM/?Cm/?Fm/?BbM/?EbM/?Cm/?Fm/?BbM/CM/Am/Dm/GM/CM/Am/Dm/GM/";	
	const string STYLE_6_STRUM_PATTERNS = 
		"2-------/2-------/1-------/1-2-2---/";		
	const string STYLE_6_NOTES = "E1/F1/G1/A1/B1/C2/D2/E2/F2/G2/A2/B2/C3/";	
	const string STYLE_6_ALT_NOTES = "Eb1/F1/G1/Ab1/Bb1/C2/D2/Eb2/F2/G2/Ab2/Bb2/";
	const int    STYLE_6_PERFORM_REQUIRED = 0;
// ***********************************************************************************
// Style 7: ???
// ***********************************************************************************
	const string STYLE_7_NAME = "Talroig Hop";
	const string STYLE_7_DESCRIPTION = "A slow dwarven dance which involves jumping slightly off the ground, over and over.";
	const int    STYLE_7_BEATS_PER_MINUTE = 180;
	const string STYLE_7_MELODIC_RHYTHMS =
		"2-------/2-2-2-2-/2---2---/2-2-2---/2---2---/2-------/2------1/2-2-----/2-----2-/";		
	const string STYLE_7_PERCUSSIVE_RHYTHMS = 
		"B-----B-/B-----Bb/";	
	const string STYLE_7_CHORDS =
		"CM/CM/CM/FM/CM/CM/GM/CM/?DM/?DM/?DM/?GM/?DM/?DM/?AM/?DM/CM/CM/CM/FM/CM/CM/GM/CM/?DM/?DM/?DM/?GM/?DM/?DM/?AM/?DM/";	
	const string STYLE_7_STRUM_PATTERNS = 
		"1-------/1-----1-/";		
	const string STYLE_7_NOTES = "C1/D1/E1/F1/G1/A1/B1/C2/";	
	const string STYLE_7_ALT_NOTES = "D1/E1/F#1/G1/A1/B1/C#2/D2/";
	const int    STYLE_7_PERFORM_REQUIRED = 0;
// ***********************************************************************************
// Style 8: ???
// ***********************************************************************************
	const string STYLE_8_NAME = "Astigani Jig";
	const string STYLE_8_DESCRIPTION = "A rowdy, quick dance popular in most port towns.";
	const int    STYLE_8_BEATS_PER_MINUTE = 220;
	const string STYLE_8_MELODIC_RHYTHMS =
		"2--/1--/2--/-11/111/2-1/1-1/---/";		
	const string STYLE_8_PERCUSSIVE_RHYTHMS = 
		"A--/A-i/aii/Aii/a--/Ai-/";	
	const string STYLE_8_CHORDS =
		"CM/CM/CM/FM/CM/CM/GM/CM/CM/CM/CM/FM/CM/CM/GM/CM/GM/GM/GM/GM/CM/CM/FM/FM/Em/Em/FM/FM/GM/GM/CM/CM/CM/CM/CM/FM/CM/CM/GM/CM/CM/CM/CM/FM/CM/CM/GM/CM/GM/GM/GM/GM/CM/CM/FM/FM/Em/Em/FM/FM/GM/GM/CM/CM/";	
	const string STYLE_8_STRUM_PATTERNS = 
		"1--/";		
	const string STYLE_8_NOTES = "C1/D1/E1/F1/G1/A1/B1/C2/D2/E2/F2/G2/A2/B2/C3/";	
	const string STYLE_8_ALT_NOTES = "";
	const int    STYLE_8_PERFORM_REQUIRED = 0;
// ***********************************************************************************
// Style 9: ???
// ***********************************************************************************
	const string STYLE_9_NAME = "Oshmionkan Toy";
	const string STYLE_9_DESCRIPTION = "A traditional 5-beat gnomish form which most people prefer not to listen to.";
	const int    STYLE_9_BEATS_PER_MINUTE = 200;
	const string STYLE_9_MELODIC_RHYTHMS =
		"111--/112--/12-12/2-2-1/2---1/2--11/2---1/2----/1-1-1/12--1/";		
	const string STYLE_9_PERCUSSIVE_RHYTHMS = 
		"AAAAA/abcde/bcdef/cdefg/defgh/efghi/fghij/jihgf/ihgfe/hgfed/gfedc/fedcb/edcba/a----/b----/c----/d----/e----/f----/g----/h----/i----/j----/";	
	const string STYLE_9_CHORDS =
		"CM/CM/?F#M/?F#M/CM/CM/?F#M/?F#M/Dm/Dm/?G#m/?G#m/Dm/Dm/?G#m/?G#m/CM/CM/?F#M/?F#M/CM/CM/?F#M/?F#M/Dm/Dm/?G#m/?G#m/Dm/Dm/?G#m/?G#m/";	
	const string STYLE_9_STRUM_PATTERNS = 
		"1----/2----/1----/1-1-1/";		
	const string STYLE_9_NOTES = "C2/D2/E2/F#2/G2/A2/B2/C3/";	
	const string STYLE_9_ALT_NOTES = "A#1/C1/C#2/D#2/E#2/F#2/G#2/A#2/C2/";
	const int    STYLE_9_PERFORM_REQUIRED = 0;
// ***********************************************************************************
// Style 10: ???
// ***********************************************************************************
	const string STYLE_10_NAME = "Grugacho";
	const string STYLE_10_DESCRIPTION = "A dark and emotional dance form popular in most Grugach communities.";
	const int    STYLE_10_BEATS_PER_MINUTE = 240;
	const string STYLE_10_MELODIC_RHYTHMS =
		"111111/2-----/2---11/2--111/2-1111/11112-/1112--/112---/12----/-11111/--1111/---111/----11/-----1/2-2-2-/2--2--/2-1-1-/";		
	const string STYLE_10_PERCUSSIVE_RHYTHMS = 
		"b--E--/b--e--/B-b-b-/B-E-b-/B--E-b/B-e-bb/";	
	const string STYLE_10_CHORDS =
		"EM/FM/EM/FM/EM/FM/EM/FM/?Am/?GM/?FM/EM/?Am/?GM/?FM/EM/EM/FM/EM/FM/EM/FM/EM/FM/?Am/?GM/?FM/EM/?Am/?GM/?FM/EM/";	
	const string STYLE_10_STRUM_PATTERNS = 
		"1-----/1-2-2-/1--1--/1-----/1-----/";		
	const string STYLE_10_NOTES = "E1/F1/G#1/A1/B1/C2/D#2>/E2/F2/G#2/A2/B2/";	
	const string STYLE_10_ALT_NOTES = "E1/F1/G1/A1/B1/C2/D2/E2/F2/G2/A2/B2/";
	const int    STYLE_10_PERFORM_REQUIRED = 0;
