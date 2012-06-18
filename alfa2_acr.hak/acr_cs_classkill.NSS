#include "acr_skills_i"

int StartingConditional(int nSkill) {

    if (_IsClassSkill(nSkill, GetPCSpeaker())) {
	    return TRUE;
    } else {
        return FALSE;
	}

}