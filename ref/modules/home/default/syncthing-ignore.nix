{ config, lib, nixosConfig, ... }:
let
  isDesktop = (nixosConfig.system.name == "pixels-pc");
  isLaptop = (nixosConfig.system.name == "pixels-laptop");
  isDeck = false;

in
{
  home.file = {
    ".factorio/.stignore" = {
      text = ''
        /saves/_autosave1.zip
        /saves/_autosave2.zip
        /saves/_autosave3.zip
      '';
    };
    "Pictures/.stignore" = {
      enable = isDeck;
      text = ''
        /Boost
        /Sync
        /Reddit
        /Memes
      '';
    };
    "Videos/.stignore" = {
      enable = !isDesktop;
      text =
        if isLaptop then
          ''
            !/Imports
            #include /.shows.stignore
            /TV/**/*.mkv
            /TV/**/*.m4v
            /TV/**/*.mp4
            /Movies/*.mkv
            /Movies/*.m4v
            /Movies/*.mp4
            /Memes
            /Yt
          ''
        else if isDeck then
          ''
            !/Imports
            /**/*
            /*
          '' else null;
    };
    ".config/.stignore" = {
      text =
        if isDesktop then
          ''
            !/autostart/**
            !/btop/**
            !/r2modmanPlus-local/**
            !/Soundux/**
            !/calibre/**
            !/vesktop/**
            /**/*
            /*
          ''
        else if isLaptop then
          ''
            !/autostart/**
            !/btop/**
            !/r2modmanPlus-local/**
            !/Soundux/**
            !/calibre/**
            !/vesktop/**
            /**/*
            /*
          ''
        else if isDeck then
          ''
            !/autostart/**
            !/btop/**
            !/r2modmanPlus-local/**
            !/Soundux/**
            /**/*
            /*
          '' else null;
    };
    ".local/.stignore" = {
      text = ''
        /share/PrismLauncher/prismlauncher.cfg
        !/bin/**
        !/share/blackbox/**
        !/share/bottles/**
        !/share/cartridges/covers/**
        !/share/komikku/**
        !/share/Mindustry/**
        !/share/nvim/**
        !/share/PrismLauncher/**
        !/share/shapez.io/**
        !/share/Terraria/**
        !/share/TIS-100/**
        !/share/Steam/steamapps/compatdata/**
        !/share/Steam/steamapps/common/Starbound/storage/**
        !/share/Steam/steamapps/common/Gensokyo\ Odyssey/Gensokyo\ Odyssey_Data/**
        !/share/zoxide/**
        !/share/osu/**
        !/share/lollypop/**
        !/share/procalc/**
        /share/epiphany/web_extensions
        !/share/epiphany/**
        /**/*
        /*
      '';
    };
    "Games/.stignore" = {
      enable = isLaptop;
      text = ''
        /Dark\ Souls\ Remastered
        /The\ Outsider\ Who\ Loved\ Gensokyo\ -\ ReimuYuukaEienteiFix
      '';
    };
    ".var/app/.stignore" = {
      text = ''
        !/com.gitfiend.GitFiend
        !/com.steamgriddb.SGDBoop
        /*
      '';
    };
    ".kodi/.stignore" = {
      text = ''
        !/userdata/Database
        !/userdata/Savestates
        !/userdata/Thumbnails
        /userdata/*
        /*
      '';
    };
  };
}
