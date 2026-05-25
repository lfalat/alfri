<!doctype html>
<html lang="${locale.currentLanguageTag!'sk'}">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Prihlásenie | ALFRI</title>
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
    <section class="alfri-card" aria-labelledby="alfri-login-title">
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
            <h1 id="alfri-login-title" class="alfri-title">Prihlásenie</h1>
            <p class="alfri-subtitle">Zadajte svoje prihlasovacie údaje pre prístup.</p>
          </header>

          <#if message?has_content && (message.type != "warning" || !isAppInitiatedAction??)>
            <div class="alfri-message alfri-message-${message.type}" role="alert">
              ${kcSanitize(message.summary)?no_esc}
            </div>
          </#if>

          <form id="kc-form-login" class="alfri-form" action="${url.loginAction}" method="post">
            <#if !usernameHidden??>
              <div class="alfri-field">
                <label class="alfri-label" for="username">
                  <#if !realm.loginWithEmailAllowed>
                    Používateľské meno
                  <#elseif !realm.registrationEmailAsUsername>
                    Používateľské meno alebo email
                  <#else>
                    Email
                  </#if>
                </label>
                <input
                  id="username"
                  class="alfri-input"
                  name="username"
                  type="text"
                  value="${((login.username)!'')}"
                  autocomplete="username"
                  autofocus
                  aria-invalid="<#if messagesPerField.existsError('username','password')>true<#else>false</#if>"
                >
                <#if messagesPerField.existsError('username','password')>
                  <span class="alfri-error">${kcSanitize(messagesPerField.getFirstError('username','password'))?no_esc}</span>
                </#if>
              </div>
            </#if>

            <div class="alfri-field">
              <label class="alfri-label" for="password">Heslo</label>
              <div class="alfri-password-field">
                <input
                  id="password"
                  class="alfri-input alfri-password-input"
                  name="password"
                  type="password"
                  autocomplete="current-password"
                  aria-invalid="<#if messagesPerField.existsError('username','password')>true<#else>false</#if>"
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
            </div>

            <#if realm.rememberMe && !usernameHidden??>
              <label class="alfri-checkbox">
                <input id="rememberMe" name="rememberMe" type="checkbox" <#if login.rememberMe??>checked</#if>>
                <span>Zapamätať prihlásenie</span>
              </label>
            </#if>

            <div class="alfri-actions">
              <button class="alfri-primary" type="submit">Prihlásiť sa</button>
            </div>
          </form>

          <#if realm.password && social?? && social.providers?has_content>
            <div class="alfri-divider"><span>${msg("identity-provider-login-label")}</span></div>
            <div class="alfri-social">
              <#list social.providers as provider>
                <a class="alfri-social-link" href="${provider.loginUrl}">
                  ${provider.displayName!provider.alias}
                </a>
              </#list>
            </div>
          </#if>

          <#if realm.password && realm.registrationAllowed && !registrationDisabled??>
            <div class="alfri-divider"><span>Alebo</span></div>
            <p class="alfri-prompt">
              Nemáte účet?
              <a class="alfri-link" href="${url.registrationUrl}">Registrujte sa</a>
            </p>
          </#if>
        </div>
      </section>
    </section>
  </main>
  <script src="${url.resourcesPath}/js/password-toggle.js"></script>
</body>
</html>
