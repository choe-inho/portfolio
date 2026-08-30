<script setup lang="ts">
withDefaults(
  defineProps<{
    href: string;
    label: string;
    filled?: boolean;
    external?: boolean;
  }>(),
  { filled: true, external: false },
);
</script>

<template>
  <a
    :href="href"
    :target="external ? '_blank' : undefined"
    :rel="external ? 'noopener noreferrer' : undefined"
    class="group inline-flex items-center gap-3 rounded-full py-2 pl-6 pr-2 transition-all duration-300 ease-[cubic-bezier(0.32,0.72,0,1)] active:scale-[0.97]"
    :class="
      filled
        ? 'cta-pulse bg-[#f5f5f7] text-black hover:-translate-y-0.5'
        : 'border border-white/20 bg-white/5 text-white hover:-translate-y-0.5'
    "
  >
    <span class="text-[15px] font-semibold">{{ label }}</span>
    <span
      class="flex h-8 w-8 items-center justify-center rounded-full transition-transform duration-300 ease-[cubic-bezier(0.32,0.72,0,1)] group-hover:translate-x-0.5 group-hover:-translate-y-0.5"
      :class="filled ? 'bg-black/10' : 'bg-white/10'"
    >
      <svg width="14" height="14" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
        <path
          d="M7 17L17 7M17 7H9M17 7V15"
          :stroke="filled ? '#000' : '#fff'"
          stroke-width="2"
          stroke-linecap="round"
          stroke-linejoin="round"
        />
      </svg>
    </span>
  </a>
</template>
