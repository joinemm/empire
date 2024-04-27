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

    opts = {
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
      backup = false;
      swapfile = false;
      undofile = true;
      undodir = "/home/${user}/.vim/undodir";
    };

    files = {
      "ftplugin/sh.lua" = {
        opts = {
          expandtab = true;
          shiftwidth = 4;
          tabstop = 4;
        };
      };
      "ftplugin/markdown.lua" = {
        opts = {
          wrap = true;
          breakindent = true;
          linebreak = true;
        };
      };
    };

    colorschemes.dracula.enable = true;
    highlightOverride = {
      Normal.bg = "none";
      NormalFloat.bg = "none";
      WinSeparator = {
        bg = "none";
        fg = "#eaeaea";
      };
      VirtColumn.fg = "#000000";
      SignColumn.bg = "none";
      Pmenu.bg = "none";
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
      # languages
      nix.enable = true;
      markdown-preview.enable = true;
      rust-tools.enable = true;

      treesitter = {
        enable = true;
        indent = true;
      };

      chadtree = {
        enable = true;
        keymap = {
          windowManagement.quit = ["q" "t"];
          fileOperations.trash = ["D"];
        };
      };

      nvim-colorizer = {
        enable = true;
        userDefaultOptions.names = false;
      };
      fidget.enable = true;
      lightline.enable = true;
      indent-blankline = {
        settings.indent.char = "|";
        enable = true;
      };
      gitgutter.enable = true;
      telescope.enable = true;
      nvim-autopairs.enable = true;
      trouble.enable = true;
      nvim-lightbulb.enable = true;
      comment.enable = true;
      barbecue.enable = true;
      lastplace.enable = true;
      illuminate.enable = true;

      cmp-treesitter.enable = true;
      cmp-nvim-lsp.enable = true;
      cmp-nvim-lsp-signature-help.enable = true;
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          window.completion.border = "rounded";
          window.documentation.border = "rounded";
          sources = [
            {
              groupIndex = 1;
              name = "nvim_lsp";
            }
            {
              groupIndex = 2;
              name = "path";
            }
          ];
          preselect = "None";
          snippet.expand = "luasnip";
          mapping = {
            "<CR>" =
              /*
              lua
              */
              ''
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

            "<C-e>" =
              /*
              lua
              */
              ''cmp.mapping.abort()'';

            "<Tab>" =
              /*
              lua
              */
              ''
                cmp.mapping(function(fallback)
                  if cmp.visible() then
                    cmp.select_next_item()
                  else
                    fallback()
                  end
                end, { "i", "s" })
              '';

            "<S-Tab>" =
              /*
              lua
              */
              ''
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
      };

      lsp-format.enable = true;

      none-ls = {
        enable = true;
        enableLspFormat = true;
        sources = {
          code_actions = {
            statix.enable = true;
            refactoring.enable = true;
          };
          diagnostics = {
            deadnix.enable = true;
            gitlint.enable = true;
            selene.enable = true;
          };
          formatting = {
            markdownlint.enable = true;
            sqlfluff.enable = true;
            shfmt = {
              enable = true;
              withArgs = ''
                { extra_args = {
                  '-i', '4', '-ci'
                } }
              '';
            };
            stylua.enable = true;
            terraform_fmt.enable = true;
          };
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
          bashls.enable = true;
          tailwindcss.enable = true;
          tsserver.enable = true;
          hls.enable = true;
          jsonls.enable = true;
          terraformls.enable = true;
          svelte.enable = true;
          eslint.enable = true;
          ruff-lsp = {
            enable = true;
          };
          pylsp = {
            enable = true;
            settings.plugins = {
              pylint.enabled = true;
            };
          };
        };
      };
    };

    extraPlugins = with pkgs.vimPlugins; [
      vim-wakatime
      smartcolumn-nvim
    ];

    extraConfigLua =
      /*
      lua
      */
      ''
        local cmp_autopairs = require('nvim-autopairs.completion.cmp')
        local cmp = require('cmp')
        cmp.event:on(
          'confirm_done',
          cmp_autopairs.on_confirm_done()
        )

        require("smartcolumn").setup()
      '';
  };
}
