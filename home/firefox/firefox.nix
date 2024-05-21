{ inputs, config, pkgs, ... }:
{
  nixpkgs.overlays = [
    inputs.nur.overlay
  ];

  # TODO: get profile name from user
  programs.firefox = {
    enable = true;
    profiles.oakley = {
      isDefault = true;
      extensions =  with pkgs.nur.repos.rycee.firefox-addons; [
        # QOL
        firefox-color
        stylus
        return-youtube-dislikes

        # Security
        bitwarden

        # Privacy
        decentraleyes
        terms-of-service-didnt-read
        flagfox
        ipvfoo
        facebook-container

        # Ads
        ublock-origin
        sponsorblock
      ];

      search.default = "Sear-Oaks!";
      search.privateDefault = "Sear-Oaks!";
      search.force = true;

      search.engines = {
        "Sear-Oaks!" = {
          urls = [{
            template = "https://searx.oakleycord.dev/search?q={searchTerms}";
          }];

          iconUpdateURL = "https://searx.oakleycord.dev/static/themes/simple/img/favicon.svg";
          updateInterval = 24 * 60 * 60 * 1000;
          definedAliases = [ "@sx" ];
        };
      };


      settings = {
        "browser.startup.homepage" = "https://searx.oakleycord.dev";

        # Remove firefox account sync
        "identity.fxaccounts.enabled" = false;

        # Show Downloads Button
        "browser.download.panel.shown" = true;

        # No signon auto complete
        "signon.rememberSignons" = false;
        "signon.autofillForms" = false;

        # Remove all this pocket bullshit
        "extensions.pocket.enabled" = false;
        "extensions.pocket.onSaveRecs" = false;
        "browser.urlbar.suggest.pocket" = false;


        # use userChrome
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };

      userChrome = ''
      ${builtins.readFile ./theming/userChrome.css}
      '';

      userContent = ''
      ${builtins.readFile ./theming/userContent.css}
      '';
    };



  };
  # Theming from https://github.com/rose-pine/firefox
  home.file = {
#    ".mozilla/firefox/oakley/chrome/add.svg".source = ./theming/add.svg;
#    ".mozilla/firefox/oakley/chrome/left-arrow.svg".source = ./theming/left-arrow.svg;
#    ".mozilla/firefox/oakley/chrome/right-arrow.svg".source = ./theming/right-arrow.svg;
    ".mozilla/firefox/oakley/chrome/userColors.css".source = ./theming/userColors.css;
  };
}
