DOTFILES_LINK="${HOME}/.dotfiles"
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ ${DOTFILES_DIR} = "${DOTFILES_LINK}" ]; then

	# determine project directory by reading .dotfiles symlink
	PROJECT_DIR=`readlink $DOTFILES_DIR`

	echo ""
	echo "${COLOR_YELLOW}Warning${COLOR_NONE}"
	echo "bootstrap.sh cannot be run from ~/.dotfiles"
	echo "~/.dotfiles symlink points to: $PROJECT_DIR"
	echo ""
	echo "Run from ${COLOR_LIGHT_GRAY}${PROJECT_DIR}${COLOR_NONE} instead?"

	read -p "[${COLOR_LIGHT_GRAY}y${COLOR_NONE}/${COLOR_LIGHT_GRAY}n${COLOR_NONE}] " should_we_continue
	if [[ $should_we_continue =~ [Yy] ]]; then
		DOTFILES_DIR=$PROJECT_DIR
	else
		exit 1
	fi
fi

function safe_remove() {
  if [ -r "$1" ]; then
    mv "$1" "$1"_old_`date +%s`
  fi
}

function safe_link() {
  safe_remove $1
  ln -s "$2" "$1"
}

# symlink .bash* files
safe_link "${HOME}/.bashrc" "${DOTFILES_LINK}/.bashrc"
safe_link "${HOME}/.bash_profile" "${DOTFILES_LINK}/.bash_profile"
safe_link "${HOME}/.inputrc" "${DOTFILES_LINK}/.inputrc"
safe_link "${HOME}/.dotfiles" "${DOTFILES_LINK}"

# stash any old copies of .profile
# .profile is only used for backwards compatibility anyway
safe_remove "${HOME}/.profile"

# symlink dotfiles directory to ~/.dotfiles
safe_link "${DOTFILES_LINK}" "${DOTFILES_DIR}"

source ~/.bash_profile

cd $DOTFILES_DIR
git submodule init
git submodule update

