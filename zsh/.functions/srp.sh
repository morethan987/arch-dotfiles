# ssh revers proxy
# place this in ~/.bashrc or ~/.zshrc
_srp_default_file="${XDG_CONFIG_HOME:-$HOME/.config}/srp/default"

# ensure config dir exists (will be created on first set-default)
_srp_ensure_dir() {
  mkdir -p "$(dirname "$_srp_default_file")" 2>/dev/null || true
}

# load persisted default (fall back to "spark")
if [ -r "$_srp_default_file" ]; then
  SRP_DEFAULT="$(cat "$_srp_default_file")"
else
  SRP_DEFAULT="spark"
fi

srp() {
  # If no args -> show default then run start
  if [ $# -eq 0 ]; then
    echo "Current default SRP target: $SRP_DEFAULT"
    echo "Starting..."
    set -- start
  fi

  # support -h/--help right away
  case "$1" in
    -h|--help)
      cat <<'EOF'
Usage: srp [start|status|stop|set|current] [alias]
Defaults:
  - default alias read from config file "$XDG_CONFIG_HOME/srp/default" or "~/.config/srp/default"
Behavior:
  - srp              => show current default and then start it
  - srp start X      => start ssh-reverse-proxy@X.service
  - srp status X     => show status of ssh-reverse-proxy@X.service
  - srp stop X       => stop ssh-reverse-proxy@X.service
  - srp set X        => persist X as new default for future shells
  - srp current      => show current persisted default
EOF
      return 0
      ;;
  esac

  action="$1"
  target="${2:-$SRP_DEFAULT}"

  case "$action" in
    start)
      sudo systemctl start "ssh-reverse-proxy@${target}.service"
      return $?
      ;;
    status)
      sudo systemctl status "ssh-reverse-proxy@${target}.service"
      return $?
      ;;
    stop)
      sudo systemctl stop "ssh-reverse-proxy@${target}.service"
      return $?
      ;;
    set)
      if [ -z "$target" ]; then
        echo "Usage: srp set <alias>"
        return 2
      fi
      _srp_ensure_dir
      printf '%s' "$target" > "$_srp_default_file" && SRP_DEFAULT="$target"
      echo "Default SRP target set to: $SRP_DEFAULT"
      return $?
      ;;
    current)
      echo "Current default SRP target: $SRP_DEFAULT"
      return 0
      ;;
    *)
      echo "Unknown action: $action"
      echo "Run: srp -h"
      return 2
      ;;
  esac
}
