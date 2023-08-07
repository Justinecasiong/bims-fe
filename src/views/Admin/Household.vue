<template>
  <div class="container">
    <div class="page-header">
      <div class="row">
        <div class="col-lg-8 col-md-5">
          <h1>Household Heads</h1>
        </div>
        <div class="col search">
          <div class="input-group">
            <input
              type="text"
              class="form-control"
              placeholder="Search"
              v-model="search"
              v-on:input="fetchHouseholdHeads()"
            />
          </div>
        </div>
      </div>
    </div>
    <div class="table-container table-responsive-xxl shadow">
      <button
        class="btn btn-primary mb-3"
        v-b-modal.modal-add
        v-if="permission == 'bspo'"
      >
        Add Household Heads
      </button>
      <div class="d-flex justify-content-center" v-if="loading">
        <div class="spinner-border text-center mt-3" role="status"></div>
      </div>
      <table class="table table-striped table-hover table-sm" v-if="!loading">
        <thead>
          <tr>
            <th scope="col">Household No.</th>
            <th scope="col">Family No.</th>
            <th scope="col">Fullname</th>
            <th scope="col">Sex</th>
            <th scope="col">Civil Status</th>
            <th scope="col">Date of Birth</th>
            <th scope="col">Age</th>
            <th scope="col">Relationship</th>
            <th scope="col">Highest Educational Attainment</th>
            <th scope="col">Action</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(household, index) in households" :key="index">
            <td>{{ household.household_num }}</td>
            <td>{{ household.family_num }}</td>
            <td>
              {{ household.first_name }}
              {{ household.middle_name ? household.middle_name : "" }}
              {{ household.last_name }}
            </td>
            <td>{{ household.sex }}</td>
            <td>{{ household.civil_status }}</td>
            <td>{{ household.birthdate }}</td>
            <td>{{ getAge(household.birthdate)  }}</td>
            <td>{{ household.relationship }}</td>
            <td>{{ household.education }}</td>
            <td>
              <button
                class="btn btn-primary mb-2"
                @click="viewDetails(household)"
              >
                View Full Details
              </button>
              <button
                class="btn btn-success mb-2"
                v-if="permission == 'bspo'"
                @click="addFamilyMember(household)"
              >
                Add Family Members
              </button>
              <button
                class="btn btn-info"
                @click="viewFamilyMember(household.family_members)"
              >
                View Family Members
              </button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <b-modal
      class="add_modal"
      id="modal-add"
      title="Add Household Head"
      size="xl"
      centered
      :hide-footer="true"
    >
      <form @submit.prevent="createHousehold" class="row">
        <div class="col">
          <div class="row">
            <div class="col-sm-4">
              <div class="form-group">
                <label for="household-number" class="control-label">
                  Household No.
                </label>
                <input
                  required
                  type="text"
                  class="form-control"
                  id="household-num"
                  placeholder="Enter Household Number"
                  v-model="household_num"
                />
                <div v-if="this.errors.household_num">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.household_num[0]
                  }}</label>
                </div>
              </div>
            </div>
            <div class="col-sm-4">
              <div class="form-group">
                <label for="family-number" class="control-label">
                  Family Number:
                </label>
                <input
                  required
                  type="text"
                  class="form-control"
                  id="family-number"
                  placeholder="Enter Family Number"
                  v-model="family_num"
                />
                <div v-if="this.errors.family_num">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.family_num[0]
                  }}</label>
                </div>
              </div>
            </div>
            <div class="col-sm-4">
              <div class="form-group">
                <label for="first-name" class="control-label">
                  First Name:
                </label>
                <input
                  required
                  type="text"
                  class="form-control"
                  id="first-name"
                  placeholder="Enter First Name"
                  v-model="first_name"
                />
                <div v-if="this.errors.first_name">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.first_name[0]
                  }}</label>
                </div>
              </div>
            </div>
          </div>
          <div class="row">
            <div class="col-sm-4">
              <div class="form-group">
                <label for="middle-name" class="control-label">
                  Middle Name:
                </label>
                <input
                  required
                  type="text"
                  class="form-control"
                  id="middle-name"
                  placeholder="Enter Middle Name"
                  v-model="middle_name"
                />
                <div v-if="this.errors.middle_name">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.middle_name[0]
                  }}</label>
                </div>
              </div>
            </div>
            <div class="col-sm-4">
              <div class="form-group">
                <label for="last-name" class="control-label">
                  Last Name:
                </label>
                <input
                  required
                  type="text"
                  class="form-control"
                  id="last-name"
                  placeholder="Enter Last Name"
                  v-model="last_name"
                />
                <div v-if="this.errors.last_name">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.last_name[0]
                  }}</label>
                </div>
              </div>
            </div>
            <div class="col-sm-4">
              <div class="form-group">
                <label for="gender" class="control-label"> Sex: </label>
                  <select
                    class="form-control"
                    id="gender"
                    placeholder="Enter Sex"
                    v-model="sex"
                  >
                  <option value="Male">Male</option>
                  <option value="Female">Female</option>
                </select>
                <div v-if="this.errors.sex">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.sex[0]
                  }}</label>
                </div>
              </div>
            </div>
          </div>
          <div class="row">
            <div class="col-sm-4">
              <div class="form-group">
                <label for="birthdate" class="control-label">
                  Birthdate:
                </label>
                <input
                  required
                  type="date"
                  class="form-control"
                  id="birthdate"
                  placeholder="Enter Birthdate"
                  v-model="birthdate"
                />
                <div v-if="this.errors.birthdate">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.birthdate[0]
                  }}</label>
                </div>
              </div>
            </div>
            <div class="col-sm-4">
              <div class="form-group">
                <label for="civil-status" class="control-label">
                  Civil Status:
                </label>
                <select
                  class="form-select"
                  name="civil-status"
                  id="civil_status"
                  v-model="civil_status"
                >
                  <option value="Single">Single</option>
                  <option value="Married">Married</option>
                  <option value="Divorced">Divorced</option>
                  <option value="Widowed">Widowed</option>
                </select>
                <div v-if="this.errors.civil_status">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.civil_status[0]
                  }}</label>
                </div>
              </div>
            </div>
          </div>
          <div class="row">
            <div class="col-sm-4">
              <div class="form-group">
                <label for="relationship" class="control-label">
                  Relationship:
                </label>
                <select
                  class="form-select"
                  name="relationship"
                  id="relationship"
                  v-model="relationship"
                >
                  <option value="Father">Father</option>
                  <option value="Mother">Mother</option>
                  <option value="Son">Son</option>
                  <option value="Daughter">Daughter</option>
                </select>
                <div v-if="this.errors.relationship">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.relationship[0]
                  }}</label>
                </div>
              </div>
            </div>
            <div class="col-sm-4">
              <div class="form-group">
                <label for="education" class="control-label">
                  Highest Educational Attainment:
                </label>
                <select
                  class="form-select"
                  name="education"
                  id="education"
                  v-model="education"
                >
                  <option value="Day Care">Day Care</option>
                  <option value="Nursery">Nursery</option>
                  <option value="Kinder">Kinder</option>
                  <option value="Elementary Level">Elementary Level</option>
                  <option value="Elementary Grad">Elementary Grad</option>
                  <option value="ALS High School">ALS High School</option>
                  <option value="High School Level">High School Level</option>
                  <option value="High School Grad">High School Grad</option>
                  <option value="Senior High">Senior High</option>
                  <option value="Vocational">Vocational</option>
                  <option value="College Level">College Level</option>
                  <option value="College Grad">College Grad</option>
                  <option value="Post Graduate">Post Graduate</option>
                </select>
                <div v-if="this.errors.education">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.education[0]
                  }}</label>
                </div>
              </div>
            </div>
            <div class="col-sm-4">
              <div class="form-group">
                <label for="occupation" class="control-label">
                  Occupation:
                </label>
                <select
                  class="form-select"
                  name="occupation"
                  id="occupation"
                  v-model="occupation"
                >
                  <option value="Government Employee">
                    Government Employee
                  </option>
                  <option value="Private Employee">Private Employee</option>
                  <option value="Barangay Employee">Barangay Employee</option>
                  <option value="Barangay Volunteers">
                    Barangay Volunteers
                  </option>
                  <option value="OFW">OFW</option>
                  <option value="Business">Business</option>
                  <option value="Carpenter">Carpenter</option>
                  <option value="Laborer/Construction">
                    Laborer/Construction
                  </option>
                  <option value="Driver">Driver</option>
                  <option value="Sari-sari Store">Sari-sari Store</option>
                  <option value="Helper">Helper</option>
                  <option value="Vendor">Vendor</option>
                  <option value="Self-Employed">Self-Employed</option>
                </select>
                <div v-if="this.errors.occupation">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.occupation[0]
                  }}</label>
                </div>
              </div>
            </div>
          </div>
          <div class="row">
            <div class="col-sm-4">
              <div class="form-group">
                <label for="method" class="control-label">
                  Family Planning Method:
                </label>
                <select
                  class="form-select"
                  name="method"
                  id="fp-method"
                  v-model="fp_method"
                >
                  <option value="Vasectomy">Vasectomy</option>
                  <option value="Tubal Ligation">Tubal Ligation</option>
                  <option value="Implant">Implant</option>
                  <option value="Condom">Condom</option>
                  <option value="IUD">IUD</option>
                  <option value="Pills">Pills</option>
                  <option value="Injectable">Injectable</option>
                  <option value="NFP">NFP</option>
                </select>
                <div v-if="this.errors.fp_method">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.fp_method[0]
                  }}</label>
                </div>
              </div>
            </div>
            <div class="col-sm-4">
              <div class="form-group">
                <label for="pwd-status" class="control-label">
                  PWD Status:
                </label>
                <select
                  class="form-select"
                  name="pwd-status"
                  id="pwd_status"
                  v-model="pwd_status"
                >
                  <option value="Yes">Yes</option>
                  <option value="No">No</option>
                </select>
                <div v-if="this.errors.pwd_status">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.pwd_status[0]
                  }}</label>
                </div>
              </div>
            </div>
            <div class="col-sm-4">
              <div class="form-group">
                <label for="senior-citizen" class="control-label">
                  Senior Citizen:
                </label>
                <select
                  class="form-select"
                  name="senior-citizen"
                  id="senior_citizen"
                  v-model="senior_citizen"
                >
                  <option value="Yes">Yes</option>
                  <option value="No">No</option>
                </select>
                <div v-if="this.errors.senior_citizen">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.senior_citizen[0]
                  }}</label>
                </div>
              </div>
            </div>
          </div>
          <div class="row">
            <div class="col-sm-4">
              <div class="form-group">
                <label for="oosy" class="control-label">
                  Out of School Youth:
                </label>
                <select
                  class="form-select"
                  name="oosy"
                  id="oosy"
                  v-model="oosy"
                >
                  <option value="Yes">Yes</option>
                  <option value="No">No</option>
                </select>
                <div v-if="this.errors.oosy">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.oosy[0]
                  }}</label>
                </div>
              </div>
            </div>
            <div class="col-sm-4">
              <div class="form-group">
                <label for="residency" class="control-label">
                  How long of Residency:
                </label>
                <br>
                <small>
                  Year Started
                </small>
                <select
                  class="form-control"
                  id="residency"
                  v-model="residency"
                >
                  <option 
                  v-for="(year, index) in years"
                    :key="index"
                    :value="year"
                  >{{ year }}</option>
                </select>
                <div v-if="this.errors.residency">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.residency[0]
                  }}</label>
                </div>
                <small>
                  Year Ended
                </small>
                <select
                  class="form-control"
                  id="residency_end"
                  v-model="residency_end"
                >
                  <option v-bind:value="null">Present (Currently a resident)</option>
                  <option 
                  v-for="(year, index) in years"
                    :key="index"
                    :value="year"
                  >{{ year }}</option>
                </select>
                <div v-if="this.errors.residency_end">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.residency_end[0]
                  }}</label>
                </div>
              </div>
            </div>
            <div class="col-sm-4">
              <div class="form-group">
                <label for="address" class="control-label">
                  Previous Address:
                </label>
                <input
                  required
                  type="text"
                  class="form-control"
                  id="address"
                  placeholder="Enter Address"
                  v-model="address"
                />
                <div v-if="this.errors.address">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.address[0]
                  }}</label>
                </div>
              </div>
            </div>
            <div class="row">
              <div class="col-sm-4">
                <div class="form-group">
                  <label for="first-name" class="control-label"> Zone: </label>
                  <select
                    class="form-select"
                    name="zone"
                    id="zone"
                    v-model="zone_id"
                  >
                    <option
                      v-for="zone in zones"
                      :key="zone.id"
                      :value="zone.id"
                    >
                      {{ zone.zone_description }}
                    </option>
                  </select>
                  <div v-if="this.errors.zone_id">
                    <label style="color: red; font-weight: 500">{{
                      this.errors.zone_id[0]
                    }}</label>
                  </div>
                </div>
              </div>
              <div class="col-sm-8">
                <div class="form-group">
                  <label for="remarks" class="control-label"> Remarks: </label>
                  <input
                    type="text"
                    class="form-control"
                    id="remarks"
                    placeholder="Enter here"
                    v-model="remarks"
                  />
                  <div v-if="this.errors.remarks">
                    <label style="color: red; font-weight: 500">{{
                      this.errors.remarks[0]
                    }}</label>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="mt-4 d-flex justify-content-end">
          <button class="btn btn-danger" type="button" @click="resetFields()">
            Cancel
          </button>
          <button class="btn btn-primary" type="submit">Save</button>
        </div>
      </form>
    </b-modal>
    <b-modal
      class="view_family_modal"
      id="modal-view-members"
      title="Household Family Members"
      size="xl"
      centered
      :hide-footer="true"
    >
      <table class="table table-striped table-hover table-sm" v-if="!loading">
        <thead>
          <tr>
            <th scope="col">Household No.</th>
            <th scope="col">Family No.</th>
            <th scope="col">Fullname</th>
            <th scope="col">Sex</th>
            <th scope="col">Civil Status</th>
            <th scope="col">Date of Birth</th>
            <th scope="col">Age</th>
            <th scope="col">Relationship</th>
            <th scope="col">Highest Educational Attainment</th>
            <th scope="col">Action</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(household, index) in householdMembers" :key="index">
            <td>{{ household.household_num }}</td>
            <td>{{ household.family_num }}</td>
            <td>
              {{ household.first_name }}
              {{ household.middle_name ? household.middle_name : "" }}
              {{ household.last_name }}
            </td>
            <td>{{ household.sex }}</td>
            <td>{{ household.civil_status }}</td>
            <td>{{ household.birthdate }}</td>
            <td>{{ getAge(household.birthdate) }}</td>
            <td>{{ household.relationship }}</td>
            <td>{{ household.education }}</td>
            <td>
              <button
                class="btn btn-primary mb-2"
                @click="viewMemberDetails(household)"
              >
                View Full Details
              </button>
              <button
                class="btn btn-danger mb-2"
                v-if="permission == 'secretary' || permission == 'admin'"
                @click="deleteHousehold(household.id)"
              >
                Delete Member
              </button>
            </td>
          </tr>
        </tbody>
      </table>
    </b-modal>
    <b-modal
      class="add_family_member_modal"
      id="modal-add-member"
      title="Add Family Member"
      size="xl"
      centered
      :hide-footer="true"
    >
      <form @submit.prevent="createHouseholdMember" class="row">
        <div class="col">
          <div class="row">
            <div class="col-sm-4">
              <div class="form-group">
                <label for="family-number" class="control-label">
                  Family Number:
                </label>
                <input
                  required
                  type="text"
                  class="form-control"
                  id="family-number"
                  placeholder="Enter Family Number"
                  v-model="familyMember.family_num"
                />
                <div v-if="this.errors.family_num">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.family_num[0]
                  }}</label>
                </div>
              </div>
            </div>
            <div class="col-sm-4">
              <div class="form-group">
                <label for="first-name" class="control-label">
                  First Name:
                </label>
                <input
                  required
                  type="text"
                  class="form-control"
                  id="first-name"
                  placeholder="Enter First Name"
                  v-model="familyMember.first_name"
                />
                <div v-if="this.errors.first_name">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.first_name[0]
                  }}</label>
                </div>
              </div>
            </div>
          </div>
          <div class="row">
            <div class="col-sm-4">
              <div class="form-group">
                <label for="middle-name" class="control-label">
                  Middle Name:
                </label>
                <input
                  required
                  type="text"
                  class="form-control"
                  id="middle-name"
                  placeholder="Enter Middle Name"
                  v-model="familyMember.middle_name"
                />
                <div v-if="this.errors.middle_name">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.middle_name[0]
                  }}</label>
                </div>
              </div>
            </div>
            <div class="col-sm-4">
              <div class="form-group">
                <label for="last-name" class="control-label">
                  Last Name:
                </label>
                <input
                  required
                  type="text"
                  class="form-control"
                  id="last-name"
                  placeholder="Enter Last Name"
                  v-model="familyMember.last_name"
                />
                <div v-if="this.errors.last_name">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.last_name[0]
                  }}</label>
                </div>
              </div>
            </div>
            <div class="col-sm-4">
              <div class="form-group">
                <label for="gender" class="control-label"> Sex: </label>
                <select
                  class="form-control"
                  id="gender"
                  placeholder="Enter Sex"
                  v-model="familyMember.sex"
                >
                  <option value="Male">Male</option>
                  <option value="Female">Female</option>
                </select>
                <div v-if="this.errors.sex">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.sex[0]
                  }}</label>
                </div>
              </div>
            </div>
          </div>
          <div class="row">
            <div class="col-sm-4">
              <div class="form-group">
                <label for="birthdate" class="control-label">
                  Birthdate:
                </label>
                <input
                  required
                  type="date"
                  class="form-control"
                  id="birthdate"
                  placeholder="Enter Birthdate"
                  v-model="familyMember.birthdate"
                />
                <div v-if="this.errors.birthdate">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.birthdate[0]
                  }}</label>
                </div>
              </div>
            </div>
            <div class="col-sm-4">
              <div class="form-group">
                <label for="civil-status" class="control-label">
                  Civil Status:
                </label>
                <select
                  class="form-select"
                  name="civil-status"
                  id="civil_status"
                  v-model="familyMember.civil_status"
                >
                  <option value="Single">Single</option>
                  <option value="Married">Married</option>
                  <option value="Divorced">Divorced</option>
                  <option value="Widowed">Widowed</option>
                </select>
                <div v-if="this.errors.civil_status">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.civil_status[0]
                  }}</label>
                </div>
              </div>
            </div>
          </div>
          <div class="row">
            <div class="col-sm-4">
              <div class="form-group">
                <label for="relationship" class="control-label">
                  Relationship:
                </label>
                <select
                  class="form-select"
                  name="relationship"
                  id="relationship"
                  v-model="familyMember.relationship"
                >
                  <option value="Father">Father</option>
                  <option value="Mother">Mother</option>
                  <option value="Son">Son</option>
                  <option value="Daughter">Daughter</option>
                </select>
                <div v-if="this.errors.relationship">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.relationship[0]
                  }}</label>
                </div>
              </div>
            </div>
            <div class="col-sm-4">
              <div class="form-group">
                <label for="education" class="control-label">
                  Highest Educational Attainment:
                </label>
                <select
                  class="form-select"
                  name="education"
                  id="education"
                  v-model="familyMember.education"
                >
                  <option value="Day Care">Day Care</option>
                  <option value="Nursery">Nursery</option>
                  <option value="Kinder">Kinder</option>
                  <option value="Elementary Level">Elementary Level</option>
                  <option value="Elementary Grad">Elementary Grad</option>
                  <option value="ALS High School">ALS High School</option>
                  <option value="High School Level">High School Level</option>
                  <option value="High School Grad">High School Grad</option>
                  <option value="Senior High">Senior High</option>
                  <option value="Vocational">Vocational</option>
                  <option value="College Level">College Level</option>
                  <option value="College Grad">College Grad</option>
                  <option value="Post Graduate">Post Graduate</option>
                </select>
                <div v-if="this.errors.education">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.education[0]
                  }}</label>
                </div>
              </div>
            </div>
            <div class="col-sm-4">
              <div class="form-group">
                <label for="occupation" class="control-label">
                  Occupation:
                </label>
                <select
                  class="form-select"
                  name="occupation"
                  id="occupation"
                  v-model="familyMember.occupation"
                >
                  <option value="Government Employee">
                    Government Employee
                  </option>
                  <option value="Private Employee">Private Employee</option>
                  <option value="Barangay Employee">Barangay Employee</option>
                  <option value="Barangay Volunteers">
                    Barangay Volunteers
                  </option>
                  <option value="OFW">OFW</option>
                  <option value="Business">Business</option>
                  <option value="Carpenter">Carpenter</option>
                  <option value="Laborer/Construction">
                    Laborer/Construction
                  </option>
                  <option value="Driver">Driver</option>
                  <option value="Sari-sari Store">Sari-sari Store</option>
                  <option value="Helper">Helper</option>
                  <option value="Vendor">Vendor</option>
                  <option value="Self-Employed">Self-Employed</option>
                </select>
                <div v-if="this.errors.occupation">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.occupation[0]
                  }}</label>
                </div>
              </div>
            </div>
          </div>
          <div class="row">
            <div class="col-sm-4">
              <div class="form-group">
                <label for="method" class="control-label">
                  Family Planning Method:
                </label>
                <select
                  class="form-select"
                  name="method"
                  id="fp-method"
                  v-model="familyMember.fp_method"
                >
                  <option value="Vasectomy">Vasectomy</option>
                  <option value="Tubal Ligation">Tubal Ligation</option>
                  <option value="Implant">Implant</option>
                  <option value="Condom">Condom</option>
                  <option value="IUD">IUD</option>
                  <option value="Pills">Pills</option>
                  <option value="Injectable">Injectable</option>
                  <option value="NFP">NFP</option>
                </select>
                <div v-if="this.errors.fp_method">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.fp_method[0]
                  }}</label>
                </div>
              </div>
            </div>
            <div class="col-sm-4">
              <div class="form-group">
                <label for="pwd-status" class="control-label">
                  PWD Status:
                </label>
                <select
                  class="form-select"
                  name="pwd-status"
                  id="pwd_status"
                  v-model="familyMember.pwd_status"
                >
                  <option value="Yes">Yes</option>
                  <option value="No">No</option>
                </select>
                <div v-if="this.errors.pwd_status">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.pwd_status[0]
                  }}</label>
                </div>
              </div>
            </div>
            <div class="col-sm-4">
              <div class="form-group">
                <label for="senior-citizen" class="control-label">
                  Senior Citizen:
                </label>
                <select
                  class="form-select"
                  name="senior-citizen"
                  id="senior_citizen"
                  v-model="familyMember.senior_citizen"
                >
                  <option value="Yes">Yes</option>
                  <option value="No">No</option>
                </select>
                <div v-if="this.errors.senior_citizen">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.senior_citizen[0]
                  }}</label>
                </div>
              </div>
            </div>
          </div>
          <div class="row">
            <div class="col-sm-4">
              <div class="form-group">
                <label for="oosy" class="control-label">
                  Out of School Youth:
                </label>
                <select
                  class="form-select"
                  name="oosy"
                  id="oosy"
                  v-model="familyMember.oosy"
                >
                  <option value="Yes">Yes</option>
                  <option value="No">No</option>
                </select>
                <div v-if="this.errors.oosy">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.oosy[0]
                  }}</label>
                </div>
              </div>
            </div>
            <div class="col-sm-4">
              <div class="form-group">
                <label for="residency" class="control-label">
                  How long of Residency:
                </label>
                <br>
                <small>
                  Year Started
                </small>
                <select
                  class="form-control"
                  id="residency"
                  v-model="familyMember.residency"
                >
                  <option 
                  v-for="(year, index) in years"
                    :key="index"
                    :value="year"
                  >{{ year }}</option>
                </select>
                <div v-if="this.errors.residency">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.residency[0]
                  }}</label>
                </div>
                <small>
                  Year Ended
                </small>
                <select
                  class="form-control"
                  id="residency_end"
                  v-model="familyMember.residency_end"
                >
                  <option v-bind:value="null">Present (Currently a resident)</option>
                  <option 
                  v-for="(year, index) in years"
                    :key="index"
                    :value="year"
                  >{{ year }}</option>
                </select>
                <div v-if="this.errors.residency_end">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.residency_end[0]
                  }}</label>
                </div>
              </div>
            </div>
            <div class="col-sm-4">
              <div class="form-group">
                <label for="address" class="control-label">
                  Previous Address:
                </label>
                <input
                  required
                  type="text"
                  class="form-control"
                  id="address"
                  placeholder="Enter Address"
                  v-model="familyMember.address"
                />
                <div v-if="this.errors.address">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.address[0]
                  }}</label>
                </div>
              </div>
            </div>
            <div class="row">
              <div class="col-sm-4">
                <div class="form-group">
                  <label for="first-name" class="control-label"> Zone: </label>
                  <select
                    class="form-select"
                    name="zone"
                    id="zone"
                    v-model="familyMember.zone_id"
                  >
                    <option
                      v-for="zone in zones"
                      :key="zone.id"
                      :value="zone.id"
                    >
                      {{ zone.zone_description }}
                    </option>
                  </select>
                  <div v-if="this.errors.zone_id">
                    <label style="color: red; font-weight: 500">{{
                      this.errors.zone_id[0]
                    }}</label>
                  </div>
                </div>
              </div>
              <div class="col-sm-8">
                <div class="form-group">
                  <label for="remarks" class="control-label"> Remarks: </label>
                  <input
                    type="text"
                    class="form-control"
                    id="remarks"
                    placeholder="Enter here"
                    v-model="familyMember.remarks"
                  />
                  <div v-if="this.errors.remarks">
                    <label style="color: red; font-weight: 500">{{
                      this.errors.remarks[0]
                    }}</label>
                  </div>
                </div>
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
          <button class="btn btn-primary" type="submit">
            Add Family Member
          </button>
        </div>
      </form>
    </b-modal>
    <b-modal
      class="view_modal"
      id="modal-view"
      title="Household Head Information"
      size="xl"
      centered
      :hide-footer="true"
    >
      <form @submit.prevent="updateHousehold" class="row">
        <div class="col">
          <div class="row">
            <div class="col-sm-4">
              <div class="form-group">
                <label for="household-number" class="control-label">
                  Household No.
                </label>
                <input
                  required
                  type="text"
                  class="form-control"
                  id="household-num"
                  placeholder="Enter Household Number"
                  v-model="householdDetails.household_num"
                />
                <div v-if="this.errors.household_num">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.household_num[0]
                  }}</label>
                </div>
              </div>
            </div>
            <div class="col-sm-4">
              <div class="form-group">
                <label for="family-number" class="control-label">
                  Family Number:
                </label>
                <input
                  required
                  type="text"
                  class="form-control"
                  id="family-number"
                  placeholder="Enter Family Number"
                  v-model="householdDetails.family_num"
                />
                <div v-if="this.errors.family_num">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.family_num[0]
                  }}</label>
                </div>
              </div>
            </div>
            <div class="col-sm-4">
              <div class="form-group">
                <label for="first-name" class="control-label">
                  First Name:
                </label>
                <input
                  required
                  type="text"
                  class="form-control"
                  id="first-name"
                  placeholder="Enter First Name"
                  v-model="householdDetails.first_name"
                />
                <div v-if="this.errors.first_name">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.first_name[0]
                  }}</label>
                </div>
              </div>
            </div>
          </div>
          <div class="row">
            <div class="col-sm-4">
              <div class="form-group">
                <label for="middle-name" class="control-label">
                  Middle Name:
                </label>
                <input
                  required
                  type="text"
                  class="form-control"
                  id="middle-name"
                  placeholder="Enter Middle Name"
                  v-model="householdDetails.middle_name"
                />
                <div v-if="this.errors.middle_name">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.middle_name[0]
                  }}</label>
                </div>
              </div>
            </div>
            <div class="col-sm-4">
              <div class="form-group">
                <label for="last-name" class="control-label">
                  Last Name:
                </label>
                <input
                  required
                  type="text"
                  class="form-control"
                  id="last-name"
                  placeholder="Enter Last Name"
                  v-model="householdDetails.last_name"
                />
                <div v-if="this.errors.last_name">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.last_name[0]
                  }}</label>
                </div>
              </div>
            </div>
            <div class="col-sm-4">
              <div class="form-group">
                <label for="gender" class="control-label"> Sex: </label>
                <input
                  required
                  type="text"
                  class="form-control"
                  id="gender"
                  placeholder="Enter Sex"
                  v-model="householdDetails.sex"
                />
                <div v-if="this.errors.sex">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.sex[0]
                  }}</label>
                </div>
              </div>
            </div>
          </div>
          <div class="row">
            <div class="col-sm-4">
              <div class="form-group">
                <label for="birthdate" class="control-label">
                  Birthdate:
                </label>
                <input
                  required
                  type="date"
                  class="form-control"
                  id="birthdate"
                  placeholder="Enter Birthdate"
                  v-model="householdDetails.birthdate"
                />
                <div v-if="this.errors.birthdate">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.birthdate[0]
                  }}</label>
                </div>
              </div>
            </div>
            <div class="col-sm-4">
              <div class="form-group">
                <label for="civil-status" class="control-label">
                  Civil Status:
                </label>
                <select
                  class="form-select"
                  name="civil-status"
                  id="civil_status"
                  v-model="householdDetails.civil_status"
                >
                  <option value="Single">Single</option>
                  <option value="Married">Married</option>
                  <option value="Divorced">Divorced</option>
                  <option value="Widowed">Widowed</option>
                </select>
                <div v-if="this.errors.civil_status">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.civil_status[0]
                  }}</label>
                </div>
              </div>
            </div>
          </div>
          <div class="row">
            <div class="col-sm-4">
              <div class="form-group">
                <label for="relationship" class="control-label">
                  Relationship:
                </label>
                <select
                  class="form-select"
                  name="relationship"
                  id="relationship"
                  v-model="householdDetails.relationship"
                >
                  <option value="Father">Father</option>
                  <option value="Mother">Mother</option>
                  <option value="Son">Son</option>
                  <option value="Daughter">Daughter</option>
                </select>
                <div v-if="this.errors.relationship">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.relationship[0]
                  }}</label>
                </div>
              </div>
            </div>
            <div class="col-sm-4">
              <div class="form-group">
                <label for="education" class="control-label">
                  Highest Educational Attainment:
                </label>
                <select
                  class="form-select"
                  name="education"
                  id="education"
                  v-model="householdDetails.education"
                >
                  <option value="Day Care">Day Care</option>
                  <option value="Nursery">Nursery</option>
                  <option value="Kinder">Kinder</option>
                  <option value="Elementary Level">Elementary Level</option>
                  <option value="Elementary Grad">Elementary Grad</option>
                  <option value="ALS High School">ALS High School</option>
                  <option value="High School Level">High School Level</option>
                  <option value="High School Grad">High School Grad</option>
                  <option value="Senior High">Senior High</option>
                  <option value="Vocational">Vocational</option>
                  <option value="College Level">College Level</option>
                  <option value="College Grad">College Grad</option>
                  <option value="Post Graduate">Post Graduate</option>
                </select>
                <div v-if="this.errors.education">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.education[0]
                  }}</label>
                </div>
              </div>
            </div>
            <div class="col-sm-4">
              <div class="form-group">
                <label for="occupation" class="control-label">
                  Occupation:
                </label>
                <select
                  class="form-select"
                  name="occupation"
                  id="occupation"
                  v-model="householdDetails.occupation"
                >
                  <option value="Government Employee">
                    Government Employee
                  </option>
                  <option value="Private Employee">Private Employee</option>
                  <option value="Barangay Employee">Barangay Employee</option>
                  <option value="Barangay Volunteers">
                    Barangay Volunteers
                  </option>
                  <option value="OFW">OFW</option>
                  <option value="Business">Business</option>
                  <option value="Carpenter">Carpenter</option>
                  <option value="Laborer/Construction">
                    Laborer/Construction
                  </option>
                  <option value="Driver">Driver</option>
                  <option value="Sari-sari Store">Sari-sari Store</option>
                  <option value="Helper">Helper</option>
                  <option value="Vendor">Vendor</option>
                  <option value="Self-Employed">Self-Employed</option>
                </select>
                <div v-if="this.errors.occupation">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.occupation[0]
                  }}</label>
                </div>
              </div>
            </div>
          </div>
          <div class="row">
            <div class="col-sm-4">
              <div class="form-group">
                <label for="method" class="control-label">
                  Family Planning Method:
                </label>
                <select
                  class="form-select"
                  name="method"
                  id="fp-method"
                  v-model="householdDetails.fp_method"
                >
                  <option value="Vasectomy">Vasectomy</option>
                  <option value="Tubal Ligation">Tubal Ligation</option>
                  <option value="Implant">Implant</option>
                  <option value="Condom">Condom</option>
                  <option value="IUD">IUD</option>
                  <option value="Pills">Pills</option>
                  <option value="Injectable">Injectable</option>
                  <option value="NFP">NFP</option>
                </select>
                <div v-if="this.errors.fp_method">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.fp_method[0]
                  }}</label>
                </div>
              </div>
            </div>
            <div class="col-sm-4">
              <div class="form-group">
                <label for="pwd-status" class="control-label">
                  PWD Status:
                </label>
                <select
                  class="form-select"
                  name="pwd-status"
                  id="pwd_status"
                  v-model="householdDetails.pwd_status"
                >
                  <option value="Yes">Yes</option>
                  <option value="No">No</option>
                </select>
                <div v-if="this.errors.pwd_status">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.pwd_status[0]
                  }}</label>
                </div>
              </div>
            </div>
            <div class="col-sm-4">
              <div class="form-group">
                <label for="senior-citizen" class="control-label">
                  Senior Citizen:
                </label>
                <select
                  class="form-select"
                  name="senior-citizen"
                  id="senior_citizen"
                  v-model="householdDetails.senior_citizen"
                >
                  <option value="Yes">Yes</option>
                  <option value="No">No</option>
                </select>
                <div v-if="this.errors.senior_citizen">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.senior_citizen[0]
                  }}</label>
                </div>
              </div>
            </div>
          </div>
          <div class="row">
            <div class="col-sm-4">
              <div class="form-group">
                <label for="oosy" class="control-label">
                  Out of School Youth:
                </label>
                <select
                  class="form-select"
                  name="oosy"
                  id="oosy"
                  v-model="householdDetails.oosy"
                >
                  <option value="Yes">Yes</option>
                  <option value="No">No</option>
                </select>
                <div v-if="this.errors.oosy">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.oosy[0]
                  }}</label>
                </div>
              </div>
            </div>
            <div class="col-sm-4">
              <div class="form-group">
                <label for="residency" class="control-label">
                  How long of Residency:
                </label>
                <br>
                <small>
                  Year Started
                </small>
                <select
                  class="form-control"
                  id="residency"
                  v-model="householdDetails.residency"
                >
                  <option 
                  v-for="(year, index) in years"
                    :key="index"
                    :value="year"
                  >{{ year }}</option>
                </select>
                <div v-if="this.errors.residency">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.residency[0]
                  }}</label>
                </div>
                <small>
                  Year Ended
                </small>
                <select
                  class="form-control"
                  id="residency_end"
                  v-model="householdDetails.residency_end"
                >
                  <option v-bind:value="null">Present (Currently a resident)</option>
                  <option 
                  v-for="(year, index) in years"
                    :key="index"
                    :value="year"
                  >{{ year }}</option>
                </select>
                <div v-if="this.errors.residency_end">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.residency_end[0]
                  }}</label>
                </div>
              </div>
            </div>
            <div class="col-sm-4">
              <div class="form-group">
                <label for="address" class="control-label">
                  Previous Address:
                </label>
                <input
                  required
                  type="text"
                  class="form-control"
                  id="address"
                  placeholder="Enter Address"
                  v-model="householdDetails.address"
                />
                <div v-if="this.errors.address">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.address[0]
                  }}</label>
                </div>
              </div>
            </div>
            <div class="row">
              <div class="col-sm-4">
                <div class="form-group">
                  <label for="first-name" class="control-label"> Zone: </label>
                  <select
                    class="form-select"
                    name="zone"
                    id="zone"
                    v-model="householdDetails.zone_id"
                  >
                    <option
                      v-for="zone in zones"
                      :key="zone.id"
                      :value="zone.id"
                    >
                      {{ zone.zone_description }}
                    </option>
                  </select>
                  <div v-if="this.errors.zone_id">
                    <label style="color: red; font-weight: 500">{{
                      this.errors.zone_id[0]
                    }}</label>
                  </div>
                </div>
              </div>
              <div class="col-sm-8">
                <div class="form-group">
                  <label for="remarks" class="control-label"> Remarks: </label>
                  <input
                    type="text"
                    class="form-control"
                    id="remarks"
                    placeholder="Enter here"
                    v-model="householdDetails.remarks"
                  />
                  <div v-if="this.errors.remarks">
                    <label style="color: red; font-weight: 500">{{
                      this.errors.remarks[0]
                    }}</label>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div
          class="mt-4 d-flex justify-content-end"
          v-if="permission == 'bspo'"
        >
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
    <b-modal
      class="view_member_modal"
      id="modal-view-member"
      title="Household Member Information"
      size="xl"
      centered
      :hide-footer="true"
    >
      <form @submit.prevent="updateHouseholdMember" class="row">
        <div class="col">
          <div class="row">
            <div class="col-sm-4">
              <div class="form-group">
                <label for="household-number" class="control-label">
                  Household No.
                </label>
                <input
                  required
                  type="text"
                  class="form-control"
                  id="household-num"
                  placeholder="Enter Household Number"
                  v-model="familyMember.household_num"
                />
                <div v-if="this.errors.household_num">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.household_num[0]
                  }}</label>
                </div>
              </div>
            </div>
            <div class="col-sm-4">
              <div class="form-group">
                <label for="family-number" class="control-label">
                  Family Number:
                </label>
                <input
                  required
                  type="text"
                  class="form-control"
                  id="family-number"
                  placeholder="Enter Family Number"
                  v-model="familyMember.family_num"
                />
                <div v-if="this.errors.family_num">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.family_num[0]
                  }}</label>
                </div>
              </div>
            </div>
            <div class="col-sm-4">
              <div class="form-group">
                <label for="first-name" class="control-label">
                  First Name:
                </label>
                <input
                  required
                  type="text"
                  class="form-control"
                  id="first-name"
                  placeholder="Enter First Name"
                  v-model="familyMember.first_name"
                />
                <div v-if="this.errors.first_name">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.first_name[0]
                  }}</label>
                </div>
              </div>
            </div>
          </div>
          <div class="row">
            <div class="col-sm-4">
              <div class="form-group">
                <label for="middle-name" class="control-label">
                  Middle Name:
                </label>
                <input
                  required
                  type="text"
                  class="form-control"
                  id="middle-name"
                  placeholder="Enter Middle Name"
                  v-model="familyMember.middle_name"
                />
                <div v-if="this.errors.middle_name">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.middle_name[0]
                  }}</label>
                </div>
              </div>
            </div>
            <div class="col-sm-4">
              <div class="form-group">
                <label for="last-name" class="control-label">
                  Last Name:
                </label>
                <input
                  required
                  type="text"
                  class="form-control"
                  id="last-name"
                  placeholder="Enter Last Name"
                  v-model="familyMember.last_name"
                />
                <div v-if="this.errors.last_name">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.last_name[0]
                  }}</label>
                </div>
              </div>
            </div>
            <div class="col-sm-4">
              <div class="form-group">
                <label for="gender" class="control-label"> Sex: </label>
                <input
                  required
                  type="text"
                  class="form-control"
                  id="gender"
                  placeholder="Enter Sex"
                  v-model="familyMember.sex"
                />
                <div v-if="this.errors.sex">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.sex[0]
                  }}</label>
                </div>
              </div>
            </div>
          </div>
          <div class="row">
            <div class="col-sm-4">
              <div class="form-group">
                <label for="birthdate" class="control-label">
                  Birthdate:
                </label>
                <input
                  required
                  type="date"
                  class="form-control"
                  id="birthdate"
                  placeholder="Enter Birthdate"
                  v-model="familyMember.birthdate"
                />
                <div v-if="this.errors.birthdate">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.birthdate[0]
                  }}</label>
                </div>
              </div>
            </div>
            <div class="col-sm-4">
              <div class="form-group">
                <label for="civil-status" class="control-label">
                  Civil Status:
                </label>
                <select
                  class="form-select"
                  name="civil-status"
                  id="civil_status"
                  v-model="familyMember.civil_status"
                >
                  <option value="Single">Single</option>
                  <option value="Married">Married</option>
                  <option value="Divorced">Divorced</option>
                  <option value="Widowed">Widowed</option>
                </select>
                <div v-if="this.errors.civil_status">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.civil_status[0]
                  }}</label>
                </div>
              </div>
            </div>
          </div>
          <div class="row">
            <div class="col-sm-4">
              <div class="form-group">
                <label for="relationship" class="control-label">
                  Relationship:
                </label>
                <select
                  class="form-select"
                  name="relationship"
                  id="relationship"
                  v-model="familyMember.relationship"
                >
                  <option value="Father">Father</option>
                  <option value="Mother">Mother</option>
                  <option value="Son">Son</option>
                  <option value="Daughter">Daughter</option>
                </select>
                <div v-if="this.errors.relationship">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.relationship[0]
                  }}</label>
                </div>
              </div>
            </div>
            <div class="col-sm-4">
              <div class="form-group">
                <label for="education" class="control-label">
                  Highest Educational Attainment:
                </label>
                <select
                  class="form-select"
                  name="education"
                  id="education"
                  v-model="familyMember.education"
                >
                  <option value="Day Care">Day Care</option>
                  <option value="Nursery">Nursery</option>
                  <option value="Kinder">Kinder</option>
                  <option value="Elementary Level">Elementary Level</option>
                  <option value="Elementary Grad">Elementary Grad</option>
                  <option value="ALS High School">ALS High School</option>
                  <option value="High School Level">High School Level</option>
                  <option value="High School Grad">High School Grad</option>
                  <option value="Senior High">Senior High</option>
                  <option value="Vocational">Vocational</option>
                  <option value="College Level">College Level</option>
                  <option value="College Grad">College Grad</option>
                  <option value="Post Graduate">Post Graduate</option>
                </select>
                <div v-if="this.errors.education">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.education[0]
                  }}</label>
                </div>
              </div>
            </div>
            <div class="col-sm-4">
              <div class="form-group">
                <label for="occupation" class="control-label">
                  Occupation:
                </label>
                <select
                  class="form-select"
                  name="occupation"
                  id="occupation"
                  v-model="familyMember.occupation"
                >
                  <option value="Government Employee">
                    Government Employee
                  </option>
                  <option value="Private Employee">Private Employee</option>
                  <option value="Barangay Employee">Barangay Employee</option>
                  <option value="Barangay Volunteers">
                    Barangay Volunteers
                  </option>
                  <option value="OFW">OFW</option>
                  <option value="Business">Business</option>
                  <option value="Carpenter">Carpenter</option>
                  <option value="Laborer/Construction">
                    Laborer/Construction
                  </option>
                  <option value="Driver">Driver</option>
                  <option value="Sari-sari Store">Sari-sari Store</option>
                  <option value="Helper">Helper</option>
                  <option value="Vendor">Vendor</option>
                  <option value="Self-Employed">Self-Employed</option>
                </select>
                <div v-if="this.errors.occupation">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.occupation[0]
                  }}</label>
                </div>
              </div>
            </div>
          </div>
          <div class="row">
            <div class="col-sm-4">
              <div class="form-group">
                <label for="method" class="control-label">
                  Family Planning Method:
                </label>
                <select
                  class="form-select"
                  name="method"
                  id="fp-method"
                  v-model="familyMember.fp_method"
                >
                  <option value="Vasectomy">Vasectomy</option>
                  <option value="Tubal Ligation">Tubal Ligation</option>
                  <option value="Implant">Implant</option>
                  <option value="Condom">Condom</option>
                  <option value="IUD">IUD</option>
                  <option value="Pills">Pills</option>
                  <option value="Injectable">Injectable</option>
                  <option value="NFP">NFP</option>
                </select>
                <div v-if="this.errors.fp_method">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.fp_method[0]
                  }}</label>
                </div>
              </div>
            </div>
            <div class="col-sm-4">
              <div class="form-group">
                <label for="pwd-status" class="control-label">
                  PWD Status:
                </label>
                <select
                  class="form-select"
                  name="pwd-status"
                  id="pwd_status"
                  v-model="familyMember.pwd_status"
                >
                  <option value="Yes">Yes</option>
                  <option value="No">No</option>
                </select>
                <div v-if="this.errors.pwd_status">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.pwd_status[0]
                  }}</label>
                </div>
              </div>
            </div>
            <div class="col-sm-4">
              <div class="form-group">
                <label for="senior-citizen" class="control-label">
                  Senior Citizen:
                </label>
                <select
                  class="form-select"
                  name="senior-citizen"
                  id="senior_citizen"
                  v-model="familyMember.senior_citizen"
                >
                  <option value="Yes">Yes</option>
                  <option value="No">No</option>
                </select>
                <div v-if="this.errors.senior_citizen">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.senior_citizen[0]
                  }}</label>
                </div>
              </div>
            </div>
          </div>
          <div class="row">
            <div class="col-sm-4">
              <div class="form-group">
                <label for="oosy" class="control-label">
                  Out of School Youth:
                </label>
                <select
                  class="form-select"
                  name="oosy"
                  id="oosy"
                  v-model="familyMember.oosy"
                >
                  <option value="Yes">Yes</option>
                  <option value="No">No</option>
                </select>
                <div v-if="this.errors.oosy">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.oosy[0]
                  }}</label>
                </div>
              </div>
            </div>
            <div class="col-sm-4">
              <div class="form-group">
                <label class="control-label mb-1">
                  How long of Residency:
                </label>
                <br>
                <small>
                  Year Started
                </small>
                <select
                  class="form-control"
                  id="residency"
                  v-model="familyMember.residency"
                >
                  <option 
                  v-for="(year, index) in years"
                    :key="index"
                    :value="year"
                  >{{ year }}</option>
                </select>
                <div v-if="this.errors.residency">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.residency[0]
                  }}</label>
                </div>
                <small>
                  Year Ended
                </small>
                <select
                  class="form-control"
                  id="residency_end"
                  v-model="familyMember.residency_end"
                >
                  <option v-bind:value="null">Present (Currently a resident)</option>
                  <option 
                  v-for="(year, index) in years"
                    :key="index"
                    :value="year"
                  >{{ year }}</option>
                </select>
                <div v-if="this.errors.residency_end">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.residency_end[0]
                  }}</label>
                </div>
              </div>
            </div>
            <div class="col-sm-4">
              <div class="form-group">
                <label for="address" class="control-label">
                  Previous Address:
                </label>
                <input
                  required
                  type="text"
                  class="form-control"
                  id="address"
                  placeholder="Enter Address"
                  v-model="familyMember.address"
                />
                <div v-if="this.errors.address">
                  <label style="color: red; font-weight: 500">{{
                    this.errors.address[0]
                  }}</label>
                </div>
              </div>
            </div>
            <div class="row">
              <div class="col-sm-4">
                <div class="form-group">
                  <label for="first-name" class="control-label"> Zone: </label>
                  <select
                    class="form-select"
                    name="zone"
                    id="zone"
                    v-model="familyMember.zone_id"
                  >
                    <option
                      v-for="zone in zones"
                      :key="zone.id"
                      :value="zone.id"
                    >
                      {{ zone.zone_description }}
                    </option>
                  </select>
                  <div v-if="this.errors.zone_id">
                    <label style="color: red; font-weight: 500">{{
                      this.errors.zone_id[0]
                    }}</label>
                  </div>
                </div>
              </div>
              <div class="col-sm-8">
                <div class="form-group">
                  <label for="remarks" class="control-label"> Remarks: </label>
                  <input
                    type="text"
                    class="form-control"
                    id="remarks"
                    placeholder="Enter here"
                    v-model="familyMember.remarks"
                  />
                  <div v-if="this.errors.remarks">
                    <label style="color: red; font-weight: 500">{{
                      this.errors.remarks[0]
                    }}</label>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div
          class="mt-4 d-flex justify-content-end"
          v-if="permission == 'secretary' || permission == 'admin'"
        >
          <button
            class="btn btn-danger"
            type="button"
            @click="closeViewMemberDetails"
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
      zone_id: 1,
      household_num: null,
      family_num: null,
      first_name: "",
      middle_name: "",
      last_name: "",
      sex: "",
      birthdate: "",
      civil_status: "Single",
      age: null,
      relationship: "Father",
      education: "Day Care",
      occupation: "Government Employee",
      fp_method: "Vasectomy",
      pwd_status: "No",
      senior_citizen: "No",
      years: [],
      oosy: "No",
      residency: null,
      residency_end: null,
      address: "",
      remarks: "",
      errors: [],
      households: [],
      householdMembers: [],
      householdDetails: {},
      familyMember: {
        zone_id: 1,
        family_num: null,
        first_name: "",
        middle_name: "",
        last_name: "",
        sex: "",
        birthdate: "",
        civil_status: "Single",
        age: null,
        relationship: "Father",
        education: "Day Care",
        occupation: "Government Employee",
        fp_method: "Vasectomy",
        pwd_status: "No",
        senior_citizen: "No",
        oosy: "No",
        residency: null,
        residency_end: null,
        address: "",
        remarks: "",
      },
      search: "",
      loading: true,
      currentPage: 0,
      rows: 0,
      perPage: 0,

      permission: localStorage.getItem("permission"),
    };
  },

  computed: {
    zones() {
      return this.$store.getters["ZONES/GET_ZONES"];
    },
  },

  methods: {
    async fetchHouseholdHeads() {
      if (!this.loading) {
        this.loading = true;
        await axios
          .get(`/household?page=${this.currentPage}&search=${this.search}`)
          .then((response) => {
            this.households = response.data.data;
            this.currentPage = response.data.current_page;
            this.rows = response.data.total;
            this.perPage = response.data.per_page;
            this.loading = false;
          })
          .catch((error) => {
            this.loading = false;
            return error.response;
          });
      }
    },

    getAge(birthdate) {
      let age = moment().diff(birthdate, 'years');
      return age >= 1 ? age : 0
    },

    async createHousehold() {
      const data = {
        household_num: this.household_num,
        family_num: this.family_num,
        first_name: this.first_name,
        middle_name: this.middle_name,
        last_name: this.last_name,
        sex: this.sex,
        birthdate: this.birthdate,
        civil_status: this.civil_status,
        age: this.age,
        relationship: this.relationship,
        education: this.education,
        occupation: this.occupation,
        fp_method: this.fp_method,
        pwd_status: this.pwd_status,
        senior_citizen: this.senior_citizen,
        oosy: this.oosy,
        residency: this.residency,
        residency_end: this.residency_end,
        address: this.address,
        zone_id: this.zone_id,
        remarks: this.remarks,
        remember_token: localStorage.getItem("token"),
      };
      await axios
        .post("/household", data)
        .then(() => {
          this.$toast.success("Household head has been created.");
          this.resetFields();
          this.$bvModal.hide("modal-add");
          this.loading = false;
          this.fetchHouseholdHeads();
        })
        .catch((error) => {
          this.errors = error.response.data.errors;
        });
    },

    async createHouseholdMember() {
      const data = {
        household_head_id: this.householdDetails.id,
        household_num: this.householdDetails.household_num,
        family_num: this.familyMember.family_num,
        first_name: this.familyMember.first_name,
        middle_name: this.familyMember.middle_name,
        last_name: this.familyMember.last_name,
        sex: this.familyMember.sex,
        birthdate: this.familyMember.birthdate,
        civil_status: this.familyMember.civil_status,
        age: this.familyMember.age,
        relationship: this.familyMember.relationship,
        education: this.familyMember.education,
        occupation: this.familyMember.occupation,
        fp_method: this.familyMember.fp_method,
        pwd_status: this.familyMember.pwd_status,
        senior_citizen: this.familyMember.senior_citizen,
        oosy: this.familyMember.oosy,
        residency: this.familyMember.residency,
        residency_end: this.familyMember.residency_end,
        address: this.familyMember.address,
        zone_id: this.familyMember.zone_id,
        remarks: this.familyMember.remarks,
        remember_token: localStorage.getItem("token"),
      };
      await axios
        .post("/household-new-member", data)
        .then(() => {
          this.$toast.success("Household member has been saved.");
          this.resetFields();
          this.closeViewDetails();
          this.loading = false;
          this.fetchHouseholdHeads();
        })
        .catch((error) => {
          this.errors = error.response.data.errors;
        });
    },

    async updateHouseholdMember() {
      const data = {
        id: this.familyMember.id,
        household_head_id: this.householdDetails.id,
        household_num: this.familyMember.household_num,
        family_num: this.familyMember.family_num,
        first_name: this.familyMember.first_name,
        middle_name: this.familyMember.middle_name,
        last_name: this.familyMember.last_name,
        sex: this.familyMember.sex,
        birthdate: this.familyMember.birthdate,
        civil_status: this.familyMember.civil_status,
        age: this.familyMember.age,
        relationship: this.familyMember.relationship,
        education: this.familyMember.education,
        occupation: this.familyMember.occupation,
        fp_method: this.familyMember.fp_method,
        pwd_status: this.familyMember.pwd_status,
        senior_citizen: this.familyMember.senior_citizen,
        oosy: this.familyMember.oosy,
        residency: this.familyMember.residency,
        residency_end: this.familyMember.residency_end,
        address: this.familyMember.address,
        zone_id: this.familyMember.zone_id,
        remarks: this.familyMember.remarks,
        remember_token: localStorage.getItem("token"),
      };
      await axios
        .put(`/update-household-member-record/${data.id}`, data)
        .then(() => {
          this.resetFields();
          this.$toast.success("Household member record has been updated.");
          this.$bvModal.hide("modal-view-member");
          this.loading = false;
          this.fetchHouseholdHeads();
        })
        .catch((error) => {
          this.loading = false;
          this.errors = error.response.data.errors;
        });
    },

    async updateHousehold() {
      const data = {
        id: this.householdDetails.id,
        household_num: this.householdDetails.household_num,
        family_num: this.householdDetails.family_num,
        first_name: this.householdDetails.first_name,
        middle_name: this.householdDetails.middle_name,
        last_name: this.householdDetails.last_name,
        sex: this.householdDetails.sex,
        birthdate: this.householdDetails.birthdate,
        civil_status: this.householdDetails.civil_status,
        age: this.householdDetails.age,
        relationship: this.householdDetails.relationship,
        education: this.householdDetails.education,
        occupation: this.householdDetails.occupation,
        fp_method: this.householdDetails.fp_method,
        pwd_status: this.householdDetails.pwd_status,
        senior_citizen: this.householdDetails.senior_citizen,
        oosy: this.householdDetails.oosy,
        residency: this.householdDetails.residency,
        residency_end: this.householdDetails.residency_end,
        address: this.householdDetails.address,
        zone_id: this.householdDetails.zone_id,
        remarks: this.householdDetails.remarks,
        remember_token: localStorage.getItem("token"),
      };
      await axios
        .put(`/update-household-head-record/${data.id}`, data)
        .then(() => {
          this.resetFields();
          this.$toast.success("Household record has been updated.");
          this.closeViewDetails();
          this.loading = false;
          this.fetchHouseholdHeads();
        })
        .catch((error) => {
          this.loading = false;
          this.errors = error.response.data.errors;
        });
    },

    async deleteHousehold(id) {
      const data = {
        remember_token: localStorage.getItem("token"),
      };
      await axios
        .post(`/delete-household-member-record/${id}`, data)
        .then(() => {
          this.resetFields();
          this.$bvModal.hide("modal-view-members");
          this.$toast.success("Household member record has been deleted.");
          this.loading = false;
          this.fetchHouseholdHeads();
        })
        .catch((error) => {
          this.errors = error.response.data.errors;
        });
    },

    async fetchZones() {
      await this.$store.dispatch("ZONES/FETCH_ZONES");
    },

    async resetFields() {
      this.$bvModal.hide("modal-add");
      (this.familyMember.zone_id = 1),
        (this.familyMember.family_num = null),
        (this.familyMember.first_name = ""),
        (this.familyMember.middle_name = ""),
        (this.familyMember.last_name = ""),
        (this.familyMember.sex = ""),
        (this.familyMember.birthdate = ""),
        (this.familyMember.civil_status = "Single"),
        (this.familyMember.age = null),
        (this.familyMember.relationship = "Father"),
        (this.familyMember.education = "Day Care"),
        (this.familyMember.occupation = "Government Employee"),
        (this.familyMember.fp_method = "Vasectomy"),
        (this.familyMember.pwd_status = "No"),
        (this.familyMember.senior_citizen = "No"),
        (this.familyMember.oosy = "No"),
        (this.familyMember.residency = null),
        (this.familyMember.residency_end = null),
        (this.familyMember.address = ""),
        (this.familyMember.remarks = ""),
        (this.errors = []);
    },

    viewDetails(data) {
      this.householdDetails = data;
      this.$bvModal.show("modal-view");
    },

    viewMemberDetails(data) {
      this.familyMember = data;
      this.$bvModal.show("modal-view-member");
    },

    viewFamilyMember(data) {
      this.householdMembers = data;
      this.$bvModal.show("modal-view-members");
    },

    addFamilyMember(data) {
      this.householdDetails = data;
      this.$bvModal.show("modal-add-member");
    },

    closeViewDetails() {
      this.householdDetails = {};
      this.$bvModal.hide("modal-view");
      this.$bvModal.hide("modal-add-member");
    },

    closeViewMemberDetails() {
      this.$bvModal.hide("modal-view-member");
    },

    generateYears(){
      var currentYear =  (new Date()).getFullYear();
      this.years = [];
      for(var i = currentYear; i > (currentYear - 100); i--){
        this.years.push(i);
      }
    }
  },



  mounted() {
    this.generateYears();
    this.fetchZones();
    this.loading = false;
    this.fetchHouseholdHeads();
  },
};
</script>
