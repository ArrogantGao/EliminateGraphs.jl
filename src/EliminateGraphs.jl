module EliminateGraphs

using Graphs
import Graphs: vertices, edges, neighbors, ne, nv, degree

using Combinatorics

include("utils.jl")
include("Core.jl")
include("Graph.jl")
include("iterset.jl")
include("generateset.jl")
include("degrees.jl")
include("eliminate.jl")
include("graphlib.jl")
include("algorithms/algorithms.jl")
end # module
