# **DE1-Projekt**
## **Členové**
Jan Veverka: Zodpovědný za programování 
  
Vojtěch Vičar: Zodpovědný za programování 
  
Marek Smékal: Zodpovědný za vytváření README souboru a pomoc s programováním 
  
Matěj Rýdel: Zodpovědný za vytváření README souboru a pomoc s programováním

## Teoretický úvod
Náš projekt je zaměřen na návrh a implementaci PWM (Pulse Width Modulation) v jazyce VHDL na vývojové desce Nexys A7-50T. Cílem je řízení jasu dvou LED diod pomocí nezávislých PWM kanálů. Uživatel vybírá, která LED má být ovládána, prostřednictvím tří přepínačů: první přepínač slouží pro ovládání první LED, druhý pro druhou LED a třetí pro současné řízení obou. Jas LED je nastavován pomocí dvou tlačítek – jedno slouží ke zvýšení intenzity o 10 %, druhé k jejímu snížení.

Pro každou LED je vyhrazen samostatný tříciferný sedmisegmentový displej, který zobrazuje aktuální hodnotu nastaveného jasu ve formátu procent. Systém umožňuje plynulé a přehledné řízení intenzity světla a zároveň demonstruje praktické využití FPGA a jazyka VHDL pro tvorbu konfigurovatelných digitálních systémů. 

## Princip PWM modulace
PWM, neboli pulsně šířková modulace, je metoda řízení analogové veličiny pomocí digitálního signálu. Spočívá v tom, že se výstupní signál přepíná mezi logickou nulou a jedničkou s určitou frekvencí. Výsledný průměrný výkon, a tím i jas LED, je dán tzv. pracovním cyklem (duty cycle) – tedy poměrem doby, po kterou je signál v logické jedničce, k celkové periodě.

Například při 50% pracovním cyklu je signál polovinu času v logické jedničce a polovinu v nule. LED tedy svítí na 50 % svého maximálního jasu. Při 100 % svítí naplno, při 0 % je zcela zhasnutá.

## Popis hardwaru a demo aplikace
Projekt je implementován na vývojové desce Nexys A7-50T od firmy Digilent, která obsahuje FPGA čip Xilinx Artix-7. Deska nabízí různé vstupně-výstupní prvky, které byly v rámci projektu využity pro realizaci ovládání LED diod a vizualizaci dat.

Využité hardwarové prvky:

LED0 a LED1 – výstupní LED diody řízené pomocí PWM

SW0–SW2 – přepínače pro výběr kanálu (LED0, LED1, obě zároveň)

BTNL (Left) a BTNR (Right) – tlačítka pro nastavování jasu po 10 % (snížení / zvýšení)

BTNC (Center Button) – slouží jako reset celého systému, vrací hodnoty duty cycle obou LED na výchozí hodnotu (např. 0 %)

6-místný sedmisegmentový displej – zobrazení aktuálního jasu vybrané LED v procentech, rozděleno po třech místech pro každou LED

Další využité prostředky:

Interní 100 MHz hodinový signál – zdroj hodin pro systém

Dělička hodin (clock divider) – pro zpomalení signálu na vhodnou frekvenci pro PWM a logiku řízení

## Popis softwaru
Projekt byl vytvořen v prostředí Vivado v jazyce VHDL. Návrh je rozdělen do několika modulárních komponent, které spolu komunikují prostřednictvím signálů.

Hlavní moduly:

Clock Divider – převádí 100 MHz vstupní hodiny na pomalejší frekvenci vhodnou pro čítání a generování PWM

PWM Generátor (2x) – každý generátor vytváří signál s nastavitelným pracovním cyklem, který určuje jas LED

Řízení vstupů (Input Control) – zpracovává stavy přepínačů a tlačítek, určuje aktivní kanál a aktualizuje hodnotu duty cycle

Segmentový displej (7-Segment Display Driver) – zobrazuje hodnoty duty cycle ve formátu procent

Top-level entita – propojuje všechny komponenty, určuje směr a logiku signálů

### Zapojení

### Top Level

### Simulace komponentů

## Instrukce

## Reference
1. [Online VHDL Testbench Template Generator](https://vhdl.lapinoo.net/)

