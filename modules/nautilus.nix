{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nautilus
    sushi
    file-roller
  ];

  dconf.settings = {
    "org/gnome/nautilus/preferences" = {
      show-hidden-files = true;
      default-folder-viewer = "list-view";
      show-delete-permanently = true;
    };

    "org/gnome/nautilus/list-view" = {
      use-tree-view = true;
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
    };
  };

  home.file.".config/gtk-3.0/bookmarks".text = ''
    file:///home/chuck/downloads Downloads
    file:///home/chukc/pictures Pictures
    file:///home/chuck/mynix NixOS Config
  '';
}
