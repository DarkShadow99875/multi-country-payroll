# Multi-Country Payroll Simulator

Un simulatore completo di payroll internazionale costruito in Elixir.

## Obiettivo

Questo progetto simula il calcolo delle paghe per dipendenti in diversi paesi, gestendo regole fiscali, contributi previdenziali e costi aziendali in modo realistico.

È stato creato per esplorare come gestire la complessità di un sistema di payroll globale usando Elixir e Phoenix.

## Funzionalità

- **Multi-tenancy**: Ogni azienda è gestita separatamente
- **Supporto multi-paese**: Italia, USA, Germania, Olanda, Spagna, Francia
- **Calcolo automatico delle paghe**: Lordo, tasse, contributi, netto e costo totale per l'azienda
- **Interfaccia LiveView**: Dashboard interattiva in tempo reale
- **Aggiunta dipendenti**: Form completo per inserire nuovi dipendenti

## Paesi supportati

| Paese | Tasse | Contributi Sociali | Contributo Datore |
|-------|-------|--------------------|-------------------|
| Italia | 23% | 9.19% | 30% |
| USA | 22% | 6.2% | 7.65% |
| Germania | 25% | 18.6% | 20% |
| Olanda | 37% | - | - |

## Come avviare il progetto

```bash
git clone https://github.com/DarkShadow99875/multi-country-payroll.git
cd multi-country-payroll

mix deps.get
mix ecto.create
mix ecto.migrate
mix run priv/repo/seeds.exs
mix phx.server
```

Apri http://localhost:4000

## Struttura del progetto

```
lib/
├── multi_country_payroll/
│   ├── companies/
│   ├── employees/
│   └── payroll.ex          # Motore di calcolo
└── multi_country_payroll_web/
    └── live/
        ├── dashboard_live.ex
        └── employee_form_live.ex
```

## Prossimi sviluppi possibili

- Aggiungere più paesi
- Generazione automatica di documenti fiscali
- Integrazione con API esterne per tassi di cambio
- Sistema di audit completo

Costruito con Elixir 1.18 + Phoenix 1.7 + LiveView.