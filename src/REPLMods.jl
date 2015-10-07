module REPLMods

import Base: LineEdit, REPL, REPLCompletions

# TODO: we should probably pop the REPL off `mirepl.interface.modes`
#       and somehow fix up main_mode.keymap_dict. Not quite sure how

# TODO: if we don't decide to kill off the old module prompts we should
#       provide a modal interface where when `key` is pressed
#       we present a list of the modules we already have prompts for and the
#       user can select which one he wants.

type ModuleREPLCompletionProvider <: REPL.CompletionProvider
    r::REPL.LineEditREPL
    mod::Module
end

function REPL.complete_line(c::ModuleREPLCompletionProvider, s)
    partial = string(c.mod, ".", REPL.bytestring_beforecursor(s.input_buffer))
    full = string(c.mod, ".", LineEdit.input_string(s))
    ret, range, should_complete = REPLCompletions.completions(full, endof(partial))
    return ret, partial[range], should_complete
end

function build_module_repl(mod::Module; key::Char='.',
                           color::AbstractString=Base.text_colors[:cyan],
                           prompt::AbstractString=string(mod, ">"))
    # extract REPL and  modal interface, if any
    mirepl = isdefined(Base.active_repl,:mi) ? Base.active_repl.mi :
                                               Base.active_repl
    repl = Base.active_repl
    main_mode = mirepl.interface.modes[1]
    hp = main_mode.hist
    replc = ModuleREPLCompletionProvider(repl, mod)

    # if we already have a prompt for this module, just return
    if haskey(hp.mode_mapping, symbol("_", mod))
        return nothing
    end

    # build prompt
    mod_prompt = LineEdit.Prompt(prompt;
        prompt_prefix = color,
        prompt_suffix = "\e[1m",
        keymap_func_data = repl,
        complete = replc)

    # on_done needs to eval into `mod` instead of into Main.
    # also keeps the `mod_prompt` active
    mod_prompt.on_done = Base.REPL.respond(repl, mod_prompt) do line
        Expr(:call, :($mod.eval), :(Base.parse_input_line($line)))
    end

    # add mod_prompt to list of modes
    push!(mirepl.interface.modes, mod_prompt)

    # add history to mod_prompt
    hp.mode_mapping[symbol("_", mod)] = mod_prompt
    mod_prompt.hist = hp

    # Add keymap so we can get into our module prompt
    const mod_keymap = Dict{Any,Any}(
        key => function (s,args...)
            if isempty(s) || position(LineEdit.buffer(s)) == 0
                buf = copy(LineEdit.buffer(s))
                LineEdit.transition(s, mod_prompt) do
                    LineEdit.state(s, mod_prompt).input_buffer = buf
                end
            else
                # don't do anything, just add the key as a standard character
                LineEdit.edit_insert(s, key)
            end
        end
    )

    # add  stuff that is in Cxx.jl that I don't understand yet
    search_prompt, skeymap = LineEdit.setup_search_keymap(hp)
    mk = REPL.mode_keymap(main_mode)

    b = Dict{Any,Any}[skeymap, mk, LineEdit.history_keymap,
                      LineEdit.default_keymap, LineEdit.escape_defaults]
    mod_prompt.keymap_dict = LineEdit.keymap(b)

    main_mode.keymap_dict = LineEdit.keymap_merge(main_mode.keymap_dict,
                                                  mod_keymap)
    nothing

end


end # module
