{ ... }: {
  nixpkgs.overlays = [
    (final: prev: import ../pkgs { pkgs = final; lib = prev.lib; })

    # yabridge 5.1.1 lets Wine hand JUCE popup menus (created as `WS_POPUP |
    # WS_SYSMENU` windows) to the window manager, which makes dropdowns in
    # plugins like Superior Drummer 3 close instantly or stall XWayland input
    # handling. This patch strips `WS_SYSMENU` from those popups so Wine maps
    # them as override-redirect windows.
    # https://github.com/robbert-vdh/yabridge/issues/521
    #
    # Re-check this when yabridge is updated upstream. The workaround can be
    # disabled at runtime with `YABRIDGE_NO_POPUP_FIX=1`, and
    # `YABRIDGE_DEBUG_LEVEL=2+editor` logs every window whose style is changed.
    (final: prev: {
      yabridge = prev.yabridge.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [ ../pkgs/yabridge-popup-menu-fix.patch ];
      });
    })
  ];
}
