.globl ent_player
.globl ent_enemy

;;
;; Tamaño de una entidad en bytes.
;; En hexadecimal para cargarlo directamente en BC
;;
ent_size = 0x000A

;;
;; Offsets para acceder a los distintos componentes de las entidades
;;
entity_s    = 0               ;; Byte de estados
entity_x    = entity_s    + 1 ;; Coordenada X                    
entity_y    = entity_x    + 1 ;; Coordenada Y
entity_vx   = entity_y    + 1 ;; Velocidad X
entity_vy   = entity_vx   + 1 ;; Velocidad Y
entity_w    = entity_vy   + 1 ;; Ancho 
entity_h    = entity_w    + 1 ;; Alto
entity_col  = entity_h    + 1 ;; Color
entity_sprL = entity_col  + 1 ;; Puntero posición anterior (L)
entity_sprH = entity_sprL + 1 ;; Puntero posición anterior (H)

;; 
;; Estados de las entidades
;;
JUGADOR  = 0x01
ENEMIGO  = 0X02
RENDER   = 0X10
PHYSICS  = 0X20
CONTROLS = 0X40