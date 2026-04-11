<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core"  prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"   prefix="fmt" %>
<%@ include file="/views/layout/header.jsp" %>

<div class="flex items-center justify-between mb-6">
    <h1 class="section-title mb-0">
        <span class="material-symbols-outlined" style="color:#8B4513">local_offer</span>
        Quản lý mã giảm giá
    </h1>
    <button onclick="openModal('addModal')" class="btn btn-primary">
        <span class="material-symbols-outlined text-[18px]">add_circle</span> Thêm mã mới
    </button>
</div>

<c:if test="${not empty message}">
    <div class="alert alert-success"><span class="material-symbols-outlined text-[18px]">check_circle</span> ${message}</div>
</c:if>
<c:if test="${not empty error}">
    <div class="alert alert-danger"><span class="material-symbols-outlined text-[18px]">error</span> ${error}</div>
</c:if>

<div class="pc-card">
    <div class="pc-card-header justify-between">
        <div class="flex items-center gap-2">
            <span class="material-symbols-outlined" style="color:#8B4513;font-size:18px">table_rows</span>
            Danh sách mã giảm giá
        </div>
        <span class="badge badge-secondary">${list.size()} mã</span>
    </div>
    <div class="overflow-x-auto">
        <table class="data-table w-full">
            <thead>
                <tr>
                    <th>Mã code</th>
                    <th class="text-center">Loại</th>
                    <th class="text-right">Giá trị</th>
                    <th>Hiệu lực</th>
                    <th style="max-width:200px">Điều kiện</th>
                    <th class="text-center">Trạng thái</th>
                    <th class="text-center">Thao tác</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${list}" var="dc">
                    <tr>
                        <td>
                            <span class="font-mono font-bold text-sm"
                                  style="background:#F5E6D3;color:#4A2810;padding:3px 10px;
                                         border-radius:6px;letter-spacing:0.05em">
                                ${dc.code}
                            </span>
                        </td>
                        <td class="text-center">
                            <c:choose>
                                <c:when test="${dc.discountType}">
                                    <span class="badge badge-info">
                                        <span class="material-symbols-outlined text-[12px]">percent</span> %
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-gold">
                                        <span class="material-symbols-outlined text-[12px]">payments</span> VNĐ
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="text-right font-bold" style="color:#8B4513">
                            <c:choose>
                                <c:when test="${dc.discountType}">
                                    <fmt:formatNumber value="${dc.discountValue}" pattern="#,##0" />%
                                </c:when>
                                <c:otherwise>
                                    <fmt:formatNumber value="${dc.discountValue}" pattern="#,##0" /> ₫
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td style="font-size:0.82rem;color:#6B3A1F">
                            <fmt:formatDate value="${dc.startDate}" pattern="dd/MM/yyyy" />
                            <span style="color:#C6956A">→</span>
                            <fmt:formatDate value="${dc.endDate}"   pattern="dd/MM/yyyy" />
                        </td>
                        <td style="max-width:200px;overflow:hidden;text-overflow:ellipsis;
                                   white-space:nowrap;font-size:0.85rem;color:#6B3A1F">
                            ${dc.conditionNote}
                        </td>
                        <td class="text-center">
                            <c:choose>
                                <c:when test="${dc.active}">
                                    <span class="badge badge-success">
                                        <span class="material-symbols-outlined text-[12px]">check_circle</span> Hoạt động
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-neutral">
                                        <span class="material-symbols-outlined text-[12px]">block</span> Vô hiệu
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="text-center">
                            <div class="flex items-center justify-center gap-1.5">
                                <%-- Edit: dùng data-* thay vì nhúng JSTL vào onclick để tránh lỗi dấu > kết thúc attribute --%>
                                <button type="button"
                                        class="btn btn-secondary btn-icon edit-btn" title="Sửa"
                                        data-id="${dc.id}"
                                        data-code="${fn:escapeXml(dc.code)}"
                                        data-value="${dc.discountValue}"
                                        data-type="${dc.discountType ? 1 : 0}"
                                        data-start="<fmt:formatDate value='${dc.startDate}' pattern='yyyy-MM-dd'/>"
                                        data-end="<fmt:formatDate value='${dc.endDate}' pattern='yyyy-MM-dd'/>"
                                        data-note="${fn:escapeXml(dc.conditionNote)}">
                                    <span class="material-symbols-outlined text-[16px]">edit</span>
                                </button>
                                <%-- Toggle --%>
                                <form action="${pageContext.request.contextPath}/manager/discount-codes/toggle"
                                      method="post" class="inline">
                                    <input type="hidden" name="id" value="${dc.id}">
                                    <button type="submit"
                                            class="btn btn-icon ${dc.active ? 'btn-outline' : 'btn-success'}"
                                            title="${dc.active ? 'Vô hiệu hoá' : 'Kích hoạt'}">
                                        <span class="material-symbols-outlined text-[16px]">
                                            ${dc.active ? 'toggle_off' : 'toggle_on'}
                                        </span>
                                    </button>
                                </form>
                                <%-- Delete --%>
                                <form action="${pageContext.request.contextPath}/manager/discount-codes/delete"
                                      method="post" class="inline"
                                      onsubmit="return confirm('Xóa mã ${dc.code}?')">
                                    <input type="hidden" name="id" value="${dc.id}">
                                    <button type="submit" class="btn btn-danger btn-icon" title="Xóa">
                                        <span class="material-symbols-outlined text-[16px]">delete</span>
                                    </button>
                                </form>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty list}">
                    <tr>
                        <td colspan="7" class="text-center" style="padding:4rem 1rem;color:#9E7B5E">
                            <span class="material-symbols-outlined block mb-2" style="font-size:3.5rem;opacity:.25">local_offer</span>
                            <p class="font-bold mb-1">Chưa có mã giảm giá nào</p>
                            <p style="font-size:.875rem;opacity:.65">Nhấn "Thêm mã mới" để bắt đầu</p>
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>

<%-- ══ ADD MODAL ══ --%>
<div id="addModal" class="modal-backdrop" style="display:none" onclick="if(event.target===this)closeModal('addModal')">
    <div class="modal-box">
        <div class="modal-header">
            <div class="flex items-center gap-2">
                <span class="material-symbols-outlined text-cream text-[20px]">local_offer</span>
                <span style="font-family:'Playfair Display',serif;font-weight:700;color:#F5E6D3">
                    Thêm mã giảm giá
                </span>
            </div>
            <button onclick="closeModal('addModal')" class="btn btn-icon"
                    style="color:rgba(245,230,211,0.7);background:rgba(255,255,255,0.1)">
                <span class="material-symbols-outlined text-[20px]">close</span>
            </button>
        </div>
        <div class="p-6">
            <form action="${pageContext.request.contextPath}/manager/discount-codes/add" method="post">
                <%@ include file="/views/discount/form-fields.jsp" %>
                <div class="flex gap-3 mt-6">
                    <button type="submit" class="btn btn-primary flex-1 py-3">
                        <span class="material-symbols-outlined text-[18px]">save</span> Thêm mã
                    </button>
                    <button type="button" onclick="closeModal('addModal')" class="btn btn-outline flex-1 py-3">
                        Hủy
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<%-- ══ EDIT MODAL ══ --%>
<div id="editModal" class="modal-backdrop" style="display:none" onclick="if(event.target===this)closeModal('editModal')">
    <div class="modal-box">
        <div class="modal-header">
            <div class="flex items-center gap-2">
                <span class="material-symbols-outlined text-cream text-[20px]">edit</span>
                <span style="font-family:'Playfair Display',serif;font-weight:700;color:#F5E6D3">
                    Chỉnh sửa mã giảm giá
                </span>
            </div>
            <button onclick="closeModal('editModal')" class="btn btn-icon"
                    style="color:rgba(245,230,211,0.7);background:rgba(255,255,255,0.1)">
                <span class="material-symbols-outlined text-[20px]">close</span>
            </button>
        </div>
        <div class="p-6">
            <form action="${pageContext.request.contextPath}/manager/discount-codes/edit" method="post">
                <input type="hidden" id="editId" name="id" value="">
                <div class="mb-4">
                    <label class="form-label">Mã code</label>
                    <input type="text" id="editCode" class="form-control opacity-60 cursor-not-allowed"
                           readonly style="font-family:monospace;font-weight:700">
                </div>
                <%-- Reuse fields via JS fill --%>
                <div class="mb-4">
                    <label class="form-label">Loại giảm giá</label>
                    <select class="form-select" name="discountType" id="editType" onchange="toggleValueLabel('edit')">
                        <option value="0">Giảm số tiền cố định (VNĐ)</option>
                        <option value="1">Giảm theo phần trăm (%)</option>
                    </select>
                </div>
                <div class="mb-4">
                    <label class="form-label" id="editValueLabel">Giá trị giảm (VNĐ)</label>
                    <input type="number" class="form-control" name="discountValue" id="editValue"
                           min="1" step="1000" required>
                </div>
                <div class="grid grid-cols-2 gap-4 mb-4">
                    <div>
                        <label class="form-label">Ngày bắt đầu</label>
                        <input type="date" class="form-control" name="startDate" id="editStart" required>
                    </div>
                    <div>
                        <label class="form-label">Ngày kết thúc</label>
                        <input type="date" class="form-control" name="endDate" id="editEnd" required>
                    </div>
                </div>
                <div class="mb-4">
                    <label class="form-label">Điều kiện áp dụng</label>
                    <textarea class="form-control" name="conditionNote" id="editNote" rows="2"></textarea>
                </div>
                <div class="flex gap-3 mt-6">
                    <button type="submit" class="btn btn-primary flex-1 py-3">
                        <span class="material-symbols-outlined text-[18px]">save</span> Lưu thay đổi
                    </button>
                    <button type="button" onclick="closeModal('editModal')" class="btn btn-outline flex-1 py-3">
                        Hủy
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
function openModal(id) { document.getElementById(id).style.display = 'flex'; }
function closeModal(id) { document.getElementById(id).style.display = 'none'; }

// Delegate: bắt click trên tất cả nút .edit-btn, đọc data attributes
document.addEventListener('click', function(e) {
    var btn = e.target.closest('.edit-btn');
    if (!btn) return;
    document.getElementById('editId').value    = btn.dataset.id;
    document.getElementById('editCode').value  = btn.dataset.code;
    document.getElementById('editValue').value = btn.dataset.value;
    document.getElementById('editType').value  = btn.dataset.type;
    document.getElementById('editStart').value = btn.dataset.start;
    document.getElementById('editEnd').value   = btn.dataset.end;
    document.getElementById('editNote').value  = btn.dataset.note;
    toggleValueLabel('edit');
    openModal('editModal');
});

function toggleValueLabel(prefix) {
    const sel = document.getElementById(prefix + 'Type').value;
    const lbl = document.getElementById(prefix + 'ValueLabel');
    if (lbl) lbl.textContent = sel === '1' ? 'Giá trị giảm (%)' : 'Giá trị giảm (VNĐ)';
}
</script>

<%-- taglib for fn:escapeXml --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ include file="/views/layout/footer.jsp" %>
