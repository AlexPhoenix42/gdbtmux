# gdbtmux.sh 🚀🌈

A small Bash utility that integrates **GDB** with **tmux** for a smoother debugging experience.  
It automatically sets up a tmux session with two panes:  
- **Pane A**: runs GDB bound to the program you want to debug.  
- **Pane B**: acts as the program’s I/O terminal.  

This way, you can debug interactively while keeping input/output neatly separated.

---

## ✨ Features
- Creates a temporary tmux session for debugging.
- Automatically binds GDB to the I/O pane’s TTY.
- Auto-runs your program inside GDB.
- Cleans up the tmux session when you exit.
- Friendly exit message with a GitHub link.
- Colorful output for style.

---

## 📦 Requirements
- **bash** (with `set -euo pipefail` support)
- **tmux**
- **gdb**

Make sure these are installed and available in your `$PATH`.

---

## ⚡ Usage

```bash
./gdbtmux.sh /path/to/program [args...]
```

Example:

```bash
./gdbtmux.sh ./minishell -v --debug
```

This will:
1. Start a new tmux session named `debug-<pid>`.
2. Split the window into two panes:
   - Top pane: GDB running your program.
   - Bottom pane: program I/O.
3. Attach to the session so you can debug interactively.
4. Clean up automatically when GDB exits.

---

## 🛠 How It Works
1. Creates a tmux session with two panes.
2. Captures the TTY of the I/O pane.
3. Launches GDB in the main pane, binding it to the I/O pane’s TTY.
4. Sends some extra GDB key sequences for layout convenience.
5. After you close GDB do ctrl+d to close the left tmux panel.

---

## 📜 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## 🔗 Powered by github.com/AlexPhoenix42 🌈🚀
Inspired by the need for a cleaner debugging workflow with tmux + gdb.
