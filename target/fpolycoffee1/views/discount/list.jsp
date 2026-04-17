<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
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
                    <div class="alert alert-success">
                        <span class="material-symbols-outlined text-[18px]">check_circle</span> ${message}
                    </div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">
                        <span class="material-symbols-outlined text-[18px]">error</span> ${error}
                    </div>
                </c:if>

                <!-- ══ TABLE ══ -->
                <div class="pc-card">
                    <div class="pc-card-header justify-between">
                        <div class="flex items-center gap-2">
                            <span class="material-symbols-outlined text-[18px]" style="color:#8B4513">list</span>
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
                                    <th class="text-center">Thời hạn</th>
                                    <th>Điều kiện</th>
                                    <th class="text-center">Trạng thái</th>
                                    <th class="text-center">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${list}" var="dc">
                                    <fmt:formatDate var="fStart" value="${dc.startDate}" pattern="yyyy-MM-dd" />
                                    <fmt:formatDate var="fEnd" value="${dc.endDate}" pattern="yyyy-MM-dd" />
                                    <fmt:formatDate var="dStart" value="${dc.startDate}" pattern="dd/MM/yyyy" />
                                    <fmt:formatDate var="dEnd" value="${dc.endDate}" pattern="dd/MM/yyyy" />

                                    <tr>
                                        <td class="font-mono font-bold" style="color:#4A2810;letter-spacing:0.05em">
                                            ${dc.code}
                                        </td>

                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${dc.discountType}">
                                                    <span class="badge"
                                                        style="background:#E3F2FD;color:#1565C0">%</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge" style="background:#FFF3E0;color:#E65100">VNĐ
                                                        ₫</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td class="text-right font-semibold" style="color:#2C1A0E">
                                            <c:choose>
                                                <c:when test="${dc.discountType}">
                                                    <fmt:formatNumber value="${dc.discountValue}" pattern="#,##0" />%
                                                </c:when>
                                                <c:otherwise>
                                                    <fmt:formatNumber value="${dc.discountValue}" pattern="#,##0" /> ₫
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td class="text-center text-sm" style="color:#6B3A1F;white-space:nowrap">
                                            ${dStart} → ${dEnd}
                                        </td>

                                        <td class="text-sm" style="color:#6B3A1F;max-width:180px;
                                   overflow:hidden;text-overflow:ellipsis;white-space:nowrap"
                                            title="${dc.conditionNote}">
                                            ${dc.conditionNote}
                                        </td>

                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${dc.active}">
                                                    <span class="badge badge-success">
                                                        <span
                                                            class="material-symbols-outlined text-[13px]">check_circle</span>
                                                        Hoạt động
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-secondary">
                                                        <span class="material-symbols-outlined text-[13px]">block</span>
                                                        Vô hiệu
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td class="text-center">
                                            <div class="flex items-center justify-center gap-1.5">

                                                <!-- Nút Sửa: toàn bộ data đặt trong data-* attribute -->
                                                <button type="button" class="btn btn-secondary btn-sm js-edit-dc"
                                                    title="Sửa" data-id="${dc.id}" data-code="${dc.code}"
                                                    data-type="${dc.discountType ? 1 : 0}"
                                                    data-value="${dc.discountValue}" data-start="${fStart}"
                                                    data-end="${fEnd}" data-note="${dc.conditionNote}">
                                                    <span class="material-symbols-outlined text-[16px]">edit</span>
                                                </button>

                                                <!-- Toggle -->
                                                <form
                                                    action="${pageContext.request.contextPath}/manager/discount-codes/toggle"
                                                    method="post" class="inline">
                                                    <input type="hidden" name="id" value="${dc.id}">
                                                    <button type="submit"
                                                        class="btn btn-sm ${dc.active ? 'btn-outline' : 'btn-primary'}"
                                                        title="${dc.active ? 'Vô hiệu hoá' : 'Kích hoạt'}"
                                                        data-msg="${dc.active ? 'Vô hiệu hoá mã ' : 'Kích hoạt mã '}${dc.code}?"
                                                        onclick="return confirm(this.dataset.msg)">
                                                        <span class="material-symbols-outlined text-[16px]">
                                                            ${dc.active ? 'toggle_off' : 'toggle_on'}
                                                        </span>
                                                    </button>
                                                </form>

                                                <!-- Xóa -->
                                                <form
                                                    action="${pageContext.request.contextPath}/manager/discount-codes/delete"
                                                    method="post" class="inline"
                                                    onsubmit="return confirm('Xóa vĩnh viễn mã ${dc.code}?')">
                                                    <input type="hidden" name="id" value="${dc.id}">
                                                    <button type="submit" class="btn btn-danger btn-sm" title="Xóa">
                                                        <span
                                                            class="material-symbols-outlined text-[16px]">delete</span>
                                                    </button>
                                                </form>

                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>

                                <c:if test="${empty list}">
                                    <tr>
                                        <td colspan="7" class="text-center py-16" style="color:#9E7B5E">
                                            <span class="material-symbols-outlined block mb-2 opacity-25"
                                                style="font-size:3rem">local_offer</span>
                                            Chưa có mã giảm giá nào
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- ══ ADD MODAL ══ -->
                <div id="addModal" class="modal-backdrop" style="display:none"
                    onclick="if(event.target===this)closeModal('addModal')">
                    <div class="modal-box">
                        <div class="modal-header">
                            <span style="font-family:'Playfair Display',serif;font-weight:700;color:#F5E6D3">
                                Thêm mã giảm giá
                            </span>
                            <button onclick="closeModal('addModal')" class="btn btn-icon"
                                style="color:rgba(245,230,211,0.7);background:rgba(255,255,255,0.1)">
                                <span class="material-symbols-outlined">close</span>
                            </button>
                        </div>
                        <div class="p-6">
                            <form action="${pageContext.request.contextPath}/manager/discount-codes/add" method="post">

                                <div class="mb-4">
                                    <label class="form-label">Mã code <span style="color:#C62828">*</span></label>
                                    <input type="text" class="form-control font-mono" name="code"
                                        placeholder="VD: SALE20"
                                        style="text-transform:uppercase;font-weight:700;letter-spacing:0.05em"
                                        oninput="this.value=this.value.toUpperCase()" required maxlength="20">
                                    <p style="font-size:0.75rem;color:#9E7B5E;margin-top:4px">Tối đa 20 ký tự,
                                        chỉ chữ và số</p>
                                </div>

                                <div class="mb-4">
                                    <label class="form-label">Loại giảm giá <span style="color:#C62828">*</span></label>
                                    <select class="form-select" name="discountType" id="addType"
                                        onchange="syncInput('add')">
                                        <option value="0">Giảm số tiền cố định (VNĐ)</option>
                                        <option value="1">Giảm theo phần trăm (%)</option>
                                    </select>
                                </div>

                                <div class="mb-4">
                                    <label class="form-label" id="addValueLabel">
                                        Giá trị giảm (VNĐ) <span style="color:#C62828">*</span>
                                    </label>
                                    <input type="number" class="form-control" name="discountValue" id="addValue" min="1"
                                        step="1" placeholder="VD: 20000" required>
                                    <p style="font-size:0.75rem;color:#9E7B5E;margin-top:4px" id="addValueHint">
                                        Nhập số tiền giảm (VNĐ)
                                    </p>
                                </div>

                                <div class="grid grid-cols-2 gap-4 mb-4">
                                    <div>
                                        <label class="form-label">Ngày bắt đầu <span
                                                style="color:#C62828">*</span></label>
                                        <input type="date" class="form-control" name="startDate" required>
                                    </div>
                                    <div>
                                        <label class="form-label">Ngày kết thúc <span
                                                style="color:#C62828">*</span></label>
                                        <input type="date" class="form-control" name="endDate" required>
                                    </div>
                                </div>

                                <div class="mb-4">
                                    <label class="form-label">Điều kiện áp dụng</label>
                                    <textarea class="form-control" name="conditionNote" rows="2"
                                        placeholder="VD: Áp dụng cho đơn từ 100.000₫..."></textarea>
                                </div>

                                <div class="flex gap-3">
                                    <button type="submit" class="btn btn-primary flex-1 py-3">
                                        <span class="material-symbols-outlined text-[18px]">save</span> Thêm mã
                                    </button>
                                    <button type="button" onclick="closeModal('addModal')"
                                        class="btn btn-outline flex-1 py-3">Hủy</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- ══ EDIT MODAL ══ -->
                <div id="editModal" class="modal-backdrop" style="display:none"
                    onclick="if(event.target===this)closeModal('editModal')">
                    <div class="modal-box">
                        <div class="modal-header">
                            <span style="font-family:'Playfair Display',serif;font-weight:700;color:#F5E6D3">
                                Chỉnh sửa mã giảm giá
                            </span>
                            <button onclick="closeModal('editModal')" class="btn btn-icon"
                                style="color:rgba(245,230,211,0.7);background:rgba(255,255,255,0.1)">
                                <span class="material-symbols-outlined">close</span>
                            </button>
                        </div>
                        <div class="p-6">
                            <form action="${pageContext.request.contextPath}/manager/discount-codes/edit" method="post">
                                <input type="hidden" id="editId" name="id">

                                <div class="mb-4">
                                    <label class="form-label">Mã code</label>
                                    <input type="text" id="editCode" class="form-control font-mono"
                                        style="font-weight:700;letter-spacing:0.05em;background:#F5F5F5" readonly>
                                    <p style="font-size:0.75rem;color:#9E7B5E;margin-top:4px">
                                        Mã code không thể thay đổi sau khi tạo.
                                    </p>
                                </div>

                                <div class="mb-4">
                                    <label class="form-label">Loại giảm giá <span style="color:#C62828">*</span></label>
                                    <select class="form-select" id="editType" name="discountType"
                                        onchange="syncInput('edit')">
                                        <option value="0">Giảm số tiền cố định (VNĐ)</option>
                                        <option value="1">Giảm theo phần trăm (%)</option>
                                    </select>
                                </div>

                                <!-- step="1" — không dùng step="1000" vì gây lỗi HTML5 validation bội số khi nhập % -->
                                <div class="mb-4">
                                    <label class="form-label" id="editValueLabel">
                                        Giá trị giảm (VNĐ) <span style="color:#C62828">*</span>
                                    </label>
                                    <input type="number" class="form-control" id="editValue" name="discountValue"
                                        min="1" step="1" required>
                                    <p style="font-size:0.75rem;color:#9E7B5E;margin-top:4px" id="editValueHint">
                                        Nhập số tiền giảm (VNĐ)
                                    </p>
                                </div>

                                <div class="grid grid-cols-2 gap-4 mb-4">
                                    <div>
                                        <label class="form-label">Ngày bắt đầu <span
                                                style="color:#C62828">*</span></label>
                                        <input type="date" class="form-control" id="editStart" name="startDate"
                                            required>
                                    </div>
                                    <div>
                                        <label class="form-label">Ngày kết thúc <span
                                                style="color:#C62828">*</span></label>
                                        <input type="date" class="form-control" id="editEnd" name="endDate" required>
                                    </div>
                                </div>

                                <div class="mb-4">
                                    <label class="form-label">Điều kiện áp dụng</label>
                                    <textarea class="form-control" id="editNote" name="conditionNote"
                                        rows="2"></textarea>
                                </div>

                                <div class="flex gap-3">
                                    <button type="submit" class="btn btn-primary flex-1 py-3">
                                        <span class="material-symbols-outlined text-[18px]">save</span>
                                        Lưu thay đổi
                                    </button>
                                    <button type="button" onclick="closeModal('editModal')"
                                        class="btn btn-outline flex-1 py-3">Hủy</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <script>
                    /* ── Modal ── */
                    function openModal(id) { document.getElementById(id).style.display = 'flex'; }
                    function closeModal(id) { document.getElementById(id).style.display = 'none'; }

                    /* ── Đọc data-* từ nút Sửa → populate Edit modal ── */
                    document.querySelectorAll('.js-edit-dc').forEach(function (btn) {
                        btn.addEventListener('click', function () {
                            /* Đặt loại trước */
                            document.getElementById('editType').value = this.dataset.type;
                            /* Sync label/step/max KHÔNG xóa value (clearVal=false) */
                            syncInput('edit', false);
                            /* Đặt các field khác */
                            document.getElementById('editId').value = this.dataset.id;
                            document.getElementById('editCode').value = this.dataset.code;
                            document.getElementById('editValue').value = this.dataset.value;
                            document.getElementById('editStart').value = this.dataset.start;
                            document.getElementById('editEnd').value = this.dataset.end;
                            document.getElementById('editNote').value = this.dataset.note;
                            openModal('editModal');
                        });
                    });

                    /**
                     * Cập nhật input giá trị theo loại Add hoặc Edit.
                     * @param {string}  prefix   'add' | 'edit'
                     * @param {boolean} clearVal true = xóa giá trị cũ (khi người dùng đổi loại)
                     */
                    function syncInput(prefix, clearVal) {
                        if (clearVal === undefined) clearVal = true;
                        var isPercent = document.getElementById(prefix + 'Type').value === '1';
                        var input = document.getElementById(prefix + 'Value');
                        var label = document.getElementById(prefix + 'ValueLabel');
                        var hint = document.getElementById(prefix + 'ValueHint');

                        if (isPercent) {
                            input.min = '1'; input.max = '100'; input.step = '1';
                            input.placeholder = 'VD: 10';
                            if (label) label.innerHTML = 'Giá trị giảm (%) <span style="color:#C62828">*</span>';
                            if (hint) hint.textContent = 'Nhập phần trăm giảm từ 1 đến 100';
                        } else {
                            input.min = '1'; input.max = ''; input.step = '1000';
                            input.placeholder = 'VD: 20000';
                            if (label) label.innerHTML = 'Giá trị giảm (VNĐ) <span style="color:#C62828">*</span>';
                            if (hint) hint.textContent = 'Nhập số tiền giảm (VNĐ)';
                        }
                        if (clearVal) input.value = '';
                    }

                    /* Tương thích với form-fields.jsp nếu vẫn còn include */
                    function toggleValueLabel(prefix) { syncInput(prefix); }
                </script>

                <%@ include file="/views/layout/footer.jsp" %>