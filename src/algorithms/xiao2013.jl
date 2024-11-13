# the algorithm in Confining sets and avoiding bottleneck cases: A simple maximum independent set algorithm in degree-3 graphs
export mis_xiao2013, count_xiao2013


function mis_xiao2013(g::SimpleGraph)
    return _xiao2013(g).mis
end

function count_xiao2013(g::SimpleGraph)
    return _xiao2013(g).count
end


function _xiao2013(g::SimpleGraph)
    if nv(g) == 0
        return CountingMIS(0)
    elseif nv(g) == 1
        return CountingMIS(1)
    elseif nv(g) == 2
        return CountingMIS(2 - has_edge(g, 1, 2))
    else
        degrees = degree(g)
        degmin = minimum(degrees)
        vmin = findfirst(==(degmin), degrees)

        if degmin == 0
            all_zero_vertices = findall(==(0), degrees)
            return length(all_zero_vertices) + _xiao2013(remove_vertex(g, all_zero_vertices))
        elseif degmin == 1
            return 1 + _xiao2013(remove_vertex(g, neighbors(g, vmin) ∪ vmin))
        elseif degmin == 2
            return 1 + _xiao2013(folding(g, vmin))
        end

        unconfined_vertices = find_unconfined_vertices(g)
        if length(unconfined_vertices) != 0
            rem_vertices!(g, [unconfined_vertices[1]])
            return _xiao2013(g)
        end

        g_new = twin_filter(g)
        if g_new != g
            return _xiao2013(g_new)+2
        end

        filter_result = short_funnel_filter(g)
        if filter_result[2] == 1
            return _xiao2013(filter_result[1])+1
        end

        g_new = desk_filter(g)
        if g_new != g
            return _xiao2013(g_new)+2
        end

        branches = one_layer_effective_vertex_filter(g)
        if length(branches) == 2
            return max(_xiao2013(branches[1][1])+branches[1][2], _xiao2013(branches[2][1])+branches[2][2])
        end

        branches = funnel_filter(g)
        if length(branches) == 2
            return max(_xiao2013(branches[1][1])+branches[1][2], _xiao2013(branches[2][1])+branches[2][2])
        end

        branches = four_cycle_filter(g)
        if length(branches) == 2
            return max(_xiao2013(branches[1][1])+branches[1][2], _xiao2013(branches[2][1])+branches[2][2])
        end

        branches = vertex_filter(g)
        return max(_xiao2013(branches[1][1])+branches[1][2], _xiao2013(branches[2][1])+branches[2][2])
    end
end