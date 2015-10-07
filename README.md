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

Gadfly>Guide.
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
Gadfly>Guide.
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
