<script>
    import NUI from './NUI.vue';

    export default {
        name: 'Progress',
        props: {
            ProgData: Object
        },
        data() {
            return {
                Label: 'Loading',
                Duration: 0,
                Delay: 0,
                Progress: 0,
                Start: 0,
                End: 0,
            }
        },
        components: {
            NUI
        },
        methods: {
            Complete: function() {
                this.Reset();
                NUI.methods.message('progressComplete');
            },
            Reset: function() {
                this.Label = 'Loading';
                this.Duration = 0;
                this.Progress = 0;
                this.Start = 0;
                this.End = 0;
                this.$parent.ProgData = null;
            },
            ProgressBar: function (data) {
                this.Label = data.label;
                this.Duration = data.duration;
                this.Progress = 0;
                this.Start = (new Date()).valueOf();
                this.End = this.Start + this.Duration;

                const int = setInterval(() => {
                    if (this.ProgData == null) { // Canceled Check
                        clearInterval(int);
                        this.Reset();
                        return;
                    }

                    const now = (new Date()).valueOf();
                    if (now >= this.End) {
                        this.Progress = 100;
                        this.Complete();
                        clearInterval(int); 
                        return;
                    };
                    
                    this.Progress  = Math.round(((now - this.Start)/(this.End - this.Start)) * 100);
                }, 10)

            },
        },
        mounted() {
            this.ProgressBar(this.ProgData);
        }
    };
</script>

<template>
    <div class="progress-container">

        <div class="progress-text">
            <div class="progress-title">{{ this.Label }}</div>
            <div class="progress-percent">{{this.Progress}}%</div>
        </div>

        <div class="progress-bar">
            <div class="progress-completed" :style="{width: this.Progress + '%'}"></div>
            <div class="progress-bar-tip"></div>
            <div class="progress-empty" :style="{width: (100 - this.Progress)  + '%'}"></div>
        </div>
    </div>

</template>

<style>

    .progress-container {
        width: 400px;
        max-width: 400px;
        height: 100px;
        display: flex;
        flex-direction: column;
        position: absolute;
        left: 50%;
        top: 85%;
        transform: translate(-50%, -50%);
    }

    .progress-text {
        font-family: 'Roboto', sans-serif;
        color: white;
        width: 400px;
        height: 20px;
        display: flex;
        float: right;
        flex-direction: row;
        justify-content: space-between;
        align-items: center;
    }

    .progress-title {
        color: white;
    }

    .progress-percent {
        color: white;
    }

    .progress-bar {
        width: 400px;
        height: 20px;
        padding-top: 10px;
        display: flex;
        flex-direction: row;
        
    }

    .progress-completed {
        height: 20px;
        background-color: var(--primary-color);    
        opacity: 0.7;  
        border-radius: 2px;
        transition: width 0.3s;
        box-shadow: 0px 0px 15px 3px var(--primary-color);
    }

    .progress-bar-tip {
        width: 5px;
        height: 20px;
        background-color: white;
        border-radius: 10px;
        margin-left: 5px;
        margin-right: 5px;
    }

    .progress-empty {
        height: 20px;
        background-color: #2C2B2B;
        opacity: 0.7;
        border-radius: 2px;
        transition: width 0.3s;
    }

</style>