#!/usr/bin/env bash

# Execute command in terminal emulator Mac OS X

# Path to temporary script file
SCRIPT_FILE=/var/tmp/doublecmd-$(date +%s)

# Add shebang
echo "#!/usr/bin/env bash" > $SCRIPT_FILE

# Remove temporary script file at exit
echo "trap 'rm -f $SCRIPT_FILE' INT TERM EXIT" >> $SCRIPT_FILE

# Change to directory
echo "cd $(pwd)" >> $SCRIPT_FILE

# Copy over target command line
echo "$@" >> $SCRIPT_FILE

# Make executable
chmod +x "$SCRIPT_FILE"

# Execute in terminal
open -b com.apple.terminal "$SCRIPT_FILE"
