println("# Julia says welcome from node ",gethostname() )

# Functions for demo calculation
function calc_pi(N::Integer)
  piapprox = 0.0
  for i in 1:N
    x, y = rand(), rand()
    piapprox += (x*x+y*y <= 1.0) ? 1.0 : 0.0
  end
  piapprox *= 4.0/N
end

# Perform demo calculation
srand(42)        # seed random number generator for repeatability
calc_pi(10)      # a test run to make sure it compiles before we start timing it
@time piapprox = calc_pi(100000000)
@printf("pi is estimated to be %14.12f\n", piapprox)
