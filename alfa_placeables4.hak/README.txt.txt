Huge Caves Tileset - Version 1.0
================================

The following files are a modified version of the normal cave tileset released with the game. They are scaled to nearly 5 times the normal height to allow for large creatures and objects to be placed inside of them.

Contents of this README
-----------------------
- Installation Instructions
- Known Bugs
- Missing Tiles
- Planned Improvements

Installation Instructions
-------------------------

Place all the files into your override directory.

Using a TLK editor add eight entries to the dialog.tlk in your games directory, add one for the Huge_Caves tileset, and one for Huge_Caves_Tileset_Door, the last 6 entries are for the metatiles, name these TL_HC_M0202_Hcurv_01, TL_HC_M0202_Hcurv_02, TL_HC_M0202_Hfork_01, TL_HC_M0202_Hfork_02, TL_HC_M0202_Hnook_01, TL_HC_M0202_Crnr_01. Please backup your original dialog.tlk file before making any changes, and note down the entry slot numbers you use for these entries you'll need them soon.

Load up the Toolset and goto View section of the menu and select 2DA's. Open the placeables.2da and add a row. Place the following values into that new row. The second entry which has ####### denoting it should be replaced with the value you used for the Huge_Caves_Tileset_Door in your tlk file.

CliffsNCaveEntrance02         ####### 0                  0    PLC_NL_CAVEENT02      ****         0               ****             ****                PLC_DN_CAVEENT1    ****             0           RESERVED          ****       ****         ****         ****         ****         ****       ****    ****    ****       ****        0        ****  

Save this new placeables.2da and load up the Tilesets.2da and add another row. Add the following values to this row, but use the Value you used in the TLK in place of the ######'s.

Huge_Caves        ######     HC 

Save that 2da and load up the tiles.2da, add 40 new rows to this 2da set. The easiest way to add the necessary entries is to find the Cave entries already in the Tiles.2da, they will have CV value as the third entry. Highlight and copy all of these entries and paste them into the new rows you have created.
Now simply change the 3rd entry values of CV to HC.

Note you will be missing 1 entry, the default tiles.2da does not contain an entry for the roof tile which does exist, if you want to use the roof tile to fill in gaps on your areas you will need to copy a roof entry from the Standard Interior Tile entries denoted with SI and replace the SI with HC.

Also note that the Hall_End_1_Door_Variant row of the cave tileset is inaccurate there are 2 variants not 1, so change the last value into 2 instead of 1.

Save the 2da and open up Metatiles.2da, add 6 new rows to this 2da. There should be 8 but the HDiag tiles have some issues I have not been able to fix yet. If you add those blank spaces will appear where they should be in the list.

Now copy all the standard TL_CVM0202_ entries already in the list that have StrRef values in 2nd entry slot and not ****, also do not copy the HDiag entries as those do not exist either. Paste those values into the 6 new rows you created and change the second Value which is the StrRef for that metatile Label to the ones you created in the TLK editing process, and also change any CV value to be HC instead.

Save the metatile.2da and exit the toolset.

Now restart the toolset and you should see a new Tile section called Huge_Caves, and new Metatile entries listed under Huge_Caves. Your ready to start creating your huge caves areas.

Known Bugs
----------

- Doors currently are not functioning for me properly, the hook-points are unchanged but something in the remodelling process seems to have broken them. I'll try to fix this, but really its not a big worry to me as I personally feel this system works better as a natural cave system and natural caves do not have doors in them. So I'm thinking I might just either totally removed the wood door structures and go with a simple always open cave passage, or remove those door frames and provide various types of door frame placeable types that could be fitted in their place instead offering variation to what type of doorway the cave builder wants to be there. But first I need to figure out what broke the doors in the first place.

- Textures look stretched, another thing that isn't a huge concern at this point, new textures can be put in to replace them but until a design is made on the doors and they are either fixed or reworked there is no point in doing in any new texture work. My caves are very dark so the stretching is not terribly noticeable anyways.

- I removed all instances of Rocky Rubble overlay's which can be seen in some of the cave normal tiles, and most of the metatiles. I did not find them very asthetically pleasing to the eye and had issues with getting them to properly merge with the floor textures, they looked much lower resolution then the normal floor imo, so I opted to simply remove these for now. No big loss imo.

Missing Tiles
-------------

- There are no Stairs Up/Down. The increased height of the tiles and the limited wifth and length makes any stairs very vertical. I think a better solution then making the stairs shallow again would be to create metatile stair tiles that allow for appropriate stairs but do so with a more gradual slope.

- The diagonal metatiles continue to have wierd results after being rescaled. I will try to work these out and release them later on, but two missing metatiles is not a big loss to the overall set as a whole.

Planned Improvements
--------------------

- Fixing the known issues
- Adding more metatiles for variation of height, possibly drop-offs, ravines, and ceiling and floor variations.
- New walls or doorways that provide higer and wider openings in them for larger creatures to be able to move through the caves.
- Narrow passage ways where movement is more restricted.

If you find any graphic glitces or any other bugs not already known please let me know what they are and in which tiles you found them and I'll do my best to fix the issue.

Hope you enjoy the Huge Caves.
Demarii' Maerynar
