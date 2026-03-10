# modules/scripts.nix
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (writeShellScriptBin "build" ''
      #!/usr/bin/env bash
      set -e
      REPO_URL="https://github.com/chuckyute/mynix.git"
      CONFIG_DIR="$HOME/mynix"
      if [ ! -d "$CONFIG_DIR" ]; then
        echo "Configuration directory not found. Cloning from GitHub..."
        git clone $REPO_URL $CONFIG_DIR
        cd $CONFIG_DIR
      else
        cd $CONFIG_DIR
        echo "Pulling latest configuration from GitHub..."
        git pull
      fi
      echo "Building NixOS configuration for $(hostname)..."
      nixos-rebuild build --flake .#$(hostname)
      echo "Build completed successfully."
      cd -
    '')

    (writeShellScriptBin "update" ''
      #!/usr/bin/env bash
      set -e
      echo "Updating flake inputs..."
      cd $HOME/mynix
      if [ ! -w ".git/objects" ] || find .git/objects -type d ! -user $(whoami) | grep -q .; then
        echo "Fixing repository permissions..."
        sudo chown -R $(whoami):$(id -gn) .
        sudo chmod -R u+rw .
      fi
      nix flake update
      echo "Rebuilding and switching to updated system ($(hostname))..."
      sudo nixos-rebuild switch --flake .#$(hostname)
      echo "System update successful"
      cd -
    '')

    (writeShellScriptBin "rebuild" ''
      #!/usr/bin/env bash
      set -e
      cd $HOME/mynix
      if [ ! -w ".git/objects" ] || find .git/objects -type d ! -user $(whoami) | grep -q .; then
        echo "Fixing repository permissions..."
        sudo chown -R $(whoami):$(id -gn) .
        sudo chmod -R u+rw .
      fi
      if ! git diff --quiet || ! git diff --staged --quiet; then
        echo "Committing configuration changes..."
        git add .
        git commit
      fi
      echo "Building and switching to new configuration ($(hostname))..."
      sudo nixos-rebuild switch --flake .#$(hostname)
      echo "Pushing changes to repository..."
      git push
      echo "Rebuild and push completed successfully"
    '')

    (writeShellScriptBin "clean" ''
      #!/usr/bin/env bash
      set -e
      echo "Running garbage collection..."
      echo "Removing old generations..."
      sudo nix-collect-garbage -d
      echo "Removing unused store paths..."
      sudo nix-store --gc
      echo "Cleaning complete. Current store size:"
      du -sh /nix/store
    '')
  ];
}
