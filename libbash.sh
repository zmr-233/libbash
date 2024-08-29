#!/bin/bash

# 方案来源:
# https://stackoverflow.com/questions/2683279/how-to-detect-if-a-script-is-being-sourced
# 检测自身是否被source
(return 0 2>/dev/null) && LIBBASH_SOURCED="yes" || LIBBASH_SOURCED="no"

# 注意: 该变量是DotfilesConfigMaster的环境变量，应该由DotfilesConfigMaster设置
DOTFILES_CONFIG_MASTER_HOME=$HOME/DotfilesConfigMaster

# LIBBASH_HOME=$HOME/libbash # 用于存储libbash目录的路径

libfiles=() # 用于存储libbash目录下的所有文件名

# 检查环境变量LIBBASH_HOME是否已设置并且目录是否存在
if [ -z "$LIBBASH_HOME" ] || [ ! -d "$LIBBASH_HOME" ]; then
    # echo "LIBBASH_HOME is not set or directory does not exist"
    # echo "BASH_SOURCE[0] = ${BASH_SOURCE[0]}"
    LIBBASH_HOME=$(readlink -f $(dirname "${BASH_SOURCE[0]}"))
fi

# echo "LIBBASH_HOME: $LIBBASH_HOME" && exit 0

# 加载所有文件
for file in "$LIBBASH_HOME"/*; do
    fileName=$(basename "$file")
    if [[ "$fileName" == "libbash.sh" ]] || [[ "$fileName" == "README.md" ]] ; then
        continue
    fi
    # source "$file" # 不能使用source，否则会导致所有函数都被加载
    libfiles+=("$fileName")
done

# 打印数组内容
# INFO "libfiles in LIBBASH_HOME:"
# for filename in "${libfiles[@]}"; do
#     DEBUG "$filename"
# done
__generate_libbash_regfile() {
    if [ -z "$DOTFILES_CONFIG_MASTER_HOME" ]; then
        echo "DOTFILES_CONFIG_MASTER_HOME is not set"
        exit 1
    fi
    local TARGET="$DOTFILES_CONFIG_MASTER_HOME/regfiles/libbash.sh"
cat << 'XXMN' > $TARGET
#!/bin/bash

# VERSION: 1

libbash_info(){
    echo "是zmr封装了大量实用bash函数的脚本库"
}

libbash_deps(){
    echo "__predeps__ zsh"
}

libbash_check(){
    checkCfg "$HOME/libbash"
    return $?
}

libbash_install(){
genSignS "libbash" $INSTALL
cat << 'EOF' >> $INSTALL
MODULE_INFO "......正在安装libbash......"
INFO "libbash是无需安装的bash函数库"
EOF
genSignE "libbash" $INSTALL
}

XXMN

# 使用printf来安全地处理数组元素，确保每个元素被正确引用
local strLibfiles="${libfiles[*]}"
cat << XXMN >> $TARGET
libbash_config(){
# 加入配置文件更新映射
declare -A config_map=(
    ["."]=".zshrc"
    ["libbash"]="libbash.sh ${strLibfiles}"
)

add_configMap config_map

XXMN

cat << 'XXMN' >> $TARGET
# 配置文件 ./.zshrc 
genSignS proxy $TEMP/./.zshrc
cat << 'EOF' >> $TEMP/./.zshrc
# libbash库函数位置
export LIBBASH_HOME="~/libbash"

EOF
genSignE proxy $TEMP/./.zshrc

XXMN

{

echo '# 配置文件 libbash/libbash.sh'
echo "cat << 'PPAP' >> \$TEMP/libbash/libbash.sh"
cat "$LIBBASH_HOME/libbash.sh"
echo ""
echo 'PPAP'
echo ""

} >> $TARGET

for filename in "${libfiles[@]}"; do
{
echo "# 配置文件 libbash/$filename"
echo "cat << 'RTYU' >> \$TEMP/libbash/$filename"
cat "$LIBBASH_HOME/$filename"
echo ""
echo 'RTYU'
echo ""
} >> $TARGET
done 

echo "" >> $TARGET
echo "}" >> $TARGET
echo "" >> $TARGET

}

# 用来生成README.md
__generate_libbash_readme(){
    echo "# Libbash Function Documentation"
    echo ""
    echo '这是一个zmr封装了大量实用bash函数的脚本库，用于快速开发bash脚本；该libbash函数注释全面，上手使用非常方便；但是字如其名，只能用于bash脚本，在其他环境下不能直接source'
    echo ""
    echo '### 使用方法'
    echo ""
    echo '1. 克隆脚本库 `git clone https://github.com/zmr-233/libbash.git ~/libbash`'
    echo ""
    echo '2. 在脚本中引入 `source ~/libbash/libbash.sh`'
    echo ""
    echo '3. 可以手动运行`bash ~/libbash/libbash.sh -h`查看帮助'
    echo ""
    if command -v tree > /dev/null 2>&1; then
        echo '### 目录结构'
        echo ""
        echo '```'
        tree $LIBBASH_HOME | sed -E 's/ -> .*//'
        echo '```'
        echo ""
    fi
    echo '### 函数列表'
    echo ""

    # 遍历libfiles数组中的每个文件
    for filename in "${libfiles[@]}"; do
        echo "#### $filename:"
        echo "| Function | Description |"
        echo "|----------|-------------|"

        # 读取文件内容
        while IFS= read -r line || [[ -n "$line" ]]; do
            # 检查是否是函数定义行
            if [[ "$line" =~ ^[[:space:]]*([a-zA-Z0-9_]+)\(\) ]]; then
                # 提取函数名称
                functionName="${BASH_REMATCH[1]}"
                if [[ -n "$functionComment" ]]; then
                    # 输出Markdown表格行
                    echo "| \`$functionName\` | $functionComment |"
                    # 重置functionComment为空
                    functionComment=""
                fi
            elif [[ "$line" =~ ^#[[:space:]]*(.*) ]]; then
                # 提取注释作为函数描述
                functionComment="${BASH_REMATCH[1]}"
            fi
        done < "$LIBBASH_HOME/$filename"

        echo ""
    done
}

# 用来生成git提交的
__generate_libbash_git(){
    local GIT_DIR=$(mktemp -d -t LIBBASH_XXXXXX)
    # mkdir -p $GIT_DIR/libbash
    git clone git@github.com:zmr-233/libbash.git $GIT_DIR/libbash
    pushd $GIT_DIR/libbash > /dev/null
    {
        cat "$LIBBASH_HOME/libbash.sh"
    } > libbash.sh
    for filename in "${libfiles[@]}"; do
        {
            cat "$LIBBASH_HOME/$filename"
        } > $filename
    done
    {
        __generate_libbash_readme
    } > README.md
    git add -A
    git commit -m "update libbash"
    git push
    popd > /dev/null

    echo "cd $GIT_DIR/libbash"
    
}

if [[ $# -eq 0 ]] || [[ "$LIBBASH_SOURCED" == "yes" ]]; then
    # 只允许加载一次
    if [ -z "$LIBBASH_SOURCE_ONCE" ]; then
        for filename in "${libfiles[@]}"; do
            source "$LIBBASH_HOME/$filename"
        done
        LIBBASH_SOURCE_ONCE=yes
    else
        echo "WARN: LIBBASH has been sourced!"
    fi
else
    while [[ $# -gt 0 ]]; do
        case $1 in
            --gen-regfile)
                __generate_libbash_regfile
                shift
                ;;
            --gen-git)
                __generate_libbash_git
                shift
                ;;
            --gen-readme)
                __generate_libbash_readme
                shift
                ;;
            --gen-update)
                __generate_libbash_git
                __generate_libbash_regfile
                shift
                ;;
            *)
                echo "Unknown option: $1"
                shift
                ;;
        esac
    done
fi



