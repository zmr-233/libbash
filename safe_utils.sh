
#==============================Safe系列==============================

# 用来控制是否发生备份的全局变量:
isMakeup=DO_MAKEUP

# 用于创建文件或目录的备份
# @param string $source 源文件或目录路径
# @param string $backupDir 备份目录路径
# @return void
# 创建文件或目录的备份
_createBackup() {
    if [[ "$isMakeup" == "NO_MAKEUP" ]]; then
        return 0
    fi
    local source=$1
    local backupDir=$2
    local backupName="$(date +%Y%m%d%H%M%S).$(basename "$source").bak"
    local target="$backupDir/$backupName"

    mkdir -p "$backupDir" || { ERROR "Could not create backup directory: $backupDir"; return 1; }
    cp -r "$source" "$target" || { ERROR "Could not create backup of $source"; return 1; }
    INFO "Backup created as $target"
}

# 用于创建不包含父路径的文件或目录的tar备份
# @param string $source 源文件或目录路径
# @param string $backupDir 备份目录路径
# @return void
# 创建不包含父路径的tar备份
_createTarBackup() {
    if [[ "$isMakeup" == "NO_MAKEUP" ]]; then
        return 0
    fi
    local source=$1
    local backupDir=$2
    local sourceBaseName=$(basename "$source")
    local sourceDirName=$(dirname "$source")
    local backupName="$(date +%Y%m%d%H%M%S).$sourceBaseName.tar.gz"

    # Convert backupDir to an absolute path
    mkdir -p "$backupDir" || { ERROR "Could not create backup directory: $backupDir"; return 1; }
    local absBackupDir=$(cd "$backupDir"; pwd)
    local target="$absBackupDir/$backupName"

    # Change to the directory containing the source to avoid including parent paths in the tar archive
    pushd "$sourceDirName" > /dev/null
    # echo "$(pwd) $target $sourceBaseName"
    tar -czf "$target" "./$sourceBaseName" || { ERROR "Could not create tar backup of $source"; popd > /dev/null; return 1; }
    popd > /dev/null
    
    INFO "Tar backup created as $target"
}

# 用于检查源文件或目录是否存在
# @param string $source 源文件或目录路径
# @return void
# 检查源文件或目录是否存在
_checkSourceExists() {
    local source=$1
    if [[ -z "$source" ]] || [[ ! -e "$source" ]]; then
        ERROR "The source does not exist: $source"
        return 1
    fi
    return 0
}

# 用于检查目标目录是否存在
# @param string $targetDir 目标目录路径
# @return void
# 检查目标目录是否存在
_checkTargetDirExists() {
    local targetDir=$1
    if [[ -z "$targetDir" ]] || [[ ! -d "$targetDir" ]]; then
        [[ "$2" ==  "NO_ECHO" ]] || ERROR "The target directory does not exist: $targetDir"
        return 1
    fi
    return 0
}

# 安全复制文件，如目标文件存在则备份
# @param string $sourceFile 源文件路径
# @param string $targetDir 目标目录路径
# @param string $backupSubdir 备份子目录路径（可选，默认为目标目录下的backup目录）
# @return void
# 安全复制文件
copySafe() {
    local sourceFile=$1
    local targetDir=$2
    local backupSubdir=${3:-$targetDir/backup}

    _checkSourceExists "$sourceFile" || return 1
    _checkTargetDirExists "$targetDir" "NO_ECHO" || mkdir -p "$targetDir" || return 1

    local targetFile="$targetDir/$(basename "$sourceFile")"

    if [ -f "$targetFile" ]; then
        _createBackup "$targetFile" "$backupSubdir" || return 1
    fi

    cp -r "$sourceFile" "$targetFile" && INFO "File $sourceFile has been copied to $targetFile"
}

# 安全移动文件或目录，如目标存在则备份
# @param string $source 源文件或目录路径
# @param string $targetDir 目标目录路径
# @param string $backupSubdir 备份子目录路径（可选，默认为目标目录下的backup目录）
# @return void
# 安全移动文件或目录
moveSafe() {
    local source=$1
    local targetDir=$2
    local backupSubdir=${3:-$targetDir/backup}

    _checkSourceExists "$source" || return 1
    _checkTargetDirExists "$targetDir" "NO_ECHO" || mkdir -p "$targetDir" || return 1

    local target="$targetDir/$(basename "$source")"

    if [[ -f "$target" ]] || [[ -d "$target" ]]; then
        _createBackup "$target" "$backupSubdir" || return 1
    fi

    mv "$source" "$target" && INFO "$source has been moved and overwritten at $target"
}

# 安全删除文件或目录，删除前备份
# @param string $source 源文件或目录路径
# @param string $backupDir 备份目录路径（可选，默认为backup目录）
# @return void
# 安全删除文件或目录
removeSafe() {
    local source=$1
    local backupDir=${2:-backup}

    _checkSourceExists "$source" || return 1

    _createBackup "$source" "$backupDir" || return 1
    rm -rf "$source" && INFO "Original $source has been removed."
}

# 备份文件或目录
# @param string $source 源文件或目录路径
# @param string $backupDir 备份目录路径（可选，默认为backup目录）
# @return void
# 备份文件或目录
saveSafe() {
    local source=$1
    local backupDir=${2:-backup}

    _checkSourceExists "$source" || return 1

    _createBackup "$source" "$backupDir"
}

# 以tar格式安全备份文件或目录
# @param string $source 源文件或目录路径
# @param string $backupDir 备份目录路径（可选，默认为backup目录）
# @return void
# 以tar格式安全备份文件或目录
tarSafe() {
    local source=$1
    local backupDir=${2:-backup}

    _checkSourceExists "$source" || return 1

    _createTarBackup "$source" "$backupDir"
}

# ==============================映射操作系列==============================


# declare -A config_map=(
#    ["."]=".zshrc .valgrindsh"
#    [".config/bat/syntaxes"]="valgrind.sublime-syntax"
# )
# declare -A workflow_map=(
#    ["."]="MODULE.cfg"
#    ["vsrc"]="*"
#    ["csrc"]="*"
# )
# 给一个像上面一样的映射，可以对映射中的文件进行保存/删除/移动/复制操作
# operateMapFiles move workflow_map "." "$WF/$SAVEN" "$WF/backup/$SAVEN"

# 对映射中的文件进行保存/删除/移动/复制操作
# @param string $operation 操作类型：save, remove, copy, move
# @param array $map_ref 文件映射引用
# @param string $src_prefix 源路径前缀
# @param string $dest_prefix 目标路径前缀
# @param string $backup_dir 备份目录
# @return void
# 操作映射中的文件
operateMapFiles() {
    local operation=$1  # 操作类型：save, remove, copy, move
    local map_ref=$2    # 引用workflow_map或init_map
    local src_prefix=$3 # 源路径前缀
    local dest_prefix=$4 # 目标路径前缀
    local backup_dir=$5  # 备份目录

    declare -n map=$map_ref

    for key in "${!map[@]}"; do
        if [[ "${map[$key]}" = "*" ]]; then
            case $operation in
                save|remove)
                    "${operation}Safe" "$dest_prefix/$key" "$backup_dir";;
                copy|move)
                    "${operation}Safe" "$src_prefix/$key" "$dest_prefix" "$backup_dir";;
            esac
        else
            eval "files=(${map[$key]})"
            for file in "${files[@]}"; do
                case $operation in
                    save|remove)
                        "${operation}Safe" "$dest_prefix/$key/$file" "$backup_dir";;
                    copy|move)
                        "${operation}Safe" "$src_prefix/$key/$file" "$dest_prefix/$key" "$backup_dir";;
                esac
            done
        fi
    done
}







