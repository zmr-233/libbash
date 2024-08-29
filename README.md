# Libbash Documentation

这是一个zmr封装了大量实用bash函数的脚本库，用于快速开发bash脚本；该libbash函数注释全面，上手使用非常方便；但是字如其名，只能用于bash脚本，在其他环境下不能直接source

### 使用方法

1. 克隆脚本库 `git clone https://github.com/zmr-233/libbash.git ~/libbash`

2. 在脚本中引入 `source ~/libbash/libbash.sh`

3. 可以手动运行`bash ~/libbash/libbash.sh -h`查看帮助

### 目录结构

```
/home/zmr466/libbash
├── array_utils.sh
├── color_utils.sh
├── file_utils.sh
├── input_utils.sh
├── libbash.sh
├── others_utils.sh
└── safe_utils.sh

1 directory, 7 files
```

### 函数列表

#### array_utils.sh:
| Function | Description |
|----------|-------------|
|  | 保存关联数组到变量或文件 |
|  | 保存普通数组到变量或文件 |
|  | 检查元素是否在数组中 |
|  | 将字符串转换为数组 |
|  | 从数组中删除指定元素 |

#### color_utils.sh:
| Function | Description |
|----------|-------------|
|  | 输出不换行的彩色文本 |
|  | 输出彩色文本 |
|  | 输出信息级别的日志 |
|  | 输出警告级别的日志 |
|  | 输出错误级别的日志 |
|  | 输出成功信息 |
|  | 输出注释信息 |
|  | 输出输入提示信息 |
|  | 输出中止操作信息 |
|  | 输出调试信息 |

#### file_utils.sh:
| Function | Description |
|----------|-------------|
|  | 生成唯一文件名 |
|  | 比较两个目录差异 |
|  | 比较两个文件差异 |

#### input_utils.sh:
| Function | Description |
|----------|-------------|
|  | 作为if条件 |
|  | 读取-yes/no |
|  | 读取输入-一整行 |
|  | 读取输入-数组 |
|  | 读取输入-无空格 |
|  | 读取输入-多行直到Ctrl+D |

#### others_utils.sh:
| Function | Description |
|----------|-------------|
|  | 检查命令是否存在 |
|  | 检查配置文件或目录是否存在 |
|  | 执行倒计时 |
|  | 获得一套生成Dotfiles的模板 |

#### safe_utils.sh:
| Function | Description |
|----------|-------------|
|  | 创建文件或目录的备份 |
|  | 创建不包含父路径的tar备份 |
|  | 检查源文件或目录是否存在 |
|  | 检查目标目录是否存在 |
|  | 安全复制文件 |
|  | 安全移动文件或目录 |
|  | 安全删除文件或目录 |
|  | 备份文件或目录 |
|  | 以tar格式安全备份文件或目录 |
|  | 操作映射中的文件 |

