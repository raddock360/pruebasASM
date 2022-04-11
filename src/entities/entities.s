.include "entities/entities.h.s"
.include "man/manager.h.s"

;; Entidades con valores iniciales
;; 1    -> Nombre de la entidad
;; 2    -> Byte de estados
;; 3, 4 -> Coordenadas X, Y
;; 5, 6 -> Velocidad X, Y
;; 7, 8 -> Ancho y alto en bytes
;; 9   -> Color
;; 12   -> Puntero a la posición anterior (para borrado)
;;
;; Jugador
;;           [1]-------        [2]---------------------------------------  [3]-  [4]-  [5]-  [6]-  [7]-  [8]-  [9]-  [12]-
DefineEntity ent_player,       ^/(JUGADOR | RENDER | PHYSICS | CONTROLS)/, 0x28, 0xB7, 0x00, 0x00, 0x04, 0x10, 0xFF, 0x00, 0x00, 0xFFFF
;; 
;; Enemigo 
;;
DefineEntity ent_enemy0,        ^/(ENEMIGO | RENDER | PHYSICS)/,           0x28, 0x20, 0x01, 0x03, 0x04, 0x10, 0xF0, 0x00, 0x00, 0xFFFF
DefineEntity ent_enemy1,        ^/(ENEMIGO | RENDER | PHYSICS)/,           0x18, 0x30, 0xff, 0xfd, 0x04, 0x10, 0xF0, 0x00, 0x00, 0xFFFF
DefineEntity ent_enemy2,        ^/(ENEMIGO | RENDER | PHYSICS)/,           0x38, 0x80, 0x01, 0x03, 0x04, 0x10, 0xF0, 0x00, 0x00, 0xFFFF
        
