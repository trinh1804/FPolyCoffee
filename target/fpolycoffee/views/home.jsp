<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="/views/layout/header.jsp" %>

        <!-- Hero Section -->
        <div class="-mx-6 -mt-8 relative overflow-hidden"
            style="background: linear-gradient(135deg, #3d1f0d 0%, #682d00 50%, #874210 100%); min-height: 480px;">
            <div class="absolute inset-0 opacity-10"
                style="background-image: radial-gradient(circle at 70% 50%, #ffb68c 0%, transparent 60%), radial-gradient(circle at 20% 80%, #ffdbc9 0%, transparent 40%);">
            </div>
            <div
                class="relative max-w-screen-xl mx-auto px-6 py-20 grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
                <div>
                    <span
                        class="inline-block py-1 px-3 bg-white/15 text-primary-fixed text-xs font-bold rounded-full mb-5 uppercase tracking-widest">Premium
                        Brewing</span>
                    <h1 class="font-headline text-5xl md:text-6xl font-black text-white mb-5 leading-tight">
                        Savour the<br>Rich Aroma &<br>Bold Flavor
                    </h1>
                    <p class="text-primary-fixed-dim text-lg mb-8 leading-relaxed max-w-md">
                        Đánh thức giác quan bằng những hạt cà phê rang xay thủ công thượng hạng, nơi mỗi tách cà phê là
                        một tác phẩm nghệ thuật.
                    </p>
                    <div class="flex flex-wrap gap-4">
                        <a href="${pageContext.request.contextPath}/dang-nhap"
                            class="btn btn-secondary text-base px-8 py-3 shadow-xl">
                            <span class="material-symbols-outlined text-[20px]">coffee</span>
                            Bắt đầu ngay
                        </a>
                    </div>
                    <!-- Stats -->
                    <div class="flex gap-8 mt-10">
                        <div>
                            <div class="font-headline font-black text-3xl text-white">50+</div>
                            <div class="text-primary-fixed-dim text-sm">Loại đồ uống</div>
                        </div>
                        <div class="border-l border-white/20 pl-8">
                            <div class="font-headline font-black text-3xl text-white">4.9★</div>
                            <div class="text-primary-fixed-dim text-sm">Đánh giá</div>
                        </div>
                        <div class="border-l border-white/20 pl-8">
                            <div class="font-headline font-black text-3xl text-white">1K+</div>
                            <div class="text-primary-fixed-dim text-sm">Khách hàng</div>
                        </div>
                    </div>
                </div>
                <!-- Image placeholder / icon decoration -->
                <div class="hidden lg:flex items-center justify-center">
                    <div class="relative">
                        <div
                            class="w-72 h-72 rounded-[2rem] bg-white/10 backdrop-blur-sm border border-white/20 flex items-center justify-center rotate-6">
                            <span class="material-symbols-outlined text-white/60"
                                style="font-size:10rem; font-variation-settings: 'FILL' 1, 'wght' 300">local_cafe</span>
                        </div>
                        <div
                            class="absolute -bottom-4 -left-8 bg-white rounded-2xl shadow-xl p-4 flex items-center gap-3">
                            <div class="w-10 h-10 bg-primary-fixed rounded-full flex items-center justify-center">
                                <span class="material-symbols-outlined text-primary text-[20px]">stars</span>
                            </div>
                            <div>
                                <div class="font-headline font-bold text-primary text-sm">Best Choice</div>
                                <div class="text-on-surface-variant text-xs">4.9/5 Rating</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Features Section -->
        <div class="mt-16">
            <div class="text-center mb-10">
                <span
                    class="inline-block py-1 px-3 bg-primary-fixed text-primary text-xs font-bold rounded-full mb-3 uppercase tracking-widest">Tại
                    sao chọn chúng tôi</span>
                <h2 class="font-headline font-extrabold text-3xl text-primary">Trải Nghiệm Đỉnh Cao</h2>
                <div class="w-16 h-1 bg-secondary rounded-full mx-auto mt-3"></div>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <!-- Card 1 -->
                <div class="pc-card p-8 group hover:-translate-y-2 transition-transform duration-300">
                    <div
                        class="w-14 h-14 rounded-2xl bg-primary-fixed flex items-center justify-center mb-6 group-hover:bg-primary group-hover:text-white transition-colors">
                        <span class="material-symbols-outlined text-primary group-hover:text-white text-2xl"
                            style="font-variation-settings: 'FILL' 0">coffee</span>
                    </div>
                    <h3 class="font-headline font-bold text-xl text-primary mb-3">Thức uống đa dạng</h3>
                    <p class="text-on-surface-variant text-sm leading-relaxed">Hơn 50 loại thức uống từ cà phê, trà,
                        sinh tố đến nước ép trái cây tươi ngon, đáp ứng mọi gu thưởng thức.</p>
                </div>
                <!-- Card 2 -->
                <div class="pc-card p-8 group hover:-translate-y-2 transition-transform duration-300">
                    <div
                        class="w-14 h-14 rounded-2xl bg-primary-fixed flex items-center justify-center mb-6 group-hover:bg-primary group-hover:text-white transition-colors">
                        <span
                            class="material-symbols-outlined text-primary group-hover:text-white text-2xl">verified</span>
                    </div>
                    <h3 class="font-headline font-bold text-xl text-primary mb-3">Chất lượng hàng đầu</h3>
                    <p class="text-on-surface-variant text-sm leading-relaxed">Tuyển chọn những hạt cà phê chất lượng
                        nhất từ các vùng cao nguyên nổi tiếng, rang xay tại chỗ mỗi ngày.</p>
                </div>
                <!-- Card 3 -->
                <div class="pc-card p-8 group hover:-translate-y-2 transition-transform duration-300">
                    <div
                        class="w-14 h-14 rounded-2xl bg-primary-fixed flex items-center justify-center mb-6 group-hover:bg-primary group-hover:text-white transition-colors">
                        <span
                            class="material-symbols-outlined text-primary group-hover:text-white text-2xl">weekend</span>
                    </div>
                    <h3 class="font-headline font-bold text-xl text-primary mb-3">Không gian thoải mái</h3>
                    <p class="text-on-surface-variant text-sm leading-relaxed">Không gian rộng rãi, thoáng mát, wifi
                        miễn phí - lý tưởng cho học tập, làm việc và gặp gỡ bạn bè.</p>
                </div>
            </div>
        </div>

        <%@ include file="/views/layout/footer.jsp" %>