<template>
  <div class="login">
    <ul class="circles">
      <li></li>
      <li></li>
      <li></li>
      <li></li>
      <li></li>
      <li></li>
      <li></li>
      <li></li>
      <li></li>
      <li></li>
    </ul>
    <div class="header">
      <!-- <button type="button" class="btn btn-outline-light btn-lg">
                Register
            </button> -->
    </div>
    <div class="container-fluid">
      <div class="card" style="max-width: 600px; box-shadow: 1px 1px 12px rgb(29, 29, 29);">
        <div class="row row-login" style="margin-top: 0; padding-top: 25px;">
          <div class="col">
            <div class="image">
              <img
                class="profile-image"
                style="max-width: 550px;"
                :src="require('../../assets/images/logo2.png')"
              />
              <h6 style="color:#0e1111; margin-top: 20px; font-weight: bold; letter-spacing: 2px; font-family: monospace;">
                INFORMATION AND MANAGEMENT SYSTEM
              </h6>
              <h5 style="color:#0e1111; margin-top: 10px; font-weight: bold; letter-spacing: 2px; font-family: inherit;">
                BARANGAY 6-A STO. NIÑO EXT. 
              </h5>
             
              <br>
            </div>
          </div>
          <div class="form-group">
            <div style="position: relative; margin-bottom: 20px;">
              <i class="fa fa-user" style="position: absolute; top:14px; left:11px; color:rgb(172, 172, 172)"></i>
              <input type="text" class="form-control" v-model="username" placeholder="Type your username" style="font-size:14px; font-family: monospace; border:none; padding:10px 45px; font-weight: 600; border-radius: 0; border-bottom: 3px solid rgb(172, 172, 172); box-shadow: none;"/>
            </div>
            <div v-if="this.errors.name">
              <label style="color: red; font-weight: 500">{{
                this.errors.name[0]
              }}</label>
            </div>
          </div>
          <div style="position: relative; margin-bottom: 20px;">
            <i class="fa fa-lock" style="position: absolute; top:14px; left:22px; color:rgb(172, 172, 172)"></i>
            <input id="password" type="password" class="form-control" v-model="password" placeholder="Type your password" style="font-size:14px; font-family: monospace; border:none; padding:10px 45px; font-weight: 600; border-radius: 0; border-bottom: 3px solid rgb(172, 172, 172); box-shadow: none;"/>
            <i
                  @click="toggleShow"
                  class="fas"
                  style="position: absolute; right: 22px; top:14px; cursor: pointer;  color:rgb(128, 128, 128)"
                  :class="{
                    'fa-eye-slash': showPassword,
                    'fa-eye': !showPassword,
                  }"
                ></i>
          </div>
            
          
                
          <div class="text-center">
            <!-- <button class="btn btn-warning" @click="register()" style="margin-top: 20px; width: 200px"> Register </button> -->
            <button
              class="btn btn-success"
              @click="login()"
              style="margin-top: 20px; width: 100%; border-radius: 25px; background-color: rgb(5, 142, 99); font-family: inherit; letter-spacing: 2px; font-weight: 700; font-size: 16px;"
              v-bind:disabled="loading"
            >
              LOGIN
              <span
                class="spinner-border spinner-border-sm"
                style="margin-left: 20px;"
                role="status"
                aria-hidden="true"
                v-if="loading"
              ></span>
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "../../axios";
export default {
  data() {
    return {
      username: null,
      password: null,

      errors: {},

      loading: false,
      showPassword: false,
    };
  },
  computed: {
    buttonLabel() {
      return this.showPassword ? "Hide" : "Show";
    },
  },

  methods: {
    toggleShow() {
      this.showPassword = !this.showPassword;
      document.getElementById('password').type = this.showPassword ? 'text' : 'password';
    },
    register() {
      this.$router.push("/register/user-information");
    },
    async login() {
      this.loading = true;
      const data = {
        name: this.username,
        password: this.password,
      };

      await axios
        .post("/login", data)
        .then((response) => {
          localStorage.setItem("token", response.data.token);

          localStorage.setItem("permission", response.data.permission);

          if (response.data.permission == "resident") {
            localStorage.setItem("resident_id", response.data.resident_id);
          }
         response.data.permission == 'admin' ? this.$router.push("/logs") : this.$router.push("/dashboard");
        })
        .catch((error) => {
          this.$toast.error(error.response.data.error);
        });
      this.loading = false;
    },
  },
};
</script>
