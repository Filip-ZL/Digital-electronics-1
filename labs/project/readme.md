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
