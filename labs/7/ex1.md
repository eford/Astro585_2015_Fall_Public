# PSU Astro585:  Lab 6  
# Parallel Computing:  Distributed Memory Clusters

## Exercise 1: Running a job on a Lion-X Cluster

In this exercise, you will learn how to run parallel jobs on the "Lion-X" clusters maintained by Penn State Institute for CyberScience's Advanced Computing Infrastructure group.  

a.  First, you need to obtain an account, setup two factor authentication and make sure that you can log in. (Using a VPN may be necessary depending on where you're ssh'ing from.)  See http://ics.psu.edu/advanced-cyberinfrastructure/accounts/ics-accounts/ for details.
[Information about the Lion-X systems](https://ics.psu.edu/advanced-cyberinfrastructure/support/tutorials/lion-x-manual/) is avaliable online.

b.  Ssh into one of the Lion-X systems (e.g., lionxf.rcc.psu.edu, lionxj.rcc.psu.edu or lionxv.rcc.psu.edu)
Run the following commands
```tcsh
module load git            
module load julia/0.3.11_483dbf5279
git config --global url."https://".insteadOf git://
```
so that git and julia v0.4 are in your path and to tell git how to work around the firewalls on this system.  (You only should need to do this git config command once on the Lion-X systems.)  

Do a simple test that you can run git and julia.  Remember that you're not to do anything computationally intensive on the head node of a cluster.  

c.  Copy the julia-demo-serial.pbs and julia-demo-serial.jl files from ~ebf11/public/ into a subdirectory that you'll be working from (either by cloning the git repository, using scp or simply copying and pasting).  Read through the PBS script to understand what it's doing and to make the one suggested trivial change.  Then, while in the same directory as those files,  submit a job to the PBS scheduler
```tcsh
qsub julia-demo-serial.pbs
```
Check on your job's status by running `qstat`.  Usually, there are a lot of jobs in the queue.  It may be helpful to pick out just your own jobs by using `qstat -u $USER`.  When you see a line like
```julia
4180477.lionxv.rcc.psu  ebf11       lionxv   julia-demo-seria    --      1      1  256mb  00:30:00 Q       --
```
you can tell that your job is still sitting in the queue (i.e., not running) based on the Q in the final column.  That will change to R once the job is running.  
Hopefully, the job will start within a few minutes and finish very promptly.  If not, then you may want to try using another of the Lion-X clusters.
Once the job starts, PBS should send you an email (if you changed the PBS file correctly).  Then the job should only take a few seconds to run.  Once the job has finished, PBS will send you an email and your job will no longer show up in the list of jobs when you run `qstat`.  
The output (that would normally be written to STDOUT and STDERR) will be stored in a file with a name like julia-demo-serial.pbs.o4180477.  The final number is the job number assigned by the PBS scheduler.  (You can change the filename for storing data written to STDOUT and STDERR by using PBS directives.  Of course, if your program wrote  data to a file, then that output data would be in whatever file you wrote to.)
  

d.  One way to use a distributed cluster like the Lion-X systems is to submit many jobs that run totally independently of each other.  Since job uses a single processor core or perhaps multiple cores within one node, then the code can be written to run in serial or in a shared-memory environment.  Of course, this is only effective if the total work flow can be easily divided into large blocks of computation that can occur independently of each other.  Is there a way that your project could make use of this model for parallel computing?  

1e.  Make and test a PBS script that runs the serial code from your class project on a Lion-X system.  

1f.  Write one or more julia programs and/or scripts that create and submit multiple PBS jobs that will perform complementary calculations (e.g., analyze different data sets, perform simulation with different initial conditions, evaluation a model using different model parameters).  Always test such scripts with a small number of jobs.


