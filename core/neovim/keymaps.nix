{ user, ... }: let
  options = { noremap = true; silent = true; };
  mkKeymaps = keymaps: map (x: x // { options = options // (x.options or { }); }) keymaps;
in {
  home-manager.users.${user} = {
    programs.nixvim.globals.mapleader = " ";

    programs.nixvim.keymaps = mkKeymaps [
      # Disable arrow keys
      { key = "<up>";    action = "<nop>"; options.desc = "Disabled"; }
      { key = "<down>";  action = "<nop>"; options.desc = "Disabled"; }
      { key = "<left>";  action = "<nop>"; options.desc = "Disabled"; }
      { key = "<right>"; action = "<nop>"; options.desc = "Disabled"; }

      # Easy search clearing
      { mode = "n"; key = "<Esc>"; action = "<CMD>nohl<CR>"; options.desc = "Clear search highlight"; }

      # Switch between alternate files (useful for returning from `gd`)
      # TODO: still useful for quick switching (0/1/0/1/0/1)
      # but can be replaced with Ctrl+o. Do we remove it?
      {
        mode = "n";
        key = "<leader>s";
        action.__raw = ''function() pcall(vim.cmd.edit, "#") end'';
        options.desc = "Alternate file";
      }

      # Do not copy contents replaced by paste actions
      { mode = "v"; key = "p"; action = "\"_dp"; options.desc = "Paste without yanking"; }
      { mode = "v"; key = "P"; action = "\"_dP"; options.desc = "Paste before without yanking"; }

      # Turn some cut operations into delete
      { mode = "n"; key = "d"; action = "\"_d"; options.desc = "Delete without yanking"; }
      { mode = "n"; key = "D"; action = "\"_D"; options.desc = "Delete to end of line without yanking"; }
      { mode = "v"; key = "d"; action = "\"_d"; options.desc = "Delete selection without yanking"; }
      { mode = "v"; key = "x"; action = "\"_d"; options.desc = "Delete selection without yanking"; }

      # Duplicate line and comment original
      { mode = "n"; key = "yc"; action = "yy<Cmd>normal! gcc<CR>p"; options.desc = "Duplicate line and comment original"; }

      # Auto-center screen on page down/page up
      { mode = "n"; key = "<Ctrl-d>"; action = "<C-d>zz"; options.desc = "Half page down and center"; }
      { mode = "n"; key = "<Ctrl-u>"; action = "<C-u>zz"; options.desc = "Half page up and center"; }

      # Window navigation
      { mode = "n"; key = "<C-h>"; action = "<C-w>h"; options.desc = "Window left"; }
      { mode = "n"; key = "<C-j>"; action = "<C-w>j"; options.desc = "Window down"; }
      { mode = "n"; key = "<C-k>"; action = "<C-w>k"; options.desc = "Window up"; }
      { mode = "n"; key = "<C-l>"; action = "<C-w>l"; options.desc = "Window right"; }
    ];
  };
}
