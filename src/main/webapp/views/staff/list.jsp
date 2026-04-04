<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="/views/layout/header.jsp" %>

        <h4 class="fw-bold mb-4" style="color:#3d1f0d">
            <i class="bi bi-people me-2"></i>Quản lý nhân viên
        </h4>

        <c:if test="${not empty message}">
            <div class="alert alert-success alert-dismissible fade show">
                <i class="bi bi-check-circle-fill me-1"></i> ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show">
                <i class="bi bi-exclamation-triangle-fill me-1"></i> ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Tìm kiếm -->
        <div class="card shadow-sm border-0 rounded-3 mb-4">
            <div class="card-header card-header-mid py-3 border-0">
                <i class="bi bi-search me-1"></i> Tìm kiếm nhân viên
            </div>
            <div class="card-body p-3">
                <form action="${pageContext.request.contextPath}/manager/staff" method="get">
                    <div class="row g-2 align-items-end">
                        <div class="col-md-3">
                            <label class="form-label fw-semibold small">Họ và tên</label>
                            <input type="text" class="form-control" name="searchName" value="${searchName}"
                                placeholder="Nhập họ tên">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-semibold small">Email</label>
                            <input type="email" class="form-control" name="searchEmail" value="${searchEmail}"
                                placeholder="Nhập email">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-semibold small">Trạng thái</label>
                            <select class="form-select" name="status">
                                <option value="">-- Tất cả --</option>
                                <option value="active" ${selectedStatus=='active' ? 'selected' : '' }>Đang hoạt động
                                </option>
                                <option value="inactive" ${selectedStatus=='inactive' ? 'selected' : '' }>Đã khóa
                                </option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-semibold small">&nbsp;</label>
                            <div class="d-flex gap-2">
                                <button type="submit" class="btn btn-coffee flex-grow-1">
                                    <i class="bi bi-search me-1"></i> Tìm
                                </button>
                                <a href="${pageContext.request.contextPath}/manager/staff"
                                    class="btn btn-outline-secondary flex-grow-1">
                                    <i class="bi bi-arrow-repeat me-1"></i> Làm mới
                                </a>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <!-- Nút thêm -->
        <div class="mb-3">
            <a href="${pageContext.request.contextPath}/manager/staff/create" class="btn btn-coffee">
                <i class="bi bi-plus-circle me-1"></i> Thêm nhân viên mới
            </a>
        </div>

        <!-- Danh sách -->
        <div class="card shadow-sm border-0 rounded-3">
            <div class="card-header card-header-mid py-3 border-0 d-flex justify-content-between align-items-center">
                <span><i class="bi bi-list me-1"></i> Danh sách nhân viên</span>
                <span class="badge bg-light text-dark">${totalRecords} nhân viên</span>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr class="text-center">
                                <th>ID</th>
                                <th class="text-start">Họ và tên</th>
                                <th>Email</th>
                                <th>Số điện thoại</th>
                                <th>Vai trò</th>
                                <th>Trạng thái</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${staffList}" var="staff">
                                <tr>
                                    <td class="text-center text-muted small">${staff.id}</td>
                                    <td><strong>${staff.fullName}</strong></td>
                                    <td class="text-muted small">${staff.email}</td>
                                    <td class="text-muted small">${staff.phone}</td>
                                    <td class="text-center">
                                        <c:if test="${staff.roleId == 1}">
                                            <span class="badge bg-danger">
                                                <i class="bi bi-shield-check me-1"></i>Quản trị viên
                                            </span>
                                        </c:if>
                                        <c:if test="${staff.roleId == 2}">
                                            <span class="badge" style="background-color:#c47c3e">
                                                <i class="bi bi-person-badge me-1"></i>Nhân viên
                                            </span>
                                        </c:if>
                                    </td>
                                    <td class="text-center">
                                        <span class="badge ${staff.active ? 'bg-success' : 'bg-secondary'}">
                                            <i class="bi ${staff.active ? 'bi-check-circle' : 'bi-x-circle'} me-1"></i>
                                            ${staff.active ? 'Đang hoạt động' : 'Đã khóa'}
                                        </span>
                                    </td>
                                    <td class="text-center" style="white-space:nowrap">
                                        <a href="${pageContext.request.contextPath}/manager/staff/edit?id=${staff.id}"
                                            class="btn btn-sm btn-warning" title="Sửa">
                                            <i class="bi bi-pencil"></i>
                                        </a>
                                        <c:set var="action" value="${staff.active ? 'khóa' : 'mở khóa'}" />
                                        <form action="${pageContext.request.contextPath}/manager/staff/toggle-status"
                                            method="post" class="d-inline"
                                            onsubmit="return confirm('Bạn có chắc muốn ${action} tài khoản nhân viên ${staff.fullName}?')">
                                            <input type="hidden" name="id" value="${staff.id}">
                                            <button type="submit"
                                                class="btn btn-sm ${staff.active ? 'btn-warning' : 'btn-success'}"
                                                title="${staff.active ? 'Khóa tài khoản' : 'Mở khóa tài khoản'}">
                                                <i class="bi ${staff.active ? 'bi-lock' : 'bi-unlock'}"></i>
                                            </button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/manager/staff/delete"
                                            method="post" class="d-inline"
                                            onsubmit="return confirm('Bạn có chắc muốn xóa nhân viên ${staff.fullName}? Hành động này không thể hoàn tác!')">
                                            <input type="hidden" name="id" value="${staff.id}">
                                            <button type="submit" class="btn btn-sm btn-danger" title="Xóa">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty staffList}">
                                <tr>
                                    <td colspan="7" class="text-center text-muted py-5">
                                        <i class="bi bi-inbox fs-2 d-block mb-2"></i>
                                        Không tìm thấy nhân viên nào
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>

                <!-- Phân trang -->
                <c:if test="${totalPages > 1}">
                    <div class="p-3">
                        <nav>
                            <ul class="pagination justify-content-center mb-0">
                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                    <a class="page-link"
                                        href="?page=${currentPage-1}&searchName=${searchName}&searchEmail=${searchEmail}&searchPhone=${searchPhone}&status=${selectedStatus}">
                                        <i class="bi bi-chevron-left"></i> Trước
                                    </a>
                                </li>
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                                        <a class="page-link"
                                            href="?page=${i}&searchName=${searchName}&searchEmail=${searchEmail}&searchPhone=${searchPhone}&status=${selectedStatus}">${i}</a>
                                    </li>
                                </c:forEach>
                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                    <a class="page-link"
                                        href="?page=${currentPage+1}&searchName=${searchName}&searchEmail=${searchEmail}&searchPhone=${searchPhone}&status=${selectedStatus}">
                                        Sau <i class="bi bi-chevron-right"></i>
                                    </a>
                                </li>
                            </ul>
                        </nav>
                    </div>
                </c:if>
            </div>
        </div>