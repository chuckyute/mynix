{ ... }:
{
  # Google Chrome configuration with Home Manager
  programs.google-chrome = {
    enable = true;

    # Optimized for your Wayland/Sway/NVIDIA setup
    commandLineArgs = [
      # Force hardware acceleration
      "--enable-gpu-rasterization"
      "--enable-zero-copy"
      "--ignore-gpu-blocklist"
      "--ignore-gpu-blacklist"
      "--disable-gpu-driver-bug-workarounds"

      # Better Wayland support (REMOVE the old VAAPI flags)
      "--enable-features=WaylandWindowDecorations,VaapiVideoDecodeLinuxGL"
      "--ozone-platform=wayland"
      "--use-gl=desktop" # Changed from egl

      # Performance optimizations
      "--enable-smooth-scrolling"
      "--enable-hardware-overlays"

      # Force hardware acceleration even if blocklisted
      "--ignore-gpu-sandbox-failures"
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
