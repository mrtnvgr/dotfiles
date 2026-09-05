{ pkgs, user, config, ... }: let
  # TODO: add rm .DS_Store, __MACOSX, rename to "linuxify"(?)
  fixperms = pkgs.writeShellScriptBin "fixperms" ''
    find "$1" -type d -exec chmod 755 {} +
    find "$1" -type f -exec chmod 644 {} +
  '';

  # Colorful for desktops, monochrome for servers
  ps1 = if config.modules.desktop.enable then
    ''\[$(tput bold)\]\[$(tput setaf 1)\][\[$(tput setaf 3)\]\u\[$(tput setaf 2)\]@\[$(tput setaf 4)\]\h \[$(tput setaf 5)\]\W\[$(tput setaf 1)\]]\[$(tput setaf 7)\]\\$ \[$(tput sgr0)\]''
  else
    ''\[$(tput bold)\]\[$(tput setaf 245)\][\[$(tput setaf 255)\]\u\[$(tput setaf 245)\]@\[$(tput setaf 250)\]\h \[$(tput setaf 250)\]\W\[$(tput setaf 245)\]]\[$(tput setaf 7)\]\\$ \[$(tput sgr0)\]'';
in {
  home-manager.users.${user} = {
    programs.bash = {
      enable = true;

      initExtra = ''PS1="${ps1}"'';

      shellAliases = {
        perm = "echo Use 'stat' instead. #";

        # Better defaults
        rsync = "rsync -zvhP";
        rsync-mirror-fat = "rsync -r --update --delete --size-only";
      };
    };

    home.packages = [ fixperms ];
  };
}
