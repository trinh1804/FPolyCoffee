<%-- views/discount/form-fields.jsp
     Partial: shared fields dùng trong Add Modal của discount-list.jsp
     Không include header/footer vì đây chỉ là fragment.
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="mb-4">
    <label class="form-label">Mã code <span style="color:#C62828">*</span></label>
    <input type="text" class="form-control font-mono" name="code"
           placeholder="VD: SALE20"
           style="text-transform:uppercase;font-weight:700;letter-spacing:0.05em"
           oninput="this.value=this.value.toUpperCase()"
           required maxlength="20">
    <p style="font-size:0.75rem;color:#9E7B5E;margin-top:4px">
        Tối đa 20 ký tự, chỉ chữ và số
    </p>
</div>

<div class="mb-4">
    <label class="form-label">Loại giảm giá <span style="color:#C62828">*</span></label>
    <select class="form-select" name="discountType" id="addType"
            onchange="toggleValueLabel('add')">
        <option value="0">Giảm số tiền cố định (VNĐ)</option>
        <option value="1">Giảm theo phần trăm (%)</option>
    </select>
</div>

<div class="mb-4">
    <label class="form-label" id="addValueLabel">Giá trị giảm (VNĐ) <span style="color:#C62828">*</span></label>
    <input type="number" class="form-control" name="discountValue" id="addValue"
           min="1" step="1000" placeholder="VD: 20000" required>
</div>

<div class="grid grid-cols-2 gap-4 mb-4">
    <div>
        <label class="form-label">Ngày bắt đầu <span style="color:#C62828">*</span></label>
        <input type="date" class="form-control" name="startDate" required>
    </div>
    <div>
        <label class="form-label">Ngày kết thúc <span style="color:#C62828">*</span></label>
        <input type="date" class="form-control" name="endDate" required>
    </div>
</div>

<div class="mb-4">
    <label class="form-label">Điều kiện áp dụng</label>
    <textarea class="form-control" name="conditionNote" rows="2"
              placeholder="VD: Áp dụng cho đơn từ 100.000₫..."></textarea>
</div>
