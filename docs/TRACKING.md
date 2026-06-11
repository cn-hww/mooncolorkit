# MoonColorKit 公开开发追踪

本文件用于记录比赛阶段的公开开发线索，便于后续在 GitHub / GitLink 上对应提交、工单和合并请求。

## 已完成

- 初始化 MoonBit 包结构和项目元信息。
- 建立 RGB / HEX / HSL 基础颜色模型。
- 建立亮度、对比度和可读文本色判断。
- 建立颜色混合、渐变、互补色和调色板生成。
- 建立主题组合模型和 CLI 演示。
- 建立 CI、Issue 模板、PR 模板和变更记录。

## 建议创建的工单

- `feature: 支持 HSV 与 CMYK 颜色空间`
- `feature: 增加 Design Token JSON 导出`
- `test: 补充色彩空间转换边界用例`
- `docs: 增加图表配色示例`

## 建议维护节奏

- 每次新增公开 API 后同步补测试。
- 每个阶段至少更新一次 `CHANGELOG.md`。
- 比赛报名或阶段检查前，手动同步 GitHub 与 GitLink。
