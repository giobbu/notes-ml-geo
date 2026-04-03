# Reference: https://observablehq.com/@mattiasvillani/poisson-time-series-model
import json
import numpy as np
import datetime

def simulate_poisson_ar1(n: int = 300, mu: float = 1.0, phi: float = 0.90, sigma_eta: float = 0.4, seed: int = 42) -> dict:

    if abs(phi) >= 1.0:
        raise ValueError(f"|phi| must be < 1 for stationarity; got phi={phi}")
    if sigma_eta <= 0:
        raise ValueError("sigma_eta must be positive")

    rng = np.random.default_rng(seed)

    # Stationary variance of z_t
    sigma_stationary = sigma_eta / np.sqrt(1.0 - phi ** 2)

    # draw initial z0 from the stationary distribution
    z0 = rng.normal(mu, sigma_stationary)

    z   = np.empty(n)
    lam = np.empty(n)
    y   = np.empty(n, dtype=int)

    z[0]   = z0
    lam[0] = np.exp(z[0])
    y[0]   = rng.poisson(lam[0])

    eta = rng.normal(0.0, sigma_eta, size=n)      # pre-draw all innovations

    for t in range(1, n):
        z[t]   = mu + phi * (z[t - 1] - mu) + eta[t]
        lam[t] = np.exp(z[t])
        y[t]   = rng.poisson(lam[t])

    list_timestamps = [f"2024-01-01T00:00:00Z"]
    for i in range(1, n):
        next_timestamp = (datetime.datetime.fromisoformat(list_timestamps[-1].replace("Z", "")) + datetime.timedelta(hours=1)).isoformat() + "Z"
        list_timestamps.append(next_timestamp)

    return {"timestamp": list_timestamps,
            "t": np.arange(n).tolist(), 
            "z": z.tolist(),
            "lam": lam.tolist(), 
            "y": y.tolist(),
            "params": dict(n=n, 
                           mu=mu, 
                           phi=phi, 
                           sigma_eta=sigma_eta, 
                           seed=seed)
                           }



if __name__ == "__main__":

    import pandas as pd

    # set parameters for simulation
    n=300
    mu=1.0
    phi=0.9
    sigma_eta=0.4
    seeds = [1, 42]

    list_ts = []
    for seed in seeds:
        sim = simulate_poisson_ar1(n = 300, mu = 1.0, phi = .9, sigma_eta = 0.4, seed = seed)
        list_ts.append(sim)

    # convert to Dataframe with timestamp as index, y1, y2 as columns and save it as Parquet file
    df = pd.DataFrame({
        "timestamp": list_ts[0]["timestamp"],
        "y1": list_ts[0]["y"],
        "y2": list_ts[1]["y"],
    })
    print("Simulated DataFrame:")
    print(df.head())

    df.to_parquet("simulated_poisson_ar1.parquet", index=False)
    print("Simulated data saved to 'simulated_poisson_ar1.parquet'")
