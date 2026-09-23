#!/bin/bash
# Disable Plasma's press-and-hold diacritics popup (holding a letter like "k"
# showed an accented-char picker, e.g. "ķ", instead of auto-repeat).
# The feature lives in the plasma-keyboard daemon (KWin's input method); its
# config file is plasmakeyboardrc, group [General].

set -e

kwriteconfig6 --file plasmakeyboardrc --group General --key diacriticsPopupEnabled false

# restart the daemon so the setting is guaranteed to be picked up
pkill -x plasma-keyboard 2>/dev/null || true
qdbus org.kde.KWin /KWin reconfigure 2>/dev/null || true
