-- Source - https://stackoverflow.com/a/56005271
-- Posted by tarleb, modified by community. See post 'Timeline' for change history
-- Retrieved 2026-05-04, License - CC BY-SA 4.0

local title

-- Promote all headers by one level. Set title from level 1 headers,
-- unless it has been set before.
function promote_header (header)

  if header.level >= 2 then
    header.level = header.level - 1
    return header
  end

  if not title then
    title = header.content
    return {}
  end

  local msg = '[WARNING] title already set; discarding header "%s"\n'
  io.stderr:write(msg:format(pandoc.utils.stringify(header)))
  return {}
end

return {
  {Meta = function (meta) title = meta.title end}, -- init title
  {Header = promote_header},
  {Meta = function (meta) meta.title = title; return meta end}, -- set title
}
