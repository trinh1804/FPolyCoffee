<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ include file="/views/layout/header.jsp" %>

                <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>

                <h1 class="section-title">
                    <span class="material-symbols-outlined text-primary">bar_chart</span>
                    Thống kê & Báo cáo
                </h1>

                <!-- Date filter -->
                <div class="pc-card mb-6">
                    <div class="pc-card-header">
                        <span class="material-symbols-outlined text-primary text-[18px]">filter_list</span>
                        Chọn khoảng thời gian
                    </div>
                    <div class="p-5">
                        <form action="${pageContext.request.contextPath}/manager/report" method="get">
                            <div class="grid grid-cols-1 md:grid-cols-3 gap-4 items-end">
                                <div>
                                    <label class="form-label">Từ ngày</label>
                                    <input type="date" class="form-control" name="fromDate" value="${fromDate}">
                                </div>
                                <div>
                                    <label class="form-label">Đến ngày</label>
                                    <input type="date" class="form-control" name="toDate" value="${toDate}">
                                </div>
                                <div>
                                    <button type="submit" class="btn btn-primary w-full py-3">
                                        <span class="material-symbols-outlined text-[18px]">search</span> Thống kê
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Stats cards -->
                <div class="grid grid-cols-2 md:grid-cols-4 gap-5 mb-6">
                    <div class="pc-card p-5 flex items-center gap-4">
                        <div class="w-12 h-12 rounded-xl bg-primary-fixed flex items-center justify-center shrink-0">
                            <span class="material-symbols-outlined text-primary text-2xl">coffee</span>
                        </div>
                        <div>
                            <div class="font-headline font-black text-2xl text-primary">${totalDrinks}</div>
                            <div class="text-xs text-on-surface-variant">Đồ uống</div>
                        </div>
                    </div>
                    <div class="pc-card p-5 flex items-center gap-4">
                        <div class="w-12 h-12 rounded-xl bg-primary-fixed flex items-center justify-center shrink-0">
                            <span class="material-symbols-outlined text-primary text-2xl">group</span>
                        </div>
                        <div>
                            <div class="font-headline font-black text-2xl text-primary">${totalStaff}</div>
                            <div class="text-xs text-on-surface-variant">Nhân viên</div>
                        </div>
                    </div>
                    <div class="pc-card p-5 flex items-center gap-4">
                        <div class="w-12 h-12 rounded-xl bg-primary-fixed flex items-center justify-center shrink-0">
                            <span class="material-symbols-outlined text-primary text-2xl">receipt_long</span>
                        </div>
                        <div>
                            <div class="font-headline font-black text-2xl text-primary">${todayBills}</div>
                            <div class="text-xs text-on-surface-variant">Đơn hôm nay</div>
                        </div>
                    </div>
                    <div class="pc-card p-5 flex items-center gap-4">
                        <div class="w-12 h-12 rounded-xl bg-primary-fixed flex items-center justify-center shrink-0">
                            <span class="material-symbols-outlined text-primary text-2xl">payments</span>
                        </div>
                        <div>
                            <div class="font-headline font-black text-lg text-primary">
                                <fmt:formatNumber value="${todayRevenue}" pattern="#,##0" />đ
                            </div>
                            <div class="text-xs text-on-surface-variant">Doanh thu hôm nay</div>
                        </div>
                    </div>
                </div>

                <!-- Charts row -->
                <div class="grid grid-cols-1 md:grid-cols-7 gap-6 mb-6">
                    <!-- Revenue chart -->
                    <div class="md:col-span-4 pc-card">
                        <div class="pc-card-header">
                            <span class="material-symbols-outlined text-primary text-[18px]">bar_chart</span>
                            Doanh thu theo ngày
                        </div>
                        <div class="p-5">
                            <canvas id="revenueChart" style="max-height:300px"></canvas>
                            <div class="grid grid-cols-2 gap-4 mt-5">
                                <div class="p-4 rounded-xl bg-primary-fixed text-center">
                                    <p class="text-xs text-on-surface-variant mb-1">Tổng doanh thu</p>
                                    <p class="font-headline font-bold text-lg text-primary">
                                        <fmt:formatNumber value="${totalRevenue}" pattern="#,##0" /> ₫
                                    </p>
                                </div>
                                <div class="p-4 rounded-xl bg-primary-fixed text-center">
                                    <p class="text-xs text-on-surface-variant mb-1">Tổng số đơn</p>
                                    <p class="font-headline font-bold text-lg text-primary">${totalBills} đơn</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Top 5 drinks -->
                    <div class="md:col-span-3 pc-card">
                        <div class="pc-card-header" style="background: linear-gradient(135deg, #874210, #c47c3e);">
                            <span class="material-symbols-outlined text-white text-[18px]">emoji_events</span>
                            <span class="text-white">Top 5 bán chạy nhất</span>
                        </div>
                        <div class="overflow-x-auto">
                            <table class="data-table w-full">
                                <thead>
                                    <tr>
                                        <th class="text-center w-10">#</th>
                                        <th>Tên</th>
                                        <th class="text-center">SL</th>
                                        <th class="text-right">Doanh thu</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${top5Drinks}" var="drink" varStatus="loop">
                                        <tr>
                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${loop.index == 0}"><span class="text-lg">🥇</span>
                                                    </c:when>
                                                    <c:when test="${loop.index == 1}"><span class="text-lg">🥈</span>
                                                    </c:when>
                                                    <c:when test="${loop.index == 2}"><span class="text-lg">🥉</span>
                                                    </c:when>
                                                    <c:otherwise><span
                                                            class="badge badge-secondary">${loop.index+1}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="font-semibold text-sm">${drink.drinkName}</td>
                                            <td class="text-center"><span
                                                    class="badge badge-info">${drink.totalQuantitySold}</span></td>
                                            <td class="text-right font-semibold text-primary text-sm">
                                                <fmt:formatNumber value="${drink.totalRevenue}" pattern="#,##0" /> ₫
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty top5Drinks}">
                                        <tr>
                                            <td colspan="4" class="text-center py-8 text-on-surface-variant">
                                                <span
                                                    class="material-symbols-outlined text-3xl block mb-1 opacity-30">inbox</span>
                                                Chưa có dữ liệu
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Orders chart -->
                <div class="pc-card">
                    <div class="pc-card-header">
                        <span class="material-symbols-outlined text-primary text-[18px]">show_chart</span>
                        Số lượng đơn hàng theo ngày
                    </div>
                    <div class="p-5">
                        <canvas id="billsChart" style="max-height:280px"></canvas>
                    </div>
                </div>

                <script>
                    const labels = [<c:forEach items="${labels}" var="label" varStatus="loop">"${label}"${!loop.last ? ',' : ''}</c:forEach>];
                    const revenues = [<c:forEach items="${revenues}" var="rev" varStatus="loop">${rev}${!loop.last ? ',' : ''}</c:forEach>];
                    const bills = [<c:forEach items="${bills}" var="bill" varStatus="loop">${bill}${!loop.last ? ',' : ''}</c:forEach>];

                    Chart.defaults.font.family = "'Inter', sans-serif";

                    new Chart(document.getElementById('revenueChart'), {
                        type: 'bar',
                        data: {
                            labels,
                            datasets: [{
                                label: 'Doanh thu (₫)',
                                data: revenues,
                                backgroundColor: 'rgba(104,45,0,0.75)',
                                borderColor: '#682d00',
                                borderWidth: 0,
                                borderRadius: 8,
                                borderSkipped: false,
                            }]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: true,
                            plugins: { legend: { display: false } },
                            scales: {
                                y: {
                                    beginAtZero: true,
                                    grid: { color: '#f1f4f9' },
                                    ticks: { callback: v => v.toLocaleString('vi-VN') + ' ₫', font: { size: 11 } }
                                },
                                x: { grid: { display: false } }
                            }
                        }
                    });

                    new Chart(document.getElementById('billsChart'), {
                        type: 'line',
                        data: {
                            labels,
                            datasets: [{
                                label: 'Số đơn',
                                data: bills,
                                backgroundColor: 'rgba(104,45,0,0.08)',
                                borderColor: '#682d00',
                                borderWidth: 2,
                                fill: true,
                                tension: 0.4,
                                pointBackgroundColor: '#ffb68c',
                                pointBorderColor: '#682d00',
                                pointRadius: 5,
                                pointHoverRadius: 7
                            }]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: true,
                            plugins: { legend: { display: false } },
                            scales: {
                                y: {
                                    beginAtZero: true,
                                    grid: { color: '#f1f4f9' },
                                    ticks: { stepSize: 1, callback: v => v + ' đơn', font: { size: 11 } }
                                },
                                x: { grid: { display: false } }
                            }
                        }
                    });
                </script>

                <%@ include file="/views/layout/footer.jsp" %>