#!/bin/bash

# Terminal Snake Game - Fixed Input Version
# A portfolio-ready shell script game with robust controls

# Game configuration
GAME_SPEED=0.08
GRID_WIDTH=40
GRID_HEIGHT=20

# Initialize terminal
setup_terminal() {
  # Save terminal settings
  old_stty=$(stty -g)
  # Disable echo and canonical mode, enable non-blocking read
  stty -echo -icanon min 0 time 0
  # Hide cursor
  tput civis 2>/dev/null || echo -ne "\e[?25l"
  # Clear screen
  clear
}

# Restore terminal settings
cleanup() {
  stty "$old_stty" 2>/dev/null
  tput cnorm 2>/dev/null || echo -ne "\e[?25h"
  clear
  echo "Thanks for playing! Final Score: $score"
  exit 0
}

# Trap signals to ensure cleanup
trap cleanup EXIT INT TERM

# Draw box drawing characters
draw_border() {
  local width=$1
  local height=$2
  local start_row=$3
  local start_col=$4

  # Top border
  tput cup $start_row $start_col
  printf "┌"
  for ((i = 0; i < width; i++)); do printf "─"; done
  printf "┐"

  # Side borders
  for ((i = 1; i <= height; i++)); do
    tput cup $((start_row + i)) $start_col
    printf "│"
    tput cup $((start_row + i)) $((start_col + width + 1))
    printf "│"
  done

  # Bottom border
  tput cup $((start_row + height + 1)) $start_col
  printf "└"
  for ((i = 0; i < width; i++)); do printf "─"; done
  printf "┘"
}

# Initialize game state
init_game() {
  score=0
  game_over=0
  direction="RIGHT"
  next_direction="RIGHT"

  # Initialize snake in the middle
  snake_x=($((GRID_WIDTH / 2)) $((GRID_WIDTH / 2 - 1)) $((GRID_WIDTH / 2 - 2)))
  snake_y=($((GRID_HEIGHT / 2)) $((GRID_HEIGHT / 2)) $((GRID_HEIGHT / 2)))

  # Place first food
  place_food
}

# Place food at random position not occupied by snake
place_food() {
  while true; do
    food_x=$((RANDOM % GRID_WIDTH))
    food_y=$((RANDOM % GRID_HEIGHT))

    # Check if food overlaps with snake
    overlap=0
    for ((i = 0; i < ${#snake_x[@]}; i++)); do
      if [[ ${snake_x[$i]} -eq $food_x && ${snake_y[$i]} -eq $food_y ]]; then
        overlap=1
        break
      fi
    done

    [[ $overlap -eq 0 ]] && break
  done
}

# Read input with proper handling for escape sequences
read_input() {
  local key
  local esc

  # Read first character
  IFS= read -rs -t 0.001 key

  if [[ -n "$key" ]]; then
    # Check if it's an escape sequence (arrow keys)
    if [[ "$key" == $'\e' ]]; then
      # Read the rest of the escape sequence with slight delay
      IFS= read -rs -t 0.001 esc
      if [[ "$esc" == "[" ]]; then
        IFS= read -rs -t 0.001 esc
        case "$esc" in
        A) [[ $direction != "DOWN" ]] && next_direction="UP" ;;
        B) [[ $direction != "UP" ]] && next_direction="DOWN" ;;
        C) [[ $direction != "LEFT" ]] && next_direction="RIGHT" ;;
        D) [[ $direction != "RIGHT" ]] && next_direction="LEFT" ;;
        esac
      fi
    else
      # Regular keys (WASD and Q)
      case "$key" in
      [wW]) [[ $direction != "DOWN" ]] && next_direction="UP" ;;
      [sS]) [[ $direction != "UP" ]] && next_direction="DOWN" ;;
      [dD]) [[ $direction != "LEFT" ]] && next_direction="RIGHT" ;;
      [aA]) [[ $direction != "RIGHT" ]] && next_direction="LEFT" ;;
      [qQ]) game_over=2 ;;
      esac
    fi
  fi
}

# Update game state
update() {
  direction=$next_direction

  # Calculate new head position
  local head_x=${snake_x[0]}
  local head_y=${snake_y[0]}

  case $direction in
  UP) ((head_y--)) ;;
  DOWN) ((head_y++)) ;;
  LEFT) ((head_x--)) ;;
  RIGHT) ((head_x++)) ;;
  esac

  # Check wall collision
  if [[ $head_x -lt 0 || $head_x -ge $GRID_WIDTH || $head_y -lt 0 || $head_y -ge $GRID_HEIGHT ]]; then
    game_over=1
    return
  fi

  # Check self collision
  for ((i = 0; i < ${#snake_x[@]}; i++)); do
    if [[ ${snake_x[$i]} -eq $head_x && ${snake_y[$i]} -eq $head_y ]]; then
      game_over=1
      return
    fi
  done

  # Move snake
  snake_x=($head_x "${snake_x[@]}")
  snake_y=($head_y "${snake_y[@]}")

  # Check food collision
  if [[ $head_x -eq $food_x && $head_y -eq $food_y ]]; then
    ((score += 10))
    place_food
  else
    # Remove tail if no food eaten
    unset 'snake_x[${#snake_x[@]}-1]'
    unset 'snake_y[${#snake_y[@]}-1]'
  fi
}

# Render game
draw() {
  # Clear game area
  for ((y = 0; y < GRID_HEIGHT; y++)); do
    tput cup $((y + 1)) 1
    printf "%${GRID_WIDTH}s" ""
  done

  # Draw snake
  for ((i = 0; i < ${#snake_x[@]}; i++)); do
    tput cup $((snake_y[i] + 1)) $((snake_x[i] + 1))
    if [[ $i -eq 0 ]]; then
      printf "▓"
    else
      printf "░"
    fi
  done

  # Draw food
  tput cup $((food_y + 1)) $((food_x + 1))
  printf "●"

  # Draw score
  tput cup 0 $((GRID_WIDTH + 4))
  printf "Score: %d" "$score"

  # Draw controls
  tput cup $((GRID_HEIGHT + 3)) 0
  printf "Controls: WASD | Q to Quit"
}

# Game over screen
show_game_over() {
  local msg="GAME OVER!"
  local score_msg="Final Score: $score"
  local center_x=$((GRID_WIDTH / 2 - ${#msg} / 2 + 1))
  local center_y=$((GRID_HEIGHT / 2))

  tput cup $center_y $center_x
  printf "\e[1;31m%s\e[0m" "$msg"
  tput cup $((center_y + 1)) $((center_x + 2))
  printf "\e[33m%s\e[0m" "$score_msg"

  tput cup $((GRID_HEIGHT + 5)) 0
  printf "Press any key to exit..."

  # Wait for key press
  while IFS= read -rs -t 0.1 key; do :; done
  IFS= read -rs -n1 key
}

# Main game loop
main() {
  setup_terminal

  # Draw border
  draw_border $GRID_WIDTH $GRID_HEIGHT 0 0

  init_game

  # Main loop
  while [[ $game_over -eq 0 ]]; do
    read_input
    update
    [[ $game_over -eq 0 ]] && draw
    sleep $GAME_SPEED
  done

  if [[ $game_over -eq 1 ]]; then
    show_game_over
  fi
}

# Start the game
main
