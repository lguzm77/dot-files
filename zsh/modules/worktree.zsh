# git worktree aliases

wt() {
  case "$1" in
    list|l)
      git worktree list
      ;;
    create|c)
      local name="${2:?Usage: wt create <name> [branch]}"
      local branch="${3:-$(git branch --show-current)}"
      git worktree add -b "$name" "$HOME/git-worktrees/$name" "$branch"
      ;;
    remove|rm)
      local worktree="${2:?Usage: wt remove <worktree>}"
      git worktree remove "$worktree"
      ;;
    *)
      git worktree "$@"
      ;;
  esac
}

_wt() {
  local -a worktrees
  worktrees=($(git worktree list --porcelain 2>/dev/null | awk 'NR%2==1 {gsub(/^\.\.\//, ""); print $1}' | xargs -I{} basename {}))
  _arguments \
    '1: :((list:l create:c remove:rm))' \
    '2:worktree:($worktrees)'
}
compdef _wt wt
