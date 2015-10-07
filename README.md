# REPLMods

Mod your REPL.

Let's you work at the REPL and evaluate directly into any module on your path or
defined within the current working module.

TODO: a real README

Example

```
julia> using REPLMods

julia> import Gadfly

julia> REPLMods.build_module_repl(Gadfly)

julia> # Now I press `.` and prompt switches to `Gadfly>`

Gadfly>Guide.  # then I hit tab to show a list of completions
Annotation                  XLabel                       over_guide_position
BottomGuidePosition         XTicks                       render_colorkey_title
ColorKey                    YLabel                       render_continuous_color_key
GuidePosition               YTicks                       render_discrete_color_key
LeftGuidePosition           ZoomSlider                   right_guide_position
ManualColorKey              annotation                   title
OverGuidePosition           background                   top_guide_position
PanelBackground             bottom_guide_position        under_guide_position
PositionedGuide             colorkey                     xlabel
RightGuidePosition          eval                         xticks
Title                       layout_guides                ylabel
TopGuidePosition            left_guide_position          yticks
UnderGuidePosition          manual_color_key             zoomslider
Gadfly> foobar = 100
100

Gadfly>foobar
100

Gadfly> # now I hit delete to return to julia REPL

julia> foobar
ERROR: UndefVarError: foobar not defined

julia> Gadfly.foobar
100

```

I could have chosen something other than `.`:

```
julia> using REPLMods
im
julia> import Gadfly

julia> REPLMods.build_module_repl(Gadfly, key='}')

julia> # now I press } and it gives me my Gadfly prompt

Gadfly>
```
