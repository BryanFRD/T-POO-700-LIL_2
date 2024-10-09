<script setup>
import { TZDate } from '@date-fns/tz'
import { formatDistance, formatRelative } from 'date-fns'
import { onMounted, ref } from 'vue'
import { useRoute } from 'vue-router'
import { toast } from 'vue-sonner'

import { instance } from '../../api/instance'

const route = useRoute()

const userId = route.params.userId

const currentClock = ref(null)
const relativeTime = ref(null)
const distanceTime = ref(null)

const refresh = async () => {
  const response = await instance.get(`/clocks/${userId}`)

  currentClock.value = response.data
  if (currentClock.value?.time) {
    relativeTime.value = formatRelative(currentClock.value.time, new Date())
    distanceTime.value = formatDistance(currentClock.value.time, new Date())
  }

  return currentClock.value
}

const clock = async () => {
  await refresh()
  const currentDate = new TZDate().toISOString()

  if (currentClock.value.status) {
    instance
      .post(`/workingtimes/${userId}`, {
        start: currentClock.value.time,
        end: currentDate
      })
      .then(() => {
        toast.success('Time worked saved')
      })
      .catch(() => {
        toast.error('Error saving time worked')
      })
  }

  await instance
    .put(`/clocks/${userId}`, {
      time: currentDate,
      status: !(currentClock.value?.status ?? false)
    })
    .then(() => {
      toast.success('Clocked')
    })
    .catch(() => {
      toast.error('Error clocking')
    })

  refresh()
}

onMounted(() => {
  refresh()
})
</script>

<template>
  <div class="flex flex-col items-center gap-4">
    <h1>Clock Manager</h1>
    <div class="flex flex-col gap-4">
      <div
        :class="[
          'rounded border-l-4 p-2',
          currentClock?.status ? 'border-green-500' : 'border-red-500'
        ]"
      >
        <div v-if="currentClock?.time">
          <div v-if="currentClock.status" class="flex flex-col items-center">
            <p>You arrived {{ relativeTime }}</p>
            <p>Time worked: {{ distanceTime }}</p>
          </div>
          <div v-else>
            <p>You left {{ relativeTime }}</p>
          </div>
        </div>
        <div v-else>
          <p>You have never clocked in</p>
        </div>
      </div>
      <div class="flex justify-center gap-4">
        <button
          class="rounded bg-slate-400 px-2 py-1 text-white"
          @click="refresh"
        >
          Refresh
        </button>
        <button
          class="rounded bg-slate-400 px-2 py-1 text-white"
          @click="clock"
        >
          Clock
        </button>
      </div>
    </div>
  </div>
</template>
