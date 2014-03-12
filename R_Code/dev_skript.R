
sim_generate(new("smstp_fe", nDomains = 2, nUnits = c(3, 5), 
                 generator = gen_fe_norm(), slope = 1, const = 2))

library(saeSim)
sim(sim_base_standard(nDomains=3, nUnits = 4), 
    # Fixed-Effects: drawn from N(50, 20^2), b0 = 0, slope = 10
    sim_fe(generator = gen_fe_norm(mean=50, sd=20), const=0, slope = 10), 
    # Model-Error: e ~ N(0, 1)
    sim_re(generator=gen_e_norm(0, 1)),
    # Random-Intercept: v ~ N(0, 1)
    sim_re(gen_v_norm(0, 1)),
    # Correlated random-effect following a SAR(1)
    sim_re(gen_v_sar(mean=0, sp_sd=2, rho=0.5, type="rook")),
    # Adding outliers in each error-component:
    # 5% in each area,at least 1, those with highest ID:
    sim_rec(gen_e_norm(sd = 150), nCont=0.05, level="unit", fixed=TRUE),
    # 5% of the areas, at least 1, those with highest ID
    sim_rec(gen_v_norm(sd = 50), nCont=0.05, level="area", fixed=TRUE),
    # 2 Areas, randomly chosen
    sim_rec(gen_v_sar(sp_sd = 50), nCont=2, level="area", fixed=FALSE),
    # 1 in area1, 2 in area2, 1 in area3
    sim_rec(gen_e_norm(mean = 10, sd = 1), nCont = c(1, 2, 1), level = "unit", fixed = TRUE),
    # 2 outliers, somewhere...
    sim_rec(gen_e_norm(mean = 10, sd = 1), nCont = 2, level = "none", fixed = FALSE)
    )


