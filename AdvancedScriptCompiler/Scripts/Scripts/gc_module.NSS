// gc_module( string sTag )
/*
	Compare sTag to current module's tag.
*/
// BMA-OEI 5/15/06

int StartingConditional( string sTag )
{
	object oModule = GetModule();
	return ( GetTag( oModule ) == sTag );
}