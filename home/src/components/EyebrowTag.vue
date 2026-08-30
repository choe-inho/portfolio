<script setup lang="ts">
defineProps<{ text: string }>();
</script>

<template>
  <span
    class="inline-block rounded-full border border-emerald-400/30 bg-emerald-400/10 px-3.5 py-1.5 text-[11px] font-semibold uppercase tracking-[0.2em] text-emerald-400"
  >
    {{ text }}
  </span>
</template>
