<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="/views/layout/header.jsp" %>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
        <div class="container">
            <div class="row">
                <div class="col-12">
                    <div class="card bg-dark text-white mb-4">
                        <img src="${pageContext.request.contextPath}/uploads/banner-coffee.png" class="card-img"
                            alt="PolyCoffee Banner" style="height: 400px; object-fit: cover;">
                    </div>
                </div>
            </div>

            <div class="row mt-4">
                <div class="col-md-4 mb-4">
                    <div class="card h-100 text-center">
                        <div class="card-body">
                            <i class="bi bi-cup-straw" style="font-size: 48px;"></i>
                            <h5 class="card-title mt-3">Thức uống đa dạng</h5>
                            <p class="card-text">Hơn 50 loại thức uống khác nhau từ cà phê, trà, sinh tố đến nước ép
                                trái
                                cây tươi ngon.</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 mb-4">
                    <div class="card h-100 text-center">
                        <div class="card-body">
                            <i class="bi bi-star-fill" style="font-size: 48px; color: gold;"></i>
                            <h5 class="card-title mt-3">Chất lượng hàng đầu</h5>
                            <p class="card-text">Nguyên liệu được chọn lọc kỹ càng, đảm bảo vệ sinh an toàn thực phẩm và
                                hương vị thơm ngon.</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 mb-4">
                    <div class="card h-100 text-center">
                        <div class="card-body">
                            <i class="bi bi-wifi" style="font-size: 48px;"></i>
                            <h5 class="card-title mt-3">Không gian thoải mái</h5>
                            <p class="card-text">Không gian rộng rãi, thoáng mát, wifi miễn phí, phù hợp cho học tập và
                                làm
                                việc.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <%@ include file="/views/layout/footer.jsp" %>