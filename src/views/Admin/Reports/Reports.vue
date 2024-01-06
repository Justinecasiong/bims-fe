<template>
    <div class="container">
        <div class="page-header">
            <div class="row">
                <div class="col-10">
                    <h1>Reports</h1>
                </div>
            </div>
            <div>
                <button class="btn btn-primary mb-3" v-b-modal.modal-add>
                    Create Report Type
                </button>
            </div>
            <div class="row">
                <div class="col-3" style="cursor: pointer" v-for="reportType in reportTypes" :key="reportType.id">
                    <div class="card card-round text-white" style="margin-top: 10px; background-color: #459a7d"
                        @click="goToReportList(reportType)">
                        <card-body name="card">
                            <center>
                                <h5>{{ reportType.name }}</h5>
                            </center>
                        </card-body>
                    </div>
                </div>
            </div>
        </div>

        <b-modal id="modal-add" size="md" title="Create Report Type" centered @ok.prevent="createReportType()"
            ok-title="Create">
            <div>
                Enter report type name
                <input v-model="reportType" type="text" class="form-control" name="report_type" id="report_type" />
            </div>
        </b-modal>
    </div>
</template>
<script>
import axios from "../../../axios";
export default {
    data() {
        return {
            id: null,
            users: [],
            reportTypes: [],
            reportType: null,

            search: "",
            loading: false,
            permission: localStorage.getItem("permission"),
        };
    },

    methods: {

        async createReportType() {
            await axios
                .post(`/add-report-type`, { name: this.reportType })
                .then(() => {
                    this.$bvModal.hide("modal-add");
                    this.fetchReportTypes();
                })
                .catch((error) => {
                    this.errors = error.response.data.errors;
                });
        },

        async fetchUsers() {
            this.loading = true;
            await axios
                .get(`/getOfficials`)
                .then((response) => {
                    this.users = response.data;
                })
                .catch((error) => {
                    return error.response;
                });
            this.loading = false;
        },

        async fetchReportTypes() {
            this.loading = true;
            await axios
                .get(`/get-all-report-type`)
                .then((response) => {
                    this.reportTypes = response.data;
                })
                .catch((error) => {
                    return error.response;
                });
            this.loading = false;
        },

        async findOfficial() {
            const data = {
                remember_token: localStorage.getItem("token"),
            };
            await axios.post(`/find-officials`, data).then((response) => {
                this.users.push(response.data.officials);
            });
        },

        async findUsers() {
            this.loading = true;
            await axios
                .get(`/getOfficials`)
                .then((response) => {
                    this.users = response.data;
                })
                .catch((error) => {
                    return error.response;
                });
            this.loading = false;
        },

        goToReportList(data) {
            this.$router.push({
                path: `/reports/list/${data.id}`,
            });
        },
    },

    mounted() {
        this.fetchReportTypes();
        // if (this.permission == "chairperson") {
        //     this.fetchUsers();
        // } else {
        //     this.findOfficial();
        // }
    },
};
</script>