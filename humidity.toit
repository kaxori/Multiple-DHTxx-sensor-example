/**
calculates absolute humidity.
*/
import math

/*
https://www.wetterochs.de/wetter/feuchte.html

Bezeichnungen:
r = relative Luftfeuchte
T = Temperatur in °C
TK = Temperatur in Kelvin (TK = T + 273.15)
TD = Taupunkttemperatur in °C
DD = Dampfdruck in hPa
SDD = Sättigungsdampfdruck in hPa

Parameter:
a = 7.5, b = 237.3 für T >= 0
a = 7.6, b = 240.7 für T < 0 über Wasser (Taupunkt)
a = 9.5, b = 265.5 für T < 0 über Eis (Frostpunkt)

R* = 8314.3 J/(kmol*K) (universelle Gaskonstante)
mw = 18.016 kg/kmol (Molekulargewicht des Wasserdampfes)
AF = absolute Feuchte in g Wasserdampf pro m3 Luft

Formeln:
    SDD(T) = 6.1078 * 10^((a*T)/(b+T))
    DD(r,T) = r/100 * SDD(T)
    r(T,TD) = 100 * SDD(TD) / SDD(T)
    TD(r,T) = b*v/(a-v) mit v(r,T) = log10(DD(r,T)/6.1078)
    AF(r,TK) = 10^5 * mw/R* * DD(r,T)/TK; AF(TD,TK) = 10^5 * mw/R* * SDD(TD)/TK


https://electric-junkie.de/2022/01/absolute-luftfeuchtigkeit
file:///D:/@%20Downloaded/Leseprobe_Gesamtwerk_Meteo_Kapitel_3_web.pdf

*/
calc-absolute-humidity rH/float T/float -> float:

  // if T >= 0.0:
  a /float := 7.5
  b /float := 237.3
  if T < 0.0:
    a = 7.6
    b = 240.7
  
  TK := T + 273.15                  // T in K
  EXP := (a*T) / (b+T)
  SDD := 6.1078 * (math.pow 10 EXP) // SättigungsDampDruck
  DD := rH / 100.0 * SDD            // DampfDruck
  aH := 100_000.0 * 18.016 / 8314.3 * DD / TK;

  //print "calc-absolute-humidity"
  return aH