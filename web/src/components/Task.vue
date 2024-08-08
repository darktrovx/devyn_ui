<script>

    export default {
        props: {
            display: Boolean,
            title: String,
            description: String
        },
        name: 'Task',
        data() {
            return { }
        },
        methods: {}
    };
</script>

<template>
    <div class="task-container" v-if="this.display">
        <div class="task-header">
            <div class="task-title">{{ this.title }}</div>
        </div>
        <div class="task-description">
            {{ this.description }}
        </div>
    </div>
</template>

<style>

    .task-container {
        position: absolute;
        top: 35%;
        left: 0;
        margin-left: 25px;
        min-width: 210px;
        max-width: 210px;
        height: auto;
    }

    .task-header {
        text-align: center;
        margin-bottom: 5px;
        border-bottom: 1px solid transparent;
        border-image: linear-gradient(to right, transparent, #fff, transparent);
        border-image-slice: 1;
    }

    .task-title {
        font-size: 14px;
        font-weight: bold;
        color: var(--primary-color);
        text-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
        padding: 5px;
    }

    .task-description {
        font-size: 12px;
        color: #fff;
        text-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
        padding: 5px;
        text-align: center;
        padding-bottom: 10px;
        background: rgba(236, 27, 255, 0.08);
        border-radius: 0px 0px 6px 6px;
        box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1);
        border: 1px solid var(--primary-color)4d; /* Add this line to add a border */
    }
</style>