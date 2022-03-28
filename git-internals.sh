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
	eog -f $BASE_DIR/${1}.png 2>/dev/null
	pause
}

zlib-uncompress() {
	python3 -c "import sys, zlib; sys.stdout.buffer.write(zlib.decompress(sys.stdin.buffer.read()))"
}
zlib-compress() {
	python3 -c "import sys, zlib; sys.stdout.buffer.write(zlib.compress(sys.stdin.buffer.read()))"
}

clear
prompt && pause
# Intro
# GIT_COMMITTER_NAME='Alexandre Garnier' \
# GIT_COMMITTER_EMAIL='alexandre.garnier@zenika.com' \
# GIT_COMMITTER_DATE='2022-04-07T15:00:00+0200' \
# git -c core.commentchar=- tag --annotate \
#     --message "Entrer dans les entrailles de Git, ou comment faire un commit sans faire du Git.
#
# TZ Zeus 2022-04-07" \
#     introduction-tz-zeus \
#     $(echo -n '' | git hash-object --stdin -w)
cd $BASE_DIR
run git show introduction-tz-zeus

# Creation du dépôt de démo
run source ./setup-repo.sh
run git log --graph --decorate --stat
run 'git show HEAD:technozaure.txt | cat -A'
run 'git show HEAD:folder/HelloWorld.txt | cat -A'
run 'git show HEAD:folder/empty.txt | cat -A'

# HEAD
run cat -A .git/HEAD
show head

# Reference
run cat -A .git/refs/heads/main
show ref

# Commit
run cat -A .git/objects/70/8ec61b4f025fb64e088cb12f2f21528b0dfd02
run 'cat .git/objects/70/8ec61b4f025fb64e088cb12f2f21528b0dfd02 | zlib-uncompress | cat -A'
show commit

# Tree
run 'cat .git/objects/1f/9db589d78405c6031e229956edbfa76d8b1cd5 | zlib-uncompress | cat -A'
run 'cat .git/objects/1f/9db589d78405c6031e229956edbfa76d8b1cd5 | zlib-uncompress | xxd -p -s 21 -l 20'
run 'cat .git/objects/1f/9db589d78405c6031e229956edbfa76d8b1cd5 | zlib-uncompress | xxd -p -s 64 -l 20'
fake_run 'cat .git/objects/1f/9db589d78405c6031e229956edbfa76d8b1cd5 | zlib-uncompress | decode' 'tree 76^@40000 folder^@49b4e4747c1c1bd8746235f146fe287992add5e9100644 technozaure.txt^@dd67068aff90e6cb95f7cc89ca7bef89811e6f03'
fake_run 'cat .git/objects/49/b4e4747c1c1bd8746235f146fe287992add5e9 | zlib-uncompress | decode' 'tree 79^@100644 HelloWorld.txt^@cd0875583aabe89ee197ea133980a9085d08e497100644 empty.txt^@e69de29bb2d1d6434b8b29ae775ad8c2e48c5391'
show tree

# Blob
run 'cat .git/objects/cd/0875583aabe89ee197ea133980a9085d08e497 | zlib-uncompress | cat -A'
run 'cat .git/objects/e6/9de29bb2d1d6434b8b29ae775ad8c2e48c5391 | zlib-uncompress | cat -A'
run 'cat .git/objects/dd/67068aff90e6cb95f7cc89ca7bef89811e6f03 | zlib-uncompress | cat -A'
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
run 'BLOB="Technozaure Zeus 2022-04-07\n" && echo -ne $BLOB | cat -A'
run 'GIT_OBJECT=$(echo -n "blob $(echo -ne $BLOB | wc --bytes)\x00$BLOB") && echo -ne $GIT_OBJECT | cat -A'
run 'BLOB_TZ_SHA1=$(echo -ne $GIT_OBJECT | sha1sum | awk "{ print \$1 }") && echo $BLOB_TZ_SHA1'
run 'mkdir -p .git/objects/${BLOB_TZ_SHA1:0:2} && echo -ne $GIT_OBJECT | zlib-compress > .git/objects/${BLOB_TZ_SHA1:0:2}/${BLOB_TZ_SHA1:2}'

run 'BLOB="Hello world!\n" && echo -ne $BLOB | cat -A
GIT_OBJECT=$(echo -n "blob $(echo -ne $BLOB | wc --bytes)\x00$BLOB") && echo -ne $GIT_OBJECT | cat -A
BLOB_HELLO_SHA1=$(echo -ne $GIT_OBJECT | sha1sum | awk "{ print \$1 }") && echo $BLOB_HELLO_SHA1
mkdir -p .git/objects/${BLOB_HELLO_SHA1:0:2} && echo -ne $GIT_OBJECT | zlib-compress > .git/objects/${BLOB_HELLO_SHA1:0:2}/${BLOB_HELLO_SHA1:2}'

run 'BLOB="" && echo -e $BLOB | cat -A
GIT_OBJECT=$(echo -n "blob $(echo -ne $BLOB | wc --bytes)\x00$BLOB") && echo -e $GIT_OBJECT | cat -A
BLOB_EMPTY_SHA1=$(echo -ne $GIT_OBJECT | sha1sum | awk "{ print \$1 }") && echo $BLOB_EMPTY_SHA1
mkdir -p .git/objects/${BLOB_EMPTY_SHA1:0:2} && echo -ne $GIT_OBJECT | zlib-compress > .git/objects/${BLOB_EMPTY_SHA1:0:2}/${BLOB_EMPTY_SHA1:2}'

show create_blobs

# Create trees (use files to avoid interpretation of binary during echoes)
run '(echo -ne "100644 HelloWorld.txt\x00"; echo $BLOB_HELLO_SHA1 | xxd -r -p; echo -ne "100644 empty.txt\x00"; echo $BLOB_EMPTY_SHA1 | xxd -r -p) >/tmp/tree && cat -A /tmp/tree && echo'
run '(echo -ne "tree $(wc --bytes /tmp/tree | awk "{ print \$1 }")\x00"; cat /tmp/tree) >/tmp/git_object && cat -A /tmp/git_object && echo'
run 'TREE_FOLDER_SHA1=$(sha1sum /tmp/git_object | awk "{ print \$1 }") && echo $TREE_FOLDER_SHA1'
run 'mkdir -p .git/objects/${TREE_FOLDER_SHA1:0:2} && cat /tmp/git_object | zlib-compress > .git/objects/${TREE_FOLDER_SHA1:0:2}/${TREE_FOLDER_SHA1:2}'

run '(echo -ne "40000 folder\x00"; echo $TREE_FOLDER_SHA1 | xxd -r -p; echo -ne "100644 technozaure.txt\x00"; echo $BLOB_TZ_SHA1 | xxd -r -p) >/tmp/tree && cat -A /tmp/tree && echo
(echo -ne "tree $(wc --bytes /tmp/tree | awk "{ print \$1 }")\x00"; cat /tmp/tree) >/tmp/git_object && cat -A /tmp/git_object && echo
TREE_ROOT_SHA1=$(sha1sum /tmp/git_object | awk "{ print \$1 }") && echo $TREE_ROOT_SHA1
mkdir -p .git/objects/${TREE_ROOT_SHA1:0:2} && cat /tmp/git_object | zlib-compress > .git/objects/${TREE_ROOT_SHA1:0:2}/${TREE_ROOT_SHA1:2}'

show create_trees

# Create commit
run 'COMMIT_DATE=$(date -d "2022-04-07T15:00:00+0200" +"%s %z") && echo $COMMIT_DATE'
run 'COMMIT="tree $TREE_ROOT_SHA1\nauthor Alexandre Garnier <alexandre.garnier@zenika.com> $COMMIT_DATE\ncommitter Alexandre Garnier <alexandre.garnier@zenika.com> $COMMIT_DATE\n\n1st commit\n" && echo -ne $COMMIT | cat -A'
run 'GIT_OBJECT=$(echo -n "commit $(echo -ne $COMMIT | wc --bytes)\x00$COMMIT") && echo -ne $GIT_OBJECT | cat -A'
run 'COMMIT_SHA1=$(echo -ne $GIT_OBJECT | sha1sum | awk "{ print \$1 }") && echo $COMMIT_SHA1'
run 'mkdir -p .git/objects/${COMMIT_SHA1:0:2} && echo -ne $GIT_OBJECT | zlib-compress > .git/objects/${COMMIT_SHA1:0:2}/${COMMIT_SHA1:2}'

show create_commit

# Set references
run 'echo $COMMIT_SHA1 >.git/refs/heads/main'
run 'echo "ref: refs/heads/main" >.git/HEAD'

show create_refs

# Check
run git log --graph --decorate --stat
run 'git show HEAD:technozaure.txt | cat -A'
run 'git show HEAD:folder/HelloWorld.txt | cat -A'
run 'git show HEAD:folder/empty.txt | cat -A'
run ls -la
run git reset --hard
run ls -lhpR

# Conclusion
# GIT_COMMITTER_NAME='Alexandre Garnier' \
# GIT_COMMITTER_EMAIL='alexandre.garnier@zenika.com' \
# GIT_COMMITTER_DATE='2022-04-07T15:30:00+0200' \
# git -c core.commentchar=- tag --annotate \
#     --message "Entrer dans les entrailles de Git, ou comment faire un commit sans faire du Git.
#
# TZ Zeus 2022-04-07
#
# https://github.com/zigarn/git-internals" \
#     conclusion-tz-zeus \
#     $(GIT_COMMITTER_DATE='2022-04-07T15:30:00+0200' \
#       GIT_COMMITTER_NAME='Alexandre Garnier' \
#       GIT_COMMITTER_EMAIL='alexandre.garnier@zenika.com' \
#       GIT_AUTHOR_DATE='2022-04-07T15:30:00+0200' \
#       GIT_AUTHOR_NAME='@zigarn' \
#       GIT_AUTHOR_EMAIL='zigarn@gmail.com' \
#       git commit-tree \
#           -m "Merci." \
#           4b825dc642cb6eb9a060e54bf8d69288fbee4904)
cd $BASE_DIR
run git show --format=fuller conclusion-tz-zeus
exit
