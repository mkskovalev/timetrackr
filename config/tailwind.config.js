const defaultTheme = require('tailwindcss/defaultTheme');
const colors = require('tailwindcss/colors');

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}',
  ],
  safelist: [
    // Backgrounds
    ...generateBgColorClasses('bg', 'gray'),
    ...generateBgColorClasses('bg', 'red'),
    ...generateBgColorClasses('bg', 'orange'),
    ...generateBgColorClasses('bg', 'amber'),
    ...generateBgColorClasses('bg', 'yellow'),
    ...generateBgColorClasses('bg', 'lime'),
    ...generateBgColorClasses('bg', 'green'),
    ...generateBgColorClasses('bg', 'emerald'),
    ...generateBgColorClasses('bg', 'teal'),
    ...generateBgColorClasses('bg', 'cyan'),
    ...generateBgColorClasses('bg', 'sky'),
    ...generateBgColorClasses('bg', 'blue'),
    ...generateBgColorClasses('bg', 'indigo'),
    ...generateBgColorClasses('bg', 'violet'),
    ...generateBgColorClasses('bg', 'purple'),
    ...generateBgColorClasses('bg', 'fuchsia'),
    ...generateBgColorClasses('bg', 'pink'),
    ...generateBgColorClasses('bg', 'rose'),
    ...generateBgColorClasses('text', 'gray'),
    ...generateBgColorClasses('text', 'red'),
    ...generateBgColorClasses('text', 'orange'),
    ...generateBgColorClasses('text', 'amber'),
    ...generateBgColorClasses('text', 'yellow'),
    ...generateBgColorClasses('text', 'lime'),
    ...generateBgColorClasses('text', 'green'),
    ...generateBgColorClasses('text', 'emerald'),
    ...generateBgColorClasses('text', 'teal'),
    ...generateBgColorClasses('text', 'cyan'),
    ...generateBgColorClasses('text', 'sky'),
    ...generateBgColorClasses('text', 'blue'),
    ...generateBgColorClasses('text', 'indigo'),
    ...generateBgColorClasses('text', 'violet'),
    ...generateBgColorClasses('text', 'purple'),
    ...generateBgColorClasses('text', 'fuchsia'),
    ...generateBgColorClasses('text', 'pink'),
    ...generateBgColorClasses('text', 'rose'),
    'bg-neutral-50',
    'bg-neutral-100',
    'bg-neutral-200',
    'bg-neutral-300',
    'bg-neutral-400',
    'bg-neutral-500',
    'bg-neutral-600',
    'bg-neutral-700',
    'bg-neutral-800',
    'bg-neutral-900',
    'bg-neutral-950',
    // Text colors
    'text-green-500',
    'text-red-500',
    'text-gray-500',
    'text-green-800',
    'text-red-800',
    'text-gray-800',
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
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

function generateBgColorClasses(type, color) {
  return [50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 950].map(shade => `${type}-${color}-${shade}`);
}