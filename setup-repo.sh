#!/bin/sh

rm -rf repo
mkdir -p repo
cd repo

git init --quiet .
git config --local commit.gpgsign false

echo 'TZ Paris décembre 2022' > tz-paris.txt
mkdir -p folder
echo -n '' >> folder/empty.txt
echo 'Hello world!' >> folder/HelloWorld.txt
git add .
GIT_COMMITTER_NAME='Alexandre Garnier' \
GIT_COMMITTER_EMAIL='alexandre.garnier@zenika.com' \
GIT_COMMITTER_DATE='2022-12-15T16:15:00+0100' \
GIT_AUTHOR_NAME='Alexandre Garnier' \
GIT_AUTHOR_EMAIL='alexandre.garnier@zenika.com' \
GIT_AUTHOR_DATE='2022-12-15T16:15:00+0100' \
git commit --quiet --message '1st commit'
