<#import "template.ftl" as layout>
<#import "components/atoms/button.ftl" as button>
<#import "components/atoms/button-group.ftl" as buttonGroup>
<#import "components/atoms/form.ftl" as form>

<@layout.registrationLayout
  displayMessage=!messagesPerField.existsError("totp")
  ;
  section
>
  <#if section="header">
    ${msg("doLogIn")}
  <#elseif section="form">
    <div class="text-center mb-6">
      <h1 class="text-xl font-semibold text-gray-900 mb-4">
        Enter Sign-In Code
      </h1>
      <p class="text-sm text-gray-600">
        We've sent a code to your email. The code expires shortly, so please enter it soon.
      </p>
    </div>

    <@form.kw action=url.loginAction method="post" id="otp_form">
      <div x-data="otpForm()" x-init="init()" class="space-y-6">
        <!-- Individual digit inputs -->
        <div class="flex justify-center space-x-3" x-ref="otpInputContainer">
          <template x-for="(input, index) in length" :key="index">
            <input
              type="text"
              maxlength="1"
              class="otpInput w-14 h-14 text-center text-2xl font-bold rounded-lg border-2 border-gray-300 focus:border-primary-500 focus:ring-2 focus:ring-primary-200 focus:outline-none transition-all duration-200 bg-white shadow-sm"
              x-on:input="handleInput($event, index)"
              x-on:paste="handlePaste($event)"
              x-on:keydown.backspace="$event.target.value || handleBackspace($event, index)"
              x-on:keydown.arrow-left="handleArrowLeft($event, index)"
              x-on:keydown.arrow-right="handleArrowRight($event, index)"
              autocomplete="off"
            />
          </template>
        </div>

        <!-- Hidden input for form submission -->
        <input type="hidden" name="otp" x-model="value">

        <!-- Error message -->
        <#if messagesPerField.existsError("totp")>
          <div class="p-4 text-sm text-red-800 rounded-lg bg-red-50 border border-red-200" role="alert">
            ${kcSanitize(messagesPerField.get("totp"))}
          </div>
        </#if>

        <!-- Helper text -->
        <p class="text-center text-sm text-gray-500 mt-4">
          Please enter the 6-character code we sent via email.
        </p>

        <!-- Buttons -->
        <div class="flex flex-col space-y-3 mt-6">
          <button class="bg-primary-600 text-white focus:ring-primary-600 hover:bg-primary-700 px-4 py-3 text-sm flex justify-center relative rounded-lg w-full focus:outline-none focus:ring-2 focus:ring-offset-2" name="submit" type="submit" id="otp-submit-btn" style="display: none;">
            ${msg("doLogIn")}
          </button>
          <button class="bg-gray-100 text-gray-700 focus:ring-gray-300 hover:bg-gray-200 px-4 py-3 text-sm flex justify-center relative rounded-lg w-full focus:outline-none focus:ring-2 focus:ring-offset-2 border border-gray-300" name="resend" type="submit">
            Resend Code
          </button>
        </div>
      </div>
    </@form.kw>

    <script>
      function otpForm() {
        return {
          length: 6,
          value: "",

          init() {
            this.$nextTick(() => {
              const firstInput = this.inputs[0];
              if (firstInput) {
                firstInput.focus();
              }
            });
          },

          get inputs() {
            return this.$refs.otpInputContainer.querySelectorAll('.otpInput');
          },

          handleInput(e, index) {
            // Only allow numbers
            const value = e.target.value.replace(/[^0-9]/g, '');
            e.target.value = value;

            const inputValues = [...this.inputs].map(input => input.value);
            this.value = inputValues.join('');

            if (value) {
              const nextInput = this.inputs[index + 1];
              if (nextInput) {
                nextInput.focus();
                nextInput.select();
              } else {
                // All inputs filled, auto-submit
                this.submitForm();
              }
            }
          },

          submitForm() {
            setTimeout(() => {
              document.getElementById("otp-submit-btn").click();
            }, 300);
          },

          handlePaste(e) {
            e.preventDefault();
            const paste = e.clipboardData.getData('text').replace(/[^0-9]/g, '').slice(0, this.length);
            
            paste.split('').forEach((char, i) => {
              if (this.inputs[i]) {
                this.inputs[i].value = char;
              }
            });

            this.value = [...this.inputs].map(input => input.value).join('');
            
            if (paste.length < this.length) {
              this.inputs[paste.length].focus();
            } else {
              this.inputs[this.length - 1].focus();
              this.submitForm();
            }
          },

          handleBackspace(e, index) {
            if (index > 0) {
              this.inputs[index - 1].focus();
              this.inputs[index - 1].select();
            }
          },

          handleArrowLeft(e, index) {
            e.preventDefault();
            if (index > 0) {
              this.inputs[index - 1].focus();
              this.inputs[index - 1].select();
            }
          },

          handleArrowRight(e, index) {
            e.preventDefault();
            if (index < this.length - 1) {
              this.inputs[index + 1].focus();
              this.inputs[index + 1].select();
            }
          }
        };
      }
    </script>
  </#if>
</@layout.registrationLayout>