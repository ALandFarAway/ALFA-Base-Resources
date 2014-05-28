using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ALFA.Shared
{
    public class BaseItem
    {
        [TwoDAColumn(TalkString = true)]
        public string Name;

        [TwoDAColumn(ColumnName = "EquipableSlots")]
        public string EquipableSlots;
        [TwoDAColumn(ColumnName = "WeaponType", Default = (int)0)]
        public int WeaponType;
        [TwoDAColumn(ColumnName = "WeaponSize", Default = (int)0)]
        public int WeaponSize;

        [TwoDAColumn(ColumnName = "RangedWeapon", Default = (int)-1)]
        public int AmmunitionType;

        [TwoDAColumn(ColumnName = "DieToRoll", Default = (int)0)]
        public int DieToRoll;
        [TwoDAColumn(ColumnName = "CritThreat", Default = (int)0)]
        public int CritThreat;
        [TwoDAColumn(ColumnName = "CritHitMult", Default = (int)0)]
        public int CritHitMult;

        [TwoDAColumn(ColumnName = "ReqFeat0", Default = (int)0)]
        public int ReqFeat0;
        [TwoDAColumn(ColumnName = "ReqFeat1", Default = (int)0)]
        public int ReqFeat1;
        [TwoDAColumn(ColumnName = "ReqFeat2", Default = (int)0)]
        public int ReqFeat2;
        [TwoDAColumn(ColumnName = "ReqFeat3", Default = (int)0)]
        public int ReqFeat3;
        [TwoDAColumn(ColumnName = "ReqFeat4", Default = (int)0)]
        public int ReqFeat4;
        [TwoDAColumn(ColumnName = "ReqFeat5", Default = (int)0)]
        public int ReqFeat5;

        [TwoDAColumn(ColumnName = "FEATImprCrit", Default = (int)0)]
        public int FEATImprCrit;
        [TwoDAColumn(ColumnName = "FEATWpnFocus", Default = (int)0)]
        public int FEATWpnFocus;
        [TwoDAColumn(ColumnName = "FEATWpnSpec", Default = (int)0)]
        public int FEATWpnSpec;
        [TwoDAColumn(ColumnName = "FEATGrtrWpnFocus", Default = (int)0)]
        public int FEATGrtrWpnFocus;
        [TwoDAColumn(ColumnName = "FEATGrtrWpnSpec", Default = (int)0)]
        public int FEATGrtrWpnSpec;

        public override string ToString() { return String.Format("Item: {0}, Feats: {1}, {2}, {3}, {4}, {5}, {6}, Focus: {7}", Name, ReqFeat0, ReqFeat1, ReqFeat2, ReqFeat3, ReqFeat4, ReqFeat5, FEATWpnFocus); }
    }
}
