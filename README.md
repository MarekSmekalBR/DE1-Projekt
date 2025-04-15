# DE1-Projekt
Jan Veverka zodpovědný za programování 
  
Vojtěch Vičar zodpovědný za programování 
  
Marek Smékal zodpovědný za vytváření README souboru a pomoc s programováním 
  
Matěj Rýdel zodpovědný za vytváření README souboru a pomoc s programováním

## Teoretický úvod
Náš projekt je zaměřen na návrh a implementaci PWM (Pulse Width Modulation) v jazyce VHDL na vývojové desce Nexys A7-50T. Cílem je řízení jasu dvou LED diod pomocí nezávislých PWM kanálů. Uživatel vybírá, která LED má být ovládána, prostřednictvím tří přepínačů: první přepínač slouží pro ovládání první LED, druhý pro druhou LED a třetí pro současné řízení obou. Jas LED je nastavován pomocí dvou tlačítek – jedno slouží ke zvýšení intenzity o 10 %, druhé k jejímu snížení.

Pro každou LED je vyhrazen samostatný tříciferný sedmisegmentový displej, který zobrazuje aktuální hodnotu nastaveného jasu ve formátu procent. Systém umožňuje plynulé a přehledné řízení intenzity světla a zároveň demonstruje praktické využití FPGA a jazyka VHDL pro tvorbu konfigurovatelných digitálních systémů. 

## Princip PWM modulace
PWM, neboli pulsně šířková modulace, je metoda řízení analogové veličiny pomocí digitálního signálu. Spočívá v tom, že se výstupní signál přepíná mezi logickou nulou a jedničkou s určitou frekvencí. Výsledný průměrný výkon, a tím i jas LED, je dán tzv. pracovním cyklem (duty cycle) – tedy poměrem doby, po kterou je signál v logické jedničce, k celkové periodě.

Například při 50% pracovním cyklu je signál polovinu času v logické jedničce a polovinu v nule. LED tedy svítí na 50 % svého maximálního jasu. Při 100 % svítí naplno, při 0 % je zcela zhasnutá.

Tato metoda je velmi efektivní, protože nezpůsobuje ztráty v podobě tepla jako klasické analogové řízení. Zároveň je vhodná pro digitální obvody, jako jsou FPGA, protože využívá pouze dvoustavové výstupy. V našem projektu je PWM generováno pomocí čítače, který porovnává svou hodnotu s nastaveným prahem – pokud je čítač menší než práh, výstup je v logické jedničce, jinak v nule. Tímto způsobem lze jednoduše řídit jas LED diod přesně a plynule.
## Popis hardwaru a demo aplikace

## Popis softwaru
### Zapojení

### Top Level

### Simulace komponentů

## Instrukce

## Reference
Online VHDL Testbench Template Generator: https://vhdl.lapinoo.net/
