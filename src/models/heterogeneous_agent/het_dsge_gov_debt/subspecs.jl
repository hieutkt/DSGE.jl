"""
`init_subspec!(m::HetDSGEGovDebt)`

Initializes a model subspecification by overwriting parameters from
the original model object with new parameter objects. This function is
called from within the model constructor.
"""
function init_subspec!(m::HetDSGEGovDebt)
    if subspec(m) == "ss0"
        return
    # All but g_shock
    elseif subspec(m) == "ss1"
        return ss1!(m)
    # All but b_shock
    elseif subspec(m) == "ss2"
        return ss2!(m)
    # All but μ shock
    elseif subspec(m) == "ss3"
        return ss3!(m)
    # All but z shock
    elseif subspec(m) == "ss4"
        return ss4!(m)
    # All but λ_f shock
    elseif subspec(m) == "ss5"
        return ss5!(m)
    # All but λ_w shock
    elseif subspec(m) == "ss6"
        return ss6!(m)
    # All but rm_shock
    elseif subspec(m) == "ss7"
        return ss7!(m)
    # All but steady state parameters
    elseif subspec(m) == "ss8"
        return ss8!(m)
    # Subspec 0, except r has higher prior mean
    elseif subspec(m) == "ss9"
        return ss9!(m)
    else
        error("This subspec should be a 0")
    end
end

"""
```
ss1!(m::HetDSGEGovDebt)
```

Initializes subspec 1 of `HetDSGEGovDebt`.
This shuts down all shocks except the government spending process (g shock).
"""
function ss1!(m::HetDSGEGovDebt)
    m <= parameter(:spp, 4., (-15., 15.), (-15., 15.), Untransformed(),
                   Normal(4., 1.5), fixed = true,
                   description = "S'': The second derivative of households' cost of adjusting investment.",
                   tex_label = "S''")
    m <= parameter(:ρR , 0.75, (1e-5, 0.999), (1e-5, 0.999), SquareRoot(),
                   BetaAlt(0.75, 0.10), fixed = true,
                   description = "ρ: The degree of inertia in the monetary policy rule.",
                   tex_label="\\rho_R")
    m <= parameter(:ψπ , 1.5, (1e-5, 10.), (1e-5, 10.0), Exponential(),
                   Normal(1.5, 0.25), fixed = true,
                   description = "ψ1: Weight on inflation gap in monetary policy rule.",
                   tex_label = "\\psi_1")

    m <= parameter(:ρ_G, 0.5, (1e-5, 1 - 1e-5), (1e-5, 1-1e-5), SquareRoot(),
                   BetaAlt(0.5, 0.2), fixed = true,
                   description = "ρ_g: AR(1) coefficient in the government spending process.",
                   tex_label = "\\rho_g")

    m <= parameter(:ρ_B, 0.0, (1e-5, 1 - 1e-5), (1e-5, 1-1e-5), SquareRoot(),
                   BetaAlt(0.5, 0.2), fixed = true,
                   description = "ρ_b: AR(1) coefficient in the intertemporal preference shifter process.",
                   tex_label = "\\rho_B")
    m <= parameter(:ρ_μ, 0.0, (1e-5, 1 - 1e-5), (1e-5, 1-1e-5), SquareRoot(),
                   BetaAlt(0.5, 0.2), fixed = true,
                   description = "ρ_μ: AR(1) coefficient in capital adjustment cost process.",
                   tex_label = "\\rho_{\\mu}")
    m <= parameter(:ρ_z, 0.0,(1e-5, 1 - 1e-5), (1e-5, 1-1e-5), SquareRoot(),
                   BetaAlt(0.5, 0.2), fixed = true,
                   description = "ρ_z: AR(1) coefficient in the technology process.",
                   tex_label = "\\rho_z")
    m <= parameter(:ρ_lamf, 0.0, (1e-5, 1 - 1e-5), (1e-5, 1-1e-5), SquareRoot(),
                   BetaAlt(0.5, 0.2), fixed = true,
                   description = "ρ_λ_f: AR(1) coefficient in the price mark-up shock process.",
                   tex_label = "\\rho_{\\lambda_f}")
    m <= parameter(:ρ_lamw, 0.0, (1e-5, 1 - 1e-5), (1e-5, 1-1e-5), SquareRoot(),
                   BetaAlt(0.5, 0.2), fixed = true,
                   description = "ρ_λ_w: AR(1) coefficient in the wage mark-up shock process.",
                   tex_label = "\\rho_{\\lambda_w}")
    m <= parameter(:ρ_mon, 0.0, (1e-5, 1 - 1e-5), (1e-5, 1-1e-5), SquareRoot(),
                   BetaAlt(0.5, 0.2), fixed = true,
                   description = "ρ_rm: AR(1) coefficient in the monetary policy shock process.",
                   tex_label = "\\rho_{r^m}")

    m <= parameter(:σ_b, 0.0, (1e-8, 5.), (1e-8, 5.), Exponential(),
                   RootInverseGamma(2, 0.10), fixed = true,
                   description = "σ_b: The standard deviation of the intertemporal preference shifter process.",
                   tex_label = "\\sigma_{b}")
    m <= parameter(:σ_μ, 0.0, (1e-8, 5.), (1e-8, 5.), Exponential(),
                   RootInverseGamma(2, 0.10), fixed = true,
                   description = "σ_μ: The standard deviation of the exogenous marginal efficiency of investment shock process.",
                   tex_label = "\\sigma_{\\mu}")
    m <= parameter(:σ_z, 0.0,(1e-8, 5.), (1e-8, 5.), Exponential(),
                   RootInverseGamma(2, 0.10), fixed = true,
                   description = "σ_z: The standard deviation of the process describing the stationary component of productivity.",
                   tex_label = "\\sigma_z")
    m <= parameter(:σ_λ_f, 0.0, (1e-8, 5.), (1e-8, 5.), Exponential(),
                   RootInverseGamma(2, 0.10), fixed = true,
                   description = "σ_λ_f: The mean of the process that generates the price elasticity of the composite good. Specifically, the elasticity is (1+λ_{f,t})/(λ_{f,t}).",
                   tex_label = "\\sigma_{\\lambda_f}")
    m <= parameter(:σ_λ_w, 0.0, (1e-8, 5.), (1e-8, 5.), Exponential(),
                   RootInverseGamma(2, 0.10), fixed = true,
                   description = "σ_λ_w",
                   tex_label = "\\sigma_{\\lambda_w}")
    m <= parameter(:σ_rm, 0.0, (1e-8, 5.), (1e-8, 5.), Exponential(),
                   RootInverseGamma(2, 0.10), fixed = true,
                   description = "σ_r_m: The standard deviation of the monetary policy shock.", tex_label = "\\sigma_{r^m}")

    m <= parameter(:π_star, 0.7000, (1e-5, 10.), (1e-5, 10.), Exponential(),
                GammaAlt(0.62, 0.1), fixed=true, scaling = x -> 1 + x/100,
                description="π_star: The steady-state rate of inflation.",
                tex_label="\\pi_*")

    m <= parameter(:Lmean, -45.9364, (-1000., 1000.), (-1e3, 1e3), Untransformed(),
                   Normal(-45., 5.), fixed=true,
                   description="Lmean: Mean level of hours.",
                   tex_label="\\bar{L}")

    m <= parameter(:κ_p, 0.5, (1e-5, 5.), (1e-5, 5.), SquareRoot(), GammaAlt(0.5, 0.3),
                 fixed = true, description = "κ_p : The slope of the Price Phillips curve",
                 tex_label = "\\kappa")

    m <= parameter(:κ_w, 0.5, (1e-5, 5.), (1e-5, 5.), SquareRoot(), GammaAlt(0.5, 0.3),
                   fixed = true, description = "κ_w: The slope of the Wage Phillips curve",
                   tex_label = "\\kappa")

    m <= parameter(:ψy , 0.5, (-0.5, 0.5), (-0.5, 0.5), Untransformed(),
                   Normal(0.12, 0.05), fixed = true,
                   description = "ψy: Weight on output growth in monetary policy rule")

    m <= parameter(:ϕh, 2., (1e-5, 10.), (1e-5, 10.), Exponential(),
                   Normal(2, 0.75), fixed = true, description = "inverse frisch elasticity",
                   tex_label = "\\phi_h")
end

"""
```
ss2!(m::HetDSGEGovDebt)
```

Initializes subspec 2 of `HetDSGEGovDebt`.
This shuts down all shocks except the preference shifter process (b shock).
"""
function ss2!(m::HetDSGEGovDebt)
    m <= parameter(:spp, 4., (-15., 15.), (-15., 15.), Untransformed(),
                   Normal(4., 1.5), fixed = true,
                   description = "S'': The second derivative of households' cost of adjusting investment.",
                   tex_label = "S''")
    m <= parameter(:ρR , 0.75, (1e-5, 0.999), (1e-5, 0.999), SquareRoot(),
                   BetaAlt(0.75, 0.10), fixed = true,
                   description = "ρ: The degree of inertia in the monetary policy rule.",
                   tex_label="\\rho_R")
    m <= parameter(:ψπ , 1.5, (1e-5, 10.), (1e-5, 10.0), Exponential(),
                   Normal(1.5, 0.25), fixed = true,
                   description = "ψ1: Weight on inflation gap in monetary policy rule.",
                   tex_label = "\\psi_1")

    m <= parameter(:ρ_G, 0.0, (1e-5, 1 - 1e-5), (1e-5, 1-1e-5), SquareRoot(),
                   BetaAlt(0.5, 0.2), fixed = true,
                   description = "ρ_g: AR(1) coefficient in the government spending process.",
                   tex_label = "\\rho_g")

    m <= parameter(:ρ_B, 0.5, (1e-5, 1 - 1e-5), (1e-5, 1-1e-5), SquareRoot(),
                   BetaAlt(0.5, 0.2), fixed = true,
                   description = "ρ_b: AR(1) coefficient in the government spending process.",
                   tex_label = "\\rho_b")

    m <= parameter(:ρ_μ, 0.0, (1e-5, 1 - 1e-5), (1e-5, 1-1e-5), SquareRoot(),
                   BetaAlt(0.5, 0.2), fixed = true,
                   description = "ρ_μ: AR(1) coefficient in capital adjustment cost process.",
                   tex_label = "\\rho_{\\mu}")
    m <= parameter(:ρ_z, 0.0,(1e-5, 1 - 1e-5), (1e-5, 1-1e-5), SquareRoot(),
                   BetaAlt(0.5, 0.2), fixed = true,
                   description = "ρ_z: AR(1) coefficient in the technology process.",
                   tex_label = "\\rho_z")
    m <= parameter(:ρ_lamf, 0.0, (1e-5, 1 - 1e-5), (1e-5, 1-1e-5), SquareRoot(),
                   BetaAlt(0.5, 0.2), fixed = true,
                   description = "ρ_λ_f: AR(1) coefficient in the price mark-up shock process.",
                   tex_label = "\\rho_{\\lambda_f}")
    m <= parameter(:ρ_lamw, 0.0, (1e-5, 1 - 1e-5), (1e-5, 1-1e-5), SquareRoot(),
                   BetaAlt(0.5, 0.2), fixed = true,
                   description = "ρ_λ_w: AR(1) coefficient in the wage mark-up shock process.",
                   tex_label = "\\rho_{\\lambda_w}")
    m <= parameter(:ρ_mon, 0.0, (1e-5, 1 - 1e-5), (1e-5, 1-1e-5), SquareRoot(),
                   BetaAlt(0.5, 0.2), fixed = true,
                   description = "ρ_rm: AR(1) coefficient in the monetary policy shock process.",
                   tex_label = "\\rho_{r^m}")

    m <= parameter(:σ_g, 0.0, (1e-8, 5.), (1e-8, 5.), Exponential(),
                   RootInverseGamma(2, 0.10), fixed = true,
                   description = "σ_g: The standard deviation of the government spending process.",
                   tex_label = "\\sigma_{g}")
    m <= parameter(:σ_μ, 0.0, (1e-8, 5.), (1e-8, 5.), Exponential(),
                   RootInverseGamma(2, 0.10), fixed = true,
                   description = "σ_μ: The standard deviation of the exogenous marginal efficiency of investment shock process.",
                   tex_label = "\\sigma_{\\mu}")
    m <= parameter(:σ_z, 0.0,(1e-8, 5.), (1e-8, 5.), Exponential(),
                   RootInverseGamma(2, 0.10), fixed = true,
                   description = "σ_z: The standard deviation of the process describing the stationary component of productivity.",
                   tex_label = "\\sigma_z")
    m <= parameter(:σ_λ_f, 0.0, (1e-8, 5.), (1e-8, 5.), Exponential(),
                   RootInverseGamma(2, 0.10), fixed = true,
                   description = "σ_λ_f: The mean of the process that generates the price elasticity of the composite good. Specifically, the elasticity is (1+λ_{f,t})/(λ_{f,t}).",
                   tex_label = "\\sigma_{\\lambda_f}")
    m <= parameter(:σ_λ_w, 0.0, (1e-8, 5.), (1e-8, 5.), Exponential(),
                   RootInverseGamma(2, 0.10), fixed = true,
                   description = "σ_λ_w",
                   tex_label = "\\sigma_{\\lambda_w}")
    m <= parameter(:σ_rm, 0.0, (1e-8, 5.), (1e-8, 5.), Exponential(),
                   RootInverseGamma(2, 0.10), fixed = true,
                   description = "σ_r_m: The standard deviation of the monetary policy shock.", tex_label = "\\sigma_{r^m}")

    m <= parameter(:π_star, 0.7000, (1e-5, 10.), (1e-5, 10.), Exponential(),
                GammaAlt(0.62, 0.1), fixed=true, scaling = x -> 1 + x/100,
                description="π_star: The steady-state rate of inflation.",
                tex_label="\\pi_*")

    m <= parameter(:Lmean, -45.9364, (-1000., 1000.), (-1e3, 1e3), Untransformed(),
                   Normal(-45., 5.), fixed=true,
                   description="Lmean: Mean level of hours.",
                   tex_label="\\bar{L}")

    m <= parameter(:κ_p, 0.5, (1e-5, 5.), (1e-5, 5.), SquareRoot(), GammaAlt(0.5, 0.3),
                 fixed = true, description = "κ_p : The slope of the Price Phillips curve",
                 tex_label = "\\kappa")

    m <= parameter(:κ_w, 0.5, (1e-5, 5.), (1e-5, 5.), SquareRoot(), GammaAlt(0.5, 0.3),
                   fixed = true, description = "κ_w: The slope of the Wage Phillips curve",
                   tex_label = "\\kappa")

    m <= parameter(:ψy , 0.5, (-0.5, 0.5), (-0.5, 0.5), Untransformed(),
                   Normal(0.12, 0.05), fixed = true,
                   description = "ψy: Weight on output growth in monetary policy rule")

    m <= parameter(:ϕh, 2., (1e-5, 10.), (1e-5, 10.), Exponential(),
                   Normal(2, 0.75), fixed = true, description = "inverse frisch elasticity",
                   tex_label = "\\phi_h")
end

"""
```
ss3!(m::HetDSGEGovDebt)
```

Initializes subspec 3 of `HetDSGEGovDebt`.
This shuts down all shocks except the capital adjustment cost process (μ shock).
"""
function ss3!(m::HetDSGEGovDebt)
    m <= parameter(:spp, 4., (-15., 15.), (-15., 15.), Untransformed(),
                   Normal(4., 1.5), fixed = true,
                   description = "S'': The second derivative of households' cost of adjusting investment.",
                   tex_label = "S''")
    m <= parameter(:ρR , 0.75, (1e-5, 0.999), (1e-5, 0.999), SquareRoot(),
                   BetaAlt(0.75, 0.10), fixed = true,
                   description = "ρ: The degree of inertia in the monetary policy rule.",
                   tex_label="\\rho_R")
    m <= parameter(:ψπ , 1.5, (1e-5, 10.), (1e-5, 10.0), Exponential(),
                   Normal(1.5, 0.25), fixed = true,
                   description = "ψ1: Weight on inflation gap in monetary policy rule.",
                   tex_label = "\\psi_1")

    m <= parameter(:ρ_G, 0.0, (1e-5, 1 - 1e-5), (1e-5, 1-1e-5), SquareRoot(),
                   BetaAlt(0.5, 0.2), fixed = true,
                   description = "ρ_g: AR(1) coefficient in the government spending process.",
                   tex_label = "\\rho_g")
    m <= parameter(:ρ_B, 0.0, (1e-5, 1 - 1e-5), (1e-5, 1-1e-5), SquareRoot(),
                   BetaAlt(0.5, 0.2), fixed = true,
                   description = "ρ_b: AR(1) coefficient in the intertemporal preference shifter process.",
                   tex_label = "\\rho_B")

    m <= parameter(:ρ_μ, 0.5, (1e-5, 1 - 1e-5), (1e-5, 1-1e-5), SquareRoot(),
                   BetaAlt(0.5, 0.2), fixed = true,
                   description = "ρ_μ: AR(1) coefficient in the government spending process.",
                   tex_label = "\\rho_\\mu")

    m <= parameter(:ρ_z, 0.0,(1e-5, 1 - 1e-5), (1e-5, 1-1e-5), SquareRoot(),
                   BetaAlt(0.5, 0.2), fixed = true,
                   description = "ρ_z: AR(1) coefficient in the technology process.",
                   tex_label = "\\rho_z")
    m <= parameter(:ρ_lamf, 0.0, (1e-5, 1 - 1e-5), (1e-5, 1-1e-5), SquareRoot(),
                   BetaAlt(0.5, 0.2), fixed = true,
                   description = "ρ_λ_f: AR(1) coefficient in the price mark-up shock process.",
                   tex_label = "\\rho_{\\lambda_f}")
    m <= parameter(:ρ_lamw, 0.0, (1e-5, 1 - 1e-5), (1e-5, 1-1e-5), SquareRoot(),
                   BetaAlt(0.5, 0.2), fixed = true,
                   description = "ρ_λ_w: AR(1) coefficient in the wage mark-up shock process.",
                   tex_label = "\\rho_{\\lambda_w}")
    m <= parameter(:ρ_mon, 0.0, (1e-5, 1 - 1e-5), (1e-5, 1-1e-5), SquareRoot(),
                   BetaAlt(0.5, 0.2), fixed = true,
                   description = "ρ_rm: AR(1) coefficient in the monetary policy shock process.",
                   tex_label = "\\rho_{r^m}")

    m <= parameter(:σ_g, 0.0, (1e-8, 5.), (1e-8, 5.), Exponential(),
                   RootInverseGamma(2, 0.10), fixed = true,
                   description = "σ_g: The standard deviation of the government spending process.",
                   tex_label = "\\sigma_{g}")
    m <= parameter(:σ_b, 0.0, (1e-8, 5.), (1e-8, 5.), Exponential(),
                   RootInverseGamma(2, 0.10), fixed = true,
                   description = "σ_b: The standard deviation of the intertemporal preference shifter process.",
                   tex_label = "\\sigma_{b}")
    m <= parameter(:σ_z, 0.0,(1e-8, 5.), (1e-8, 5.), Exponential(),
                   RootInverseGamma(2, 0.10), fixed = true,
                   description = "σ_z: The standard deviation of the process describing the stationary component of productivity.",
                   tex_label = "\\sigma_z")
    m <= parameter(:σ_λ_f, 0.0, (1e-8, 5.), (1e-8, 5.), Exponential(),
                   RootInverseGamma(2, 0.10), fixed = true,
                   description = "σ_λ_f: The mean of the process that generates the price elasticity of the composite good. Specifically, the elasticity is (1+λ_{f,t})/(λ_{f,t}).",
                   tex_label = "\\sigma_{\\lambda_f}")
    m <= parameter(:σ_λ_w, 0.0, (1e-8, 5.), (1e-8, 5.), Exponential(),
                   RootInverseGamma(2, 0.10), fixed = true,
                   description = "σ_λ_w",
                   tex_label = "\\sigma_{\\lambda_w}")
    m <= parameter(:σ_rm, 0.0, (1e-8, 5.), (1e-8, 5.), Exponential(),
                   RootInverseGamma(2, 0.10), fixed = true,
                   description = "σ_r_m: The standard deviation of the monetary policy shock.", tex_label = "\\sigma_{r^m}")

    m <= parameter(:π_star, 0.7000, (1e-5, 10.), (1e-5, 10.), Exponential(),
                GammaAlt(0.62, 0.1), fixed=true, scaling = x -> 1 + x/100,
                description="π_star: The steady-state rate of inflation.",
                tex_label="\\pi_*")

    m <= parameter(:Lmean, -45.9364, (-1000., 1000.), (-1e3, 1e3), Untransformed(),
                   Normal(-45., 5.), fixed=true,
                   description="Lmean: Mean level of hours.",
                   tex_label="\\bar{L}")

    m <= parameter(:κ_p, 0.5, (1e-5, 5.), (1e-5, 5.), SquareRoot(), GammaAlt(0.5, 0.3),
                 fixed = true, description = "κ_p : The slope of the Price Phillips curve",
                 tex_label = "\\kappa")

    m <= parameter(:κ_w, 0.5, (1e-5, 5.), (1e-5, 5.), SquareRoot(), GammaAlt(0.5, 0.3),
                   fixed = true, description = "κ_w: The slope of the Wage Phillips curve",
                   tex_label = "\\kappa")

    m <= parameter(:ψy , 0.5, (-0.5, 0.5), (-0.5, 0.5), Untransformed(),
                   Normal(0.12, 0.05), fixed = true,
                   description = "ψy: Weight on output growth in monetary policy rule")

    m <= parameter(:ϕh, 2., (1e-5, 10.), (1e-5, 10.), Exponential(),
                   Normal(2, 0.75), fixed = true, description = "inverse frisch elasticity",
                   tex_label = "\\phi_h")
end

"""
```
ss4(m::HetDSGEGovDebt)
```

Initializes subspec 4 of `HetDSGEGovDebt`.
This shuts down all shocks except the technology process (z shock).
"""
function ss4!(m::HetDSGEGovDebt)
    m <= parameter(:spp, 4., (-15., 15.), (-15., 15.), Untransformed(),
                   Normal(4., 1.5), fixed = true,
                   description = "S'': The second derivative of households' cost of adjusting investment.",
                   tex_label = "S''")
    m <= parameter(:ρR , 0.75, (1e-5, 0.999), (1e-5, 0.999), SquareRoot(),
                   BetaAlt(0.75, 0.10), fixed = true,
                   description = "ρ: The degree of inertia in the monetary policy rule.",
                   tex_label="\\rho_R")
    m <= parameter(:ψπ , 1.5, (1e-5, 10.), (1e-5, 10.0), Exponential(),
                   Normal(1.5, 0.25), fixed = true,
                   description = "ψ1: Weight on inflation gap in monetary policy rule.",
                   tex_label = "\\psi_1")

    m <= parameter(:ρ_G, 0.0, (1e-5, 1 - 1e-5), (1e-5, 1-1e-5), SquareRoot(),
                   BetaAlt(0.5, 0.2), fixed = true,
                   description = "ρ_g: AR(1) coefficient in the government spending process.",
                   tex_label = "\\rho_g")
    m <= parameter(:ρ_B, 0.0, (1e-5, 1 - 1e-5), (1e-5, 1-1e-5), SquareRoot(),
                   BetaAlt(0.5, 0.2), fixed = true,
                   description = "ρ_b: AR(1) coefficient in the intertemporal preference shifter process.",
                   tex_label = "\\rho_B")
    m <= parameter(:ρ_μ, 0.0, (1e-5, 1 - 1e-5), (1e-5, 1-1e-5), SquareRoot(),
                   BetaAlt(0.5, 0.2), fixed = true,
                   description = "ρ_μ: AR(1) coefficient in capital adjustment cost process.",
                   tex_label = "\\rho_{\\mu}")

    m <= parameter(:ρ_z, 0.5, (1e-5, 1 - 1e-5), (1e-5, 1-1e-5), SquareRoot(),
                   BetaAlt(0.5, 0.2), fixed = true,
                   description = "ρ_z: AR(1) coefficient in the government spending process.",
                   tex_label = "\\rho_z")

    m <= parameter(:ρ_lamf, 0.0, (1e-5, 1 - 1e-5), (1e-5, 1-1e-5), SquareRoot(),
                   BetaAlt(0.5, 0.2), fixed = true,
                   description = "ρ_λ_f: AR(1) coefficient in the price mark-up shock process.",
                   tex_label = "\\rho_{\\lambda_f}")
    m <= parameter(:ρ_lamw, 0.0, (1e-5, 1 - 1e-5), (1e-5, 1-1e-5), SquareRoot(),
                   BetaAlt(0.5, 0.2), fixed = true,
                   description = "ρ_λ_w: AR(1) coefficient in the wage mark-up shock process.",
                   tex_label = "\\rho_{\\lambda_w}")
    m <= parameter(:ρ_mon, 0.0, (1e-5, 1 - 1e-5), (1e-5, 1-1e-5), SquareRoot(),
                   BetaAlt(0.5, 0.2), fixed = true,
                   description = "ρ_rm: AR(1) coefficient in the monetary policy shock process.",
                   tex_label = "\\rho_{r^m}")

    m <= parameter(:σ_g, 0.0, (1e-8, 5.), (1e-8, 5.), Exponential(),
                   RootInverseGamma(2, 0.10), fixed = true,
                   description = "σ_g: The standard deviation of the government spending process.",
                   tex_label = "\\sigma_{g}")
    m <= parameter(:σ_b, 0.0, (1e-8, 5.), (1e-8, 5.), Exponential(),
                   RootInverseGamma(2, 0.10), fixed = true,
                   description = "σ_b: The standard deviation of the intertemporal preference shifter process.",
                   tex_label = "\\sigma_{b}")
    m <= parameter(:σ_μ, 0.0, (1e-8, 5.), (1e-8, 5.), Exponential(),
                   RootInverseGamma(2, 0.10), fixed = true,
                   description = "σ_μ: The standard deviation of the exogenous marginal efficiency of investment shock process.",
                   tex_label = "\\sigma_{\\mu}")
    m <= parameter(:σ_λ_f, 0.0, (1e-8, 5.), (1e-8, 5.), Exponential(),
                   RootInverseGamma(2, 0.10), fixed = true,
                   description = "σ_λ_f: The mean of the process that generates the price elasticity of the composite good. Specifically, the elasticity is (1+λ_{f,t})/(λ_{f,t}).",
                   tex_label = "\\sigma_{\\lambda_f}")
    m <= parameter(:σ_λ_w, 0.0, (1e-8, 5.), (1e-8, 5.), Exponential(),
                   RootInverseGamma(2, 0.10), fixed = true,
                   description = "σ_λ_w",
                   tex_label = "\\sigma_{\\lambda_w}")
    m <= parameter(:σ_rm, 0.0, (1e-8, 5.), (1e-8, 5.), Exponential(),
                   RootInverseGamma(2, 0.10), fixed = true,
                   description = "σ_r_m: The standard deviation of the monetary policy shock.", tex_label = "\\sigma_{r^m}")

    m <= parameter(:π_star, 0.7000, (1e-5, 10.), (1e-5, 10.), Exponential(),
                GammaAlt(0.62, 0.1), fixed=true, scaling = x -> 1 + x/100,
                description="π_star: The steady-state rate of inflation.",
                tex_label="\\pi_*")

    m <= parameter(:Lmean, -45.9364, (-1000., 1000.), (-1e3, 1e3), Untransformed(),
                   Normal(-45., 5.), fixed=true,
                   description="Lmean: Mean level of hours.",
                   tex_label="\\bar{L}")

    m <= parameter(:κ_p, 0.5, (1e-5, 5.), (1e-5, 5.), SquareRoot(), GammaAlt(0.5, 0.3),
                 fixed = true, description = "κ_p : The slope of the Price Phillips curve",
                 tex_label = "\\kappa")

    m <= parameter(:κ_w, 0.5, (1e-5, 5.), (1e-5, 5.), SquareRoot(), GammaAlt(0.5, 0.3),
                   fixed = true, description = "κ_w: The slope of the Wage Phillips curve",
                   tex_label = "\\kappa")

    m <= parameter(:ψy , 0.5, (-0.5, 0.5), (-0.5, 0.5), Untransformed(),
                   Normal(0.12, 0.05), fixed = true,
                   description = "ψy: Weight on output growth in monetary policy rule")

    m <= parameter(:ϕh, 2., (1e-5, 10.), (1e-5, 10.), Exponential(),
                   Normal(2, 0.75), fixed = true, description = "inverse frisch elasticity",
                   tex_label = "\\phi_h")

end

"""
```
ss5!(m::HetDSGEGovDebt)
```

Initializes subspec 5 of `HetDSGEGovDebt`.
This shuts down all shocks except the price mark-up shock process (λ_f shock).
"""
function ss5!(m::HetDSGEGovDebt)
    m <= parameter(:spp, 4., (-15., 15.), (-15., 15.), Untransformed(),
                   Normal(4., 1.5), fixed = true,
                   description = "S'': The second derivative of households' cost of adjusting investment.",
                   tex_label = "S''")
    m <= parameter(:ρR , 0.75, (1e-5, 0.999), (1e-5, 0.999), SquareRoot(),
                   BetaAlt(0.75, 0.10), fixed = true,
                   description = "ρ: The degree of inertia in the monetary policy rule.",
                   tex_label="\\rho_R")
    m <= parameter(:ψπ , 1.5, (1e-5, 10.), (1e-5, 10.0), Exponential(),
                   Normal(1.5, 0.25), fixed = true,
                   description = "ψ1: Weight on inflation gap in monetary policy rule.",
                   tex_label = "\\psi_1")

    m <= parameter(:ρ_G, 0.0, (1e-5, 1 - 1e-5), (1e-5, 1-1e-5), SquareRoot(),
                   BetaAlt(0.5, 0.2), fixed = true,
                   description = "ρ_g: AR(1) coefficient in the government spending process.",
                   tex_label = "\\rho_g")
    m <= parameter(:ρ_B, 0.0, (1e-5, 1 - 1e-5), (1e-5, 1-1e-5), SquareRoot(),
                   BetaAlt(0.5, 0.2), fixed = true,
                   description = "ρ_b: AR(1) coefficient in the intertemporal preference shifter process.",
                   tex_label = "\\rho_B")
    m <= parameter(:ρ_μ, 0.0, (1e-5, 1 - 1e-5), (1e-5, 1-1e-5), SquareRoot(),
                   BetaAlt(0.5, 0.2), fixed = true,
                   description = "ρ_μ: AR(1) coefficient in capital adjustment cost process.",
                   tex_label = "\\rho_{\\mu}")
    m <= parameter(:ρ_z, 0.0,(1e-5, 1 - 1e-5), (1e-5, 1-1e-5), SquareRoot(),
                   BetaAlt(0.5, 0.2), fixed = true,
                   description = "ρ_z: AR(1) coefficient in the technology process.",
                   tex_label = "\\rho_z")

    m <= parameter(:ρ_lamf, 0.5, (1e-5, 1 - 1e-5), (1e-5, 1-1e-5), SquareRoot(),
                   BetaAlt(0.5, 0.2), fixed = true,
                   description = "ρ_lamf: AR(1) coefficient in the government spending process.",
                   tex_label = "\\rho_{\\lambda_f}")

    m <= parameter(:ρ_lamw, 0.0, (1e-5, 1 - 1e-5), (1e-5, 1-1e-5), SquareRoot(),
                   BetaAlt(0.5, 0.2), fixed = true,
                   description = "ρ_λ_w: AR(1) coefficient in the wage mark-up shock process.",
                   tex_label = "\\rho_{\\lambda_w}")
    m <= parameter(:ρ_mon, 0.0, (1e-5, 1 - 1e-5), (1e-5, 1-1e-5), SquareRoot(),
                   BetaAlt(0.5, 0.2), fixed = true,
                   description = "ρ_rm: AR(1) coefficient in the monetary policy shock process.",
                   tex_label = "\\rho_{r^m}")

    m <= parameter(:σ_g, 0.0, (1e-8, 5.), (1e-8, 5.), Exponential(),
                   RootInverseGamma(2, 0.10), fixed = true,
                   description = "σ_g: The standard deviation of the government spending process.",
                   tex_label = "\\sigma_{g}")
    m <= parameter(:σ_b, 0.0, (1e-8, 5.), (1e-8, 5.), Exponential(),
                   RootInverseGamma(2, 0.10), fixed = true,
                   description = "σ_b: The standard deviation of the intertemporal preference shifter process.",
                   tex_label = "\\sigma_{b}")
    m <= parameter(:σ_μ, 0.0, (1e-8, 5.), (1e-8, 5.), Exponential(),
                   RootInverseGamma(2, 0.10), fixed = true,
                   description = "σ_μ: The standard deviation of the exogenous marginal efficiency of investment shock process.",
                   tex_label = "\\sigma_{\\mu}")
    m <= parameter(:σ_z, 0.0,(1e-8, 5.), (1e-8, 5.), Exponential(),
                   RootInverseGamma(2, 0.10), fixed = true,
                   description = "σ_z: The standard deviation of the process describing the stationary component of productivity.",
                   tex_label = "\\sigma_z")
    m <= parameter(:σ_λ_w, 0.0, (1e-8, 5.), (1e-8, 5.), Exponential(),
                   RootInverseGamma(2, 0.10), fixed = true,
                   description = "σ_λ_w",
                   tex_label = "\\sigma_{\\lambda_w}")
    m <= parameter(:σ_rm, 0.0, (1e-8, 5.), (1e-8, 5.), Exponential(),
                   RootInverseGamma(2, 0.10), fixed = true,
                   description = "σ_r_m: The standard deviation of the monetary policy shock.", tex_label = "\\sigma_{r^m}")

    m <= parameter(:π_star, 0.7000, (1e-5, 10.), (1e-5, 10.), Exponential(),
                GammaAlt(0.62, 0.1), fixed=true, scaling = x -> 1 + x/100,
                description="π_star: The steady-state rate of inflation.",
                tex_label="\\pi_*")

    m <= parameter(:Lmean, -45.9364, (-1000., 1000.), (-1e3, 1e3), Untransformed(),
                   Normal(-45., 5.), fixed=true,
                   description="Lmean: Mean level of hours.",
                   tex_label="\\bar{L}")

    m <= parameter(:κ_p, 0.5, (1e-5, 5.), (1e-5, 5.), SquareRoot(), GammaAlt(0.5, 0.3),
                 fixed = true, description = "κ_p : The slope of the Price Phillips curve",
                 tex_label = "\\kappa")

    m <= parameter(:κ_w, 0.5, (1e-5, 5.), (1e-5, 5.), SquareRoot(), GammaAlt(0.5, 0.3),
                   fixed = true, description = "κ_w: The slope of the Wage Phillips curve",
                   tex_label = "\\kappa")

    m <= parameter(:ψy , 0.5, (-0.5, 0.5), (-0.5, 0.5), Untransformed(),
                   Normal(0.12, 0.05), fixed = true,
                   description = "ψy: Weight on output growth in monetary policy rule")

    m <= parameter(:ϕh, 2., (1e-5, 10.), (1e-5, 10.), Exponential(),
                   Normal(2, 0.75), fixed = true, description = "inverse frisch elasticity",
                   tex_label = "\\phi_h")

end

"""
```
ss6!(m::HetDSGEGovDebt)
```

Initializes subspec 6 of `HetDSGEGovDebt`.
This shuts down all shocks except the wage mark-up shock process (λ_w shock).
"""
function ss6!(m::HetDSGEGovDebt)
    m <= parameter(:spp, 4., (-15., 15.), (-15., 15.), Untransformed(),
                   Normal(4., 1.5), fixed = true,
                   description = "S'': The second derivative of households' cost of adjusting investment.",
                   tex_label = "S''")
    m <= parameter(:ρR , 0.75, (1e-5, 0.999), (1e-5, 0.999), SquareRoot(),
                   BetaAlt(0.75, 0.10), fixed = true,
                   description = "ρ: The degree of inertia in the monetary policy rule.",
                   tex_label="\\rho_R")
    m <= parameter(:ψπ , 1.5, (1e-5, 10.), (1e-5, 10.0), Exponential(),
                   Normal(1.5, 0.25), fixed = true,
                   description = "ψ1: Weight on inflation gap in monetary policy rule.",
                   tex_label = "\\psi_1")

    m <= parameter(:ρ_G, 0.0, (1e-5, 1 - 1e-5), (1e-5, 1-1e-5), SquareRoot(),
                   BetaAlt(0.5, 0.2), fixed = true,
                   description = "ρ_g: AR(1) coefficient in the government spending process.",
                   tex_label = "\\rho_g")
    m <= parameter(:ρ_B, 0.0, (1e-5, 1 - 1e-5), (1e-5, 1-1e-5), SquareRoot(),
                   BetaAlt(0.5, 0.2), fixed = true,
                   description = "ρ_b: AR(1) coefficient in the intertemporal preference shifter process.",
                   tex_label = "\\rho_B")
    m <= parameter(:ρ_μ, 0.0, (1e-5, 1 - 1e-5), (1e-5, 1-1e-5), SquareRoot(),
                   BetaAlt(0.5, 0.2), fixed = true,
                   description = "ρ_μ: AR(1) coefficient in capital adjustment cost process.",
                   tex_label = "\\rho_{\\mu}")
    m <= parameter(:ρ_z, 0.0,(1e-5, 1 - 1e-5), (1e-5, 1-1e-5), SquareRoot(),
                   BetaAlt(0.5, 0.2), fixed = true,
                   description = "ρ_z: AR(1) coefficient in the technology process.",
                   tex_label = "\\rho_z")
    m <= parameter(:ρ_lamf, 0.0, (1e-5, 1 - 1e-5), (1e-5, 1-1e-5), SquareRoot(),
                   BetaAlt(0.5, 0.2), fixed = true,
                   description = "ρ_λ_f: AR(1) coefficient in the price mark-up shock process.",
                   tex_label = "\\rho_{\\lambda_f}")
    m <= parameter(:ρ_lamw, 0.0, (1e-5, 1 - 1e-5), (1e-5, 1-1e-5), SquareRoot(),
                   BetaAlt(0.5, 0.2), fixed = true,
                   description = "ρ_λ_w: AR(1) coefficient in the price mark-up shock process.",
                   tex_label = "\\rho_{\\lambda_w}")

    m <= parameter(:ρ_mon, 0.0, (1e-5, 1 - 1e-5), (1e-5, 1-1e-5), SquareRoot(),
                   BetaAlt(0.5, 0.2), fixed = true,
                   description = "ρ_rm: AR(1) coefficient in the monetary policy shock process.",
                   tex_label = "\\rho_{r^m}")

    m <= parameter(:σ_g, 0.0, (1e-8, 5.), (1e-8, 5.), Exponential(),
                   RootInverseGamma(2, 0.10), fixed = true,
                   description = "σ_g: The standard deviation of the government spending process.",
                   tex_label = "\\sigma_{g}")
    m <= parameter(:σ_b, 0.0, (1e-8, 5.), (1e-8, 5.), Exponential(),
                   RootInverseGamma(2, 0.10), fixed = true,
                   description = "σ_b: The standard deviation of the intertemporal preference shifter process.",
                   tex_label = "\\sigma_{b}")
    m <= parameter(:σ_μ, 0.0, (1e-8, 5.), (1e-8, 5.), Exponential(),
                   RootInverseGamma(2, 0.10), fixed = true,
                   description = "σ_μ: The standard deviation of the exogenous marginal efficiency of investment shock process.",
                   tex_label = "\\sigma_{\\mu}")
    m <= parameter(:σ_z, 0.0,(1e-8, 5.), (1e-8, 5.), Exponential(),
                   RootInverseGamma(2, 0.10), fixed = true,
                   description = "σ_z: The standard deviation of the process describing the stationary component of productivity.",
                   tex_label = "\\sigma_z")
    m <= parameter(:σ_λ_f, 0.0, (1e-8, 5.), (1e-8, 5.), Exponential(),
                   RootInverseGamma(2, 0.10), fixed = true,
                   description = "σ_λ_f: The mean of the process that generates the price elasticity of the composite good. Specifically, the elasticity is (1+λ_{f,t})/(λ_{f,t}).",
                   tex_label = "\\sigma_{\\lambda_f}")
    m <= parameter(:σ_rm, 0.0, (1e-8, 5.), (1e-8, 5.), Exponential(),
                   RootInverseGamma(2, 0.10), fixed = true,
                   description = "σ_r_m: The standard deviation of the monetary policy shock.", tex_label = "\\sigma_{r^m}")

    m <= parameter(:π_star, 0.7000, (1e-5, 10.), (1e-5, 10.), Exponential(),
                GammaAlt(0.62, 0.1), fixed=true, scaling = x -> 1 + x/100,
                description="π_star: The steady-state rate of inflation.",
                tex_label="\\pi_*")

    m <= parameter(:Lmean, -45.9364, (-1000., 1000.), (-1e3, 1e3), Untransformed(),
                   Normal(-45., 5.), fixed=true,
                   description="Lmean: Mean level of hours.",
                   tex_label="\\bar{L}")

    m <= parameter(:κ_p, 0.5, (1e-5, 5.), (1e-5, 5.), SquareRoot(), GammaAlt(0.5, 0.3),
                 fixed = true, description = "κ_p : The slope of the Price Phillips curve",
                 tex_label = "\\kappa")

    m <= parameter(:κ_w, 0.5, (1e-5, 5.), (1e-5, 5.), SquareRoot(), GammaAlt(0.5, 0.3),
                   fixed = true, description = "κ_w: The slope of the Wage Phillips curve",
                   tex_label = "\\kappa")

    m <= parameter(:ψy , 0.5, (-0.5, 0.5), (-0.5, 0.5), Untransformed(),
                   Normal(0.12, 0.05), fixed = true,
                   description = "ψy: Weight on output growth in monetary policy rule")

    m <= parameter(:ϕh, 2., (1e-5, 10.), (1e-5, 10.), Exponential(),
                   Normal(2, 0.75), fixed = true, description = "inverse frisch elasticity",
                   tex_label = "\\phi_h")


end

"""
```
ss7!(m::HetDSGEGovDebt)
```

Initializes subspec 7 of `HetDSGEGovDebt`.
This shuts down all shocks except the monetary policy shock process (rm shock).
"""
function ss7!(m::HetDSGEGovDebt)
    m <= parameter(:spp, 4., (-15., 15.), (-15., 15.), Untransformed(),
                   Normal(4., 1.5), fixed = true,
                   description = "S'': The second derivative of households' cost of adjusting investment.",
                   tex_label = "S''")
    m <= parameter(:ρR , 0.75, (1e-5, 0.999), (1e-5, 0.999), SquareRoot(),
                   BetaAlt(0.75, 0.10), fixed = true,
                   description = "ρ: The degree of inertia in the monetary policy rule.",
                   tex_label="\\rho_R")
    m <= parameter(:ψπ , 1.5, (1e-5, 10.), (1e-5, 10.0), Exponential(),
                   Normal(1.5, 0.25), fixed = true,
                   description = "ψ1: Weight on inflation gap in monetary policy rule.",
                   tex_label = "\\psi_1")

    m <= parameter(:ρ_G, 0.0, (1e-5, 1 - 1e-5), (1e-5, 1-1e-5), SquareRoot(),
                   BetaAlt(0.5, 0.2), fixed = true,
                   description = "ρ_g: AR(1) coefficient in the government spending process.",
                   tex_label = "\\rho_g")
    m <= parameter(:ρ_B, 0.0, (1e-5, 1 - 1e-5), (1e-5, 1-1e-5), SquareRoot(),
                   BetaAlt(0.5, 0.2), fixed = true,
                   description = "ρ_b: AR(1) coefficient in the intertemporal preference shifter process.",
                   tex_label = "\\rho_B")
    m <= parameter(:ρ_μ, 0.0, (1e-5, 1 - 1e-5), (1e-5, 1-1e-5), SquareRoot(),
                   BetaAlt(0.5, 0.2), fixed = true,
                   description = "ρ_μ: AR(1) coefficient in capital adjustment cost process.",
                   tex_label = "\\rho_{\\mu}")
    m <= parameter(:ρ_z, 0.0,(1e-5, 1 - 1e-5), (1e-5, 1-1e-5), SquareRoot(),
                   BetaAlt(0.5, 0.2), fixed = true,
                   description = "ρ_z: AR(1) coefficient in the technology process.",
                   tex_label = "\\rho_z")
    m <= parameter(:ρ_lamf, 0.0, (1e-5, 1 - 1e-5), (1e-5, 1-1e-5), SquareRoot(),
                   BetaAlt(0.5, 0.2), fixed = true,
                   description = "ρ_λ_f: AR(1) coefficient in the price mark-up shock process.",
                   tex_label = "\\rho_{\\lambda_f}")
    m <= parameter(:ρ_lamw, 0.0, (1e-5, 1 - 1e-5), (1e-5, 1-1e-5), SquareRoot(),
                   BetaAlt(0.5, 0.2), fixed = true,
                   description = "ρ_λ_w: AR(1) coefficient in the wage mark-up shock process.",
                   tex_label = "\\rho_{\\lambda_w}")

    m <= parameter(:ρ_mon, 0.5, (1e-5, 1 - 1e-5), (1e-5, 1-1e-5), SquareRoot(),
                   BetaAlt(0.5, 0.2), fixed = true,
                   description = "ρ_rm: AR(1) coefficient in the monetary policy shock process.",
                   tex_label = "\\rho_{r^m}")

    m <= parameter(:σ_g, 0.0, (1e-8, 5.), (1e-8, 5.), Exponential(),
                   RootInverseGamma(2, 0.10), fixed = true,
                   description = "σ_g: The standard deviation of the government spending process.",
                   tex_label = "\\sigma_{g}")
    m <= parameter(:σ_b, 0.0, (1e-8, 5.), (1e-8, 5.), Exponential(),
                   RootInverseGamma(2, 0.10), fixed = true,
                   description = "σ_b: The standard deviation of the intertemporal preference shifter process.",
                   tex_label = "\\sigma_{b}")
    m <= parameter(:σ_μ, 0.0, (1e-8, 5.), (1e-8, 5.), Exponential(),
                   RootInverseGamma(2, 0.10), fixed = true,
                   description = "σ_μ: The standard deviation of the exogenous marginal efficiency of investment shock process.",
                   tex_label = "\\sigma_{\\mu}")
    m <= parameter(:σ_z, 0.0,(1e-8, 5.), (1e-8, 5.), Exponential(),
                   RootInverseGamma(2, 0.10), fixed = true,
                   description = "σ_z: The standard deviation of the process describing the stationary component of productivity.",
                   tex_label = "\\sigma_z")
    m <= parameter(:σ_λ_f, 0.0, (1e-8, 5.), (1e-8, 5.), Exponential(),
                   RootInverseGamma(2, 0.10), fixed = true,
                   description = "σ_λ_f: The mean of the process that generates the price elasticity of the composite good. Specifically, the elasticity is (1+λ_{f,t})/(λ_{f,t}).",
                   tex_label = "\\sigma_{\\lambda_f}")
    m <= parameter(:σ_λ_w, 0.0, (1e-8, 5.), (1e-8, 5.), Exponential(),
                   RootInverseGamma(2, 0.10), fixed = true,
                   description = "σ_λ_w",
                   tex_label = "\\sigma_{\\lambda_w}")

    m <= parameter(:π_star, 0.7000, (1e-5, 10.), (1e-5, 10.), Exponential(),
                GammaAlt(0.62, 0.1), fixed=true, scaling = x -> 1 + x/100,
                description="π_star: The steady-state rate of inflation.",
                tex_label="\\pi_*")

    m <= parameter(:Lmean, -45.9364, (-1000., 1000.), (-1e3, 1e3), Untransformed(),
                   Normal(-45., 5.), fixed=true,
                   description="Lmean: Mean level of hours.",
                   tex_label="\\bar{L}")
    m <= parameter(:κ_p, 0.5, (1e-5, 5.), (1e-5, 5.), SquareRoot(), GammaAlt(0.5, 0.3),
                 fixed = true, description = "κ_p : The slope of the Price Phillips curve",
                 tex_label = "\\kappa")

    m <= parameter(:κ_w, 0.5, (1e-5, 5.), (1e-5, 5.), SquareRoot(), GammaAlt(0.5, 0.3),
                   fixed = true, description = "κ_w: The slope of the Wage Phillips curve",
                   tex_label = "\\kappa")

    m <= parameter(:ψy , 0.5, (-0.5, 0.5), (-0.5, 0.5), Untransformed(),
                   Normal(0.12, 0.05), fixed = true,
                   description = "ψy: Weight on output growth in monetary policy rule")

    m <= parameter(:ϕh, 2., (1e-5, 10.), (1e-5, 10.), Exponential(),
                   Normal(2, 0.75), fixed = true, description = "inverse frisch elasticity",
                   tex_label = "\\phi_h")
end

"""
```
ss8!(m::HetDSGEGovDebt)
```

Initializes subspec 8 of `HetDSGEGovDebt`.
Estimates all non-steadystate parameters.
Right now it's empty becaus we do this by default
"""
function ss8!(m::HetDSGEGovDebt)
    m <= parameter(:r, 0.6, (1e-5, 10.0), (1e-5, 10.), Exponential(),
                   GammaAlt(0.25, .1), fixed = true, scaling = x -> x/100 + .4/100,
                   description="r: Quarterly steady-state real interest rate.",
                   tex_label="100*(r^{HetDSGE}-\\gamma^{FRBNY})")

    m <= parameter(:α, 0.3, fixed = true, (1e-5, 0.999), (1e-5, 0.999), SquareRoot(),
                   Normal(0.30, 0.05),
                   description = "α: Capital elasticity in the intermediate goods sector's production function (also known as the capital share).",
                   tex_label = "\\alpha")

    m <= parameter(:pLH, 0.01125, (0.005, 0.055), (0.005, 0.055), Untransformed(),
                   Uniform(0.005, 0.055), fixed = true, description = "Prob of going from low to high persistent skill",
                   tex_label = "p(s_L \\mid s_H)")
    m <= parameter(:pHL, 0.03, (0.005, 0.055), (0.005, 0.055), Untransformed(),
                   Uniform(0.005, 0.055), fixed = true, description = "Prob of going from high to low persistent skill",
                   tex_label = "p(s_H \\mid s_L)")

end

"""
```
ss9!(m::HetDSGEGovDebt)
```

Initializes subspec 9 of `HetDSGEGovDebt`.
Is subspec 0 except with higher prior mean on r.
"""
function ss9!(m::HetDSGEGovDebt)
    m <= parameter(:r, 0.6, (1e-5, 10.0), (1e-5, 10.), Exponential(),
                   GammaAlt(0.6, .1), fixed = true, scaling = x -> x/100 + .4/100,
                   description="r: Quarterly steady-state real interest rate.",
                   tex_label="100*(r^{HetDSGE}-\\gamma^{FRBNY})")
end
