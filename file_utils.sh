
# 该函数接受一个文件名作为输入，并返回一个附加了当前时间戳的唯一文件名
# @param string $fileName 输入的原始文件名
# @return string 返回附加了时间戳的唯一文件名
# 生成唯一文件名
genUniName() {
    local fileName=$1
    local timestamp=$(date +%Y%m%d%H%M)
    echo "${fileName}.${timestamp}"
}


# 该函数比较两个目录的内容差异
# @param string $dir1 第一个目录路径
# @param string $dir2 第二个目录路径
# @return int 当两个目录相同返回0，不同或其中一个不存在返回1
# 比较两个目录差异
diffDir() {
  local dir1="$1"
  local dir2="$2"

  # 当两个目录都不存在时，视为没有差异
  if [[ ! -d "$dir1" ]] && [[ ! -d "$dir2" ]]; then
    # echo "Both directories do not exist - no difference."
    return 0
  fi

  # 当其中一个目录不存在时，视为有差异
  if [[ ! -d "$dir1" ]] || [[ ! -d "$dir2" ]]; then
    # echo "Error: One of the directories does not exist."
    return 1
  fi

  # 包括比较内容
  if diff -rq "$dir1" "$dir2" > /dev/null; then
    # echo "Directories are identical."
    return 0
  else
    # echo "Directories differ."
    return 1
  fi
}

# 该函数比较两个文件的内容差异
# @param string $file1 第一个文件路径
# @param string $file2 第二个文件路径
# @return int 当两个文件内容相同返回0，不同或其中一个不存在返回1
# 比较两个文件差异
diffFile() {
  local file1="$1"
  local file2="$2"

  # 当两个文件都不存在时，视为没有差异
  if [[ ! -f "$file1" ]] && [[ ! -f "$file2" ]]; then
    # echo "Both files do not exist - no difference."
    return 0
  fi

  # 当其中一个文件不存在时，视为有差异
  if [[ ! -f "$file1" ]] || [[ ! -f "$file2" ]]; then
    # echo "Error: One of the files does not exist."
    return 1
  fi

  # 比较文件内容
  if diff -q "$file1" "$file2" > /dev/null; then
    # echo "Files are identical."
    return 0
  else
    # echo "Files differ."
    return 1
  fi
}










