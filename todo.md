# Godot Game Jam 80
Controlled Caos

## Priority:

+ [X] ~~*Roulette*~~ **2025-04-14**
	+ [X] ~~*Expansible columns*~~ **2025-04-13**
	+ [X] ~~*Jackpot detection*~~ **2025-04-13**
	+ [X] ~~*Multiplier*~~ **2025-04-14**
	+ [X] ~~*Reroll*~~ **2025-04-14**
		* It should be capable of rerolling even by enemies (A global access)
	+ [X] ~~*Tokens*~~ **2025-04-14**
		* Each slot should have its own value marked as idk "can_be_multiplied"
+ [X] ~~*Combat System*~~ **2025-04-18**
	* [X] ~~*An turn based combat*~~ **2025-04-14**
	+ [X] ~~*Health, and general win/lose condition*~~ **2025-04-14** (I already had one)
	+ [X] ~~*Attacks*~~ **2025-04-14**` (renamed Abilities)
		* Try to reuse as much from slot if possible
		+ [X] ~~*List of events:*~~ **2025-04-14**
			+ [X] ~~*When its their turn, they will call "trigger"*~~ **2025-04-14**
	+ [X] ~~*Enemy*~~ **2025-04-14**
		+ [ ] Attacks Patterns
			* The idea is they have a "mana" system so they don´t spam the strongest attack
	+ [X] ~~*Player attack*~~ **2025-04-15**
		+ [X] ~~*Select the enemy*~~ **2025-04-15**
		+ [X] ~~*Apply the results of the roll to that enemy*~~ **2025-04-15** 
			* Depends of the token to do what they want to do
+ [X] ~~*Map Navigation*~~ **2025-04-18**
	+ [X] ~~*Walkable (Clickable) tiles*~~ **2025-04-18**
		+ [X] ~~*Enemy Tile Placement*~~ **2025-04-18** 
		+ [X] ~~*Boss Tile Placement*~~ **2025-04-18**
		+ [X] ~~*Shop Tile Placement*~~ **2025-04-18**

+ [ ] Gameplay loop
	+ [ ] Clicking play goes to a level and shows the map
	+ [ ] Clicking on a tile in the map triggers an encounter
		+ [ ] Battle encounter
			* [ ] The boss encounter just should be a special Battle
		+ [ ] General encounter
			* Im thinking a screen with different layouts
			+ [ ] Campfire encounter
			+ [ ] Treasure encounter
			+ [ ] Shop encounter

	+ [ ] Beating the boss resets the level with more floors and a new set of enemies
	+ [ ] If the player dies shows a game over screen that goes to the main screen
		+ [ ] Adds option to immediately restart the run

## After:

+ [ ] Tokens
+ [ ] Potions
+ [ ] Trinkets
+ [ ] Enemies
+ [ ] Bosses

## After after:

+ [ ] Replace any default icon with placeholder art
+ [ ] Sounds
+ [ ] Music