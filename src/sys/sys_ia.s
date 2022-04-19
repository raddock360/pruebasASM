.include "entities/entities.h.s"
.include "man/manager.h.s"
.include "cpctelera.h.s"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Sistema de IA
;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; sys_ia_init inicializa ciertos valores y los almacena en diversas direcciones
;; de memoria para evitar tener que hacerlo cada vez que se llamen a las 
;; rutinas.
;;
sys_ia_init::
        call    man_get_entityVector     ;; Obtenemos en DE un puntero al vector de entidades.
        ld      (player_ptr), de         ;; Cargamos el puntero a la entidad jugador en (player_ptr)
        ld__ixh_d                        ;; IX = DE
        ld__ixl_e                        ;; \
        ld      de, #sizeof_entity       ;; Avanzamos IX hasta la segunda entidad.
        add     ix, de                   ;; La primera es la del jugador
        ld      (enemy_vector), ix       ;; Y lo almacenamos en sys_ia_update
        
        
        ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; sys_ia_update recorre el vector de entidades llamando para cada entidad con
;; IA a la rutina pertinente.
;; INPUT: IX -> puntero a la segunda entidad del vector (primera no jugable)
;; OUTPUT:
;; DESTROYS: AF, B, DE, IX
;;
sys_ia_update::
enemy_vector = . + 2
        ld      ix, #0x0000              ;; La rutina sys_ia_init carga aquí el puntero a la primera entidad enemigo
        call    man_get_created_entities ;; B = número de entidades en el array
        
;; Comenzamos a recorrer el vector en busca de entidades con IA
again:
        dec     b                        ;; B -= 1 (contador de entidades)
        ret     z                        ;; if B = 0 return
        ld      a, #AI                   ;; A = 0x04 (máscara de bits que indican entidad con IA)
        and     entity_s(ix)             ;; A & entity_s
        jr      z, next_entity           ;; if (!(A & entity_s)) next entity
                call    sys_ia_behaviour ;; if (A & entity_s) call sys_is_behaviour
next_entity:
        ld      de, #sizeof_entity       ;; DE = size of entities in bytes
        add     ix, de                   ;; IX += DE
        jr      again                    ;; repeat the procces

        ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; sys_ia_behaviour ejecuta el comportamiento de la entidad recibida en IX
;; INPUT: IX -> puntero a la entidad
;; OUTPUT:
;; DESTROYS:
;;
sys_ia_behaviour:
player_ptr = . + 2
        ld      iy, #0x0000               ;; El iniciador carga aquí el puntero a la entidad jugador
        ld       h, entity_x(iy)          ;; H = coordenada x del jugador 
        ld       l, entity_y(iy)          ;; L = coordenada Y del jugador
        ld      entity_ai_x_target(ix), h ;; Coordenada X de persecución = H
        ld      entity_ai_y_target(ix), l ;; Coordenada Y de persecución = L

        ld       a, entity_x(ix)
        sub      h 
        jr      nc, menos 
                ld      entity_vx(ix), #1
                jr      x_coord
menos: 
        ld      entity_vx(ix), #-1
x_coord:
        ld       a, entity_y(ix)
        sub      l
        jr      nc, menos2
                ld      entity_vy(ix), #1
                jr      exit
menos2:
        ld      entity_vy(ix), #-1
exit:
        ret