# Multi-Country Payroll Simulator - Documentation

## Overview

Enterprise-grade international payroll management system built with Elixir 1.18 + Phoenix 1.7 + LiveView.

This project demonstrates advanced capabilities for global HR and payroll operations, ideal for companies like Remote.com, Deel, or any organization managing international teams.

## Key Features

- **Multi-Country Payroll Engine** (10 countries with realistic tax rules)
- **Advanced HR Dashboard** with powerful filters
- **Full CRUD** (Admin + Employee Self-Service)
- **Background Jobs (Oban)** for async processing
- **Audit Logging** and **Role-Based Access Control** (Mock AD)
- **Analytics Dashboard** with key metrics
- **PDF Payslip Export**

## Setup

```bash
git clone https://github.com/DarkShadow99875/multi-country-payroll.git
cd multi-country-payroll

mix deps.get
mix ecto.create
mix ecto.migrate
mix run priv/repo/seeds.exs
mix phx.server
```

## Demo Credentials

- Admin: admin@acme.it / password123
- Employee: marco.rossi@acme.it / password123

## Architecture

- Clean Context-based design
- Oban for background jobs
- LiveView for real-time UI
- Progressive tax calculation engine

## Extending

- Add new countries in `payroll.ex`
- Create new Oban jobs in `jobs/`
- Extend analytics in `analytics_live.ex`

## Production Ready

- bcrypt for password hashing
- Oban for reliable background processing
- Audit trails for compliance

Built as a showcase of modern Elixir/Phoenix capabilities for global payroll systems.