/**
 * Authentication Debug and Testing Script
 * Comprehensive testing for the unified navbar authentication system
 */

window.AuthDebugger = {
    // Debug configuration
    config: {
        enableConsoleLogging: true,
        enableUIOverlay: true,
        checkInterval: 2000 // Check every 2 seconds
    },

    // Initialize the debugger
    init() {
        console.log('🔧 Auth Debugger initialized');
        this.createDebugOverlay();
        this.startMonitoring();
        this.bindDebugControls();
    },

    // Create debug overlay UI
    createDebugOverlay() {
        if (!this.config.enableUIOverlay) return;

        const overlay = document.createElement('div');
        overlay.id = 'auth-debug-overlay';
        overlay.innerHTML = `
            <div style="
                position: fixed;
                top: 10px;
                right: 10px;
                background: rgba(0,0,0,0.9);
                color: white;
                padding: 15px;
                border-radius: 8px;
                font-family: monospace;
                font-size: 12px;
                z-index: 9999;
                max-width: 350px;
                border: 2px solid #28a745;
            ">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
                    <strong>🔧 Auth Debug Panel</strong>
                    <button id="toggle-debug" style="background: #dc3545; color: white; border: none; padding: 2px 6px; border-radius: 3px; cursor: pointer;">×</button>
                </div>
                <div id="debug-status">Initializing...</div>
                <div style="margin-top: 10px;">
                    <button id="force-refresh" style="background: #007bff; color: white; border: none; padding: 5px 10px; border-radius: 3px; cursor: pointer; margin-right: 5px;">Force Refresh</button>
                    <button id="clear-auth" style="background: #dc3545; color: white; border: none; padding: 5px 10px; border-radius: 3px; cursor: pointer;">Clear Auth</button>
                </div>
                <div style="margin-top: 10px;">
                    <button id="simulate-login" style="background: #28a745; color: white; border: none; padding: 5px 10px; border-radius: 3px; cursor: pointer; margin-right: 5px;">Simulate Login</button>
                    <button id="simulate-logout" style="background: #fd7e14; color: white; border: none; padding: 5px 10px; border-radius: 3px; cursor: pointer;">Simulate Logout</button>
                </div>
            </div>
        `;
        document.body.appendChild(overlay);
    },

    // Bind debug control buttons
    bindDebugControls() {
        setTimeout(() => {
            const toggleBtn = document.getElementById('toggle-debug');
            const forceRefreshBtn = document.getElementById('force-refresh');
            const clearAuthBtn = document.getElementById('clear-auth');
            const simulateLoginBtn = document.getElementById('simulate-login');
            const simulateLogoutBtn = document.getElementById('simulate-logout');

            if (toggleBtn) {
                toggleBtn.addEventListener('click', () => {
                    const overlay = document.getElementById('auth-debug-overlay');
                    if (overlay) overlay.remove();
                });
            }

            if (forceRefreshBtn) {
                forceRefreshBtn.addEventListener('click', () => {
                    this.forceAuthRefresh();
                });
            }

            if (clearAuthBtn) {
                clearAuthBtn.addEventListener('click', () => {
                    this.clearAuthData();
                });
            }

            if (simulateLoginBtn) {
                simulateLoginBtn.addEventListener('click', () => {
                    this.simulateLogin();
                });
            }

            if (simulateLogoutBtn) {
                simulateLogoutBtn.addEventListener('click', () => {
                    this.simulateLogout();
                });
            }
        }, 100);
    },

    // Start monitoring authentication state
    startMonitoring() {
        this.updateDebugStatus();
        setInterval(() => {
            this.updateDebugStatus();
        }, this.config.checkInterval);
    },

    // Update debug status display
    updateDebugStatus() {
        const statusElement = document.getElementById('debug-status');
        if (!statusElement) return;

        const authData = this.getAuthData();
        const navbarState = this.getNavbarState();
        
        const status = `
            <div style="margin-bottom: 8px;"><strong>📊 Auth State:</strong></div>
            <div>✅ Logged In: ${authData.isLoggedIn}</div>
            <div>👤 User: ${authData.userName || 'None'}</div>
            <div>📧 Email: ${authData.userEmail || 'None'}</div>
            <div>🎭 Avatar: ${authData.userAvatar ? 'Yes' : 'No'}</div>
            <div style="margin: 8px 0;"><strong>🎯 Navbar State:</strong></div>
            <div>👁️ User Info: ${navbarState.userInfoVisible}</div>
            <div>🚪 Login Btn: ${navbarState.loginBtnVisible}</div>
            <div>🖼️ Avatar Loaded: ${navbarState.avatarLoaded}</div>
            <div style="margin: 8px 0;"><strong>📍 Current Page:</strong></div>
            <div>${window.location.pathname}</div>
        `;

        statusElement.innerHTML = status;
    },

    // Get authentication data from localStorage
    getAuthData() {
        return {
            isLoggedIn: localStorage.getItem('userLoggedIn') === 'true',
            userName: localStorage.getItem('userName'),
            userEmail: localStorage.getItem('userEmail'),
            userRole: localStorage.getItem('userRole'),
            userAvatar: localStorage.getItem('userAvatar')
        };
    },

    // Get navbar UI state
    getNavbarState() {
        const userInfo = document.getElementById('nav-user-info');
        const loginBtn = document.getElementById('nav-login-btn');
        const avatarImg = document.getElementById('userAvatarImage');

        return {
            userInfoVisible: userInfo ? !userInfo.classList.contains('d-none') && userInfo.style.display !== 'none' : false,
            loginBtnVisible: loginBtn ? !loginBtn.classList.contains('d-none') && loginBtn.style.display !== 'none' : false,
            avatarLoaded: avatarImg ? avatarImg.src && !avatarImg.src.includes('placeholder.jpg') : false
        };
    },

    // Force authentication refresh
    forceAuthRefresh() {
        console.log('🔄 Forcing auth refresh...');
        if (window.authSyncManager) {
            window.authSyncManager.forceRefresh();
        }
        if (window.navbarManager) {
            window.navbarManager.checkInitialState();
        }
        this.updateDebugStatus();
    },

    // Clear all authentication data
    clearAuthData() {
        console.log('🗑️ Clearing auth data...');
        localStorage.removeItem('userLoggedIn');
        localStorage.removeItem('userName');
        localStorage.removeItem('userEmail');
        localStorage.removeItem('userRole');
        localStorage.removeItem('userAvatar');
        
        // Trigger logout event
        window.dispatchEvent(new CustomEvent('userLoggedOut'));
        this.updateDebugStatus();
    },

    // Simulate user login
    simulateLogin() {
        console.log('🎭 Simulating login...');
        const testUser = {
            userName: 'Test User',
            userEmail: 'test@example.com',
            userRole: 'CUSTOMER',
            avatarUrl: window.AvatarUtils ? window.AvatarUtils.generateDefaultAvatar('Test User', 'test@example.com') : ''
        };

        localStorage.setItem('userLoggedIn', 'true');
        localStorage.setItem('userName', testUser.userName);
        localStorage.setItem('userEmail', testUser.userEmail);
        localStorage.setItem('userRole', testUser.userRole);
        if (testUser.avatarUrl) {
            localStorage.setItem('userAvatar', testUser.avatarUrl);
        }

        // Trigger login event
        window.dispatchEvent(new CustomEvent('userLoggedIn', {
            detail: {
                fullName: testUser.userName,
                email: testUser.userEmail,
                role: testUser.userRole,
                avatarUrl: testUser.avatarUrl
            }
        }));

        this.updateDebugStatus();
    },

    // Simulate user logout
    simulateLogout() {
        console.log('🚪 Simulating logout...');
        this.clearAuthData();
    },

    // Comprehensive auth state test
    runComprehensiveTest() {
        console.log('🧪 Running comprehensive auth test...');
        
        const results = {
            localStorageTest: this.testLocalStorage(),
            navbarElementsTest: this.testNavbarElements(),
            eventListenersTest: this.testEventListeners(),
            avatarUtilsTest: this.testAvatarUtils(),
            authSyncTest: this.testAuthSync()
        };

        console.log('📋 Test Results:', results);
        return results;
    },

    // Test localStorage functionality
    testLocalStorage() {
        try {
            localStorage.setItem('test', 'value');
            const value = localStorage.getItem('test');
            localStorage.removeItem('test');
            return value === 'value';
        } catch (error) {
            console.error('localStorage test failed:', error);
            return false;
        }
    },

    // Test navbar elements exist
    testNavbarElements() {
        const requiredElements = [
            'nav-user-info',
            'nav-login-btn',
            'userAvatarImage',
            'userDisplayName',
            'userFullName'
        ];

        const results = {};
        requiredElements.forEach(id => {
            results[id] = !!document.getElementById(id);
        });

        return results;
    },

    // Test event listeners
    testEventListeners() {
        const testEvent = new CustomEvent('userLoggedIn', {
            detail: { fullName: 'Test', email: 'test@test.com' }
        });
        
        let eventFired = false;
        const testListener = () => { eventFired = true; };
        
        window.addEventListener('userLoggedIn', testListener);
        window.dispatchEvent(testEvent);
        window.removeEventListener('userLoggedIn', testListener);
        
        return eventFired;
    },

    // Test avatar utilities
    testAvatarUtils() {
        if (!window.AvatarUtils) return false;
        
        try {
            const gravatar = window.AvatarUtils.getGravatarUrl('test@example.com');
            const uiAvatar = window.AvatarUtils.getUIAvatarUrl('Test User');
            const initials = window.AvatarUtils.getInitials('Test User');
            
            return !!(gravatar && uiAvatar && initials);
        } catch (error) {
            console.error('AvatarUtils test failed:', error);
            return false;
        }
    },

    // Test auth sync manager
    testAuthSync() {
        return !!(window.authSyncManager && typeof window.authSyncManager.forceRefresh === 'function');
    }
};

// Auto-initialize if in debug mode
if (window.location.search.includes('debug=auth') || localStorage.getItem('authDebugMode') === 'true') {
    document.addEventListener('DOMContentLoaded', () => {
        setTimeout(() => {
            window.AuthDebugger.init();
        }, 1000);
    });
}

// Add global debug functions
window.debugAuth = () => window.AuthDebugger.runComprehensiveTest();
window.enableAuthDebug = () => {
    localStorage.setItem('authDebugMode', 'true');
    window.AuthDebugger.init();
};
window.disableAuthDebug = () => {
    localStorage.removeItem('authDebugMode');
    const overlay = document.getElementById('auth-debug-overlay');
    if (overlay) overlay.remove();
};

console.log('🔧 Auth Debug script loaded. Use debugAuth(), enableAuthDebug(), or disableAuthDebug() in console.');
