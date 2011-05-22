//::///////////////////////////////////////////////////////////////////////////
//::
//::	gai_ignore_dcr
//::
//::	Determine Combat Round for the Spell Queue AI.
//::
//::        Spell Queue AI's will cast spells form an ordered list attached to them.
//::		To Attach a list, use the function ******, the conversation script ******,
//::		or manually using these variables (must be done pre-spawn) *******.
//::
//::///////////////////////////////////////////////////////////////////////////
// DBR 1/30/06

#include "ginc_ai"


void main()
{
    object oIntruder = GetCreatureOverrideAIScriptTarget();
    ClearCreatureOverrideAIScriptTarget(); //Handling Determine Combat round red tape
	
	SetCreatureOverrideAIScriptFinished();//Tell Determine Combat Round That I handled things.
}