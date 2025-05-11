document.addEventListener('DOMContentLoaded', function() {
  const paymentForm = document.getElementById('payment-form');
  if (!paymentForm) return;

  // Initialize Stripe
  const stripe = Stripe(document.querySelector('meta[name="stripe-key"]').content);
  const elements = stripe.elements();

  // Create card element
  const cardElement = elements.create('card', {
    style: {
      base: {
        fontSize: '16px',
        color: '#32325d',
        fontFamily: '"Inter", -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif',
        fontSmoothing: 'antialiased',
        '::placeholder': {
          color: '#aab7c4'
        }
      },
      invalid: {
        color: '#fa755a',
        iconColor: '#fa755a'
      }
    }
  });

  // Mount card element
  cardElement.mount('#card-element');

  // Handle validation errors
  cardElement.on('change', function(event) {
    const displayError = document.getElementById('card-errors');
    if (event.error) {
      displayError.textContent = event.error.message;
      displayError.classList.remove('hidden');
    } else {
      displayError.textContent = '';
      displayError.classList.add('hidden');
    }
  });

  // Handle form submission
  paymentForm.addEventListener('submit', async function(event) {
    event.preventDefault();

    const submitButton = paymentForm.querySelector('button[type="submit"]');
    const originalButtonText = submitButton.textContent;
    
    // Disable form and show loading state
    setLoading(true);

    try {
      // Create payment intent on the server
      const response = await fetch(paymentForm.action, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
        },
        body: JSON.stringify({
          payment: {
            course_id: document.getElementById('course_id').value,
            amount: document.getElementById('payment_amount').value
          }
        })
      });

      const result = await response.json();

      if (result.error) {
        handleError(result.error);
        return;
      }

      // Confirm card payment
      const { paymentIntent, error } = await stripe.confirmCardPayment(result.clientSecret, {
        payment_method: {
          card: cardElement,
          billing_details: {
            name: document.getElementById('card_holder_name')?.value
          }
        }
      });

      if (error) {
        handleError(error.message);
      } else if (paymentIntent.status === 'succeeded') {
        // Payment successful - redirect to success page
        window.location.href = `/payments/${result.payment_id}`;
      }
    } catch (error) {
      handleError('An unexpected error occurred. Please try again.');
    }

    setLoading(false);
    submitButton.textContent = originalButtonText;
  });

  function setLoading(isLoading) {
    const submitButton = paymentForm.querySelector('button[type="submit"]');
    const spinner = submitButton.querySelector('.spinner');
    const buttonText = submitButton.querySelector('.button-text');

    if (isLoading) {
      submitButton.disabled = true;
      spinner?.classList.remove('hidden');
      buttonText.textContent = 'Processing...';
    } else {
      submitButton.disabled = false;
      spinner?.classList.add('hidden');
      buttonText.textContent = 'Pay Now';
    }
  }

  function handleError(message) {
    const errorElement = document.getElementById('card-errors');
    errorElement.textContent = message;
    errorElement.classList.remove('hidden');
    setLoading(false);

    // Scroll error into view
    errorElement.scrollIntoView({ behavior: 'smooth', block: 'center' });
  }
});
