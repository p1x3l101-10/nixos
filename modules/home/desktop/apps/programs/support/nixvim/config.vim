" Print current working file to default printer
" Depends on the following variables:
" - g:Hardcopy_paperType
" Depends on the following binaries:
" - html2pdf
" - gdbus
" - rm
" Depends on the following plugins
" - nvim.tohtml
" Notes
" - Was built with the assumption that the running shell is nushell, might not
"   work otherwise
command Hardcopy call s:Print()
command Hc call s:Print()
command HC call s:Print()
function s:Print()
  " Load required plugins
  echo "Loading plugins"
  packadd nvim.tohtml
  " Conversions
  echo "Wrapping in HTML"
  TOhtml
  let l:file = expand("%")
  silent write
  quit
  let l:destFile = l:file .. ".pdf"
  echo "Rendering as PDF"
  silent execute("!html2pdf" .. " --output " .. l:destFile .. " --paper ".. g:Hardcopy_paperType .. " " .. l:file)
  " Schedule print job
  echo "Requesting Print Job"
  silent execute("!open `" .. l:destFile .. "` | gdbus call --session --dest org.freedesktop.portal.Desktop --object-path /org/freedesktop/portal/desktop --method org.freedesktop.portal.Print.Print `` `Printing from Vim` 0 `{'modal':<true>}`")
  " Cleanup
  echo "Cleaning up"
  silent execute("!rm " .. l:destFile .. " " .. l:file)
  echo "Done"
  return
endfunction
