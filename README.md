# 企业进销存智能管理系统

一个基于 Flask + 原生 JavaScript 的进销存管理系统。

## 技术栈

- **后端**：Python Flask + SQLAlchemy + SQLite
- **前端**：原生 HTML/CSS/JS（单页应用）
- **数据库**：SQLite（`backend/erp.db`，首次运行自动创建）

## 快速启动

```bash
# 1. 安装依赖
pip install flask flask-cors flask-sqlalchemy

# 2. 进入后端目录
cd backend

# 3. 启动服务
python app.py
```

浏览器打开 `http://localhost:5000`

## 功能模块

| 模块 | 说明 |
|------|------|
| 仪表盘 | 库存概览、预警、最近采购/销售 |
| 商品管理 | CRUD、CSV/Excel 批量导入、选择弹窗 |
| 供应商管理 | 供应商信息维护 |
| 客户管理 | 客户信息维护 |
| 采购订单 | 草稿→审批→付款→入库 全流程 |
| 销售订单 | 草稿→确认→收款→发货→完成 全流程 |
| 库存管理 | 实时库存、调拨、操作日志 |
| 退货管理 | 供应商退货、客户退货 |
| 报损报溢 | 商品损坏/溢余处理 |
| 分页功能 | 全部 GET 列表接口支持分页 |

## 项目结构

```
├── backend/
│   └── app.py          # Flask 后端（含所有 API 和数据模型）
├── frontend/
│   ├── index.html       # 前端 SPA（含所有页面和样式）
│   ├── order-detail-helper.js
│   └── so-helper.js
└── README.md
```

## API 说明

后端提供 RESTful API，所有 GET 列表接口支持分页：

- `GET /api/products?page=1&per_page=20`
- `GET /api/suppliers?page=1&per_page=20`
- 响应格式：`{data, total, page, per_page, total_pages}`

## 注意事项

- 首次运行会自动创建数据库并初始化演示数据
- 端口默认 5000，可在 `app.py` 末尾修改
- `.gitignore` 已排除数据库文件和缓存
