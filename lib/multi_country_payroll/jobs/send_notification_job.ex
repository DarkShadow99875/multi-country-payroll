defmodule MultiCountryPayroll.Jobs.SendNotificationJob do
  use Oban.Worker, queue: :notifications, max_attempts: 3

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"user_id" => user_id, "message" => message}}) do
    IO.puts("[Oban] Notifica inviata a utente #{user_id}: #{message}")
    :ok
  end
end
