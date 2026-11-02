#!/bin/bash
{
# Truncation guard: this brace group ensures bash reads the entire file before
# running any command. A partial download is an unterminated compound command.
set -euo pipefail

PACKAGE="macx-agents"
REPOSITORY="user/macx"
numeric_identifier='(0|[1-9][0-9]*)'
prerelease_identifier="(${numeric_identifier}|[0-9A-Za-z-]*[A-Za-z-][0-9A-Za-z-]*)"
build_identifier='[0-9A-Za-z-]+'
version_pattern="${numeric_identifier}\.${numeric_identifier}\.${numeric_identifier}(-${prerelease_identifier}(\.${prerelease_identifier})*)?(\\+${build_identifier}(\.${build_identifier})*)?$"
version="${MACX_VERSION:-}"
version_requested=false
dry_run=false
start_setup=true
verbose=false

fail() {
  printf 'MACX installation failed: %s\n' "$1" >&2
  exit 1
}

matches() {
  eval '[[ "$1" =~ $2 ]]'
}

node_host_labels() {
  case "$(uname -m)" in
    arm64|aarch64) node_arch_label="arm64" ;;
    x86_64|amd64) node_arch_label="x64" ;;
    *) node_arch_label="$(uname -m)" ;;
  esac
  case "$(uname -s)" in
    Darwin) node_os_label="darwin" ;;
    Linux) node_os_label="linux" ;;
    *) node_os_label="$(uname -s | tr '[:upper:]' '[:lower:]')" ;;
  esac
}

fail_node_version() {
  local observed="$1"
  node_host_labels
  printf 'MACX installation failed: Node.js %s is unsupported.\n\n' "$observed" >&2
  printf 'MACX requires Node.js 22.x (>=22.23.4), 24.x (>=24.22.1), or 26.12.1+. Install one via:\n' >&2
  printf '  nvm:  nvm install 24 && nvm use 24      (https://github.com/nvm-sh/nvm)\n' >&2
  printf '  fnm:  fnm install 24 && fnm use 24      (https://github.com/Schniz/fnm)\n' >&2
  printf '  Direct download for %s/%s:\n' "$node_os_label" "$node_arch_label" >&2
  printf '    https://nodejs.org/dist/latest-v24.x/  (grab the %s-%s tarball)\n' "$node_os_label" "$node_arch_label" >&2
  printf 'Then rerun this installer.\n' >&2
  exit 1
}

usage() {
  cat <<'EOF'
Usage: install.sh [--version VERSION] [--dry-run] [--no-setup] [--no-prompt] [--verbose]

Installs the MACX CLI, then starts `macx setup` interactively to configure
analysis providers and agents when a terminal is available. Pass --no-setup
(or --no-prompt) to skip setup and run `macx setup` later.
EOF
}

main() {
  while (($# > 0)); do
    case "$1" in
      --version)
        (($# >= 2)) || fail "--version requires a value."
        version="$2"
        version_requested=true
        shift 2
        ;;
      --dry-run)
        dry_run=true
        shift
        ;;
      --no-setup|--no-prompt)
        start_setup=false
        shift
        ;;
      --verbose)
        verbose=true
        shift
        ;;
      --help|-h)
        usage
        exit 0
        ;;
      *) fail "unknown option: $1" ;;
    esac
  done

  if [ "$verbose" = true ]; then
    set -x
  fi

  platform="$(uname -s)"
  [ "$platform" = "Darwin" ] || [ "$platform" = "Linux" ] || fail "MACX supports macOS and selected 64-bit Linux distributions."
  command -v curl >/dev/null 2>&1 || fail "curl is required. Install curl, then rerun this installer."
  command -v node >/dev/null 2>&1 || fail "Node.js 22.x (>=22.23.4), 24.x (>=24.22.1), or 26.12.1+ is required; install it from https://nodejs.org and retry."
  command -v npm >/dev/null 2>&1 || fail "npm is required; install it with Node.js and retry."

  node_version="$(node -p 'process.versions.node' 2>/dev/null || true)"
  IFS=. read -r node_major node_minor _node_patch <<<"$node_version"
  matches "$node_major" '^[0-9]+$' && matches "$node_minor" '^[0-9]+$' || fail "the active Node.js version could not be read."
  node_patch="${_node_patch%%+*}"
  if ! matches "$_node_patch" '^[0-9]+(\+[0-9A-Za-z.-]+)?$' ||
    ! ((node_major == 22 && (node_minor > 23 || node_minor == 23 && node_patch >= 4) ||
      node_major == 24 && (node_minor > 22 || node_minor == 22 && node_patch >= 1) ||
      node_major == 26 && (node_minor > 12 || node_minor == 12 && node_patch >= 1) ||
      node_major > 26)); then
    fail_node_version "$node_version"
  fi

  if [ "$version_requested" = true ] || [ -n "$version" ]; then
    matches "$version" "^${version_pattern}" || fail "version must be an exact semantic version."
  else
    version="1.0.0"
  fi

  install_args=(install --global)
  if [ "$platform" = "Linux" ]; then
    install_args+=(--prefix "$HOME/.local")
    install_bin="$HOME/.local/bin/macx"
  else
    npm_prefix="$(npm prefix --global)" || fail "the npm global prefix could not be read."
    install_bin="$npm_prefix/bin/macx"
  fi
  install_args+=("$PACKAGE@$version")

  printf 'MACX install plan\n'
  printf '  Version: %s\n' "$version"
  printf '  Runtime: Node.js %s\n' "$node_version"
  printf '  Command:'
  printf ' %q' npm "${install_args[@]}"
  printf '\n'
  printf '  Binary:  %s\n' "$install_bin"
  printf '  Setup:   %s\n' "$([ "$start_setup" = true ] && printf 'start when a terminal is available' || printf 'skipped')"

  if [ "$dry_run" = true ]; then
    printf 'Dry run complete; no changes made.\n'
    exit 0
  fi

  printf 'Installing %s@%s...\n' "$PACKAGE" "$version"
  npm "${install_args[@]}" || fail "npm could not install MACX. Check registry access and npm permissions, then retry."
  [ -x "$install_bin" ] || fail "npm completed without installing the macx command."

  printf 'MACX %s is installed.\n' "$version"
  if [ "$start_setup" = true ] && [ -r /dev/tty ] && [ -w /dev/tty ] && [ -t 1 ] && [ -t 2 ]; then
    printf 'Starting MACX setup...\n'
    "$install_bin" setup </dev/tty >/dev/tty
  else
    printf 'Run %s setup to configure analysis providers and agents.\n' "$install_bin"
  fi
}

main "$@"
exit $?
}
