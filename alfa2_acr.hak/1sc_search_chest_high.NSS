#include "acr_xp_i"
#include "acr_wealth_i"

void main()
{
  if(GetLocalInt(OBJECT_SELF, "LOOTED")) return;
  SetLocalInt(OBJECT_SELF, "LOOTED", 1);
  int loot = FloatToInt(ACR_CalculateMultiplier(GetLastOpenedBy()) * 50);
  int maxItem = GetMaxItemValue(ACR_GetECL(GetLastOpenedBy()));
  ACR_GenerateLoot(OBJECT_SELF, loot, maxItem);
}
