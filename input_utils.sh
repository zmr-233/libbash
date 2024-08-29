
# 此函数用于读取用户的yes/no输入，并根据输入返回相应的状态码
# @param string $prompt 提示信息
# @return int 根据用户输入返回0（yes）或1（no）
# 作为if条件
readReturn(){
    local prompt=$1
    local input

    while true; do
        INPUT "$prompt [y/n] default: y"
        read -r input

        if [ -z "$input" ]; then
            return 0
            break
        fi

        case $input in
            [yY][eE][sS]|[yY])
                return 0
                break
                ;;
            [nN][oO]|[nN])
                return 1
                break
                ;;
            *)
                WARN "请输入 yes 或 no"
                ;;
        esac
    done

}

# 此函数用于读取用户的yes/no输入，并将结果赋值给指定的变量
# @param string $varName 变量名
# @param string $prompt 提示信息
# 读取-yes/no
readBool() {
    local varName=$1
    local prompt=$2
    local input

    while true; do
        INPUT "$prompt [y/n] default: y"
        read -r input

        if [ -z "$input" ]; then
            eval "$varName=\"y\""
            break
        fi

        case $input in
            [yY][eE][sS]|[yY])
                eval "$varName=\"y\""
                break
                ;;
            [nN][oO]|[nN])
                eval "$varName=\"n\""
                break
                ;;
            *)
                WARN "请输入 yes 或 no"
                ;;
        esac
    done
}

# 此函数用于读取用户输入的一整行文本，并将结果赋值给指定的变量
# @param string $varName 变量名
# @param string $prompt 提示信息
# 读取输入-一整行
readLine() {
    local varName=$1
    local prompt=$2
    local input

    INPUT "LINE= $prompt"
    read -r input

    # 使用 eval
    eval "$varName=\"$input\""
    # 使用间接引用
    # printf -v "$varName" '%s' "$input"
}

# 此函数用于读取用户输入的文本，将其分割成数组，并赋值给指定的变量
# @param string $var_name 变量名
# @param string $prompt_message 提示信息
# 读取输入-数组
readArr() {
    local var_name=$1
    local prompt_message=$2
    local input

    # 使用提供的提示信息来读取输入
    INPUT "ARRAY= $prompt_message"
    read -r input

    # 将输入分割成数组并赋值给指定的变量
    IFS=' ' read -r -a "$var_name" <<< "$input"
}

# 此函数用于读取用户输入的文本，确保输入中不含空格或特殊字符，并将结果赋值给指定的变量
# @param string $varName 变量名
# @param string $prompt 提示信息
# 读取输入-无空格
readNoSpace() {
    local varName=$1
    local prompt=$2
    local input

    while true; do
        INPUT "NO_SPACE= $prompt"
        read -r input

        # 检查输入是否包含空格或特殊字符
        if [[ "$input" =~ [[:space:][:punct:]] ]]; then
            WARN "输入不能包含空格或特殊字符，请重新输入。"
        else
            break
        fi
    done

    # 使用 eval 动态设置变量名
    eval "$varName=\"$input\""
}

# 此函数用于读取用户输入的多行文本直到Ctrl+D，并将结果赋值给指定的变量
# @param string $varName 变量名
# @param string $prompt 提示信息
# 读取输入-多行直到Ctrl+D
readMultiLine() {
    local varName=$1
    local prompt=$2
    local result=""

    INPUT "<Ctrl-D>= $prompt"

    while IFS= read -r line; do
        result="${result}${line}"$'\n'
    done

    # 确保变量内容包含换行符并且未解析任何 $ 符号
    eval "$varName=\"\$result\""
}



