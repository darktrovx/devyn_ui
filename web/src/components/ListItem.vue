<script>

    export default {
        props: {
            itemId: String,
            label: String,
            text: String
        },
        data() {
            return {}
        },
        methods: {}
    };
</script>

<template>
    <div class="list-item">
        <div class="list-label">{{label}}</div>
        <div class="list-text">{{text}}</div>
    </div>
</template>

<style>
    .list-item {
        border: 2px solid var(--primary-color);
        border-radius: 3px;
        width: 200px;
        height: auto;
        display: flex;
        flex-direction: column;
        padding: 10px;
    }

    .list-label {
        font-family: 'Roboto', sans-serif;
        font-weight: bold;
        font-size: 18px;
        color: var(--primary-color);
        margin-bottom: 5px;
    }

    .list-text {
        font-family: 'Roboto', sans-serif;
        color: white;
        width: 200px;
        height: 10px;
        display: flex;
        flex-direction: row;
        justify-content: space-between;
        align-items: center;
    }
</style>