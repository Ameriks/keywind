<#import "template.ftl" as layout>
<#import "components/atoms/button.ftl" as button>
<#import "components/atoms/button-group.ftl" as buttonGroup>
<#import "components/atoms/form.ftl" as form>
<#import "components/atoms/input.ftl" as input>
<#import "components/atoms/radio.ftl" as radio>
<#import "features/labels/totp.ftl" as totpLabel>

<#assign totpLabel><@totpLabel.kw /></#assign>

<@layout.registrationLayout
  displayMessage=!messagesPerField.existsError("totp")
  ;
  section
>
  <#if section="header">
    ${msg("doLogIn")}
  <#elseif section="form">
    <@form.kw action=url.loginAction method="post">
      <@input.kw
        autocomplete="off"
        autofocus=true
        invalid=messagesPerField.existsError("totp")
        label=totpLabel
        message=kcSanitize(messagesPerField.get("totp"))
        name="otp"
        type="text"
      />
      <@buttonGroup.kw>
        <@button.kw color="primary" name="submit" type="submit">
          ${msg("doLogIn")}
        </@button.kw>
        <@button.kw color="secondary" name="resend" type="submit">
          ${msg("resend")}
        </@button.kw>
      </@buttonGroup.kw>
    </@form.kw>
  </#if>
</@layout.registrationLayout>
