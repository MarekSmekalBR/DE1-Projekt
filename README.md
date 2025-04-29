# **DE1-Projekt**
## **Členové**
Jan Veverka: Zodpovědný za programování 
  
Vojtěch Vičar: Zodpovědný za programování 
  
Marek Smékal: Zodpovědný za vytváření README souboru a pomoc s programováním 
  
Matěj Rýdel: Zodpovědný za vytváření README souboru a pomoc s programováním

## Teoretický úvod
Náš projekt je zaměřen na návrh a implementaci PWM (Pulse Width Modulation) v jazyce VHDL na vývojové desce Nexys A7-50T. Cílem je řízení jasu dvou LED pomocí PWM. Uživatel vybírá, která LED má být ovládána, prostřednictvím dvou přepínačů: první přepínač slouží pro ovládání první LED, druhý pro druhou LED. Lze ovládat i obě LED současně. Jas LED je nastavován pomocí dvou tlačítek – jedno slouží ke zvýšení intenzity a druhé k jejímu snížení. 

Pro každou LED je vyhrazen samostatný tříciferný sedmisegmentový displej, který zobrazuje aktuální hodnotu nastaveného jasu ve formátu procent. Systém umožňuje plynulé a přehledné řízení intenzity světla a zároveň demonstruje praktické využití FPGA a jazyka VHDL pro tvorbu konfigurovatelných digitálních systémů. 

## Princip PWM modulace
PWM, neboli pulsně šířková modulace, je metoda řízení analogové veličiny pomocí digitálního signálu. Spočívá v tom, že se výstupní signál přepíná mezi logickou nulou a jedničkou s určitou frekvencí. Výsledný průměrný výkon, a tím i jas LED, je dán tzv. pracovním cyklem (duty cycle) – tedy poměrem doby, po kterou je signál v logické jedničce, k celkové periodě.

Například při 50% pracovním cyklu je signál polovinu času v logické jedničce a polovinu v nule. LED tedy svítí na 50 % svého maximálního jasu. Při 100 % svítí naplno, při 1 % je téměř zhasnutá.

## Popis hardwaru a demo aplikace
Projekt je implementován na vývojové desce Nexys A7-50T od firmy Digilent, která obsahuje FPGA čip Xilinx Artix-7. Deska nabízí různé vstupně-výstupní prvky, které byly v rámci projektu využity pro realizaci ovládání LED diod a vizualizaci dat.

<ins>Využité hardwarové prvky:<ins>

Výstupní LED - diody řízené pomocí PWM

SW0 a SW1 – přepínače pro výběr kanálu

BTNL (Button Left) a BTNR (Button Right) – tlačítka pro nastavování jasu (snížení / zvýšení)

BTNC (Center Button) – slouží jako reset celého systému, vrací hodnoty duty cycle aktivních LED na výchozí hodnotu (50 %)

BTND (Button Down) - slouží pro deaktivaci systému 

6-místný sedmisegmentový displej – zobrazení aktuálního jasu vybrané LED v procentech, rozděleno po třech místech pro každou LED

Breadboard se samotnými LED a rezistory

![image](https://github.com/user-attachments/assets/1fa2566f-5888-4dca-b762-d699d41f3add)

*Zobrazení pinů na desce Nexys*

## Popis softwaru
Projekt byl vytvořen v prostředí Vivado v jazyce VHDL. Návrh je rozdělen do několika modulárních komponent, které spolu komunikují prostřednictvím signálů.

<ins>Hlavní moduly:<ins>

Top-level entita – propojuje všechny komponenty, určuje směr a logiku signálů

Clock Divider – převádí 100 MHz vstupní hodiny na pomalejší frekvenci vhodnou pro čítání a generování PWM

Luminosity - slouží k řízení intenzity jasu LED v rozsahu 1 % až 100 %

PWM Generátor – generátor vytváří signál s nastavitelným pracovním cyklem, který určuje jas LED

Řízení vstupů – zpracovává stavy přepínačů a tlačítek, určuje aktivní kanál a aktualizuje hodnotu duty cycle

### Zapojení

![Schéma](https://github.com/user-attachments/assets/d1574ec6-31e8-4aae-bc06-2e8b394e8f85)


### Simulace komponentů
<ins>**Generátor pulzů s volitelným poměrem**<ins>  

Tato komponenta generuje výstupní pulz s nastavitelnou periodou podle vstupního hodinového signálu. Pomocí vstupu *switch* lze zvolit mezi základní periodou *PERIOD* a prodlouženou periodou *PERIOD * RATIO*. Vnitřní čítač počítá hodiny a při dosažení zvoleného limitu vygeneruje krátký pulz. Při aktivním resetu se čítač i výstupní pulz vynulují.



<ins>**Nastavení intenzity**<ins>

Tato komponenta slouží k řízení intenzity (např. jasu LED) v rozsahu 1 až 100. Při aktivaci vstupu *up* se hodnota zvyšuje, při *down* snižuje. Výchozí hodnota je 50. Komponenta reaguje pouze při aktivním *comp_en* a *clk* náběžné hraně. Při resetu (*rst*) se hodnota vrací na 50. Výsledná intenzita je dostupná na výstupu *lum*.




<ins>**Generátor PWM signálu**<ins>

Tato komponenta vytváří PWM signál na základě vstupní hodnoty *POS*, která určuje šířku pulzu. Interní čítač počítá do hodnoty *C_END*, po jejímž dosažení se vynuluje a PWM signál se nastaví zpět na '1'. Jakmile čítač dosáhne hodnoty *POS*, výstupní signál se přepne na '0'. Komponenta se aktivuje pomocí vstupu *en* a lze ji resetovat signálem *rst*. Výstupní signál *pwm_out* poskytuje výsledný PWM výstup.



<ins>**Převodník binárního čísla na BCD**<ins>

Tato komponenta převádí 8bitové binární číslo na BCD formát (stovky, desítky a jednotky). Převod probíhá pomocí posuvného algoritmu s korekcí hodnot (tzv. "double dabble"). Vnitřní stavový automat prochází stavy *start*, *shift*, *check* a *done*, kde se postupně zpracovává vstupní číslo. Převod začíná při změně vstupu *BIN* a aktivním hodinovém signálu *CLK*. Výsledné číslo je na výstupech *BCD1*, *BCD10* a *BCD100*. Při resetu (*RST*) se stav i výstupy vynulují.



<ins>**Ovladač 7-segmentových displejů**<ins>

Tato komponenta slouží k řízení šesti 7-segmentových displejů pomocí multiplexování. V každém taktu hodinového signálu aktivuje postupně jednu anodu (*AN*) a připojí k ní odpovídající segmentové hodnoty (*CA* až *CG*). Vstupní signály *SEGM1* až *SEGM8* obsahují segmentové kódy pro jednotlivé pozice. Při resetu se aktivuje první displej, a pokud je komponenta povolena (*EN*), rotuje aktivní anoda. Desetinná tečka (*DP*) je trvale vypnuta.




<ins>**Řízení jasu pomocí PWM a 7-segmentového displeje**<ins>

Tato komponenta integruje několik podkomponent pro řízení jasu LED pomocí PWM signálu a zobrazení procentuálního jasu na 7-segmentovém displeji. Hlavními součástmi jsou:

*luminosity* – Tato komponenta řídí změny hodnoty jasu na základě vstupních tlačítek pro zvýšení a snížení hodnoty, a také pro resetování do střední hodnoty.

*PWM_LED* – Generuje PWM signál, který řídí výkon LED diody na základě hodnoty jasu.

*bin2bcd* – Převádí binární hodnotu jasu do formátu BCD pro zobrazení na displeji.

*bin2seg* – Zobrazuje hodnoty BCD na 7-segmentovém displeji.

Komponenta přijímá různé vstupy pro ovládání a reset, a na výstupu poskytuje PWM signál pro LED a BCD hodnoty pro zobrazení na 7-segmentových displejích (pro jednotky, desítky a stovky).



## Instrukce

Krok 1:
Připojí se napájení desky a ověří se správné zapojení všech komponent. Diody jsou připojeny na breadboard, čímž je zajištěna lepší rozlišitelnost změn ve svítivosti oproti desce Nexys. Breadboard je propojen s vývojovou deskou prostřednictvím JA konektorů.

![Snímek obrazovky 2025-04-25 211140](https://github.com/user-attachments/assets/7ce09b4b-5083-42cf-a377-e2d0f5eb9e88)

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
Tlačítko BTNC slouží k resetování jasu. Po jeho stisku se hodnota jasu aktivních diod vrátí na výchozí hodnotu, tedy 50 %.

![IMG_20250425_124051113_1](https://github.com/user-attachments/assets/453c2c30-7a5e-4167-81fd-057b39b8fcf2)

Krok 5:
Tlačítkem BTND lze celý systém deaktivovat – displej zhasne a připojené LED začnou svítit na maximální intenzitu bez možnosti úpravy jasu.

![IMG_20250425_124340133](https://github.com/user-attachments/assets/a3ffe822-9926-458e-8e1d-df2640c04253)


## Reference
1. [Online VHDL Testbench Template Generator](https://vhdl.lapinoo.net/)
2. [Nexys A7 Reference Manual](https://digilent.com/reference/programmable-logic/nexys-a7/reference-manual)
3. [Basic writing and formating](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax)
