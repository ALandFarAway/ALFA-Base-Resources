// gr_print_effects( string sTag )
// BMA-OEI 9/05/06

#include "ginc_debug"
#include "ginc_param_const"

void PrintEffect( effect eEffect );
void PrintEffectsOnObject( object oObject );

void main( string sTag )
{
	object oObject = GetTarget( sTag );
	PrettyDebug( "gr_print_effects: printing effects on " + GetName( oObject ) + " (Tag:" + GetTag( oObject ) + ")" );
	PrintEffectsOnObject( oObject );
}

void PrintEffect( effect eEffect )
{
	PrettyMessage( " ** Creator : " + GetName( GetEffectCreator( eEffect ) ) + " (Tag:" + GetTag( GetEffectCreator( eEffect ) ) + ")" );
	PrettyMessage( " ** Duration: " + IntToString( GetEffectDurationType( eEffect ) ) );
	PrettyMessage( " ** SpellId : " + IntToString( GetEffectSpellId( eEffect ) ) );
	PrettyMessage( " ** Type    : " + IntToString( GetEffectType( eEffect ) ) );
	PrettyMessage( " ** SubType : " + IntToString( GetEffectSubType( eEffect ) ) );
}

void PrintEffectsOnObject( object oObject )
{
	string sName = GetName( oObject );
	string sTag = GetTag( oObject );
	effect eEffect = GetFirstEffect( oObject );
	int n = 1;
	while ( GetIsEffectValid( eEffect ) == TRUE )
	{
		PrettyDebug( "Effect #" + IntToString( n ) + " on " + sName + " (Tag:" + sTag + ")" );
		PrintEffect( eEffect );
		n = n + 1;
		eEffect = GetNextEffect( oObject );
	}
}