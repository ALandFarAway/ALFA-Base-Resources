//
// gui_scliext_dm_pollarea
//
// This support script lets DMs using the client extension view creatures in
// areas other than their current area.
//

void main( int nReserved, int nObjectTypeMask, int nAreaObjectId )
{
	object oAreaObject = IntToObject( nAreaObjectId );
	object oCallerPC   = OBJECT_SELF;
	object oAreaObj   = GetFirstObjectInArea( oAreaObject );
	int    nType;
	float  fFacing;
	vector vPos;

	//
	// Only allow access to DMs.
	//

	if (GetIsDM( oCallerPC ) == FALSE)
		return;

	while (oAreaObj != OBJECT_INVALID)
	{
		nType = GetObjectType( oAreaObj );

		//
		// Filter the list of objects to only what the caller requested.
		//

		if ((nType == OBJECT_TYPE_INVALID) || (!(nType & nObjectTypeMask)))
		{	oAreaObj = GetNextObjectInArea( oAreaObject );
			continue;
		}

		//
		// Transmit updated positional data.
		//

		vPos    = GetPosition( oAreaObj );
		fFacing = GetFacing( oAreaObj );

		SendMessageToPC(
			oCallerPC,
			"SCliExt11" + ObjectToString( oAreaObj ) + " " +
				FloatToString( vPos.x ) + " " +
				FloatToString( vPos.y ) + " " +
				FloatToString( vPos.z ) + " " +
				FloatToString( fFacing )
			);
		oAreaObj = GetNextObjectInArea( oAreaObject );
	}

	//
	// Inform the caller that all area positional data has now been sent.
	//

	SendMessageToPC( oCallerPC, "SCliExt12" + ObjectToString( oAreaObject ) );
}
