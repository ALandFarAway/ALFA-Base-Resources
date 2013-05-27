using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Resources;
using System.Text;
using System.Drawing;
using System.Windows.Forms;

namespace AdvancedLogParser
{
    class CharacterDetails: Form
    {
        const int leftColumn = 5;
        const int rightColumn = 100;
        Label classLabel = new Label();
        Label classValue = new Label();
        Label alignment = new Label();

        Label wealthLabel = new Label();
        Label wealthValue = new Label();
        Label deityLabel = new Label();
        Label deityValue = new Label();

        Label strengthLabel = new Label();
        Label strengthValue = new Label();
        Label dexterityLabel = new Label();
        Label dexterityValue = new Label();
        Label constitutionLabel = new Label();
        Label constitutionValue = new Label();
        Label intelligenceLabel = new Label();
        Label intelligenceValue = new Label();
        Label wisdomLabel = new Label();
        Label wisdomValue = new Label();
        Label charismaLabel = new Label();
        Label charismaValue = new Label();

        public CharacterDetails(Character character)
        {
            this.Name = character.Name;
            this.Text = character.Name;

            if (character.Morals >= 70)
            {
                if(character.Ethics >= 70) alignment.Text = "Lawful Good";
                else if(character.Ethics >= 31) alignment.Text = "Neutral Good";
                else alignment.Text = "Chaotic Good";
            }
            else if (character.Morals >= 31)
            {
                if (character.Ethics >= 70) alignment.Text = "Lawful Neutral";
                else if (character.Ethics >= 31) alignment.Text = "True Neutral";
                else alignment.Text = "Chaotic Neutral";
            }
            else
            {
                if (character.Ethics >= 70) alignment.Text = "Lawful Evil";
                else if (character.Ethics >= 31) alignment.Text = "Neutral Evil";
                else alignment.Text = "Chaotic Evil";
            }
            alignment.Text += " " + SubraceToString(character.SubRace);
            alignment.Size = alignment.PreferredSize;
            alignment.Location = new Point(leftColumn, 5);

            classLabel.Text = "Class:";
            classLabel.Size = classLabel.PreferredSize;
            classLabel.Location = new Point(leftColumn, alignment.Location.Y + alignment.Height);

            string classes = PlayerDetails.ClassToAbbreviation(character.Class1) + character.Level1;
            if (character.Class2 < 255)
            {
                classes += "/" + PlayerDetails.ClassToAbbreviation(character.Class2) + character.Level2;
            }
            if (character.Class3 < 255)
            {
                classes += "/" + PlayerDetails.ClassToAbbreviation(character.Class3) + character.Level3;
            }
            classes += String.Format("({0} XP)", character.XP);
            classValue.Text = classes;
            classValue.Size = classValue.PreferredSize;
            classValue.Location = new Point(rightColumn, classLabel.Location.Y);

            wealthLabel.Text = "Wealth";
            wealthLabel.Size = wealthLabel.PreferredSize;
            wealthLabel.Location = new Point(leftColumn, classLabel.Location.Y + classLabel.Height);

            WealthLevel lvl = InfoGather.GetWealthLevel(character);
            switch (lvl)
            {
                case WealthLevel.VeryPoor:
                    wealthValue.Text = String.Format("Very Poor ({0})", character.Wealth);
                    wealthValue.ForeColor = Color.Red;
                    wealthValue.BackColor = Color.Yellow;
                    break;
                case WealthLevel.Poor:
                    wealthValue.Text = String.Format("Poor ({0})", character.Wealth);
                    break;
                case WealthLevel.Target:
                    wealthValue.Text = String.Format("Near Target ({0})", character.Wealth);
                    break;
                case WealthLevel.Rich:
                    wealthValue.Text = String.Format("Rich ({0})", character.Wealth);
                    break;
                case WealthLevel.VeryRich:
                    wealthValue.Text = String.Format("Very Rich ({0})", character.Wealth);
                    break;
                case WealthLevel.Cutoff:
                    wealthValue.Text = String.Format("Cutoff ({0})", character.Wealth);
                    wealthValue.ForeColor = Color.Red;
                    wealthValue.BackColor = Color.Yellow;
                    break;
            }
            wealthValue.Size = wealthValue.PreferredSize;
            wealthValue.Location = new Point(rightColumn, wealthLabel.Location.Y);

            deityLabel.Text = "Deity:";
            deityLabel.Size = deityLabel.PreferredSize;
            deityLabel.Location = new Point(leftColumn, wealthLabel.Location.Y + wealthLabel.Height);

            deityValue.Text = character.Deity;
            deityValue.Size = deityValue.PreferredSize;
            deityValue.Location = new Point(rightColumn, deityLabel.Location.Y);

            strengthLabel.Text = "Strength:";
            strengthLabel.Size = strengthLabel.PreferredSize;
            strengthLabel.Location = new Point(leftColumn, deityLabel.Location.Y + deityLabel.Height);

            if (character.Strength >= 10)
            {
                strengthValue.Text = String.Format("{0} (+{1})", character.Strength, ((int)character.Strength - 10) / 2);
            }
            else
            {
                strengthValue.Text = String.Format("{0} ({1})", character.Strength, ((int)character.Strength - 10) / 2);
            }
            strengthValue.Size = strengthValue.PreferredSize;
            strengthValue.Location = new Point(rightColumn, strengthLabel.Location.Y);

            dexterityLabel.Text = "Dexterity:";
            dexterityLabel.Size = dexterityLabel.PreferredSize;
            dexterityLabel.Location = new Point(leftColumn, strengthLabel.Location.Y + strengthLabel.Height);

            if (character.Dexterity >= 10)
            {
                dexterityValue.Text = String.Format("{0} (+{1})", character.Dexterity, ((int)character.Dexterity - 10) / 2);
            }
            else
            {
                dexterityValue.Text = String.Format("{0} ({1})", character.Dexterity, ((int)character.Dexterity - 10) / 2);
            }
            dexterityValue.Size = dexterityValue.PreferredSize;
            dexterityValue.Location = new Point(rightColumn, dexterityLabel.Location.Y);

            constitutionLabel.Text = "Constitution:";
            constitutionLabel.Size = constitutionLabel.PreferredSize;
            constitutionLabel.Location = new Point(leftColumn, dexterityLabel.Location.Y + dexterityLabel.Height);

            if (character.Constitution >= 10)
            {
                constitutionValue.Text = String.Format("{0} (+{1})", character.Constitution, ((int)character.Constitution - 10) / 2);
            }
            else
            {
                constitutionValue.Text = String.Format("{0} ({1})", character.Constitution, ((int)character.Constitution - 10) / 2);
            }
            constitutionValue.Size = constitutionValue.PreferredSize;
            constitutionValue.Location = new Point(rightColumn, constitutionLabel.Location.Y);

            intelligenceLabel.Text = "Intelligence:";
            intelligenceLabel.Size = intelligenceLabel.PreferredSize;
            intelligenceLabel.Location = new Point(leftColumn, constitutionLabel.Location.Y + constitutionLabel.Height);

            if (character.Intelligence >= 10)
            {
                intelligenceValue.Text = String.Format("{0} (+{1})", character.Intelligence, ((int)character.Intelligence - 10) / 2);
            }
            else
            {
                intelligenceValue.Text = String.Format("{0} ({1})", character.Intelligence, ((int)character.Intelligence - 10) / 2);
            }
            intelligenceValue.Size = intelligenceValue.PreferredSize;
            intelligenceValue.Location = new Point(rightColumn, intelligenceLabel.Location.Y);

            wisdomLabel.Text = "Wisdom:";
            wisdomLabel.Size = wisdomLabel.PreferredSize;
            wisdomLabel.Location = new Point(leftColumn, intelligenceLabel.Location.Y + intelligenceLabel.Height);

            if (character.Wisdom >= 10)
            {
                wisdomValue.Text = String.Format("{0} (+{1})", character.Wisdom, ((int)character.Wisdom - 10) / 2);
            }
            else
            {
                wisdomValue.Text = String.Format("{0} ({1})", character.Wisdom, ((int)character.Wisdom - 10) / 2);
            }
            wisdomValue.Size = wisdomValue.PreferredSize;
            wisdomValue.Location = new Point(rightColumn, wisdomLabel.Location.Y);

            charismaLabel.Text = "Charisma:";
            charismaLabel.Size = charismaLabel.PreferredSize;
            charismaLabel.Location = new Point(leftColumn, wisdomLabel.Location.Y + wisdomLabel.Height);

            if (character.Charisma >= 10)
            {
                charismaValue.Text = String.Format("{0} (+{1})", character.Charisma, ((int)character.Charisma - 10) / 2);
            }
            else
            {
                charismaValue.Text = String.Format("{0} ({1})", character.Charisma, ((int)character.Charisma - 10) / 2);
            }
            charismaValue.Size = charismaValue.PreferredSize;
            charismaValue.Location = new Point(rightColumn, charismaLabel.Location.Y);

            this.Controls.Add(alignment);
            this.Controls.Add(classLabel);
            this.Controls.Add(classValue);
            this.Controls.Add(wealthLabel);
            this.Controls.Add(wealthValue);
            this.Controls.Add(deityLabel);
            this.Controls.Add(deityValue);
            this.Controls.Add(strengthLabel);
            this.Controls.Add(strengthValue);
            this.Controls.Add(dexterityLabel);
            this.Controls.Add(dexterityValue);
            this.Controls.Add(constitutionLabel);
            this.Controls.Add(constitutionValue);
            this.Controls.Add(intelligenceLabel);
            this.Controls.Add(intelligenceValue);
            this.Controls.Add(wisdomLabel);
            this.Controls.Add(wisdomValue);
            this.Controls.Add(charismaLabel);
            this.Controls.Add(charismaValue);
        }

        string SubraceToString(uint Subrace)
        {
            switch(Subrace)
            {
                case 0: return "Gold Dwarf";
                case 1: return "Duergar";
                case 2: return "Shield Dwarf";
                case 3: return "Drow";
                case 4: return "Moon Elf";
                case 5: return "Sun Elf";
                case 6: return "Wild Elf";
                case 7: return "Wood Elf";
                case 8: return "Svirfneblin";
                case 9: return "Rock Gnome";
                case 10: return "Ghostwise Halfling";
                case 11: return "Lightfoot Halfling";
                case 12: return "Strongheart Halfling";
                case 13: return "Aasimar";
                case 14: return "Tieflng";
                case 15: return "Half Elf";
                case 16: return "Half Orc";
                case 17: return "Human";
                case 18: return "Air Genasi";
                case 19: return "Earth Genasi";
                case 20: return "Fire Genasi";
                case 21: return "Water Genasi";
                case 22: return "Aberration";
                case 23: return "Animal";
                case 24: return "Beast";
                case 25: return "Construct";
                case 26: return "Goblinoid";
                case 27: return "Monstrous Humanoid";
                case 28: return "Orc";
                case 29: return "Reptilian";
                case 30: return "Elemental";
                case 31: return "Fey";
                case 32: return "Giant";
                case 33: return "Outsider";
                case 34: return "Shapechanger";
                case 35: return "Undead";
                case 36: return "Vermin";
                case 37: return "Ooze";
                case 38: return "Dragon";
                case 39: return "Magical Beast";
                case 40: return "Incorporeal";
                case 41: return "Githyanki";
                case 42: return "Githzerai";
                case 43: return "Half Drow";
                case 44: return "Plant";
                case 45: return "Hagspawn";
                case 46: return "Half Celestial";
                case 47: return "Yuan-ti Pureblood";
                case 48: return "Grey Orc";
                case 67: return "Vampire";
            }
            return "Unknown Race";
        }
    }
}
