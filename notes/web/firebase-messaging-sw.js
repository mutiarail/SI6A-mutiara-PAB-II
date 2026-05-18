importScripts("https://www.gstatic.com/firebasejs/10.7.1/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.7.1/firebase-messaging-compat.js");

// Gunakan konfigurasi web dari firebase_options.dart Anda
firebase.initializeApp({
 apiKey: 'AIzaSyDA2oKqNJQLpCW82yOVK9353BrxFepLWbw',
    appId: '1:795572857509:web:51be2ed88a4529419e3b4c',
    messagingSenderId: '795572857509',
    projectId: 'notes-72bdc',
    authDomain: 'notes-72bdc.firebaseapp.com',
    storageBucket: 'notes-72bdc.firebasestorage.app',
    measurementId: 'G-3CBLECKJS7',
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: "/favicon.png",
  };
  return self.registration.showNotification(notificationTitle, notificationOptions);
});
