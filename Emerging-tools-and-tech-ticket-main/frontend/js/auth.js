/* ===========================================
   Authentication Helper Functions
   Handles login, logout, and user session
   =========================================== */

/**
 * Check if user is logged in
 * Returns true if token exists in localStorage
 */
function isLoggedIn() {
    return localStorage.getItem('token') !== null;
}

/**
 * Get stored user data
 * Returns an object with user info from localStorage
 */
function getUser() {
    return {
        token: localStorage.getItem('token'),
        role: localStorage.getItem('role'),
        agentType: localStorage.getItem('agent_type'),
        customerType: localStorage.getItem('customer_type')
    };
}

/**
 * Save user data to localStorage after login
 * @param {object} userData - User data from login response
 */
function saveUserData(userData) {
    localStorage.setItem('token', userData.token);
    localStorage.setItem('role', userData.role);

    if (userData.agent_type) {
        localStorage.setItem('agent_type', userData.agent_type);
    }
    if (userData.customer_type) {
        localStorage.setItem('customer_type', userData.customer_type);
    }
}

/**
 * Clear user data and logout
 */
function logout() {
    localStorage.removeItem('token');
    localStorage.removeItem('role');
    localStorage.removeItem('agent_type');
    localStorage.removeItem('customer_type');
    // Redirect to login page
    window.location.href = getBasePath() + 'index.html';
}

/**
 * Check authentication and redirect if not logged in
 * Call this at the start of every protected page
 */
function requireAuth() {
    if (!isLoggedIn()) {
        window.location.href = getBasePath() + 'index.html';
        return false;
    }
    return true;
}

/**
 * Get the redirect URL based on user role
 * Used after login to send user to correct dashboard
 */
function getDashboardUrl() {
    const user = getUser();
    const basePath = getBasePath();

    if (user.role === 'customer') {
        if (user.customerType === 'manager') {
            return basePath + 'pages/manager/dashboard.html';
        } else {
            return basePath + 'pages/customer/dashboard.html';
        }
    } else if (user.role === 'agent') {
        if (user.agentType === 'admin') {
            return basePath + 'pages/admin/dashboard.html';
        } else {
            // All agents (normal, delivery_lead, hod) go to agent dashboard
            return basePath + 'pages/agent/dashboard.html';
        }
    }

    // Default fallback
    return basePath + 'index.html';
}

/**
 * Get the base path for links (handles nested pages)
 * This calculates how many "../" needed based on current page depth
 */
function getBasePath() {
    const path = window.location.pathname;

    // Count how deep we are in the folder structure
    if (path.includes('/pages/customer/') ||
        path.includes('/pages/manager/') ||
        path.includes('/pages/agent/') ||
        path.includes('/pages/admin/')) {
        return '../../';
    }
    if (path.includes('/pages/')) {
        return '../';
    }
    return './';
}

/**
 * Check if current user has a specific role
 * @param {string} role - Role to check ('customer', 'agent')
 * @param {string} subType - Sub-type to check (optional)
 */
function hasRole(role, subType = null) {
    const user = getUser();

    if (user.role !== role) {
        return false;
    }

    if (subType) {
        if (role === 'customer') {
            return user.customerType === subType;
        } else if (role === 'agent') {
            return user.agentType === subType;
        }
    }

    return true;
}

/**
 * Get user role display name
 */
function getUserRoleDisplay() {
    const user = getUser();

    if (user.role === 'customer') {
        return user.customerType === 'manager' ? 'Manager' : 'Customer';
    } else if (user.role === 'agent') {
        switch (user.agentType) {
            case 'admin':
                return 'Admin';
            case 'delivery_lead':
                return 'Delivery Lead';
            case 'hod':
                return 'HOD';
            default:
                return 'Agent';
        }
    }

    return 'User';
}
