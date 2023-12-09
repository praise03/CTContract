import { createWebHistory, createRouter } from "vue-router";
import Home from "./components/Home.vue";
import Orders from "./components/Orders.vue"
import CopyTrade from "./components/CopyTrade.vue"

const routes = [
    {
        path: '/pathMatch(.*)*',
        name: 'Error',
        component: Error
    },
    {
        path: "/",
        name: 'Home',
        component: Home
    },
    {
        path: "/orders",
        name: 'Orders',
        component: Orders
    },
    {
        path: "/copytrade",
        name: 'CopyTrade',
        component: CopyTrade
    }

    

]

const router = createRouter({
    history: createWebHistory(),
    routes
})

export default router