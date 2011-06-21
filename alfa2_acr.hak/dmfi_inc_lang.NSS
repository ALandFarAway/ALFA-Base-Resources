///////////////////////////////////////////////////////////////////////////////
// dmfi_inc_lang - DM Friendly Initiative -  Language Include File
// Original Scripter:  Demetrious      Design: DMFI Design Team
//------------------------------------------------------------------------------
// Last Modified By:   Demetrious           1/12/7
//    AcadiusLost: subbed Loross for Talfiric, Netherese for Raumvira
//    AcadiusLost: subbed Yuanti for Oillusk  7/18/2009
//------------------------------------------------------------------------------
// CREDIT:  Process for translation taken from original DMFI Wand / Widget package
// Code structure changed for "main" languages to structure used in the TALUS
// SPEECH SYSTEM to make translation easier to understand and shorter.
// Sylvan language adapted from the TALUS SPEECH SYSTEM.  A boat load of regional
// languages from Myth Drannor PW care of Lanessar via the SIMTools created
// by FunkySwerve
////////////////////////////////////////////////////////////////////////////////

// This file is a cleaned in v1.02 to only hold translation data.
#include "dmfi_inc_tool"

string ConvertDrow(string sLetter)
{
    string sTranslate = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int iTrans = FindSubString(sTranslate, sLetter);

    switch (iTrans)
    {
    case 0: return "il";
    case 26: return "Il";
    case 1: return "f";
    case 2: return "st";
    case 28: return "St";
    case 3: return "w";
    case 4: return "a";
    case 5: return "o";
    case 6: return "v";
    case 7: return "ir";
    case 33: return "Ir";
    case 8: return "e";
    case 9: return "vi";
    case 35: return "Vi";
    case 10: return "go";
    case 11: return "c";
    case 12: return "li";
    case 13: return "l";
    case 14: return "e";
    case 15: return "ty";
    case 41: return "Ty";
    case 16: return "r";
    case 17: return "m";
    case 18: return "la";
    case 44: return "La";
    case 19: return "an";
    case 45: return "An";
    case 20: return "y";
    case 21: return "el";
    case 47: return "El";
    case 22: return "ky";
    case 48: return "Ky";
    case 23: return "'";
    case 24: return "a";
    case 25: return "p'";
    case 27: return "F";
    case 29: return "W";
    case 30: return "A";
    case 31: return "O";
    case 32: return "V";
    case 34: return "E";
    case 36: return "Go";
    case 37: return "C";
    case 38: return "Li";
    case 39: return "L";
    case 40: return "E";
    case 42: return "R";
    case 43: return "M";
    case 46: return "Y";
    case 49: return "'";
    case 50: return "A";
    case 51: return "P'";

    default: return sLetter; } return "";
}

string ProcessDrow(string sPhrase)
{
    string sOutput;
    int iToggle;
    while (GetStringLength(sPhrase) > 0)
    {
        if (GetStringLeft(sPhrase,1) == "*")
            iToggle = abs(iToggle - 1);
        if (iToggle)
            sOutput = sOutput + GetStringLeft(sPhrase,1);
        else
            sOutput = sOutput + ConvertDrow(GetStringLeft(sPhrase, 1));

        sPhrase = GetStringRight(sPhrase, GetStringLength(sPhrase)-1);
    }
    return sOutput;
}



string ConvertLeetspeak(string sLetter)
{
    string sTranslate = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int iTrans = FindSubString(sTranslate, sLetter);

    switch (iTrans)
    {
    case 0: return "4";
    case 26: return "4";
    case 1: return "8";
    case 27: return "8";
    case 2: return "(";
    case 28: return "(";
    case 3: return "|)";
    case 29: return "|)";
    case 4: return "3";
    case 30: return "3";
    case 5: return "f";
    case 31: return "F";
    case 6: return "9";
    case 32: return "9";
    case 7: return "h";
    case 33: return "H";
    case 8: return "!";
    case 34: return "!";
    case 9: return "j";
    case 35: return "J";
    case 10: return "|<";
    case 36: return "|<";
    case 11: return "1";
    case 37: return "1";
    case 12: return "/\/\";
    case 38: return "/\/\";
    case 13: return "|\|";
    case 39: return "|\|";
    case 14: return "0";
    case 40: return "0";
    case 15: return "p";
    case 41: return "P";
    case 16: return "Q";
    case 42: return "Q";
    case 17: return "R";
    case 43: return "R";
    case 18: return "5";
    case 44: return "5";
    case 19: return "7";
    case 45: return "7";
    case 20: return "u";
    case 46: return "U";
    case 21: return "\/";
    case 47: return "\/";
    case 22: return "\/\/";
    case 48: return "\/\/";
    case 23: return "x";
    case 49: return "X";
    case 24: return "y";
    case 50: return "Y";
    case 25: return "2";
    case 51: return "2";
    default: return sLetter;
    }
    return "";
}//end ConvertLeetspeak

string ProcessLeetspeak(string sPhrase)
{
    string sOutput;
    int iToggle;
    while (GetStringLength(sPhrase) > 0)
    {
        if (GetStringLeft(sPhrase,1) == "*")
            iToggle = abs(iToggle - 1);
        if (iToggle)
            sOutput = sOutput + GetStringLeft(sPhrase,1);
        else
            sOutput = sOutput + ConvertLeetspeak(GetStringLeft(sPhrase, 1));
        sPhrase = GetStringRight(sPhrase, GetStringLength(sPhrase)-1);
    }
    return sOutput;
}

string ConvertInfernal(string sLetter)
{
    string sTranslate = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int iTrans = FindSubString(sTranslate, sLetter);

    switch (iTrans)
    {
    case 0: return "o";
    case 1: return "c";
    case 2: return "r";
    case 3: return "j";
    case 4: return "a";
    case 5: return "v";
    case 6: return "k";
    case 7: return "r";
    case 8: return "y";
    case 9: return "z";
    case 10: return "g";
    case 11: return "m";
    case 12: return "z";
    case 13: return "r";
    case 14: return "y";
    case 15: return "k";
    case 16: return "r";
    case 17: return "n";
    case 18: return "k";
    case 19: return "d";
    case 20: return "'";
    case 21: return "r";
    case 22: return "'";
    case 23: return "k";
    case 24: return "i";
    case 25: return "g";
    case 26: return "O";
    case 27: return "C";
    case 28: return "R";
    case 29: return "J";
    case 30: return "A";
    case 31: return "V";
    case 32: return "K";
    case 33: return "R";
    case 34: return "Y";
    case 35: return "Z";
    case 36: return "G";
    case 37: return "M";
    case 38: return "Z";
    case 39: return "R";
    case 40: return "Y";
    case 41: return "K";
    case 42: return "R";
    case 43: return "N";
    case 44: return "K";
    case 45: return "D";
    case 46: return "'";
    case 47: return "R";
    case 48: return "'";
    case 49: return "K";
    case 50: return "I";
    case 51: return "G";
    default: return sLetter;
    }
    return "";
}//end ConvertInfernal

string ProcessInfernal(string sPhrase)
{
    string sOutput;
    int iToggle;
    while (GetStringLength(sPhrase) > 0)
    {
        if (GetStringLeft(sPhrase,1) == "*")
            iToggle = abs(iToggle - 1);
        if (iToggle)
            sOutput = sOutput + GetStringLeft(sPhrase,1);
        else
            sOutput = sOutput + ConvertInfernal(GetStringLeft(sPhrase, 1));
        sPhrase = GetStringRight(sPhrase, GetStringLength(sPhrase)-1);
    }
    return sOutput;
}

string ConvertAbyssal(string sLetter)
{
    string sTranslate = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int iTrans = FindSubString(sTranslate, sLetter);

    switch (iTrans)
    {
    case 27: return "N";
    case 28: return "M";
    case 29: return "G";
    case 30: return "A";
    case 31: return "K";
    case 32: return "S";
    case 33: return "D";
    case 35: return "H";
    case 36: return "B";
    case 37: return "L";
    case 38: return "P";
    case 39: return "T";
    case 40: return "E";
    case 41: return "B";
    case 43: return "N";
    case 44: return "M";
    case 45: return "G";
    case 48: return "B";
    case 51: return "T";
    case 0: return "oo";
    case 26: return "OO";
    case 1: return "n";
    case 2: return "m";
    case 3: return "g";
    case 4: return "a";
    case 5: return "k";
    case 6: return "s";
    case 7: return "d";
    case 8: return "oo";
    case 34: return "OO";
    case 9: return "h";
    case 10: return "b";
    case 11: return "l";
    case 12: return "p";
    case 13: return "t";
    case 14: return "e";
    case 15: return "b";
    case 16: return "ch";
    case 42: return "Ch";
    case 17: return "n";
    case 18: return "m";
    case 19: return "g";
    case 20: return  "ae";
    case 46: return  "Ae";
    case 21: return  "ts";
    case 47: return  "Ts";
    case 22: return "b";
    case 23: return  "bb";
    case 49: return  "Bb";
    case 24: return  "ee";
    case 50: return  "Ee";
    case 25: return "t";
    default: return sLetter;
    }
    return "";
}//end ConvertAbyssal

string ProcessAbyssal(string sPhrase)
{
    string sOutput;
    int iToggle;
    while (GetStringLength(sPhrase) > 0)
    {
        if (GetStringLeft(sPhrase,1) == "*")
            iToggle = abs(iToggle - 1);
        if (iToggle)
            sOutput = sOutput + GetStringLeft(sPhrase,1);
        else
            sOutput = sOutput + ConvertAbyssal(GetStringLeft(sPhrase, 1));
        sPhrase = GetStringRight(sPhrase, GetStringLength(sPhrase)-1);
    }
    return sOutput;
}

string ConvertCelestial(string sLetter)
{
    string sTranslate = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int iTrans = FindSubString(sTranslate, sLetter);

    switch (iTrans)
    {
    case 0: return "a";
    case 1: return "p";
    case 2: return "v";
    case 3: return "t";
    case 4: return "el";
    case 5: return "b";
    case 6: return "w";
    case 7: return "r";
    case 8: return "i";
    case 9: return "m";
    case 10: return "x";
    case 11: return "h";
    case 12: return "s";
    case 13: return "c";
    case 14: return "u";
    case 15: return "q";
    case 16: return "d";
    case 17: return "n";
    case 18: return "l";
    case 19: return "y";
    case 20: return "o";
    case 21: return "j";
    case 22: return "f";
    case 23: return "g";
    case 24: return "z";
    case 25: return "k";
    case 26: return "A";
    case 27: return "P";
    case 28: return "V";
    case 29: return "T";
    case 30: return "El";
    case 31: return "B";
    case 32: return "W";
    case 33: return "R";
    case 34: return "I";
    case 35: return "M";
    case 36: return "X";
    case 37: return "H";
    case 38: return "S";
    case 39: return "C";
    case 40: return "U";
    case 41: return "Q";
    case 42: return "D";
    case 43: return "N";
    case 44: return "L";
    case 45: return "Y";
    case 46: return "O";
    case 47: return "J";
    case 48: return "F";
    case 49: return "G";
    case 50: return "Z";
    case 51: return "K";
    default: return sLetter;
    }
    return "";
}//end ConvertCelestial

string ProcessCelestial(string sPhrase)
{
    string sOutput;
    int iToggle;
    while (GetStringLength(sPhrase) > 0)
    {
        if (GetStringLeft(sPhrase,1) == "*")
            iToggle = abs(iToggle - 1);
        if (iToggle)
            sOutput = sOutput + GetStringLeft(sPhrase,1);
        else
            sOutput = sOutput + ConvertCelestial(GetStringLeft(sPhrase, 1));
        sPhrase = GetStringRight(sPhrase, GetStringLength(sPhrase)-1);
    }
    return sOutput;
}

string ConvertGoblin(string sLetter)
{
    string sTranslate = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int iTrans = FindSubString(sTranslate, sLetter);

    switch (iTrans)
    {
    case 0: return "u";
    case 1: return "p";
    case 2: return "";
    case 3: return "t";
    case 4: return "'";
    case 5: return "v";
    case 6: return "k";
    case 7: return "r";
    case 8: return "o";
    case 9: return "z";
    case 10: return "g";
    case 11: return "m";
    case 12: return "s";
    case 13: return "";
    case 14: return "u";
    case 15: return "b";
    case 16: return "";
    case 17: return "n";
    case 18: return "k";
    case 19: return "d";
    case 20: return "u";
    case 21: return "";
    case 22: return "'";
    case 23: return "";
    case 24: return "o";
    case 25: return "w";

    case 26: return "U";
    case 27: return "P";
    case 28: return "";
    case 29: return "T";
    case 30: return "'";
    case 31: return "V";
    case 32: return "K";
    case 33: return "R";
    case 34: return "O";
    case 35: return "Z";
    case 36: return "G";
    case 37: return "M";
    case 38: return "S";
    case 39: return "";
    case 40: return "U";
    case 41: return "B";
    case 42: return "";
    case 43: return "N";
    case 44: return "K";
    case 45: return "D";
    case 46: return "U";
    case 47: return "";
    case 48: return "'";
    case 49: return "";
    case 50: return "O";
    case 51: return "W";
    default: return sLetter;
    }
    return "";
}//end ConvertGoblin

string ProcessGoblin(string sPhrase)
{
    string sOutput;
    int iToggle;
    while (GetStringLength(sPhrase) >0)
    {
        if (GetStringLeft(sPhrase,1) == "*")
            iToggle = abs(iToggle - 1);
        if (iToggle)
            sOutput = sOutput + GetStringLeft(sPhrase,1);
        else
            sOutput = sOutput + ConvertGoblin(GetStringLeft(sPhrase, 1));
        sPhrase = GetStringRight(sPhrase, GetStringLength(sPhrase)-1);
    }
    return sOutput;
}

string ConvertDraconic(string sLetter)
{
    string sTranslate = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int iTrans = FindSubString(sTranslate, sLetter);

    switch (iTrans)
    {
    case 0: return "e";
    case 26: return "E";
    case 1: return "po";
    case 27: return "Po";
    case 2: return "st";
    case 28: return "St";
    case 3: return "ty";
    case 29: return "Ty";
    case 4: return "i";
    case 5: return "w";
    case 6: return "k";
    case 7: return "ni";
    case 33: return "Ni";
    case 8: return "un";
    case 34: return "Un";
    case 9: return "vi";
    case 35: return "Vi";
    case 10: return "go";
    case 36: return "Go";
    case 11: return "ch";
    case 37: return "Ch";
    case 12: return "li";
    case 38: return "Li";
    case 13: return "ra";
    case 39: return "Ra";
    case 14: return "y";
    case 15: return "ba";
    case 41: return "Ba";
    case 16: return "x";
    case 17: return "hu";
    case 43: return "Hu";
    case 18: return "my";
    case 44: return "My";
    case 19: return "dr";
    case 45: return "Dr";
    case 20: return "on";
    case 46: return "On";
    case 21: return "fi";
    case 47: return "Fi";
    case 22: return "zi";
    case 48: return "Zi";
    case 23: return "qu";
    case 49: return "Qu";
    case 24: return "an";
    case 50: return "An";
    case 25: return "ji";
    case 51: return "Ji";
    case 30: return "I";
    case 31: return "W";
    case 32: return "K";
    case 40: return "Y";
    case 42: return "X";
    default: return sLetter;
    }
    return "";
}//end ConvertDraconic

string ProcessDraconic(string sPhrase)
{
    string sOutput;
    int iToggle;
    while (GetStringLength(sPhrase) > 0)
    {
        if (GetStringLeft(sPhrase,1) == "*")
            iToggle = abs(iToggle - 1);
        if (iToggle)
            sOutput = sOutput + GetStringLeft(sPhrase,1);
        else
            sOutput = sOutput + ConvertDraconic(GetStringLeft(sPhrase, 1));
        sPhrase = GetStringRight(sPhrase, GetStringLength(sPhrase)-1);
    }
    return sOutput;
}

string ConvertDwarf(string sLetter)
{
    string sTranslate = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int iTrans = FindSubString(sTranslate, sLetter);

    switch (iTrans)
    {
    case 0: return "az";
    case 26: return "Az";
    case 1: return "po";
    case 27: return "Po";
    case 2: return "zi";
    case 28: return "Zi";
    case 3: return "t";
    case 4: return "a";
    case 5: return "wa";
    case 31: return "Wa";
    case 6: return "k";
    case 7: return "'";
    case 8: return "a";
    case 9: return "dr";
    case 35: return "Dr";
    case 10: return "g";
    case 11: return "n";
    case 12: return "l";
    case 13: return "r";
    case 14: return "ur";
    case 40: return "Ur";
    case 15: return "rh";
    case 41: return "Rh";
    case 16: return "k";
    case 17: return "h";
    case 18: return "th";
    case 44: return "Th";
    case 19: return "k";
    case 20: return "'";
    case 21: return "g";
    case 22: return "zh";
    case 48: return "Zh";
    case 23: return "q";
    case 24: return "o";
    case 25: return "j";
    case 29: return "T";
    case 30: return "A";
    case 32: return "K";
    case 33: return "'";
    case 34: return "A";
    case 36: return "G";
    case 37: return "N";
    case 38: return "L";
    case 39: return "R";
    case 42: return "K";
    case 43: return "H";
    case 45: return "K";
    case 46: return "'";
    case 47: return "G";
    case 49: return "Q";
    case 50: return "O";
    case 51: return "J";
    default: return sLetter; } return "";
}//end ConvertDwarf

string ProcessDwarf(string sPhrase)
{
    string sOutput;
    int iToggle;
    while (GetStringLength(sPhrase) > 0)
    {
        if (GetStringLeft(sPhrase,1) == "*")
            iToggle = abs(iToggle - 1);
        if (iToggle)
            sOutput = sOutput + GetStringLeft(sPhrase,1);
        else
            sOutput = sOutput + ConvertDwarf(GetStringLeft(sPhrase, 1));
        sPhrase = GetStringRight(sPhrase, GetStringLength(sPhrase)-1);
    }
    return sOutput;
}

string ConvertElven(string sLetter)
{
    string sTranslate = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int iTrans = FindSubString(sTranslate, sLetter);

    switch (iTrans)
    {
    case 0: return "il";
    case 26: return "Il";
    case 1: return "f";
    case 2: return "ny";
    case 28: return "Ny";
    case 3: return "w";
    case 4: return "a";
    case 5: return "o";
    case 6: return "v";
    case 7: return "ir";
    case 33: return "Ir";
    case 8: return "e";
    case 9: return "qu";
    case 35: return "Qu";
    case 10: return "n";
    case 11: return "c";
    case 12: return "s";
    case 13: return "l";
    case 14: return "e";
    case 15: return "ty";
    case 41: return "Ty";
    case 16: return "h";
    case 17: return "m";
    case 18: return "la";
    case 44: return "La";
    case 19: return "an";
    case 45: return "An";
    case 20: return "y";
    case 21: return "el";
    case 47: return "El";
    case 22: return "am";
    case 48: return "Am";
    case 23: return "'";
    case 24: return "a";
    case 25: return "j";

    case 27: return "F";
    case 29: return "W";
    case 30: return "A";
    case 31: return "O";
    case 32: return "V";
    case 34: return "E";
    case 36: return "N";
    case 37: return "C";
    case 38: return "S";
    case 39: return "L";
    case 40: return "E";
    case 42: return "H";
    case 43: return "M";
    case 46: return "Y";
    case 49: return "'";
    case 50: return "A";
    case 51: return "J";

    default: return sLetter; } return "";
}

string ProcessElven(string sPhrase)
{
    string sOutput;
    int iToggle;
    while (GetStringLength(sPhrase) > 0)
    {
        if (GetStringLeft(sPhrase,1) == "*")
            iToggle = abs(iToggle - 1);
        if (iToggle)
            sOutput = sOutput + GetStringLeft(sPhrase,1);
        else
            sOutput = sOutput + ConvertElven(GetStringLeft(sPhrase, 1));
        sPhrase = GetStringRight(sPhrase, GetStringLength(sPhrase)-1);
    }
    return sOutput;
}

string ConvertGnome(string sLetter)
{
    string sTranslate = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int iTrans = FindSubString(sTranslate, sLetter);

    switch (iTrans)
    {
//cipher based on English -> Al Baed
    case 0: return "y";
    case 1: return "p";
    case 2: return "l";
    case 3: return "t";
    case 4: return "a";
    case 5: return "v";
    case 6: return "k";
    case 7: return "r";
    case 8: return "e";
    case 9: return "z";
    case 10: return "g";
    case 11: return "m";
    case 12: return "s";
    case 13: return "h";
    case 14: return "u";
    case 15: return "b";
    case 16: return "x";
    case 17: return "n";
    case 18: return "c";
    case 19: return "d";
    case 20: return "i";
    case 21: return "j";
    case 22: return "f";
    case 23: return "q";
    case 24: return "o";
    case 25: return "w";

    case 26: return "Y";
    case 27: return "P";
    case 28: return "L";
    case 29: return "T";
    case 30: return "A";
    case 31: return "V";
    case 32: return "K";
    case 33: return "R";
    case 34: return "E";
    case 35: return "Z";
    case 36: return "G";
    case 37: return "M";
    case 38: return "S";
    case 39: return "H";
    case 40: return "U";
    case 41: return "B";
    case 42: return "X";
    case 43: return "N";
    case 44: return "C";
    case 45: return "D";
    case 46: return "I";
    case 47: return "J";
    case 48: return "F";
    case 49: return "Q";
    case 50: return "O";
    case 51: return "W";
    default: return sLetter; } return "";
}

string ProcessGnome(string sPhrase)
{
    string sOutput;
    int iToggle;
    while (GetStringLength(sPhrase) > 0)
    {
        if (GetStringLeft(sPhrase,1) == "*")
            iToggle = abs(iToggle - 1);
        if (iToggle)
            sOutput = sOutput + GetStringLeft(sPhrase,1);
        else
            sOutput = sOutput + ConvertGnome(GetStringLeft(sPhrase, 1));
        sPhrase = GetStringRight(sPhrase, GetStringLength(sPhrase)-1);
    }
    return sOutput;
}

string ConvertHalfling(string sLetter)
{
    string sTranslate = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int iTrans = FindSubString(sTranslate, sLetter);

    switch (iTrans)
    {
//cipher based on Al Baed -> English
    case 0: return "e";
    case 1: return "p";
    case 2: return "s";
    case 3: return "t";
    case 4: return "i";
    case 5: return "w";
    case 6: return "k";
    case 7: return "n";
    case 8: return "u";
    case 9: return "v";
    case 10: return "g";
    case 11: return "c";
    case 12: return "l";
    case 13: return "r";
    case 14: return "y";
    case 15: return "b";
    case 16: return "x";
    case 17: return "h";
    case 18: return "m";
    case 19: return "d";
    case 20: return "o";
    case 21: return "f";
    case 22: return "z";
    case 23: return "q";
    case 24: return "a";
    case 25: return "j";

    case 26: return "E";
    case 27: return "P";
    case 28: return "S";
    case 29: return "T";
    case 30: return "I";
    case 31: return "W";
    case 32: return "K";
    case 33: return "N";
    case 34: return "U";
    case 35: return "V";
    case 36: return "G";
    case 37: return "C";
    case 38: return "L";
    case 39: return "R";
    case 40: return "Y";
    case 41: return "B";
    case 42: return "X";
    case 43: return "H";
    case 44: return "M";
    case 45: return "D";
    case 46: return "O";
    case 47: return "F";
    case 48: return "Z";
    case 49: return "Q";
    case 50: return "A";
    case 51: return "J";
    default: return sLetter; } return "";
}

string ProcessHalfling(string sPhrase)
{
    string sOutput;
    int iToggle;
    while (GetStringLength(sPhrase) > 0)
    {
        if (GetStringLeft(sPhrase,1) == "*")
            iToggle = abs(iToggle - 1);
        if (iToggle)
            sOutput = sOutput + GetStringLeft(sPhrase,1);
        else
            sOutput = sOutput + ConvertHalfling(GetStringLeft(sPhrase, 1));
        sPhrase = GetStringRight(sPhrase, GetStringLength(sPhrase)-1);
    }
    return sOutput;
}

string ConvertOrc(string sLetter)
{
    string sTranslate = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int iTrans = FindSubString(sTranslate, sLetter);

    switch (iTrans)
    {
    case 0: return "ha";
    case 26: return "Ha";
    case 1: return "p";
    case 2: return "z";
    case 3: return "t";
    case 4: return "o";
    case 5: return "";
    case 6: return "k";
    case 7: return "r";
    case 8: return "a";
    case 9: return "m";
    case 10: return "g";
    case 11: return "h";
    case 12: return "r";
    case 13: return "k";
    case 14: return "u";
    case 15: return "b";
    case 16: return "k";
    case 17: return "h";
    case 18: return "g";
    case 19: return "n";
    case 20: return "";
    case 21: return "g";
    case 22: return "r";
    case 23: return "r";
    case 24: return "'";
    case 25: return "m";

    case 27: return "P";
    case 28: return "Z";
    case 29: return "T";
    case 30: return "O";
    case 31: return "";
    case 32: return "K";
    case 33: return "R";
    case 34: return "A";
    case 35: return "M";
    case 36: return "G";
    case 37: return "H";
    case 38: return "R";
    case 39: return "K";
    case 40: return "U";
    case 41: return "B";
    case 42: return "K";
    case 43: return "H";
    case 44: return "G";
    case 45: return "N";
    case 46: return "";
    case 47: return "G";
    case 48: return "R";
    case 49: return "R";
    case 50: return "'";
    case 51: return "M";
    default: return sLetter; } return "";
}

string ProcessOrc(string sPhrase)
{
    string sOutput;
    int iToggle;
    while (GetStringLength(sPhrase) > 0)
    {
        if (GetStringLeft(sPhrase,1) == "*")
            iToggle = abs(iToggle - 1);
        if (iToggle)
            sOutput = sOutput + GetStringLeft(sPhrase,1);
        else
            sOutput = sOutput + ConvertOrc(GetStringLeft(sPhrase, 1));
        sPhrase = GetStringRight(sPhrase, GetStringLength(sPhrase)-1);
    }
    return sOutput;
}

string ConvertAnimal(string sLetter)
{
    string sTranslate = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int iTrans = FindSubString(sTranslate, sLetter);

    switch (iTrans)
    {
    case 0: return "'";
    case 1: return "'";
    case 2: return "'";
    case 3: return "'";
    case 4: return "'";
    case 5: return "'";
    case 6: return "'";
    case 7: return "'";
    case 8: return "'";
    case 9: return "'";
    case 10: return "'";
    case 11: return "'";
    case 12: return "'";
    case 13: return "'";
    case 14: return "'";
    case 15: return "'";
    case 16: return "'";
    case 17: return "'";
    case 18: return "'";
    case 19: return "'";
    case 20: return "'";
    case 21: return "'";
    case 22: return "'";
    case 23: return "'";
    case 24: return "'";
    case 25: return "'";

    case 26: return "'";
    case 27: return "'";
    case 28: return "'";
    case 29: return "'";
    case 30: return "'";
    case 31: return "'";
    case 32: return "'";
    case 33: return "'";
    case 34: return "'";
    case 35: return "'";
    case 36: return "'";
    case 37: return "'";
    case 38: return "'";
    case 39: return "'";
    case 40: return "'";
    case 41: return "'";
    case 42: return "'";
    case 43: return "'";
    case 44: return "'";
    case 45: return "'";
    case 46: return "'";
    case 47: return "'";
    case 48: return "'";
    case 49: return "'";
    case 50: return "'";
    case 51: return "'";
    default: return sLetter; } return "";
}

string ProcessAnimal(string sPhrase)
{
    string sOutput;
    int iToggle;
    while (GetStringLength(sPhrase) > 0)
    {
        if (GetStringLeft(sPhrase,1) == "*")
            iToggle = abs(iToggle - 1);
        if (iToggle)
            sOutput = sOutput + GetStringLeft(sPhrase,1);
        else
            sOutput = sOutput + ConvertAnimal(GetStringLeft(sPhrase, 1));
        sPhrase = GetStringRight(sPhrase, GetStringLength(sPhrase)-1);
    }
    return sOutput;
}

string ProcessDrowSign(string sLetter)
{
    if (GetStringLength(sLetter) > 0) sLetter = GetStringLeft(sLetter, 1);
    if (sLetter == "a" || sLetter == "A") return DCANT_A;
    if (sLetter == "b" || sLetter == "B") return DCANT_B;
    if (sLetter == "c" || sLetter == "C") return DCANT_C;
    if (sLetter == "d" || sLetter == "D") return DCANT_D;
    if (sLetter == "e" || sLetter == "E") return DCANT_E;
    if (sLetter == "f" || sLetter == "F") return DCANT_F;
    if (sLetter == "g" || sLetter == "G") return DCANT_G;
    if (sLetter == "h" || sLetter == "H") return DCANT_H;
    if (sLetter == "i" || sLetter == "I") return DCANT_I;
    if (sLetter == "j" || sLetter == "J") return DCANT_J;
    if (sLetter == "k" || sLetter == "K") return DCANT_K;
    if (sLetter == "l" || sLetter == "L") return DCANT_L;
    if (sLetter == "m" || sLetter == "M") return DCANT_M;
    if (sLetter == "n" || sLetter == "N") return DCANT_N;
    if (sLetter == "o" || sLetter == "O") return DCANT_O;
    if (sLetter == "p" || sLetter == "P") return DCANT_P;
    if (sLetter == "q" || sLetter == "Q") return DCANT_Q;
    if (sLetter == "r" || sLetter == "R") return DCANT_R;
    if (sLetter == "s" || sLetter == "S") return DCANT_S;
    if (sLetter == "t" || sLetter == "T") return DCANT_T;
    if (sLetter == "u" || sLetter == "U") return DCANT_U;
    if (sLetter == "v" || sLetter == "V") return DCANT_V;
    if (sLetter == "w" || sLetter == "W") return DCANT_W;
    if (sLetter == "x" || sLetter == "X") return DCANT_X;
    if (sLetter == "y" || sLetter == "Y") return DCANT_Y;
    if (sLetter == "z" || sLetter == "Z") return DCANT_Z;
    return CANT_DEFAULT;
}

string ProcessCant(string sLetter)
{
    if (GetStringLength(sLetter) > 0) sLetter = GetStringLeft(sLetter, 1);
    if (sLetter == "a" || sLetter == "A") return CANT_A;
    if (sLetter == "b" || sLetter == "B") return CANT_B;
    if (sLetter == "c" || sLetter == "C") return CANT_C;
    if (sLetter == "d" || sLetter == "D") return CANT_D;
    if (sLetter == "e" || sLetter == "E") return CANT_E;
    if (sLetter == "f" || sLetter == "F") return CANT_F;
    if (sLetter == "g" || sLetter == "G") return CANT_G;
    if (sLetter == "h" || sLetter == "H") return CANT_H;
    if (sLetter == "i" || sLetter == "I") return CANT_I;
    if (sLetter == "j" || sLetter == "J") return CANT_J;
    if (sLetter == "k" || sLetter == "K") return CANT_K;
    if (sLetter == "l" || sLetter == "L") return CANT_L;
    if (sLetter == "m" || sLetter == "M") return CANT_M;
    if (sLetter == "n" || sLetter == "N") return CANT_N;
    if (sLetter == "o" || sLetter == "O") return CANT_O;
    if (sLetter == "p" || sLetter == "P") return CANT_P;
    if (sLetter == "q" || sLetter == "Q") return CANT_Q;
    if (sLetter == "r" || sLetter == "R") return CANT_R;
    if (sLetter == "s" || sLetter == "S") return CANT_S;
    if (sLetter == "t" || sLetter == "T") return CANT_T;
    if (sLetter == "u" || sLetter == "U") return CANT_U;
    if (sLetter == "v" || sLetter == "V") return CANT_V;
    if (sLetter == "w" || sLetter == "W") return CANT_W;
    if (sLetter == "x" || sLetter == "X") return CANT_X;
    if (sLetter == "y" || sLetter == "Y") return CANT_Y;
    if (sLetter == "z" || sLetter == "Z") return CANT_Z;
    return CANT_DEFAULT;
}
//void main(){}



string ConvertUndercommon(string sLetter)
{
    string sTranslate ="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int iTrans = FindSubString(sTranslate, sLetter);

    switch (iTrans)
    {
    case 0: return "u";
    case 1: return "h";
    case 2: return "s";
    case 3: return "w";
    case 4: return "o";
    case 5: return "a";
    case 6: return "b";
    case 7: return "t";
    case 8: return "e";
    case 9: return "kk";
    case 10: return "n";
    case 11: return "c";
    case 12: return "z";
    case 13: return "l";
    case 14: return "i";
    case 15: return "d";
    case 16: return "f";
    case 17: return "m";
    case 18: return "r";
    case 19: return "n";
    case 20: return "y";
    case 21: return "x";
    case 22: return "bb";
    case 23: return "dr";
    case 24: return "gi";
    case 25: return "jh";
    case 26: return "U";
    case 27: return "H";
    case 28: return "S";
    case 29: return "W";
    case 30: return "O";
    case 31: return "A";
    case 32: return "B";
    case 33: return "T";
    case 34: return "E";
    case 35: return "KK";
    case 36: return "N";
    case 37: return "C";
    case 38: return "Z";
    case 39: return "L";
    case 40: return "I";
    case 41: return "D";
    case 42: return "F";
    case 43: return "M";
    case 44: return "R";
    case 45: return "N";
    case 46: return "Y";
    case 47: return "X";
    case 48: return "BB";
    case 49: return "Dr";
    case 50: return "Gi";
    case 51: return "Jh";
    default: return sLetter; } return "";
}

string ProcessUndercommon(string sPhrase)
{
    string sOutput;
    int iToggle;
    while (GetStringLength(sPhrase) > 0)
    {
        if (GetStringLeft(sPhrase,1) == "*") iToggle = abs(iToggle - 1);
        if (iToggle) sOutput = sOutput + GetStringLeft(sPhrase,1);
        else sOutput = sOutput + ConvertUndercommon(GetStringLeft(sPhrase, 1));
        sPhrase = GetStringRight(sPhrase, GetStringLength(sPhrase)-1);
    }
    return sOutput;
}

string ConvertAquan(string sLetter)
{
    string sTranslate = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int iTrans = FindSubString(sTranslate, sLetter);
    switch (iTrans)
    {
    case 0: return "ha";
    case 26: return "Ha";
    case 1: return "p";
    case 2: return "z";
    case 3: return "j";
    case 4: return "o";
    case 5: return "";
    case 6: return "c";
    case 7: return "r";
    case 8: return "a";
    case 9: return "m";
    case 10: return "s";
    case 11: return "h";
    case 12: return "r";
    case 13: return "k";
    case 14: return "u";
    case 15: return "b";
    case 16: return "d";
    case 17: return "h";
    case 18: return "y";
    case 19: return "n";
    case 20: return "";
    case 21: return "i";
    case 22: return "r";
    case 23: return "r";
    case 24: return "'";
    case 25: return "m";
    case 27: return "Ph";
    case 28: return "Z";
    case 29: return "Th";
    case 30: return "O";
    case 31: return "";
    case 32: return "Ff";
    case 33: return "Rrs";
    case 34: return "A";
    case 35: return "M";
    case 36: return "Gh";
    case 37: return "H";
    case 38: return "R";
    case 39: return "S";
    case 40: return "U";
    case 41: return "B";
    case 42: return "Cs";
    case 43: return "Ha";
    case 44: return "Se";
    case 45: return "Ne";
    case 46: return "";
    case 47: return "G";
    case 48: return "R";
    case 49: return "R";
    case 50: return "'";
    case 51: return "N";
    default: return sLetter; } return "";
}

string ProcessAquan(string sPhrase)
{
    string sOutput;
    int iToggle;
    while (GetStringLength(sPhrase) > 0)
    {
        if (GetStringLeft(sPhrase,1) == "*") iToggle = abs(iToggle - 1);
        if (iToggle) sOutput = sOutput + GetStringLeft(sPhrase,1);
        else sOutput = sOutput + ConvertAquan(GetStringLeft(sPhrase, 1));
        sPhrase = GetStringRight(sPhrase, GetStringLength(sPhrase)-1);
    }
    return sOutput;
}

string ConvertAuran(string sLetter)
{
    string sTranslate = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int iTrans = FindSubString(sTranslate, sLetter);
    switch (iTrans)
    {
    case 0: return "Wh";
    case 26: return "Wys";
    case 1: return "Yss";
    case 2: return "S";
    case 3: return "Y";
    case 4: return "W";
    case 5: return "o";
    case 6: return "C";
    case 7: return "u";
    case 8: return "S";
    case 9: return "Ss";
    case 10: return "Oo";
    case 11: return "io";
    case 12: return "i";
    case 13: return "f";
    case 14: return "ph";
    case 15: return "pys";
    case 16: return "sys";
    case 17: return "se";
    case 18: return "eu";
    case 19: return "u";
    case 20: return "J";
    case 21: return "A";
    case 22: return "Ae";
    case 23: return ".O";
    case 24: return "e. A";
    case 25: return "Ab";
    case 27: return "b";
    case 28: return "Y";
    case 29: return "we";
    case 30: return "ye";
    case 31: return "se";
    case 32: return "sy";
    case 33: return "s";
    case 34: return "Y";
    case 35: return "U";
    case 36: return "I";
    case 37: return "O";
    case 38: return "W";
    case 39: return "e";
    case 40: return "wY";
    case 41: return "cA";
    case 42: return "ac";
    case 43: return "jh";
    case 44: return "ah";
    case 45: return "ha";
    case 46: return "v";
    case 47: return "th";
    case 48: return "gh";
    case 49: return "vy";
    case 50: return "uy";
    case 51: return "el";
    default: return sLetter; } return "";
}

string ProcessAuran(string sPhrase)
{
    string sOutput;
    int iToggle;
    while (GetStringLength(sPhrase) > 0)
    {
        if (GetStringLeft(sPhrase,1) == "*") iToggle = abs(iToggle - 1);
        if (iToggle) sOutput = sOutput + GetStringLeft(sPhrase,1);
        else sOutput = sOutput + ConvertAuran(GetStringLeft(sPhrase, 1));
        sPhrase = GetStringRight(sPhrase, GetStringLength(sPhrase)-1);
    }
    return sOutput;
}

string ConvertGiant(string sLetter)
{
    string sTranslate = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int iTrans = FindSubString(sTranslate, sLetter);
    switch (iTrans)
    {
    case 0: return "Ugh";
    case 1: return "Gk";
    case 2: return "K";
    case 3: return "gj";
    case 4: return "j";
    case 5: return "r";
    case 6: return "t";
    case 7: return "u";
    case 8: return "i";
    case 9: return "s";
    case 10: return "S";
    case 11: return "a";
    case 12: return "V";
    case 13: return "G";
    case 14: return "H";
    case 15: return "X";
    case 16: return "R";
    case 17: return "We";
    case 18: return "Rt";
    case 19: return "Jk";
    case 20: return "Jk";
    case 21: return "jk";
    case 22: return "kj";
    case 23: return "ty";
    case 24: return "tr";
    case 25: return "lp";
    case 26: return "plop";
    case 27: return "qrk";
    case 28: return "cd";
    case 29: return "dg";
    case 30: return "fhg";
    case 31: return "hgf";
    case 32: return "gty";
    case 33: return "rk";
    case 34: return "er";
    case 35: return "gh";
    case 36: return "kj";
    case 37: return "r";
    case 38: return "t";
    case 39: return "s";
    case 40: return "v";
    case 41: return "s";
    case 42: return "a";
    case 43: return "h";
    case 44: return "t";
    case 45: return "k";
    case 46: return "y";
    case 47: return "h";
    case 48: return "u";
    case 49: return "i";
    case 50: return "j";
    case 51: return "w";
    default: return sLetter; } return "";
}

string ProcessGiant(string sPhrase)
{
    string sOutput;
    int iToggle;
    while (GetStringLength(sPhrase) > 0)
    {
        if (GetStringLeft(sPhrase,1) == "*")
            iToggle = abs(iToggle - 1);
        if (iToggle)
            sOutput = sOutput + GetStringLeft(sPhrase,1);
        else
            sOutput = sOutput + ConvertGiant(GetStringLeft(sPhrase, 1));
        sPhrase = GetStringRight(sPhrase, GetStringLength(sPhrase)-1);
    }
    return sOutput;
}

string ConvertGnoll(string sLetter)
{
    string sTranslate = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int iTrans = FindSubString(sTranslate, sLetter);

    switch (iTrans)
    {
    case 0: return "Gr";
    case 1: return "gr";
    case 2: return "ra";
    case 3: return "wr";
    case 4: return "aw";
    case 5: return "Wr";
    case 6: return "rA";
    case 7: return "Ra";
    case 8: return "gR";
    case 9: return "yip";
    case 10: return "yi";
    case 11: return "Ip";
    case 12: return "ep";
    case 13: return "Ee";
    case 14: return "eE";
    case 15: return "Ep";
    case 16: return "yw";
    case 17: return "ra";
    case 18: return "wa";
    case 19: return "yee";
    case 20: return "ngh";
    case 21: return "u";
    case 22: return "gn";
    case 23: return "ol";
    case 24: return "l";
    case 25: return "en";
    case 26: return "gh";
    case 27: return "yee";
    case 28: return "ey";
    case 29: return "eh";
    case 30: return "pf";
    case 31: return "ph";
    case 32: return "er";
    case 33: return "kip";
    case 34: return "kI";
    case 35: return "Ip";
    case 36: return "Ye";
    case 37: return "En";
    case 38: return "Gh";
    case 39: return "uU";
    case 40: return "yw";
    case 41: return "y";
    case 42: return "o";
    case 43: return "n";
    case 44: return "d";
    case 45: return "a";
    case 46: return "l";
    case 47: return "l";
    case 48: return "arf";
    case 49: return "a";
    case 50: return "r";
    case 51: return "f";
    default: return sLetter; } return "";
}

string ProcessGnoll(string sPhrase)
{
    string sOutput;
    int iToggle;
    while (GetStringLength(sPhrase) > 0)
    {
        if (GetStringLeft(sPhrase,1) == "*") iToggle = abs(iToggle - 1);
        if (iToggle) sOutput = sOutput + GetStringLeft(sPhrase,1);
        else sOutput = sOutput + ConvertGnoll(GetStringLeft(sPhrase, 1));
        sPhrase = GetStringRight(sPhrase, GetStringLength(sPhrase)-1);
    }
    return sOutput;
}
string ConvertIgnan(string sLetter)
{
    string sTranslate = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int iTrans = FindSubString(sTranslate, sLetter);
    switch (iTrans)
    {
    case 0: return "k";
    case 1: return "ra";
    case 2: return "kk";
    case 3: return "le";
    case 4: return "kr";
    case 5: return "ck";
    case 6: return "k k";
    case 7: return "-";
    case 8: return "sk";
    case 9: return "k";
    case 10: return "ig";
    case 11: return "g";
    case 12: return "na";
    case 13: return "hh";
    case 14: return "k";
    case 15: return "n";
    case 16: return "hu";
    case 17: return "kc";
    case 18: return "kr";
    case 19: return "cr";
    case 20: return "rc";
    case 21: return "k";
    case 22: return "rk";
    case 23: return "ckl";
    case 24: return "zk";
    case 25: return "";
    case 26: return "hhh";
    case 27: return "kz";
    case 28: return "k";
    case 29: return "kk";
    case 30: return "h-";
    case 31: return "ha";
    case 32: return " k";
    case 33: return "te";
    case 34: return "'k";
    case 35: return "la";
    case 36: return "r'";
    case 37: return "ng";
    case 38: return "'";
    case 39: return "mr";
    case 40: return "ak";
    case 41: return "ua";
    case 42: return "i";
    case 43: return "ge";
    case 44: return "f";
    case 45: return "'r";
    case 46: return "ss";
    case 47: return "er";
    case 48: return "re";
    case 49: return "r";
    case 50: return "fi";
    case 51: return "e";
    default: return sLetter; } return "";
}

string ProcessIgnan(string sPhrase)
{
    string sOutput;
    int iToggle;
    while (GetStringLength(sPhrase) > 0)
    {
        if (GetStringLeft(sPhrase,1) == "*") iToggle = abs(iToggle - 1);
        if (iToggle) sOutput = sOutput + GetStringLeft(sPhrase,1);
        else sOutput = sOutput + ConvertIgnan(GetStringLeft(sPhrase, 1));
        sPhrase = GetStringRight(sPhrase, GetStringLength(sPhrase)-1);
    }
    return sOutput;
}
string ConvertSylvan(string sLetter)
{
    string sTranslate = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int iTrans = FindSubString(sTranslate, sLetter);
    switch (iTrans)
    {
    case 0: return "s";
    case 1: return "F";
    case 2: return "y";
    case 3: return "E";
    case 4: return "l";
    case 5: return "Y";
    case 6: return "v";
    case 7: return "Tr";
    case 8: return "a";
    case 9: return "Ee";
    case 10: return "n";
    case 11: return "Ny";
    case 12: return "mp";
    case 13: return "h";
    case 14: return "M";
    case 15: return "jo";
    case 16: return "li";
    case 17: return "nar";
    case 18: return "shr";
    case 19: return "ub";
    case 20: return "Whi";
    case 21: return "his";
    case 22: return "ssp";
    case 23: return "pey";
    case 24: return "tee";
    case 25: return "hee";
    case 26: return "na";
    case 27: return "At";
    case 28: return "Tu";
    case 29: return "Ure";
    case 30: return "aN";
    case 31: return "wh'";
    case 32: return "sy'";
    case 33: return "'l'v";
    case 34: return "-";
    case 35: return "Sy";
    case 36: return "'s";
    case 37: return "yu";
    case 38: return "el";
    case 39: return "Si'";
    case 40: return "lv";
    case 41: return "ll'";
    case 42: return "ve";
    case 43: return "ee";
    case 44: return "E";
    case 45: return "en";
    case 46: return "S";
    case 47: return "Y";
    case 48: return "Wy";
    case 49: return "Yv";
    case 50: return "Ki";
    case 51: return "tT";
    default: return sLetter; } return "";
}

string ProcessSylvan(string sPhrase)
{
    string sOutput;
    int iToggle;
    while (GetStringLength(sPhrase) > 0)
    {
        if (GetStringLeft(sPhrase,1) == "*") iToggle = abs(iToggle - 1);
        if (iToggle) sOutput = sOutput + GetStringLeft(sPhrase,1);
        else sOutput = sOutput + ConvertSylvan(GetStringLeft(sPhrase, 1));
        sPhrase = GetStringRight(sPhrase, GetStringLength(sPhrase)-1);
    }
    return sOutput;
}
string ConvertTerran(string sLetter)
{
    string sTranslate = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int iTrans = FindSubString(sTranslate, sLetter);
    switch (iTrans)
    {
    case 0: return "R";
    case 1: return "T";
    case 2: return "E";
    case 3: return "T";
    case 4: return "C";
    case 5: return "ter";
    case 6: return "O";
    case 7: return "A";
    case 8: return "l";
    case 9: return "rra";
    case 10: return "oO";
    case 11: return "R";
    case 12: return "E";
    case 13: return "C";
    case 14: return "for";
    case 15: return "d";
    case 16: return "T";
    case 17: return "Rr";
    case 18: return "D";
    case 19: return "h";
    case 20: return "K";
    case 21: return "mi";
    case 22: return "D";
    case 23: return "S";
    case 24: return "A";
    case 25: return "ng";
    case 26: return "t";
    case 27: return "wa";
    case 28: return "rf";
    case 29: return "wa";
    case 30: return "N";
    case 31: return "o";
    case 32: return "rph";
    case 33: return "cO";
    case 34: return "n";
    case 35: return "Nc";
    case 36: return "r";
    case 37: return "ete";
    case 38: return "di";
    case 39: return "e";
    case 40: return "rT";
    case 41: return "mu";
    case 42: return "d";
    case 43: return "s";
    case 44: return "Mn";
    case 45: return "in";
    case 46: return "ni";
    case 47: return "ng";
    case 48: return "i'";
    case 49: return "Kr";
    case 50: return "Umb";
    case 51: return "Le";
    default: return sLetter; } return "";
}

string ProcessTerran(string sPhrase)
{
    string sOutput;
    int iToggle;
    while (GetStringLength(sPhrase) > 0)
    {
        if (GetStringLeft(sPhrase,1) == "*") iToggle = abs(iToggle - 1);
        if (iToggle) sOutput = sOutput + GetStringLeft(sPhrase,1);
        else sOutput = sOutput + ConvertTerran(GetStringLeft(sPhrase, 1));
        sPhrase = GetStringRight(sPhrase, GetStringLength(sPhrase)-1);
    }
    return sOutput;
}
string ConvertTreant(string sLetter)
{
   string sTranslate = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int iTrans = FindSubString(sTranslate, sLetter);
    switch (iTrans)
    {
    case 0: return "Tr";
    case 1: return "O";
    case 2: return "ee";
    case 3: return "ak";
    case 4: return "ant";
    case 5: return "Bi";
    case 6: return "Pi";
    case 7: return "rch";
    case 8: return "Tr";
    case 9: return "neh";
    case 10: return "trr";
    case 11: return "lea";
    case 12: return "Ee";
    case 13: return "bra";
    case 14: return "ves";
    case 15: return "-";
    case 16: return "Be";
    case 17: return "nch";
    case 18: return "Tr'";
    case 19: return "ches";
    case 20: return "Ar";
    case 21: return "iro";
    case 22: return "noa";
    case 23: return "Rd";
    case 24: return "K'k";
    case 25: return "nwo";
    case 26: return "ood";
    case 27: return "Corr'";
    case 28: return "wo";
    case 29: return "od";
    case 30: return "ne'";
    case 31: return "'dle";
    case 32: return "Au't";
    case 33: return "uM";
    case 34: return "sto";
    case 35: return "Orum";
    case 36: return "eer";
    case 37: return "ert";
    case 38: return "kao";
    case 39: return "kra";
    case 40: return "ab";
    case 41: return "eni";
    case 42: return "ipe";
    case 43: return "pap";
    case 44: return "re";
    case 45: return "eR";
    case 46: return "Pu";
    case 47: return "lP";
    case 48: return "Cy";
    case 49: return "kle";
    case 50: return "chn";
    case 51: return "br";
    default: return sLetter; } return "";
}

string ProcessTreant(string sPhrase)
{
    string sOutput;
    int iToggle;
    while (GetStringLength(sPhrase) > 0)
    {
        if (GetStringLeft(sPhrase,1) == "*") iToggle = abs(iToggle - 1);
        if (iToggle) sOutput = sOutput + GetStringLeft(sPhrase,1);
        else sOutput = sOutput + ConvertTreant(GetStringLeft(sPhrase, 1));
        sPhrase = GetStringRight(sPhrase, GetStringLength(sPhrase)-1);
    }
    return sOutput;
}
string ConvertAlgarondan(string sLetter)
{
    string sTranslate = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int iTrans = FindSubString(sTranslate, sLetter);
    switch (iTrans)
    {
    case 0: return "a";
    case 1: return "u";
    case 2: return "l";
    case 3: return "s";
    case 4: return "g";
    case 5: return "e";
    case 6: return "a";
    case 7: return "s";
    case 8: return "r";
    case 9: return "E";
    case 10: return "o";
    case 11: return "l";
    case 12: return "n";
    case 13: return "v";
    case 14: return "d";
    case 15: return "E";
    case 16: return "a";
    case 17: return "n";
    case 18: return "n";
    case 19: return "A";
    case 20: return "A";
    case 21: return "l";
    case 22: return "L";
    case 23: return "f";
    case 24: return "T";
    case 25: return "'";
    case 26: return "-";
    case 27: return "U";
    case 28: return "";
    case 29: return "M";
    case 30: return "U";
    case 31: return "B";
    case 32: return "L";
    case 33: return "A";
    case 34: return "T";
    case 35: return "I";
    case 36: return "R";
    case 37: return "A";
    case 38: return "A";
    case 39: return "N";
    case 40: return "K";
    case 41: return "U";
    case 42: return "Ll";
    case 43: return "iL";
    case 44: return "N";
    case 45: return "r";
    case 46: return "e";
    case 47: return "T";
    case 48: return "ph";
    case 49: return "Hj";
    case 50: return "t";
    case 51: return "te";
    default: return sLetter; } return "";
}

string ProcessAlgarondan(string sPhrase)
{
    string sOutput;
    int iToggle;
    while (GetStringLength(sPhrase) > 0)
    {
        if (GetStringLeft(sPhrase,1) == "*") iToggle = abs(iToggle - 1);
        if (iToggle) sOutput = sOutput + GetStringLeft(sPhrase,1);
        else sOutput = sOutput + ConvertAlgarondan(GetStringLeft(sPhrase, 1));
        sPhrase = GetStringRight(sPhrase, GetStringLength(sPhrase)-1);
    }
    return sOutput;
}

string ConvertAlzhedo(string sLetter)
{
    string sTranslate = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int iTrans = FindSubString(sTranslate, sLetter);
    switch (iTrans)
    {
    case 0: return "o";
    case 1: return "d";
    case 2: return "e";
    case 3: return "h";
    case 4: return "zee";
    case 5: return "ull";
    case 6: return "a";
    case 7: return "n";
    case 8: return "A";
    case 9: return "ah";
    case 10: return "c";
    case 11: return "nn";
    case 12: return "i";
    case 13: return "m";
    case 14: return "l";
    case 15: return "Ca";
    case 16: return "O";
    case 17: return "N";
    case 18: return "R";
    case 19: return "A";
    case 20: return "D";
    case 21: return "W";
    case 22: return "E";
    case 23: return "A";
    case 24: return "R";
    case 25: return "L";
    case 26: return "eRe";
    case 27: return "R";
    case 28: return "N";
    case 29: return "N";
    case 30: return "I";
    case 31: return "Dh";
    case 32: return "T";
    case 33: return "A";
    case 34: return "Ee";
    case 35: return "R";
    case 36: return "G";
    case 37: return "N";
    case 38: return "B";
    case 39: return "A";
    case 40: return "Sh";
    case 41: return "IM";
    case 42: return "LL";
    case 43: return "A";
    case 44: return "C";
    case 45: return "O";
    case 46: return "D";
    case 47: return "E";
    case 48: return "H";
    case 49: return "Z";
    case 50: return "L";
    case 51: return "A";
    default: return sLetter; } return "";
}

string ProcessAlzhedo(string sPhrase)
{
    string sOutput;
    int iToggle;
    while (GetStringLength(sPhrase) > 0)
    {
        if (GetStringLeft(sPhrase,1) == "*") iToggle = abs(iToggle - 1);
        if (iToggle) sOutput = sOutput + GetStringLeft(sPhrase,1);
        else sOutput = sOutput + ConvertAlzhedo(GetStringLeft(sPhrase, 1));
        sPhrase = GetStringRight(sPhrase, GetStringLength(sPhrase)-1);
    }
    return sOutput;
}

string ConvertChessentan(string sLetter)
{
    string sTranslate = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int iTrans = FindSubString(sTranslate, sLetter);
    switch (iTrans)
    {
    case 0: return "N";
    case 1: return "A";
    case 2: return "T";
    case 3: return "N";
    case 4: return "E";
    case 5: return "S";
    case 6: return "S";
    case 7: return "E";
    case 8: return "H";
    case 9: return "C";
    case 10: return "N";
    case 11: return "O";
    case 12: return "M";
    case 13: return "M";
    case 14: return "O";
    case 15: return "C";
    case 16: return "Y";
    case 17: return "B";
    case 18: return "Y";
    case 19: return "A";
    case 20: return "M";
    case 21: return "N";
    case 22: return "a";
    case 23: return "I";
    case 24: return "g";
    case 25: return "A";
    case 26: return "i";
    case 27: return "G";
    case 28: return "n";
    case 29: return "A";
    case 30: return "p";
    case 31: return "";
    case 32: return "o";
    case 33: return ".";
    case 34: return "o";
    case 35: return "g'";
    case 36: return "h";
    case 37: return "c'";
    case 38: return "a";
    case 39: return "m'";
    case 40: return "l";
    case 41: return " ";
    case 42: return "pi";
    case 43: return "'";
    case 44: return "re";
    case 45: return "h";
    case 46: return "f";
    case 47: return "Yd";
    case 48: return "s";
    case 49: return "Gj";
    case 50: return "l";
    case 51: return "jG";
    default: return sLetter; } return "";
}

string ProcessChessentan(string sPhrase)
{
    string sOutput;
    int iToggle;
    while (GetStringLength(sPhrase) > 0)
    {
        if (GetStringLeft(sPhrase,1) == "*") iToggle = abs(iToggle - 1);
        if (iToggle) sOutput = sOutput + GetStringLeft(sPhrase,1);
        else sOutput = sOutput + ConvertChessentan(GetStringLeft(sPhrase, 1));
        sPhrase = GetStringRight(sPhrase, GetStringLength(sPhrase)-1);
    }
    return sOutput;
}

string ConvertChondathan(string sLetter)
{
    string sTranslate = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int iTrans = FindSubString(sTranslate, sLetter);
    switch (iTrans)
    {
    case 0: return "eh";
    case 1: return "bee";
    case 2: return "sea";
    case 3: return "de";
    case 4: return "e";
    case 5: return "eph";
    case 6: return "gee";
    case 7: return "ehtch";
    case 8: return "eye";
    case 9: return "jae";
    case 10: return "kay";
    case 11: return "ell";
    case 12: return "emm";
    case 13: return "en";
    case 14: return "oh";
    case 15: return "pee";
    case 16: return "kue";
    case 17: return "arr";
    case 18: return "es";
    case 19: return "tea";
    case 20: return "you";
    case 21: return "vea";
    case 22: return "uu";
    case 23: return "why";
    case 24: return "ex";
    case 25: return "zee";
    case 26: return "EH";
    case 27: return "BEE";
    case 28: return "SEA";
    case 29: return "DE";
    case 30: return "E";
    case 31: return "EPH";
    case 32: return "GEE";
    case 33: return "EHTCH";
    case 34: return "EYE";
    case 35: return "JAE";
    case 36: return "KAY";
    case 37: return "ELL";
    case 38: return "EMM";
    case 39: return "EN";
    case 40: return "OH";
    case 41: return "PEE";
    case 42: return "KUE";
    case 43: return "ARR";
    case 44: return "ES";
    case 45: return "TEA";
    case 46: return "YOU";
    case 47: return "VEA";
    case 48: return "UU";
    case 49: return "WHY";
    case 50: return "EX";
    case 51: return "ZEE";
    default: return sLetter; } return "";
}

string ProcessChondathan(string sPhrase)
{
    string sOutput;
    int iToggle;
    while (GetStringLength(sPhrase) > 0)
    {
        if (GetStringLeft(sPhrase,1) == "*") iToggle = abs(iToggle - 1);
        if (iToggle) sOutput = sOutput + GetStringLeft(sPhrase,1);
        else sOutput = sOutput + ConvertChondathan(GetStringLeft(sPhrase, 1));
        sPhrase = GetStringRight(sPhrase, GetStringLength(sPhrase)-1);
    }
    return sOutput;
}

string ConvertChultan(string sLetter)
{
    string sTranslate = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int iTrans = FindSubString(sTranslate, sLetter);
    switch (iTrans)
    {
    case 0: return "n";
    case 1: return "n";
    case 2: return "e";
    case 3: return "a";
    case 4: return "o";
    case 5: return "t";
    case 6: return "t";
    case 7: return "v";
    case 8: return "a";
    case 9: return "l";
    case 10: return "e";
    case 11: return "l";
    case 12: return "u";
    case 13: return "l";
    case 14: return "s";
    case 15: return "h";
    case 16: return "b";
    case 17: return "n";
    case 18: return "C";
    case 19: return "o";
    case 20: return "t";
    case 21: return "r";
    case 22: return "o";
    case 23: return "a";
    case 24: return "R";
    case 25: return "K";
    case 26: return "E";
    case 27: return "P";
    case 28: return "";
    case 29: return "H";
    case 30: return "U";
    case 31: return ",";
    case 32: return "S";
    case 33: return "R";
    case 34: return "-";
    case 35: return "A";
    case 36: return "P";
    case 37: return "'";
    case 38: return "W";
    case 39: return " ";
    case 40: return "Y";
    case 41: return "H";
    case 42: return "L";
    case 43: return "E";
    case 44: return "S";
    case 45: return "E";
    case 46: return "K";
    case 47: return "I";
    case 48: return "M";
    case 49: return "N";
    case 50: return "D";
    case 51: return "O";
    default: return sLetter; } return "";
}

string ProcessChultan(string sPhrase)
{
    string sOutput;
    int iToggle;
    while (GetStringLength(sPhrase) > 0)
    {
        if (GetStringLeft(sPhrase,1) == "*") iToggle = abs(iToggle - 1);
        if (iToggle) sOutput = sOutput + GetStringLeft(sPhrase,1);
        else sOutput = sOutput + ConvertChultan(GetStringLeft(sPhrase, 1));
        sPhrase = GetStringRight(sPhrase, GetStringLength(sPhrase)-1);
    }
    return sOutput;
}

string ConvertDamaran(string sLetter)
{
    string sTranslate = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int iTrans = FindSubString(sTranslate, sLetter);
    switch (iTrans)
    {
    case 0: return "n";
    case 1: return "a";
    case 2: return "a";
    case 3: return "a";
    case 4: return "e";
    case 5: return "s";
    case 6: return "r";
    case 7: return "s";
    case 8: return "a";
    case 9: return "a";
    case 10: return "n";
    case 11: return "a";
    case 12: return "n";
    case 13: return "o";
    case 14: return "v";
    case 15: return "a";
    case 16: return "o";
    case 17: return "e";
    case 18: return "d";
    case 19: return "m";
    case 20: return "l";
    case 21: return "k";
    case 22: return "l";
    case 23: return "a";
    case 24: return "S";
    case 25: return "l";
    case 26: return "D";
    case 27: return "E";
    case 28: return "R";
    case 29: return "T";
    case 30: return "H";
    case 31: return "A";
    case 32: return "A";
    case 33: return "T";
    case 34: return "N";
    case 35: return "E";
    case 36: return "F";
    case 37: return "R";
    case 38: return "U";
    case 39: return "R";
    case 40: return "T";
    case 41: return "L";
    case 42: return "G";
    case 43: return "I";
    case 44: return "S";
    case 45: return "P";
    case 46: return "H";
    case 47: return "M";
    case 48: return "G";
    case 49: return "I";
    case 50: return "A";
    case 51: return "S";
    default: return sLetter; } return "";
}

string ProcessDamaran(string sPhrase)
{
    string sOutput;
    int iToggle;
    while (GetStringLength(sPhrase) > 0)
    {
        if (GetStringLeft(sPhrase,1) == "*") iToggle = abs(iToggle - 1);
        if (iToggle) sOutput = sOutput + GetStringLeft(sPhrase,1);
        else sOutput = sOutput + ConvertDamaran(GetStringLeft(sPhrase, 1));
        sPhrase = GetStringRight(sPhrase, GetStringLength(sPhrase)-1);
    }
    return sOutput;
}

string ConvertDambrathan(string sLetter)
{
   string sTranslate = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int iTrans = FindSubString(sTranslate, sLetter);
    switch (iTrans)
    {
    case 0: return "n";
    case 1: return "h";
    case 2: return "f";
    case 3: return "a";
    case 4: return "a";
    case 5: return "s";
    case 6: return "h";
    case 7: return "v";
    case 8: return " ";
    case 9: return "t";
    case 10: return "e";
    case 11: return ".";
    case 12: return "a";
    case 13: return "a";
    case 14: return ",";
    case 15: return "r";
    case 16: return "d";
    case 17: return "n";
    case 18: return "b";
    case 19: return "a";
    case 20: return "i";
    case 21: return "m";
    case 22: return "J";
    case 23: return "S";
    case 24: return "C";
    case 25: return "R";
    case 26: return "S";
    case 27: return "E";
    case 28: return "E";
    case 29: return "d";
    case 30: return "'";
    case 31: return "T";
    case 32: return "a";
    case 33: return "N";
    case 34: return "T";
    case 35: return "A";
    case 36: return "E";
    case 37: return "H";
    case 38: return "Y";
    case 39: return "T";
    case 40: return "L";
    case 41: return "A";
    case 42: return "N";
    case 43: return "R";
    case 44: return "E";
    case 45: return "B";
    case 46: return "V";
    case 47: return "M";
    case 48: return "L";
    case 49: return "A";
    case 50: return "E";
    case 51: return "D";
    default: return sLetter; } return "";
}

string ProcessDambrathan(string sPhrase)
{
    string sOutput;
    int iToggle;
    while (GetStringLength(sPhrase) > 0)
    {
        if (GetStringLeft(sPhrase,1) == "*") iToggle = abs(iToggle - 1);
        if (iToggle) sOutput = sOutput + GetStringLeft(sPhrase,1);
        else sOutput = sOutput + ConvertDambrathan(GetStringLeft(sPhrase, 1));
        sPhrase = GetStringRight(sPhrase, GetStringLength(sPhrase)-1);
    }
    return sOutput;
}

string ConvertDurpari(string sLetter)
{
   string sTranslate = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int iTrans = FindSubString(sTranslate, sLetter);
    switch (iTrans)
    {
    case 0: return "i";
    case 1: return "b";
    case 2: return "r";
    case 3: return "s";
    case 4: return "a";
    case 5: return "e";
    case 6: return "p";
    case 7: return "s";
    case 8: return "r";
    case 9: return "t";
    case 10: return "u";
    case 11: return "a";
    case 12: return "d";
    case 13: return "g";
    case 14: return "a";
    case 15: return "o";
    case 16: return "v";
    case 17: return "n";
    case 18: return "r";
    case 19: return "d";
    case 20: return "v";
    case 21: return "N";
    case 22: return "e";
    case 23: return "U";
    case 24: return "l";
    case 25: return "G";
    case 26: return "d";
    case 27: return "A";
    case 28: return "o";
    case 29: return "T";
    case 30: return "r";
    case 31: return "S";
    case 32: return "n";
    case 33: return "E";
    case 34: return "A";
    case 35: return "C";
    case 36: return "R";
    case 37: return "O";
    case 38: return "E";
    case 39: return "M";
    case 40: return "M";
    case 41: return "M";
    case 42: return "A";
    case 43: return "O";
    case 44: return "C";
    case 45: return "N";
    case 46: return "L";
    case 47: return " ";
    case 48: return "I";
    case 49: return "G";
    case 50: return "N";
    case 51: return "O";
    default: return sLetter; } return "";
}

string ProcessDurpari(string sPhrase)
{
    string sOutput;
    int iToggle;
    while (GetStringLength(sPhrase) > 0)
    {
        if (GetStringLeft(sPhrase,1) == "*") iToggle = abs(iToggle - 1);
        if (iToggle) sOutput = sOutput + GetStringLeft(sPhrase,1);
        else sOutput = sOutput + ConvertDurpari(GetStringLeft(sPhrase, 1));
        sPhrase = GetStringRight(sPhrase, GetStringLength(sPhrase)-1);
    }
    return sOutput;
}

string ConvertHalardrim(string sLetter)
{
    string sTranslate = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int iTrans = FindSubString(sTranslate, sLetter);
    switch (iTrans)
    {
    case 0: return "m";
    case 1: return "t";
    case 2: return "i";
    case 3: return "h";
    case 4: return "r";
    case 5: return "r";
    case 6: return "d";
    case 7: return "e";
    case 8: return "r";
    case 9: return "s";
    case 10: return "a";
    case 11: return "k";
    case 12: return "l";
    case 13: return "a";
    case 14: return "e";
    case 15: return "l";
    case 16: return "h";
    case 17: return "t";
    case 18: return "c";
    case 19: return "h";
    case 20: return "a";
    case 21: return "a";
    case 22: return "r";
    case 23: return "R";
    case 24: return "T";
    case 25: return "I";
    case 26: return "E";
    case 27: return "S";
    case 28: return "R";
    case 29: return "S";
    case 30: return "M";
    case 31: return "E";
    case 32: return "A";
    case 33: return "C";
    case 34: return "J";
    case 35: return "R";
    case 36: return "O";
    case 37: return "O";
    case 38: return "R";
    case 39: return "F";
    case 40: return "M";
    case 41: return "R";
    case 42: return "I";
    case 43: return "Y";
    case 44: return "L";
    case 45: return "T";
    case 46: return "I";
    case 47: return "E";
    case 48: return "T";
    case 49: return "He";
    case 50: return "A";
    case 51: return "'X";
    default: return sLetter; } return "";
}

string ProcessHalardrim(string sPhrase)
{
    string sOutput;
    int iToggle;
    while (GetStringLength(sPhrase) > 0)
    {
        if (GetStringLeft(sPhrase,1) == "*") iToggle = abs(iToggle - 1);
        if (iToggle) sOutput = sOutput + GetStringLeft(sPhrase,1);
        else sOutput = sOutput + ConvertHalardrim(GetStringLeft(sPhrase, 1));
        sPhrase = GetStringRight(sPhrase, GetStringLength(sPhrase)-1);
    }
    return sOutput;
}

string ConvertHalruaan(string sLetter)
{
    string sTranslate = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int iTrans = FindSubString(sTranslate, sLetter);
    switch (iTrans)
    {
    case 0: return "n";
    case 1: return "l";
    case 2: return "a";
    case 3: return "a";
    case 4: return "a";
    case 5: return "r";
    case 6: return "u";
    case 7: return "b";
    case 8: return "r";
    case 9: return "m";
    case 10: return "l";
    case 11: return "i";
    case 12: return "a";
    case 13: return "n";
    case 14: return "h";
    case 15: return "ni";
    case 16: return "s";
    case 17: return "i";
    case 18: return "h";
    case 19: return "c";
    case 20: return "i";
    case 21: return "d";
    case 22: return "N";
    case 23: return "Ra";
    case 24: return "I";
    case 25: return "R";
    case 26: return "Ck";
    case 27: return "N";
    case 28: return "C";
    case 29: return "G";
    case 30: return "S";
    case 31: return "S";
    case 32: return "D";
    case 33: return "O";
    case 34: return "N";
    case 35: return "U";
    case 36: return "U";
    case 37: return "T";
    case 38: return "O";
    case 39: return "H";
    case 40: return "";
    case 41: return "O";
    case 42: return "N";
    case 43: return "H";
    case 44: return "T";
    case 45: return "E";
    case 46: return "I";
    case 47: return "G";
    case 48: return "Az";
    case 49: return "A";
    case 50: return "'uth";
    case 51: return "M";
    default: return sLetter; } return "";
}

string ProcessHalruaan(string sPhrase)
{
    string sOutput;
    int iToggle;
    while (GetStringLength(sPhrase) > 0)
    {
        if (GetStringLeft(sPhrase,1) == "*") iToggle = abs(iToggle - 1);
        if (iToggle) sOutput = sOutput + GetStringLeft(sPhrase,1);
        else sOutput = sOutput + ConvertHalruaan(GetStringLeft(sPhrase, 1));
        sPhrase = GetStringRight(sPhrase, GetStringLength(sPhrase)-1);
    }
    return sOutput;
}

string ConvertIlluskan(string sLetter)
{
    string sTranslate = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int iTrans = FindSubString(sTranslate, sLetter);
    switch (iTrans)
    {
    case 0: return "n";
    case 1: return "nr";
    case 2: return "a";
    case 3: return "r";
    case 4: return "k";
    case 5: return "a";
    case 6: return "s";
    case 7: return "t";
    case 8: return "u";
    case 9: return "n";
    case 10: return "l";
    case 11: return "i";
    case 12: return "l";
    case 13: return "m";
    case 14: return "i";
    case 15: return " ";
    case 16: return "mo";
    case 17: return "e";
    case 18: return "o";
    case 19: return "m";
    case 20: return "n";
    case 21: return "o";
    case 22: return "s";
    case 23: return "S";
    case 24: return "H";
    case 25: return "A";
    case 26: return "A";
    case 27: return "V";
    case 28: return "E";
    case 29: return "A";
    case 30: return "S";
    case 31: return "G";
    case 32: return "E";
    case 33: return "R";
    case 34: return "N";
    case 35: return "U";
    case 36: return "O";
    case 37: return "A";
    case 38: return "R";
    case 39: return "T";
    case 40: return "T";
    case 41: return "H";
    case 42: return "H";
    case 43: return "Y";
    case 44: return "'U";
    case 45: return "M";
    case 46: return "T";
    case 47: return "-G";
    case 48: return "H";
    case 49: return "R";
    case 50: return "Gy";
    case 51: return " a";
    default: return sLetter; } return "";
}

string ProcessIlluskan(string sPhrase)
{
    string sOutput;
    int iToggle;
    while (GetStringLength(sPhrase) > 0)
    {
        if (GetStringLeft(sPhrase,1) == "*") iToggle = abs(iToggle - 1);
        if (iToggle) sOutput = sOutput + GetStringLeft(sPhrase,1);
        else sOutput = sOutput + ConvertIlluskan(GetStringLeft(sPhrase, 1));
        sPhrase = GetStringRight(sPhrase, GetStringLength(sPhrase)-1);
    }
    return sOutput;
}

string ConvertImaskar(string sLetter)
{
    string sTranslate = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int iTrans = FindSubString(sTranslate, sLetter);
    switch (iTrans)
    {
    case 0: return "r";
    case 1: return "U";
    case 2: return "a";
    case 3: return "n";
    case 4: return "k";
    case 5: return "t";
    case 6: return "s";
    case 7: return "h";
    case 8: return "a";
    case 9: return "e";
    case 10: return "m";
    case 11: return "r";
    case 12: return "i";
    case 13: return "d";
    case 14: return "l";
    case 15: return "n";
    case 16: return "a";
    case 17: return "a";
    case 18: return "i";
    case 19: return "r";
    case 20: return "t";
    case 21: return "o";
    case 22: return "a";
    case 23: return "H";
    case 24: return "I";
    case 25: return "L";
    case 26: return "L";
    case 27: return "U";
    case 28: return "E";
    case 29: return "M";
    case 30: return "C";
    case 31: return "T";
    case 32: return " ";
    case 33: return "H";
    case 34: return "'";
    case 35: return "I";
    case 36: return "Hs";
    case 37: return "S";
    case 38: return "Gr";
    case 39: return "IS";
    case 40: return "Ge";
    case 41: return "S";
    case 42: return "E";
    case 43: return "I";
    case 44: return "E";
    case 45: return "HL";
    case 46: return "H";
    case 47: return "L";
    case 48: return "E";
    case 49: return "Y";
    case 50: return "T";
    case 51: return "E";
    default: return sLetter; } return "";
}

string ProcessImaskar(string sPhrase)
{
    string sOutput;
    int iToggle;
    while (GetStringLength(sPhrase) > 0)
    {
        if (GetStringLeft(sPhrase,1) == "*") iToggle = abs(iToggle - 1);
        if (iToggle) sOutput = sOutput + GetStringLeft(sPhrase,1);
        else sOutput = sOutput + ConvertImaskar(GetStringLeft(sPhrase, 1));
        sPhrase = GetStringRight(sPhrase, GetStringLength(sPhrase)-1);
    }
    return sOutput;
}

string ConvertLantanese(string sLetter)
{
    string sTranslate = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int iTrans = FindSubString(sTranslate, sLetter);
    switch (iTrans)
    {
    case 0: return "e";
    case 1: return "g";
    case 2: return "s";
    case 3: return "n";
    case 4: return "e";
    case 5: return "o";
    case 6: return "n";
    case 7: return "m";
    case 8: return "a";
    case 9: return "e";
    case 10: return "t";
    case 11: return "p";
    case 12: return "n";
    case 13: return "o";
    case 14: return "a";
    case 15: return "w";
    case 16: return "l";
    case 17: return "e";
    case 18: return "r";
    case 19: return "U";
    case 20: return " ";
    case 21: return "p";
    case 22: return "e'";
    case 23: return "W";
    case 24: return "S";
    case 25: return "Ith";
    case 26: return "E";
    case 27: return "Ca";
    case 28: return "A";
    case 29: return "Ra";
    case 30: return "T";
    case 31: return "Zy";
    case 32: return "S";
    case 33: return "I";
    case 34: return "O";
    case 35: return "F";
    case 36: return "N";
    case 37: return "R";
    case 38: return "V";
    case 39: return "A";
    case 40: return "E";
    case 41: return "G";
    case 42: return "N";
    case 43: return "E";
    case 44: return "T";
    case 45: return "G";
    case 46: return "I";
    case 47: return "N";
    case 48: return "O";
    case 49: return "S";
    case 50: return "N";
    case 51: return "E";
    default: return sLetter; } return "";
}

string ProcessLantanese(string sPhrase)
{
    string sOutput;
    int iToggle;
    while (GetStringLength(sPhrase) > 0)
    {
        if (GetStringLeft(sPhrase,1) == "*") iToggle = abs(iToggle - 1);
        if (iToggle) sOutput = sOutput + GetStringLeft(sPhrase,1);
        else sOutput = sOutput + ConvertLantanese(GetStringLeft(sPhrase, 1));
        sPhrase = GetStringRight(sPhrase, GetStringLength(sPhrase)-1);
    }
    return sOutput;
}

string ConvertMidani(string sLetter)
{
    string sTranslate = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int iTrans = FindSubString(sTranslate, sLetter);
    switch (iTrans)
    {
    case 0: return "i";
    case 1: return "z";
    case 2: return "n";
    case 3: return "a";
    case 4: return "a";
    case 5: return "k";
    case 6: return "d";
    case 7: return "h";
    case 8: return "i";
    case 9: return "a";
    case 10: return "m";
    case 11: return "r";
    case 12: return "a";
    case 13: return "b";
    case 14: return "d";
    case 15: return "e";
    case 16: return "s";
    case 17: return "d";
    case 18: return "e";
    case 19: return "i";
    case 20: return "r";
    case 21: return "n";
    case 22: return "t";
    case 23: return "e";
    case 24: return "S";
    case 25: return "C";
    case 26: return "A";
    case 27: return "A";
    case 28: return "N";
    case 29: return "L";
    case 30: return "D";
    case 31: return "I";
    case 32: return "S";
    case 33: return "M";
    case 34: return "'";
    case 35: return "S";
    case 36: return "Y";
    case 37: return "H";
    case 38: return "L";
    case 39: return "A";
    case 40: return "E";
    case 41: return "N  ";
    case 42: return "Rg";
    case 43: return "K";
    case 44: return "Gr";
    case 45: return "I";
    case 46: return "A";
    case 47: return "L";
    case 48: return "F";
    case 49: return "N";
    case 50: return "Y";
    case 51: return "U";
    default: return sLetter; } return "";
}

string ProcessMidani(string sPhrase)
{
    string sOutput;
    int iToggle;
    while (GetStringLength(sPhrase) > 0)
    {
        if (GetStringLeft(sPhrase,1) == "*") iToggle = abs(iToggle - 1);
        if (iToggle) sOutput = sOutput + GetStringLeft(sPhrase,1);
        else sOutput = sOutput + ConvertMidani(GetStringLeft(sPhrase, 1));
        sPhrase = GetStringRight(sPhrase, GetStringLength(sPhrase)-1);
    }
    return sOutput;
}

string ConvertMulhorandi(string sLetter)
{
    string sTranslate = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int iTrans = FindSubString(sTranslate, sLetter);
    switch (iTrans)
    {
    case 0: return "i";
    case 1: return "r";
    case 2: return "d";
    case 3: return "e";
    case 4: return "n";
    case 5: return "d";
    case 6: return "a";
    case 7: return "b";
    case 8: return "r";
    case 9: return "u";
    case 10: return "o";
    case 11: return "l";
    case 12: return "h";
    case 13: return "l";
    case 14: return "l";
    case 15: return "E";
    case 16: return "u";
    case 17: return "l";
    case 18: return "m";
    case 19: return "v";
    case 20: return " ";
    case 21: return "e";
    case 22: return "E";
    case 23: return "S";
    case 24: return "R";
    case 25: return "W";
    case 26: return "E";
    case 27: return "I";
    case 28: return "H";
    case 29: return "T";
    case 30: return "T";
    case 31: return "H";
    case 32: return "O";
    case 33: return "W";
    case 34: return "S";
    case 35: return "I";
    case 36: return "D";
    case 37: return "N";
    case 38: return "L";
    case 39: return "G";
    case 40: return "R";
    case 41: return "S";
    case 42: return "O";
    case 43: return "R";
    case 44: return "W";
    case 45: return "U";
    case 46: return "E";
    case 47: return "L";
    case 48: return "H";
    case 49: return "E";
    case 50: return "'";
    case 51: return "T";
    default: return sLetter; } return "";
}

string ProcessMulhorandi(string sPhrase)
{
    string sOutput;
    int iToggle;
    while (GetStringLength(sPhrase) > 0)
    {
        if (GetStringLeft(sPhrase,1) == "*") iToggle = abs(iToggle - 1);
        if (iToggle) sOutput = sOutput + GetStringLeft(sPhrase,1);
        else sOutput = sOutput + ConvertMulhorandi(GetStringLeft(sPhrase, 1));
        sPhrase = GetStringRight(sPhrase, GetStringLength(sPhrase)-1);
    }
    return sOutput;
}

string ConvertNexalan(string sLetter)
{
   string sTranslate = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int iTrans = FindSubString(sTranslate, sLetter);
    switch (iTrans)
    {
    case 0: return "n";
    case 1: return "m";
    case 2: return "a";
    case 3: return "a";
    case 4: return "l";
    case 5: return "z";
    case 6: return "a";
    case 7: return "t";
    case 8: return "x";
    case 9: return "i";
    case 10: return "e";
    case 11: return "c";
    case 12: return "n";
    case 13: return "a";
    case 14: return "e";
    case 15: return "";
    case 16: return "n";
    case 17: return "";
    case 18: return "t";
    case 19: return "";
    case 20: return "e";
    case 21: return "";
    case 22: return "r";
    case 23: return "";
    case 24: return "P";
    case 25: return "";
    case 26: return "R";
    case 27: return "S";
    case 28: return "I";
    case 29: return "";
    case 30: return "S";
    case 31: return "";
    case 32: return "E";
    case 33: return " ";
    case 34: return "U";
    case 35: return "-";
    case 36: return "S";
    case 37: return "'";
    case 38: return "N";
    case 39: return "A";
    case 40: return "A";
    case 41: return "C";
    case 42: return "L";
    case 43: return "I";
    case 44: return "A";
    case 45: return "T";
    case 46: return "X";
    case 47: return "Z";
    case 48: return "E";
    case 49: return "A";
    case 50: return "N";
    case 51: return "M";
    default: return sLetter; } return "";
}

string ProcessNexalan(string sPhrase)
{
    string sOutput;
    int iToggle;
    while (GetStringLength(sPhrase) > 0)
    {
        if (GetStringLeft(sPhrase,1) == "*") iToggle = abs(iToggle - 1);
        if (iToggle) sOutput = sOutput + GetStringLeft(sPhrase,1);
        else sOutput = sOutput + ConvertNexalan(GetStringLeft(sPhrase, 1));
        sPhrase = GetStringRight(sPhrase, GetStringLength(sPhrase)-1);
    }
    return sOutput;
}

string ConvertOillusk(string sLetter)
{
    string sTranslate = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int iTrans = FindSubString(sTranslate, sLetter);
    switch (iTrans)
    {
    case 0: return "k";
    case 1: return "s";
    case 2: return "u";
    case 3: return "l";
    case 4: return "l";
    case 5: return "i";
    case 6: return "o";
    case 7: return "n";
    case 8: return "s";
    case 9: return "o";
    case 10: return "i";
    case 11: return "r";
    case 12: return "n";
    case 13: return "t";
    case 14: return "g";
    case 15: return "h";
    case 16: return "i";
    case 17: return "s";
    case 18: return "n";
    case 19: return "w";
    case 20: return "g";
    case 21: return "o";
    case 22: return "i";
    case 23: return "R";
    case 24: return "N";
    case 25: return "D";
    case 26: return "T";
    case 27: return "C";
    case 28: return "H";
    case 29: return "O";
    case 30: return "E";
    case 31: return "A";
    case 32: return "R";
    case 33: return "S";
    case 34: return "A";
    case 35: return "T";
    case 36: return "I";
    case 37: return "H";
    case 38: return "N";
    case 39: return "S";
    case 40: return "";
    case 41: return "I";
    case 42: return "'b";
    case 43: return "V";
    case 44: return "G";
    case 45: return "I";
    case 46: return "G";
    case 47: return "T";
    case 48: return "X";
    case 49: return "C";
    case 50: return " S";
    case 51: return "O";
    default: return sLetter; } return "";
}

string ProcessOillusk(string sPhrase)
{
    string sOutput;
    int iToggle;
    while (GetStringLength(sPhrase) > 0)
    {
        if (GetStringLeft(sPhrase,1) == "*") iToggle = abs(iToggle - 1);
        if (iToggle) sOutput = sOutput + GetStringLeft(sPhrase,1);
        else sOutput = sOutput + ConvertOillusk(GetStringLeft(sPhrase, 1));
        sPhrase = GetStringRight(sPhrase, GetStringLength(sPhrase)-1);
    }
    return sOutput;
}

string ConvertRashemi(string sLetter)
{
    string sTranslate = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int iTrans = FindSubString(sTranslate, sLetter);
    switch (iTrans)
    {
    case 0: return "i";
    case 1: return "r";
    case 2: return "m";
    case 3: return "a";
    case 4: return "e";
    case 5: return "s";
    case 6: return "h";
    case 7: return "h";
    case 8: return "s";
    case 9: return "e";
    case 10: return "a";
    case 11: return "m";
    case 12: return "r";
    case 13: return "Rawr";
    case 14: return "a";
    case 15: return "rarg";
    case 16: return "n";
    case 17: return "t";
    case 18: return "ej";
    case 19: return "e";
    case 20: return "x";
    case 21: return "d";
    case 22: return "cv";
    case 23: return "D";
    case 24: return "F";
    case 25: return "Y";
    case 26: return "I";
    case 27: return "B";
    case 28: return "S";
    case 29: return "E";
    case 30: return "H";
    case 31: return "A";
    case 32: return "F";
    case 33: return "R";
    case 34: return "L";
    case 35: return "P";
    case 36: return "A";
    case 37: return "U";
    case 38: return "M";
    case 39: return "N";
    case 40: return "M";
    case 41: return "K";
    case 42: return "A";
    case 43: return "E";
    case 44: return "B";
    case 45: return "L";
    case 46: return "T";
    case 47: return "E";
    case 48: return "N";
    case 49: return "P";
    case 50: return "A";
    case 51: return "H";
    default: return sLetter; } return "";
}

string ProcessRashemi(string sPhrase)
{
    string sOutput;
    int iToggle;
    while (GetStringLength(sPhrase) > 0)
    {
        if (GetStringLeft(sPhrase,1) == "*") iToggle = abs(iToggle - 1);
        if (iToggle) sOutput = sOutput + GetStringLeft(sPhrase,1);
        else sOutput = sOutput + ConvertRashemi(GetStringLeft(sPhrase, 1));
        sPhrase = GetStringRight(sPhrase, GetStringLength(sPhrase)-1);
    }
    return sOutput;
}

string ConvertRaumvira(string sLetter)
{
    string sTranslate = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int iTrans = FindSubString(sTranslate, sLetter);
    switch (iTrans)
    {
    case 0: return "a";
    case 1: return "t";
    case 2: return "r";
    case 3: return "h";
    case 4: return "i";
    case 5: return "e";
    case 6: return "v";
    case 7: return "s";
    case 8: return "m";
    case 9: return "k";
    case 10: return "u";
    case 11: return "t";
    case 12: return "a";
    case 13: return "h";
    case 14: return "r";
    case 15: return "a";
    case 16: return "";
    case 17: return "r";
    case 18: return "";
    case 19: return "r";
    case 20: return " ";
    case 21: return "i";
    case 22: return "S";
    case 23: return "sS";
    case 24: return "P";
    case 25: return "D";
    case 26: return "E";
    case 27: return "N";
    case 28: return "A";
    case 29: return "E";
    case 30: return "K";
    case 31: return "F";
    case 32: return "S";
    case 33: return "R";
    case 34: return "I";
    case 35: return "I";
    case 36: return "R";
    case 37: return "A";
    case 38: return "H";
    case 39: return "R";
    case 40: return "T";
    case 41: return "I";
    case 42: return "K";
    case 43: return "V";
    case 44: return "S";
    case 45: return "M";
    case 46: return "E";
    case 47: return "U";
    case 48: return "H";
    case 49: return "A";
    case 50: return "T";
    case 51: return "R";
    default: return sLetter; } return "";
}

string ProcessRaumvira(string sPhrase)
{
    string sOutput;
    int iToggle;
    while (GetStringLength(sPhrase) > 0)
    {
        if (GetStringLeft(sPhrase,1) == "*") iToggle = abs(iToggle - 1);
        if (iToggle) sOutput = sOutput + GetStringLeft(sPhrase,1);
        else sOutput = sOutput + ConvertRaumvira(GetStringLeft(sPhrase, 1));
        sPhrase = GetStringRight(sPhrase, GetStringLength(sPhrase)-1);
    }
    return sOutput;
}

string ConvertSerusan(string sLetter)
{
    string sTranslate = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int iTrans = FindSubString(sTranslate, sLetter);
    switch (iTrans)
    {
    case 0: return "n";
    case 1: return "c";
    case 2: return "a";
    case 3: return "h";
    case 4: return "s";
    case 5: return "i";
    case 6: return "u";
    case 7: return "p";
    case 8: return "r";
    case 9: return "r";
    case 10: return "e";
    case 11: return "i";
    case 12: return "s";
    case 13: return "n";
    case 14: return "c";
    case 15: return "i";
    case 16: return "p";
    case 17: return "a";
    case 18: return "l";
    case 19: return "g";
    case 20: return "a";
    case 21: return "o";
    case 22: return "r";
    case 23: return "B";
    case 24: return "C";
    case 25: return "E";
    case 26: return "H";
    case 27: return "R";
    case 28: return "E";
    case 29: return "P";
    case 30: return "R";
    case 31: return "O";
    case 32: return "Sa";
    case 33: return "R";
    case 34: return "In";
    case 35: return "T";
    case 36: return "G";
    case 37: return "H";
    case 38: return "O";
    case 39: return "N";
    case 40: return "O";
    case 41: return "A";
    case 42: return "S";
    case 43: return "S";
    case 44: return "T";
    case 45: return "U";
    case 46: return "H";
    case 47: return "R";
    case 48: return "E";
    case 49: return "E";
    case 50: return "D";
    case 51: return "S";
    default: return sLetter; } return "";
}

string ProcessSerusan(string sPhrase)
{
    string sOutput;
    int iToggle;
    while (GetStringLength(sPhrase) > 0)
    {
        if (GetStringLeft(sPhrase,1) == "*") iToggle = abs(iToggle - 1);
        if (iToggle) sOutput = sOutput + GetStringLeft(sPhrase,1);
        else sOutput = sOutput + ConvertSerusan(GetStringLeft(sPhrase, 1));
        sPhrase = GetStringRight(sPhrase, GetStringLength(sPhrase)-1);
    }
    return sOutput;
}

string ConvertShaaran(string sLetter)
{
    string sTranslate = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int iTrans = FindSubString(sTranslate, sLetter);
    switch (iTrans)
    {
    case 0: return "n";
    case 1: return "s";
    case 2: return "a";
    case 3: return "e";
    case 4: return "r";
    case 5: return "s";
    case 6: return "a";
    case 7: return "p";
    case 8: return "a";
    case 9: return "e";
    case 10: return "h";
    case 11: return "c";
    case 12: return "s";
    case 13: return "h";
    case 14: return "t";
    case 15: return "s";
    case 16: return "h";
    case 17: return "c";
    case 18: return "e";
    case 19: return "h";
    case 20: return "s";
    case 21: return "o";
    case 22: return "h";
    case 23: return "L";
    case 24: return "A";
    case 25: return "Pa";
    case 26: return "R";
    case 27: return "A";
    case 28: return "R";
    case 29: return "L";
    case 30: return "M";
    case 31: return "I";
    case 32: return "A";
    case 33: return "I";
    case 34: return "E";
    case 35: return "Y";
    case 36: return "T";
    case 37: return "A";
    case 38: return "S";
    case 39: return "N";
    case 40: return "F";
    case 41: return "A";
    case 42: return "O";
    case 43: return "R";
    case 44: return "E";
    case 45: return "R";
    case 46: return "K";
    case 47: return "A";
    case 48: return "A";
    case 49: return "H";
    case 50: return "L";
    case 51: return "S";
    default: return sLetter; } return "";
}

string ProcessShaaran(string sPhrase)
{
    string sOutput;
    int iToggle;
    while (GetStringLength(sPhrase) > 0)
    {
        if (GetStringLeft(sPhrase,1) == "*") iToggle = abs(iToggle - 1);
        if (iToggle) sOutput = sOutput + GetStringLeft(sPhrase,1);
        else sOutput = sOutput + ConvertShaaran(GetStringLeft(sPhrase, 1));
        sPhrase = GetStringRight(sPhrase, GetStringLength(sPhrase)-1);
    }
    return sOutput;
}

string ConvertShou(string sLetter)
{
    string sTranslate = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int iTrans = FindSubString(sTranslate, sLetter);
    switch (iTrans)
    {
    case 0: return "u";
    case 1: return "e";
    case 2: return "o";
    case 3: return "m";
    case 4: return "h";
    case 5: return "p";
    case 6: return "s";
    case 7: return "o";
    case 8: return "d";
    case 9: return "r";
    case 10: return "r";
    case 11: return "e";
    case 12: return "a";
    case 13: return "r";
    case 14: return "c";
    case 15: return " ";
    case 16: return "o";
    case 17: return "j";
    case 18: return "n";
    case 19: return "w";
    case 20: return "i";
    case 21: return "nd";
    case 22: return "c";
    case 23: return "S";
    case 24: return "O";
    case 25: return "gh";
    case 26: return "B";
    case 27: return " ";
    case 28: return "A";
    case 29: return "'";
    case 30: return "G";
    case 31: return "A";
    case 32: return "N";
    case 33: return "V";
    case 34: return "A";
    case 35: return "L";
    case 36: return "R";
    case 37: return "A";
    case 38: return "U";
    case 39: return "Y";
    case 40: return "T";
    case 41: return "O";
    case 42: return "-";
    case 43: return "R";
    case 44: return "A";
    case 45: return "U";
    case 46: return "R";
    case 47: return "O";
    case 48: return "A";
    case 49: return "H";
    case 50: return "K";
    case 51: return "S";
    default: return sLetter; } return "";
}

string ProcessShou(string sPhrase)
{
    string sOutput;
    int iToggle;
    while (GetStringLength(sPhrase) > 0)
    {
        if (GetStringLeft(sPhrase,1) == "*") iToggle = abs(iToggle - 1);
        if (iToggle) sOutput = sOutput + GetStringLeft(sPhrase,1);
        else sOutput = sOutput + ConvertShou(GetStringLeft(sPhrase, 1));
        sPhrase = GetStringRight(sPhrase, GetStringLength(sPhrase)-1);
    }
    return sOutput;
}

string ConvertTalfiric(string sLetter)
{
    string sTranslate = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int iTrans = FindSubString(sTranslate, sLetter);
    switch (iTrans)
    {
    case 0: return "c";
    case 1: return "b";
    case 2: return "i";
    case 3: return "a";
    case 4: return "r";
    case 5: return "d";
    case 6: return "i";
    case 7: return "e";
    case 8: return "f";
    case 9: return "ho";
    case 10: return "l";
    case 11: return "w";
    case 12: return "a";
    case 13: return "e";
    case 14: return "t";
    case 15: return "s";
    case 16: return "a";
    case 17: return "t";
    case 18: return "l";
    case 19: return "e";
    case 20: return "c";
    case 21: return "r";
    case 22: return "u";
    case 23: return "N";
    case 24: return "M";
    case 25: return "He";
    case 26: return "P";
    case 27: return "A";
    case 28: return "O";
    case 29: return "R";
    case 30: return "W";
    case 31: return "T";
    case 32: return "D";
    case 33: return "L";
    case 34: return "E";
    case 35: return "A";
    case 36: return "R";
    case 37: return "C";
    case 38: return "N";
    case 39: return "I";
    case 40: return "D";
    case 41: return "R";
    case 42: return "S";
    case 43: return "E";
    case 44: return "";
    case 45: return "F";
    case 46: return "A";
    case 47: return "L";
    case 48: return "C";
    case 49: return "A";
    case 50: return "B";
    case 51: return "T";
    default: return sLetter; } return "";
}

string ProcessTalfiric(string sPhrase)
{
    string sOutput;
    int iToggle;
    while (GetStringLength(sPhrase) > 0)
    {
        if (GetStringLeft(sPhrase,1) == "*") iToggle = abs(iToggle - 1);
        if (iToggle) sOutput = sOutput + GetStringLeft(sPhrase,1);
        else sOutput = sOutput + ConvertTalfiric(GetStringLeft(sPhrase, 1));
        sPhrase = GetStringRight(sPhrase, GetStringLength(sPhrase)-1);
    }
    return sOutput;
}

string ConvertTashalan(string sLetter)
{
    string sTranslate = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int iTrans = FindSubString(sTranslate, sLetter);
    switch (iTrans)
    {
    case 0: return "n";
    case 1: return "b";
    case 2: return "a";
    case 3: return "l";
    case 4: return "l";
    case 5: return "a";
    case 6: return "a";
    case 7: return "c";
    case 8: return "h";
    case 9: return "k";
    case 10: return "s";
    case 11: return "j";
    case 12: return "a";
    case 13: return "u";
    case 14: return "t";
    case 15: return "n";
    case 16: return "t";
    case 17: return "g";
    case 18: return "h";
    case 19: return "l";
    case 20: return "i";
    case 21: return "e";
    case 22: return "n";
    case 23: return "S";
    case 24: return "D";
    case 25: return "A";
    case 26: return "O";
    case 27: return "M";
    case 28: return "L";
    case 29: return "A";
    case 30: return "M";
    case 31: return "R";
    case 32: return "H";
    case 33: return "A";
    case 34: return "I";
    case 35: return "C";
    case 36: return "R";
    case 37: return "N";
    case 38: return "H";
    case 39: return "A";
    case 40: return "D";
    case 41: return "H";
    case 42: return "W";
    case 43: return "S";
    case 44: return "R";
    case 45: return "A";
    case 46: return "Ve";
    case 47: return "L";
    case 48: return "N";
    case 49: return "A";
    case 50: return "CC";
    case 51: return "T";
    default: return sLetter; } return "";
}

string ProcessTashalan(string sPhrase)
{
    string sOutput;
    int iToggle;
    while (GetStringLength(sPhrase) > 0)
    {
        if (GetStringLeft(sPhrase,1) == "*") iToggle = abs(iToggle - 1);
        if (iToggle) sOutput = sOutput + GetStringLeft(sPhrase,1);
        else sOutput = sOutput + ConvertTashalan(GetStringLeft(sPhrase, 1));
        sPhrase = GetStringRight(sPhrase, GetStringLength(sPhrase)-1);
    }
    return sOutput;
}

string ConvertTuigan(string sLetter)
{
   string sTranslate = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int iTrans = FindSubString(sTranslate, sLetter);
    switch (iTrans)
    {
    case 0: return "n";
    case 1: return "p";
    case 2: return "a";
    case 3: return "e";
    case 4: return "g";
    case 5: return "o";
    case 6: return "i";
    case 7: return "n";
    case 8: return "u";
    case 9: return "s";
    case 10: return "t";
    case 11: return "w";
    case 12: return "tu";
    case 13: return "a";
    case 14: return "tin";
    case 15: return "r";
    case 16: return "ng";
    case 17: return "c";
    case 18: return "ti";
    case 19: return "h";
    case 20: return "ton";
    case 21: return "i";
    case 22: return "ng";
    case 23: return "E";
    case 24: return "Gyg";
    case 25: return "F";
    case 26: return "E";
    case 27: return "H";
    case 28: return "H";
    case 29: return "E";
    case 30: return "ET";
    case 31: return "H";
    case 32: return "S";
    case 33: return "T";
    case 34: return "D";
    case 35: return "R";
    case 36: return "N";
    case 37: return "O";
    case 38: return "A";
    case 39: return "F";
    case 40: return "L";
    case 41: return "N";
    case 42: return "E";
    case 43: return "A";
    case 44: return "D";
    case 45: return "G";
    case 46: return "R";
    case 47: return "I";
    case 48: return "O";
    case 49: return "U";
    case 50: return "H";
    case 51: return "T";
    default: return sLetter; } return "";
}

string ProcessTuigan(string sPhrase)
{
    string sOutput;
    int iToggle;
    while (GetStringLength(sPhrase) > 0)
    {
        if (GetStringLeft(sPhrase,1) == "*") iToggle = abs(iToggle - 1);
        if (iToggle) sOutput = sOutput + GetStringLeft(sPhrase,1);
        else sOutput = sOutput + ConvertTuigan(GetStringLeft(sPhrase, 1));
        sPhrase = GetStringRight(sPhrase, GetStringLength(sPhrase)-1);
    }
    return sOutput;
}

string ConvertTurmic(string sLetter)
{
    string sTranslate = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int iTrans = FindSubString(sTranslate, sLetter);
    switch (iTrans)
    {
    case 0: return "c";
    case 1: return "a";
    case 2: return "i";
    case 3: return "n";
    case 4: return "m";
    case 5: return "t";
    case 6: return "r";
    case 7: return "i";
    case 8: return "u";
    case 9: return "c";
    case 10: return "t";
    case 11: return "s";
    case 12: return "m";
    case 13: return "o";
    case 14: return "l";
    case 15: return "f";
    case 16: return "t";
    case 17: return "f";
    case 18: return "u";
    case 19: return "s";
    case 20: return "r";
    case 21: return "d";
    case 22: return "m";
    case 23: return "B";
    case 24: return "I";
    case 25: return "A";
    case 26: return "S";
    case 27: return "L";
    case 28: return "H";
    case 29: return "E";
    case 30: return "Le";
    case 31: return "F";
    case 32: return "A";
    case 33: return "F";
    case 34: return "D";
    case 35: return "O";
    case 36: return "D";
    case 37: return "R";
    case 38: return "N";
    case 39: return "P";
    case 40: return "A";
    case 41: return "C";
    case 42: return "R";
    case 43: return "I";
    case 44: return "Y";
    case 45: return "M";
    case 46: return "R";
    case 47: return "R";
    case 48: return "O";
    case 49: return "U";
    case 50: return "C";
    case 51: return "T";
    default: return sLetter; } return "";
}

string ProcessTurmic(string sPhrase)
{
    string sOutput;
    int iToggle;
    while (GetStringLength(sPhrase) > 0)
    {
        if (GetStringLeft(sPhrase,1) == "*") iToggle = abs(iToggle - 1);
        if (iToggle) sOutput = sOutput + GetStringLeft(sPhrase,1);
        else sOutput = sOutput + ConvertTurmic(GetStringLeft(sPhrase, 1));
        sPhrase = GetStringRight(sPhrase, GetStringLength(sPhrase)-1);
    }
    return sOutput;
}

string ConvertUluik(string sLetter)
{
    string sTranslate = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int iTrans = FindSubString(sTranslate, sLetter);
    switch (iTrans)
    {
    case 0: return "k";
    case 1: return "t";
    case 2: return "i";
    case 3: return "h";
    case 4: return "u";
    case 5: return "e";
    case 6: return "l";
    case 7: return "g";
    case 8: return "u";
    case 9: return "r";
    case 10: return "yu";
    case 11: return "e";
    case 12: return "x";
    case 13: return "a";
    case 14: return "se";
    case 15: return "t";
    case 16: return "te'";
    case 17: return "b";
    case 18: return "ym'";
    case 19: return "e";
    case 20: return "een";
    case 21: return "e";
    case 22: return "r";
    case 23: return "O";
    case 24: return "E";
    case 25: return "U";
    case 26: return "I";
    case 27: return "T";
    case 28: return "C";
    case 29: return "H";
    case 30: return "A";
    case 31: return "E";
    case 32: return "L";
    case 33: return "R";
    case 34: return "G";
    case 35: return "E";
    case 36: return "T";
    case 37: return "D";
    case 38: return "A";
    case 39: return "A";
    case 40: return "E";
    case 41: return "T";
    case 42: return "R";
    case 43: return "K";
    case 44: return "G";
    case 45: return "I";
    case 46: return "E";
    case 47: return "U";
    case 48: return "H";
    case 49: return "L";
    case 50: return "T";
    case 51: return "U";
    default: return sLetter; } return "";
}

string ProcessUluik(string sPhrase)
{
    string sOutput;
    int iToggle;
    while (GetStringLength(sPhrase) > 0)
    {
        if (GetStringLeft(sPhrase,1) == "*") iToggle = abs(iToggle - 1);
        if (iToggle) sOutput = sOutput + GetStringLeft(sPhrase,1);
        else sOutput = sOutput + ConvertUluik(GetStringLeft(sPhrase, 1));
        sPhrase = GetStringRight(sPhrase, GetStringLength(sPhrase)-1);
    }
    return sOutput;
}

string ConvertUntheric(string sLetter)
{
    string sTranslate = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int iTrans = FindSubString(sTranslate, sLetter);
    switch (iTrans)
    {
    case 0: return "c";
    case 1: return "u";
    case 2: return "i";
    case 3: return "n";
    case 4: return "r";
    case 5: return "t";
    case 6: return "e";
    case 7: return "h";
    case 8: return "h";
    case 9: return "e";
    case 10: return "t";
    case 11: return "r";
    case 12: return "n";
    case 13: return "d";
    case 14: return "u";
    case 15: return "e";
    case 16: return "a";
    case 17: return "t";
    case 18: return "l";
    case 19: return "h";
    case 20: return "e ";
    case 21: return "e";
    case 22: return "w";
    case 23: return "K";
    case 24: return "E";
    case 25: return "Sc";
    case 26: return "T";
    case 27: return "Ot";
    case 28: return "S";
    case 29: return "Ch";
    case 30: return "F";
    case 31: return "B";
    case 32: return "R";
    case 33: return "Oo";
    case 34: return "A";
    case 35: return "Ze";
    case 36: return "W";
    case 37: return "C";
    case 38: return "D";
    case 39: return "I";
    case 40: return "K";
    case 41: return "R";
    case 42: return "J";
    case 43: return "E";
    case 44: return "H";
    case 45: return "H";
    case 46: return "T";
    case 47: return "T";
    case 48: return "E";
    case 49: return "N";
    case 50: return "D";
    case 51: return "U";
    default: return sLetter; } return "";
}

string ProcessUntheric(string sPhrase)
{
    string sOutput;
    int iToggle;
    while (GetStringLength(sPhrase) > 0)
    {
        if (GetStringLeft(sPhrase,1) == "*") iToggle = abs(iToggle - 1);
        if (iToggle) sOutput = sOutput + GetStringLeft(sPhrase,1);
        else sOutput = sOutput + ConvertUntheric(GetStringLeft(sPhrase, 1));
        sPhrase = GetStringRight(sPhrase, GetStringLength(sPhrase)-1);
    }
    return sOutput;
}

string ConvertVaasan(string sLetter)
{
    string sTranslate = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int iTrans = FindSubString(sTranslate, sLetter);
    switch (iTrans)
    {
    case 0: return "n";
    case 1: return "t";
    case 2: return "a";
    case 3: return "h";
    case 4: return "s";
    case 5: return "e";
    case 6: return "a";
    case 7: return "t";
    case 8: return "a";
    case 9: return "o";
    case 10: return "v";
    case 11: return "r";
    case 12: return "h";
    case 13: return "t";
    case 14: return "i";
    case 15: return "u";
    case 16: return "g";
    case 17: return "r";
    case 18: return "h";
    case 19: return "e";
    case 20: return "i";
    case 21: return "d";
    case 22: return "c";
    case 23: return "L";
    case 24: return "E";
    case 25: return "A";
    case 26: return "G";
    case 27: return "N";
    case 28: return "O";
    case 29: return "D";
    case 30: return "O";
    case 31: return "S";
    case 32: return "G";
    case 33: return "San";
    case 34: return "L";
    case 35: return "Dwi";
    case 36: return "Y";
    case 37: return "Ch";
    case 38: return "M";
    case 39: return "Ti";
    case 40: return "O";
    case 41: return "N";
    case 42: return "O";
    case 43: return "A";
    case 44: return "G";
    case 45: return "A";
    case 46: return "L";
    case 47: return "S";
    case 48: return "Y";
    case 49: return "A";
    case 50: return "Oy";
    case 51: return "V";
    default: return sLetter; } return "";
}

string ProcessVaasan(string sPhrase)
{
    string sOutput;
    int iToggle;
    while (GetStringLength(sPhrase) > 0)
    {
        if (GetStringLeft(sPhrase,1) == "*") iToggle = abs(iToggle - 1);
        if (iToggle) sOutput = sOutput + GetStringLeft(sPhrase,1);
        else sOutput = sOutput + ConvertVaasan(GetStringLeft(sPhrase, 1));
        sPhrase = GetStringRight(sPhrase, GetStringLength(sPhrase)-1);
    }
    return sOutput;
}

string ConvertDruidic(string sLetter)
{
    string sTranslate = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int iTrans = FindSubString(sTranslate, sLetter);
    switch (iTrans)
    {
    case 0: return "d";
    case 1: return "d";
    case 2: return "r";
    case 3: return "o";
    case 4: return "u";
    case 5: return "o";
    case 6: return "i";
    case 7: return "l";
    case 8: return "d";
    case 9: return "i";
    case 10: return "i";
    case 11: return "t";
    case 12: return "c";
    case 13: return "t";
    case 14: return "t";
    case 15: return "l";
    case 16: return "a";
    case 17: return "e";
    case 18: return "l";
    case 19: return "d";
    case 20: return "k";
    case 21: return "o";
    case 22: return "Wii";
    case 23: return "C";
    case 24: return "U";
    case 25: return "T";
    case 26: return "G";
    case 27: return "O";
    case 28: return "N";
    case 29: return "R";
    case 30: return "T";
    case 31: return "K";
    case 32: return "N";
    case 33: return "L";
    case 34: return "E";
    case 35: return "A";
    case 36: return "S";
    case 37: return "T";
    case 38: return "O";
    case 39: return "C";
    case 40: return "H";
    case 41: return "I";
    case 42: return "O";
    case 43: return "D";
    case 44: return "A";
    case 45: return "I";
    case 46: return "T";
    case 47: return "U";
    case 48: return "B";
    case 49: return "R";
    case 50: return "U";
    case 51: return "D";
    default: return sLetter; } return "";
}

string ProcessDruidic(string sPhrase)
{
    string sOutput;
    int iToggle;
    while (GetStringLength(sPhrase) > 0)
    {
        if (GetStringLeft(sPhrase,1) == "*") iToggle = abs(iToggle - 1);
        if (iToggle) sOutput = sOutput + GetStringLeft(sPhrase,1);
        else sOutput = sOutput + ConvertDruidic(GetStringLeft(sPhrase, 1));
        sPhrase = GetStringRight(sPhrase, GetStringLength(sPhrase)-1);
    }
    return sOutput;
}

string ProcessAssassinsCant(string sLetter)
{
    if (GetStringLength(sLetter) > 0) sLetter = GetStringLeft(sLetter, 1);
    if (sLetter == "a" || sLetter == "A") return ASCANT_A;
    if (sLetter == "b" || sLetter == "B") return ASCANT_B;
    if (sLetter == "c" || sLetter == "C") return ASCANT_C;
    if (sLetter == "d" || sLetter == "D") return ASCANT_D;
    if (sLetter == "e" || sLetter == "E") return ASCANT_E;
    if (sLetter == "f" || sLetter == "F") return ASCANT_F;
    if (sLetter == "g" || sLetter == "G") return ASCANT_G;
    if (sLetter == "h" || sLetter == "H") return ASCANT_H;
    if (sLetter == "i" || sLetter == "I") return ASCANT_I;
    if (sLetter == "j" || sLetter == "J") return ASCANT_J;
    if (sLetter == "k" || sLetter == "K") return ASCANT_K;
    if (sLetter == "l" || sLetter == "L") return ASCANT_L;
    if (sLetter == "m" || sLetter == "M") return ASCANT_M;
    if (sLetter == "n" || sLetter == "N") return ASCANT_N;
    if (sLetter == "o" || sLetter == "O") return ASCANT_O;
    if (sLetter == "p" || sLetter == "P") return ASCANT_P;
    if (sLetter == "q" || sLetter == "Q") return ASCANT_Q;
    if (sLetter == "r" || sLetter == "R") return ASCANT_R;
    if (sLetter == "s" || sLetter == "S") return ASCANT_S;
    if (sLetter == "t" || sLetter == "T") return ASCANT_T;
    if (sLetter == "u" || sLetter == "U") return ASCANT_U;
    if (sLetter == "v" || sLetter == "V") return ASCANT_V;
    if (sLetter == "w" || sLetter == "W") return ASCANT_W;
    if (sLetter == "x" || sLetter == "X") return ASCANT_X;
    if (sLetter == "y" || sLetter == "Y") return ASCANT_Y;
    if (sLetter == "z" || sLetter == "Z") return ASCANT_Z;
    return ASCANT_DEFAULT;
}

// FILE: dmfi_inc_lang
// Returns translated version of sPhrase in sLang. It will return "" if sLang not valid
string DMFI_ProcessLanguage(string sPhrase, string sLang, object oTool)
{ 

  // Original Scripter: Demetrious
  // Last Modified By: Demetrious  1/11/7
  //  2009/07/10 AL - ALFA edits, Talfiric for Loross, Raumvira for Netherese
    string sOutput;
    	
	if (sLang==LNG_COMMON) return sPhrase;
	
	int nSort = GetLocalInt(oTool, sLang);
	
	if (nSort==1)
    {
        if (sLang==LNG_ANIMAL) sOutput =  ProcessAnimal(sPhrase);
        else if (sLang==LNG_ASSASSIN) sOutput =  ProcessAssassinsCant(sPhrase);
        else if (sLang==LNG_ABYSSAL) sOutput =  ProcessAbyssal(sPhrase);
        else if (sLang==LNG_AQUAN) sOutput =  ProcessAquan(sPhrase);
        else if (sLang==LNG_AURAN) sOutput =  ProcessAuran(sPhrase);
        else if (sLang==LNG_ALGARONDAN) sOutput =  ProcessAlgarondan(sPhrase);
        else if (sLang==LNG_ALZHEDO) sOutput =  ProcessAlzhedo(sPhrase);
        else return "";
    }
    else if (nSort==2)
    {
        if (sLang==LNG_CANT) sOutput =  ProcessCant(sPhrase);
        else if (sLang==LNG_CELESTIAL) sOutput =  ProcessCelestial(sPhrase);
        else if (sLang==LNG_CHESSENTAN) sOutput =  ProcessChessentan(sPhrase);
        else if (sLang==LNG_CHONDATHAN) sOutput =  ProcessChondathan(sPhrase);
        else if (sLang==LNG_CHULTAN) sOutput =  ProcessChultan(sPhrase);
        else return "";
    }
    else if (nSort==3)
    {
        if (sLang==LNG_DWARF) sOutput =  ProcessDwarf(sPhrase);
        else if (sLang==LNG_DROW) sOutput =  ProcessDrow(sPhrase);
        else if (sLang==LNG_DROWSIGN) sOutput =  ProcessDrowSign(sPhrase);
        else if (sLang==LNG_DRUIDIC) sOutput =  ProcessDruidic(sPhrase);
        else if (sLang==LNG_DRACONIC) sOutput =  ProcessDraconic(sPhrase);
        else if (sLang==LNG_DAMARAN) sOutput =  ProcessDamaran(sPhrase);
        else if (sLang==LNG_DAMBRATHAN) sOutput =  ProcessDambrathan(sPhrase);
        else if (sLang==LNG_DURPARI) sOutput =  ProcessDurpari(sPhrase);
        else return "";
    }
    else if (nSort==4)
    {
        if (sLang==LNG_ELVEN) sOutput = ProcessElven(sPhrase);
        else if (sLang==LNG_GNOME) sOutput =  ProcessGnome(sPhrase);
        else if (sLang==LNG_GOBLIN) sOutput =  ProcessGoblin(sPhrase);
        else if (sLang==LNG_GIANT) sOutput =  ProcessGiant(sPhrase);
        else if (sLang==LNG_GNOLL) sOutput =  ProcessGnoll(sPhrase);
        else return "";
    }
    else if (nSort==5)
    {
        if (sLang==LNG_HALFLING) sOutput =  ProcessHalfling(sPhrase);
        else if (sLang==LNG_IGNAN) sOutput =  ProcessIgnan(sPhrase);
        else if (sLang==LNG_HALARDRIM) sOutput =  ProcessHalardrim(sPhrase);
        else if (sLang==LNG_HALRUAAN) sOutput = ProcessHalruaan(sPhrase);
        else if (sLang==LNG_ILLUSKAN) sOutput =  ProcessIlluskan(sPhrase);
        else if (sLang==LNG_IMASKAR) sOutput =  ProcessImaskar(sPhrase);
        else if (sLang==LNG_INFERNAL) sOutput =  ProcessInfernal(sPhrase);
        else return "";
    }
    else if (nSort==6)
    {
        if (sLang==LNG_LEETSPEAK) sOutput =  ProcessLeetspeak(sPhrase);
        else if (sLang==LNG_LANTANESE) sOutput =  ProcessLantanese(sPhrase);
		// ALFA edit:
        else if (sLang==LNG_LOROSS) sOutput =  ProcessTalfiric(sPhrase);
        else if (sLang==LNG_MIDANI) sOutput =  ProcessMidani(sPhrase);
        else if (sLang==LNG_MULHORANDI) sOutput =  ProcessMulhorandi(sPhrase);
		// ALFA edit:
		else if (sLang==LNG_NETHERESE) sOutput =  ProcessRaumvira(sPhrase);
        else return "";
    }
    else if (nSort==7)
    {
        if (sLang==LNG_RASHEMI) sOutput =  ProcessRashemi(sPhrase);
        else if (sLang==LNG_SERUSAN) sOutput =  ProcessSerusan(sPhrase);
        else if (sLang==LNG_SHAARAN) sOutput =  ProcessShaaran(sPhrase);
        else if (sLang==LNG_SHOU) sOutput =  ProcessShou(sPhrase);
        else if (sLang==LNG_SYLVAN) sOutput =  ProcessSylvan(sPhrase);
        else return "";
    }
    else if (nSort==8)
    {
        if (sLang==LNG_TERRAN) sOutput =  ProcessTerran(sPhrase);
        else if (sLang==LNG_TREANT) sOutput = ProcessTreant(sPhrase);
        else if (sLang==LNG_TASHALAN) sOutput =  ProcessTashalan(sPhrase);
        else if (sLang==LNG_TUIGAN) sOutput =  ProcessTuigan(sPhrase);
        else if (sLang==LNG_TURMIC) sOutput =  ProcessTurmic(sPhrase);
        else return "";
    }
    else
    {
        if (sLang==LNG_ORC) sOutput =  ProcessOrc(sPhrase);
        else if (sLang==LNG_NEXALAN) sOutput =  ProcessNexalan(sPhrase);
        // else if (sLang==LNG_OILLUSK) sOutput =  ProcessOillusk(sPhrase);
		// ALFA Edit:
		else if (sLang==LNG_YUANTI) sOutput =  ProcessOillusk(sPhrase);
        else if (sLang==LNG_UNDERCOMMON) sOutput =  ProcessUndercommon(sPhrase);
        else if (sLang==LNG_ULUIK) sOutput =  ProcessUluik(sPhrase);
        else if (sLang==LNG_UNTHERIC) sOutput =  ProcessUntheric(sPhrase);
        else if (sLang==LNG_VAASAN) sOutput =  ProcessVaasan(sPhrase);
        else return "";
    }
    return sOutput;
}
//void main(){}