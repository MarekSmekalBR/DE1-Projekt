# **DE1-Projekt**
## **Členové**
Jan Veverka: Zodpovědný za programování 
  
Vojtěch Vičar: Zodpovědný za programování 
  
Marek Smékal: Zodpovědný za vytváření README souboru a pomoc s programováním 
  
Matěj Rýdel: Zodpovědný za vytváření README souboru a pomoc s programováním

## Teoretický úvod
Náš projekt je zaměřen na návrh a implementaci PWM (Pulse Width Modulation) v jazyce VHDL na vývojové desce Nexys A7-50T. Cílem je řízení jasu dvou LED diod pomocí PWM. Uživatel vybírá, která LED má být ovládána, prostřednictvím dvou přepínačů: první přepínač slouží pro ovládání první LED, druhý pro druhou LED. Jas LED je nastavován pomocí dvou tlačítek – jedno slouží ke zvýšení intenzity a druhé k jejímu snížení.

Pro každou LED je vyhrazen samostatný tříciferný sedmisegmentový displej, který zobrazuje aktuální hodnotu nastaveného jasu ve formátu procent. Systém umožňuje plynulé a přehledné řízení intenzity světla a zároveň demonstruje praktické využití FPGA a jazyka VHDL pro tvorbu konfigurovatelných digitálních systémů. 

## Princip PWM modulace
PWM, neboli pulsně šířková modulace, je metoda řízení analogové veličiny pomocí digitálního signálu. Spočívá v tom, že se výstupní signál přepíná mezi logickou nulou a jedničkou s určitou frekvencí. Výsledný průměrný výkon, a tím i jas LED, je dán tzv. pracovním cyklem (duty cycle) – tedy poměrem doby, po kterou je signál v logické jedničce, k celkové periodě.

Například při 50% pracovním cyklu je signál polovinu času v logické jedničce a polovinu v nule. LED tedy svítí na 50 % svého maximálního jasu. Při 100 % svítí naplno, při 1 % je téměř zhasnutá.

## Popis hardwaru a demo aplikace
Projekt je implementován na vývojové desce Nexys A7-50T od firmy Digilent, která obsahuje FPGA čip Xilinx Artix-7. Deska nabízí různé vstupně-výstupní prvky, které byly v rámci projektu využity pro realizaci ovládání LED diod a vizualizaci dat.

<ins>Využité hardwarové prvky:<ins>

LED0 a LED1 – výstupní LED diody řízené pomocí PWM

SW0 a SW1 – přepínače pro výběr kanálu (LED0, LED1)

BTNL (Button Left) a BTNR (Button Right) – tlačítka pro nastavování jasu (snížení / zvýšení)

BTNC (Center Button) – slouží jako reset celého systému, vrací hodnoty duty cycle obou LED na výchozí hodnotu (50 %)

6-místný sedmisegmentový displej – zobrazení aktuálního jasu vybrané LED v procentech, rozděleno po třech místech pro každou LED

Breadboard se samotnými LED a rezistory

![image](https://github.com/user-attachments/assets/1fa2566f-5888-4dca-b762-d699d41f3add)

*Zobrazení pinů na desce Nexys*

## Popis softwaru
Projekt byl vytvořen v prostředí Vivado v jazyce VHDL. Návrh je rozdělen do několika modulárních komponent, které spolu komunikují prostřednictvím signálů.

<ins>Hlavní moduly:<ins>

Top-level entita – propojuje všechny komponenty, určuje směr a logiku signálů

Clock Divider – převádí 100 MHz vstupní hodiny na pomalejší frekvenci vhodnou pro čítání a generování PWM

PWM Generátor – generátor vytváří signál s nastavitelným pracovním cyklem, který určuje jas LED

Řízení vstupů – zpracovává stavy přepínačů a tlačítek, určuje aktivní kanál a aktualizuje hodnotu duty cycle

### Zapojení

### Top Level

### Simulace komponentů
<ins>**Generátor hodinového impulzu s volitelným poměrem**<ins>  

Tato komponenta generuje impulz na základě příchozího hodinového signálu. Pomocí vstupu switch lze volit mezi dvěma frekvencemi. Pokud je switch = 0, výstupní impulzy mají základní periodu (PERIOD). Pokud je switch = 1, perioda se násobí hodnotou RATIO, tedy výstupní impulzy jsou méně časté. nterní čítač počítá až do dané hodnoty (buď PERIOD nebo PERIOD * RATIO) a po přetečení vygeneruje jeden krátký impuls (pulse = '1').



<ins>**Generátor hodinového impulzu**<ins>

Tato komponenta slouží k vytváření impulzů na základě hlavního hodinového signálu (clk). Pomocí generického parametru PERIOD se nastavuje, kolik taktů hlavního hodinového signálu je potřeba pro vytvoření jednoho výstupního impulzu (pulse). Po dosažení této hodnoty se vygeneruje jeden krátký impulz (pulse = '1') a čítač se vynuluje. Komponenta slouží jako jednoduchý časovač nebo dělič frekvence, kdy můžeme např. z 100 MHz hodinového signálu vytvořit mnohem pomalejší řídicí impulzy pro jiné části systému.




<ins>**Clock Enable**<ins>

Tato komponenta vytváří periodické impulzy na výstupu pulse podle hodnoty zadané parametrem PERIOD. Čítač uvnitř komponenty počítá jednotlivé taktovací cykly signálu clk. Po dosažení hodnoty PERIOD - 1 se vygeneruje jeden krátký impulz a čítač se vynuluje. Signál rst slouží k resetování komponenty do výchozího stavu. Komponenta se používá pro zpomalení hodinového signálu nebo pro řízení operací, které se nemají provádět při každém taktu.




<ins>**Segmentový kontrolér**<ins>

Tato komponenta slouží k multiplexnímu řízení osmimístného sedmisegmentového displeje. Pomocí interního registru sig_an dochází k postupnému přepínání jednotlivých anod tak, aby se jednotlivé segmenty na všech osmi pozicích zdály svítit současně. Přepínání je řízeno taktovacím signálem CLK a je aktivní pouze při zapnutém vstupu EN. Výstupy CA až CG určují, které segmenty jsou v daném okamžiku aktivní, a jsou přiřazovány podle toho, která anoda je aktuálně aktivní. Výstup DP (desetinná tečka) je trvale vypnut. Signál RST zajišťuje návrat do výchozího stavu – aktivní první anoda. Komponenta zajišťuje efektivní zobrazení více číslic při použití jediného sady výstupních signálů.




<ins>**Regulátor jasu**<ins>

Tato komponenta slouží k řízení úrovně jasu LED diod. Výstupní signál lum udává hodnotu intenzity v rozsahu 1 až 100, přičemž výchozí hodnota po resetu je nastavena na 50. Pomocí vstupů up a down lze tuto hodnotu zvyšovat nebo snižovat. Změny jsou prováděny pouze v případě, že komponenta je aktivována (comp_en = '1') a zároveň povolena (en = '1'). Zajištěna je ochrana proti současnému stisknutí obou tlačítek (up i down) a také proti překročení hranic rozsahu. Hodnota jasu je aktualizována při každém náběžné hraně hodinového signálu clk.




<ins>****<ins>

## Instrukce

Krok 1:
Připojí se napájení a ověří se správné zapojení všech komponent. Diody jsou připojeny na breadboard, čímž je zajištěna lepší rozlišitelnost změn ve svítivosti oproti desce Nexys. Breadboard je propojen s vývojovou deskou prostřednictvím JA konektorů.

![IMG_20250425_124051113_1](https://github.com/user-attachments/assets/f6c51059-0738-4ed6-b6ca-c460a8fbe37b)

Krok 2:
Pomocí přepínače SW0 nebo SW1 se aktivuje řízení konkrétní diody. SW0 slouží pro ovládání první LED, SW1 pro druhou. Pokud jsou aktivovány oba přepínače, ovládají se obě LED současně.

Krok 3:
Po aktivaci LED se na přidruženém tříciferném sedmisegmentovém displeji zobrazí aktuální hodnota jasu ve formátu procent. Tlačítky BTNL a BTNR se hodnota jasu upravuje – BTNL snižuje jas, zatímco BTNR jej zvyšuje. Pokud jsou stisknuta obě tlačítka současně, nedojde ke změně hodnoty. Jas je nastavitelný v rozsahu od 1 % do 100 %.

![IMG_20250425_124226401_1](https://github.com/user-attachments/assets/ff214bde-f9bd-4b08-a304-632ac9aa8828)
*Ovládání pravé diody - zvýšení jasu na maximum*

![IMG_20250425_124216722_1](https://github.com/user-attachments/assets/31320315-87cd-42c4-8d92-40eae1f741aa)
*Ovládání levé diody - snížení jasu na minimum*

![IMG_20250425_124356216_1](https://github.com/user-attachments/assets/30ceed31-e8a2-4005-af00-eed59df99df7)
*Stistknutí obou tlačítek současně - jas se nijak nezmění*

Krok 4:
Tlačítko BTNC slouží k resetování jasu. Po jeho stisku se hodnota jasu vrátí na výchozí hodnotu 50 %.

![IMG_20250425_124051113_1](https://github.com/user-attachments/assets/453c2c30-7a5e-4167-81fd-057b39b8fcf2)

Krok 5:
Tlačítkem BTND lze celý systém deaktivovat – displej zhasne a připojené LED začnou svítit na maximální intenzitu bez možnosti úpravy jasu.

![IMG_20250425_124340133](https://github.com/user-attachments/assets/a3ffe822-9926-458e-8e1d-df2640c04253)


## Reference
1. [Online VHDL Testbench Template Generator](https://vhdl.lapinoo.net/)
2. [Nexys A7 Reference Manual](https://digilent.com/reference/programmable-logic/nexys-a7/reference-manual)
