" Print current working file to default printer
" Depends on the following variables:
" - g:Hardcopy_paperType
" Depends on the following binaries:
" - html2pdf
" - lp
" - rm
" Depends on the following plugins
" - nvim.tohtml
command Hardcopy call s:Print()
command Hc call s:Print()
command HC call s:Print()
function s:Print()
  " Load required plugins
  packadd nvim.tohtml
  " Conversions
  TOhtml
  let l:file = expand("%")
  write
  quit
  let l:destFile = l:file .. ".pdf"
  silent
  execute("!html2pdf" .. " --output " .. l:destFile .. " --paper ".. g:Hardcopy_paperType .. " " .. l:file)
  silent
  " Schedule print job
  execute("!lp " .. l:destFile)
  silent
  " Cleanup
  execute("!rm " .. l:destFile .. " " .. l:file)
  return
endfunction
