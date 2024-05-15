<script setup>
import { ref } from 'vue'
import BorderLine from './BorderLine.vue'
import WeatherForecastDay from './WeatherForecastDay.vue'
import WeatherInfo from './WeatherInfo.vue'

defineProps({
    place: Object
})

const emit = defineEmits(['delete-place'])

const showDetail = ref(false)

const removePlace = (placeName) => {
    emit('delete-place', placeName)
    showDetail.value = false
}

const formatTime = (time) => {
    const date = new Date(time)
    const hours = date.getHours().toString().padStart(2, '0')
    const minutes = date.getMinutes().toString().padStart(2, '0')
    return `${hours}:${minutes}`
}
</script>

<template>
    <div :class="place.current.is_day === 1 ? 'bg-day' : 'bg-night'"
        class="text-white p-10 rounded-lg shadow-lg gap-6 mb-6 relative overflow-hidden bg-blue-500">
        <!-- Location & time -->
        <div class="mb-2 flex justify-between items-center">
            <div class="flex items-center justify-center gap-2">
                <i class="fa-solid fa-location-dot"></i>
                <h1 class="text-3xl">{{ place.location.name }}</h1>
            </div>
            <div class="flex items-center justify-center gap-2">
                <i class="fa-solid fa-clock"></i>
                <h1 class="text-3xl">
                    {{ formatTime(place.location.localtime) }}

                </h1>
            </div>
        </div>

        <!-- current weather -->
        <div class="text-center flex-1">
            <img :src="place.current.condition.icon" alt="icon" width="200" class="mx-auto -mb-10" />
            <h1 class="text-9xl mb-2 -mr-4">{{ Math.round(place.current.temp_c) }}&deg;</h1>
            <p class="text-2xl">{{ place.current.condition.text }}</p>
        </div>

        <BorderLine />

        <!-- forecast -->
        <div v-for="(day, idx) in place.forecast.forecastday" :key="idx">
            <WeatherForecastDay :day="day" />
        </div>

        <!-- info -->
        <Transition name="fade">
            <div v-show="showDetail">
                <WeatherInfo :place="place" @close-info="showDetail = false"
                    @remove-place="removePlace(place.location.name)" />
            </div>
        </Transition>
        <!-- forecast btn -->
        <div class="flex justify-end items-center gap-1 mt-10">
            <button @click="showDetail = true">
                Mehr... <i class="fa-solid fa-arrow-right text-sm -mb-px"></i>
            </button>
        </div>
    </div>
</template>

<style scoped>
/* Tag und Nacht Gradient */
.bg-day {
    background-color: #8ec5fc;
    background-image: linear-gradient(62deg, #8ec5fc 0%, #e0c3fc 100%);
}

.bg-night {
    background-color: #07223d;
    background-image: linear-gradient(62deg, #0a2a4a 0%, #270845 100%);
}

/* Overlay Fade */

.fade-enter-active,
.fade-leave active {
    transition: opacity 0.5s ease;
}

.fade-enter-from,
.fade-leave-to {
    transition: 0.5s ease;
    opacity: 0;
}
</style>