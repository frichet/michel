#!/bin/sh

set -xe

# DIR=$(dirname "$0")
upstream=origin

# cd "$DIR/.." || exit 1

if [ "$(git status -s)" ]
then
    echo "The working directory is dirty. Please commit any pending changes."
    exit 1;
fi

echo "Deleting old publication"
rm -rf public
mkdir public
git worktree prune
rm -rf .git/worktrees/public/

echo "Checking out gh-pages branch into public"
git worktree add -B gh-pages public $upstream/gh-pages

echo "Removing existing files"
rm -rf public/*

echo "Generating site"
hugo # -d public

cd public || exit 1

# HitHub pages custom domain
echo michel.frichet.org >> CNAME

echo "Updating gh-pages branch"
git add --all && git commit -m "Publishing to gh-pages (gh-pages.sh)"

git push --force $upstream gh-pages
