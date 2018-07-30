" Vim syntax file
" Language:     Jrnl
" Maintainer:   Gabriele Lana <gabriele.lana@gmail.com>
" Filenames:    *.md

if exists("b:current_syntax")
  finish
endif

if !exists('main_syntax')
  let main_syntax = 'jrnl'
endif

if !exists('g:jrnl_flavor')
  let g:jrnl_flavor = 'github'
endif

if exists('g:jrnl_enable_conceal') && g:jrnl_enable_conceal
    let b:jrnl_concealends = 'concealends'
    let b:jrnl_conceal = 'conceal'
    set conceallevel=2
    set concealcursor=
else
    let b:jrnl_concealends = ''
    let b:jrnl_conceal = ''
endif

syn spell toplevel
syn sync fromstart
syn case ignore


" {{{ INLINE ELEMENTS

syn cluster jrnlInline contains=
  \ jrnlItalic,jrnlBold,jrnlBoldItalic,jrnlStrike,jrnlInlineCode,
  \ jrnlPullRequestLinkInText,jrnlUrlLinkInText,jrnlUserLinkInText,
  \ jrnlEmailLinkInText,jrnlLinkContainer,jrnlXmlComment,
  \ jrnlXmlElement,jrnlXmlEmptyElement,jrnlXmlEntities

execute 'syn region jrnlItalic matchgroup=jrnlInlineDelimiter '
  \ . 'start="\%(\s\|_\|^\)\@<=\*\%(\s\|\*\|$\)\@!" end="\%(\s\|\*\)\@<!\*" '
  \ . 'contains=@jrnlInline '
  \ . b:jrnl_concealends
execute 'syn region jrnlItalic matchgroup=jrnlInlineDelimiter '
  \ . 'start="\%(\s\|\*\|^\)\@<=_\%(\s\|_\|$\)\@!" end="\%(\s\|_\)\@<!_" '
  \ . 'contains=@jrnlInline '
  \ . b:jrnl_concealends

execute 'syn region jrnlBold matchgroup=jrnlInlineDelimiter '
  \ . 'start="\%(\s\|__\|^\)\@<=\*\*\%(\s\|\*\|$\)\@!" end="\%(\s\|\*\*\)\@<!\*\*" '
  \ . 'contains=@jrnlInline '
  \ . b:jrnl_concealends
execute 'syn region jrnlBold matchgroup=jrnlInlineDelimiter '
  \ . 'start="\%(\s\|\*\*\|^\)\@<=__\%(\s\|_\|$\)\@!" end="\%(\s\|__\)\@<!__" '
  \ . 'contains=@jrnlInline '
  \ . b:jrnl_concealends

execute 'syn region jrnlBoldItalic matchgroup=jrnlInlineDelimiter '
  \ . 'start="\%(\s\|_\|^\)\@<=\*\*\*\%(\s\|\*\|$\)\@!" end="\%(\s\|\*\)\@<!\*\*\*" '
  \ . 'contains=@jrnlInline '
  \ . b:jrnl_concealends
execute 'syn region jrnlBoldItalic matchgroup=jrnlInlineDelimiter '
  \ . 'start="\%(\s\|\*\|^\)\@<=___\%(\s\|_\|$\)\@!" end="\%(\s\|_\)\@<!___" '
  \ . 'contains=@jrnlInline '
  \ . b:jrnl_concealends
execute 'syn region jrnlBoldItalic matchgroup=jrnlInlineDelimiter '
  \ . 'start="\%(\s\|_\|^\)\@<=\*\*_\%(\s\|_\|$\)\@!" end="\%(\s\|_\)\@<!_\*\*" '
  \ . 'contains=@jrnlInline '
  \ . b:jrnl_concealends
execute 'syn region jrnlBoldItalic matchgroup=jrnlInlineDelimiter '
  \ . 'start="\%(\s\|\*\|^\)\@<=__\*\%(\s\|\*\|$\)\@!" end="\%(\s\|\*\)\@<!\*__" '
  \ . 'contains=@jrnlInline '
  \ . b:jrnl_concealends

syn match jrnlStrike /\%(\\\)\@<!\~\~\%(\S\)\@=\_.\{-}\%(\S\)\@<=\~\~/ contains=jrnlStrikeDelimiter,@jrnlInline
syn match jrnlStrikeDelimiter /\~\~/ contained

" Fenced code blocks in list items must be preceded by an empty line This is
" made this way so that the second rule could eat up something that is not a
" fenced code block like
"
"     * This is a list item
"       ```ruby
"       # this is not a fenced code block but it's a code block
"       def ruby;
"       ```
execute 'syn region jrnlInlineCode matchgroup=jrnlCodeDelimiter start=/\%(`\)\@<!`/ end=/`/ keepend contains=@NoSpell ' . b:jrnl_concealends
execute 'syn region jrnlInlineCode matchgroup=jrnlCodeDelimiter start=/\%(`\)\@<!`\z(`\+\)/ end=/`\z1/ keepend contains=@NoSpell ' . b:jrnl_concealends

" case insensitive
" preceded by something that is not a word
" could be surrounded by angle brackets
" could begin with / or // (path) or the url protocol
" inside the url pairs of balanced parentheses are allowed
" inside the url html entities are allowed
" the end block is different because ?!:,. are not included in the url if they
" appear at the end of the url
let b:jrnl_syntax_url =
  \ '\c'
  \ . '\%(\W\)\@<='
  \ . '<\?'
  \ . '\%('
  \ .   '\%(\<\%(https\?\|ftp\|file\):\/\/\|www\.\|ftp\.\)'
  \ .   '\|'
  \ .   '\/\/\?'
  \ . '\)'
  \ . '\%('
  \ .   '&#\?[0-9A-Za-z]\{1,8};'
  \ .   '\|'
  \ .   '\\'
  \ .   '\|'
  \ .   '([-A-Z0-9+&@#/%=~_|$?!:,.]*\\\?)'
  \ .   '\|'
  \ .   '\[[-A-Z0-9+&@#/%=~_|$?!:,.]*\\\?\]'
  \ .   '\|'
  \ .   '{[-A-Z0-9+&@#/%=~_|$?!:,.]*\\\?}'
  \ .   '\|'
  \ .   '[-A-Z0-9+&@#/%=~_|$?!:,.]'
  \ . '\)*'
  \ . '\%('
  \ .   '&#\?[0-9A-Za-z]\{1,8};'
  \ .   '\|'
  \ .   '\\'
  \ .   '\|'
  \ .   '([-A-Z0-9+&@#/%=~_|$?!:,.]*\\\?)'
  \ .   '\|'
  \ .   '\[[-A-Z0-9+&@#/%=~_|$?!:,.]*\\\?\]'
  \ .   '\|'
  \ .   '{[-A-Z0-9+&@#/%=~_|$?!:,.]*\\\?}'
  \ .   '\|'
  \ .   '[-A-Z0-9+&@#/%=~_|$]\+'
  \ . '\)'
  \ . '>\?'
execute 'syn match jrnlUrlLinkInText /' . b:jrnl_syntax_url . '/ contains=@NoSpell display'

syn match jrnlPullRequestLinkInText /\%(\w\)\@<!#\d\+/ display
syn match jrnlUserLinkInText /\%(\w\)\@<!@[[:alnum:]._\/-]\+/ contains=@NoSpell display
syn match jrnlEmailLinkInText /[[:alnum:]._%+-]\+@[[:alnum:].-]\+\.\w\{2,4}/ contains=@NoSpell display

" something encosed in square brackets
" could not be preceded by a backslash
" could contain pairs of square brackets
" could contain no more than two consecutive newlines
" could contain single square brackets (open or closed) escaped
" could not contain unbalanced square brackets like 'a [ b \] c'
" could not contain nested square brackets
let b:jrnl_syntax_allowed_characters_in_square_brackets = '\%([^\[\]]\|\\\[\|\\\]\)*'
let b:jrnl_syntax_square_brackets_block = ''
  \ . '\%(\\\)\@<!\['
  \ .   '\%('
  \ .     b:jrnl_syntax_allowed_characters_in_square_brackets
  \ .     '\|'
  \ .     b:jrnl_syntax_allowed_characters_in_square_brackets
  \ .     '\['
  \ .       b:jrnl_syntax_allowed_characters_in_square_brackets
  \ .     '\]'
  \ .     b:jrnl_syntax_allowed_characters_in_square_brackets
  \ .   '\)'
  \ .   '\%('
  \ .     '\n\%(\n\)\@!'
  \ .     '\%('
  \ .       b:jrnl_syntax_allowed_characters_in_square_brackets
  \ .       '\|'
  \ .       b:jrnl_syntax_allowed_characters_in_square_brackets
  \ .       '\['
  \ .         b:jrnl_syntax_allowed_characters_in_square_brackets
  \ .       '\]'
  \ .       b:jrnl_syntax_allowed_characters_in_square_brackets
  \ .     '\)'
  \ .   '\)*'
  \ . '\]'

" something encosed in round brackets
" could not be preceded by a backslash
" could contain pairs of round brackets
" could contain no more than two consecutive newlines
" could contain single round brackets (open or closed) escaped
" could not contain unbalanced round brackets like 'a ( b \) c'
" could not contain nested round brackets
let b:jrnl_syntax_allowed_characters_in_round_brackets = '[^()]*'
let b:jrnl_syntax_round_brackets_block = ''
  \ . '\%(\\\)\@<!('
  \ .   '\%('
  \ .     b:jrnl_syntax_allowed_characters_in_round_brackets
  \ .     '\|'
  \ .     b:jrnl_syntax_allowed_characters_in_round_brackets
  \ .     '('
  \ .       b:jrnl_syntax_allowed_characters_in_round_brackets
  \ .     ')'
  \ .     b:jrnl_syntax_allowed_characters_in_round_brackets
  \ .   '\)'
  \ .   '\%('
  \ .     '\n\%(\n\)\@!'
  \ .     '\%('
  \ .       b:jrnl_syntax_allowed_characters_in_round_brackets
  \ .       '\|'
  \ .       b:jrnl_syntax_allowed_characters_in_round_brackets
  \ .       '('
  \ .         b:jrnl_syntax_allowed_characters_in_round_brackets
  \ .       ')'
  \ .       b:jrnl_syntax_allowed_characters_in_round_brackets
  \ .     '\)'
  \ .   '\)*'
  \ . ')'

execute 'syn match jrnlLinkContainer '
  \ . 'contains=jrnlLinkTextContainer,jrnlLinkUrlContainer transparent '
  \ . '/'
  \ . '!\?'
  \ . b:jrnl_syntax_square_brackets_block
  \ . '\%(\s*\|\n\%\(\n\)\@!\)'
  \ . '\%('
  \ .   b:jrnl_syntax_round_brackets_block
  \ .   '\|'
  \ .   b:jrnl_syntax_square_brackets_block
  \ . '\)'
  \ . '/'

execute 'syn match jrnlLinkTextContainer contained '
  \ . 'contains=jrnlLinkText '
  \ . '/'
  \ . '!\?'
  \ . b:jrnl_syntax_square_brackets_block
  \ . '/'

execute 'syn match jrnlLinkText contained '
  \ . 'contains=@jrnlInline,@NoSpell '
  \ . '/'
  \ . '!\?'
  \ . b:jrnl_syntax_square_brackets_block
  \ . '/'
  \ . 'hs=s+1,he=e-1'

execute 'syn match jrnlLinkUrlContainer contained '
  \ . 'contains=jrnlLinkUrl,jrnlLinkTitleSingleQuoted,jrnlLinkTitleDoubleQuoted '
  \ . '/'
  \ . b:jrnl_syntax_round_brackets_block
  \ . '/ '
  \ . b:jrnl_conceal

execute 'syn match jrnlLinkUrl contained '
  \ . 'contains=@NoSpell '
  \ . '/'
  \ . '\%((\)\@<='
  \ . '\%('
  \ .   '&#\?[0-9A-Za-z]\{1,8};'
  \ .   '\|'
  \ .   '\\'
  \ .   '\|'
  \ .   '([-A-Z0-9+&@#/%=~_|$?!:,.]*\\\?)'
  \ .   '\|'
  \ .   '\[[-A-Z0-9+&@#/%=~_|$?!:,.]*\\\?\]'
  \ .   '\|'
  \ .   '{[-A-Z0-9+&@#/%=~_|$?!:,.]*\\\?}'
  \ .   '\|'
  \ .   '[-A-Z0-9+&@#/%=~_|$?!:,.]'
  \ .   '\|'
  \ .   '\s'
  \ . '\)\+'
  \ . '\%(\s\+["'']\|)\|\n\)\@='
  \ . '/'

execute 'syn region jrnlLinkTitleSingleQuoted start=/\s*''/ skip=/\\''/ end=/''\_s*/ display '
  \ . 'keepend contained contains=@jrnlInline '
  \ . b:jrnl_conceal

execute 'syn region jrnlLinkTitleDoubleQuoted start=/\s*"/ skip=/\\"/ end=/"\_s*/ display '
  \ . 'keepend contained contains=@jrnlInline '
  \ . b:jrnl_conceal

syn match jrnlXmlComment /\c<\!--\_.\{-}-->/ contains=@NoSpell
syn match jrnlXmlElement /\c<\([-A-Z0-9_$?!:,.]\+\)[^>]\{-}>\_.\{-}<\/\1>/ contains=@NoSpell
syn match jrnlXmlEmptyElement /\c<\([-A-Z0-9_$?!:,.]\+\)\%(\s\+[^>]\{-}\/>\|\s*\/>\)/ contains=@NoSpell
syn match jrnlXmlEntities /&#\?[0-9A-Za-z]\{1,8};/ contains=@NoSpell

" }}}


" {{{ ANCHORED BLOCKS

syn match jrnlRule /^\s*\*\s*\*\s*\*[[:space:]*]*$/ display
syn match jrnlRule /^\s*-\s*-\s*-[[:space:]-]*$/ display
syn match jrnlRule /^\s*_\s*_\s*_[[:space:]_]*$/ display

if g:jrnl_flavor ==? 'github'
  syn region jrnlH1 matchgroup=jrnlHeadingDelimiter start=/^#\%(\s\+\)\@=/      end=/#*\s*$/ display oneline contains=@jrnlInline
  syn region jrnlH2 matchgroup=jrnlHeadingDelimiter start=/^##\%(\s\+\)\@=/     end=/#*\s*$/ display oneline contains=@jrnlInline
  syn region jrnlH3 matchgroup=jrnlHeadingDelimiter start=/^###\%(\s\+\)\@=/    end=/#*\s*$/ display oneline contains=@jrnlInline
  syn region jrnlH4 matchgroup=jrnlHeadingDelimiter start=/^####\%(\s\+\)\@=/   end=/#*\s*$/ display oneline contains=@jrnlInline
  syn region jrnlH5 matchgroup=jrnlHeadingDelimiter start=/^#####\%(\s\+\)\@=/  end=/#*\s*$/ display oneline contains=@jrnlInline
  syn region jrnlH6 matchgroup=jrnlHeadingDelimiter start=/^######\%(\s\+\)\@=/ end=/#*\s*$/ display oneline contains=@jrnlInline

  syn match jrnlH1 /^.\+\n=\+$/ display contains=@jrnlInline,jrnlHeadingUnderline
  syn match jrnlH2 /^.\+\n-\+$/ display contains=@jrnlInline,jrnlHeadingUnderline
  syn match jrnlHeadingUnderline /^[=-]\+$/ display contained
endif

if g:jrnl_flavor ==? 'kramdown'
  syn match jrnlHeaderContainer /^#\{1,6}.\+$/ display transparent
    \ contains=@jrnlInline,jrnlHeader,jrnlHeaderId,jrnlHeadingDelimiter
  syn match jrnlHeader /\%(^#\+\)\@<=\%([^#]\+\%(#\+\s*\%($\|{\)\)\@=\|[^{]\{-}\%({\)\@=\|#$\)/

  syn match jrnlHeader /^.\+\n=\+$/ display contains=@jrnlInline,jrnlHeadingUnderline,jrnlHeaderId
  syn match jrnlHeader /^.\+\n-\+$/ display contains=@jrnlInline,jrnlHeadingUnderline,jrnlHeaderId
  syn match jrnlHeadingUnderline /^[=-]\+$/ display contained

  syn match jrnlHeaderId /{[^}]\+}\s*$/ display contained
  syn match jrnlHeadingDelimiter /#\+\%(.\+\)\@=/ display contained
endif

execute 'syn match jrnlLinkReference '
  \ . 'contains=@NoSpell '
  \ . 'display '
  \ . '/'
  \ . '^\s\{,3}'
  \ . b:jrnl_syntax_square_brackets_block
  \ . ':.*'
  \ . '\%(\n\%\(\n\)\@!.*$\)*'
  \ . '/'

syn region jrnlBlockquote start=/^\s*\%(>\s\?\)\+\%(.\)\@=/ end=/\n\n/ contains=jrnlBlockquoteDelimiter,@NoSpell
syn match jrnlBlockquoteDelimiter /^\s*\%(>\s\?\)\+/ contained

syn region jrnlFencedCodeBlock matchgroup=jrnlCodeDelimiter start=/^\s\{,3}```\%(`*\).*$/ end=/^\s\{,3}```\%(`*\)\s*$/ contains=@NoSpell
syn region jrnlFencedCodeBlock matchgroup=jrnlCodeDelimiter start=/^\s\{,3}\~\~\~\%(\~*\).*$/ end=/^\s\{,3}\~\~\~\%(\~*\)\s*$/ contains=@NoSpell

syn match jrnlCodeBlock /\%(^\n\)\@<=\%(\%(\s\{4,}\|\t\+\).*\n\)\+$/ contains=@NoSpell

let s:jrnl_table_header_rows_separator = ''
  \ . '\%('
  \ .   '\s*|\?\%(\s*[-:]-\{1,}[-:]\s*|\)\+\s*[-:]-\{1,}[-:]\s*|\?\s*'
  \ .   '\|'
  \ .   '\s*|\s*[-:]-\{1,}[-:]\s*|\s*'
  \ .   '\|'
  \ .   '\s*|\s*[-:]-\{1,}[-:]\s*'
  \ .   '\|'
  \ .   '\s*[-:]-\{1,}[-:]\s*|\s*'
  \ . '\)'
execute 'syn match jrnlTable '
  \ . 'transparent contains=jrnlTableHeader,jrnlTableDelimiter,@jrnlInline '
  \ . '/'
  \ .   '^\s*\n'
  \ .   '\s*|\?\%([^|]\+|\)*[^|]\+|\?\s*\n'
  \ .   s:jrnl_table_header_rows_separator . '\n'
  \ .   '\%('
  \ .     '\s*|\?\%([^|]\+|\)*[^|]\+|\?\s*\n'
  \ .   '\)*'
  \ .   '$'
  \ . '/'
syn match jrnlTableDelimiter /|/ contained
execute 'syn match jrnlTableDelimiter contained '
  \ . '/' . s:jrnl_table_header_rows_separator . '/'
execute 'syn match jrnlTableHeader contained contains=@jrnlInline '
  \ . '/\%(|\?\s*\)\@<=[^|]\+\%(.*\n' . s:jrnl_table_header_rows_separator . '\)\@=/'

" }}}


" {{{ NESTED BLOCKS

for s:level in range(1, 16)
  let s:indented_as_content = '\%( \{' . (2*s:level) . '}\|\t\{' . (s:level) . '}\)'
  let s:indented_as_container = '\%( \{' . (2*(s:level-1)) . '}\|\t\{' . (s:level-1) . '}\)'
  let s:preceded_by_separator = '^\s*\n'

  execute 'syn region jrnlListItemAtLevel' . (s:level) . ' '
    \ . 'matchgroup=jrnlItemDelimiter '
    \ . (s:level > 1 ? 'contained ' : '')
    \ . 'keepend '
    \ . 'contains='
    \ .   'jrnlTableInListItemAtLevel' . (s:level) . ','
    \ .   'jrnlCodeBlockInListItemAtLevel' . (s:level) . ','
    \ .   'jrnlFencedCodeBlockInListItemAtLevel' . (s:level) . ','
    \ .   'jrnlH1InListItemAtLevel' . (s:level) . ','
    \ .   'jrnlH2InListItemAtLevel' . (s:level) . ','
    \ .   'jrnlH3InListItemAtLevel' . (s:level) . ','
    \ .   'jrnlH4InListItemAtLevel' . (s:level) . ','
    \ .   'jrnlH5InListItemAtLevel' . (s:level) . ','
    \ .   'jrnlH6InListItemAtLevel' . (s:level) . ','
    \ .   'jrnlRuleInListItemAtLevel' . (s:level) . ','
    \ .   'jrnlBlockquoteInListItemAtLevel' . (s:level) . ','
    \ .   'jrnlListItemAtLevel' . (s:level+1) . ','
    \ .   '@jrnlInline '
    \ . 'start=/^' . (s:indented_as_container) . '\%([-*+]\|\d\+\.\)\%(\s\+\[[ x]\]\)\?\s\+/ '
    \ . 'end='
    \ .   '/'
    \ .     '\n\%(\n\n\)\@='
    \ .     '\|'
    \ .     '\n\%(' . (s:indented_as_container) . '\%([-*+]\|\d\+\.\)\s\+\)\@='
    \ .     '\|'
    \ .     '\n\%(\n' . (s:indented_as_container) . '\S\)\@='
    \ .   '/'

  " fenced code blocks could have leading spaces after the base level indentation
  " so at least it must be indented as content but could be indented more
  " there's no upper limit to the indentation because the following rule on
  " code blocks is going to take care of that
  " TL;DR: don't swap jrnlFencedCodeBlockInListItemAtLevel* with
  " jrnlCodeBlockInListItemAtLevel* :-)
  execute 'syn region jrnlFencedCodeBlockInListItemAtLevel' . (s:level) . ' '
    \ . 'contained contains=@NoSpell '
    \ . 'matchgroup=jrnlFencedCodeBlockInItemDelimiter '
    \ . 'start='
    \ .   '/'
    \ .     (s:preceded_by_separator)
    \ .     '\z( \{' . (2*s:level) . ',}\|\t\{' . (s:level) . ',}\)*```\%(`*\).*$'
    \ .   '/ '
    \ . 'end=/^\z1```\%(`*\)\s*$/'
  execute 'syn region jrnlFencedCodeBlockInListItemAtLevel' . (s:level) . ' '
    \ . 'contained contains=@NoSpell '
    \ . 'matchgroup=jrnlFencedCodeBlockInItemDelimiter '
    \ . 'start='
    \ .   '/'
    \ .     (s:preceded_by_separator)
    \ .     '\z( \{' . (2*s:level) . ',}\|\t\{' . (s:level) . ',}\)*\~\~\~\%(\~*\).*$'
    \ .   '/ '
    \ . 'end=/^\z1\~\~\~\%(\~*\)\s*$/'
  execute 'hi def link jrnlFencedCodeBlockInListItemAtLevel' . (s:level) . ' String'

  execute 'syn match jrnlCodeBlockInListItemAtLevel' . (s:level) . ' '
    \ . 'contained contains=@NoSpell '
    \ . '/' . (s:preceded_by_separator) . '\%(\%( \{' . (6+2*s:level)  . ',}\|\t\{' . (1+s:level) . ',}\).*\n\?\)\+$/'
  execute 'hi def link jrnlCodeBlockInListItemAtLevel' . (s:level) . ' String'

  execute 'syn region jrnlH1InListItemAtLevel' . (s:level) . ' '
    \ . 'contained display oneline '
    \ . 'matchgroup=jrnlHeadingDelimiter '
    \ . 'contains=@jrnlInline '
    \ . 'start=/' . (s:preceded_by_separator) . (s:indented_as_content) . '#\%(\s\+\)\@=/ '
    \ . 'end=/#*\s*$/'
  execute 'syn region jrnlH2InListItemAtLevel' . (s:level) . ' '
    \ . 'contained display oneline '
    \ . 'matchgroup=jrnlHeadingDelimiter '
    \ . 'contains=@jrnlInline '
    \ . 'start=/' . (s:preceded_by_separator) . (s:indented_as_content) . '##\%(\s\+\)\@=/ '
    \ . 'end=/#*\s*$/'
  execute 'syn region jrnlH3InListItemAtLevel' . (s:level) . ' '
    \ . 'contained display oneline '
    \ . 'matchgroup=jrnlHeadingDelimiter '
    \ . 'contains=@jrnlInline '
    \ . 'start=/' . (s:preceded_by_separator) . (s:indented_as_content) . '###\%(\s\+\)\@=/ '
    \ . 'end=/#*\s*$/'
  execute 'syn region jrnlH4InListItemAtLevel' . (s:level) . ' '
    \ . 'contained display oneline '
    \ . 'matchgroup=jrnlHeadingDelimiter '
    \ . 'contains=@jrnlInline '
    \ . 'start=/' . (s:preceded_by_separator) . (s:indented_as_content) . '####\%(\s\+\)\@=/ '
    \ . 'end=/#*\s*$/'
  execute 'syn region jrnlH5InListItemAtLevel' . (s:level) . ' '
    \ . 'contained display oneline '
    \ . 'matchgroup=jrnlHeadingDelimiter '
    \ . 'contains=@jrnlInline '
    \ . 'start=/' . (s:preceded_by_separator) . (s:indented_as_content) . '#####\%(\s\+\)\@=/ '
    \ . 'end=/#*\s*$/'
  execute 'syn region jrnlH6InListItemAtLevel' . (s:level) . ' '
    \ . 'contained display oneline '
    \ . 'matchgroup=jrnlHeadingDelimiter '
    \ . 'contains=@jrnlInline '
    \ . 'start=/' . (s:preceded_by_separator) . (s:indented_as_content) . '######\%(\s\+\)\@=/ '
    \ . 'end=/#*\s*$/'
  execute 'hi def link jrnlH1InListItemAtLevel' . (s:level) . ' Title'
  execute 'hi def link jrnlH2InListItemAtLevel' . (s:level) . ' Title'
  execute 'hi def link jrnlH3InListItemAtLevel' . (s:level) . ' Title'
  execute 'hi def link jrnlH4InListItemAtLevel' . (s:level) . ' Title'
  execute 'hi def link jrnlH5InListItemAtLevel' . (s:level) . ' Title'
  execute 'hi def link jrnlH6InListItemAtLevel' . (s:level) . ' Title'

  execute 'syn match jrnlH1InListItemAtLevel' . (s:level) . ' '
    \ . 'display contained contains=@jrnlInline,jrnlHeadingDelimiterInListItemAtLevel'. (s:level) . ' '
    \ . '/' . (s:preceded_by_separator) . (s:indented_as_content) . '.\+\n' . (s:indented_as_content) . '=\+$/'
  execute 'syn match jrnlH1InListItemAtLevel' . (s:level) . ' '
    \ . 'display contained contains=@jrnlInline,jrnlHeadingDelimiterInListItemAtLevel'. (s:level) . ' '
    \ . '/' . (s:preceded_by_separator) . (s:indented_as_content) . '.\+\n' . (s:indented_as_content) . '-\+$/'
  execute 'syn match jrnlHeadingDelimiterInListItemAtLevel' . (s:level) . ' '
    \ . 'display contained '
    \ . '/^' . (s:indented_as_content) . '\%(-\+\|=\+\)$/'
  execute 'hi def link jrnlH1InListItemAtLevel' . (s:level) . ' Title'
  execute 'hi def link jrnlH2InListItemAtLevel' . (s:level) . ' Title'
  execute 'hi def link jrnlHeadingDelimiterInListItemAtLevel' . (s:level) . ' Special'

  execute 'syn match jrnlRuleInListItemAtLevel' . (s:level) . ' '
    \ . '/' . (s:preceded_by_separator) . (s:indented_as_content) . '*\*\s*\*\s*\*[[:space:]*]*$/ display'
  execute 'syn match jrnlRuleInListItemAtLevel' . (s:level) . ' '
    \ . '/' . (s:preceded_by_separator) . (s:indented_as_content) . '-\s*-\s*-[[:space:]-]*$/ display'
  execute 'syn match jrnlRuleInListItemAtLevel' . (s:level) . ' '
    \ . '/' . (s:preceded_by_separator) . (s:indented_as_content) . '_\s*_\s*_[[:space:]_]*$/ display'
  execute 'hi def link jrnlRuleInListItemAtLevel' . (s:level) . ' Identifier'

  execute 'syn region jrnlBlockquoteInListItemAtLevel' . (s:level) . ' '
    \ . 'contained '
    \ . 'contains=jrnlBlockquoteDelimiterInListItemAtLevel' . (s:level) . ',@NoSpell '
    \ . 'start=/' . (s:preceded_by_separator) . (s:indented_as_content) . '\%(>\s\?\)\+\%(.\)\@=/ '
    \ . 'end=/\n\n/'
  execute 'syn match jrnlBlockquoteDelimiterInListItemAtLevel' . (s:level) . ' '
    \ . 'contained '
    \ . '/^' . (s:indented_as_content) . '\%(>\s\?\)\+/'
  execute 'hi def link jrnlBlockquoteInListItemAtLevel' . (s:level) . ' Comment'
  execute 'hi def link jrnlBlockquoteDelimiterInListItemAtLevel' . (s:level) . ' Delimiter'

  " " the only constraint here is that the table begins at least at the same
  " " level as the list item's content, se we could reuse the previous syntactic
  " " elements, we could do that because tables could have arbitrary indentation
  execute 'syn match jrnlTableInListItemAtLevel' . (s:level) . ' '
    \ . 'transparent contained contains=jrnlTableHeader,jrnlTableDelimiter,@jrnlInline '
    \ . '/'
    \ .   '^\s*\n'
    \ .   (s:indented_as_content) . '\s*|\?\%([^|]\+|\)*[^|]\+|\?\s*\n'
    \ .   s:jrnl_table_header_rows_separator . '\n'
    \ .   '\%('
    \ .     '\s*|\?\%([^|]\+|\)*[^|]\+|\?\s*\n'
    \ .   '\)*'
    \ .   '$'
    \ . '/'
endfor
hi def link jrnlItemDelimiter Special
hi def link jrnlFencedCodeBlockInItemDelimiter Special

" }}}


" {{{ EMOTICONS

syn keyword jrnlEmoticonKeyword :bowtie: :smile: :laughing: :blush: :smiley:
syn keyword jrnlEmoticonKeyword :bowtie: :smile: :laughing: :blush: :smiley:
syn keyword jrnlEmoticonKeyword :relaxed: :smirk: :heart_eyes: :kissing_heart: :kissing_closed_eyes:
syn keyword jrnlEmoticonKeyword :flushed: :relieved: :satisfied: :grin: :wink:
syn keyword jrnlEmoticonKeyword :stuck_out_tongue_winking_eye: :stuck_out_tongue_closed_eyes: :grinning: :kissing: :kissing_smiling_eyes:
syn keyword jrnlEmoticonKeyword :stuck_out_tongue: :sleeping: :worried: :frowning: :anguished:
syn keyword jrnlEmoticonKeyword :open_mouth: :grimacing: :confused: :hushed: :expressionless:
syn keyword jrnlEmoticonKeyword :unamused: :sweat_smile: :sweat: :disappointed_relieved: :weary:
syn keyword jrnlEmoticonKeyword :pensive: :disappointed: :confounded: :fearful: :cold_sweat:
syn keyword jrnlEmoticonKeyword :persevere: :cry: :sob: :joy: :astonished:
syn keyword jrnlEmoticonKeyword :scream: :neckbeard: :tired_face: :angry: :rage:
syn keyword jrnlEmoticonKeyword :triumph: :sleepy: :yum: :mask: :sunglasses:
syn keyword jrnlEmoticonKeyword :dizzy_face: :imp: :smiling_imp: :neutral_face: :no_mouth:
syn keyword jrnlEmoticonKeyword :innocent: :alien: :yellow_heart: :blue_heart: :purple_heart:
syn keyword jrnlEmoticonKeyword :heart: :green_heart: :broken_heart: :heartbeat: :heartpulse:
syn keyword jrnlEmoticonKeyword :two_hearts: :revolving_hearts: :cupid: :sparkling_heart: :sparkles:
syn keyword jrnlEmoticonKeyword :star: :star2: :dizzy: :boom: :collision:
syn keyword jrnlEmoticonKeyword :anger: :exclamation: :question: :grey_exclamation: :grey_question:
syn keyword jrnlEmoticonKeyword :zzz: :dash: :sweat_drops: :notes: :musical_note:
syn keyword jrnlEmoticonKeyword :fire: :hankey: :poop: :shit: :+1:
syn keyword jrnlEmoticonKeyword :thumbsup: :-1: :thumbsdown: :ok_hand: :punch:
syn keyword jrnlEmoticonKeyword :facepunch: :fist: :v: :wave: :hand:
syn keyword jrnlEmoticonKeyword :raised_hand: :open_hands: :point_up: :point_down: :point_left:
syn keyword jrnlEmoticonKeyword :point_right: :raised_hands: :pray: :point_up_2: :clap:
syn keyword jrnlEmoticonKeyword :muscle: :metal: :fu: :walking: :runner:
syn keyword jrnlEmoticonKeyword :running: :couple: :family: :two_men_holding_hands: :two_women_holding_hands:
syn keyword jrnlEmoticonKeyword :dancer: :dancers: :ok_woman: :no_good: :information_desk_person:
syn keyword jrnlEmoticonKeyword :raising_hand: :bride_with_veil: :person_with_pouting_face: :person_frowning: :bow:
syn keyword jrnlEmoticonKeyword :couplekiss: :couple_with_heart: :massage: :haircut: :nail_care:
syn keyword jrnlEmoticonKeyword :boy: :girl: :woman: :man: :baby:
syn keyword jrnlEmoticonKeyword :older_woman: :older_man: :person_with_blond_hair: :man_with_gua_pi_mao: :man_with_turban:
syn keyword jrnlEmoticonKeyword :construction_worker: :cop: :angel: :princess: :smiley_cat:
syn keyword jrnlEmoticonKeyword :smile_cat: :heart_eyes_cat: :kissing_cat: :smirk_cat: :scream_cat:
syn keyword jrnlEmoticonKeyword :crying_cat_face: :joy_cat: :pouting_cat: :japanese_ogre: :japanese_goblin:
syn keyword jrnlEmoticonKeyword :see_no_evil: :hear_no_evil: :speak_no_evil: :guardsman: :skull:
syn keyword jrnlEmoticonKeyword :feet: :lips: :kiss: :droplet: :ear:
syn keyword jrnlEmoticonKeyword :eyes: :nose: :tongue: :love_letter: :bust_in_silhouette:
syn keyword jrnlEmoticonKeyword :busts_in_silhouette: :speech_balloon: :thought_balloon: :feelsgood: :finnadie:
syn keyword jrnlEmoticonKeyword :goberserk: :godmode: :hurtrealbad: :rage1: :rage2:
syn keyword jrnlEmoticonKeyword :rage3: :rage4: :suspect: :trollface: :sunny:
syn keyword jrnlEmoticonKeyword :umbrella: :cloud: :snowflake: :snowman: :zap:
syn keyword jrnlEmoticonKeyword :cyclone: :foggy: :ocean: :cat: :dog:
syn keyword jrnlEmoticonKeyword :mouse: :hamster: :rabbit: :wolf: :frog:
syn keyword jrnlEmoticonKeyword :tiger: :koala: :bear: :pig: :pig_nose:
syn keyword jrnlEmoticonKeyword :cow: :boar: :monkey_face: :monkey: :horse:
syn keyword jrnlEmoticonKeyword :racehorse: :camel: :sheep: :elephant: :panda_face:
syn keyword jrnlEmoticonKeyword :snake: :bird: :baby_chick: :hatched_chick: :hatching_chick:
syn keyword jrnlEmoticonKeyword :chicken: :penguin: :turtle: :bug: :honeybee:
syn keyword jrnlEmoticonKeyword :ant: :beetle: :snail: :octopus: :tropical_fish:
syn keyword jrnlEmoticonKeyword :fish: :whale: :whale2: :dolphin: :cow2:
syn keyword jrnlEmoticonKeyword :ram: :rat: :water_buffalo: :tiger2: :rabbit2:
syn keyword jrnlEmoticonKeyword :dragon: :goat: :rooster: :dog2: :pig2:
syn keyword jrnlEmoticonKeyword :mouse2: :ox: :dragon_face: :blowfish: :crocodile:
syn keyword jrnlEmoticonKeyword :dromedary_camel: :leopard: :cat2: :poodle: :paw_prints:
syn keyword jrnlEmoticonKeyword :bouquet: :cherry_blossom: :tulip: :four_leaf_clover: :rose:
syn keyword jrnlEmoticonKeyword :sunflower: :hibiscus: :maple_leaf: :leaves: :fallen_leaf:
syn keyword jrnlEmoticonKeyword :herb: :mushroom: :cactus: :palm_tree: :evergreen_tree:
syn keyword jrnlEmoticonKeyword :deciduous_tree: :chestnut: :seedling: :blossom: :ear_of_rice:
syn keyword jrnlEmoticonKeyword :shell: :globe_with_meridians: :sun_with_face: :full_moon_with_face: :new_moon_with_face:
syn keyword jrnlEmoticonKeyword :new_moon: :waxing_crescent_moon: :first_quarter_moon: :waxing_gibbous_moon: :full_moon:
syn keyword jrnlEmoticonKeyword :waning_gibbous_moon: :last_quarter_moon: :waning_crescent_moon: :last_quarter_moon_with_face: :first_quarter_moon_with_face:
syn keyword jrnlEmoticonKeyword :moon: :earth_africa: :earth_americas: :earth_asia: :volcano:
syn keyword jrnlEmoticonKeyword :milky_way: :partly_sunny: :octocat: :squirrel: :bamboo:
syn keyword jrnlEmoticonKeyword :gift_heart: :dolls: :school_satchel: :mortar_board: :flags:
syn keyword jrnlEmoticonKeyword :fireworks: :sparkler: :wind_chime: :rice_scene: :jack_o_lantern:
syn keyword jrnlEmoticonKeyword :ghost: :santa: :christmas_tree: :gift: :bell:
syn keyword jrnlEmoticonKeyword :no_bell: :tanabata_tree: :tada: :confetti_ball: :balloon:
syn keyword jrnlEmoticonKeyword :crystal_ball: :cd: :dvd: :floppy_disk: :camera:
syn keyword jrnlEmoticonKeyword :video_camera: :movie_camera: :computer: :tv: :iphone:
syn keyword jrnlEmoticonKeyword :phone: :telephone: :telephone_receiver: :pager: :fax:
syn keyword jrnlEmoticonKeyword :minidisc: :vhs: :sound: :speaker: :mute:
syn keyword jrnlEmoticonKeyword :loudspeaker: :mega: :hourglass: :hourglass_flowing_sand: :alarm_clock:
syn keyword jrnlEmoticonKeyword :watch: :radio: :satellite: :loop: :mag:
syn keyword jrnlEmoticonKeyword :mag_right: :unlock: :lock: :lock_with_ink_pen: :closed_lock_with_key:
syn keyword jrnlEmoticonKeyword :key: :bulb: :flashlight: :high_brightness: :low_brightness:
syn keyword jrnlEmoticonKeyword :electric_plug: :battery: :calling: :email: :mailbox:
syn keyword jrnlEmoticonKeyword :postbox: :bath: :bathtub: :shower: :toilet:
syn keyword jrnlEmoticonKeyword :wrench: :nut_and_bolt: :hammer: :seat: :moneybag:
syn keyword jrnlEmoticonKeyword :yen: :dollar: :pound: :euro: :credit_card:
syn keyword jrnlEmoticonKeyword :money_with_wings: :e-mail: :inbox_tray: :outbox_tray: :envelope:
syn keyword jrnlEmoticonKeyword :incoming_envelope: :postal_horn: :mailbox_closed: :mailbox_with_mail: :mailbox_with_no_mail:
syn keyword jrnlEmoticonKeyword :door: :smoking: :bomb: :gun: :hocho:
syn keyword jrnlEmoticonKeyword :pill: :syringe: :page_facing_up: :page_with_curl: :bookmark_tabs:
syn keyword jrnlEmoticonKeyword :bar_chart: :chart_with_upwards_trend: :chart_with_downwards_trend: :scroll: :clipboard:
syn keyword jrnlEmoticonKeyword :calendar: :date: :card_index: :file_folder: :open_file_folder:
syn keyword jrnlEmoticonKeyword :scissors: :pushpin: :paperclip: :black_nib: :pencil2:
syn keyword jrnlEmoticonKeyword :straight_ruler: :triangular_ruler: :closed_book: :green_book: :blue_book:
syn keyword jrnlEmoticonKeyword :orange_book: :notebook: :notebook_with_decorative_cover: :ledger: :books:
syn keyword jrnlEmoticonKeyword :bookmark: :name_badge: :microscope: :telescope: :newspaper:
syn keyword jrnlEmoticonKeyword :football: :basketball: :soccer: :baseball: :tennis:
syn keyword jrnlEmoticonKeyword :8ball: :rugby_football: :bowling: :golf: :mountain_bicyclist:
syn keyword jrnlEmoticonKeyword :bicyclist: :horse_racing: :snowboarder: :swimmer: :surfer:
syn keyword jrnlEmoticonKeyword :ski: :spades: :hearts: :clubs: :diamonds:
syn keyword jrnlEmoticonKeyword :gem: :ring: :trophy: :musical_score: :musical_keyboard:
syn keyword jrnlEmoticonKeyword :violin: :space_invader: :video_game: :black_joker: :flower_playing_cards:
syn keyword jrnlEmoticonKeyword :game_die: :dart: :mahjong: :clapper: :memo:
syn keyword jrnlEmoticonKeyword :pencil: :book: :art: :microphone: :headphones:
syn keyword jrnlEmoticonKeyword :trumpet: :saxophone: :guitar: :shoe: :sandal:
syn keyword jrnlEmoticonKeyword :high_heel: :lipstick: :boot: :shirt: :tshirt:
syn keyword jrnlEmoticonKeyword :necktie: :womans_clothes: :dress: :running_shirt_with_sash: :jeans:
syn keyword jrnlEmoticonKeyword :kimono: :bikini: :ribbon: :tophat: :crown:
syn keyword jrnlEmoticonKeyword :womans_hat: :mans_shoe: :closed_umbrella: :briefcase: :handbag:
syn keyword jrnlEmoticonKeyword :pouch: :purse: :eyeglasses: :fishing_pole_and_fish: :coffee:
syn keyword jrnlEmoticonKeyword :tea: :sake: :baby_bottle: :beer: :beers:
syn keyword jrnlEmoticonKeyword :cocktail: :tropical_drink: :wine_glass: :fork_and_knife: :pizza:
syn keyword jrnlEmoticonKeyword :hamburger: :fries: :poultry_leg: :meat_on_bone: :spaghetti:
syn keyword jrnlEmoticonKeyword :curry: :fried_shrimp: :bento: :sushi: :fish_cake:
syn keyword jrnlEmoticonKeyword :rice_ball: :rice_cracker: :rice: :ramen: :stew:
syn keyword jrnlEmoticonKeyword :oden: :dango: :egg: :bread: :doughnut:
syn keyword jrnlEmoticonKeyword :custard: :icecream: :ice_cream: :shaved_ice: :birthday:
syn keyword jrnlEmoticonKeyword :cake: :cookie: :chocolate_bar: :candy: :lollipop:
syn keyword jrnlEmoticonKeyword :honey_pot: :apple: :green_apple: :tangerine: :lemon:
syn keyword jrnlEmoticonKeyword :cherries: :grapes: :watermelon: :strawberry: :peach:
syn keyword jrnlEmoticonKeyword :melon: :banana: :pear: :pineapple: :sweet_potato:
syn keyword jrnlEmoticonKeyword :eggplant: :tomato: :corn: :house: :house_with_garden:
syn keyword jrnlEmoticonKeyword :school: :office: :post_office: :hospital: :bank:
syn keyword jrnlEmoticonKeyword :convenience_store: :love_hotel: :hotel: :wedding: :church:
syn keyword jrnlEmoticonKeyword :department_store: :european_post_office: :city_sunrise: :city_sunset: :japanese_castle:
syn keyword jrnlEmoticonKeyword :european_castle: :tent: :factory: :tokyo_tower: :japan:
syn keyword jrnlEmoticonKeyword :mount_fuji: :sunrise_over_mountains: :sunrise: :stars: :statue_of_liberty:
syn keyword jrnlEmoticonKeyword :bridge_at_night: :carousel_horse: :rainbow: :ferris_wheel: :fountain:
syn keyword jrnlEmoticonKeyword :roller_coaster: :ship: :speedboat: :boat: :sailboat:
syn keyword jrnlEmoticonKeyword :rowboat: :anchor: :rocket: :airplane: :helicopter:
syn keyword jrnlEmoticonKeyword :steam_locomotive: :tram: :mountain_railway: :bike: :aerial_tramway:
syn keyword jrnlEmoticonKeyword :suspension_railway: :mountain_cableway: :tractor: :blue_car: :oncoming_automobile:
syn keyword jrnlEmoticonKeyword :car: :red_car: :taxi: :oncoming_taxi: :articulated_lorry:
syn keyword jrnlEmoticonKeyword :bus: :oncoming_bus: :rotating_light: :police_car: :oncoming_police_car:
syn keyword jrnlEmoticonKeyword :fire_engine: :ambulance: :minibus: :truck: :train:
syn keyword jrnlEmoticonKeyword :station: :train2: :bullettrain_front: :bullettrain_side: :light_rail:
syn keyword jrnlEmoticonKeyword :monorail: :railway_car: :trolleybus: :ticket: :fuelpump:
syn keyword jrnlEmoticonKeyword :vertical_traffic_light: :traffic_light: :warning: :construction: :beginner:
syn keyword jrnlEmoticonKeyword :atm: :slot_machine: :busstop: :barber: :hotsprings:
syn keyword jrnlEmoticonKeyword :checkered_flag: :crossed_flags: :izakaya_lantern: :moyai: :circus_tent:
syn keyword jrnlEmoticonKeyword :performing_arts: :round_pushpin: :triangular_flag_on_post: :jp: :kr:
syn keyword jrnlEmoticonKeyword :cn: :us: :fr: :es: :it:
syn keyword jrnlEmoticonKeyword :ru: :gb: :uk: :de: :one:
syn keyword jrnlEmoticonKeyword :two: :three: :four: :five: :six:
syn keyword jrnlEmoticonKeyword :seven: :eight: :nine: :keycap_ten: :1234:
syn keyword jrnlEmoticonKeyword :zero: :hash: :symbols: :arrow_backward: :arrow_down:
syn keyword jrnlEmoticonKeyword :arrow_forward: :arrow_left: :capital_abcd: :abcd: :abc:
syn keyword jrnlEmoticonKeyword :arrow_lower_left: :arrow_lower_right: :arrow_right: :arrow_up: :arrow_upper_left:
syn keyword jrnlEmoticonKeyword :arrow_upper_right: :arrow_double_down: :arrow_double_up: :arrow_down_small: :arrow_heading_down:
syn keyword jrnlEmoticonKeyword :arrow_heading_up: :leftwards_arrow_with_hook: :arrow_right_hook: :left_right_arrow: :arrow_up_down:
syn keyword jrnlEmoticonKeyword :arrow_up_small: :arrows_clockwise: :arrows_counterclockwise: :rewind: :fast_forward:
syn keyword jrnlEmoticonKeyword :information_source: :ok: :twisted_rightwards_arrows: :repeat: :repeat_one:
syn keyword jrnlEmoticonKeyword :new: :top: :up: :cool: :free:
syn keyword jrnlEmoticonKeyword :ng: :cinema: :koko: :signal_strength: :u5272:
syn keyword jrnlEmoticonKeyword :u5408: :u55b6: :u6307: :u6708: :u6709:
syn keyword jrnlEmoticonKeyword :u6e80: :u7121: :u7533: :u7a7a: :u7981:
syn keyword jrnlEmoticonKeyword :sa: :restroom: :mens: :womens: :baby_symbol:
syn keyword jrnlEmoticonKeyword :no_smoking: :parking: :wheelchair: :metro: :baggage_claim:
syn keyword jrnlEmoticonKeyword :accept: :wc: :potable_water: :put_litter_in_its_place: :secret:
syn keyword jrnlEmoticonKeyword :congratulations: :m: :passport_control: :left_luggage: :customs:
syn keyword jrnlEmoticonKeyword :ideograph_advantage: :cl: :sos: :id: :no_entry_sign:
syn keyword jrnlEmoticonKeyword :underage: :no_mobile_phones: :do_not_litter: :non-potable_water: :no_bicycles:
syn keyword jrnlEmoticonKeyword :no_pedestrians: :children_crossing: :no_entry: :eight_spoked_asterisk: :eight_pointed_black_star:
syn keyword jrnlEmoticonKeyword :heart_decoration: :vs: :vibration_mode: :mobile_phone_off: :chart:
syn keyword jrnlEmoticonKeyword :currency_exchange: :aries: :taurus: :gemini: :cancer:
syn keyword jrnlEmoticonKeyword :leo: :virgo: :libra: :scorpius: :sagittarius:
syn keyword jrnlEmoticonKeyword :capricorn: :aquarius: :pisces: :ophiuchus: :six_pointed_star:
syn keyword jrnlEmoticonKeyword :negative_squared_cross_mark: :a: :b: :ab: :o2:
syn keyword jrnlEmoticonKeyword :diamond_shape_with_a_dot_inside: :recycle: :end: :on: :soon:
syn keyword jrnlEmoticonKeyword :clock1: :clock130: :clock10: :clock1030: :clock11:
syn keyword jrnlEmoticonKeyword :clock1130: :clock12: :clock1230: :clock2: :clock230:
syn keyword jrnlEmoticonKeyword :clock3: :clock330: :clock4: :clock430: :clock5:
syn keyword jrnlEmoticonKeyword :clock530: :clock6: :clock630: :clock7: :clock730:
syn keyword jrnlEmoticonKeyword :clock8: :clock830: :clock9: :clock930: :heavy_dollar_sign:
syn keyword jrnlEmoticonKeyword :copyright: :registered: :tm: :x: :heavy_exclamation_mark:
syn keyword jrnlEmoticonKeyword :bangbang: :interrobang: :o: :heavy_multiplication_x: :heavy_plus_sign:
syn keyword jrnlEmoticonKeyword :heavy_minus_sign: :heavy_division_sign: :white_flower: :100: :heavy_check_mark:
syn keyword jrnlEmoticonKeyword :ballot_box_with_check: :radio_button: :link: :curly_loop: :wavy_dash:
syn keyword jrnlEmoticonKeyword :part_alternation_mark: :trident: :black_square: :white_square: :white_check_mark:
syn keyword jrnlEmoticonKeyword :black_square_button: :white_square_button: :black_circle: :white_circle: :red_circle:
syn keyword jrnlEmoticonKeyword :large_blue_circle: :large_blue_diamond: :large_orange_diamond: :small_blue_diamond: :small_orange_diamond:
syn keyword jrnlEmoticonKeyword :small_red_triangle: :small_red_triangle_down: :shipit: :relaxed: :smirk:
syn keyword jrnlEmoticonKeyword :heart_eyes: :kissing_heart: :kissing_closed_eyes: :flushed: :relieved:
syn keyword jrnlEmoticonKeyword :satisfied: :grin: :wink: :stuck_out_tongue_winking_eye: :stuck_out_tongue_closed_eyes:
syn keyword jrnlEmoticonKeyword :grinning: :kissing: :kissing_smiling_eyes: :stuck_out_tongue: :sleeping:
syn keyword jrnlEmoticonKeyword :worried: :frowning: :anguished: :open_mouth: :grimacing:
syn keyword jrnlEmoticonKeyword :confused: :hushed: :expressionless: :unamused: :sweat_smile:
syn keyword jrnlEmoticonKeyword :sweat: :disappointed_relieved: :weary: :pensive: :disappointed:
syn keyword jrnlEmoticonKeyword :confounded: :fearful: :cold_sweat: :persevere: :cry:
syn keyword jrnlEmoticonKeyword :sob: :joy: :astonished: :scream: :neckbeard:
syn keyword jrnlEmoticonKeyword :tired_face: :angry: :rage: :triumph: :sleepy:
syn keyword jrnlEmoticonKeyword :yum: :mask: :sunglasses: :dizzy_face: :imp:
syn keyword jrnlEmoticonKeyword :smiling_imp: :neutral_face: :no_mouth: :innocent: :alien:
syn keyword jrnlEmoticonKeyword :yellow_heart: :blue_heart: :purple_heart: :heart: :green_heart:
syn keyword jrnlEmoticonKeyword :broken_heart: :heartbeat: :heartpulse: :two_hearts: :revolving_hearts:
syn keyword jrnlEmoticonKeyword :cupid: :sparkling_heart: :sparkles: :star: :star2:
syn keyword jrnlEmoticonKeyword :dizzy: :boom: :collision: :anger: :exclamation:
syn keyword jrnlEmoticonKeyword :question: :grey_exclamation: :grey_question: :zzz: :dash:
syn keyword jrnlEmoticonKeyword :sweat_drops: :notes: :musical_note: :fire: :hankey:
syn keyword jrnlEmoticonKeyword :poop: :shit: :+1: :thumbsup: :-1:
syn keyword jrnlEmoticonKeyword :thumbsdown: :ok_hand: :punch: :facepunch: :fist:
syn keyword jrnlEmoticonKeyword :v: :wave: :hand: :raised_hand: :open_hands:
syn keyword jrnlEmoticonKeyword :point_up: :point_down: :point_left: :point_right: :raised_hands:
syn keyword jrnlEmoticonKeyword :pray: :point_up_2: :clap: :muscle: :metal:
syn keyword jrnlEmoticonKeyword :fu: :walking: :runner: :running: :couple:
syn keyword jrnlEmoticonKeyword :family: :two_men_holding_hands: :two_women_holding_hands: :dancer: :dancers:
syn keyword jrnlEmoticonKeyword :ok_woman: :no_good: :information_desk_person: :raising_hand: :bride_with_veil:
syn keyword jrnlEmoticonKeyword :person_with_pouting_face: :person_frowning: :bow: :couplekiss: :couple_with_heart:
syn keyword jrnlEmoticonKeyword :massage: :haircut: :nail_care: :boy: :girl:
syn keyword jrnlEmoticonKeyword :woman: :man: :baby: :older_woman: :older_man:
syn keyword jrnlEmoticonKeyword :person_with_blond_hair: :man_with_gua_pi_mao: :man_with_turban: :construction_worker: :cop:
syn keyword jrnlEmoticonKeyword :angel: :princess: :smiley_cat: :smile_cat: :heart_eyes_cat:
syn keyword jrnlEmoticonKeyword :kissing_cat: :smirk_cat: :scream_cat: :crying_cat_face: :joy_cat:
syn keyword jrnlEmoticonKeyword :pouting_cat: :japanese_ogre: :japanese_goblin: :see_no_evil: :hear_no_evil:
syn keyword jrnlEmoticonKeyword :speak_no_evil: :guardsman: :skull: :feet: :lips:
syn keyword jrnlEmoticonKeyword :kiss: :droplet: :ear: :eyes: :nose:
syn keyword jrnlEmoticonKeyword :tongue: :love_letter: :bust_in_silhouette: :busts_in_silhouette: :speech_balloon:
syn keyword jrnlEmoticonKeyword :thought_balloon: :feelsgood: :finnadie: :goberserk: :godmode:
syn keyword jrnlEmoticonKeyword :hurtrealbad: :rage1: :rage2: :rage3: :rage4:
syn keyword jrnlEmoticonKeyword :suspect: :trollface: :sunny: :umbrella: :cloud:
syn keyword jrnlEmoticonKeyword :snowflake: :snowman: :zap: :cyclone: :foggy:
syn keyword jrnlEmoticonKeyword :ocean: :cat: :dog: :mouse: :hamster:
syn keyword jrnlEmoticonKeyword :rabbit: :wolf: :frog: :tiger: :koala:
syn keyword jrnlEmoticonKeyword :bear: :pig: :pig_nose: :cow: :boar:
syn keyword jrnlEmoticonKeyword :monkey_face: :monkey: :horse: :racehorse: :camel:
syn keyword jrnlEmoticonKeyword :sheep: :elephant: :panda_face: :snake: :bird:
syn keyword jrnlEmoticonKeyword :baby_chick: :hatched_chick: :hatching_chick: :chicken: :penguin:
syn keyword jrnlEmoticonKeyword :turtle: :bug: :honeybee: :ant: :beetle:
syn keyword jrnlEmoticonKeyword :snail: :octopus: :tropical_fish: :fish: :whale:
syn keyword jrnlEmoticonKeyword :whale2: :dolphin: :cow2: :ram: :rat:
syn keyword jrnlEmoticonKeyword :water_buffalo: :tiger2: :rabbit2: :dragon: :goat:
syn keyword jrnlEmoticonKeyword :rooster: :dog2: :pig2: :mouse2: :ox:
syn keyword jrnlEmoticonKeyword :dragon_face: :blowfish: :crocodile: :dromedary_camel: :leopard:
syn keyword jrnlEmoticonKeyword :cat2: :poodle: :paw_prints: :bouquet: :cherry_blossom:
syn keyword jrnlEmoticonKeyword :tulip: :four_leaf_clover: :rose: :sunflower: :hibiscus:
syn keyword jrnlEmoticonKeyword :maple_leaf: :leaves: :fallen_leaf: :herb: :mushroom:
syn keyword jrnlEmoticonKeyword :cactus: :palm_tree: :evergreen_tree: :deciduous_tree: :chestnut:
syn keyword jrnlEmoticonKeyword :seedling: :blossom: :ear_of_rice: :shell: :globe_with_meridians:
syn keyword jrnlEmoticonKeyword :sun_with_face: :full_moon_with_face: :new_moon_with_face: :new_moon: :waxing_crescent_moon:
syn keyword jrnlEmoticonKeyword :first_quarter_moon: :waxing_gibbous_moon: :full_moon: :waning_gibbous_moon: :last_quarter_moon:
syn keyword jrnlEmoticonKeyword :waning_crescent_moon: :last_quarter_moon_with_face: :first_quarter_moon_with_face: :moon: :earth_africa:
syn keyword jrnlEmoticonKeyword :earth_americas: :earth_asia: :volcano: :milky_way: :partly_sunny:
syn keyword jrnlEmoticonKeyword :octocat: :squirrel: :bamboo: :gift_heart: :dolls:
syn keyword jrnlEmoticonKeyword :school_satchel: :mortar_board: :flags: :fireworks: :sparkler:
syn keyword jrnlEmoticonKeyword :wind_chime: :rice_scene: :jack_o_lantern: :ghost: :santa:
syn keyword jrnlEmoticonKeyword :christmas_tree: :gift: :bell: :no_bell: :tanabata_tree:
syn keyword jrnlEmoticonKeyword :tada: :confetti_ball: :balloon: :crystal_ball: :cd:
syn keyword jrnlEmoticonKeyword :dvd: :floppy_disk: :camera: :video_camera: :movie_camera:
syn keyword jrnlEmoticonKeyword :computer: :tv: :iphone: :phone: :telephone:
syn keyword jrnlEmoticonKeyword :telephone_receiver: :pager: :fax: :minidisc: :vhs:
syn keyword jrnlEmoticonKeyword :sound: :speaker: :mute: :loudspeaker: :mega:
syn keyword jrnlEmoticonKeyword :hourglass: :hourglass_flowing_sand: :alarm_clock: :watch: :radio:
syn keyword jrnlEmoticonKeyword :satellite: :loop: :mag: :mag_right: :unlock:
syn keyword jrnlEmoticonKeyword :lock: :lock_with_ink_pen: :closed_lock_with_key: :key: :bulb:
syn keyword jrnlEmoticonKeyword :flashlight: :high_brightness: :low_brightness: :electric_plug: :battery:
syn keyword jrnlEmoticonKeyword :calling: :email: :mailbox: :postbox: :bath:
syn keyword jrnlEmoticonKeyword :bathtub: :shower: :toilet: :wrench: :nut_and_bolt:
syn keyword jrnlEmoticonKeyword :hammer: :seat: :moneybag: :yen: :dollar:
syn keyword jrnlEmoticonKeyword :pound: :euro: :credit_card: :money_with_wings: :e-mail:
syn keyword jrnlEmoticonKeyword :inbox_tray: :outbox_tray: :envelope: :incoming_envelope: :postal_horn:
syn keyword jrnlEmoticonKeyword :mailbox_closed: :mailbox_with_mail: :mailbox_with_no_mail: :door: :smoking:
syn keyword jrnlEmoticonKeyword :bomb: :gun: :hocho: :pill: :syringe:
syn keyword jrnlEmoticonKeyword :page_facing_up: :page_with_curl: :bookmark_tabs: :bar_chart: :chart_with_upwards_trend:
syn keyword jrnlEmoticonKeyword :chart_with_downwards_trend: :scroll: :clipboard: :calendar: :date:
syn keyword jrnlEmoticonKeyword :card_index: :file_folder: :open_file_folder: :scissors: :pushpin:
syn keyword jrnlEmoticonKeyword :paperclip: :black_nib: :pencil2: :straight_ruler: :triangular_ruler:
syn keyword jrnlEmoticonKeyword :closed_book: :green_book: :blue_book: :orange_book: :notebook:
syn keyword jrnlEmoticonKeyword :notebook_with_decorative_cover: :ledger: :books: :bookmark: :name_badge:
syn keyword jrnlEmoticonKeyword :microscope: :telescope: :newspaper: :football: :basketball:
syn keyword jrnlEmoticonKeyword :soccer: :baseball: :tennis: :8ball: :rugby_football:
syn keyword jrnlEmoticonKeyword :bowling: :golf: :mountain_bicyclist: :bicyclist: :horse_racing:
syn keyword jrnlEmoticonKeyword :snowboarder: :swimmer: :surfer: :ski: :spades:
syn keyword jrnlEmoticonKeyword :hearts: :clubs: :diamonds: :gem: :ring:
syn keyword jrnlEmoticonKeyword :trophy: :musical_score: :musical_keyboard: :violin: :space_invader:
syn keyword jrnlEmoticonKeyword :video_game: :black_joker: :flower_playing_cards: :game_die: :dart:
syn keyword jrnlEmoticonKeyword :mahjong: :clapper: :memo: :pencil: :book:
syn keyword jrnlEmoticonKeyword :art: :microphone: :headphones: :trumpet: :saxophone:
syn keyword jrnlEmoticonKeyword :guitar: :shoe: :sandal: :high_heel: :lipstick:
syn keyword jrnlEmoticonKeyword :boot: :shirt: :tshirt: :necktie: :womans_clothes:
syn keyword jrnlEmoticonKeyword :dress: :running_shirt_with_sash: :jeans: :kimono: :bikini:
syn keyword jrnlEmoticonKeyword :ribbon: :tophat: :crown: :womans_hat: :mans_shoe:
syn keyword jrnlEmoticonKeyword :closed_umbrella: :briefcase: :handbag: :pouch: :purse:
syn keyword jrnlEmoticonKeyword :eyeglasses: :fishing_pole_and_fish: :coffee: :tea: :sake:
syn keyword jrnlEmoticonKeyword :baby_bottle: :beer: :beers: :cocktail: :tropical_drink:
syn keyword jrnlEmoticonKeyword :wine_glass: :fork_and_knife: :pizza: :hamburger: :fries:
syn keyword jrnlEmoticonKeyword :poultry_leg: :meat_on_bone: :spaghetti: :curry: :fried_shrimp:
syn keyword jrnlEmoticonKeyword :bento: :sushi: :fish_cake: :rice_ball: :rice_cracker:
syn keyword jrnlEmoticonKeyword :rice: :ramen: :stew: :oden: :dango:
syn keyword jrnlEmoticonKeyword :egg: :bread: :doughnut: :custard: :icecream:
syn keyword jrnlEmoticonKeyword :ice_cream: :shaved_ice: :birthday: :cake: :cookie:
syn keyword jrnlEmoticonKeyword :chocolate_bar: :candy: :lollipop: :honey_pot: :apple:
syn keyword jrnlEmoticonKeyword :green_apple: :tangerine: :lemon: :cherries: :grapes:
syn keyword jrnlEmoticonKeyword :watermelon: :strawberry: :peach: :melon: :banana:
syn keyword jrnlEmoticonKeyword :pear: :pineapple: :sweet_potato: :eggplant: :tomato:
syn keyword jrnlEmoticonKeyword :corn: :house: :house_with_garden: :school: :office:
syn keyword jrnlEmoticonKeyword :post_office: :hospital: :bank: :convenience_store: :love_hotel:
syn keyword jrnlEmoticonKeyword :hotel: :wedding: :church: :department_store: :european_post_office:
syn keyword jrnlEmoticonKeyword :city_sunrise: :city_sunset: :japanese_castle: :european_castle: :tent:
syn keyword jrnlEmoticonKeyword :factory: :tokyo_tower: :japan: :mount_fuji: :sunrise_over_mountains:
syn keyword jrnlEmoticonKeyword :sunrise: :stars: :statue_of_liberty: :bridge_at_night: :carousel_horse:
syn keyword jrnlEmoticonKeyword :rainbow: :ferris_wheel: :fountain: :roller_coaster: :ship:
syn keyword jrnlEmoticonKeyword :speedboat: :boat: :sailboat: :rowboat: :anchor:
syn keyword jrnlEmoticonKeyword :rocket: :airplane: :helicopter: :steam_locomotive: :tram:
syn keyword jrnlEmoticonKeyword :mountain_railway: :bike: :aerial_tramway: :suspension_railway: :mountain_cableway:
syn keyword jrnlEmoticonKeyword :tractor: :blue_car: :oncoming_automobile: :car: :red_car:
syn keyword jrnlEmoticonKeyword :taxi: :oncoming_taxi: :articulated_lorry: :bus: :oncoming_bus:
syn keyword jrnlEmoticonKeyword :rotating_light: :police_car: :oncoming_police_car: :fire_engine: :ambulance:
syn keyword jrnlEmoticonKeyword :minibus: :truck: :train: :station: :train2:
syn keyword jrnlEmoticonKeyword :bullettrain_front: :bullettrain_side: :light_rail: :monorail: :railway_car:
syn keyword jrnlEmoticonKeyword :trolleybus: :ticket: :fuelpump: :vertical_traffic_light: :traffic_light:
syn keyword jrnlEmoticonKeyword :warning: :construction: :beginner: :atm: :slot_machine:
syn keyword jrnlEmoticonKeyword :busstop: :barber: :hotsprings: :checkered_flag: :crossed_flags:
syn keyword jrnlEmoticonKeyword :izakaya_lantern: :moyai: :circus_tent: :performing_arts: :round_pushpin:
syn keyword jrnlEmoticonKeyword :triangular_flag_on_post: :jp: :kr: :cn: :us:
syn keyword jrnlEmoticonKeyword :fr: :es: :it: :ru: :gb:
syn keyword jrnlEmoticonKeyword :uk: :de: :one: :two: :three:
syn keyword jrnlEmoticonKeyword :four: :five: :six: :seven: :eight:
syn keyword jrnlEmoticonKeyword :nine: :keycap_ten: :1234: :zero: :hash:
syn keyword jrnlEmoticonKeyword :symbols: :arrow_backward: :arrow_down: :arrow_forward: :arrow_left:
syn keyword jrnlEmoticonKeyword :capital_abcd: :abcd: :abc: :arrow_lower_left: :arrow_lower_right:
syn keyword jrnlEmoticonKeyword :arrow_right: :arrow_up: :arrow_upper_left: :arrow_upper_right: :arrow_double_down:
syn keyword jrnlEmoticonKeyword :arrow_double_up: :arrow_down_small: :arrow_heading_down: :arrow_heading_up: :leftwards_arrow_with_hook:
syn keyword jrnlEmoticonKeyword :arrow_right_hook: :left_right_arrow: :arrow_up_down: :arrow_up_small: :arrows_clockwise:
syn keyword jrnlEmoticonKeyword :arrows_counterclockwise: :rewind: :fast_forward: :information_source: :ok:
syn keyword jrnlEmoticonKeyword :twisted_rightwards_arrows: :repeat: :repeat_one: :new: :top:
syn keyword jrnlEmoticonKeyword :up: :cool: :free: :ng: :cinema:
syn keyword jrnlEmoticonKeyword :koko: :signal_strength: :u5272: :u5408: :u55b6:
syn keyword jrnlEmoticonKeyword :u6307: :u6708: :u6709: :u6e80: :u7121:
syn keyword jrnlEmoticonKeyword :u7533: :u7a7a: :u7981: :sa: :restroom:
syn keyword jrnlEmoticonKeyword :mens: :womens: :baby_symbol: :no_smoking: :parking:
syn keyword jrnlEmoticonKeyword :wheelchair: :metro: :baggage_claim: :accept: :wc:
syn keyword jrnlEmoticonKeyword :potable_water: :put_litter_in_its_place: :secret: :congratulations: :m:
syn keyword jrnlEmoticonKeyword :passport_control: :left_luggage: :customs: :ideograph_advantage: :cl:
syn keyword jrnlEmoticonKeyword :sos: :id: :no_entry_sign: :underage: :no_mobile_phones:
syn keyword jrnlEmoticonKeyword :do_not_litter: :non-potable_water: :no_bicycles: :no_pedestrians: :children_crossing:
syn keyword jrnlEmoticonKeyword :no_entry: :eight_spoked_asterisk: :eight_pointed_black_star: :heart_decoration: :vs:
syn keyword jrnlEmoticonKeyword :vibration_mode: :mobile_phone_off: :chart: :currency_exchange: :aries:
syn keyword jrnlEmoticonKeyword :taurus: :gemini: :cancer: :leo: :virgo:
syn keyword jrnlEmoticonKeyword :libra: :scorpius: :sagittarius: :capricorn: :aquarius:
syn keyword jrnlEmoticonKeyword :pisces: :ophiuchus: :six_pointed_star: :negative_squared_cross_mark: :a:
syn keyword jrnlEmoticonKeyword :b: :ab: :o2: :diamond_shape_with_a_dot_inside: :recycle:
syn keyword jrnlEmoticonKeyword :end: :on: :soon: :clock1: :clock130:
syn keyword jrnlEmoticonKeyword :clock10: :clock1030: :clock11: :clock1130: :clock12:
syn keyword jrnlEmoticonKeyword :clock1230: :clock2: :clock230: :clock3: :clock330:
syn keyword jrnlEmoticonKeyword :clock4: :clock430: :clock5: :clock530: :clock6:
syn keyword jrnlEmoticonKeyword :clock630: :clock7: :clock730: :clock8: :clock830:
syn keyword jrnlEmoticonKeyword :clock9: :clock930: :heavy_dollar_sign: :copyright: :registered:
syn keyword jrnlEmoticonKeyword :tm: :x: :heavy_exclamation_mark: :bangbang: :interrobang:
syn keyword jrnlEmoticonKeyword :o: :heavy_multiplication_x: :heavy_plus_sign: :heavy_minus_sign: :heavy_division_sign:
syn keyword jrnlEmoticonKeyword :white_flower: :100: :heavy_check_mark: :ballot_box_with_check: :radio_button:
syn keyword jrnlEmoticonKeyword :link: :curly_loop: :wavy_dash: :part_alternation_mark: :trident:
syn keyword jrnlEmoticonKeyword :black_square: :white_square: :white_check_mark: :black_square_button: :white_square_button:
syn keyword jrnlEmoticonKeyword :black_circle: :white_circle: :red_circle: :large_blue_circle: :large_blue_diamond:
syn keyword jrnlEmoticonKeyword :large_orange_diamond: :small_blue_diamond: :small_orange_diamond: :small_red_triangle: :small_red_triangle_down:
syn keyword jrnlEmoticonKeyword :shipit:

" }}}


" {{{ HIGHLIGHT DEFINITION

hi def Italic                       term=italic cterm=italic gui=italic
hi def Bold                         term=bold cterm=bold gui=bold
hi def BoldItalic                   term=bold,italic cterm=bold,italic gui=bold,italic

hi def link jrnlItalic                  Italic
hi def link jrnlBold                    Bold
hi def link jrnlBoldItalic              BoldItalic

hi def link jrnlPullRequestLinkInText   Underlined
hi def link jrnlUserLinkInText          Underlined
hi def link jrnlUrlLinkInText           Underlined
hi def link jrnlEmailLinkInText         Underlined

hi def link jrnlLinkText                Underlined
hi def link jrnlLinkUrl                 Underlined
hi def link jrnlLinkTitleSingleQuoted   Bold
hi def link jrnlLinkTitleDoubleQuoted   Bold
hi def link jrnlLinkUrlContainer        Delimiter
hi def link jrnlLinkTextContainer       Delimiter
hi def link jrnlLinkReference           NonText

hi def link jrnlCodeDelimiter           Delimiter
hi def link jrnlInlineCode              String
hi def link jrnlFencedCodeBlock         String
hi def link jrnlCodeBlock               String

hi def link jrnlTableDelimiter          Delimiter
hi def link jrnlTableHeader             Bold

hi def link jrnlStrike                  NonText
hi def link jrnlStrikeDelimiter         Delimiter
hi def link jrnlBlockquote              Comment
hi def link jrnlBlockquoteDelimiter     Delimiter
hi def link jrnlInlineDelimiter         Delimiter
hi def link jrnlListDelimiter           Delimiter

hi def link jrnlHeaderId                Delimiter
hi def link jrnlHeadingDelimiter        Delimiter
hi def link jrnlHeadingUnderline        Delimiter
hi def link jrnlHeader                  Title
hi def link jrnlH1                      Title
hi def link jrnlH2                      Title
hi def link jrnlH3                      Title
hi def link jrnlH4                      Title
hi def link jrnlH5                      Title
hi def link jrnlH6                      Title

hi def link jrnlEmoticonKeyword         Statement
hi def link jrnlRule                    Identifier

hi def link jrnlXmlComment              NonText
hi def link jrnlXmlElement              NonText
hi def link jrnlXmlEmptyElement         NonText
hi def link jrnlXmlEntities             Special

" }}}


if !exists('g:jrnl_include_jekyll_support') || g:jrnl_include_jekyll_support
  execute 'runtime! syntax/jrnl_jekyll.vim'
endif

" if exists('b:current_syntax') | finish | endif

if !exists('g:jrnl_tagsymbols')
    let g:jrnl_tagsymbols = ['@']
endif

syntax match jrnlDate '^\d\{4\}-\d\{2\}-\d\{2\}'
syntax match jrnlTime ' \d\{2\}:\d\{2\} '
syntax match jrnlTodo '^ - .*$'
execute 'syntax match jrnlTag "\('. join(g:jrnl_tagsymbols, '\|') . '\)\(\w\|-\|+\|*\|#\|/\)\+"'

highlight def link jrnlDate String
highlight def link jrnlTag Identifier
highlight def link jrnlTime Type
highlight def link jrnlTodo Keyword

let b:current_syntax = "jrnl"
if main_syntax ==# 'jrnl'
  unlet main_syntax
endif
