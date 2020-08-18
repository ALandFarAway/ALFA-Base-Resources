////////////////////////////////////////////////////////////////////////////////
//
//                     Wynna			9/18/2008   
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////



void main()
{
    object oDM = OBJECT_SELF;
	object oObject = GetLocalObject(oDM, "Object_Target");
	int iDeity = GetLocalInt(oDM, "SetPCDeity");
	
		 SendMessageToPC(oDM, "Deity: " + GetDeity(oObject));
		 
		 
	string sDeity;
	if(iDeity == 0)
		{sDeity = "No Deity";}
	if(iDeity == 1)
		{sDeity = "Akadi";}
	if(iDeity == 2)
		{sDeity = "Auril";}
	if(iDeity == 3)
		{sDeity = "Azuth";}
	if(iDeity == 4)
		{sDeity = "Bane";}
	if(iDeity == 5)
		{sDeity = "Beshaba";}
	if(iDeity == 6)
		{sDeity = "Chauntea";}
	if(iDeity == 7)
		{sDeity = "Cyric";}
	if(iDeity == 8)
		{sDeity = "Deneir";}
	if(iDeity == 9)
		{sDeity = "Eldath";}
	if(iDeity == 10)
		{sDeity = "Finder Wyvernspur";}
	if(iDeity == 11)
		{sDeity = "Garagos";}
	if(iDeity == 12)
		{sDeity = "Gargauth";}
	if(iDeity == 13)
		{sDeity = "Gond";}
	if(iDeity == 14)
		{sDeity = "Grumbar";}
	if(iDeity == 15)
		{sDeity = "Gwaeron Windstrom";}
	if(iDeity == 16)
		{sDeity = "Helm";}
	if(iDeity == 17)
		{sDeity = "Hoar";}
	if(iDeity == 18)
		{sDeity = "Ilmater";}
	if(iDeity == 19)
		{sDeity = "Istishia";}
	if(iDeity == 20)
		{sDeity = "Jergal";}
	if(iDeity == 21)
		{sDeity = "Kelemvor";}
	if(iDeity == 22)
		{sDeity = "Kossuth";}
	if(iDeity == 23)
		{sDeity = "Lathander";}
	if(iDeity == 24)
		{sDeity = "Lliira";}
	if(iDeity == 25)
		{sDeity = "Loviatar";}
	if(iDeity == 26)
		{sDeity = "Lurue";}
	if(iDeity == 27)
		{sDeity = "Malar";}
	if(iDeity == 28)
		{sDeity = "Mask";}
	if(iDeity == 29)
		{sDeity = "Mielikki";}
	if(iDeity == 30)
		{sDeity = "Milil";}
	if(iDeity == 31)
		{sDeity = "Mystra";}
	if(iDeity == 32)
		{sDeity = "Oghma";}
	if(iDeity == 33)
		{sDeity = "Red Knight";}
	if(iDeity == 34)
		{sDeity = "Savras";}
	if(iDeity == 35)
		{sDeity = "Selune";}
	if(iDeity == 36)
		{sDeity = "Shar";}
	if(iDeity == 37)
		{sDeity = "Sharess";}
	if(iDeity == 38)
		{sDeity = "Shaundakul";}
	if(iDeity == 39)
		{sDeity = "Shiallia";}
	if(iDeity == 40)
		{sDeity = "Siamorphe";}
	if(iDeity == 41)
		{sDeity = "Silvanus";}
	if(iDeity == 42)
		{sDeity = "Sune";}
	if(iDeity == 43)
		{sDeity = "Talona";}
	if(iDeity == 44)
		{sDeity = "Talos";}
	if(iDeity == 45)
		{sDeity = "Tempus";}
	if(iDeity == 46)
		{sDeity = "Torm";}
	if(iDeity == 47)
		{sDeity = "Tymora";}
	if(iDeity == 48)
		{sDeity = "Tyr";}
	if(iDeity == 49)
		{sDeity = "Umberlee";}
	if(iDeity == 50)
		{sDeity = "Valkur";}
	if(iDeity == 51)
		{sDeity = "Velsharoon";}
	if(iDeity == 52)
		{sDeity = "Waukeen";}
	if(iDeity == 53)
		{sDeity = "Leira";}
	if(iDeity == 54)
		{sDeity = "Ubtao";}
	if(iDeity == 55)
		{sDeity = "Abbathor";}
	if(iDeity == 56)
		{sDeity = "Berronar Truesilver";}
	if(iDeity == 57)
		{sDeity = "Clangeddin Silverbeard";}
	if(iDeity == 58)
		{sDeity = "Dugmaren Brightmantle";}
	if(iDeity == 59)
		{sDeity = "Dumathoin";}
	if(iDeity == 60)
		{sDeity = "Gorm Gulthyn";}
	if(iDeity == 61)
		{sDeity = "Haela Brightaxe";	}
	if(iDeity == 62)
		{sDeity = "Marthammor Duin";}
	if(iDeity == 63)
		{sDeity = "Moradin";}
	if(iDeity == 64)
		{sDeity = "Sharindlar";}
	if(iDeity == 65)
		{sDeity = "Thard Harr";}
	if(iDeity == 66)
		{sDeity = "Vergadain";}
	if(iDeity == 67)
		{sDeity = "Aerdrie Faenya";}
	if(iDeity == 68)
		{sDeity = "Angharradh";}
	if(iDeity == 69)
		{sDeity = "Corellon Larethian";}
	if(iDeity == 70)
		{sDeity = "Erevan Ilesere";}
	if(iDeity == 71)
		{sDeity = "Fenmarel Mestarine";}
	if(iDeity == 72)
		{sDeity = "Hanali Celanil";}
	if(iDeity == 73)
		{sDeity = "Labelas Enoreth";}
	if(iDeity == 74)
		{sDeity = "Rillfane Rallathil";}
	if(iDeity == 75)
		{sDeity = "Sehanine Moonbow";}
	if(iDeity == 76)
		{sDeity = "Shevarash";}
	if(iDeity == 77)
		{sDeity = "Solonor Thelandira";}
	if(iDeity == 78)
		{sDeity = "Eilistraee";}
	if(iDeity == 79)
		{sDeity = "Baervan Wildwanderer";}
	if(iDeity == 80)
		{sDeity = "Baravar Cloakshadow";}
	if(iDeity == 81)
		{sDeity = "Flandal Steelskin";}
	if(iDeity == 82)
		{sDeity = "Gaerdal Ironhand";}
	if(iDeity == 83)
		{sDeity = "Garl Glittergold";}
	if(iDeity == 84)
		{sDeity = "Segojan Earthcaller";}
	if(iDeity == 85)
		{sDeity = "Urdeen";}
	if(iDeity == 86)
		{sDeity = "Arvoreen";}
	if(iDeity == 87)
		{sDeity = "Brandobaris";}
	if(iDeity == 88)
		{sDeity = "Cyrrollalee";}
	if(iDeity == 89)
		{sDeity = "Sheela Peryroyl";}
	if(iDeity == 90)
		{sDeity = "Urogalan";}
	if(iDeity == 91)
		{sDeity = "Yondalla";}
	if(iDeity == 92)
		{sDeity = "Bahgtru";	}
	if(iDeity == 93)
		{sDeity = "Gruumsh";}
	if(iDeity == 94)
		{sDeity = "Ilneval";}
	if(iDeity == 95)
		{sDeity = "Luthic";}
	if(iDeity == 96)
		{sDeity = "Shargaas";}
	if(iDeity == 97)
		{sDeity = "Yurtrus";	}
	if(iDeity == 98)
		{sDeity = "Kiransalee";}
	if(iDeity == 99)
		{sDeity = "Lolth";}
	if(iDeity == 100)
		{sDeity = "Seveltarm";}
	if(iDeity == 101)
		{sDeity = "Vhaeraun";}
	if(iDeity == 102)
		{sDeity = "Ao";	} 
	if(iDeity == 103)
		{sDeity = "Uthgar";	} 
	if(iDeity == 104)
		{sDeity = "Tiamat";	} 
	if(iDeity == 105)
		{sDeity = "Bahamut";	} 
	if(iDeity == 106)
		{sDeity = "Unther";	} 
    if(iDeity == 107)
		{sDeity = "Jannath";	}	
    if(iDeity == 108)
		{sDeity = "Isis";	}	
	if(iDeity == 109)
		{sDeity = "Path of Enlightenment";	}
	if(iDeity == 110)
		{sDeity = "The Way";	}
	if(iDeity == 111)
		{sDeity = "Faith of the Nine Travelers";	}
	if(iDeity == 112)
		{sDeity = "Eight Million Gods";	}
	
	if(iDeity >= 0)
		{SetDeity(oObject, sDeity);
		 SendMessageToPC(oDM, "Deity changed to: " + GetDeity(oObject));
		 SetLocalInt(oDM, "SetPCDeity", 0);
		 }
}