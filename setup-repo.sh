#!/bin/sh

rm -rf repo
mkdir -p repo
cd repo

git init --quiet .

echo 'Technozaure Zeus 2022-04-07' > technozaure.txt
mkdir -p folder
echo -n '' >> folder/empty.txt
echo 'Hello world!' >> folder/HelloWorld.txt
git add .
GIT_COMMITTER_NAME='Alexandre Garnier' \
GIT_COMMITTER_EMAIL='alexandre.garnier@zenika.com' \
GIT_COMMITTER_DATE='2022-04-07T15:00:00+0200' \
GIT_AUTHOR_NAME='Alexandre Garnier' \
GIT_AUTHOR_EMAIL='alexandre.garnier@zenika.com' \
GIT_AUTHOR_DATE='2022-04-07T15:00:00+0200' \
git commit --quiet --message '1st commit'
