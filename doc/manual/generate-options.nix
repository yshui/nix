with builtins;
with import ./utils.nix;

options:

concatStrings (map
  (name:
    let option = options.${name}; in
    "  - [`${name}`](#conf-${name})"
    + "<p id=\"conf-${name}\"></p>\n\n"
    + concatStrings (map (s: "    ${s}\n") (splitLines option.description)) + "\n\n"
    + (if option.documentDefault
       then "    **Default:** " + (
       if option.defaultValue == "" || option.defaultValue == []
       then "*empty*"
       else if isBool option.defaultValue
       then (if option.defaultValue then "`true`" else "`false`")
       else
         # n.b. a StringMap value type is specified as a string, but
         # this shows the value type.  The empty stringmap is "null" in
         # JSON, but that converts to "{ }" here.
         (if isAttrs option.defaultValue then "`\"\"`"
          else "`" + toString option.defaultValue + "`")) + "\n\n"
       else "    **Default:** *machine-specific*\n")
    + (if option.aliases != []
       then "    **Deprecated alias:** " + (concatStringsSep ", " (map (s: "`${s}`") option.aliases)) + "\n\n"
       else "")
    )
  (attrNames options))
