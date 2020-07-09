# ~/.bash_logout: executed by bash(1) when login shell exits.

# when leaving the console clear the screen to increase privacy

if [ "$SHLVL" = 1 ]; then
    [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
fi

# adc added 2020-07-09
# Based on https://unix.stackexchange.com/questions/365339/making-pushd-directory-stack-persistent
declare -p DIRSTACK >"$HOME/.dirstack"
sed -i s/DIRSTACK/tempVar/ "$HOME/.dirstack" 

