# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A NixOS flake managing two machines for user `chuck`:
- **nixdesktop** — Intel CPU + NVIDIA GPU desktop
- **nixframe** — Framework 16 laptop (AMD AI 9 HX 370 + RX 7700S dGPU)

## Key commands

There are custom scripts in `modules/scripts.nix` for day-to-day use:

- `rebuild` — commits any uncommitted changes, runs `nixos-rebuild switch` for the current host (auto-detected via `hostname`), then pushes
- `update` — runs `nix flake update` then `nixos-rebuild switch`
- `build` — pulls latest from GitHub and runs `nixos-rebuild build` (no switch, no commit)
- `clean` — runs garbage collection and store cleanup

Use `rebuild` as the normal workflow after making changes. Direct `nixos-rebuild` calls are only needed for dry-run checks:
```bash
nixos-rebuild dry-build --flake .#nixframe
```

## Architecture

```
flake.nix              # Entry point; defines both nixosConfigurations
nixos-common.nix       # Shared NixOS config for all hosts (boot, networking, audio, steam, etc.)
home.nix               # Shared home-manager config for chuck (packages, git, session vars)
hosts/
  nixdesktop/          # NVIDIA-specific config + hardware-configuration.nix
  nixframe/            # AMD/Framework-specific config + hardware-configuration.nix
modules/
  stylix.nix           # Theming (shared, imported per-host from hosts/<name>/configuration.nix)
  hyprland/
    default.nix        # Shared Hyprland home-manager config
    nixdesktop.nix     # Desktop-specific Hyprland (monitor layout, etc.)
    nixframe.nix       # Laptop-specific Hyprland
  nvim/                # Neovim config: default.nix + lua files (lsp, cmp, telescope, treesitter)
  ghostty.nix          # Terminal emulator config
  waybar.nix           # Status bar config
  yazi.nix             # File manager config
  scripts.nix          # Custom shell scripts
```

### How host configs are wired

`flake.nix` builds each host by combining:
1. `sharedModules` — stylix, hyprland nixos module, home-manager nixos module
2. `hosts/<name>/configuration.nix` — imports `nixos-common.nix`, `modules/stylix.nix`, and hardware config
3. A host-specific Hyprland home-manager module (`modules/hyprland/<name>.nix`) passed via `hmModule`

Home-manager runs as a NixOS module (`useGlobalPkgs = true`, `useUserPackages = true`). The shared `home.nix` is always imported; the host-specific Hyprland module is added on top.

## Flake inputs

- `nixpkgs` — nixos-unstable channel
- `nixos-hardware` — used only by nixframe for Framework 16 AMD module
- `home-manager` — follows nixpkgs
- `stylix` — theming, follows nixpkgs
- `hyprland` — built from source (git), follows nixpkgs
- `claude-code` — `github:sadjow/claude-code-nix`
