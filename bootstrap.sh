#!/bin/bash

panic() {
  if [[ ${1+isset} = isset ]]; then
    echo ${1} 1>&2
  fi
  exit ${2:-1}
}

check_prerequirements() {
  if [ ! -f /etc/os-release ]; then
    panic "Cannot detect OS"
  fi

  source /etc/os-release
  if [[ "${ID}" != "ubuntu" ]]; then
    panic "Detected unsupported OS: ${ID} <${PRETTY_NAME}>"
  fi
}

check_prerequirements

sudo apt-get update
sudo apt-get dist-upgrade --yes --force-yes
sudo apt-get install ansible

ansible-playbook -i inventory/localhost --extra-vars="roles=ansible" bootstrap.yml -K -vvvv $@
ansible-playbook -i inventory/localhost --extra-vars="roles=common" bootstrap.yml -K -vvvv $@
ansible-playbook -i inventory/localhost --extra-vars="roles=dev" bootstrap.yml -K -vvvv $@

ansible-playbook -i inventory/localhost --extra-vars="roles=git" --extra-vars="enable_sudo=false" git.yml -K -vvvv $@
ansible-playbook -i inventory/localhost --extra-vars="roles=zsh" --extra-vars="enable_sudo=false" bootstrap.yml -K -vvvv $@
