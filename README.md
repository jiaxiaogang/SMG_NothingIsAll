# he4o系统

> #### he4o是一个信息熵减机系统。
> 关键字:
> 1. 支持迁移学习为主，强化学习为辅。
> 2. 完善的知识表征：`稀疏码`、`特征`、`概念`、`时序`、`价值`。
> 3. 神经网络支持：动态、模糊,终身动态学习，知识网络遗传迭代。
> 4. 支持智能体自发动态常识获取问题（定义问题）。
> 4. 无论宏观框架还是微观细节设计,都依从相对与循环转化。
> 5. 支持感性与理性的递归决策。
> 6. 认知学习、决策行为、反思反省。
> 7. 数理：集合论。
> 8. 计算：使用最简单的bool运算：`类比`和`评价`。
>
> 手稿：<https://github.com/jiaxiaogang/HELIX_THEORY>  
> 网站：<http://www.jiaxiaogang.cn>

[![](https://img.shields.io/badge/%20QQGroup-528053635%20-orange.svg)](tencent://message/?uin=283636001&Site=&Menu=yes)
[![](https://img.shields.io/badge/%20QQ-在线交谈%20-orange.svg)](http://wpa.qq.com/msgrd?v=3&uin=283636001&site=qq&menu=yes)
[![](https://img.shields.io/badge/%20QQ-客户端交谈%20-orange.svg)](tencent://message/?uin=283636001&Site=&Menu=yes)
![](https://img.shields.io/badge/%20Wechat-17636342724%20-orange.svg)
[![License](https://img.shields.io/badge/license-GPL-blue.svg)](LICENSE)

### 1. -------------引言-------------

> 第一梯队:1950年图灵提出"可思考的机器"和"图灵测试",他说:"放眼不远的将来,我们就有很多工作要做";

> 第二梯队:1956达特矛斯会议后，明斯基和麦卡锡等等许多前辈穷其一生心血，虽然符号主义AI在面对不确定性环境下鲁棒性差，但却为AGI奠定了很多基础。

> 第三梯队:随着大数据,云计算等成熟,AI迎来DL热,但DL也并非全功能型智能体。

> 综上：近70年历史，人工智能研究经历跌宕起伏，但终是方兴未艾，he4o旨在以熵减机方式解决这一问题。

### 2. -------------目录-------------

<!-- TOC -->

- [he4o系统](#he4o系统)
  - [1. -------------引言-------------](#1--------------引言-------------)
  - [2. -------------目录-------------](#2--------------目录-------------)
  - [3. -------------（一）熵减机-------------](#3--------------一熵减机-------------)
  - [4. -------------（二）信息熵减机模型-------------](#4--------------二信息熵减机模型-------------)
  - [5. -------------（三）he4o系统实践-------------](#5--------------三he4o系统实践-------------)
  - [6. -------------时间线-------------](#6--------------时间线-------------)

<!-- /TOC -->

***

### 3. -------------（一）熵减机-------------

> 　　熵减机从2017年2月正式开始研究至2018年2月成熟，历时一年。

| ![](https://github.com/jiaxiaogang/HELIX_THEORY/blob/master/%E6%89%8B%E5%86%99%E7%AC%94%E8%AE%B0/assets/165_%E8%9E%BA%E6%97%8B%E8%AE%BALOGO.png?raw=true) |
| --- |
| 熵减机：其包含三大要素，分别为： 定义、相对和循环。 |
| https://github.com/jiaxiaogang/HELIX_THEORY#%E7%86%B5%E5%87%8F%E6%9C%BA |

<br>

### 4. -------------（二）信息熵减机模型-------------

> 信息熵减机理论模型在18年3月成熟，直至今天此模型仍在不断细化中。

| ![](https://github.com/jiaxiaogang/HELIX_THEORY/blob/master/%E6%89%8B%E5%86%99%E7%AC%94%E8%AE%B0/assets/267_%E4%BF%A1%E6%81%AF%E7%86%B5%E5%87%8F%E6%9C%BA%E6%A8%A1%E5%9E%8B_%E7%9B%B8%E5%AF%B9%E7%89%88.png?raw=true) |
| --- |
| 1. 从外到内,从内到外的双向,分别为:从动到静,从静到动（客观角度）。 |
| 2. 每外一个模块,与内所有模块之和相对循环 (如神经网络与思维,智能体与现实世界) |
| 注: 一切都是从无到有,相对与循环; |
| 注: he4o认为自己活着 `源于循环`; |

<br>

### 5. -------------（三）he4o系统实践-------------

> **V1.0《初版》：**  
> 　　`2017年2月`立项　－ `2018年10月21日`正式落地发布V1.0版本。  
> **V2.0《小鸟生存演示》：**  
> 　　`2018年11月`　－　`至今`　开发完成，第三轮测试训练中...

| 架构图 | ![](https://github.com/jiaxiaogang/HELIX_THEORY/blob/master/%E6%89%8B%E5%86%99%E7%AC%94%E8%AE%B0/assets/139_v2.0%E6%9E%B6%E6%9E%84%E5%9B%BE.png?raw=true) |
| --- | --- |
| 性能要求 | 可运行于单机终端 |
| 编程思想 | DOP (面向动态编程) |
| 架构设计 | 由熵减机理论展开成信息熵减机模型,再由信息熵减机模型展开为系统架构 `碰巧与大脑多有相似之处^_^` |
| 代码占比 | 内核代码中神经网络占30％,思维控制器占50%,其它（输入、输出等）共占20%; |
| 神经网络 | 神经网络的模型十字总结:`横向组与分,纵向抽具象`; |
| 思维控制器 | 由向性规则决定，每一种方向操作代表一种思维操作。 |

<br>

### 6. -------------时间线-------------

> ##### 2017.02.21 `耗时1个月`
> - 流程架构

> ##### 2017.03.21 `耗时1个月`
> - 分层架构

> ##### 2017.04.21 `耗时1个月`
> - 金字塔架构

> ##### 2017.05.21 `耗时1天`
> -  重绘了新版架构图; (AIFoundation)

> ##### 2017.05.22 `耗时10天`
> - OOP编程思想->数据语言 (OOP2DataLanguage)

> ##### 2017.06.01 `耗时40天`
> - 三维架构(参考笔记/AI/框架)

> ##### 2017.07.10 `耗时20天`
> - BrainTree(参考N3P7,N3P8)

> ##### 2017.08.02 `耗时20天`
> - MindValue

> ##### 2017.08.23 `耗时1个月`
> - 神经网络 (算法,抽具象网络)

> ##### 2017.09.20 `耗时50天`
> - DOP_面向数据编程
> - GNOP_动态构建网络

> ##### 2017.11.10 `耗时1个月`
> - 规则 (最简)

> ##### 2017.12.09 `耗时2个月`
> - 定义 (从0到1)

> ##### 2018.02.01 `耗时3个月`
> - 宏微 (前身是拆分与整合,宏微一体)

> ##### 2018.05.01 `耗时1个月`
> - 相对 (he4o实现定义,横向相对,纵向相对)

> ##### 2018.06.01 `耗时1个月`
> - 三层循环大改版 (mv循环,思维网络循环,智能体与现实世界循环)

> ##### 2018.07.01 `耗时1个月`
> - HELIX (定义、相对和循环呈现的螺旋型)

> ##### 2018.08.01 `耗时1个月`
> - MIL & MOL (重构中层动循环)

> ##### 2018.08.29 `耗时2个月`
> - MOL

> ##### 2018.10.20 `耗时0天`
> - 信息熵减机 (产生智能的环境)

> ##### 2018.10.21 `耗时0天`
> - v1.0.0 (he4o内核发布)

> ##### 2018.11.05 `规划耗时20天`
> - 势 (小鸟生存演示) (v2.0开始开发)

> ##### 2018.11.28 `耗时2个月`
> - 迭代神经网络 (区分动态时序与静态概念)

> ##### 2019.01.21 `耗时40天`
> - 迭代决策循环 （行为化等）

> ##### 2019.03.01 `耗时2个月`
> - 内类比 （与外类比相对）

> ##### 2019.05.01 `耗时1个月`
> - 优化性能——`XGWedis异步持久化` 和 `短时内存网络`

> ##### 2019.06.05 `写完耗时15天,调至可用性达到标准至45天`
> - v2.0一测－－小鸟训练——神经网络可视化v2.0

> ##### 2019.06.20 `耗时2个月`
> - v2.0版本基础测试改BUG 与 训练

> ##### 2019.08.25 `耗时1个月`
> - 理性思维——TIR迭代 (时序识别、时序预测、价值预判)

> ##### 2019.09.30 `耗时2个月`
> - 理性思维——TOR迭代 (行为化架构迭代、支持瞬时网络)

> ##### 2019.11.22 `耗时1个月`
> - 理性思维——反思评价

> ##### 2019.12.27 `持续3个月`
> - v2.0二测与规划性训练－－回归小鸟训练

> ##### 2020.02.20 `耗时18天`
> - 稀疏码模糊匹配

> ##### 2020.03.31 `耗时1个月`
> - 迭代外类比: 新增反向反馈类比 (In反省类比) (构建SP正负时序、应用SP于决策的MC中、迭代反思)

> ##### 2020.04.21 `耗时1个月`
> - 决策迭代：（根据`输入期短时记忆`使决策支持四模式）

> ##### 2020.05.15 `耗时20天`
> - 决策迭代：（根据`输出期短时记忆`使决策递归与外循环更好协作）

> ##### 2020.06.06 `耗时2个月`
> - v2.0三测与训练

> ##### 2020.06.28 `5天`
> - 决策迭代：PM理性评价

> ##### 2020.08.12 `耗时27天`
> - Out反省类比迭代 (DiffAnalogy)、生物钟(AITime)、PM理性评价迭代v2

> ##### 2020.09.01 `耗时1个月`
> - v2.0四测与训练

> ##### 2020.10.21 `耗时15天`
> - TIR_Alg支持多识别

> ##### 2020.11.07 `耗时1个月`
> - v2.0五测与训练

> ##### 2020.12.07 `耗时1个月`
> - AIScore评价器整理完善：`时序理性评价：FRS`、`稀疏码理性评价：VRS`

> ##### 2020.12.24 `耗时20天`
> - v2.0六测与训练 `多向飞行正常`

> ##### 2021.01.15 `至今`
> - In反省类比迭代 (DiffAnalogy) `迭代触发机制: 生物钟触发器`
