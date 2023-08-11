#!/bin/bash

plugins=("foreman_ansible" "foreman_azure_rm" "foreman_bootdisk" "foreman_discovery" "foreman-discovery-image" "foreman_leapp" "foreman_puppet")
output="open_prs.txt"

github_call() {
  echo "Pulling $1 repository"
  echo "$1" >> $output

  gh pr list --json number,author,title,updatedAt,url --template \
        '{{range .}}{{(printf "#%v" .number)}} {{(hyperlink .url .title)}}  ({{.author.login}}, {{(timeago .updatedAt)}}) {{"\n"}}{{end}}' \
        --repo $1 >> $output
  echo "" >> $output
}

clear
echo "Running all open PRs report"
rm -rf $output

for plugin in "${plugins[@]}"; do
    github_call "theforeman/$plugin"
done

echo "Done."
echo "========================="
cat $output;
