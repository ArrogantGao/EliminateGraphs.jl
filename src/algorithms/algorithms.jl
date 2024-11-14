include("mis1.jl")
include("mis2.jl")
include("xiao2013.jl")
include("xiao2013_utils.jl")

mis1(g::SimpleGraph) = mis1(EliminateGraph(g))
mis2(g::SimpleGraph) = mis2(EliminateGraph(g))