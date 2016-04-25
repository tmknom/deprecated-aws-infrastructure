#!/bin/bash
#
# direnvの.envrcから読み込まれるスクリプト
#
# 静的にベタ書きする環境変数は.envrcに記述し、
# .envrcから導出可能な環境変数は本スクリプト経由で導出する。
#
# .envrcに記述すべき内容はenvrc.exampleを参照のこと。
#
#############################################################

PROJECT_ROOT=$(git rev-parse --show-toplevel)
MODULE_FILES="$PROJECT_ROOT/development/environment_variable/module/*"

for filepath in ${MODULE_FILES}
do
  source ${filepath}
done

