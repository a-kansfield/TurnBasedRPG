# Amber's RPG Toolbox
Please note as of right now the visuals to this are very basic. My focus is making a system that can be easily retooled and applied to a variety of personal RPG projects within Godot.
Current focus is the battle system. The system itself makes heavy use of signal based architecture, but as I continue to learn more about Godot this could be subject to change.

## Roadmap
- [x] Enemy factory that randomizes each enemy from a dictionary of possible enemies, as well as the number of enemies generated.
- [x] Player factory that generates the first #n characters in the party array (Defaulted to 3).
- [x] Turn Order that sorts by each characters DEX stat.
- [x] Enemy and Character attacks. When an entities health reaches 0, they are removed from the battle and turn order. Enemy damage is based on their STR stat.
- [ ] Implement turn order functionality for player characters.
- [ ] Have the turn change automatically after enemy turn (currently a button needs to be pressed each time.)
- [ ] Sound effects and animation.
- [ ] Better character menu and base sprites.
- [ ] Adding the overworld scene and gameplay.
- [ ] Experience from battles being saved.
- [ ] Save file functionality.
- [ ] Dialog system.


