<template>
 <nav class="navbar navbar-expand-lg shadow">
  <div class="container-fluid  d-flex flex-row align-items-center justify-content-between">
   <div
    class="text"
    v-if="permission == 'resident'"
    style="display: inline"
   >
    <h5 style="margin-top: 20px">
     <img
      v-if="permission == 'resident' && this.residents.resident.profile_pic == null"
      class="profile-image"
      :src="require('../assets/images/profile_image.png')"
      height="50"
      alt="profile_image"
     />
     <img
      v-if="permission == 'resident' && this.residents.resident.profile_pic != null"
      class="profile-image"
      :src="'http://localhost/img/' + this.residents.resident.profile_pic"
      height="50"
      alt="profile_image"
     />
     {{ this.residents.resident.first_name }}
     {{ this.residents.resident.last_name }} -
     {{ this.residents.resident.zones.zone_description }}
    </h5>
   </div>

   <div
    class="text"
    v-if="permission != 'resident'"
    style="display: inline"
   >
    <h5 style="margin-top: 20px" v-if="this.officials.officials">
     <img
      v-if="this.officials.officials && !this.officials.officials.profile_pic"
      class="profile-image"
      :src="require('../assets/images/profile_image.png')"
      height="50"
      alt="profile_image"
     />
     <img
      v-if="this.officials.officials && this.officials.officials.profile_pic"
      class="profile-image"
      :src="'http://localhost/img/' + this.officials.officials.profile_pic"
      height="50"
      alt="profile_image"
     />
     {{ this.officials.officials.fullname }} -
     {{ this.officials.officials.position.position_description }}
     <span v-if="this.officials.officials.zones">({{ this.officials.officials.zones.zone_description }})</span>
    </h5>
   </div>

   <div
    class="text"
    v-if="permission == 'admin'"
    style="display: inline"
   >
    <h5 style="margin-top: 20px">Admin</h5>
   </div>

   <div class="mt-3 d-flex flex-row align-items-center justify-content-between">
    <h5 style="white-space: nowrap; margin-right: 10px;">{{ timestamp }}</h5>
    <div>
        <b-dropdown
        id="dropdown-1"
        class="m-md-2"
        right
        variant="primary"
        title="Profile Settings"
        >
        <b-dropdown-item @click="editProfile()"> Edit Profile </b-dropdown-item>
        <b-dropdown-item @click="logOut()">Logout</b-dropdown-item>
        </b-dropdown>
    </div>
   </div>

   
  </div>
 </nav>
</template>

<script>
import axios from "../axios";
import moment from "moment";
export default {
 data() {
  return {
   permission: localStorage.getItem("permission"),
   authorized: true,
   residents: [],
   officials: [],
   mini: false,
   timestamp: "",

   profile_pic: null,
  };
 },
 created() {
  setInterval(this.getNow, 1000);
 },

 methods: {
  getNow() {
   const today = new Date();
   const date = today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate();
   const time = today.getHours() + ":" + today.getMinutes() + ":" + today.getSeconds();
   const dateTime = date + " " + time;
   this.timestamp = moment(dateTime).format("MMMM D YYYY, h:mm:ss a");
  },
  async findResident() {
   this.loading = true;
   const data = {
    remember_token: localStorage.getItem("token"),
   };
   await axios
    .post(`/find-resident`, data)
    .then((response) => {
     this.residents = response.data;
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
    .post(`/find-officials`, data)
    .then((response) => {
     this.officials = response.data;
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

  editProfile() {
   if (localStorage.getItem("permission") == "resident") {
    this.$router.push("/edit_resident_profile");
   }
   if (localStorage.getItem("permission") != "resident") {
    this.$router.push("/edit_profile");
   }
   if (localStorage.getItem("permission") == "admin") {
    this.$router.push("/edit_admin_profile");
   }
  },

  toggleSidebar() {
   if (this.mini) {
    this.mini = false;
    document.getElementById("mySidebar").style.width = "250px";
    document.getElementById("main").style.marginLeft = "250px";
    // this.mini = false;
   } else {
    this.mini = true;
    document.getElementById("mySidebar").style.width = "85px";
    document.getElementById("main").style.marginLeft = "85px";
    document.getElementById("profile-pic").style.width = "60%";
    document.getElementById("profile-pic").style.height = "60%";
    // this.mini = true;
   }
  },
 },

 mounted() {
  if (localStorage.getItem("permission") == "resident") {
   this.findResident();
  }
  if (localStorage.getItem("permission") != "resident") {
   this.fetchOfficial();
  }
  this.toggleSidebar();
 },
};
</script>
