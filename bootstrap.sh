#!/bin/bash

readonly work_dir=$(readlink -e $(dirname ${0}))

panic() {
  if [[ ${1+isset} = isset ]]; then
    echo ${1} 1>&2
  fi
  exit ${2:-1}
}

check_requirements() {
  if [ ! -f /etc/os-release ]; then
    panic "Cannot detect OS"
  fi

  source /etc/os-release
  if [[ "${ID}" != "ubuntu" ]]; then
    panic "Detected unsupported OS: ${ID} <${PRETTY_NAME}>"
  fi
}

pushd ${work_dir} >/dev/null

check_requirements

if ! command -v ansible-playbook >/dev/null 2>&1; then
  sudo apt-get update
  sudo apt-get dist-upgrade --yes --force-yes
  sudo apt-get install --yes --force-yes -- ansible
fi

ansible-playbook -i inventory/localhost --extra-vars="roles=ansible" bootstrap.yml -vvvv $@
ansible-playbook -i inventory/localhost --extra-vars="roles=common" bootstrap.yml -vvvv $@
ansible-playbook -i inventory/localhost --extra-vars="roles=dev" bootstrap.yml -vvvv $@
ansible-playbook -i inventory/localhost --extra-vars="roles=scala" bootstrap.yml -vvvv $@

ansible-playbook -i inventory/localhost --extra-vars="roles=git" --extra-vars="enable_sudo=false" git.yml -vvvv $@
ansible-playbook -i inventory/localhost --extra-vars="roles=ssh" -e "allow_root_login=true" bootstrap.yml -vvvv $@
ansible-playbook -i inventory/localhost --extra-vars="roles=ssh" bootstrap.yml -vvvv $@

ansible-playbook -i inventory/localhost --extra-vars="roles=zsh" --extra-vars="enable_sudo=false" bootstrap.yml -vvvv $@
ansible-playbook -i inventory/localhost --extra-vars="roles=docker" --extra-vars="enable_sudo=false" bootstrap.yml -vvvv $@
ansible-playbook -i inventory/localhost --extra-vars="roles=python" --extra-vars="enable_sudo=false" bootstrap.yml -vvvv $@

ansible-playbook -i inventory/localhost --extra-vars="roles=entertainment" bootstrap.yml -vvvv $@
ansible-playbook -i inventory/localhost --extra-vars="roles=qtcreator" bootstrap.yml -vvvv $@
ansible-playbook -i inventory/localhost --extra-vars="roles=local-repo" --extra-vars="enable_sudo=false" bootstrap.yml -vvvv $@

ansible-playbook -i inventory/localhost --extra-vars="roles=mmc" --extra-vars="enable_sudo=false" bootstrap.yml -vvvv $@

popd >/dev/null