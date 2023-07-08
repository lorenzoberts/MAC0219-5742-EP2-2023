array_sizes=(2^10 2^11 2^12 2^13 2^14 2^15 2^16 2^17)
nps=(1 2 4 8 16 32)

modes=("normal" "custom")
num_medicoes=10

OUTPUT_FILE="resultado_medicoes.csv"

echo "Iniciando medições..."

csv_out=$'modo,array_size,np'

for i in $(seq 1 $num_medicoes); do
	csv_out="$csv_out","measure_$i"
done
csv_out="$csv_out"$'\n'

for a_size in ${array_sizes[@]}; do
    for np in ${nps[@]}; do
		for mode in ${modes[@]}; do
       		csv_line="$mode"','"$a_size"','"$np"
        	for m in $(seq 1 $num_medicoes); do
        		if [[ $mode == "custom" ]];then
					resultado=$(mpirun --use-hwthread-cpus  --oversubscribe -np $np ./broadcast --array_size $a_size --root 0 --custom)
        		else
					resultado=$(mpirun --use-hwthread-cpus  --oversubscribe -np $np ./broadcast --array_size $a_size --root 0)
        		fi
        		csv_line="$csv_line"','"$resultado"
        	done
        	
        	csv_line="$csv_line"$'\n'

        	csv_out="$csv_out""$csv_line"
        done
    done
done

echo "$csv_out" > $OUTPUT_FILE

