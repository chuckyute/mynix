{ ... }:
{
  # Google Chrome configuration with Home Manager
  programs.google-chrome = {
    enable = true;

    # Optimized for your Wayland/Sway/NVIDIA setup
    commandLineArgs = [
      # Essential Wayland support
      "--enable-wayland-ime"
      "--ozone-platform=wayland"
      "--enable-features=WaylandWindowDecorations"

      # NVIDIA optimizations
      "--enable-gpu-rasterization"
      "--enable-zero-copy"
      "--ignore-gpu-blocklist"

      # General improvements
      "--enable-smooth-scrolling"
      "--disable-features=UseChromeOSDirectVideoDecoder"
    ];
  };

  # XDG MIME configuration - REQUIRED for NixOS
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "google-chrome.desktop";
      "x-scheme-handler/http" = "google-chrome.desktop";
      "x-scheme-handler/https" = "google-chrome.desktop";
      "x-scheme-handler/about" = "google-chrome.desktop";
      "x-scheme-handler/unknown" = "google-chrome.desktop";
    };
  };
}
