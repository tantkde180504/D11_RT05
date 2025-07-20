<!-- Unified Scripts - Single source for consistent header behavior -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<!-- Legacy Cleanup - MUST RUN FIRST to remove old elements -->
<script src="<%=request.getContextPath()%>/js/legacy-navbar-cleanup.js"></script>

<!-- MD5 Library for Gravatar -->
<script src="<%=request.getContextPath()%>/js/md5.min.js"></script>

<!-- Email to Google Converter -->
<script src="<%=request.getContextPath()%>/js/email-to-google-converter.js"></script>

<!-- Anti-Flicker Unified - LOAD FIRST to prevent navbar flickering -->
<script src="<%=request.getContextPath()%>/js/anti-flicker-unified.js"></script>

<!-- Unified Navbar Manager - Core navbar logic -->
<script src="<%=request.getContextPath()%>/js/unified-navbar-manager.js"></script>

<!-- Google OAuth Handler - Updated for unified navbar -->
<script src="<%=request.getContextPath()%>/js/google-oauth-handler.js"></script>

<!-- Hamburger Menu Script -->
<script src="<%=request.getContextPath()%>/js/hamburger-menu.js"></script>

<!-- Search Autocomplete Script -->
<script src="<%=request.getContextPath()%>/js/search-autocomplete.js"></script>

<!-- Context Path Setup -->
<script>
    window.contextPath = '<%=request.getContextPath()%>';
    console.log('Context path set to:', window.contextPath);
</script>
