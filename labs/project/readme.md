# TECHNICKÁ DOKUMENTACE KE STMÍVAČI S PWM MODULACÍ A ČASOVAČEM
## 1.	Zadání úkolu
*	PWM stmívač s nastavitelnou dobou "načasování" s rotačním enkodérem KY-040 s tlačítkem. 
Po uplynutí zadané doby se výstup ze 100% PWM plynule ztlumí na nulu.
## 2.	Popis funkce programu
### 2.1.	Uživatelské prostředí
*	pomocí enkodéru si může uživatel nastavit dobu, po kterou bude dioda svítit. PWM generátor zajistí její postupný útlum na nulu
*	hodnota (v sekundách), kterou nastavuje uživatel, lze vyčíst pomocí sedmisegmenotvého displeje
*	stisknutím tlačítka enkodéru potvrdíme nastavení času a odstartujeme odpočet, který lze opět na displeji sledovat
* součástí programu je také resetovací tlačítko, které nám zařízení vrátí do výchozího stavu (nulování)

### 2.2.	Funkční bloky programu
![Block diagram](https://github.com/Filip-ZL/Digital-electronics-1/blob/master/labs/project/kk.png)
Obrázek 1) Blokové schéma 
#### 2.2.1.	Popis diagramu
-	vytvořili jsme programovou simulaci reálného enkodéru se třemi vstupy 
-	uživatel otáčí ve směru, protisměru hodinových ručiček nebo stiskne tlačítko, popř. nedělá nic (není v diagramu uvedeno)
-	reálný enkodér generuje pouze 2 impulzy posunuté o 90°, naše simulace však generuje sled impulzů, což je pro následnou simulaci a ověření funkčnosti praktičtější (výsledek simulace pro enkodér je na obrázku č. 2)
-	Další stěžejní částí je analyzátor impulsů z enkodéru, který vyhodnotí, kterým směrem uživatel hýbe a na základě toho pošle na výstup tolik impulsů podle toho kolikrát a jakým směrem jsme enkodérem pootočili (výsledek simulace obr. č. 3)
-	tyto údaje jsou následně zpracovány v bloku „stopwatch“, který vyhodnotí směr posunu a podle něj čítá dopředu či dozadu (nelze čítat pod hodnotu 0, maximální hodnota může být 59‘ 59“)
-	pokud jsou aktivní stopky (bylo stisknuto tlačítko), nelze již čas nastavovat, nastavení je možné až po opětovném stisknutí tlačítka (funkce pozastavení stopek).
-	výstupem „stopwatch“ (výsledek simulace obr. č. 4 – čítání uživatelem č.5-simulace stopek) jsou již hodnoty, které jsou poslány na řadič a ten jim podle časové jednotky (minuty, desítky minut, atd) přiřadí místo na sedmisegmentovém displeji
-	dalším výstup nastaví hodnotu pro PWM generátor, který se spustí společně s odpočtem a postupně mění střídu až na 0%
-	Do PWM generátoru jsou z bloku „stopwatch“ poslány 2 vstupy. První z nich poskytuje maximální čítací hodnotu, druhý se v čase mění a tím je zajištěna změna střídy

## 2.3.	Výsledky simulací
![encoder](https://github.com/Filip-ZL/Digital-electronics-1/blob/master/labs/project/encoder.PNG)
Obrázek 2) Výstupy na enkodéru

![enc_analyser](https://github.com/Filip-ZL/Digital-electronics-1/blob/master/labs/project/analyzer.PNG)
Obrázek 3) Výsledek simulace - analyzátor signálů z enkodéru

![counter](https://github.com/Filip-ZL/Digital-electronics-1/blob/master/labs/project/counter.PNG)
Obrázek 4) Výsledek simulace - čítání

![stopwatch](https://github.com/Filip-ZL/Digital-electronics-1/blob/master/labs/project/set_timer.PNG)
Obrázek 5) Výsledek simulace - aktivní stopky

![clock_enable](https://github.com/Filip-ZL/Digital-electronics-1/blob/master/labs/project/Clock_enabled.PNG)
Obrázek 6) Výsledek simulace - dělička frekvence

![Duty_cycle1](https://github.com/Filip-ZL/Digital-electronics-1/blob/master/labs/project/strida%202%25.PNG)
Obrázek 7) Střída 2%

![Duty_cycle2](https://github.com/Filip-ZL/Digital-electronics-1/blob/master/labs/project/strida%2014%25.PNG)
Obrázek 8) Střída 50%

## 2.4.	Další návrhy na vylepšení programu
- Chyba v propojení v PWM generátoru, zvlášť funguje dobře, při spojení se "stopwatch" nefunguje korektně
-	jelikož do čítače se dá nastavit hodnota odpočtu až do 59‘ 59“, je poněkud nepraktické čítat, zvláště pak u vyšších hodnot, po vteřinách. 
-	zabudování resetovacího tlačítka do tlačítka enkodéru (např. pokud uživatel zmáčkne tlačítko po dobu 2 vteřin, čítač se vynuluje)
- v UCF chybí připojit enkodér (nevěděli jsme jak)
