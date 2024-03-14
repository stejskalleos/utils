#!/bin/sh
endpoint='https://rubygems.org/api/v1/versions'
plugins=('katello' 'foreman_ansible' 'foreman_discovery')


# TODO: Setup
# Create repo Foreman utils

# Install jq, git and curl
# Install dnf install https://yum.theforeman.org/releases/nightly/el8/x86_64/foreman-release.rpm
# also katello
#
echo ""
echo "Latest versions of Foreman plugins"

echo "In RubyGems.org:"
for plugin in ${plugins[@]}
do
  response=$(curl -s "${endpoint}/${plugin}/latest.json" | jq '.version')

  echo "${plugin}: ${response}"
done

echo ""
echo "In Foreman nightly:"

# Check presence of foreman nightly

echo "Updating cache for foreman-plugins repo"
dnf makecache --repo "foreman-plugins"
# TODO: also katello
#

for plugin in ${plugins[@]}
do
  echo $plugin
done

