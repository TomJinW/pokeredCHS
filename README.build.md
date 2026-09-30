# 如何编译汉化

## 步骤零：环境准备（概览）

这里记载了编译汉化版 ROM 需要的依赖环境，有经验的用户可以自行安装相关依赖。

### Windows：
- 需要一个 Linux 环境。Windows 10 或以上推荐使用 [WSL](https://learn.microsoft.com/zh-cn/windows/wsl/install)（Windows Subsystem for Linux）。使用 WSL 的情况下，步骤和 Linux 环境下相同。
- 纯 Windows 环境下亦可以使用 [SnDream/rgbds-ws](https://github.com/SnDream/rgbds-ws) ，将完整的本仓库克隆到该环境中的 home 目录，再配合本仓库内的 _prepare-win32.sh 进行编译。该环境具体使用方法请参考 [SnDream/rgbds-ws](https://github.com/SnDream/rgbds-ws) 提供的使用教程。arm64 版 Windows 在该环境下为 x86_64 转译运行。

### macOS 和 Linux：
- git 和 make
- [原版 RGBDS 1.0.4](https://github.com/gbdev/rgbds/releases/tag/v1.0.4)（安装方式和从源代码编译时所需的依赖见 [官方说明](https://rgbds.gbdev.io/install/)）
-  python3 和 pip3
-  openpyxl

## 步骤一：安装环境
### Linux (以 Ubuntu 为例）：
- 更新源：

	```
	sudo apt update
	```
	
- 安装所需依赖：

	```
	sudo apt install git make gcc python3-pip
	```
	
- 安装 openpyxl，用于读取汉化 Excel 文件。
	
	```
	sudo pip3 install openpyxl
	```
	
- 安装 RGBDS 1.0.4：从 [v1.0.4 发布页](https://github.com/gbdev/rgbds/releases/tag/v1.0.4)获取适合系统架构的安装包，按照 [RGBDS 官方安装说明](https://rgbds.gbdev.io/install/)安装；没有适用安装包时，按官方说明从 v1.0.4 源代码编译。发行版软件包的版本可能不同，请安装后运行 `rgbasm --version` 确认是 1.0.4。
		
### macOS：
- 安装 Xcode Command Line Tools，如果安装了 Xcode ，可以跳过这个步骤。
	
	```
	xcode-select --install
	```
	
- 安装 [Homebrew](https://brew.sh) 包管理器，以用来安装其他软件。
	
	```
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	```

	- 如果已经安装过 [Homebrew](https://brew.sh) 包管理器，更新源。
	
		```
		brew update
		```

- 如果系统低于 macOS Ventura，还需要安装 python3。此操作会自动安装 pip3。
	
	```
	brew install python@3
	```

- 安装 openpyxl，用于读取汉化 Excel 文件。
	
	```
	pip3 install openpyxl
	```
	
- 安装 RGBDS 1.0.4：从 [v1.0.4 发布页](https://github.com/gbdev/rgbds/releases/tag/v1.0.4)获取适合 Mac 架构的安装包，并按照 [RGBDS 官方安装说明](https://rgbds.gbdev.io/install/)安装；也可以按官方说明从 v1.0.4 源代码编译。安装后运行 `rgbasm --version` 确认是 1.0.4。
		



## 步骤二：编译ROM

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

- 添加运行权限并运行：

	```
	chmod +x _prepare.command && ./_prepare.command
	```

	- 脚本会创建一个 buildRB(宝可梦红·蓝) 或 buildRGB (精灵宝可梦红·绿·蓝) 文件夹，会自动把代码复制到 buildRB/buildRGB 文件夹，脚本还会自动把汉化更改应用到 buildRB/buildRGB 文件夹中，并在 buildRB/buildRGB 文件夹中进行编译。

	- 最后看到「done」说明一切完成。

### 首次编译完成之后：

- 可以直接在 buildRB/buildRGB 文件夹里修改需要的部分并运行 make 来重新编译游戏，汉化版的修改已经应用于 buildRB/buildRGB 文件夹，所以可以不需要再运行 _prepare.command：

	```
	cd buildRB # 宝可梦 红·蓝
	cd buildRGB # 精灵宝可梦红·绿·蓝
	make
	```

## 查看编译 ROM

- 编译好的ROM的文件存档如图所示：

```
pokeredCHS/buildRB (宝可梦红·蓝)
│   Makefile
│   ...    
└───roms
│   └───rb （宝可梦版 红·蓝）
│ 	│ 	  pokered.gbc 			（宝可梦 红）
│ 	│ 	  pokered_vc.gbc		（宝可梦 红 VC修正版）
│ 	│ 	  pokered_debug.gbc		（宝可梦 红 Debug版）
│ 	│ 	  pokered.patch			（宝可梦 红 VC用补丁）
│ 	│ 	  pokeblue.gbc 			（宝可梦 蓝）
│ 	│ 	  pokeblue_vc.gbc		（宝可梦 蓝 VC修正版）
│ 	│ 	  pokeblue_debug.gbc		（宝可梦 蓝 Debug版）
│ 	│ 	  pokeblue.patch		（宝可梦 蓝 VC用补丁）

pokeredCHS/buildRGB (精灵宝可梦红·绿·蓝)
│   Makefile
│   ...    
└───roms
│   └───rgb （精灵宝可梦版 红·绿·蓝）
│ 	│ 	  pokered.gbc			（精灵宝可梦 红）
│ 	│ 	  pokered_vc.gbc		（精灵宝可梦 红 VC修正版）
│ 	│ 	  pokered_debug.gbc		（精灵宝可梦 红 Debug版）
│ 	│ 	  pokered.patch			（精灵宝可梦 红 VC用补丁）
│ 	│ 	  pokegreen.gbc			（精灵宝可梦 绿）
│ 	│ 	  pokegreen_vc.gbc		（精灵宝可梦 绿 VC修正版）
│ 	│ 	  pokegreen_debug.gbc		（精灵宝可梦 绿 Debug版）
│ 	│ 	  pokegreen.patch		（精灵宝可梦 绿 VC用补丁）
│ 	│ 	  pokeblue.gbc			（精灵宝可梦 蓝）
│ 	│ 	  pokeblue_vc.gbc		（精灵宝可梦 蓝 VC修正版）
│ 	│ 	  pokeblue_debug.gbc		（精灵宝可梦 蓝 Debug版）
│ 	│ 	  pokeblue.patch		（精灵宝可梦 蓝 VC用补丁）
└───────
```
	
- VC修正版 ROM 是生成 VC 补丁的副产物，无法在 3DS VC 中实现各种功能，**请务必不要在 3DS VC 中直接使用 VC 修正版 ROM，一定要使用原版 ROM + VC .patch 补丁。**
	
	
	
