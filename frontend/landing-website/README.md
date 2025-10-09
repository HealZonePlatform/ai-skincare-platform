# AI Skincare Platform Landing Page

A modern, responsive landing page for the AI Skincare Platform built with Next.js 14, TypeScript, Tailwind CSS, and Framer Motion.

## Features

- Responsive design with mobile-first approach
- Animated components using Framer Motion
- SEO optimized with proper metadata
- Contact form integration with Formspree
- Modern UI with Tailwind CSS
- Performance optimized for fast loading
- GitHub Pages deployment ready

## Tech Stack

- Next.js 14 (App Router)
- TypeScript
- Tailwind CSS
- Framer Motion (Animations)
- Headless UI (Mobile navigation)
- Heroicons (Icons)
- Formspree (Contact form)

## Getting Started

### Prerequisites

- Node.js 18 or higher
- npm or yarn

### Installation

1. Clone the repository
2. Navigate to the project directory
3. Install dependencies:

```bash
npm install
```

### Development

To run the development server:

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) with your browser to see the result.

### Build

To build the application for production:

```bash
npm run build
```

### Export for Static Deployment

To generate a static export (for GitHub Pages, Netlify, etc.):

```bash
npm run build && npm run export
```

## Deployment
### GitHub Pages

This project is configured for GitHub Pages deployment. The workflow is set up in `.github/workflows/deploy-landing.yml`.


To deploy:

1. Push your changes to the `main` branch
2. The GitHub Action will automatically build and deploy your site

The site will be available at `https://<your-username>.github.io/<repository-name>`

### Environment Configuration

For GitHub Pages deployment, the `next.config.js` is already configured with:
- `output: 'export'` for static export
- `basePath` and `assetPrefix` for subdirectory deployment

## Project Structure

```
src/
├── app/                 # Next.js 14 App Router
│   ├── layout.tsx       # Root layout with metadata
│   └── page.tsx         # Home page
├── components/          # Reusable UI components
│   ├── Header.tsx
│   ├── Hero.tsx
│   ├── Features.tsx
│   ├── HowItWorks.tsx
│   ├── Testimonials.tsx
│   ├── CallToAction.tsx
│   └── Contact.tsx
└── app/
    ├── globals.css      # Global styles
    └── layout.tsx       # Root layout
```

## Customization

### Colors

Color palette can be customized in `tailwind.config.js` under the `extend.colors` section.

### Content

All content can be modified in the respective component files in the `src/components/` directory.

### Contact Form

To use the contact form with Formspree:

1. Create an account at [formspree.io](https://formspree.io)
2. Create a new form and get the endpoint URL
3. Replace the placeholder form action in `Contact.tsx`

## Performance

- Images are optimized for fast loading
- CSS is purged in production
- JavaScript is minified
- Responsive images with proper sizing
- Lazy loading for off-screen content

## Accessibility

- Semantic HTML structure
- Proper ARIA attributes
- Keyboard navigation support
- Screen reader friendly
- Sufficient color contrast

## License

This project is licensed under the MIT License.