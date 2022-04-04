.include "man/manager.h.s"
.include "entities/entities.h.s"

;; Vector de entidades
;; Esta macro define el vector de entidades y establece el puntero a la primera entidad
;; libre y el contador de entidades creadas. Definida en manager.h.s
DefineEntityVector man_entity_vector, man_max_entities

;;
;; Devuelve el puntero a la siguiente entidad libre, incrementa el 
;; contador de entidades creadas e incrementa el puntero a la siguiente entidad
;; libre.
;; DEVUELVE: DE -> puntero a la entidad reservada
;; DESTRUYE: DE, HL
;;
man_create_entity::
        ld      de, (man_next_free_entity)
        ld      hl, #ent_size
        add     hl, de
        ld      (man_next_free_entity), hl
        ld      hl, #man_created_entities
        inc     (hl)
        
        ret

;;
;; Copia una plantilla de entidad en el espacio reservado de una nueva entidad.
;; RECIBE: HL -> Bytes de inicialización de la entidad a copiar
;;         DE -> Puntero a la entidad vacía
;;         BC -> Tamaño de la entidad (en bytes)
;;
man_init_entity::
        ldir

        ret

;;
;; Devuelve el número de entidades creadas 
;; DEVUELVE: A -> Número de entidades creadas
;;
man_get_created_entities::
        ld      a, (man_created_entities)

        ret

;;
;; Devuelve en DE el puntero al vector de entidades
;;
man_get_entityVector::
        ld      de, #man_entity_vector

        ret

;;
;; Recorre el vector aplicando la rutina recibida en HL a todas las entidades que
;; tengan activo el bit de estado recibido en A
;; INPUT: HL -> Puntero a la rutina
;;         A -> Bit de estado
;; OUTPUT:
;;
man_do_it_for_all_matching::
        ld      ix, #man_entity_vector     ; IX -> Puntero al inicio del vector de entidades
        ld      bc, (man_created_entities) ; BC -> Número de entidades creadas
        ld      b, c
;; Comienzo del bucle para recorrer el vector
again:  
        ld       d, entity_s(ix)           ; D -> Byte de estados de la entidad
        and      d                         ; Comprobamos si tiene activo el bit recibido en A
        push    af                         ; Si lo tiene activo, guardamos AF, BC y HL para
        push    hl                         ; evitar su corrupción en la llamada al mánager.
        push    bc                         ; \
        jr       z, return                 ; Si no lo tiene activo continuamos con el bucle      
                ld      de, #return        ; Simulamos un call, metiendo en la pila la dirección 
                push    de                 ; de retorno.
                jp      (hl)               ; Saltamos a la rutina recibida en HL.
return:
        pop     bc                         ; Recuperamos los valores preservados en la pila
        pop     hl                         ; |
        pop     af                         ; \
        djnz    nextEntity                 ; Decrementamos BC y si no es CERO, pasamos a la siguiente entidad
        ret                                ; Si es CERO, volvemos.
nextEntity:                                ; Siguiente entidad del vector
        ld      de, #ent_size              ; DE -> Tamaño de una entidad en bytes
        add     ix, de                     ; Se lo sumamos a IX para movernos a la siguiente entidad
        jr      again                      ; Repetimos el proceso.

