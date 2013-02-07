# Setup the main shell variables and functions
SHELL_PLATFORM='OTHER'
case "$OSTYPE" in
  *'linux'*   ) SHELL_PLATFORM='LINUX' ;;
  *'darwin'*  ) SHELL_PLATFORM='OSX' ;;
  *'freebsd'* ) SHELL_PLATFORM='BSD' ;;
esac

if ! type -p shell_is_login ; then
  shell_is_linux       () { [[ "$OSTYPE" == *'linux'* ]] ; }
  shell_is_osx         () { [[ "$OSTYPE" == *'darwin'* ]] ; }
  shell_is_login       () { shopt -q login_shell ; }
  shell_is_interactive () { test -n "$PS1" ; }
  shell_is_script      () { ! shell_is_interactive ; }
fi

# should you be changing this?
DOTFILES_HOME="${HOME}/.dotfiles"

# load all .sh files in dotfiles folder, in alphabetical order
for file in "${DOTFILES_HOME}/"*.conf; do
  # wait to load prompt till the end of everything
  # just in case some crappy script tries to define PS1
  if [ "$file" != "${DOTFILES_HOME}/prompt.conf" ]; then
    source "${file}"
  fi
done

# load these last, to give user ability to override/customize in private
for file in ~/.{path,extras}; do
  [ -r "$file" ] && source "$file"
done
unset file

# update submodules
cd $DOTFILES_HOME
git submodule update

# load z...z is the shizznit!
[ -r "./z/z.sh" ] && source "./z/z.sh"

# load prompt last to ensure it isn't fucked with
[ -r "${DOTFILES_HOME}/prompt.conf" ] && source "${DOTFILES_HOME}/prompt.conf"

cd $HOME
