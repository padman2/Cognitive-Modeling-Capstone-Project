// Simple Flat DDM
// ============================
// a (boundary) and t (non-decision time) are fixed at constants.
// Only global v_easy, v_hard, and beta are estimated.

data {
    int<lower=1> N;
    array[N] int<lower=0, upper=1> choice;
    vector<lower=0>[N] RT;
    array[N] int<lower=0, upper=1> difficulty;
}

transformed data {
    // Fixed constants — not estimated
    real a_fixed = 1.5;    // boundary separation
    real t_fixed = 0.05;   // non-decision time (50ms)
}

parameters {
    real v_easy;
    real v_hard;
    real beta_logit;
}

transformed parameters {
    real beta = inv_logit(beta_logit);
}

model {
    // Priors
    v_easy     ~ normal(0, 2);
    v_hard     ~ normal(0, 2);
    beta_logit ~ normal(0, 1);

    // Likelihood
    for (n in 1:N) {
        real v_n = (difficulty[n] == 0) ? v_easy : v_hard;

        if (RT[n] > t_fixed) {
            if (choice[n] == 1) {
                target += wiener_lpdf(RT[n] | a_fixed, t_fixed, beta, v_n);
            } else {
                target += wiener_lpdf(RT[n] | a_fixed, t_fixed,
                                      1 - beta, -v_n);
            }
        }
    }
}

generated quantities {
    real v_diff             = v_easy - v_hard;
    real p_v_easy_gt_v_hard = (v_easy > v_hard) ? 1.0 : 0.0;

    // Per-trial log likelihood for LOO-IC computation
    vector[N] log_lik;
    for (n in 1:N) {
        real v_n = (difficulty[n] == 0) ? v_easy : v_hard;
        if (RT[n] > t_fixed) {
            if (choice[n] == 1) {
                log_lik[n] = wiener_lpdf(RT[n] | a_fixed, t_fixed, beta, v_n);
            } else {
                log_lik[n] = wiener_lpdf(RT[n] | a_fixed, t_fixed,
                                         1 - beta, -v_n);
            }
        } else {
            log_lik[n] = 0;
        }
    }
}
