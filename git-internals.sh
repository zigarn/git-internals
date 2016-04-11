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

fake_run() {
	local cmd=$1
	local res=$2
	echo "$cmd"
	pause
	echo "$res"
	echo
	prompt
	pause
}

show() {
	eog -f $BASE_DIR/${1}.png
	pause
}

zlib-uncompress() {
	python -c "import sys, zlib; sys.stdout.write(zlib.decompress(sys.stdin.read()))"
}
zlib-compress() {
	python -c "import sys, zlib; sys.stdout.write(zlib.compress(sys.stdin.read()))"
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

# Creation du dépôt de démo
run source ./setup-repo.sh
run git log --graph --decorate --stat
run 'git show HEAD:devoxx.txt | cat -A'
run 'git show HEAD:folder/HelloWorld.txt | cat -A'
run 'git show HEAD:folder/empty.txt | cat -A'

# HEAD
run cat -A .git/HEAD
show head

# Reference
run cat -A .git/refs/heads/master
show ref

# Commit
run cat -A .git/objects/1c/3071594c824c3e56c2880a5762b255b4353446
run 'cat .git/objects/1c/3071594c824c3e56c2880a5762b255b4353446 | zlib-uncompress | cat -A'
show commit

# Tree
run 'cat .git/objects/de/4e37df389aa8030f77ec4739ec68cffcb08a57 | zlib-uncompress | cat -A'
run 'cat .git/objects/de/4e37df389aa8030f77ec4739ec68cffcb08a57 | zlib-uncompress | xxd -p -s 26 -l 20'
run 'cat .git/objects/de/4e37df389aa8030f77ec4739ec68cffcb08a57 | zlib-uncompress | xxd -p -s 59 -l 20'
fake_run 'cat .git/objects/de/4e37df389aa8030f77ec4739ec68cffcb08a57 | zlib-uncompress | decode' 'tree 71^@100644 devoxx.txt^@961777f374f9ad986b004f07049b3f6443ff270f40000 folder^@49b4e4747c1c1bd8746235f146fe287992add5e9'
fake_run 'cat .git/objects/49/b4e4747c1c1bd8746235f146fe287992add5e9 | zlib-uncompress | decode' 'tree 79^@100644 HelloWorld.txt^@cd0875583aabe89ee197ea133980a9085d08e497100644 empty.txt^@e69de29bb2d1d6434b8b29ae775ad8c2e48c5391'
show tree

# Blob
run 'cat .git/objects/96/1777f374f9ad986b004f07049b3f6443ff270f | zlib-uncompress | cat -A'
run 'cat .git/objects/cd/0875583aabe89ee197ea133980a9085d08e497 | zlib-uncompress | cat -A'
run 'cat .git/objects/e6/9de29bb2d1d6434b8b29ae775ad8c2e48c5391 | zlib-uncompress | cat -A'
show blob

# Git objects
fake_run 'display-format blob' 'blob SPACE <size> NULL <content>'
fake_run 'display-format tree' 'tree SPACE <size> NULL (<mode> SPACE <name> NULL <binary_sha1>)+'
fake_run 'display-format commit' 'commit SPACE <size> NULL tree SPACE <sha1> LF
(parent SPACE <sha1> LF)*
author SPACE <author> SPACE <timestamp> LF
commiter SPACE <committer> SPACE <timestamp> LF
LF
<message>'
fake_run 'display-format ref' '<sha1>'
fake_run 'display-format HEAD' 'ref: SPACE refs/heads/<branch_name>'

# Clean
run 'rm -rf * .git && git init --quiet .'
run ls -la
run git log --graph --decorate

# Create blobs
run 'BLOB="Devoxx France 2016\n" && echo -ne $BLOB | cat -A'
run 'GIT_OBJECT=$(echo -n "blob $(echo -ne $BLOB | wc --bytes)\x00$BLOB") && echo -ne $GIT_OBJECT | cat -A'
run 'BLOB_DEVOXX_SHA1=$(echo -ne $GIT_OBJECT | sha1sum | awk "{ print \$1 }") && echo $BLOB_DEVOXX_SHA1'
run 'mkdir -p .git/objects/${BLOB_DEVOXX_SHA1:0:2} && echo -ne $GIT_OBJECT | zlib-compress > .git/objects/${BLOB_DEVOXX_SHA1:0:2}/${BLOB_DEVOXX_SHA1:2}'

run 'BLOB="Hello world!\n" && echo -ne $BLOB | cat -A
GIT_OBJECT=$(echo -n "blob $(echo -ne $BLOB | wc --bytes)\x00$BLOB") && echo -ne $GIT_OBJECT | cat -A
BLOB_HELLO_SHA1=$(echo -ne $GIT_OBJECT | sha1sum | awk "{ print \$1 }") && echo $BLOB_HELLO_SHA1
mkdir -p .git/objects/${BLOB_HELLO_SHA1:0:2} && echo -ne $GIT_OBJECT | zlib-compress > .git/objects/${BLOB_HELLO_SHA1:0:2}/${BLOB_HELLO_SHA1:2}'

run 'BLOB="" && echo -e $BLOB | cat -A
GIT_OBJECT=$(echo -n "blob $(echo -ne $BLOB | wc --bytes)\x00$BLOB") && echo -e $GIT_OBJECT | cat -A
BLOB_EMPTY_SHA1=$(echo -ne $GIT_OBJECT | sha1sum | awk "{ print \$1 }") && echo $BLOB_EMPTY_SHA1
mkdir -p .git/objects/${BLOB_EMPTY_SHA1:0:2} && echo -ne $GIT_OBJECT | zlib-compress > .git/objects/${BLOB_EMPTY_SHA1:0:2}/${BLOB_EMPTY_SHA1:2}'

show create_blobs

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
