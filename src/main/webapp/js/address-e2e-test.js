// End-to-end test script for address functionality
console.log('Loading E2E Address Test Script...');

window.testAddressE2E = async function() {
    console.log('=== E2E ADDRESS TEST STARTING ===');
    
    const contextPath = window.APP_CONTEXT_PATH || '';
    
    // Test data
    const testAddress = {
        recipientName: 'Test User ' + Date.now(),
        phone: '0987654321',
        houseNumber: '123 Test Street',
        ward: 'Test Ward',
        district: 'Test District',
        province: 'Hà Nội',
        isDefault: false
    };
    
    try {
        console.log('1. Getting current address count...');
        let response = await fetch(`${contextPath}/api/addresses`);
        let data = await response.json();
        console.log('Current addresses response:', data);
        
        const initialCount = data.success ? data.addresses.length : 0;
        console.log('Initial address count:', initialCount);
        
        console.log('2. Adding new address...');
        console.log('Test address data:', testAddress);
        
        response = await fetch(`${contextPath}/api/addresses`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(testAddress)
        });
        
        console.log('Add response status:', response.status);
        const addResult = await response.json();
        console.log('Add response data:', addResult);
        
        if (!addResult.success) {
            console.error('Failed to add address:', addResult.message);
            return false;
        }
        
        console.log('3. Waiting 1 second...');
        await new Promise(resolve => setTimeout(resolve, 1000));
        
        console.log('4. Getting updated address list...');
        response = await fetch(`${contextPath}/api/addresses`);
        data = await response.json();
        console.log('Updated addresses response:', data);
        
        const finalCount = data.success ? data.addresses.length : 0;
        console.log('Final address count:', finalCount);
        
        if (finalCount === initialCount + 1) {
            console.log('✅ SUCCESS: Address count increased correctly');
            
            // Find the new address
            const newAddress = data.addresses.find(addr => 
                addr.recipient_name === testAddress.recipientName
            );
            
            if (newAddress) {
                console.log('✅ SUCCESS: New address found in list:', newAddress);
                
                // Clean up - delete the test address
                console.log('5. Cleaning up test address...');
                const deleteResponse = await fetch(`${contextPath}/api/addresses/${newAddress.id}`, {
                    method: 'DELETE'
                });
                const deleteResult = await deleteResponse.json();
                console.log('Delete result:', deleteResult);
                
                return true;
            } else {
                console.error('❌ FAIL: New address not found in list');
                return false;
            }
        } else {
            console.error(`❌ FAIL: Address count should be ${initialCount + 1} but is ${finalCount}`);
            return false;
        }
        
    } catch (error) {
        console.error('❌ E2E TEST ERROR:', error);
        return false;
    }
};

// Test refresh functionality
window.testAddressRefresh = async function() {
    console.log('=== TESTING ADDRESS REFRESH ===');
    
    if (typeof loadAddresses !== 'function') {
        console.error('loadAddresses function not available');
        return;
    }
    
    if (typeof refreshAddressList !== 'function') {
        console.error('refreshAddressList function not available');
        return;
    }
    
    console.log('1. Current addresses:', window.addresses || []);
    
    console.log('2. Loading addresses...');
    await loadAddresses();
    console.log('After loadAddresses:', window.addresses || []);
    
    console.log('3. Refreshing UI...');
    await refreshAddressList();
    
    console.log('4. Address refresh test complete');
};

console.log('E2E Address Test Script Loaded. Use testAddressE2E() or testAddressRefresh() in console.');
