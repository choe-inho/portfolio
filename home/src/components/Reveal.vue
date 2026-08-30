<script setup lang="ts">
import { useReveal } from '../composables/useReveal';

withDefaults(defineProps<{ delay?: number }>(), { delay: 0 });
const { el, revealed } = useReveal();
</script>

<template>
  <div
    ref="el"
    class="transition-all duration-[900ms] ease-[cubic-bezier(0.32,0.72,0,1)]"
    :class="revealed ? 'opacity-100 translate-y-0 blur-0' : 'opacity-0 translate-y-10 blur-sm'"
    :style="{ transitionDelay: `${delay}ms` }"
  >
    <slot />
  </div>
</template>
