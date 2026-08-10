# SeymSoft móvil

## Ejecutar en desarrollo

1. Inicia el backend en el puerto `3000`.
2. Instala dependencias con `flutter pub get`.
3. Ejecuta la aplicación con `flutter run`.

La URL del backend se puede sobrescribir sin cambiar código:

```powershell
flutter run --dart-define=API_BASE_URL=http://192.168.1.33:3000/api
```

Para el emulador Android estándar usa `http://10.0.2.2:3000/api` como
`API_BASE_URL`. Para un celular físico, PC y celular deben estar en la misma
red Wi-Fi; usa la IPv4 de la PC que ejecuta el backend.
