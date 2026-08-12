# User-installed scripts/binaries (XDG-style, no sudo required)
export PATH="$HOME/.local/bin:$PATH"

# Load Composer tools
export PATH="$HOME/.composer/vendor/bin:$PATH"

# Load Node global installed binaries
export PATH="$HOME/.node/bin:$PATH"

# Use project specific binaries before global ones
export PATH="./:node_modules/.bin:$PATH"

# use sbin
export PATH="/usr/local/sbin:$PATH"

# Brew's Ruby
export PATH="/usr/local/opt/ruby/bin:/usr/local/lib/ruby/gems/2.7.0/bin:$PATH"

# DBngin MySql
export PATH=/Users/Shared/DBngin/mysql/8.2/bin:$PATH

# Make sure coreutils are loaded before system commands
# I've disabled this for now because I only use "ls" which is
# referenced in my aliases.zsh file directly.
#export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"
