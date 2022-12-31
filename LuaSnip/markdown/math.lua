-- Important: remember to exit snippets with trigger, otherwise
-- all tabstops will be kept in memory and that can cause
-- performance issues.

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

-- Math context detection (requires vimtex plugin) 
-- Note: I tried both options but it was expensive in terms of performance for my pc
-- So I opted for more unusual triggers that can be used globally in the markdown file
-- rather than just inside the $ $
-- local tex = {}
-- tex.in_mathzone = function() return vim.fn['vimtex#syntax#in_mathzone']() == 1 end
-- tex.in_text = function() return not tex.in_mathzone() end

-- Suggested: knowledge of regular expressions makes life much easier to understand what happens here
-- Return snippet tables
return{
  -- SUBSCRIPTS and SUPERSCRIPTS
   -- SUPERSCRIPT
  s({trig = "([%w%)%]%}])'", wordTrig=false, regTrig = true, snippetType="autosnippet"},
    fmta(
      "<>^{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual),
      }
    )
  ),
  -- SUBSCRIPT
  s({trig = "([%w%)%]%}]);", wordTrig=false, regTrig = true, snippetType="autosnippet"},
    fmta(
      "<>_{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual),
      }
    )
  ),
  -- SUBSCRIPT AND SUPERSCRIPT
  s({trig = "([%w%)%]%}])__", wordTrig=false, regTrig = true, snippetType="autosnippet"},
    fmta(
      "<>^{<>}_{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        i(1),
        i(2),
      }
    )
  ),
  -- TEXT SUBSCRIPT
  s({trig = 'sd', snippetType="autosnippet", wordTrig=false},
    fmta("_{\\mathrm{<>}}",
      { d(1, get_visual) }
    )
  ),
  -- SUPERSCRIPT SHORTCUT
  -- Places the first alphanumeric character after the trigger into a superscript.
  -- e.g. a"2 becomes a^{2}
  s({trig = '([%w%)%]%}])"([%w])', regTrig = true, wordTrig = false, snippetType="autosnippet"},
    fmta(
      "<>^{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        f( function(_, snip) return snip.captures[2] end ),
      }
    )
  ),
  -- SUBSCRIPT SHORTCUT
  -- Places the first alphanumeric character after the trigger into a subscript.
  -- e.g. a:z becomes a_{z}
  s({trig = '([%w%)%]%}]):([%w])', regTrig = true, wordTrig = false, snippetType="autosnippet"},
    fmta(
      "<>_{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        f( function(_, snip) return snip.captures[2] end ),
      }
    )
  ), 
  -- MINUS ONE SUPERSCRIPT SHORTCUT (TO CHANGE conflicts with a1 to a_1)
  s({trig = '([%a%)%]%}])11', regTrig = true, wordTrig = false, snippetType="autosnippet"},
    fmta(
      "<>_{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        t("-1")
      }
    )
  ),
  -- J SUBSCRIPT SHORTCUT (since jk triggers snippet jump forward)
  s({trig = '([%a%)%]%}])JJ', wordTrig = false, regTrig = true, snippetType="autosnippet"},
    fmta(
      "<>_{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        t("j")
      }
    )
  ),
  -- PLUS SUPERSCRIPT SHORTCUT
  s({trig = '([%a%)%]%}])%+%+', regTrig = true, wordTrig = false, snippetType="autosnippet"},
    fmta(
      "<>^{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        t("+")
      }
    )
  ),
  -- COMPLEMENT SUPERSCRIPT: xcc becomes x^{\complement}
  s({trig = '([%a%)%]%}])cc', regTrig = true, wordTrig = false, snippetType="autosnippet"},
    fmta(
      "<>^{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        t("C")
      }
    )
  ),
  -- CONJUGATE (STAR) SUPERSCRIPT SHORTCUT: x** becomes x^{*}
  s({trig = '([%a%)%]%}])%*%*', regTrig = true, wordTrig = false, snippetType="autosnippet"},
    fmta(
      "<>^{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        t("*")
      }
    )
  ),
  -- Expand ee to e^{} after spaces, delimiters and so on but not in words like "see", "feel" etc.
  s({trig = '([^%a])ee', regTrig = true, wordTrig = false, snippetType="autosnippet"},
    fmta(
      "<>e^{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual)
      }
    )
  ),
  -- _{0} after letters and closing delimiters i.e. | ) ] } but not in numbers like 100
  s({trig = '([%a%|%)%]%}])0', regTrig = true, wordTrig = false, snippetType="autosnippet"},
    fmta(
      "<>_{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        t("0")
      }
    )
  ),
  -- type ; after brackets to have _{}
  -- figure out how to make it work without conflict of normal text in markdown (math context vs not)
  s({trig = "([%)%]%}]);", wordTrig=false, regTrig = true, snippetType="autosnippet"},
    fmta(
      "<>_{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual),
      }
    )
  ),
  -- FONTS and TEXT (mathbb and mathcal)
  -- MATH BLACKBOARD i.e. \mathbb
  s({trig = "([^%a])mbb", regTrig = true, wordTrig = false, snippetType="autosnippet"},
    fmta(
      "<>\\mathbb{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual),
      }
    )
  ),
  -- MATH CALIGRAPHY i.e. \mathcal
  s({trig = "([^%a])mcc", regTrig = true, wordTrig = false, snippetType="autosnippet"},
    fmta(
      "<>\\mathcal{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual),
      }
    )
  ),
  -- REGULAR TEXT i.e. \text 
  s({trig = "([^%a])tee", regTrig = true, wordTrig = false, snippetType="autosnippet"},
    fmta(
      "<>\\text{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
          d(1, get_visual),
      }
    )
  ),
  -- GENERAL MATHEMATICAL NOTATION
  -- Absolute value
  s({trig = "([^%a])aa", regTrig = true, wordTrig = false, snippetType="autosnippet"},
    fmta(
      "<>\\left| <> \\right|",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual),
      }
    )
  ),
  -- Angle brackets
  s({trig = "([^%a])lng", regTrig = true, wordTrig = false, snippetType="autosnippet"},
    fmta(
      "<>\\langle <> \\rangle",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual),
      }
    )
  ),
  -- Norm
  s({trig = "([^%a])nr", regTrig = true, wordTrig = false, snippetType="autosnippet"},
    fmta(
      "<>\\left\\lVert <> \\right\\rVert",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual),
      }
    )
  ),
  -- Expand ff to \frac{}{} but not in words
  s({trig = '([^%a])ff', regTrig = true, wordTrig = false, snippetType="autosnippet"},
    fmta(
      [[<>\frac{<>}{<>}]],
      {
        f( function(_, snip) return snip.captures[1] end ),
        i(1),
        i(2)
      }
    )
  ),
  -- Bar (ideally use math mode)
  s({trig = "([^%a])bbb", regTrig = true, wordTrig = false, snippetType="autosnippet"},
    fmta(
      "<>\\bar_{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual),
      }
    )
  ),
  -- Hat
  s({trig = "([^%a])ht", regTrig = true, wordTrig = false, snippetType="autosnippet"},
    fmta(
      "<>\\hat_{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual),
      }
    )
  ),
  -- Overline
  s({trig = "([^%a])ovl", regTrig = true, wordTrig = false, snippetType="autosnippet"},
    fmta(
      "<>\\overline_{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual),
      }
    )
  ),
  -- Tilde
  s({trig = "([^%a])til", regTrig = true, wordTrig = false, snippetType="autosnippet"},
    fmta(
      "<>\\tilde{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual),
      }
    )
  ),
  -- SQUARE ROOT
  s({trig = "([^%\\])sq", wordTrig = false, regTrig = true, snippetType="autosnippet"},
    fmta(
      "<>\\sqrt{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual),
      }
    )
  ),
  -- BINOMIAL SYMBOL
  s({trig = "([^%\\])bnn", wordTrig = false, regTrig = true, snippetType="autosnippet"},
    fmta(
      "<>\\binom{<>}{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        i(1),
        i(2),
      }
    )
  ),
  -- LOGARITHM WITH BASE SUBSCRIPT
  s({trig = "([^%a%\\])lg", wordTrig = false, regTrig = true, snippetType="autosnippet"},
    fmta(
      "<>\\log_{<>}",
      {
        f( function(_, snip) return snip.captures[1] end ),
        i(1),
      }
    )
  ),
  -- Spaces
  s({trig="LL", snippetType="autosnippet"},
    {
      t("& "),
    }
  ),
  s({trig="q"}, -- needs to be manually triggered
    {
      t("\\quad "),
    }
  ),
  s({trig="qq", snippetType="autosnippet"},
    {
      t("\\qquad "),
    }
  ),
  -- Infinity
  s({trig="inff", snippetType="autosnippet"},
    {
      t("\\infty"),
    }
  ),
  -- inn becomes \in \mathbb{R} (default option, press tab to keep it or write to change it)
  s({trig="([^%a])inn", regTrig=true, wordTrig = false, snippetType="autosnippet"},
    fmta(
      [[\in {<>}]],
      {
        i(1, "\\mathbb{R}"),
      }
    )
  ),
  -- xn becomes x \in \ 
  s({trig="([^%a])xnn", regTrig=true, wordTrig = false, snippetType="autosnippet"},
    fmta(
      [[<>x \in <>]],
      {
        f( function(_, snip) return snip.captures[1] end ),
        d(1, get_visual),
      }
    )
  ),
  -- Xt becomes X_{t} 
  s({trig="Xt", snippetType="autosnippet"},
    {
      t("X_{t}"),
    }
  ),
  -- "Evaluated at" a.k.a vert

} 
