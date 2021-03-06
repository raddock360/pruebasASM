.include "cpctelera.h.s"
.include "cpctelera_functions.h.s"
.include "man/manager.h.s"
.include "entities/entities.h.s"
.include "sys/render.h.s"
.include "sys/physics.h.s"
.include "sys/sys_ia.h.s"

;;
;; Start of _DATA area 
;; SDCC requires at least _DATA and _CODE areas to be declared, but you may use
;; any one of them for any purpose. Usually, compiler puts _DATA area contents
;; right after _CODE area contents.
;;
.area _DATA

;;
;; Start of _CODE area
;; 
.area _CODE

;;
;; MAIN function. This is the entry point of the application.
;; _main:: global symbol is required for correctly compiling and linking
;;
_main::
   call  cpct_disableFirmware_asm
   call  sys_ia_init
   
   call  man_create_entity ;; Creamos entidad del jugador
   ld    hl, #ent_player
   ld    bc, #sizeof_entity
   call  man_init_entity
   
   call  man_create_entity ;; Creamos entidad enemigo
   ld    hl, #ent_enemy0
   ld    bc, #sizeof_entity
   call  man_init_entity

   call  man_create_entity ;; Creamos entidad enemigo
   ld    hl, #ent_enemy1
   ld    bc, #sizeof_entity
   call  man_init_entity
   
   call  man_create_entity ;; Creamos entidad enemigo
   ld    hl, #ent_enemy2
   ld    bc, #sizeof_entity
   call  man_init_entity

   ld    a, #50
   ld    (counter), a

   ;; Loop forever
loop:
   call  pysx_update_all_entities
counter = . + 1
   ld     a, #0x00
   dec    a
   ld    (counter), a
   jr    nz, render   
   call  sys_ia_update
   ld     a, #50
   ld    (counter), a
render:
   call  ren_do_it_for_all
   
   call cpct_waitVSYNC_asm
   jr    loop