.include "entities.h.s"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Sistema de IA
;;


sys_ia_init::
        ld      de, #sizeof_entity ;; Avanzamos IX hasta la segunda entidad.
        add     ix, de             ;; La primera es la del jugador
        ld      (enemy_vector), ix ;; Y lo almacenamos en sys_ia_update

        ret


sys_ia_update::
enemy_vector = . + 2
        ld      ix, 0x0000      ;; Cargamos en IX el puntero al vector de entidades enemigas
counter = . + 1
        ld       a, 0x00