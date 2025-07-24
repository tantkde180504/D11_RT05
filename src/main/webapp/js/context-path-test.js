// Context Path Detection Test Script
console.log('=== CONTEXT PATH DETECTION TEST ===');

function testContextPath() {
    const fullPath = window.location.pathname;
    console.log('Current full pathname:', fullPath);
    console.log('Current href:', window.location.href);
    console.log('Current host:', window.location.host);
    console.log('Current origin:', window.location.origin);
    
    let contextPath = '';
    if (fullPath.includes('/login.jsp')) {
        // Extract context path before /login.jsp
        const pathParts = fullPath.split('/login.jsp')[0];
        contextPath = pathParts && pathParts !== '' ? pathParts : '';
    } else {
        // Fallback: try to get from first path segment
        const segments = fullPath.split('/').filter(Boolean);
        contextPath = segments.length > 0 ? '/' + segments[0] : '';
    }
    
    const apiUrl = contextPath + '/api/login';
    const homeUrl = contextPath || '/';
    
    console.log('Detected context path:', contextPath);
    console.log('Constructed API URL:', apiUrl);
    console.log('Constructed home URL:', homeUrl);
    console.log('Full API URL:', window.location.origin + apiUrl);
    
    return {
        fullPath,
        contextPath,
        apiUrl,
        homeUrl,
        fullApiUrl: window.location.origin + apiUrl
    };
}

// Test different scenarios
function testDifferentPaths() {
    console.log('\n=== TESTING DIFFERENT PATH SCENARIOS ===');
    
    const testCases = [
        '/login.jsp',           // No context
        '/myapp/login.jsp',     // With context
        '/43gundam/login.jsp',  // Real app context
        '/ROOT/login.jsp',      // ROOT context
    ];
    
    testCases.forEach(testPath => {
        console.log(`\nTesting path: ${testPath}`);
        
        let contextPath = '';
        if (testPath.includes('/login.jsp')) {
            const pathParts = testPath.split('/login.jsp')[0];
            contextPath = pathParts && pathParts !== '' ? pathParts : '';
        }
        
        const apiUrl = contextPath + '/api/login';
        console.log(`  Context: "${contextPath}"`);
        console.log(`  API URL: ${apiUrl}`);
    });
}

// Auto-run tests
document.addEventListener('DOMContentLoaded', function() {
    console.log('Context path test ready!');
    console.log('Run testContextPath() to test current page');
    console.log('Run testDifferentPaths() to test scenarios');
    
    // Auto-test current page
    setTimeout(() => {
        testContextPath();
        testDifferentPaths();
    }, 1000);
});

// Make functions globally available
window.contextPathTest = {
    testContextPath,
    testDifferentPaths
};
