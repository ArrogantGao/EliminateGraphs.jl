using EliminateGraphs
using Test
using Random

@testset "xiao2013" begin
    for seed in 10:2:100
        Random.seed!(seed)
        g = random_regular_graph(seed, 3)
        eg = EliminateGraph(g)
        mis_size_standard = mis2(eg)
        mis_size = mis_xiao2013(g)
        @test mis_size_standard == mis_size
    end
end