# Terminal Snake Game
A classic Snake game implemented entirely in Bash shell script with real-time terminal controls.

[![MIT License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Bash Version](https://img.shields.io/badge/Bash-4.0+-blue.svg)]()

---

## Description
This project is a fully functional Snake game that runs directly in the terminal using pure Bash scripting. It demonstrates advanced shell programming techniques including real-time input handling, terminal manipulation, game loop architecture, and collision detection. The game features smooth controls, score tracking, and a polished Unicode-based interface without requiring any external dependencies or libraries.

## Features
- Real-time gameplay with smooth controls using WASD or Arrow Keys
- Non-blocking input handling for instant response without pressing Enter
- Collision detection for both wall boundaries and self-collision
- Score tracking with 10 points awarded per food item collected
- Unicode box-drawing characters for clean visual presentation
- Automatic terminal state restoration on exit or interrupt
- Adjustable game speed for difficulty customization
- Pure Bash implementation with zero external dependencies

## Requirements

### Hardware
- Computer with Unix-like operating system
- Keyboard with standard input keys
- Terminal emulator with Unicode support

### Software
- Bash shell version 4.0 or higher
- Unix-like environment (Linux, macOS, or WSL on Windows)
- Terminal emulator supporting ANSI escape sequences
- Required tools:
  - stty (terminal configuration)
  - tput (terminal capability manipulation)
  - sleep (timing control)

## Wiring / Setup

### Terminal Configuration
| Setting | Value | Description |
|---------|-------|-------------|
| stty | -echo -icanon | Disable echo and canonical mode |
| tput | civis | Hide cursor during gameplay |
| tput | cnorm | Restore cursor on exit |

### Input Handling
| Key Input | Escape Sequence | Action |
|-----------|-----------------|--------|
| Up Arrow | \e[A | Move snake up |
| Down Arrow | \e[B | Move snake down |
| Right Arrow | \e[C | Move snake right |
| Left Arrow | \e[D | Move snake left |
| W Key | w/W | Move snake up |
| S Key | s/S | Move snake down |
| D Key | d/D | Move snake right |
| A Key | a/A | Move snake left |
| Q Key | q/Q | Quit game |

### Game Loop Architecture
| Component | Function | Implementation |
|-----------|----------|----------------|
| Setup | Terminal initialization | setup_terminal() |
| Input | Key reading | read_input() |
| Logic | State update | update() |
| Render | Screen drawing | draw() |
| Cleanup | Resource release | cleanup() |

## Installation
1. Download the snake_game.sh file to your local machine
2. Open a terminal in the project directory
3. Make the script executable:
   chmod +x snake_game.sh
4. Verify bash compatibility:
   bash --version
5. Run the game:
   ./snake_game.sh

## Usage
Upon launching the game, the terminal will clear and display a bordered game area with the snake positioned in the center. Use WASD keys or Arrow Keys to control the snake's direction. The objective is to guide the snake to eat the food (represented by a filled circle) which appears at random locations. Each food item consumed increases the score by 10 points and extends the snake's length by one segment. The game ends if the snake collides with the wall boundaries or runs into itself. Press Q at any time to quit the game gracefully. After game over, press any key to return to the command prompt.

## License
MIT License

## Author
Amiel Josh Basug
