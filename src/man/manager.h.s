.globl man_create_entity
.globl man_init_entity
.globl man_entity_vector ;; Solo para debuggear, luego quitar
.globl man_do_it_for_all_matching
.globl man_get_entityVector
.globl man_get_created_entities

;;
;; Número máximo de entidades en juego
;;
man_max_entities = 10


;;
;; Define una entidad estándar. Se utiliza principalmente para inicializar el vector
;;
.macro DefineStandardEntity ?_name
    _name:
        .db 0xCA
        .db 0x00, 0x00
        .db 0x00, 0x00
        .db 0x00, 0x00
        .db 0x00
        .dw 0xFFFF
.endm

;;
;; Define una entidad con los valores recibidos en los parámetros
;; - Puntero a la posición anterior (para borrado) --------------------------
;; - Color de la entidad ---------------------------------------------      |
;; - Alto de la entidad ( en bytes ) ----------------------------    |      |
;; - Ancho de la entiad ( en bytes ) -----------------------    |    |      |
;; - Velocidad Y de la entidad -----------------------     |    |    |      |
;; - Velocidad X de la entidad -----------------     |     |    |    |      |
;; - Posición Y de la entidad ------------     |     |     |    |    |      |
;; - Posición X de la entidad -------    |     |     |     |    |    |      |
;; - Byte de estados ----------     |    |     |     |     |    |    |      |
;; - Nombre -----------       |     |    |     |     |     |    |    |      |         
;;                    |       |     |    |     |     |     |    |    |      |
.macro DefineEntity _name, _estat, _ex, _ey, _evx, _evy, _ew, _eh, _ecol, _eptr
    _name:
        .db _estat
        .db _ex, _ey 
        .db _evx, _evy
        .db _ew, _eh 
        .db _ecol
        .dw _eptr
.endm

;;
;; Define un vector de nombre -name y lo rellena con _n entidades estándar
;; Después crea un puntero man_next_free_entity que apunta a la primera entidad 
;; libre el vector y un contador de entidades de juego creadas man_created_entities,
;; que es 0 al comienzo de la ejecución.
;; - Número de entidades ---------
;; - Nombre del vector ------    |
;;                          |    |
.macro DefineEntityVector _name, _n
    _name:
        .rept _n
                DefineStandardEntity 
        .endm

    man_next_free_entity: .dw   _name
    man_created_entities: .db   0
.endm