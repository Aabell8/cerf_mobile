# Viss mobile

Flutter service technician routing app

## Getting started

`flutter packages get` to install dependencies  
`flutter run` to run app  
`flutter build` to build deployable apk  

Key is needed to build app with current configuration. Create file `key.properties` in the `<appdir>/android/` directory with this framework:

```
storePassword=<password from previous step>
keyPassword=<password from previous step>
keyAlias=key
storeFile=<location of the key store file, e.g. /Users/<user name>/key.jks>
```
