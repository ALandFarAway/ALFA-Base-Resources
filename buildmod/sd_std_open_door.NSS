void main()
{ 

//NOTE: not sure, but I suspect an object can not find itself as a 'nearest object'
// - so this script is a workaround to let objects delete themselves.

  	string self_tag = GetTag( OBJECT_SELF );
	string first_tag = GetLocalString(OBJECT_SELF,"Target1");
	string second_tag = GetLocalString(OBJECT_SELF,"Target2");

	object oTarg1;
	object oTarg2;
	
	if( self_tag != first_tag ){
		oTarg1 = GetNearestObjectByTag( first_tag );
	}	else {
		oTarg1 = OBJECT_SELF;
	}
	if( self_tag != second_tag ){
		oTarg2 = GetNearestObjectByTag( second_tag );
	} else {
		oTarg2 = OBJECT_SELF;
	}

	DestroyObject( oTarg1 );
	DestroyObject( oTarg2 );
	
}