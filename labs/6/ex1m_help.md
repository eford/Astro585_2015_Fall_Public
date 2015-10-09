function int_normal_pdf(a::Real, b::Real, n::Integer = 1000)
   @assert(n>2)
   x = distribute([ a+i*(b-a)/(n+1) for i in 1:n ])
   integral = (b-a)/n * mapreduce(fetch,+,RemoteRef[ (@spawnat p sum(normal_pdf(localpart(x)))) for p in procs(x) ])
end



