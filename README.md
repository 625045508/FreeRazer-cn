# FreeRazer 中文版

不用装雷云（Razer Synapse）就能改雷蛇鼠标按键的小工具。可以建多套配置、把配置关联到游戏，游戏在前台时自动把对应配置写到鼠标上。鼠标自己会记住最后一套配置，所以设好之后不需要一直挂着程序。

**非官方项目。** 本项目与雷蛇公司（Razer Inc.）无关，未获得其认可或支持。"Razer" 及各鼠标型号是其各自所有者的商标，此处仅用于说明兼容的硬件。项目不包含任何雷蛇代码、图形或标识。

**关于汉化：** 本仓库是 [JSa25/FreeRazer](https://github.com/JSa25/FreeRazer) 的简体中文分支，界面、提示、错误信息和安装程序都已汉化，功能与上游一致（版本 1.0.7）。鼠标型号名按上游保持英文，便于对照 OpenRazer 与 GitHub issue。安装包由 `build.ps1` 一键生成，安装界面为简体中文。

汉化工作由 **DeepSeek Harness** 完成：用它的代码工具链逐个字符串翻译 `freerazer.pyw` / `razer_switch.py`（共 336 处），修正了汉化引起的告警判定、配置名校验等耦合，再用 PyInstaller + Inno Setup 打包并逐页截图验收。

## 下载（不用自己编译）

到 [Releases](https://github.com/625045508/FreeRazer-cn/releases) 下载：

| 文件 | 用途 |
|---|---|
| `FreeRazerSetup.exe` | 安装程序（简体中文向导，装到当前用户，不需要管理员权限） |
| `FreeRazer.exe` | 单文件绿色版，双击即用（更适合放 U 盘） |
| `FreeRazerSetup.exe.sha256` | 安装包的校验值 |

## 功能

- 除左键外，任意按键都能改（左键保留，防止把自己锁在外面）：其它鼠标键、单键、组合键（如 Ctrl + S）、DPI 档位切换。
- 按键或组合键可以"按一下"直接录制。
- 每个游戏一套配置：关联游戏的 .exe，打开自动切换。
- 灵敏度（DPI）、回报率、休眠时间、低功耗模式。
- 支持的鼠标可调灯光：关闭、常亮、呼吸、彩虹，任意颜色（十六进制与 RGB 拾色）和亮度。
- 同时插了多只雷蛇鼠标时，可在标题栏选择要设置的那一只。
- 常驻系统托盘，可开机自启。
- 出错会写入 `%APPDATA%\FreeRazer\error.log`（设置 > 打开错误日志），窗口里也会提示。
- 配置保存在 `%APPDATA%\FreeRazer\profiles.json`。首次启动会把旧版本放在程序旁边的 `profiles.json` 复制过来（原文件保留作备份）。

和雷云可以共存：比如键盘还在用雷云时，雷云在后台不会动鼠标；但在雷云窗口里点开鼠标会写入雷云自己的设置，FreeRazer 会在 30 秒内发现并把你的设置写回去。

## 从源码运行

需要 Windows 和 Python 3.13（3.11+ 一般也可以）。

```bash
py -3.13 -m pip install hidapi pystray pillow
pyw -3.13 freerazer.pyw
```

命令行（`py -3.13 razer_switch.py ...`）：

| 命令 | 作用 |
|---|---|
| （无） / `list` | 列出配置 |
| `apply NAME` | 把某套配置写到鼠标 |
| `show` | 打印鼠标每个按键当前的绑定 |
| `auto` | 按前台程序自动切换配置 |
| `probe` | 只读报告，用于提交新鼠标 |
| `test` | 离线自检（不需要鼠标） |

## 打包 exe 与安装程序

需要 Python（含 `hidapi pystray pillow pyinstaller`）和 Inno Setup 6：

```bash
py -3.13 -m pip install hidapi pystray pillow pyinstaller
winget install JRSoftware.InnoSetup
```

一条命令生成 exe、安装包和安装包校验值（都在 `dist\`）：

```powershell
powershell -ExecutionPolicy Bypass -File build.ps1
```

`build.ps1` 会从 `freerazer.pyw` 的 `APP_VERSION` 取版本号，跑一遍自检，用 PyInstaller 打包 `FreeRazer.exe`，再用 Inno Setup 编译 `FreeRazerSetup.exe`。要用别的解释器，先设环境变量 `PYTHON`（例如 `$env:PYTHON='C:\path\to\python.exe'`）。

**安装：** 双击 `FreeRazerSetup.exe`。只装给当前用户（不需要管理员权限），装到 `%LOCALAPPDATA%\Programs\FreeRazer`，会加一条开始菜单项，也会出现在"设置 > 应用 > 已安装的应用"里，从那里可以卸载。装新版本会原地升级。

安装包默认包含简体中文界面（`ChineseSimplified.isl`，取自 Inno Setup 官方收集的社区翻译，放在本仓库根目录）。

## 支持的鼠标

## Supported mice

<details>
<summary>Supported mice (118)</summary>

Names and USB product IDs from [OpenRazer](https://github.com/openrazer/openrazer).

| Mouse | USB product ID |
|---|---|
| Abyssus 1800 | 0x0020 |
| Abyssus 2000 | 0x005E |
| Abyssus Elite (D.Va Edition) | 0x006A |
| Abyssus Essential | 0x006B |
| Abyssus V2 | 0x005B |
| Abyssus | 0x0042 |
| Atheris (Receiver) | 0x0062 |
| Basilisk Essential | 0x0065 |
| Basilisk Mobile (Receiver) | 0x00D4 |
| Basilisk Mobile (Wired) | 0x00D3 |
| Basilisk Ultimate (Receiver) | 0x0088 |
| Basilisk Ultimate | 0x0086 |
| Basilisk V2 | 0x0085 |
| Basilisk V3 35K | 0x00CB |
| Basilisk V3 Pro (Wired) | 0x00AA |
| Basilisk V3 Pro (Wireless) | 0x00AB |
| Basilisk V3 Pro 35K (Wired) | 0x00CC |
| Basilisk V3 Pro 35K (Wireless) | 0x00CD |
| Basilisk V3 Pro 35K Phantom Green Edition (Wired) | 0x00D6 |
| Basilisk V3 Pro 35K Phantom Green Edition (Wireless) | 0x00D7 |
| Basilisk V3 X HyperSpeed | 0x00B9 |
| Basilisk V3 | 0x0099 |
| Basilisk X HyperSpeed | 0x0083 |
| Basilisk | 0x0064 |
| Cobra HyperSpeed Receiver | 0x00DB |
| Cobra HyperSpeed | 0x00DA |
| Cobra Pro (Wired) | 0x00AF |
| Cobra Pro (Wireless) | 0x00B0 |
| Cobra | 0x00A3 |
| DeathAdder 1800 | 0x0038 |
| DeathAdder 2000 | 0x004F |
| DeathAdder 2013 | 0x0037 |
| DeathAdder 3.5G Black | 0x0029 |
| DeathAdder 3.5G | 0x0016 |
| DeathAdder 3500 | 0x0054 |
| DeathAdder Chroma | 0x0043 |
| DeathAdder Elite | 0x005C |
| DeathAdder Essential (2021) | 0x0098 |
| DeathAdder Essential (White Edition) | 0x0071 |
| DeathAdder Essential | 0x006E |
| DeathAdder V2 Lite | 0x00A1 |
| DeathAdder V2 Mini | 0x008C |
| DeathAdder V2 Pro (Wired) | 0x007C |
| DeathAdder V2 Pro (Wireless) | 0x007D |
| DeathAdder V2 X HyperSpeed | 0x009C |
| DeathAdder V2 | 0x0084 |
| DeathAdder V3 HyperSpeed (Wired) | 0x00C4 |
| DeathAdder V3 HyperSpeed (Wireless) | 0x00C5 |
| DeathAdder V3 Pro (Wired) | 0x00B6 |
| DeathAdder V3 Pro (Wired) | 0x00C2 |
| DeathAdder V3 Pro (Wireless) | 0x00B7 |
| DeathAdder V3 Pro (Wireless) | 0x00C3 |
| DeathAdder V3 | 0x00B2 |
| DeathAdder V4 Pro (Wired) | 0x00BE |
| DeathAdder V4 Pro (Wireless) | 0x00BF |
| Diamondback Chroma | 0x004C |
| HyperPolling Wireless Dongle | 0x00B3 |
| Imperator 2012 | 0x002F |
| Lancehead (Wired) | 0x0059 |
| Lancehead (Wireless) | 0x005A |
| Lancehead Tournament Edition | 0x0060 |
| Lancehead Wireless (Receiver) | 0x006F |
| Lancehead Wireless (Wired) | 0x0070 |
| Mamba 2012 (Wired) | 0x0024 |
| Mamba 2012 (Wireless) | 0x0025 |
| Mamba Chroma (Wired) | 0x0044 |
| Mamba Chroma (Wireless) | 0x0045 |
| Mamba Elite | 0x006C |
| Mamba Tournament Edition | 0x0046 |
| Mamba Wireless (Receiver) | 0x0072 |
| Mamba Wireless (Wired) | 0x0073 |
| Naga 2012 | 0x002E |
| Naga 2014 | 0x0040 |
| Naga Chroma | 0x0053 |
| Naga Epic Chroma (Wired) | 0x003E |
| Naga Epic Chroma (Wireless) | 0x003F |
| Naga Epic | 0x001F |
| Naga Hex (Red) | 0x0036 |
| Naga Hex V2 | 0x0050 |
| Naga Hex | 0x0041 |
| Naga Left Handed Edition 2020 | 0x008D |
| Naga Pro (Wired) | 0x008F |
| Naga Pro (Wireless) | 0x0090 |
| Naga Trinity | 0x0067 |
| Naga V2 HyperSpeed (Receiver) | 0x00B4 |
| Naga V2 Pro (Wired) | 0x00A7 |
| Naga V2 Pro (Wireless) | 0x00A8 |
| Naga X | 0x0096 |
| Naga | 0x0015 |
| Orochi (Wired) | 0x0048 |
| Orochi 2011 | 0x0013 |
| Orochi 2013 | 0x0039 |
| Orochi V2 (Bluetooth) | 0x0095 |
| Orochi V2 (Receiver) | 0x0094 |
| Ouroboros | 0x0032 |
| Pro Click (Receiver) | 0x0077 |
| Pro Click (Wired) | 0x0080 |
| Pro Click Mini (Receiver) | 0x009A |
| Pro Click V2 (Wired) | 0x00D0 |
| Pro Click V2 (Wireless) | 0x00D1 |
| Pro Click V2 Vertical Edition (Wired) | 0x00C7 |
| Pro Click V2 Vertical Edition (Wireless) | 0x00C8 |
| Taipan | 0x0034 |
| Viper 8KHz | 0x0091 |
| Viper Mini SE (Wired) | 0x009E |
| Viper Mini SE (Wireless) | 0x009F |
| Viper Mini | 0x008A |
| Viper Ultimate (Wired) | 0x007A |
| Viper Ultimate (Wireless) | 0x007B |
| Viper V2 Pro (Wired) | 0x00A5 |
| Viper V2 Pro (Wireless) | 0x00A6 |
| Viper V3 HyperSpeed | 0x00B8 |
| Viper V3 Pro (Wired) | 0x00C0 |
| Viper V3 Pro (Wireless) | 0x00C1 |
| Viper V3 Pro SE (Wired) | 0x00DE |
| Viper V3 Pro SE (Wireless) | 0x00DF |
| Viper V4 Pro | 0x00E6 |
| Viper | 0x0078 |

</details>

鼠标不在列表里？上游 README 里有提交方法：用"学习按键…"和"复制鼠标报告"生成报告，粘贴到 GitHub issue。

程序只读写按键绑定、DPI、回报率、节能（休眠时间、低功耗门槛）和灯光，不碰固件。每只鼠标能改什么来自鼠标数据库（`devices.json`），可在"设置 > 更新鼠标数据库"在线更新。

## 上游与致谢

- 原项目：[JSa25/FreeRazer](https://github.com/JSa25/FreeRazer)（MIT）
- 鼠标数据来自 [OpenRazer](https://github.com/openrazer/openrazer)
- 中文安装界面来自 Inno Setup 社区翻译

许可证沿用上游的 MIT，见 [LICENSE](LICENSE)。
