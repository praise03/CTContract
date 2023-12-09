import { createApp } from 'vue'
import router from './router'
import Notifications from '@kyvg/vue3-notification'
import './style.css'
import App from './App.vue'
import Toast from "vue-toastification";
import "vue-toastification/dist/index.css";


const app = createApp(App)

app.use(router)
app.use(Notifications)
const options = {
};

app.use(Toast, options);
app.mount("#app")
