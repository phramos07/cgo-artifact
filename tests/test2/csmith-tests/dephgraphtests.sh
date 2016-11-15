DIR=$2
file=$1

		filename=$(basename "$file")
		echo "Running NO_AA test on " $filename ...
		echo $filename  >> $DIR-no-aa.out
		opt -load TaskMiner.dylib -load obaa.dylib \
		-ModuleDepGraph -stats -disable-output  < $file 2>&1 \
		| grep "memory nodes" >> $DIR-no-aa.out

		echo "Running BASICAA test on " $filename ...
		echo $filename  >> $DIR-basicaa.out
		opt -load TaskMiner.dylib -load obaa.dylib -basicaa \
		-ModuleDepGraph -stats -disable-output  < $file 2>&1 \
		| grep "memory nodes" >> $DIR-basicaa.out

		echo "Running SRAA test on " $filename ...
		echo $filename  >> $DIR-sraa.out
		opt -load TaskMiner.dylib -load obaa.dylib -basicaa -sraa \
		-ModuleDepGraph -stats -disable-output  < $file 2>&1 \
		| grep "memory nodes" >> $DIR-sraa.out