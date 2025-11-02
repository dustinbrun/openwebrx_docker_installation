// Receiver plugins initialization.
// everything after '//' is a comment.

// uncomment the next line to enable plugin debugging in browser console.
// Plugins._enable_debug = true;

// base URL for receiver plugins
const rp_url = 'https://0xaf.github.io/openwebrxplus-plugins/receiver';

// First load the utils, needed for some plugins
Plugins.load('utils').then(async function () {

  // Load the notification plugin, used by some plugins. await to ensure it is loaded before the rest.
  await Plugins.load('notify');

  // load remote plugins
  Plugins.load('colorful_spectrum');
  Plugins.load('doppler');
  Plugins.load('frequency_far_jump');
  Plugins.load('keyboard_shortcuts');
  Plugins.load('magic_key');
  Plugins.load('frequency_far_jump');
});
