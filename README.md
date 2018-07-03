# DoubleCommander
GitHub clone of SVN repo http://svn.code.sf.net/p/doublecmd/code/ (cloned by http://svn2github.com/)

# 我追过的各种桌面工具
这里说的桌面工具指的资源管理器/文件管理器一类的工具。

- Clover：我最早知道 clover 还是公司秘书推荐的，clover 确实是一个好东西，个人认为是 Windows 自带的资源管理器的最佳、最完美的替代品。但 clover 委身商业公司之后，登录注册、广告推送不胜其烦，网上有说 3.0.406 这个版本是最后一个“干净”的版本（不需要登录注册，没有广告推送），喜爱 Clover 的同好建议安装这个版本。

- Explorer++：Explorer++ 是 Windows 资源管理器的开源增强，支持多个 tab 页面，能收藏常用的文件夹，是 Windows 资源管理器的一个很好的替代品，我修改过的版本也能很好地支持 tab 页面重用，但 Explorer++ 目前似乎开发停滞，或许在憋大招也不定。

- FreeCommander：FreeCommander 挺好用，它是一个自由软件，但并不开源，因此，没有办法按自己的想法添加特性。

- DoubleCommander：DoubleCommander 官方通常缩写为 DC，首次使用时并不起眼，Windows 下默认的界面也很糙，但经过配置后，其界面也可以变得很亮丽的，开源，各种功能很强大，我还在探索中。


# 我对 DC 的修改
- 增强对 tab 页面的重用：只要勾上了“尽可能重复使用现在标签”，则总是重复使用现有标签，原作者仅对“锁定在新标签打开的文件夹”操作时才尽可能重复使用现在标签，不知是否故意为之。
- 文件浏览面板中，选择文件（或目录）后，在弹出的右键菜单中加入“复制包含完整路径的文件名到剪贴板”，以方便拷贝文件全路径。
- （实验特性）将历史打开的文件夹加入到特殊文件夹中，这样使得ctrl-d 能够快速打开历史文件夹，ctrl-d 有目录文件树功能异常强大。
- （实验特性）文件浏览面板中，按 @ 弹出特殊文件夹操作菜单，等同于 ctrl-d。初步尝试似乎 @ 这个键并不太容易操作，未必比 ctrl-d 好使。
- （实验特性，进行中）文件浏览面板中，按若干个字符就能选择到某个文件，这是已有的功能，比如，按 bu 就很有可能选择到 build.bat 这个文件，如果要对这个选中的文件进行操作的话，现在通常的做法是双击打开，或者鼠标右键弹出 context 菜单。现在尝试通过输入 # 键，通过已经定义好的各种 # 命令进行各种操作，如 #np 则使用 notepad++ 来打开，#vim 则使用 vim 来打开

# Screenshot
