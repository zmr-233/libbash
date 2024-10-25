# 检查指定的命令是否存在于系统的路径中
# @param string $1 要检查的命令名
# @return 无返回值，如果命令不存在则将错误输出重定向到 /dev/null
# 检查命令是否存在
checkCmd(){ type $1 > /dev/null 2>&1; }


ISCONFIG="" # 用来判断是否需要跳过配置检查

# 根据ISCONFIG变量的值决定是否跳过配置文件或目录的存在性检查
# @param string $1 需要检查的文件或目录路径
# @return int 如果ISCONFIG为空并且文件或目录存在则返回0，否则返回1；如果ISCONFIG非空则直接返回0
# 检查配置文件或目录是否存在
checkCfg(){
    if [[ -z $ISCONFIG ]];then
        if [[ -e "$1" ]] || [[ -d "$1" ]] ;then
            return 0
        else
            return 1
        fi
    else
        return 0
    fi
}

# 执行一个倒计时，期间在命令行显示剩余时间
# @param int $1 倒计时的总秒数
# @return 无返回值，显示倒计时并在每秒更新一次显示
# 执行倒计时
countDown() {
    local tn=$1
    nECHO "YELLOW" "... "
    while [ $tn -ge 1 ]; do
        nECHO "YELLOW" "${tn} "
        sleep 1
        ((tn--))
    done
    nECHO "YELLOW" "0 ..."
    sleep 1
    echo ""
}

# =======================一个用于生成函数描述的模版=======================:

### 函数描述格式要求

# 1. **详细描述**（可选）：在函数定义上方，使用多行注释来提供对函数功能的详细描述。这些描述应该清晰地解释函数的行为、边界条件或其他复杂的细节。如果该函数十分简单，只写简短描述即可。

# 2. **简短描述**：在详细描述之后，紧接着在函数定义之前的最后一行使用注释提供一个简洁的语句，概括函数的基本作用。

# 3. **参数描述**：对每个参数进行描述，包括它的类型、用途和任何默认值。使用`@param`标签来标记这些行。如果没有参数，或者参数异常明显，比如`ECHO()`函数，就不需要参数描述了。

# 4. **返回值描述**：描述函数的返回值，包括类型和条件。使用`@return`标签来标记这行。

# ### 示例

# ```bash
# # 这个函数接受两个整数作为输入，并返回它们的算术和
# # @param int $num1 第一个整数
# # @param int $num2 第二个整数
# # @return int 返回两个数的和
# # 计算两个数的和
# sum() {
#     local num1=$1
#     local num2=$2
#     echo $((num1 + num2))
# }
# ```

# 这种格式调整保证了简短描述始终位于函数定义的最后一行注释，便于在生成README时提取。

# ========================================

# 请根据如上要求，用中文为如下的函数生成函数描述：


# # ==========加载.libbash函数库==========
# source test/libbash/libbash.sh
# if [ $? -ne 0 ]; then
#     echo "Unable to load libbash library"
#     read -p "Would you like to automatically clone libbash from GitHub? (y/n) " -n 1 -r
#     echo
#     if [[ $REPLY =~ ^[Yy]$ ]]; then
#         echo "Cloning libbash..."
#         git clone https://github.com/zmr-233/libbash/ test/libbash
#         if [ $? -ne 0 ]; then
#             echo "Error occurred during git clone operation"
#             exit 1
#         fi
#         echo "Attempting to source libbash again..."
#         source test/libbash/libbash.sh
#         if [ $? -ne 0 ]; then
#             echo "Unable to load libbash library after cloning"
#             exit 1
#         fi
#     else
#         echo "User declined to clone libbash. Exiting..."
#         exit 1
#     fi
# fi








