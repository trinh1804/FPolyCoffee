<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="/views/layout/header.jsp" %>

        <!-- Banner -->
        <div class="rounded-3 overflow-hidden mb-5 position-relative" style="height:400px; background-color:#3d1f0d;">
            <img src="${pageContext.request.contextPath}/uploads/banner-coffee.png"
                class="w-100 h-100 object-fit-cover opacity-50 position-absolute top-0 start-0"
                alt="FPolyCoffee Banner">
            <div class="position-absolute top-50 start-50 translate-middle text-center text-white px-3">
                <div class="display-3 mb-2"><i class="bi bi-cup-hot-fill me-2"></i></div>
                <h1 class="fw-bold display-5">FPolyCoffee</h1>
                <p class="lead mb-0 opacity-75">Thức uống chất lượng · Phục vụ tận tâm</p>
            </div>
        </div>

        <!-- Tính năng nổi bật -->
        <div class="text-center mb-4">
            <span class="badge rounded-pill px-3 py-2 mb-2" style="background-color:#c47c3e">Tại sao chọn chúng
                tôi</span>
            <h2 class="fw-bold" style="color:#3d1f0d">Trải nghiệm khác biệt</h2>
        </div>

        <div class="row g-4 mb-4">
            <div class="col-md-4">
                <div class="card h-100 border-0 shadow-sm text-center p-2">
                    <div class="card-body">
                        <div class="rounded-circle d-inline-flex align-items-center justify-content-center mb-3"
                            style="width:72px;height:72px;background-color:#f0e4d0;">
                            <i class="bi bi-cup-straw fs-2" style="color:#c47c3e"></i>
                        </div>
                        <h5 class="fw-bold" style="color:#3d1f0d">Thức uống đa dạng</h5>
                        <p class="text-muted small">Hơn 50 loại thức uống từ cà phê, trà, sinh tố đến nước ép trái cây
                            tươi ngon.</p>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card h-100 border-0 shadow-sm text-center p-2">
                    <div class="card-body">
                        <div class="rounded-circle d-inline-flex align-items-center justify-content-center mb-3"
                            style="width:72px;height:72px;background-color:#f0e4d0;">
                            <i class="bi bi-star-fill fs-2" style="color:#f0c070"></i>
                        </div>
                        <h5 class="fw-bold" style="color:#3d1f0d">Chất lượng hàng đầu</h5>
                        <p class="text-muted small">Nguyên liệu được chọn lọc kỹ càng, đảm bảo vệ sinh an toàn thực phẩm
                            và hương vị thơm ngon.</p>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card h-100 border-0 shadow-sm text-center p-2">
                    <div class="card-body">
                        <div class="rounded-circle d-inline-flex align-items-center justify-content-center mb-3"
                            style="width:72px;height:72px;background-color:#f0e4d0;">
                            <i class="bi bi-wifi fs-2" style="color:#c47c3e"></i>
                        </div>
                        <h5 class="fw-bold" style="color:#3d1f0d">Không gian thoải mái</h5>
                        <p class="text-muted small">Không gian rộng rãi, thoáng mát, wifi miễn phí, phù hợp cho học tập
                            và làm việc.</p>
                    </div>
                </div>
            </div>
        </div>

        <%@ include file="/views/layout/footer.jsp" %>