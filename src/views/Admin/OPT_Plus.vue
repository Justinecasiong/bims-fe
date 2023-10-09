<template>
 <div class="container">
  <div class="page-header">
   <div class="row">
    <div class="col-lg-8 col-md-5">
     <h1>Preschooler Nutritional Status</h1>
    </div>
    <div class="col search">
     <div class="input -group">
      <input required type="text" class="form-control" placeholder="Search" v-model="optData.search" v-on:input="fetchOptRecords()" />
     </div>
    </div>
   </div>
  </div>
  <div class="table-container table-responsive-xxl shadow">
   <button class="btn btn-primary mb-3" v-b-modal.modal-add v-if="permission == 'bns'"> Add Child/Preschooler </button>
   <div class="d-flex justify-content-center" v-if="loading">
    <div class="spinner-border text-center mt-3" role="status"></div>
   </div>
   <table class="table table-striped table-hover table-sm" v-if="loading == false">
    <thead>
     <tr>
      <th scope="col">Purok</th>
      <th scope="col">Household No.</th>
      <th scope="col">Name of Household/Mother/Caregiver</th>
      <th scope="col">Name of Preschooler</th>
      <th scope="col">Sex</th>
      <th scope="col">Birthday (YYYY/MM/DD)</th>
      <th scope="col">Weight</th>
      <th scope="col">Length/Height</th>
      <th scope="col" >Action</th>
     </tr>
    </thead>

    <tbody>
     <tr v-for="(opt, index) in optRecords" :key="index">
      <td> {{ opt.purok }} </td>
      <td> {{ opt.household_num }} </td>
      <td> {{ opt.name_of_caregiver }} </td>
      <td> {{ opt.preschooler_name }} </td>
      <td> {{ opt.sex }} </td>
      <td> {{ opt.birthdate }} </td>
      <td> {{ opt.weight }} </td>
      <td> {{ opt.length_height }} </td>
      <td>
       <button class="btn btn-primary mb-2" @click="viewDetails(opt)">View Details</button>
       <button v-if="permission == 'bns' && permission != 'chairperson'" class="btn btn-danger" @click="deleteOpt(opt.id)" >Delete Record</button>
      </td>
     </tr>
    </tbody>
   </table>
  </div>

  <b-modal class="add_modal" id="modal-add" title="Add Child/Preschooler" size="xl" centered :hide-footer="true">
   <form @submit.prevent="createOptRecord" class="row">
    <div class="col">
     <div class="row">
      <div class="col-sm-4">
       <div class="form-group">
        <label for="purok" class="control-label"> Purok </label>
        <input required type="text" class="form-control" id="purok" placeholder="Enter purok" v-model="optData.purok" />
        <div v-if="this.errors.purok">
         <label style="color: red; font-weight: 500">{{ this.errors.purok[0] }}</label>
        </div>
       </div>
      </div>
      <div class="col-sm-4">
       <div class="form-group">
        <label for="household-number" class="control-label"> Household No. </label>
        <input required type="text" class="form-control" id="household-number" placeholder="Enter household no." v-model="optData.household_num" />
        <div v-if="this.errors.household_num">
         <label style="color: red; font-weight: 500">{{ this.errors.household_num[0] }}</label>
        </div>
       </div>
      </div>
      <div class="col-sm-4">
       <div class="form-group">
        <label for="name_of_caregiver" class="control-label"> Name of Household Head/Mother/Caregiver </label>
        <input required type="text" class="form-control" id="name_of_caregiver" placeholder="Enter household head/mother/caregiver" v-model="optData.name_of_caregiver" />
        <div v-if="this.errors.name_of_caregiver">
         <label style="color: red; font-weight: 500">{{ this.errors.name_of_caregiver[0] }}</label>
        </div>
       </div>
      </div>
     </div>
     <div class="row">
      <div class="col-sm-4">
       <div class="form-group">
        <label for="preschooler_name" class="control-label"> Name of Preschooler </label>
        <input required type="text" class="form-control" id="preschooler_name" placeholder="Enter name of preschooler" v-model="optData.preschooler_name" />
        <div v-if="this.errors.preschooler_name">
         <label style="color: red; font-weight: 500">{{ this.errors.preschooler_name[0] }}</label>
        </div>
       </div>
      </div>
      <div class="col-sm-4">
       <div class="form-group">
        <label for="gender" class="control-label"> Sex </label>
        <input required type="text" class="form-control" id="gender" placeholder="Enter sex" v-model="optData.sex" />
        <div v-if="this.errors.sex">
         <label style="color: red; font-weight: 500">{{ this.errors.sex[0] }}</label>
        </div>
       </div>
      </div>
      <div class="col-sm-4">
       <div class="form-group">
        <label for="birthdate" class="control-label"> Birthday (YYYY/MM/DD) </label>
        <input required type="date" class="form-control" id="birthdate" placeholder="Enter birthday" v-model="optData.birthdate" />
        <div v-if="this.errors.birthdate">
         <label style="color: red; font-weight: 500">{{ this.errors.birthdate[0] }}</label>
        </div>
       </div>
      </div>
     </div>
     <div class="row">
      <div class="col-sm-4">
       <div class="form-group">
        <label for="weight" class="control-label"> Weight </label>
        <input required type="text" class="form-control" id="weight" placeholder="Enter Weight" v-model="optData.weight" />
        <div v-if="this.errors.weight">
         <label style="color: red; font-weight: 500">{{ this.errors.weight[0] }}</label>
        </div>
       </div>
      </div>

      <div class="col-sm-4">
       <div class="form-group">
        <label for="length_height" class="control-label"> Length/Height </label>
        <input required type="number" class="form-control" id="length_height" placeholder="Enter length/height" v-model="optData.length_height" />
        <div v-if="this.errors.length_height">
         <label style="color: red; font-weight: 500">{{ this.errors.length_height[0] }}</label>
        </div>
       </div>
      </div>

      <div class="col-sm-4">
       <div class="form-group">
        <label for="age_in_months" class="control-label"> Age in Months </label>
        <input required type="number" class="form-control" id="age_in_months" placeholder="Enter age in months" v-model="optData.age_in_months" />
        <div v-if="this.errors.age_in_months">
         <label style="color: red; font-weight: 500">{{ this.errors.age_in_months[0] }}</label>
        </div>
       </div>
      </div>

      <div class="col-sm-4">
       <div class="form-group">
        <label for="weight_kg" class="control-label"> Weight (kg) </label>
        <input required type="number" class="form-control" id="weight_kg" placeholder="Enter weight (kg)" v-model="optData.weight_kg" />
        <div v-if="this.errors.weight_kg">
         <label style="color: red; font-weight: 500">{{ this.errors.weight_kg[0] }}</label>
        </div>
       </div>
      </div>

      <div class="col-sm-4">
       <div class="form-group">
        <label for="length_height_cm" class="control-label"> Length/Height (cm) </label>
        <input required type="number" class="form-control" id="length_height_cm" placeholder="Enter length/height (cm)" v-model="optData.length_height_cm" />
        <div v-if="this.errors.length_height_cm">
         <label style="color: red; font-weight: 500">{{ this.errors.length_height_cm[0] }}</label>
        </div>
       </div>
      </div>

      <div class="col-sm-4">
       <div class="form-group">
        <label for="weight_kg" class="control-label"> Weigth for Age </label>
        <select required class="form-select" name="weight_kg" id="weight_for_age" v-model="optData.weight_for_age">
         <option value="Normal">Normal</option>
         <option value="Underweight">Underweight</option>
         <option value="Severely Underweight">Severely Underweight</option>
         <option value="Overweight">Overweight</option>
        </select>
        <div v-if="this.errors.weight_for_age">
         <label style="color: red; font-weight: 500">{{ this.errors.weight_for_age[0] }}</label>
        </div>
       </div>
      </div>

      <div class="col-sm-4">
       <div class="form-group">
        <label for="length_height_cm" class="control-label"> Length/Height for Age </label>
        <select required class="form-select" name="length_height_cm" id="length_height_for_age" v-model="optData.length_height_for_age">
         <option value="Normal">Normal</option>
         <option value="Stunting">Stunting</option>
         <option value="Severely Stunting">Severely Stunting</option>
         <option value="Tall">Tall</option>
        </select>
        <div v-if="this.errors.length_height_for_age">
         <label style="color: red; font-weight: 500">{{ this.errors.length_height_for_age[0] }}</label>
        </div>
       </div>
      </div>

      <div class="col-sm-4">
       <div class="form-group">
        <label for="weight_for_length_height" class="control-label"> Weigth for Length/Height </label>
        <select required class="form-select" name="weight_for_length_height" id="weight_for_length_height" v-model="optData.weight_for_length_height">
         <option value="Normal">Normal</option>
         <option value="Waisted">Waisted</option>
         <option value="Severely Waisted">Severely Waisted</option>
         <option value="Overweight">Overweight</option>
         <option value="Obese">Obese</option>
        </select>
        <div v-if="this.errors.weight_for_length_height">
         <label style="color: red; font-weight: 500">{{ this.errors.weight_for_length_height[0] }}</label>
        </div>
       </div>
      </div>
     </div>
    </div>

    <div class="mt-4 d-flex justify-content-end">
     <button class="btn btn-danger" type="button" @click="closeViewDetails">Cancel</button>
     <button class="btn btn-primary" type="submit">Save</button>
    </div>
   </form>
  </b-modal>
  <b-modal class="update_modal" id="modal-view" title="Update Child/Preschooler" size="xl" centered :hide-footer="true">
   <form @submit.prevent="updateOptRecord" class="row">
    <div class="col">
     <div class="row">
      <div class="col-sm-4">
       <div class="form-group">
        <label for="purok" class="control-label"> Purok </label>
        <input required type="text" class="form-control" id="purok" placeholder="Enter purok" v-model="optData.purok" />
        <div v-if="this.errors.purok">
         <label style="color: red; font-weight: 500">{{ this.errors.purok[0] }}</label>
        </div>
       </div>
      </div>
      <div class="col-sm-4">
       <div class="form-group">
        <label for="household-number" class="control-label"> Household No. </label>
        <input required type="text" class="form-control" id="household-number" placeholder="Enter household no." v-model="optData.household_num" />
        <div v-if="this.errors.household_num">
         <label style="color: red; font-weight: 500">{{ this.errors.household_num[0] }}</label>
        </div>
       </div>
      </div>
      <div class="col-sm-4">
       <div class="form-group">
        <label for="name_of_caregiver" class="control-label"> Name of Household Head/Mother/Caregiver </label>
        <input required type="text" class="form-control" id="name_of_caregiver" placeholder="Enter household head/mother/caregiver" v-model="optData.name_of_caregiver" />
        <div v-if="this.errors.name_of_caregiver">
         <label style="color: red; font-weight: 500">{{ this.errors.name_of_caregiver[0] }}</label>
        </div>
       </div>
      </div>
     </div>
     <div class="row">
      <div class="col-sm-4">
       <div class="form-group">
        <label for="preschooler_name" class="control-label"> Name of Preschooler </label>
        <input required type="text" class="form-control" id="preschooler_name" placeholder="Enter name of preschooler" v-model="optData.preschooler_name" />
        <div v-if="this.errors.preschooler_name">
         <label style="color: red; font-weight: 500">{{ this.errors.preschooler_name[0] }}</label>
        </div>
       </div>
      </div>
      <div class="col-sm-4">
       <div class="form-group">
        <label for="gender" class="control-label"> Sex </label>
        <input required type="text" class="form-control" id="gender" placeholder="Enter sex" v-model="optData.sex" />
        <div v-if="this.errors.sex">
         <label style="color: red; font-weight: 500">{{ this.errors.sex[0] }}</label>
        </div>
       </div>
      </div>
      <div class="col-sm-4">
       <div class="form-group">
        <label for="birthdate" class="control-label"> Birthday (YYYY/MM/DD) </label>
        <input required type="date" class="form-control" id="birthdate" placeholder="Enter birthday" v-model="optData.birthdate" />
        <div v-if="this.errors.birthdate">
         <label style="color: red; font-weight: 500">{{ this.errors.birthdate[0] }}</label>
        </div>
       </div>
      </div>
     </div>
     <div class="row">
      <div class="col-sm-4">
       <div class="form-group">
        <label for="weight" class="control-label"> Weight </label>
        <input required type="text" class="form-control" id="weight" placeholder="Enter Weight" v-model="optData.weight" />
        <div v-if="this.errors.weight">
         <label style="color: red; font-weight: 500">{{ this.errors.weight[0] }}</label>
        </div>
       </div>
      </div>

      <div class="col-sm-4">
       <div class="form-group">
        <label for="length_height" class="control-label"> Length/Height </label>
        <input required type="number" class="form-control" id="length_height" placeholder="Enter length/height" v-model="optData.length_height" />
        <div v-if="this.errors.length_height">
         <label style="color: red; font-weight: 500">{{ this.errors.length_height[0] }}</label>
        </div>
       </div>
      </div>

      <div class="col-sm-4">
       <div class="form-group">
        <label for="age_in_months" class="control-label"> Age in Months </label>
        <input required type="number" class="form-control" id="age_in_months" placeholder="Enter age in months" v-model="optData.age_in_months" />
        <div v-if="this.errors.age_in_months">
         <label style="color: red; font-weight: 500">{{ this.errors.age_in_months[0] }}</label>
        </div>
       </div>
      </div>

      <div class="col-sm-4">
       <div class="form-group">
        <label for="weight_kg" class="control-label"> Weight (kg) </label>
        <input required type="number" class="form-control" id="weight_kg" placeholder="Enter weight (kg)" v-model="optData.weight_kg" />
        <div v-if="this.errors.weight_kg">
         <label style="color: red; font-weight: 500">{{ this.errors.weight_kg[0] }}</label>
        </div>
       </div>
      </div>

      <div class="col-sm-4">
       <div class="form-group">
        <label for="length_height_cm" class="control-label"> Length/Height (cm) </label>
        <input required type="number" class="form-control" id="length_height_cm" placeholder="Enter length/height (cm)" v-model="optData.length_height_cm" />
        <div v-if="this.errors.length_height_cm">
         <label style="color: red; font-weight: 500">{{ this.errors.length_height_cm[0] }}</label>
        </div>
       </div>
      </div>

      <div class="col-sm-4">
       <div class="form-group">
        <label for="weight_kg" class="control-label"> Weigth for Age </label>
        <select required class="form-select" name="weight_kg" id="weight_for_age" v-model="optData.weight_for_age">
         <option value="Normal">Normal</option>
         <option value="Underweight">Underweight</option>
         <option value="Severely Underweight">Severely Underweight</option>
         <option value="Overweight">Overweight</option>
        </select>
        <div v-if="this.errors.weight_for_age">
         <label style="color: red; font-weight: 500">{{ this.errors.weight_for_age[0] }}</label>
        </div>
       </div>
      </div>

      <div class="col-sm-4">
       <div class="form-group">
        <label for="length_height_cm" class="control-label"> Length/Height for Age </label>
        <select required class="form-select" name="length_height_cm" id="length_height_for_age" v-model="optData.length_height_for_age">
         <option value="Normal">Normal</option>
         <option value="Stunting">Stunting</option>
         <option value="Severely Stunting">Severely Stunting</option>
         <option value="Tall">Tall</option>
        </select>
        <div v-if="this.errors.length_height_for_age">
         <label style="color: red; font-weight: 500">{{ this.errors.length_height_for_age[0] }}</label>
        </div>
       </div>
      </div>

      <div class="col-sm-4">
       <div class="form-group">
        <label for="weight_for_length_height" class="control-label"> Weigth for Length/Height </label>
        <select required class="form-select" name="weight_for_length_height" id="weight_for_length_height" v-model="optData.weight_for_length_height">
         <option value="Normal">Normal</option>
         <option value="Waisted">Waisted</option>
         <option value="Severely Waisted">Severely Waisted</option>
         <option value="Overweight">Overweight</option>
         <option value="Obese">Obese</option>
        </select>
        <div v-if="this.errors.weight_for_length_height">
         <label style="color: red; font-weight: 500">{{ this.errors.weight_for_length_height[0] }}</label>
        </div>
       </div>
      </div>
     </div>
    </div>
    <div class="mt-4 d-flex justify-content-end" v-if="permission == 'bns'">
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
    optData: {
     purok: "",
     household_num: null,
     name_of_caregiver: "",
     preschooler_name: "",
     sex: "Male",
     birthdate: "",
     weight: null,
     length_height: null,
     age_in_months: null,
     weight_kg: null,
     length_height_cm: null,
     weight_for_age: "Normal",
     length_height_for_age: "Normal",
     weight_for_length_height: "Normal",
     remember_token: localStorage.getItem("token"),
    },
    optRecords: [],
    errors: [],

    search: "",
    loading: true,
    currentPage: 0,
    rows: 0,
    perPage: 0,

    permission: localStorage.getItem("permission"),
   };
  },

  methods: {
   async fetchOptRecords() {
    this.loading = true;
    await axios
     .get(`/opt-records?page=${this.currentPage}&search=${this.search}`)
     .then((response) => {
      this.optRecords = response.data.data;
      this.currentPage = response.data.current_page;
      this.rows = response.data.total;
      this.perPage = response.data.per_page;
     })
     .catch((error) => {
      return error.response;
     });
    this.loading = false;
   },

   async createOptRecord() {
    await axios
     .post("/new-opt-record", this.optData)
     .then(async () => {
      this.$toast.success("OPT record saved.");
      this.$bvModal.hide("modal-add");
      await this.fetchOptRecords();
     })
     .catch((error) => {
      this.errors = error.response.data.errors;
     });
   },

   async updateOptRecord() {
    await axios
     .put(`/update-opt-record/${this.optData.id}`, this.optData)
     .then(() => {
      this.$toast.success("OPT record updated.");
      this.$bvModal.hide("modal-view");
      this.fetchOptRecords();
     })
     .catch((error) => {
      this.errors = error.response.data.errors;
     });
   },

   async deleteOpt(id) {
    const data = {
     remember_token: localStorage.getItem("token"),
    };
    await axios
     .post(`/delete-opt-record/${id}`, data)
     .then(() => {
      this.$toast.success("OPT record deleted.");
      this.fetchOptRecords();
     })
     .catch((error) => {
      this.errors = error.response.data.errors;
     });
   },

   viewDetails(data) {
    this.optData = {
     id: data.id,
     purok: data.purok,
     weight: data.weight,
     household_num: data.household_num,
     name_of_caregiver: data.name_of_caregiver,
     preschooler_name: data.preschooler_name,
     sex: data.sex,
     birthdate: data.birthdate,
     length_height: data.length_height,
     age_in_months: data.age_in_months,
     weight_kg: data.weight_kg,
     length_height_cm: data.length_height_cm,
     weight_for_age: data.weight_for_age,
     length_height_for_age: data.length_height_for_age,
     weight_for_length_height: data.weight_for_length_height,
     remember_token: localStorage.getItem("token"),
    };
    this.$bvModal.show("modal-view");
   },

   closeViewDetails() {
    (this.optData = {
     purok: "",
     household_num: null,
     name_of_caregiver: "",
     preschooler_name: "",
     sex: "Male",
     birthdate: "",
     weight: null,
     length_height: null,
     age_in_months: null,
     weight_kg: null,
     length_height_cm: null,
     weight_for_age: "Normal",
     length_height_for_age: "Normal",
     weight_for_length_height: "Normal",
     remember_token: localStorage.getItem("token"),
    }),
     this.$bvModal.hide("modal-add");
    this.$bvModal.hide("modal-view");
   },
  },

  async mounted() {
   await this.fetchOptRecords();
  },
 };
</script>
