BUCKET=$2

for ((i = 1; i <= $1; i++))
	do
		csmith --max-pointer-depth $BUCKET > bucket-$BUCKET-$i.c
	done
