<script setup lang="ts">
import { useTilt } from '../composables/useTilt';

withDefaults(defineProps<{ as?: string; tilt?: boolean }>(), { as: 'div', tilt: true });
const { rotateX, rotateY, scale, onMouseMove, onMouseLeave } = useTilt(8);
</script>

<template>
  <!-- Double-Bezel: outer glass shell + inner core with its own highlight -->
  <component
    :is="as"
    class="rounded-[2rem] border border-white/10 bg-white/5 p-1.5"
    :style="
      tilt
        ? {
            transform: `perspective(900px) rotateX(${rotateX}deg) rotateY(${rotateY}deg) scale(${scale})`,
            transition: 'transform 250ms cubic-bezier(0.32,0.72,0,1)',
            transformStyle: 'preserve-3d',
          }
        : undefined
    "
    @mousemove="tilt ? onMouseMove($event) : undefined"
    @mouseleave="tilt ? onMouseLeave() : undefined"
  >
    <div
      class="relative h-full rounded-[calc(2rem-0.375rem)] border border-white/10 bg-[#0d0d0f] p-6 shadow-[0_12px_40px_rgba(0,0,0,0.35)] before:pointer-events-none before:absolute before:inset-0 before:rounded-[calc(2rem-0.375rem)] before:border-t before:border-white/15 before:content-['']"
    >
      <slot />
    </div>
  </component>
</template>
