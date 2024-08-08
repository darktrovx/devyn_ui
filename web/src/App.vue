<script>

    import NUI from './components/NUI.vue';
    import Progress from './components/Progress.vue';
    import Task from './components/Task.vue';
    import Timer from './components/Timer.vue';
    import ListItem from './components/ListItem.vue';
  
    export default {
        components: {
        NUI,
        Progress,
        Timer,
        Task,
        ListItem,
    },
    data() {
        return {
            ProgData: null,
            Timers: [],
            taskDisplay: false,
            taskTitle: '',
            taskDescription: '',
            ListItems: [],
        }
    },
    methods: {
        createTimer: function(data) {
            this.Timers.push({
                timerId: data.timerId,
                label: data.label,
                duration: data.duration,
            });
        },
        removeTimer: function(timerId) {
            this.Timers = this.Timers.filter((timer) => timer.timerId !== timerId);
        },

        createListItem: function(data) {
            this.ListItems.push({
                itemId: data.itemId,
                label: data.label,
                text: data.text,
            });
        },
        updateListItem: function(data) {
            const temp = this.ListItems;
            for (let item of temp) {
                if (item.itemId === data.itemId) {
                    item.label = data.label;
                    item.text = data.text;
                }
            }

            this.ListItems = temp;
        },
        removeListItem: function(itemId) {
            this.ListItems = this.ListItems.filter((item) => item.itemId !== itemId);
        },
    },
    
    destroyed() {
        window.removeEventListener("message", this.listener);
    },
    mounted() {
        this.listener = window.addEventListener("message", (event) => {
            switch (event.data.action) {
                case 'progress':
                    this.ProgData = event.data.data;
                    break;
                case 'progressCancel':
                    this.ProgData = null;
                case 'timer':
                    this.createTimer(event.data.data)
                    break;
                case 'timerCancel':
                    this.removeTimer(event.data.data.timerId);
                    break;
                case 'task':
                    this.taskDisplay = true;
                    this.taskTitle = event.data.title;
                    this.taskDescription = event.data.description;
                    break;
                case 'taskHide':
                    this.taskDisplay = false;
                    this.taskTitle = '';
                    this.taskDescription = '';
                    break;
                case 'createInfoItem':
                    this.createListItem(event.data);
                    break;
                case 'updateInfoItem':
                    this.updateListItem(event.data);
                    break;
                case 'removeInfoItem':
                    this.removeListItem(event.data.itemId);
                    break;

            }
        });
    },
}
</script>

<template>

    <div class="timers">
        <Timer v-for="timer in this.Timers" :timerId="timer.timerId" :label="timer.label" :duration="timer.duration" />
    </div>

    <div class="listItems">
        <ListItem v-for="item in this.ListItems" :itemId="item.itemId" :label="item.label" :text="item.text" />
    </div>

    <Progress v-if="this.ProgData" :ProgData="this.ProgData"/>

    <Task :display="this.taskDisplay" :title="this.taskTitle" :description="this.taskDescription"/>

</template>

<style>
    .timers {
        position: absolute;
        top: 45%;
        left: 0;
        margin-left: 25px;
        height: 100%;

        display: flex;
        flex-direction: column;
        align-items: flex-start;
        column-gap: 20px;
    }

    .listItems {
        position: absolute;
        width: 300px;
        top: 45%;
        right: 0;
        margin-right: 15px;
        height: 100%;

        display: flex;
        flex-direction: column;
        align-items: flex-start;
        column-gap: 20px;
        row-gap: 20px;
    }
</style>