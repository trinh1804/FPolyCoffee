<%-- views/discount/form-fields.jsp Partial: shared fields dùng trong Add Modal của discount-list.jsp Không include
    header/footer vì đây chỉ là fragment. --%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

        <div class="mb-4">
            <label class="form-label">Mã code <span style="color:#C62828">*</span></label>
            <input type="text" class="form-control font-mono" name="code" placeholder="VD: SALE20"
                style="text-transform:uppercase;font-weight:700;letter-spacing:0.05em"
                oninput="this.value=this.value.toUpperCase()" required maxlength="20" pattern="[A-Za-z0-9]+">
            <p style="font-size:0.75rem;color:#9E7B5E;margin-top:4px">
                Tối đa 20 ký tự, chỉ chữ và số
            </p>
        </div>

        <div class="mb-4">
            <label class="form-label">Loại giảm giá <span style="color:#C62828">*</span></label>
            <select class="form-select" name="discountType" id="addType"
                onchange="syncValueInput('addType','addValue','addValueLabel')">
                <option value="0">Giảm số tiền cố định (VNĐ)</option>
                <option value="1">Giảm theo phần trăm (%)</option>
            </select>
        </div>

        <div class="mb-4">
            <%-- Label và placeholder được cập nhật bằng JS khi đổi loại --%>
                <label class="form-label" id="addValueLabel">
                    Giá trị giảm (VNĐ) <span style="color:#C62828">*</span>
                </label>
                <%-- BUG FIX: Trước đây step="1000" khiến HTML5 validation báo
                    lỗi "The two nearest valid values are 1 and 1001" khi nhập giá trị % như 10, 20, 30 (vì chúng không
                    phải bội của 1000). Fix: - step="1" luôn (không gây lỗi validation bội số) - max="" được set động
                    qua JS: 100 khi chọn %, không giới hạn khi chọn VNĐ - placeholder thay đổi theo loại --%>
                    <input type="number" class="form-control" name="discountValue" id="addValue" min="1" step="1"
                        placeholder="VD: 20000" required>
                    <p style="font-size:0.75rem;color:#9E7B5E;margin-top:4px" id="addValueHint">
                        Nhập số tiền giảm (VNĐ)
                    </p>
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

        <script>
            /**
             * Đồng bộ các thuộc tính của input giá trị giảm khi đổi loại giảm giá.
             * Gọi được từ cả modal Thêm mới và form Chỉnh sửa.
             *
             * @param {string} typeId      - id của <select> loại giảm giá
             * @param {string} valueId     - id của <input> giá trị
             * @param {string} labelId     - id của <label> giá trị
             */
            function syncValueInput(typeId, valueId, labelId) {
                const isPercent = document.getElementById(typeId).value === '1';
                const input = document.getElementById(valueId);
                const label = document.getElementById(labelId);
                const hint = document.getElementById(labelId.replace('Label', 'Hint')
                    || (labelId + 'Hint'));          // fallback nếu id khác

                if (isPercent) {
                    input.min = '1';
                    input.max = '100';
                    input.step = '1';
                    input.placeholder = 'VD: 10 (tức giảm 10%)';
                    if (label) label.innerHTML =
                        'Giá trị giảm (%) <span style="color:#C62828">*</span>';
                    if (hint) hint.textContent = 'Nhập phần trăm giảm từ 1 đến 100';
                } else {
                    input.min = '1';
                    input.max = '';          // không giới hạn max
                    input.step = '1000';
                    input.placeholder = 'VD: 20000';
                    if (label) label.innerHTML =
                        'Giá trị giảm (VNĐ) <span style="color:#C62828">*</span>';
                    if (hint) hint.textContent = 'Nhập số tiền giảm (VNĐ)';
                }

                // Xóa giá trị cũ để tránh submit giá trị không hợp lệ
                input.value = '';
            }

            /* Alias cũ để không phá form edit nếu nó vẫn gọi toggleValueLabel */
            function toggleValueLabel(prefix) {
                const typeId = prefix + 'Type';
                const valueId = prefix + 'Value';
                const labelId = prefix + 'ValueLabel';
                syncValueInput(typeId, valueId, labelId);
            }
        </script>