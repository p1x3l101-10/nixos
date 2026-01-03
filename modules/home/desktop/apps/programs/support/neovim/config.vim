" Print current working file to default printer
" Depends on the following variables:
" - g:Hardcopy_paperType
command Hardcopy call s:Print()
command Hc call s:Print()
command HC call s:Print()
function s:Print()
  TOhtml
  let l:file = expand("%")
  quit
  let l:destFile = l:file .. ".pdf"
  silent
  execute("!html2pdf" .. " --output " .. l:destFile .. " --paper ".. g:Hardcopy_paperType .. " " .. s:file)
  silent
  execute("!lp " .. l:destFile)
  silent
  execute("!rm " .. l:destFile .. " " .. l:file)
  return
endfunction
