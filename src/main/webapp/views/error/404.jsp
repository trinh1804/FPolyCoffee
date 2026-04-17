<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="/views/layout/header.jsp" %>

        <div class="flex flex-col items-center justify-center py-20 text-center">
            <div class="w-24 h-24 rounded-3xl bg-primary-fixed flex items-center justify-center mb-6">
                <span class="material-symbols-outlined text-primary" style="font-size: 3rem">search_off</span>
            </div>
            <h1 class="font-headline font-black text-8xl text-primary opacity-20 mb-2">404</h1>
            <h2 class="font-headline font-bold text-2xl text-primary mb-3">Không tìm thấy trang</h2>
            <p class="text-on-surface-variant max-w-sm mb-8">Trang bạn đang tìm kiếm không tồn tại hoặc đã được di
                chuyển đến địa chỉ khác.</p>
            <a href="${pageContext.request.contextPath}/trang-chu" class="btn btn-primary px-8 py-3 text-base">
                <span class="material-symbols-outlined text-[20px]">home</span>
                Về trang chủ
            </a>
        </div>

        <%@ include file="/views/layout/footer.jsp" %>