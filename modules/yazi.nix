{ pkgs, ... }:
{
  home.packages = with pkgs; [
    yazi
    unar
  ];

  programs.yazi = {
    enable = true;
    enableBashIntegration = true;

    settings = {
      manager = {
        show_hidden = true;
      };

      which = {
        sort_by = "key";
      };

      opener = {
        edit = [
          {
            run = "nvim \"$@\"";
            block = true;
            desc = "Edit with nvim";
          }
        ];

        extract = [
          {
            run = "unar \"$@\"";
            desc = "Extract archive";
          }
        ];
      };
    };

    keymap = {
      manager.prepend_keymap = [
        {
          on = [ "j" ];
          run = "arrow next";
          desc = "Move down";
        }
        {
          on = [ "k" ];
          run = "arrow prev";
          desc = "Move up";
        }
        {
          on = [ "h" ];
          run = "leave";
          desc = "Go back/up directory";
        }
        {
          on = [ "l" ];
          run = "enter";
          desc = "Enter directory/open file";
        }
        {
          on = [ "<Esc>" ];
          run = "escape";
          desc = "Escape";
        }
        {
          on = [
            "g"
            "g"
          ];
          run = "arrow top";
          desc = "Go to top";
        }
        {
          on = [ "G" ];
          run = "arrow bot";
          desc = "Go to bottom";
        }
        {
          on = [ "H" ];
          run = "back";
          desc = "Go back (history)";
        }
        {
          on = [ "L" ];
          run = "forward";
          desc = "Go forward (history)";
        }
        {
          on = [ "v" ];
          run = "visual_mode";
          desc = "Enter visual mode";
        }
        {
          on = [ "V" ];
          run = "visual_mode --unset";
          desc = "Exit visual mode unset";
        }
        # Preview navigation
        {
          on = [ "K" ];
          run = "seek -5";
          desc = "Scroll preview up";
        }
        {
          on = [ "J" ];
          run = "seek 5";
          desc = "Scroll preview down";
        }
        # Search operations
        {
          on = [ "/" ];
          run = "find";
          desc = "Find files (incremental)";
        }
        {
          on = [ "f" ];
          run = "filter";
          desc = "Filter files";
        }
        {
          on = [
            "s"
            "f"
          ];
          run = "plugin fzf";
          desc = "Search files with fzf";
        }
        {
          on = [
            "s"
            "g"
          ];
          run = "search --via=rg";
          desc = "Search content (ripgrep)";
        }
        # File operations
        {
          on = [ "i" ];
          run = "create";
          desc = "Create file/directory";
        }
        {
          on = [
            "c"
            "n"
          ];
          run = "rename";
          desc = "Rename file";
        }
        # Vim-like yank operations
        {
          on = [
            "y"
            "y"
          ];
          run = "yank";
          desc = "Yank (copy) files";
        }
        {
          on = [
            "y"
            "p"
          ];
          run = "copy path";
          desc = "Copy file path";
        }
        {
          on = [
            "y"
            "d"
          ];
          run = "copy dirname";
          desc = "Copy directory name";
        }
        {
          on = [
            "y"
            "f"
          ];
          run = "copy filename";
          desc = "Copy file name";
        }
        {
          on = [ "x" ];
          run = "yank --cut";
          desc = "Cut files";
        }

        # Paste operations
        {
          on = [ "p" ];
          run = "paste";
          desc = "Paste files";
        }
        {
          on = [ "P" ];
          run = "paste --force";
          desc = "Paste (overwrite)";
        }
        {
          on = [ "<Space>" ];
          run = [
            "toggle"
            "arrow next"
          ];
          desc = "Toggle select & next";
        }
        {
          on = [ "d" ];
          run = "remove";
          desc = "Delete (to trash)";
        }
        {
          on = [ "D" ];
          run = "remove --permanently";
          desc = "Delete permanently";
        }
        {
          on = [ "<Enter>" ];
          run = "open";
          desc = "Open file";
        }
        {
          on = [ "q" ];
          run = "quit";
          desc = "Quit yazi";
        }
        {
          on = [ "?" ];
          run = "help";
          desc = "Show help";
        }
        {
          on = [
            "<Space>"
            "s"
            "x"
          ];
          run = "shell 'yazi-search-extract \"$1\"' --orphan --confirm";
          desc = "Search extract";
        }
      ];
    };
  };
}
