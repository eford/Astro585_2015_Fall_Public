proclist = workers()         # Get list of workers

# test that can use tasks on all workers
for proc in proclist
  println("Julia says welcome from proc ",proc," w/ hostname ",@fetchfrom(proc,gethostname() ))
end
#Libc.flush_cstdio()

# Functions for demo calculation
function calc_pi(N::Integer)
  piapprox = @sync @parallel (+) for i in 1:N
    x, y = rand(), rand()
    (x*x+y*y <= 1.0) ? 1 : 0
  end
  piapprox *= 4.0/N
end

# Perform demo calculation
srand(42)        # make sure different processors have different seeds
calc_pi(10)
@time piapprox = calc_pi(1000000)
@printf("pi is estimated to be %14.12f\n", piapprox)
