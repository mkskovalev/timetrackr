const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  // Add classes here that are generated dynamically
  // Otherwise, PurgeCSS will remove them during the build process because they are not explicitly referenced.
  purge: {
    options: {
      safelist: [
        // Backgrounds
        'bg-green-100',
        'bg-red-100',
        'bg-gray-100',
        // Text colors
        'text-green-500',
        'text-red-500',
        'text-gray-500',
        'text-green-800',
        'text-red-800',
        'text-gray-800',
      ]
    },
  },
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
  ]
}
