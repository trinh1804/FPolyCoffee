<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ include file="/views/layout/header.jsp" %>

                <div class="flex items-center justify-between mb-6">
                    <h1 class="section-title mb-0">
                        <span class="material-symbols-outlined" style="color:#8B4513">coffee</span>
                        Quản lý đồ uống
                    </h1>
                    <button onclick="openModal('addModal')" class="btn btn-primary">
                        <span class="material-symbols-outlined text-[18px]">add_circle</span> Thêm đồ uống
                    </button>
                </div>

                <c:if test="${not empty message}">
                    <div class="alert alert-success"><span
                            class="material-symbols-outlined text-[18px]">check_circle</span> ${message}</div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger"><span class="material-symbols-outlined text-[18px]">error</span>
                        ${error}</div>
                </c:if>

                <!-- Search -->
                <div class="pc-card mb-6">
                    <div class="pc-card-header">
                        <span class="material-symbols-outlined text-[18px]" style="color:#8B4513">search</span>
                        Tìm kiếm đồ uống
                    </div>
                    <div class="p-5">
                        <form action="${pageContext.request.contextPath}/manager/drinks" method="get">
                            <div class="grid grid-cols-1 md:grid-cols-4 gap-4 items-end">
                                <div>
                                    <label class="form-label">Tên đồ uống</label>
                                    <input type="text" class="form-control" name="searchName" value="${searchName}"
                                        placeholder="Nhập tên">
                                </div>
                                <div>
                                    <label class="form-label">Danh mục</label>
                                    <select class="form-select" name="categoryId">
                                        <option value="0">-- Tất cả --</option>
                                        <c:forEach items="${categories}" var="cat">
                                            <option value="${cat.id}" ${selectedCategoryId==cat.id ? 'selected' : '' }>
                                                ${cat.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div>
                                    <label class="form-label">Trạng thái</label>
                                    <select class="form-select" name="status">
                                        <option value="">-- Tất cả --</option>
                                        <option value="active" ${selectedStatus=='active' ? 'selected' :''}>Đang bán
                                        </option>
                                        <option value="inactive" ${selectedStatus=='inactive' ? 'selected' :''}>
                                            Ngừng bán</option>
                                    </select>
                                </div>
                                <div class="flex gap-2">
                                    <button type="submit" class="btn btn-primary flex-1">
                                        <span class="material-symbols-outlined text-[18px]">search</span> Tìm
                                    </button>
                                    <a href="${pageContext.request.contextPath}/manager/drinks" class="btn btn-outline">
                                        <span class="material-symbols-outlined text-[18px]">refresh</span>
                                    </a>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Table -->
                <div class="pc-card">
                    <div class="pc-card-header justify-between">
                        <div class="flex items-center gap-2">
                            <span class="material-symbols-outlined text-[18px]" style="color:#8B4513">list</span>
                            Danh sách đồ uống
                        </div>
                        <span class="badge badge-secondary">${totalRecords} sản phẩm</span>
                    </div>
                    <div class="overflow-x-auto">
                        <table class="data-table w-full">
                            <thead>
                                <tr>
                                    <th class="text-center">ID</th>
                                    <th class="text-center">Ảnh</th>
                                    <th>Tên đồ uống</th>
                                    <th class="text-right">Giá</th>
                                    <th class="text-center">Danh mục</th>
                                    <th class="text-center">Trạng thái</th>
                                    <th class="text-center">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${drinks}" var="drink">
                                    <tr>
                                        <td class="text-center" style="color:#9E7B5E;font-size:0.85rem">
                                            ${drink.id}</td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${not empty drink.image}">
                                                    <img src="${pageContext.request.contextPath}/uploads/${drink.image}"
                                                        class="rounded-xl object-cover mx-auto"
                                                        style="width:44px;height:44px" alt=""
                                                        onerror="this.style.display='none';this.nextElementSibling.style.display='flex'">
                                                    <div class="rounded-xl mx-auto hidden items-center justify-center"
                                                        style="width:44px;height:44px;background:#F5E6D3">
                                                        <span class="material-symbols-outlined"
                                                            style="color:#C6956A;font-size:20px">coffee</span>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="rounded-xl mx-auto flex items-center justify-center"
                                                        style="width:44px;height:44px;background:#F5E6D3">
                                                        <span class="material-symbols-outlined"
                                                            style="color:#C6956A;font-size:20px">coffee</span>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <p class="font-semibold" style="color:#2C1A0E">${drink.name}</p>
                                            <p style="font-size:0.78rem;color:#9E7B5E;overflow:hidden;text-overflow:ellipsis;
                                      white-space:nowrap;max-width:180px">${drink.description}</p>
                                        </td>
                                        <td class="text-right font-bold" style="color:#8B4513;white-space:nowrap">
                                            <fmt:formatNumber value="${drink.price}" pattern="#,##0" /> ₫
                                        </td>
                                        <td class="text-center">
                                            <c:forEach items="${categories}" var="cat">
                                                <c:if test="${cat.id == drink.categoryId}">
                                                    <span class="badge badge-info">${cat.name}</span>
                                                </c:if>
                                            </c:forEach>
                                        </td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${drink.active}">
                                                    <span class="badge badge-success">
                                                        <span
                                                            class="material-symbols-outlined text-[12px]">check_circle</span>
                                                        Đang bán
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-neutral">
                                                        <span class="material-symbols-outlined text-[12px]">block</span>
                                                        Ngừng bán
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <div class="flex items-center justify-center gap-1.5">

                                                <!-- Edit -->
                                                <button type="button" class="btn btn-secondary btn-icon" title="Sửa"
                                                    data-id="${drink.id}" data-name="${drink.name}"
                                                    data-price="${drink.price}" data-category="${drink.categoryId}"
                                                    data-description="${drink.description}"
                                                    data-active="${drink.active}" onclick="openEditModal(this)">
                                                    <span class="material-symbols-outlined text-[16px]">edit</span>
                                                </button>

                                                <!-- Toggle mở / ẩn -->
                                                <c:set var="msg" value="${drink.active ? 'Ngừng bán' : 'Mở bán lại'}" />
                                                <form
                                                    action="${pageContext.request.contextPath}/manager/drinks/toggle-status"
                                                    method="post" class="inline"
                                                    onsubmit="return confirm('${msg} đồ uống này?')">
                                                    <input type="hidden" name="id" value="${drink.id}">
                                                    <button type="submit" class="btn btn-icon ${drink.active ? 'btn-outline' :
                                                        'btn-success'}"
                                                        title="${drink.active ? 'Ngừng bán' : 'Mở bán lại'}">
                                                        <span class="material-symbols-outlined text-[16px]">
                                                            ${drink.active ? 'visibility_off' : 'visibility'}
                                                        </span>
                                                    </button>
                                                </form>

                                                <!-- Delete -->
                                                <form action="${pageContext.request.contextPath}/manager/drinks/delete"
                                                    method="post" class="inline"
                                                    onsubmit="return confirm('Xóa đồ uống \'${drink.name}\'?')">
                                                    <input type="hidden" name="id" value="${drink.id}">
                                                    <button type="submit" class="btn btn-icon btn-danger" title="Xóa">
                                                        <span
                                                            class="material-symbols-outlined text-[16px]">delete</span>
                                                    </button>
                                                </form>

                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty drinks}">
                                    <tr>
                                        <td colspan="7" class="text-center" style="padding:4rem;color:#9E7B5E">
                                            <span class="material-symbols-outlined block mb-2"
                                                style="font-size:4rem;opacity:.25">coffee</span>
                                            Không tìm thấy đồ uống nào
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <div class="p-5 flex justify-center gap-1">
                            <a href="?page=${currentPage-1}&searchName=${searchName}&categoryId=${selectedCategoryId}&status=${selectedStatus}"
                                class="page-btn ${currentPage == 1 ? 'disabled' : ''}">
                                <span class="material-symbols-outlined text-[16px]">chevron_left</span>
                            </a>
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <a href="?page=${i}&searchName=${searchName}&categoryId=${selectedCategoryId}&status=${selectedStatus}"
                                    class="page-btn ${currentPage == i ? 'active' : ''}">${i}</a>
                            </c:forEach>
                            <a href="?page=${currentPage+1}&searchName=${searchName}&categoryId=${selectedCategoryId}&status=${selectedStatus}"
                                class="page-btn ${currentPage == totalPages ? 'disabled' : ''}">
                                <span class="material-symbols-outlined text-[16px]">chevron_right</span>
                            </a>
                        </div>
                    </c:if>
                </div>

                <!-- ══ ADD MODAL ══ -->
                <div id="addModal" class="modal-backdrop" style="display:none"
                    onclick="if(event.target===this)closeModal('addModal')">
                    <div class="modal-box">
                        <div class="modal-header">
                            <span style="font-family:'Playfair Display',serif;font-weight:700;color:#F5E6D3">Thêm
                                đồ uống mới</span>
                            <button onclick="closeModal('addModal')" class="btn btn-icon"
                                style="color:rgba(245,230,211,0.7);background:rgba(255,255,255,0.1)">
                                <span class="material-symbols-outlined">close</span>
                            </button>
                        </div>
                        <div class="p-6">
                            <form action="${pageContext.request.contextPath}/manager/drinks/add" method="post"
                                enctype="multipart/form-data">
                                <div class="mb-4">
                                    <label class="form-label">Tên đồ uống <span style="color:#C62828">*</span></label>
                                    <input type="text" class="form-control" name="name" placeholder="VD: Cà phê muối"
                                        required>
                                </div>
                                <div class="grid grid-cols-2 gap-4 mb-4">
                                    <div>
                                        <label class="form-label">Giá (VNĐ) <span style="color:#C62828">*</span></label>
                                        <input type="number" class="form-control" name="price" step="1000"
                                            placeholder="35000" required min="1000">
                                    </div>
                                    <div>
                                        <label class="form-label">Danh mục <span style="color:#C62828">*</span></label>
                                        <select class="form-select" name="categoryId" required>
                                            <option value="">-- Chọn --</option>
                                            <c:forEach items="${categories}" var="cat">
                                                <option value="${cat.id}">${cat.name}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>
                                <div class="mb-4">
                                    <label class="form-label">Mô tả</label>
                                    <textarea class="form-control" name="description" rows="2"
                                        placeholder="Mô tả ngắn..."></textarea>
                                </div>
                                <div class="mb-4">
                                    <label class="form-label">Hình ảnh</label>
                                    <input type="file" class="form-control" name="image" accept="image/*">
                                </div>
                                <div class="flex items-center gap-2 mb-5">
                                    <input type="checkbox" id="addActive" name="active" value="true" checked
                                        class="accent-caramel w-4 h-4">
                                    <label for="addActive" class="form-label mb-0 cursor-pointer">Đang
                                        bán</label>
                                </div>
                                <div class="flex gap-3">
                                    <button type="submit" class="btn btn-primary flex-1 py-3">
                                        <span class="material-symbols-outlined text-[18px]">add</span> Thêm
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
                            <span style="font-family:'Playfair Display',serif;font-weight:700;color:#F5E6D3">Chỉnh
                                sửa đồ uống</span>
                            <button onclick="closeModal('editModal')" class="btn btn-icon"
                                style="color:rgba(245,230,211,0.7);background:rgba(255,255,255,0.1)">
                                <span class="material-symbols-outlined">close</span>
                            </button>
                        </div>
                        <div class="p-6">
                            <form action="${pageContext.request.contextPath}/manager/drinks/edit" method="post"
                                enctype="multipart/form-data">
                                <input type="hidden" id="editDrinkId" name="id">
                                <div class="mb-4">
                                    <label class="form-label">Tên đồ uống <span style="color:#C62828">*</span></label>
                                    <input type="text" class="form-control" id="editDrinkName" name="name" required>
                                </div>
                                <div class="grid grid-cols-2 gap-4 mb-4">
                                    <div>
                                        <label class="form-label">Giá (VNĐ) <span style="color:#C62828">*</span></label>
                                        <input type="number" class="form-control" id="editDrinkPrice" name="price"
                                            step="1000" min="1000" required>
                                    </div>
                                    <div>
                                        <label class="form-label">Danh mục <span style="color:#C62828">*</span></label>
                                        <select class="form-select" id="editDrinkCat" name="categoryId" required>
                                            <option value="">-- Chọn --</option>
                                            <c:forEach items="${categories}" var="cat">
                                                <option value="${cat.id}">${cat.name}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>
                                <div class="mb-4">
                                    <label class="form-label">Mô tả</label>
                                    <textarea class="form-control" id="editDrinkDesc" name="description"
                                        rows="2"></textarea>
                                </div>
                                <div class="mb-4">
                                    <label class="form-label">Hình ảnh mới <span
                                            style="font-size:0.78rem;color:#9E7B5E">(để trống giữ ảnh
                                            cũ)</span></label>
                                    <input type="file" class="form-control" name="image" accept="image/*">
                                </div>
                                <div class="flex items-center gap-2 mb-5">
                                    <input type="checkbox" id="editDrinkActive" name="active" value="true"
                                        class="accent-caramel w-4 h-4">
                                    <label for="editDrinkActive" class="form-label mb-0 cursor-pointer">Đang bán</label>
                                </div>
                                <div class="flex gap-3">
                                    <button type="submit" class="btn btn-primary flex-1 py-3">
                                        <span class="material-symbols-outlined text-[18px]">save</span>
                                        Lưu
                                    </button>
                                    <button type="button" onclick="closeModal('editModal')"
                                        class="btn btn-outline flex-1 py-3">Hủy</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <script>
                    function openModal(id) { document.getElementById(id).style.display = 'flex'; }
                    function closeModal(id) { document.getElementById(id).style.display = 'none'; }

                    function openEditModal(btn) {
                        document.getElementById('editDrinkId').value = btn.dataset.id;
                        document.getElementById('editDrinkName').value = btn.dataset.name;
                        document.getElementById('editDrinkPrice').value = btn.dataset.price;
                        document.getElementById('editDrinkDesc').value = btn.dataset.description;
                        document.getElementById('editDrinkCat').value = btn.dataset.category;
                        document.getElementById('editDrinkActive').checked = btn.dataset.active === "true";
                        openModal('editModal');
                    }
                </script>

                <%@ include file="/views/layout/footer.jsp" %>