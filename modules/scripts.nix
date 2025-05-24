{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (writeShellScriptBin "build" ''
      #!/usr/bin/env bash
      set -e
      # configuration settings
      REPO_URL="https://github.com/chuckyute/mynix.git"
      CONFIG_DIR="$HOME/mynix"
      # check if directory exists
      if [ ! -d "$CONFIG_DIR" ]; then
        echo "Configuration directory not found. Cloning from GitHub..."
        git clone $REPO_URL $CONFIG_DIR
        cd $CONFIG_DIR
      else
        # if exists pull latest changes
        cd $CONFIG_DIR
        echo "Pulling latest configuration from GitHub..."
        git pull
      fi
      echo "Building NixOS configuration..."
      nixos-rebuild build --flake .#nixos
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
      echo "Rebuilding and switching to updated system..."
      sudo nixos-rebuild switch --flake .#nixos
      echo "System update successfull"
      cd -
    '')
    (writeShellScriptBin "rebuild" ''
      #!/usr/bin/env bash
      set -e
      cd $HOME/mynix
      # Fix permissions if needed - check for root-owned subdirectories
      if [ ! -w ".git/objects" ] || find .git/objects -type d ! -user $(whoami) | grep -q .; then
        echo "Fixing repository permissions..."
        sudo chown -R $(whoami):$(id -gn) .
        sudo chmod -R u+rw .
      fi
      if ! git diff --quiet || ! git diff --staged --quiet; then
        echo "Committing Configuration changes..."
        git add .
        git commit
      fi
      echo "Building and switching to new configuration.."
      sudo nixos-rebuild switch --flake .#nixos
      echo "Pushing changes to repository..."
      git push
      echo "Rebuild and push completed successfully"    '')
    (writeShellScriptBin "clean" ''
      #!/usr/bin/env bash
      set -e
      echo "Running garbage collection ..."
      echo "Removing old generations..."
      sudo nix-collect-garbage -d
      echo "Removing unused store paths..."
      sudo nix-store --gc
      echo "Cleaning complete. Current store size:"
      du -sh /nix/store
    '')
  ];
}
