# CLAUDE.md — Brotato Survivors 项目专属规则

## 项目基础信息
- **项目名称**：Brotato Survivors
- **引擎版本**：Godot 4.6+（当前 4.6.2 stable）
- **开发语言**：GDScript（严禁 C#）
- **游戏类型**：俯视角 Rogue-lite 生存竞技场射击
- **目标平台**：PC（Windows/macOS/Linux）
- **游戏分辨率**：640×360（16:9，可缩放保持宽高比）

---

# 0. 总策划协作协议（最高优先级）

## 角色定义
- **你（编码者）**：本项目唯一开发人员，负责写代码、建场景、调通功能
- **总策划（规划者）**：另一个 AI，负责设计游戏、发布指令、审查结果
- **用户**：项目 owner，暴露项目文件给总策划

## 需求文档文件夹（只读）
```
F:\godot测试需求文档\
├── GDD.md              ← 游戏设计文档
├── PROJECT_STRUCTURE.md ← 目录结构 + 命名规范 + Autoload 顺序
├── DEV_PIPELINE.md      ← 开发流水线（阶段 0～10）
├── ART_ASSETS.md        ← 美术素材方案
└── Collaborate.md       ← 唯一可写文件！！！（协作沟通）
```

## 硬性规则

### 规则 A：Collaborate.md 是唯一可写文件
- 在 `F:\godot测试需求文档\` 中，**只能修改 Collaborate.md**
- GDD.md / PROJECT_STRUCTURE.md / DEV_PIPELINE.md / ART_ASSETS.md = **只读**，禁止修改

### 规则 B：总策划只读项目文件
- 总策划可以查看项目文件（`F:\godotProject\firsttest\`）但**不能修改**
- 你是唯一有权限修改项目文件的人

### 规则 C：按指令执行，不抢先
- 只能执行 `Collaborate.md` 中 `## 📋 当前指令` 标记为 `[待执行]` 的指令
- 无待执行指令时必须回复 `[等待指令]`
- 禁止同时执行多条指令

### 规则 D：必须验证
- 每条指令末尾有验证标准，必须逐条验证
- 验证结果写入 `Collaborate.md` 的 `## ✅ 验证结果` 区块
- FAIL 则立即停止，写入 `## ⚠️ 问题上报`

### 规则 E：保留全部对话历史
- Collaborate.md 中任何内容不得删除
- 完成的指令归档到 `## 📜 指令历史`
- 完成的报告归档到 `## 📜 报告历史`

### 规则 F：如实汇报
- 报告包含实际创建的文件路径列表
- Godot 报错必须复制完整错误信息
- 不确定时在问题上报区块提问，不猜测

### 规则 G：用户直接指令优先
- 当用户（project owner）直接给出指令时，优先执行用户指令
- 但仍需在 Collaborate.md 中记录执行情况

---

# 1. 项目目标

本项目是一个：

- 高代码量
- 低美术依赖（MVP 阶段 P0 全部程序化生成）
- 高可重复游玩性
- 类 Vampire Survivors + Brotato

的俯视角 Rogue-lite 竞技场生存游戏。

## 核心玩法循环

开始波次 → 击杀敌人 → 获得经验 → 升级选择（3选1/4选1）
    ↑                                                            ↓
    │          ← 商店购买 ← 波次结束 ←───────────────────
    └── 循环直到阵亡或通关 20 波 ────────────────────→ 元成长/新角色

---

# 2. 当前阶段

```txt
阶段 0：项目初始化（DEV_PIPELINE 0.1 + 0.2）
- 重构目录树以匹配设计方案
- 创建 5 个 Autoload
- 修改 project.godot（名称、分辨率、stretch）
下一步：阶段 1 — 核心框架 & 玩家
```

---

# 3. 目录结构（严格遵循 PROJECT_STRUCTURE.md）

```
F:\godotProject\firsttest\
├── project.godot
├── scenes/
│   ├── main.tscn              # 入口场景
│   ├── menu/
│   │   ├── main_menu.tscn
│   │   ├── character_select.tscn
│   │   ├── settings.tscn
│   │   └── game_over.tscn
│   ├── game/
│   │   ├── battle.tscn        # 战斗场景（核心）
│   │   ├── arena.tscn
│   │   └── shop.tscn
│   ├── entities/
│   │   ├── player.tscn
│   │   └── enemies/
│   └── ui/
│       ├── hud.tscn
│       ├── level_up_card.tscn
│       ├── level_up_screen.tscn
│       ├── shop_card.tscn
│       ├── shop_screen.tscn
│       ├── weapon_icon.tscn
│       └── floating_text.tscn
│
├── scripts/
│   ├── autoload/
│   │   ├── event_bus.gd       # 全局信号总线
│   │   ├── save_system.gd     # 存档系统
│   │   ├── data_registry.gd   # 数据注册表
│   │   ├── audio_manager.gd   # 音频管理
│   │   └── game_manager.gd    # 游戏状态管理
│   ├── player/
│   │   ├── player.gd
│   │   └── player_stats.gd
│   ├── weapons/
│   ├── projectiles/
│   ├── enemies/
│   ├── items/
│   ├── systems/
│   └── utils/
│
├── resources/
│   ├── characters/
│   ├── weapons/
│   ├── enemies/
│   ├── items/
│   ├── waves/
│   ├── curves/
│   └── themes/
│
└── assets/
    ├── sprites/
    ├── audio/
    └── fonts/
```

---

# 4. 编码规范

## 命名规范
- 脚本/场景/资源文件：`snake_case`
- 类名：`PascalCase`
- 变量/函数：`snake_case`
- Autoload 脚本名即全局单例名

## 类型安全（强制）
```gdscript
var health: float = 100.0       # 正确
var health = 100                # 禁止
```

## 信号优先
- 必须优先使用 signal，禁止轮询
- EventBus 是全局信号中心

## 注释规范
- 每个主要函数包含中文说明
- 类级注释说明职责

## 禁止事项
- 禁止 C#
- 禁止硬编码数值
- 禁止超大脚本（>500 行必须拆分）
- 禁止 God Object

---

# 5. Autoload 加载顺序

| # | 名称 | 路径 | 说明 |
|---|------|------|------|
| 1 | EventBus | scripts/autoload/event_bus.gd | 最底层，无依赖 |
| 2 | SaveSystem | scripts/autoload/save_system.gd | 依赖 EventBus |
| 3 | DataRegistry | scripts/autoload/data_registry.gd | 数据表 |
| 4 | AudioManager | scripts/autoload/audio_manager.gd | 依赖 EventBus |
| 5 | GameManager | scripts/autoload/game_manager.gd | 最上层 |

---

# 6. 性能规范
- 稳定 60 FPS（同屏 200+ 敌人 + 200+ 弹幕）
- 对象池管理所有可回收实体
- 禁止高频 new / instantiate

---

# 7. MVP 阶段约束
- **P0 美术：全部程序化生成**（draw_circle/rect，ColorRect 占位）
- **音效：jsfxr 生成**
- **字体：m5x7 或系统默认**

---

# 8. 已实现功能

```txt
当前：准备从 0 开始重构为 Brotato Survivors
（旧 Pixel Roguelike 代码将被替换）
```

---

# 9. Claude 工作流

1. 确认当前开发阶段
2. 按 DEV_PIPELINE 执行（用户直接指令优先）
3. 通过 Godot MCP 运行验证
4. 修复问题
5. 在 Collaborate.md 中汇报
6. 更新本文件"已实现功能"
