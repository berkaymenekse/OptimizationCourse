using JuMP, Clp, Printf

d = [40 60 75 25]                   # monthly demand for boats

m = Model(with_optimizer(Clp.Optimizer))

@variable(m, 0 <= x[1:5] <= 40)       # boats produced with regular labor
@variable(m, y[1:5] >= 0)             # boats produced with overtime labor
@variable(m, h[1:5] >= 0)             # boats held in inventory

@variable(m, cp[1:4] >= 0)
@variable(m, cn[1:4] >=0)

@constraint(m, h[5] >= 10)
@constraint(m, h[1] == 10)

@constraint(m, x[1] == 40)
@constraint(m, y[1] == 10)


@constraint(m, flow[i in 1:4], h[i]+x[i+1]+y[i+1]==d[i]+h[i+1])     # conservation of boats
@constraint(m, balance[i in 1:4], x[i+1]+y[i+1] - (x[i]+y[i]) == cp[i] + cn[i])


@objective(m, Min, 400*sum(x) + 450*sum(y) + 20*sum(h) + 400*sum(cp) + 500*sum(cn))         # minimize costs

optimize!(m)

@printf("Boats to build regular labor: %d %d %d %d %d\n", value(x[1]), value(x[2]), value(x[3]), value(x[4]), value(x[5]))
@printf("Boats to build extra labor: %d %d %d %d %d\n", value(y[1]), value(y[2]), value(y[3]), value(y[4]), value(y[5]))
@printf("Inventories: %d %d %d %d %d\n ", value(h[1]), value(h[2]), value(h[3]), value(h[4]), value(h[5]))
@printf("Increased product number: %d %d %d %d\n ", value(cp[1]), value(cp[2]), value(cp[3]), value(cp[4]))
@printf("Decreased product number: %d %d %d %d\n ", value(cn[1]), value(cn[2]), value(cn[3]), value(cn[4]))

@printf("Objective cost: %f\n", objective_value(m))