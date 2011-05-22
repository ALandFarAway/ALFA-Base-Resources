// gc_dead
//
// Returns true if sCreatureTag is no longer amongst the living (or unliving)
//
// EPF 4/13/05

int StartingConditional(string sCreatureTag)
{
	return (GetIsDead(GetObjectByTag(sCreatureTag)));
}