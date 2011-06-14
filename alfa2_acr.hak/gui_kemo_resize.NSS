// KEMO
// called from kemo_sitting_conv (option 8) and kemo_animation_conv (option 8)
// normalizes PC height
// now called from kemo_chairs.xml ---KEMO 3/10/09

void main()
{
	//object oPC = GetPCSpeaker();
	object oPC = OBJECT_SELF;
	float fPCHeight = GetScale(oPC,SCALE_Z);
	float fPCNaturalHeight = GetLocalFloat(oPC,"CharacterHeight");
		if (fPCNaturalHeight < 0.1) fPCNaturalHeight = fPCHeight;
	float fPCX = GetScale(oPC,SCALE_X);
	float fPCY = GetScale(oPC,SCALE_Y);

	if (fPCHeight == 1.0f) // if the character is currently at normalized height, return to natural
		SetScale(oPC,fPCX,fPCY,fPCNaturalHeight);
	else // character is at natural height, normalize
	{
		SetLocalFloat(oPC,"CharacterHeight",fPCHeight);
		SetScale(oPC,fPCX,fPCY,1.0f);
	}
}