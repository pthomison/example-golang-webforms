import * as Vue from 'Vue';
import FormComponent from './form.vue';
import 'bootstrap';

const app = Vue.createApp({})
app.component('form-component', FormComponent)
const vm = app.mount('#app')
