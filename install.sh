set -o errexit

panic() {
  echo ${1} 1>&2
  exit ${2:-1}
}

check_requirements() {
  if ! command -v grep >/dev/null 2>&1; then
    panic "Grep is not installed"
  fi
  if [ ! -f /etc/os-release ]; then
    panic "Cannot detect OS"
  fi
  if ! grep -q 'ID=ubuntu' /etc/os-release; then
    panic "Detected unsupported OS"
  fi
}

main() {
  check_requirements

  if ! command -v git >/dev/null 2>&1; then
    sudo apt-get update
    sudo apt-get install --yes --force-yes -- git
  fi

  git clone --depth=1 https://github.com/lyobzik/zhivovlyak.git
}

main
