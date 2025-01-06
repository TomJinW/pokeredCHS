# 如何编译汉化

## 步骤零：环境准备（概览）

这里记载了编译汉化版 ROM 需要的依赖环境，有经验的用户可以自行安装相关依赖。

### Windows：
- 需要一个 Linux 环境。Windows 10 或以上推荐使用 WSL（Windows Subsystem for Linux）。
- 不提供纯 Windows 环境下的编译方式，敬请见谅。

### macOS 和 Linux：
- git
- rsync
- [原版 RGBDS 0.6.1 - 0.7.0](https://rgbds.gbdev.io/install/) （从源代码编译 RGBDS 需要以下依赖）
	-  libpng
	-  gcc
	-  bison
	-  pkg-config
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
	sudo apt install git gcc python3-pip
	```
	
- 安装 openpyxl，用于读取汉化 Excel 文件。
	
	```
	sudo pip3 install openpyxl
	```
	
- rgbds 安装选项
	-  （仅限 x86_64）从 Github Release 上下载原版 RGBDS 0.7.0，文件名为：  [rgbds-0.7.0-linux-x86_64.tar.xz](https://github.com/gbdev/rgbds/releases/tag/v0.7.0)
	- arm64 Linux 需要自行从源代码编译 RGBDS 并安装。[前往这里](https://rgbds.gbdev.io/install/source)查看官方教程。

 	
 		```
		# 创建解压目录
		mkdir rgbds

		# 解压下载好的文件到 rgbds 目录
		tar -xvf rgbds-0.7.0-linux-x86_64.tar.xz -C rgbds

		# 切换到目录
		cd rgbds

		# 使用管理员密码安装 rgbds
		sudo ./install.sh
		```
		
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
	
- rgbds 安装选项

	1.  从 Github Release 上下载原版 RGBDS 0.7.0，文件名为：  [rgbds-0.7.0-macos-x86_64.zip
](https://github.com/gbdev/rgbds/releases/tag/v0.7.0) 目前 rgbds 0.7.0 预编译包仅有 x86_64 版，Apple Silicon Mac （arm64）通过 Rosetta 2 转译运行。 

		- 如果需要原生 arm64 版 rgbds，你可以：

			1. [前往这里下载](https://tomjinw.github.io/download/rgbds-0.7.0.macUniversal.zip) 本人编译的 arm64 Mac 版 rgbds，文件名为：rgbds-0.7.0.macUniversal.zip。
			2. 使用源代码自行编译 rgbds，[前往这里](https://rgbds.gbdev.io/install/source)查看官方教程。
 	
	3. 下载好压缩包之后：

 		```
		# 双击 zip 文件自动解压，并切换到解压后目录：
		cd rgbds-0.7.0-macos-x86_64

		# 或者如果下载的是本人编译的 arm64 Mac 版 rgbds：
		cd rgbds-0.7.0-macos-arm64

		# 可恶的 macOS GateKeeper 会默认阻止来源不明的 App，需要删除 App 的 com.apple.quarantine 属性。
		xattr -d com.apple.quarantine rgbasm
		xattr -d com.apple.quarantine rgbgfx
		xattr -d com.apple.quarantine rgblink
		xattr -d com.apple.quarantine rgbfix

		# 使用管理员密码安装 rgbds
		sudo ./install.sh
		```
		



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
│ 	│ 	  pokeblue_debug.gbc	（宝可梦 蓝 Debug版）
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
│ 	│ 	  pokegreen_debug.gbc	（精灵宝可梦 绿 Debug版）
│ 	│ 	  pokegreen.patch		（精灵宝可梦 绿 VC用补丁）
│ 	│ 	  pokeblue.gbc			（精灵宝可梦 蓝）
│ 	│ 	  pokeblue_vc.gbc		（精灵宝可梦 蓝 VC修正版）
│ 	│ 	  pokeblue_debug.gbc	（精灵宝可梦 蓝 Debug版）
│ 	│ 	  pokeblue.patch		（精灵宝可梦 蓝 VC用补丁）
└───────
```
	
- VC修正版 ROM 是生成 VC 补丁的副产物，无法在 3DS VC 中实现各种功能，**请务必不要在 3DS VC 中直接使用 VC 修正版 ROM，一定要使用原版 ROM + VC .patch 补丁。**
	
	
	

