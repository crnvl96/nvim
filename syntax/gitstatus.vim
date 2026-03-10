if exists('b:current_syntax')
  finish
endif

" Branch info
syn match gitstatusOnBranch    /^On branch / nextgroup=gitstatusBranch
syn match gitstatusBranch      /\S\+/ contained
syn match gitstatusRemote      /'\zs[^']\+\ze'/

" Section headers
syn match gitstatusHeader      /^Changes to be committed:$/
syn match gitstatusHeader      /^Changes not staged for commit:$/
syn match gitstatusHeader      /^Untracked files:$/
syn match gitstatusHeader      /^Ignored files:$/

" Hints in parentheses
syn match gitstatusHint        /^\s\+(use ".\+")$/

" Staged file status (indented with a tab, under "Changes to be committed")
syn match gitstatusStaged      /^\t\(new file\|modified\|deleted\|renamed\|copied\|typechange\):\s\+.*$/

" Unstaged file status (indented with a tab, under "Changes not staged")
syn match gitstatusUnstaged    /^\t\(modified\|deleted\|typechange\):\s\+.*$/ " same pattern, colored by context

" Untracked files (indented with a tab)
syn match gitstatusUntracked   /^\t[^ \t].\+$/

" Clean/dirty summary
syn match gitstatusClean       /^nothing to commit, working tree clean$/
syn match gitstatusDirty       /^no changes added to commit.*$/

" Up to date / ahead / behind / diverged
syn match gitstatusUpToDate    /^Your branch is up to date with.*$/
syn match gitstatusAhead       /^Your branch is ahead of.*$/
syn match gitstatusBehind      /^Your branch is behind.*$/
syn match gitstatusDiverged    /^Your branch and.\+have diverged.*$/

hi def link gitstatusOnBranch   Keyword
hi def link gitstatusBranch     Title
hi def link gitstatusRemote     String
hi def link gitstatusHeader     @markup.heading
hi def link gitstatusHint       Comment
hi def link gitstatusStaged     Added
hi def link gitstatusUnstaged   Changed
hi def link gitstatusUntracked  Removed
hi def link gitstatusClean      DiagnosticOk
hi def link gitstatusDirty      DiagnosticWarn
hi def link gitstatusUpToDate   DiagnosticOk
hi def link gitstatusAhead      DiagnosticInfo
hi def link gitstatusBehind     DiagnosticWarn
hi def link gitstatusDiverged   DiagnosticError

let b:current_syntax = 'gitstatus'
