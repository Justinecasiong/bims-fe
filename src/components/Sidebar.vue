<template>
 <div class="wrapper">
  <div
   id="mySidebar"
   class="sidebar"
   @mouseover="toggleSidebar()"
   @mouseout="toggleSidebar()"
  >
   <div
    class="sidebar-header"
    style="text-align: center"
   >
    <img
     id="profile-pic"
     class="profile-image"
     :src="require('../assets/images/brgylogo.png')"
     height="60"
    />
    <p
     style="color: white; margin-top: 10px; pointer-events: none"
     v-if="!mini"
    >
     Barangay Information <br />
     System Management
    </p>
   </div>

   <a v-if="permission == 'admin' ">
    <router-link :to="{ name: 'Logs' }">
     <i class="fas fa-bars"></i>
     <span class="menu-label">Dashboard</span>
    </router-link>
   </a>
   <a v-if="permission != 'admin'">
    <router-link :to="{ name: 'Dashboard' }">
     <i class="fas fa-bars"></i>
     <span class="menu-label">Dashboard</span>
    </router-link>
   </a>
   <a
    v-if="
     permission == 'kagawad' ||
     permission == 'treasurer' ||
     permission == 'chairperson' ||
     permission == 'secretary' ||
     permission == 'treasurer' ||
     permission == 'admin' ||
     permission == 'resident' ||
     permission == 'bspo' ||
     permission == 'bns' ||
     permission == 'sk chairman' || 
     permission == 'bhw'
    "
   >
    <router-link :to="{ name: 'Barangay_Officials' }">
     <i class="fas fa-user-tie"></i>
     <span class="menu-label">Barangay Officials</span>
    </router-link>
   </a>

   <a v-if="permission == 'kagawad' || permission == 'bspo' || permission == 'chairperson' || permission == 'secretary'">
    <router-link :to="{ name: 'Household' }">
     <i class="fas fa-home"></i>
     <span class="menu-label">Households</span>
    </router-link>
   </a>
   <!-- <a v-if="permission == 'kagawad' || permission == 'bspo' || permission == 'bns' || permission == 'bhw' || permission == 'chairperson' || permission == 'secretary'">
    <router-link :to="{ name: 'Environment' }">
     <i class="fas fa-tree"></i>
     <span class="menu-label">Environment</span>
    </router-link>
   </a> -->
   <a v-if="permission == 'kagawad' || permission == 'chairperson' || permission == 'secretary' || permission == 'bspo'">
    <router-link :to="{ name: 'Family_Records' }">
     <i class="fas fa-users"></i>
     <span class="menu-label">Family Records</span>
    </router-link>
   </a>
   <a
    style="margin-left: 3px"
    v-if="permission == 'chairperson' || permission == 'secretary' || permission == 'kagawad' || permission == 'resident'"
   >
    <router-link :to="{ name: 'RequestCertification' }">
     <i class="fas fa-award"></i>
     <div
      class="notification-dot"
      v-if="filterRequestStatus.length != 0"
     ></div>
     <span
      v-if="filterRequestStatus.length != 0"
      class="menu-label"
      style="margin-left: -10px"
      >Certificates Request</span
     >
     <span
      class="menu-label"
      style="margin-left: 0px"
      >Certificates Request</span
     >
    </router-link>
   </a>
   <a v-if="permission == 'kagawad' || permission == 'chairperson' || permission == 'secretary'">
    <router-link :to="{ name: 'Blotter' }">
     <i class="fas fa-layer-group"></i>
     <span class="menu-label">Blotter</span>
    </router-link>
   </a>

   <a v-if="permission == 'kagawad' || permission == 'chairperson' || permission == 'secretary' || permission == 'bspo'">
    <router-link :to="{ name: 'Business_Establishments' }">
     <i class="fas fa-building"></i>
     <span class="menu-label">Business Establishments</span>
    </router-link>
   </a>

   <a
    style="margin-left: 4px"
    v-if="permission == 'treasurer' || permission == 'chairperson' || permission == 'secretary' || permission == 'kagawad'"
   >
    <router-link :to="{ name: 'Transactions' }">
     <i class="fas fa-dollar-sign"></i>
     <span class="menu-label">Transactions</span>
    </router-link>
   </a>
   <a
    style="margin-left: 4px"
    v-if="permission != 'admin' && permission != 'resident'"
   >
    <router-link :to="{ name: 'Reports' }">
     <i class="fas fa-file"></i>
     <span class="menu-label">Reports</span>
    </router-link>
   </a>
   <a v-if="permission == 'kagawad' || permission == 'chairperson' || permission == 'bhw' || permission == 'secretary' || permission == 'resident'">
    <router-link :to="`/covid/ `">
     <i class="fas fa-hospital"></i>
     <span class="menu-label">COVID-19</span>
    </router-link>
   </a>
   <a v-if="permission == 'sk chairman' || permission == 'kagawad' || permission == 'chairperson' || permission == 'secretary' || permission == 'resident' || permission == 'bspo' || permission == 'bns' || permission == 'bhw'">
    <router-link :to="{ name: 'Announcement' }">
     <i class="fas fa-bullhorn"></i>
     <span class="menu-label">Announcement</span>
    </router-link>
   </a>
   <a v-if="permission == 'admin'">
    <router-link :to="{ name: 'UserManagement' }">
     <i class="fas fa-user-cog"></i>
     <span class="menu-label">User Management</span>
    </router-link>
   </a>
   <a>
    <router-link :to="{ name: 'Hotline' }">
     <i class="fas fa-address-card"></i>
     <span class="menu-label">Hotline Numbers</span>
    </router-link>
   </a>
   <a v-if="permission == 'treasurer' || permission == 'chairperson' || permission == 'admin'">
    <router-link :to="{ name: 'General_Setting' }">
     <i class="fa fa-cog"></i>
     <span class="menu-label">Settings</span>
    </router-link>
   </a>

   <a v-if="permission == 'chairperson' || permission == 'secretary' || permission == 'kagawad' || permission == 'bns'">
    <router-link :to="{ name: 'OPT_Plus' }">
     <i class="fa fa-leaf"></i>
     <span class="menu-label">OPT Plus</span>
    </router-link>
   </a>

   <a v-if="permission == 'chairperson' || permission == 'secretary' || permission == 'kagawad'">
    <router-link :to="{ name: 'Summon_Letter' }">
     <i class="fa fa-paste"></i>
     <span class="menu-label">Summon Letter</span>
    </router-link>
   </a>

   <a v-if="permission == 'chairperson' || permission == 'secretary' || permission == 'kagawad' || permission == 'bhw'">
    <router-link :to="{ name: 'Health_Services' }">
     <i class="fa fa-user-nurse"></i>
     <span class="menu-label">Health Services</span>
    </router-link>
   </a>
    <a v-if="permission == 'chairperson' ">
    <router-link :to="{ name: 'Logs' }">
     <i class="fas fa-bars"></i>
     <span class="menu-label">Logs</span>
    </router-link>
   </a>
  </div>

  <div id="main">
   <NavbarVue />
   <router-view></router-view>
  </div>
 </div>
</template>

<script>
import axios from "../axios";
import NavbarVue from "./Navbar.vue";
export default {
 components: {
  NavbarVue,
 },
 data() {
  return {
   permission: localStorage.getItem("permission"),
   authorized: true,
   residents: [],
   officials: [],
   certification_requests: [],
   mini: false,

   loading: false,
   currentPage: 1,
   rows: 0,
   perPage: 0,
   search: "",

   profile_pic: null,
  };
 },

 computed: {
  filterRequestStatus() {
   return this.certification_requests.filter((data) => {
    return data.status.match("Pending") || data.status.match("Paid") || data.status.match("Approved");
   });
  },

  filterRegistration() {
   return this.residents.filter((data) => {
    return data.status.match("Pending");
   });
  },
 },

 methods: {
  async fetchCertificationRequest() {
   this.loading = true;
   await axios
    .get(`/certification_request?page=${this.currentPage}`)
    .then((response) => {
     this.certification_requests = response.data.data;
     this.currentPage = response.data.current_page;
     this.rows = response.data.total;
     this.perPage = response.data.per_page;
    })
    .catch((error) => {
     return error.response;
    });
   this.loading = false;
  },

  async fetchResident() {
   this.loading = true;
   await axios
    .get(`/pending-residents?page=${this.currentPage}&search=${this.search}`)
    .then((response) => {
     this.residents = response.data.data;
     this.currentPage = response.data.current_page;
     this.rows = response.data.total;
     this.perPage = response.data.per_page;
    })
    .catch((error) => {
     return error.response;
    });
   this.loading = false;
  },

  async findResident() {
   this.loading = true;
   const data = {
    remember_token: localStorage.getItem("token"),
   };
   await axios
    .post(`/find-resident?page=${this.currentPage}`, data)
    .then((response) => {
     this.residents = response.data.data;
    })
    .catch((error) => {
     return error.response;
    });
   this.loading = false;
  },

  async fetchOfficial() {
   this.loading = true;
   const data = {
    remember_token: localStorage.getItem("token"),
   };
   await axios
    .post(`/find-officials?page=${this.currentPage}`, data)
    .then((response) => {
     this.officials = response.data.data;
    })
    .catch((error) => {
     return error.response;
    });
   this.loading = false;
  },

  logOut() {
   localStorage.clear("token");
   localStorage.clear("permission");
   this.$router.push("/");
  },

  toggleSidebar() {
   if (this.mini) {
    this.mini = false;
    document.getElementById("mySidebar").style.width = "290px";
    document.getElementById("mySidebar").style.overflowY = "scroll";
    document.getElementById("mySidebar").style.overflowX = "hidden";
    document.getElementById("main").style.marginLeft = "290px";
   } else {
    this.mini = true;
    document.getElementById("mySidebar").style.width = "85px";
    document.getElementById("mySidebar").style.overflow = "hidden";
    document.getElementById("main").style.marginLeft = "85px";
    document.getElementById("profile-pic").style.width = "60%";
    document.getElementById("profile-pic").style.height = "60%";
   }
  },
 },

 mounted() {
  if (localStorage.getItem("permission") == "resident") {
   this.findResident();
  }
  if (localStorage.getItem("permission") != "resident") {
   this.fetchOfficial();
   this.fetchCertificationRequest();
   this.fetchResident();
  }
  this.toggleSidebar();
  window.onpopstate = () => {
   if (window.localStorage.getItem("token") !== null && this.$router.path == "/") {
    this.$router.push("/admin"); // redirect to home, for example
   }
  };
 },
};
</script>
