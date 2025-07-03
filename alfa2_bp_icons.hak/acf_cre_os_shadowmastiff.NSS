// Created by Riotnrrd for ALFA 8/2012

#include "acr_creature_i"

void main()
{
    ACR_CreatureOnSpawnIn();

	ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectConcealment(50)), OBJECT_SELF);

}