# WickedPDF Global Configuration
WickedPdf.config = {
  # Path to the wkhtmltopdf executable: This will be populated automatically by the
  # wkhtmltopdf-binary gem. You can also specify a custom path if needed.
  # exe_path: '/usr/local/bin/wkhtmltopdf',
  
  # Layout file to be used for all PDFs
  # (but can be overridden in your controller)
  layout: "pdf.html",

  # Orientation: 'Portrait' or 'Landscape'
  orientation: "Portrait",

  # Page size: A4, Letter, etc.
  page_size: "A4",

  # Margin (in mm)
  margin: {
    top: 10,
    bottom: 10,
    left: 10,
    right: 10
  },

  # Enable/disable JavaScript
  enable_javascript: true,

  # JavaScript delay (in seconds)
  javascript_delay: 1,

  # Window status to wait for before rendering
  window_status: "ready",

  # Print background graphics
  print_media_type: true,

  # Enable/disable smart shrinking
  disable_smart_shrinking: false,

  # Zoom factor
  zoom: 1,

  # DPI
  dpi: 300,

  # Enable/disable forms
  enable_forms: true,

  # Enable/disable external links
  enable_external_links: true,

  # Enable/disable internal links
  enable_internal_links: true,

  # Enable/disable local file access
  enable_local_file_access: true,

  # Encoding
  encoding: "UTF-8",

  # User style sheet
  user_style_sheet: nil,

  # Viewport size
  viewport_size: "1024x768"
}
