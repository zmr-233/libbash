# Libbash Function Documentation

这是一个zmr封装了大量实用bash函数的脚本库，用于快速开发bash脚本；该libbash函数注释全面，上手使用非常方便；但是字如其名，只能用于bash脚本，在其他环境下不能直接source

### 使用方法

1. 克隆脚本库到任意目录，例如 `git clone https://github.com/zmr-233/libbash.git /path/to/libbash`

2. 在脚本中引入 `source /path/to/libbash/libbash.sh`

3. 可以手动运行`bash /path/to/libbash/libbash.sh -h`查看帮助

### 目录结构

```
/home/zmr466/1_GitProject/Compiler/LycorisRecompile/scripts_utils
├── README.md
├── array_utils.sh
├── color_utils.sh
├── file_utils.sh
├── input_utils.sh
├── libbash.sh
├── others_utils.sh
├── regfile_template.sh
└── safe_utils.sh

1 directory, 9 files
```

### 函数列表

#### array_utils.sh:
| Function | Description |
|----------|-------------|
| `saveMap` | 保存关联数组到变量或文件 |
| `saveArr` | 保存普通数组到变量或文件 |
| `inArr` | 检查元素是否在数组中 |
| `strToArr` | 将字符串转换为数组 |
| `delFromArr` | 从数组中删除指定元素 |

#### color_utils.sh:
| Function | Description |
|----------|-------------|
| `nECHO` | 输出不换行的彩色文本 |
| `ECHO` | 输出彩色文本 |
| `INFO` | 输出信息级别的日志 |
| `WARN` | 输出警告级别的日志 |
| `ERROR` | 输出错误级别的日志 |
| `SUCCESS` | 输出成功信息 |
| `NOTE` | 输出注释信息 |
| `INPUT` | 输出输入提示信息 |
| `ABORT` | 输出中止操作信息 |
| `DEBUG` | 输出调试信息 |

#### file_utils.sh:
| Function | Description |
|----------|-------------|
| `genUniName` | 生成唯一文件名 |
| `diffDir` | 比较两个目录差异 |
| `diffFile` | 比较两个文件差异 |

#### input_utils.sh:
| Function | Description |
|----------|-------------|
| `readReturn` | 作为if条件 |
| `readBool` | 读取-yes/no |
| `readLine` | 读取输入-一整行 |
| `readArr` | 读取输入-数组 |
| `readNoSpace` | 读取输入-无空格 |
| `readMultiLine` | 读取输入-多行直到Ctrl+D |

#### others_utils.sh:
| Function | Description |
|----------|-------------|
| `checkCmd` | 检查命令是否存在 |
| `checkCfg` | 检查配置文件或目录是否存在 |
| `countDown` | 执行倒计时 |

#### regfile_template.sh:
| Function | Description |
|----------|-------------|
| `regfileTemplate` | 生成regfile模板函数 |

#### safe_utils.sh:
| Function | Description |
|----------|-------------|
| `_createBackup` | 创建文件或目录的备份 |
| `_createTarBackup` | 创建不包含父路径的tar备份 |
| `_checkSourceExists` | 检查源文件或目录是否存在 |
| `_checkTargetDirExists` | 检查目标目录是否存在 |
| `copySafe` | 安全复制文件 |
| `moveSafe` | 安全移动文件或目录 |
| `removeSafe` | 安全删除文件或目录 |
| `saveSafe` | 备份文件或目录 |
| `tarSafe` | 以tar格式安全备份文件或目录 |
| `operateMapFiles` | 操作映射中的文件 |

