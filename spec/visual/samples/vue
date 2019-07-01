<template lang="jade">
div
  p {{ greeting }} World!
  other-component
</template>

<script>
import OtherComponent from './OtherComponent.vue'

export default {
  data () {
    return {
      greeting: 'Hello'
    }
  },
  components: {
    OtherComponent
  }
}
</script>

<style lang="scss">
  .vue-carousel {
    overflow: hidden;

    &:hover {
      display: none;
      .next {
        display: block;
      }
    }
  }
</style>

<style lang="stylus" scoped>
p
  font-size 2em
  text-align center
</style>



<template>
  <p>{{ greeting }} World!</p>
  {{ message | filterA('arg1', arg2) }}
</template>

<script>
module.exports = {
  data: function () {
    return {
      greeting: 'Hello'
    }
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>

<script lang=coffee>
  module.exports = { data: -> { greeting: 'Hello' } }
</script>

<script lang='coffee'>
  module.exports = { data: -> { greeting: 'Hello' } }
</script>

<script lang="coffee">
  module.exports = { data: -> { greeting: 'Hello' } }
</script>
