import TiFirebaseDynamicLinks from 'ti.firebasedynamiclinks';

// Place this in the earliest possible place, e.g. the alloy.js (Alloy) or app.js (classic Ti)
TiFirebaseDynamicLinks.addEventListener('deeplink', event => {
  console.warn(`URL: ${event.url}, Match type: ${event.matchType}`);
});