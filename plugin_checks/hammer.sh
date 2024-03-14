#!/bin/bash

# Array of GitHub repository URLs
repositories=(
  "hammer-cli-foreman-ansible"
  "hammer-cli-foreman-discovery"
  "hammer_cli_foreman_bootdisk"
  "hammer_cli_foreman_azure_rm"
  "hammer-cli-foreman-google"
  "hammer-cli-foreman-leapp"
  "hammer-cli-foreman-puppet"
  "hammer-cli-foreman-kubevirt"
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


check_rubocop() {
  if grep -sq "theforeman/actions/.github/workflows/rubocop.yml" -R "./.github"; then
    echo -e "\033[32mY - Rubocop GH Action\033[0m"
  else
    echo -e "\033[31mF - Rubocop GH Action\033[0m"
  fi

}

check_test() {
  if [ -d "./test" ]; then
    if grep -sq "theforeman/actions/.github/workflows/test-gem.yml" -R "./.github"; then
      echo -e "\033[32mY - Foreman plugin test GH Action\033[0m"
    else
      echo -e "\033[31mF - Foreman plugin test GH Action\033[0m"
    fi
  else
      echo -e "\033[0;33mS - ./test dir not found, skipping ... \033[0m"
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
  clone_dir="$temp_dir/$repo"

  if [ -d "$clone_dir" ]; then
    pushd "$clone_dir" > /dev/null
    git pull --quiet
  else
    git clone --quiet --single-branch --depth 1 "git@github.com:theforeman/$repo.git" "$clone_dir"
  fi

  pushd "$clone_dir" > /dev/null

  echo ""
  echo -e "\033[94m$repo\033[0m https://github.com/theforeman/$repo"
  echo "----------------"
  check_packit
  check_rubocop
  check_test
  # check_release

  popd > /dev/null
done
