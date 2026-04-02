/* ===========================================
   Common Utility Functions
   Reusable helper functions used across pages
   =========================================== */

// ============ DATE/TIME FORMATTING ============

/**
 * Format a date string to readable format
 * @param {string} dateString - ISO date string from API
 * @returns {string} - Formatted date like "Mar 18, 2024"
 */
function formatDate(dateString) {
    if (!dateString) return '-';
    const date = new Date(dateString);
    return date.toLocaleDateString('en-US', {
        year: 'numeric',
        month: 'short',
        day: 'numeric'
    });
}

/**
 * Format a date with time
 * @param {string} dateString - ISO date string from API
 * @returns {string} - Formatted like "Mar 18, 2024 10:30 AM"
 */
function formatDateTime(dateString) {
    if (!dateString) return '-';
    const date = new Date(dateString);
    return date.toLocaleDateString('en-US', {
        year: 'numeric',
        month: 'short',
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
    });
}

/**
 * Calculate ticket age in hours and days
 * @param {string} createdAt - Ticket creation date
 * @returns {string} - Age like "2 days 5 hours"
 */
function calculateTicketAge(createdAt) {
    if (!createdAt) return '-';

    const created = new Date(createdAt);
    const now = new Date();
    const diffMs = now - created;
    const diffHours = Math.floor(diffMs / (1000 * 60 * 60));
    const days = Math.floor(diffHours / 24);
    const hours = diffHours % 24;

    if (days > 0) {
        return `${days} day${days > 1 ? 's' : ''} ${hours} hr${hours > 1 ? 's' : ''}`;
    }
    return `${hours} hour${hours > 1 ? 's' : ''}`;
}

// ============ STATUS/PRIORITY HELPERS ============

/**
 * Get CSS class for priority badge
 * @param {number} priority - Priority level (1-5)
 * @returns {string} - CSS class name
 */
function getPriorityClass(priority) {
    return 'priority-' + priority;
}

/**
 * Get priority label
 * @param {number} priority - Priority level (1-5)
 * @returns {string} - Label like "L1 - Critical"
 */
function getPriorityLabel(priority) {
    const labels = {
        1: 'L1 - Critical',
        2: 'L2 - High',
        3: 'L3 - Medium',
        4: 'L4 - Low',
        5: 'L5 - Minimal'
    };
    return labels[priority] || 'Unknown';
}

/**
 * Get CSS class for status badge
 * @param {string} status - Ticket status
 * @returns {string} - CSS class name
 */
function getStatusClass(status) {
    const classes = {
        'Unassigned': 'badge-secondary',
        'Open': 'badge-primary',
        'Assigned': 'badge-info',
        'Requirements': 'badge-info',
        'Development': 'badge-warning',
        'Internal Testing': 'badge-warning',
        'UAT': 'badge-warning',
        'Resolved': 'badge-success',
        'Closed': 'badge-success',
        'Escalated': 'badge-danger',
        'Pending': 'badge-warning',
        'Approved': 'badge-success',
        'Rejected': 'badge-danger'
    };
    return classes[status] || 'badge-secondary';
}

/**
 * Get next possible status in workflow
 * @param {string} currentStatus - Current ticket status
 * @returns {string} - Next status
 */
function getNextStatus(currentStatus) {
    const workflow = {
        'Unassigned': 'Open',
        'Open': 'Assigned',
        'Assigned': 'Requirements',
        'Requirements': 'Development',
        'Development': 'Internal Testing',
        'Internal Testing': 'UAT',
        'UAT': 'Resolved',
        'Resolved': 'Closed'
    };
    return workflow[currentStatus] || currentStatus;
}

// ============ HTML HELPERS ============

/**
 * Show an alert message on the page
 * @param {string} message - Message to show
 * @param {string} type - Alert type ('success', 'danger', 'warning', 'info')
 * @param {string} containerId - ID of container element to show alert in
 */
function showAlert(message, type = 'info', containerId = 'alert-container') {
    const container = document.getElementById(containerId);
    if (container) {
        container.innerHTML = `
            <div class="alert alert-${type}">
                ${message}
            </div>
        `;
        // Auto-hide after 5 seconds
        setTimeout(() => {
            container.innerHTML = '';
        }, 5000);
    }
}

/**
 * Show loading spinner
 * @param {string} containerId - ID of container element
 */
function showLoading(containerId) {
    const container = document.getElementById(containerId);
    if (container) {
        container.innerHTML = `
            <div class="loading">
                <div class="spinner"></div>
            </div>
        `;
    }
}

/**
 * Hide loading spinner (by replacing with content)
 * @param {string} containerId - ID of container element
 * @param {string} content - HTML content to show
 */
function hideLoading(containerId, content = '') {
    const container = document.getElementById(containerId);
    if (container) {
        container.innerHTML = content;
    }
}

/**
 * Open a modal
 * @param {string} modalId - ID of modal overlay element
 */
function openModal(modalId) {
    const modal = document.getElementById(modalId);
    if (modal) {
        modal.classList.add('active');
    }
}

/**
 * Close a modal
 * @param {string} modalId - ID of modal overlay element
 */
function closeModal(modalId) {
    const modal = document.getElementById(modalId);
    if (modal) {
        modal.classList.remove('active');
    }
}

/**
 * Get URL parameter value
 * @param {string} name - Parameter name
 * @returns {string|null} - Parameter value
 */
function getUrlParam(name) {
    const params = new URLSearchParams(window.location.search);
    return params.get(name);
}

/**
 * Escape HTML to prevent XSS
 * @param {string} text - Text to escape
 * @returns {string} - Escaped text
 */
function escapeHtml(text) {
    if (!text) return '';
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

// ============ CATEGORY/SUBCATEGORY DATA ============

/**
 * Get subcategories for a category
 * @param {string} category - Main category
 * @returns {array} - Array of subcategory options
 */
function getSubcategories(category) {
    const subcategories = {
        'SAP': ['MM', 'SD', 'FI', 'ABAP', 'BASIS'],
        'Product': ['Vendor Portal', 'Customer Portal', 'Tax', 'General'],
        'Integration': ['Middleware'],
        'Other': ['Other']
    };
    return subcategories[category] || [];
}

// ============ SLA DATA ============

/**
 * Get SLA hours based on priority
 * @param {number} priority - Priority level (1-5)
 * @returns {number} - SLA hours
 */
function getSlaHours(priority) {
    const slaMap = {
        1: 4,    // L1 - 4 hours
        2: 8,    // L2 - 8 hours
        3: 24,   // L3 - 24 hours
        4: 48,   // L4 - 48 hours
        5: 72    // L5 - 72 hours
    };
    return slaMap[priority] || 24;
}

// ============ TABLE HELPERS ============

/**
 * Generate table HTML from data
 * @param {array} headers - Array of header objects {key, label}
 * @param {array} data - Array of data objects
 * @param {function} rowRenderer - Optional custom row renderer
 * @returns {string} - HTML table string
 */
function generateTable(headers, data, rowRenderer = null) {
    if (!data || data.length === 0) {
        return '<p class="text-center">No data found.</p>';
    }

    let html = '<table><thead><tr>';

    // Headers
    headers.forEach(h => {
        html += `<th>${h.label}</th>`;
    });
    html += '</tr></thead><tbody>';

    // Rows
    data.forEach(item => {
        if (rowRenderer) {
            html += rowRenderer(item);
        } else {
            html += '<tr>';
            headers.forEach(h => {
                html += `<td>${escapeHtml(String(item[h.key] || '-'))}</td>`;
            });
            html += '</tr>';
        }
    });

    html += '</tbody></table>';
    return html;
}
