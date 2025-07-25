<!-- Unified Scripts - Single source for consistent header behavior -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<!-- Anti-Flicker Unified - MUST RUN FIRST to prevent navbar flickering -->
<script src="<%=request.getContextPath()%>/js/anti-flicker-unified.js"></script>

<!-- Legacy Cleanup - Remove old elements after anti-flicker -->
<script src="<%=request.getContextPath()%>/js/legacy-navbar-cleanup.js"></script>

<!-- MD5 Library for Gravatar -->
<script src="<%=request.getContextPath()%>/js/md5.min.js"></script>

<!-- Modern Notification System -->
<script src="<%=request.getContextPath()%>/js/notification-system.js"></script>

<!-- Email to Google Converter -->
<script src="<%=request.getContextPath()%>/js/email-to-google-converter.js"></script>

<!-- Unified Navbar Manager - Core navbar logic -->
<script src="<%=request.getContextPath()%>/js/unified-navbar-manager.js"></script>

<!-- Google OAuth Handler - Updated for unified navbar -->
<script src="<%=request.getContextPath()%>/js/google-oauth-handler.js"></script>

<!-- Hamburger Menu Script -->
<script src="<%=request.getContextPath()%>/js/hamburger-menu.js"></script>

<!-- Modern Category Navigation Script -->
<script src="<%=request.getContextPath()%>/js/modern-category-nav.js"></script>

<!-- Mobile Sidebar Z-Index Fix - CRITICAL for visibility -->
<script src="<%=request.getContextPath()%>/js/mobile-sidebar-fix.js"></script>

<!-- Search Autocomplete Script -->
<script src="<%=request.getContextPath()%>/js/search-autocomplete.js"></script>

<!-- Debug Script for troubleshooting -->
<script src="<%=request.getContextPath()%>/js/debug-navbar.js"></script>

<!-- UTF-8 Placeholder Fix - Handles Vietnamese text encoding -->
<script src="<%=request.getContextPath()%>/js/utf8-placeholder-fix.js"></script>

<!-- Context Path Setup -->
<script>
    window.contextPath = '<%=request.getContextPath()%>';
    console.log('Context path set to:', window.contextPath);
</script>
