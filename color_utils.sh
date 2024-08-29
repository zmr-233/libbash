
#====   Colorized variables  ====
if [[ -t 1 ]]; then # is terminal?
  BOLD="\e[1m";      DIM="\e[2m";
  RED="\e[0;31m";    RED_BOLD="\e[1;31m";
  YELLOW="\e[0;33m"; YELLOW_BOLD="\e[1;33m";
  GREEN="\e[0;32m";  GREEN_BOLD="\e[1;32m";
  BLUE="\e[0;34m";   BLUE_BOLD="\e[1;34m";
  GREY="\e[37m";     CYAN_BOLD="\e[1;36m";
  RESET="\e[0m";
fi

#====   Colorized functions  ====

# 为输出的文本提供颜色，以增强可读性和视觉区分
# 定义一系列颜色变量，用于在支持颜色的终端中显示彩色文本

# 在不换行的情况下输出带颜色的文本
# @param string $1 颜色变量名
# @param string $2 要输出的文本
# 输出不换行的彩色文本
nECHO(){ echo -n -e "${!1}${2}${RESET}"; }

# 输出带颜色的文本
# @param string $1 颜色变量名
# @param string $2 要输出的文本
# 输出彩色文本
ECHO() { echo -e "${!1}${2}${RESET}"; }

# 输出带有[INFO]前缀的绿色加粗文本
# @param string $1 要输出的信息文本
# 输出信息级别的日志
INFO(){ echo -e "${GREEN_BOLD}[INFO] ${1}${RESET}"; }

# 输出带有[WARNING]前缀的黄色加粗文本
# @param string $1 要输出的警告文本
# 输出警告级别的日志
WARN() { echo -e "${YELLOW_BOLD}[WARNING] ${1}${RESET}"; }

# 输出带有[ERROR]前缀的红色加粗文本
# @param string $1 要输出的错误文本
# 输出错误级别的日志
ERROR() { echo -e "${RED_BOLD}[ERROR] ${1}${RESET}"; }

# 输出带有[SUCCESS]前缀的绿色加粗文本
# @param string $1 要输出的成功文本
# 输出成功信息
SUCCESS() { echo -e "${GREEN_BOLD}[SUCCESS] ${1}${RESET}"; }

# 输出带有[NOTE]前缀的蓝色加粗文本
# @param string $1 要输出的注释文本
# 输出注释信息
NOTE() { echo -e "${BLUE_BOLD}[NOTE] ${1}${RESET}"; }

# 以青色加粗文本形式输出输入提示
# @param string $1 要输出的输入提示文本
# 输出输入提示信息
INPUT() { echo -e "${CYAN_BOLD}==INPUT==${1}${RESET}"; }

# 输出带有[ABORT]前缀的红色加粗文本，表示中止操作
# @param string $1 要输出的中止信息文本
# 输出中止操作信息
ABORT(){ echo -e "${RED_BOLD}[ABORT] ${1}${RESET}"; }

# 输出带有[DEBUG]前缀的黄色文本，用于调试信息
# @param string $1 要输出的调试信息文本
# 输出调试信息
DEBUG(){ echo -e "${YELLOW}[DEBUG] ${1}${RESET}"; }







