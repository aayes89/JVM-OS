# JVM-OS
Sistema operativo (baremetal).

# Lenguajes utilizados
* Assembly en NASM para el bootloader.
* C para el Kernel, Shell, drivers y aplicaciones.

# Funcionalidades en modo Texto
### Comando - Función - Descripción
```
 * {"help",     help_cmd,      "Mostrar lista de comandos"}
 * {"clear",    clear_cmd,     "Limpiar pantalla"}
 * {"cls",      clear_cmd,     "Limpiar pantalla"}
 * {"cd",       cd_cmd,        "Cambiar de directorio"}
 * {"cp",       copy_cmd,      "Copiar archivo"}
 * {"ls",       ls_cmd,        "Listar archivos"}
 * {"dir",      ls_cmd,        "Listar archivos"}
 * {"rm",       rm_cmd,        "Eliminar archivo"}
 * {"ren",      ren_cmd,       "Renombrar archivo"}
 * {"mv",       mv_cmd,        "Mover archivo/directorio"}
 * {"touch",    touch_cmd,     "Crear archivo vacío"}
 * {"echo",     echo_cmd,      "Crear archivo con texto"}
 * {"mkdir",    mkdir_cmd,     "Crear directorio"}
 * {"cat",      cat_cmd,       "Ver contenido de archivo"}
 * {"run",      run_cmd,       "Ejecutar binario"}
 * {"java",     java_cmd,      "Ejecutar binario compilado de Java .class"}
 * {"edit",     edit_cmd,      "Editor de texto"}
 * {"ping",     ping_cmd,      "Ejecutar comando ping"}
 * {"ifconfig", ifconfig_cmd,  "Configurar controlador ethernet"}
 * {"netstat",  netstat_cmd,   "Estadísticas de red"}
 * {"nslookup", dns_lookup_cmd,"Comando nslookup"}
 * {"startx",   setVGAmode_cmd,"Cambiar a modo VGA"}
 * {"reboot",   reboot_cmd,    "Reiniciar el sistema"}
 * {"shutdown", shutdown_cmd,  "Apagar el sistema"}
 * {"info",     info_cmd,      "Información del sistema"}
```

# Funcionalidades en UI
* Navegador de archivos
* Apagar sistema
* Eventos de mouse

# Modo de ejecución
### Modo Gráfico
```
make clean && make run
```
### Modo Texto
```
make clean && make headless
```
# Agradecimientos
* https://os.phil-opp.com - (Fuente de información para escribir un Sistema en Rust)
* https://gist.github.com/leommoore/f9e57ba2aa4bf197ebc5 - (Recopilatorio de Magic Numbers)
* https://elm-chan.org - (Librería FatFs)
* Familia - (Por la paciencia y horas ocupadas cada día (3) en hacer este proyecto)

# Licencias
* MIT
* FatFs
```
/*----------------------------------------------------------------------------/
/  FatFs - Generic FAT Filesystem Module  Rx.xx                               /
/-----------------------------------------------------------------------------/
/
/ Copyright (C) 20xx, ChaN, all right reserved.
/
/ FatFs module is an open source software. Redistribution and use of FatFs in
/ source and binary forms, with or without modification, are permitted provided
/ that the following condition is met:
/
/ 1. Redistributions of source code must retain the above copyright notice,
/    this condition and the following disclaimer.
/
/ This software is provided by the copyright holder and contributors "AS IS"
/ and any warranties related to this software are DISCLAIMED.
/ The copyright owner or contributors be NOT LIABLE for any damages caused
/ by use of this software.
/----------------------------------------------------------------------------*/
```

# Captura de pantalla
<img width="1021" height="766" alt="imagen" src="https://github.com/user-attachments/assets/016dca45-f91c-4aa6-81e7-7c94192c48c4" />
