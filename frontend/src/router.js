import { createRouter, createWebHistory } from 'vue-router'

import ClockManagerView from './components/clockmanager/ClockManagerView.vue'
import UserView from './components/user/UserView.vue'
import Layout from './components/layout/Layout.vue'
import WorkingTimes from './components/workingTimes/WorkingTimes.vue'

const router = createRouter({
  history: createWebHistory(),
  routes: [
    {
      path: '/',
      component: Layout,
      children: [
        { path: '/:userId', name: 'user', component: UserView },
        {
          path: '/working-times/:userId',
          name: 'working-times',
          component: WorkingTimes
        }
      ]
    }
  ]
})

export default router
