source("decode.R")

fit <- Decode(counts, map, params,
              alpha = decoding_params$alpha,
              correction = decoding_params$correction)

