###
 # @Descripttion: 
 # @version: V 1.0
 # @Author: wxw
 # @Date: 2020-10-18 21:36:58
### 
#!/usr/bin/env sh

# 确保脚本抛出遇到的错误
set -e

echo "拉取最新更新资源"
#  
git fetch

echo "全量拉取资源"

# 从git工作空间 提交到本地仓库
git  pull 

echo "拉取结束"
cd -