#include-once
Global $g_aPhases[][] = [ _
        ["SkipTutorial",              "Take The Shortcut",                  "pending", "Tutorial",                      "primary"], _
        ["RewardM01",                 "Chahbek Village",             "pending", "M01 Chahbek Village",           "coop"   ], _
        ["PrimaryTraining",           "Primary Training",                                   "pending", "Primary Training",              "primary"], _
        ["HoningYourSkills",          "Honing Your Skills",                                 "pending", "Honing your Skills",            "primary"], _
        ["SecondaryTraining",         "Secondary Training",                                 "pending", "Secondary Training",            "primary"], _
        ["ChooseSecondaryProfession", "Choose Your Secondary Profession",                   "pending", "Choose Your Secondary",         "primary"], _
        ["LeavingALegacy",            "Leaving A Legacy",                                   "pending", "Leaving a Legacy",              "primary"], _
        ["TheHonorableGeneral",       "The Honorable General",                              "pending", "The Honorable General",         "primary"], _
        ["SignsAndPortents",          "Signs And Portents",                                 "pending", "Signs and Portents",            "primary"], _
        ["M02_JokanurDiggings",       "Jokanur Diggings",         "pending", "M02 Jokanur Diggings",          "coop"   ], _
        ["IsleOfTheDead",             "Isle Of The Dead",                                   "pending", "Isle of the Dead",              "primary"], _
        ["BadTideRising",             "Bad Tide Rising",                                    "pending", "Bad Tide Rising",               "primary"], _
        ["SpecialDelivery",           "Special Delivery",                                   "pending", "Special Delivery",              "primary"], _
        ["BigNewsSmallPackage",       "Big News, Small Package",                            "pending", "Big News, Small Package",       "primary"], _
        ["FollowingTheTrail",         "Following The Trail",                                "pending", "Following the Trail",           "primary"], _
        ["M03_BlacktideDen",          "Blacktide Den",           "pending", "M03 Blacktide Den",             "coop"   ], _
        ["TheIronTruth",              "The Iron Truth",                                     "pending", "The Iron Truth",                "primary"], _
        ["TrialByFire",               "Trial by Fire",                                      "pending", "Trial by Fire",                 "primary"], _
        ["WarPrep_GhostRecon",        "War Preparations (Ghost Recon)",                     "pending", "War Preparations",              "primary"], _
        ["WarPrep_RecruitTraining",   "War Preparations (Recruit Training)",                "pending", "War Preparations",              "primary"], _
        ["WarPrep_WindAndWater",      "War Preparations (Wind and Water)",                  "pending", "War Preparations",              "primary"], _
        ["TheTimeIsNigh",             "The Time is Nigh",               "pending", "The Time is Nigh",              "primary"], _
        ["M04_ConsulateDocks",        "CONSULATE DOCKS",          "pending", "M04 Consulate Docks",           "coop"   ], _
        ["Hunted",                    "Hunted!",                                            "pending", "Hunted!",                       "primary"], _
        ["TheGreatEscape",            "The Great Escape",                                   "pending", "The Great Escape",              "primary"], _
        ["AndAHeroShallLeadThem",     "And a Hero Shall Lead Them",                         "pending", "And a Hero Shall Lead",         "primary"], _
        ["M05_VentaCemetery",         "VENTA CEMETERY",              "pending", "M05 Venta Cemetery",            "coop"   ], _
        ["TheCouncilIsCalled",        "The Council is Called",                              "pending", "The Council is Called",         "primary"], _
        ["ToVabbi",                   "To Vabbi!",                                          "pending", "To Vabbi!",                     "primary"], _
        ["CentaurBlackmail",          "Centaur Blackmail",                                  "pending", "Centaur Blackmail",             "primary"], _
        ["M06_KodonurCrossroads",     "KODONUR CROSSROADS","pending", "M06 Kodonur Crossroads",       "coop"   ], _
        ["MysteriousMessage",         "Mysterious Message",                                 "pending", "Mysterious Message",            "primary"], _
        ["SecretsInTheShadow",        "Secrets in the Shadow",                              "pending", "Master of Whispers path",       "primary"], _
        ["ToKillADemon",              "To Kill a Demon",                                    "pending", "Master of Whispers path",       "primary"], _
        ["M07_RilohnRefuge",          "RILOHN REFUGE", "pending", "M07 Rilohn Refuge",             "coop"   ], _
        ["M08_ModdokCrevice",         "MODDOK CREVICE",           "pending", "M08 Moddok Crevice",            "coop"   ], _
        ["RallyThePrinces",           "Rally The Princes",                                  "pending", "Rally The Princes",             "primary"], _
        ["M09_TiharkOrchard",         "TIHARK ORCHARD",                                     "pending", "M09 Tihark Orchard",            "coop"   ], _
        ["AllsWellThatEndsWell",      "All's Well That Ends Well",                          "pending", "All's Well That Ends Well",     "primary"], _
        ["WarningKehanni",            "Warning Kehanni",                                    "pending", "Warning Kehanni",               "primary"], _
        ["CallingTheOrder",           "Calling the Order",                                  "pending", "Master of Whispers path",       "primary"], _
        ["M10_DzagonurBastion",       "DZAGONUR BASTION","pending", "M10 Dzagonur Bastion",        "coop"   ], _
        ["PledgeOfMerchantPrinces",   "Pledge of the Merchant Princes",                     "pending", "Pledge of the Princes",        "primary"], _
        ["M11_GrandCourtSebelkeh",    "GRAND COURT OF SEBELKEH", "pending", "M11 Grand Court Sebelkeh",     "coop"   ], _
        ["AttackAtTheKodash",         "Attack at the Kodash",                               "pending", "Attack at the Kodash",         "primary"], _
        ["HeartOrMindRonjokInDanger", "Heart or Mind: Ronjok in Danger",                    "pending", "Heart or Mind",                "primary"], _
        ["M12_NunduBay",              "NUNDU BAY",                "pending", "M12 Nundu Bay",                 "coop"   ], _
        ["CrossingTheDesolation",     "Crossing the Desolation",                            "pending", "Crossing the Desolation",      "primary"], _
        ["M13_GateOfDesolation",      "GATE OF DESOLATION","pending", "M13 Gate of Desolation",      "coop"   ], _
        ["ADealsADeal",               "A Deal's a Deal",                                    "pending", "A Deal's a Deal",              "primary"], _
        ["HordeOfDarkness",           "Horde of Darkness",                                  "pending", "Horde of Darkness",            "primary"], _
        ["M14_RuinsOfMorah",          "RUINS OF MORAH",   "pending", "M14 Ruins of Morah",           "coop"   ], _
        ["UnchartedTerritory",        "Uncharted Territory",                                "pending", "Uncharted Territory",          "primary"], _
        ["M15_GateOfPain",            "GATE OF PAIN",             "pending", "M15 Gate of Pain",             "coop"   ], _
        ["KormirsCrusade",            "Kormir's Crusade",                                   "pending", "Kormir's Crusade",             "primary"], _
        ["AllAloneInTheDarkness",     "All Alone in the Darkness",                          "pending", "All Alone in the Darkness",    "primary"], _
        ["M16_GateOfMadness",         "GATE OF MADNESS",                                    "pending", "M16 Gate of Madness",          "coop"   ], _
        ["M17_AbaddonsGate",          "ABADDON'S GATE",                                     "pending", "M17 Abaddon's Gate",           "coop"   ]  _
]
Global $g_bTrialMode = True
Local $aTrialPhases[16][5]
For $iTrial = 0 To 15
    For $jTrial = 0 To 4
        $aTrialPhases[$iTrial][$jTrial] = $g_aPhases[$iTrial][$jTrial]
    Next
Next
$g_aPhases = $aTrialPhases