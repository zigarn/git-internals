#!/bin/sh

rm -rf repo
mkdir -p repo
cd repo

git init --quiet .

echo 'Devoxx France 2016' > devoxx.txt
mkdir -p folder
echo -n '' >> folder/empty.txt
echo 'Hello world!' >> folder/HelloWorld.txt
git add .
GIT_COMMITTER_NAME='Alexandre Garnier' \
GIT_COMMITTER_EMAIL='alexandre.garnier@zenika.com' \
GIT_COMMITTER_DATE='2016-04-21T18:55:00+0200' \
GIT_AUTHOR_NAME='Alexandre Garnier' \
GIT_AUTHOR_EMAIL='alexandre.garnier@zenika.com' \
GIT_AUTHOR_DATE='2016-04-21T18:55:00+0200' \
git commit --quiet --message '1st commit'
