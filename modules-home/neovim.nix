{
  pkgs,
  user,
  ...
}: {
  home.packages = with pkgs; [
    alejandra
  ];

  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    options = {
      autoindent = true;
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      tabstop = 2;
      softtabstop = 2;
      scrolloff = 8;
      expandtab = true;
      smartindent = true;
      wrap = false;
      hlsearch = false;
      incsearch = true;
      termguicolors = true;
      cursorline = true;
      signcolumn = "yes";
      colorcolumn = "81";
      backup = false;
      swapfile = false;
      undofile = true;
      undodir = "/home/${user}/.vim/undodir";
    };

    colorschemes.dracula.enable = true;
    highlight = {
      Normal.bg = "none";
      NormalFloat.bg = "none";
      WinSeparator = {
        bg = "none";
        fg = "#eaeaea";
      };
      CursorLine = {
        bg = "none";
        underline = true;
      };
      CursorLineNr.link = "CursorLine";
      VirtColumn.fg = "#000000";
      SignColumn.bg = "none";
    };

    globals.mapleader = " ";
    keymaps = [
      {
        action = ":CHADopen<CR>";
        key = "t";
        mode = "n";
      }
      {
        action = "<cmd>TroubleToggle<cr>";
        key = "<leader>t";
        mode = "n";
      }
      {
        # this is here because it needs insert mode
        action = "vim.lsp.buf.signature_help";
        lua = true;
        key = "<C-h>";
        mode = "i";
      }
      {
        # don't override buffer when pasting
        action = ''"_dP'';
        key = "p";
        mode = "x";
      }
      {
        # copy to system clipboard
        action = ''"+y'';
        key = "<leader>y";
        mode = ["n" "x"];
      }
      {
        # no macro menu
        action = "<nop>";
        key = "q";
        mode = "n";
      }
      # move between windows with ctrl hjkl
      {
        action = "<C-w>h";
        key = "<C-h>";
        mode = "n";
      }
      {
        action = "<C-w>j";
        key = "<C-j>";
        mode = "n";
      }
      {
        action = "<C-w>k";
        key = "<C-k>";
        mode = "n";
      }
      {
        action = "<C-w>l";
        key = "<C-l>";
        mode = "n";
      }
    ];

    plugins = {
      nvim-colorizer.enable = true;
      fidget.enable = true;
      lightline.enable = true;
      indent-blankline.enable = true;
      gitgutter.enable = true;
      telescope.enable = true;
      treesitter = {
        enable = true;
        indent = true;
      };
      nvim-autopairs.enable = true;
      chadtree = {
        enable = true;
        keymap = {
          windowManagement.quit = ["q" "t"];
          fileOperations.trash = ["D"];
        };
      };
      trouble.enable = true;
      lsp-format.enable = true;
      nvim-lightbulb.enable = true;
      cmp-nvim-lsp.enable = true;
      cmp-treesitter.enable = true;
      comment-nvim.enable = true;
      nvim-cmp = {
        enable = true;
        snippet.expand = "luasnip";
        preselect = "None";
        autoEnableSources = true;
        sources = [
          {
            groupIndex = 1;
            name = "luasnip";
          }
          {
            groupIndex = 1;
            name = "nvim_lsp";
          }
          {
            groupIndex = 2;
            name = "path";
          }
        ];
        mapping = {
          "<CR>" = ''
            cmp.mapping({
              i = function(fallback)
                if cmp.visible() and cmp.get_active_entry() then
                  cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                else
                  fallback()
                end
              end,
              s = cmp.mapping.confirm({ select = true }),
              c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
            })
          '';

          "<C-e>" = "cmp.mapping.abort()";

          "<Tab>" = ''
            cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              else
                fallback()
              end
            end, { "i", "s" })
          '';

          "<S-Tab>" = ''
            cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              else
                fallback()
              end
            end, { "i", "s" })
          '';
        };
      };

      lsp = {
        enable = true;
        keymaps = {
          diagnostic = {
            # vim.diagnostic.#
            "<leader>vd" = "open_float";
            "<leader>k" = "goto_prev";
            "<leader>j" = "goto_next";
          };
          lspBuf = {
            # vim.lsp.buf.#
            "gd" = "definition";
            "gt" = "type_definition";
            "gr" = "references";
            "gi" = "implementation";
            "K" = "hover";
            "<leader>ca" = "code_action";
            "<leader>rn" = "rename";
          };
        };
        servers = {
          nil_ls = {
            enable = true;
            settings.formatting.command = ["alejandra"];
          };
          lua-ls.enable = true;
          pylsp = {
            enable = true;
            settings.plugins = {
              pylint.enabled = true;
              pylsp_mypy = {
                enabled = true;
                live_mode = true;
              };
              isort.enabled = true;
              black.enabled = true;
            };
          };
        };
      };
    };

    extraPlugins = with pkgs.vimPlugins; [
      vim-wakatime
    ];

    extraConfigLua = ''
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local cmp = require('cmp')
      cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done()
      )
    '';
  };
}
