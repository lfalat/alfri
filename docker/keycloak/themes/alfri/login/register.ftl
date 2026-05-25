<!doctype html>
<html lang="${locale.currentLanguageTag!'sk'}">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Registrácia | ALFRI</title>
  <link rel="icon" href="${url.resourcesPath}/img/favicon.ico" sizes="any">
  <link rel="icon" href="${url.resourcesPath}/img/favicon.svg" type="image/svg+xml">
  <link rel="stylesheet" href="${url.resourcesPath}/css/alfri-login.css">
</head>
<body>
  <header class="alfri-toolbar">
    <div class="alfri-brand" aria-label="ALFRI">
      <img
        src="${url.resourcesPath}/img/logo.svg"
        width="30"
        height="30"
        alt="Alfri logo"
        class="alfri-logo"
      >
      <span>ALFRI</span>
    </div>
  </header>
  <main class="alfri-auth">
    <section class="alfri-card" aria-labelledby="alfri-register-title">
      <aside class="alfri-info">
        <div class="alfri-pattern"></div>
        <div class="alfri-blob alfri-blob-top"></div>
        <div class="alfri-blob alfri-blob-bottom"></div>
        <div class="alfri-info-content">
          <img
            src="${url.resourcesPath}/img/brain_lb.png"
            alt="ALFRI Brain"
            class="alfri-brain"
            width="1408"
            height="1012"
          >
          <h2 class="alfri-info-title">Prvý inteligentný asistent pre študentov a učiteľov FRI UNIZA.</h2>
        </div>
      </aside>

      <section class="alfri-panel">
        <div class="alfri-form-content">
          <header class="alfri-header">
            <h1 id="alfri-register-title" class="alfri-title">Registrácia</h1>
            <p class="alfri-subtitle">Vytvorte si účet pre prístup k systému.</p>
          </header>

          <#if message?has_content>
            <div class="alfri-message alfri-message-${message.type}" role="alert">
              ${kcSanitize(message.summary)?no_esc}
            </div>
          </#if>

          <form id="kc-register-form" class="alfri-form" action="${url.registrationAction}" method="post">
            <div class="alfri-field">
              <label class="alfri-label" for="firstName">Meno</label>
              <input
                id="firstName"
                class="alfri-input"
                name="firstName"
                type="text"
                value="${((register.formData.firstName)!'')}"
                autocomplete="given-name"
                aria-invalid="<#if messagesPerField.existsError('firstName')>true<#else>false</#if>"
              >
              <#if messagesPerField.existsError('firstName')>
                <span class="alfri-error">${kcSanitize(messagesPerField.getFirstError('firstName'))?no_esc}</span>
              </#if>
            </div>

            <div class="alfri-field">
              <label class="alfri-label" for="lastName">Priezvisko</label>
              <input
                id="lastName"
                class="alfri-input"
                name="lastName"
                type="text"
                value="${((register.formData.lastName)!'')}"
                autocomplete="family-name"
                aria-invalid="<#if messagesPerField.existsError('lastName')>true<#else>false</#if>"
              >
              <#if messagesPerField.existsError('lastName')>
                <span class="alfri-error">${kcSanitize(messagesPerField.getFirstError('lastName'))?no_esc}</span>
              </#if>
            </div>

            <div class="alfri-field">
              <label class="alfri-label" for="email">Email</label>
              <input
                id="email"
                class="alfri-input"
                name="email"
                type="email"
                value="${((register.formData.email)!'')}"
                autocomplete="email"
                aria-invalid="<#if messagesPerField.existsError('email')>true<#else>false</#if>"
              >
              <#if messagesPerField.existsError('email')>
                <span class="alfri-error">${kcSanitize(messagesPerField.getFirstError('email'))?no_esc}</span>
              </#if>
            </div>

            <#if !realm.registrationEmailAsUsername>
              <div class="alfri-field">
                <label class="alfri-label" for="username">Používateľské meno</label>
                <input
                  id="username"
                  class="alfri-input"
                  name="username"
                  type="text"
                  value="${((register.formData.username)!'')}"
                  autocomplete="username"
                  aria-invalid="<#if messagesPerField.existsError('username')>true<#else>false</#if>"
                >
                <#if messagesPerField.existsError('username')>
                  <span class="alfri-error">${kcSanitize(messagesPerField.getFirstError('username'))?no_esc}</span>
                </#if>
              </div>
            </#if>

            <#if (passwordRequired?? && passwordRequired) || !passwordRequired??>
              <div class="alfri-field">
                <label class="alfri-label" for="password">Heslo</label>
                <div class="alfri-password-field">
                  <input
                    id="password"
                    class="alfri-input alfri-password-input"
                    name="password"
                    type="password"
                    autocomplete="new-password"
                    aria-invalid="<#if messagesPerField.existsError('password','password-confirm')>true<#else>false</#if>"
                  >
                  <button
                    class="alfri-password-toggle"
                    type="button"
                    data-password-toggle="password"
                    aria-label="Zobraziť heslo"
                    aria-pressed="false"
                  >
                    <svg class="alfri-eye alfri-eye-open" viewBox="0 0 24 24" aria-hidden="true">
                      <path d="M2.1 12s3.6-6.5 9.9-6.5 9.9 6.5 9.9 6.5-3.6 6.5-9.9 6.5S2.1 12 2.1 12Z"></path>
                      <circle cx="12" cy="12" r="3"></circle>
                    </svg>
                    <svg class="alfri-eye alfri-eye-closed" viewBox="0 0 24 24" aria-hidden="true">
                      <path d="m3 3 18 18"></path>
                      <path d="M10.7 5.7A10.7 10.7 0 0 1 12 5.6c6.3 0 9.9 6.4 9.9 6.4a17.7 17.7 0 0 1-3 3.6"></path>
                      <path d="M6.1 6.7A17.4 17.4 0 0 0 2.1 12s3.6 6.5 9.9 6.5c1.8 0 3.4-.5 4.7-1.2"></path>
                      <path d="M9.9 9.9a3 3 0 0 0 4.2 4.2"></path>
                    </svg>
                  </button>
                </div>
                <#if messagesPerField.existsError('password')>
                  <span class="alfri-error">${kcSanitize(messagesPerField.getFirstError('password'))?no_esc}</span>
                </#if>
              </div>

              <div class="alfri-field">
                <label class="alfri-label" for="password-confirm">Potvrdenie hesla</label>
                <div class="alfri-password-field">
                  <input
                    id="password-confirm"
                    class="alfri-input alfri-password-input"
                    name="password-confirm"
                    type="password"
                    autocomplete="new-password"
                    aria-invalid="<#if messagesPerField.existsError('password-confirm')>true<#else>false</#if>"
                  >
                  <button
                    class="alfri-password-toggle"
                    type="button"
                    data-password-toggle="password-confirm"
                    aria-label="Zobraziť heslo"
                    aria-pressed="false"
                  >
                    <svg class="alfri-eye alfri-eye-open" viewBox="0 0 24 24" aria-hidden="true">
                      <path d="M2.1 12s3.6-6.5 9.9-6.5 9.9 6.5 9.9 6.5-3.6 6.5-9.9 6.5S2.1 12 2.1 12Z"></path>
                      <circle cx="12" cy="12" r="3"></circle>
                    </svg>
                    <svg class="alfri-eye alfri-eye-closed" viewBox="0 0 24 24" aria-hidden="true">
                      <path d="m3 3 18 18"></path>
                      <path d="M10.7 5.7A10.7 10.7 0 0 1 12 5.6c6.3 0 9.9 6.4 9.9 6.4a17.7 17.7 0 0 1-3 3.6"></path>
                      <path d="M6.1 6.7A17.4 17.4 0 0 0 2.1 12s3.6 6.5 9.9 6.5c1.8 0 3.4-.5 4.7-1.2"></path>
                      <path d="M9.9 9.9a3 3 0 0 0 4.2 4.2"></path>
                    </svg>
                  </button>
                </div>
                <#if messagesPerField.existsError('password-confirm')>
                  <span class="alfri-error">${kcSanitize(messagesPerField.getFirstError('password-confirm'))?no_esc}</span>
                </#if>
              </div>
            </#if>

            <#if termsAcceptanceRequired??>
              <label class="alfri-checkbox">
                <input id="termsAccepted" name="termsAccepted" type="checkbox">
                <span>Súhlasím s podmienkami používania</span>
              </label>
            </#if>

            <#if recaptchaRequired??>
              <div class="g-recaptcha" data-size="compact" data-sitekey="${recaptchaSiteKey}"></div>
            </#if>

            <button class="alfri-primary" type="submit">Registrovať</button>
          </form>

          <div class="alfri-divider"><span>Alebo</span></div>
          <p class="alfri-prompt">
            Už máte účet?
            <a class="alfri-link" href="${url.loginUrl}">Prihláste sa</a>
          </p>
        </div>
      </section>
    </section>
  </main>
  <script src="${url.resourcesPath}/js/password-toggle.js"></script>
</body>
</html>
