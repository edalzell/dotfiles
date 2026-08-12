# Shortcuts
alias copyssh="pbcopy < $HOME/.ssh/id_rsa.pub"
alias rm="trash"


# Laravel
alias art="herd php artisan"
alias acc="art cache:clear"
alias avp="art vendor:publish"
alias mfs="art migrate:fresh --seed"
alias rl="art route:list --except-path=cp"
alias stan="./vendor/bin/phpstan analyse"

# Herd
alias hp="herd php"
alias hc="herd composer"
alias hcov="herd coverage ./vendor/bin/pest --coverage"

# Brew
alias bo="brew outdated"
alias bu="brew update"

# Composer
alias fu-composer="rm vendor composer.lock && herd composer clear-cache"
alias ci="hc install"
alias co="hc outdated"
alias cr="hc require"
alias cu="hc update && hc bump"
alias cda="hc dump-autoload"
alias cgu="composer global update"

# Statamic
alias plz="herd php please"

# JS
alias dev="npm run dev"
alias build="npm run build"

