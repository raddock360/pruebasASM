.include "cpctelera.h.s"
.include "cpctelera_functions.h.s"
.include "entities/entities.h.s"
.include "man/manager.h.s"

;;
;; Dibuja una entidad
;; RECIBE: IX -> Puntero a la entidad
;; DEVUELVE: NADA
;; DESTRUYE: AF, BC, DE, HL
;;
ren_one_entity::
        ;; Borrado de la posición anterior del sprite
        ld       d, entity_sprH(ix)   ; DE = posición anterior del sprite (puntero)
        ld       e, entity_sprL(ix)   ; \
        ld       c, entity_w(ix)      ; BC = ancho y alto del sprite
        ld       b, entity_h(ix)      ;\    
        ld       a, #0                ; A = color del borrado
        call    cpct_drawSolidBox_asm ; Dibujamos la entidad

        ;; Cálculamos el puntero a la nueva posición de la memoria de vídeo
        ld      de, #CPCT_VMEM_START_ASM ; DE = puntero al inicio de la memoria de vídeo
        ld       c, entity_x(ix)         ; BC = posición X e Y de la entidad
        ld       b, entity_y(ix)         ;\
        call    cpct_getScreenPtr_asm    ; Calculamos el puntero en función de X e Y
        ld      entity_sprH(ix), h       ; Almacenamos el nuevo puntero en la entidad (para borrado)
        ld      entity_sprL(ix), l       ; \

        ;; Dibujamos el sprite en la nueva posición
        ex      de, hl                ; DE = HL (Puntero obtenido en la llamada anterior)
        ld       c, entity_w(ix)      ; BC = ancho y alto de la entidad       
        ld       b, entity_h(ix)      ; \
        ld       a, entity_col(ix)    ; A = color de la entidad
        call    cpct_drawSolidBox_asm ; Dibujamos la entidad 

        ret

;;
;; Llama al mánager pasándole como parámetro un puntero a la función "ren_one_entity"
;; y el byte de estado de render.
;; INPUT:
;; OUTPUT: HL -> Puntero al método render
;;          A -> Byte de estado
;; DESTRUYE: AF, BC, DE, HL
;;
ren_do_it_for_all::
        ld      hl, #ren_one_entity        ; HL = Puntero a la rutina de renderizado 
        ld       a, #RENDER                ; A = Byte con el estado render activado (máscara)
        call    man_do_it_for_all_matching ; Llamamos al mánager 

        ret