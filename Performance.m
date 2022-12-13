function[W_fuel] = Performance(W_wing, W_fuel, LD)

MTOW = W_fuel + W_wing + Aircraft_Wing

Ws_We = exp(R*(C_T/v)*(1/LD))

W_fuel = (1 - 0.938*Ws_We)*MTOW