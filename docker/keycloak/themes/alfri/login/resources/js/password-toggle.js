document.querySelectorAll('[data-password-toggle]').forEach((button) => {
  const input = document.getElementById(button.dataset.passwordToggle);

  if (!input) {
    return;
  }

  button.addEventListener('click', () => {
    const shouldShowPassword = input.type === 'password';

    input.type = shouldShowPassword ? 'text' : 'password';
    button.setAttribute('aria-pressed', String(shouldShowPassword));
    button.setAttribute('aria-label', shouldShowPassword ? 'Skryť heslo' : 'Zobraziť heslo');
  });
});
