# SeymSoft móvil

## Ejecutar

Por defecto, la aplicación consume el backend desplegado:

```text
https://api.seymsoft.dev/api
```

Instala dependencias y ejecuta la aplicación:

```powershell
flutter pub get
flutter run
```

## Usar el backend local

La URL se puede sobrescribir sin cambiar código:

```powershell
flutter run -d chrome --web-port 5174 --dart-define=API_BASE_URL=http://127.0.0.1:3000/api
```

Para el emulador Android usa `http://10.0.2.2:3000/api`. Para un celular
físico, PC y celular deben estar en la misma red Wi-Fi y se debe usar la IPv4
del PC que ejecuta el backend.
