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
                ld      entity_vy(ix), #-3 ; VY = 1 (Velocidad Y)

;; Comprobamos la tecla A
q_not_pressed:
        ld      hl, #Key_A                ; HL = Tecla A
        call    cpct_isKeyPressed_asm     ; ¿Ha sido pulsada?
        jr      z, a_not_pressed
                ld      entity_vy(ix), #3 ; VY = -2 (velocidad Y)

a_not_pressed:

        ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Comprueba si la entidad jugador colisiona con alguna entidad enemiga o 
;; elemento colisionable.
;; INPUT: 
;; OUTPUT:
;; DESTROY:
;;
pysx_check_collisions::
;; Apuntamos IX a la entidad del jugador (la primera del vector)
;; Apuntamos IY a la segunda entidad del vector
        ld      ix, #man_entity_vector   ; IX = puntero a la primera entidad del vector
        ld      iy, #man_entity_vector   ; IY = puntero a la primera entidad del vector
        ld      de, #ent_size            ; DE = tamaño de una entidad en bytes
        add     iy, de                   ; IY += DE (sumamos DE a IY para avanzar el puntero hasta la segunda entidad)
        ld      hl, #0xC000              ; Puntero a la memoria de vídeo para pintar un píxel rojo si hay colisión
        call    man_get_created_entities ; Obtenemos el número de entidades en el vector
        dec     b                        ; y lo decrementamos en uno para la cuenta
comprobar_colisiones:
        ld      a, entity_y(iy)          ; A = posición Y de la esquina sup-izda de la entidad enemiga
        add     entity_h(iy)             ; A += entity_h. Sumamos la altura para calcular donde empieza la parte inferior de la entidad
        ld      c, a                     ; B = A (pasamos el valor de A a B)
        ld      a, entity_y(ix)          ; A = posición Y de la esquina sup-izda del jugador
        cp      c                        ; 
        jr      nc, no_collision         ; Si no, pasamos a la siguiente entidad
possible_y_collision:
                ld      a, entity_y(ix)  ; A = posición Y de la esquina sup-izda del personaje
                add     entity_h(ix)     ; A += entity_h
                cp      entity_y(iy)     ; Si A <= enemy_y + enemy_h hay colisión
                jr      c, no_collision  ; Si no, no la hay
there_is_y_collision:
                        ld      (hl), #0xFF
                        jr      next_entity
no_collision:
        ld      (hl), #0x00
next_entity:
        dec     b
        ret     z 
        add     iy, de 
        jr      comprobar_colisiones

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Actualiza las físicas de una entidad. Para ello, comprueba que no ha llegado a 
;; los límites de la pantalla. Si ha llegado, no permite el paso.
;; INPUT: IX -> Puntero a la entidad
;;
pysx_update_one_entity:
        ld      a, entity_x(ix)         ; Sumamos la velocidad a la posición de 
        add     entity_vx(ix)           ; la entidad y lo almacenamos en B
        ld      b, a                    ; \
;; Comprobamos si hemos llegado al borde derecho
        ld      a, #RIGHT_BORDER        ; A = borde derecho
        sub     entity_w(ix)            ; A -= ancho de la entidad
        cp      b                       ; Si hemos llegado, detectamos colisión
        jr      c, x_collision          ; \
;; Comprobamos el borde izquierdo
        ld      a, #LEFT_BORDER         ; A = borde izquierdo
        cp      b                       ; Si hemos llegado al borde izquierdo
        jr      nc, x_collision         ; detectamos colisión
x_no_collision:
        ld      entity_x(ix), b
x_collision:
;; Comprobamos eje Y
        ld      a, entity_y(ix)
        add     entity_vy(ix)
        ld      b, a
;; Comprobamos borde inferior
        ld      a, #LOWER_BORDER
        sub     entity_h(ix)
        cp      b
        jr      c, y_collision
;; Comprobamos el borde superior
        ld      a, #UPPER_BORDER
        cp      b
        jr      nc, y_collision
y_no_collision:
        ld      entity_y(ix), b
y_collision:
        ld      entity_vx(ix), #0
        ld      entity_vy(ix), #0

        ret
        

;;
;; Actualiza las físicas de todas las entidades
;;
pysx_update_all_entities::
        call    pysx_check_keyboard_one_entity
        ld      hl, #pysx_update_one_entity
        ld       a, #PHYSICS
        call    man_do_it_for_all_matching
        call    pysx_check_collisions

        ret