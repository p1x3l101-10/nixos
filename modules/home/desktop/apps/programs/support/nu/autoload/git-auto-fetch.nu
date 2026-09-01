const repoCooldown = 4hr
const cooldownPause = "pause"

def "__hook-in-git-repo_dirRecursion" [ acc: list<string> ]: nothing -> list<string> {
  let topDir = $acc | last
  if ($topDir == "/") {
    return $acc
  } else {
    __hook-in-git-repo_dirRecursion ($acc ++ [ ($topDir | path dirname) ])
  }
}

def "__hook-in-git-repo_locate" []: string -> any {
  __hook-in-git-repo_dirRecursion [ $in ]
  | par-each { |x|
    {
      path: $x
      repoBase: ($x | path join ".git" | path exists)
    }
  }
  | where $it.repoBase == true
  | last
  | get path?
}

def "__hook-in-git-repo_cooldown" [--pause]: string -> bool {
  let repoData = $in | path join ".git"
  # End early if bad access perms
  if (ls -laD $repoData | get 0.readonly) {
    return true
  }
  let suffix = (if $pause {".paused"} else {""})
  let timestamp = $repoData | path join $"nu-hooks/cooldown-timestamp($suffix)"
  if ($timestamp | path exists) {
    ls -la $timestamp
    | get 0.created
    | if ((date now) - $repoCooldown) < $in { # Returns true when timestamp file is older
      return true
    } else {
      if (open $timestamp | str contains $cooldownPause) and (not $pause) {
        __hook-in-git-repo_cooldown --pause
        return true
      }
      if $pause {
        print $"(ansi magenta)->  Note: git shell hooks are paused(ansi reset)"
      }
      # Reset timestamp
      rm $timestamp
      touch $timestamp
      return false
    }
  } else {
    mkdir ($timestamp | path dirname)
    touch $timestamp
    return false
  }
}

def "__hook-in-git-repo" []: string -> nothing {
  let repo = $in
  def --wrapped git [...args] {
    ^git -C $repo ...$args
  }
  print $"(ansi magenta)->  Running periodic shell hooks for git, this may take a moment(ansi reset)"
  # All the funny git hooks to run
  print $"(ansi cyan)>>  Fetching remotes(ansi reset)"
  do {
    git remote
    | split row "\n"
    | each { |x|
      print $"(ansi cyan_dimmed)>>> Fetching from: ($x)(ansi reset)"
      git fetch $x | ignore
    }
  }
  print $"(ansi magenta)->  Finished work, see you (((date now) + $repoCooldown) | date humanize)(ansi reset)"
}

# Inject hook into nushell
$env.config = ($env.config | upsert hooks {
  env_change: {
    PWD: [
      {
        condition: {|before, after|
          let repo = $after | __hook-in-git-repo_locate
          if ($repo | is-empty) {
            return false
          }
          not ($repo | __hook-in-git-repo_cooldown)
        }
        code: {|before, after|
          $after | __hook-in-git-repo_locate | __hook-in-git-repo
        }
      }
    ]
  }
})
