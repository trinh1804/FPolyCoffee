        </div><%-- /page wrapper inner --%>
    </div><%-- /padding-top wrapper --%>

    <%-- ══════════ FOOTER ══════════ --%>
    <footer style="background: linear-gradient(160deg, #1C0F06 0%, #2C1A0E 60%, #3A1F08 100%);
                   border-top: 1px solid rgba(197,149,106,0.2);">
        <div class="max-w-screen-xl mx-auto px-6 pt-12 pb-8">

            <%-- Top row --%>
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-8 mb-10">

                <%-- Brand --%>
                <div class="lg:col-span-1">
                    <div class="flex items-center gap-2.5 mb-4">
                        <div style="width:36px;height:36px;border-radius:10px;
                                    background:linear-gradient(135deg,#C6956A,#8B4513);
                                    display:flex;align-items:center;justify-content:center">
                            <span class="material-symbols-outlined text-white text-[18px]"
                                  style="font-variation-settings:'FILL' 1">local_cafe</span>
                        </div>
                        <span style="font-family:'Playfair Display',serif;font-weight:700;
                                     font-size:1.25rem;color:#F5E6D3">
                            FPoly<span style="color:#D4A017">Coffee</span>
                        </span>
                    </div>
                    <p style="color:rgba(245,230,211,0.65);font-size:0.875rem;line-height:1.7">
                        Hệ thống quản lý quán cà phê thông minh — từ thực đơn đến thanh toán và
                        tích điểm khách hàng trung thành.
                    </p>
                    <%-- Social icons --%>
                    <div class="flex gap-2 mt-5">
                        <a href="#" class="footer-icon-btn"
                           style="width:34px;height:34px;border-radius:8px;
                                  background:rgba(255,255,255,0.08);border:1px solid rgba(197,149,106,0.25);
                                  display:flex;align-items:center;justify-content:center;
                                  color:rgba(245,230,211,0.7);transition:all .2s;text-decoration:none"
                           onmouseover="this.style.background='rgba(212,160,23,0.2)';this.style.color='#D4A017'"
                           onmouseout="this.style.background='rgba(255,255,255,0.08)';this.style.color='rgba(245,230,211,0.7)'">
                            <span class="material-symbols-outlined text-[16px]">language</span>
                        </a>
                        <a href="#" class="footer-icon-btn"
                           style="width:34px;height:34px;border-radius:8px;
                                  background:rgba(255,255,255,0.08);border:1px solid rgba(197,149,106,0.25);
                                  display:flex;align-items:center;justify-content:center;
                                  color:rgba(245,230,211,0.7);transition:all .2s;text-decoration:none"
                           onmouseover="this.style.background='rgba(212,160,23,0.2)';this.style.color='#D4A017'"
                           onmouseout="this.style.background='rgba(255,255,255,0.08)';this.style.color='rgba(245,230,211,0.7)'">
                            <span class="material-symbols-outlined text-[16px]">mail</span>
                        </a>
                        <a href="#" class="footer-icon-btn"
                           style="width:34px;height:34px;border-radius:8px;
                                  background:rgba(255,255,255,0.08);border:1px solid rgba(197,149,106,0.25);
                                  display:flex;align-items:center;justify-content:center;
                                  color:rgba(245,230,211,0.7);transition:all .2s;text-decoration:none"
                           onmouseover="this.style.background='rgba(212,160,23,0.2)';this.style.color='#D4A017'"
                           onmouseout="this.style.background='rgba(255,255,255,0.08)';this.style.color='rgba(245,230,211,0.7)'">
                            <span class="material-symbols-outlined text-[16px]">call</span>
                        </a>
                    </div>
                </div>

                <%-- Quick links --%>
                <div>
                    <p style="font-weight:700;font-size:0.8rem;text-transform:uppercase;
                               letter-spacing:0.1em;color:#C6956A;margin-bottom:1rem">
                        Điều hướng
                    </p>
                    <ul style="list-style:none;padding:0;margin:0;display:flex;flex-direction:column;gap:0.6rem">
                        <li><a href="${pageContext.request.contextPath}/trang-chu" class="footer-link"
                               style="color:rgba(245,230,211,0.70);font-size:0.875rem;text-decoration:none;
                                      transition:color .15s;display:flex;align-items:center;gap:0.5rem"
                               onmouseover="this.style.color='#F5E6D3'"
                               onmouseout="this.style.color='rgba(245,230,211,0.70)'">
                               <span class="material-symbols-outlined text-[14px]" style="color:#8B4513">arrow_forward_ios</span>
                               Trang chủ & Thực đơn
                        </a></li>
                        <li><a href="${pageContext.request.contextPath}/employee/bills" class="footer-link"
                               style="color:rgba(245,230,211,0.70);font-size:0.875rem;text-decoration:none;
                                      transition:color .15s;display:flex;align-items:center;gap:0.5rem"
                               onmouseover="this.style.color='#F5E6D3'"
                               onmouseout="this.style.color='rgba(245,230,211,0.70)'">
                               <span class="material-symbols-outlined text-[14px]" style="color:#8B4513">arrow_forward_ios</span>
                               Phiếu bán hàng
                        </a></li>
                        <li><a href="${pageContext.request.contextPath}/manager/report" class="footer-link"
                               style="color:rgba(245,230,211,0.70);font-size:0.875rem;text-decoration:none;
                                      transition:color .15s;display:flex;align-items:center;gap:0.5rem"
                               onmouseover="this.style.color='#F5E6D3'"
                               onmouseout="this.style.color='rgba(245,230,211,0.70)'">
                               <span class="material-symbols-outlined text-[14px]" style="color:#8B4513">arrow_forward_ios</span>
                               Báo cáo & Thống kê
                        </a></li>
                    </ul>
                </div>

                <%-- Contact --%>
                <div>
                    <p style="font-weight:700;font-size:0.8rem;text-transform:uppercase;
                               letter-spacing:0.1em;color:#C6956A;margin-bottom:1rem">Liên hệ</p>
                    <ul style="list-style:none;padding:0;margin:0;display:flex;flex-direction:column;gap:0.75rem">
                        <li style="display:flex;align-items:flex-start;gap:0.625rem">
                            <span class="material-symbols-outlined text-[16px]" style="color:#C6956A;margin-top:1px">location_on</span>
                            <span style="color:rgba(245,230,211,0.70);font-size:0.875rem;line-height:1.5">
                                123 Đường Nguyễn Văn A,<br>Quận 1, TP.HCM
                            </span>
                        </li>
                        <li style="display:flex;align-items:center;gap:0.625rem">
                            <span class="material-symbols-outlined text-[16px]" style="color:#C6956A">call</span>
                            <span style="color:rgba(245,230,211,0.70);font-size:0.875rem">(028) 1234 5678</span>
                        </li>
                        <li style="display:flex;align-items:center;gap:0.625rem">
                            <span class="material-symbols-outlined text-[16px]" style="color:#C6956A">mail</span>
                            <span style="color:rgba(245,230,211,0.70);font-size:0.875rem">info@fpolycoffee.com</span>
                        </li>
                    </ul>
                </div>

                <%-- Hours --%>
                <div>
                    <p style="font-weight:700;font-size:0.8rem;text-transform:uppercase;
                               letter-spacing:0.1em;color:#C6956A;margin-bottom:1rem">Giờ mở cửa</p>
                    <ul style="list-style:none;padding:0;margin:0;display:flex;flex-direction:column;gap:0.625rem">
                        <li style="display:flex;justify-content:space-between;gap:1rem">
                            <span style="color:rgba(245,230,211,0.65);font-size:0.875rem">Thứ 2 – Thứ 6</span>
                            <span style="color:#F5E6D3;font-size:0.875rem;font-weight:600">7:00 – 22:00</span>
                        </li>
                        <li style="display:flex;justify-content:space-between;gap:1rem">
                            <span style="color:rgba(245,230,211,0.65);font-size:0.875rem">Thứ 7</span>
                            <span style="color:#F5E6D3;font-size:0.875rem;font-weight:600">8:00 – 23:00</span>
                        </li>
                        <li style="display:flex;justify-content:space-between;gap:1rem">
                            <span style="color:rgba(245,230,211,0.65);font-size:0.875rem">Chủ nhật</span>
                            <span style="color:#F5E6D3;font-size:0.875rem;font-weight:600">8:00 – 23:00</span>
                        </li>
                        <li style="margin-top:0.5rem;padding:0.625rem 0.875rem;border-radius:0.75rem;
                                   background:rgba(212,160,23,0.12);border:1px solid rgba(212,160,23,0.25);
                                   display:flex;align-items:center;gap:0.5rem">
                            <span class="material-symbols-outlined text-[15px]" style="color:#D4A017">circle</span>
                            <span style="color:#D4A017;font-size:0.8rem;font-weight:600">Đang mở cửa</span>
                        </li>
                    </ul>
                </div>
            </div>

            <%-- Divider --%>
            <div style="height:1px;background:linear-gradient(90deg,transparent,rgba(197,149,106,0.35),transparent);
                        margin-bottom:1.5rem"></div>

            <%-- Bottom row --%>
            <div style="display:flex;flex-wrap:wrap;align-items:center;
                        justify-content:space-between;gap:0.75rem">
                <p style="color:rgba(245,230,211,0.5);font-size:0.8rem;margin:0">
                    © 2026 <strong style="color:rgba(245,230,211,0.75)">FPolyCoffee</strong>.
                    Tất cả các quyền được bảo lưu.
                </p>
                <div style="display:flex;align-items:center;gap:0.5rem">
                    <span style="display:inline-block;width:6px;height:6px;border-radius:50%;
                                 background:#D4A017;animation:pulse 2s infinite"></span>
                    <span style="color:rgba(245,230,211,0.5);font-size:0.8rem">
                        Xây dựng với ❤️ bởi nhóm FPoly
                    </span>
                </div>
            </div>
        </div>
    </footer>

    <style>
        @keyframes pulse {
            0%, 100% { opacity: 1; } 50% { opacity: 0.3; }
        }
    </style>
</body>
</html>
