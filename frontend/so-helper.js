// 销售订单相关辅助函数（由 AI 助手生成）
// 避免在主 HTML 文件中因模板字符串导致 PowerShell 编辑失败

// ============================================================
// 销售弹窗快捷新增商品
// ============================================================
function toggleSoQuickAdd() {
    const div = document.getElementById('so-quick-add');
    if (div.style.display === 'none' || !div.style.display) {
        div.style.display = 'block';
        const ts = Date.now().toString().slice(-5);
        document.getElementById('so-ncode').value = 'S' + ts;
        document.getElementById('so-nname').focus();
    } else {
        div.style.display = 'none';
    }
}

async function quickAddProductInSo() {
    const code = document.getElementById('so-ncode').value.trim();
    const name = document.getElementById('so-nname').value.trim();
    if (!code) { toast('商品编码不能为空', 'error'); return; }
    if (!name) { toast('商品名称不能为空', 'error'); return; }

    const data = {
        code: code,
        name: name,
        category: document.getElementById('so-ncategory').value.trim(),
        model: document.getElementById('so-nmodel').value.trim(),
        unit: '个',
        purchase_price: 0,
        sale_price: parseFloat(document.getElementById('so-nsale-price').value) || 0,
        safety_stock: 10
    };

    try {
        const newProduct = await apiPost('/api/products', data);
        toast('✅ 商品「' + name + '」已添加');
        toggleSoQuickAdd();
        await refreshSoProducts(newProduct.id);
    } catch(e) { toast('添加失败: ' + e.message, 'error'); }
}

async function refreshSoProducts(selectId) {
    try {
        const products = await apiGet('/api/products');
        const productOptions = products.map(p =>
            '<option value="' + p.id + '" data-price="' + p.sale_price + '" data-stock="' + p.current_stock + '">' +
            p.name + ' (¥' + formatMoney(p.sale_price) + ' | 库存:' + p.current_stock + ')</option>'
        ).join('');

        document.querySelectorAll('#so-items select').forEach(function(sel) {
            const currentVal = sel.value;
            sel.innerHTML = '<option value="">--选择商品--</option>' + productOptions;
            sel.value = currentVal || (selectId ? String(selectId) : '');
        });

        document.getElementById('so-ncode').value = '';
        document.getElementById('so-nname').value = '';
        document.getElementById('so-ncategory').value = '';
        document.getElementById('so-nmodel').value = '';
        document.getElementById('so-nsale-price').value = '0';
    } catch(e) { toast('刷新商品列表失败: ' + e.message, 'error'); }
}

// ============================================================
// 销售弹窗中打开批量导入
// ============================================================
function showImportModalInSo() {
    document.getElementById('importModal').classList.add('show');
    document.getElementById('importFile').value = '';
    document.getElementById('importResult').style.display = 'none';
    document.getElementById('importResult').innerHTML = '';
    document.getElementById('importBtn').disabled = false;
    document.getElementById('importBtn').textContent = '开始导入';
    document.getElementById('importModal').setAttribute('data-from-so', '1');
}

// ============================================================
// 销售订单详情弹窗
// ============================================================
function showSalesOrderDetail(order) {
    let itemsHtml;
    if (order.items && order.items.length > 0) {
        let rows = '';
        for (let i = 0; i < order.items.length; i++) {
            const it = order.items[i];
            rows += '<tr style="border-bottom:1px solid #f1f5f9;">' +
                '<td style="padding:6px 4px;">' + (it.product_name || '商品#' + it.product_id) + '</td>' +
                '<td style="text-align:center;padding:6px 4px;">' + it.quantity + '</td>' +
                '<td style="text-align:right;padding:6px 4px;">¥' + formatMoney(it.unit_price) + '</td>' +
                '<td style="text-align:right;padding:6px 4px;">¥' + formatMoney(it.subtotal) + '</td>' +
                '</tr>';
        }
        itemsHtml = '<table style="width:100%;font-size:13px;border-collapse:collapse;margin-top:8px;">' +
            '<thead><tr style="border-bottom:1px solid #e2e8f0;">' +
            '<th style="text-align:left;padding:6px 4px;">商品</th>' +
            '<th style="text-align:center;padding:6px 4px;width:60px;">数量</th>' +
            '<th style="text-align:right;padding:6px 4px;width:100px;">单价(¥)</th>' +
            '<th style="text-align:right;padding:6px 4px;width:100px;">小计(¥)</th>' +
            '</tr></thead><tbody>' + rows + '</tbody></table>';
    } else {
        itemsHtml = '<p style="color:var(--text-muted);">暂无商品明细</p>';
    }

    let remarkHtml = '';
    if (order.remark) {
        remarkHtml = '<div style="display:flex;justify-content:space-between;margin-bottom:6px;">' +
            '<span style="color:var(--text-muted);">备注</span>' +
            '<span>' + order.remark + '</span></div>';
    }

    document.getElementById('so-detail-content').innerHTML =
        '<div style="background:#f8fafc;border-radius:8px;padding:14px 16px;margin-bottom:14px;">' +
            '<div style="display:flex;justify-content:space-between;margin-bottom:6px;">' +
                '<span style="color:var(--text-muted);">销售单号</span>' +
                '<strong>' + order.order_no + '</strong></div>' +
            '<div style="display:flex;justify-content:space-between;margin-bottom:6px;">' +
                '<span style="color:var(--text-muted);">客户</span>' +
                '<span>' + order.customer_name + '</span></div>' +
            '<div style="display:flex;justify-content:space-between;margin-bottom:6px;">' +
                '<span style="color:var(--text-muted);">状态</span>' +
                '<span>' + statusBadge(order.status) + '</span></div>' +
            '<div style="display:flex;justify-content:space-between;margin-bottom:6px;">' +
                '<span style="color:var(--text-muted);">创建时间</span>' +
                '<span>' + order.created_at + '</span></div>' +
            remarkHtml +
            '<div style="display:flex;justify-content:space-between;padding-top:6px;border-top:1px solid #e2e8f0;margin-top:6px;">' +
                '<span style="color:var(--text-muted);">销售总金额</span>' +
                '<strong style="font-size:15px;">¥' + formatMoney(order.total_amount) + '</strong></div>' +
        '</div>' +
        '<h4 style="font-size:14px;margin:0 0 6px 0;">📤 销售商品明细</h4>' +
        itemsHtml;

    document.getElementById('salesOrderDetailModal').classList.add('show');
}

function closeSalesOrderDetailModal() {
    document.getElementById('salesOrderDetailModal').classList.remove('show');
}
