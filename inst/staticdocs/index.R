sd_section("Basic Functions",
           "You won't get around these functions if you decide to work with this 
           package. Use `sim` to start a simulation simulation.",
           c("base_id", "sim"))

sd_section("Simulation Components",
           "These functions help to control the simulation workflow. Use them to 
           add components to a simulation setup.",
           c("sim_gen", "sim_comp_pop", "sim_comp_sample", "sim_comp_agg","sim_sample", "sim_agg"))

sd_section("Generators",
           "These functions are predefined interfaces to random number generators
           implemented in *R*. You can use `gen_generic` to supply any random 
           number generator. Use these functions in conjunction with `sim_gen`",
           c("gen_generic", "gen_norm", "gen_v_norm", "gen_v_sar"))

sd_section("Compute Functions",
           "Use these functions to add computations.",
           c("comp_var"))

sd_section("Sampling Functions",
           "Use these functions to control the sampling process.",
           c("sample_number", "sample_fraction"))

sd_section("Aggregator Functions",
           "There is only one preconfigured function for aggregation. If you don't 
           like it's behavior you can supply your own function to `sim_agg`.",
           c("agg_all"))