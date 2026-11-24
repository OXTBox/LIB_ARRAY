#!/bin/bash
# Get the whole LIB_ARRAY: every OXTBox project you can see, side by side in one folder.
# Run it again any time to bring them all up to date.
#   ./get_everything.sh            -> into ./projects
#   ./get_everything.sh ~/where    -> into ~/where
# Needs git. Private projects ask you to log in to GitHub once (or use: gh auth login; gh auth setup-git).
DEST="${1:-projects}"; ORG=OXTBox
mkdir -p "$DEST" && cd "$DEST" || exit 1
if command -v gh >/dev/null && gh auth status >/dev/null 2>&1; then
  NAMES=$(gh repo list $ORG --limit 500 --json name --jq '.[].name')
else
  NAMES="LIB_ARRAY LIB_BAT LIB_BIN LIB_BIT LIB_BUILD LIB_BVH LIB_CITY LIB_COMFY LIB_DATA LIB_DEV LIB_EDITOR LIB_EMITTERS LIB_GAD LIB_GAMES LIB_GENERICA LIB_GLOBALS LIB_GUI LIB_HOWTO LIB_ig3d LIB_INPUT LIB_LISTS LIB_LLMIN LIB_LLMOUT LIB_LOADING_SCREEN LIB_MAP LIB_MCP LIB_MENU LIB_MOCAP LIB_PORTS LIB_POWERBAR LIB_PUBLIC LIB_RAYCAST LIB_RAYGUI LIB_RTS LIB_SCRIPTBLOCKS LIB_SFX LIB_SPARK LIB_SYSTEM LIB_TEST LIB_THEME LIB_TOOLBAR LIB_TRACE LIB_TTRPG LIB_UNICODE LIB_UPBGE LIB_USERS LIB_XTJSON PROMPT_GLAZE Vibecode3D xt3D_Raylib_Livecode_Bridge xtalk_py "
fi
got=0; skipped=""
for n in $NAMES; do
  if [ -d "$n/.git" ]; then echo "update  $n"; git -C "$n" pull -q --ff-only || skipped="$skipped $n"
  else echo "get     $n"; git clone -q "https://github.com/$ORG/$n.git" "$n" 2>/dev/null || { rm -rf "$n"; skipped="$skipped $n"; continue; }; fi
  got=$((got+1))
done
echo; echo "$got projects in $(pwd)"
[ -n "$skipped" ] && echo "Not reached (no access, or local changes in the way):$skipped"
exit 0
