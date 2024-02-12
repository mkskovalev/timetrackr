const defaultTheme = require('tailwindcss/defaultTheme');
const colors = require('tailwindcss/colors');

const colorNames = [
  'gray', 'neutral', 'red', 'orange', 'amber', 'yellow', 'lime', 'green', 'emerald',
  'teal', 'cyan', 'sky', 'blue', 'indigo', 'violet', 'purple', 'fuchsia', 'pink', 'rose'
];

const shades = [50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 950];

function generateColorClasses(type, colorNames) {
  return colorNames.flatMap(color => 
    shades.map(shade => `${type}-${color}-${shade}`)
  );
}

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}',
  ],
  safelist: [
    // Backgrounds
    ...generateColorClasses('bg', colorNames),
    ...generateColorClasses('text', colorNames),
    ...generateColorClasses('border', colorNames),
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Raleway', 'sans-serif'],
      },
      colors: {
        green: colors.emerald,
        yellow: colors.amber,
        purple: colors.violet,
        gray: colors.neutral,
      },
      minWidth: {
        '1': '0.25rem', // min-w-2 like min width 0.25rem
      },
      fontSize: {
        '2xs': '0.65rem'
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
