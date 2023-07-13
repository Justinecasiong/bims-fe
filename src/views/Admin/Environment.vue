<template>
 <div class="">
  <div class="page-header">
   <div class="row">
    <div class="col-lg-8 col-md-5">
     <h1>Environment</h1>
    </div>
    <div class="col search">
     <div class="input-group">
      <input type="text" class="form-control" placeholder="Search" v-model="search" v-on:input="fetchHouseholdEnv" />
     </div>
    </div>
   </div>
  </div>
  <div class="table-container table-responsive-xxl shadow">
   <div class="d-flex justify-content-center" v-if="loading">
    <div class="spinner-border text-center mt-3" role="status"></div>
   </div>
   <table class="table table-striped table-hover table-sm" v-if="!loading">
    <thead>
     <tr>
      <th scope="col">Household No.</th>
      <th scope="col">Household Head Name</th>
      <th scope="col">Birthday</th>
      <th scope="col">Age</th>
      <th scope="col">Sex</th>
      <th scope="col">Has access to toilet?</th>
      <th scope="col">No. of Hypertensive in family</th>
      <th scope="col">No. of diabetic in family</th>
      <th scope="col">No. of high risk in family</th>
      <th scope="col">Action</th>
     </tr>
    </thead>
    <tbody>
     <tr v-for="(envs, index) in householdEnvs" :key="index">
      <td>{{ envs.household_head.household_num }}</td>
      <td>{{ envs.household_head.first_name }} {{ envs.household_head.middle_name ? envs.household_head.middle_name : "" }} {{ envs.household_head.last_name }} </td>
      <td>{{ envs.household_head.birthdate }}</td>
      <td>{{ envs.household_head.age }}</td>
      <td>{{ envs.household_head.sex }}</td>
      <td>{{ envs.toilet_access }}</td>
      <td>{{ envs.hypertensive_family_no }}</td>
      <td>{{ envs.diabetic_family_no }}</td>
      <td>{{ envs.high_risk_family_no }}</td>
      <td>
       <button class="btn btn-primary mb-2" @click="viewDetails(envs)">Update Environment</button>
      </td>
     </tr>
    </tbody>
   </table>
  </div>
  <b-modal class="view_modal" id="modal-view" title="Household Head Information" centered :hide-footer="true">
   <form @submit.prevent="updateEnv" class="row">
    <div class="col">
     <div class="col-12">
      <div class="form-group">
       <label for="toilet_access" class="control-label"> Has access to toilet? </label>
       <select class="form-select" name="toilet_access" id="toilet_access" v-model="envDetails.toilet_access">
        <option value="Yes">Yes</option>
        <option value="No">No</option>
       </select>
       <div v-if="this.errors.toilet_access">
        <label style="color: red; font-weight: 500">{{ this.errors.toilet_access[0] }}</label>
       </div>
      </div>
     </div>
     <div class="col-12">
      <div class="form-group">
       <label for="hypertensive_family_no" class="control-label"> No. of Hypertensive in family </label>
       <input required type="number" class="form-control" id="hypertensive_family_no" placeholder=" " v-model="envDetails.hypertensive_family_no" />
       <div v-if="this.errors.hypertensive_family_no">
        <label style="color: red; font-weight: 500">{{ this.errors.hypertensive_family_no[0] }}</label>
       </div>
      </div>
     </div>
     <div class="col-12">
      <div class="form-group">
       <label for="diabetic_family_no" class="control-label"> No. of diabetic in family </label>
       <input required type="number" class="form-control" id="diabetic_family_no" placeholder=" " v-model="envDetails.diabetic_family_no" />
       <div v-if="this.errors.diabetic_family_no">
        <label style="color: red; font-weight: 500">{{ this.errors.diabetic_family_no[0] }}</label>
       </div>
      </div>
     </div>
     <div class="col-12">
      <div class="form-group">
       <label for="high_risk_family_no" class="control-label"> No. of high risk in family </label>
       <input required type="number" class="form-control" id="high_risk_family_no" placeholder=" " v-model="envDetails.high_risk_family_no" />
       <div v-if="this.errors.high_risk_family_no">
        <label style="color: red; font-weight: 500">{{ this.errors.high_risk_family_no[0] }}</label>
       </div>
      </div>
     </div>
    </div>
    <div class="mt-4 d-flex justify-content-end">
     <button class="btn btn-danger" type="button" @click="closeViewDetails">Cancel</button>
     <button class="btn btn-primary" type="submit">Update Record</button>
    </div>
   </form>
  </b-modal>
 </div>
</template>

<script>
 import axios from "../../axios";
 export default {
  data() {
   return {
    errors: [],
    householdEnvs: [],
    householdMembers: [],
    envDetails: {},
    search: "",
    loading: true,
    currentPage: 0,
    rows: 0,
    perPage: 0,

    permission: localStorage.getItem("permission"),
   };
  },

  methods: {
   async fetchHouseholdEnv() {
    await axios
     .get(`/all-household-envs?page=${this.currentPage}&search=${this.search}`)
     .then((response) => {
      this.householdEnvs = response.data.data;
      this.currentPage = response.data.current_page;
      this.rows = response.data.total;
      this.perPage = response.data.per_page;
     })
     .catch((error) => {
      return error.response;
     });
    this.loading = false;
   },

   async updateEnv() {
    const data = {
     id: this.envDetails.id,
     household_head_id: this.envDetails.household_head_id,
     toilet_access: this.envDetails.toilet_access,
     hypertensive_family_no: this.envDetails.hypertensive_family_no,
     diabetic_family_no: this.envDetails.diabetic_family_no,
     high_risk_family_no: this.envDetails.high_risk_family_no,
     remember_token: localStorage.getItem("token"),
    };
    this.loading = true;
    this.$bvModal.hide("modal-view");
    await axios
     .put(`/update-household-env-record/${data.id}`, data)
     .then(async () => {
      this.$toast.success("Household environment record has been updated.");
      this.closeViewDetails();
      await this.fetchHouseholdEnv();
     })
     .catch((error) => {
      this.errors = error.response.data.errors;
     });
   },

   viewDetails(data) {
    this.envDetails = data;
    this.$bvModal.show("modal-view");
   },

   closeViewDetails() {
    this.envDetails = {};
    this.$bvModal.hide("modal-view");
   },
  },

  mounted() {
   this.fetchHouseholdEnv();
  },
 };
</script>
