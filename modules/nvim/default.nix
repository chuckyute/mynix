{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    extraPackages = with pkgs; [
      nerd-fonts.code-new-roman
      ripgrep
      lua-language-server
      nixd
      wl-clipboard
      stylua
      nixfmt-rfc-style
    ];
    plugins = with pkgs.vimPlugins; [
      gruvbox-nvim
      comment-nvim
      lualine-nvim
      gitsigns-nvim
      which-key-nvim
      todo-comments-nvim
      mini-nvim
      vim-godot
      # telescope plugins
      plenary-nvim
      telescope-fzf-native-nvim
      telescope-ui-select-nvim
      nvim-web-devicons
      vim-nix
      {
        plugin = telescope-nvim;
        type = "lua";
        config = builtins.readFile ./telescope.lua;
      }
      # completion
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp_luasnip
      friendly-snippets
      luasnip
      {
        plugin = nvim-cmp;
        type = "lua";
        config = builtins.readFile ./cmp.lua;
      }
      # lsp plugins
      fidget-nvim
      lazydev-nvim
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = builtins.readFile ./lsp.lua;
      }
      {
        plugin = (
          nvim-treesitter.withPlugins (p: [
            p.tree-sitter-nix
            p.tree-sitter-vim
            p.tree-sitter-bash
            p.tree-sitter-lua
            p.tree-sitter-json
          ])
        );
        type = "lua";
        config = builtins.readFile ./treesitter.lua;
      }
      {
        plugin = conform-nvim;
        type = "lua";
        config = builtins.readFile ./format.lua;
      }
    ];
    extraLuaConfig = ''
      ${builtins.readFile ./options.lua}
      ${builtins.readFile ./plugins.lua}
    '';
  };
}
