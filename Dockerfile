FROM ubuntu:16.04
MAINTAINER Pedro Ramos <pedroramos@dcc.ufmg.br>
MAINTAINER Vitor Paisante <vmpaisante@gmail.com>

# Install dependencies
RUN apt-get update && \
		apt-get install g++ gcc make python csmith subversion -y

# Get LLVM 3.7 + test-suite (4GB approximately)
RUN svn co http://llvm.org/svn/llvm-project/llvm/tags/RELEASE_370/final llvm && \
		svn co http://llvm.org/svn/llvm-project/cfe/tags/RELEASE_370/final llvm/tools/clang && \
		svn co http://llvm.org/svn/llvm-project/compiler-rt/tags/RELEASE_370/final llvm/projects/compiler-rt && \
		svn co http://llvm.org/svn/llvm-project/test-suite/tags/RELEASE_370/final llvm/projects/test-suite

# Change config files in order to allow in-source build
RUN rm -r llvm/Makefile.config.in && \
		rm -r llvm/configure
ADD /config /llvm

# Add our passes to the Passes root directory
ADD /src /llvm/lib/Transforms

# Add tests scripts to tests folder
ADD /tests /sraa/tests

# build llvm and test-suite
RUN cd llvm && ./configure
RUN cd llvm/lib/Transforms/sraa && make
RUN cd llvm/lib/Transforms/RangeAnalysis && make
RUN cd llvm/lib/Transforms/vSSA && make

WORKDIR /sraa

CMD bash