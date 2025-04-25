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
Připojí se napájení a ověří se správné zapojení všech komponent. LED diody jsou připojeny pouze na breadboard, čímž je zajištěna lepší rozlišitelnost změn ve svítivosti. Breadboard je propojen s vývojovou deskou prostřednictvím JA konektorů.

![IMG_20250425_124051113_1](https://github.com/user-attachments/assets/f6c51059-0738-4ed6-b6ca-c460a8fbe37b)


Krok 2:
Pomocí přepínače SW0 nebo SW1 se aktivuje řízení konkrétní LED diody. SW0 slouží pro ovládání první LED, SW1 pro druhou. Pokud jsou aktivovány oba přepínače, ovládají se obě LED současně.

Krok 3:
Po aktivaci LED se na přidruženém tříciferném sedmisegmentovém displeji zobrazí aktuální hodnota jasu ve formátu procent (50 %). Tlačítky BTNL a BTNR se hodnota jasu upravuje – BTNL snižuje jas, zatímco BTNR jej zvyšuje. Pokud jsou stisknuta obě tlačítka současně, nedojde ke změně hodnoty. Jas je nastavitelný v rozsahu od 1 % do 100 %.

![IMG_20250425_124226401_1](https://github.com/user-attachments/assets/ff214bde-f9bd-4b08-a304-632ac9aa8828)
*Snížení jasu levé diody na minimum a zvýšení jasu pravé diody na maximum*

![IMG_20250425_124216722_1](https://github.com/user-attachments/assets/31320315-87cd-42c4-8d92-40eae1f741aa)
*Snížení jasu pravé diody na 50 %*

![IMG_20250425_124356216_1](https://github.com/user-attachments/assets/30ceed31-e8a2-4005-af00-eed59df99df7)


Krok 4:
Tlačítko BTNC slouží k vynulování jasu – provede reset systému. Po jeho stisku se hodnota jasu vrátí na výchozí hodnotu 50 %.

![IMG_20250425_124051113_1](https://github.com/user-attachments/assets/453c2c30-7a5e-4167-81fd-057b39b8fcf2)

Krok 5:
Tlačítkem BTND lze celý systém deaktivovat – displej zhasne a připojené LED začnou svítit na maximální intenzitu bez možnosti úpravy jasu.

![IMG_20250425_124340133](https://github.com/user-attachments/assets/a3ffe822-9926-458e-8e1d-df2640c04253)


## Reference
1. [Online VHDL Testbench Template Generator](https://vhdl.lapinoo.net/)
2. [Nexys A7 Reference Manual](https://digilent.com/reference/programmable-logic/nexys-a7/reference-manual)
