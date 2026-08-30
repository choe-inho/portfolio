import { ref } from 'vue';

/** Pointer-reactive 3D tilt, mirroring the Flutter app's `TiltCard`. */
export function useTilt(maxTiltDeg = 10) {
  const rotateX = ref(0);
  const rotateY = ref(0);
  const scale = ref(1);

  function onMouseMove(e: MouseEvent) {
    const target = e.currentTarget as HTMLElement;
    const rect = target.getBoundingClientRect();
    const dx = (e.clientX - rect.left) / rect.width - 0.5;
    const dy = (e.clientY - rect.top) / rect.height - 0.5;
    rotateY.value = dx * maxTiltDeg * 2;
    rotateX.value = -dy * maxTiltDeg * 2;
    scale.value = 1.035;
  }

  function onMouseLeave() {
    rotateX.value = 0;
    rotateY.value = 0;
    scale.value = 1;
  }

  return { rotateX, rotateY, scale, onMouseMove, onMouseLeave };
}
