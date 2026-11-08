{ lib, ext, self }:

builtins.addErrorContext "While defining a search engine" (
  { name
  , searchExtension
  , urlBase
  , updateInterval ? 24 * 60 * 60 * 1000 # In seconds
  , noIcon ? false
  , iconFile ? null
  , alias ? null
  , aliases ? []
  , dontPrefixAlias ? false
  , aliasPrefix ? "@"
  , extraParams ? {}
  , extraOptions ? {}
  , additionalUrlExtensions ? [] # Instead of `template`, use `ext`
  , additionalUrls ? []
  }:
  {
    "${name}" = self.attrsets.mergeAttrs [
      {
        inherit name updateInterval;
        urls = (
          [{ template = "${urlBase}/${searchExtension}{searchTerms}"; }]
          ++ (map
            ({ ext, ... }@x: {
              template = "${urlBase}/${ext}";
            } // (builtins.removeAttrs x ["ext"]))
            additionalUrlExtensions
          )
          ++ additionalUrls
        );
        params = lib.attrsets.attrsToList (
          { query = "{searchTerms}"; } // extraParams
        );
      }
      (
        if (builtins.isNull iconFile) then (
          if (!noIcon) then {
            iconMapObj."16" = "${urlBase}/favicon.ico";
          } else {}
        ) else {
          icon = iconFile;
        }
      )
      (
        let
          prefix = if (dontPrefixAlias) then "" else aliasPrefix;
        in if (builtins.isNull alias) then (
          if (aliases != []) then {
            definedAliases = (map
              (x: "${prefix}${x}")
              aliases
            );
          } else {}
        ) else {
          definedAliases = [ "${prefix}${alias}" ];
        }
      )
      extraOptions
    ];
  }
)
