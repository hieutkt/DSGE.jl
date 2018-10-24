# This file holds functions that compute the upwinding scheme
# for the value function, given inputs for the savings over
# the state space, and solves the HJB equation,
# given the standard form: ρV = u + AV.



# Upwind step for value function
# Exact upwind
function upwind_value_function{T<:Number}(dVf::Matrix{T}, dVb::Matrix{T}, dV0::Matrix{T},
                                          sf::Matrix{T}, sb::Matrix{T})
    If = sf .> 0 # positive drift -> forward diff
    Ib = sb .< 0 # negative drift -> backward dift
    I0 = (1 - If - Ib)
    V =  dVf .* If + dVb .* Ib + dV0 .* I0
    return V, If, Ib, I0
end

# Inexact upwind, assumes positive consumption drift corresponds to positive value function drift,
# written based on model using CRRA utility with labor disutility
# Vaf - value function without labor disutility applied to forward consumption diff
# Vf - value function w/labor disutility, etc., applied to forward consumption diff, forward hours diff, etc.
function upwind_value_function{T<:Number}(Vaf::Matrix{T}, Vab::Matrix{T}, Va0::Matrix{T},
                                          Vf_orig::Matrix{T}, Vb_orig::Matrix{T}, V0_orig::Matrix{T},
                                          cf::Matrix{T}, cb::Matrix{T}, c0::Matrix{T},
                                          sf::Matrix{T}, sb::Matrix{T}; reverse_sign::Float64 = -1e12)
    Vf = (cf .> 0) .* (Vf_orig + sf .* Vaf) + (cf .<= 0) * (reverse_sign)
    Vb = (cb .> 0) .* (Vb_orig + sb .* Vab) + (cb .<= 0) * (reverse_sign)
    V0 = (c0 .> 0) .* V0_orig + (c0 .<= 0) * (reverse_sign)

    I_neither = (1 - (sf .> 0)) .* (1 - (sb .< 0)) # exactly zero drift
    I_unique = (sb .< 0) .* (1 - (sf .> 0)) + (1 - (sb .< 0)) .* (sf .> 0) # just one direction
    I_both = (sb .< 0) .* (sf .> 0) # both positive and negative

    Ib = I_unique .* (sb .< 0) .* (Vb .> V0) + I_both .* (Vb .== max.(max.(Vb, Vf), V0))
    If = I_unique .* (sf .> 0) .* (Vf .> V0) + I_both .* (Vf .== max.(max.(Vb, Vf), V0))
    I0 = I_neither + (1 - I_neither) .* (V0 .== max.(max.(Vb, Vf), V0))
    I0 = 1 - Ib - If
    V = Vaf .* If + Vab .* Ib + Va0 .* I0

    return V, If, Ib, I0
end

# Constructs A matrix that applies to the HJB
# A_switch - summarizes all information due to non-wealth state variables, e.g. income shocks
function upwind_matrix{R<:Number, S<:Number, T<:Number}(A_switch::SparseMatrixCSC{R, Int64},
                                                        sf::Matrix{S}, sb::Matrix{S},
                                                        f_diff::Matrix{T}, b_diff::Matrix{T},
                                                        wealth_dim::Int, other_dims::Int;
                                                        exact::Bool = true,
                                                        If::Matrix{Int64} = Matrix{Int64}(0, 0),
                                                        Ib::Matrix{Int64} = Matrix{Int64}(0, 0),
                                                        I0::Matrix{Int64} = Matrix{Int64}(0, 0))
    if size(sf, 1) != wealth_dim
        error("Dimension of wealth grid, wealth_dim, is incorrect.")
    elseif size(f_diff) != size(sf) || size(b_diff) != size(sf)
        error("Dimension of diff, differenced state space grid, along the wealth dimension is wrong.")
    end

    # Compute diagonals of first-order differenced V matrix
    if exact
        # use min/max b/c assumes we set I0 entries to 1 only if sf/sb exactly zero
        X = -min.(sb, 0) ./ b_diff
        Y = -max.(sf, 0) ./ f_diff + min.(sb, 0) ./ b_diff
        Z = max.(sf, 0) ./ f_diff
    else
        X = -Ib .* sb ./ b_diff
        Y = -If .* sf ./ f_diff + Ib .* sb ./ b_diff
        Z = If .* sf ./ f_diff
    end

    total_dims = wealth_dim * other_dims
    centdiag = vec(Y)
    updiag = zeros(R, total_dims - 1)
    lowdiag = zeros(R, total_dims - 1)
    for j = 1:other_dims
        for i = 1:wealth_dim
            # When i == wealth_dim, leave entry as zero,
            # Also, this way, we don't save Z[end, end]
            # or X[1, 1]
            if i < wealth_dim
                updiag[wealth_dim * (j-1) + i] = Z[i, j]
                lowdiag[wealth_dim * (j-1) + i] = X[i + 1, j]
            end
        end
    end

     AA = spdiagm((lowdiag, centdiag, updiag), (-1, 0, 1))
    A = AA + A_switch
    return A
end
function upwind_matrix{R<:Number, S<:Number, T<:Number}(A_switch::SparseMatrixCSC{R, Int64},
                                                        sf::Matrix{S}, sb::Matrix{S},
                                                        diff::T, wealth_dim::Int, other_dims::Int;
                                                        exact::Bool = true,
                                                        If::Matrix{Int64} = Matrix{Int64}(0, 0),
                                                        Ib::Matrix{Int64} = Matrix{Int64}(0, 0),
                                                        I0::Matrix{Int64} = Matrix{Int64}(0, 0))
    if size(sf, 1) != wealth_dim
        error("Dimension of wealth grid is incorrect.")
    end

    # Compute diagonals of first-order differenced V matrix

    if exact
        # use min/max b/c assumes we set I0 entries to 1 only if sf/sb exactly zero
        X = -min.(sb, 0) / diff
        Y = -max.(sf, 0) / diff + min.(sb, 0) / diff
        Z = max.(sf, 0) / diff
    else
        # Need to multiply with Ib, If to be consistent with how we set the entries of I0
        X = -Ib .* sb ./ diff
        Y = -If .* sf ./ diff + Ib .* sb ./ diff
        Z = If .* sf ./ diff
    end
    total_dims = wealth_dim * other_dims
    centdiag = vec(Y)
    updiag = zeros(R, total_dims - 1)
    lowdiag = zeros(R, total_dims - 1)
    for j = 1:other_dims
        for i = 1:wealth_dim
            if i < wealth_dim
                updiag[wealth_dim * (j-1) + i] = Z[i, j]
                lowdiag[wealth_dim * (j-1) + i] = X[i + 1, j]
            end
        end
    end

    AA = spdiagm(centdiag, 0, total_dims, total_dims) +
        spdiagm(updiag, 1, total_dims, total_dims) +
        spdiagm(lowdiag, -1, total_dims, total_dims)

    A = AA + A_switch
    return A
end

# Solves hjb
function solve_hjb{R<:Number, S<:Number, T<:Number}(A::SparseMatrixCSC{R, Int64}, ρ::S,
                                            Δ_HJB::S, u::Matrix{T}, V::Matrix{T})
    # Stack u and V
    return solve_hjb(A, ρ, Δ_HJB, vec(u), vec(V))
end
function solve_hjb{R<:Number, S<:Number, T<:Number}(A::SparseMatrixCSC{R, Int64}, ρ::S,
                                            Δ_HJB::S, u::Vector{T}, V::Vector{T})
    B = (1/Δ_HJB + ρ) * speye(size(A, 1)) - A
    b = u + V / Δ_HJB
    return B \ b
end

# Wrapper function combining upwind_value_function and upwind_matrix
# since these do not require intermediate steps. However, b/c
# solve_hjb needs flow utility, which is model-specific,
# we do not wrap all of these steps into one function
function upwind{R<:Number, S<:Number, T<:Number}(A_switch::SparseMatrixCSC{R, Int64},
                                                 Vaf::Matrix{S}, Vab::Matrix{S}, Va0::Matrix{S},
                                                 Vf::Matrix{S}, Vb::Matrix{S}, V0::Matrix{S},
                                                 cf::Matrix{S}, cb::Matrix{S}, c0::Matrix{S},
                                                 sf::Matrix{S}, sb::Matrix{S},
                                                 f_diff::Matrix{T}, b_diff::Matrix{T},
                                                 wealth_dim::Int, other_dims::Int;
                                                 reverse_sign = -1e12, exact::Bool = true)
    if exact
        dV_upwind, If, Ib, I0 = upwind_value_function(Vaf, Vab, Va0, sf, sb)
        A = upwind_matrix(A_switch, sf, sb, f_diff, b_diff, wealth_dim, other_dims;
                      exact = exact)
    else
        dV_upwind, If, Ib, I0 = upwind_value_function(Vaf, Vab, Va0, Vf, Vb, V0, cf, cb, c0,
                                                  sf, sb; reverse_sign = reverse_sign)
        A = upwind_matrix(A_switch, sf, sb, f_diff, b_diff, wealth_dim, other_dims;
                      exact = exact, If = If, Ib = Ib, I0 = I0)
    end
    return dV_upwind, If, Ib, I0, A
end
function upwind{R<:Number, S<:Number, T<:Number}(A_switch::SparseMatrixCSC{R, Int64},
                                                 Vaf::Matrix{S}, Vab::Matrix{S}, Va0::Matrix{S},
                                                 sf::Matrix{S}, sb::Matrix{S},
                                                 f_diff::Matrix{T}, b_diff::Matrix{T},
                                                 wealth_dim::Int, other_dims::Int;
                                                 reverse_sign::Float64 = -1e12)
    dV_upwind, If, Ib, I0 = upwind_value_function(Vaf, Vab, Va0, sf, sb)
    A = upwind_matrix(A_switch, sf, sb, f_diff, b_diff, wealth_dim, other_dims;
                      exact = true)
    return dV_upwind, If, Ib, I0, A
end
function upwind{R<:Number, S<:Number, T<:Number}(A_switch::SparseMatrixCSC{R, Int64},
                                                 Vaf::Matrix{S}, Vab::Matrix{S}, Va0::Matrix{S},
                                                 Vf::Matrix{S}, Vb::Matrix{S}, V0::Matrix{S},
                                                 cf::Matrix{S}, cb::Matrix{S}, c0::Matrix{S},
                                                 sf::Matrix{S}, sb::Matrix{S},
                                                 diff::T, wealth_dim::Int, other_dims::Int;
                                                 reverse_sign = -1e12, exact::Bool = trie)
    if exact
        dV_upwind, If, Ib, I0 = upwind_value_function(Vaf, Vab, Va0, sf, sb)
        A = upwind_matrix(A_switch, sf, sb, diff, wealth_dim, other_dims;
                      exact = exact)
    else
        dV_upwind, If, Ib, I0 = upwind_value_function(Vaf, Vab, Va0, Vf, Vb, V0, cf, cb, c0,
                                                  sf, sb; reverse_sign = reverse_sign)
        A = upwind_matrix(A_switch, sf, sb, diff, wealth_dim, other_dims;
                          exact = exact, If = If, Ib = Ib, I0 = I0)
    end
    return dV_upwind, If, Ib, I0, A
end
function upwind{R<:Number, S<:Number, T<:Number}(A_switch::SparseMatrixCSC{R, Int64},
                                                 Vaf::Matrix{S}, Vab::Matrix{S}, Va0::Matrix{S},
                                                 sf::Matrix{S}, sb::Matrix{S},
                                                 diff::T, wealth_dim::Int, other_dims::Int;
                                                 reverse_sign::Float64 = -1e12)
    dV_upwind, If, Ib, I0 = upwind_value_function(Vaf, Vab, Va0, sf, sb)
    A = upwind_matrix(A_switch, sf, sb, diff, wealth_dim, other_dims;
                      exact = true)

    return dV_upwind, If, Ib, I0, A
end