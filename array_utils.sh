
# 此函数用于将关联数组内容保存到变量或文件
# @param string $1 关联数组的名字
# @param string $2 可选，输出文件的路径
# @return void
# 保存关联数组到变量或文件
saveMap() {
    local -n __map__=$1
    local output=""
    output+="declare -A $1=("$'\n'
    for key in "${!__map__[@]}"; do
        output+="    [\"$key\"]=\"${__map__[$key]}\""$'\n'
    done
    output+=")"$'\n'

    if [ -n "$2" ]; then
        echo "$output" >> "$2"
    else
        echo "$output"
    fi
}

# 此函数用于将普通数组内容保存到变量或文件
# @param string $1 数组的名字
# @param string $2 可选，输出文件的路径
# @param string $3 可选，声明数组类型的标识（如 '-A' 用于关联数组）
# @return void
# 保存普通数组到变量或文件
saveArr() {
    local -n array=$1
    local output=""

    output+="declare $3 -a $1=("$'\n'
    for element in "${array[@]}"; do
        output+="\"$element\" "$'\n'
    done
    output+=")"$'\n'

    if [ -n "$2" ]; then
        echo "$output" >> "$2"
    else
        echo "$output"
    fi
}

# 此函数用于检查元素是否存在于数组中
# @param string $1 数组名
# @param mixed $2 要检查的元素
# @return bool 如果元素存在于数组中返回0，否则返回1
# 检查元素是否在数组中
inArr() {
    [ $# -eq 0 ] && {
        ERROR "argument error"
        exit 2
    }

    [ $# -eq 1 ] && return 0

    declare -n _arr="$1"
    declare v="$2"
    local elem

    for elem in "${_arr[@]}";do
        [ "$elem" == "$v" ] && return 0
    done

    return 1
}

# 此函数用于将字符串转换为数组
# @param string $1 目标数组的名字
# @param string $2 输入的字符串
# @return void
# 将字符串转换为数组
strToArr() {
    local var_name=$1
    local input=$2
    # 将输入分割成数组并赋值给指定的变量
    IFS=' ' read -r -a "$var_name" <<< "$input"
}

# 此函数用于从数组中删除指定的元素
# @param string $1 数组名
# @param mixed $2 要删除的元素
# @param string $3 可选，关联数组名，用于同步删除关联数组中的键
# @return void
# 从数组中删除指定元素
delFromArr() {
    [ $# -lt 2 ] || [ $# -gt 3 ] && {
        ERROR "argument error"
        exit 2
    }

    declare -n _arr="$1"
    declare v="$2"
    local tempArray=()

    for elem in "${_arr[@]}"; do
        if [[ "$elem" != "$v" ]]; then
            tempArray+=("$elem")
        fi
    done

    _arr=("${tempArray[@]}")

    # 如果传入了三个参数，则更新关联数组
    if [ $# -eq 3 ]; then
        declare -n _map="$3"
        unset _map["$v"]
        for elem in "${_arr[@]}"; do
            _map["$elem"]=1
        done
    fi
}










