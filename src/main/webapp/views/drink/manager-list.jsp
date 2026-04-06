<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ include file="/views/layout/header.jsp" %>


                <div class="flex items-center justify-between mb-6">
                    <h1 class="section-title mb-0">
                        <span class="material-symbols-outlined text-primary">coffee</span>
                        Quản lý đồ uống
                    </h1>
                    <button type="button" onclick="document.getElementById('addDrinkModal').classList.remove('hidden')"
                        class="btn btn-primary">
                        <span class="material-symbols-outlined text-[18px]">add_circle</span>
                        Thêm đồ uống
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
                        <span class="material-symbols-outlined text-primary text-[18px]">search</span>
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
                                        <option value="active" ${selectedStatus=='active' ? 'selected' : '' }>Đang bán
                                        </option>
                                        <option value="inactive" ${selectedStatus=='inactive' ? 'selected' : '' }>Ngừng
                                            bán</option>
                                    </select>
                                </div>
                                <div class="flex gap-2">
                                    <button type="submit" class="btn btn-primary flex-1">
                                        <span class="material-symbols-outlined text-[18px]">search</span> Tìm
                                    </button>
                                    <a href="${pageContext.request.contextPath}/manager/drinks"
                                        class="btn btn-outline flex-1">
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
                            <span class="material-symbols-outlined text-primary text-[18px]">list</span>
                            Danh sách đồ uống
                        </div>
                        <span class="badge badge-secondary">${totalRecords} sản phẩm</span>
                    </div>
                    <div class="overflow-x-auto">
                        <table class="data-table w-full">
                            <thead>
                                <tr>
                                    <th class="text-center">ID</th>
                                    <th class="text-center">Hình</th>
                                    <th>Tên đồ uống</th>
                                    <th class="text-right">Giá</th>
                                    <th class="text-center">Danh mục</th>
                                    <th>Mô tả</th>
                                    <th class="text-center">Trạng thái</th>
                                    <th class="text-center">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${drinks}" var="drink">
                                    <tr>
                                        <td class="text-center text-on-surface-variant text-sm">${drink.id}</td>
                                        <td class="text-center">
                                            <c:if test="${not empty drink.image}">
                                                <img src="${pageContext.request.contextPath}/uploads/${drink.image}"
                                                    class="rounded-xl object-cover mx-auto"
                                                    style="width:44px;height:44px" alt="">
                                            </c:if>
                                            <c:if test="${empty drink.image}">
                                                <div
                                                    class="rounded-xl bg-surface-container w-11 h-11 mx-auto flex items-center justify-center">
                                                    <span
                                                        class="material-symbols-outlined text-outline text-[20px]">coffee</span>
                                                </div>
                                            </c:if>
                                        </td>
                                        <td class="font-semibold text-on-surface">${drink.name}</td>
                                        <td class="text-right font-semibold text-primary" style="white-space:nowrap">
                                            <fmt:formatNumber value="${drink.price}" pattern="#,##0" /> ₫
                                        </td>
                                        <td class="text-center">
                                            <c:forEach items="${categories}" var="cat">
                                                <c:if test="${cat.id == drink.categoryId}">
                                                    <span class="badge badge-info">${cat.name}</span>
                                                </c:if>
                                            </c:forEach>
                                        </td>
                                        <td class="text-on-surface-variant text-sm"
                                            style="max-width:140px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap">
                                            ${drink.description}</td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${drink.active}">
                                                    <span class="badge badge-success"><span
                                                            class="material-symbols-outlined text-[14px]">check_circle</span>Đang
                                                        bán</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-secondary"><span
                                                            class="material-symbols-outlined text-[14px]">block</span>Ngừng
                                                        bán</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <div class="flex items-center justify-center gap-2">
                                                <a href="${pageContext.request.contextPath}/manager/drinks/edit?id=${drink.id}"
                                                    class="btn btn-secondary btn-sm" title="Sửa">
                                                    <span class="material-symbols-outlined text-[16px]">edit</span>
                                                </a>
                                                <form action="${pageContext.request.contextPath}/manager/drinks/delete"
                                                    method="post" class="inline"
                                                    onsubmit="return confirm('Bạn có chắc muốn ẩn đồ uống này?')">
                                                    <input type="hidden" name="id" value="${drink.id}">
                                                    <button type="submit" class="btn btn-danger btn-sm" title="Ẩn">
                                                        <span
                                                            class="material-symbols-outlined text-[16px]">visibility_off</span>
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty drinks}">
                                    <tr>
                                        <td colspan="8" class="text-center py-12 text-on-surface-variant">
                                            <span
                                                class="material-symbols-outlined text-5xl block mb-2 opacity-30">inbox</span>
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

                <!-- Add Drink Modal -->
                <div id="addDrinkModal" class="hidden fixed inset-0 z-50 flex items-center justify-center p-4"
                    style="background:rgba(0,0,0,0.4)">
                    <div class="pc-card w-full max-w-md max-h-[90vh] overflow-y-auto">
                        <div class="pc-card-header justify-between"
                            style="background: linear-gradient(135deg, #3d1f0d, #874210);">
                            <div class="flex items-center gap-2 text-white">
                                <span class="material-symbols-outlined text-[18px]">add_circle</span>
                                <span class="font-headline font-bold text-white">Thêm đồ uống mới</span>
                            </div>
                            <button onclick="document.getElementById('addDrinkModal').classList.add('hidden')"
                                class="text-white/70 hover:text-white">
                                <span class="material-symbols-outlined">close</span>
                            </button>
                        </div>
                        <div class="p-6">
                            <form action="${pageContext.request.contextPath}/manager/drinks/add" method="post"
                                enctype="multipart/form-data">
                                <div class="mb-4">
                                    <label class="form-label">Tên đồ uống <span class="text-error">*</span></label>
                                    <input type="text" class="form-control" name="name" placeholder="Nhập tên" required>
                                </div>
                                <div class="mb-4">
                                    <label class="form-label">Giá (VNĐ) <span class="text-error">*</span></label>
                                    <input type="number" class="form-control" name="price" step="1000"
                                        placeholder="VD: 35000" required>
                                </div>
                                <div class="mb-4">
                                    <label class="form-label">Danh mục <span class="text-error">*</span></label>
                                    <select class="form-select" name="categoryId" required>
                                        <option value="">-- Chọn danh mục --</option>
                                        <c:forEach items="${categories}" var="cat">
                                            <option value="${cat.id}">${cat.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="mb-4">
                                    <label class="form-label">Mô tả</label>
                                    <textarea class="form-control" name="description" rows="3"
                                        placeholder="Mô tả đồ uống..."></textarea>
                                </div>
                                <div class="mb-4">
                                    <label class="form-label">Hình ảnh</label>
                                    <input type="file" class="form-control" name="image" accept="image/*">
                                </div>
                                <div class="flex items-center gap-2 mb-5">
                                    <input type="checkbox" id="activeChk" name="active" class="w-4 h-4 accent-primary"
                                        checked>
                                    <label for="activeChk" class="text-sm text-on-surface cursor-pointer">Đang
                                        bán</label>
                                </div>
                                <div class="flex gap-3">
                                    <button type="submit" class="btn btn-primary flex-1 py-3">
                                        <span class="material-symbols-outlined text-[18px]">save</span> Thêm
                                    </button>
                                    <button type="button"
                                        onclick="document.getElementById('addDrinkModal').classList.add('hidden')"
                                        class="btn btn-outline flex-1 py-3">Hủy</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <%@ include file="/views/layout/footer.jsp" %>