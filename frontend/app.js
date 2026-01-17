// ============================================
// FUSE Security Scanner - JavaScript
// ============================================

// If opened directly from disk (file://), we need an absolute API URL.
// When served via Nginx or FastAPI, same-origin relative URLs are preferred.
const DEFAULT_API_URL = 'http://localhost:8000';
const API_URL = (window.location.protocol === 'file:') ? DEFAULT_API_URL : '';
let currentScanId = null;
let statusCheckInterval = null;
let startTime = null;
let durationInterval = null;

// Storage for scans/reports
let scansData = [];

// ============================================
// Initialization
// ============================================

document.addEventListener('DOMContentLoaded', () => {
    initializeApp();
    checkBackendHealth();
    setupNavigation();
    loadScansFromStorage();
});

function initializeApp() {
    const startScanBtn = document.getElementById('start-scan-btn');
    const newScanBtn = document.getElementById('new-scan-btn');
    const clearLogsBtn = document.getElementById('clear-logs-btn');
    const downloadReportBtn = document.getElementById('download-report-btn');

    startScanBtn.addEventListener('click', startScan);
    newScanBtn.addEventListener('click', resetScan);
    clearLogsBtn.addEventListener('click', clearLogs);
    downloadReportBtn.addEventListener('click', downloadReport);

    // Allow Enter key to start scan
    document.getElementById('target-url').addEventListener('keypress', (e) => {
        if (e.key === 'Enter') startScan();
    });

    // Setup report filters
    const reportSearch = document.getElementById('report-search');
    const reportSort = document.getElementById('report-sort');
    if (reportSearch) {
        reportSearch.addEventListener('input', filterReports);
    }
    if (reportSort) {
        reportSort.addEventListener('change', filterReports);
    }
}

// ============================================
// Navigation System
// ============================================

function setupNavigation() {
    const navLinks = document.querySelectorAll('.nav-link');
    
    navLinks.forEach(link => {
        link.addEventListener('click', (e) => {
            e.preventDefault();
            const sectionId = link.getAttribute('data-section');
            showSection(sectionId);
            
            // Update active state
            navLinks.forEach(l => l.classList.remove('active'));
            link.classList.add('active');
            
            // Handle hash for browser history
            const hash = link.getAttribute('href');
            window.location.hash = hash;
        });
    });
    
    // Handle hash changes
    window.addEventListener('hashchange', () => {
        const hash = window.location.hash;
        if (hash === '#dashboard') {
            showSection('dashboard-section');
            updateDashboard();
        } else if (hash === '#reports') {
            showSection('reports-section');
            displayReports();
        } else {
            showSection('scanner-section');
        }
    });
}

function showSection(sectionId) {
    // Hide all sections
    document.getElementById('scanner-section').style.display = 'none';
    document.getElementById('dashboard-section').style.display = 'none';
    document.getElementById('reports-section').style.display = 'none';
    
    // Show selected section
    const section = document.getElementById(sectionId);
    if (section) {
        section.style.display = 'block';
    }
}

// ============================================
// Backend Health Check
// ============================================

async function checkBackendHealth() {
    const statusElement = document.getElementById('backend-status');
    const statusDot = document.querySelector('.status-dot');
    
    try {
        const response = await fetch(`${API_URL}/health`);
        if (response.ok) {
            statusElement.textContent = 'Online';
            statusDot.style.background = '#43e97b';
        } else {
            throw new Error('Backend not responding');
        }
    } catch (error) {
        statusElement.textContent = 'Offline';
        statusDot.style.background = '#f5576c';
        statusDot.style.animation = 'none';
        console.error('Backend health check failed:', error);
    }
}

// ============================================
// Scan Management
// ============================================

async function startScan() {
    const targetUrl = document.getElementById('target-url').value.trim();
    
    if (!targetUrl) {
        showNotification('Veuillez entrer une URL valide', 'error');
        return;
    }

    if (!isValidUrl(targetUrl)) {
        showNotification('Format d\'URL invalide. Utilisez http:// ou https://', 'error');
        return;
    }

    try {
        // Show progress section
        document.getElementById('progress-section').style.display = 'block';
        document.getElementById('results-section').style.display = 'none';
        
        // Reset UI
        resetProgress();
        startTime = Date.now();
        startDurationTimer();

        // Start scan
        const response = await fetch(`${API_URL}/scan`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ target_url: targetUrl })
        });

        if (!response.ok) {
            throw new Error('Échec du démarrage du scan');
        }

        const data = await response.json();
        currentScanId = data.scan_id;
        
        document.getElementById('scan-id-display').textContent = `Scan ID: ${currentScanId}`;
        addLog('Scan démarré avec succès', 'success');

        // Start polling for status
        statusCheckInterval = setInterval(checkScanStatus, 1000);

    } catch (error) {
        console.error('Error starting scan:', error);
        showNotification('Erreur lors du démarrage du scan', 'error');
        addLog(`Erreur: ${error.message}`, 'error');
    }
}

async function checkScanStatus() {
    if (!currentScanId) return;

    try {
        const response = await fetch(`${API_URL}/status/${currentScanId}`);
        if (!response.ok) {
            throw new Error('Failed to fetch status');
        }

        const data = await response.json();
        updateProgress(data);

        if (data.status === 'completed' || data.status === 'failed') {
            clearInterval(statusCheckInterval);
            clearInterval(durationInterval);
            
            if (data.status === 'completed') {
                showResults(data);
            } else {
                showNotification('Le scan a échoué', 'error');
            }
        }

    } catch (error) {
        console.error('Error checking status:', error);
    }
}

function updateProgress(data) {
    // Update step indicators
    const steps = document.querySelectorAll('.step');
    steps.forEach((step, index) => {
        const stepNumber = parseInt(step.dataset.step);
        step.classList.remove('active', 'completed');
        
        if (stepNumber < data.step) {
            step.classList.add('completed');
        } else if (stepNumber === data.step) {
            step.classList.add('active');
        }
    });

    // Update progress bar
    const progress = ((data.step + 1) / 6) * 100;
    document.getElementById('progress-fill').style.width = `${progress}%`;
    document.getElementById('progress-percent').textContent = `${Math.round(progress)}%`;

    // Update statistics
    document.getElementById('vulns-count').textContent = data.vulns || 0;
    document.getElementById('logs-count').textContent = data.logs?.length || 0;
    
    const openPorts = data.results?.open_ports || [];
    document.getElementById('ports-count').textContent = openPorts.length;

    // Update logs
    if (data.logs && data.logs.length > 0) {
        const lastLog = data.logs[data.logs.length - 1];
        const existingLogs = Array.from(document.querySelectorAll('.log-entry')).map(
            el => el.textContent
        );
        
        if (!existingLogs.includes(lastLog)) {
            addLog(lastLog);
        }
    }
}

// ============================================
// Results Display
// ============================================

function showResults(data) {
    document.getElementById('progress-section').style.display = 'none';
    document.getElementById('results-section').style.display = 'block';

    // Save to storage
    saveScanToStorage(data);

    // Security Status
    const vulns = data.vulns || 0;
    let statusText = '';
    let statusClass = '';
    
    if (vulns === 0) {
        statusText = '✓ Sécurité Optimale';
        statusClass = 'success';
    } else if (vulns <= 3) {
        statusText = '⚠ Risque Modéré';
        statusClass = 'warning';
    } else {
        statusText = '✗ Risque Élevé';
        statusClass = 'critical';
    }
    
    document.getElementById('security-status').textContent = statusText;
    document.getElementById('security-status').className = statusClass;

    // Server Info
    const headers = data.results?.headers || {};
    const server = headers.Server || 'Serveur non identifié';
    document.getElementById('server-info').textContent = server;

    // Open Ports
    const openPorts = data.results?.open_ports || [];
    const portsContainer = document.getElementById('ports-list');
    portsContainer.innerHTML = '';
    
    if (openPorts.length > 0) {
        openPorts.forEach(port => {
            const badge = document.createElement('div');
            badge.className = 'port-badge';
            badge.innerHTML = `<i class="fas fa-network-wired"></i> Port ${port}`;
            portsContainer.appendChild(badge);
        });
    } else {
        portsContainer.innerHTML = '<p style="color: var(--text-secondary);">Aucun port ouvert détecté</p>';
    }

    // Security Headers
    const headersContainer = document.getElementById('headers-list');
    headersContainer.innerHTML = '';
    
    const securityHeaders = [
        'X-Frame-Options',
        'X-XSS-Protection',
        'Content-Security-Policy',
        'Strict-Transport-Security',
        'X-Content-Type-Options'
    ];

    securityHeaders.forEach(header => {
        const badge = document.createElement('div');
        const isPresent = headers[header] !== undefined;
        badge.className = `header-badge ${isPresent ? 'present' : 'missing'}`;
        badge.innerHTML = `
            <i class="fas ${isPresent ? 'fa-check-circle' : 'fa-times-circle'}"></i>
            ${header}
        `;
        headersContainer.appendChild(badge);
    });

    // AI Report
    const aiReport = data.results?.ai_report || 'Rapport IA non disponible';
    const reportContainer = document.getElementById('ai-report');
    reportContainer.innerHTML = marked.parse ? marked.parse(aiReport) : aiReport;

    showNotification('Scan terminé avec succès!', 'success');
}

// ============================================
// UI Helpers
// ============================================

function addLog(message, type = 'info') {
    const logsContainer = document.getElementById('logs-container');
    const logEntry = document.createElement('div');
    logEntry.className = `log-entry ${type}`;
    
    const timestamp = new Date().toLocaleTimeString('fr-FR');
    logEntry.innerHTML = `
        <span class="log-timestamp">[${timestamp}]</span>
        <span class="log-message">${escapeHtml(message)}</span>
    `;
    
    logsContainer.appendChild(logEntry);
    logsContainer.scrollTop = logsContainer.scrollHeight;
}

function clearLogs() {
    document.getElementById('logs-container').innerHTML = '';
    addLog('Logs effacés', 'info');
}

function resetProgress() {
    // Reset steps
    document.querySelectorAll('.step').forEach(step => {
        step.classList.remove('active', 'completed');
    });
    
    // Reset progress bar
    document.getElementById('progress-fill').style.width = '0%';
    document.getElementById('progress-percent').textContent = '0%';
    
    // Reset stats
    document.getElementById('vulns-count').textContent = '0';
    document.getElementById('ports-count').textContent = '0';
    document.getElementById('duration').textContent = '0s';
    document.getElementById('logs-count').textContent = '0';
    
    // Clear logs
    document.getElementById('logs-container').innerHTML = '';
}

function resetScan() {
    if (statusCheckInterval) {
        clearInterval(statusCheckInterval);
    }
    if (durationInterval) {
        clearInterval(durationInterval);
    }
    
    currentScanId = null;
    startTime = null;
    
    document.getElementById('progress-section').style.display = 'none';
    document.getElementById('results-section').style.display = 'none';
    document.getElementById('target-url').value = '';
    
    showNotification('Prêt pour un nouveau scan', 'info');
}

function startDurationTimer() {
    durationInterval = setInterval(() => {
        if (startTime) {
            const elapsed = Math.floor((Date.now() - startTime) / 1000);
            document.getElementById('duration').textContent = `${elapsed}s`;
        }
    }, 1000);
}

function downloadReport() {
    if (!currentScanId) return;
    
    const aiReport = document.getElementById('ai-report').textContent;
    const blob = new Blob([aiReport], { type: 'text/markdown' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `security-report-${currentScanId}.md`;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
    
    showNotification('Rapport téléchargé', 'success');
}

function showNotification(message, type = 'info') {
    // Simple notification implementation
    console.log(`[${type.toUpperCase()}] ${message}`);
    addLog(message, type);
}

// ============================================
// Utility Functions
// ============================================

function isValidUrl(string) {
    try {
        const url = new URL(string);
        return url.protocol === 'http:' || url.protocol === 'https:';
    } catch {
        return false;
    }
}

function escapeHtml(text) {
    const map = {
        '&': '&amp;',
        '<': '&lt;',
        '>': '&gt;',
        '"': '&quot;',
        "'": '&#039;'
    };
    return text.replace(/[&<>"']/g, m => map[m]);
}

// Simple markdown parser fallback
const marked = {
    parse: (text) => {
        return text
            .replace(/^### (.*$)/gim, '<h3>$1</h3>')
            .replace(/^## (.*$)/gim, '<h2>$1</h2>')
            .replace(/^# (.*$)/gim, '<h1>$1</h1>')
            .replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>')
            .replace(/\*(.*?)\*/g, '<em>$1</em>')
            .replace(/\n/g, '<br>');
    }
};

// ============================================
// Dashboard Functions
// ============================================

function updateDashboard() {
    // Calculate stats
    const totalScans = scansData.length;
    const secureTargets = scansData.filter(s => s.vulns === 0).length;
    const atRiskTargets = scansData.filter(s => s.vulns > 0).length;
    const totalVulns = scansData.reduce((sum, s) => sum + (s.vulns || 0), 0);
    
    // Update stats display
    document.getElementById('total-scans').textContent = totalScans;
    document.getElementById('secure-targets').textContent = secureTargets;
    document.getElementById('at-risk-targets').textContent = atRiskTargets;
    document.getElementById('total-vulns').textContent = totalVulns;
    
    // Display recent scans
    displayRecentScans();
}

function displayRecentScans() {
    const table = document.getElementById('recent-scans-table');
    
    if (scansData.length === 0) {
        table.innerHTML = '<div class="scans-table-empty"><i class="fas fa-inbox"></i><p>Aucun scan enregistré</p></div>';
        return;
    }
    
    // Sort by date (most recent first)
    const sorted = [...scansData].sort((a, b) => new Date(b.date) - new Date(a.date));
    
    let html = '<div class="scans-table-row header">' +
        '<div>Cible</div>' +
        '<div>Date</div>' +
        '<div>Statut</div>' +
        '<div>Vulns</div>' +
        '<div>Action</div>' +
        '</div>';
    
    sorted.forEach(scan => {
        const statusClass = scan.vulns === 0 ? 'success' : (scan.vulns <= 3 ? 'warning' : 'danger');
        const date = new Date(scan.date).toLocaleDateString('fr-FR');
        
        html += `<div class="scans-table-row">
            <div class="scans-table-cell target">${escapeHtml(scan.target_url)}</div>
            <div class="scans-table-cell">${date}</div>
            <div class="scans-table-cell status ${statusClass}">${scan.vulns === 0 ? '✓ OK' : '⚠ RISK'}</div>
            <div class="scans-table-cell vulns">${scan.vulns}</div>
            <div class="scans-table-cell">
                <button class="report-btn" onclick="viewScanReport('${scan.scan_id}')">
                    <i class="fas fa-file-pdf"></i> Voir
                </button>
            </div>
        </div>`;
    });
    
    table.innerHTML = html;
}

// ============================================
// Reports Functions
// ============================================

function displayReports() {
    filterReports();
}

function filterReports() {
    const searchTerm = document.getElementById('report-search')?.value.toLowerCase() || '';
    const sortBy = document.getElementById('report-sort')?.value || 'recent';
    
    let filtered = scansData.filter(scan => 
        scan.target_url.toLowerCase().includes(searchTerm) ||
        (scan.ai_report && scan.ai_report.toLowerCase().includes(searchTerm))
    );
    
    // Sort
    filtered.sort((a, b) => {
        switch(sortBy) {
            case 'oldest':
                return new Date(a.date) - new Date(b.date);
            case 'target':
                return a.target_url.localeCompare(b.target_url);
            case 'vulns':
                return (b.vulns || 0) - (a.vulns || 0);
            case 'recent':
            default:
                return new Date(b.date) - new Date(a.date);
        }
    });
    
    renderReports(filtered);
}

function renderReports(reports) {
    const list = document.getElementById('reports-list');
    
    if (reports.length === 0) {
        list.innerHTML = '<div class="reports-empty"><i class="fas fa-search"></i><p>Aucun rapport trouvé</p></div>';
        return;
    }
    
    list.innerHTML = reports.map((report, index) => {
        const date = new Date(report.date).toLocaleDateString('fr-FR', { 
            year: 'numeric', 
            month: 'long', 
            day: 'numeric' 
        });
        const preview = (report.ai_report || '').substring(0, 150) + '...';
        const statusClass = report.vulns === 0 ? 'success' : (report.vulns <= 3 ? 'warning' : 'danger');
        
        // Find the actual index in scansData for modal opening
        const actualIndex = scansData.findIndex(s => s.scan_id === report.scan_id);
        
        return `
            <div class="report-card">
                <div class="report-header">
                    <div class="report-target"><i class="fas fa-globe"></i> ${escapeHtml(report.target_url)}</div>
                    <div class="report-date"><i class="fas fa-calendar"></i> ${date}</div>
                </div>
                <div class="report-stats">
                    <div class="report-stat">
                        <div class="report-stat-value">${report.vulns || 0}</div>
                        <div class="report-stat-label">Vulnérabilités</div>
                    </div>
                    <div class="report-stat">
                        <div class="report-stat-value">${(report.open_ports || []).length}</div>
                        <div class="report-stat-label">Ports</div>
                    </div>
                </div>
                <div class="report-preview">${escapeHtml(preview)}</div>
                <div class="report-actions">
                    <button class="report-btn" onclick="openReportModal(${actualIndex})">
                        <i class="fas fa-eye"></i> Voir Complet
                    </button>
                    <button class="report-btn" onclick="downloadScanReport('${report.scan_id}', '${escapeHtml(report.target_url)}')">
                        <i class="fas fa-download"></i> Télécharger
                    </button>
                </div>
            </div>
        `;
    }).join('');
}

function viewScanReport(scanId) {
    const scanIndex = scansData.findIndex(s => s.scan_id === scanId);
    if (scanIndex !== -1) {
        openReportModal(scanIndex);
    }
}

function downloadScanReport(scanId, target) {
    const scan = scansData.find(s => s.scan_id === scanId);
    if (scan && scan.ai_report) {
        const blob = new Blob([scan.ai_report], { type: 'text/markdown' });
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = `security-report-${target.replace(/[^a-z0-9]/gi, '-')}.md`;
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        URL.revokeObjectURL(url);
    }
}

// ============================================
// Local Storage Functions
// ============================================

function loadScansFromStorage() {
    const stored = localStorage.getItem('scansData');
    if (stored) {
        try {
            scansData = JSON.parse(stored);
        } catch (e) {
            console.error('Failed to load scans from storage:', e);
            scansData = [];
        }
    }
}

function saveScanToStorage(scanData) {
    scansData.push({
        scan_id: currentScanId,
        target_url: scanData.target_url || '',
        date: new Date().toISOString(),
        vulns: scanData.vulns || 0,
        open_ports: scanData.results?.open_ports || [],
        ai_report: scanData.results?.ai_report || ''
    });
    
    localStorage.setItem('scansData', JSON.stringify(scansData));
}
// ============================================
// Modal Functions
// ============================================

function openReportModal(scanIndex) {
    const scan = scansData[scanIndex];
    if (!scan) return;

    const modal = document.getElementById('report-modal');
    const overlay = document.getElementById('modal-overlay');
    const title = document.getElementById('modal-report-title');
    const content = document.getElementById('modal-report-content');
    const downloadBtn = document.getElementById('modal-download-btn');

    // Set title with date
    const scanDate = new Date(scan.date).toLocaleDateString('fr-FR', {
        year: 'numeric',
        month: 'long',
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
    });
    title.textContent = `Rapport Complet - ${scan.target_url} (${scanDate})`;

    // Set content
    if (scan.ai_report) {
        content.textContent = scan.ai_report;
    } else {
        content.textContent = 'Aucun rapport disponible pour ce scan.';
    }

    // Set download button action
    downloadBtn.onclick = () => downloadReportModal(scan);

    // Show modal
    modal.style.display = 'flex';
    overlay.style.display = 'block';

    // Close button handlers
    const closeBtn = document.getElementById('modal-close-btn');
    const closeBtn2 = document.getElementById('modal-close-btn2');
    
    closeBtn.onclick = closeReportModal;
    closeBtn2.onclick = closeReportModal;
}

function closeReportModal() {
    const modal = document.getElementById('report-modal');
    const overlay = document.getElementById('modal-overlay');
    
    modal.style.display = 'none';
    overlay.style.display = 'none';
}

function downloadReportModal(scan) {
    const element = document.createElement('a');
    const file = new Blob([scan.ai_report], {type: 'text/plain'});
    element.href = URL.createObjectURL(file);
    element.download = `rapport_${scan.target_url.replace(/[^a-z0-9]/gi, '_')}_${new Date(scan.date).getTime()}.txt`;
    document.body.appendChild(element);
    element.click();
    document.body.removeChild(element);
}

// Close modal when clicking overlay
document.addEventListener('DOMContentLoaded', () => {
    const overlay = document.getElementById('modal-overlay');
    if (overlay) {
        overlay.addEventListener('click', closeReportModal);
    }
});