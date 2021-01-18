#!/bin/sh
app_launcher="app.desktop"
new_script="new_launch_assistance.desktop"
cat $app_launcher $0 $1 > $new_script
