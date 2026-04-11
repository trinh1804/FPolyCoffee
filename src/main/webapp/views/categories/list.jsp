<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ include file="/views/layout/header.jsp" %>

                <div class="flex items-center justify-between mb-6">
                    <h1 class="section-title mb-0">
                        <span class="material-symbols-outlined text-primary">label</span>
                        Quản lý danh mục
                    </h1>
                    <button onclick="document.getElementById('addModal').classList.remove('hidden')"
                        class="btn btn-primary">
                        <span class="material-symbols-outlined text-[18px]">add_circle</span>
                        Thêm danh mục
                    </button>
                </div>

                <!-- Alerts -->
                <c:if test="${not empty message}">
                    <div class="alert alert-success"><span
                            class="material-symbols-outlined text-[18px]">check_circle</span> ${message}</div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger"><span class="material-symbols-outlined text-[18px]">error</span>
                        ${error}</div>
                </c:if>

                <!-- Two-column layout: table left, edit form right -->
                <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">

                    <!-- Category table (2/3) -->
                    <div class="lg:col-span-2">
                        <div class="pc-card">
                            <div class="pc-card-header justify-between px-5 py-4">
                                <div class="flex items-center gap-2">
                                    <span class="material-symbols-outlined text-primary text-[18px]">table_rows</span>
                                    Danh sách danh mục
                                </div>
                                <span class="badge badge-secondary text-xs">${list.size()} danh mục</span>
                            </div>
                            <div class="overflow-x-auto">
                                <table class="data-table w-full">
                                    <thead>
                                        <tr>
                                            <th class="text-center w-12">ID</th>
                                            <th class="text-center w-16">Hình</th>
                                            <th>Tên danh mục</th>
                                            <th>Mô tả</th>
                                            <th class="text-center">Trạng thái</th>
                                            <th class="text-center">Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${list}" var="cat">
                                            <tr>
                                                <td class="text-center text-on-surface-variant text-xs font-mono">
                                                    ${cat.id}</td>
                                                <td class="text-center">
                                                    <c:if test="${not empty cat.image}">
                                                        <img src="${pageContext.request.contextPath}/uploads/${cat.image}"
                                                            class="w-10 h-10 rounded-xl object-cover mx-auto" alt="">
                                                    </c:if>
                                                    <c:if test="${empty cat.image}">
                                                        <div
                                                            class="w-10 h-10 rounded-xl bg-primary-fixed mx-auto flex items-center justify-center">
                                                            <span
                                                                class="material-symbols-outlined text-primary text-[18px]">label</span>
                                                        </div>
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <span
                                                        class="font-headline font-bold text-on-surface">${cat.name}</span>
                                                </td>
                                                <td class="text-on-surface-variant text-sm"
                                                    style="max-width:200px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap">
                                                    ${cat.description}
                                                </td>
                                                <td class="text-center">
                                                    <c:choose>
                                                        <c:when test="${cat.active}">
                                                            <span class="badge badge-success">
                                                                <span
                                                                    class="material-symbols-outlined text-[13px]">check_circle</span>Hoạt
                                                                động
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge badge-secondary">
                                                                <span
                                                                    class="material-symbols-outlined text-[13px]">block</span>Ẩn
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="text-center">
                                                    <div class="flex items-center justify-center gap-1.5">
                                                        <!-- Edit: load into sidebar form -->
                                                        <a href="?id=${cat.id}" class="btn btn-secondary btn-sm"
                                                            title="Sửa">
                                                            <span
                                                                class="material-symbols-outlined text-[15px]">edit</span>
                                                        </a>
                                                        <!-- Delete -->
                                                        <form
                                                            action="${pageContext.request.contextPath}/manager/categories/delete"
                                                            method="post" class="inline"
                                                            onsubmit="return confirm('Xác nhận xóa danh mục «${cat.name}»?')">
                                                            <input type="hidden" name="id" value="${cat.id}">
                                                            <button type="submit" class="btn btn-danger btn-sm"
                                                                title="Xóa">
                                                                <span
                                                                    class="material-symbols-outlined text-[15px]">delete</span>
                                                            </button>
                                                        </form>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty list}">
                                            <tr>
                                                <td colspan="6" class="text-center py-14 text-on-surface-variant">
                                                    <span class="material-symbols-outlined block mb-2 opacity-25"
                                                        style="font-size:3.5rem">label_off</span>
                                                    <p class="font-semibold mb-1">Chưa có danh mục nào</p>
                                                    <p class="text-sm opacity-60">Nhấn «Thêm danh mục» để bắt đầu</p>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <!-- Edit sidebar (1/3) — only shown when id param present -->
                    <c:if test="${category != null}">
                        <div class="lg:col-span-1">
                            <div class="pc-card sticky top-24">
                                <div class="pc-card-header"
                                    style="background: linear-gradient(135deg, #3d1f0d, #874210);">
                                    <span class="material-symbols-outlined text-white text-[18px]">edit</span>
                                    <span class="text-white font-headline font-bold">Chỉnh sửa danh mục</span>
                                </div>
                                <div class="p-5">
                                    <form action="${pageContext.request.contextPath}/manager/categories/edit"
                                        method="post" enctype="multipart/form-data">
                                        <input type="hidden" name="id" value="${category.id}">

                                        <div class="mb-4">
                                            <label class="form-label"><span class="text-error">*</span> Tên danh
                                                mục</label>
                                            <input type="text" class="form-control" name="name" value="${category.name}"
                                                placeholder="Nhập tên" required>
                                        </div>
                                        <div class="mb-4">
                                            <label class="form-label">Mô tả</label>
                                            <textarea class="form-control" name="description" rows="3"
                                                placeholder="Mô tả về danh mục...">${category.description}</textarea>
                                        </div>
                                        <div class="mb-4">
                                            <label class="form-label">Hình ảnh mới</label>
                                            <input type="file" class="form-control text-sm" name="image"
                                                accept="image/*">
                                            <p class="text-xs text-on-surface-variant mt-1">JPG, PNG, GIF — tối đa 5MB
                                            </p>
                                            <c:if test="${not empty category.image}">
                                                <img src="${pageContext.request.contextPath}/uploads/${category.image}"
                                                    class="mt-2 w-16 h-16 rounded-xl object-cover" alt="">
                                            </c:if>
                                        </div>
                                        <div class="flex gap-3 mt-5">
                                            <button type="submit" class="btn btn-primary flex-1 py-2.5">
                                                <span class="material-symbols-outlined text-[17px]">save</span> Lưu
                                            </button>
                                            <a href="${pageContext.request.contextPath}/manager/categories"
                                                class="btn btn-outline py-2.5 px-4">
                                                <span class="material-symbols-outlined text-[17px]">close</span>
                                            </a>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </div>

                <!-- ===== Add Category Modal ===== -->
                <div id="addModal" class="hidden fixed inset-0 z-50 flex items-center justify-center p-4"
                    style="background:rgba(0,0,0,0.4)" onclick="if(event.target===this)this.classList.add('hidden')">
                    <div class="pc-card w-full max-w-md animate-none">
                        <!-- Modal header -->
                        <div class="flex items-center justify-between px-6 py-4 rounded-t-[1.25rem]"
                            style="background: linear-gradient(135deg, #3d1f0d, #874210);">
                            <div class="flex items-center gap-2">
                                <span class="material-symbols-outlined text-white text-[18px]">add_circle</span>
                                <span class="font-headline font-bold text-white">Thêm danh mục mới</span>
                            </div>
                            <button onclick="document.getElementById('addModal').classList.add('hidden')"
                                class="text-white/70 hover:text-white transition-colors">
                                <span class="material-symbols-outlined">close</span>
                            </button>
                        </div>

                        <!-- Modal body -->
                        <div class="p-6">
                            <form action="${pageContext.request.contextPath}/manager/categories/add" method="post"
                                enctype="multipart/form-data">

                                <div class="mb-4">
                                    <label class="form-label"><span class="text-error">*</span> Tên danh mục</label>
                                    <div class="relative">
                                        <span
                                            class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-outline text-[18px]">label</span>
                                        <input type="text" class="form-control pl-10" name="name"
                                            placeholder="Nhập tên danh mục" required>
                                    </div>
                                </div>

                                <div class="mb-4">
                                    <label class="form-label">Mô tả</label>
                                    <textarea class="form-control" name="description" rows="3"
                                        placeholder="Mô tả về danh mục..."></textarea>
                                </div>

                                <div class="mb-5">
                                    <label class="form-label">Hình ảnh</label>
                                    <!-- Custom file input -->
                                    <label
                                        class="flex flex-col items-center gap-2 p-4 rounded-xl border-2 border-dashed border-outline-variant hover:border-primary hover:bg-primary-fixed/30 cursor-pointer transition-all">
                                        <span class="material-symbols-outlined text-outline text-3xl">image</span>
                                        <span class="text-sm text-on-surface-variant">Nhấn để chọn ảnh</span>
                                        <span class="text-xs text-on-surface-variant opacity-60">JPG, PNG, GIF — tối đa
                                            5MB</span>
                                        <input type="file" name="image" accept="image/*" class="hidden"
                                            onchange="document.getElementById('fileName').textContent = this.files[0]?.name || ''">
                                    </label>
                                    <p id="fileName" class="text-xs text-primary mt-1 font-medium"></p>
                                </div>

                                <div class="flex gap-3">
                                    <button type="submit" class="btn btn-primary flex-1 py-3">
                                        <span class="material-symbols-outlined text-[18px]">add</span> Thêm mới
                                    </button>
                                    <button type="button"
                                        onclick="document.getElementById('addModal').classList.add('hidden')"
                                        class="btn btn-outline flex-1 py-3">Hủy</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <%@ include file="/views/layout/footer.jsp" %>