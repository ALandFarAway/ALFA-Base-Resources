// ga_music_set
/*
   Set background music in current area to track nTrack
   
   nTime will have the following effects:
   
   nTime = 0: Change both Day and Night tracks
   nTime = 1: Change Day track only
   nTime = 2: Change Night track only
   
   
   As of 8/23/06, this was the track indexing.  The latest can be found in ambientmusic.2da.
   
   0. NO MUSIC
   
   From NWN1:					
   ---------
   1.  rural day
   2.  rural day 2
   3.  rural night
   4.  forest day
   5.  forest day 2
   6.  forest night
   7.  generic dungeon 1
   8.  sewer
   9.  mines 1
   10. mines 2
   11. crypt 1
   12. crypt 2
   13. evil dungeon 1
   14. evil dungeon 2
   15. slums day
   16. slums night
   17. docks day
   18. docks night
   19. city wealthy
   20. city market
   21. city night
   22. tavern 1
   23. tavern 2
   24. tavern 3
   25. rich house
   26. store
   27. good temple
   28. temple evil
   29. nwn1 theme
   30. nwn chapter 1 theme
   31. nwn chapter 2 theme
   32. nwn chapter 3 theme
   33. nwn chapter 4 theme
   34. rural battle 1
   35. forest battle 1
   36. forest battle 2
   37. dungeon battle 1
   38. dungeon battle 2
   39. dungeon battle 3 (stinger)
   40. city battle 1
   41. city battle 2
   42. city battle 3
   43. city boss battle
   44. forest boss battle
   45. lizard boss battle
   46. dragon boss battle
   47. aribeth boss battle
   48. end boss battle
   49. good temple 2
   50. castle
   51. aribeth good theme
   52. aribeth evil theme
   53. arren gend theme
   54. maugrim theme
   55. morag theme
   56. tavern 4
   
   From NWN1 Expansion 1
   ---------------------
   57. desert battle
   58. desert day
   59. winter day
   60. winter battle
   61. desert night
   
   From NWN1 Expansion 2
   ---------------------
   62. x2 Theme
   63. waterdeep theme
   64. undermountain theme
   65. rebel camp 
   66. fire plane
   67. queen (?) theme
   68. frozen hell
   69. dracolich
   70. small battle
   71. medium battle
   72. large battle
   73. hell battle
   74. boss battle 1
   75. boss battle 2
   
   From NWN2
   ---------
   95.  west harbor theme
   96.  githyanki theme
   97.  githyanki battle 
   98.  west harbor blown up
   99.  swamp
   100. docks battle
   101. docks battle looped
   102. dungeon
   103. neverwinter theme
   104. neverwinter interior
   105. west harbor attack
   106. back alley
   107. king of shadows combat
   108. king of shadows theme
   109. village
   110. sunken flagon
   111. crossroad keep theme
   112. illefarn ruins theme
   113. murder
   114. ammon jerro theme
   115. back alley battle
   
       
   
*/
// EPF 8/23/06

const int TIME_BOTH = 0;
const int TIME_DAY = 1;
const int TIME_NIGHT = 2;

#include "ginc_sound"

void main(int nTrack, int nTime)
{
	object oPC = GetPCSpeaker();
	
	if(!GetIsObjectValid(oPC))
	{
		oPC = OBJECT_SELF;
	}
	object oArea = GetArea(oPC);
	
	if(nTime == TIME_BOTH || nTime == TIME_DAY)
	{
		MusicBackgroundChangeDay(oArea,nTrack);
	}
	
	if(nTime == TIME_BOTH || nTime == TIME_NIGHT)
	{
		MusicBackgroundChangeNight(oArea, nTrack);
	}
}