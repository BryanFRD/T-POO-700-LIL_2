import { createRouter, createWebHistory } from 'vue-router'

import ClockManagerView from './components/clockmanager/ClockManagerView.vue'
import UserView from './components/user/UserView.vue'

const routes = [
  { path: '/:userId', name: 'user', component: UserView },
  { path: '/clock/:userId', name: 'clock', component: ClockManagerView }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
