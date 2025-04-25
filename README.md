# **DE1-Projekt**
## **Členové**
Jan Veverka: Zodpovědný za programování 
  
Vojtěch Vičar: Zodpovědný za programování 
  
Marek Smékal: Zodpovědný za vytváření README souboru a pomoc s programováním 
  
Matěj Rýdel: Zodpovědný za vytváření README souboru a pomoc s programováním

## Teoretický úvod
Náš projekt je zaměřen na návrh a implementaci PWM (Pulse Width Modulation) v jazyce VHDL na vývojové desce Nexys A7-50T. Cílem je řízení jasu dvou LED diod pomocí PWM. Uživatel vybírá, která LED má být ovládána, prostřednictvím dvou přepínačů: první přepínač slouží pro ovládání první LED, druhý pro druhou LED. Jas LED je nastavován pomocí dvou tlačítek – jedno slouží ke zvýšení intenzity o 10 %, druhé k jejímu snížení.

Pro každou LED je vyhrazen samostatný tříciferný sedmisegmentový displej, který zobrazuje aktuální hodnotu nastaveného jasu ve formátu procent. Systém umožňuje plynulé a přehledné řízení intenzity světla a zároveň demonstruje praktické využití FPGA a jazyka VHDL pro tvorbu konfigurovatelných digitálních systémů. 

## Princip PWM modulace
PWM, neboli pulsně šířková modulace, je metoda řízení analogové veličiny pomocí digitálního signálu. Spočívá v tom, že se výstupní signál přepíná mezi logickou nulou a jedničkou s určitou frekvencí. Výsledný průměrný výkon, a tím i jas LED, je dán tzv. pracovním cyklem (duty cycle) – tedy poměrem doby, po kterou je signál v logické jedničce, k celkové periodě.

Například při 50% pracovním cyklu je signál polovinu času v logické jedničce a polovinu v nule. LED tedy svítí na 50 % svého maximálního jasu. Při 100 % svítí naplno, při 0 % je zcela zhasnutá.

## Popis hardwaru a demo aplikace
Projekt je implementován na vývojové desce Nexys A7-50T od firmy Digilent, která obsahuje FPGA čip Xilinx Artix-7. Deska nabízí různé vstupně-výstupní prvky, které byly v rámci projektu využity pro realizaci ovládání LED diod a vizualizaci dat.

<ins>Využité hardwarové prvky:<ins>

LED0 a LED1 – výstupní LED diody řízené pomocí PWM

SW0 a SW1 – přepínače pro výběr kanálu (LED0, LED1)

BTNL (Left) a BTNR (Right) – tlačítka pro nastavování jasu po 10 % (snížení / zvýšení)

BTNC (Center Button) – slouží jako reset celého systému, vrací hodnoty duty cycle obou LED na výchozí hodnotu (např. 0 %)

6-místný sedmisegmentový displej – zobrazení aktuálního jasu vybrané LED v procentech, rozděleno po třech místech pro každou LED

<ins>Další využité prostředky:<ins>

Interní 100 MHz hodinový signál – zdroj hodin pro systém

Dělička hodin (clock divider) – pro zpomalení signálu na vhodnou frekvenci pro PWM a logiku řízení

![image](https://github.com/user-attachments/assets/1fa2566f-5888-4dca-b762-d699d41f3add)

## Popis softwaru
Projekt byl vytvořen v prostředí Vivado v jazyce VHDL. Návrh je rozdělen do několika modulárních komponent, které spolu komunikují prostřednictvím signálů.

<ins>Hlavní moduly:<ins>

Clock Divider – převádí 100 MHz vstupní hodiny na pomalejší frekvenci vhodnou pro čítání a generování PWM

PWM Generátor (2x) – každý generátor vytváří signál s nastavitelným pracovním cyklem, který určuje jas LED

Řízení vstupů – zpracovává stavy přepínačů a tlačítek, určuje aktivní kanál a aktualizuje hodnotu duty cycle

Segmentový displej – zobrazuje hodnoty duty cycle ve formátu procent

Top-level entita – propojuje všechny komponenty, určuje směr a logiku signálů

### Zapojení

### Top Level

### Simulace komponentů
<ins>**CLK100MHz**<ins>  

Komponenta *clock_en_100MHz* generuje výstupní puls *pulse* s periodou nastavitelnou pomocí parametru *n_periods*. Každý *n_periods*-tý takt hodinového signálu *clk* je *pulse* nastaven na '1'. Komponenta je resetována vstupem *rst*. Slouží jako dělička hodin, například pro zpomalení řízení nebo časování dalších částí návrhu.

![image](https://github.com/user-attachments/assets/5855c609-5462-46cf-8999-8a8ba929a9c9)

<ins>**CLK20Hz**<ins>

Komponenta *clock_en_20Hz* slouží k vytváření krátkých pulzů s frekvencí 20 Hz. Pulz *pulse* je aktivní jeden takt hodinového signálu *clk*, a opakuje se každých *n_periods taktů*. Vstup *rst* resetuje vnitřní čítač. Komponenta funguje jako dělička hodinového signálu z 100 MHz na 20 Hz a může být použita k časování pomalejších procesů, jako je čtení tlačítek nebo změna jasu LED.

![image](https://github.com/user-attachments/assets/ba2d61d3-ba38-4a36-9c4a-53828a341a0a)

<ins>**Luminosity**<ins>  

Komponenta *luminosity* slouží k řízení hodnoty intenzity světla v rozsahu 0–100 %. Na základě stisků tlačítek *high* a *low* zvyšuje nebo snižuje vnitřní čítač po krocích 10. Hodnota je aktualizována pouze tehdy, pokud je aktivní signál *en* a zároveň *change_en*. Tlačítko *rst* provede reset čítače na nulu. Pokud jsou obě tlačítka stisknuta současně, hodnota se nemění. Výstupní signál *lum* obsahuje aktuální intenzitu v osmibitovém formátu.

![image](https://github.com/user-attachments/assets/3b60fa7b-57da-42c8-afad-159e59e96bfb)

<ins>**PWM**<ins> 

Komponenta *PWM_gen* generuje PWM signál na základě vstupní hodnoty *lum*, která určuje pracovní cyklus (duty cycle). Po aktivaci signálem *en* čítač běží od 0 do *C_END - 1* a pokud aktuální hodnota čítače překročí *lum*, výstup *pwm_out* se nastaví na '0', jinak zůstává '1'. Tím vzniká signál s proměnlivou šířkou pulzu odpovídající požadovanému jasu LED. Vstup *rst* provádí reset čítače. Hodnota *C_END* určuje rozlišení PWM.

![image](https://github.com/user-attachments/assets/e55e5a58-f3e8-4b60-b080-04a394fde615)

<ins>**Seg_bcd_d**<ins>  

Komponenta *seg_bcd_d* převádí 4bitové binární číslo na odpovídající výstup pro sedmisegmentový displej (segments a–g). Vstup *bin* reprezentuje číslici 0–9, která je dekódována do sedmisegmentového výstupu *seg*. Pokud je aktivní signál *clear*, všechny segmenty se vypnou (*seg <= "1111111"*). Tím je možné jednotlivé číslice na displeji jednoduše zobrazovat nebo mazat.

![image](https://github.com/user-attachments/assets/893d600c-1da9-404e-8757-2ede3ee9e6b6)

<ins>**Bin2bcd**<ins>

Komponenta *bin2bcd* převádí 8bitové binární číslo *BIN* na tři čtyřbitové BCD výstupy *BCD_1*, *BCD_10* a BCD_100*, které reprezentují jednotky, desítky a stovky. Převod probíhá při každé náběžné hraně hodinového signálu *CLK*, pokud není aktivní reset *RST*. V případě resetu se výstupy vynulují. Tento převod je nezbytný pro správné zobrazení čísel na sedmisegmentových displejích, protože každý displej přijímá hodnoty ve formátu BCD (Binary Coded Decimal).

![image](https://github.com/user-attachments/assets/94b8e407-5999-44fb-be5d-33b7c0ba2fa6)

## Instrukce

Krok 1:
Připojte napájení a ověřte správné zapojení všech komponent. LED diody zapojte pouze na breadboard, aby bylo možné lépe pozorovat rozdíly v jejich svítivosti. Breadboard je připojen k vývojové desce pomocí JA konektorů.



Krok 2:
Pomocí přepínače SW (v našem projektu slouží jako povolení ovládání jasu) aktivujte systém. Pokud není přepínač zapnutý, tlačítka nebudou mít žádný efekt.



Krok 3:
Stiskněte tlačítko BTNL pro snížení jasu LED. Tlačítko BTNR naopak jas zvýší. Jas je nastavitelný v rozsahu od 0 do 100 %.



Krok 4:
Stisknutím BTNC nastavíte jas LED na výchozí hodnotu (0 %).


 
Krok 5:
Aktuální hodnota jasu (0–100 %) je zobrazena na 7segmentovém displeji.



Krok 6:
Pokud stisknete současně tlačítka BTNL a BTNR, hodnota jasu se nezmění.



## Reference
1. [Online VHDL Testbench Template Generator](https://vhdl.lapinoo.net/)
2. [Nexys A7 Reference Manual](https://digilent.com/reference/programmable-logic/nexys-a7/reference-manual)
