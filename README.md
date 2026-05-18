# Brotato Survivors

**Brotato × Vampire Survivors** 俯视角 Rogue-lite 生存竞技场射击游戏。

在波次竞技场中，用自动武器杀出重围——升级、购买、合成，从成百上千的怪物围攻中存活 20 波。

---

## 技术栈

- **引擎**：Godot 4.6.2
- **语言**：GDScript（纯，无 C#）
- **架构**：Autoload 驱动（EventBus → SaveSystem → DataRegistry → AudioManager → GameManager）
- **美术**：MVP 阶段全部程序化生成（ColorRect / draw_* 占位）
- **性能目标**：60 FPS @ 200+ 敌人 + 200+ 弹幕

## 开发进度

| 阶段 | 内容 | 状态 |
|------|------|------|
| 0 | 项目初始化 + 目录树 | ✅ |
| 1 | 核心框架 + 玩家 | ✅ |
| 2.1 | 武器 & 弹幕数据 Resource | ✅ |
| 2.2 | 弹幕基类 + 对象池 | ✅ |
| 2.3 | 武器基类 + 武器管理器 | ⏳ |
| 3 | 敌人系统 | ⏳ |
| 4 | 战斗系统 & 数值 | ⏳ |
| 5 | 商店系统 | ⏳ |
| 6 | UI 系统 | ⏳ |
| 7 | 主菜单 & 游戏流程 | ⏳ |
| 8 | 集成 & 核心循环 | ⏳ |
| 9 | 初始武器数据 | ⏳ |

## 项目结构

```
scenes/game/battle.tscn          # 战斗主场景（1200x1200 竞技场）
scripts/autoload/                 # 5 个全局单例
scripts/player/                   # 玩家 + 属性
scripts/weapons/                  # 武器系统
scripts/projectiles/              # 弹幕系统
scripts/enemies/                  # 敌人系统
scripts/systems/                  # 游戏系统
resources/                        # 数据 .tres 文件
```

## 快速开始

```bash
# 用 Godot 打开项目
godot --path . -d

# 或通过 Godot MCP
claude mcp add godot -- npx @coding-solo/godot-mcp
```

## 输入

| 操作 | 按键 |
|------|------|
| 移动 | WASD / 方向键 |
| 攻击 | 全自动 |

## 游戏设计

完整设计文档见 `F:\godot测试需求文档\GDD.md`

## 许可证

MIT
