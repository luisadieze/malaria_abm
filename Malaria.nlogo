__includes [ "Definiciones.nls" "Ambiente.nls" "Acciones humanos.nls" "Acciones vectores.nls"  "Interacciones vectores.nls" 
             "Interacciones humanos.nls" "Interacciones humano.vector.nls"] 
                              
     
        

to setup 
  clear-all
  
  
  set e-births 0  ;;Para prueba
  set e-deaths 0  ;;Para prueba
  set l-births 0  ;;Para prueba  
  set l-deaths 0  ;;Para prueba
  set p-births 0  ;;Para prueba  
  set p-deaths 0  ;;Para prueba
  set Air-temp-increase-tmp Air-temp-increase
  ;-----------------------------------------------------------------------------------------------------------------------------------------------------------------


   
 ask patches [ set pcolor green - 1]
 
 file-open "AirTemp.txt"
 foreach sort patches
 [
 ask ? [set air-t file-read + Air-temp-increase]
 ]
 file-close

 file-open "WaterTemp.txt"
 foreach sort patches
 [
 ask ? [ set water-t file-read ]
 ]
 file-close

 
 ask patches [ if water-t != 0 [set water-t water-t + Air-temp-increase set pcolor cyan] ;; Por ahora no se puede actualizar durante la simulación.  
                ]
   
  ;-----------------------------------------------------------------------------------------------------------------------------------------------------------------
    
  set humans-lifespan 27740         ;;Promedio de días que vive un humano.    
  set mosquitoes-lifespan 28        ;;Promedio de días que vive un mosquito.
                                                             
  
  set schizogony 17                 ;;Promedio de días del período de esquizogonia.  
  set average-infected-period 548   ;;Promedio en días. (1.5 años)                        
  set average-immune-period 548     ;;Promedio en días. (1.5 años)
  
 ;------------------------------------------------------------------------------------------------------------------------------------- 
 
 
  set-default-shape humans "person"
  create-humans 100 [ 
    set color white 
    set size 2
    set humans-age random humans-lifespan
    set male? true
    set female? false
    set susceptible? true
    set infected? false                
    set infectious? false
    set immune? false
    setxy random-xcor random-ycor
    ;setxy 11 + random (max-pxcor - 11) random-ycor ;; Ubicación: Cambiar según el espacio!!
   ]
   
   
  ask n-of 48 humans [ set shape "woman" set male? false set female? true]
  
  
  
  ask n-of 20 humans with [susceptible? = true]
                          [set susceptible? false set infected? true  set infectious? false  set immune? false  
                          set color yellow
                          set schizogony-time random schizogony
                          set humans-age random (humans-lifespan - schizogony) + schizogony ;;Esto garantiza que la edad sea mayor que
                          ]                                                                 ;;el tiempo de la esquizogonia.
                          
                         
                         
                         
  ask n-of 20 humans with [susceptible? = true]
                          [set susceptible? false set infected? false  set infectious? true  set immune? false 
                          set color red
                          set recover-time random average-infected-period
                          set humans-age random (humans-lifespan - (schizogony + recover-time)) + (schizogony + recover-time) ;;Esto garantiza que la edad
                          ]                                                                                                   ;;sea mayor que la esquizogonia
                                                                                                                              ;;y lo que lleva del tiempo de
                                                                                                                              ;;recuperación    
                         
                         
  ask n-of 10 humans with [susceptible? = true]
                          [set susceptible? false set infected? false  set infectious? false  set immune? true 
                          set color gray
                          set immunity-time random average-immune-period
                          set humans-age random (humans-lifespan - (schizogony + average-infected-period + immunity-time)) + (schizogony + average-infected-period + immunity-time)                         
                          ]               ;;Esto garantiza que la edad sea mayor que la esquizogonia, el tiempo infeccioso y lo que lleva deltiempo de recuperación.
  
 
 
  ;-----------------------------------------------------------------------------------------------------------------------------------------------------------------
 
 
  set-default-shape mosquitoesF "Mosquito"
  create-mosquitoesF 200 [
    set color white    
    set susceptible? true 
    set infected? false                
    set infectious? false
    set sporogonic-cycle 0
    set n-oviposition random 3
    
    if n-oviposition > 0 [set spermatheca-full? true 
                          set gonotrophic-time random gonotrophic-cycle + 1
                          set mosquitoesF-age random (mosquitoes-lifespan - 3) + 3 ;; Esto es para prueba, para que el mosquito tenga más probabilidad de haber hecho los ciclos.
                          set n-blood-meal random 2 + 2] ;;Aquí, el número de alimentaciones debería ser igual o mayor que el
                                                         ;;número de oviposiciones. Por ahora puede valer 2 o 3.
    if n-oviposition = 0 [set spermatheca-full? false
                          set gonotrophic-time 0
                          set mosquitoesF-age random mosquitoes-lifespan
                          set n-blood-meal random 2]
    if n-blood-meal > 0 [set spermatheca-full? true]   
    ;; set size 0.5
    ;setxy  min-pxcor - random (min-pxcor + 11) random-ycor ;; Ubicación: Cambiar según el espacio!!
    setxy random-xcor random-ycor
    ]
  
  
    ask n-of 10 mosquitoesF with [susceptible? = true]
    [
    set susceptible? false
    set infected? true 
    set infectious? false
    set color yellow
    set sporogonic-cycle random sporogony
    set mosquitoesF-age random (mosquitoes-lifespan - sporogonic-cycle) + (sporogonic-cycle + 1) ;;Esto garantiza que la edad será > que el tiempo del ciclo
    set spermatheca-full? true
    set n-blood-meal random 2 + 2 ;; Tuvo que haber picado por lo menos una vez
    ]
  
    ask n-of 10 mosquitoesF with [susceptible? = true]
    [
    set mosquitoesF-age random (mosquitoes-lifespan - sporogony) + (sporogony + 1) ;; Esto garantiza que el mosquito haya tenido el período esporogónico completo.  
    set susceptible? false
    set infected? false 
    set infectious? true
    set sporogonic-cycle 0
    set color red
    set n-blood-meal random 2 + 2 ;; Tuvo que haber picado por lo menos una vez
    set spermatheca-full? true
    ]
    
  ;-----------------------------------------------------------------------------------------------------------------------------------------------------------------  
  
  set-default-shape mosquitoesM "Mosquito"
  create-mosquitoesM 200 [
    set color black  
    set mosquitoesM-age random mosquitoes-lifespan
    ;;set size 0.5
    ;setxy  min-pxcor - random (min-pxcor + 11) random-ycor ;; Ubicación: Cambiar según el espacio!!
    setxy random-xcor random-ycor
    ]
  
 ;-----------------------------------------------------------------------------------------------------------------------------------------------------------------  

  set-default-shape eggs "dot"
  create-eggs 30
  ask eggs [set color brown - 2
  move-to one-of patches with [pcolor = cyan]]
  
  set-default-shape larvae "dot"
  create-larvae 20
  ask larvae [set color brown + 2
  move-to one-of patches with [pcolor = cyan]]
  
  set-default-shape pupae "dot"
  create-pupae 10
  ask pupae [set color brown + 3
  move-to one-of patches with [pcolor = cyan]]
  
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------  
   
  ;;Los números están incrementados en una unidad, porque son los "días transcurridos" para cada cosa. 
  
  ask mosquitoesF [ ask patch-here [
  if air-t >= 27 [set sporogony 8] ;7
  if (air-t >= 23) and (air-t <= 26) [set sporogony 10] ;9         ;; En días. Valores para P.vivax. También están disponibles para
  if air-t <= 22 [set sporogony 17]  ;16                           ;; P. falciparum, P. malariae y P. ovale. 
  
  
  if air-t >= 26 [set gonotrophic-cycle 4] ;3
  if (air-t >= 23) and (air-t <= 25) [set gonotrophic-cycle 5] ;4  ;; En días. La duración es de 2, 3 o 4 días, pero cuando pica se toma como día uno,
  if air-t <= 22 [set gonotrophic-cycle 6]]] ;5                      ;; entonces va hasta 3er, 4to o 5to día.               
  
  
  ask eggs [ ask patch-here [
  if air-t >= 30 [set hatching 3] ;2
  if (air-t >= 26) and (air-t <= 29) [set hatching 4] ;3             ;; En días
  if (air-t >= 23) and (air-t <= 25) [set hatching 6] ;5  
  if air-t <= 22 [set hatching 8]]]  ;7                   
  
  ask larvae [ ask patch-here [
  if air-t >= 33 [set pupation 10] ;9
  if (air-t >= 28) and (air-t <= 32) [set pupation 11] ;10            ;; En días
  if (air-t >= 25) and (air-t <= 27) [set pupation 12] ;11
  if air-t <= 24 [set pupation 14]]]   ;13                   
  
  ask pupae [ ask patch-here [
  if air-t >= 27 [set emerge 2] ;1                                 ;; En días
  if air-t <= 26 [set emerge 3]]] ;2

   
  ;-----------------------------------------------------------------------------------------------------------------------------------------------------------------
 
 ;;set mosquitoe-zone min-pxcor + 40
 ;;set human-zone max-pxcor - 40 
 
  ;-----------------------------------------------------------------------------------------------------------------------------------------------------------------
  
 
  reset-ticks 
  
end


to go

humans-move
human-gets-older
h-reproduce
human-becomes-infectious
human-becomes-immune
human-becomes-susceptible


blood-meal-seeking 
mosquitoF-becomes-infectious 
mosquitoF-gets-older
mosquitoesM-move
mosquitoM-gets-older
m-reproduce

eggs-become-larvae
larvae-become-pupae 
pupae-become-mosquitoes
immatures-death

environmental-changes


 tick

end 


 
                
@#$#@#$#@
GRAPHICS-WINDOW
354
10
1275
464
50
23
9.02
1
10
1
1
1
0
0
0
1
-50
50
-23
23
0
0
1
Días Transcurridos
30.0

BUTTON
73
15
128
48
Go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
10
14
65
47
Setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
11
60
156
93
Air-temp-increase
Air-temp-increase
0
22
10
1
1
Deg
HORIZONTAL

PLOT
10
276
341
489
Populations
Days
Populations
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"mosquitoesF" 1.0 0 -5825686 true "" "plot count mosquitoesF"
"mosquitoesM" 1.0 0 -13345367 true "" "plot count mosquitoesM"
"Humans" 1.0 0 -13840069 true "" "plot count Humans"

PLOT
10
101
339
271
Incidence
Days
Humans
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Humans" 1.0 0 -2674135 true "" "plot count humans with [infectious? = true]"

MONITOR
162
10
219
55
Eggs
count eggs
17
1
11

MONITOR
221
10
278
55
Larvae
count larvae
17
1
11

MONITOR
280
10
337
55
Pupae
count pupae
17
1
11

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

mosquito
true
0
Polygon -7500403 true true 149 87 134 97 139 115 129 149 137 180 135 196 150 204 162 195 161 180 169 151 158 116 164 98
Polygon -7500403 true true 148 183 134 193 132 220 140 239 150 244 161 240 167 221 163 193 149 184
Polygon -7500403 true true 135 161 87 184 90 204 55 257 96 205 93 185 138 162
Polygon -7500403 true true 161 158 204 187 195 206 232 255 201 206 208 185 162 155
Polygon -7500403 true true 134 145 106 102 119 86 123 40 125 87 113 102 136 141
Polygon -7500403 true true 162 139 186 105 172 84 171 46 179 84 192 105 161 143
Line -7500403 true 145 96 105 61
Line -7500403 true 152 99 193 62
Polygon -7500403 true true 134 156 94 151 94 122 66 58 100 118 101 146 136 152
Polygon -7500403 true true 165 153 204 144 205 116 240 69 210 116 209 149 163 157
Polygon -7500403 true true 147 94 148 56 150 56 151 95
Polygon -7500403 false true 144 136 115 168 104 189 99 217 102 231 108 243 123 249 141 241 149 208 151 188 153 164 142 142 141 152
Polygon -7500403 false true 151 135 175 164 188 183 194 207 196 225 190 243 172 247 156 239 150 211 148 188 148 164 147 141 142 132

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

woman
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 113 88 132 165 110 278 107 299 137 299 152 224 167 299 197 299 194 282 168 164 189 89
Rectangle -7500403 true true 135 79 163 93
Polygon -7500403 true true 189 89 233 176 215 185 176 106
Polygon -7500403 true true 112 88 67 178 87 187 126 104
Polygon -7500403 true true 130 161 81 239 213 239 166 159 130 161

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.0.3
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 1.0 0.0
0.0 1 1.0 0.0
0.2 0 1.0 0.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
