.include "sys/physics.h.s"
.include "cpctelera.h.s"
.include "cpctelera_functions.h.s"
.include "entities/entities.h.s"
.include "man/manager.h.s"

;;
;; Comprueba el teclado para la entidad jugador (la primera del vector) y actualiza su velocidad
;; en función de la tecla pulsada.
;; 
pysx_check_keyboard_one_entity:
        call    man_get_entityVector       ; Pedimos al mánager un puntero al vector
        ld__ixh_d                          ; IX = HL (puntero recién recibido)
        ld__ixl_e                          ; \
        ld      entity_vx(ix), #0          ; Reseteamos las velocidades del jugador
        ld      entity_vy(ix), #0          ; \
        call    cpct_scanKeyboard_asm      ; Leemos el teclado al completo

;; Comprobamos si la tecla "O" ha sido pulsada
        ld      hl, #Key_O                 ; HL = Tecla O
        call    cpct_isKeyPressed_asm      ; ¿ Ha sido pulsada ?
        jr      z, o_not_pressed           ; En caso negativo, pasamos a la siguiente tecla
                ld      entity_vx(ix), #-1 ; VX = -1 (velocidad de la entidad = -1)
        
;; Comprobamos la tecla "P"
o_not_pressed:
        ld      hl, #Key_P                ; HL = Tecla P
        call    cpct_isKeyPressed_asm     ; ¿ Ha sido pulsada ?
        jr      z, p_not_pressed          ; En caso negativo, saltamos a la siguiente tecla
                ld      entity_vx(ix), #1 ; VX = 1 (velocidad de la entidad = 1)

;; Comprobamos la tecla Q
p_not_pressed:
        ld      hl, #Key_Q                ; HL = Tecla Q
        call    cpct_isKeyPressed_asm     ; ¿ Ha sido pulsada ?
        jr      z, q_not_pressed          ; En caso negativo, saltamos a la siguiente tecla
                ld      entity_vy(ix), #2 ; VY = 1 (Velocidad Y)

;; Comprobamos la tecla A
q_not_pressed:
        ld      hl, #Key_A                ; HL = Tecla A
        call    cpct_isKeyPressed_asm     ; ¿Ha sido pulsada?
        jr      z, a_not_pressed
                ld      entity_vy(ix), #-2 ; VY = -2 (velocidad Y)

a_not_pressed:

        ret

;;
;; Actualiza las físicas de una entidad. Para ello, comprueba que no ha llegado a 
;; los límites de la pantalla. Si ha llegado, no permite el paso.
;; INPUT: IX -> Puntero a la entidad
;;
pysx_update_one_entity:
;; Comprobamos si hemos llegado al border derecho. En caso afirmativo
;; reseteamos la VX a cero para que el personaje no siga avanzando.
rightBorder:
        ld      a, entity_x(ix)           ; A = posición X de la entidad
        cp      #RIGHT_BORDER             ; if A > RIGHT_BORDER 
        jr      nz, leftBorder            ; else goto leftBorder 
                ld      a, entity_vx(ix)
                neg
                ld      entity_vx(ix), a
                jr      upperBorder

;; Comprobamos si hemos llegado al borde izquierdo.
leftBorder:
        cp      #LEFT_BORDER
        jr      nz, upperBorder 
                ld      a, entity_vx(ix)
                neg
                ld      entity_vx(ix), a
        
;; Comprobamos si hemos llegado al borde superior
upperBorder:
        ld      a, entity_y(ix)
        cp      #upperBorder
        jr      c, lowerBorder
                ld      entity_vy(ix), #0
                jr      finish
;; Comprobamos si hemos llegado al borde inferior
lowerBorder:
        cp      #LOWER_BORDER
        jr      nc, finish
                ld      entity_vy(ix), #0
;; Sumamos las velocidades resultantes y regresamos
finish:
        add     entity_vy(ix)
        ld      entity_y(ix), a
        ld      a, entity_x(ix)
        add     entity_vx(ix)
        ld      entity_x(ix), a

        ret

;;
;; Comprueba si hay colisiones entre dos entidades.
;; INPUT: IX -> Puntero a la entidad 1
;;        IY -> Puntero a la entidad 2
;;
pysx_check_collisions_pairs_of_entities::
        ld      a, entity_x(ix)
        add     entity_w(ix)
        cp      entity_x(iy)
        jr      nz, no_collision
                ld      a, entity_x(iy)
                add     entity_w(iy)
                cp      entity_x(ix)
                jr      nz, no_collision
there_is_collision:
        ld      hl, #0xC000
        ld      (hl), #0xFF
        inc     hl
        ld      (hl), #0xFF

no_collision:

        ret

;;
;; Actualiza las físicas de todas las entidades
;;
pysx_update_all_entities::
        call    pysx_check_keyboard_one_entity
        ld      hl, #pysx_update_one_entity
        ld       a, #PHYSICS
        call    man_do_it_for_all_matching

        ret