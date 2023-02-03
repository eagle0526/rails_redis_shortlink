// Visit The Stimulus Handbook for more details 
// https://stimulusjs.org/handbook/introduction
// 
// This example controller works with specially annotated HTML like:
//
// <div data-controller="hello">
//   <h1 data-target="hello.output"></h1>
// </div>

import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "url", "utmCampaign", "utmMedium", "utmSource", "utmTerm", "utmContent" ]

  connect() {

  }

  inputUtmCampaign(e) {    
    this.setUrl()

    // this.urlTarget.value = this.urlTarget.value.split("?")[0]
    // ---
    // this.urlTarget.value = ""
    // if (this.utmCampaignTarget.value !== "" && this.utmMediumTarget.value === "") {
    //   this.urlTarget.value = `${this.urlTarget.value}?utm_campaign=${this.utmCampaignTarget.value}`  
    // } else if (this.utmCampaignTarget.value === "" && this.utmMediumTarget.value !== "") {
    //   this.urlTarget.value = `${this.urlTarget.value}?utm_medium=${this.utmMediumTarget.value}`
    // } else {
    //   this.urlTarget.value = `${this.urlTarget.value}?utm_campaign=${this.utmCampaignTarget.value}?utm_medium=${this.utmMediumTarget.value}`
    // }
    // ---

  }

  inputUtmMedium(e) {
    this.setUrl()
  }
 
  inputUtmSource() {
    this.setUrl()       
  }

  inputUtmTerm() {
    this.setUrl()
  }

  inputUtmContent() {
    this.setUrl()
  }

  inputUrl() {
    
    if(this.urlTarget.value.includes("?utm_campaign=")) {
      this.utmCampaignTarget.value = this.urlTarget.value.split("?utm_campaign=")[1].split("?")[0]
    }

    if (this.urlTarget.value.includes("?utm_medium=")) {
      this.utmMediumTarget.value = this.urlTarget.value.split("?utm_medium=")[1].split("?")[0]      
    }

    if (this.urlTarget.value.includes("?utm_source=")) {
      this.utmSourceTarget.value = this.urlTarget.value.split("?utm_source=")[1].split("?")[0]      
    }

    if (this.urlTarget.value.includes("?utm_term=")) {
      this.utmTermTarget.value = this.urlTarget.value.split("?utm_term=")[1].split("?")[0]      
    }

    if (this.urlTarget.value.includes("?utm_content=")) {
      this.utmContentTarget.value = this.urlTarget.value.split("?utm_content=")[1]  
    }
    
  }
  



  setUrl() {

    this.urlTarget.value = this.urlTarget.value.split("?")[0]
    if(this.utmCampaignTarget.value) {
      this.urlTarget.value = `${this.urlTarget.value}?utm_campaign=${this.utmCampaignTarget.value}`  
    }

    if(this.utmMediumTarget.value) {
      this.urlTarget.value = `${this.urlTarget.value}?utm_medium=${this.utmMediumTarget.value}`
    }

    if(this.utmSourceTarget.value) {
      this.urlTarget.value = `${this.urlTarget.value}?utm_source=${this.utmSourceTarget.value}`      
    }
    
    if(this.utmTermTarget.value) {
      this.urlTarget.value = `${this.urlTarget.value}?utm_term=${this.utmTermTarget.value}`      
    }

    if(this.utmContentTarget.value) {
      this.urlTarget.value = `${this.urlTarget.value}?utm_content=${this.utmContentTarget.value}`      
    }
  } 


}
