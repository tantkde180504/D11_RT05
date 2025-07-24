// Test script for Address Book functionality
// Add this to browser console to test the API

async function testAddressAPI() {
    const contextPath = window.APP_CONTEXT_PATH || '';
    
    console.log('=== TESTING ADDRESS API ===');
    console.log('Context path:', contextPath);
    
    try {
        // Test 1: Test GET endpoint
        console.log('1. Testing GET /test endpoint...');
        const testResponse = await fetch(`${contextPath}/api/addresses/test`);
        console.log('GET test response status:', testResponse.status);
        console.log('GET test response headers:', testResponse.headers.get('content-type'));
        
        const testResult = await testResponse.json();
        console.log('GET test result:', testResult);
        
        // Test 2: Test POST endpoint
        console.log('2. Testing POST /test endpoint...');
        const testPostData = {
            test: "value",
            timestamp: new Date().getTime()
        };
        
        const postTestResponse = await fetch(`${contextPath}/api/addresses/test`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(testPostData)
        });
        
        console.log('POST test response status:', postTestResponse.status);
        console.log('POST test response headers:', postTestResponse.headers.get('content-type'));
        
        const postTestResult = await postTestResponse.json();
        console.log('POST test result:', postTestResult);
        
        // Test 3: Get addresses count
        console.log('3. Testing address count...');
        const countResponse = await fetch(`${contextPath}/api/addresses/count`);
        console.log('Count response status:', countResponse.status);
        
        const countResult = await countResponse.json();
        console.log('Count result:', countResult);
        
        // Test 4: Get all addresses
        console.log('4. Testing get all addresses...');
        const addressesResponse = await fetch(`${contextPath}/api/addresses`);
        console.log('Addresses response status:', addressesResponse.status);
        
        const addressesResult = await addressesResponse.json();
        console.log('Addresses result:', addressesResult);
        
        // Test 5: Test address creation with sample data
        console.log('5. Testing address creation...');
        const sampleAddress = {
            recipientName: "Test User",
            phone: "0123456789",
            houseNumber: "123 Test Street",
            ward: "Test Ward",
            district: "Test District",
            province: "Hà Nội",
            isDefault: false
        };
        
        console.log('Sample address data:', sampleAddress);
        
        const createResponse = await fetch(`${contextPath}/api/addresses`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(sampleAddress)
        });
        
        console.log('Create response status:', createResponse.status);
        console.log('Create response headers:', createResponse.headers.get('content-type'));
        
        // Check if response is JSON
        const contentType = createResponse.headers.get('content-type');
        if (!contentType || !contentType.includes('application/json')) {
            const textResponse = await createResponse.text();
            console.error('Non-JSON response from create:', textResponse);
            throw new Error('Server returned non-JSON response: ' + textResponse.substring(0, 200));
        }
        
        const createResult = await createResponse.json();
        console.log('Create result:', createResult);
        
        return {
            testGet: testResult,
            testPost: postTestResult,
            count: countResult,
            addresses: addressesResult,
            create: createResult
        };
        
    } catch (error) {
        console.error('Test failed:', error);
        return { error: error.message };
    }
}

// Quick test function for simple endpoint
async function simpleTest() {
    const contextPath = window.APP_CONTEXT_PATH || '';
    
    try {
        console.log('Testing simple endpoint...');
        const response = await fetch(`${contextPath}/api/addresses/simple-test`);
        
        console.log('Simple test response status:', response.status);
        console.log('Simple test response headers:', [...response.headers.entries()]);
        
        const contentType = response.headers.get('content-type');
        console.log('Content-Type:', contentType);
        
        if (!contentType || !contentType.includes('application/json')) {
            const textResponse = await response.text();
            console.error('Non-JSON response:', textResponse);
            return { error: 'Non-JSON response: ' + textResponse.substring(0, 200) };
        }
        
        const result = await response.json();
        console.log('Simple test result:', result);
        return result;
    } catch (error) {
        console.error('Simple test failed:', error);
        return { error: error.message };
    }
}

// Detailed test function
async function detailedAddressTest() {
    const contextPath = window.APP_CONTEXT_PATH || '';
    
    try {
        console.log('=== DETAILED ADDRESS TEST ===');
        
        // Test address data
        const testAddress = {
            recipientName: "Nguyễn Văn Test",
            phone: "0123456789", 
            houseNumber: "123 Test Street",
            ward: "Phường Test",
            district: "Quận Test",
            province: "Hà Nội",
            isDefault: false
        };
        
        console.log('Sending address data:', testAddress);
        
        const response = await fetch(`${contextPath}/api/addresses`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json'
            },
            body: JSON.stringify(testAddress)
        });
        
        console.log('=== RESPONSE DETAILS ===');
        console.log('Status:', response.status);
        console.log('Status text:', response.statusText);
        console.log('Headers:', [...response.headers.entries()]);
        console.log('OK:', response.ok);
        console.log('Type:', response.type);
        console.log('URL:', response.url);
        
        // Get raw response first
        const rawResponse = await response.clone().text();
        console.log('Raw response:', rawResponse);
        
        // Check content type
        const contentType = response.headers.get('content-type');
        if (!contentType || !contentType.includes('application/json')) {
            console.error('Server returned non-JSON:', contentType);
            return { 
                error: 'Non-JSON response',
                contentType: contentType,
                response: rawResponse 
            };
        }
        
        // Parse JSON
        const result = await response.json();
        console.log('Parsed result:', result);
        
        return result;
        
    } catch (error) {
        console.error('=== TEST ERROR ===');
        console.error('Error type:', error.constructor.name);
        console.error('Error message:', error.message);
        console.error('Full error:', error);
        return { error: error.message };
    }
}

// Quick test function for just POST test
async function quickPostTest() {
    const contextPath = window.APP_CONTEXT_PATH || '';
    
    try {
        const testData = { test: "quick test", time: Date.now() };
        const response = await fetch(`${contextPath}/api/addresses/test`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(testData)
        });
        
        console.log('Quick POST test status:', response.status);
        const result = await response.json();
        console.log('Quick POST test result:', result);
        return result;
    } catch (error) {
        console.error('Quick POST test failed:', error);
        return { error: error.message };
    }
}

// Run the test
console.log('Available test functions:');
console.log('- simpleTest() - Test simple endpoint without session');
console.log('- testAddressAPI() - Full API test');
console.log('- detailedAddressTest() - Detailed address creation test');
console.log('- quickPostTest() - Quick POST test');
