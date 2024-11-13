using EliminateGraphs
using Test

using EliminateGraphs: line_graph,find_unconfined_vertices,confined_set,twin_filter,short_funnel_filter,desk_filter,one_layer_effective_vertex_filter,funnel_filter,count_o_path,has_fine_structure,four_cycle_filter,vertex_filter

using EliminateGraphs: find_children, unconfined_vertices

@testset "find_children" begin
    function graph_from_edges(edges)
        return SimpleGraph(Graphs.SimpleEdge.(edges))
    end
    g = graph_from_edges([(1,2),(2,3), (1,4), (2,5), (3,5)])
    @test find_children(g, [1]) == [2, 4]
    @test find_children(g, [1,2,3]) == [4]
end

@testset "line graph" begin
    edges = [(1,2),(1,4),(1,5),(2,3),(2,4),(2,5),(3,4),(3,5)]
    example_g = SimpleGraph(Graphs.SimpleEdge.(edges))
    @test is_lg = line_graph(example_g) == true

    edges = [(1,2),(1,4),(1,5),(2,3),(2,4),(2,5),(3,4),(3,5),(4,5)]
    example_g = SimpleGraph(Graphs.SimpleEdge.(edges))
    @test is_lg = line_graph(example_g) == false
end


@testset "confined set and unconfined vertices" begin
    # edges = [(1, 2), (2, 3), (2, 6), (3, 4), (3, 6), (4, 5), (5, 6)]
    # example_g = SimpleGraph(Graphs.SimpleEdge.(edges))
    # @test unconfined_vertices(example_g) == [2]

    # for v in 1:6
    #     if v != 2
    #         @test confined_set(example_g,v) != nothing
    #     end
    # end

    # via dominated rule
    g = graph_from_edges([(1,2),(1,3),(1, 4), (2, 3), (2, 4), (2, 6), (3, 5), (4, 5)])
    @test unconfined_vertices(g) == [2]
    
    # via roof
    g = graph_from_edges([(1, 2), (1, 5), (1, 6), (2, 5), (2, 3), (4, 5), (3, 4), (3, 7), (4, 7)])
    @test in(1, unconfined_vertices(g))
end


@testset "twin" begin
    edges = [(1, 3), (1, 4), (1, 5), (2, 3), (2, 4), (2, 5), (4, 5), (3, 6), (3, 7), (4, 8), (5, 9), (5, 10)]
    example_g = SimpleGraph(Graphs.SimpleEdge.(edges))
    g_after = twin_filter(example_g)
    @test ne(g_after) == 0

    edges = [(1, 3), (1, 4), (1, 5), (2, 3), (2, 4), (2, 5), (3, 6), (3, 7), (4, 8), (5, 9), (5, 10)]
    example_g = SimpleGraph(Graphs.SimpleEdge.(edges))
    g_after = twin_filter(example_g)
    @test ne(g_after) == 5
end



@testset "short funnel" begin
    edges = [(1, 2), (1, 4), (1, 5), (2, 3), (2, 6), (3, 6), (4, 6)]
    example_g = SimpleGraph(Graphs.SimpleEdge.(edges))
    g_after = short_funnel_filter(example_g)
    @test g_after == (SimpleGraph{Int64}(5, [[2, 3, 4], [1, 3], [1, 2, 4], [1, 3]]), 1)
end


@testset "desk" begin
    edges = [(1, 2), (1, 4), (1, 8), (2, 3), (2, 7), (3, 8), (5, 7), (6, 8), (7, 8)]
    example_g = SimpleGraph(Graphs.SimpleEdge.(edges))
    g_after = desk_filter(example_g)
    @test g_after == SimpleGraph{Int64}(4, [[2, 4], [1, 3], [2, 4], [1, 3]])
end


@testset "effective vertex" begin
    edges = [(1, 2), (1, 3), (1, 4), (2, 3), (2, 7), (3, 8), (4, 5), (4, 6)]
    example_g = SimpleGraph(Graphs.SimpleEdge.(edges))
    g_after = one_layer_effective_vertex_filter(example_g)
    @test g_after == example_g
end

@testset "funnel" begin
    edges = [(1, 2), (1, 3), (1, 4), (1, 5), (2, 3), (2, 4), (3, 4)]
    example_g = SimpleGraph(Graphs.SimpleEdge.(edges))
    g_after = funnel_filter(example_g)
    @test g_after[1] == (SimpleGraph{Int64}(0, Vector{Int64}[]), 1)
    @test g_after[2] == (SimpleGraph{Int64}(3, [[2, 3], [1, 3], [1, 2]]), 1)
end

@testset "o_path" begin
    edges = [(1, 2), (2, 3), (3, 4), (1, 5), (1, 6), (3, 7)]
    example_g = SimpleGraph(Graphs.SimpleEdge.(edges))
    o_path_num = count_o_path(example_g)
    @test o_path_num == 1

    edges = [(1, 2), (2, 3), (3, 4), (1, 5), (1, 6), (4, 7),(4, 8)]
    example_g = SimpleGraph(Graphs.SimpleEdge.(edges))
    o_path_num = count_o_path(example_g)
    @test o_path_num == 0
end

@testset "fine_structure" begin
    edges = [(1, 2), (2, 3), (3, 4), (1, 5), (1, 6), (3, 7)]
    example_g = SimpleGraph(Graphs.SimpleEdge.(edges))
    @test has_fine_structure(example_g) == true

    edges = [(1, 2), (1, 3), (1, 4), (2, 3), (2, 7), (3, 8), (4, 5), (4, 6)]
    example_g = SimpleGraph(Graphs.SimpleEdge.(edges))
    @test has_fine_structure(example_g) == true

    edges = [(1, 2), (2, 3), (3, 4), (1, 5), (1, 6), (4, 7),(4, 8)]
    example_g = SimpleGraph(Graphs.SimpleEdge.(edges))
    @test has_fine_structure(example_g) == false
end

@testset "four_cycle" begin
    edges = [(1, 2), (2, 3), (3, 4), (4, 1), (1, 5)]
    example_g = SimpleGraph(Graphs.SimpleEdge.(edges))
    g_after = four_cycle_filter(example_g)
    @test nv(g_after[1][1]) == 3
    @test ne(g_after[2][1]) == 1
    edges = [(1, 2), (2, 3), (3, 1)]
    example_g = SimpleGraph(Graphs.SimpleEdge.(edges))
    g_after = four_cycle_filter(example_g)
    @test g_after == example_g
end

@testset "optimal vertex" begin
    edges = [(1, 2), (2, 6), (1, 3), (3, 7), (1, 4), (4, 8), (1, 5), (5, 9)]
    example_g = SimpleGraph(Graphs.SimpleEdge.(edges))
    g_after = vertex_filter(example_g)
    @test g_after[1] == (SimpleGraph{Int64}(4, [[5], [6], [7], [8], [1], [2], [3], [4]]), 0)
    @test g_after[2] == (SimpleGraph{Int64}(0, Vector{Int64}[]), 5)
end