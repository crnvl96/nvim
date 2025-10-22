" Vim syntax file for git status
" Language: git-status

if exists("b:current_syntax")
  finish
endif

syn case match

" Section headers
syn match gitStatusHeader "^Changes to be committed:$"
syn match gitStatusHeader "^Changes not staged for commit:$"
syn match gitStatusHeader "^Untracked files:$"
syn match gitStatusHeader "^Unmerged paths:$"

" File statuses
syn match gitStatusModified "\v^\s*modified:\s+\zs.*$"
syn match gitStatusAdded "\v^\s*new file:\s+\zs.*$"
syn match gitStatusDeleted "\v^\s*deleted:\s+\zs.*$"
syn match gitStatusRenamed "\v^\s*renamed:\s+\zs.*$"
syn match gitStatusCopied "\v^\s*copied:\s+\zs.*$"
syn match gitStatusUnmerged "\v^\s*unmerged:\s+\zs.*$"

" Other
syn match gitStatusBranch "On branch \zs\S\+"
syn match gitStatusRemote "'\zs[^']\+'"
syn match gitStatusAdvice "\v^\s*\([^)]+\)$"

" Highlights
hi def link gitStatusHeader Constant
hi def link gitStatusModified Function
hi def link gitStatusDeleted @keyword.return
hi def link gitStatusAdded String
hi def link gitStatusRenamed Special
hi def link gitStatusCopied Special
hi def link gitStatusUnmerged Error
hi def link gitStatusBranch Function
hi def link gitStatusRemote String
hi def link gitStatusAdvice Comment

let b:current_syntax = "git-status"
