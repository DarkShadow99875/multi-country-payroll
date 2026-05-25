# Multi-Country Payroll Simulator

**Enterprise-grade international payroll management system** built with Elixir + Phoenix + LiveView.

A production-ready simulation showcasing advanced features for global HR and payroll operations.

## Key Features

### Core Functionality
- **Multi-Country Payroll Engine** — Realistic tax and contribution calculations for 10+ countries
- **Advanced HR Dashboard** — Powerful filters (search, country, employment type, status)
- **Full CRUD Operations** — Complete employee management (admin + self-service)
- **Employee Self-Service Portal** — Employees can view and update their personal information
- **PDF Payslip Generation** — Professional payslip export

### Enterprise Features
- **Background Jobs (Oban)** — Asynchronous payroll processing and notifications
- **Audit Logging** — Complete action history for compliance
- **Role-Based Access Control** — Mock Active Directory integration with role management
- **Analytics Dashboard** — Real-time metrics and country distribution
- **Real-time Updates** — Phoenix PubSub powered live updates

### Technical Highlights
- Clean architecture with Contexts
- Progressive tax calculation engine
- Modern LiveView UI
- Enterprise-ready dependencies (bcrypt, Oban, Contex)

## Supported Countries

| Country | Tax Rate | Social Security | Employer Contribution |
|---------|----------|-----------------|-----------------------|
| Italy | 23% | 9.19% | 30% |
| United States | 22% | 6.2% | 7.65% |
| Germany | 25% | 18.6% | 20% |
| Netherlands | 37% | - | - |
| Spain | 19% | 6.35% | 30% |
| France | 30% | 22% | 42% |
| United Kingdom | 20% | 12% | 13.8% |
| Canada | 25% | 4.95% | - |
| Australia | 30% | - | - |
| Brazil | 27.5% | 7.5% | 20% |

## Getting Started

```bash
git clone https://github.com/DarkShadow99875/multi-country-payroll.git
cd multi-country-payroll

mix deps.get
mix ecto.create
mix ecto.migrate
mix run priv/repo/seeds.exs
mix phx.server
```

Open http://localhost:4000

**Demo Credentials:**
- Admin: `admin@acme.it` / `password123`
- Employee: `marco.rossi@acme.it` / `password123`

## Project Structure

```
lib/
├── multi_country_payroll/
│   ├── accounts/           # Authentication & RBAC
│   ├── companies/
│   ├── employees/
│   ├── payroll/            # Advanced calculation engine
│   ├── jobs/               # Oban background jobs
│   └── audit/
└── multi_country_payroll_web/
    └── live/
        ├── dashboard_live.ex     # Advanced filters + CRUD
        ├── employee_portal_live.ex
        ├── analytics_live.ex     # Metrics dashboard
        ├── login_live.ex
        └── role_management_live.ex
```

## Why This Project Stands Out

- **Production-Ready Architecture** — Clean separation of concerns
- **Real Enterprise Features** — Background processing, audit trails, RBAC
- **Global Scale Ready** — Multi-country logic with realistic tax rules
- **Modern Tech Stack** — Elixir 1.18 + Phoenix 1.7 + LiveView + Oban

Built as a demonstration of advanced Elixir/Phoenix capabilities for global payroll systems.

## License

MIT