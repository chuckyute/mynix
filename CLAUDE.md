# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A NixOS flake managing two machines for user `chuck`:
- **nixdesktop** — Intel CPU + NVIDIA GPU desktop
- **nixframe** — Framework 16 laptop (AMD AI 9 HX 370 + RX 7700S dGPU)

## Key commands

Rebuild and switch the current host:
```bash
sudo nixos-rebuild switch --flake .#nixdesktop
sudo nixos-rebuild switch --flake .#nixframe
```

Test a build without switching (dry run):
```bash
nixos-rebuild dry-build --flake .#nixdesktop
```

Update flake inputs:
```bash
nix flake update
```

Check flake for errors:
```bash
nix flake check
```

Format nix files (if alejandra or nixfmt is available):
```bash
nix fmt
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
