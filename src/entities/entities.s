.include "entities/entities.h.s"
.include "man/manager.h.s"

;; Entidades con valores iniciales
;; 1    -> Nombre de la entidad
;; 2    -> Byte de estados
;; 3, 4 -> Coordenadas X, Y
;; 5, 6 -> Velocidad X, Y
;; 7, 8 -> Ancho y alto en bytes
;; 10   -> Color
;; 11   -> Puntero a la posición anterior (para borrado)
;;
;; Jugador
;;           [1]-------        [2]---------------------------------------  [3]-  [4]-  [5]-  [6]-  [7]-  [8]-  [9]-  [10]-
DefineEntity ent_player,       ^/(JUGADOR | RENDER | PHYSICS | CONTROLS)/, 0x28, 0xB7, 0x00, 0x00, 0x04, 0x10, 0xFF, 0xFFFF
;; 
;; Enemigo 
;;
DefineEntity ent_enemy,        ^/(ENEMIGO | RENDER | PHYSICS)/,            0x28, 0x0A, 0x00, 0x00, 0x04, 0x10, 0xF0, 0xFFFF
        
