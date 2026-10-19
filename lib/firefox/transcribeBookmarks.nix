{ lib, ext, self }:

# This turns an attrset into something that a firefox bookmark generator will understand

let
  yants = self.infusion.yants "firefox:transcribeBookmarks";
  inherit (self.infusion) infuse;
  inherit (yants) defun;
  # A horrible terrible amalgamation of my custom types superimposed ontop of yants
  types = infuse yants (lib.mapAttrs (_: v: { __assign = v; }) (with yants; rec {
      recursive = any; # *Sigh* Yants gives nothing for recursive types :(
      entryContents = eitherN [
        string
        (attrs recursive)
        (list recursive)
      ];
      entry = struct {
        name = string;
        value = entryContents;
      };
      unorderedBookmarks = attrs entryContents;
      orderedBookmarks = list entry;
      bookmarkFolder = struct {
        name = string;
        bookmarks = list recursive;
        toolbar = bool;
      };
      bookmark = struct {
        name = string;
        url = string;
        tags = list string;
        keyword = option string;
      };
      transcribedBookmark = either bookmarkFolder bookmark;
      transcribedBookmarks = list transcribedBookmark;
      inputData = either (list entryContents) (attrs entryContents);
    })
  );
  # Prime operates as a function mapped onto a list, sometimes I want the list to be ordered and other times I dont care, Ensure that the value exists
  prepPrimeRun = defun (with types; [ (either orderedBookmarks unorderedBookmarks) orderedBookmarks ]) (x:
    if (builtins.isAttrs x) then ( # Unordered bookmarks
      lib.attrsets.attrsToList x
    ) else ( # Ordered bookmarks
      x
    )
  );
  # The recursive function
  transcribeBookmarks' = defun (with types; [ entry transcribedBookmark ]) (acc: builtins.addErrorContext "While transcribing the bookmark tree ${acc.name}" (
    if (builtins.isString acc.value) then ( # Is a bookmark
      {
        inherit (acc) name;
        url = acc.value;
        tags = [];
        keyword = null;
      }
    ) else ( # Is a folder of some kind
      if (acc.name == "Toolbar") then ( # Is the bookmarks folder
        {
          inherit (acc) name;
          toolbar = true;
          bookmarks = (map transcribeBookmarks' (prepPrimeRun acc.value));
        }
      ) else ( # Is a normal folder
        {
          inherit (acc) name;
          toolbar = false;
          bookmarks = (map transcribeBookmarks' (prepPrimeRun acc.value));
        }
      )
    )
  ));
in

# A clean entrypoint
defun (with types; [ inputData transcribedBookmarks ]) (attrs: builtins.addErrorContext
  "While transcribing bookmarks"
  (map
    transcribeBookmarks'
    (prepPrimeRun attrs)
  )
)
