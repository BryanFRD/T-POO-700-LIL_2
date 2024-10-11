<script setup>
import {
  differenceInMinutes,
  endOfDay,
  format,
  isSameDay,
  startOfDay,
  subDays
} from 'date-fns'
import { computed, onMounted, ref, watch } from 'vue'
import { useRoute } from 'vue-router'

import { instance } from '@/api/instance'
import { LineChart } from '@/components/ui/chart-line'

const route = useRoute()

const lastWeekDate = subDays(new Date(), 7)

const workingTimes = ref([])
const workingTimesLoading = ref(false)
const workingTimesError = ref(null)

const getWorkingTimes = async userId => {
  workingTimesLoading.value = true
  workingTimesError.value = null

  try {
    const result = await instance.get(
      `/workingtimes/${userId}?order_by=start&order=asc&start=${lastWeekDate.toISOString()}`
    )

    workingTimes.value = result.data
  } catch {
    workingTimesError.value = `Failed to fetch WorkingTimes`
  } finally {
    workingTimesLoading.value = false
  }
}

const groupedByDay = computed(() => {
  if (!workingTimes.value.length) return {}

  return workingTimes.value.reduce((acc, workingTime) => {
    const startDate = new Date(workingTime.start)
    const endDate = new Date(workingTime.end)

    if (isSameDay(startDate, endDate)) {
      const startDay = startOfDay(startDate)
      const dateISOString = startDay.toISOString()

      if (!acc[dateISOString]) {
        acc[dateISOString] = 0
      }

      acc[dateISOString] += differenceInMinutes(endDate, startDate)
    } else {
      const startDay = startOfDay(startDate)
      const endDay = endOfDay(startDate)
      const dateISOString = startDay.toISOString()

      if (!acc[dateISOString]) {
        acc[dateISOString] = 0
      }

      acc[dateISOString] += differenceInMinutes(endDay, startDate)

      const nextDay = startOfDay(endDate)
      const nextDayISOString = nextDay.toISOString()

      if (!acc[nextDayISOString]) {
        acc[nextDayISOString] = 0
      }

      acc[nextDayISOString] += differenceInMinutes(endDate, nextDay)
    }

    return acc
  }, {})
})

const data = computed(() => {
  return Object.entries(groupedByDay.value).map(([key, value]) => {
    return {
      date: format(new Date(key), 'yyyy-MM-dd'),
      hour: value / 60
    }
  })
})

watch(() => route.params.userId, getWorkingTimes)
onMounted(() => {
  getWorkingTimes(route.params.userId)
})
</script>

<template>
  <div class="pt-2">
    <h2 class="pb-6 text-xl font-semibold">Working Times</h2>

    <LineChart
      :data="data"
      index="date"
      :categories="['hour']"
      :show-legend="false"
    />
  </div>
</template>
