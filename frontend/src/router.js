import { createRouter, createWebHistory } from 'vue-router'

import ChartsManager from './components/charts/ChartsManager.vue'
import ClockManager from './components/clocks/ClockManager.vue'
import Layout from './components/layout/Layout.vue'
import User from './components/user/User.vue'
import WorkingTimes from './components/workingTimes/WorkingTimes.vue'

const router = createRouter({
  history: createWebHistory(),
  routes: [
    {
      path: '/',
      component: Layout,
      children: [
        { path: '/:userId', name: 'user', component: User },
        { path: '/clock/:userId', name: 'clock', component: ClockManager },
        {
          path: '/working-times/:userId',
          name: 'working-times',
          component: WorkingTimes
        },
        { path: '/charts/:userId', name: 'charts', component: ChartsManager }
      ]
    }
  ]
})

export default router
