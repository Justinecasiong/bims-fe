<template>
 <div class="container">
  <div class="page-header">
   <div class="d-flex flex-column items-content-center">
    <h1 style="line-height: 0 !important; margin-bottom: 0 !important">Health Services</h1>
    <div class="form-group mb-5 col-4">
     <select class="form-select" name="fic" id="fic" v-model="selectedData">
      <option value="Environment">Environment</option>
      <option value="Child Information">Child Infomartion</option>
      <option value="Mother">Mother Information</option>
     </select>
    </div>
   </div>
  </div>
  <Environment v-if="selectedData == 'Environment'" />
  <ChildInfo v-if="selectedData == 'Child Information'" />
  <Mother v-if="selectedData == 'Mother'" />
 </div>
</template>

<script>
 import Environment from "./Environment.vue";
 import ChildInfo from "./ChildInfo.vue";
 import Mother from "./Mother.vue";
 export default {
  components: { Environment, ChildInfo, Mother},
  data() {
   return {
    errors: [],
    selectedData: "Child Information",
    search: "",
    loading: false,
    currentPage: 0,
    rows: 0,
    perPage: 0,

    permission: localStorage.getItem("permission"),
   };
  },

  methods: {},

  mounted() {},
 };
</script>
