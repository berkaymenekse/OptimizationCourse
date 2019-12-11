using Cbc;
using JuMP;
#for dot product
using  LinearAlgebra;
totalCandidate = 250;
totalVote = 5000;
model = Model(with_optimizer(Cbc.Optimizer));


#we have to minimize z value
#firstly declarate z 
@variable(model, z>=0,Int);

#our goal is find to candidate number so we will use vote count as a index
#votes describe number of candidates who are taken same number of votes
#votes can not be higher or lower than 5000
#all votes[index] sum must be equals to candidate number
# summation of votes[i] dot i must be equals to 5000

@variable(model, totalVote >= votes[1:5000] >= 0,Int);


@constraint(model,dot(votes,1:5000) == 5000);

#all votes count must be equal to 
@constraint(model,sum(votes) == 250 );

#we travel to find our goal
@constraint(model, [index = 1:5000],z >=votes[index]);
@objective(model,Min,z);

optimize!(model);

#i found not integer value then i changed the code,i added Int (casting)
# objective value 6.4102564

#@variable(model, z>=0,Int);
#@variable(model, totalVote >= votes[1:5000] >= 0,Int);


