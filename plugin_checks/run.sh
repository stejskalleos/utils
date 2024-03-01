#!/bin/bash

# Array of GitHub repository URLs
repositories=(
  "https://github.com/theforeman/foreman_ansible.git"
  "https://github.com/theforeman/hammer-cli-foreman-ansible.git"
  "https://github.com/theforeman/foreman_discovery.git"
  "https://github.com/theforeman/hammer-cli-foreman-discovery.git"
  "https://github.com/theforeman/foreman_bootdisk.git"
  "https://github.com/theforeman/hammer_cli_foreman_bootdisk.git"
  "https://github.com/theforeman/foreman_azure_rm.git"
  "https://github.com/theforeman/hammer_cli_foreman_azure_rm.git"
  "https://github.com/theforeman/foreman_google.git"
  "https://github.com/theforeman/hammer-cli-foreman-google.git"
  "https://github.com/theforeman/foreman_leapp.git"
  "https://github.com/theforeman/hammer-cli-foreman-leapp.git"
  "https://github.com/theforeman/foreman_puppet.git"
  "https://github.com/theforeman/hammer-cli-foreman-puppet.git"
  "https://github.com/theforeman/foreman_kubevirt.git"
  "https://github.com/theforeman/hammer-cli-foreman-kubevirt.git"
)

# Directory to clone repositories into
temp_dir='/tmp/repo_check'
mkdir -p $temp_dir

check_packit() {
  if grep -sq "rhel-8" --include=\*packit\* -R .; then
    echo -e "\033[32mY - RHEL 8 Packit\033[0m"
  else
    echo -e "\033[31mF - RHEL 8 Packit\033[0m"
  fi

  if grep -sq "rhel-9" --include=\*packit\* -R .; then
    echo -e "\033[32mY - RHEL 9 Packit\033[0m"
  else
    echo -e "\033[31mF - RHEL 9 Packit\033[0m"
  fi
}


check_shared_gh() {
  if grep -sq "theforeman/actions/.github/workflows/rubocop.yml" -R "./.github"; then
    echo -e "\033[32mY - Rubocop GH Action\033[0m"
  else
    echo -e "\033[31mF - Rubocop GH Action\033[0m"
  fi

  if grep -sq "theforeman/actions/.github/workflows/foreman_plugin.yml" -R "./.github"; then
    echo -e "\033[32mY - Foreman plugin test GH Action\033[0m"
  else
    echo -e "\033[31mF - Foreman plugin test GH Action\033[0m"
  fi
}

check_release() {
  if grep -sq "theforeman/actions/.github/workflows/release-gem.yml" -R "./.github"; then
    echo -e "\033[32mY - Foreman release gem GH Action\033[0m"
  else
    echo -e "\033[31mF - Foreman release gem GH Action\033[0m"
  fi
}

for repo in "${repositories[@]}"; do
  repo_name=$(basename "$repo" .git)
  clone_dir="$temp_dir/$repo_name"

  if [ -d "$clone_dir" ]; then
    pushd "$clone_dir" > /dev/null
    git pull --quiet
  else
    git clone --quiet --single-branch --depth 1 "$repo" "$clone_dir"
  fi

  pushd "$clone_dir" > /dev/null

  echo ""
  echo -e "\033[94m$repo_name\033[0m"
  echo "----------------"
  check_packit
  check_shared_gh
  check_release

  popd > /dev/null
done
