# NightfallStoryline FREE 1-16 (Trial)

Bot para Guild Wars Nightfall que juega solo las misiones **1 a 16** (desde Take The Shortcut hasta Blacktide Den). Al terminar la 16 muestra "Storyline completa".

> Versión de prueba gratuita. Sin cuentas, sin contraseñas, sin progreso: todo se crea al usarlo.

## Requisitos

1. **Guild Wars** instalado (cualquier ruta; se configura en el launcher).
2. **AutoIt3** (autoitscript.com) — el bot es código `.au3`, no `.exe`.
3. **Git + Git LFS** (o GitHub Desktop, que ya trae LFS) — el `GW_Launcher.exe` va por LFS.
4. Windows 10/11.

## Instalación y uso

1. Clona el repo (con LFS activado para traer el launcher).
2. Abre `GW_Launcher.exe` y añade tu cuenta (se crea `Accounts.json` solo).
3. Abre `NightfallStoryline.au3` con AutoIt3 (x86).
4. Elige la cuenta en el desplegable (salen TODAS: character, Name, title o email).
5. Pulsa **START** (con **AUTO ON** encadena fases solo hasta la 16).
6. **STOP** lo para en seco. Solo UNA instancia del bot a la vez.

Logs en vivo: `%TEMP%\gwbot\bot_live.log`.

## Fases incluidas (16)

| # | Fase | Qué hace |
|---|------|----------|
| 01 | Take The Shortcut | Salta el tutorial |
| 02 | Chahbek Village | Cobra 677, acepta 676, corre la misión M01 |
| 03 | Primary Training | Acepta 600/649 con Dehvad (verifica nombre, no homónimos) |
| 04 | Honing Your Skills | Cobra 649, viaja a Sunspear Great Hall (anti-muro) |
| 05 | Secondary Training | Segunda profesión |
| 06 | Choose Your Secondary Profession | Elige secundaria |
| 07 | Leaving A Legacy | Ferryman a Kamadan (632) |
| 08 | The Honorable General | Recluta a Koss (633) |
| 09 | Signs And Portents | Velas + ferry |
| 10 | Jokanur Diggings | Misión M02 (Kahdash escolta) |
| 11 | Isle Of The Dead | Quest 635 + Nerashi |
| 12 | Bad Tide Rising | Barco a Sun Docks |
| 13 | Special Delivery | Quest 637: pacificar Jerek, Hayao, Puuba, escolta |
| 14 | Big News, Small Package | Quest 638 con Jerek |
| 15 | Following The Trail | Quest 639: Mindhebeh, reward con Nunbe (anti lecturas rancias) |
| 16 | Blacktide Den | Misión M03: disfraz, escolta Besuz pegada, Kahyet |

## Archivos del bot

### Raíz

| Archivo | Qué es |
|---------|--------|
| `NightfallStoryline.au3` | Entrada: bucle principal, cadena de fases, watchdog anti-cuelgue (3 nudges + recuperación), viajes, lanzamiento de GW, mutex de instancia única |
| `config.ini` | Toda la configuración (fases, builds, flags debug). Sin credenciales |
| `GW_Launcher.exe` | Lanzador de cuentas v18.5 (LFS). Al abrirlo crea `Accounts.json` |
| `Accounts.json` | Cuentas del comprador (NO incluido; lo crea el launcher) |

### `gui/` (interfaz)

| Archivo | Qué es |
|---------|--------|
| `MainWindow.au3` | Ventana: lista de fases, RUN LOG (consola), cadena AUTO, resume con detección de fase real, sync lista/INI, desplegable de cuentas (todas: character/Name/title/email) |
| `Catalog.au3` | Catálogo de 58 fases con recorte TRIAL a las 16 primeras |
| `UiStatus.au3` | Panel BOT STATUS (vida, energía, misión, mapa, objetivo, coords) |

### `lib/` (librerías)

| Archivo | Qué es |
|---------|--------|
| `_Au3CheckStubs.au3` | Stubs solo para que Au3Check compile |
| `_AutoLevel.au3` | Sube atributos al subir de nivel |
| `_AutoParty.au3` | Mantiene el party (héroes/henchmen) |
| `_Bot.au3` | STOP global, wrappers de diálogo con registro (`Bot_Dialog`) |
| `_Cinematic.au3` | Detecta y salta cinemáticas |
| `_Combat.au3` | Limpieza de zona, anti-stuck, nudges LoS con verificación anti-hundimiento |
| `_CombatSkills.au3` | Rotación de skills en combate (incluye sierpe 1-4) |
| `_Equipment.au3` | Auto-equipo inicial (no toca arma equipada) |
| `_Gadgets.au3` | Interacción con gadgets (palancas, catapultas) |
| `_GameEvents.au3` | Eventos de juego (quests, diálogos, anti-idle) |
| `_GwNFAgentIDs.au3` | IDs de modelos de NPCs/bosses |
| `_Helpers.au3` | Utilidades: `MoveToFollowPath` con reagrupado de rezagados |
| `_Heroes.au3` | Builds de héroes, verificación de slots, sustitutos si falta skill, auditoría de desbloqueos |
| `_Inventory.au3` | Inventario: guadaña derviche (no toca tu arma), tirar basura |
| `_Loot.au3` | Recoger botín del suelo |
| `_Mission.au3` | Motor genérico de misiones por pasos |
| `_PartyRecovery.au3` | Resucitar al party |
| `_Quests.au3` | Aceptar/cobrar quests con verificación por NOMBRE (anti-homonimos 4751) + fallback por nombre |
| `_Recorder.au3` | Grabador de sesiones (desarrollo) |
| `_Recovery.au3` | Salidas de instancia, reintentos |
| `_Sunspear.au3` | Puntos/rango Sunspear |
| `_Travel.au3` | Viajes directos + a pie + re-instancia si el travel falla |
| `_TrialCompat.au3` | Solo TRIAL: funciones huérfanas de fases 17+ que usa el motor |
| `_UpgradeCommand.au3` | Aplicar runas por paquetes (lo necesita el framework) |

### `missions/` (fases)

| Archivo | Qué es |
|---------|--------|
| `engine/Q_CompleteQuests.au3` | Completado genérico de quests |
| `engine/Q_PrimaryQuestEngine.au3` | Motor quest primaria (navegación+combate+diálogos) |
| `phases/_phases_index.au3` | Índice: incluye las 16 fases |
| `phases/TakeTheShortcut.au3` … `phases/BlacktideDen.au3` | Las 16 fases (ver tabla arriba) |

### `GwAu3-main/API` (framework embebido)

| Ruta | Qué es |
|------|--------|
| `API/_GwAu3.au3` | Entrada del framework |
| `API/Constants/` | IDs de skills, agentes, mapas, profesiones |
| `API/Core/` | Núcleo (memoria, paquetes) |
| `API/Modules/Cmd/` | Comandos: Agent, Chat, Item, Map, Party, Quest (`Quest_ActiveQuest`), Skill, Trade |
| `API/Modules/Data/` | Lecturas de datos del juego |
| `API/Plugins/Pathfinder/` | Navegación: `GWPathfinder.dll` + `maps/` (malla). Sin esto NO se mueve |
| `API/Plugins/ChatLog/` | Registro de chat |
| `API/Plugins/UtilityAI/` | IA de combate (caché de skills, targeting) |

### `maps/` (malla de navegación, formato `ID_Campaña_Region_Nombre_Tipo.json`)

| ID | Mapa | Tipo |
|----|------|------|
| 369 | Elona Kourna JahaiBluffs | ExplorableZone |
| 371 | Elona Kourna MargaCoast | ExplorableZone |
| 373 | Elona Kourna SunwardMarches | ExplorableZone |
| 375 | Elona Kourna BarbarousShore | ExplorableZone |
| 376 | Elona Kourna CampHojanu | Outpost |
| 377 | Elona Kourna BahdokCaverns | ExplorableZone |
| 378 | Elona Kourna WehhanTerraces | Outpost |
| 379 | Elona Kourna DejarinEstate | ExplorableZone |
| 380 | Elona Kourna ArkjokWard | ExplorableZone |
| 381 | Elona Kourna YohlonHaven | Outpost |
| 382 | Elona Kourna GandaratheMoonFortress | ExplorableZone |
| 384 | Elona Kourna TheFloodplainofMahnkelon | ExplorableZone |
| 386 | Elona Kourna TuraisProcession | ExplorableZone |
| 387 | Elona Kourna SunspearSanctuary | City |
| 392 | Elona Vabbi YatendiCanyons | ExplorableZone |
| 393 | Elona Vabbi ChantryofSecrets | Outpost |
| 394 | Elona Vabbi GardenofSeborhin | ExplorableZone |
| 395 | Elona Vabbi HoldingsofChokhin | ExplorableZone |
| 396 | Elona Vabbi MihanuTownship | Outpost |
| 397 | Elona Vabbi VehjinMines | ExplorableZone |
| 398 | Elona Vabbi BasaltGrotto | Outpost |
| 399 | Elona Vabbi ForumHighlands | ExplorableZone |
| 402 | Elona Vabbi ResplendentMakuun | ExplorableZone |
| 403 | Elona Vabbi HonurHill | Outpost |
| 404 | Elona Vabbi WildernessofBahdza | ExplorableZone |
| 406 | Elona Vabbi VehtendiValley | ExplorableZone |
| 407 | Elona Vabbi YahnurMarket | Outpost |
| 413 | Elona Vabbi TheHiddenCityofAhdashim | ExplorableZone |
| 414 | Elona Vabbi TheKodashBazaar | City |
| 419 | Elona Vabbi TheMirrorofLyss | ExplorableZone |
| 421 | Elona Kourna VentaCemetery | MissionOutpost |
| 424 | Elona Kourna KodonurCrossroads | MissionOutpost |
| 425 | Elona Kourna RilohnRefuge | MissionOutpost |
| 426 | Elona Kourna PogahnPassage | MissionOutpost |
| 427 | Elona Kourna ModdokCrevice | MissionOutpost |
| 428 | Elona Vabbi TiharkOrchard | MissionOutpost |
| 429 | Elona Istan Consulate | ExplorableZone |
| 430 | Elona Istan PlainsofJarin | ExplorableZone |
| 431 | Elona Istan SunspearGreatHall | Outpost |
| 432 | Elona Istan CliffsofDohjok | ExplorableZone |
| 434 | Elona Vabbi DashaVestibule | MissionOutpost |
| 435 | Elona Vabbi GrandCourtofSebelkeh | MissionOutpost |
| 436 | Elona Kourna CommandPost | ExplorableZone |
| 437 | Elona TheDesolation JokosDomain | ExplorableZone |
| 438 | Elona TheDesolation BonePalace | Outpost |
| 439 | Elona TheDesolation TheRupturedHeart | ExplorableZone |
| 440 | Elona TheDesolation TheMouthofTorment | Outpost |
| 441 | Elona TheDesolation TheShatteredRavines | ExplorableZone |
| 442 | Elona TheDesolation LairoftheForgotten | Outpost |
| 443 | Elona TheDesolation PoisonedOutcrops | ExplorableZone |
| 444 | Elona TheDesolation TheSulfurousWastes | ExplorableZone |
| 446 | Elona TheDesolation TheAlkaliPan | ExplorableZone |
| 448 | Elona TheDesolation CrystalOverlook | ExplorableZone |
| 449 | Elona Istan KamadanJewelofIstan | City |
| 450 | RealmOfTorment DomainOfAnguish GateofTorment | City |
| 451 | RealmOfTorment DomainOfAnguish GateofAnguish | EliteMission |
| 456 | Elona Istan ChuurhirFields | ExplorableZone |
| 462 | RealmOfTorment DomainOfAnguish HeartofAbaddon | ExplorableZone |
| 465 | RealmOfTorment DomainOfAnguish NightfallenJahai | ExplorableZone |
| 466 | RealmOfTorment DomainOfAnguish DepthsofMadness | ExplorableZone |
| 468 | RealmOfTorment DomainOfAnguish DomainofFear | ExplorableZone |
| 469 | RealmOfTorment DomainOfAnguish GateofFear | Outpost |
| 470 | RealmOfTorment DomainOfAnguish DomainofPain | ExplorableZone |
| 472 | RealmOfTorment DomainOfAnguish DomainofSecrets | ExplorableZone |
| 473 | RealmOfTorment DomainOfAnguish GateofSecrets | Outpost |
| 474 | RealmOfTorment DomainOfAnguish DomainofAnguish | EliteMission |
| 476 | Elona Vabbi JennursHorde | MissionOutpost |
| 477 | Elona Kourna NunduBay | MissionOutpost |
| 478 | Elona TheDesolation GateofDesolation | MissionOutpost |
| 479 | Elona Istan ChampionsDawn | Outpost |
| 480 | Elona TheDesolation RuinsofMorah | MissionOutpost |
| 481 | Elona Istan FahranurTheFirstCity | ExplorableZone |
| 483 | Elona Istan ZehlonReach | ExplorableZone |
| 484 | Elona Istan LahtendaBog | ExplorableZone |
| 486 | Elona Istan IssnurIsles | ExplorableZone |
| 487 | Elona Istan BeknurHarbor | Outpost |
| 488 | Elona Istan MehtaniKeys | ExplorableZone |
| 489 | Elona Istan KodlonuHamlet | Outpost |
| 490 | Elona Istan IslandofShehkah | ExplorableZone |
| 491 | Elona Istan JokanurDiggings | MissionOutpost |
| 492 | Elona Istan BlacktideDen | MissionOutpost |
| 493 | Elona Kourna ConsulateDocks | MissionOutpost |
| 494 | RealmOfTorment DomainOfAnguish GateofPain | MissionOutpost |
| 495 | RealmOfTorment DomainOfAnguish GateofMadness | MissionOutpost |
| 496 | RealmOfTorment DomainOfAnguish AbaddonsGate | MissionOutpost |
| 497 | Elona Istan SunspearArena | Arena |
| 500 | Elona Vabbi BokkaAmphitheatre | ExplorableZone |
| 502 | Elona Istan TheAstralarium | Outpost |
| 503 | RealmOfTorment DomainOfAnguish ThroneofSecrets | ExplorableZone |
| 543 | Elona Istan SunDocks | ExplorableZone |
| 544 | Elona Istan ChahbekVillage | MissionOutpost |
| 559 | RealmOfTorment DomainOfAnguish GateofNightfallenLands | Outpost |
| 818 | Elona Istan KamadanJewelofIstanHalloween | City |
| 819 | Elona Istan KamadanJewelofIstanWintersday | City |
| 820 | Elona Istan KamadanJewelofIstanCanthanNewYear | City |

## Notas

- Una sola instancia del bot a la vez (hay mutex; la segunda avisa y sale).
- `.gitattributes` (LFS) y `.gitignore` deben quedarse en el repo: sin el primero no se descarga el launcher.
