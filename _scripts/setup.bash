#!/bin/bash

echo "This command will set up a 'vanilla' Mac to be a Java development machine."
echo "This includes things like:"
echo " -Installing Homebrew (a package manager for Mac)"
echo " -Installing git (The latest version of the most common versioning system)"

echo "This install takes a while, but is intended to be (mostly) non-destructive."
echo "- Homebrew seems to skip installation if it already has the latest installed (otherwise it updates)"
echo "- brew install installs or upgrades what ever it is installing (git for instance)"
echo ""
echo "**NOTE** Some Hombrew apps require the Apple quarantine flag to be turned off for the app."
echo "This requires sudo, so this script should be run with 'sudo'."
echo ""
read -r -p "Are you sure you want to run this? [y/N] " response

if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
    echo "Great!  Continuing on..."
else
  echo "OK, quitting"
  exit 0;
fi

# Display each expanded command as it runs
set -x


# Mac settings
defaults write com.apple.Finder AppleShowAllFiles true
killall Finder

./install_homebrew.bash

./install_sdkman.bash

# Init homebrew for this shell
eval "$(/opt/homebrew/bin/brew shellenv)"

# Init sdkman
source "~/.sdkman/bin/sdkman-init.sh"

if [[ -n "$ZSH_VERSION" ]]; then
  source ~/.zshrc
elif [[ -n "$BASH_VERSION" ]]; then
  source ~/.bash_profile
fi

# Commands needed for other installs
brew install jq   # Used for shell interaction w/ json config files

./install_docker.bash

# 'tap' the github list of cask-versions so multiple versions are available of
# casks.  This allows finding older versions of Java
brew tap homebrew/cask
brew tap homebrew/cask-versions

# General CLI Tools
brew install git
brew install maven
brew install gradle
brew install gradle-completion
brew install bash
brew install bash-completion
brew install openssl
# Node and python libs
# brew install nvm

# Improvement over bash grep, including non-greedy qualifiers and replacement
brew install ripgrep
# Strangely missing on Mac
brew install wget
brew install python@3.11
brew install virtualenv
# brew install ansible
# Used by Obsidian to export to Word and other formats
# brew install pandoc

#Amazon CLI Tools
# brew tap aws/tap
# brew install aws-sam-cli
# brew install awscli

# Get latest java versions
# This relies on the order or sdk list command, which seems to not get the sub-point versions right.
# For instance, '11.0.20-tem' is listed before '11.0.20.1-tem', so the first is choosen
LATEST_JDK8=`sdk ls java | grep -E -m 1 -o '8\.0\.\d+(\.\d+)?-librca'`
LATEST_JDK11=`sdk ls java | grep -E -m 1 -o '11\.0\.\d+(\.\d+)?-tem'`
LATEST_JDK17=`sdk ls java | grep -E -m 1 -o '17\.0\.\d+(\.\d+)?-tem'`
LATEST_JDK20=`sdk ls java | grep -E -m 1 -o '20\.0\.\d+(\.\d+)?-tem'`
LATEST_JDK21=`sdk ls java | grep -E -m 1 -o '21\.0\.\d+(\.\d+)?-tem'`

# Java Versions
yes n | sdk install java ${LATEST_JDK8}
yes n | sdk install java ${LATEST_JDK11}
yes n | sdk install java ${LATEST_JDK17}
yes n | sdk install java ${LATEST_JDK20}
yes n | sdk install java ${LATEST_JDK21}

sdk default java ${LATEST_JDK21}



# Think this is not required after switching to SdkMan
# find /Library/Java/JavaVirtualMachines/* -type d -prune -exec jenv add {}/Contents/Home \;

# GUIs
brew install --cask sublime-text
brew install --cask sourcetree
brew install --cask keepassxc
brew install --cask intellij-idea
brew install --cask dbeaver-community
brew install --cask studio-3t
brew install --cask fluid
brew install --cask google-chrome
brew install --cask pycharm


# GUIs that for some reason don't require '--cask'
brew install drawio
brew install obsidian
brew install bbedit
brew install firefox

## Extras
# Nice suite of monospaced fonts: https://github.com/githubnext/monaspace?tab=readme-ov-file#monaspace
brew install font-monaspace




echo "Currently installed Homebrew formula:"
brew bundle dump --file -

echo "Currently installed Java SDKs:"
sdk list | grep ">>>\|installed\|local"

# Misc

# Turn off security on a few apps
xattr -d com.apple.quarantine /Applications/KeePassXC.app
xattr -d com.apple.quarantine /Applications/Sourcetree.app
xattr -d com.apple.quarantine "/Applications/Studio 3T.app"
xattr -d com.apple.quarantine "/Applications/DBeaver.app"



# Other non-automated apps (just a list of TODOs)
#
# Plantronics Hub:  https://www.poly.com/us/en/support/downloads-apps
# Moom from Many Tricks in the App Store
# Oxygen XML Editor
# IntelliJ

# Here is the complete list that was installed as of Oct 4, 2023, many of which may not be needed:
# brew "python@3.11"
# brew "tcl-tk"
# brew "python@3.8"
# brew "aws-sam-cli"
# brew "binutils"
# brew "freetype"
# brew "fontconfig"
# brew "harfbuzz"
# brew "libtiff"
# brew "little-cms2"
# brew "maven"
# brew "openssl@1.1"
# brew "python@3.10"
# brew "python@3.9"
# brew "ripgrep"
# cask "adoptopenjdk8"
# cask "bbedit"
# cask "intellij-idea"
