<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="/views/layout/header.jsp" %>

        <div class="flex justify-center items-start py-8">
            <div class="w-full max-w-md">

                <!-- Card -->
                <div class="pc-card overflow-hidden">
                    <!-- Header -->
                    <div class="px-8 pt-10 pb-6 text-center"
                        style="background: linear-gradient(135deg, #3d1f0d, #874210);">
                        <div class="w-16 h-16 rounded-2xl bg-white/15 flex items-center justify-center mx-auto mb-4">
                            <span class="material-symbols-outlined text-white text-3xl"
                                style="font-variation-settings: 'FILL' 1">local_cafe</span>
                        </div>
                        <h2 class="font-headline font-black text-2xl text-white mb-1">Đăng nhập hệ thống</h2>
                        <p class="text-primary-fixed-dim text-sm">FPolyCoffee Management</p>
                    </div>

                    <!-- Body -->
                    <div class="p-8">
                        <c:if test="${not empty message}">
                            <div class="alert alert-danger">
                                <span class="material-symbols-outlined text-[18px]">error</span>
                                ${message}
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/dang-nhap" method="post">
                            <div class="mb-5">
                                <label class="form-label">Email</label>
                                <div class="relative">
                                    <span
                                        class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-outline text-[18px]">mail</span>
                                    <input type="email" class="form-control pl-10" name="email"
                                        placeholder="example@email.com" required>
                                </div>
                            </div>

                            <div class="mb-5">
                                <label class="form-label">Mật khẩu</label>
                                <div class="relative">
                                    <span
                                        class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-outline text-[18px]">lock</span>
                                    <input type="password" class="form-control pl-10" name="password"
                                        placeholder="Nhập mật khẩu" required>
                                </div>
                            </div>

                            <div class="flex items-center gap-2 mb-6">
                                <input type="checkbox" id="remember" class="w-4 h-4 accent-primary">
                                <label for="remember" class="text-sm text-on-surface-variant cursor-pointer">Ghi nhớ
                                    đăng nhập</label>
                            </div>

                            <button type="submit" class="btn btn-primary w-full py-3 text-base">
                                <span class="material-symbols-outlined text-[20px]">login</span>
                                Đăng nhập
                            </button>
                        </form>

                        <div class="border-t border-outline-variant mt-6 pt-6 flex flex-col items-center gap-2">
                            <a href="${pageContext.request.contextPath}/quen-mat-khau"
                                class="text-sm text-primary hover:underline flex items-center gap-1 no-underline">
                                <span class="material-symbols-outlined text-[16px]">help</span>
                                Quên mật khẩu?
                            </a>
                            <a href="${pageContext.request.contextPath}/quen-tai-khoan"
                                class="text-sm text-primary hover:underline flex items-center gap-1 no-underline">
                                <span class="material-symbols-outlined text-[16px]">person_search</span>
                                Quên tài khoản?
                            </a>
                        </div>
                    </div>
                </div>

            </div>
        </div>

        <%@ include file="/views/layout/footer.jsp" %>