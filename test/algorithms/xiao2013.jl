using EliminateGraphs
using Test
using Random

@testset "xiao2013" begin
    for seed in 1:100
        Random.seed!(1234)
        g = random_regular_graph(100, 3)
        eg = EliminateGraph(g)
        mis_size_standard = mis2(eg)
        mis_size = xiao2013(g)
        @test mis_size_standard == mis_size
    end
end