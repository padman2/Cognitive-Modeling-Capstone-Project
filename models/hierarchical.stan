// Simple Hierarchical DDM
// ============================
// a (boundary) and t (non-decision time) are fixed at constants.
// Only v_easy, v_hard, and beta are estimated per player.

data {
    int<lower=1> N;
    int<lower=1> J;
    array[N] int<lower=1, upper=J> player;
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
    // Group-level hyperparameters
    real mu_v_easy;
    real<lower=0> sigma_v_easy;
    real mu_v_hard;
    real<lower=0> sigma_v_hard;
    real mu_beta_logit;
    real<lower=0> sigma_beta;

    // Non-centered offsets
    vector[J] z_v_easy;
    vector[J] z_v_hard;
    vector[J] z_beta;
}

transformed parameters {
    vector[J] v_easy = mu_v_easy + sigma_v_easy * z_v_easy;
    vector[J] v_hard = mu_v_hard + sigma_v_hard * z_v_hard;
    vector[J] beta   = inv_logit(mu_beta_logit + sigma_beta * z_beta);
}

model {
    // Hyperpriors
    mu_v_easy     ~ normal(0, 2);
    sigma_v_easy  ~ normal(0, 1);
    mu_v_hard     ~ normal(0, 2);
    sigma_v_hard  ~ normal(0, 1);
    mu_beta_logit ~ normal(0, 1);
    sigma_beta    ~ normal(0, 0.5);

    // Non-centered offsets
    z_v_easy ~ normal(0, 1);
    z_v_hard ~ normal(0, 1);
    z_beta   ~ normal(0, 1);

    // Likelihood
    for (n in 1:N) {
        int j = player[n];
        real v_n = (difficulty[n] == 0) ? v_easy[j] : v_hard[j];

        if (RT[n] > t_fixed) {
            if (choice[n] == 1) {
                target += wiener_lpdf(RT[n] | a_fixed, t_fixed, beta[j], v_n);
            } else {
                target += wiener_lpdf(RT[n] | a_fixed, t_fixed,
                                      1 - beta[j], -v_n);
            }
        }
    }
}

generated quantities {
    real p_v_easy_gt_v_hard = (mu_v_easy > mu_v_hard) ? 1.0 : 0.0;
    real mu_v_diff          = mu_v_easy - mu_v_hard;
    vector[J] v_diff        = v_easy - v_hard;
    real group_beta         = inv_logit(mu_beta_logit);
}