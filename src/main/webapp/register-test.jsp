<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Test Registration - 43 Gundam Hobby</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            padding: 20px;
        }
        .test-container {
            max-width: 800px;
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
            color: #28a745;
            font-weight: bold;
            margin-bottom: 20px;
        }
        .btn-test {
            background-color: #28a745;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            margin: 5px;
        }
        .btn-test:hover {
            background-color: #20c997;
            color: white;
        }
        .response-area {
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 5px;
            padding: 10px;
            margin-top: 10px;
            min-height: 100px;
            font-family: monospace;
            font-size: 12px;
        }
    </style>
</head>
<body>
    <div class="test-container">
        <div class="test-card">
            <h2 class="test-title">🧪 Test Registration API</h2>
            <p>Test the registration functionality with various scenarios.</p>
            
            <div class="mb-3">
                <button class="btn btn-test" onclick="testRegisterEndpoint()">Test Register Endpoint</button>
                <button class="btn btn-test" onclick="testValidRegistration()">Test Valid Registration</button>
                <button class="btn btn-test" onclick="testDuplicateEmail()">Test Duplicate Email</button>
                <button class="btn btn-test" onclick="testInvalidEmail()">Test Invalid Email</button>
                <button class="btn btn-test" onclick="testPasswordMismatch()">Test Password Mismatch</button>
                <button class="btn btn-test" onclick="testMissingFields()">Test Missing Fields</button>
                <button class="btn btn-test" onclick="clearResponse()">Clear Response</button>
            </div>
            
            <div id="response-area" class="response-area">
                Click a test button to see the response...
            </div>
        </div>
        
        <div class="test-card">
            <h3>📋 Test Links</h3>
            <p>Quick links to test the registration UI:</p>
            <a href="<%=request.getContextPath()%>/register.jsp" class="btn btn-outline-primary me-2">Register Page</a>
            <a href="<%=request.getContextPath()%>/login.jsp" class="btn btn-outline-secondary">Login Page</a>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const responseArea = document.getElementById('response-area');
        
        function log(message) {
            const timestamp = new Date().toLocaleTimeString();
            responseArea.innerHTML += `[${timestamp}] ${message}\n`;
            responseArea.scrollTop = responseArea.scrollHeight;
        }
        
        function clearResponse() {
            responseArea.innerHTML = 'Response cleared...\n';
        }
        
        async function testRegisterEndpoint() {
            log('Testing register endpoint...');
            try {
                const response = await fetch('/api/register-test');
                const data = await response.json();
                log('✅ Register endpoint test successful:');
                log(JSON.stringify(data, null, 2));
            } catch (error) {
                log('❌ Register endpoint test failed:');
                log(error.message);
            }
        }
        
        async function testValidRegistration() {
            log('Testing valid registration...');
            const testData = {
                firstName: 'Test',
                lastName: 'User',
                email: 'testuser' + Date.now() + '@example.com',
                password: 'password123',
                confirmPassword: 'password123',
                phone: '0123456789'
            };
            
            try {
                const formData = new FormData();
                Object.keys(testData).forEach(key => {
                    formData.append(key, testData[key]);
                });
                
                const response = await fetch('/api/register', {
                    method: 'POST',
                    body: formData
                });
                
                const data = await response.json();
                log('✅ Valid registration test:');
                log(`Status: ${response.status}`);
                log(JSON.stringify(data, null, 2));
            } catch (error) {
                log('❌ Valid registration test failed:');
                log(error.message);
            }
        }
        
        async function testDuplicateEmail() {
            log('Testing duplicate email...');
            const testData = {
                firstName: 'Test',
                lastName: 'User',
                email: 'test@example.com', // Common email that might already exist
                password: 'password123',
                confirmPassword: 'password123'
            };
            
            await performRegistrationTest(testData, 'Duplicate email test');
        }
        
        async function testInvalidEmail() {
            log('Testing invalid email...');
            const testData = {
                firstName: 'Test',
                lastName: 'User',
                email: 'invalid-email',
                password: 'password123',
                confirmPassword: 'password123'
            };
            
            await performRegistrationTest(testData, 'Invalid email test');
        }
        
        async function testPasswordMismatch() {
            log('Testing password mismatch...');
            const testData = {
                firstName: 'Test',
                lastName: 'User',
                email: 'test' + Date.now() + '@example.com',
                password: 'password123',
                confirmPassword: 'different_password'
            };
            
            await performRegistrationTest(testData, 'Password mismatch test');
        }
        
        async function testMissingFields() {
            log('Testing missing fields...');
            const testData = {
                firstName: '',
                lastName: 'User',
                email: 'test@example.com',
                password: 'password123',
                confirmPassword: 'password123'
            };
            
            await performRegistrationTest(testData, 'Missing fields test');
        }
        
        async function performRegistrationTest(testData, testName) {
            try {
                const formData = new FormData();
                Object.keys(testData).forEach(key => {
                    formData.append(key, testData[key]);
                });
                
                const response = await fetch('/api/register', {
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
    </script>
</body>
</html>
