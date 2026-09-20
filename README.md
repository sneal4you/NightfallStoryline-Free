# Nightfall Storyline Free

An AutoIt bot for the Guild Wars Nightfall campaign. The free edition includes phases 1 to 16, from **Take The Shortcut** through **Blacktide Den**.

## Requirements

- Windows 10 or 11
- Guild Wars with the Nightfall campaign installed
- [AutoIt](https://www.autoitscript.com/site/autoit/downloads/) to run the `.au3` source files
- GW Launcher, if you want the bot to start a configured account automatically

## Installation

1. Download the repository as a ZIP file and extract it to a permanent folder.
2. Install AutoIt and open `NightfallStoryline.au3` with AutoIt x86.
3. Configure your character and build options in `config.ini`.
4. If you use GW Launcher, download it from the project Releases page and place `GW_Launcher.exe` beside `NightfallStoryline.au3`.
5. Start Guild Wars or select an account from the bot. Choose a phase and press **START**.

Use **AUTO ON** to continue through the included phases automatically. **STOP** pauses the active run.

## Included Phases

| # | Phase |
| --- | --- |
| 01 | Take The Shortcut |
| 02 | Chahbek Village |
| 03 | Primary Training |
| 04 | Honing Your Skills |
| 05 | Secondary Training |
| 06 | Choose Your Secondary Profession |
| 07 | Leaving A Legacy |
| 08 | The Honorable General |
| 09 | Signs And Portents |
| 10 | Jokanur Diggings |
| 11 | Isle Of The Dead |
| 12 | Bad Tide Rising |
| 13 | Special Delivery |
| 14 | Big News, Small Package |
| 15 | Following The Trail |
| 16 | Blacktide Den |

## Project Layout

| Path | Description |
| --- | --- |
| `NightfallStoryline.au3` | Main entry point. Starts the bot and coordinates phase execution. |
| `config.ini` | User configuration for character, builds, and runtime options. |
| `GW_Launcher.exe` | Optional account launcher. It will be distributed through Releases instead of Git LFS. |
| `gui/` | Bot interface: phase list, controls, activity log, and live status panel. |
| `gui/MainWindow.au3` | Main application window and user controls. |
| `gui/Catalog.au3` | Phase catalogue shown by the interface. |
| `gui/UiStatus.au3` | Live game and bot status display. |
| `missions/` | Campaign phase scripts and their shared mission engines. |
| `missions/phases/` | Individual scripts for the phases included in this edition. |
| `missions/engine/` | Shared helpers used to complete quests and mission objectives. |
| `lib/` | Shared bot features such as travel, party handling, combat, inventory, and recovery. |
| `GwAu3-main/API/` | Embedded GWAU3 framework used to read game state and interact with Guild Wars. |

## Free Edition Scope

This edition is limited to the first 16 Nightfall phases. It is intended as a trial version and does not include paid-edition content.

## Support

Join the Discord server for setup help, updates, and known issues:

https://discord.gg/378MDSMdrF

When reporting an issue, include the phase name, what you expected, what happened, and a screenshot or relevant log lines.
