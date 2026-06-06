// ============================================================
// 订单详情辅助函数
// ============================================================

function showSalesOrderDetail(order) {
    const items = order.items || [];
    document.getElementById('salesDetailTitle').textContent = '📋 销售订单详情 - ' + order.order_no;
    const statusMap = { draft:'草稿', confirmed:'已确认', collected:'已收款', shipped:'已发货', completed:'已完成', cancelled:'已取消' };
    document.getElementById('salesDetailInfo').innerHTML =
        '<div><strong>订单编号：</strong>' + order.order_no + '</div>' +
        '<div><strong>客户：</strong>' + (order.customer_name || '-') + '</div>' +
        '<div><strong>订单金额：</strong>¥' + formatMoney(order.total_amount) + '</div>' +
        '<div><strong>状态：</strong>' + (statusMap[order.status] || order.status) + '</div>' +
        '<div><strong>创建时间：</strong>' + (order.created_at || '-') + '</div>' +
        '<div><strong>备注：</strong>' + (order.remark || '-') + '</div>';
    document.getElementById('salesDetailItems').innerHTML = items.length === 0
        ? '<tr><td colspan="6" style="text-align:center;color:var(--text-muted);">暂无明细</td></tr>'
        : items.map(function(item, i) {
            return '<tr><td>' + (i+1) + '</td><td>' + (item.product_code||'') + '</td><td>' + (item.product_name||'') + '</td><td>' + formatMoney(item.unit_price||0) + '</td><td>' + (item.quantity||0) + '</td><td>¥' + formatMoney((item.unit_price||0)*(item.quantity||0)) + '</td></tr>';
        }).join('');
    document.getElementById('salesDetailLogs').innerHTML = (order.logs && order.logs.length)
        ? order.logs.map(function(l) {
            return '<div style="border-bottom:1px solid var(--border);padding:6px 0;font-size:13px;"><strong>' + (l.operator||'') + '</strong> ' + (l.action||'') + ' · <span style="color:var(--text-muted);">' + (l.created_at||'') + '</span></div>';
        }).join('')
        : '<div style="text-align:center;color:var(--text-muted);padding:10px;">暂无日志</div>';
    document.getElementById('salesOrderDetailModal').classList.add('show');
}

function closeSalesOrderDetailModal() {
    document.getElementById('salesOrderDetailModal').classList.remove('show');
}

function showPurchaseOrderDetail(order) {
    const items = order.items || [];
    document.getElementById('purchaseDetailTitle').textContent = '📋 采购订单详情 - ' + order.order_no;
    const statusMap = { draft:'草稿', approved:'已审批', paid:'已付款', received:'已入库', completed:'已完成', cancelled:'已取消' };
    document.getElementById('purchaseDetailInfo').innerHTML =
        '<div><strong>订单编号：</strong>' + order.order_no + '</div>' +
        '<div><strong>供应商：</strong>' + (order.supplier_name || '-') + '</div>' +
        '<div><strong>订单金额：</strong>¥' + formatMoney(order.total_amount) + '</div>' +
        '<div><strong>状态：</strong>' + (statusMap[order.status] || order.status) + '</div>' +
        '<div><strong>创建时间：</strong>' + (order.created_at || '-') + '</div>' +
        '<div><strong>备注：</strong>' + (order.remark || '-') + '</div>';
    document.getElementById('purchaseDetailItems').innerHTML = items.length === 0
        ? '<tr><td colspan="6" style="text-align:center;color:var(--text-muted);">暂无明细</td></tr>'
        : items.map(function(item, i) {
            return '<tr><td>' + (i+1) + '</td><td>' + (item.product_code||'') + '</td><td>' + (item.product_name||'') + '</td><td>' + formatMoney(item.unit_price||0) + '</td><td>' + (item.quantity||0) + '</td><td>¥' + formatMoney((item.unit_price||0)*(item.quantity||0)) + '</td></tr>';
        }).join('');
    document.getElementById('purchaseDetailLogs').innerHTML = (order.logs && order.logs.length)
        ? order.logs.map(function(l) {
            return '<div style="border-bottom:1px solid var(--border);padding:6px 0;font-size:13px;"><strong>' + (l.operator||'') + '</strong> ' + (l.action||'') + ' · <span style="color:var(--text-muted);">' + (l.created_at||'') + '</span></div>';
        }).join('')
        : '<div style="text-align:center;color:var(--text-muted);padding:10px;">暂无日志</div>';
    document.getElementById('purchaseOrderDetailModal').classList.add('show');
}

function closePurchaseOrderDetailModal() {
    document.getElementById('purchaseOrderDetailModal').classList.remove('show');
}

// ESC 关闭所有详情弹窗
document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        ['salesOrderDetailModal','purchaseOrderDetailModal','returnOrderDetailModal'].forEach(function(id) {
            var el = document.getElementById(id);
            if (el) el.classList.remove('show');
        });
    }
});
