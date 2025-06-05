{ pkgs, ... }:
{
  home.packages = with pkgs; [
    unar
  ];

  programs.yazi = {
    enable = true;
    enableBashIntegration = true;

    settings = {
      manager = {
        show_hidden = true;
        title_format = "yazi";
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
      # File association rules - this is the key part
      open = {
        rules = [
          # Archive files use extract workflow when pressing Enter
          {
            mime = "application/zip";
            use = [ "extract" ];
          }
          {
            mime = "application/gzip";
            use = [ "extract" ];
          }
          {
            mime = "application/x-tar";
            use = [ "extract" ];
          }
          {
            mime = "application/x-7z-compressed";
            use = [ "extract" ];
          }
          {
            mime = "application/x-rar";
            use = [ "extract" ];
          }

          # Pattern-based matching (more reliable than MIME)
          {
            name = "*.zip";
            use = [ "extract" ];
          }
          {
            name = "*.tar.gz";
            use = [ "extract" ];
          }
          {
            name = "*.tgz";
            use = [ "extract" ];
          }
          {
            name = "*.tar.xz";
            use = [ "extract" ];
          }
          {
            name = "*.7z";
            use = [ "extract" ];
          }
          {
            name = "*.rar";
            use = [ "extract" ];
          }
        ];
      };
    };

    keymap = {
      manager.keymap = [
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
        # tab operations
        {
          on = [
            "t"
            "n"
          ];
          run = "tab_create";
          desc = "New tab";
        }
        {
          on = [
            "t"
            "q"
          ];
          run = "tab_close";
          desc = "Close tab";
        }
        {
          on = [ "<Tab>" ];
          run = "tab_switch --relative 1";
          desc = "Next tab";
        }
        {
          on = [ "<BackTab>" ];
          run = "tab_switch --relative -1";
          desc = "Prev tab";
        }
        {
          on = [
            "t"
            "1"
          ];
          run = "tab_switch 0";
          desc = "Switch to tab 1";
        }
        {
          on = [
            "t"
            "2"
          ];
          run = "tab_switch 1";
          desc = "Switch to tab 2";
        }
        {
          on = [
            "t"
            "3"
          ];
          run = "tab_switch 2";
          desc = "Switch to tab 3";
        }
        {
          on = [
            "t"
            "4"
          ];
          run = "tab_switch 3";
          desc = "Switch to tab 4";
        }
        {
          on = [
            "t"
            "5"
          ];
          run = "tab_switch 4";
          desc = "Switch to tab 5";
        }
        {
          on = [
            "t"
            "6"
          ];
          run = "tab_switch 5";
          desc = "Switch to tab 6";
        }
        {
          on = [
            "t"
            "7"
          ];
          run = "tab_switch 6";
          desc = "Switch to tab 7";
        }
        {
          on = [
            "t"
            "8"
          ];
          run = "tab_switch 7";
          desc = "Switch to tab 8";
        }
        {
          on = [
            "t"
            "9"
          ];
          run = "tab_switch 8";
          desc = "Switch to tab 9";
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
          on = [ ";" ];
          run = "shell --interactive";
          desc = "run shell command";
        }
        {
          on = [ ":" ];
          run = "shell --block --interactive";
          desc = "run shell command (block until finished)";
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
      ];
    };
  };
}
