#ifndef ACR_LIST_I
#define ACR_LIST_I

string ACR_GetTokenAtIndex( string sList, int nIndex, string sDelim = ";" ) {
	int nStartPosition = -1;
	int nDelimLength = GetStringLength( sDelim );
	
	// Find the start of the token.
	int i;
	for ( i = 0; i < nIndex; i++ ) {
		nStartPosition = FindSubString( sList, sDelim, nStartPosition ) + nDelimLength;
		if ( nStartPosition == -1 ) return "";
	}
	
	// Get the length of the parameter.
	int nParamLength = FindSubString( sList, sDelim, nStartPosition ) - nStartPosition;
	if ( nParamLength == -1 ) nParamLength = GetStringLength( sList ) - nStartPosition;
	
	// Return.
	return GetSubString( sList, nStartPosition, nParamLength );
}

int ACR_GetTokenCount( string sList, string sDelim = ";" ) {
	int nCurrentPos = 0;
	int nCount = 0;
	int nDelimLength = GetStringLength( sDelim );
	
	if ( sDelim == "" ) return 0;
	
	while ( nCurrentPos != -1 ) {
		nCurrentPos = FindSubString( sList, sDelim, nCurrentPos ) + nDelimLength;
		nCount++;
	}
	
	return nCount;
}

// Currently unimplemented.
string ACR_SortTokens( string sList ) {
	return sList;
}

object _check_object(object o)
{
	return ((o == OBJECT_INVALID) ? GetModule() : o);
}

int _get_index(string id, object src=OBJECT_INVALID)
{
	src = _check_object(src);
	
	return GetLocalInt(src, id+"_index");
}

void _incr_index(string id, object src=OBJECT_INVALID)
{
	src = _check_object(src);
	
	SetLocalInt(src, id+"_index", GetLocalInt(src, id+"_index")+1);
}

void _incr_count(string id, int n=1, object src=OBJECT_INVALID)
{
	src = _check_object(src);
	
	SetLocalInt(src, id+"_count", GetLocalInt(src, id+"_count")+n);
}

int ACR_ListGetCount(string id, object src=OBJECT_INVALID)
{
	src = _check_object(src);
	
	return GetLocalInt(src, id+"_count");
}

int ACR_ListGetNextIndex(string id, int index, object src=OBJECT_INVALID)
{
	src = _check_object(src);
	
	return GetLocalInt(src, id+"_"+IntToString(index)+"_"+"N");
}

int ACR_ListGetPrevIndex(string id, int index, object src=OBJECT_INVALID)
{
	src = _check_object(src);
	
	return GetLocalInt(src, id+"_"+IntToString(index)+"_"+"P");
}

object ACR_ListGetElementObject(string id, int index, object src=OBJECT_INVALID)
{
	src = _check_object(src);
	
	return GetLocalObject(src, id+"_"+IntToString(index));
}

void ACR_ListSetElementObject(string id, int index, object elem, object src=OBJECT_INVALID)
{
	src = _check_object(src);
	
	SetLocalObject(src, id+"_"+IntToString(index), elem);
}

int ACR_ListInsertAfterIndex(string id, int index, object src=OBJECT_INVALID)
{
	int next, new_index;
	
	src = _check_object(src);
	
	next = ACR_ListGetNextIndex(id,index,src);
	
	_incr_count(id, 1, src);
	_incr_index(id, src);
	
	new_index = _get_index(id, src);
	
	SetLocalInt(src, id+"_"+IntToString(new_index)+"_"+"N", next);
	SetLocalInt(src, id+"_"+IntToString(new_index)+"_"+"P", index);
	
	SetLocalInt(src, id+"_"+IntToString(index)+"_"+"N", new_index);
	SetLocalInt(src, id+"_"+IntToString(next)+"_"+"P", new_index);
	
	return new_index;
}

void ACR_ListRemoveAtIndex(string id, int index, object src=OBJECT_INVALID)
{
	int next, prev;
	
	src = _check_object(src);
	
	next = ACR_ListGetNextIndex(id,index,src);
	prev = ACR_ListGetPrevIndex(id,index,src);
	
	_incr_count(id, -1, src);
	
	DeleteLocalObject(src,id+"_"+IntToString(index));
	DeleteLocalInt(src,id+"_"+IntToString(index)+"_"+"N");
	DeleteLocalInt(src,id+"_"+IntToString(index)+"_"+"P");

	SetLocalInt(src, id+"_"+IntToString(prev)+"_"+"N", next);
	SetLocalInt(src, id+"_"+IntToString(next)+"_"+"P", prev);
}

int ACR_ListGetFirstIndex(string id, object src=OBJECT_INVALID)
{
	src = _check_object(src);
	
	return 0;
}

int ACR_ListRemoveAtTail(string id, object src=OBJECT_INVALID)
{
	int tail;
	
	src = _check_object(src);
	
	tail = ACR_ListGetPrevIndex(id, ACR_ListGetFirstIndex(id, src), src);
	
	return ACR_ListInsertAfterIndex(id, tail, src);
}

int ACR_ListRemoveAtElementObject(string id, object elem, object src=OBJECT_INVALID)
{
	int i,first;
	
	src = _check_object(src);
	
	first = ACR_ListGetFirstIndex(id, src);
	i = first;
	
	do {
		i = ACR_ListGetNextIndex(id, i, src);
		if (ACR_ListGetElementObject(id, i, src) == elem) {
			ACR_ListRemoveAtIndex(id, i, src);
			return 1;
		}
		
	} while (first !=i);
	
	return 0;
}

string ACR_ListToString(string id, object src=OBJECT_INVALID)
{
	int i,first;
	string str;
	
	src = _check_object(src);
	
	first = ACR_ListGetFirstIndex(id, src);
	i = first;
	
	do {
		
		str = str + IntToString(i) + ": " + GetName(ACR_ListGetElementObject(id,i)) + ", ";
		i = ACR_ListGetNextIndex(id, i, src);
		
	} while (first !=i);
	
	return str;
}

#endif