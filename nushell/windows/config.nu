# config.nu
#
# Installed by:
# version = "0.104.1"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# This file is loaded after env.nu and before login.nu
#
# You can open this file in your default editor using:
# config nu
#
# See `help config nu` for more options
#
# You can remove these comments if you want or leave
# them for future reference.

$env.config.show_banner = false
alias lz = lazygit
alias ll = ls -la
alias l = ls
alias yz = yazi
alias cl = clear

$env.HTTP_PROXY = "http://127.0.0.1:7897"
$env.HTTPS_PROXY = "http://127.0.0.1:7897"


# table.*
# mode (string):
# Specifies the visual display style of a table
# One of: "default", "basic", "compact", "compact_double", "heavy", "light", "none", "reinforced",
# "rounded", "thin", "with_love", "psql", "markdown", "dots", "restructured", "ascii_rounded",
# or "basic_compact"
# Can be overridden by passing a table to `| table --theme/-t`
$env.config.table.mode = "compact"

#source ~/.zoxide.nu
source ./zoxide.nu

def open [
    path?: string  # optional path
] {
    let target = if $path == null { '.' } else { $path }
    ^explorer $target
}
