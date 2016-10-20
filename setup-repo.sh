#!/bin/sh

rm -rf repo
mkdir -p repo
cd repo

git init --quiet .

echo 'Capitole du libre 2016' > CdL.txt
mkdir -p folder
echo -n '' >> folder/empty.txt
echo 'Hello world!' >> folder/HelloWorld.txt
git add .
GIT_COMMITTER_NAME='Alexandre Garnier' \
GIT_COMMITTER_EMAIL='zigarn@gmail.com' \
GIT_COMMITTER_DATE='2016-11-19T17:00:00+0100' \
GIT_AUTHOR_NAME='Alexandre Garnier' \
GIT_AUTHOR_EMAIL='zigarn@gmail.com' \
GIT_AUTHOR_DATE='2016-11-19T17:00:00+0100' \
git commit --quiet --message '1st commit'
