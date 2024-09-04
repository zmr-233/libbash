# 该函数是用于生成DotfilesConfigMaster的配置文件模板
# 该函数与https://github.com/zmr-233/DotfilesConfigMaster深度相关
# 但是经过解耦合，可以不依赖该项目生成模板文件
# 使用样例： 以changeflow.sh为代表性样例

# # 生成regfile模板函数
# __generate_changeflow_regfile(){
#     # local SCRIPT_NAME='.changeflowrc'
#     local REG_NAME=changeflow
#     local REG_INFO='轻松切换和管理工作流的工具'
#     local REG_DEPS='zsh libbash'
#     local REG_CHECK="checkCfg \$HOME/.changeflowrc"
#     local REG_INSTALL=""
#     declare -A REG_CONFIG_MAP=(
#         ["."]=".zshrc .changeflowrc"
#     )
#     local ZSHRC_CONTENT=$(cat << 'EOM'
# # Alias for changeflow
# alias changeflow='bash ~/.changeflowrc'
# alias cflow=changeflow

# EOM
# )
#     local CHANGEFLOW_CONTENT=$(cat "$0")
#     declare -A REG_CONFIG_FILE_MAP=(
#         ["./.zshrc"]=$ZSHRC_CONTENT
#         ["./.changeflowrc"]=$CHANGEFLOW_CONTENT
#     )
#     local REG_UPDATE=""
#     local REG_UNINSTALL=""

#     regfileTemplate "$REG_NAME" "$REG_INFO" "$REG_DEPS" "$REG_CHECK" "$REG_INSTALL" REG_CONFIG_MAP REG_CONFIG_FILE_MAP "$REG_UPDATE" "$REG_UNINSTALL"
# }

# 生成regfile模板函数
regfileTemplate(){
    if [ -z "$DOTFILES_CONFIG_MASTER_HOME" ]; then
        echo "DOTFILES_CONFIG_MASTER_HOME is not set"
        exit 1
    fi
    local DOT_CFG_TEMP=$DOTFILES_CONFIG_MASTER_HOME/regfiles
    mkdir -p $DOT_CFG_TEMP

    local REG_NAME=$1
    local REG_INFO=$2
    local REG_DEPS=$3
    local REG_CHECK=${4:-"checkCmd $1; return \$?;"}
    local REG_INSTALL=$5
    local -n REG_CONFIG_MAP__=$6
    local -n REG_CONFIG_FILE_MAP__=$7
    local REG_UPDATE=${8:-""}
    local REG_UNINSTALL=${9:-""}

#========================== gen_info ========================== 
    if [ -z "$(echo -e "$REG_INFO" | tr -d '[:space:]')" ]; then
        WARN "介绍为空，默认填入---- no info ----"
        REG_INFO="---- no info ----"
    fi
    {
        echo "#!/bin/bash"
        echo ""
        echo "# VERSION: 1"
        echo ""
        echo "${1}_info(){"
        echo "    echo \"$REG_INFO\""
        echo "}"
    } >$DOT_CFG_TEMP/$1.sh

#========================== gen_deps ==========================
    if [ -z "$(echo -e "$REG_DEPS" | tr -d '[:space:]')" ]; then
        WARN "依赖项为空，默认返回空"
        REG_DEPS=""
    fi
    {
        echo ""
        echo "${1}_deps(){"
        echo "    echo \"__predeps__ $REG_DEPS\""
        echo "}"
    } >> $DOT_CFG_TEMP/$1.sh

#========================== gen_check ==========================
    {
        echo ""
        echo "${1}_check(){"
        echo "$REG_CHECK"
        echo "return \$?"
        echo "}"
    } >> $DOT_CFG_TEMP/$1.sh

#========================== gen_install ==========================
    if [ -z "$(echo -e "$REG_INSTALL" | tr -d '[:space:]')" ]; then
        WARN "安装命令为空，跳过"
    {
        echo ""
        echo "${1}_install(){"
        echo "genSignS \"$1\" \$INSTALL"
        echo "cat << 'EOF' >> \$INSTALL"
        echo "MODULE_INFO \"......正在安装${1}......\""
        echo "INFO \"${1}是无需安装的配置文件\""
        echo "EOF"
        echo "genSignE \"$1\" \$INSTALL"
        echo "}"
    } >> $DOT_CFG_TEMP/$1.sh
    else
    {
        echo ""
        echo "${1}_install(){"
        echo "genSignS \"$1\" \$INSTALL"
        echo "cat << 'EOF' >> \$INSTALL"
        echo "MODULE_INFO \"......正在安装${1}......\""
        echo "if ${1}_check; then"
        echo "    WARN \"${1}已经安装，不再执行安装操作\""
        echo "else"
        echo "$REG_INSTALL"
        echo "fi"
        echo "EOF"
        echo "genSignE \"$1\" \$INSTALL"
        echo "}"
    } >> $DOT_CFG_TEMP/$1.sh
    fi

#========================== gen_config ==========================
    {
        echo ""
        echo "${1}_config(){"
        echo "# 加入配置文件更新映射"
        saveMap REG_CONFIG_MAP__
        echo "add_configMap REG_CONFIG_MAP__"
    } >> $DOT_CFG_TEMP/$1.sh

    for key in ${!REG_CONFIG_MAP__[@]}; do
        for file in ${REG_CONFIG_MAP__[$key]}; do
            curconfigcmd=${REG_CONFIG_FILE_MAP__[$key/$file]}
            if [ -z "$(echo -e "$curconfigcmd" | tr -d '[:space:]')" ]; then
                WARN "该文件配置为空，默认写入一个换行符"
    {
    echo "# 配置文件 $key/$file 为空--默认写入一个换行符"
    echo "cat << 'EOF' >> \$TEMP/$key/$file"
    echo ""
    echo "EOF"
    }>> $DOT_CFG_TEMP/$1.sh

            else
    {
    echo "cat << 'XUVYP' >> \$TEMP/$key/$file"
    echo "$curconfigcmd"
    echo "XUVYP"
    }>> $DOT_CFG_TEMP/$1.sh
            fi
        done
    done

    echo "return 0" >> $DOT_CFG_TEMP/$1.sh
    echo "}" >> $DOT_CFG_TEMP/$1.sh

#========================== gen_update ==========================
    if [ -z "$(echo -e "$REG_UPDATE" | tr -d '[:space:]')" ]; then
        WARN "升级命令为空，跳过"
    else
    {
        echo ""
        echo "${1}_update(){"
        echo "genSignS \"$1\" \$UPDATE"
        echo "cat << 'EOF' >> \$UPDATE"
        echo ""
        echo "MODULE_INFO \"......正在升级${1}......\""
        echo "$REG_UPDATE"
        echo "EOF"
        echo "genSignE \"$1\" \$UPDATE"
        echo "}"
    }>>$DOT_CFG_TEMP/$1.sh
    fi

#========================== gen_uninstall ==========================
    if [ -z "$(echo -e "$REG_UNINSTALL" | tr -d '[:space:]')" ]; then
        WARN "卸载命令为空，跳过"
    else
    {
        echo ""
        echo "${1}_uninstall(){"
        echo "genSignS \"$1\" \$UNINSTALL"
        echo "cat << 'EOF' >> \$UNINSTALL"
        echo ""
        echo "MODULE_INFO \"......正在卸载${1}......\""
        echo "if ${1}_check; then"
        echo "$REG_UNINSTALL"
        echo "else"
        echo "    WARN \"${1}已经卸载，不再执行卸载操作\""
        echo "fi"
        echo "EOF"
        echo "genSignE \"$1\" \$UNINSTALL"
        echo "}"
    }>>$DOT_CFG_TEMP/$1.sh
    fi

#========================== 最终生成阶段 ==========================
    INFO "临时注册文件生成完毕，文件路径: $DOT_CFG_TEMP/$1.sh"
}


