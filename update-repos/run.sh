#!/bin/bash

repos=("foreman_ansible" "foreman_azure_rm" "foreman_bootdisk" "foreman_discovery" "foreman_leapp" "foreman_puppet" "foreman-tasks" "foreman_remote_execution" "foreman_openscap")
# repos=("foreman_ansible")

project_dir="$DIR"

if [ -z "$project_dir" ]; then
    echo "Variable DIR is not set"
    echo "Usage: DIR=/path/to/plugins $0"
    exit 1
fi


update_repo() {
  echo "Pulling latest changes for [$1]"
  echo $project_dir/$1
  cd $project_dir/$repo

  default_branch=$(git remote show upstream | grep "HEAD branch" | cut -d' ' -f5)

  git checkout $default_branch
  git pull upstream $default_branch
  echo ""
}

for repo in "${repos[@]}"
do
  update_repo $repo
done

echo "Updating foreman"
cd $project_dir/foreman
git checkout develop
git pull upstream develop

rm -rf $project_dir/foreman/Gemfile.lock
bundle install

bundle exec rails db:migrate
npm install

echo "Done"
