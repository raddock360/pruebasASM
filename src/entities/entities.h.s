.globl ent_player
.globl ent_enemy0
.globl ent_enemy1
.globl ent_enemy2

;;
;; Tamaño de una entidad en bytes.
;; En hexadecimal para cargarlo directamente en BC
;;
sizeof_entity = 12

;;
;; Offsets para acceder a los distintos componentes de las entidades
;;
entity_s           = 0                      ;; Byte de estados
entity_x           = entity_s           + 1 ;; Coordenada X                    
entity_y           = entity_x           + 1 ;; Coordenada Y
entity_vx          = entity_y           + 1 ;; Velocidad X
entity_vy          = entity_vx          + 1 ;; Velocidad Y
entity_w           = entity_vy          + 1 ;; Ancho 
entity_h           = entity_w           + 1 ;; Alto
entity_col         = entity_h           + 1 ;; Color
entity_ai_x_target = entity_col         + 1 ;; Coordenada X de persecución de entidad con IA
entity_ai_y_target = entity_ai_x_target + 1 ;; Coordenada Y de persecución de entidad con IA
entity_sprL        = entity_ai_y_target + 1 ;; Puntero posición anterior (L)
entity_sprH        = entity_sprL        + 1 ;; Puntero posición anterior (H)

;; 
;; Estados de las entidades
;;
JUGADOR  = 0x01 ;; Jugador
ENEMIGO  = 0X02 ;; Enemigo
AI       = 0x04 ;; Entidad con IA
RENDER   = 0X10 ;; Entidad renderizable
PHYSICS  = 0X20 ;; Entidad con físicas
CONTROLS = 0X40 ;; Entidad controlable