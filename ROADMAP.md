# MoonColorKit Roadmap

## 0.1.x 基础稳定期

- 完成 RGB、HEX、HSL、亮度、对比度和基础调色板 API。
- 补齐 CLI 示例、README、变更记录和协作模板。
- 保持 `moon test` 覆盖全部公开函数的典型路径和边界路径。

## 0.2.x 色彩空间扩展

- 增加 HSV / CMYK / Lab / LCH 的基础表示与转换。
- 增加 Delta E 色差估算，支持调色结果的可感知距离比较。
- 增加色盲模拟与安全配色检查，提升可访问性场景价值。

## 0.3.x 主题工程化

- 扩展 `Theme`，支持浅色 / 深色双主题、语义 token 和状态色。
- 增加 CSS variables、JSON token、Design Token Community Group 风格导出。
- 提供更完整的示例，覆盖数据图表、编辑器主题和终端配色。

## 长期方向

- 保持核心库零平台依赖。
- 在性能稳定后增加 benchmark 文档。
- 结合 MoonBit 包管理生态，沉淀成可复用的颜色算法基础件。
