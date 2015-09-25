# Astro 585 Lab 5, Exercise 2

### Object Oriented Programming
Some languages like C++ and Java are designed in a way to encourage Object Oriented Programming (OOP).  Other languages (e.g., C and Julia) don't emphasize OOP.   However, the principles of object oriented programming can be used when appropriate.  

The key element of OOP is thinking of "objects" that include both data and code.  For example, when fitting a model to data, there's both the data and a function that specifies the model.  

In order to make use of libraries and/or maximize reuse of your own code, you likely have functions that needs a simple argument list.  For example, consider the `optimize(function, param)` function in Julia's Optim.jl package.  It attempts to find the minimum value of some function, starting from an initial guess of the parameter values.  Your function might compute a goodness-of-fit statistic such as chi-squared, based on comparing the model's predictions to data.  But where do you put the data when calling optimize?

I'll demonstrate one pattern for how this can be done below when fitting a simple model to simulated data.  Then you'll be asked to write code for a slightly more sophisticated model using a similar pattern.


### Modules

First, we will create a "module" that contains functions to compute a planet's transit times using one of two simple models.
```julia
module Ephemerides

# Specify which functions to expose
export linear_transit_ephemeris, sinusoidal_transit_ephemeris

# Calculate transit times assuming constant orbital period
# Input: Transit number(s)
# Output: Predicted transit time(s)
linear_transit_ephemeris(transit_num, param::Vector) = param[1].+param[2].*transit_num

# Calculate transit times as a linear ephemeris plus a sinusoidal perturbation
# Input: Transit number(s)
# Output: Predicted transit time(s)
function sinusoidal_transit_ephemeris(transit_num,param::Vector) 
 t_linear = linear_transit_ephemeris(transit_num,param[1:2])
 t_ttv = t_linear.+param[4].*sin(t_linear.*2pi./param[3])+param[5].*cos(t_linear.*2pi./param[3])
end

end # module Ephemerides
```

Now, if we call the function `linear_transit_ephemeris(0,[0.,0.])`
we will get an error saying that the function is not defined, because the function is wrapped up in a module that is not exposed to the global namespace.  
To access this function, we can either specify the module explicitly by calling `Ephemerides.linear_transit_ephemeris(0,[0.,0.])` or we use
```julia
using Ephemerides
linear_transit_ephemeris(0,[0.,0.])
```
to load all of the functions that are exported by the Ephemerides module.

a.  Write a module named `Fitting` that exports the following function.
```julia
# Generic function to calculate chi squared for a given model and data
# Inputs: 
#   param:  Vector of model parameters
#   model:  Function taking x values and input parameters and returning model predictions
#   x:      Data for input to model
#   y:      Measured data for comparison to model predictions
#   sigma:  Uncertainties in measurements
# Output: chi squared of model for given parameters and data
function chisq_model_vs_data(param::Vector, model::Function, x::Vector, y::Vector, sigma::Vector) 
  @assert( length(x) == length(y) == length(sigma) > 0)
  chisq = zero(eltype(param))
  for i in 1:length(x)
    predict = model(x[i],param)
	chisq += ((predict-y[i])/sigma[i])^2
  end
  chisq
end
```

### Modules and OOP
The modules above provided only functions.  Modules can also contain variables.  (In Julia, technically functions are just one type of variable.)  For example, we could create a module that contains data which can be used in combination with the Fitting module and an ephemeris to compute a goodness-of-fit statistic for a given set of parameter values.

```julia
module SimulatedData

using Ephemerides, Fitting
export chisq_linear_b, chisq_linear_c

# Parameters to be used for for simulated data
P_b_true = 5.729
 t0_b_true = 781.99
 P_c_true = 11.6035
 t0_c_true = 786.76
 period_ttv_true = 450.0
 A_b_true = 0.0001
 B_b_true = -0.0001
 A_c_true = 0.02
 B_c_true = -0.02
 pl_b_true = [t0_b_true,P_b_true,period_ttv_true,A_b_true,B_b_true]
 pl_c_true = [t0_c_true,P_c_true,period_ttv_true,A_c_true,B_c_true]
  
# Generate simulated data set
 # Generate transit numbers
 const sim_trid_list_b = linspace(-125,129,255)
 const sim_trid_list_c = linspace(-62,62,125)
 # Calculate "true" transit times
 const true_tt_list_b = sinusoidal_transit_ephemeris(sim_trid_list_b, pl_b_true )
 const true_tt_list_c = sinusoidal_transit_ephemeris(sim_trid_list_c, pl_c_true )
 # Set measurement uncertainties for each observation
 const sigma_tt_b = 0.005*ones(length(true_tt_list_b))
 const sigma_tt_c = 0.010*ones(length(true_tt_list_c))
 # Calculate simulated transit times
 const sim_tt_list_b = true_tt_list_b .+ sigma_tt_b.*rand(length(true_tt_list_b))
 const sim_tt_list_c = true_tt_list_c .+ sigma_tt_c.*rand(length(true_tt_list_c))

# Calculate chi_sq for a linear ephemeris and simulated data for planet b
chisq_linear_b(param::Vector) = chisq_model_vs_data(param,linear_transit_ephemeris,sim_trid_list_b,sim_tt_list_b,sigma_tt_b)

# Calculate chi_sq for a linear ephemeris and simulated data for planet c
chisq_linear_c(param::Vector) = chisq_model_vs_data(param,linear_transit_ephemeris,sim_trid_list_c,sim_tt_list_c,sigma_tt_c)

end # Module SimulatedData
```
(If it doesn't work, check that your `Fitting` module is correct.)

The SimualtedData module provides a function (`SimulatedData.chisq_linear_b`) that takes only a set of parameter values and returns a chi-squared statistic describing how well a model with those parameter values matches the data that is also stored in the module.  
If your Fitting module is working, then you should be able to do
We could access that function by doing
```julia
using SimulatedData 
chisq_linear_b([782.0,5.7])
```
but sometimes it's nice to be able to access those functions only when specifying their namespace.  So instead we'll do
```julia
# We want access to variables inside SimulatedData, but only when explicitly specifying their namespace
import SimulatedData 

# Initial guesses for the orbital period and "zeroth" transit time
P_b_guess = SimulatedData.P_b_true+0.01*randn()
 t0_b_guess = SimulatedData.t0_b_true+0.00001*randn()
 pl_b_guess = [t0_b_guess,P_b_guess]
 P_c_guess =  SimulatedData.P_c_true+0.01*randn()
 t0_c_guess = SimulatedData.t0_c_true+0.0001*randn()
 pl_c_guess = [t0_c_guess,P_c_guess]

# Calculate best-fit models with linear ephemeris
using Optim 
fit_b_output = optimize(SimulatedData.chisq_linear_b,pl_b_guess)
fit_c_output = optimize(SimulatedData.chisq_linear_c,pl_c_guess) 
```
to fit a linear transit model to the simulated data.  It's nice to check how close the solution is to the true value.
```julia
# How close is the solution found to the true values?
fit_b_output.minimum-[SimulatedData.t0_b_true,SimulatedData.P_b_true]
fit_c_output.minimum-[SimulatedData.t0_c_true,SimulatedData.P_c_true]
```

b.  Write a module `DataFromFile` that exports two functions `chisq_linear_b` and `chisq_linear_c` analogous to those from the `SimulatedData` module, but using data read in from two files, "ttv_b.csv" and "ttv_c.csv" instead of simulated data.

c. Add functions `chisq_sinusoid_b(param::Vector)` and `chisq_sinusoid_c(param::Vector)` to both the `SimulatedData` module and your `DataFromFile` module.  

d.  Test that your functions work when using optimize to calculate the minimum chi-squared value and the values of the model parameters that maximize the goodness-of-fit based on the sinusoidal transit ephemeris model.  Once you've establish confidence that they're working well by comparing the results for your simulated data, then apply them to the datasets in the files `ttv_b.csv` and `ttv_c.csv`.  Make it easy for me to find where you report the values from that calculation.

e. You may have noticed that some of your code in the two modules is quite similar, but with just a few different variables being passed One problem with the current pattern is that the number of combinations of models and datasets grows geometrically, rather than linearly.  How could one write even more general code that 

f.  (Optional) Try implementing your best suggestion from part e.

g.  (Optional)  Add to your modules a function `chisq_sinusoid_bc(param::Vector)` that computes the sum of the chi-square statistics for both planets (using functions written in part c & d), where most of the input parameters are independent, but the  sinusoids have a common period.  Test and apply to the datafiles provided.

