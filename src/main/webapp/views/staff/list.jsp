<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ include file="/views/layout/header.jsp" %>

            <div class="flex items-center justify-between mb-6">
                <h1 class="section-title mb-0">
                    <span class="material-symbols-outlined text-primary">group</span>
                    Quản lý nhân viên
                </h1>
                <a href="${pageContext.request.contextPath}/manager/staff/create" class="btn btn-primary">
                    <span class="material-symbols-outlined text-[18px]">person_add</span>
                    Thêm nhân viên
                </a>
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

            <!-- Search -->
            <div class="pc-card mb-6">
                <div class="pc-card-header">
                    <span class="material-symbols-outlined text-primary text-[18px]">search</span>
                    Tìm kiếm nhân viên
                </div>
                <div class="p-5">
                    <form action="${pageContext.request.contextPath}/manager/staff" method="get">
                        <div class="grid grid-cols-1 md:grid-cols-4 gap-4 items-end">
                            <div>
                                <label class="form-label">Họ và tên</label>
                                <input type="text" class="form-control" name="searchName" value="${searchName}"
                                    placeholder="Nhập họ tên">
                            </div>
                            <div>
                                <label class="form-label">Email</label>
                                <input type="email" class="form-control" name="searchEmail" value="${searchEmail}"
                                    placeholder="Nhập email">
                            </div>
                            <div>
                                <label class="form-label">Trạng thái</label>
                                <select class="form-select" name="status">
                                    <option value="">-- Tất cả --</option>
                                    <option value="active" ${selectedStatus=='active' ? 'selected' : '' }>Đang hoạt động
                                    </option>
                                    <option value="inactive" ${selectedStatus=='inactive' ? 'selected' : '' }>Đã khóa
                                    </option>
                                </select>
                            </div>
                            <div class="flex gap-2">
                                <button type="submit" class="btn btn-primary flex-1">
                                    <span class="material-symbols-outlined text-[18px]">search</span> Tìm
                                </button>
                                <a href="${pageContext.request.contextPath}/manager/staff"
                                    class="btn btn-outline flex-1">
                                    <span class="material-symbols-outlined text-[18px]">refresh</span> Làm mới
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
                        Danh sách nhân viên
                    </div>
                    <span class="badge badge-secondary">${totalRecords} nhân viên</span>
                </div>
                <div class="overflow-x-auto">
                    <table class="data-table w-full">
                        <thead>
                            <tr>
                                <th class="text-center">ID</th>
                                <th>Họ và tên</th>
                                <th>Email</th>
                                <th>Số điện thoại</th>
                                <th class="text-center">Vai trò</th>
                                <th class="text-center">Trạng thái</th>
                                <th class="text-center">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${staffList}" var="staff">
                                <tr>
                                    <td class="text-center text-on-surface-variant text-sm">${staff.id}</td>
                                    <td class="font-semibold text-on-surface">${staff.fullName}</td>
                                    <td class="text-on-surface-variant text-sm">${staff.email}</td>
                                    <td class="text-on-surface-variant text-sm">${staff.phone}</td>
                                    <td class="text-center">
                                        <c:if test="${staff.roleId == 1}">
                                            <span class="badge badge-danger"><span
                                                    class="material-symbols-outlined text-[14px]">shield</span>Admin</span>
                                        </c:if>
                                        <c:if test="${staff.roleId == 2}">
                                            <span class="badge badge-gold"><span
                                                    class="material-symbols-outlined text-[14px]">badge</span>Nhân
                                                viên</span>
                                        </c:if>
                                    </td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${staff.active}">
                                                <span class="badge badge-success"><span
                                                        class="material-symbols-outlined text-[14px]">check_circle</span>Hoạt
                                                    động</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-secondary"><span
                                                        class="material-symbols-outlined text-[14px]">block</span>Đã
                                                    khóa</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <div class="flex items-center justify-center gap-2">
                                            <a href="${pageContext.request.contextPath}/manager/staff/edit?id=${staff.id}"
                                                class="btn btn-secondary btn-sm" title="Sửa">
                                                <span class="material-symbols-outlined text-[16px]">edit</span>
                                            </a>
                                            <c:set var="action" value="${staff.active ? 'khóa' : 'mở khóa'}" />
                                            <form
                                                action="${pageContext.request.contextPath}/manager/staff/toggle-status"
                                                method="post" class="inline"
                                                onsubmit="return confirm('Bạn có chắc muốn ${action} tài khoản ${staff.fullName}?')">
                                                <input type="hidden" name="id" value="${staff.id}">
                                                <button type="submit"
                                                    class="btn ${staff.active ? 'btn-outline' : 'badge-success'} btn-sm"
                                                    title="${staff.active ? 'Khóa' : 'Mở khóa'}">
                                                    <span class="material-symbols-outlined text-[16px]">${staff.active ?
                                                        'lock' : 'lock_open'}</span>
                                                </button>
                                            </form>
                                            <form action="${pageContext.request.contextPath}/manager/staff/delete"
                                                method="post" class="inline"
                                                onsubmit="return confirm('Bạn có chắc muốn xóa nhân viên ${staff.fullName}?')">
                                                <input type="hidden" name="id" value="${staff.id}">
                                                <button type="submit" class="btn btn-danger btn-sm" title="Xóa">
                                                    <span class="material-symbols-outlined text-[16px]">delete</span>
                                                </button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty staffList}">
                                <tr>
                                    <td colspan="7" class="text-center py-12 text-on-surface-variant">
                                        <span
                                            class="material-symbols-outlined text-5xl block mb-2 opacity-30">inbox</span>
                                        Không tìm thấy nhân viên nào
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->
                <c:if test="${totalPages > 1}">
                    <div class="p-5 flex justify-center gap-1">
                        <a href="?page=${currentPage-1}&searchName=${searchName}&searchEmail=${searchEmail}&status=${selectedStatus}"
                            class="page-btn ${currentPage == 1 ? 'disabled' : ''}">
                            <span class="material-symbols-outlined text-[16px]">chevron_left</span>
                        </a>
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <a href="?page=${i}&searchName=${searchName}&searchEmail=${searchEmail}&status=${selectedStatus}"
                                class="page-btn ${currentPage == i ? 'active' : ''}">${i}</a>
                        </c:forEach>
                        <a href="?page=${currentPage+1}&searchName=${searchName}&searchEmail=${searchEmail}&status=${selectedStatus}"
                            class="page-btn ${currentPage == totalPages ? 'disabled' : ''}">
                            <span class="material-symbols-outlined text-[16px]">chevron_right</span>
                        </a>
                    </div>
                </c:if>
            </div>

            <%@ include file="/views/layout/footer.jsp" %>