# Pin npm packages by running ./bin/importmap

# Core Rails libraries
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true

# Stimulus controllers
pin_all_from "app/javascript/controllers", under: "controllers"

# Application JavaScript
pin "application", preload: true

# Stripe integration
pin "stripe_elements", to: "stripe_elements.js", preload: true
pin "stripe_account", to: "stripe_account.js", preload: true

# Third-party libraries
pin "stripe", to: "https://js.stripe.com/v3/", preload: true
