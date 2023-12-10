import { createApp } from 'vue'
import router from './router'
import Notifications from '@kyvg/vue3-notification'
import './style.css'
import App from './App.vue'
import Toast from "vue-toastification";
import "vue-toastification/dist/index.css";
import { apolloClient } from './apolloClient'
import { DefaultApolloClient } from '@vue/apollo-composable'


const app = createApp(App)

app.use(router)
app.use(Notifications)
const options = {
};
app.provide(DefaultApolloClient, apolloClient)
app.use(Toast, options);
app.mount("#app")
