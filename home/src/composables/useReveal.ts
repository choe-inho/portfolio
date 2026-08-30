import { onMounted, onUnmounted, ref } from 'vue';

/**
 * Scroll-entry reveal (IntersectionObserver, never a scroll listener —
 * per the high-end-visual-design skill's performance guardrails).
 */
export function useReveal() {
  const el = ref<HTMLElement | null>(null);
  const revealed = ref(false);
  let observer: IntersectionObserver | null = null;

  onMounted(() => {
    if (!el.value) return;
    observer = new IntersectionObserver(
      (entries) => {
        for (const entry of entries) {
          if (entry.isIntersecting) {
            revealed.value = true;
            observer?.disconnect();
          }
        }
      },
      { threshold: 0.15 },
    );
    observer.observe(el.value);
  });

  onUnmounted(() => observer?.disconnect());

  return { el, revealed };
}
