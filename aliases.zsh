# Shortcuts
alias copyssh="pbcopy < $HOME/.ssh/id_rsa.pub"
alias reloadshell="source $HOME/.zshrc"
alias reloaddns="dscacheutil -flushcache && sudo killall -HUP mDNSResponder"
alias ll="/usr/local/opt/coreutils/libexec/gnubin/ls -AhlFo --color --group-directories-first"
alias c="clear"
alias rm="trash"

# Directories
alias dotfiles="cd $DOTFILES"
alias library="cd $HOME/Library"
alias sites="cd $HOME/Sites"

# Laravel
alias art="php artisan"
alias acc="art cache:clear"
alias fresh="php artisan migrate:fresh --seed"
alias seed="php artisan db:seed"
alias rl="art route:list --columns=uri,name,action"
alias avc="art view:clear"

# Brew
alias bo="brew outdated"
alias bu="brew update"

# Composer
alias fu-composer="rm vendor composer.lock && composer clear-cache"
alias cu="composer update"
alias cda="composer dump-autoload"

# Statamic
alias plz="php please"


# JS
alias nfresh="rm -rf node_modules/ package-lock.json && npm install"
alias watch="npm run watch"


# Git
alias gst="git status"
alias gb="git branch"
alias gc="git checkout"
alias gl="git log --oneline --decorate --color"
alias amend="git add . && git commit --amend --no-edit"
alias commit="git add . && git commit -m"
alias diff="git diff"
alias force="git push --force"
alias nuke="git clean -df && git reset --hard"
alias pop="git stash pop"
alias pull="git pull"
alias push="git push"
alias resolve="git add . && git commit --no-edit"
alias stash="git stash -u"
alias unstage="git restore --staged ."
alias wip="commit wip"
