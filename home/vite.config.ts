import { defineConfig } from 'vite';
import vue from '@vitejs/plugin-vue';
import tailwindcss from '@tailwindcss/vite';

// Served at the repo's GitHub Pages project-page root (choe-inho.github.io/portfolio/),
// with the Flutter app living one level down at /portfolio/app/.
export default defineConfig({
  base: '/portfolio/',
  plugins: [vue(), tailwindcss()],
  ssgOptions: {
    script: 'async',
    formatting: 'minify',
  },
});
