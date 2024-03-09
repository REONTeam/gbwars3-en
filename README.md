## To-Do

- Import the remaining text.
- Identify missing pointers.
- Add section_ends as needed.
- Add section fragments for translated text that doesn't fit.
- Split edited image data from [main.asm](main.asm) into image files.
- Split the Campaign Mode briefings from bank[$33] into bank[$33] and bank[$34].
- Move the Beginner Mode briefings from bank[$25] to bank[$35].
- Shift the cursor for the second and third positions of the Map Menu left one on both rows.
- Attempt to increase map names from 8 to 9 characters.
	- Visually all menus already have enough space.
	- Names would need to be shifted back one byte at the start of each map's data.
	- Pointers would need to be found and updated to account for this.
- Unit Status's subscreens have headers that point to the same strings as the main screen, need to identify those and update them.
- The coordinates for the Initiative value on the unit status screen need to be found and shifted 3 tiles to the right.
- The Editor submenus require a bit of coordinate adjusting, various things need extra space.
    - Specifically, MAP, should be changed to TERRAIN, in the terrain placement submenu, but that means shifting the terrain name after it.