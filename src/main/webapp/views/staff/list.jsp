<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="/views/layout/header.jsp" %>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

        <div class="container">
            <h2 class="mb-4">
                <i class="bi bi-people"></i> Quản lý nhân viên
            </h2>

            <c:if test="${not empty message}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="bi bi-check-circle-fill"></i> ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="bi bi-exclamation-triangle-fill"></i> ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Form tìm kiếm -->
            <div class="card mb-4">
                <div class="card-header bg-info text-white">
                    <h5 class="mb-0">
                        <i class="bi bi-search"></i> Tìm kiếm nhân viên
                    </h5>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/manager/staff" method="get" class="row g-3">
                        <div class="col-md-4">
                            <label class="form-label">Họ tên</label>
                            <input type="text" class="form-control" name="searchName" value="${searchName}"
                                placeholder="Nhập họ tên">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Email</label>
                            <input type="email" class="form-control" name="searchEmail" value="${searchEmail}"
                                placeholder="Nhập email">
                        </div>
                        <div class="col-md-2">
                            <label class="form-label">Trạng thái</label>
                            <select class="form-select" name="status">
                                <option value="">-- Tất cả --</option>
                                <option value="active" ${selectedStatus=='active' ? 'selected' : '' }>Đang hoạt động
                                </option>
                                <option value="inactive" ${selectedStatus=='inactive' ? 'selected' : '' }>Đã khóa
                                </option>
                            </select>
                        </div>
                        <div class="col-md-2 d-flex align-items-end">
                            <button type="submit" class="btn btn-primary w-100">
                                <i class="bi bi-search"></i> Tìm kiếm
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Danh sách nhân viên -->
            <div class="card">
                <div class="card-header bg-info text-white">
                    <h5 class="mb-0">
                        <i class="bi bi-list"></i> Danh sách nhân viên
                        <span class="badge bg-light text-dark float-end">${totalRecords} nhân viên</span>
                    </h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-bordered table-hover">
                            <thead class="table-light">
                                <tr class="text-center">
                                    <th>ID</th>
                                    <th>Họ và tên</th>
                                    <th>Email</th>
                                    <th>Số điện thoại</th>
                                    <th>Trạng thái</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${staffList}" var="staff">
                                    <tr>
                                        <td class="text-center">${staff.id}</td>
                                        <td><strong>${staff.fullName}</strong></td>
                                        <td>${staff.email}</td>
                                        <td>${staff.phone}</td>
                                        <td class="text-center">
                                            <span class="badge ${staff.active ? 'bg-success' : 'bg-secondary'}">
                                                <i class="bi ${staff.active ? 'bi-check-circle' : 'bi-x-circle'}"></i>
                                                ${staff.active ? 'Đang hoạt động' : 'Đã khóa'}
                                            </span>
                                        </td>
                                        <td class="text-center">
                                            <form
                                                action="${pageContext.request.contextPath}/manager/staff/reset-password"
                                                method="post" style="display:inline"
                                                onsubmit="return confirm('Bạn có chắc muốn cấp lại mật khẩu cho nhân viên ${staff.fullName}? Mật khẩu mới sẽ được gửi qua email.')">
                                                <input type="hidden" name="id" value="${staff.id}">
                                                <button type="submit" class="btn btn-sm btn-warning"
                                                    title="Cấp lại mật khẩu">
                                                    <i class="bi bi-key"></i> Cấp lại MK
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty staffList}">
                                    <tr>
                                        <td colspan="6" class="text-center text-muted">
                                            <i class="bi bi-inbox"></i> Không tìm thấy nhân viên nào
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>

                    <!-- Phân trang -->
                    <c:if test="${totalPages > 1}">
                        <nav aria-label="Page navigation">
                            <ul class="pagination justify-content-center">
                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                    <a class="page-link"
                                        href="?page=${currentPage-1}&searchName=${searchName}&searchEmail=${searchEmail}&status=${selectedStatus}">
                                        <i class="bi bi-chevron-left"></i> Trước
                                    </a>
                                </li>

                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                                        <a class="page-link"
                                            href="?page=${i}&searchName=${searchName}&searchEmail=${searchEmail}&status=${selectedStatus}">${i}</a>
                                    </li>
                                </c:forEach>

                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                    <a class="page-link"
                                        href="?page=${currentPage+1}&searchName=${searchName}&searchEmail=${searchEmail}&status=${selectedStatus}">
                                        Sau <i class="bi bi-chevron-right"></i>
                                    </a>
                                </li>
                            </ul>
                        </nav>
                    </c:if>
                </div>
            </div>
        </div>