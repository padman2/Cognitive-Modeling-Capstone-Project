data {
    int<lower=1> N;
    int<lower=1> J;
    array[N] int<lower=1, upper=J> player;
    array[N] int<lower=0, upper=1> choice;
    vector<lower=0>[N] RT;
    array[N] int<lower=0, upper=1> difficulty;
    real<lower=0> sigma_v;   // prior SD passed in as data
}
transformed data {
    real a_fixed = 1.5;
    real t_fixed = 0.05;
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
    v_easy     ~ normal(0, sigma_v);
    v_hard     ~ normal(0, sigma_v);
    beta_logit ~ normal(0, 1);
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
    real v_diff = v_easy - v_hard;
    real p_easy_gt_hard = (v_easy > v_hard) ? 1.0 : 0.0;
}