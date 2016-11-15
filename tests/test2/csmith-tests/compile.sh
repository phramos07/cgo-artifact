CLANG=/usr/local/bin/clang 
CSMITHLIB=/Users/pedroramos/programs/csmith-2.2.0/runtime

$CLANG -I$CSMITHLIB -c -emit-llvm $1 -o $1.bc
opt -mem2reg -instnamer $1.bc -o $1.mem.bc
rm -r $1.bc		
