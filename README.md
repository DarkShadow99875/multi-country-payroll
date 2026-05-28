# MultiCountryPayroll

**Enterprise-grade international payroll management system** built with Elixir + Phoenix + LiveView.

**Created by DarkShadow99875 (2026)**

A complete, production-ready simulation showcasing advanced features for global HR and payroll operations.

## Key Features

### Core Functionality
- **Multi-Country Payroll Engine** — Realistic tax and contribution calculations for 10+ countries
- **Advanced HR Dashboard** — Powerful filters (search, country, employment type, status)
- **Full CRUD Operations** — Complete employee management (admin + self-service)
- **Employee Self-Service Portal** — Employees can view and update their personal information
- **PDF Payslip Generation** — Professional payslip export

### Enterprise Features
- **Multi-Factor Authentication (MFA)** — Microsoft Authenticator (TOTP) + Email OTP with method selection
- **Background Jobs (Oban)** — Asynchronous payroll processing and notifications
- **Audit Logging** — Complete action history for compliance
- **Role-Based Access Control** — Mock Active Directory integration
- **Analytics Dashboard** — Real-time metrics and country distribution

## Tech Stack

- Elixir 1.18 + Phoenix 1.7 + LiveView
- Ecto + PostgreSQL (production) / SQLite (tests)
- Tailwind CSS + Heroicons
- NimbleTOTP for Microsoft Authenticator
- ChromicPDF for PDF generation
- Oban for background jobs

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
│   ├── accounts/           # Authentication & MFA
│   ├── companies/
│   ├── employees/
│   ├── payroll/            # Advanced calculation engine
│   ├── jobs/               # Oban background jobs
│   └── audit/
└── multi_country_payroll_web/
    └── live/
        ├── dashboard_live.ex     # Advanced filters + CRUD + PDF
        ├── employee_portal_live.ex
        ├── analytics_live.ex
        └── login_live.ex         # MFA with Microsoft Authenticator
```

## Why This Project Stands Out

- **Complete MFA System** — Microsoft Authenticator + Email OTP with user choice
- **Production-Ready Architecture** — Clean separation of concerns
- **Global Scale Ready** — Multi-country logic with realistic tax rules
- **Modern Tech Stack** — Elixir 1.18 + Phoenix 1.7 + LiveView + Oban


## License

MIT
