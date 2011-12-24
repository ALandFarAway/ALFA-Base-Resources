/*
Script: tkl_cardgame_descriptions
Author: brockfanning
Date: 11/3/07
Purpose: This script contains descriptions of the various cards.  This will be unnecessary
whenever Obsidian fixes GetDescription().  After that, the descriptions will simply be on each
card item.  For now, though, use this script if you want to add/change any descriptions.
As of now, only the Tarot cards have descriptions.  (I didn't see much point in descriptions
of Poker cards.)  If you want to add Poker descriptions, scroll down and don't forget to
delete the two specified lines.
*/

// SCROLL DOWN TO ADD/MODIFY CARD DESCRIPTIONS

const string SET_TAROT =		"i_cards_tarot_";
const string SET_POKER =		"i_cards_poker_";

const string SUIT_CLUBS =		"club";
const string SUIT_HEARTS =		"hear";
const string SUIT_SPADES =		"spad";
const string SUIT_DIAMONDS =	"diam";
const string SUIT_SWORDS =		"swor";
const string SUIT_WANDS =		"wand";
const string SUIT_PENTACLES =	"pent";
const string SUIT_CUPS =		"cups";
const string SUIT_TRUMPS =		"trum";

const string CARD_HEARTS_2 =	"i_cards_poker_hearts_2";
const string CARD_HEARTS_3 =	"i_cards_poker_hearts_3";
const string CARD_HEARTS_4 =	"i_cards_poker_hearts_4";
const string CARD_HEARTS_5 =	"i_cards_poker_hearts_5";
const string CARD_HEARTS_6 =	"i_cards_poker_hearts_6";
const string CARD_HEARTS_7 =	"i_cards_poker_hearts_7";
const string CARD_HEARTS_8 =	"i_cards_poker_hearts_8";
const string CARD_HEARTS_9 =	"i_cards_poker_hearts_9";
const string CARD_HEARTS_10 =	"i_cards_poker_hearts_10";
const string CARD_HEARTS_JACK =	"i_cards_poker_hearts_jack";
const string CARD_HEARTS_QUEEN =	"i_cards_poker_hearts_queen";
const string CARD_HEARTS_KING =	"i_cards_poker_hearts_king";
const string CARD_HEARTS_ACE =	"i_cards_poker_hearts_ace";

const string CARD_SPADES_2 =	"i_cards_poker_spades_2";
const string CARD_SPADES_3 =	"i_cards_poker_spades_3";
const string CARD_SPADES_4 =	"i_cards_poker_spades_4";
const string CARD_SPADES_5 =	"i_cards_poker_spades_5";
const string CARD_SPADES_6 =	"i_cards_poker_spades_6";
const string CARD_SPADES_7 =	"i_cards_poker_spades_7";
const string CARD_SPADES_8 =	"i_cards_poker_spades_8";
const string CARD_SPADES_9 =	"i_cards_poker_spades_9";
const string CARD_SPADES_10 =	"i_cards_poker_spades_10";
const string CARD_SPADES_JACK =	"i_cards_poker_spades_jack";
const string CARD_SPADES_QUEEN =	"i_cards_poker_spades_queen";
const string CARD_SPADES_KING =	"i_cards_poker_spades_king";
const string CARD_SPADES_ACE =	"i_cards_poker_spades_ace";

const string CARD_CLUBS_2 =	"i_cards_poker_clubs_2";
const string CARD_CLUBS_3 =	"i_cards_poker_clubs_3";
const string CARD_CLUBS_4 =	"i_cards_poker_clubs_4";
const string CARD_CLUBS_5 =	"i_cards_poker_clubs_5";
const string CARD_CLUBS_6 =	"i_cards_poker_clubs_6";
const string CARD_CLUBS_7 =	"i_cards_poker_clubs_7";
const string CARD_CLUBS_8 =	"i_cards_poker_clubs_8";
const string CARD_CLUBS_9 =	"i_cards_poker_clubs_9";
const string CARD_CLUBS_10 =	"i_cards_poker_clubs_10";
const string CARD_CLUBS_JACK =	"i_cards_poker_clubs_jack";
const string CARD_CLUBS_QUEEN =	"i_cards_poker_clubs_queen";
const string CARD_CLUBS_KING =	"i_cards_poker_clubs_king";
const string CARD_CLUBS_ACE =	"i_cards_poker_clubs_ace";

const string CARD_DIAMONDS_2 =	"i_cards_poker_diamonds_2";
const string CARD_DIAMONDS_3 =	"i_cards_poker_diamonds_3";
const string CARD_DIAMONDS_4 =	"i_cards_poker_diamonds_4";
const string CARD_DIAMONDS_5 =	"i_cards_poker_diamonds_5";
const string CARD_DIAMONDS_6 =	"i_cards_poker_diamonds_6";
const string CARD_DIAMONDS_7 =	"i_cards_poker_diamonds_7";
const string CARD_DIAMONDS_8 =	"i_cards_poker_diamonds_8";
const string CARD_DIAMONDS_9 =	"i_cards_poker_diamonds_9";
const string CARD_DIAMONDS_10 =	"i_cards_poker_diamonds_10";
const string CARD_DIAMONDS_JACK =	"i_cards_poker_diamonds_jack";
const string CARD_DIAMONDS_QUEEN =	"i_cards_poker_diamonds_queen";
const string CARD_DIAMONDS_KING =	"i_cards_poker_diamonds_king";
const string CARD_DIAMONDS_ACE =	"i_cards_poker_diamonds_ace";

const string CARD_WANDS_2 =	"i_cards_tarot_wands_2";
const string CARD_WANDS_3 =	"i_cards_tarot_wands_3";
const string CARD_WANDS_4 =	"i_cards_tarot_wands_4";
const string CARD_WANDS_5 =	"i_cards_tarot_wands_5";
const string CARD_WANDS_6 =	"i_cards_tarot_wands_6";
const string CARD_WANDS_7 =	"i_cards_tarot_wands_7";
const string CARD_WANDS_8 =	"i_cards_tarot_wands_8";
const string CARD_WANDS_9 =	"i_cards_tarot_wands_9";
const string CARD_WANDS_10 =	"i_cards_tarot_wands_10";
const string CARD_WANDS_KNIGHT =	"i_cards_tarot_wands_kn";
const string CARD_WANDS_PAGE =	"i_cards_tarot_wands_p";
const string CARD_WANDS_QUEEN =	"i_cards_tarot_wands_q";
const string CARD_WANDS_KING =	"i_cards_tarot_wands_k";
const string CARD_WANDS_ACE =	"i_cards_tarot_wands_a";

const string CARD_SWORDS_2 =	"i_cards_tarot_swords_2";
const string CARD_SWORDS_3 =	"i_cards_tarot_swords_3";
const string CARD_SWORDS_4 =	"i_cards_tarot_swords_4";
const string CARD_SWORDS_5 =	"i_cards_tarot_swords_5";
const string CARD_SWORDS_6 =	"i_cards_tarot_swords_6";
const string CARD_SWORDS_7 =	"i_cards_tarot_swords_7";
const string CARD_SWORDS_8 =	"i_cards_tarot_swords_8";
const string CARD_SWORDS_9 =	"i_cards_tarot_swords_9";
const string CARD_SWORDS_10 =	"i_cards_tarot_swords_10";
const string CARD_SWORDS_KNIGHT =	"i_cards_tarot_swords_kn";
const string CARD_SWORDS_PAGE =	"i_cards_tarot_swords_p";
const string CARD_SWORDS_QUEEN =	"i_cards_tarot_swords_q";
const string CARD_SWORDS_KING =	"i_cards_tarot_swords_k";
const string CARD_SWORDS_ACE =	"i_cards_tarot_swords_a";

const string CARD_PENTACLES_2 =	"i_cards_tarot_pent_2";
const string CARD_PENTACLES_3 =	"i_cards_tarot_pent_3";
const string CARD_PENTACLES_4 =	"i_cards_tarot_pent_4";
const string CARD_PENTACLES_5 =	"i_cards_tarot_pent_5";
const string CARD_PENTACLES_6 =	"i_cards_tarot_pent_6";
const string CARD_PENTACLES_7 =	"i_cards_tarot_pent_7";
const string CARD_PENTACLES_8 =	"i_cards_tarot_pent_8";
const string CARD_PENTACLES_9 =	"i_cards_tarot_pent_9";
const string CARD_PENTACLES_10 =	"i_cards_tarot_pent_10";
const string CARD_PENTACLES_KNIGHT =	"i_cards_tarot_pent_kn";
const string CARD_PENTACLES_PAGE =	"i_cards_tarot_pent_p";
const string CARD_PENTACLES_QUEEN =	"i_cards_tarot_pent_q";
const string CARD_PENTACLES_KING =	"i_cards_tarot_pent_k";
const string CARD_PENTACLES_ACE =	"i_cards_tarot_pent_a";

const string CARD_CUPS_2 =	"i_cards_tarot_cups_2";
const string CARD_CUPS_3 =	"i_cards_tarot_cups_3";
const string CARD_CUPS_4 =	"i_cards_tarot_cups_4";
const string CARD_CUPS_5 =	"i_cards_tarot_cups_5";
const string CARD_CUPS_6 =	"i_cards_tarot_cups_6";
const string CARD_CUPS_7 =	"i_cards_tarot_cups_7";
const string CARD_CUPS_8 =	"i_cards_tarot_cups_8";
const string CARD_CUPS_9 =	"i_cards_tarot_cups_9";
const string CARD_CUPS_10 =	"i_cards_tarot_cups_10";
const string CARD_CUPS_KNIGHT =	"i_cards_tarot_cups_kn";
const string CARD_CUPS_PAGE =	"i_cards_tarot_cups_p";
const string CARD_CUPS_QUEEN =	"i_cards_tarot_cups_q";
const string CARD_CUPS_KING =	"i_cards_tarot_cups_k";
const string CARD_CUPS_ACE =	"i_cards_tarot_cups_a";

const string CARD_TRUMP_0 =	"i_cards_tarot_trump_0";
const string CARD_TRUMP_1 =	"i_cards_tarot_trump_1";
const string CARD_TRUMP_2 =	"i_cards_tarot_trump_2";
const string CARD_TRUMP_3 =	"i_cards_tarot_trump_3";
const string CARD_TRUMP_4 =	"i_cards_tarot_trump_4";
const string CARD_TRUMP_5 =	"i_cards_tarot_trump_5";
const string CARD_TRUMP_6 =	"i_cards_tarot_trump_6";
const string CARD_TRUMP_7 =	"i_cards_tarot_trump_7";
const string CARD_TRUMP_8 =	"i_cards_tarot_trump_8";
const string CARD_TRUMP_9 =	"i_cards_tarot_trump_9";
const string CARD_TRUMP_10 =	"i_cards_tarot_trump_10";
const string CARD_TRUMP_11 =	"i_cards_tarot_trump_11";
const string CARD_TRUMP_12 =	"i_cards_tarot_trump_12";
const string CARD_TRUMP_13 =	"i_cards_tarot_trump_13";
const string CARD_TRUMP_14 =	"i_cards_tarot_trump_14";
const string CARD_TRUMP_15 =	"i_cards_tarot_trump_15";
const string CARD_TRUMP_16 =	"i_cards_tarot_trump_16";
const string CARD_TRUMP_17 =	"i_cards_tarot_trump_17";
const string CARD_TRUMP_18 =	"i_cards_tarot_trump_18";
const string CARD_TRUMP_19 =	"i_cards_tarot_trump_19";
const string CARD_TRUMP_20 =	"i_cards_tarot_trump_20";
const string CARD_TRUMP_21 =	"i_cards_tarot_trump_21";


// ADD/MODIFY CARD DESCRIPTIONS BELOW

string GetCardDescription(object oCard)
{
	string sTag = GetTag(oCard);
	// The first 14 letters of each card's tag determines which cardset it is from.
	string sSet = GetStringLeft(sTag, 14);
	// The next 4 letters can be used to determine which suit the card is.
	string sSuit = GetSubString(sTag, 14, 4);
	string sDescription;
	string sName = GetName(oCard);
	
	if (sSet == SET_TAROT)
	{
		if (sSuit == SUIT_SWORDS)
		{
			if (sTag == CARD_SWORDS_2)
				sDescription = "This card represents blocking emotions, being at a stalemate, and avoiding the truth.";
			else if (sTag == CARD_SWORDS_3)
				sDescription = "This card represents feeling heartbreak, feeling lonely, and experiencing betrayal.";
			else if (sTag == CARD_SWORDS_4)
				sDescription = "This card represents resting, contemplating, quietly preparing.";	
			else if (sTag == CARD_SWORDS_5)
				sDescription = "This card represents acting in your own self-interest, experiencing discord, and witnessing open dishonor.";
			else if (sTag == CARD_SWORDS_6)
				sDescription = "This card represents feeling sad, recovering, and traveling.";
			else if (sTag == CARD_SWORDS_7)
				sDescription = "This card represents running away, being a lone wolf, and choosing hidden dishonor.";
			else if (sTag == CARD_SWORDS_8)
				sDescription = "This card represents feeling restricted, feeling confused, and feeling powerless.";
			else if (sTag == CARD_SWORDS_9)
				sDescription = "This card represents worrying, feeling guilty, and suffering anguish.";
			else if (sTag == CARD_SWORDS_10)
				sDescription = "This card represents bottoming out, feeling like a victim, and being a martyr.";
			else if (sTag == CARD_SWORDS_PAGE)
				sDescription = "This card represents using your mind, being truthful, being just, and having fortitude.";
			else if (sTag == CARD_SWORDS_KNIGHT)
				sDescription = "This card represents being direct, authoritative, logical, incisive, and knowledgable.";
			else if (sTag == CARD_SWORDS_QUEEN)
				sDescription = "This card represents being honest, astute, forthright, witty, and experienced.";
			else if (sTag == CARD_SWORDS_KING)
				sDescription = "This card represents being intellectual, analytical, ethical, just, and articulate.";
			else if (sTag == CARD_SWORDS_ACE)
				sDescription = "This card represents using mental force, seeking justice, having fortitude, and proceeding with truth.";		
		}
		else if (sSuit == SUIT_WANDS)
		{
			if (sTag == CARD_WANDS_2)
				sDescription = "This card represents having personal power, being bold, and showing originality.";
			else if (sTag == CARD_WANDS_3)
				sDescription = "This card represents exploring the unknown, having foresight, and demonstrating leadership.";
			else if (sTag == CARD_WANDS_4)
				sDescription = "This card represents celebrating, seeking freedom, and feeling excited.";
			else if (sTag == CARD_WANDS_5)
				sDescription = "This card represents disagreeing, experiencing competition, and experiencing hassles.";
			else if (sTag == CARD_WANDS_6)
				sDescription = "This card represents acheiving victory, receiving acclaim, and feeling pride.";
			else if (sTag == CARD_WANDS_7)
				sDescription = "This card represents being aggressive, being defiant, showing conviction.";
			else if (sTag == CARD_WANDS_8)
				sDescription = "This card represents taking quick action, coming to a conclusion, and receiving news.";
			else if (sTag == CARD_WANDS_9)
				sDescription = "This card represents defending yourself, persevering, and showing stamina.";
			else if (sTag == CARD_WANDS_10)
				sDescription = "This card represents over-extending, feeling burdened, and struggling.";
			else if (sTag == CARD_WANDS_PAGE)
				sDescription = "This card represents being creative, enthusiastic, courageous, and confident.";
			else if (sTag == CARD_WANDS_KNIGHT)
				sDescription = "This card represents being charming, confident, daring, adventurous, and passionate.";
			else if (sTag == CARD_WANDS_QUEEN)
				sDescription = "This card represents being attractive, self-assured, whole-hearted, energetic, and cheerful.";
			else if (sTag == CARD_WANDS_KING)
				sDescription = "This card represents being creative, inspiring, forceful, charismatic, and bold.";
			else if (sTag == CARD_WANDS_ACE)
				sDescription = "This card represents using creative force, showing enthusiasm, having confidence, and proceeding with courage.";
		}
		else if (sSuit == SUIT_CUPS)
		{
			if (sTag == CARD_CUPS_2)
				sDescription = "This card represents making a connection, calling a truce, and acknowledging an attraction.";
			else if (sTag == CARD_CUPS_3)
				sDescription = "This card represents feeling exuberant, enjoying a friendship, and valuing community.";
			else if (sTag == CARD_CUPS_4)
				sDescription = "This card represents being self-absorbed, feeling apathetic, and going within.";	
			else if (sTag == CARD_CUPS_5)
				sDescription = "This card represents suffering a loss, feeling bereft, and feeling regret.";
			else if (sTag == CARD_CUPS_6)
				sDescription = "This card represents experiencing good will, enjoying innocence, and focusing on childhood.";
			else if (sTag == CARD_CUPS_7)
				sDescription = "This card represents indulging in wishful thinking, having many options, and falling into dissipation.";
			else if (sTag == CARD_CUPS_8)
				sDescription = "This card represents seeking deeper meaning, moving on, and growing weary.";
			else if (sTag == CARD_CUPS_9)
				sDescription = "This card represents having your wish fulfilled, feeling satisfied, and enjoying sensual pleasure.";
			else if (sTag == CARD_CUPS_10)
				sDescription = "This card represents feeling joy, enjoying peace, and looking to the family.";
			else if (sTag == CARD_CUPS_PAGE)
				sDescription = "This card represents being emotional, loving, intimate, and intuitive.";
			else if (sTag == CARD_CUPS_KNIGHT)
				sDescription = "This card represents being romantic, sensitive, imaginative, refined, and introspective.";
			else if (sTag == CARD_CUPS_QUEEN)
				sDescription = "This card represents being loving, tender-heared, psychic, spiritual, and intuitive.";
			else if (sTag == CARD_CUPS_KING)
				sDescription = "This card represents being wise, calm, tolerant, caring, and diplomatic.";
			else if (sTag == CARD_CUPS_ACE)
				sDescription = "This card represents using emotional force, developing intuition, proceeding with love, and experiencing intimacy.";			
		}
		else if (sSuit == SUIT_PENTACLES)
		{
			if (sTag == CARD_PENTACLES_2)
				sDescription = "This card represents juggling, being flexible, and having fun.";
			else if (sTag == CARD_PENTACLES_3)
				sDescription = "This card represents working as a team, planning, and being competent.";
			else if (sTag == CARD_PENTACLES_4)
				sDescription = "This card represents wanting to possess, blocking change, and maintaining control.";	
			else if (sTag == CARD_PENTACLES_5)
				sDescription = "This card represents experiencing hard times, suffering ill health, and being rejected.";
			else if (sTag == CARD_PENTACLES_6)
				sDescription = "This card represents having/not having resources, having/not having knowledge, and having/not having power.";
			else if (sTag == CARD_PENTACLES_7)
				sDescription = "This card represents assessing, reaping a reward, and considering a direction change.";
			else if (sTag == CARD_PENTACLES_8)
				sDescription = "This card represents showing diligence, increasing knowledge, and paying attention to detail.";
			else if (sTag == CARD_PENTACLES_9)
				sDescription = "This card represents being disciplined, relying on yourself, and pursuing refinement.";
			else if (sTag == CARD_PENTACLES_10)
				sDescription = "This card represents enjoying affluence, seeking permanence, and following convention.";
			else if (sTag == CARD_PENTACLES_PAGE)
				sDescription = "This card represents being effective, trusting, trustworthy, practical, and prosperous.";
			else if (sTag == CARD_PENTACLES_KNIGHT)
				sDescription = "This card represents being unwavering, cautious, thorough, realistic, and hard-working.";
			else if (sTag == CARD_PENTACLES_QUEEN)
				sDescription = "This card represents being nurturing, big-hearted, resourceful, down-to-earth, and trustworthy.";
			else if (sTag == CARD_PENTACLES_KING)
				sDescription = "This card represents being enterprising, adept, reliable, supporting, and steady.";
			else if (sTag == CARD_PENTACLES_ACE)
				sDescription = "This card represents using material force, prospering, being practical, and proceeding with trust.";			
		}
		else if (sSuit == SUIT_TRUMPS)
		{
			if (sTag == CARD_TRUMP_0)
				sDescription = "This card represents beginning, being spontaneous, having faith, and embracing folly.";
			else if (sTag == CARD_TRUMP_1)
				sDescription = "This card represents taking action, acting consciously, concentrating, and experiencing power.";
			else if (sTag == CARD_TRUMP_2)
				sDescription = "This card represents staying nonactive, accessing the unconscious, seeing the potential, and sensing the mystery.";
			else if (sTag == CARD_TRUMP_3)
				sDescription = "This card represents mothering, welcoming abundance, experiencing the senses, and responding to Nature.";
			else if (sTag == CARD_TRUMP_4)
				sDescription = "This card represents fathering, emphasizing structure, exercising authority, and regulating.";	
			else if (sTag == CARD_TRUMP_5)
				sDescription = "This card represents getting an education, having a belief system, conforming, and identifying with a group.";
			else if (sTag == CARD_TRUMP_6)
				sDescription = "This card represents relating to others, being sexual, establishing personal beliefs, and determining values.";
			else if (sTag == CARD_TRUMP_7)
				sDescription = "This card represents achieving victory, using your will, asserting yourself, and achieving hard control.";
			else if (sTag == CARD_TRUMP_8)
				sDescription = "This card represents showing strength, being patient, being compassionate, and achieving soft control.";
			else if (sTag == CARD_TRUMP_9)
				sDescription = "This card represents being introspective, searching, receiving/giving guidance, and seeking solitude.";
			else if (sTag == CARD_TRUMP_10)
				sDescription = "This card represents feeling a sense of destiny, being at a turning point, feeling movement, and having a personal vision.";
			else if (sTag == CARD_TRUMP_11)
				sDescription = "This card represents respecting justice, assuming responsibility, preparing for a decision, and understanding cause and effect.";
			else if (sTag == CARD_TRUMP_12)
				sDescription = "This card represents letting go, reversing, suspending action, and sacrificing.";
			else if (sTag == CARD_TRUMP_13)
				sDescription = "This card represents ending, going through transition, eliminating excess, and experiencing inexorable forces.";
			else if (sTag == CARD_TRUMP_14)
				sDescription = "This card represents being temperate, maintaining balance, experiencing health, and combining forces.";	
			else if (sTag == CARD_TRUMP_15)
				sDescription = "This card represents experiencing bondage, focusing on the material, staying in ignorance, and feeling hopeless.";
			else if (sTag == CARD_TRUMP_16)
				sDescription = "This card represents going through sudden change, releasing, falling down, and having a revelation.";
			else if (sTag == CARD_TRUMP_17)
				sDescription = "This card represents regaining hope, being inspired, being generous, and feeling serene.";
			else if (sTag == CARD_TRUMP_18)
				sDescription = "This card represents feeling fear, believing illusions, stimulating the imagination, and feeling bewildered.";
			else if (sTag == CARD_TRUMP_19)
				sDescription = "This card represents becoming enlightened, experiencing greatness, feeling vitality, and having assurance.";
			else if (sTag == CARD_TRUMP_20)
				sDescription = "This card represents making a judgment, feeling reborn, hearing a call, and finding absolution.";
			else if (sTag == CARD_TRUMP_21)
				sDescription = "This card represents integrating, accomplishing, becoming involved, and feeling fulfilled.";
		}
	}
	else if (sSet == SET_POKER)
	{
		/* IF WANT TO GIVE THE POKER CARDS DESCRIPTIONS, DELETE THIS LINE AND SEE BELOW.
		   
		if (sSuit == SUIT_HEARTS)
		{
			if (sTag == CARD_HEARTS_2)
				sDescription = "";
			else if (sTag == CARD_HEARTS_3)
				sDescription = "";
			else if (sTag == CARD_HEARTS_4)
				sDescription = "";	
			else if (sTag == CARD_HEARTS_5)
				sDescription = "";
			else if (sTag == CARD_HEARTS_6)
				sDescription = "";
			else if (sTag == CARD_HEARTS_7)
				sDescription = "";
			else if (sTag == CARD_HEARTS_8)
				sDescription = "";
			else if (sTag == CARD_HEARTS_9)
				sDescription = "";
			else if (sTag == CARD_HEARTS_10)
				sDescription = "";
			else if (sTag == CARD_HEARTS_JACK)
				sDescription = "";
			else if (sTag == CARD_HEARTS_QUEEN)
				sDescription = "";
			else if (sTag == CARD_HEARTS_KING)
				sDescription = "";
			else if (sTag == CARD_HEARTS_ACE)
				sDescription = "";		
		}
		else if (sSuit == SUIT_SPADES)
		{
			if (sTag == CARD_SPADES_2)
				sDescription = "";
			else if (sTag == CARD_SPADES_3)
				sDescription = "";
			else if (sTag == CARD_SPADES_4)
				sDescription = "";	
			else if (sTag == CARD_SPADES_5)
				sDescription = "";
			else if (sTag == CARD_SPADES_6)
				sDescription = "";
			else if (sTag == CARD_SPADES_7)
				sDescription = "";
			else if (sTag == CARD_SPADES_8)
				sDescription = "";
			else if (sTag == CARD_SPADES_9)
				sDescription = "";
			else if (sTag == CARD_SPADES_10)
				sDescription = "";
			else if (sTag == CARD_SPADES_JACK)
				sDescription = "";
			else if (sTag == CARD_SPADES_QUEEN)
				sDescription = "";
			else if (sTag == CARD_SPADES_KING)
				sDescription = "";
			else if (sTag == CARD_SPADES_ACE)
				sDescription = "";			
		}
		else if (sSuit == SUIT_CLUBS)
		{
			if (sTag == CARD_CLUBS_2)
				sDescription = "";
			else if (sTag == CARD_CLUBS_3)
				sDescription = "";
			else if (sTag == CARD_CLUBS_4)
				sDescription = "";	
			else if (sTag == CARD_CLUBS_5)
				sDescription = "";
			else if (sTag == CARD_CLUBS_6)
				sDescription = "";
			else if (sTag == CARD_CLUBS_7)
				sDescription = "";
			else if (sTag == CARD_CLUBS_8)
				sDescription = "";
			else if (sTag == CARD_CLUBS_9)
				sDescription = "";
			else if (sTag == CARD_CLUBS_10)
				sDescription = "";
			else if (sTag == CARD_CLUBS_JACK)
				sDescription = "";
			else if (sTag == CARD_CLUBS_QUEEN)
				sDescription = "";
			else if (sTag == CARD_CLUBS_KING)
				sDescription = "";
			else if (sTag == CARD_CLUBS_ACE)
				sDescription = "";			
		}
		else if (sSuit == SUIT_DIAMONDS)
		{
			if (sTag == CARD_DIAMONDS_2)
				sDescription = "";
			else if (sTag == CARD_DIAMONDS_3)
				sDescription = "";
			else if (sTag == CARD_DIAMONDS_4)
				sDescription = "";	
			else if (sTag == CARD_DIAMONDS_5)
				sDescription = "";
			else if (sTag == CARD_DIAMONDS_6)
				sDescription = "";
			else if (sTag == CARD_DIAMONDS_7)
				sDescription = "";
			else if (sTag == CARD_DIAMONDS_8)
				sDescription = "";
			else if (sTag == CARD_DIAMONDS_9)
				sDescription = "";
			else if (sTag == CARD_DIAMONDS_10)
				sDescription = "";
			else if (sTag == CARD_DIAMONDS_JACK)
				sDescription = "";
			else if (sTag == CARD_DIAMONDS_QUEEN)
				sDescription = "";
			else if (sTag == CARD_DIAMONDS_KING)
				sDescription = "";
			else if (sTag == CARD_DIAMONDS_ACE)
				sDescription = "";			
		}
		
		ALSO DELETE THIS LINE IF YOU GIVE THE POKER CARDS DESCRIPTIONS */
	}
	
	if (sDescription == "")
		sDescription = sName;
	else sDescription = sName + ": " + sDescription;
	return sDescription;
}