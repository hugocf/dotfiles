#!/usr/bin/env bash
set -euo pipefail

random_task=$(things.sh today 2> /dev/null | grep " things:///show" | sort --sort=random | head -n 1 | sed 's/   */ | /g')
task_url=$(echo "$random_task" | cut -d '|' -f 3 | tr -d ' ')

echo "$random_task"
open "$task_url"
