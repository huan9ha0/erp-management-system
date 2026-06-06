-- ============================================
-- 企业进销存智能管理系统 - 数据库建表脚本
-- 数据库: SQLite
-- 生成时间: 2026-06-06
-- ============================================

PRAGMA foreign_keys = ON;

-- ----------------------------------------
-- 1. 供应商表
-- ----------------------------------------
CREATE TABLE IF NOT EXISTS suppliers (
    id                  INTEGER PRIMARY KEY AUTOINCREMENT,
    name                VARCHAR(100) NOT NULL,          -- 供应商名称
    contact_person      VARCHAR(50),                    -- 联系人
    phone               VARCHAR(20),                    -- 联系电话
    email               VARCHAR(100),                   -- 邮箱
    address             VARCHAR(200),                   -- 地址
    rating              INTEGER DEFAULT 3,              -- 评级(1-5)
    cooperation_history TEXT,                           -- 合作历史
    created_at          DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ----------------------------------------
-- 2. 客户表
-- ----------------------------------------
CREATE TABLE IF NOT EXISTS customers (
    id             INTEGER PRIMARY KEY AUTOINCREMENT,
    name           VARCHAR(100) NOT NULL,               -- 客户名称
    contact_person VARCHAR(50),                         -- 联系人
    phone          VARCHAR(20),                         -- 联系电话
    email          VARCHAR(100),                        -- 邮箱
    address        VARCHAR(200),                        -- 地址
    region         VARCHAR(50),                         -- 所在区域
    created_at     DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ----------------------------------------
-- 3. 商品表
-- ----------------------------------------
CREATE TABLE IF NOT EXISTS products (
    id             INTEGER PRIMARY KEY AUTOINCREMENT,
    code           VARCHAR(50) UNIQUE NOT NULL,         -- 商品编码
    name           VARCHAR(100) NOT NULL,               -- 商品名称
    category       VARCHAR(50),                         -- 商品类别
    model          VARCHAR(100),                        -- 型号
    manufacturer   VARCHAR(100),                        -- 生产厂商
    unit           VARCHAR(20) DEFAULT '个',            -- 单位
    purchase_price FLOAT DEFAULT 0,                     -- 采购参考价
    sale_price     FLOAT DEFAULT 0,                     -- 销售单价
    safety_stock   INTEGER DEFAULT 10,                  -- 安全库存量
    created_at     DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ----------------------------------------
-- 4. 实时库存表
-- ----------------------------------------
CREATE TABLE IF NOT EXISTS inventory (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    product_id INTEGER UNIQUE NOT NULL,                 -- 商品ID(一对一)
    quantity   INTEGER DEFAULT 0,                       -- 当前库存数量
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- ----------------------------------------
-- 5. 库存变动日志表
-- ----------------------------------------
CREATE TABLE IF NOT EXISTS inventory_logs (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    product_id      INTEGER NOT NULL,                   -- 商品ID
    change_type     VARCHAR(20),                        -- 变动类型: purchase_in/sales_out/adjust
    change_quantity INTEGER NOT NULL,                   -- 变动数量(正=入库,负=出库)
    before_quantity INTEGER,                            -- 变动前库存
    after_quantity  INTEGER,                            -- 变动后库存
    reference_no    VARCHAR(50),                        -- 关联单号
    remark          VARCHAR(200),                       -- 备注
    created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- ----------------------------------------
-- 6. 采购订单表
-- ----------------------------------------
CREATE TABLE IF NOT EXISTS purchase_orders (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    order_no     VARCHAR(50) UNIQUE NOT NULL,           -- 订单编号
    supplier_id  INTEGER NOT NULL,                      -- 供应商ID
    status       VARCHAR(20) DEFAULT 'draft',           -- draft/approved/paid/received/cancelled
    total_amount FLOAT DEFAULT 0,                       -- 总金额
    remark       VARCHAR(200),                          -- 备注
    created_at   DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at   DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(id)
);

-- ----------------------------------------
-- 7. 采购订单明细表
-- ----------------------------------------
CREATE TABLE IF NOT EXISTS purchase_order_items (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id   INTEGER NOT NULL,                        -- 采购订单ID
    product_id INTEGER NOT NULL,                        -- 商品ID
    quantity   INTEGER NOT NULL,                        -- 采购数量
    unit_price FLOAT NOT NULL,                          -- 采购单价
    subtotal   FLOAT,                                   -- 小计金额
    FOREIGN KEY (order_id) REFERENCES purchase_orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- ----------------------------------------
-- 8. 销售订单表
-- ----------------------------------------
CREATE TABLE IF NOT EXISTS sales_orders (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    order_no     VARCHAR(50) UNIQUE NOT NULL,           -- 订单编号
    customer_id  INTEGER NOT NULL,                      -- 客户ID
    status       VARCHAR(20) DEFAULT 'draft',           -- draft/confirmed/collected/shipped/completed/cancelled
    total_amount FLOAT DEFAULT 0,                       -- 总金额
    remark       VARCHAR(200),                          -- 备注
    created_at   DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at   DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

-- ----------------------------------------
-- 9. 销售订单明细表
-- ----------------------------------------
CREATE TABLE IF NOT EXISTS sales_order_items (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id   INTEGER NOT NULL,                        -- 销售订单ID
    product_id INTEGER NOT NULL,                        -- 商品ID
    quantity   INTEGER NOT NULL,                        -- 销售数量
    unit_price FLOAT NOT NULL,                          -- 销售单价
    subtotal   FLOAT,                                   -- 小计金额
    FOREIGN KEY (order_id) REFERENCES sales_orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- ----------------------------------------
-- 10. 退货单(供应商)主表
-- ----------------------------------------
CREATE TABLE IF NOT EXISTS return_orders (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    order_no     VARCHAR(30) UNIQUE NOT NULL,           -- 退货单号
    supplier_id  INTEGER NOT NULL,                      -- 供应商ID
    status       VARCHAR(20) DEFAULT 'draft',           -- draft/submitted/approved/returned/refunded/completed/cancelled
    total_amount FLOAT DEFAULT 0,                       -- 退货总金额
    remark       VARCHAR(200),                          -- 备注
    created_at   DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at   DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(id)
);

-- ----------------------------------------
-- 11. 退货单(供应商)明细表
-- ----------------------------------------
CREATE TABLE IF NOT EXISTS return_order_items (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id   INTEGER NOT NULL,                        -- 退货单ID
    product_id INTEGER NOT NULL,                        -- 商品ID
    quantity   INTEGER NOT NULL,                        -- 退货数量
    unit_price FLOAT NOT NULL,                          -- 退货单价
    subtotal   FLOAT,                                   -- 小计金额
    FOREIGN KEY (order_id) REFERENCES return_orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- ----------------------------------------
-- 12. 客户退货单主表
-- ----------------------------------------
CREATE TABLE IF NOT EXISTS customer_return_orders (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    order_no     VARCHAR(30) UNIQUE NOT NULL,           -- 退货单号
    customer_id  INTEGER NOT NULL,                      -- 客户ID
    status       VARCHAR(20) DEFAULT 'draft',           -- draft/submitted/approved/received/refunded/completed/cancelled
    total_amount FLOAT DEFAULT 0,                       -- 退货总金额
    remark       VARCHAR(200),                          -- 备注
    created_at   DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at   DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

-- ----------------------------------------
-- 13. 客户退货单明细表
-- ----------------------------------------
CREATE TABLE IF NOT EXISTS customer_return_order_items (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id   INTEGER NOT NULL,                        -- 退货单ID
    product_id INTEGER NOT NULL,                        -- 商品ID
    quantity   INTEGER NOT NULL,                        -- 退货数量
    unit_price FLOAT NOT NULL,                          -- 退货单价
    subtotal   FLOAT,                                   -- 小计金额
    FOREIGN KEY (order_id) REFERENCES customer_return_orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- ----------------------------------------
-- 14. 商品报损单表
-- ----------------------------------------
CREATE TABLE IF NOT EXISTS damage_reports (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    report_no   VARCHAR(30) UNIQUE NOT NULL,            -- 报损单号
    product_id  INTEGER NOT NULL,                       -- 商品ID
    quantity    INTEGER NOT NULL,                       -- 报损数量
    reason      VARCHAR(50) NOT NULL,                   -- 报损原因
    remark      VARCHAR(200),                           -- 备注
    status      VARCHAR(20) DEFAULT 'draft',            -- draft/submitted/approved/executed/cancelled
    loss_amount FLOAT DEFAULT 0,                        -- 损失金额
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- ----------------------------------------
-- 15. 商品报溢单表
-- ----------------------------------------
CREATE TABLE IF NOT EXISTS overflow_reports (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    report_no   VARCHAR(30) UNIQUE NOT NULL,            -- 报溢单号
    product_id  INTEGER NOT NULL,                       -- 商品ID
    quantity    INTEGER NOT NULL,                       -- 报溢数量
    reason      VARCHAR(50) NOT NULL,                   -- 报溢原因
    remark      VARCHAR(200),                           -- 备注
    status      VARCHAR(20) DEFAULT 'draft',            -- draft/submitted/approved/executed/cancelled
    amount      FLOAT DEFAULT 0,                        -- 金额
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id)
);
