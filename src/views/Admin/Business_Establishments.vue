<template>
 <div class="container">
  <div class="page-header">
   <div class="row">
    <div class="col-lg-8 col-md-5">
     <h1>Business Establishment Records</h1>
    </div>
    <div class="col search">
     <div class="input-group">
      <input type="text" class="form-control" placeholder="Search" v-model="search" v-on:input="fetchBusinessEsts()" />
     </div>
    </div>
   </div>
  </div>
  <div class="table-container table-responsive-xxl shadow">
   <button class="btn btn-primary mb-3" v-b-modal.modal-add v-if="permission == 'bspo'"> Add Record </button>
   <div class="d-flex justify-content-center" v-if="loading">
    <div class="spinner-border text-center mt-3" role="status"></div>
   </div>
   <table class="table table-striped table-hover table-sm" v-if="!loading">
    <thead>
     <tr>
      <th scope="col">Name of Business Establishment</th>
      <th scope="col">Type of Business</th>
      <th scope="col">Name of Owner</th>
      <th scope="col" v-if="permission == 'bspo'">Action</th>
     </tr>
    </thead>
    <tbody>
     <tr v-for="(bs, index) in businessEsts" :key="index">
      <td>{{ bs.business_est_name }}</td>
      <td>{{ bs.business_type }}</td>
      <td> {{ bs.business_owner }} </td>
      <td v-if="permission == 'bspo'">
       <button class="btn btn-primary mb-2" @click="viewDetails(bs)">Update Details</button>
       <button class="btn btn-danger  mb-2" @click="deleteBusiness(bs.id)">Delete Record</button>
      </td>
     </tr>
    </tbody>
   </table>
  </div>

  <b-modal class="add_modal" id="modal-add" title="Add Establishment" centered :hide-footer="true">
   <form @submit.prevent="createBusinessEst" class="col">
    <div class="form-group">
     <label for="household-num" class="control-label"> Name of Business Establishment </label>
     <input type="text" class="form-control" id="household-num" placeholder="Enter name of establishment" v-model="bsInfo.business_est_name" />
     <div v-if="this.errors.business_est_name">
      <label style="color: red; font-weight: 500">{{ this.errors.business_est_name[0] }}</label>
     </div>
    </div>
    <div class="form-group">
     <label for="family-number" class="control-label"> Type of Business </label>
     <input type="text" class="form-control" id="family-number" placeholder="Enter type of business" v-model="bsInfo.business_type" />
     <div v-if="this.errors.business_type">
      <label style="color: red; font-weight: 500">{{ this.errors.business_type[0] }}</label>
     </div>
    </div>
    <div class="form-group">
     <label for="first-name" class="control-label"> Name of Owner </label>
     <input type="text" class="form-control" id="first-name" placeholder="Enter name of owner" v-model="bsInfo.business_owner" />
     <div v-if="this.errors.business_owner">
      <label style="color: red; font-weight: 500">{{ this.errors.business_owner[0] }}</label>
     </div>
    </div>

    <div class="mt-4 d-flex justify-content-end">
     <button class="btn btn-danger" type="button" @click="closeViewDetails">Cancel</button>
     <button class="btn btn-primary" type="submit">Save</button>
    </div>
   </form>
  </b-modal>
  <b-modal class="update_modal" id="modal-view" title="Update Establishment" centered :hide-footer="true">
   <form @submit.prevent="updateBusiness" class="col">
    <div class="form-group">
     <label for="household-num" class="control-label"> Name of Business Establishment </label>
     <input type="text" class="form-control" id="household-num" placeholder="Enter name of establishment" v-model="bsInfo.business_est_name" />
     <div v-if="this.errors.business_est_name">
      <label style="color: red; font-weight: 500">{{ this.errors.business_est_name[0] }}</label>
     </div>
    </div>
    <div class="form-group">
     <label for="family-number" class="control-label"> Type of Business </label>
     <input type="text" class="form-control" id="family-number" placeholder="Enter type of business" v-model="bsInfo.business_type" />
     <div v-if="this.errors.business_type">
      <label style="color: red; font-weight: 500">{{ this.errors.business_type[0] }}</label>
     </div>
    </div>
    <div class="form-group">
     <label for="first-name" class="control-label"> Name of Owner </label>
     <input type="text" class="form-control" id="first-name" placeholder="Enter name of owner" v-model="bsInfo.business_owner" />
     <div v-if="this.errors.business_owner">
      <label style="color: red; font-weight: 500">{{ this.errors.business_owner[0] }}</label>
     </div>
    </div>

    <div class="mt-4 d-flex justify-content-end">
     <button class="btn btn-danger" type="button" @click="closeViewDetails">Cancel</button>
     <button class="btn btn-primary" type="submit">Update</button>
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
    bsInfo: {
     business_est_name: "",
     business_type: "",
     business_owner: "",
     remember_token: localStorage.getItem("token"),
    },
    errors: [],
    businessEsts: [],
    businessDetails: {},

    search: "",
    loading: true,
    currentPage: 0,
    rows: 0,
    perPage: 0,

    permission: localStorage.getItem("permission"),
   };
  },

  methods: {
   async fetchBusinessEsts() {
    this.loading = true;
    await axios
     .get(`/business-est-records?page=${this.currentPage}&search=${this.search}`)
     .then((response) => {
      this.businessEsts = response.data.data;
      this.currentPage = response.data.current_page;
      this.rows = response.data.total;
      this.perPage = response.data.per_page;
     })
     .catch((error) => {
      return error.response;
     });
    this.loading = false;
   },

   async createBusinessEst() {
    await axios
     .post("/new-business-est-record", this.bsInfo)
     .then(() => {
      this.$toast.success("Business establishment record saved.");
      this.$bvModal.hide("modal-add");
      this.fetchBusinessEsts();
     })
     .catch((error) => {
      this.errors = error.response.data.errors;
     });
   },

   async updateBusiness() {
    await axios
     .put(`/update-business-est-record/${this.bsInfo.id}`, this.bsInfo)
     .then(() => {
      this.$toast.success("Business establishment record updated.");
      this.$bvModal.hide("modal-view");
      this.fetchBusinessEsts();
     })
     .catch((error) => {
      this.errors = error.response.data.errors;
     });
   },

   async deleteBusiness(id) {
    const data = {
     remember_token: localStorage.getItem("token"),
    };
    await axios
     .post(`/delete-business-est-record/${id}`, data)
     .then(() => {
      this.$toast.success("Business establishment record deleted.");
      this.fetchBusinessEsts();
     })
     .catch((error) => {
      this.errors = error.response.data.errors;
     });
   },

   viewDetails(data) {
    this.bsInfo = {
     id: data.id,
     business_est_name: data.business_est_name,
     business_owner: data.business_owner,
     business_type: data.business_type,
     remember_token: localStorage.getItem("token"),
    };
    this.$bvModal.show("modal-view");
   },

   closeViewDetails() {
    this.bsInfo = {
     business_est_name: "",
     business_owner: "",
     business_type: "",
    };
    this.$bvModal.hide("modal-view");
   },
  },

  mounted() {
   this.fetchBusinessEsts();
  },
 };
</script>
