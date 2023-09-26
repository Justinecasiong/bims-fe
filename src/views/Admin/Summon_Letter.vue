<template>
  <div class="container">
    <div class="page-header">
      <div class="row">
        <div class="col-lg-8 col-md-5">
          <h1>Summon Letter</h1>
        </div>
        <div class="col search">
          <div class="input-group">
            <input
              required
              type="text"
              class="form-control"
              placeholder="Search"
              v-model="search"
              v-on:input="fetchSummonRecord()"
            />
          </div>
        </div>
      </div>
    </div>
    <div class="table-container table-responsive-xxl shadow">
      <button
        class="btn btn-primary mb-3"
        v-b-modal.modal-add
        v-if="
          permission == 'chairperson' ||
          permission == 'kagawad' ||
          permission == 'secretary' ||
          permission == 'admin'
        "
      >
        Add Summon Letter
      </button>
      <div class="d-flex justify-content-center" v-if="loading">
        <div class="spinner-border text-center mt-3" role="status"></div>
      </div>
      <table class="table table-striped table-hover table-sm" v-if="!loading">
        <thead>
          <tr>
            <th scope="col">Complainant</th>
            <th scope="col">Respondent</th>
            <th scope="col">Barangay Case Number</th>
            <th scope="col">Date and Time</th>
            <th scope="col">Action</th>
          </tr>
        </thead>

        <tbody>
          <tr v-for="(summon, index) in summonRecords" :key="index">
            <td>{{ summon.complainant }}</td>
            <td>{{ summon.respondent }}</td>
            <td>{{ summon.brgy_case_number }}</td>
            <td>
              {{ filterDate(summon.date) }} @ {{ filterTime(summon.time) }}
            </td>
            <td class="d-flex flex-row">
              <button class="btn btn-primary" @click="viewDetails(summon)">
                View Details
              </button>
              <button class="btn btn-success" @click="printSummon(summon)">
                Print Summon Letter
              </button>
            </td>
          </tr>
        </tbody>
      </table>
      <div class="mt-3">
          <b-pagination
            v-model="currentPage"
            prev-text="Prev"
            next-text="Next"
            :total-rows="rows"
            :per-page="perPage"
            align="center"
            v-on:input="fetchSummonRecord()"
            style="align-items: flex-end"
          ></b-pagination>
        </div>
    </div>

    <b-modal
      class="add_modal"
      id="modal-add"
      title="Add Summon Letter"
      centered
      :hide-footer="true"
    >
      <form @submit.prevent="createSummonRecord" class="col">
        <div class="form-group">
          <label for="complainant" class="control-label"> Complainant </label>
          <input
            required
            type="text"
            class="form-control"
            id="complainant"
            placeholder="Enter complainant"
            v-model="summonData.complainant"
          />
          <div v-if="this.errors.complainant">
            <label style="color: red; font-weight: 500">{{
              this.errors.complainant[0]
            }}</label>
          </div>
        </div>
        <div class="form-group">
          <label for="respondent" class="control-label"> Respondent </label>
          <input
            required
            type="text"
            class="form-control"
            id="respondent"
            placeholder="Enter respondent"
            v-model="summonData.respondent"
          />
          <div v-if="this.errors.respondent">
            <label style="color: red; font-weight: 500">{{
              this.errors.respondent[0]
            }}</label>
          </div>
        </div>
        <div class="form-group">
          <label for="brgy_case_number" class="control-label">
            Barangay Case Number
          </label>
          <input
            required
            type="text"
            class="form-control"
            id="brgy_case_number"
            placeholder="Enter barangay case number"
            v-model="summonData.brgy_case_number"
          />
          <div v-if="this.errors.brgy_case_number">
            <label style="color: red; font-weight: 500">{{
              this.errors.brgy_case_number[0]
            }}</label>
          </div>
        </div>
        <div class="form-group">
          <label for="date" class="control-label"> Date</label>
          <input
            required
            type="date"
            class="form-control"
            id="date"
            placeholder="Enter date"
            v-model="summonData.date"
          />
          <div v-if="this.errors.date">
            <label style="color: red; font-weight: 500">{{
              this.errors.date[0]
            }}</label>
          </div>
        </div>
        <div class="form-group">
          <label for="time" class="control-label"> Time</label>
          <input
            required
            type="time"
            class="form-control"
            id="time"
            placeholder="Enter time"
            v-model="summonData.time"
          />
          <div v-if="this.errors.time">
            <label style="color: red; font-weight: 500">{{
              this.errors.time[0]
            }}</label>
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
          <button class="btn btn-primary" type="submit">
            Create Summon Letter
          </button>
        </div>
      </form>
    </b-modal>
    <b-modal
      class="update_modal"
      id="modal-view"
      title="Update Summon Letter"
      centered
      :hide-footer="true"
    >
      <form @submit.prevent="updateSummonRecord" class="col">
        <div class="form-group">
          <label for="complainant" class="control-label"> Complainant </label>
          <input
            required
            type="text"
            class="form-control"
            id="complainant"
            placeholder="Enter complainant"
            v-model="summonData.complainant"
          />
          <div v-if="this.errors.complainant">
            <label style="color: red; font-weight: 500">{{
              this.errors.complainant[0]
            }}</label>
          </div>
        </div>
        <div class="form-group">
          <label for="respondent" class="control-label"> Respondent </label>
          <input
            required
            type="text"
            class="form-control"
            id="respondent"
            placeholder="Enter respondent"
            v-model="summonData.respondent"
          />
          <div v-if="this.errors.respondent">
            <label style="color: red; font-weight: 500">{{
              this.errors.respondent[0]
            }}</label>
          </div>
        </div>
        <div class="form-group">
          <label for="brgy_case_number" class="control-label">
            Barangay Case Number
          </label>
          <input
            required
            type="text"
            class="form-control"
            id="brgy_case_number"
            placeholder="Enter barangay case number"
            v-model="summonData.brgy_case_number"
          />
          <div v-if="this.errors.brgy_case_number">
            <label style="color: red; font-weight: 500">{{
              this.errors.brgy_case_number[0]
            }}</label>
          </div>
        </div>
        <div class="form-group">
          <label for="date" class="control-label"> Date</label>
          <input
            required
            type="date"
            class="form-control"
            id="date"
            placeholder="Enter date"
            v-model="summonData.date"
          />
          <div v-if="this.errors.date">
            <label style="color: red; font-weight: 500">{{
              this.errors.date[0]
            }}</label>
          </div>
        </div>
        <div class="form-group">
          <label for="time" class="control-label"> Time</label>
          <input
            required
            type="time"
            class="form-control"
            id="time"
            placeholder="Enter time"
            v-model="summonData.time"
          />
          <div v-if="this.errors.time">
            <label style="color: red; font-weight: 500">{{
              this.errors.time[0]
            }}</label>
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
          <button class="btn btn-primary" type="submit">
            Create Summon Letter
          </button>
        </div>
      </form>
    </b-modal>
    <b-modal
      size="xl"
      id="modal-print-preview"
      title="Print Preview"
      centered
      @hidden="resetFields()"
      :hide-footer="true"
    >
      <button class="btn btn-primary" v-print="'#summonLetter'">Print</button>
      <div id="summonLetter" style=" font-size: 12px;">
        <div style="text-align: center" class="mt-5">
        <table style="width: 100%; border: none">
          <tr>
            <td>
              <div class="left-logo">
                <img
                  class="logo"
                  :src="require('../../assets/images/brgylogo.jpg')"
                  width="120"
                />
              </div>
            </td>

            <td>
              <div class="header-top">
                <h5 style="font-size: 14pt">Republic of the Philippines</h5>
                <h5 style="font-size: 14pt">Province of LEYTE</h5>
                <h5 style="font-size: 14pt">TACLOBAN CITY</h5>
                <h3 style="font-weight: bold; font-size: 14pt">
                  STO. NIÑO EXTENSION, BARANGAY 6-A
                </h3>
                <h6 style="font-style: italic; font-size: 14pt">
                  Mobile No. (053) 300 - 2436
                </h6>
              </div>
            </td>
            <td>
              <div class="col-lg-4 right-logo">
                <img
                  class="logo"
                  :src="require('../../assets/images/taclogo.png')"
                  width="110"
                />
              </div>
            </td>
          </tr>
        </table>
      </div>
        <div class="container-fluid text-center" style="padding: 20px 50px">
          <span style="font-weight: bold">
            OFFICE OF THE LUPONG TAGAPAMAYAPA</span
          >
        </div>
        <div class="row justify-content-between" style="padding: 0 50px">
          <div class="col">
            <br />
            <div style="max-width: 250px; text-align: center">
              <span>{{ this.summonData.complainant.toUpperCase() }}</span>
            </div>
            <div
              style="
                border-top: 1px solid black;
                max-width: 250px;
                text-align: center;
                font-weight: 600;
              "
            >
              Complainant/s
            </div>
            <div
              style="max-width: 250px; text-align: center; padding: 10px 0px"
            >
              <span>-against-</span>
            </div>
            <div style="max-width: 250px; text-align: center">
              <span>{{ this.summonData.respondent.toUpperCase() }}</span>
            </div>
            <div
              style="
                border-top: 1px solid black;
                max-width: 250px;
                text-align: center;
                font-weight: 600;
              "
            >
              Respondent
            </div>
          </div>
          <div class="col">
            <div class="d-flex justify-content-end">
              <div class="col" style="max-width: 180px; margin-left: 70px">
                <span style="white-space: nowrap">Barangay Case No :</span
                ><br />
                <span>For :</span><br />
              </div>
              <div class="col">
                <div
                  style="
                    min-height: 21px;
                    border-bottom: 1px solid black;
                    padding: 0 10px;
                  "
                >
                  {{ this.summonData.brgy_case_number.toUpperCase() }}
                </div>
                <div
                  style="
                    min-height: 21px;
                    border-bottom: 1px solid black;
                    padding: 0 10px;
                  "
                ></div>
                <div
                  style="
                    min-height: 21px;
                    border-bottom: 1px solid black;
                    padding: 0 10px;
                  "
                ></div>
              </div>
            </div>
          </div>
        </div>
        <div class="container-fluid text-center" style="padding: 0 50px">
          <span
            style="
              font-weight: bold;
              font-family: cursive;
              letter-spacing: 5px;
              font-size: 16px;
            "
            >SUMMONS</span
          >
        </div>
        <div class="container-fluid" style="padding: 20px 50px">
          <span> TO: {{ this.summonData.respondent.toUpperCase() }}</span
          ><br />
          <span style="font-weight: 600px; margin-left: 30px">Respondent</span>
        </div>
        <div class="container-fluid" style="padding: 0 50px; line-height: 1.3;">
          <p style="text-indent: 2cm">
            You are hereby summoned to appear before me in person, together with
            your witnesses, on the
            <b>{{ getDate(this.summonData.date) }}</b> day of
            <b>{{ getMonthYear(this.summonData.date) }}</b> at
            <b>{{ filterTime(this.summonData.time) }}</b
            >, then and there to answer to a complaint made before me, copy of
            which is attached, for mediation of your dispute with complainant/s.
          </p>
          <p style="text-indent: 2cm">
            You are hereby warned that if you refuse or willfully fail to appear
            in obedience to the summons, you may be barred from filing any
            counterclaim arising from said complaint.
          </p>
          <p style="text-indent: 2cm">
            FAIL NOT or else face punishment as for contempt of court.
          </p>
          <p style="text-indent: 2cm">
            This <b>{{ getDate(this.summonData.date) }}</b> day of
            <b>{{ getMonthYear(this.summonData.date) }}</b
            >.
          </p>
        </div>

        <div
          class="container-fluid d-flex flex-row-reverse"
          style="padding: 0 100px"
        >
          <div
            style="
              text-align: center;
              min-width: 350px;
              text-underline-offset: 3px;
              text-decoration: underline;
              text-align: center;
              font-weight: 600;
            "
          >
            {{ this.chairman[0].fullname.toUpperCase() }}
          </div>
        </div>
        <div
          class="container-fluid d-flex flex-row-reverse"
          style="padding: 0 100px"
        >
          <div style="min-width: 350px; text-align: center; font-weight: 600">
            Punong Barangay/Lupon Chairman
          </div>
        </div>
        <div
          class="container-fluid text-center"
          style="padding: 0 50px; padding-top: 10px"
        >
          <span
            style="
              font-weight: bold;
              font-family: cursive;
              letter-spacing: 5px;
              font-size: 16px;
            "
          >
            OFFICER'S RETURN</span
          >
        </div>
        <div class="container-fluid" style="padding: 0 50px; font-size: 12px;">
          <p style="text-indent: 2cm">
            I served this summon upon respondent
            <b>{{ this.summonData.respondent.toUpperCase() }}</b> on the
            <b>{{ getDate(this.summonData.date) }}</b> day of
            <b>{{ getMonthYear(this.summonData.date) }}</b> at
            <b>{{ filterTime(this.summonData.time) }}</b
            >.
          </p>
        </div>
        <div class="container-fluid text-center" style="padding;0 50px">
          <span style="font-weight: bold"> Respondent/s</span>
        </div>
        <div class="container-fluid" style="padding: 0 50px">
          <span
            >_____________1. Handling to him/her/them said summons in person,
            or</span
          ><br />
          <span
            >_____________2. Handling to him/her/them said summons and
            he/she/they refused to received it, or</span
          ><br />
          <span
            >_____________3. Leaving said summons at his/her/their dwelling with
            ____________________________.</span
          ><br />
          <span
            >_____________4. Leaving said summons at his/her/their office/place
            of business with ____________________________ a competent person in
            charge thereof.</span
          ><br />
        </div>
        <div
          class="container-fluid d-flex flex-row-reverse"
          style="padding: 0 100px"
        >
          <div
            style="
              position: absolute;
              margin-top: 15px;
              border-top: 1px solid black;
              min-width: 100px;
              text-align: center;
              font-weight: 600;
            "
          >
            Officer
          </div>
        </div>
        <div class="container-fluid" style="padding: 0 50px; padding-top: 20px">
          <span style="font-weight: bold"
            >Received By Respondent/representative:</span
          ><br />
          <div class="row justify-content-between">
            <div class="col" style="max-width: 300px">
              <div
                style="
                  border-top: 1px solid black;
                  text-align: center;
                  font-weight: 600;
                  margin-top: 30px;
                "
              >
                (Signature)
              </div>
              <div
                style="
                  border-top: 1px solid black;
                  text-align: center;
                  font-weight: 600;
                  margin-top: 30px;
                "
              >
                (Signature)
              </div>
            </div>
            <div class="col" style="max-width: 300px">
              <div
                style="
                  border-top: 1px solid black;
                  text-align: center;
                  font-weight: 600;
                  margin-top: 30px;
                "
              >
                (Date)
              </div>
              <div
                style="
                  border-top: 1px solid black;
                  text-align: center;
                  font-weight: 600;
                  margin-top: 30px;
                "
              >
                (Date)
              </div>
            </div>
          </div>
        </div>
      </div>
    </b-modal>

    <b-modal
      id="modal-letter-payment"
      size="md"
      title="Certification Payment"
      centered
      @ok.prevent="generateCertificate()"
      ok-only
      ok-title="Generate"
    >
      <div class="form-group">
        <label for="certification_request" class="control-label">
          Amount:
        </label>
        <input type="number" v-model="payment.amount" class="form-control" />
      </div>
      <div class="form-group">
        <label for="certification_request" class="control-label">
          Payment Details:
        </label>
        <input
          type="text"
          v-model="payment.payment_detail"
          class="form-control"
          disabled
        />
      </div>
    </b-modal>
  </div>
</template>

<script>
import axios from "../../axios";
import moment from "moment";
import Print from "vue-print-nb";
export default {
  directives: {
    Print,
  },

  data() {
    return {
      summonData: {
        complainant: "",
        respondent: "",
        brgy_case_number: "",
        is_paid: false,
        date: "",
        time: "",
        remember_token: localStorage.getItem("token"),
      },
      tempSummonData: {
        complainant: "",
        respondent: "",
        brgy_case_number: "",
        is_paid: false,
        date: "",
        time: "",
        remember_token: localStorage.getItem("token"),
      },
      payment: {
        amount: null,
        payment_detail: null,
      },

      summonRecords: [],
      errors: [],

      officials: [],
      search: "",
      loading: true,
      currentPage: 0,
      rows: 0,
      perPage: 0,

      permission: localStorage.getItem("permission"),
    };
  },

  computed: {
    chairman() {
      return this.officials.filter((data) => {
        return data.position.position_description.match("Chairperson");
      });
    },
  },

  methods: {
    getDate(value) {
      let date = moment(value).format("DD");
      return moment.localeData().ordinal(date);
    },
    filterTime(time) {
      return moment(time, [moment.ISO_8601, "HH:mm"]).format("LT");
    },
    getMonthYear(value) {
      return moment(value).format("MMMM, YYYY");
    },
    filterDate(date) {
      return moment(date).format("LL");
    },
    async fetchSummonRecord() {
      await axios
        .get(`/summon-records?page=${this.currentPage}&search=${this.search}`)
        .then((response) => {
          this.summonRecords = response.data.data;
          this.currentPage = response.data.current_page;
          this.rows = response.data.total;
          this.perPage = response.data.per_page;
        })
        .catch((error) => {
          return error.response;
        });
      this.loading = false;
    },

    async createSummonRecord() {
      await axios
        .post("/new-summon-record", this.summonData)
        .then(async () => {
          this.$toast.success("Summon record saved.");
          this.$bvModal.hide("modal-add");
          await this.fetchSummonRecord();
        })
        .catch((error) => {
          this.errors = error.response.data.errors;
        });
    },

    async updateSummonRecord() {
      await axios
        .put(`/update-summon-record/${this.summonData.id}`, this.summonData)
        .then(() => {
          this.$toast.success("Summon record updated.");
          this.$bvModal.hide("modal-view");
          this.fetchSummonRecord();
        })
        .catch((error) => {
          this.errors = error.response.data.errors;
        });
    },

    async deleteSummon(id) {
      const data = {
        remember_token: localStorage.getItem("token"),
      };
      await axios
        .post(`/delete-summon-record/${id}`, data)
        .then(() => {
          this.$toast.success("Summon record deleted.");
          this.fetchSummonRecord();
        })
        .catch((error) => {
          this.errors = error.response.data.errors;
        });
    },

    async fetchOfficial() {
      this.loading = true;
      await axios
        .get(`/barangay_officals?page=${this.currentPage}`)
        .then((response) => {
          this.officials = response.data.data;
        })
        .catch((error) => {
          return error.response;
        });
      this.loading = false;
    },

    printSummon(data) {
      this.summonData = {
        id: data.id,
        complainant: data.complainant,
        respondent: data.respondent,
        brgy_case_number: data.brgy_case_number,
        is_paid: data.is_paid,
        date: data.date,
        time: data.time,
        remember_token: localStorage.getItem("token"),
      };
      this.tempSummonData = this.summonData;
      console.log(this.summonData);
      data.is_paid ? this.printLetter() : this.certPayment();
    },

    printLetter() {
      this.$bvModal.show("modal-print-preview");
    },

    certPayment() {
      this.payment = {
        amount: null,
        payment_detail: "Summon Letter",
      };
      this.$bvModal.show("modal-letter-payment");
    },

    viewDetails(data) {
      this.summonData = {
        id: data.id,
        complainant: data.complainant,
        respondent: data.respondent,
        brgy_case_number: data.brgy_case_number,
        is_paid: data.is_paid,
        date: data.date,
        time: data.time,
        remember_token: localStorage.getItem("token"),
      };
      this.$bvModal.show("modal-view");
    },

    closeViewDetails() {
      (this.summonData = {
        complainant: "",
        respondent: "",
        brgy_case_number: "",
        is_paid: false,
        date: "",
        time: "",
        remember_token: localStorage.getItem("token"),
      }),
        this.$bvModal.hide("modal-add");
      this.$bvModal.hide("modal-view");
    },

    generateCertificate() {
      var data = {
        custom_recipient: this.summonData.complainant,
        amount: this.payment.amount,
        details: this.payment.payment_detail,
        mode_of_payment: "Via Barangay Hall",
        remember_token: localStorage.getItem("token"),
        date: new Date(
          new Date().getTime() - new Date().getTimezoneOffset() * 60000
        )
          .toISOString()
          .split("T")[0],
      };

      axios.post("/revenue", data).then(() => {
        this.$bvModal.hide("modal-letter-payment");
        this.$toast.success("Summon Letter payment has been successful.");
        this.tempSummonData.is_paid = true;
        this.updateSummonRecord();
        this.printSummon(this.tempSummonData);
      });
    },

    async resetFields() {
      this.summonData = {
        complainant: "",
        respondent: "",
        brgy_case_number: "",
        is_paid: false,
        date: "",
        time: "",
        remember_token: localStorage.getItem("token"),
      };
      this.payment = {
        amount: null,
        payment_detail: null,
      };
    },
  },

  async mounted() {
    this.fetchOfficial();
    await this.fetchSummonRecord();
  },
};
</script>
