<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
    <%@ include file="/views/layout/header.jsp" %>

        <div class="flex flex-col items-center justify-center py-20 text-center">
            <div class="w-24 h-24 rounded-3xl bg-error-container flex items-center justify-center mb-6">
                <span class="material-symbols-outlined text-error" style="font-size: 3rem">error</span>
            </div>
            <h1 class="font-headline font-black text-8xl text-error opacity-20 mb-2">500</h1>
            <h2 class="font-headline font-bold text-2xl text-on-surface mb-3">Lỗi hệ thống</h2>
            <p class="text-on-surface-variant max-w-sm mb-8">Đã có lỗi xảy ra phía máy chủ. Chúng tôi đang khắc phục,
                vui lòng thử lại sau.</p>
            <a href="${pageContext.request.contextPath}/trang-chu" class="btn btn-primary px-8 py-3 text-base">
                <span class="material-symbols-outlined text-[20px]">home</span>
                Về trang chủ
            </a>
        </div>

        <%@ include file="/views/layout/footer.jsp" %>