# Astro 585 Lab 2, Exercise 4
## Numerical Stability of Integrators

Consider integrating the equations of motion for a test particle orbiting a star fixed at the origin. In 2D, there are two 2nd order ODEs:


function calc_time_log_likelihood(Nobs::Int, Mtimes::Int = 1)
  @assert (Nobs>=1);
  srand(42);
  z = zeros(Nobs);
  sigma = 2. * ones(Nobs);
  y = z + sigma .* randn(Nobs);
  total = 0.;
  for i in 1:Mtimes
    total = total + @elapsed log_likelihood(y,sigma,z);
  end
  return total;
end

a. Write a function integrate_euler!(state,dt, duration) that integrates a system (described by state) using Eulers method and steps of size dt for an interval of time given by duration. It would probably be wise to write at least two additional functions. Have your function return a two dimensional array containing a list of the states of the system during your integration

b. Use the above code to integrate a system with an initial state of (r_x, r_y, v_x, v_y) = (1, 0, 0, 1) for roughly 3 orbits (i.e., 3*2pi time units if you set GM=1) using approximately 200 time steps per orbit. Inspect the final state and comment on the accuracy of the integration.

c. Plot the trajectory of the test particle (e.g., x vs y). Is the calculated behavior accurate?

d. Write a new function integrate_leapfrog!(state,dt, duration) that is analogous to integrate_euler, but uses the leapfrog or modified Eulers integration method:
r(tn+1/2)=r(tn)+dt/2drdt|tnv(tn+1)=v(tn)+dtdvdt|tn+1/2r(tn+1)=r(tn+1/2)+dt/2drdt|tn+1

e. Repeat the integration from part 3b, but using the integrate_leapfrog code. Inspect the final end state and make a similar plot. Describe the main difference in the results and explain on what basis you would choose one over the other.

f. Time how long your code for a similar integration of 100 orbits. How long would it take to integrate for 4.5*10^9 orbits (e.g., age of Earth)?

g. Repeat the integration from part 3e, but using a larger dt. Inspect the final end state. How much less accurate is the integration that used a larger dt?

h. Make a log-log plot of the accuracy of the integration versus the integration duration for durations spanning at least a few orders of magnitude. Estimate the slope (by eye is fine). What are the implications for the accuracy of a long-term integration?

i. List a few ideas for how you could accelerate the integrations. Comment on how likely each of your ideas is to make a significant difference. (If you try it out, report the new time for 100 orbits, so we can compare.) Discuss any drawbacks of each idea to accelerate the integrations.


