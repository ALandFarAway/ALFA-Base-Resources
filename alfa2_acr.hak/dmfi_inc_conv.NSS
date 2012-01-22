////////////////////////////////////////////////////////////////////////////////
// zdlg_include_i - DM Friendly Initiative -  Include file for the dynamic conversation
// Original Scripter:  Demetrious      Design: DMFI Design Team
//------------------------------------------------------------------------------
// Last Modified By:   Demetrious           10/22/6
//------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////
#include "dmfi_inc_sendtex"
// This file is the work of Paul Speed.  The original files pg_lists_i and
// zdlg_include_i are now combined into this single include file.

/**
 *  $Id: zdlg_include_i.nss,v 1.2 2005/08/07 04:38:30 pspeed Exp $
 *  $Id: pg_lists_i.nss,v 1.2 2005/08/07 04:38:30 pspeed Exp $
 *
 *  Include file for using the Z-Dialog runtime conversation
 *  system and some list APIs that work with local object variables.
 *
 *  Copyright (c) 2004 Paul Speed - BSD licensed.
 *  NWN Tools - http://nwntools.sf.net/
 */
const int DLG_CONV_NUM = 27;    // plus NEXT and PREVIOUS and END gets to 30

const string LIST_PREFIX = "pgList:";

// Constants defined for dialog events
const int DLG_INIT = 0; // new dialog is started
const int DLG_PAGE_INIT = 1; // a new page is started
const int DLG_SELECTION = 2; // item is selected
const int DLG_ABORT = 3; // dialog was aborted
const int DLG_END = 4; // dialog ended normally

const string DLG_CURRENT_HANDLER = "currentDialog";
const string DLG_HANDLER = "dialog";
const string DLG_PROMPT = "zdlgPrompt";
const string DLG_RESPONSE_LIST = "zdlgResponseList";
const string DLG_RESPONSE_LIST_HOLDER = "zdlgResponseHolder";
const string DLG_EVENT_TYPE = "zdlgEventType";
const string DLG_EVENT_SELECTION = "zdlgEventSelection";
const string DLG_PAGE_ID = "zdlgPageId";
const string DLG_ITEM = "zdlgItem";
const string DLG_ITEM_CONVERSER = "zdlgConverser";
const string DLG_STATE = "zdlgState";

const string DLG_START_ENTRY = "zdlgStartEntry";
const string DLG_HAS_PREV = "zdlgHasPrevious";
const string DLG_HAS_NEXT = "zdlgHasNext";
const string DLG_HAS_END = "zdlgHasEnd";

// Some state constants that the zdlg_page_init check
// can use to determine current conversation state.
const int DLG_STATE_INIT = 0;
const int DLG_STATE_RUNNING = 1;
const int DLG_STATE_ENDED = -1;

// The base token for the dialog inserts.  +0 is the
// prompt.  +1 - +13 is the item text.  These values
// must match the .dlg file exactly.
const int DLG_BASE_TOKEN = 4200;

///// Core prototypes

// Returns the number of items in the specified list.
int GetElementCount( string list, object holder = OBJECT_SELF );

// Removes the list element at the specified index.  Returns
// the new item count.
int RemoveElement( int index, string list, object holder = OBJECT_SELF );

// Removes the list elements from start to end-1 inclusive at the
// specified index.  Returns the new item count.
int RemoveElements( int start, int end, string list, object holder = OBJECT_SELF );

// Inserts a blank entry into the specified index.  Returns
// the new item count.
int InsertElement( int index, string list, object holder = OBJECT_SELF );

// Deletes the list and all contents.  Returns the number
// of elements deleted in the process.
int DeleteList( string list, object holder = OBJECT_SELF );

///// STRING Prototypes

// Adds a string item to the list and return the new item count.
int AddStringElement( string item, string list, object holder = OBJECT_SELF );

// Returns the string item at the specified index.
string GetStringElement( int index, string list, object holder = OBJECT_SELF );

// Removes the string item from the end of the list and returns
// it.  Note: this will orphan any other types the might be stored
// at the same list location.
string PopStringElement( string list, object holder = OBJECT_SELF );

// Replaces the string at the specified index.  Returns the old
// string.
string ReplaceStringElement( int index, string value, string list, object holder = OBJECT_SELF );

// Begins a list iteration for string values
string GetFirstStringElement( string list, object holder = OBJECT_SELF );

// Returns the next item in a list iteration
string GetNextStringElement();

//// OBJECT Prototypes

// Adds an object item to the list and return the new item count.
int AddObjectElement( object item, string list, object holder = OBJECT_SELF );

// Returns the object item at the specified index.
object GetObjectElement( int index, string list, object holder = OBJECT_SELF );

// Removes the object item from the end of the list and returns
// it.  Note: this will orphan any other types the might be stored
// at the same list location.
object PopObjectElement( string list, object holder = OBJECT_SELF );

// Replaces the object at the specified index.  Returns the old
// string.
object ReplaceObjectElement( int index, object value, string list, object holder = OBJECT_SELF );

// Begins a list iteration for object values
object GetFirstObjectElement( string list, object holder = OBJECT_SELF );

// Returns the next item in an object list iteration
object GetNextObjectElement();

//// INT Prototypes

// Adds an int item to the list and return the new item count.
int AddIntElement( int item, string list, object holder = OBJECT_SELF );

// Returns the int item at the specified index.
int GetIntElement( int index, string list, object holder = OBJECT_SELF );

// Removes the int item from the end of the list and returns
// it.  Note: this will orphan any other types the might be stored
// at the same list location.
int PopIntElement( string list, object holder = OBJECT_SELF );

// Replaces the int at the specified index.  Returns the old
// int.
int ReplaceIntElement( int index, int value, string list, object holder = OBJECT_SELF );

// Begins a list iteration for int values
int GetFirstIntElement( string list, object holder = OBJECT_SELF );

// Returns the next item in a list iteration
int GetNextIntElement();

// ZDLG PROTOTYPES:

// Returns the current PC speaker for this dialog.
// This has some enhanced features to work around bioware
// limitations with item dialogs.
object GetPcDlgSpeaker();

// Sets the new current dialog handler script for the current conversation.
// This allows on the fly conversation changes and linking.  This must
// be called within a conversation related event.
void SetCurrentDlgHandlerScript( string script );

// Returns the current dialog handler script for the current conversation.
string GetCurrentDlgHandlerScript();

// Returns the current conversation's default dialog handler script if
// it has one defined.  This is used when there is otherwise
// not a current handler script set.
string GetDefaultDlgHandlerScript( object oNPC = OBJECT_SELF );

// Sets the prompt that will be displayed in the dialog
// when talking to the current speaker.
void SetDlgPrompt( string prompt );

// Returns the current prompt that will be displayed in the
// dialog when talking to the current speaker.
string GetDlgPrompt();

// Set to TRUE if the end dialog selection should be shown
// on every page.  FALSE if not.
void SetShowEndSelection( int flag );

// Returns TRUE if the end dialog selection should be shown
// on every page.  FALSE if not.
int GetShowEndSelection();

// Sets the list of responses that will be displayed in the
// dialog when talking to the current speaker.
void SetDlgResponseList( string listId, object oListHolder );

// Returns the list id for the list of responses that will be
// displayed in the dialog when talking to the current speaker.
string GetDlgResponseList();

// Returns the dialog type of event that caused the handler
// script to be executed.
int GetDlgEventType();

// Returns the selected item in a DLG_SELECTION event.
int GetDlgSelection();

// Sets a page string that the handler scripts can use to track
// progress through the conversation.  This is really just a
// convenience function that tacks a local var onto the PC dlg
// speaker.  It has the added benefit of getting auto-cleaned
// with the dialog clean-up.
void SetDlgPageString( string page );

// Returns a page string that the handler scripts can use to track
// progress through the conversation.
string GetDlgPageString();

// Sets a page integer that the handler scripts can use to track
// progress through the conversation.  This is really just a
// convenience function that tacks a local var onto the PC dlg
// speaker.  It has the added benefit of getting auto-cleaned
// with the dialog clean-up.
void SetDlgPageInt( int page );

// Returns a page integer that the handler scripts can use to track
// progress through the conversation.
int GetDlgPageInt();

// Called to initiate a conversation programmatically between
// the dialog source and the object to converse with.  If
// dlgHandler is "" then the object's default script will be used.
void StartDlg( object oPC, object oObjectToConverseWith, string dlgHandler = "", int bPrivate = FALSE, int bPlayHello = TRUE, int bNWN2Style = TRUE );

// Ends the current conversation and will fire the DLG_END event.
void EndDlg();

// ***************************** FUNCTIONS *************************************

string currentList = "";
object currentHolder = OBJECT_INVALID;
int currentCount = 0;
int currentIndex = -1;

// Internal function to get the string for a given
// index
string IndexToString( int index, string list )
{
    return( LIST_PREFIX + list + "." + IntToString(index) );
}

// Returns the number of items in the specified list.
int GetElementCount( string list, object holder = OBJECT_SELF )
{
    return( GetLocalInt( holder, LIST_PREFIX + list ) );
}

// Removes the list element at the specified index.  Returns
// the new item count.
int RemoveElement( int index, string list, object holder = OBJECT_SELF )
{
    int count = GetElementCount( list, holder );
    if( count == 0 )
        return( count );

    // Shift all of the other elements forward
    int i;
    string next;
    for( i = index; i < count - 1; i++ )
        {
        // We don't know what type the list elements are
        // (and they could be any), so we shift them all.
        // This function is already expensive enough anyway.
        string current = IndexToString( i, list );
        next = IndexToString( i + 1, list );

        SetLocalFloat( holder, current, GetLocalFloat( holder, next ) );
        SetLocalInt( holder, current, GetLocalInt( holder, next ) );
        SetLocalLocation( holder, current, GetLocalLocation( holder, next ) );
        SetLocalObject( holder, current, GetLocalObject( holder, next ) );
        SetLocalString( holder, current, GetLocalString( holder, next ) );
        }

    // Delete the top item
    DeleteLocalFloat( holder, next );
    DeleteLocalInt( holder, next );
    DeleteLocalLocation( holder, next );
    DeleteLocalObject( holder, next );
    DeleteLocalString( holder, next );

    count--;
    SetLocalInt( holder, LIST_PREFIX + list, count );

    return( count );
}

// Removes the list elements from start to end-1 inclusive at the
// specified index.  Returns the new item count.
int RemoveElements( int start, int end, string list, object holder = OBJECT_SELF )
{
    int count = GetElementCount( list, holder );
    if( count == 0 )
        return( count );

    // Shift all of the other elements forward
    int i;
    string next;
    int removeCount = end - start;
    for( i = start; i < count - removeCount; i++ )
        {
        // We don't know what type the list elements are
        // (and they could be any), so we shift them all.
        // This function is already expensive enough anyway.
        string current = IndexToString( i, list );
        next = IndexToString( i + removeCount, list );

        SetLocalFloat( holder, current, GetLocalFloat( holder, next ) );
        SetLocalInt( holder, current, GetLocalInt( holder, next ) );
        SetLocalLocation( holder, current, GetLocalLocation( holder, next ) );
        SetLocalObject( holder, current, GetLocalObject( holder, next ) );
        SetLocalString( holder, current, GetLocalString( holder, next ) );
        }

    // Delete the top items
    for( i = count - removeCount; i < count; i++ )
        {
        next = IndexToString( i, list );
        DeleteLocalFloat( holder, next );
        DeleteLocalInt( holder, next );
        DeleteLocalLocation( holder, next );
        DeleteLocalObject( holder, next );
        DeleteLocalString( holder, next );
        }

    count -= removeCount;
    SetLocalInt( holder, LIST_PREFIX + list, count );

    return( count );
}


// Inserts a blank entry into the specified index.  Returns
// the new item count.
int InsertElement( int index, string list, object holder = OBJECT_SELF )
{
    int count = GetElementCount( list, holder );

    // Shift all of the other elements backwards
    int i;
    string next;
    for( i = count - 1; i >= index; i-- )
        {
        // We don't know what type the list elements are
        // (and they could be any), so we shift them all.
        // This function is already expensive enough anyway.
        string current = IndexToString( i, list );
        next = IndexToString( i + 1, list );

        SetLocalFloat( holder, next, GetLocalFloat( holder, current ) );
        SetLocalInt( holder, next, GetLocalInt( holder, current ) );
        SetLocalLocation( holder, next, GetLocalLocation( holder, current ) );
        SetLocalObject( holder, next, GetLocalObject( holder, current ) );
        SetLocalString( holder, next, GetLocalString( holder, current ) );
        }

    // Delete the old values from the index since
    // it should be empty now
    string current = IndexToString( index, list );
    DeleteLocalFloat( holder, current );
    DeleteLocalInt( holder, current );
    DeleteLocalLocation( holder, current );
    DeleteLocalObject( holder, current );
    DeleteLocalString( holder, current );

    count++;
    SetLocalInt( holder, LIST_PREFIX + list, count );

    return( count );
}

// Deletes the list and all contents.  Returns the number
// of elements deleted in the process.
int DeleteList( string list, object holder = OBJECT_SELF )
{
    int count = GetElementCount( list, holder );
    if( count == 0 )
        return( count );

    // Delete all elements
    int i;
    for( i = 0; i < count; i++ )
        {
        string current = IndexToString( i, list );
        DeleteLocalFloat( holder, current );
        DeleteLocalInt( holder, current );
        DeleteLocalLocation( holder, current );
        DeleteLocalObject( holder, current );
        DeleteLocalString( holder, current );
        }

    // Delete the main list info
    DeleteLocalInt( holder, LIST_PREFIX + list );

    return( count );
}

///// STRING FUNCTIONS

// Adds a string item to the list and return the new item count.
int AddStringElement( string item, string list, object holder = OBJECT_SELF )
{
    int count = GetElementCount( list, holder );
    SetLocalString( holder, IndexToString( count, list ), item );
    count++;
    SetLocalInt( holder, LIST_PREFIX + list, count );

    return( count );
}

// Returns the string item at the specified index.
string GetStringElement( int index, string list, object holder = OBJECT_SELF )
{
    int count = GetElementCount( list, holder );
    if( index >= count )
        {
        PrintString( "Error: (GetStringItem) index out of bounds["
                     + IntToString(index) + "] in list:" + list );
        return( "" );
        }
    return( GetLocalString( holder, IndexToString( index, list ) ) );
}

// Removes the string item from the end of the list and returns
// it.  Note: this will orphan any other types the might be stored
// at the same list location.
string PopStringElement( string list, object holder = OBJECT_SELF )
{
    int count = GetElementCount( list, holder );
    string index = IndexToString( count - 1, list );
    string value = GetLocalString( holder, index );

    // Delete the values
    DeleteLocalString( holder, index );

    SetLocalInt( holder, LIST_PREFIX + list, count - 1 );

    return( value );
}

// Replaces the string at the specified index.  Returns the old
// string.
string ReplaceStringElement( int index, string value, string list, object holder = OBJECT_SELF )
{
    int count = GetElementCount( list, holder );
    if( index >= count )
        {
        PrintString( "Error: (ReplaceStringItem) index out of bounds[" + IntToString(index)
                     + "] in list:" + list );
        return( "" );
        }

    string original = GetLocalString( holder, IndexToString( index, list ) );
    SetLocalString( holder, IndexToString( index, list ), value );

    return( original );
}

// Begins a list iteration for string values
string GetFirstStringElement( string list, object holder = OBJECT_SELF )
{
    currentCount = GetElementCount( list, holder );
    currentIndex = 0;
    return( GetLocalString( holder, IndexToString( currentIndex++, list ) ) );
}

// Returns the next item in a list iteration
string GetNextStringElement()
{
    if( currentIndex >= currentCount )
        return( "" );
    return( GetLocalString( currentHolder, IndexToString( currentIndex++, currentList ) ) );
}

//// OBJECT FUNCTIONS

// Adds an object item to the list and return the new item count.
int AddObjectElement( object item, string list, object holder = OBJECT_SELF )
{
    int count = GetElementCount( list, holder );
    SetLocalObject( holder, IndexToString( count, list ), item );
    count++;
    SetLocalInt( holder, LIST_PREFIX + list, count );

    return( count );
}

// Returns the object item at the specified index.
object GetObjectElement( int index, string list, object holder = OBJECT_SELF )
{
    int count = GetElementCount( list, holder );
    if( index >= count )
        {
        PrintString( "Error: (GetObjectItem) index out of bounds[" + IntToString(index)
                     + "] in list:" + list );
        return( OBJECT_INVALID );
        }
    return( GetLocalObject( holder, IndexToString( index, list ) ) );
}

// Removes the object item from the end of the list and returns
// it.  Note: this will orphan any other types the might be stored
// at the same list location.
object PopObjectElement( string list, object holder = OBJECT_SELF )
{
    int count = GetElementCount( list, holder );
    string index = IndexToString( count - 1, list );
    object value = GetLocalObject( holder, index );

    // Delete the values
    DeleteLocalObject( holder, index );

    SetLocalInt( holder, LIST_PREFIX + list, count - 1 );

    return( value );
}

// Replaces the object at the specified index.  Returns the old
// string.
object ReplaceObjectElement( int index, object value, string list, object holder = OBJECT_SELF )
{
    int count = GetElementCount( list, holder );
    if( index >= count )
        {
        PrintString( "Error: (ReplaceObjectItem) index out of bounds[" + IntToString(index)
                     + "] in list:" + list );
        return( OBJECT_INVALID );
        }

    object original = GetLocalObject( holder, IndexToString( index, list ) );
    SetLocalObject( holder, IndexToString( index, list ), value );

    return( original );
}

// Begins a list iteration for object values
object GetFirstObjectElement( string list, object holder = OBJECT_SELF )
{
    currentList = list;
    currentHolder = holder;
    currentCount = GetElementCount( list, holder );
    currentIndex = 0;
    return( GetLocalObject( holder, IndexToString( currentIndex++, list ) ) );
}

// Returns the next item in an object list iteration
object GetNextObjectElement()
{
    if( currentIndex >= currentCount )
        return( OBJECT_INVALID );
    return( GetLocalObject( currentHolder, IndexToString( currentIndex++, currentList ) ) );
}

//// INT FUNCTIONS

// Adds an int item to the list and return the new item count.
int AddIntElement( int item, string list, object holder = OBJECT_SELF )
{
    int count = GetElementCount( list, holder );
    SetLocalInt( holder, IndexToString( count, list ), item );
    count++;
    SetLocalInt( holder, LIST_PREFIX + list, count );

    return( count );
}

// Returns the int item at the specified index.
int GetIntElement( int index, string list, object holder = OBJECT_SELF )
{
    int count = GetElementCount( list, holder );
    if( index >= count )
        {
        PrintString( "Error: (GetIntItem) index out of bounds[" + IntToString(index)
                     + "] in list:" + list );
        return( -1 );
        }
    return( GetLocalInt( holder, IndexToString( index, list ) ) );
}

// Removes the int item from the end of the list and returns
// it.  Note: this will orphan any other types the might be stored
// at the same list location.
int PopIntElement( string list, object holder = OBJECT_SELF )
{
    int count = GetElementCount( list, holder );
    string index = IndexToString( count - 1, list );
    int value = GetLocalInt( holder, index );

    // Delete the values
    DeleteLocalInt( holder, index );

    SetLocalInt( holder, LIST_PREFIX + list, count - 1 );

    return( value );
}

// Replaces the int at the specified index.  Returns the old
// int.
int ReplaceIntElement( int index, int value, string list, object holder = OBJECT_SELF )
{
    int count = GetElementCount( list, holder );
    if( index >= count )
        {
        PrintString( "Error: (ReplaceIntItem) index out of bounds[" + IntToString(index)
                     + "] in list:" + list );
        return( -1 );
        }

    int original = GetLocalInt( holder, IndexToString( index, list ) );
    SetLocalInt( holder, IndexToString( index, list ), value );

    return( original );
}

// Begins a list iteration for int values
int GetFirstIntElement( string list, object holder = OBJECT_SELF )
{
    currentCount = GetElementCount( list, holder );
    currentIndex = 0;
    return( GetLocalInt( holder, IndexToString( currentIndex++, list ) ) );
}

// Returns the next item in a list iteration
int GetNextIntElement()
{
    if( currentIndex >= currentCount )
        return( -1 );
    return( GetLocalInt( currentHolder, IndexToString( currentIndex++, currentList ) ) );
}

// Returns the current PC speaker for this dialog.
// This has some enhanced features to work around bioware
// limitations with item dialogs.
object GetPcDlgSpeaker()
{
    object oPC = GetPCSpeaker();
    if( oPC == OBJECT_INVALID )
        {
        // See if we're an item and if we're connected to a PC already.
        // Note: GetItemActivator won't work in multiplayer because other
        //       players will be trouncing on its state.
        oPC = GetLocalObject( OBJECT_SELF, DLG_ITEM_CONVERSER );
        }
    if( oPC == OBJECT_INVALID )
        PrintString( "WARNING: Unable to retrieve a PC speaker." );
    return( oPC );
}

// Sets the new current dialog handler script for the current conversation.
// This allows on the fly conversation changes and linking.  This must
// be called within a conversation related event.
void SetCurrentDlgHandlerScript( string script )
{
    SetLocalString( GetPcDlgSpeaker(), DLG_CURRENT_HANDLER, script );
}

// Returns the current dialog handler script for the current conversation.
string GetCurrentDlgHandlerScript()
{
    return( GetLocalString( GetPcDlgSpeaker(), DLG_CURRENT_HANDLER ) );
}

// Returns the current conversation's default dialog handler script if
// it has one defined.  This is used when there is otherwise
// not a current handler script set.
string GetDefaultDlgHandlerScript( object oNPC = OBJECT_SELF )
{
    return( GetLocalString( oNPC, DLG_HANDLER ) );
}

// Sets the prompt that will be displayed in the dialog
// when talking to the current speaker.
void SetDlgPrompt( string prompt )
{
    SetLocalString( GetPcDlgSpeaker(), DLG_PROMPT, prompt );
}

// Returns the current prompt that will be displayed in the
// dialog when talking to the current speaker.
string GetDlgPrompt()
{
    return( GetLocalString( GetPcDlgSpeaker(), DLG_PROMPT ) );
}

// Set to TRUE if the end dialog selection should be shown
// on every page.  FALSE if not.
void SetShowEndSelection( int flag )
{
    SetLocalInt( GetPcDlgSpeaker(), DLG_HAS_END, flag );
}

// Returns TRUE if the end dialog selection should be shown
// on every page.  FALSE if not.
int GetShowEndSelection()
{
    return( GetLocalInt( GetPcDlgSpeaker(), DLG_HAS_END ) );
}

// Sets the list of responses that will be displayed in the
// dialog when talking to the current speaker.
void SetDlgResponseList( string listId, object oListHolder )
{
    object oSpeaker = GetPcDlgSpeaker();
    SetLocalObject( oSpeaker, DLG_RESPONSE_LIST_HOLDER, oListHolder );
    SetLocalString( oSpeaker, DLG_RESPONSE_LIST, listId );
}

// Returns the list id for the list of responses that will be
// displayed in the dialog when talking to the current speaker.
string GetDlgResponseList()
{
    return( GetLocalString( GetPcDlgSpeaker(), DLG_RESPONSE_LIST ) );
}

// Returns the dialog type of event that caused the handler
// script to be executed.
int GetDlgEventType()
{
    return( GetLocalInt( GetPcDlgSpeaker(), DLG_EVENT_TYPE ) );
}

// Returns the selected item in a DLG_SELECTION event.
int GetDlgSelection()
{
    return( GetLocalInt( GetPcDlgSpeaker(), DLG_EVENT_SELECTION ) );
}

// Sets a page string that the scripts can use to track
// progress through the conversation.
void SetDlgPageString( string page )
{
    SetLocalString( GetPcDlgSpeaker(), DLG_PAGE_ID, page );
}

// Returns a page string that the scripts can use to track
// progress through the conversation.
string GetDlgPageString()
{
    return( GetLocalString( GetPcDlgSpeaker(), DLG_PAGE_ID ) );
}

// Sets a page string that the scripts can use to track
// progress through the conversation.
void SetDlgPageInt( int page )
{
    SetLocalInt( GetPcDlgSpeaker(), DLG_PAGE_ID, page );
}

// Returns a page string that the scripts can use to track
// progress through the conversation.
int GetDlgPageInt()
{
    return( GetLocalInt( GetPcDlgSpeaker(), DLG_PAGE_ID ) );
}

// Called to initiate a conversation programmatically between
// the dialog source and the object to converse with.  If
// dlgHandler is "" then the object's default script will be used.
// EDIT BY Demetrious:  Changed bZoom to NWN1 or NWN2 style because
// zoom has no effect anyway on a NWN2 style conversation.
void StartDlg( object oPC, object oObjectToConverseWith, string dlgHandler = "",
               int bPrivate = FALSE, int bPlayHello = TRUE, int bNWN2Style = TRUE )
{
    string dlg;
	// Setup the conversation
    if( dlgHandler != "" )
        SetLocalString( oPC, DLG_CURRENT_HANDLER, dlgHandler );

    if( GetObjectType( oObjectToConverseWith ) == OBJECT_TYPE_ITEM )
        {
        // We presume that only one player can talk to an item at
        // a time... we could check, but we don't.
        SetLocalObject( oObjectToConverseWith, DLG_ITEM_CONVERSER, oPC );

        // We can't actually talk to items so we fudge it.
        SetLocalObject( oPC, DLG_ITEM, oObjectToConverseWith );
        oObjectToConverseWith = oPC;
        }
    
    if( bNWN2Style )
        dlg = "dmfi_conv2";
	else
		dlg = "dmfi_conv";	

    AssignCommand( oObjectToConverseWith,
                   ActionStartConversation( oPC, dlg, bPrivate, bPlayHello ) );
}

// Ends the current conversation and will fire the DLG_END event.
void EndDlg()
{
    object oSpeaker = GetPcDlgSpeaker();
    SetLocalInt( oSpeaker, DLG_STATE, DLG_STATE_ENDED );
}

// Returns the number of responses that will be displayed
// in the dialog when talking to the specified speaker.
// The speaker can be specified for looping optimization
// so that the functions don't have to retrieve it every time.
int GetDlgResponseCount( object oSpeaker )
{
    object oHolder = GetLocalObject( oSpeaker, DLG_RESPONSE_LIST_HOLDER );
    string listId = GetLocalString( oSpeaker, DLG_RESPONSE_LIST );
    return( GetElementCount( listId, oHolder ) );
}

// Returns the response string for the specified entry.
// The speaker can be specified for looping optimization
// so that the functions don't have to retrieve it every time.
string GetDlgResponse( int num, object oSpeaker )
{
    object oHolder = GetLocalObject( oSpeaker, DLG_RESPONSE_LIST_HOLDER );
    string listId = GetLocalString( oSpeaker, DLG_RESPONSE_LIST );
    return( GetStringElement( num, listId, oHolder ) );
}

// Sets up the previous/next buttons
void _SetDlgPreviousNext( object oSpeaker, int hasPrevious, int hasNext )
{
    SetLocalInt( oSpeaker, DLG_HAS_PREV, hasPrevious );
    SetLocalInt( oSpeaker, DLG_HAS_NEXT, hasNext );
}

// Returns true if the "previous" entry is turned on in the
// response list
int _HasDlgPrevious( object oSpeaker )
{
    return( GetLocalInt( oSpeaker, DLG_HAS_PREV ) );
}

// Returns true if the "next" entry is turned on in the
// response list
int _HasDlgNext( object oSpeaker )
{
    return( GetLocalInt( oSpeaker, DLG_HAS_NEXT ) );
}

// Returns true if the "end" entry is turned on in the
// response list
int _HasDlgEnd( object oSpeaker )
{
    return( GetLocalInt( oSpeaker, DLG_HAS_END ) );
}

// Sets the starting entry for when a response list is
// broken into multiple pages.
void _SetDlgFirstResponse( object oSpeaker, int start )
{
    SetLocalInt( oSpeaker, DLG_START_ENTRY, start );
}

// Returns the starting entry for when a response list is
// broken into multiple pages.
int _GetDlgFirstResponse( object oSpeaker )
{
    return( GetLocalInt( oSpeaker, DLG_START_ENTRY ) );
}

// Sets the token for the response string and returns true
// if there is a valid response entry for the specified num.
int _SetupDlgResponse( int num, object oSpeaker )
{
    int nPage = GetLocalInt(oSpeaker, "dlg_num");
	if (nPage==0)
		nPage = DLG_CONV_NUM;

	int hasNext = _HasDlgNext( oSpeaker );
    int hasPrev = _HasDlgPrevious( oSpeaker );
    int hasEnd = _HasDlgEnd( oSpeaker );
    if( (hasNext || hasPrev || hasEnd) && num >= nPage )
        {
        if( hasNext && num == nPage )
            {
            SetCustomToken( DLG_BASE_TOKEN + nPage+1, "Next" );
            return( TRUE );
            }
        if( hasPrev && num == nPage+1 )
            {
            SetCustomToken( DLG_BASE_TOKEN + nPage+2, "Previous" );
            return( TRUE );
            }
        if( hasEnd && num == nPage+2 )
            {
            SetCustomToken( DLG_BASE_TOKEN + nPage+3, "End" );
            return( TRUE );
            }
        return( FALSE );
        }

    int i = _GetDlgFirstResponse( oSpeaker ) + num;
    int count = GetDlgResponseCount( oSpeaker );
    if( i < count )
        {
        string response = GetDlgResponse( i, oSpeaker );
        SetCustomToken( DLG_BASE_TOKEN + num + 1, response );
        return( TRUE );
        }
    return( FALSE );
}

// Called to clean-up the current conversation related
// resources.
void _CleanupDlg( object oSpeaker )
{
    // See if the PC was associated with an item
    object oItem = GetLocalObject( oSpeaker, DLG_ITEM );
    if( oItem != OBJECT_INVALID )
        {
        DeleteLocalObject( oItem, DLG_ITEM_CONVERSER );
        }

    DeleteLocalInt( oSpeaker, DLG_STATE );
    DeleteLocalObject( oSpeaker, DLG_RESPONSE_LIST_HOLDER );
    DeleteLocalString( oSpeaker, DLG_RESPONSE_LIST );
    DeleteLocalString( oSpeaker, DLG_PROMPT );
    DeleteLocalString( oSpeaker, DLG_CURRENT_HANDLER );
    DeleteLocalInt( oSpeaker, DLG_PAGE_ID );
    DeleteLocalString( oSpeaker, DLG_PAGE_ID );
    DeleteLocalObject( oSpeaker, DLG_ITEM );
    DeleteLocalInt( oSpeaker, DLG_HAS_PREV );
    DeleteLocalInt( oSpeaker, DLG_HAS_NEXT );
    DeleteLocalInt( oSpeaker, DLG_HAS_END );
    DeleteLocalInt( oSpeaker, DLG_START_ENTRY );
}

// Sends the specified dialog event to the specified NPC
// using the current script handler.  The selection parameter
// is used for select events.  The speaker is provided for
// event specific paramaters to be stored onto.
void _SendDlgEvent( object oSpeaker, int dlgEvent, int selection = -1, object oNPC = OBJECT_SELF )
{
    string dlg = GetCurrentDlgHandlerScript();
    if( oNPC == oSpeaker )
        oNPC = GetLocalObject( oSpeaker, DLG_ITEM );

    SetLocalInt( oSpeaker, DLG_EVENT_TYPE, dlgEvent );
    SetLocalInt( oSpeaker, DLG_EVENT_SELECTION, selection );
    ExecuteScript( dlg, oNPC );
    DeleteLocalInt( oSpeaker, DLG_EVENT_TYPE );
    DeleteLocalInt( oSpeaker, DLG_EVENT_SELECTION );
}

void _DoDlgSelection( object oSpeaker, int selection, object oNPC = OBJECT_SELF )
{
    int nPage = GetLocalInt(oSpeaker, "dlg_num");
    if (nPage==0)
		nPage = DLG_CONV_NUM;
	// Check to see if this is one or our internal events
    int first = _GetDlgFirstResponse( oSpeaker );

    if (selection==nPage)
	{
		if (_HasDlgNext(oSpeaker))
		{
			_SetDlgFirstResponse(oSpeaker, first + nPage);
			return;
		}
	}
	else if (selection==nPage+1)
	{	
		if( _HasDlgPrevious( oSpeaker ) )
        {
        	_SetDlgFirstResponse( oSpeaker, first - nPage );
            return;
        }
	}					
	else if (selection==nPage+2)
	{
		if( _HasDlgEnd( oSpeaker ) )
        {
        	EndDlg();
            return;
        }
    }

    selection += first;
    _SendDlgEvent( oSpeaker, DLG_SELECTION, selection, oNPC );
}

// Returns the current conversation state.
int _GetDlgState( object oSpeaker )
{
    return( GetLocalInt( oSpeaker, DLG_STATE ) );
}

// Called by the dialog internals to initialize the page
// and possibly the conversation
void _InitializePage( object oSpeaker, object oNPC = OBJECT_SELF )
{
    int state = GetLocalInt( oSpeaker, DLG_STATE );
    string dlg = GetCurrentDlgHandlerScript();
    if( oNPC == oSpeaker )
        oNPC = GetLocalObject( oSpeaker, DLG_ITEM );

    // See if the NPC has a dialog file defined
    if( dlg == "" )
        {
        // Try to see if they have a default defined
        dlg = GetDefaultDlgHandlerScript( oNPC );
        SetCurrentDlgHandlerScript( dlg );
        state = 0;
        }

    // If we aren't initialized
    if( state == DLG_STATE_INIT )
        {
        // Then we'll send the conversation init event
        _SendDlgEvent( oSpeaker, DLG_INIT, -1, oNPC );
        SetLocalInt( oSpeaker, DLG_STATE, DLG_STATE_RUNNING );
        }

    // Send the page initialization event
    _SendDlgEvent( oSpeaker, DLG_PAGE_INIT, -1, oNPC );
}


// ConfigureConv				FILE: dmfi_inc_conv
// Purpose:  Configures basic conversation data for Custom Token Dialog System.
// sStartPage is the name of the page where the conversation begins - it does NOT create this page.
// oHolder is where the conversation data is held - OBJECT_SELF or oSpeaker are most common.  If
// you are holding oSpeaker information (ie PCs inventory), oSpeaker is a good place to store the datat.
// nNum is the maximun number of entries to show per page - NOTE: Will NOT limit sStartPage - affects
// all other pages.  nShowEnd - Should every page show an option to END the conversation.  sAbort and 
// sGoodbye are the strings spoken by OBJECT_SELF if the conversation is ABORTED or ENEDED.
void ConfigureConv(string sStartPage, object oHolder, int nNum=0, int nShowEnd=FALSE, string sAbort="", string sGoodbye="")
{
	string sTest = GetDlgPageString();
	if (sTest=="")
			SetDlgPageString(sStartPage);
	
	object oSpeaker = GetPcDlgSpeaker();
	SetLocalObject(OBJECT_SELF, "DLG_HOLDER", oHolder);
	
	if (nNum==0)	nNum = DLG_CONV_NUM;
	if (nNum>27)	nNum =27;
	SetLocalInt(oSpeaker, "dlg_num", nNum);
	
	SetShowEndSelection(nShowEnd);
	SetLocalString(OBJECT_SELF, "DLG_ABORT", sAbort);
	SetLocalString(OBJECT_SELF, "DLG_END", sGoodbye);
}

// StaticPage					FILE: dmfi_inc_conv
// PURPOSE: Creates a static page with name sPage.  sPrompt is the OBJECT_SELF (NPC) line.  nColor  
// is a COLOR constant.
void StaticPage(string sPage, string sPrompt, int nColor=-1)
{
	if (nColor!=-1) sPrompt = ColorText(sPrompt, nColor);
	
	SetLocalString(OBJECT_SELF, sPage + "PROMPT", sPrompt);
	SetLocalString(OBJECT_SELF, "DLG_CURRENT_PAGE", sPage);
}	

// DynamicPage					FILE: dmfi_inc_conv
// PURPOSE: Creates a dynamic page with name sPage.  sPrompt is the OBJECT_SELF (NPC) line.  nColor 
// is a COLOR constant.
void DynamicPage(string sPage, string sPrompt, int nColor=-1)
{
	object oHolder = GetLocalObject(OBJECT_SELF, "DLG_HOLDER");
	SetLocalInt(oHolder, "DLG_REFRESH" + sPage, 1);
	DeleteList(sPage, oHolder);
	
	if (nColor!=-1) sPrompt = ColorText(sPrompt, nColor);
	
	SetLocalString(OBJECT_SELF, sPage + "PROMPT", sPrompt);
	SetLocalString(OBJECT_SELF, "DLG_CURRENT_PAGE", sPage);
}

// AddReply						FILE: dmfi_inc_conv
// PURPOSE: Adds a reply to the last StaticPage or DynamicPage.  sTargetPage is the
// page where selecting this reply will take you.  nColor is a COLOR constant.
void AddReply(string sReply, string sTargetPage="", int nColor=-1)
{
	string sPage;
	object oHolder = GetLocalObject(OBJECT_SELF, "DLG_HOLDER");
	
	if (nColor!=-1) sReply = ColorText(sReply, nColor);
	
	sPage = GetLocalString(OBJECT_SELF, "DLG_CURRENT_PAGE");
	AddStringElement(sReply, sPage, oHolder);
	AddStringElement(sTargetPage, sPage + "TARGET_PAGE", oHolder);
}	

// AddReplyLinkInt				FILE: dmfi_inc_conv
// PURPOSE: Adds a reply to the last StaticPage or DynamicPage and links an integer
// to that particular entries that can be accessed via GetElementInt().  sTargetPage is the
// page where selecting this reply will take you.  nColor is a COLOR constant.
void AddReplyLinkInt(string sReply, string sTargetPage="", int nColor=-1, int nLink=0)
{
	int n;
	string sPage;
	object oHolder = GetLocalObject(OBJECT_SELF, "DLG_HOLDER");
	if (nColor!=-1) sReply = ColorText(sReply, nColor);
	
	sPage = GetLocalString(OBJECT_SELF, "DLG_CURRENT_PAGE");
	n = AddStringElement(sReply, sPage, oHolder);
	ReplaceIntElement(n-1, nLink, sPage, oHolder);
	AddStringElement(sTargetPage, sPage + "TARGET_PAGE", oHolder);
}	

// AddReplyLinkObject			FILE: dmfi_inc_conv
// PURPOSE: Adds a reply to the last StaticPage or DynamicPage and links an object
// to that particular entries that can be accessed via GetElementObject().  sTargetPage is the
// page where selecting this reply will take you.  nColor is a COLOR constant.
void AddReplyLinkObject(string sReply, string sTargetPage="", int nColor=-1, object oLink=OBJECT_INVALID)
{
	int n;
	string sPage;
	object oHolder = GetLocalObject(OBJECT_SELF, "DLG_HOLDER");
	if (nColor!=-1) sReply = ColorText(sReply, nColor);
	
	sPage = GetLocalString(OBJECT_SELF, "DLG_CURRENT_PAGE");
	n = AddStringElement(sReply, sPage, oHolder);
	ReplaceObjectElement(n-1, oLink, sPage, oHolder);
	AddStringElement(sTargetPage, sPage + "TARGET_PAGE", oHolder);
}	

// UseReplyPage					FILE: dmfi_inc_conv
// PURPOSE: Rather than adding individual replies, this function assigns a page to use a set of replies
// from another page.  Prevents you from duplicating responses if they are common.
// USE:  Will assign last created page to use sString page's replies.
void UseReplyPage(string sString)
{
	string sPage = GetLocalString(OBJECT_SELF, "DLG_CURRENT_PAGE");
	SetLocalString(OBJECT_SELF, sPage + "DLG_REPLY_PAGE", sString);
}	

//void main(){}
