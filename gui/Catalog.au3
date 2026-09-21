#include-once
Global $g_aPhases[][] = [ _
        ["SkipTutorial_P1",           "Take The Shortcut - Parte 1",              "pending", "Tutorial",                      "primary"], _
        ["SkipTutorial_P2",           "Take The Shortcut - Parte 2",              "pending", "Tutorial",                      "primary"], _
        ["SkipTutorial_P3",           "Take The Shortcut - Parte 3",              "pending", "Tutorial",                      "primary"], _
        ["RewardM01",                 "Chahbek Village",             "pending", "M01 Chahbek Village",           "coop"   ], _
        ["PrimaryTraining",           "Primary Training",                                   "pending", "Primary Training",              "primary"], _
        ["HoningYourSkills",          "Honing Your Skills",                                 "pending", "Honing Your Skills",            "primary"], _
        ["SecondaryTraining",         "Secondary Training",                                 "pending", "Secondary Training",            "primary"], _
        ["ChooseSecondaryProfession", "Choose Your Secondary Profession",                   "pending", "Choose Your Secondary",         "primary"], _
        ["LeavingALegacy",            "Leaving A Legacy",                                   "pending", "Leaving A Legacy",              "primary"], _
        ["TheHonorableGeneral",       "The Honorable General",                              "pending", "The Honorable General",         "primary"], _
        ["SignsAndPortents",          "Signs And Portents",                                 "pending", "Signs And Portents",            "primary"], _
        ["M02_JokanurDiggings",       "Jokanur Diggings",         "pending", "M02 Jokanur Diggings",          "coop"   ], _
        ["IsleOfTheDead",             "Isle Of The Dead",                                   "pending", "Isle Of The Dead",              "primary"], _
        ["BadTideRising",             "Bad Tide Rising",                                    "pending", "Bad Tide Rising",               "primary"], _
        ["SpecialDelivery",           "Special Delivery",                                   "pending", "Special Delivery",              "primary"], _
        ["BigNewsSmallPackage",       "Big News, Small Package",                            "pending", "Big News, Small Package",       "primary"], _
        ["FollowingTheTrail",         "Following The Trail",                                "pending", "Following The Trail",           "primary"], _
        ["M03_BlacktideDen",          "Blacktide Den",           "pending", "M03 Blacktide Den",             "coop"   ], _
        ["TheIronTruth",              "The Iron Truth",                                     "pending", "The Iron Truth",                "primary"], _
        ["TrialByFire",               "Trial By Fire",                                      "pending", "Trial By Fire",                 "primary"], _
        ["WarPrep_GhostRecon",        "War Preparations (Ghost Recon)",                     "pending", "War Preparations",              "primary"], _
        ["WarPrep_RecruitTraining",   "War Preparations (Recruit Training)",                "pending", "War Preparations",              "primary"], _
        ["WarPrep_WindAndWater",      "War Preparations (Wind And Water)",                  "pending", "War Preparations",              "primary"], _
        ["TheTimeIsNigh",             "The Time Is Nigh",               "pending", "The Time Is Nigh",              "primary"], _
        ["M04_ConsulateDocks",        "Consulate Docks",          "pending", "M04 Consulate Docks",           "coop"   ], _
        ["Hunted",                    "Hunted!",                                            "pending", "Hunted!",                       "primary"], _
        ["TheGreatEscape",            "The Great Escape",                                   "pending", "The Great Escape",              "primary"], _
        ["AndAHeroShallLeadThem",     "And A Hero Shall Lead Them",                         "pending", "And a Hero Shall Lead",         "primary"], _
        ["M05_VentaCemetery",         "Venta Cemetery",              "pending", "M05 Venta Cemetery",            "coop"   ], _
        ["TheCouncilIsCalled",        "The Council Is Called",                              "pending", "The Council Is Called",         "primary"], _
        ["ToVabbi",                   "To Vabbi!",                                          "pending", "To Vabbi!",                     "primary"], _
        ["CentaurBlackmail",          "Centaur Blackmail",                                  "pending", "Centaur Blackmail",             "primary"], _
        ["M06_KodonurCrossroads",     "Kodonur Crossroads","pending", "M06 Kodonur Crossroads",       "coop"   ], _
        ["MysteriousMessage",         "Mysterious Message",                                 "pending", "Mysterious Message",            "primary"], _
        ["SecretsInTheShadow",        "Secrets In The Shadow",                              "pending", "Master of Whispers path",       "primary"], _
        ["ToKillADemon",              "To Kill A Demon",                                    "pending", "Master of Whispers path",       "primary"], _
        ["M07_RilohnRefuge",          "Rilohn Refuge", "pending", "M07 Rilohn Refuge",             "coop"   ], _
        ["M08_ModdokCrevice",         "Moddok Crevice",           "pending", "M08 Moddok Crevice",            "coop"   ], _
        ["RallyThePrinces",           "Rally The Princes",                                  "pending", "Rally The Princes",             "primary"], _
        ["M09_TiharkOrchard",         "Tihark Orchard",                                     "pending", "M09 Tihark Orchard",            "coop"   ], _
        ["AllsWellThatEndsWell",      "All's Well That Ends Well",                          "pending", "All's Well That Ends Well",     "primary"], _
        ["WarningKehanni",            "Warning Kehanni",                                    "pending", "Warning Kehanni",               "primary"], _
        ["CallingTheOrder",           "Calling The Order",                                  "pending", "Master of Whispers path",       "primary"], _
        ["M10_DzagonurBastion",       "Dzagonur Bastion","pending", "M10 Dzagonur Bastion",        "coop"   ], _
        ["PledgeOfMerchantPrinces",   "Pledge Of The Merchant Princes",                     "pending", "Pledge of the Princes",        "primary"], _
        ["M11_GrandCourtSebelkeh",    "Grand Court Of Sebelkeh", "pending", "M11 Grand Court Sebelkeh",     "coop"   ], _
        ["AttackAtTheKodash",         "Attack At The Kodash",                               "pending", "Attack At The Kodash",         "primary"], _
        ["HeartOrMindRonjokInDanger", "Heart Or Mind: Ronjok In Danger",                    "pending", "Heart or Mind",                "primary"], _
        ["M12_NunduBay",              "Nundu Bay",                "pending", "M12 Nundu Bay",                 "coop"   ], _
        ["CrossingTheDesolation",     "Crossing The Desolation",                            "pending", "Crossing The Desolation",      "primary"], _
        ["M13_GateOfDesolation",      "Gate Of Desolation","pending", "M13 Gate of Desolation",      "coop"   ], _
        ["ADealsADeal",               "A Deal's A Deal",                                    "pending", "A Deal's A Deal",              "primary"], _
        ["HordeOfDarkness",           "Horde Of Darkness",                                  "pending", "Horde Of Darkness",            "primary"], _
        ["M14_RuinsOfMorah",          "Ruins Of Morah",   "pending", "M14 Ruins of Morah",           "coop"   ], _
        ["UnchartedTerritory",        "Uncharted Territory",                                "pending", "Uncharted Territory",          "primary"], _
        ["M15_GateOfPain",            "Gate Of Pain",             "pending", "M15 Gate of Pain",             "coop"   ], _
        ["KormirsCrusade",            "Kormir's Crusade",                                   "pending", "Kormir's Crusade",             "primary"], _
        ["AllAloneInTheDarkness",     "All Alone In The Darkness",                          "pending", "All Alone In The Darkness",    "primary"], _
        ["M16_GateOfMadness",         "Gate Of Madness",                                    "pending", "M16 Gate of Madness",          "coop"   ], _
        ["M17_AbaddonsGate",          "Abaddon's Gate",                                     "pending", "M17 Abaddon's Gate",           "coop"   ]  _
]

Global $g_bTrialMode = True
Local $aTrialPhases[18][5]
For $iTrial = 0 To 17
    For $jTrial = 0 To 4
        $aTrialPhases[$iTrial][$jTrial] = $g_aPhases[$iTrial][$jTrial]
    Next
Next
$g_aPhases = $aTrialPhases