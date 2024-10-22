#!/usr/bin/env bash
set -euo pipefail

anon_name="Anonymous"
anon_email="anonymous@example.com"

# WARNING: git-filter-branch has a glut of gotchas generating mangled history
# 	 rewrites.  Hit Ctrl-C before proceeding to abort, then use an
# 	 alternative filtering tool such as 'git filter-repo'
# 	 (https://github.com/newren/git-filter-repo/) instead.  See the
# 	 filter-branch manual page for more details; to squelch this warning,
# 	 set FILTER_BRANCH_SQUELCH_WARNING=1.
git filter-branch -f --env-filter "
    GIT_AUTHOR_NAME='$anon_name'
    GIT_AUTHOR_EMAIL='$anon_email'
    GIT_COMMITTER_NAME='$anon_name'
    GIT_COMMITTER_EMAIL='$anon_email'
    " HEAD
