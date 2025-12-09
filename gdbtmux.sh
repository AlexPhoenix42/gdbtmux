#!/usr/bin/env bash
# gdbtmux.sh
# Usage: ./minishell [args...]

set -euo pipefail

# Colors (optional, for styling)
MAGENTA="\033[1;35m"
RESET="\033[0m"

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 /path/to/program [args...]"
  exit 1
fi

prog=$1
shift
session="debug-$$"

# On exit: kill only the tmux session we created and print a friendly message
trap 'tmux kill-session -t "$session" 2>/dev/null || true;
      echo -e "\e]8;;https://github.com/AlexPhoenix42\e\\Powered by ${MAGENTA}github.com/AlexPhoenix42${RESET} 🌈🚀\e]8;;\e\\"' EXIT

# 1. Create a new session with a shell in pane A
tmux new-session -d -s "$session" "bash"

# 2. Split horizontally (top/bottom) for the I/O pane
tmux split-window -v -t "$session" "sleep infinity"

# 3. Capture pane IDs
pane_ids=($(tmux list-panes -t "$session" -F '#{pane_id}'))
pane_a=${pane_ids[0]}   # first pane (GDB)
pane_b=${pane_ids[1]}   # second pane (I/O)

# 4. Get tty of pane B
TTY=$(tmux display -p -t "$pane_b" '#{pane_tty}')
if [[ -z "$TTY" || ! -e "$TTY" ]]; then
  echo "Failed to get pane tty: '$TTY'"
  exit 1
fi

# 5. Launch gdb in pane A, bound to pane B’s tty, and auto-run
tmux send-keys -t "$pane_a" \
  "gdb --quiet --tty=$TTY --args \"$prog\" $* -ex 'set startup-with-shell off' -ex run" C-m

# 6. Send extra keys to GDB pane (like your other script)
tmux send-keys -t "$pane_a" C-x
tmux send-keys -t "$pane_a" 1
tmux send-keys -t "$pane_a" C-x
tmux send-keys -t "$pane_a" o
tmux send-keys -t "$pane_a" C-l

# 7. ensure panes close when their command exits, and kill session when GDB exits
tmux set-option -t "$session" remain-on-exit off
tmux set-hook   -t "$session" pane-exited "kill-session"

# 8. Ensure focus is on the GDB pane
tmux select-pane -t "$pane_a"

# 9. Attach to the session
tmux attach -t "$session"
