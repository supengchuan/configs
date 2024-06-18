# If this module depends on an external Tmux plugin, say so in a comment.
# E.g.: Requires https://github.com/aaronpowell/tmux-weather

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

show_memory() {
  local index icon color text module

  index=$1
  icon=$(get_tmux_option "@catppuccin_ram_icon" "󰍛")
  color="$(get_tmux_option "@catppuccin_ram_color" "#{ram_bg_color}")"
  text="$(get_tmux_option "@catppuccin_ram_text" "#($CURRENT_DIR/mem_usage.sh)")"

  tmux set-option -g @ram_low_bg_color "$thm_yellow"    # background color when cpu is low
  tmux set-option -g @ram_medium_bg_color "$thm_orange" # background color when cpu is medium
  tmux set-option -g @ram_high_bg_color "$thm_red"      # background color when cpu is high

  module=$(build_status_module "$index" "$icon" "$color" "$text")

  echo "$module"
}
