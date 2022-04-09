.include "cpctelera.h.s"
.include "cpctelera_functions.h.s"
.include "man/manager.h.s"
.include "entities/entities.h.s"
.include "sys/render.h.s"
.include "sys/physics.h.s"

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
   
   call  man_create_entity ;; Creamos entidad del jugador
   ld    hl, #ent_player
   ld    bc, #ent_size
   call  man_init_entity
   
   call  man_create_entity ;; Creamos entidad enemigo
   ld    hl, #ent_enemy0
   ld    bc, #ent_size
   call  man_init_entity

   call  man_create_entity ;; Creamos entidad enemigo
   ld    hl, #ent_enemy1
   ld    bc, #ent_size
   call  man_init_entity
   
   call  man_create_entity ;; Creamos entidad enemigo
   ld    hl, #ent_enemy2
   ld    bc, #ent_size
   call  man_init_entity


   ;; Loop forever
loop:
   call  pysx_update_all_entities
   call  ren_do_it_for_all
   
   call cpct_waitVSYNC_asm
   jr    loop