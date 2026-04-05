<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ include file="/views/layout/header.jsp" %>

                <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>

                <h4 class="fw-bold mb-4" style="color:#3d1f0d">
                    <i class="bi bi-graph-up me-2"></i>Thống kê & Báo cáo
                </h4>

                <!-- Bộ lọc thời gian -->
                <div class="card shadow-sm border-0 rounded-3 mb-4">
                    <div class="card-header card-header-mid py-3 border-0">
                        <i class="bi bi-funnel me-1"></i> Chọn khoảng thời gian
                    </div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/manager/report" method="get"
                            class="row g-3 align-items-end">
                            <div class="col-md-4">
                                <label class="form-label fw-semibold">Từ ngày</label>
                                <input type="date" class="form-control" name="fromDate" value="${fromDate}">
                            </div>
                            <div class="col-md-4">
                                <label class="form-label fw-semibold">Đến ngày</label>
                                <input type="date" class="form-control" name="toDate" value="${toDate}">
                            </div>
                            <div class="col-md-4">
                                <button type="submit" class="btn btn-coffee w-100">
                                    <i class="bi bi-search me-1"></i> Thống kê
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Thống kê tổng quan (4 cards) -->
                <div class="row g-4 mb-4">
                    <div class="col-md-3">
                        <div class="card border-0 shadow-sm text-center">
                            <div class="card-body">
                                <i class="bi bi-cup-straw fs-1" style="color:#c47c3e"></i>
                                <h5 class="mt-2 mb-0 fw-bold">${totalDrinks}</h5>
                                <p class="text-muted small mb-0">Đồ uống</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card border-0 shadow-sm text-center">
                            <div class="card-body">
                                <i class="bi bi-people fs-1" style="color:#c47c3e"></i>
                                <h5 class="mt-2 mb-0 fw-bold">${totalStaff}</h5>
                                <p class="text-muted small mb-0">Nhân viên</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card border-0 shadow-sm text-center">
                            <div class="card-body">
                                <i class="bi bi-receipt fs-1" style="color:#c47c3e"></i>
                                <h5 class="mt-2 mb-0 fw-bold">${todayBills}</h5>
                                <p class="text-muted small mb-0">Đơn hôm nay</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card border-0 shadow-sm text-center">
                            <div class="card-body">
                                <i class="bi bi-currency-dollar fs-1" style="color:#c47c3e"></i>
                                <h5 class="mt-2 mb-0 fw-bold">
                                    <fmt:formatNumber value="${todayRevenue}" pattern="#,##0" />đ
                                </h5>
                                <p class="text-muted small mb-0">Doanh thu hôm nay</p>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row g-4">
                    <!-- Biểu đồ doanh thu -->
                    <div class="col-md-7">
                        <div class="card shadow-sm border-0 rounded-3 h-100">
                            <div class="card-header card-header-coffee py-3 border-0">
                                <i class="bi bi-bar-chart-steps me-1"></i> Doanh thu theo ngày
                            </div>
                            <div class="card-body">
                                <canvas id="revenueChart" style="width:100%; max-height:350px"></canvas>

                                <div class="row mt-4 pt-2 text-center">
                                    <div class="col-6">
                                        <div class="p-3 rounded" style="background-color:#f0e4d0">
                                            <p class="text-muted mb-1">Tổng doanh thu</p>
                                            <h4 class="fw-bold" style="color:#c47c3e">
                                                <fmt:formatNumber value="${totalRevenue}" pattern="#,##0" /> ₫
                                            </h4>
                                        </div>
                                    </div>
                                    <div class="col-6">
                                        <div class="p-3 rounded" style="background-color:#f0e4d0">
                                            <p class="text-muted mb-1">Tổng số đơn</p>
                                            <h4 class="fw-bold" style="color:#c47c3e">
                                                ${totalBills} đơn
                                            </h4>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Top 5 đồ uống bán chạy -->
                    <div class="col-md-5">
                        <div class="card shadow-sm border-0 rounded-3 h-100">
                            <div class="card-header card-header-gold py-3 border-0">
                                <i class="bi bi-trophy me-1"></i> Top 5 thức uống bán chạy
                            </div>
                            <div class="card-body p-0">
                                <div class="table-responsive">
                                    <table class="table table-hover align-middle mb-0">
                                        <thead class="table-light">
                                            <tr>
                                                <th>#</th>
                                                <th>Tên đồ uống</th>
                                                <th class="text-center">SL bán</th>
                                                <th class="text-end">Doanh thu</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${top5Drinks}" var="drink" varStatus="loop">
                                                <tr>
                                                    <td class="text-center">
                                                        <c:choose>
                                                            <c:when test="${loop.index == 0}">
                                                                <span
                                                                    class="badge bg-warning rounded-circle p-2">🥇</span>
                                                            </c:when>
                                                            <c:when test="${loop.index == 1}">
                                                                <span
                                                                    class="badge bg-secondary rounded-circle p-2">🥈</span>
                                                            </c:when>
                                                            <c:when test="${loop.index == 2}">
                                                                <span
                                                                    class="badge bg-danger rounded-circle p-2">🥉</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span
                                                                    class="badge bg-light text-dark rounded-circle p-2">${loop.index+1}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="fw-semibold">${drink.drinkName}</td>
                                                    <td class="text-center">
                                                        <span class="badge bg-info">${drink.totalQuantitySold}</span>
                                                    </td>
                                                    <td class="text-end fw-semibold" style="color:#c47c3e">
                                                        <fmt:formatNumber value="${drink.totalRevenue}"
                                                            pattern="#,##0" /> ₫
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            <c:if test="${empty top5Drinks}">
                                                <tr>
                                                    <td colspan="4" class="text-center text-muted py-4">
                                                        <i class="bi bi-inbox fs-2 d-block mb-2"></i>
                                                        Chưa có dữ liệu bán hàng
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Biểu đồ số lượng đơn hàng theo ngày -->
                <div class="row mt-4">
                    <div class="col-12">
                        <div class="card shadow-sm border-0 rounded-3">
                            <div class="card-header card-header-mid py-3 border-0">
                                <i class="bi bi-bar-chart-line me-1"></i> Số lượng đơn hàng theo ngày
                            </div>
                            <div class="card-body">
                                <canvas id="billsChart" style="width:100%; max-height:300px"></canvas>
                            </div>
                        </div>
                    </div>
                </div>

                <script>
                    const labels = [
                        <c:forEach items="${labels}" var="label" varStatus="loop">
                            "${label}"${!loop.last ? ',' : ''}
                        </c:forEach>
                    ];

                    const revenues = [
                        <c:forEach items="${revenues}" var="rev" varStatus="loop">
                            ${rev}${!loop.last ? ',' : ''}
                        </c:forEach>
                    ];

                    const bills = [
                        <c:forEach items="${bills}" var="bill" varStatus="loop">
                            ${bill}${!loop.last ? ',' : ''}
                        </c:forEach>
                    ];

                    // Biểu đồ doanh thu
                    const revenueCtx = document.getElementById('revenueChart').getContext('2d');
                    new Chart(revenueCtx, {
                        type: 'bar',
                        data: {
                            labels: labels,
                            datasets: [{
                                label: 'Doanh thu (VNĐ)',
                                data: revenues,
                                backgroundColor: 'rgba(196, 124, 62, 0.7)',
                                borderColor: '#c47c3e',
                                borderWidth: 1,
                                borderRadius: 8
                            }]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: true,
                            plugins: {
                                legend: {
                                    position: 'top',
                                },
                                tooltip: {
                                    callbacks: {
                                        label: function (context) {
                                            let value = context.raw;
                                            return 'Doanh thu: ' + value.toLocaleString('vi-VN') + ' ₫';
                                        }
                                    }
                                }
                            },
                            scales: {
                                y: {
                                    beginAtZero: true,
                                    ticks: {
                                        callback: function (value) {
                                            return value.toLocaleString('vi-VN') + ' ₫';
                                        }
                                    }
                                }
                            }
                        }
                    });

                    // Biểu đồ số lượng đơn hàng
                    const billsCtx = document.getElementById('billsChart').getContext('2d');
                    new Chart(billsCtx, {
                        type: 'line',
                        data: {
                            labels: labels,
                            datasets: [{
                                label: 'Số lượng đơn hàng',
                                data: bills,
                                backgroundColor: 'rgba(61, 31, 13, 0.1)',
                                borderColor: '#3d1f0d',
                                borderWidth: 2,
                                fill: true,
                                tension: 0.3,
                                pointBackgroundColor: '#c47c3e',
                                pointBorderColor: '#fff',
                                pointRadius: 5,
                                pointHoverRadius: 7
                            }]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: true,
                            plugins: {
                                legend: {
                                    position: 'top',
                                },
                                tooltip: {
                                    callbacks: {
                                        label: function (context) {
                                            return 'Số đơn: ' + context.raw + ' đơn';
                                        }
                                    }
                                }
                            },
                            scales: {
                                y: {
                                    beginAtZero: true,
                                    ticks: {
                                        stepSize: 1,
                                        callback: function (value) {
                                            return value + ' đơn';
                                        }
                                    }
                                }
                            }
                        }
                    });
                </script>