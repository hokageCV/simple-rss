const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}',
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
        'transitional': ['Charter', 'Bitstream Charter', 'Sitka Text', 'Cambria', 'serif'],
      },
      colors: {
        baseBg: {
          8: '#0d2134',
          5: '#193f63',
          3: '#255d92',
        },
        sidebarBg: {
          4: '#d59455',
          6: '#905924',
          7: '#804f20',
        },
        accent: '#39a3ed',
        text: {
          1: '#c5d0de',
          2: '#a6c8e8',
          3: '#77abdd',
        },
      },
      typography: {
        rss: {
          css: {
            lineHeight: '1.6',
            fontSize: '1.25rem',
            color: '#c5d0de',
            h1: {
              margin: '3rem 0 1.75rem',
              fontSize: '2rem',
              fontWeight: '700',
            },
            h2: {
              margin: '1.5rem 0 1rem',
              fontSize: '1.75rem',
              fontWeight: '700',
            },
            h3: {
              margin: '1.5rem 0 1rem',
              fontSize: '1.75rem',
              fontWeight: '700',
            },
            h4: {
              margin: '1.5rem 0 1rem',
              fontSize: '1.75rem',
              fontWeight: '700',
            },
            h5: {
              margin: '1.5rem 0 1rem',
              fontSize: '1.75rem',
              fontWeight: '700',
            },
            h6: {
              margin: '1.5rem 0 1rem',
              fontSize: '1.75rem',
              fontWeight: '700',
            },
            p: {
              marginTop: '1.25rem',
            },
            a: {
              color: '#a6c8e8',
              textDecoration: 'underline',
              textDecorationColor: '#39a3ed',
            },
            ul: {
              paddingLeft: '1.5rem',
              marginTop: '1rem',
              listStyleType: 'disc',
            },
            'ul p': {
              marginTop: '5px',
            },
            hr: {
              marginTop: '5px',
              marginBottom: '5px',
            },
            img: {
              marginTop: '5px',
            },
            'pre': {
              backgroundColor: '#2e2a47',
              color: '#f8f8f2',
              padding: '1rem',
              borderRadius: '0.375rem',
              overflowX: 'auto',
              whiteSpace: 'pre-wrap',
              fontFamily: '"Courier New", monospace',
              fontSize: '1rem',
            },
            'blockquote': {
              padding: '1rem',
              margin: '1.25rem 0',
              borderLeft: '4px solid #39a3ed',
              color: '#a6c8e8',
              fontStyle: 'italic',
              backgroundColor: '#232c38',
              borderRadius: '0.375rem',
            },
          },
        },
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
    // require('@tailwindcss/container-queries')
  ],
}
