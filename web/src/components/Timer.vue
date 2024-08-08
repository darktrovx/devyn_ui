<script>
    import NUI from './NUI.vue';

    export default {
        name: 'Timer',
        props: {
            timerId: Number,
            label: String,
            duration: Number,
        },
        data() {
            return {
                timer: null,
                countdown: 0,

                silverBar: 0,
                goldBar: 0,
            }
        },
        components: {
            NUI
        },
        methods: {
            timerStart: function() {
                this.countdown = this.duration / 1000;
                this.goldBar = (this.countdown / (this.duration / 1000)) * 100;
                this.silverBar = 100 - this.goldBar;

                this.timer = setInterval(() => {
                    this.countdown--;

                    this.goldBar = (this.countdown / (this.duration / 1000)) * 100;
                    this.silverBar = 100 - this.goldBar;

                    if (this.countdown < 1) {
                        clearInterval(this.timer);
                        NUI.methods.message('timerComplete', { timerId: this.timerId });
                        this.$parent.removeTimer(this.timerId);
                    }

                }, 1000);
            },
            timeFormat: function(duration) {
                // Hours, minutes and seconds
                const hrs = ~~(duration / 3600);
                const mins = ~~((duration % 3600) / 60);
                const secs = ~~duration % 60;

                // Output like "1:01" or "4:03:59" or "123:03:59"
                let ret = "";

                if (hrs > 0) {
                    ret += "" + hrs + ":" + (mins < 10 ? "0" : "");
                }

                ret += "" + mins + ":" + (secs < 10 ? "0" : "");
                ret += "" + secs;

                return ret;
            }
        },
        unmounted () {
            clearInterval(this.timer);
        },
        mounted() {
            this.timerStart();
        },
    };
</script>

<template>
    <div class="timer">
        <div class="timer-text">
            <div class="timer-title">{{ this.label }} :</div>
            <div class="timer-percent">{{this.timeFormat(this.countdown)}}</div>
        </div>

        <div class="timer-bar">
            <div class="timer-remaining" :style="{width: this.goldBar + '%'}"></div>
            <div class="timer-split"></div>
            <div class="timer-expired" :style="{width: this.silverBar  + '%'}"></div>
        </div>
    </div>
</template>

<style>

    .timer {
        width: 200px;
        height: 10px;
        margin-top: 60px;
        display: flex;
        flex-direction: column;
    }

    .timer-text {
        font-family: 'Roboto', sans-serif;
        color: white;
        width: 200px;
        height: 10px;
        display: flex;
        float: right;
        flex-direction: row;
        justify-content: space-between;
        align-items: center;
    }

    .timer-title {
        color: white;
    }

    .timer-percent {
        color: white;
    }

    .timer-bar {
        width: 200px;
        height: 10px;
        padding-top: 10px;
        display: flex;
        flex-direction: row;
    }

    .timer-remaining {
        height: 10px;
        background-color: var(--primary-color);      
        border-radius: 2px;
    }

    .timer-split {
        width: 5px;
        height: 10px;
        background-color: white;
        border-radius: 10px;
        margin-left: 5px;
        margin-right: 5px;
    }

    .timer-expired {
        height: 10px;
        background-color: #2C2B2B;
        opacity: 0.7;
        border-radius: 2px;
    }

</style>