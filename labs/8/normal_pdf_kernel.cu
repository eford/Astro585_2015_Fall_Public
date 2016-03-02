extern "C"   // ensure function name will be left alone rather than mangled like a C++ function
{

    // Compute the standard normal density at an array of n points (x) and stores output in y.
    __global__ void std_normal_pdf_double(const double *x, double *y, unsigned int n)
    {
	// assumes a 2-d grid of 1-d blocks
	unsigned int i = (blockIdx.y * gridDim.x + blockIdx.x) * blockDim.x + threadIdx.x;
	const double ONE_OVER_ROOT_TWOPI = 1.0/sqrt(2.0*M_PI);
        if(i<n)  y[i] = exp(-0.5*x[i]*x[i])*ONE_OVER_ROOT_TWOPI;
    }

    // Compute the standard normal density at an array of n points (x) and stores output in y.
    __global__ void std_normal_pdf_float(const float *x, float *y, unsigned int n)
    {
	// assumes a 2-d grid of 1-d blocks
	unsigned int i = (blockIdx.y * gridDim.x + blockIdx.x) * blockDim.x + threadIdx.x;
	const float  ONE_OVER_ROOT_TWOPI_F = rsqrt(2.0f*3.14159265358979f);
        if(i<n)  y[i] = exp(-0.5f*x[i]*x[i])*ONE_OVER_ROOT_TWOPI_F;
    }


    // Compute the standard normal density at an array of n points (x) and stores output in y.
    __global__ void normal_pdf_double(const double *x, const double *mu, const double *sig, double *y, unsigned int n)
    {
	// assumes a 2-d grid of 1-d blocks
	unsigned int i = (blockIdx.y * gridDim.x + blockIdx.x) * blockDim.x + threadIdx.x;
	const float  ONE_OVER_ROOT_TWOPI = 1.0/sqrt(2.0*M_PI);
        if(i<n)  
           {
           double dx = x[i] - mu[i];
           y[i] = exp(-0.5*dx*dx)*ONE_OVER_ROOT_TWOPI/sig[i];
           }
    }

    // Compute the standard normal density at an array of n points (x) and stores output in y.
    __global__ void normal_pdf_float(const float *x, const float *mu, const float *sig, float *y, unsigned int n)
    {
	// assumes a 2-d grid of 1-d blocks
	unsigned int i = (blockIdx.y * gridDim.x + blockIdx.x) * blockDim.x + threadIdx.x;
	const float  ONE_OVER_ROOT_TWOPI_F = rsqrt(2.0f*3.14159265358979f);
        if(i<n)  
           {
           float dx = x[i] - mu[i];
           y[i] = exp(-0.5f*dx*dx)*ONE_OVER_ROOT_TWOPI_F/sig[i];
           }
    }

__global__ void sum_simplistic_double(const double *input, double *output, unsigned int n)
{
  unsigned int i = (blockIdx.y * gridDim.x + blockIdx.x) * blockDim.x + threadIdx.x;
  double sum = 0.0;
  if (i==0)
    {
    for(int j=0;j<n;++j)
       sum += input[j];
    }
  output[0] = sum;
}

__global__ void sum_simplistic_float(const float *input, float *output, unsigned int n)
{
  unsigned int i = (blockIdx.y * gridDim.x + blockIdx.x) * blockDim.x + threadIdx.x;
  float sum = 0.0;
  if (i==0)
    {
    for(int j=0;j<n;++j)
       sum += input[j];
    }
  output[0] = sum;
}

// Adopted from https://code.google.com/p/stanford-cs193g-sp2010/source/browse/trunk/tutorials/sum_reduction.cu
// this kernel computes, per-block, the sum
// of a block-sized portion of the input
// using a block-wide reduction
__global__ void block_sum_double(const double *input,
                          double *per_block_results,
                          unsigned int n)
{
  extern __shared__ double sdata[];

  unsigned int i = (blockIdx.y * gridDim.x + blockIdx.x) * blockDim.x + threadIdx.x;

  // load input into __shared__ memory
  double x = 0.0;
  if(i < n)
  {
    x = input[i];
  }
  sdata[threadIdx.x] = x;
  __syncthreads();

  // contiguous range pattern
  for(unsigned int offset = blockDim.x / 2;
      offset > 0;
      offset >>= 1)
  {
    if(threadIdx.x < offset)
    {
      // add a partial sum upstream to our own
      sdata[threadIdx.x] += sdata[threadIdx.x + offset];
    }

    // wait until all threads in the block have
    // updated their partial sums
    __syncthreads();
  }

  // thread 0 writes the final result
  if(threadIdx.x == 0)
  {
    unsigned int block_id_1d = (blockIdx.y * gridDim.x + blockIdx.x);
    per_block_results[block_id_1d] = sdata[0];
  }
}

}

