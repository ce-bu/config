function array_handle()
{
    local var=$1
    local arr=$2
    local x="\${!${arr}[@]}"
    eval local keys=$x
    for k in $keys; do
        eval ${var}_${k}=\""\${${arr}[$k]}"\"
    done
}
