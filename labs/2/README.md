# PsuAstro585:  Lab 2:  
# Testing, Assertions, Benchmarking, Scaling with Problem Size

## Exercises
1.  Developing a Well Tested Function
2.  Benchmarking Code, Regression Tests & Algorithmic Optimizations
3.  Large Linear Algebra Problems
4.  Numerical Stability of Integrators  (as time permits)

## Getting started with lab 2

First, you'll want to merge the changes that I've made to the course's template git repository into your local repository.
To do that, you'll first want to change into a directory that's part of a local git repository.
Then tell git that you want your local repository to know about another remote repository (which we'll call "upstream") with the following command.
```
> git remote add upstream git@github.com:eford/PsuAstro585.git
```
If you're working from multiple local repositories (e.g., one on a lab computer, one on your laptop), then you'll need to do this once for each repository.  

Remember that you can "pull" changes from your remote repository into your local repository with the command.
```
> git pull
```
When you don't specify a repository after the pull command, then by default git uses the "origin" repository that you specified when you issued the `git clone` command to setup your local repository.

Now, we'll "pull" in changes from the "master" branch of the "upstream" repository with the command
```
> git pull upstream master
```

If all goes smoothly, then you'll now have new files in the labs/2 subdirectory.

If you run into problems with git, ask for help.  Or you can just go view the files via a web browser at github https://github.com/eford/PsuAstro585.  

Note that exercise 4 is in an IJulia notebook (so you can view the equations).  If you don't have IPython working, you can still view the ipython notebook at github https://github.com/eford/PsuAstro585.
 
