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
