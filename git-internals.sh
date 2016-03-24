#!/bin/bash

BASE_DIR=$(cd $(dirname $0) && pwd)

for file in $BASE_DIR/*.dot; do
	name=${file%.dot}
	dot -Tpng -Gsize=10,10\! -Gdpi=100 -o${name}.png ${name}.dot
done

pause() {
	read -N1 -s
	# Discard any other input
	read -s -t 0.1
}

prompt() {
	local prompt="$(echo -n | bash -i 2>&1 >/dev/null)"
	echo -n "${prompt%exit}"
}

run() {
	echo "$@"
	pause
	eval "$@"
	echo
	prompt
	pause
}

show() {
	eog -f $BASE_DIR/${1}.png
	pause
}

clear
prompt && pause
# Intro
# GIT_COMMITTER_NAME='Alexandre Garnier' \
# GIT_COMMITTER_EMAIL='alexandre.garnier@zenika.com' \
# GIT_COMMITTER_DATE='2016-04-21T18:55:00+0200' \
# git -c core.commentchar=- tag --annotate \
#     --message "Entrer dans les entrailles de Git, ou comment faire un commit sans faire du Git.
#
# #DevoxxFR 2016" \
#     introduction $(echo -n '' | git hash-object --stdin -w)
cd $BASE_DIR
run git show introduction

# TODO

# Conclusion
# GIT_COMMITTER_NAME='Alexandre Garnier' \
# GIT_COMMITTER_EMAIL='alexandre.garnier@zenika.com' \
# GIT_COMMITTER_DATE='2016-04-21T19:25:00+0200' \
# git -c core.commentchar=- tag --annotate \
#     --message "Entrer dans les entrailles de Git, ou comment faire un commit sans faire du Git.
#
# #DevoxxFR 2016
#
# https://bitbucket.org/zigarn/git-internals" \
#     conclusion $(GIT_COMMITTER_DATE='2016-04-21T19:25:00+0200' \
#                  GIT_COMMITTER_NAME='Alexandre Garnier' \
#                  GIT_COMMITTER_EMAIL='alexandre.garnier@zenika.com' \
#                  GIT_AUTHOR_DATE='2016-04-21T19:25:00+0200' \
#                  GIT_AUTHOR_NAME='@zigarn' \
#                  GIT_AUTHOR_EMAIL='zigarn@gmail.com' \
#                 git commit-tree \
#                  -m "Merci." \
#                  4b825dc642cb6eb9a060e54bf8d69288fbee4904)
cd $BASE_DIR
run git show --format=fuller conclusion
