// Configure your import map in config/importmap.rb

// Core Rails libraries
import "@hotwired/turbo-rails"
import "@hotwired/stimulus"

// Stripe integration
import "./stripe_elements"
import "./stripe_account"

// Initialize Stimulus controllers
import "controllers"

// Add meta tag for Stripe public key if on a payment page
document.addEventListener('turbo:load', () => {
  const paymentForm = document.getElementById('payment-form');
  const stripeAccountStatus = document.querySelector('[data-stripe-account-status]');
  
  if (paymentForm || stripeAccountStatus) {
    const meta = document.createElement('meta');
    meta.name = 'stripe-key';
    meta.content = document.querySelector('[data-stripe-publishable-key]')?.content || '';
    document.head.appendChild(meta);
  }
});

// Handle Turbo cache for Stripe Elements
document.addEventListener('turbo:before-cache', () => {
  // Clean up Stripe Elements before caching
  const cardElement = document.getElementById('card-element');
  if (cardElement) {
    cardElement.innerHTML = '';
  }
});

// Add CSRF token to all fetch requests
document.addEventListener('DOMContentLoaded', () => {
  const csrfToken = document.querySelector('meta[name="csrf-token"]')?.content;
  if (csrfToken) {
    window.fetch = new Proxy(window.fetch, {
      apply: function(fetch, that, args) {
        const [resource, config] = args;
        
        // Only add CSRF token for same-origin requests
        if (resource.toString().startsWith(window.location.origin)) {
          config = config || {};
          config.headers = config.headers || {};
          config.headers['X-CSRF-Token'] = csrfToken;
        }
        
        return fetch.apply(that, [resource, config]);
      }
    });
  }
});

// Handle server-side validation errors
document.addEventListener('turbo:frame-load', (event) => {
  const frame = event.target;
  const errorSummary = frame.querySelector('.error-summary');
  
  if (errorSummary) {
    errorSummary.scrollIntoView({ behavior: 'smooth', block: 'center' });
  }
});

// Add loading indicators for form submissions
document.addEventListener('turbo:submit-start', (event) => {
  const form = event.target;
  const submitButton = form.querySelector('button[type="submit"]');
  
  if (submitButton) {
    const originalText = submitButton.textContent;
    submitButton.disabled = true;
    submitButton.innerHTML = `
      <svg class="animate-spin h-5 w-5 mr-2 inline" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
      </svg>
      Processing...
    `;

    // Reset button on form submission end
    const resetButton = () => {
      submitButton.disabled = false;
      submitButton.textContent = originalText;
    };

    document.addEventListener('turbo:submit-end', resetButton, { once: true });
  }
});
