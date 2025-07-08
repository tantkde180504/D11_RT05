// Test script để demo login flow
console.log("🎮 43 Gundam Hobby - Login Flow Demo");

// Danh sách tài khoản test
const testAccounts = [
    {
        email: "admin@gundamhobby.com",
        password: "admin123",
        role: "ADMIN",
        name: "Admin User",
        targetPage: "/"
    },
    {
        email: "staff@gundamhobby.com", 
        password: "staff123",
        role: "STAFF",
        name: "Staff User",
        targetPage: "staffsc.jsp"
    },
    {
        email: "customer@gundamhobby.com",
        password: "customer123", 
        role: "CUSTOMER",
        name: "Nguyễn Văn A",
        targetPage: "index.jsp"
    }
];

// Function test login
async function testLogin(account) {
    console.log(`\n🔄 Testing login for ${account.role}: ${account.email}`);
    
    try {
        const response = await fetch('/api/login', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: `email=${encodeURIComponent(account.email)}&password=${encodeURIComponent(account.password)}`
        });
        
        const data = await response.json();
        
        if (response.status === 200 && data.success) {
            console.log(`✅ Login successful!`);
            console.log(`   👤 User: ${data.fullName}`);
            console.log(`   🎭 Role: ${data.role}`);
            console.log(`   🎯 Target: ${account.targetPage}`);
            console.log(`   📋 Response:`, data);
        } else {
            console.log(`❌ Login failed:`, data.message);
        }
    } catch (error) {
        console.log(`💥 Error:`, error.message);
    }
}

// Function test tất cả accounts
async function testAllAccounts() {
    console.log("🚀 Testing all accounts...\n");
    
    for (const account of testAccounts) {
        await testLogin(account);
        await new Promise(resolve => setTimeout(resolve, 1000)); // Delay 1s
    }
    
    console.log("\n✨ All tests completed!");
}

// Function test với sai thông tin
async function testInvalidLogin() {
    console.log("\n🧪 Testing invalid login...");
    
    try {
        const response = await fetch('/api/login', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'email=wrong@email.com&password=wrongpassword'
        });
        
        const data = await response.json();
        console.log(`Status: ${response.status}`);
        console.log(`Response:`, data);
    } catch (error) {
        console.log(`Error:`, error.message);
    }
}

// Export functions để có thể sử dụng trong console
window.testLogin = testLogin;
window.testAllAccounts = testAllAccounts;
window.testInvalidLogin = testInvalidLogin;
window.testAccounts = testAccounts;

console.log(`
📋 Available test functions:
   - testLogin(account)     : Test login cho 1 tài khoản
   - testAllAccounts()      : Test tất cả tài khoản
   - testInvalidLogin()     : Test login sai thông tin
   - testAccounts          : Danh sách tài khoản test

💡 Example usage:
   testAllAccounts()
   testLogin(testAccounts[0])
`);
