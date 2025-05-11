document.addEventListener('DOMContentLoaded', function() {
  const statusPage = document.querySelector('[data-stripe-account-status]');
  if (!statusPage) return;

  // Poll for status updates when account is being set up
  if (document.querySelector('[data-status-polling]')) {
    pollAccountStatus();
  }

  // Handle refresh button clicks
  const refreshButton = document.querySelector('[data-refresh-account]');
  if (refreshButton) {
    refreshButton.addEventListener('click', handleRefresh);
  }

  // Automatically check requirements status
  const requirementsSection = document.querySelector('[data-requirements-section]');
  if (requirementsSection) {
    checkRequirements();
  }

  async function pollAccountStatus() {
    try {
      const response = await fetch('/stripe_accounts/status', {
        headers: {
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest'
        }
      });

      if (!response.ok) throw new Error('Failed to fetch status');

      const data = await response.json();
      updateStatusDisplay(data);

      // Continue polling if account is not fully set up
      if (!data.charges_enabled || !data.payouts_enabled) {
        setTimeout(pollAccountStatus, 5000); // Poll every 5 seconds
      } else {
        window.location.reload(); // Refresh page when setup is complete
      }
    } catch (error) {
      console.error('Error polling account status:', error);
    }
  }

  async function handleRefresh(event) {
    event.preventDefault();
    const button = event.currentTarget;
    
    try {
      button.disabled = true;
      button.innerHTML = `
        <svg class="animate-spin h-5 w-5 mr-2" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
          <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
          <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
        </svg>
        Refreshing...
      `;

      const response = await fetch(button.href, {
        headers: {
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest'
        }
      });

      if (!response.ok) throw new Error('Failed to refresh account');

      const data = await response.json();
      if (data.redirect_url) {
        window.location.href = data.redirect_url;
      } else {
        updateStatusDisplay(data);
      }
    } catch (error) {
      console.error('Error refreshing account:', error);
      showError('Failed to refresh account status. Please try again.');
    } finally {
      button.disabled = false;
      button.textContent = 'Refresh Status';
    }
  }

  async function checkRequirements() {
    try {
      const response = await fetch('/stripe_accounts/status', {
        headers: {
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest'
        }
      });

      if (!response.ok) throw new Error('Failed to fetch requirements');

      const data = await response.json();
      updateRequirementsDisplay(data.requirements);
    } catch (error) {
      console.error('Error checking requirements:', error);
    }
  }

  function updateStatusDisplay(status) {
    const statusIndicators = {
      details_submitted: document.querySelector('[data-status-details]'),
      charges_enabled: document.querySelector('[data-status-charges]'),
      payouts_enabled: document.querySelector('[data-status-payouts]')
    };

    Object.entries(statusIndicators).forEach(([key, element]) => {
      if (element) {
        const isComplete = status[key];
        element.innerHTML = getStatusIcon(isComplete);
        element.classList.toggle('text-green-500', isComplete);
        element.classList.toggle('text-yellow-500', !isComplete);
      }
    });

    // Update overall status message
    const statusMessage = document.querySelector('[data-status-message]');
    if (statusMessage) {
      statusMessage.textContent = getStatusMessage(status);
      updateStatusMessageStyle(statusMessage, status);
    }
  }

  function updateRequirementsDisplay(requirements) {
    const requirementsList = document.querySelector('[data-requirements-list]');
    if (!requirementsList || !requirements) return;

    if (requirements.currently_due?.length > 0) {
      const items = requirements.currently_due.map(req => `
        <li class="flex items-center text-sm text-gray-700">
          <svg class="h-5 w-5 text-yellow-500 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/>
          </svg>
          ${req.replace(/_/g, ' ').replace(/\b\w/g, l => l.toUpperCase())}
        </li>
      `).join('');
      requirementsList.innerHTML = items;
    } else {
      requirementsList.innerHTML = `
        <li class="flex items-center text-sm text-green-700">
          <svg class="h-5 w-5 text-green-500 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
          </svg>
          All requirements completed
        </li>
      `;
    }
  }

  function getStatusIcon(isComplete) {
    return isComplete
      ? `<svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
           <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
         </svg>`
      : `<svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
           <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/>
         </svg>`;
  }

  function getStatusMessage(status) {
    if (status.charges_enabled && status.payouts_enabled) {
      return 'Your account is fully set up and ready to receive payments.';
    } else if (status.details_submitted) {
      return 'Your account is connected but requires additional information before you can receive payments.';
    } else {
      return 'Please complete your account setup to start receiving payments.';
    }
  }

  function updateStatusMessageStyle(element, status) {
    element.classList.remove('text-green-700', 'text-yellow-700', 'text-red-700');
    if (status.charges_enabled && status.payouts_enabled) {
      element.classList.add('text-green-700');
    } else if (status.details_submitted) {
      element.classList.add('text-yellow-700');
    } else {
      element.classList.add('text-red-700');
    }
  }

  function showError(message) {
    const errorContainer = document.querySelector('[data-error-container]');
    if (errorContainer) {
      errorContainer.textContent = message;
      errorContainer.classList.remove('hidden');
      setTimeout(() => {
        errorContainer.classList.add('hidden');
      }, 5000);
    }
  }
});
