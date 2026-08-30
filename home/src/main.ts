import { ViteSSG } from 'vite-ssg';
import App from './App.vue';
import './style.css';

export const createApp = ViteSSG(App, { routes: [] });
