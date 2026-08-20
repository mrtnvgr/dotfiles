{ user, ... }: let
  genIndent = count: tabs: {
    expandtab = !tabs;
    shiftwidth = count;
    tabstop = count;
  };
in {
  home-manager.users.${user}.programs.nixvim = {
    opts = {
      # Line numbers
      number = true;
      relativenumber = true;

      # Search
      ignorecase = true;
      smartcase = true;

      smartindent = true;

      # Temporary files
      backup = false;
      undofile = true;

      wrap = false;

      mouse = "a";
      guicursor = "";
      clipboard = "unnamedplus";

      termguicolors = true;
      updatetime = 100;
      timeoutlen = 500;

      # Paddings
      signcolumn = "yes";
      cmdheight = 0;

      backspace = "indent,eol,start";

      # Splits
      splitright = true;
      splitbelow = true;

      autoread = true;
      confirm = true;

      foldlevel = 99; # do not auto close folds
    } // (genIndent 4 true);

    extraConfigLua = ''
      vim.opt.shortmess:append("I") -- hide intro message
      vim.opt.shortmess:append("s") -- hide "search hit BOTTOM ..."
      vim.opt.shortmess:append("c") -- do not pass messages to |ins-completion-menu|

      -- hide ~ blank lines
      vim.opt.fillchars:append("eob: ")
    '';

    globals.netrw_banner = 0; # Hide the Netrw banner

    # Use 2 spaces in nix and lua files
    files."ftplugin/nix.lua".opts = genIndent 2 false;
    files."ftplugin/lua.lua".opts = genIndent 2 false;
  };
}
