# ProjecteRPG — Morales Jose Manuel

Un RPG 2D hecho en Godot 4 como proyecto de clase. La idea es construir un juego de rol completo donde el jugador lucha, sube de nivel y consigue hechizos hablando con un mago — literalmente hablando con él mediante IA.

---

## De qué va el juego

Es un RPG 2D con vista top-down. Te mueves por el mapa, peleas contra enemigos de distintos niveles y vas haciéndote más fuerte. Lo que lo hace diferente es el sistema de hechizos: hay un NPC mago con el que puedes chatear, y según lo que le preguntes o le digas, te da hechizos distintos. Puedes tener hasta 10 equipados a la vez (teclas 1-0) y si quieres uno nuevo, tienes que reemplazar uno antiguo.

---

## Donde estamos

El juego está en desarrollo. Esto es lo que hay hasta ahora y lo que queda:

- [x] Movimiento del personaje (WASD)
- [x] Sistema de ataque melee (click izquierdo)
- [x] Area de ataque direccional
- [ ] Animaciones de combate
- [ ] Enemigos con comportamiento propio
- [ ] Sistema de hechizos con el mago
- [ ] Mana y experiencia
- [ ] Barra de vida, muerte y respawn
- [ ] Bosses y reaparicion de enemigos
- [ ] Chat con IA para generar hechizos

---

## Tecnologias

- Motor: Godot 4.6
- Lenguaje: GDScript
- Arte: sprites 2D pixel art
- IA (proximamente): Claude API de Anthropic

---

## Estructura del proyecto

```
Juego/
├── main.tscn        # Escena principal
├── player.gd        # Script del jugador
├── Player.png       # Sprite del personaje
├── Tileset1.png     # Tileset del mapa
└── project.godot    # Configuracion del proyecto
```

---

## Como ejecutarlo

1. Instala Godot 4
2. Clona el repositorio:
   ```bash
   git clone https://github.com/JoseManuel1432/Morales_JoseManuel_ProjecteRPG.git
   ```
3. Abre Godot, importa el proyecto y dale a F5

---

## Mecanicas previstas

| Mecanica | Descripcion |
|---|---|
| Combate melee | Click izquierdo para atacar |
| Bloqueo y parry | Click derecho para bloquear o hacer parry en el momento justo |
| Hechizos (1-0) | 10 slots de hechizos obtenidos hablando con el mago |
| Mana | Recurso necesario para lanzar hechizos |
| Experiencia | Se gana al matar enemigos y sube el nivel |
| NPC Mago | Chat con IA que genera hechizos unicos segun la conversacion |

---

## Autor

Jose Manuel Morales — Proyecto de Digitalizacion
