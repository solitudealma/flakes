#!/usr/bin/env bash
# 脚本用法及参数: screenshot (1|2|3) {1-9} {1-9}
# 第一个参数为截图方案：
# 1 ) # 选区截图后发送剪切板
# 2 ) # 当前显示器全屏截图后直接发送剪切板
# 3 ) # 活动窗口截图后直接发送剪切板

## Add to hyprland windowrule config
# ===========================

# 质量初始化
quality=$2
pause_quality=$3

## 全屏暂停截图 简单对比
# 1. 质量 grim_quality  6 | pause_grim_quality 6 , 分辨率4k  time:screenshot 1  4.53s user 2.55s system 109% cpu 6.462 total
# 2. 质量 grim_quality  5 | pause_grim_quality 4 , 分辨率4k  time:screenshot 1  2.88s user 2.10s system 67% cpu 7.410 total

# 窗口截屏时留的边距
pos_lu=20 # lu: left up
pos_rd=40 # rd: right down

function focused_window {
  grim -l $quality -g "$(hyprctl activewindow -j \
    | gojq  -j '.at[0]-($gaps_lu | tonumber), ",", .at[1]-($gaps_lu | tonumber), " ", .size[0]+($gaps_rd | tonumber), "x", .size[1]+($gaps_rd | tonumber)' --arg gaps_lu $pos_lu --arg gaps_rd $pos_rd)" - \
    | satty -f - --copy-command wl-copy --early-exit
}

# 已使用 satty 替代
#function pause_focused_screen {
#  while true; do
#    if ! pgrep -f slurp > /dev/null; then # && ! pgrep -f grim > /dev/null
#       killall imv-wayland
#       break
#    fi
#  done &
#
#  grim -l $pause_quality -o $(hyprctl monitors -j | gojq '.[] | select(.focused == true) | .name' -r) - \
#    | imv -f -
#}

function take_fullscreen {
  if $EDIT; then
    grim -l $quality -g "$(slurp -b "#ef5b9c30" -d)" - \
      | satty -f - --copy-command wl-copy --early-exit
  else
    grim -l $quality -o "$(hyprctl monitors -j | gojq '.[] | select(.focused == true) | .name' -r)" - \
      | wl-copy
  fi
}

function take_select_edit {
  grim -l $quality -g "$(slurp -b "#ef5b9c30" -d)" - \
    | satty -f - --copy-command wl-copy --early-exit
}

function take_select {
  grim -l $quality -g "$(slurp -b "#ef5b9c30" -d)" - \
    | wl-copy
}


case $1 in
  1 ) # 选区截图后发送剪切板
    take_select
    ;;

  2 ) # 当前显示器全屏截图后直接发送剪切板
    EDIT=false

    take_fullscreen ;;

  3 ) # 活动窗口截图后直接发送剪切板
    focused_window
    ;;

  4 ) # 当前显示器全屏截图后编辑
    #EDIT=true
    #pause_focused_screen &
    #take_fullscreen
    grim -l 1 -o $(hyprctl monitors -j | gojq '.[] | select(.focused == true) | .name' -r) - \
      | satty -f - --fullscreen --init-tool crop --copy-command wl-copy --early-exit
    ;;
#  5 ) # 根据选区录屏
#    ;;
#  6 ) # 当前屏幕录屏
#    ;;
#  7 ）# 所有屏幕录屏
#    ;;
esac
