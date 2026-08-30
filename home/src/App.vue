<script setup lang="ts">
import { onMounted, onUnmounted, ref } from 'vue';
import Reveal from './components/Reveal.vue';
import GlassCard from './components/GlassCard.vue';
import PillButton from './components/PillButton.vue';
import EyebrowTag from './components/EyebrowTag.vue';

const APP_URL = '/portfolio/app/';

// Cursor-tracking spotlight glow (client-only; onMounted never runs during SSG).
const glowX = ref(0);
const glowY = ref(0);
const glowVisible = ref(false);

function handlePointerMove(e: PointerEvent) {
  glowX.value = e.clientX;
  glowY.value = e.clientY;
  glowVisible.value = true;
}

onMounted(() => window.addEventListener('pointermove', handlePointerMove));
onUnmounted(() => window.removeEventListener('pointermove', handlePointerMove));

const skills = [
  { name: 'Flutter', icon: '/portfolio/skill/flutter.png' },
  { name: 'Node', icon: '/portfolio/skill/node.png' },
  { name: 'Python', icon: '/portfolio/skill/python.png' },
  { name: 'AWS', icon: '/portfolio/skill/aws.png' },
  { name: 'Firebase', icon: '/portfolio/skill/firebase.png' },
  { name: 'REST API', icon: '/portfolio/skill/api.png' },
];

const quickLinks = [
  {
    title: 'About Me',
    desc: '저에 대해 알아보세요',
    href: `${APP_URL}#/about-me`,
    accent: 'from-emerald-400/20',
  },
  {
    title: 'Projects',
    desc: '진행한 프로젝트들',
    href: `${APP_URL}#/projects`,
    accent: 'from-blue-400/20',
  },
  {
    title: 'Contact',
    desc: '연락처 정보',
    href: `${APP_URL}#/contact`,
    accent: 'from-purple-400/20',
  },
];

const socials = [
  { label: 'GitHub', href: 'https://github.com/choe-inho' },
  { label: 'Blog', href: 'https://iconoding.tistory.com/' },
  { label: 'Email', href: 'mailto:iconoding.dev@gmail.com' },
];
</script>

<template>
  <div class="relative min-h-[100dvh] overflow-hidden bg-[#050505] text-[#f5f5f7]">
    <!-- Ethereal Glass mesh backdrop -->
    <div class="pointer-events-none fixed inset-0 z-0">
      <div class="orb-drift-a absolute -left-24 -top-32 h-[380px] w-[380px] rounded-full bg-purple-500/20 blur-[120px]" />
      <div class="orb-drift-b absolute -right-32 top-24 h-[440px] w-[440px] rounded-full bg-blue-500/20 blur-[130px]" />
      <div class="orb-drift-c absolute bottom-[-160px] left-16 h-[400px] w-[400px] rounded-full bg-emerald-500/20 blur-[130px]" />
    </div>

    <!-- Cursor-tracking spotlight -->
    <div
      v-if="glowVisible"
      class="pointer-events-none fixed z-0 h-[420px] w-[420px] rounded-full"
      :style="{
        left: `${glowX - 210}px`,
        top: `${glowY - 210}px`,
        background: 'radial-gradient(circle, rgba(16,185,129,0.14) 0%, rgba(16,185,129,0) 70%)',
        transition: 'left 80ms linear, top 80ms linear',
      }"
    />

    <!-- Fluid Island nav -->
    <header class="fixed inset-x-0 top-6 z-20 flex justify-center px-4">
      <nav
        class="flex items-center gap-2 rounded-full border border-white/10 bg-[#0d0d0f]/70 px-5 py-2.5 backdrop-blur-2xl"
      >
        <span class="pr-3 text-sm font-semibold tracking-tight">최인호</span>
        <a
          :href="APP_URL"
          class="rounded-full px-4 py-1.5 text-sm text-white/70 transition-colors hover:bg-white/10 hover:text-white"
          >포트폴리오</a
        >
      </nav>
    </header>

    <main class="relative z-10 mx-auto max-w-5xl px-6 pb-32 pt-40 md:px-10">
      <!-- Hero -->
      <Reveal>
        <EyebrowTag text="Portfolio" />
      </Reveal>
      <Reveal :delay="80">
        <h1 class="mt-6 max-w-3xl text-[2.25rem] font-extrabold leading-[1.08] tracking-tight md:text-6xl">
          사용자의 니즈를 생각하는<br />개발자 최인호입니다
        </h1>
      </Reveal>
      <Reveal :delay="160">
        <p class="mt-7 max-w-xl text-[15px] leading-relaxed text-white/60 md:text-base">
          사용자 경험을 최우선으로 생각하며, 깔끔하고 효율적인 앱을 만듭니다. 새로운 기술을 배우는 것을 즐기고,
          문제 해결에 열정을 가지고 있습니다.
        </p>
      </Reveal>
      <Reveal :delay="240">
        <div class="mt-10 flex flex-wrap gap-4">
          <PillButton :href="APP_URL" label="포트폴리오 보기" />
          <PillButton :href="`${APP_URL}#/contact`" label="연락하기" :filled="false" />
        </div>
      </Reveal>

      <!-- Asymmetrical bento: quick links -->
      <div class="mt-28 grid grid-cols-1 gap-5 md:grid-cols-3">
        <Reveal v-for="(link, i) in quickLinks" :key="link.title" :delay="i * 90" :class="i === 0 ? 'md:col-span-2' : ''">
          <a :href="link.href" class="block h-full">
            <GlassCard class="h-full">
              <div :class="`absolute inset-0 rounded-[calc(2rem-0.375rem)] bg-gradient-to-br ${link.accent} to-transparent opacity-60`" />
              <div class="relative">
                <h3 class="text-xl font-semibold">{{ link.title }}</h3>
                <p class="mt-2 text-sm text-white/55">{{ link.desc }}</p>
              </div>
            </GlassCard>
          </a>
        </Reveal>
      </div>

      <!-- Tech stack -->
      <div class="mt-28 text-center">
        <Reveal>
          <p class="text-[11px] font-semibold uppercase tracking-[0.3em] text-white/40">Tech Stack</p>
        </Reveal>
        <Reveal :delay="80">
          <div class="mt-7 flex flex-wrap justify-center gap-3">
            <span
              v-for="skill in skills"
              :key="skill.name"
              class="flex items-center gap-2.5 rounded-full border border-white/10 bg-white/5 px-4 py-2.5"
            >
              <img :src="skill.icon" :alt="skill.name" class="h-5 w-5" />
              <span class="text-sm text-white/85">{{ skill.name }}</span>
            </span>
          </div>
        </Reveal>
      </div>
    </main>

    <footer class="relative z-10 border-t border-white/10 px-6 py-14 text-center">
      <div class="flex flex-wrap justify-center gap-3">
        <a
          v-for="social in socials"
          :key="social.label"
          :href="social.href"
          target="_blank"
          rel="noopener noreferrer"
          class="rounded-full border border-white/10 bg-white/5 px-4 py-2 text-sm text-white/70 transition-colors hover:text-white"
        >
          {{ social.label }}
        </a>
      </div>
      <div class="mt-6 flex justify-center gap-6 text-sm text-white/50">
        <a :href="`${APP_URL}#/privacy`" class="underline decoration-white/20 underline-offset-4 hover:text-white/80"
          >개인정보처리방침</a
        >
        <a :href="`${APP_URL}#/terms`" class="underline decoration-white/20 underline-offset-4 hover:text-white/80"
          >이용약관</a
        >
      </div>
      <p class="mt-6 text-xs text-white/30">© {{ new Date().getFullYear() }} iconoding · Built with Vue &amp; Flutter</p>
    </footer>
  </div>
</template>
