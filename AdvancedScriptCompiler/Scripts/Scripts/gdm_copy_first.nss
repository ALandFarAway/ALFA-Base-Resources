// gdm_copy_first 
/* 
   copy the first item in player's inventory. 

   This script for use in normal conversation 
*/ 
// ChazM 12/30/05 
void main() 
{ 
   object oPC = GetPCSpeaker(); 
   object oItem = GetFirstItemInInventory(oPC); 
   if (!GetIsObjectValid(oItem)) 
   { 
       SpeakString("Item not found in inventory."); 
       return; 
   } 
   object oNewItem = CopyItem(oItem, oPC, TRUE); 
   if (!GetIsObjectValid(oNewItem)) 
   { 
       SpeakString("Item failed to copy."); 
       return; 
   } 
} 