Mix.install([
  {:broadway, "~> 1.0"},
  {:broadway_rabbitmq, "~> 0.7"}
], force: true)

defmodule Consumer do
  use Broadway

  def start_link(opts) do
    queue = Keyword.fetch!(opts, :queue)
    IO.inspect("Starting consumer #{queue}")

    Broadway.start_link(__MODULE__,
      name: Module.concat(__MODULE__, String.to_atom("Queue#{queue}")),
      context: %{queue: queue},
      producer: [
        module: {BroadwayRabbitMQ.Producer,
          queue: queue,
          qos: [prefetch_count: 50],
          on_failure: :reject
        },
        concurrency: 1
      ],
      processors: [
        default: [
          concurrency: 1,
          min_demand: 5
        ]
      ],
    )
  end

  def handle_message(_, message, context) do
    IO.inspect(message, label: context.queue)
    message
  end
end

for queue_number <- 0..3 do
  {:ok, _pid} = Consumer.start_link(queue: "test_super_stream-#{queue_number}")
end

{:ok, _pid} = Consumer.start_link(queue: "test_stream")
