# SG_Paint

## Overview
SG_Paint is a graphical paint application for DOS, developed in assembly language. The project supports basic drawing functionalities, color changes, and interaction via keyboard and mouse. The program also includes personalized greetings based on user input.

## Features
1. **Drawing Options:**
   - Paint pixels, lines, and squares on the screen.
   - Adjustable brush width for different drawing effects.

2. **Color Selection:**
   - Choose colors using keyboard shortcuts (`b` for blue, `r` for red, etc.).
   - Real-time preview of the current color.

3. **Custom Greetings:**
   - Prompts the user to identify themselves as a student, teacher, or "Segev" and provides a corresponding greeting.

4. **File Processing:**
   - Reads BMP files to display images in VGA mode.

5. **Interactive Mouse Support:**
   - Draw near the mouse pointer.
   - Mouse click detection for painting.

6. **Reset Functionality:**
   - Option to clear the screen and restart the drawing process.

## Keyboard Shortcuts
| Key   | Action                      |
|-------|-----------------------------|
| `b`   | Switch to blue color        |
| `r`   | Switch to red color         |
| `g`   | Switch to green color       |
| `w`   | Switch to white color       |
| `k`   | Switch to black color       |
| `1`   | Set brush width to 1 pixel  |
| `2`   | Set brush width to 2 pixels |
| `3`   | Set brush width to 4 pixels |
| `4`   | Set brush width to 6 pixels |
| `5`   | Set brush width to 10 pixels|
| `e`   | Exit to text mode           |
| `d`   | Delete all and restart      |

## File Structure
### Key Procedures
- **`write` (lines 162-175):** Prints messages using BP for stack-based parameter passing.
- **`pixle`:** Paints a single pixel on the screen.
- **`shora`:** Paints a horizontal row of pixels.
- **`reboa`:** Paints a square of pixels.
- **`areYouSure`:** Confirms if the user wants to clear the screen, accompanied by a sound effect.
- **`ProcessBMPFile`:** Handles opening, reading, and displaying BMP files.
- **`preView`:** Displays a preview of the currently selected color.
- **`paint`:** Main drawing function that interacts with mouse movements and applies color.

### Data Definitions
- **`color`:** Current drawing color.
- **`x` and `y`:** Coordinates for drawing.
- **`width`:** Brush width.
- **`startM`, `startG`, `endT`:** Strings for user instructions and messages.
- **`q`, `one`, `two`, `three`:** Strings for user selection prompts.

## Execution Flow
1. **Startup:**
   - Initialize VGA graphics mode and load BMP file for display.
   - Print instructions and prompts using the `write` procedure.

2. **User Input:**
   - Prompt user to identify themselves and display a greeting.
   - Wait for key or mouse input to start drawing.

3. **Drawing Mode:**
   - Enable mouse support and listen for clicks to draw on the screen.
   - Allow dynamic color and brush width changes.

4. **Reset/Exit:**
   - Provide options to clear the screen (`d`) or exit to text mode (`e`).

## Technical Notes
- **Graphics Mode:** Utilizes VGA mode (13h) for 320x200 resolution with 256 colors.
- **Mouse Handling:** Employs interrupt 33h for mouse initialization and input.
- **File Handling:** Uses DOS interrupts to open and process BMP files.
- **Sound Effects:** Configures the speaker using port 61h for feedback on reset confirmation.

## Usage Instructions
1. Run the program in a DOS environment (e.g., DOSBox).
2. Follow on-screen instructions to select colors, adjust brush width, and start drawing.
3. Use the reset option (`d`) to clear the screen or exit (`e`) to terminate the program.

## Acknowledgments
Project developed by Segev Shalom.
