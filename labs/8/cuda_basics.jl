if typeof(Pkg.installed("CUDArt")) != VersionNumber 
   Pkg.add("CUDArt") 
end

if !contains(ENV["PATH"],"cuda")
  ENV["PATH"] = string(ENV["PATH"],":/usr/local/cuda/bin")
end

if !( mtime("normal_pdf_kernel.ptx") >= mtime("normal_pdf_kernel.cu") )
  run(`nvcc -ptx normal_pdf_kernel.cu`)
end

using CUDArt

function init_cuda(gpuid::Integer = first(devices(dev->capability(dev)[1]>=2)) )  
  dev = device(gpuid) # specify a CUDA device, defaulting to the first GPU with CUDA compute capability >=2.0

  # Set parameters based on the attributes of this specific GPU
  const global max_grid_dimx_size = attribute(dev,CUDArt.CUDArt_gen.cudaDevAttrMaxGridDimX )
  const global max_block_dimx_size = attribute(dev,CUDArt.CUDArt_gen.cudaDevAttrMaxBlockDimX )
  const global max_threads_per_block = attribute(dev,CUDArt.CUDArt_gen.cudaDevAttrMaxThreadsPerBlock)

  return dev
end

function load_functions(T::Type=Float64)
  # load the PTX module containing compiled GPU kernels (each module can contain multiple kernel functions)
  md = CuModule("normal_pdf_kernel.ptx", false)  # false specifies not to finalize module

  # Retrieve a few kernel functions from the module
  if T==Float64
    global std_normal_pdf_kernel = CuFunction(md, "std_normal_pdf_double")
    global normal_pdf_kernel = CuFunction(md, "normal_pdf_double")
    global block_sum_kernel = CuFunction(md, "block_sum_double")
  elseif T==Float32
    global std_normal_pdf_kernel = CuFunction(md, "std_normal_pdf_float")
    global normal_pdf_kernel = CuFunction(md, "normal_pdf_float")
    global block_sum_kernel = CuFunction(md, "block_sum_float")
  else
    throw("Invalid type specified")
  end
  return md
end
 
function unload_functions!(md::CuModule)
  # finalize: unload module 
  unload(md)
end

function close_cuda(gpuid::Integer = first(devices(dev->capability(dev)[1]>=2)) )
  device_reset(gpuid)
end

#  Could optimize the choice of block sizes better, allow for 2-d blocks, etc.
function choose_block_size(n::Integer)
  min(n,max_threads_per_block)
end

#  Could optimize the chocie of grid sizes better, allow for 3-d grids, etc.
function choose_grid_size(n::Integer, block_size::Integer)
  @assert(block_size <= max_block_dimx_size)

  grid_size = ceil(Int64,n/block_size)
  if grid_size > max_grid_dimx_size
    grid_size_x = ceil(Int64,sqrt(grid_size))
    @assert(grid_size_x <= max_grid_dimx_size)
    grid_size = (grid_size_x, grid_size_x)
  end
  return grid_size
end

nothing
