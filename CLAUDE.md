# NixOS Flake Configuration

Personal NixOS configuration for a single desktop host (`paris-nix0`).

## Structure

```
├── flake.nix                 # Main entry: inputs, outputs, devshells
├── nixos/                    # System configuration
│   ├── configuration.nix     # Core system: boot, networking, services
│   ├── hardware-configuration.nix  # Auto-generated hardware
│   └── nvidia.nix            # NVIDIA drivers + CUDA
├── hosts/desktop/fonts/      # Font configuration
├── home/                     # Home-manager configuration
│   ├── home.nix              # Main user config, packages
│   └── programs/             # Per-program modules
│       ├── hypr/             # Hyprland window manager
│       ├── waybar/           # Status bar
│       ├── alacritty/        # Terminal
│       ├── zsh/              # Shell + powerlevel10k
│       ├── tmux/             # Multiplexer
│       └── bash/             # Fallback shell
├── devshells/                # Development environments
│   ├── cuda-shell.nix        # CUDA development (gcc13)
│   ├── c-cpp-shell.nix       # C/C++ toolchain
│   ├── python312-shell.nix   # Python 3.12
│   ├── shared-utils.nix      # Common utilities
│   └── c-cpp-utils.nix       # C/C++ build deps
└── home/scripts/             # User scripts (symlinked to ~/.scripts)
```

## Key Flake Inputs

- `nixpkgs`: nixos-unstable (unfree allowed)
- `home-manager`: follows nixpkgs
- `paris-nixvim`: custom neovim config (external flake)
- `claude-code`: Claude Code CLI

## System Overview

- **User**: bruno (wheel, docker, scanner, lp groups)
- **Locale**: fr_FR.UTF-8, AZERTY keyboard
- **Desktop**: Hyprland (Wayland) + PipeWire audio
- **GPU**: NVIDIA with stable drivers, CUDA toolkit
- **Services**: Docker, SSH, CUPS printing, Flatpak

## Development Shells

```bash
nix develop .#cuda       # CUDA with gcc13
nix develop .#cCpp       # C/C++ toolchain
nix develop .#python312  # Python 3.12 + pip/virtualenv
```

## Rebuilding

```bash
sudo nixos-rebuild switch --flake .#paris-nix0  # System
home-manager switch --flake .#bruno             # Home only
```

## Configuration Patterns

- Programs are modular: each in `home/programs/<name>/default.nix`
- Config files often split: nix wrapper + raw config (e.g., `hyprland.config`)
- Devshells use composable utility sets (`sharedInputs`, `cCppInputs`)
- External flake inputs passed via `specialArgs = { inherit inputs; }`

## Notable Files

- `home/programs/hypr/hyprland.config`: Hyprland keybinds and settings
- `home/programs/waybar/style.css`: Catppuccin-themed status bar
- `home/programs/zsh/p10k-config/`: Powerlevel10k theme
- `nixos/nvidia.nix`: GPU setup with container toolkit support
