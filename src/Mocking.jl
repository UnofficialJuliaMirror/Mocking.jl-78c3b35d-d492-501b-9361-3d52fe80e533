module Mocking

export @patch, @mock, Patch, apply

struct Injector{name} end

include("expr.jl")
include("dispatch.jl")
include("patch.jl")
include("mock.jl")
include("deprecated.jl")

include("cassette-static.jl")
include("cassette-code-gen.jl")

const global INJECTOR = Ref{Injector}(Injector{:MockMacro}())

function apply(body::Function, patch_env::PatchEnv)
    apply(INJECTOR[], body, patch_env)
end

# Create the initial definition of `activated` which defaults Mocking to be disabled
activated() = false

"""
    Mocking.activate()

Enable `@mock` call sites to allow for calling patches instead of the original function.
"""
function activate()
    # Avoid redefining `activated` when it's already set appropriately
    !activated() && Core.eval(@__MODULE__, :(activated() = true))
    return nothing
end

"""
    Mocking.deactivate()

Disable `@mock` call sites to only call the original function.
"""
function deactivate()
    # Avoid redefining `activated` when it's already set appropriately
    activated() && Core.eval(@__MODULE__, :(activated() = false))
    return nothing
end

end # module
