<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Test Forgot Password - 43 Gundam Hobby</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            padding: 20px;
        }
        .test-container {
            max-width: 1000px;
            margin: 0 auto;
        }
        .test-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .test-title {
            color: #ff6600;
            font-weight: bold;
            margin-bottom: 20px;
        }
        .btn-test {
            background-color: #ff6600;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            margin: 5px;
        }
        .btn-test:hover {
            background-color: #e55a00;
            color: white;
        }
        .response-area {
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 5px;
            padding: 10px;
            margin-top: 10px;
            min-height: 150px;
            font-family: monospace;
            font-size: 12px;
            max-height: 400px;
            overflow-y: auto;
        }
        .test-input {
            margin-bottom: 10px;
        }
        .token-display {
            background-color: #fff3cd;
            border: 1px solid #ffecb5;
            border-radius: 5px;
            padding: 10px;
            margin-top: 10px;
            font-family: monospace;
            font-size: 12px;
            word-break: break-all;
        }
    </style>
</head>
<body>
    <div class="test-container">
        <div class="test-card">
            <h2 class="test-title">🧪 Test Forgot Password API</h2>
            <p>Test the forgot password functionality with various scenarios.</p>
            
            <div class="row">
                <div class="col-md-4">
                    <div class="test-input">
                        <label for="testEmail" class="form-label">Test Email:</label>
                        <input type="email" class="form-control" id="testEmail" value="test@example.com" placeholder="Enter email to test">
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="test-input">
                        <label for="testToken" class="form-label">Reset Token:</label>
                        <input type="text" class="form-control" id="testToken" placeholder="Token will appear here">
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="test-input">
                        <label for="newPassword" class="form-label">New Password:</label>
                        <input type="password" class="form-control" id="newPassword" value="newpassword123" placeholder="New password">
                    </div>
                </div>
            </div>
            
            <div class="mb-3">
                <h5>Step 1: Test Forgot Password</h5>
                <button class="btn btn-test" onclick="testForgotPasswordEndpoint()">Test Endpoint</button>
                <button class="btn btn-test" onclick="testValidEmail()">Test Valid Email</button>
                <button class="btn btn-test" onclick="testInvalidEmail()">Test Invalid Email</button>
                <button class="btn btn-test" onclick="testNonExistentEmail()">Test Non-existent Email</button>
            </div>
            
            <div class="mb-3">
                <h5>Step 2: Test Reset Password</h5>
                <button class="btn btn-test" onclick="testVerifyToken()">Verify Token</button>
                <button class="btn btn-test" onclick="testResetPassword()">Reset Password</button>
                <button class="btn btn-test" onclick="testInvalidToken()">Test Invalid Token</button>
                <button class="btn btn-test" onclick="testExpiredToken()">Test Expired Token</button>
            </div>
            
            <div class="mb-3">
                <button class="btn btn-secondary" onclick="clearResponse()">Clear Response</button>
                <button class="btn btn-info" onclick="generateTestToken()">Generate Test Token</button>
            </div>
            
            <div id="response-area" class="response-area">
                Click a test button to see the response...
            </div>
            
            <div id="token-display" class="token-display d-none">
                <strong>Current Reset Token:</strong><br>
                <span id="current-token">No token generated yet</span>
            </div>
        </div>
        
        <div class="test-card">
            <h3>📋 Test Links</h3>
            <p>Quick links to test the forgot password UI:</p>
            <a href="<%=request.getContextPath()%>/forgot-password.jsp" class="btn btn-outline-primary me-2" target="_blank">Forgot Password Page</a>
            <a href="<%=request.getContextPath()%>/login.jsp" class="btn btn-outline-secondary me-2" target="_blank">Login Page</a>
            <a href="<%=request.getContextPath()%>/register.jsp" class="btn btn-outline-success" target="_blank">Register Page</a>
        </div>
        
        <div class="test-card">
            <h3>📖 Usage Instructions</h3>
            <ol>
                <li><strong>Test Forgot Password:</strong> First test with a valid email to get a reset token</li>
                <li><strong>Copy Token:</strong> Copy the token from the response or use "Generate Test Token"</li>
                <li><strong>Test Reset:</strong> Use the token to test password reset functionality</li>
                <li><strong>Test Reset Link:</strong> Use the generated URL to test the full flow</li>
            </ol>
            
            <div class="alert alert-info">
                <strong>Note:</strong> In production, reset tokens would be sent via email. 
                For testing, tokens are returned in the API response.
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const responseArea = document.getElementById('response-area');
        let currentResetToken = '';
        
        function log(message) {
            const timestamp = new Date().toLocaleTimeString();
            responseArea.innerHTML += `[${timestamp}] ${message}\n`;
            responseArea.scrollTop = responseArea.scrollHeight;
        }
        
        function clearResponse() {
            responseArea.innerHTML = 'Response cleared...\n';
        }
        
        function updateTokenDisplay(token) {
            currentResetToken = token;
            document.getElementById('testToken').value = token;
            document.getElementById('current-token').textContent = token;
            document.getElementById('token-display').classList.remove('d-none');
        }
        
        async function testForgotPasswordEndpoint() {
            log('Testing forgot password endpoint...');
            try {
                const response = await fetch('/api/forgot-password-test');
                const data = await response.json();
                log('✅ Forgot password endpoint test successful:');
                log(JSON.stringify(data, null, 2));
            } catch (error) {
                log('❌ Forgot password endpoint test failed:');
                log(error.message);
            }
        }
        
        async function testValidEmail() {
            const email = document.getElementById('testEmail').value || 'test@example.com';
            log(`Testing forgot password with email: ${email}`);
            
            try {
                const formData = new FormData();
                formData.append('email', email);
                
                const response = await fetch('/api/forgot-password', {
                    method: 'POST',
                    body: formData
                });
                
                const data = await response.json();
                log('✅ Valid email test:');
                log(`Status: ${response.status}`);
                log(JSON.stringify(data, null, 2));
                
                // If we got a reset token, store it for testing
                if (data.resetToken) {
                    updateTokenDisplay(data.resetToken);
                    log('🔑 Reset token captured for testing');
                    
                    // Generate test URL
                    const testUrl = window.location.origin + '/forgot-password.jsp?token=' + data.resetToken;
                    log(`🔗 Test reset URL: ${testUrl}`);
                }
            } catch (error) {
                log('❌ Valid email test failed:');
                log(error.message);
            }
        }
        
        async function testInvalidEmail() {
            log('Testing forgot password with invalid email...');
            await performForgotPasswordTest('invalid-email', 'Invalid email test');
        }
        
        async function testNonExistentEmail() {
            log('Testing forgot password with non-existent email...');
            await performForgotPasswordTest('nonexistent' + Date.now() + '@example.com', 'Non-existent email test');
        }
        
        async function performForgotPasswordTest(email, testName) {
            try {
                const formData = new FormData();
                formData.append('email', email);
                
                const response = await fetch('/api/forgot-password', {
                    method: 'POST',
                    body: formData
                });
                
                const data = await response.json();
                log(`✅ ${testName}:`);
                log(`Status: ${response.status}`);
                log(JSON.stringify(data, null, 2));
            } catch (error) {
                log(`❌ ${testName} failed:`);
                log(error.message);
            }
        }
        
        async function testVerifyToken() {
            const token = document.getElementById('testToken').value || currentResetToken;
            if (!token) {
                log('❌ No token to verify. Please generate a token first.');
                return;
            }
            
            log(`Testing token verification: ${token.substring(0, 20)}...`);
            
            try {
                const response = await fetch(`/api/verify-reset-token?token=${encodeURIComponent(token)}`);
                const data = await response.json();
                log('✅ Token verification test:');
                log(`Status: ${response.status}`);
                log(JSON.stringify(data, null, 2));
            } catch (error) {
                log('❌ Token verification test failed:');
                log(error.message);
            }
        }
        
        async function testResetPassword() {
            const token = document.getElementById('testToken').value || currentResetToken;
            const newPassword = document.getElementById('newPassword').value || 'newpassword123';
            
            if (!token) {
                log('❌ No token available. Please generate a token first.');
                return;
            }
            
            log(`Testing password reset with token: ${token.substring(0, 20)}...`);
            
            try {
                const formData = new FormData();
                formData.append('token', token);
                formData.append('newPassword', newPassword);
                formData.append('confirmNewPassword', newPassword);
                
                const response = await fetch('/api/reset-password', {
                    method: 'POST',
                    body: formData
                });
                
                const data = await response.json();
                log('✅ Password reset test:');
                log(`Status: ${response.status}`);
                log(JSON.stringify(data, null, 2));
                
                if (data.success) {
                    log('🎉 Password reset successful! Token has been consumed.');
                    // Clear the token as it's now used
                    currentResetToken = '';
                    document.getElementById('testToken').value = '';
                }
            } catch (error) {
                log('❌ Password reset test failed:');
                log(error.message);
            }
        }
        
        async function testInvalidToken() {
            log('Testing with invalid token...');
            
            try {
                const formData = new FormData();
                formData.append('token', 'invalid-token-12345');
                formData.append('newPassword', 'newpassword123');
                formData.append('confirmNewPassword', 'newpassword123');
                
                const response = await fetch('/api/reset-password', {
                    method: 'POST',
                    body: formData
                });
                
                const data = await response.json();
                log('✅ Invalid token test:');
                log(`Status: ${response.status}`);
                log(JSON.stringify(data, null, 2));
            } catch (error) {
                log('❌ Invalid token test failed:');
                log(error.message);
            }
        }
        
        async function testExpiredToken() {
            log('Testing with potentially expired token...');
            // This would need a pre-generated expired token
            log('ℹ️ This test requires a manually expired token from the database');
        }
        
        function generateTestToken() {
            log('Generating test token by requesting forgot password...');
            testValidEmail();
        }
    </script>
</body>
</html>
