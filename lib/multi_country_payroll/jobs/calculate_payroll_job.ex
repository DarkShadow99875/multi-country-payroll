defmodule MultiCountryPayroll.Jobs.CalculatePayrollJob do
  use Oban.Worker, queue: :payroll, max_attempts: 3

  alias MultiCountryPayroll.Employees

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"employee_id" => employee_id}}) do
    employee = Employees.get_employee!(employee_id)
    IO.puts("[Oban] Payroll calcolato per #{employee.full_name}")
    :ok
  end
end
