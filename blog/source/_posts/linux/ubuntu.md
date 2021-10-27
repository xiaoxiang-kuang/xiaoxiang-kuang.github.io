---
title: ubuntu
categories:
  - [linux]
site: linux
date: 2021-09-25 00:58:07
---

**记录使用ubuntu的一些发现**

* ~~提升体验的一个软件`apt install gnome-shell-extension-dash-to-panel;apt remove gnome-shell-extension-ubuntu-dock`重启之后在gnome-tweaks中打开该扩展即可。它类似于windows的状态栏，比之前ubuntu自带的收藏栏和状态栏分开的情况好多了，而且可定制的程度高~~。 此种方式下载的已经过时，在ubuntu20上会有bug，最新版本可以通过[GNOME Shell Extensions](https://extensions.gnome.org/)下载，该网站需要安装浏览器扩展插件、本地主机安装chrome-gnome-shell，安装完后和直接在该网站下载Dash to Panel即可。**参考链接：**[Installation · home-sweet-gnome/dash-to-panel Wiki · GitHub](https://github.com/home-sweet-gnome/dash-to-panel/wiki/Installation#ubuntu)
* `neofetch` 命令行显示系统信息、logo。 
* `ctrl + d` 文件夹添加到左边栏
* `gnome-screenshot --interactive --area` 截图
* `sudo apt install papirus-icon-theme` 好看的图标

* 创建一个桌面应用图标：

``` sh
#/usr/share/applications目录下
[Desktop Entry]
Name=Typora
Exec=/opt/Typora-linux-x64/Typora %f
Icon=/opt/Typora-linux-x64/resources/assets/icon/icon_256x256.png
Type=Application
```

[The Exec key](https://specifications.freedesktop.org/desktop-entry-spec/1.1/ar01s06.html)

