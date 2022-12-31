-- This is the get_visual function. Summary: If `SELECT_RAW` is populated 
-- with a visual selection, the function returns an insert node whose initial
-- text is set to the visual selection. If `SELECT_RAW` is empty, the function simply returns an empty insert node.
local function get_visual(args, parent)
  if (#parent.snippet.env.SELECT_RAW > 0) then
    return sn(nil, i(1, parent.snippet.env.SELECT_RAW))
  else
    return sn(nil, i(1, ''))
  end
end

local line_begin = require("luasnip.extras.expand_conditions").line_begin

-- Return snippet tables
return{
    -- Fenced block of code
    s({trig="cc", snippetType="autosnippet"},
      fmta(
        [[
        ```<>
        <>
        ```
      ]],
        {
          i(1),
          d(2, get_visual),
        }
      ),
      {condition = line_begin}
    ),
    -- Inline code
    s({trig="cx", snippetType="autosnippet"},
      fmta(
        [[
        `<>`
      ]],
        {
          i(1),
        }
      ),
      {condition = line_begin}
    ),
    -- Inline (fenced) math, if you want to avoid conflit with words but not trigger
    -- at the beginning of a line place ([^%a])fm
    s({trig = "fm", wordTrig = false, regTrig = true, snippetType="autosnippet"},
      fmta(
        "<>$<>$",
        {
          f( function(_, snip) return snip.captures[1] end ),
          d(1, get_visual),
        }
      )
    ),
    -- Display math
    s({trig = "dm", wordTrig = false, regTrig = true, snippetType="autosnippet"},
      fmta(
        "<>$$<>$$",
        {
          f( function(_, snip) return snip.captures[1] end ),
          d(1, get_visual),
        }
      )
    ),
    -- BOLDFACE TEXT
    s({trig="tbb", snippetType="autosnippet"},
      fmta(
        [[**<>**]],
        {
          d(1, get_visual),
        }
      )
    ),
    -- ITALIC TEXT
    s({trig="tii", snippetType="autosnippet"},
      fmta(
        [[*<>*]],
        {
          d(1, get_visual),
        }
      )
    ),
}
