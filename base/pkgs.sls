{% set vim = salt['grains.filter_by']({ 
      'RedHat': {'pkg': 'vim-enhanced'},
      'FreeBSD': {'pkg': 'vim'},
   }, default='RedHat') 
%}

base_pkg:
  pkg.installed:
    - names:
      - {{ vim.pkg }}
      - lsof
      - screen
      - htop
