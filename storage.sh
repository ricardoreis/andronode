#!/bin/bash

# Internal Memory
arr=( $(find /storage -type d -name "com.termux" 2>/dev/null) )
arr+=( $(echo $HOME) )
echo ${arr[@]}
arrayname+=(element1 element2 elementN)
arrayname+=( $(find  -type d -name "com.termux" 2>/dev/null) )
echo ${arr[@]}
echo ${arr[-1]}



# Length 
len=${#arr[@]}
echo "Length of Array : $len"

json='{'

for i in "${arr[@]}"
do
    eval "$(df -Pk $i | awk 'NR==2 {printf "size=%d used=%d available=%d", $2, $3, $4}')"
    json+="\"$i\": {\"size\": $size,\"used\": $used,\"available\" : $available}"
   
    if [[ $i != ${arr[-1]} ]]; then
        json+=","
    fi   
done
json+='}'

echo $json



# 
size=$(df -Pk ~ | awk 'NR==2 {print $2}')  # in kB


# To set all the variables at once, you can make awk print a shell snippet.
eval "$(df -Pk ~ | awk 'NR==2 {printf "size=%d used=%d available=%d", $2, $3, $4}')"


df -Pk /storage/067B-8F1F/Android/data/com.termux | awk 'NR==2 {printf "size=%d used=%d available=%d", $2, $3, $4}'


# Json
{
  "/storage/000-000/": {
    "size": 5,
    "used": 1,
    "available" : 4
  },
  "/storage/000-111/": {
    "size": 5,
    "used": 1,
    "available" : 4
  }
}
