<template>
  <div class="container">
    <div class="page-header">
      <div class="row">
        <div class="col-lg-8 col-md-5">
          <h1>Mother Information</h1>
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
            <th scope="col">Full Name</th>
            <th scope="col">Birthday</th>
            <th scope="col">Age</th>
            <th scope="col">Sex</th>
            <th scope="col">NHTS 4ps/MCCT</th>
            <th scope="col">Family Planning</th>
            <th scope="col">Maternal Care and Services</th>
            <th scope="col">Did You Give birth this month?</th>
            <th scope="col">Date/Place of Delivery</th>
            <th scope="col">Type of Delivery</th>
            <th scope="col">Person who deliver</th>
            <th scope="col">Child Gender</th>
            <th scope="col">Birth Term</th>
            <th scope="col">Abortion/Miscarriage</th>
            <th scope="col">Experience 2 Postpartum Check Up with newborn</th>
            <th scope="col">Experience 2 Postpartum Check Up as pregnant</th>
            <th scope="col" v-if="permission != 'chairperson'">Action</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(member, index) in members" :key="index">

            <td>
              {{ member.household ? member.household.first_name :  member.household_head.first_name}}
              {{
                member.household ? (member.household.middle_name ? member.household.middle_name : "") : (member.household_head.middle_name ? member.household_head.middle_name : "")
              }}
              {{ member.household ? member.household.last_name : member.household_head.last_name }}
            </td>
            <td>{{ member.household ? member.household.birthdate : member.household_head.birthdate }} </td>
            <td>{{  member.household ? getAge(member.household.age) : getAge(member.household_head.age)}}</td>
            <td>{{  member.household ? member.household.sex : member.household_head.sex }}</td>

            <td>{{ member.nhts }}</td>
            <td>{{ member.family_planning }}</td>
            <td>{{ member.maternal_care_services }}</td>
            <td>{{ member.give_birth_this_month }}</td>
            <td>{{ member.delivery }}</td>
            <td>{{ member.delivery_type }}</td>
            <td>{{ member.person_who_deliver }}</td>
            <td>{{ member.child_gender }}</td>
            <td>{{ member.birth_term }}</td>
            <td>{{ member.is_miscarriage_or_abortion }}</td>
            <td>{{ member.postpartum_with_newborn }}</td>
            <td>{{ member.postpartum_as_pregnant }}</td>
            <td v-if="permission != 'chairperson'">
              <button class="btn btn-primary mb-2" @click="viewDetails(member)">
                Update Information
              </button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    <b-modal
      class="view_modal"
      id="mother-modal-view"
      title="Mother Information"
      centered
      :hide-footer="true"
    >
      <form @submit.prevent="updateEnv" class="row">
        <div class="col">
          <div class="col-12">
            <div class="form-group">
              <label for="nhts" class="control-label"> NHTS </label>
              <select
                class="form-select"
                name="nhts"
                id="nhts"
                v-model="envDetails.nhts"
              >
                <option value="" disabled selected>Select NHTS</option>
                <option value="4ps">4ps</option>
                <option value="MCCT">MCCT</option>
              </select>
              <div v-if="this.errors.nhts">
                <label style="color: red; font-weight: 500">{{
                  this.errors.nhts[0]
                }}</label>
              </div>
            </div>
          </div>
          <div class="col-12">
            <div class="form-group">
              <label for="nhts" class="control-label"> Family Planning </label>
              <select
                class="form-select"
                name="family_planning"
                id="family_planning"
                v-model="envDetails.family_planning"
              >
                <option value="" disabled selected>
                  Select Family Planning
                </option>
                <option value="WRA with unmet need for family planning">
                  WRA with unmet need for family planning
                </option>
                <option value="Female Sterilization/BTL">
                  Female Sterilization/BTL
                </option>
                <option value="Male Sterilization">Male Sterilization</option>
                <option value="Condom">Condom</option>
                <option value="Pills (POP)">Pills (POP)</option>
                <option value="Pills (COC)">Pills (COC)</option>
                <option value="Injectables">Injectables</option>
                <option value="IUD">IUD</option>
                <option value="LAM">LAM</option>
                <option value="N/A">N/A</option>
              </select>
              <div v-if="this.errors.family_planning">
                <label style="color: red; font-weight: 500">{{
                  this.errors.family_planning[0]
                }}</label>
              </div>
            </div>
          </div>
          <div class="col-12">
            <div class="form-group">
              <label for="maternal_care_services" class="control-label">
                Maternal Care and Services
              </label>
              <select
                class="form-select"
                name="maternal_care_services"
                id="maternal_care_services"
                v-model="envDetails.maternal_care_services"
              >
                <option value="" disabled selected>
                  Select Maternal Care and Services
                </option>
                <option value="Have at least 4 pre-natal check-up">
                  Have at least 4 pre-natal check-up
                </option>
                <option value="Referred to pre-natal care">
                  Referred to pre-natal care
                </option>
                <option value="Given 2 doses of TD vaccination">
                  Given 2 doses of TD vaccination
                </option>
                <option value="Given 3 doses of TD vaccination">
                  Given 3 doses of TD vaccination
                </option>
                <option value="N/A">N/A</option>
              </select>
              <div v-if="this.errors.maternal_care_services">
                <label style="color: red; font-weight: 500">{{
                  this.errors.maternal_care_services[0]
                }}</label>
              </div>
            </div>
          </div>
          <div class="col-12">
            <div class="form-group">
              <label for="give_birth_this_month" class="control-label"
                >Did You Give birth this month?</label
              >
              <select
                class="form-select"
                name="give_birth_this_month"
                id="give_birth_this_month"
                v-model="envDetails.give_birth_this_month"
              >
                <option value="yes">Yes</option>
                <option value="no">No</option>
              </select>
              <div v-if="this.errors.give_birth_this_month">
                <label style="color: red; font-weight: 500">{{
                  this.errors.give_birth_this_month[0]
                }}</label>
              </div>
            </div>
          </div>
          <div class="col-12">
            <div class="form-group">
              <label for="delivery" class="control-label"
                >Date/Place of Delivery</label
              >
              <input
                class="form-select"
                name="delivery"
                id="delivery"
                v-model="envDetails.delivery"
              />
              <div v-if="this.errors.delivery">
                <label style="color: red; font-weight: 500">{{
                  this.errors.delivery[0]
                }}</label>
              </div>
            </div>
          </div>
          <div class="col-12">
            <div class="form-group">
              <label for="delivery_type" class="control-label"
                >Type of Delivery</label
              >
              <select
                class="form-select"
                name="delivery_type"
                id="delivery_type"
                v-model="envDetails.delivery_type"
              >
                <option value="Normal Delivery">Normal Delivery</option>
                <option value="Cesarian">Cesarian</option>
              </select>
              <div v-if="this.errors.delivery_type">
                <label style="color: red; font-weight: 500">{{
                  this.errors.delivery_type[0]
                }}</label>
              </div>
            </div>
          </div>
          <div class="col-12">
            <div class="form-group">
              <label for="person_who_deliver" class="control-label"
                >Person who Deliver</label
              >
              <select
                class="form-select"
                name="person_who_deliver"
                id="person_who_deliver"
                v-model="envDetails.person_who_deliver"
              >
                <option value="Doctor">Doctor</option>
                <option value="Nurse">Nurse</option>
                <option value="Midwife">Midwife</option>
                <option value="Non-skilled health professionals">
                  Non-skilled health professionals
                </option>
              </select>
              <div v-if="this.errors.person_who_deliver">
                <label style="color: red; font-weight: 500">{{
                  this.errors.person_who_deliver[0]
                }}</label>
              </div>
            </div>
          </div>
          <div class="col-12">
            <div class="form-group">
              <label for="child_gender" class="control-label"
                >Child Gender</label
              >
              <select
                class="form-select"
                name="child_gender"
                id="child_gender"
                v-model="envDetails.child_gender"
              >
                <option value="Male">Male</option>
                <option value="Female">Female</option>
              </select>
              <div v-if="this.errors.child_gender">
                <label style="color: red; font-weight: 500">{{
                  this.errors.child_gender[0]
                }}</label>
              </div>
            </div>
          </div>
          <div class="col-12">
            <div class="form-group">
              <label for="birth_term" class="control-label">Birth Term</label>
              <select
                class="form-select"
                name="birth_term"
                id="birth_term"
                v-model="envDetails.birth_term"
              >
                <option value="Full Term">Full Term</option>
                <option value="Pre-term">Pre-term</option>
                <option value="Fetal Death">Fetal Death</option>
              </select>
              <div v-if="this.errors.birth_term">
                <label style="color: red; font-weight: 500">{{
                  this.errors.birth_term[0]
                }}</label>
              </div>
            </div>
          </div>
          <div class="col-12">
            <div class="form-group">
              <label for="is_miscarriage_or_abortion" class="control-label"
                >Abortion/Miscarriage</label
              >
              <select
                class="form-select"
                name="is_miscarriage_or_abortion"
                id="is_miscarriage_or_abortion"
                v-model="envDetails.is_miscarriage_or_abortion"
              >
                <option value="yes">Yes</option>
                <option value="no">No</option>
              </select>
              <div v-if="this.errors.is_miscarriage_or_abortion">
                <label style="color: red; font-weight: 500">{{
                  this.errors.is_miscarriage_or_abortion[0]
                }}</label>
              </div>
            </div>
          </div>
          <div class="col-12">
            <div class="form-group">
              <label for="postpartum_with_newborn" class="control-label"
                >Experience 2 Postpartum Check Up with newborn</label
              >
              <select
                class="form-select"
                name="postpartum_with_newborn"
                id="postpartum_with_newborn"
                v-model="envDetails.postpartum_with_newborn"
              >
                <option value="yes">Yes</option>
                <option value="no">No</option>
              </select>
              <div v-if="this.errors.postpartum_with_newborn">
                <label style="color: red; font-weight: 500">{{
                  this.errors.postpartum_with_newborn[0]
                }}</label>
              </div>
            </div>
          </div>
          <div class="col-12">
            <div class="form-group">
              <label for="postpartum_as_pregnant" class="control-label"
                >Experience 2 Postpartum Check Up as pregnant</label
              >
              <select
                class="form-select"
                name="postpartum_as_pregnant"
                id="postpartum_as_pregnant"
                v-model="envDetails.postpartum_as_pregnant"
              >
                <option value="yes">Yes</option>
                <option value="no">No</option>
              </select>
              <div v-if="this.errors.postpartum_as_pregnant">
                <label style="color: red; font-weight: 500">{{
                  this.errors.postpartum_as_pregnant[0]
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
      members: [],
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
        .get(`/all-mother-info?page=${this.currentPage}&search=${this.search}`)
        .then((response) => {
          this.members = response.data.data;
          this.currentPage = response.data.current_page;
          this.rows = response.data.total;
          this.perPage = response.data.per_page;
        })
        .catch((error) => {
          return error.response;
        });
      this.loading = false;
    },

  getAge(birthdate) {
      let age = moment().diff(birthdate, 'years');
      return age >= 1 ? age : 0
    },
    async updateEnv() {
      const data  = {
        id: this.envDetails.id,
        household_head_member_id: this.envDetails.household_head_member_id,
        household_head_id: this.envDetails.household_head_id,
        nhts: this.envDetails.nhts,
        family_planning: this.envDetails.family_planning,
        maternal_care_services: this.envDetails.maternal_care_services,
        give_birth_this_month: this.envDetails.give_birth_this_month,
        delivery: this.envDetails.delivery,
        delivery_type: this.envDetails.delivery_type,
        person_who_deliver: this.envDetails.person_who_deliver,
        child_gender: this.envDetails.child_gender,
        birth_term: this.envDetails.birth_term,
        is_miscarriage_or_abortion: this.envDetails.is_miscarriage_or_abortion,
        postpartum_with_newborn: this.envDetails.postpartum_with_newborn,
        postpartum_as_pregnant: this.envDetails.postpartum_as_pregnant,
        remember_token: localStorage.getItem("token"),
      };
      this.loading = true;
      this.$bvModal.hide("mother-modal-view");
      await axios
        .put(`/update-mother-record/${data.id}`, data)
        .then(async () => {
          this.$toast.success("Mother record has been updated.");
          this.closeViewDetails();
          await this.fetchHouseholdEnv();
        })
        .catch((error) => {
          this.errors = error.response.data.errors;
        });
    },

    viewDetails(data) {
      this.envDetails = data;
      this.$bvModal.show("mother-modal-view");
    },

    closeViewDetails() {
      this.envDetails = {};
      this.$bvModal.hide("mother-modal-view");
    },
  },

  mounted() {
    this.fetchHouseholdEnv();
  },
};
</script>
