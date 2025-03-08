#!/bin/sh
# This script is executed during container initialization.
# It will launch dupeGuru if the APP_NAME is set to "dupeGuru".

if [ "$APP_NAME" = "dupeGuru" ]; then
  echo "Starting dupeGuru..."
  # Launch the application. Adjust the command if your installation is different.
  exec python3 /usr/share/dupeguru/run.py
fi
