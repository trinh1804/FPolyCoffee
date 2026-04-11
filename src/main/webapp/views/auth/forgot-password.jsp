<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="/views/layout/header.jsp" %>

        <div class="flex justify-center py-8">
            <div class="w-full max-w-md">
                <div class="pc-card overflow-hidden">
                    <!-- Header -->
                    <div class="px-8 pt-8 pb-5" style="background: linear-gradient(135deg, #3d1f0d, #874210);">
                        <div class="flex items-center gap-3">
                            <div class="w-10 h-10 rounded-xl bg-white/15 flex items-center justify-center">
                                <span class="material-symbols-outlined text-white text-xl">help</span>
                            </div>
                            <div>
                                <h2 class="font-headline font-bold text-xl text-white">Quên mật khẩu</h2>
                                <p class="text-primary-fixed-dim text-xs">Lấy lại quyền truy cập tài khoản</p>
                            </div>
                        </div>
                    </div>

                    <div class="p-8">
                        <c:if test="${not empty message}">
                            <div class="alert alert-success">
                                <span class="material-symbols-outlined text-[18px]">check_circle</span>
                                ${message}
                            </div>
                        </c:if>
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger">
                                <span class="material-symbols-outlined text-[18px]">error</span>
                                ${error}
                            </div>
                        </c:if>

                        <p class="text-on-surface-variant text-sm mb-6 leading-relaxed">
                            Vui lòng nhập email đã đăng ký. Hệ thống sẽ gửi mật khẩu mới đến email của bạn.
                        </p>

                        <form action="${pageContext.request.contextPath}/quen-mat-khau" method="post">
                            <div class="mb-6">
                                <label class="form-label">Email đăng ký</label>
                                <div class="relative">
                                    <span
                                        class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-outline text-[18px]">mail</span>
                                    <input type="email" class="form-control pl-10" name="email"
                                        placeholder="example@email.com" required>
                                </div>
                            </div>
                            <div class="flex flex-col gap-3">
                                <button type="submit" class="btn btn-primary w-full py-3">
                                    <span class="material-symbols-outlined text-[18px]">send</span>
                                    Gửi yêu cầu
                                </button>
                                <a href="${pageContext.request.contextPath}/dang-nhap"
                                    class="btn btn-outline w-full py-3">
                                    <span class="material-symbols-outlined text-[18px]">arrow_back</span>
                                    Quay lại đăng nhập
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <%@ include file="/views/layout/footer.jsp" %>