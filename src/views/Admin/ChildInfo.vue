<template>
  <div class="container">
    <div class="page-header">
      <div class="row">
        <div class="col-lg-8 col-md-5">
          <h1>Child Information</h1>
        </div>
        <div class="col search">
          <div class="input-group">
            <input
              type="text"
              class="form-control"
              placeholder="Search"
              v-model="search"
              v-on:input="fetchHouseholdEnv"
            />
          </div>
        </div>
      </div>
    </div>
    <div
      class="table-container table-responsive-xl shadow"
      style="overflow-x: auto"
    >
      <div class="d-flex justify-content-center" v-if="loading">
        <div class="spinner-border text-center mt-3" role="status"></div>
      </div>
      <table class="table table-striped table-hover table-sm" v-if="!loading">
        <thead>
          <tr>
            <th scope="col">Child Name</th>
            <th scope="col">Birthday</th>
            <th scope="col">Age</th>
            <th scope="col">Sex</th>
            <th scope="col">Vaccine Given</th>
            <th scope="col">FIC</th>
            <th scope="col">CIC</th>
            <th scope="col">Exclusive Breastfeeding</th>
            <th scope="col">Given Deworming</th>
            <th scope="col">Given Vitamin A Supplementation</th>
            <th scope="col">Nutritional Status</th>
            <th scope="col" v-if="permission != 'chairperson'">Action</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(envs, index) in householdEnvs" :key="index">
            <td>
              {{ envs.household.first_name }}
              {{
                envs.household.middle_name ? envs.household.middle_name : ""
              }}
              {{ envs.household.last_name }}
            </td>
            <td>{{ envs.household.birthdate }}</td>
            <td>{{ getAge(envs.household.birthdate) }}</td>
            <td>{{ envs.household.sex }}</td>
            <td>{{ envs.vaccine_given }}</td>
            <td>{{ envs.fic }}</td>
            <td>{{ envs.cic }}</td>
            <td>{{ envs.exclusive_bf }}</td>
            <td>{{ envs.dewormed }}</td>
            <td>{{ envs.given_vitamin_sipplementation }}</td>
            <td>{{ envs.nutritional_status }}</td>
            <td v-if="permission != 'chairperson'">
              <button class="btn btn-primary mb-2" @click="viewDetails(envs)">
                Update Information
              </button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    <b-modal
      class="view_modal"
      id="modal-view"
      title="Child Health Information"
      centered
      :hide-footer="true"
    >
      <form @submit.prevent="updateEnv" class="row">
        <div class="col">
          <div class="col-12">
            <div class="form-group">
              <label for="vaccine_given" class="control-label">
                Vaccine Given
              </label>
              <select
                class="form-select"
                name="vaccine_given"
                id="vaccine_given"
                v-model="envDetails.vaccine_given"
              >
                <option value="BCG">BCG</option>
                <option value="Hepa B within 24 Hours">
                  Hepa B within 24 Hours
                </option>
                <option value="Pentavalent 1">Pentavalent 1</option>
                <option value="Pentavalent 2">Pentavalent 2</option>
                <option value="Pentavalent 3">Pentavalent 3</option>
                <option value="Oral Polio Vaccine 1">
                  Oral Polio Vaccine 1
                </option>
                <option value="Oral Polio Vaccine 2">
                  Oral Polio Vaccine 2
                </option>
                <option value="Oral Polio Vaccine 3">
                  Oral Polio Vaccine 3
                </option>
                <option value="Inactivated Polio Vaccine 1">
                  Inactivated Polio Vaccine 1
                </option>
                <option value="Inactivated Polio Vaccine 2">
                  Inactivated Polio Vaccine 2
                </option>
                <option value="Pneumococcal Conjugate Vaccine 1">
                  Pneumococcal Conjugate Vaccine 1
                </option>
                <option value="Pneumococcal Conjugate Vaccine 2">
                  Pneumococcal Conjugate Vaccine 2
                </option>
                <option value="MMR 1">MMR 1</option>
                <option value="MMR 2">MMR 2</option>
              </select>
              <div v-if="this.errors.vaccine_given">
                <label style="color: red; font-weight: 500">{{
                  this.errors.vaccine_given[0]
                }}</label>
              </div>
            </div>
          </div>
          <div class="col-12">
            <div class="form-group">
              <label for="fic" class="control-label"> FIC </label>
              <select
                class="form-select"
                name="fic"
                id="fic"
                v-model="envDetails.fic"
              >
                <option value="Yes">Yes</option>
                <option value="No">No</option>
              </select>
              <div v-if="this.errors.fic">
                <label style="color: red; font-weight: 500">{{
                  this.errors.fic[0]
                }}</label>
              </div>
            </div>
          </div>
          <div class="col-12">
            <div class="form-group">
              <label for="cic" class="control-label"> CIC </label>
              <select
                class="form-select"
                name="cic"
                id="cic"
                v-model="envDetails.cic"
              >
                <option value="Yes">Yes</option>
                <option value="No">No</option>
              </select>
              <div v-if="this.errors.cic">
                <label style="color: red; font-weight: 500">{{
                  this.errors.cic[0]
                }}</label>
              </div>
            </div>
          </div>
          <div class="col-12">
            <div class="form-group">
              <label for="exclusive_bf" class="control-label">
                Exclusive Breastfeeding
              </label>
              <select
                class="form-select"
                name="exclusive_bf"
                id="exclusive_bf"
                v-model="envDetails.exclusive_bf"
              >
                <option value="Yes">Yes</option>
                <option value="No">No</option>
              </select>
              <div v-if="this.errors.exclusive_bf">
                <label style="color: red; font-weight: 500">{{
                  this.errors.exclusive_bf[0]
                }}</label>
              </div>
            </div>
          </div>
          <div class="col-12">
            <div class="form-group">
              <label for="dewormed" class="control-label">
                Given Deworming
              </label>
              <select
                class="form-select"
                name="dewormed"
                id="dewormed"
                v-model="envDetails.dewormed"
              >
                <option value="Yes">Yes</option>
                <option value="No">No</option>
              </select>
              <div v-if="this.errors.dewormed">
                <label style="color: red; font-weight: 500">{{
                  this.errors.dewormed[0]
                }}</label>
              </div>
            </div>
          </div>
          <div class="col-12">
            <div class="form-group">
              <label for="nutritional_status" class="control-label">
                Nutritional Status
              </label>
              <select
                class="form-select"
                name="nutritional_status"
                id="nutritional_status"
                v-model="envDetails.nutritional_status"
              >
                <option value="Stunted">Stunted</option>
                <option value="Malnourished">Malnourished</option>
                <option value="Obese">Obese</option>
              </select>
              <div v-if="this.errors.nutritional_status">
                <label style="color: red; font-weight: 500">{{
                  this.errors.nutritional_status[0]
                }}</label>
              </div>
            </div>
          </div>
        </div>
        <div class="mt-4 d-flex justify-content-end">
          <button
            class="btn btn-danger"
            type="button"
            @click="closeViewDetails"
          >
            Cancel
          </button>
          <button class="btn btn-primary" type="submit">Update Record</button>
        </div>
      </form>
    </b-modal>
  </div>
</template>

<script>
import axios from "../../axios";
import moment from "moment";
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
        .get(`/all-child-info?page=${this.currentPage}&search=${this.search}`)
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
        household_head_member_id: this.envDetails.household_head_member_id,
        vaccine_given: this.envDetails.vaccine_given,
        fic: this.envDetails.fic,
        cic: this.envDetails.cic,
        exclusive_bf: this.envDetails.exclusive_bf,
        dewormed: this.envDetails.dewormed,
        given_vitamin_sipplementation:
          this.envDetails.given_vitamin_sipplementation,
        nutritional_status: this.envDetails.nutritional_status,
        remember_token: localStorage.getItem("token"),
      };
      this.loading = true;
      this.$bvModal.hide("modal-view");
      await axios
        .put(`/update-child-health-record/${data.id}`, data)
        .then(async () => {
          this.$toast.success("Child health record has been updated.");
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

    getAge(birthdate) {
      let age = moment().diff(birthdate, 'years');
      return age >= 1 ? age : 0
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
