# 如何编译汉化

## 步骤零：环境准备（概览）

这里记载了编译汉化版 ROM 需要的依赖环境，有经验的用户可以自行安装相关依赖。

### Windows：
- 需要一个 Linux 环境。Windows 10 或以上推荐使用 WSL（Windows Subsystem for Linux）。
- 不提供纯 Windows 环境下的编译方式，敬请见谅。

### macOS 和 Linux：
- git
- [原版 RGBDS 0.6.1](https://rgbds.gbdev.io/install/) 或者 [SnDream 修改的 RGBDS 0.6.1](https://github.com/SnDream/rgbds/)（从源代码编译 RGBDS 需要以下依赖）
	-  libpng
	-  gcc
	-  bison
	-  pkg-config
-  python3 和 pip3
-  openpyxl

-  两个 rgbds 版本的区别：原版 rgbds 不支持多字节编码，所以源代码内的汉字必须使用RAW 的 16 进制硬编码，但好处是不需要魔改 rgbds。而改版 rgbds 支持了多字节编码，源代码可以直接嵌入汉字。代价就是需要自行编译改版 rgbds。对于最终编译出来的 ROM 来说，**两种方式没有任何区别**。
##步骤一：安装环境
### Linux (以 Ubuntu 为例）：

- 安装所需依赖：

	```
	sudo apt install git libpng-dev gcc bison pkg-config python3-pip
	```
	
- 安装 openpyxl，用于读取汉化 Excel 文件。
	
	```
	sudo pip3 install openpyxl
	```
	
- rgbds 安装选项	（在 1. 或 2. 中任选一个即可）
	1. 编译 [原版 RGBDS 0.6.1 ](https://rgbds.gbdev.io/install/)
 	
 		```
		git clone https://github.com/gbdev/rgbds && cd rgbds
		sudo make install
		```
		
	2. 编译 [SnDream 修改的 RGBDS 0.6.1](https://github.com/SnDream/rgbds/)
 		
 		```
		git clone https://github.com/SnDream/rgbds && cd rgbds
		make
		```
		对于修改版rgbds，编译完成之后保存好整个rgbds文件夹，将其重命名为rgbds-cn以便稍后使用。
		
### macOS：
- 安装 Xcode Command Line Tools，如果安装了 Xcode ，可以跳过这个步骤。
	
	```
	xcode-select --install
	```
	
- 安装 [Homebrew](https://brew.sh) 包管理器，以用来安装其他软件。
	
	```
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	```

- 如果系统低于 macOS Ventura，还需要安装 python3。此操作会自动安装 pip3。
	
	```
	brew install python@3
	```

- 安装 openpyxl，用于读取汉化 Excel 文件。
	
	```
	pip3 install openpyxl
	```
	
- rgbds 安装选项	（在 1. 或 2. 中任选一个即可）
	1. 安装 [原版 RGBDS 0.6.1 ](https://rgbds.gbdev.io/install/)
 	
 		```
		brew install rgbds
		```
		
	2. 编译 [SnDream 修改的 RGBDS 0.6.1](https://github.com/SnDream/rgbds/)
		- 安装编译依赖
 		
 			```
			brew install libpng bison pkg-config
			```
		- 编译改版 rgbds
 	
	 		```
			git clone https://github.com/SnDream/rgbds/ && cd rgbds
			```
			
			- （二选一）Intel 版本 Homebrew：
			
	 			```
				make BISON=/usr/local/opt/bison/bin/bison
				```
				
			- （二选一）Apple Silicon 版本 Homebrew：
			
	 			```
				make BISON=/opt/homebrew/opt/bison/bin/bison
				```
				
			- 由于 macOS 自带的 bison 无法用于编译 rgbds，为了保证不破坏其他 macOS App 的编译兼容性，编译 rgbds 时需要指定使用 Homebrew 安装的 bison ，根据 Mac 处理器种类的不同，Homebrew 安装的 bison 文件位置也会有所不同。

		- 编译完成之后保存好整个rgbds文件夹，将其重命名为rgbds-cn以便稍后使用。

##步骤二：编译ROM

### macOS 和 Linux

- 克隆代码仓库：

	```
	git clone https://github.com/TomJinW/pokeredCHS && cd pokeredCHS
	```
	
- 切换分支：
	- 要编译「宝可梦版 红·蓝」：

		```
		git checkout CHS_Mod
		```
		
	- 要编译仿日版「精灵宝可梦版 红·绿·蓝」：（注意大小写）

		```
		git checkout CHS_MOD_RGB
		```
- 如果打算使用 [SnDream 修改的 RGBDS 0.6.1](https://github.com/SnDream/rgbds/)，请将上一步编译好的 rgbds-cn 文件夹原样拷贝到 pokeredCHS 文件夹根目录里。类似如图所示：

	```
	pokeredCHS
	│   README.md
	│   ...    
	└───rgbds-cn
	│   │   rgbasm
	│   │   rgbfix
	│   │   rgbgfx
	│   │   rgblink
	│   │   ...
	│   └───
	└───
	```

- 添加运行权限并运行：

	```
	chmod +x _build.command _prepare.command && ./_prepare.command
	```

	- 提示「Which rgbds? Enter number and hit return.」时，输入1或者2并按下回车键选择。如果直接按下回车会默认使用选项1。
		1. Original RGBDS installed with the system：使用当前 shell 环境安装的原版rgbds。源代码中的汉化文本全部使用 RAW 16进制数据替换。因为原版 rgbds 不支持多字节文字编码。
		2. Modded RGBDS for CHINESE Characters in rgbds-cn ： 使用rgbds-cn文件夹中修改的rgbds。使用修改版 rgbds 直接支持源代码中使用汉化文本。
		
	- 看到「db Data Import complete. Press Return to proceed..」，此时汉化文本已通过对应形式替换到源代码中，请按回车继续进行编译操作。
	
	- 最后看到「Restore Backup?」提示是否将repo恢复到未加入汉化文本的状态，输入1或者2并按下回车键选择。如果直接按下回车会默认使用选项1。

## 查看编译 ROM

- 编译好的ROM的文件存档如图所示：

```
pokeredCHS
│   README.md
│   ...    
└───roms
│   └───rb （宝可梦版 红·蓝）
│ 	│ 	│ pokered.gbc 			（宝可梦 红）
│ 	│ 	│ pokered_vc.gbc		（宝可梦 红 VC修正版）
│ 	│ 	│ pokered_debug.gbc		（宝可梦 红 Debug版）
│ 	│ 	│ pokered.patch			（宝可梦 红 VC用补丁）
│ 	│ 	│ pokeblue.gbc 			（宝可梦 蓝）
│ 	│ 	│ pokeblue_vc.gbc		（宝可梦 蓝 VC修正版）
│ 	│ 	│ pokeblue_debug.gbc	（宝可梦 蓝 Debug版）
│ 	│ 	│ pokeblue.patch		（宝可梦 蓝 VC用补丁）
│   └───rgb （精灵宝可梦版 红·绿·蓝）
│ 	│ 	│ pokered.gbc			（精灵宝可梦 红）
│ 	│ 	│ pokered_vc.gbc		（精灵宝可梦 红 VC修正版）
│ 	│ 	│ pokered_debug.gbc		（精灵宝可梦 红 Debug版）
│ 	│ 	│ pokered.patch			（精灵宝可梦 红 VC用补丁）
│ 	│ 	│ pokegreen.gbc			（精灵宝可梦 绿）
│ 	│ 	│ pokegreen_vc.gbc		（精灵宝可梦 绿 VC修正版）
│ 	│ 	│ pokegreen_debug.gbc	（精灵宝可梦 绿 Debug版）
│ 	│ 	│ pokegreen.patch		（精灵宝可梦 绿 VC用补丁）
│ 	│ 	│ pokeblue.gbc			（精灵宝可梦 蓝）
│ 	│ 	│ pokeblue_vc.gbc		（精灵宝可梦 蓝 VC修正版）
│ 	│ 	│ pokeblue_debug.gbc	（精灵宝可梦 蓝 Debug版）
│ 	│ 	│ pokeblue.patch		（精灵宝可梦 蓝 VC用补丁）
└───────
```

- 实际文件名中还有额外的 .1 和 .2 扩展名，代表了编译过程中「Which rgbds? Enter number and hit return.」使用的选项。比如 pokeblue.1.gbc 使用的是  Original RGBDS installed with the system。
	
- VC修正版 ROM 是生成 VC 补丁的副产物，无法在 3DS VC 中实现各种功能，**请务必不要在 3DS VC 中直接使用 VC 修正版 ROM，一定要使用原版 ROM + VC .patch 补丁。**
	
	
	

