# CLAUDE.md — Brotato Survivors 项目专属规则

> **本文件存储在项目文件夹中，编码者每次启动时自动加载。**
> **规则优先级：本文件 > Collaborate.md 中的具体指令**

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

## 强制规则（编码者每次启动必须牢记）

### 规则 A：Collaborate.md 是唯一可写文件
- 在 `F:\godot测试需求文档\` 中，**只能修改 Collaborate.md**
- GDD.md / PROJECT_STRUCTURE.md / DEV_PIPELINE.md / ART_ASSETS.md = **只读**，禁止修改

### 规则 B：总策划只读项目文件
- 总策划可以查看项目文件（`F:\godotProject\firsttest\`）但**不能修改**
- 你是唯一有权限修改项目文件的人
- **你自己也仅能通过 Collaborate.md 中的指令来修改项目文件，不得擅自改动**

### 规则 C：按指令执行，不抢先
- 只能执行 `Collaborate.md` 中 `## 📋 当前指令` 标记为 `[待执行]` 的指令
- 无待执行指令时必须回复 `[等待指令]`
- 禁止同时执行多条指令
- 禁止预判下一步、禁止跨越 DEV_PIPELINE 的步骤顺序

### 规则 D：必须验证
- 每条指令末尾有验证标准，必须逐条验证
- 验证结果写入 `Collaborate.md` 的 `## ✅ 验证结果` 区块
- 格式为 `[PASS]` 或 `[FAIL]` + 描述
- FAIL 则立即停止，写入 `## ⚠️ 问题上报`，禁止继续执行

### 规则 E：保留全部对话历史，永不删除
- Collaborate.md 中任何内容**不得删除**，这是项目唯一的沟通日志
- 完成的指令归档到 `## 📜 指令历史`，加盖归档时间戳
- 完成的报告归档到 `## 📜 报告历史`，加盖归档时间戳
- 进度追踪表只更新状态和时间，不清除历史行
- 这确保任何时刻都可以回溯整个开发过程的决策链和执行记录

### 规则 F：如实汇报
- 报告包含实际创建/修改的文件路径列表（完整路径）
- Godot 报错必须复制完整错误信息（逐字复制，不可摘要）
- 不允许写"一切正常"而没有验证证据
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
阶段 3 进行中（等待步骤 3.3 指令）
- 步骤 3.1 已完成：EnemyData Resource + EnemyBase
- 步骤 3.2 已完成：EnemySpawner 敌人生成器
- 步骤 2.1 已完成：WeaponData + ProjectileData Resource
- 步骤 2.2 已完成：ObjectPool + ProjectileBase + ProjectilePool + projectile_default.tscn
- 步骤 2.3 已完成：WeaponBase + WeaponManager
- 阶段 1 已完成（0.1 + 0.2 + 1.1 + 1.2 + 1.3）
- 5 个 Autoload 就位
- 玩家系统就位（移动、受击、闪避、护甲、相机）
- 弹幕系统就位（数据类、基类、对象池）
- 武器系统就位（基类、管理器、6槽位）
下一步：敌人生成器（步骤 3.2）
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
阶段 0 + 1 已完成（2026-05-17）：
✅ project.godot — 名称、640×360、stretch canvas_items、输入映射
✅ 5 Autoload — EventBus, SaveSystem, DataRegistry, AudioManager, GameManager
✅ battle.tscn — 竞技场(1200×1200) + 实体容器 + 弹幕容器 + 拾取容器
✅ battle.gd — 战斗场景主控，arena_size 常量，clamp_to_arena()
✅ PlayerStats Resource — 19 属性完整定义
✅ player.gd — Input.get_vector 移动，闪避判定，护甲减伤，接触伤害
✅ player.tscn — CharacterBody2D + Circle碰撞 + PickupArea + Camera2D
✅ 目录树 — 30+ 目录按 PROJECT_STRUCTURE.md 创建
✅ 旧 Pixel Roguelike 代码已清理

阶段 2.1 已完成（2026-05-18）：
✅ WeaponData Resource — 15 属性 + 5 武器类型枚举 + 5 瞄准方式枚举
✅ ProjectileData Resource — 8 属性

阶段 2.2 已完成（2026-05-18）：
✅ ObjectPool — 通用对象池（init/acquire/release，池满复用最老实例）
✅ ProjectileBase — 弹幕基类（Area2D，飞行/碰撞/穿透/停用）
✅ ProjectilePool — 弹幕池管理器（按 scene_path 延迟创建多个池）
✅ projectile_default.tscn — 默认弹幕场景（ColorRect 8x8 占位）

阶段 2.3 已完成（2026-05-18）：
✅ WeaponBase — 武器基类（_attack分发 / _get_targets排序 / 属性修正）
✅ WeaponManager — 武器管理器（6槽位 / add/remove / EventBus信号）

阶段 3.1 已完成（2026-05-18）：
✅ EnemyData Resource — BehaviorType枚举(4值) + 11属性
✅ EnemyBase — 3种AI行为(chase/charge/ranged) + 受击/死亡/闪烁

阶段 3.2 已完成（2026-05-18）：
✅ EnemySpawner — 波次配额/间隔/解锁/加权随机/边沿生成
下一步：敌人数据资源文件 + 敌人对象池（步骤 3.3）
```

---

# 9. Claude 工作流

1. 确认当前开发阶段
2. 按 DEV_PIPELINE 执行（用户直接指令优先）
3. 通过 Godot MCP 运行验证
4. 修复问题
5. 在 Collaborate.md 中汇报
6. 更新本文件"已实现功能"
