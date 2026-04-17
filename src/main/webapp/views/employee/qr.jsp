<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>QR Thanh toán — ${bill.code} | FPolyCoffee</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'DM Sans', sans-serif;
            background: linear-gradient(135deg, #001D3D 0%, #003566 50%, #001D3D 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            color: #1A1A1A;
        }
        .qr-container {
            width: 100%;
            max-width: 420px;
            animation: fadeUp .4s ease-out;
        }
        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(20px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        /* Header */
        .qr-header {
            background: #003F8A;
            padding: 16px 20px;
            border-radius: 16px 16px 0 0;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .bank-logo {
            width: 44px; height: 44px;
            background: white;
            border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            flex-shrink: 0;
        }
        .bank-logo span {
            font-size: 14px; font-weight: 900;
            color: #003F8A; font-family: Arial, sans-serif;
            letter-spacing: -0.5px;
        }
        .bank-info { flex: 1; }
        .bank-name { color: white; font-weight: 700; font-size: 15px; }
        .bank-account-name { color: rgba(255,255,255,0.7); font-size: 12px; margin-top: 2px; }
        .vietqr-badge {
            background: rgba(255,255,255,0.15);
            color: white; font-size: 11px; font-weight: 700;
            padding: 4px 10px; border-radius: 20px;
            letter-spacing: 0.5px;
        }

        /* QR Body */
        .qr-body {
            background: white;
            padding: 28px 20px;
            text-align: center;
        }
        .qr-loading {
            padding: 40px 0;
        }
        .spinner {
            width: 48px; height: 48px;
            border: 4px solid #003F8A;
            border-top-color: transparent;
            border-radius: 50%;
            animation: spin .8s linear infinite;
            margin: 0 auto 12px;
        }
        @keyframes spin { to { transform: rotate(360deg); } }
        .qr-loading span { font-size: 14px; color: #666; }
        #qrImg {
            display: none;
            width: 280px; height: 280px;
            object-fit: contain;
            margin: 0 auto;
            border-radius: 12px;
        }
        #qrError {
            display: none;
            padding: 24px 0;
        }
        #qrError p { font-size: 13px; color: #999; margin-top: 8px; }
        #qrError a { color: #003F8A; text-decoration: underline; }
        .qr-timer {
            display: none;
            margin-top: 10px;
            font-size: 13px; color: #888;
        }
        .qr-timer strong { color: #C62828; font-weight: 700; font-size: 14px; }

        /* Info rows */
        .qr-info {
            background: #F0F6FF;
            padding: 14px 20px;
            font-size: 13px;
        }
        .info-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 6px 0;
        }
        .info-row + .info-row { border-top: 1px solid #D6E4F5; }
        .info-label { color: #666; }
        .info-value { font-weight: 700; font-family: monospace; font-size: 14px; color: #1A1A1A; }
        .info-value.amount { color: #003F8A; font-size: 16px; }

        /* Footer */
        .qr-footer {
            background: #FFFBEB;
            border-top: 1px solid #FDE68A;
            padding: 14px 20px;
            border-radius: 0 0 16px 16px;
        }
        .qr-hint {
            display: flex; align-items: center; gap: 8px;
            margin-bottom: 12px;
        }
        .qr-hint-dot {
            width: 10px; height: 10px;
            border-radius: 50%; background: #F59E0B;
            flex-shrink: 0;
            animation: pulse 1.5s ease-in-out infinite;
        }
        @keyframes pulse { 0%,100%{opacity:1} 50%{opacity:.35} }
        .qr-hint span { font-size: 12px; color: #92400E; }

        .btn-copy {
            width: 100%; padding: 10px;
            border-radius: 10px;
            background: #EBF3FF; color: #1565C0;
            border: 1px solid #B3D3FF;
            font-size: 13px; font-weight: 600;
            cursor: pointer;
            display: flex; align-items: center; justify-content: center; gap: 6px;
            transition: all .15s;
            font-family: 'DM Sans', sans-serif;
            margin-bottom: 8px;
        }
        .btn-copy:hover { background: #D6E4F5; }

        .btn-back {
            width: 100%; padding: 10px;
            border-radius: 10px;
            background: transparent; color: #92400E;
            border: 1px solid #FDE68A;
            font-size: 13px; font-weight: 600;
            cursor: pointer;
            display: flex; align-items: center; justify-content: center; gap: 6px;
            transition: all .15s;
            font-family: 'DM Sans', sans-serif;
            text-decoration: none;
        }
        .btn-back:hover { background: #FEF3C7; }

        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
            vertical-align: middle; line-height: 1;
        }
    </style>
</head>
<body>

<div class="qr-container">

    <%-- Header --%>
    <div class="qr-header">
        <div class="bank-logo"><span>MB</span></div>
        <div class="bank-info">
            <div class="bank-name">MBBank · 0364298183</div>
            <div class="bank-account-name">FPOLY COFFEE</div>
        </div>
        <div class="vietqr-badge">VietQR</div>
    </div>

    <%-- QR Code --%>
    <div class="qr-body">
        <div id="qrLoading" class="qr-loading">
            <div class="spinner"></div>
            <span>Đang tạo mã QR...</span>
        </div>
        <img id="qrImg" alt="QR MBBank" onload="qrLoaded()" onerror="qrFailed()">
        <div id="qrError">
            <span class="material-symbols-outlined" style="font-size:48px;color:#ddd">qr_code_scanner</span>
            <p>Không tải được QR — <a id="qrFallbackLink" href="#" target="_blank">Mở trên VietQR</a></p>
        </div>
        <div id="qrTimer" class="qr-timer">
            QR hết hạn sau <strong id="qrCountdown">10:00</strong>
        </div>
    </div>

    <%-- Transfer info --%>
    <div class="qr-info">
        <div class="info-row">
            <span class="info-label">Số tài khoản</span>
            <span class="info-value">0364298183</span>
        </div>
        <div class="info-row">
            <span class="info-label">Số tiền</span>
            <span class="info-value amount">
                <fmt:formatNumber value="${bill.totalPrice}" pattern="#,##0" /> &#8363;
            </span>
        </div>
        <div class="info-row">
            <span class="info-label">Nội dung CK</span>
            <span class="info-value" style="color:#2C1A0E">${bill.code}</span>
        </div>
    </div>

    <%-- Footer --%>
    <div class="qr-footer">
        <div class="qr-hint">
            <div class="qr-hint-dot"></div>
            <span>Sau khi khách quét QR, quay lại trang phiếu và nhấn "Hoàn thành thanh toán"</span>
        </div>
        <button type="button" id="copyBtn" onclick="copyInfo()" class="btn-copy">
            <span class="material-symbols-outlined" style="font-size:16px">content_copy</span>
            Sao chép thông tin chuyển khoản
        </button>
        <a href="${pageContext.request.contextPath}/employee/bills/order?id=${bill.id}" class="btn-back">
            <span class="material-symbols-outlined" style="font-size:16px">arrow_back</span>
            Quay lại phiếu bán hàng
        </a>
    </div>
</div>

<script>
    var QR_BANK    = 'MB';
    var QR_ACCOUNT = '0364298183';
    var QR_NAME    = 'FPOLY COFFEE';
    var BILL_TOTAL = Math.round(${bill.totalPrice});
    var BILL_CODE  = '${bill.code}';

    function buildQRUrl(amount, info) {
        var base     = 'https://img.vietqr.io/image';
        var template = 'compact2';
        var query    = 'amount=' + encodeURIComponent(amount) +
                       '&addInfo=' + encodeURIComponent(info) +
                       '&accountName=' + encodeURIComponent(QR_NAME);
        return base + '/' + QR_BANK + '-' + QR_ACCOUNT + '-' + template + '.png?' + query;
    }

    /* Load QR */
    (function() {
        if (BILL_TOTAL <= 0) {
            document.getElementById('qrLoading').innerHTML =
                '<span style="font-size:14px;color:#999">Phiếu chưa có sản phẩm.<br>Thêm món trước khi tạo QR.</span>';
            return;
        }
        var url = buildQRUrl(BILL_TOTAL, BILL_CODE);
        var img = document.getElementById('qrImg');
        var fbLink = document.getElementById('qrFallbackLink');
        if (fbLink) fbLink.href = url;
        img.src = url + '&_t=' + Date.now();
    })();

    function qrLoaded() {
        document.getElementById('qrLoading').style.display = 'none';
        document.getElementById('qrImg').style.display = 'block';
        startCountdown();
    }
    function qrFailed() {
        document.getElementById('qrLoading').style.display = 'none';
        document.getElementById('qrError').style.display = 'block';
        var fb = document.getElementById('qrFallbackLink');
        if (fb) fb.href = buildQRUrl(BILL_TOTAL, BILL_CODE);
    }

    /* Countdown 10 min */
    var countdownSec = 600, timer = null;
    function startCountdown() {
        var el = document.getElementById('qrCountdown');
        var td = document.getElementById('qrTimer');
        if (td) td.style.display = 'block';
        timer = setInterval(function() {
            countdownSec--;
            if (countdownSec <= 0) {
                clearInterval(timer);
                document.getElementById('qrImg').style.display = 'none';
                document.getElementById('qrLoading').style.display = 'block';
                document.getElementById('qrLoading').innerHTML =
                    '<span style="font-size:14px;color:#C62828;display:block;text-align:center">' +
                    '&#9888; QR hết hạn.<br>' +
                    '<button onclick="reloadQR()" style="margin-top:8px;padding:6px 16px;background:#003F8A;color:white;border:none;border-radius:8px;cursor:pointer;font-size:13px">Tạo lại QR</button></span>';
                if (td) td.style.display = 'none';
                return;
            }
            var m = String(Math.floor(countdownSec / 60)).padStart(2, '0');
            var s = String(countdownSec % 60).padStart(2, '0');
            if (el) { el.textContent = m + ':' + s; el.style.color = countdownSec < 60 ? '#C62828' : ''; }
        }, 1000);
    }
    function reloadQR() {
        countdownSec = 600;
        document.getElementById('qrLoading').innerHTML =
            '<div class="spinner"></div><span>Đang tạo mã QR...</span>';
        document.getElementById('qrLoading').style.display = 'block';
        var url = buildQRUrl(BILL_TOTAL, BILL_CODE);
        document.getElementById('qrImg').src = url + '&_t=' + Date.now();
    }

    /* Copy */
    function copyInfo() {
        var btn = document.getElementById('copyBtn');
        var info = 'Ngân hàng: MBBank\nSố tài khoản: ' + QR_ACCOUNT +
                   '\nTên tài khoản: ' + QR_NAME +
                   '\nSố tiền: ' + BILL_TOTAL.toLocaleString('vi-VN') + ' đ' +
                   '\nNội dung: ' + BILL_CODE;
        var done = function() {
            var orig = btn.innerHTML;
            btn.innerHTML = '<span class="material-symbols-outlined" style="font-size:16px">check_circle</span> Đã sao chép!';
            btn.style.background = '#D1FAE5'; btn.style.color = '#065F46'; btn.style.borderColor = '#6EE7B7';
            setTimeout(function() {
                btn.innerHTML = orig;
                btn.style.background = '#EBF3FF'; btn.style.color = '#1565C0'; btn.style.borderColor = '#B3D3FF';
            }, 2200);
        };
        if (navigator.clipboard && navigator.clipboard.writeText)
            navigator.clipboard.writeText(info).then(done).catch(function() { fallbackCopy(info, done); });
        else fallbackCopy(info, done);
    }
    function fallbackCopy(text, cb) {
        var ta = document.createElement('textarea');
        ta.value = text; ta.style.cssText = 'position:fixed;opacity:0;top:0;left:0';
        document.body.appendChild(ta); ta.select(); document.execCommand('copy');
        document.body.removeChild(ta); cb();
    }
</script>

</body>
</html>
