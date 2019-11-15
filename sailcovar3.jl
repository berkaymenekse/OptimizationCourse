using JuMP, Clp, Printf

d = [40 60 75 25]                   # monthly demand for boats

m = Model(with_optimizer(Clp.Optimizer))

@variable(m, 0 <= x[1:5] <= 40)       # boats produced with regular labor
@variable(m, y[1:5] >= 0)             # boats produced with overtime labor
@variable(m, hp[1:5] >= 0)             # boats held in inventory
@variable(m, hn[1:5] >= 0)

@variable(m, cp[1:4] >= 0)
@variable(m, cn[1:4] >=0)

@constraint(m, hp[5] >= 10)
@constraint(m, hp[1] == 10)

@constraint(m, hn[5] <= 0)

@constraint(m, x[1] == 40)
@constraint(m, y[1] == 10)



@constraint(m, flow[i in 1:4], hp[i+1]-hn[i+1] == hp[i]-hn[i] +x[i] + y[i] - d[i])
@constraint(m, balance[i in 1:4], x[i+1]+y[i+1] - (x[i]+y[i]) == cp[i] + cn[i])


@objective(m, Min, 400*sum(x) + 450*sum(y) + 20*sum(hp) + 400*sum(cp) + 500*sum(cn) + 100*sum(hn))         # minimize costs

optimize!(m)

@printf("Boats to build regular labor: %d %d %d %d %d\n", value(x[1]), value(x[2]), value(x[3]), value(x[4]), value(x[5]))
@printf("Boats to build extra labor: %d %d %d %d %d\n", value(y[1]), value(y[2]), value(y[3]), value(y[4]), value(y[5]))
@printf("Stock: %d %d %d %d %d\n ", value(hp[1]), value(hp[2]), value(hp[3]), value(hp[4]), value(hp[5]))
@printf("Demand: %d %d %d %d %d\n ", value(hn[1]), value(hn[2]), value(hn[3]), value(hn[4]), value(hn[5]))
@printf("Increased product number: %d %d %d %d\n ", value(cp[1]), value(cp[2]), value(cp[3]), value(cp[4]))
@printf("Decreased product number: %d %d %d %d\n ", value(cn[1]), value(cn[2]), value(cn[3]), value(cn[4]))



@printf("Objective cost: %f\n", objective_value(m))