# thanks to http://www.joshstaiger.org/archives/2005/07/bash_profile_vs.html
if [ -r ~/.bashrc ]; then
   source ~/.bashrc
fi

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
