#!/bin/sh
app_launcher="app.desktop"
script="launch_assistance.sh"
new_launcher="new_launch_assistance.desktop"
cat $app_launcher $script $1 > $new_launcher
chmod +x $new_launcher
