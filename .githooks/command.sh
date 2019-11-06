RED=$(tput setaf 1)
NORMAL=$(tput sgr0)

# 清理本地存在但是服务器端不存在的分支 +
gs_clear_local_barnch() {
    git fetch -p && for branch in `git branch -vv | grep ': gone]' | awk '{print $1}'`; do git branch -D $branch; done
}

# 查看分支最后提交人和存活周期，辅助删除过期分支 +
gs_branch_last_commit() {
    git fetch --prune
    git for-each-ref --sort='-committerdate' --format="%(refname:short) %09 %(authorname) %09 %(committerdate:relative)"  \
        | grep  --line-buffered "origin" \
        | awk '{printf "%-50s%-25s%s %s %s\n",$1,$2,$3,$4,$5}'
}

# 统计过去一段时间内的代码提交数量，参数 +
#
# $1 : 时间段或者起始时间，如 `7.days` 、`2019-10-10`
gs_past_commit_statistic() {
    git log --format='%aN' | \
        sort -u | \
        while read name; do \
            echo -en "$name\t"; git log --author="$name" --pretty=tformat: --numstat --since="$1" | \
            awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "added lines: %s, removed lines: %s, total lines: %s\n", add, subs, loc }' -; \
        done
}

# 展示所有的别名规则，参考 link:https://stackoverflow.com/questions/7066325/list-git-aliases[list-git-aliases]
gs_show_all_alias() {
    git config --get-regexp ^alias\. | sed -e s/^alias\.// -e s/\ /\ =\ /
}
