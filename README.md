# Python Semantics for K 5.0

This is the CS522 course project of Qianyang Peng and Wenhua Lin. We implemented a simple python semantics for K framework 5.0.

Our implementation is based on the untyped KOOL semantics, which is a untyped object oriented programming language implementation:

https://github.com/kframework/k/tree/master/k-distribution/tutorial/2_languages/2_kool/1_untyped

Although there has been a python semantic implementation for K 3.2.1:

https://github.com/kframework/python-semantics

But we are not using it, because we find it hard to get it compiled in K 5.0, and it is too complicated for us to fully understand it.

For the details of our implementation, please refer to our report:

https://github.com/CS522-python-semantics/kpython-k5-lite/blob/master/report/report.pdf

# Usage

1. make all: Compile the project.

2. make clean: Remove the compiled kpython binaries.

3. make tests: Run the tests inside the ./test folder. The output will be compared with the output of executing same python files with python3 and the output will be put in the ./tmp folder

4. make test-clean: Remove the output files in the ./tmp folder.

# Environment Version

## K Framework version
The K framework is evolving very quickly, thus we are not sure whether our current implementation still work in the future release of K. Here is the K framework version that we are using:

Git revision: 82ced7b

Git branch: master

Build date: Thu Dec 06 09:33:50 AEST 2018

## Python version

Our implementation should work on any version of Python 3. 

# Contribution:

Qianyang Peng: 50%

Wenhua Lin: 50%
